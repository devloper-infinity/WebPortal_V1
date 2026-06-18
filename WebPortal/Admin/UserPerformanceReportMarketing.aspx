<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="UserPerformanceReportMarketing.aspx.cs" Inherits="WebPortal.Admin.UserPerformanceReportMarketing" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        body {
            background: #f4f7fb;
        }

        .loading {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            width: 180px;
            min-height: 150px;
            margin-top: -90px;
            margin-left: -90px;
            padding: 22px 18px;
            border-radius: 14px;
            background: rgba(255, 255, 255, 0.94);
            box-shadow: 0 18px 45px rgba(15, 23, 42, 0.18);
            text-align: center;
            z-index: 99999;
        }

        .loading img {
            max-width: 64px;
            margin-bottom: 12px;
        }

        .upr-header {
            position: relative;
            overflow: hidden;
            margin-bottom: 22px;
            padding: 18px;
            border-radius: 8px;
            background: #fff;
            border: 1px solid #dbe5ec;
            border-top: 3px solid #1f6feb;
            color: #172033;
            box-shadow: 0 10px 28px rgba(15, 23, 42, 0.07);
        }

        .upr-header-row {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 16px;
        }

        .upr-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0;
            font-size: 20px;
            font-weight: 700;
        }

        .upr-title-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 34px;
            height: 34px;
            border-radius: 8px;
            background: #eaf2ff;
            color: #1f6feb;
            font-size: 14px;
        }

        .upr-subtitle {
            margin: 7px 0 0 44px;
            color: #667085;
            font-size: 12px;
        }

        .upr-marketing-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            min-height: 34px;
            padding: 7px 12px;
            border: 1px solid #b9cbe0;
            border-radius: 6px;
            background: #f8fbff;
            color: #1f4f8f;
            font-size: 12px;
            font-weight: 700;
            text-decoration: none;
            white-space: nowrap;
        }

        .upr-marketing-link:hover,
        .upr-marketing-link:focus {
            color: #153e75;
            text-decoration: none;
            background: #edf5ff;
        }

        .upr-page {
            width: 100%;
            padding: 0 2px 26px;
        }

        .upr-shell {
            display: grid;
            gap: 18px;
        }

        .upr-panel {
            background: #fff;
            border: 1px solid #dbe5ec;
            border-radius: 8px;
            box-shadow: 0 8px 22px rgba(15, 23, 42, 0.055);
        }

        .upr-panel-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            padding: 16px 18px;
            border-bottom: 1px solid #e5edf3;
            background: #fbfdff;
            border-radius: 8px 8px 0 0;
        }

        .upr-panel-title {
            margin: 0;
            color: #172033;
            font-size: 15px;
            font-weight: 700;
        }

        .upr-panel-subtitle {
            margin: 4px 0 0;
            color: #6b7788;
            font-size: 12px;
        }

        .upr-panel-body {
            padding: 18px;
        }

        .upr-filter-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 15px;
            align-items: end;
        }

        .upr-field {
            min-width: 0;
        }

        .upr-field label {
            display: block;
            margin-bottom: 6px;
            color: #344054;
            font-size: 12px;
            font-weight: 700 !important;
            border: none !important;
        }

        .upr-field .form-control,
        .upr-field input {
            width: 100%;
            min-height: 40px;
            border: 1px solid #cad6e2;
            border-radius: 6px;
            box-shadow: none;
            color: #172033;
            font-size: 13px;
        }

        .upr-field .form-control:focus,
        .upr-field input:focus {
            border-color: #6ea8fe;
            box-shadow: 0 0 0 3px rgba(31, 111, 235, 0.12);
        }

        .upr-actions {
            display: flex;
            align-items: center;
            gap: 10px;
            grid-column: span 2;
        }

        .upr-primary-action,
        .upr-secondary-action {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-height: 40px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 700;
            white-space: nowrap;
        }

        .upr-primary-action {
            border: 0;
            background: #1f6feb;
            box-shadow: 0 8px 18px rgba(31, 111, 235, 0.22);
        }

        .upr-primary-action:hover,
        .upr-primary-action:focus {
            background: #185abc;
        }

        .upr-secondary-action {
            border: 1px solid #cbd5e1;
            background: #fff;
            color: #334155;
        }

        .upr-secondary-action:hover,
        .upr-secondary-action:focus {
            background: #f8fafc;
            color: #172033;
        }

        .upr-tabs {
            display: flex;
            flex-wrap: wrap;
            gap: 4px;
            margin: 16px 18px 0;
            padding: 4px;
            border: 1px solid #dbe5ec;
            border-radius: 8px;
            background: #f1f5f9;
        }

        .upr-tabs .nav-item {
            margin-bottom: 0;
        }

        .upr-tabs .nav-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            min-height: 38px;
            border: 0;
            border-radius: 6px;
            background: transparent;
            color: #475569;
            font-size: 12px;
            font-weight: 700;
            padding: 9px 13px;
        }

        .upr-tabs .nav-link.active {
            background: #fff;
            color: #1f6feb;
            box-shadow: 0 1px 3px rgba(15, 23, 42, 0.12);
        }

        .upr-tab-body {
            padding: 16px 18px 18px;
        }

        .upr-table-wrap {
            width: 100%;
            overflow-x: auto;
            border: 1px solid #dbe5ec;
            border-radius: 8px;
            background: #fff;
        }

        .upr-data-table {
            width: 100% !important;
            margin: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0;
            color: #253044;
            font-size: 12px;
        }

        .upr-data-table thead th,
        table.dataTable thead th {
            background: #edf3f6 !important;
            border-color: #d7e2ea !important;
            border-bottom: 1px solid #d7e2ea !important;
            color: #263342 !important;
            font-size: 12px;
            font-weight: 700;
            padding: 11px 12px !important;
            text-align: center;
            white-space: nowrap;
        }

        .upr-data-table tbody td,
        table.dataTable tbody td {
            border-bottom: 1px solid #edf2f7;
            padding: 9px 12px !important;
            vertical-align: top;
            background: #fff !important;
        }

        .upr-data-table tbody tr:hover td,
        table.dataTable tbody tr:hover td {
            background: #f8fbfd !important;
        }

        .dt-center {
            text-align: center;
        }

        .dataTables_wrapper .dataTables_filter {
            margin: 0 12px 12px 0;
            color: #64748b;
            font-size: 12px;
        }

        .dataTables_wrapper {
            padding: 12px;
        }

        .dataTables_wrapper .dataTables_filter input {
            height: 34px;
            min-width: 220px;
            margin-left: 8px;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            padding: 6px 10px;
        }

        .dataTables_wrapper .dataTables_info {
            padding-top: 12px;
            color: #64748b;
            font-size: 12px;
        }

        .dataTables_scroll {
            clear: both;
            border: 1px solid #dbe5ec;
            border-radius: 8px;
            overflow: hidden;
        }

        .dataTables_scrollHead {
            background: #edf3f6;
        }

        .dataTables_scrollBody {
            border-bottom: 0 !important;
        }

        .dataTables_paginate {
            float: left !important;
            padding-top: 12px !important;
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button {
            border: 1px solid #d7e2ea !important;
            border-radius: 6px !important;
            background: #fff !important;
            color: #344054 !important;
            margin: 0 3px !important;
            padding: 5px 10px !important;
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button.current {
            background: #1f6feb !important;
            border-color: #1f6feb !important;
            color: #fff !important;
        }

        div.dt-buttons {
            position: static;
            float: left;
            padding: 0 10px 12px 0;
        }

        .buttons-excel,
        .dt-button {
            border: 1px solid #c7d6e3 !important;
            border-radius: 6px !important;
            background: #fff !important;
            color: #1f2937 !important;
            box-shadow: none !important;
            font-size: 12px !important;
            font-weight: 700 !important;
            margin-right: 8px !important;
            padding: 6px 12px !important;
        }

        .buttons-excel:hover,
        .dt-button:hover {
            background: #f8fafc !important;
            color: #172033 !important;
        }

        .upr-waiting-panel .modal-dialog {
            margin-top: 22vh;
        }

        .upr-waiting-content {
            display: inline-flex;
            align-items: center;
            gap: 14px;
            padding: 18px 22px;
            border-radius: 10px;
            background: rgba(15, 23, 42, 0.86);
            color: #fff;
            font-size: 16px;
            font-weight: 700;
        }

        .upr-waiting-content img {
            width: 44px;
            height: 44px;
        }

        @media (max-width: 1199px) {
            .upr-filter-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .upr-actions {
                grid-column: span 2;
            }
        }

        @media (max-width: 767px) {
            .upr-header-row,
            .upr-panel-header {
                align-items: flex-start;
                flex-direction: column;
            }

            .upr-marketing-link {
                width: 100%;
                justify-content: center;
            }

            .upr-filter-grid {
                grid-template-columns: 1fr;
            }

            .upr-actions {
                grid-column: span 1;
                flex-direction: column;
            }

            .upr-actions .btn {
                width: 100%;
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            //uprMark_BindSummaryGrid("26-Jun-2025", "25-Jul-2025");
            //uprMark_BindProductionGrid("26-Jun-2025", "25-Jul-2025");
            //uprMark_BindAttendanceGrid("26-Jun-2025", "25-Jul-2025");
        });

        function uprMark_export() {
            var tableId = $(".tab-pane.active table").attr("id") || "table_uprSummaryMark";

            if (!$.fn.dataTable.isDataTable("#" + tableId)) {
                alert("Please load the report before exporting.");
                return false;
            }

            $("#" + tableId).DataTable().button(".buttons-excel").trigger();
            return false;
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="upr-header">
        <div class="upr-header-row">
            <div>
                <h1 class="upr-title">
                    <span class="upr-title-icon"><i class="fas fa-chart-line"></i></span>
                    User Performance Report Marketing
                </h1>
                <p class="upr-subtitle">Review marketing summary, production, and attendance performance for the selected period.</p>
            </div>
            <a class="upr-marketing-link" href="UserPerformanceReport.aspx">
                <i class="fas fa-arrow-left"></i>
                Main Report
            </a>
        </div>
    </div>

    <div class="upr-page">
        <div class="upr-shell">
            <div class="upr-panel">
                <div class="upr-panel-header">
                    <div>
                        <h3 class="upr-panel-title">Report Filters</h3>
                        <p class="upr-panel-subtitle">Choose a date range, then load or export the marketing report.</p>
                    </div>
                </div>
                <div class="upr-panel-body">
                    <div class="upr-filter-grid">
                        <div class="upr-field">
                            <label for="uprMark_fromdate">From Date</label>
                            <input type="date" id="uprMark_fromdate" name="uprMark_fromdate" class="form-control" />
                        </div>

                        <div class="upr-field">
                            <label for="uprMark_todate">To Date</label>
                            <input type="date" id="uprMark_todate" name="uprMark_todate" class="form-control" />
                        </div>

                        <div class="upr-actions">
                            <button id="uprMark_btnsubmit" type="button" name="uprMark_btnsubmit" onclick="return uprMark_submit();" class="btn btn-primary upr-primary-action">
                                <i class="fas fa-search"></i>
                                Submit
                            </button>
                            <button id="uprMark_btnexport" type="button" name="uprMark_btnexport" onclick="return uprMark_export();" class="btn upr-secondary-action">
                                <i class="fas fa-file-excel"></i>
                                Export
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="upr-panel">
                <ul class="nav nav-tabs upr-tabs" id="custom-tabs-one-tab" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">
                            <i class="fas fa-table"></i>
                            Summary
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">
                            <i class="fas fa-industry"></i>
                            Production
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" id="custom-tabs-one-attendance-tab" data-toggle="pill" href="#custom-tabs-one-attendance" role="tab" aria-controls="custom-tabs-one-attendance" aria-selected="false">
                            <i class="fas fa-user-clock"></i>
                            Attendance
                        </a>
                    </li>
                </ul>

                <div class="tab-content upr-tab-body" id="custom-tabs-one-tabContent">
                    <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                        <div class="upr-table-wrap">
                            <table class="table table-hover upr-data-table" id="table_uprSummaryMark">
                                <thead>
                                    <tr>
                                        <th>Code</th>
                                        <th>Name</th>
                                        <th>Pseudo Name</th>
                                        <th>Production Count</th>
                                        <th>Production %</th>
                                        <th>Production Grade</th>
                                        <th>Quality %</th>
                                        <th>Quality Grade</th>
                                        <th>Attendance %</th>
                                        <th>Attendance Grade</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                        <div class="upr-table-wrap">
                            <table class="table table-hover upr-data-table" id="uprMark_tableprod">
                                <thead>
                                    <tr>
                                        <th>Code</th>
                                        <th>Name</th>
                                        <th>Date</th>
                                        <th>Domain</th>
                                        <th>Criteria</th>
                                        <th>Target</th>
                                        <th>Production</th>
                                        <th>Leads</th>
                                        <th>Time Spent</th>
                                        <th>Source</th>
                                        <th>Remark</th>
                                        <th>Added Date</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="custom-tabs-one-attendance" role="tabpanel" aria-labelledby="custom-tabs-one-attendance-tab">
                        <div class="upr-table-wrap">
                            <table class="table table-hover upr-data-table" id="uprMark_attendancetable">
                                <thead>
                                    <tr>
                                        <th>Code</th>
                                        <th>Total Days<br />(Calender Days)</th>
                                        <th>Absent Days<br />(Full Days)</th>
                                        <th>Partial Days</th>
                                        <th>Partial days<br />(equivalent full days)</th>
                                        <th>Total Absents<br />(Full day + Partial Days)</th>
                                        <th>Present Days<br />(as per Final Salary Calculation)</th>
                                        <th>Attendance % on Total Days</th>
                                        <th>Latemarks</th>
                                        <th>Latemarks Removed</th>
                                        <th>Total Latemarks</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade upr-waiting-panel" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <div class="upr-waiting-content">
                <img src="../Images/Load.gif" />
                <span id="spnMarktext">System is updating details. Please wait</span>
            </div>
        </div>
    </div>
</asp:Content>
