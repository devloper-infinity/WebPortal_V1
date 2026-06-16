let selectedEmployeeId = 0;
let selectedPolicyId = 0;
let currentEmployeeIndex = 0;
let policyEmployees = [];

$(document).on('click', '#insurance_btnPreviousEmployee', function () {
    openEmployeeByIndex(currentEmployeeIndex - 1);
});

$(document).on('click', '#insurance_btnNextEmployee', function () {
    openEmployeeByIndex(currentEmployeeIndex + 1);
});

function togglePrevNextButtons() {
    $('#insurance_btnPreviousEmployee').prop('disabled', currentEmployeeIndex <= 0);

    $('#insurance_btnNextEmployee').prop(
        'disabled',
        currentEmployeeIndex >= policyEmployees.length - 1 || policyEmployees.length === 0
    );
}

$(document).on('change', '#insurance_ddlDashboardPolicyPeriod', function () {
    bindDashboardSummary();
});

function bindPolicyUsers() {

    $('#insurance_tblPolicyUsers').DataTable({
        destroy: true,
        paging: false,
        processing: true,
        info: true,
        responsive: true,
        autoWidth: false,
        destroy: true,
        fixedHeader: true,
        // pageLength: 20,
        scrollX: true,
        scrollY: '500px',
        scrollCollapse: true,

        ajax: {
            url: 'HealthInsurancePolicy.aspx/GetPolicyUsers',
            type: 'POST',
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            dataSrc: function (json) {
                return JSON.parse(json.d);
            }
        },

        columns: [
            {
                data: 'EmployeeID',
                orderable: false,
                render: function (data) {
                    return `<input type="checkbox" class="chkEmp" value="${data}" />`;
                }
            },
            {
                data: null,
                render: function (data, type, row, meta) {
                    return meta.row + 1;
                }
            },
            { data: 'Code' },
            { data: 'EmpName' },
            { data: 'DateOfBirth' },
            { data: 'JoiningDate' },
            { data: 'BranchName' },
            { data: 'DepartmentName' },
            { data: 'DesignationName' }
        ]
    });
}

function submitSelectedEmployeesForPolicy() {
    let policyStartDate = $('#insurance_txtPolicyStartDateMain').val();
    let policyPeriod = $('#insurance_txtPolicyPeriodMain').val();
    let sumInsured = $('#insurance_ddlSumInsuredMain').val();
    let policyId = $('#insurance_ddlSumInsuredMain option:selected').data('policyid');
    sumInsured = sumInsured.toString().split('::').pop().trim();
    let employeeIds = [];

    $('#insurance_tblPolicyUsers').DataTable().$('input.chkEmp:checked').each(function () {
        employeeIds.push(parseInt($(this).val()));
    });

    if (policyStartDate === '') {
        Swal.fire('Required', 'Please enter policy start date.', 'warning');
        return;
    }

    if (policyPeriod === '') {
        Swal.fire('Required', 'Please enter policy period.', 'warning');
        return;
    }

    if (sumInsured === '') {
        Swal.fire('Required', 'Please select sum insured.', 'warning');
        return;
    }

    if (employeeIds.length === 0) {
        Swal.fire('Required', 'Please select at least one employee.', 'warning');
        return;
    }

    $.ajax({
        url: 'HealthInsurancePolicy.aspx/ApplyPolicyToEmployees',
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify({
            employeeIds: employeeIds,
            policyStartDate: policyStartDate,
            policyPeriod: policyPeriod,
            sumInsured: sumInsured,
            PolicyId: policyId
        }),
        success: function (res) {
            if (res.d > 0) {
                Swal.fire('Saved', 'Policy applied to selected employees.', 'success');

                bindPolicyPeriodDropdown();

                $('a[href="#tab-assign"]').tab('show');
            } else {
                Swal.fire('Error', 'Policy was not applied.', 'error');
            }
        }
    });
}

function bindPolicyAmounts() {
    $.ajax({
        url: 'HealthInsurancePolicy.aspx/GetPolicyAmounts',
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        success: function (res) {
            let data = [];

            if (res && res.d) {
                data = typeof res.d === 'object' ? res.d : JSON.parse(res.d);
            }

            let html = '<option value="">Select</option>';

            data.forEach(function (item) {
                html += `<option value="${item.PolicyTypeAmount}" data-policyid="${item.PolicyId}">
                            ${item.PolicyTypeAmount}
                         </option>`;
            });
            $('#insurance_ddlSumInsuredMain').html(html);
        }
    });
}

function openPolicyForm(employeeId, policyId) {
    selectedEmployeeId = employeeId;
    selectedPolicyId = policyId;

    $('#tabAssignLink').tab('show');

    bindEmployeeInfo(employeeId);
    bindPolicyInfo(employeeId, policyId);
    bindFamilyInfo(employeeId, policyId);
}

