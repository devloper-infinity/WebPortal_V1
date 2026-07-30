function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}
//Monthly Increments
function moninc_bindyear() {
    var start = new Date().getFullYear();

    var select = document.getElementById("moninc_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#moninc_year").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#moninc_year").append($("<option></option>").val(i).html(i));
    }
}

function moninc_bindgrid() {
    $('#load1').show();
    var ddlmonth = document.getElementById("moninc_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("moninc_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    $.ajax({
        url: "IncrementReport.aspx/GetMnthlyIncrements",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: "{Month:'" + month + "', Year:" + year + "}",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//

            $('#moninc_table').DataTable({
                dom: 'lBftip',
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                filter: true,
                'select': {
                    'style': 'single'
                },
                "serverSide": false,
                "data": dataArray,
                columns: [
                    { data: 'Code' },
                    { data: 'FullName' },
                    { data: 'Branch' },
                    { data: 'DepartmentName' },
                    { data: 'DesignationName' },
                    { data: 'DomainName' },
                    { data: 'JoiningDate' },
                    { data: 'LastMonth' },
                    { data: 'CurrentMonthYear' },
                    { data: 'BeforeSalary' },
                    { data: 'CurrentSalary' },
                    { data: 'Difference' },
                    { data: 'IncrementPercentage' },
                    { data: 'NextDueMonthYear' },
                    { data: 'RetentionBonus' },
                    { data: 'RetentionBonusPeriod1' },
                    { data: 'RetentionBonusMonth1' },
                    { data: 'RetentionBonusYear1' },
                    { data: 'Status' },
                    { data: 'Remark' },
                    { data: 'AddedByName' },
                    { data: 'AddedDate1' },
                    { data: 'AddedIP' }
                ],
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                },

                initComplete: function () {
                    $('#load1').hide();
                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Total Salary Report', autoFilter: true,
                    },
                ],
            });

        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });


    return false;
}

//Increment Difference
function monincdiff_bindyear() {
    var start = new Date().getFullYear();

    var select = document.getElementById("monincdiff_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#monincdiff_year").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#monincdiff_year").append($("<option></option>").val(i).html(i));
    }
}

function monincdiff_bindgrid() {
    $('#load1').show();
    var ddlmonth = document.getElementById("monincdiff_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("monincdiff_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    $.ajax({
        url: "IncrementReport.aspx/GetAllIncrementDifference",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: "{Month:'" + month + "', Year:" + year + "}",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//

            $('#monincdiff_table').DataTable({
                dom: 'lBftip',
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                filter: true,
                'select': {
                    'style': 'single'
                },
                "serverSide": false,
                "data": dataArray,
                columns: [
                    { data: 'Code' },
                    { data: 'NAME' },
                    { data: 'Branch' },
                    { data: 'Department' },
                    { data: 'DomainName' },
                    { data: 'BankName' },
                    { data: 'AccountNumber' },
                    { data: 'IFSCCode' },
                    { data: 'Salary' },
                    { data: 'Percentage' },
                    { data: 'LastIncMonth' },
                    { data: 'NextIncrementDue' },
                    { data: 'MONTH' },
                    { data: 'YEAR' },
                    { data: 'TotalDays' },
                    { data: 'ActualDifference' },
                    { data: 'DaywiseDifference' },
                    { data: 'DifferenceTotal' }
                ],
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                },

                initComplete: function () {
                    $('#load1').hide();
                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Total Salary Report', autoFilter: true,
                    },
                ],
            });

        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });


    return false;
}

function getattendancebounusattributes(ddl) {
    var istrue = ddl.options[ddl.selectedIndex].value;
    if (istrue == "Yes") {
        document.getElementById("incentry_attbonustype").style.display = 'inline';
        document.getElementById("incentry_attbonus").style.display = 'inline';
        document.getElementById("incentry_attbonusamount").style.display = 'inline';
    }
    else {
        document.getElementById("incentry_attbonustype").style.display = 'none';
        document.getElementById("incentry_attbonus").style.display = 'none';
        document.getElementById("incentry_attbonusamount").style.display = 'none';
    }
    return false;
}

