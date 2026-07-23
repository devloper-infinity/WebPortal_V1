var page = 'ManagerDashboard.aspx', reAllUsers = []; document.addEventListener('DOMContentLoaded', function () { bindManagerTabs(); setDates(); OLT.call(page, 'GetProjects').then(function (r) { [mgrProject, dealProject, hourlyProject, reProject].forEach(function (s) { OLT.options(s, r, ['ProjectID'], ['ProjectName'], 'Select project'); }); }); mgrProject.onchange = function () { clearReport(); if (mgrProject.value) loadFilters(); else clearFilters(); }; dealProject.onchange = function () { loadDeals(dealProject, dealNumber, 'All deals'); }; hourlyProject.onchange = function () { loadDeals(hourlyProject, hourlyDeal, 'All deals'); }; reProject.onchange = loadReProject; reDeal.onchange = enableReProcess; reProcess.onchange = loadReUsers; reFromUser.onchange = function () { renderReTargets(); loadReOrders(); }; });
var pmaUsers = []; document.addEventListener('DOMContentLoaded', function () { OLT.call(page, 'GetProjects').then(function (r) { OLT.options(pmaProject, r, ['ProjectID'], ['ProjectName'], 'Select project'); }); pmaProject.onchange = loadProjectData; pmaDeal.onchange = enableProcess; pmaProcess.onchange = loadLoans; pmaUser.onchange = showUserCount; });
function loadProjectData() { pmaDeal.disabled = true; pmaProcess.disabled = true; pmaUser.disabled = true; pmaLoans.innerHTML = '<div class="olt-empty">Loading...</div>'; if (!pmaProject.value) return; Promise.all([OLT.call(page, 'GetDeals', { projectId: +pmaProject.value }), OLT.call(page, 'GetFlow', { projectId: +pmaProject.value }), OLT.call(page, 'GetUsers', { projectId: +pmaProject.value })]).then(function (r) { OLT.options(pmaDeal, r[0], ['DealNo', 'DealNumber', 'Deal'], ['DealNo', 'DealNumber', 'Deal'], 'Select deal'); pmaDeal.disabled = false; OLT.options(pmaProcess, r[1], ['ProcessID'], ['ProcessName'], 'Select deal first'); pmaUsers = r[2]; pmaUser.innerHTML = '<option value="">Select user</option>'; pmaUsers.forEach(function (x) { var o = document.createElement('option'); o.value = x.UserID; o.textContent = x.UserName + ' (' + x.ActiveCount + ' active)'; pmaUser.appendChild(o); }); pmaUser.disabled = false; pmaLoans.innerHTML = '<div class="olt-empty">Select deal and process.</div>'; }).catch(showAllocationError); }
function enableProcess() { pmaProcess.disabled = !pmaDeal.value; pmaProcess.value = ''; if (pmaProcess.options.length) pmaProcess.options[0].text = pmaDeal.value ? 'Select process' : 'Select deal first'; pmaLoans.innerHTML = '<div class="olt-empty">Select process.</div>'; }
function loadLoans() { if (!pmaProject.value || !pmaDeal.value || !pmaProcess.value) return; pmaLoans.innerHTML = '<div class="olt-empty">Loading eligible orders...</div>'; OLT.call(page, 'GetEligibleLoans', { projectId: +pmaProject.value, dealNumber: pmaDeal.value, processId: +pmaProcess.value }).then(function (r) { pmaLoans.innerHTML = r.length ? r.map(function (x) { return '<label class="pma-loan"><input type="checkbox" class="pma-check" value="' + OLT.esc(x.LoanNumber) + '" onchange="limitSelection(this)"/><span>' + OLT.esc(x.LoanNumber) + '</span></label>'; }).join('') : '<div class="olt-empty">No eligible orders found.</div>'; }).catch(showAllocationError); }
function limitSelection(changed) { var selected = document.querySelectorAll('.pma-check:checked'); if (selected.length > 2) { changed.checked = false; OLT.alert('Select a maximum of two orders.', true); } }
function showUserCount() { var u = pmaUsers.filter(function (x) { return String(x.UserID) === String(pmaUser.value); })[0]; pmaUserNote.textContent = u ? u.ActiveCount + ' active Pending/In Process order(s).' : ''; }

var reCurrentOrders = [];

