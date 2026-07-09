<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AllResignedEmployees.aspx.cs" Inherits="WebPortal.Admin.AllResignedEmployees" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .loading {
            display: none;
            position: fixed;
            inset: 0;
            width: 100%;
            height: 100%;
            background: rgba(255,255,255,.72);
            z-index: 99999;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            backdrop-filter: blur(3px);
        }

        .loading img {
            width: 76px;
            height: 76px;
        }

        .loading div {
            margin-top: 10px;
            font-size: 13px;
            font-weight: 700;
            color: #1f2937;
        }

        .are-hero {
            position: relative;
            overflow: hidden;
            border-radius: 20px;
            padding: 22px 24px;
            margin-bottom: 18px;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 62%, #22c1dc 100%);
            color: #fff;
            box-shadow: 0 18px 36px rgba(37, 99, 235, .22);
        }

        .are-hero:before,
        .are-hero:after {
            content: "";
            position: absolute;
            border-radius: 999px;
            background: rgba(255,255,255,.16);
        }

        .are-hero:before {
            width: 220px;
            height: 220px;
            top: -115px;
            right: -35px;
        }

        .are-hero:after {
            width: 140px;
            height: 140px;
            bottom: -70px;
            left: 38%;
        }

        .are-hero-content {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            flex-wrap: wrap;
        }

        .are-title-wrap {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .are-title-icon {
            width: 58px;
            height: 58px;
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.18);
            border: 1px solid rgba(255,255,255,.24);
            box-shadow: inset 0 1px 0 rgba(255,255,255,.25);
            font-size: 25px;
        }

        .are-hero h4 {
            margin: 0;
            font-size: 22px;
            line-height: 1.25;
            font-weight: 800;
            letter-spacing: .2px;
        }

        .are-hero p {
            margin: 5px 0 0;
            color: rgba(255,255,255,.88);
            font-size: 13px;
        }

        .are-chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 14px;
            border-radius: 999px;
            background: rgba(255,255,255,.16);
            border: 1px solid rgba(255,255,255,.24);
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
        }

        .are-card {
            border: 0;
            border-radius: 18px;
            background: #fff;
            box-shadow: 0 12px 32px rgba(15, 23, 42, .08);
            overflow: hidden;
            margin-bottom: 18px;
        }

        .are-card-header {
            padding: 16px 18px;
            border-bottom: 1px solid #edf2f7;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            flex-wrap: wrap;
            background: linear-gradient(180deg, #ffffff 0%, #f8fbff 100%);
        }

        .are-card-title {
            margin: 0;
            font-size: 15px;
            font-weight: 800;
            color: #111827;
            display: flex;
            align-items: center;
            gap: 9px;
        }

        .are-card-title i {
            color: #2563eb;
        }

        .are-card-body {
            padding: 18px;
        }

        .are-filter-grid {
            display: grid;
            grid-template-columns: repeat(12, 1fr);
            gap: 14px;
            align-items: end;
        }

        .are-field {
            grid-column: span 3;
        }

        .are-field label {
            display: block;
            margin-bottom: 7px;
            font-size: 12px;
            font-weight: 800 !important;
            color: #374151;
            border: 0 !important;
        }

        .are-field .form-control {
            min-height: 42px;
            border-radius: 12px;
            border: 1px solid #dbe3ef;
            color: #111827;
            font-size: 13px;
            box-shadow: none;
            transition: all .2s ease;
        }

        .are-field .form-control:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, .10);
        }

        .are-actions {
            grid-column: span 6;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            flex-wrap: wrap;
        }

        .are-btn {
            min-height: 42px;
            border-radius: 12px;
            padding: 10px 18px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            font-size: 13px;
            font-weight: 800;
            border: 0;
            transition: all .22s ease;
            white-space: nowrap;
        }

        .are-btn-primary {
            color: #fff !important;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 55%, #22c1dc 100%);
            box-shadow: 0 10px 20px rgba(37, 99, 235, .18);
        }

        .are-btn-secondary {
            color: #1f2937 !important;
            background: #fff;
            border: 1px solid #dbe3ef;
            box-shadow: 0 8px 18px rgba(15, 23, 42, .06);
        }

        .are-btn:hover {
            transform: translateY(-2px);
            text-decoration: none;
        }

        .are-tabs-card {
            border: 0;
            border-radius: 18px;
            box-shadow: 0 12px 32px rgba(15, 23, 42, .08);
            overflow: hidden;
        }

        .are-tabs-header {
            padding: 12px 14px 0;
            background: #f8fbff;
            border-bottom: 1px solid #edf2f7;
        }

        .are-tabs-header .nav-tabs {
            border: 0;
            gap: 8px;
        }

        .are-tabs-header .nav-link {
            border: 0 !important;
            border-radius: 14px 14px 0 0;
            color: #475569;
            font-weight: 800;
            padding: 12px 18px;
            background: #eef4ff;
        }

        .are-tabs-header .nav-link.active {
            color: #fff !important;
            background: linear-gradient(120deg, #1d4ed8, #22c1dc) !important;
            box-shadow: 0 10px 18px rgba(37, 99, 235, .18);
        }

        .are-tab-body {
            padding: 18px;
            background: #fff;
        }

        .are-table-wrap {
            width: 100%;
            overflow-x: auto;
            border: 1px solid #edf2f7;
            border-radius: 16px;
            background: #fff;
        }

        .table.dataTable,
        table.table {
            margin-bottom: 0 !important;
            width: 100% !important;
        }

        .table.dataTable th,
        table.table thead th {
            background: #edf3f6 !important;
            color: #111827 !important;
            font-size: 12px;
            font-weight: 800;
            height: 42px;
            vertical-align: middle;
            border-bottom: 1px solid #dbe3ef !important;
            white-space: nowrap;
        }

        .table.dataTable tr td,
        table.table tbody td {
            background: #fff !important;
            font-size: 12px;
            vertical-align: middle;
            white-space: nowrap;
        }

        .table.dataTable tbody tr:hover td,
        table.table tbody tr:hover td {
            background: #f8fbff !important;
        }

        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dataTables_info {
            float: left !important;
            font-size: 12px;
            color: #475569;
        }

        div.dt-buttons {
            position: static;
            padding-left: 12px;
            float: left;
        }

        .buttons-excel,
        .buttons-html5 {
            color: #fff !important;
            box-shadow: none;
            background: linear-gradient(120deg, #1d4ed8, #22c1dc) !important;
            border: 0 !important;
            font-weight: 800;
            border-radius: 10px !important;
            margin: 0 8px;
            padding: 7px 14px !important;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: normal !important;
            border: none !important;
        }

        @media (max-width: 991px) {
            .are-field {
                grid-column: span 6;
            }
            .are-actions {
                grid-column: span 12;
                justify-content: flex-start;
            }
        }

        @media (max-width: 575px) {
            .are-page {
                padding: 10px;
            }
            .are-hero {
                padding: 18px;
                border-radius: 16px;
            }
            .are-title-wrap {
                align-items: flex-start;
            }
            .are-title-icon {
                width: 48px;
                height: 48px;
                border-radius: 14px;
                font-size: 21px;
            }
            .are-hero h4 {
                font-size: 18px;
            }
            .are-field,
            .are-actions {
                grid-column: span 12;
            }
            .are-actions .are-btn {
                width: 100%;
            }
            .are-tabs-header .nav-link {
                padding: 10px 12px;
                font-size: 12px;
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            allresigned_BindYear();
        });

        function allresigned_Exporttoexcel() {
            __doPostBack("<%= btn31.UniqueID %>", '');
            return false;
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Button ID="btn31" runat="server" Style="display: none;" OnClick="btn31_Click" />

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div>One moment, please . . . .</div>
    </div>

    <div class="are-page">
        <div class="are-hero">
            <div class="are-hero-content">
                <div class="are-title-wrap">
                    <div class="are-title-icon">
                        <i class="fas fa-user-minus"></i>
                    </div>
                    <div>
                        <h4>All Resigned Employees</h4>
                        <p>View resigned employee summary and detailed resignation information by selected date range.</p>
                    </div>
                </div>
                <div class="are-chip">
                    <i class="fas fa-chart-line"></i>
                    Resignation Report
                </div>
            </div>
        </div>

        <div class="are-card">
            <div class="are-card-header">
                <h5 class="are-card-title"><i class="fas fa-filter"></i> Search Filters</h5>
            </div>
            <div class="are-card-body">
                <div class="are-filter-grid">
                    <div class="are-field">
                        <label for="allresigned_from">From Date</label>
                        <input type="date" id="allresigned_from" name="allresigned_from" class="form-control" />
                        <select id="allresigned_month" name="allresigned_month" class="form-control" style="display: none;">
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

                    <div class="are-field">
                        <label for="allresigned_to">To Date</label>
                        <input type="date" id="allresigned_to" name="allresigned_to" class="form-control" />
                        <select id="allresigned_year" name="allresigned_year" class="form-control" style="display: none;">
                            <option value="">Select</option>
                        </select>
                    </div>

                    <div class="are-actions">
                        <button type="button" id="allresigned_btnShow" class="are-btn are-btn-primary" onclick="return allresigned_Submit();">
                            <i class="fas fa-search"></i><span>Show</span>
                        </button>
                        <button type="button" id="allresigned_btnExporttoexcel" class="are-btn are-btn-secondary" onclick="return allresigned_Exporttoexcel();">
                            <i class="fas fa-file-excel"></i><span>Export to Excel</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <div class="are-tabs-card">
            <div class="are-tabs-header">
                <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home-summary" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">
                            <i class="fas fa-chart-pie"></i> Summary
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile-detail" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">
                            <i class="fas fa-list"></i> Details
                        </a>
                    </li>
                </ul>
            </div>

            <div class="are-tab-body">
                <div class="tab-content" id="custom-tabs-one-tabContent">
                    <div class="tab-pane fade show active" id="custom-tabs-one-home-summary" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                        <div class="are-table-wrap">
                            <table class="table" id="table_resignedSummary" style="width: 100%;"></table>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="custom-tabs-one-profile-detail" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                        <div class="are-table-wrap">
                            <table class="table" id="allresigned_table" style="width: 100%;">
                                <thead>
                                    <tr>
                                        <th class="sort border-top ps-3">Sr. #</th>
                                        <th class="sort border-top ps-3">Code</th>
                                        <th class="sort border-top ps-3">Employee Name</th>
                                        <th class="sort border-top ps-3">Joining Date</th>
                                        <th class="sort border-top ps-3">Birth Date</th>
                                        <th class="sort border-top ps-3">Branch</th>
                                        <th class="sort border-top ps-3">Department</th>
                                        <th class="sort border-top ps-3">Designation</th>
                                        <th class="sort border-top ps-3">Domain</th>
                                        <th class="sort border-top ps-3">Subdomain</th>
                                        <th class="sort border-top ps-3">Reporting Manager</th>
                                        <th class="sort border-top ps-3">Domain Head</th>
                                        <th class="sort border-top ps-3">Latest Login Date</th>
                                        <th class="sort border-top ps-3">Resignation Type</th>
                                        <th class="sort border-top ps-3">Resignation Date</th>
                                        <th class="sort border-top ps-3">Last Working Date</th>
                                        <th class="sort border-top ps-3">Step 1 Remark</th>
                                        <th class="sort border-top ps-3">Step 2 Remark</th>
                                        <th class="sort border-top ps-3">Step 3 Remark</th>
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
</asp:Content>

<%--<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
        /*.form-control {
            font-size: 11px !important;
        }*/
    </style>

    <script>
        $(document).ready(function () {
            allresigned_BindYear();
        });

        function allresigned_Exporttoexcel() {
            __doPostBack("<%= btn31.UniqueID %>", '');
            return false;
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Button ID="btn31" runat="server" Style="display: none;" OnClick="btn31_Click" />
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>All Resigned Employees</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <h5 class="card-title"></h5>
                <table class="table">
                    <tr>
                        <td style="width: 50px;"><b>From Date:</b></td>
                        <td style="width: 150px;">
                            <input type="date" id="allresigned_from" name="allresigned_from" class="form-control" />
                            <select id="allresigned_month" name="allresigned_month" class="form-control" style="display: none;">
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
                        </td>
                        <td style="width: 50px;">
                            <b>To Date:</b>
                        </td>
                        <td style="width: 150px;">
                            <input type="date" id="allresigned_to" name="allresigned_to" class="form-control" />
                            <select id="allresigned_year" name="allresigned_year" class="form-control" style="display: none;">
                                <option value="">Select</option>
                            </select>
                        </td>
                        <td style="width: 100px;">
                            <button id="allresigned_btnShow" class="btn btn-primary" onclick="return allresigned_Submit()">Show</button>
                            <button id="allresigned_btnExporttoexcel" class="btn btn-secondary" onclick="return allresigned_Exporttoexcel();">Export to excel</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <div class="card card-tabs">
                    <div class="card-header p-0 pt-1">
                        <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home-summary" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Summary</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile-detail" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">Details</a>
                            </li>
                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-home-summary" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                                <table class="table" id="table_resignedSummary" style="width: 100%;"></table>
                                <div class="col-lg-12">
                                    <div class="row">

                                        <%--  <div class="col-lg-12">
                                            <h5 class="card-title">Month wise Summary</h5>
                                            <table class="table" id="attrition_monthsummary" style="padding-top: 10px; width: 100%;">
                                                <thead>
                                                    <tr>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Month</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Year</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Opening Count</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">New Joiners</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Exit Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Remaining Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Excluded Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attrition %</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attrition Cost</th>
                                                    </tr>
                                                </thead>
                                                <tbody></tbody>
                                            </table>
                                            <hr />
                                        </div>
                                        <div class="col-lg-12">
                                            <h5 class="card-title">Location wise Summary</h5>
                                            <table class="table" id="attrition_locationsummary" style="padding-top: 10px; width: 100%;">
                                                <thead>
                                                    <tr>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Opening Count</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">New Joiners</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Exit Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Remaining Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Excluded Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attrition %</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attrition Cost</th>
                                                    </tr>
                                                </thead>
                                                <tbody></tbody>
                                            </table>
                                            <hr />
                                        </div>
                                        <div class="col-lg-12">
                                            <h5 class="card-title">Domain wise Summary</h5>
                                            <table class="table" id="attrition_domainsummary" style="padding-top: 10px; width: 100%;">
                                                <thead>
                                                    <tr>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Domain</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Opening Count</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">New Joiners</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Exit Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Remaining Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Excluded Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attrition %</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attrition Cost</th>
                                                    </tr>
                                                </thead>
                                                <tbody></tbody>
                                            </table>
                                            <hr />
                                        </div>
                                        <div class="col-lg-12">
                                            <h5 class="card-title">Domain Head wise Summary</h5>
                                            <table class="table" id="attrition_domainheadsummary" style="padding-top: 10px; width: 100%;">
                                                <thead>
                                                    <tr>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Domain Head</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Opening Count</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">New Joiners</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Exit Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Remaining Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Excluded Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attrition %</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attrition Cost</th>
                                                    </tr>
                                                </thead>
                                                <tbody></tbody>
                                            </table>
                                            <hr />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="tab-pane fade" id="custom-tabs-one-profile-detail" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                                <table class="table" id="allresigned_table" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Employee Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Joining Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Birth Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Department</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Designation</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Domain</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Subdomain</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Reporting Manager</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Domain Head</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Latest Login Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Resignation Type</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Resignation Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Last Working Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Step 1 Remark</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Step 2 Remark</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Step 3 Remark</th>
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
</asp:Content>--%>
