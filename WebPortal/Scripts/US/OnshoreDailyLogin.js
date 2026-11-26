let currentActiveBreakInOutId = null;
function updateTime() {
    const currentClock = getOnshoreDailyLoginClockNow();
    $("#osdlcurrentTime").text(formatEstTime(currentClock));
    $("#osdldlClockDate").text(formatEstDate(currentClock) + " EST");
}

function formatEstTime(date) {
    try {
        return new Intl.DateTimeFormat("en-GB", {
            timeZone: "America/New_York",
            hour: "2-digit",
            minute: "2-digit",
            second: "2-digit",
            hour12: false
        }).format(date);
    } catch (ex) {
        return date.toTimeString().slice(0, 8);
    }
}

function formatEstDate(date) {
    return new Intl.DateTimeFormat('en-US', {
        timeZone: 'America/New_York',
        month: 'short', 
        day: 'numeric',  
        year: 'numeric' 
    }).format(date);
}

function getOnshoreDailyLoginClockNow() {
    if (typeof dailyLoginServerUtcBase !== 'undefined' && dailyLoginServerUtcBase) {
        return new Date(dailyLoginServerUtcBase.getTime() + (Date.now() - dailyLoginClockSyncedAt));
    }
    return new Date();
}

//Add Login Details 
function AddOnshore_login() {
    var currentTime = $('#osdlcurrentTime').text().substring(0, 5);
    var rawDate = new Date($('#osdldlClockDate').text().replace(" EST", "").trim());

    var clockDate = String(rawDate.getMonth() + 1).padStart(2, '0') + '/' +
        String(rawDate.getDate()).padStart(2, '0') + '/' +
        rawDate.getFullYear();

    if (!currentTime || !clockDate) {
        Swal.fire('Warning', 'Time values are missing!', 'warning');
        return false;
    }

    $('#load1').css('display', 'flex');

    $.ajax({
        type: "POST",
        url: "DailyLogin.aspx/AddOnshorelogin", 
        data: JSON.stringify({ currentTime: currentTime, clockDate: clockDate }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            $('#load1').hide();

            var res = JSON.parse(response.d);
            if (res.success) {
                Swal.fire({
                    title: 'Success!',
                    text: res.message,
                    icon: 'success',
                    confirmButtonText: 'OK'
                }).then((result) => {
                    loadOnshoreDailyLogs();
                });
            } else {
                Swal.fire('Error', res.message, 'error');
            }
        },
        error: function (xhr, status, error) {
            $('#load1').hide();
            console.error(xhr.responseText);
            Swal.fire('Error', 'Something went wrong while processing login.', 'error');
        }
    });

    return false;
}

//Add LogOut Details 
function AddOnshore_LogOut() {
    var currentOutTime = $('#osdlcurrentTime').text().substring(0, 5);
    var rawText = $('#osdldlClockDate').text().trim();
    var d = new Date(rawText);
    var mm = String(d.getMonth() + 1).padStart(2, '0'); 
    var dd = String(d.getDate()).padStart(2, '0');       
    var yyyy = d.getFullYear();                        
    var currentDate = mm + '/' + dd + '/' + yyyy;
    if (!currentOutTime) {
        Swal.fire('Warning', 'Time values are missing!', 'warning');
        return false;
    }

    $('#load1').css('display', 'flex');

    $.ajax({
        type: "POST",
        url: "DailyLogin.aspx/AddOnshoreLogOut",
        data: JSON.stringify({ currentOutTime: currentOutTime, currentDate: currentDate }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            $('#load1').hide();
            var res = JSON.parse(response.d);

            if (res.success) {
                Swal.fire({
                    title: 'Success!',
                    text: res.message,
                    icon: 'success',
                    confirmButtonText: 'OK'
                }).then((result) => {
                    loadOnshoreDailyLogs();
                });
            } else {
                Swal.fire('Error', res.message, 'error');
            }
        },
        error: function (xhr, status, error) {
            $('#load1').hide();
            console.error(xhr.responseText);
            Swal.fire('Error', 'Something went wrong while processing logout.', 'error');
        }
    });

    return false;
}

//Add Break In Details 
function AddOnshore_BreakIn() {
    var BreakInTime = $('#osdlcurrentTime').text().substring(0, 5);

    if (!BreakInTime) {
        Swal.fire('Warning', 'Time values are missing!', 'warning');
        return false;
    }

    $('#load1').css('display', 'flex');

    $.ajax({
        type: "POST",
        url: "DailyLogin.aspx/AddOnshoreBreakIn",
        data: JSON.stringify({ BreakInTime: BreakInTime, breakInOutID: currentActiveBreakInOutId }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            $('#load1').hide();
            var res = JSON.parse(response.d);

            if (res.success) {
                Swal.fire({
                    title: 'Success!',
                    text: res.message,
                    icon: 'success',
                    confirmButtonText: 'OK'
                }).then((result) => {
                    loadOnshoreDailyLogs();
                });
            } else {
                Swal.fire('Error', res.message, 'error');
            }
        },
        error: function (xhr, status, error) {
            $('#load1').hide();
            console.error(xhr.responseText);
            Swal.fire('Error', 'Something went wrong while processing BreakIn.', 'error');
        }
    });

    return false;
}

