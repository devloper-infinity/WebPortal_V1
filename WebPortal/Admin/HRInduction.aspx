<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="HRInduction.aspx.cs" Inherits="WebPortal.Admin.HRInduction" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --ind-primary: #1d4ed8;
            --ind-primary-2: #2563eb;
            --ind-accent: #22c1dc;
            --ind-bg: #f4f7fb;
            --ind-card: #ffffff;
            --ind-text: #172033;
            --ind-muted: #64748b;
            --ind-border: #dbe5f1;
            --ind-soft: #eff6ff;
        }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            margin: auto;
            width: 190px;
            height: 150px;
            z-index: 99999;
            background: rgba(255, 255, 255, .96);
            border-radius: 18px;
            box-shadow: 0 18px 45px rgba(15, 23, 42, .18);
            text-align: center;
            padding: 22px 15px;
        }

        .loading img {
            width: 58px;
            height: 58px;
            object-fit: contain;
        }

        .hrind-page {
            background: var(--ind-bg);
          
        }

        .hrind-container {
            width: 100%;
          padding: -10px;
        }

        .hrind-hero {
            margin: 14px 0 18px;
            padding: 22px 24px;
            border-radius: 20px;
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%);
            box-shadow: 0 16px 35px rgba(37, 99, 235, .25);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            overflow: hidden;
            position: relative;
        }

        .hrind-hero:after {
            content: "";
            position: absolute;
            width: 220px;
            height: 220px;
            border-radius: 50%;
            background: rgba(255, 255, 255, .13);
            right: -80px;
            top: -100px;
        }

        .hrind-hero-left {
            display: flex;
            align-items: center;
            gap: 15px;
            position: relative;
            z-index: 1;
        }

        .hrind-hero-icon {
            width: 54px;
            height: 54px;
            border-radius: 17px;
            background: rgba(255, 255, 255, .2);
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: inset 0 0 0 1px rgba(255, 255, 255, .22);
            font-size: 24px;
        }

        .hrind-hero h4 {
            margin: 0;
            font-size: 22px;
            font-weight: 800;
            letter-spacing: .2px;
        }

        .hrind-hero p {
            margin: 5px 0 0;
            color: rgba(255, 255, 255, .88);
            font-size: 13px;
        }

        .hrind-chip {
            position: relative;
            z-index: 1;
            padding: 8px 14px;
            border-radius: 999px;
            background: rgba(255, 255, 255, .18);
            border: 1px solid rgba(255, 255, 255, .28);
            font-weight: 700;
            font-size: 12px;
            white-space: nowrap;
        }

        .hrind-shell {
            background: var(--ind-card);
            border: 1px solid var(--ind-border);
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(15, 23, 42, .08);
            overflow: hidden;
        }

        .hrind-tabs-wrap {
            padding: 14px 16px 0;
            background: linear-gradient(180deg, #ffffff 0%, #f8fbff 100%);
            border-bottom: 1px solid var(--ind-border);
        }

        .hrind-tabs {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            border: 0 !important;
        }

        .hrind-tabs .nav-item {
            margin: 0 !important;
        }

        .hrind-tabs .nav-link {
            border: 1px solid var(--ind-border) !important;
            border-radius: 14px 14px 0 0 !important;
            background: #fff;
            color: var(--ind-muted) !important;
            font-weight: 800;
            padding: 12px 16px;
            transition: all .2s ease;
        }

        .hrind-tabs .nav-link i {
            margin-right: 7px;
        }

        .hrind-tabs .nav-link:hover {
            color: var(--ind-primary) !important;
            transform: translateY(-1px);
        }

        .hrind-tabs .nav-link.active {
            color: #fff !important;
            background: linear-gradient(120deg, var(--ind-primary), var(--ind-accent)) !important;
            border-color: transparent !important;
            box-shadow: 0 10px 20px rgba(37, 99, 235, .18);
        }

        .hrind-body {
            padding: 18px;
        }

        .hrind-section-card {
            border: 1px solid var(--ind-border);
            border-radius: 18px;
            background: #fff;
            padding: 18px;
            margin-bottom: 18px;
        }

        .hrind-section-title {
            display: flex;
            align-items: center;
            gap: 9px;
            margin-bottom: 15px;
            font-size: 15px;
            font-weight: 900;
            color: var(--ind-text);
        }

        .hrind-section-title i {
            color: var(--ind-primary-2);
        }

        .hrind-label {
            font-weight: 800 !important;
            color: #334155;
            font-size: 12px;
            margin-bottom: 7px;
        }

        .hrind-page .form-control,
        .hrind-page select.form-control,
        .hrind-page textarea.form-control {
            border: 1px solid var(--ind-border) !important;
            border-radius: 12px !important;
            min-height: 40px;
            box-shadow: none !important;
            color: var(--ind-text);
            font-size: 13px;
        }

        .hrind-page textarea.form-control {
            min-height: 96px;
            resize: vertical;
        }

        .hrind-page .form-control:focus {
            border-color: var(--ind-primary-2) !important;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, .12) !important;
        }

        .hrind-upload-box {
            border: 1.5px dashed #9bb5d6;
            border-radius: 16px;
            background: linear-gradient(180deg, #f8fbff 0%, #ffffff 100%);
            padding: 14px;
            position: relative;
            min-height: 92px;
        }

        .hrind-upload-title {
            display: flex;
            align-items: center;
            gap: 10px;
            color: var(--ind-primary);
            font-weight: 900;
            margin-bottom: 8px;
        }

        .hrind-upload-title i {
            font-size: 22px;
        }

        .hrind-file-input {
            padding: 7px !important;
            background: #fff;
        }

        .hrind-selected-file {
            margin-top: 10px;
            color: #0f766e;
            font-weight: 800;
            font-size: 12px;
        }

        .hrind-option-row {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .hrind-option-row .form-control {
            flex: 1;
        }

        .hrind-check {
            width: 20px;
            height: 20px;
            accent-color: var(--ind-primary-2);
            cursor: pointer;
        }

        .hrind-actions {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 8px;
        }

        .hrind-btn-primary,
        .hrind-page .btn-primary {
            border: 0 !important;
            border-radius: 12px !important;
            background: linear-gradient(120deg, var(--ind-primary), var(--ind-accent)) !important;
            color: #fff !important;
            font-weight: 900 !important;
            padding: 10px 20px !important;
            box-shadow: 0 10px 20px rgba(37, 99, 235, .2) !important;
        }

        .hrind-btn-primary:hover,
        .hrind-page .btn-primary:hover {
            transform: translateY(-1px);
            box-shadow: 0 14px 24px rgba(37, 99, 235, .28) !important;
        }

        .hrind-filter-card {
            border: 1px solid var(--ind-border);
            background: #f8fbff;
            border-radius: 18px;
            padding: 16px;
            margin-bottom: 18px;
        }

        .hrind-table-title {
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--ind-text);
            font-weight: 900;
            margin: 10px 0 12px;
            font-size: 15px;
        }

        .hrind-table-title i {
            color: var(--ind-primary);
        }

        .hrind-table-wrap {
            width: 100%;
            overflow-x: auto;
            border: 1px solid var(--ind-border);
            border-radius: 16px;
            background: #fff;
            margin-bottom: 18px;
        }

        .hrind-page table.dataTable,
        .hrind-page table.table {
            margin-bottom: 0 !important;
            width: 100% !important;
        }

        .hrind-page .table.dataTable th,
        .hrind-page .table th {
            background: #edf3f6 !important;
            color: #172033 !important;
            font-size: 12px;
            font-weight: 900;
            height: 42px;
            vertical-align: middle !important;
            white-space: nowrap;
            border-bottom: 1px solid var(--ind-border) !important;
        }

        .hrind-page .table.dataTable td,
        .hrind-page .table td {
            background: #fff !important;
            color: #334155;
            font-size: 12px;
            vertical-align: middle !important;
            border-top: 1px solid #eef2f7 !important;
        }

        .hrind-page .table tbody tr:hover td {
            background: #f8fbff !important;
        }

        .dataTables_length, .dataTables_info {
            float: left !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 12px;
            float: left;
        }

        .buttons-excel, .buttons-html5 {
            color: #fff !important;
            box-shadow: none !important;
            background: linear-gradient(120deg, var(--ind-primary), var(--ind-accent)) !important;
            border: 0 !important;
            font-weight: 800 !important;
            margin: 0 8px !important;
            border-radius: 10px !important;
            padding: 7px 14px !important;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: normal !important;
            border: none !important;
        }

        .hrind-page .modal-content {
            border: 0;
            border-radius: 18px;
            box-shadow: 0 20px 45px rgba(15, 23, 42, .22);
        }

        .hrind-page .modal-header {
            border-radius: 18px 18px 0 0;
            background: linear-gradient(120deg, var(--ind-primary), var(--ind-accent));
            color: #fff;
        }

        @media (max-width: 767px) {
            .hrind-container {
                padding: 0px;
            }

            .hrind-hero {
                align-items: flex-start;
                flex-direction: column;
                padding: 18px;
            }

            .hrind-hero h4 {
                font-size: 19px;
            }

            .hrind-tabs .nav-link {
                width: 100%;
                border-radius: 12px !important;
            }

            .hrind-tabs .nav-item {
                width: 100%;
            }

            .hrind-actions {
                justify-content: stretch;
            }

            .hrind-actions .btn {
                width: 100%;
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            inductionset_BindGrid();
            checkpaper_BindYear();
            indreport_BindYear();
        });

        window.onload = function () {
            document.getElementById('inductionset_attachment').addEventListener('change', getFileName);
        }

        const getFileName = (event) => {
            const files = event.target.files;
            var file = files[0];
            if (!file) {
                return;
            }
            document.getElementById("filep").value = files[0].name;

            const fd = new FormData();

            fd.append(event.target.name, file, file.name);
            const xhr = new XMLHttpRequest();

            xhr.onload = () => {
                if (xhr.status >= 200 && xhr.status < 300) {
                }
            };
            var url = window.location.href;
            xhr.open('POST', url, true);
            xhr.send(fd);
            document.getElementById("dropzone").classList.add("dz-max-files-reached");
            document.getElementById("conentdiv").style.display = '';
            document.getElementById("filesdiv").innerHTML = '<i class="fas fa-check-circle"></i> ' + file.name;
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="filep" style="display: none;" />

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold; margin-top: 8px;">One moment, please . . . .</div>
    </div>

    <div class="hrind-page">
      <%--  <div class="hrind-container"></div>--%>
            <div class="hrind-hero">
                <div class="hrind-hero-left">
                    <div class="hrind-hero-icon">
                        <i class="fas fa-user-graduate"></i>
                    </div>
                    <div>
                        <h4>HR Induction Management</h4>
                        <p>Manage induction questions, verify papers and track employee induction status.</p>
                    </div>
                </div>
                <div class="hrind-chip">
                    <i class="fas fa-copy"></i> HR Induction
                </div>
            </div>

            <div class="hrind-shell">
                <div class="hrind-tabs-wrap">
                    <ul class="nav nav-tabs hrind-tabs" id="custom-tabs-one-tab" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">
                                <i class="fas fa-list-check"></i>Question Set
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">
                                <i class="fas fa-file-signature"></i>Check Question Paper
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="custom-tabs-one-messages-tab" data-toggle="pill" href="#custom-tabs-one-messages" role="tab" aria-controls="custom-tabs-one-messages" aria-selected="false">
                                <i class="fas fa-chart-column"></i>Induction Report
                            </a>
                        </li>
                    </ul>
                </div>

                <div class="hrind-body">
                    <div class="tab-content" id="custom-tabs-one-tabContent">
                        <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                            <div class="hrind-section-card">
                                <div class="hrind-section-title">
                                    <i class="fas fa-circle-question"></i>
                                    Create Question Set
                                </div>

                                <div class="row">
                                    <div class="col-lg-12 col-md-12 col-sm-12 mb-3">
                                        <label class="hrind-label" for="inductionset_question">Question</label>
                                        <textarea id="inductionset_question" name="inductionset_question" class="form-control" placeholder="Enter induction question"></textarea>
                                    </div>

                                    <div class="col-lg-4 col-md-6 col-sm-12 mb-3">
                                        <label class="hrind-label" for="inductionset_weightage">Weightage</label>
                                        <input type="number" id="inductionset_weightage" name="inductionset_weightage" class="form-control" placeholder="Enter marks" />
                                    </div>

                                    <div class="col-lg-8 col-md-6 col-sm-12 mb-3">
                                        <label class="hrind-label" for="inductionset_attachment">Attachment</label>
                                        <div class="hrind-upload-box dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete" id="dropzone">
                                            <div class="hrind-upload-title">
                                                <i class="fas fa-cloud-arrow-up-alt"></i>
                                                <span>Upload attachment</span>
                                            </div>
                                            <input type="file" id="inductionset_attachment" name="inductionset_attachment" class="form-control hrind-file-input" />
                                            <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column" id="conentdiv" style="display: none!important;">
                                                <div class="flex-1 d-flex flex-between-center">
                                                    <div id="filesdiv" class="hrind-selected-file"></div>
                                                    <div class="dropdown font-sans-serif">
                                                        <button class="btn btn-link text-600 btn-sm dropdown-toggle btn-reveal dropdown-caret-none" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="display: none!important;">
                                                            <span class="fas fa-ellipsis-h"></span>
                                                        </button>
                                                        <div class="dropdown-menu dropdown-menu-end border py-2">
                                                            <a class="dropdown-item" href="#!" data-dz-remove="data-dz-remove">Remove File</a>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-lg-6 col-md-6 col-sm-12 mb-3">
                                        <label class="hrind-label" for="inductionset_option1">Option 1</label>
                                        <div class="hrind-option-row">
                                            <input type="text" id="inductionset_option1" name="inductionset_option1" class="form-control" placeholder="Enter option 1" />
                                            <input type="checkbox" class="custom-checkbox hrind-check" id="option1" title="Correct answer" />
                                        </div>
                                    </div>

                                    <div class="col-lg-6 col-md-6 col-sm-12 mb-3">
                                        <label class="hrind-label" for="inductionset_option2">Option 2</label>
                                        <div class="hrind-option-row">
                                            <input type="text" id="inductionset_option2" name="inductionset_option2" class="form-control" placeholder="Enter option 2" />
                                            <input type="checkbox" class="custom-checkbox hrind-check" id="option2" title="Correct answer" />
                                        </div>
                                    </div>

                                    <div class="col-lg-6 col-md-6 col-sm-12 mb-3">
                                        <label class="hrind-label" for="inductionset_option3">Option 3</label>
                                        <div class="hrind-option-row">
                                            <input type="text" id="inductionset_option3" name="inductionset_option3" class="form-control" placeholder="Enter option 3" />
                                            <input type="checkbox" class="custom-checkbox hrind-check" id="option3" title="Correct answer" />
                                        </div>
                                    </div>

                                    <div class="col-lg-6 col-md-6 col-sm-12 mb-3">
                                        <label class="hrind-label" for="inductionset_option4">Option 4</label>
                                        <div class="hrind-option-row">
                                            <input type="text" id="inductionset_option4" name="inductionset_option4" class="form-control" placeholder="Enter option 4" />
                                            <input type="checkbox" class="custom-checkbox hrind-check" id="option4" title="Correct answer" />
                                        </div>
                                    </div>
                                </div>

                                <div class="hrind-actions">
                                    <button id="inductionset_btnsubmit" class="btn btn-primary hrind-btn-primary" onclick="return inductionset_submit();">
                                        <i class="fas fa-paper-plane"></i> Submit
                                    </button>
                                </div>
                            </div>

                            <div class="hrind-table-title">
                                <i class="fas fa-table"></i> Question List
                            </div>
                            <div class="hrind-table-wrap">
                                <table class="table table-striped table-hover" id="inductionset_table" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Question</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Weightage</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Option 1</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Option 2</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Option 3</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Option 4</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Answer</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added By</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added Date</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>

                        <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                            <div class="hrind-filter-card">
                                <div class="row align-items-end">
                                    <div class="col-lg-3 col-md-4 col-sm-12 mb-3">
                                        <label class="hrind-label" for="checkpaper_month">Month</label>
                                        <select id="checkpaper_month" name="checkpaper_month" class="form-control">
                                            <option value="">Select</option>
                                            <option value="January">January</option>
                                            <option value="February">February</option>
                                            <option value="March">March</option>
                                            <option value="April">April</option>
                                            <option value="May">May</option>
                                            <option value="June">June</option>
                                            <option value="July">July</option>
                                            <option value="August">August</option>
                                            <option value="September">September</option>
                                            <option value="October">October</option>
                                            <option value="November">November</option>
                                            <option value="December">December</option>
                                        </select>
                                    </div>

                                    <div class="col-lg-3 col-md-4 col-sm-12 mb-3">
                                        <label class="hrind-label" for="checkpaper_year">Year</label>
                                        <select id="checkpaper_year" name="checkpaper_year" class="form-control">
                                            <option value="">Select</option>
                                        </select>
                                    </div>

                                    <div class="col-lg-2 col-md-4 col-sm-12 mb-3">
                                        <button id="checkpaper_btnShow" class="btn btn-primary hrind-btn-primary w-100" onclick="return checkpaper_Submit()">
                                            <i class="fas fa-search"></i> Show
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <div class="hrind-table-title">
                                <i class="fas fa-file-lines"></i> Question Paper List
                            </div>
                            <div class="hrind-table-wrap">
                                <table class="table table-striped table-hover" id="checkpaper_table" style="padding-top: 10px; width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="display: none;">Employee ID</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Answer Sheet</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Employee Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Result</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Exam Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Attempt</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>

                        <div class="tab-pane fade" id="custom-tabs-one-messages" role="tabpanel" aria-labelledby="custom-tabs-one-messages-tab">
                            <div class="hrind-filter-card">
                                <div class="row align-items-end">
                                    <div class="col-lg-3 col-md-4 col-sm-12 mb-3">
                                        <label class="hrind-label" for="indreport_month">Month</label>
                                        <select id="indreport_month" name="indreport_month" class="form-control">
                                            <option value="">Select</option>
                                            <option value="All">All</option>
                                            <option value="January">January</option>
                                            <option value="February">February</option>
                                            <option value="March">March</option>
                                            <option value="April">April</option>
                                            <option value="May">May</option>
                                            <option value="June">June</option>
                                            <option value="July">July</option>
                                            <option value="August">August</option>
                                            <option value="September">September</option>
                                            <option value="October">October</option>
                                            <option value="November">November</option>
                                            <option value="December">December</option>
                                        </select>
                                    </div>

                                    <div class="col-lg-3 col-md-4 col-sm-12 mb-3">
                                        <label class="hrind-label" for="indreport_year">Year</label>
                                        <select id="indreport_year" name="indreport_year" class="form-control">
                                            <option value="">Select</option>
                                        </select>
                                    </div>

                                    <div class="col-lg-2 col-md-4 col-sm-12 mb-3">
                                        <button id="indreport_btnShow" class="btn btn-primary hrind-btn-primary w-100" onclick="return indreportsummary_bindgrid()">
                                            <i class="fas fa-search"></i> Show
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <div class="hrind-table-title">
                                <i class="fas fa-chart-pie"></i> Summary
                            </div>
                            <div class="hrind-table-wrap">
                                <table class="table table-striped table-hover" id="indreport_table" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Total</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Completed</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Pending</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>

                            <div class="hrind-table-title">
                                <i class="fas fa-clipboard-list"></i> Details
                            </div>
                            <div class="hrind-table-wrap">
                                <table class="table table-striped table-hover" id="indreportdetail_table" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Exam Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Result</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Marks Obtained</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Percentage</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Joining Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Department</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Designation</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Reporting Manager</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Attempt</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        
    </div>

    <div class="modal fade" id="inductionset_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="inductionset_errmsg"></h6>
                </div>
                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="inductionset_btnMessage" onclick="return inductionset_Message();">Okay</button>
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
            /*  background-color: #ccc;*/
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
            /*     background-color: #28a745;
            border-color: #28a745;*/
            box-shadow: none;
            background: linear-gradient(to right, #ffbf96, #fe7096);
            border: 0;
            font-weight: bold;
            margin: 0px 10px;
        }

        .table.dataTable th {
            background: linear-gradient(to bottom, #007bff, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
        }
        /*.form-control {
            font-size: 11px !important;
        }*/
    </style>

    <script>
        $(document).ready(function () {
            inductionset_BindGrid();
            checkpaper_BindYear();
            indreport_BindYear();
        });

        window.onload = function () {
            document.getElementById('inductionset_attachment').addEventListener('change', getFileName);
        }

        const getFileName = (event) => {
            const files = event.target.files;
            var file = files[0];
            document.getElementById("filep").value = files[0].name;

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
            document.getElementById("filesdiv").innerHTML = file.name;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="filep" style="display: none;" />
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>HR Induction</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <div class="card card-tabs">
                    <div class="card-header p-0 pt-1">
                        <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Question Set</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">Check Question Paper</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-messages-tab" data-toggle="pill" href="#custom-tabs-one-messages" role="tab" aria-controls="custom-tabs-one-messages" aria-selected="false">Induction Report</a>
                            </li>
                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                                <table class="table">
                                    <tr>
                                        <td><b>Question:</b></td>
                                        <td colspan="3">
                                            <textarea id="inductionset_question" name="inductionset_question" class="form-control" style="width: 600px;"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><b>Weightage:</b></td>
                                        <td>
                                            <input type="number" id="inductionset_weightage" name="inductionset_weightage" class="form-control" style="width: 300px;" />
                                        </td>
                                        <td><b>Attachment:</b></td>
                                        <td>
                                            <input type="file" id="inductionset_attachment" name="inductionset_attachment" class="form-control" style="width: 300px;" />
                                            <div class="dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete" id="dropzone">
                                                <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column" id="conentdiv" style="display: none!important;">
                                                    <div class="flex-1 d-flex flex-between-center">
                                                        <div id="filesdiv" style="margin-top: 10px; margin-bottom: 10px;"></div>
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
                                    </tr>
                                    <tr>
                                        <td><b>Option 1:</b></td>
                                        <td>
                                            <input type="text" id="inductionset_option1" name="inductionset_option1" class="form-control" style="width: 300px; display: inline;" />
                                            <input type="checkbox" class="custom-checkbox" id="option1" />
                                        </td>
                                        <td><b>Option 2:</b></td>
                                        <td>
                                            <input type="text" id="inductionset_option2" name="inductionset_option2" class="form-control" style="width: 300px; display: inline;" />
                                            <input type="checkbox" class="custom-checkbox" id="option2" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><b>Option 3:</b></td>
                                        <td>
                                            <input type="text" id="inductionset_option3" name="inductionset_option3" class="form-control" style="width: 300px; display: inline;" />
                                            <input type="checkbox" class="custom-checkbox" id="option3" />
                                        </td>
                                        <td><b>Option 4:</b></td>
                                        <td>
                                            <input type="text" id="inductionset_option4" name="inductionset_option4" class="form-control" style="width: 300px; display: inline;" />
                                            <input type="checkbox" class="custom-checkbox" id="option4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" style="text-align: center;">
                                            <button id="inductionset_btnsubmit" class="btn btn-primary" onclick="return inductionset_submit();">Submit</button>
                                        </td>
                                    </tr>
                                </table>
                                <hr />
                                <table class="table" id="inductionset_table" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Question</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Weightage</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Option 1</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Option 2</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Option 3</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Option 4</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Answer</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added By</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added Date</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>

                                </table>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                                <table class="table">
                                    <tr>
                                        <td style="width: 50px;"><b>Month:</b></td>
                                        <td style="width: 150px;">
                                            <select id="checkpaper_month" name="checkpaper_month" class="form-control">
                                                <option value="">Select</option>
                                                <option value="January">January</option>
                                                <option value="February">February</option>
                                                <option value="March">March</option>
                                                <option value="April">April</option>
                                                <option value="May">May</option>
                                                <option value="June">June</option>
                                                <option value="July">July</option>
                                                <option value="August">August</option>
                                                <option value="September">September</option>
                                                <option value="October">October</option>
                                                <option value="November">November</option>
                                                <option value="December">December</option>
                                            </select>
                                        </td>
                                        <td style="width: 50px;">
                                            <b>Year:</b>
                                        </td>
                                        <td style="width: 150px;">
                                            <select id="checkpaper_year" name="checkpaper_year" class="form-control">
                                                <option value="">Select</option>
                                            </select>
                                        </td>
                                        <td style="width: 100px;">
                                            <button id="checkpaper_btnShow" class="btn btn-primary" onclick="return checkpaper_Submit()">Show</button>
                                        </td>
                                    </tr>
                                </table>
                                <hr />
                                <table class="table" id="checkpaper_table" style="padding-top: 10px; width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="display: none;">Employee ID</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Answer Sheet</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Employee Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Result</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Exam Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Attempt</th>
                                        </tr>

                                    </thead>
                                    <tbody></tbody>

                                </table>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-messages" role="tabpanel" aria-labelledby="custom-tabs-one-messages-tab">
                                <table class="table">
                                    <tr>
                                        <td style="width: 50px;"><b>Month:</b></td>
                                        <td style="width: 150px;">
                                            <select id="indreport_month" name="indreport_month" class="form-control">
                                                <option value="">Select</option>
                                                <option value="All">All</option>
                                                <option value="January">January</option>
                                                <option value="February">February</option>
                                                <option value="March">March</option>
                                                <option value="April">April</option>
                                                <option value="May">May</option>
                                                <option value="June">June</option>
                                                <option value="July">July</option>
                                                <option value="August">August</option>
                                                <option value="September">September</option>
                                                <option value="October">October</option>
                                                <option value="November">November</option>
                                                <option value="December">December</option>
                                            </select>
                                        </td>
                                        <td style="width: 50px;">
                                            <b>Year:</b>
                                        </td>
                                        <td style="width: 150px;">
                                            <select id="indreport_year" name="indreport_year" class="form-control">
                                                <option value="">Select</option>
                                            </select>
                                        </td>
                                        <td style="width: 100px;">
                                            <button id="indreport_btnShow" class="btn btn-primary" onclick="return indreportsummary_bindgrid()">Show</button>
                                        </td>
                                    </tr>
                                </table>
                                <hr />
                                <h6 style="text-decoration:underline;">Summary</h6><br />
                                <table class="table" id="indreport_table" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Total</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Completed</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Pending</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                                <h6 style="text-decoration:underline;">Details</h6>
                                <table class="table" id="indreportdetail_table" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Exam Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Result</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Marks Obtained</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Percentage</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Joining Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Department</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Designation</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Reporting Manager</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Attempt</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>


                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="inductionset_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="inductionset_errmsg"></h6>
                                   </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="inductionset_btnMessage" onclick="return inductionset_Message();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>--%>
