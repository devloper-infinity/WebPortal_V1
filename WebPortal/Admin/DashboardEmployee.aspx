<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="DashboardEmployee.aspx.cs" Inherits="WebPortal.Admin.DashboardEmployee" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/intro.js/minified/introjs.min.css" rel="stylesheet">

    <script src="https://cdn.jsdelivr.net/npm/intro.js/minified/intro.min.js"></script>
    <script src="../plugins/chart.js/Chart.bundle.min.js"></script>
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

        /*  .birthday-card {
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
*/
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
            /*background: linear-gradient(135deg, #28a745, #5cd65c);*/
            background: #FD4179 !important; /* linear-gradient(135deg, #FD4179, #FE7AA1) !important;*/
            border: none;
            color: white;
            padding: 5px 14px;
            border-radius: 20px;
            font-size: 13px;
            transition: 0.3s;
        }

            .btn-wish:hover {
                transform: scale(1.05);
                /* background: linear-gradient(135deg, #218838, #4cd137);*/
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
    <style id="passwordexpirary">
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

        .important-notification {
            max-width: 100%;
            overflow: hidden !important;
        }

            /* DataTable wrapper must not expand outside card */
            .important-notification .dataTables_wrapper {
                width: 100% !important;
                max-width: 100% !important;
                overflow: hidden !important;
                padding: 0 !important;
                box-shadow: none !important;
                border: none !important;
                background: transparent !important;
            }

            /* Table full width inside card */
            .important-notification table.dataTable {
                width: 100% !important;
                max-width: 100% !important;
            }

            /* Bottom row: info + pagination */
            .important-notification .dataTables_info,
            .important-notification .dataTables_paginate {
                float: none !important;
                width: 100% !important;
                text-align: left !important;
            }

            /* Pagination must wrap inside card */
            .important-notification .dataTables_paginate {
                display: flex !important;
                flex-wrap: wrap !important;
                justify-content: flex-start !important;
                gap: 6px;
                overflow: hidden !important;
                margin-top: 8px !important;
            }

                /* Smaller buttons */
                .important-notification .dataTables_paginate .paginate_button {
                    min-width: 34px !important;
                    height: 32px !important;
                    padding: 5px 10px !important;
                    margin: 0 !important;
                    font-size: 11px !important;
                }

                    /* Hide extra page numbers on small dashboard card */
                    .important-notification .dataTables_paginate .paginate_button:not(.previous):not(.next):not(.current) {
                        display: none !important;
                    }

            /* Compact table */
            .important-notification table.dataTable th,
            .important-notification table.dataTable td {
                padding: 7px 9px !important;
                font-size: 11px !important;
            }
    </style>
    <style>
        .hr-dashboard-highlight {
            position: relative;
            border: 2px solid #0d6efd !important;
            border-radius: 18px;
            animation: pulseGlow 1.8s infinite;
            overflow: hidden;
        }

            .hr-dashboard-highlight::before {
                content: '';
                position: absolute;
                top: -40%;
                left: -40%;
                width: 180%;
                height: 180%;
                background: linear-gradient( 120deg, transparent, rgba(13,110,253,0.18), transparent );
                transform: rotate(25deg);
                animation: shine 3s linear infinite;
            }

        @keyframes pulseGlow {
            0% {
                box-shadow: 0 0 0 0 rgba(13,110,253,0.5);
                transform: scale(1);
            }

            50% {
                box-shadow: 0 0 25px 8px rgba(13,110,253,0.35);
                transform: scale(1.03);
            }

            100% {
                box-shadow: 0 0 0 0 rgba(13,110,253,0.5);
                transform: scale(1);
            }
        }

        @keyframes shine {
            0% {
                transform: translateX(-100%) rotate(25deg);
            }

            100% {
                transform: translateX(100%) rotate(25deg);
            }
        }
    </style>
    <style id="productive-employees-dashboard">
        .productive-section {
            margin-top: 14px;
            margin-bottom: 12px;
            position: relative;
        }

        .productive-section-heading {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 10px;
        }

            .productive-section-heading h5 {
                margin: 0;
                font-size: 16px;
                font-weight: 600;
                color: #343a40;
            }

        .productive-section-subtitle {
            display: block;
            margin-top: 2px;
            font-size: 12px;
            color: #6c757d;
        }

        .productive-period-select {
            border: 1px solid #ced4da;
            border-radius: 4px;
            color: #495057;
            font-size: 12px;
            height: 28px;
            margin-left: 4px;
            padding: 2px 24px 2px 8px;
        }

        .productive-period-detail {
            color: #6c757d;
            display: block;
            font-size: 11px;
            margin-top: 3px;
        }

        .productive-period-message {
            color: #b26a00;
            display: none;
            font-size: 11px;
            margin-top: 3px;
        }

        .productive-section-actions {
            display: flex;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
            font-size: 12px;
        }

            .productive-section-actions a {
                color: #4F81BD;
                text-decoration: underline;
            }

        .productive-kpi-card {
            background: #fff;
            border: 1px solid #e9ecef;
            border-left: 3px solid #4F81BD;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.06);
            min-height: 104px;
            padding: 13px 14px;
            margin-bottom: 14px;
        }

        .productive-kpi-label {
            color: #6c757d;
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 0;
            text-transform: uppercase;
        }

        .productive-kpi-value {
            color: #343a40;
            font-size: 23px;
            font-weight: 700;
            line-height: 1.2;
            margin-top: 8px;
            word-break: break-word;
        }

        .productive-kpi-note {
            color: #6c757d;
            font-size: 12px;
            margin-top: 4px;
        }

        .productive-chart-card {
            min-height: 360px;
        }

        .productive-chart-wrap {
            position: relative;
            height: 282px;
            min-height: 282px;
        }

        .productive-empty-state {
            background: #fff;
            border: 1px dashed #ced4da;
            border-radius: 8px;
            color: #6c757d;
            font-size: 13px;
            padding: 18px;
            text-align: center;
        }

        .productive-detail-table {
            font-size: 11px;
        }

            .productive-detail-table th,
            .productive-detail-table td {
                white-space: nowrap;
                vertical-align: middle !important;
            }

        .productive-grade-cell {
            background: salmon;
        }

        .productive-alert-badge {
            background: red;
            color: white;
            border-radius: 3px;
            display: inline-block;
            padding: 3px 7px;
        }

        .productive-section-loading {
            align-items: center;
            background: rgba(255,255,255,0.84);
            bottom: 0;
            display: none;
            justify-content: center;
            left: 0;
            position: absolute;
            right: 0;
            top: 0;
            z-index: 5;
        }

        .productive-loading-box {
            align-items: center;
            background: #fff;
            border: 1px solid #d8e2ef;
            border-radius: 8px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.12);
            color: #343a40;
            display: flex;
            font-size: 13px;
            gap: 10px;
            padding: 14px 18px;
        }

        @media (max-width: 767px) {
            .productive-section-heading {
                align-items: flex-start;
                flex-direction: column;
            }

            .productive-chart-wrap {
                height: 240px;
                min-height: 240px;
            }
        }
    </style>

    <script>
        var dashProductiveProductionChart = null;
        var dashProductiveAttendanceChart = null;

        function dash_bindProductiveEmployeeInsights() {
            var rangeType = $("#dashboard_productive_action").val() || "Last12Months";

            $("#prod_dashboard_employee").show();
            $("#dashboard_productive_section").show();
            $("#dashboard_productive_empty").hide();
            $("#dashboard_productive_content").hide();
            dashSetProductiveInsightsLoading(true);

            $.ajax({
                url: "DashboardEmployee.aspx/GetProductiveEmployeeInsightDetails",
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ RangeType: rangeType }),
                global: false,
                success: function (data) {
                    var payload = {};

                    try {
                        payload = JSON.parse(data.d || "{}");
                    }
                    catch (ex) {
                        payload = {};
                    }

                    var productionRows = dashSortProductionRows(payload.production || []);
                    var attendanceRows = dashSortAttendanceRows(payload.attendance || []);
                    var hasVisibleRows = dashIsTaskBasedEmployee() ? attendanceRows.length > 0 : (productionRows.length > 0 || attendanceRows.length > 0);

                    if (!hasVisibleRows) {
                        dashApplyProductiveEmployeeMode();
                        dashUpdateProductivePeriod(payload, productionRows, attendanceRows);
                        $("#dashboard_productive_section").show();
                        $("#dashboard_productive_empty").text(dashIsTaskBasedEmployee() ? "No attendance details available." : "No productive employee details available.");
                        $("#dashboard_productive_empty").show();
                        $("#dashboard_productive_content").hide();
                        return;
                    }

                    $("#dashboard_productive_section").show();
                    $("#dashboard_productive_empty").hide();
                    $("#dashboard_productive_content").show();

                    dashApplyProductiveEmployeeMode();
                    dashUpdateProductivePeriod(payload, productionRows, attendanceRows);
                    dashRenderProductiveKpis(productionRows, attendanceRows);
                    dashRenderProductiveCharts(productionRows, attendanceRows);
                    dashRenderProductiveTables(productionRows, attendanceRows);
                },
                error: function (error) {
                    if (window.console) {
                        console.log(error && error.responseText ? error.responseText : error);
                    }
                },
                complete: function () {
                    dashSetProductiveInsightsLoading(false);
                }
            });

            return false;
        }

        function dashSetProductiveInsightsLoading(isLoading) {
            var $loader = $("#dashboard_productive_loading");
            $("#dashboard_productive_action").prop("disabled", isLoading);

            if (!$loader.length) {
                return;
            }

            if (isLoading) {
                $loader.css("display", "flex");
            }
            else {
                $loader.hide();
            }
        }

        function dashSortProductionRows(rows) {
            rows = rows || [];

            rows.sort(function (a, b) {
                return dashProductionSortValue(a) - dashProductionSortValue(b);
            });

            return rows;
        }

        function dashSortAttendanceRows(rows) {
            rows = rows || [];

            rows.sort(function (a, b) {
                return dashAttendanceSortValue(a) - dashAttendanceSortValue(b);
            });

            return rows;
        }

        function dashProductionSortValue(row) {
            if (row.MonthSort) {
                return parseInt(String(row.MonthSort).replace("-", ""), 10) || 0;
            }

            return dashMonthYearSortValue(row.MonthYear);
        }

        function dashAttendanceSortValue(row) {
            var year = dashToNumber(row.Year);
            var month = dashMonthNumber(row.Month);

            return (year * 100) + month;
        }

        function dashMonthYearSortValue(value) {
            var text = dashCleanText(value);
            var match = /([A-Za-z]{3,9})[\s\-\/,]+(\d{2,4})/.exec(text);
            var year;
            var month;

            if (match) {
                month = dashMonthNumber(match[1]);
                year = parseInt(match[2], 10);

                if (year < 100) {
                    year += 2000;
                }

                return (year * 100) + month;
            }

            match = /(\d{1,2})[\-\/](\d{2,4})/.exec(text);

            if (match) {
                month = parseInt(match[1], 10);
                year = parseInt(match[2], 10);

                if (year < 100) {
                    year += 2000;
                }

                return (year * 100) + month;
            }

            return 0;
        }

        function dashMonthNumber(value) {
            var text = dashCleanText(value).toLowerCase();
            var monthMap = {
                jan: 1,
                feb: 2,
                mar: 3,
                apr: 4,
                may: 5,
                jun: 6,
                jul: 7,
                aug: 8,
                sep: 9,
                oct: 10,
                nov: 11,
                dec: 12
            };
            var number = parseInt(text, 10);

            if (!isNaN(number) && number > 0 && number <= 12) {
                return number;
            }

            return monthMap[text.substring(0, 3)] || 0;
        }

        function dashUpdateProductivePeriod(payload, productionRows, attendanceRows) {
            var labels = [];
            var firstLabel = "";
            var lastLabel = "";
            var selectedRange = dashCleanText(payload.selectedRange);
            var periodLabel = dashCleanText(payload.periodLabel);
            var rangeMessage = dashCleanText(payload.rangeMessage);

            if (selectedRange) {
                $("#dashboard_productive_action").val(selectedRange);
            }

            if (productionRows.length > 0) {
                firstLabel = dashCleanText(productionRows[0].MonthYear);
                lastLabel = dashCleanText(productionRows[productionRows.length - 1].MonthYear);
            }
            else if (attendanceRows.length > 0) {
                firstLabel = dashAttendanceLabel(attendanceRows[0]);
                lastLabel = dashAttendanceLabel(attendanceRows[attendanceRows.length - 1]);
            }

            if (firstLabel) {
                labels.push(firstLabel);
            }

            if (lastLabel && lastLabel !== firstLabel) {
                labels.push(lastLabel);
            }

            if (!periodLabel) {
                periodLabel = labels.length > 1 ? labels.join(" to ") : (labels[0] || "");
            }

            $("#dashboard_productive_period").text(periodLabel ? "Period: " + periodLabel : "");
            $("#dashboard_productive_range_message")
                .text(rangeMessage)
                .toggle(!!rangeMessage);
        }

        function dashRenderProductiveKpis(productionRows, attendanceRows) {
            var latestProduction = productionRows.length > 0 ? productionRows[productionRows.length - 1] : {};
            var latestAttendance = attendanceRows.length > 0 ? attendanceRows[attendanceRows.length - 1] : {};
            var attendanceAverage = dashAverageRows(attendanceRows, "AttendancePercOnTotalDays");

            if (attendanceAverage === 0) {
                attendanceAverage = dashAverageRows(productionRows, "Attendance");
            }

            $("#dashboard_kpi_total_production").text(dashFormatWhole(dashSumRows(productionRows, "Production")));
            $("#dashboard_kpi_total_production_note").text("Latest: " + dashFormatWhole(latestProduction.Production || 0));
            $("#dashboard_kpi_expected_productivity").text(dashFormatWhole(dashSumRows(productionRows, "ExpectedProductivity")));
            $("#dashboard_kpi_expected_productivity_note").text("Latest: " + dashFormatWhole(latestProduction.ExpectedProductivity || 0));
            $("#dashboard_kpi_production_perc").text(dashFormatPercent(dashAverageRows(productionRows, "ProductionPerc")));
            $("#dashboard_kpi_production_perc_note").text("Grade: " + (dashCleanText(latestProduction.ProdGrade) || "-"));
            $("#dashboard_kpi_accuracy").text(dashFormatPercent(dashAverageRows(productionRows, "Accuracy")));
            $("#dashboard_kpi_accuracy_note").text("QA grade: " + (dashCleanText(latestProduction.QAGrade) || "-"));
            $("#dashboard_kpi_attendance").text(dashFormatPercent(attendanceAverage));
            $("#dashboard_kpi_attendance_note").text("Latest: " + dashFormatPercent(latestAttendance.AttendancePercOnTotalDays || latestProduction.Attendance || 0));
            $("#dashboard_kpi_latemarks").text(dashFormatWhole(dashSumRows(attendanceRows, "TotalLatemarks")));
            $("#dashboard_kpi_latemarks_note").text("Removed: " + dashFormatWhole(dashSumRows(attendanceRows, "RemovedLatemarks")));
        }

        function dashRenderProductiveCharts(productionRows, attendanceRows) {
            if (typeof Chart === "undefined") {
                return;
            }

            if (dashIsTaskBasedEmployee()) {
                if (dashProductiveProductionChart) {
                    dashProductiveProductionChart.destroy();
                    dashProductiveProductionChart = null;
                }
            }
            else {
                dashRenderProductionTrendChart(productionRows);
            }

            dashRenderAttendanceTrendChart(attendanceRows);
        }

        function dashRenderProductionTrendChart(rows) {
            var labels = [];
            var production = [];
            var productionPerc = [];
            var accuracy = [];
            var ctx = document.getElementById("dashboard_production_chart");

            if (!ctx) {
                return;
            }

            $.each(rows, function (index, row) {
                labels.push(dashCleanText(row.MonthYear));
                production.push(dashToNumber(row.Production));
                productionPerc.push(dashToNumber(row.ProductionPerc));
                accuracy.push(dashToNumber(row.Accuracy));
            });

            if (dashProductiveProductionChart) {
                dashProductiveProductionChart.destroy();
            }

            dashProductiveProductionChart = new Chart(ctx.getContext("2d"), {
                type: "bar",
                data: {
                    labels: labels,
                    datasets: [
                        {
                            label: "Production",
                            data: production,
                            backgroundColor: "rgba(79,129,189,0.65)",
                            borderColor: "#4F81BD",
                            borderWidth: 1,
                            yAxisID: "production-axis"
                        },
                        {
                            label: "Production %",
                            data: productionPerc,
                            type: "line",
                            fill: false,
                            borderColor: "#28a745",
                            backgroundColor: "rgba(40,167,69,0.08)",
                            pointRadius: 3,
                            yAxisID: "percent-axis"
                        },
                        {
                            label: "Accuracy %",
                            data: accuracy,
                            type: "line",
                            fill: false,
                            borderColor: "#6c757d",
                            backgroundColor: "rgba(108,117,125,0.08)",
                            pointRadius: 3,
                            yAxisID: "percent-axis"
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    legend: {
                        display: true,
                        position: "bottom"
                    },
                    tooltips: {
                        mode: "index",
                        intersect: false
                    },
                    scales: {
                        xAxes: [{
                            gridLines: {
                                display: false
                            }
                        }],
                        yAxes: [
                            {
                                id: "production-axis",
                                position: "left",
                                ticks: {
                                    beginAtZero: true,
                                    precision: 0
                                }
                            },
                            {
                                id: "percent-axis",
                                position: "right",
                                gridLines: {
                                    drawOnChartArea: false
                                },
                                ticks: {
                                    beginAtZero: true,
                                    callback: function (value) {
                                        return value + "%";
                                    }
                                }
                            }
                        ]
                    }
                }
            });
        }

        function dashRenderAttendanceTrendChart(rows) {
            var labels = [];
            var attendancePerc = [];
            var absentDays = [];
            var ctx = document.getElementById("dashboard_attendance_chart");

            if (!ctx) {
                return;
            }

            $.each(rows, function (index, row) {
                labels.push(dashAttendanceLabel(row));
                attendancePerc.push(dashToNumber(row.AttendancePercOnTotalDays));
                absentDays.push(dashToNumber(row.TotalAbsentDays));
            });

            if (dashProductiveAttendanceChart) {
                dashProductiveAttendanceChart.destroy();
            }

            dashProductiveAttendanceChart = new Chart(ctx.getContext("2d"), {
                type: "bar",
                data: {
                    labels: labels,
                    datasets: [
                        {
                            label: "Absent Days",
                            data: absentDays,
                            backgroundColor: "rgba(220,53,69,0.30)",
                            borderColor: "#dc3545",
                            borderWidth: 1,
                            yAxisID: "days-axis"
                        },
                        {
                            label: "Attendance %",
                            data: attendancePerc,
                            type: "line",
                            fill: false,
                            borderColor: "#4F81BD",
                            backgroundColor: "rgba(79,129,189,0.08)",
                            pointRadius: 3,
                            yAxisID: "attendance-axis"
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    legend: {
                        display: true,
                        position: "bottom"
                    },
                    tooltips: {
                        mode: "index",
                        intersect: false
                    },
                    scales: {
                        xAxes: [{
                            gridLines: {
                                display: false
                            }
                        }],
                        yAxes: [
                            {
                                id: "days-axis",
                                position: "left",
                                ticks: {
                                    beginAtZero: true
                                }
                            },
                            {
                                id: "attendance-axis",
                                position: "right",
                                gridLines: {
                                    drawOnChartArea: false
                                },
                                ticks: {
                                    beginAtZero: true,
                                    callback: function (value) {
                                        return value + "%";
                                    }
                                }
                            }
                        ]
                    }
                }
            });
        }

        function dashRenderProductiveTables(productionRows, attendanceRows) {
            if (dashIsTaskBasedEmployee()) {
                dashDestroyProductiveTable("#dashboard_prod_performance_table");
                $("#dashboard_prod_performance_table tbody").empty();
            }
            else {
                dashRenderProductionDetailsTable(productionRows);
            }

            dashRenderAttendanceDetailsTable(attendanceRows);

        }

        function dashIsTaskBasedEmployee() {
            return window.dashboardEmployeeProductivityMode === "Task" || window.dashboardIsTaskBasedEmployee === true;
        }

        function dashApplyProductiveEmployeeMode() {
            if (window.dashboardShouldLoadProductiveInsights === false) {
                $("#dashboard_productive_section").hide();
                return;
            }

            var isTaskBased = dashIsTaskBasedEmployee();
            $("#prod_dashboard_employee").show();
            $("#dashboard_productive_section").show();

            $(".productive-production-only").toggle(!isTaskBased);

            if (isTaskBased) {
                $(".productive-section-heading h5").html(
                    '<i class="far fa-calendar-check mr-1"></i>Attendance Insights'
                );

                $("#dashboard_productive_view_label").text("Attendance view");

                $(".productive-attendance-chart-col")
                    .removeClass("col-lg-4")
                    .addClass("col-lg-12");

                $(".productive-attendance-table-col")
                    .removeClass("col-lg-5")
                    .addClass("col-lg-12");

                $(".productive-attendance-kpi")
                    .removeClass("col-lg-2")
                    .addClass("col-lg-6");
            }
            else {
                $(".productive-section-heading h5").html(
                    '<i class="far fa-chart-bar mr-1"></i>Productive Employee Insights'
                );

                $("#dashboard_productive_view_label").text("Production and attendance view");

                $(".productive-attendance-chart-col")
                    .removeClass("col-lg-12")
                    .addClass("col-lg-4");

                $(".productive-attendance-table-col")
                    .removeClass("col-lg-12")
                    .addClass("col-lg-5");

                $(".productive-attendance-kpi")
                    .removeClass("col-lg-6")
                    .addClass("col-lg-2");
            }
        }

        function dashRenderProductionDetailsTable(rows) {
            var html = "";

            $.each(rows, function (index, row) {
                var code = blankForNull(row.Code);
                var fromDate = blankForNull(row.FromDateNew);
                var toDate = blankForNull(row.ToDateNew);
                var production = blankForNull(row.Production);

                html += "<tr>";
                html += "<td>" + dashEscape(row.MonthYear) + "</td>";
                /*html += "<td>" + dashEscape(row.Production) + "</td>";*/
                html += '<td>';
                html += '<a href="#!" onclick="return dash_showProductionDetails(\''
                    + code + '\',\''
                    + fromDate + '\',\''
                    + toDate + '\');">'
                    + production + '</a>';
                html += '</td>';
                html += "<td>" + dashEscape(row.ExpectedProductivity) + "</td>";
                html += "<td>" + dashEscape(row.Critical) + "</td>";
                html += "<td>" + dashEscape(row.NonCritical) + "</td>";
                html += "<td>" + dashEscape(row.TotalError) + "</td>";
                html += "<td>" + dashEscape(row.ProductionPerc) + "</td>";
                html += "<td>" + dashEscape(row.Accuracy) + "</td>";
                /*html += "<td>" + dashEscape(row.Attendance) + "</td>";*/
                html += "<td class=\"productive-grade-cell\">" + dashEscape(row.ProdGrade) + "</td>";
                html += "<td class=\"productive-grade-cell\">" + dashEscape(row.QAGrade) + "</td>";
                html += "</tr>";
            });

            dashDestroyProductiveTable("#dashboard_prod_performance_table");
            $("#dashboard_prod_performance_table tbody").html(html || "<tr><td colspan=\"10\" class=\"text-center text-muted\">No production details available.</td></tr>");

            if (html) {
                dashInitProductiveTable("#dashboard_prod_performance_table", "production");
            }
        }

        function dash_showProductionDetails(code, fromDate, toDate) {

            $.ajax({
                type: "POST",
                url: "DashboardEmployee.aspx/GetProductionDetails",
                data: JSON.stringify({
                    FromDate: fromDate,
                    ToDate: toDate,
                    Code: code
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (res) {

                    var data = typeof res.d === "string" ? JSON.parse(res.d) : res.d;
                    var html = "";

                    $.each(data, function (index, value) {
                        html += "<tr>";
                        html += "<td>" + (index + 1) + "</td>";
                        html += "<td>" + blankForNull(value.MY) + "</td>";
                        html += "<td>" + blankForNull(value.Code) + "</td>";
                        html += "<td>" + blankForNull(value.Project1) + "</td>";
                        html += "<td>" + blankForNull(value.Process1) + "</td>";
                        html += "<td>" + blankForNull(value.TotalProduction) + "</td>";
                        html += "</tr>";
                    });

                    if ($.fn.dataTable.isDataTable("#dash_tblProductionDetails")) {
                        $("#dash_tblProductionDetails").DataTable().destroy();
                    }

                    $("#dash_tblProductionDetails tbody").html(html);

                    $("#dash_tblProductionDetails").DataTable({
                        dom: dashboardDataTableDom(false),
                        scrollX: false,
                        destroy: true,
                        paging: true,
                        pageLength: 25,
                        lengthChange: false,
                        ordering: true,
                        order: [[1, "asc"]],
                        language: dashboardDataTableLanguage("production details"),

                        footerCallback: function () {
                            var api = this.api();

                            for (var i = 5; i <= 5; i++) {
                                var total = api.column(i, { page: "current" }).data().reduce(function (a, b) {
                                    return dash_toNumber(a) + dash_toNumber(b);
                                }, 0);

                                $(api.column(i).footer()).html(total.toFixed(2));
                            }
                        },

                        buttons: [
                            {
                                extend: "excelHtml5",
                                title: "Actual Production Details",
                                text: "Export",
                                autoFilter: true
                            }
                        ]
                    });

                    $("#productionDetailsModal").modal("show");
                },

                error: function (err) {
                    alert("Error loading production details");
                    console.log(err.responseText);
                }
            });

            return false;
        }

        function dash_toNumber(value) {
            value = blankForNull(value).toString().replace(/,/g, "").replace(/%/g, "");
            var number = parseFloat(value);
            return isNaN(number) ? 0 : number;
        }

        function dashRenderAttendanceDetailsTable(rows) {
            var html = "";

            $.each(rows, function (index, row) {
                html += "<tr>";
                html += "<td>" + dashEscape(dashAttendanceLabel(row)) + "</td>";
                html += "<td>" + dashEscape(row.TotalCalenderDays) + "</td>";
                html += "<td>" + dashEscape(row.SalaryPresentDays) + "</td>";
                html += "<td>" + dashEscape(row.AbsentDays) + "</td>";
                html += "<td>" + dashEscape(row.PartialDays) + "</td>";
                html += "<td>" + dashEscape(row.TotalAbsentDays) + "</td>";
                html += "<td>" + dashAttendancePercentCell(row.AttendancePercOnTotalDays) + "</td>";
                html += "<td>" + dashEscape(row.TotalLatemarks) + "</td>";
                html += "</tr>";
            });

            dashDestroyProductiveTable("#dashboard_prod_attendance_table");
            $("#dashboard_prod_attendance_table tbody").html(html || "<tr><td colspan=\"8\" class=\"text-center text-muted\">No attendance details available.</td></tr>");

            if (html) {
                dashInitProductiveTable("#dashboard_prod_attendance_table", "attendance");
            }
        }

        function dashDestroyProductiveTable(selector) {
            if ($.fn.dataTable && $.fn.dataTable.isDataTable(selector)) {
                $(selector).DataTable().destroy();
            }
        }

        function dashInitProductiveTable(selector, scope) {
            if (!$.fn.DataTable) {
                return;
            }

            $(selector).DataTable({
                dom: "t",
                scrollX: true,
                destroy: true,
                paging: false,
                autoWidth: false,
                ordering: false,
                processing: true,
                language: typeof dashboardDataTableLanguage === "function" ? dashboardDataTableLanguage(scope) : {
                    info: "Showing _START_ to _END_ of _TOTAL_",
                    infoEmpty: "No records available",
                    zeroRecords: "No matching records found"
                }
            });
        }

        function dashAttendancePercentCell(value) {
            var number = dashToNumber(value);
            var text = dashEscape(value);

            if (text === "") {
                return "";
            }

            if (number < 95) {
                return "<span class=\"productive-alert-badge\">" + text + "</span>";
            }

            return text;
        }

        function dashAttendanceLabel(row) {
            var month = dashCleanText(row.Month);
            var year = dashCleanText(row.Year);

            if (month && year) {
                return month + "-" + year;
            }

            return month || year;
        }

        function dashSumRows(rows, fieldName) {
            var total = 0;

            $.each(rows || [], function (index, row) {
                total += dashToNumber(row[fieldName]);
            });

            return total;
        }

        function dashAverageRows(rows, fieldName) {
            var total = 0;
            var count = 0;

            $.each(rows || [], function (index, row) {
                var value = dashCleanText(row[fieldName]);

                if (value !== "") {
                    total += dashToNumber(value);
                    count++;
                }
            });

            return count === 0 ? 0 : total / count;
        }

        function dashFormatWhole(value) {
            return Math.round(dashToNumber(value)).toLocaleString("en-IN");
        }

        function dashFormatOne(value) {
            return dashToNumber(value).toFixed(1);
        }

        function dashFormatPercent(value) {
            return dashFormatOne(value) + "%";
        }

        function dashToNumber(value) {
            var text = dashCleanText(value).replace(/,/g, "").replace(/%/g, "").replace(/[^0-9.\-]/g, "");
            var number = parseFloat(text);

            return isNaN(number) ? 0 : number;
        }

        function dashCleanText(value) {
            if (value === null || typeof value === "undefined" || value === "null") {
                return "";
            }

            return String(value);
        }

        function dashEscape(value) {
            return $("<div/>").text(dashCleanText(value)).html();
        }
    </script>

    <script>

        $(document).ready(function () {
            var userId = '<%= HttpContext.Current.User.Identity.Name.ToString() %>';

            $("#dash_anniversaryModal")
                .off("hidden.bs.modal.anniversaryDismiss")
                .on("hidden.bs.modal.anniversaryDismiss", dash_rememberAnniversaryDismissal);

            New_workAnniversary();
            window.dashboardShouldLoadProductiveInsights = userId !== "10161";
            window.dashboardProductiveInsightsRequested = false;

            dash_bindBasciInfo();
            dash_bindImpNotification()

            if (userId == 10161)
                document.getElementById("dash_board").style.display = 'none';
            else
                document.getElementById("dash_board").style.display = '';

            if (userId == 12 || userId == 7036 || userId == 8082 || userId == 8938) {
                document.getElementById("onlymgmt").style.display = '';
                dash_bindManpowerSumary('All')
            }
            else {
                document.getElementById("onlymgmt").style.display = 'none';
            }

            console.log("Page Loaded ✅");

        });


        function dash_anniversaryDismissalKey() {
            return "dashboardWorkAnniversaryDismissed_" + '<%= HttpContext.Current.User.Identity.Name.ToString() %>';
        }

        function dash_anniversaryTodayKey() {
            var today = new Date();
            return today.getFullYear() + "-" +
                ("0" + (today.getMonth() + 1)).slice(-2) + "-" +
                ("0" + today.getDate()).slice(-2);
        }

        function dash_anniversaryWasDismissedToday() {
            try {
                return window.localStorage.getItem(dash_anniversaryDismissalKey()) === dash_anniversaryTodayKey();
            }
            catch (ex) {
                return false;
            }
        }

        function dash_rememberAnniversaryDismissal() {
            try {
                window.localStorage.setItem(dash_anniversaryDismissalKey(), dash_anniversaryTodayKey());
            }
            catch (ex) {
            }
        }

        function New_workAnniversary() {
            if (dash_anniversaryWasDismissedToday()) {
                return;
            }

            $.ajax({
                type: "POST",
                url: "DashboardEmployee.aspx/GetEmpWorkAnniversary",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    new_renderWorkAnniversary(response.d);
                },
                error: function () {
                    console.error("Anniversary API error");
                }
            });
        }

        function dash_escapeAnniversary(value) {
            return $("<div>").text(value == null ? "" : value).html();
        }

        function dash_anniversaryInitials(name) {
            var parts = $.trim(name || "").split(/\s+/).filter(Boolean);
            if (!parts.length) return "IP";
            return (parts[0].charAt(0) + (parts.length > 1 ? parts[parts.length - 1].charAt(0) : "")).toUpperCase();
        }

        function dash_completedServiceYears(joiningDate, yearsCompleted) {
            var years = parseInt(yearsCompleted, 10);
            var joined = new Date(joiningDate);

            if (!isNaN(joined.getTime())) {
                var today = new Date();
                years = today.getFullYear() - joined.getFullYear();

                if (today.getMonth() < joined.getMonth() ||
                    (today.getMonth() === joined.getMonth() && today.getDate() < joined.getDate())) {
                    years--;
                }
            }

            return Math.max(0, isNaN(years) ? 0 : years);
        }

        function new_renderWorkAnniversary(data) {
            if (!data || data.length === 0) {
                return false;
            }

            var cards = $.map(data, function (emp, index) {
                var name = dash_escapeAnniversary(emp.EmpName || "Employee");
                var designation = dash_escapeAnniversary(emp.Designation || "—");
                var department = dash_escapeAnniversary(emp.DepartmentName || "—");
                var branch = dash_escapeAnniversary(emp.BranchName || "—");
                var manager = dash_escapeAnniversary(emp.ReportingManager || "—");
                var joiningDate = dash_escapeAnniversary(emp.JoiningDate || "—");
                var domain = dash_escapeAnniversary(emp.DomainName || "");
                var years = dash_completedServiceYears(emp.JoiningDate, emp.YearsCompleted);
                var yearLabel = years === 1 ? "YEAR" : "YEARS";
                return '<div class="carousel-item' + (index === 0 ? ' active' : '') + '">' +
                    '<article class="anniv-profile">' +
                    '<div class="anniv-profile-left">' +
                        '<span class="anniv-panel-orb anniv-panel-orb-top"></span>' +
                        '<span class="anniv-panel-orb anniv-panel-orb-bottom"></span>' +
                        '<span class="anniv-panel-orb anniv-panel-orb-corner"></span>' +
                        '<span class="anniv-brand">INFINITY IPS</span>' +
                        '<span class="anniv-ribbon">CONGRATULATIONS!</span>' +
                        '<span class="anniv-confetti anniv-confetti-one"></span>' +
                        '<span class="anniv-confetti anniv-confetti-two"></span>' +
                        '<div class="anniv-avatar"><span class="anniv-camera" aria-hidden="true"><svg viewBox="0 0 48 48" focusable="false"><path d="M16 14l3-5h10l3 5h6a4 4 0 014 4v18a4 4 0 01-4 4H10a4 4 0 01-4-4V18a4 4 0 014-4h6zm8 20a8 8 0 100-16 8 8 0 000 16z"/><circle cx="24" cy="26" r="5"/></svg></span><small>ADD EMPLOYEE PHOTO</small></div>' +
                        '<h3>[' + name + ']</h3>' +
                        '<p>[Location: ' + branch + ']</p>' +
                        '<span class="anniv-balloons" aria-hidden="true"><i></i><i></i></span>' +
                        '<div class="anniv-service-badge"><span class="anniv-trophy-mark">♛</span><strong>' + years + ' ' + yearLabel.charAt(0) + yearLabel.slice(1).toLowerCase() + '</strong></div>' +
                    '</div>' +
                    '<div class="anniv-profile-right">' +
                        '<span class="anniv-kicker">✦ CELEBRATION TIME</span>' +
                        '<h2>HAPPY WORK<br><em>ANNIVERSARY!</em></h2>' +
                        '<p class="anniv-intro">Today we celebrate <strong>' + name + '</strong> and ' + years + ' ' + yearLabel.toLowerCase() + ' of dedication, growth, and outstanding contribution to our team.</p>' +
                        '<div class="anniv-details">' +
                            '<div><i>▣</i><span><small>DATE OF JOINING</small><strong>' + joiningDate + '</strong></span></div>' +
                            '<div><i>▥</i><span><small>CURRENT ROLE</small><strong>' + designation + '</strong></span></div>' +
                            '<div><i>♧</i><span><small>DEPARTMENT</small><strong>' + department + '</strong></span></div>' +
                            '<div><i>●</i><span><small>REPORTING MANAGER</small><strong>' + manager + '</strong></span></div>' +
                            // (domain ? '<div><i>◇</i><span><small>DOMAIN</small><strong>' + domain + '</strong></span></div>' : '') +
                        '</div>' +
                        '<div class="anniv-thanks">✦ <span>Thank you for being an invaluable part of the Infinity IPS family. Here’s to many more years of success together!</span></div>' +
                    '</div>' +
                    '</article>' +
                '</div>';
            }).join("");

            var indicators = $.map(data, function (emp, index) {
                var label = "Show " + (emp.EmpName || ("employee " + (index + 1)));
                return '<button type="button" class="anniv-carousel-dot' + (index === 0 ? ' active' : '') + '" data-target="#dash_anniversaryCarousel" data-slide-to="' + index + '" aria-label="' + dash_escapeAnniversary(label) + '"></button>';
            }).join("");

            $("#dash_anniversaryList").html(cards);
            $("#dash_anniversaryIndicators").html(indicators);
            $("#dash_anniversaryCarouselNav").toggle(data.length > 1);
            $("#dash_anniversaryPosition").text("1 / " + data.length);

            var $carousel = $("#dash_anniversaryCarousel");
            $carousel.carousel({ interval: false, wrap: true, keyboard: true });
            $carousel.carousel(0);
            $carousel.off("slide.bs.carousel.workAnniversary").on("slide.bs.carousel.workAnniversary", function (event) {
                var nextIndex = typeof event.to === "number" ? event.to : 0;
                $("#dash_anniversaryPosition").text((nextIndex + 1) + " / " + data.length);
                $("#dash_anniversaryIndicators .anniv-carousel-dot").removeClass("active").eq(nextIndex).addClass("active");
            });

            $("#dash_anniversaryModal").modal("show");
            return false;
        }

        function empBirthdays() {

            $('#dash_birthdayModal_all').modal('show');

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
                            console.error("Birthday JSON parse error", e);
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
                    console.error("Birthday API error");
                    callback();
                }
            });
        }
    </script>

    <script>
        $(document).ready(function () {

            /*  localStorage.clear();*/

            runPopupSequence();
        });

    </script>
    <%-- <script src="../Scripts/Functions/NewDashboard.js"></script>--%>
    <%-- <script src="../Scripts/Functions/NewDash.js"></script>--%>
    <%--<script src="../Scripts/Functions/NewDash2.js"></script>--%>
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input type="hidden" id="hdnUserId" value="<%= HttpContext.Current.User.Identity.Name.ToString() %>" />
    <input type="hidden" id="hdnLoginTime" value="<%= Session["LoginTime"] %>" />

    <div class="dashboard-main-page">
        <!-------------- Main Part OF Dashboard ------------->
        <div class="row dashboard-row" style="padding-top: 10px; display: none;" id="dash_board" data-intro="This is your main dashboard." data-step="1">
            <div class="col-md-4">
                <!-- Widget: user widget style 1 -->
                <div class="card card-widget widget-user shadow dashboard-profile-card" style="height: 270px;" data-intro="Here you can quickly access your Productivity, Attendance, and Profile details in one place." data-step="2">
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
                        <a class="animation__shake" style="color: white;" href="Birthday.aspx">
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
                <div class="dashboard-card important-notification dashboard-notification-card dashboard-table-card">
                    <div class="card-header dashboard-card-header ui-sortable-handle" style="padding: 5px 1.25rem!important;">
                        <h3 class="card-title dashboard-card-title">
                            <i class="fas fa-info-circle mr-1"></i>
                            Important Notifications
                        </h3>
                        <div class="card-tools">
                            <%--<a class="nav-link active" href="Notifications.aspx">View All</a>--%>
                        </div>
                    </div>
                    <table class="table1 dashboard-table" id="dashboard_alert_table" style="padding-top: 0px; font-size: 11px; width: 100%;">
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
        <div class="row col-lg-12">

            <% if (HttpContext.Current.User.Identity.Name.ToString() == "7036")
                { %>
            <div class="col-lg-3 col-md-4 col-sm-6 mb-3">
                <a href="HRDashboard.aspx"
                    class="card shadow-sm border-0 text-decoration-none h-100 hr-dashboard-highlight">
                    <div class="card-body text-center">
                        <i class="fas fa-chart-bar fa-2x text-primary mb-2"></i>
                        <h5 class="mb-1 text-dark">HR Dashboard</h5>
                        <span class="badge bg-primary mt-2">NEW</span>
                        <p class="text-muted small mb-0">
                            View HR analytics & manpower insights
                        </p>
                    </div>
                </a>
            </div>
            <% } %>

            <% if (HttpContext.Current.User.Identity.Name.ToString() == "12" || HttpContext.Current.User.Identity.Name.ToString() == "7036")
                { %>
            <div class="col-lg-3 col-md-4 col-sm-6 mb-3">
                <a href="ProductionDashboard.aspx"
                    class="card shadow-sm border-0 text-decoration-none h-100 hr-dashboard-highlight">
                    <div class="card-body text-center">
                        <i class="fas fa-chart-bar fa-2x text-primary mb-2"></i>
                        <h5 class="mb-1 text-dark">Production Dashboard</h5>
                        <span class="badge bg-primary mt-2">NEW</span>
                        <p class="text-muted small mb-0">
                            View production details domain wise
                        </p>
                    </div>
                </a>
            </div>
            <% } %>
        </div>
        <!-------------- Productive Employee Insights ------------->
        <div id="prod_dashboard_employee">
            <div class="row dashboard-productive-row productive-section" id="dashboard_productive_section" style="display: none;">
                <div class="productive-section-loading" id="dashboard_productive_loading">
                    <div class="productive-loading-box">
                        <i class="fas fa-spinner fa-spin"></i>
                        <span>Loading insights...</span>
                    </div>
                </div>
                <div class="col-md-12">
                    <div class="productive-section-heading">
                        <div>
                            <h5><i class="far fa-chart-bar mr-1"></i>Productive Employee Insights</h5>
                            <span class="productive-section-subtitle">
                                <span id="dashboard_productive_view_label">Production and attendance view</span>
                                <label for="dashboard_productive_action" class="mb-0 ml-2">Action</label>
                                <select id="dashboard_productive_action" class="productive-period-select" onchange="return dash_bindProductiveEmployeeInsights();">
                                    <option value="Last12Months">Last 12 months</option>
                                    <option value="LatestIncrement">From Latest Increment till month</option>
                                    <option value="CurrentMonth">Current Month</option>
                                </select>
                                <span id="dashboard_productive_period" class="productive-period-detail"></span>
                                <span id="dashboard_productive_range_message" class="productive-period-message"></span>
                            </span>
                        </div>
                        <div class="productive-section-actions">
                            <a class="productive-production-only" href="DasboardPerformanceDetails.aspx">Production Details</a>
                            <span class="productive-production-only">|</span>
                            <a href="DetailedAttendancePercentage.aspx">Attendance Details</a>
                        </div>
                    </div>
                    <div class="productive-empty-state" id="dashboard_productive_empty" style="display: none;">
                        No productive employee details available.
               
                    </div>
                </div>

                <div class="col-md-12" id="dashboard_productive_content" style="display: none;">
                    <div class="row">
                        <div class="col-lg-2 col-md-4 col-sm-6 productive-production-only">
                            <div class="productive-kpi-card">
                                <div class="productive-kpi-label">Total Production</div>
                                <div class="productive-kpi-value" id="dashboard_kpi_total_production">0</div>
                                <div class="productive-kpi-note" id="dashboard_kpi_total_production_note">Latest: 0</div>
                            </div>
                        </div>
                        <div class="col-lg-2 col-md-4 col-sm-6 productive-production-only">
                            <div class="productive-kpi-card">
                                <div class="productive-kpi-label">Expected Productivity</div>
                                <div class="productive-kpi-value" id="dashboard_kpi_expected_productivity">0</div>
                                <div class="productive-kpi-note" id="dashboard_kpi_expected_productivity_note">Latest: 0</div>
                            </div>
                        </div>
                        <div class="col-lg-2 col-md-4 col-sm-6 productive-production-only">
                            <div class="productive-kpi-card">
                                <div class="productive-kpi-label">Avg Production %</div>
                                <div class="productive-kpi-value" id="dashboard_kpi_production_perc">0.0%</div>
                                <div class="productive-kpi-note" id="dashboard_kpi_production_perc_note">Grade: -</div>
                            </div>
                        </div>
                        <div class="col-lg-2 col-md-4 col-sm-6 productive-production-only">
                            <div class="productive-kpi-card">
                                <div class="productive-kpi-label">Avg Accuracy %</div>
                                <div class="productive-kpi-value" id="dashboard_kpi_accuracy">0.0%</div>
                                <div class="productive-kpi-note" id="dashboard_kpi_accuracy_note">QA grade: -</div>
                            </div>
                        </div>
                        <div class="col-lg-2 col-md-4 col-sm-6 productive-attendance-kpi">
                            <div class="productive-kpi-card">
                                <div class="productive-kpi-label">Avg Attendance %</div>
                                <div class="productive-kpi-value" id="dashboard_kpi_attendance">0.0%</div>
                                <div class="productive-kpi-note" id="dashboard_kpi_attendance_note">Latest: 0.0%</div>
                            </div>
                        </div>
                        <div class="col-lg-2 col-md-4 col-sm-6 productive-attendance-kpi">
                            <div class="productive-kpi-card">
                                <div class="productive-kpi-label">Latemarks</div>
                                <div class="productive-kpi-value" id="dashboard_kpi_latemarks">0</div>
                                <div class="productive-kpi-note" id="dashboard_kpi_latemarks_note">Removed: 0</div>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-lg-8 productive-production-only">
                            <div class="card dashboard-table-card productive-chart-card">
                                <div class="card-header dashboard-card-header">
                                    <h5 class="card-title dashboard-card-title">Production Trend</h5>
                                </div>
                                <div class="card-body">
                                    <div class="productive-chart-wrap">
                                        <canvas id="dashboard_production_chart"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4 productive-attendance-chart-col">
                            <div class="card dashboard-table-card productive-chart-card">
                                <div class="card-header dashboard-card-header">
                                    <h5 class="card-title dashboard-card-title">Attendance Trend</h5>
                                </div>
                                <div class="card-body">
                                    <div class="productive-chart-wrap">
                                        <canvas id="dashboard_attendance_chart"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-lg-7 productive-production-only">
                            <div class="card dashboard-table-card">
                                <div class="card-header dashboard-card-header">
                                    <h5 class="card-title dashboard-card-title">Production Details</h5>
                                </div>
                                <div class="card-body">
                                    <table class="table table-bordered dashboard-table productive-detail-table" id="dashboard_prod_performance_table" style="width: 100%;">
                                        <thead>
                                            <tr>
                                                <th>Month-Year</th>
                                                <th>Production</th>
                                                <th>Expected Productivity</th>
                                                <th>Critical</th>
                                                <th>Non Critical</th>
                                                <th>Total Errors</th>
                                                <th>Production %</th>
                                                <th>Accuracy %</th>
                                                <%--<th>Attendance %</th>--%>
                                                <th>Prod Grade</th>
                                                <th>QA Grade</th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-5 productive-attendance-table-col">
                            <div class="card dashboard-table-card">
                                <div class="card-header dashboard-card-header">
                                    <h5 class="card-title dashboard-card-title">Attendance Details</h5>
                                </div>
                                <div class="card-body">
                                    <table class="table table-bordered table-striped dashboard-table productive-detail-table" id="dashboard_prod_attendance_table" style="width: 100%;">
                                        <thead>
                                            <tr>
                                                <th>Month-Year</th>
                                                <th>Total Days</th>
                                                <th>Present Days</th>
                                                <th>Absent Days</th>
                                                <th>Partial Days</th>
                                                <th>Total Absents</th>
                                                <th>Attendance %</th>
                                                <th>Latemarks</th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-------------- Branch > Domain > Subdomain wise Manpower Summary ------------->
        <div class="row dashboard-management-row" style="display: none;">
            <div class="col-md-12">
                <div class="card dashboard-table-card dashboard-manpower-card" id="onlymgmt">
                    <div class="card-header dashboard-card-header">
                        <h5 class="card-title dashboard-card-title">Branch > Domain > Subdomain wise Manpower Summary</h5>

                        <div class="card-tools dashboard-card-tools">
                            <a class="dashboard-report-shortcut" href="ManagementReports.aspx" title="Management Reports">
                                <i class="fas fa-chart-line"></i><span>Management Reports</span>
                            </a>
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
                                <table class="table dashboard-table" id="dasboard_currentmanpower" style="width: 100%;">
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

    </div>

    <!-------------- User Personal & Profile Info  ------------->
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
                        <%-- <div class="modal-footer justify-content-between">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                        </div>--%>
                    </div>
                    <!-- /.modal-content -->
                </div>
                <!-- /.modal-dialog -->
            </div>
        </div>
    </div>

    <!-------------- Branch > Domain > Subdomain wise Manpower Details ------------->
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

    <!-------------- Client Holiday List ------------->
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
                            <td>Thursday</td>
                            <td>01-January</td>
                        </tr>
                        <tr>
                            <td>Memorial Day</td>
                            <td>Monday</td>
                            <td>25-May</td>
                        </tr>
                        <tr>
                            <td>Independence Day</td>
                            <td>Friday</td>
                            <td>03-July</td>
                        </tr>
                        <tr>
                            <td>Labor Day</td>
                            <td>Monday</td>
                            <td>07-September</td>
                        </tr>
                        <tr>
                            <td>Thanks Giving Day</td>
                            <td>Thursday</td>
                            <td>26-November</td>
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



    <!----------------------------------------------- Pop-UPs ------------------------------------------------>

    <!-------------- Welcome Intro ------------->
    <div id="dashwelcomeIntro" class="intro-overlay" style="display: none;">
        <div class="intro-box">
            <h3>Welcome to Your Workspace 👋</h3>
            <p>Let’s walk you through the main features to help you get started.</p>

            <div class="intro-buttons">
                <button id="btndashSkipIntro" type="button" class="btn-skip">Skip</button>
                <button id="btndashStartIntro" type="button" class="btn-next">Next</button>
            </div>
        </div>
    </div>
    <div id="dashfinalMessagePopup" class="intro-overlay" style="display: none;">
        <div class="intro-box">
            <h3>You're All Set 🎉</h3>
            <p>You are now ready to explore the new ERP system.  Please use the platform and share your valuable feedback with us.</p>

            <div class="intro-buttons">
                <button id="btnCloseFinal" class="btn-next">Got It</button><%-- class="btn-next"--%>
            </div>
        </div>
    </div>


    <!-------------- Own Birthday ------------->
    <div class="modal fade" id="birthdayModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered birthday-dialog">
            <div class="modal-content birthday-popup">
                <div class="modal-body text-center position-relative">

                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>

                    <div class="birthday-ribbon ribbon-left"></div>
                    <div class="birthday-ribbon ribbon-right"></div>

                    <div class="balloon balloon-left-one"></div>
                    <div class="balloon balloon-left-two"></div>
                    <div class="balloon balloon-right-one"></div>
                    <div class="balloon balloon-right-two"></div>

                    <div class="birthday-icon">
                        <i class="fas fa-birthday-cake"></i>
                    </div>

                    <h2 class="birthday-title">Happy Birthday</h2>

                    <div class="birthday-divider"></div>

                    <h4 id="lblBirthdayName" style="color: #EE0D63!important;"></h4>

                    <p>Wishing you a wonderful year ahead!</p>

                </div>
            </div>
        </div>
    </div>


    <!-------------- Work Anniversary ------------->
    <div class="modal fade" id="dash_anniversaryModal" tabindex="-1" role="dialog" aria-label="Work anniversary" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered anniversary-dialog" role="document">
            <div class="modal-content workanniversary-modal">
                <button type="button" class="anniv-close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <div class="modal-body anniv-modal-body">
                    <div id="dash_anniversaryCarousel" class="carousel slide anniv-carousel" data-interval="false" data-wrap="true">
                        <div id="dash_anniversaryList" class="carousel-inner"></div>
                        <div id="dash_anniversaryCarouselNav" class="anniv-carousel-nav">
                            <button type="button" class="anniv-carousel-arrow anniv-carousel-prev" data-target="#dash_anniversaryCarousel" data-slide="prev" aria-label="Previous employee"><span aria-hidden="true">&#8249;</span></button>
                            <div class="anniv-carousel-progress">
                                <div id="dash_anniversaryIndicators" class="anniv-carousel-indicators"></div>
                                <span id="dash_anniversaryPosition" class="anniv-carousel-position"></span>
                            </div>
                            <button type="button" class="anniv-carousel-arrow anniv-carousel-next" data-target="#dash_anniversaryCarousel" data-slide="next" aria-label="Next employee"><span aria-hidden="true">&#8250;</span></button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>




    <!-------------- Employee's Birthday ------------->
    <div class="modal fade" id="dash_birthdayModal_all">
        <div class="modal-dialog modal-dialog-centered birthday-list-dialog">
            <div class="modal-content birthday-list-popup">

                <div class="modal-header birthday-list-header">

                    <div class="birthday-header-content">
                        <div class="birthday-header-icon">
                            🎂
                        </div>

                        <div>
                            <h4>Today's Birthdays</h4>
                            <small>Let's celebrate our colleagues</small>
                        </div>
                    </div>

                    <button type="button"
                        class="close birthday-close"
                        data-dismiss="modal">
                        <span>&times;</span>
                    </button>

                </div>

                <div class="modal-body birthday-list-body">

                    <div class="birthday-confetti"></div>

                    <div id="dash_birthdayList"></div>

                </div>

            </div>
        </div>
    </div>


    <!-------------- Festival ------------->
    <div class="modal fade" id="dash_festWish_PopUp">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">

                <div class="modal-header">
                    <h5 id="dash_popupGreeting"></h5>
                    <button type="button" class="close" data-dismiss="modal">
                        <span>&times;</span>
                    </button>
                </div>

                <div class="modal-body text-center">
                    <img id="dash_festivalImage" style="max-width: 100%;" />
                </div>

            </div>
        </div>
    </div>


    <!-------------- Project Notifications ------------->
    <div id="dash_projectNotifications" class="modal fade" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="prjN_alertTitle"></h5>
                </div>
                <div class="modal-body">
                    <p id="prjN_alertMessage"></p>
                    <div id="prjN_attachmentDiv" style="display: none;">
                        <a id="prjN_downloadFile" class="btn btn-outline-primary" target="_blank">Download Attachment</a>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" onclick="return goToNextAlert();">Mark as Read</button>
                    <button type="button" id="btnCloseExpiry" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>


    <!-------------- Dashboard Alert ------------->
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


    <!-------------- Password Expiry Notification ------------->
    <div id="dash_expiryModal" class="modal fade">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content erp-modal-box">

                <div class="modal-header warning-header">
                    <h5 class="modal-title">Password Expiry Notice</h5>
                </div>

                <div class="modal-body">
                    <p id="expiryText"></p>
                    <p>Your ERP password is about to expire. Please reset your password to avoid interruption.</p>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" id="btnRemind"><b>Remind Me Later</b></button>
                    <a href="ChangePassword.aspx" rel="noopener noreferrer" class="btn btn-primary">Reset Password</a>
                </div>
            </div>
        </div>
    </div>


    <!-------------- Pending Task Notifications ------------->
    <div class="modal fade" id="dash_pendingnotifications" style="max-height: 500px; overflow-y: auto;" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="staticBackdropLabel" aria-hidden="true">
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
                <div class="modal-footer">
                    <button class="btn btn-primary" data-dismiss="modal"><span id="totalCount"></span></button>
                    <button type="button" id="btnpendingClose" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="productionDetailsModal" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-xl" role="document">
            <div class="modal-content">

                <div class="modal-header">
                    <h5 class="modal-title">Actual Production Details
                    </h5>
                    <button type="button" class="close" data-dismiss="modal">
                        <span>&times;</span>
                    </button>
                </div>

                <div class="modal-body">
                    <table id="dash_tblProductionDetails" class="table table-bordered table-striped table-sm w-100">
                        <thead>
                            <tr>
                                <th>Sr. #</th>
                                <th>Month-Year</th>
                                <th>Code</th>
                                <th>Project</th>
                                <th>Process</th>
                                <th>Total Production</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                        <tfoot>
                            <tr>
                                <th>Total</th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>

                            </tr>
                        </tfoot>
                    </table>
                </div>

            </div>
        </div>
    </div>


    <style id="ownBirthday_style">
        #birthdayModal .birthday-dialog {
            max-width: 850px !important;
            width: 92% !important;
        }

        .birthday-popup {
            border: none;
            border-radius: 30px;
            overflow: hidden;
            background: linear-gradient(135deg, #ff4f9a 0%, #ff8ab3 42%, #fff06a 100%) !important;
            box-shadow: 0 28px 70px rgba(0,0,0,.28);
            animation: popupZoom .45s ease;
        }

            .birthday-popup .modal-body {
                min-height: 520px;
                padding: 70px 70px 55px;
                position: relative;
                overflow: hidden;
                background: radial-gradient(circle at 15% 20%, rgba(255,255,255,.45), transparent 18%), radial-gradient(circle at 80% 20%, rgba(255,255,255,.38), transparent 20%), linear-gradient(135deg, #ff3f91 0%, #ff8ab3 45%, #fff176 100%) !important;
            }

                /* Confetti dots */
                .birthday-popup .modal-body::before {
                    content: "";
                    position: absolute;
                    inset: 0;
                    background-image: radial-gradient(#fff 2px, transparent 2px), radial-gradient(#ffd700 2px, transparent 2px), radial-gradient(#ff1493 2px, transparent 2px);
                    background-size: 55px 55px, 80px 80px, 95px 95px;
                    background-position: 10px 20px, 30px 60px, 70px 10px;
                    opacity: .45;
                    pointer-events: none;
                }

        /* Cake icon */
        .birthday-icon {
            position: relative;
            z-index: 5;
            width: 135px;
            height: 135px;
            margin: 0 auto 20px;
            border-radius: 50%;
            background: linear-gradient(135deg, #ff007f, #ff4fa3);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 58px;
            border: 5px solid rgba(255,255,255,.85);
            box-shadow: 0 18px 40px rgba(255,0,127,.45), 0 0 0 10px rgba(255,255,255,.18);
            animation: cakeMove 2.2s infinite ease-in-out;
        }

            .birthday-icon::after {
                content: "";
                position: absolute;
                width: 105px;
                height: 18px;
                bottom: -22px;
                border-radius: 50%;
                background: rgba(255,255,255,.45);
                filter: blur(3px);
                animation: shadowMove 2.2s infinite ease-in-out;
            }

            /* Animated small shake on icon */
            .birthday-icon i {
                animation: cakeShake 1.4s infinite ease-in-out;
            }

        /* Title */
        .birthday-title {
            position: relative;
            z-index: 5;
            margin-top: 25px;
            margin-bottom: 8px;
            font-size: 56px;
            font-weight: 800;
            color: #fff;
            letter-spacing: .5px;
            text-shadow: 0 5px 12px rgba(191, 0, 94, .55);
            font-family: "PMingLiU-ExtB", "PMingLiU", serif;
            font-style: italic;
        }

        #lblBirthdayName {
            position: relative;
            z-index: 5;
            font-size: 42px;
            font-weight: 800;
            color: #b0004f;
            margin-top: 18px;
            text-shadow: 0 2px 4px rgba(255,255,255,.6);
        }

        .birthday-popup p {
            position: relative;
            z-index: 5;
            font-size: 22px;
            color: #3b2350;
            margin-top: 18px;
            font-weight: 600;
        }

        .birthday-divider {
            position: relative;
            z-index: 5;
            width: 150px;
            height: 5px;
            border-radius: 20px;
            margin: 16px auto;
            background: rgba(255,255,255,.9);
            box-shadow: 0 3px 10px rgba(255,255,255,.4);
        }

        /* Close Button */
        .birthday-popup .close {
            position: absolute;
            z-index: 20;
            top: 22px;
            right: 24px;
            width: 52px;
            height: 52px;
            border-radius: 50%;
            border: none;
            background: #fff;
            font-size: 40px;
            line-height: 45px;
            color: #e91e63;
            box-shadow: 0 10px 25px rgba(0,0,0,.18);
            transition: .3s;
        }

            .birthday-popup .close:hover {
                background: #e91e63;
                color: #fff;
                transform: rotate(90deg);
            }

        /* Balloons */
        .balloon {
            position: absolute;
            z-index: 2;
            width: 78px;
            height: 95px;
            border-radius: 50% 50% 45% 45%;
            opacity: .95;
            animation: balloonFloat 3s infinite ease-in-out;
        }

            .balloon::after {
                content: "";
                position: absolute;
                left: 50%;
                bottom: -80px;
                width: 2px;
                height: 85px;
                background: rgba(255,255,255,.7);
            }

            .balloon::before {
                content: "";
                position: absolute;
                top: 18px;
                left: 18px;
                width: 22px;
                height: 32px;
                border-radius: 50%;
                background: rgba(255,255,255,.45);
            }

        .balloon-left-one {
            left: 35px;
            top: 95px;
            background: linear-gradient(135deg, #ff3f91, #ff9ac5);
        }

        .balloon-left-two {
            left: 105px;
            top: 190px;
            width: 68px;
            height: 84px;
            background: linear-gradient(135deg, #ffd83d, #ff9d00);
            animation-delay: .5s;
        }

        .balloon-right-one {
            right: 45px;
            top: 100px;
            background: linear-gradient(135deg, #ff4f9a, #ffb3d2);
            animation-delay: .4s;
        }

        .balloon-right-two {
            right: 120px;
            top: 190px;
            width: 70px;
            height: 88px;
            background: linear-gradient(135deg, #ffe45c, #ffad00);
            animation-delay: .8s;
        }

        /* Ribbons */
        .birthday-ribbon {
            position: absolute;
            z-index: 1;
            width: 220px;
            height: 28px;
            border-radius: 50%;
            border-top: 12px solid rgba(255, 0, 127, .65);
            transform: rotate(-18deg);
            opacity: .9;
        }

        .ribbon-left {
            left: -40px;
            bottom: 55px;
        }

        .ribbon-right {
            right: -40px;
            bottom: 75px;
            transform: rotate(18deg);
            border-top-color: rgba(255, 193, 7, .8);
        }

        /* Animations */
        @keyframes popupZoom {
            from {
                transform: scale(.7);
                opacity: 0;
            }

            to {
                transform: scale(1);
                opacity: 1;
            }
        }

        @keyframes cakeMove {
            0% {
                transform: translateY(0) rotate(0deg);
            }

            25% {
                transform: translateY(-8px) rotate(-3deg);
            }

            50% {
                transform: translateY(0) rotate(0deg);
            }

            75% {
                transform: translateY(-8px) rotate(3deg);
            }

            100% {
                transform: translateY(0) rotate(0deg);
            }
        }

        @keyframes cakeShake {
            0%, 100% {
                transform: rotate(0deg) scale(1);
            }

            25% {
                transform: rotate(-5deg) scale(1.05);
            }

            50% {
                transform: rotate(5deg) scale(1.08);
            }

            75% {
                transform: rotate(-3deg) scale(1.05);
            }
        }

        @keyframes shadowMove {
            0%, 100% {
                transform: scale(1);
                opacity: .45;
            }

            50% {
                transform: scale(.8);
                opacity: .25;
            }
        }

        @keyframes balloonFloat {
            0%, 100% {
                transform: translateY(0) rotate(-2deg);
            }

            50% {
                transform: translateY(-14px) rotate(2deg);
            }
        }
    </style>


    <style id="empBirthday_style">
        .birthday-list-dialog {
            max-width: 600px;
            height: auto;
        }

        .birthday-list-popup {
            border: none;
            border-radius: 25px;
            overflow: hidden;
            box-shadow: 0 30px 70px rgba(255, 20, 147, .28);
        }

        .birthday-list-header {
            border: none;
            padding: 22px 30px;
            background: #FD5486 !important; /*  linear-gradient(135deg,#FEC6D7 0%,#FEA0BC 35%,#FE7AA1 70%,#FD4179 100%) !important;*/
            color: #fff !important;
            position: relative;
        }

            .birthday-list-header::before {
                content: "";
                position: absolute;
                inset: 0;
                background: radial-gradient(circle at 15% 30%, rgba(255,255,255,.35), transparent 18%), radial-gradient(circle at 85% 25%, rgba(255,255,255,.25), transparent 20%);
            }

        .birthday-header-content {
            display: flex;
            align-items: center;
            gap: 18px;
            position: relative;
            z-index: 2;
        }

        .birthday-header-icon {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 34px;
            background: linear-gradient(135deg, #ff0f7b, #ff63b5);
            color: #fff;
            box-shadow: 0 12px 35px rgba(255,20,147,.35);
            animation: rotateCake 2.5s infinite ease-in-out;
        }

        .birthday-list-header h4 {
            margin: 0;
            font-size: 32px;
            font-weight: 700;
        }

        .birthday-list-header small {
            font-size: 16px;
            opacity: .95;
        }

        .birthday-close {
            position: absolute;
            top: 20px;
            right: 20px;
            width: 48px;
            height: 48px;
            border-radius: 50%;
            border: 2px solid #ffc1dd;
            background: #fff;
            color: #e91e63;
            font-size: 34px;
            line-height: 42px;
            box-shadow: 0 8px 20px rgba(255,20,147,.22);
            transition: .3s;
        }

            .birthday-close:hover {
                background: #ff2f7f;
                color: #FD6794;
                transform: rotate(90deg);
                box-shadow: 0 0 20px rgba(255,20,147,.45);
            }

        .birthday-list-body {
            position: relative;
            background: white !important; /* linear-gradient(135deg, #fff0f8 0%, #ffe6f3 45%, #fff8fc 100%);*/
            padding: 30px;
            min-height: 420px;
        }

        .birthday-confetti {
            position: absolute;
            inset: 0;
            pointer-events: none;
            background: white !important;
            background-image: radial-gradient(#ff0f7b 2px, transparent 2px), radial-gradient(#ff4da6 2px, transparent 2px), radial-gradient(#ff8fcf 2px, transparent 2px), radial-gradient(#ffc3df 2px, transparent 2px);
            background-size: 70px 70px, 90px 90px, 110px 110px, 130px 130px;
            opacity: .20;
        }

        .birthday-person {
            position: relative;
            z-index: 5;
            display: flex;
            align-items: center;
            gap: 18px;
            padding: 18px;
            margin-bottom: 18px;
            background: rgba(255,255,255,.92);
            backdrop-filter: blur(8px);
            border: 1px solid rgba(255,105,180,.18);
            border-radius: 18px;
            box-shadow: 0 12px 30px rgba(255,20,147,.10);
            transition: .35s;
            background: #ff0f7b
        }

            .birthday-person:hover {
                transform: translateY(-5px);
                box-shadow: 0 20px 45px rgba(255,20,147,.28), 0 0 18px rgba(255,105,180,.22);
            }

            .birthday-person img {
                width: 75px;
                height: 75px;
                border-radius: 50%;
                object-fit: cover;
                border: 4px solid #ff4da6;
                box-shadow: 0 0 15px rgba(255,20,147,.35);
            }

        .birthday-person-name {
            font-size: 22px;
            font-weight: 700;
            color: #d81b60;
            text-shadow: 0 1px 3px rgba(255,255,255,.8);
        }

        .birthday-person-designation {
            color: #7a4a61;
            font-size: 15px;
        }

        .birthday-person button {
            margin-left: auto;
            border: none;
            padding: 10px 24px;
            border-radius: 30px;
            color: #fff;
            background: linear-gradient(135deg, #ff0f7b, #ff5cab, #ff9ed2);
            box-shadow: 0 10px 25px rgba(255,20,147,.28);
            transition: .3s;
        }

            .birthday-person button:hover {
                transform: scale(1.05);
                box-shadow: 0 14px 30px rgba(255,20,147,.40);
            }

        @keyframes rotateCake {
            0%,100% {
                transform: translateY(0) rotate(0deg);
            }

            25% {
                transform: translateY(-6px) rotate(-6deg);
            }

            50% {
                transform: translateY(0) rotate(0deg);
            }

            75% {
                transform: translateY(-6px) rotate(6deg);
            }
        }
    </style>

    <style>
        .anniv-card {
            position: relative;
            width: 100%;
            /*   width: 70%;*/
            max-width: 1050px;
            /*   min-height: 650px;*/
            margin: 20px auto;
            padding: 45px 40px;
            overflow: hidden;
            border-radius: 28px;
            background: radial-gradient(circle at 50% 45%, rgba(255,255,255,.18), transparent 25%), linear-gradient(135deg, #06245c 0%, #0b55ad 45%, #79c8ff 100%);
            box-shadow: 0 30px 80px rgba(0, 39, 98, .35);
            border: 2px solid rgba(255,255,255,.75);
        }

            .anniv-card::before {
                content: "";
                position: absolute;
                inset: 0;
                background: radial-gradient(circle at 12% 15%, rgba(255,255,255,.35), transparent 3%), radial-gradient(circle at 88% 18%, rgba(255,255,255,.3), transparent 4%), radial-gradient(circle at 22% 78%, rgba(255,255,255,.25), transparent 4%), radial-gradient(circle at 78% 82%, rgba(255,255,255,.25), transparent 4%);
                opacity: .9;
            }

        .anniv-bg-sparkles {
            position: absolute;
            inset: 0;
            background-image: radial-gradient(#fff 1.5px, transparent 1.5px), radial-gradient(#ffd76a 2px, transparent 2px), radial-gradient(#9ddcff 2px, transparent 2px);
            background-size: 48px 48px, 75px 75px, 110px 110px;
            opacity: .45;
            animation: sparkleMove 6s linear infinite;
        }

        .anniv-main-title {
            position: relative;
            z-index: 5;
            text-align: center;
            margin: -21px 0 17px;
            color: #fff4c8;
            font-size: 25px;
            font-weight: 800;
            letter-spacing: 1px;
            font-family: Century Schoolbook;
            text-shadow: 0 5px 18px rgba(0,0,0,.45);
        }

        .anniv-inner-card {
            position: relative;
            z-index: 6;
            margin: 0 auto;
            padding: 60px 45px 45px;
            text-align: center;
            border-radius: 28px;
            background: rgba(255,255,255,.96);
            box-shadow: 0 25px 60px rgba(0, 40, 110, .32), inset 0 0 35px rgba(255,255,255,.7);
        }

        .anniv-top-line {
            position: absolute;
            top: 0;
            left: 50%;
            width: 190px;
            height: 8px;
            transform: translateX(-50%);
            border-radius: 0 0 12px 12px;
            background: linear-gradient(90deg, #83c7ff, #0f56b3);
        }

        .anniv-trophy {
            font-size: 65px;
            line-height: 1;
            margin-bottom: 25px;
            filter: drop-shadow(0 8px 12px rgba(0,0,0,.18));
            animation: trophyMove 2.2s ease-in-out infinite;
        }

        .anniv-name {
            margin: 0;
            color: #092b69;
            font-size: 30px;
            font-weight: 900;
        }

        .anniv-designation {
            border-radius: 12px;
            font-size: 15px;
            font-weight: 600;
            color: #2379d9;
        }

        .anniv-years {
            display: inline-block;
            margin-top: 30px;
            padding: 15px 38px;
            border-radius: 35px;
            color: #fff;
            font-size: 17px;
            font-weight: 800;
            background: linear-gradient(135deg, #2b82da, #003c9b);
            box-shadow: 0 14px 30px rgba(0, 82, 180, .35);
        }

        .anniv-divider {
            width: 190px;
            height: 3px;
            margin: 35px auto 22px;
            border-radius: 10px;
            background: linear-gradient(90deg, transparent, #1f63b5, transparent);
        }

        .anniv-message {
            margin-bottom: -20px;
            color: #0b3f91;
            font-size: 17px;
            font-weight: 800;
            font-style: italic;
            line-height: 1.6;
            font-family: Georgia, serif;
        }

        .balloons {
            position: absolute;
            z-index: 3;
            width: 210px;
            height: 440px;
            bottom: 20px;
            background-repeat: no-repeat;
            background-size: contain;
            opacity: .95;
        }

        .balloons-left {
            left: 15px;
            background: radial-gradient(ellipse at center, #ffffff 0%, #dcecff 45%, #86bff7 100%) 50px 30px / 70px 95px no-repeat, radial-gradient(ellipse at center, #0b65d8 0%, #0047a8 75%) 100px 75px / 75px 100px no-repeat, radial-gradient(ellipse at center, #8fd1ff 0%, #1b77d0 80%) 20px 130px / 80px 105px no-repeat, radial-gradient(ellipse at center, #ffffff 0%, #dbeafe 70%) 110px 190px / 75px 100px no-repeat;
        }

        .balloons-right {
            right: 15px;
            transform: scaleX(-1);
            background: radial-gradient(ellipse at center, #ffffff 0%, #dcecff 45%, #86bff7 100%) 50px 30px / 70px 95px no-repeat, radial-gradient(ellipse at center, #0b65d8 0%, #0047a8 75%) 100px 75px / 75px 100px no-repeat, radial-gradient(ellipse at center, #8fd1ff 0%, #1b77d0 80%) 20px 130px / 80px 105px no-repeat, radial-gradient(ellipse at center, #ffffff 0%, #dbeafe 70%) 110px 190px / 75px 100px no-repeat;
        }

        @keyframes trophyMove {
            0%, 100% {
                transform: translateY(0) rotate(0deg);
            }

            25% {
                transform: translateY(-8px) rotate(-5deg);
            }

            50% {
                transform: translateY(0) rotate(0deg);
            }

            75% {
                transform: translateY(-8px) rotate(5deg);
            }
        }

        @keyframes sparkleMove {
            from {
                background-position: 0 0, 0 0, 0 0;
            }

            to {
                background-position: 80px 80px, -80px 80px, 100px -100px;
            }
        }

        @media (max-width: 768px) {
            .anniv-card {
                padding: 30px 15px;
                min-height: auto;
            }

            .anniv-main-title {
                font-size: 28px;
            }

            .anniv-inner-card {
                width: 92%;
                min-width: unset;
                padding: 45px 22px 35px;
            }

            .balloons {
                opacity: .25;
            }
        }

        .anniversary-dialog {
            width: min(940px, calc(100% - 32px));
            max-width: 940px;
            margin: 18px auto;
        }

        .workanniversary-modal {
            position: relative;
            overflow: hidden;
            border: 0;
            border-radius: 22px;
            background: #f5f6f8;
            box-shadow: 0 28px 75px rgba(15, 29, 74, .28);
        }

        .anniv-close {
            position: absolute;
            z-index: 20;
            top: 14px;
            right: 16px;
            display: grid;
            width: 38px;
            height: 38px;
            padding: 0;
            place-items: center;
            border: 1px solid rgba(23, 39, 92, .12);
            border-radius: 50%;
            color: #17275c;
            background: rgba(255, 255, 255, .94);
            font-size: 25px;
            line-height: 1;
            cursor: pointer;
            box-shadow: 0 5px 16px rgba(23, 39, 92, .12);
        }

        .anniv-close:hover,
        .anniv-close:focus {
            color: #fff;
            background: #17275c;
            outline: 0;
        }

        .anniv-modal-body {
            padding: 50px 58px 14px;
            overflow: hidden;
        }

        .anniv-carousel {
            position: relative;
            padding-bottom: 78px;
        }

        .anniv-carousel .carousel-inner {
            overflow: visible;
        }

        .anniv-carousel .carousel-item {
            transition: transform .65s cubic-bezier(.22, .61, .36, 1), opacity .45s ease;
        }

        .anniv-carousel-nav {
            position: absolute;
            z-index: 12;
            inset: 0;
            display: flex;
            align-items: center;
            justify-content: space-between;
            pointer-events: none;
        }

        .anniv-carousel-arrow {
            display: grid;
            width: 34px;
            height: 34px;
            padding: 0 0 3px;
            place-items: center;
            border: 1px solid #d8deeb;
            border-radius: 50%;
            color: #17265e;
            background: #fff;
            font-family: Arial, sans-serif;
            font-size: 28px;
            line-height: 1;
            cursor: pointer;
            box-shadow: 0 6px 16px rgba(23, 38, 94, .12);
            transition: transform .2s ease, color .2s ease, background .2s ease;
            pointer-events: auto;
        }

        .anniv-carousel-arrow:hover,
        .anniv-carousel-arrow:focus {
            color: #fff;
            background: #17265e;
            outline: 0;
            transform: translateY(-2px);
        }

        .anniv-carousel-progress {
            position: absolute;
            right: 0;
            bottom: 0;
            left: 0;
            display: flex;
            min-width: 150px;
            align-items: center;
            flex-direction: column;
            justify-content: center;
            gap: 5px;
            pointer-events: auto;
        }

        .anniv-carousel-indicators {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
        }

        .anniv-carousel-dot {
            width: 8px;
            height: 8px;
            padding: 0;
            border: 0;
            border-radius: 50%;
            background: #c7cddd;
            cursor: pointer;
            transition: width .25s ease, border-radius .25s ease, background .25s ease;
        }

        .anniv-carousel-dot.active {
            width: 24px;
            border-radius: 10px;
            background: #d5a91f;
        }

        .anniv-carousel-dot:focus {
            outline: 2px solid rgba(23, 38, 94, .28);
            outline-offset: 2px;
        }

        .anniv-carousel-position {
            color: #70798f;
            font-size: 9px;
            font-weight: 800;
            letter-spacing: 1.1px;
        }

        .anniv-profile {
            position: relative;
            display: grid;
            grid-template-columns: 246px minmax(0, 1fr);
            width: 100%;
            max-width: 760px;
            min-height: 360px;
            margin: 0 auto;
            overflow: visible;
            border: 0;
            background: #fff;
            box-shadow: none;
        }

        .anniv-profile-left {
            position: relative;
            display: flex;
            align-items: center;
            flex-direction: column;
            justify-content: flex-start;
            overflow: visible;
            padding: 76px 20px 18px;
            color: #fff;
            text-align: center;
            background: #202b69;
        }

        .anniv-profile-left::before,
        .anniv-profile-left::after { display: none; }

        .anniv-panel-orb {
            position: absolute;
            z-index: 0;
            display: block;
            border-radius: 50%;
            background: #111944;
        }

        .anniv-panel-orb-top { top: -33px; left: -28px; width: 106px; height: 106px; }
        .anniv-panel-orb-bottom { bottom: -67px; left: -52px; width: 96px; height: 96px; }
        .anniv-panel-orb-corner { right: 10px; bottom: -34px; width: 58px; height: 58px; }

        .anniv-brand {
            position: absolute;
            z-index: 2;
            top: 26px;
            left: 50%;
            transform: translateX(-50%);
            font-size: 8px;
            font-weight: 800;
            letter-spacing: 2.5px;
            opacity: .9;
            white-space: nowrap;
        }

        .anniv-ribbon {
            position: absolute;
            z-index: 4;
            top: 13px;
            left: -22px;
            width: 140px;
            padding: 7px 4px;
            transform: rotate(-40deg);
            color: #fff;
            background: #ff5c68;
            font-size: 7px;
            font-weight: 900;
            letter-spacing: 1.2px;
            box-shadow: 0 6px 14px rgba(0, 0, 0, .18);
        }

        .anniv-avatar {
            position: relative;
            z-index: 2;
            display: grid;
            width: 132px;
            height: 132px;
            margin: 0 0 12px;
            place-content: center;
            border: 3px solid #f0c83d;
            border-radius: 50%;
            background: #111944;
            box-shadow: 0 0 0 2px rgba(255, 255, 255, .22), 0 12px 24px rgba(0, 0, 0, .2);
        }

        .anniv-camera {
            display: block;
            width: 35px;
            height: 35px;
            margin: 0 auto;
        }

        .anniv-camera svg {
            width: 100%;
            height: 100%;
            overflow: visible;
            fill: none;
            stroke: #dbe3ff;
            stroke-width: 2.7;
            stroke-linecap: round;
            stroke-linejoin: round;
        }

        .anniv-avatar small {
            display: block;
            margin-top: 13px;
            color: #fff;
            font-size: 6px;
            font-weight: 800;
            letter-spacing: .35px;
        }

        .anniv-profile-left h3 {
            position: relative;
            z-index: 2;
            max-width: 100%;
            margin: 0 0 4px;
            font-family: Georgia, "Times New Roman", serif;
            font-size: 14px;
            font-weight: 700;
            line-height: 1.2;
            white-space: nowrap;
        }

        .anniv-profile-left p {
            position: relative;
            z-index: 2;
            min-height: 15px;
            margin: 0;
            color: #dbe2ff;
            font-size: 8px;
            line-height: 1.35;
        }

        .anniv-profile-left p b { padding: 0 3px; color: #f0c83d; }

        .anniv-service-badge {
            position: relative;
            z-index: 2;
            display: flex;
            width: 64px;
            height: 64px;
            margin-top: 16px;
            align-items: center;
            flex-direction: column;
            justify-content: center;
            border: 0;
            border-radius: 50%;
            color: #162256;
            background: #e2b735;
            box-shadow: 0 0 0 4px #202b69;
        }

        .anniv-service-badge::before {
            content: "";
            position: absolute;
            inset: -7px;
            border: 1px dashed #e2b735;
            border-radius: 50%;
        }

        .anniv-service-badge strong { font-size: 10px; line-height: 1.1; }
        .anniv-service-badge span { margin-top: 2px; font-size: 6px; font-weight: 900; letter-spacing: 1px; }
        .anniv-service-badge .anniv-trophy-mark { margin: 0 0 3px; font-size: 15px; line-height: 1; letter-spacing: 0; }

        .anniv-balloons {
            position: absolute;
            z-index: 3;
            right: 35px;
            bottom: 54px;
            width: 30px;
            height: 46px;
        }

        .anniv-balloons i {
            position: absolute;
            top: 0;
            width: 11px;
            height: 16px;
            border-radius: 50% 50% 48% 48%;
            background: #e2b735;
            transform: rotate(-12deg);
        }

        .anniv-balloons i:first-child { left: 2px; }
        .anniv-balloons i:last-child { top: 7px; right: 2px; transform: rotate(13deg); }
        .anniv-balloons i::after { content: ""; position: absolute; top: 15px; left: 5px; width: 1px; height: 24px; background: #e2b735; transform: rotate(-13deg); transform-origin: top; }

        .anniv-confetti {
            position: absolute;
            z-index: 1;
            width: 7px;
            height: 7px;
            border-radius: 50%;
            background: #f2c943;
            box-shadow: 46px 33px 0 #ff6670, 90px -18px 0 #60c4da, 132px 40px 0 #fff, 23px 120px 0 #50acbe, 155px 155px 0 #f2c943, 72px 195px 0 #ff6670;
        }

        .anniv-confetti-one { top: 75px; left: 38px; }
        .anniv-confetti-two { right: 42px; bottom: 75px; transform: rotate(55deg); }

        .anniv-profile-right {
            position: relative;
            padding: 29px 36px 24px;
            color: #243052;
            background: radial-gradient(circle at 90% 9%, rgba(242, 201, 67, .18) 0 3px, transparent 4px), radial-gradient(circle at 83% 19%, rgba(51, 142, 177, .28) 0 2px, transparent 3px), #fff;
        }

        .anniv-kicker {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            color: #bc9213;
            background: #fbf2d4;
            font-size: 8px;
            font-weight: 900;
            letter-spacing: 1.5px;
        }

        .anniv-profile-right h2 {
            margin: 10px 0 9px;
            color: #17265e;
            font-family: Georgia, "Times New Roman", serif;
            font-size: 24px;
            font-weight: 800;
            line-height: 1.06;
        }

        .anniv-profile-right h2 em {
            color: #d5a91f;
            font-style: normal;
        }

        .anniv-intro {
            max-width: 610px;
            margin-bottom: 15px;
            color: #526078;
            font-size: 11px;
            line-height: 1.5;
        }

        .anniv-details {
            display: grid;
            grid-template-columns: 1fr;
            gap: 8px;
        }

        .anniv-details > div {
            display: flex;
            min-width: 0;
            align-items: center;
            gap: 10px;
        }

        .anniv-details i {
            display: grid;
            width: 27px;
            height: 27px;
            flex: 0 0 27px;
            place-items: center;
            border-radius: 50%;
            color: #c79d1f;
            background: #fbf2d4;
            font-size: 12px;
            font-style: normal;
        }

        .anniv-details span { min-width: 0; }

        .anniv-details small {
            display: block;
            margin-bottom: 2px;
            color: #7b8296;
            font-size: 7px;
            font-weight: 900;
            letter-spacing: 1.2px;
        }

        .anniv-details strong {
            display: block;
            overflow: hidden;
            color: #1f2a50;
            font-size: 11px;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .anniv-thanks {
            display: flex;
            margin-top: 12px;
            padding: 10px 13px;
            align-items: flex-start;
            gap: 10px;
            border-radius: 8px;
            color: #606779;
            background: #f7f4ed;
            font-family: Georgia, "Times New Roman", serif;
            font-size: 11px;
            font-style: italic;
            line-height: 1.5;
            font-weight:bold;
            /*padding-top:20px;*/
            
        }

        .anniv-thanks:first-letter { color: #d5a91f; }

        @media (max-width: 767px) {
            .anniversary-dialog { width: calc(100% - 18px); margin: 9px auto; }
            .anniv-modal-body { padding: 46px 28px 12px; }
            .anniv-carousel { padding-bottom: 74px; }
            .anniv-profile { grid-template-columns: 1fr; }
            .anniv-profile-left { min-height: 395px; padding: 58px 22px 28px; }
            .anniv-profile-right { padding: 32px 24px 28px; }
            .anniv-profile-right h2 { font-size: 28px; }
            .anniv-details { grid-template-columns: 1fr; }
            .anniv-details strong { white-space: normal; }
        }
    </style>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.x.x/css/all.min.css">
</asp:Content>
