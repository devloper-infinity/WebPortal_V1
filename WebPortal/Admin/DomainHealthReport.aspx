<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="DomainHealthReport.aspx.cs" Inherits="WebPortal.Admin.DomainHealthReport" %>

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

        .table {
            border-collapse: separate !important;
            border-spacing: 0;
            margin-top: 0 !important;
            width: 100% !important;
        }

        .table thead th {
            background: linear-gradient(to bottom, #0f766e, 3%, #fff) !important;
            border-color: rgba(255,255,255,0.28) !important;
            color: #000;
            font-size: 12px;
            font-weight: 700;
            text-align: center;
            vertical-align: middle;
            white-space: nowrap;
        }

        .table tbody td {
            background: #fff;
            border-color: #e2e9ef !important;
            color: #263747;
            font-size: 12px;
            vertical-align: middle;
        }

        .table tbody tr:hover td {
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
        var domainHealthTable;

        $(document).ready(function () {
            domainHealth_Init();
        });

        function domainHealth_Init() {
            domainHealth_FillYears();
            domainHealth_SetDefaultMonths();
            domainHealth_BindDomains();

            $("#domainHealth_Domain").on("change", function () {
                domainHealth_BindSubdomains($(this).val());
            });

            $("#domainHealth_Clear").on("click", function () {
                domainHealth_SetDefaultMonths();
                $("#domainHealth_Domain").val("0");
                domainHealth_BindSubdomains("0");
                domainHealth_RenderTable([]);
                domainHealth_UpdateStats([]);
                return false;
            });

            $("#domainHealth_GetReport").on("click", function () {
                return domainHealth_GetReport();
            });

            domainHealth_RenderTable([]);
        }

        function domainHealth_FillYears() {
            var currentYear = new Date().getFullYear();
            var startYear = currentYear - 5;
            var options = "";

            for (var year = startYear; year <= currentYear; year++) {
                options += '<option value="' + year + '">' + year + '</option>';
            }

            $("#domainHealth_FromYear, #domainHealth_ToYear").html(options).val(currentYear.toString());
        }

        function domainHealth_SetDefaultMonths() {
            var monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
            var month = monthNames[new Date().getMonth()];
            $("#domainHealth_FromMonth, #domainHealth_ToMonth").val(month);
            $("#domainHealth_FromYear, #domainHealth_ToYear").val(new Date().getFullYear().toString());
        }

        function domainHealth_BindDomains() {
            $.ajax({
                type: "POST",
                url: "DomainHealthReport.aspx/GetDomainGroups",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (res) {
                    var dataArray = JSON.parse(res.d);
                    var select = $("#domainHealth_Domain");
                    select.empty();
                    select.append($("<option></option>").val("0").html("Select"));
                    if (dataArray.ShowAllDomains) {
                        select.append($("<option></option>").val("99").html("All Domains"));
                    }
                    //select.append($("<option></option>").val("99").html("All Domains"));


                    $.each(dataArray.Domains, function (index, value) {
                        select.append($("<option></option>").val(value.DomainGroupId).html(value.DomainGroupName));
                    });

                    domainHealth_BindSubdomains("0");
                }
            });
        }

        function domainHealth_BindSubdomains(domainId) {
            var select = $("#domainHealth_Subdomain");
            select.empty();
            select.append($("<option></option>").val("0").html("Select"));

            if (domainId === "0" || domainId === "") {
                return;
            }

            if (domainId === "99") {
                select.append($("<option></option>").val("-1").html("All Subdomains"));
                select.val("-1");
                return;
            }

            $.ajax({
                type: "POST",
                url: "DomainHealthReport.aspx/GetSubdomains",
                data: JSON.stringify({ DomainId: parseInt(domainId, 10) }),
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (res) {
                    var dataArray = JSON.parse(res.d);
                    select.empty();
                    select.append($("<option></option>").val("0").html("Select"));
                    select.append($("<option></option>").val("-1").html("All Subdomains"));

                    $.each(dataArray, function (index, value) {
                        select.append($("<option></option>").val(value.SubdomainID).html(value.SubdomainName));
                    });
                }
            });
        }

        function domainHealth_GetReport() {
            var filters = {
                FromMonth: $("#domainHealth_FromMonth").val(),
                FromYear: $("#domainHealth_FromYear").val(),
                ToMonth: $("#domainHealth_ToMonth").val(),
                ToYear: $("#domainHealth_ToYear").val(),
                DomainGroup: parseInt($("#domainHealth_Domain").val(), 10) || 0,
                SubdomainGroup: parseInt($("#domainHealth_Subdomain").val(), 10) || 0
            };

            if (!filters.FromMonth || !filters.ToMonth || filters.DomainGroup === 0) {
                alert("Please select month range and domain.");
                return false;
            }

            $("#domainHealth_load").show();

            $.ajax({
                type: "POST",
                url: "DomainHealthReport.aspx/GetReport",
                data: JSON.stringify(filters),
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (res) {
                    var dataArray = JSON.parse(res.d);
                    domainHealth_RenderTable(dataArray);
                    domainHealth_UpdateStats(dataArray);
                    $("#domainHealth_load").hide();
                },
                error: function (xhr) {
                    $("#domainHealth_load").hide();
                    alert("Unable to load domain health report.");
                    console.log(xhr.responseText);
                }
            });

            return false;
        }

        function domainHealth_RenderTable(dataArray) {
            if ($.fn.DataTable.isDataTable(".table")) {
                domainHealthTable.destroy();
            }

            domainHealthTable = $(".table").DataTable({
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
                    { data: "Domain", defaultContent: "" },
                    { data: "Subdomain", defaultContent: "" },
                    { data: "Month", defaultContent: "" },
                    { data: "Year", defaultContent: "" },
                    { data: "EmployeesAssigned", defaultContent: "0" },
                    { data: "OrderCount", defaultContent: "0" },
                    { data: "BilledCount", defaultContent: "0" },
                    { data: "CodeCount", defaultContent: "0" },
                    { data: "InternalErrors", defaultContent: "0" },
                    { data: "ClientErrors", defaultContent: "0" }
                ],
                columnDefs: [
                    { targets: [2, 3, 4, 5, 6, 7, 8, 9], className: "text-center" }
                ],
                buttons: [
                    {
                        extend: "excelHtml5",
                        title: "Domain Health Report",
                        text: '<i class="fas fa-file-excel"></i> Export Excel',
                        autoFilter: true
                    }
                ]
            });
        }

        function domainHealth_UpdateStats(dataArray) {
            $("#domainHealth_Records").text(dataArray.length);
            $("#domainHealth_Employees").text(domainHealth_Sum(dataArray, "EmployeesAssigned"));
            $("#domainHealth_Received").text(domainHealth_Sum(dataArray, "OrderCount"));
            $("#domainHealth_Errors").text(domainHealth_Sum(dataArray, "InternalErrors") + domainHealth_Sum(dataArray, "ClientErrors"));
        }

        function domainHealth_Sum(dataArray, fieldName) {
            var total = 0;
            $.each(dataArray, function (index, row) {
                total += parseFloat(row[fieldName]) || 0;
            });
            return total;
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="domainHealth_load">
        <img src="../images/Load_1.gif" alt="Loading" />
        <div>Loading report...</div>
    </div>

    <div class="health-page">
        <div class="health-hero">
            <div>
                <div class="health-kicker">Operations</div>
                <h1 class="health-title"><i class="fas fa-heart-pulse mr-2"></i>Domain Health Report</h1>
                <p class="health-subtitle">Review domain and subdomain volume, staffing, FTE utilization, and error health across selected billing months.</p>
            </div>
        </div>

        <div class="health-panel">
            <div class="health-panel-header">
                <div>
                    <h2 class="health-panel-title"><i class="fas fa-filter"></i>Report Filters</h2>
                    <p class="health-panel-subtitle">Select a month range and domain scope.</p>
                </div>
            </div>
            <div class="health-panel-body">
                <div class="health-form-grid">
                    <div class="health-field">
                        <label for="domainHealth_FromMonth">From Month</label>
                        <select id="domainHealth_FromMonth" class="form-control">
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
                        <label for="domainHealth_FromYear">From Year</label>
                        <select id="domainHealth_FromYear" class="form-control"></select>
                    </div>
                    <div class="health-field">
                        <label for="domainHealth_ToMonth">To Month</label>
                        <select id="domainHealth_ToMonth" class="form-control">
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
                        <label for="domainHealth_ToYear">To Year</label>
                        <select id="domainHealth_ToYear" class="form-control"></select>
                    </div>
                    <div class="health-field">
                        <label for="domainHealth_Domain">Domain</label>
                        <select id="domainHealth_Domain" class="form-control"></select>
                    </div>
                    <div class="health-field">
                        <label for="domainHealth_Subdomain">Subdomain</label>
                        <select id="domainHealth_Subdomain" class="form-control"></select>
                    </div>
                </div>
                <div class="health-action-row">
                    <button type="button" id="domainHealth_Clear" class="health-btn health-btn-outline">
                        <i class="fas fa-rotate-left"></i>
                        Clear
                    </button>
                    <button type="button" id="domainHealth_GetReport" class="health-btn health-btn-primary">
                        <i class="fas fa-chart-line"></i>
                        Get Report
                    </button>
                </div>
            </div>
        </div>

        <div class="health-stat-grid">
            <div class="health-stat">
                <span>Records</span>
                <strong id="domainHealth_Records">0</strong>
            </div>
            <div class="health-stat">
                <span>Employees Assigned</span>
                <strong id="domainHealth_Employees">0</strong>
            </div>
            <div class="health-stat">
                <span>Volume Received</span>
                <strong id="domainHealth_Received">0</strong>
            </div>
            <div class="health-stat">
                <span>Total Errors</span>
                <strong id="domainHealth_Errors">0</strong>
            </div>
        </div>

        <div class="health-panel">
            <div class="health-panel-header">
                <div>
                    <h2 class="health-panel-title"><i class="fas fa-table"></i>Domain Health Data</h2>
                    <p class="health-panel-subtitle">Use search and export after loading the report.</p>
                </div>
            </div>
            <div class="health-table-wrap">
                <table class="table table-bordered" id="table_domainHealthReport">
                    <thead>
                        <tr>
                            <th>Domain</th>
                            <th>Subdomain</th>
                            <th>Month</th>
                            <th>Year</th>
                            <th># of Employees Assigned</th>
                            <th>Total Volume Received</th>
                            <th>Total Volume Billed</th>
                            <th># of FTEs Utilized</th>
                            <th># of Errors Internal</th>
                            <th># of Errors Client</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