function bindEmployeeInfo(employeeId) {
    $.ajax({
        url: 'HealthInsurancePolicy.aspx/GetEmployeeInfo',
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify({ employeeId: employeeId }),
        success: function (res) {
            let data = JSON.parse(res.d)[0];

            $('#insurance_txtEmpCode').val(data.Code);
            $('#insurance_txtEmpName').val(data.EmpName);
            $('#insurance_txtJoiningDate').val(data.JoiningDate);
            $('#insurance_txtBirthDate').val(data.DateOfBirth);
        }
    });
}

function bindPolicyInfo(employeeId, policyId) {

    $.ajax({
        url: 'HealthInsurancePolicy.aspx/GetEmployeePolicyInfo',
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify({
            employeeId: employeeId,
            policyId: policyId
        }),
        success: function (res) {
            let data = JSON.parse(res.d);

            if (data.length === 0) return;

            let p = data[0];
            $('#insurance_ddlPolicyType').val(p.GroupPolicyType);
            $('#insurance_txtSumInsured').val(p.SumInsured);
            $('#insurance_txtApproxPremium').val(p.ApproxPremium);
            $('#insurance_ddlApplicable').val(
                p.IsApplicable ? 'true' : 'false'
            );

            $('#insurance_ddlContriCategory').val(p.ContributionCategory);
            $('#insurance_ddlContriType').val(p.ContributionType);
            $('#insurance_txtPercentage').val(p.PercFixAmount);
            console.log($('#insurance_ddlApplicable').val());
            handleContributionCategory();

            $('#insurance_txtCompContributionMonthly').val(p.CompanyContributionMonthly);
            $('#insurance_txtCompContributionYearly').val(p.CompanyContributionYearly);
            $('#insurance_txtEmployeeApproxPremiumMonthly').val(p.EmpApproxPremiumMonthly);
            $('#insurance_txtEmployeeApproxPremiumYearly').val(p.EmpApproxPremiumYearly);

            $('#insurance_txtPolicyPeriod1').val(p.PolicyPeriod);
            $('#insurance_txtPolicyStartDate').val(convertToHtmlDate(p.PolicyStartDate));
            $('#insurance_txtSumInsured').val(p.SumInsured);
        }
    });
}

function bindFamilyInfo(employeeId, policyId) {
    $('#insurance_tblFamily').DataTable({
        destroy: true,
        processing: true,
        scrollX: true,
        autoWidth: false,
        
        dom: 't',
        ajax: {
            url: 'HealthInsurancePolicy.aspx/GetFamilyInfo',
            type: 'POST',
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            data: function () {
                return JSON.stringify({
                    employeeId: employeeId,
                    policyId: policyId
                });
            },
            dataSrc: function (json) {
                return json && json.d ? JSON.parse(json.d) : [];
            }
        },
        columns: [
            {
                data: null,
                render: function (data, type, row, meta) {
                    return meta.row + 1;
                }
            },
            { data: 'BeneficiaryName' },
            { data: 'Relation' },
            { data: 'BirthDate' },
            { data: 'Age' },
            {
                data: 'ApproxPremium',
                render: function (data) {
                    return `<input type="text" class="form-control form-control-sm fam-premium" value="${data || 0}" />`;
                }
            },
            {
                data: 'CompanyContributionMonthly',
                render: function (data) {
                    return `<input type="text" class="form-control form-control-sm fam-comp-monthly" value="${data || 0}" readonly />`;
                }
            },
            {
                data: 'CompanyContributionYearly',
                render: function (data) {
                    return `<input type="text" class="form-control form-control-sm fam-comp-yearly" value="${data || 0}" readonly />`;
                }
            },
            {
                data: 'EmpApproxPremiumMonthly',
                render: function (data) {
                    return `<input type="text" class="form-control form-control-sm fam-emp-monthly" value="${data || 0}" readonly />`;
                }
            },
            {
                data: 'EmpApproxPremiumYearly',
                render: function (data) {
                    return `<input type="text" class="form-control form-control-sm fam-emp-yearly" value="${data || 0}" readonly />`;
                }
            },
            {
                data: 'GroupPolicyFamilyID',
                render: function (data) {
                    return `<button type="button" class="btn btn-gradient-success btn-sm"
                    onclick="saveFamilyContribution(this, ${data})">Save</button>`;
                }
            },
            {
                data: 'GroupPolicyFamilyID',
                render: function (data) {
                    return `<button type="button" class="btn btn-gradient-danger btn-sm"
                    onclick="deleteFamily(${data})">Delete</button>`;
                }
            }
        ]
    });
}

