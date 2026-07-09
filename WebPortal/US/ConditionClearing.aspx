<%@ Page Title="" Language="C#" MasterPageFile="~/US/USAdmin.Master" AutoEventWireup="true" CodeBehind="ConditionClearing.aspx.cs" Inherits="WebPortal.US.ConditionClearing" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        :root {
            --ca-primary: #2563eb;
            --ca-primary-dark: #1d4ed8;
            --ca-primary-soft: #eff6ff;
            --ca-success: #16a34a;
            --ca-success-dark: #15803d;
            --ca-bg: #f5f7fb;
            --ca-surface: #ffffff;
            --ca-text: #111827;
            --ca-muted: #6b7280;
            --ca-border: #e5e7eb;
            --ca-ring: rgba(37, 99, 235, .18);
            --ca-shadow: 0 18px 45px rgba(15, 23, 42, .10);
            --ca-radius-lg: 20px;
            --ca-radius-md: 12px;
        }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            width: 100%;
            height: 100%;
            z-index: 200000;
            background: rgba(15, 23, 42, .30);
            backdrop-filter: blur(4px);
            align-items: center;
            justify-content: center;
            text-align: center;
        }

            .loading img {
                width: 74px;
                height: 74px;
                padding: 12px;
                background: var(--ca-surface);
                border-radius: 18px;
                box-shadow: var(--ca-shadow);
            }

            .loading div {
                display: inline-block;
                margin-top: 12px;
                padding: 8px 14px;
                color: var(--ca-text);
                background: var(--ca-surface);
                border-radius: 999px;
                box-shadow: 0 8px 25px rgba(15, 23, 42, .12);
            }

        .condition-page {
            width: 100%;
            padding: 0 15px 24px;
            background: var(--ca-bg);
            min-height: calc(100vh - 80px);
        }

        .condition-hero {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            padding: 22px 24px;
            margin: 0 15px 18px;
            color: #fff;
            background: linear-gradient(135deg, #2563eb 0%, #7c3aed 100%);
            border-radius: var(--ca-radius-lg);
            box-shadow: var(--ca-shadow);
            overflow: hidden;
            position: relative;
        }

            .condition-hero:after {
                content: "";
                position: absolute;
                right: -64px;
                top: -64px;
                width: 190px;
                height: 190px;
                border-radius: 999px;
                background: rgba(255, 255, 255, .15);
            }

        .condition-title-wrap {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .condition-title-icon {
            width: 46px;
            height: 46px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 16px;
            background: rgba(255, 255, 255, .18);
            box-shadow: inset 0 0 0 1px rgba(255, 255, 255, .20);
            font-size: 20px;
        }

        .condition-title {
            margin: 0;
            font-size: 24px;
            line-height: 1.2;
            font-weight: 800;
            letter-spacing: -.02em;
        }

        .condition-subtitle {
            margin: 4px 0 0;
            color: rgba(255, 255, 255, .82);
            font-size: 13px;
        }

        .condition-card {
            width: 100%;
            margin-bottom: 18px;
            border: 1px solid var(--ca-border);
            border-radius: var(--ca-radius-lg);
            background: var(--ca-surface);
            box-shadow: 0 14px 35px rgba(15, 23, 42, .07);
            overflow: hidden;
        }

        .condition-card-header {
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 18px 20px;
            border-bottom: 1px solid var(--ca-border);
            background: linear-gradient(180deg, #fff 0%, #f8fafc 100%);
        }

        .condition-card-title {
            margin: 0;
            font-size: 16px;
            font-weight: 750;
            color: var(--ca-text);
        }

        .condition-card-hint {
            margin: 3px 0 0;
            color: var(--ca-muted);
            font-size: 12px;
        }

        .condition-card-body {
            padding: 18px 20px 22px;
        }

        .main-container {
            width: 100%;
        }

        .my-row {
            display: flex;
            flex-wrap: wrap;
            gap: 16px;
            margin-bottom: 16px;
            width: 100%;
        }

        .my-col-3, .my-col-4, .my-col-6, .my-col-12 {
            padding-right: 0;
        }

        .my-col-4 {
            flex: 1 1 260px;
            max-width: calc(33.333% - 11px);
        }

        .my-col-12 {
            flex: 1 1 100%;
            width: 100%;
            max-width: 100%;
        }

        .my-row label {
            display: block;
            margin-bottom: 7px;
            font-size: 12px;
            letter-spacing: .01em;
            color: #374151;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: 600 !important;
            border: none !important;
            color: #374151;
        }

        .req {
            color: #ef4444;
            font-weight: 800;
            margin-left: 3px;
        }

        .my-input, .my-select, .my-textarea {
            width: 100%;
            border: 1px solid var(--ca-border);
            padding: 9px 11px;
            border-radius: 12px;
            font-size: 13px;
            color: var(--ca-text);
            background-color: #fff;
            transition: border-color .16s ease, box-shadow .16s ease, background-color .16s ease;
        }

        .my-input, .my-select {
            height: 40px;
        }

        textarea.my-input, .my-textarea {
            min-height: 88px;
            height: auto;
            resize: vertical;
        }

            .my-input:focus, .my-select:focus, .my-textarea:focus {
                border-color: var(--ca-primary);
                box-shadow: 0 0 0 4px var(--ca-ring);
                outline: none;
            }

        .my-row:last-child {
            margin-bottom: 0;
        }

        .action-row {
            display: flex;
            justify-content: flex-end;
            align-items: center;
        }

        .my-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 42px;
            padding: 9px 22px;
            border: none;
            border-radius: 13px;
            color: white;
            margin-right: 0;
            font-size: 14px;
            font-weight: 800;
            letter-spacing: .01em;
            cursor: pointer;
            transition: transform .16s ease, box-shadow .16s ease, background .16s ease;
            background: linear-gradient(135deg, #2563eb 0%, #7c3aed 100%) !important;
        }

            .my-btn:hover {
                transform: translateY(-1px);
                opacity: 1;
            }

        .primary {
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            box-shadow: 0 10px 20px rgba(37, 99, 235, .24);
        }

        .success {
            background: linear-gradient(90deg, #16a34a 0%, #22c55e 100%);
            box-shadow: 0 10px 20px rgba(34, 197, 94, .22);
        }

        .warning {
            background: #f59e0b;
            box-shadow: 0 10px 20px rgba(245, 158, 11, .22);
        }

        .dataTables_scrollBody {
            min-height: 160px !important;
            height: auto;
        }

        .dataTables_length, .dataTables_info {
            float: left !important;
            color: var(--ca-muted);
            font-size: 13px;
        }

        div.dt-buttons {
            position: static;
            padding-left: 18px;
            float: left;
        }

        .buttons-excel, .buttons-html5 {
            color: #fff !important;
            box-shadow: 0 10px 20px rgba(37, 99, 235, .24);
            background: linear-gradient(135deg, var(--ca-primary), #7c3aed) !important;
            border: 0 !important;
            font-weight: 700;
            border-radius: 999px !important;
            margin: 0 6px;
            padding: 8px 14px !important;
        }

        .top {
            display: flex;
            align-items: center;
        }

        .dataTables_length {
            margin-right: 10px;
        }

        .dt-buttons {
            margin-right: auto;
        }

        .dataTables_filter {
            margin-left: auto;
        }

        .table.dataTable {
            border-collapse: separate !important;
            border-spacing: 0;
        }

            .table.dataTable th {
                white-space: nowrap;
                color: #374151;
                background: #f8fafc;
                border-bottom: 1px solid var(--ca-border) !important;
                font-size: 12px;
                text-transform: uppercase;
                letter-spacing: .04em;
            }

            .table.dataTable tr td {
                background: none !important;
                background-color: #fff !important;
                color: var(--ca-text);
                border-color: #eef2f7 !important;
                vertical-align: middle;
            }

            .table.dataTable tbody tr:hover td {
                background-color: #f8fbff !important;
            }

        #table_condclear_wrapper, #table_condclear {
            width: 100% !important;
        }

        .swal2-container {
            z-index: 200000 !important;
        }

        .custom-dropdown {
            position: relative;
            width: 200px;
            font-family: Arial, sans-serif;
        }

        .selected {
            border: 1px solid var(--ca-border);
            padding: 8px;
            border-radius: 12px;
            cursor: pointer;
            user-select: none;
            background: #fff;
        }

        .dropdown-menu {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            border: 1px solid var(--ca-border);
            border-top: none;
            background: #fff;
            max-height: 200px;
            overflow-y: auto;
            z-index: 10;
            border-radius: 0 0 12px 12px;
            box-shadow: 0 12px 30px rgba(15, 23, 42, .12);
        }

            .dropdown-menu.hidden {
                display: none;
            }

        .search-box {
            width: 100%;
            box-sizing: border-box;
            padding: 8px 10px;
            border: none;
            border-bottom: 1px solid var(--ca-border);
        }

        .options div {
            padding: 8px;
            cursor: pointer;
        }

            .options div:hover {
                background-color: var(--ca-primary-soft);
            }

        @media (max-width: 768px) {
            .condition-page {
                padding: 0 12px 18px;
            }

            .condition-hero {
                margin: 0 12px 16px;
                padding: 18px;
            }

            .condition-title {
                font-size: 20px;
            }

            .condition-card-header, .condition-card-body {
                padding: 16px;
            }

            div.dt-buttons {
                padding-left: 0;
                margin-top: 10px;
            }

            .my-col-4 {
                max-width: 100%;
                flex-basis: 100%;
            }
        }
    </style>

    <style>
        .select2-container--default .select2-selection--single {
            height: 40px;
            border: 1px solid #dbe3ef;
            border-radius: 8px;
            padding: 5px 10px;
        }

            .select2-container--default .select2-selection--single .select2-selection__rendered {
                line-height: 30px;
            }

            .select2-container--default .select2-selection--single .select2-selection__arrow {
                height: 38px;
            }

        .select2-dropdown {
            border-radius: 8px;
            border: 1px solid #dbe3ef;
        }

        .select2-search__field {
            border-radius: 6px !important;
        }
    </style>

    <script>

        $(document).ready(function () {

            bindProjects();
            condclearing_bindGrid();
        });
    </script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="loading" id="load1">
        <div>
            <img src="../images/Load_1.gif" />
            <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
        </div>
    </div>

    <div class="condition-hero">
        <div class="condition-title-wrap">
            <span class="condition-title-icon"><i class="fas fa-copy"></i></span>
            <div>
                <h1 class="condition-title">Condition Clearing</h1>
                <p class="condition-subtitle">Add, track, and clear client condition details.</p>
            </div>
        </div>
    </div>

    <div class="condition-page">
        <div class="condition-card">
            <div class="condition-card-header">
                <div>
                    <h2 class="condition-card-title">Add New Condition</h2>
                    <p class="condition-card-hint">Enter project, loan, condition, and rebuttal details.</p>
                </div>
            </div>
            <div class="condition-card-body">
                <div class="main-container">

                    <div class="my-row">
                        <div class="my-col-4">
                            <label><b>Project # <span class="req">*</span></b></label>
                            <select class="my-select" id="conclUS_project"></select>
                        </div>

                        <div class="my-col-4">
                            <label><b>Loan # <span class="req">*</span></b></label>
                            <input class="my-input" id="conclUS_loanNo" type="text" onchange="GetDealFromLoan(this);" />
                        </div>

                        <div class="my-col-4">
                            <label><b>Deal # <span class="req">*</span></b></label>
                            <input class="my-input" id="conclUS_dealNo" type="text" readonly/>
                        </div>
                    </div>

                    <div class="my-row">
                        <div class="my-col-4">
                            <label><b>Received Date <span class="req">*</span></b></label>
                            <input type="date" class="my-input" id="conclUS_receiveddate">
                        </div>

                        <div class="my-col-4">
                            <label><b>Initial Exception Grade <span class="req">*</span></b></label>
                            <select class="my-select" id="conclUS_expgrade">
                                <option value="">Select Grade</option>
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="4">4</option>
                            </select>
                        </div>

                        <div class="my-col-4">
                            <label><b>Process <span class="req">*</span></b></label>
                            <select class="my-select" id="conclUS_process">
                                <option value="">Select Process</option>
                                <option value="Loan Setup">Loan Setup</option>
                                <option value="Credit">Credit</option>
                                <option value="Compliance">Compliance</option>
                            </select>
                        </div>
                    </div>

                    <div class="my-row">
                        <div class="my-col-12">
                            <label><b>Infinity Condition <span class="req">*</span></b></label>
                            <textarea class="my-input" id="conclUS_infcondition"></textarea>
                        </div>
                    </div>

                    <div class="my-row">
                        <div class="my-col-12">
                            <label><b>Clients Rebuttal <span class="req">*</span></b></label>
                            <textarea class="my-input" id="conclUS_rebuttal"></textarea>
                        </div>
                    </div>

                    <div class="my-row">
                        <div class="my-col-12 action-row">
                            <button type="button" class="my-btn primary" onclick="return conclUS_SaveData();">Add Condition</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="condition-card">
            <div class="condition-card-header">
                <div>
                    <h2 class="condition-card-title">Condition Clearing Queue</h2>
                    <p class="condition-card-hint">Review saved condition clearing records below.</p>
                </div>
            </div>
            <div class="condition-card-body">
                <table class="table" id="table_condclear" style="width: 100%;">
                    <thead></thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>

