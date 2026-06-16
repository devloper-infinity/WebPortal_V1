<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="HRInduction.aspx.cs" Inherits="WebPortal.Admin.HRInduction" %>

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
            inductionset_BindGrid();
            checkpaper_BindYear();
            indreport_BindYear();
        });

        window.onload = function () {
            document.getElementById('inductionset_attachment').addEventListener('change', getFileName);
        }

        const getFileName = (event) => {
            const files = event.target.files;
            var file = files[0];
            document.getElementById("filep").value = files[0].name;

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
            document.getElementById("filesdiv").innerHTML = file.name;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="filep" style="display: none;" />
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>HR Induction</b></h6>
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
                                <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Question Set</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">Check Question Paper</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-messages-tab" data-toggle="pill" href="#custom-tabs-one-messages" role="tab" aria-controls="custom-tabs-one-messages" aria-selected="false">Induction Report</a>
                            </li>
                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                                <table class="table">
                                    <tr>
                                        <td><b>Question:</b></td>
                                        <td colspan="3">
                                            <textarea id="inductionset_question" name="inductionset_question" class="form-control" style="width: 600px;"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><b>Weightage:</b></td>
                                        <td>
                                            <input type="number" id="inductionset_weightage" name="inductionset_weightage" class="form-control" style="width: 300px;" />
                                        </td>
                                        <td><b>Attachment:</b></td>
                                        <td>
                                            <input type="file" id="inductionset_attachment" name="inductionset_attachment" class="form-control" style="width: 300px;" />
                                            <div class="dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete" id="dropzone">
                                                <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column" id="conentdiv" style="display: none!important;">
                                                    <div class="flex-1 d-flex flex-between-center">
                                                        <div id="filesdiv" style="margin-top: 10px; margin-bottom: 10px;"></div>
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
                                    </tr>
                                    <tr>
                                        <td><b>Option 1:</b></td>
                                        <td>
                                            <input type="text" id="inductionset_option1" name="inductionset_option1" class="form-control" style="width: 300px; display: inline;" />
                                            <input type="checkbox" class="custom-checkbox" id="option1" />
                                        </td>
                                        <td><b>Option 2:</b></td>
                                        <td>
                                            <input type="text" id="inductionset_option2" name="inductionset_option2" class="form-control" style="width: 300px; display: inline;" />
                                            <input type="checkbox" class="custom-checkbox" id="option2" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><b>Option 3:</b></td>
                                        <td>
                                            <input type="text" id="inductionset_option3" name="inductionset_option3" class="form-control" style="width: 300px; display: inline;" />
                                            <input type="checkbox" class="custom-checkbox" id="option3" />
                                        </td>
                                        <td><b>Option 4:</b></td>
                                        <td>
                                            <input type="text" id="inductionset_option4" name="inductionset_option4" class="form-control" style="width: 300px; display: inline;" />
                                            <input type="checkbox" class="custom-checkbox" id="option4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" style="text-align: center;">
                                            <button id="inductionset_btnsubmit" class="btn btn-primary" onclick="return inductionset_submit();">Submit</button>
                                        </td>
                                    </tr>
                                </table>
                                <hr />
                                <table class="table" id="inductionset_table" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Question</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Weightage</th>
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
                            <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                                <table class="table">
                                    <tr>
                                        <td style="width: 50px;"><b>Month:</b></td>
                                        <td style="width: 150px;">
                                            <select id="checkpaper_month" name="checkpaper_month" class="form-control">
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
                                        </td>
                                        <td style="width: 50px;">
                                            <b>Year:</b>
                                        </td>
                                        <td style="width: 150px;">
                                            <select id="checkpaper_year" name="checkpaper_year" class="form-control">
                                                <option value="">Select</option>
                                            </select>
                                        </td>
                                        <td style="width: 100px;">
                                            <button id="checkpaper_btnShow" class="btn btn-primary" onclick="return checkpaper_Submit()">Show</button>
                                        </td>
                                    </tr>
                                </table>
                                <hr />
                                <table class="table" id="checkpaper_table" style="padding-top: 10px; width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="display: none;">Employee ID</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Answer Sheet</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Employee Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Result</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Exam Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Attempt</th>
                                        </tr>

                                    </thead>
                                    <tbody></tbody>

                                </table>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-messages" role="tabpanel" aria-labelledby="custom-tabs-one-messages-tab">
                                <table class="table">
                                    <tr>
                                        <td style="width: 50px;"><b>Month:</b></td>
                                        <td style="width: 150px;">
                                            <select id="indreport_month" name="indreport_month" class="form-control">
                                                <option value="">Select</option>
                                                <option value="All">All</option>
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
                                        </td>
                                        <td style="width: 50px;">
                                            <b>Year:</b>
                                        </td>
                                        <td style="width: 150px;">
                                            <select id="indreport_year" name="indreport_year" class="form-control">
                                                <option value="">Select</option>
                                            </select>
                                        </td>
                                        <td style="width: 100px;">
                                            <button id="indreport_btnShow" class="btn btn-primary" onclick="return indreportsummary_bindgrid()">Show</button>
                                        </td>
                                    </tr>
                                </table>
                                <hr />
                                <h6 style="text-decoration:underline;">Summary</h6><br />
                                <table class="table" id="indreport_table" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Total</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Completed</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Pending</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                                <h6 style="text-decoration:underline;">Details</h6>
                                <table class="table" id="indreportdetail_table" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Exam Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Result</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Marks Obtained</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Percentage</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Joining Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Department</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Designation</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Reporting Manager</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Attempt</th>
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

    <div class="modal fade" id="inductionset_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="inductionset_errmsg"></h6>
                    <%--<button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>--%>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="inductionset_btnMessage" onclick="return inductionset_Message();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>
