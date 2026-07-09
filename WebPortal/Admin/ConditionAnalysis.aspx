<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ConditionAnalysis.aspx.cs" Inherits="WebPortal.Admin.ConditionAnalysis" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        :root {
            --ca-primary: #1d4ed8;
            --ca-primary-2: #2563eb;
            --ca-accent: #22c1dc;
            --ca-dark: #0f172a;
            --ca-muted: #64748b;
            --ca-border: #dbeafe;
            --ca-soft: #f8fbff;
            --ca-card: #ffffff;
            --ca-success: #16a34a;
        }

        .loading {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            opacity: .95;
            border-radius: 24px;
            width: 190px;
            min-height: 190px;
            z-index: 99999;
            background: rgba(255,255,255,.94);
            box-shadow: 0 22px 55px rgba(15,23,42,.22);
            text-align: center;
            padding: 28px 18px;
            backdrop-filter: blur(8px);
        }

        .loading img {
            width: 72px;
            height: 72px;
            object-fit: contain;
        }

        .loading div {
            margin-top: 14px;
            font-size: 13px !important;
            font-weight: 700 !important;
            color: var(--ca-dark);
        }

        .ca-page {
            background: #f3f7fb;
            min-height: calc(100vh - 80px);
        }

        .ca-hero {
            position: relative;
            overflow: hidden;
            border-radius: 22px;
            padding: 22px 26px;
            margin-bottom: 18px;
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 62%, #22c1dc 100%);
            box-shadow: 0 18px 45px rgba(37,99,235,.25);
        }

        .ca-hero:before,
        .ca-hero:after {
            content: "";
            position: absolute;
            border-radius: 50%;
            background: rgba(255,255,255,.15);
            pointer-events: none;
        }

        .ca-hero:before {
            width: 170px;
            height: 170px;
            top: -85px;
            right: 70px;
        }

        .ca-hero:after {
            width: 240px;
            height: 240px;
            bottom: -150px;
            right: -65px;
        }

        .ca-hero-inner {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            flex-wrap: wrap;
        }

        .ca-title-wrap {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .ca-icon-box {
            width: 58px;
            height: 58px;
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.2);
            border: 1px solid rgba(255,255,255,.3);
            box-shadow: inset 0 1px 0 rgba(255,255,255,.35);
            font-size: 26px;
        }

        .ca-hero h4 {
            margin: 0;
            font-size: 22px;
            font-weight: 800;
            letter-spacing: .2px;
        }

        .ca-hero p {
            margin: 4px 0 0;
            opacity: .92;
            font-size: 13px;
            font-weight: 500;
        }

        .ca-chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 14px;
            border-radius: 999px;
            background: rgba(255,255,255,.17);
            border: 1px solid rgba(255,255,255,.26);
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
        }

        .ca-card {
            background: var(--ca-card);
            border-radius: 20px;
            border: 1px solid rgba(219,234,254,.9);
            box-shadow: 0 14px 35px rgba(15,23,42,.08);
            overflow: hidden;
        }

        .ca-card-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 16px 18px;
            border-bottom: 1px solid #eaf1fb;
            background: linear-gradient(180deg, #fff 0%, #f8fbff 100%);
            flex-wrap: wrap;
        }

        .ca-card-title {
            display: flex;
            align-items: center;
            gap: 10px;
            color: var(--ca-dark);
            font-weight: 800;
            font-size: 15px;
        }

        .ca-card-title i {
            width: 34px;
            height: 34px;
            border-radius: 12px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: #e0f2fe;
            color: var(--ca-primary);
        }

        .ca-card-body {
            padding: 16px;
        }

        #table_conAnalysis_wrapper,
        #table_conAnalysis {
            width: 100% !important;
        }

        .table.dataTable {
            border-collapse: separate !important;
            border-spacing: 0;
            overflow: hidden;
            border-radius: 14px;
        }

        .table.dataTable th {
            white-space: nowrap;
            color: #0f172a;
            background: #edf3f6 !important;
            height: 42px;
            vertical-align: middle;
            font-size: 12px;
            text-align: center;
        }

        .table.dataTable tr td {
            background: #fff !important;
            vertical-align: middle;
            font-size: 12px;
        }

        .table.dataTable tbody tr:hover td {
            background: #f8fbff !important;
        }

        .dataTables_scrollBody {
            min-height: 120px !important;
            height: auto;
            border-bottom: 0 !important;
        }

        .dataTables_length, .dataTables_info {
            float: left !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 16px;
            float: left;
        }

        .buttons-excel, .buttons-html5 {
            color: #fff !important;
            box-shadow: 0 8px 18px rgba(37,99,235,.20);
            background: linear-gradient(120deg, #1d4ed8, #22c1dc) !important;
            border: 0 !important;
            font-weight: 700;
            margin: 0 8px;
            border-radius: 10px !important;
            padding: 7px 14px !important;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: 600 !important;
            border: none !important;
            color: #334155;
        }

        .swal2-container {
            z-index: 200000 !important;
        }

        .custom-modal {
            display: none;
            position: fixed;
            z-index: 9999;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow-y: auto;
            padding: 24px 12px;
            background: rgba(15, 23, 42, .62);
            backdrop-filter: blur(5px);
        }

        .custom-modal-content {
            background: #fff;
            margin: 24px auto;
            width: min(1120px, 96%);
            border-radius: 22px;
            box-shadow: 0 28px 70px rgba(15,23,42,.36);
            overflow: hidden;
            animation: caModalIn .25s ease-out;
        }

        @keyframes caModalIn {
            from { opacity: 0; transform: translateY(18px) scale(.98); }
            to { opacity: 1; transform: translateY(0) scale(1); }
        }

        .custom-modal-header {
            padding: 16px 20px;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%) !important;
            color: white;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
        }

        .custom-modal-header h5 {
            margin: 0;
            font-size: 18px;
            font-weight: 800;
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .custom-modal-header h5:before {
            content: "\f15c";
            font-family: "Font Awesome 5 Free";
            font-weight: 900;
            width: 38px;
            height: 38px;
            border-radius: 13px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.18);
            border: 1px solid rgba(255,255,255,.24);
        }

        #ana_popupheader {
            font-weight: 600 !important;
            font-size: 15px !important;
            opacity: .95;
        }

        .custom-modal-header .close {
            opacity: 1;
            color: #fff !important;
            text-shadow: none;
            width: 38px;
            height: 38px;
            border-radius: 12px;
            background: rgba(255,255,255,.16);
            border: 1px solid rgba(255,255,255,.24);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 0;
        }

        .custom-modal-body {
            padding: 20px;
            background: #f8fbff;
        }

        .analysiscon-container {
            width: 100%;
        }

        .ca-form-section {
            background: #fff;
            border: 1px solid #e5efff;
            border-radius: 18px;
            padding: 18px;
            margin-bottom: 16px;
            box-shadow: 0 10px 25px rgba(15,23,42,.05);
        }

        .section-title-line {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 15px;
            font-weight: 800;
            margin: 0 0 14px;
            color: #0f172a;
        }

        .section-title-line i {
            width: 34px;
            height: 34px;
            border-radius: 12px;
            background: #e0f2fe;
            color: var(--ca-primary);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
        }

        .my-row {
            display: flex;
            flex-wrap: wrap;
            margin: 0 -8px;
        }

        .my-col-3,
        .my-col-4,
        .my-col-6,
        .my-col-12 {
            padding: 0 8px 14px;
        }

        .my-col-3 { flex: 0 0 25%; max-width: 25%; }
        .my-col-4 { flex: 0 0 33.333%; max-width: 33.333%; }
        .my-col-6 { flex: 0 0 50%; max-width: 50%; }
        .my-col-12 { flex: 0 0 100%; max-width: 100%; }

        .field-card label {
            margin-bottom: 6px;
            font-size: 12px;
            font-weight: 800 !important;
            color: #334155;
        }

        .my-input,
        .my-select,
        .my-textarea {
            width: 100%;
            border: 1px solid #dbeafe;
            background: #f8fbff;
            color: #0f172a;
            border-radius: 12px;
            font-size: 13px;
            transition: .2s ease;
            box-shadow: inset 0 1px 0 rgba(255,255,255,.75);
        }

        .my-input,
        .my-select {
            height: 42px;
            padding: 8px 12px;
        }

        .my-textarea {
            min-height: 92px;
            padding: 10px 12px;
            resize: vertical;
        }

        .my-input[readonly],
        .my-textarea[readonly] {
            background: #eef6ff;
            color: #475569;
        }

        .my-input:focus,
        .my-select:focus,
        .my-textarea:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37,99,235,.12);
            background: #fff;
            outline: none;
        }

        .ca-actions {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 12px;
            padding-top: 4px;
        }

        .my-btn {
            border: none;
            border-radius: 12px;
            color: white;
            margin-right: 0;
            padding: 11px 22px;
            font-weight: 800;
            letter-spacing: .2px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 12px 24px rgba(22,163,74,.20);
            transition: .2s ease;
        }

        .my-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 16px 28px rgba(22,163,74,.28);
        }

        .primary {
            background: #475569;
        }

        .success {
            background: linear-gradient(120deg, #16a34a, #22c55e);
        }

        @media (max-width: 991px) {
            .my-col-3,
            .my-col-4,
            .my-col-6 {
                flex: 0 0 50%;
                max-width: 50%;
            }
        }

        @media (max-width: 575px) {
            .ca-page {
                padding: 10px 8px 20px;
            }

            .ca-hero {
                padding: 18px;
                border-radius: 18px;
            }

            .ca-title-wrap {
                align-items: flex-start;
            }

            .ca-hero h4 {
                font-size: 18px;
            }

            .ca-icon-box {
                width: 48px;
                height: 48px;
                font-size: 22px;
            }

            .custom-modal-content {
                width: 100%;
                margin: 0 auto;
                border-radius: 18px;
            }

            .custom-modal-body {
                padding: 14px;
            }

            .my-col-3,
            .my-col-4,
            .my-col-6,
            .my-col-12 {
                flex: 0 0 100%;
                max-width: 100%;
            }

            div.dt-buttons {
                padding-left: 0;
                margin-top: 8px;
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            condAnalysis_bindGrid();
        });
    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="loading" id="usload1">
        <img src="../images/Load_1.gif" />
        <div>One moment, please . . . .</div>
    </div>

    <div class="ca-page">
        <div class="ca-hero">
            <div class="ca-hero-inner">
                <div class="ca-title-wrap">
                    <div class="ca-icon-box">
                        <i class="fas fa-clipboard-check"></i>
                    </div>
                    <div>
                        <h4>Condition Analysis</h4>
                        <p>Review condition exceptions, capture rebuttal details and finalize Infinity response.</p>
                    </div>
                </div>
                <div class="ca-chip">
                    <i class="fas fa-layer-group"></i>
                    Analysis Queue
                </div>
            </div>
        </div>

        <div class="ca-card">
            <div class="ca-card-head">
                <div class="ca-card-title">
                    <i class="fas fa-table"></i>
                    <span>Condition Analysis Details</span>
                </div>
            </div>
            <div class="ca-card-body">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover" style="width: 100%;" id="table_conAnalysis">
                        <thead></thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div id="popUp_addResponse" class="custom-modal">
        <div class="custom-modal-content">

            <div class="custom-modal-header">
                <h5>Analysis Condition Of : <span id="ana_popupheader"></span></h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="color: white;">
                    <span aria-hidden="true" onclick="closeAnalysisModal()">&times;</span>
                </button>
            </div>

            <div class="custom-modal-body">
                <div class="analysiscon-container">

                    <div class="ca-form-section">
                        <div class="section-title-line">
                            <i class="fas fa-info-circle"></i>
                            <span>Condition Information</span>
                        </div>

                        <div class="my-row">
                            <div class="my-col-4 field-card">
                                <label for="ana_receivedDate">Received Date</label>
                                <input type="date" class="my-input" id="ana_receivedDate" readonly>
                            </div>

                            <div class="my-col-4 field-card">
                                <label for="ana_process">Process</label>
                                <input type="text" class="my-input" id="ana_process" readonly>
                            </div>

                            <div class="my-col-4 field-card">
                                <label for="ana_initGrade">Initial Exception Grade</label>
                                <input type="text" class="my-input" id="ana_initGrade" readonly>
                            </div>
                        </div>

                        <div class="my-row">
                            <div class="my-col-12 field-card">
                                <label for="ana_infCondition">Infinity Condition</label>
                                <textarea class="my-textarea" id="ana_infCondition" readonly></textarea>
                            </div>
                        </div>

                        <div class="my-row">
                            <div class="my-col-12 field-card">
                                <label for="ana_rebuttal">Clients Rebuttal</label>
                                <textarea class="my-textarea" id="ana_rebuttal"></textarea>
                            </div>
                        </div>
                    </div>

                    <div class="ca-form-section">
                        <div class="section-title-line">
                            <i class="fas fa-pen-nib"></i>
                            <span>Infinity Response</span>
                        </div>

                        <div class="my-row">
                            <div class="my-col-4 field-card">
                                <label for="ana_reviewDate">Reviewed Date</label>
                                <input type="date" class="my-input" id="ana_reviewDate">
                            </div>

                            <div class="my-col-4 field-card">
                                <label for="ana_resolved">Resolved</label>
                                <select class="my-select" id="ana_resolved">
                                    <option value="">Select</option>
                                    <option value="Yes">Yes</option>
                                    <option value="No">No</option>
                                </select>
                            </div>

                            <div class="my-col-4 field-card">
                                <label for="ana_finalGrade">Final Exception Grade</label>
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
                            <div class="my-col-12 field-card">
                                <label for="ana_response">Comment</label>
                                <textarea class="my-textarea" id="ana_response"></textarea>
                            </div>
                        </div>

                        <div class="ca-actions">
                            <button type="button" class="my-btn success" onclick="return ana_endAnalysis();">
                                <i class="fas fa-check-circle"></i>
                                <span>End Analysis</span>
                            </button>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>

</asp:Content>

<%--<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        .loading {
            display: none;
            position: fixed;
            top: 350px;
            left: 50%;
            margin-top: -96px;
            margin-left: -96px;
            opacity: .85;
            border-radius: 25px;
            width: 192px;
            height: 192px;
            z-index: 99999;
        }

        .dataTables_scrollBody {
            min-height: 100px !important;
            height: auto;
        }

        .dataTables_length, .dataTables_info {
            float: left !important;
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
            box-shadow: none;
            background: linear-gradient(to right, #ffbf96, #fe7096);
            border: 0;
            font-weight: bold;
            margin: 0px 10px;
        }

        .table.dataTable th {
            white-space: nowrap;
            color: #000;
        }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
        }

        #table_conAnalysis_wrapper {
            width: 100% !important;
        }

        #table_conAnalysis {
            width: 100% !important;
        }

        .swal2-container {
            z-index: 200000 !important;
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
    <div class="loading" id="usload1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Condition Analysis</b></h6>
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
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
                <h5>Analysis Condition Of :<span id="ana_popupheader" style="font-weight: normal; font-size: 18px!important;"></span></h5>
             <%--   <span class="close-btn" onclick="closeAnalysisModal()">&times;</span>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="color: white;">
                    <span aria-hidden="true" onclick="closeAnalysisModal()">&times;</span>
                </button>
            </div>

            <div class="custom-modal-body">
                <div class="analysiscon-container">
                    <!-- Row -->
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

                    <!-- Infinity Condition -->
                    <div class="my-row">
                        <div class="my-col-12">
                            <label><b>Infinity Condition</b></label>
                            <textarea class="my-textarea" id="ana_infCondition" readonly></textarea>
                        </div>
                    </div>

                    <!-- Clients Rebuttal -->
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

                    <!-- Row -->
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
                        <%--</div>

  <!-- Total Time -->
  <div class="my-row">--%>
                        <%-- <div class="my-col-3">
          <label><b>Total Time (in Mins)</b></label>
          <input type="time" class="my-input" id="ana_totaltime" step="60">
      </div>
                    </div>

                    <!-- Infinity Response -->
                    <div class="my-row">
                        <div class="my-col-12">
                            <label><b>Comment</b></label>
                            <textarea class="my-textarea" id="ana_response"></textarea>
                        </div>
                    </div>

                    <!-- Buttons -->
                    <div class="my-row">
                        <div class="my-col-12" style="text-align: right;">
                            <button type="button" class="my-btn success" onclick="return ana_endAnalysis();">End Analysis</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style>
        /* Modal Background */
        .custom-modal {
            display: none;
            position: fixed;
            z-index: 9999;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.4);
        }

        /* Modal Box */
        .custom-modal-content {
            background-color: #fff;
            margin: 5% auto;
            width: 70%;
            border-radius: 6px;
            box-shadow: 0 0 10px rgba(0,0,0,0.3);
        }

        /* Header */
        .custom-modal-header {
            padding: 10px;
            /* background: #e9e9e9;*/
            background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;
            font-weight: bold;
            display: flex;
            font-size: 16px;
            color: white;
            justify-content: space-between;
        }

        /* Body */
        .custom-modal-body {
            padding: 15px;
            padding-left: 3%;
        }

        .label {
            font-weight: bold;
        }

        /* Close Button */
        .close-btn {
            cursor: pointer;
            font-size: 20px;
        }

        /* Grid Layout */
        .my-row {
            display: flex;
            flex-wrap: wrap;
            margin-bottom: 10px;
        }

        .my-col-3 {
            width: 25%;
            padding-right: 15px;
        }

        .my-col-4 {
            width: 33%;
            padding-right: 15px;
        }

        .my-col-6 {
            width: 50%;
            padding-right: 15px;
        }

        .my-col-12 {
            width: 98%;
        }

        /* Inputs */
        .my-input, .my-select {
            width: 100%;
            height: 30px;
            border: 1px solid #cfcfcf;
            padding: 4px;
            border-radius: 3px;
            font-size: 12px;
        }

        .my-textarea {
            width: 100%;
            height: 60px;
            border: 1px solid #cfcfcf;
            padding: 5px;
            border-radius: 3px;
            resize: none;
        }

            .my-input:focus, .my-select:focus, .my-textarea:focus {
                border-color: #b5d3ff;
                box-shadow: 0 0 3px rgba(181,211,255,0.7);
                outline: none;
            }

        /* Buttons */
        .my-btn {
            padding: 6px 18px;
            border: none;
            border-radius: 4px;
            color: white;
            margin-right: 10px;
        }

        .primary {
            background: #6c757d;
        }

        .success {
            background: #5cb85c;
        }
    </style>

    <style>
        .section-title-line {
            display: flex;
            align-items: center;
            font-size: 14px;
            font-weight: 600;
            margin: 18px 5px 10px 5px;
            color: #2c2c2c;
        }

            .section-title-line i {
                margin-right: 8px;
                font-size: 15px;
            }
    </style>

</asp:Content>--%>
