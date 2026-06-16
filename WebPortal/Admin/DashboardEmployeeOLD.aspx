<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="DashboardEmployeeOLD.aspx.cs" Inherits="WebPortal.Admin.DashboardEmployeeOLD" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/intro.js/minified/introjs.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/intro.js/minified/intro.min.js"></script>
    <style>
        .festival-modal {
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 35px rgba(0,0,0,0.25);
        }

        .festival-header {
            background: linear-gradient(45deg,#ff4da6,#ff80bf);
            color: white;
            justify-content: center;
        }

        .festival-title {
            font-weight: bold;
            font-size: 20px;
            text-align: center;
            width: 100%;
        }

        .festival-close {
            position: absolute;
            right: 15px;
            color: white;
            opacity: 1;
        }

        .festival-img {
            max-height: 360px;
            border-radius: 10px;
            animation: zoomIn 0.6s ease;
        }

        .festival-msg {
            margin-top: 12px;
            font-size: 15px;
            color: #555;
            font-weight: 500;
        }

        @keyframes zoomIn {
            from {
                transform: scale(0.7);
                opacity: 0;
            }

            to {
                transform: scale(1);
                opacity: 1;
            }
        }

        .birthday-popup {
            background: linear-gradient(135deg,#ff758c,#ff7eb3,#ffd194);
            color: white;
            border-radius: 20px;
            border: none;
            text-align: center;
            animation: birthdayZoom 0.6s ease;
        }

            .birthday-popup h2 {
                font-size: 32px;
                font-weight: bold;
            }

            .birthday-popup h4 {
                font-weight: bold;
                margin-top: 10px;
            }

            .birthday-popup p {
                font-size: 16px;
            }

            .birthday-popup button {
                border-radius: 25px;
                padding: 8px 25px;
                font-weight: bold;
            }

        @keyframes birthdayZoom {
            from {
                transform: scale(0.5);
                opacity: 0;
            }

            to {
                transform: scale(1);
                opacity: 1;
            }
        }

        .btn-close-birthday {
            position: absolute;
            top: 10px;
            right: 15px;
            background: white;
            border: none;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.2s;
        }

            .btn-close-birthday:hover {
                background: #f0f0f0;
            }
    </style>

    <style>
        #dashboard_alert_table_wrapper .dataTables_scroll {
            height: 225px !important;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: normal !important;
            border: none !important;
        }
    </style>
    <style>
        .loading {
            display: none;
            position: fixed;
            top: 350px;
            left: 50%;
            margin-top: -96px;
            margin-left: -96px;
            /*  background-color: #ccc;*/
            opacity: .85;
            border-radius: 25px;
            width: 192px;
            height: 192px;
            z-index: 99999;
        }

        .dataTables_length, .dataTables_info {
            float: left !important;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: normal !important;
            border: none !important;
        }

        div.dt-buttons {
            position: static;
            float: left;
        }

        .buttons-excel, .buttons-html5 {
            color: #fff;
            /*     background-color: #28a745;
            border-color: #28a745;*/
            box-shadow: none;
            background: linear-gradient(to right, #ffbf96, #fe7096);
            border: 0;
            font-weight: bold;
            margin: 0px 10px;
        }

        .table.dataTable th {
            background: linear-gradient(to bottom, #007bff, 3%, #fff) !important;
            /*background:#4F81BD;*/
            color: #000;
        }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
        }
        /* Profile Header */
        .widget-user-header {
            background: #4F81BD !important;
            color: white;
        }

        /* Dashboard Boxes */
        .box-productivity {
            background: #5DADE2;
            color: white;
        }

        .box-leaves {
            background: #E57373;
            color: white;
        }

        .box-salary {
            background: #66BB6A;
            color: white;
        }

        .box-attendance {
            background: #FFB74D;
            color: #333;
        }

        .box-birthday {
            background: #42A5F5;
            color: white;
        }

        .box-holidays {
            background: #4DB6AC;
            color: white;
        }

        /* Card style */
        .info-box {
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            padding: 10px;
        }
    </style>
    <style>
        .close-btn {
            position: absolute;
            top: 8px;
            right: 10px;
            background: transparent;
            border: none;
            font-size: 18px;
            color: #999;
            cursor: pointer;
        }

            .close-btn:hover {
                color: #333;
            }

        .dashboard-wrapper {
            padding: 15px;
        }

        /* PROFILE CARD */

        .profile-card {
            background: #fff;
            border-radius: 10px;
            padding: 20px;
            display: flex;
            align-items: center;
            box-shadow: 0 3px 10px rgba(0,0,0,0.08);
        }

        .profile-img {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            margin-right: 20px;
        }

        .profile-info h4 {
            font-weight: 600;
            margin-bottom: 5px;
        }

        .profile-info span {
            color: #777;
            font-size: 14px;
        }

        /* STAT BOX */

        .stat-box {
            background: #fff;
            border-radius: 10px;
            text-align: center;
            padding: 20px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.07);
            margin-bottom: 15px;
        }

            .stat-box h4 {
                font-weight: 600;
                margin-bottom: 5px;
            }

            .stat-box span {
                color: #888;
                font-size: 13px;
            }

        /* TABS */

        .profile-tabs {
            margin-top: 20px;
        }

            .profile-tabs .nav-link {
                border-radius: 20px;
                padding: 8px 20px;
            }

        .tab-card {
            background: #fff;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.07);
        }

        .birthday-card {
            background: linear-gradient(135deg, #f8f9fa, #ffffff);
            border-radius: 12px;
            padding: 12px 15px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            transition: 0.3s;
        }

            .birthday-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 14px rgba(0,0,0,0.15);
            }

        .avatar-circle {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            background: linear-gradient(135deg, #4facfe, #00f2fe);
            color: white;
            font-weight: bold;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
        }

        .emp-name {
            font-weight: 600;
            font-size: 14px;
        }

        .emp-meta {
            font-size: 12px;
            color: #6c757d;
        }

        .btn-wish {
            background: linear-gradient(135deg, #28a745, #5cd65c);
            border: none;
            color: white;
            padding: 5px 14px;
            border-radius: 20px;
            font-size: 13px;
            transition: 0.3s;
        }

            .btn-wish:hover {
                transform: scale(1.05);
                background: linear-gradient(135deg, #218838, #4cd137);
            }

        .cake-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, #fff1eb, #ace0f9);
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }

            .cake-avatar img {
                width: 30px;
                height: 30px;
            }

        .wish-box {
            background: #f8f9fa;
            padding: 10px;
            border-radius: 8px;
        }
    </style>
    <style>
        .intro-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.6);
            z-index: 999999;
            backdrop-filter: blur(3px);
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .intro-box {
            background: #ffffff;
            padding: 30px;
            width: 420px;
            border-radius: 12px;
            text-align: left;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            animation: scaleIn 0.3s ease;
        }

            .intro-box h3 {
                margin-bottom: 10px;
                font-size: 22px;
            }

            .intro-box p {
                color: #555;
                font-size: 14px;
            }

        .intro-buttons {
            margin-top: 20px;
            text-align: right;
        }

        .btn-next {
            background: #0d6efd;
            color: white;
            border: none;
            padding: 8px 18px;
            border-radius: 6px;
        }

        .btn-skip {
            background: transparent;
            border: none;
            color: #777;
            margin-right: 10px;
        }

        @keyframes scaleIn {
            from {
                transform: scale(0.7);
                opacity: 0;
            }

            to {
                transform: scale(1);
                opacity: 1;
            }
        }
    </style>
    <style id="intro">
        /* ===== Tooltip Container ===== */
        .introjs-tooltip {
            border-radius: 12px;
            padding: 20px;
            font-family: 'Segoe UI', sans-serif;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            min-width: 280px;
        }

        /* ===== Tooltip Text ===== */
        .introjs-tooltiptext {
            font-size: 14px;
            color: #444;
            line-height: 1.5;
            margin-bottom: 15px;
        }

        /* ===== Header (Optional if title used) ===== */
        .introjs-tooltip-header {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 10px;
        }

        /* ===== Buttons Container ===== */
        .introjs-tooltipbuttons {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        /* ===== Buttons ===== */
        .introjs-button {
            border-radius: 6px;
            padding: 6px 14px;
            font-size: 13px;
            border: none;
            cursor: pointer;
        }

        /* Next Button */
        .introjs-nextbutton {
            background: #0d6efd;
            color: #fff;
        }

        /* Back Button */
        .introjs-prevbutton {
            background: #e9ecef;
            color: #333;
        }

        /* Skip Button */
        .introjs-skipbutton {
            color: #888;
            font-size: 13px;
        }

        /* Hover Effects */
        .introjs-nextbutton:hover {
            background: #4e79a7;
        }

        .introjs-prevbutton:hover {
            background: #d6d8db;
        }

        /* ===== Progress Bar ===== */
        .introjs-progressbar {
            background-color: #4e79a7;
            height: 5px;
            border-radius: 10px;
        }

        /* Progress Container */
        .introjs-progress {
            background-color: #e9ecef;
            border-radius: 10px;
            height: 5px;
            margin-top: 10px;
        }

        /* ===== Tooltip Arrow ===== */
        .introjs-arrow {
            border-width: 8px;
        }

        /* ===== Highlighted Element ===== */
        .introjs-helperLayer {
            border-radius: 10px !important;
            box-shadow: 0 0 0 4px rgba(13,110,253,0.2);
        }

        /* ===== Overlay Background ===== */
        .introjs-overlay {
            background: rgba(0,0,0,0.5);
        }
    </style>
    <script>
        function startDashboardTour() {
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
                $('#finalMessagePopup').fadeIn();
            });

            // ✅ When user skips tour
            intro.onexit(function () {
                $('#finalMessagePopup').fadeIn();
            });

            intro.start();

        }

        function closeBirthdayCard(btn) {
            $(btn).closest('.birthday-card').fadeOut(200, function () {
                $(this).remove(); // optional (remove from DOM)
            });
            return false;
        }

        $(document).ready(function () {

            var currentUserName = '<%= HttpContext.Current.User.Identity.Name.ToString() %>';

            /* loadHrAnniversary();*/
            /* workAnniversary();*/

            //const keyworkAnniversary = "workAnniversary_" + currentUserName;
            //if (!localStorage.getItem(keyworkAnniversary)) {

            //    workAnniversary();
            //    localStorage.setItem(keyworkAnniversary, "true");
            //}
            if (currentUserName == 10161)
                document.getElementById("dash_board").style.display = 'none';
            else
                document.getElementById("dash_board").style.display = '';
            if (currentUserName == 12 || currentUserName == 7036 || currentUserName == 8082 || currentUserName == 8938) {
                document.getElementById("onlymgmt").style.display = '';
                Dashboard_GetManpowerSumary('All');
            }
            else {
                document.getElementById("onlymgmt").style.display = 'none';
            }
            //checkBirthday1();
            //Dashboard_BindFormInformation();
            //getPendingTaskNotifications();
            //Dashboard_GetDashboardAlerts()
            //loadUserprojectnotifications();

            setTimeout(function () {
                $("#festivalModal").modal("show");
            }, 1000);

            var isFirstLogin = localStorage.getItem("dashboardIntro2_" + currentUserName);

            //if (!isFirstLogin) {
            //    $('#welcomeIntro').fadeIn();
            //}
            $('#welcomeIntro').fadeIn();
            // Skip button
            $('#btnSkipIntro').click(function () {
                $('#welcomeIntro').fadeOut();
                localStorage.setItem("dashboardIntro2_" + currentUserName, "done");
                location.reload();
            });

            // Start tour
            $('#btnStartIntro').click(function () {
                $('#welcomeIntro').fadeOut();

                startDashboardTour();

                localStorage.setItem("dashboardIntro2_" + currentUserName, "done");
            });

            if (localStorage.getItem("dashboardIntro2_" + currentUserName) === "done") {
                $.ajax({
                    type: "POST",
                    url: "DashboardEmployee.aspx/CheckBirthday",
                    data: '{}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",

                    success: function (res) {

                        if (res.d.IsBirthday) {
                            const today = new Date().toISOString().slice(0, 10); // YYYY-MM-DD
                            const key = "birthdayShown2_" + today;
                            if (localStorage.getItem(key)) {
                                return; // already shown today
                            }

                            $("#lblBirthdayName").text(res.d.Name);

                            $("#birthdayModal").modal("show");
                            confetti({
                                particleCount: 200,
                                spread: 120,
                                origin: { y: 0.6 }
                            });
                            localStorage.setItem(key, "true");
                        }
                        else {
                            const today = new Date().toISOString().split('T')[0]; // YYYY-MM-DD
                            const lastShown = localStorage.getItem("birthdayPopupShown2_" + currentUserName);

                            if (lastShown !== today) {

                                // Call backend to get birthdays
                                $.ajax({
                                    type: "POST",
                                    url: "DashboardEmployee.aspx/GetTodayBirthdays",
                                    contentType: "application/json",
                                    success: function (res) {

                                        if (res.d && res.d.length > 0) {
                                            var data = JSON.parse(res.d);
                                            renderBirthdayPopup(data);

                                            $('#birthdayModal_all').modal('show');

                                            // ✅ Mark as shown for today
                                            localStorage.setItem("birthdayPopupShown2_" + currentUserName, today);
                                        }
                                        else {

                                            getPendingTaskNotifications();  // Important Not
                                            Dashboard_GetDashboardAlerts(); // Last One
                                            loadUserprojectnotifications(); // Project Not
                                            setTimeout(function () {
                                                $("#festivalModal").modal("show");
                                            }, 1000);
                                        }
                                    }
                                });
                            }
                            else {

                                getPendingTaskNotifications();
                                Dashboard_GetDashboardAlerts()
                                loadUserprojectnotifications();
                                setTimeout(function () {
                                    $("#festivalModal").modal("show");
                                }, 1000);
                            }
                        }
                    }
                });
            }
        });

        function toggleWishBox(empId) {
            $('.wish-box').hide(); // close others
            $('#wishBox_' + empId).toggle();
            return false;
        }

        function renderBirthdayPopup(data) {

            if (typeof data === "string") {
                data = JSON.parse(data);
            }

            let html = '';

            data.forEach(emp => {

                // Generate initials for avatar
                let initials = emp.Name.split(' ')
                    .map(x => x[0])
                    .join('')
                    .substring(0, 2);

                let bg = getAvatarColor(emp.Name);

                html += `
        <div class="birthday-card d-flex flex-column mb-3">
        
    <div class="d-flex align-items-center justify-content-between">

        <div class="d-flex align-items-center">
            <div class="cake-avatar" style="margin-right:10px;">
                <img src="../images/cake.png" />
            </div>

            <div class="ms-3">
                <div class="emp-name">${emp.Name}</div>
                <div class="emp-meta">
                    ${emp.Code} | ${emp.BranchName} | ${emp.DepartmentName}
                </div>
            </div>
        </div>

        <button class="btn btn-wish" onclick="return toggleWishBox(${emp.EmployeeID})">
            🎉 Wish
        </button>

    </div>

    <!-- Hidden message box -->
    <div id="wishBox_${emp.EmployeeID}" class="wish-box mt-2" style="display:none;">
        <input type="text" class="form-control mb-2" 
            placeholder="Write your birthday wish..." 
            id="msg_${emp.Code}" />

        <button class="btn btn-sm btn-success"
            onclick="return dash_sendWish('${emp.Code}', this)">
            Send
        </button>
    </div>

</div>`;
            });

            $('#birthdayList').html(html);
        }

        function getAvatarColor(name) {
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

    </script>

    <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="modal fade" id="birthdayModal_all">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5>🎉 Today's Birthdays</h5>
                    <button type="button" class="close" onclick="location.reload();">
                        <span>&times;</span>
                    </button>
                </div>
                <div class="modal-body" id="birthdayList"></div>
            </div>
        </div>
    </div>

    <div id="alertModal" class="modal fade" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">

                <div class="modal-header navbar-white text-white">
                    <h5 class="modal-title" id="alertTitle"></h5>

                </div>

                <div class="modal-body">
                    <p id="alertMessage"></p>

                    <div id="attachmentDiv" style="display: none;">
                        <a id="downloadFile" class="btn btn-outline-primary" target="_blank">Download Attachment
                        </a>
                    </div>
                </div>

                <div class="modal-footer">
                    <button class="btn btn-primary" onclick="return GotToNextAlert();">Mark as read</button>
                    <button id="btnClose" class="btn btn-secondary" data-bs-dismiss="modal">
                        Close
   
                    </button>
                </div>

            </div>
        </div>
    </div>

    <div class="modal fade" id="festWish_PopUp">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content festival-modal">
                <div class="modal-header festival-header">
                    <h5 id="popupGreeting" class="festival-title"></h5>
                    <button type="button" class="close festival-close" data-dismiss="modal">
                        <span>&times;</span>
                    </button>
                </div>

                <div class="modal-body text-center">
                    <img id="festivalImage" class="rounded zoom-start" style="width: 100%; max-width: 500px;">
                    <%-- <img src="../FestivalWishesImages/WomenDay.jpg" class="rounded zoom-start" style="width: 100%; max-width: 500px;">--%>
                </div>

            </div>
        </div>
    </div>

    <div class="row dashboard-row" style="padding-top: 10px; display: none;" id="dash_board" data-intro="This is your main dashboard." data-step="1">
        <div class="col-md-4">
            <!-- Widget: user widget style 1 -->
            <div class="card card-widget widget-user shadow" style="height: 270px;" data-intro="Here you can quickly access your Productivity, Attendance, and Profile details in one place." data-step="2">
                <!-- Add the bg color to the header using any of the bg-* classes -->
                <div class="widget-user-header bg-gradient-success">
                    <h3 class="widget-user-username" id="dashboard_spnusername" onclick="return dashboard_profileinfo();" style="font-style: italic; font-weight: bold; cursor: pointer; text-decoration: underline;"></h3>
                    <h6 class="widget-user-desc" id="dashboard_spndesignation"></h6>
                </div>
                <div class="widget-user-image">
                    <img class="img-circle elevation-2" id="dashboard_userimg" alt="User Avatar" />
                </div>
                <div class="card-footer">
                    <div class="row">
                        <div class="col-sm-4 border-right" data-intro="<b>Your Performance</b> <br /> Your monthly productivity here with production count, percentage and grading" data-step="3">
                            <div class="description-block">
                                <i class="uil uil-chart-bar" style="font-size: 28px; color: #4F81BD;"></i>
                                <br>
                                <span class="description-text"><a href="DasboardPerformanceDetails.aspx" style="text-decoration: underline;">Productivity</a></span>
                            </div>
                            <!-- /.description-block -->
                        </div>
                        <!-- /.col -->
                        <div class="col-sm-4 border-right" data-intro="<b>Your Attendance Overview</b> <br /> View your daily attendance, login details, and working status." data-step="4">
                            <div class="description-block">
                                <i class="uil uil-calendar-alt" style="font-size: 28px; color: #4F81BD;"></i>
                                <br>
                                <span class="description-text"><a href="Log.aspx" style="text-decoration: underline;">Attendance</a></span>
                            </div>
                            <!-- /.description-block -->
                        </div>
                        <!-- /.col -->
                        <div class="col-sm-4" data-intro="<b>Your Profile Info.</b> <br /> You can access your personal and official information here." data-step="5">
                            <div class="description-block">
                                <i class="uil uil-user-circle" style="font-size: 28px; color: #4F81BD;"></i>
                                <br>
                                <span class="description-text"><a href="#url" onclick="return dashboard_profileinfo();" style="text-decoration: underline;">Profile Info.</a></span>
                            </div>
                            <!-- /.description-block -->
                        </div>
                        <!-- /.col -->
                    </div>
                    <!-- /.row -->
                </div>
            </div>
            <!-- /.widget-user -->
        </div>
        <div class="col-md-2">
            <!-- Info Boxes Style 2 -->
            <div class="info-box mb-3 box-productivity" data-intro="<b>Track Your Productivity</b> <br /> Please ensure you update your daily productivity before logging out." data-step="6">
                <span class="info-box-icon"><i class="far fa-chart-bar"></i></span>

                <div class="info-box-content">
                    <a class="animation__shake" style="color: white;" href="DailyProductivity.aspx">
                        <span class="info-box-number">Daily Productivity</span></a>
                </div>
                <!-- /.info-box-content -->
            </div>
            <!-- /.info-box -->
            <div class="info-box mb-3 box-salary" data-intro="<b>Salary Insights</b> <br />Review your proposed salary details and breakdown." data-step="7">
                <span class="info-box-icon"><i class="fa fa-circle-notch"></i></span>

                <div class="info-box-content">
                    <a class="animation__shake" style="color: white;" href="ProposedSalaryReport.aspx">
                        <span class="info-box-number">Proposed Salary Report</span></a>
                </div>
                <!-- /.info-box-content -->
            </div>
            <div class="info-box mb-3 box-birthday" data-intro="<b>Celebrate Your Team 🎉</b> <br />See who’s celebrating their birthday today and send wishes." data-step="8">
                <span class="info-box-icon"><i class="fas fa-birthday-cake"></i></span>

                <div class="info-box-content">
                    <a class="animation__shake" style="color: white;" href="ViewBirthdays.aspx">
                        <span class="info-box-number">Today's Birthday</span></a>
                </div>
                <!-- /.info-box-content -->
            </div>

        </div>
        <div class="col-md-2">
            <!-- /.info-box -->
            <div class="info-box mb-3 box-leaves" data-intro="<b>Manage Your Leaves</b> <br />Apply for leave, check balances, and track your requests." data-step="9">
                <span class="info-box-icon"><i class="fas fa-luggage-cart"></i></span>

                <div class="info-box-content">
                    <a class="animation__shake" style="color: white;" href="SelfLeaves.aspx">
                        <span class="info-box-number">My Leaves</span></a>
                </div>
                <!-- /.info-box-content -->
            </div>
            <!-- /.info-box -->
            <div class="info-box mb-3 box-attendance" data-intro="<b>Fix Attendance Issues</b> <br />Submit requests to correct missing or incorrect attendance." data-step="10">
                <span class="info-box-icon"><i class="fas fa-check"></i></span>

                <div class="info-box-content">
                    <a class="animation__shake" style="color: black;" href="AttendanceCorrectionSelf.aspx">
                        <span class="info-box-number">Attendance Corrections</span></a>
                </div>
                <!-- /.info-box-content -->
            </div>
            <div class="info-box mb-3 box-holidays" data-intro="<b><b>Plan Your Schedule</b> <br /></b> <br />View upcoming client holidays and plan your work accordingly." data-step="11">
                <span class="info-box-icon"><i class="fas fa-list-ol"></i></span>

                <div class="info-box-content">
                    <a class="animation__shake" style="color: white;" href="#" data-target="#ClientHolidays" data-toggle="modal">
                        <span class="info-box-number" data-target="ClientHolidays" data-toggle="modal">Client Holidays List</span></a>
                </div>
                <!-- /.info-box-content -->
            </div>


        </div>
        <div class="col-md-4" data-intro="<b>Stay Updated</b> Check important announcements, system updates, and action items here." data-step="12">
            <div class="card">
                <div class="card-header ui-sortable-handle" style="padding: 5px 1.25rem!important;">
                    <h3 class="card-title">
                        <i class="fas fa-info-circle mr-1"></i>
                        Important Notifications
                    </h3>
                    <div class="card-tools">
                        <%--<a class="nav-link active" href="Notifications.aspx">View All</a>--%>
                    </div>
                </div>
                <table class="table" id="dashboard_alert_table" style="padding-top: 0px; font-size: 11px; width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="display: none;">Alert Id</th>
                            <th class="sort border-top ps-3" style="display: none;">Sr. #</th>
                            <th class="sort border-top ps-3">Subject</th>
                            <th class="sort border-top ps-3">Attachment</th>
                            <th class="sort border-top ps-3">View</th>
                            <th class="sort border-top ps-3" style="display: none;">Attachment</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-12">
            <div class="card" id="onlymgmt">
                <div class="card-header">
                    <h5 class="card-title">Branch > Domain > Subdomain wise Manpower Summary</h5>

                    <div class="card-tools">
                        <strong id="dashboard_graphperiod">Period: </strong>
                        <div class="btn-group">
                            <button type="button" class="btn btn-tool dropdown-toggle" data-toggle="dropdown">
                                <i class="fas fa-wrench"></i>&nbsp;&nbsp;<span style="font-size: 12px;" id="summary_gridheaderfilter">All Employees</span>
                            </button>
                            <div class="dropdown-menu dropdown-menu-right" role="menu">
                                <a href="#" class="dropdown-item" onclick="return Dashboard_GetManpowerSumary('All');">All Employees</a>
                                <a href="#" class="dropdown-item" onclick="return Dashboard_GetManpowerSumary('Present');">Present Today</a>
                                <a href="#" class="dropdown-item" onclick="return Dashboard_GetManpowerSumary('Leave');">Users on Leave</a>
                            </div>
                        </div>

                    </div>
                </div>
                <!-- /.card-header -->
                <div class="card-body">
                    <div class="row">

                        <div class="col-md-12">
                            <table class="table" id="dasboard_currentmanpower" style="width: 100%;">
                                <thead>
                                    <tr>
                                        <th class="sort border-top ps-3" style="display: none;">Sr. #</th>
                                        <th class="sort border-top ps-3" style="display: none;">Sr. #</th>
                                        <th class="sort border-top ps-3" style="display: none;">Sr. #</th>
                                        <th class="sort border-top ps-3">Branch</th>
                                        <th class="sort border-top ps-3">Domain</th>
                                        <th class="sort border-top ps-3">Subdomain</th>
                                        <th class="sort border-top ps-3" style="text-align: center;">Total</th>
                                        <th class="sort border-top ps-3" style="text-align: center;">On Floor</th>
                                        <th class="sort border-top ps-3" style="text-align: center;">Resigned</th>
                                        <th class="sort border-top ps-3" style="text-align: center;">Absconding</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                        <!-- /.col -->
                    </div>
                    <!-- /.row -->
                </div>
                <!-- ./card-body -->
                <div class="card-footer">
                    <div class="row">
                        <div class="col-sm-3 col-6">
                            <div class="description-block border-right">
                                <h5 class="description-header" id="dashboard_totalemployees"></h5>
                                <span class="description-text">TOTAL EMPLOYEES</span>
                            </div>
                            <!-- /.description-block -->
                        </div>
                        <!-- /.col -->
                        <div class="col-sm-3 col-6">
                            <div class="description-block border-right">
                                <h5 class="description-header" id="dashboard_onfloormployees"></h5>
                                <span class="description-text">TOTAL ON FLOOR</span>
                            </div>
                            <!-- /.description-block -->
                        </div>
                        <!-- /.col -->
                        <div class="col-sm-3 col-6">
                            <div class="description-block border-right">
                                <h5 class="description-header" id="dashboard_resignedemployees"></h5>
                                <span class="description-text">TOTAL RESIGNED</span>
                            </div>
                            <!-- /.description-block -->
                        </div>
                        <!-- /.col -->
                        <div class="col-sm-3 col-6">
                            <div class="description-block">
                                <h5 class="description-header" id="dashboard_abscondingemployees"></h5>
                                <span class="description-text">TOTAL ABSCONDING</span>
                            </div>
                            <!-- /.description-block -->
                        </div>
                    </div>
                    <!-- /.row -->
                </div>
                <!-- /.card-footer -->
            </div>
            <!-- /.card -->
        </div>
        <!-- /.col -->
    </div>

    <div class="modal fade" id="dashboard_profileinfopopup">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Profile Information</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body card-primary card-outline">
                    <div class="card card-tabs">
                        <div class="card-header p-0 pt-1">
                            <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                                <li class="nav-item">
                                    <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Personal Information</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">Official Information</a>
                                </li>

                            </ul>
                        </div>
                        <div class="card-body">
                            <div class="tab-content" id="custom-tabs-one-tabContent">
                                <input id="filep" style="display: none;" />
                                <asp:HiddenField ID="filepath" runat="server" />
                                <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                                    <div class="col-sm-12">
                                        <table class="table">
                                            <tr>
                                                <td><b>Name:</b></td>
                                                <td>
                                                    <label id="dasboard_popname" class="form-control" style="width: 350px;"></label>
                                                </td>
                                                <td><b>Date of Birth:</b></td>
                                                <td>
                                                    <label id="dasboard_popdob" class="form-control" style="width: 350px;"></label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><b>Present Address:</b></td>
                                                <td>
                                                    <label id="dasboard_poppresentaddress" class="form-control" style="width: 350px;"></label>
                                                </td>
                                                <td><b>Permanent Address:</b></td>
                                                <td>
                                                    <label id="dasboard_poppermanentaddress" class="form-control" style="width: 350px;"></label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><b>Contact #:</b></td>
                                                <td>
                                                    <label id="dasboard_popcontact" class="form-control" style="width: 350px;"></label>
                                                </td>
                                                <td><b>PAN:</b></td>
                                                <td>
                                                    <label id="dasboard_poppan" class="form-control" style="width: 350px;"></label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><b>Qualification:</b></td>
                                                <td>
                                                    <label id="dasboard_popqualification" class="form-control" style="width: 350px;"></label>
                                                </td>
                                                <td><b>Blood Group:</b></td>
                                                <td>
                                                    <label id="dasboard_popbloodgroup" class="form-control" style="width: 350px;"></label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><b>Email Address:</b></td>
                                                <td>
                                                    <label id="dasboard_popemail" class="form-control" style="width: 350px;"></label>
                                                </td>
                                                <td></td>
                                                <td></td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                                <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                                    <div class="col-sm-12">
                                        <table class="table">
                                            <tr>
                                                <td><b>Employee ID:</b></td>
                                                <td>
                                                    <label id="dasboard_popemployeeid" class="form-control" style="width: 350px;"></label>
                                                </td>
                                                <td><b>Code:</b></td>
                                                <td>
                                                    <label id="dasboard_popcode" class="form-control" style="width: 350px;"></label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><b>Joining Date:</b></td>
                                                <td>
                                                    <label id="dasboard_popjoiningdate" class="form-control" style="width: 350px;"></label>
                                                </td>
                                                <td><b>Working Branch:</b></td>
                                                <td>
                                                    <label id="dasboard_popbranch" class="form-control" style="width: 350px;"></label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><b>Department:</b></td>
                                                <td>
                                                    <label id="dasboard_popdepartment" class="form-control" style="width: 350px;"></label>
                                                </td>
                                                <td><b>Designation:</b></td>
                                                <td>
                                                    <label id="dasboard_popdesignation" class="form-control" style="width: 350px;"></label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><b>Shift:</b></td>
                                                <td>
                                                    <label id="dasboard_popshift" class="form-control" style="width: 350px;"></label>
                                                </td>
                                                <td><b>Working Hours:</b></td>
                                                <td>
                                                    <label id="dasboard_popworkinghours" class="form-control" style="width: 350px;"></label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><b>Cut off Time:</b></td>
                                                <td>
                                                    <label id="dasboard_popcutofftime" class="form-control" style="width: 350px;"></label>
                                                </td>
                                                <td><b>Weekly Holiday:</b></td>
                                                <td>
                                                    <label id="dasboard_popweeklyholiday" class="form-control" style="width: 350px;"></label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><b>Official Email:</b></td>
                                                <td>
                                                    <label id="dasboard_popofficialemail" class="form-control" style="width: 350px;"></label>
                                                </td>
                                                <td><b>Bank Name:</b></td>
                                                <td>
                                                    <label id="dasboard_popbankname" class="form-control" style="width: 350px;"></label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><b>Account #:</b></td>
                                                <td>
                                                    <label id="dasboard_popaccountno" class="form-control" style="width: 350px;"></label>
                                                </td>
                                                <td><b>IFSC Code:</b></td>
                                                <td>
                                                    <label id="dasboard_popifsccode" class="form-control" style="width: 350px;"></label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><b>EISC #:</b></td>
                                                <td>
                                                    <label id="dasboard_popesicno" class="form-control" style="width: 350px;"></label>
                                                </td>
                                                <td><b>PF #:</b></td>
                                                <td>
                                                    <label id="dasboard_poppfno" class="form-control" style="width: 350px;"></label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><b>UAN:</b></td>
                                                <td>
                                                    <label id="dasboard_popuan" class="form-control" style="width: 350px;"></label>
                                                </td>
                                                <td><b>Reporting Manager:</b></td>
                                                <td>
                                                    <label id="dasboard_popreportingmanager" class="form-control" style="width: 350px;"></label>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>



                            </div>
                        </div>
                        <div class="modal-footer justify-content-between">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                        </div>
                    </div>
                    <!-- /.modal-content -->
                </div>
                <!-- /.modal-dialog -->
            </div>
        </div>
    </div>

    <div class="modal fade" id="dashboard_alertdetails">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Important Notification</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body card-primary card-outline">
                    <div class="card card-tabs">
                        <table class="table table-borderless">
                            <tr>
                                <td><b>Subject:</b></td>
                                <td>
                                    <label id="dasboard_popalertsubject" class="form-control" style="border: none;"></label>
                                </td>
                            </tr>
                            <tr>
                                <td><b>Message:</b></td>
                                <td>
                                    <label id="dasboard_popalertmessage" class="form-control" style="border: none; min-height: 100px; height: auto;"></label>
                                </td>
                            </tr>

                        </table>

                    </div>
                    <div class="modal-footer justify-content-between">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    </div>
                </div>
                <!-- /.modal-content -->
                <!-- /.modal-dialog -->
            </div>
        </div>
    </div>

    <div class="modal fade" id="dashboard_summarydetails">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="details_popupheader">Employee Details</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body card-primary card-outline">
                    <div class="card card-tabs" style="min-height: 400px; height: auto;">
                        <table class="table" id="details_table" style="width: 100%; font-size: 10px!important;">
                            <thead>
                                <tr>
                                    <th class="sort border-top ps-3">Sr. #</th>
                                    <th class="sort border-top ps-3">Code</th>
                                    <th class="sort border-top ps-3">Employee Name</th>
                                    <th class="sort border-top ps-3">Joining Date</th>
                                    <th class="sort border-top ps-3">Branch</th>
                                    <th class="sort border-top ps-3">Domain</th>
                                    <th class="sort border-top ps-3">Subdomain</th>
                                    <th class="sort border-top ps-3">Departmnet</th>
                                    <th class="sort border-top ps-3">Designation</th>
                                    <th class="sort border-top ps-3">Reporting Manager</th>
                                    <th class="sort border-top ps-3">Domain Head</th>
                                    <th class="sort border-top ps-3">Resignation Type</th>
                                    <th class="sort border-top ps-3">Resignation Date</th>
                                    <th class="sort border-top ps-3">Last Working Date</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>

                    </div>
                    <div class="modal-footer justify-content-between">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    </div>
                </div>
                <!-- /.modal-content -->
                <!-- /.modal-dialog -->
            </div>
        </div>
    </div>

    <div class="modal fade" id="dash_notifications" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="staticBackdropLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl" role="document">
            <div class="modal-content">
                <div class="modal-header bg-danger">
                    <h5 class="modal-title" id="staticBackdropLabel"><i class="fas fa-bell"></i>&nbsp;&nbsp;Pending Task List</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body" style="min-height: 400px; height: auto;">
                    <table id="dash_tblnotifications" class="table" style="width: 100%;">
                        <thead>
                            <tr>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="ClientHolidays" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="ClientHolidaysLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="ClientHolidaysLabel">Client Holidays</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table id="ClientHolidayList" runat="server" class="table table-bordered">
                        <tr>
                            <th style="border-bottom: solid 1px gray;">Holiday Name</th>
                            <th style="border-bottom: solid 1px gray;">Day</th>
                            <th style="border-bottom: solid 1px gray;">Date</th>
                        </tr>

                        <tr>
                            <td>New Year's Day</td>
                            <td>Monday</td>
                            <td>01-January</td>
                        </tr>
                        <tr>
                            <td>Memorial Day</td>
                            <td>Monday</td>
                            <td>27-May</td>
                        </tr>
                        <tr>
                            <td>Independence Day</td>
                            <td>Thursday</td>
                            <td>04-July</td>
                        </tr>
                        <tr>
                            <td>Labor Day</td>
                            <td>Monday</td>
                            <td>02-September</td>
                        </tr>
                        <tr>
                            <td>Thanks Giving Day</td>
                            <td>Thursday</td>
                            <td>28-November</td>
                        </tr>
                        <tr>
                            <td>Christmas Day</td>
                            <td>Wednesday</td>
                            <td>25-December</td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="birthdayModal" data-bs-backdrop="static"
        data-bs-keyboard="false" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content birthday-popup">

                <div class="modal-body text-center position-relative">
                    <!-- Close button -->
                    <button class="btn-close-birthday"
                        data-bs-dismiss="modal" onclick="return insertselfbirthdayreminder();">
                        ✖                
                    </button>
                    <h2>🎉 Happy Birthday!</h2>

                    <h4 id="lblBirthdayName"></h4>

                    <p>Wishing you a wonderful year ahead!</p>


                </div>

            </div>
        </div>
    </div>

    <div id="welcomeIntro" class="intro-overlay" style="display: none;">
        <div class="intro-box">
            <h3>Welcome to Your Workspace 👋</h3>
            <p>Let’s walk you through the main features to help you get started.</p>

            <div class="intro-buttons">
                <button id="btnSkipIntro" type="button" class="btn-skip">Skip</button>
                <button id="btnStartIntro" type="button" class="btn-next">Next</button>
            </div>
        </div>
    </div>

    <div id="finalMessagePopup" class="intro-overlay" style="display: none;">
        <div class="intro-box">
            <h3>You're All Set 🎉</h3>
            <p>
                You are now ready to explore the new ERP system.  
            Please use the platform and share your valuable feedback with us.
       
            </p>

            <div class="intro-buttons">
                <button id="btnCloseFinal" class="btn-next">Got It</button>
            </div>
        </div>
    </div>

    <div class="modal fade" id="anniversaryModal">
        <div class="modal-dialogs modal-dialog-centered">
            <div class="modal-content anniversary-modal">

                <div class="modal-header text-center" style="font-family: Britannic Bold;">
                    <h4 class="modal-title w-100"><span id="workAnn_header"></span></h4>
                    <%--<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span>&times;</span></button>--%>
                    <button class="btn-close-birthday"
                        data-bs-dismiss="modal" onclick="return showantherPopUp();">
                        ✖                
                    </button>
                </div>
                <div class="modal-body">
                    <div id="anniversaryContainer" class="row text-center">
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style>
        /* Modal Size */
        .modal-dialogs {
            max-width: 650px;
            max-height: 900px;
            margin: 40px auto;
        }

        /* Outer Panel */
        .anniversary-modal {
            background: linear-gradient(to right, #6fa0d6 0%, #4F81BD 50%, #2f5f9e 100%) !important;
            backdrop-filter: blur(12px);
            border: 2px solid #4F81BD;
            border-radius: 25px;
            box-shadow: 0 20px 50px rgba(47, 95, 158, 0.4);
            color: #fff;
            animation: popupAnimation 0.4s ease;
            position: relative;
            overflow: hidden;
            padding: 28px;
        }

            /* Floating Particles */
            .anniversary-modal::before {
                content: "";
                position: absolute;
                width: 200%;
                height: 200%;
                background-image: radial-gradient(circle, rgba(255,255,255,0.4) 2px, transparent 2px);
                background-size: 40px 40px;
                animation: moveParticles 20s linear infinite;
                opacity: 0.4;
            }

        @keyframes moveParticles {
            from {
                transform: translateY(0);
            }

            to {
                transform: translateY(-200px);
            }
        }

        /* Inner Card */
        .employees-card {
            padding: 35px;
            background: #ffffff;
            border-radius: 22px;
            text-align: center;
            border: 2px solid #4F81BD;
            box-shadow: 0 10px 30px rgba(47, 95, 158, 0.25);
            transition: 0.3s;
            width: 90%;
            max-width: 460px;
            min-height: 330px;
            margin: 0 auto;
            color: #2f5f9e;
            position: relative;
            overflow: hidden;
        }

            /* Shine Effect */
            .employees-card::after {
                content: "";
                position: absolute;
                top: -50%;
                left: -50%;
                width: 200%;
                height: 200%;
                background: linear-gradient( 120deg, transparent, rgba(255,255,255,0.5), transparent );
                transform: rotate(25deg);
                animation: shine 5s infinite;
            }



        @keyframes shine {
            0% {
                transform: translateX(-100%) rotate(25deg);
            }

            100% {
                transform: translateX(100%) rotate(25deg);
            }
        }

        /* Photo Glow Ring */
        .emp-photo {
            width: 125px;
            height: 125px;
            border-radius: 50%;
            border: 4px solid white;
            object-fit: cover;
            margin-bottom: 15px;
            animation: glowRing 2s infinite alternate;
        }

        @keyframes glowRing {
            from {
                box-shadow: 0 0 10px #4F81BD;
            }

            to {
                box-shadow: 0 0 25px #6fa0d6;
            }
        }

        /* Text */
        .emps-name {
            font-weight: bold;
            font-size: 22px;
            color: #2f5f9e;
        }

        .emp-designation {
            font-size: 15px;
            color: #4F81BD;
            margin-bottom: 10px;
            margin-top: 20px;
        }

        .divider-line {
            height: 2px;
            background: #4F81BD;
            margin: 15px 0;
        }

        /* Years Badge */
        .emp-years {
            display: inline-block;
            background: #2f5f9e;
            color: white;
            padding: 8px 18px;
            border-radius: 25px;
            font-size: 14px;
            margin-top: 10px;
            font-weight: bold;
        }

        /* Popup Animation */
        @keyframes popupAnimation {
            from {
                transform: scale(0.8);
                opacity: 0;
            }

            to {
                transform: scale(1);
                opacity: 1;
            }
        }

        .company-logo {
            font-size: 40px;
            margin-bottom: 10px;
            animation: floatLogo 3s ease-in-out infinite;
        }
        /* Title */
        .anniversary-title {
            font-size: 22px;
            color: #2f5f9e;
            margin-bottom: 10px;
            font-family: Georgia;
        }


        /* Anniversary Message */
        .anniversary-msg {
            margin-top: 25px;
            font-size: 15px;
            color: #2f5f9e !important;
            font-style: italic;
            font-family: Georgia !important;
            font-weight: bold !important;
        }
    </style>

    <div id="hrAnniversaryModal" class="hr-modal">
        <div class="hr-modal-box">

            <div class="hr-modal-header">
                <%--  <img src="../images/WorkAnniversary.jpg">--%>
                <h3>🎉 Today's Work Anniversaries</h3>
                <span class="hr-close" onclick="closeHrModal()">×</span>
            </div>
            <%--   <div class="hr-banner">
             
            </div>--%>
            <div class="hr-modal-body">
                <div id="hrAnniversaryCards" class="hr-card-container"></div>
            </div>

            <%--            <div class="hr-modal-footer">
                <button onclick="closeHrModal()">Close</button>
            </div>--%>
        </div>
    </div>

    <style>
        .hr-banner img {
            width: 100%;
            height: 120px;
            object-fit: cover;
        }

        .hr-modal {
            display: none;
            position: fixed;
            z-index: 9999;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
        }

        .hr-modal-box {
            background: #fff;
            width: 650px;
            margin: 6% auto;
            border-radius: 10px;
            overflow: hidden;
        }

        .hr-modal-header {
            background: #2e8b57;
            color: white;
            padding: 14px;
            font-size: 18px;
            display: flex;
            justify-content: space-between;
        }

        .hr-modal-body {
            padding: 20px;
            max-height: 350px;
            overflow-y: auto;
        }

        .hr-modal-footer {
            padding: 10px;
            text-align: right;
        }

        .hr-close {
            cursor: pointer;
            font-size: 22px;
        }

        /* Cards */
        .hr-card-container {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .hr-card {
            width: 48%;
            background: #f5f5f5;
            padding: 12px;
            border-radius: 8px;
            border-left: 5px solid #2e8b57;
        }

        .hr-card-name {
            font-weight: bold;
            font-size: 16px;
        }

        .hr-card-dept {
            font-size: 13px;
            color: #555;
        }

        .hr-card-years {
            margin-top: 5px;
            color: #2e8b57;
            font-weight: bold;
        }
    </style>


    <div id="expiryModal" class="modal fade">
        <div class="erp-modal-box">

            <div class="erp-modal-header warning-header">
                <h2>Password Expiry Notice</h2>
                <p id="expiryText"></p>
            </div>

            <div class="erp-modal-body">
                <p>
                    Your ERP password is about to expire.
                Please reset your password to avoid interruption.
                </p>
            </div>

            <div class="erp-modal-footer">
                <button type="button" class="btn-secondary" onclick="closePasswprdPopUp()">Remind Me Later</button>
                <a href="ChangePassword.aspx" class="btn-primary">Reset Password</a>
            </div>

        </div>
    </div>

    <style>
        .erp-modal {
            /* display: none;*/
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.6);
            z-index: 9999;
            font-family: Segoe UI;
        }

        .erp-modal-box {
            width: 420px;
            margin: 8% auto;
            background: #fff;
            border-radius: 10px;
            overflow: hidden;
        }

        .primary-header {
            background: #007bff;
            color: white;
            padding: 18px;
            text-align: center;
        }

        .warning-header {
            /*background: #ff9800;*/
            background: linear-gradient(to right, #90caf9, 10%, #047edf);
            color: white;
            padding: 18px;
            text-align: center;
        }

        .erp-modal-body {
            padding: 20px;
            font-size: 15px;
        }

        .erp-modal-footer {
            padding: 15px;
            text-align: right;
            border-top: 1px solid #eee;
        }

        .input-group {
            margin-bottom: 12px;
        }

            .input-group input {
                width: 100%;
                padding: 8px;
            }

        .btn-primary {
            background: #047edf; /* #28a745;*/
            color: #fff;
            padding: 8px 14px;
            border: none;
        }

        .btn-secondary {
            background: #ccc;
            padding: 8px 14px;
            border: none;
        }
    </style>

</asp:Content>