//Add Break Out Details 
function AddOnshore_BreakOut(breakReason) {
    var BreakOutTime = $('#osdlcurrentTime').text().substring(0, 5);

    if (!BreakOutTime) {
        Swal.fire('Warning', 'Time values are missing!', 'warning');
        return false;
    }

    $('#load1').css('display', 'flex');

    $.ajax({
        type: "POST",
        url: "DailyLogin.aspx/AddOnshoreBreakOut",
        data: JSON.stringify({ BreakOutTime: BreakOutTime, BreakReason: breakReason }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            $('#load1').hide();
            var res = JSON.parse(response.d);

            if (res.success) {
                Swal.fire({
                    title: 'Success!',
                    text: res.message,
                    icon: 'success',
                    confirmButtonText: 'OK'
                }).then((result) => {
                    loadOnshoreDailyLogs();
                });
            } else {
                Swal.fire('Error', res.message, 'error');
            }
        },
        error: function (xhr, status, error) {
            $('#load1').hide();
            console.error(xhr.responseText);
            Swal.fire('Error', 'Something went wrong while processing BreakIn.', 'error');
        }
    });

    return false;
}
//Get Login Data
function loadOnshoreDailyLogs() {
    $.ajax({
        type: "POST",
        url: "DailyLogin.aspx/GetOnshoreDailyLogs",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var data = JSON.parse(response.d);
            var today = new Date();
            var mm = String(today.getMonth() + 1).padStart(2, '0');
            var dd = String(today.getDate()).padStart(2, '0');
            var yyyy = today.getFullYear();
            var todayDate = mm + '/' + dd + '/' + yyyy;

            var todayRecord = null;
            if (data && data.length > 0) {
                todayRecord = data.find(function (row) {
                    return row.Date === todayDate;
                });
            }
            if (todayRecord && todayRecord.InTime && (!todayRecord.OutTime || todayRecord.OutTime === "" || todayRecord.OutTime === "NA")) {
                $("#osdlloginout_btnlogin").hide();
               
 
                startSimpleLiveTimer(todayRecord.InTime);
                
                var activeRecord = null;
                if (data && data.length > 0) {
                    activeRecord = data.find(function (row) {
                        return !row.OutTime || row.OutTime === "" || row.OutTime === "NA";
                    });
                }

                var employeeId = activeRecord ? activeRecord.ID : null;

                console.log("Active Record ID:", employeeId);

                $.ajax({
                    type: "POST",
                    url: "DailyLogin.aspx/GetOnshoreDailyLogsBreakInOut",
                    data: JSON.stringify({ employeeID: employeeId }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (breakResponse) {
                        var breakData = JSON.parse(breakResponse.d);
                        var isCurrentlyOnBreak = false;

                        if (breakData && breakData.length > 0) {
                            var latestBreak = breakData[breakData.length - 1];

                            if (latestBreak && latestBreak.BreakOutTime && latestBreak.BreakOutTime !== "" && latestBreak.BreakOutTime !== "NA") {
                                if (!latestBreak.BreakInTime || latestBreak.BreakInTime === "" || latestBreak.BreakInTime === "NA") {
                                    isCurrentlyOnBreak = true;
                                    currentActiveBreakInOutId = latestBreak.BreakInOutId;
                                }
                            }
                        }

                        if (isCurrentlyOnBreak) {
                            $("#osdlbreakin_btnbreakin").show();
                            $("#osdlbreakout_btnbreakout").hide();
                            $("#osdlloginout_btnlogout").hide();
                        } else {
                            $("#osdlbreakin_btnbreakin").hide();
                            $("#osdlbreakout_btnbreakout").show();
                            $("#osdlloginout_btnlogout").show();
                        }
                    }
                });

            } else {
                var isTodayCompleted = todayRecord &&
                    todayRecord.InTime && todayRecord.InTime !== "" && todayRecord.InTime !== "NA" &&
                    todayRecord.OutTime && todayRecord.OutTime !== "" && todayRecord.OutTime !== "NA";
                if (isTodayCompleted) {
                    $("#osdlloginout_btnlogin").hide();
                } else {
                    $("#osdlloginout_btnlogin").show(); 
                }
                $("#osdlloginout_btnlogout").hide();
                $("#osdlbreakin_btnbreakin").hide();
                $("#osdlbreakout_btnbreakout").hide();

                $("#osdlCurrentLogin").text("NA");
                $("#osdlUptoTime").text("00:00:00");
                if (osdlTimer) clearInterval(osdlTimer);
            }

            if ($.fn.DataTable.isDataTable('#osdlloginout_table')) {
                $('#osdlloginout_table').DataTable().clear().destroy();
            }

            $('#osdlloginout_table').DataTable({
                data: data,
                paging: false,
                columns: [
                    { data: 'Date' },
                    { data: 'InTime' },
                    {
                        data: 'OutTime',
                        render: function (data, type, row) {
                            if (!data || data === "" || data === "NA") {
                                if (row.Date !== todayDate) {
                                    return '<span style="color: red; font-weight: bold;">Incomplete Log</span>';
                                } else {
                                    return '<span style="color: green; font-weight: bold;">Current Login</span>';
                                }
                            }
                            return data;
                        }
                    },
                    {
                        data: null,
                        title: "Total Break Hours",
                        render: function (data, type, row) {
                            var breakVal = row.TotalBreakHours;
                            var displayValue = (!breakVal || breakVal === "" || breakVal === "NA") ? "00:00" : breakVal;

                            return `<a href="javascript:void(0);" onclick="openBreakModal('${row.ID}')" title="view break details" style="color: #007bff; text-decoration: underline; font-weight: bold; cursor: pointer;">${displayValue}</a>`;
                        }
                    },
                    { data: 'Hours' }
                ],
                rowCallback: function (row, data) {
                    if (!data.OutTime || data.OutTime === "" || data.OutTime === "NA") {
                        if (data.Date !== todayDate) {
                            $(row).css('background-color', '#f8d7da');
                        } else {
                            $(row).css('background-color', '#e6f4ea');
                        }
                    }
                },
                responsive: true,
                autoWidth: false
            });
        }
    });
}

