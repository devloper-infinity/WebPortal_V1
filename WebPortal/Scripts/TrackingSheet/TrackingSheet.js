
var page = 'TrackingSheet.aspx', flow = [], queue = [], otherLoanRows = [], otherLoanTable = null, otherSearchLoans = [], selectedOtherLoans = {}, isOtherProcess = false, isHourlyOtherProcess = false;
var from_Date; var to_Date;

document.addEventListener('DOMContentLoaded', function () {
    bindTabs();
    setToday();
    OLT.call(page, 'GetProjects').then(function (r) {
        OLT.options(project, r, ['ProjectID', 'projectID'], ['ProjectName', 'ProjectNo', 'Name'], 'Select project');
    });
    OLT.call(page, 'GetDailyProcesses').then(function (r) {
        OLT.options(dailyProcess, r, ['ProcessID'], ['ProcessName'], 'All processes');
    });
    OLT.call(page, 'GetCurrentPseudoName').then(function (r) { processingUserName.value = r || ''; });

    project.onchange = loadProject; deal.onchange = selectDeal; process.onchange = selectProcess;
    otherLoanSearch.oninput = applyOtherLoanSearch;
    clearOtherLoanSearch.onclick = clearOtherSearch;
    selectAllOtherLoans.onchange = toggleAllOtherLoans;
    populateHourlyTimeOptions(); hourlyEntrySubmit.onclick = submitHourlyEntry;
    bindOtherLoanActions();
    fbPreviousProcessSearch.oninput = renderPreviousProcessOptions;
    if (window.jQuery && $.fn.DataTable) $.fn.dataTable.ext.search.push(function (settings, data, dataIndex, rowData) {
        if (!settings.nTable || settings.nTable.id !== 'otherLoanTable' || !otherSearchLoans.length) return true;
        var loanNo = String((rowData && rowData.LoanNo) || data[1] || '').trim().toLowerCase();
        return otherSearchLoans.indexOf(loanNo) >= 0;
    });
    loadQueue(); loadDaily();
});

function bindTabs() { [].slice.call(document.querySelectorAll('.ots-tab')).forEach(function (b) { b.onclick = function () { document.querySelector('.ots-tab.active').classList.remove('active'); document.querySelector('.ots-panel.active').classList.remove('active'); b.classList.add('active'); document.getElementById(b.dataset.panel).classList.add('active'); if (b.dataset.panel === 'status') loadQueue(); if (b.dataset.panel === 'daily') loadDaily(); }; }); }

function loadProject() { resetProcessDisplay(); process.disabled = true; process.innerHTML = '<option value="">Select deal first</option>'; loan.innerHTML = '<option value="">Select deal and process</option>'; deal.innerHTML = '<option value="">Select deal</option>'; if (!project.value) return; OLT.call(page, 'GetDeals', { projectId: +project.value }).then(function (r) { OLT.options(deal, r, ['DealNo', 'DealNumber', 'Deal'], ['DealNo', 'DealNumber', 'Deal'], 'Select deal'); }).catch(showError); }

function selectDeal() { resetProcessDisplay(); process.disabled = true; process.innerHTML = '<option value="">Loading configured flow...</option>'; loan.innerHTML = '<option value="">Select process</option>'; if (!deal.value) return; OLT.call(page, 'GetFlow', { projectId: +project.value, dealNumber: deal.value }).then(function (r) { flow = r || []; OLT.options(process, flow, ['ProcessID'], ['ProcessName'], 'Select process'); process.disabled = false; }).catch(showError); }

function selectProcess() {
    resetProcessDisplay();
    if (!project.value || !deal.value || !process.value) return;
    OLT.call(page, 'GetProcessEntryMode', { projectId: +project.value, dealNumber: deal.value, processId: +process.value })
        .then(function (mode) {
            isOtherProcess = mode && mode.IsTrackingSheetProcess === false;
            isHourlyOtherProcess = isOtherProcess && mode.ProductivityType === 'Hourly Productivity';
            otherSelectionCount.style.display = isHourlyOtherProcess ? 'none' : '';
            hourlyEntrySection.classList.toggle('active', isHourlyOtherProcess);
            standardOtherProcessingSection.style.display = isHourlyOtherProcess ? 'none' : '';
            document.querySelector('.ots-processing-head').style.display = isHourlyOtherProcess ? 'none' : '';
            loanField.style.display = isOtherProcess ? 'none' : '';
            legacyAllocationActions.style.display = isOtherProcess ? 'none' : '';
            trackingQueueSection.style.display = isOtherProcess ? 'none' : '';
            otherProcessingSection.classList.toggle('active', isOtherProcess);
            if (isHourlyOtherProcess) { hourlyEntryHours.focus(); return; }
            if (isOtherProcess) loadNonTrackingLoans(); else tryLoadLoan();
        }).catch(showError);
}