function incentry_getattbonusamount() {
    var ddlatttype = document.getElementById("incentry_attbonustype");
    var type = ddlatttype.options[ddlatttype.selectedIndex].value;
    var attamount = document.getElementById("incentry_attbonus").value;
    var incrementedsalary = document.getElementById("incentry_incrementedsalary").value;

    if (type == "Percentage") {
        var perc = (parseInt(attamount) * parseInt(incrementedsalary)) / 100;
        document.getElementById("incentry_attbonusamount").innerHTML = '(' + perc + ')';
        document.getElementById("incentry_attbonusamount").style.fontWeight = 'bold';
    }
    else if (type == "Fix Amount") {
        document.getElementById("incentry_attbonusamount").innerHTML = '(' + attamount + ')';
        document.getElementById("incentry_attbonusamount").style.fontWeight = 'bold';
    }
}

function incentry_bindretentionperiod() {
    var start = 1;

    var select = document.getElementById("incentry_retentionperiod");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i++;) {
        select.removeChild(options[i]);
    }

    $("#incentry_retentionperiod").append($("<option></option>").val("").html("Select"));
    for (var i = start; i <= 40; i++) {
        if (i == 1)
            $("#incentry_retentionperiod").append($("<option></option>").val(i + " Month").html(i + " Month"));
        else
            $("#incentry_retentionperiod").append($("<option></option>").val(i + " Months").html(i + " Months"));
    }
}

function incentry_bindretentionyear() {
    var start = new Date().getFullYear();

    var select = document.getElementById("incentry_retentionyear");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#incentry_retentionyear").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#incentry_retentionyear").append($("<option></option>").val(i).html(i));
    }
}

function incentry_bindeffectiveyear() {
    var start = new Date().getFullYear();

    var select = document.getElementById("incentry_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#incentry_year").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#incentry_year").append($("<option></option>").val(i).html(i));
    }
}
function incentry_bindnextdueyear() {
    var start = new Date().getFullYear() + 2;

    var select = document.getElementById("incentry_nextincyear");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#incentry_nextincyear").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#incentry_nextincyear").append($("<option></option>").val(i).html(i));
    }
}

function getretentionattributes(ddl) {
    var isretention = ddl.options[ddl.selectedIndex].value;

    if (isretention == "Yes") {
        document.getElementById("incentry_retentionamount").style.display = 'inline';
        document.getElementById("incentry_retentionperiod").style.display = 'inline';
        document.getElementById("incentry_retentionmonth").style.display = 'inline';
        document.getElementById("incentry_retentionyear").style.display = 'inline';
        document.getElementById("retamt").style.display = 'inline';
        document.getElementById("retprd").style.display = 'inline';
        document.getElementById("retmth").style.display = 'inline';
        document.getElementById("retyer").style.display = 'inline';
    }
    else {
        document.getElementById("incentry_retentionamount").style.display = 'none';
        document.getElementById("incentry_retentionperiod").style.display = 'none';
        document.getElementById("incentry_retentionmonth").style.display = 'none';
        document.getElementById("incentry_retentionyear").style.display = 'none';
        document.getElementById("retamt").style.display = 'none';
        document.getElementById("retprd").style.display = 'none';
        document.getElementById("retmth").style.display = 'none';
        document.getElementById("retyer").style.display = 'none';
    }
}

function incentry_bindemployee() {
    var select = document.getElementById("incentry_employee");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#incentry_employee").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "IncrementReport.aspx/GetAllCodes", dataType: "json", contentType: "application/json",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                $("#incentry_employee").append($("<option></option>").val(value.Code).html(value.Code + ' : ' + value.Name));
            })
        }
    });
}

function incentry_getempinfo(ddl) {
    var code = ddl.options[ddl.selectedIndex].value;

    $.ajax({
        type: "POST", url: "IncrementReport.aspx/GetUserInfo", dataType: "json", contentType: "application/json", data: "{Code:'" + code + "'}",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                document.getElementById("incentry_empname").innerHTML = blankForNull(value.FullName);
                document.getElementById("incentry_joiningdate").innerHTML = blankForNull(value.JoiningDate);
                document.getElementById("incentry_branch").innerHTML = blankForNull(value.WorkingBranchName);
                document.getElementById("incentry_dept").innerHTML = blankForNull(value.DepartmentName);
                document.getElementById("incentry_desg").innerHTML = blankForNull(value.DesignationName);
                document.getElementById("incentry_salary").innerHTML = blankForNull(value.Salary);
            })
        }
    });
}

