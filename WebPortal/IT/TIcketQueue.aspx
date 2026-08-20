<%@ Page Title="" Language="C#" MasterPageFile="~/IT/Admin.Master" AutoEventWireup="true" CodeBehind="TIcketQueue.aspx.cs" Inherits="WebPortal.IT.TIcketQueue" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --ticket-primary: #2563eb;
            --ticket-primary-dark: #1d4ed8;
            --ticket-soft: #eff6ff;
            --ticket-border: #e5e7eb;
            --ticket-text: #0f172a;
            --ticket-muted: #64748b;
            --ticket-card-shadow: 0 18px 45px rgba(15, 23, 42, .08);
        }

        .ticket-page {
            background: #f8fafc;
            min-height: calc(100vh - 90px);
        }

        .ticket-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: flex-start;
            gap: 18px;
            color: #fff;
            background: linear-gradient(135deg, #2563eb 0%, #7c3aed 55%, #f97316 120%);
            border-radius: 22px;
            padding: 24px 28px;
            margin-bottom: 18px;
            box-shadow: var(--ticket-card-shadow);
        }

            .ticket-hero:after {
                content: "";
                position: absolute;
                width: 280px;
                height: 280px;
                right: -80px;
                top: -110px;
                background: rgba(255, 255, 255, .16);
                border-radius: 50%;
            }

            .ticket-hero h4,
            .ticket-hero p,
            .ticket-hero .btn {
                position: relative;
                z-index: 1;
            }

            .ticket-hero h4 {
                margin: 0;
                font-weight: 800;
                letter-spacing: .2px;
            }

            .ticket-hero p {
                margin: 7px 0 0;
                color: rgba(255, 255, 255, .86);
            }


        .ticket-hero-icon {
            width: 52px;
            height: 52px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 16px;
            color: #fff;
            background: linear-gradient(135deg, var(--ticket-primary), #fe7096);
            box-shadow: 0 14px 26px rgba(37, 99, 235, .25);
            font-size: 22px;
        }

        .ticket-card {
            border: 1px solid var(--ticket-border) !important;
            border-radius: 18px !important;
            box-shadow: var(--ticket-card-shadow);
            overflow: visible;
        }

        .queue-toolbar { display:flex; align-items:center; justify-content:space-between; gap:16px; margin-bottom:18px; }
        .queue-tabs { display:flex; gap:6px; flex-wrap:wrap; padding:4px; border:1px solid var(--ticket-border); border-radius:12px; background:#f8fafc; }
        .queue-tab { border:0; background:transparent; color:var(--ticket-muted); border-radius:9px; padding:9px 16px; font-weight:700; cursor:pointer; transition:all .2s ease; }
        .queue-tab:hover { color:var(--ticket-primary); background:#fff; }
        .queue-tab.active { background:#fff; color:var(--ticket-primary); box-shadow:0 2px 8px rgba(15,23,42,.09); }
        .queue-panel { display:none; }
        .queue-panel.active { display:block; }
        .btn-export-excel { display:inline-flex; align-items:center; gap:8px; border:0; border-radius:10px; padding:10px 16px; color:#fff; background:#15803d; font-weight:700; box-shadow:0 7px 16px rgba(21,128,61,.18); transition:all .2s ease; white-space:nowrap; }
        .btn-export-excel:hover { color:#fff; background:#166534; transform:translateY(-1px); }

            .ticket-card .card-body {
                padding: 20px;
            }

        .ticket-table-wrap {
            width: 100%;
            overflow: visible;
            border: 1px solid var(--ticket-border);
            border-radius: 14px;
            background: #fff;
        }

        #it_ticketqueue, #it_myqueue {
            border-collapse: collapse !important;
            border-spacing: 0 !important;
            margin-top: 0 !important;
            margin-bottom: 0 !important;
            table-layout: fixed;
        }

        #it_ticketqueue { width:1696px !important; min-width:1696px; }
        #it_myqueue { width:1541px !important; min-width:1541px; }

        #it_ticketqueue th, #it_ticketqueue td,
        #it_myqueue th, #it_myqueue td { box-sizing:border-box; }

            #it_ticketqueue thead th, #it_myqueue thead th {
                background: #f8fafc !important;
                color: #334155 !important;
                font-size: 11px;
                font-weight: 800;
                text-transform: uppercase;
                letter-spacing: .055em;
                border: 0 !important;
                border-bottom: 1px solid #dbe3ed !important;
                padding: 13px 12px !important;
                vertical-align: middle;
                white-space: nowrap;
            }

            #it_ticketqueue tbody tr, #it_myqueue tbody tr {
                transition: background-color .15s ease, box-shadow .15s ease;
            }

            #it_ticketqueue tbody tr:nth-child(even), #it_myqueue tbody tr:nth-child(even) {
                background: #fbfdff;
            }

            #it_ticketqueue tbody tr:hover, #it_myqueue tbody tr:hover {
                background: #f0f7ff;
                box-shadow: inset 3px 0 0 var(--ticket-primary);
            }

            #it_ticketqueue tbody td, #it_myqueue tbody td {
                background: transparent !important;
                border: 0 !important;
                border-bottom: 1px solid #edf1f5 !important;
                padding: 12px !important;
                vertical-align: middle;
                color: #334155;
                font-size: 13px;
            }

        .ticket-number { color:var(--ticket-primary-dark); font-weight:800; white-space:nowrap; }
        .ticket-subject { display:block; width:auto; min-width:0; max-width:none; color:var(--ticket-text); font-weight:600; line-height:1.4; white-space:normal; overflow-wrap:anywhere; }
        .ticket-meta { color:var(--ticket-muted); white-space:nowrap; }
        .ticket-badge { display:inline-flex; align-items:center; border-radius:999px; padding:5px 9px; font-size:11px; font-weight:800; line-height:1; white-space:nowrap; }
        .ticket-badge-high, .ticket-badge-critical, .ticket-badge-urgent { color:#b42318; background:#fee4e2; }
        .ticket-badge-medium, .ticket-badge-normal { color:#b54708; background:#fef0c7; }
        .ticket-badge-low { color:#027a48; background:#d1fadf; }
        .ticket-badge-default { color:#475467; background:#eef2f6; }
        .ticket-badge-open, .ticket-badge-in-progress, .ticket-badge-pending { color:#175cd3; background:#dbeafe; }
        .ticket-badge-closed, .ticket-badge-resolved, .ticket-badge-completed { color:#027a48; background:#d1fadf; }
        .ticket-action-icon { display:inline-flex; align-items:center; justify-content:center; width:36px; height:36px; border-radius:9px; padding:0; font-size:14px; color:#fff; background:var(--ticket-primary); box-shadow:0 5px 12px rgba(37,99,235,.2); transition:all .2s ease; }
        .ticket-action-icon:hover { color:#fff; background:var(--ticket-primary-dark); transform:translateY(-1px); }
        .ticket-action-icon:focus { color:#fff; outline:none; box-shadow:0 0 0 3px rgba(37,99,235,.2); }
        .ticket-action-icon.is-locked { background:#94a3b8; box-shadow:none; cursor:not-allowed; }

        .ticket-assign-control { display:flex; align-items:stretch; width:100%; min-width:0; box-sizing:border-box; border-radius:10px; box-shadow:0 4px 12px rgba(15,23,42,.08); }
        .ticket-assign-select { min-width:0; height:38px; flex:1 1 auto; padding:6px 32px 6px 11px; color:#334155; background-color:#fff; border:1px solid #cbd5e1; border-right:0; border-radius:10px 0 0 10px; font-size:13px; font-weight:600; outline:none; transition:border-color .2s ease, box-shadow .2s ease; }
        .ticket-assign-select:hover { border-color:#94a3b8; }
        .ticket-assign-select:focus { position:relative; z-index:1; border-color:var(--ticket-primary); box-shadow:0 0 0 3px rgba(37,99,235,.12); }
        .ticket-assign-button { display:inline-flex; align-items:center; justify-content:center; gap:6px; height:38px; padding:0 13px; color:#fff; background:linear-gradient(135deg,#0d9488,#2dd4bf); border:0; border-radius:0 10px 10px 0; font-size:12px; font-weight:800; white-space:nowrap; transition:filter .2s ease, transform .2s ease; }
        .ticket-assign-button:hover { color:#fff; filter:brightness(.94); }
        .ticket-assign-button:focus { outline:none; box-shadow:0 0 0 3px rgba(13,148,136,.2); }
        .ticket-assigned-user { display:inline-flex; align-items:center; max-width:224px; padding:6px 10px; color:#475569; background:#eef2f6; border:1px solid #e2e8f0; border-radius:999px; font-size:11px; font-weight:800; line-height:1.2; }

        .ticket-col-action { width:64px !important; min-width:64px !important; text-align:center !important; }
        .ticket-col-assign { width:260px !important; min-width:260px !important; text-align:left !important; }
        .ticket-col-number { width:130px !important; min-width:130px !important; text-align:left !important; }
        .ticket-col-date { width:170px !important; min-width:170px !important; text-align:left !important; }
        .ticket-col-tat { width:175px !important; min-width:175px !important; text-align:left !important; }
        .ticket-col-code { width:72px !important; min-width:72px !important; text-align:center !important; }
        .ticket-col-location { width:90px !important; min-width:90px !important; text-align:left !important; }
        .ticket-col-request { width:190px !important; min-width:190px !important; text-align:left !important; }
        td.ticket-col-request { white-space:normal; overflow-wrap:anywhere; }
        .ticket-col-priority { width:100px !important; min-width:100px !important; text-align:center !important; }
        .ticket-subject-column { width:300px !important; min-width:260px !important; text-align:left !important; }
        .ticket-col-status { width:105px !important; min-width:105px !important; text-align:center !important; }
        .ticket-col-elapsed { width:145px !important; min-width:145px !important; text-align:left !important; }

        .dataTables_wrapper .dataTables_filter input,
        .dataTables_wrapper .dataTables_length select {
            border: 1px solid var(--ticket-border) !important;
            border-radius: 10px !important;
            padding: 7px 10px !important;
            outline: none !important;
        }

        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dataTables_filter { margin-bottom:14px; color:var(--ticket-muted); font-size:13px; }
        .dataTables_wrapper .dataTables_info { padding:16px 4px 4px !important; color:var(--ticket-muted) !important; font-size:13px; }
        .dataTables_wrapper .dataTables_paginate { padding-top:12px !important; }
        .dataTables_wrapper .dataTables_paginate .paginate_button { border:0 !important; border-radius:8px !important; }
        .dataTables_wrapper .dataTables_paginate .paginate_button:hover { color:var(--ticket-primary) !important; background:#eff6ff !important; }
        .ticket-dt-top, .ticket-dt-bottom { display:flex; align-items:center; justify-content:space-between; gap:14px; flex-wrap:wrap; padding:14px; }
        .ticket-dt-top .dataTables_length, .ticket-dt-top .dataTables_filter,
        .ticket-dt-bottom .dataTables_info, .ticket-dt-bottom .dataTables_paginate { float:none !important; margin:0 !important; padding:0 !important; }
        .ticket-grid-scroll { width:100%; overflow-x:auto; border-top:1px solid var(--ticket-border); border-bottom:1px solid var(--ticket-border); }

            .dataTables_wrapper .dataTables_filter input:focus {
                border-color: var(--ticket-primary) !important;
                box-shadow: 0 0 0 3px rgba(37, 99, 235, .12) !important;
            }

        .dataTables_wrapper .dataTables_paginate .paginate_button.current,
        .dataTables_wrapper .dataTables_paginate .paginate_button.current:hover {
            color: #fff !important;
            border: 0 !important;
            border-radius: 10px !important;
            background: var(--ticket-primary) !important;
        }

        @media (max-width: 767px) {
            .ticket-hero {
                align-items: flex-start;
                padding: 18px;
            }

            .ticket-hero-icon {
                width: 46px;
                height: 46px;
            }

            .queue-toolbar { align-items:stretch; flex-direction:column; }
            .queue-tabs { width:100%; }
            .queue-tab { flex:1; }
            .btn-export-excel { justify-content:center; width:100%; }
            .ticket-card .card-body { padding:14px; }
        }
         .loading {
     align-items: center;
     background: rgba(255,255,255,0.92);
     border: 1px solid #dce5ec;
     border-radius: 8px;
     box-shadow: 0 18px 40px rgba(20, 33, 45, 0.18);
     color: #263747;
     display: none;
     font-size: 12px;
     font-weight: 700;
     left: 50%;
     min-width: 220px;
     padding: 18px;
     position: fixed;
     text-align: center;
     top: 42%;
     transform: translate(-50%, -50%);
     z-index: 99999;
 }

     .loading img {
         display: block;
         margin: 0 auto 10px;
         max-width: 44px;
     }
    </style>
    <script type="text/javascript">
        var it_tq_departmentUsers = [];

        $(document).ready(function () {
            it_tq_loadDepartmentUsers(function () { it_tq_bindgrid(); });
        });

        function it_tq_text(value) {
            if (value === null || value === undefined) return '';
            return $('<div/>').text(value).html();
        }

        function it_tq_value(item, names) {
            for (var i = 0; i < names.length; i++) {
                if (item[names[i]] !== undefined && item[names[i]] !== null && item[names[i]] !== '') return item[names[i]];
            }
            return '';
        }

        function it_tq_getTicketId(item) {
            return it_tq_value(item, ['TicketID', 'TicketId', 'ID', 'Id']);
        }

        function it_tq_loadDepartmentUsers(callback) {
            $.ajax({
                type: 'POST',
                url: 'TIcketQueue.aspx/GetEmpsByDept',
                data: '{}',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (response) {
                    
                    it_tq_departmentUsers = response && response.d ? JSON.parse(response.d) : [];
                    if (typeof callback === 'function') callback();
                },
                error: function () {
                    it_tq_departmentUsers = [];
                    if (typeof callback === 'function') callback();
                }
            });
        }

        function it_tq_assignDropdown(ticketId, disabled, item) {
            if (disabled) {
                var assignedName = it_tq_value(item, ['AssignName', 'AssignedToUserName', 'AssignToName', 'AssignedToName']);
                return '<span class="ticket-assigned-user"><i class="fas fa-user-check mr-1" aria-hidden="true"></i>' + it_tq_text(assignedName || 'Assigned') + '</span>';
            }
            var htmldrp = '<div class="ticket-assign-control">';
            htmldrp += '<select class="ticket-assign-select it-tq-assignto" aria-label="Select user to assign" data-ticketid="' + it_tq_text(ticketId) + '">';
            htmldrp += '<option value="0">Select user</option>';
            $.each(it_tq_departmentUsers, function (i, emp) {
                var empId = it_tq_value(emp, ['EmpId', 'EmployeeId','EmployeeID', 'UserId', 'ID', 'Id', 'EmpID']);
                var empText = it_tq_value(emp, ['EmpName1', 'EmployeeName', 'Name', 'FullName', 'FirstName']);
                var code = it_tq_value(emp, ['Code', 'EmployeeCode', 'EmpCode']);
                if (code) empText = code + ' - ' + empText;
                if (empId) htmldrp += '<option value="' + it_tq_text(empId) + '">' + it_tq_text(empText) + '</option>';
            });
            htmldrp += '</select><button type="button" class="ticket-assign-button" title="Assign ticket" onclick="return it_tq_assignSelected(this);"><i class="fas fa-user-plus" aria-hidden="true"></i><span>Assign</span></button></div>';
            return htmldrp;
        }

        function it_tq_actionHtml(item) {
            var ticketId = it_tq_getTicketId(item);
            if (item.CanTakeAction === false || item.CanTakeAction === 'False' || item.CanTakeAction === 'false') {
                var assignedName = item.AssignedToUserName ? ' to ' + it_tq_text(item.AssignedToUserName) : '';
                return '<span class="ticket-action-icon is-locked" title="Ticket is already assigned' + assignedName + '" aria-label="Ticket is locked"><i class="fas fa-lock" aria-hidden="true"></i></span>';
            }
            return '<a class="ticket-action-icon" href="AddTicketRemark.aspx?TicketId=' + it_tq_text(ticketId) + '" title="Update" aria-label="Update"><i class="fas fa-edit" aria-hidden="true"></i></a>';
        }

        function it_tq_badge(value, type) {
            var text = $.trim(value === null || value === undefined ? '' : String(value));
            if (!text) return '<span class="ticket-meta">&mdash;</span>';
            var key = text.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/(^-|-$)/g, '');
            var supported = type === 'priority'
                ? ['high', 'critical', 'urgent', 'medium', 'normal', 'low']
                : ['open', 'in-progress', 'pending', 'closed', 'resolved', 'completed'];
            if ($.inArray(key, supported) < 0) key = 'default';
            return '<span class="ticket-badge ticket-badge-' + key + '">' + it_tq_text(text) + '</span>';
        }

        function it_tq_cell(value, className) {
            var text = $.trim(value === null || value === undefined ? '' : String(value));
            return '<span class="' + className + '" title="' + it_tq_text(text) + '">' + (text ? it_tq_text(text) : '&mdash;') + '</span>';
        }

        function it_tq_export() {
            var mode = $('#panelMyQueue').hasClass('active') ? 'my' : 'department';
            window.location.href = 'TIcketQueue.aspx?export=' + mode;
        }

        function it_tq_dataTableOptions(isMyQueue) {
            var widths = isMyQueue
                ? ['64px', '130px', '170px', '175px', '72px', '90px', '190px', '100px', '300px', '105px', '145px']
                : ['64px', '260px', '130px', '170px', '175px', '72px', '90px', '190px', '100px', '300px', '145px'];
            var columnDefs = [];
            $.each(widths, function (index, width) {
                columnDefs.push({ targets: index, width: width });
            });
            return {
                autoWidth: false,
                pageLength: 25,
                order: [],
                columnDefs: columnDefs,
                dom: '<"ticket-dt-top"lf><"ticket-grid-scroll"t><"ticket-dt-bottom"ip>'
            };
        }

        function it_tq_bindgrid() {
            $.ajax({
                type: 'POST',
                url: 'TIcketQueue.aspx/GetAllTickets',
                data: '{}',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (response) {
                    var rows = response && response.d ? JSON.parse(response.d) : [];
                    if ($.fn.DataTable.isDataTable('#it_ticketqueue')) $('#it_ticketqueue').DataTable().destroy();
                    var tbody = $('#it_ticketqueue tbody');
                    tbody.empty();
                    $.each(rows, function (i, item) {
                        var ticketId = it_tq_getTicketId(item);
                        var assigned = item.IsAssigned === true || item.IsAssigned === 'True' || item.IsAssigned === 'true';
                        var assignedToMe = item.IsAssignedToMe === true || item.IsAssignedToMe === 'True' || item.IsAssignedToMe === 'true';
                        var disableAssign = assigned && !assignedToMe;
                        var html = '<tr>' +
                            '<td class="ticket-col-action">' + it_tq_actionHtml(item) + '</td>' +
                            '<td class="ticket-col-assign">' + it_tq_assignDropdown(ticketId, disableAssign || assignedToMe, item) + '</td>' +
                            '<td class="ticket-col-number">' + it_tq_cell(it_tq_value(item, ['TicketNo', 'Ticket']), 'ticket-number') + '</td>' +
                            '<td class="ticket-col-date">' + it_tq_cell(it_tq_value(item, ['RequestDateTime', 'RequestDate', 'CreatedDate']), 'ticket-meta') + '</td>' +
                            '<td class="ticket-col-tat">' + it_tq_cell(it_tq_value(item, ['ExpectedTAT', 'TAT']), 'ticket-meta') + '</td>' +
                            '<td class="ticket-col-code">' + it_tq_text(it_tq_value(item, ['Code', 'EmployeeCode'])) + '</td>' +
                            '<td class="ticket-col-location">' + it_tq_text(it_tq_value(item, ['WorkingBranch', 'Location'])) + '</td>' +
                            '<td class="ticket-col-request">' + it_tq_text(it_tq_value(item, ['RequestB', 'Request', 'RequestRelatedTo'])) + '</td>' +
                            '<td class="ticket-col-priority">' + it_tq_badge(it_tq_value(item, ['Priority']), 'priority') + '</td>' +
                            '<td class="ticket-subject-column">' + it_tq_cell(it_tq_value(item, ['Subject']), 'ticket-subject') + '</td>' +
                            '<td class="ticket-col-elapsed">' + it_tq_cell(it_tq_value(item, ['ElapsedTime']), 'ticket-meta') + '</td>' +
                            '</tr>';
                        tbody.append(html);
                    });
                    $('#it_ticketqueue').DataTable(it_tq_dataTableOptions(false));
                }
            });
        }

        function it_tq_assignSelected(btn) {
            var $wrap = $(btn).closest('.ticket-assign-control');
            var assignTo = parseInt($wrap.find('.it-tq-assignto').val(), 10);
            var ticketId = parseInt($wrap.find('.it-tq-assignto').data('ticketid'), 10);
            if (!assignTo || !ticketId) { alert('Please select user.'); return false; }
            $('#load1').show();
            $.ajax({
                type: 'POST',
                url: 'TIcketQueue.aspx/InsertTicketAssignTo',
                data: JSON.stringify({ AssignTo: assignTo, TicketID: ticketId }),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (r) {
                    $('#load1').hide();
                    if (parseInt(r.d, 10) > 0) {
                        alert('Ticket assigned successfully.');
                        it_tq_bindgrid();
                        it_mq_bindgrid();
                    } else { alert('Ticket could not be assigned.'); }
                },
                error: function () { $('#load1').hide(); alert('Ticket could not be assigned.'); }
            });
            return false;
        }

        function showQueuePanel(panel) {
            $('.queue-tab').removeClass('active');
            $('.queue-tab').attr('aria-selected', 'false');
            $('.queue-panel').removeClass('active');
            $('#' + panel).addClass('active');
            $('[data-panel="' + panel + '"]').addClass('active').attr('aria-selected', 'true');
            if (panel === 'panelMyQueue') {
                it_mq_bindgrid();
            }
        }

        function it_mq_bindgrid() {
            $.ajax({
                type: 'POST',
                url: 'TIcketQueue.aspx/GetMyQueue',
                data: '{}',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (response) {
                    var rows = response && response.d ? JSON.parse(response.d) : [];
                    if ($.fn.DataTable.isDataTable('#it_myqueue')) $('#it_myqueue').DataTable().destroy();
                    var tbody = $('#it_myqueue tbody');
                    tbody.empty();
                    $.each(rows, function (i, item) {
                        var ticketId = it_tq_getTicketId(item);
                        var html = '<tr>' +
                            '<td class="ticket-col-action"><a class="ticket-action-icon" href="AddTicketRemark.aspx?TicketId=' + it_tq_text(ticketId) + '" title="Update" aria-label="Update"><i class="fas fa-edit" aria-hidden="true"></i></a></td>' +
                            '<td class="ticket-col-number">' + it_tq_cell(it_tq_value(item, ['TicketNo', 'Ticket']), 'ticket-number') + '</td>' +
                            '<td class="ticket-col-date">' + it_tq_cell(it_tq_value(item, ['RequestDateTime', 'RequestDate', 'CreatedDate']), 'ticket-meta') + '</td>' +
                            '<td class="ticket-col-tat">' + it_tq_cell(it_tq_value(item, ['ExpectedTAT', 'TAT']), 'ticket-meta') + '</td>' +
                            '<td class="ticket-col-code">' + it_tq_text(it_tq_value(item, ['Code', 'EmployeeCode'])) + '</td>' +
                            '<td class="ticket-col-location">' + it_tq_text(it_tq_value(item, ['WorkingBranch', 'Location'])) + '</td>' +
                            '<td class="ticket-col-request">' + it_tq_text(it_tq_value(item, ['RequestB', 'Request', 'RequestRelatedTo'])) + '</td>' +
                            '<td class="ticket-col-priority">' + it_tq_badge(it_tq_value(item, ['Priority']), 'priority') + '</td>' +
                            '<td class="ticket-subject-column">' + it_tq_cell(it_tq_value(item, ['Subject']), 'ticket-subject') + '</td>' +
                            '<td class="ticket-col-status">' + it_tq_badge(it_tq_value(item, ['Status']), 'status') + '</td>' +
                            '<td class="ticket-col-elapsed">' + it_tq_cell(it_tq_value(item, ['ElapsedTime']), 'ticket-meta') + '</td>' +
                            '</tr>';
                        tbody.append(html);
                    });
                    $('#it_myqueue').DataTable(it_tq_dataTableOptions(true));
                }
            });
        }

    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="ticket-page">
        <div class="ticket-hero">
            <span class="ticket-hero-icon"><i class="fas fa-ticket-alt"></i></span> <div>
                <h4>Ticket Queue</h4>
                <p>Review assigned tickets, priority, TAT and elapsed time in one clean view.</p>
            </div>
           
        </div>
        <div class="col-lg-12 p-0">
            <div class="card ticket-card">
                <div class="card-body">
                    <div class="queue-toolbar">
                        <div class="queue-tabs" role="tablist" aria-label="Ticket queue views">
                            <button type="button" class="queue-tab active" role="tab" aria-selected="true" data-panel="panelDepartmentQueue" onclick="showQueuePanel('panelDepartmentQueue');">Department Queue</button>
                            <button type="button" class="queue-tab" role="tab" aria-selected="false" data-panel="panelMyQueue" onclick="showQueuePanel('panelMyQueue');">My Queue</button>
                        </div>
                        <button type="button" class="btn-export-excel" onclick="it_tq_export();"><i class="fas fa-file-excel"></i>Export to Excel</button>
                    </div>
                    <div id="panelDepartmentQueue" class="queue-panel active">
                    <div class="ticket-table-wrap">
                        <table class="table" id="it_ticketqueue" style="width: 100%;">
                            <thead>
                                <tr>
                                    <th class="sort border-top ticket-col-action">Action</th>
                                    <th class="sort border-top ticket-col-assign">Assign Ticket</th>
                                    <th class="sort border-top ticket-col-number">Ticket No</th>
                                    <th class="sort border-top ticket-col-date">Ticket Raised On</th>
                                    <th class="sort border-top ticket-col-tat">Expected TAT</th>
                                    <th class="sort border-top ticket-col-code">Code</th>
                                    <th class="sort border-top ticket-col-location">Location</th>
                                    <th class="sort border-top ticket-col-request">Request Related To</th>
                                    <th class="sort border-top ticket-col-priority">Priority</th>
                                    <th class="sort border-top ticket-subject-column">Subject</th>
                                    <th class="sort border-top ticket-col-elapsed">Elapsed Time</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                    </div>
                    <div id="panelMyQueue" class="queue-panel">
                        <div class="ticket-table-wrap">
                            <table class="table" id="it_myqueue" style="width: 100%;">
                                <thead>
                                    <tr>
                                        <th class="sort border-top ticket-col-action">Action</th>
                                        <th class="sort border-top ticket-col-number">Ticket No</th>
                                        <th class="sort border-top ticket-col-date">Ticket Raised On</th>
                                        <th class="sort border-top ticket-col-tat">Expected TAT</th>
                                        <th class="sort border-top ticket-col-code">Code</th>
                                        <th class="sort border-top ticket-col-location">Location</th>
                                        <th class="sort border-top ticket-col-request">Request Related To</th>
                                        <th class="sort border-top ticket-col-priority">Priority</th>
                                        <th class="sort border-top ticket-subject-column">Subject</th>
                                        <th class="sort border-top ticket-col-status">Status</th>
                                        <th class="sort border-top ticket-col-elapsed">Elapsed Time</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