function resetProcessDisplay() {
    isOtherProcess = false; isHourlyOtherProcess = false; otherProcessingSection.classList.remove('active'); otherSelectionCount.style.display = ''; hourlyEntrySection.classList.remove('active'); standardOtherProcessingSection.style.display = ''; document.querySelector('.ots-processing-head').style.display = '';
    loanField.style.display = ''; legacyAllocationActions.style.display = ''; trackingQueueSection.style.display = '';
    clearOtherSearch();
    if (otherLoanTable) { otherLoanTable.destroy(); otherLoanTable = null; }
    otherLoanRows = []; selectedOtherLoans = {}; updateOtherSelectionCount();
}

function tryLoadLoan() { if (!project.value || !process.value || !deal.value) return; var selected = process.options[process.selectedIndex]; loan.innerHTML = '<option value="">Checking eligibility...</option>'; OLT.call(page, 'GetAvailableLoan', { projectId: +project.value, dealNumber: deal.value, processId: +process.value, processName: selected.text }).then(function (r) { if (typeof r === 'string') { try { r = JSON.parse(r); } catch (e) { r = { LoanNumber: r }; } } var number = r && r.LoanNumber ? String(r.LoanNumber) : ''; loan.innerHTML = ''; var option = document.createElement('option'); option.value = number; option.textContent = number || 'No eligible loan available'; loan.appendChild(option); }).catch(showError); }

function loadNonTrackingLoans() {
    if (!isOtherProcess || !project.value || !deal.value || !process.value) return;
    OLT.call(page, 'GetNonTrackingPendingLoans', { projectId: +project.value, dealNumber: deal.value, processId: +process.value }).then(function (rows) {
        otherLoanRows = rows || []; selectedOtherLoans = {}; updateOtherSelectionCount();
        if (otherLoanRows.length && otherLoanRows[0].UserName) processingUserName.value = otherLoanRows[0].UserName;
        if (otherLoanTable) otherLoanTable.destroy();
        otherLoanHead.innerHTML = isHourlyOtherProcess
            ? '<tr><th>LoanNo</th><th>DealNo</th><th>UserName</th><th>Hours</th><th>Minutes</th><th>Action</th></tr>'
            : '<tr><th><input id="selectAllOtherLoans" class="ots-row-check" type="checkbox" aria-label="Select all visible loans" /></th><th>LoanNo</th><th>DealNo</th><th>UserName</th><th>StartDate</th><th>EndDate</th><th>Status</th><th>Reason</th><th>Action</th></tr>';
        var selectAll = document.getElementById('selectAllOtherLoans'); if (selectAll) selectAll.onchange = toggleAllOtherLoans;
        otherLoanTable = $('#otherLoanTable').DataTable({
            data: otherLoanRows, pageLength: 25, order: [[1, 'asc']], autoWidth: false, dom: 'lrtip',
            columns: [
                { data: null, orderable: false, searchable: false, render: function (_, type, row) { if (type !== 'display') return ''; var key = otherLoanKey(row); return '<input type="checkbox" class="ots-row-check other-loan-check" data-key="' + OLT.esc(key) + '"' + (selectedOtherLoans[key] ? ' checked' : '') + ' />'; } },
                { data: 'LoanNo' }, { data: 'DealNo' }, { data: 'UserName' },
                { data: 'StartDate', render: function (v, type) { return type === 'display' ? fmt(v) : (v || ''); } },
                { data: 'EndDate', render: function (v, type) { return type === 'display' ? fmt(v) : (v || ''); } },
                { data: 'Status', render: function (v, type) { if (type !== 'display') return v || ''; var css = String(v || '').toLowerCase().replace(/\s+/g, '-'), label = v === 'Hold' ? 'On Hold' : v; return '<span class="ots-status ' + css + '">' + OLT.esc(label) + '</span>'; } },
                { data: 'Reason', defaultContent: '' },
                { data: null, orderable: false, searchable: false, render: function (_, type, row) { if (type !== 'display') return ''; var blockedText = 'Complete or place the current In Process loan on hold before starting another loan.'; if (row.Status === 'Hold') return '<div class="ots-action-group"><button type="button" class="olt-btn other-resume"' + (row.StartBlocked ? ' disabled title="' + blockedText + '"' : '') + '>Resume</button></div>'; if (row.Status === 'In Process') return '<div class="ots-action-group"><button type="button" class="olt-btn other-end">End</button></div>'; return '<div class="ots-action-group"><button type="button" class="olt-btn secondary other-start"' + (row.StartBlocked ? ' disabled title="' + blockedText + '"' : '') + '>Start</button></div>'; } }
            ],
            language: { emptyTable: 'No pending loans are available for the selected process.' },
            drawCallback: function () { var all = document.getElementById('selectAllOtherLoans'); if (all) all.checked = false; }
        });
        applyOtherLoanSearch();
    }).catch(showError);
}

