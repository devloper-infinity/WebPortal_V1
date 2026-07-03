<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="RewardAndRecognition.aspx.cs" Inherits="WebPortal.Admin.RewardAndRecognition" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --rnr-ink: #172033;
            --rnr-muted: #667085;
            --rnr-line: #d9e0ea;
            --rnr-soft-line: #edf1f6;
            --rnr-page: #f5f7fb;
            --rnr-surface: #ffffff;
            --rnr-accent: #2563eb;
            --rnr-accent-dark: #1e40af;
            --rnr-success: #047857;
            --rnr-danger: #b42318;
            --rnr-shadow: 0 14px 34px rgba(23, 32, 51, .10);
        }

        .rnr-page {
            min-height: calc(100vh - 150px);
            padding: 18px 8px 34px;
            color: var(--rnr-ink);
            background: var(--rnr-page);
        }

        .rnr-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            margin-bottom: 18px;
            padding: 18px 20px;
            border: 1px solid var(--rnr-line);
            border-left: 4px solid var(--rnr-accent);
            border-radius: 8px;
            background: var(--rnr-surface);
            box-shadow: var(--rnr-shadow);
        }

        .rnr-header-main {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .rnr-header-icon,
        .rnr-section-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            flex: 0 0 auto;
            border-radius: 8px;
        }

        .rnr-header-icon {
            width: 48px;
            height: 48px;
            color: var(--rnr-accent);
            background: #eff6ff;
            border: 1px solid #bfdbfe;
        }

            .rnr-header-icon i {
                font-size: 23px;
            }

        .rnr-title {
            margin: 0;
            color: var(--rnr-ink);
            font-size: 24px;
            font-weight: 800;
            letter-spacing: 0;
        }

        .rnr-subtitle {
            margin: 5px 0 0;
            color: var(--rnr-muted);
            font-size: 13px;
        }

        .rnr-status-pill {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            min-height: 34px;
            padding: 7px 11px;
            border: 1px solid #c7d2fe;
            border-radius: 8px;
            color: #1e3a8a;
            background: #eef2ff;
            font-size: 12px;
            font-weight: 800;
            white-space: nowrap;
        }

        .rnr-panel {
            overflow: hidden;
            border: 1px solid var(--rnr-line);
            border-radius: 8px;
            background: var(--rnr-surface);
            box-shadow: var(--rnr-shadow);
        }

        .rnr-tabs {
            display: flex;
            gap: 8px;
            margin: 0;
            padding: 12px;
            border-bottom: 1px solid var(--rnr-line);
            background: #fafbfc;
        }

            .rnr-tabs .nav-item {
                margin: 0;
            }

            .rnr-tabs .nav-link {
                min-height: 38px;
                border: 1px solid transparent;
                border-radius: 8px;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 8px 12px;
                color: #475467;
                background: transparent;
                font-size: 13px;
                font-weight: 800;
            }

                .rnr-tabs .nav-link.active {
                    color: var(--rnr-accent-dark);
                    border-color: #bfdbfe;
                    background: #eff6ff;
                }

        .rnr-tab-body {
            padding: 18px 20px 20px;
        }

        .rnr-section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            margin-bottom: 16px;
            padding-bottom: 14px;
            border-bottom: 1px solid var(--rnr-soft-line);
        }

        .rnr-section-title-wrap {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .rnr-section-icon {
            width: 38px;
            height: 38px;
            color: #fff;
            background: var(--rnr-accent);
            box-shadow: 0 8px 18px rgba(37, 99, 235, .18);
        }

        .rnr-section-title {
            margin: 0;
            color: var(--rnr-ink);
            font-size: 18px;
            font-weight: 800;
            letter-spacing: 0;
        }

        .rnr-section-subtitle {
            margin: 4px 0 0;
            color: var(--rnr-muted);
            font-size: 13px;
        }

        .rnr-page label:not(.form-check-label):not(.custom-file-label) {
            display: block;
            margin-bottom: 7px;
            border: 0 !important;
            color: #344054;
            font-size: 13px;
            font-weight: 700 !important;
        }

        .rnr-page .form-control,
        .rnr-page select.form-control,
        .rnr-page input.form-control {
            min-height: 42px;
            border: 1px solid #d0d7e2;
            border-radius: 8px;
            background-color: #fff;
            color: var(--rnr-ink);
            box-shadow: 0 1px 2px rgba(15, 23, 42, .04);
            transition: border-color .18s ease, box-shadow .18s ease;
        }

            .rnr-page .form-control:focus {
                border-color: var(--rnr-accent);
                box-shadow: 0 0 0 3px rgba(37, 99, 235, .14);
                outline: 0;
            }

        .rnr-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 16px;
            padding-top: 14px;
            border-top: 1px dashed #d9e0ea;
        }

        .rnr-btn {
            min-height: 40px;
            border: 0;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 9px 16px;
            font-size: 13px;
            font-weight: 800;
            cursor: pointer;
            transition: transform .18s ease, box-shadow .18s ease, background .18s ease;
        }

        .rnr-btn-primary {
            color: #fff;
            background: var(--rnr-accent);
            box-shadow: 0 10px 20px rgba(37, 99, 235, .18);
        }

            .rnr-btn-primary:hover,
            .rnr-btn-primary:focus {
                color: #fff;
                background: var(--rnr-accent-dark);
                transform: translateY(-1px);
                outline: 0;
            }

        .rnr-btn-light {
            color: #344054;
            border: 1px solid #d0d7e2;
            background: #fff;
        }

            .rnr-btn-light:hover,
            .rnr-btn-light:focus {
                color: var(--rnr-accent-dark);
                border-color: #bfdbfe;
                background: #eff6ff;
                outline: 0;
            }

        .rnr-upload-zone {
            position: relative;
            min-height: 150px;
            border: 2px dashed #b8c4d6;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 18px;
            text-align: center;
            background: #fafbfc;
            transition: border-color .2s ease, background .2s ease, transform .2s ease;
            cursor: pointer;
        }

            .rnr-upload-zone:hover,
            .rnr-upload-zone.is-dragover {
                border-color: var(--rnr-accent);
                background: #eff6ff;
                transform: translateY(-1px);
            }

        .rnr-file-input {
            position: absolute;
            width: 1px;
            height: 1px;
            opacity: 0;
            pointer-events: none;
        }

        .rnr-upload-icon {
            width: 44px;
            height: 44px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 10px;
            color: var(--rnr-accent);
            background: #eff6ff;
            border: 1px solid #bfdbfe;
        }

            .rnr-upload-icon i {
                font-size: 22px;
            }

        .rnr-upload-title {
            margin: 0;
            color: var(--rnr-ink);
            font-size: 14px;
            font-weight: 800;
        }

        .rnr-upload-note {
            margin: 5px 0 12px;
            color: var(--rnr-muted);
            font-size: 12px;
        }

        .rnr-file-panel {
            display: none;
            margin-top: 12px;
            padding: 12px;
            border: 1px solid #d0d7e2;
            border-radius: 8px;
            background: #fff;
            animation: rnrPanelIn .24s ease both;
        }

            .rnr-file-panel.is-visible {
                display: block;
            }

        @keyframes rnrPanelIn {
            from {
                opacity: 0;
                transform: translateY(8px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .rnr-file-panel-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
            margin-bottom: 10px;
            color: var(--rnr-ink);
            font-size: 13px;
            font-weight: 800;
        }

        .rnr-file-list {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }

        .rnr-file-chip {
            max-width: 100%;
            border: 1px solid #d0d7e2;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 7px 9px;
            color: #344054;
            background: #f8fafc;
            font-size: 12px;
            font-weight: 700;
        }

        .rnr-table-wrap {
            overflow-x: auto;
            margin-top: 18px;
        }

        #rnr_table,
        #table_rnr_snap {
            width: 100% !important;
            border-collapse: separate !important;
            border-spacing: 0;
            border: 1px solid var(--rnr-line);
            border-radius: 8px;
            overflow: hidden;
            background: #fff;
        }

            #rnr_table thead th,
            #table_rnr_snap thead th,
            .table.dataTable th {
                background: #f8fafc !important;
                color: #344054;
                border-bottom: 1px solid var(--rnr-line) !important;
                font-size: 12px;
                font-weight: 800;
                text-transform: uppercase;
                letter-spacing: 0;
                white-space: nowrap;
            }

            #rnr_table tbody td,
            #table_rnr_snap tbody td,
            .table.dataTable tr td {
                vertical-align: middle;
                border-color: var(--rnr-soft-line);
                background: #fff !important;
                color: #344054;
                font-size: 13px;
            }

            #rnr_table tbody tr:hover td,
            #table_rnr_snap tbody tr:hover td {
                background: #f8fafc !important;
            }

        .dataTables_length,
        .dataTables_info {
            float: left !important;
        }

        div.dt-buttons {
            position: static;
            float: left;
            padding-left: 16px;
        }

        .buttons-excel,
        .buttons-html5 {
            margin: 0 8px;
            border: 0 !important;
            border-radius: 8px !important;
            color: #fff !important;
            background: var(--rnr-success) !important;
            box-shadow: none;
            font-weight: 800;
            padding: 7px 15px !important;
        }

        .rnr-image-action,
        .rnr-image-action-disabled {
            width: 34px;
            height: 34px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: transform .18s ease, background .18s ease, color .18s ease;
        }

        .rnr-image-action {
            border: 1px solid #bfdbfe;
            color: var(--rnr-accent);
            background: #eff6ff;
            cursor: pointer;
        }

            .rnr-image-action:hover,
            .rnr-image-action:focus {
                color: #fff;
                background: var(--rnr-accent);
                transform: translateY(-1px);
                outline: 0;
            }

        .rnr-image-action-disabled {
            border: 1px solid #e5e7eb;
            color: #98a2b3;
            background: #f8fafc;
        }

        .modal-content {
            overflow: hidden;
            border: 0;
            border-radius: 8px;
            box-shadow: 0 24px 70px rgba(15, 23, 42, .30);
        }

        .rnr-modal-animated.fade .modal-dialog {
            transform: translateY(18px) scale(.98);
            transition: transform .22s ease-out;
        }

        .rnr-modal-animated.show .modal-dialog {
            transform: translateY(0) scale(1);
        }

        .modal-header {
            border-bottom: 1px solid var(--rnr-line);
            background: #f8fafc;
        }

        .modal-title,
        #displayrnr_snap_Header {
            margin: 0;
            color: var(--rnr-ink);
            font-size: 18px;
            font-weight: 800 !important;
        }

        .rnr-carousel-image {
            display: block;
            max-width: 100%;
            max-height: 560px;
            margin: 0 auto;
            border-radius: 8px;
            object-fit: contain;
            box-shadow: 0 14px 30px rgba(15, 23, 42, .18);
        }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 99999;
            width: 210px;
            height: 150px;
            margin: auto;
            padding: 22px;
            border: 1px solid var(--rnr-line);
            border-radius: 8px;
            background: rgba(255, 255, 255, .94);
            box-shadow: var(--rnr-shadow);
            text-align: center;
        }

            .loading img {
                max-width: 64px;
                margin-bottom: 12px;
            }

            .loading .loading-text {
                color: #344054;
                font-size: 12px;
                font-weight: 800;
            }

        @media (max-width: 767px) {
            .rnr-page {
                padding: 12px 0 28px;
            }

            .rnr-header {
                align-items: flex-start;
                flex-direction: column;
            }

            .rnr-title {
                font-size: 21px;
            }

            .rnr-tabs {
                overflow-x: auto;
            }

            .rnr-actions {
                justify-content: stretch;
            }

            .rnr-btn {
                width: 100%;
            }
        }
    </style>

    <script>
        var rnrSelectedFiles = [];
        var rnrUploadData = new FormData();

        function escapeRnrFileName(value) {
            return String(value || '').replace(/[&<>"']/g, function (character) {
                return {
                    '&': '&amp;',
                    '<': '&lt;',
                    '>': '&gt;',
                    '"': '&quot;',
                    "'": '&#39;'
                }[character];
            });
        }

        function renderRnrFiles(files) {
            var names = [];
            var html = '';

            for (var i = 0; i < files.length; i++) {
                names.push(files[i].name);
                html += '<span class="rnr-file-chip"><i class="fas fa-file-image" aria-hidden="true"></i>' + escapeRnrFileName(files[i].name) + '</span>';
            }

            document.getElementById('RewardRecg_file').value = names.join(',');
            $('#filesdiv').html(html);
            $('#conentdiv').toggleClass('is-visible', files.length > 0);
        }

        function uploadRnrFiles(files) {
            rnrSelectedFiles = Array.prototype.slice.call(files || []);
            rnrUploadData = new FormData();

            for (var i = 0; i < rnrSelectedFiles.length; i++) {
                rnrUploadData.append('RewardRecg_attachment', rnrSelectedFiles[i], rnrSelectedFiles[i].name);
            }

            renderRnrFiles(rnrSelectedFiles);

            if (rnrSelectedFiles.length === 0) {
                return;
            }

            var xhr = new XMLHttpRequest();
            xhr.open('POST', window.location.href, true);
            xhr.send(rnrUploadData);
        }

        function openRnrFilePicker(event) {
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            document.getElementById('RewardRecg_attachment').click();
        }

        window.getFileName = function (event) {
            uploadRnrFiles(event.target.files);
        };

        $(document).ready(function () {
            rnr_BindYear();
            rnr_bindusers();
            rnr_bidgrid();
            rnr_bindbranches();
            rnr_snap_binddata();

            $('#RewardRecg_attachment').on('change', function (event) {
                uploadRnrFiles(event.target.files);
            });

            $('#rnrBrowseFiles, #rnrChangeFiles').on('click', openRnrFilePicker);

            $('#dropzone')
                .on('click', function (event) {
                    if ($(event.target).closest('button').length === 0) {
                        openRnrFilePicker(event);
                    }
                })
                .on('dragenter dragover', function (event) {
                    event.preventDefault();
                    event.stopPropagation();
                    $(this).addClass('is-dragover');
                })
                .on('dragleave dragend drop', function (event) {
                    event.preventDefault();
                    event.stopPropagation();
                    $(this).removeClass('is-dragover');
                })
                .on('drop', function (event) {
                    var files = event.originalEvent.dataTransfer.files;
                    uploadRnrFiles(files);
                });
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="RewardRecg_file" type="hidden" />

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" alt="Loading" />
        <div class="loading-text">One moment, please...</div>
    </div>

    <div class="rnr-page">
        <div class="rnr-header">
            <div class="rnr-header-main">
                <span class="rnr-header-icon" aria-hidden="true"><i class="fas fa-award"></i></span>
                <div>
                    <h1 class="rnr-title">Reward and Recognition</h1>
                    <p class="rnr-subtitle">Manage quarterly recognition entries and event snaps from one workspace.</p>
                </div>
            </div>
            <span class="rnr-status-pill"><i class="fas fa-briefcase" aria-hidden="true"></i>Professional Admin View</span>
        </div>

        <div class="rnr-panel">
            <ul class="nav nav-tabs rnr-tabs" id="custom-tabs-one-tab" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" id="custom-tabs-one-rnr_emp-tab" data-toggle="pill" href="#custom-tabs-one-rnr_emp" role="tab" aria-controls="custom-tabs-one-rnr_emp" aria-selected="true">
                        <i class="fas fa-user-check" aria-hidden="true"></i>
                        <span>Add Employee</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="custom-tabs-one-rnr_snap-tab" data-toggle="pill" href="#custom-tabs-one-rnr_snap" role="tab" aria-controls="custom-tabs-one-rnr_snap" aria-selected="false">
                        <i class="fas fa-images" aria-hidden="true"></i>
                        <span>Add Snaps</span>
                    </a>
                </li>
            </ul>

            <div class="tab-content rnr-tab-body" id="custom-tabs-one-tabContent">
                <div class="tab-pane fade show active" id="custom-tabs-one-rnr_emp" role="tabpanel" aria-labelledby="custom-tabs-one-rnr_emp-tab">
                    <div class="rnr-section-header">
                        <div class="rnr-section-title-wrap">
                            <span class="rnr-section-icon" aria-hidden="true"><i class="fas fa-medal"></i></span>
                            <div>
                                <h3 class="rnr-section-title">Employee Recognition</h3>
                                <p class="rnr-section-subtitle">Select a quarter and employee to add to the recognition list.</p>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-3">
                            <label for="rnr_year">Year :</label>
                            <select id="rnr_year" name="rnr_year" class="form-control">
                                <option value="">Select</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label for="rnr_quarter">Quarter :</label>
                            <select id="rnr_quarter" name="rnr_quarter" class="form-control">
                                <option value="">Select</option>
                                <option value="January ~ March">January ~ March</option>
                                <option value="April ~ June">April ~ June</option>
                                <option value="July ~ September">July ~ September</option>
                                <option value="October ~ December">October ~ December</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label for="rnr_employee">Employee :</label>
                            <select id="rnr_employee" name="rnr_employee" class="form-control"></select>
                        </div>
                    </div>

                    <div class="rnr-actions">
                        <button id="rnr_btnsubmit" type="button" class="rnr-btn rnr-btn-primary" onclick="return rnr_Submit();">
                            <i class="fas fa-save" aria-hidden="true"></i>
                            <span>Submit</span>
                        </button>
                    </div>

                    <div class="rnr-table-wrap">
                        <table class="table table-hover align-middle" id="rnr_table">
                            <thead>
                                <tr>
                                    <th>Quarter</th>
                                    <th>Code</th>
                                    <th>Employee Name</th>
                                    <th>Joining Date</th>
                                    <th>Date Of Birth</th>
                                    <th>Branch</th>
                                    <th>Domain</th>
                                    <th>Subdomain</th>
                                    <th>Department</th>
                                    <th>Designation</th>
                                    <th>Reporting Manager</th>
                                    <th>Current Status</th>
                                    <th>Latest Working Date</th>
                                    <th>Productivity/Task</th>
                                    <th>Final Status</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>

                <div class="tab-pane fade" id="custom-tabs-one-rnr_snap" role="tabpanel" aria-labelledby="custom-tabs-one-rnr_snap-tab">
                    <div class="rnr-section-header">
                        <div class="rnr-section-title-wrap">
                            <span class="rnr-section-icon" aria-hidden="true"><i class="fas fa-camera-retro"></i></span>
                            <div>
                                <h3 class="rnr-section-title">Recognition Snaps</h3>
                                <p class="rnr-section-subtitle">Upload branch-wise snaps for the selected quarter.</p>
                            </div>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-3">
                            <label for="rnrSnap_year">Year :</label>
                            <select id="rnrSnap_year" name="rnrSnap_year" class="form-control">
                                <option value="">Select</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label for="rnrSnap_quarter">Quarter :</label>
                            <select id="rnrSnap_quarter" name="rnrSnap_quarter" class="form-control">
                                <option value="">Select</option>
                                <option value="January ~ March">January ~ March</option>
                                <option value="April ~ June">April ~ June</option>
                                <option value="July ~ September">July ~ September</option>
                                <option value="October ~ December">October ~ December</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label for="rnrSnap_location">Location :</label>
                            <select id="rnrSnap_location" name="rnrSnap_location" class="form-control"></select>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-lg-7">
                            <label for="RewardRecg_attachment">Snaps :</label>
                            <input type="file" id="RewardRecg_attachment" name="RewardRecg_attachment" class="rnr-file-input" multiple />
                            <div class="rnr-upload-zone" id="dropzone" role="button" tabindex="0">
                                <div>
                                    <span class="rnr-upload-icon" aria-hidden="true"><i class="fas fa-cloud-upload-alt"></i></span>
                                    <p class="rnr-upload-title">Drag and drop recognition snaps here</p>
                                    <p class="rnr-upload-note">Use Browse Files to select multiple files, or drop them into this area.</p>
                                    <button type="button" class="rnr-btn rnr-btn-light" id="rnrBrowseFiles">
                                        <i class="fas fa-folder-open" aria-hidden="true"></i>
                                        <span>Browse Files</span>
                                    </button>
                                </div>
                            </div>
                            <div class="rnr-file-panel" id="conentdiv">
                                <div class="rnr-file-panel-head">
                                    <span><i class="fas fa-paperclip mr-1" aria-hidden="true"></i>Selected files</span>
                                    <button type="button" class="rnr-btn rnr-btn-light" id="rnrChangeFiles">
                                        <i class="fas fa-sync-alt" aria-hidden="true"></i>
                                        <span>Change Files</span>
                                    </button>
                                </div>
                                <div class="rnr-file-list" id="filesdiv"></div>
                            </div>
                        </div>
                    </div>

                    <div class="rnr-actions">
                        <button id="rnrSnap_btnsubmit" type="button" class="rnr-btn rnr-btn-primary" onclick="return rnrSnap_Submit();">
                            <i class="fas fa-upload" aria-hidden="true"></i>
                            <span>Submit Snaps</span>
                        </button>
                    </div>

                    <div class="rnr-table-wrap">
                        <table class="table table-hover align-middle" id="table_rnr_snap">
                            <thead>
                                <tr>
                                    <th class="text-center">Action</th>
                                    <th>Location</th>
                                    <th>Year</th>
                                    <th>Quarter</th>
                                    <th>Uploaded By</th>
                                    <th>Uploaded Date</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade rnr-modal-animated" id="rnr_dverror" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-sm modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="rnr_errmsg"></h6>
                </div>
                <div class="modal-footer justify-content-center">
                    <button class="rnr-btn rnr-btn-primary" type="button" id="followup_btnMessage" onclick="return rnr_Message();">Okay</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade rnr-modal-animated" id="rnr_snap_display" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 id="displayrnr_snap_Header" name="displayrnr_snap_Header">Recognition Snaps</h6>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="dvslidermain"></div>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
