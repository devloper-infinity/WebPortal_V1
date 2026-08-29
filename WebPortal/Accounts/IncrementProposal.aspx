<%@ Page Title="" Language="C#" MasterPageFile="~/Accounts/Accounts.Master" AutoEventWireup="true" CodeBehind="IncrementProposalReport_Step1.aspx.cs" Inherits="WebPortal.Accounts.IncrementProposal" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../plugins/datatables-fixedcolumns/css/fixedColumns.bootstrap4.min.css" />
    <link rel="stylesheet" href="../plugins/datatables-fixedheader/css/fixedHeader.bootstrap4.min.css" />
    <style>
        .increment-shell {
            background: #f5f7fb;
            min-height: calc(100vh - 120px);
            padding-bottom: 24px;
        }

        .increment-header {
            align-items: center;
            background: #ffffff;
            border: 1px solid #dde5ef;
            border-left: 4px solid #0f766e;
            display: flex;
            justify-content: space-between;
            margin: 16px auto;
            max-width: 1480px;
            padding: 16px 18px;
        }

        .increment-title {
            color: #172033;
            font-size: 22px;
            font-weight: 700;
            margin: 0;
        }

        .increment-subtitle {
            color: #667085;
            font-size: 13px;
            margin-top: 4px;
        }

        .increment-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            justify-content: flex-end;
        }

        .increment-panel {
            background: #ffffff;
            border: 1px solid #dde5ef;
            margin: 0 auto;
            max-width: 1480px;
        }

        .increment-tabs {
            background: #f8fafc;
            border-bottom: 1px solid #dde5ef;
            padding: 0 12px;
        }

        .increment-tabs .nav-link {
            border-radius: 0;
            color: #475467;
            font-weight: 700;
            padding: 14px 18px;
        }

        .increment-tabs .nav-link.active {
            background: #ffffff;
            border-top: 3px solid #0f766e;
            color: #0f172a;
        }

        .increment-body {
            padding: 16px;
        }

        .increment-toolbar {
            align-items: center;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: space-between;
            margin-bottom: 12px;
        }

        .increment-filter {
            align-items: center;
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }

        .increment-filter label {
            color: #344054;
            font-size: 12px;
            font-weight: 700 !important;
            margin: 0;
        }

        .increment-filter .form-control {
            min-width: 180px;
        }

        .increment-kpis {
            display: grid;
            gap: 10px;
            grid-template-columns: repeat(4, minmax(150px, 1fr));
            margin-bottom: 14px;
        }

        .increment-kpi {
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 12px;
        }

        .increment-kpi span {
            color: #64748b;
            display: block;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
        }

        .increment-kpi strong {
            color: #111827;
            display: block;
            font-size: 22px;
            line-height: 1.2;
            margin-top: 4px;
        }

        .increment-kpi.teal {
            border-top: 3px solid #0f766e;
        }

        .increment-kpi.blue {
            border-top: 3px solid #2563eb;
        }

        .increment-kpi.amber {
            border-top: 3px solid #d97706;
        }

        .increment-kpi.rose {
            border-top: 3px solid #be123c;
        }

        .increment-table {
            border-collapse: collapse !important;
            width: 100% !important;
        }

        .increment-table th,
        .increment-table td {
            font-size: 12px;
            vertical-align: middle !important;
            white-space: nowrap;
        }

        .increment-table thead th {
            background: #eef3f8;
            border-bottom: 1px solid #ced8e3 !important;
            color: #1f2937;
            font-weight: 700;
        }

        .increment-table .btn {
            font-size: 11px;
            padding: 3px 8px;
        }

        .increment-pill {
            border-radius: 999px;
            display: inline-block;
            font-size: 11px;
            font-weight: 700;
            padding: 3px 8px;
        }

        .increment-pill.general {
            background: #e0f2fe;
            color: #075985;
        }

        .increment-pill.uw {
            background: #ecfdf3;
            color: #027a48;
        }

        .increment-pill.task {
            background: #fff7ed;
            color: #9a3412;
        }

        .increment-pill.productive {
            background: #f0fdfa;
            color: #115e59;
        }

        .increment-loading {
            align-items: center;
            background: rgba(15, 23, 42, .58);
            bottom: 0;
            display: none;
            justify-content: center;
            left: 0;
            position: fixed;
            right: 0;
            top: 0;
            z-index: 99999;
        }

        .increment-loading-box {
            background: #ffffff;
            border-radius: 8px;
            box-shadow: 0 18px 50px rgba(15, 23, 42, .18);
            min-width: 260px;
            padding: 18px;
            text-align: center;
        }

        .increment-loading-box img {
            height: 46px;
            margin-bottom: 8px;
        }

        .modal-xl {
            max-width: 1140px;
        }

        .proposal-grid {
            display: grid;
            gap: 12px;
            grid-template-columns: repeat(4, minmax(0, 1fr));
        }

        .proposal-field label {
            color: #344054;
            display: block;
            font-size: 12px;
            font-weight: 700 !important;
            margin-bottom: 4px;
        }

        .proposal-field.wide {
            grid-column: span 2;
        }

        .proposal-field.full {
            grid-column: 1 / -1;
        }

        .proposal-section-title {
            border-bottom: 1px solid #e2e8f0;
            color: #111827;
            font-size: 14px;
            font-weight: 700;
            margin: 16px 0 10px;
            padding-bottom: 6px;
        }

        .readonly-value {
            background: #f8fafc;
            border: 1px solid #d9e2ec;
            color: #111827;
            min-height: 35px;
            padding: 7px 10px;
        }

        .document-list {
            max-height: 340px;
            overflow: auto;
        }

        .dataTables_wrapper .dt-buttons .btn,
        .dataTables_wrapper .dt-buttons button {
            background: #0f766e;
            border: 0;
            border-radius: 6px;
            color: #fff;
            font-weight: 700;
            margin-right: 6px;
            padding: 5px 10px;
        }

        @media (max-width: 991px) {
            .increment-header {
                align-items: flex-start;
                flex-direction: column;
            }

            .increment-actions {
                justify-content: flex-start;
            }

            .increment-kpis,
            .proposal-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 575px) {
            .increment-kpis,
            .proposal-grid {
                grid-template-columns: 1fr;
            }

            .proposal-field.wide {
                grid-column: auto;
            }
        }
    </style>
    <script>
        $(document).ready(function () {
            if (window.incprop_init) {
                incprop_init();
            }
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="increment-loading" id="incprop_loader">
        <div class="increment-loading-box">
            <img src="../images/Load_1.gif" alt="Loading" />
            <div><b>One moment, please...</b></div>
        </div>
    </div>

    <div class="increment-shell">
        <div class="increment-header">
            <div>
                <h1 class="increment-title"><i class="fas fa-chart-line"></i>&nbsp;Increment Proposal</h1>
                <div class="increment-subtitle">Due employees, proposal review, and final salary insertion.</div>
            </div>
            <div class="increment-actions">
                <a href="ResumeIncrementProposal.aspx" class="btn btn-outline-secondary btn-sm" id="incprop_resumeLink">
                    <i class="fas fa-history"></i>&nbsp;Resume
                </a>
                <a href="IncrementEligibleEmployeesWithinYear.aspx" class="btn btn-outline-secondary btn-sm" id="incprop_eligibleLink">
                    <i class="fas fa-user-clock"></i>&nbsp;Eligible In One Year
                </a>
                <button type="button" class="btn btn-outline-primary btn-sm" onclick="return incprop_refreshAll();">
                    <i class="fas fa-sync-alt"></i>&nbsp;Refresh
                </button>
            </div>
        </div>

        <div class="increment-panel">
            <div class="increment-tabs">
                <ul class="nav nav-tabs border-0" id="incprop_tabs" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link active" id="incprop_due_tab" data-toggle="pill" href="#incprop_due" role="tab" aria-controls="incprop_due" aria-selected="true">
                            <i class="fas fa-users"></i>&nbsp;Step 1 - Due For Increment
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" id="incprop_selected_tab" data-toggle="pill" href="#incprop_selected" role="tab" aria-controls="incprop_selected" aria-selected="false">
                            <i class="fas fa-edit"></i>&nbsp;Step 2 - Selected For Increment
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" id="incprop_final_tab" data-toggle="pill" href="#incprop_final" role="tab" aria-controls="incprop_final" aria-selected="false">
                            <i class="fas fa-check-circle"></i>&nbsp;Step 3 - Final Report
                        </a>
                    </li>
                </ul>
            </div>

            <div class="increment-body">
                <div class="increment-kpis">
                    <div class="increment-kpi teal">
                        <span>Due Employees</span>
                        <strong id="incprop_dueCount">0</strong>
                    </div>
                    <div class="increment-kpi blue">
                        <span>Selected</span>
                        <strong id="incprop_selectedCount">0</strong>
                    </div>
                    <div class="increment-kpi amber">
                        <span>Ready Final</span>
                        <strong id="incprop_finalCount">0</strong>
                    </div>
                    <div class="increment-kpi rose">
                        <span>Selected Rows</span>
                        <strong id="incprop_checkedCount">0</strong>
                    </div>
                </div>

                <div class="tab-content" id="incprop_tabContent">
                    <div class="tab-pane fade show active" id="incprop_due" role="tabpanel" aria-labelledby="incprop_due_tab">
                        <div class="increment-toolbar">
                            <div>
                                <button type="button" class="btn btn-success" onclick="return incprop_proceedToStep2();">
                                    <i class="fas fa-arrow-right"></i>&nbsp;Proceed To Step 2
                                </button>
                            </div>
                            <div class="increment-filter">
                                <label for="incprop_dueSearch">Quick Search</label>
                                <input type="text" class="form-control form-control-sm" id="incprop_dueSearch" placeholder="Code, name, department, manager" />
                            </div>
                        </div>

                        <table class="table table-bordered table-hover increment-table" id="incprop_dueTable">
                            <thead>
                                <tr>
                                    <th><input type="checkbox" id="incprop_dueCheckAll" /></th>
                                    <th>Code</th>
                                    <th>Name</th>
                                    <th>Joining Date</th>
                                    <th>Branch</th>
                                    <th>Department</th>
                                    <th>Designation</th>
                                    <th>Reporting Manager</th>
                                    <th>Productive/Task</th>
                                    <th>Current Salary</th>
                                    <th>Latest Login Date</th>
                                    <th>Tenure Since Last Increment</th>
                                    <th>Previous Increment Amount</th>
                                    <th>Previous Salary</th>
                                    <th>Previous Increment Month-Year</th>
                                    <th>Previous Increment %</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>

                    <div class="tab-pane fade" id="incprop_selected" role="tabpanel" aria-labelledby="incprop_selected_tab">
                        <div class="increment-toolbar">
                            <div class="increment-actions">
                                <button type="button" class="btn btn-primary" onclick="return incprop_setForApproval();">
                                    <i class="fas fa-paper-plane"></i>&nbsp;Set Selected For Approval
                                </button>
                                <button type="button" class="btn btn-outline-primary" onclick="return incprop_bindSelected();">
                                    <i class="fas fa-sync-alt"></i>&nbsp;Refresh Selected
                                </button>
                            </div>
                            <div class="increment-filter">
                                <input type="hidden" id="incprop_domainMode" />
                                <label for="incprop_selectedSearch">Quick Search</label>
                                <input type="text" class="form-control form-control-sm" id="incprop_selectedSearch" placeholder="Code, name, domain, status" />
                            </div>
                        </div>

                        <table class="table table-bordered table-hover increment-table" id="incprop_selectedTable">
                            <thead>
                                <tr>
                                    <th><input type="checkbox" id="incprop_selectedCheckAll" /></th>
                                    <th>Actions</th>
                                    <th>Flow</th>
                                    <th>Productive/Task</th>
                                    <th>Domain</th>
                                    <th>Branch</th>
                                    <th>Code</th>
                                    <th>Name</th>
                                    <th>Joining Date</th>
                                    <th>Reporting Manager</th>
                                    <th>Production</th>
                                    <th>Quality</th>
                                    <th>Attendance</th>
                                    <th>Reviewer</th>
                                    <th>PKT</th>
                                    <th>ENG</th>
                                    <th>Flexibility</th>
                                    <th>Salary</th>
                                    <th>Standard %</th>
                                    <th>PM %</th>
                                    <th>Increment Amount</th>
                                    <th>Attendance Bonus</th>
                                    <th>Night Bonus</th>
                                    <th>Salary After Increment</th>
                                    <th>Month</th>
                                    <th>Year</th>
                                    <th>Status</th>
                                    <th>PM Remark</th>
                                    <th>Tenure Since Last Increment</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>

                    <div class="tab-pane fade" id="incprop_final" role="tabpanel" aria-labelledby="incprop_final_tab">
                        <div class="increment-toolbar">
                            <div class="increment-actions">
                                <button type="button" class="btn btn-success" onclick="return incprop_addFinalToDatabase();">
                                    <i class="fas fa-database"></i>&nbsp;Add Selected In Database
                                </button>
                                <button type="button" class="btn btn-outline-primary" onclick="return incprop_bindFinal();">
                                    <i class="fas fa-sync-alt"></i>&nbsp;Refresh Final
                                </button>
                            </div>
                            <div class="increment-filter">
                                <label for="incprop_finalSearch">Quick Search</label>
                                <input type="text" class="form-control form-control-sm" id="incprop_finalSearch" placeholder="Code, name, branch, manager" />
                            </div>
                        </div>

                        <table class="table table-bordered table-hover increment-table" id="incprop_finalTable">
                            <thead>
                                <tr>
                                    <th><input type="checkbox" id="incprop_finalCheckAll" /></th>
                                    <th>Sr #</th>
                                    <th>Productive/Task</th>
                                    <th>Branch</th>
                                    <th>Code</th>
                                    <th>Name</th>
                                    <th>Joining Date</th>
                                    <th>Reporting Manager</th>
                                    <th>Tenure Since Last Increment</th>
                                    <th>Production Grade</th>
                                    <th>Quality Grade</th>
                                    <th>Attendance Grade</th>
                                    <th>Salary</th>
                                    <th>Standard %</th>
                                    <th>Recommendation DH</th>
                                    <th>Recommendation CM</th>
                                    <th>Negotiation Done</th>
                                    <th>Last 3 Years Avg</th>
                                    <th>Increment Amount</th>
                                    <th>Salary After Increment</th>
                                    <th>Effective Month</th>
                                    <th>Effective Year</th>
                                    <th>Next Due Month</th>
                                    <th>Next Due Year</th>
                                    <th>PM Remark</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="incprop_proposalModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-xl" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="incprop_proposalTitle">Increment Proposal</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="incprop_modalWorkflow" />
                    <input type="hidden" id="incprop_modalCode" />
                    <input type="hidden" id="incprop_modalProposalId" />
                    <input type="hidden" id="incprop_modalIncCounter" />
                    <input type="hidden" id="incprop_modalDpType" />

                    <div class="proposal-section-title">Employee Snapshot</div>
                    <div class="proposal-grid">
                        <div class="proposal-field">
                            <label>Code</label>
                            <div class="readonly-value" id="incprop_mCode"></div>
                        </div>
                        <div class="proposal-field">
                            <label>Name</label>
                            <div class="readonly-value" id="incprop_mName"></div>
                        </div>
                        <div class="proposal-field">
                            <label>Domain</label>
                            <div class="readonly-value" id="incprop_mDomain"></div>
                        </div>
                        <div class="proposal-field">
                            <label>Productive/Task</label>
                            <div class="readonly-value" id="incprop_mDpType"></div>
                        </div>
                        <div class="proposal-field">
                            <label>Joining Date</label>
                            <div class="readonly-value" id="incprop_mJoining"></div>
                        </div>
                        <div class="proposal-field">
                            <label>Reporting Manager</label>
                            <div class="readonly-value" id="incprop_mManager"></div>
                        </div>
                        <div class="proposal-field">
                            <label>Current Salary</label>
                            <input type="number" class="form-control" id="incprop_mSalary" readonly />
                        </div>
                        <div class="proposal-field">
                            <label>Standard %</label>
                            <div class="readonly-value" id="incprop_mStandard"></div>
                        </div>
                    </div>

                    <div class="proposal-section-title">Increment Details</div>
                    <div class="proposal-grid">
                        <div class="proposal-field">
                            <label>Percentage</label>
                            <input type="number" step="0.01" class="form-control" id="incprop_mPercentage" onchange="incprop_recalculateProposal();" />
                        </div>
                        <div class="proposal-field">
                            <label>Increment Amount</label>
                            <input type="number" class="form-control" id="incprop_mIncrementAmount" readonly />
                        </div>
                        <div class="proposal-field">
                            <label>Salary After Increment</label>
                            <input type="number" class="form-control" id="incprop_mSalaryAfter" readonly />
                        </div>
                        <div class="proposal-field">
                            <label>Grand Total</label>
                            <div class="readonly-value" id="incprop_mGrandTotal">0</div>
                        </div>
                        <div class="proposal-field">
                            <label>Effective Month</label>
                            <select class="form-control" id="incprop_mMonth" onchange="incprop_updateNextDue();"></select>
                        </div>
                        <div class="proposal-field">
                            <label>Effective Year</label>
                            <select class="form-control" id="incprop_mYear" onchange="incprop_updateNextDue();"></select>
                        </div>
                        <div class="proposal-field">
                            <label>Next Increment After</label>
                            <select class="form-control" id="incprop_mNextAfter" onchange="incprop_updateNextDue();">
                                <option value="">Select</option>
                                <option value="1">1 Year</option>
                                <option value="2">2 Years</option>
                                <option value="3">3 Years</option>
                                <option value="4">4 Years</option>
                                <option value="5">5 Years</option>
                            </select>
                        </div>
                        <div class="proposal-field">
                            <label>Status</label>
                            <select class="form-control" id="incprop_mStatus">
                                <option value="">Select</option>
                                <option value="Negotiation Done">Negotiation Done</option>
                                <option value="Set For Approval">Set For Approval</option>
                            </select>
                        </div>
                        <div class="proposal-field">
                            <label>Next Due Month</label>
                            <select class="form-control" id="incprop_mNextMonth"></select>
                        </div>
                        <div class="proposal-field">
                            <label>Next Due Year</label>
                            <select class="form-control" id="incprop_mNextYear"></select>
                        </div>
                        <div class="proposal-field full">
                            <label>PM Remark</label>
                            <textarea class="form-control" id="incprop_mRemark" rows="2"></textarea>
                        </div>
                    </div>

                    <div class="proposal-section-title">Bonus Details</div>
                    <div class="proposal-grid">
                        <div class="proposal-field">
                            <label>Attendance Bonus Applicable</label>
                            <select class="form-control" id="incprop_mAttnApplicable" onchange="incprop_toggleBonus();">
                                <option value="false">No</option>
                                <option value="true">Yes</option>
                            </select>
                        </div>
                        <div class="proposal-field">
                            <label>Attendance Bonus Type</label>
                            <select class="form-control" id="incprop_mAttnType" onchange="incprop_recalculateBonus();">
                                <option value="">Select</option>
                                <option value="Percentage">Percentage</option>
                                <option value="Fix Amount">Fix Amount</option>
                            </select>
                        </div>
                        <div class="proposal-field">
                            <label>Bonus Amount/Percentage</label>
                            <input type="number" class="form-control" id="incprop_mAttnValue" onchange="incprop_recalculateBonus();" />
                        </div>
                        <div class="proposal-field">
                            <label>Calculated Attendance Bonus</label>
                            <div class="readonly-value" id="incprop_mAttnAmount">0</div>
                        </div>
                        <div class="proposal-field">
                            <label>Bonus Effective Month</label>
                            <select class="form-control" id="incprop_mAttnMonth"></select>
                        </div>
                        <div class="proposal-field">
                            <label>Bonus Effective Year</label>
                            <select class="form-control" id="incprop_mAttnYear"></select>
                        </div>
                        <div class="proposal-field">
                            <label>Quality Bonus</label>
                            <input type="number" class="form-control" id="incprop_mQualityBonus" value="0" />
                        </div>
                        <div class="proposal-field">
                            <label>Night Bonus Applicable</label>
                            <select class="form-control" id="incprop_mNightApplicable" disabled>
                                <option value="false">No</option>
                                <option value="true">Yes</option>
                            </select>
                        </div>
                        <div class="proposal-field">
                            <label>Night Bonus Amount</label>
                            <input type="number" class="form-control" id="incprop_mNightBonus" value="0" readonly />
                        </div>
                    </div>

                    <div class="proposal-section-title">Retention Bonus</div>
                    <div class="proposal-grid">
                        <div class="proposal-field">
                            <label>Amount</label>
                            <input type="number" class="form-control" id="incprop_mRetentionBonus" value="0" />
                        </div>
                        <div class="proposal-field">
                            <label>For Period</label>
                            <select class="form-control" id="incprop_mRetentionPeriod"></select>
                        </div>
                        <div class="proposal-field">
                            <label>Effective Month</label>
                            <select class="form-control" id="incprop_mRetentionMonth"></select>
                        </div>
                        <div class="proposal-field">
                            <label>Effective Year</label>
                            <select class="form-control" id="incprop_mRetentionYear"></select>
                        </div>
                    </div>

                    <div class="proposal-section-title">Remark History</div>
                    <div class="table-responsive">
                        <table class="table table-bordered table-sm increment-table" id="incprop_remarksTable">
                            <thead>
                                <tr>
                                    <th>Sr #</th>
                                    <th>Percentage</th>
                                    <th>Status</th>
                                    <th>Increment Amount</th>
                                    <th>Salary After Increment</th>
                                    <th>Month</th>
                                    <th>Year</th>
                                    <th>Remark</th>
                                    <th>Added By</th>
                                    <th>Added Date</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-primary" onclick="return incprop_applyStandardFromModal();">
                        <i class="fas fa-magic"></i>&nbsp;Apply Standard Criteria
                    </button>
                    <button type="button" class="btn btn-success" onclick="return incprop_saveProposal();">
                        <i class="fas fa-save"></i>&nbsp;Save Proposal
                    </button>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="incprop_uploadModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Upload Performance Document</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="incprop_uploadWorkflow" />
                    <input type="hidden" id="incprop_uploadCode" />
                    <input type="hidden" id="incprop_uploadIncCounter" />
                    <div class="form-group">
                        <label>Employee</label>
                        <div class="readonly-value" id="incprop_uploadEmployee"></div>
                    </div>
                    <div class="form-group">
                        <label>Select File</label>
                        <input type="file" class="form-control" id="incprop_uploadFile" />
                    </div>
                    <div class="form-group">
                        <label>Remark</label>
                        <textarea class="form-control" id="incprop_uploadRemark" rows="3"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success" onclick="return incprop_uploadDocument();">
                        <i class="fas fa-upload"></i>&nbsp;Upload
                    </button>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="incprop_docsModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Performance Documents</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body document-list">
                    <table class="table table-bordered table-sm increment-table" id="incprop_docsTable">
                        <thead>
                            <tr>
                                <th>Sr #</th>
                                <th>Document</th>
                                <th>Remark</th>
                                <th>Uploaded By</th>
                                <th>Uploaded Date</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script src="../plugins/datatables-fixedcolumns/js/dataTables.fixedColumns.min.js"></script>
    <script src="../plugins/datatables-fixedheader/js/dataTables.fixedHeader.min.js"></script>
    <script src="../Scripts/Reports/IncrementProposalAccounts.js"></script>
</asp:Content>
