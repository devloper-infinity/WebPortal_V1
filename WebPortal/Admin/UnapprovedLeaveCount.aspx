<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="UnapprovedLeaveCount.aspx.cs" Inherits="WebPortal.Admin.UnapprovedLeaveCount" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --ulc-primary: #1d4ed8;
            --ulc-primary-2: #2563eb;
            --ulc-cyan: #22c1dc;
            --ulc-dark: #0f172a;
            --ulc-muted: #64748b;
            --ulc-soft: #f8fafc;
            --ulc-border: #e2e8f0;
            --ulc-shadow: 0 18px 45px rgba(15, 23, 42, .10);
        }

        .ulc-hero {
            position: relative;
            overflow: hidden;
            border-radius: 24px;
            padding: 24px 28px;
            margin-bottom: 22px;
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 60%, #22c1dc 100%);
            box-shadow: 0 18px 45px rgba(37, 99, 235, .25);
        }

        .ulc-hero:before,
        .ulc-hero:after {
            content: "";
            position: absolute;
            border-radius: 999px;
            background: rgba(255, 255, 255, .14);
            pointer-events: none;
        }

        .ulc-hero:before {
            width: 210px;
            height: 210px;
            top: -95px;
            right: -45px;
        }

        .ulc-hero:after {
            width: 140px;
            height: 140px;
            bottom: -65px;
            left: 35%;
        }

        .ulc-hero-content {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            flex-wrap: wrap;
        }

        .ulc-title-wrap {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .ulc-icon {
            width: 64px;
            height: 64px;
            min-width: 64px;
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            background: rgba(255, 255, 255, .18);
            border: 1px solid rgba(255, 255, 255, .28);
            box-shadow: inset 0 1px 0 rgba(255,255,255,.25);
        }

        .ulc-title {
            margin: 0;
            font-size: 24px;
            font-weight: 800;
            letter-spacing: .2px;
        }

        .ulc-subtitle {
            margin: 6px 0 0;
            color: rgba(255, 255, 255, .88);
            font-size: 14px;
        }

        .ulc-chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 14px;
            border-radius: 999px;
            background: rgba(255, 255, 255, .16);
            border: 1px solid rgba(255, 255, 255, .28);
            font-size: 13px;
            font-weight: 700;
            white-space: nowrap;
        }

        .ulc-filter-card,
        .ulc-table-card {
            border: 0;
            border-radius: 22px;
            background: #fff;
            box-shadow: var(--ulc-shadow);
        }

        .ulc-filter-card {
            margin-bottom: 22px;
        }

        .ulc-card-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 10px;
            padding: 20px 22px 0;
        }

        .ulc-card-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0;
            font-size: 16px;
            font-weight: 800;
            color: var(--ulc-dark);
        }

        .ulc-card-title i {
            color: var(--ulc-primary-2);
        }

        .ulc-card-desc {
            margin: 4px 0 0;
            color: var(--ulc-muted);
            font-size: 13px;
        }

        .ulc-filter-body {
            padding: 18px 22px 22px;
        }

        .ulc-field label {
            display: block;
            margin-bottom: 8px;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: .5px;
            color: #475569;
            font-weight: 800;
        }

        .ulc-field .form-control {
            width: 100% !important;
            height: 44px;
            border-radius: 12px;
            border: 1px solid var(--ulc-border);
            background: var(--ulc-soft);
            box-shadow: none;
            font-size: 14px;
            transition: .25s ease;
        }

        .ulc-field .form-control:focus {
            border-color: #60a5fa;
            background: #fff;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, .12);
        }

        .ulc-actions {
            display: flex;
            align-items: flex-end;
            gap: 10px;
            height: 100%;
        }

        .btn-ulc-primary {
            min-height: 44px;
            padding: 10px 22px;
            border: 0;
            border-radius: 12px;
            color: #fff !important;
            font-weight: 800;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%);
            box-shadow: 0 10px 24px rgba(37, 99, 235, .25);
            transition: .25s ease;
        }

        .btn-ulc-primary:hover,
        .btn-ulc-primary:focus {
            transform: translateY(-2px);
            box-shadow: 0 14px 28px rgba(37, 99, 235, .32);
        }

        .btn-ulc-primary i {
            margin-right: 7px;
        }

        .ulc-table-card {
            padding: 20px 22px 24px;
        }

        .ulc-table-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 12px;
            margin-bottom: 14px;
        }

        .ulc-table-title {
            margin: 0;
            font-size: 17px;
            font-weight: 850;
            color: var(--ulc-dark);
        }

        .ulc-table-note {
            color: var(--ulc-muted);
            font-size: 13px;
        }

        .ulc-table-shell {
            border: 1px solid var(--ulc-border);
            border-radius: 18px;
            overflow: hidden;
            background: #fff;
        }

        #unappleave_table {
            margin: 0 !important;
            width: 100% !important;
        }

        #unappleave_table thead th,
        .table.dataTable thead th {
            background: #edf3f6 !important;
            color: #0f172a !important;
            border-bottom: 1px solid #dbe5ef !important;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: .35px;
            height: 42px;
            vertical-align: middle;
            text-align: center;
            white-space: nowrap;
        }

        #unappleave_table tbody td {
            vertical-align: middle;
            color: #334155;
            font-size: 13px;
            white-space: nowrap;
            text-align: center;
        }

        #unappleave_table tbody tr:hover td {
            background: #f8fbff !important;
        }

        .dataTables_wrapper .dataTables_filter input,
        .dataTables_wrapper .dataTables_length select {
            border: 1px solid var(--ulc-border);
            border-radius: 10px;
            padding: 6px 10px;
            outline: none;
        }

        .dataTables_wrapper .dataTables_filter input:focus,
        .dataTables_wrapper .dataTables_length select:focus {
            border-color: #60a5fa;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, .10);
        }

        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dt-buttons {
            display: flex;
            align-items: center;
        }

        .dataTables_wrapper .dataTables_length {
            float: left !important;
        }

        .dataTables_paginate {
            float: left !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 18px;
            float: left;
        }

        .buttons-excel {
            color: #fff !important;
            border: 0 !important;
            border-radius: 10px !important;
            font-weight: 800 !important;
            padding: 7px 16px !important;
            background: linear-gradient(120deg, #16a34a 0%, #22c55e 100%) !important;
            box-shadow: 0 8px 18px rgba(34, 197, 94, .20) !important;
        }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            width: 100%;
            height: 100%;
            z-index: 99999;
            background: rgba(15, 23, 42, .30);
            backdrop-filter: blur(3px);
        }

        .loading-box {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 210px;
            padding: 22px 18px;
            text-align: center;
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 20px 50px rgba(15, 23, 42, .18);
        }

        .loading-box img {
            width: 70px;
            height: 70px;
            object-fit: contain;
        }

        .loading-text {
            margin-top: 10px;
            font-size: 13px;
            font-weight: 800;
            color: #334155;
        }

        @media (max-width: 767px) {
            .ulc-page {
                padding: 10px 4px 22px;
            }

            .ulc-hero {
                padding: 20px;
                border-radius: 18px;
            }

            .ulc-title {
                font-size: 20px;
            }

            .ulc-icon {
                width: 54px;
                height: 54px;
                min-width: 54px;
                font-size: 23px;
            }

            .ulc-filter-body,
            .ulc-table-card {
                padding: 16px;
            }

            .ulc-actions,
            .btn-ulc-primary {
                width: 100%;
            }
        }
    </style>
    <script>
        $(document).ready(function () {
            unappleave_bindyear();
        });

        function unappleave_bindyear() {
            var start = new Date().getFullYear();

            var select = document.getElementById("unappleave_year");
            let options = select.getElementsByTagName('option');

            for (var i = options.length; i--;) {
                select.removeChild(options[i]);
            }

            $("#unappleave_year").append($("<option></option>").val("0").html("Select"));
            for (var i = start; i > start - 5; i--) {
                $("#unappleave_year").append($("<option></option>").val(i).html(i));
            }
        }

        function unapprove_submit() {
            $('#load1').show();
            var ddldomain = document.getElementById("unappleave_domain");
            var ddlmonth = document.getElementById("unappleave_month");
            var ddlyear = document.getElementById("unappleave_year");
            var domainname = ddldomain.options[ddldomain.selectedIndex].text;
            var domain = ddldomain.options[ddldomain.selectedIndex].value;
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            var filename = domainname + "_" + month + "_" + year + "_Unapproved leaves count.xlsx";

            $.ajax({
                url: "UnapprovedLeaveCount.aspx/Getunapprovedleavecount",
                type: "POST",
                dataType: "json",
                data: "{DomainID:" + domain + ",Month:'" + month + "',Year:'" + year + "'}",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    var dataArray = JSON.parse(data.d);
                    $('#unappleave_table').DataTable({
                        dom: 'Bftip',
                        destroy: true,
                        orderCellsTop: true,
                        fixedHeader: true,
                        scrollY: "400px",
                        scrollCollapse: true,
                        scrollX: true,
                        paging: false,
                        autoWidth: false,
                        select: true,
                        ordering: false,
                        processing: true,
                        filter: true,
                        select: {
                            style: 'single'
                        },
                        serverSide: false,
                        data: dataArray,
                        columns: [
                            { data: 'Code' },
                            { data: 'Name' },
                            { data: 'BranchName' },
                            { data: 'Domain' },
                            { data: 'Subdomain' },
                            { data: 'Current Status' },
                            { data: 'Latest Login Date' },
                            { data: 'LeaveCount' }
                        ],
                        fnCreatedRow: function (nRow, aData, iDataIndex) {
                            $(nRow).children("td").css("text-wrap", "nowrap");
                            $(nRow).children("td").css("text-align", "center");
                        },
                        initComplete: function () {
                            $('#load1').hide();
                        },
                        buttons: [
                            {
                                extend: 'excelHtml5',
                                title: filename,
                                autoFilter: true
                            }
                        ]
                    });
                },
                error: function (error) {
                    $('#load1').hide();
                    alert('error; ' + eval(error));
                    alert('error; ' + error.responseText);
                }
            });
            return false;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <div class="loading-box">
            <img src="../images/Load_1.gif" />
            <div class="loading-text">One moment, please . . .</div>
        </div>
    </div>

    <div class="container-fluid ulc-page">
        <div class="ulc-hero">
            <div class="ulc-hero-content">
                <div class="ulc-title-wrap">
                    <div class="ulc-icon">
                        <i class="fas fa-calendar-times"></i>
                    </div>
                    <div>
                        <h1 class="ulc-title">Unapproved Leave Count</h1>
                        <p class="ulc-subtitle">View domain-wise unapproved leave count and export employee absent day details.</p>
                    </div>
                </div>
                <div class="ulc-chip">
                    <i class="fas fa-file-excel"></i>
                    Excel Export Ready
                </div>
            </div>
        </div>

        <div class="card ulc-filter-card">
            <div class="ulc-card-head">
                <div>
                    <h3 class="ulc-card-title"><i class="fas fa-filter"></i> Report Filters</h3>
                    <p class="ulc-card-desc">Select domain, month and year to generate the report.</p>
                </div>
            </div>
            <div class="ulc-filter-body">
                <div class="row">
                    <div class="col-lg-3 col-md-4 col-sm-6 col-12 mb-3">
                        <div class="ulc-field">
                            <label for="unappleave_domain">Domain</label>
                            <select id="unappleave_domain" name="unappleave_domain" class="form-control">
                                <option value="">Select</option>
                                <option value="1">Non-DD</option>
                                <option value="2">Credit</option>
                                <option value="3">Servicing</option>
                            </select>
                        </div>
                    </div>

                    <div class="col-lg-3 col-md-4 col-sm-6 col-12 mb-3">
                        <div class="ulc-field">
                            <label for="unappleave_month">Month</label>
                            <select id="unappleave_month" name="unappleave_month" class="form-control">
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
                    </div>

                    <div class="col-lg-3 col-md-4 col-sm-6 col-12 mb-3">
                        <div class="ulc-field">
                            <label for="unappleave_year">Year</label>
                            <select id="unappleave_year" name="unappleave_year" class="form-control">
                                <option value="">Select</option>
                            </select>
                        </div>
                    </div>

                    <div class="col-lg-3 col-md-4 col-sm-6 col-12 mb-3">
                        <div class="ulc-actions">
                            <button type="submit" id="btn_unappleave_search" name="btn_unappleave_search" onclick="return unapprove_submit();" class="btn btn-ulc-primary">
                                <i class="fas fa-search"></i>Show Report
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card ulc-table-card">
            <div class="ulc-table-header">
                <div>
                    <h3 class="ulc-table-title"><i class="fas fa-list-alt"></i> Leave Count Details</h3>
                    <div class="ulc-table-note">Generated records will display below with Excel export option.</div>
                </div>
            </div>
            <div class="ulc-table-shell">
                <table class="table table-bordered table-hover" id="unappleave_table">
                    <thead>
                        <tr>
                            <th>Code</th>
                            <th>Name</th>
                            <th>Branch</th>
                            <th>Domain</th>
                            <th>Subdomain</th>
                            <th>Current Status</th>
                            <th>Latest Login Date</th>
                            <th># of Absent Days</th>
                        </tr>
                    </thead>
                </table>
            </div>
        </div>
    </div>
</asp:Content>

