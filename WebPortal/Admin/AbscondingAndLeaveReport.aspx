<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AbscondingAndLeaveReport.aspx.cs" Inherits="WebPortal.Admin.AbscondingAndLeaveReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%--   <style>
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

        .dataTables_scrollHeadInner {
            width: 100% !important;
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
            /*   margin: 0px 10px;*/
            border-radius: 12px;
            height: 40px;
            width: 95%;
            font-weight: 400;
            transition: 0.3s;
        }

        .table {
            width: 100% !important;
        }

        .dataTable {
            width: 100% !important;
        }

        .no-footer {
            width: 100% !important;
        }

        .table.dataTable th {
            background: linear-gradient(to bottom, #007bff, 3%, #fff) !important;
            color: #000;
            text-align: left;
        }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
        }

        .dataTables_scrollBody {
            min-height: 20px !important;
            height: auto !important;
        }

        .tab-pane {
            height: auto !important;
        }

        .dataTables_wrapper {
            margin-top: 0 !important;
        }

        .btn-gradient-primary {
            background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;
            color: #fff;
            border-radius: 12px;
            height: 40px;
            font-weight: 400;
            transition: 0.3s;
        }

            .btn-gradient-primary:hover {
                transform: translateY(-2px);
                /*background: linear-gradient(135deg, #4da6ff, #1a8cff);*/
                background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;
                color: #fff;
            }
    </style>--%>

    <style>
        .al-hero {
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%);
            color: #fff;
            border-radius: 18px;
            padding: 22px 24px;
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            box-shadow: 0 12px 30px rgba(37,99,235,.22);
        }

        .al-title {
            margin: 0;
            font-size: 24px;
            font-weight: 800;
        }

        .al-subtitle {
            margin-top: 5px;
            font-size: 13px;
            opacity: .9;
        }

        .al-chip {
            background: rgba(255,255,255,.18);
            padding: 9px 14px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 700;
            white-space: nowrap;
        }

        .al-card {
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 8px 28px rgba(15,23,42,.08);
            border: 1px solid #edf2f7;
            padding: 18px;
        }

        .al-label {
            font-size: 13px;
            font-weight: 700;
            color: #374151;
            margin-bottom: 6px;
        }

        .al-input {
            height: 42px !important;
            border-radius: 12px !important;
            border: 1px solid #dbe3ef !important;
        }

        .al-btn {
            height: 42px;
            border: 0;
            border-radius: 12px;
            color: #fff;
            font-weight: 700;
            width: 100%;
            transition: .2s;
        }

            .al-btn:hover {
                transform: translateY(-2px);
                color: #fff;
            }

        .al-show {
            background: linear-gradient(135deg, #2563eb, #22c1dc);
        }

        .al-export {
            background: linear-gradient(135deg, #16a34a, #22c55e);
        }

        .al-tabs-card {
            margin-top: 18px;
            border-radius: 18px;
            overflow: hidden;
            border: 1px solid #edf2f7;
            box-shadow: 0 8px 28px rgba(15,23,42,.08);
        }

            .al-tabs-card .nav-tabs {
                background: #f8fafc;
                border-bottom: 1px solid #e5e7eb;
                padding: 10px 10px 0;
            }

            .al-tabs-card .nav-link {
                border: 0;
                border-radius: 12px 12px 0 0;
                font-weight: 700;
                color: #475569;
                padding: 11px 18px;
            }

                .al-tabs-card .nav-link.active {
                    background: #fff;
                    color: #1d4ed8;
                    box-shadow: 0 -3px 12px rgba(15,23,42,.06);
                }

        .al-table-wrap {
            width: 100%;
            overflow-x: auto;
            padding: 14px;
            background: #fff;
        }

        .al-table {
            width: 100% !important;
            white-space: nowrap;
        }

            .al-table thead th {
                background: #edf3f6 !important;
                color: #111827 !important;
                font-size: 13px;
                font-weight: 800;
                height: 42px;
                vertical-align: middle;
            }

            .al-table tbody td {
                font-size: 13px;
                vertical-align: middle;
            }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(255,255,255,.72);
            z-index: 99999;
            align-items: center;
            justify-content: center;
            text-align: center;
            margin: auto;
            width: 210px;
            height: 150px;
            z-index: 99999;
            border: 1px solid var(--fw-border);
            border-radius: 24px;
            box-shadow: var(--fw-shadow);
            padding: 22px;
        }

        @media(max-width:768px) {
            .al-hero {
                flex-direction: column;
                align-items: flex-start;
            }

            .al-title {
                font-size: 20px;
            }

            .al-chip {
                width: 100%;
                text-align: center;
            }
        }

        .sec-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            gap: 22px;
            padding: 17px 35px;
            margin-bottom: 25px;
            border-radius: 18px;
            color: #fff;
            background: linear-gradient(115deg,#0a5fd7 0%,#1976f3 35%,#1da8ea 70%,#22d3ee 100%);
            box-shadow: 0 12px 28px rgba(21, 98, 228, .25);
        }

        .sec-hero-icon {
            width: 50px;
            height: 50px;
            min-width: 50px;
            border-radius: 20%;
            border: 2px solid rgba(255,255,255,.75);
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.10);
            backdrop-filter: blur(4px);
        }

            .sec-hero-icon i {
                font-size: 34px;
                color: #fff;
            }

        .sec-kicker {
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 2px;
            opacity: .9;
            margin-bottom: 5px;
            font-weight: 600;
        }

        .sec-title {
            margin: 0;
            font-size: 20px;
            font-weight: 700;
            color: #fff;
            margin-bottom: -10px;
        }

            .sec-title i {
                margin-right: 10px;
            }

        .sec-subtitle {
            margin: 10px 0 0;
            font-size: 14px;
            color: rgba(255,255,255,.92);
            line-height: 1.6;
            max-width: 900px;
        }
    </style>

    <script>
        function export_Submit() {
            __doPostBack("<%= btn1.UniqueID %>", '');
            return false;
        }
        $(document).ready(function () {
            BindYear_AbscondingLeave();
        });
    </script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <div>
            <img src="../images/Load_1.gif" />
            <div style="font-size: 12px; font-weight: bold;">One moment, please...</div>
        </div>
    </div>

    <div class="al-page"></div>

    <div class="sec-hero">
        <span class="sec-hero-icon">
            <i class="fas fa-user-clock"></i>
        </span>
        <div>
            <h1 class="sec-title">Monthly Absconding and Leaves Report</h1>
            <p class="sec-subtitle">
                View absconding employees and leave records by month and year.
            </p>
        </div>
    </div>

    <div class="al-card">
        <div class="row align-items-end g-3">

            <div class="col-lg-4 col-md-6">
                <label class="al-label">Month</label>
                <select id="ableave_month" name="ableave_month" class="form-control al-input">
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

            <div class="col-lg-4 col-md-6">
                <label class="al-label">Year</label>
                <select id="ableave_year" name="ableave_year" class="form-control al-input">
                    <option value="">Select Year</option>
                </select>
            </div>

            <div class="col-lg-2 col-md-6">
                <button id="ableave_btnShow" type="button" class="al-btn al-show" onclick="return ableave_Submit();">
                    <i class="fas fa-search"></i>&nbsp;&nbsp;Get Record
                </button>
            </div>

            <div class="col-lg-2 col-md-6">
                <button id="ableave_btnExport" type="button" class="al-btn al-export" onclick="return export_Submit();">
                    <i class="fas fa-file-excel"></i>&nbsp;&nbsp;Export
                </button>
            </div>
        </div>
    </div>

    <div class="al-tabs-card">
        <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
            <li class="nav-item">
                <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill"
                    href="#custom-tabs-one-home" role="tab">
                    <i class="fas fa-user-slash"></i>&nbsp;&nbsp;Absconding
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill"
                    href="#custom-tabs-one-profile" role="tab">
                    <i class="fas fa-calendar-minus"></i>&nbsp;&nbsp;Leaves
                </a>
            </li>
        </ul>

        <div class="tab-content" id="custom-tabs-one-tabContent">
            <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel">
                <div class="al-table-wrap">
                    <table class="table table-bordered table-hover al-table" id="abscondleavelist">
                        <!-- keep your same thead and tbody here -->
                    </table>
                </div>
            </div>

            <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel">
                <div class="al-table-wrap">
                    <table class="table table-bordered table-hover al-table" id="totalleavelist">
                        <!-- keep your same thead and tbody here -->
                    </table>
                </div>
            </div>
        </div>
    </div>

    <asp:Button ID="btn1" runat="server" Style="display: none;" OnClick="btn1_Click" />
</asp:Content>
