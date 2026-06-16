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