function bindOtherLoanActions() {
    $('#otherLoanTable').on('click', '.other-start', function () { var tableRow = otherLoanTable.row($(this).closest('tr')); startOtherLoan(tableRow.data(), this, tableRow); });
    $('#otherLoanTable').on('click', '.other-end', function () { var row = otherLoanTable.row($(this).closest('tr')).data(); openComplete(+row.AssignmentID, row); });
    $('#otherLoanTable').on('click', '.other-resume', function () { resumeLoan(+(otherLoanTable.row($(this).closest('tr')).data().AssignmentID)); });
    $('#otherLoanTable').on('change', '.other-loan-check', function () { selectedOtherLoans[this.dataset.key] = this.checked; updateOtherSelectionCount(); });
}

function startOtherLoan(row, button, tableRow) {
    if (!row || !button) return;
    button.disabled = true; button.textContent = 'Starting...';
    OLT.call(page, 'StartNonTrackingLoan', { projectId: +project.value, processId: +process.value, loanNumber: row.LoanNo, dealNumber: deal.value, assignmentId: +(row.AssignmentID || 0) })
        .then(function (r) {
            if (!actionSucceeded(r)) { loadNonTrackingLoans(); return; }
            row.AssignmentID = r.AssignmentID; row.Status = 'In Process'; row.StartDate = '/Date(' + Date.now() + ')/'; row.Reason = 'Work started';
            tableRow.data(row);
            otherLoanTable.rows().every(function () { var item = this.data(); if (item !== row) { item.StartBlocked = true; this.data(item); } });
            otherLoanTable.draw(false);
            OLT.alert(r.Message || 'Loan started successfully.');
        })
        .catch(function (error) { showError(error); loadNonTrackingLoans(); });
}
function otherLoanKey(row) { return String(row.AssignmentID || '') + '|' + String(row.LoanNo || '').trim(); }
function applyOtherLoanSearch() { otherSearchLoans = String(otherLoanSearch.value || '').split(',').map(function (x) { return x.trim().toLowerCase(); }).filter(function (x, i, a) { return x && a.indexOf(x) === i; }); if (otherLoanTable) otherLoanTable.draw(); }
function clearOtherSearch() { if (!window.otherLoanSearch) return; otherLoanSearch.value = ''; otherSearchLoans = []; if (otherLoanTable) otherLoanTable.draw(); }
function toggleAllOtherLoans() { if (!otherLoanTable) return; var checked = selectAllOtherLoans.checked; otherLoanTable.rows({ search: 'applied' }).every(function () { var row = this.data(); selectedOtherLoans[otherLoanKey(row)] = checked; }); $('#otherLoanTable tbody .other-loan-check').prop('checked', checked); updateOtherSelectionCount(); }
function updateOtherSelectionCount() { var count = Object.keys(selectedOtherLoans).filter(function (k) { return selectedOtherLoans[k]; }).length; if (window.otherSelectionCount) otherSelectionCount.textContent = count + ' loan(s) selected'; }
function refreshQueues() { loadQueue(); loadDaily(); if (isOtherProcess) loadNonTrackingLoans(); }

function allocateLoan() { if (!loan.value) { OLT.alert('No eligible loan is available for the selected process and deal.', true); return; } OLT.call(page, 'Allocate', { projectId: +project.value, processId: +process.value, loanNumber: loan.value, dealNumber: deal.value }).then(function (r) { if (!actionSucceeded(r)) return; OLT.alert(r.Message || 'Loan allocated successfully.'); tryLoadLoan(); loadQueue(); }).catch(showError); }

