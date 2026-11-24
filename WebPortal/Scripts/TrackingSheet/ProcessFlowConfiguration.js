var page = 'ProcessFlowConfiguration.aspx', processes = [], flow = [], dealProcesses = [], dealProjectFlow = [], dealFlow = [], contextProcesses = [], contextProjectFlow = [], contextFlow = [], eligibleAfterSelection = [], feedbackTargetSelection = [], activeFlowAction = null;

document.addEventListener('DOMContentLoaded', function () {
    bindTabs();
    OLT.call(page, 'GetProjects').then(function (r) {
        OLT.options(project, r, ['ProjectID', 'projectID'], ['ProjectName', 'ProjectNo', 'Name'], 'Select project');
        OLT.options(dealProject, r, ['ProjectID', 'projectID'], ['ProjectName', 'ProjectNo', 'Name'], 'Select project');
    });
    project.onchange = loadProject;
    process.onchange = renderProjectPickers;
    stageNo.oninput = renderProjectPickers;
    eligibleAfterSearch.oninput = renderEligibleAfterOptions;
    feedbackAgainstSearch.oninput = renderFeedbackTargetOptions;
    dealProject.onchange = loadDealProject;
    dealNumber.onchange = loadDeal;
    if (document.getElementById('contextProject')) {
        OLT.call(page, 'GetCanopyProjects').then(function (r) { OLT.options(contextProject, r, ['ProjectID', 'projectID'], ['ProjectName', 'ProjectNo', 'Name'], 'Select project'); }).catch(showError);
        contextProject.onchange = loadContextProject; contextType.onchange = loadContextFlow;
    }
    document.addEventListener('click', closeFlowActionMenu);
    window.addEventListener('resize', closeFlowActionMenu);
    [].slice.call(document.querySelectorAll('.flow-grid-scroll')).forEach(function (wrapper) { wrapper.addEventListener('scroll', closeFlowActionMenu); });
});

function bindTabs() {
    [].slice.call(document.querySelectorAll('.flow-tab')).forEach(function (button) {
        button.onclick = function () {
            var target = document.getElementById(button.dataset.panel);
            if (!target) return;
            var activeTab = document.querySelector('.flow-tab.active'), activePanel = document.querySelector('.flow-panel.active');
            if (activeTab) activeTab.classList.remove('active');
            if (activePanel) activePanel.classList.remove('active');
            button.classList.add('active');
            target.classList.add('active');
        };
    });
}

function loadProject() {
    if (!project.value) { flow = []; render(); return; }
    Promise.all([OLT.call(page, 'GetProcesses', { projectId: +project.value }), OLT.call(page, 'GetFlow', { projectId: +project.value })])
        .then(function (r) { processes = r[0] || []; flow = r[1] || []; OLT.options(process, processes, ['ProcessID', 'processID'], ['ProcessAlias', 'ProcessName', 'Name'], 'Select process'); clearEligibleAfter(); clearFeedbackTargets(); render(); })
        .catch(showError);
}

function loadDealProject() {
    dealNumber.disabled = true; dealNumber.innerHTML = '<option value="">Select deal</option>'; dealProjectFlow = []; dealFlow = []; renderDeal();
    if (!dealProject.value) return;
    Promise.all([OLT.call(page, 'GetProcesses', { projectId: +dealProject.value }), OLT.call(page, 'GetDeals', { projectId: +dealProject.value }), OLT.call(page, 'GetFlow', { projectId: +dealProject.value })])
        .then(function (r) { dealProcesses = r[0] || []; dealProjectFlow = r[2] || []; OLT.options(dealProcess, dealProcesses, ['ProcessID', 'processID'], ['ProcessAlias', 'ProcessName', 'Name'], 'Select process'); OLT.options(dealNumber, r[1] || [], ['DealNo', 'DealNumber', 'Deal'], ['DealNo', 'DealNumber', 'Deal'], 'Select deal'); dealNumber.disabled = false; })
        .catch(showError);
}

