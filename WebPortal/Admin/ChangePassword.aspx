<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ChangePassword.aspx.cs" Inherits="WebPortal.Admin.ChangePassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .cp-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            gap: 22px;
            padding: 17px 22px;
            margin-bottom: 22px;
            border-radius: 18px;
            color: #fff;
           /* background: linear-gradient(135deg, #2563eb 0%, #7c3aed 100%);*/
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%);
            box-shadow: 0 14px 20px rgba(21, 98, 150, .24);
        }

            .cp-hero:before {
                content: "";
                position: absolute;
                top: -92px;
                left: -6%;
                width: 115%;
                height: 185px;
                border-radius: 50%;
                background: rgba(255,255,255,.10);
                transform: rotate(-3deg);
            }

            .cp-hero:after {
                content: "";
                position: absolute;
                right: -10%;
                bottom: -76px;
                width: 70%;
                height: 190px;
                background: repeating-radial-gradient(ellipse at center, rgba(255,255,255,.18) 0, rgba(255,255,255,.18) 2px, transparent 3px, transparent 11px);
                opacity: .42;
                transform: rotate(-7deg);
            }

            .cp-hero > * {
                position: relative;
                z-index: 2;
            }

        .cp-hero-icon {
            width: 55px;
            height: 55px;
            min-width: 55px;
            border-radius: 50%;
            border: 2px solid rgba(255,255,255,.78);
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.12);
            backdrop-filter: blur(5px);
        }

            .cp-hero-icon i {
                font-size: 34px;
                color: #fff;
            }

        .cp-kicker {
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 2px;
            opacity: .92;
            margin-bottom: 5px;
            font-weight: 700;
        }

        .cp-title {
            margin: 0;
            font-size: 25px;
            font-weight: 800;
            color: #fff;
        }

        .cp-subtitle {
            margin: 9px 0 0;
            max-width: 850px;
            color: rgba(255,255,255,.94);
            font-size: 13px;
            line-height: 1.6;
        }

        .cp-shell {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 340px;
            gap: 20px;
        }

        .cp-card,
        .cp-help-card {
            background: #fff;
            border: 1px solid #e6edf7;
            border-radius: 18px;
            box-shadow: 0 12px 30px rgba(15, 23, 42, .08);
        }

        .cp-card-header {
            padding: 18px 22px;
            border-bottom: 1px solid #edf2f7;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
        }

        .cp-card-title {
            margin: 0;
            font-size: 18px;
            color: #172554;
            font-weight: 800;
        }

        .cp-card-note {
            margin: 4px 0 0;
            font-size: 13px;
            color: #64748b;
        }

        .cp-badge {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 7px 12px;
            border-radius: 999px;
            color: #075985;
            background: #e0f2fe;
            font-weight: 700;
            font-size: 12px;
            white-space: nowrap;
        }

        .cp-form {
            padding: 22px;
            max-width: 720px;
        }

        .cp-form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 18px;
        }

        .cp-field-full {
            grid-column: 1 / -1;
        }

        .cp-field label {
            display: block;
            margin-bottom: 7px;
            color: #334155;
            font-size: 13px;
            font-weight: 800;
        }

        .cp-input-wrap {
            position: relative;
        }

        .cp-field .form-control {
            width: 100%;
            height: 44px;
            border: 1px solid #dbe4f0;
            border-radius: 12px;
            padding: 10px 45px 10px 14px;
            color: #0f172a;
            font-size: 14px;
            box-shadow: none;
            transition: all .2s ease;
        }

            .cp-field .form-control:focus {
                border-color: #2563eb;
                box-shadow: 0 0 0 4px rgba(37, 99, 235, .12);
            }

        .cp-toggle {
            position: absolute;
            top: 50%;
            right: 12px;
            transform: translateY(-50%);
            border: 0;
            background: transparent;
            color: #64748b;
            cursor: pointer;
            width: 28px;
            height: 28px;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 0;
        }

        .cp-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            padding-top: 20px;
        }

        .cp-btn-primary,
        .cp-btn-light {
            border: 0;
            border-radius: 12px;
            min-height: 42px;
            padding: 10px 18px;
            font-weight: 800;
            cursor: pointer;
            transition: all .2s ease;
        }

        .cp-btn-primary {
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8, #2563eb 65%, #22c1dc);
            box-shadow: 0 8px 18px rgba(37, 99, 235, .25);
        }

            .cp-btn-primary:hover {
                transform: translateY(-1px);
                box-shadow: 0 12px 22px rgba(37, 99, 235, .32);
            }

        .cp-btn-light {
            color: #334155;
            background: #f1f5f9;
        }

        .cp-message {
            margin-top: 18px;
            padding: 12px 15px;
            border: 1px solid transparent;
            border-radius: 10px;
            font-size: 14px;
            line-height: 1.5;
        }

        .cp-message[hidden] {
            display: none;
        }

        .cp-message-success {
            color: #166534;
            background: #f0fdf4;
            border-color: #bbf7d0;
        }

        .cp-message-warning {
            color: #92400e;
            background: #fffbeb;
            border-color: #fde68a;
        }

        .cp-message-error {
            color: #991b1b;
            background: #fef2f2;
            border-color: #fecaca;
        }

        .cp-message-info {
            color: #1e40af;
            background: #eff6ff;
            border-color: #bfdbfe;
        }

        .cp-btn-primary:disabled {
            cursor: wait;
            opacity: .7;
            transform: none;
        }

        .cp-help-card {
            padding: 22px;
        }

        .cp-help-title {
            margin: 0 0 12px;
            font-size: 16px;
            color: #172554;
            font-weight: 800;
        }

        .cp-help-list {
            margin: 0;
            padding-left: 18px;
            color: #475569;
            font-size: 13px;
            line-height: 1.8;
        }

        @media (max-width: 992px) {
            .cp-shell {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 576px) {
            .cp-hero {
                align-items: flex-start;
                padding: 22px;
            }

            .cp-hero-icon {
                width: 60px;
                height: 60px;
                min-width: 60px;
            }

            .cp-title {
                font-size: 24px;
            }

            .cp-form-grid {
                grid-template-columns: 1fr;
            }

            .cp-actions {
                flex-direction: column-reverse;
            }
        }
    </style>

    <script>
        function changepassword_submit() {
            var currentPassword = $.trim($("#changepassword_currentpassword").val());
            var newPassword = $.trim($("#changepassword_newpassword").val());
            var confirmPassword = $.trim($("#changepassword_confirmnewpassword").val());

            if (currentPassword === "") {
                changepassword_showValidation("Please enter current password.");
                return false;
            }

            if (newPassword === "") {
                changepassword_showValidation("Please enter new password.");
                return false;
            }

            if (confirmPassword === "") {
                changepassword_showValidation("Please enter confirm password.");
                return false;
            }

            if (newPassword.length < 6) {
                changepassword_showValidation("New password must be at least 6 characters.");
                return false;
            }

            if (confirmPassword !== newPassword) {
                changepassword_showValidation("New password and confirm password should be same.");
                return false;
            }

            changepassword_setBusy(true);
            changepassword_showMessage("info", "Please wait", "Changing your password.");

            PageMethods.ChangePasswords(currentPassword, newPassword, changepassword_OnSuccess, changepassword_OnError);
            return false;
        }

        function changepassword_OnSuccess(result) {
            changepassword_setBusy(false);

            if (result > 0) {
                changepassword_clear();
                changepassword_showMessage("success", "Success", "Password changed successfully.");
            }
            else if (result == -1) {
                changepassword_showMessage("warning", "Wrong Password", "You have entered wrong current password.");
            }
            else {
                changepassword_showMessage("error", "Error", "Error occurred while changing password. Please contact administrator.");
            }

            return false;
        }

        function changepassword_OnError(error) {
            changepassword_setBusy(false);
            changepassword_showMessage("error", "Error", error && error.responseText ? error.responseText : "Unable to change password.");

            return false;
        }

        function changepassword_showValidation(message) {
            changepassword_showMessage("warning", "Please check", message);
        }

        function changepassword_showMessage(type, title, message) {
            var notice = document.getElementById("changepassword_message");
            notice.className = "cp-message cp-message-" + type;
            notice.setAttribute("role", type === "error" || type === "warning" ? "alert" : "status");
            notice.setAttribute("aria-live", type === "error" || type === "warning" ? "assertive" : "polite");
            notice.textContent = title + ": " + message;
            notice.hidden = false;
        }

        function changepassword_setBusy(isBusy) {
            var button = document.getElementById("changepassword_btnsubmit");
            button.disabled = isBusy;
            button.setAttribute("aria-busy", isBusy ? "true" : "false");
        }

        function changepassword_clear() {
            $("#changepassword_currentpassword").val("");
            $("#changepassword_newpassword").val("");
            $("#changepassword_confirmnewpassword").val("");
        }

        function changepassword_toggle(inputId, btn) {
            var input = document.getElementById(inputId);
            var icon = btn.querySelector("i");

            if (input.type === "password") {
                input.type = "text";
                icon.className = "fas fa-eye-slash";
            } else {
                input.type = "password";
                icon.className = "fas fa-eye";
            }

            return false;
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="cp-page">
        <div class="cp-hero">
            <span class="cp-hero-icon">
                <i class="fas fa-key"></i>
            </span>
            <div>
                <h1 class="cp-title">Change Password</h1>
                <p class="cp-subtitle">Update your login password securely and keep your ERP account protected.</p>
            </div>
        </div>

        <div class="cp-shell">
            <div class="cp-card">
                <div class="cp-card-header">
                    <div>
                        <h2 class="cp-card-title">Password Details</h2>
                        <p class="cp-card-note">Enter your current password and confirm the new password.</p>
                    </div>
                    <span class="cp-badge"><i class="fas fa-shield-alt"></i>Secure Update</span>
                </div>

                <div class="cp-form">
                    <div class="cp-form-grid">
                        <div class="cp-field cp-field-full">
                            <label for="changepassword_currentpassword">Current Password</label>
                            <div class="cp-input-wrap">
                                <input type="password" id="changepassword_currentpassword" name="changepassword_currentpassword" class="form-control" placeholder="Enter current password" autocomplete="current-password" />
                                <button type="button" class="cp-toggle" onclick="return changepassword_toggle('changepassword_currentpassword', this);"><i class="fas fa-eye"></i></button>
                            </div>
                        </div>

                        <div class="cp-field">
                            <label for="changepassword_newpassword">New Password</label>
                            <div class="cp-input-wrap">
                                <input type="password" id="changepassword_newpassword" name="changepassword_newpassword" class="form-control" placeholder="Enter new password" autocomplete="new-password" />
                                <button type="button" class="cp-toggle" onclick="return changepassword_toggle('changepassword_newpassword', this);"><i class="fas fa-eye"></i></button>
                            </div>
                        </div>

                        <div class="cp-field">
                            <label for="changepassword_confirmnewpassword">Confirm New Password</label>
                            <div class="cp-input-wrap">
                                <input type="password" id="changepassword_confirmnewpassword" name="changepassword_confirmnewpassword" class="form-control" placeholder="Confirm new password" autocomplete="new-password" />
                                <button type="button" class="cp-toggle" onclick="return changepassword_toggle('changepassword_confirmnewpassword', this);"><i class="fas fa-eye"></i></button>
                            </div>
                        </div>
                    </div>

                    <div id="changepassword_message" class="cp-message" role="status" aria-live="polite" aria-atomic="true" hidden></div>

                    <div class="cp-actions">
                        <button type="button" class="cp-btn-light" onclick="changepassword_clear(); return false;">
                            <i class="fas fa-undo-alt"></i>Clear
                        </button>
                        <button type="button" id="changepassword_btnsubmit" class="cp-btn-primary" onclick="return changepassword_submit();">
                            <i class="fas fa-save"></i>&nbsp;&nbsp;Update Password
                        </button>
                    </div>
                </div>
            </div>

            <div class="cp-help-card">
                <h3 class="cp-help-title"><i class="fas fa-info-circle"></i>Password Tips</h3>
                <ul class="cp-help-list">
                    <li>Use at least 6 characters.</li>
                    <li>Avoid using your name or employee code.</li>
                    <li>Use a mix of letters, numbers, and symbols.</li>
                    <li>Do not share your password with anyone.</li>
                </ul>
            </div>
        </div>
    </div>
</asp:Content>
