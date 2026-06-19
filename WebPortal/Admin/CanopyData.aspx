<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="CanopyData.aspx.cs" Inherits="WebPortal.Admin.CanopyData" %>

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
            margin: 0px 10px;
        }

        .table.dataTable th {
            background: linear-gradient(to bottom, #007bff, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
        }

        .dataTables_scroll {
            overflow: auto;
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
            grid-template-columns: minmax(180px, 1fr) minmax(180px, 1fr) minmax(220px, 1fr);
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
            height: 38px !important;
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
        $(document).ready(function () {
            canopydata_bindyear();
        });
    </script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="modern-report-header">
        <div class="modern-report-title">
            <span class="modern-report-title-icon"><i class="bi bi-diagram-3-fill"></i></span>
            <div>
                <h1>Lauramac Database Volume</h1>
                <span>Review loan and task volume by month and year</span>
            </div>
        </div>
        <div class="modern-report-badge">
            <i class="fas fa-table"></i>
            <span>Loan and task details</span>
        </div>
    </div>
    <div class="col-lg-12 modern-report-main">
        <div class="card modern-report-card">
            <div class="card-body">
                <div class="modern-filter-panel">
                    <div class="modern-filter-grid">
                        <div class="modern-field">
                            <label for="can_fromdate">Month</label>
                            <select id="can_fromdate" name="can_fromdate" class="form-control" style="height: 40px;">
                                <option value="">Select</option>
                                <option value="January">January</option>
                                <option value="February">February</option>
                                <option value="March">March</option>
                                <option value="April">April</option>
                                <option value="May">May</option>
                                <option value="June">June</option>
                                <option value="July">July</option>
                                <option value="August">August</option>
                                <option value="September">September</option>
                                <option value="October">October</option>
                                <option value="November">November</option>
                                <option value="December">December</option>
                            </select>
                        </div>
                        <div class="modern-field">
                            <label for="can_todate">Year</label>
                            <select id="can_todate" name="can_todate" class="form-control" style="height: 40px;">
                                <option value="">Select</option>
                            </select>
                        </div>
                        <div>
                            <button id="can_btnexport" class="btn modern-btn modern-btn-primary" onclick="return getcanopyData()"><i class="fas fa-search"></i><span>Get Record</span></button>
                        </div>
                    </div>
                </div>

                <div>
                    <div class="card-header modern-tabs-wrap">
                        <ul class="nav nav-tabs modern-tabs" id="custom-tabs-one-tab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Loan Details</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">Task Details</a>
                            </li>
                        </ul>
                    </div>
                    <div class="card-body modern-table-panel">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">

                                <table class="table" id="can_table" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Sr. #</th>
                                            <th class="sort border-top" style="text-wrap: nowrap; display: none;">Task Details</th>
                                            <th class="sort border-top" style="text-wrap: nowrap; display: none;">Loan ID</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Loan #</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Created Date</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Submitted Date</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Delivered Date</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Transaction Identifier</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Script</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Buyer</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Seller</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>

                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                                <table class="table" id="candetails_table" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Sr. #</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Transaction Identifier</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Loan #</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Created Date</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Submitted Date</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Script</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Task</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Process Flow</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Assigned User</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Assigned Date</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Due Date</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Delivered Date</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Task Status</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Delivered Date</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Buyer</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Seller</th>
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
    </div>


    <div class="modal fade" id="can_details">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Task Details</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table table-responsive" id="cantaskdetails" style="width: 100%;">
                        <thead>
                            <tr>
                                <th class="sort border-top" style="text-wrap: nowrap;">Sr. #</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Loan #</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Process</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Task</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Status</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Assigned User</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Assigned Date</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Due Date</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Completed Date</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>

            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>
