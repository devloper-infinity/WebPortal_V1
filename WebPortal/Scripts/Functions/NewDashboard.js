
var currentUserName;
var IsOwnBirthDayPopUp;
var IsBirthdayNotifications;
var IsWorkAnnivesary;
var IsPasswordChange;
var PoshStatus;
var dd = 0;

let alertsQueue = [];
let currentIndex = 0;
let globalCallback = null;
let localCallback = null;


function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

function dash_bindBasciInfo() {

    $.ajax({
        url: "DashboardEmployee.aspx/BindInformation",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);
            var i = 0;
            $.each(dataArray, function (index, value) {
                i++;

                $("#dashboard_spnusername").text(value.FirstName + " " + value.lastName);
                $("#dashboard_spndesignation").text(value.DesignationName);
                IsPasswordChange = value.IsPasswordChange;
                PoshStatus = value.PoshStatus;

                if (value.Gender == "Male")
                    document.getElementById("dashboard_userimg").src = "../dist/img/Male.png";
                else
                    document.getElementById("dashboard_userimg").src = "../dist/img/Female.png";

                var employeeMode = blankForNull(value.DailyTaskProductivity).toString().toLowerCase();
                window.dashboardEmployeeProductivityMode = employeeMode == "task" ? "Task" : "Productive";
                window.dashboardIsTaskBasedEmployee = employeeMode == "task";
                $("#prod_dashboard_employee").show();
                dashApplyProductiveEmployeeMode();

                if (window.dashboardShouldLoadProductiveInsights === true &&
                    window.dashboardProductiveInsightsRequested !== true &&
                    typeof dash_bindProductiveEmployeeInsights === "function") {
                    window.dashboardProductiveInsightsRequested = true;
                    dash_bindProductiveEmployeeInsights();
                }
            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
}

function dash_bindImpNotification() {

    $('#load1').show();
    html = '';
    $.ajax({
        url: "DashboardEmployee.aspx/GetDashboardAlerts",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);
            var i = 0;
            $.each(dataArray, function (index, value) {
                i++;
                html += '<tr>';
                html += '<td style="display:none;">' + blankForNull(value.AlertId) + '</td>';
                html += '<td style="display:none;">' + blankForNull(i) + '</td>';
                html += '<td>' + blankForNull(value.Subject) + '</td>';
                html += '<td style="text-align:center;"><a class="dropdown-item" href="#!" id="Actions" onclick="dashboard_downloadattachment(' + value.AlertId + ',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-cloud-download"></i></span></a></td>';
                html += '<td style="text-align:center;"><a class="dropdown-item" href="#!" id="Actions" onclick="dashboard_viewalertdetails(' + value.AlertId + ',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-search-alt"></i></span></a></td>';
                html += '<td style="text-wrap: nowrap;display:none;">' + blankForNull(value.Attachment) + '</td>';
                html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#dashboard_alert_table')) {
                dashboard_alert_table.destroy();
            }
            $('#dashboard_alert_table tbody').html(html);

            dashboard_alert_table = $('#dashboard_alert_table').DataTable({
                dom: 't',
                scrollX: true,
                destroy: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                "pageLength": 5,
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
    return false;
}

function dash_bindManpowerSumary(Type) {
    $('#load1').show();
    dasboard_currentmanpower_html = '';
    $.ajax({
        url: "DashboardEmployee.aspx/CurrentManpowerSummary",
        type: "POST",
        data: "{Type:'" + Type + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//            
            var i = 0;
            summary_total = 0;
            summary_onfloor = 0;
            summary_resigned = 0;
            summary_absconding = 0;
            $.each(dataArray, function (index, value) {
                i++;
                dasboard_currentmanpower_html += '<tr>';
                dasboard_currentmanpower_html += '<td style="display:none;">' + blankForNull(value.DomainId) + '</td>';
                dasboard_currentmanpower_html += '<td style="display:none;">' + blankForNull(value.WorkingBranch) + '</td>';
                dasboard_currentmanpower_html += '<td style="display:none;">' + blankForNull(i) + '</td>';
                dasboard_currentmanpower_html += '<td>' + blankForNull(value.BranchName) + '</td>';
                dasboard_currentmanpower_html += '<td>' + blankForNull(value.DomainGroupName) + '</td>';
                dasboard_currentmanpower_html += '<td>' + blankForNull(value.Subdomain) + '</td>';
                dasboard_currentmanpower_html += '<td style="text-align:center;"><a href="#url" onclick="summary_totalclick(' + value.WorkingBranch + ',' + value.DomainId + ',\'' + value.Subdomain + '\',1); " >' + blankForNull(value.Total) + '</a></td>';
                dasboard_currentmanpower_html += '<td style="text-align:center;"><a href="#url" onclick="summary_totalclick(' + value.WorkingBranch + ',' + value.DomainId + ',\'' + value.Subdomain + '\',2); " >' + blankForNull(value.OnFloor) + '</a></td>';
                dasboard_currentmanpower_html += '<td style="text-align:center;"><a href="#url" onclick="summary_totalclick(' + value.WorkingBranch + ',' + value.DomainId + ',\'' + value.Subdomain + '\',3); " >' + blankForNull(value.Resigned) + '</a></td>';
                dasboard_currentmanpower_html += '<td style="text-align:center;"><a href="#url" onclick="summary_totalclick(' + value.WorkingBranch + ',' + value.DomainId + ',\'' + value.Subdomain + '\',4); " >' + blankForNull(value.Absconding) + '</a></td>';
                summary_total = summary_total + parseInt(value.Total);
                summary_onfloor = summary_onfloor + parseInt(value.OnFloor);
                summary_resigned = summary_resigned + parseInt(value.Resigned);
                summary_absconding = summary_absconding + parseInt(value.Absconding);
                dasboard_currentmanpower_html += '</tr>';
                document.getElementById("dashboard_graphperiod").innerHTML = 'Period: ' + blankForNull(value.Period);
            });

            if ($.fn.dataTable.isDataTable('#dasboard_currentmanpower')) {
                dasboard_currentmanpower_table.destroy();
            }
            $('#dasboard_currentmanpower tbody').html(dasboard_currentmanpower_html);
            //else
            dasboard_currentmanpower_table = $('#dasboard_currentmanpower').DataTable({
                dom: 'tBp',
                scrollX: true,
                destroy: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                "pageLength": 10,
                'select': {
                    'style': 'single'
                },

                initComplete: function () {
                    $('#load1').hide();
                    document.getElementById("dashboard_totalemployees").innerHTML = summary_total;
                    document.getElementById("dashboard_onfloormployees").innerHTML = summary_onfloor;
                    document.getElementById("dashboard_resignedemployees").innerHTML = summary_resigned;
                    document.getElementById("dashboard_abscondingemployees").innerHTML = summary_absconding;
                    if (Type == "All")
                        document.getElementById("summary_gridheaderfilter").innerHTML = 'All Employees';
                    else if (Type == "Present")
                        document.getElementById("summary_gridheaderfilter").innerHTML = 'Present Today';
                    else if (Type == "Leave")
                        document.getElementById("summary_gridheaderfilter").innerHTML = 'Users on Leave';

                },
                "rowCallback": function (row, data) {
                    var val = data[3];
                },

                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Current Manpower Summary', autoFilter: true,
                        exportOptions: {
                            columns: [3, 4, 5, 6, 7, 8, 9]
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


/*------------  Pop-Ups Sequence  ------------*/

function runPopupSequence() {

    currentUserName = document.getElementById("hdnUserId").value;

    const popups = [
        { id: "welcomeIntro", type: "first_time" },

        { id: "birthdayModal", key: "birthday", type: "once_per_day" },
        { id: "dash_anniversaryModal", key: "workAnniversary", type: "once_per_day" },
        { id: "dash_birthdayModal_all", key: "allBirthday", type: "once_per_day" },
        { id: "dash_festWish_PopUp", key: "festival", type: "once_per_day" },
        { id: "dash_projectNotifications", key: "projectNotifications", type: "once_per_day" },

        /*{ id: "dashboard_alertdetails", type: "every_login" },*/
        { id: "dash_expiryModal", key: "passwordExpirary", type: "every_login" },
        { id: "dash_pendingnotifications", key: "pendingNotifications", type: "every_login" }
    ];

    showPopupsSequentially(popups, 0);
}

function openPopup(id, callback) {

    // 🎯 Intro Popup  -- 1
    if (id === "welcomeIntro") {
        handleIntroPopup(callback);
        return;
    }

    // 🎂 Birthday Popup (API based)--2
    if (id === "birthdayModal") {
        dash_ownBirthday(callback);
        return;
    }

    // 🎂 Work Anniversary Popup (API based) --  3
    if (id === "dash_anniversaryModal") {
        // console.log("🔥 Work Anniversary Triggered");
        dash_workAnniversary(callback);
        return;
    }

    // 🎂 Employee's Birthday Popup (API based)  --  4
    if (id === "dash_birthdayModal_all") {
        // console.log("🔥 Employee's Birthday Popup");
        dash_empBirthdays(callback);
        return;
    }

    // 🎯 Festival Popup --  5
    if (id === "dash_festWish_PopUp") {
        dash_bindFestivalWish(callback);
        return;
    }

    // 🎯 Project Notofcations --  6
    if (id === "dash_projectNotifications") {
        dash_loadUserProjectNotifications(callback);
        return;
    }

    //  Password Expirary --  7
    if (id === "dash_expiryModal") {
        // console.log('passsword');
        dash_passwordExpirary(callback);
        return;
    }


    //  Pending Notification --  8
    if (id === "dash_pendingnotifications") {
        dash_PendingTaskNotifications(callback);
        return;
    }

    let el = document.getElementById(id);

    if (!el) {
        // console.warn("Popup not found:", id);
        callback();
        return;
    }


    // ✅ ONLY Bootstrap 4
    if ($(el).hasClass("modal")) {

        $(el).modal('show');

        $(el)
            .off('hidden.bs.modal')
            .on('hidden.bs.modal', function () {
                callback();
            });

    } else {
        el.style.display = "block";

        setTimeout(() => {
            el.style.display = "none";
            callback();
        }, 3000);
    }
}

function showPopupsSequentially(popups, index) {

    // console.log(index);

    if (index >= popups.length) return;

    let popup = popups[index];

    if (shouldShowPopup(popup)) {

        openPopup(popup.id, function () {

            // console.log("Completed:", popup.id);

            showPopupsSequentially(popups, index + 1);
        });

    } else {
        showPopupsSequentially(popups, index + 1);
    }
}

function shouldShowPopup(popup) {

    let today = new Date().toDateString();

    // ✅ First time
    if (popup.type === "first_time") {

        let key = "first_time_" + currentUserName;

        if (localStorage.getItem(key)) return false;

        localStorage.setItem(key, "done");
        return true;
    }

    // ✅ Once per day
    if (popup.type === "once_per_day") {

        let key = popup.key + "_" + currentUserName;

        if (localStorage.getItem(key) === today) return false;

        localStorage.setItem(key, today);
        return true;
    }

    // ✅ Every login (SAFE for ASP.NET)
    if (popup.type === "every_login") {

        //let key = "session_" + popup.id;

        //if (sessionStorage.getItem(key)) return false;

        //sessionStorage.setItem(key, "shown");
        return true;
    }

    return false;
}

function markPopupAsShown(popup) {

    let key = "popup_" + popup.id + "_" + currentUserName;
    let today = new Date().toDateString();

    if (popup.type === "first_time") {
        localStorage.setItem(key, "done");
    }

    if (popup.type === "once_per_day") {
        localStorage.setItem(key, today);
    }
}



/*------------------------  Bind Pop-Ups Methods  ------------------------*/

/* Dashboard Navigations */
function core1_dash_startDashboardTour() {

    var intro = introJs();
    var steps = [];

    // 👉 First: Add all existing HTML steps (sorted)
    $('[data-step]').sort(function (a, b) {
        return $(a).data('step') - $(b).data('step');
    }).each(function () {

        steps.push({
            element: this,
            intro: $(this).attr('data-intro')
        });
    });

    // 👉 Then: Add Menu step at LAST
    if ($('#navbarCollapse').length) {
        steps.push({
            element: '#navbarCollapse',
            intro: '<b>Introducing a horizontal menu for easier page access and navigation.</b>'
        });
    }

    intro.setOptions({
        steps: steps,
        nextLabel: 'Next →',
        prevLabel: '← Back',
        skipLabel: 'Skip',
        doneLabel: 'Finish',
        showProgress: true
    });

    // ✅ When user completes tour
    intro.oncomplete(function () {

        $('#dashwelcomeIntro').fadeOut();

    });

    // ✅ When user skips tour
    intro.onexit(function () {

        $('#dashwelcomeIntro').fadeOut();
        $('#dashfinalMessagePopup').fadeIn();

        if (callback) callback();   // 🔥 VERY IMPORTANT
    });

    intro.start();

}

function core2_dash_startDashboardTour(callback) {

    var intro = introJs();
    var steps = [];

    $('[data-step]').sort(function (a, b) {
        return $(a).data('step') - $(b).data('step');
    }).each(function () {
        steps.push({
            element: this,
            intro: $(this).attr('data-intro')
        });
    });

    if ($('#navbarCollapse').length) {
        steps.push({
            element: '#navbarCollapse',
            intro: '<b>Introducing a horizontal menu for easier navigation.</b>'
        });
    }

    intro.setOptions({
        steps: steps,
        nextLabel: 'Next →',
        prevLabel: '← Back',
        skipLabel: 'Skip',
        doneLabel: 'Finish',
        showProgress: true
    });

    // ✅ ONLY on Finish
    intro.oncomplete(function () {

        $('#dashwelcomeIntro').fadeOut();

        // 👉 Show ONLY when finished
        $('#dashfinalMessagePopup').fadeIn();

        if (callback) callback();
    });

    // ❌ Skip / Exit → do NOT show final popup
    intro.onexit(function () {

        $('#dashwelcomeIntro').fadeOut();

        if (callback) callback();
    });

    intro.start();
}

function core3_dash_startDashboardTour(callback) {

    var intro = introJs();
    var steps = [];
    var isHandled = false;

    $('[data-step]').sort(function (a, b) {
        return $(a).data('step') - $(b).data('step');
    }).each(function () {
        steps.push({
            element: this,
            intro: $(this).attr('data-intro')
        });
    });

    if ($('#navbarCollapse').length) {
        steps.push({
            element: '#navbarCollapse',
            intro: '<b>Introducing a horizontal menu for easier navigation.</b>'
        });
    }

    intro.setOptions({
        steps: steps,
        nextLabel: 'Next →',
        prevLabel: '← Back',
        skipLabel: 'Skip',
        doneLabel: 'Finish',
        showProgress: true
    });

    function safeClose(isFinish) {

        if (isHandled) return;
        isHandled = true;

        $('#dashwelcomeIntro').fadeOut();

        // ✅ ONLY when finished
        if (isFinish) {
            $('#dashfinalMessagePopup').fadeIn();

            // 🔥 CALL DATABASE METHOD
            finishTour();
            callback();
        }

        //// ✅ Always continue popup sequence
        //setTimeout(function () {
        //    if (callback) callback();
        //}, 300);
    }

    // ✅ Finish
    intro.oncomplete(function () {
        safeClose(true);
    });

    // ✅ Skip / Exit
    intro.onexit(function () {
        safeClose(false);
    });

    intro.start();
}

function dash_startDashboardTour(callback) {

    var intro = introJs();
    var steps = [];
    var isHandled = false;

    $('[data-step]').sort(function (a, b) {
        return $(a).data('step') - $(b).data('step');
    }).each(function () {
        steps.push({
            element: this,
            intro: $(this).attr('data-intro')
        });
    });

    if ($('#navbarCollapse').length) {
        steps.push({
            element: '#navbarCollapse',
            intro: '<b>Introducing a horizontal menu for easier navigation.</b>'
        });
    }

    intro.setOptions({
        steps: steps,
        nextLabel: 'Next →',
        prevLabel: '← Back',
        skipLabel: 'Skip',
        doneLabel: 'Finish',
        showProgress: true
    });

    function safeClose(isFinish) {

        if (isHandled) return;
        isHandled = true;

        // ✅ FORCE CLOSE intro
        try {
            //intro.exit();   // 🔥 IMPORTANT FIX
            PageMethods.InsertDashboardTour('Add', function (res) {

                if (res !== "completed") {

                }
            });
            $('#dashfinalMessagePopup').fadeIn();
            callback();
        } catch (e) { }

        $('.introjs-overlay, .introjs-helperLayer, .introjs-tooltip').remove(); // extra safety

        $('#dashwelcomeIntro').fadeOut();

        if (isFinish) {

            // ✅ DB call
            PageMethods.InsertDashboardTour('Add', function (res) {

                if (res !== "completed") {

                }
            });
            $('#dashfinalMessagePopup').fadeIn();

            // ✅ attach click (remove old + add new)
            $('#btnCloseFinal').off('click').on('click', function () {

                $('#dashfinalMessagePopup').fadeOut();
                callback();
            });
        }
    }

    // ✅ Finish
    intro.oncomplete(function () {
        safeClose(true);
    });

    // ✅ Skip / Exit
    intro.onexit(function () {
        safeClose(false);
    });

    intro.start();
}

function finishTour() {

    // 🔥 Save in background
    PageMethods.InsertDashboardTour('Add', function (res) {

        if (res !== "completed") {

        }
    });
}

function core_dash_startDashboardTour() {

    var intro = introJs();
    var steps = [];

    // 👉 First: Add all existing HTML steps (sorted)
    $('[data-step]').sort(function (a, b) {
        return $(a).data('step') - $(b).data('step');
    }).each(function () {

        steps.push({
            element: this,
            intro: $(this).attr('data-intro')
        });
    });

    // 👉 Then: Add Menu step at LAST
    if ($('#navbarCollapse').length) {
        steps.push({
            element: '#navbarCollapse',
            intro: '<b>Introducing a horizontal menu for easier page access and navigation.</b>'
        });
    }


    intro.setOptions({
        steps: steps,
        nextLabel: 'Next →',
        prevLabel: '← Back',
        skipLabel: 'Skip',
        doneLabel: 'Finish',
        showProgress: true
    });

    // ✅ When user completes tour
    intro.oncomplete(function () {
        /*  $('#dashfinalMessagePopup').fadeIn();*/

        // ✅ DB call
        PageMethods.InsertDashboardTour('Add', function (res) {

            if (res !== "completed") {

            }
        });
        $('#dashfinalMessagePopup').fadeIn();


        callback();
    });

    // ✅ When user skips tour
    intro.onexit(function () {
        /*$('#dashfinalMessagePopup').fadeIn();*/
        /*  $('#dashwelcomeIntro').fadeOut();*/


        try {
            intro.exit();   // 🔥 IMPORTANT FIX
        } catch (e) { }

        $('.introjs-overlay, .introjs-helperLayer, .introjs-tooltip').remove(); // extra safety

        $('#dashwelcomeIntro').fadeOut();

        callback();
    });

    intro.start();

}

function handleIntroPopup(callback) {

    PageMethods.InsertDashboardTour('Check', function (res) {
        if (res === "show") {

            $('#dashwelcomeIntro').fadeIn();

            $('#btndashSkipIntro').off('click').on('click', function () {

                $('#dashwelcomeIntro').fadeOut();

                /*  localStorage.setItem("first_time_" + currentUserName, "done");*/

                callback(); // ✅ MUST
            });

            $('#btndashStartIntro').off('click').on('click', function () {

                $('#dashwelcomeIntro').fadeOut();

                dash_startDashboardTour();

                /*  localStorage.setItem("first_time_" + currentUserName, "done");*/

                /* callback();*/ // ✅ MUST
            });

        } else {

            callback();
        }
    });

}


/* Birthday */
function dash_ownBirthday(callback) {

    $.ajax({
        type: "POST",
        url: "DashboardEmployee.aspx/CheckBirthday",
        data: '{}',
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        success: function (res) {

            try {
                let data = res.d;

                if (!data || data.IsBirthday !== true) {
                    callback();
                    return;
                }

                $("#lblBirthdayName").text(data.FirstName);/*Name*/
                
                let modalEl = document.getElementById('birthdayModal');

                //let modal = bootstrap.Modal.getInstance(modalEl)
                //    || new bootstrap.Modal(modalEl);

                //modal.show();

                //modalEl.addEventListener('hidden.bs.modal', function handler() {
                //    modalEl.removeEventListener('hidden.bs.modal', handler);
                //    callback();
                //});

                $('#birthdayModal').modal('show');

                $('#birthdayModal')
                    .off('hidden.bs.modal')
                    .on('hidden.bs.modal', function () {
                        callback();
                    });

            } catch (e) {
                // console.error("Birthday Error:", e);
                callback(); // ✅ NEVER block flow
            }
        },

        error: function () {
            callback();
        }
    });
}


/* Work Anniversary */
function dash_workAnniversary(callback) {

    $.ajax({
        type: "POST",
        url: "DashboardEmployee.aspx/GetEmpWorkAnniversary",
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        success: function (response) {
            renderWorkAnniversary(response.d, callback); // ✅ CLEAN
        },

        error: function () {
            // console.error("Anniversary API error");
            callback();
        }
    });
}

function renderWorkAnniversary(data, callback) {

    if (!data || data.length === 0) {
        if (typeof callback === "function") {
            callback();
        }
        return false;
    }

    var firstEmp = data[0];
    var jubilee = getJubileeDetails(firstEmp.YearsCompleted);

    var headerHtml = "";

    if (jubilee && jubilee.title) {
        headerHtml =
            '<b>💐 WORK ANNIVERSARY - ' +
            '<span style="color:' + jubilee.color + '; font-weight:bold;">' +
            jubilee.title + ' 💐' +
            '</span></b>';
    }
    else {
        headerHtml = '<b>💐 WORK ANNIVERSARY 💐</b>';
    }

    $("#workAnn_header").html(headerHtml);

    var emp = firstEmp;
    var jubileeEach = getJubileeDetails(emp.YearsCompleted);

    $("#name_header").html(emp.EmpName || "");
    $("#designation_header").html(emp.Designation || "");
    $("#years_header").html((emp.YearsCompleted || "0") + " Years of Excellence");

    $("#message_header").html(
        (jubileeEach && jubileeEach.message)
            ? jubileeEach.message
            : getAnniversaryMessage(emp.YearsCompleted)
    );

    $("#dash_anniversaryModal").modal("show");

    startConfetti();

    $("#dash_anniversaryModal")
        .off("hidden.bs.modal.workAnniversary")
        .on("hidden.bs.modal.workAnniversary", function () {
            if (typeof callback === "function") {
                callback();
            }
        });

    return false;
}

function startConfetti() {
    var duration = 3 * 1000;
    var end = Date.now() + duration;

    (function frame() {
        confetti({
            particleCount: 5,
            angle: 60,
            spread: 55,
            origin: { x: 0 }
        });
        confetti({
            particleCount: 5,
            angle: 120,
            spread: 55,
            origin: { x: 1 }
        });

        if (Date.now() < end) {
            requestAnimationFrame(frame);
        }
    }());
}

function createBalloons() {
    for (let i = 0; i < 15; i++) {
        let balloon = document.createElement("div");
        balloon.className = "balloon";
        balloon.style.left = Math.random() * 100 + "%";
        balloon.style.background = getRandomColor();
        balloon.style.animationDuration = (6 + Math.random() * 5) + "s";
        document.getElementById("balloons").appendChild(balloon);
    }
}

function getRandomColor() {
    var colors = ["red", "blue", "green", "orange", "purple", "gold"];
    return colors[Math.floor(Math.random() * colors.length)];
}

function getAnniversaryMessage(years) {

    if (years <= 1)
        return "Wishing you a great start to a wonderful journey with us.";
    else if (years <= 3)
        return "Thank you for growing with us and being a valuable team member.";
    else if (years <= 5)
        return "Your dedication and hard work inspire everyone around you.";
    else if (years <= 10)
        return "We truly appreciate your long-term commitment and contribution.";
    else if (years <= 15)
        return "Your experience and dedication are truly valuable to our organization.";
    else if (years <= 20)
        return "Two decades of dedication – we sincerely appreciate your journey with us.";
    else if (years < 25)
        return "Your long-term commitment and contribution mean a lot to us.";

    // Jubilee Messages
    else if (years == 25)
        return "Happy Silver Jubilee! Celebrating 25 years of dedication, loyalty, and excellence.";
    else if (years == 30)
        return "Happy Pearl Jubilee! Your journey with us is truly inspiring.";
    else if (years == 35)
        return "Happy Coral Jubilee! Thank you for your continued dedication and service.";
    else if (years == 40)
        return "Happy Ruby Jubilee! Your contribution over the years has been invaluable.";
    else if (years == 45)
        return "Happy Sapphire Jubilee! We deeply appreciate your incredible journey with us.";
    else if (years >= 50)
        return "Happy Golden Jubilee! A legendary milestone of dedication and loyalty.";

    else
        return "You are a pillar of our organization. Thank you for everything.";
}

function getJubileeDetails(years) {

    if (years == 25) {
        return {
            title: "Silver Jubilee",
            message: "Celebrating 25 years of dedication, loyalty, and excellence. Your contribution has been invaluable to our organization.",
            color: "#C0C0C0"
        };
    }
    else if (years == 30) {
        return {
            title: "Pearl Jubilee",
            message: "30 years of commitment and dedication is truly inspiring. Thank you for being an integral part of our journey.",
            color: "#FDEEF4"
        };
    }
    else if (years == 35) {
        return {
            title: "Coral Jubilee",
            message: "Celebrating 35 years of incredible service and dedication. We truly appreciate your journey with us.",
            color: "#FF7F50"
        };
    }
    else if (years == 40) {
        return {
            title: "Ruby Jubilee",
            message: "40 years of loyalty and dedication is a remarkable achievement. Thank you for your priceless contribution.",
            color: "#9B111E"
        };
    }
    else if (years == 45) {
        return {
            title: "Sapphire Jubilee",
            message: "Your 45 years of dedication and commitment are deeply respected and appreciated.",
            color: "#0F52BA"
        };
    }
    else if (years >= 50) {
        return {
            title: "Golden Jubilee",
            message: "A Golden Jubilee milestone! Thank you for your legendary dedication and lifetime contribution.",
            color: "#D4AF37"
        };
    }
    else {
        return ""; /* {title: "Work Anniversary",message: getAnniversaryMessage(years),color: "#00b3b3"};*/
    }
}



/* Employee Birthday */
function dash_empBirthdays(callback) {

    $.ajax({
        type: "POST",
        url: "DashboardEmployee.aspx/GetTodayBirthdays",
        contentType: "application/json",
        dataType: "json",

        success: function (res) {

            let data = res.d;

            if (typeof data === "string") {
                try {
                    data = JSON.parse(data);
                } catch (e) {
                    // console.error("Birthday JSON parse error", e);
                    callback();
                    return;
                }
            }

            if (!data || data.length === 0) {
                callback();
                return;
            }

            dash_renderBirthdayPopup(data);

            $('#dash_birthdayModal_all').modal({
                backdrop: 'static',
                keyboard: false
            });

            // ✅ FIXED EVENT BINDING
            $('#dash_birthdayModal_all')
                .off('hidden.bs.modal')
                .on('hidden.bs.modal', function () {
                    callback();
                });
        },

        error: function () {
            // console.error("Birthday API error");
            callback();
        }
    });
}

function dash_renderBirthdayPopup(data) {
    if (!data || data.length === 0) return;

    let html = '';

    data.forEach(emp => {
        let initials = emp.Name.split(' ').map(x => x[0]).join('').substring(0, 2);
        let bg = dash_getAvatarColor(emp.Name);

        html += `
        <div class="birthday-card d-flex flex-column mb-3">
            <div class="d-flex align-items-center justify-content-between">
                <div class="d-flex align-items-center">
                    <div class="cake-avatar" style="margin-right:10px;">
                        <img src="../images/cake.jpg" />
                    </div>
                    <div class="ms-3">
                        <div class="emp-name">${emp.Name}</div>
                        <div class="emp-meta">${emp.Code} | ${emp.BranchName} | ${emp.DepartmentName}</div>
                    </div>
                </div>
                  <button class="btn btn-wish" type="button" onclick="return dash_toggleWishBox(${emp.EmployeeID})">🎉 Wish</button>
            </div>

            <div id="wishBox_${emp.EmployeeID}" class="wish-box mt-2" style="display:none;">
                <input type="text" class="form-control mb-2" placeholder="Write your birthday wish..." id="msg_${emp.Code}" />
                <button class="btn btn-sm btn-success"  onclick="return dash_sendWish('${emp.Code}', this)">Send</button>
            </div>
        </div>`;
    });
   
    $('#dash_birthdayList').html(html);
}

function dash_toggleWishBox(empId) {
  
    window.location.href = "Birthday.aspx?EmployeeID=" + empId;

    // $('.wish-box').hide(); // close others
    // $('#wishBox_' + empId).toggle();
    // return false;
}

function dash_getAvatarColor(name) {
    const colors = [
        "linear-gradient(135deg,#667eea,#764ba2)",
        "linear-gradient(135deg,#f7971e,#ffd200)",
        "linear-gradient(135deg,#43cea2,#185a9d)",
        "linear-gradient(135deg,#ff6a00,#ee0979)",
        "linear-gradient(135deg,#36d1dc,#5b86e5)"
    ];

    let index = name.charCodeAt(0) % colors.length;
    return colors[index];
}

function dash_sendWish(empId, btn) {

    let msg = $('#msg_' + empId).val();

    if (!msg) {
        alert("Please enter a message");
        return false;
    }

    $.ajax({
        type: "POST",
        url: "DashboardEmployee.aspx/SendWish",
        data: JSON.stringify({ toUserId: empId, message: msg }),
        contentType: "application/json",

        success: function () {

            $(btn).text("Wished 🎂");
            $(btn).prop("disabled", true);

            $('#wishBox_' + empId).hide();
        }
    });
    return false;
}


/* Festival */
function dash_bindFestivalWish(callback) {

    $.ajax({
        type: "POST",
        url: "DashboardEmployee.aspx/BindInformation",
        dataType: "json",
        contentType: "application/json",

        success: function (res1) {

            let dataArray = res1.d;

            // ✅ Safe JSON handling
            if (typeof dataArray === "string") {
                try {
                    dataArray = JSON.parse(dataArray);
                } catch (e) {
                    // console.error("Festival JSON error", e);
                    callback();
                    return;
                }
            }

            // ✅ No data → skip
            if (!dataArray || dataArray.length === 0) {
                callback();
                return;
            }

            let value1 = dataArray[0]; // ✅ Use first record only

            // ✅ Set greeting
            document.getElementById("dash_popupGreeting").innerText = " 🌸 Hi " + value1.FirstName + " 🌸 ";

            $("#dash_festivalImage").attr("src", "../FestivalWishesImages/" + value1.FestiveImgPath);


            // ✅ Condition to show popup
            let shouldShow = false;

            if (value1.Gender === "Male") {
                if (value1.title !== "Women's Day" && value1.FestiveImgPath) {
                    shouldShow = true;
                }
            } else {
                if (value1.FestiveImgPath) {
                    shouldShow = true;
                }
            }

            if (!shouldShow) {
                callback();
                return;
            }

            // ✅ Show modal (Bootstrap 4)
            $('#dash_festWish_PopUp').modal('show');

            // ✅ Continue sequence after close
            $('#dash_festWish_PopUp').on('hidden.bs.modal', function handler() {
                $('#dash_festWish_PopUp').off('hidden.bs.modal', handler);
                callback();
            });
        },

        error: function () {
            // console.error("Festival API error");
            callback();
        }
    });
}


/* Project Notifications */
function dash_loadUserProjectNotifications(callback) {

    let localCallback = callback;

    $.ajax({
        type: "POST",
        url: "DashboardEmployee.aspx/GetDashboardProjectAlerts",
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        success: function (res) {

            if (!res.d) {
                callback();
                return;
            }

            alertsQueue = typeof res.d === "string" ? JSON.parse(res.d) : res.d;

            if (alertsQueue.length > 0) {
                currentIndex = 0;
                test_showNextAlert();
                $("#dash_projectNotifications").modal("show");
            }
            else {
                callback();
            }
        },

        error: function () {
            callback();
        }
    });
}

function test_showNextAlert() {

    if (currentIndex >= alertsQueue.length) {

        $("#dash_projectNotifications")
            .off('hidden.bs.modal')
            .on('hidden.bs.modal', function () {
                if (localCallback) localCallback();
            });

        $("#dash_projectNotifications").modal("hide");
        return;
    }

    let alert1 = alertsQueue[currentIndex];

    $("#prjN_alertTitle").text(alert1.Subject || "Project Alert");
    $("#prjN_alertMessage").text(alert1.Message || "");

    if (alert1.Attachment && alert1.Attachment.trim() !== "") {
        $("#prjN_attachmentDiv").show();
        $("#prjN_downloadFile").attr("href", alert1.Attachment);
    } else {
        $("#prjN_attachmentDiv").hide();
    }

    $("#dash_projectNotifications").modal("show");


    // ✅ NEXT BUTTON FLOW
    $("#btnNextAlert").off("click").on("click", function () {
        let alert2 = alertsQueue[currentIndex];

        markAsRead(alert2.AlertId);

        currentIndex++;
        showNextAlert();
    });

    // ✅ CLOSE BUTTON FLOW (IMPORTANT FIX)
    $("#btnClose").off("click").on("click", function () {

        currentIndex = alertsQueue.length;

        $("#dash_projectNotifications")
            .off('hidden.bs.modal')
            .on('hidden.bs.modal', function () {
                if (localCallback) localCallback();
            });

        $("#dash_projectNotifications").modal("hide");
    });
}

function goToNextAlert(e) {

    /*if (e) e.preventDefault(); */// ✅ stop form submit

    // ✅ SAFETY CHECK
    if (!alertsQueue || currentIndex >= alertsQueue.length) {

        $("#dash_projectNotifications")
            .off('hidden.bs.modal')
            .on('hidden.bs.modal', function () {
                if (localCallback) localCallback();
            });

        $("#dash_projectNotifications").modal("hide");

        return false;
    }

    let alert = alertsQueue[currentIndex];

    // ✅ EXTRA SAFETY
    if (!alert) {
        // console.warn("Alert is undefined at index:", currentIndex);

        $("#dash_projectNotifications")
            .off('hidden.bs.modal')
            .on('hidden.bs.modal', function () {
                if (localCallback) localCallback();
            });

        $("#dash_projectNotifications").modal("hide");

        return false;
    }

    // ✅ SAFE NOW
    markAsRead(alert.AlertId);

    currentIndex++;

    if (currentIndex < alertsQueue.length) {
        showNextAlert();
    } else {
        $("#dash_projectNotifications")
            .off('hidden.bs.modal')
            .on('hidden.bs.modal', function () {
                if (localCallback) localCallback();
            });

        $("#dash_projectNotifications").modal("hide");
    }

    return false;

}

function markAsRead(alertId) {
    $.ajax({
        type: "POST",
        url: "DashboardEmployee.aspx/UpdateProjectReadAlertStatus",
        data: JSON.stringify({ AlertID: alertId }),
        contentType: "application/json; charset=utf-8",

        success: function () {
            // console.log("Alert marked as read:", alertId);
        },

        error: function (err) {
            // console.error("Error marking alert as read:", err);
        }
    });
}


/* Password Expiry Notification */
function dash_passwordExpirary(callback) {

    // console.log("IsPasswordChange: shubhangi");

    if (IsPasswordChange !== 1) {
        callback();
        return;
    }

    $('#dash_expiryModal').modal('show');

    $('#dash_expiryModal')
        .off('hidden.bs.modal')
        .on('hidden.bs.modal', function () {
            callback();
        });

    $("#btnRemind")
        .off("click")
        .on("click", function () {
            $('#dash_expiryModal').modal('hide');
        });
}


/* Pending Task List */
function dash_PendingTaskNotifications(callback) {

    var total_Count = 0;

    $.ajax({
        url: "DashboardEmployee.aspx/GetPendingTask",
        type: "POST",
        data: JSON.stringify({ Type: Type }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        success: function (res) {

            let data = typeof res.d === "string" ? JSON.parse(res.d) : res.d;

            // ❌ No data → skip popup
            if (!data || data.length === 0) {
                callback();
                return;
            }

            // ✅ Create rows
            let html = "";

            data.forEach(function (item) {

                total_Count++;

                var taskUrl = item.Url;
                if ((item.Text || "").indexOf("Profile Verification Request") === 0) {
                    taskUrl = "ApproveSalaryStructure.aspx";
                }

                html += `
                    <tr>
                        <td>
                             <a href="${taskUrl}" target="_blank" style="font-size:14px; color:black; text-decoration:underline;">${item.Text || ""}</a>
                        </td>
                    </tr>`;
            });

            $("#totalCount").text(total_Count);

            // ✅ Set table data
            $('#dash_tblnotifications tbody').html(html);

            $('#dash_tblnotifications').DataTable({
                pageLength: 10,
                lengthChange: false,
                searching: false,
                ordering: false
            });

            // ✅ Show modal
            $('#dash_pendingnotifications').modal('show');


            // ✅ Continue after close
            $('#dash_pendingnotifications')
                .off('hidden.bs.modal')
                .on('hidden.bs.modal', function () {
                    callback();
                });
        },

        error: function () {
            callback(); // continue even if error
        }
    });
}



//---- By NGK
/*------------------------ Production Details Pop-Up  ------------------------*/

function dashboardDataTableDom(isCompact) {
    if (isCompact) {
        return "t<'dashboard-dt-footer dashboard-dt-footer-compact'<'dashboard-dt-info'i><'dashboard-dt-pages'p>>";
    }

    return "<'dashboard-dt-toolbar'<'dashboard-dt-actions'B><'dashboard-dt-search'f>>" +
        "t" +
        "<'dashboard-dt-footer'<'dashboard-dt-info'i><'dashboard-dt-pages'p>>";
}

function dashboardDataTableLanguage(scope) {
    return {
        search: '',
        searchPlaceholder: 'Search ' + (scope || 'records'),
        info: 'Showing _START_ to _END_ of _TOTAL_',
        infoEmpty: 'No records available',
        zeroRecords: 'No matching records found',
        processing: 'Loading...',
        paginate: {
            previous: 'Previous',
            next: 'Next'
        }
    };
}

function dashboardAttachColumnFilters(tableSelector, tableApi) {
    var $thead = $(tableSelector + ' thead');

    $thead.off('keyup.dashboardFilter change.dashboardFilter', '.dashboard-column-search');
    $thead.on('keyup.dashboardFilter change.dashboardFilter', '.dashboard-column-search', function (event) {
        event.stopPropagation();

        var columnIndex = parseInt($(this).attr('data-column'), 10);
        if (!isNaN(columnIndex)) {
            tableApi.column(columnIndex).search(this.value).draw();
        }
    });
}
