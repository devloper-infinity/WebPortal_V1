<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ProjectHealthReport.aspx.cs" Inherits="WebPortal.Admin.ProjectHealthReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body {
            background: #f3f6f8;
        }

        .health-page {
            color: #172737;
            padding-bottom: 28px;
        }

        .health-hero {
            align-items: center;
            background: linear-gradient(135deg, #0f766e 0%, #1d4ed8 100%);
            border-radius: 8px;
            box-shadow: 0 14px 28px rgba(28, 58, 85, 0.16);
            color: #fff;
            display: flex;
            gap: 20px;
            justify-content: space-between;
            margin-bottom: 18px;
            padding: 22px 24px;
        }

        .health-kicker {
            color: rgba(255,255,255,0.82);
            font-size: 12px;
            font-weight: 700;
            margin-bottom: 6px;
            text-transform: uppercase;
        }

        .health-title {
            font-size: 24px;
            font-weight: 700;
            line-height: 1.2;
            margin: 0;
        }

        .health-subtitle {
            color: rgba(255,255,255,0.88);
            font-size: 13px;
            margin: 8px 0 0;
            max-width: 760px;
        }

        .health-panel {
            background: #fff;
            border: 1px solid #dce5ec;
            border-radius: 8px;
            box-shadow: 0 10px 24px rgba(31, 51, 71, 0.06);
            margin-bottom: 18px;
            overflow: hidden;
        }

        .health-panel-header {
            align-items: center;
            border-bottom: 1px solid #e7edf2;
            display: flex;
            gap: 14px;
            justify-content: space-between;
            padding: 16px 18px;
        }

        .health-panel-title {
            align-items: center;
            color: #172737;
            display: flex;
            font-size: 16px;
            font-weight: 700;
            gap: 9px;
            margin: 0;
        }

        .health-panel-subtitle {
            color: #6d7f90;
            font-size: 12px;
            margin: 4px 0 0;
        }

        .health-panel-body {
            padding: 18px;
        }

        .health-form-grid {
            display: grid;
            gap: 14px 16px;
            grid-template-columns: repeat(6, minmax(0, 1fr));
        }

        .health-field {
            min-width: 0;
        }

        .health-field label {
            color: #46596b;
            display: block;
            font-size: 12px;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .health-field .form-control {
            border: 1px solid #cfdbe5;
            border-radius: 6px;
            box-shadow: none;
            color: #172737;
            font-size: 13px;
            min-height: 38px;
            width: 100%;
        }

        .health-field .form-control:focus {
            border-color: #0f766e;
            box-shadow: 0 0 0 3px rgba(15, 118, 110, 0.14);
            outline: none;
        }

        .health-action-row {
            align-items: center;
            border-top: 1px solid #e7edf2;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 18px;
            padding-top: 16px;
        }

        .health-btn {
            align-items: center;
            border-radius: 6px;
            display: inline-flex;
            font-size: 13px;
            font-weight: 700;
            gap: 8px;
            justify-content: center;
            min-height: 38px;
            padding: 8px 14px;
        }

        .health-btn-primary {
            background: #0f766e;
            border: 1px solid #0f766e;
            color: #fff;
        }

        .health-btn-primary:hover,
        .health-btn-primary:focus {
            background: #0b5f59;
            border-color: #0b5f59;
            color: #fff;
        }

        .health-btn-outline {
            background: #fff;
            border: 1px solid #cbd6df;
            color: #263747;
        }

        .health-stat-grid {
            display: grid;
            gap: 12px;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            margin-bottom: 18px;
        }

        .health-stat {
            background: #fff;
            border: 1px solid #dce5ec;
            border-left: 4px solid #0f766e;
            border-radius: 8px;
            box-shadow: 0 8px 18px rgba(31, 51, 71, 0.06);
            padding: 14px 16px;
        }

        .health-stat span {
            color: #667789;
            display: block;
            font-size: 12px;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .health-stat strong {
            color: #172737;
            display: block;
            font-size: 22px;
            line-height: 1;
        }

        .health-table-wrap {
            overflow-x: auto;
            padding: 0 18px 18px;
        }

        #table_projectHealthReport {
            border-collapse: separate !important;
            border-spacing: 0;
            margin-top: 0 !important;
            width: 100% !important;
        }

        #table_projectHealthReport thead th {
            background: linear-gradient(135deg, #0f766e 0%, #1d4ed8 100%) !important;
            border-color: rgba(255,255,255,0.28) !important;
            color: #fff;
            font-size: 12px;
            font-weight: 700;
            text-align: center;
            vertical-align: middle;
            white-space: nowrap;
        }

        #table_projectHealthReport tbody td {
            background: #fff;
            border-color: #e2e9ef !important;
            color: #263747;
            font-size: 12px;
            vertical-align: middle;
        }

        #table_projectHealthReport tbody tr:hover td {
            background: #f7fbfa;
        }

        .dataTables_wrapper .dataTables_info,
        .dataTables_wrapper .dataTables_paginate {
            color: #5c6f82;
            font-size: 12px;
            padding: 12px 0 0;
        }

        div.dt-buttons {
            float: left;
            padding: 0 0 8px;
            position: static;
        }

        .buttons-excel {
            background: #0f766e !important;
            border: 0 !important;
            border-radius: 6px !important;
            box-shadow: none !important;
            color: #fff !important;
            font-weight: 700 !important;
            margin: 0 10px 0 0 !important;
        }

        .loading {
            align-items: center;
            background: rgba(255,255,255,0.92);
            border: 1px solid #dce5ec;
            border-radius: 8px;
            box-shadow: 0 18px 40px rgba(20, 33, 45, 0.18);
            color: #263747;
            display: none;
            font-size: 12px;
            font-weight: 700;
            left: 50%;
            min-width: 220px;
            padding: 18px;
            position: fixed;
            text-align: center;
            top: 42%;
            transform: translate(-50%, -50%);
            z-index: 99999;
        }

        .loading img {
            display: block;
            margin: 0 auto 10px;
            max-width: 44px;
        }

        @media (max-width: 1199px) {
            .health-form-grid {
                grid-template-columns: repeat(3, minmax(0, 1fr));
            }

            .health-stat-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 767px) {
            .health-hero,
            .health-action-row {
                align-items: stretch;
                flex-direction: column;
            }

            .health-form-grid,
            .health-stat-grid {
                grid-template-columns: 1fr;
            }

            .health-btn {
                width: 100%;
            }
        }
    </style>

    <script>
        var projectHealthTable;

        $(document).ready(function () {
            projectHealth_Init();
        });

        function projectHealth_Init() {
            projectHealth_FillYears();
            projectHealth_SetDefaultMonths();
            projectHealth_BindDomains();

            $("#projectHealth_Domain").on("change", function () {
                projectHealth_BindProjects($(this).val());
            });

            $("#projectHealth_Clear").on("click", function () {
                projectHealth_SetDefaultMonths();
                $("#projectHealth_Domain").val("0");
                projectHealth_BindProjects("0");
                projectHealth_RenderTable([]);
                projectHealth_UpdateStats([]);
                return false;
            });

            $("#projectHealth_GetReport").on("click", function () {
                return projectHealth_GetReport();
            });

            projectHealth_RenderTable([]);
        }

        function projectHealth_FillYears() {
            var currentYear = new Date().getFullYear();
            var startYear = currentYear - 5;
            var options = "";

            for (var year = startYear; year <= currentYear; year++) {
                options += '<option value="' + year + '">' + year + '</option>';
            }

            $("#projectHealth_FromYear, #projectHealth_ToYear").html(options).val(currentYear.toString());
        }

        function projectHealth_SetDefaultMonths() {
            var monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
            var month = monthNames[new Date().getMonth()];
            $("#projectHealth_FromMonth, #projectHealth_ToMonth").val(month);
            $("#projectHealth_FromYear, #projectHealth_ToYear").val(new Date().getFullYear().toString());
        }

        function projectHealth_BindDomains() {
            $.ajax({
                type: "POST",
                url: "ProjectHealthReport.aspx/GetDomainGroups",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (res) {
                    var dataArray = JSON.parse(res.d);
                    var select = $("#projectHealth_Domain");
                    select.empty();
                    select.append($("<option></option>").val("0").html("Select"));
                    if (dataArray.ShowAllDomains) {
                        select.append($("<option></option>").val("99").html("All Domains"));
                    }
                    //select.append($("<option></option>").val("99").html("All Domains"));

                    $.each(dataArray.Domains, function (index, value) {
                        select.append($("<option></option>").val(value.DomainGroupId).html(value.DomainGroupName));
                    });

                    projectHealth_BindProjects("0");
                }
            });
        }

        function projectHealth_BindProjects(domainId) {
            var select = $("#projectHealth_Project");
            select.empty();
            select.append($("<option></option>").val("0").html("Select"));

            if (domainId === "0" || domainId === "") {
                return;
            }

            $.ajax({
                type: "POST",
                url: "ProjectHealthReport.aspx/GetProjects",
                data: JSON.stringify({ DomainGroup: parseInt(domainId, 10) }),
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (res) {
                    var dataArray = JSON.parse(res.d);
                    select.empty();
                    select.append($("<option></option>").val("0").html("Select"));
                    select.append($("<option></option>").val("-1").html("All Projects"));

                    $.each(dataArray, function (index, value) {
                        select.append($("<option></option>").val(value.ProjectID).html(value.ProjectName));
                    });
                }
            });
        }

        function projectHealth_GetReport() {
            var filters = {
                FromMonth: $("#projectHealth_FromMonth").val(),
                FromYear: $("#projectHealth_FromYear").val(),
                ToMonth: $("#projectHealth_ToMonth").val(),
                ToYear: $("#projectHealth_ToYear").val(),
                DomainGroup: parseInt($("#projectHealth_Domain").val(), 10) || 0,
                ProjectID: parseInt($("#projectHealth_Project").val(), 10) || 0
            };

            if (!filters.FromMonth || !filters.ToMonth || filters.DomainGroup === 0 || filters.ProjectID === 0) {
                alert("Please select month range, domain, and project.");
                return false;
            }

            $("#projectHealth_load").show();

            $.ajax({
                type: "POST",
                url: "ProjectHealthReport.aspx/GetReport",
                data: JSON.stringify(filters),
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (res) {
                    var dataArray = JSON.parse(res.d);
                    projectHealth_RenderTable(dataArray);
                    projectHealth_UpdateStats(dataArray);
                    $("#projectHealth_load").hide();
                },
                error: function (xhr) {
                    $("#projectHealth_load").hide();
                    alert("Unable to load project health report.");
                    console.log(xhr.responseText);
                }
            });

            return false;
        }

        function projectHealth_RenderTable(dataArray) {
            if ($.fn.DataTable.isDataTable("#table_projectHealthReport")) {
                projectHealthTable.destroy();
            }

            projectHealthTable = $("#table_projectHealthReport").DataTable({
                dom: "Bfrtip",
                destroy: true,
                scrollX: true,
                paging: true,
                pageLength: 25,
                autoWidth: true,
                ordering: false,
                processing: true,
                filter: true,
                data: dataArray,
                columns: [
                    { data: "Month", defaultContent: "" },
                    { data: "Year", defaultContent: "" },
                    { data: "Domain", defaultContent: "" },
                    { data: "Subdomain", defaultContent: "" },
                    { data: "Project", defaultContent: "" },
                    { data: "OrderCount", defaultContent: "0" },
                    { data: "BilledCount", defaultContent: "0" },
                    { data: "OnHoldCount", defaultContent: "0" },
                    { data: "InProcessCount", defaultContent: "0" },
                    { data: "CodeCount", defaultContent: "0" },
                    { data: "InternalErrors", defaultContent: "0" },
                    { data: "ClientErrors", defaultContent: "0" },
                    { data: "Accuracy", defaultContent: "" },
                    { data: "AvgTAT", defaultContent: "" },
                    { data: "VolumeVariation", defaultContent: "" },
                    { data: "AccuracyVariation", defaultContent: "" }
                ],
                columnDefs: [
                    { targets: [0, 1, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], className: "text-center" }
                ],
                buttons: [
                    {
                        extend: "excelHtml5",
                        title: "Project Health Report",
                        text: '<i class="fas fa-file-excel"></i> Export Excel',
                        autoFilter: true
                    }
                ]
            });
        }

        function projectHealth_UpdateStats(dataArray) {
            $("#projectHealth_Records").text(dataArray.length);
            $("#projectHealth_Received").text(projectHealth_Sum(dataArray, "OrderCount"));
            $("#projectHealth_Billed").text(projectHealth_Sum(dataArray, "BilledCount"));
            $("#projectHealth_Errors").text(projectHealth_Sum(dataArray, "InternalErrors") + projectHealth_Sum(dataArray, "ClientErrors"));
        }

        function projectHealth_Sum(dataArray, fieldName) {
            var total = 0;
            $.each(dataArray, function (index, row) {
                total += parseFloat(row[fieldName]) || 0;
            });
            return total;
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="projectHealth_load">
        <img src="../images/Load_1.gif" alt="Loading" />
        <div>Loading report...</div>
    </div>

    <div class="health-page">
        <div class="health-hero">
            <div>
                <div class="health-kicker">Operations</div>
                <h1 class="health-title"><i class="fas fa-chart-simple mr-2"></i>Project Health Report</h1>
                <p class="health-subtitle">Review project volume, billed work, work status, FTE utilization, accuracy, TAT, and month-over-month variation.</p>
            </div>
        </div>

        <div class="health-panel">
            <div class="health-panel-header">
                <div>
                    <h2 class="health-panel-title"><i class="fas fa-filter"></i>Report Filters</h2>
                    <p class="health-panel-subtitle">Select a month range and project scope.</p>
                </div>
            </div>
            <div class="health-panel-body">
                <div class="health-form-grid">
                    <div class="health-field">
                        <label for="projectHealth_FromMonth">From Month</label>
                        <select id="projectHealth_FromMonth" class="form-control">
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
                    </div>
                    <div class="health-field">
                        <label for="projectHealth_FromYear">From Year</label>
                        <select id="projectHealth_FromYear" class="form-control"></select>
                    </div>
                    <div class="health-field">
                        <label for="projectHealth_ToMonth">To Month</label>
                        <select id="projectHealth_ToMonth" class="form-control">
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
                    </div>
                    <div class="health-field">
                        <label for="projectHealth_ToYear">To Year</label>
                        <select id="projectHealth_ToYear" class="form-control"></select>
                    </div>
                    <div class="health-field">
                        <label for="projectHealth_Domain">Domain</label>
                        <select id="projectHealth_Domain" class="form-control"></select>
                    </div>
                    <div class="health-field">
                        <label for="projectHealth_Project">Project</label>
                        <select id="projectHealth_Project" class="form-control"></select>
                    </div>
                </div>
                <div class="health-action-row">
                    <button type="button" id="projectHealth_Clear" class="health-btn health-btn-outline">
                        <i class="fas fa-rotate-left"></i>
                        Clear
                    </button>
                    <button type="button" id="projectHealth_GetReport" class="health-btn health-btn-primary">
                        <i class="fas fa-chart-line"></i>
                        Get Report
                    </button>
                </div>
            </div>
        </div>

        <div class="health-stat-grid">
            <div class="health-stat">
                <span>Records</span>
                <strong id="projectHealth_Records">0</strong>
            </div>
            <div class="health-stat">
                <span>Volume Received</span>
                <strong id="projectHealth_Received">0</strong>
            </div>
            <div class="health-stat">
                <span>Volume Billed</span>
                <strong id="projectHealth_Billed">0</strong>
            </div>
            <div class="health-stat">
                <span>Total Errors</span>
                <strong id="projectHealth_Errors">0</strong>
            </div>
        </div>

        <div class="health-panel">
            <div class="health-panel-header">
                <div>
                    <h2 class="health-panel-title"><i class="fas fa-table"></i>Project Health Data</h2>
                    <p class="health-panel-subtitle">Use search and export after loading the report.</p>
                </div>
            </div>
            <div class="health-table-wrap">
                <table class="table table-bordered" id="table_projectHealthReport">
                    <thead>
                        <tr>
                            <th>Month</th>
                            <th>Year</th>
                            <th>Domain</th>
                            <th>Subdomain</th>
                            <th>Project</th>
                            <th>Total Volume Received</th>
                            <th>Total Volume Billed</th>
                            <th>Total Volume On Hold</th>
                            <th>Total Volume In-Process</th>
                            <th># of FTEs Utilized</th>
                            <th># of Errors Internal</th>
                            <th># of Errors Client</th>
                            <th>Accuracy %</th>
                            <th>Average TAT</th>
                            <th>Volume Variation From Previous Month</th>
                            <th>Accuracy Variation From Previous Month</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
