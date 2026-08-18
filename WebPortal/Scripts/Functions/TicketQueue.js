
/*var remark_TicketID = 0;*/
var ticketRemarkHistory_table;
var it_ticketqueue;
var dept = 0;
var remark_TicketID = 0;
var file_TickeID = 0;
var file_Path;


/*----------------- Ticket Queue  -----------------*/

var empList = [];

function assignEmployee() {

    $.ajax({
        url: "TicketQueue.aspx/GetEmpsByDept",
        type: "POST",
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        success: function (res) {

            empList = []; // reset

            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (data, value) {

                empList.push({
                    EmployeeID: value.EmployeeID,
                    EmpName: value.EmpName
                });
            })
        }
    });

}

function it_tq_bindgrid_1() {

    assignEmployee();

    $('#load1').show();

    $.ajax({
        url: "TicketQueue.aspx/GetAllTickets",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = JSON.parse(data.d);

            it_ticketqueue = $('#it_ticketqueue').DataTable({
                dom: 'Bftip',
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                paging: true,
                autoWidth: true,
                ordering: false,
                processing: true,
                filter: true,
                serverSide: false,
                select: { style: 'single' },
                data: dataArray,

                columns: [
                    { data: '' },          // Actions
                    { data: 'TicketId' },  // Hidden
                    { data: null },        // 👈 DROPDOWN
                    { data: null },
                    { data: 'TicketNo' },
                    { data: 'RequestDateTime' },
                    { data: 'ExpectedTAT' },
                    { data: 'Code' },
                    { data: 'WorkingBranch' },
                    { data: 'Request' },
                    { data: 'Priority' },
                    { data: 'Subject' },
                    /*  { data: 'AssignName' },*/
                    { data: 'TET' }
                ],

                columnDefs: [
                    {
                        targets: 0,
                        width: "45px",
                        render: function (data, type, row, meta) {
                            return '<a href="#!" onclick="ticketQueue_EditTicket(\'' + meta.row + '\')">' +
                                '<i class="uil fs-0 me-2 uil-pen" style="color:dodgerblue;"></i></a>';
                        }
                    },
                    {
                        targets: 1,
                        visible: false
                    },
                    {
                        targets: 2,
                        width: "300px",
                        render: function (data, type, row) {

                            var isDisabled = row.AssignTo > 0 ? 'disabled' : '';

                            var ddl = `<select class="form-control emp-dd" 
                            style="width:150px;"
                            id="ddl_${row.TicketId}" ${isDisabled}>
                        <option value="">Select Employee</option>`;

                            $.each(empList, function (i, emp) {

                                // 👇 set selected value
                                var selected = (emp.EmployeeID == row.AssignTo) ? 'selected' : '';

                                ddl += `<option value="${emp.EmployeeID}" ${selected}>
                        ${emp.EmpName}
                    </option>`;
                            });

                            ddl += `</select>`;

                            return ddl;
                        }
                    },
                    {
                        targets: 3,
                        render: function (data, type, row) {

                            var isDisabledbtn = row.AssignTo && row.AssignTo > 0 ? 'disabled' : '';
                            var isAssigned = row.AssignTo && row.AssignTo > 0;
                            var btnLabel = isAssigned ? 'Assigned' : 'Assign';

                            var btn = `<button type="button" class="btn btn-primary" 
                            ${isDisabledbtn}
                            onclick="assignEmployeeByBtn('${row.TicketId}')"> ${btnLabel}  </button>`;/**/

                            return btn;
                        }
                    }
                ],

                drawCallback: function () {
                    var api = this.api();

                    api.rows().every(function () {
                        var rowData = this.data();

                        if (rowData.AssignTo > 0) {

                            $('#ddl_' + rowData.TicketId).val(rowData.AssignTo);
                        }
                    });
                },

                fnCreatedRow: function (nRow) {
                    $(nRow).children("td").css("white-space", "nowrap");
                },

                initComplete: function () {

                    $('#load1').hide();
                },

                buttons: [
                    {
                        extend: 'excelHtml5',
                        title: 'All Tickets',
                        autoFilter: true
                    }
                ]
            });
        },

        error: function (error) {
            alert('Error: ' + error.responseText);
        }
    });

    return false;
}

function assignEmployeeByBtn(ticketId) {

    var ddl = document.getElementById("ddl_" + ticketId);
    var empId = ddl.value;

    if (empId === "") {
        alert("Please select an employee");
        return;
    }

    PageMethods.InsertTicketAssignTo(empId, ticketId, onSuccess_assign, onError_assign);
    return false;
}

function onSuccess_assign(result) {
    if (result > 0) {

        alert("Ticket assigned successfully.");
        it_tq_bindgrid();

        // $('#ddl_' + ticketId).val(empId).prop('disabled', true);
    }
    else {
        alert("Error assigned ticket");
    }
}

