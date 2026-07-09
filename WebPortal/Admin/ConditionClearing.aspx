<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ConditionClearing.aspx.cs" Inherits="WebPortal.Admin.ConditionClearing" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        :root {
            --cc-primary: #1d4ed8;
            --cc-primary2: #2563eb;
            --cc-accent: #22c1dc;
            --cc-bg: #f4f7fb;
            --cc-text: #0f172a;
            --cc-muted: #64748b;
            --cc-border: #e2e8f0;
            --cc-soft: #eff6ff;
            --cc-shadow: 0 18px 45px rgba(15, 23, 42, .10);
        }

        .condition-page {
            background: var(--cc-bg);
            min-height: calc(100vh - 70px);
        }

        .cc-hero {
            position: relative;
            overflow: hidden;
            border-radius: 22px;
            padding: 24px 28px;
            margin-bottom: 20px;
            color: #fff;
            background: linear-gradient(120deg, var(--cc-primary) 0%, var(--cc-primary2) 62%, var(--cc-accent) 100%);
            box-shadow: var(--cc-shadow);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
        }

        .cc-hero:before,
        .cc-hero:after {
            content: "";
            position: absolute;
            border-radius: 999px;
            background: rgba(255,255,255,.16);
        }

        .cc-hero:before {
            width: 210px;
            height: 210px;
            right: -65px;
            top: -95px;
        }

        .cc-hero:after {
            width: 130px;
            height: 130px;
            right: 150px;
            bottom: -75px;
        }

        .cc-hero-left {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .cc-hero-icon {
            width: 58px;
            height: 58px;
            min-width: 58px;
            border-radius: 18px;
            background: rgba(255,255,255,.18);
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: inset 0 0 0 1px rgba(255,255,255,.22);
        }

        .cc-hero-icon i {
            font-size: 26px;
        }

        .cc-hero h3 {
            margin: 0;
            font-size: 24px;
            line-height: 1.2;
            font-weight: 800;
            letter-spacing: .2px;
        }

        .cc-hero p {
            margin: 5px 0 0;
            color: rgba(255,255,255,.86);
            font-size: 13px;
        }

        .cc-chip {
            position: relative;
            z-index: 1;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 14px;
            border-radius: 999px;
            background: rgba(255,255,255,.18);
            color: #fff;
            font-weight: 700;
            font-size: 12px;
            white-space: nowrap;
        }

        .cc-card {
            background: #fff;
            border: 1px solid rgba(226,232,240,.9);
            border-radius: 20px;
            box-shadow: 0 12px 32px rgba(15, 23, 42, .07);
            margin-bottom: 18px;
            overflow: hidden;
        }

        .cc-card-header {
            padding: 18px 22px;
            border-bottom: 1px solid var(--cc-border);
            background: linear-gradient(180deg, #ffffff 0%, #f8fbff 100%);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
        }

        .cc-card-title {
            display: flex;
            align-items: center;
            gap: 12px;
            color: var(--cc-text);
        }

        .cc-card-title i {
            width: 38px;
            height: 38px;
            border-radius: 12px;
            background: var(--cc-soft);
            color: var(--cc-primary2);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
        }

        .cc-card-title h5 {
            margin: 0;
            font-weight: 800;
            font-size: 16px;
        }

        .cc-card-title small {
            display: block;
            margin-top: 2px;
            color: var(--cc-muted);
            font-size: 12px;
        }

        .cc-card-body {
            padding: 22px;
        }

        .cc-grid {
            display: grid;
            grid-template-columns: repeat(12, minmax(0, 1fr));
            gap: 17px;
        }

        .cc-field {
            grid-column: span 4;
        }

        .cc-field.cc-full {
            grid-column: span 12;
        }

        .cc-field label {
            display: flex;
            align-items: center;
            gap: 5px;
            color: #334155;
            font-size: 12px;
            font-weight: 800;
            margin-bottom: 7px;
            letter-spacing: .1px;
        }

        .req {
            color: #ef4444;
            font-weight: 900;
        }

        .cc-input,
        .cc-select,
        .cc-textarea {
            width: 100%;
            border: 1px solid #dbe3ee;
            background: #fff;
            border-radius: 12px;
            padding: 10px 12px;
            color: var(--cc-text);
            font-size: 13px;
            outline: none;
            transition: all .2s ease;
            box-shadow: 0 1px 0 rgba(15, 23, 42, .02);
        }

        .cc-input,
        .cc-select {
            height: 42px;
        }

        .cc-textarea {
            min-height: 96px;
            resize: vertical;
        }

        .cc-input:focus,
        .cc-select:focus,
        .cc-textarea:focus {
            border-color: var(--cc-primary2);
            box-shadow: 0 0 0 4px rgba(37, 99, 235, .12);
        }

        .cc-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            flex-wrap: wrap;
            margin-top: 20px;
            padding-top: 18px;
            border-top: 1px dashed var(--cc-border);
        }

        .cc-btn {
            border: 0;
            min-height: 42px;
            padding: 10px 22px;
            border-radius: 12px;
            font-weight: 800;
            font-size: 13px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: all .2s ease;
            cursor: pointer;
        }

        .cc-btn-primary {
            color: #fff;
            background: linear-gradient(135deg, var(--cc-primary2), var(--cc-accent));
            box-shadow: 0 10px 22px rgba(37, 99, 235, .25);
        }

        .cc-btn-primary:hover {
            color: #fff;
            transform: translateY(-2px);
            box-shadow: 0 14px 28px rgba(37, 99, 235, .32);
        }

        .cc-table-wrap {
            padding: 18px;
            overflow: auto;
        }

        #table_condclear {
            width: 100% !important;
            border-collapse: separate !important;
            border-spacing: 0;
        }

        #table_condclear thead th {
            background: #edf3f6 !important;
            color: #0f172a;
            font-size: 12px;
            font-weight: 800;
            height: 42px;
            vertical-align: middle;
            border-bottom: 1px solid #dbe3ee !important;
            white-space: nowrap;
            text-align: center;
        }

        #table_condclear tbody td {
            font-size: 12px;
            vertical-align: middle;
            border-bottom: 1px solid #edf2f7;
            color: #334155;
        }

        #table_condclear tbody tr:hover {
            background: #f8fbff;
        }

        .top {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
            margin-bottom: 12px;
        }

        .dt-buttons {
            margin-right: auto;
        }

        .dataTables_filter {
            margin-left: auto;
        }

        .dataTables_filter input,
        .dataTables_length select {
            border: 1px solid #dbe3ee;
            border-radius: 10px;
            height: 34px;
            padding: 5px 10px;
            outline: none;
        }

        .loading {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 170px;
            min-height: 155px;
            z-index: 99999;
            background: rgba(255,255,255,.96);
            border-radius: 22px;
            box-shadow: 0 18px 50px rgba(15,23,42,.18);
            text-align: center;
            padding: 22px 14px;
            color: #0f172a;
            font-size: 12px;
            font-weight: 800;
        }

        .loading img {
            max-width: 78px;
            display: block;
            margin: 0 auto 10px;
        }

        @media (max-width: 991px) {
            .condition-page {
                padding: 14px;
            }

            .cc-hero {
                align-items: flex-start;
                flex-direction: column;
                padding: 22px;
            }

            .cc-field {
                grid-column: span 6;
            }
        }

        @media (max-width: 575px) {
            .cc-field,
            .cc-field.cc-full {
                grid-column: span 12;
            }

            .cc-card-body,
            .cc-card-header {
                padding: 16px;
            }

            .cc-hero h3 {
                font-size: 20px;
            }

            .cc-hero-icon {
                width: 50px;
                height: 50px;
                min-width: 50px;
            }

            .cc-actions,
            .dataTables_filter {
                justify-content: stretch;
                margin-left: 0;
            }

            .cc-btn {
                width: 100%;
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            bindProjects();
            condclearing_bindGrid();
        });
    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div>One moment, please . . . .</div>
    </div>

    <div class="condition-page">
        <div class="cc-hero">
            <div class="cc-hero-left">
                <div class="cc-hero-icon">
                    <i class="fas fa-clipboard-check"></i>
                </div>
                <div>
                    <h3>Condition Clearing</h3>
                    <p>Add condition details, client rebuttal and maintain condition clearing records.</p>
                </div>
            </div>
            <div class="cc-chip">
                <i class="fas fa-layer-group"></i>
                Condition Queue
            </div>
        </div>

        <div class="cc-card">
            <div class="cc-card-header">
                <div class="cc-card-title">
                    <i class="fas fa-plus"></i>
                    <div>
                        <h5>Add New Condition</h5>
                        <small>Fill required fields and submit condition information.</small>
                    </div>
                </div>
            </div>

            <div class="cc-card-body">
                <div class="cc-grid">
                    <div class="cc-field">
                        <label for="concl_project">Project # <span class="req">*</span></label>
                        <select class="cc-select" id="concl_project" onchange="bindDeals(this);"></select>
                    </div>

                    <div class="cc-field">
                        <label for="concl_dealNo">Deal # <span class="req">*</span></label>
                        <select class="cc-select" id="concl_dealNo" onchange="bindLoans(this);"></select>
                    </div>

                    <div class="cc-field">
                        <label for="concl_loanNo">Loan # <span class="req">*</span></label>
                        <select class="cc-select" id="concl_loanNo"></select>
                    </div>

                    <div class="cc-field">
                        <label for="concl_receiveddate">Received Date <span class="req">*</span></label>
                        <input type="date" class="cc-input" id="concl_receiveddate" />
                    </div>

                    <div class="cc-field">
                        <label for="concl_expgrade">Initial Exception Grade <span class="req">*</span></label>
                        <select class="cc-select" id="concl_expgrade">
                            <option value="">Select Grade</option>
                            <option value="1">1</option>
                            <option value="2">2</option>
                            <option value="3">3</option>
                            <option value="4">4</option>
                        </select>
                    </div>

                    <div class="cc-field">
                        <label for="concl_process">Process <span class="req">*</span></label>
                        <select class="cc-select" id="concl_process">
                            <option value="">Select Process</option>
                            <option value="Loan Setup">Loan Setup</option>
                            <option value="Credit">Credit</option>
                            <option value="Compliance">Compliance</option>
                        </select>
                    </div>

                    <div class="cc-field cc-full">
                        <label for="concl_infcondition">Infinity Condition <span class="req">*</span></label>
                        <textarea class="cc-textarea" id="concl_infcondition" placeholder="Enter infinity condition details"></textarea>
                    </div>

                    <div class="cc-field cc-full">
                        <label for="concl_rebuttal">Clients Rebuttal <span class="req">*</span></label>
                        <textarea class="cc-textarea" id="concl_rebuttal" placeholder="Enter client rebuttal details"></textarea>
                    </div>
                </div>

                <div class="cc-actions">
                    <button type="button" class="cc-btn cc-btn-primary" onclick="return concl_SaveData();">
                        <i class="fas fa-save"></i>
                        <span>Add Condition</span>
                    </button>
                </div>
            </div>
        </div>

        <div class="cc-card">
            <div class="cc-card-header">
                <div class="cc-card-title">
                    <i class="fas fa-table"></i>
                    <div>
                        <h5>Condition Clearing Records</h5>
                        <small>Search, review and export condition clearing data.</small>
                    </div>
                </div>
            </div>
            <div class="cc-table-wrap">
                <table class="table table-hover" id="table_condclear" style="width: 100%;">
                    <thead></thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

