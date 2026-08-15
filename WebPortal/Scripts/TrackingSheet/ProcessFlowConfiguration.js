var page = 'ProcessFlowConfiguration.aspx', processes = [], flow = [], dealProcesses = [], dealProjectFlow = [], dealFlow = [];

document.addEventListener('DOMContentLoaded', function () {
    bindTabs();
    OLT.call(page, 'GetProjects').then(function (r) {
        OLT.options(project, r, ['ProjectID', 'projectID'], ['ProjectName', 'ProjectNo', 'Name'], 'Select project');
        OLT.options(dealProject, r, ['ProjectID', 'projectID'], ['ProjectName', 'ProjectNo', 'Name'], 'Select project');
    });
    project.onchange = loadProject;
    dealProject.onchange = loadDealProject;
    dealNumber.onchange = loadDeal;
});

function bindTabs() {
    [].slice.call(document.querySelectorAll('.flow-tab')).forEach(function (button) {
        button.onclick = function () {
            document.querySelector('.flow-tab.active').classList.remove('active');
            document.querySelector('.flow-panel.active').classList.remove('active');
            button.classList.add('active');
            document.getElementById(button.dataset.panel).classList.add('active');
        };
    });
}

function loadProject() {
    if (!project.value) { flow = []; render(); return; }
    Promise.all([OLT.call(page, 'GetProcesses', { projectId: +project.value }), OLT.call(page, 'GetFlow', { projectId: +project.value })])
        .then(function (r) { processes = r[0] || []; flow = r[1] || []; OLT.options(process, processes, ['ProcessID', 'processID'], ['ProcessAlias', 'Name'], 'Select process'); render(); })
        .catch(showError);
}

function loadDealProject() {
    dealNumber.disabled = true; dealNumber.innerHTML = '<option value="">Select deal</option>'; dealProjectFlow = []; dealFlow = []; renderDeal();
    if (!dealProject.value) return;
    Promise.all([OLT.call(page, 'GetProcesses', { projectId: +dealProject.value }), OLT.call(page, 'GetDeals', { projectId: +dealProject.value }), OLT.call(page, 'GetFlow', { projectId: +dealProject.value })])
        .then(function (r) { dealProcesses = r[0] || []; dealProjectFlow = r[2] || []; OLT.options(dealProcess, dealProcesses, ['ProcessID', 'processID'], ['ProcessAlias', 'Name'], 'Select process'); OLT.options(dealNumber, r[1] || [], ['DealNo', 'DealNumber', 'Deal'], ['DealNo', 'DealNumber', 'Deal'], 'Select deal'); dealNumber.disabled = false; })
        .catch(showError);
}

function loadDeal() {
    dealFlow = []; renderDeal();
    if (!dealProject.value || !dealNumber.value) return;
    OLT.call(page, 'GetDealFlow', { projectId: +dealProject.value, dealNumber: dealNumber.value })
        .then(function (r) { dealFlow = mergeDealFlow(r || []); renderDeal(); }).catch(showError);
}

function mergeDealFlow(overrides) {
    var overrideMap = {}, merged = [], projectMap = {};
    overrides.forEach(function (x) { overrideMap[String(x.ProcessID)] = x; });
    dealProjectFlow.forEach(function (projectRow) {
        var key = String(projectRow.ProcessID), source = overrideMap[key] || projectRow, copy = {};
        Object.keys(source).forEach(function (name) { copy[name] = source[name]; });
        copy.IsDealOverride = !!overrideMap[key]; projectMap[key] = true; merged.push(copy);
    });
    overrides.forEach(function (x) { if (!projectMap[String(x.ProcessID)]) { x.IsDealOverride = true; merged.push(x); } });
    return merged.sort(function (a, b) { return (+a.StageNo - +b.StageNo) || String(a.ProcessName).localeCompare(String(b.ProcessName)); });
}