function openBreakModal(employeeId) {
    $.ajax({
        type: "POST",
        url: "DailyLogin.aspx/GetOnshoreDailyLogsBreakInOut",
        data: JSON.stringify({ employeeID: employeeId }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var breakData = JSON.parse(response.d); 
            if ($.fn.DataTable.isDataTable('#osdl_break_popup_table')) {
                $('#osdl_break_popup_table').DataTable().clear().destroy();
            }

            $('#osdl_break_popup_table').DataTable({
                data: breakData,
                columns: [
                    { data: 'BreakOutTime', title: 'Break Out' },
                    { data: 'BreakInTime', title: 'Break In' },
                    { data: 'TotalBreakHours', title: 'Total Time' },
                    { data: 'Remark', title: 'Reason' } 

                ],
                paging: false,
                searching: false,
                info: false,
                autoWidth: false,
                ordering: false,

                footerCallback: function (row, data, start, end, display) {
                    var api = this.api();
                    var totalBreakMinutes = 0;

                    api.column(2, { page: 'current' }).data().each(function (value) {
                        if (value !== null && value !== undefined) {
                            var stringValue = String(value).trim();

                            if (stringValue !== "" && stringValue !== "NA" && stringValue !== "0.") {
                                var parts = stringValue.split(":");
                                var hrs = parseInt(parts[0]) || 0;
                                var mins = parseInt(parts[1]) || 0;

                                totalBreakMinutes += (hrs * 60) + mins;
                            }
                        }
                    });

                    var totalHours = Math.floor(totalBreakMinutes / 60);
                    var totalMins = totalBreakMinutes % 60;

                    var formattedTotal = String(totalHours).padStart(2, '0') + ':' + String(totalMins).padStart(2, '0');

                    $(api.column(2).footer()).html(formattedTotal);
                }
            });

            $('#osdlBreakModal').modal('show');
        },
        error: function (xhr, status, error) {
            console.log("Error: " + error);
        }
    });
}

let osdlTimer = null;
function startSimpleLiveTimer(inTimeString) {
    if (!inTimeString) return;

    $("#osdlCurrentLogin").text(inTimeString);

    if (osdlTimer) clearInterval(osdlTimer);
    let p = inTimeString.split(":");
    let loginTotalSec = (parseInt(p[0] || 0) * 3600) + (parseInt(p[1] || 0) * 60) + parseInt(p[2] || 0);
    osdlTimer = setInterval(function () {
        let now = new Date();
        let currentTotalSec = (now.getHours() * 3600) + (now.getMinutes() * 60) + now.getSeconds();

        let diffSec = currentTotalSec - loginTotalSec;
        if (diffSec < 0) diffSec = 0; 
        let h = String(Math.floor(diffSec / 3600)).padStart(2, '0');
        let m = String(Math.floor((diffSec % 3600) / 60)).padStart(2, '0');
        let s = String(diffSec % 60).padStart(2, '0');

        $("#osdlUptoTime").text(h + ":" + m + ":" + s);
    }, 1000);
}

function openBreakReasonPopup() {
    var BreakOutTime = $('#osdlcurrentTime').text().substring(0, 5);

    if (!BreakOutTime) {
        Swal.fire('Warning', 'Time values are missing!', 'warning');
        return false;
    }

    $('#ddlBreakReason').val('');
    $('#txtOtherReason').val('');
    $('#divOtherReason').hide();
    $('#osdlBreakReasonModal').modal('show');
    return false;
}

function onBreakReasonChange() {
    var selectedVal = $('#ddlBreakReason').val();
    if (selectedVal === 'Other') {
        $('#divOtherReason').show();
    } else {
        $('#divOtherReason').hide();
        $('#txtOtherReason').val('');
    }
}

