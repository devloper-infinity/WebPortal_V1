<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AbscondingAndLeaveReport.aspx.cs" Inherits="WebPortal.Admin.AbscondingAndLeaveReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <%--<style>
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
    </style>--%>


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
    </style>

    <script>
        function export_Submit() {
            __doPostBack("<%= btn1.UniqueID %>", '');
            return false;
        }
        $(document).ready(function () {
            BindYear_AbscondingLeave();
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Monthly Absconding and Leaves Report</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <div class="row align-items-end g-4">
                    <div class="col-md-4">
                        <label class="form-label"><b>Month</b></label>
                        <div class="input-group">
                            <select id="ableave_month" name="ableave_month" class="form-control" style="height: 40px;">
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
                    </div>

                    <!-- Year -->
                    <div class="col-md-4">
                        <label class="form-label"><b>Year </b></label>
                        <div class="input-group">
                            <select id="ableave_year" name="ableave_year" class="form-control" style="height: 40px;">
                                <option value="">Select</option>
                            </select>
                        </div>
                    </div>

                    <!-- Get Report -->
                    <div class="col-md-2">
                        <button id="ableave_btnShow" type="button" class="btn btn-gradient-primary w-100" onclick="return ableave_Submit()">Get Record</button>
                    </div>
                    <div class="col-md-2">
                        <button class="btn btn-secondary buttons-excel buttons-html5 btn-success" id="ableave_btnExport" onclick="return export_Submit();" type="button"><span>Export to Excel</span></button>
                    </div>
                </div>
                <br />

                <hr />
                <div class="card card-tabs">
                    <div class="card-header p-0 pt-1">
                        <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Absconding</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">Leaves</a>
                            </li>

                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                                <table class="table" id="abscondleavelist" style="padding-top: 10px; width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Employee Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Joining Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Domain</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Subdomain</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Reporting Manager</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Domain Head</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Tenure</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Current Status</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Resignation Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Last Working Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">PM/ System Remark</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Absconded On</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; display: none;">Latest Login Date</th>

                                        </tr>

                                    </thead>
                                    <tbody></tbody>

                                </table>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                                <div style="width: 100%; overflow: auto;">
                                    <table class="table" id="totalleavelist" style="padding-top: 10px; width: 100%;">
                                        <thead>
                                            <tr>
                                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Employee Name</th>
                                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Joining Date</th>
                                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Domain</th>
                                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Subdomain</th>
                                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Reporting Manager</th>
                                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Domain Head</th>
                                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">For Days</th>
                                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Leave From</th>
                                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Leave To</th>
                                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Reason For Leave</th>
                                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Applied By</th>
                                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Applied Date</th>
                                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Leave Status</th>
                                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Approved By</th>
                                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Approved Remark</th>
                                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Approved Date</th>
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
    </div>
    <asp:Button ID="btn1" runat="server" Style="display: none;" OnClick="btn1_Click" />
</asp:Content>
