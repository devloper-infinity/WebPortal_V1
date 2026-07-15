<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="InitiateResignation.aspx.cs" Inherits="WebPortal.Admin.InitiateResignationPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --init-blue: #1d4ed8;
            --init-cyan: #0891b2;
            --init-green: #059669;
            --init-red: #dc2626;
            --init-ink: #0f172a;
            --init-muted: #64748b;
            --init-border: #d8e2ee;
            --init-soft: #f4f7fb;
            --init-surface: #ffffff;
        }

        .initiate-page {
            color: var(--init-ink);
            font-size: 13px;
            padding: 0px 0 26px;
        }

        .initiate-shell {
            width: 100%;
            max-width: 1480px;
            margin: 0 auto;
        }

        .initiate-hero {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            min-height: 78px;
            padding: 16px 18px;
            border: 1px solid var(--init-border);
            border-radius: 8px;
            color: #fff;
            background: linear-gradient(135deg, #0f172a 0%, var(--init-blue) 56%, var(--init-cyan) 100%);
            box-shadow: 0 14px 32px rgba(15, 23, 42, .12);
        }

        .initiate-title {
            display: flex;
            align-items: center;
            gap: 13px;
            min-width: 0;
        }

        .initiate-title .icon-box {
            width: 44px;
            height: 44px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.15);
            font-size: 18px;
        }

        .initiate-title h1 {
            margin: 0;
            font-size: 22px;
            font-weight: 800;
            line-height: 1.15;
            letter-spacing: 0;
        }

        .initiate-title p {
            margin: 4px 0 0;
            color: rgba(255,255,255,.78);
            font-size: 12px;
        }

        .initiate-chip {
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

        .initiate-chip:hover {
            color: #fff;
            text-decoration: none;
            background: rgba(255,255,255,.2);
        }

        .initiate-panel {
            margin-top: 14px;
            border: 1px solid var(--init-border);
            border-radius: 8px;
            background: var(--init-surface);
            box-shadow: 0 10px 28px rgba(15, 23, 42, .07);
            overflow: hidden;
        }

        .section-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 16px 16px 0;
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
            color: var(--init-blue);
        }

        .section-title h2 {
            margin: 0;
            font-size: 16px;
            font-weight: 800;
            letter-spacing: 0;
        }

        .initiate-body {
            padding: 16px;
        }

        .detail-grid {
            display: grid;
            grid-template-columns: repeat(12, minmax(0, 1fr));
            gap: 13px 16px;
        }

        .detail-item {
            grid-column: span 4;
            min-width: 0;
        }

        .detail-item.col-6 {
            grid-column: span 6;
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
            border: 1px solid var(--init-border);
            border-radius: 8px;
            background: #f8fafc;
            color: var(--init-ink);
            font-size: 12px;
            font-weight: 700;
            word-break: break-word;
        }

        .required {
            color: var(--init-red);
        }

        .initiate-page .form-control,
        .initiate-page select,
        .initiate-page textarea {
            width: 100% !important;
            min-height: 38px;
            border: 1px solid var(--init-border) !important;
            border-radius: 8px !important;
            box-shadow: none !important;
            font-size: 12px !important;
            color: var(--init-ink);
        }

        .initiate-page textarea.form-control {
            min-height: 82px;
            resize: vertical;
        }

        .decision-band {
            margin-top: 16px;
            padding-top: 16px;
            border-top: 1px solid var(--init-border);
        }

        .actions-row {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            padding-top: 6px;
        }

        .btn-initiate {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-height: 38px;
            padding: 9px 14px;
            border: 1px solid transparent;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 800;
            cursor: pointer;
            transition: background .15s ease, border-color .15s ease, color .15s ease;
        }

        .btn-initiate-primary {
            color: #fff;
            background: var(--init-blue);
            border-color: var(--init-blue);
        }

        .btn-initiate-primary:hover {
            color: #fff;
            background: #1e40af;
            border-color: #1e40af;
        }

        .btn-initiate-soft {
            color: #1e3356;
            background: #fff;
            border-color: var(--init-border);
        }

        .btn-initiate-soft:hover {
            color: var(--init-blue);
            background: #f8fafc;
        }

        .initiate-message {
            display: none;
            margin: 14px 16px 0;
            padding: 10px 12px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 800;
        }

        .initiate-message.success {
            color: #065f46;
            background: #d1fae5;
            border: 1px solid #a7f3d0;
        }

        .initiate-message.error {
            color: #991b1b;
            background: #fee2e2;
            border: 1px solid #fecaca;
        }

        #initiateLoader.initiate-loading {
            display: none !important;
            position: fixed !important;
            top: 0 !important;
            right: 0 !important;
            bottom: 0 !important;
            left: 0 !important;
            width: 100vw !important;
            height: 100vh !important;
            z-index: 999999 !important;
            background: rgba(248, 250, 252, .72);
        }

        #initiateLoader.initiate-loading.is-visible {
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
        }

        #initiateLoader .loading-inner {
            width: 220px;
            min-height: 130px;
            padding: 22px;
            border: 1px solid var(--init-border);
            border-radius: 8px;
            background: #fff;
            text-align: center;
            box-shadow: 0 20px 48px rgba(15, 23, 42, .18);
        }

        #initiateLoader .loading-inner img {
            width: 52px;
            height: 52px;
        }

        #initiateLoader .loading-text {
            margin-top: 12px;
            color: var(--init-ink);
            font-size: 13px;
            font-weight: 800;
        }

        @media (max-width: 991px) {
            .detail-item,
            .detail-item.col-6 {
                grid-column: span 6;
            }
        }

        @media (max-width: 640px) {
            .initiate-hero,
            .section-head {
                align-items: flex-start;
                flex-direction: column;
            }

            .detail-item,
            .detail-item.col-6,
            .detail-item.col-12 {
                grid-column: span 12;
            }

            .actions-row {
                justify-content: stretch;
                flex-direction: column;
            }

            .btn-initiate {
                width: 100%;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="initiate-loading" id="initiateLoader" aria-hidden="true">
        <div class="loading-inner">
            <img src="../images/Load_1.gif" alt="Loading" />
            <div class="loading-text">One moment, please...</div>
        </div>
    </div>

    <div class="initiate-page">
        <div class="initiate-shell">
            <header class="initiate-hero">
                <div class="initiate-title">
                    <span class="icon-box"><i class="fas fa-check-circle"></i></span>
                    <div>
                        <h1>Finalize Resignation</h1>
                        <p>Review Step 1 details and record the Step 2 accept or reject decision.</p>
                    </div>
                </div>
                <a class="initiate-chip" href="Resignation.aspx"><i class="fas fa-list-check"></i>Full Workflow</a>
            </header>

            <section class="initiate-panel">
                <div id="initiateMessage" class="initiate-message"></div>

                <div class="section-head">
                    <div class="section-title">
                        <i class="fas fa-user-minus"></i>
                        <h2>Step 1 Details</h2>
                    </div>
                </div>

                <div class="initiate-body">
                    <input type="hidden" id="step2ResignationId" />
                    <div class="detail-grid">
                        <div class="detail-item">
                            <label>Employee</label>
                            <div class="detail-value" id="step2Employee"></div>
                        </div>
                        <div class="detail-item">
                            <label>Joining Date</label>
                            <div class="detail-value" id="step2Joining"></div>
                        </div>
                        <div class="detail-item">
                            <label>Reporting Manager</label>
                            <div class="detail-value" id="step2Manager"></div>
                        </div>
                        <div class="detail-item">
                            <label>Department</label>
                            <div class="detail-value" id="step2Department"></div>
                        </div>
                        <div class="detail-item">
                            <label>Designation</label>
                            <div class="detail-value" id="step2Designation"></div>
                        </div>
                        <div class="detail-item">
                            <label>Resignation Type</label>
                            <div class="detail-value" id="step2Type"></div>
                        </div>
                        <div class="detail-item">
                            <label>Resignation Date</label>
                            <div class="detail-value" id="step2Date"></div>
                        </div>
                        <div class="detail-item">
                            <label>Last Working Date</label>
                            <div class="detail-value" id="step2LastWorking"></div>
                        </div>
                        <div class="detail-item">
                            <label>Latest Login Date</label>
                            <div class="detail-value" id="step2LastLogin"></div>
                        </div>
                        <div class="detail-item col-12">
                            <label>Step 1 Remark</label>
                            <div class="detail-value" id="step2Step1Remark"></div>
                        </div>
                    </div>

                    <div class="decision-band">
                        <div class="section-title" style="margin-bottom: 14px;">
                            <i class="fas fa-clipboard-check"></i>
                            <h2>Step 2 Decision</h2>
                        </div>

                        <div class="detail-grid">
                            <div class="detail-item">
                                <label for="step2Status">Action <span class="required">*</span></label>
                                <select id="step2Status" class="form-control">
                                    <option value="">Select</option>
                                    <option value="Approve">Accept</option>
                                    <option value="Reject">Reject</option>
                                </select>
                            </div>
                            <div class="detail-item" id="step2AttritionWrap">
                                <label for="step2AttritionCategory">Attrition Category <span id="attritionRequired" class="required">*</span></label>
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
                            <div class="detail-item" id="step2ReceivedWrap">
                                <label for="step2ReceivedThrough">Resignation Received Through <span class="required">*</span></label>
                                <select id="step2ReceivedThrough" class="form-control">
                                    <option value="">Select</option>
                                    <option value="Self">Self</option>
                                    <option value="Company">Company</option>
                                </select>
                            </div>
                            <div class="detail-item col-12">
                                <label for="step2Remark">Step 2 Remark <span class="required">*</span></label>
                                <textarea id="step2Remark" class="form-control" maxlength="500" onpaste="return false"></textarea>
                            </div>
                            <div class="detail-item col-12 actions-row">
                                <a class="btn-initiate btn-initiate-soft" href="Resignation.aspx">
                                    <i class="fas fa-arrow-left"></i>Back
                                </a>
                                <button type="button" class="btn-initiate btn-initiate-primary" id="btnStep2Submit">
                                    <i class="fas fa-paper-plane"></i>Submit Decision
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </div>

    <portal:VersionedScript Src="~/Scripts/Functions/InitiateResignation.js" runat="server"></portal:VersionedScript>
</asp:Content>