function loadDeal() {
    dealFlow = []; renderDeal();
    if (!dealProject.value || !dealNumber.value) return;
    OLT.call(page, 'GetDealFlow', { projectId: +dealProject.value, dealNumber: dealNumber.value })
        .then(function (r) { dealFlow = mergeDealFlow(r || []); renderDeal(); }).catch(showError);
}

function loadContextProject() {
    contextProjectFlow = []; contextFlow = []; clearContextForm(); renderContext();
    if (!contextProject.value) return;
    OLT.call(page, 'GetFlow', { projectId: +contextProject.value }).then(function (r) { contextProjectFlow = r || []; loadContextFlow(); }).catch(showError);
}
function loadContextFlow() {
    contextFlow = []; clearContextForm(); renderContext();
    if (!contextProject.value || !contextType.value) return;
    OLT.call(page, 'GetContextDealFlow', { projectId: +contextProject.value, configurationProcess: contextType.value, dealNumber: '' }).then(function (r) { contextFlow = mergeContextFlow(r || []); renderContext(); }).catch(showError);
}
function mergeContextFlow(overrides) {
    var map = {}, seen = {}, result = []; overrides.forEach(function (x) { map[String(x.ProcessID)] = x; });
    contextProjectFlow.forEach(function (x) { var key = String(x.ProcessID), source = map[key] || x, copy = {}; Object.keys(source).forEach(function (n) { copy[n] = source[n]; }); copy.IsDealOverride = !!map[key]; seen[key] = true; result.push(copy); });
    overrides.forEach(function (x) { if (!seen[String(x.ProcessID)]) { x.IsDealOverride = true; result.push(x); } });
    return result.sort(function (a, b) { return (+a.StageNo - +b.StageNo) || String(a.ProcessName).localeCompare(String(b.ProcessName)); });
}
function renderContext() {
    if (!document.getElementById('contextRows')) return;
    contextRows.innerHTML = contextFlow.length ? contextFlow.map(function (x) { var override = !!x.IsDealOverride, out = x.IsOutOfScope === true || x.IsOutOfScope === 1 || x.IsOutOfScope === '1'; return '<tr><td><button type="button" class="flow-action-button" onclick="editContextFlow(' + (+x.ProcessID) + ')">&#9998;</button> ' + (override ? '<button type="button" class="flow-action-button" onclick="removeContextFlow(' + (+x.ProcessID) + ')">&#128465;</button>' : '') + '</td><td>' + OLT.esc(x.ProcessName) + '</td><td><span class="flow-stage">' + x.StageNo + '</span></td><td>' + (out ? '<span class="flow-final">Out of Scope</span>' : (x.IsMandatory ? 'Mandatory' : 'Can be skipped')) + '</td><td>' + (x.FeedbackRequiredOnComplete ? 'Yes' : 'No') + '</td><td>' + (x.IsFinalProcess ? '<span class="flow-final">Final</span>' : 'No') + '</td><td><span class="flow-source ' + (override ? 'override">Process override' : 'inherited">Project default') + '</span></td><td>' + OLT.esc(x.ProductivityType || 'Loan Based Productivity') + '</td><td>' + (x.MinCompletionMinutes == null ? '&mdash;' : x.MinCompletionMinutes) + '</td><td>' + (x.MaxCompletionMinutes == null ? '&mdash;' : x.MaxCompletionMinutes) + '</td></tr>'; }).join('') : '<tr><td colspan="10" class="olt-empty">Select a project, process, and deal.</td></tr>';
}
function editContextFlow(id) { var x = find(contextFlow, id); if (!x) return; contextProcess.value = id; contextProcessName.value = x.ProcessName; contextStageNo.value = x.StageNo; contextRequirement.value = x.IsOutOfScope ? 'out-of-scope' : (x.IsMandatory ? 'mandatory' : 'skippable'); contextFeedback.checked = !!x.FeedbackRequiredOnComplete; contextFinalProcess.checked = !!x.IsFinalProcess; contextProductivityType.value = x.ProductivityType || 'Loan Based Productivity'; contextMinCompletionMinutes.value = x.MinCompletionMinutes == null ? '' : x.MinCompletionMinutes; contextMaxCompletionMinutes.value = x.MaxCompletionMinutes == null ? '' : x.MaxCompletionMinutes; toggleContextScopeControls(); }
function clearContextForm() { contextProcess.value = ''; contextProcessName.value = ''; contextStageNo.value = 1; contextRequirement.value = 'mandatory'; contextFeedback.checked = false; contextFinalProcess.checked = false; contextProductivityType.value = 'Loan Based Productivity'; contextMinCompletionMinutes.value = ''; contextMaxCompletionMinutes.value = ''; toggleContextScopeControls(); }
function toggleContextScopeControls() { var disabled = contextRequirement.value === 'out-of-scope'; [contextFeedback, contextFinalProcess, contextProductivityType, contextMinCompletionMinutes, contextMaxCompletionMinutes].forEach(function (x) { x.disabled = disabled; }); if (disabled) { contextFeedback.checked = false; contextFinalProcess.checked = false; } }
function saveContextFlow() {
    if (!contextProject.value || !contextType.value || !contextProcess.value || +contextStageNo.value < 1) return OLT.alert('Select Project and Pre/Post Close, then edit a process from the list.', true);
    var min = optionalMinutes(contextMinCompletionMinutes), max = optionalMinutes(contextMaxCompletionMinutes); if (isNaN(min) || isNaN(max) || (min != null && max != null && max < min)) return OLT.alert('Enter valid Min/Max Completion Minutes.', true);
    callSave('SaveContextDealFlow', { projectId: +contextProject.value, configurationProcess: contextType.value, dealNumber: '', processId: +contextProcess.value, processName: contextProcessName.value, stageNo: +contextStageNo.value, isMandatory: contextRequirement.value === 'mandatory', feedbackRequired: contextFeedback.checked, isFinalProcess: contextFinalProcess.checked, productivityType: contextProductivityType.value, expectedCompletionMinutes: 0, minCompletionMinutes: min, maxCompletionMinutes: max, isOutOfScope: contextRequirement.value === 'out-of-scope' }, clearContextForm, loadContextFlow);
}
function removeContextFlow(id) { if (!confirm('Delete this process-specific override?')) return; remove('RemoveContextDealFlow', { projectId: +contextProject.value, configurationProcess: contextType.value, dealNumber: '', processId: id }, loadContextFlow, true); }

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

