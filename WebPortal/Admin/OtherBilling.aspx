<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="OtherBilling.aspx.cs" Inherits="WebPortal.Admin.OtherBilling" %>

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

        .dataTables_paginate {
            float: left !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 50px;
            float: left;
        }

        .buttons-excel {
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
            /*background:linear-gradient(to bottom, #0070C0, 80%, #ffffff);*/
            background: linear-gradient(to bottom, #cbd0dd, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none;
        }

        .dt-center {
            text-align: center;
        }
    </style>

    <script>

        $(document).ready(function () {
            BindDomainWise_Project(9);
            //otherBilling_BindDetails();
        });

        window.onload = function () {
            document.getElementById('otherBilling_attachment').addEventListener('change', getFileName);
        }

        const getFileName = (event) => {
            const files = event.target.files;
            var file = files[0];
            document.getElementById("file_otherBilling").value = files[0].name;

            const fd = new FormData();

            // add all selected files
            fd.append(event.target.name, file, file.name);
            // create the request
            const xhr = new XMLHttpRequest();

            xhr.onload = () => {
                if (xhr.status >= 200 && xhr.status < 300) {
                    // we done!
                }
            };
            var url = window.location.href;
            // path to server would be where you'd normally post the form to
            xhr.open('POST', url, true);
            xhr.send(fd);
            document.getElementById("dropzone").classList.add("dz-max-files-reached");
            document.getElementById("conentdiv").style.display = '';
            document.getElementById("otherbillingfilesdiv").innerHTML = file.name;
        }

    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="file_otherBilling" style="display: none;" />
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Other Billing</b></h6>
                </div>
                <div class="col-sm-6" style="text-align: right;">
                    <a href="ExcelBillingReport.aspx" class="m-0" style="font-size: 13px; text-decoration: underline; float: right; margin-right: 100px; font-weight: bold;">Sent To Billing Report >> </a>
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
                        <td><b>Project Type:</b></td>
                        <td>
                            <select id="otherBilling_ProjectType" name="otherBilling_ProjectType" class="form-control" style="width: 250px;">
                                <option value="Select">Select</option>
                                <option value="Rebuttal">Condition Clearing</option>
                                <option value="Research">Research</option>
                            </select>
                        </td>
                        <td><b>Project :</b></td>
                        <td>
                            <select id="otherBilling_Project" name="otherBilling_Project" class="form-control" style="width: 250px;" onchange="return bindDeals(this);">
                                <%-- <option value="Select">Select</option>--%>
                            </select>
                        </td>
                        <td>
                            <a href="../Formats/ImportRebuttalFormat.xlsx" style="font-family: Verdana; font-size: 13px; font-weight: bold; color: blue; text-decoration: underline;">Condition Clearing</a>
                            <a href="../Formats/ImportResearchFormat.xlsx" style="font-family: Verdana; font-size: 13px; font-weight: bold; color: blue; padding-left: 20px; text-decoration: underline;">Research Format</a>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Deal #:</b></td>
                        <td>
                            <select id="otherBilling_DealNo" name="otherBilling_DealNo" class="form-control" style="width: 250px;"></select>
                        </td>
                        <td><b>Attachment:</b></td>
                        <td>
                            <input type="file" id="otherBilling_attachment" name="otherBilling_attachment" class="form-control" style="width: 250px;" />
                            <div class="dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete" id="dropzone">
                                <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column" id="conentdiv" style="display: none!important;">
                                    <div class="flex-1 d-flex flex-between-center">
                                        <div id="otherbillingfilesdiv" style="margin-top: 10px; margin-bottom: 10px;"></div>
                                        <div class="dropdown font-sans-serif">
                                            <button class="btn btn-link text-600 btn-sm dropdown-toggle btn-reveal dropdown-caret-none" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                <svg class="svg-inline--fa fa-ellipsis" style="display: none!important" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="ellipsis" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg="">
                                                    <path fill="currentColor" d="M120 256C120 286.9 94.93 312 64 312C33.07 312 8 286.9 8 256C8 225.1 33.07 200 64 200C94.93 200 120 225.1 120 256zM280 256C280 286.9 254.9 312 224 312C193.1 312 168 286.9 168 256C168 225.1 193.1 200 224 200C254.9 200 280 225.1 280 256zM328 256C328 225.1 353.1 200 384 200C414.9 200 440 225.1 440 256C440 286.9 414.9 312 384 312C353.1 312 328 286.9 328 256z"></path></svg><!-- <span class="fas fa-ellipsis-h"></span> Font Awesome fontawesome.com --></button>
                                            <div class="dropdown-menu dropdown-menu-end border py-2"><a class="dropdown-item" href="#!" data-dz-remove="data-dz-remove">Remove File</a></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </td>
                        <td>
                            <button type="submit" id="otherBilling_Import" name="otherBilling_Import" class="btn btn-primary" onclick="return btnOtherBilling_Import();">Import</button>
                            &nbsp;&nbsp;&nbsp;&nbsp;
                            <button type="submit" id="otherBilling_Verify" name="otherBilling_Verify" class="btn btn-primary" onclick="return btnOtherBilling_Verify();">Verify & Submit</button>
                        </td>
                    </tr>
                </table>
                <hr />

                <table class="table" id="table_Research" style="display: none;">
                    <thead>
                        <tr>
                            <%--  <th class="sort border-top ps-3" style="width: 80px;">Sr. #</th>--%>
                            <th class="sort border-top ps-3" style="width: 100px;">Deal #</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Deal Name</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Subject Line</th>
                            <th class="sort border-top ps-3" style="width: 100px;">No of Loans/Docs</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Requested Docs/Tasks Performed</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Total Time Taken (in Minutes)</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Request Received from</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Request Received Date</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Documents Delivered Date</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Remark</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Time (In Hours)</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                    <tfoot>
                        <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td style="font-weight: bold; font-size: 13px;"></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                    </tfoot>

                </table>

                <table class="table" id="table_Rebuttal" style="display: none;">
                    <thead>
                        <tr>
                            <%-- <th class="sort border-top ps-3" style="width: 80px;">Sr. #</th>--%>
                            <th class="sort border-top ps-3" style="width: 100px;">Deal #</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Loan Name</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Condition</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Status</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Client Rebuttal</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Rebuttal Received Date</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Rebuttal Response Date</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Review Time (In Minutes)</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Time</th>
                            <%-- <th class="sort border-top ps-3" style="width: 150px;">Amount</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Rate</th>--%>
                            <th class="sort border-top ps-3" style="width: 150px;">Billing Type</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>

                <table class="table" id="table_Other" style="display: none;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="width: 80px;">Sr. #</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Name</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Week</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Hours Worked</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Rate/Hour</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Extra Hours Worked</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Extra Hours Rate/Hour</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Total</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
                <table class="table" id="table_670" style="display: none;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="width: 80px;">Sr. #</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Week Worked</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Day</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Total Hours Worked</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Rate</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Amount</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Job Description</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Member Name</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
                <table class="table" id="table_639" style="display: none;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="width: 80px;">Sr. #</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Day</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Loan Number</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Last Name</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Underwriting Status</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Underwriter</th>
                            <th class="sort border-top ps-3" style="width: 100px;">No of Re-Submission</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Billable Re-Submission</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Additional Touches</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Initial Review Rate</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Re-Submission Rate</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Total Billing</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Remark</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
                <table class="table" id="table_Secure" style="display: none;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="width: 80px;">Sr. #</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Task/Process</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Billable Hours</th>
                            <th class="sort border-top ps-3" style="width: 150px; text-align: center;">Total Billing</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Remark</th>
                            <th class="sort border-top ps-3" style="width: 100px; text-align: center;">Billing Type</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
                <table class="table" id="table_Inventory" style="display: none;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="width: 80px;">Sr. #</th>
                            <th class="sort border-top ps-3" style="width: 100px;">PRP ID</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Seller ID</th>
                            <th class="sort border-top ps-3" style="width: 150px; text-align: center;">Deal #</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Total Time Spent in Minutes</th>
                            <th class="sort border-top ps-3" style="width: 100px; text-align: center;">Time (In Hours)</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="OtherBilling_Waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">System is updating details. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>

    <div class="modal fade" id="billingMessage">
        <div class="modal-dialog modal-l">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Notification</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p style="font-size: 16px;">Data has been verified and submitted successfully</p>
                </div>
                <div class="modal-footer justify-content-between">
                    <%--<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>--%>
                    <button class="btn btn-primary" type="button" id="roam_btnYes" onclick="window.location.reload();">OK</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

</asp:Content>