function submitBreakOutWithReason() {
    var breakReason = $('#ddlBreakReason').val();
    var otherReason = $('#txtOtherReason').val().trim();

    if (!breakReason) {
        Swal.fire('Warning', 'Please select a break reason!', 'warning');
        return;
    }

    if (breakReason === 'Other' && !otherReason) {
        Swal.fire('Warning', 'Please specify the reason in the text box!', 'warning');
        return;
    }

    var finalReason = (breakReason === 'Other') ? (otherReason) : breakReason;

    $('#osdlBreakReasonModal').modal('hide');

    AddOnshore_BreakOut(finalReason);
}




//***************************Edit Daily Login **************************/

function GetAllEmpOnshoreDailyLogs() {
    $.ajax({
        type: "POST",
        url: "EditDailyLogin.aspx/GetAllEmpOnshoreDailyLogs",
        data: JSON.stringify({}),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var breakData = JSON.parse(response.d);

            if ($.fn.DataTable.isDataTable('#editonshoreloginout_table')) {
                $('#editonshoreloginout_table').DataTable().clear().destroy();
            }

            $('#editonshoreloginout_table').DataTable({
                data: breakData,
                columns: [
                    {
                        data: null,
                        render: function (data, type, row) {
                            return '<button type="button" class="btn btn-sm btn-editonshoreedit" title="Edit" style="background: transparent; border: none; color: #007bff; margin-right: 5px;"><i class="fas fa-pencil-alt"></i></button>' +
                                '<button type="button" class="btn btn-sm btn-editonshoredelete" title="Delete" style="background: transparent; border: none; color: #dc3545;"><i class="fas fa-trash"></i></button>';
                        }
                    },
                    { data: 'ID', visible: false },
                    { data: 'Code', visible: false },
                    { data: 'EmployeeName' },
                    { data: 'Date' },
                    { data: 'InTime' },
                    { data: 'OutTime' },


                    {
                        data: null,
                        title: "Total Break Hours",
                        render: function (data, type, row) {
                            var breakVal = row.TotalBreakHours;
                            var displayValue = (!breakVal || breakVal === "" || breakVal === "NA") ? "00:00" : breakVal;

                            return `<a href="javascript:void(0);" onclick="openBreakInOutModalForUpdate('${row.ID}','${row.Code}')" title="view break details" style="color: #007bff; text-decoration: underline; font-weight: bold; cursor: pointer;">${displayValue}</a>`;
                        }
                    },

                    { data: 'Hours' },
                    { data: 'UpdateRemark' },

                ],
                paging: true,      
                pageLength: 10,    
                searching: true,
                info: true,
                autoWidth: false,
                ordering: false
            });

        },
        error: function (xhr, status, error) {
            console.log("Error: " + error);
        }
    });
}

$(document).on('click', '#editonshoreloginout_table .btn-editonshoreedit', function () {
    var table = $('#editonshoreloginout_table').DataTable();
    var tr = $(this).closest('tr');
    var rowData = table.row(tr).data();

    if (rowData) {
        $('#editonshoretxtDate').val(rowData.Date);
        $('#editModal').data('code', rowData.Code);
        $('#editonshoretxtUpdateRemark').val(rowData.Remark || rowData.UpdateRemark || '');
        var inTimeInput = document.getElementById('editonshoretxtInTime');
        var outTimeInput = document.getElementById('editonshoretxtOutTime');

        if (inTimeInput && inTimeInput.setTimeValue) {
            inTimeInput.setTimeValue(rowData.InTime);
        } else {
            $('#editonshoretxtInTime').val(rowData.InTime);
        }

        if (outTimeInput && outTimeInput.setTimeValue) {
            outTimeInput.setTimeValue(rowData.OutTime);
        } else {
            $('#editonshoretxtOutTime').val(rowData.OutTime);
        }

        $('#editModal').modal('show');
    }
});

$(document).on('click', '#editonshoreloginout_table .btn-editonshoredelete', function () {
    var table = $('#editonshoreloginout_table').DataTable();
    var tr = $(this).closest('tr');
    var rowData = table.row(tr).data();

    Swal.fire({
        title: 'Are you sure?',
        text: "You want to delete this record for date?",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'Yes'
    }).then((result) => {
        if (result.isConfirmed) {
            deleteRecord(rowData);
        }
    });
});

function deleteRecord(rowData) {
    $.ajax({
        url: 'EditDailyLogin.aspx/DeleteUserWiseOnshoreDailyLogin',
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify({ Date: rowData.Date, Code: rowData.Code }),
        dataType: 'json',
        success: function (response) {
            var res = response.d ? (typeof response.d === 'string' ? JSON.parse(response.d) : response.d)
                : (typeof response === 'string' ? JSON.parse(response) : response);

            if (res.success) {
                Swal.fire(
                    'Deleted!',
                    res.message,
                    'success'
                );
                GetAllEmpOnshoreDailyLogs();
            } else {
                Swal.fire(
                    'Error!',
                    res.message || 'Record could not be deleted.',
                    'error'
                );
            }
        },
        error: function (xhr) {
            Swal.fire(
                'Error!',
                'Something went wrong while deleting.',
                'error'
            );
        }
    });
}

