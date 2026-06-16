
var currentUserName;
var IsPasswordChange;

/* Project Notifications */
let alertsQueue = [];
let currentIndex = 0;
let projectCallback = null;


console.log('JS Loaded');

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
        "welcomeIntro",
        "birthdayModal",
        "dash_anniversaryModal",
        "dash_birthdayModal_all",
        "dash_festWish_PopUp",
        "dash_projectNotifications",
        "dash_expiryModal",
        "dash_pendingnotifications"
    ];

    runNextPopup(popups, 0);
}

function runNextPopup(popups, index) {

    if (index >= popups.length) return;
    console.log(index);
    console.log(popups.length);
    let id = popups[index];

    console.log("👉 Running:", id);

    openPopup(id, function () {
        runNextPopup(popups, index + 1);
    });
}

function openPopup(id, callback) {
    console.log(id);
    // 🔥 ALWAYS close previous modal first
    $('.modal').modal('hide');


    setTimeout(() => {

        if (id === "welcomeIntro") return handleIntroPopup(callback);
        if (id === "birthdayModal") return dash_ownBirthday(callback);
        if (id === "dash_anniversaryModal") return dash_workAnniversary(callback);
        if (id === "dash_birthdayModal_all") return dash_empBirthdays(callback);
        if (id === "dash_festWish_PopUp") return dash_bindFestivalWish(callback);
        if (id === "dash_projectNotifications") return dash_projectNotifications(callback);
        if (id === "dash_expiryModal") return dash_passwordExpirary(callback);
        if (id === "dash_pendingnotifications") return dash_PendingTaskNotifications(callback);

        callback();

    }, 300); // 🔥 REQUIRED delay
}





/*------------  Bind Pop-Ups Methods  ------------*/


/* Dashboard Navigations */
function dash_startDashboardTour() {
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
        $('#dashfinalMessagePopup').fadeIn();
    });

    // ✅ When user skips tour
    intro.onexit(function () {
        $('#dashfinalMessagePopup').fadeIn();
    });

    intro.start();

}

function handleIntroPopup(callback) {
    if (localStorage.getItem("first_time_" + currentUserName) != "done") {
        $('#dashwelcomeIntro').fadeIn();

        $('#btndashSkipIntro').off('click').on('click', function () {

            $('#dashwelcomeIntro').fadeOut();

            localStorage.setItem("first_time_" + currentUserName, "done");

            callback(); // ✅ MUST
        });

        $('#btndashStartIntro').off('click').on('click', function () {

            $('#dashwelcomeIntro').fadeOut();

            dash_startDashboardTour();

            localStorage.setItem("first_time_" + currentUserName, "done");

            callback(); // ✅ MUST
        });
    }

}

function core_handleIntroPopup(callback) {

    // Show popup
    $('#dashwelcomeIntro').fadeIn();

    // 🔥 Remove old bindings (VERY IMPORTANT)
    $('#btndashSkipIntro').off('click');
    $('#btndashStartIntro').off('click');

    // Skip button
    $('#btndashSkipIntro').on('click', function () {
        $('#dashwelcomeIntro').fadeOut();

        localStorage.setItem("dashboardIntro2_" + currentUserName, "done");

        callback(); // 👉 move to next popup
    });

    // Start tour
    $('#btndashStartIntro').on('click', function () {
        $('#dashwelcomeIntro').fadeOut();

        dash_startDashboardTour();

        localStorage.setItem("dashboardIntro2_" + currentUserName, "done");

        // 👉 After tour, you can call callback if needed
        callback();
    });
}

