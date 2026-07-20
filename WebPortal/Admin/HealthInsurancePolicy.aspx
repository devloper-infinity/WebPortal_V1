<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="HealthInsurancePolicy.aspx.cs" Inherits="WebPortal.Admin.HealthInsurancePolicy" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <portal:VersionedScript Src="~/Scripts/Functions/HealthInsurance.js" runat="server"></portal:VersionedScript>

    <style>
        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: normal !important;
            border: none !important;
            color: #6c757d;
        }

        .page-title-box {
            background: #fff;
            border-left: 4px solid #047edf;
            padding: 12px 18px;
            border-radius: 1px;
            box-shadow: 0 1px 5px rgba(0,0,0,0.08);
        }

        .btn-gradient-primary {
            background: linear-gradient(to right, #90caf9, 3%, #047edf) !important;
            color: #fff;
            border-radius: 12px;
            height: 40px;
            font-weight: 500;
            border: 0;
            transition: 0.3s;
        }

            .btn-gradient-primary:hover {
                transform: translateY(-2px);
                color: #fff;
            }

        .btn-gradient-success {
            background: linear-gradient(to right, #90caf9, 3%, #047edf) !important;
            color: #fff;
            border-radius: 12px;
            height: 40px;
            font-weight: 500;
            border: 0;
        }

        .btn-gradient-danger {
            background: linear-gradient(to right, #ffbf96, #fe7096) !important;
            color: #fff;
            border-radius: 12px;
            height: 36px;
            font-weight: 500;
            border: 0;
        }

        .summary-card {
            background: #fff;
            border-radius: 10px;
            padding: 16px;
            box-shadow: 0 1px 6px rgba(0,0,0,0.08);
            border-left: 4px solid #047edf;
        }

            .summary-card h6 {
                font-size: 13px;
                color: #777;
                margin-bottom: 6px;
            }

            .summary-card h4 {
                margin: 0;
                font-weight: bold;
            }

        .section-title {
            font-size: 15px;
            font-weight: bold;
            margin-bottom: 12px;
            padding-bottom: 8px;
            border-bottom: 1px solid #e5e5e5;
        }

        .form-control {
            height: 38px;
            border-radius: 5px;
        }

        .table th {
            background: linear-gradient(to bottom, #007bff, 3%, #fff) !important;
            color: #000;
            white-space: nowrap;
        }

        th, td {
            white-space: nowrap;
        }

        .badge-pending {
            background: #ffc107;
            color: #000;
            padding: 5px 10px;
            border-radius: 12px;
        }

        .badge-active {
            background: #28a745;
            color: #fff;
            padding: 5px 10px;
            border-radius: 12px;
        }

        .badge-deleted {
            background: #dc3545;
            color: #fff;
            padding: 5px 10px;
            border-radius: 12px;
        }

        .sticky-action-bar {
            background: #fff;
            border-top: 1px solid #ddd;
            padding: 12px;
            position: sticky;
            bottom: 0;
            z-index: 10;
            box-shadow: 0 -2px 6px rgba(0,0,0,0.08);
        }

        .employee-list-box {
            max-height: 500px;
            overflow-y: auto;
            border: 1px solid #ddd;
            border-radius: 6px;
        }

        .employee-item {
            padding: 12px;
            border-bottom: 1px solid #ddd;
            cursor: pointer;
            transition: 0.2s;
            background: #fff;
        }

            .employee-item:hover {
                background: #f5f9ff;
            }

            .employee-item.active {
                background: #d9ecff !important;
                border-left: 4px solid #007bff;
                font-weight: 600;
            }

        .small-note {
            font-size: 12px;
            color: #777;
        }

        .compact-dashboard {
            display: flex;
            align-items: end;
            gap: 10px;
            background: #fff;
            padding: 12px;
            border-radius: 10px;
            box-shadow: 0 1px 6px rgba(0,0,0,0.08);
            overflow-x: auto;
            white-space: nowrap;
        }

        .dash-filter {
            min-width: 210px;
        }

            .dash-filter label {
                font-size: 12px;
                font-weight: bold;
                margin-bottom: 4px;
            }

        .dash-item {
            min-width: 105px;
            width: 150px;
            padding: 8px 12px;
            border-left: 4px solid #047edf;
            background: #f8fbff;
            border-radius: 8px;
        }

            .dash-item span {
                display: block;
                font-size: 12px;
                color: #666;
            }

            .dash-item b {
                font-size: 20px;
                color: #111;
            }

            .dash-item.premium {
                min-width: 150px;
            }
    </style>

    <script>
        $(document).ready(function () {
            bindPolicyUsers();
            bindPolicyAmounts();
            bindPolicyPeriodDropdown();
            bindDashboardPolicyPeriodDropdown();
            bindDashboardSummary();
            //bindActivePolicies();
            //bindDeletedEmployees();

            $(document).on('change', '.chkEmp', function () {
                updateSelectedCount();
            });

            $(document).on('change', '#insurance_chkAll', function () {
                $('.chkEmp').prop('checked', this.checked);
                updateSelectedCount();
            });

            function updateSelectedCount() {
                $('#insurance_selectedCount').text($('.chkEmp:checked').length);
            }

            $('#insurance_btnAddFamily').click(function () {
                addFamilyMember();
            });

            $('#insurance_btnSubmitPolicy').click(function () {
                savePolicyInfo();
            });

            $('#insurance_txtFamilyBirthDate').change(function () {
                insurance_calculateAge();
            });

            $(document).on('change', '#insurance_ddlApplicable', function () {
                getAmountDistribution();
            });

            $(document).on('change', '#insurance_ddlContriType', function () {
                getAmountDistributionPercentage();
            });

            $(document).on('keyup change', '#insurance_txtPercentage', function () {
                getAmountDistributionPercentage();
            });

            $(document).on('keyup change', '#insurance_txtApproxPremium', function () {
                if ($('#insurance_ddlContriType').val() !== '') {
                    getAmountDistributionPercentage();
                }
            });

            $(document).on('change', '#insurance_ddlContriCategory', function () {
                handleContributionCategory();
            });

            $(document).on('keyup change', '.fam-premium', function () {
                calculateFamilyContribution(this);
            });


        });
    </script>

    <script>
        //$("#insurance_txtPolicyStartDateMain").datepicker({ dateFormat: "dd-M-yy" });

        $(function () {
            $("#insurance_txtPolicyStartDateMain").datepicker({
                dateFormat: "dd-M-yy"  // 01-Jan-2026
            });
        });
</script>

    <!-- Toastr CSS -->
    <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" />

    <!-- jQuery -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

    <!-- Toastr JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

    <!-- SweetAlert -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="content-header">
        <div class="container-fluid">
            <div class="page-title-box">
                <h6 class="m-0">
                    <i class="fas fa-shield-alt"></i>&nbsp;&nbsp;
               
                    <b>Health Insurance Policy Management</b>
                </h6>
                <small class="text-muted">Select employees, assign policy, manage family details and active insurance records.</small>
            </div>
        </div>
    </div>

    <div class="col-lg-12 mt-3">
        <div class="card">
            <div class="card-body">

                <!-- SUMMARY CARDS -->
                <div class="compact-dashboard">

                    <div class="dash-filter">
                        <label>Policy Period</label>
                        <select class="form-control" id="insurance_ddlDashboardPolicyPeriod">
                            <option value="">All Policy Periods</option>
                        </select>
                    </div>

                    <div class="dash-item">
                        <span>Total</span>
                        <b id="dashTotalEmployees">0</b>
                    </div>

                    <div class="dash-item">
                        <span>Applied</span>
                        <b id="dashApplied">0</b>
                    </div>

                    <div class="dash-item">
                        <span>Pending</span>
                        <b id="dashPending">0</b>
                    </div>

                    <div class="dash-item">
                        <span>Family</span>
                        <b id="dashFamilyPolicy">0</b>
                    </div>

                    <div class="dash-item">
                        <span>Individual</span>
                        <b id="dashIndividualPolicy">0</b>
                    </div>

                    <div class="dash-item">
                        <span>Members</span>
                        <b id="dashFamilyMembers">0</b>
                    </div>

                    <div class="dash-item premium">
                        <span>Premium</span>
                        <b id="dashTotalPremium">₹0</b>
                    </div>

                </div>

                <!-- TABS -->
                <div class="card-header p-0 pt-1">
                    <ul class="nav nav-tabs" id="insurance-tabs" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" data-toggle="pill" href="#tab-pending" role="tab">Pending Employees
                        </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="tabAssignLink" data-toggle="pill" href="#tab-assign" role="tab">Assign Policy
                        </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" data-toggle="pill" href="#tab-active" role="tab" onclick="return assignedpolicy_bindgrid();">Assigned Policy
                        </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" data-toggle="pill" href="#tab-deleted" role="tab" onclick="return deletedpolicy_bindgrid();">Deleted Employees</a>
                        </li>
                    </ul>
                </div>

                <div class="tab-content mt-3">

                    <!-- TAB 1: PENDING EMPLOYEES -->
                    <div class="tab-pane fade show active" id="tab-pending" role="tabpanel">

                        <div class="section-title">Policy Assignment Details</div>

                        <div class="row align-items-end mb-3">

                            <div class="col-md-4">
                                <label><b>Policy Start Date</b></label>
                                <input type="text" class="form-control" id="insurance_txtPolicyStartDateMain" name="insurance_txtPolicyStartDateMain" placeholder="dd-MMM-yyyy" />
                            </div>

                            <div class="col-md-4">
                                <label><b>Policy Period</b></label>
                                <input type="text" class="form-control" id="insurance_txtPolicyPeriodMain" placeholder="2025-2026" />
                            </div>

                            <div class="col-md-4">
                                <label><b>Sum Insured</b></label>
                                <select class="form-control" id="insurance_ddlSumInsuredMain">
                                    <option value="">Select</option>
                                </select>
                            </div>

                            <div class="col-md-2" style="display: none;">
                                <button type="button" class="btn btn-gradient-primary w-100" onclick="submitSelectedEmployeesForPolicy()">Apply</button>
                            </div>

                        </div>

                        <!-- MAIN DATATABLE -->
                        <table class="table table-bordered table-hover" id="insurance_tblPolicyUsers" style="width: 100%;">
                            <thead>
                                <tr>
                                    <th>
                                        <input type="checkbox" id="insurance_chkAll" /></th>
                                    <th>Sr. #</th>
                                    <th>Code</th>
                                    <th>Name</th>
                                    <th>DOB</th>
                                    <th>Joining Date</th>
                                    <th>Branch</th>
                                    <th>Department</th>
                                    <th>Designation</th>
                                </tr>
                            </thead>
                        </table>


                        <div class="sticky-action-bar d-flex justify-content-between align-items-center">
                            <b>Selected Employees: <span id="insurance_selectedCount">0</span></b>
                            <div>
                                <button type="button" class="btn btn-default mr-2" onclick="resetPendingSelection()">Reset</button>
                                <button type="button" class="btn btn-gradient-success" onclick="submitSelectedEmployeesForPolicy()">Submit & Continue</button>
                            </div>
                        </div>
                    </div>

                    <!-- TAB 2: ASSIGN POLICY -->
                    <div class="tab-pane fade" id="tab-assign" role="tabpanel">
                        <div class="row">

                            <!-- LEFT EMPLOYEE LIST -->

                            <div class="col-md-3">
                                <div class="row mb-3">
                                    <div class="col-md-10">
                                        <label><b>Policy Period</b></label>
                                        <select class="form-control" id="insurance_ddlPolicyPeriodTab2" onchange="bindEmployeesByPolicyPeriod()">
                                            <option value="">Select</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="section-title">Selected Employees</div>

                                <!-- JS will bind selected employees here -->
                                <div class="employee-list-box" id="selectedEmployeeList">
                                </div>

                                <div class="mt-3">
                                    <b>Progress:</b>
                                    <span id="employeeProgress">0 / 0 Completed</span>
                                </div>
                            </div>

                            <!-- RIGHT FORM -->
                            <div class="col-md-9">

                                <div class="section-title">Employee Details</div>

                                <div class="row mb-3">
                                    <div class="col-md-3">
                                        <label><b>Code</b></label>
                                        <input type="text" id="insurance_txtEmpCode" class="form-control" readonly style="background-color: white; font-weight: bold;" />
                                    </div>

                                    <div class="col-md-5">
                                        <label><b>Name</b></label>
                                        <input type="text" id="insurance_txtEmpName" class="form-control" readonly style="background-color: white;" />
                                    </div>

                                    <div class="col-md-2">
                                        <label><b>Joining Date</b></label>
                                        <input type="text" id="insurance_txtJoiningDate" class="form-control" readonly style="background-color: white;" />
                                    </div>

                                    <div class="col-md-2">
                                        <label><b>Birth Date</b></label>
                                        <input type="text" id="insurance_txtBirthDate" class="form-control" readonly />
                                    </div>
                                </div>

                                <div class="section-title">Policy Information</div>

                                <div class="row mb-3">
                                    <div class="col-md-3">
                                        <label><b>Group Policy Type</b></label>
                                        <select class="form-control" id="insurance_ddlPolicyType">
                                            <option value="Select">Select</option>
                                            <option value="Individual">Individual</option>
                                            <option value="Family">Family</option>
                                        </select>
                                    </div>

                                    <div class="col-md-3">
                                        <label><b>Sum Insured</b></label>
                                        <input type="text" class="form-control" id="insurance_txtSumInsured" />
                                    </div>

                                    <div class="col-md-3">
                                        <label><b>Approx Premium</b></label>
                                        <input type="text" class="form-control" id="insurance_txtApproxPremium" />
                                    </div>

                                    <div class="col-md-3">
                                        <label><b>Company Contribution?</b></label>
                                        <select class="form-control" id="insurance_ddlApplicable">
                                            <option value="Select">Select</option>
                                            <option value="true">Yes</option>
                                            <option value="false">No</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-3">
                                        <label><b>Contribution Category</b></label>
                                        <select class="form-control" id="insurance_ddlContriCategory">
                                            <option value="Select">Select</option>
                                            <option value="Full">Full</option>
                                            <option value="Partial">Partial</option>
                                        </select>
                                    </div>

                                    <div class="col-md-3">
                                        <label><b>Contribution Type</b></label>
                                        <select class="form-control" id="insurance_ddlContriType">
                                            <option value="Select">Select</option>
                                            <option value="Percentage">Percentage</option>
                                            <option value="Fix Amount">Fix Amount</option>
                                        </select>
                                    </div>

                                    <div class="col-md-3">
                                        <label><b>Percentage / Fix Amount</b></label>
                                        <input type="text" class="form-control" id="insurance_txtPercentage" />
                                    </div>

                                    <div class="col-md-3">
                                        <label><b>Company Monthly</b></label>
                                        <input type="text" class="form-control" id="insurance_txtCompContributionMonthly" />
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-3">
                                        <label><b>Company Yearly</b></label>
                                        <input type="text" class="form-control" id="insurance_txtCompContributionYearly" />
                                    </div>

                                    <div class="col-md-3">
                                        <label><b>Employee Monthly</b></label>
                                        <input type="text" class="form-control" id="insurance_txtEmployeeApproxPremiumMonthly" />
                                    </div>

                                    <div class="col-md-3">
                                        <label><b>Employee Yearly</b></label>
                                        <input type="text" class="form-control" id="insurance_txtEmployeeApproxPremiumYearly" />
                                    </div>

                                    <div class="col-md-3">
                                        <label><b>Policy Start Date</b></label>
                                        <input type="date" class="form-control" id="insurance_txtPolicyStartDate" />
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-3">
                                        <label><b>Policy Period</b></label>
                                        <input type="text" class="form-control" id="insurance_txtPolicyPeriod1" />
                                    </div>
                                </div>

                                <div class="section-title">Family Information</div>

                                <div class="row align-items-end mb-3" style="display: none;">
                                    <div class="col-md-4">
                                        <label><b>Beneficiary Name</b></label>
                                        <input type="text" class="form-control" id="insurance_txtBeneficiaryName" />
                                    </div>

                                    <div class="col-md-2">
                                        <label><b>Relation</b></label>
                                        <select class="form-control" id="insurance_ddlRelation">
                                            <option value="">Select</option>
                                            <option value="Spouse">Spouse</option>
                                            <option value="Child">Child</option>
                                            <option value="Father">Father</option>
                                            <option value="Mother">Mother</option>
                                        </select>
                                    </div>

                                    <div class="col-md-2">
                                        <label><b>Birth Date</b></label>
                                        <input type="date" class="form-control" id="insurance_txtFamilyBirthDate" />
                                    </div>

                                    <div class="col-md-2">
                                        <label><b>Age</b></label>
                                        <input type="text" class="form-control" id="insurance_txtAge" readonly />
                                    </div>

                                    <div class="col-md-2">
                                        <button type="button" id="insurance_btnAddFamily" class="btn btn-gradient-primary w-100">
                                            Add
                                        </button>
                                    </div>
                                </div>
                                <div class="table-responsive">
                                    <table class="table table-bordered table-sm" id="insurance_tblFamily" style="width: 100%;">
                                        <thead>
                                            <tr>
                                                <th>Sr. #</th>
                                                <th>Name</th>
                                                <th>Relation</th>
                                                <th>Birth Date</th>
                                                <th>Age</th>
                                                <th>Approx Premium</th>
                                                <th>Company Monthly</th>
                                                <th>Company Yearly</th>
                                                <th>Employee Monthly</th>
                                                <th>Employee Yearly</th>
                                                <th>Save</th>
                                                <th>Delete</th>
                                            </tr>
                                        </thead>
                                    </table>
                                </div>
                                <div class="sticky-action-bar d-flex justify-content-between align-items-center">
                                    <button class="btn btn-default" type="button" id="insurance_btnPreviousEmployee">
                                        Previous Employee
                                    </button>

                                    <div>
                                        <button class="btn btn-gradient-primary mr-2" type="button" id="insurance_btnSubmitPolicy">
                                            Save Employee
                                        </button>

                                        <button class="btn btn-gradient-success" type="button" id="insurance_btnNextEmployee">
                                            Next Employee
                                        </button>
                                    </div>
                                </div>

                            </div>
                        </div>

                    </div>

                    <!-- TAB 3: ACTIVE POLICIES -->
                    <div class="tab-pane fade" id="tab-active" role="tabpanel">
                        <table class="table table-bordered table-hover" id="tblActivePolicies" style="width: 100%;">
                            <thead>
                                <tr>
                                    <th>Action</th>
                                    <th>Sr. #</th>
                                    <th>Code</th>
                                    <th>Employee Name</th>
                                    <th>Birth Date</th>
                                    <th>Joining Date</th>
                                    <th>Branch</th>
                                    <th>Policy Type</th>
                                    <th>Sum Insured</th>
                                    <th>Premium</th>
                                    <th>Policy Period</th>
                                    <th>Start Date</th>
                                </tr>
                            </thead>
                        </table>
                    </div>

                    <!-- TAB 4: DELETED EMPLOYEES -->
                    <div class="tab-pane fade" id="tab-deleted" role="tabpanel">
                        <table class="table table-bordered table-hover" id="tblDeletedEmployees" style="width: 100%;">
                            <thead>
                                <tr>
                                    <th>Sr. #</th>
                                    <th>Code</th>
                                    <th>Employee Name</th>
                                    <th>Birth Date</th>
                                    <th>Joining Date</th>
                                    <th>Branch</th>
                                    <%-- <th>Removed Date</th>--%>
                                    <%--<th>Reason</th>
                                    <th>Status</th>
                                    <th>Restore</th>--%>
                                </tr>
                            </thead>
                        </table>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.8/css/jquery.dataTables.min.css" />
    <link rel="stylesheet" href="https://cdn.datatables.net/fixedcolumns/4.3.0/css/fixedColumns.dataTables.min.css" />
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/fixedcolumns/4.3.0/js/dataTables.fixedColumns.min.js"></script>

</asp:Content>
