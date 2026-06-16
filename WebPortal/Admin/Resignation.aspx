<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Resignation.aspx.cs" Inherits="WebPortal.Admin.Resignation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
            padding: 16px 0 26px;
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
            border-radius: 8px;
            background: linear-gradient(135deg, #0f172a 0%, #1d4ed8 56%, #0891b2 100%);
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
            color: var(--ac-text);
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
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
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
                    <span class="icon-box"><i class="fas fa-user-minus"></i></span>
                    <div>
                        <h1>Employee Resignation</h1>
                        <p>Initiate, approve, revise, and complete dropout processing.</p>
                    </div>
                </div>
                <span class="resignation-chip"><i class="fas fa-briefcase"></i>HRMS</span>
            </header>

            <section class="resignation-panel">
                <ul class="nav nav-tabs resignation-tabs" id="resignationTabs" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link active" id="tab-initiate-link" data-toggle="pill" href="#tab-initiate" role="tab" aria-controls="tab-initiate" aria-selected="true">
                            <i class="fas fa-file-signature"></i>Step 1 : Initiate Resignation
                        </a>
                    </li>
                    <li class="nav-item" id="nav2" runat="server">
                        <a class="nav-link" id="tab-finalize-link" data-toggle="pill" href="#tab-finalize" role="tab" aria-controls="tab-finalize" aria-selected="false" data-resg-load="finalize">
                            <i class="fas fa-check-circle"></i>Step 2 : Finalise Resignation
                        </a>
                    </li>
                    <li class="nav-item" id="nav3" runat="server">
                        <a class="nav-link" id="tab-dropout-link" data-toggle="pill" href="#tab-dropout" role="tab" aria-controls="tab-dropout" aria-selected="false" data-resg-load="dropout">
                            <i class="fas fa-user-slash"></i>Step 3 : Dropout Employee
                        </a>
                    </li>
                    <li class="nav-item" id="nav4" runat="server">
                        <a class="nav-link" id="tab-edit-link" data-toggle="pill" href="#tab-edit" role="tab" aria-controls="tab-edit" aria-selected="false" data-resg-load="edit">
                            <i class="fas fa-edit"></i>Edit Finalized Resignations
                        </a>
                    </li>
                    <li class="nav-item" id="nav5" runat="server">
                        <a class="nav-link" id="tab-direct-link" data-toggle="pill" href="#tab-direct" role="tab" aria-controls="tab-direct" aria-selected="false" data-resg-load="direct">
                            <i class="fas fa-bolt"></i>Direct Dropout
                        </a>
                    </li>
                </ul>

                <div class="tab-content">
                    <div class="tab-pane fade show active resignation-pane" id="tab-initiate" role="tabpanel" aria-labelledby="tab-initiate-link">
                        <div class="section-head">
                            <div class="section-title">
                                <i class="fas fa-file-signature"></i>
                                <h2>Initiate Resignation</h2>
                            </div>
                        </div>

                        <div class="form-grid">
                            <div class="field col-4">
                                <label for="resgEmployeeCode">Code <span class="required">*</span></label>
                                <select id="resgEmployeeCode" class="form-control" style="width: 250px;" required>
                                    <option value="">Select</option>
                                </select>
                            </div>
                            <div class="field col-4">
                                <label for="resgName">Name</label>
                                <input id="resgName" class="form-control readonly-soft" readonly="readonly" style="width: 250px;" />
                            </div>
                            <div class="field col-4">
                                <label for="resgDepartment">Department</label>
                                <input id="resgDepartment" class="form-control readonly-soft" readonly="readonly" style="width: 250px;" />
                            </div>
                            <div class="field col-4">
                                <label for="resgJoiningDate">Joining Date</label>
                                <input id="resgJoiningDate" class="form-control readonly-soft" readonly="readonly" style="width: 250px;" />
                            </div>
                            <div class="field col-4">
                                <label for="resgDesignation">Designation</label>
                                <input id="resgDesignation" class="form-control readonly-soft" readonly="readonly" style="width: 250px;" />
                            </div>
                            <div class="field col-4">
                                <label for="resgContact">Contact # <span class="required">*</span></label>
                                <input id="resgContact" type="number" min="0" class="form-control" required style="width: 250px;" />
                            </div>
                            <div class="field col-4" id="resgProjectField" style="display: none;">
                                <label for="resgProject">Project #</label>
                                <select id="resgProject" class="form-control" style="width: 250px;">
                                    <option value="">Select</option>
                                </select>
                            </div>
                            <div class="field col-4" id="resgProcessField" style="display: none;">
                                <label for="resgProcess">Process #</label>
                                <select id="resgProcess" class="form-control" style="width: 250px;">
                                    <option value="">Select</option>
                                </select>
                            </div>
                            <div class="field col-4">
                                <label for="resgType">Resignation Type <span class="required">*</span></label>
                                <select id="resgType" class="form-control" required style="width: 250px;">
                                    <option value="">Select</option>
                                    <option value="Absconding">Absconding</option>
                                    <option value="Immediate">Immediate</option>
                                    <option value="Normal">Normal</option>
                                    <option value="Special">Special</option>
                                    <option value="Termination">Termination</option>
                                </select>
                            </div>
                            <div class="field col-4">
                                <label for="resgDate">Resignation Date <span class="required">*</span></label>
                                <input id="resgDate" type="date" class="form-control" style="width: 250px;" />
                            </div>
                            <div class="field col-4" id="resgLastWorkingField">
                                <label for="resgLastWorkingDate">Last Working Date <span class="required">*</span></label>
                                <input id="resgLastWorkingDate" type="date" class="form-control" style="width: 250px;" />
                            </div>
                            <div class="field col-4" id="resgLastLoginField" style="display: none;">
                                <label for="resgLastLoginDate">Latest Login Date</label>
                                <input id="resgLastLoginDate" class="form-control readonly-soft" readonly="readonly" style="width: 250px;" />
                            </div>
                            <div class="field col-4">
                                <label for="resgDays">No. of Days</label>
                                <input id="resgDays" class="form-control readonly-soft" readonly="readonly" style="width: 250px;" />
                            </div>
                            <div class="field col-12" id="resgTerminationReasonField" style="display: none;">
                                <label for="resgTerminationReason">Reason To Terminate</label>
                                <textarea id="resgTerminationReason" class="form-control" style="width: 250px;"></textarea>
                            </div>
                            <div class="field col-6">
                                <label for="fpAttachment">Attachment</label>
                                <div class="file-shell">
                                    <i class="fas fa-paperclip" style="color: var(--resg-blue);"></i>
                                    <input type="file" id="fpAttachment" name="fpAttachment" class="form-control" style="width: 250px;" />
                                </div>
                                <div id="resgFileName" class="file-name"></div>
                            </div>
                            <div class="field col-6">
                                <label for="resgRemark">Remark <span class="required">*</span></label>
                                <textarea id="resgRemark" class="form-control" onpaste="return false" style="width: 250px;"></textarea>
                            </div>
                            <div class="field col-12 actions-row">
                                <button type="button" class="btn-resg btn-resg-primary" id="btnInitiateResignation">
                                    <i class="fas fa-paper-plane"></i>Initiate Resignation
                               
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="tab-pane fade resignation-pane" id="tab-finalize" role="tabpanel" aria-labelledby="tab-finalize-link">
                        <div class="section-head">
                            <div class="section-title">
                                <i class="fas fa-check-circle"></i>
                                <h2>Finalize Resignation</h2>
                            </div>
                            <button type="button" class="btn-resg btn-resg-soft" data-resg-refresh="finalize"><i class="fas fa-sync-alt"></i>Refresh</button>
                        </div>
                        <div class="table-shell">
                            <table id="tblFinalize" class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>Action</th>
                                        <th>Code</th>
                                        <th>Name</th>
                                        <th>Joining Date</th>
                                        <th>Reporting Manager</th>
                                        <th>Resignation Type</th>
                                        <th>Resignation Date</th>
                                        <th>Last Working Date</th>
                                        <th>Remark</th>
                                        <th>Status</th>
                                        <th>Added Date</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>

                    <div class="tab-pane fade resignation-pane" id="tab-dropout" role="tabpanel" aria-labelledby="tab-dropout-link">
                        <div class="section-head">
                            <div class="section-title">
                                <i class="fas fa-user-slash"></i>
                                <h2>Dropout Employee</h2>
                            </div>
                            <button type="button" class="btn-resg btn-resg-soft" data-resg-refresh="dropout"><i class="fas fa-sync-alt"></i>Refresh</button>
                        </div>
                        <div class="table-shell">
                            <table id="tblDropout" class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>Action</th>
                                        <th>Code</th>
                                        <th>Name</th>
                                        <th>Joining Date</th>
                                        <th>Branch</th>
                                        <th>Resignation Type</th>
                                        <th>Resignation Date</th>
                                        <th>Last Working Date</th>
                                        <th>Step 1 Remark</th>
                                        <th>Step 2 Remark</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>

                    <div class="tab-pane fade resignation-pane" id="tab-edit" role="tabpanel" aria-labelledby="tab-edit-link">
                        <div class="section-head">
                            <div class="section-title">
                                <i class="fas fa-edit"></i>
                                <h2>Edit Finalized Resignations</h2>
                            </div>
                            <button type="button" class="btn-resg btn-resg-soft" data-resg-refresh="edit"><i class="fas fa-sync-alt"></i>Refresh</button>
                        </div>
                        <div class="table-shell">
                            <table id="tblEdit" class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>Action</th>
                                        <th>Code</th>
                                        <th>Name</th>
                                        <th>Joining Date</th>
                                        <th>Branch</th>
                                        <th>Resignation Type</th>
                                        <th>Resignation Date</th>
                                        <th>Last Working Date</th>
                                        <th>Step 1 Remark</th>
                                        <th>Step 2 Remark</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>

                    <div class="tab-pane fade resignation-pane" id="tab-direct" role="tabpanel" aria-labelledby="tab-direct-link">
                        <div class="section-head">
                            <div class="section-title">
                                <i class="fas fa-bolt"></i>
                                <h2>Direct Dropout</h2>
                            </div>
                            <button type="button" class="btn-resg btn-resg-soft" data-resg-refresh="direct"><i class="fas fa-sync-alt"></i>Refresh</button>
                        </div>
                        <div class="table-shell">
                            <table id="tblDirectDropout" class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>Action</th>
                                        <th>Code</th>
                                        <th>Name</th>
                                        <th>Joining Date</th>
                                        <th>Date Of Birth</th>
                                        <th>Project Manager</th>
                                        <th>Resignation Type</th>
                                        <th>Resignation Date</th>
                                        <th>Last Working Date</th>
                                        <th>Current Login</th>
                                        <th>Remark</th>
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

    <div class="modal fade" id="waitingpanel" tabindex="-1" data-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" alt="" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;">Processing. Please wait</span>
        </div>
    </div>

    <div class="modal fade" id="step2Modal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-xl" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Approve / Reject Resignation</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="step2ResignationId" />
                    <div class="detail-grid">
                        <div class="detail-item">
                            <label>Employee</label><div class="detail-value" id="step2Employee"></div>
                        </div>
                        <div class="detail-item">
                            <label>Joining Date</label><div class="detail-value" id="step2Joining"></div>
                        </div>
                        <div class="detail-item">
                            <label>Reporting Manager</label><div class="detail-value" id="step2Manager"></div>
                        </div>
                        <div class="detail-item">
                            <label>Resignation Type</label><div class="detail-value" id="step2Type"></div>
                        </div>
                        <div class="detail-item">
                            <label>Resignation Date</label><div class="detail-value" id="step2Date"></div>
                        </div>
                        <div class="detail-item">
                            <label>Last Working Date</label><div class="detail-value" id="step2LastWorking"></div>
                        </div>
                        <div class="detail-item">
                            <label>Step 1 Remark</label><div class="detail-value" id="step2Step1Remark"></div>
                        </div>
                        <div class="detail-item">
                            <label for="step2AttritionCategory">Attrition Category <span class="required">*</span></label>
                            <select id="step2AttritionCategory" class="form-control">
                                <option value="">Select</option>
                                <option value="Salary problem">Salary problem</option>
                                <option value="Got Another job">Got Another job</option>
                                <option value="Absconded">Absconded</option>
                                <option value="Personal Problem">Personal Problem</option>
                                <option value="Education Issue">Education Issue</option>
                                <option value="Health Problem">Health Problem</option>
                                <option value="Night Shift Problem">Night Shift Problem</option>
                                <option value="Terminated/Laid Off">Terminated/Laid Off</option>
                            </select>
                        </div>
                        <div class="detail-item">
                            <label for="step2ReceivedThrough">Resignation Received Through <span class="required">*</span></label>
                            <select id="step2ReceivedThrough" class="form-control">
                                <option value="">Select</option>
                                <option value="Self">Self</option>
                                <option value="Company">Company</option>
                            </select>
                        </div>
                        <div class="detail-item">
                            <label for="step2Status">Status <span class="required">*</span></label>
                            <select id="step2Status" class="form-control">
                                <option value="">Select</option>
                                <option value="Approve">Approve</option>
                                <option value="Reject">Reject</option>
                            </select>
                        </div>
                        <div class="detail-item" style="grid-column: 1 / -1;">
                            <label for="step2Remark">Step 2 Remark <span class="required">*</span></label>
                            <textarea id="step2Remark" class="form-control" maxlength="500"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn-resg btn-resg-soft" data-dismiss="modal">Close</button>
                    <button type="button" class="btn-resg btn-resg-primary" id="btnStep2Submit">Okay</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="dropoutModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-xl" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Delete User</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="dropoutResignationId" />
                    <div class="detail-grid">
                        <div class="detail-item">
                            <label>Employee</label><div class="detail-value" id="dropoutEmployee"></div>
                        </div>
                        <div class="detail-item">
                            <label>Joining Date</label><div class="detail-value" id="dropoutJoining"></div>
                        </div>
                        <div class="detail-item">
                            <label>Branch</label><div class="detail-value" id="dropoutBranch"></div>
                        </div>
                        <div class="detail-item">
                            <label>Resignation Type</label><div class="detail-value" id="dropoutType"></div>
                        </div>
                        <div class="detail-item">
                            <label>Resignation Date</label><div class="detail-value" id="dropoutDate"></div>
                        </div>
                        <div class="detail-item">
                            <label>Last Working Date</label><div class="detail-value" id="dropoutLastWorking"></div>
                        </div>
                        <div class="detail-item">
                            <label>Step 1 Remark</label><div class="detail-value" id="dropoutStep1Remark"></div>
                        </div>
                        <div class="detail-item">
                            <label>Step 2 Remark</label><div class="detail-value" id="dropoutStep2Remark"></div>
                        </div>
                        <div class="detail-item" style="grid-column: 1 / -1;">
                            <label for="dropoutRemark">Step 3 Remark <span class="required">*</span></label>
                            <textarea id="dropoutRemark" class="form-control" maxlength="500"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn-resg btn-resg-soft" data-dismiss="modal">Close</button>
                    <button type="button" class="btn-resg btn-resg-red" id="btnDropoutSubmit">Delete User</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="exitFormalityModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-xl" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Send Exit Formality Email</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="exitResignationId" />
                    <div class="detail-grid">
                        <div class="detail-item">
                            <label>Employee</label><div class="detail-value" id="exitEmployee"></div>
                        </div>
                        <div class="detail-item">
                            <label>Joining Date</label><div class="detail-value" id="exitJoining"></div>
                        </div>
                        <div class="detail-item">
                            <label>Branch</label><div class="detail-value" id="exitBranch"></div>
                        </div>
                        <div class="detail-item">
                            <label>Resignation Type</label><div class="detail-value" id="exitType"></div>
                        </div>
                        <div class="detail-item">
                            <label>Resignation Date</label><div class="detail-value" id="exitDate"></div>
                        </div>
                        <div class="detail-item">
                            <label>Last Working Date</label><div class="detail-value" id="exitLastWorking"></div>
                        </div>
                        <div class="detail-item">
                            <label>Step 1 Remark</label><div class="detail-value" id="exitStep1Remark"></div>
                        </div>
                        <div class="detail-item">
                            <label>Step 2 Remark</label><div class="detail-value" id="exitStep2Remark"></div>
                        </div>
                        <div class="detail-item" style="grid-column: 1 / -1;">
                            <label for="exitRemark">Exit Formality Remark <span class="required">*</span></label>
                            <textarea id="exitRemark" class="form-control" maxlength="500"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn-resg btn-resg-soft" data-dismiss="modal">Close</button>
                    <button type="button" class="btn-resg btn-resg-green" id="btnExitSubmit">Send Exit Formality Email</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="changeTypeModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-xl" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Change Resignation Type</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="changeResignationKey" />
                    <div class="detail-grid">
                        <div class="detail-item">
                            <label>Employee</label><div class="detail-value" id="changeEmployee"></div>
                        </div>
                        <div class="detail-item">
                            <label>Joining Date</label><div class="detail-value" id="changeJoining"></div>
                        </div>
                        <div class="detail-item">
                            <label>Branch</label><div class="detail-value" id="changeBranch"></div>
                        </div>
                        <div class="detail-item">
                            <label>Step 1 Remark</label><div class="detail-value" id="changeStep1Remark"></div>
                        </div>
                        <div class="detail-item">
                            <label>Step 2 Remark</label><div class="detail-value" id="changeStep2Remark"></div>
                        </div>
                        <div class="detail-item">
                            <label for="changeType">Resignation Type <span class="required">*</span></label>
                            <select id="changeType" class="form-control">
                                <option value="">Select</option>
                                <option value="Absconding">Absconding</option>
                                <option value="Immediate">Immediate</option>
                                <option value="Normal">Normal</option>
                                <option value="Special">Special</option>
                                <option value="Termination">Termination</option>
                            </select>
                        </div>
                        <div class="detail-item">
                            <label for="changeResignationDate">Resignation Date <span class="required">*</span></label>
                            <input id="changeResignationDate" type="date" class="form-control" />
                        </div>
                        <div class="detail-item">
                            <label for="changeLastWorkingDate">Last Working Date <span class="required">*</span></label>
                            <input id="changeLastWorkingDate" type="date" class="form-control" />
                        </div>
                        <div class="detail-item">
                            <label for="changeDays">No. of Days</label>
                            <input id="changeDays" class="form-control readonly-soft" readonly="readonly" />
                        </div>
                        <div class="detail-item" id="changeTerminationReasonField" style="display: none;">
                            <label for="changeTerminationReason">Reason To Terminate</label>
                            <textarea id="changeTerminationReason" class="form-control"></textarea>
                        </div>
                        <div class="detail-item" style="grid-column: 1 / -1;">
                            <label for="changeRemark">Remark <span class="required">*</span></label>
                            <textarea id="changeRemark" class="form-control" maxlength="500"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn-resg btn-resg-soft" data-dismiss="modal">Close</button>
                    <button type="button" class="btn-resg btn-resg-primary" id="btnChangeSubmit">Change Resignation Type</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="extendModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-xl" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Extend / Shorten Notice Period</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="extendResignationKey" />
                    <div class="detail-grid">
                        <div class="detail-item">
                            <label>Employee</label><div class="detail-value" id="extendEmployee"></div>
                        </div>
                        <div class="detail-item">
                            <label>Joining Date</label><div class="detail-value" id="extendJoining"></div>
                        </div>
                        <div class="detail-item">
                            <label>Branch</label><div class="detail-value" id="extendBranch"></div>
                        </div>
                        <div class="detail-item">
                            <label>Resignation Type</label><div class="detail-value" id="extendTypeCurrent"></div>
                        </div>
                        <div class="detail-item">
                            <label>Resignation Date</label><div class="detail-value" id="extendResignationDate"></div>
                        </div>
                        <div class="detail-item">
                            <label>Last Working Date</label><div class="detail-value" id="extendLastWorkingDate"></div>
                        </div>
                        <div class="detail-item">
                            <label>Step 1 Remark</label><div class="detail-value" id="extendStep1Remark"></div>
                        </div>
                        <div class="detail-item">
                            <label>Step 2 Remark</label><div class="detail-value" id="extendStep2Remark"></div>
                        </div>
                        <div class="detail-item">
                            <label for="extendType">Type <span class="required">*</span></label>
                            <select id="extendType" class="form-control">
                                <option value="">Select</option>
                                <option value="Extend">Extend</option>
                                <option value="Shorten">Shorten</option>
                            </select>
                        </div>
                        <div class="detail-item">
                            <label for="extendRevisedDate">Revised Date <span class="required">*</span></label>
                            <input id="extendRevisedDate" type="date" class="form-control" />
                        </div>
                        <div class="detail-item">
                            <label for="extendDays">No. of Days</label>
                            <input id="extendDays" class="form-control readonly-soft" readonly="readonly" />
                        </div>
                        <div class="detail-item" style="grid-column: 1 / -1;">
                            <label for="extendRemark">Remark <span class="required">*</span></label>
                            <textarea id="extendRemark" class="form-control" maxlength="500"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn-resg btn-resg-soft" data-dismiss="modal">Close</button>
                    <button type="button" class="btn-resg btn-resg-primary" id="btnExtendSubmit">Submit</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="cancelModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-xl" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Cancel Resignation</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="cancelResignationKey" />
                    <div class="detail-grid">
                        <div class="detail-item">
                            <label>Employee</label><div class="detail-value" id="cancelEmployee"></div>
                        </div>
                        <div class="detail-item">
                            <label>Joining Date</label><div class="detail-value" id="cancelJoining"></div>
                        </div>
                        <div class="detail-item">
                            <label>Branch</label><div class="detail-value" id="cancelBranch"></div>
                        </div>
                        <div class="detail-item">
                            <label>Resignation Type</label><div class="detail-value" id="cancelType"></div>
                        </div>
                        <div class="detail-item">
                            <label>Resignation Date</label><div class="detail-value" id="cancelDate"></div>
                        </div>
                        <div class="detail-item">
                            <label>Last Working Date</label><div class="detail-value" id="cancelLastWorking"></div>
                        </div>
                        <div class="detail-item">
                            <label>Step 1 Remark</label><div class="detail-value" id="cancelStep1Remark"></div>
                        </div>
                        <div class="detail-item">
                            <label>Step 2 Remark</label><div class="detail-value" id="cancelStep2Remark"></div>
                        </div>
                        <div class="detail-item" style="grid-column: 1 / -1;">
                            <label for="cancelRemark">Remark <span class="required">*</span></label>
                            <textarea id="cancelRemark" class="form-control" maxlength="500"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn-resg btn-resg-soft" data-dismiss="modal">Close</button>
                    <button type="button" class="btn-resg btn-resg-red" id="btnCancelSubmit">Cancel Resignation</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="directDropoutModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-xl" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Delete User</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="directResignationId" />
                    <div class="detail-grid">
                        <div class="detail-item">
                            <label>Employee</label><div class="detail-value" id="directEmployee"></div>
                        </div>
                        <div class="detail-item">
                            <label>Joining Date</label><div class="detail-value" id="directJoining"></div>
                        </div>
                        <div class="detail-item">
                            <label>Reporting Manager</label><div class="detail-value" id="directManager"></div>
                        </div>
                        <div class="detail-item">
                            <label>Resignation Type</label><div class="detail-value" id="directType"></div>
                        </div>
                        <div class="detail-item">
                            <label>Resignation Date</label><div class="detail-value" id="directDate"></div>
                        </div>
                        <div class="detail-item">
                            <label>Last Working Date</label><div class="detail-value" id="directLastWorking"></div>
                        </div>
                        <div class="detail-item">
                            <label>Step 1 Remark</label><div class="detail-value" id="directStep1Remark"></div>
                        </div>
                        <div class="detail-item">
                            <label>Step 2 Remark</label><div class="detail-value" id="directStep2Remark"></div>
                        </div>
                        <div class="detail-item" style="grid-column: 1 / -1;">
                            <label for="directRemark">Step 3 Remark <span class="required">*</span></label>
                            <textarea id="directRemark" class="form-control" maxlength="500"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn-resg btn-resg-soft" data-dismiss="modal">Close</button>
                    <button type="button" class="btn-resg btn-resg-red" id="btnDirectSubmit">Delete User</button>
                </div>
            </div>
        </div>
    </div>

    <script src="../Scripts/Functions/Resignation.js"></script>
</asp:Content>
