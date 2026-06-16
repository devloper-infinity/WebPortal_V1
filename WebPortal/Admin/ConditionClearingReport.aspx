<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ConditionClearingReport.aspx.cs" Inherits="WebPortal.Admin.ConditionClearingReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">


    <style>
        .main-container {
            width: 100%;
            padding: 15px 25px;
        }

        /* Custom Grid */
        .my-row {
            display: flex;
            flex-wrap: wrap;
            margin-bottom: 15px;
            width: 100%;
        }

        .my-col-4 {
            width: 33.33%;
            padding-right: 15px;
        }

        .my-col-2 {
            width: 10%;
            padding-left: 90px;
        }

        .my-col-12 {
            width: 100%;
        }

        .my-input:focus, .my-select:focus {
            border-color: #b5d3ff;
            box-shadow: 0 0 4px rgba(181, 211, 255, 0.6);
            outline: none;
        }
        /* Inputs */
        .my-input, .my-select {
            width: 100%;
            height: 34px;
            border: 1px solid #dcdcdc;
            padding: 6px;
            border-radius: 5px;
            font-size: 12px;
            background-color: #fff;
            transition: all 0.2s ease;
        }

        textarea.my-input {
            height: 70px;
            resize: none;
        }

        label {
            font-size: 12px;
            margin-bottom: 4px;
            display: block;
        }

        .my-btn {
            padding: 6px 18px;
            border-radius: 4px;
            border: none;
            color: #fff;
            font-size: 14px;
            margin-right: 8px;
        }

        .primary {
            background: #2f7ed8;
        }

        .success {
            background: #28a745;
        }

        .warning {
            background: #f0ad4e;
        }

        .my-btn:hover {
            opacity: 0.9;
        }

        .req {
            color: red;
            font-weight: bold;
            margin-left: 3px;
        }


        .top {
            display: flex;
            align-items: center;
        }

        .dataTables_length {
            margin-right: 10px;
        }

        .dt-buttons {
            margin-right: auto;
        }

        .dataTables_filter {
            margin-left: auto;
        }

        .card {
            transition: 0.3s ease;
        }

            .card:hover {
                transform: translateY(-3px);
            }

        .btn {
            border-radius: 10px;
            font-weight: 400;
        }

        .form-select {
            border-radius: 10px;
        }

        h5, h6 {
            letter-spacing: 0.5px;
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

        .icon-btn {
            height: 50px;
            width: 50px;
            background: linear-gradient(135deg, #85e0e0, #33cccc);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #99e6e6;
            border: 1px solid #29a3a3;
            transition: 0.3s;
            margin-left: 15px;
        }

            .icon-btn:hover {
                background: #adebeb;
                transform: translateY(-2px);
            }
            
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
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="filep_ap" style="display: none;" />
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <%--<table class="table">
                    <tr>
                        <td><b>From Date :</b></td>
                        <td>
                            <input type="date" class="form-control" id="Condition_FromDate" name="Condition_FromDate" />
                        </td>
                        <td><b>To Date :</b></td>
                        <td>
                            <input type="date" class="form-control" id="Condition_ToDate" name="Condition_ToDate" />
                        </td>
                        <td>
                            <button class="btn btn-primary" type="button" id="btnConditionShow" onclick="return btnConditionShowReport();">Show</button>
                        </td>
                    </tr>
                </table>--%>

                <div class="row align-items-end g-4">

                    <!-- From Date -->
                    <div class="col-md-4">
                        <label class="form-label"><b>From Date</b></label>
                        <div class="input-group">
                            <input type="date" id="Condition_FromDate" name="Condition_FromDate" class="form-control" style="height: 40px;">
                        </div>
                    </div>

                    <!-- To Date -->
                    <div class="col-md-4">
                        <label class="form-label"><b>To Date</b></label>
                        <div class="input-group">
                            <input type="date" class="form-control" id="Condition_ToDate" name="Condition_ToDate" style="height: 40px;">
                        </div>
                    </div>

                    <!-- Get Report -->
                    <div class="col-md-4">
                        <button type="button" class="btn btn-gradient-primary w-100" id="btnConditionShow" onclick="return btnConditionShowReport();"><i class="bi bi-bar-chart-line"></i>Get Report</button>
                        <%-- <button class="btn btn-primary" type="button" id="btnConditionShow" onclick="return btnConditionShowReport();">Show</button>--%>
                    </div>
                </div>
            </div>

            <div class="card-body">
                <table class="table" id="table_InfinityCondition" style="width: 100%;">
                    <thead>
                        <tr>

                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Deal No</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Loan Number</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Infinity Condition</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Clients Rebuttal</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Document Received Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Review Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Infinity Response</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Condition Status</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Initial Exception Grade</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Final Exception Grade</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Total Time</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Deal Manager</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Review By</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Review Date</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
