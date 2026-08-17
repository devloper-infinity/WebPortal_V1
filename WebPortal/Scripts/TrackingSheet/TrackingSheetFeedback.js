var page = 'TrackingSheetFeedback.aspx', assignmentId = 0, context = {}, feedbackOwners = [], feedbackConfiguredProcesses = [], selectedTargetIds = [], unavailableConfiguredTargets = 0, savedFeedbackCount = 0, feedbackDirty = false, allowNavigation = false;

document.addEventListener('DOMContentLoaded', function () {
    assignmentId = +(new URLSearchParams(window.location.search).get('assignmentId') || 0);
    if (!assignmentId) { feedbackPageLoading.textContent = 'A valid Tracking Sheet assignment is required.'; return; }
    manualTarget.onchange = manualTargetChanged;
    feedbackSeverity.onchange = severityChanged;
    feedbackCategory.onchange = loadSubcategories;
    addFeedbackButton.onclick = saveFeedback;
    completeLoanButton.onclick = completeLoan;
    feedbackPageContent.addEventListener('input', function () { feedbackDirty = true; });
    window.addEventListener('beforeunload', function (event) { if (!allowNavigation && feedbackDirty) { event.preventDefault(); event.returnValue = ''; } });
    loadPage();
});

function parseResult(value) { if (typeof value === 'string') { try { return JSON.parse(value); } catch (error) { return {}; } } return value || {}; }
function loadPage() {
    return Promise.all([OLT.call(page, 'GetPageData', { assignmentId: assignmentId }), OLT.call(page, 'GetFeedbackCategories')])
        .then(function (result) {
            var data = parseResult(result[0]); context = (data.table0 || [])[0] || {};
            feedbackOwners = deduplicateOwners(data.table2 || []); feedbackConfiguredProcesses = data.table4 || [];
            fillSelect(feedbackCategory, result[1] || [], 'Value', 'Text', 'Select');
            bindContext(); renderTargets(); renderSavedFeedback(data.table3 || []);
            savedFeedbackCount = +(context.FeedbackCount || 0); updateCompletionState(data.table3 || []);
            feedbackPageLoading.hidden = true; feedbackPageContent.hidden = false;
        }).catch(showLoadError);
}
function refreshPageData() {
    return OLT.call(page, 'GetPageData', { assignmentId: assignmentId }).then(function (raw) {
        var data = parseResult(raw); context = (data.table0 || [])[0] || {}; feedbackOwners = deduplicateOwners(data.table2 || []); feedbackConfiguredProcesses = data.table4 || [];
        bindContext(); renderTargets(); renderSavedFeedback(data.table3 || []); savedFeedbackCount = +(context.FeedbackCount || 0); updateCompletionState(data.table3 || []);
    });
}
function deduplicateOwners(rows) { var seen = {}; return rows.filter(function (row) { var key = String(row.ProcessID); if (seen[key]) return false; seen[key] = true; return true; }); }
function bindContext() {
    contextProject.textContent = context.Client || context.ProjectID || '';
    contextDeal.textContent = context.DealNumber || '';
    contextLoan.textContent = context.LoanNumber || '';
    contextProcess.textContent = context.ProcessName || '';
    feedbackBy.value = context.FeedbackBy || ''; feedbackQcDate.value = context.QCDate || '';
}
function ownerForProcess(processId) { return feedbackOwners.filter(function (owner) { return +owner.ProcessID === +processId; })[0] || null; }
function renderTargets() {
    selectedTargetIds = []; unavailableConfiguredTargets = 0;
    var hasConfiguration = feedbackConfiguredProcesses.length > 0 || context.HasConfiguredFeedbackTargets === true;
    configuredTargetsContainer(hasConfiguration);
    if (!hasConfiguration) { renderManualTarget(); return; }
    routingHelp.textContent = 'Feedback will be saved automatically against every configured previous process user shown below.';
    configuredTargetList.innerHTML = feedbackConfiguredProcesses.map(function (target) {
        var owner = ownerForProcess(target.ProcessID), available = !!owner;
        if (available) selectedTargetIds.push(+owner.AssignmentID); else unavailableConfiguredTargets++;
        return '<div class="feedback-target' + (available ? ' selected' : ' unavailable') + '"><span class="feedback-target-content"><span class="feedback-target-process">' + OLT.esc(target.ProcessName) + '</span>' + (available ? '<span class="feedback-target-user">Completed By: ' + OLT.esc(owner.UserName) + '</span><span class="olt-muted">Completed On: ' + OLT.esc(formatDateTime(owner.CompletedDate)) + '</span>' : '<span class="feedback-target-status">Not Completed</span>') + '</span></div>';
    }).join('');
    addFeedbackButton.disabled = unavailableConfiguredTargets > 0;
}
function configuredTargetsContainer(configured) { configuredTargetList.hidden = !configured; manualTargetField.hidden = configured; }
function renderManualTarget() {
    routingHelp.textContent = 'No Feedback Against configuration exists for this process. Select a completed previous process manually.';
    manualTarget.innerHTML = '<option value="">Select Process</option>' + feedbackOwners.map(function (owner) { return '<option value="' + (+owner.AssignmentID) + '">' + OLT.esc(owner.ProcessName) + '</option>'; }).join('');
    manualCompletedBy.textContent = feedbackOwners.length ? '' : 'No completed previous process is available for this loan.'; addFeedbackButton.disabled = false;
}
function manualTargetChanged() {
    var id = +manualTarget.value, owner = feedbackOwners.filter(function (row) { return +row.AssignmentID === id; })[0];
    selectedTargetIds = owner ? [id] : []; manualCompletedBy.innerHTML = owner ? '<strong>Completed By:</strong> ' + OLT.esc(owner.UserName) + '<br/><strong>Completed On:</strong> ' + OLT.esc(formatDateTime(owner.CompletedDate)) : '';
}
function formatDate(value) { if (!value) return ''; var number = parseInt(String(value).replace(/\D/g, ''), 10), date = number ? new Date(number) : new Date(value); if (isNaN(date.getTime())) return ''; return String(date.getMonth() + 1).padStart(2, '0') + '/' + String(date.getDate()).padStart(2, '0') + '/' + date.getFullYear(); }
function formatDateTime(value) { if (!value) return ''; var number = parseInt(String(value).replace(/\D/g, ''), 10), date = number ? new Date(number) : new Date(value); if (isNaN(date.getTime())) return ''; return date.toLocaleString('en-GB', { day:'2-digit', month:'short', year:'numeric', hour:'2-digit', minute:'2-digit', hour12:true }); }
function fillSelect(element, rows, valueName, textName, placeholder) { element.innerHTML = '<option value="">' + placeholder + '</option>'; rows.forEach(function (row) { var option = document.createElement('option'); option.value = row[valueName]; option.textContent = row[textName]; element.appendChild(option); }); }
function loadSubcategories() { feedbackSubcategory.innerHTML = '<option value="">Select</option>'; if (!feedbackCategory.value) return Promise.resolve(); return OLT.call(page, 'GetFeedbackSubcategories', { categoryId: +feedbackCategory.value }).then(function (rows) { fillSelect(feedbackSubcategory, rows || [], 'Value', 'Text', 'Select'); }); }
function selectByText(element, text) { var option = [].slice.call(element.options).filter(function (item) { return item.text.trim().toLowerCase() === text.toLowerCase(); })[0]; if (option) element.value = option.value; return !!option; }
function severityChanged() {
    var noError = feedbackSeverity.value === 'No Error', fields = [feedbackCategory, feedbackSubcategory, feedbackErrorField, feedbackScreen, feedbackErrorType, feedbackType, feedbackFinding, feedbackRca];
    fields.forEach(function (field) { field.disabled = noError; });
    if (!noError) return;
    if (!selectByText(feedbackCategory, 'Compliance')) { OLT.alert('Compliance category is not configured. Please contact the administrator.', true); feedbackSeverity.value = ''; return severityChanged(); }
    loadSubcategories().then(function () { if (!selectByText(feedbackSubcategory, 'Compliance')) { OLT.alert('Compliance subcategory is not configured. Please contact the administrator.', true); feedbackSeverity.value = ''; return severityChanged(); } feedbackErrorField.value = 'NA'; feedbackScreen.value = 'NA'; feedbackErrorType.value = 'NA'; feedbackType.value = 'NA'; feedbackFinding.value = 'No Error'; feedbackRca.value = 'No Error'; });
}
function feedbackModel() { return { AssignmentID: assignmentId, TargetAssignmentIDs: selectedTargetIds.slice(), FeedbackBy: feedbackBy.value, ErrorType: feedbackErrorType.value.trim(), CategoryID: +feedbackCategory.value || 0, Category: feedbackCategory.options[feedbackCategory.selectedIndex] ? feedbackCategory.options[feedbackCategory.selectedIndex].text : '', SubcategoryID: +feedbackSubcategory.value || 0, Subcategory: feedbackSubcategory.options[feedbackSubcategory.selectedIndex] ? feedbackSubcategory.options[feedbackSubcategory.selectedIndex].text : '', Severity: feedbackSeverity.value, ErrorField: feedbackErrorField.value.trim(), Screen: feedbackScreen.value.trim(), FeedbackType: feedbackType.value.trim(), Error: feedbackFinding.value.trim(), ShouldBe: feedbackRca.value.trim(), Remark: '' }; }
function validate(model) { if (unavailableConfiguredTargets > 0) return 'All configured Previous Processes must be completed before feedback can be added.'; if (!model.TargetAssignmentIDs.length) return 'Select a completed Previous Process.'; if (!model.Severity) return 'Select Severity.'; if (!model.CategoryID) return 'Select Category.'; if (!model.SubcategoryID) return 'Select Subcategory.'; if (!model.ErrorField) return 'Enter Error Field.'; if (!model.Screen) return 'Enter Screen.'; if (!model.ErrorType) return 'Enter Error Type.'; if (!model.FeedbackType) return 'Enter Feedback Type.'; if (!model.Error) return 'Enter Finding.'; if (!model.ShouldBe) return 'Enter RCA.'; return ''; }
function saveFeedback() {
    var model = feedbackModel(), error = validate(model); if (error) { OLT.alert(error, true); return; }
    addFeedbackButton.disabled = true;
    OLT.call(page, 'SaveFeedback', { model: model }).then(function (result) { if (!result || !result.Success) { OLT.alert(result && result.Message ? result.Message : 'Feedback could not be saved.', true); return; } OLT.alert(result.Message || 'Feedback saved.'); feedbackDirty = false; clearFeedbackFields(); return refreshPageData(); }).catch(showError).then(function () { addFeedbackButton.disabled = false; });
}
function clearFeedbackFields() { feedbackSeverity.value = ''; [feedbackCategory, feedbackSubcategory].forEach(function (field) { field.disabled = false; }); feedbackCategory.value = ''; feedbackSubcategory.innerHTML = '<option value="">Select</option>'; [feedbackErrorField, feedbackScreen, feedbackErrorType, feedbackType, feedbackFinding, feedbackRca].forEach(function (field) { field.disabled = false; field.value = ''; }); }
function renderSavedFeedback(rows) { savedFeedbackRows.innerHTML = rows.length ? rows.map(function (row) { return '<tr><td>' + OLT.esc(row.FeedbackID) + '</td><td>' + OLT.esc(row.MarkedTo) + '</td><td>' + OLT.esc(row.ErrorBy) + '</td><td>' + OLT.esc(row.Severity) + '</td><td>' + OLT.esc(row.Category) + '</td><td>' + OLT.esc(row.Subcategory) + '</td><td>' + OLT.esc(row.ErrorField) + '</td><td>' + OLT.esc(row.ErrorType) + '</td><td>' + OLT.esc(row.Finding) + '</td><td>' + OLT.esc(row.RCA) + '</td><td>' + OLT.esc(row.FeedbackStatus || 'Pending') + '</td><td>' + OLT.esc(formatDate(row.AddedDate)) + '</td></tr>'; }).join('') : '<tr><td colspan="12" class="olt-empty">No feedback added yet.</td></tr>'; }
function updateCompletionState(rows) { var configuredSatisfied = !feedbackConfiguredProcesses.length || feedbackConfiguredProcesses.every(function (target) { return rows.some(function (row) { return +row.FeedbackAgainstProcessID === +target.ProcessID; }); }); completeLoanButton.disabled = unavailableConfiguredTargets > 0 || savedFeedbackCount < 1 || !configuredSatisfied; }
function completeLoan() { if (savedFeedbackCount < 1) { OLT.alert('Save at least one valid feedback entry before completing the loan.', true); return; } if (!completionRemark.value.trim()) { OLT.alert('Completion Remark is required.', true); return; } completeLoanButton.disabled = true; OLT.call(page, 'CompleteLoan', { assignmentId: assignmentId, remark: completionRemark.value.trim() }).then(function (result) { if (!result || !result.Success) { completeLoanButton.disabled = false; OLT.alert(result && result.Message ? result.Message : 'The loan could not be completed.', true); return; } allowNavigation = true; window.location.href = 'TrackingSheet.aspx'; }).catch(function (error) { completeLoanButton.disabled = false; showError(error); }); }
function showLoadError(error) { feedbackPageLoading.textContent = error && error.message ? error.message : 'The feedback page could not be loaded.'; OLT.alert(feedbackPageLoading.textContent, true); }
function showError(error) { OLT.alert(error && error.message ? error.message : 'The requested action could not be completed.', true); }
