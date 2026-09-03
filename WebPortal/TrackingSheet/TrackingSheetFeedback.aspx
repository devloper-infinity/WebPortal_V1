<%@ Page Title="Mandatory Feedback" Language="C#" MasterPageFile="~/TrackingSheet/TrackingSheetMaster.Master" AutoEventWireup="true" CodeBehind="TrackingSheetFeedback.aspx.cs" Inherits="WebPortal.TrackingSheet.TrackingSheetFeedbackPage" %>

<asp:Content ID="Head" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="OLTracking.css?v=20260901.1" />
    <link rel="stylesheet" href="TrackingSheetFeedbackEntry.css?v=20260816.2" />
    <script src="OLTracking.js?v=20260901.1"></script>
    <script src="../Scripts/TrackingSheet/TrackingSheetFeedback.js?v=20260819.1"></script>
</asp:Content>

<asp:Content ID="Body" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="olt-page feedback-page">
        <div class="olt-hero feedback-hero">
            <div><h2>Mandatory Feedback</h2><p>Add the required feedback before completing this loan process.</p></div>
            <a class="olt-btn secondary" href="TrackingSheet.aspx">Back to Tracking Sheet</a>
        </div>
        <div id="oltAlert" class="olt-alert"></div>
        <div id="feedbackPageLoading" class="feedback-page-loading">Loading loan and process details...</div>
        <div id="feedbackPageContent" hidden>
            <section class="olt-card feedback-section">
                <div class="olt-card-head">Loan context</div>
                <div class="olt-card-body feedback-context-grid">
                    <div><span>Project</span><strong id="contextProject"></strong></div>
                    <div><span>Deal</span><strong id="contextDeal"></strong></div>
                    <div><span>Loan #</span><strong id="contextLoan"></strong></div>
                    <div><span>Current Process</span><strong id="contextProcess"></strong></div>
                </div>
            </section>

            <section class="olt-card feedback-section">
                <div class="olt-card-head">Feedback Against</div>
                <div class="olt-card-body">
                    <p id="routingHelp" class="feedback-help"></p>
                    <div id="configuredTargetList" class="feedback-target-grid"></div>
                    <div id="manualTargetField" class="olt-field feedback-manual-target" hidden>
                        <label>Previous Process <span class="feedback-required">*</span></label>
                        <select id="manualTarget"><option value="">Select Process</option></select>
                        <div id="manualCompletedBy" class="feedback-manual-owner"></div>
                    </div>
                </div>
            </section>

            <section class="olt-card feedback-section">
                <div class="olt-card-head">Feedback details</div>
                <div class="olt-card-body">
                    <div class="feedback-form-grid">
                        <div class="olt-field"><label>QC Name</label><input id="feedbackBy" disabled /></div>
                        <div class="olt-field"><label>QC Date</label><input id="feedbackQcDate" disabled /></div>
                        <div class="olt-field"><label>Severity</label><select id="feedbackSeverity"><option value="">Select</option><option>No Error</option><option>Non-Critical</option><option>Critical</option></select></div>
                        <div class="olt-field"><label>Category</label><select id="feedbackCategory"><option value="">Select</option></select></div>
                        <div class="olt-field"><label>Subcategory</label><select id="feedbackSubcategory"><option value="">Select</option></select></div>
                        <div class="olt-field"><label>Error Field</label><input id="feedbackErrorField" maxlength="500" /></div>
                        <div class="olt-field"><label>Screen</label><input id="feedbackScreen" maxlength="1000" /></div>
                        <div class="olt-field"><label>Error Type</label><input id="feedbackErrorType" maxlength="100" /></div>
                        <div class="olt-field"><label>Feedback Type</label><input id="feedbackType" maxlength="100" /></div>
                        <div class="olt-field full"><label>Finding</label><textarea id="feedbackFinding" maxlength="2000"></textarea></div>
                        <div class="olt-field full"><label>RCA</label><textarea id="feedbackRca" maxlength="2000"></textarea></div>
                    </div>
                    <div class="olt-actions feedback-actions"><button id="addFeedbackButton" type="button" class="olt-btn">Add Feedback</button></div>
                </div>
            </section>

            <section class="olt-card feedback-section">
                <div class="olt-card-head">Saved Feedback Details</div>
                <div class="feedback-table-scroll">
                    <table class="olt-table">
                        <thead><tr><th>Feedback #</th><th>Previous Process</th><th>Completed By</th><th>Severity</th><th>Category</th><th>Subcategory</th><th>Error Field</th><th>Error Type</th><th>Finding</th><th>RCA</th><th>Status</th><th>Added</th></tr></thead>
                        <tbody id="savedFeedbackRows"><tr><td colspan="12" class="olt-empty">No feedback added yet.</td></tr></tbody>
                    </table>
                </div>
            </section>

            <section class="olt-card feedback-section completion-section">
                <div class="olt-card-head">Complete Loan Process</div>
                <div class="olt-card-body">
                    <div class="olt-field full"><label>Completion Remark</label><textarea id="completionRemark" maxlength="1000"></textarea></div>
                    <p class="feedback-help">The loan remains pending or in process until feedback is saved and completion succeeds.</p>
                    <div class="olt-actions"><button id="completeLoanButton" type="button" class="olt-btn" disabled>Complete Loan</button></div>
                </div>
            </section>
        </div>
    </div>
</asp:Content>
