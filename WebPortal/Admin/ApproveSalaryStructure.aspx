<%@ Page Title="Salary Structure Approval" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ApproveSalaryStructure.aspx.cs" Inherits="WebPortal.Admin.ApproveSalaryStructure" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --salary-primary: #2563eb;
            --salary-dark: #0f172a;
            --salary-muted: #64748b;
            --salary-border: #dbe4ef;
            --salary-soft: #f5f8fc;
            --salary-success: #059669;
        }

        .salary-page {
            color: var(--salary-dark);
            font-size: 13px;
        }

        .salary-shell {
            width: 100%;
            max-width: 1480px;
            margin: 0 auto;
        }

        .salary-hero {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            padding: 20px 22px;
            color: #fff;
            border-radius: 12px;
            background: linear-gradient(135deg,#0f172a 0%,#1d4ed8 58%,#0891b2 100%);
            box-shadow: 0 16px 38px rgba(15,23,42,.16);
        }

        .salary-hero-main {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .salary-hero-icon {
            width: 48px;
            height: 48px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 12px;
            background: rgba(255,255,255,.16);
            font-size: 20px;
        }

        .salary-hero h1 {
            margin: 0;
            font-size: 23px;
            font-weight: 800;
        }

        .salary-hero p {
            margin: 5px 0 0;
            color: rgba(255,255,255,.8);
        }

        .salary-count {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 13px;
            border-radius: 999px;
            background: rgba(255,255,255,.14);
            font-weight: 700;
            white-space: nowrap;
        }

        .salary-card {
            margin-top: 16px;
            overflow: hidden;
            border: 1px solid var(--salary-border);
            border-radius: 12px;
            background: #fff;
            box-shadow: 0 10px 28px rgba(15,23,42,.07);
        }

        .salary-card-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            padding: 15px 18px;
            border-bottom: 1px solid var(--salary-border);
            background: #f8fafc;
        }

            .salary-card-head h2 {
                margin: 0;
                font-size: 16px;
                font-weight: 800;
            }

            .salary-card-head p {
                margin: 3px 0 0;
                color: var(--salary-muted);
            }

        .salary-card-body {
            padding: 15px;
        }

        .salary-actions {
            display: flex;
            align-items: center;
            gap: 5px;
            flex-wrap: wrap;
        }

        .salary-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            min-height: 36px;
            padding: 8px 13px;
            border: 1px solid transparent;
            border-radius: 8px;
            font-weight: 700;
            cursor: pointer;
            transition: .18s ease;
        }

            .salary-btn:hover {
                transform: translateY(-1px);
            }

        .salary-btn-primary {
            color: #fff;
            background: var(--salary-primary);
        }

        .salary-btn-success {
            color: #fff;
            background: var(--salary-success);
        }

        .salary-btn-soft {
            color: #334155;
            border-color: var(--salary-border);
            background: #fff;
        }

        .salary-btn-sm {
            min-height: 30px;
            padding: 5px 10px;
            font-size: 12px;
        }

        .salary-table-wrap {
            overflow-x: auto;
        }

        #salaryApprovalTable {
            width: 100% !important;
        }

            #salaryApprovalTable thead th {
                padding: 11px 10px;
                border-bottom: 1px solid var(--salary-border);
                background: #eef4fb;
                color: #334155;
                font-size: 12px;
                font-weight: 800;
                white-space: nowrap;
            }

            #salaryApprovalTable tbody td {
                padding: 10px;
                border-color: #e8eef5;
                vertical-align: middle;
            }

        .salary-code {
            font-weight: 800;
            color: #1d4ed8;
        }

        .salary-money {
            white-space: nowrap;
            font-weight: 700;
        }

        .review-workspace {
            display: none;
        }

            .review-workspace.is-open {
                display: block;
            }

        .employee-banner {
            display: grid;
            grid-template-columns: minmax(220px,1.4fr) repeat(5,minmax(100px,1fr));
            gap: 12px;
            padding: 16px;
            border: 1px solid #bfdbfe;
            border-radius: 10px;
            background: linear-gradient(135deg,#eff6ff,#f8fafc);
        }

        .employee-primary {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .employee-avatar {
            width: 46px;
            height: 46px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 12px;
            color: #fff;
            background: #2563eb;
            font-size: 16px;
            font-weight: 800;
        }

        .employee-primary h3 {
            margin: 0;
            font-size: 16px;
            font-weight: 800;
        }

        .employee-primary p, .employee-fact p {
            margin: 4px 0 0;
            color: var(--salary-muted);
        }

        .employee-fact {
            padding-left: 13px;
            border-left: 1px solid #cbdcf2;
        }

            .employee-fact strong {
                display: block;
                color: #334155;
            }

            .employee-fact:last-child {
                white-space: nowrap;
            }

        .salary-grid {
            display: grid;
            grid-template-columns: repeat(12,minmax(0,1fr));
            gap: 14px;
            margin-top: 14px;
        }

        .salary-section {
            grid-column: span 6;
            border: 1px solid var(--salary-border);
            border-radius: 10px;
            background: #fff;
            overflow: hidden;
        }

            .salary-section.full {
                grid-column: span 12;
            }

        .salary-section-head {
            display: flex;
            align-items: center;
            gap: 9px;
            padding: 12px 14px;
            border-bottom: 1px solid var(--salary-border);
            background: #f8fafc;
            font-size: 14px;
            font-weight: 800;
        }

            .salary-section-head i {
                color: var(--salary-primary);
            }

        .salary-fields {
            display: grid;
            grid-template-columns: repeat(2,minmax(0,1fr));
            gap: 12px;
            padding: 14px;
        }

        .salary-field {
            min-width: 0;
        }

            .salary-field.full {
                grid-column: 1 / -1;
            }

            .salary-field label {
                display: block;
                margin-bottom: 5px;
                color: #475569;
                font-size: 12px;
                font-weight: 700;
            }

        .salary-value {
            min-height: 38px;
            display: flex;
            align-items: center;
            padding: 8px 10px;
            border: 1px solid #e2e8f0;
            border-radius: 7px;
            background: #f8fafc;
            font-weight: 700;
        }

        .salary-field .form-control {
            height: 38px;
            border-color: #cbd5e1;
            border-radius: 7px;
            font-size: 13px;
        }

        .conditional-field {
            display: none;
        }

            .conditional-field.is-visible {
                display: block;
            }

        .amount-note {
            margin-top: 5px;
            color: var(--salary-muted);
            font-size: 11px;
        }

        .net-salary {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 16px;
            border-radius: 10px;
            color: #fff;
            background: linear-gradient(135deg,#047857,#059669);
        }

            .net-salary span {
                color: rgba(255,255,255,.8);
            }

            .net-salary strong {
                font-size: 24px;
            }

        .review-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            margin-top: 16px;
            padding-top: 16px;
            border-top: 1px solid var(--salary-border);
        }

            .review-footer p {
                margin: 0;
                color: var(--salary-muted);
            }

        .salary-rules {
            margin-top: 14px;
            border: 1px solid var(--salary-border);
            border-radius: 10px;
            background: #f8fafc;
        }

            .salary-rules summary {
                padding: 12px 14px;
                cursor: pointer;
                font-weight: 800;
            }

        .salary-rules-grid {
            display: grid;
            grid-template-columns: repeat(2,minmax(0,1fr));
            gap: 10px;
            padding: 0 14px 14px;
        }

        .salary-rule {
            padding: 10px 12px;
            border-radius: 8px;
            background: #fff;
            border: 1px solid #e2e8f0;
        }

            .salary-rule strong {
                display: block;
                margin-bottom: 3px;
            }

            .salary-rule span {
                color: var(--salary-muted);
            }

        .salary-loading {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 2000;
            align-items: center;
            justify-content: center;
            background: rgba(15,23,42,.35);
            backdrop-filter: blur(2px);
        }

            .salary-loading.is-visible {
                display: flex;
            }

        .salary-loading-box {
            min-width: 190px;
            padding: 20px;
            text-align: center;
            border-radius: 12px;
            background: #fff;
            box-shadow: 0 18px 50px rgba(15,23,42,.2);
        }

            .salary-loading-box i {
                color: var(--salary-primary);
                font-size: 24px;
            }

            .salary-loading-box div {
                margin-top: 9px;
                font-weight: 700;
            }

        @media (max-width: 992px) {
            .employee-banner {
                grid-template-columns: repeat(2,minmax(0,1fr));
            }

            .salary-section {
                grid-column: span 12;
            }
        }

        @media (max-width: 640px) {
            .salary-hero, .salary-card-head, .review-footer {
                align-items: flex-start;
                flex-direction: column;
            }

            .employee-banner, .salary-fields, .salary-rules-grid {
                grid-template-columns: 1fr;
            }

            .employee-fact {
                padding: 10px 0 0;
                border-left: 0;
                border-top: 1px solid #cbdcf2;
            }

            .salary-actions, .salary-actions .salary-btn {
                width: 100%;
            }
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="salary-loading" id="salaryLoading">
        <div class="salary-loading-box">
            <i class="fas fa-circle-notch fa-spin"></i>
            <div>Loading salary details...</div>
        </div>
    </div>

    <main class="salary-page">
        <div class="salary-shell">
            <header class="salary-hero">
                <div class="salary-hero-main">
                    <span class="salary-hero-icon"><i class="fas fa-file-invoice-dollar"></i></span>
                    <div>
                        <h1>Salary Structure Approval</h1>
                        <p>Review pending employee profiles, verify the salary breakup, and approve from one workspace.</p>
                    </div>
                </div>
                <span class="salary-count"><i class="fas fa-user-clock"></i><span id="pendingCount">0</span> pending</span>
            </header>

            <section class="salary-card">
                <div class="salary-card-head">
                    <div>
                        <h2>Pending employee profiles</h2>
                        <p>Select an employee to calculate and review the proposed salary structure.</p>
                    </div>
                    <div class="salary-actions">
                        <button type="button" class="salary-btn salary-btn-soft" id="btnRefreshApprovals"><i class="fas fa-sync-alt"></i>Refresh</button>
                    </div>
                </div>
                <div class="salary-card-body salary-table-wrap">
                    <table id="salaryApprovalTable" class="table table-hover table-bordered">
                        <thead>
                            <tr>
                                <th>Code</th>
                                <th>Employee</th>
                                <th>Joining Date</th>
                                <th>Salary</th>
                                <th>Company</th>
                                <th>Branch</th>
                                <th>Department</th>
                                <th>Reporting Manager</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </section>

            <section class="salary-card review-workspace" id="salaryReviewWorkspace">
                <div class="salary-card-head">
                    <div>
                        <h2>Review salary structure</h2>
                        <p>Calculated using the existing salary rules and employee profile.</p>
                    </div>
                    <button type="button" class="salary-btn salary-btn-soft" id="btnCloseReview"><i class="fas fa-times"></i>Close review</button>
                </div>
                <div class="salary-card-body">
                    <div class="employee-banner">
                        <div class="employee-primary">
                            <span class="employee-avatar" id="employeeInitials">--</span><div>
                                <h3 id="employeeName">--</h3>
                                <p><span id="employeeType">--</span></p>
                            </div>
                        </div>
                        <div class="employee-fact">
                            <strong>Gross Salary</strong><p id="employeeGross">0</p>
                        </div>
                        <div class="employee-fact">
                            <strong>Branch</strong>
                            <p><span id="employeeBranch"></span></p>
                        </div>
                        <div class="employee-fact">
                            <strong>Department</strong><p><span id="employeeDepartment"></span></p>
                        </div>
                        <div class="employee-fact">
                            <strong>Reporting</strong><p><span id="employeeManager"></span></p>
                        </div>
                        <div class="employee-fact">
                            <strong>Cut Off</strong><p><span id="employeeCutoff"></span></p>
                        </div>
                    </div>

                    <div class="salary-grid">
                        <section class="salary-section">
                            <div class="salary-section-head"><i class="fas fa-wallet"></i>Earnings and allowances</div>
                            <div class="salary-fields">
                                <div class="salary-field">
                                    <label>Basic + DA</label><div class="salary-value" id="valueBasic">0</div>
                                </div>
                                <div class="salary-field">
                                    <label>House Rent Allowance</label><div class="salary-value" id="valueHRA">0</div>
                                </div>
                                <div class="salary-field">
                                    <label>Attendance Bonus Applicable?</label><select id="attendanceApplicable" class="form-control"><option value="Select">Select</option>
                                        <option value="Yes">Yes</option>
                                        <option value="No">No</option>
                                    </select>
                                </div>
                                <div class="salary-field conditional-field" id="attendanceTypeField">
                                    <label>Attendance Bonus Type</label><select id="attendanceType" class="form-control"><option value="Select">Select</option>
                                        <option value="Percentage">Percentage</option>
                                        <option value="Fix Amount">Fix Amount</option>
                                    </select>
                                </div>
                                <div class="salary-field conditional-field" id="attendanceAmountField">
                                    <label id="attendanceAmountLabel">Bonus Value</label><input id="attendanceAmount" type="number" min="0" step="1" class="form-control" /><div class="amount-note" id="attendanceActual">Actual allocation: 0</div>
                                </div>
                                <div class="salary-field">
                                    <label>Quality Bonus Applicable?</label><select id="qualityApplicable" class="form-control"><option value="Select">Select</option>
                                        <option value="Yes">Yes</option>
                                        <option value="No">No</option>
                                    </select>
                                </div>
                                <div class="salary-field conditional-field" id="qualityAmountField">
                                    <label>Quality Bonus Amount</label><input id="qualityAmount" type="number" min="0" step="1" class="form-control" />
                                </div>
                            </div>
                        </section>

                        <section class="salary-section">
                            <div class="salary-section-head"><i class="fas fa-receipt"></i>Statutory deductions</div>
                            <div class="salary-fields">
                                <div class="salary-field">
                                    <label>ESI Applicable</label><select id="esiApplicable" class="form-control"><option value="Yes">Yes</option>
                                        <option value="No">No</option>
                                    </select>
                                </div>
                                <div class="salary-field">
                                    <label>ESI</label><div class="salary-value" id="valueESI">0</div>
                                </div>
                                <div class="salary-field">
                                    <label>PF Applicable</label><select id="pfApplicable" class="form-control"><option value="Yes">Yes</option>
                                        <option value="No">No</option>
                                    </select>
                                </div>
                                <div class="salary-field">
                                    <label>PF</label><div class="salary-value" id="valuePF">0</div>
                                </div>
                                <div class="salary-field">
                                    <label>Professional Tax</label><div class="salary-value" id="valuePT">0</div>
                                </div>
                                <div class="salary-field">
                                    <label>MLWF</label><div class="salary-value">25 <small>&nbsp;(June and December)</small></div>
                                </div>
                                <div class="salary-field full">
                                    <label>Total Deduction</label><div class="salary-value" id="valueTotalDeduction">0</div>
                                </div>
                            </div>
                        </section>

                        <section class="salary-section full">
                            <div class="salary-section-head"><i class="fas fa-sliders-h"></i>Eligibility and monthly salary</div>
                            <div class="salary-fields">
                                <div class="salary-field">
                                    <label>Eligible for Extra Days</label><select id="extraDays" class="form-control"><option value="Yes">Yes</option>
                                        <option value="No" selected>No</option>
                                    </select>
                                </div>
                                <div class="salary-field">
                                    <label>Days in Current Month</label><div class="salary-value" id="valueDays">--</div>
                                </div>
                                <div class="salary-field">
                                    <label>Night Bonus Applicable</label><select id="nightApplicable" class="form-control"><option value="Yes">Yes</option>
                                        <option value="No">No</option>
                                    </select>
                                </div>
                                <div class="salary-field conditional-field" id="nightAmountField">
                                    <label>Night Bonus</label><input id="nightAmount" type="number" min="0" step="1" class="form-control" />
                                </div>
                                <div class="salary-field full">
                                    <div class="net-salary">
                                        <div>
                                            <span>Calculated net salary</span><div>After statutory deductions</div>
                                        </div>
                                        <strong id="valueNetSalary">0</strong>
                                    </div>
                                </div>
                            </div>
                        </section>
                    </div>

                    <details class="salary-rules">
                        <summary><i class="fas fa-book-open"></i>&nbsp; Salary rules used by this workflow</summary>
                        <div class="salary-rules-grid">
                            <div class="salary-rule"><strong>Basic</strong><span>51% of gross salary; fixed at 16,000 when salary exceeds 21,000.</span></div>
                            <div class="salary-rule"><strong>HRA</strong><span>Remaining gross salary after the salary components and applicable bonuses.</span></div>
                            <div class="salary-rule"><strong>ESIC</strong><span>0.75% when gross salary is 21,000 or below; not deducted for consultants.</span></div>
                            <div class="salary-rule"><strong>PF</strong><span>12% of Basic when applicable; not deducted for consultants.</span></div>
                            <div class="salary-rule"><strong>Professional Tax</strong><span>Applied by the existing gender, employee-type, and salary slabs.</span></div>
                            <div class="salary-rule"><strong>Minimum Structure</strong><span>Salary below 7,911 is structured at 7,911 while preserving the legacy calculation workflow.</span></div>
                        </div>
                    </details>

                    <div class="review-footer">
                        <p><i class="fas fa-info-circle"></i>Approval saves the salary structure and removes the employee from the pending queue.</p>
                        <div class="salary-actions">
                            <button type="button" class="salary-btn salary-btn-soft" id="btnCancelReview">Cancel</button>
                            <button type="button" class="salary-btn salary-btn-success" id="btnApproveSalary"><i class="fas fa-check-circle"></i>Approve salary structure</button>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <portal:VersionedScript Src="~/Scripts/Functions/ApproveSalaryStructure.js" runat="server"></portal:VersionedScript>
</asp:Content>
