<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="WebPortal.ForgotPassword" %>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <style>
        body {
            background: linear-gradient(135deg, #1e3a8a, #9333ea);
            /* background: linear-gradient(to right, #6fa0d6 0%, #4F81BD 50%, #2f5f9e 100%) !important;*/
        }
    </style>

</head>
<body class="flex items-center justify-center min-h-screen font-sans">



    <div class="bg-white/10 backdrop-blur-lg shadow-2xl rounded-2xl p-8 w-full max-w-md border border-white/20">

        <div class="text-center mb-6">
            <h1 class="text-3xl font-bold text-white">Forgot Password</h1>
        </div>

        <div id="msgBox" class="hidden mb-4 p-3 rounded-lg text-sm font-medium"></div>

        <form onsubmit="updatePassword(event)">

            <!-- User Name -->
            <div class="mb-3 relative">
                <input id="pass_username" type="text" placeholder="User Name" style="text-transform: uppercase;"
                    class="w-full pl-10 pr-0 py-2 rounded-lg bg-white/20 text-white placeholder-white/60 focus:outline-none focus:ring-2 focus:ring-purple-400">
                <%--    <span class="absolute left-3 top-2 text-white/60">👤</span>--%>
                <span class="absolute right-3 top-2 cursor-pointer text-white">👤</span>
            </div>

            <!-- ✅ ADD BUTTON HERE -->
            <button type="button" onclick="sendOTP()"
                class="w-full bg-blue-500 text-white py-2 rounded-lg mb-3">
                Send Code
            </button>

            <!-- OTP Field -->
            <%--   <div class="mb-3">
                    <input id="otp" type="text" placeholder="Enter OTP" class="w-full px-4 py-2 rounded-lg bg-white/20 text-white">
                </div>--%>

            <div class="mb-3 position-relative">
                <input id="otp" type="text" placeholder="Enter OTP"
                    oninput="validateOTPField()"
                    maxlength="6"
                    class="w-full px-4 py-2 rounded-lg bg-white/20 text-white">

                <!-- Loader -->
                <span id="otp_loader" style="display: none; position: absolute; right: 10px; top: 10px;">⏳
                </span>

                <!-- Success Tick -->
                <span id="otp_success" style="display: none; position: absolute; right: 10px; top: 10px; color: lime;">✔
                </span>

                <!-- Error Cross -->
                <span id="otp_error_icon" style="display: none; position: absolute; right: 10px; top: 10px; color: red;">✖
                </span>
            </div>

            <!-- Error Message -->
            <div id="otp_error_text" style="color: red; display: none; font-size: 13px;"></div>

            <!-- New Password -->
            <div class="mb-3 relative">
                <input id="newPassword" type="password" placeholder="New Password"
                    class="w-full px-4 py-2 rounded-lg bg-white/20 text-white placeholder-white/60 focus:outline-none focus:ring-2 focus:ring-purple-400">
                <span onclick="toggle('newPassword')" class="absolute right-3 top-2 cursor-pointer text-white">👁️</span>
            </div>

            <!-- Confirm Password -->
            <div class="mb-4 relative">
                <input id="confirmPassword" type="password" placeholder="Confirm Password"
                    class="w-full px-4 py-2 rounded-lg bg-white/20 text-white placeholder-white/60 focus:outline-none focus:ring-2 focus:ring-purple-400">
                <span onclick="toggle('confirmPassword')" class="absolute right-3 top-2 cursor-pointer text-white">👁️</span>
            </div>

            <!-- Rules -->
            <div class="text-sm text-white/80 mb-4 space-y-1">
                <p id="ruleUpper">✔  Uppercase</p>
                <p id="ruleLower">✔  Lowercase</p>
                <p id="ruleNumber">✔  Number</p>
                <p id="ruleSpecial">✔  Special Character (not %)</p>
                <p id="ruleLength">✔  Min 8 Characters</p>
            </div>

            <button type="submit" id="btnSubmit"
                class="w-full bg-gradient-to-r from-purple-500 to-blue-500 text-white py-2 rounded-lg font-semibold">
                Update Password
            </button>
        </form>

    </div>

    <script>

        let otpVerified = false;
        let otpTimer;
        let resendInterval;
        let resendSeconds = 30;

        // 🔐 Toggle password visibility
        function toggle(id) {
            const el = document.getElementById(id);
            el.type = el.type === "password" ? "text" : "password";
        }

        // 🚀 SEND OTP
        function sendOTP() {
            let username = $("#pass_username").val().trim();

            if (username === "") {
                showMessage("Please enter username", "error");
                return;
            }

            $("#btnSend").prop("disabled", true).text("Sending...");

            $.ajax({
                type: "POST",
                url: "ForgotPassword.aspx/SendOTP",
                data: JSON.stringify({ username: username }),
                contentType: "application/json; charset=utf-8",

                success: function () {
                    showMessage("OTP sent to your official email 📩", "success");

                    startResendTimer();
                    $("#otp").focus();
                },

                error: function () {
                    showMessage("Error sending OTP", "error");
                    $("#btnSend").prop("disabled", false).text("Send Code");
                }
            });
        }

        // ⏱ RESEND TIMER
        function startResendTimer() {
            resendSeconds = 30;
            $("#btnSend").text("Resend in 30s");

            resendInterval = setInterval(() => {
                resendSeconds--;
                $("#btnSend").text("Resend in " + resendSeconds + "s");

                if (resendSeconds <= 0) {
                    clearInterval(resendInterval);
                    $("#btnSend").prop("disabled", false).text("Resend Code");
                }
            }, 1000);
        }

        // 🔢 OTP INPUT VALIDATION
        function validateOTPField() {
            let otp = $("#otp").val().replace(/\D/g, '');
            $("#otp").val(otp);

            resetOTPUI();

            if (otp.length === 6) {
                clearTimeout(otpTimer);
                otpTimer = setTimeout(() => verifyOTPFromServer(otp), 400);
            }
        }

        // 🔁 RESET OTP UI
        function resetOTPUI() {
            $("#otp_success, #otp_error_icon, #otp_error_text").hide();
            $("#otp").css("border", "");
            otpVerified = false;
            $("#btnSubmit").prop("disabled", true);
        }

        // 🌐 VERIFY OTP
        function verifyOTPFromServer(otp) {
            let username = $("#pass_username").val();

            $("#otp_loader").show();

            $.ajax({
                type: "POST",
                url: "ForgotPassword.aspx/VerifyOTP",
                data: JSON.stringify({ username: username, otp: otp }),
                contentType: "application/json; charset=utf-8",

                success: function (res) {
                    $("#otp_loader").hide();

                    if (res.d === "Valid") {
                        otpVerified = true;

                        $("#otp_success").show();
                        $("#otp").css("border", "2px solid #4ade80");

                        $("#btnSubmit").prop("disabled", false);
                        showMessage("OTP Verified ✅", "success");

                    } else {
                        $("#otp_error_icon").show();
                        $("#otp_error_text").text("Invalid OTP").show();
                        $("#otp").css("border", "2px solid #f87171");
                    }
                },

                error: function () {
                    $("#otp_loader").hide();
                    $("#otp_error_text").text("Error validating OTP").show();
                }
            });
        }

        // 🔐 PASSWORD VALIDATION
        $("#newPassword").on("keyup", function () {
            const val = $(this).val();

            toggleRule("ruleUpper", /[A-Z]/.test(val));
            toggleRule("ruleLower", /[a-z]/.test(val));
            toggleRule("ruleNumber", /[0-9]/.test(val));
            toggleRule("ruleSpecial", /[^A-Za-z0-9%]/.test(val));
            toggleRule("ruleLength", val.length >= 8);
        });

        function toggleRule(id, valid) {
            const el = document.getElementById(id);
            el.innerHTML = (valid ? "✔ " : "❌ ") + el.innerHTML.substring(2);
            el.style.color = valid ? "#4ade80" : "#f87171";
        }

        function validatePassword(pwd) {
            if (pwd.includes("%")) {
                showMessage("Password cannot contain %", "error");
                return false;
            }

            return /[A-Z]/.test(pwd) &&
                /[a-z]/.test(pwd) &&
                /[0-9]/.test(pwd) &&
                /[^A-Za-z0-9%]/.test(pwd) &&
                pwd.length >= 8;
        }

        // 🔄 UPDATE PASSWORD
        function updatePassword(e) {
            e.preventDefault();

            const username = $("#pass_username").val();
            const pwd = $("#newPassword").val();
            const confirm = $("#confirmPassword").val();
            const otp = $("#otp").val();

            if (!otpVerified) {
                showMessage("Please verify OTP first", "error");
                return;
            }

            if (!validatePassword(pwd)) {
                showMessage("Password does not meet requirements", "error");
                return;
            }

            if (pwd !== confirm) {
                showMessage("Passwords do not match", "error");
                return;
            }

            $("#btnSubmit").prop("disabled", true).text("Updating...");

            $.ajax({
                type: "POST",
                url: "ForgotPassword.aspx/UpdatePassword",
                data: JSON.stringify({ username: username, newPassword: pwd, otp: otp }),
                contentType: "application/json; charset=utf-8",

                success: function (res) {
                    showMessage(res.d, "success");
                    $("#btnSubmit").text("Update Password");
                },

                error: function () {
                    showMessage("Error updating password", "error");
                    $("#btnSubmit").prop("disabled", false).text("Update Password");
                }
            });
        }

        // 💬 MESSAGE BOX
        function showMessage(msg, type) {
            const box = $("#msgBox");

            box.removeClass("hidden");

            if (type === "error") {
                box.attr("class", "mb-4 p-3 rounded-lg bg-red-500/20 text-red-200 border border-red-400");
            } else {
                box.attr("class", "mb-4 p-3 rounded-lg bg-green-500/20 text-green-200 border border-green-400");
            }

            box.html(msg);
        }

    </script>

</body>
</html>