function incentry_submit() {
    var ddlcode = document.getElementById("incentry_employee");
    var code = ddlcode.options[ddlcode.selectedIndex].value;
    var ddleffmonth = document.getElementById("incentry_month");
    var effmonth = ddleffmonth.options[ddleffmonth.selectedIndex].value;
    var ddleffyear = document.getElementById("incentry_year");
    var effyear = ddleffyear.options[ddleffyear.selectedIndex].value;
    var currentsalary = document.getElementById("incentry_salary").innerHTML;
    var incrementedamount = document.getElementById("incentry_incrementedsalary").value;
    var remark = document.getElementById("incentry_remark").value;
    var ddlattbonus = document.getElementById("incentry_isattbonus");
    var isattbonus = ddlattbonus.options[ddlattbonus.selectedIndex].value;
    var attbonusamount = document.getElementById("incentry_attbonusamount").innerHTML.replace("(", "").replace(")", "");
    if (attbonusamount == "")
        attbonusamount = 0;
    var ddlretbonus = document.getElementById("incentry_isretention");
    var retbonus = ddlretbonus.options[ddlretbonus.selectedIndex].value;
    var retbonusamount = document.getElementById("incentry_retentionamount").value;
    if (retbonusamount == "")
        retbonusamount = 0;
    var ddlretperiod = document.getElementById("incentry_retentionperiod");
    var retperiod = ddlretperiod.options[ddlretperiod.selectedIndex].value;
    var ddlretmonth = document.getElementById("incentry_retentionmonth");
    var retmonth = ddlretmonth.options[ddlretmonth.selectedIndex].value;
    var ddretyear = document.getElementById("incentry_retentionyear");
    var retyear = ddretyear.options[ddretyear.selectedIndex].value;
    var ddlnextduemonth = document.getElementById("incentry_nextincmonth");
    var nextduemonth = ddlnextduemonth.options[ddlnextduemonth.selectedIndex].value;
    var ddlnextdueyear = document.getElementById("incentry_nextincyear");
    var nextdueyear = ddlnextdueyear.options[ddlnextdueyear.selectedIndex].value;
    $("#waitingpanel").modal('show');

    PageMethods.InsertIncrement(code, effmonth, effyear, currentsalary, incrementedamount, remark, isattbonus, attbonusamount, retbonus, retbonusamount, retperiod, retmonth, retyear, nextduemonth, nextdueyear, incentry_submit_OnSuccess, incentry_submit_OnError);
    return false;
}


function incentry_submit_OnSuccess(result) {
    $("#waitingpanel").modal('hide');
    if (result > 0) {
        document.getElementById("increport_errmsg").innerHTML = "Increment added successfully!";
        $("#increport_dverror").modal("show");
    }
    else {
        document.getElementById("increport_errmsg").innerHTML = "Error occured while adding increment. Please contact administrator!";
        document.getElementById("increport_errmsg").style.color = 'red';
        $('#increport_dverror').modal('show');
        return false;
    }
    return false;
}

function incentry_submit_OnError(error) {
    alert(error.get_message());
}

// Increment Approval
function bindincrementapproval() {
    $('#load1').show();

    $.ajax({
        url: "IncrementReport.aspx/GetIncrementApprovalList",
        type: "POST",
        data: "{}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (response) {
            var approvalData = JSON.parse(response.d || "[]");

            $('#incapr_tblIncrementApproval').DataTable({
                destroy: true,
                data: approvalData,
                paging: false,
                searching: true,
                ordering: false,
                processing: true,
                autoWidth: false,
                scrollX: true,
                columns: [
                    {
                        data: 'IncrementID',
                        searchable: false,
                        render: function (data, type) {
                            if (type !== 'display') {
                                return data;
                            }

                            return '<input type="checkbox" class="incapr_rowCheck" value="' + data + '" />';
                        }
                    },
                    {
                        data: null,
                        searchable: false,
                        render: function (data, type, row, meta) {
                            return meta.row + 1;
                        }
                    },
                    { data: 'Code', defaultContent: '' },
                    { data: 'FullName', defaultContent: '' },
                    { data: 'BeforeSalary', defaultContent: '' },
                    { data: 'CurrentSalary', defaultContent: '' },
                    { data: 'Difference', defaultContent: '' },
                    { data: 'AttendanceBonus', defaultContent: '' },
                    { data: 'QualityBonus', defaultContent: '' },
                    { data: 'Month', defaultContent: '' },
                    { data: 'Year', defaultContent: '' },
                    { data: 'Percentage', defaultContent: '' },
                    { data: 'Remark', defaultContent: '' },
                    { data: 'NextDueMonth', defaultContent: '' },
                    { data: 'NextDueYear', defaultContent: '' },
                    { data: 'RetentionBonus', defaultContent: '' },
                    { data: 'RetentionBonusPeriod1', defaultContent: '' },
                    { data: 'RetentionBonusMonth1', defaultContent: '' },
                    { data: 'RetentionBonusYear1', defaultContent: '' },
                    { data: 'AddedByName', defaultContent: '' },
                    {
                        data: 'AddedDate',
                        defaultContent: '',
                        render: function (data, type) {
                            if (!data || type !== 'display') {
                                return data || '';
                            }

                            var match = /\/Date\((\d+)\)\//.exec(data);
                            return match ? new Date(parseInt(match[1], 10)).toLocaleString() : data;
                        }
                    }
                ],
                fnCreatedRow: function (row) {
                    $(row).children("td").css("white-space", "nowrap");
                },
                drawCallback: function () {
                    $('#incapr_chkAll').prop('checked', false);
                }
            });

            $('#incapr_chkAll').prop('checked', false);
        },
        error: function (xhr) {
            Swal.fire({
                icon: 'error',
                title: 'Unable to load increments',
                text: xhr.responseJSON && xhr.responseJSON.Message
                    ? xhr.responseJSON.Message
                    : 'Please try again or contact the administrator.'
            });
        },
        complete: function () {
            $('#load1').hide();
        }
    });
}

