<%@ Page Title="" Language="C#" MasterPageFile="~/Accounts/Accounts.Master" AutoEventWireup="true" CodeBehind="IncrementReport.aspx.cs" Inherits="WebPortal.Accounts.IncrementReport" %>

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

      .erp-page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    flex-wrap: wrap;
    gap: 10px;
}

.erp-title {
    margin: 0;
    font-size: 26px;
    font-weight: 600;
    color: #1f2937;
}

.erp-subtitle {
    font-size: 13px;
    color: #6b7280;
    margin-top: 2px;
}

/* ===================================
   CARD
=================================== */

.erp-card {
    background: #ffffff;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 2px 10px rgba(0,0,0,0.06);
    border: 1px solid #e5e7eb;
}

.erp-card-header {
    padding: 14px 18px;
    background: #f8fafc;
    border-bottom: 1px solid #e5e7eb;
}

.erp-card-title {
    font-size: 16px;
    font-weight: 600;
    color: #111827;
}

.erp-card-body {
    padding: 15px;
}

/* ===================================
   TABLE
=================================== */

#incapr_tblIncrementApproval,
#inchist_tblIncrementHistory {
    width: 100% !important;
}

#incapr_tblIncrementApproval thead th,
#incapr_tblIncrementApproval tbody td,
#incapr_tblIncrementApproval tfoot th,
#incapr_tblIncrementApproval tfoot td,
#inchist_tblIncrementHistory thead th,
#inchist_tblIncrementHistory tbody td {

    white-space: nowrap;
    vertical-align: middle;
}

/* FOOTER */

#incapr_tblIncrementApproval tfoot th,
#incapr_tblIncrementApproval tfoot td {

    background: #f8fafc !important;
    font-weight: 600;
    border-top: 2px solid #d1d5db !important;
}

/* IMPORTANT */

.dataTables_scrollFootInner,
.dataTables_scrollFootInner table {

    width: 100% !important;
}

/* HEADER + FOOTER WIDTH MATCH */

.dataTables_scrollHeadInner table,
.dataTables_scrollFootInner table {

    margin-bottom: 0 !important;
}

/* REMOVE EXTRA SPACING */

.dataTables_wrapper .dataTables_scrollFoot {

    overflow: hidden !important;
}

