<%@ Page Title="User Access Management" Language="C#" MasterPageFile="~/US/USAdmin.Master" AutoEventWireup="true" CodeBehind="ResetPasswordSegment.aspx.cs" Inherits="WebPortal.US.ResetPasswordSegment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../plugins/sweetalert2/sweetalert2.min.css" />
    <style>
        :root {
            --rps-primary: #2563eb;
            --rps-primary-dark: #1e3a8a;
            --rps-accent: #06b6d4;
            --rps-ink: #0f172a;
            --rps-muted: #64748b;
            --rps-border: #e2e8f0;
            --rps-soft: #f8fafc;
            --rps-shadow: 0 18px 45px rgba(15, 23, 42, .08);
        }

        .rps-page { color: var(--rps-ink); }

        .rps-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            gap: 16px;
            padding: 20px 24px;
            border-radius: 20px;
            color: #fff;
            background: linear-gradient(120deg, var(--rps-primary-dark), var(--rps-primary) 62%, var(--rps-accent));
            box-shadow: var(--rps-shadow);
        }

        .rps-hero::after {
            content: "";
            position: absolute;
            right: -80px;
            top: -120px;
            width: 280px;
            height: 280px;
            border-radius: 50%;
            background: rgba(255, 255, 255, .12);
        }

        .rps-hero-icon {
            position: relative;
            z-index: 1;
            width: 52px;
            height: 52px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            flex: 0 0 52px;
            border: 1px solid rgba(255, 255, 255, .25);
            border-radius: 16px;
            background: rgba(255, 255, 255, .16);
            font-size: 22px;
        }

        .rps-hero-content { position: relative; z-index: 1; }
        .rps-title { margin: 0; font-size: 22px; font-weight: 800; letter-spacing: -.02em; }
        .rps-subtitle { margin: 6px 0 0; font-size: 13px; opacity: .9; }

        .rps-workspace,
        .rps-table-card {
            margin-top: 18px;
            overflow: hidden;
            border: 1px solid var(--rps-border);
            border-radius: 20px;
            background: #fff;
            box-shadow: var(--rps-shadow);
        }

        .rps-tabs {
            display: flex;
            gap: 6px;
            padding: 8px;
            border-bottom: 1px solid var(--rps-border);
            background: var(--rps-soft);
        }

        .rps-tab {
            min-height: 44px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
            padding: 0 18px;
            border: 0;
            border-radius: 12px;
            background: transparent;
            color: #475569;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            transition: background .18s ease, color .18s ease, box-shadow .18s ease;
        }

        .rps-tab:hover { background: #fff; color: var(--rps-primary); }

        .rps-tab.is-active {
            background: #fff;
            color: var(--rps-primary);
            box-shadow: 0 6px 18px rgba(15, 23, 42, .08);
        }

        .rps-tab:focus-visible,
        .rps-button:focus-visible,
        .rps-form-control:focus-visible {
            outline: 3px solid rgba(37, 99, 235, .22);
            outline-offset: 2px;
        }

        .rps-panel { display: none; padding: 22px; }
        .rps-panel.is-active { display: block; }

        .rps-panel-heading {
            display: flex;
            align-items: flex-start;
            gap: 12px;
            margin-bottom: 20px;
        }

        .rps-panel-icon {
            width: 42px;
            height: 42px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            flex: 0 0 42px;
            border-radius: 13px;
            background: #eff6ff;
            color: var(--rps-primary);
            font-size: 17px;
        }

        .rps-panel-title,
        .rps-table-title { margin: 0; color: var(--rps-ink); font-size: 17px; font-weight: 800; }

        .rps-panel-copy,
        .rps-table-copy { margin: 4px 0 0; color: var(--rps-muted); font-size: 13px; }

        .rps-form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 18px;
        }

        .rps-field label {
            display: block;
            margin-bottom: 8px;
            color: #334155;
            font-size: 14px;
            font-weight: 700;
        }

        .rps-required { color: #dc2626; }

        .rps-form-control {
            width: 100%;
            height: 46px;
            padding: 9px 13px;
            border: 1px solid var(--rps-border);
            border-radius: 12px;
            background: #fff;
            color: var(--rps-ink);
            font-size: 14px;
            box-shadow: none;
            transition: border-color .18s ease, box-shadow .18s ease;
        }

        .rps-form-control:focus {
            border-color: var(--rps-primary);
            box-shadow: 0 0 0 4px rgba(37, 99, 235, .1);
        }

        .rps-form-control[readonly] {
            background: #f8fafc;
            color: #0f172a;
            font-family: Consolas, monospace;
            font-weight: 700;
            letter-spacing: .04em;
        }

        .rps-password-row {
            display: grid;
            grid-template-columns: minmax(0, 1fr) auto;
            gap: 10px;
        }

        .rps-button {
            min-height: 44px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 0 18px;
            border: 0;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 800;
            cursor: pointer;
            transition: transform .18s ease, box-shadow .18s ease;
        }

        .rps-button:hover { transform: translateY(-1px); }

        .rps-button-primary {
            color: #fff;
            background: linear-gradient(135deg, var(--rps-primary), var(--rps-accent));
            box-shadow: 0 10px 22px rgba(37, 99, 235, .22);
        }

        .rps-button-secondary {
            border: 1px solid #bfdbfe;
            color: #1d4ed8;
            background: #eff6ff;
        }

        .rps-actions { display: flex; justify-content: flex-end; margin-top: 20px; }
        .rps-policy { margin: 10px 0 0; color: var(--rps-muted); font-size: 12px; line-height: 1.5; }

        .rps-table-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            padding: 18px 20px;
            border-bottom: 1px solid var(--rps-border);
            background: linear-gradient(180deg, #fff, #f8fafc);
        }

        .rps-table-body { padding: 18px 20px 22px; }

        .rps-table-wrap {
            width: 100%;
            overflow: hidden;
            border: 1px solid var(--rps-border);
            border-radius: 14px;
        }

        #rpsEmployeeTable { width: 100% !important; margin: 0 !important; }

        #rpsEmployeeTable thead th {
            padding: 12px !important;
            border: 0 !important;
            border-bottom: 1px solid var(--rps-border) !important;
            background: #eff6ff;
            color: #1e3a8a;
            font-size: 12px;
            font-weight: 800;
            letter-spacing: .025em;
            text-transform: uppercase;
            white-space: nowrap;
        }

        #rpsEmployeeTable tbody td {
            padding: 11px 12px !important;
            border-color: #eef2f7 !important;
            color: #334155;
            font-size: 13px;
            vertical-align: middle;
            white-space: nowrap;
        }

        #rpsEmployeeTable tbody tr:hover td { background: #f8fbff; }

        .rps-segment-badge {
            display: inline-flex;
            align-items: center;
            min-height: 28px;
            padding: 0 10px;
            border-radius: 999px;
            background: #ecfeff;
            color: #0e7490;
            font-size: 12px;
            font-weight: 700;
        }

        .dataTables_wrapper .dataTables_filter input,
        .dataTables_wrapper .dataTables_length select {
            border: 1px solid var(--rps-border) !important;
            border-radius: 10px !important;
            padding: 6px 9px !important;
        }

        .dataTables_wrapper .dt-buttons .btn {
            margin-right: 6px;
            border: 0;
            border-radius: 9px;
            font-size: 12px;
            font-weight: 700;
        }

        .rps-loader {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 99990;
            align-items: center;
            justify-content: center;
            background: rgba(248, 250, 252, .72);
            backdrop-filter: blur(3px);
        }

        .rps-loader.is-visible { display: flex; }

        .rps-loader-card {
            min-width: 170px;
            padding: 22px;
            border-radius: 18px;
            background: #fff;
            color: var(--rps-ink);
            text-align: center;
            font-size: 13px;
            font-weight: 700;
            box-shadow: 0 24px 60px rgba(15, 23, 42, .18);
        }

        .rps-spinner {
            width: 38px;
            height: 38px;
            margin: 0 auto 12px;
            border: 4px solid #dbeafe;
            border-top-color: var(--rps-primary);
            border-radius: 50%;
            animation: rpsSpin .75s linear infinite;
        }

        @keyframes rpsSpin { to { transform: rotate(360deg); } }
        .swal2-container { z-index: 100000 !important; }

        @media (max-width: 767px) {
            .rps-page { padding-top: 12px; }

            .rps-hero,
            .rps-panel,
            .rps-table-body { padding: 18px; }

            .rps-form-grid { grid-template-columns: 1fr; }

            .rps-tabs,
            .rps-table-head { align-items: stretch; flex-direction: column; }

            .rps-tab,
            .rps-actions .rps-button { width: 100%; }

            .rps-password-row { grid-template-columns: 1fr; }
        }

        @media (prefers-reduced-motion: reduce) {
            .rps-button,
            .rps-tab { transition: none; }
        }
    </style>
    <script src="../plugins/sweetalert2/sweetalert2.all.min.js"></script>
    <script src="../Scripts/US/ResetPasswordSegment.js?v=1"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="rpsPageLoader" class="rps-loader" aria-hidden="true">
        <div class="rps-loader-card" role="status">
            <div class="rps-spinner"></div>
            <span>Loading employee data...</span>
        </div>
    </div>

    <main class="rps-page">
        <section class="rps-hero" aria-labelledby="rpsPageTitle">
            <span class="rps-hero-icon"><i class="fas fa-user-shield" aria-hidden="true"></i></span>
            <div class="rps-hero-content">
                <h1 class="rps-title" id="rpsPageTitle">Reset Password/Segment</h1>
                <p class="rps-subtitle">Reset employee passwords and maintain segment assignments.</p>
            </div>
        </section>

        <section class="rps-workspace">
            <div class="rps-tabs" role="tablist" aria-label="User access actions">
                <button type="button" class="rps-tab is-active" id="rpsResetTab" role="tab" aria-selected="true" aria-controls="rpsResetPanel" data-rps-tab="reset">
                    <i class="fas fa-key" aria-hidden="true"></i> Reset Password
                </button>
                <button type="button" class="rps-tab" id="rpsSegmentTab" role="tab" aria-selected="false" aria-controls="rpsSegmentPanel" data-rps-tab="segment" tabindex="-1">
                    <i class="fas fa-layer-group" aria-hidden="true"></i> Segment
                </button>
            </div>

            <div class="rps-panel is-active" id="rpsResetPanel" role="tabpanel" aria-labelledby="rpsResetTab" data-rps-panel="reset">
                <div class="rps-panel-heading">
                    <span class="rps-panel-icon"><i class="fas fa-lock" aria-hidden="true"></i></span>
                    <div>
                        <h2 class="rps-panel-title">Reset employee password</h2>
                        <p class="rps-panel-copy">Generate a secure temporary password, then save it for the selected employee.</p>
                    </div>
                </div>

                <div class="rps-form-grid">
                    <div class="rps-field">
                        <label for="rpsResetUser">User <span class="rps-required">*</span></label>
                        <select id="rpsResetUser" class="rps-form-control"><option value="">Select user</option></select>
                    </div>
                    <div class="rps-field">
                        <label for="rpsGeneratedPassword">Generated password <span class="rps-required">*</span></label>
                        <div class="rps-password-row">
                            <input type="text" id="rpsGeneratedPassword" class="rps-form-control" readonly="readonly" autocomplete="off" placeholder="Click Generate Password" />
                            <button type="button" id="rpsGeneratePassword" class="rps-button rps-button-secondary">
                                <i class="fas fa-magic" aria-hidden="true"></i> Generate Password
                            </button>
                        </div>
                        <p class="rps-policy">Passwords are generated securely and include uppercase, lowercase, numeric, and special characters.</p>
                    </div>
                </div>

                <div class="rps-actions">
                    <button type="button" id="rpsSavePassword" class="rps-button rps-button-primary">
                        <i class="fas fa-sync-alt" aria-hidden="true"></i> Save / Reset Password
                    </button>
                </div>
            </div>

            <div class="rps-panel" id="rpsSegmentPanel" role="tabpanel" aria-labelledby="rpsSegmentTab" data-rps-panel="segment" hidden="hidden">
                <div class="rps-panel-heading">
                    <span class="rps-panel-icon"><i class="fas fa-project-diagram" aria-hidden="true"></i></span>
                    <div>
                        <h2 class="rps-panel-title">Update employee segment</h2>
                        <p class="rps-panel-copy">Assign one employee to the appropriate operational segment.</p>
                    </div>
                </div>

                <div class="rps-form-grid">
                    <div class="rps-field">
                        <label for="rpsSegmentUser">User <span class="rps-required">*</span></label>
                        <select id="rpsSegmentUser" class="rps-form-control"><option value="">Select user</option></select>
                    </div>
                    <div class="rps-field">
                        <label for="rpsSegment">Segment <span class="rps-required">*</span></label>
                        <select id="rpsSegment" class="rps-form-control">
                            <option value="">Select segment</option>
                            <option value="Compliance QC - Canopy">Compliance QC - Canopy</option>
                            <option value="Credit QC - Canopy">Credit QC - Canopy</option>
                            <option value="Management">Management</option>
                        </select>
                    </div>
                </div>

                <div class="rps-actions">
                    <button type="button" id="rpsSaveSegment" class="rps-button rps-button-primary">
                        <i class="fas fa-save" aria-hidden="true"></i> Save / Update Segment
                    </button>
                </div>
            </div>
        </section>

        <section class="rps-table-card" aria-labelledby="rpsEmployeeTableTitle">
            <div class="rps-table-head">
                <div>
                    <h2 class="rps-table-title" id="rpsEmployeeTableTitle">Employee directory</h2>
                    <p class="rps-table-copy">Current employee and segment information</p>
                </div>
            </div>
            <div class="rps-table-body">
                <div class="rps-table-wrap">
                    <table id="rpsEmployeeTable" class="table table-hover" aria-describedby="rpsEmployeeTableTitle">
                        <thead>
                            <tr>
                                <th>Sr. #</th>
                                <th>Name</th>
                              <%--  <th>Manager</th>
                                <th>Designation Name</th>
                                <th>Department</th>--%>
                                <th>Segment</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </section>
    </main>
</asp:Content>
