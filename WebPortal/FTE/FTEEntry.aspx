<%@ Page Title="" Language="C#" MasterPageFile="~/FTE/FTE.Master" AutoEventWireup="true" CodeBehind="FTEEntry.aspx.cs" Inherits="WebPortal.FTE.FTEEntry" %>

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
            BindFteProject();
            //BindGrid_FTEEntry(203, 809);
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
                                <a class="nav-link active" id="custom-tabs-one-FTE-DataEntry-tab" data-toggle="pill" href="#custom-tabs-one-FTE-DataEntry" role="tab" aria-controls="custom-tabs-one-FTE-DataEntry" aria-selected="true"><b>FTE Data Entry</b></a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link disabled" id="custom-tabs-one-FTE-UserAttendance-tab" data-toggle="pill" href="#custom-tabs-one-FTE-UserAttendance" role="tab" aria-controls="custom-tabs-one-FTE-UserAttendance" aria-selected="false"><b>User Attendance</b></a>
                            </li>
                        </ul>
                    </div>

                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-FTE-DataEntry" role="tabpanel" aria-labelledby="custom-tabs-one-FTE-DataEntry-tab">
                                <table class="table">
                                    <tr>
                                        <td>
                                            <b>Project :</b>
                                        </td>
                                        <td>
                                            <select id="fteEntry_project" name="fteEntry_project" onchange="return getfteProcess(this);" class="form-control" style="width: 250px;">
                                                <option value="Select">Select</option>
                                            </select>
                                        </td>
                                        <td>
                                            <b>Process :</b>
                                        </td>
                                        <td>
                                            <select id="fteEntry_process" name="fteEntry_process" onchange="return bindGrid(this);" class="form-control" style="width: 250px;">
                                                <option value="">Select</option>
                                            </select>
                                        </td>
                                        <td>
                                            <b>Approved FTE Count :</b>
                                        </td>
                                        <td>
                                            <input type="number" id="fteEntry_appFTEcount" name="fteEntry_appFTEcount" class="form-control" style="width: 250px;" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><b>Date :</b></td>
                                        <td>
                                            <input type="date" id="fteEntry_Date" class="form-control" style="width: 250px;" />
                                        </td>
                                        <td><b>Actual Total FTE Count:</b></td>
                                        <td>
                                            <input type="number" id="fteEntry_ActualTotalFteCnt" class="form-control" style="width: 250px;" />
                                        </td>
                                        <td>
                                            <button id="btnFteEntrySubmit" onclick="return btnFteEntrySubmitData();" class="btn btn-primary" style="display: inline;">Submit</button>
                                            &nbsp;&nbsp;&nbsp;
                                            <button id="btnFteEntryCancel" onclick="return location.reload();" class="btn btn-default" style="display: none;">Cancel</button>
                                        </td>
                                    </tr>
                                </table>
                                <hr />
                                <table class="table table-bordered" id="table_FTEDataEntry" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top" style="text-align: center;">Action</th>
                                            <th class="sort border-top" style="text-align: center;">Sr #</th>
                                            <th class="sort border-top" style="display: none;">Project</th>
                                            <th class="sort border-top" style="display: none;">Process</th>
                                            <th class="sort border-top">Project</th>
                                            <th class="sort border-top">Process</th>
                                            <th class="sort border-top">Approved FTE Count</th>
                                            <th class="sort border-top">Date</th>
                                            <th class="sort border-top">Actual FTE Count</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>

                            <div class="tab-pane fade show fade" id="custom-tabs-one-FTE-UserAttendance" role="tabpanel" aria-labelledby="custom-tabs-one-FTE-UserAttendance-tab"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
