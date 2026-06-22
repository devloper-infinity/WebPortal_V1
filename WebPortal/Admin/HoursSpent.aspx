<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="HoursSpent.aspx.cs" Inherits="WebPortal.Admin.HoursSpent" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .loading {
            display: none;
            position: fixed;
            top: 350px;
            left: 50%;
            margin-top: -96px;
            margin-left: -96px;
            /*  background-color: #ccc;*/
            opacity: .85;
            border-radius: 25px;
            width: 192px;
            height: 192px;
            z-index: 99999;
        }

        .dataTables_length, .dataTables_info {
            float: left !important;
        }

        .dataTables_scrollHeadInner {
            width: 100% !important;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: normal !important;
            border: none !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 50px;
            float: left;
        }

        .buttons-excel, .buttons-html5 {
            color: #fff;
            /*     background-color: #28a745;
            border-color: #28a745;*/
            box-shadow: none;
            background: linear-gradient(to right, #ffbf96, #fe7096);
            border: 0;
            font-weight: bold;
            /*   margin: 0px 10px;*/
            border-radius: 12px;
            height: 40px;
            width: 95%;
            font-weight: 400;
            transition: 0.3s;
        }

        .table {
            width: 100% !important;
        }

        .dataTable {
            width: 100% !important;
        }

        .no-footer {
            width: 100% !important;
        }

        .table.dataTable th {
            background: linear-gradient(to bottom, #007bff, 3%, #fff) !important;
            color: #000;
            text-align: left;
        }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
        }

        .dataTables_scrollBody {
            min-height: 20px !important;
            height: auto !important;
        }

        .tab-pane {
            height: auto !important;
        }

        .dataTables_wrapper {
            margin-top: 0 !important;
        }

        .btn-gradient-primary {
            background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;
            color: #fff;
            border-radius: 12px;
            height: 40px;
            font-weight: 400;
            transition: 0.3s;
        }

            .btn-gradient-primary:hover {
                transform: translateY(-2px);
                /*background: linear-gradient(135deg, #4da6ff, #1a8cff);*/
                background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;
                color: #fff;
            }

        .modern-report-header {
            align-items: center;
            background: #fff;
            border: 1px solid #e4e9f2;
            border-left: 4px solid #2563eb;
            border-radius: 8px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, .06);
            display: flex;
            flex-wrap: wrap;
            gap: 14px;
            justify-content: space-between;
            margin: 12px 15px 16px;
            padding: 16px 18px;
        }

        .modern-report-title {
            align-items: center;
            display: flex;
            gap: 12px;
        }

        .modern-report-title-icon {
            align-items: center;
            background: #edf4ff;
            border-radius: 8px;
            color: #1d4ed8;
            display: inline-flex;
            font-size: 18px;
            height: 40px;
            justify-content: center;
            width: 40px;
        }

        .modern-report-title h1 {
            color: #172033;
            font-size: 20px;
            font-weight: 700;
            line-height: 1.2;
            margin: 0;
        }

        .modern-report-title span {
            color: #667085;
            display: block;
            font-size: 12px;
            margin-top: 2px;
        }

        .modern-report-badge {
            align-items: center;
            background: #f8fafc;
            border: 1px solid #e4e9f2;
            border-radius: 6px;
            color: #344054;
            display: inline-flex;
            font-size: 12px;
            font-weight: 600;
            gap: 8px;
            padding: 8px 10px;
        }

        .modern-report-main {
            padding: 0 15px 24px;
        }

        .modern-report-card {
            border: 1px solid #e4e9f2;
            border-radius: 8px;
            box-shadow: 0 10px 28px rgba(15, 23, 42, .06);
            overflow: hidden;
        }

        .modern-report-card > .card-body {
            padding: 0;
        }

        .modern-filter-panel {
            background: #fff;
            border-bottom: 1px solid #e4e9f2;
            padding: 16px;
        }

        .modern-filter-grid {
            align-items: flex-end;
            display: grid;
            gap: 14px;
            grid-template-columns: minmax(180px, 1fr) minmax(180px, 1fr) minmax(160px, .6fr) minmax(180px, .7fr);
        }

        .modern-field label {
            border: none !important;
            color: #475467;
            display: block;
            font-size: 12px;
            font-weight: 700 !important;
            margin-bottom: 6px;
        }

        .modern-field .form-control {
            border-color: #d0d7e2;
            border-radius: 6px;
            box-shadow: none;
            height: 38px;
        }

        .modern-field .form-control:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 .15rem rgba(37, 99, 235, .12);
        }

        .modern-btn {
            align-items: center;
            border-radius: 6px;
            display: inline-flex;
            font-weight: 600;
            gap: 8px;
            justify-content: center;
            min-height: 38px;
            padding: 8px 14px;
            white-space: nowrap;
            width: 100%;
        }

        .modern-btn-primary {
            background: #2563eb;
            border-color: #2563eb;
            color: #fff;
        }

        .modern-btn-primary:hover,
        .modern-btn-primary:focus {
            background: #1d4ed8;
            border-color: #1d4ed8;
            color: #fff;
        }

        .modern-btn-secondary {
            background: #111827 !important;
            border-color: #111827 !important;
            color: #fff !important;
        }

        .modern-btn-secondary:hover,
        .modern-btn-secondary:focus {
            background: #0f172a !important;
            border-color: #0f172a !important;
            color: #fff !important;
        }

        .modern-tabs-wrap {
            background: #f8fafc;
            border-bottom: 1px solid #e4e9f2;
            padding: 10px 12px 0;
        }

        .modern-tabs {
            border-bottom: 0;
            display: flex;
            flex-wrap: nowrap;
            gap: 6px;
            overflow-x: auto;
            overflow-y: hidden;
            padding-bottom: 10px;
        }

        .modern-tabs .nav-item {
            flex: 0 0 auto;
        }

        .modern-tabs .nav-link {
            background: #fff;
            border: 1px solid #d8e0ec !important;
            border-radius: 6px !important;
            color: #42526e;
            font-size: 12px;
            font-weight: 600;
            padding: 8px 12px;
            white-space: nowrap;
        }

        .modern-tabs .nav-link.active {
            background: #2563eb !important;
            border-color: #2563eb !important;
            box-shadow: 0 8px 16px rgba(37, 99, 235, .18);
            color: #fff !important;
        }

        .modern-table-panel {
            background: #fff;
            padding: 16px;
        }

        .modern-table-panel .tab-pane {
            min-height: 260px;
            overflow-x: auto;
        }

        .loading {
            background: #fff;
            border: 1px solid #e4e9f2;
            border-radius: 8px;
            box-shadow: 0 18px 40px rgba(15, 23, 42, .16);
            display: none;
            height: auto;
            left: 50%;
            margin: 0;
            min-height: 154px;
            opacity: .96;
            padding: 20px;
            position: fixed;
            text-align: center;
            top: 50%;
            transform: translate(-50%, -50%);
            width: 180px;
            z-index: 99999;
        }

        .loading img {
            max-width: 72px;
        }

        .loading div {
            color: #334155;
            font-size: 12px;
            font-weight: 700;
            margin-top: 12px;
        }

        .table.dataTable th {
            background: #f3f6fb !important;
            border-bottom: 1px solid #d8e0ec !important;
            color: #172033;
            font-weight: 700;
        }

        .table.dataTable tr td {
            background-color: #fff !important;
            color: #344054;
        }

        .table.dataTable tbody tr:hover td {
            background-color: #f8fbff !important;
        }

        .report-waiting-text {
            color: #fff;
            display: inline-block;
            font-size: 22px;
            font-style: normal;
            font-weight: 700;
            margin-top: 10px;
        }

        .report-waiting-dots {
            animation: animate 1s linear infinite;
            color: #fff;
            display: inline-block;
            font-size: 42px;
            font-style: normal;
            font-weight: 700;
        }

        @media (max-width: 991px) {
            .modern-filter-grid {
                grid-template-columns: 1fr 1fr;
            }
        }

        @media (max-width: 767px) {
            .modern-report-header {
                margin-left: 8px;
                margin-right: 8px;
            }

            .modern-report-main {
                padding-left: 8px;
                padding-right: 8px;
            }

            .modern-filter-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
    <link rel="stylesheet" href="ModernReportSecuritization.css" />

    <script>
        //$(document).ready(function () {
        //    bindProjectWiseData("26-Nov-2025", "12-Dec-2025");
        //});

        $(document).ready(function () {

           // bindProjectWiseData("26-Nov-2025", "12-Dec-2025");

            //$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {

            //    var activeTab = $(e.target).attr('href');

            //    // Destroy tables in NON-active tabs only
            //    if (activeTab !== '#custom-tabs-one-home-tab') {
            //        destroyTable('#hoursSpent_project');
            //    }
            //    if (activeTab !== '#custom-tabs-two-tab') {
            //        destroyTable('#hoursSpenttable_prjprc');
            //    }
            //    if (activeTab !== '#custom-tabs-three-tab') {
            //        destroyTable('#hoursSpenttable_prjprcuser');
            //    }
            //    if (activeTab !== '#custom-tabs-four-tab') {
            //        destroyTable('#hoursSpenttable_proddata');
            //    }
            //});
        });

        //function destroyTable(tableId) {
        //    if ($.fn.DataTable.isDataTable(tableId)) {
        //        $(tableId).DataTable().clear().destroy();
        //        $(tableId + ' tbody').empty();
        //    }
        //}

        function hoursSpent_Exporttoexcel() {
            __doPostBack("<%= btnHoursSpent.UniqueID %>", '');
            return false;
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Button ID="btnHoursSpent" runat="server" Style="display: none;" OnClick="btnHoursSpent_Click" />
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="modern-report-header">
        <div class="modern-report-title">
            <span class="modern-report-title-icon"><i class="bi bi-diagram-3-fill"></i></span>
            <div>
                <h1>Hours Spent</h1>
                <span>Track project, process, user, and production time views</span>
            </div>
        </div>
        <div class="modern-report-badge">
            <i class="fas fa-layer-group"></i>
            <span>4 report views</span>
        </div>
    </div>

    <div class="col-lg-12 modern-report-main">
        <div class="card modern-report-card">
            <div class="card-body">
                <div class="modern-filter-panel">
                    <div class="modern-filter-grid">
                        <div class="modern-field">
                            <label for="hoursSpent_from">From Date</label>
                            <input type="date" id="hoursSpent_from" name="hoursSpent_from" class="form-control" />
                        </div>
                        <div class="modern-field">
                            <label for="hoursSpent_to">To Date</label>
                            <input type="date" id="hoursSpent_to" name="hoursSpent_to" class="form-control" />
                        </div>
                        <div>
                            <button id="ackMonthly_btnShow" type="button" class="btn modern-btn modern-btn-primary" onclick="return hoursSpent_show()"><i class="fas fa-search"></i><span>Get Record</span></button>
                        </div>
                        <div>
                            <button class="btn modern-btn modern-btn-secondary buttons-excel buttons-html5 btn-success" id="hoursSpent_btnExporttoexcel" onclick="return hoursSpent_Exporttoexcel();" type="button"><i class="fas fa-file-excel"></i><span>Export to Excel</span></button>
                        </div>
                    </div>
                </div>
                <div class="card card-tabs mb-0 border-0 shadow-none">
                    <div class="card-header modern-tabs-wrap">
                        <ul class="nav nav-tabs modern-tabs" id="custom-tabs-one-tab" role="tablist" style="font-weight: bold;">
                            <li class="nav-item">
                                <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-project" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Project</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-two-tab" onclick="return bindprjprc();" data-toggle="pill" href="#custom-tabs-two-prjprc" role="tab" aria-controls="custom-tabs-ctrl-two-prjprc" aria-selected="false">Project + Process</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-three-tab" onclick="return binduserwise();" data-toggle="pill" href="#custom-tabs-three-prjprcuser" role="tab" aria-controls="custom-tabs-ctrl-three-prjprcuser" aria-selected="false">Project + User +Process</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-four-tab" onclick="return bindprodData();" data-toggle="pill" href="#custom-tabs-four-proddata" role="tab" aria-controls="custom-tabs-ctrl-four-proddata" aria-selected="false">Production Data</a>
                            </li>
                        </ul>
                    </div>
                    <div class="card-body modern-table-panel">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-project" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                                <table class="table" id="hoursSpent_project" style="padding-top: 10px; width: 100%!important;"></table>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-two-prjprc" role="tabpanel" aria-labelledby="custom-tabs-two-prjprc-tab">
                                <table class="table" id="hoursSpenttable_prjprc" style="padding-top: 10px; width: 100%!important;">
                                    <thead style="text-align: left;"></thead>
                                </table>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-three-prjprcuser" role="tabpanel" aria-labelledby="custom-tabs-three-prjprcuser-tab">
                                <table class="table" id="hoursSpenttable_prjprcuser" style="padding-top: 10px; width: 100%!important;">
                                    <thead style="text-align: left;"></thead>
                                </table>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-four-proddata" role="tabpanel" aria-labelledby="custom-tabs-four-proddata-tab">
                                <table class="table" id="hoursSpenttable_proddata" style="padding-top: 10px; width: 100%!important;"></table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="Prodwaitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span class="report-waiting-text" id="spntext">System is updating details. Please wait</span>
            <span class="report-waiting-dots">&nbsp;. . . .</span>
        </div>
    </div>
</asp:Content>