function render() { rows.innerHTML = flow.length ? flow.map(function (x, i) { return flowRow(x, i, flow, false); }).join('') : '<tr><td colspan="9" class="olt-empty">No tracking processes configured.</td></tr>'; }
function renderDeal() { dealRows.innerHTML = dealFlow.length ? dealFlow.map(function (x, i) { return flowRow(x, i, dealFlow, true); }).join('') : '<tr><td colspan="9" class="olt-empty">No project process flow is configured.</td></tr>'; }
function flowRow(x, i, source, isDeal) {
    var simultaneous = i > 0 && source[i - 1].StageNo === x.StageNo, prefix = isDeal ? 'Deal' : '';
    var isTracking = !(x.IsTrackingSheetProcess === false || x.IsTrackingSheetProcess === 0 || x.IsTrackingSheetProcess === '0');
    var trackingCell = isDeal ? '<td><span class="flow-source ' + (x.IsDealOverride ? 'override' : 'inherited') + '">' + (x.IsDealOverride ? 'Deal override' : 'Project default') + '</span></td>' : '<td>' + (isTracking ? 'Yes' : 'No &ndash; separate processing form') + '</td>';
    var removeButton = isDeal ? '' : ' <button type="button" class="olt-btn danger" onclick="remove' + prefix + 'Flow(' + x.ProcessID + ');return false;">Remove</button>';
    var productivity = x.ProductivityType || 'Loan Based Productivity', expected = productivity === 'Hourly Productivity' ? formatExpectedTime(x.ExpectedCompletionMinutes) : '&mdash;';
    return '<tr><td><span class="flow-stage">' + x.StageNo + '</span>' + (simultaneous ? '<span class="flow-same">simultaneous</span>' : '') + '</td><td>' + OLT.esc(x.ProcessName) + '</td><td>' + (x.IsMandatory ? 'Mandatory' : 'Can be skipped') + '</td><td>' + (x.FeedbackRequiredOnComplete ? 'Yes' : 'No') + '</td><td>' + (x.IsFinalProcess ? '<span class="flow-final">Final</span>' : 'No') + '</td>' + trackingCell + '<td>' + OLT.esc(productivity) + '</td><td>' + expected + '</td><td><button type="button" class="olt-btn secondary" onclick="edit' + prefix + 'Flow(' + x.ProcessID + ');return false;">Edit</button>' + removeButton + '</td></tr>';
}

function editFlow(id) { var x = find(flow, id); if (!x) return; process.value = id; stageNo.value = x.StageNo; requirement.value = x.IsMandatory ? 'mandatory' : 'skippable'; feedback.checked = x.FeedbackRequiredOnComplete; finalProcess.checked = x.IsFinalProcess; trackingSheetProcess.checked = !(x.IsTrackingSheetProcess === false || x.IsTrackingSheetProcess === 0 || x.IsTrackingSheetProcess === '0'); setProductivity(false, x); window.scrollTo(0, 0); }
function editDealFlow(id) { var x = find(dealFlow, id); if (!x) return; dealProcess.value = id; dealStageNo.value = x.StageNo; dealRequirement.value = x.IsMandatory ? 'mandatory' : 'skippable'; dealFeedback.checked = x.FeedbackRequiredOnComplete; dealFinalProcess.checked = x.IsFinalProcess; setProductivity(true, x); window.scrollTo(0, 0); }
function find(source, id) { return source.filter(function (x) { return +x.ProcessID === id; })[0]; }

function clearForm() { process.value = ''; stageNo.value = 1; requirement.value = 'mandatory'; feedback.checked = false; finalProcess.checked = false; trackingSheetProcess.checked = true; setProductivity(false, {}); }
function clearDealForm() { dealProcess.value = ''; dealStageNo.value = 1; dealRequirement.value = 'mandatory'; dealFeedback.checked = false; dealFinalProcess.checked = false; setProductivity(true, {}); }

