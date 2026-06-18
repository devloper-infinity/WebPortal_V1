<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="UsersAppreciationDisplinaryAction.aspx.cs" Inherits="WebPortal.Admin.UsersAppreciationDisplinaryAction" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --ad-blue: #1d4ed8;
            --ad-cyan: #0891b2;
            --ad-green: #059669;
            --ad-red: #dc2626;
            --ad-ink: #0f172a;
            --ad-muted: #64748b;
            --ad-border: #d8e2ee;
            --ad-soft: #f4f7fb;
            --ad-surface: #fff;
        }

        .ad-page {
            padding: 0px 0 26px;
            color: var(--ad-ink);
            font-size: 13px;
        }

        .ad-shell {
            width: 100%;
            max-width: 1480px;
            margin: 0 auto;
        }

        .ad-hero {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            min-height: 78px;
            padding: 16px 18px;
            border: 1px solid var(--ad-border);
            border-radius: 8px;
            color: #fff;
            background: linear-gradient(135deg, #0f172a 0%, var(--ad-blue) 56%, var(--ad-cyan) 100%);
            box-shadow: 0 14px 32px rgba(15, 23, 42, .12);
        }

        .ad-title {
            display: flex;
            align-items: center;
            gap: 13px;
            min-width: 0;
        }

        .ad-title .icon-box {
            width: 44px;
            height: 44px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.15);
            font-size: 18px;
        }

        .ad-title h1 {
            margin: 0;
            font-size: 22px;
            font-weight: 800;
            line-height: 1.15;
            letter-spacing: 0;
        }

        .ad-title p {
            margin: 4px 0 0;
            color: rgba(255,255,255,.78);
            font-size: 12px;
        }

        .ad-chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 12px;
            border-radius: 999px;
            background: rgba(255,255,255,.14);
            color: #fff;
            font-weight: 800;
            white-space: nowrap;
        }

        .ad-chip:hover {
            color: #fff;
            text-decoration: none;
            background: rgba(255,255,255,.2);
        }

        .ad-profile {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 12px;
            margin-top: 14px;
        }

        .ad-stat {
            min-height: 80px;
            padding: 13px 14px;
            border: 1px solid var(--ad-border);
            border-radius: 8px;
            background: #fff;
            box-shadow: 0 8px 24px rgba(15, 23, 42, .06);
        }

        .ad-stat label {
            display: block;
            margin: 0 0 5px;
            color: var(--ad-muted);
            font-size: 11px;
            font-weight: 800;
            text-transform: uppercase;
        }

        .ad-stat div {
            color: var(--ad-ink);
            font-size: 15px;
            font-weight: 800;
            word-break: break-word;
        }

        .ad-panel {
            margin-top: 14px;
            border: 1px solid var(--ad-border);
            border-radius: 8px;
            background: var(--ad-surface);
            box-shadow: 0 10px 28px rgba(15, 23, 42, .07);
            overflow: hidden;
        }

        .ad-tabs {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            padding: 10px 10px 0;
            border-bottom: 1px solid var(--ad-border);
            background: #f8fafc;
        }

        .ad-tabs .nav-link {
            border: 1px solid transparent !important;
            border-radius: 8px 8px 0 0 !important;
            color: #334155;
            font-size: 12px;
            font-weight: 800;
            padding: 10px 13px;
        }

        .ad-tabs .nav-link.active {
            color: var(--ad-blue) !important;
            border-color: var(--ad-border) var(--ad-border) #fff !important;
            background: #fff !important;
        }

        .ad-pane {
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
            color: var(--ad-blue);
        }

        .section-title h2 {
            margin: 0;
            font-size: 16px;
            font-weight: 800;
            letter-spacing: 0;
        }

        .table-shell {
            width: 100%;
            overflow: auto;
        }

        .ad-table {
            width: 100% !important;
            border-collapse: collapse;
        }

        .ad-table thead th {
            border-bottom: 1px solid var(--ad-border) !important;
            background: #f8fafc !important;
            color: #1e3356;
            font-size: 11px;
            font-weight: 900;
            text-transform: uppercase;
            white-space: nowrap;
        }

        .ad-table tbody td {
            vertical-align: middle;
            color: #172033;
            font-size: 12px;
            white-space: nowrap;
        }

        .ad-table tbody td.wrap {
            min-width: 220px;
            white-space: normal;
        }

        .btn-ad {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            min-height: 34px;
            padding: 7px 11px;
            border: 1px solid transparent;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 800;
            cursor: pointer;
        }

        .btn-ad-primary {
            color: #fff;
            background: var(--ad-blue);
            border-color: var(--ad-blue);
        }

        .btn-ad-primary:hover {
            color: #fff;
            background: #1e40af;
            border-color: #1e40af;
        }

        .btn-ad-soft {
            color: #1e3356;
            background: #fff;
            border-color: var(--ad-border);
        }

        .btn-ad-soft:hover {
            color: var(--ad-blue);
            background: #f8fafc;
        }

        .btn-ad-green {
            color: #fff;
            background: var(--ad-green);
            border-color: var(--ad-green);
        }

        .status-pill {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 70px;
            padding: 5px 9px;
            border-radius: 999px;
            background: #eef2ff;
            color: #3730a3;
            font-size: 11px;
            font-weight: 900;
        }

        .status-pill.closed {
            background: #d1fae5;
            color: #065f46;
        }

        .status-pill.extended {
            background: #fef3c7;
            color: #92400e;
        }

        .ad-message {
            display: none;
            margin: 14px 0 0;
            padding: 10px 12px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 800;
        }

        .ad-message.success {
            color: #065f46;
            background: #d1fae5;
            border: 1px solid #a7f3d0;
        }

        .ad-message.error {
            color: #991b1b;
            background: #fee2e2;
            border: 1px solid #fecaca;
        }

        .detail-grid {
            display: grid;
            grid-template-columns: repeat(12, minmax(0, 1fr));
            gap: 12px 14px;
        }

        .detail-item {
            grid-column: span 4;
            min-width: 0;
        }

        .detail-item.col-12 {
            grid-column: span 12;
        }

        .detail-item label {
            display: block;
            margin: 0 0 6px;
            color: #1e3356;
            font-size: 11px;
            font-weight: 800;
        }

        .detail-value {
            min-height: 38px;
            padding: 9px 11px;
            border: 1px solid var(--ad-border);
            border-radius: 8px;
            background: #f8fafc;
            color: var(--ad-ink);
            font-size: 12px;
            font-weight: 700;
            word-break: break-word;
        }

        .letter-box {
            min-height: 380px;
            padding: 28px;
            border: 1px solid var(--ad-border);
            border-radius: 8px;
            background: #fff;
            color: #111827;
            font-size: 13px;
            line-height: 1.55;
        }

        .letter-top {
            display: flex;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 18px;
        }

        .letter-subject {
            margin: 18px 0;
            padding: 12px 0;
            border-top: 1px solid var(--ad-border);
            border-bottom: 1px solid var(--ad-border);
            text-align: center;
            font-weight: 900;
        }

        #adLoader.ad-loading {
            display: none !important;
            position: fixed !important;
            inset: 0 !important;
            width: 100vw !important;
            height: 100vh !important;
            z-index: 999999 !important;
            background: rgba(248, 250, 252, .72);
        }

        #adLoader.ad-loading.is-visible {
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
        }

        #adLoader .loading-inner {
            width: 220px;
            min-height: 130px;
            padding: 22px;
            border: 1px solid var(--ad-border);
            border-radius: 8px;
            background: #fff;
            text-align: center;
            box-shadow: 0 20px 48px rgba(15, 23, 42, .18);
        }

        #adLoader .loading-inner img {
            width: 52px;
            height: 52px;
        }

        #adLoader .loading-text {
            margin-top: 12px;
            color: var(--ad-ink);
            font-size: 13px;
            font-weight: 800;
        }

        @media (max-width: 991px) {
            .ad-profile {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .detail-item {
                grid-column: span 6;
            }
        }

        @media (max-width: 640px) {
            .ad-hero,
            .section-head,
            .letter-top {
                align-items: flex-start;
                flex-direction: column;
            }

            .ad-profile {
                grid-template-columns: 1fr;
            }

            .detail-item,
            .detail-item.col-12 {
                grid-column: span 12;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="ad-loading" id="adLoader" aria-hidden="true">
        <div class="loading-inner">
            <img src="../images/Load_1.gif" alt="Loading" />
            <div class="loading-text">One moment, please...</div>
        </div>
    </div>

    <div class="ad-page">
        <div class="ad-shell">
            <header class="ad-hero">
                <div class="ad-title">
                    <span class="icon-box"><i class="fas fa-award"></i></span>
                    <div>
                        <h1>Appreciation & Disciplinary Actions</h1>
                        <p id="adHeroSubtitle">Employee action history and warning status management.</p>
                    </div>
                </div>
                <a class="ad-chip" href="SetAppreciationDisciplinaryAction.aspx"><i class="fas fa-arrow-left"></i>Back</a>
            </header>

            <div id="adMessage" class="ad-message"></div>

            <section class="ad-profile">
                <div class="ad-stat">
                    <label>Employee</label>
                    <div id="adEmployeeName">-</div>
                </div>
                <div class="ad-stat">
                    <label>Joining Date</label>
                    <div id="adJoiningDate">-</div>
                </div>
                <div class="ad-stat">
                    <label>Department</label>
                    <div id="adDepartment">-</div>
                </div>
                <div class="ad-stat">
                    <label>Reporting Manager</label>
                    <div id="adManager">-</div>
                </div>
            </section>

            <section class="ad-panel">
                <ul class="nav nav-tabs ad-tabs" id="adTabs" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link active" id="tab-appreciation-link" data-toggle="pill" href="#tab-appreciation" role="tab">
                            <i class="fas fa-star"></i>&nbsp;Appreciation <span id="countAppreciation" class="badge badge-light">0</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" id="tab-disciplinary-link" data-toggle="pill" href="#tab-disciplinary" role="tab">
                            <i class="fas fa-exclamation-triangle"></i>&nbsp;Disciplinary Action <span id="countDisciplinary" class="badge badge-light">0</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" id="tab-pip-link" data-toggle="pill" href="#tab-pip" role="tab">
                            <i class="fas fa-chart-line"></i>&nbsp;PIP <span id="countPip" class="badge badge-light">0</span>
                        </a>
                    </li>
                </ul>

                <div class="tab-content">
                    <div class="tab-pane fade show active ad-pane" id="tab-appreciation" role="tabpanel">
                        <div class="section-head">
                            <div class="section-title">
                                <i class="fas fa-star"></i>
                                <h2>Appreciation</h2>
                            </div>
                        </div>
                        <div class="table-shell">
                            <table id="tblAppreciation" class="table table-striped table-hover ad-table">
                                <thead>
                                    <tr>
                                        <th>Action</th>
                                        <th>Sr #</th>
                                        <th>Code</th>
                                        <th>Employee</th>
                                        <th>Title</th>
                                        <th>Added By</th>
                                        <th>Added Date</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>

                    <div class="tab-pane fade ad-pane" id="tab-disciplinary" role="tabpanel">
                        <div class="section-head">
                            <div class="section-title">
                                <i class="fas fa-exclamation-triangle"></i>
                                <h2>Disciplinary Action</h2>
                            </div>
                        </div>
                        <div class="table-shell">
                            <table id="tblDisciplinary" class="table table-striped table-hover ad-table">
                                <thead>
                                    <tr>
                                        <th>Action</th>
                                        <th>Sr #</th>
                                        <th>Code</th>
                                        <th>Employee</th>
                                        <th>Warning</th>
                                        <th>Added By</th>
                                        <th>Added Date</th>
                                        <th>Period</th>
                                        <th>Status</th>
                                        <th>PM Remark</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>

                    <div class="tab-pane fade ad-pane" id="tab-pip" role="tabpanel">
                        <div class="section-head">
                            <div class="section-title">
                                <i class="fas fa-chart-line"></i>
                                <h2>Performance Improvement Plan</h2>
                            </div>
                        </div>
                        <div class="table-shell">
                            <table id="tblPip" class="table table-striped table-hover ad-table">
                                <thead>
                                    <tr>
                                        <th>Action</th>
                                        <th>Sr #</th>
                                        <th>Code</th>
                                        <th>Employee</th>
                                        <th>Title</th>
                                        <th>Added By</th>
                                        <th>Added Date</th>
                                        <th>Period</th>
                                        <th>Status</th>
                                        <th>PM Remark</th>
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

    <div class="modal fade" id="adActionModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Take Action</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="adActionId" />
                    <div class="detail-grid">
                        <div class="detail-item col-12">
                            <label>Employee</label>
                            <div class="detail-value" id="adActionEmployee"></div>
                        </div>
                        <div class="detail-item">
                            <label for="adWarningStatus">Action</label>
                            <select id="adWarningStatus" class="form-control">
                                <option value="">Select</option>
                                <option value="Close">Close</option>
                                <option value="Extend">Extend</option>
                            </select>
                        </div>
                        <div class="detail-item" id="adPeriodWrap" style="display: none;">
                            <label for="adPeriod">Period</label>
                            <select id="adPeriod" class="form-control">
                                <option value="">Select</option>
                                <option value="5">5 Days</option>
                                <option value="10">10 Days</option>
                                <option value="15">15 Days</option>
                                <option value="20">20 Days</option>
                                <option value="25">25 Days</option>
                                <option value="30">30 Days</option>
                            </select>
                        </div>
                        <div class="detail-item col-12">
                            <label for="adActionRemark">Remark</label>
                            <textarea id="adActionRemark" class="form-control" maxlength="5000"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn-ad btn-ad-soft" data-dismiss="modal">Cancel</button>
                    <button type="button" class="btn-ad btn-ad-primary" id="btnAdActionSubmit"><i class="fas fa-save"></i>Submit</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="adDetailModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-xl" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Action Details</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                </div>
                <div class="modal-body">
                    <div class="letter-box" id="adLetter">
                        <div class="letter-top">
                            <div>
                                <div><strong>Code:</strong> <span id="adLetterCode"></span></div>
                                <div><strong>Name:</strong> <span id="adLetterName"></span></div>
                                <div><strong>Joining Date:</strong> <span id="adLetterJoining"></span></div>
                                <div><strong>Location:</strong> <span id="adLetterLocation"></span></div>
                            </div>
                            <div id="adLetterDate"></div>
                        </div>
                        <div class="letter-subject" id="adLetterSubject"></div>
                        <div id="adLetterRecipient"></div>
                        <div id="adLetterDescription" style="margin-top: 16px;"></div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn-ad btn-ad-soft" data-dismiss="modal">Close</button>
                    <button type="button" class="btn-ad btn-ad-primary" id="btnAdPrint"><i class="fas fa-print"></i>Print</button>
                </div>
            </div>
        </div>
    </div>

    <script src="../Scripts/Functions/UsersAppreciationDisplinaryAction.js"></script>
</asp:Content>