$(document)
    .off('change.incrementApproval', '#incapr_chkAll')
    .on('change.incrementApproval', '#incapr_chkAll', function () {
        $('.incapr_rowCheck').prop('checked', this.checked);
    })
    .off('change.incrementApproval', '.incapr_rowCheck')
    .on('change.incrementApproval', '.incapr_rowCheck', function () {
        var rowCheckboxes = $('.incapr_rowCheck');
        var checkedRows = rowCheckboxes.filter(':checked');

        $('#incapr_chkAll').prop(
            'checked',
            rowCheckboxes.length > 0 && rowCheckboxes.length === checkedRows.length
        );
    })
    .off('shown.bs.tab.incrementApproval', '#custom-tabs-one-profile-tab-approval')
    .on('shown.bs.tab.incrementApproval', '#custom-tabs-one-profile-tab-approval', function () {
        if ($.fn.DataTable.isDataTable('#incapr_tblIncrementApproval')) {
            $('#incapr_tblIncrementApproval').DataTable().columns.adjust().draw(false);
        }
    });

function approveincrements() {
    var table = $('#incapr_tblIncrementApproval').DataTable();
    var increments = [];

    $('.incapr_rowCheck:checked').each(function () {
        var rowData = table.row($(this).closest('tr')).data();

        if (rowData) {
            increments.push({
                IncrementID: parseInt(rowData.IncrementID, 10),
                CurrentSalary: String(rowData.CurrentSalary == null ? '' : rowData.CurrentSalary)
            });
        }
    });

    if (increments.length === 0) {
        Swal.fire({
            icon: 'warning',
            title: 'No employee selected',
            text: 'Please select at least one increment to approve.'
        });
        return false;
    }

    Swal.fire({
        icon: 'question',
        title: 'Approve selected increments?',
        text: increments.length + ' increment(s) will be approved.',
        showCancelButton: true,
        confirmButtonText: 'Approve',
        cancelButtonText: 'Cancel',
        confirmButtonColor: '#28a745'
    }).then(function (result) {
        if (!result.isConfirmed) {
            return;
        }

        $('#load1').show();
        $('#incapr_btnSubmit').prop('disabled', true);

        $.ajax({
            url: "IncrementReport.aspx/ApproveIncrements",
            type: "POST",
            data: JSON.stringify({ increments: increments }),
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (response) {
                var resultData = response.d;

                if (resultData && resultData.Status === 1) {
                    Swal.fire({
                        icon: 'success',
                        title: 'Approved',
                        text: resultData.Message
                    }).then(function () {
                        bindincrementapproval();
                    });
                }
                else {
                    Swal.fire({
                        icon: 'error',
                        title: 'Approval failed',
                        text: resultData && resultData.Message
                            ? resultData.Message
                            : 'The selected increments could not be approved.'
                    });
                }
            },
            error: function (xhr) {
                Swal.fire({
                    icon: 'error',
                    title: 'Approval failed',
                    text: xhr.responseJSON && xhr.responseJSON.Message
                        ? xhr.responseJSON.Message
                        : 'Please try again or contact the administrator.'
                });
            },
            complete: function () {
                $('#load1').hide();
                $('#incapr_btnSubmit').prop('disabled', false);
            }
        });
    });

    return false;
}