function render() { rows.innerHTML = flow.length ? flow.map(function (x, i) { return flowRow(x, i, flow, false); }).join('') : '<tr><td colspan="12" class="olt-empty">No tracking processes configured.</td></tr>'; renderProjectPickers(); }
function renderDeal() { dealRows.innerHTML = dealFlow.length ? dealFlow.map(function (x, i) { return flowRow(x, i, dealFlow, true); }).join('') : '<tr><td colspan="10" class="olt-empty">No project process flow is configured.</td></tr>'; }
function flowRow(x, i, source, isDeal) {
    var simultaneous = i > 0 && source[i - 1].StageNo === x.StageNo;
    var isTracking = !(x.IsTrackingSheetProcess === false || x.IsTrackingSheetProcess === 0 || x.IsTrackingSheetProcess === '0');
    var trackingCell = isDeal ? '<td><span class="flow-source ' + (x.IsDealOverride ? 'override' : 'inherited') + '">' + (x.IsDealOverride ? 'Deal override' : 'Project default') + '</span></td>' : '<td>' + (isTracking ? 'Yes' : 'No &ndash; separate processing form') + '</td>';
    var productivity = x.ProductivityType || 'Loan Based Productivity';
    var dependencyCell = isDeal ? '' : '<td>' + (x.EligibleAfterProcessNames ? OLT.esc(x.EligibleAfterProcessNames) : '<span class="olt-muted">Sequence flow</span>') + '</td>';
    var feedbackTargetCell = isDeal ? '' : '<td>' + (x.FeedbackAgainstProcessNames ? OLT.esc(x.FeedbackAgainstProcessNames) : '<span class="olt-muted">All prior completed processes</span>') + '</td>';
    var actionButton = '<button type="button" class="flow-action-button" aria-haspopup="menu" aria-expanded="false" aria-label="Actions for ' + OLT.esc(x.ProcessName) + '" onclick="toggleFlowActions(event,' + (+x.ProcessID) + ',' + (isDeal ? 'true' : 'false') + ')">&#9881;</button>';
    var minMinutes = x.MinCompletionMinutes == null ? '&mdash;' : OLT.esc(x.MinCompletionMinutes);
    var maxMinutes = x.MaxCompletionMinutes == null ? '&mdash;' : OLT.esc(x.MaxCompletionMinutes);
    var requirementLabel = x.IsOutOfScope === true || x.IsOutOfScope === 1 || x.IsOutOfScope === '1' ? '<span class="flow-final">Out of Scope</span>' : (x.IsMandatory ? 'Mandatory' : 'Can be skipped');
    return '<tr><td>' + actionButton + '</td><td>' + OLT.esc(x.ProcessName) + '</td><td><span class="flow-stage">' + x.StageNo + '</span>' + (simultaneous ? '<span class="flow-same">simultaneous</span>' : '') + '</td><td>' + requirementLabel + '</td><td>' + (x.FeedbackRequiredOnComplete ? 'Yes' : 'No') + '</td><td>' + (x.IsFinalProcess ? '<span class="flow-final">Final</span>' : 'No') + '</td>' + trackingCell + '<td>' + OLT.esc(productivity) + '</td><td>' + minMinutes + '</td><td>' + maxMinutes + '</td>' + dependencyCell + feedbackTargetCell + '</tr>';
}

