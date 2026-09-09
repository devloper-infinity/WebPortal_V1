window.IHMS = (function () {
    var pendingRequests = 0;
    function esc(value) { return $('<div>').text(value == null ? '' : value).html(); }
    function parse(value) { return typeof value === 'string' ? JSON.parse(value) : value; }
    function date(value) {
        if (!value) return '—';
        var match = /\/Date\((-?\d+)/.exec(value), result = match ? new Date(+match[1]) : new Date(value);
        return isNaN(result.getTime()) ? esc(value) : result.toLocaleString('en-GB', { day: '2-digit', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit' });
    }
    function display(value) { return typeof value === 'string' && /^\/Date\(/.test(value) ? date(value) : esc(value); }
    function busy(show) {
        pendingRequests = Math.max(0, pendingRequests + (show ? 1 : -1));
        var overlay = $('#ihms-loading');
        if (!overlay.parent().is('body')) overlay.appendTo(document.body);
        overlay.css('display', pendingRequests ? 'flex' : 'none').attr('aria-hidden', pendingRequests ? 'false' : 'true');
    }
    function toast(message, bad) {
        var item = $('<div class="toast-msg">').text(message).css('background', bad ? '#a52b2b' : '#20384a').appendTo('.ihms');
        setTimeout(function () { item.fadeOut(function () { item.remove(); }); }, 3500);
    }
    function post(url, parameters, done) {
        busy(true);
        $.ajax({ type: 'POST', url: url, contentType: 'application/json; charset=utf-8', data: JSON.stringify(parameters || {}), dataType: 'json' })
            .done(function (response) { try { done(parse(response.d)); } catch (error) { toast(error.message, true); } })
            .fail(function (response) { var message = 'Unable to complete the request.'; try { var error = JSON.parse(response.responseText); message = error.Message || error.ExceptionMessage || message; } catch (ignore) { } toast(message.replace(/^System\.[^:]+:\s*/, ''), true); })
            .always(function () { busy(false); });
    }
    function table(selector, rows, columns) {
        var html = '<thead><tr>';
        columns.forEach(function (column) { html += '<th>' + esc(column[0]) + '</th>'; });
        html += '</tr></thead><tbody>';
        (rows || []).forEach(function (row) {
            html += '<tr>';
            columns.forEach(function (column) { var value = row[column[1]]; html += '<td>' + (column[2] ? column[2](value, row) : display(value)) + '</td>'; });
            html += '</tr>';
        });
        $(selector).html(html + '</tbody>');
    }
    function nav() { return '<div class="nav"><a href="Dashboard.aspx">Dashboard</a><a href="MyTickets.aspx">My tickets</a><a href="MyHelpdeskTickets.aspx">My requests</a><a href="TicketApproval.aspx">Approvals</a><a href="TicketReport.aspx">Report</a><a href="HelpdeskPerformance.aspx">Performance</a><a href="Administration.aspx">Admin</a></div>'; }
    function shell(title, subtitle) { $('#ihms-title').text(title); $('#ihms-sub').text(subtitle || ''); $('#ihms-nav').html(nav()); }
    function ticketLink(value, row) { return '<a href="TicketDetails.aspx?id=' + row.TicketID + '">' + esc(value) + '</a>'; }
    function status(value) { return '<span class="badge-status">' + esc(value) + '</span>'; }
    function priority(value) { return '<span class="badge-priority">' + esc(value) + '</span>'; }
    return { esc: esc, date: date, post: post, table: table, toast: toast, shell: shell, ticketLink: ticketLink, status: status, priority: priority };
})();
