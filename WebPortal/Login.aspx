<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="WebPortal.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Welcome To Infinity IPS</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700,800&display=fallback" />
    <link rel="stylesheet" href="plugins/fontawesome-free/css/all.min.css" />
    <link rel="stylesheet" href="plugins/icheck-bootstrap/icheck-bootstrap.min.css" />
    <link rel="stylesheet" href="dist/css/adminlte.min.css" />

    <style>
        :root {
            --login-primary: #2563eb;
            --login-primary-dark: #172554;
            --login-cyan: #06b6d4;
            --login-bg: #f3f7fb;
            --login-card: #ffffff;
            --login-border: #dbe5f1;
            --login-text: #0f172a;
            --login-muted: #64748b;
            --login-soft: #eef6ff;
            --login-shadow: 0 24px 60px rgba(15, 23, 42, .18);
        }

        * {
            box-sizing: border-box;
        }

        html,
        body {
            min-height: 100%;
            margin: 0;
            font-family: "Source Sans Pro", "Segoe UI", Arial, sans-serif;
            overflow-x: hidden;
        }

            body.login-page {
                min-height: 100vh;
                background: radial-gradient(circle at 10% 10%, rgba(37, 99, 235, .18), transparent 28%), radial-gradient(circle at 90% 18%, rgba(6, 182, 212, .16), transparent 28%), linear-gradient(135deg, #eff6ff 0%, #f8fafc 50%, #ecfeff 100%);
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 28px;
                color: var(--login-text);
            }

        .login-shell {
            width: 100%;
            /*max-width: 1180px;
            min-height: 640px;*/
            /*   max-width: 80%;
            min-height: 50%;*/
            display: grid;
            grid-template-columns: minmax(0, 1.1fr) 430px;
            border-radius: 28px;
            overflow: hidden;
            background: rgba(255,255,255,.72);
            border: 1px solid rgba(219, 229, 241, .9);
            box-shadow: var(--login-shadow);
            backdrop-filter: blur(16px);
            position: relative;
            width: 80%;
            height: 50%;
        }

            .login-shell::before {
                padding:20%;
                content: "";
                position: absolute;
                inset: 0;
                pointer-events: none;
                border-radius: 28px;
                box-shadow: inset 0 1px 0 rgba(255,255,255,.72);
            }

        .login-visual {
            position: relative;
            padding: 46px;
            color: #fff;
            background: linear-gradient(135deg, rgba(23,37,84,.96) 0%, rgba(37,99,235,.92) 58%, rgba(6,182,212,.88) 100%), url("images/login-bg.jpg");
            background-size: cover;
            background-position: center;
            overflow: hidden;
        }

            .login-visual::before,
            .login-visual::after {
                content: "";
                position: absolute;
                border-radius: 999px;
                background: rgba(255,255,255,.11);
                filter: blur(.2px);
            }

            .login-visual::before {
                width: 260px;
                height: 260px;
                right: -80px;
                top: -70px;
            }

            .login-visual::after {
                width: 180px;
                height: 180px;
                left: -55px;
                bottom: -45px;
            }

        .brand-content {
            position: relative;
            z-index: 1;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            gap: 32px;
        }

        .brand-badge {
            width: max-content;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 10px 14px;
            border-radius: 999px;
            background: rgba(255,255,255,.16);
            border: 1px solid rgba(255,255,255,.22);
            font-size: 13px;
            font-weight: 800;
            letter-spacing: .2px;
        }

        .brand-title h1 {
            margin: 0;
            max-width: 560px;
            font-size: 46px;
            line-height: 1.05;
            font-weight: 800;
            letter-spacing: -.8px;
        }

        .brand-title p {
            max-width: 540px;
            margin: 18px 0 0;
            color: rgba(255,255,255,.84);
            font-size: 15px;
            line-height: 1.65;
            font-weight: 500;
        }

        .feature-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 14px;
        }

        .feature-card {
            min-height: 112px;
            padding: 16px;
            border-radius: 18px;
            background: rgba(255,255,255,.13);
            border: 1px solid rgba(255,255,255,.20);
            box-shadow: 0 16px 36px rgba(15, 23, 42, .10);
        }

            .feature-card i {
                width: 34px;
                height: 34px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                border-radius: 12px;
                background: rgba(255,255,255,.16);
                margin-bottom: 12px;
            }

            .feature-card span {
                display: block;
                font-size: 12px;
                line-height: 1.4;
                font-weight: 800;
                color: rgba(255,255,255,.92);
            }

        .login-panel {
            background: #fff;
            padding: 44px 40px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-card {
            width: 100%;
            max-width: 360px;
        }

        .logo-box {
            text-align: center;
            margin-bottom: 28px;
        }

        .logo-frame {
            width: 86px;
            height: 86px;
            margin: 0 auto 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 24px;
            background: linear-gradient(135deg, #ffffff, #f8fbff);
            border: 1px solid var(--login-border);
            box-shadow: 0 16px 32px rgba(15, 23, 42, .08);
        }

            .logo-frame img {
                max-width: 66px;
                max-height: 66px;
                object-fit: contain;
            }

        .logo-box h2 {
            margin: 0;
            color: #102a56;
            font-size: 25px;
            font-weight: 900;
            letter-spacing: -.2px;
        }

        .logo-box p {
            margin: 7px 0 0;
            color: var(--login-muted);
            font-size: 13px;
            font-weight: 600;
        }

        #dvError {
            margin-bottom: 16px;
            border-radius: 14px;
            font-size: 13px;
            font-weight: 700;
        }

        .auth-loader {
            display: none;
            margin-bottom: 14px;
            padding: 10px 12px;
            border-radius: 14px;
            background: var(--login-soft);
            color: var(--login-primary);
            font-size: 13px;
            font-weight: 800;
            text-align: center;
        }

            .auth-loader span {
                width: 13px;
                height: 13px;
                margin-right: 8px;
                display: inline-block;
                border-radius: 50%;
                border: 2px solid rgba(37, 99, 235, .25);
                border-top-color: var(--login-primary);
                animation: spin .75s linear infinite;
                vertical-align: -2px;
            }

        @keyframes spin {
            to {
                transform: rotate(360deg);
            }
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            color: #102a56;
            font-size: 12px;
            font-weight: 900;
            letter-spacing: .2px;
        }

        .login-field {
            margin-bottom: 16px;
        }

        .login-input {
            position: relative;
        }

            .login-input .form-control {
                width: 100%;
                min-height: 48px;
                padding: 11px 46px 11px 14px;
                border: 1px solid #cbd5e1;
                border-radius: 14px;
                background: #fff;
                color: var(--login-text);
                font-size: 14px;
                font-weight: 700;
                box-shadow: none;
                transition: .18s ease;
            }

                .login-input .form-control:focus {
                    border-color: var(--login-primary);
                    box-shadow: 0 0 0 4px rgba(37, 99, 235, .12);
                }

        .login-input-icon {
            position: absolute;
            right: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: #64748b;
            font-size: 14px;
            pointer-events: none;
        }

        .login-options {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin: 2px 0 18px;
        }

        .remember-box {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #334155;
            font-size: 13px;
            font-weight: 800;
            user-select: none;
        }

            .remember-box input {
                width: 16px;
                height: 16px;
                accent-color: var(--login-primary);
            }

        .forgot-link {
            color: var(--login-primary);
            font-size: 13px;
            font-weight: 900;
            text-decoration: none;
        }

            .forgot-link:hover {
                color: var(--login-primary-dark);
                text-decoration: underline;
            }

        .btn-login-primary {
            width: 100%;
            min-height: 48px;
            border: 0 !important;
            border-radius: 14px !important;
            background: linear-gradient(135deg, #2563eb 0%, #06b6d4 100%) !important;
            color: #fff !important;
            font-size: 14px !important;
            font-weight: 900 !important;
            letter-spacing: .2px;
            box-shadow: 0 14px 28px rgba(37, 99, 235, .28) !important;
            transition: .18s ease !important;
        }

            .btn-login-primary:hover {
                transform: translateY(-1px);
                box-shadow: 0 18px 34px rgba(37, 99, 235, .34) !important;
            }

        .btn-authenticating {
            opacity: .88;
            cursor: wait !important;
        }

        .login-footer {
            margin-top: 22px;
            padding-top: 18px;
            border-top: 1px solid #eef2f7;
            text-align: center;
            color: #64748b;
            font-size: 12px;
            font-weight: 700;
        }

            .login-footer i {
                color: #16a34a;
                margin-right: 6px;
            }

        @media (max-width: 980px) {
            body.login-page {
                padding: 18px;
            }

            .login-shell {
                grid-template-columns: 1fr;
                max-width: 520px;
            }

            .login-visual {
                padding: 34px;
            }

            .brand-title h1 {
                font-size: 34px;
            }

            .feature-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 520px) {
            body.login-page {
                padding: 0;
                align-items: stretch;
            }

            .login-shell {
                min-height: 100vh;
                border-radius: 0;
            }

            .login-visual {
                padding: 26px 22px;
            }

            .login-panel {
                padding: 32px 22px;
            }

            .brand-title h1 {
                font-size: 30px;
            }
        }
    </style>
</head>
<body class="login-page">
    <div class="login-shell">
        <section class="login-visual">
            <div class="brand-content">
                <div>
                    <div class="brand-badge">
                        <i class="fas fa-shield-alt"></i>
                        Secure Access Portal
                    </div>

                    <div class="brand-title">
                        <h1>Welcome to Infinity IPS</h1>
                        <p>Access your enterprise dashboard, employee services, assets, reports, and helpdesk tools from one secure workspace.</p>
                    </div>
                </div>

                <div class="feature-grid">
                    <div class="feature-card">
                        <i class="fas fa-chart-line"></i>
                        <span>Dashboard and productivity insights</span>
                    </div>
                    <div class="feature-card">
                        <i class="fas fa-user-lock"></i>
                        <span>Secure sign-in for authorized users</span>
                    </div>
                    <div class="feature-card">
                        <i class="fas fa-headset"></i>
                        <span>Service desk and reporting access</span>
                    </div>
                </div>
            </div>
        </section>

        <section class="login-panel">
            <div class="login-card">
                <div class="logo-box">
                    <div class="logo-frame">
                        <img src="images/logo-login.png" alt="Company Logo" />
                    </div>
                    <h2>Sign In</h2>
                    <p>Use your account credentials to continue</p>
                </div>

                <div id="dvError" runat="server" role="alert"></div>

                <div id="authLoader" class="auth-loader">
                    <span></span>Authenticating...
                </div>

                <form id="form1" runat="server">
                    <div class="login-field">
                        <label class="form-label" for="<%= txtUserName.ClientID %>">Username</label>
                        <div class="login-input">
                            <asp:TextBox ID="txtUserName" runat="server" placeholder="Enter username" required="required" title="Please enter username" autocomplete="off" Style="text-transform: uppercase;" CssClass="form-control"></asp:TextBox>
                            <i class="fas fa-user login-input-icon"></i>
                        </div>
                    </div>

                    <div class="login-field">
                        <label class="form-label" for="<%= txtPassword.ClientID %>">Password</label>
                        <div class="login-input">
                            <asp:TextBox ID="txtPassword" runat="server" placeholder="Enter password" TextMode="Password" CssClass="form-control" required="required"></asp:TextBox>
                            <i class="fas fa-lock login-input-icon"></i>
                        </div>
                    </div>

                    <div class="login-options">
                        <label class="remember-box" for="chkRemember">
                            <input type="checkbox" id="chkRemember" runat="server" />
                            Remember me
                        </label>
                        <a href="ForgotPassword.aspx" class="forgot-link">Forgot?</a>
                    </div>

                    <asp:Button ID="btnSubmit" runat="server" Text="Sign In" CssClass="btn btn-login-primary" OnClientClick="showAuthenticatingEffect(this);" OnClick="btnSubmit_Click" />
                </form>

                <div class="login-footer">
                    <i class="fas fa-check-circle"></i>Protected internal workspace
                </div>
            </div>
        </section>
    </div>

    <script src="plugins/jquery/jquery.min.js"></script>
    <script src="plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="dist/js/adminlte.min.js"></script>
    <script>
        function showAuthenticatingEffect(btn) {
            var loader = document.getElementById('authLoader');

            if (loader) {
                loader.style.display = 'block';
            }

            btn.value = 'Authenticating...';
            btn.classList.add('btn-authenticating');

            return true;
        }
    </script>
</body>
</html>