$(document).on('click', '#btnUpdate', function (e) {
    e.preventDefault();

    let dateVal = $('#editonshoretxtDate').val().trim();
    let inTimeVal = $('#editonshoretxtInTime').val().trim();
    let outTimeVal = $('#editonshoretxtOutTime').val().trim();
    let updateRemarkVal = $('#editonshoretxtUpdateRemark').val().trim();
    let codeVal = $('#editModal').data('code');
    if (!dateVal || !inTimeVal || !outTimeVal) {
        Swal.fire('Warning', 'Please fill out all required fields.', 'warning');
        return;
    }

    if (outTimeVal <= inTimeVal) {
        Swal.fire('Warning', 'Out Time must be later than In Time.', 'warning');
        return;
    }

    var updatedData = {
        Code: codeVal,
        Date: dateVal,
        InTime: inTimeVal,
        OutTime: outTimeVal,
        Remark: updateRemarkVal
    };


    $.ajax({
        type: "POST",
        url: "EditDailyLogin.aspx/UpdateOnshorelogin",
        data: JSON.stringify(updatedData),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var res = (typeof response.d === 'string') ? JSON.parse(response.d) : response.d;

            if (res.success) {
                Swal.fire({
                    title: 'Success!',
                    text: res.message,
                    icon: 'success',
                    confirmButtonText: 'OK'
                }).then(() => {
                    $('#editModal').modal('hide');
                    GetAllEmpOnshoreDailyLogs();
                });
            } else {
                Swal.fire('Error', res.message, 'error');
            }
        },
        error: function (xhr, status, error) {
            console.error("AJAX Error: ", error);
            Swal.fire('Server Error', xhr.responseText || 'An unexpected error occurred.', 'error');
        },
        complete: function () {
            $btn.prop('disabled', false);
        }
    });
});
$(document).on('shown.bs.modal', '#editModal', function () {
    initTimePickers();
});

function initTimePickers() {
    const timeConfigs = [
        ['editonshoretxtInTime', 'in-time-panel', 'in-hours', 'in-mins'],
        ['editonshoretxtOutTime', 'out-time-panel', 'out-hours', 'out-mins']
    ];

    timeConfigs.forEach(([inputId, panelId, hoursId, minsId]) => {
        let input = document.getElementById(inputId);
        let panel = document.getElementById(panelId);
        let hoursCol = document.getElementById(hoursId);
        let minsCol = document.getElementById(minsId);

        if (!input || !panel || !hoursCol || !minsCol) return;
        if (hoursCol.children.length === 0) {
            for (let h = 0; h < 24; h++) {
                let hh = String(h).padStart(2, '0');
                let div = document.createElement('div');
                div.className = 'nph-time-option';
                div.textContent = hh;
                div.onclick = function (e) {
                    e.stopPropagation();
                    hoursCol.querySelectorAll('.nph-time-option').forEach(x => x.classList.remove('selected'));
                    this.classList.add('selected');

                    let cur = input.value ? input.value.split(':') : ['00', '00'];
                    cur[0] = hh;
                    input.value = cur.join(':');
                    $(input).trigger('change');
                };
                hoursCol.appendChild(div);
            }

            for (let m = 0; m < 60; m++) {
                let mm = String(m).padStart(2, '0');
                let div = document.createElement('div');
                div.className = 'nph-time-option';
                div.textContent = mm;
                div.onclick = function (e) {
                    e.stopPropagation();
                    minsCol.querySelectorAll('.nph-time-option').forEach(x => x.classList.remove('selected'));
                    this.classList.add('selected');

                    let cur = input.value ? input.value.split(':') : ['00', '00'];
                    cur[1] = mm;
                    input.value = cur.join(':');
                    $(input).trigger('change');
                };
                minsCol.appendChild(div);
            }
        }

        input.setTimeValue = function (val) {
            input.value = val || '';
            if (val && val.includes(':')) {
                let parts = val.split(':');
                let h = parts[0];
                let m = parts[1];

                hoursCol.querySelectorAll('.nph-time-option').forEach(el => {
                    if (el.textContent === h) el.classList.add('selected');
                    else el.classList.remove('selected');
                });

                minsCol.querySelectorAll('.nph-time-option').forEach(el => {
                    if (el.textContent === m) el.classList.add('selected');
                    else el.classList.remove('selected');
                });
            }
        };

        input.onclick = function (e) {
            e.stopPropagation();
            document.querySelectorAll('.nph-time-picker-panel').forEach(p => {
                if (p.id !== panelId) p.classList.remove('active');
            });
            panel.classList.toggle('active');
        };
    });

    if (!window._timePickerGlobalClickListener) {
        window._timePickerGlobalClickListener = true;
        document.addEventListener('click', function () {
            document.querySelectorAll('.nph-time-picker-panel').forEach(p => {
                p.classList.remove('active');
            });
        });
    }
}

