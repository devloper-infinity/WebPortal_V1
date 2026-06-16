<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LoginNew.aspx.cs" Inherits="WebPortal.LoginNew" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ERP Login</title>

    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <style>
        body {
            /*background: linear-gradient(to right, #6fa0d6 0%, #4F81BD 50%, #2f5f9e 100%);*/

            background: linear-gradient(to right, #90caf9, 10%, #047edf) !important
        }

        @keyframes gradientMove {
            0% {
                background-position: 0% 50%;
            }

            50% {
                background-position: 100% 50%;
            }

            100% {
                background-position: 0% 50%;
            }
        }
    </style>
</head>

<%--<body class="flex items-center justify-center min-h-screen font-sans">--%>

<body class="flex items-center justify-center min-h-screen font-sans  bg-gradient-to-r from-[#6fa0d6] via-[#4F81BD] to-[#2f5f9e] bg-[length:200%_200%] animate-[gradientMove_8s_ease_infinite]">

    <!-- Toast -->
    <div id="toast" class="hidden fixed top-5 right-5 px-4 py-3 rounded-lg text-white shadow-lg z-50"></div>

    <!-- Loader -->
    <div id="loader" class="hidden fixed inset-0 bg-black/40 flex items-center justify-center z-50">
        <div class="bg-white p-6 rounded-xl shadow-lg flex items-center gap-3">
            <div class="animate-spin rounded-full h-6 w-6 border-b-2 border-blue-600"></div>
            <span class="font-medium text-gray-700">Authenticating...</span>
        </div>
    </div>

    <!-- Card -->
    <div class="bg-white/10 backdrop-blur-xl shadow-2xl rounded-2xl p-8 w-full max-w-md border border-white/30">

        <!-- Message -->
        <div id="loginMessage" class="hidden mb-4 p-3 rounded-lg text-sm font-medium"></div>

        <!-- Header -->
        <div class="text-center mb-6">
            <img src="https://cdn-icons-png.flaticon.com/512/3135/3135715.png" class="w-16 mx-auto mb-3" />
            <h1 class="text-3xl font-bold text-white">Welcome To Infinty ERP</h1>
            <p class="text-white/80 text-sm">Please login</p>
        </div>

        <form onsubmit="loginUser(event)">

            <!-- Username -->
            <div class="mb-4">
                <label class="block text-white text-sm mb-1">Username</label>
                <input id="username" type="text" placeholder="Enter username" style="text-transform: uppercase;"
                    class="w-full px-4 py-2 rounded-lg bg-white/20 text-white placeholder-white/60 
          focus:outline-none focus:ring-2 focus:ring-blue-300">
            </div>

            <!-- Password -->
            <div class="mb-4 relative">
                <label class="block text-white text-sm mb-1">Password</label>
                <input id="password" type="password" placeholder="Enter password"
                    class="w-full px-4 py-2 rounded-lg bg-white/20 text-white placeholder-white/60 
          focus:outline-none focus:ring-2 focus:ring-blue-300">
                <span onclick="togglePassword()" class="absolute right-3 top-9 cursor-pointer text-white/70 hover:text-white">👁️</span>
            </div>

            <!-- Remember -->
            <div class="flex items-center justify-between mb-6 text-sm">
                <label class="flex items-center text-white/80">
                    <input type="checkbox" id="rememberMe" class="mr-2">
                    Remember me
                </label>
                <a href="ForgotPassword.aspx" class="text-blue-200 hover:underline">Forgot Password?</a>
            </div>

            <!-- Button -->
            <button id="loginBtn" type="submit"
                class="w-full bg-gradient-to-r from-blue-500 to-blue-700 
        hover:from-blue-600 hover:to-blue-800 text-white py-2 rounded-lg font-semibold 
        transition flex items-center justify-center shadow-md">

                <span id="btnText">Login</span>
            </button>
        </form>

        <p class="text-center text-white/60 text-xs mt-6">© 2026 ERP System</p>
    </div>


    <script>								

        window.onload = function () {
            const savedUser = localStorage.getItem("erp_username");
            const savedPass = localStorage.getItem("erp_password");

            if (savedUser && savedPass) {
                document.getElementById("username").value = savedUser;
                document.getElementById("password").value = savedPass;
                document.getElementById("rememberMe").checked = true;
            }
        }

        function togglePassword() {
            const pwd = document.getElementById("password");
            pwd.type = pwd.type === "password" ? "text" : "password";
        }

        function showMessage(msg, type) {
            const box = document.getElementById("loginMessage");
            box.classList.remove("hidden");

            if (type === "error") {
                box.className = "mb-4 p-3 rounded-lg text-sm font-medium bg-red-500/20 text-red-200 border border-red-400";
            } else {
                box.className = "mb-4 p-3 rounded-lg text-sm font-medium bg-green-500/20 text-green-200 border border-green-400";
            }

            box.innerHTML = msg;

            setTimeout(() => {
                box.classList.add("hidden");
            }, 4000);
        }

        function showToast(msg, type) {
            const toast = document.getElementById("toast");
            toast.classList.remove("hidden");

            if (type === "error") {
                toast.className = "fixed top-5 right-5 px-4 py-3 rounded-lg text-white bg-red-500 shadow-lg";
            } else {
                toast.className = "fixed top-5 right-5 px-4 py-3 rounded-lg text-white bg-green-500 shadow-lg";
            }

            toast.innerHTML = msg;

            setTimeout(() => {
                toast.classList.add("hidden");
            }, 3000);
        }

        function loginUser(e) {
            e.preventDefault();

            const username = $("#username").val();
            const password = $("#password").val();
            const remember = $("#rememberMe").is(":checked");

            const btn = document.getElementById("loginBtn");
            const text = document.getElementById("btnText");

            btn.disabled = true;
            text.innerHTML = "Authenticating... ⏳";
            $("#loader").removeClass("hidden");

            $.ajax({
                url: "LoginNew.aspx/ValidateUser",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({ username: username, password: password, rememberMe: remember }),

                success: function (res) {
                    const result = res.d;

                    $("#loader").addClass("hidden");

                    if (result.status === "success") {

                        if (remember) {
                            localStorage.setItem("erp_username", username);
                            localStorage.setItem("erp_password", password);
                        } else {
                            localStorage.clear();
                        }
                        window.location.href = result.url;

                        //showToast("Login Successful ✅", "success");								

                        //setTimeout(() => {								
                        //    window.location.href = result.url;								
                        //}, 1000);								
                    }
                    else if (result.status === "redirect") {
                        window.location.href = result.url;
                    }
                    else {
                        showMessage(result.message, "error");
                        /* showToast(result.message, "error");*/
                        btn.disabled = false;
                        text.innerHTML = "Login";
                    }
                },

                error: function (xhr) {
                    $("#loader").addClass("hidden");
                    showToast("Server error", "error");
                    btn.disabled = false;
                    text.innerHTML = "Login";
                    console.log(xhr.responseText);
                }
            });
        }
    </script>
</body>
</html>
