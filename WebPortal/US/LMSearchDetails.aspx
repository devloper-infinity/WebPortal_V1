<%@ Page Title="" Language="C#" MasterPageFile="~/US/USAdmin.Master" AutoEventWireup="true" CodeBehind="LMSearchDetails.aspx.cs" Inherits="WebPortal.US.LMSearchDetails" %>


<asp:Content ID="lmsearchdetails_head" ContentPlaceHolderID="head" runat="server">

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
            z-index: 200000;
            flex-direction: column;
            background: rgba(15,23,42,.35);
            backdrop-filter: blur(4px);
            align-items: center;
            justify-content: center;
            text-align: center;
        }

        #lmsearchdetails_load1.lmsearch-loading-active { display: flex !important; }

        #lmsearchdetails_load1 .lmsearch-loading-box { display:flex; flex-direction:column; align-items:center; gap:10px; padding:16px 20px; border-radius:12px; background:#fff; box-shadow:0 12px 30px rgba(15,23,42,.22); }
        #lmsearchdetails_load1 .lmsearch-loading-box img { width:56px; height:56px; }

        .condition-page {
            width: 100%;
            /*   padding: 0 15px 24px;*/
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

        .hero-back-link {
            position: relative;
            z-index: 1;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 14px;
            color: #fff !important;
            background: rgba(255, 255, 255, .16);
            border: 1px solid rgba(255, 255, 255, .22);
            border-radius: 999px;
            font-size: 13px;
            font-weight: 800;
            text-decoration: none !important;
            transition: transform .16s ease, background .16s ease;
        }

            .hero-back-link:hover {
                color: #fff !important;
                background: rgba(255, 255, 255, .24);
                transform: translateY(-1px);
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

        .my-col-4, .my-col-6, .my-col-12 {
            padding-right: 0;
        }

        .my-col-4 {
            flex: 1 1 260px;
            max-width: calc(33.333% - 11px);
        }

        .my-col-6 {
            flex: 1 1 320px;
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

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: 600 !important;
            border: none !important;
            color: #374151;
        }

        .my-input, .my-select, .my-textarea,
        .form-control {
            width: 100% !important;
            border: 1px solid var(--ca-border) !important;
            padding: 9px 11px !important;
            border-radius: 12px !important;
            font-size: 13px !important;
            color: var(--ca-text) !important;
            background-color: #fff !important;
            transition: border-color .16s ease, box-shadow .16s ease, background-color .16s ease;
        }

        .my-input, .my-select, .form-control {
            height: 40px;
        }

        textarea.my-input, .my-textarea, textarea.form-control {
            min-height: 88px !important;
            height: auto !important;
            resize: vertical;
        }

            .my-input:focus, .my-select:focus, .my-textarea:focus, .form-control:focus {
                border-color: var(--ca-primary) !important;
                box-shadow: 0 0 0 4px var(--ca-ring) !important;
                outline: none !important;
            }

        .action-row {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .feedback-row-action { border: 0; border-radius: 8px; padding: 6px 9px; color: #fff; background: #2563eb; cursor: pointer; }
        .feedback-row-action:hover { background: #1d4ed8; }
        .feedback-row-action.delete { margin-left: 5px; background: #dc2626; }

        .drop-zone {
            /* min-height: 126px;*/
            border: 1.5px dashed #8ab4ff;
            border-radius: 18px;
            background: linear-gradient(180deg, #f7fbff 0%, #eef6ff 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            cursor: pointer;
            padding: 18px;
            transition: all .22s ease;
        }

        .drop-zone-content {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }

            .drop-zone-content i {
                display: flex;
                width: 40px;
                height: 40px;
                border-radius: 14px;
                align-items: center;
                justify-content: center;
                font-size: 22px;
                color: #fff;
                /* background: linear-gradient(135deg, #2457e6, #25bfd4);*/
                background: linear-gradient(135deg, #2563eb 0%, #7c3aed 100%);
                box-shadow: 0 10px 18px rgba(36, 87, 230, .22);
                flex-shrink: 0;
            }

        .drop-text {
            display: flex;
            flex-direction: column;
            text-align: left;
        }

        .drop-title {
            font-size: 12px;
            font-weight: 800;
            color: #182230;
        }

        .drop-subtitle {
            margin-top: 2px;
            font-size: 12px;
            color: var(--ot-muted);
        }

        .selected-file-name {
            margin-top: 8px;
            font-size: 12px;
            color: #047857;
            font-weight: 800;
            word-break: break-word;
        }

        .my-btn, .btn.btn-primary, #lmsearchdetails_btnsubmit, #lmsearchdetails_btncomplete {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 42px;
            padding: 9px 24px !important;
            border: none !important;
            border-radius: 13px !important;
            color: white !important;
            margin-right: 0;
            font-size: 14px !important;
            font-weight: 800 !important;
            letter-spacing: .01em;
            cursor: pointer;
            /* background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%) !important;*/
            background: linear-gradient(135deg, #2563eb 0%, #7c3aed 100%);
            box-shadow: 0 10px 20px rgba(37, 99, 235, .24) !important;
            transition: transform .16s ease, box-shadow .16s ease, background .16s ease;
        }

            .my-btn:hover, .btn.btn-primary:hover, #lmsearchdetails_btnsubmit:hover, #lmsearchdetails_btncomplete:hover {
                transform: translateY(-1px);
                opacity: 1;
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

        .table.dataTable, #lmsearchdetails_table {
            border-collapse: separate !important;
            border-spacing: 0;
        }

            .table.dataTable th, #lmsearchdetails_table th {
                white-space: nowrap;
                color: #374151 !important;
                background: #f8fafc !important;
                border-bottom: 1px solid var(--ca-border) !important;
                font-size: 12px;
                text-transform: uppercase;
                letter-spacing: .04em;
            }

            .table.dataTable tr td, #lmsearchdetails_table td {
                background: none !important;
                background-color: #fff !important;
                color: var(--ca-text);
                border-color: #eef2f7 !important;
                vertical-align: middle;
            }

            .table.dataTable tbody tr:hover td, #lmsearchdetails_table tbody tr:hover td {
                background-color: #f8fbff !important;
            }

        #lmsearchdetails_table_wrapper, #lmsearchdetails_table {
            width: 100% !important;
        }

        .table-responsive-modern {
            width: 100%;
            overflow-x: auto;
        }

        @media (max-width: 768px) {
            .condition-page {
                padding: 0 12px 18px;
            }

            .condition-hero {
                margin: 0 12px 16px;
                padding: 18px;
                align-items: flex-start;
                flex-direction: column;
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

            .my-col-4, .my-col-6 {
                max-width: 100%;
                flex-basis: 100%;
            }
        }
    </style>

    <script src="../Scripts/US/LMSearch.js?v=20261019.17"></script>

    <script>
        $(document).ready(function () {
            LMSearchDetails.initializeDetails();
            lmsearchdetails_initDragDrop();
        });

        function lmsearchdetails_initDragDrop() {
            const lmsearchdetails_dropZone = document.getElementById('lmsearchdetails_dropZone');
            const lmsearchdetails_fileInput = document.getElementById('lmsearchdetails_fileUploads');

            if (!lmsearchdetails_dropZone || !lmsearchdetails_fileInput) return;

            lmsearchdetails_dropZone.addEventListener('click', function () {
                lmsearchdetails_fileInput.click();
            });

            lmsearchdetails_dropZone.addEventListener('keydown', function (lmsearchdetails_event) {
                if (lmsearchdetails_event.key === 'Enter' || lmsearchdetails_event.key === ' ') {
                    lmsearchdetails_event.preventDefault();
                    lmsearchdetails_fileInput.click();
                }
            });

            ['dragenter', 'dragover'].forEach(function (lmsearchdetails_eventName) {
                lmsearchdetails_dropZone.addEventListener(lmsearchdetails_eventName, function (lmsearchdetails_event) {
                    lmsearchdetails_event.preventDefault();
                    lmsearchdetails_event.stopPropagation();
                    lmsearchdetails_dropZone.classList.add('dragover');
                });
            });

            ['dragleave', 'drop'].forEach(function (lmsearchdetails_eventName) {
                lmsearchdetails_dropZone.addEventListener(lmsearchdetails_eventName, function (lmsearchdetails_event) {
                    lmsearchdetails_event.preventDefault();
                    lmsearchdetails_event.stopPropagation();
                    lmsearchdetails_dropZone.classList.remove('dragover');
                });
            });

            lmsearchdetails_dropZone.addEventListener('drop', function (lmsearchdetails_event) {
                const lmsearchdetails_files = lmsearchdetails_event.dataTransfer.files;
                if (!lmsearchdetails_files || lmsearchdetails_files.length === 0) return;

                const lmsearchdetails_firstFile = lmsearchdetails_files[0];
                if (!lmsearchdetails_firstFile.name.toLowerCase().endsWith('.xlsx')) {
                    NativePopup.fire('Invalid file', 'Please upload only .xlsx file.', 'warning');
                    return;
                }

                const lmsearchdetails_dataTransfer = new DataTransfer();
                lmsearchdetails_dataTransfer.items.add(lmsearchdetails_firstFile);
                lmsearchdetails_fileInput.files = lmsearchdetails_dataTransfer.files;
                lmsearchdetails_uploadFile(lmsearchdetails_firstFile, lmsearchdetails_fileInput.name || 'lmsearchdetails_fileUploads');
            });

            lmsearchdetails_fileInput.addEventListener('change', function (lmsearchdetails_event) {
                const lmsearchdetails_files = lmsearchdetails_event.target.files;
                if (!lmsearchdetails_files || lmsearchdetails_files.length === 0) return;
                lmsearchdetails_uploadFile(lmsearchdetails_files[0], lmsearchdetails_event.target.name || 'lmsearchdetails_fileUploads');
            });
        }

        function lmsearchdetails_uploadFile(lmsearchdetails_file, lmsearchdetails_fieldName) {
            document.getElementById('lmsearchdetails_file').value = lmsearchdetails_file.name;
            document.getElementById('lmsearchdetails_selectedFile').innerText = lmsearchdetails_file.name;

            const lmsearchdetails_formData = new FormData();
            lmsearchdetails_formData.append(lmsearchdetails_fieldName, lmsearchdetails_file, lmsearchdetails_file.name);

            const lmsearchdetails_xhr = new XMLHttpRequest();
            lmsearchdetails_xhr.onload = function () {
                if (lmsearchdetails_xhr.status < 200 || lmsearchdetails_xhr.status >= 300) {
                    NativePopup.fire('Upload failed', 'Unable to upload selected file. Please try again.', 'error');
                }
            };

            lmsearchdetails_xhr.open('POST', window.location.href, true);
            lmsearchdetails_xhr.send(lmsearchdetails_formData);
        }

    </script>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
</asp:Content>

<asp:Content ID="lmsearchdetails_content" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input type="hidden" id="lmsearchdetails_file" name="lmsearchdetails_file" />

    <div class="loading" id="lmsearchdetails_load1">
        <div class="lmsearch-loading-box">
            <img src="../images/Load_1.gif" alt="Loading" />
            <span style="font-size:12px;font-weight:bold;">One moment, please . . . .</span>
        </div>
    </div>

    <div class="condition-hero">
        <div class="condition-title-wrap">
            <span class="condition-title-icon"><i class="fas fa-copy"></i></span>
            <div>
                <h1 class="condition-title">Feedback Details</h1>
                <p class="condition-subtitle">Add, review, and track loan feedback details.</p>
            </div>
        </div>
        <a id="lmsearchdetails_back" href="LMSearch.aspx" class="hero-back-link">
            <i class="fas fa-arrow-left"></i>Go back
        </a>
    </div>

    <div class="condition-page">
        <div class="condition-card">
            <div class="condition-card-header">
                <div>
                    <h2 class="condition-card-title" id="lmsearchdetails_clientinfo">Feedback Information</h2>
                    <p class="condition-card-hint">Enter client, loan, task, reviewer, and feedback findings.</p>
                </div>
            </div>
            <div class="condition-card-body">
                <div class="main-container">

                    <div class="my-row">
                        <div class="my-col-6">
                            <label><b>Client</b></label>
                            <input type="text" id="lmsearchdetails_client" name="lmsearchdetails_client" class="my-input form-control" />
                        </div>
                    </div>
                    <div class="my-row">
                        <div class="my-col-6">
                            <label><b>Reviewer:</b></label>
                            <input type="text" id="lmsearchdetails_qcername" name="lmsearchdetails_qcername" class="my-input form-control" />
                        </div>
                        <div class="my-col-6">
                            <label><b>Date Reviewed:</b></label>
                            <input type="text" id="lmsearchdetails_qcerdate" name="lmsearchdetails_qcerdate" class="my-input form-control" />
                        </div>
                    </div>
                    <div class="my-row">
                        <div class="my-col-6">
                            <label><b>Loan ID</b></label>
                            <input type="text" id="lmsearchdetails_loanid" name="lmsearchdetails_loanid" class="my-input form-control" />
                        </div>
                        <div class="my-col-6">
                            <label><b>Task</b></label>
                            <select id="lmsearchdetails_task" name="lmsearchdetails_task" class="my-select form-control" onchange="return LMSearchDetails.taskChanged(this);"></select>
                        </div>
                    </div>

                    <div id="lmsearchdetails_trOther" class="my-row" style="display: none;">
                        <div class="my-col-6">
                            <label><b>Severity <span class="req">*</span></b></label>
                            <select id="lmsearchdetails_severity" name="lmsearchdetails_severity" class="my-select form-control" required="required" aria-required="true" onchange="return LMSearchDetails.syncNoError();">
                                <option value="">Select</option>
                                <option value="Critical">Critical</option>
                                <option value="Non-Critical">Non-Critical</option>
                                <option value="No Error">No Error</option>
                            </select>
                        </div>
                        <div class="my-col-6">
                            <label><b>Findings <span class="req">*</span></b></label>
                            <textarea id="lmsearchdetails_finding" name="lmsearchdetails_finding" class="my-textarea form-control" required="required" aria-required="true"></textarea>
                        </div>
                    </div>

                    <div id="lmsearchdetails_tratr1" class="my-row" style="display: none;">
                        <div class="my-col-6">
                            <label><b>Reviewer</b></label>
                            <input type="text" id="lmsearchdetails_reviewer" name="lmsearchdetails_reviewer" class="my-input form-control" />
                        </div>
                        <div class="my-col-6">
                            <label><b>Review Date</b></label>
                            <input type="date" id="lmsearchdetails_reviewdate" name="lmsearchdetails_reviewdate" class="my-input form-control" />
                        </div>
                    </div>

                    <div id="lmsearchdetails_tratr2" class="my-row" style="display: none;">
                        <div class="my-col-6">
                            <label><b>ATR Supported?</b></label>
                            <select id="lmsearchdetails_atrsupported" name="lmsearchdetails_atrsupported" class="my-select form-control">
                                <option value="">Select</option>
                                <option value="Yes">Yes</option>
                                <option value="No">No</option>
                            </select>
                        </div>
                        <div class="my-col-6">
                            <label><b># of Borrowers</b></label>
                            <input type="number" id="lmsearchdetails_noofbwr" name="lmsearchdetails_noofbwr" class="my-input form-control" />
                        </div>
                    </div>

                    <div id="lmsearchdetails_tratr3" class="my-row" style="display: none;">
                        <div class="my-col-6">
                            <label><b>Review Findings</b></label>
                            <textarea id="lmsearchdetails_reviewfindings" name="lmsearchdetails_reviewfindings" class="my-textarea form-control"></textarea>
                        </div>
                        <div class="my-col-6">
                            <label><b>Seller Disclosed DTI Issue</b></label>
                            <textarea id="lmsearchdetails_dtiissue" name="lmsearchdetails_dtiissue" class="my-textarea form-control"></textarea>
                        </div>
                    </div>

                    <div id="lmsearchdetails_tratr4" class="my-row" style="display: none;">
                        <div class="my-col-6">
                            <label><b>Highest BWR Income Type</b></label>
                            <input type="text" id="lmsearchdetails_incometype" name="lmsearchdetails_incometype" class="my-input form-control" />
                        </div>
                        <div class="my-col-6">
                            <label><b># SE businesses</b></label>
                            <input type="number" id="lmsearchdetails_noofsebus" name="lmsearchdetails_noofsebus" class="my-input form-control" />
                        </div>
                    </div>

                    <div id="lmsearchdetails_tratr5" class="my-row" style="display: none;">
                        <div class="my-col-6">
                            <label><b># Rental Properties</b></label>
                            <input type="number" id="lmsearchdetails_noofrental" name="lmsearchdetails_noofrental" class="my-input form-control" />
                        </div>
                        <div class="my-col-6">
                            <label><b>Comments</b></label>
                            <textarea id="lmsearchdetails_comments" name="lmsearchdetails_comments" class="my-textarea form-control"></textarea>
                        </div>
                    </div>

                    <div class="my-row">
                        <div class="my-col-6" style="display: none;">
                            <div class="form-field">
                                <label for="lmsearchdetails_fileUploads">Upload File <span class="req">*</span></label>
                                <div id="lmsearchdetails_dropZone" class="drop-zone" role="button" tabindex="0">
                                    <div class="drop-zone-content">
                                        <i class="bi bi-cloud-arrow-up"></i>
                                        <div class="drop-text">
                                            <span class="drop-title">Drag & drop Excel file here</span>
                                            <span class="drop-subtitle">or click to browse .xlsx file</span>
                                        </div>
                                        <div id="lmsearchdetails_selectedFile" class="selected-file-name"></div>
                                    </div>
                                </div>
                                <input type="file" id="lmsearchdetails_fileUploads" name="lmsearchdetails_fileUploads" class="file-input d-none" accept=".xlsx" />
                            </div>
                        </div>
                        <div class="my-row">
                            <div class="my-col-12 action-row">
                                <input type="hidden" id="lmsearchdetails_editkey" value="" />
                                <button type="button" id="lmsearchdetails_btnsubmit" name="lmsearchdetails_btnsubmit" class="my-btn primary btn btn-primary" onclick="return LMSearchDetails.submit();">
                                    <i class="fas fa-plus"></i>&nbsp; Add
                                </button>
                                <button type="button" id="lmsearchdetails_btncanceledit" class="my-btn btn btn-secondary" style="display:none" onclick="return LMSearchDetails.cancelEdit();">
                                    <i class="fas fa-times"></i>&nbsp; Cancel Edit
                                </button>
                                <button type="button" id="lmsearchdetails_btncomplete" name="lmsearchdetails_btncomplete" class="my-btn primary btn btn-primary" onclick="return LMSearchDetails.complete();">
                                    <i class="fas fa-check"></i>&nbsp; Complete Loan
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="condition-card">
                <div class="condition-card-header">
                    <div>
                        <h2 class="condition-card-title">Feedback Records</h2>
                        <p class="condition-card-hint">Review saved feedback records below.</p>
                    </div>
                </div>
                <div class="condition-card-body">
                    <div class="table-responsive-modern">
                        <table class="table table-bordered" style="width: 100%;" id="lmsearchdetails_table"></table>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>


