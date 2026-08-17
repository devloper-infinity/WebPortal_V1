<%@ Page Title="" Language="C#" MasterPageFile="~/US/USAdmin.Master" AutoEventWireup="true" CodeBehind="AddFeedback.aspx.cs" Inherits="WebPortal.US.AddFeedback" %>

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

        .feedback-page {
            width: 100%;
            padding: 0 15px 24px;
            background: var(--ca-bg);
            min-height: calc(100vh - 80px);
        }

        .feedback-hero {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            padding: 22px 24px;
            margin: 0 0 18px;
            color: #fff;
            background: linear-gradient(135deg, #2563eb 0%, #7c3aed 100%);
            border-radius: var(--ca-radius-lg);
            box-shadow: var(--ca-shadow);
            overflow: hidden;
            position: relative;
        }

            .feedback-hero:after {
                content: "";
                position: absolute;
                right: -64px;
                top: -64px;
                width: 190px;
                height: 190px;
                border-radius: 999px;
                background: rgba(255, 255, 255, .15);
            }

        .feedback-title-wrap {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .feedback-title-icon {
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

        .feedback-title {
            margin: 0;
            font-size: 24px;
            line-height: 1.2;
            font-weight: 800;
            letter-spacing: -.02em;
        }

        .feedback-subtitle {
            margin: 4px 0 0;
            color: rgba(255, 255, 255, .82);
            font-size: 13px;
        }

        .feedback-back {
            position: relative;
            z-index: 1;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 14px;
            border-radius: 999px;
            color: #fff !important;
            background: rgba(255, 255, 255, .16);
            border: 1px solid rgba(255, 255, 255, .24);
            font-weight: 700;
            font-size: 13px;
            text-decoration: none !important;
            transition: all .2s ease;
        }

            .feedback-back:hover {
                background: rgba(255, 255, 255, .26);
                transform: translateY(-1px);
            }

        .feedback-card {
            width: 100%;
            margin-bottom: 18px;
            border: 1px solid var(--ca-border);
            border-radius: var(--ca-radius-lg);
            background: var(--ca-surface);
            box-shadow: 0 14px 35px rgba(15, 23, 42, .07);
            overflow: hidden;
        }

        .feedback-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 18px 20px;
            border-bottom: 1px solid var(--ca-border);
            background: linear-gradient(180deg, #fff 0%, #f8fafc 100%);
        }

        .feedback-card-title {
            margin: 0;
            font-size: 16px;
            font-weight: 750;
            color: var(--ca-text);
        }

        .feedback-card-hint {
            margin: 3px 0 0;
            color: var(--ca-muted);
            font-size: 12px;
        }

        .feedback-card-body {
            padding: 20px;
        }

        .feedback-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(220px, 1fr));
            gap: 16px;
        }

        .feedback-field.full {
            grid-column: 1 / -1;
        }

        .feedback-field label {
            display: block;
            margin-bottom: 7px;
            font-size: 13px;
            font-weight: 700 !important;
            color: #374151;
        }

        .feedback-field .form-control,
        .feedback-field select,
        .feedback-field textarea {
            width: 100% !important;
            min-height: 42px;
            border: 1px solid var(--ca-border);
            border-radius: var(--ca-radius-md);
            background: #fff;
            color: var(--ca-text);
            font-size: 14px;
            box-shadow: none;
            transition: all .18s ease;
        }

        .feedback-field textarea {
            min-height: 94px;
            resize: vertical;
        }

            .feedback-field .form-control:focus,
            .feedback-field select:focus,
            .feedback-field textarea:focus {
                border-color: var(--ca-primary);
                box-shadow: 0 0 0 4px var(--ca-ring);
                outline: none;
            }

        .feedback-field .form-control:disabled {
            background: #f9fafb;
            color: #4b5563;
            cursor: not-allowed;
        }

        .feedback-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            flex-wrap: wrap;
            margin-top: 18px;
            padding-top: 16px;
            border-top: 1px solid var(--ca-border);
        }

        #btnAddFeedback,
        #btnCompleteLoan,
        .btn.btn-primary {
            min-width: 110px;
            padding: 10px 18px;
            border: 0;
            border-radius: 999px;
            background: linear-gradient(135deg, var(--ca-primary), var(--ca-primary-dark));
            color: #fff;
            font-weight: 800;
            box-shadow: 0 10px 22px rgba(37, 99, 235, .24);
            transition: all .2s ease;
        }

            #btnAddFeedback:hover,
            #btnCompleteLoan:hover,
            .btn.btn-primary:hover {
                transform: translateY(-1px);
                box-shadow: 0 14px 28px rgba(37, 99, 235, .30);
            }

        .feedback-table-wrap {
            width: 100%;
            overflow: auto;
            border: 1px solid var(--ca-border);
            border-radius: var(--ca-radius-lg);
            background: #fff;
        }

        #table_usfeedback {
            margin: 0 !important;
            width: 100% !important;
        }

            #table_usfeedback thead th,
            .table.dataTable th {
                white-space: nowrap;
                border: 0 !important;
                /*    padding: 13px 14px !important;*/
                /*   background: linear-gradient(135deg, #2563eb, #1d4ed8) !important;*/
                /* color: #fff !important;*/
                font-size: 13px;
                font-weight: 800;
                border-bottom-color: black;
            }

            #table_usfeedback tbody td,
            .table.dataTable tr td {
                padding: 12px 14px !important;
                border-top: 1px solid var(--ca-border) !important;
                background-color: #fff !important;
                color: #374151;
                vertical-align: middle;
            }

            #table_usfeedback tbody tr:hover td {
                background-color: var(--ca-primary-soft) !important;
            }

        .dataTables_wrapper {
            padding: 0;
        }

        .dataTables_length,
        .dataTables_info {
            float: left !important;
            color: var(--ca-muted);
            font-size: 13px;
            padding: 10px 0;
        }

        div.dt-buttons {
            position: static;
            padding-left: 12px;
            float: left;
        }

        .buttons-excel,
        .buttons-html5 {
            color: #fff !important;
            box-shadow: 0 10px 20px rgba(22, 163, 74, .18);
            background: linear-gradient(135deg, var(--ca-success), var(--ca-success-dark)) !important;
            border: 0 !important;
            border-radius: 999px !important;
            font-weight: 800 !important;
            margin: 0 8px;
            padding: 8px 14px !important;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: 700 !important;
            border: none !important;
        }

        @media (max-width: 991px) {
            .feedback-grid {
                grid-template-columns: repeat(2, minmax(220px, 1fr));
            }
        }

        @media (max-width: 767px) {
            .feedback-page {
                padding: 0 10px 18px;
            }

            .feedback-hero {
                flex-direction: column;
                align-items: flex-start;
                padding: 20px;
            }

            .feedback-grid {
                grid-template-columns: 1fr;
            }

            .feedback-actions {
                justify-content: stretch;
            }

            #btnAddFeedback,
            #btnCompleteLoan {
                width: 100%;
            }
        }

        .feedback-row-action {
            width: 32px;
            height: 32px;
            padding: 0;
            margin: 0 2px;
            border: 0;
            border-radius: 6px;
            color: #fff;
            cursor: pointer;
        }

            .feedback-row-action.edit {
                background: #2f80ed;
            }

            .feedback-row-action.delete {
                background: #dc3545;
            }
    </style>

    <script>

        $(document).ready(function () {

            const urlParams = new URLSearchParams(window.location.search);
            const ProcessID = urlParams.get('ProcessID');

            BindInfinityFeedback_US(ProcessID);
        });

    </script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <input id="filep_ap" style="display: none;" />
    <div class="loading" id="load1">
        <div>
            <img src="../images/Load_1.gif" />
            <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
        </div>
    </div>

    <div class="feedback-page">
        <div class="feedback-hero">
            <div class="feedback-title-wrap">
                <div class="feedback-title-icon">
                    <i class="fas fa-copy"></i>
                </div>
                <div>
                    <h4 class="feedback-title">Add Feedback</h4>
                    <p class="feedback-subtitle">Review loan details, add severity, and capture feedback findings.</p>
                </div>
            </div>
            <a href="LoanDetails.aspx" class="feedback-back">
                <i class="fas fa-arrow-left"></i>
                Go back
            </a>
        </div>

        <div class="feedback-card">
            <div class="feedback-card-header">
                <div>
                    <h5 class="feedback-card-title">Feedback Details</h5>
                    <p class="feedback-card-hint">Fields marked from loan details are read-only.</p>
                </div>
            </div>
            <div class="feedback-card-body">
                <div class="feedback-grid">
                    <input type="hidden" id="USLoanDetails_Task" />
                    <div id="standardSeverityField" class="feedback-field">
                        <label for="USLoanDetails_LoanNo">Loan #</label>
                        <input type="text" id="USLoanDetails_LoanNo" name="USLoanDetails_LoanNo" class="form-control" disabled="disabled" />
                    </div>

                    <div class="feedback-field">
                        <label for="USLoanDetails_Client">Client</label>
                        <input type="text" id="USLoanDetails_Client" name="USLoanDetails_Client" class="form-control" disabled="disabled" />
                    </div>

                    <div class="feedback-field">
                        <label for="USLoanDetails_UWName">UW Name</label>
                        <input type="text" id="USLoanDetails_UWName" name="USLoanDetails_UWName" class="form-control" disabled="disabled" />
                    </div>

                    <div class="feedback-field">
                        <label for="USLoanDetails_DateReviewed">Date Reviewed</label>
                        <input type="text" id="USLoanDetails_DateReviewed" name="USLoanDetails_DateReviewed" class="form-control" disabled="disabled" />
                    </div>

                    <div class="feedback-field">
                        <label for="USLoanDetails_QcDate">QC Date</label>
                        <input type="text" id="USLoanDetails_QcDate" name="USLoanDetails_QcDate" class="form-control" disabled="disabled" />
                    </div>

                    <div class="feedback-field">
                        <label for="USLoanDetails_Severity">Severity</label>
                        <select id="USLoanDetails_Severity" name="USLoanDetails_Severity" class="form-control" required="required" aria-required="true" onchange="return syncAddFeedbackFindingRequirement();">
                            <option value="">Select</option>
                            <option value="Critical">Critical</option>
                            <option value="Non-Critical">Non-Critical</option>
                            <option value="No Error">No Error</option>
                        </select>
                    </div>

                    <div id="standardFindingField" class="feedback-field full">
                        <label for="USLoanDetails_Finding">Finding</label>
                        <textarea id="USLoanDetails_Finding" name="USLoanDetails_Finding" class="form-control"></textarea>
                    </div>
                    <div id="collectionCommentsFields" class="feedback-field full" style="display:none">
                        <div class="feedback-grid">
                            <div class="feedback-field">
                                <label for="USLoanDetails_DataField">Data Field</label>
                                <select id="USLoanDetails_DataField" class="form-control" onchange="return syncCollectionCommentsFeedback();"><option value="">Select</option></select>
                            </div>
                            <div class="feedback-field">
                                <label for="USLoanDetails_IsError">Is Error</label>
                                <select id="USLoanDetails_IsError" class="form-control"><option value="">Select</option><option value="Yes">Yes</option><option value="No">No</option></select>
                            </div>
                            <div class="feedback-field full">
                                <label for="USLoanDetails_CollectionFinding">Finding</label>
                                <textarea id="USLoanDetails_CollectionFinding" class="form-control" rows="4"></textarea>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="feedback-actions">
                    <input type="hidden" id="USFeedback_EditId" value="0" />
                    <button class="btn btn-primary" type="button" id="btnAddFeedback" onclick="return OnClickAddFeedback();">
                        <i class="fas fa-plus"></i>&nbsp; Add Feedback
                    </button>
                    <button class="btn btn-secondary" type="button" id="btnCancelEdit" style="display: none;" onclick="return CancelFeedbackEdit();">
                        <i class="fas fa-times"></i>&nbsp; Cancel Edit
                    </button>
                    <button class="btn btn-primary" type="button" id="btnCompleteLoan" onclick="return OnClickCompleteLoan();">
                        <i class="fas fa-check"></i>&nbsp; Complete Loan
                    </button>
                </div>
            </div>
        </div>

        <div class="feedback-card">
            <div class="feedback-card-header">
                <div>
                    <h5 class="feedback-card-title">Feedback History</h5>
                    <p class="feedback-card-hint">Previously added feedback records for this loan.</p>
                </div>
            </div>
            <div class="feedback-card-body">
                <div class="feedback-table-wrap">
                    <table class="table" id="table_usfeedback" style="padding-top: 10px; width: 100%!important;">
                        <thead>
                            <tr>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Actions</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Loan #</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Severity</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Findings</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Data Field</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Is Error</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; display: none;">Added By Name</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; display: none;">Added Date</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
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
            background: linear-gradient(to bottom, #cbd0dd, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
        }
    </style>

    <script>

        $(document).ready(function () {

            const urlParams = new URLSearchParams(window.location.search);
            const ProcessID = urlParams.get('ProcessID');

            BindInfinityFeedback_US(ProcessID);
        });

    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <input id="filep_ap" style="display: none;" />
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Add Feedback</b></h6>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right" style="font-size: 12px; font-weight: bold;">
                        <li class="breadcrumb-item"><a href="LoanDetails.aspx" style="color: saddlebrown"><< Go back </a></li>

                    </ol>
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <table class="table table-responsive">
                    <tr>
                        <td><b>Loan # :</b></td>
                        <td>
                            <input type="text" id="USLoanDetails_LoanNo" name="USLoanDetails_LoanNo" class="form-control" style="width: 250px;" disabled="disabled" />
                        </td>
                        <td><b>Client :</b></td>
                        <td>
                            <input type="text" id="USLoanDetails_Client" name="USLoanDetails_Client" class="form-control" style="width: 250px;" disabled="disabled" />
                        </td>
                        <td><b>UW Name:</b></td>
                        <td>
                            <input type="text" id="USLoanDetails_UWName" name="USLoanDetails_UWName" class="form-control" style="width: 250px;" disabled="disabled" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Date Reviewed:</b></td>
                        <td>
                            <input type="text" id="USLoanDetails_DateReviewed" name="USLoanDetails_DateReviewed" class="form-control" style="width: 250px;" disabled="disabled" />
                        </td>

                        <td><b>QC Date :</b></td>
                        <td>
                            <input type="text" id="USLoanDetails_QcDate" name="USLoanDetails_QcDate" class="form-control" style="width: 250px;" disabled="disabled" />
                        </td>
                        <td>
                            <b>Severity :</b>
                        </td>
                        <td>
                            <select id="USLoanDetails_Severity" name="USLoanDetails_Severity" class="form-control" style="width: 250px;">
                                <option value="">Select</option>
                                <option value="Critical">Critical</option>
                                <option value="Non-Critical">Non-Critical</option>
                                <option value="No Error">No Error</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <b>Finding :</b>
                        </td>
                        <td colspan="3">
                            <textarea type="text" id="USLoanDetails_Finding" name="USLoanDetails_Finding" class="form-control" style="width: 670px;"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td style="text-align: center;">
                            <button class="btn btn-primary" type="button" id="btnAddFeedback" onclick="return OnClickAddFeedback();">Add</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <table class="table" id="table_usfeedback" style="padding-top: 10px; width: 100%!important;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Loan #</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Severity</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Findings</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; display:none;">Added By Name</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; display:none;">Added Date</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

</asp:Content>--%>