function setProductivity(isDeal, row) { var type = document.getElementById(isDeal ? 'dealProductivityType' : 'productivityType'); type.value = row.ProductivityType || 'Loan Based Productivity'; document.getElementById(isDeal ? 'dealExpectedHours' : 'expectedHours').value = Math.floor(+(row.ExpectedCompletionMinutes || 0) / 60); document.getElementById(isDeal ? 'dealExpectedMinutes' : 'expectedMinutes').value = +(row.ExpectedCompletionMinutes || 0) % 60; toggleExpectedTime(isDeal); }
function toggleExpectedTime(isDeal) { var type = document.getElementById(isDeal ? 'dealProductivityType' : 'productivityType'), fields = document.getElementById(isDeal ? 'dealExpectedTimeFields' : 'expectedTimeFields'); fields.style.display = type.value === 'Hourly Productivity' ? '' : 'none'; }
function expectedMinutes(isDeal) { var type = document.getElementById(isDeal ? 'dealProductivityType' : 'productivityType').value, hours = +(document.getElementById(isDeal ? 'dealExpectedHours' : 'expectedHours').value || 0), minutes = +(document.getElementById(isDeal ? 'dealExpectedMinutes' : 'expectedMinutes').value || 0); if (type !== 'Hourly Productivity') return 0; if (hours < 0 || minutes < 0 || minutes > 59 || hours * 60 + minutes < 1) { OLT.alert('Expected Completion Time must be at least 00:01 and minutes must be between 0 and 59.', true); return -1; } return hours * 60 + minutes; }
function formatExpectedTime(value) { var minutes = +(value || 0); return String(Math.floor(minutes / 60)).padStart(2, '0') + ':' + String(minutes % 60).padStart(2, '0'); }

function saveFlow() {
    if (!project.value || !process.value || +stageNo.value < 1) return OLT.alert('Project, process, and valid sequence are required.', true);
    var minutes = expectedMinutes(false); if (minutes < 0) return;
    callSave('SaveFlow', { projectId: +project.value, processId: +process.value, processName: process.options[process.selectedIndex].text, stageNo: +stageNo.value, isMandatory: requirement.value === 'mandatory', feedbackRequired: feedback.checked, isFinalProcess: finalProcess.checked, isTrackingSheetProcess: trackingSheetProcess.checked, productivityType: productivityType.value, expectedCompletionMinutes: minutes }, clearForm, loadProject);
}
function saveDealFlow() {
    if (!dealProject.value || !dealNumber.value || !dealProcess.value || +dealStageNo.value < 1) return OLT.alert('Project, deal, process, and valid sequence are required.', true);
    var minutes = expectedMinutes(true); if (minutes < 0) return;
    callSave('SaveDealFlow', { projectId: +dealProject.value, dealNumber: dealNumber.value, processId: +dealProcess.value, processName: dealProcess.options[dealProcess.selectedIndex].text, stageNo: +dealStageNo.value, isMandatory: dealRequirement.value === 'mandatory', feedbackRequired: dealFeedback.checked, isFinalProcess: dealFinalProcess.checked, productivityType: dealProductivityType.value, expectedCompletionMinutes: minutes }, clearDealForm, loadDeal);
}
function callSave(method, model, clear, reload) { OLT.call(page, method, model).then(function () { OLT.alert('Process flow saved.'); clear(); reload(); }).catch(showError); }

function removeFlow(id) { remove('RemoveFlow', { projectId: +project.value, processId: id }, loadProject); }
function removeDealFlow(id) { remove('RemoveDealFlow', { projectId: +dealProject.value, dealNumber: dealNumber.value, processId: id }, loadDeal); }
function remove(method, model, reload) { if (!confirm('Remove this process from the tracking flow?')) return; OLT.call(page, method, model).then(function () { OLT.alert('Process removed.'); reload(); }).catch(showError); }
function showError(e) { OLT.alert(e && e.message ? e.message : 'The requested action could not be completed.', true); }
