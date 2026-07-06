<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="HRReport.aspx.cs" Inherits="WebPortal.Admin.HRReport" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        function hr_Submit() {
            __doPostBack("<%= btn1.UniqueID %>", '');
            return false;
        }
    </script>
    <style>
        :root {
            --hr-primary: #1d4ed8;
            --hr-primary-2: #2563eb;
            --hr-accent: #22c1dc;
            --hr-bg: #f4f7fb;
            --hr-card: #ffffff;
            --hr-text: #0f172a;
            --hr-muted: #64748b;
            --hr-border: #e2e8f0;
            --hr-shadow: 0 18px 45px rgba(15, 23, 42, .10);
        }

        .hr-page {
            padding: 14px 14px 28px;
            background: var(--hr-bg);
            min-height: calc(100vh - 120px);
        }

        .hr-hero {
            position: relative;
            overflow: hidden;
            border-radius: 18px;
            padding: 22px 24px;
            background: linear-gradient(120deg, var(--hr-primary) 0%, var(--hr-primary-2) 62%, var(--hr-accent) 100%);
            color: #fff;
            box-shadow: var(--hr-shadow);
            margin-bottom: 18px;
        }

            .hr-hero::after {
                content: "";
                position: absolute;
                width: 210px;
                height: 210px;
                right: -70px;
                top: -80px;
                border-radius: 50%;
                background: rgba(255, 255, 255, .16);
            }

        .hr-hero-inner {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            flex-wrap: wrap;
        }

        .hr-hero-title-wrap {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .hr-hero-icon {
            width: 52px;
            height: 52px;
            border-radius: 16px;
            background: rgba(255, 255, 255, .18);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            box-shadow: inset 0 0 0 1px rgba(255, 255, 255, .22);
        }

        .hr-hero h4 {
            margin: 0;
            font-size: 22px;
            font-weight: 800;
            letter-spacing: .2px;
        }

        .hr-hero p {
            margin: 4px 0 0;
            color: rgba(255, 255, 255, .88);
            font-size: 13px;
        }

        .hr-chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 13px;
            border-radius: 999px;
            background: rgba(255, 255, 255, .18);
            color: #fff;
            font-size: 13px;
            font-weight: 700;
            white-space: nowrap;
        }

        .hr-panel {
            background: var(--hr-card);
            border: 1px solid var(--hr-border);
            border-radius: 18px;
            box-shadow: 0 14px 35px rgba(15, 23, 42, .08);
            overflow: hidden;
        }

        .hr-panel-head {
            padding: 15px 18px;
            border-bottom: 1px solid var(--hr-border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            background: linear-gradient(180deg, #ffffff 0%, #f8fafc 100%);
        }

            .hr-panel-head h5 {
                margin: 0;
                font-weight: 800;
                color: var(--hr-text);
                font-size: 16px;
            }

            .hr-panel-head span {
                color: var(--hr-muted);
                font-size: 12px;
                font-weight: 600;
            }

        .hr-form {
            padding: 18px;
        }

        .hr-form-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(180px, 1fr));
            gap: 16px;
            align-items: end;
        }

        .hr-field label {
            display: block;
            margin-bottom: 7px;
            color: #334155;
            font-size: 13px;
            font-weight: 800 !important;
            border: 0 !important;
        }

        .hr-field .form-control {
            height: 42px;
            border-radius: 12px;
            border: 1px solid #cbd5e1;
            color: var(--hr-text);
            font-size: 13px;
            box-shadow: none;
            transition: all .18s ease;
        }

            .hr-field .form-control:focus {
                border-color: var(--hr-primary-2);
                box-shadow: 0 0 0 3px rgba(37, 99, 235, .12);
            }

        .hr-actions {
            display: flex;
            justify-content: flex-end;
            align-items: end;
        }

        .hr-export-btn {
            min-height: 42px;
            border: 0;
            border-radius: 12px;
            padding: 10px 18px;
            color: #fff;
            font-size: 13px;
            font-weight: 800;
            background: linear-gradient(120deg, var(--hr-primary-2), var(--hr-accent));
            box-shadow: 0 12px 24px rgba(37, 99, 235, .22);
            transition: transform .18s ease, box-shadow .18s ease;
            white-space: nowrap;
        }

            .hr-export-btn:hover,
            .hr-export-btn:focus {
                color: #fff;
                transform: translateY(-1px);
                box-shadow: 0 16px 28px rgba(37, 99, 235, .28);
            }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            margin: auto;
            width: 192px;
            height: 192px;
            z-index: 99999;
            text-align: center;
            opacity: .95;
        }

            .loading img {
                max-width: 80px;
                display: block;
                margin: 0 auto 10px;
            }

        .hr-wait-modal .modal-dialog {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto;
        }

        .hr-wait-box {
            width: min(520px, calc(100vw - 28px));
            border-radius: 22px;
            padding: 30px 24px;
            text-align: center;
            background: rgba(15, 23, 42, .86);
            border: 1px solid rgba(255, 255, 255, .16);
            box-shadow: 0 24px 70px rgba(0, 0, 0, .35);
            color: #fff;
            backdrop-filter: blur(6px);
        }

            .hr-wait-box img {
                width: 82px;
                margin-bottom: 14px;
            }

        .hr-wait-title {
            display: block;
            font-size: 20px;
            font-weight: 800;
            line-height: 1.45;
        }

        .hr-wait-dots {
            display: block;
            margin-top: 8px;
            font-size: 34px;
            font-weight: 900;
            letter-spacing: 3px;
            animation: hrPulse 1.1s linear infinite;
        }

        @keyframes hrPulse {
            0%, 100% {
                opacity: .35;
            }

            50% {
                opacity: 1;
            }
        }

        .dataTables_scrollBody {
            min-height: 100px !important;
            height: auto;
        }

        .dataTables_length,
        .dataTables_info {
            float: left !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 50px;
            float: left;
        }

        .buttons-excel,
        .buttons-html5 {
            color: #fff;
            box-shadow: none;
            background: linear-gradient(120deg, var(--hr-primary-2), var(--hr-accent));
            border: 0;
            font-weight: bold;
            margin: 0 10px;
            border-radius: 10px;
        }

        .table.dataTable th {
            background: #edf3f6 !important;
            color: #0f172a;
            height: 42px;
            vertical-align: middle;
        }

        .table.dataTable tr td {
            background: #fff !important;
            vertical-align: middle;
        }

        @media (max-width: 991px) {
            .hr-form-grid {
                grid-template-columns: repeat(2, minmax(180px, 1fr));
            }
        }

        @media (max-width: 575px) {
            .hr-page {
                padding: 10px;
            }

            .hr-hero {
                padding: 18px;
                border-radius: 15px;
            }

            .hr-hero-title-wrap {
                align-items: flex-start;
            }

            .hr-form-grid {
                grid-template-columns: 1fr;
            }

            .hr-actions {
                justify-content: stretch;
            }

            .hr-export-btn {
                width: 100%;
            }
        }
    </style>