</asp:Content>

<%--<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        .main-container {
            width: 100%;
            padding: 15px 25px;
        }

        /* Custom Grid */
        .my-row {
            display: flex;
            flex-wrap: wrap;
            margin-bottom: 15px;
            width: 100%;
        }

        .my-col-4 {
            width: 33.33%;
            padding-right: 15px;
        }

        .my-col-12 {
            width: 100%;
        }

        .my-input:focus, .my-select:focus {
            border-color: #b5d3ff;
            box-shadow: 0 0 4px rgba(181, 211, 255, 0.6);
            outline: none;
        }
        /* Inputs */
        .my-input, .my-select {
            width: 100%;
            height: 34px;
            border: 1px solid #dcdcdc;
            padding: 6px;
            border-radius: 5px;
            font-size: 12px;
            background-color: #fff;
            transition: all 0.2s ease;
        }

        textarea.my-input {
            height: 70px;
            resize: none;
        }

        label {
            font-size: 12px;
            margin-bottom: 4px;
            display: block;
        }

        .my-btn {
            padding: 6px 18px;
            border-radius: 4px;
            border: none;
            color: #fff;
            font-size: 14px;
            margin-right: 8px;
        }

        .primary {
            background: #2f7ed8;
        }

        .success {
            background: #28a745;
        }

        .warning {
            background: #f0ad4e;
        }

        .my-btn:hover {
            opacity: 0.9;
        }

        .req {
            color: red;
            font-weight: bold;
            margin-left: 3px;
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
    </style>

    <style>
        .custom-dropdown {
            position: relative;
            width: 200px;
            font-family: Arial, sans-serif;
        }

        .selected {
            border: 1px solid #ccc;
            padding: 8px;
            cursor: pointer;
            user-select: none;
        }

        .dropdown-menu {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            border: 1px solid #ccc;
            border-top: none;
            background: #fff;
            max-height: 200px;
            overflow-y: auto;
            z-index: 10;
        }

            .dropdown-menu.hidden {
                display: none;
            }

        .search-box {
            width: 100%;
            box-sizing: border-box;
            padding: 6px 8px;
            border: none;
            border-bottom: 1px solid #ccc;
        }

        .options div {
            padding: 8px;
            cursor: pointer;
        }

            .options div:hover {
                background-color: #eee;
            }

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
    </style>

    <script>

        $(document).ready(function () {

            bindProjects();
            condclearing_bindGrid();
        });
    </script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Add New Condition</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <div class="main-container">

                    <!-- Row 1 -->
                    <div class="my-row">
                        <div class="my-col-4">
                            <label><b>Project # <span class="req">*</span></b></label>
                            <select class="my-select" id="concl_project" onchange="bindDeals(this);"></select>
                        </div>

                        <div class="my-col-4">
                            <label><b>Deal # <span class="req">*</span></b></label>
                            <select class="my-select" id="concl_dealNo" onchange="bindLoans(this);"></select>
                        </div>

                        <div class="my-col-4">
                            <label><b>Loan # <span class="req">*</span></b></label>
                            <select class="my-select" id="concl_loanNo"></select>
                        </div>
                    </div>

                    <!-- Row 2 -->
                    <div class="my-row">
                        <div class="my-col-4">
                            <label><b>Received Date <span class="req">*</span></b></label>
                            <input type="date" class="my-input" id="concl_receiveddate">
                        </div>

                        <div class="my-col-4">
                            <label><b>Initial Exception Grade <span class="req">*</span></b></label>
                            <select class="my-select" id="concl_expgrade">
                                <option value="">Select Grade</option>
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="4">4</option>
                            </select>
                        </div>

                        <div class="my-col-4">
                            <label><b>Process <span class="req">*</span></b></label>
                            <select class="my-select" id="concl_process">
                                <option value="">Select Process</option>
                                <option value="Loan Setup">Loan Setup</option>
                                <option value="Credit">Credit</option>
                                <option value="Compliance">Compliance</option>
                            </select>
                        </div>
                    </div>

                    <!-- Row 3 -->
                    <div class="my-row">
                        <div class="my-col-12">
                            <label><b>Infinity Condition <span class="req">*</span></b></label>
                            <textarea class="my-input" id="concl_infcondition"></textarea>
                        </div>
                    </div>

                    <!-- Row 4 -->
                    <div class="my-row">
                        <div class="my-col-12">
                            <label><b>Clients Rebuttal <span class="req">*</span></b></label>
                            <textarea class="my-input" id="concl_rebuttal"></textarea>
                        </div>
                    </div>

                    <!-- Buttons -->
                    <div class="my-row">
                        <div class="my-col-12">
                            <button class="my-btn primary" onclick="return concl_SaveData();">Add</button>
                         
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-body">
                <table class="table" id="table_condclear" style="width: 100%;">
                    <thead>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

</asp:Content>--%>
