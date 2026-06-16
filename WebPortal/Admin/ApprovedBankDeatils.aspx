<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ApprovedBankDeatils.aspx.cs" Inherits="WebPortal.Admin.ApprovedBankDeatils" %>


<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <style>
        .col-4 {
            max-width: 100% !important;
        }

        :root {
            --resg-blue: #2563eb;
            --resg-green: #059669;
            --resg-red: #dc2626;
            --resg-ink: #0f172a;
            --resg-muted: #64748b;
            --resg-border: #d8e2ee;
            --resg-surface: #ffffff;
            --resg-soft: #f4f7fb;
        }

        .resignation-page {
            color: var(--resg-ink);
            font-size: 13px;
           /* padding: 16px 0 26px;*/
        }

        .resignation-shell {
            width: 100%;
            max-width: 1480px;
            margin: 0 auto;
        }

        .resignation-hero {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            min-height: 78px;
            padding: 16px 18px;
            border: 1px solid var(--resg-border);
            border-radius: 15px;
           /* background: linear-gradient(135deg, #0f172a 0%, #1d4ed8 56%, #0891b2 100%);*/
           background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            color: #fff;
            box-shadow: 0 14px 32px rgba(15, 23, 42, .12);
        }

        .resignation-title {
            display: flex;
            align-items: center;
            gap: 13px;
            min-width: 0;
        }

            .resignation-title .icon-box {
                width: 44px;
                height: 44px;
                border-radius: 8px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                background: rgba(255,255,255,.15);
                font-size: 18px;
            }

            .resignation-title h1 {
                margin: 0;
                font-size: 22px;
                font-weight: 800;
                line-height: 1.15;
                letter-spacing: 0;
            }

            .resignation-title p {
                margin: 4px 0 0;
                color: rgba(255,255,255,.78);
                font-size: 12px;
            }

        .resignation-chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 12px;
            border-radius: 999px;
            background: rgba(255,255,255,.14);
            font-weight: 800;
            white-space: nowrap;
        }

        .resignation-panel {
            margin-top: 14px;
            border: 1px solid var(--resg-border);
            border-radius: 8px;
            background: var(--resg-surface);
            box-shadow: 0 10px 28px rgba(15, 23, 42, .07);
            overflow: hidden;
        }

        .resignation-tabs {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            padding: 10px 10px 0;
            border-bottom: 1px solid var(--resg-border);
            background: #f8fafc;
        }

            .resignation-tabs .nav-link {
                border: 1px solid transparent !important;
                border-radius: 8px 8px 0 0 !important;
                color: #334155;
                font-size: 12px;
                font-weight: 800;
                padding: 10px 13px;
            }

                .resignation-tabs .nav-link.active {
                    color: var(--resg-blue) !important;
                    border-color: var(--resg-border) var(--resg-border) #fff !important;
                    background: #fff !important;
                }

        .resignation-pane {
            padding: 16px;
        }

        .section-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 14px;
        }

        .section-title {
            display: flex;
            align-items: center;
            gap: 10px;
        }

            .section-title i {
                width: 34px;
                height: 34px;
                border-radius: 8px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                background: #eaf2ff;
                color: var(--resg-blue);
            }

            .section-title h2 {
                margin: 0;
                font-size: 16px;
                font-weight: 800;
                letter-spacing: 0;
            }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(12, minmax(0, 1fr));
            gap: 13px 16px;
            align-items: end;
        }

        .field {
            min-width: 0;
        }

            .field.col-3 {
                grid-column: span 3;
            }

            .field.col-4 {
                grid-column: span 4;
            }

            .field.col-6 {
                grid-column: span 6;
            }

            .field.col-8 {
                grid-column: span 8;
            }

            .field.col-12 {
                grid-column: span 12;
            }

            .field label {
                display: block;
                margin: 0 0 6px;
                color: #1e3356;
                font-size: 11px;
                font-weight: 800;
            }

        .required {
            color: var(--resg-red);
        }

        .form-control {
            height: calc(2.25rem + 2px) !important;
        }

        .resignation-page .form-control,
        .resignation-page select,
        .resignation-page input,
        .resignation-page textarea {
            width: 100% !important;
            min-height: 38px;
            border: 1px solid var(--resg-border) !important;
            border-radius: 8px !important;
            box-shadow: none !important;
            font-size: 12px !important;
            color: var(--resg-ink);
        }

            .resignation-page textarea.form-control {
                min-height: 82px;
                resize: vertical;
            }

        .readonly-soft {
            background: #f8fafc !important;
            color: #475569 !important;
        }

        .file-shell {
            display: flex;
            align-items: center;
            gap: 10px;
            min-height: 38px;
            padding: 7px 10px;
            border: 1px dashed #aebfd3;
            border-radius: 8px;
            background: #f8fbff;
        }

            .file-shell input {
                border: 0 !important;
                padding: 0 !important;
                min-height: auto;
                background: transparent;
            }

        .file-name {
            display: none;
            margin-top: 7px;
            color: var(--resg-blue);
            font-weight: 800;
            font-size: 12px;
        }

        .actions-row {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            padding-top: 8px;
            border-top: 1px dashed var(--resg-border);
        }

        .btn-resg {
            min-height: 36px;
            border: 0;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 8px 14px;
            font-size: 12px;
            font-weight: 800;
            cursor: pointer;
        }

        .btn-resg-primary {
            color: #fff;
            background: var(--resg-blue);
        }

        .btn-resg-green {
            color: #fff;
            background: var(--resg-green);
        }

        .btn-resg-red {
            color: #fff;
            background: var(--resg-red);
        }

        .btn-resg-soft {
            color: #1e3356;
            background: #edf3f9;
            border: 1px solid var(--resg-border);
        }

        .table-shell {
            width: 100%;
            overflow: auto;
            border: 1px solid var(--resg-border);
            border-radius: 8px;
            background: #fff;
        }

        .resignation-page table.dataTable,
        .resignation-page .table {
            width: 100% !important;
            margin: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0 !important;
        }

            .resignation-page table.dataTable thead th,
            .resignation-page .table thead th {
                white-space: nowrap !important;
                background: #f8fafc !important;
                color: #1e3356 !important;
                border-bottom: 1px solid var(--resg-border) !important;
                padding: 10px 12px !important;
                font-size: 11px !important;
                font-weight: 900 !important;
                vertical-align: middle !important;
            }

            .resignation-page table.dataTable tbody td,
            .resignation-page .table tbody td {
                background: #fff !important;
                border-top: 1px solid #eef2f7 !important;
                color: #1f2937 !important;
                padding: 10px 12px !important;
                font-size: 12px !important;
                vertical-align: middle !important;
            }

        .resignation-page .dataTables_wrapper {
            padding: 12px;
        }

        .resignation-page .dt-buttons .btn,
        .resignation-page .dt-button {
            border-radius: 8px !important;
            border: 1px solid var(--resg-border) !important;
            background: #fff !important;
            color: #1e3356 !important;
            font-size: 12px !important;
            font-weight: 800 !important;
            padding: 6px 10px !important;
            margin-right: 6px;
        }

        .action-menu .dropdown-toggle {
            width: 34px;
            height: 34px;
            border-radius: 8px;
            border: 1px solid var(--resg-border);
            background: #fff;
            color: var(--resg-blue);
        }

        .status-pill {
            display: inline-flex;
            align-items: center;
            border-radius: 999px;
            padding: 4px 9px;
            font-size: 11px;
            font-weight: 800;
            background: #eef6ff;
            color: #1d4ed8;
        }

        .detail-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 12px 16px;
        }

        .detail-item label {
            display: block;
            margin: 0 0 5px;
            color: var(--resg-muted);
            font-size: 11px;
            font-weight: 800;
        }

        .detail-value {
            min-height: 38px;
            padding: 9px 10px;
            border: 1px solid var(--resg-border);
            border-radius: 8px;
            background: #f8fafc;
            color: #1f2937;
            word-break: break-word;
        }

        #load1.loading {
            display: none;
            position: fixed !important;
            top: 0 !important;
            left: 0 !important;
            right: 0 !important;
            bottom: 0 !important;
            width: 100vw !important;
            height: 100vh !important;
            margin: 0 !important;
            padding: 0 !important;
            background: rgba(15, 23, 42, .42) !important;
            z-index: 2147483000 !important;
            text-align: center;
            backdrop-filter: blur(4px);
        }

        #load1 .loading-inner {
            position: absolute !important;
            top: 50% !important;
            left: 50% !important;
            transform: translate(-50%, -50%) !important;
            width: min(280px, calc(100vw - 32px));
            max-width: calc(100vw - 32px);
            border-radius: 22px;
            background: #fff;
            padding: 24px 22px;
            box-shadow: 0 24px 55px rgba(15, 23, 42, .28);
        }

        #load1.loading img {
            display: block;
            width: 82px;
            max-width: 82px;
            height: auto;
            margin: 0 auto;
        }

        .loading-text {
            margin-top: 10px;
            font-size: 13px;
            font-weight: 800;
            color: var(--resg-ink);
        }

        @media (max-width: 1100px) {
            .field.col-3,
            .field.col-4,
            .field.col-6,
            .field.col-8 {
                grid-column: span 6;
            }
        }

        @media (max-width: 760px) {
            .resignation-hero,
            .section-head {
                align-items: flex-start;
                flex-direction: column;
            }

            .field.col-3,
            .field.col-4,
            .field.col-6,
            .field.col-8,
            .field.col-12,
            .detail-grid {
                grid-column: span 12;
                grid-template-columns: 1fr;
            }

            .actions-row {
                justify-content: stretch;
                flex-direction: column;
            }
        }

        #app_approvebutton {
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
        }
    </style>

    <script>
        $(document).ready(function () {

            change_bindBankName();
            change_bindUsers();
        });

        // function showTabsByRights(logId) {
        //     const navApproveAcc = document.getElementById("nav_ApproveAcc");

        //     if (logId === 7036 || logId === 255 || logId === 291) {
        //         navApproveAcc.style.display = "";
        //     } else {
        //         navApproveAcc.style.display = "none";
        //     }
        // }

        var fileslist = '';
        var fd = new FormData();

        window.onload = function () {

            document.getElementById('fpBankProof').addEventListener('change', cp_getFileName);
        }

        const cp_getFileName = (event) => {

            for (var i = 0; i < event.target.files.length; i++) {

                const files = event.target.files;
                var file = files[i];
                document.getElementById("bank_attachment").value = files[i].name;

                if (fileslist != '')
                    fileslist = fileslist + ',' + file.name;
                else
                    fileslist = file.name;

                // add all selected files
                fd.append(event.target.name, file, file.name);

                // create the request
            }

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

        }

    </script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <input id="bank_attachment" style="display: none;" />

    <div class="loading" id="load1">
        <div class="loading-inner">
            <img src="../images/Load_1.gif" alt="Loading" />
            <div class="loading-text">One moment, please...</div>
        </div>
    </div>

    <div class="resignation-page">
        <div class="resignation-shell">
            <header class="resignation-hero">
                <div class="resignation-title">
                    <span class="icon-box"><i class="fas fa-university"></i></span>
                    <div>
                        <h1>Change/Approve Bank Account </h1>
                        <p>Submit, review, and approve employee bank account changes.</p>
                    </div>
                </div>
            </header>

            <section class="resignation-panel">
                <ul class="nav nav-tabs resignation-tabs" id="resignationTabs" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link active" id="nav_changeAcc" data-toggle="pill" href="#tab-changeAcc" role="tab" aria-controls="tab-changeAcc" aria-selected="true">
                            <i class="fas fa-university"></i>&nbsp;&nbsp;Change Bank Account
                      </a>
                    </li>
                    <li class="nav-item" id="nav_ApproveAcc" runat="server" onclick="return bank_BindApprovalData();">
                        <a class="nav-link" id="tab-approveAcc-link" data-toggle="pill" href="#tab-approveAcc" role="tab" aria-controls="tab-approveAcc" aria-selected="false" data-resg-load="approveAcc">
                            <i class="fas fa-check-circle"></i>&nbsp;&nbsp;Approve Bank Account 
                      </a>
                    </li>
                </ul>
                <div class="tab-content">
                    <div class="tab-pane fade show active resignation-pane" id="tab-changeAcc" role="tabpanel" aria-labelledby="tab-changeAcc-link">
                        <div class="section-head">
                            <div class="section-title">
                                <i class="fas fa-university"></i>
                                <h2>Add New Bank Account Details</h2>
                            </div>
                        </div>

                        <div class="form-grid">
                            <div class="field col-4">
                                <label for="bank_Employee"><span class="required">*</span>&nbsp;Employee</label>
                                <select id="bank_Employee" class="form-control" required>
                                    <option value="">Select</option>
                                </select>
                            </div>
                            <div class="field col-4">
                                <label for="bank_BankName"><span class="required">*</span>&nbsp;Bank Name </label>
                                <select id="bank_BankName" class="form-control" required>
                                    <option value="">Select</option>
                                </select>
                            </div>
                            <div class="field col-4">
                                <label for="bank_AccountNo"><span class="required">*</span>&nbsp;Account # </label>
                                <input id="bank_AccountNo" class="form-control" required inputmode="numeric" maxlength="18" />
                            </div>
                            <div class="field col-4">
                                <label for="bank_ReAccountNo"><span class="required">*</span>&nbsp;Re-enter Account # </label>
                                <input id="bank_ReAccountNo" class="form-control" required inputmode="numeric" maxlength="18" />
                            </div>
                            <div class="field col-4">
                                <label for="bank_IFSCCode"><span class="required">*</span>&nbsp;IFSC Code</label>
                                <input id="bank_IFSCCode" type="text" class="form-control" required maxlength="11" style="text-transform: uppercase;" pattern="^[A-Z]{4}0[A-Z0-9]{6}$" />
                            </div>
                            <div class="field col-4">
                                <label for="bank_ReIFSCCode"><span class="required">*</span>&nbsp;Re-enter IFSC Code </label>
                                <input id="bank_ReIFSCCode" type="text" class="form-control" required maxlength="11" style="text-transform: uppercase;" pattern="^[A-Z]{4}0[A-Z0-9]{6}$" />
                            </div>
                            <div class="field col-6">
                                <label for="fpBankProof">Attachment (Bank Proof)</label>
                                <div class="file-shell">
                                    <i class="fas fa-paperclip" style="color: var(--resg-blue);"></i>
                                    <input type="file" id="fpBankProof" name="fpBankProof" class="form-control" accept=".pdf,.jpg,.jpeg,.png,.xlsx" />
                                </div>
                                <div id="bank_BankProof" class="file-name"></div>
                            </div>

                            <div class="field col-12 actions-row">
                                <button type="button" class="btn-resg btn-resg-primary" id="bank_btnAccSave" onclick="return saveBankDetails();"><i class="fas fa-paper-plane"></i>Submit Bank Details</button>
                            </div>
                        </div>
                    </div>

                    <div class="tab-pane fade resignation-pane" id="tab-approveAcc" role="tabpanel" aria-labelledby="tab-approveAcc-link">
                        <div class="section-head">
                            <div class="section-title">
                                <i class="fas fa-check-circle"></i>
                                <h2>Approve Bank Account Details</h2>
                            </div>
                            <button type="button" class="btn-resg btn-resg-soft" data-resg-refresh="approveAcc"><i class="fas fa-sync-alt"></i>Refresh</button>
                        </div>
                        <div class="table-shell">
                            <table class="table" id="bankapprv_list" style="width: 100%;">
                                <thead>
                                    <tr>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Actions</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                        <th class="sort border-top ps-3" style="display: none;">AccNoChangeID</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">TicketNo</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Department</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Designation</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Domain</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Reporting Manager</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added By</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added Date</th>
                                        <th class="sort border-top ps-3" style="display: none;">Attachment</th>
                                        <th class="sort border-top ps-3" style="display: none;">OldBankName</th>
                                        <th class="sort border-top ps-3" style="display: none;">OldBankAccNo</th>
                                        <th class="sort border-top ps-3" style="display: none;">OldBankIFSCCode</th>
                                        <th class="sort border-top ps-3" style="display: none;">NewBankName</th>
                                        <th class="sort border-top ps-3" style="display: none;">NewBankAccNo</th>
                                        <th class="sort border-top ps-3" style="display: none;">NewBankIFSCCode</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </div>

    <div class="modal fade" id="bankapprv_Approval" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="bankapprv_ApprovalLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl" role="document">
            <div class="modal-content border-0 shadow-lg">

                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="bankapprv_ApprovalLabel">
                        <i class="fas fa-check-circle mr-2"></i>
                        <span id="app_bankDetailsHeader"></span>
                    </h5>
                    <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>

                <div class="modal-body bg-light">

                    <div class="row" id="bankapprv_bankDetailsRow">

                        <!-- Old Bank Details -->
                        <div class="col-md-6" id="bankapprv_oldBankCard">
                            <div class="card border-0 shadow-sm mb-3 h-100">
                                <div class="card-header bg-white border-bottom">
                                    <h6 class="mb-0 font-weight-bold text-secondary">Old Bank Account Details
                                    </h6>
                                </div>

                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-4 mb-3">
                                            <small class="text-muted d-block">Bank Name</small>
                                            <div class="font-weight-bold" id="bankapprv_oldbankname"></div>
                                        </div>

                                        <div class="col-md-4 mb-3">
                                            <small class="text-muted d-block">Account #</small>
                                            <div class="font-weight-bold" id="bankapprv_oldaccno"></div>
                                        </div>

                                        <div class="col-md-4 mb-3">
                                            <small class="text-muted d-block">IFSC Code</small>
                                            <div class="font-weight-bold" id="bankapprv_oldifsc"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- New Bank Details -->
                        <div class="col-md-6" id="bankapprv_newBankCol">
                            <div class="card border-0 shadow-sm mb-3 h-100">
                                <div class="card-header bg-white border-bottom">
                                    <h6 class="mb-0 font-weight-bold text-primary">New Bank Account Details
                                    </h6>
                                </div>

                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-4 mb-3">
                                            <small class="text-muted d-block">Bank Name</small>
                                            <div class="font-weight-bold text-primary" id="bankapprv_newbankname"></div>
                                        </div>

                                        <div class="col-md-4 mb-3">
                                            <small class="text-muted d-block">Account #</small>
                                            <div class="font-weight-bold text-primary" id="bankapprv_newaccno"></div>
                                        </div>

                                        <div class="col-md-4 mb-3">
                                            <small class="text-muted d-block">IFSC Code</small>
                                            <div class="font-weight-bold text-primary" id="bankapprv_newifsc"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>

                    <!-- Status and Remark -->
                    <div class="card border-0 shadow-sm mt-3">
                        <div class="card-body">

                            <div class="row align-items-start">
                                <div class="col-md-3">
                                    <label class="font-weight-bold">
                                        Status <span class="text-danger">*</span>
                                    </label>
                                    <select id="bankapprv_status" name="bankapprv_status" class="form-control">
                                        <option value="">Select</option>
                                        <option value="True">Approve</option>
                                        <option value="False">Reject</option>
                                    </select>
                                </div>

                                <div class="col-md-9">
                                    <label class="font-weight-bold">Remark</label>
                                    <textarea id="bankapprv_remark"
                                        class="form-control"
                                        rows="2"
                                        placeholder="Enter remark..."></textarea>
                                </div>
                            </div>

                            <div class="row mt-3">
                                <div class="col-md-12">
                                    <div class="custom-control custom-checkbox">
                                        <input type="checkbox" id="bankapprv_checkverify" class="custom-control-input" />
                                        <label class="custom-control-label text-danger font-weight-bold" for="bankapprv_checkverify">
                                            I have verified the bank name, account number, and IFSC code against the attached proof.
                                        </label>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>

                </div>

                <div class="modal-footer bg-white justify-content-between">
                    <button type="button" class="btn btn-outline-secondary" data-dismiss="modal">
                        Close
                    </button>
                    <button type="button" id="app_approvebutton" class="btn btn-primary px-4" onclick="return bankapprv_submit();">
                        Submit
                    </button>
                </div>

            </div>
        </div>
    </div>

</asp:Content>