<script>
    $(document).ready(function () {
        hr_BindYear();
        hr_buildSheetList();
        hr_resetProgress();
    });

    const hrSheets = [
        { name: "Recruitment Summary", method: "RecruitmentSummary", useMonthYear: true },
        { name: "Hiring", method: "Hiring" },
        { name: "Manpower", method: "Manpower" },
        { name: "Skip Level Summary", method: "SkipLevel" },
        { name: "Skip Level Details", method: "SkipLevelDetails" },
        { name: "Background Verification", method: "BackgroundVerification" },
        { name: "Absconding", method: "Absconding" },
        { name: "Resigned", method: "Resigned" },
        { name: "Fun Friday Details", method: "FunFriday" },
        { name: "Fun Friday Snaps", method: "FunFridaySnaps" },
        { name: "Naukri", method: "Naukri" },
        { name: "LinkedIn", method: "LinkedIn" },
        { name: "Glassdoor Infinity", method: "GlassdoorInfinity" },
        { name: "Glassdoor Competitors", method: "GlassdoorCompetitors" },
        { name: "Reward and Recognition Details", method: "RnR" },
        { name: "Reward and Recognition Snaps", method: "RnRSnaps" },
        { name: "Stamp Paper Purchase", method: "StamppaperPurchase" },
        { name: "Master Data", method: "MasterData" },
        { name: "HR Induction Report", method: "HRInductionReport" },
        { name: "New Joinee Followup", method: "NewJoineeFollowUp" },
        { name: "Address Verification", method: "AddressVerification" },
        { name: "Exit Employees", method: "ExitEmployees" },
        { name: "Ticket Report", method: "TicketReport" },
        { name: "Dashboard Summary", method: "EditDashboard", text: "Editing Dashboard Summary..." },
        { name: "Attrition Report", method: "AttritionReport" }
    ];

    function RecruitmentSummary() {
        var month = $("#hr_month").val();
        var year = $("#hr_year").val();

        if (!month || month === "0") {
            Swal.fire("Month Required", "Please select month.", "warning");
            return false;
        }

        if (!year || year === "0") {
            Swal.fire("Year Required", "Please select year.", "warning");
            return false;
        }

        $('#waitingpanel').modal('show');

        hr_buildSheetList();
        hr_resetProgress();

        hr_runSheet(0, month, year);

        return false;
    }

    function hr_runSheet(index, month, year) {
        if (index >= hrSheets.length) {
            hr_setProgress(100, "All sheets generated successfully.");
            $("#hr_sheetList .hr-sheet-item").addClass("done").removeClass("active");
            $('#waitingpanel').modal('hide');

            __doPostBack("<%= btn1.UniqueID %>", '');
            return false;
        }

        var sheet = hrSheets[index];
        var runningText = sheet.text || ("Preparing sheet : " + sheet.name + " ...");

        hr_markSheetActive(index);
        hr_setProgress(Math.round((index / hrSheets.length) * 100), runningText);

        var success = function () {
            hr_markSheetDone(index);

            var completedPercent = Math.round(((index + 1) / hrSheets.length) * 100);
            hr_setProgress(completedPercent, "Completed : " + sheet.name);

            setTimeout(function () {
                hr_runSheet(index + 1, month, year);
            }, 250);
        };

        var error = function (err) {
            $('#waitingpanel').modal('hide');

            var msg = "Something went wrong.";
            if (err && typeof err.get_message === "function") {
                msg = err.get_message();
            }

            Swal.fire({
                icon: "error",
                title: "Sheet Generation Failed",
                html: "<b>" + sheet.name + "</b><br/>" + msg
            });
        };

        if (!PageMethods[sheet.method]) {
            $('#waitingpanel').modal('hide');
            Swal.fire("Method Missing", sheet.method + " method not found in PageMethods.", "error");
            return false;
        }

        if (sheet.useMonthYear === true) {
            PageMethods[sheet.method](month, year, success, error);
        } else {
            PageMethods[sheet.method](success, error);
        }

        return false;
    }

    function hr_buildSheetList() {
        var html = "";

        $.each(hrSheets, function (i, sheet) {
            html += `
            <div class="hr-sheet-item" id="hr_sheet_${i}">
                <span class="hr-sheet-icon">
                    <i class="fas fa-clock"></i>
                </span>
                <span>${sheet.name}</span>
            </div>`;
        });

        $("#hr_sheetList").html(html);
    }

    function hr_markSheetActive(index) {
        $(".hr-sheet-item").removeClass("active");

        var item = $("#hr_sheet_" + index);
        item.addClass("active");

        item.find(".hr-sheet-icon").html('<i class="fas fa-spinner fa-spin"></i>');

        var container = $("#hr_sheetList");
        container.animate({
            scrollTop: item.position().top + container.scrollTop() - 80
        }, 300);
    }

    function hr_markSheetDone(index) {
        var item = $("#hr_sheet_" + index);

        item.removeClass("active").addClass("done");
        item.find(".hr-sheet-icon").html('<i class="fas fa-check"></i>');
    }

    function hr_setProgress(percent, text) {
        percent = Math.min(100, Math.max(0, percent));

        $("#spntext").html(text);
        $("#hr_progressText").text(percent + "%");
        $("#hr_progressbar").css("width", percent + "%");
    }

    function hr_resetProgress() {
        $("#hr_progressbar").css("width", "0%");
        $("#hr_progressText").text("0%");
        $("#spntext").html("Waiting to start...");

        $(".hr-sheet-item")
            .removeClass("active done")
            .find(".hr-sheet-icon")
            .html('<i class="fas fa-clock"></i>');
    }