function loadQueue() {
    OLT.call(page, 'GetQueue').then(function (r) {
        queue = r;
        var hasInProcess = r.some(function (x) { return x.AssignmentStatus === 'In Process'; });
        queueRows.innerHTML = r.length ? r.map(function (x) {
            var blocked = hasInProcess && x.AssignmentStatus !== 'In Process';
            var blockedText = 'Place the current In Process loan on Hold or complete it first.';
            var action = '';
            if (x.AssignmentStatus === 'Hold') {
                action = blocked
                    ? '<button type="button" class="olt-btn" disabled title="' + blockedText + '">Resume</button>'
                    : '<button type="button" class="olt-btn" onclick="resumeLoan(' + x.AssignmentID + ')">Resume</button>';
            } else if (x.AssignmentStatus === 'Pending') {
                action = (blocked
                    ? '<button type="button" class="olt-btn secondary" disabled title="' + blockedText + '">Start Work</button> '
                    : '<button type="button" class="olt-btn secondary" onclick="startLoan(' + x.AssignmentID + ')">Start Work</button> ')
                    + '<button type="button" class="olt-btn" disabled title="Start the loan before updating its status.">Update Status</button>';
            } else if (x.AssignmentStatus === 'In Process') {
                action = '<button type="button" class="olt-btn" onclick="openComplete(' + x.AssignmentID + ')">Update Status</button>';
            }
            return '<tr><td>' + OLT.esc(x.ProjectName || x.ProjectID) + '</td><td>' + OLT.esc(x.DealNumber) + '</td><td>' + OLT.esc(x.LoanNumber) + '</td><td>' + OLT.esc(x.ProcessName) + '</td><td><span class="ots-status">' + x.AssignmentStatus + '</span></td><td>' + fmt(x.AssignedDate) + '</td><td>' + duration(x.HoldTATSeconds) + '</td><td>' + duration(x.TotalTATSeconds) + '</td><td>' + action + '</td></tr>';
        }).join('') : '<tr><td colspan="9" class="olt-empty">No active or held loans.</td></tr>';
    }).catch(showError);
}

function startLoan(id) { OLT.call(page, 'StartLoan', { assignmentId: id }).then(function (r) { if (!actionSucceeded(r)) return; OLT.alert(r.Message || 'Loan marked In Process.'); loadQueue(); }).catch(showError); }

function resumeLoan(id) { OLT.call(page, 'ResumeLoan', { assignmentId: id }).then(function (r) { if (!actionSucceeded(r)) return; OLT.alert(r.Message || 'Loan resumed successfully.'); refreshQueues(); }).catch(showError); }

var activeAssignment = null, feedbackRequired = false, savedFeedbacks = 0, feedbackOwners = [], feedbackTargetSelection = [], feedbackDetailsTable = null;

function openComplete(id, selectedAssignment) {
    var assignment = selectedAssignment || queue.filter(function (q) { return q.AssignmentID === id; })[0] || null;
    if (!assignment) { OLT.alert('The selected assignment is no longer available.', true); return; }
    OLT.call(page, 'GetCompletionFeedbackRequirement', { assignmentId: id })
        .then(function (required) { showCompleteModal(id, assignment, !!required, !!selectedAssignment); })
        .catch(showError);
}

function showCompleteModal(id, assignment, requiresFeedback, isSeparateProcessing) {
    activeAssignment = assignment; feedbackRequired = requiresFeedback;
    activeAssignment.FeedbackRequiredOnComplete = requiresFeedback;
    skipStatusOption.hidden = isSeparateProcessing || !(activeAssignment && activeAssignment.CanSkip);
    savedFeedbacks = 0; assignmentId.value = id; completeRemark.value = ''; updateStatus.value = ''; holdReason.value = ''; finalStatus.value = 'Completed';
    renderSavedFeedbackDetails([]); continueAfterFeedback.disabled = true;
    [statusStep, feedbackStep, completeStep].forEach(function (step) { step.classList.remove('active'); });
    statusStep.classList.add('active'); changeCompletionStatus(); completeModal.classList.add('open');
}

function closeComplete() { completeModal.classList.remove('open'); activeAssignment = null; }

function changeCompletionStatus() {
    var status = updateStatus.value;
    holdReasonField.style.display = status === 'Hold' ? 'block' : 'none';
    statusActions.style.display = status === 'Hold' ? 'block' : 'none';
    feedbackStep.classList.remove('active'); completeStep.classList.remove('active'); statusStep.classList.add('active');
    if (status === 'Hold') { statusContinueButton.textContent = 'Place on Hold'; return; }
    if (status !== 'Completed' && status !== 'Skipped') return;
    if (status === 'Skipped' && !(activeAssignment && activeAssignment.CanSkip)) { updateStatus.value = ''; OLT.alert('This process is mandatory and cannot be skipped.', true); return changeCompletionStatus(); }
    finalStatus.value = status;
    if (status === 'Completed' && feedbackRequired) { openMandatoryFeedbackPage(); return; }
    completeStep.classList.add('active');
}