var inchistLoaded = false;

function inchist_bindfilters() {
    var currentYear = new Date().getFullYear();
    var fromYear = $('#inchist_fromyear');
    var toYear = $('#inchist_toyear');

    fromYear.empty().append($('<option></option>').val(0).text('All'));
    toYear.empty().append($('<option></option>').val(0).text('All'));

    for (var year = currentYear + 1; year >= 2000; year--) {
        fromYear.append($('<option></option>').val(year).text(year));
        toYear.append($('<option></option>').val(year).text(year));
    }

    $.ajax({
        type: "POST",
        url: "IncrementReport.aspx/GetAllCodes",
        data: "{}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (response) {
            var employees = JSON.parse(response.d || "[]");
            var codeSelect = $('#inchist_code');

            codeSelect.empty().append($('<option></option>').val('').text('All Employees'));

            $.each(employees, function (index, employee) {
                codeSelect.append(
                    $('<option></option>')
                        .val(employee.Code)
                        .text(employee.Code + ' : ' + employee.Name)
                );
            });
        }
    });
}

function inchist_formatdate(value) {
    if (!value) {
        return '';
    }

    var aspNetDate = /\/Date\((\d+)\)\//.exec(value);
    var dateValue = aspNetDate ? new Date(parseInt(aspNetDate[1], 10)) : new Date(value);

    return isNaN(dateValue.getTime()) ? value : dateValue.toLocaleString();
}

function inchist_validatefilters() {
    var fromDate = $('#inchist_fromdate').val();
    var toDate = $('#inchist_todate').val();
    var fromMonth = parseInt($('#inchist_frommonth').val(), 10) || 0;
    var fromYear = parseInt($('#inchist_fromyear').val(), 10) || 0;
    var toMonth = parseInt($('#inchist_tomonth').val(), 10) || 0;
    var toYear = parseInt($('#inchist_toyear').val(), 10) || 0;
    var message = '';

    if (fromDate && toDate && fromDate > toDate) {
        message = 'Added From Date cannot be later than Added To Date.';
    }
    else if (fromMonth > 0 && fromYear === 0) {
        message = 'Please select an Effective From Year.';
    }
    else if (toMonth > 0 && toYear === 0) {
        message = 'Please select an Effective To Year.';
    }
    else if (fromYear > 0 && toYear > 0) {
        var fromKey = (fromYear * 100) + (fromMonth || 1);
        var toKey = (toYear * 100) + (toMonth || 12);

        if (fromKey > toKey) {
            message = 'Effective From Month-Year cannot be later than Effective To Month-Year.';
        }
    }

    if (message) {
        Swal.fire({
            icon: 'warning',
            title: 'Invalid filter range',
            text: message
        });
        return false;
    }

    return true;
}

