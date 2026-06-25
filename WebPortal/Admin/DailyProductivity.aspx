<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="DailyProductivity.aspx.cs" Inherits="WebPortal.Admin.DailyProductivity" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --dp-primary: #2563eb;
            --dp-primary-dark: #1d4ed8;
            --dp-accent: #06b6d4;
            --dp-success: #16a34a;
            --dp-warning: #f59e0b;
            --dp-danger: #dc2626;
            --dp-bg: #f4f7fb;
            --dp-card: #ffffff;
            --dp-border: #e5e7eb;
            --dp-muted: #64748b;
            --dp-text: #0f172a;
            --dp-shadow: 0 16px 42px rgba(15, 23, 42, .08);
            --dp-radius: 18px;
        }

        .content-wrapper, body { background: var(--dp-bg) !important; }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: 600 !important;
            border: none !important;
            color: var(--dp-text);
            margin-bottom: 6px;
        }

        .dp-page {
            padding: 18px 18px 28px;
        }

        .dp-hero {
            background: linear-gradient(135deg, #1e3a8a 0%, #2563eb 48%, #06b6d4 100%);
            border-radius: 24px;
            color: #fff;
            padding: 24px;
            margin-bottom: 18px;
            box-shadow: var(--dp-shadow);
            position: relative;
            overflow: hidden;
        }

        .dp-hero:after {
            content: "";
            position: absolute;
            right: -70px;
            top: -80px;
            width: 240px;
            height: 240px;
            border-radius: 999px;
            background: rgba(255,255,255,.16);
        }

        .dp-title {
            font-size: 24px;
            font-weight: 800;
            letter-spacing: -.02em;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .dp-subtitle {
            margin-top: 6px;
            opacity: .86;
            font-size: 13px;
        }

        .dp-status-grid {
            display: grid;
            grid-template-columns: repeat(5, minmax(145px, 1fr));
            gap: 10px;
            margin-top: 18px;
            position: relative;
            z-index: 2;
        }

        .dp-status-card {
            background: rgba(255,255,255,.14);
            border: 1px solid rgba(255,255,255,.18);
            border-radius: 16px;
            padding: 12px 14px;
            backdrop-filter: blur(6px);
        }

        .dp-status-label {
            display: block;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: .08em;
            opacity: .78;
            margin-bottom: 4px;
        }

        .dp-status-value {
            font-size: 15px;
            font-weight: 800;
            min-height: 20px;
        }

        .dp-live-seconds {
            color: #facc15;
            font-weight: 900;
        }

        .dp-shell-card {
            background: var(--dp-card);
            border: 1px solid var(--dp-border);
            border-radius: var(--dp-radius);
            box-shadow: var(--dp-shadow);
            margin-bottom: 18px;
        }

        .dp-card-header {
            padding: 18px 20px;
            border-bottom: 1px solid var(--dp-border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
        }

        .dp-card-title {
            margin: 0;
            font-size: 17px;
            font-weight: 800;
            color: var(--dp-text);
        }

        .dp-card-subtitle {
            color: var(--dp-muted);
            font-size: 12px;
            margin-top: 2px;
        }

        .dp-card-body { padding: 20px; }

        .dp-tabs {
            display: flex;
            gap: 10px;
            background: #eef4ff;
            padding: 8px;
            border-radius: 16px;
            border: 1px solid #dbeafe;
        }

        .dp-tabs .nav-link {
            border: none !important;
            border-radius: 12px !important;
            color: #1e3a8a !important;
            font-weight: 800;
            padding: 10px 16px;
        }

        .dp-tabs .nav-link.active {
            background: #fff !important;
            color: var(--dp-primary) !important;
            box-shadow: 0 8px 20px rgba(37, 99, 235, .12);
        }

        .dp-form-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(220px, 1fr));
            gap: 16px;
            align-items: end;
        }

        .dp-form-grid.two { grid-template-columns: repeat(2, minmax(220px, 1fr)); }
        .dp-form-grid .span-2 { grid-column: span 2; }
        .dp-form-grid .span-3 { grid-column: span 3; }

        .dp-field .form-control,
        .dp-field select,
        .dp-field textarea,
        .dp-inline-time select {
            width: 100% !important;
            border: 1px solid #d9e2ef;
            border-radius: 12px;
            min-height: 42px;
            font-size: 13px;
            box-shadow: none !important;
        }

        .dp-field textarea { min-height: 84px; resize: vertical; }

        .dp-inline-time {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
        }

        .dp-actions {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 16px;
        }

        .btn {
            border-radius: 12px !important;
            font-weight: 800 !important;
            padding: 9px 16px !important;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--dp-primary), var(--dp-primary-dark)) !important;
            border: 0 !important;
            box-shadow: 0 8px 20px rgba(37, 99, 235, .22);
        }

        .btn-success {
            background: linear-gradient(135deg, #22c55e, #15803d) !important;
            border: 0 !important;
        }

        .btn-danger {
            background: linear-gradient(135deg, #ef4444, #b91c1c) !important;
            border: 0 !important;
        }

        .btn-secondary, .btn-default {
            background: #f1f5f9 !important;
            color: #334155 !important;
            border: 1px solid #dbe3ef !important;
        }

        .dp-section-title {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin: 22px 0 10px;
            gap: 12px;
        }

        .dp-section-title h6 {
            margin: 0;
            font-weight: 900;
            color: var(--dp-text);
        }

        .dp-chip {
            font-size: 11px;
            color: #1e40af;
            background: #dbeafe;
            border-radius: 999px;
            padding: 5px 10px;
            font-weight: 800;
        }

        .dp-table-wrap {
            border: 1px solid var(--dp-border);
            border-radius: 16px;
            overflow: hidden;
            background: #fff;
        }

        .table {
            margin-bottom: 0 !important;
            font-size: 12px;
        }

        .table thead th,
        .table.dataTable th {
            background: #f8fafc !important;
            color: #0f172a !important;
            border-bottom: 1px solid var(--dp-border) !important;
            font-weight: 900 !important;
            white-space: nowrap;
            vertical-align: middle;
        }

        .table tbody td {
            vertical-align: middle;
            background: #fff !important;
            border-color: #eef2f7 !important;
        }

        .dataTables_wrapper { padding: 12px; }
        .dataTables_length, .dataTables_info { float: left !important; }
        div.dt-buttons { position: static; float: left; margin-right: 12px; }
        .buttons-excel, .buttons-html5 {
            color: #fff !important;
            background: linear-gradient(135deg, #fb7185, #f97316) !important;
            border: 0 !important;
            font-weight: 800 !important;
            border-radius: 10px !important;
            margin: 0 6px 8px 0 !important;
        }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 99999;
            background: rgba(15, 23, 42, .42);
            align-items: center;
            justify-content: center;
            text-align: center;
        }

        .loading-inner {
            width: 210px;
            background: #fff;
            border-radius: 20px;
            padding: 24px;
            box-shadow: var(--dp-shadow);
            color: var(--dp-text);
            font-weight: 800;
        }

        .dp-spinner {
            width: 46px;
            height: 46px;
            border: 5px solid #dbeafe;
            border-top-color: var(--dp-primary);
            border-radius: 50%;
            animation: dpSpin .8s linear infinite;
            margin: 0 auto 12px;
        }

        @keyframes dpSpin { to { transform: rotate(360deg); } }

        .modal-content { border-radius: 18px !important; border: 0 !important; overflow: hidden; }
        .modal-header { background: #f8fafc; border-bottom: 1px solid var(--dp-border); }
        .modal-title { font-weight: 900; color: var(--dp-text); }

        @media (max-width: 1200px) {
            .dp-status-grid { grid-template-columns: repeat(2, minmax(145px, 1fr)); }
            .dp-form-grid, .dp-form-grid.two { grid-template-columns: repeat(2, minmax(220px, 1fr)); }
            .dp-form-grid .span-3 { grid-column: span 2; }
        }

        @media (max-width: 768px) {
            .dp-page { padding: 12px; }
            .dp-status-grid, .dp-form-grid, .dp-form-grid.two { grid-template-columns: 1fr; }
            .dp-form-grid .span-2, .dp-form-grid .span-3 { grid-column: span 1; }
            .dp-card-header { flex-direction: column; align-items: flex-start; }
            .dp-tabs { width: 100%; }
            .dp-tabs .nav-item { flex: 1; text-align: center; }
        }
    </style>

    <script>
        (function () {
            var booted = false;
            var autoLoaded = false;

            function todayIso() {
                var d = new Date();
                var m = String(d.getMonth() + 1).padStart(2, '0');
                var day = String(d.getDate()).padStart(2, '0');
                return d.getFullYear() + '-' + m + '-' + day;
            }

            function callIfExists(name) {
                if (typeof window[name] === 'function') {
                    try { return window[name].apply(window, Array.prototype.slice.call(arguments, 1)); }
                    catch (e) { if (window.console) console.error(name, e); }
                }
            }

            function initDailyProductivity() {
                if (booted) return;
                booted = true;

                var currEmp = '<%= HttpContext.Current.User.Identity.Name.ToString() %>';
                var today = todayIso();
                $('#date,#autoDate,#clientorderdate').val(today).attr('max', today);

                callIfExists('BindProdInfo');
                callIfExists('BindDomain');
                callIfExists('BindTempGrid');
                callIfExists('BindHoursMinutes');
                callIfExists('BindProjects', currEmp);
                callIfExists('BindProdGrid');
            }

            function loadAutoTab() {
                if (autoLoaded) return;
                autoLoaded = true;
                var autoDate = $('#autoDate').val() || todayIso();
                callIfExists('BindAutoProd', autoDate, 0);
                callIfExists('BindMissingProcess');
            }

            $(document).ready(function () {
                initDailyProductivity();

                $('a[data-toggle="pill"][href="#custom-tabs-one-profile"]').one('shown.bs.tab', loadAutoTab);
                $('#autoDate').on('change', function () { autoLoaded = false; loadAutoTab(); });
            });
        })();
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <label id="prodCode" name="prodCode" style="display:none;" runat="server"></label>

   <%-- <div class="loading" id="load1">
        <div class="loading-inner">
            <div class="dp-spinner"></div>
            <div>One moment, please...</div>
        </div>
    </div>--%>

    <div class="dp-page">
        <div class="dp-hero">
            <div class="row align-items-center">
                <div class="col-lg-7">
                    <h1 class="dp-title"><i class="fas fa-chart-line"></i> Daily Productivity</h1>
                    <div class="dp-subtitle">Add manual productivity, review auto-tracked production, and monitor daily time status.</div>
                </div>
            </div>
            <div class="dp-status-grid">
                <div class="dp-status-card"><span class="dp-status-label">Current Login</span><span class="dp-status-value" id="dailyprod_logtinimedisplay"></span></div>
                <div class="dp-status-card"><span class="dp-status-label">Upto Time</span><span class="dp-status-value" id="dailyprod_tilltimedisplay"></span></div>
                <div class="dp-status-card"><span class="dp-status-label">Break Out</span><span class="dp-status-value" id="dailyprod_breakouttimedisplay"></span></div>
                <div class="dp-status-card"><span class="dp-status-label">Break In</span><span class="dp-status-value" id="dailyprod_breakintimedisplay"></span></div>
                <div class="dp-status-card"><span class="dp-status-label">Total Break</span><span class="dp-status-value" id="dailyprod_breaktimedisplay"></span></div>
            </div>
        </div>

        <div class="dp-shell-card">
            <div class="dp-card-header">
                <div>
                    <h5 class="dp-card-title">Productivity Entry</h5>
                    <div class="dp-card-subtitle">Manual entry loads first. Auto productivity loads only when the tab is opened.</div>
                </div>
                <ul class="nav nav-tabs dp-tabs" id="custom-tabs-one-tab" role="tablist">
                    <li class="nav-item"><a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Manual Productivity</a></li>
                    <li class="nav-item"><a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">Auto Productivity</a></li>
                </ul>
            </div>

            <div class="dp-card-body tab-content" id="custom-tabs-one-tabContent">
                <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                    <div class="dp-form-grid">
                        <div class="dp-field"><label>Client Order Date</label><input type="date" id="clientorderdate" name="clientorderdate" class="form-control" /></div>
                        <div class="dp-field"><label>Date</label><input type="date" id="date" name="date" class="form-control" /></div>
                        <div class="dp-field"><label>Project</label><select id="projects" name="projects" class="form-control" onchange="onprojectclick();"><option value="Select">Select</option></select></div>
                        <div class="dp-field"><label>Process</label><select id="process" name="process" class="form-control" onchange="onprocessclick();"><option value="Select">Select</option></select></div>
                        <div class="dp-field"><label>Product Type</label><select id="producttype" name="producttype" class="form-control" onchange="onproductclick();"><option value="Select">Select</option></select></div>
                        <div class="dp-field"><label>Target</label><input type="text" id="target" name="target" class="form-control" readonly="readonly" /></div>
                        <div class="dp-field"><label>Production</label><input type="text" id="production" name="production" class="form-control" /></div>
                        <div class="dp-field"><label>ERP Production</label><input type="text" id="erpproduction" name="erpproduction" class="form-control" disabled="disabled" /></div>
                        <div class="dp-field"><label>Time Spent</label><div class="dp-inline-time"><select id="hours" name="hours" class="form-control"><option value="Select">Hours</option></select><select id="minutes" name="minutes" class="form-control"><option value="Select">Minutes</option></select></div></div>
                        <div class="dp-field"><label>Production Type</label><select id="productiontype" name="productiontype" class="form-control"><option value="Select">Select</option><option value="Test">Test</option><option value="Practice">Practice</option><option value="Live">Live</option><option value="Rework">Rework</option><option value="Training">Training</option><option value="Clean up Activity">Clean up Activity</option><option value="System down">System down</option><option value="Huddle/Meeting">Huddle/Meeting</option><option value="Test Loans">Test Loans</option><option value="Live Work with No Project">Live Work with No Project</option><option value="New Client Test Loans">New Client Test Loans</option><option value="New Client Test QC">New Client Test QC</option><option value="Work From Home">Work From Home</option></select></div>
                        <div class="dp-field span-2"><label>Remark</label><textarea id="remark" name="remark" class="form-control"></textarea></div>
                    </div>
                    <div class="dp-actions"><button type="button" class="btn btn-primary" id="btnsubmit" name="btnsubmit" onclick="submitTempProductivity();"><i class="fas fa-plus"></i> Add</button><button type="button" class="btn btn-secondary" id="reset" style="display:none;" onclick="location.reload();">Reset</button></div>

                    <div class="dp-section-title"><h6>Pending Productivity Entries</h6><span class="dp-chip">Temporary records</span></div>
                    <div class="dp-table-wrap table-responsive">
                        <table class="table table-hover" id="tempprod" style="width:100%;">
                            <thead><tr><th style="text-align:center">Delete</th><th>Date</th><th>Project</th><th>Process</th><th>Product Type</th><th>Target</th><th>Production</th><th>Time Spent</th><th>Production Type</th><th>Status</th><th>Remark</th><th style="display:none;">ProjectID</th><th style="display:none;">ProcessID</th><th style="display:none;">ProductID</th><th style="display:none;">ClientOrderDate</th><th style="display:none;">EmployeeID</th><th style="display:none;">Hours</th><th style="display:none;">Minutes</th></tr></thead>
                            <tbody></tbody>
                        </table>
                    </div>
                    <div class="dp-actions" style="justify-content:center;"><button id="btnSaveExit" type="button" class="btn btn-success" onclick="return SaveProductivity();"><i class="fas fa-save"></i> Save & Exit</button></div>
                </div>

                <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                    <div class="dp-form-grid two">
                        <div class="dp-field"><label>Date</label><input type="date" id="autoDate" name="autoDate" class="form-control" /></div>
                        <div class="dp-field"><label>Domain</label><select id="autoDomain" name="autoDomain" class="form-control" onchange="showAutoProdData(this);"><option value="Select">Select</option></select></div>
                    </div>
                    <div class="dp-actions"><button type="button" class="btn btn-success" id="btnApprove" name="btnApprove" onclick="approveProductivity();"><i class="fas fa-check"></i> Approve</button><button type="button" class="btn btn-danger" id="btnReject" name="btnReject" onclick="rejectProductivity();"><i class="fas fa-times"></i> Reject</button></div>

                    <div class="dp-section-title"><h6>Auto Productivity</h6><span class="dp-chip">Tracking records</span></div>
                    <div class="dp-table-wrap table-responsive">
                        <table class="table table-hover" id="autoProd_table" style="width:100%;">
                            <thead><tr><th style="text-align:center;">Action</th><th>Date</th><th>Project</th><th>Tracking Process</th><th>Process</th><th>Target</th><th>Production</th><th>Time Spent</th><th>Status</th><th>Remark</th><th style="display:none;">TrackingProductionID</th><th style="display:none;">Code</th><th style="display:none;">ClientOrderDate</th></tr></thead>
                            <tbody></tbody>
                        </table>
                    </div>

                    <div class="dp-section-title"><h6>Missing Process Orders</h6><span class="dp-chip">Needs review</span></div>
                    <div class="dp-table-wrap table-responsive">
                        <table class="table table-hover" id="prosMissing_table" style="width:100%;">
                            <thead><tr><th>Sr. #</th><th>Date</th><th>Client Order Date</th><th>Project</th><th>Tracking Process</th><th>Order #</th><th style="text-align:center;">Production</th><th style="text-align:center;">Time Spent</th></tr></thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="dp-shell-card">
            <div class="dp-card-header"><div><h5 class="dp-card-title">Saved Productivity Details</h5><div class="dp-card-subtitle">Submitted productivity history for the current user.</div></div></div>
            <div class="dp-card-body">
                <div class="dp-table-wrap table-responsive">
                    <table class="table table-hover" id="table_detailProd" style="width:100%;">
                        <thead><tr><th>Sr. #</th><th>Date</th><th>Client Order Date</th><th>Project</th><th>Process</th><th>Product Type</th><th>Production</th><th>Target</th><th>Production Type</th><th>Time Spent</th><th>Status</th><th>Remark</th></tr></thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="popup_editProd">
        <div class="modal-dialog modal-xl"><div class="modal-content">
            <div class="modal-header"><h4 class="modal-title">Edit Productivity</h4><button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button></div>
            <div class="modal-body">
                <div class="dp-form-grid">
                    <div class="dp-field"><label>Client Order Date</label><input type="date" id="edit_clientorderdate" name="edit_clientorderdate" class="form-control" /></div>
                    <div class="dp-field"><label>Date</label><input type="date" id="edit_date" name="edit_date" class="form-control" /></div>
                    <div class="dp-field"><label>Project</label><select id="edit_projects" name="edit_projects" class="form-control" disabled="disabled"><option value="Select">Select</option></select></div>
                    <div class="dp-field"><label>Process</label><select id="edit_process" name="edit_process" class="form-control" disabled="disabled"><option value="Select">Select</option></select></div>
                    <div class="dp-field"><label>Product Type</label><select id="edit_producttype" name="edit_producttype" class="form-control" disabled="disabled"><option value="Select">Select</option></select></div>
                    <div class="dp-field"><label>Target</label><input type="text" id="edit_target" name="edit_target" class="form-control" disabled="disabled" /></div>
                    <div class="dp-field"><label>Production</label><input type="text" id="edit_production" name="edit_production" class="form-control" /></div>
                    <div class="dp-field"><label>ERP Production</label><input type="text" id="edit_erpproduction" name="edit_erpproduction" class="form-control" disabled="disabled" /></div>
                    <div class="dp-field"><label>Time Spent</label><div class="dp-inline-time"><select id="edit_hours" name="edit_hours" class="form-control"><option value="Select">Hours</option></select><select id="edit_minutes" name="edit_minutes" class="form-control"><option value="Select">Minutes</option></select></div></div>
                    <div class="dp-field"><label>Production Type</label><select id="edit_productiontype" name="edit_productiontype" class="form-control"><option value="Select">Select</option><option value="Test">Test</option><option value="Practice">Practice</option><option value="Live">Live</option><option value="Rework">Rework</option><option value="Training">Training</option><option value="Clean up Activity">Clean up Activity</option><option value="System down">System down</option><option value="Huddle/Meeting">Huddle/Meeting</option><option value="Test Loans">Test Loans</option><option value="Live Work with No Project">Live Work with No Project</option><option value="New Client Test Loans">New Client Test Loans</option><option value="New Client Test QC">New Client Test QC</option><option value="Work From Home">Work From Home</option></select></div>
                    <div class="dp-field span-2"><label>Remark</label><textarea id="edit_remark" name="edit_remark" class="form-control"></textarea></div>
                </div>
            </div>
            <div class="modal-footer justify-content-between"><button type="button" class="btn btn-default" data-dismiss="modal">Close</button><button id="editProd_btn" type="button" onclick="return editProd_btnOnClick();" class="btn btn-primary">Update</button></div>
        </div></div>
    </div>

    <div class="modal fade" id="productivity_dverror">
        <div class="modal-dialog modal-sm"><div class="modal-content"><div class="modal-header"><h6 class="modal-title" id="productivity_errmsg"></h6></div><div class="modal-footer align-content-center"><button class="btn btn-primary" type="button" id="btnMessage" onclick="return location.reload();">Okay</button></div></div></div>
    </div>

    <div class="modal fade" id="popUpdeletetempProd">
        <div class="modal-dialog modal-l"><div class="modal-content"><div class="modal-header"><h4 class="modal-title">Delete Productivity Record</h4><button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button></div><div class="modal-body"><p style="font-size:13px;">Are you sure you want to delete this record?</p></div><div class="modal-footer justify-content-between"><button type="button" class="btn btn-default" data-dismiss="modal">No</button><button class="btn btn-danger" type="button" id="roam_btnYes" onclick="return deleteProdRecord();">Yes, Delete</button></div></div></div>
    </div>

    <div class="modal fade" id="Prodwaitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center"><div class="dp-spinner" style="width:64px;height:64px;border-width:7px;margin-top:120px;"></div><br /><span style="color:#fff;font-size:24px;font-weight:bold;font-style:italic;" id="spntext">System is updating details. Please wait</span><span style="color:#fff;font-size:48px;font-weight:bold;font-style:italic;animation:animate 1s linear infinite;">&nbsp;. . . .</span></div>
    </div>
</asp:Content>