function selectCompletionStatus() { if (updateStatus.value === 'Hold') { if (!holdReason.value) { OLT.alert('Please select a hold reason.', true); return; } statusContinueButton.disabled = true; OLT.call(page, 'HoldLoan', { assignmentId: +assignmentId.value, holdReason: holdReason.value }).then(function (r) { if (!actionSucceeded(r)) return; closeComplete(); OLT.alert(r.Message || 'Loan placed on hold successfully.'); refreshQueues(); }).catch(showError).then(function () { statusContinueButton.disabled = false; }); return; } if (updateStatus.value !== 'Completed' && updateStatus.value !== 'Skipped') { OLT.alert('Please select a status.', true); return; } if (updateStatus.value === 'Skipped' && !(activeAssignment && activeAssignment.CanSkip)) { OLT.alert('This process is mandatory and cannot be skipped.', true); return; } finalStatus.value = updateStatus.value; statusStep.classList.remove('active'); if (updateStatus.value === 'Skipped' || !feedbackRequired) { completeStep.classList.add('active'); return; } openMandatoryFeedbackPage(); }

function openMandatoryFeedbackPage() { var id = +assignmentId.value; if (!id) { OLT.alert('The selected assignment is no longer available.', true); return; } window.location.href = 'TrackingSheetFeedback.aspx?assignmentId=' + encodeURIComponent(id); }

function parseJsonResult(r) { if (typeof r === 'string') { try { return JSON.parse(r); } catch (e) { return {}; } } return r || {}; }

function fillSelect(el, rows, valueName, textName, placeholder) { el.innerHTML = '<option value="">' + placeholder + '</option>'; (rows || []).forEach(function (x) { var o = document.createElement('option'); o.value = x[valueName]; o.textContent = x[textName]; el.appendChild(o); }); }

function loadFeedbackForm() { return OLT.call(page, 'GetFeedbackDefaults', { assignmentId: +assignmentId.value }).then(function (r) { r = parseJsonResult(r); var context = (r.table0 || [])[0] || {}, seen = {}; feedbackOwners = (r.table2 || []).filter(function (x) { var key = String(x.ProcessID); if (seen[key]) return false; seen[key] = true; return true; }); clearPreviousProcessSelection(); fbLoanNumber.value = context.LoanNumber || ''; fbClient.value = context.Client || ''; fbFeedbackBy.value = context.FeedbackBy || ''; fbQCDate.value = context.QCDate || ''; fbReceivedDate.value = context.QCDate || ''; savedFeedbacks = +(context.FeedbackCount || 0); renderSavedFeedbackDetails(r.table3 || []); updateFeedbackState(); return OLT.call(page, 'GetFeedbackCategories').then(function (c) { fillSelect(fbCategory, c, 'Value', 'Text', 'Select'); }); }).catch(showError); }

function clearPreviousProcessSelection() { feedbackTargetSelection = []; fbPreviousProcessSearch.value = ''; fbDateReviewed.value = ''; renderPreviousProcessOptions(); }
function renderPreviousProcessOptions() {
    var search = String(fbPreviousProcessSearch.value || '').toLowerCase();
    var candidates = feedbackOwners.filter(function (x) { return !search || (String(x.ProcessName) + ' ' + String(x.UserName)).toLowerCase().indexOf(search) >= 0; });
    fbPreviousProcessOptions.innerHTML = candidates.length ? candidates.map(function (x) {
        var id = +x.AssignmentID, checked = feedbackTargetSelection.indexOf(id) >= 0 ? ' checked' : '';
        return '<label class="olt-feedback-process-option"><input type="checkbox" value="' + id + '"' + checked + ' onchange="togglePreviousProcess(this)"/><span><strong>' + OLT.esc(x.ProcessName) + '</strong><small>Completed by ' + OLT.esc(x.UserName) + ' &middot; ' + OLT.esc(formatFeedbackDate(x.CompletedDate)) + '</small></span></label>';
    }).join('') : '<div class="olt-feedback-process-empty">No configured completed processes are available for this loan.</div>';
    updatePreviousProcessSummary();
}

