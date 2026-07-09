<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ResetUserPassword.aspx.cs" Inherits="WebPortal.Admin.ResetUserPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --rup-primary: #1d4ed8;
            --rup-primary-2: #2563eb;
            --rup-accent: #22c1dc;
            --rup-bg: #f4f7fb;
            --rup-text: #0f172a;
            --rup-muted: #64748b;
            --rup-border: #e5e7eb;
            --rup-shadow: 0 18px 45px rgba(15, 23, 42, .10);
        }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            margin: auto;
            width: 192px;
            height: 192px;
            z-index: 99999;
            opacity: .95;
            border-radius: 24px;
            text-align: center;
        }

        .rup-page {
            background: var(--rup-bg);
            min-height: calc(100vh - 90px);
        }

        .rup-container {
          /*  max-width: 1180px;*/
            margin: 0 auto;
        }

        .rup-hero {
            position: relative;
            overflow: hidden;
            border-radius: 22px;
            padding: 24px 28px;
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%);
            box-shadow: var(--rup-shadow);
            margin-bottom: 20px;
        }

        .rup-hero:before {
            content: "";
            position: absolute;
            right: -60px;
            top: -70px;
            width: 220px;
            height: 220px;
            border-radius: 50%;
            background: rgba(255, 255, 255, .14);
        }

        .rup-hero:after {
            content: "";
            position: absolute;
            right: 110px;
            bottom: -80px;
            width: 180px;
            height: 180px;
            border-radius: 50%;
            background: rgba(255, 255, 255, .10);
        }

        .rup-hero-content {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
        }

        .rup-title-wrap {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .rup-hero-icon {
            width: 58px;
            height: 58px;
            min-width: 58px;
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255, 255, 255, .18);
            border: 1px solid rgba(255, 255, 255, .28);
            font-size: 26px;
            box-shadow: inset 0 0 25px rgba(255, 255, 255, .10);
        }

        .rup-hero h3 {
            margin: 0;
            font-size: 24px;
            line-height: 1.2;
            font-weight: 800;
            letter-spacing: .2px;
        }

        .rup-hero p {
            margin: 6px 0 0;
            color: rgba(255, 255, 255, .88);
            font-size: 13px;
        }

        .rup-chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 14px;
            border-radius: 999px;
            background: rgba(255,255,255,.16);
            border: 1px solid rgba(255,255,255,.28);
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
        }

        .rup-card {
            background: #fff;
            border: 1px solid var(--rup-border);
            border-radius: 22px;
            box-shadow: 0 12px 32px rgba(15, 23, 42, .07);
            overflow: hidden;
        }

        .rup-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            padding: 18px 22px;
            border-bottom: 1px solid #eef2f7;
            background: linear-gradient(180deg, #ffffff 0%, #f8fbff 100%);
        }

        .rup-card-title {
            display: flex;
            align-items: center;
            gap: 12px;
            color: var(--rup-text);
            font-weight: 800;
            font-size: 16px;
        }

        .rup-card-title i {
            width: 38px;
            height: 38px;
            border-radius: 12px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: #2563eb;
            background: #eff6ff;
        }

        .rup-card-body {
            padding: 24px;
        }

        .rup-form-grid {
            display: grid;
            grid-template-columns: minmax(260px, 1fr) auto;
            gap: 18px;
            align-items: end;
        }

        .rup-field label {
            display: block;
            margin-bottom: 8px;
            color: #334155;
            font-size: 13px;
            font-weight: 700 !important;
            border: 0 !important;
        }

        .rup-field .form-control,
        #rup_user {
            width: 100% !important;
            min-height: 44px;
            border: 1px solid #dbe3ef;
            border-radius: 12px;
            padding: 9px 12px;
            font-size: 14px;
            box-shadow: none;
            background: #fff;
            transition: .25s ease;
        }

        #rup_user:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, .12);
            outline: none;
        }

        .rup-help {
            display: flex;
            align-items: flex-start;
            gap: 11px;
            margin-top: 18px;
            padding: 14px 15px;
            border-radius: 16px;
            background: #f8fafc;
            border: 1px dashed #cbd5e1;
            color: var(--rup-muted);
            font-size: 13px;
            line-height: 1.5;
        }

        .rup-help i {
            color: #2563eb;
            margin-top: 2px;
        }

        #brup_btnreset,
        .btn-rup-primary {
            min-height: 44px;
            padding: 10px 24px;
            border-radius: 12px;
            border: 0;
            background: linear-gradient(120deg, #1d4ed8, #2563eb 65%, #22c1dc);
            color: #fff !important;
            font-weight: 800;
            letter-spacing: .2px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
            box-shadow: 0 10px 22px rgba(37, 99, 235, .22);
            transition: .25s ease;
            white-space: nowrap;
        }

        #brup_btnreset:hover,
        .btn-rup-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 14px 28px rgba(37, 99, 235, .30);
        }

        .rup-modal .modal-content {
            border: 0;
            border-radius: 18px;
            overflow: hidden;
            box-shadow: 0 25px 55px rgba(15, 23, 42, .25);
        }

        .rup-modal .modal-header {
            background: linear-gradient(120deg, #1d4ed8, #22c1dc);
            color: #fff;
            border: 0;
            justify-content: center;
            padding: 18px;
        }

        .rup-modal .modal-title {
            font-weight: 800;
            text-align: center;
        }

        .rup-modal .modal-footer {
            border-top: 1px solid #eef2f7;
            justify-content: center;
            padding: 16px;
        }

        .dataTables_scrollBody {
            min-height: 100px !important;
            height: auto;
        }

        .dataTables_length, .dataTables_info {
            float: left !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 50px;
            float: left;
        }

        .buttons-excel, .buttons-html5 {
            color: #fff;
            box-shadow: none;
            background: linear-gradient(120deg, #1d4ed8, #22c1dc);
            border: 0;
            font-weight: bold;
            margin: 0px 10px;
            border-radius: 10px;
        }

        .table.dataTable th {
            color: #0f172a;
            background: #f1f5f9 !important;
        }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
        }

        @media (max-width: 768px) {
            .rup-page {
                padding: 12px;
            }

            .rup-hero {
                padding: 20px;
                border-radius: 18px;
            }

            .rup-hero-content {
                align-items: flex-start;
                flex-direction: column;
            }

            .rup-hero h3 {
                font-size: 20px;
            }

            .rup-form-grid {
                grid-template-columns: 1fr;
            }

            #brup_btnreset {
                width: 100%;
            }
        }
    </style>
    <script>
        $(document).ready(function () {
            rup_bindusers();
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="rup-page">
        <div class="rup-container">

            <div class="rup-hero">
                <div class="rup-hero-content">
                    <div class="rup-title-wrap">
                        <div class="rup-hero-icon">
                            <i class="fas fa-user-lock"></i>
                        </div>
                        <div>
                            <h3>Reset User Password</h3>
                            <p>Select employee and reset password quickly with secure admin action.</p>
                        </div>
                    </div>
                    <div class="rup-chip">
                        <i class="fas fa-shield-alt"></i>
                        Admin Utility
                    </div>
                </div>
            </div>

            <div class="rup-card">
                <div class="rup-card-header">
                    <div class="rup-card-title">
                        <i class="fas fa-key"></i>
                        <span>Password Reset</span>
                    </div>
                </div>

                <div class="rup-card-body">
                    <div class="rup-form-grid">
                        <div class="rup-field">
                            <label for="rup_user">Employee</label>
                            <select id="rup_user" name="rup_user" class="form-control"></select>
                        </div>

                        <div class="rup-actions">
                            <button id="brup_btnreset" name="brup_btnreset" type="button" class="btn-rup-primary" onclick="return brup_reset();">
                                <i class="fas fa-sync-alt"></i>
                                <span>Reset Password</span>
                            </button>
                        </div>
                    </div>

                    <div class="rup-help">
                        <i class="fas fa-info-circle"></i>
                        <div>
                            Please select a valid employee before resetting the password. Existing page methods and backend reset logic are unchanged.
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <div class="modal fade rup-modal" id="rup_dverror">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="rup_errmsg"></h6>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn-rup-primary" type="button" id="rup_btnMessage" onclick="location.reload();">
                        <i class="fas fa-check"></i>
                        Okay
                    </button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