.inchist-column-filter {
    display: block;
    width: 100%;
    min-width: 110px;
    margin-top: 6px;
    padding: 4px 6px;
    font-size: 12px;
    font-weight: normal;
}
        /*.form-control {
            font-size: 11px !important;
        }*/
    </style>
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet" />

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        $(document).ready(function () {
            moninc_bindyear();
            monincdiff_bindyear();
            incentry_bindemployee();
            incentry_bindeffectiveyear();
            incentry_bindnextdueyear();
            incentry_bindretentionperiod();
            incentry_bindretentionyear();
            bindincrementapproval();
            inchist_bindfilters();
        });

        window.onload = function () {
            document.getElementById('incentry_attachment').addEventListener('change', getFileName);
        }

        const getFileName = (event) => {
            const files = event.target.files;
            var file = files[0];
            document.getElementById("filep").value = files[0].name;
            const fd = new FormData();
            fd.append(event.target.name, file, file.name);
            const xhr = new XMLHttpRequest();

            xhr.onload = () => {
                if (xhr.status >= 200 && xhr.status < 300) {
                }
            };
            var url = window.location.href;
            xhr.open('POST', url, true);
            xhr.send(fd);
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Monthly Increments</b></h6>
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
                                <a class="nav-link active" id="custom-tabs-one-home-tab-IM" data-toggle="pill" href="#custom-tabs-one-home-IM" role="tab" aria-controls="custom-tabs-one-home-IM" aria-selected="true">Increment Entry</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Monthly Increments Report</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">Increment Differences</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-profile-tab-approval" data-toggle="pill" href="#custom-tabs-one-profile-approval" role="tab" aria-controls="custom-tabs-one-profile-approval" aria-selected="false">Increment Approval</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-history-tab" data-toggle="pill" href="#custom-tabs-one-history" role="tab" aria-controls="custom-tabs-one-history" aria-selected="false">Increment History</a>
                            </li>

                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-home-IM" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab-IM">
                                <div class="card-header">
                                    <div class="card-title">
                                        <i class="fas fa-edit"></i>
                                        Employee Information:
                                    </div>
                                </div>
                                <table class="table">
                                    <tr>
                                        <td><b>Code:</b></td>
                                        <td>
                                            <select id="incentry_employee" name="incentry_employee" class="form-control" style="width: 250px;" onchange="return incentry_getempinfo(this);"></select>
                                        </td>
                                        <td><b>Name:</b></td>
                                        <td>
                                            <label id="incentry_empname" name="incentry_empname" class="form-control" style="width: 250px;"></label>
                                        </td>
                                        <td><b>Joining Date:</b></td>
                                        <td>
                                            <label id="incentry_joiningdate" name="incentry_joiningdate" class="form-control" style="width: 250px;"></label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><b>Branch:</b></td>
                                        <td>
                                            <label id="incentry_branch" name="incentry_branch" class="form-control" style="width: 250px;"></label>
                                        </td>
                                        <td><b>Department:</b></td>
                                        <td>
                                            <label id="incentry_dept" name="incentry_dept" class="form-control" style="width: 250px;"></label>
                                        </td>
                                        <td><b>Designation:</b></td>
                                        <td>
                                            <label id="incentry_desg" name="incentry_desg" class="form-control" style="width: 250px;"></label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><b>Salary:</b></td>
                                        <td>
                                            <label id="incentry_salary" name="incentry_salary" class="form-control" style="width: 250px;"></label>
                                        </td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                </table>
                                <div class="card-header">
                                    <div class="card-title">
                                        <i class="fas fa-edit"></i>
                                        Increment Information:
                                    </div>
                                </div>
                                <table class="table">
                                    <tr>
                                        <td><b>Effective Month:</b></td>
                                        <td>
                                            <select id="incentry_month" name="incentry_month" class="form-control" style="width: 250px;">
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
                                        <td><b>Effective Year:</b></td>
                                        <td>
                                            <select id="incentry_year" name="incentry_year" class="form-control" style="width: 250px;"></select>
                                        </td>
                                        <td><b>Incremented Salary:</b></td>
                                        <td>
                                            <input type="number" id="incentry_incrementedsalary" name="incentry_incrementedsalary" class="form-control" style="width: 250px;" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><b>Attendane Bonus:</b></td>
                                        <td colspan="5">
                                            <select id="incentry_isattbonus" name="incentry_isattbonus" class="form-control" style="width: 250px; display: inline!important;" onchange="return getattendancebounusattributes(this);">
                                                <option value="">Select</option>
                                                <option value="Yes">Yes</option>
                                                <option value="No">No</option>
                                            </select>
                                            &nbsp;
                                            <select id="incentry_attbonustype" name="incentry_attbonustype" class="form-control" style="width: 250px; display: none;">
                                                <option value="">Select</option>
                                                <option value="Fix Amount">Fix Amount</option>
                                                <option value="Percentage">Percentage</option>
                                            </select>
                                            &nbsp;
                                            <input type="number" id="incentry_attbonus" name="incentry_attbonus" class="form-control" style="width: 250px; display: none;" onchange="incentry_getattbonusamount();" />
                                            &nbsp;
                                            <label id="incentry_attbonusamount" name="incentry_attbonusamount" class="col-form-label" style="width: 250px; display: none;"></label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><b>Retention Bonus:</b></td>
                                        <td colspan="5">
                                            <select id="incentry_isretention" name="incentry_isretention" class="form-control" style="width: 250px; display: inline!important;" onchange="return getretentionattributes(this);">
                                                <option value="">Select</option>
                                                <option value="Yes">Yes</option>
                                                <option value="No">No</option>
                                            </select>
                                            &nbsp;<b id="retamt" style="display: none;">Amount:</b>
                                            <input type="number" id="incentry_retentionamount" name="incentry_retentionamount" class="form-control" style="width: 100px; display: none;" />
                                            &nbsp;<b id="retprd" style="display: none;">For Period:</b>
                                            <select id="incentry_retentionperiod" name="incentry_retentionperiod" class="form-control" style="width: 100px; display: none;">
                                            </select>
                                            &nbsp;<b id="retmth" style="display: none;">Effective Month:</b>
                                            <select id="incentry_retentionmonth" name="incentry_retentionmonth" class="form-control" style="width: 100px; display: none;">
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
                                            &nbsp;<b id="retyer" style="display: none;">Effective Year:</b>
                                            <select id="incentry_retentionyear" name="incentry_retentionyear" class="form-control" style="width: 100px; display: none;">
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><b>Attachment:</b></td>
                                        <td>
                                            <input type="file" id="incentry_attachment" name="incentry_attachment" class="form-control" style="width: 250px;" />
                                        </td>
                                        <td><b>Next Inc Due Month:</b></td>
                                        <td>
                                            <select id="incentry_nextincmonth" name="incentry_nextincmonth" class="form-control" style="width: 250px;">
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
                                        <td><b>Next Inc Due Year:</b></td>
                                        <td>
                                            <select id="incentry_nextincyear" name="incentry_nextincyear" class="form-control" style="width: 250px;"></select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><b>Remark:</b></td>
                                        <td colspan="4">
                                            <textarea id="incentry_remark" name="incentry_remark" class="form-control" style="width: 700px;"></textarea>
                                        </td>
                                        <td>
                                            <button id="incentry_btnsubmit" name="incentry_btnsubmit" class="btn btn-primary" onclick="return incentry_submit();">Submit</button>
                                        </td>
                                        <td></td>
                                    </tr>
                                </table>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                                <table class="table">
                                    <tr>
                                        <td style="width: 50px;"><b>Month:</b></td>
                                        <td style="width: 150px;">
                                            <select id="moninc_month" name="moninc_month" class="form-control">
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
                                            <select id="moninc_year" name="moninc_year" class="form-control">
                                                <option value="">Select</option>
                                            </select>
                                        </td>
                                        <td style="width: 100px;">
                                            <button id="moninc_btnShow" class="btn btn-primary" onclick="return moninc_bindgrid();">Show</button>
                                        </td>
                                    </tr>
                                </table>
                                <hr />
                                <table class="table table-bordered" style="width: 100%;" id="moninc_table">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Department</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Designation</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Domain</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Joining Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Last Increment Month-Year</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Current Increment Month-Year</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Salary Before Increment</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Salary After Increment</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Difference Amount</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Increment Percentage</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Next Increment Due On</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Retention Bonus</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">For Period</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Effective Month</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Effective Year</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Status</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Remark</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added By</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added IP</th>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                                <table class="table">
                                    <tr>
                                        <td style="width: 50px;"><b>Month:</b></td>
                                        <td style="width: 150px;">
                                            <select id="monincdiff_month" name="monincdiff_month" class="form-control">
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
                                            <select id="monincdiff_year" name="monincdiff_year" class="form-control">
                                                <option value="">Select</option>
                                            </select>
                                        </td>
                                        <td style="width: 100px;">
                                            <button id="monincdiff_btnShow" class="btn btn-primary" onclick="return monincdiff_bindgrid();">Show</button>

                                        </td>
                                    </tr>
                                </table>
                                <hr />
                                <table class="table table-bordered" style="width: 100%;" id="monincdiff_table">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Department</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Domain</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Bank Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Account #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">IFSC Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Salary</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Increment Percentage</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Last Increment Month-Year</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Next Increment Due On</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Month</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Year</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Total Days</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Gross Difference</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Actual Difference</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Total Amount</th>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-profile-approval" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab-approval">
                                <!-- ===================================
     PAGE HEADER
=================================== -->

                                <div class="erp-page-header">


                                    <div>
                                        <button type="button"
                                            id="incapr_btnSubmit"
                                            class="btn btn-success erp-btn"
                                            onclick="return approveincrements();">

                                            <i class="fa fa-check-circle"></i>
                                            Approve Selected

                                        </button>
                                    </div>

                                </div>

                                <!-- ===================================
     GRID SECTION
=================================== -->

                                <div class="erp-card">

                                    <div class="erp-card-header">

                                        <div class="erp-card-title">
                                            Pending Increment List
                                        </div>

                                    </div>

                                    <div class="erp-card-body">

                                        <div class="table-responsive">

                                            <table id="incapr_tblIncrementApproval"
                                                class="table table-bordered table-hover align-middle w-100">

                                                <thead>

                                                    <tr>

                                                        <th width="40">
                                                            <input type="checkbox" id="incapr_chkAll" />
                                                        </th>

                                                        <th>Sr#</th>
                                                        <th>Code</th>
                                                        <th>Employee Name</th>
                                                        <th>Before Salary</th>
                                                        <th>Current Salary</th>
                                                        <th>Difference</th>
                                                        <th>Attendance Bonus</th>
                                                        <th>Quality Bonus</th>
                                                        <th>Month</th>
                                                        <th>Year</th>
                                                        <th>%</th>
                                                        <th>Remark</th>
                                                        <th>Next Due Month</th>
                                                        <th>Next Due Year</th>
                                                        <th>Retention Bonus</th>
                                                        <th>Period</th>
                                                        <th>Effective Month</th>
                                                        <th>Effective Year</th>
                                                        <th>Added By</th>
                                                        <th>Added Date</th>

                                                    </tr>

                                                </thead>

                                                <tbody>
                                                </tbody>

                                                <tfoot>

                                                    <tr style="display:none;">

                                                        <th colspan="4" class="text-end">Total :
                                                        </th>

                                                        <th id="total_before_salary"></th>
                                                        <th id="total_current_salary"></th>
                                                        <th id="total_difference"></th>

                                                        <th colspan="14"></th>

                                                    </tr>

                                                </tfoot>

                                            </table>

                                        </div>

                                    </div>

                                </div>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-history" role="tabpanel" aria-labelledby="custom-tabs-one-history-tab">
                                <div class="erp-card">
                                    <div class="erp-card-header">
                                        <div class="erp-card-title">Increment History Filters</div>
                                    </div>
                                    <div class="erp-card-body">
                                        <div class="form-row">
                                            <div class="form-group col-md-3">
                                                <label for="inchist_code">Employee Code</label>
                                                <select id="inchist_code" class="form-control">
                                                    <option value="">All Employees</option>
                                                </select>
                                            </div>
                                            <div class="form-group col-md-2">
                                                <label for="inchist_fromdate">Added From Date</label>
                                                <input type="date" id="inchist_fromdate" class="form-control" />
                                            </div>
                                            <div class="form-group col-md-2">
                                                <label for="inchist_todate">Added To Date</label>
                                                <input type="date" id="inchist_todate" class="form-control" />
                                            </div>
                                            <div class="form-group col-md-2">
                                                <label for="inchist_status">Status</label>
                                                <select id="inchist_status" class="form-control">
                                                    <option value="">All</option>
                                                    <option value="Pending">Pending</option>
                                                    <option value="Approved">Approved</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="form-row align-items-end">
                                            <div class="form-group col-md-2">
                                                <label for="inchist_frommonth">Effective From Month</label>
                                                <select id="inchist_frommonth" class="form-control">
                                                    <option value="0">All</option>
                                                    <option value="1">January</option>
                                                    <option value="2">February</option>
                                                    <option value="3">March</option>
                                                    <option value="4">April</option>
                                                    <option value="5">May</option>
                                                    <option value="6">June</option>
                                                    <option value="7">July</option>
                                                    <option value="8">August</option>
                                                    <option value="9">September</option>
                                                    <option value="10">October</option>
                                                    <option value="11">November</option>
                                                    <option value="12">December</option>
                                                </select>
                                            </div>
                                            <div class="form-group col-md-2">
                                                <label for="inchist_fromyear">Effective From Year</label>
                                                <select id="inchist_fromyear" class="form-control">
                                                    <option value="0">All</option>
                                                </select>
                                            </div>
                                            <div class="form-group col-md-2">
                                                <label for="inchist_tomonth">Effective To Month</label>
                                                <select id="inchist_tomonth" class="form-control">
                                                    <option value="0">All</option>
                                                    <option value="1">January</option>
                                                    <option value="2">February</option>
                                                    <option value="3">March</option>
                                                    <option value="4">April</option>
                                                    <option value="5">May</option>
                                                    <option value="6">June</option>
                                                    <option value="7">July</option>
                                                    <option value="8">August</option>
                                                    <option value="9">September</option>
                                                    <option value="10">October</option>
                                                    <option value="11">November</option>
                                                    <option value="12">December</option>
                                                </select>
                                            </div>
                                            <div class="form-group col-md-2">
                                                <label for="inchist_toyear">Effective To Year</label>
                                                <select id="inchist_toyear" class="form-control">
                                                    <option value="0">All</option>
                                                </select>
                                            </div>
                                            <div class="form-group col-md-4">
                                                <button type="button" id="inchist_btnShow" class="btn btn-primary" onclick="return inchist_bindgrid();">
                                                    <i class="fa fa-search"></i> Show
                                                </button>
                                                <button type="button" id="inchist_btnReset" class="btn btn-secondary ml-2" onclick="return inchist_resetfilters();">
                                                    <i class="fa fa-undo"></i> Reset
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="erp-card mt-3">
                                    <div class="erp-card-header">
                                        <div class="erp-card-title">Increment History</div>
                                    </div>
                                    <div class="erp-card-body">
                                        <div class="table-responsive">
                                            <table id="inchist_tblIncrementHistory" class="table table-bordered table-hover align-middle w-100">
                                                <thead>
                                                    <tr>
                                                        <th>Sr#</th>
                                                        <th>
                                                            Code
                                                            <input type="text" class="form-control inchist-column-filter inchist-code-column-filter" placeholder="Filter code" />
                                                        </th>
                                                        <th>
                                                            Employee Name
                                                            <input type="text" class="form-control inchist-column-filter inchist-name-column-filter" placeholder="Filter name" />
                                                        </th>
                                                        <th>Before Salary</th>
                                                        <th>Current Salary</th>
                                                        <th>Difference</th>
                                                        <th>Attendance Bonus</th>
                                                        <th>Quality Bonus</th>
                                                        <th>Month</th>
                                                        <th>Year</th>
                                                        <th>%</th>
                                                        <th>Remark</th>
                                                        <th>Next Due Month</th>
                                                        <th>Next Due Year</th>
                                                        <th>Retention Bonus</th>
                                                        <th>Period</th>
                                                        <th>Effective Month</th>
                                                        <th>Effective Year</th>
                                                        <th>Added By</th>
                                                        <th>Added Date</th>
                                                        <th>Status</th>
                                                        <th>Approved By</th>
                                                        <th>Approved Date</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                </tbody>
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
    <div class="modal fade" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">System is sending email notification. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>
    <div class="modal fade" id="increport_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="increport_errmsg"></h6>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="bank_btnMessage" onclick="location.reload();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

</asp:Content>
