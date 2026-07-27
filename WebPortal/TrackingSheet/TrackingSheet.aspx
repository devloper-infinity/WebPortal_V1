<%@ Page Title="Tracking Sheet" Language="C#" MasterPageFile="~/Production/Production.Master" AutoEventWireup="true" CodeBehind="TrackingSheet.aspx.cs" Inherits="WebPortal.TrackingSheet.TrackingSheetPage" %>

<asp:Content ID="Head" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="OLTracking.css" />
    <link rel="stylesheet" href="TrackingSheetFeedback.css" />

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
    </style>

    <script src="OLTracking.js"></script>
    <script src="../Scripts/TrackingSheet/TrackingSheet.js"></script>
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
                <div class="olt-card-head">Allocate one eligible loan</div>
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
                        <div class="olt-field wide">
                            <label>Loan #</label><select id="loan" class="ots-disabled" disabled><option value="">Select project, deal and process</option>
                            </select>
                        </div>
                        <div class="olt-field full">
                            <div class="ots-note">The first eligible loan is populated automatically and cannot be changed. Only one loan can be In Process at a time. Place it on Hold or complete it before starting another loan.</div>
                            <button type="button" class="olt-btn" onclick="allocateLoan()">Allocate</button>
                        </div>
                    </div>
                    <br />
                    <div class="olt-table-wrap">
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
                            <label>From date</label><input id="fromDate" type="date" />
                        </div>
                        <div class="olt-field">
                            <label>To date</label><input id="toDate" type="date" />
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
                <div id="statusStep" class="ots-step">
                    <div class="olt-form">
                        <div class="olt-field wide">
                            <label>Status</label><select id="updateStatus" onchange="changeCompletionStatus()"><option value="">Select status</option>
                                <option value="Completed">Completed</option>
                                <option value="Hold">Hold</option>
                            </select>
                        </div>
                        <div id="holdReasonField" class="olt-field wide" style="display: none">
                            <label>Hold Reason</label><select id="holdReason"><option value="">Select</option>
                                <option>PDF Issue</option>
                                <option>Audit Worksheet Not available in Box</option>
                                <option>Partially Review in Scienna</option>
                                <option>Wrongly pulled in ERP</option>
                                <option value="Miscellaneous - Any other issue with comments">Miscellaneous &ndash; Any other issue with comments</option>
                            </select>
                        </div>
                        <div class="olt-field full olt-actions">
                            <button id="statusContinueButton" type="button" class="olt-btn" onclick="selectCompletionStatus()">Continue</button>
                        </div>
                    </div>
                </div>
                <div id="feedbackStep" class="ots-step">
                    <div class="olt-feedback-heading">
                        <div>
                            <h3>Add Feedback</h3>
                            <p>At least one feedback entry is mandatory before the loan can be completed.</p>
                        </div>
                        <span id="savedFeedbackCount" class="olt-feedback-count">0 feedback added</span>
                    </div>
                    <div class="olt-feedback-form">
                        <div class="olt-field">
                            <label>Loan #</label><input id="fbLoanNumber" class="ots-disabled" disabled />
                        </div>
                        <div class="olt-field">
                            <label>Client</label><input id="fbClient" class="ots-disabled" disabled />
                        </div>
                        <div class="olt-field">
                            <label>UW Name</label><select id="fbErrorBy" onchange="bindFeedbackOwner()"><option value="">Select</option>
                            </select>
                        </div>
                        <div class="olt-field">
                            <label>Previous Process</label><input id="fbMarkedTo" class="ots-disabled" disabled />
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
                            <label>Category</label><select id="fbCategory" onchange="loadFeedbackSubcategories()"><option value="">Select</option>
                            </select>
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
                            <label>Severity</label><select id="fbSeverity"><option value="">Select</option>
                                <option>Non-Critical</option>
                                <option>Critical</option>
                                <option>Critical-Saleable</option>
                            </select>
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
                    </div>
                    <div class="olt-actions olt-feedback-actions">
                        <button type="button" class="olt-btn" onclick="saveFeedback()">Add Feedback</button>
                        <button id="continueAfterFeedback" type="button" class="olt-btn secondary" onclick="continueToComplete()" disabled>Continue to Update Loan</button>
                    </div>
                    <div id="savedFeedbackList" class="olt-saved-feedback"></div>
                </div>
                <div id="completeStep" class="ots-step">
                    <div class="olt-form">
                        <div class="olt-field wide">
                            <label>Status</label><input value="Completed" class="ots-disabled" disabled />
                        </div>
                        <div class="olt-field full">
                            <label>Remark</label><textarea id="completeRemark" maxlength="1000"></textarea>
                        </div>
                        <div class="olt-field full olt-actions">
                            <button type="button" class="olt-btn" onclick="submitCompletion()">Update Loan</button>
                            <button type="button" class="olt-btn secondary" onclick="closeComplete()">Cancel</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


</asp:Content>
