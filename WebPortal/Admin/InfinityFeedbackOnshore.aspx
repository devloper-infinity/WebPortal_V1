<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="InfinityFeedbackOnshore.aspx.cs" Inherits="WebPortal.Admin.InfinityFeedbackOnshore" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .loading {
            display: none;
            position: fixed;
            top: 350px;
            left: 50%;
            margin-top: -96px;
            margin-left: -96px;
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
            box-shadow: none;
            background: linear-gradient(to right, #ffbf96, #fe7096);
            border: 0;
            font-weight: bold;
            margin: 0px 10px;
        }

        .table.dataTable th {
            background: linear-gradient(to bottom, #cbd0dd, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
        }
    </style>


    <script>

        $(document).ready(function () {

           // bind_onshoredata("01-Apr-2026", "01-Apr-2026");

        });
    </script>

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
                <table class="table">
                    <tr>
                        <td><b>From Date :</b></td>
                        <td>
                            <input type="date" class="form-control" id="infFeedback_FromDateOnShore" name="infFeedback_FromDateOnShore" />
                        </td>
                        <td><b>To Date :</b></td>
                        <td>
                            <input type="date" class="form-control" id="infFeedback_ToDateOnShore" name="infFeedback_ToDateOnShore" />
                        </td>
                        <td>
                            <button class="btn btn-primary" type="button" id="btnEditFeedbackShowOnShore" onclick="return showdata1();">Show</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <table class="table" id="table_InfinityFeedbackOnShore" style="width: 100%;">
                    <thead>
                        <%-- <tr>
                          
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Loan Number</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Client</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">UW Name</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">QC Name</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Date Reviewed</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">QC Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Category</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sub category</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Error Field</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Screen</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Error Type</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Finding</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Feedback Type</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Severity</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">RCA</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Comments</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Source</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Feedback Received Date</th>
                        </tr>--%>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
