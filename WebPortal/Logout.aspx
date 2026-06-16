<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Logout.aspx.cs" Inherits="WebPortal.Logout" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Signed Out - Infinity IPS</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <link rel="stylesheet" href="plugins/fontawesome-free/css/all.min.css" />
    <link rel="stylesheet" href="dist/css/adminlte.min.css" />

    <style>
        :root {
            --logout-primary: #2563eb;
            --logout-primary-dark: #172554;
            --logout-cyan: #06b6d4;
            --logout-border: #dbe5f1;
            --logout-text: #0f172a;
            --logout-muted: #64748b;
            --logout-soft: #eef6ff;
            --logout-shadow: 0 24px 60px rgba(15, 23, 42, .18);
        }

        * {
            box-sizing: border-box;
        }

        html,
        body {
            min-height: 100%;
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
        }

        body.logout-page {
            min-height: 100vh;
            padding: 28px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--logout-text);
            background:
                radial-gradient(circle at 10% 10%, rgba(37, 99, 235, .18), transparent 28%),
                radial-gradient(circle at 90% 18%, rgba(6, 182, 212, .16), transparent 28%),
                linear-gradient(135deg, #eff6ff 0%, #f8fafc 50%, #ecfeff 100%);
            overflow: hidden;
        }

        body.logout-page::before,
        body.logout-page::after {
            content: "";
            position: fixed;
            border-radius: 999px;
            pointer-events: none;
            z-index: 0;
        }

        body.logout-page::before {
            width: 360px;
            height: 360px;
            right: -110px;
            top: -110px;
            background: rgba(37, 99, 235, .14);
        }

        body.logout-page::after {
            width: 260px;
            height: 260px;
            left: -90px;
            bottom: -90px;
            background: rgba(6, 182, 212, .16);
        }

        #form1 {
            width: 100%;
            margin: 0;
            position: relative;
            z-index: 1;
        }

        .logout-shell {
            width: 100%;
            max-width: 520px;
            margin: 0 auto;
        }

        .logout-card {
            overflow: hidden;
            border-radius: 28px;
            background: rgba(255, 255, 255, .86);
            border: 1px solid rgba(219, 229, 241, .9);
            box-shadow: var(--logout-shadow);
            backdrop-filter: blur(16px);
            text-align: center;
        }

        .logout-header {
            padding: 30px 34px;
            color: #fff;
            background: linear-gradient(135deg, #172554 0%, #2563eb 52%, #06b6d4 100%);
        }

        .logo-frame {
            width: 86px;
            height: 86px;
            margin: 0 auto 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 24px;
            background: rgba(255,255,255,.96);
            box-shadow: 0 16px 32px rgba(15, 23, 42, .12);
        }

        .logo-frame img {
            max-width: 68px;
            max-height: 68px;
            object-fit: contain;
        }

        .logout-header h1 {
            margin: 0;
            font-size: 24px;
            font-weight: 900;
            letter-spacing: -.2px;
        }

        .logout-header p {
            margin: 8px 0 0;
            color: rgba(255,255,255,.84);
            font-size: 13px;
            font-weight: 600;
        }

        .logout-body {
            padding: 34px;
            background: #fff;
        }

        .logout-icon {
            width: 76px;
            height: 76px;
            margin: 0 auto 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 24px;
            color: #16a34a;
            background: #ecfdf5;
            border: 1px solid #bbf7d0;
            font-size: 32px;
            box-shadow: 0 12px 26px rgba(22, 163, 74, .12);
        }

        .logout-body h2 {
            margin: 0;
            color: #102a56;
            font-size: 22px;
            font-weight: 900;
        }

        .logout-body .message {
            max-width: 360px;
            margin: 10px auto 24px;
            color: var(--logout-muted);
            font-size: 14px;
            line-height: 1.55;
            font-weight: 600;
        }

        .logout-progress {
            height: 8px;
            overflow: hidden;
            margin: 0 0 22px;
            border-radius: 999px;
            background: #e5edf6;
        }

        .logout-progress span {
            display: block;
            width: 0;
            height: 100%;
            border-radius: inherit;
            background: linear-gradient(135deg, #2563eb 0%, #06b6d4 100%);
            animation: logoutProgress 2.6s linear forwards;
        }

        @keyframes logoutProgress {
            to {
                width: 100%;
            }
        }

        .logout-actions {
            display: flex;
            justify-content: center;
        }

        .btn-login {
            min-width: 180px;
            min-height: 46px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            border-radius: 14px;
            color: #fff !important;
            text-decoration: none !important;
            font-size: 14px;
            font-weight: 900;
            background: linear-gradient(135deg, #2563eb 0%, #06b6d4 100%);
            box-shadow: 0 14px 28px rgba(37, 99, 235, .28);
            transition: .18s ease;
        }

        .btn-login:hover {
            transform: translateY(-1px);
            box-shadow: 0 18px 34px rgba(37, 99, 235, .34);
        }

        .logout-footer {
            margin-top: 20px;
            color: #64748b;
            font-size: 12px;
            font-weight: 700;
        }

        .logout-footer i {
            color: #16a34a;
            margin-right: 5px;
        }

        @media (max-width: 520px) {
            body.logout-page {
                padding: 16px;
            }

            .logout-header,
            .logout-body {
                padding: 28px 22px;
            }

            .logout-card {
                border-radius: 22px;
            }
        }
    </style>

    <script type="text/javascript">
        window.setTimeout(function () {
            window.location.href = "Login.aspx";
        }, 2600);
    </script>
</head>
<body class="logout-page">
    <form id="form1" runat="server">
        <main class="logout-shell">
            <section class="logout-card" aria-labelledby="logoutTitle">
                <div class="logout-header">
                    <div class="logo-frame">
                        <img src="images/logo-login.png" alt="Infinity IPS" />
                    </div>
                    <h1>Infinity IPS</h1>
                    <p>Secure session management</p>
                </div>

                <div class="logout-body">
                    <div class="logout-icon">
                        <i class="fas fa-check"></i>
                    </div>

                    <h2 id="logoutTitle">You have been signed out</h2>
                    <p class="message">Your session has ended successfully. You will be redirected to the login page automatically.</p>

                    <div class="logout-progress" aria-hidden="true">
                        <span></span>
                    </div>

                    <div class="logout-actions">
                        <a class="btn-login" href="Login.aspx">
                            <i class="fas fa-arrow-right-to-bracket"></i>
                            Back to Login
                        </a>
                    </div>

                    <div class="logout-footer">
                        <i class="fas fa-shield-alt"></i>Protected internal workspace
                    </div>
                </div>
            </section>
        </main>
    </form>
</body>
</html>

