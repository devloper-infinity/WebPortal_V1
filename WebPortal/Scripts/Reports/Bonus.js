function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

//Master
function bonusentry_bindyear() {
    var start = new Date().getFullYear();

    var select = document.getElementById("bonusentry_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#bonusentry_year").append($("<option></option>").val("0").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#bonusentry_year").append($("<option></option>").val(i).html(i));
    }
}

function bonusentry_bindemployee() {
    var select = document.getElementById("bonusentry_employee");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#bonusentry_employee").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "BonusMaster.aspx/GetAllUsers", dataType: "json", contentType: "application/json",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                $("#bonusentry_employee").append($("<option></option>").val(value.Code).html(value.Code + ' : ' + value.FirstName + ' ' + value.lastName));
            })
        }
    });
}

function bonusentry_addbonus() {
    var ddlemp = document.getElementById("bonusentry_employee");
    var code = ddlemp.options[ddlemp.selectedIndex].value;
    var ddlmonth = document.getElementById("bonusentry_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("bonusentry_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    var amount = document.getElementById("bonusentry_amount").value;
    var remark = document.getElementById("bonusentry_remark").value;
    if (code == "") {
        alert("Please select employee");
        return false;
    }
    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }
    if (amount == "") {
        alert("Please enter amount");
        return false;
    }
    if (remark == "") {
        alert("Please enter remark");
        return false;
    }

    PageMethods.InsertBonus(code, month, year, amount, remark, bonusentry_submit_OnSuccess, bonusentry_submit_OnError);
    return false;
}

function bonusentry_submit_OnSuccess(result) {
    if (result > 0) {
        document.getElementById("bonusentry_errmsg").innerHTML = "Record added successfully!";
        $('#bonusentry_dverror').modal('show');
    }
    else {
        document.getElementById("bonusentry_errmsg").innerHTML = "Record already exists for the selected employee and month-year.!";
        document.getElementById("bonusentry_errmsg").style.color = 'red';
        $('#bonusentry_dverror').modal('show');
        return false;
    }
    return false;
}

function bonusentry_submit_OnError(error) {
    alert(error);
}

function bonusentrye_Message() {
    location.reload();
}

function bonusentrye_bindgrid() {
    $('#load1').show();
    var ddlmonth = document.getElementById("bonusentry_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("bonusentry_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    $.ajax({
        url: "BonusMaster.aspx/GetAllBonusRecords",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: "{Month:'" + month + "', Year:" + year + "}",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//

            $('#bonusentry_table').DataTable({
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
                    { data: 'Month' },
                    { data: 'Year' },
                    { data: 'Amount' },
                    { data: 'Status' },
                    { data: 'Remark' },
                    { data: 'AddedByName' },
                    { data: 'AddedDate1' }
                ],
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                },

                initComplete: function () {
                    $('#load1').hide();
                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Bonus Report', autoFilter: true,
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

//Report
function bonusreport_bindyear() {
    var start = new Date().getFullYear();

    var select = document.getElementById("bonusreport_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#bonusreport_year").append($("<option></option>").val("0").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#bonusreport_year").append($("<option></option>").val(i).html(i));
    }
}

function bonusreport_bindgrid() {
    $('#load1').show();
    var ddlmonth = document.getElementById("bonusreport_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("bonusreport_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    $.ajax({
        url: "BonusMaster.aspx/GetAllBonusRecords",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: "{Month:'" + month + "', Year:" + year + "}",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//

            $('#bonusreport_table').DataTable({
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
                    { data: 'BranchName' },
                    { data: 'Month' },
                    { data: 'Year' },
                    { data: 'Amount' },
                    { data: 'SilverCoin' },
                    { data: 'Type1' },
                    { data: 'Type2' },
                    { data: 'Type3' },
                    { data: 'Status' },
                    { data: 'MachineIP' },
                    { data: 'AddedByName' },
                    { data: 'AddedDate1' }
                ],
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                },

                initComplete: function () {
                    $('#load1').hide();
                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Bonus Report', autoFilter: true,
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