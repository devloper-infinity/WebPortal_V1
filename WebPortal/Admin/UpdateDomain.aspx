<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="UpdateDomain.aspx.cs" Inherits="WebPortal.Admin.UpdateDomain" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.8/css/jquery.dataTables.min.css" />
    <link rel="stylesheet" href="https://cdn.datatables.net/fixedheader/3.4.0/css/fixedHeader.dataTables.min.css" />
    <link rel="stylesheet" href="https://cdn.datatables.net/fixedcolumns/4.3.0/css/fixedColumns.dataTables.min.css" />
    <script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/fixedheader/3.4.0/js/dataTables.fixedHeader.min.js"></script>
    <script src="https://cdn.datatables.net/fixedcolumns/4.3.0/js/dataTables.fixedColumns.min.js"></script>

    <style>
        :root {
            --ud-primary: #2563eb;
            --ud-primary-dark: #1d4ed8;
            --ud-accent: #22c1dc;
            --ud-bg: #f5f7fb;
            --ud-card: #ffffff;
            --ud-text: #0f172a;
            --ud-muted: #64748b;
            --ud-border: #e2e8f0;
            --ud-soft: #eff6ff;
            --ud-shadow: 0 18px 45px rgba(15, 23, 42, .08);
        }

        body { background: var(--ud-bg); }

      
        .ud-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            gap: 18px;
            padding: 22px 28px;
            border-radius: 22px;
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%);
            box-shadow: var(--ud-shadow);
        }

        .ud-hero:before,
        .ud-hero:after {
            content: "";
            position: absolute;
            border-radius: 999px;
            background: rgba(255, 255, 255, .12);
        }

        .ud-hero:before {
            width: 220px;
            height: 220px;
            right: 70px;
            top: -120px;
        }

        .ud-hero:after {
            width: 300px;
            height: 300px;
            right: -90px;
            bottom: -170px;
        }

        .ud-hero-icon {
            position: relative;
            z-index: 1;
            width: 50px;
            height: 50px;
            display: grid;
            place-items: center;
            flex-shrink: 0;
            border-radius: 18px;
            background: rgba(255, 255, 255, .16);
            border: 1px solid rgba(255, 255, 255, .22);
            font-size: 24px;
        }

        .ud-hero-content {
            position: relative;
            z-index: 1;
        }

        .ud-title {
            margin: 0;
            font-size: 19px;
            font-weight: 800;
            letter-spacing: -.02em;
        }

        .ud-subtitle {
            margin: 8px 0 0;
            font-size: 12px;
            opacity: .9;
        }

        .ud-card {
            margin-top: 22px;
            padding: 22px;
            border: 1px solid var(--ud-border);
            border-radius: 22px;
            background: var(--ud-card);
            box-shadow: var(--ud-shadow);
        }

        .ud-section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 18px;
            color: var(--ud-text);
            font-size: 16px;
            font-weight: 800;
        }

        .ud-section-title i {
            width: 34px;
            height: 34px;
            display: inline-grid;
            place-items: center;
            border-radius: 12px;
            background: var(--ud-soft);
            color: var(--ud-primary);
        }

        .main-container {
            width: 100%;
            padding: 0;
        }

        .my-row {
            display: grid;
            grid-template-columns: repeat(4, minmax(160px, 1fr));
            gap: 16px;
            align-items: end;
            margin-bottom: 0;
            width: 100%;
        }

        .my-col-3,
        .my-col-12 {
            width: 100%;
            padding-right: 0;
        }

        label,
        .form-label {
            display: block;
            margin-bottom: 8px;
            color: var(--ud-muted);
            font-size: 12px;
            font-weight: 800;
            letter-spacing: .02em;
        }

        .req,
        .text-danger {
            color: #ef4444 !important;
            font-weight: 900;
            margin-left: 3px;
        }

        .my-input,
        .my-select,
        .form-select,
        .form-control {
            width: 100%;
            height: 46px;
            border: 1px solid var(--ud-border);
            padding: 9px 14px;
            border-radius: 14px;
            font-size: 13px;
            font-weight: 400;
            color: var(--ud-text);
            background-color: #fff;
            outline: none;
            box-shadow: none;
            transition: border-color .18s ease, box-shadow .18s ease, transform .18s ease;
        }

        .my-input:focus,
        .my-select:focus,
        .form-control:focus,
        .form-select:focus {
            border-color: var(--ud-primary);
            box-shadow: 0 0 0 4px rgba(37, 99, 235, .12);
        }

        textarea.my-input {
            height: 90px;
            resize: vertical;
        }

        .btn,
        .my-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-height: 44px;
            padding: 0 18px;
            border: 0;
            border-radius: 14px;
            font-size: 14px;
            font-weight: 800;
            text-decoration: none;
            cursor: pointer;
            transition: transform .18s ease, box-shadow .18s ease, background .18s ease;
        }

        .btn:hover,
        .my-btn:hover {
            transform: translateY(-1px);
            text-decoration: none;
        }

        .btn-gradient-primary,
        .btn-primary,
        .primary {
            background: linear-gradient(135deg, var(--ud-primary), var(--ud-accent)) !important;
            color: #fff !important;
            box-shadow: 0 12px 24px rgba(37, 99, 235, .24);
        }

        .btn-gradient-primary:hover,
        .btn-primary:hover,
        .primary:hover {
            color: #fff !important;
            box-shadow: 0 16px 30px rgba(37, 99, 235, .32);
        }

        .success {
            background: linear-gradient(135deg, #22c55e, #15803d);
            color: #fff;
        }

        .warning {
            background: linear-gradient(135deg, #f59e0b, #d97706);
            color: #fff;
        }

        .ud-table-wrap {
            width: 100%;
            overflow-x: auto;
            border-radius: 18px;
            background: #fff;
        }

        #table_updomain {
            width: 100% !important;
            margin: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0;
            white-space: nowrap;
        }

        #table_updomain thead th {
            border: 0 !important;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%) !important;
            color: #fff !important;
            font-size: 12px;
            font-weight: 900;
            text-align: center;
            vertical-align: middle;
            letter-spacing: .02em;
        }

        #table_updomain tbody td {
            padding: 12px !important;
            border-bottom: 1px solid var(--ud-border) !important;
            color: #334155;
            font-size: 13px;
            vertical-align: middle;
        }

        #table_updomain tbody tr:hover td {
            background: #f8fbff;
        }

        #table_updomain input[type="checkbox"] {
            width: 16px;
            height: 16px;
            accent-color: var(--ud-primary);
        }

        table.dataTable thead th::before,
        table.dataTable thead th::after {
            display: none !important;
        }

        .top {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
            padding-bottom: 12px;
        }

        .dataTables_length,
        .dt-buttons {
            margin-right: 10px;
        }

        .dataTables_filter {
            margin-left: auto;
        }

        .dataTables_filter input,
        .dataTables_length select,
        #filter_rows input,
        #filter_row input,
        #filter_row select {
            min-height: 34px;
            border: 1px solid var(--ud-border);
            border-radius: 12px;
            padding: 6px 10px;
            font-size: 12px;
            outline: none;
        }

        #filter_row { background-color: #f8fafc; }

        .modal-content {
            overflow: hidden;
            border: 0;
            border-radius: 22px;
            box-shadow: 0 24px 60px rgba(15, 23, 42, .22);
        }

        .modal-header {
            border-bottom: 0;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%) !important;
            color: #fff;
            padding: 18px 22px;
        }

        #updomain_Header {
            margin: 0;
            color: #fff !important;
            font-size: 18px !important;
            font-weight: 900 !important;
        }

        .modal-body {
            padding: 24px;
            background: #f8fafc;
        }

        .modal-footer {
            padding: 16px 22px;
            border-top: 1px solid var(--ud-border);
            background: #fff;
        }

        .btn-light {
            background: #f1f5f9 !important;
            color: #334155 !important;
        }

        .close {
            opacity: 1;
            text-shadow: none;
        }

        .loading {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            padding: 22px;
            width: 210px;
            min-height: 190px;
            text-align: center;
            background: rgba(255,255,255,.92);
            border: 1px solid var(--ud-border);
            border-radius: 24px;
            box-shadow: var(--ud-shadow);
            z-index: 99999;
        }

        @media (max-width: 991px) {
            .ud-page { padding: 16px; }
            .my-row { grid-template-columns: repeat(2, minmax(160px, 1fr)); }
            .dataTables_filter { margin-left: 0; }
        }

        @media (max-width: 575px) {
            .ud-hero { align-items: flex-start; padding: 20px; }
            .ud-title { font-size: 20px; }
            .my-row { grid-template-columns: 1fr; }
        }
    </style>

    <script>
        $(document).ready(function () {
            updomain_bindDomains();
            updomain_bindSubDomains();
            updomain_bindgrid();
        });
    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="ud-page">
        <section class="ud-hero">
            <div class="ud-hero-icon"><i class="bi bi-diagram-3-fill"></i></div>
            <div class="ud-hero-content">
                <h1 class="ud-title">Update Domain</h1>
                <p class="ud-subtitle">Change employee domain, sub domain and process details quickly.</p>
            </div>
        </section>

        <div class="ud-card">
            <div class="ud-section-title"><i class="bi bi-sliders"></i><span>Domain Update Panel</span></div>
            <div class="main-container">
                <div class="my-row">
                    <div class="my-col-3">
                        <label>Domain<b><span class="req">*</span></b></label>
                        <select class="my-select" id="updomain_domain" onchange="otherTask_bindProcess(this)"></select>
                    </div>

                    <div class="my-col-3">
                        <label>Sub Domain<b><span class="req">*</span></b></label>
                        <select class="my-select" id="updomain_subdomain"></select>
                    </div>

                    <div class="my-col-3">
                        <label>Process<span class="req"></span></label>
                        <input type="text" id="updomain_process" class="my-select" />
                    </div>

                    <div class="my-col-3">
                        <label>&nbsp;</label>
                        <button type="submit" id="updomain_update" class="btn btn-gradient-primary w-100" onclick="return updomain_submit();"><i class="bi bi-arrow-repeat"></i>&nbsp; Update Domain</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="ud-card">
            <div class="ud-section-title"><i class="bi bi-people"></i><span>Employee Domain List</span></div>
            <div class="ud-table-wrap">
                <table class="table" id="table_updomain" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top" style="text-wrap: nowrap; width: 100px;">Sr. #</th>
                            <th class="no-sort"><input type="checkbox" id="updomain_selectAll" /></th>
                            <th style="width: 50px;">Actions</th>
                            <th class="sort border-top" style="text-wrap: nowrap; width: 100px;">Code</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Name</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Joining Date</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Branch</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Department</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Designation</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Domain</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Subdomain</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Segment</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Reporting Manager</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Job Type</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Latest Login</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Current Status</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="updomain_popUp">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <label id="updomain_Header" name="updomain_Header"></label>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="color: white;">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="container-fluid">
                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label fw-bold">Domain <span class="text-danger">*</span></label>
                                <select class="my-select" id="popUp_domain" onchange="otherTask_bindProcess(this)"></select>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label fw-bold">Sub Domain <span class="text-danger">*</span></label>
                                <select class="my-select" id="popUp_subdomain"></select>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label fw-bold">Process <span class="text-danger">*</span></label>
                                <input class="my-select" id="popUp_process" />
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer d-flex justify-content-between">
                    <button type="button" class="btn btn-light" data-dismiss="modal">Close</button>
                    <button type="submit" id="popUp_update" class="btn btn-primary px-4" onclick="return popUp_submit();"><i class="bi bi-arrow-repeat"></i>Update</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="updomain_waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">System is updating data. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>

</asp:Content>

