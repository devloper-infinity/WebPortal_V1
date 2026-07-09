<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="PoshTestResult.aspx.cs" Inherits="WebPortal.Admin.PoshTestResult" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --posh-primary: #2563eb;
            --posh-primary-dark: #1d4ed8;
            --posh-accent: #22c1dc;
            --posh-success: #16a34a;
            --posh-danger: #ef4444;
            --posh-text: #0f172a;
            --posh-muted: #64748b;
            --posh-border: #dbe4f0;
            --posh-soft: #f8fbff;
        }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            margin: auto;
            width: 190px;
            height: 150px;
            z-index: 99999;
            background: rgba(255,255,255,.96);
            border: 1px solid #dbeafe;
            border-radius: 22px;
            box-shadow: 0 18px 50px rgba(15,23,42,.18);
            align-items: center;
            justify-content: center;
            flex-direction: column;
            text-align: center;
            color: var(--posh-text);
            font-size: 12px;
            font-weight: 700;
        }

            .loading img {
                max-width: 58px;
                margin-bottom: 10px;
            }

        .posh-page {
            background: #eef3f9;
            min-height: calc(100vh - 70px);
        }

        .posh-hero {
            position: relative;
            overflow: hidden;
            border-radius: 22px;
            padding: 22px 26px;
            margin-bottom: 18px;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 62%, #22c1dc 100%);
            color: #fff;
            box-shadow: 0 16px 35px rgba(37,99,235,.25);
        }

            .posh-hero:before,
            .posh-hero:after {
                content: "";
                position: absolute;
                border-radius: 50%;
                background: rgba(255,255,255,.13);
            }

            .posh-hero:before {
                width: 180px;
                height: 180px;
                right: -45px;
                top: -70px;
            }

            .posh-hero:after {
                width: 110px;
                height: 110px;
                right: 110px;
                bottom: -55px;
            }

        .posh-hero-content {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .posh-hero-icon {
            width: 58px;
            height: 58px;
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.18);
            border: 1px solid rgba(255,255,255,.28);
            box-shadow: inset 0 1px 0 rgba(255,255,255,.2);
            font-size: 26px;
        }

        .posh-hero h3 {
            margin: 0;
            font-size: 23px;
            font-weight: 800;
            letter-spacing: .2px;
        }

        .posh-hero p {
            margin: 4px 0 0;
            color: rgba(255,255,255,.88);
            font-size: 13px;
            font-weight: 500;
        }

        .posh-card {
            background: #fff;
            border: 1px solid var(--posh-border);
            border-radius: 20px;
            box-shadow: 0 10px 28px rgba(15,23,42,.07);
            margin-bottom: 18px;
            overflow: hidden;
        }

        .posh-card-head {
            padding: 16px 20px;
            border-bottom: 1px solid #e8eef7;
            background: linear-gradient(180deg, #fff, #f8fbff);
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
        }

        .posh-section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0;
            color: var(--posh-text);
            font-size: 15px;
            font-weight: 800;
        }

            .posh-section-title i {
                width: 34px;
                height: 34px;
                border-radius: 10px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                color: #fff;
                background: linear-gradient(135deg, var(--posh-primary), var(--posh-accent));
            }

        .posh-card-body {
            padding: 20px;
        }

        .posh-filter-grid {
            display: grid;
            grid-template-columns: repeat(12, 1fr);
            gap: 16px;
            align-items: end;
        }

        .posh-field {
            grid-column: span 4;
        }

        .posh-action-field {
            grid-column: span 4;
            display: flex;
            gap: 10px;
            justify-content: flex-start;
        }

        .posh-field label {
            display: block;
            margin-bottom: 7px;
            color: #334155;
            font-size: 12px;
            font-weight: 800;
        }

        .posh-field .form-control,
        .posh-field select {
            height: 43px;
            border: 1px solid #cbd5e1;
            border-radius: 12px;
            color: #0f172a;
            font-size: 13px;
            font-weight: 600;
            box-shadow: none;
            transition: .25s;
        }

            .posh-field .form-control:focus,
            .posh-field select:focus {
                border-color: var(--posh-primary);
                box-shadow: 0 0 0 3px rgba(37,99,235,.13);
            }

        .btn-posh-primary {
            height: 43px;
            padding: 0 24px;
            border: 0;
            border-radius: 12px;
            background: linear-gradient(135deg, var(--posh-primary), var(--posh-accent));
            color: #fff !important;
            font-weight: 800;
            box-shadow: 0 10px 22px rgba(37,99,235,.24);
            transition: .25s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

            .btn-posh-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 14px 28px rgba(37,99,235,.32);
            }

        .posh-table-wrap {
            width: 100%;
            overflow-x: auto;
        }

            .posh-table-wrap table {
                margin-bottom: 0 !important;
                width: 100% !important;
            }

            .table.dataTable,
            .posh-table-wrap .table {
                border-collapse: separate !important;
                border-spacing: 0;
                border: 1px solid #e2e8f0;
                border-radius: 14px;
                overflow: hidden;
            }

                .table.dataTable th,
                .posh-table-wrap .table thead th {
                    background: #edf3f8 !important;
                    color: #0f172a !important;
                    border-bottom: 1px solid #dbe4f0 !important;
                    font-size: 12px;
                    font-weight: 800;
                    white-space: nowrap;
                    vertical-align: middle;
                }

                .table.dataTable td,
                .posh-table-wrap .table tbody td {
                    font-size: 12px;
                    vertical-align: middle;
                    color: #1e293b;
                    border-color: #e5edf6 !important;
                }

                .table.dataTable tbody tr:hover td,
                .posh-table-wrap .table tbody tr:hover td {
                    background: #f8fbff !important;
                }

        div.dt-buttons {
            position: static;
            padding-left: 0;
            float: left;
            margin-bottom: 10px;
        }

        .buttons-excel {
            color: #fff !important;
            box-shadow: 0 10px 22px rgba(22,163,74,.18);
            background: linear-gradient(135deg, #16a34a, #22c55e) !important;
            border: 0 !important;
            font-weight: 800 !important;
            margin: 0 10px 8px 0 !important;
            border-radius: 10px !important;
            padding: 8px 15px !important;
        }

        .dataTables_filter input,
        .dataTables_length select {
            border: 1px solid #cbd5e1 !important;
            border-radius: 10px !important;
            padding: 5px 10px !important;
            outline: none !important;
        }

        .posh-chip {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 7px 12px;
            border-radius: 999px;
            background: #eef6ff;
            color: #2563eb;
            font-size: 12px;
            font-weight: 800;
        }

        @media (max-width: 992px) {
            .posh-field,
            .posh-action-field {
                grid-column: span 6;
            }
        }

        @media (max-width: 576px) {
            .posh-page {
                padding: 10px;
            }

            .posh-hero {
                padding: 18px;
                border-radius: 18px;
            }

                .posh-hero h3 {
                    font-size: 19px;
                }

            .posh-hero-content {
                align-items: flex-start;
            }

            .posh-field,
            .posh-action-field {
                grid-column: span 12;
            }

                .posh-action-field .btn-posh-primary {
                    width: 100%;
                    justify-content: center;
                }

            .posh-card-body {
                padding: 14px;
            }
        }
    </style>
    <script>
        $(document).ready(function () {

            poshtestres_bindyear();

            var poshmonth = document.getElementById("poshtestres_month");
            var Pmonth = poshmonth.options[poshmonth.selectedIndex].text;

            var poshyear = document.getElementById("poshtestres_year");
            var Pyear = poshyear.options[poshyear.selectedIndex].value;

            if (Pmonth != "Select" && Pyear != "Select") {
                poshtestres_submit(Pmonth, Pyear);
            }
        });
    </script>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div>One moment, please . . .</div>
    </div>

    <div class="posh-page">
        <div class="posh-hero">
            <div class="posh-hero-content">
                <div class="posh-hero-icon">
                    <i class="fas fa-shield-alt"></i>
                </div>
                <div>
                    <h3>POSH Induction Test Result</h3>
                    <p>View POSH induction test summary, employee-wise result details and answer sheets.</p>
                </div>
            </div>
        </div>

        <div class="posh-card">
            <div class="posh-card-head">
                <h6 class="posh-section-title">
                    <i class="fas fa-filter"></i>
                    Filter Test Result
                </h6>
                <span class="posh-chip"><i class="fas fa-calendar-alt"></i>Month / Year Wise</span>
            </div>
            <div class="posh-card-body">
                <div class="posh-filter-grid">
                    <div class="posh-field">
                        <label for="poshtestres_month">Month</label>
                        <select id="poshtestres_month" name="poshtestres_month" class="form-control">
                            <option value="Select">Select</option>
                            <option value="All">All</option>
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

                    <div class="posh-field">
                        <label for="poshtestres_year">Year</label>
                        <select id="poshtestres_year" name="poshtestres_year" class="form-control">
                            <option value="">Select</option>
                        </select>
                    </div>

                    <div class="posh-action-field">
                        <button id="btnShow" type="button" class="btn btn-posh-primary" onclick="return poshtestres_submit();">
                            <i class="fas fa-search"></i>
                            <span>Show Result</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <div class="posh-card">
            <div class="posh-card-head">
                <h6 class="posh-section-title">
                    <i class="fas fa-chart-pie"></i>
                    Summary
                </h6>
            </div>
            <div class="posh-card-body">
                <div class="posh-table-wrap">
                    <table class="table table-bordered table-hover" id="table_poshtestSummary" style="width: 100%;">
                        <thead>
                            <tr>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Total</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Completed</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Pending</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="posh-card">
            <div class="posh-card-head">
                <h6 class="posh-section-title">
                    <i class="fas fa-list-check"></i>
                    Detail
                </h6>
            </div>
            <div class="posh-card-body">
                <div class="posh-table-wrap">
                    <table class="table table-bordered table-hover" id="poshtestres_table" style="padding-top: 10px; width: 100%;">
                        <thead>
                            <tr>
                                <th class="sort border-top ps-3" style="display: none;">EmployeeID</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Answer Sheet</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Employee Name</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Joining Date</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Test Status</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Test Date</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Marks</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Result</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; display: none;">View Answer Sheet</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
