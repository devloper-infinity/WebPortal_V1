<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="CompensatoryOff.aspx.cs" Inherits="WebPortal.Admin.CompensatoryOff" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script>
        $(document).ready(function () {

            var currentUserName = '<%= HttpContext.Current.User.Identity.Name.ToString() %>';

            setTabVisibility();

            bindworkedholiday(currentUserName);
        });

        $(function () {
            $("#compoff_date").datepicker({
                dateFormat: "dd-M-yy"  // 01-Jan-2026
            });

            $("#teamcompoffadd_date").datepicker({
                dateFormat: "dd-M-yy"
            });
        });
    </script>
    <link rel="stylesheet" href="dist/css/adminlte.min.css">
    <link rel="stylesheet" href="dist/css/custom-style.css">
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Compensatory Off</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <div class="card-header p-0 pt-1">
                    <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist" style="font-weight: bold;">
                        <li class="nav-item" id="liUserCompOff">
                            <a class="nav-link active" id="custom-tabs-two-user-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">My Compensatory Off</a>
                        </li>
                        <li class="nav-item" id="liTeamCompOff">
                            <a class="nav-link" id="custom-tabs-two-pm-tab" data-toggle="pill" href="#custom-tabs-two" role="tab" aria-controls="custom-tabs-two-pm" onclick="return teambindWorkedHoliday_Grid();" aria-selected="false">Team Compensation Off</a>
                        </li>
                    </ul>
                </div>
                <div class="card-body">
                    <div class="tab-content" id="custom-tabs-one-tabContent">
                        <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                            <%--  <table class="table">
                                <tr>
                                    <td><b>Worked Holiday Date :</b></td>
                                    <td>
                                        <select id="compoff_holidaydate" name="compoff_holidaydate" class="form-control" style="width: 300px;">
                                            <option value="Select">Select</option>
                                        </select>
                                    </td>
                                    <td><b>Comp Off Date :</b></td>
                                    <td>
                                        <input type="text" id="compoff_date" name="compoff_date" class="form-control" style="width: 300px;" />
                                    </td>
                                </tr>
                                <tr>
                                    <td><b>Remark :</b></td>
                                    <td>
                                        <textarea id="compoff_remark" name="compoff_remark" class="form-control" style="width: 300px;"></textarea>
                                    </td>
                                    <td></td>
                                    <td>
                                        <button id="compoff_btn" class="btn gradient-btn" onclick="return compoff_btnsubmit();">Submit</button>
                                    </td>
                                </tr>
                            </table>--%>

                            <div class="container-fluid">

                                <div class="row align-items-end g-3">

                                    <!-- Worked Holiday Date -->
                                    <div class="col">
                                        <label for="compoff_holidaydate" class="form-label fw-bold">
                                            Worked Holiday Date
                                        </label>

                                        <select id="compoff_holidaydate"
                                            name="compoff_holidaydate"
                                            class="form-control">
                                            <option value="Select">Select</option>
                                        </select>
                                    </div>

                                    <!-- Comp Off Date -->
                                    <div class="col">
                                        <label for="compoff_date" class="form-label fw-bold">
                                            Comp Off Date
                                        </label>

                                        <input type="text"
                                            id="compoff_date"
                                            name="compoff_date"
                                            class="form-control" />
                                    </div>

                                    <!-- Remark -->
                                    <div class="col">
                                        <label for="compoff_remark" class="form-label fw-bold">
                                            Remark
                                        </label>

                                        <textarea id="compoff_remark"
                                            name="compoff_remark"
                                            class="form-control"
                                            rows="1"></textarea>
                                    </div>

                                    <!-- Submit -->
                                    <div class="col-auto d-flex align-items-end">
                                        <button id="compoff_btn"
                                            class="btn gradient-btn px-4"
                                            onclick="return compoff_btnsubmit();">
                                            Submit
                                        </button>
                                    </div>

                                </div>

                            </div>

                            <hr />
                            <table class="table" id="table_compoff" style="width: 100%;">
                                <thead>
                                    <tr>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Worked-Holiday</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Compensatory Off</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Remark</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Requested Date</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Approval Status</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Approval Remark</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Approved By</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Approved Date</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                        <div class="tab-pane fade" id="custom-tabs-two" role="tabpanel" aria-labelledby="custom-tabs-two-tab">
                            <button type="button" id="addNewcompoff_btn" class="btn gradient-btn" onclick="return addNewCompesatoryOff();">Add New Comensatory Off</button>
                            <hr />
                            <div style="overflow: auto;">
                                <table class="table" id="table_pmcompoff" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Action</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">EmpName</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Department</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Designation</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Domain</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sub-Domain</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Reporting Manager</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Worked-Holiday</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Compensatory Off</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; width: 300px;">Remark</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Requested Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Approval Status</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Approval Remark</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Approved By</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Approved Date</th>
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

    <%------ Add New ------%>
    <div class="modal fade" id="teamCompOffadd_details" data-backdrop="static" tabindex="-1">
        <div class="modal-dialog modal-xl modal-dialog-centered">
            <div class="modal-content custom-comp-modal">

                <!-- Header -->
                <div class="modal-header custom-comp-header">
                    <h5 class="modal-title">
                        <i class="fa fa-calendar-check mr-2"></i>
                        Compensatory Off
                    </h5>
                    <button type="button" class="close text-white" data-dismiss="modal">
                        <span>&times;</span>
                    </button>
                </div>

                <!-- Body -->
                <div class="modal-body">

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label>Employee</label>
                            <select id="teamCompOffadd_user" class="form-control custom-input" onchange="return bindTeamtHoliday(this);" style="height:40px;">
                                <option value="Select">Select</option>
                            </select>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label>Worked Holiday Date</label>
                            <select id="temcompoffadd_holidaydate" class="form-control custom-input" style="height:40px;">
                                <option value="Select">Select</option>
                            </select>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label>Comp Off Date</label>
                            <input type="text" id="teamcompoffadd_date" class="form-control custom-input"  style="height:40px;"/>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label>Remark</label>
                            <textarea id="teamCompOffadd_remark" class="form-control custom-input" rows="2"></textarea>
                        </div>

                    </div>

                </div>

                <!-- Footer -->
                <div class="modal-footer custom-footer">
                    <button type="button" class="btn btn-light btn-cancel" data-dismiss="modal">Cancel</button>
                    <button type="button" class="btn gradient-btn" onclick="return teamCompOffAdd_btnSubmit();">Submit</button>
                </div>

            </div>
        </div>
    </div>


    <%------ Approve Reject ------%>
    <div class="modal fade" id="teamCompOff_details" data-backdrop="static" tabindex="-1">
        <div class="modal-dialog modal-xl modal-dialog-centered">
            <div class="modal-content custom-comp-modal">

                <!-- Header -->
                <div class="modal-header custom-comp-header">
                    <h5 class="modal-title font-weight-bold" id="teamCompOff_lbldetails"></h5>
                    <button type="button" class="close text-white" data-dismiss="modal">
                        <span>&times;</span>
                    </button>
                </div>

                <!-- Body -->
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label>Worked Holiday Date</label>
                            <input type="text" id="temcompoff_holidaydate" readonly class="form-control custom-input" />
                        </div>
                        <div class="col-md-6 mb-3">
                            <label>Comp Off Date</label>
                            <input type="text" id="teamcompoff_date" readonly class="form-control custom-input" />
                        </div>

                        <div class="col-md-6 mb-3">
                            <label>Status</label>
                            <select id="teamCompOff_Status" class="form-control custom-input">
                                <option value="Select">Select</option>
                                <option value="Approved">Approve</option>
                                <option value="Rejected">Reject</option>
                            </select>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label>Remark</label>
                            <textarea id="teamCompOff_remark" class="form-control custom-input" rows="2"></textarea>
                        </div>
                    </div>
                </div>

                <!-- Footer -->
                <div class="modal-footer custom-footer">
                    <button type="button" class="btn btn-light btn-cancel" data-dismiss="modal">Cancel</button>
                    <button type="button" class="btn gradient-btn" onclick="return teamCompOff_btnSubmit();">Submit</button>
                </div>

            </div>
        </div>
    </div>


    <div class="modal fade" id="compoff_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="compoff_errmsg"></h6>
                </div>
                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="compoff_btnMessage" onclick="return compoff_Message();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>
