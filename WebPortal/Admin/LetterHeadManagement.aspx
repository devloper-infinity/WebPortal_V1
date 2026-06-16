<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="LetterHeadManagement.aspx.cs" Inherits="WebPortal.Admin.LetterHeadManagement" %>

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

        /*.form-control {
            font-size: 11px !important;
        }*/
    </style>

    <script>
        $(document).ready(function () {
            Letterhead_BindCodes();
            Letterhead_BindGrid();
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Letter Head Management</b></h6>
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
                        <td><b>Employee:</b></td>
                        <td>
                            <select id="letterhead_employee" name="letterhead_employee" class="form-control" style="width: 300px;" required>
                                <option value="">Select</option>
                            </select>
                        </td>
                        <td><b>Date:</b></td>
                        <td>
                            <input type="date" id="letterhead_date" name="letterhead_date" class="form-control" style="width: 300px" required />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Reason:</b></td>
                        <td>
                            <input type="text" id="letterhead_reason" name="letterhead_reason" class="form-control" style="width: 300px;" required />
                        </td>
                        <td><b>Letterhead Count:</b></td>
                        <td>
                            <input type="number" id="letterhead_count" name="letterhead_count" class="form-control" style="width: 300px;" required />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4" align="center">
                            <button id="letterhead_btnsubmit" class="btn btn-primary" onclick="return letterhead_submit();">Submit</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <table class="table" id="letterhead_table" style="padding-top: 10px; width: 100%;"">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Employee Name</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Domain</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Reason</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Count</th>
                        </tr>
                    </thead>
                    <tbody>
                        
                    </tbody>
                </table>

            </div>
        </div>
    </div>


    <div class="modal fade" id="letterhead_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="letterhead_errmsg"></h6>
                    <%--<button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>--%>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="letterhead_btnMessage" onclick="return letterhead_Message();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>