function toggleFlowActions(event, processId, isDeal) {
    event.preventDefault(); event.stopPropagation();
    var button = event.currentTarget;
    if (activeFlowAction && activeFlowAction.button === button && !flowActionMenu.hidden) { closeFlowActionMenu(); return; }
    closeFlowActionMenu();
    activeFlowAction = { processId: +processId, isDeal: !!isDeal, button: button };
    var selectedRow = find(isDeal ? dealFlow : flow, +processId);
    flowDeleteAction.disabled = !!isDeal && selectedRow && !selectedRow.IsDealOverride;
    flowDeleteAction.title = flowDeleteAction.disabled ? 'Only deal-specific overrides can be deleted here.' : '';
    button.setAttribute('aria-expanded', 'true'); flowActionMenu.hidden = false;
    var rect = button.getBoundingClientRect(), menuWidth = flowActionMenu.offsetWidth, menuHeight = flowActionMenu.offsetHeight;
    var left = Math.min(rect.left, window.innerWidth - menuWidth - 8), below = rect.bottom + 5;
    var top = below + menuHeight <= window.innerHeight - 8 ? below : Math.max(8, rect.top - menuHeight - 5);
    flowActionMenu.style.left = Math.max(8, left) + 'px'; flowActionMenu.style.top = top + 'px';
}
function closeFlowActionMenu() {
    if (activeFlowAction && activeFlowAction.button) activeFlowAction.button.setAttribute('aria-expanded', 'false');
    flowActionMenu.hidden = true; activeFlowAction = null;
}
function runFlowAction(action) {
    if (!activeFlowAction) return;
    var selected = activeFlowAction, row = find(selected.isDeal ? dealFlow : flow, selected.processId);
    closeFlowActionMenu(); if (!row) return;
    if (action === 'edit') { if (selected.isDeal) editDealFlow(selected.processId); else editFlow(selected.processId); return; }
    var message = 'Are you sure you want to delete the configuration for "' + row.ProcessName + '"?';
    if (!confirm(message)) return;
    if (selected.isDeal) removeDealFlow(selected.processId, true); else removeFlow(selected.processId, true);
}

