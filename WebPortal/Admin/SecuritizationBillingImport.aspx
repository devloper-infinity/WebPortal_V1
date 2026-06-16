<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="SecuritizationBillingImport.aspx.cs" Inherits="WebPortal.Admin.SecuritizationBillingImport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="../Scripts/Functions/SecuritizationBillingImport.js"></script>

    <style>
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
            box-shadow: 0 14px 28px rgba(28, 58, 85, 0.16);
            color: #fff;
            display: flex;
            gap: 20px;
            justify-content: space-between;
            margin-bottom: 18px;
            padding: 22px 24px;
        }

        .sec-kicker {
            color: rgba(255,255,255,0.82);
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
            color: rgba(255,255,255,0.88);
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

            .sec-btn-primary:hover,
            .sec-btn-primary:focus {
                background: #0b5f59;
                border-color: #0b5f59;
                color: #fff;
            }

        .sec-btn-light {
            background: rgba(255,255,255,0.96);
            border: 1px solid rgba(255,255,255,0.96);
            color: #17324d;
        }

        .sec-btn-soft {
            background: #eef6f5;
            border: 1px solid #cce3df;
            color: #0f5f58;
        }

        .sec-btn-outline {
            background: #fff;
            border: 1px solid #cbd6df;
            color: #263747;
        }

        .sec-btn-danger {
            background: #fff5f5;
            border: 1px solid #f4c7c7;
            color: #b42318;
        }

        .sec-panel {
            background: #fff;
            border: 1px solid #dce5ec;
            border-radius: 8px;
            box-shadow: 0 10px 24px rgba(31, 51, 71, 0.06);
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
            display: grid;
            gap: 14px 16px;
            grid-template-columns: repeat(4, minmax(0, 1fr));
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

        .sec-field .form-control,
        .sec-field select,
        .sec-field textarea {
            border: 1px solid #cfdbe5;
            border-radius: 6px;
            box-shadow: none;
            color: #172737;
            font-size: 13px;
            min-height: 38px;
            width: 100%;
        }

            .sec-field .form-control:focus,
            .sec-field select:focus,
            .sec-field textarea:focus {
                border-color: #0f766e;
                box-shadow: 0 0 0 3px rgba(15, 118, 110, 0.14);
                outline: none;
            }

        .sec-required {
            color: #dc3545;
            margin-left: 2px;
        }

        .sec-file-preview {
            background: #f7fbfa;
            border: 1px dashed #bfd8d4;
            border-radius: 6px;
            color: #46596b;
            font-size: 12px;
            margin-top: 8px;
            padding: 8px 10px;
        }

        .sec-action-row {
            align-items: center;
            border-top: 1px solid #e7edf2;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 18px;
            padding-top: 16px;
        }

        .sec-status {
            color: #5c6f82;
            font-size: 12px;
            font-weight: 700;
            margin-right: auto;
        }

        .sec-status strong {
            color: #0f766e;
        }

        .sec-tabs {
            border-bottom: 1px solid #e7edf2;
            display: flex;
            gap: 8px;
            margin: 0;
            padding: 12px 18px 0;
        }

            .sec-tabs .nav-link {
                border: 1px solid transparent;
                border-radius: 8px 8px 0 0;
                color: #5c6f82;
                font-size: 13px;
                font-weight: 700;
                padding: 10px 14px;
            }

                .sec-tabs .nav-link.active {
                    background: #fff;
                    border-color: #dce5ec #dce5ec #fff;
                    color: #0f5f58;
                }

        .sec-table-toolbar {
            align-items: center;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: space-between;
        }

        .sec-table-wrap {
            overflow-x: auto;
            padding: 0 18px 18px;
        }

        .sec-deal-record-panel {
            margin-bottom: 12px;
        }

        .sec-deal-toggle {
            align-items: center;
            background: #fff;
            border: 0;
            color: #172737;
            display: flex;
            gap: 12px;
            justify-content: space-between;
            padding: 12px 18px;
            text-align: left;
            width: 100%;
        }

            .sec-deal-toggle:focus {
                outline: none;
            }

        .sec-deal-toggle-title {
            align-items: center;
            display: flex;
            gap: 9px;
            min-width: 0;
        }

            .sec-deal-toggle-title strong {
                color: #172737;
                display: block;
                font-size: 14px;
                line-height: 1.2;
            }

            .sec-deal-toggle-title span {
                color: #6d7f90;
                display: block;
                font-size: 12px;
                font-weight: 600;
                margin-top: 2px;
            }

        .sec-deal-toggle-meta {
            align-items: center;
            color: #0f5f58;
            display: inline-flex;
            flex-shrink: 0;
            font-size: 12px;
            font-weight: 800;
            gap: 8px;
        }

        .sec-deal-records-body {
            border-top: 1px solid #e7edf2;
            display: none;
            padding-top: 12px;
        }

            .sec-deal-records-body.is-open {
                display: block;
            }

            .sec-deal-records-body .sec-table-wrap {
                max-height: 210px;
                overflow: auto;
                padding: 0 14px 14px;
            }

            .sec-deal-records-body .dataTables_length,
            .sec-deal-records-body .dataTables_info {
                display: none;
            }

        #table_secBillImportDealRecs,
        #table_secBillImportNewLoanList,
        #table_secBillImportExistingLoanList {
            border-collapse: separate !important;
            border-spacing: 0;
            margin-top: 0 !important;
            min-width: 980px;
            width: 100% !important;
        }

        #table_secBillImportDealRecs_wrapper,
        #table_secBillImportNewLoanList_wrapper,
        #table_secBillImportExistingLoanList_wrapper,
        #table_secBillImportDealRecs_wrapper .dataTables_scroll,
        #table_secBillImportNewLoanList_wrapper .dataTables_scroll,
        #table_secBillImportExistingLoanList_wrapper .dataTables_scroll,
        #table_secBillImportDealRecs_wrapper .dataTables_scrollHead,
        #table_secBillImportNewLoanList_wrapper .dataTables_scrollHead,
        #table_secBillImportExistingLoanList_wrapper .dataTables_scrollHead,
        #table_secBillImportDealRecs_wrapper .dataTables_scrollBody,
        #table_secBillImportNewLoanList_wrapper .dataTables_scrollBody,
        #table_secBillImportExistingLoanList_wrapper .dataTables_scrollBody {
            width: 100% !important;
        }

        #table_secBillImportDealRecs_wrapper .dataTables_scrollHeadInner,
        #table_secBillImportNewLoanList_wrapper .dataTables_scrollHeadInner,
        #table_secBillImportExistingLoanList_wrapper .dataTables_scrollHeadInner {
            box-sizing: border-box;
            width: 100% !important;
        }

            #table_secBillImportDealRecs_wrapper .dataTables_scrollHeadInner table,
            #table_secBillImportNewLoanList_wrapper .dataTables_scrollHeadInner table,
            #table_secBillImportExistingLoanList_wrapper .dataTables_scrollHeadInner table,
            #table_secBillImportDealRecs_wrapper .dataTables_scrollBody table,
            #table_secBillImportNewLoanList_wrapper .dataTables_scrollBody table,
            #table_secBillImportExistingLoanList_wrapper .dataTables_scrollBody table {
                min-width: 980px;
                width: 100% !important;
            }

            #table_secBillImportDealRecs thead th,
            #table_secBillImportNewLoanList thead th,
            #table_secBillImportExistingLoanList thead th {
                background: #edf3f6 !important;
                border-color: #d7e2ea !important;
                color: #263747;
                font-size: 12px;
                text-align: center;
                vertical-align: middle;
                white-space: nowrap;
            }

            #table_secBillImportDealRecs tbody td,
            #table_secBillImportNewLoanList tbody td,
            #table_secBillImportExistingLoanList tbody td {
                background: #fff;
                border-color: #e2e9ef !important;
                color: #263747;
                font-size: 12px;
                vertical-align: middle;
            }

        .dataTables_wrapper .dataTables_info,
        .dataTables_wrapper .dataTables_paginate {
            color: #5c6f82;
            font-size: 12px;
            padding: 12px 0 0;
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

        .sec-message-icon {
            align-items: center;
            background: #eef6f5;
            border-radius: 8px;
            color: #0f766e;
            display: flex;
            font-size: 28px;
            height: 58px;
            justify-content: center;
            margin: 4px auto 14px;
            width: 58px;
        }

        @media (max-width: 1199px) {
            .sec-form-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 767px) {
            .sec-hero {
                align-items: flex-start;
                flex-direction: column;
            }

            .sec-hero-actions,
            .sec-action-row,
            .sec-table-toolbar {
                align-items: stretch;
                flex-direction: column;
                width: 100%;
            }

            .sec-status,
            .sec-btn {
                width: 100%;
            }

            .sec-form-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="secBillImport_fileName" style="display: none;" />
    <input id="secBillImport_BillingId" name="secBillImport_BillingId" type="hidden" value="0" />
    <label id="secBillImport_lblProjectId" name="secBillImport_lblProjectId" style="display: none"></label>
    <label id="secBillImport_lblClientDealName" name="secBillImport_lblClientDealName" style="display: none"></label>
    <label id="secBillImport_lblProjectName" name="secBillImport_lblProjectName" style="display: none"></label>

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" alt="Loading" />
        <div>One moment, please...</div>
    </div>

    <div class="sec-page">
        <div class="sec-hero">
            <div>
                <div class="sec-kicker">Operations</div>
                <h1 class="sec-title"><i class="fas fa-file-import mr-2"></i>Securitization Billing Import</h1>
                <p class="sec-subtitle">Generate the billing period first, then upload, review, and import the related loan list.</p>
            </div>
            <div class="sec-hero-actions">
                <a href="SecuritizationBilling.aspx" class="sec-btn sec-btn-light">
                    <i class="fas fa-arrow-left"></i>
                    Billing
                </a>
                <a href="../Formats/LoanList.xlsx" class="sec-btn sec-btn-light">
                    <i class="fas fa-download"></i>
                    Download Format
                </a>
            </div>
        </div>

        <div class="sec-panel">
            <div class="sec-panel-header">
                <div>
                    <h2 class="sec-panel-title"><i class="fas fa-plus-circle"></i>Billing And Import Details</h2>
                    <p class="sec-panel-subtitle">Upload will create the billing period using these details before reading the loan file.</p>
                </div>
                <button id="secBillImport_ClearForm" type="button" class="sec-btn sec-btn-outline">
                    <i class="fas fa-rotate-left"></i>
                    Clear
                </button>
            </div>
            <div class="sec-panel-body">
                <div class="sec-section-title"><i class="fas fa-briefcase"></i>Billing Details</div>
                <div class="sec-form-grid">
                    <div class="sec-field">
                        <label for="secBillImport_BillingType">Billing Type <span class="sec-required">*</span></label>
                        <select id="secBillImport_BillingType" name="secBillImport_BillingType" class="form-control">
                            <option value="Select">Select</option>
                            <option value="Reliance Letter">Reliance Letter</option>
                            <option value="Securitization">Securitization</option>
                        </select>
                    </div>
                    <div class="sec-field">
                        <label for="secBillImport_DealNo">Deal # <span class="sec-required">*</span></label>
                        <select id="secBillImport_DealNo" name="secBillImport_DealNo" class="form-control" onchange="return secBillImport_ChangeDealLoans(this);"></select>
                    </div>
                    <div class="sec-field">
                        <label for="secBillImport_NoOfLoans"># of Loans <span class="sec-required">*</span></label>
                        <input type="number" min="0" step="1" id="secBillImport_NoOfLoans" name="secBillImport_NoOfLoans" class="form-control" />
                    </div>
                    <div class="sec-field">
                        <label for="secBillImport_attachment">Attachment <span class="sec-required">*</span></label>
                        <input type="file" id="secBillImport_attachment" name="secBillImport_attachment" class="form-control file-input" accept=".xlsx" />
                        <div class="dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete" id="secBillImport_dropzone">
                            <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column sec-file-preview" id="secBillImport_contentdiv" style="display: none!important;">
                                <div class="flex-1 d-flex flex-between-center">
                                    <div id="secBillImport_filesdiv"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="sec-action-row">
                    <div class="sec-status" id="secBillImport_StatusText">Billing period will be generated on Upload.</div>
                    <button type="button" id="secBillImport_Upload" name="secBillImport_Upload" class="sec-btn sec-btn-primary" onclick="return btnSecBillImport_Upload();">
                        <i class="fas fa-upload"></i>
                        Upload
                    </button>
                    <button type="submit" id="secBillImport_ImportToDatabase" name="secBillImport_ImportToDatabase" class="sec-btn sec-btn-soft" onclick="return btnSecBillImport_ImportToDatabase();">
                        <i class="fas fa-database"></i>
                        Import To Database
                    </button>
                    <button type="button" id="secBillImport_ClearData" name="secBillImport_ClearData" class="sec-btn sec-btn-danger" onclick="return btnSecBillImport_ClearData();">
                        <i class="fas fa-circle-xmark"></i>
                        Clear Uploaded Data
                    </button>
                </div>
            </div>
        </div>

        <div class="sec-panel sec-deal-record-panel">
            <button type="button" id="secBillImport_ToggleDealRecords" class="sec-deal-toggle" aria-expanded="false">
                <span class="sec-deal-toggle-title">
                    <i class="fas fa-table"></i>
                    <span>
                        <strong>Deal Records</strong>
                        <span>Collapsed to keep import loan tabs visible while uploading.</span>
                    </span>
                </span>
                <span class="sec-deal-toggle-meta">
                    <span id="secBillImport_DealRecordCount">0 records</span>
                    <i class="fas fa-chevron-down" id="secBillImport_DealRecordIcon"></i>
                </span>
            </button>
            <div id="secBillImport_DealRecordsBody" class="sec-deal-records-body">
                <div class="sec-table-wrap">
                    <table class="table table-bordered" id="table_secBillImportDealRecs" style="width: 100%">
                        <thead>
                            <tr>
                                <th class="sort border-top ps-3" style="width: 80px;">Sr. #</th>
                                <th class="sort border-top ps-3" style="width: 100px;">Project #</th>
                                <th class="sort border-top ps-3" style="width: 150px;">Client Deal Name</th>
                                <th class="sort border-top ps-3" style="width: 150px;">Loan Count</th>
                                <th class="sort border-top ps-3" style="width: 100px;">Task Name</th>
                                <th class="sort border-top ps-3" style="width: 100px;">Copy</th>
                                <th class="sort border-top ps-3" style="width: 120px;">Requested Date</th>
                                <th class="sort border-top ps-3" style="width: 120px;">Delivered Date</th>
                                <th class="sort border-top ps-3" style="width: 120px;">Billing Hours</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="sec-panel">
            <ul class="nav nav-tabs sec-tabs" id="secBillImport_tabs" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" id="secBillImport_newLoanTab" data-toggle="pill" href="#secBillImport_newLoanPane" role="tab" aria-controls="secBillImport_newLoanPane" aria-selected="true">
                        <i class="fas fa-upload mr-1"></i>Import Loan List
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="secBillImport_existingLoanTab" onclick="return secBillImport_ExistingLoanDetails_BindGrid();" data-toggle="pill" href="#secBillImport_existingLoanPane" role="tab" aria-controls="secBillImport_existingLoanPane" aria-selected="false">
                        <i class="fas fa-list-check mr-1"></i>Existing Loan List
                    </a>
                </li>
            </ul>

            <div class="tab-content" id="secBillImport_tabContent">
                <div class="tab-pane fade show active" id="secBillImport_newLoanPane" role="tabpanel" aria-labelledby="secBillImport_newLoanTab">
                    <div class="sec-panel-header">
                        <div>
                            <h2 class="sec-panel-title"><i class="fas fa-table"></i>New Loan Preview</h2>
                            <p class="sec-panel-subtitle">Temporary loan records loaded from the uploaded file.</p>
                        </div>
                    </div>
                    <div class="sec-table-wrap">
                        <table class="table" id="table_secBillImportNewLoanList">
                            <thead>
                                <tr>
                                    <th class="sort border-top ps-3" style="width: 100px;">Sr. #</th>
                                    <th class="sort border-top ps-3" style="width: 100px;">Project #</th>
                                    <th class="sort border-top" style="width: 150px;">Deal #</th>
                                    <th class="sort border-top" style="width: 100px;">Loan #1</th>
                                    <th class="sort border-top" style="width: 100px;">Loan #2</th>
                                    <th class="sort border-top" style="width: 150px;">Received Date</th>
                                    <th class="sort border-top" style="width: 150px;">Delivered Date</th>
                                    <th class="sort border-top">Source</th>
                                    <th class="sort border-top" style="text-align: center; width: 200px;">Remark</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>

                <div class="tab-pane fade" id="secBillImport_existingLoanPane" role="tabpanel" aria-labelledby="secBillImport_existingLoanTab">
                    <div class="sec-panel-header">
                        <div>
                            <h2 class="sec-panel-title"><i class="fas fa-list-check"></i>Existing Loan List</h2>
                            <p class="sec-panel-subtitle">Previously imported loans available in securitization tracking.</p>
                        </div>
                    </div>
                    <div class="sec-table-wrap">
                        <table class="table" id="table_secBillImportExistingLoanList" style="width: 100%">
                            <thead>
                                <tr>
                                    <th class="sort border-top ps-3" style="text-align: center;">Sr. #</th>
                                    <th class="sort border-top" style="width: 300px;">Billing Period</th>
                                    <th class="sort border-top ps-3">Project #</th>
                                    <th class="sort border-top">Deal #</th>
                                    <th class="sort border-top">Loan #1</th>
                                    <th class="sort border-top">Loan #2</th>
                                    <th class="sort border-top" style="text-align: center;">Received Date</th>
                                    <th class="sort border-top" style="text-align: center;">Delivered Date</th>
                                    <th class="sort border-top" style="text-align: center;">Source</th>
                                </tr>
                                <tr class="filters">
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="secBillImport_dverror">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-body text-center">
                    <div class="sec-message-icon">
                        <i class="fas fa-circle-info"></i>
                    </div>
                    <h6 class="modal-title" id="secBillImport_errmsg"></h6>
                </div>
                <div class="modal-footer justify-content-center">
                    <button class="sec-btn sec-btn-primary" type="button" id="secBillImport_btnMessage" onclick="location.reload();">Okay</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
