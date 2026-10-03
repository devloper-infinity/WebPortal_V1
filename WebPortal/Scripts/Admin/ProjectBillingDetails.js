(function ($) {
    'use strict';

    var tables = [];
    var currentResult = null;

    $(function () {
        $('#btnGenerateBilling').on('click', loadBillingDetails);
        $('#billingTabs').on('shown.bs.tab', 'a[data-toggle="tab"]', function () {
            $.fn.dataTable.tables({ visible: true, api: true }).columns.adjust();
        });
        $('#billingSummaryContent').on('click', '.project-summary-toggle', toggleProjectDetails);
        $('#billingSummaryContent').on('click', '.summary-count', handleCountClick);
        $('#blankLoansBody').on('click', '.save-loan-remark', saveSingleRemark);
        $('#chkSelectAllLoans').on('change', function () {
            $('#blankLoansBody .loan-select').prop('checked', this.checked);
        });
        $('#blankLoansBody').on('change', '.loan-select', syncSelectAll);
        $('#btnSaveBulkRemark').on('click', saveBulkRemarks);
        $('#billingTabContent').on('click', '.export-project-data', exportProjectData);
        loadBillingDetails();
    });

    function loadBillingDetails() {
        var month = $('#ddlMonth').val();
        var year = parseInt($('#ddlYear').val(), 10);
        if (!month || !year) {
            showMessage('Please select Month and Year.', true);
            return;
        }

        setLoading(true);
        clearResults();
        $.ajax({
            type: 'POST',
            url: 'ProjectBillingDetails.aspx/GetBillingDetails',
            data: JSON.stringify({ month: month, year: year }),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (response) {
                var result = response.d;
                if (!result || !result.Success) {
                    showMessage(result && result.Message ? result.Message : 'Unable to fetch billing details.', true);
                    return;
                }
                if (!result.Projects || !result.Projects.length) {
                    showMessage(result.Message || 'No billing records found for selected Month and Year.', false);
                    return;
                }
                currentResult = result;
                if (result.BillingMode === 'FTE') $('#billingSummary').hide();
                else renderSummary(result.Summary || []);
                renderProjects(result.Projects);
            },
            error: function () { showMessage('Unable to fetch billing details.', true); },
            complete: function () { setLoading(false); }
        });
    }

    function renderSummary(projects) {
        if (isProjectOnlyMode()) {
            renderProjectOnlySummary(projects);
            return;
        }
        $('.summary-title-row > span:first').text('Billing Readiness Summary');
        $('.summary-hint').text('Click a project to view deal-wise counts. Action-required counts open the affected loans.').show();
        var $container = $('#billingSummaryContent').empty();
        $.each(projects, function (index, project) {
            var $card = $('<div/>', { 'class': 'project-summary-card' });
            var $header = $('<div/>', { 'class': 'project-summary-row project-summary-main' });
            $('<button/>', {
                type: 'button',
                'class': 'project-summary-toggle',
                'data-target': 'deal-summary-' + index,
                'aria-expanded': 'false',
                text: project.ProjectName
            }).prepend($('<span/>', { 'class': 'expand-icon', text: '+' })).appendTo($header);
            appendCounts($header, project, project.ProjectID, '', index);
            $card.append($header);

            var $details = $('<div/>', { id: 'deal-summary-' + index, 'class': 'deal-summary-details' });
            var $table = $('<table/>', { 'class': 'table table-sm deal-summary-table' });
            $table.append('<thead><tr><th>Deal #</th><th>Total Loans</th><th>Dispatched</th><th>Pending</th><th>Blank Billing Parameters</th><th>Status</th></tr></thead>');
            var $body = $('<tbody/>');
            $.each(project.Deals || [], function (_, deal) {
                var $row = $('<tr/>');
                $('<td/>').text(deal.DealNo).appendTo($row);
                appendDealCounts($row, deal, project.ProjectID, project.ProjectName, index);
                $body.append($row);
            });
            $details.append($table.append($body));
            $card.append($details);
            $container.append($card);
        });
        $('#billingSummary').show();
    }

    function isProjectOnlyMode() {
        return currentResult && (currentResult.BillingMode === 'Commitment' || currentResult.BillingMode === 'Freight' || currentResult.BillingMode === 'Valuation');
    }

    function renderProjectOnlySummary(projects) {
        var $container = $('#billingSummaryContent').empty();
        $('.summary-title-row > span:first').text('Project-wise ' + currentResult.BillingMode + ' Summary');
        $('.summary-hint').text(currentResult.BillingMode === 'Freight' ? 'On Hold excludes dispatched and cancelled record quantities.' : 'On Hold records do not have a Dispatched Date.').show();
        $.each(projects, function (index, project) {
            var rowClass = currentResult.BillingMode === 'Freight' ? 'freight-summary-row' : 'commitment-summary-row';
            var $row = $('<div/>', { 'class': 'project-summary-row project-summary-main ' + rowClass });
            $('<div/>', { 'class': 'commitment-project-name', text: project.ProjectName }).appendTo($row);
            var metrics = [
                ['Total', project.TotalLoans, 'total'],
                ['Dispatched', project.DispatchedLoans, 'dispatched'],
            ];
            if (currentResult.BillingMode === 'Freight') metrics.push(['Cancelled', project.CancelledLoans || 0, 'cancelled']);
            metrics.push(['On Hold', project.PendingLoans, 'onhold']);
            $.each(metrics, function (_, item) {
                var $cell = $('<div/>', { 'class': 'summary-metric' });
                $('<span/>', { 'class': 'summary-metric-label', text: item[0] }).appendTo($cell);
                createCountButton(item[1], item[2], project.ProjectID, '', project.ProjectName, index).appendTo($cell);
                $row.append($cell);
            });
            $('<div/>', { 'class': 'summary-status-cell' }).append(statusBadge(project.Status)).appendTo($row);
            $container.append($('<div/>', { 'class': 'project-summary-card' }).append($row));
        });
        $('#billingSummary').show();
    }

    function appendCounts($row, counts, projectId, dealNo, projectIndex) {
        var items = [
            ['Total Loans', counts.TotalLoans, 'total'],
            ['Dispatched', counts.DispatchedLoans, 'dispatched'],
            ['Pending', counts.PendingLoans, 'pending'],
            ['Blank Billing Parameters', counts.BlankBillingParameters, 'blank']
        ];
        $.each(items, function (_, item) {
            var $cell = $('<div/>', { 'class': 'summary-metric' });
            $('<span/>', { 'class': 'summary-metric-label', text: item[0] }).appendTo($cell);
            createCountButton(item[1], item[2], projectId, dealNo, counts.ProjectName, projectIndex).appendTo($cell);
            $row.append($cell);
        });
        $('<div/>', { 'class': 'summary-status-cell' }).append(statusBadge(counts.Status)).appendTo($row);
    }

    function appendDealCounts($row, deal, projectId, projectName, projectIndex) {
        $.each([
            [deal.TotalLoans, 'total'], [deal.DispatchedLoans, 'dispatched'],
            [deal.PendingLoans, 'pending'], [deal.BlankBillingParameters, 'blank']
        ], function (_, item) {
            $('<td/>').append(createCountButton(item[0], item[1], projectId, deal.DealNo, projectName, projectIndex)).appendTo($row);
        });
        $('<td/>').append(statusBadge(deal.Status)).appendTo($row);
    }

    function createCountButton(value, category, projectId, dealNo, projectName, projectIndex) {
        return $('<button/>', {
            type: 'button',
            'class': 'summary-count count-' + category,
            'data-category': category,
            'data-project-id': projectId,
            'data-project-name': projectName || '',
            'data-project-index': projectIndex,
            'data-deal': dealNo || '',
            text: value
        });
    }

    function statusBadge(status) {
        var css = status === 'Complete' ? 'complete' : (status === 'Action Required' ? 'action' : 'pending');
        return $('<span/>', { 'class': 'billing-status status-' + css, text: status });
    }

    function toggleProjectDetails() {
        var $button = $(this);
        var $details = $('#' + $button.data('target'));
        var open = !$details.is(':visible');
        $details.slideToggle(140);
        $button.attr('aria-expanded', open ? 'true' : 'false').find('.expand-icon').text(open ? '−' : '+');
    }

    function handleCountClick(event) {
        event.stopPropagation();
        var $button = $(this);
        var category = $button.data('category');
        var count = parseInt($button.text(), 10) || 0;
        if (category === 'blank') {
            if (count > 0) openBlankLoans($button.data('project-id'), String($button.data('deal') || ''), $button.data('project-name'));
            return;
        }
        if (category === 'pending') {
            if (count > 0) openLoanPopup('PendingLoans', $button.data('project-id'), String($button.data('deal') || ''), $button.data('project-name'), 'Pending Loans');
            return;
        }
        if (category === 'onhold') {
            if (count > 0) openLoanPopup('PendingLoans', $button.data('project-id'), '', $button.data('project-name'), 'On Hold - Dispatched Date Missing');
            return;
        }
        activateProjectTab(parseInt($button.data('project-index'), 10), String($button.data('deal') || ''));
    }

    function activateProjectTab(projectIndex, dealNo) {
        $('#billingTabs a[href="#billing-project-' + projectIndex + '"]').tab('show');
        if (tables[projectIndex]) tables[projectIndex].search(dealNo).draw();
        $('html,body').animate({ scrollTop: $('#billingResults').offset().top - 15 }, 180);
    }

    function openBlankLoans(projectId, dealNo, projectName) {
        openLoanPopup('BlankLoans', projectId, dealNo, projectName, 'Loans With Blank Billing Parameters');
    }

    function openLoanPopup(sourceName, projectId, dealNo, projectName, title) {
        var loans = $.grep((currentResult && currentResult[sourceName]) || [], function (loan) {
            return loan.ProjectID === projectId && (!dealNo || loan.DealNo === dealNo);
        });
        var projectOnlyMode = isProjectOnlyMode();
        if (projectOnlyMode) renderProjectOnlyPopup(projectId, loans);
        else renderStandardLoanPopup(loans);
        $('#blankBillingModalTitle').text(title);
        $('#blankBillingModalContext').text(projectName + (projectOnlyMode ? ' • Project records' : (dealNo ? ' • Deal ' + dealNo : ' • All deals')));
        $('#chkSelectAllLoans').prop('checked', false);
        $('#txtBulkRemark').val('');
        $('#remarkMessage').hide();
        $('.bulk-remark-bar').toggle(!projectOnlyMode && !!dealNo);
        $('#blankBillingModal').modal('show');
    }

    function renderStandardLoanPopup(loans) {
        $('.blank-loans-table').removeClass('commitment-loans-table').find('thead').html('<tr><th>Select</th><th>Project</th><th>Deal #</th><th>Loan #</th><th>Dispatch Date</th><th>Blank Parameter(s)</th><th>Existing Remark</th><th>Remark</th><th>Action</th></tr>');
        var $body = $('#blankLoansBody').empty();
        $.each(loans, function (_, loan) {
            var $row = $('<tr/>').data('loan', loan);
            $('<td/>').append($('<input/>', { type: 'checkbox', 'class': 'loan-select' })).appendTo($row);
            $('<td/>').text(loan.ProjectName).appendTo($row);
            $('<td/>').text(loan.DealNo).appendTo($row);
            $('<td/>').text(loan.LoanNo).appendTo($row);
            $('<td/>').text(loan.DispatchDate).appendTo($row);
            var $blanks = $('<td/>');
            $.each((loan.BlankParameters || '').split(','), function (_, name) {
                if ($.trim(name)) $('<span/>', { 'class': 'blank-parameter', text: $.trim(name) }).appendTo($blanks);
            });
            $row.append($blanks);
            $('<td/>', { 'class': 'existing-remark', text: loan.Remark ? loan.Remark + (loan.HasValidRemark ? ' (Valid)' : ' (Condition changed)') : '—' }).appendTo($row);
            $('<td/>').append($('<input/>', { type: 'text', 'class': 'form-control loan-remark', maxlength: 1000, value: loan.Remark || '' })).appendTo($row);
            $('<td/>').append($('<button/>', { type: 'button', 'class': 'btn btn-sm btn-billing save-loan-remark', text: 'Save' })).appendTo($row);
            $body.append($row);
        });
    }

    function renderProjectOnlyPopup(projectId, loans) {
        var project = $.grep((currentResult && currentResult.Projects) || [], function (item) { return item.ProjectID === projectId; })[0];
        var columns = project ? (project.Columns || []) : [];
        var $table = $('.blank-loans-table').addClass('commitment-loans-table');
        var $header = $('<tr/>');
        $.each(columns, function (_, column) { $('<th/>').text(column).appendTo($header); });
        $('<th/>').text('Existing Remark').appendTo($header);
        $('<th/>').text('Remark').appendTo($header);
        $('<th/>').text('Action').appendTo($header);
        $table.find('thead').empty().append($header);

        var $body = $('#blankLoansBody').empty();
        $.each(loans, function (_, loan) {
            var $row = $('<tr/>').data('loan', loan);
            var missingName = $.trim(loan.BlankParameters || '').toLowerCase();
            $.each(columns, function (_, column) {
                var value = loan.RowValues && loan.RowValues[column] != null ? loan.RowValues[column] : '';
                var isMissing = $.trim(column).toLowerCase() === missingName && !$.trim(String(value));
                var $cell = $('<td/>', { text: value });
                if (isMissing) $cell.addClass('missing-project-value').empty().append($('<span/>', { 'class': 'blank-parameter', text: 'Missing' }));
                $cell.appendTo($row);
            });
            $('<td/>', { 'class': 'existing-remark', text: loan.Remark ? loan.Remark + (loan.HasValidRemark ? ' (Valid)' : ' (Condition changed)') : '—' }).appendTo($row);
            $('<td/>').append($('<input/>', { type: 'text', 'class': 'form-control loan-remark', maxlength: 1000, value: loan.Remark || '' })).appendTo($row);
            $('<td/>').append($('<button/>', { type: 'button', 'class': 'btn btn-sm btn-billing save-loan-remark', text: 'Save' })).appendTo($row);
            $body.append($row);
        });
    }

    function saveSingleRemark() {
        var $row = $(this).closest('tr');
        var loan = $row.data('loan');
        var remark = $.trim($row.find('.loan-remark').val());
        if (!remark) { showRemarkMessage('Remark is mandatory.', true); return; }
        saveRemarks([{ ProjectID: loan.ProjectID, DealNo: loan.DealNo, LoanNo: loan.LoanNo, BillingMonth: loan.BillingMonth, PendingSignature: loan.PendingSignature }], remark, false);
    }

    function saveBulkRemarks() {
        var remark = $.trim($('#txtBulkRemark').val());
        var items = [];
        $('#blankLoansBody .loan-select:checked').each(function () {
            var loan = $(this).closest('tr').data('loan');
            items.push({ ProjectID: loan.ProjectID, DealNo: loan.DealNo, LoanNo: loan.LoanNo, BillingMonth: loan.BillingMonth, PendingSignature: loan.PendingSignature });
        });
        if (!items.length) { showRemarkMessage('Select at least one loan.', true); return; }
        if (!remark) { showRemarkMessage('Remark is mandatory.', true); return; }
        if (!window.confirm('Apply this remark to ' + items.length + ' selected loan(s)?')) return;
        saveRemarks(items, remark, true);
    }

    function saveRemarks(items, remark) {
        setLoading(true);
        $.ajax({
            type: 'POST',
            url: 'ProjectBillingDetails.aspx/SaveBillingRemarks',
            data: JSON.stringify({ items: items, remark: remark }),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (response) {
                var result = response.d;
                if (!result || !result.Success) { showRemarkMessage(result && result.Message ? result.Message : 'Unable to save remark.', true); return; }
                showRemarkMessage(result.Message, false);
                window.setTimeout(function () { $('#blankBillingModal').modal('hide'); loadBillingDetails(); }, 650);
            },
            error: function () { showRemarkMessage('Unable to save remark.', true); },
            complete: function () { setLoading(false); }
        });
    }

    function syncSelectAll() {
        var total = $('#blankLoansBody .loan-select').length;
        $('#chkSelectAllLoans').prop('checked', total > 0 && $('#blankLoansBody .loan-select:checked').length === total);
    }

    function renderProjects(projects) {
        var $tabs = $('#billingTabs');
        var $content = $('#billingTabContent');
        $.each(projects, function (index, project) {
            var paneId = 'billing-project-' + index;
            var active = index === 0;
            $('<li/>', { 'class': 'nav-item', role: 'presentation' }).append($('<a/>', {
                'class': 'nav-link' + (active ? ' active' : ''), href: '#' + paneId, role: 'tab',
                'data-toggle': 'tab', 'aria-selected': active ? 'true' : 'false', text: project.ProjectName || ('Project ' + (index + 1))
            })).appendTo($tabs);
            var $table = $('<table/>', { id: 'billing-table-' + index, 'class': 'display nowrap table table-bordered table-sm billing-table' });
            var $pane = $('<div/>', { 'class': 'tab-pane fade billing-tab-pane' + (active ? ' show active' : ''), id: paneId, role: 'tabpanel' });
            if (currentResult && currentResult.BillingMode === 'FTE') {
                var $projectSummary = $('<div/>', { 'class': 'fte-project-summary' });
                $.each(project.SummaryItems || [], function (_, item) {
                    $('<div/>', { 'class': 'fte-summary-item' })
                        .append($('<span/>', { text: item.Label }))
                        .append($('<strong/>', { text: item.Value }))
                        .appendTo($projectSummary);
                });
                $pane.append($projectSummary);
                if (project.ReportTitle) $pane.append($('<div/>', { 'class': 'fte-report-title', text: project.ReportTitle }));
            }
            var $toolbar = $('<div/>', { 'class': 'billing-table-toolbar' });
            $('<button/>', {
                type: 'button',
                'class': 'btn btn-sm btn-billing export-project-data',
                'data-project-index': index,
                text: 'Export CSV'
            }).appendTo($toolbar);
            $pane.append($toolbar).append($('<div/>', { 'class': 'billing-table-wrap' }).append($table)).appendTo($content);
            var columns = $.map(project.Columns || [], function (name, columnIndex) {
                return { title: name, data: columnIndex, render: $.fn.dataTable.render.text() };
            });
            tables.push($table.DataTable({
                data: project.Rows || [], columns: columns, autoWidth: false, scrollX: true, scrollCollapse: true,
                pageLength: 25, lengthMenu: [[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']], order: [],
                language: { emptyTable: 'No billing records found for this project.' }
            }));
        });
        $('#billingResults').show();
        window.setTimeout(function () { $.fn.dataTable.tables({ visible: true, api: true }).columns.adjust(); }, 0);
    }

    function exportProjectData() {
        var projectIndex = parseInt($(this).data('project-index'), 10);
        var project = currentResult && currentResult.Projects ? currentResult.Projects[projectIndex] : null;
        var table = tables[projectIndex];
        if (!project || !table) return;

        var rows = table.rows({ search: 'applied' }).data().toArray();
        if (!rows.length) {
            window.alert('No filtered records are available to export.');
            return;
        }

        var csv = [toCsvRow(project.Columns || [])];
        $.each(rows, function (_, row) { csv.push(toCsvRow(row)); });
        var blob = new Blob(['\ufeff' + csv.join('\r\n')], { type: 'text/csv;charset=utf-8;' });
        var fileName = safeFileName(project.ProjectName || ('Project_' + (projectIndex + 1))) +
            '_Billing_' + safeFileName($('#ddlMonth').val() + '-' + $('#ddlYear').val()) + '.csv';

        if (window.navigator.msSaveBlob) {
            window.navigator.msSaveBlob(blob, fileName);
            return;
        }
        var url = window.URL.createObjectURL(blob);
        var link = document.createElement('a');
        link.href = url;
        link.download = fileName;
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        window.setTimeout(function () { window.URL.revokeObjectURL(url); }, 0);
    }

    function toCsvRow(values) {
        return $.map(values || [], function (value) {
            var text = value == null ? '' : String(value);
            if (/^[=+\-@]/.test(text)) text = "'" + text;
            return '"' + text.replace(/"/g, '""') + '"';
        }).join(',');
    }

    function safeFileName(value) {
        return String(value || '').replace(/[\\/:*?"<>|]+/g, '_').replace(/\s+/g, '_');
    }

    function clearResults() {
        $.each(tables, function (_, table) { if (table) table.destroy(); });
        tables = [];
        currentResult = null;
        $('#billingTabs,#billingTabContent,#billingSummaryContent').empty();
        $('#billingResults,#billingSummary,#billingMessage').hide();
    }
    function showMessage(text, error) { $('#billingResults,#billingSummary').hide(); $('#billingMessage').toggleClass('billing-error', !!error).text(text).show(); }
    function showRemarkMessage(text, error) { $('#remarkMessage').toggleClass('is-error', !!error).text(text).show(); }
    function setLoading(show) { $('#btnGenerateBilling,#btnSaveBulkRemark,.save-loan-remark').prop('disabled', show); $('#billingLoadingOverlay').toggleClass('is-visible', show).attr('aria-hidden', show ? 'false' : 'true'); }
}(jQuery));