function openBreakInOutModalForUpdate(ID, Code) {
    $('#osdlUpdateBreakModal').data('parent-row-id', ID);
    $('#osdlUpdateBreakModal').data('parent-row-code', Code);
    $.ajax({
        type: "POST",
        url: "EditDailyLogin.aspx/GetOnshoreEditDailyLogsBreakInOut",
        data: JSON.stringify({ ID: ID, Code: Code }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var breakData = JSON.parse(response.d);

            if ($.fn.DataTable.isDataTable('#osdl_breakInOutForupdate_table')) {
                $('#osdl_breakInOutForupdate_table').DataTable().clear().destroy();
            }

            $('#osdl_breakInOutForupdate_table').DataTable({
                data: breakData,
                columns: [
                    {
                        data: null, title: 'Action',
                        render: function (data, type, row) {
                            return '<button type="button" class="btn btn-sm btn-editonshoreBreakinOut" title="Edit" style="background: transparent !important; background-color: transparent !important; border: none !important; box-shadow: none !important; color: #007bff; margin-right: 5px; outline: none !important;"><i class="fas fa-pencil-alt"></i></button>' +
                                '<button type="button" class="btn btn-sm btn-danger btn-deleteonshoreinout" title="Delete" style="background: transparent; border: none; color: #dc3545;"><i class="fas fa-trash"></i></button>';
                        }
                    },
                    { data: 'BreakOutTime', title: 'Break Out' },
                    { data: 'BreakInTime', title: 'Break In' },
                    { data: 'TotalBreakHours', title: 'Total Time' },
                    { data: 'Remark', title: 'Reason' },
                    {
                        data: 'UpdateRemark',
                        title: 'Update Remark',
                        render: function (data, type, row) {
                            if (!data || data === "" || data === "NA") {
                                return '<span class="text-muted">--</span>';
                            }
                            return data;
                        }
                    }

                ],
                createdRow: function (row, data, dataIndex) {
                    $(row).attr('data-id', data.ID);
                },
                paging: true,      
                pageLength: 10,    
                searching: true,
                info: true,
                autoWidth: false,
                ordering: false,
                drawCallback: function (settings) {
                    var api = this.api();
                    var totalBreakMinutes = 0;

                    api.rows({ page: 'current' }).data().each(function (row) {
                        var stringValue = row.TotalBreakHours ? String(row.TotalBreakHours).trim() : "";

                        if (stringValue !== "" && stringValue !== "NA" && stringValue !== "0.") {
                            var parts = stringValue.split(":");
                            if (parts.length === 2) {
                                var hrs = parseInt(parts[0]) || 0;
                                var mins = parseInt(parts[1]) || 0;
                                totalBreakMinutes += (hrs * 60) + mins;
                            }
                        }
                    });

                    var totalHours = Math.floor(totalBreakMinutes / 60);
                    var totalMins = totalBreakMinutes % 60;

                    var formattedTotal = String(totalHours).padStart(2, '0') + ':' + String(totalMins).padStart(2, '0');
           

                    $('#osdlUpdateBreakModal').modal('show');
                    $('#totalBreakSum').text(formattedTotal);
                }
            });
        },
        error: function (xhr, status, error) {
            console.log("Error: " + error);
        }
    });
}

