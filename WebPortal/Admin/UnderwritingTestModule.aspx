<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="UnderwritingTestModule.aspx.cs" Inherits="WebPortal.Admin.UnderwritingTestModule" %>

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
            cruw_BindGrid();
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input type="text" id="emailappidser" name="emailappidser" style="display: none;" />
    <input type="text" id="emailappid" name="emailappid" style="display: none;" />
    <%--<asp:UpdatePanel ID="up1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>--%>
    <asp:Button ID="Button1" runat="server" OnClick="btnMail_Click" Style="display: none;" />
    <asp:Button ID="btnMailSer" runat="server" OnClick="btnMailSer_Click" Style="display: none;" />
    <%--</ContentTemplate>
    </asp:UpdatePanel>--%>
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Underwriting Test</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <div class="card card-tabs">
                    <div class="card-header p-0 pt-1">
                        <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Credit</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-profile-tab" onclick="return getServicingDetails();" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">Servicing</a>
                            </li>
                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                                <div class="card card-tabs">
                                    <div class="card-header p-0 pt-1">
                                        <ul class="nav nav-tabs" id="custom-tabs-one-tab-sub" role="tablist">
                                            <li class="nav-item">
                                                <a class="nav-link active" id="custom-tabs-one-home-tab-sub" data-toggle="pill" href="#custom-tabs-one-home-sub" role="tab" aria-controls="custom-tabs-one-home-sub" aria-selected="true">Question Set</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" id="custom-tabs-one-profile-tab-sub" data-toggle="pill" href="#custom-tabs-one-profile-sub" role="tab" aria-controls="custom-tabs-one-profile-sub" aria-selected="false">Check Question Paper</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" id="custom-tabs-one-messages-tab-sub" data-toggle="pill" href="#custom-tabs-one-messages-sub" role="tab" aria-controls="custom-tabs-one-messages-sub" aria-selected="false">Send Test Link</a>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="card-body">
                                        <div class="tab-content" id="custom-tabs-one-tabContent-sub">
                                            <div class="tab-pane fade show active" id="custom-tabs-one-home-sub" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab-sub">
                                                <%--Credit Question Set--%>
                                                <table class="table">
                                                    <tr>
                                                        <td><b>Question:</b></td>
                                                        <td colspan="3">
                                                            <textarea id="cruw_question" name="cruw_question" class="form-control" style="width: 600px;"></textarea>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><b>Question Type:</b></td>
                                                        <td>
                                                            <select id="cruw_questiontype" name="cruw_questiontype" class="form-control" style="width: 300px;">
                                                                <option value="">Select</option>
                                                                <option value="Credit">Credit</option>
                                                                <option value="Compliance">Compliance</option>
                                                                <option value="Collateral">Collateral</option>
                                                            </select>
                                                        </td>
                                                        <td><b>Marks:</b></td>
                                                        <td>
                                                            <input type="number" id="cruw_marks" name="cruw_marks" class="form-control" style="width: 300px;" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><b>Option 1:</b></td>
                                                        <td>
                                                            <input type="text" id="cruw_option1" name="cruw_option1" class="form-control" style="width: 300px; display: inline;" />
                                                            <input type="checkbox" class="custom-checkbox" id="cruw_A_option1" />
                                                        </td>
                                                        <td><b>Option 2:</b></td>
                                                        <td>
                                                            <input type="text" id="cruw_option2" name="cruw_option2" class="form-control" style="width: 300px; display: inline;" />
                                                            <input type="checkbox" class="custom-checkbox" id="cruw_A_option2" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><b>Option 3:</b></td>
                                                        <td>
                                                            <input type="text" id="cruw_option3" name="cruw_option3" class="form-control" style="width: 300px; display: inline;" />
                                                            <input type="checkbox" class="custom-checkbox" id="cruw_A_option3" />
                                                        </td>
                                                        <td><b>Option 4:</b></td>
                                                        <td>
                                                            <input type="text" id="cruw_option4" name="cruw_option4" class="form-control" style="width: 300px; display: inline;" />
                                                            <input type="checkbox" class="custom-checkbox" id="cruw_A_option4" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="4" style="text-align: center;">
                                                            <button id="cruw_btnsubmit" class="btn btn-primary" onclick="return cruw_submit();">Submit</button>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <hr />
                                                <table class="table" id="cruw_table" style="width: 100%;">
                                                    <thead>
                                                        <tr>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Question</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Question Type</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Marks</th>
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
                                            <div class="tab-pane fade" id="custom-tabs-one-profile-sub" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab-sub">
                                                <table class="table">
                                                    <tr>
                                                        <td style="width: 50px;"><b>From Date:</b></td>
                                                        <td style="width: 150px;">
                                                            <input type="date" id="cruw_paper_from" name="cruw_paper_from" class="form-control" />
                                                        </td>
                                                        <td style="width: 50px;">
                                                            <b>Year:</b>
                                                        </td>
                                                        <td style="width: 150px;">
                                                            <input type="date" id="cruw_paper_to" name="cruw_paper_to" class="form-control" />
                                                        </td>
                                                        <td style="width: 100px;">
                                                            <button id="cruw_paper_btnShow" class="btn btn-primary" onclick="return cruw_paper_Submit()">Show</button>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <hr />
                                                <table class="table table-bordered" id="cruw_paper_table" style="padding-top: 10px; width: 100%;">
                                                    <thead>
                                                        <tr>
                                                            <th colspan="6"></th>
                                                            <th colspan="2" style="text-align: center;">Credit</th>
                                                            <th colspan="2" style="text-align: center;">Compliance</th>
                                                            <th colspan="2" style="text-align: center;">Collateral</th>
                                                        </tr>
                                                        <tr>
                                                            <th class="sort border-top ps-3" style="display: none;">App ID</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Answer Sheet</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Test Assigned Date</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Test Date</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Attempt</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Marks</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Percentage</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Marks</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Percentage</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Marks</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Percentage</th>
                                                        </tr>

                                                    </thead>
                                                    <tbody></tbody>

                                                </table>
                                            </div>
                                            <div class="tab-pane fade" id="custom-tabs-one-messages-sub" role="tabpanel" aria-labelledby="custom-tabs-one-messages-tab-sub">
                                                <table class="table">
                                                    <tr>
                                                        <td style="width: 50px;"><b>From Date:</b></td>
                                                        <td style="width: 150px;">
                                                            <input type="date" id="cruw_send_from" name="cruw_paper_from" class="form-control" />
                                                        </td>
                                                        <td style="width: 50px;">
                                                            <b>Year:</b>
                                                        </td>
                                                        <td style="width: 150px;">
                                                            <input type="date" id="cruw_send_to" name="cruw_paper_to" class="form-control" />
                                                        </td>

                                                        <td style="width: 100px;">
                                                            <button id="cruw_send_btnShow" class="btn btn-primary" onclick="return cruw_send_Submit();">Show</button>
                                                            <button id="cruw_send_btnSendEmail" class="btn btn-secondary" onclick="return cruw_send_SendEmail();">Send Email</button>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <hr />
                                                <table class="table table-bordered" id="cruw_send_table" style="padding-top: 10px; width: 100%;">
                                                    <thead>
                                                        <tr>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Action</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Application ID</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Position Applied For</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Email Address</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Contact #</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Result</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Marks Obtained</th>
                                                        </tr>

                                                    </thead>
                                                    <tbody></tbody>

                                                </table>

                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">

                                <div class="card card-tabs">
                                    <div class="card-header p-0 pt-1">
                                        <ul class="nav nav-tabs" id="custom-tabs-one-tab-sub-serv" role="tablist">
                                            <li class="nav-item">
                                                <a class="nav-link active" id="custom-tabs-one-home-tab-sub-serv" data-toggle="pill" href="#custom-tabs-one-home-sub-serv" role="tab" aria-controls="custom-tabs-one-home-sub-serv" aria-selected="true">Question Set</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" id="custom-tabs-one-profile-tab-sub-serv" data-toggle="pill" href="#custom-tabs-one-profile-sub-serv" role="tab" aria-controls="custom-tabs-one-profile-sub-serv" aria-selected="false">Check Question Paper</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" id="custom-tabs-one-messages-tab-sub-serv" data-toggle="pill" href="#custom-tabs-one-messages-sub-serv" role="tab" aria-controls="custom-tabs-one-messages-sub-serv" aria-selected="false">Send Test Link</a>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="card-body">
                                        <div class="tab-content" id="custom-tabs-one-tabContent-sub-serv">
                                            <div class="tab-pane fade show active" id="custom-tabs-one-home-sub-serv" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab-sub-serv">
                                                <%--Servicing Question Set--%>
                                                <table class="table">
                                                    <tr>
                                                        <td><b>Question:</b></td>
                                                        <td colspan="3">
                                                            <textarea id="crser_question" name="crser_question" class="form-control" style="width: 600px;"></textarea>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="display: none;"><b>Question Type:</b></td>
                                                        <td style="display: none;">
                                                            <select id="crser_questiontype" name="crser_questiontype" class="form-control" style="width: 300px;">
                                                                <option value="">Select</option>
                                                                <option value="Credit">Credit</option>
                                                                <option value="Compliance">Compliance</option>
                                                                <option value="Collateral">Collateral</option>
                                                            </select>
                                                        </td>
                                                        <td><b>Marks:</b></td>
                                                        <td>
                                                            <input type="number" id="crser_marks" name="cruw_marks" class="form-control" style="width: 300px;" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><b>Option 1:</b></td>
                                                        <td>
                                                            <input type="text" id="crser_option1" name="crser_option1" class="form-control" style="width: 300px; display: inline;" />
                                                            <input type="checkbox" class="custom-checkbox" id="crser_A_option1" />
                                                        </td>
                                                        <td><b>Option 2:</b></td>
                                                        <td>
                                                            <input type="text" id="crser_option2" name="crser_option2" class="form-control" style="width: 300px; display: inline;" />
                                                            <input type="checkbox" class="custom-checkbox" id="crser_A_option2" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><b>Option 3:</b></td>
                                                        <td>
                                                            <input type="text" id="crser_option3" name="crser_option3" class="form-control" style="width: 300px; display: inline;" />
                                                            <input type="checkbox" class="custom-checkbox" id="crser_A_option3" />
                                                        </td>
                                                        <td><b>Option 4:</b></td>
                                                        <td>
                                                            <input type="text" id="crser_option4" name="crser_option4" class="form-control" style="width: 300px; display: inline;" />
                                                            <input type="checkbox" class="custom-checkbox" id="crser_A_option4" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="4" style="text-align: center;">
                                                            <button id="crser_btnsubmit" class="btn btn-primary" onclick="return crser_submit();">Submit</button>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <hr />
                                                <table class="table" id="crser_table" style="width: 100%;">
                                                    <thead>
                                                        <tr>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Question</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Marks</th>
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
                                            <div class="tab-pane fade" id="custom-tabs-one-profile-sub-serv" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab-sub-serv">
                                                <table class="table">
                                                    <tr>
                                                        <td style="width: 50px;"><b>From Date:</b></td>
                                                        <td style="width: 150px;">
                                                            <input type="date" id="crser_paper_from" name="crser_paper_from" class="form-control" />
                                                        </td>
                                                        <td style="width: 50px;">
                                                            <b>Year:</b>
                                                        </td>
                                                        <td style="width: 150px;">
                                                            <input type="date" id="crser_paper_to" name="crser_paper_to" class="form-control" />
                                                        </td>
                                                        <td style="width: 100px;">
                                                            <button id="crser_paper_btnShow" class="btn btn-primary" onclick="return crser_paper_Submit()">Show</button>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <hr />
                                                <table class="table table-bordered" id="crser_paper_table" style="padding-top: 10px; width: 100%;">
                                                    <thead>
                                                        <tr>
                                                            <th class="sort border-top ps-3" style="display: none;">App ID</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Answer Sheet</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Test Date</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Attempt</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Marks</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Percentage</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody></tbody>
                                                </table>
                                            </div>
                                            <div class="tab-pane fade" id="custom-tabs-one-messages-sub-serv" role="tabpanel" aria-labelledby="custom-tabs-one-messages-tab-sub-serv">
                                                <table class="table">
                                                    <tr>
                                                        <td style="width: 50px;"><b>From Date:</b></td>
                                                        <td style="width: 150px;">
                                                            <input type="date" id="crser_send_from" name="crser_send_from" class="form-control" />
                                                        </td>
                                                        <td style="width: 50px;">
                                                            <b>Year:</b>
                                                        </td>
                                                        <td style="width: 150px;">
                                                            <input type="date" id="crser_send_to" name="crser_send_to" class="form-control" />
                                                        </td>

                                                        <td style="width: 100px;">
                                                            <button id="crser_send_btnShow" class="btn btn-primary" onclick="return crser_send_Submit();">Show</button>
                                                            <button id="crcrser_send_btnSendEmail" class="btn btn-secondary" onclick="return crser_send_SendEmail();">Send Email</button>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <hr />
                                                <table class="table table-bordered" id="crser_send_table" style="padding-top: 10px; width: 100%;">
                                                    <thead>
                                                        <tr>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Action</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Application ID</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Position Applied For</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Email Address</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Contact #</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Result</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Marks Obtained</th>
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
            </div>
        </div>
    </div>

    <div class="modal fade" id="cruw_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="cruw_errmsg"></h6>
                    <%--<button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>--%>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="cruw_btnMessage" onclick="return cruw_Message();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>
