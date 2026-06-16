<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LogoutNew.aspx.cs" Inherits="WebPortal.LogoutNew" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Logout | ERP</title>

    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', sans-serif;
            /* background: linear-gradient(135deg, #667eea, #764ba2);*/
            background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            color: white;
        }

        .logout-box {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            padding: 40px;
            border-radius: 20px;
            text-align: center;
            width: 350px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            animation: fadeIn 0.5s ease-in-out;
        }

            .logout-box h2 {
                margin-bottom: 10px;
            }

            .logout-box p {
                opacity: 0.8;
            }

        .btn {
            margin-top: 20px;
            padding: 12px 25px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-size: 14px;
            transition: 0.3s;
        }

        .btn-logout {
            /*  background: #ff4b5c;*/
            background: linear-gradient(to right, #6390F8,10%,  #2765F5) !important;
            color: white;
        }

        .btn-cancel {
            background: #33C6F2;
            color: #333;
            margin-left: 10px;
        }

        .btn:hover {
            transform: scale(1.05);
        }

        .loader {
            display: none;
            margin-top: 20px;
        }

        .spinner {
            border: 4px solid rgba(255,255,255,0.2);
            border-top: 4px solid white;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            animation: spin 1s linear infinite;
            margin: auto;
        }

        @keyframes spin {
            100% {
                transform: rotate(360deg);
            }
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>

<body>

    <form id="form1" runat="server">

        <div class="logout-box">
            <h2>Logout</h2>
            <p>Are you sure you want to logout?</p>

            <button type="button" class="btn btn-logout" onclick="logoutUser()">Logout</button>
            <button type="button" class="btn btn-cancel" onclick="goBack()">Cancel</button>

            <div class="loader" id="loader">
                <div class="spinner"></div>
                <p>Logging out...</p>
            </div>
        </div>

    </form>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script>
        function logoutUser() {

            $("#loader").show();

            $.ajax({
                type: "POST",
                url: "LogoutNew.aspx/DoLogout",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function () {

                    setTimeout(function () {
                        window.location.href = "LoginNew.aspx";
                    }, 1200);
                },
                error: function () {
                    alert("Logout failed!");
                    $("#loader").hide();
                }
            });
        }

        function goBack() {
            window.history.back();
        }

        function quickLogout() {
            $.post("Logout.aspx/DoLogout", function () {
                window.location.href = "LoginNew.aspx";
            });
        }
    </script>

</body>
</html>
