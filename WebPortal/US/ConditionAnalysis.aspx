<%@ Page Title="" Language="C#" MasterPageFile="~/US/USAdmin.Master" AutoEventWireup="true" CodeBehind="ConditionAnalysis.aspx.cs" Inherits="WebPortal.US.ConditionAnalysis" %>


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
            background: var(--ca-bg);
            min-height: calc(100vh - 80px);
        }

        .condition-hero {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            padding: 22px 24px;
            margin-bottom: 18px;
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

        .dataTables_scrollBody {
            min-height: 160px !important;
            height: auto;
        }

        .dataTables_length, .dataTables_info {
            float: left !important;
            color: var(--ca-muted);
            font-size: 13px;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: 600 !important;
            border: none !important;
            color: #374151;
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

        #table_conAnalysis_wrapper, #table_conAnalysis {
            width: 100% !important;
        }

        .swal2-container {
            z-index: 200000 !important;
        }

        .custom-modal {
            display: none;
            position: fixed;
            z-index: 9999;
            inset: 0;
            width: 100%;
            height: 100%;
            overflow-y: auto;
            padding: 28px 16px;
            background: rgba(15, 23, 42, .58);
            backdrop-filter: blur(6px);
        }

        .custom-modal-content {
            background: var(--ca-surface);
            margin: 0 auto;
            width: min(980px, 96vw);
            border: 1px solid rgba(255, 255, 255, .5);
            border-radius: 24px;
            box-shadow: 0 28px 70px rgba(15, 23, 42, .28);
            overflow: hidden;
            animation: modalIn .18s ease-out;
        }

        @keyframes modalIn {
            from {
                transform: translateY(12px);
                opacity: 0;
            }

            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        .custom-modal-header {
            padding: 18px 22px;
            background: linear-gradient(135deg, #1d4ed8 0%, #4338ca 55%, #7c3aed 100%) !important;
            font-weight: 700;
            display: flex;
            font-size: 16px;
            color: white;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
        }

            .custom-modal-header h5 {
                margin: 0;
                font-size: 18px;
                font-weight: 800;
                line-height: 1.3;
            }

        #ana_popupheader {
            display: inline-block;
            margin-left: 6px;
            font-weight: 500 !important;
            color: rgba(255, 255, 255, .86);
            font-size: 16px !important;
        }

        .custom-modal-body {
            padding: 22px;
            background: linear-gradient(180deg, #ffffff 0%, #f8fafc 100%);
        }

        .analysiscon-container {
            width: 100%;
        }

        .close-btn {
            cursor: pointer;
            width: 36px;
            height: 36px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 999px;
            background: rgba(255, 255, 255, .16);
            color: #fff;
            font-size: 26px;
            line-height: 1;
            transition: .16s ease;
        }

            .close-btn:hover {
                background: rgba(255, 255, 255, .26);
                transform: rotate(90deg);
            }

        .my-row {
            display: flex;
            flex-wrap: wrap;
            gap: 16px;
            margin-bottom: 16px;
        }

        .my-col-3, .my-col-4, .my-col-6, .my-col-12 {
            padding-right: 0;
        }

        .my-col-3 {
            flex: 1 1 220px;
            max-width: calc(25% - 12px);
        }

        .my-col-4 {
            flex: 1 1 260px;
            max-width: calc(33.333% - 11px);
        }

        .my-col-6 {
            flex: 1 1 360px;
            max-width: calc(50% - 8px);
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

        .my-textarea {
            min-height: 88px;
            resize: vertical;
        }

            .my-input[readonly], .my-textarea[readonly] {
                color: #4b5563;
                background: #f9fafb;
            }

            .my-input:focus, .my-select:focus, .my-textarea:focus {
                border-color: var(--ca-primary);
                box-shadow: 0 0 0 4px var(--ca-ring);
                outline: none;
            }

        .section-title-line {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 14px;
            font-weight: 800;
            margin: 22px 0 14px;
            color: var(--ca-primary-dark);
        }

            .section-title-line:after {
                content: "";
                flex: 1;
                height: 1px;
                background: linear-gradient(90deg, rgba(37, 99, 235, .28), transparent);
            }

            .section-title-line i {
                width: 30px;
                height: 30px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                margin-right: 0;
                font-size: 15px;
                border-radius: 10px;
                color: var(--ca-primary);
                background: var(--ca-primary-soft);
            }

        .card-blue.card-outline {
            display: none;
        }

        .my-row:last-child {
            margin-bottom: 0;
        }

        .my-col-12[style*="text-align: right"] {
            display: flex;
            justify-content: flex-end;
        }

        .my-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 42px;
            padding: 9px 20px;
            border: none;
            border-radius: 30px;
            color: white;
            margin-right: 0;
            font-weight: 800;
            letter-spacing: .01em;
            transition: transform .16s ease, box-shadow .16s ease, background .16s ease;
            background: linear-gradient(135deg, #2563eb 0%, #7c3aed 100%) !important;
        }

            .my-btn:hover {
                transform: translateY(-1px);
            }

        .primary {
            background: #64748b;
            box-shadow: 0 10px 20px rgba(100, 116, 139, .22);
        }

        .success {
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            border-radius: 13px;
        }

        @media (max-width: 768px) {
            .condition-page {
                padding: 12px;
            }

            .condition-hero {
                padding: 18px;
            }

            .condition-title {
                font-size: 20px;
            }

            div.dt-buttons {
                padding-left: 0;
                margin-top: 10px;
            }

            .custom-modal {
                padding: 12px;
            }

            .custom-modal-body {
                padding: 16px;
            }

            .my-col-3, .my-col-4, .my-col-6 {
                max-width: 100%;
                flex-basis: 100%;
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            condAnalysis_bindGrid();
        });
    </script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
 <%--   <div class="loading" id="usload1">
        <div>
            <img src="../images/Load_1.gif" />
            <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
        </div>
    </div>--%>

    <div class="condition-hero">
        <div class="condition-title-wrap">
            <span class="condition-title-icon"><i class="fas fa-copy"></i></span>
            <div>
                <h1 class="condition-title">Condition Analysis</h1>
                <p class="condition-subtitle">Review, analyze, and finalize client rebuttal conditions.</p>
            </div>
        </div>
    </div>

    <div class="condition-page">
        <div class="condition-card">
            <div class="condition-card-header">
                <div>
                    <h2 class="condition-card-title">Analysis Queue</h2>
                    <p class="condition-card-hint">Use the table actions to open and complete analysis.</p>
                </div>
            </div>
            <div class="condition-card-body">
                <table class="table" style="width: 100%;" id="table_conAnalysis">
                    <thead></thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Analysis Modal -->
    <div id="popUp_addResponse" class="custom-modal">
        <div class="custom-modal-content">
            <div class="custom-modal-header">
                <h5>Analysis Condition Of :<span id="ana_popupheader"></span></h5>
                <span class="close-btn" onclick="closeAnalysisModal()">&times;</span>
            </div>

            <div class="custom-modal-body">
                <div class="analysiscon-container">
                    <div class="my-row">
                        <div class="my-col-4">
                            <label><b>Received Date</b></label>
                            <input type="date" class="my-input" id="ana_receivedDate" readonly>
                        </div>

                        <div class="my-col-4">
                            <label><b>Process</b></label>
                            <input type="text" class="my-input" id="ana_process" readonly>
                        </div>

                        <div class="my-col-4">
                            <label><b>Initial Exception Grade</b></label>
                            <input type="text" class="my-input" id="ana_initGrade" readonly>
                        </div>
                    </div>

                    <div class="my-row">
                        <div class="my-col-12">
                            <label><b>Infinity Condition</b></label>
                            <textarea class="my-textarea" id="ana_infCondition" readonly></textarea>
                        </div>
                    </div>

                    <div class="my-row">
                        <div class="my-col-12">
                            <label><b>Clients Rebuttal</b></label>
                            <textarea class="my-textarea" id="ana_rebuttal"></textarea>
                        </div>
                    </div>

                    <div class="section-title-line">
                        <i class="uil uil-pen"></i>
                        <span>Infinity Response</span>
                    </div>
                    <div class="card-blue card-outline" style="padding-bottom: 1%;"></div>

                    <div class="my-row">
                        <div class="my-col-4">
                            <label><b>Reviewed Date</b></label>
                            <input type="date" class="my-input" id="ana_reviewDate">
                        </div>

                        <div class="my-col-4">
                            <label><b>Resolved</b></label>
                            <select class="my-select" id="ana_resolved">
                                <option value="">Select</option>
                                <option value="Yes">Yes</option>
                                <option value="No">No</option>
                            </select>
                        </div>

                        <div class="my-col-4">
                            <label><b>Final Exception Grade</b></label>
                            <select class="my-select" id="ana_finalGrade">
                                <option value="">Select</option>
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="4">4</option>
                            </select>
                        </div>
                    </div>

                    <div class="my-row">
                        <div class="my-col-12">
                            <label><b>Comment</b></label>
                            <textarea class="my-textarea" id="ana_response"></textarea>
                        </div>
                    </div>
                </div>

                <div class="modal-footer bg-white justify-content-between">
                    <button type="button" class="btn btn-outline-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="my-btn success" onclick="return ana_endAnalysis();">End Analysis</button>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

