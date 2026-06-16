<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="SecuritizationSummary.aspx.cs" Inherits="WebPortal.Admin.SecuritizationSummary" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style id="st1">
        body {
            background: #f3f6f8;
        }

        .sec-page {
            color: #16202a;
            padding-bottom: 28px;
        }

        .sec-hero {
            align-items: center;
            background: linear-gradient(135deg, #0f766e 0%, #1d4ed8 100%);
            border-radius: 8px;
            box-shadow: 0 14px 28px rgba(28,58,85,.16);
            color: #fff;
            display: flex;
            gap: 20px;
            justify-content: space-between;
            margin-bottom: 18px;
            padding: 22px 24px;
        }

        .sec-kicker {
            color: rgba(255,255,255,.82);
            font-size: 12px;
            font-weight: 700;
            margin-bottom: 6px;
            text-transform: uppercase;
        }

        .sec-title {
            font-size: 24px;
            font-weight: 700;
            line-height: 1.2;
            margin: 0;
        }

        .sec-subtitle {
            color: rgba(255,255,255,.88);
            font-size: 13px;
            margin: 8px 0 0;
            max-width: 760px;
        }

        .sec-hero-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: flex-end;
        }

        .sec-btn {
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

        .sec-btn-primary {
            background: #0f766e;
            border: 1px solid #0f766e;
            color: #fff;
        }

            .sec-btn-primary:hover, .sec-btn-primary:focus {
                background: #0b5f59;
                border-color: #0b5f59;
                color: #fff;
            }

        .sec-btn-light {
            background: rgba(255,255,255,.96);
            border: 1px solid rgba(255,255,255,.96);
            color: #17324d;
        }

        .sec-btn-soft {
            background: #eef6f5;
            border: 1px solid #cce3df;
            color: #0f5f58;
        }

        .sec-panel {
            background: #fff;
            border: 1px solid #dce5ec;
            border-radius: 8px;
            box-shadow: 0 10px 24px rgba(31,51,71,.06);
            margin-bottom: 18px;
            overflow: hidden;
        }

        .sec-panel-header {
            align-items: center;
            border-bottom: 1px solid #e7edf2;
            display: flex;
            gap: 14px;
            justify-content: space-between;
            padding: 16px 18px;
        }

        .sec-panel-title {
            align-items: center;
            color: #172737;
            display: flex;
            font-size: 16px;
            font-weight: 700;
            gap: 9px;
            margin: 0;
        }

        .sec-panel-subtitle {
            color: #6d7f90;
            font-size: 12px;
            margin: 4px 0 0;
        }

        .sec-panel-body {
            padding: 18px;
        }

        .sec-section-title {
            align-items: center;
            color: #2d3f50;
            display: flex;
            font-size: 13px;
            font-weight: 800;
            gap: 8px;
            margin: 0 0 12px;
        }

        .sec-form-grid {
            align-items: end;
            display: grid;
            gap: 14px 16px;
            grid-template-columns: 190px 190px 1fr;
        }

        .sec-field {
            min-width: 0;
        }

            .sec-field label {
                color: #46596b;
                display: block;
                font-size: 12px;
                font-weight: 700;
                margin-bottom: 6px;
            }

            .sec-field .form-control, .sec-field select {
                border: 1px solid #cfdbe5;
                border-radius: 6px;
                box-shadow: none;
                color: #172737;
                font-size: 13px;
                min-height: 38px;
                width: 100%;
            }

                .sec-field .form-control:focus, .sec-field select:focus {
                    border-color: #0f766e;
                    box-shadow: 0 0 0 3px rgba(15,118,110,.14);
                    outline: none;
                }

        .sec-action-row {
            align-items: center;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: flex-start;
        }

        .sec-table-wrap {
            overflow-x: auto;
            padding: 0 18px 18px;
        }

        #secsummary_rel, #secsummary_sec {
            border-collapse: separate !important;
            border-spacing: 0;
            margin-top: 0 !important;
            width: 100% !important;
        }

            #secsummary_rel thead th, #secsummary_sec thead th, .table.dataTable th {
                background: #edf3f6 !important;
                border-color: #d7e2ea !important;
                color: #263747;
                font-size: 12px;
                text-align: center;
                vertical-align: middle;
                white-space: nowrap;
            }

            #secsummary_rel tbody td, #secsummary_sec tbody td, .table.dataTable tr td {
                background: #fff;
                border-color: #e2e9ef !important;
                color: #263747;
                font-size: 12px;
                vertical-align: middle;
            }

            #secsummary_rel tbody tr:hover td, #secsummary_sec tbody tr:hover td {
                background: #f7fbfa;
            }

        .dataTables_wrapper .dataTables_info, .dataTables_wrapper .dataTables_paginate {
            color: #5c6f82;
            font-size: 12px;
            padding: 12px 0 0;
        }

        .dataTables_wrapper .dataTables_paginate {
            float: right !important;
        }

            .dataTables_wrapper .dataTables_paginate .paginate_button {
                border-radius: 6px !important;
                padding: 4px 10px !important;
            }

        div.dt-buttons {
            float: left;
            padding-left: 0;
            position: static;
        }

        .buttons-excel {
            background: #0f766e;
            border: 1px solid #0f766e;
            border-radius: 6px;
            box-shadow: none;
            color: #fff;
            font-size: 12px;
            font-weight: 700;
            margin: 0 10px;
            padding: 6px 12px;
        }

        .loading {
            align-items: center;
            background: rgba(255,255,255,.92);
            border: 1px solid #dce5ec;
            border-radius: 8px;
            box-shadow: 0 18px 40px rgba(20,33,45,.18);
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

        @media (max-width: 991px) {
            .sec-form-grid {
                grid-template-columns: repeat(2,minmax(0,1fr));
            }

            .sec-action-row {
                grid-column: 1 / -1;
            }
        }

        @media (max-width: 767px) {
            .sec-hero {
                align-items: flex-start;
                flex-direction: column;
            }

            .sec-hero-actions, .sec-action-row {
                align-items: stretch;
                flex-direction: column;
                width: 100%;
            }

            .sec-btn {
                width: 100%;
            }

            .sec-form-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            secsummary_bindyear();
        });
        function sec_genExcel_senttoclient() {
            document.getElementById("<%= btn1.ClientID %>").click();
            return false;
        }
    </script>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" alt="Loading" />
        <div>One moment, please...</div>
    </div>

    <div class="sec-page">
        <div class="sec-hero">
            <div>
                <div class="sec-kicker">Reports</div>
                <h1 class="sec-title"><i class="fas fa-chart-column mr-2"></i>Securitization Summary</h1>
                <p class="sec-subtitle">Review monthly Reliance Letter and Securitization request summaries, then export the report for client delivery.</p>
            </div>
            <div class="sec-hero-actions">
                <button type="button" id="secsummary_btnexport" class="sec-btn sec-btn-light" onclick="return secsummary_Exporttoexcel();">
                    <i class="fas fa-file-excel"></i>
                    Export to Excel
               
                </button>
                <asp:Button ID="btn1" runat="server" Style="display: none;" OnClick="btn1_Click" />
            </div>
        </div>

        <div class="sec-panel">
            <div class="sec-panel-header">
                <div>
                    <h2 class="sec-panel-title"><i class="fas fa-filter"></i>Report Filters</h2>
                    <p class="sec-panel-subtitle">Select billing month and year to load both summary sections.</p>
                </div>
            </div>
            <div class="sec-panel-body">
                <div class="sec-section-title"><i class="fas fa-calendar-days"></i>Billing Period</div>
                <div class="sec-form-grid">
                    <div class="sec-field">
                        <label for="secsummary_month">Month</label>
                        <select id="secsummary_month" name="secsummary_month" class="form-control">
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
                    <div class="sec-field">
                        <label for="secsummary_year">Year</label>
                        <select id="secsummary_year" name="secsummary_year" class="form-control">
                            <option value="">Select</option>
                        </select>
                    </div>
                    <div class="sec-action-row">
                        <button type="button" id="secsummary_btnShow" class="sec-btn sec-btn-primary" onclick="return secsummary_BindAllGrids();"><i class="fas fa-magnifying-glass-chart"></i>Show Report</button>
                        <button type="button" class="sec-btn sec-btn-soft" onclick="ResetSecuritizationSummary(); return false;"><i class="fas fa-rotate-left"></i>Reset</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="sec-panel">
            <div class="sec-panel-header">
                <div>
                    <h2 class="sec-panel-title"><i class="fas fa-file-signature"></i>Reliance Letter Requests</h2>
                    <p class="sec-panel-subtitle">Summary details for reliance letter requests in the selected billing period.</p>
                </div>
            </div>
            <div class="sec-table-wrap">
                <table class="table table-bordered" id="secsummary_rel" style="width: 100%;">
                    <thead id="secsummary_rel_head"></thead>
                </table>
            </div>
        </div>

        <div class="sec-panel">
            <div class="sec-panel-header">
                <div>
                    <h2 class="sec-panel-title"><i class="fas fa-building-columns"></i>Securitization Requests</h2>
                    <p class="sec-panel-subtitle">Summary details for securitization requests in the selected billing period.</p>
                </div>
            </div>
            <div class="sec-table-wrap">
                <table class="table table-bordered" id="secsummary_sec" style="width: 100%;">
                    <thead id="secsummary_sec_head"></thead>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">System is updating details. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>
</asp:Content>


