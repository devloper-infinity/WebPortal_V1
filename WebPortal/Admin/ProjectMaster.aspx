<%@ Page Title="Project Master" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ProjectMaster.aspx.cs" Inherits="WebPortal.Admin.ProjectMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../plugins/sweetalert2/sweetalert2.min.css" />
    <style>
        :root {
            --pm-blue: #1d4ed8;
            --pm-cyan: #0891b2;
            --pm-teal: #0f766e;
            --pm-slate: #0f172a;
            --pm-muted: #64748b;
            --pm-border: #dce6f2;
            --pm-soft: #f5f8fc;
        }

        .pm-page {
            color: var(--pm-slate);
            font-family: Inter, "Segoe UI", Arial, sans-serif;
            padding: 4px 4px 24px;
        }

        .pm-hero {
            align-items: center;
            background: linear-gradient(120deg, #17336f 0%, var(--pm-blue) 54%, #11a9c7 100%);
            border-radius: 18px;
            box-shadow: 0 14px 30px rgba(29,78,216,.20);
            color: #fff;
            display: flex;
            justify-content: space-between;
            margin-bottom: 18px;
            min-height: 118px;
            overflow: hidden;
            padding: 22px 26px;
            position: relative;
        }

        .pm-hero::before,
        .pm-hero::after {
            background: rgba(255,255,255,.09);
            border-radius: 50%;
            content: "";
            position: absolute;
        }

        .pm-hero::before { height: 220px; right: 82px; top: -156px; width: 220px; }
        .pm-hero::after { bottom: -92px; height: 170px; right: -34px; width: 170px; }

        .pm-hero-main {
            align-items: center;
            display: flex;
            gap: 16px;
            position: relative;
            z-index: 1;
        }

        .pm-hero-icon {
            align-items: center;
            background: rgba(255,255,255,.16);
            border: 1px solid rgba(255,255,255,.27);
            border-radius: 16px;
            display: inline-flex;
            font-size: 24px;
            height: 58px;
            justify-content: center;
            width: 58px;
        }

        .pm-hero h1 {
            font-size: 23px;
            font-weight: 800;
            margin: 0;
        }

        .pm-hero p {
            color: rgba(255,255,255,.88);
            font-size: 12px;
            font-weight: 600;
            margin: 6px 0 0;
        }

        .pm-hero-badge {
            align-items: center;
            background: rgba(255,255,255,.14);
            border: 1px solid rgba(255,255,255,.25);
            border-radius: 999px;
            display: inline-flex;
            font-size: 11px;
            font-weight: 800;
            gap: 7px;
            padding: 8px 12px;
            position: relative;
            z-index: 1;
        }

        .pm-stat-grid {
            display: grid;
            gap: 13px;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            margin-bottom: 18px;
        }

        .pm-stat-card {
            align-items: center;
            background: #fff;
            border: 1px solid var(--pm-border);
            border-radius: 14px;
            box-shadow: 0 8px 22px rgba(15,23,42,.06);
            display: flex;
            gap: 12px;
            min-height: 86px;
            padding: 14px 16px;
        }

        .pm-stat-icon {
            align-items: center;
            background: #eaf1ff;
            border-radius: 11px;
            color: var(--pm-blue);
            display: inline-flex;
            font-size: 17px;
            height: 43px;
            justify-content: center;
            width: 43px;
        }

        .pm-stat-card.is-active .pm-stat-icon { background: #e7f8f1; color: #087a55; }
        .pm-stat-card.is-inactive .pm-stat-icon { background: #fff2e8; color: #c2410c; }
        .pm-stat-card.is-domain .pm-stat-icon { background: #f2eefe; color: #6d28d9; }

        .pm-stat-card span {
            color: var(--pm-muted);
            display: block;
            font-size: 10px;
            font-weight: 800;
            letter-spacing: .35px;
            text-transform: uppercase;
        }

        .pm-stat-card strong {
            color: #16283f;
            display: block;
            font-size: 23px;
            line-height: 1;
            margin-top: 5px;
        }

        .pm-shell {
            background: #fff;
            border: 1px solid var(--pm-border);
            border-radius: 18px;
            box-shadow: 0 14px 34px rgba(15,23,42,.08);
            overflow: hidden;
        }

        .pm-create-panel {
            background: linear-gradient(145deg, #f8fbff 0%, #f3f8fc 100%);
            border-bottom: 1px solid #e2eaf3;
            padding: 18px 20px;
        }

        .pm-section-kicker {
            color: var(--pm-blue);
            font-size: 10px;
            font-weight: 800;
            letter-spacing: .45px;
            margin-bottom: 4px;
            text-transform: uppercase;
        }

        .pm-section-title {
            color: #19324d;
            font-size: 15px;
            font-weight: 800;
            margin: 0;
        }

        .pm-section-subtitle {
            color: var(--pm-muted);
            font-size: 11px;
            font-weight: 600;
            margin: 4px 0 0;
        }

        .pm-create-form {
            align-items: end;
            display: grid;
            gap: 14px;
            grid-template-columns: minmax(250px, 1fr) auto;
            margin-top: 15px;
        }

        .pm-field label {
            color: #334155;
            display: block;
            font-size: 11px;
            font-weight: 800;
            margin-bottom: 7px;
        }

        .pm-control {
            background: #fff;
            border: 1px solid #cbd8e7;
            border-radius: 10px;
            color: #1f2937;
            font-size: 13px;
            height: 43px;
            outline: none;
            padding: 9px 11px;
            transition: border-color .18s ease, box-shadow .18s ease;
            width: 100%;
        }

        .pm-control:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59,130,246,.12);
        }

        .pm-field-hint {
            color: #7a8ba0;
            display: block;
            font-size: 10px;
            margin-top: 5px;
        }

        .pm-btn {
            align-items: center;
            border: 1px solid transparent;
            border-radius: 9px;
            display: inline-flex;
            font-size: 11px;
            font-weight: 800;
            gap: 7px;
            height: 40px;
            justify-content: center;
            padding: 0 15px;
            white-space: nowrap;
        }

        .pm-btn-primary {
            background: linear-gradient(135deg, var(--pm-teal), var(--pm-blue));
            box-shadow: 0 8px 18px rgba(29,78,216,.20);
            color: #fff;
            min-width: 126px;
        }

        .pm-btn-primary:hover,
        .pm-btn-primary:focus { color: #fff; filter: brightness(.97); outline: none; }

        .pm-btn-light {
            background: #fff;
            border-color: #cfdae8;
            color: #34506e;
        }

        .pm-list-panel { padding: 18px 20px 20px; }

        .pm-list-head {
            align-items: center;
            display: flex;
            gap: 14px;
            justify-content: space-between;
            margin-bottom: 15px;
        }

        .pm-list-tools {
            align-items: center;
            display: flex;
            gap: 9px;
        }

        .pm-filter { min-width: 145px; }

        .pm-table-wrap {
            border: 1px solid #dfe7f0;
            border-radius: 13px;
            overflow-x: auto;
        }

        #pm_table {
            border-collapse: separate !important;
            border-spacing: 0 !important;
            margin: 0 !important;
            min-width: 980px;
            width: 100% !important;
        }

        #pm_table thead th {
            background: #f3f6fa;
            border-bottom: 1px solid #dbe4ef !important;
            color: #42526a;
            font-size: 10px;
            font-weight: 800;
            padding: 12px 10px !important;
            text-transform: uppercase;
            white-space: nowrap;
        }

        #pm_table tbody td {
            border-bottom: 1px solid #edf2f7 !important;
            color: #344054;
            font-size: 12px;
            padding: 11px 10px !important;
            vertical-align: middle;
        }

        #pm_table tbody tr:hover td { background: #f8fbff; }

        .pm-project-name {
            color: #17365d;
            font-weight: 800;
        }

        .pm-status-badge {
            align-items: center;
            background: #e8f7f0;
            border: 1px solid #c7ebdc;
            border-radius: 999px;
            color: #08734f;
            display: inline-flex;
            font-size: 10px;
            font-weight: 800;
            gap: 5px;
            padding: 6px 9px;
        }

        .pm-status-badge.is-inactive {
            background: #fff3e8;
            border-color: #fed7aa;
            color: #b54708;
        }

        .pm-row-actions {
            display: inline-flex;
            gap: 6px;
        }

        .pm-action-btn {
            align-items: center;
            background: #fff;
            border: 1px solid #ccd8e5;
            border-radius: 8px;
            color: #31506f;
            display: inline-flex;
            font-size: 10px;
            font-weight: 800;
            gap: 5px;
            height: 32px;
            justify-content: center;
            padding: 0 9px;
        }

        .pm-action-btn.pm-delete { border-color: #fecaca; color: #b42318; }
        .pm-action-btn:hover { background: #f6f9fc; }

        #pm_table_wrapper .dataTables_filter input,
        #pm_table_wrapper .dataTables_length select {
            border: 1px solid #cbd8e7;
            border-radius: 8px;
            font-size: 11px;
            height: 34px;
        }

        #pm_table_wrapper .dataTables_info,
        #pm_table_wrapper .dataTables_paginate,
        #pm_table_wrapper .dataTables_length,
        #pm_table_wrapper .dataTables_filter {
            color: #64748b;
            font-size: 11px;
            padding: 10px 2px;
        }

        .pm-modal-content {
            border: 0;
            border-radius: 15px;
            box-shadow: 0 24px 60px rgba(15,23,42,.24);
            overflow: hidden;
        }

        .pm-modal-header {
            align-items: center;
            background: linear-gradient(135deg, #17336f, var(--pm-blue));
            border: 0;
            color: #fff;
            padding: 17px 19px;
        }

        .pm-modal-header .close { color: #fff; opacity: .9; text-shadow: none; }
        .pm-modal-body { background: var(--pm-soft); padding: 18px; }
        .pm-modal-panel { background: #fff; border: 1px solid var(--pm-border); border-radius: 12px; padding: 16px; }
        .pm-modal-footer { background: #fff; border-top: 1px solid #e8eef5; gap: 8px; padding: 13px 18px; }

        .pm-loading {
            align-items: center;
            background: rgba(255,255,255,.78);
            backdrop-filter: blur(3px);
            display: none;
            flex-direction: column;
            inset: 0;
            justify-content: center;
            position: fixed;
            z-index: 3000;
        }

        .pm-loading img { height: 52px; margin-bottom: 9px; width: 52px; }
        .pm-loading span { color: #334155; font-size: 11px; font-weight: 800; }

        @media (max-width: 900px) {
            .pm-stat-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); }
        }

        @media (max-width: 640px) {
            .pm-page { padding: 0 0 18px; }
            .pm-hero { border-radius: 14px; padding: 18px 15px; }
            .pm-hero-badge { display: none; }
            .pm-hero-icon { height: 50px; width: 50px; }
            .pm-hero h1 { font-size: 19px; }
            .pm-stat-grid { gap: 8px; grid-template-columns: 1fr 1fr; }
            .pm-stat-card { min-height: 72px; padding: 10px; }
            .pm-stat-icon { height: 37px; width: 37px; }
            .pm-stat-card strong { font-size: 19px; }
            .pm-create-form { grid-template-columns: 1fr; }
            .pm-create-form .pm-btn { width: 100%; }
            .pm-list-head { align-items: stretch; flex-direction: column; }
            .pm-list-tools { align-items: stretch; flex-direction: column; }
            .pm-filter, .pm-list-tools .pm-btn { width: 100%; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="pm-loading" id="pm_loading" aria-hidden="true">
        <img src="../images/Load_1.gif" alt="" />
        <span id="pm_loadingText">Loading projects...</span>
    </div>

    <main class="pm-page">
        <section class="pm-hero">
            <div class="pm-hero-main">
                <span class="pm-hero-icon"><i class="fas fa-project-diagram"></i></span>
                <div>
                    <h1>Project Master</h1>
                    <p>Create, maintain, activate, and retire WebPortal projects from one workspace.</p>
                </div>
            </div>
            <span class="pm-hero-badge"><i class="fas fa-shield-alt"></i>Admin Master</span>
        </section>

        <section class="pm-stat-grid" aria-label="Project summary">
            <div class="pm-stat-card">
                <span class="pm-stat-icon"><i class="fas fa-layer-group"></i></span>
                <div><span>Total Projects</span><strong id="pm_statTotal">0</strong></div>
            </div>
            <div class="pm-stat-card is-active">
                <span class="pm-stat-icon"><i class="fas fa-check-circle"></i></span>
                <div><span>Active</span><strong id="pm_statActive">0</strong></div>
            </div>
            <div class="pm-stat-card is-inactive">
                <span class="pm-stat-icon"><i class="fas fa-pause-circle"></i></span>
                <div><span>Inactive</span><strong id="pm_statInactive">0</strong></div>
            </div>
            <div class="pm-stat-card is-domain">
                <span class="pm-stat-icon"><i class="fas fa-sitemap"></i></span>
                <div><span>Domains</span><strong id="pm_statDomains">0</strong></div>
            </div>
        </section>

        <section class="pm-shell">
            <div class="pm-create-panel">
                <div class="pm-section-kicker">Quick Create</div>
                <h2 class="pm-section-title">Add a new project</h2>
                <p class="pm-section-subtitle">New projects are created as active and become available in the project list immediately.</p>

                <div class="pm-create-form">
                    <div class="pm-field">
                        <label for="pm_projectName">Project Name</label>
                        <input type="text" id="pm_projectName" class="pm-control" maxlength="100" autocomplete="off" placeholder="Example: 561-Underwriting" />
                        <span class="pm-field-hint">Letters, numbers, spaces, and hyphens are allowed.</span>
                    </div>
                    <button type="button" class="pm-btn pm-btn-primary" id="pm_btnCreate">
                        <i class="fas fa-plus-circle"></i>Create Project
                    </button>
                </div>
            </div>

            <div class="pm-list-panel">
                <div class="pm-list-head">
                    <div>
                        <div class="pm-section-kicker">Project Directory</div>
                        <h2 class="pm-section-title">Manage projects</h2>
                        <p class="pm-section-subtitle">Search, edit status, or remove project records.</p>
                    </div>
                    <div class="pm-list-tools">
                        <select id="pm_statusFilter" class="pm-control pm-filter" aria-label="Filter by status">
                            <option value="">All statuses</option>
                            <option value="Active">Active</option>
                            <option value="Deactive">Inactive</option>
                        </select>
                        <button type="button" class="pm-btn pm-btn-light" id="pm_btnRefresh">
                            <i class="fas fa-sync-alt"></i>Refresh
                        </button>
                    </div>
                </div>

                <div class="pm-table-wrap">
                    <table id="pm_table" class="table table-hover" aria-label="Project master records">
                        <thead>
                            <tr>
                                <th>Sr. #</th>
                                <th>Project ID</th>
                                <th>Domain</th>
                                <th>Project Name</th>
                                <th>Added By</th>
                                <th>Added Date</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </section>
    </main>

    <div class="modal fade" id="pm_editModal" tabindex="-1" role="dialog" aria-labelledby="pm_editTitle" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content pm-modal-content">
                <div class="modal-header pm-modal-header">
                    <div>
                        <h5 class="modal-title font-weight-bold" id="pm_editTitle">Edit Project</h5>
                        <div class="small" style="opacity:.82;">Update the project name or active status.</div>
                    </div>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                </div>
                <div class="modal-body pm-modal-body">
                    <div class="pm-modal-panel">
                        <input type="hidden" id="pm_editId" />
                        <div class="pm-field mb-3">
                            <label for="pm_editName">Project Name</label>
                            <input type="text" id="pm_editName" class="pm-control" maxlength="100" autocomplete="off" />
                        </div>
                        <div class="pm-field">
                            <label for="pm_editStatus">Status</label>
                            <select id="pm_editStatus" class="pm-control">
                                <option value="Active">Active</option>
                                <option value="Deactive">Inactive</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer pm-modal-footer">
                    <button type="button" class="pm-btn pm-btn-light" data-dismiss="modal">Cancel</button>
                    <button type="button" class="pm-btn pm-btn-primary" id="pm_btnSaveEdit">
                        <i class="fas fa-save"></i>Save Changes
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="../plugins/sweetalert2/sweetalert2.all.min.js"></script>
    <script src="../Scripts/Functions/ProjectMaster.js"></script>
</asp:Content>
