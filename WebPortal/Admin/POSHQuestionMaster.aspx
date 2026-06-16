<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="POSHQuestionMaster.aspx.cs" Inherits="WebPortal.Admin.POSHQuestionMaster" %>

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

        .dataTables_scrollBody {
            min-height: 100px !important;
            height: auto;
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
            posh_BindGrid();
            posh_bindSection();
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>POSH Question Master</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <table class="table">
                    <tr>
                        <td><b>Question:</b></td>
                        <td colspan="3">
                            <textarea id="posh_question" name="posh_question" class="form-control" style="width: 600px;"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Section:</b></td>
                        <td>
                            <select id="posh_section" name="posh_section" class="form-control" style="width: 300px;">
                                <option value="Select">Select</option>
                            </select>
                        </td>
                        <td><b>Marks:</b></td>
                        <td>
                            <input type="number" id="posh_marks" name="posh_marks" class="form-control" style="width: 300px;" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Option 1:</b></td>
                        <td>
                            <input type="text" id="posh_option1" name="posh_option1" class="form-control" style="width: 300px; display: inline;" />
                            <input type="checkbox" class="custom-checkbox" id="posh_A_option1" />
                        </td>
                        <td><b>Option 2:</b></td>
                        <td>
                            <input type="text" id="posh_option2" name="posh_option2" class="form-control" style="width: 300px; display: inline;" />
                            <input type="checkbox" class="custom-checkbox" id="posh_A_option2" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Option 3:</b></td>
                        <td>
                            <input type="text" id="posh_option3" name="posh_option3" class="form-control" style="width: 300px; display: inline;" />
                            <input type="checkbox" class="custom-checkbox" id="posh_A_option3" />
                        </td>
                        <td><b>Option 4:</b></td>
                        <td>
                            <input type="text" id="posh_option4" name="posh_option4" class="form-control" style="width: 300px; display: inline;" />
                            <input type="checkbox" class="custom-checkbox" id="posh_A_option4" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4" style="text-align: center;">
                            <button id="posh_btnsubmit" class="btn btn-primary" onclick="return posh_Questionsubmit();">Submit</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <table class="table" id="table_posh" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Section</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Question</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align:center;">Weightage</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Option 1</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Option 2</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Option 3</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Option 4</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Answer</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added By</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added Date</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

     <div class="modal fade" id="posh_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="posh_errmsg"></h6>
                </div>
                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="posh_btnMessage" onclick="return posh_Message();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>
