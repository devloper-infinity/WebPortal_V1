/*
 * Global session-expiry warning for authenticated WebPortal pages.
 * The actual ASP.NET Session.Timeout value is returned by SessionKeepAlive.aspx.
 */
(function (window, document) {
    "use strict";

    if (window.__webPortalSessionHandlerLoaded) {
        return;
    }
    window.__webPortalSessionHandlerLoaded = true;

    var scriptElement = document.currentScript;
    var scriptUrl = scriptElement && scriptElement.src
        ? new URL(scriptElement.src, window.location.href)
        : new URL("Scripts/SessionHandler.js", window.location.href);
    var applicationRoot = new URL("../", scriptUrl);
    var keepAliveUrl = new URL("SessionKeepAlive.aspx", applicationRoot).toString();
    var loginUrl = new URL("Login.aspx", applicationRoot).toString();
    var logoutUrl = new URL("Logout.aspx", applicationRoot).toString();
    var storageKey = "webportal-session-deadline:" + applicationRoot.pathname.toLowerCase();

    var fallbackTimeoutSeconds = 20 * 60;
    var timeoutSeconds = fallbackTimeoutSeconds;
    var warningSeconds = 2 * 60;
    var heartbeatSeconds = 5 * 60;
    var deadline = Date.now() + (timeoutSeconds * 1000);
    var lastActivityAt = Date.now();
    var lastKeepAliveAt = Date.now();
    var warningVisible = false;
    var sessionExpired = false;
    var keepAliveInProgress = false;
    var keepAliveCallbacks = [];
    var tickTimer = null;
    var attentionTimer = null;
    var notification = null;
    var warningShownForDeadline = 0;
    var titleBeforeAttention = "";
    var iconStates = [];

    var warningIcon = "data:image/svg+xml," + encodeURIComponent(
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64">' +
        '<circle cx="32" cy="32" r="30" fill="#dc2626"/>' +
        '<rect x="29" y="13" width="6" height="28" rx="3" fill="white"/>' +
        '<circle cx="32" cy="50" r="4" fill="white"/>' +
        '</svg>'
    );
    var normalFallbackIcon = "data:image/svg+xml," + encodeURIComponent(
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64">' +
        '<circle cx="32" cy="32" r="30" fill="#1d4ed8"/>' +
        '<path d="M29 15h7v34h-7z" fill="white"/>' +
        '</svg>'
    );

    function byId(id) {
        return document.getElementById(id);
    }

    function formatTime(totalSeconds) {
        var seconds = Math.max(0, Math.ceil(totalSeconds));
        var minutesPart = Math.floor(seconds / 60);
        var secondsPart = seconds % 60;
        return (minutesPart < 10 ? "0" : "") + minutesPart + ":" +
            (secondsPart < 10 ? "0" : "") + secondsPart;
    }

    function isLoginResponseUrl(url) {
        var normalized = String(url || "").toLowerCase();
        return normalized.indexOf("/login.aspx") >= 0 || normalized.indexOf("/loginnew.aspx") >= 0;
    }

    function addQuery(url, name, value) {
        return url + (url.indexOf("?") >= 0 ? "&" : "?") +
            encodeURIComponent(name) + "=" + encodeURIComponent(value);
    }

    function broadcastDeadline() {
        try {
            window.localStorage.setItem(storageKey, JSON.stringify({
                deadline: deadline,
                updatedAt: Date.now()
            }));
        } catch (ignore) {
            // Storage can be disabled by browser privacy settings.
        }
    }

    function calculateTiming(serverTimeoutSeconds) {
        timeoutSeconds = Math.max(60, parseInt(serverTimeoutSeconds, 10) || fallbackTimeoutSeconds);
        warningSeconds = Math.min(120, Math.max(30, Math.floor(timeoutSeconds * 0.20)));
        warningSeconds = Math.min(warningSeconds, Math.max(10, timeoutSeconds - 10));
        heartbeatSeconds = Math.max(60, Math.min(300, Math.floor(timeoutSeconds / 3)));
    }

    function resetDeadline(serverTimeoutSeconds) {
        calculateTiming(serverTimeoutSeconds);
        deadline = Date.now() + (timeoutSeconds * 1000);
        lastKeepAliveAt = Date.now();
        warningShownForDeadline = 0;
        broadcastDeadline();
        hideWarning();
    }

    function ensureUi() {
        if (byId("wpsession-overlay")) {
            return;
        }

        var style = document.createElement("style");
        style.id = "wpsession-style";
        style.textContent =
            "#wpsession-overlay{position:fixed;inset:0;z-index:2147483000;display:none;align-items:center;justify-content:center;padding:22px;background:rgba(15,23,42,.62);backdrop-filter:blur(5px);font-family:'Segoe UI',Arial,sans-serif}" +
            "#wpsession-overlay.wpsession-open{display:flex}" +
            ".wpsession-card{width:min(470px,100%);overflow:hidden;border:1px solid rgba(255,255,255,.55);border-radius:18px;background:#fff;box-shadow:0 30px 80px rgba(15,23,42,.36);color:#0f172a}" +
            ".wpsession-accent{height:6px;background:linear-gradient(90deg,#0f766e,#2563eb,#dc2626)}" +
            ".wpsession-body{padding:28px}" +
            ".wpsession-icon{display:flex;align-items:center;justify-content:center;width:54px;height:54px;margin-bottom:18px;border-radius:16px;background:#fff1f2;color:#dc2626;font-size:29px;font-weight:900}" +
            ".wpsession-title{margin:0;font-size:23px;line-height:1.25;font-weight:800;color:#0f172a}" +
            ".wpsession-copy{margin:10px 0 0;color:#64748b;font-size:14px;line-height:1.55}" +
            ".wpsession-countdown{display:flex;align-items:center;justify-content:space-between;gap:16px;margin:22px 0;padding:16px 18px;border:1px solid #dbe5ef;border-radius:14px;background:#f8fafc}" +
            ".wpsession-countdown-label{font-size:12px;font-weight:800;letter-spacing:.05em;text-transform:uppercase;color:#64748b}" +
            "#wpsession-time{font-variant-numeric:tabular-nums;font-size:28px;font-weight:900;letter-spacing:.04em;color:#dc2626}" +
            "#wpsession-status{min-height:20px;margin:-9px 0 15px;color:#b45309;font-size:12px;font-weight:700}" +
            ".wpsession-actions{display:flex;flex-wrap:wrap;gap:10px;justify-content:flex-end}" +
            ".wpsession-btn{min-height:42px;padding:9px 16px;border-radius:10px;border:1px solid transparent;font:700 13px 'Segoe UI',Arial,sans-serif;cursor:pointer;transition:transform .15s ease,box-shadow .15s ease,background .15s ease}" +
            ".wpsession-btn:hover{transform:translateY(-1px)}" +
            ".wpsession-btn:disabled{cursor:wait;opacity:.65;transform:none}" +
            ".wpsession-btn-secondary{border-color:#cbd5e1;background:#fff;color:#334155}" +
            ".wpsession-btn-primary{background:linear-gradient(135deg,#0f766e,#2563eb);color:#fff;box-shadow:0 10px 22px rgba(37,99,235,.24)}" +
            ".wpsession-notify{display:none;margin-top:14px;padding:0;border:0;background:transparent;color:#2563eb;font:700 12px 'Segoe UI',Arial,sans-serif;cursor:pointer;text-decoration:underline}" +
            "@media(max-width:520px){.wpsession-body{padding:22px}.wpsession-actions{flex-direction:column-reverse}.wpsession-btn{width:100%}}";
        document.head.appendChild(style);

        var overlay = document.createElement("div");
        overlay.id = "wpsession-overlay";
        overlay.setAttribute("role", "dialog");
        overlay.setAttribute("aria-modal", "true");
        overlay.setAttribute("aria-labelledby", "wpsession-title");
        overlay.innerHTML =
            '<div class="wpsession-card">' +
            '<div class="wpsession-accent"></div>' +
            '<div class="wpsession-body">' +
            '<div class="wpsession-icon" aria-hidden="true">!</div>' +
            '<h2 class="wpsession-title" id="wpsession-title">Your session is about to expire</h2>' +
            '<p class="wpsession-copy" id="wpsession-copy">For your security, you will be signed out because the portal has been idle. Continue your session to keep working.</p>' +
            '<div class="wpsession-countdown"><span class="wpsession-countdown-label">Time remaining</span><strong id="wpsession-time">02:00</strong></div>' +
            '<div id="wpsession-status" aria-live="polite"></div>' +
            '<div class="wpsession-actions">' +
            '<button type="button" class="wpsession-btn wpsession-btn-secondary" id="wpsession-signout">Sign out now</button>' +
            '<button type="button" class="wpsession-btn wpsession-btn-primary" id="wpsession-stay">Stay signed in</button>' +
            '</div>' +
            '<button type="button" class="wpsession-notify" id="wpsession-enable-notifications">Enable desktop alerts for future warnings</button>' +
            '</div></div>';
        document.body.appendChild(overlay);

        byId("wpsession-stay").addEventListener("click", function () {
            var button = this;
            button.disabled = true;
            byId("wpsession-status").textContent = "Renewing your session...";
            renewSession(function (success) {
                button.disabled = false;
                if (!success && !sessionExpired) {
                    byId("wpsession-status").textContent = "We could not renew the session. Check your connection and try again.";
                }
            });
        });

        byId("wpsession-signout").addEventListener("click", function () {
            redirectToLogout(sessionExpired ? "session-expired" : "user-signout");
        });

        byId("wpsession-enable-notifications").addEventListener("click", requestNotificationPermission);
    }

    function requestNotificationPermission() {
        if (!("Notification" in window) || window.Notification.permission !== "default") {
            updateNotificationButton();
            return;
        }

        var permissionResult = window.Notification.requestPermission();
        if (permissionResult && typeof permissionResult.then === "function") {
            permissionResult.then(function () {
                updateNotificationButton();
            });
        } else {
            window.setTimeout(updateNotificationButton, 250);
        }
    }

    function updateNotificationButton() {
        var button = byId("wpsession-enable-notifications");
        if (!button) {
            return;
        }
        button.style.display = ("Notification" in window && window.Notification.permission === "default") ? "inline-block" : "none";
    }

    function captureFavicons() {
        iconStates = [];
        var icons = document.querySelectorAll("link[rel~='icon'], link[rel='shortcut icon']");
        var index;

        for (index = 0; index < icons.length; index += 1) {
            iconStates.push({
                element: icons[index],
                href: icons[index].getAttribute("href") || normalFallbackIcon,
                created: false
            });
        }

        if (iconStates.length === 0) {
            var icon = document.createElement("link");
            icon.rel = "icon";
            icon.href = normalFallbackIcon;
            document.head.appendChild(icon);
            iconStates.push({ element: icon, href: normalFallbackIcon, created: true });
        }
    }

    function setWarningFavicon(showWarningIcon) {
        var index;
        for (index = 0; index < iconStates.length; index += 1) {
            iconStates[index].element.setAttribute("href", showWarningIcon ? warningIcon : iconStates[index].href);
        }
    }

    function startAttention() {
        if (attentionTimer) {
            return;
        }

        titleBeforeAttention = document.title;
        captureFavicons();
        var warningState = false;
        attentionTimer = window.setInterval(function () {
            warningState = !warningState;
            document.title = warningState ? "⚠ Session expires soon" : titleBeforeAttention;
            setWarningFavicon(warningState);
        }, 700);
        showDesktopNotification();
    }

    function stopAttention() {
        if (attentionTimer) {
            window.clearInterval(attentionTimer);
            attentionTimer = null;
        }

        if (titleBeforeAttention) {
            document.title = titleBeforeAttention;
        }
        setWarningFavicon(false);

        if (notification) {
            notification.close();
            notification = null;
        }
    }

    function showDesktopNotification() {
        if (!("Notification" in window) || window.Notification.permission !== "granted" || !document.hidden || notification) {
            return;
        }

        try {
            notification = new window.Notification("WebPortal session expires soon", {
                body: "Return to WebPortal and choose Stay signed in to continue your work.",
                tag: "webportal-session-expiry",
                requireInteraction: true
            });
            notification.onclick = function () {
                window.focus();
                notification.close();
                notification = null;
            };
            notification.onclose = function () {
                notification = null;
            };
        } catch (ignore) {
            notification = null;
        }
    }

    function showWarning(remainingSeconds) {
        ensureUi();
        byId("wpsession-overlay").classList.add("wpsession-open");
        byId("wpsession-time").textContent = formatTime(remainingSeconds);
        byId("wpsession-status").textContent = "";
        updateNotificationButton();

        if (!warningVisible) {
            warningVisible = true;
            startAttention();
            if (!document.hidden) {
                byId("wpsession-stay").focus();
            }
        }

        if (warningShownForDeadline !== deadline) {
            warningShownForDeadline = deadline;
            showDesktopNotification();
        }
    }

    function hideWarning() {
        warningVisible = false;
        var overlay = byId("wpsession-overlay");
        if (overlay) {
            overlay.classList.remove("wpsession-open");
            byId("wpsession-stay").style.display = "inline-block";
            byId("wpsession-stay").disabled = false;
            byId("wpsession-signout").textContent = "Sign out now";
            byId("wpsession-title").textContent = "Your session is about to expire";
            byId("wpsession-copy").textContent = "For your security, you will be signed out because the portal has been idle. Continue your session to keep working.";
        }
        stopAttention();
    }

    function completeKeepAlive(success, responseData) {
        var callbacks = keepAliveCallbacks.slice(0);
        keepAliveCallbacks = [];
        keepAliveInProgress = false;

        if (success) {
            resetDeadline(responseData && responseData.timeoutSeconds);
        }

        var index;
        for (index = 0; index < callbacks.length; index += 1) {
            callbacks[index](success);
        }
    }

    function renewSession(callback) {
        if (typeof callback === "function") {
            keepAliveCallbacks.push(callback);
        }
        if (keepAliveInProgress || sessionExpired) {
            return;
        }

        keepAliveInProgress = true;
        var xhr = new XMLHttpRequest();
        xhr.open("POST", keepAliveUrl, true);
        xhr.withCredentials = true;
        xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
        xhr.setRequestHeader("Cache-Control", "no-cache");
        xhr.onreadystatechange = function () {
            if (xhr.readyState !== 4) {
                return;
            }

            if (xhr.status === 401 || xhr.status === 403 || xhr.status === 440 || isLoginResponseUrl(xhr.responseURL)) {
                completeKeepAlive(false, null);
                expireSession();
                return;
            }

            if (xhr.status >= 200 && xhr.status < 300) {
                try {
                    var data = JSON.parse(xhr.responseText || "{}");
                    if (data.authenticated === true) {
                        completeKeepAlive(true, data);
                        return;
                    }
                } catch (ignore) {
                    // A non-JSON response normally indicates a login redirect.
                }
            }

            completeKeepAlive(false, null);
        };
        xhr.onerror = function () {
            completeKeepAlive(false, null);
        };
        xhr.send(null);
    }

    function redirectToLogout(reason) {
        stopAttention();
        window.location.replace(addQuery(logoutUrl, "reason", reason || "session-expired"));
    }

    function expireSession() {
        if (sessionExpired) {
            return;
        }

        sessionExpired = true;
        warningVisible = true;
        ensureUi();
        byId("wpsession-overlay").classList.add("wpsession-open");
        byId("wpsession-title").textContent = "Your session has expired";
        byId("wpsession-copy").textContent = "You are being redirected to the login page. Any unsaved server-side changes may need to be entered again.";
        byId("wpsession-time").textContent = "00:00";
        byId("wpsession-status").textContent = "Redirecting securely...";
        byId("wpsession-stay").style.display = "none";
        byId("wpsession-signout").textContent = "Sign in again";
        updateNotificationButton();
        startAttention();
        window.setTimeout(function () {
            redirectToLogout("session-expired");
        }, 3000);
    }

    function registerActivity() {
        if (sessionExpired) {
            return;
        }

        lastActivityAt = Date.now();
        if (!warningVisible && (lastActivityAt - lastKeepAliveAt) >= (heartbeatSeconds * 1000)) {
            renewSession();
        }
    }

    function tick() {
        if (sessionExpired) {
            return;
        }

        var now = Date.now();
        var remainingSeconds = (deadline - now) / 1000;

        if (remainingSeconds <= 0) {
            expireSession();
            return;
        }

        if (remainingSeconds <= warningSeconds) {
            showWarning(remainingSeconds);
            return;
        }

        if (!warningVisible && lastActivityAt > lastKeepAliveAt &&
            (now - lastKeepAliveAt) >= (heartbeatSeconds * 1000) &&
            (now - lastActivityAt) <= (heartbeatSeconds * 1000)) {
            renewSession();
        }
    }

    function attachAuthenticationFailureHandlers() {
        if (window.fetch) {
            var originalFetch = window.fetch;
            window.fetch = function () {
                return originalFetch.apply(this, arguments).then(function (response) {
                    if (response.status === 401 || response.status === 403 || response.status === 440 ||
                        (response.redirected && isLoginResponseUrl(response.url))) {
                        expireSession();
                    }
                    return response;
                });
            };
        }

        if (window.jQuery) {
            window.jQuery(document).ajaxError(function (event, xhr) {
                if (xhr.status === 401 || xhr.status === 403 || xhr.status === 440 || isLoginResponseUrl(xhr.responseURL)) {
                    expireSession();
                }
            });
        }
    }

    function initialize() {
        ensureUi();
        attachAuthenticationFailureHandlers();

        var activityEvents = ["pointerdown", "keydown", "touchstart", "scroll"];
        var index;
        for (index = 0; index < activityEvents.length; index += 1) {
            document.addEventListener(activityEvents[index], registerActivity, false);
        }

        window.addEventListener("storage", function (event) {
            if (event.key !== storageKey || !event.newValue || sessionExpired) {
                return;
            }
            try {
                var sharedState = JSON.parse(event.newValue);
                if (sharedState.deadline > Date.now() && sharedState.deadline > deadline) {
                    deadline = sharedState.deadline;
                    lastKeepAliveAt = Date.now();
                    warningShownForDeadline = 0;
                    hideWarning();
                }
            } catch (ignore) {
                // Ignore malformed or unavailable cross-tab state.
            }
        });

        document.addEventListener("visibilitychange", function () {
            tick();
            if (warningVisible && document.hidden) {
                showDesktopNotification();
            }
        });

        window.addEventListener("focus", tick);
        tickTimer = window.setInterval(tick, 1000);
        renewSession();
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", initialize);
    } else {
        initialize();
    }

})(window, document);
