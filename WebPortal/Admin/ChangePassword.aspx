<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ChangePassword.aspx.cs" Inherits="WebPortal.Admin.ChangePassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
    <%--   <div class="col-lg-12">
        <div class="card">
            <div class="card-body">

                  <h2>Change Password</h2>

                <div class="form-group">
                    <label><b>Current Password</b></label>
                    <input type="password" id="currentPassword" placeholder="Current Password">
                    <span class="toggle" onclick="togglePassword('currentPassword')">Show</span>
                    <div class="error" id="currentError"></div>
                </div>

                <div class="form-group">
                    <input type="password" id="newPassword" placeholder="New Password">
                    <span class="toggle" onclick="togglePassword('newPassword')">Show</span>
                    <div class="error" id="newError"></div>
                </div>

                <div class="form-group">
                    <input type="password" id="confirmPassword" placeholder="Confirm Password">
                    <span class="toggle" onclick="togglePassword('confirmPassword')">Show</span>
                    <div class="error" id="confirmError"></div>
                </div>

                <button onclick="changePassword()">Change Password</button>

                <div class="success" id="successMsg"></div>
            </div>
        </div>
    </div>--%>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <%-- <div class="form-group mb-3 position-relative">
                    <label><b>Current Password</b></label>
                    <input type="password" id="currentPassword" class="form-control" style="width: 350px;" placeholder="Enter current password">
                    <span class="toggle" onclick="togglePassword('currentPassword')">👁</span>
                    <div class="error" id="currentError"></div>
                </div>

                <div class="form-group mb-3 position-relative">
                    <label><b>New Password</b></label>
                    <input type="password" id="newPassword" class="form-control" style="width: 350px;" placeholder="Enter new password">
                    <span class="toggle" onclick="togglePassword('newPassword')">👁</span>
                    <div class="error" id="newError"></div>
                </div>

                <div class="form-group mb-3 position-relative">
                    <label><b>Confirm Password</b></label>
                    <input type="password" id="confirmPassword" class="form-control" style="width: 350px;" placeholder="Confirm new password">
                    <span class="toggle" onclick="togglePassword('confirmPassword')">👁</span>
                    <div class="error" id="confirmError"></div>
                </div><button class="btn btn-primary w-100" onclick="changepassword_submit()" >Change Password</button>

<div class="success mt-3 text-center" id="successMsg"></div>--%>
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
                    <h6 class="modal-title" id="cp_errmsg"></h6>
                    <%--<button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>--%>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="cp_btnMessage" onclick="return cp_Message();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

    <style>
        /* body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #4facfe, #00f2fe);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }*/

        /*  .card {
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            width: 350px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }*/

        /* h2 {
            text-align: center;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 15px;
            position: relative;
        }

        input {
            width: 30%;
            padding: 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 14px;
        }

            input:focus {
                border-color: #4facfe;
                outline: none;
            }

        .toggle {
            position: unset;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            font-size: 12px;
            color: #555;
        }

        .error {
            color: red;
            font-size: 12px;
            margin-top: 3px;
        }

        .success {
            color: green;
            text-align: center;
            margin-top: 10px;
        }

        button {
            width: 300px;
            padding: 10px;
            background: #4facfe;
            border: none;
            color: white;
            font-size: 16px;
            border-radius: 6px;
            cursor: pointer;
            transition: 0.3s;
        }

            button:hover {
                background: #00c6ff;
            }*/
    </style>

    <%--   <table class="table">
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
               <td colspan="2" style="text-align:center;">
                   <button id="changepassword_btnsubmit" class="btn btn-primary" onclick="return changepassword_submit();">Submit</button> 
               </td>
           </tr>
       </table>--%>
</asp:Content>