function onError_assign(error) {

    alert(error.responseText);
}

function it_tq_bindgrid_Core() {
    $('#load1').show();

    $.ajax({
        url: "TicketQueue.aspx/GetAllTickets",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);//

            it_ticketqueue = $('#it_ticketqueue').DataTable({
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
                    { data: '' },
                    { data: 'TicketId' },
                    { data: '' },
                    { data: 'TicketNo' },
                    { data: 'RequestDateTime' },
                    { data: 'ExpectedTAT' },
                    { data: 'Code' },
                    { data: 'WorkingBranch' },
                    { data: 'Request' },
                    { data: 'Priority' },
                    { data: 'Subject' },
                    { data: 'AssignName' },
                    { data: 'TET' }

                ],
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                },
                columnDefs: [
                    {
                        targets: 0,
                        "width": "45px",
                        render: function (data, type, row, meta) {
                            return '<a class="dropdown-item" href="#!" id="Actions" onclick="ticketQueue_EditTicket(\'' + meta.row + '\');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-pen"></i></span></a>';
                            //return '<input type="button" class="btn-primary" id=viewdetails-"' + meta.row + '" value="Details" onclick="return ViewPolicyDetails(\'' + meta.row + '\');" />&nbsp;<input type="button" class="btn-default" id=viewtasks-"' + meta.row + '" value="Tasks"  onclick="return ViewTaskDetails(\'' + meta.row + '\');"/>';
                        }
                    },
                    {
                        targets: 1,
                        "visible": false,
                    },
                    {
                        targets: 2, // 👈 dropdown column
                        render: function (data, type, row, meta) {

                            var ddl = `<select class="form-control emp-dd"
                              onchange="assignEmployee(this, '${row.TicketId}')">
                        <option value="">Select Employee</option>`;

                            $.each(empList, function (i, emp) {
                                ddl += `<option value="${emp.EmployeeID}">
                            ${emp.EmpName}
                        </option>`;
                            });

                            ddl += `</select>`;
                            return ddl;
                        }
                    }
                ],

                initComplete: function () {
                    $('#load1').hide();

                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: 'All Tickets', autoFilter: true,
                    },
                ],
            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });

    //$('#it_ticketqueue thead tr:eq(1) th').each(function () {
    //    var title = $(this).text();
    //    $(this).html('<input type="text" style="border-color:#e3e3e3; border-radius:5px;" class="column_search" />');
    //});

    var isrch = 0;
    $('#it_ticketqueue thead tr:eq(1) th').each(function () {
        if (isrch == 2) {
            var title = $(this).text();
            $(this).html('<input type="text" placeholder="Search ' + title + '" class="column_search" />');
        }
        else {
            $(this).html('');
        }
        isrch++;
    });

    $('#it_ticketqueue thead').on('keyup', ".column_search", function () {

        it_ticketqueue
            .column($(this).parent().index())
            .search(this.value)
            .draw();
    });

    return false;
}


function ticketQueue_EditTicket(rowid) {
    var row = $('#it_ticketqueue').DataTable().row(rowid).data();
    remark_TicketID = row.TicketId;
    location.href = "AddTicketRemark.aspx?TicketId=" + row.TicketId;
}


/*----------------- Add Ticket Remark  -----------------*/

