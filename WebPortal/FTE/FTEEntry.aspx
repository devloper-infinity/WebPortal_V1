<%@ Page Title="" Language="C#" MasterPageFile="~/FTE/FTE.Master" AutoEventWireup="true" CodeBehind="FTEEntry.aspx.cs" Inherits="WebPortal.FTE.FTEEntry" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .loading {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            /*  background-color: #ccc;*/
            opacity: .85;
            border-radius: 25px;
            width: 192px;
            height: 192px;
            z-index: 99999;
            text-align: center;
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

        #table_FTEDataEntry thead th {
            color: #fff !important;
        }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
        }

        .fte-entry-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            padding: 18px 22px;
            border-radius: 8px;
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8 0%, #0f9fbe 100%);
            box-shadow: 0 14px 34px rgba(15, 23, 42, .16);
        }

        .fte-entry-header h4 {
            margin: 0;
            font-weight: 800;
        }

        .fte-entry-header p {
            margin: 4px 0 0;
            color: rgba(255,255,255,.84);
            font-size: 13px;
        }

        .fte-entry-panel {
            border: 1px solid #dbe5f3;
            border-radius: 8px;
            background: #fff;
            box-shadow: 0 10px 28px rgba(15, 23, 42, .08);
        }

        .fte-entry-panel-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 14px 16px;
            border-bottom: 1px solid #e7eef8;
        }

        .fte-entry-panel-header h6 {
            margin: 0;
            color: #102a56;
            font-weight: 800;
        }

        .fte-entry-panel-body {
            padding: 16px;
        }

        .fte-entry-form {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 14px 16px;
        }

        .fte-entry-field label {
            display: block;
            margin-bottom: 6px;
            color: #263a5f;
            font-size: 13px;
            font-weight: 700 !important;
        }

        .fte-entry-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 16px;
        }

        .fte-entry-table {
            overflow-x: auto;
        }

        @media (max-width: 900px) {
            .fte-entry-form {
                grid-template-columns: 1fr;
            }

            .fte-entry-header,
            .fte-entry-panel-header,
            .fte-entry-actions {
                align-items: flex-start;
                flex-direction: column;
            }
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
        <div class="fte-entry-header">
            <div>
                <h4><i class="fas fa-keyboard"></i>&nbsp;&nbsp;FTE Data Entry</h4>
                <p>Capture daily actual FTE count against configured project and process capacity.</p>
            </div>
        </div>
    </div>

    <div class="col-lg-12">
        <div class="fte-entry-panel">
            <div class="fte-entry-panel-header">
                <h6><i class="fas fa-edit"></i>&nbsp;&nbsp;FTE Data Entry</h6>
            </div>
            <div class="fte-entry-panel-body">
                <div class="fte-entry-form">
                    <div class="fte-entry-field">
                        <label for="fteEntry_project">Project</label>
                        <select id="fteEntry_project" name="fteEntry_project" onchange="return getfteProcess(this);" class="form-control">
                            <option value="Select">Select</option>
                        </select>
                    </div>
                    <div class="fte-entry-field">
                        <label for="fteEntry_process">Process</label>
                        <select id="fteEntry_process" name="fteEntry_process" onchange="return onFteProcessChange();" class="form-control">
                            <option value="Select">Select</option>
                        </select>
                    </div>
                    <div class="fte-entry-field">
                        <label for="fteEntry_appFTEcount">Approved FTE Count</label>
                        <input type="number" id="fteEntry_appFTEcount" name="fteEntry_appFTEcount" class="form-control" readonly="readonly" />
                    </div>
                    <div class="fte-entry-field">
                        <label for="fteEntry_Date">Date</label>
                        <input type="date" id="fteEntry_Date" class="form-control" />
                    </div>
                    <div class="fte-entry-field">
                        <label for="fteEntry_ActualTotalFteCnt">Actual Total FTE Count</label>
                        <input type="number" id="fteEntry_ActualTotalFteCnt" class="form-control" />
                    </div>
                    <div class="fte-entry-field" id="fteEntry_averageFteField" style="display: none;">
                        <label for="fteEntry_AverageFTE">Average FTE</label>
                        <input type="number" id="fteEntry_AverageFTE" class="form-control" step="0.01" min="0" />
                    </div>
                </div>

                <div class="fte-entry-actions">
                    <button type="button" id="btnFteEntryCancel" onclick="return resetFteEntryForm();" class="btn btn-default" style="display: none;">Cancel</button>
                    <button type="button" id="btnFteEntrySubmit" onclick="return btnFteEntrySubmitData();" class="btn btn-primary">Submit</button>
                </div>

                <hr />
                <div class="fte-entry-table">
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
                                <th class="sort border-top">Average FTE</th>
                                <th class="sort border-top">Billed FTE</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
