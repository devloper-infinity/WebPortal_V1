<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="OtherTask.aspx.cs" Inherits="WebPortal.Admin.OtherTask" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style id="st1">
        :root {
            --ot-primary: #2457e6;
            --ot-primary-dark: #1742c6;
            --ot-cyan: #29c6d7;
            --ot-ink: #101828;
            --ot-muted: #667085;
            --ot-line: #e6ebf2;
            --ot-bg: #f5f8fc;
        }



        .modern-page-hero {
            position: relative;
            min-height: 94px;
            border-radius: 20px;
            padding: 21px 30px;
            display: flex;
            align-items: center;
            gap: 18px;
            overflow: hidden;
            color: #fff;
            isolation: isolate;
            background: radial-gradient(circle at 88% -18%, rgba(255, 255, 255, .18) 0 112px, transparent 113px), radial-gradient(circle at 97% 96%, rgba(255, 255, 255, .20) 0 105px, transparent 106px), linear-gradient(105deg, #2352df 0%, #2867eb 48%, #35c5d4 100%);
            box-shadow: 0 20px 42px rgba(36, 87, 230, .22);
        }

            .modern-page-hero:before {
                content: "";
                position: absolute;
                inset: 0;
                background: linear-gradient(90deg, rgba(255, 255, 255, .14), transparent 30%, rgba(255, 255, 255, .10) 78%, transparent);
                transform: skewX(-18deg) translateX(-32%);
                width: 62%;
                z-index: -1;
            }

            .modern-page-hero:after {
                content: "";
                position: absolute;
                right: 210px;
                top: 18px;
                width: 6px;
                height: 6px;
                border-radius: 50%;
                background: rgba(255, 255, 255, .55);
                box-shadow: 22px 18px 0 rgba(255,255,255,.24), 48px -2px 0 rgba(255,255,255,.22), 78px 26px 0 rgba(255,255,255,.18);
            }

        .modern-page-icon {
            width: 50px;
            height: 50px;
            min-width: 50px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255, 255, 255, .16);
            border: 1px solid rgba(255, 255, 255, .25);
            box-shadow: inset 0 1px 0 rgba(255, 255, 255, .30), 0 10px 24px rgba(0, 0, 0, .12);
            backdrop-filter: blur(8px);
        }

            .modern-page-icon i {
                font-size: 24px;
                color: #fff;
            }

        .modern-page-copy {
            flex: 1;
            min-width: 0;
        }

        .modern-page-title {
            margin: 0;
            font-size: 20px;
            line-height: 1.15;
            font-weight: 800;
            letter-spacing: -.02em;
            color: #fff;
        }

        .modern-page-subtitle {
            margin: 8px 0 0;
            font-size: 12px;
            line-height: 1.5;
            font-weight: 700;
            color: rgba(255, 255, 255, .88);
        }

        .hero-chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 12px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
            color: #fff;
            background: rgba(255, 255, 255, .15);
            border: 1px solid rgba(255, 255, 255, .22);
            backdrop-filter: blur(8px);
            white-space: nowrap;
        }

        .col-lg-12 {
            /*   padding: 18px 24px 26px;
            background: #f4f7fb;*/
        }

        .task-card {
            width: 100%;
            border: 1px solid rgba(230, 235, 242, .95);
            border-radius: 22px;
            box-shadow: 0 16px 38px rgba(16, 24, 40, .07);
            overflow: hidden;
            margin-bottom: 22px;
            margin-top: 22px;
            background: rgba(255, 255, 255, .96);
        }

        .task-card-header {
            padding: 18px 22px;
            background: linear-gradient(180deg, #ffffff 0%, #f8fbff 100%);
            border-bottom: 1px solid var(--ot-line);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
        }

        .task-card-title {
            margin: 0;
            font-size: 15px;
            font-weight: 800;
            color: var(--ot-ink);
            display: flex;
            align-items: center;
            gap: 10px;
        }

            .task-card-title i {
                width: 34px;
                height: 34px;
                border-radius: 12px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                color: #2457e6;
                background: #eef4ff;
            }

        .task-card-body {
            padding: 24px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr 1.25fr;
            gap: 18px;
            align-items: stretch;
        }

        .form-field {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

            .form-field label {
                font-size: 12px;
                font-weight: 800;
                color: #344054;
                margin: 0;
            }

        .my-input,
        .my-select {
            width: 100%;
            min-height: 44px;
            border: 1px solid #d9e2ef;
            padding: 9px 12px;
            border-radius: 14px;
            font-size: 13px;
            color: var(--ot-ink);
            background-color: #fff;
            box-shadow: 0 1px 2px rgba(16, 24, 40, .04);
            transition: border-color .2s ease, box-shadow .2s ease, transform .2s ease;
        }

            .my-input:focus,
            .my-select:focus {
                border-color: #3572f4;
                box-shadow: 0 0 0 4px rgba(53, 114, 244, .13);
                outline: none;
            }

        .req {
            color: #ef4444;
            font-weight: 900;
            margin-left: 3px;
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
                width: 30px;
                height: 30px;
                border-radius: 14px;
                align-items: center;
                justify-content: center;
                font-size: 22px;
                color: #fff;
                background: linear-gradient(135deg, #2457e6, #25bfd4);
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

        .actions-grid {
            display: grid;
            grid-template-columns: 1fr 1fr 1.35fr;
            gap: 16px;
            margin-top: 22px;
            align-items: center;
        }

        .btn {
            border-radius: 14px;
            font-weight: 800;
        }

        .btn-gradient-primary,
        .btn-gradient-success {
            color: #fff;
            border-radius: 14px;
            min-height: 46px;
            font-weight: 800;
            border: 0;
            box-shadow: 0 12px 22px rgba(36, 87, 230, .17);
            transition: transform .2s ease, box-shadow .2s ease;
        }

        .btn-gradient-primary {
            background: linear-gradient(135deg, #2457e6, #29c6d7);
        }

        .btn-gradient-success {
            background: linear-gradient(135deg, #16a34a, #10b981);
            box-shadow: 0 12px 22px rgba(16, 185, 129, .18);
        }

            .btn-gradient-primary:hover,
            .btn-gradient-success:hover {
                transform: translateY(-2px);
                color: #fff;
                box-shadow: 0 16px 28px rgba(36, 87, 230, .22);
            }

        .download-action {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .icon-btn {
            height: 46px;
            min-width: 56px;
            background: #dcf7f9;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 1px solid #b9edf1;
            color: #087f8c;
            text-decoration: none;
            transition: transform .2s ease;
        }

            .icon-btn:hover {
                font-weight: 900;
                transform: scale(1.2);
                color: #087f8c;
            }

        .result-panel {
            border: 1px solid var(--ot-line);
            border-radius: 18px;
            padding: 14px;
            background: #ffffff;
            overflow-x: auto;
            min-height: 120px;
        }

        .alert-text {
            font-weight: 800;
            font-size: 14px;
            color: #dc2626;
            display: block;
            margin-bottom: 12px;
        }

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

        @media (max-width: 992px) {
            .form-grid,
            .actions-grid {
                grid-template-columns: 1fr;
            }

            .hero-chip {
                display: none;
            }
        }

        @media (max-width: 576px) {
            .modern-header-wrap,
            .col-lg-12 {
                padding-left: 12px;
                padding-right: 12px;
            }

            .modern-page-hero {
                min-height: 86px;
                padding: 18px;
                border-radius: 16px;
                gap: 12px;
            }

            .modern-page-icon {
                width: 46px;
                height: 46px;
                min-width: 46px;
                border-radius: 14px;
            }

            .modern-page-title {
                font-size: 18px;
            }

            .modern-page-subtitle {
                font-size: 11px;
            }

            .task-card-body {
                padding: 18px;
            }
        }
    </style>

    <script>

        $(document).ready(function () {
            var userId = '<%= HttpContext.Current.User.Identity.Name.ToString() %>';
            otherTask_Project(userId);
            initOtherTaskDragDrop();
        });

        function initOtherTaskDragDrop() {
            const dropZone = document.getElementById('otherTask_dropZone');
            const fileInput = document.getElementById('otherTask_fileUploads');

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
                uploadOtherTaskFile(firstFile, fileInput.name || 'otherTask_fileUploads');
            });

            fileInput.addEventListener('change', function (event) {
                const files = event.target.files;
                if (!files || files.length === 0) return;
                uploadOtherTaskFile(files[0], event.target.name || 'otherTask_fileUploads');
            });
        }

        function uploadOtherTaskFile(file, fieldName) {
            document.getElementById('file_otherTask').value = file.name;
            document.getElementById('otherTask_selectedFile').innerText = file.name;

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


    <script>
        // Enable tooltip
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
        tooltipTriggerList.map(function (el) {
            return new bootstrap.Tooltip(el)
        })
    </script>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="file_otherTask" style="display: none;" />

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="modern-header-wrap">
        <div class="modern-page-hero">
            <div class="modern-page-icon">
                <i class="bi-clipboard-check-fill"></i>
            </div>
            <div class="modern-page-copy">
                <h1 class="modern-page-title">Other Task</h1>
                <p class="modern-page-subtitle">Upload, verify and submit other task data quickly.</p>
            </div>
            <div class="hero-chip"><i class="bi bi-lightning-charge-fill"></i>Fast Employee Operations</div>
        </div>
    </div>

    <div class="col-lg-12">
        <div class="task-card">
            <div class="task-card-header">
                <h5 class="task-card-title"><i class="bi bi-ui-checks-grid"></i>Upload Other Task Data</h5>
            </div>
            <div class="task-card-body">
                <div class="form-grid">
                    <div class="form-field">
                        <label for="otherTask_project">Project # <span class="req">*</span></label>
                        <select class="my-select" id="otherTask_project" onchange="otherTask_bindProcess(this)"></select>
                    </div>

                    <div class="form-field">
                        <label for="otherTask_process">Process <span class="req">*</span></label>
                        <select class="my-select" id="otherTask_process"></select>
                    </div>

                    <div class="form-field">
                        <label for="otherTask_fileUploads">Upload File <span class="req">*</span></label>
                        <div id="otherTask_dropZone" class="drop-zone" role="button" tabindex="0">
                            <div class="drop-zone-content">
                                <i class="bi bi-cloud-arrow-up"></i>
                                <div class="drop-text">
                                    <span class="drop-title">Drag & drop Excel file here</span>
                                    <span class="drop-subtitle">or click to browse .xlsx file</span>
                                </div>
                                <div id="otherTask_selectedFile" class="selected-file-name"></div>
                            </div>
                        </div>
                        <input type="file" id="otherTask_fileUploads" class="file-input d-none" accept=".xlsx" />
                    </div>
                </div>

                <div class="actions-grid">
                    <button type="submit" class="btn btn-gradient-primary w-100" onclick="return otherTask_uploadData();" style="margin-right: 10px;">
                        <i class="bi bi-cloud-upload"></i>&nbsp; Upload File
                   
                    </button>

                    <button type="button" class="btn btn-outline-danger w-100" onclick="return otherTask_clearData();" style="min-height: 46px; width: 360px; margin-left: 30px; margin-left: 10px;">
                        <i class="bi bi-x-circle"></i>&nbsp; Clear Uploaded Data
                   
                    </button>

                    <div class="download-action">
                        <button type="submit" id="otherTask_verify" class="btn btn-gradient-success flex-grow-1" onclick="return otherTask_VerifyData();" style="margin-left: 25px; width: 300px;">
                            <i class="bi bi-check-circle"></i>&nbsp; Verify & Submit
                       
                        </button>
                        <a href="OtherTaskImportFormat.xlsx" class="icon-btn" data-bs-toggle="tooltip" title="Download Standard Format Excel">
                            <i class="bi bi-download" style="font-size: 150%;"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <div class="task-card">
            <div class="task-card-header">
                <h5 class="task-card-title"><i class="bi bi-list-check"></i>Uploaded Data Preview</h5>
            </div>
            <div class="task-card-body">
                <label id="otherTask_alert" class="alert-text"></label>
                <div class="result-panel">
                    <table class="table" id="table_otherTask" style="width: 100%;">
                        <thead></thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="othertask_waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">System is updating details. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>

</asp:Content>

