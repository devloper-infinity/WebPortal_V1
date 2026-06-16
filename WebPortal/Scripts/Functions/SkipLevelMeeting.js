var reporthtml;
var skip_table;
var skiplevel_gradingtable;
var skiplevel_historytable;
var skiplevel_reporttable;
var html;
var prehtml;
var skip_meetingid;
var finalreturnid;

function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

function skip_BindYear() {
    var start = new Date().getFullYear();

    var select = document.getElementById("skip_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#skip_year").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#skip_year").append($("<option></option>").val(i).html(i));
    }
}

function skip_BindYearReport() {
    var start = new Date().getFullYear();

    var select = document.getElementById("skip_yearreport");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#skip_yearreport").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#skip_yearreport").append($("<option></option>").val(i).html(i));
    }
}

function skip_bindusers() {
    var select = document.getElementById("skip_employee");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#skip_employee").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "SkipLevelMeeting.aspx/GetAllEmployees", dataType: "json", contentType: "application/json",
        success: function (res1) {
            var dataArray = JSON.parse(res1.d);
            $.each(dataArray, function (data1, value1) {
                $("#skip_employee").append($("<option></option>").val(value1.EmployeeID).html(value1.FullName));
            });
        }
    });
}

function skip_getempdetails(ddlemp, currentUserName) {
    var EmployeeID = ddlemp.options[ddlemp.selectedIndex].value;
    var ddlquarter = document.getElementById("skip_quarter");
    ddlquarter.selectedIndex = 0;
    document.getElementById("skip_date").value = '';

    $.ajax({
        type: "POST", url: "SkipLevelMeeting.aspx/GetUserName", dataType: "json", contentType: "application/json",
        data: "{EmployeeID:" + EmployeeID + "}",
        success: function (res1) {
            var dataArray = JSON.parse(res1.d);
            $.each(dataArray, function (data1, value1) {
                document.getElementById("skip_branch").innerHTML = value1.WorkingBranchName;
                document.getElementById("skip_department").innerHTML = value1.DepartmentName;
                document.getElementById("skip_designation").innerHTML = value1.DesignationName;
                document.getElementById("skip_reportingmanager").innerHTML = value1.ReportingManager;
                document.getElementById("skip_incrementperc").innerHTML = value1.IncPerc;
                document.getElementById("skip_incrementamount").innerHTML = value1.IncAmount;
                document.getElementById("skip_incrementmonthyear").innerHTML = value1.IncMonthYear;
                document.getElementById("skip_nextincrementdue").innerHTML = value1.NextMonthYear;

                if (currentUserName == 8938 || currentUserName == 8082) {
                    document.getElementById("inc1").style.display = '';
                    document.getElementById("inc2").style.display = '';
                }
                else {
                    document.getElementById("inc1").style.display = 'none';
                    document.getElementById("inc2").style.display = 'none';
                }

            });
        }
    });
}

function getlastfourGrading() {
    $('#load1').show();
    html = '';
    var ddlcode = document.getElementById("skip_employee");
    var skip_employee = ddlcode.options[ddlcode.selectedIndex].value;
    if (skip_employee == '') {
        alert("Please select code first");
        $('#load1').hide();
        document.getElementById("skip_year").selectedIndex = 0;
        document.getElementById("skip_quarter").selectedIndex = 0;
        return;
    }
    var Year = ''
    var ddlyear = document.getElementById("skip_year");
    var skip_year = ddlyear.options[ddlyear.selectedIndex].value;
    if (skip_year == '') {
        alert("Please select year");
        $('#load1').hide();
        document.getElementById("skip_quarter").selectedIndex = 0;
        return;
    }
    var Quarter = ''
    var ddlquarter = document.getElementById("skip_quarter");
    var skip_quarter = ddlquarter.options[ddlquarter.selectedIndex].value;

    var Code = ''
    var ddlcode = document.getElementById("skip_employee");
    var skip_employee = ddlcode.options[ddlcode.selectedIndex].text;
    Code = skip_employee.substring(0, 3);
    if (skip_quarter != "") {
        $.ajax({
            url: "SkipLevelMeeting.aspx/GetLastFourGrading",
            type: "POST",
            data: "{Quarter:'" + skip_quarter + "', Year:'" + skip_year + "', Code:'" + Code + "'}",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (data) {
                var dataArray = JSON.parse(data.d);//
                $.each(dataArray, function (index, value) {

                    html += '<tr>';
                    html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.Quarter) + '</td>';
                    html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.ProdGrade) + '</td>';
                    html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.QualGrade) + '</td>';
                    html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.AttGrade) + '</td>';
                    html += '</tr>';


                });

                if ($.fn.dataTable.isDataTable('#skiplevel_gradingtable')) {
                    skiplevel_gradingtable.destroy();
                }
                $('#skiplevel_gradingtable tbody').html(html);
                //else
                skiplevel_gradingtable = $('#skiplevel_gradingtable').DataTable({
                    dom: 't',
                    scrollX: true,
                    destroy: true,
                    "paging": true,
                    "autoWidth": true,
                    select: true,
                    "ordering": false,
                    processing: true,
                    'select': {
                        'style': 'single'
                    },

                    initComplete: function () {
                        $('#load1').hide();
                    },
                    "rowCallback": function (row, data) {
                        var val = data[3];
                    },

                    buttons: [
                        {
                            extend: 'excelHtml5', title: 'New Joinee HR Follow up', autoFilter: true,
                            exportOptions: {
                                columns: [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
                            }
                        },
                    ],
                });

                //$('#fnalize tbody').on('click', 'tr', function () {
                //    row = table.row(this).data();
                //});
            },
            error: function (error) {
                alert('error; ' + eval(error));
                alert('error; ' + error.responseText);
            }
        });
    }
    else {
        $('#load1').hide();

    }
    getskipremarkhistory();
    return false;
}

