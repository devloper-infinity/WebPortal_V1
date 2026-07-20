<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="DashboardTest.aspx.cs" Inherits="WebPortal.Admin.DashboardTest" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/intro.js/minified/introjs.min.css" rel="stylesheet">

    <script src="https://cdn.jsdelivr.net/npm/intro.js/minified/intro.min.js"></script>
    <script src="../plugins/chart.js/Chart.bundle.min.js"></script>
    <portal:VersionedScript Src="~/Scripts/Functions/DashboardTest.js" runat="server"></portal:VersionedScript>
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
                global: false,
                success: function (data) {
                    var payload = {};

                    try {
                        payload = JSON.parse(data.d || "{}");
                    }
                    catch (ex) {
                        payload = {};
                    }

                    var productionRows = dashLastTwelveRows(dashSortProductionRows(payload.production || []));
                    var attendanceRows = dashLastTwelveRows(dashSortAttendanceRows(payload.attendance || []));
                    var hasVisibleRows = dashIsTaskBasedEmployee() ? attendanceRows.length > 0 : (productionRows.length > 0 || attendanceRows.length > 0);

                    if (!hasVisibleRows) {
                        dashApplyProductiveEmployeeMode();
                        dashUpdateProductivePeriod(productionRows, attendanceRows);
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
                    dashUpdateProductivePeriod(productionRows, attendanceRows);
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

        function dashLastTwelveRows(rows) {
            if (!rows || rows.length <= 12) {
                return rows || [];
            }

            return rows.slice(rows.length - 12);
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

        function dashUpdateProductivePeriod(productionRows, attendanceRows) {
            var labels = [];
            var firstLabel = "";
            var lastLabel = "";

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

            $("#dashboard_productive_period").text(labels.length > 1 ? labels.join(" to ") : (labels[0] || "Last 12 months"));
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

                $(".productive-section-subtitle").html(
                    'Attendance view for <span id="dashboard_productive_period">Last 12 months</span>'
                );

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

                $(".productive-section-subtitle").html(
                    'Production and attendance view for <span id="dashboard_productive_period">Last 12 months</span>'
                );

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
    <style id="dashboard-test-modern">
        body.dashboard-test-body {
            background: #f5f7fb;
        }

        .dashboard-test-shell {
            padding: 16px 18px 24px;
        }

        .dashboard-test-shell .dashboard-row {
            align-items: stretch;
            margin-left: -8px;
            margin-right: -8px;
        }

        .dashboard-test-shell .dashboard-row > [class*="col-"] {
            padding-left: 8px;
            padding-right: 8px;
        }

        .dashboard-test-shell .dashboard-profile-card,
        .dashboard-test-shell .dashboard-table-card,
        .dashboard-test-shell .productive-kpi-card,
        .dashboard-test-shell .hr-dashboard-highlight,
        .dashboard-test-shell .info-box {
            border: 1px solid #dfe7f3 !important;
            border-radius: 8px !important;
            box-shadow: 0 10px 24px rgba(31, 45, 61, 0.08) !important;
            overflow: hidden;
        }

        .dashboard-test-shell .dashboard-profile-card {
            height: 270px !important;
            background: #ffffff;
        }

        .dashboard-test-shell .dashboard-profile-card .widget-user-header {
            background: linear-gradient(135deg, #2563eb 0%, #0f766e 100%) !important;
            min-height: 122px;
            padding: 24px 18px 36px;
        }

        .dashboard-test-shell .widget-user-username {
            color: #ffffff;
            font-size: 22px;
            letter-spacing: 0;
            text-decoration: none !important;
        }

        .dashboard-test-shell .widget-user-desc {
            color: rgba(255, 255, 255, 0.82);
            font-weight: 500;
        }

        .dashboard-test-shell .widget-user-image > img {
            background: #ffffff;
            border: 4px solid #ffffff;
            height: 94px;
            object-fit: cover;
            width: 94px;
        }

        .dashboard-test-shell .description-block i {
            align-items: center;
            background: #eef6ff;
            border-radius: 8px;
            display: inline-flex;
            height: 42px;
            justify-content: center;
            width: 42px;
        }

        .dashboard-test-shell .description-text a {
            color: #243b53 !important;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 0;
            text-decoration: none !important;
        }

        .dashboard-test-shell .info-box {
            align-items: center;
            border-left-width: 5px !important;
            color: #172033;
            min-height: 78px;
            padding: 10px 12px;
        }

        .dashboard-test-shell .info-box .info-box-icon {
            background: rgba(255, 255, 255, 0.7) !important;
            border-radius: 8px;
            color: inherit !important;
            font-size: 22px;
            height: 48px;
            line-height: 48px;
            margin-right: 10px;
            width: 48px;
        }

        .dashboard-test-shell .info-box .info-box-content {
            min-width: 0;
            padding: 0;
        }

        .dashboard-test-shell .info-box .info-box-number {
            color: #172033;
            display: block;
            font-size: 13px;
            font-weight: 800;
            line-height: 1.25;
            white-space: normal;
        }

        .dashboard-test-shell .box-productivity { background: #eaf5ff !important; border-left-color: #2563eb !important; }
        .dashboard-test-shell .box-salary { background: #fff7e6 !important; border-left-color: #b7791f !important; }
        .dashboard-test-shell .box-birthday { background: #fff0f6 !important; border-left-color: #be185d !important; }
        .dashboard-test-shell .box-leaves { background: #ecfdf3 !important; border-left-color: #15803d !important; }
        .dashboard-test-shell .box-attendance { background: #f0f7ff !important; border-left-color: #0f766e !important; }
        .dashboard-test-shell .box-holidays { background: #f6f3ff !important; border-left-color: #6d28d9 !important; }

        .dashboard-test-shell .dashboard-card-header {
            align-items: center;
            background: #ffffff !important;
            border-bottom: 1px solid #e5edf7;
            display: flex;
            min-height: 46px;
        }

        .dashboard-test-shell .dashboard-card-title {
            color: #1f2a44;
            font-size: 15px;
            font-weight: 800;
            letter-spacing: 0;
        }

        .dashboard-test-shell .dashboard-table th {
            background: #f2f6fb;
            color: #526176;
            font-size: 11px !important;
            letter-spacing: 0;
            text-transform: uppercase;
        }

        .dashboard-test-shell .dashboard-table td {
            color: #25364d;
            font-size: 12px !important;
            vertical-align: middle !important;
        }

        .dashboard-test-shell .productive-section-heading {
            background: #ffffff;
            border: 1px solid #dfe7f3;
            border-radius: 8px;
            box-shadow: 0 8px 20px rgba(31, 45, 61, 0.06);
            padding: 13px 16px;
        }

        .dashboard-test-shell .productive-kpi-card {
            min-height: 96px;
            padding: 14px 15px;
        }

        .dashboard-test-shell .productive-kpi-card:nth-child(odd),
        .dashboard-test-shell .productive-kpi-card:nth-child(even) {
            background: #ffffff;
        }

        .dashboard-test-shell .productive-kpi-value {
            color: #172033;
            font-size: 24px;
        }

        #birthdayModal .modal-dialog,
        #dash_birthdayModal_all .modal-dialog,
        #dash_anniversaryModal .modal-dialog {
            max-width: min(760px, calc(100vw - 28px));
        }

        #birthdayModal .birthday-popup,
        #dash_birthdayModal_all .modal-content,
        #dash_anniversaryModal .anniversary-modal {
            background: #ffffff;
            border: 0;
            border-radius: 8px;
            box-shadow: 0 26px 70px rgba(15, 23, 42, 0.24);
            overflow: hidden;
        }

        #birthdayModal .birthday-popup .modal-body {
            background: linear-gradient(135deg, #fff7ed 0%, #fff1f2 45%, #eef6ff 100%);
            min-height: 260px;
            padding: 42px 32px 34px;
        }

        #birthdayModal .birthday-popup .modal-body:before {
            background: rgba(255, 255, 255, 0.72);
            border: 1px solid rgba(255, 255, 255, 0.9);
            border-radius: 8px;
            color: #be185d;
            content: "\f1fd";
            display: inline-flex;
            font-family: "Font Awesome 5 Free";
            font-size: 34px;
            font-weight: 900;
            height: 72px;
            align-items: center;
            justify-content: center;
            margin-bottom: 16px;
            width: 72px;
        }

        #birthdayModal .birthday-popup h2,
        #birthdayModal .birthday-popup h4 {
            color: #7f1d1d;
            font-weight: 900;
            letter-spacing: 0;
        }

        #birthdayModal .birthday-popup p {
            color: #854d0e;
            font-size: 15px;
            font-weight: 600;
        }

        #dash_birthdayModal_all .modal-header,
        #dash_anniversaryModal .modal-header {
            background: linear-gradient(135deg, #7c2d12 0%, #be185d 52%, #2563eb 100%);
            border: 0;
            color: #ffffff;
            min-height: 64px;
            padding: 18px 22px;
        }

        #dash_birthdayModal_all .modal-header h5,
        #dash_anniversaryModal .modal-header h4 {
            color: #ffffff;
            font-weight: 900;
            letter-spacing: 0;
            margin: 0;
        }

        #dash_birthdayModal_all .modal-body,
        #dash_anniversaryModal .modal-body {
            background: #fffaf7;
            max-height: 72vh;
            overflow-y: auto;
            padding: 20px;
        }

        .dashboard-test-birthday-card,
        #dash_birthdayList .birthday-card {
            background: #ffffff !important;
            border: 1px solid #f3d7df;
            border-left: 5px solid #be185d;
            border-radius: 8px !important;
            box-shadow: 0 12px 24px rgba(190, 24, 93, 0.08) !important;
            padding: 14px !important;
        }

        .dashboard-test-birthday-avatar,
        #dash_birthdayList .cake-avatar {
            background: #fff1f2 !important;
            border: 1px solid #fecdd3;
            border-radius: 8px !important;
            color: #be185d;
            display: inline-flex;
            font-weight: 900;
            height: 52px;
            justify-content: center;
            width: 52px;
        }

        .dashboard-test-birthday-meta,
        #dash_birthdayList .emp-meta {
            color: #64748b;
            font-size: 12px;
            line-height: 1.35;
        }

        .dashboard-test-wish-btn,
        #dash_birthdayList .btn-wish {
            background: #be185d !important;
            border: 0 !important;
            border-radius: 8px !important;
            color: #ffffff !important;
            font-weight: 800;
            min-width: 86px;
        }

        #dash_birthdayList .wish-box {
            background: #fff7ed;
            border: 1px dashed #fdba74;
            border-radius: 8px;
        }

        #dash_anniversaryContainer {
            justify-content: center;
        }

        #dash_anniversaryContainer .employees-card {
            background: linear-gradient(180deg, #ffffff 0%, #fff7ed 100%) !important;
            border: 1px solid #fed7aa;
            border-top: 5px solid #b7791f;
            border-radius: 8px !important;
            box-shadow: 0 14px 30px rgba(180, 83, 9, 0.12) !important;
            flex: 1 1 240px;
            margin: 10px;
            max-width: 310px;
            min-height: 250px;
            padding: 22px 18px !important;
        }

        #dash_anniversaryContainer .company-logo {
            background: #fffbeb;
            border: 1px solid #fde68a;
            border-radius: 8px;
            color: #b45309;
            display: inline-flex;
            font-size: 28px;
            height: 58px;
            align-items: center;
            justify-content: center;
            margin: 0 auto 12px;
            width: 58px;
        }

        #dash_anniversaryContainer .emps-name {
            color: #1f2937;
            font-size: 18px;
            font-weight: 900;
            letter-spacing: 0;
            line-height: 1.25;
        }

        #dash_anniversaryContainer .emp-designation {
            color: #64748b;
            font-size: 13px;
            margin-top: 4px;
        }

        #dash_anniversaryContainer .emp-years {
            background: #fff7ed;
            border-radius: 8px;
            color: #9a3412;
            display: inline-block;
            font-weight: 900;
            margin-top: 12px;
            padding: 7px 12px;
        }

        #dash_anniversaryContainer .anniversary-msg {
            color: #475569;
            font-size: 13px;
            line-height: 1.45;
            margin-top: 12px;
        }

        .modal .close {
            color: inherit;
            opacity: 0.86;
            text-shadow: none;
        }

        @media (max-width: 767px) {
            .dashboard-test-shell {
                padding: 10px;
            }

            .dashboard-test-shell .dashboard-profile-card {
                height: auto !important;
                min-height: 270px;
            }

            #dash_birthdayModal_all .modal-body,
            #dash_anniversaryModal .modal-body {
                padding: 14px;
            }
        }
    </style>
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input type="hidden" id="hdnUserId" value="<%= HttpContext.Current.User.Identity.Name.ToString() %>" />
    <input type="hidden" id="hdnLoginTime" value="<%= Session["LoginTime"] %>" />

    <div class="dashboard-main-page dashboard-test-shell">
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

    <% if (HttpContext.Current.User.Identity.Name.ToString() == "7036") { %>
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

    <% if (HttpContext.Current.User.Identity.Name.ToString() == "12") { %>
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
                            <span class="productive-section-subtitle">Production and attendance view for <span id="dashboard_productive_period">Last 12 months</span></span>
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
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content birthday-popup">
                <div class="modal-body text-center position-relative">
                    <!-- Close button -->
                    <%-- <button class="btn-close-birthday" data-bs-dismiss="modal">✖</button>--%><%-- onclick="return insertselfbirthdayreminder();"--%>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h2>🎉 Happy Birthday!</h2>

                    <h4 id="lblBirthdayName"></h4>

                    <p>Wishing you a wonderful year ahead!</p>
                </div>
            </div>
        </div>
    </div>


    <!-------------- Work Annivesary ------------->
    <div class="modal fade" id="dash_anniversaryModal">
        <%--<div class="modal-dialog modal-dialog-centered">
        <div class="modal-dialog modal-dialog-centered modal-l">--%>
        <div class="modal-dialog modal-dialog-centered custom-modal-width">
            <div class="modal-content anniversary-modal">

                <div class="modal-header text-center" style="font-family: Britannic Bold;">
                    <h4 class="modal-title w-100">
                        <span id="workAnn_header"></span>
                    </h4>

                    <!-- ✅ Bootstrap 5 close button -->
                    <%-- <button type="button" class="btn-close" data-bs-dismiss="modal"></button>--%>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>

                </div>

                <div class="modal-body">
                    <div id="dash_anniversaryContainer" class="row text-center">
                    </div>
                </div>

            </div>
        </div>
    </div>


    <!-------------- Employee's Birthday ------------->
    <div class="modal fade" id="dash_birthdayModal_all">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5>🎉 Today's Birthdays</h5>
                    <%--<button type="button" class="close"><span>&times;</span></button>--%><%-- onclick="location.reload();"--%>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>

                </div>
                <div class="modal-body" id="dash_birthdayList"></div>
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
    <portal:VersionedScript Src="~/Scripts/Functions/DashboardTest.js" runat="server"></portal:VersionedScript>
</asp:Content>
