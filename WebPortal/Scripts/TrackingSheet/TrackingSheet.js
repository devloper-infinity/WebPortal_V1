
    var page = 'TrackingSheet.aspx', flow = [], queue = []; document.addEventListener('DOMContentLoaded', function () {bindTabs(); setToday(); OLT.call(page, 'GetProjects').then(function (r) {OLT.options(project, r, ['ProjectID', 'projectID'], ['ProjectName', 'ProjectNo', 'Name'], 'Select project'); }); OLT.call(page, 'GetDailyProcesses').then(function (r) {OLT.options(dailyProcess, r, ['ProcessID'], ['ProcessName'], 'All processes'); }); project.onchange = loadProject; deal.onchange = selectDeal; process.onchange = tryLoadLoan; loadQueue(); loadDaily(); });

    function bindTabs() {[].slice.call(document.querySelectorAll('.ots-tab')).forEach(function (b) { b.onclick = function () { document.querySelector('.ots-tab.active').classList.remove('active'); document.querySelector('.ots-panel.active').classList.remove('active'); b.classList.add('active'); document.getElementById(b.dataset.panel).classList.add('active'); if (b.dataset.panel === 'status') loadQueue(); if (b.dataset.panel === 'daily') loadDaily(); }; }); }

    function loadProject() { if (!project.value) return; process.disabled = true; loan.innerHTML = '<option value="">Select deal and process</option>'; Promise.all([OLT.call(page, 'GetDeals', {projectId: +project.value }), OLT.call(page, 'GetFlow', {projectId: +project.value })]).then(function (r) {OLT.options(deal, r[0], ['DealNo', 'DealNumber', 'Deal'], ['DealNo', 'DealNumber', 'Deal'], 'Select deal'); flow = r[1]; OLT.options(process, flow, ['ProcessID'], ['ProcessName'], 'Select deal first'); process.disabled = true; }).catch(showError); }

    function selectDeal() {process.disabled = !deal.value; process.value = ''; if (process.options.length) process.options[0].text = deal.value ? 'Select process' : 'Select deal first'; loan.innerHTML = '<option value="">Select process</option>'; }

    function tryLoadLoan() { if (!project.value || !process.value || !deal.value) return; var selected = process.options[process.selectedIndex]; loan.innerHTML = '<option value="">Checking eligibility...</option>'; OLT.call(page, 'GetAvailableLoan', {projectId: +project.value, dealNumber: deal.value, processId: +process.value, processName: selected.text }).then(function (r) { if (typeof r === 'string') { try {r = JSON.parse(r); } catch (e) {r = { LoanNumber: r }; } } var number = r && r.LoanNumber ? String(r.LoanNumber) : ''; loan.innerHTML = ''; var option = document.createElement('option'); option.value = number; option.textContent = number || 'No eligible loan available'; loan.appendChild(option); }).catch(showError); }

    function allocateLoan() { if (!loan.value) {OLT.alert('No eligible loan is available for the selected process and deal.', true); return; } OLT.call(page, 'Allocate', {projectId: +project.value, processId: +process.value, loanNumber: loan.value, dealNumber: deal.value }).then(function (r) { if (!actionSucceeded(r)) return; OLT.alert(r.Message || 'Loan allocated successfully.'); tryLoadLoan(); loadQueue(); }).catch(showError); }

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

    function startLoan(id) {OLT.call(page, 'StartLoan', { assignmentId: id }).then(function (r) { if (!actionSucceeded(r)) return; OLT.alert(r.Message || 'Loan marked In Process.'); loadQueue(); }).catch(showError); }

    function resumeLoan(id) {OLT.call(page, 'ResumeLoan', { assignmentId: id }).then(function (r) { if (!actionSucceeded(r)) return; OLT.alert(r.Message || 'Loan resumed successfully.'); loadQueue(); loadDaily(); }).catch(showError); }

    var activeAssignment = null, feedbackRequired = false, savedFeedbacks = 0, feedbackOwners = [];

    function openComplete(id) {activeAssignment = queue.filter(function (q) { return q.AssignmentID === id; })[0] || null; feedbackRequired = !!(activeAssignment && activeAssignment.FeedbackRequiredOnComplete); savedFeedbacks = 0; assignmentId.value = id; completeRemark.value = ''; updateStatus.value = ''; holdReason.value = ''; changeCompletionStatus(); savedFeedbackList.innerHTML = ''; savedFeedbackCount.textContent = '0 feedback added'; continueAfterFeedback.disabled = true;[statusStep, feedbackStep, completeStep].forEach(function (s) {s.classList.remove('active'); }); statusStep.classList.add('active'); completeModal.classList.add('open'); }

    function closeComplete() {completeModal.classList.remove('open'); activeAssignment = null; }

    function changeCompletionStatus() { var isHold = updateStatus.value === 'Hold'; holdReasonField.style.display = isHold ? 'block' : 'none'; statusContinueButton.textContent = isHold ? 'Place on Hold' : 'Continue'; }

    function selectCompletionStatus() { if (updateStatus.value === 'Hold') { if (!holdReason.value) {OLT.alert('Please select a hold reason.', true); return; } statusContinueButton.disabled = true; OLT.call(page, 'HoldLoan', {assignmentId: +assignmentId.value, holdReason: holdReason.value }).then(function (r) { if (!actionSucceeded(r)) return; closeComplete(); OLT.alert(r.Message || 'Loan placed on hold successfully.'); loadQueue(); loadDaily(); }).catch(showError).then(function () {statusContinueButton.disabled = false; }); return; } if (updateStatus.value !== 'Completed') {OLT.alert('Please select a status.', true); return; } statusStep.classList.remove('active'); if (!feedbackRequired) {completeStep.classList.add('active'); return; } feedbackStep.classList.add('active'); loadFeedbackForm(); }

    function parseJsonResult(r) { if (typeof r === 'string') { try { return JSON.parse(r); } catch (e) { return { }; } } return r || { }; }

    function fillSelect(el, rows, valueName, textName, placeholder) {el.innerHTML = '<option value="">' + placeholder + '</option>'; (rows || []).forEach(function (x) { var o = document.createElement('option'); o.value = x[valueName]; o.textContent = x[textName]; el.appendChild(o); }); }

    function loadFeedbackForm() {OLT.call(page, 'GetFeedbackDefaults', { assignmentId: +assignmentId.value }).then(function (r) { r = parseJsonResult(r); var context = (r.table0 || [])[0] || {}; feedbackOwners = r.table2 || []; fillSelect(fbErrorBy, feedbackOwners, 'AssignmentID', 'UserName', 'Select'); if (feedbackOwners.length) fbErrorBy.value = String(feedbackOwners[0].AssignmentID); bindFeedbackOwner(); fbLoanNumber.value = context.LoanNumber || ''; fbClient.value = context.Client || ''; fbFeedbackBy.value = context.FeedbackBy || ''; fbQCDate.value = context.QCDate || ''; fbReceivedDate.value = context.QCDate || ''; savedFeedbacks = +(context.FeedbackCount || 0); updateFeedbackState(); OLT.call(page, 'GetFeedbackCategories').then(function (c) { fillSelect(fbCategory, c, 'Value', 'Text', 'Select'); }).catch(showError); }).catch(showError); }

    function bindFeedbackOwner() { var assignment = String(fbErrorBy.value || ''), owner = feedbackOwners.filter(function (x) { return String(x.AssignmentID) === assignment; })[0] || { }; fbMarkedTo.value = owner.ProcessName || ''; fbDateReviewed.value = formatFeedbackDate(owner.CompletedDate); }

    function formatFeedbackDate(value) { if (!value) return ''; var n = parseInt(String(value).replace(/\D/g, ''), 10), d = n ? new Date(n) : new Date(value); if (isNaN(d.getTime())) return ''; return String(d.getMonth() + 1).padStart(2, '0') + '/' + String(d.getDate()).padStart(2, '0') + '/' + d.getFullYear(); }

    function loadFeedbackSubcategories() {fbSubcategory.innerHTML = '<option value="">Select</option>'; if (!fbCategory.value) return; OLT.call(page, 'GetFeedbackSubcategories', {categoryId: +fbCategory.value }).then(function (r) {fillSelect(fbSubcategory, r, 'Value', 'Text', 'Select'); }).catch(showError); }

    function feedbackModel() { var owner = feedbackOwners.filter(function (x) { return String(x.AssignmentID) === String(fbErrorBy.value); })[0] || { }; return {AssignmentID: +assignmentId.value, MarkedTo: owner.ProcessName || '', ErrorBy: owner.UserName || '', FeedbackBy: fbFeedbackBy.value, DateReviewed: fbDateReviewed.value, ErrorType: fbErrorType.value.trim(), CategoryID: +fbCategory.value || 0, Category: fbCategory.options[fbCategory.selectedIndex] ? fbCategory.options[fbCategory.selectedIndex].text : '', SubcategoryID: +fbSubcategory.value || 0, Subcategory: fbSubcategory.options[fbSubcategory.selectedIndex] ? fbSubcategory.options[fbSubcategory.selectedIndex].text : '', Severity: fbSeverity.value, ErrorField: fbErrorField.value.trim(), Screen: fbScreen.value.trim(), FeedbackType: fbFeedbackType.value.trim(), Error: fbError.value.trim(), ShouldBe: '', Remark: '' }; }

    function validateFeedback(m) { if (!m.MarkedTo || !m.ErrorBy) return 'Please select UW Name.'; if (!m.ErrorType) return 'Please enter Error Type.'; if (!m.CategoryID) return 'Please select Category.'; if (!m.SubcategoryID) return 'Please select Subcategory.'; if (!m.Severity) return 'Please select Severity.'; if (!m.ErrorField) return 'Please enter Error Field.'; if (!m.FeedbackType) return 'Please enter Feedback Type.'; if (!m.Error) return 'Please enter Finding.'; return ''; }

    function saveFeedback() { var m = feedbackModel(), error = validateFeedback(m); if (error) {OLT.alert(error, true); return; } OLT.call(page, 'SaveFeedback', {model: m }).then(function (r) { if (!actionSucceeded(r)) return; savedFeedbacks = +(r.FeedbackCount || savedFeedbacks + 1); var item = document.createElement('div'); item.textContent = 'Feedback #' + r.FeedbackID + ' added successfully.'; savedFeedbackList.appendChild(item); clearFeedbackEntry(); updateFeedbackState(); OLT.alert(r.Message || 'Feedback added successfully.'); }).catch(showError); }

    function clearFeedbackEntry() {fbErrorType.value = ''; fbCategory.value = ''; fbSubcategory.innerHTML = '<option value="">Select</option>'; fbSeverity.value = ''; fbErrorField.value = ''; fbScreen.value = ''; fbFeedbackType.value = ''; fbError.value = ''; }

    function updateFeedbackState() {savedFeedbackCount.textContent = savedFeedbacks + ' feedback ' + (savedFeedbacks === 1 ? 'added' : 'entries added'); continueAfterFeedback.disabled = savedFeedbacks < 1; }

    function continueToComplete() { if (feedbackRequired && savedFeedbacks < 1) {OLT.alert('At least one feedback entry is required.', true); return; } feedbackStep.classList.remove('active'); completeStep.classList.add('active'); }

    function submitCompletion() { if (!completeRemark.value.trim()) {OLT.alert('Remark is required.', true); return; } OLT.call(page, 'CompleteLoan', {assignmentId: +assignmentId.value, remark: completeRemark.value, feedbacks: [] }).then(function (r) { if (!actionSucceeded(r)) return; closeComplete(); OLT.alert(r.Message || 'Loan completed.'); loadQueue(); loadDaily(); }).catch(showError); }

    function setToday() { var d = new Date().toISOString().slice(0, 10); fromDate.value = toDate.value = d; } function applyMonth() { if (!monthFilter.value) return; var p = monthFilter.value.split('-'), start = new Date(+p[0], +p[1] - 1, 1), end = new Date(+p[0], +p[1], 0); fromDate.value = localIso(start); toDate.value = localIso(end); } function localIso(d) { return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0'); }

    function loadDaily() {OLT.call(page, 'GetDailyStatus', { processId: +dailyProcess.value || 0, fromDate: fromDate.value, toDate: toDate.value }).then(function (r) { if (window.jQuery && $.fn.DataTable && $.fn.DataTable.isDataTable('#dailyTable')) $('#dailyTable').DataTable().destroy(); dailyRows.innerHTML = r.length ? r.map(function (x) { return '<tr><td>' + OLT.esc(x.ProjectName || x.ProjectID) + '</td><td>' + OLT.esc(x.DealNumber) + '</td><td>' + OLT.esc(x.LoanNumber) + '</td><td>' + OLT.esc(x.ProcessName) + '</td><td>' + x.AssignmentStatus + '</td><td>' + fmt(x.AssignedDate) + '</td><td>' + fmt(x.StartedDate) + '</td><td>' + fmt(x.CompletedDate) + '</td><td>' + duration(x.HoldTATSeconds) + '</td><td>' + duration(x.TotalTATSeconds) + '</td><td>' + OLT.esc(x.LastRemark) + '</td></tr>'; }).join('') : '<tr><td colspan="11" class="olt-empty">No loans found.</td></tr>'; if (r.length && window.jQuery && $.fn.DataTable) $('#dailyTable').DataTable({ pageLength: 25, order: [] }); }).catch(showError); } function actionSucceeded(r) { if (typeof r === 'string') { try {r = JSON.parse(r); } catch (e) {r = { Success: false, Message: 'The requested action could not be completed.' }; } } if (!r || r.Success !== true) {OLT.alert(r && r.Message ? r.Message : 'The requested action could not be completed.', true); return false; } return true; } function duration(value) { var s = Math.max(0, +value || 0), d = Math.floor(s / 86400); s %= 86400; var h = Math.floor(s / 3600); s %= 3600; var m = Math.floor(s / 60); return (d ? d + 'd ' : '') + String(h).padStart(2, '0') + ':' + String(m).padStart(2, '0'); } function fmt(v) { var n = parseInt(String(v || '').replace(/\D/g, ''), 10); return n ? new Date(n).toLocaleString() : ''; } function showError(e) {OLT.alert('The requested action could not be completed. Please refresh the page and try again.', true); }