// Edit button click handler
$(document).on('click', '.btn-editonshoreBreakinOut', function () {
    var $row = $(this).closest('tr');
    var $icon = $(this).find('i');
    var $deleteBtn = $row.find('.btn-deleteonshoreinout');
    var $deleteIcon = $deleteBtn.find('i');

    if ($icon.hasClass('fa-pencil-alt')) {
        var breakOutVal = $row.find('td:eq(1)').text().trim() || "--:--";
        var breakInVal = $row.find('td:eq(2)').text().trim() || "--:--";
        var existingRemark = $row.find('td:eq(5)').text().trim();
        if (existingRemark === "--") {
            existingRemark = "";
        }
        $row.data('original-breakout', breakOutVal);
        $row.data('original-breakin', breakInVal);
        $row.data('original-remark', existingRemark);
        $icon.removeClass('fa-pencil-alt').addClass('fa-check');
        $(this).removeClass('btn-primary').addClass('btn-success');

        $deleteIcon.removeClass('fa-trash').addClass('fa-times');
        $deleteBtn.attr('title', 'Cancel');

        $icon.css({
            'color': '#007bff', 
            'background': 'transparent !important',
            'background-color': 'transparent !important',
            'border': 'none !important'
        });
        var breakOutHtml = `
            <div class="nph-time-input-container">
                <input type="text" class="form-control form-control-sm txt-breakout" placeholder="--:--" readonly value="${breakOutVal}" style="cursor: pointer; background-color: #fff; padding-right: 30px;">
                <span class="fas fa-clock nph-clock-icon"></span>
                <div class="nph-time-picker-panel custom-breakout-panel">
                    <div class="nph-time-column breakout-hours-col"></div>
                    <div class="nph-time-column breakout-mins-col"></div>
                </div>
            </div>`;

        var breakInHtml = `
            <div class="nph-time-input-container">
                <input type="text" class="form-control form-control-sm txt-breakin" placeholder="--:--" readonly value="${breakInVal}" style="cursor: pointer; background-color: #fff; padding-right: 30px;">
                <span class="fas fa-clock nph-clock-icon"></span>
                <div class="nph-time-picker-panel custom-breakin-panel">
                    <div class="nph-time-column breakin-hours-col"></div>
                    <div class="nph-time-column breakin-mins-col"></div>
                </div>
            </div>`;
        var updateRemarkHtml = `<input type="text" class="form-control form-control-sm txt-updatemark" value="${existingRemark}" placeholder="Enter update remark...">`;
        $row.find('td:eq(1)').html(breakOutHtml);
        $row.find('td:eq(2)').html(breakInHtml);
        $row.find('td:eq(5)').html(updateRemarkHtml);
        initCustomTimePicker($row.find('.txt-breakout'), $row.find('.custom-breakout-panel'), $row.find('.breakout-hours-col'), $row.find('.breakout-mins-col'));
        initCustomTimePicker($row.find('.txt-breakin'), $row.find('.custom-breakin-panel'), $row.find('.breakin-hours-col'), $row.find('.breakin-mins-col'));
    }
    else {
        var parentRowID = $('#osdlUpdateBreakModal').data('parent-row-id');
        var parentRowCode = $('#osdlUpdateBreakModal').data('parent-row-code');
        var table = $('#osdl_breakInOutForupdate_table').DataTable();
        var rowData = table.row($row).data();

       

        var rowID = rowData.BreakInOutId;
        var newBreakOut = $row.find('.txt-breakout').val().trim();
        var newBreakIn = $row.find('.txt-breakin').val().trim();
        var newUpdateRemark = $row.find('.txt-updatemark').val().trim();

        if (newBreakIn <= newBreakOut) {
            Swal.fire('Warning', 'Break In time must be later than Break Out time.', 'warning');
            return;
        }

        var mainTable = $('#editonshoreloginout_table').DataTable();
        var mainRow = mainTable.rows().data().toArray().find(r => r.ID == parentRowID);

        if (mainRow) {
            var mainInTime = mainRow.InTime;   
            var mainOutTime = mainRow.OutTime;

            if (newBreakOut < mainInTime || newBreakOut > mainOutTime) {
                Swal.fire('Warning', `Break Out time must be between In-Time (${mainInTime}) and Out-Time (${mainOutTime}).`, 'warning');
                return;
            }

            if (newBreakIn < mainInTime || newBreakIn > mainOutTime) {
                Swal.fire('Warning', `Break In time must be between In-Time (${mainInTime}) and Out-Time (${mainOutTime}).`, 'warning');
                return;
            }
        }

        var btnElem = $(this);

        $.ajax({
            type: "POST",
            url: "EditDailyLogin.aspx/UpdateOnshoreBreakInOut",
            data: JSON.stringify({ ID: rowID, BreakOutTime: newBreakOut, BreakInTime: newBreakIn, Code: parentRowCode, Remark: newUpdateRemark }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                var res = JSON.parse(response.d);

                if (res.success) {
                    Swal.fire({
                        title: 'Success!',
                        text: res.message,
                        icon: 'success',
                        confirmButtonText: 'OK'
                    }).then(() => {
                        $row.find('td:eq(1)').text(newBreakOut);
                        $row.find('td:eq(2)').text(newBreakIn);
                        var displayRemark = newUpdateRemark === "" ? '<span class="text-muted">--</span>' : newUpdateRemark;
                        $row.find('td:eq(5)').html(displayRemark);
                        table.row($row).invalidate();

                        $icon.removeClass('fa-check').addClass('fa-pencil-alt');
                        btnElem.css({
                            'color': '#007bff',
                            'background': 'transparent',
                            'background-color': 'transparent',
                            'border': 'none'
                        });
                        if (parentRowID) {
                            openBreakInOutModalForUpdate(parentRowID, parentRowCode);
                            GetAllEmpOnshoreDailyLogs();
                        }
                        $deleteIcon.removeClass('fa-times').addClass('fa-trash');
                        $deleteBtn.attr('title', 'Delete');
                    });
                } else {
                    Swal.fire('Error', res.message, 'error');
                }
               
            },
            error: function (xhr, status, error) {
                console.log("Error: " + error);
            }
        });
    }
});