function calculateFamilyContribution(input) {
    let row = $(input).closest('tr');

    let approxPremium = parseFloat($(input).val().replace(',', '')) || 0;

    let category = $('#insurance_ddlContriCategory').val();
    let contributionType = $('#insurance_ddlContriType').val();
    let percentageOrAmount = parseFloat(($('#insurance_txtPercentage').val()).replace(',', '')) || 0;
    let isApplicable = $('#insurance_ddlApplicable').val();

    let companyYearly = 0;
    let employeeYearly = 0;

    if (isApplicable === 'false' || isApplicable === false) {
        companyYearly = 0;
        employeeYearly = approxPremium;
    }
    else if (category === 'Full') {
        companyYearly = approxPremium;
        employeeYearly = 0;
    }
    else {
        if (contributionType === 'Percentage') {
            companyYearly = (approxPremium * percentageOrAmount) / 100;
            employeeYearly = approxPremium - companyYearly;
        }
        else if (contributionType === 'Fix Amount') {
            companyYearly = percentageOrAmount;
            employeeYearly = approxPremium - companyYearly;
        }
        else {
            companyYearly = 0;
            employeeYearly = approxPremium;
        }
    }

    if (employeeYearly < 0) {
        employeeYearly = 0;
    }

    row.find('.fam-comp-monthly').val((companyYearly / 12).toFixed(2));
    row.find('.fam-comp-yearly').val(companyYearly.toFixed(2));
    row.find('.fam-emp-monthly').val((employeeYearly / 12).toFixed(2));
    row.find('.fam-emp-yearly').val(employeeYearly.toFixed(2));
}

function saveFamilyContribution(btn, familyId) {
    let row = $(btn).closest('tr');

    let obj = {
        familyId: familyId,
        approxPremium: row.find('.fam-premium').val(),
        companyContributionMonthly: row.find('.fam-comp-monthly').val(),
        companyContributionYearly: row.find('.fam-comp-yearly').val(),
        empApproxPremiumMonthly: row.find('.fam-emp-monthly').val(),
        empApproxPremiumYearly: row.find('.fam-emp-yearly').val()
    };

    $.ajax({
        url: 'HealthInsurancePolicy.aspx/UpdateFamilyContribution',
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify(obj),
        success: function (res) {
            if (res.d === 'Success') {
                Swal.fire('Saved', 'Family contribution updated.', 'success');
                bindFamilyInfo(selectedEmployeeId, selectedPolicyId);
            } else {
                Swal.fire('Error', 'Unable to update contribution.', 'error');
            }
        }
    });
}

function addFamilyMember() {
    let obj = {
        employeeId: selectedEmployeeId,
        policyId: selectedPolicyId,
        beneficiaryName: $('#insurance_txtBeneficiaryName').val(),
        relation: $('#insurance_ddlRelation').val(),
        birthDate: $('#insurance_txtFamilyBirthDate').val(),
        age: $('#insurance_txtAge').val(),
        approxPremium: $('#insurance_txtFamilyApproxPremium').val(),
        companyContributionMonthly: $('#insurance_txtCompContributionMonthly').val(),
        companyContributionYearly: $('#insurance_txtCompContributionYearly').val(),
        empApproxPremiumMonthly: $('#insurance_txtEmployeeApproxPremiumMonthly').val(),
        empApproxPremiumYearly: $('#insurance_txtEmployeeApproxPremiumYearly').val()
    };

    $.ajax({
        url: 'HealthInsurancePolicy.aspx/AddFamilyMember',
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify(obj),
        success: function (res) {
            if (res.d > 0) {
                clearFamilyForm();
                bindFamilyInfo(selectedEmployeeId, selectedPolicyId);
                Swal.fire('Saved', 'Family member added successfully.', 'success');
            } else {
                Swal.fire('Error', 'Unable to save family member.', 'error');
            }
        }
    });
}

function convertToHtmlDate(dateStr) {
    if (!dateStr) return '';

    let d = new Date(dateStr);

    if (isNaN(d.getTime())) return '';

    let month = String(d.getMonth() + 1).padStart(2, '0');
    let day = String(d.getDate()).padStart(2, '0');
    let year = d.getFullYear();

    return `${year}-${month}-${day}`;
}

function clearFamilyForm() {
    $('#insurance_txtBeneficiaryName').val('');
    $('#insurance_ddlRelation').val('Select');
    $('#insurance_txtFamilyBirthDate').val('');
    $('#insurance_txtAge').val('');
    $('#insurance_txtFamilyApproxPremium').val('');
}

function core_savePolicyInfo() {
    let obj = {
        policyId: selectedPolicyId,
        employeeId: selectedEmployeeId,
        groupPolicyType: $('#insurance_ddlPolicyType').val(),
        sumInsured: $('#insurance_txtSumInsured').val(),
        approxPremium: $('#insurance_txtApproxPremium').val(),
        companyContributionMonthly: $('#insurance_txtCompContributionMonthly').val(),
        companyContributionYearly: $('#insurance_txtCompContributionYearly').val(),
        empApproxPremiumMonthly: $('#insurance_txtEmployeeApproxPremiumMonthly').val(),
        empApproxPremiumYearly: $('#insurance_txtEmployeeApproxPremiumYearly').val(),
        isApplicable: $('#insurance_ddlApplicable').val(),
        contributionCategory: $('#insurance_ddlContriCategory').val(),
        contributionType: $('#insurance_ddlContriType').val(),
        percFixAmount: $('#insurance_txtPercentage').val(),
        policyStartDate: $('#insurance_txtPolicyStartDate').val(),
        policyPeriod: $('#insurance_txtPolicyPeriod1').val()
    };

    $.ajax({
        url: 'HealthInsurancePolicy.aspx/SavePolicyInfo',
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify(obj),
        success: function (res) {
            if (res.d > 0) {
                Swal.fire('Saved', 'Policy information saved successfully.', 'success');
                bindPolicyUsers();
            } else {
                Swal.fire('Error', 'Unable to save policy.', 'error');
            }
        },
        error: function (xhr) {
            console.log(xhr.responseText);
            Swal.fire('Error', xhr.responseText, 'error');
        }
    });
}