function populateHourlyTimeOptions() {
    hourlyEntryHours.innerHTML = ''; hourlyEntryMinutes.innerHTML = '';
    for (var h = 0; h <= 24; h++) { var ho = document.createElement('option'); ho.value = h; ho.textContent = String(h).padStart(2, '0'); hourlyEntryHours.appendChild(ho); }
    for (var m = 0; m < 60; m++) { var mo = document.createElement('option'); mo.value = m; mo.textContent = String(m).padStart(2, '0'); hourlyEntryMinutes.appendChild(mo); }
}
function submitHourlyEntry() {
    var hours = +hourlyEntryHours.value, minutes = +hourlyEntryMinutes.value;
    if (hours * 60 + minutes < 1 || (hours === 24 && minutes > 0)) { OLT.alert('Enter a duration between 00:01 and 24:00.', true); return; }
    hourlyEntrySubmit.disabled = true; hourlyEntrySubmit.textContent = 'Submitting...';
    OLT.call(page, 'SubmitHourlyProductivity', { projectId: +project.value, processId: +process.value, dealNumber: deal.value, hours: hours, minutes: minutes })
        .then(function (r) { if (!actionSucceeded(r)) return; hourlyEntryHours.value = '0'; hourlyEntryMinutes.value = '0'; OLT.alert(r.Message || 'Hourly productivity submitted successfully.'); loadDaily(); })
        .catch(showError).then(function () { hourlyEntrySubmit.disabled = false; hourlyEntrySubmit.textContent = 'Submit'; });
}

function togglePreviousProcess(box) { var id = +box.value, index = feedbackTargetSelection.indexOf(id); if (box.checked && index < 0) feedbackTargetSelection.push(id); if (!box.checked && index >= 0) feedbackTargetSelection.splice(index, 1); updatePreviousProcessSummary(); }
function updatePreviousProcessSummary() {
    var selected = feedbackOwners.filter(function (x) { return feedbackTargetSelection.indexOf(+x.AssignmentID) >= 0; });
    fbPreviousProcessSummary.textContent = selected.length ? selected.map(function (x) { return x.ProcessName; }).join(', ') : 'Select completed process(es)';
    var dates = selected.map(function (x) { return formatFeedbackDate(x.CompletedDate); }).filter(Boolean);
    fbDateReviewed.value = !dates.length ? '' : dates.every(function (x) { return x === dates[0]; }) ? dates[0] : 'Multiple completion dates';
}

function formatFeedbackDate(value) { if (!value) return ''; var n = parseInt(String(value).replace(/\D/g, ''), 10), d = n ? new Date(n) : new Date(value); if (isNaN(d.getTime())) return ''; return String(d.getMonth() + 1).padStart(2, '0') + '/' + String(d.getDate()).padStart(2, '0') + '/' + d.getFullYear(); }

function loadFeedbackSubcategories() { fbSubcategory.innerHTML = '<option value="">Select</option>'; if (!fbCategory.value) return Promise.resolve(); return OLT.call(page, 'GetFeedbackSubcategories', { categoryId: +fbCategory.value }).then(function (r) { fillSelect(fbSubcategory, r, 'Value', 'Text', 'Select'); }).catch(showError); }

function selectByText(select, text) { var option = [].slice.call(select.options).filter(function (x) { return x.text.trim().toLowerCase() === text.toLowerCase(); })[0]; if (option) select.value = option.value; return !!option; }
function severityChanged() {
    var noError = fbSeverity.value === 'No Error', fields = [fbCategory, fbSubcategory, fbErrorField, fbScreen, fbErrorType, fbFeedbackType, fbError, fbRca];
    fields.forEach(function (field) { field.disabled = noError; field.classList.toggle('ots-disabled', noError); });
    if (!noError) { fields.forEach(function (field) { field.disabled = false; field.classList.remove('ots-disabled'); }); return; }
    if (!selectByText(fbCategory, 'Compliance')) { OLT.alert('Compliance category is not configured. Please contact the administrator.', true); fbSeverity.value = ''; return severityChanged(); }
    loadFeedbackSubcategories().then(function () {
        if (!selectByText(fbSubcategory, 'Compliance')) { OLT.alert('Compliance subcategory is not configured. Please contact the administrator.', true); fbSeverity.value = ''; return severityChanged(); }
        fbErrorField.value = 'NA'; fbScreen.value = 'NA'; fbErrorType.value = 'NA'; fbFeedbackType.value = 'NA'; fbError.value = 'No Error'; fbRca.value = 'No Error';
    });
}