function inchist_bindgrid() {
    if (!inchist_validatefilters()) {
        return false;
    }

    var filters = {
        Code: $('#inchist_code').val() || '',
        FromDate: $('#inchist_fromdate').val() || '',
        ToDate: $('#inchist_todate').val() || '',
        FromMonth: parseInt($('#inchist_frommonth').val(), 10) || 0,
        FromYear: parseInt($('#inchist_fromyear').val(), 10) || 0,
        ToMonth: parseInt($('#inchist_tomonth').val(), 10) || 0,
        ToYear: parseInt($('#inchist_toyear').val(), 10) || 0,
        Status: $('#inchist_status').val() || ''
    };

    $('#load1').show();
    $('#inchist_btnShow').prop('disabled', true);

    $.ajax({
        url: "IncrementReport.aspx/GetIncrementHistory",
        type: "POST",
        data: JSON.stringify(filters),
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (response) {
            var historyData = JSON.parse(response.d || "[]");

            $('#inchist_tblIncrementHistory').DataTable({
                destroy: true,
                data: historyData,
                dom: 'lBfrtip',
                paging: true,
                pageLength: 25,
                searching: true,
                ordering: false,
                processing: true,
                autoWidth: false,
                scrollX: true,
                columns: [
                    {
                        data: null,
                        searchable: false,
                        render: function (data, type, row, meta) {
                            return meta.row + meta.settings._iDisplayStart + 1;
                        }
                    },
                    { data: 'Code', defaultContent: '' },
                    { data: 'FullName', defaultContent: '' },
                    { data: 'BeforeSalary', defaultContent: '' },
                    { data: 'CurrentSalary', defaultContent: '' },
                    { data: 'Difference', defaultContent: '' },
                    { data: 'AttendanceBonus', defaultContent: '' },
                    { data: 'QualityBonus', defaultContent: '' },
                    { data: 'Month', defaultContent: '' },
                    { data: 'Year', defaultContent: '' },
                    { data: 'Percentage', defaultContent: '' },
                    { data: 'Remark', defaultContent: '' },
                    { data: 'NextDueMonth', defaultContent: '' },
                    { data: 'NextDueYear', defaultContent: '' },
                    { data: 'RetentionBonus', defaultContent: '' },
                    { data: 'RetentionBonusPeriod1', defaultContent: '' },
                    { data: 'RetentionBonusMonth1', defaultContent: '' },
                    { data: 'RetentionBonusYear1', defaultContent: '' },
                    { data: 'AddedByName', defaultContent: '' },
                    {
                        data: 'AddedDate',
                        defaultContent: '',
                        render: function (data, type) {
                            return type === 'display' ? inchist_formatdate(data) : (data || '');
                        }
                    },
                    { data: 'ApprovalStatus', defaultContent: '' },
                    { data: 'ApprovedByName', defaultContent: '' },
                    {
                        data: 'ApprovedDate',
                        defaultContent: '',
                        render: function (data, type) {
                            return type === 'display' ? inchist_formatdate(data) : (data || '');
                        }
                    }
                ],
                fnCreatedRow: function (row) {
                    $(row).children('td').css('white-space', 'nowrap');
                },
                buttons: [
                    {
                        extend: 'excelHtml5',
                        title: 'Increment History',
                        autoFilter: true
                    }
                ],
                initComplete: function () {
                    var historyTable = this.api();

                    $('.inchist-code-column-filter')
                        .off('.incrementHistoryColumn')
                        .on('click.incrementHistoryColumn', function (event) {
                            event.stopPropagation();
                        })
                        .on('keyup.incrementHistoryColumn change.incrementHistoryColumn', function () {
                            var filterValue = this.value;
                            $('.inchist-code-column-filter').not(this).val(filterValue);

                            if (historyTable.column(1).search() !== filterValue) {
                                historyTable.column(1).search(filterValue).draw();
                            }
                        });

                    $('.inchist-name-column-filter')
                        .off('.incrementHistoryColumn')
                        .on('click.incrementHistoryColumn', function (event) {
                            event.stopPropagation();
                        })
                        .on('keyup.incrementHistoryColumn change.incrementHistoryColumn', function () {
                            var filterValue = this.value;
                            $('.inchist-name-column-filter').not(this).val(filterValue);

                            if (historyTable.column(2).search() !== filterValue) {
                                historyTable.column(2).search(filterValue).draw();
                            }
                        });

                    historyTable.columns.adjust();
                }
            });

            inchistLoaded = true;
        },
        error: function (xhr) {
            Swal.fire({
                icon: 'error',
                title: 'Unable to load increment history',
                text: xhr.responseJSON && xhr.responseJSON.Message
                    ? xhr.responseJSON.Message
                    : 'Please try again or contact the administrator.'
            });
        },
        complete: function () {
            $('#load1').hide();
            $('#inchist_btnShow').prop('disabled', false);
        }
    });

    return false;
}

function inchist_resetfilters() {
    $('#inchist_code').val('');
    $('#inchist_fromdate').val('');
    $('#inchist_todate').val('');
    $('#inchist_frommonth').val('0');
    $('#inchist_fromyear').val('0');
    $('#inchist_tomonth').val('0');
    $('#inchist_toyear').val('0');
    $('#inchist_status').val('');
    $('.inchist-code-column-filter').val('');
    $('.inchist-name-column-filter').val('');

    if ($.fn.DataTable.isDataTable('#inchist_tblIncrementHistory')) {
        $('#inchist_tblIncrementHistory').DataTable()
            .column(1).search('')
            .column(2).search('');
    }

    return inchist_bindgrid();
}

$(document)
    .off('shown.bs.tab.incrementHistory', '#custom-tabs-one-history-tab')
    .on('shown.bs.tab.incrementHistory', '#custom-tabs-one-history-tab', function () {
        if (!inchistLoaded) {
            inchist_bindgrid();
        }
        else if ($.fn.DataTable.isDataTable('#inchist_tblIncrementHistory')) {
            $('#inchist_tblIncrementHistory').DataTable().columns.adjust().draw(false);
        }
    });