function savePolicyInfo() {

    // Field Validation
    if ($('#insurance_ddlPolicyType').val() === 'Select') {
        toastr.error('Policy Type is required');
        Swal.fire('Required', 'Policy Type is required', 'warning');
        $('#insurance_ddlPolicyType').focus();
        return;
    }

    if (!$('#insurance_txtSumInsured').val()) {
        toastr.error('Sum Insured is required');
        Swal.fire('Required', 'Sum Insured is required', 'warning');
        $('#insurance_txtSumInsured').focus();
        return;
    }

    if (!$('#insurance_txtApproxPremium').val()) {
        toastr.error('Approx Premium is required');
        Swal.fire('Required', 'Approx Premium is required', 'warning');
        $('#insurance_txtApproxPremium').focus();
        return;
    }

    if (!$('#insurance_txtCompContributionMonthly').val()) {
        toastr.error('Company Contribution Monthly is required');
        Swal.fire('Required', 'Company Contribution Monthly is required', 'warning');
        $('#insurance_txtCompContributionMonthly').focus();
        return;
    }

    if (!$('#insurance_txtCompContributionYearly').val()) {
        toastr.error('Company Contribution Yearly is required');
        Swal.fire('Required', 'Company Contribution Yearly is required', 'warning');
        $('#insurance_txtCompContributionYearly').focus();
        return;
    }

    if (!$('#insurance_txtEmployeeApproxPremiumMonthly').val()) {
        toastr.error('Employee Approx Premium Monthly is required');
        Swal.fire('Required', 'Employee Approx Premium Monthly is required', 'warning');
        $('#insurance_txtEmployeeApproxPremiumMonthly').focus();
        return;
    }

    if (!$('#insurance_txtEmployeeApproxPremiumYearly').val()) {
        toastr.error('Employee Approx Premium Yearly is required');
        Swal.fire('Required', 'Employee Approx Premium Yearly is required', 'warning');
        $('#insurance_txtEmployeeApproxPremiumYearly').focus();
        return;
    }

    if ($('#insurance_ddlApplicable').val() === 'Select') {
        toastr.error('Applicable field is required');
        Swal.fire('Required', 'Applicable field is required', 'warning');
        $('#insurance_ddlApplicable').focus();
        return;
    }

    if ($('#insurance_ddlContriCategory').val() === 'Select') {
        toastr.error('Contribution Category is required');
        Swal.fire('Required', 'Contribution Category is required', 'warning');
        $('#insurance_ddlContriCategory').focus();
        return;
    }

    if ($('#insurance_ddlContriType').val() === 'Select') {
        toastr.error('Contribution Type is required');
        Swal.fire('Required', 'Contribution Type is required', 'warning');
        $('#insurance_ddlContriType').focus();
        return;
    }

    if (!$('#insurance_txtPercentage').val()) {
        toastr.error('Percentage / Fixed Amount is required');
        Swal.fire('Required', 'Percentage / Fixed Amount is required', 'warning');
        $('#insurance_txtPercentage').focus();
        return;
    }

    if (!$('#insurance_txtPolicyStartDate').val()) {
        toastr.error('Policy Start Date is required');
        Swal.fire('Required', 'Policy Start Date is required', 'warning');
        $('#insurance_txtPolicyStartDate').focus();
        return;
    }

    if (!$('#insurance_txtPolicyPeriod1').val()) {
        toastr.error('Policy Period is required');
        Swal.fire('Required', 'Policy Period is required', 'warning');
        $('#insurance_txtPolicyPeriod1').focus();
        return;
    }

    let obj = {
        policyId: selectedPolicyId,
        employeeId: selectedEmployeeId,
        groupPolicyType: $('#insurance_ddlPolicyType').val(),
        sumInsured: $('#insurance_txtSumInsured').val(),
        approxPremium: $('#insurance_txtApproxPremium').val(),
        companyContributionMonthly: $('#insurance_txtCompContributionMonthly').val(),
        companyContributionYearly: $('#insurance_txtCompContributionYearly').val(),
        empApproxPremiumMonthly: $('#insurance_txtEmployeeApproxPremiumMonthly').val(),
        empApproxPremiumYearly: $('#insurance_txtEmployeeApproxPremiumYearly').val(),
        isApplicable: $('#insurance_ddlApplicable').val(),
        contributionCategory: $('#insurance_ddlContriCategory').val(),
        contributionType: $('#insurance_ddlContriType').val(),
        percFixAmount: $('#insurance_txtPercentage').val(),
        policyStartDate: $('#insurance_txtPolicyStartDate').val(),
        policyPeriod: $('#insurance_txtPolicyPeriod1').val()
    };

    $.ajax({
        url: 'HealthInsurancePolicy.aspx/SavePolicyInfo',
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify(obj),

        success: function (res) {

            alert(res.d);

            if (res.d > 0) {

                toastr.success('Policy information saved successfully');

                Swal.fire({
                    icon: 'success',
                    title: 'Success',
                    text: 'Policy information saved successfully'
                });

                bindPolicyUsers();

            } else {

                toastr.error('Unable to save policy');

                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'Unable to save policy'
                });
            }
        },

        error: function (xhr) {

            console.log(xhr.responseText);

            toastr.error('Something went wrong');

            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: xhr.responseText
            });
        }
    });
}


