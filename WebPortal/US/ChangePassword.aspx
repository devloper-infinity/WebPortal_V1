<%@ Page Title="" Language="C#" MasterPageFile="~/US/USAdmin.Master" AutoEventWireup="true" CodeBehind="ChangePassword.aspx.cs" Inherits="WebPortal.US.ChangePassword" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        .cp-page {
        }

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
            background: linear-gradient(135deg, #2563eb 0%, #7c3aed 100%);
            box-shadow: 0 14px 32px rgba(21, 98, 228, .24);
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
            /* background: linear-gradient(120deg, #1d4ed8, #2563eb 65%, #22c1dc);*/
            background: linear-gradient(135deg, #2563eb 0%, #7c3aed 100%);
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

            Swal.fire({
                title: "Please wait...",
                text: "Changing your password.",
                allowOutsideClick: false,
                allowEscapeKey: false,
                showConfirmButton: false,
                didOpen: function () {
                    Swal.showLoading();
                }
            });

            PageMethods.ChangePasswords(currentPassword, newPassword, changepassword_OnSuccess, changepassword_OnError);
            return false;
        }

        function changepassword_OnSuccess(result) {
            Swal.close();

            if (result > 0) {
                Swal.fire({
                    icon: "success",
                    title: "Success",
                    text: "Password changed successfully.",
                    confirmButtonColor: "#2563eb"
                });

                changepassword_clear();
            }
            else if (result == -1) {
                Swal.fire({
                    icon: "warning",
                    title: "Wrong Password",
                    text: "You have entered wrong current password.",
                    confirmButtonColor: "#f59e0b"
                });
            }
            else {
                Swal.fire({
                    icon: "error",
                    title: "Error",
                    text: "Error occurred while changing password. Please contact administrator.",
                    confirmButtonColor: "#dc2626"
                });
            }

            return false;
        }

        function changepassword_OnError(error) {
            Swal.close();

            Swal.fire({
                icon: "error",
                title: "Error",
                text: error && error.responseText ? error.responseText : "Unable to change password.",
                confirmButtonColor: "#dc2626"
            });

            return false;
        }

        function changepassword_showValidation(message) {
            Swal.fire({
                icon: "warning",
                title: "Validation",
                text: message,
                confirmButtonColor: "#f59e0b"
            });
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


<%--<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .loading {
            display: none;
            position: fixed;
            top: 350px;
            left: 50%;
            margin-top: -96px;
            margin-left: -96px;
            /*  background-color: #ccc;*/
            opacity: .85;
            border-radius: 25px;
            width: 192px;
            height: 192px;
            z-index: 99999;
        }
    </style>

    <script>
        function changepassword_submit() {

            var changepassword_currentpassword = document.getElementById("changepassword_currentpassword").value;
            var changepassword_newpassword = document.getElementById("changepassword_newpassword").value;
            var changepassword_confirmnewpassword = document.getElementById("changepassword_confirmnewpassword").value;

            //var changepassword_currentpassword = document.getElementById("currentPassword").value;
            //var changepassword_newpassword = document.getElementById("newPassword").value;
            //var changepassword_confirmnewpassword = document.getElementById("confirmPassword").value;

            if (changepassword_currentpassword == "") {
                alert("Please enter current password.");
                return false;
            }
            if (changepassword_newpassword == "") {
                alert("Please enter new password.");
                return false;
            }
            if (changepassword_confirmnewpassword == "") {
                alert("Please enter confirm password.");
                return false;
            }
            if (changepassword_confirmnewpassword != changepassword_newpassword) {
                alert("New password and confirm password should be same.");
                return false;
            }


            PageMethods.ChangePasswords(changepassword_currentpassword, changepassword_newpassword, changepassword_OnSuccess, changepassword_OnError);

            return false;
        }

        function changepassword_OnSuccess(result) {
            if (result > 0) {
                Swal.fire({
                    icon: 'success',
                    title: 'Success',
                    text: 'Password changed successfully',
                    zIndex: 999999
                });
                $("#changepassword_currentpassword").val('');
                $("#changepassword_newpassword").val('');
                $("#changepassword_confirmnewpassword").val('');
            }
            else if (result == -1) {

                Swal.fire({
                    icon: 'warning',
                    title: 'Warning',
                    text: 'Oops! You have entered wrong password!',
                    zIndex: 999999
                });

            }
            else {

                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'Oops! Error occured while changing password. Please contact administrator!',
                    zIndex: 999999
                });
            }

            return false;

        }

        function changepassword_OnError(error) {

            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: error.responseText,
                zIndex: 999999
            });
            return false;
        }

    </script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Change Password</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
  
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
           
                <table class="table">
                    <tr>
                        <td><b>Current Password:</b></td>
                        <td>
                            <input type="password" id="changepassword_currentpassword" name="changepassword_currentpassword" class="form-control" style="width: 350px;" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>New Password:</b></td>
                        <td>
                            <input type="password" id="changepassword_newpassword" name="changepassword_newpassword" class="form-control" style="width: 350px;" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Confirm New Password:</b></td>
                        <td>
                            <input type="password" id="changepassword_confirmnewpassword" name="changepassword_confirmnewpassword" class="form-control" style="width: 350px;" />
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <button type="submit" id="changepassword_btnsubmit" class="btn btn-primary" onclick="return changepassword_submit();" style="width: 350px;">Submit</button>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="cp_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="cp_btnMessage" onclick="return cp_Message();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

</asp:Content>--%>