function btnUpdateTicket_newRemark() {

    const urlParams = new URLSearchParams(window.location.search);
    const TicketId = urlParams.get('TicketId');
    remark_TicketID = TicketId;

    var ddlrequest = document.getElementById("ticketRemark_ReqType");
    var request = ddlrequest.options[ddlrequest.selectedIndex].value;

    var ddlPriority = document.getElementById("ticketRemark_Priority");
    var priority = ddlPriority.options[ddlPriority.selectedIndex].value;

    var ddlNextStatus = document.getElementById("ticketRemark_NextStatus");
    var nextStatus = ddlNextStatus.options[ddlNextStatus.selectedIndex].value;

    var description = document.getElementById("ticketRemark_Description").value;

    var ddldays = document.getElementById("ticketRemark_days");
    var days = ddldays.options[ddldays.selectedIndex].value;
    var ddlhours = document.getElementById("ticketRemark_hours");
    var hours = ddlhours.options[ddlhours.selectedIndex].value;
    var ddlminutes = document.getElementById("ticketRemark_minutes");
    var minutes = ddlminutes.options[ddlminutes.selectedIndex].value;



    if (dept == 7 || dept == 6) {

        if (request == "") {
            alert("Please select Request Type.");
            document.getElementById("ticketRemark_ReqType").focus();
            return false;
        }
        if (priority == "") {
            alert("Please select Priority.");
            document.getElementById("ticketRemark_Priority").focus();
            return false;
        }
    }
    if (nextStatus == "") {
        alert("Please select Status.");
        document.getElementById("ticketRemark_NextStatus").focus();
        return false;
    }
    if (days == "") {
        alert("Please select Days From Expected TAT.");
        document.getElementById("ticketRemark_days").focus();
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
    if (description == "") {
        alert("Please enter Description.");
        document.getElementById("ticketRemark_Description").focus();
        return false;
    }
    $('#waitingpanelTicket').modal('show');

    PageMethods.UpdateTicketRemark(TicketId, request, priority, nextStatus, description, days, hours, minutes, ticketremark_OnSuccess, ticketremark_OnError);
    return false;
}

function ticketremark_OnSuccess(result) {

    $('#waitingpanelTicket').modal('hide');

    if (result > 0) {
        //remark_TicketID = 0;
        document.getElementById("ticketremark_errmsg").innerHTML = "Remark added successfully!";
        $('#ticketremark_dverror').modal('show');
        bind_TicketRemarkHistory(remark_TicketID);
        return false;
    }
    else {
        document.getElementById("ticketremark_errmsg").innerHTML = "Oops! Error occured while adding remark. Please contact administrator!";
        document.getElementById("ticketremark_errmsg").style.color = 'red';
        $('#ticketremark_dverror').modal('show');
        return false;
    }
}

function ticketremark_OnError(error) {
    alert(error.responseText);
}

function downloadImg() {

    var currenturl = window.location.href;
    var urlindex = currenturl.lastIndexOf('/');
    var firstpart = currenturl.substring(0, urlindex + 1);

    var actualurl = firstpart + "DownloadFiles.aspx?TicketID=" + file_TickeID;

    window.location.href = actualurl; // ✅ SAFE
    return false;
}


/*----------------- Bind Method -----------------*/

function ticketRemark_Binddays() {

    var select = document.getElementById("ticketRemark_days");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#ticketRemark_days").append($("<option></option>").val("").html("Select"));

    for (var i = 0; i < 31; i++) {
        $("#ticketRemark_days").append($("<option ></option>").val(i).html(i));
    }
}

function ticketRemark_Bindhours() {

    var select = document.getElementById("ticketRemark_hours");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#ticketRemark_hours").append($("<option></option>").val("").html("Select"));

    for (var i = 0; i < 12; i++) {
        $("#ticketRemark_hours").append($("<option></option>").val(i).html(i));
    }
}

function ticketRemark_Bindminutes() {

    var select = document.getElementById("ticketRemark_minutes");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#ticketRemark_minutes").append($("<option></option>").val("").html("Select"));

    for (var i = 0; i < 60; i++) {
        $("#ticketRemark_minutes").append($("<option></option>").val(i).html(i));
    }
}

function bindticketremarkfields(TicketId) {

    $('#load1').show();

    $.ajax({
        url: "AddTicketRemark.aspx/GetAllTicketsRemark",
        type: "POST",
        dataType: "json",
        data: "{TicketId:" + TicketId + "}",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {

                dept = value.Department;

                if (value.Department == 7 || value.Department == 6)
                    trReqTypePriority.style.display = "";
                else
                    trReqTypePriority.style.display = "none";

                file_TickeID = TicketId;
                file_Path = value.Attachment;

                document.getElementById("ticketremark_ticketno").innerHTML = value.TicketNo;
                document.getElementById("ticketremark_requestrelatedto").innerHTML = value.Request;
                document.getElementById("ticketremark_requestby").innerHTML = value.RequestByName;
                document.getElementById("ticketremark_subject").innerHTML = value.Subject;
                document.getElementById("ticketremark_requestdatetime").innerHTML = value.RequestDateTime;
                document.getElementById("ticketremark_deskno").innerHTML = value.DeskNo;
                document.getElementById("ticketremark_requestonbehalf").innerHTML = value.RequestOnBehalf;
                document.getElementById("ticketremark_reportingmanager").innerHTML = value.ReportingManager;
                document.getElementById("ticketremark_description").innerHTML = value.Description;
                document.getElementById("lbl_downloadPath").innerHTML = value.Attachment;

                if (value.Attachment.length > 0)
                    $("#downloadLink").show();
                else
                    $("#downloadLink").hide();

                $('#load1').hide();
                //$("#downloadLink").hide();
            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });

}

function bind_TicketRemarkHistory(ticketID) {

    $('#load1').show();

    $.ajax({
        url: "AddTicket.aspx/GetAllRemarkTicketwise",
        type: "POST",
        dataType: "json",
        data: "{TicketID:" + ticketID + "}",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            ticketRemarkHistory_table = $('#table_ticketRemarkHistory').DataTable({
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