function editFlow(id) { var x = find(flow, id); if (!x) return; process.value = id; stageNo.value = x.StageNo; requirement.value = x.IsMandatory ? 'mandatory' : 'skippable'; feedback.checked = x.FeedbackRequiredOnComplete; finalProcess.checked = x.IsFinalProcess; trackingSheetProcess.checked = !(x.IsTrackingSheetProcess === false || x.IsTrackingSheetProcess === 0 || x.IsTrackingSheetProcess === '0'); setProductivity(false, x); setTimeLimits(false, x); setEligibleAfter(x.EligibleAfterProcessIDs); setFeedbackTargets(x.FeedbackAgainstProcessIDs); window.scrollTo(0, 0); }
function editDealFlow(id) { var x = find(dealFlow, id); if (!x) return; dealProcess.value = id; dealStageNo.value = x.StageNo; dealRequirement.value = x.IsOutOfScope === true || x.IsOutOfScope === 1 || x.IsOutOfScope === '1' ? 'out-of-scope' : (x.IsMandatory ? 'mandatory' : 'skippable'); dealFeedback.checked = x.FeedbackRequiredOnComplete; dealFinalProcess.checked = x.IsFinalProcess; setProductivity(true, x); setTimeLimits(true, x); toggleDealScopeControls(); window.scrollTo(0, 0); }
function find(source, id) { return source.filter(function (x) { return +x.ProcessID === id; })[0]; }

function clearForm() { process.value = ''; stageNo.value = 1; requirement.value = 'mandatory'; feedback.checked = false; finalProcess.checked = false; trackingSheetProcess.checked = true; setProductivity(false, {}); setTimeLimits(false, {}); clearEligibleAfter(); clearFeedbackTargets(); }
function clearDealForm() { dealProcess.value = ''; dealStageNo.value = 1; dealRequirement.value = 'mandatory'; dealFeedback.checked = false; dealFinalProcess.checked = false; setProductivity(true, {}); setTimeLimits(true, {}); toggleDealScopeControls(); }
function toggleDealScopeControls() { var out = dealRequirement.value === 'out-of-scope'; [dealFeedback, dealFinalProcess, dealProductivityType, dealMinCompletionMinutes, dealMaxCompletionMinutes].forEach(function (control) { control.disabled = out; }); if (out) { dealFeedback.checked = false; dealFinalProcess.checked = false; } }

function setProductivity(isDeal, row) { document.getElementById(isDeal ? 'dealProductivityType' : 'productivityType').value = row.ProductivityType || 'Loan Based Productivity'; }
function setTimeLimits(isDeal, row) { document.getElementById(isDeal ? 'dealMinCompletionMinutes' : 'minCompletionMinutes').value = row.MinCompletionMinutes == null ? '' : row.MinCompletionMinutes; document.getElementById(isDeal ? 'dealMaxCompletionMinutes' : 'maxCompletionMinutes').value = row.MaxCompletionMinutes == null ? '' : row.MaxCompletionMinutes; }
function optionalMinutes(element) { if (String(element.value).trim() === '') return null; var value = Number(element.value); return Number.isInteger(value) && value >= 0 ? value : NaN; }
function timeLimits(isDeal) { var min = optionalMinutes(document.getElementById(isDeal ? 'dealMinCompletionMinutes' : 'minCompletionMinutes')), max = optionalMinutes(document.getElementById(isDeal ? 'dealMaxCompletionMinutes' : 'maxCompletionMinutes')); if (isNaN(min) || isNaN(max)) { OLT.alert('Min and Max Completion Minutes must be whole numbers greater than or equal to 0.', true); return null; } if (min != null && max != null && max < min) { OLT.alert('Maximum completion time cannot be less than the minimum completion time.', true); return null; } return { min: min, max: max }; }

