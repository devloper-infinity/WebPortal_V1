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
                renderSummary(result.Summary || []);
                renderProjects(result.Projects);
            },
            error: function () { showMessage('Unable to fetch billing details.', true); },
            complete: function () { setLoading(false); }
        });
    }

    function renderSummary(projects) {
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
        $('#blankBillingModalTitle').text(title);
        $('#blankBillingModalContext').text(projectName + (dealNo ? ' • Deal ' + dealNo : ' • All deals'));
        $('#chkSelectAllLoans').prop('checked', false);
        $('#txtBulkRemark').val('');
        $('#remarkMessage').hide();
        $('.bulk-remark-bar').toggle(!!dealNo);
        $('#blankBillingModal').modal('show');
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
            $('<div/>', { 'class': 'tab-pane fade billing-tab-pane' + (active ? ' show active' : ''), id: paneId, role: 'tabpanel' })
                .append($('<div/>', { 'class': 'billing-table-wrap' }).append($table)).appendTo($content);
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