/* Birthday */
function dash_ownBirthday(callback) {
    if (localStorage.getItem("lsbirthday_" + currentUserName) == "done") {
        console.log("Self Birthday Already Completed");
        return;
    }
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

                $("#lblBirthdayName").text(data.Name);

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
                localStorage.setItem("lsbirthday_" + currentUserName, "done");


            } catch (e) {
                console.error("Birthday Error:", e);
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

        success: function (res) {

            let data = res.d;

            if (typeof data === "string") {
                try { data = JSON.parse(data); } catch { }
            }

            if (!data || data.length === 0) {
                callback();
                return;
            }

            renderWorkAnniversary(data);

            $('#dash_anniversaryModal').modal('show');

            $('#dash_anniversaryModal')
                .off('hidden.bs.modal')
                .on('hidden.bs.modal', function () {
                    callback();
                });
        },

        error: function () {
            callback();
        }
    });
}

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
            console.error("Anniversary API error");
            callback();
        }
    });
}

function renderWorkAnniversary(data, callback) {

    // ✅ Safety check
    if (!data || data.length === 0) {
        callback();
        return;
    }

    let html = "";

    // ✅ Header (only once)
    let jubilee = getJubileeDetails(data[0].YearsCompleted);

    let headerHtml = (jubilee && jubilee.title)
        ? `<b>💐 WORK ANNIVERSARY - 
            <span style="color:${jubilee.color}; font-weight:bold;">
                ${jubilee.title} 💐
            </span>
           </b>`
        : `<b>💐 WORK ANNIVERSARY 💐</b>`;

    $("#workAnn_header").html(headerHtml);

    // ✅ Cards rendering
    data.forEach(emp => {

        let jubileeEach = getJubileeDetails(emp.YearsCompleted);

        html += `
<div class="employees-card premium-card">

    <div class="company-logo">🏆</div>

    <div class="emps-name">
        ${emp.EmpName}
    </div>

    <div class="emp-designation">
        ${emp.Designation}
    </div>

    <div class="divider"></div>

    <div class="emp-years">
        ${emp.YearsCompleted} Years of Excellence
    </div>

    <div class="anniversary-msg">
        ${(jubileeEach && jubileeEach.message)
                ? jubileeEach.message
                : getAnniversaryMessage(emp.YearsCompleted)}
    </div>

</div>`;
    });

    // ✅ Inject HTML
    $("#dash_anniversaryContainer").html(html);

    // ✅ Modal handling
    let modalEl = document.getElementById('dash_anniversaryModal');

    //let modal = bootstrap.Modal.getInstance(modalEl)
    //    || new bootstrap.Modal(modalEl);

    //modal.show();

    $('#dash_anniversaryModal').modal('show');

    // 🎉 Effects
    startConfetti();

    // ✅ Continue popup sequence
    //modalEl.addEventListener('hidden.bs.modal', function handler() {
    //    modalEl.removeEventListener('hidden.bs.modal', handler);
    //    callback();
    //});


    $('#dash_anniversaryModal').on('hidden.bs.modal', function handler() {
        $('#dash_anniversaryModal').off('hidden.bs.modal', handler);
        callback();
    });
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
function dash_workAnniversary(callback) {

    $.ajax({
        type: "POST",
        url: "DashboardEmployee.aspx/GetEmpWorkAnniversary",

        success: function (res) {

            let data = res.d;

            if (typeof data === "string") {
                try { data = JSON.parse(data); } catch { }
            }

            if (!data || data.length === 0) {
                callback();
                return;
            }

            renderWorkAnniversary(data);

            $('#dash_anniversaryModal').modal('show');

            $('#dash_anniversaryModal')
                .off('hidden.bs.modal')
                .on('hidden.bs.modal', function () {
                    callback();
                });
        },

        error: function () {
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
                <button class="btn btn-wish" onclick="return dash_toggleWishBox(${emp.EmployeeID})">🎉 Wish</button>
            </div>

            <div id="wishBox_${emp.EmployeeID}" class="wish-box mt-2" style="display:none;">
                <input type="text" class="form-control mb-2" placeholder="Write your birthday wish..." id="msg_${emp.Code}" />
                <button class="btn btn-sm btn-success" onclick="return dash_sendWish('${emp.Code}', this)">Send</button>
            </div>
        </div>`;
    });

    $('#dash_birthdayList').html(html);
}

function dash_toggleWishBox(empId) {
    $('.wish-box').hide(); // close others
    $('#wishBox_' + empId).toggle();
    return false;
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
                    console.error("Festival JSON error", e);
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
            console.error("Festival API error");
            callback();
        }
    });
}



function dash_projectNotifications(callback) {

    projectCallback = callback;

    $.ajax({
        type: "POST",
        url: "DashboardEmployee.aspx/GetDashboardProjectAlerts",

        success: function (res) {

            let data = res.d;

            if (typeof data === "string") {
                try { data = JSON.parse(data); } catch { }
            }

            if (!data || data.length === 0) {
                callback();
                return;
            }

            alertsQueue = data;
            currentIndex = 0;

            showProjectAlert();
        },

        error: function () {
            callback();
        }
    });
}

function showProjectAlert() {

    if (currentIndex >= alertsQueue.length) {

        $('#dash_projectNotifications').modal('hide');

        if (projectCallback) projectCallback();

        return;
    }

    let alert = alertsQueue[currentIndex];

    $("#prjN_alertTitle").text(alert.Subject || "");
    $("#prjN_alertMessage").text(alert.Message || "");

    $('#dash_projectNotifications').modal('show');

    $("#btnNextAlert").off("click").on("click", function () {
        currentIndex++;
        showProjectAlert();
    });

    $("#btnClose").off("click").on("click", function () {

        currentIndex = alertsQueue.length;

        $('#dash_projectNotifications').modal('hide');

        if (projectCallback) projectCallback();
    });
}


function showProjectAlert() {

    alert('Project');

    if (currentIndex >= alertsQueue.length) {

        $("#dash_projectNotifications")
            .off('hidden.bs.modal')
            .on('hidden.bs.modal', function () {
                if (localCallback) localCallback();
            });

        $("#dash_projectNotifications").modal("hide");
        return;
    }

    let alert = alertsQueue[currentIndex];

    $("#prjN_alertTitle").text(alert.Subject || "Project Alert");
    $("#prjN_alertMessage").text(alert.Message || "");

    if (alert.Attachment && alert.Attachment.trim() !== "") {
        $("#prjN_attachmentDiv").show();
        $("#prjN_downloadFile").attr("href", alert.Attachment);
    } else {
        $("#prjN_attachmentDiv").hide();
    }

    $("#dash_projectNotifications").modal("show");


    // ✅ NEXT BUTTON FLOW
    $("#btnNextAlert").off("click").on("click", function () {
        let alert = alertsQueue[currentIndex];

        markAsRead(alert.AlertId);

        currentIndex++;
        showProjectAlert();
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
        console.warn("Alert is undefined at index:", currentIndex);

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
        showProjectAlert();
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
            console.log("Alert marked as read:", alertId);
        },

        error: function (err) {
            console.error("Error marking alert as read:", err);
        }
    });
}


/* Password Expiry Notification */
function dash_passwordExpirary(callback) {

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

    $("#btnRemind").off("click").on("click", function () {
        $('#dash_expiryModal').modal('hide');
    });
}


/* Pending Task List */
function dash_PendingTaskNotifications(callback) {

    $.ajax({
        url: "DashboardEmployee.aspx/GetPendingTask",
        type: "POST",

        success: function (res) {

            let data = res.d;

            if (typeof data === "string") {
                try { data = JSON.parse(data); } catch { }
            }

            if (!data || data.length === 0) {
                callback();
                return;
            }

            let html = "";

            data.forEach(function (item) {
                html += `<tr>
                    <td><a href="${item.Url}" target="_blank">${item.Text}</a></td>
                </tr>`;
            });

            $('#dash_tblnotifications tbody').html(html);

            $('#dash_pendingnotifications').modal('show');

            $('#dash_pendingnotifications')
                .off('hidden.bs.modal')
                .on('hidden.bs.modal', function () {
                    callback();
                });
        },

        error: function () {
            callback();
        }
    });
}