function getskipremarkhistory() {
    var Code = ''
    var ddlcode = document.getElementById("skip_employee");
    var skip_employee = ddlcode.options[ddlcode.selectedIndex].value;
    $('#load1').show();
    prehtml = '';
    $.ajax({
        url: "SkipLevelMeeting.aspx/GetPreviousSkipRemarks",
        type: "POST",
        data: "{EmployeeID:" + skip_employee + "}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {

                prehtml += '<tr>';
                prehtml += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.Date) + '</td>';
                prehtml += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.Quarter) + '</td>';
                prehtml += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.Year) + '</td>';
                prehtml += '<td>' + blankForNull(value.Remark) + '</td>';
                prehtml += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.AddedByName) + '</td>';
                prehtml += '</tr>';


            });

            if ($.fn.dataTable.isDataTable('#skiplevel_historytable')) {
                skiplevel_historytable.destroy();
            }
            $('#skiplevel_historytable tbody').html(prehtml);
            //else
            skiplevel_historytable = $('#skiplevel_historytable').DataTable({
                dom: 'tp',
                scrollX: true,
                destroy: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "pageLength": 5,
                "ordering": false,
                processing: true,
                'select': {
                    'style': 'single'
                },

                initComplete: function () {
                    $('#load1').hide();
                },
                "rowCallback": function (row, data) {
                    var val = data[3];
                },

            });

            //$('#fnalize tbody').on('click', 'tr', function () {
            //    row = table.row(this).data();
            //});
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });

    return false;
}

function skip_SubmitInfo() {
    var ddlquarter = document.getElementById("skip_quarter");
    var skip_quarter = ddlquarter.options[ddlquarter.selectedIndex].value;
    var ddlyear = document.getElementById("skip_year");
    var skip_year = ddlyear.options[ddlyear.selectedIndex].value;
    var ddlcode = document.getElementById("skip_employee");
    var skip_employee = ddlcode.options[ddlcode.selectedIndex].value;
    var skip_date = document.getElementById("skip_date").value;
    var skip_remark = document.getElementById("skip_remark").value;
    var ddlstatus = document.getElementById("skip_status");
    var skip_status = ddlstatus.options[ddlstatus.selectedIndex].value;

    if (skip_employee == "") {
        alert("Please select Employee");
        document.getElementById("skip_employee").focus();
        return false;
    }
    if (skip_date == "") {
        alert("Please select Date");
        document.getElementById("skip_date").focus();
        return false;
    }
    if (skip_year == "") {
        alert("Please select Year");
        document.getElementById("skip_year").focus();
        return false;
    }
    if (skip_quarter == "") {
        alert("Please select Quarter");
        document.getElementById("skip_quarter").focus();
        return false;
    }

    if (skip_status == "") {
        alert("Please select appropriate status");
        document.getElementById("skip_status").focus();
        return false;
    }
    if (skip_remark == "") {
        alert("Please enter Remark");
        document.getElementById("skip_remark").focus();
        return false;
    }

    PageMethods.InsertSkipLevelMeeting(skip_employee, skip_date, skip_remark, skip_quarter, skip_year, skip_status, skip_OnSuccess, skip_OnError);
    return false;
}

function skip_OnSuccess(result) {
    if (result > 0) {
        //alert("Remark added successfully. Please proceed to add comments.");
        //skip_meetingid = result;
        //document.getElementById("skip_dvcomments").style.display = '';
        //document.getElementById("skip_type").focus();

        $('#waitingpanel').modal('hide');
        document.getElementById("skip_errmsg").innerHTML = "Record added Successfully!";
        $('#skip_dverror').modal('show');

        //$('#waitingpanel').modal('hide');
        //document.getElementById("errmsg").innerHTML = "Data Saved Successfully!";
        //$('#dverror').modal('show');
        //alert('Email sent successfully!');
    }
    else {
        $('#waitingpanel').modal('hide');
        document.getElementById("skip_errmsg").innerHTML = "Record already exists for selected employee, quarter and year. Please confirm.";
        document.getElementById("skip_errmsg").style.color = 'red';
        $('#skip_dverror').modal('show');
        //alert('Oops! Error occured while sending email. Please contact administrator!');
        return false;
    }
    //location.reload();
    return false;
}
function skip_OnError(error) {
    alert(error);
}