function deleteFamily(id) {
    Swal.fire({
        title: 'Are you sure?',
        text: 'This family member will be removed.',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Yes, delete'
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: 'HealthInsurancePolicy.aspx/DeleteFamilyMember',
                type: 'POST',
                contentType: 'application/json; charset=utf-8',
                data: JSON.stringify({ id: id }),
                success: function (res) {
                    if (res.d == "Success") {
                        bindFamilyInfo(selectedEmployeeId, selectedPolicyId);
                        Swal.fire('Deleted', 'Family member deleted.', 'success');
                    }
                }
            });
        }
    });
}


function bindActivePolicies() {
    $('#tblActivePolicies').DataTable({
        destroy: true,
        processing: true,
        ajax: {
            url: 'HealthInsurancePolicy.aspx/GetActivePolicies',
            type: 'POST',
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            dataSrc: function (json) {
                return JSON.parse(json.d);
            }
        },
        columns: [
            {
                data: null,
                render: function (data, type, row, meta) {
                    return meta.row + 1;
                }
            },
            { data: 'Code' },
            { data: 'EmployeeName' },
            { data: 'GroupPolicyType' },
            { data: 'SumInsured' },
            { data: 'ApproxPremium' },
            { data: 'CompanyContributionYearly' },
            { data: 'EmpApproxPremiumYearly' },
            { data: 'PolicyStartDate' },
            { data: 'PolicyPeriod' },
            {
                data: 'IsApproved',
                render: function (data) {
                    return data === true || data === 'True'
                        ? '<span class="badge-active">Approved</span>'
                        : '<span class="badge-pending">Pending</span>';
                }
            },
            {
                data: null,
                render: function (data, type, row) {
                    return `
                        <button type="button" class="btn btn-gradient-primary btn-sm"
                            onclick="openPolicyForm(${row.EmployeeID}, ${row.EmpGroupPolicyID})">
                            Edit
                        </button>
                        <button type="button" class="btn btn-gradient-danger btn-sm"
                            onclick="removePolicy(${row.EmpGroupPolicyID})">
                            Remove
                        </button>`;
                }
            }
        ]
    });
}

function bindDeletedEmployees() {
    $('#tblDeletedEmployees').DataTable({
        destroy: true,
        processing: true,
        ajax: {
            url: 'HealthInsurancePolicy.aspx/GetDeletedEmployees',
            type: 'POST',
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            dataSrc: function (json) {
                return JSON.parse(json.d);
            }
        },
        columns: [
            {
                data: null,
                render: function (data, type, row, meta) {
                    return meta.row + 1;
                }
            },
            { data: 'Code' },
            { data: 'EmployeeName' },
            { data: 'Branch' },
            { data: 'Department' },
            { data: 'Designation' },
            { data: 'GroupPolicyType' },
            { data: 'SumInsured' },
            { data: 'UpdatedDate' },
            { data: 'Reason' },
            {
                data: null,
                render: function () {
                    return '<span class="badge-deleted">Deleted</span>';
                }
            },
            {
                data: 'EmpGroupPolicyID',
                render: function (data) {
                    return `
                        <button type="button" class="btn btn-gradient-success btn-sm"
                            onclick="restorePolicy(${data})">
                            Restore
                        </button>`;
                }
            }
        ]
    });
}

let selectedEmployees = [];

function buildSelectedEmployeeList() {
    let html = '';

    selectedEmployees.forEach(function (emp, index) {
        html += `
            <div class="employee-item ${index === 0 ? 'active' : ''}"
                 onclick="openSelectedEmployee(${index})">
                <b>${emp.Code} - ${emp.EmpName}</b><br/>
                <span class="small-note">${emp.Status}</span>
            </div>`;
    });

    $('#selectedEmployeeList').html(html);
    $('#employeeProgress').text(`0 / ${selectedEmployees.length} Completed`);
}

function openSelectedEmployee(index) {
    $('.employee-item').removeClass('active');
    $('.employee-item').eq(index).addClass('active');

    let emp = selectedEmployees[index];

    openPolicyForm(emp.EmployeeID, emp.EmpGroupPolicyID || 0);

    $('#insurance_txtPolicyPeriod1').val($('#insurance_txtPolicyPeriod').val());
    $('#insurance_txtPolicyStartDate').val($('#insurance_txtPolicyStartDateMain').val());
    $('#insurance_txtSumInsured').val($('#insurance_ddlSumInsured').val());
}
function resetPendingSelection() {
    $('.chkEmp').prop('checked', false);
    $('#chkAll').prop('checked', false);
    selectedEmployees = [];
    updateSelectedCount();
}

