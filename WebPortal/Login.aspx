<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="WebPortal.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <title>Welcome To Infinity IPS | Enterprise Portal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Source+Sans+Pro:wght@400;600;700&display=swap" rel="stylesheet" />

    <!-- Core Styles -->
    <link rel="stylesheet" href="plugins/fontawesome-free/css/all.min.css" />
    <link rel="stylesheet" href="dist/css/adminlte.min.css" />

    <style>
        :root {
            --brand-primary: #2563eb;
            --brand-primary-hover: #1d4ed8;
            --brand-navy-dark: #0b192c;
            --brand-navy: #172554;
            --brand-navy-mid: #1e3a8a;
            --brand-cyan: #06b6d4;
            --brand-cyan-light: #38bdf8;
            --brand-cyan-glow: rgba(6, 182, 212, 0.25);
            --brand-blue-glow: rgba(37, 99, 235, 0.25);
            --bg-canvas: #f0f6fc;
            --card-bg: #ffffff;
            --card-border: rgba(219, 229, 241, 0.85);
            --text-heading: #0f172a;
            --text-body: #334155;
            --text-muted: #64748b;
            --text-light: #94a3b8;
            --input-border: #cbd5e1;
            --input-focus-border: #2563eb;
            --status-success: #10b981;
            --shadow-sm: 0 2px 8px rgba(15, 23, 42, 0.04);
            --shadow-md: 0 12px 30px -6px rgba(15, 23, 42, 0.08);
            --shadow-card: 0 25px 60px -15px rgba(15, 23, 42, 0.16), 0 0 0 1px rgba(219, 229, 241, 0.7);
        }

        *, *::before, *::after {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        html, body {
            min-height: 100%;
            height: 100%;
            font-family: 'Plus Jakarta Sans', 'Source Sans Pro', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background-color: var(--bg-canvas);
            color: var(--text-heading);
            overflow-x: hidden;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }

        /* Ambient Animated Mesh Background */
        body.login-page {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 32px 20px;
            position: relative;
            background: 
                radial-gradient(ellipse 70% 50% at 15% 15%, rgba(37, 99, 235, 0.16), transparent 70%),
                radial-gradient(ellipse 60% 50% at 85% 20%, rgba(6, 182, 212, 0.14), transparent 65%),
                radial-gradient(ellipse 50% 60% at 50% 90%, rgba(30, 58, 138, 0.10), transparent 70%),
                linear-gradient(140deg, #eff6ff 0%, #f8fafc 45%, #ecfeff 100%);
            background-attachment: fixed;
        }

        /* Subtle Grid Pattern Overlay */
        .bg-grid-overlay {
            position: fixed;
            inset: 0;
            background-size: 36px 36px;
            background-image: 
                linear-gradient(to right, rgba(37, 99, 235, 0.035) 1px, transparent 1px),
                linear-gradient(to bottom, rgba(37, 99, 235, 0.035) 1px, transparent 1px);
            pointer-events: none;
            z-index: 0;
        }

        /* Ambient Floating Glowing Blobs */
        .ambient-blob {
            position: fixed;
            border-radius: 50%;
            filter: blur(80px);
            pointer-events: none;
            z-index: 0;
            opacity: 0.65;
            animation: floatSlow 18s ease-in-out infinite alternate;
        }

        .blob-1 {
            width: 440px;
            height: 440px;
            background: radial-gradient(circle, rgba(37, 99, 235, 0.28) 0%, rgba(6, 182, 212, 0.08) 70%, transparent 100%);
            top: -120px;
            left: -80px;
        }

        .blob-2 {
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, rgba(6, 182, 212, 0.25) 0%, rgba(37, 99, 235, 0.08) 70%, transparent 100%);
            bottom: -100px;
            right: -80px;
            animation-duration: 22s;
            animation-delay: -5s;
        }

        @keyframes floatSlow {
            0% { transform: translate(0, 0) scale(1); }
            50% { transform: translate(35px, 25px) scale(1.06); }
            100% { transform: translate(-25px, 35px) scale(0.96); }
        }

        /* Main Login Shell Container */
        .login-shell {
            width: 100%;
            max-width: 1080px;
            min-height: 580px;
            display: grid;
            grid-template-columns: minmax(0, 1.15fr) minmax(380px, 440px);
            border-radius: 24px;
            background: rgba(255, 255, 255, 0.88);
            border: 1px solid rgba(255, 255, 255, 0.95);
            box-shadow: var(--shadow-card);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            position: relative;
            z-index: 1;
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        /* ============================================================
           LEFT PANEL - BRAND VISUAL & ENTERPRISE SHOWCASE
           ============================================================ */
        .login-visual {
            position: relative;
            padding: 48px 44px;
            color: #ffffff;
            background: 
                radial-gradient(circle at top right, rgba(6, 182, 212, 0.38), transparent 50%),
                radial-gradient(circle at bottom left, rgba(37, 99, 235, 0.42), transparent 55%),
                linear-gradient(145deg, #0b192c 0%, #172554 38%, #1e40af 75%, #0284c7 100%);
            overflow: hidden;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .login-visual::before {
            content: "";
            position: absolute;
            width: 380px;
            height: 380px;
            border-radius: 50%;
            border: 1px solid rgba(255, 255, 255, 0.12);
            top: -120px;
            right: -100px;
            pointer-events: none;
        }

        .login-visual::after {
            content: "";
            position: absolute;
            width: 260px;
            height: 260px;
            border-radius: 50%;
            border: 1px solid rgba(6, 182, 212, 0.22);
            bottom: -60px;
            left: -50px;
            pointer-events: none;
        }

        .visual-pattern {
            position: absolute;
            inset: 0;
            background-image: radial-gradient(rgba(255, 255, 255, 0.12) 1px, transparent 1px);
            background-size: 24px 24px;
            opacity: 0.35;
            pointer-events: none;
        }

        .brand-content {
            position: relative;
            z-index: 2;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            gap: 36px;
        }

        .brand-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 7px 15px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.12);
            border: 1px solid rgba(255, 255, 255, 0.22);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            font-size: 12.5px;
            font-weight: 600;
            letter-spacing: 0.3px;
            color: #ffffff;
            box-shadow: 0 4px 14px rgba(0, 0, 0, 0.08);
            width: max-content;
        }

        .status-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background-color: #34d399;
            box-shadow: 0 0 10px #34d399;
            animation: pulseGreen 2s infinite;
        }

        @keyframes pulseGreen {
            0% { box-shadow: 0 0 0 0 rgba(52, 211, 153, 0.7); }
            70% { box-shadow: 0 0 0 8px rgba(52, 211, 153, 0); }
            100% { box-shadow: 0 0 0 0 rgba(52, 211, 153, 0); }
        }

        .brand-title {
            margin-top: 18px;
        }

        .brand-title h1 {
            font-size: 38px;
            line-height: 1.15;
            font-weight: 800;
            letter-spacing: -0.8px;
            color: #ffffff;
            margin: 0;
        }

        .brand-title h1 span.gradient-text {
            background: linear-gradient(120deg, #ffffff 30%, #7dd3fc 80%, #38bdf8 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            display: inline-block;
        }

        .brand-title p {
            margin: 14px 0 0;
            color: rgba(255, 255, 255, 0.82);
            font-size: 14.5px;
            line-height: 1.6;
            font-weight: 400;
            max-width: 480px;
        }

        .feature-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
            margin-top: 10px;
        }

        .feature-card {
            padding: 16px 14px;
            border-radius: 16px;
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.16);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
            transition: all 0.25s ease;
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
        }

        .feature-card:hover {
            background: rgba(255, 255, 255, 0.14);
            border-color: rgba(255, 255, 255, 0.28);
            transform: translateY(-2px);
        }

        .feature-icon-box {
            width: 36px;
            height: 36px;
            border-radius: 10px;
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.22) 0%, rgba(255, 255, 255, 0.08) 100%);
            border: 1px solid rgba(255, 255, 255, 0.25);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 10px;
            color: #7dd3fc;
            font-size: 14px;
        }

        .feature-card span.feature-label {
            font-size: 12px;
            font-weight: 700;
            color: #ffffff;
            line-height: 1.35;
        }

        .feature-card span.feature-desc {
            font-size: 11px;
            font-weight: 400;
            color: rgba(255, 255, 255, 0.72);
            margin-top: 3px;
            line-height: 1.3;
        }

        .visual-footer {
            display: flex;
            align-items: center;
            gap: 10px;
            padding-top: 14px;
            border-top: 1px solid rgba(255, 255, 255, 0.14);
            font-size: 12px;
            color: rgba(255, 255, 255, 0.75);
            font-weight: 500;
        }

        .visual-footer i {
            color: #38bdf8;
        }

        /* ============================================================
           RIGHT PANEL - LOGIN FORM
           ============================================================ */
        .login-panel {
            background: #ffffff;
            padding: 44px 38px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            position: relative;
        }

        .login-card-inner {
            width: 100%;
            max-width: 360px;
        }

        .logo-box {
            text-align: center;
            margin-bottom: 24px;
        }

        .logo-frame {
            width: 76px;
            height: 76px;
            margin: 0 auto 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 20px;
            background: linear-gradient(135deg, #ffffff 0%, #f0f7ff 100%);
            border: 1px solid rgba(219, 229, 241, 0.95);
            box-shadow: 0 10px 24px rgba(37, 99, 235, 0.08), 0 2px 6px rgba(15, 23, 42, 0.04);
            position: relative;
            transition: transform 0.25s ease, box-shadow 0.25s ease;
        }

        .logo-frame:hover {
            transform: translateY(-2px);
            box-shadow: 0 14px 28px rgba(37, 99, 235, 0.14);
        }

        .logo-frame img {
            max-width: 54px;
            max-height: 54px;
            object-fit: contain;
            transition: transform 0.2s ease;
        }

        .logo-box h2 {
            margin: 0;
            color: var(--brand-navy-dark);
            font-size: 24px;
            font-weight: 800;
            letter-spacing: -0.4px;
        }

        .logo-box p {
            margin: 5px 0 0;
            color: var(--text-muted);
            font-size: 13px;
            font-weight: 500;
        }

        #dvError {
            margin-bottom: 18px;
            padding: 12px 14px;
            border-radius: 12px;
            font-size: 13px;
            font-weight: 600;
            line-height: 1.45;
            display: none;
            animation: fadeInAlert 0.25s ease;
        }

        @keyframes fadeInAlert {
            from { opacity: 0; transform: translateY(-4px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .alert-danger {
            background-color: #fef2f2 !important;
            border: 1px solid #fecaca !important;
            color: #991b1b !important;
        }

        .alert-warning {
            background-color: #fffbeb !important;
            border: 1px solid #fde68a !important;
            color: #92400e !important;
        }

        /* Authentication Loader */
        .auth-loader {
            display: none;
            align-items: center;
            justify-content: center;
            gap: 10px;
            margin-bottom: 16px;
            padding: 10px 14px;
            border-radius: 12px;
            background: #eff6ff;
            border: 1px solid #bfdbfe;
            color: var(--brand-primary);
            font-size: 13px;
            font-weight: 700;
            animation: fadeInAlert 0.2s ease;
        }

        /* Reset any conflicting inherited styles for span or text inside loader */
        .auth-loader span,
        .auth-loader .auth-loader-text {
            animation: none !important;
            transform: none !important;
            width: auto !important;
            height: auto !important;
            border: none !important;
            border-radius: 0 !important;
            display: inline-block !important;
            vertical-align: middle !important;
            margin: 0 !important;
            color: var(--brand-primary) !important;
            font-size: 13px !important;
            font-weight: 700 !important;
        }

        .auth-spinner {
            width: 18px !important;
            height: 18px !important;
            border-radius: 50% !important;
            border: 2.5px solid rgba(37, 99, 235, 0.2) !important;
            border-top-color: var(--brand-primary) !important;
            animation: spinRing 0.75s linear infinite !important;
            flex-shrink: 0;
            display: inline-block !important;
            vertical-align: middle !important;
        }

        @keyframes spinRing {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .login-field {
            margin-bottom: 16px;
        }

        .form-label {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 6px;
            color: var(--brand-navy);
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 0.2px;
            text-transform: uppercase;
        }

        .login-input-wrap {
            position: relative;
            display: flex;
            align-items: center;
        }

        .login-input-wrap .form-control {
            width: 100%;
            height: 46px;
            padding: 10px 42px 10px 38px;
            border: 1.5px solid var(--input-border);
            border-radius: 12px;
            background: #ffffff;
            color: var(--text-heading);
            font-size: 13.5px;
            font-weight: 600;
            box-shadow: 0 1px 2px rgba(15, 23, 42, 0.03);
            transition: border-color 0.2s ease, box-shadow 0.2s ease, background 0.2s ease;
            outline: none;
        }

        .login-input-wrap .form-control:focus {
            border-color: var(--brand-primary);
            box-shadow: 0 0 0 3.5px rgba(37, 99, 235, 0.14);
            background: #ffffff;
        }

        .login-input-wrap .form-control::placeholder {
            color: var(--text-light);
            font-weight: 400;
        }

        .input-lead-icon {
            position: absolute;
            left: 13px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-light);
            font-size: 14px;
            pointer-events: none;
            transition: color 0.2s ease;
        }

        .login-input-wrap:focus-within .input-lead-icon {
            color: var(--brand-primary);
        }

        .password-toggle-btn {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            background: transparent;
            border: none;
            color: var(--text-muted);
            font-size: 14px;
            cursor: pointer;
            padding: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 6px;
            transition: color 0.2s ease, background-color 0.2s ease;
        }

        .password-toggle-btn:hover {
            color: var(--brand-primary);
            background-color: #f1f5f9;
        }

        .login-options {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin: 4px 0 20px;
            font-size: 12.5px;
        }

        .remember-box {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: var(--text-body);
            font-weight: 600;
            cursor: pointer;
            user-select: none;
        }

        .remember-box input[type="checkbox"] {
            width: 16px;
            height: 16px;
            border-radius: 4px;
            border: 1.5px solid #94a3b8;
            accent-color: var(--brand-primary);
            cursor: pointer;
        }

        .forgot-link {
            color: var(--brand-primary);
            font-weight: 700;
            text-decoration: none;
            transition: color 0.2s ease;
        }

        .forgot-link:hover {
            color: var(--brand-primary-hover);
            text-decoration: underline;
        }

        .btn-login-primary {
            width: 100%;
            height: 48px;
            border: 0 !important;
            border-radius: 12px !important;
            background: linear-gradient(135deg, #2563eb 0%, #0284c7 100%) !important;
            color: #ffffff !important;
            font-size: 14px !important;
            font-weight: 700 !important;
            letter-spacing: 0.3px;
            box-shadow: 0 8px 20px rgba(37, 99, 235, 0.28) !important;
            transition: all 0.22s ease !important;
            cursor: pointer !important;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            gap: 8px !important;
        }

        .btn-login-primary:hover {
            background: linear-gradient(135deg, #1d4ed8 0%, #0369a1 100%) !important;
            box-shadow: 0 12px 24px rgba(37, 99, 235, 0.36) !important;
            transform: translateY(-1px);
        }

        .btn-login-primary:active {
            transform: translateY(0);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.25) !important;
        }

        .btn-authenticating {
            opacity: 0.85;
            cursor: wait !important;
            pointer-events: none;
        }

        .login-card-footer {
            margin-top: 24px;
            padding-top: 16px;
            border-top: 1px solid #f1f5f9;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            color: var(--text-muted);
            font-size: 11.5px;
            font-weight: 600;
        }

        .login-card-footer i {
            color: var(--status-success);
            font-size: 12px;
        }

        @media (max-width: 980px) {
            body.login-page {
                padding: 20px 14px;
            }

            .login-shell {
                grid-template-columns: 1fr;
                max-width: 520px;
                min-height: auto;
                border-radius: 20px;
            }

            .login-visual {
                padding: 34px 28px;
            }

            .brand-title h1 {
                font-size: 30px;
            }

            .feature-grid {
                grid-template-columns: 1fr;
                gap: 10px;
            }

            .feature-card {
                padding: 12px 14px;
                flex-direction: row;
                align-items: center;
                gap: 12px;
            }

            .feature-icon-box {
                margin-bottom: 0;
                flex-shrink: 0;
            }

            .login-panel {
                padding: 36px 28px;
            }
        }

        @media (max-width: 480px) {
            body.login-page {
                padding: 12px 8px;
                align-items: flex-start;
            }

            .login-shell {
                border-radius: 16px;
                border: 1px solid rgba(219, 229, 241, 0.9);
            }

            .login-visual {
                padding: 28px 20px;
            }

            .brand-title h1 {
                font-size: 26px;
            }

            .brand-title p {
                font-size: 13.5px;
            }

            .login-panel {
                padding: 28px 18px;
            }

            .logo-frame {
                width: 66px;
                height: 66px;
            }

            .logo-box h2 {
                font-size: 21px;
            }
        }
        .mfa-screen{display:none}.mfa-choice{width:100%;display:flex;align-items:center;gap:14px;margin:12px 0;padding:15px;border:1px solid #dbe5f1;border-radius:12px;background:#f8fbff;color:#172554;text-align:left;cursor:pointer}.mfa-choice.selected{border-color:#2563eb;box-shadow:0 0 0 3px rgba(37,99,235,.12)}.mfa-choice i{width:42px;height:42px;display:grid;place-items:center;border-radius:10px;background:#e6f1ff;color:#2563eb;font-size:20px}.mfa-choice strong,.mfa-choice small{display:block}.mfa-choice small{margin-top:3px;color:#64748b}.mfa-primary{width:100%;margin-top:12px}.mfa-step{text-align:center;color:#64748b;font-size:13px}.mfa-qr{width:170px;height:170px;margin:18px auto;padding:10px;border:1px solid #dbe5f1;border-radius:12px;background:#fff}.mfa-qr img,.mfa-qr canvas{width:148px!important;height:148px!important}.mfa-secret{text-align:center;color:#64748b;font-size:12px}.mfa-secret code{display:block;margin-top:5px;word-break:break-all;color:#172554}.mfa-code{height:52px!important;margin:17px 0;text-align:center;letter-spacing:12px;font-size:22px!important;font-weight:700}.mfa-code::placeholder{letter-spacing:0;font-size:14px;font-weight:400}.mfa-email{margin:14px 0;padding:11px;border-radius:9px;background:#eef6ff;text-align:center;color:#173b70}.mfa-link{display:block;margin:14px auto 0;border:0;background:none;color:#2563eb;cursor:pointer}.mfa-back{margin-top:10px}.mfa-message{display:none;margin-bottom:14px;padding:11px;border-radius:9px;font-size:13px}.mfa-message.error{display:block;background:#fff1f2;color:#9f1239;border:1px solid #fecdd3}.mfa-message.success{display:block;background:#ecfdf5;color:#166534;border:1px solid #bbf7d0}
    </style>
</head>
<body class="login-page">

    <!-- Ambient Grid & Glow Elements -->
    <div class="bg-grid-overlay"></div>
    <div class="ambient-blob blob-1"></div>
    <div class="ambient-blob blob-2"></div>

    <!-- Main Login Shell -->
    <main class="login-shell" role="main">
        
        <!-- Left Side: Brand Visual & Features Showcase -->
        <section class="login-visual" aria-label="Portal Overview">
            <div class="visual-pattern"></div>
            <div class="brand-content">
                
                <!-- Top Brand Header -->
                <div>
                    <div class="brand-badge">
                        <span class="status-dot"></span>
                        <i class="fas fa-shield-alt"></i>
                        <span>Secure Enterprise Gateway</span>
                    </div>

                    <div class="brand-title">
                        <h1>Welcome to <span class="gradient-text">Infinity IPS</span></h1>
                        <p>Unified enterprise workspace for seamless operations, analytics, automated workflows, and employee service management.</p>
                    </div>
                </div>

                <!-- Feature Showcase Grid -->
                <div class="feature-grid">
                    <div class="feature-card">
                        <div class="feature-icon-box">
                            <i class="fas fa-chart-line"></i>
                        </div>
                        <div>
                            <span class="feature-label">Unified Dashboard</span>
                            <span class="feature-desc">Real-time productivity & operations</span>
                        </div>
                    </div>

                    <div class="feature-card">
                        <div class="feature-icon-box">
                            <i class="fas fa-user-shield"></i>
                        </div>
                        <div>
                            <span class="feature-label">Enterprise Security</span>
                            <span class="feature-desc">Role-based access & verification</span>
                        </div>
                    </div>

                    <div class="feature-card">
                        <div class="feature-icon-box">
                            <i class="fas fa-headset"></i>
                        </div>
                        <div>
                            <span class="feature-label">Centralized Services</span>
                            <span class="feature-desc">Helpdesk, reports & tracking</span>
                        </div>
                    </div>
                </div>

                <!-- Bottom Visual Note -->
                <div class="visual-footer">
                    <i class="fas fa-lock"></i>
                    <span>Authorized personnel access only &bull; Enterprise Grade Infrastructure</span>
                </div>
            </div>
        </section>

        <!-- Right Side: Login Form Panel -->
        <section class="login-panel" aria-label="Sign In Form">
            <div class="login-card-inner">
                
                <!-- Logo & Heading -->
                <div class="logo-box">
                    <div class="logo-frame">
                        <img src="images/logo-login.png" alt="Infinity IPS Logo" />
                    </div>
                    <h2>Sign In</h2>
                    <p>Enter your credentials to access your workspace</p>
                </div>

                <!-- Server Error Alert Box -->
                <div id="dvError" runat="server" role="alert"></div>

                <!-- Client-side Loading State -->
                <div id="authLoader" class="auth-loader" aria-live="polite">
                    <div class="auth-spinner"></div>
                    <div class="auth-loader-text">Verifying credentials...</div>
                </div>

                <!-- ASP.NET Server Form -->
                <form id="form1" runat="server" autocomplete="on">
                    <div id="mfaMessage" class="mfa-message" role="alert"></div>
                    <div id="credentialFields">
                    
                    <!-- Username Field -->
                    <div class="login-field">
                        <label class="form-label" for="<%= txtUserName.ClientID %>">
                            <span>Username</span>
                            <i class="fas fa-asterisk text-primary" style="font-size: 8px;"></i>
                        </label>
                        <div class="login-input-wrap">
                            <i class="fas fa-user input-lead-icon" aria-hidden="true"></i>
                            <asp:TextBox ID="txtUserName" runat="server" 
                                placeholder="Enter your username" 
                                required="required" 
                                title="Please enter your username" 
                                autocomplete="username" 
                                Style="text-transform: uppercase;" 
                                CssClass="form-control login-username-input"></asp:TextBox>
                        </div>
                    </div>

                    <!-- Password Field with Show/Hide Toggle -->
                    <div class="login-field">
                        <label class="form-label" for="<%= txtPassword.ClientID %>">
                            <span>Password</span>
                            <i class="fas fa-asterisk text-primary" style="font-size: 8px;"></i>
                        </label>
                        <div class="login-input-wrap">
                            <i class="fas fa-lock input-lead-icon" aria-hidden="true"></i>
                            <asp:TextBox ID="txtPassword" runat="server" 
                                placeholder="Enter your password" 
                                TextMode="Password" 
                                CssClass="form-control login-password-input" 
                                autocomplete="current-password" 
                                required="required"></asp:TextBox>
                            <button type="button" class="password-toggle-btn" id="btnTogglePassword" onclick="togglePasswordVisibility();" title="Show or hide password" aria-label="Toggle password visibility">
                                <i class="fas fa-eye" id="togglePasswordIcon" aria-hidden="true"></i>
                            </button>
                        </div>
                    </div>

                    <!-- Options: Remember Me & Forgot Password -->
                    <div class="login-options">
                        <label class="remember-box" for="chkRemember">
                            <input type="checkbox" id="chkRemember" runat="server" />
                            <span>Remember me</span>
                        </label>
                        <a href="ForgotPassword.aspx" class="forgot-link">Forgot password?</a>
                    </div>

                    <!-- Sign In Submit Button -->
                    <asp:Button ID="btnSubmit" runat="server" 
                        Text="Sign In" 
                        CssClass="btn btn-login-primary" 
                        OnClientClick="return showAuthenticatingEffect(this);" 
                        OnClick="btnSubmit_Click" />
                    </div>

                    <div id="mfaSelection" class="mfa-screen">
                        <button class="mfa-choice" data-method="Authenticator" type="button"><i class="fas fa-mobile-alt"></i><span><strong>Authenticator App</strong><small>Use a 6-digit code from your app</small></span></button>
                        <button class="mfa-choice" data-method="Email" type="button"><i class="fas fa-envelope"></i><span><strong>Official Email Address</strong><small>Receive an OTP on your work email</small></span></button>
                        <button id="mfaMethodContinue" class="btn btn-login-primary mfa-primary" type="button" disabled>Continue</button>
                    </div>

                    <div id="mfaAuthSetup" class="mfa-screen">
                        <p class="mfa-step">Scan this QR code with Microsoft or Google Authenticator.</p><div id="mfaQr" class="mfa-qr"></div>
                        <div class="mfa-secret">Can't scan? Enter setup key:<code id="mfaSecret"></code></div>
                        <input id="mfaSetupCode" class="form-control mfa-code" inputmode="numeric" maxlength="6" autocomplete="one-time-code" placeholder="Enter 6-digit code" />
                        <button class="btn btn-login-primary mfa-primary mfa-verify" data-input="mfaSetupCode" type="button">Verify &amp; Enable MFA</button><button class="mfa-link mfa-change" type="button">Try another way</button>
                    </div>

                    <div id="mfaAuthVerify" class="mfa-screen"><p class="mfa-step">Enter the current code from your Authenticator App.</p><input id="mfaAuthCode" class="form-control mfa-code" inputmode="numeric" maxlength="6" autocomplete="one-time-code" placeholder="Enter 6-digit code"/><button class="btn btn-login-primary mfa-primary mfa-verify" data-input="mfaAuthCode" type="button">Verify &amp; Continue</button><button class="mfa-link mfa-change" type="button">Try another way</button></div>
                    <div id="mfaEmailVerify" class="mfa-screen"><p class="mfa-step">Enter the OTP sent to your official email.</p><div id="mfaMaskedEmail" class="mfa-email"></div><input id="mfaEmailCode" class="form-control mfa-code" inputmode="numeric" maxlength="6" autocomplete="one-time-code" placeholder="Enter 6-digit code"/><button class="btn btn-login-primary mfa-primary mfa-verify" data-input="mfaEmailCode" type="button">Verify &amp; Continue</button><button id="mfaResend" class="mfa-link" type="button" disabled>Resend OTP in 00:30</button><button class="mfa-link mfa-change" type="button">Try another way</button></div>
                    <button id="mfaBack" class="btn btn-outline-secondary mfa-back mfa-screen" type="button">Back to login</button>
                </form>

                <!-- Security Trust Footnote -->
                <div class="login-card-footer">
                    <i class="fas fa-check-circle"></i>
                    <span>256-bit SSL Encrypted &bull; Protected Session</span>
                </div>
            </div>
        </section>

    </main>

    <!-- Scripts -->
    <script src="plugins/jquery/jquery.min.js"></script>
    <script src="plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="dist/js/adminlte.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
    <script type="text/javascript">
        // Show/Hide Password Toggle
        function togglePasswordVisibility() {
            var pwdInputs = document.querySelectorAll('.login-password-input');
            var icon = document.getElementById('togglePasswordIcon');
            
            pwdInputs.forEach(function (input) {
                if (input.type === 'password') {
                    input.type = 'text';
                    if (icon) {
                        icon.classList.remove('fa-eye');
                        icon.classList.add('fa-eye-slash');
                    }
                } else {
                    input.type = 'password';
                    if (icon) {
                        icon.classList.remove('fa-eye-slash');
                        icon.classList.add('fa-eye');
                    }
                }
            });
        }

        // Authenticating state feedback on submit
        var selectedMfaMethod = '', mfaTimer = null;
        function showAuthenticatingEffect(btn) {
            var form = document.getElementById('form1');
            if (form && typeof form.checkValidity === 'function') {
                if (!form.checkValidity()) {
                    form.reportValidity();
                    return false;
                }
            }

            var loader = document.getElementById('authLoader');
            if (loader) {
                loader.style.display = 'flex';
            }

            if (btn) {
                btn.value = 'Signing in...';
                btn.classList.add('btn-authenticating');
            }

            callMfa('ValidateMfaLogin', { username: document.getElementById('<%= txtUserName.ClientID %>').value, password: document.getElementById('<%= txtPassword.ClientID %>').value, rememberMe: document.getElementById('chkRemember').checked }, handleMfa);
            return false;
        }

        document.querySelectorAll('.mfa-choice').forEach(function (button) { button.addEventListener('click', function () { document.querySelectorAll('.mfa-choice').forEach(function (x) { x.classList.remove('selected'); }); button.classList.add('selected'); selectedMfaMethod = button.getAttribute('data-method'); document.getElementById('mfaMethodContinue').disabled = false; }); });
        document.getElementById('mfaMethodContinue').addEventListener('click', function () { callMfa('SelectMfaMethod', { method: selectedMfaMethod }, handleMfa); });
        document.querySelectorAll('.mfa-verify').forEach(function (button) { button.addEventListener('click', function () { callMfa('VerifyMfa', { code: document.getElementById(button.getAttribute('data-input')).value }, handleMfa); }); });
        document.querySelectorAll('.mfa-code').forEach(function (input) { input.addEventListener('input', function () { input.value = input.value.replace(/\D/g, '').slice(0, 6); }); input.addEventListener('keydown', function (event) { if (event.key === 'Enter') { event.preventDefault(); event.stopPropagation(); var verifyButton = input.closest('.mfa-screen').querySelector('.mfa-verify'); if (verifyButton) verifyButton.click(); } }); });
        document.getElementById('mfaResend').addEventListener('click', function () { callMfa('ResendMfaEmail', {}, handleMfa); });
        document.querySelectorAll('.mfa-change').forEach(function (button) { button.addEventListener('click', function () { selectedMfaMethod = ''; document.querySelectorAll('.mfa-choice').forEach(function (x) { x.classList.remove('selected'); }); showMfaScreen('mfaSelection', 'Try another way', 'Choose a different verification method.'); document.getElementById('mfaMethodContinue').disabled = true; }); });
        document.getElementById('mfaBack').addEventListener('click', resetMfa);

        function callMfa(method, data, done) { setMfaBusy(true); fetch('Login.aspx/' + method, { method: 'POST', headers: { 'Content-Type': 'application/json; charset=utf-8' }, body: JSON.stringify(data || {}) }).then(function (r) { return r.json(); }).then(function (r) { setMfaBusy(false); done(r.d); }).catch(function () { setMfaBusy(false); showMfaMessage('Server error. Please try again.', 'error'); }); }
        function handleMfa(result) { if (result.status === 'success' || result.status === 'redirect') { window.location.href = result.url; return; } if (result.status === 'error') { showMfaMessage(result.message, 'error'); return; } if (result.status === 'expired') { resetMfa(); showMfaMessage(result.message, 'error'); return; } if (result.status === 'mfa_selection') { selectedMfaMethod = ''; showMfaScreen('mfaSelection', 'Secure your account', 'Choose how you want to verify your identity.'); document.getElementById('mfaMethodContinue').disabled = true; return; } if (result.status === 'authenticator_setup') { showMfaScreen('mfaAuthSetup', 'Set up Authenticator App', 'Scan the QR code, then verify the generated code.'); document.getElementById('mfaSecret').textContent = result.secret; document.getElementById('mfaQr').innerHTML = ''; new QRCode(document.getElementById('mfaQr'), { text: result.uri, width: 148, height: 148 }); return; } if (result.status === 'authenticator_verify') { showMfaScreen('mfaAuthVerify', 'Verification required', 'Confirm the code from your Authenticator App.'); return; } if (result.status === 'email_verify') { showMfaScreen('mfaEmailVerify', 'Check your official email', 'We sent a 6-digit verification code.'); document.getElementById('mfaMaskedEmail').textContent = result.email; startMfaTimer(); } }
        function showMfaScreen(id, title, subtitle) { document.getElementById('credentialFields').style.display = 'none'; document.querySelectorAll('.mfa-screen').forEach(function (x) { x.style.display = 'none'; }); document.getElementById(id).style.display = 'block'; document.getElementById('mfaBack').style.display = 'block'; document.querySelector('.logo-box h2').textContent = title; document.querySelector('.logo-box p').textContent = subtitle; clearMfaMessage(); }
        function resetMfa() { if (mfaTimer) clearInterval(mfaTimer); document.querySelectorAll('.mfa-screen').forEach(function (x) { x.style.display = 'none'; }); document.getElementById('credentialFields').style.display = 'block'; document.querySelector('.logo-box h2').textContent = 'Sign In'; document.querySelector('.logo-box p').textContent = 'Enter your credentials to access your workspace'; document.getElementById('<%= txtPassword.ClientID %>').value = ''; clearMfaMessage(); }
        function startMfaTimer() { var left = 30, button = document.getElementById('mfaResend'); button.disabled = true; if (mfaTimer) clearInterval(mfaTimer); mfaTimer = setInterval(function () { left--; button.textContent = left > 0 ? 'Resend OTP in 00:' + String(left).padStart(2, '0') : 'Resend OTP'; button.disabled = left > 0; if (left <= 0) clearInterval(mfaTimer); }, 1000); }
        function setMfaBusy(on) { document.getElementById('authLoader').style.display = on ? 'flex' : 'none'; document.querySelectorAll('#form1 button,#form1 input[type=submit]').forEach(function (x) { x.disabled = on; }); if (!on && selectedMfaMethod) document.getElementById('mfaMethodContinue').disabled = false; }
        function showMfaMessage(text, type) { var box = document.getElementById('mfaMessage'); box.className = 'mfa-message ' + type; box.textContent = text; } function clearMfaMessage() { var box = document.getElementById('mfaMessage'); box.className = 'mfa-message'; box.textContent = ''; }
    </script>
</body>
</html>