function feedbackModel() { return { AssignmentID: +assignmentId.value, TargetAssignmentIDs: feedbackTargetSelection.slice(), FeedbackBy: fbFeedbackBy.value, ErrorType: fbErrorType.value.trim(), CategoryID: +fbCategory.value || 0, Category: fbCategory.options[fbCategory.selectedIndex] ? fbCategory.options[fbCategory.selectedIndex].text : '', SubcategoryID: +fbSubcategory.value || 0, Subcategory: fbSubcategory.options[fbSubcategory.selectedIndex] ? fbSubcategory.options[fbSubcategory.selectedIndex].text : '', Severity: fbSeverity.value, ErrorField: fbErrorField.value.trim(), Screen: fbScreen.value.trim(), FeedbackType: fbFeedbackType.value.trim(), Error: fbError.value.trim(), ShouldBe: fbRca.value.trim(), Remark: '' }; }

function validateFeedback(m) { if (!m.TargetAssignmentIDs.length) return 'Please select at least one Previous Process.'; if (!m.Severity) return 'Please select Severity.'; if (!m.CategoryID) return 'Please select Category.'; if (!m.SubcategoryID) return 'Please select Subcategory.'; if (!m.ErrorField) return 'Please enter Error Field.'; if (!m.Screen) return 'Please enter Screen.'; if (!m.ErrorType) return 'Please enter Error Type.'; if (!m.FeedbackType) return 'Please enter Feedback Type.'; if (!m.Error) return 'Please enter Finding.'; if (!m.ShouldBe) return 'Please enter RCA.'; return ''; }

function saveFeedback() { var m = feedbackModel(), error = validateFeedback(m); if (error) { OLT.alert(error, true); return; } OLT.call(page, 'SaveFeedback', { model: m }).then(function (r) { if (!actionSucceeded(r)) return; savedFeedbacks = +(r.FeedbackCount || savedFeedbacks + 1); clearFeedbackEntry(); updateFeedbackState(); OLT.alert(r.Message || 'Feedback added successfully.'); return loadFeedbackForm(); }).catch(showError); }

function clearFeedbackEntry() { fbSeverity.value = ''; severityChanged(); fbErrorType.value = ''; fbCategory.value = ''; fbSubcategory.innerHTML = '<option value="">Select</option>'; fbErrorField.value = ''; fbScreen.value = ''; fbFeedbackType.value = ''; fbError.value = ''; fbRca.value = ''; }

function updateFeedbackState() { continueAfterFeedback.disabled = savedFeedbacks < 1; }

function renderSavedFeedbackDetails(rows) {
    rows = rows || [];
    if (window.jQuery && $.fn.DataTable) {
        if (!feedbackDetailsTable) {
            feedbackDetailsTable = $('#savedFeedbackTable').DataTable({
                data: rows, pageLength: 5, lengthChange: false, autoWidth: false, scrollX: true, order: [[0, 'desc']],
                columnDefs: [{ targets: [1, 2, 3, 4, 5, 6, 7, 8, 9], render: $.fn.dataTable.render.text() }],
                columns: [
                    { data: 'FeedbackID' },
                    { data: 'MarkedTo', defaultContent: '' },
                    { data: 'ErrorBy', defaultContent: '' },
                    { data: 'Severity', defaultContent: '' },
                    { data: 'Category', defaultContent: '' },
                    { data: 'Subcategory', defaultContent: '' },
                    { data: 'ErrorField', defaultContent: '' },
                    { data: 'ErrorType', defaultContent: '' },
                    { data: 'Finding', defaultContent: '' },
                    { data: 'RCA', defaultContent: '' },
                    { data: 'FeedbackStatus', defaultContent: 'Pending', render: function (value, type) { if (type !== 'display') return value || 'Pending'; var status = value || 'Pending', css = String(status).toLowerCase().replace(/[^a-z0-9]+/g, '-'); return '<span class="olt-feedback-status ' + css + '">' + OLT.esc(status) + '</span>'; } },
                    { data: 'AddedDate', render: function (value, type) { return type === 'display' ? fmt(value) : (value || ''); } }
                ],
                language: { emptyTable: 'No feedback has been added for this loan yet.' }
            });
        } else {
            feedbackDetailsTable.clear().rows.add(rows).draw();
            window.setTimeout(function () { feedbackDetailsTable.columns.adjust(); }, 0);
        }
        return;
    }
    var body = savedFeedbackTable.tBodies[0];
    body.innerHTML = rows.length ? rows.map(function (row) {
        return '<tr><td>' + OLT.esc(row.FeedbackID) + '</td><td>' + OLT.esc(row.MarkedTo) + '</td><td>' + OLT.esc(row.ErrorBy) + '</td><td>' + OLT.esc(row.Severity) + '</td><td>' + OLT.esc(row.Category) + '</td><td>' + OLT.esc(row.Subcategory) + '</td><td>' + OLT.esc(row.ErrorField) + '</td><td>' + OLT.esc(row.ErrorType) + '</td><td>' + OLT.esc(row.Finding) + '</td><td>' + OLT.esc(row.RCA) + '</td><td>' + OLT.esc(row.FeedbackStatus || 'Pending') + '</td><td>' + OLT.esc(fmt(row.AddedDate)) + '</td></tr>';
    }).join('') : '<tr><td colspan="12" class="olt-empty">No feedback has been added for this loan yet.</td></tr>';
}