function bindPolicyPeriodDropdown() {
    $.ajax({
        url: 'HealthInsurancePolicy.aspx/GetPolicyPeriods',
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        success: function (res) {
            let data = JSON.parse(res.d);

            let html = '<option value="">Select</option>';

            data.forEach(function (item) {
                html += `<option value="${item.PolicyPeriod}">${item.PolicyPeriod}</option>`;
            });

            $('#insurance_ddlPolicyPeriodTab2').html(html);
        }
    });
}

function bindEmployeesByPolicyPeriod() {
    let policyPeriod = $('#insurance_ddlPolicyPeriodTab2').val();

    if (policyPeriod === '') {
        policyEmployees = [];
        currentEmployeeIndex = 0;
        $('#selectedEmployeeList').html('');
        $('#employeeProgress').text('0 / 0 Completed');
        togglePrevNextButtons();
        return;
    }

    $.ajax({
        url: 'HealthInsurancePolicy.aspx/GetEmployeesByPolicyPeriod',
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify({
            policyPeriod: policyPeriod
        }),
        success: function (res) {
            policyEmployees = [];

            if (res && res.d && res.d !== '') {
                policyEmployees = JSON.parse(res.d);
            }

            currentEmployeeIndex = 0;

            bindLeftEmployeeList();

            if (policyEmployees.length > 0) {
                openEmployeeByIndex(0);
            }

            togglePrevNextButtons();
        }
    });
}

function bindLeftEmployeeList() {
    let html = '';

    policyEmployees.forEach(function (emp, index) {
        html += `
            <div class="employee-item ${index === currentEmployeeIndex ? 'active' : ''}"
                 onclick="openEmployeeByIndex(${index})">

                <b>${emp.Code} - ${emp.EmpName}</b><br/>

                <span class="small-note">Sum Insured:</span>
                <span class="small-note">${emp.SumInsured}</span><br/>

                <span class="badge ${emp.isApprovedPolicy == 1 ? 'badge-success' : 'badge-warning'}">
                    ${emp.isApprovedPolicy == 1 ? 'Policy Applied' : 'Pending'}
                </span>

            </div>`;
    });

    $('#selectedEmployeeList').html(html);

    let completed = policyEmployees.filter(x => x.isApprovedPolicy == 1).length;

    $('#employeeProgress').text(`${completed} / ${policyEmployees.length} Completed`);
}

function openEmployeeByIndex(index) {
    if (index < 0 || index >= policyEmployees.length) {
        return;
    }

    currentEmployeeIndex = index;

    bindLeftEmployeeList();

    let emp = policyEmployees[index];

    openPolicyForm(emp.EmployeeID, emp.EmpGroupPolicyID);

    togglePrevNextButtons();
}


function bindEmployeesByPolicyPeriod_OLD() {
    let policyPeriod = $('#insurance_ddlPolicyPeriodTab2').val();

    if (policyPeriod === '') {
        $('#selectedEmployeeList').html('');
        $('#employeeProgress').text('0 / 0 Completed');
        return;
    }

    $.ajax({
        url: 'HealthInsurancePolicy.aspx/GetEmployeesByPolicyPeriod',
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify({
            policyPeriod: policyPeriod
        }),
        success: function (res) {
            if (!res || !res.d || res.d === "") {
                return [];
            }
            let data = JSON.parse(res.d);

            let html = '';

            data.forEach(function (emp, index) {
                html += `
                        <div class="employee-item ${index === 0 ? 'active' : ''}"
                             onclick="selectEmployee(this, ${emp.EmployeeID}, ${emp.EmpGroupPolicyID})">
                            <b>${emp.Code} - ${emp.EmpName}</b><br/>
                            <span class="small-note">Sum Insured:</span>&nbsp;<span class="small-note">${emp.SumInsured}</span>
                            <span class="badge ${emp.isApprovedPolicy == 1 ? 'badge-success' : 'badge-warning'}">${emp.isApprovedPolicy == 1 ? 'Policy Applied' : 'Pending'}</span>
                        </div>`;
            });

            $('#selectedEmployeeList').html(html);
            $('#employeeProgress').text(`0 / ${data.length} Completed`);

            if (data.length > 0) {
                openPolicyForm(data[0].EmployeeID, data[0].EmpGroupPolicyID);
            }
        }
    });
}

function selectEmployee(element, employeeId, policyId) {

    // remove active from all
    $('.employee-item').removeClass('active');

    // add active to selected
    $(element).addClass('active');

    // open employee data
    openPolicyForm(employeeId, policyId);
}