</script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="hr-page">
        <div class="hr-hero">
            <div class="hr-hero-inner">
                <div class="hr-hero-title-wrap">
                    <div class="hr-hero-icon">
                        <i class="fas fa-file-excel"></i>
                    </div>
                    <div>
                        <h4>HR Report</h4>
                        <p>Generate monthly HR MIS report sheets quickly and accurately.</p>
                    </div>
                </div>
                <div class="hr-chip">
                    <i class="fas fa-calendar-alt"></i>
                    Monthly Export
               
                </div>
            </div>
        </div>

        <div class="hr-panel">
            <div class="hr-panel-head">
                <div>
                    <h5><i class="fas fa-filter"></i>&nbsp; Report Filters</h5>
                    <span>Select month and year to export HR report.</span>
                </div>
            </div>

            <div class="hr-form">
                <div class="hr-form-grid">
                    <div class="hr-field">
                        <label for="hr_month">Month</label>
                        <select id="hr_month" name="hr_month" class="form-control">
                            <option value="">Select Month</option>
                            <option value="January">January</option>
                            <option value="February">February</option>
                            <option value="March">March</option>
                            <option value="April">April</option>
                            <option value="May">May</option>
                            <option value="June">June</option>
                            <option value="July">July</option>
                            <option value="August">August</option>
                            <option value="September">September</option>
                            <option value="October">October</option>
                            <option value="November">November</option>
                            <option value="December">December</option>
                        </select>
                    </div>

                    <div class="hr-field">
                        <label for="hr_year">Year</label>
                        <select id="hr_year" name="hr_year" class="form-control">
                            <option value="">Select Year</option>
                        </select>
                    </div>

                    <div class="hr-actions">
                        <button id="hr_btnShow" type="button" class="hr-export-btn" onclick="return RecruitmentSummary();">
                            <i class="fas fa-file-export"></i>&nbsp; Export to Excel
                       
                        </button>
                    </div>
                </div>

                <asp:Button ID="btn1" runat="server" Style="display: none;" OnClick="btn1_Click" />
            </div>
        </div>
    </div>

    <div class="modal fade hr-wait-modal" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog">
            <div class="hr-wait-box">
                <img src="../Images/Load.gif" />
                <span class="hr-wait-title" id="spntext">System is generating excel. Please wait</span>
                <span class="hr-wait-dots">. . . .</span>
            </div>
        </div>
    </div>
    <div class="hr-progress-card">

        <div class="hr-progress-header">
            <div>
                <h5>Generating HR Report</h5>
                <p id="spntext">Waiting to start...</p>
            </div>
            <div class="hr-progress-percent" id="hr_progressText">0%</div>
        </div>

        <div class="hr-main-progress">
            <div id="hr_progressbar"></div>
        </div>

        <div id="hr_sheetList" class="hr-sheet-list"></div>

    </div>
    
    <style>
        .hr-progress-card {
            width: 100%;
            padding: 18px;
            border-radius: 18px;
            background: #ffffff;
            box-shadow: 0 18px 40px rgba(15, 23, 42, 0.18);
        }

        .hr-progress-header {
            display: flex;
            justify-content: space-between;
            gap: 15px;
            align-items: center;
            margin-bottom: 14px;
        }

            .hr-progress-header h5 {
                margin: 0;
                font-weight: 800;
                color: #0f172a;
            }

            .hr-progress-header p {
                margin: 4px 0 0;
                color: #64748b;
                font-size: 13px;
            }

        .hr-progress-percent {
            min-width: 62px;
            height: 62px;
            border-radius: 50%;
            background: linear-gradient(135deg, #2563eb, #22c1dc);
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            box-shadow: 0 10px 22px rgba(37, 99, 235, 0.35);
        }

        .hr-main-progress {
            width: 100%;
            height: 12px;
            background: #e5e7eb;
            border-radius: 999px;
            overflow: hidden;
            margin-bottom: 18px;
        }

        #hr_progressbar {
            width: 0%;
            height: 100%;
            border-radius: 999px;
            background: linear-gradient(90deg, #2563eb, #22c1dc, #16a34a);
            transition: width 0.45s ease;
            position: relative;
        }

            #hr_progressbar::after {
                content: "";
                position: absolute;
                inset: 0;
                background-image: linear-gradient( 45deg, rgba(255,255,255,.35) 25%, transparent 25%, transparent 50%, rgba(255,255,255,.35) 50%, rgba(255,255,255,.35) 75%, transparent 75%, transparent );
                background-size: 22px 22px;
                animation: hrProgressMove 1s linear infinite;
            }

        @keyframes hrProgressMove {
            from {
                background-position: 0 0;
            }

            to {
                background-position: 22px 0;
            }
        }

        .hr-sheet-list {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
            gap: 10px;
            max-height: 360px;
            overflow-y: auto;
            padding-right: 4px;
        }

        .hr-sheet-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 11px 12px;
            border-radius: 14px;
            background: #f8fafc;
            border: 1px solid #e5e7eb;
            color: #475569;
            font-size: 13px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .hr-sheet-icon {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background: #e2e8f0;
            color: #64748b;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
        }

        .hr-sheet-item.active {
            background: linear-gradient(135deg, #eff6ff, #ecfeff);
            border-color: #2563eb;
            color: #1d4ed8;
            transform: scale(1.02);
            box-shadow: 0 8px 22px rgba(37, 99, 235, 0.18);
        }

            .hr-sheet-item.active .hr-sheet-icon {
                background: #2563eb;
                color: #fff;
                animation: hrPulse 1s infinite;
            }

        .hr-sheet-item.done {
            background: #ecfdf5;
            border-color: #22c55e;
            color: #15803d;
        }

            .hr-sheet-item.done .hr-sheet-icon {
                background: #22c55e;
                color: #fff;
            }

        @keyframes hrPulse {
            0% {
                box-shadow: 0 0 0 0 rgba(37, 99, 235, .45);
            }

            70% {
                box-shadow: 0 0 0 8px rgba(37, 99, 235, 0);
            }

            100% {
                box-shadow: 0 0 0 0 rgba(37, 99, 235, 0);
            }
        }

        @media (max-width: 576px) {
            .hr-progress-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .hr-progress-percent {
                width: 52px;
                height: 52px;
                min-width: 52px;
                font-size: 13px;
            }

            .hr-sheet-list {
                grid-template-columns: 1fr;
                max-height: 300px;
            }
        }
    </style>

</asp:Content>

<%--<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        function hr_Submit() {
            __doPostBack("<%= btn1.UniqueID %>", '');
            return false;
        }
    </script>
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

        .dataTables_scrollBody {
            min-height: 100px !important;
            height: auto;
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
            padding-left: 50px;
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
            color: #000;
        }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
        }



        /*.form-control {
            font-size: 11px !important;
        }*/
    </style>
    <script>
        $(document).ready(function () {
            hr_BindYear();
        });

        function RecruitmentSummary() {
            $('#waitingpanel').modal('show');
            var ddlmonth = document.getElementById("hr_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("hr_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            document.getElementById("spntext").innerHTML = "Preparing sheet : Recruitment Summary . . . ";
            PageMethods.RecruitmentSummary(month, year, Recruit_OnSuccess, Recruit_OnError);
            return false;
        }
        function Recruit_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Hiring . . . ";
            PageMethods.Hiring(Hiring_OnSuccess, Hiring_OnError);
            return false;
        }
        function Recruit_OnError(error) {
            alert(error.get_message());
        }
        //Hiring
        function Hiring_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Manpower . . . ";
            PageMethods.Manpower(Manpower_OnSuccess, Manpower_OnError);
            return false;
        }
        function Hiring_OnError(error) {
            alert(error.get_message());
        }
        //SkipLevel
        function Manpower_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Skip Level Summary . . . ";
            PageMethods.SkipLevel(SkipLevel_OnSuccess, SkipLevel_OnError);
            return false;
        }
        function Manpower_OnError(error) {
            alert(error.get_message());
        }
        //Skip Level Details
        function SkipLevel_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Skip Level Details . . . ";
            PageMethods.SkipLevelDetails(SkipLevelDetails_OnSuccess, SkipLevelDetails_OnError);
            return false;
        }
        function SkipLevel_OnError(error) {
            alert(error.get_message());
        }
        //Background Verification
        function SkipLevelDetails_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Background Verification . . . ";
            PageMethods.BackgroundVerification(BackgroundVerification_OnSuccess, BackgroundVerification_OnError);
            return false;
        }
        function SkipLevelDetails_OnError(error) {
            alert(error.get_message());
        }
        //Absconding
        function BackgroundVerification_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Absconding . . . ";
            PageMethods.Absconding(Absconding_OnSuccess, Absconding_OnError);
            return false;
        }
        function BackgroundVerification_OnError(error) {
            alert(error.get_message());
        }
        //Resigned
        function Absconding_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Resigned . . . ";
            PageMethods.Resigned(Resigned_OnSuccess, Resigned_OnError);
            return false;
        }
        function Absconding_OnError(error) {
            alert(error.get_message());
        }

        //FunFriday
        function Resigned_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Fun Friday Details . . . ";
            PageMethods.FunFriday(FunFriday_OnSuccess, FunFriday_OnError);
            return false;
        }
        function Resigned_OnError(error) {
            alert(error.get_message());
        }
        //FunFridaySnaps
        function FunFriday_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Fun Friday Snaps . . . ";
            PageMethods.FunFridaySnaps(FunFridaySnaps_OnSuccess, FunFridaySnaps_OnError);
            return false;
        }
        function FunFriday_OnError(error) {
            alert(error.get_message());
        }
        //Naukri
        function FunFridaySnaps_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Naukri . . . ";
            PageMethods.Naukri(Naukri_OnSuccess, Naukri_OnError);
            return false;
        }
        function FunFridaySnaps_OnError(error) {
            alert(error.get_message());
        }
        //LinkedIn
        function Naukri_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : LinkedIn . . . ";
            PageMethods.LinkedIn(LinkedIn_OnSuccess, LinkedIn_OnError);
            return false;
        }
        function Naukri_OnError(error) {
            alert(error.get_message());
        }
        //Glassdoor Infinity
        function LinkedIn_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Glassdoor Infinity . . . ";
            PageMethods.GlassdoorInfinity(GlassdoorInfinity_OnSuccess, GlassdoorInfinity_OnError);
            return false;
        }
        function LinkedIn_OnError(error) {
            alert(error.get_message());
        }
        //Glassdoor Competitors
        function GlassdoorInfinity_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Glassdoor Competitors . . . ";
            PageMethods.GlassdoorCompetitors(GlassdoorCompetitors_OnSuccess, GlassdoorCompetitors_OnError);
            return false;
        }
        function GlassdoorInfinity_OnError(error) {
            alert(error.get_message());
        }
        //RnR
        function GlassdoorCompetitors_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Reward and Recognition Details . . . ";
            PageMethods.RnR(RnR_OnSuccess, RnR_OnError);
            return false;
        }
        function GlassdoorCompetitors_OnError(error) {
            alert(error.get_message());
        }
        //RnRSnaps
        function RnR_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Reward and Recognition Snaps . . . ";
            PageMethods.RnRSnaps(RnRSnaps_OnSuccess, RnRSnaps_OnError);
            return false;
        }
        function RnR_OnError(error) {
            alert(error.get_message());
        }
        //StamppaperPurchase
        function RnRSnaps_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Stamp Paper Purchase . . . ";
            PageMethods.StamppaperPurchase(StamppaperPurchase_OnSuccess, StamppaperPurchase_OnError);
            return false;
        }
        function RnRSnaps_OnError(error) {
            alert(error.get_message());
        }
        //Master Data
        function StamppaperPurchase_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Master Data . . . ";
            PageMethods.MasterData(MasterData_OnSuccess, MasterData_OnError);
            return false;
        }
        function StamppaperPurchase_OnError(error) {
            alert(error.get_message());
        }

        //HRInductionReport
        function MasterData_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : HR Induction Report . . . ";
            PageMethods.HRInductionReport(HRInductionReport_OnSuccess, HRInductionReport_OnError);
            return false;
        }
        function MasterData_OnError(error) {
            alert(error.get_message());
        }

        //NewJoineeFollowUp
        function HRInductionReport_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : New Joinee Followup . . . ";
            PageMethods.NewJoineeFollowUp(NewJoineeFollowUp_OnSuccess, NewJoineeFollowUp_OnError);
            return false;
        }
        function HRInductionReport_OnError(error) {
            alert(error.get_message());
        }
        //AddressVerification
        function NewJoineeFollowUp_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Address Verification . . . ";
            PageMethods.AddressVerification(AddressVerification_OnSuccess, AddressVerification_OnError);
            return false;
        }
        function NewJoineeFollowUp_OnError(error) {
            alert(error.get_message());
        }
        //ExitEmployees
        function AddressVerification_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Exit Employees . . . ";
            PageMethods.ExitEmployees(ExitEmployees_OnSuccess, ExitEmployees_OnError);
            return false;
        }
        function AddressVerification_OnError(error) {
            alert(error.get_message());
        }
        //TicketReport
        function ExitEmployees_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Ticket Report . . . ";
            PageMethods.TicketReport(TicketReport_OnSuccess, TicketReport_OnError);
            return false;
        }
        function ExitEmployees_OnError(error) {
            alert(error.get_message());
        }
        //EditDashboard
        function TicketReport_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Editing Dashboard Summary . . . ";
            PageMethods.EditDashboard(EditDashboard_OnSuccess, EditDashboard_OnError);
            return false;
        }
        function TicketReport_OnError(error) {
            alert(error.get_message());
        }
        //AttritionReport
        function EditDashboard_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Attrition Report . . . ";
            PageMethods.AttritionReport(AttritionReport_OnSuccess, AttritionReport_OnError);
            return false;
        }
        function EditDashboard_OnError(error) {
            alert(error.get_message());
        }

        //Export final Excel
        function AttritionReport_OnSuccess(result) {
          
            $('#waitingpanel').modal('hide');
            __doPostBack("<%= btn1.UniqueID %>", '');
            return false;
        }
        function AttritionReport_OnError(error) {
            alert(error.get_message());
        }


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>HR Report</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <table class="table">
                    <tr>
                        <td style="width: 50px;"><b>Month:</b></td>
                        <td style="width: 150px;">
                            <select id="hr_month" name="hr_month" class="form-control">
                                <option value="">Select</option>
                                <option value="January">January</option>
                                <option value="February">February</option>
                                <option value="March">March</option>
                                <option value="April">April</option>
                                <option value="May">May</option>
                                <option value="June">June</option>
                                <option value="July">July</option>
                                <option value="August">August</option>
                                <option value="September">September</option>
                                <option value="October">October</option>
                                <option value="November">November</option>
                                <option value="December">December</option>
                            </select>
                        </td>
                        <td style="width: 50px;">
                            <b>Year:</b>
                        </td>
                        <td style="width: 150px;">
                            <select id="hr_year" name="hr_year" class="form-control">
                                <option value="">Select</option>
                            </select>
                        </td>
                        <td style="width: 100px;">
                            <button id="hr_btnShow" class="btn btn-primary" onclick="return RecruitmentSummary()">Export to excel</button>
                        </td>
                    </tr>
                </table>
                <asp:Button ID="btn1" runat="server" Style="display: none;" OnClick="btn1_Click" />
            </div>
        </div>
    </div>
    <div class="modal fade" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">System is generating excel. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>

</asp:Content>--%>
