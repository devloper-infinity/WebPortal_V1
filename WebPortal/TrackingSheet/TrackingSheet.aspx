<%@ Page Title="Tracking Sheet" Language="C#" MasterPageFile="~/TrackingSheet/TrackingSheetMaster.Master" AutoEventWireup="true" CodeBehind="TrackingSheet.aspx.cs" Inherits="WebPortal.TrackingSheet.TrackingSheetPage" %>

<asp:Content ID="Head" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="OLTracking.css" />
    <link rel="stylesheet" href="TrackingSheetFeedback.css?v=20260816.2" />

    <style>
        .ots-tabs {
            display: flex;
            gap: 8px;
            margin-bottom: 14px;
            border-bottom: 1px solid #d7e2ee
        }

        .ots-tab {
            padding: 12px 18px;
            border: 0;
            border-bottom: 3px solid transparent;
            background: transparent;
            color: #496078;
            font-weight: 800;
            cursor: pointer
        }

            .ots-tab.active {
                border-bottom-color: #0f6b8f;
                color: #0f6b8f
            }

        .ots-panel {
            display: none
        }

            .ots-panel.active {
                display: block
            }

        .ots-status {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 12px;
            background: #e8f3f7;
            color: #0f6b8f;
            font-size: 11px;
            font-weight: 800
        }

        .ots-step {
            display: none
        }

            .ots-step.active {
                display: block
            }

        .ots-disabled {
            background: #edf2f7 !important;
            color: #344a60 !important
        }

        .ots-note {
            margin: 8px 0;
            padding: 9px 11px;
            border-radius: 6px;
            background: #f1f7fb;
            color: #486174;
            font-size: 12px
        }

        .ots-daily-table-wrap {
            box-sizing: border-box;
            padding: 0 15px 15px;
        }

        .olt-btn:disabled {
            border-color: #cbd5e1;
            background: #e2e8f0;
            color: #64748b;
            cursor: not-allowed;
            opacity: .78
        }

        .ots-other-processing { display:none; margin-top:18px; border-top:1px solid #d7e2ee; padding-top:18px }
        .ots-other-processing.active { display:block }
        .ots-processing-head { display:flex; justify-content:space-between; gap:16px; align-items:flex-end; margin-bottom:12px }
        .ots-processing-head h3 { margin:0 0 4px; color:#17324d }
        .ots-processing-head p { margin:0; color:#64748b }
        .ots-search-row { display:grid; grid-template-columns:minmax(260px,1fr) minmax(180px,280px) auto; gap:12px; align-items:end; margin-bottom:12px }
        .ots-search-help { margin-top:5px; color:#64748b; font-size:11px }
        .ots-selection-count { padding-bottom:9px; color:#496078; font-weight:700; white-space:nowrap }
        .ots-row-check { width:16px; height:16px }
        .ots-action-group { display:flex; gap:6px; flex-wrap:wrap }
        .ots-status.available { background:#eef2ff; color:#4338ca }
        .ots-status.pending { background:#fff7dc; color:#92400e }
        .ots-status.in-process { background:#e0f2fe; color:#075985 }
        .ots-status.hold { background:#fee2e2; color:#991b1b }
        .olt-dialog-head button:not(.olt-dialog-close) { display:none }
        .ots-status-control { grid-column:span 12; max-width:540px }
        #completeModal .olt-dialog { overflow:hidden; box-shadow:0 24px 70px rgba(15,23,42,.28) }
        #completeModal .olt-dialog-body { max-height:calc(90vh - 63px); overflow:auto; padding:0 }
        #completeModal .ots-step { box-sizing:border-box; padding:20px 22px 22px }
        #completeModal #completeStep.active { border-top:1px solid #e2e8f0; background:#fbfdff }
        #completeModal #completeRemark { box-sizing:border-box; min-height:100px; resize:vertical; line-height:1.5 }
        #completeModal .ots-completion-actions { margin-top:4px; padding-top:2px }
        .ots-modal-message { display:flex; align-items:flex-start; gap:12px; margin:16px 22px 0; padding:13px 15px; border:1px solid #fecaca; border-left:4px solid #dc2626; border-radius:8px; background:#fff7f7; color:#7f1d1d; box-shadow:0 4px 14px rgba(127,29,29,.08) }
        .ots-modal-message[hidden] { display:none }
        .ots-modal-message-icon { display:flex; flex:0 0 28px; width:28px; height:28px; align-items:center; justify-content:center; border-radius:50%; background:#dc2626; color:#fff; font-size:17px; font-weight:900 }
        .ots-modal-message strong { display:block; margin:1px 0 4px; color:#991b1b; font-size:14px }
        .ots-modal-message p { margin:0; color:#7f1d1d; line-height:1.5 }
        .hourly-hours,.hourly-minutes { width:90px; min-width:70px; padding:8px; border:1px solid #c8d5e3; border-radius:5px }
        .ots-hourly-entry { display:none; padding:16px; border:1px solid #cfe0eb; border-radius:8px; background:#f7fbfd }
        .ots-hourly-entry.active { display:block }
        .ots-hourly-entry .olt-form { align-items:end }
        @media(max-width:700px) { .ots-processing-head { display:block } .ots-search-row { grid-template-columns:1fr } }
    </style>

   <%-- <script src="OLTracking.js"></script>--%>
   <%-- <script src="../Scripts/TrackingSheet/TrackingSheet.js"></script>--%>
    <script src="OLTracking.js"></script>
    <script src="../Scripts/TrackingSheet/TrackingSheet.js?v=20260901.1"></script>
</asp:Content>

<asp:Content ID="Body" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="olt-page">
        <div class="olt-hero">
            <div>
                <h2>Tracking Sheet</h2>
                <p>Allocate eligible loans, update your queue, and review daily status.</p>
            </div>
        </div>
        <div id="oltAlert" class="olt-alert"></div>
        <div class="ots-tabs">
            <button type="button" class="ots-tab active" data-panel="allocation">Order Allocation</button>
            <button type="button" class="ots-tab" data-panel="daily">Daily Status</button>
        </div>

        <section id="allocation" class="ots-panel active">
            <div class="olt-card">
                <div class="olt-card-head">Loan processing</div>
                <div class="olt-card-body">
                    <div class="olt-form">
                        <div class="olt-field wide">
                            <label>Project #</label><select id="project"></select>
                        </div>
                        <div class="olt-field wide">
                            <label>Deal #</label><select id="deal"><option value="">Select deal</option>
                            </select>
                        </div>
                        <div class="olt-field wide">
                            <label>Process</label><select id="process" disabled><option value="">Select deal first</option>
                            </select>
                        </div>
                        <div id="loanField" class="olt-field wide">
                            <label>Loan #</label><select id="loan" disabled><option value="">Select project, deal and process</option>
                            </select>
                        </div>
                        <div id="legacyAllocationActions" class="olt-field full">
                            <div class="ots-note">Select an eligible loan for allocation. Only one loan can be In Process at a time. Place it on Hold or complete it before starting another loan.</div>
                            <button type="button" class="olt-btn" onclick="allocateLoan()">Allocate</button>
                        </div>
                    </div>
                    <div id="otherProcessingSection" class="ots-other-processing">
                        <div class="ots-processing-head">
                            <div><h3>Pending Loan Processing</h3><p>Work on pending loans without leaving the selected Project / Deal / Process.</p></div>
                        </div>
                        <div id="hourlyEntrySection" class="ots-hourly-entry">
                            <div class="olt-form">
                                <div class="olt-field"><label for="hourlyEntryHours">Hours</label><select id="hourlyEntryHours"></select></div>
                                <div class="olt-field"><label for="hourlyEntryMinutes">Minutes</label><select id="hourlyEntryMinutes"></select></div>
                                <div class="olt-field"><button id="hourlyEntrySubmit" type="button" class="olt-btn">Submit</button></div>
                            </div>
                            <div class="ots-search-help">Submit the total time worked for the selected Project, Deal and Process. Start and End time are not captured.</div>
                        </div>
                        <div id="standardOtherProcessingSection">
                        <div class="ots-search-row">
                            <div class="olt-field">
                                <label for="otherLoanSearch">Loan Search</label>
                                <input id="otherLoanSearch" type="text" placeholder="100245, 100278, 100301" autocomplete="off" />
                                <div class="ots-search-help">Enter one or more comma-separated loan numbers. Spaces are ignored.</div>
                            </div>
                            <div class="olt-field">
                                <label for="processingUserName">Username</label>
                                <input id="processingUserName" class="ots-disabled" readonly />
                            </div>
                            <div><button id="clearOtherLoanSearch" type="button" class="olt-btn secondary">Clear Search</button></div>
                        </div>
                        <div id="otherSelectionCount" class="ots-selection-count">0 loan(s) selected</div>
                        <div class="olt-table-wrap">
                            <table id="otherLoanTable" class="olt-table">
                                <thead id="otherLoanHead"><tr>
                                    <th><input id="selectAllOtherLoans" class="ots-row-check" type="checkbox" aria-label="Select all visible loans" /></th>
                                    <th>LoanNo</th><th>DealNo</th><th>UserName</th><th>StartDate</th><th>EndDate</th><th>Status</th><th>Reason</th><th>Action</th>
                                </tr></thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                    </div>
                    <br />
                    <div id="trackingQueueSection" class="olt-table-wrap">
                        <table class="olt-table">
                            <thead>
                                <tr>
                                    <th>Project</th>
                                    <th>Deal #</th>
                                    <th>Loan #</th>
                                    <th>Process</th>
                                    <th>Status</th>
                                    <th>Assigned</th>
                                    <th>Hold TAT</th>
                                    <th>Net TAT</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody id="queueRows">
                                <tr>
                                    <td colspan="9" class="olt-empty">Loading queue...</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </section>

        <section id="daily" class="ots-panel">
            <div class="olt-card">
                <div class="olt-card-head">Daily status filters</div>
                <div class="olt-card-body">
                    <div class="olt-form">
                        <div class="olt-field">
                            <label>From date</label><input id="trackNew_fromDate" type="date" />
                        </div>
                        <div class="olt-field">
                            <label>To date</label><input id="trackNew_toDate" type="date" />
                        </div>
                        <div class="olt-field">
                            <label>Month</label><input id="monthFilter" type="month" onchange="applyMonth()" />
                        </div>
                        <div class="olt-field">
                            <label>Process</label><select id="dailyProcess"><option value="">All processes</option>
                            </select>
                        </div>
                        <div class="olt-field full">
                            <button type="button" class="olt-btn" onclick="loadDaily()">Show</button>
                        </div>
                    </div>
                </div>
                <div class="olt-table-wrap ots-daily-table-wrap">
                    <table id="dailyTable" class="olt-table">
                        <thead>
                            <tr>
                                <th>Project</th>
                                <th>Deal #</th>
                                <th>Loan #</th>
                                <th>Process</th>
                                <th>Status</th>
                                <th>Assigned</th>
                                <th>Started</th>
                                <th>Completed</th>
                                <th>Hold TAT</th>
                                <th>Total TAT</th>
                                <th>Hours Worked</th>
                                <th>Remark</th>
                            </tr>
                        </thead>
                        <tbody id="dailyRows"></tbody>
                    </table>
                </div>
            </div>
        </section>
    </div>

    <div id="completeModal" class="olt-modal">
        <div class="olt-dialog olt-dialog-large" role="dialog" aria-modal="true" aria-labelledby="completeDialogTitle">
            <div class="olt-dialog-head">
                <span id="completeDialogTitle">Update loan status</span>
                <button type="button" class="olt-dialog-close" onclick="closeComplete()" aria-label="Close popup">&times;</button>
                <button type="button" onclick="closeComplete()">×</button>
            </div>
            <div class="olt-dialog-body">
                <input id="assignmentId" type="hidden" />
                <div id="completionValidation" class="ots-modal-message" role="alert" aria-live="assertive" hidden>
                    <span class="ots-modal-message-icon" aria-hidden="true">!</span>
                    <div><strong id="completionValidationTitle">Unable to update loan</strong><p id="completionValidationText"></p></div>
                </div>
                <div id="statusStep" class="ots-step">
                    <div class="olt-form">
                        <div class="olt-field ots-status-control">
                            <label>Status</label><select id="updateStatus" onchange="changeCompletionStatus()"><option value="">Select status</option>
                                <option value="Completed">Completed</option>
                                <option value="Hold">On Hold</option>
                                <option id="skipStatusOption" value="Skipped" hidden>Skipped</option>
                            </select>
                        </div>
                        <div id="holdReasonField" class="olt-field ots-status-control" style="display: none">
                            <label>Hold Reason</label><select id="holdReason"><option value="">Loading Hold Reasons...</option></select>
                        </div>
                        <div id="statusActions" class="olt-field full olt-actions" style="display:none">
                            <button id="statusContinueButton" type="button" class="olt-btn" onclick="selectCompletionStatus()">Continue</button>
                        </div>
                    </div>
                </div>
                <div id="feedbackStep" class="ots-step">
                    <div class="olt-feedback-heading">
                        <div>
                            <h3>Add Feedback</h3>
                            <p>Add feedback and review every saved error before continuing.</p>
                        </div>
                    </div>
                    <div class="olt-feedback-form">
                        <div class="olt-field">
                            <label>Loan #</label><input id="fbLoanNumber" class="ots-disabled" disabled />
                        </div>
                        <div class="olt-field">
                            <label>Client</label><input id="fbClient" class="ots-disabled" disabled />
                        </div>
                        <div class="olt-field span-2">
                            <label>Previous Process(es)</label>
                            <details id="fbPreviousProcessPicker" class="olt-feedback-process-picker">
                                <summary id="fbPreviousProcessSummary">Select completed process(es)</summary>
                                <div class="olt-feedback-process-menu">
                                    <input id="fbPreviousProcessSearch" type="search" placeholder="Search completed processes..." autocomplete="off" />
                                    <div id="fbPreviousProcessOptions" class="olt-feedback-process-options"></div>
                                    <div class="olt-feedback-process-actions">
                                        <button type="button" class="olt-btn secondary" onclick="clearPreviousProcessSelection();return false;">Clear all</button>
                                        <button type="button" class="olt-btn" onclick="fbPreviousProcessPicker.open=false;return false;">Done</button>
                                    </div>
                                </div>
                            </details>
                            <small class="olt-muted">Feedback is saved against the user who completed each selected process.</small>
                        </div>
                        <div class="olt-field">
                            <label>Date Reviewed</label><input id="fbDateReviewed" class="ots-disabled" disabled />
                        </div>
                        <div class="olt-field">
                            <label>QC Name</label><input id="fbFeedbackBy" class="ots-disabled" disabled />
                        </div>
                        <div class="olt-field">
                            <label>QC Date</label><input id="fbQCDate" class="ots-disabled" disabled />
                        </div>
                        <div class="olt-field">
                            <label>Severity</label><select id="fbSeverity" onchange="severityChanged()"><option value="">Select</option>
                                <option>No Error</option>
                                <option>Non-Critical</option>
                                <option>Critical</option>
                                <option>Critical-Saleable</option>
                            </select>
                        </div>
                        <div class="olt-field">
                            <label>Category</label><select id="fbCategory" onchange="loadFeedbackSubcategories()"><option value="">Select</option></select>
                        </div>
                        <div class="olt-field">
                            <label>Subcategory</label><select id="fbSubcategory"><option value="">Select</option>
                            </select>
                        </div>
                        <div class="olt-field">
                            <label>Error Field</label><input id="fbErrorField" maxlength="500" />
                        </div>
                        <div class="olt-field">
                            <label>Screen</label><input id="fbScreen" maxlength="1000" />
                        </div>
                        <div class="olt-field">
                            <label>Error Type</label><input id="fbErrorType" maxlength="100" />
                        </div>
                        <div class="olt-field">
                            <label>Feedback Type</label><input id="fbFeedbackType" maxlength="100" />
                        </div>
                        <div class="olt-field">
                            <label>Feedback Status</label><input id="fbFeedbackStatus" value="Pending" class="ots-disabled" disabled />
                        </div>
                        <div class="olt-field">
                            <label>Source</label><input id="fbSource" value="Internal" class="ots-disabled" disabled />
                        </div>
                        <div class="olt-field">
                            <label>Feedback Received Date</label><input id="fbReceivedDate" class="ots-disabled" disabled />
                        </div>
                        <div class="olt-field span-3">
                            <label>Finding</label><textarea id="fbError" maxlength="2000"></textarea>
                        </div>
                        <div class="olt-field span-3">
                            <label>RCA</label><textarea id="fbRca" maxlength="2000"></textarea>
                        </div>
                    </div>
                    <div class="olt-actions olt-feedback-actions">
                        <button type="button" class="olt-btn" onclick="saveFeedback()">Add Feedback</button>
                        <button id="continueAfterFeedback" type="button" class="olt-btn secondary" onclick="continueToComplete()" disabled>Continue to Update Loan</button>
                    </div>
                    <div class="olt-saved-feedback">
                        <div class="olt-saved-feedback-title">Saved Feedback Details</div>
                        <div class="olt-table-wrap">
                            <table id="savedFeedbackTable" class="olt-table" style="width:100%">
                                <thead>
                                    <tr>
                                        <th>Feedback #</th>
                                        <th>Previous Process</th>
                                        <th>Feedback Against User</th>
                                        <th>Severity</th>
                                        <th>Category</th>
                                        <th>Subcategory</th>
                                        <th>Error Field</th>
                                        <th>Error Type</th>
                                        <th>Finding</th>
                                        <th>RCA</th>
                                        <th>Status</th>
                                        <th>Added</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                        </div>
                    </div>
                </div>
                <div id="completeStep" class="ots-step">
                    <div class="olt-form">
                        <input id="finalStatus" type="hidden" value="Completed" />
                        <div class="olt-field full">
                            <label>Remark</label><textarea id="completeRemark" maxlength="1000"></textarea>
                        </div>
                        <div class="olt-field full olt-actions ots-completion-actions">
                            <button type="button" class="olt-btn" onclick="submitCompletion()">Update Loan</button>
                            <button type="button" class="olt-btn secondary" onclick="closeComplete()">Cancel</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
