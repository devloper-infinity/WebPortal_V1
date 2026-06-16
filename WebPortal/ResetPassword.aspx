<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ResetPassword.aspx.cs" Inherits="WebPortal.ResetPassword" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Reset Password</title>

    <!-- SweetAlert -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script>

        var username;

        window.onload = function () {
            const userId = new URLSearchParams(window.location.search).get('UserId');
            username = userId;
        };


        function toggle(id) {
            let x = document.getElementById(id);
            x.type = x.type === "password" ? "text" : "password";
        }

        function core_checkPassword() {
            let val = document.getElementById("txtNew").value;

            let upper = /[A-Z]/.test(val);
            let lower = /[a-z]/.test(val);
            let number = /[0-9]/.test(val);
            let special = /[@$!%*?&]/.test(val);
            let length = val.length >= 8;

            update("upper", upper);
            update("lower", lower);
            update("number", number);
            update("special", special);
            update("length", length);

            let score = [upper, lower, number, special, length].filter(v => v).length;
            let bar = document.getElementById("bar");

            bar.style.width = (score * 20) + "%";
            bar.style.background = score < 3 ? "red" : score < 5 ? "orange" : "green";
        }

        function checkPassword() {
            let val = document.getElementById("txtNew").value;

            // ❌ Block % character using Swal
            if (val.includes("%")) {

                Swal.fire({
                    icon: 'error',
                    title: 'Invalid Character',
                    text: "'%' is not allowed in password",
                    confirmButtonColor: '#d33'
                });

                document.getElementById("txtNew").value = val.replace(/%/g, "");
                return;
            }

            let upper = /[A-Z]/.test(val);
            let lower = /[a-z]/.test(val);
            let number = /[0-9]/.test(val);

            // ✅ Removed % from special characters
            let special = /[@$!*?&]/.test(val);

            let length = val.length >= 8;

            update("upper", upper);
            update("lower", lower);
            update("number", number);
            update("special", special);
            update("length", length);

            let score = [upper, lower, number, special, length].filter(v => v).length;
            let bar = document.getElementById("bar");

            bar.style.width = (score * 20) + "%";
            bar.style.background = score < 3 ? "red" : score < 5 ? "orange" : "green";
        }

        function update(id, valid) {
            let el = document.getElementById(id);
            if (valid) el.classList.add("valid");
            else el.classList.remove("valid");
        }

        function resetPassword() {
            let current = document.getElementById("txtCurrent").value;
            let newPass = document.getElementById("txtNew").value;
            let confirm = document.getElementById("txtConfirm").value;

            if (!current || !newPass || !confirm) {
                Swal.fire("Error", "All fields required", "error");
                return;
            }

            if (newPass !== confirm) {
                Swal.fire("Error", "Passwords do not match", "error");
                return;
            }

            PageMethods.ResetUserPassword(username, newPass, function (res) {
                if (res === "Success") {
                    Swal.fire({
                        title: "Password Updated",
                        text: "Please login with your new Password",
                        icon: "success",
                        confirmButtonText: "OK"
                    }).then((result) => {
                        if (result.isConfirmed) {
                            document.getElementById("txtCurrent").value = "";
                            document.getElementById("txtNew").value = "";
                            document.getElementById("txtConfirm").value = "";
                            window.location.href = "Login.aspx"; // 🔁 change to your page
                        }
                    });


                } else {
                    Swal.fire("Error", res, "error");
                }
            });
        }
    </script>

    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI';
            /*  background: #f5f7fb;*/
            /*  background: linear-gradient(to right, #90caf9, 10%, #047edf);*/
            background: linear-gradient(135deg, #1e3a8a, #9333ea);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .card {
            background: #fff;
            padding: 30px;
            width: 500px;
            border-radius: 12px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
        }

        /* Input Group */
        .input-group {
            position: relative;
            margin-bottom: 20px;
        }

            .input-group input {
                width: 80%;
                padding: 14px 40px 14px 12px;
                border: 1px solid #ddd;
                border-radius: 8px;
                background: #fafafa;
                border-color: black;
                outline: none;
                transition: 0.3s;
            }

                .input-group input:focus {
                    background: #fff;
                    border-color: #2196f3;
                    box-shadow: 0 0 6px rgba(33,150,243,0.2);
                }

            /* Floating Label */
            .input-group label {
                position: absolute;
                left: 12px;
                top: 14px;
                color: #888;
                font-size: 14px;
                transition: 0.3s;
                background: #fff;
                padding: 0 5px;
            }

            .input-group input:focus + label,
            .input-group input:valid + label {
                top: -8px;
                font-size: 12px;
                color: #2196f3;
            }

        /* Eye Icon */
        .eye {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
        }

        /* Password Rules */
        .rules span {
            display: block;
            font-size: 13px;
            color: #888;
        }

        .rules {
            padding-bottom: 5%;
        }

        .valid {
            color: green;
            font-weight: 500;
        }

        /* Strength Bar */
        .strength-bar {
            height: 6px;
            border-radius: 5px;
            margin-top: 5px;
            width: 60%;
        }

        /* Button */
        button {
            width: 70%;
            padding: 12px;
            border: none;
            border-radius: 8px;
            background: #047edf;
            color: #fff;
            /* font-weight: bold;*/
            cursor: pointer;
        }

        .btn-container {
            text-align: center;
        }

        button:hover {
            background: #047edf;
            font-weight: bold;
        }
    </style>

</head>

<body>
    <form runat="server">

        <asp:ScriptManager runat="server" EnablePageMethods="true" />

        <div class="card">
            <h2>🔐 Reset Password</h2>

            <div class="input-group">
                <input type="password" id="txtCurrent" required />
                <label>Current Password</label>
                <span class="eye" onclick="toggle('txtCurrent')">👁️</span>
            </div>

            <div class="input-group">
                <input type="password" id="txtNew" required onkeyup="checkPassword()" />
                <label>New Password</label>
                <span class="eye" onclick="toggle('txtNew')">👁️</span>
                <div id="bar" class="strength-bar"></div>
            </div>

            <div class="rules">
                <span id="upper">✔ Uppercase</span>
                <span id="lower">✔ Lowercase</span>
                <span id="number">✔ Number</span>
                <span id="special">✔ Special Character (Please do not use '%')</span>
                <span id="length">✔ Min 8 Characters</span>
            </div>

            <div class="input-group">
                <input type="password" id="txtConfirm" required />
                <label>Confirm Password</label>
                <span class="eye" onclick="toggle('txtConfirm')">👁️</span>
            </div>
            <div class="btn-container">
                <button type="button" onclick="resetPassword()">Update Password</button>
            </div>
        </div>
    </form>
</body>
</html>

