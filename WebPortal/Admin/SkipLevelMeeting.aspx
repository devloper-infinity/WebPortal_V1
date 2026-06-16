<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="SkipLevelMeeting.aspx.cs" Inherits="WebPortal.Admin.SkipLevelMeeting" %>

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
            skip_BindYear();
            skip_BindYearReport();
            skip_bindusers();
        });

        function skip_getempdetails_root(ddl) {
            skip_getempdetails(ddl, '<%= HttpContext.Current.User.Identity.Name.ToString() %>');
            return false;
        }

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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Skip Level Meeting</b></h6>
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
                                <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Skip Level Entry</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">Skip Level Report</a>
                            </li>

                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                                <div class="card card-primary card-outline">
                                    <div class="card-header">
                                        <div class="card-title">
                                            <i class="fas fa-edit"></i>
                                            Employee Details:
                                        </div>
                                    </div>
                                    <table class="table">
                                        <tr>
                                            <td><b>Employee:</b></td>
                                            <td>
                                                <select id="skip_employee" name="skip_employee" class="form-control" style="width: 350px;" onchange="return skip_getempdetails(this);"></select>
                                            </td>
                                            <td><b>Date:</b></td>
                                            <td>
                                                <input type="date" id="skip_date" name="skip_date" class="form-control" style="width: 350px;" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><b>Branch:</b></td>
                                            <td>
                                                <label id="skip_branch" name="skip_branch" class="form-control" style="width: 350px;"></label>
                                            </td>
                                            <td><b>Department</b></td>
                                            <td>
                                                <label id="skip_department" name="skip_department" class="form-control" style="width: 350px;"></label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><b>Designation:</b></td>
                                            <td>
                                                <label id="skip_designation" name="skip_designation" class="form-control" style="width: 350px;"></label>
                                            </td>
                                            <td><b>Reporting Manager:</b></td>
                                            <td>
                                                <label id="skip_reportingmanager" name="skip_reportingmanager" class="form-control" style="width: 350px;"></label>
                                            </td>
                                        </tr>

                                        <tr>
                                            <td><b>Increment %:</b></td>
                                            <td>
                                                <label id="skip_incrementperc" name="skip_incrementperc" class="form-control" style="width: 350px;"></label>
                                            </td>
                                            <td><b>Increment Amount:</b></td>
                                            <td>
                                                <label id="skip_incrementamount" name="skip_incrementamount" class="form-control" style="width: 350px;"></label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><b>Increment Month-Year:</b></td>
                                            <td>
                                                <label id="skip_incrementmonthyear" name="skip_incrementmonthyear" class="form-control" style="width: 350px;"></label>
                                            </td>
                                            <td><b>Next Increment Due:</b></td>
                                            <td>
                                                <label id="skip_nextincrementdue" name="skip_nextincrementdue" class="form-control" style="width: 350px;"></label>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="card card-primary card-outline">
                                    <div class="card-header">
                                        <div class="card-title">
                                            <i class="fas fa-edit"></i>
                                            Skip Level Details:
                                        </div>
                                    </div>
                                    <table class="table">
                                        <tr>
                                            <td><b>Year:</b></td>
                                            <td>
                                                <select id="skip_year" name="skip_year" class="form-control" style="width: 350px;"></select>
                                            </td>
                                            <td><b>Quarter:</b></td>
                                            <td>
                                                <select id="skip_quarter" name="skip_quarter" class="form-control" style="width: 350px;" onchange="return getlastfourGrading();">
                                                    <option value="">Select</option>
                                                    <option value="January ~ March">January ~ March</option>
                                                    <option value="April ~ June">April ~ June</option>
                                                    <option value="July ~ September">July ~ September</option>
                                                    <option value="October ~ December">October ~ December</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">

                                                <div class="card card-success card-outline">
                                                    <div class="card-header" style="padding: 0px 1.25rem!important;">
                                                        <div class="card-title" style="font-size: 14px!important;">
                                                            <i class="fas fa-chart-line"></i>
                                                            Last 4 quarters grading details:
                                                        </div>
                                                    </div>
                                                    <table class="table" id="skiplevel_gradingtable" style="width: 100%;">
                                                        <thead>
                                                            <tr>
                                                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Quarter</th>
                                                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Production Grade</th>
                                                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Quality Grade</th>
                                                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attendance Grade</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">

                                                <div class="card card-success card-outline">
                                                    <div class="card-header" style="padding: 0px 1.25rem!important;">
                                                        <div class="card-title" style="font-size: 14px!important;">
                                                            <i class="fas fa-history"></i>
                                                            Skip Level History:
                                                        </div>
                                                    </div>
                                                    <table class="table" id="skiplevel_historytable" style="width: 100%;">
                                                        <thead>
                                                            <tr>
                                                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Date</th>
                                                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Quarter</th>
                                                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Year</th>
                                                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Remark</th>
                                                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Added By</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><b>Status:</b></td>
                                            <td>
                                                <select id="skip_status" name="skip_status" class="form-control" style="width: 350px;">
                                                    <option value="">Select</option>
                                                    <option value="Discussion Completed">Discussion Completed</option>
                                                    <%--<option value="Need to contact again">Need to contact again</option>--%>
                                                </select>
                                            </td>
                                            <td><b>Remark:</b></td>
                                            <td>
                                                <textarea id="skip_remark" class="form-control" style="width: 350px;"></textarea>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="4" align="center">
                                                <button id="skip_btnsubmit" class="btn btn-primary" onclick="return skip_SubmitInfo();">Submit</button>
                                                <%--<button id="skip_btnsubmit" class="btn btn-primary" onclick="return skip_SubmitInfo();">Proceed to add details</button>--%>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="card card-primary card-outline" id="skip_dvcomments" style="display: none;">
                                    <div class="card-header">
                                        <div class="card-title">
                                            <i class="fas fa-edit"></i>
                                            Employee Comments:
                                        </div>
                                    </div>
                                    <table class="table">
                                        <tr>
                                            <td><b>Type:</b></td>
                                            <td>
                                                <select id="skip_type" name="skip_type" class="form-control" style="width: 350px;">
                                                    <option value="">Select</option>
                                                    <option value="Appreciation">Appreciation</option>
                                                    <option value="Complaint">Complaint</option>
                                                    <option value="Feedback">Feedback</option>
                                                    <option value="Suggestion">Suggestion</option>
                                                </select>
                                            </td>
                                            <td><b>Description:</b></td>
                                            <td>
                                                <textarea id="skip_description" name="skip_description" class="form-control" style="width: 350px; display: inline!important"></textarea>
                                                <button id="skip_btnaddcomment" class="btn buttons-excel" onclick="return skip_Addremark();" style="vertical-align: top;">Add</button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><b>Comments:</b></td>
                                            <td colspan="3">
                                                <select id="skip_comments" name="skip_comments" class="form-control list-group" multiple style="width: 800px; overflow:auto;"></select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="4" align="center">
                                                <button id="skip_btnfinalsubmit" class="btn btn-primary" onclick="return skip_finalsubmit();">Submit</button>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                                <table class="table">
                                    <tr>
                                        <td style="width: 50px;">
                                            <b>Year:</b>
                                        </td>
                                        <td style="width: 150px;">
                                            <select id="skip_yearreport" name="skip_yearreport" class="form-control">
                                                <option value="">Select</option>
                                            </select>
                                        </td>
                                        <td style="width: 50px;"><b>Quarter:</b></td>
                                        <td style="width: 150px;">
                                            <select id="skip_quarterreport" name="skip_quarterreport" class="form-control" style="width: 350px;">
                                                <option value="">Select</option>
                                                <option value="January ~ March">January ~ March</option>
                                                <option value="April ~ June">April ~ June</option>
                                                <option value="July ~ September">July ~ September</option>
                                                <option value="October ~ December">October ~ December</option>
                                            </select>
                                        </td>

                                        <td style="width: 100px;">
                                            <button id="skiplevel_btnShow" class="btn btn-primary" onclick="return skiplevel_SubmitReport();">Show</button>
                                            <asp:Button ID="btnExporttoExcel" runat="server" OnClick="btnExporttoExcel_Click" Text="Export to excel" CssClass="btn btn-secondary" />
                                        </td>
                                    </tr>
                                </table>
                                <hr />
                                <table class="table" id="skiplevel_reporttable" style="padding-top: 10px; width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; ">Branch</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align:center;">Total</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align:center;">Actual Contacted</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align:center;">Discussion Completed</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align:center; display:none;">Need To Contact Again</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align:center;">Absconding</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align:center;">Pending</th>
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

    <div class="modal fade" id="skip_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="skip_errmsg"></h6>
                    <%--<button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>--%>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="skip_btnMessage" onclick="return skip_Message();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

</asp:Content>