$(document).on('click', '.btn-deleteonshoreinout', function (e) {
    var $row = $(this).closest('tr');
    var $icon = $(this).find('i');
    var parentRowCode = $('#osdlUpdateBreakModal').data('parent-row-code');

    if ($icon.hasClass('fa-times')) {
        e.preventDefault();
        var origBreakOut = $row.data('original-breakout') || "--:--";
        var origBreakIn = $row.data('original-breakin') || "--:--";
        var origRemark = $row.data('original-remark') || "";

        $row.find('td:eq(1)').text(origBreakOut);
        $row.find('td:eq(2)').text(origBreakIn);

        var displayOrigRemark = (origRemark === "" || origRemark === "NA") ? '<span class="text-muted">--</span>' : origRemark;
        $row.find('td:eq(5)').html(displayOrigRemark);

        var $editBtn = $row.find('.btn-editonshoreBreakinOut');
        var $editIcon = $editBtn.find('i');
        $editIcon.removeClass('fa-check').addClass('fa-pencil-alt');
        $editBtn.removeClass('btn-success').addClass('btn-primary');

        $icon.removeClass('fa-times').addClass('fa-trash');
        $(this).attr('title', 'Delete');
    } else {
        e.preventDefault();
        var parentRowID = $('#osdlUpdateBreakModal').data('parent-row-id');
        var parentRowCode = $('#osdlUpdateBreakModal').data('parent-row-code');

        var table = $('#osdl_breakInOutForupdate_table').DataTable();
        var rowData = table.row($row).data();

        if (!rowData) {
            Swal.fire('Error!', 'Row data not found.', 'error');
            return;
        }

        var breakInOutId = rowData.BreakInOutId || rowData.Id;

        Swal.fire({
            title: 'Are you sure?',
            text: "You want to delete this record for date?",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6',
            confirmButtonText: 'Yes'
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    type: "POST",
                    url: "EditDailyLogin.aspx/DeleteUserWiseOnshoreDailyBreakInOut",
                    data: JSON.stringify({ BreakInOutId: breakInOutId, Code: parentRowCode }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        var res = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;

                        if (res.success) {
                            Swal.fire(
                                'Deleted!',
                                res.message,
                                'success'
                            );
                            if (parentRowID) {
                                openBreakInOutModalForUpdate(parentRowID, parentRowCode);
                                GetAllEmpOnshoreDailyLogs();
                            }
                        } else {
                            Swal.fire(
                                'Error!',
                                res.message,
                                'error'
                            );
                        }
                    },
                    error: function (xhr, status, error) {
                        Swal.fire(
                            'Error!',
                            "Error: " + error,
                            'error'
                        );
                    }
                });
            }
        });
    }
});

function initCustomTimePicker($input, $panel, $hoursCol, $minsCol) {
    let selectedHour = "--";
    let selectedMin = "--";

    let currentVal = $input.val();
    if (currentVal && currentVal.includes(':')) {
        let parts = currentVal.split(':');
        selectedHour = parts[0];
        selectedMin = parts[1];
    }

    let hCol = $hoursCol[0];
    let mCol = $minsCol[0];

    if (!hCol || !mCol) return;

    hCol.innerHTML = '';
    mCol.innerHTML = '';

    for (let h = 0; h < 24; h++) {
        let hh = String(h).padStart(2, '0');
        let div = document.createElement('div');
        div.className = 'nph-time-option';
        if (hh === selectedHour) div.classList.add('selected');
        div.textContent = hh;

        div.onclick = function (e) {
            e.stopPropagation();
            $hoursCol.find('.nph-time-option').removeClass('selected');
            $(this).addClass('selected');
            selectedHour = hh;
            if (selectedMin === "--") selectedMin = "00";
            $input.val(`${selectedHour}:${selectedMin}`);
        };
        hCol.appendChild(div);
    }

    for (let m = 0; m < 60; m++) {
        let mm = String(m).padStart(2, '0');
        let div = document.createElement('div');
        div.className = 'nph-time-option';
        if (mm === selectedMin) div.classList.add('selected');
        div.textContent = mm;

        div.onclick = function (e) {
            e.stopPropagation();
            $minsCol.find('.nph-time-option').removeClass('selected');
            $(this).addClass('selected');
            selectedMin = mm;
            if (selectedHour === "--") selectedHour = "00";
            $input.val(`${selectedHour}:${selectedMin}`);
        };
        mCol.appendChild(div);
    }

    $input.off('click').on('click', function (e) {
        e.stopPropagation();
        $('.nph-time-picker-panel').not($panel).removeClass('active');

        let inputRect = this.getBoundingClientRect();
        let spaceBelow = window.innerHeight - inputRect.bottom;

        $panel.toggleClass('active');

        if ($panel.hasClass('active')) {
            if (spaceBelow < 180) {
                $panel.css({
                    'top': 'auto',
                    'bottom': '100%',
                    'margin-bottom': '4px',
                    'margin-top': '0'
                });
            } else {
                $panel.css({
                    'top': '100%',
                    'bottom': 'auto',
                    'margin-top': '4px',
                    'margin-bottom': '0'
                });
            }
        }
    });

    $panel.off('click').on('click', function (e) {
        e.stopPropagation();
    });
}

$(document).off('click.nphPicker').on('click.nphPicker', function (e) {
    if (!$(e.target).closest('.nph-time-input-container').length) {
        $('.nph-time-picker-panel').removeClass('active');
    }
});