function selectedEligibleAfterIds() { return eligibleAfterSelection.slice(); }
function setEligibleAfter(csv) {
    eligibleAfterSearch.value = '';
    var selected = String(csv || '').split(',').filter(Boolean).map(Number);
    renderEligibleAfterOptions(selected);
}
function clearEligibleAfter() { eligibleAfterSearch.value = ''; renderEligibleAfterOptions([]); }
function renderEligibleAfterOptions(forcedSelection) {
    if (forcedSelection) eligibleAfterSelection = forcedSelection.slice();
    var selected = eligibleAfterSelection, currentId = +process.value || 0, currentStage = +stageNo.value || 0;
    eligibleAfterSelection = selected = selected.filter(function (id) { var row = find(flow, id); return row && +row.ProcessID !== currentId && (!currentStage || +row.StageNo < currentStage); });
    var search = String(eligibleAfterSearch.value || '').toLowerCase(), candidates = flow.filter(function (x) {
        return +x.ProcessID !== currentId && (!currentStage || +x.StageNo < currentStage) && (!search || String(x.ProcessName).toLowerCase().indexOf(search) >= 0);
    });
    eligibleAfterOptions.innerHTML = candidates.length ? candidates.map(function (x) {
        var checked = selected.indexOf(+x.ProcessID) >= 0 ? ' checked' : '';
        return '<label class="flow-dependency-option"><input type="checkbox" value="' + (+x.ProcessID) + '"' + checked + ' onchange="toggleEligibleAfter(this)"/><span>' + OLT.esc(x.ProcessName) + ' <span class="olt-muted">(Sequence ' + (+x.StageNo) + ')</span></span></label>';
    }).join('') : '<div class="flow-dependency-empty">No earlier configured processes found.</div>';
    updateEligibleAfterSummary();
}
function toggleEligibleAfter(box) {
    var id = +box.value, index = eligibleAfterSelection.indexOf(id);
    if (box.checked && index < 0) eligibleAfterSelection.push(id);
    if (!box.checked && index >= 0) eligibleAfterSelection.splice(index, 1);
    updateEligibleAfterSummary();
}
function updateEligibleAfterSummary() {
    var names = eligibleAfterSelection.map(function (id) { var row = find(flow, id); return row ? row.ProcessName : ''; }).filter(Boolean);
    eligibleAfterSummary.textContent = names.length ? names.join(', ') : 'No selection – use sequence flow';
}

function renderProjectPickers() { renderEligibleAfterOptions(); renderFeedbackTargetOptions(); }
function selectedFeedbackTargetIds() { return feedbackTargetSelection.slice(); }
function setFeedbackTargets(csv) { feedbackAgainstSearch.value = ''; renderFeedbackTargetOptions(String(csv || '').split(',').filter(Boolean).map(Number)); }
function clearFeedbackTargets() { feedbackAgainstSearch.value = ''; renderFeedbackTargetOptions([]); }
function renderFeedbackTargetOptions(forcedSelection) {
    if (forcedSelection) feedbackTargetSelection = forcedSelection.slice();
    var currentId = +process.value || 0, currentStage = +stageNo.value || 0;
    feedbackTargetSelection = feedbackTargetSelection.filter(function (id) { var row = find(flow, id); return row && +row.ProcessID !== currentId && (!currentStage || +row.StageNo < currentStage); });
    var search = String(feedbackAgainstSearch.value || '').toLowerCase(), candidates = flow.filter(function (x) {
        return +x.ProcessID !== currentId && (!currentStage || +x.StageNo < currentStage) && (!search || String(x.ProcessName).toLowerCase().indexOf(search) >= 0);
    });
    feedbackAgainstOptions.innerHTML = candidates.length ? candidates.map(function (x) {
        var checked = feedbackTargetSelection.indexOf(+x.ProcessID) >= 0 ? ' checked' : '';
        return '<label class="flow-dependency-option"><input type="checkbox" value="' + (+x.ProcessID) + '"' + checked + ' onchange="toggleFeedbackTarget(this)"/><span>' + OLT.esc(x.ProcessName) + ' <span class="olt-muted">(Sequence ' + (+x.StageNo) + ')</span></span></label>';
    }).join('') : '<div class="flow-dependency-empty">No earlier configured processes found.</div>';
    updateFeedbackTargetSummary();
}
function toggleFeedbackTarget(box) {
    var id = +box.value, index = feedbackTargetSelection.indexOf(id);
    if (box.checked && index < 0) feedbackTargetSelection.push(id);
    if (!box.checked && index >= 0) feedbackTargetSelection.splice(index, 1);
    updateFeedbackTargetSummary();
}
function updateFeedbackTargetSummary() {
    var names = feedbackTargetSelection.map(function (id) { var row = find(flow, id); return row ? row.ProcessName : ''; }).filter(Boolean);
    feedbackAgainstSummary.textContent = names.length ? names.join(', ') : 'No selection – allow all prior completed processes';
}

