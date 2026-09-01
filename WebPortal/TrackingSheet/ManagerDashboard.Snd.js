(function () {
    'use strict';
    var holdAvailableRows = [], heldRows = [], selectedHoldLoans = {}, selectedResumeLoans = {}, holdSearchLoans = [];
    var holdAvailableTable = null, heldTable = null;

    document.addEventListener('DOMContentLoaded', function () {
        setSndDates();
        OLT.call(page, 'GetProjects').then(function (rows) {
            [overviewProject, productivityProject, dailyProject, holdLoanProject].forEach(function (select) {
                OLT.options(select, rows, ['ProjectID'], ['ProjectName'], 'Select project');
            });
        }).catch(showError);
        loadHoldReasonsManager();
        holdLoanProject.onchange = loadHoldLoanDeals;
        holdLoanDeal.onchange = loadLoanHoldData;
        holdLoanSearch.oninput = applyHoldLoanSearch;
        clearHoldLoanSearch.onclick = function () { holdLoanSearch.value = ''; applyHoldLoanSearch(); };
        selectAllHoldLoans.onchange = toggleAllHoldLoans;
        selectAllResumeLoans.onchange = toggleAllResumeLoans;
        $('#holdLoanAvailableTable').on('change', '.hold-loan-check', function () { selectedHoldLoans[this.dataset.id] = this.checked; updateLoanHoldCounts(); });
        $('#heldLoanTable').on('change', '.resume-loan-check', function () { selectedResumeLoans[this.dataset.id] = this.checked; updateLoanHoldCounts(); });
        if (window.jQuery && $.fn.DataTable) $.fn.dataTable.ext.search.push(function (settings, data, dataIndex, rowData) {
            if (!settings.nTable || settings.nTable.id !== 'holdLoanAvailableTable' || !holdSearchLoans.length) return true;
            var loan = String((rowData && rowData.LoanNumber) || data[1] || '').trim().toLowerCase();
            return holdSearchLoans.indexOf(loan) >= 0;
        });
    });

    function resetLoanHoldTables(message) {
        if (holdAvailableTable) { holdAvailableTable.destroy(); holdAvailableTable = null; }
        if (heldTable) { heldTable.destroy(); heldTable = null; }
        holdAvailableRows = []; heldRows = []; selectedHoldLoans = {}; selectedResumeLoans = {};
        $('#holdLoanAvailableTable tbody').html('<tr><td colspan="8" class="olt-empty">' + message + '</td></tr>');
        $('#heldLoanTable tbody').html('<tr><td colspan="7" class="olt-empty">' + message + '</td></tr>');
        updateLoanHoldCounts();
    }

    function loadHoldLoanDeals() {
        holdLoanDeal.disabled = true;
        holdLoanDeal.innerHTML = '<option value="">' + (holdLoanProject.value ? 'Loading deals...' : 'Select project first') + '</option>';
        resetLoanHoldTables('Select Project and Deal.');
        if (!holdLoanProject.value) return;
        OLT.call(page, 'GetDeals', { projectId: +holdLoanProject.value }).then(function (rows) {
            OLT.options(holdLoanDeal, rows || [], ['DealNo', 'DealNumber', 'Deal'], ['DealNo', 'DealNumber', 'Deal'], 'Select deal');
            holdLoanDeal.disabled = false;
        }).catch(showError);
    }

    window.loadLoanHoldData = function () {
        resetLoanHoldTables('Loading loans...');
        if (!holdLoanProject.value || !holdLoanDeal.value) { resetLoanHoldTables('Select Project and Deal.'); return; }
        Promise.all([
            OLT.call(page, 'GetLoanHoldCandidates', { projectId: +holdLoanProject.value, dealNumber: holdLoanDeal.value }),
            OLT.call(page, 'GetHeldLoans', { projectId: +holdLoanProject.value, dealNumber: holdLoanDeal.value })
        ]).then(function (result) {
            holdAvailableRows = result[0] || []; heldRows = result[1] || [];
            renderAvailableHoldLoans(); renderHeldLoans();
        }).catch(showError);
    };

    function renderAvailableHoldLoans() {
        selectedHoldLoans = {}; updateLoanHoldCounts();
        if (holdAvailableTable) holdAvailableTable.destroy();
        holdAvailableTable = $('#holdLoanAvailableTable').DataTable({
            data: holdAvailableRows, pageLength: 25, order: [[1, 'asc']], autoWidth: false, dom: 'lrtip',
            columns: [
                { data: null, orderable: false, searchable: false, render: function (_, type, row) { return type === 'display' ? '<input type="checkbox" class="hold-loan-check" data-id="' + (+row.ItemID) + '"' + (selectedHoldLoans[row.ItemID] ? ' checked' : '') + ' />' : ''; } },
                { data: 'LoanNumber', render: holdText }, { data: 'DealNumber', render: holdText },
                { data: 'LoanStatus', defaultContent: 'Pending', render: holdText },
                { data: 'ProcessName', defaultContent: '—', render: holdText }, { data: 'UserName', defaultContent: '—', render: holdText },
                { data: 'AssignmentStatus', defaultContent: 'Not Assigned', render: holdText },
                { data: 'AddedDate', render: function (value, type) { return type === 'display' ? fmt(value) : (value || ''); } }
            ],
            language: { emptyTable: 'No available loans found for this Project and Deal.' },
            drawCallback: function () { selectAllHoldLoans.checked = false; }
        });
        applyHoldLoanSearch();
    }

    function renderHeldLoans() {
        selectedResumeLoans = {}; updateLoanHoldCounts();
        if (heldTable) heldTable.destroy();
        heldTable = $('#heldLoanTable').DataTable({
            data: heldRows, pageLength: 25, order: [[5, 'desc']], autoWidth: false, dom: 'lrtip',
            columns: [
                { data: null, orderable: false, searchable: false, render: function (_, type, row) { return type === 'display' ? '<input type="checkbox" class="resume-loan-check" data-id="' + (+row.ItemID) + '"' + (selectedResumeLoans[row.ItemID] ? ' checked' : '') + ' />' : ''; } },
                { data: 'LoanNumber', render: holdText }, { data: 'DealNumber', render: holdText },
                { data: 'Reason', render: holdText }, { data: 'HeldByName', render: holdText },
                { data: 'HeldDate', render: function (value, type) { return type === 'display' ? fmt(value) : (value || ''); } },
                { data: null, render: function (_, type, row) { var value = (row.ProcessName || 'Not Assigned') + (row.UserName ? ' / ' + row.UserName : ''); return type === 'display' ? OLT.esc(value) : value; } }
            ],
            language: { emptyTable: 'No currently held loans for this Project and Deal.' },
            drawCallback: function () { selectAllResumeLoans.checked = false; }
        });
    }

    function applyHoldLoanSearch() {
        holdSearchLoans = String(holdLoanSearch.value || '').split(',').map(function (value) { return value.trim().toLowerCase(); })
            .filter(function (value, index, values) { return value && values.indexOf(value) === index; });
        if (holdAvailableTable) holdAvailableTable.draw();
    }

    function toggleAllHoldLoans() {
        if (!holdAvailableTable) return;
        var checked = selectAllHoldLoans.checked;
        holdAvailableTable.rows({ search: 'applied' }).every(function () { selectedHoldLoans[this.data().ItemID] = checked; });
        $('#holdLoanAvailableTable tbody .hold-loan-check').prop('checked', checked); updateLoanHoldCounts();
    }

    function toggleAllResumeLoans() {
        if (!heldTable) return;
        var checked = selectAllResumeLoans.checked;
        heldTable.rows({ search: 'applied' }).every(function () { selectedResumeLoans[this.data().ItemID] = checked; });
        $('#heldLoanTable tbody .resume-loan-check').prop('checked', checked); updateLoanHoldCounts();
    }

    function selectedIds(selection) { return Object.keys(selection).filter(function (id) { return selection[id]; }).map(function (id) { return +id; }); }
    function holdText(value, type) { value = value == null || value === '' ? '—' : String(value); return type === 'display' ? OLT.esc(value) : value; }
    function updateLoanHoldCounts() {
        holdLoanSelectionCount.textContent = selectedIds(selectedHoldLoans).length + ' loan(s) selected';
        resumeLoanSelectionCount.textContent = selectedIds(selectedResumeLoans).length + ' loan(s) selected';
    }

    window.holdSelectedLoans = function () {
        var ids = selectedIds(selectedHoldLoans), reason = String(holdLoanReason.value || '').trim();
        if (!holdLoanProject.value || !holdLoanDeal.value) { OLT.alert('Please select Project # and Deal #.', true); return; }
        if (!ids.length) { OLT.alert('Select at least one loan to place on HOLD.', true); return; }
        if (!reason) { OLT.alert('Reason is required.', true); return; }
        OLT.call(page, 'HoldLoans', { projectId: +holdLoanProject.value, dealNumber: holdLoanDeal.value, itemIds: ids, reason: reason }).then(function (result) {
            if (!result || result.Success !== true) { OLT.alert(result && result.Message ? result.Message : 'Unable to hold the selected loans.', true); return; }
            holdLoanReason.value = ''; OLT.alert(result.Message); loadLoanHoldData();
        }).catch(showError);
    };

    window.resumeSelectedLoans = function () {
        var ids = selectedIds(selectedResumeLoans);
        if (!ids.length) { OLT.alert('Select at least one held loan to RESUME.', true); return; }
        if (!window.confirm('Resume the selected loan(s) and return them to the normal process flow?')) return;
        OLT.call(page, 'ResumeHeldLoans', { projectId: +holdLoanProject.value, dealNumber: holdLoanDeal.value, itemIds: ids }).then(function (result) {
            if (!result || result.Success !== true) { OLT.alert(result && result.Message ? result.Message : 'Unable to resume the selected loans.', true); return; }
            OLT.alert(result.Message); loadLoanHoldData();
        }).catch(showError);
    };

    window.setSndDates = function (prefix) {
        var end = new Date(), start = new Date();
        start.setDate(end.getDate() - 30);
        ['overview', 'productivity', 'daily'].filter(function (name) { return !prefix || name === prefix; }).forEach(function (name) {
            document.getElementById(name + 'From').value = iso(start);
            document.getElementById(name + 'To').value = iso(end);
        });
    };

    window.resetSndFilter = function (prefix) {
        document.getElementById(prefix + 'Project').value = '';
        setSndDates(prefix);
        clearReport(prefix);
    };

    function clearReport(prefix) {
        if (prefix === 'overview') {
            overviewProcessKpis.innerHTML = '<div class="snd-empty">Select a project to view the report.</div>';
            overviewSelectedProcessKpis.innerHTML = '<div class="snd-empty">Select a project to view the report.</div>';
            topContributorRows.innerHTML = '<tr><td colspan="5" class="olt-empty">No data loaded.</td></tr>';
            dealProgressRows.innerHTML = notAssignedRows.innerHTML = '<tr><td colspan="3" class="olt-empty">No data loaded.</td></tr>';
            topCurrentTotal.textContent = topPreviousTotal.textContent = notAssignedTotal.textContent = '0';
            dealProgressTotal.textContent = '0 / 0'; dealProgressPercent.textContent = '0%';
        } else if (prefix === 'productivity') {
            productivityHead.innerHTML = '<tr><th>Rank</th><th>Reviewer</th><th>Days Worked</th><th>% Target</th></tr>';
            productivityRows.innerHTML = '<tr><td colspan="4" class="olt-empty">Select a project to view productivity.</td></tr>';
        } else {
            dailyProcessSections.innerHTML = '<div class="snd-empty">Select a project to view daily production.</div>';
        }
    }

    function getData(prefix) {
        var project = document.getElementById(prefix + 'Project');
        var from = document.getElementById(prefix + 'From');
        var to = document.getElementById(prefix + 'To');
        if (!project.value) { OLT.alert('Please select Project #.', true); return Promise.reject({ handled: true }); }
        if (!from.value || !to.value || from.value > to.value) { OLT.alert('Please enter a valid date range.', true); return Promise.reject({ handled: true }); }
        OLT.showLoading('Loading dashboard report...');
        return OLT.call(page, 'GetSndDashboard', { projectId: +project.value, fromDate: from.value, toDate: to.value }).then(function (result) {
            OLT.hideLoading(true);
            return typeof result === 'string' ? JSON.parse(result) : result;
        }).catch(function (error) {
            OLT.hideLoading(true);
            if (!error || !error.handled) showError();
            throw error;
        });
    }

    window.loadOverview = function () { getData('overview').then(renderOverview).catch(ignore); };

    function renderOverview(data) {
        var summary = data.table1 || [], contributors = data.table2 || [], deals = data.table3 || [];
        overviewProcessKpis.innerHTML = summary.length ? summary.map(function (row) {
            return '<div class="snd-process-card"><h4>' + esc(row.ProcessName) + '</h4><div class="snd-process-values">' +
                '<div><span>Assigned</span><strong>' + (+row.TotalAssigned || 0) + '</strong></div>' +
                '<div><span>Done</span><strong>' + (+row.DoneCount || 0) + '</strong></div>' +
                '<div><span>In Process</span><strong>' + (+row.InProcessCount || 0) + '</strong></div></div></div>';
        }).join('') : '<div class="snd-empty">No loan-based processes are configured for this project.</div>';
        var requiredProcesses = ['ccreview', 'ccqc', 'ssreview', 'ssqc'];
        var processSummary = requiredProcesses.map(function (name) {
            return summary.filter(function (row) {
                return String(row.ProcessName || '').toLowerCase().replace(/[^a-z0-9]/g, '') === name;
            })[0];
        }).filter(Boolean);
        overviewSelectedProcessKpis.innerHTML = processSummary.length ? processSummary.map(function (row) {
            var assigned = +row.TotalAssigned || 0, done = +row.DoneCount || 0;
            var inProcess = row.InProcessCount == null ? Math.max(0, assigned - done) : (+row.InProcessCount || 0);
            var donePercent = assigned ? (done / assigned * 100).toFixed(1) : '0.0';
            var inProcessPercent = assigned ? (inProcess / assigned * 100).toFixed(1) : '0.0';
            return '<div class="snd-process-card"><h4>' + esc(row.ProcessName) + '</h4>' +
                '<div class="snd-process-total"><strong>' + assigned + '</strong><span>Total Assigned</span></div>' +
                '<div class="snd-process-values"><div class="snd-process-done"><strong>' + done + '</strong><span>Done</span><small>' + donePercent + '%</small></div>' +
                '<div class="snd-process-pending"><strong>' + inProcess + '</strong><span>In Process</span><small>' + inProcessPercent + '%</small></div></div></div>';
        }).join('') : '<div class="snd-empty">No loan-based processes are configured for this project.</div>';

        var active = contributors.filter(function (row) { return +row.CurrentDone > 0; });
        var topRows = active.slice(0, 10);
        topContributorRows.innerHTML = topRows.map(function (row) {
            var change = (+row.PreviousRank || 0) - (+row.CurrentRank || 0);
            var css = change > 0 ? 'up' : change < 0 ? 'down' : 'same';
            var label = change > 0 ? '▲ ' + change : change < 0 ? '▼ ' + Math.abs(change) : '—';
            return '<tr><td class="snd-rank">' + row.CurrentRank + '</td><td>' + esc(row.UserName) + '</td><td>' + row.CurrentDone + '</td><td>' + row.PreviousDone + '</td><td class="snd-delta ' + css + '">' + label + '</td></tr>';
        }).join('') || '<tr><td colspan="5" class="olt-empty">No completed production found.</td></tr>';
        topCurrentTotal.textContent = total(topRows, 'CurrentDone'); topPreviousTotal.textContent = total(topRows, 'PreviousDone');

        var notAssigned = contributors.filter(function (row) { return +row.CurrentAssigned === 0 && +row.RecentActivity > 0; });
        notAssignedRows.innerHTML = notAssigned.map(function (row, index) {
            return '<tr><td class="snd-rank">' + (index + 1) + '</td><td>' + esc(row.UserName) + '</td><td>' + row.RecentActivity + '</td></tr>';
        }).join('') || '<tr><td colspan="3" class="olt-empty">All recently active reviewers have assignments in this period.</td></tr>';
        notAssignedTotal.textContent = total(notAssigned, 'RecentActivity');

        dealProgressRows.innerHTML = deals.map(function (row) {
            var count = +row.TotalLoans || 0, completed = +row.CompletedLoans || 0;
            var percent = count ? Math.min(100, completed / count * 100) : 0;
            return '<tr><td>' + esc(row.DealNumber || 'Unspecified') + '</td><td>' + completed + ' / ' + count + '</td><td class="snd-progress"><div class="snd-progress-track"><div class="snd-progress-fill" style="width:' + percent.toFixed(1) + '%"></div></div><span class="snd-progress-label">' + percent.toFixed(1) + '%</span></td></tr>';
        }).join('') || '<tr><td colspan="3" class="olt-empty">No deal activity found.</td></tr>';
        var allLoans = total(deals, 'TotalLoans'), allDone = total(deals, 'CompletedLoans');
        dealProgressTotal.textContent = allDone + ' / ' + allLoans;
        dealProgressPercent.textContent = allLoans ? (allDone / allLoans * 100).toFixed(1) + '%' : '0%';
    }

    window.loadProductivity = function () { getData('productivity').then(renderProductivity).catch(ignore); };

    function renderProductivity(data) {
        var processes = data.table0 || [], rows = data.table4 || [], users = {};
        rows.forEach(function (row) {
            var key = row.UserID;
            if (!users[key]) users[key] = { name: row.UserName, days: 0, byProcess: {}, completed: 0, targets: 0, missingTarget: false };
            var user = users[key], completed = +row.CompletedCount || 0, target = targetNumber(row.DailyTarget);
            user.days = Math.max(user.days, +row.DaysWorked || 0);
            user.byProcess[row.ProcessID] = completed; user.completed += completed;
            if (completed > 0 && target > 0) user.targets += target;
            else if (completed > 0) user.missingTarget = true;
        });
        var list = Object.keys(users).map(function (key) {
            var user = users[key], denominator = user.days * user.targets;
            user.denominator = denominator;
            user.percent = !user.missingTarget && denominator > 0 ? user.completed / denominator * 100 : null;
            return user;
        }).filter(function (user) { return user.completed > 0 || user.days > 0; }).sort(function (a, b) {
            return (b.percent == null ? -1 : b.percent) - (a.percent == null ? -1 : a.percent) || a.name.localeCompare(b.name);
        });
        productivityHead.innerHTML = '<tr><th>Rank</th><th>Reviewer</th><th>Days Worked</th>' + processes.map(function (process) { return '<th>' + esc(process.ProcessName) + '</th>'; }).join('') + '<th>% Target</th></tr>';
        productivityRows.innerHTML = list.map(function (user, index) {
            var value = user.percent == null ? '—' : user.percent.toFixed(1) + '%';
            var css = user.percent == null ? '' : user.percent >= 100 ? 'good' : user.percent >= 80 ? 'watch' : 'low';
            return '<tr><td class="snd-rank">' + (index + 1) + '</td><td>' + esc(user.name) + '</td><td>' + user.days + '</td>' + processes.map(function (process) { return '<td>' + (user.byProcess[process.ProcessID] || 0) + '</td>'; }).join('') + '<td class="snd-achievement ' + css + '">' + value + '</td></tr>';
        }).join('') || '<tr><td colspan="' + (processes.length + 4) + '" class="olt-empty">No completed production found for this period.</td></tr>';
        var processTotals = {};
        processes.forEach(function (process) { processTotals[process.ProcessID] = list.reduce(function (sum, user) { return sum + (+user.byProcess[process.ProcessID] || 0); }, 0); });
        var aggregateDenominator = list.reduce(function (sum, user) { return sum + (user.missingTarget ? 0 : user.denominator); }, 0);
        var hasMissingTarget = list.some(function (user) { return user.missingTarget; });
        var aggregatePercent = !hasMissingTarget && aggregateDenominator > 0 ? total(list, 'completed') / aggregateDenominator * 100 : null;
        productivityFoot.innerHTML = '<tr><td colspan="2">Total</td><td>' + total(list, 'days') + '</td>' + processes.map(function (process) { return '<td>' + processTotals[process.ProcessID] + '</td>'; }).join('') + '<td class="snd-achievement">' + (aggregatePercent == null ? '--' : aggregatePercent.toFixed(1) + '%') + '</td></tr>';
    }

    window.loadDailyProduction = function () { getData('daily').then(renderDailyProduction).catch(ignore); };

    window.loadHoldReasonsManager = function () {
        OLT.call(page, 'GetHoldReasons').then(function (rows) {
            holdReasonRows.innerHTML = rows.length ? rows.map(function (row, index) {
                var active = row.IsActive === true || row.IsActive === 1 || row.IsActive === '1';
                return '<tr><td class="snd-rank">' + (index + 1) + '</td><td>' + esc(row.ReasonText) + '</td><td><span class="hold-status ' + (active ? 'active' : 'inactive') + '">' + (active ? 'Active' : 'Inactive') + '</span></td><td><button type="button" class="olt-btn secondary" onclick="setHoldReasonActive(' + (+row.HoldReasonID) + ',' + (!active) + ')">' + (active ? 'Deactivate' : 'Activate') + '</button></td></tr>';
            }).join('') : '<tr><td colspan="4" class="olt-empty">No Hold Reasons configured.</td></tr>';
            holdReasonTotal.textContent = rows.length;
        }).catch(showError);
    };

    window.saveHoldReason = function () {
        var reason = String(newHoldReason.value || '').trim();
        if (!reason) { OLT.alert('Please enter a Hold Reason.', true); return; }
        OLT.call(page, 'SaveHoldReason', { reasonText: reason }).then(function () { newHoldReason.value = ''; OLT.alert('Hold Reason saved successfully.'); loadHoldReasonsManager(); }).catch(showError);
    };

    window.setHoldReasonActive = function (holdReasonId, isActive) {
        var action = isActive ? 'activate' : 'deactivate';
        if (!window.confirm('Are you sure you want to ' + action + ' this Hold Reason?')) return;
        OLT.call(page, 'SetHoldReasonActive', { holdReasonId: +holdReasonId, isActive: !!isActive }).then(function () { OLT.alert('Hold Reason updated successfully.'); loadHoldReasonsManager(); }).catch(showError);
    };

    function renderDailyProduction(data) {
        var processes = data.table0 || [], rows = data.table5 || [];
        dailyProcessSections.innerHTML = processes.map(function (process) {
            var people = rows.filter(function (row) { return String(row.ProcessID) === String(process.ProcessID) && +row.TotalCount > 0; });
            var totals = { done: 0, progress: 0, pending: 0, all: 0 };
            people.forEach(function (row) { totals.done += +row.DoneCount || 0; totals.progress += +row.InProcessCount || 0; totals.pending += +row.PendingCount || 0; totals.all += +row.TotalCount || 0; });
            var body = people.map(function (row) { return '<tr><td>' + esc(row.UserName) + '</td><td>' + row.DoneCount + '</td><td>' + row.InProcessCount + '</td><td>' + row.PendingCount + '</td><td>' + row.TotalCount + '</td></tr>'; }).join('') || '<tr><td colspan="5" class="olt-empty">No activity in the selected period.</td></tr>';
            return '<div class="snd-process-section"><h4>' + esc(process.ProcessName) + '</h4><div class="olt-table-wrap"><table class="olt-table"><thead><tr><th>Reviewer</th><th>Done</th><th>In Process</th><th>Pending</th><th>Total</th></tr></thead><tbody>' + body + '</tbody><tfoot><tr><td>Total</td><td>' + totals.done + '</td><td>' + totals.progress + '</td><td>' + totals.pending + '</td><td>' + totals.all + '</td></tr></tfoot></table></div></div>';
        }).join('') || '<div class="snd-empty">No loan-based processes are configured for this project.</div>';
    }

    function targetNumber(value) { var parsed = parseFloat(String(value == null ? '' : value).replace(/[^0-9.\-]/g, '')); return isNaN(parsed) ? 0 : parsed; }
    function total(rows, field) { return rows.reduce(function (sum, row) { return sum + (+row[field] || 0); }, 0); }
    function ignore() { }
}());
