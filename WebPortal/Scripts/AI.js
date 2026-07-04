(function (window, $) {
    "use strict";

    if (!$) {
        return;
    }

    var endpointUrl = "/Admin/AICopilot.aspx/AskAI";
    var settingsUrl = "/Admin/AICopilot.aspx/GetReportSettings";
    var saveSettingsUrl = "/Admin/AICopilot.aspx/SaveReportSettings";

    function escapeHtml(text) {
        return $("<div>").text(text || "").html();
    }

    function formatAnswer(text) {
        var html = escapeHtml(text || "");
        html = html.replace(/(\/[A-Za-z0-9_\-\/.]+\.(?:aspx|csv|xlsx|xls)(?:\?[A-Za-z0-9_\-./%=&]*)?)/g, function (match) {
            return '<a href="' + match + '">' + match + '</a>';
        });
        return html.replace(/\n/g, "<br>");
    }

    function appendMessage(boxSelector, type, text, pendingClass) {
        var cls = type === "user" ? "user" : "bot";
        var pending = pendingClass ? " " + pendingClass : "";
        var rowClass = boxSelector === "#chatBox" ? "ai-message-row" : "copilot-msg-row";
        var msgClass = boxSelector === "#chatBox" ? "ai-message" : "copilot-msg";
        var html =
            '<div class="' + rowClass + " " + cls + pending + '">' +
            '<div class="' + msgClass + " " + cls + '">' + formatAnswer(text) + "</div>" +
            "</div>";

        $(boxSelector).find(".ai-empty, .copilot-welcome").remove();
        $(boxSelector).append(html);
        $(boxSelector).scrollTop($(boxSelector)[0].scrollHeight);
    }

    function setPendingMessage(boxSelector, text) {
        var pending = $(boxSelector).find(".ai-pending").last();
        if (pending.length) {
            pending.find(".ai-message, .copilot-msg").html(formatAnswer(text));
            pending.removeClass("ai-pending");
        } else {
            appendMessage(boxSelector, "bot", text);
        }
    }

    function askCopilot(question, options) {
        question = $.trim(question || "");
        if (question === "") {
            return;
        }

        appendMessage(options.boxSelector, "user", question);
        $(options.inputSelector).val("");
        $(options.buttonSelector).prop("disabled", true).text("...");
        appendMessage(options.boxSelector, "bot", "Copilot is thinking...", "ai-pending");

        $.ajax({
            type: "POST",
            url: endpointUrl,
            data: JSON.stringify({ question: question }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (res) {
                setPendingMessage(options.boxSelector, res.d);
            },
            error: function () {
                setPendingMessage(options.boxSelector, "Unable to connect to ERP Copilot. Please check Ollama service or contact ERP admin.");
            },
            complete: function () {
                $(options.buttonSelector).prop("disabled", false).text(options.buttonText);
            }
        });
    }

    function injectFloatingStyles() {
        if ($("#erpCopilotStyles").length) {
            return;
        }

        $("head").append(
            '<style id="erpCopilotStyles">' +
            "#erpCopilotFab{position:fixed;right:22px;bottom:22px;z-index:1050;width:58px;height:58px;border:0;border-radius:50%;background:#0f766e;color:#fff;box-shadow:0 12px 30px rgba(15,118,110,.32);display:flex;align-items:center;justify-content:center;font-weight:700;cursor:pointer}" +
            "#erpCopilotFab i{font-size:22px}" +
            "#erpCopilotOverlay{display:none;position:fixed;inset:0;background:rgba(15,23,42,.28);z-index:1048}" +
            "#erpCopilotPanel{position:fixed;right:22px;bottom:92px;width:390px;max-width:calc(100vw - 28px);height:560px;max-height:calc(100vh - 120px);background:#fff;border:1px solid #dbe3ef;border-radius:8px;box-shadow:0 18px 48px rgba(15,23,42,.24);z-index:1049;display:none;overflow:hidden;font-family:Segoe UI,Arial,sans-serif}" +
            "#erpCopilotPanel.open{display:flex;flex-direction:column}" +
            ".copilot-head{height:58px;background:#0f766e;color:#fff;display:flex;align-items:center;justify-content:space-between;padding:0 14px}" +
            ".copilot-head h4{margin:0;font-size:16px;font-weight:700}.copilot-head span{font-size:12px;opacity:.86}" +
            "#btnCloseCopilot{border:0;background:rgba(255,255,255,.16);color:#fff;width:32px;height:32px;border-radius:50%;cursor:pointer}" +
            ".copilot-quick{display:flex;gap:8px;flex-wrap:wrap;padding:10px 12px;border-bottom:1px solid #e5edf6;background:#f8fafc}" +
            ".copilot-chip{border:1px solid #bfd8d4;background:#fff;color:#0f766e;border-radius:16px;padding:5px 10px;font-size:12px;cursor:pointer}" +
            ".copilot-settings{display:none;padding:9px 12px;border-bottom:1px solid #e5edf6;background:#fff7ed;color:#7c2d12;font-size:12px}.copilot-settings label{display:flex;align-items:center;gap:7px;margin:0}.copilot-settings input{margin:0}.copilot-settings-status{display:block;margin-top:5px;color:#92400e}" +
            "#copilotChatBox{flex:1;overflow:auto;padding:14px;background:#f8fafc}.copilot-welcome{color:#475569;text-align:center;margin-top:95px}" +
            ".copilot-msg-row{display:flex;margin-bottom:12px}.copilot-msg-row.user{justify-content:flex-end}.copilot-msg{max-width:82%;padding:10px 12px;border-radius:8px;font-size:13px;line-height:1.45}.copilot-msg.user{background:#0f766e;color:#fff}.copilot-msg.bot{background:#fff;color:#1f2937;border:1px solid #e2e8f0}.copilot-msg a{color:#0f766e;font-weight:600}" +
            ".copilot-input{display:flex;gap:8px;padding:12px;border-top:1px solid #e5edf6;background:#fff}#txtCopilotQuestion{flex:1;min-height:44px;max-height:90px;resize:vertical;border:1px solid #cbd5e1;border-radius:8px;padding:9px;font-size:13px}#btnCopilotSend{width:72px;border:0;border-radius:8px;background:#f59e0b;color:#111827;font-weight:700;cursor:pointer}#btnCopilotSend:disabled{opacity:.65;cursor:not-allowed}" +
            "@media(max-width:575px){#erpCopilotPanel{right:14px;bottom:84px;height:520px}.copilot-msg{max-width:90%}}" +
            "</style>"
        );
    }

    function ensureFloatingCopilot() {
        if ($("#btnAskAI").length && $("#chatBox").length) {
            return;
        }

        if ($("#erpCopilotFab").length) {
            return;
        }

        injectFloatingStyles();

        $("body").append(
            '<button type="button" id="erpCopilotFab" title="ERP Assistant"><i class="fas fa-comments"></i><span class="sr-only">ERP Assistant</span></button>' +
            '<div id="erpCopilotOverlay"></div>' +
            '<section id="erpCopilotPanel" aria-label="ERP Assistant">' +
            '<div class="copilot-head"><div><h4>ERP Assistant</h4><span>Local AI</span></div><button type="button" id="btnCloseCopilot">x</button></div>' +
            '<div class="copilot-quick">' +
            '<button type="button" class="copilot-chip" data-prompt="Find salary slip">Salary slip</button>' +
            '<button type="button" class="copilot-chip" data-prompt="Find attendance report">Attendance report</button>' +
            '<button type="button" class="copilot-chip" data-prompt="Find resignation page">Resignation</button>' +
            '<button type="button" class="copilot-chip" data-prompt="Generate performance report this month">Performance report</button>' +
            '<button type="button" class="copilot-chip" data-prompt="Generate branch wise login count today">Login count</button>' +
            '<button type="button" class="copilot-chip" data-prompt="Generate segment wise employees report">Segment employees</button>' +
            "</div>" +
            '<div id="copilotReportSettings" class="copilot-settings">' +
            '<label><input type="checkbox" id="chkAllowBelowPMReports"> Allow report generation below PM</label>' +
            '<span id="copilotReportSettingsStatus" class="copilot-settings-status"></span>' +
            "</div>" +
            '<div id="copilotChatBox"><div class="copilot-welcome">How can I help?</div></div>' +
            '<div class="copilot-input"><textarea id="txtCopilotQuestion" placeholder="Ask for a menu or generate report..."></textarea><button type="button" id="btnCopilotSend">Send</button></div>' +
            "</section>"
        );
    }

    function loadReportSettings() {
        if (!$("#copilotReportSettings").length) {
            return;
        }

        $.ajax({
            type: "POST",
            url: settingsUrl,
            data: "{}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (res) {
                var settings = res.d || {};
                $("#chkAllowBelowPMReports").prop("checked", settings.AllowReportGenerationBelowPM === true);

                if (settings.CanManageReports === true) {
                    $("#copilotReportSettings").show();
                    updateSettingsStatus("Report setting loaded.");
                } else {
                    $("#copilotReportSettings").hide();
                }
            }
        });
    }

    function saveReportSettings() {
        var allowBelowPM = $("#chkAllowBelowPMReports").is(":checked");
        updateSettingsStatus("Saving...");

        $.ajax({
            type: "POST",
            url: saveSettingsUrl,
            data: JSON.stringify({ allowReportGenerationBelowPM: allowBelowPM }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function () {
                updateSettingsStatus(allowBelowPM ? "Below-PM report generation is enabled." : "Below-PM report generation is disabled.");
            },
            error: function () {
                updateSettingsStatus("Unable to save report setting.");
            }
        });
    }

    function updateSettingsStatus(text) {
        $("#copilotReportSettingsStatus").text(text || "");
    }

    function bindFullPageCopilot() {
        if (!$("#btnAskAI").length) {
            return;
        }

        $("#btnAskAI").off("click.ai").on("click.ai", function () {
            askCopilot($("#txtQuestion").val(), {
                boxSelector: "#chatBox",
                inputSelector: "#txtQuestion",
                buttonSelector: "#btnAskAI",
                buttonText: "Send"
            });
        });

        $("#txtQuestion").off("keydown.ai").on("keydown.ai", function (e) {
            if (e.keyCode === 13 && !e.shiftKey) {
                e.preventDefault();
                $("#btnAskAI").trigger("click");
            }
        });

        $(".ai-chip").off("click.ai").on("click.ai", function () {
            $("#txtQuestion").val($(this).data("prompt")).focus();
        });

        $("#btnNewChat").off("click.ai").on("click.ai", function () {
            $("#chatBox").html(
                '<div class="ai-empty">' +
                '<div class="ai-empty-icon">AI</div>' +
                "<h4>How can I help you today?</h4>" +
                "<p>Ask for a menu, report, or ERP workflow.</p>" +
                "</div>"
            );
        });
    }

    function bindFloatingCopilot() {
        $("#erpCopilotFab").off("click.ai").on("click.ai", function () {
            $("#erpCopilotOverlay").show();
            $("#erpCopilotPanel").addClass("open");
            $("#txtCopilotQuestion").focus();
        });

        $("#btnCloseCopilot, #erpCopilotOverlay").off("click.ai").on("click.ai", function () {
            $("#erpCopilotPanel").removeClass("open");
            $("#erpCopilotOverlay").hide();
        });

        $("#btnCopilotSend").off("click.ai").on("click.ai", function () {
            askCopilot($("#txtCopilotQuestion").val(), {
                boxSelector: "#copilotChatBox",
                inputSelector: "#txtCopilotQuestion",
                buttonSelector: "#btnCopilotSend",
                buttonText: "Send"
            });
        });

        $("#txtCopilotQuestion").off("keydown.ai").on("keydown.ai", function (e) {
            if (e.keyCode === 13 && !e.shiftKey) {
                e.preventDefault();
                $("#btnCopilotSend").trigger("click");
            }
        });

        $(".copilot-chip").off("click.ai").on("click.ai", function () {
            $("#txtCopilotQuestion").val($(this).data("prompt")).focus();
        });

        $("#chkAllowBelowPMReports").off("change.ai").on("change.ai", function () {
            saveReportSettings();
        });
    }

    $(function () {
        ensureFloatingCopilot();
        bindFullPageCopilot();
        bindFloatingCopilot();
        loadReportSettings();
    });
})(window, window.jQuery);
