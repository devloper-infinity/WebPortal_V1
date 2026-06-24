<%@ Page Title="" Language="C#" MasterPageFile="~/US/USAdmin.Master" AutoEventWireup="true" CodeBehind="FeedbackDetails.aspx.cs" Inherits="WebPortal.US.FeedbackDetails" %>


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
            top: 50%;
            left: 50%;
            width: 180px;
            min-height: 150px;
            z-index: 200000;
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
                box-shadow: var(--ca-shadow);
            }

            .loading div {
                display: inline-block;
                margin-top: 12px;
                padding: 8px 14px;
                color: var(--ca-text);
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
        }

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

        .my-btn, .btn.btn-primary, #usfeedback_btnsubmit {
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

            .my-btn:hover, .btn.btn-primary:hover, #usfeedback_btnsubmit:hover {
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

        .table.dataTable, #usfeedback_table {
            border-collapse: separate !important;
            border-spacing: 0;
        }

            .table.dataTable th, #usfeedback_table th {
                white-space: nowrap;
                color: #374151 !important;
                background: #f8fafc !important;
                border-bottom: 1px solid var(--ca-border) !important;
                font-size: 12px;
                text-transform: uppercase;
                letter-spacing: .04em;
            }

            .table.dataTable tr td, #usfeedback_table td {
                background: none !important;
                background-color: #fff !important;
                color: var(--ca-text);
                border-color: #eef2f7 !important;
                vertical-align: middle;
            }

            .table.dataTable tbody tr:hover td, #usfeedback_table tbody tr:hover td {
                background-color: #f8fbff !important;
            }

        #usfeedback_table_wrapper, #usfeedback_table {
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

    <script>
        $(document).ready(function () {
            GetLoggedInUserDetails();
            bindloanDetails_feedback();
        });


        function initusfeedbackDragDrop() {
            const dropZone = document.getElementById('usfeedback_dropZone');
            const fileInput = document.getElementById('usfeedback_fileUploads');

            if (!dropZone || !fileInput) return;

            dropZone.addEventListener('click', function () {
                fileInput.click();
            });

            dropZone.addEventListener('keydown', function (event) {
                if (event.key === 'Enter' || event.key === ' ') {
                    event.preventDefault();
                    fileInput.click();
                }
            });

            ['dragenter', 'dragover'].forEach(function (eventName) {
                dropZone.addEventListener(eventName, function (event) {
                    event.preventDefault();
                    event.stopPropagation();
                    dropZone.classList.add('dragover');
                });
            });

            ['dragleave', 'drop'].forEach(function (eventName) {
                dropZone.addEventListener(eventName, function (event) {
                    event.preventDefault();
                    event.stopPropagation();
                    dropZone.classList.remove('dragover');
                });
            });

            dropZone.addEventListener('drop', function (event) {
                const files = event.dataTransfer.files;
                if (!files || files.length === 0) return;

                const firstFile = files[0];
                if (!firstFile.name.toLowerCase().endsWith('.xlsx')) {
                    Swal.fire('Invalid file', 'Please upload only .xlsx file.', 'warning');
                    return;
                }

                const dataTransfer = new DataTransfer();
                dataTransfer.items.add(firstFile);
                fileInput.files = dataTransfer.files;
                uploadusfeedbackFile(firstFile, fileInput.name || 'usfeedback_fileUploads');
            });

            fileInput.addEventListener('change', function (event) {
                const files = event.target.files;
                if (!files || files.length === 0) return;
                uploadusfeedbackFile(files[0], event.target.name || 'usfeedback_fileUploads');
            });
        }

        function uploadusfeedbackFile(file, fieldName) {
            document.getElementById('file_usfeedback').value = file.name;
            document.getElementById('usfeedback_selectedFile').innerText = file.name;

            const fd = new FormData();
            fd.append(fieldName, file, file.name);

            const xhr = new XMLHttpRequest();
            xhr.onload = function () {
                if (xhr.status < 200 || xhr.status >= 300) {
                    Swal.fire('Upload failed', 'Unable to upload selected file. Please try again.', 'error');
                }
            };

            xhr.open('POST', window.location.href, true);
            xhr.send(fd);
        }

    </script>


    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input type="text" id="usfeedback_projectid" name="usfeedback_projectid" style="display: none;" />
    <input id="file_usfeedback" style="display: none;" />

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
                <h1 class="condition-title">Feedback Details</h1>
                <p class="condition-subtitle">Add, review, and track loan feedback details.</p>
            </div>
        </div>
        <a id="usfeedback_back" href="GlobalSearch.aspx" class="hero-back-link">
            <i class="fas fa-arrow-left"></i>Go back
        </a>
    </div>

    <div class="condition-page">
        <div class="condition-card">
            <div class="condition-card-header">
                <div>
                    <h2 class="condition-card-title">Feedback Information</h2>
                    <p class="condition-card-hint">Enter client, loan, task, reviewer, and feedback findings.</p>
                </div>
            </div>
            <div class="condition-card-body">
                <div class="main-container">

                    <div class="my-row">
                        <div class="my-col-6">
                            <label><b>Client</b></label>
                            <input type="text" id="usfeedback_projectno" name="usfeedback_projectno" class="my-input form-control" />
                        </div>
                        <div class="my-col-6">
                            <label><b>Client Deal #</b></label>
                            <input type="text" id="usfeedback_dealno" name="usfeedback_dealno" class="my-input form-control" />
                        </div>
                    </div>
                    <div class="my-row">
                        <div class="my-col-6">
                            <label><b>Loan #</b></label>
                            <input type="text" id="usfeedback_loanno" name="usfeedback_loanno" class="my-input form-control" />
                        </div>
                        <div class="my-col-6">
                            <label><b>Task</b></label>
                            <select id="usfeedback_task" name="usfeedback_task" class="my-select form-control" onchange="return getTaskwiseDetails(this);"></select>
                        </div>
                    </div>

                    <div id="trOther" class="my-row" style="display: none;">
                        <div class="my-col-6">
                            <label><b>Severity</b></label>
                            <select id="usfeedback_severity" name="usfeedback_severity" class="my-select form-control">
                                <option value="">Select</option>
                                <option value="Critical">Critical</option>
                                <option value="Non-Critical">Non-Critical</option>
                                <option value="No Error">No Error</option>
                            </select>
                        </div>
                        <div class="my-col-6">
                            <label><b>Findings</b></label>
                            <textarea id="usfeedback_finding" name="usfeedback_finding" class="my-textarea form-control"></textarea>
                        </div>
                    </div>

                    <div id="tratr1" class="my-row" style="display: none;">
                        <div class="my-col-6">
                            <label><b>Reviewer</b></label>
                            <input type="text" id="usfeedback_reviewer" name="usfeedback_reviewer" class="my-input form-control" />
                        </div>
                        <div class="my-col-6">
                            <label><b>Review Date</b></label>
                            <input type="date" id="usfeedback_reviewdate" name="usfeedback_reviewdate" class="my-input form-control" />
                        </div>
                    </div>

                    <div id="tratr2" class="my-row" style="display: none;">
                        <div class="my-col-6">
                            <label><b>ATR Supported?</b></label>
                            <select id="usfeedback_atrsupported" name="usfeedback_atrsupported" class="my-select form-control">
                                <option value="">Select</option>
                                <option value="Yes">Yes</option>
                                <option value="No">No</option>
                            </select>
                        </div>
                        <div class="my-col-6">
                            <label><b># of Borrowers</b></label>
                            <input type="number" id="usfeedback_noofbwr" name="usfeedback_noofbwr" class="my-input form-control" />
                        </div>
                    </div>

                    <div id="tratr3" class="my-row" style="display: none;">
                        <div class="my-col-6">
                            <label><b>Review Findings</b></label>
                            <textarea id="usfeedback_reviewfindings" name="usfeedback_reviewfindings" class="my-textarea form-control"></textarea>
                        </div>
                        <div class="my-col-6">
                            <label><b>Seller Disclosed DTI Issue</b></label>
                            <textarea id="usfeedback_dtiissue" name="usfeedback_dtiissue" class="my-textarea form-control"></textarea>
                        </div>
                    </div>

                    <div id="tratr4" class="my-row" style="display: none;">
                        <div class="my-col-6">
                            <label><b>Highest BWR Income Type</b></label>
                            <input type="text" id="usfeedback_incometype" name="usfeedback_incometype" class="my-input form-control" />
                        </div>
                        <div class="my-col-6">
                            <label><b># SE businesses</b></label>
                            <input type="number" id="usfeedback_noofsebus" name="usfeedback_noofsebus" class="my-input form-control" />
                        </div>
                    </div>

                    <div id="tratr5" class="my-row" style="display: none;">
                        <div class="my-col-6">
                            <label><b># Rental Properties</b></label>
                            <input type="number" id="usfeedback_noofrental" name="usfeedback_noofrental" class="my-input form-control" />
                        </div>
                        <div class="my-col-6">
                            <label><b>Comments</b></label>
                            <textarea id="usfeedback_comments" name="usfeedback_comments" class="my-textarea form-control"></textarea>
                        </div>
                    </div>

                    <div class="my-row">
                        <div class="my-col-6">
                            <div class="form-field">
                                <label for="usfeedback_fileUploads">Upload File <span class="req">*</span></label>
                                <div id="usfeedback_dropZone" class="drop-zone" role="button" tabindex="0">
                                    <div class="drop-zone-content">
                                        <i class="bi bi-cloud-arrow-up"></i>
                                        <div class="drop-text">
                                            <span class="drop-title">Drag & drop Excel file here</span>
                                            <span class="drop-subtitle">or click to browse .xlsx file</span>
                                        </div>
                                        <div id="usfeedback_selectedFile" class="selected-file-name"></div>
                                    </div>
                                </div>
                                <input type="file" id="fee_fileUploads" class="file-input d-none" accept=".xlsx" />
                            </div>
                        </div>
                        <div class="my-row">
                            <div class="my-col-12 action-row">
                                <button type="button" id="usfeedback_btnsubmit" name="usfeedback_btnsubmit" class="my-btn primary btn btn-primary" onclick="return usfeedback_submit();">Submit</button>
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
                        <table class="table table-bordered" style="width: 100%;" id="usfeedback_table"></table>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