function saveFlow() {
    if (!project.value || !process.value || +stageNo.value < 1) return OLT.alert('Project, process, and valid sequence are required.', true);
    var limits = timeLimits(false); if (!limits) return;
    callSave('SaveFlow', { projectId: +project.value, processId: +process.value, processName: process.options[process.selectedIndex].text, stageNo: +stageNo.value, isMandatory: requirement.value === 'mandatory', feedbackRequired: feedback.checked, isFinalProcess: finalProcess.checked, isTrackingSheetProcess: trackingSheetProcess.checked, productivityType: productivityType.value, expectedCompletionMinutes: 0, minCompletionMinutes: limits.min, maxCompletionMinutes: limits.max, eligibleAfterProcessIds: selectedEligibleAfterIds(), feedbackAgainstProcessIds: selectedFeedbackTargetIds() }, clearForm, loadProject);
}
function saveDealFlow() {
    if (!dealProject.value || !dealNumber.value || !dealProcess.value || +dealStageNo.value < 1) return OLT.alert('Project, deal, process, and valid sequence are required.', true);
    var limits = timeLimits(true); if (!limits) return;
    callSave('SaveDealFlow', { projectId: +dealProject.value, dealNumber: dealNumber.value, processId: +dealProcess.value, processName: dealProcess.options[dealProcess.selectedIndex].text, stageNo: +dealStageNo.value, isMandatory: dealRequirement.value === 'mandatory', feedbackRequired: dealFeedback.checked, isFinalProcess: dealFinalProcess.checked, productivityType: dealProductivityType.value, expectedCompletionMinutes: 0, minCompletionMinutes: limits.min, maxCompletionMinutes: limits.max, isOutOfScope: dealRequirement.value === 'out-of-scope' }, clearDealForm, loadDeal);
}
function callSave(method, model, clear, reload) { OLT.call(page, method, model).then(function () { OLT.alert('Process flow saved.'); clear(); reload(); }).catch(showError); }

function removeFlow(id, confirmed) { remove('RemoveFlow', { projectId: +project.value, processId: id }, loadProject, confirmed); }
function removeDealFlow(id, confirmed) { remove('RemoveDealFlow', { projectId: +dealProject.value, dealNumber: dealNumber.value, processId: id }, loadDeal, confirmed); }
function remove(method, model, reload, confirmed) { if (!confirmed && !confirm('Are you sure you want to delete this process configuration?')) return; OLT.call(page, method, model).then(function () { OLT.alert('Process configuration deleted.'); reload(); }).catch(showError); }
function showError(e) { OLT.alert(e && e.message ? e.message : 'The requested action could not be completed.', true); }