function getAmountDistribution() {
    let approxPremium = $('#insurance_txtApproxPremium').val();
    let sumInsured = $('#insurance_txtSumInsured').val();
    let isApplicable = $('#insurance_ddlApplicable').val();
    console.log($('#insurance_ddlApplicable').val());
    console.log(sumInsured);
    console.log(isApplicable);
    if (isApplicable === '') {
        return;
    }

    if (sumInsured === '') {
        Swal.fire('Required', 'Please enter sum insured.', 'warning');
        return;
    }

    if (approxPremium === '') {
        Swal.fire('Required', 'Please enter approx premium.', 'warning');
        return;
    }

    $.ajax({
        url: 'HealthInsurancePolicy.aspx/getAmountDistribution',
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify({
            Amount: approxPremium.replace(',', ''),
            SumInsured: sumInsured.replace(',', ''),
            IsApplicable: isApplicable
        }),
        success: function (res) {
            bindAmountDistribution(res.d);
        },
        error: function () {
            Swal.fire('Error', 'Unable to calculate contribution.', 'error');
        }
    });
}

function bindAmountDistribution(result) {
    if (result && result !== '') {
        let amount = JSON.parse(result)[0];
        $('#insurance_txtCompContributionMonthly').val(amount.CompContMonthly.replace(',', ''));
        $('#insurance_txtCompContributionYearly').val(amount.CompContYearly.replace(',', ''));
        $('#insurance_txtEmployeeApproxPremiumMonthly').val(amount.EmplPremiumMonthly.replace(',', ''));
        $('#insurance_txtEmployeeApproxPremiumYearly').val(amount.EmplPremiumYearly.replace(',', ''));
        $('#insurance_txtApproxPremium').val(amount.ApproxPremium.replace(',', ''));
        $('#insurance_txtSumInsured').val(amount.SumInsured.replace(',', ''));
    } else {
        clearContributionAmounts();
    }
}

function clearContributionAmounts() {
    $('#insurance_txtCompContributionMonthly').val('');
    $('#insurance_txtCompContributionYearly').val('');
    $('#insurance_txtEmployeeApproxPremiumMonthly').val('');
    $('#insurance_txtEmployeeApproxPremiumYearly').val('');
}

function getAmountDistributionPercentage() {
    let approxPremium = $('#insurance_txtApproxPremium').val().replace(',', '');
    let sumInsured = $('#insurance_txtSumInsured').val().replace(',', '');
    let isApplicable = $('#insurance_ddlApplicable').val();
    let value = $('#insurance_txtPercentage').val();
    let contributionType = $('#insurance_ddlContriType').val();

    if (isApplicable === '') {
        return;
    }

    if (sumInsured === '') {
        Swal.fire('Required', 'Please enter sum insured.', 'warning');
        return;
    }

    if (approxPremium === '') {
        Swal.fire('Required', 'Please enter approx premium.', 'warning');
        return;
    }

    if (value === '') {
        Swal.fire('Required', 'Please enter percentage / fix amount.', 'warning');
        return;
    }

    approxPremium = parseFloat(approxPremium);
    value = parseFloat(value);

    if (isNaN(approxPremium) || isNaN(value)) {
        Swal.fire('Invalid', 'Please enter valid numeric values.', 'warning');
        return;
    }

    let companyYearly = 0;
    let employeeYearly = 0;

    if (contributionType === 'Percentage') {
        companyYearly = (approxPremium * value) / 100;
        employeeYearly = approxPremium - companyYearly;
    }
    else if (contributionType === 'Fix Amount') {
        companyYearly = value;
        employeeYearly = approxPremium - companyYearly;
    }
    else {
        return;
    }

    if (employeeYearly < 0) {
        Swal.fire('Invalid', 'Company contribution cannot be greater than approx premium.', 'warning');
        return;
    }

    $('#insurance_txtCompContributionMonthly').val((companyYearly / 12).toFixed(2));
    $('#insurance_txtCompContributionYearly').val(companyYearly.toFixed(2));
    $('#insurance_txtEmployeeApproxPremiumMonthly').val((employeeYearly / 12).toFixed(2));
    $('#insurance_txtEmployeeApproxPremiumYearly').val(employeeYearly.toFixed(2));
}

function handleContributionCategory() {
    let category = $('#insurance_ddlContriCategory').val();

    if (category === 'Full') {
        $('#insurance_ddlContriType').val('').prop('disabled', true);
        $('#insurance_txtPercentage').val('').prop('disabled', true);

        getAmountDistribution();
    }
    else {
        $('#insurance_ddlContriType').prop('disabled', false);
        $('#insurance_txtPercentage').prop('disabled', false);

        clearContributionAmounts();
    }
}

function insurance_calculateAge() {
    let birthDate = $('#insurance_txtFamilyBirthDate').val();

    if (birthDate === '') {
        $('#insurance_txtAge').val('');
        return;
    }

    $.ajax({
        url: 'HealthInsurancePolicy.aspx/getAge',
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify({
            BirthDate: birthDate
        }),
        success: function (res) {
            var daa = JSON.parse(res.d);

            $('#insurance_txtAge').val(daa[0].Age);
        },
        error: function () {
            Swal.fire('Error', 'Unable to calculate age.', 'error');
        }
    });
}

