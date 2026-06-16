
var approveTicket_html;
var addticket_html;

var ticketHistory_table;
var ticketHistory_html;

var TicketId = 0;

/*------------------- Add New Ticket -------------------*/

function addticket_bindgrid() {
    $('#load1').show();
    $.ajax({
        url: "AddTicket.aspx/GetAllRequests",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            addticket_table = $('#addticket_table').DataTable({
                dom: 'Bftip',
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
                    { data: 'TicketId' },
                    { data: 'RequestId' },
                    { data: '' },
                    { data: 'TicketNo' },
                    { data: 'Request' },
                    { data: 'RequestDateTime' },
                    { data: 'DepartmentName' },
                    { data: 'Subject' },
                    { data: 'Description' },
                    { data: 'NextState' },

                ],
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "wrap");
                },
                columnDefs: [
                    {
                        targets: 0, visible: false,
                    },
                    {
                        targets: 1, visible: false,
                    },
                    {
                        targets: 2,
                        "width": "45px",
                        render: function (data, type, row, meta) {

                            return '<div class="btn-group"><div type="button" data-toggle="dropdown" aria-expanded="false"><i style="color: dodgerblue; font-size:14px;" class="uil fs-0 me-2 uil-cog"></i></div > <div class="dropdown-menu" role="menu" style="">' +
                                '<a class="dropdown-item" href="#!" id="Actions" onclick="viewTicket(\'' + row.TicketId + '\',' + meta.row + ');"><span style="color: dodgerblue;"><i class="uil-search-alt"></i></span>&nbsp;&nbsp;View</a>' +
                                '<a class="dropdown-item" href="#!" id="Actions" onclick="reOpen(\'' + row.TicketId + '\',' + meta.row + ');"><span style="color: orange;"><i class="uil-edit"></i></span>&nbsp;&nbsp;Re-Open</a>' +
                                '<a class="dropdown-item" href="#!" id="Actions" onclick="closureRemark(\'' + row.TicketId + '\',' + meta.row + ');"><span style="color: forestgreen;"><i class="uil-comment-edit"></i></span>&nbsp;&nbsp;Closure Remark</a></div ></div >';
                        },
                    },
                    {
                        targets: 1,
                        "visible": false,
                    }
                ],

                initComplete: function () {
                    $('#load1').hide();

                },

                buttons: [
                    {
                        extend: 'excelHtml5', title: 'All Requests', autoFilter: true,
                    },
                ],

            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    $('#addticket_table thead tr:eq(1) th').each(function () {
        var title = $(this).text();
        $(this).html('<input type="text" style="border-color:#e3e3e3; border-radius:5px;" class="column_search" />');
    });

    $('#addticket_table thead').on('keyup', ".column_search", function () {

        it_ticketqueue
            .column($(this).parent().index())
            .search(this.value)
            .draw();
    });
    return false;
}


/*Add Ticket*/
function addticket_submit() {

    var ddlrequest = document.getElementById("addticket_requestrelatedto");
    var request = ddlrequest.options[ddlrequest.selectedIndex].value;

    var ddldepartment = document.getElementById("addticket_department");
    var department = ddldepartment.options[ddldepartment.selectedIndex].value;

    var ddlonbehalf = document.getElementById("addticket_onbehalf");
    var onbehalf = ddlonbehalf.options[ddlonbehalf.selectedIndex].value;

    var subject = document.getElementById("addticket_subject").value;

    var deskno = document.getElementById("addticket_deskno").value;
    var desription = document.getElementById("addticket_description").value;
    var ddldays = document.getElementById("addticket_days");
    var days = ddldays.options[ddldays.selectedIndex].value;
    var ddlhours = document.getElementById("addticket_hours");
    var hours = ddlhours.options[ddlhours.selectedIndex].value;
    var ddlminutes = document.getElementById("addticket_minutes");
    var minutes = ddlminutes.options[ddlminutes.selectedIndex].value;

    if (request == "") {
        alert("Please select Request Related To.");
        document.getElementById("addticket_requestrelatedto").focus();
        return false;
    }
    if (subject == "") {
        alert("Please enter Subject.");
        document.getElementById("addticket_subject").focus();
        return false;
    }
    if (deskno == "") {
        alert("Please enter Desk No.");
        document.getElementById("addticket_deskno").focus();
        return false;
    }
    if (desription == "") {
        alert("Please enter Description.");
        document.getElementById("addticket_description").focus();
        return false;
    }
    if (days == "") {
        alert("Please select Days From Expected TAT.");
        document.getElementById("addticket_days").focus();
        return false;
    }
    if (hours == "") {
        alert("Please select Hours From Expected TAT.");
        document.getElementById("addticket_hours").focus();
        return false;
    }
    if (minutes == "") {

        alert("Please select Minutes From Expected TAT.");
        document.getElementById("addticket_minutes").focus();
        return false;
    }
    $('#waitingpanelAddTicket').modal('show');

    PageMethods.InsertTicket(deskno, subject, desription, onbehalf, request, department, days, hours, minutes, addticket_OnSuccess, addticket_OnError);
    return false;
}

function addticket_OnSuccess(result) {
    if (result > 0) {
        $('#waitingpanelAddTicket').modal('hide');
        document.getElementById("addticket_errmsg").innerHTML = "Ticket raised successfully!";
        $('#addticket_dverror').modal('show');
        return false;
    }
    else {
        document.getElementById("addticket_errmsg").innerHTML = "Oops! Error occured while raising ticket. Please contact administrator!";
        document.getElementById("addticket_errmsg").style.color = 'red';
        $('#addticket_dverror').modal('show');
        return false;
    }
}

function addticket_OnError(error) {
    alert(error.responseText);
}


/*Update*/
function viewTicket(id, index) {

    var row = addticket_table.row(index).data();
    TicketId = id;

    document.getElementById("addTicket_viewLabel").innerHTML = "Add New Remark : " + row['TicketNo'] + " - " + row['Subject'] + " - " + row['Status'];

    if (row['Status'] == "Open")
        document.getElementById("updateTicket_TATlabel").innerHTML = "<b>Expected TAT : </b>";
    else
        document.getElementById("updateTicket_TATlabel").innerHTML = "<b>TAT : </b>";


    bind_TicketHistory(id);

    $('#addTicket_view').modal('show');
    return false;
}

function bind_TicketHistory(ticketID) {

    // ticketID = 36181;

    $('#load1').show();

    $.ajax({
        url: "AddTicket.aspx/GetAllRemarkTicketwise",
        type: "POST",
        dataType: "json",
        data: "{TicketID:" + ticketID + "}",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            ticketHistory_table = $('#table_ticketHistory').DataTable({
                dom: 't',
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
                    { data: 'SrNo' },
                    { data: 'TicketNo' },
                    { data: 'Remark' },
                    { data: 'NextState' },
                    { data: 'RemarkAddedBy' },
                    { data: 'AddedDate' }
                ],
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                },
                initComplete: function () {
                    $('#load1').hide();
                },
            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}

function btnaddTicket_newRemark() {

    var Remark = document.getElementById("updateTicket_Description").value;
    var ddlStatus = document.getElementById("updateTicket_Status");
    var Status = ddlStatus.options[ddlStatus.selectedIndex].value;
    var ddldays = document.getElementById("updateTicket_days");
    var Days = ddldays.options[ddldays.selectedIndex].value;
    var ddlHours = document.getElementById("updateTicket_hours");
    var Hours = ddlHours.options[ddlHours.selectedIndex].value;
    var ddlMin = document.getElementById("updateTicket_minutes");
    var Minutes = ddlMin.options[ddlMin.selectedIndex].value;

    if (Status == "Select") {
        alert("Please select Status.");
        document.getElementById("updateTicket_Status").focus();
        return false;
    }
    if (Remark == "") {
        alert("Please enter Remark.");
        document.getElementById("updateTicket_Description").focus();
        return false;
    }
    if (Days == "Select") {
        alert("Please select Days.");
        document.getElementById("updateTicket_days").focus();
        return false;
    }
    if (Hours == "Select") {
        alert("Please select Hours.");
        document.getElementById("updateTicket_hours").focus();
        return false;
    }
    if (Minutes == "Select") {
        alert("Please select Mintues.");
        document.getElementById("updateTicket_minutes").focus();
        return false;
    }

    PageMethods.InsertRemark(TicketId, Remark, Status, Days, Hours, Minutes, closure_OnSuccess, closure_OnError);
    return false;
}


/*Reopen*/
function reOpen(id, index) {

    var row = addticket_table.row(index).data();
    TicketId = id;

    document.getElementById("addTicket_reOpenLabel").innerHTML = "Reopen : " + row['Subject'];
    document.getElementById("addTicket_reOpenStatus").value = row['Status'];
    document.getElementById("addTicket_reOpenRemark").value = row['TicketNo'] + " : " + row['Request'] + " : " + row['Subject'];

    if (row['Status'] == "Open") {
        document.getElementById("addTicket_reOpenMsg").style.display = '';
        document.getElementById("addTicket_reOpenMsg").innerHTML = " * This ticket is currently open and therefore cannot be reopened.";
        btnReopenTicket.disabled = true;
        btnReopenTicket.textContent = 'Already Open';
    }
    else {
        document.getElementById("addTicket_reOpenMsg").style.display = 'none';
        document.getElementById("addTicket_reOpenMsg").innerHTML = "";
        btnReopenTicket.disabled = false;
        btnReopenTicket.textContent = 'Re-Open';
    }

    $('#addTicket_reOpen').modal('show');
    return false;
}

function btnaddTicket_reOpen() {

    var Status = document.getElementById("addTicket_reOpenStatus").value;;
    var Remark = document.getElementById("addTicket_reOpenRemark").value;

    if (Status == "") {
        alert("Please enter Status.");
        document.getElementById("addTicket_reOpenStatus").focus();
        return false;
    }
    if (Remark == "") {
        alert("Please enter Remark.");
        document.getElementById("addTicket_reOpenRemark").focus();
        return false;
    }

    PageMethods.ReOpenTicket(TicketId, Status, Remark, reOpen_OnSuccess, reOpen_OnError);
    return false;
}

function reOpen_OnSuccess(result) {
    if (result > 0) {
        document.getElementById("addticket_errmsg").innerHTML = "Ticket re-open successfully!";
        $('#addticket_dverror').modal('show');
        return false;
    }
    else {
        document.getElementById("addticket_errmsg").innerHTML = "Oops! Error occured while re-opeining ticket. Please contact administrator!";
        document.getElementById("addticket_errmsg").style.color = 'red';
        $('#addticket_dverror').modal('show');
        return false;
    }
}

function reOpen_OnError(error) {
    alert(error.responseText);
}


/*Close*/
function closureRemark(id, index) {

    var row = addticket_table.row(index).data();
    TicketId = id;

    document.getElementById("addTicket_closureLabel").innerHTML = "Closure Remark : " + row['Subject'];
    document.getElementById("addTicket_closureStatus").value = row['Status'];

    $('#addTicket_closure').modal('show');
    return false;
}

function btnaddTicket_closure() {

    var Status = document.getElementById("addTicket_closureStatus").value;;
    var Remark = document.getElementById("addTicket_closureRemark").value;

    if (Status == "") {
        alert("Please enter Status.");
        document.getElementById("addTicket_closureStatus").focus();
        return false;
    }
    if (Remark == "") {
        alert("Please enter Remark.");
        document.getElementById("addTicket_closureRemark").focus();
        return false;
    }

    PageMethods.UpdateClosureRemark(TicketId, Remark, closure_OnSuccess, closure_OnError);
    return false;
}

function closure_OnSuccess(result) {
    if (result > 0) {
        document.getElementById("addticket_errmsg").innerHTML = "Remark saved successfully!";
        $('#addticket_dverror').modal('show');
        return false;
    }
    else {
        document.getElementById("addticket_errmsg").innerHTML = "Oops! Error occured while saving remark. Please contact administrator!";
        document.getElementById("addticket_errmsg").style.color = 'red';
        $('#addticket_dverror').modal('show');
        return false;
    }
}

function closure_OnError(error) {
    alert(error.responseText);
}


/*bind dropdown*/
function getrequestdepartment(ddlrequest) {
    var requestid = ddlrequest.options[ddlrequest.selectedIndex].value;
    $.ajax({
        type: "POST", url: "AddTicket.aspx/GetDepartmentForRequest", dataType: "json", contentType: "application/json",
        data: "{RequestID:" + requestid + "}",

        success: function (res1) {
            var dataArray = JSON.parse(res1.d);
            $.each(dataArray, function (data1, value1) {
                var select = document.getElementById("addticket_department");
                var options = select.getElementsByTagName('option');

                for (var i = options.length; i--;) {
                    select.removeChild(options[i]);
                }


                $.ajax({
                    type: "POST", url: "AddTicket.aspx/GetDepartment", dataType: "json", contentType: "application/json",
                    success: function (res) {
                        $.each(res.d, function (data, value) {
                            $("#addticket_department").append($("<option></option>").val(value.DepartmentID).html(value.DepartmentName));
                        })
                        $("#addticket_department").val(value1.DepartmentID);
                        //document.getElementById("addticket_department").value = value1.DepartmentID;
                    }

                });
                document.getElementById("addticket_department").disabled = true;
            })
        }

    });

}

function addticket_Binddays() {

    var select = document.getElementById("addticket_days");
    let options = select.getElementsByTagName('option');

    var U_select = document.getElementById("updateTicket_days");
    let U_options = U_select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    for (var i = U_options.length; i--;) {
        select.removeChild(U_options[i]);
    }

    $("#addticket_days").append($("<option></option>").val("").html("Select"));
    $("#updateTicket_days").append($("<option></option>").val("").html("Select"));

    for (var i = 0; i < 31; i++) {
        $("#addticket_days").append($("<option></option>").val(i).html(i));
        $("#updateTicket_days").append($("<option></option>").val(i).html(i));
    }
}

function addticket_Bindhours() {
    var select = document.getElementById("addticket_hours");
    let options = select.getElementsByTagName('option');

    var U_select = document.getElementById("updateTicket_hours");
    let U_options = U_select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    for (var i = U_options.length; i--;) {
        select.removeChild(U_options[i]);
    }

    $("#updateTicket_hours").append($("<option></option>").val("").html("Select"));
    $("#addticket_hours").append($("<option></option>").val("").html("Select"));

    for (var i = 0; i < 12; i++) {
        $("#addticket_hours").append($("<option></option>").val(i).html(i));
        $("#updateTicket_hours").append($("<option></option>").val(i).html(i));
    }
}

function addticket_Bindminutes() {

    var select = document.getElementById("addticket_minutes");
    let options = select.getElementsByTagName('option');

    var U_select = document.getElementById("updateTicket_minutes");
    let U_options = U_select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    for (var i = U_options.length; i--;) {
        select.removeChild(U_options[i]);
    }

    $("#addticket_minutes").append($("<option></option>").val("").html("Select"));
    $("#updateTicket_minutes").append($("<option></option>").val("").html("Select"));

    for (var i = 0; i < 60; i++) {
        $("#addticket_minutes").append($("<option></option>").val(i).html(i));
        $("#updateTicket_minutes").append($("<option></option>").val(i).html(i));
    }
}

function addticket_bindrequestonbehalf() {
    var select = document.getElementById("addticket_onbehalf");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#addticket_onbehalf").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "AddTicket.aspx/GetRequestOnBehalf", dataType: "json", contentType: "application/json; charset=utf-8",

        success: function (res) {
            var dataArray = JSON.parse(res.d);//

            if (dataArray.length > 0) {
                $.each(dataArray, function (index, value) {
                    $("#addticket_onbehalf").append($("<option></option>").val(value.EMPID).html(value.Code + ' : ' + value.NAME));
                })
            }
            else {
                document.getElementById("addticket_onbehalf").disabled = true;
            }
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
}

function addticket_bindrequestrelatedto() {
    var select = document.getElementById("addticket_requestrelatedto");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#addticket_requestrelatedto").append($("<option></option>").val("").html("Select"));
    $("#addticket_department").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "AddTicket.aspx/GetRequestRelatedTo", dataType: "json", contentType: "application/json; charset=utf-8",
        success: function (res) {
            var dataArray = JSON.parse(res.d);//
            $.each(dataArray, function (index, value) {
                $("#addticket_requestrelatedto").append($("<option></option>").val(value.RequestId).html(value.Request));
            })
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
}


/*------------------- Ticket Approval -------------------*/

var AppticketHistory_table;
var approveTicket_table;
var approveTicket_html;
var approve_TicketId = 0;
var approveRejectStatus = '';

function approve_BindGrid() {

    $('#load1').show();

    approveTicket_html = '';

    $.ajax({
        url: "TicketApproval.aspx/GetAllTicketForApproval",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            $.each(dataArray, function (index, value) {

                approveTicket_html += '<tr>';

                //approveTicket_html += '<td class=""><div class="btn-group">';
                //approveTicket_html += '<div class="btn-group">';
                //approveTicket_html += '<div type="button" data-toggle="dropdown" aria-expanded="false"><i style="color: dodgerblue; font-size:14px;" class="uil fs-0 me-2 uil-cog"></i>';
                //approveTicket_html += '<span class="sr-only"></span></div><div class="dropdown-menu" role="menu" style="">';
                //approveTicket_html += '<a class="dropdown-item" href="#!" id="Actions" onclick="approveViewTicket(\'' + value.TicketId + '\',' + index + ');"><span style="color: dodgerblue;"><i class="uil-search-alt"></i></span>&nbsp;&nbsp;View</a>';
                //approveTicket_html += '<a class="dropdown-item" href="#!" id="Actions" onclick="ApproveTicket(\'' + value.TicketId + '\',' + index + ');"><span style="color: forestgreen;"><i class="uil-edit"></i></span>&nbsp;&nbsp;Approve/Reject</a><div class="dropdown-divider"></div></div></div></td>';
                //approveTicket_html += '<td class=""><span></span></td >';

                approveTicket_html += '<td style="text-align:center;"><a class="dropdown-item" href="#!" id="ac_Approve" onclick="ApproveTicket(' + value.TicketId + ',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-pen"></i></span>&nbsp;&nbsp;Approve/Reject</a></td>';
                approveTicket_html += '<td style="display: none;">' + blankForNull(value.TicketId) + '</td>';
                approveTicket_html += '<td>' + blankForNull(value.TicketNo) + '</td>';
                approveTicket_html += '<td>' + blankForNull(value.RequestByName) + '</td>';
                approveTicket_html += '<td>' + blankForNull(value.RequestDateTime1) + '</td>';
                approveTicket_html += '<td>' + blankForNull(value.DepartmentName) + '</td>';
                approveTicket_html += '<td>' + blankForNull(value.Subject) + '</td>';
                approveTicket_html += '<td>' + blankForNull(value.RequestType) + '</td>';
                approveTicket_html += '<td>' + blankForNull(value.Severity) + '</td>';
                approveTicket_html += '<td>' + blankForNull(value.Priority) + '</td>';
                approveTicket_html += '<td>' + blankForNull(value.ApprovalStatus) + '</td>';
                approveTicket_html += '<td>' + blankForNull(value.ApprovedByName) + '</td>';
                approveTicket_html += '<td>' + blankForNull(value.ApprovedDate1) + '</td>';
                approveTicket_html += '<td>' + blankForNull(value.Status) + '</td>';
                approveTicket_html += '<td>' + blankForNull(value.NewRemark) + '</td>';
                approveTicket_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#table_approveTicket')) {
                approveTicket_table.destroy();
            }

            $('#table_approveTicket tbody').html(approveTicket_html);

            approveTicket_table = $('#table_approveTicket').DataTable({
                dom: 'ftip',
                scrollX: true,
                destroy: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                processing: true,
                'select': {
                    'style': 'single'
                },

                initComplete: function () {
                    /* jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');*/
                    $('#load1').hide();
                },
            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });

    return false;
}

function ApproveTicket(id, index) {

    var row = approveTicket_table.row(index).data();
    approve_TicketId = id;

    document.getElementById("approveTicket_popUpLabel").innerHTML = "Approve/Reject : " + row[6];
    appTicketRemarkHistoryGrid_Bind(id);
    $('#approveTicket_popUp').modal('show');
    return false;
}

function btnApproveTicket() {

    var ddlappStatus = document.getElementById("approveTicket_Status");
    var appStatus = ddlappStatus.options[ddlappStatus.selectedIndex].value;

    var ddlappRqType = document.getElementById("approveTicket_RqType");
    var appRqType = ddlappRqType.options[ddlappRqType.selectedIndex].value;

    var ddlappSeverity = document.getElementById("approveTicket_Severity");
    var appSeverity = ddlappSeverity.options[ddlappSeverity.selectedIndex].value;

    var ddlappPriority = document.getElementById("approveTicket_Priority");
    var appPriority = ddlappPriority.options[ddlappPriority.selectedIndex].value;

    var appRemark = document.getElementById("approveTicket_Remark").value;

    approveRejectStatus = appStatus;

    if (appStatus == "") {
        alert("Please select Status.");
        document.getElementById("approveTicket_Status").focus();
        return false;
    }
    if (appRqType == "") {
        alert("Please select Request Type.");
        document.getElementById("approveTicket_RqType").focus();
        return false;
    }
    if (appSeverity == "") {
        alert("Please select Severity.");
        document.getElementById("approveTicket_Severity").focus();
        return false;
    }
    if (appPriority == "") {
        alert("Please select Priority.");
        document.getElementById("approveTicket_Priority").focus();
        return false;
    }
    if (appRemark == "") {
        alert("Please enter Remark.");
        document.getElementById("addticket_subject").focus();
        return false;
    }

    var Status;

    if (appStatus == "Approve")
        Status = true;
    else
        Status = false;

    $('#waitingpanelAppTicket').modal('show');

    PageMethods.InsertTicketApproval(approve_TicketId, Status, appRqType, appSeverity, appPriority, appRemark, appticket_OnSuccess, appticket_OnError);
    return false;
}

function appticket_OnSuccess(result) {
    $('#waitingpanelAppTicket').modal('hide');

    var NewStatus;

    if (approveRejectStatus == "Approve")
        NewStatus = "approv";
    else if (approveRejectStatus == "Reject")
        NewStatus = "reject";

    if (result > 0) {
        alert("Ticket " + NewStatus + "ed successfully.");
        return false;
    }
    else {
        alert("Oops! Error occured while  " + NewStatus + "ing ticket. Please contact administrator");
        return false;
    }

    $('#approveTicket_popUp').modal('hide');
}

function appticket_OnError(error) {
    alert(error.responseText);
}

function appTicketRemarkHistoryGrid_Bind(ticketID) {
    $('#load1').show();
    $.ajax({
        url: "TicketApproval.aspx/GetTicketForApprval",
        type: "POST",
        dataType: "json",
        data: "{TicketID:" + ticketID + "}",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            AppticketHistory_table = $('#table_AppticketHistory').DataTable({
                dom: 'ti',
                destroy: true,
                // orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                "paging": false,
                "autoWidth": true,
                select: true,
                // "ordering": false,
                processing: true,
                filter: true,
                'select': {
                    'style': 'single'
                },
                "serverSide": false,
                "data": dataArray,
                columns: [
                    { data: 'TicketNo' },
                    { data: 'Subject' },
                    { data: 'Description' },
                    { data: 'RequestType' },
                    { data: 'RequestDateTime1' },
                    { data: 'DepartmentName' },
                    { data: 'NextState' },
                    { data: 'Severity' },
                    { data: 'Priority' },
                    { data: 'ApprovalStatus' },
                    { data: 'ApprovedBy' },
                    { data: 'ApprovedDate1' },
                ],

                initComplete: function () {
                    $('#load1').hide();
                },
            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });

    return false;
}

