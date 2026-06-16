<%@ Page Title="" Language="C#" MasterPageFile="~/FTE/FTE.Master" AutoEventWireup="true" CodeBehind="FTEMaster.aspx.cs" Inherits="WebPortal.FTE.FTEMaster" %>

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
            /*background: linear-gradient(to bottom, #c5c5c5, 3%, #fff) !important;*/
            color: #000;
        }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
        }
    </style>

    <script>

        $(document).ready(function () {
            BindUsers();
            BindProject_All();
            BindGrid_UserConfig();
            BindGrid_ProjConfig();
            BindGrid_ClientHoliday();
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>FTE Master</b></h6>
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <div class="card card-tabs">
                    <div class="card-header p-0 pt-1">
                        <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="custom-tabs-one-FTE-ProjectConfig-tab" data-toggle="pill" href="#custom-tabs-one-FTE-ProjectConfig" role="tab" aria-controls="custom-tabs-one-FTE-ProjectConfig" aria-selected="true"><b>Project Configuration Report</b></a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-FTE-UserConfig-tab" data-toggle="pill" href="#custom-tabs-one-FTE-UserConfig" role="tab" aria-controls="custom-tabs-one-FTE-UserConfig" aria-selected="false"><b>User Configuration</b></a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-FTE-ClientHoliday-tab" data-toggle="pill" href="#custom-tabs-one-FTE-ClientHoliday" role="tab" aria-controls="custom-tabs-one-FTE-ClientHoliday" aria-selected="false"><b>Client Holiday Master</b></a>
                            </li>
                        </ul>
                    </div>

                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-FTE-ProjectConfig" role="tabpanel" aria-labelledby="custom-tabs-one-FTE-ProjectConfig-tab">
                                <table class="table">
                                    <tr>
                                        <td>
                                            <b>Project :</b>
                                        </td>
                                        <td>
                                            <select id="fte_project" name="fte_project" onchange="return getProcess(this);" class="form-control" style="width: 250px;">
                                                <option value="Select">Select</option>
                                            </select>
                                        </td>
                                        <td>
                                            <b>Process :</b>
                                        </td>
                                        <td>
                                            <select id="fte_process" name="fte_process" class="form-control" style="width: 250px;">
                                                <option value="">Select</option>
                                            </select>
                                        </td>
                                        <td>
                                            <b>Approved FTE Count :</b>
                                        </td>
                                        <td>
                                            <input type="text" id="fte_appFTEcount" name="fte_appFTEcount" class="form-control" style="width: 250px;" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <b>Billable Standard Hours :</b>
                                        </td>
                                        <td>
                                            <input type="text" id="fte_billableStandHpurs" name="fte_billableStandHpurs" class="form-control" style="width: 250px;" />
                                        </td>
                                        <td>
                                            <b>Billing Type :</b>
                                        </td>
                                        <td>
                                            <select id="fte_billingType" name="fte_billingType" class="form-control" style="width: 250px;">
                                                <option value="Select">Select</option>
                                                <option value="Hourly">Hourly</option>
                                                <option value="RecordBase">RecordBase</option>
                                                <option value="WeekAverage">WeekAverage</option>
                                                <option value="OtherCount">OtherCount</option>
                                            </select>
                                        </td>
                                        <td>
                                            <b>Weekend Allowed :</b>
                                        </td>
                                        <td>
                                            <select id="fte_weekendAllowed" name="fte_weekendAllowed" class="form-control" style="width: 250px;">
                                                <option value="Select">Select</option>
                                                <option value="Yes">Yes</option>
                                                <option value="No">No</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <b>US Holiday Allowed :</b>
                                        </td>
                                        <td>
                                            <select id="fte_usHolidayAllowed" name="fte_usHolidayAllowed" class="form-control" style="width: 250px;">
                                                <option value="Select">Select</option>
                                                <option value="Yes">Yes</option>
                                                <option value="No">No</option>
                                            </select>
                                        </td>
                                        <td></td>
                                        <td colspan="3">
                                            <button id="btnfteSubmit" onclick="return btnfteSubmitData();" class="btn btn-primary" style="display: inline;">Submit</button>
                                            &nbsp;&nbsp;&nbsp;
                                            <button id="btnfteCancel" onclick="return location.reload();" class="btn btn-default" style="display: none;">Cancel</button>
                                        </td>
                                    </tr>
                                </table>
                                <%-- <br />--%>
                                <table class="table table-bordered" id="table_FTEProjectConfig" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top" style="text-align: center;">Action</th>
                                            <th class="sort border-top" style="text-align: center;">Sr #</th>
                                            <th class="sort border-top" style="display: none;">Project</th>
                                            <th class="sort border-top" style="display: none;">Process</th>
                                            <th class="sort border-top">Project</th>
                                            <th class="sort border-top">Process</th>
                                            <th class="sort border-top">Approved FTE Count</th>
                                            <th class="sort border-top">Billable Standard Hours</th>
                                            <th class="sort border-top">Billing Type</th>
                                            <th class="sort border-top">Weekend Allowed</th>
                                            <th class="sort border-top">US Holiday Allowed</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>

                            <div class="tab-pane fade show fade" id="custom-tabs-one-FTE-UserConfig" role="tabpanel" aria-labelledby="custom-tabs-one-FTE-UserConfig-tab">
                                <table class="table">
                                    <tr>
                                        <td><b>Project:</b></td>
                                        <td>
                                            <select id="fte_Userproject" name="fte_Userproject" onchange="return getUserProcess(this);" class="form-control" style="width: 250px;">
                                                <option value="Select">Select</option>
                                            </select>
                                        </td>
                                        <td><b>Process:</b></td>
                                        <td>
                                            <select id="fte_Userprocess" name="fte_Userprocess" class="form-control" style="width: 250px;">
                                                <option value="">Select</option>
                                            </select>
                                        </td>
                                        <td><b>Employee:</b></td>
                                        <td>
                                            <select id="fte_UserEmployee" name="fte_UserEmployee" onchange="return getPsuedoName(this);" class="form-control" style="width: 250px;">
                                                <option value="">Select</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><b>Pseudo Name :</b></td>
                                        <td>
                                            <input type="text" id="fte_UserPsuedoName" name="fte_UserPsuedoName" class="form-control" style="width: 250px;" />
                                        </td>
                                        <td><b>Employee Status :</b></td>
                                        <td>
                                            <select id="fte_UserEmpStatus" name="fte_UserEmpStatus" class="form-control" style="width: 250px;">
                                                <option value="Select">Select</option>
                                                <option value="Live">Live</option>
                                                <option value="On Hold">On Hold</option>
                                                <option value="Extra">Extra</option>
                                            </select>
                                        </td>
                                        <td><b>Effective Date :</b></td>
                                        <td>
                                            <input type="date" id="fte_UserEffectDate" class="form-control" style="width: 250px;" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><b>Notice Period Days:</b></td>
                                        <td>
                                            <input type="number" id="fte_UserNoticePeriodDays" class="form-control" style="width: 250px;" />
                                        </td>
                                        <td></td>
                                        <td>
                                            <button id="btnfteUserSubmit" onclick="return btnfteUserSubmitData();" class="btn btn-primary" style="display: inline;">Submit</button>
                                            &nbsp;&nbsp;&nbsp;
                                            <button id="btnUserCancel" onclick="return location.reload();" class="btn btn-default" style="display: none;">Cancel</button>
                                        </td>
                                    </tr>
                                </table>

                                <table class="table table-bordered" id="table_FTE_UserConfig" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top" style="text-align: center;">Action</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Sr #</th>
                                            <%--<th class="sort border-top" style="display: none;">ConfigId</th>--%>
                                            <th class="sort border-top" style="display: none;">ProjectID</th>
                                            <th class="sort border-top" style="display: none;">ProcessID</th>
                                            <th class="sort border-top">Project</th>
                                            <th class="sort border-top">Process</th>
                                            <th class="sort border-top">Employee</th>
                                            <th class="sort border-top">Pseudo Name</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Employee Status</th>
                                            <th class="sort border-top">Effective Date</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Notice Period Days</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>

                            <div class="tab-pane fade show fade" id="custom-tabs-one-FTE-ClientHoliday" role="tabpanel" aria-labelledby="custom-tabs-one-FTE-ClientHoliday-tab">
                                <table class="table">
                                    <tr>
                                        <td>
                                            <b>Project :</b>
                                        </td>
                                        <td>
                                            <select id="fte_clientHolidayproject" name="fte_clientHolidayproject" onchange="return getProcess(this);" class="form-control" style="width: 250px;">
                                                <option value="Select">Select</option>
                                            </select>
                                        </td>
                                        <td><b>Client Holiday :</b></td>
                                        <td>
                                            <input type="date" id="fte_ClientHoliday" name="fte_ClientHoliday" class="form-control" style="width: 250px;" />
                                        </td>
                                        <td>
                                            <button id="btnClientHoliday" onclick="return btnClientHolidaySubmit();" class="btn btn-primary" style="display: inline;">Submit</button>
                                        </td>
                                    </tr>
                                </table>

                                <table class="table table-bordered" id="table_FTE_ClientHoliday" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top">Sr #</th>
                                            <th class="sort border-top">Project #</th>
                                            <th class="sort border-top">Client Holiday</th>
                                            <th class="sort border-top">Added By</th>
                                            <th class="sort border-top">AddedDate</th>
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
</asp:Content>
