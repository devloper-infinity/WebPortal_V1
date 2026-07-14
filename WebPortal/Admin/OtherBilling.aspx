<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="OtherBilling.aspx.cs" Inherits="WebPortal.Admin.OtherBilling" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --ob-primary: #1d4ed8;
            --ob-secondary: #22c1dc;
            --ob-dark: #0f172a;
            --ob-muted: #64748b;
            --ob-border: #e2e8f0;
            --ob-soft: #f8fafc;
            --ob-success: #16a34a;
        }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            margin: auto;
            width: 192px;
            height: 192px;
            z-index: 99999;
            text-align: center;
            background: rgba(255,255,255,.92);
            border-radius: 24px;
            box-shadow: 0 24px 60px rgba(15,23,42,.22);
            padding: 26px 18px;
        }

        .ob-page {
            background: #f5f7fb;
            min-height: calc(100vh - 80px);
        }

        .ob-hero {
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 62%, #22c1dc 100%);
            border-radius: 20px;
            padding: 22px 26px;
            color: #fff;
            box-shadow: 0 18px 45px rgba(37,99,235,.25);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            margin-bottom: 18px;
            position: relative;
            overflow: hidden;
        }

            .ob-hero:before {
                content: "";
                position: absolute;
                width: 230px;
                height: 230px;
                border-radius: 50%;
                background: rgba(255,255,255,.14);
                right: -75px;
                top: -95px;
            }

        .ob-hero-left {
            display: flex;
            align-items: center;
            gap: 16px;
            position: relative;
            z-index: 1;
        }

        .ob-hero-icon {
            width: 58px;
            height: 58px;
            border-radius: 18px;
            background: rgba(255,255,255,.18);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 26px;
            box-shadow: inset 0 0 0 1px rgba(255,255,255,.22);
        }

        .ob-hero h4 {
            margin: 0;
            font-size: 22px;
            font-weight: 800;
            letter-spacing: .2px;
        }

        .ob-hero p {
            margin: 4px 0 0;
            color: rgba(255,255,255,.86);
            font-size: 13px;
        }

        .ob-report-link {
            position: relative;
            z-index: 1;
            background: rgba(255,255,255,.16);
            color: #fff !important;
            border: 1px solid rgba(255,255,255,.30);
            border-radius: 999px;
            padding: 10px 16px;
            font-weight: 700;
            font-size: 13px;
            text-decoration: none !important;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: .25s ease;
            white-space: nowrap;
        }

            .ob-report-link:hover {
                background: rgba(255,255,255,.25);
                transform: translateY(-1px);
            }

        .ob-card {
            background: #fff;
            border: 1px solid var(--ob-border);
            border-radius: 20px;
            box-shadow: 0 14px 36px rgba(15,23,42,.07);
            overflow: hidden;
            margin-bottom: 18px;
        }

        .ob-card-header {
            padding: 17px 22px;
            border-bottom: 1px solid var(--ob-border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            background: linear-gradient(180deg,#ffffff,#f8fafc);
        }

        .ob-card-title {
            margin: 0;
            font-size: 15px;
            font-weight: 800;
            color: var(--ob-dark);
            display: flex;
            align-items: center;
            gap: 9px;
        }

        .ob-card-body {
            padding: 22px;
        }

        .ob-field {
            margin-bottom: 16px;
        }

            .ob-field label {
                display: block;
                font-size: 12px;
                font-weight: 800;
                color: #334155;
                margin-bottom: 7px;
            }

            .ob-field .form-control {
                min-height: 42px;
                border-radius: 11px;
                border: 1px solid #cbd5e1;
                font-size: 13px;
                box-shadow: none;
                width: 100% !important;
            }

                .ob-field .form-control:focus {
                    border-color: var(--ob-primary);
                    box-shadow: 0 0 0 3px rgba(37,99,235,.12);
                }

        .ob-format-box {
            background: #f8fafc;
            border: 1px dashed #cbd5e1;
            border-radius: 15px;
            padding: 16px;
            height: 100%;
        }

        .ob-format-title {
            font-weight: 600;
            color: #475569;
            margin-bottom: 12px;
        }

        .ob-format-links {
            display: flex;
            gap: 10px;
            flex-wrap: wrap; /* Change to nowrap if you never want wrapping */
            align-items: center;
        }

        .ob-format-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 8px;
            border-radius: 30px;
            background: #eef6ff;
            border: 1px solid #bfdcff;
            color: #2563eb;
            text-decoration: none;
            font-weight: 600;
            transition: .25s;
            white-space: nowrap;
        }

            .ob-format-link:hover {
                background: linear-gradient(135deg, #2563eb, #22c1dc);
                color: #fff;
                border-color: transparent;
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(37,99,235,.25);
            }

            .ob-format-link i {
                color: #16a34a;
            }

            .ob-format-link:hover i {
                color: #fff;
            }

        .ob-upload-box {
            position: relative;
        }

        .ob-upload-input {
            position: absolute;
            inset: 0;
            opacity: 0;
            width: 100% !important;
            height: 100%;
            cursor: pointer;
            z-index: 2;
        }

        .ob-upload-area {
            border: 2px dashed #bfdbfe;
            border-radius: 16px;
            background: linear-gradient(180deg,#f8fbff,#ffffff);
            min-height: 112px;
            padding: 18px;
            display: flex;
            align-items: center;
            gap: 15px;
            cursor: pointer;
            transition: .25s ease;
        }

            .ob-upload-area:hover,
            .ob-upload-area.ob-dragover {
                border-color: #2563eb;
                background: #eff6ff;
                transform: translateY(-2px);
                box-shadow: 0 13px 25px rgba(37,99,235,.12);
            }

        .ob-upload-icon {
            width: 54px;
            height: 54px;
            min-width: 54px;
            border-radius: 16px;
            background: linear-gradient(135deg,#16a34a,#22c55e);
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 25px;
            animation: obFloat 2.2s ease-in-out infinite;
        }

        @keyframes obFloat {
            0%,100% {
                transform: translateY(0);
            }

            50% {
                transform: translateY(-6px);
            }
        }

        .ob-upload-main {
            font-size: 13px;
            font-weight: 800;
            color: var(--ob-dark);
        }

        .ob-upload-sub {
            font-size: 12px;
            color: var(--ob-muted);
            margin-top: 3px;
        }

        .ob-file-preview {
            margin-top: 10px;
            border-radius: 12px;
            background: #f0fdf4;
            border: 1px solid #bbf7d0;
            color: #166534;
            padding: 10px 12px;
            font-size: 13px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .ob-actions {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
            height: 100%;
            padding-top: 24px;
        }

        .ob-btn-primary,
        .ob-btn-success {
            border: 0;
            color: #fff !important;
            border-radius: 12px;
            padding: 11px 18px;
            font-size: 13px;
            font-weight: 800;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-height: 42px;
            box-shadow: 0 12px 24px rgba(37,99,235,.22);
            transition: .22s ease;
        }

        .ob-btn-primary {
            background: linear-gradient(135deg,#2563eb,#22c1dc);
        }

        .ob-btn-success {
            background: linear-gradient(135deg,#16a34a,#22c55e);
        }

            .ob-btn-primary:hover,
            .ob-btn-success:hover {
                transform: translateY(-2px);
                color: #fff !important;
            }

        .ob-table-wrap {
            background: #fff;
            border: 1px solid var(--ob-border);
            border-radius: 18px;
            padding: 14px;
            box-shadow: 0 12px 30px rgba(15,23,42,.06);
            overflow-x: auto;
            margin-bottom: 18px;
        }

            .ob-table-wrap .table {
                margin-bottom: 0;
                white-space: nowrap;
            }

            .table.dataTable th,
            .ob-table-wrap table th {
                background: #edf3f6 !important;
                color: #0f172a !important;
                font-size: 12px;
                font-weight: 800;
                height: 42px;
                vertical-align: middle !important;
                border-bottom: 1px solid #dbe4ea !important;
            }

            .table.dataTable tr td,
            .ob-table-wrap table td {
                background: #fff;
                font-size: 12px;
                vertical-align: middle !important;
            }

            .table.dataTable tbody tr:hover td,
            .ob-table-wrap table tbody tr:hover td {
                background: #f8fbff !important;
            }

        .dataTables_wrapper .dataTables_filter input,
        .dataTables_wrapper .dataTables_length select {
            border: 1px solid #cbd5e1;
            border-radius: 10px;
            padding: 6px 10px;
            outline: none;
        }

        .dataTables_paginate {
            float: left !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 15px;
            float: left;
        }

        .buttons-excel {
            color: #fff !important;
            box-shadow: none;
            background: linear-gradient(135deg,#16a34a,#22c55e) !important;
            border: 0 !important;
            font-weight: 800;
            margin: 0 10px;
            border-radius: 10px !important;
            padding: 7px 14px !important;
        }

        .dt-center {
            text-align: center;
        }

        .ob-modal .modal-content {
            border: 0;
            border-radius: 18px;
            overflow: hidden;
            box-shadow: 0 24px 65px rgba(15,23,42,.28);
        }

        .ob-modal .modal-header {
            background: linear-gradient(120deg,#1d4ed8,#22c1dc);
            color: #fff;
            border-bottom: 0;
        }

        .ob-modal .modal-title {
            font-weight: 800;
            font-size: 18px;
        }

        @media (max-width: 767px) {
            .ob-page {
                padding: 10px;
            }

            .ob-hero {
                flex-direction: column;
                align-items: flex-start;
                padding: 18px;
            }

                .ob-hero h4 {
                    font-size: 19px;
                }

            .ob-card-body {
                padding: 16px;
            }

            .ob-actions {
                justify-content: stretch;
                padding-top: 5px;
            }

            .ob-btn-primary, .ob-btn-success, .ob-report-link {
                width: 100%;
            }

            .ob-upload-area {
                align-items: flex-start;
            }
        }
    </style>

    <script>

        $(document).ready(function () {
            BindDomainWise_Project(9);
            //otherBilling_BindDetails();
        });

        window.onload = function () {
            document.getElementById('otherBilling_attachment').addEventListener('change', getFileName);
        }

        const getFileName = (event) => {
            const files = event.target.files;
            var file = files[0];
            document.getElementById("file_otherBilling").value = files[0].name;

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
            document.getElementById("otherbillingfilesdiv").innerHTML = '<i class="fas fa-file-excel"></i> ' + file.name;
        }



        $(document).on("dragover", "#otherBilling_uploadArea", function (e) {
            e.preventDefault();
            $(this).addClass("ob-dragover");
        });

        $(document).on("dragleave drop", "#otherBilling_uploadArea", function (e) {
            e.preventDefault();
            $(this).removeClass("ob-dragover");
        });
</script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="file_otherBilling" style="display: none;" />
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="ob-page">
        <div class="ob-hero">
            <div class="ob-hero-left">
                <div class="ob-hero-icon"><i class="fas fa-file-invoice-dollar"></i></div>
                <div>
                    <h4>Other Billing</h4>
                    <p>Import billing sheets, verify data and submit billing details.</p>
                </div>
            </div>
            <a href="ExcelBillingReport.aspx" class="ob-report-link">
                <i class="fas fa-chart-line"></i>
                <span>Sent To Billing Report</span>
                <i class="fas fa-arrow-right"></i>
            </a>
        </div>

        <div class="ob-card">
            <div class="ob-card-header">
                <h5 class="ob-card-title"><i class="fas fa-filter"></i>Billing Import Details</h5>
            </div>
            <div class="ob-card-body">
                <div class="row">
                    <div class="col-lg-3 col-md-6">
                        <div class="ob-field">
                            <label for="otherBilling_ProjectType">Project Type</label>
                            <select id="otherBilling_ProjectType" name="otherBilling_ProjectType" class="form-control">
                                <option value="Select">Select</option>
                                <option value="Rebuttal">Condition Clearing</option>
                                <option value="Research">Research</option>
                            </select>
                        </div>
                    </div>

                    <div class="col-lg-3 col-md-6">
                        <div class="ob-field">
                            <label for="otherBilling_Project">Project</label>
                            <select id="otherBilling_Project" name="otherBilling_Project" class="form-control" onchange="return otherbil_bindDeals(this);">
                            </select>
                        </div>
                    </div>

                    <div class="col-lg-3 col-md-6">
                        <div class="ob-field">
                            <label for="otherBilling_DealNo">Deal #</label>
                            <select id="otherBilling_DealNo" name="otherBilling_DealNo" class="form-control"></select>
                        </div>
                    </div>

                    <div class="col-lg-3 col-md-6">
                        <div class="ob-format-box">

                            <div class="ob-format-title">
                                <i class="fas fa-download"></i>&nbsp;&nbsp;Download Formats
                            </div>

                            <div class="ob-format-links">
                                <a href="../Formats/ImportRebuttalFormat.xlsx" class="ob-format-link">
                                    <i class="fas fa-file-excel"></i>
                                    <span>Condition Clearing</span>
                                </a>

                                <a href="../Formats/ImportResearchFormat.xlsx" class="ob-format-link">
                                    <i class="fas fa-file-excel"></i>
                                    <span>Research Format</span>
                                </a>
                            </div>

                        </div>
                    </div>
                </div>

                <div class="row align-items-stretch">
                    <div class="col-lg-8 col-md-12">
                        <div class="ob-field">
                            <label for="otherBilling_attachment">Attachment</label>
                            <div class="ob-upload-box">
                                <input type="file" id="otherBilling_attachment" name="otherBilling_attachment" class="form-control ob-upload-input" />
                                <div class="ob-upload-area" id="otherBilling_uploadArea">
                                    <div class="ob-upload-icon"><i class="fas fa-cloud-upload-alt"></i></div>
                                    <div>
                                        <div class="ob-upload-main">Drag & drop billing Excel file here</div>
                                        <div class="ob-upload-sub">or click to browse and select file</div>
                                    </div>
                                </div>
                            </div>

                            <div class="dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete" id="dropzone">
                                <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column" id="conentdiv" style="display: none!important;">
                                    <div class="flex-1 d-flex flex-between-center">
                                        <div id="otherbillingfilesdiv" class="ob-file-preview" style="margin-top: 10px; margin-bottom: 10px;"></div>
                                        <div class="dropdown font-sans-serif">
                                            <button class="btn btn-link text-600 btn-sm dropdown-toggle btn-reveal dropdown-caret-none" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                <svg class="svg-inline--fa fa-ellipsis" style="display: none!important" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="ellipsis" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg="">
                                                    <path fill="currentColor" d="M120 256C120 286.9 94.93 312 64 312C33.07 312 8 286.9 8 256C8 225.1 33.07 200 64 200C94.93 200 120 225.1 120 256zM280 256C280 286.9 254.9 312 224 312C193.1 312 168 286.9 168 256C168 225.1 193.1 200 224 200C254.9 200 280 225.1 280 256zM328 256C328 225.1 353.1 200 384 200C414.9 200 440 225.1 440 256C440 286.9 414.9 312 384 312C353.1 312 328 286.9 328 256z"></path></svg></button>
                                            <div class="dropdown-menu dropdown-menu-end border py-2"><a class="dropdown-item" href="#!" data-dz-remove="data-dz-remove">Remove File</a></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-4 col-md-12">
                        <div class="ob-actions">
                            <button type="submit" id="otherBilling_Import" name="otherBilling_Import" class="ob-btn-primary" onclick="return btnOtherBilling_Import();">
                                <i class="fas fa-upload"></i>Import
                           
                            </button>
                            <button type="submit" id="otherBilling_Verify" name="otherBilling_Verify" class="ob-btn-success" onclick="return btnOtherBilling_Verify();">
                                <i class="fas fa-check-circle"></i>Verify & Submit
                           
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="ob-table-wrap">

            <table class="table" id="table_Research" style="display: none;">
                <thead>
                    <tr>
                        <%--  <th class="sort border-top ps-3" style="width: 80px;">Sr. #</th>--%>
                        <th class="sort border-top ps-3" style="width: 100px;">Deal #</th>
                        <th class="sort border-top ps-3" style="width: 150px;">Deal Name</th>
                        <th class="sort border-top ps-3" style="width: 150px;">Subject Line</th>
                        <th class="sort border-top ps-3" style="width: 100px;">No of Loans/Docs</th>
                        <th class="sort border-top ps-3" style="width: 100px;">Requested Docs/Tasks Performed</th>
                        <th class="sort border-top ps-3" style="width: 100px;">Total Time Taken (in Minutes)</th>
                        <th class="sort border-top ps-3" style="width: 150px;">Request Received from</th>
                        <th class="sort border-top ps-3" style="width: 150px;">Request Received Date</th>
                        <th class="sort border-top ps-3" style="width: 150px;">Documents Delivered Date</th>
                        <th class="sort border-top ps-3" style="width: 150px;">Remark</th>
                        <th class="sort border-top ps-3" style="width: 150px;">Time (In Hours)</th>
                    </tr>
                </thead>
                <tbody></tbody>
                <tfoot>
                    <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td style="font-weight: bold; font-size: 13px;"></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                </tfoot>

            </table>

            <table class="table" id="table_Rebuttal" style="display: none;">
                <thead>
                    <tr>
                        <%-- <th class="sort border-top ps-3" style="width: 80px;">Sr. #</th>--%>
                        <th class="sort border-top ps-3" style="width: 100px;">Deal #</th>
                        <th class="sort border-top ps-3" style="width: 150px;">Loan Name</th>
                        <th class="sort border-top ps-3" style="width: 150px;">Condition</th>
                        <th class="sort border-top ps-3" style="width: 150px;">Status</th>
                        <th class="sort border-top ps-3" style="width: 150px;">Client Rebuttal</th>
                        <th class="sort border-top ps-3" style="width: 150px;">Rebuttal Received Date</th>
                        <th class="sort border-top ps-3" style="width: 150px;">Rebuttal Response Date</th>
                        <th class="sort border-top ps-3" style="width: 150px;">Review Time (In Minutes)</th>
                        <th class="sort border-top ps-3" style="width: 150px;">Time</th>
                        <%-- <th class="sort border-top ps-3" style="width: 150px;">Amount</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Rate</th>--%>
                        <th class="sort border-top ps-3" style="width: 150px;">Billing Type</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>

            <table class="table" id="table_Other" style="display: none;">
                <thead>
                    <tr>
                        <th class="sort border-top ps-3" style="width: 80px;">Sr. #</th>
                        <th class="sort border-top ps-3" style="width: 100px;">Name</th>
                        <th class="sort border-top ps-3" style="width: 100px;">Week</th>
                        <th class="sort border-top ps-3" style="width: 100px;">Hours Worked</th>
                        <th class="sort border-top ps-3" style="width: 100px;">Rate/Hour</th>
                        <th class="sort border-top ps-3" style="width: 100px;">Extra Hours Worked</th>
                        <th class="sort border-top ps-3" style="width: 100px;">Extra Hours Rate/Hour</th>
                        <th class="sort border-top ps-3" style="width: 100px;">Total</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
            <table class="table" id="table_670" style="display: none;">
                <thead>
                    <tr>
                        <th class="sort border-top ps-3" style="width: 80px;">Sr. #</th>
                        <th class="sort border-top ps-3" style="width: 100px;">Week Worked</th>
                        <th class="sort border-top ps-3" style="width: 100px;">Day</th>
                        <th class="sort border-top ps-3" style="width: 100px;">Total Hours Worked</th>
                        <th class="sort border-top ps-3" style="width: 100px;">Rate</th>
                        <th class="sort border-top ps-3" style="width: 100px;">Amount</th>
                        <th class="sort border-top ps-3" style="width: 100px;">Job Description</th>
                        <th class="sort border-top ps-3" style="width: 100px;">Member Name</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
            <table class="table" id="table_639" style="display: none;">
                <thead>
                    <tr>
                        <th class="sort border-top ps-3" style="width: 80px;">Sr. #</th>
                        <th class="sort border-top ps-3" style="width: 100px;">Day</th>
                        <th class="sort border-top ps-3" style="width: 100px;">Loan Number</th>
                        <th class="sort border-top ps-3" style="width: 100px;">Last Name</th>
                        <th class="sort border-top ps-3" style="width: 100px;">Underwriting Status</th>
                        <th class="sort border-top ps-3" style="width: 100px;">Underwriter</th>
                        <th class="sort border-top ps-3" style="width: 100px;">No of Re-Submission</th>
                        <th class="sort border-top ps-3" style="width: 100px;">Billable Re-Submission</th>
                        <th class="sort border-top ps-3" style="width: 100px;">Additional Touches</th>
                        <th class="sort border-top ps-3" style="width: 100px;">Initial Review Rate</th>
                        <th class="sort border-top ps-3" style="width: 100px;">Re-Submission Rate</th>
                        <th class="sort border-top ps-3" style="width: 100px;">Total Billing</th>
                        <th class="sort border-top ps-3" style="width: 100px;">Remark</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
            <table class="table" id="table_Secure" style="display: none;">
                <thead>
                    <tr>
                        <th class="sort border-top ps-3" style="width: 80px;">Sr. #</th>
                        <th class="sort border-top ps-3" style="width: 100px;">Task/Process</th>
                        <th class="sort border-top ps-3" style="width: 150px;">Billable Hours</th>
                        <th class="sort border-top ps-3" style="width: 150px; text-align: center;">Total Billing</th>
                        <th class="sort border-top ps-3" style="width: 100px;">Remark</th>
                        <th class="sort border-top ps-3" style="width: 100px; text-align: center;">Billing Type</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
            <table class="table" id="table_Inventory" style="display: none;">
                <thead>
                    <tr>
                        <th class="sort border-top ps-3" style="width: 80px;">Sr. #</th>
                        <th class="sort border-top ps-3" style="width: 100px;">PRP ID</th>
                        <th class="sort border-top ps-3" style="width: 150px;">Seller ID</th>
                        <th class="sort border-top ps-3" style="width: 150px; text-align: center;">Deal #</th>
                        <th class="sort border-top ps-3" style="width: 100px;">Total Time Spent in Minutes</th>
                        <th class="sort border-top ps-3" style="width: 100px; text-align: center;">Time (In Hours)</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>

    <div class="modal fade" id="OtherBilling_Waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">System is updating details. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>

    <div class="modal fade ob-modal" id="billingMessage">
        <div class="modal-dialog modal-l">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Notification</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p style="font-size: 16px;">Data has been verified and submitted successfully</p>
                </div>
                <div class="modal-footer justify-content-between">
                    <%--<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>--%>
                    <button class="btn btn-primary" type="button" id="roam_btnYes" onclick="window.location.reload();">OK</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
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
            /*  background-color: #ccc;*/
            opacity: .85;
            border-radius: 25px;
            width: 192px;
            height: 192px;
            z-index: 99999;
        }

        .dataTables_paginate {
            float: left !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 50px;
            float: left;
        }

        .buttons-excel {
            color: #fff;
            /*     background-color: #28a745;
            border-color: #28a745;*/
            box-shadow: none;
            background: linear-gradient(to right, #ffbf96, #fe7096);
            border: 0;
            font-weight: bold;
            margin: 0px 10px;
        }

        .table.dataTable th {
            /*background:linear-gradient(to bottom, #0070C0, 80%, #ffffff);*/
            background: linear-gradient(to bottom, #cbd0dd, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none;
        }

        .dt-center {
            text-align: center;
        }
    </style>

    <script>

        $(document).ready(function () {
            BindDomainWise_Project(9);
            //otherBilling_BindDetails();
        });

        window.onload = function () {
            document.getElementById('otherBilling_attachment').addEventListener('change', getFileName);
        }

        const getFileName = (event) => {
            const files = event.target.files;
            var file = files[0];
            document.getElementById("file_otherBilling").value = files[0].name;

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
            document.getElementById("otherbillingfilesdiv").innerHTML = file.name;
        }

    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="file_otherBilling" style="display: none;" />
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Other Billing</b></h6>
                </div>
                <div class="col-sm-6" style="text-align: right;">
                    <a href="ExcelBillingReport.aspx" class="m-0" style="font-size: 13px; text-decoration: underline; float: right; margin-right: 100px; font-weight: bold;">Sent To Billing Report >> </a>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <h5 class="card-title"></h5>
                <table class="table">
                    <tr>
                        <td><b>Project Type:</b></td>
                        <td>
                            <select id="otherBilling_ProjectType" name="otherBilling_ProjectType" class="form-control" style="width: 250px;">
                                <option value="Select">Select</option>
                                <option value="Rebuttal">Condition Clearing</option>
                                <option value="Research">Research</option>
                            </select>
                        </td>
                        <td><b>Project :</b></td>
                        <td>
                            <select id="otherBilling_Project" name="otherBilling_Project" class="form-control" style="width: 250px;" onchange="return bindDeals(this);">
                            </select>
                        </td>
                        <td>
                            <a href="../Formats/ImportRebuttalFormat.xlsx" style="font-family: Verdana; font-size: 13px; font-weight: bold; color: blue; text-decoration: underline;">Condition Clearing</a>
                            <a href="../Formats/ImportResearchFormat.xlsx" style="font-family: Verdana; font-size: 13px; font-weight: bold; color: blue; padding-left: 20px; text-decoration: underline;">Research Format</a>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Deal #:</b></td>
                        <td>
                            <select id="otherBilling_DealNo" name="otherBilling_DealNo" class="form-control" style="width: 250px;"></select>
                        </td>
                        <td><b>Attachment:</b></td>
                        <td>
                            <input type="file" id="otherBilling_attachment" name="otherBilling_attachment" class="form-control" style="width: 250px;" />
                            <div class="dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete" id="dropzone">
                                <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column" id="conentdiv" style="display: none!important;">
                                    <div class="flex-1 d-flex flex-between-center">
                                        <div id="otherbillingfilesdiv" style="margin-top: 10px; margin-bottom: 10px;"></div>
                                        <div class="dropdown font-sans-serif">
                                            <button class="btn btn-link text-600 btn-sm dropdown-toggle btn-reveal dropdown-caret-none" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                <svg class="svg-inline--fa fa-ellipsis" style="display: none!important" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="ellipsis" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg="">
                                                    <path fill="currentColor" d="M120 256C120 286.9 94.93 312 64 312C33.07 312 8 286.9 8 256C8 225.1 33.07 200 64 200C94.93 200 120 225.1 120 256zM280 256C280 286.9 254.9 312 224 312C193.1 312 168 286.9 168 256C168 225.1 193.1 200 224 200C254.9 200 280 225.1 280 256zM328 256C328 225.1 353.1 200 384 200C414.9 200 440 225.1 440 256C440 286.9 414.9 312 384 312C353.1 312 328 286.9 328 256z"></path></svg><!-- <span class="fas fa-ellipsis-h"></span> Font Awesome fontawesome.com --></button>
                                            <div class="dropdown-menu dropdown-menu-end border py-2"><a class="dropdown-item" href="#!" data-dz-remove="data-dz-remove">Remove File</a></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </td>
                        <td>
                            <button type="submit" id="otherBilling_Import" name="otherBilling_Import" class="btn btn-primary" onclick="return btnOtherBilling_Import();">Import</button>
                            &nbsp;&nbsp;&nbsp;&nbsp;
                            <button type="submit" id="otherBilling_Verify" name="otherBilling_Verify" class="btn btn-primary" onclick="return btnOtherBilling_Verify();">Verify & Submit</button>
                        </td>
                    </tr>
                </table>
                <hr />

                <table class="table" id="table_Research" style="display: none;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="width: 100px;">Deal #</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Deal Name</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Subject Line</th>
                            <th class="sort border-top ps-3" style="width: 100px;">No of Loans/Docs</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Requested Docs/Tasks Performed</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Total Time Taken (in Minutes)</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Request Received from</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Request Received Date</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Documents Delivered Date</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Remark</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Time (In Hours)</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                    <tfoot>
                        <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td style="font-weight: bold; font-size: 13px;"></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                    </tfoot>

                </table>

                <table class="table" id="table_Rebuttal" style="display: none;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="width: 100px;">Deal #</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Loan Name</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Condition</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Status</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Client Rebuttal</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Rebuttal Received Date</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Rebuttal Response Date</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Review Time (In Minutes)</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Time</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Billing Type</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>

                <table class="table" id="table_Other" style="display: none;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="width: 80px;">Sr. #</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Name</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Week</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Hours Worked</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Rate/Hour</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Extra Hours Worked</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Extra Hours Rate/Hour</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Total</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
                <table class="table" id="table_670" style="display: none;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="width: 80px;">Sr. #</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Week Worked</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Day</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Total Hours Worked</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Rate</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Amount</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Job Description</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Member Name</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
                <table class="table" id="table_639" style="display: none;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="width: 80px;">Sr. #</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Day</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Loan Number</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Last Name</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Underwriting Status</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Underwriter</th>
                            <th class="sort border-top ps-3" style="width: 100px;">No of Re-Submission</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Billable Re-Submission</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Additional Touches</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Initial Review Rate</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Re-Submission Rate</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Total Billing</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Remark</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
                <table class="table" id="table_Secure" style="display: none;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="width: 80px;">Sr. #</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Task/Process</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Billable Hours</th>
                            <th class="sort border-top ps-3" style="width: 150px; text-align: center;">Total Billing</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Remark</th>
                            <th class="sort border-top ps-3" style="width: 100px; text-align: center;">Billing Type</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
                <table class="table" id="table_Inventory" style="display: none;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="width: 80px;">Sr. #</th>
                            <th class="sort border-top ps-3" style="width: 100px;">PRP ID</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Seller ID</th>
                            <th class="sort border-top ps-3" style="width: 150px; text-align: center;">Deal #</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Total Time Spent in Minutes</th>
                            <th class="sort border-top ps-3" style="width: 100px; text-align: center;">Time (In Hours)</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="OtherBilling_Waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">System is updating details. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>

    <div class="modal fade" id="billingMessage">
        <div class="modal-dialog modal-l">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Notification</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p style="font-size: 16px;">Data has been verified and submitted successfully</p>
                </div>
                <div class="modal-footer justify-content-between">
                    <button class="btn btn-primary" type="button" id="roam_btnYes" onclick="window.location.reload();">OK</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

</asp:Content>--%>
