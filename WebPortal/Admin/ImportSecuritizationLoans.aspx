<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ImportSecuritizationLoans.aspx.cs" Inherits="WebPortal.Admin.ImportSecuritizationLoans" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style id="st1">
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
            grid-template-columns: repeat(3, minmax(0, 1fr));
        }

        .sec-field {
            min-width: 0;
        }

        .sec-field-wide {
            grid-column: span 1;
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

            .sec-field textarea.form-control {
                min-height: 86px;
                resize: vertical;
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
            padding: 0 18px 18px;
            overflow-x: auto;
        }

        #table_NewLoanList,
        #table_ExistingLoanList {
            border-collapse: separate !important;
            border-spacing: 0;
            margin-top: 0 !important;
            width: 100% !important;
        }

            #table_NewLoanList thead th,
            #table_ExistingLoanList thead th {
                background: #edf3f6 !important;
                border-color: #d7e2ea !important;
                color: #263747;
                font-size: 12px;
                text-align: center;
                vertical-align: middle;
                white-space: nowrap;
            }

            #table_NewLoanList tbody td,
            #table_ExistingLoanList tbody td {
                background: #fff;
                border-color: #e2e9ef !important;
                color: #263747;
                font-size: 12px;
                vertical-align: middle;
            }

            #table_NewLoanList tbody tr:hover td,
            #table_ExistingLoanList tbody tr:hover td {
                background: #f7fbfa;
            }

        .dataTables_wrapper .dataTables_info,
        .dataTables_wrapper .dataTables_paginate {
            color: #5c6f82;
            font-size: 12px;
            padding: 12px 0 0;
        }

        .dataTables_wrapper .dataTables_paginate {
            float: right !important;
        }

            .dataTables_wrapper .dataTables_paginate .paginate_button {
                border-radius: 6px !important;
                padding: 4px 10px !important;
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
            .sec-action-row {
                align-items: stretch;
                flex-direction: column;
                width: 100%;
            }

            .sec-btn {
                width: 100%;
            }

            .sec-form-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>


    <script>

        $(document).ready(function () {

            impSerc_bindDeals();

            //test();
        });

        window.onload = function () {
            document.getElementById('importSerc_attachment').addEventListener('change', getFileName);
        }

        const getFileName = (event) => {
            const files = event.target.files;
            var file = files[0];
            document.getElementById("file_importSerc").value = files[0].name;

            const fd = new FormData();

            // add all selected files
            fd.append(event.target.name, file, file.name);
            // create the request
            const xhr = new XMLHttpRequest();

            xhr.onload = () => {
                if (xhr.status >= 200 && xhr.status < 300) {
                    // we done!
                }
            };
            var url = window.location.href;
            // path to server would be where you'd normally post the form to
            xhr.open('POST', url, true);
            xhr.send(fd);
            document.getElementById("dropzone").classList.add("dz-max-files-reached");
            document.getElementById("conentdiv").style.display = '';
            document.getElementById("importSercfilesdiv").innerHTML = file.name;
        }

    </script>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="file_importSerc" style="display: none;" />
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" alt="Loading" />
        <div>One moment, please...</div>
    </div>

    <div class="sec-page">
        <div class="sec-hero">
            <div>
                <div class="sec-kicker">Operations</div>
                <h1 class="sec-title"><i class="fas fa-file-import mr-2"></i>Import Securitization Loan</h1>
                <p class="sec-subtitle">Upload the standard loan list, review temporary records, and import validated loans into securitization tracking.</p>
            </div>
            <div class="sec-hero-actions">
                <a href="SecuritizationTracking.aspx" class="sec-btn sec-btn-light">
                    <i class="fas fa-arrow-left"></i>
                    Back To Tracking
                </a>
                <a href="../Formats/LoanList.xlsx" class="sec-btn sec-btn-light">
                    <i class="fas fa-download"></i>
                    Download Format
                </a>
            </div>
        </div>

        <div class="sec-panel">
            <ul class="nav nav-tabs sec-tabs" id="custom-tabs-one-tab" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" id="custom-tabs-one-importLoan" data-toggle="pill" href="#custom-tabs-one-tab-importLoan" role="tab" aria-controls="custom-tabs-one-importLoan" aria-selected="true">
                        <i class="fas fa-upload mr-1"></i>Import Loan List
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="custom-tabs-two-ExistingLoan" onclick="return ExistingLoanDetails_BindGrid();" data-toggle="pill" href="#custom-tabs-two-tab-ExistingLoan" role="tab" aria-controls="custom-tabs-one-ExistingLoan" aria-selected="false">
                        <i class="fas fa-list-check mr-1"></i>Existing Loan List
                    </a>
                </li>
            </ul>

            <div class="tab-content" id="custom-tabs-one-tabContent">
                <div class="tab-pane fade show active" id="custom-tabs-one-tab-importLoan" role="tabpanel" aria-labelledby="custom-tabs-one-importLoan-tab">
                    <div class="sec-panel-body">
                        <div class="sec-panel-header" style="border: 0; padding: 0 0 16px;">
                            <div>
                                <h2 class="sec-panel-title"><i class="fas fa-cloud-arrow-up"></i>Upload New Loan List</h2>
                                <p class="sec-panel-subtitle">Select a deal, attach the XLSX file, and add an optional import remark.</p>
                            </div>
                        </div>

                        <div class="sec-section-title"><i class="fas fa-briefcase"></i>Import Details</div>
                        <div class="sec-form-grid">
                            <div class="sec-field">
                                <label for="importSerc_DealNo">Deal # <span class="sec-required">*</span></label>
                                <select class="form-control" id="importSerc_DealNo" name="importSerc_DealNo"></select>
                            </div>

                            <div class="sec-field">
                                <label for="importSerc_attachment">Upload File <span class="sec-required">*</span></label>
                                <input type="file" id="importSerc_attachment" name="importSerc_attachment" class="form-control file-input" accept=".xlsx" />
                                <div class="dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete" id="dropzone">
                                    <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column sec-file-preview" id="conentdiv" style="display: none!important;">
                                        <div class="flex-1 d-flex flex-between-center">
                                            <div id="importSercfilesdiv"></div>
                                            <div class="dropdown font-sans-serif">
                                                <button class="btn btn-link text-600 btn-sm dropdown-toggle btn-reveal dropdown-caret-none" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                    <i class="fas fa-ellipsis"></i>
                                                </button>
                                                <div class="dropdown-menu dropdown-menu-end border py-2"><a class="dropdown-item" href="#!" data-dz-remove="data-dz-remove">Remove File</a></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="sec-field sec-field-wide">
                                <label for="importSerc_Remark">Remark <span class="sec-required">*</span></label>
                                <textarea id="importSerc_Remark" name="importSerc_Remark" class="form-control"></textarea>
                            </div>
                        </div>

                        <div class="sec-action-row">
                            <button type="button" id="importSerc_Upload" name="importSerc_Upload" class="sec-btn sec-btn-primary" onclick="return btnImportSerc_Upload();">
                                <i class="fas fa-upload"></i>
                                Upload
                           
                            </button>
                            <button type="submit" id="importSerc_ImportToDatabase" name="importSerc_ImportToDatabase" class="sec-btn sec-btn-soft" onclick="return btnImportSerc_ImportToDatabase();">
                                <i class="fas fa-database"></i>
                                Import To Database

                            </button>
                            <button type="button" class="sec-btn sec-btn-danger" id="importSerc_ClearData" name="importSerc_ClearData" onclick="return btnImportSerc_ClearData();">
                                <i class="fas fa-circle-xmark"></i>
                                Clear Uploaded Data
                           
                            </button>

                        </div>
                    </div>

                    <div class="sec-panel-header">
                        <div>
                            <h2 class="sec-panel-title"><i class="fas fa-table"></i>New Loan Preview</h2>
                            <p class="sec-panel-subtitle">Temporary loan records loaded from the uploaded file.</p>
                        </div>
                    </div>
                    <div class="sec-table-wrap">
                        <table class="table" id="table_NewLoanList">
                            <thead>
                                <tr>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; width: 100px;">Sr. #</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; width: 100px;">Project #</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; width: 150px;">Deal #</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; width: 100px;">Loan #1</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; width: 100px;">Loan #2</th>
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

                <div class="tab-pane fade" id="custom-tabs-two-tab-ExistingLoan" role="tabpanel" aria-labelledby="custom-tabs-one-ExistingLoan-tab">
                    <div class="sec-panel-header">
                        <div>
                            <h2 class="sec-panel-title"><i class="fas fa-list-check"></i>Existing Loan List</h2>
                            <p class="sec-panel-subtitle">Previously imported loans available in securitization tracking.</p>
                        </div>
                    </div>
                    <div class="sec-table-wrap">
                        <table class="table" id="table_ExistingLoanList" style="width: 100%">
                            <thead>
                                <tr>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                    <th class="sort border-top" style="width: 300px;">Billing Period</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Project #</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Deal #</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Loan #1</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Loan #2</th>
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

    <div class="modal fade" id="popUp_Waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">System is updating details. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>


    <div class="modal fade" id="popUp_AlertImportSerc">
        <div class="modal-dialog modal-l">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title"><i class="fas fa-circle-check text-success"></i>Notification</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="sec-message-icon"><i class="fas fa-check"></i></div>
                    <p style="font-size: 16px; text-align: center;">Data imported successfully.</p>
                </div>
                <div class="modal-footer justify-content-between">
                    <button class="sec-btn sec-btn-primary" type="button" id="roam_btnYes" onclick="window.location.reload();">OK</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>

