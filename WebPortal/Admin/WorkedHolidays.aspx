<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="WorkedHolidays.aspx.cs" Inherits="WebPortal.Admin.WorkedHolidays" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --wh-primary: #0b5ed7;
            --wh-primary-dark: #063ca8;
            --wh-cyan: #20c4e8;
            --wh-text: #0f1b3d;
            --wh-muted: #667085;
            --wh-border: #e5eaf3;
            --wh-soft: #f6f9ff;
            --wh-success: #22c55e;
            --wh-warning: #f59e0b;
            --wh-purple: #7c3aed;
        }

        .wh-page {
          
            background: linear-gradient(180deg, #f8fbff 0%, #ffffff 42%, #f8fbff 100%);
            min-height: calc(100vh - 80px);
        }

        .wh-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            padding: 24px 28px;
            margin-bottom: 22px;
            border-radius: 24px;
            background: linear-gradient(120deg, #0436a8 0%, #0b5ed7 58%, #22c1dc 100%);
            color: #fff;
            box-shadow: 0 18px 45px rgba(11, 94, 215, .23);
        }

        .wh-hero:before {
            content: "";
            position: absolute;
            width: 360px;
            height: 360px;
            right: -120px;
            top: -180px;
            border-radius: 50%;
            background: rgba(255, 255, 255, .16);
        }

        .wh-hero:after {
            content: "";
            position: absolute;
            width: 220px;
            height: 220px;
            right: 180px;
            bottom: -150px;
            border-radius: 50%;
            background: rgba(255, 255, 255, .10);
        }

        .wh-hero-left,
        .wh-breadcrumb {
            position: relative;
            z-index: 1;
        }

        .wh-hero-left {
            display: flex;
            align-items: center;
            gap: 18px;
        }

        .wh-hero-icon {
            width: 60px;
            height: 60px;
            display: grid;
            place-items: center;
            border-radius: 18px;
            background: linear-gradient(135deg, rgba(34, 193, 220, .95), rgba(6, 60, 168, .95));
            box-shadow: inset 0 1px 0 rgba(255, 255, 255, .35), 0 14px 30px rgba(3, 22, 70, .22);
        }

        .wh-hero-icon i {
            font-size: 30px;
            color: #fff;
        }

        .wh-hero-title {
            margin: 0;
            font-size: 22px;
            line-height: 1.15;
            font-weight: 800;
            letter-spacing: -.5px;
        }

        .wh-hero-subtitle {
            margin: 6px 0 0;
            color: rgba(255, 255, 255, .86);
            font-size: 15px;
            font-weight: 400;
        }

        .wh-breadcrumb {
            display: flex;
            align-items: center;
            gap: 9px;
            padding: 10px 14px;
            border: 1px solid rgba(255, 255, 255, .22);
            border-radius: 999px;
            background: rgba(255, 255, 255, .13);
            backdrop-filter: blur(10px);
            color: rgba(255, 255, 255, .9);
            font-size: 13px;
            white-space: nowrap;
        }

        .wh-breadcrumb i { color: #fff; }
        .wh-breadcrumb b { color: #fff; }

        .wh-stat-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(180px, 1fr));
            gap: 18px;
            margin-bottom: 22px;
        }

        .wh-stat-card {
            position: relative;
            overflow: hidden;
            min-height: 112px;
            display: flex;
            align-items: center;
            gap: 16px;
            padding: 22px;
            border: 1px solid var(--wh-border);
            border-radius: 18px;
            background: #fff;
            box-shadow: 0 12px 34px rgba(16, 24, 40, .07);
        }

        .wh-stat-card:after {
            content: attr(data-watermark);
            position: absolute;
            right: 18px;
            bottom: -22px;
            font-size: 76px;
            line-height: 1;
            font-weight: 900;
            color: rgba(15, 27, 61, .05);
        }

        .wh-stat-blue { background: linear-gradient(135deg, #fff 0%, #f0f7ff 100%); border-color: #cfe5ff; }
        .wh-stat-green { background: linear-gradient(135deg, #fff 0%, #f2fff5 100%); border-color: #ccefd5; }
        .wh-stat-orange { background: linear-gradient(135deg, #fff 0%, #fff8ec 100%); border-color: #ffe2ad; }
        .wh-stat-purple { background: linear-gradient(135deg, #fff 0%, #fbf7ff 100%); border-color: #e7d6ff; }

        .wh-stat-icon {
            width: 46px;
            height: 46px;
            min-width: 46px;
            display: grid;
            place-items: center;
            border-radius: 50%;
            color: #fff;
            font-size: 23px;
            box-shadow: 0 12px 26px rgba(0, 0, 0, .15);
        }

        .wh-stat-blue .wh-stat-icon { background: linear-gradient(135deg, #1687ff, #0256d9); }
        .wh-stat-green .wh-stat-icon { background: linear-gradient(135deg, #35d05f, #16a34a); }
        .wh-stat-orange .wh-stat-icon { background: linear-gradient(135deg, #ffb020, #f97316); }
        .wh-stat-purple .wh-stat-icon { background: linear-gradient(135deg, #9b4dff, #6d28d9); }

        .wh-stat-label {
            margin: 0;
            color: var(--wh-muted);
            font-size: 13px;
            font-weight: 600;
        }

        .wh-stat-value {
            margin: 3px 0 2px;
            color: var(--wh-text);
            font-size: 25px;
            line-height: 1;
            font-weight: 800;
        }

        .wh-stat-note {
            margin: 0;
            color: var(--wh-muted);
            font-size: 12px;
        }

        .wh-card {
            border: 1px solid var(--wh-border);
            border-radius: 18px;
            background: #fff;
            box-shadow: 0 14px 40px rgba(16, 24, 40, .07);
            overflow: hidden;
        }

        .wh-card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            padding: 18px 20px;
            border-bottom: 1px solid var(--wh-border);
            background: linear-gradient(180deg, #fff, #fbfdff);
        }

        .wh-section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0;
            color: var(--wh-text);
            font-size: 17px;
            font-weight: 800;
        }

        .wh-section-title i { color: var(--wh-primary); }

        .wh-export-chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 13px;
            border: 1px solid var(--wh-border);
            border-radius: 10px;
            background: #fff;
            color: var(--wh-text);
            font-size: 13px;
            font-weight: 700;
        }

        .wh-card-body { padding: 12px 14px 18px; }
/*
        .loading {
            display: none;
            position: fixed;
            inset: 0;
            width: 100%;
            height: 100%;
            z-index: 99999;
            background: rgba(255, 255, 255, .72);
            backdrop-filter: blur(3px);
            text-align: center;
        }*/

        .loading .wh-loader-box {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            min-width: 190px;
            padding: 22px 24px;
            border-radius: 18px;
            background: #fff;
            border: 1px solid var(--wh-border);
            box-shadow: 0 16px 45px rgba(16, 24, 40, .16);
            color: var(--wh-text);
            font-size: 12px;
            font-weight: 800;
        }

        .loading img {
            max-width: 70px;
            display: block;
            margin: 0 auto 10px;
        }

        .dataTables_wrapper { color: var(--wh-text); }

        .dataTables_length,
        .dataTables_info {
            float: left !important;
            color: var(--wh-muted) !important;
            font-size: 13px;
            padding-top: 14px !important;
        }

        .dataTables_filter {
            float: right !important;
            margin-bottom: 12px;
        }

        .dataTables_filter label,
        .dataTables_length label {
            color: var(--wh-muted) !important;
            font-weight: 600 !important;
        }

        .dataTables_filter input,
        .dataTables_length select {
            border: 1px solid var(--wh-border) !important;
            border-radius: 10px !important;
            height: 38px !important;
            padding: 6px 12px !important;
            outline: none !important;
            box-shadow: none !important;
        }

        div.dt-buttons {
            position: static;
            float: left;
            padding-left: 18px;
            padding-top: 8px;
        }

        .buttons-excel,
        .buttons-html5 {
            color: #fff !important;
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%) !important;
            border: 0 !important;
            border-radius: 10px !important;
            font-weight: 800 !important;
            box-shadow: 0 10px 22px rgba(37, 117, 252, .22) !important;
            margin: 0 8px !important;
            padding: 8px 14px !important;
        }

        .dataTables_scrollBody {
            min-height: 100px !important;
            height: auto;
            border-bottom: 1px solid var(--wh-border) !important;
        }

        .table.dataTable {
            width: 100% !important;
            border-collapse: separate !important;
            border-spacing: 0 !important;
            border: 1px solid var(--wh-border);
            border-radius: 14px;
            overflow: hidden;
        }

        .table.dataTable thead th {
            border-color: rgba(255, 255, 255, .18) !important;
            font-size: 13px;
            font-weight: 800;
            white-space: nowrap;
            vertical-align: middle;
        }

        .table.dataTable tbody td {
            background: #fff !important;
            color: var(--wh-text);
            border-color: var(--wh-border) !important;
            font-size: 13px;
            padding: 13px 16px !important;
            vertical-align: middle;
        }

        .table.dataTable tbody tr:hover td {
            background: #f8fbff !important;
        }

        .table.dataTable tbody tr td:first-child,
        .table.dataTable thead tr th:first-child {
            text-align: center;
        }

        .paginate_button,
        .page-link {
            border-radius: 9px !important;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: 600 !important;
            border: none !important;
        }

        .wh-modal .modal-dialog { max-width: 1120px; }

        .wh-modal .modal-content {
            border: 0;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 28px 80px rgba(15, 27, 61, .25);
        }

        .wh-modal-header {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 22px 24px;
            background: linear-gradient(120deg, #0436a8 0%, #0b5ed7 62%, #22c1dc 100%);
            color: #fff;
        }

        .wh-modal-header:after {
            content: "";
            position: absolute;
            width: 220px;
            height: 220px;
            right: -90px;
            top: -130px;
            border-radius: 50%;
            background: rgba(255, 255, 255, .15);
        }

        .wh-modal-title-wrap {
            display: flex;
            align-items: center;
            gap: 14px;
            position: relative;
            z-index: 1;
        }

        .wh-modal-icon {
            width: 52px;
            height: 52px;
            display: grid;
            place-items: center;
            border-radius: 16px;
            background: rgba(255, 255, 255, .16);
            border: 1px solid rgba(255, 255, 255, .22);
        }

        .wh-modal-icon i { font-size: 24px; }

        .wh-modal-title {
            margin: 0;
            font-size: 20px;
            font-weight: 800;
        }

        .wh-modal-subtitle {
            margin: 4px 0 0;
            color: rgba(255, 255, 255, .85);
            font-size: 13px;
        }

        .wh-modal .close {
            position: relative;
            z-index: 2;
            width: 40px;
            height: 40px;
            display: grid;
            place-items: center;
            border-radius: 50%;
            background: rgba(255, 255, 255, .16);
            opacity: 1;
            color: #fff;
            text-shadow: none;
        }

        .wh-modal .modal-body {
            padding: 20px;
            background: #f8fbff;
        }

        .wh-inner-card {
            border: 1px solid var(--wh-border);
            border-radius: 16px;
            background: #fff;
            box-shadow: 0 12px 30px rgba(16, 24, 40, .06);
            overflow: hidden;
        }

        .wh-inner-card-header {
            display: flex;
            align-items: center;
            gap: 9px;
            padding: 15px 18px;
            border-bottom: 1px solid var(--wh-border);
            color: var(--wh-text);
            font-weight: 800;
            background: #fff;
        }

        .wh-inner-card-header i { color: var(--wh-primary); }

        .wh-remark-wrap { margin-top: 18px; }

        .wh-remark-label {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 8px;
            color: var(--wh-text);
            font-weight: 800 !important;
        }

        .wh-remark-wrap textarea {
            border: 1px solid var(--wh-border);
            border-radius: 14px;
            min-height: 105px;
            resize: vertical;
            box-shadow: none !important;
        }

        .wh-modal .modal-footer {
            padding: 16px 20px;
            border-top: 1px solid var(--wh-border);
            background: #fff;
        }

        .btn-wh-approve {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            min-width: 120px;
            justify-content: center;
            height: 42px;
            padding: 0 18px;
            border: 0;
            border-radius: 12px;
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%) !important;
            color: #fff !important;
            font-weight: 800;
            box-shadow: 0 12px 26px rgba(37, 117, 252, .26);
            transition: .2s ease;
        }

        .btn-wh-approve:hover {
            transform: translateY(-1px);
            color: #fff !important;
            box-shadow: 0 16px 32px rgba(37, 117, 252, .34);
        }

        @media (max-width: 1199px) {
            .wh-stat-grid { grid-template-columns: repeat(2, 1fr); }
        }

        @media (max-width: 767px) {
            .wh-page { padding: 8px 8px 24px; }
            .wh-hero { flex-direction: column; align-items: flex-start; padding: 20px; border-radius: 18px; }
            .wh-hero-left { align-items: flex-start; }
            .wh-hero-icon { width: 58px; height: 58px; }
            .wh-hero-title { font-size: 24px; }
            .wh-breadcrumb { white-space: normal; }
            .wh-stat-grid { grid-template-columns: 1fr; }
            .wh-card-header { flex-direction: column; align-items: flex-start; }
            .dataTables_filter, .dataTables_length, div.dt-buttons { float: none !important; padding-left: 0; }
        }
    </style>

    <script>
        $(document).ready(function () {
            wholiday_bindgrid();
        });
    </script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <div class="wh-loader-box">
            <img src="../images/Load_1.gif" alt="Loading" />
            <div>One moment, please . . . .</div>
        </div>
    </div>

    <div class="wh-page">
        <div class="wh-hero">
            <div class="wh-hero-left">
                <div class="wh-hero-icon">
                    <i class="fas fa-calendar-check"></i>
                </div>
                <div>
                    <h1 class="wh-hero-title">Worked Holidays</h1>
                    <p class="wh-hero-subtitle">View, approve and manage employees who worked on holidays.</p>
                </div>
            </div>
        </div>

        <div class="wh-card">
            <div class="wh-card-header">
                <h2 class="wh-section-title"><i class="fas fa-users"></i> Worked Holidays List</h2>
            </div>
            <div class="wh-card-body">
                <div class="table-responsive">
                    <table class="table table-hover table-bordered" style="width: 100%;" id="wholidays_table">
                        <thead>
                            <tr>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Action</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Days</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Reporting Manager</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade wh-modal" id="wholiday_detailspop" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-xl" role="document">
            <div class="modal-content">
                <div class="wh-modal-header">
                    <div class="wh-modal-title-wrap">
                        <div class="wh-modal-icon"><i class="fas fa-calendar-check"></i></div>
                        <div>
                            <h5 class="wh-modal-title">Worked Holiday Details</h5>
                            <p class="wh-modal-subtitle">Employee: <span id="wholiday_popup_name"></span></p>
                        </div>
                    </div>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                </div>

                <div class="modal-body">
                    <div class="wh-inner-card">
                        <div class="wh-inner-card-header"><i class="fas fa-list-ul"></i> Activity Log</div>
                        <div class="table-responsive w-100">
                            <table class="table table-hover table-bordered w-100 mb-0" id="wholiday_logdetails">
                                <thead>
                                    <tr>
                                        <th>Action</th>
                                        <th>Date</th>
                                        <th>In Time</th>
                                        <th>Out Time</th>
                                        <th>Total Hours</th>
                                        <th>In IP</th>
                                        <th>Out IP</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>

                    <div class="wh-remark-wrap">
                        <label class="wh-remark-label" for="wholiday_popup_remark"><i class="fas fa-comment-dots"></i> Remark</label>
                        <textarea id="wholiday_popup_remark" name="wholiday_popup_remark" class="form-control" rows="3" placeholder="Enter approval remark here..."></textarea>
                    </div>
                </div>

                <div class="modal-footer">
                    <button class="btn btn-wh-approve" type="button" id="wholiday_pupup_btnsubmit" onclick="return wholiday_pupup_submit();">
                        <i class="fa fa-check"></i> Approve
                    </button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