function allocateSelected() {
    var loans = [].slice.call(document.querySelectorAll('.pma-check:checked')).map(function (x) { return x.value; });

    if (!pmaUser.value) {
        OLT.alert('Please select a user.', true);
        return;
    }

    if (!loans.length || loans.length > 2) {
        OLT.alert('Select one or two orders.', true);
        return;
    }

    OLT.call(page, 'AllocateOrders', { projectId: +pmaProject.value, dealNumber: pmaDeal.value, processId: +pmaProcess.value, targetUserId: +pmaUser.value, loanNumbers: loans }).then(function (r) {

        if (!r || r.Success !== true) {
            OLT.alert(r && r.Message ? r.Message : 'Allocation failed.', true);
            return;
        }

        OLT.alert(r.Message); loadProjectData();

    }).catch(showAllocationError);
}
function showAllocationError() { OLT.alert('The requested action could not be completed. Please try again.', true); }
function bindManagerTabs() { function activate(b) { document.querySelector('.mgr-tab.active').classList.remove('active'); document.querySelector('.mgr-panel.active').classList.remove('active'); b.classList.add('active'); document.getElementById(b.dataset.panel).classList.add('active'); mgrActivePanel.value = b.dataset.panel; } [].slice.call(document.querySelectorAll('.mgr-tab')).forEach(function (b) { b.onclick = function () { activate(b); }; }); var saved = document.querySelector('.mgr-tab[data-panel="' + mgrActivePanel.value + '"]'); if (saved && !saved.classList.contains('active')) activate(saved); }
function setDates() { var e = new Date(), s = new Date(); s.setDate(e.getDate() - 30); mgrFrom.value = iso(s); mgrTo.value = iso(e); hourlyDate.value = iso(e); } function iso(d) { return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0'); }
function clearFilters() { mgrProcess.innerHTML = '<option value="0">All processes</option>'; mgrUser.innerHTML = '<option value="0">All users</option>'; }
function clearReport() { renderSummary([]); renderDetails([]); }
function loadFilters() { var id = +mgrProject.value; if (!id) return; Promise.all([OLT.call(page, 'GetProcesses', { projectId: id }), OLT.call(page, 'GetUsers', { projectId: id })]).then(function (r) { OLT.options(mgrProcess, r[0], ['ProcessID'], ['ProcessName'], 'All processes'); mgrProcess.options[0].value = '0'; OLT.options(mgrUser, r[1], ['UserID'], ['UserName'], 'All users'); mgrUser.options[0].value = '0'; }).catch(showError); }
function loadManagerReport() { var projectId = +mgrProject.value; if (!projectId) { OLT.alert('Please select Project #.', true); return; } OLT.call(page, 'GetReport', { projectId: projectId, processId: +mgrProcess.value || 0, userId: +mgrUser.value || 0, status: mgrStatus.value, fromDate: mgrFrom.value, toDate: mgrTo.value }).then(function (r) { if (typeof r === 'string') r = JSON.parse(r); renderSummary(r.table0 || []); renderDetails(r.table1 || []); }).catch(showError); }
function renderSummary(rows) { summaryRows.innerHTML = rows.length ? rows.map(function (x) { return '<tr><td>' + esc(x.ProjectName) + '</td><td>' + esc(x.ProcessName) + '</td><td>' + esc(x.UserName) + '</td><td>' + x.TotalOrders + '</td><td>' + x.PendingOrders + '</td><td>' + x.InProcessOrders + '</td><td>' + x.HoldOrders + '</td><td>' + x.CompletedOrders + '</td><td class="mgr-duration">' + duration(x.AverageTATSeconds) + '</td><td class="mgr-duration">' + duration(x.TotalHoldTATSeconds) + '</td></tr>'; }).join('') : '<tr><td colspan="10" class="olt-empty">No summary records found.</td></tr>'; }
function renderDetails(rows) { var counts = { total: rows.length, pending: 0, process: 0, hold: 0, completed: 0 }; rows.forEach(function (x) { if (x.AssignmentStatus === 'Pending') counts.pending++; else if (x.AssignmentStatus === 'In Process') counts.process++; else if (x.AssignmentStatus === 'Hold') counts.hold++; else if (x.AssignmentStatus === 'Completed') counts.completed++; }); kTotal.textContent = counts.total; kPending.textContent = counts.pending; kProcess.textContent = counts.process; kHold.textContent = counts.hold; kCompleted.textContent = counts.completed; detailRows.innerHTML = rows.length ? rows.map(function (x) { return '<tr><td>' + esc(x.ProjectName) + '</td><td>' + esc(x.DealNumber) + '</td><td>' + esc(x.LoanNumber) + '</td><td>' + esc(x.ProcessName) + '</td><td>' + esc(x.UserName) + '</td><td>' + esc(x.AssignmentStatus) + '</td><td>' + fmt(x.AssignedDate) + '</td><td>' + fmt(x.StartedDate) + '</td><td>' + fmt(x.CompletedDate) + '</td><td>' + duration(x.HoldTATSeconds) + '</td><td>' + duration(x.TotalTATSeconds) + '</td><td>' + esc(x.LastRemark) + '</td></tr>'; }).join('') : '<tr><td colspan="12" class="olt-empty">No detail records found.</td></tr>'; }
function loadDeals(projectSelect, dealSelect, placeholder) { dealSelect.disabled = true; dealSelect.innerHTML = '<option value="">' + placeholder + '</option>'; if (!projectSelect.value) return; OLT.call(page, 'GetDeals', { projectId: +projectSelect.value }).then(function (r) { OLT.options(dealSelect, r, ['DealNo', 'DealNumber', 'Deal'], ['DealNo', 'DealNumber', 'Deal'], placeholder); dealSelect.disabled = false; }).catch(showError); }
function loadDealDashboard() { if (!dealProject.value) { OLT.alert('Please select Project #.', true); return; } OLT.call(page, 'GetDealDashboard', { projectId: +dealProject.value, dealNumber: dealNumber.value }).then(function (r) { dealRows.innerHTML = r.length ? r.map(function (x) { return '<tr><td>' + esc(x.DealNumber) + '</td><td>' + x.DealCount + '</td><td>' + fmtDate(x.ReceivedDate) + '</td><td>' + fmtDate(x.DueDate) + '</td><td>' + esc(x.ProcessName) + '</td><td>' + x.PendingOrders + '</td><td>' + x.CompletedOrders + '</td><td>' + x.HoldOrders + '</td><td>' + x.SkippedOrders + '</td><td>' + x.TodayInProcess + '</td><td>' + x.TodayCompleted + '</td><td>' + x.TodayHold + '</td></tr>'; }).join('') : '<tr><td colspan="12" class="olt-empty">No deal records found.</td></tr>'; }).catch(showError); }
function loadHourly() { if (!hourlyProject.value) { OLT.alert('Please select Project #.', true); return; } OLT.call(page, 'GetHourlyProduction', { projectId: +hourlyProject.value, reportDate: hourlyDate.value, dealNumber: hourlyDeal.value }).then(function (r) { hourlyRows.innerHTML = r.length ? r.map(function (x) { return '<tr><td>' + esc(x.DealNumber) + '</td><td>' + esc(x.ProcessName) + '</td><td>' + x.H10AM + '</td><td>' + x.H12PM + '</td><td>' + x.H02PM + '</td><td>' + x.H04PM + '</td><td>' + x.H06PM + '</td><td>' + x.H08PM + '</td><td>' + x.H10PM + '</td><td>' + x.H12AM + '</td><td>' + x.H02AM + '</td><td>' + x.H04AM + '</td><td>' + x.H06AM + '</td><td>' + x.H08AM + '</td><td>' + x.TotalCompleted + '</td></tr>'; }).join('') : '<tr><td colspan="15" class="olt-empty">No completed orders found for this production date.</td></tr>'; }).catch(showError); }
function loadReProject() { reDeal.disabled = true; reProcess.disabled = true; reFromUser.disabled = true; reToUser.disabled = true; reRows.innerHTML = '<tr><td colspan="9" class="olt-empty">Select project, deal, process and current user.</td></tr>'; if (!reProject.value) return; Promise.all([OLT.call(page, 'GetDeals', { projectId: +reProject.value }), OLT.call(page, 'GetProcesses', { projectId: +reProject.value }), OLT.call(page, 'GetUsers', { projectId: +reProject.value })]).then(function (r) { OLT.options(reDeal, r[0], ['DealNo', 'DealNumber', 'Deal'], ['DealNo', 'DealNumber', 'Deal'], 'Select deal'); reDeal.disabled = false; OLT.options(reProcess, r[1], ['ProcessID'], ['ProcessName'], 'Select deal first'); reAllUsers = r[2] || []; renderReTargets(); }).catch(showError); }
function enableReProcess() { reProcess.disabled = !reDeal.value; reProcess.value = ''; if (reProcess.options.length) reProcess.options[0].text = reDeal.value ? 'Select process' : 'Select deal first'; reFromUser.disabled = true; reRows.innerHTML = '<tr><td colspan="9" class="olt-empty">Select process and current user.</td></tr>'; }
function loadReUsers() { reFromUser.disabled = true; if (!reProject.value || !reDeal.value || !reProcess.value) return; OLT.call(page, 'GetReallocationUsers', { projectId: +reProject.value, dealNumber: reDeal.value, processId: +reProcess.value }).then(function (r) { OLT.options(reFromUser, r, ['UserID'], ['UserName'], 'Select current user'); reFromUser.disabled = false; renderReTargets(); }).catch(showError); }
function renderReTargets() { reToUser.innerHTML = '<option value="">Select new user</option>'; reAllUsers.filter(function (x) { return String(x.UserID) !== String(reFromUser.value); }).forEach(function (x) { var o = document.createElement('option'); o.value = x.UserID; o.textContent = x.UserName + ' (' + x.ActiveCount + ' active)'; reToUser.appendChild(o); }); reToUser.disabled = !reProject.value; }
function loadReOrders() { if (!reFromUser.value) return; OLT.call(page, 'GetReallocationOrders', { projectId: +reProject.value, dealNumber: reDeal.value, processId: +reProcess.value, fromUserId: +reFromUser.value }).then(function (r) { reCurrentOrders = r || []; reRows.innerHTML = reCurrentOrders.length ? reCurrentOrders.map(function (x) { return '<tr><td><input type="checkbox" class="mgr-select re-check" value="' + x.AssignmentID + '" onchange="limitReSelection(this)"/></td><td>' + esc(x.ProjectName) + '</td><td>' + esc(x.DealNumber) + '</td><td>' + esc(x.ProcessName) + '</td><td>' + esc(x.LoanNumber) + '</td><td>' + esc(x.UserName) + '</td><td>' + esc(x.AssignmentStatus) + '</td><td>' + esc(x.LastRemark) + '</td><td>' + fmt(x.AssignedDate) + '</td></tr>'; }).join('') : '<tr><td colspan="9" class="olt-empty">No allocated orders found for this user.</td></tr>'; }).catch(showError); }
function limitReSelection(changed) { if (document.querySelectorAll('.re-check:checked').length > 2) { changed.checked = false; OLT.alert('Select a maximum of two orders.', true); } }

function reallocateSelected() {
    var ids = [].slice.call(document.querySelectorAll('.re-check:checked')).map(function (x) { return +x.value; });

    if (!reFromUser.value) {

        OLT.alert('Please select Current User.', true); return;
    }

    if (!reToUser.value) {
        OLT.alert('Please select New User.', true); return;
    }

    if (!reRemark.value.trim()) {
        OLT.alert('Re-allocation remark is required.', true); return;
    }

    if (!ids.length || ids.length > 2) { OLT.alert('Select one or two orders.', true); return; }

    var hasInProcess = reCurrentOrders.some(function (order) {
        return ids.indexOf(+order.AssignmentID) >= 0 && order.AssignmentStatus === 'In Process';
    });

    if (hasInProcess && !window.confirm('Are you sure you want to reallocate this loan? This loan is currently In-Process.')) {
        return;
    }

    OLT.call(page, 'ReallocateOrders', { projectId: +reProject.value, fromUserId: +reFromUser.value, toUserId: +reToUser.value, assignmentIds: ids, remark: reRemark.value, confirmInProcess: hasInProcess }).then(function (r) {

        if (!r || r.Success !== true) {
            OLT.alert(r && r.Message ? r.Message : 'Re-allocation failed.', true); return;
        }

        OLT.alert(r.Message); reRemark.value = ''; loadReUsers(); reRows.innerHTML = '<tr><td colspan="9" class="olt-empty">Select current user to refresh orders.</td></tr>';
    }).catch(showError);
}


function exportTable(tableId, fileName) { var rows = [].slice.call(document.querySelectorAll('#' + tableId + ' tr')), csv = rows.map(function (row) { return [].slice.call(row.querySelectorAll('th,td')).map(function (cell) { return '"' + cell.textContent.trim().replace(/"/g, '""') + '"'; }).join(','); }).join('\r\n'), blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' }), a = document.createElement('a'); a.href = URL.createObjectURL(blob); a.download = fileName; document.body.appendChild(a); a.click(); a.remove(); URL.revokeObjectURL(a.href); }
function fmtDate(v) { var n = parseInt(String(v || '').replace(/\D/g, ''), 10); return n ? new Date(n).toLocaleDateString() : ''; }
function duration(v) { var s = Math.max(0, +v || 0), d = Math.floor(s / 86400); s %= 86400; var h = Math.floor(s / 3600); s %= 3600; var m = Math.floor(s / 60); return (d ? d + 'd ' : '') + String(h).padStart(2, '0') + ':' + String(m).padStart(2, '0'); } function fmt(v) { var n = parseInt(String(v || '').replace(/\D/g, ''), 10); return n ? new Date(n).toLocaleString() : ''; } function esc(v) { return OLT.esc(v); } function showError() { OLT.alert('The report could not be loaded. Please try again.', true); }