function bindDashboardSummary() {
    let policyPeriod = $('#insurance_ddlDashboardPolicyPeriod').val();

    $.ajax({
        url: 'HealthInsurancePolicy.aspx/GetDashboardSummary',
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify({
            policyPeriod: policyPeriod
        }),
        success: function (res) {
            let data = [];

            if (res && res.d) {
                data = JSON.parse(res.d);
            }

            if (data.length === 0) return;

            let d = data[0];

            $('#dashTotalEmployees').text(d.TotalEmployees || 0);
            $('#dashFamilyPolicy').text(d.FamilyPolicy || 0);
            $('#dashIndividualPolicy').text(d.IndividualPolicy || 0);
            $('#dashPending').text(d.PendingPolicyInfo || 0);
            $('#dashApplied').text(d.PolicyApplied || 0);
            $('#dashDeleted').text(d.DeletedEmployees || 0);
            $('#dashFamilyMembers').text(d.FamilyMembers || 0);
            $('#dashTotalPremium').text('₹' + (d.TotalApproxPremium || 0));
        }
    });
}

function bindDashboardPolicyPeriodDropdown() {
    $.ajax({
        url: 'HealthInsurancePolicy.aspx/GetPolicyPeriods',
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        success: function (res) {
            let data = [];

            if (res && res.d) {
                data = typeof res.d === 'object' ? res.d : JSON.parse(res.d);
            }

            let html = '<option value="">All Policy Periods</option>';

            data.forEach(function (item) {
                html += `<option value="${item.PolicyPeriod}"> ${item.PolicyPeriod}</option>`;
            });

            $('#insurance_ddlDashboardPolicyPeriod').html(html);
        }
    });
}



/* Assigned Policy */

function assignedpolicy_bindgrid() {

    $('#tblActivePolicies').DataTable({
        destroy: true,
        paging: false,
        processing: true,
        info: true,
        responsive: false, // IMPORTANT
        autoWidth: false,
        fixedHeader: true,

        scrollX: true,
        scrollY: '500px',
        scrollCollapse: true,

        // fixedColumns: {
        //     leftColumns: 3
        // },

        ajax: {
            url: 'HealthInsurancePolicy.aspx/GetApplicableEmployeeForGroupPolicy',
            type: 'POST',
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            dataSrc: function (json) { return JSON.parse(json.d); }
        },

        columns: [
            {
                data: null,
                orderable: false,
                searchable: false,
                render: function (data, type, row, meta) {

                    var username = data.Code + " : " + data.EmpName;

                    return `<a title="Delete Record" class="dropdown-item" href="#!" id="Actions" onclick="delete_policy('${username}','${data.Code}');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-trash"></i></span></a>`;
                }
            },
            {
                data: null,
                render: function (data, type, row, meta) {
                    return meta.row + 1;
                }
            },
            { data: 'Code' },
            { data: 'EmpName' },
            { data: 'DateOfBirth' },
            { data: 'JoiningDate' },
            { data: 'BranchName' },
            { data: 'GroupPolicyType' },
            { data: 'SumInsured' },
            { data: 'ApproxPremium' },
            { data: 'PolicyPeriod' },
            { data: 'PolicyStartDate' }
        ]
    });
}


function delete_policy(username, code) {

    Swal.fire({
        title: 'Confirm Action',
        html: `Do you want to delete the policy of user <br><b>${username}</b>?`,
        icon: 'question',
        allowOutsideClick: false,
        showCancelButton: true,
        confirmButtonText: 'Yes',
        cancelButtonText: 'Cancel',
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33'
    }).then((result) => {

        // Call PageMethod only when user clicks YES
        if (result.isConfirmed) {

            PageMethods.RemoveFromPolicyList(
                code,

                // Success
                function () {

                    Swal.fire({
                        icon: 'success',
                        title: 'Success',
                        text: 'Record deleted successfully.'
                    }).then(() => {

                        assignedpolicy_bindgrid();

                    });
                },

                // Error
                function () {

                    Swal.fire({
                        icon: 'error',
                        title: 'Failed',
                        text: 'Error in deleting record.'
                    });
                }
            );
        }
    });

    return false;
}


/* Deleted Policy */
function deletedpolicy_bindgrid() {

    $('#tblDeletedEmployees').DataTable({
        destroy: true,
        paging: false,
        processing: true,
        info: true,
        responsive: false, // IMPORTANT
        autoWidth: false,
        fixedHeader: true,

        scrollX: true,
        scrollY: '500px',
        scrollCollapse: true,

        ajax: {
            url: 'HealthInsurancePolicy.aspx/GetNotApplicableEmployeeForGroupPolicy',
            type: 'POST',
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            dataSrc: function (json) { return JSON.parse(json.d); }
        },

        columns: [
            {
                data: null,
                render: function (data, type, row, meta) {
                    return meta.row + 1;
                }
            },
            { data: 'Code' },
            { data: 'EmpName' },
            { data: 'DateOfBirth' },
            { data: 'JoiningDate' },
            { data: 'BranchName' }

        ]
    });
}