function continueToComplete() { if (feedbackRequired && savedFeedbacks < 1) { OLT.alert('At least one feedback entry is required.', true); return; } feedbackStep.classList.remove('active'); completeStep.classList.add('active'); }

function submitCompletion() { if (!completeRemark.value.trim()) { OLT.alert('Remark is required.', true); return; } var skipped = finalStatus.value === 'Skipped', method = skipped ? 'SkipLoan' : 'CompleteLoan', model = skipped ? { assignmentId: +assignmentId.value, remark: completeRemark.value } : { assignmentId: +assignmentId.value, remark: completeRemark.value, feedbacks: [] }; OLT.call(page, method, model).then(function (r) { if (!actionSucceeded(r)) return; closeComplete(); OLT.alert(r.Message || (skipped ? 'Process skipped.' : 'Loan completed.')); refreshQueues(); }).catch(showError); }

function setToday() {

    var d = new Date().toISOString().slice(0, 10); trackNew_fromDate.value = trackNew_toDate.value = d;
}

function applyMonth() {
    if (!monthFilter.value)
        return;
    var p = monthFilter.value.split('-'), start = new Date(+p[0], +p[1] - 1, 1), end = new Date(+p[0], +p[1], 0); trackNew_fromDate.value = localIso(start); trackNew_toDate.value = localIso(end);
} function localIso(d) { return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0'); }

function loadDaily() {
    OLT.call(page, 'GetDailyStatus',
        {
            processId: +dailyProcess.value || 0, fromDate: trackNew_fromDate.value, toDate: trackNew_toDate.value
        }).then(function (r) {
            if (window.jQuery && $.fn.DataTable && $.fn.DataTable.isDataTable('#dailyTable')) $('#dailyTable').DataTable().destroy(); dailyRows.innerHTML = r.length ? r.map(function (x) { var worked = x.ManualDurationMinutes == null ? '—' : workedDuration(x.ManualDurationMinutes); return '<tr><td>' + OLT.esc(x.ProjectName || x.ProjectID) + '</td><td>' + OLT.esc(x.DealNumber) + '</td><td>' + OLT.esc(x.LoanNumber) + '</td><td>' + OLT.esc(x.ProcessName) + '</td><td>' + x.AssignmentStatus + '</td><td>' + fmt(x.AssignedDate) + '</td><td>' + fmt(x.StartedDate) + '</td><td>' + fmt(x.CompletedDate) + '</td><td>' + duration(x.HoldTATSeconds) + '</td><td>' + duration(x.TotalTATSeconds) + '</td><td>' + worked + '</td><td>' + OLT.esc(x.LastRemark) + '</td></tr>'; }).join('') : '<tr><td colspan="12" class="olt-empty">No loans found.</td></tr>'; if (r.length && window.jQuery && $.fn.DataTable) $('#dailyTable').DataTable({ pageLength: 25, order: [] });
        }).catch(showError);
} function actionSucceeded(r) { if (typeof r === 'string') { try { r = JSON.parse(r); } catch (e) { r = { Success: false, Message: 'The requested action could not be completed.' }; } } if (!r || r.Success !== true) { OLT.alert(r && r.Message ? r.Message : 'The requested action could not be completed.', true); return false; } return true; } function duration(value) { var s = Math.max(0, +value || 0), d = Math.floor(s / 86400); s %= 86400; var h = Math.floor(s / 3600); s %= 3600; var m = Math.floor(s / 60); return (d ? d + 'd ' : '') + String(h).padStart(2, '0') + ':' + String(m).padStart(2, '0'); } function workedDuration(minutes) { minutes = Math.max(0, +minutes || 0); return Math.floor(minutes / 60) + ':' + String(Math.floor(minutes % 60)).padStart(2, '0'); } function fmt(v) { var n = parseInt(String(v || '').replace(/\D/g, ''), 10); return n ? new Date(n).toLocaleString() : ''; } function showError(e) { var message = e && e.message ? e.message : 'The requested action could not be completed. Please refresh the page and try again.'; OLT.alert(message, true); }
