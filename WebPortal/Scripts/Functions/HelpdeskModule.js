(function (window, $) {
    'use strict';
    var state = { ticketId: 0, ticket: null, agents: [], configuration: { categories: [], sla: [], agents: [] } };

    function endpoint(method) {
        return window.location.pathname.substring(window.location.pathname.lastIndexOf('/') + 1) + '/' + method;
    }

    function api(method, payload, done) {
        $.ajax({
            url: endpoint(method), type: 'POST', data: JSON.stringify(payload || {}),
            contentType: 'application/json; charset=utf-8', dataType: 'json',
            success: function (response) { done(null, response.d); },
            error: function (xhr) { done((xhr.responseJSON && xhr.responseJSON.Message) || 'The request could not be completed.'); }
        });
    }

    function parse(value) { return value ? JSON.parse(value) : []; }
    function text(value) { return $('<div/>').text(value === null || value === undefined ? '' : value).html(); }
    function bool(value) { return value === true || value === 'True' || value === 'true' || value === 1; }
    function date(value) {
        if (!value) return '—';
        var match = /Date\((\d+)\)/.exec(value), d = match ? new Date(parseInt(match[1], 10)) : new Date(value);
        return isNaN(d.getTime()) ? text(value) : d.toLocaleString();
    }
    function badge(value) { return '<span class="hd-badge ' + text(value).replace(/\s/g, '-') + '">' + text(value) + '</span>'; }
    function show(message, kind) { $('#hd-alert').removeClass('error success').addClass(kind || 'error').text(message); }
    function clearAlert() { $('#hd-alert').removeClass('error success').empty(); }
    function query(name) { return new URLSearchParams(window.location.search).get(name); }

    function loadHome() {
        api('GetBootstrap', {}, function (error, raw) {
            if (error) return show(error);
            var tables = parse(raw), categories = tables[0] || [], permissions = (tables[1] || [])[0] || {};
            $.each(categories, function (_, category) {
                $('#hd-category').append($('<option/>').val(category.CategoryID).text(category.DepartmentName + ' — ' + category.CategoryName));
            });
            if (bool(permissions.IsAgent)) $('#hd-workbench-link').show();
            if (bool(permissions.IsAdmin)) $('#hd-admin-link').show();
        });
        loadMyTickets();
    }

    function loadMyTickets() {
        api('GetMyTickets', { status: $('#hd-my-status').val() || '' }, function (error, raw) {
            if (error) return show(error);
            var rows = parse(raw), html = '';
            $.each(rows, function (_, row) {
                html += '<tr><td><a class="hd-link" href="Ticket.aspx?id=' + row.TicketID + '">' + text(row.TicketNo) + '</a><br><small>' + text(row.CategoryName) + '</small></td>' +
                    '<td>' + text(row.Subject) + '</td><td>' + badge(row.PriorityCode) + '</td><td>' + badge(row.StatusCode) + '</td><td>' + date(row.UpdatedOn) + '</td></tr>';
            });
            $('#hd-my-tickets').html(html || '<tr><td colspan="5" class="hd-empty">No tickets found.</td></tr>');
        });
    }

    function createTicket() {
        clearAlert();
        var payload = {
            categoryId: parseInt($('#hd-category').val(), 10) || 0, subject: $.trim($('#hd-subject').val()),
            description: $.trim($('#hd-description').val()), location: $.trim($('#hd-location').val()),
            assetReference: $.trim($('#hd-asset').val()), impact: $('#hd-impact').val(),
            urgency: $('#hd-urgency').val(), onBehalfOfId: 0
        };
        if (!payload.categoryId || !payload.subject || !payload.description) return show('Category, subject, and description are required.');
        api('CreateTicket', payload, function (error, result) {
            if (error) return show(error);
            result = parseInt(result, 10);
            if (result === -2) return show('This category requires approval, but no reporting manager/approver is configured.');
            if (result <= 0) return show('The ticket could not be created.');
            window.location.href = 'Ticket.aspx?id=' + result;
        });
    }

    function loadQueue() {
        api('GetQueue', { scope: $('#hd-scope').val() || 'All', status: $('#hd-queue-status').val() || '', priority: $('#hd-queue-priority').val() || '' }, function (error, raw) {
            if (error) return show(error);
            var rows = parse(raw), html = '', unassigned = 0, overdue = 0, critical = 0;
            $.each(rows, function (_, row) {
                if (!row.AssignedTo) unassigned++; if (bool(row.IsOverdue)) overdue++; if (row.PriorityCode === 'Critical') critical++;
                var select = '<select class="form-control hd-agent-select" data-ticket="' + row.TicketID + '"><option value="">Assign...</option>';
                $.each(state.agents, function (_, agent) { select += '<option value="' + agent.EmployeeID + '"' + (agent.EmployeeID == row.AssignedTo ? ' selected' : '') + '>' + text(agent.DisplayName) + '</option>'; });
                select += '</select>';
                html += '<tr><td><a class="hd-link" href="Ticket.aspx?id=' + row.TicketID + '">' + text(row.TicketNo) + '</a><br><small>' + date(row.CreatedOn) + '</small></td>' +
                    '<td><small>' + text(row.CategoryName) + '</small><br>' + text(row.Subject) + '</td><td>' + badge(row.PriorityCode) + '</td><td>' + badge(row.StatusCode) + '</td>' +
                    '<td class="' + (bool(row.IsOverdue) ? 'hd-overdue' : '') + '">' + date(row.ResolutionDueOn) + '</td><td>' + select + '</td>' +
                    '<td><button class="hd-btn hd-btn-muted" onclick="Helpdesk.assign(' + row.TicketID + ')">Save</button></td></tr>';
            });
            $('#hd-queue').html(html || '<tr><td colspan="7" class="hd-empty">No tickets match the selected queue.</td></tr>');
            $('#hd-stat-total').text(rows.length); $('#hd-stat-unassigned').text(unassigned); $('#hd-stat-overdue').text(overdue); $('#hd-stat-critical').text(critical);
        });
    }

    function loadWorkbench() {
        api('GetAgents', {}, function (error, raw) {
            if (error) return show(error);
            state.agents = parse(raw); loadQueue();
        });
    }

    function assign(ticketId) {
        var agent = parseInt($('.hd-agent-select[data-ticket="' + ticketId + '"]').val(), 10) || 0;
        if (!agent) return show('Select an agent first.');
        api('Assign', { ticketId: ticketId, agentEmployeeId: agent }, function (error, result) {
            if (error || parseInt(result, 10) <= 0) return show(error || 'Assignment was not permitted.');
            show('Ticket assigned.', 'success'); loadQueue();
        });
    }

    function actionButton(label, status, danger) {
        return '<button type="button" class="hd-btn ' + (danger ? 'hd-btn-danger' : 'hd-btn-muted') + '" onclick="Helpdesk.transition(\'' + status + '\')">' + label + '</button> ';
    }

    function renderTicketActions(ticket) {
        var html = '', status = ticket.StatusCode, isStaff = bool(ticket.IsStaff), current = parseInt(ticket.CurrentEmployeeID, 10);
        if (status === 'Pending Approval' && current === parseInt(ticket.ApproverID, 10)) {
            html += '<div class="hd-field"><label>Approval comment</label><textarea id="hd-action-comment" class="form-control"></textarea></div><div class="hd-actions">' +
                '<button class="hd-btn hd-btn-danger" onclick="Helpdesk.approval(\'Rejected\')">Reject</button><button class="hd-btn hd-btn-primary" onclick="Helpdesk.approval(\'Approved\')">Approve</button></div>';
        } else if (isStaff) {
            html += '<div class="hd-field"><label>Work note / resolution *</label><textarea id="hd-action-comment" class="form-control"></textarea></div><div class="hd-actions" style="flex-wrap:wrap">';
            if (status === 'New' || status === 'Reopened' || status === 'Assigned') html += actionButton('Start work', 'In Progress');
            if (status === 'Assigned' || status === 'In Progress' || status.indexOf('Waiting') === 0) {
                html += actionButton('Wait for user', 'Waiting for User') + actionButton('Wait for vendor', 'Waiting for Vendor') + actionButton('Resolve', 'Resolved');
            }
            html += actionButton('Cancel', 'Cancelled', true) + '</div>';
        } else {
            html += '<div class="hd-field"><label>Comment</label><textarea id="hd-action-comment" class="form-control"></textarea></div><div class="hd-actions">';
            if (status === 'Resolved') html += actionButton('Reopen', 'Reopened') + actionButton('Confirm and close', 'Closed');
            if (status === 'Closed') html += actionButton('Reopen', 'Reopened');
            if (status === 'New' || status === 'Pending Approval') html += actionButton('Cancel ticket', 'Cancelled', true);
            html += '</div>';
        }
        $('#hd-ticket-actions').html(html || '<div class="hd-empty">No action is currently available.</div>');
    }

    function loadTicket() {
        state.ticketId = parseInt(query('id'), 10) || 0;
        if (!state.ticketId) return show('A valid ticket ID is required.');
        api('GetTicket', { ticketId: state.ticketId }, function (error, raw) {
            if (error) return show(error);
            var tables = parse(raw), ticket = (tables[0] || [])[0], messages = tables[1] || [], audit = tables[2] || [];
            if (!ticket) return show('Ticket not found or you do not have access.');
            state.ticket = ticket;
            $('#hd-ticket-title').text(ticket.TicketNo); $('#hd-ticket-subject').text(ticket.Subject); $('#hd-ticket-description').text(ticket.Description);
            if (bool(ticket.IsStaff)) { $('#hd-ticket-workbench,#hd-internal-wrap').show(); }
            var meta = [['Status', badge(ticket.StatusCode)], ['Priority', badge(ticket.PriorityCode)], ['Category', text(ticket.CategoryName)], ['Requester', text(ticket.RequesterID)], ['Assigned to', text(ticket.AssignedToName || 'Unassigned')], ['Resolution SLA', date(ticket.ResolutionDueOn)]];
            $('#hd-ticket-meta').html($.map(meta, function (item) { return '<div><label>' + item[0] + '</label><strong>' + item[1] + '</strong></div>'; }).join(''));
            $('#hd-messages').html($.map(messages, function (m) { return '<div class="hd-message ' + (bool(m.IsInternal) ? 'internal' : '') + '"><div>' + text(m.MessageText) + '</div><small>' + (bool(m.IsInternal) ? 'Internal note · ' : '') + text(m.AddedBy) + ' · ' + date(m.AddedOn) + '</small></div>'; }).join('') || '<div class="hd-empty">No replies yet.</div>');
            $('#hd-audit').html($.map(audit, function (a) { return '<div class="hd-event"><strong>' + text(a.EventCode) + '</strong><div>' + text(a.OldValue || '') + (a.NewValue ? ' → ' + text(a.NewValue) : '') + '</div><small>' + date(a.PerformedOn) + ' · ' + text(a.PerformedBy) + '</small></div>'; }).join(''));
            renderTicketActions(ticket);
        });
    }

    function addMessage() {
        var message = $.trim($('#hd-reply').val()); if (!message) return show('Enter a reply.');
        api('AddMessage', { ticketId: state.ticketId, message: message, isInternal: $('#hd-internal').is(':checked') }, function (error, result) {
            if (error || parseInt(result, 10) <= 0) return show(error || 'Reply was not permitted.');
            $('#hd-reply').val(''); loadTicket();
        });
    }

    function transition(nextStatus) {
        var comment = $.trim($('#hd-action-comment').val());
        if ((nextStatus === 'Resolved' || nextStatus === 'Cancelled' || nextStatus === 'Reopened') && !comment) return show('A comment is required for this action.');
        api('Transition', { ticketId: state.ticketId, nextStatus: nextStatus, comment: comment }, function (error, result) {
            if (error || parseInt(result, 10) <= 0) return show(error || 'That status transition is not permitted.');
            show('Ticket updated.', 'success'); loadTicket();
        });
    }

    function approval(decision) {
        api('DecideApproval', { ticketId: state.ticketId, decision: decision, comment: $.trim($('#hd-action-comment').val()) }, function (error, result) {
            if (error || parseInt(result, 10) <= 0) return show(error || 'Approval decision was not permitted.');
            show('Decision recorded.', 'success'); loadTicket();
        });
    }

    function loadAdministration() {
        api('GetConfiguration', {}, function (error, raw) {
            if (error) return show(error);
            var tables = parse(raw), categories = tables[0] || [], sla = tables[1] || [], agents = tables[2] || [];
            if (!tables.length) return show('Administrator access is required.');
            state.configuration = { categories: categories, sla: sla, agents: agents };
            $('#hd-admin-categories').html($.map(categories, function (x, i) { return '<tr><td>' + text(x.CategoryName) + '</td><td>' + text(x.DepartmentName) + '</td><td>' + badge(x.DefaultPriority) + '</td><td>' + text(x.ApprovalMode) + '</td><td>' + text(x.DefaultApproverID || '—') + '</td><td>' + (bool(x.IsActive) ? 'Yes' : 'No') + '</td><td><button class="hd-btn hd-btn-muted" onclick="Helpdesk.editCategory(' + i + ')">Edit</button></td></tr>'; }).join(''));
            $('#hd-admin-sla').html($.map(sla, function (x, i) { return '<tr><td>' + badge(x.PriorityCode) + '</td><td>' + x.FirstResponseMins + ' min</td><td>' + x.ResolutionMins + ' min</td><td>' + (bool(x.IsActive) ? 'Yes' : 'No') + '</td><td><button class="hd-btn hd-btn-muted" onclick="Helpdesk.editSla(' + i + ')">Edit</button></td></tr>'; }).join(''));
            $('#hd-admin-agents').html($.map(agents, function (x, i) { return '<tr><td>' + x.EmployeeID + '</td><td>' + text(x.DisplayName) + '</td><td>' + text(x.DepartmentID || 'All') + '</td><td>' + text(x.RoleCode) + '</td><td>' + (bool(x.IsActive) ? 'Yes' : 'No') + '</td><td><button class="hd-btn hd-btn-muted" onclick="Helpdesk.editAgent(' + i + ')">Edit</button></td></tr>'; }).join(''));
        });
    }

    function saveCategory() {
        var payload = { categoryId: +$('#hd-category-id').val(), categoryName: $.trim($('#hd-admin-category-name').val()),
            departmentId: +$('#hd-admin-department-id').val(), departmentName: $.trim($('#hd-admin-department-name').val()),
            defaultPriority: $('#hd-admin-category-priority').val(), approvalMode: $('#hd-admin-approval-mode').val(),
            defaultApproverId: +$('#hd-admin-approver').val(), isActive: $('#hd-admin-category-active').is(':checked') };
        if (!payload.categoryName || !payload.departmentId || !payload.departmentName) return show('Category and department are required.');
        api('SaveCategory', payload, function (error, result) { if (error || +result <= 0) return show(error || 'Category was not saved.'); show('Category saved.', 'success'); $('#hd-category-id').val(0); loadAdministration(); });
    }
    function editCategory(index) {
        var x = state.configuration.categories[index]; $('#hd-category-id').val(x.CategoryID); $('#hd-admin-category-name').val(x.CategoryName);
        $('#hd-admin-department-id').val(x.DepartmentID); $('#hd-admin-department-name').val(x.DepartmentName);
        $('#hd-admin-category-priority').val(x.DefaultPriority); $('#hd-admin-approval-mode').val(x.ApprovalMode);
        $('#hd-admin-approver').val(x.DefaultApproverID || 0); $('#hd-admin-category-active').prop('checked', bool(x.IsActive));
    }
    function saveSla() {
        var payload = { slaPolicyId: +$('#hd-sla-id').val(), policyName: $.trim($('#hd-sla-name').val()), priorityCode: $('#hd-sla-priority').val(),
            firstResponseMins: +$('#hd-sla-response').val(), resolutionMins: +$('#hd-sla-resolution').val(), isActive: $('#hd-sla-active').is(':checked') };
        if (!payload.policyName || payload.firstResponseMins <= 0 || payload.resolutionMins < payload.firstResponseMins) return show('Enter a valid SLA name and minute targets.');
        api('SaveSla', payload, function (error, result) { if (error || +result <= 0) return show(error || 'SLA was not saved.'); show('SLA saved.', 'success'); $('#hd-sla-id').val(0); loadAdministration(); });
    }
    function editSla(index) {
        var x = state.configuration.sla[index]; $('#hd-sla-id').val(x.SlaPolicyID); $('#hd-sla-name').val(x.PolicyName); $('#hd-sla-priority').val(x.PriorityCode);
        $('#hd-sla-response').val(x.FirstResponseMins); $('#hd-sla-resolution').val(x.ResolutionMins); $('#hd-sla-active').prop('checked', bool(x.IsActive));
    }
    function saveAgent() {
        var payload = { agentId: +$('#hd-agent-id').val(), agentEmployeeId: +$('#hd-agent-employee').val(), displayName: $.trim($('#hd-agent-name').val()),
            departmentId: +$('#hd-agent-department').val(), roleCode: $('#hd-agent-role').val(), isActive: $('#hd-agent-active').is(':checked') };
        if (!payload.agentEmployeeId || !payload.displayName) return show('Employee ID and display name are required.');
        api('SaveAgent', payload, function (error, result) { if (error || +result <= 0) return show(error || 'Agent was not saved.'); show('Agent saved.', 'success'); $('#hd-agent-id').val(0); loadAdministration(); });
    }
    function editAgent(index) {
        var x = state.configuration.agents[index]; $('#hd-agent-id').val(x.AgentID); $('#hd-agent-employee').val(x.EmployeeID);
        $('#hd-agent-name').val(x.DisplayName); $('#hd-agent-department').val(x.DepartmentID || 0); $('#hd-agent-role').val(x.RoleCode); $('#hd-agent-active').prop('checked', bool(x.IsActive));
    }

    $(function () {
        var page = $('[data-helpdesk-page]').data('helpdesk-page');
        if (page === 'home') loadHome();
        else if (page === 'workbench') loadWorkbench();
        else if (page === 'ticket') loadTicket();
        else if (page === 'administration') loadAdministration();
    });

    window.Helpdesk = { createTicket: createTicket, loadMyTickets: loadMyTickets, loadQueue: loadQueue, assign: assign, addMessage: addMessage,
        transition: transition, approval: approval, saveCategory: saveCategory, editCategory: editCategory, saveSla: saveSla,
        editSla: editSla, saveAgent: saveAgent, editAgent: editAgent };
})(window, window.jQuery);
