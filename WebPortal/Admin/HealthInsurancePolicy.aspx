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

        .insurance-hero {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            min-height: 78px;
            padding: 16px 18px;
            border-radius: 8px;
            background: linear-gradient(90deg, #172554 0%, #2457e6 55%, #0891b2 100%);
            color: #fff;
            box-shadow: 0 14px 32px rgba(15, 23, 42, .12);
        }

        .insurance-hero-title {
            display: flex;
            align-items: center;
            gap: 13px;
            min-width: 0;
        }

        .insurance-hero-icon {
            width: 44px;
            height: 44px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            background: rgba(255,255,255,.15);
            font-size: 18px;
        }

        .insurance-hero h1 {
            margin: 0;
            font-size: 22px;
            font-weight: 800;
            line-height: 1.15;
        }

        .insurance-hero p {
            margin: 4px 0 0;
            color: rgba(255,255,255,.82);
            font-size: 12px;
        }

        .insurance-hero-chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 12px;
            border: 1px solid rgba(255,255,255,.25);
            border-radius: 999px;
            background: rgba(255,255,255,.14);
            font-size: 12px;
            font-weight: 800;
            white-space: nowrap;
        }

        @media (max-width: 575px) {
            .insurance-hero {
                align-items: flex-start;
                flex-direction: column;
            }
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

        .mgmt-report { font-size: 12px; }
        .mgmt-report .table { width: 100% !important; white-space: nowrap; }
        .mgmt-report .dataTables_wrapper { width: 100%; overflow-x: auto; }
        .mgmt-cards { display:grid; grid-template-columns:repeat(5,minmax(150px,1fr)); gap:10px; }
        .mgmt-card { border-left:4px solid #047edf; background:#f8fbff; padding:10px; border-radius:7px; }
        .mgmt-card span { color:#667085; display:block; }
        .mgmt-card b { font-size:17px; }
        .mgmt-loading { display:none; position:fixed; inset:0; z-index:2000; background:rgba(255,255,255,.65); align-items:center; justify-content:center; font-size:18px; font-weight:bold; }
        @media(max-width:991px){.mgmt-cards{grid-template-columns:repeat(2,minmax(140px,1fr));}}
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
                refreshRemainingMonthAmounts();
            });

            $(document).on('keyup change', '#insurance_txtPercentage', function () {
                getAmountDistributionPercentage();
                refreshRemainingMonthAmounts();
            });

            $(document).on('change', '#insurance_txtPolicyStartDate, #insurance_txtPolicyPeriod1', function () {
                refreshRemainingMonthAmounts();
                refreshAllFamilyRemainingMonthAmounts();
            });

            $(document).ajaxComplete(function (event, xhr, settings) {
                if (settings.url.indexOf('/getAmountDistribution') >= 0 || settings.url.indexOf('/GetEmployeePolicyInfo') >= 0) {
                    refreshRemainingMonthAmounts();
                    setTimeout(refreshAllFamilyRemainingMonthAmounts, 0);
                }
                if (settings.url.indexOf('/GetFamilyInfo') >= 0)
                    setTimeout(refreshAllFamilyRemainingMonthAmounts, 0);
            });

            $(document).on('keyup', '#insurance_txtEmployeeSearch', function () {
                bindLeftEmployeeList();
            });

            $(document).on('change', '#insurance_ddlEmployeeStatus', function () {
                bindLeftEmployeeList();
            });

            $(document).on('change', '#insurance_ddlContriCategory', function () {
                handleContributionCategory();
            });

            $(document).on('keyup change', '.fam-premium', function () {
                calculateFamilyContribution(this);
                refreshFamilyRemainingMonthAmounts($(this).closest('tr'));
            });


        });

        function refreshRemainingMonthAmounts() {
            var start = $('#insurance_txtPolicyStartDate').val();
            var period = $('#insurance_txtPolicyPeriod1').val();
            var employeeYearly = parseFloat($('#insurance_txtEmployeeApproxPremiumYearly').val()) || 0;
            var companyYearly = parseFloat($('#insurance_txtCompContributionYearly').val()) || 0;
            if (!start || !period || !selectedEmployeeId) return;

            $.ajax({
                url: 'HealthInsurancePolicy.aspx/CalculateMonthlyContributions',
                type: 'POST',
                contentType: 'application/json; charset=utf-8',
                data: JSON.stringify({
                    employeeId: selectedEmployeeId,
                    policyId: selectedPolicyId,
                    policyStartDate: start,
                    policyPeriod: period,
                    employeeYearly: employeeYearly,
                    companyYearly: companyYearly
                }),
                success: function (res) {
                    $('#insurance_txtEmployeeApproxPremiumMonthly').val(res.d.EmployeeMonthly.toFixed(2));
                    $('#insurance_txtCompContributionMonthly').val(res.d.CompanyMonthly.toFixed(2));
                }
            });
        }

        function refreshAllFamilyRemainingMonthAmounts() {
            $('#insurance_tblFamily tbody tr').each(function () {
                refreshFamilyRemainingMonthAmounts($(this));
            });
        }

        function refreshFamilyRemainingMonthAmounts(row) {
            var start = $('#insurance_txtPolicyStartDate').val();
            var period = $('#insurance_txtPolicyPeriod1').val();
            var employeeYearly = parseFloat(row.find('.fam-emp-yearly').val()) || 0;
            var companyYearly = parseFloat(row.find('.fam-comp-yearly').val()) || 0;
            if (!start || !period || !selectedEmployeeId || !row.find('.fam-premium').length) return;

            $.ajax({
                url: 'HealthInsurancePolicy.aspx/CalculateFamilyMonthlyContributions',
                type: 'POST',
                contentType: 'application/json; charset=utf-8',
                data: JSON.stringify({
                    employeeId: selectedEmployeeId,
                    policyId: selectedPolicyId,
                    policyStartDate: start,
                    policyPeriod: period,
                    employeeYearly: employeeYearly,
                    companyYearly: companyYearly
                }),
                success: function (res) {
                    row.find('.fam-emp-monthly').val(res.d.EmployeeMonthly.toFixed(2));
                    row.find('.fam-comp-monthly').val(res.d.CompanyMonthly.toFixed(2));
                }
            });
        }

        var mgmtLoaded = false, mgmtLoading = false;
        function mgmtFilters() { return {
            policy:$('#mgmtPolicy').val()||'', policyPeriod:$('#mgmtPeriod').val()||'', employee:$('#mgmtEmployee').val()||'',
            department:$('#mgmtDepartment').val()||'', location:$('#mgmtLocation').val()||'', status:$('#mgmtStatus').val()||'',
            contributionType:$('#mgmtContribution').val()||'', fromDate:$('#mgmtFrom').val()||'', toDate:$('#mgmtTo').val()||'' }; }
        function mgmtMoney(v){return '₹'+(parseFloat(v)||0).toLocaleString('en-IN',{minimumFractionDigits:2,maximumFractionDigits:2});}
        function mgmtSelect(id,values){var old=$(id).val()||'',h='<option value="">All</option>';$.each(values||[],function(_,v){h+='<option>'+v+'</option>';});$(id).html(h).val(old);}
        function mgmtTable(id,data,columns){if($.fn.DataTable.isDataTable(id))$(id).DataTable().clear().destroy();$(id).DataTable({data:data||[],columns:columns,scrollX:true,autoWidth:false,pageLength:10,order:[],language:{emptyTable:'No records found'}});}
        function loadManagementReport(){
            if(mgmtLoading)return; mgmtLoading=true;
            $('#mgmtLoading').css('display','flex');
            $.ajax({url:'HealthInsurancePolicy.aspx/GetManagementReport',type:'POST',contentType:'application/json; charset=utf-8',data:JSON.stringify(mgmtFilters())})
            .done(function(res){var x=res.d,s=x.Summary;
                var cards=[['Total Policies',s.TotalPolicies],['Enrolled Employees',s.TotalEnrolledEmployees],['Annual Premium',mgmtMoney(s.TotalAnnualPremium)],['Company Contribution',mgmtMoney(s.TotalCompanyContribution)],['Employee Contribution',mgmtMoney(s.TotalEmployeeContribution)],['Monthly Company',mgmtMoney(s.TotalMonthlyCompanyDeduction)],['Monthly Employee',mgmtMoney(s.TotalMonthlyEmployeeDeduction)],['Added Later',s.LateEmployees],['Active Policies',s.ActivePolicies],['Expiring Soon',s.ExpiringSoon]];
                $('#mgmtCards').html($.map(cards,function(c){return '<div class="mgmt-card"><span>'+c[0]+'</span><b>'+c[1]+'</b></div>';}).join(''));
                if(!mgmtLoaded){var periods=[];$('#insurance_ddlPolicyPeriodTab2 option').each(function(){if(this.value)periods.push(this.value);});mgmtSelect('#mgmtPolicy',x.Filters.Policies);mgmtSelect('#mgmtPeriod',periods.length?periods:x.Filters.Periods);mgmtSelect('#mgmtEmployee',x.Filters.Employees);mgmtSelect('#mgmtDepartment',x.Filters.Departments);mgmtSelect('#mgmtLocation',x.Filters.Locations);mgmtSelect('#mgmtContribution',x.Filters.ContributionTypes);}
                var money=function(d){return mgmtMoney(d);};
                mgmtTable('#mgmtPolicyTable',x.PolicySummary,[{data:null,render:function(_,__,___,m){return m.row+1;}},{data:'PolicyName',render:function(d,_,r){return '<a href="#" class="mgmt-policy" data-policy="'+d+'" data-period="'+r.PolicyPeriod+'">'+d+'</a>'; }},{data:'PolicyStartDate'},{data:'PolicyEndDate'},{data:'TotalEmployees',render:function(d,_,r){return '<a href="#" class="mgmt-policy" data-policy="'+r.PolicyName+'" data-period="'+r.PolicyPeriod+'">'+d+'</a>'; }},{data:'OriginalEmployees'},{data:'EmployeesAddedLater'},{data:'TotalAnnualPremium',render:money},{data:'CompanyContribution',render:money},{data:'EmployeeContribution',render:money},{data:'MonthlyCompanyContribution',render:money},{data:'MonthlyEmployeeContribution',render:money},{data:'TotalDeducted',render:money},{data:'RemainingDeduction',render:money},{data:'PolicyStatus'},{data:'RemainingDays'}]);
                mgmtTable('#mgmtEmployeeTable',x.EmployeeDetails,[{data:null,render:function(_,__,___,m){return m.row+1;}},{data:'EmployeeCode'},{data:'EmployeeName'},{data:'Department'},{data:'Location'},{data:'PolicyName'},{data:'EmployeeStart'},{data:'PolicyEnd'},{data:'ContributionType'},{data:'AnnualPremium',render:money},{data:'CompanyContribution',render:money},{data:'EmployeeContribution',render:money},{data:'RemainingMonths'},{data:'MonthlyCompanyContribution',render:money},{data:'MonthlyEmployeeContribution',render:money},{data:'AlreadyDeductedEmployeeAmount',render:money},{data:'AlreadyDeductedCompanyAmount',render:money},{data:'RemainingEmployeeAmount',render:money},{data:'RemainingCompanyAmount',render:money},{data:'DeductionStartMonth'},{data:'LastDeductedMonth'},{data:'Status'}]);
                mgmtTable('#mgmtLateTable',x.LateEnrollment,[{data:'Employee'},{data:'Policy'},{data:'OriginalPolicyStartDate'},{data:'EmployeeEffectiveStartDate'},{data:'MonthsElapsed'},{data:'RemainingDeductionMonths'},{data:'AnnualPremium',render:money},{data:'EmployeeMonthlyContribution',render:money},{data:'CompanyMonthlyContribution',render:money}]);
                mgmtTable('#mgmtDeductionTable',x.DeductionSummary,[{data:'Policy'},{data:'TotalExpectedEmployeeContribution',render:money},{data:'EmployeeContributionDeducted',render:money},{data:'EmployeeContributionPending',render:money},{data:'TotalExpectedCompanyContribution',render:money},{data:'CompanyContributionProcessed',render:money},{data:'CompanyContributionPending',render:money},{data:'CompletionPercent',render:function(d){return d+'%';}}]);
                $('#mgmtTotals').html('<b>Total Employees:</b> '+s.TotalEnrolledEmployees+' &nbsp; <b>Total Premium:</b> '+mgmtMoney(s.TotalAnnualPremium)+' &nbsp; <b>Total Company:</b> '+mgmtMoney(s.TotalCompanyContribution)+' &nbsp; <b>Total Employee:</b> '+mgmtMoney(s.TotalEmployeeContribution)+' &nbsp; <b>Total Deducted:</b> '+mgmtMoney($.fn.DataTable.isDataTable('#mgmtPolicyTable')?$('#mgmtPolicyTable').DataTable().column(12).data().reduce(function(a,b){return a+(parseFloat(b)||0);},0):0)+' &nbsp; <b>Total Pending:</b> '+mgmtMoney($.fn.DataTable.isDataTable('#mgmtPolicyTable')?$('#mgmtPolicyTable').DataTable().column(13).data().reduce(function(a,b){return a+(parseFloat(b)||0);},0):0));
                mgmtLoaded=true;
            }).fail(function(x){Swal.fire('Error',x.responseText,'error');}).always(function(){mgmtLoading=false;$('#mgmtLoading').hide();});
        }
        function resetManagementReport(){$('#tab-management select,#tab-management input').val('');loadManagementReport();}
        function exportManagementReport(){$('#mgmtLoading').css('display','flex');$.ajax({url:'HealthInsurancePolicy.aspx/ExportManagementReport',type:'POST',contentType:'application/json; charset=utf-8',data:JSON.stringify(mgmtFilters())}).done(function(r){var a=document.createElement('a');a.href='data:application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;base64,'+r.d;a.download='HealthInsuranceManagementReport.xlsx';a.click();}).fail(function(x){Swal.fire('Error',x.responseText,'error');}).always(function(){$('#mgmtLoading').hide();});}
        $(document).on('shown.bs.tab','a[href="#tab-management"]',function(){if(!mgmtLoaded)resetManagementReport();});
        $(document).on('click','.mgmt-policy',function(e){e.preventDefault();$('#mgmtPolicy').val($(this).data('policy'));$('#mgmtPeriod').val($(this).data('period'));loadManagementReport();});
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

    <!-- Toastr JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

    <!-- SweetAlert -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="content-header">
        <div class="container">
            <header class="insurance-hero">
                <div class="insurance-hero-title">
                    <span class="insurance-hero-icon"><i class="fas fa-shield-alt"></i></span>
                    <div>
                        <h1>Health Insurance Policy Management</h1>
                        <p>Select employees, assign policy, manage family details and active insurance records.</p>
                    </div>
                </div>
                <span class="insurance-hero-chip"><i class="fas fa-layer-group"></i> Insurance Policy</span>
            </header>
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
                        <li class="nav-item"><a class="nav-link" data-toggle="pill" href="#tab-management" role="tab" onclick="if(!mgmtLoaded)resetManagementReport();">Management Report</a></li>
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

                                <input type="text" class="form-control mb-2" id="insurance_txtEmployeeSearch" placeholder="Search employees" />
                                <select class="form-control mb-2" id="insurance_ddlEmployeeStatus">
                                    <option value="All">All</option>
                                    <option value="Pending">Pending</option>
                                    <option value="Policy Applied">Policy Applied</option>
                                </select>

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

                    <div class="tab-pane fade mgmt-report" id="tab-management" role="tabpanel">
                        <div class="section-title">Management Report</div>
                        <div class="row mb-2">
                            <div class="col-md-2"><label>Policy</label><select id="mgmtPolicy" class="form-control"><option value="">All</option></select></div>
                            <div class="col-md-2"><label>Policy Period</label><select id="mgmtPeriod" class="form-control"><option value="">All</option></select></div>
                            <div class="col-md-2"><label>Employee</label><select id="mgmtEmployee" class="form-control"><option value="">All</option></select></div>
                            <div class="col-md-2"><label>Department</label><select id="mgmtDepartment" class="form-control"><option value="">All</option></select></div>
                            <div class="col-md-2"><label>Location</label><select id="mgmtLocation" class="form-control"><option value="">All</option></select></div>
                            <div class="col-md-2"><label>Status</label><select id="mgmtStatus" class="form-control"><option value="">All</option><option>Not Started</option><option>Active</option><option>Deduction In Progress</option><option>Completed</option><option>Expired</option><option>Expiring Soon</option></select></div>
                        </div>
                        <div class="row align-items-end mb-3">
                            <div class="col-md-2"><label>Contribution Type</label><select id="mgmtContribution" class="form-control"><option value="">All</option></select></div>
                            <div class="col-md-2"><label>From Date</label><input id="mgmtFrom" type="date" class="form-control" /></div>
                            <div class="col-md-2"><label>To Date</label><input id="mgmtTo" type="date" class="form-control" /></div>
                            <div class="col-md-6"><button type="button" class="btn btn-primary mr-2" onclick="loadManagementReport()">Search</button><button type="button" class="btn btn-default mr-2" onclick="resetManagementReport()">Reset</button><button type="button" class="btn btn-success" onclick="exportManagementReport()"><i class="fas fa-file-excel"></i> Export to Excel</button></div>
                        </div>
                        <div id="mgmtCards" class="mgmt-cards mb-4"></div>

                        <div class="section-title">Policy-wise Summary</div>
                        <table id="mgmtPolicyTable" class="table table-bordered table-sm"><thead><tr><th>Sr #</th><th>Policy Name</th><th>Policy Start Date</th><th>Policy End Date</th><th>Total Employees</th><th>Original Employees</th><th>Employees Added Later</th><th>Total Annual Premium</th><th>Company Contribution</th><th>Employee Contribution</th><th>Monthly Company Contribution</th><th>Monthly Employee Contribution</th><th>Total Deducted</th><th>Remaining Deduction</th><th>Policy Status</th><th>Remaining Days</th></tr></thead></table>

                        <div class="section-title mt-4">Employee-wise Details</div>
                        <table id="mgmtEmployeeTable" class="table table-bordered table-sm"><thead><tr><th>Sr #</th><th>Employee Code</th><th>Employee Name</th><th>Department</th><th>Location</th><th>Policy Name</th><th>Employee Policy Start Date</th><th>Policy End Date</th><th>Contribution Type</th><th>Annual Premium</th><th>Company Contribution</th><th>Employee Contribution</th><th>Remaining Months</th><th>Monthly Company Contribution</th><th>Monthly Employee Contribution</th><th>Already Deducted Employee Amount</th><th>Already Deducted Company Amount</th><th>Remaining Employee Amount</th><th>Remaining Company Amount</th><th>Deduction Start Month</th><th>Last Deducted Month</th><th>Status</th></tr></thead></table>

                        <div class="section-title mt-4">Employees Added After Policy Start</div>
                        <table id="mgmtLateTable" class="table table-bordered table-sm"><thead><tr><th>Employee</th><th>Policy</th><th>Original Policy Start Date</th><th>Employee Effective Start Date</th><th>Months Elapsed</th><th>Remaining Deduction Months</th><th>Annual Premium</th><th>Employee Monthly Contribution</th><th>Company Monthly Contribution</th></tr></thead></table>

                        <div class="section-title mt-4">Deduction Progress</div>
                        <table id="mgmtDeductionTable" class="table table-bordered table-sm"><thead><tr><th>Policy</th><th>Total Expected Employee Contribution</th><th>Employee Contribution Deducted</th><th>Employee Contribution Pending</th><th>Total Expected Company Contribution</th><th>Company Contribution Processed</th><th>Company Contribution Pending</th><th>Completion %</th></tr></thead></table>
                        <div id="mgmtTotals" class="summary-card mt-3"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="mgmtLoading" class="mgmt-loading"><i class="fas fa-spinner fa-spin mr-2"></i> Loading report...</div>

</asp:Content>