function skip_Addremark() {
    var ddltype = document.getElementById("skip_type");
    var skip_type = ddltype.options[ddltype.selectedIndex].value;
    var skip_description = document.getElementById("skip_description").value;

    if (skip_type == "") {
        alert("Please select type");
        return false;
    }
    if (skip_description == "") {
        alert("Please enter description");
        return false;
    }
    var skip_listitem = skip_type + ' ~ ' + skip_description;
    $("#skip_comments").append($("<option></option>").val(skip_listitem).html(skip_listitem));
    ddltype.selectedIndex = 0;
    document.getElementById("skip_description").value = '';
    return false;
}

function skip_finalsubmit() {
    $('#waitingpanel').modal('show');
    var returnvalue = 0;
    var meetingid = skip_meetingid;
    var ddlcode = document.getElementById("skip_employee");
    var skip_employee = ddlcode.options[ddlcode.selectedIndex].value;
    var select = document.getElementById("skip_comments");
    let options = select.getElementsByTagName('option');
    var SkipDetails = new Array();
    if (options.length <= 0) {
        $('#waitingpanel').modal('hide');
        document.getElementById("skip_errmsg").innerHTML = "Record added Successfully!";
        $('#skip_dverror').modal('show');
    }
    else {
        for (var i = options.length; i--;) {
            SkipDetails.push(options[i].value);
        }
        PageMethods.InsertSkipLevelDetails(meetingid, skip_employee, SkipDetails, detail_OnSuccess, details_OnError)
    }
    return false;
}

function detail_OnSuccess(result) {
    if (result > 0) {
        $('#waitingpanel').modal('hide');
        document.getElementById("skip_errmsg").innerHTML = "Record added Successfully!";
        $('#skip_dverror').modal('show');
    }
    else {
        $('#waitingpanel').modal('hide');
        document.getElementById("skip_errmsg").innerHTML = "Oops! Error occured while adding record. Please contact administrator!";
        document.getElementById("skip_errmsg").style.color = 'red';
        $('#skip_dverror').modal('show');
    }
}
function details_OnError(error) {
}

function skip_Message() {
    location.reload();
}

function skiplevel_SubmitReport() {
    document.getElementById("skiplevel_btnShow").disabled = true;
    var ddlquarter = document.getElementById("skip_quarterreport");
    var month = ddlquarter.options[ddlquarter.selectedIndex].value;
    var ddlyear = document.getElementById("skip_yearreport");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    if (month == "") {
        alert("Please select quarter");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }
    $('#load1').show();
    reporthtml = '';
    $.ajax({
        url: "SkipLevelMeeting.aspx/GetSummaryReport",
        type: "POST",
        data: "{Quarter:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                reporthtml += '<tr>';
                reporthtml += '<td style="text-wrap: nowrap;">' + blankForNull(value.Branch) + '</td>';
                reporthtml += '<td style="text-align:center;">' + blankForNull(value.Total) + '</td>';
                reporthtml += '<td style="text-align:center;">' + blankForNull(value.ActualContacted) + '</td>';
                reporthtml += '<td style="text-align:center;">' + blankForNull(value.DiscussionCompleted) + '</td>';
                reporthtml += '<td style="text-align:center; display:none;">' + blankForNull(value.NeedToContactAgain) + '</td>';
                reporthtml += '<td style="text-align:center;">' + blankForNull(value.Absconding) + '</td>';
                reporthtml += '<td style="text-align:center;">' + blankForNull(value.Pending) + '</td>';
                reporthtml += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#skiplevel_reporttable')) {
                skiplevel_reporttable.destroy();
            }
            $('#skiplevel_reporttable tbody').html(reporthtml);
            //else
            skiplevel_reporttable = $('#skiplevel_reporttable').DataTable({
                dom: 'lBftip',
                scrollX: true,
                destroy: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                'select': {
                    'style': 'single'
                },

                initComplete: function () {
                    $('#load1').hide();
                    document.getElementById("skiplevel_btnShow").disabled = false;
                },
                "rowCallback": function (row, data) {
                    // Cell at index 5 in the row is 'Active'.
                },

                buttons: [

                    {
                        extend: 'excelHtml5', title: 'Skip Level Meeting Report', autoFilter: true,
                        exportOptions: {
                            columns: [0, 1, 2, 3, 4, 5, 6]
                        }

                    },

                ],

            });

            //$('#fnalize tbody').on('click', 'tr', function () {
            //    row = table.row(this).data();
            //});
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}


