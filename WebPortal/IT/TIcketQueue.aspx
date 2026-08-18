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
            box-shadow: var(--remark-shadow);
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
            overflow: hidden;
        }

        .queue-tabs { display:flex; gap:10px; margin-bottom:16px; flex-wrap:wrap; }
        .queue-tab { border:1px solid var(--ticket-border); background:#fff; color:var(--ticket-text); border-radius:999px; padding:9px 18px; font-weight:800; cursor:pointer; }
        .queue-tab.active { background:var(--ticket-primary); color:#fff; border-color:var(--ticket-primary); }
        .queue-panel { display:none; }
        .queue-panel.active { display:block; }
        .btn-self-assign { border-radius:999px; font-weight:700; padding:6px 14px; }

            .ticket-card .card-body {
                padding: 20px;
            }

        .ticket-table-wrap {
            width: 100%;
            overflow-x: auto;
        }

        #it_ticketqueue, #it_myqueue {
            border-collapse: separate !important;
            border-spacing: 0 10px !important;
            margin-top: 0 !important;
        }

            #it_ticketqueue thead th, #it_myqueue thead th {
                background: #f1f5f9 !important;
                color: #334155 !important;
                font-size: 12px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: .03em;
                border: 0 !important;
                padding: 12px 14px !important;
                vertical-align: middle;
            }

            #it_ticketqueue tbody tr, #it_myqueue tbody tr {
                box-shadow: 0 6px 18px rgba(15, 23, 42, .06);
                border-radius: 14px;
            }

            #it_ticketqueue tbody td, #it_myqueue tbody td {
                background: #fff !important;
                border-top: 1px solid var(--ticket-border) !important;
                border-bottom: 1px solid var(--ticket-border) !important;
                padding: 13px 14px !important;
                vertical-align: middle;
                color: #1f2937;
            }

                #it_ticketqueue tbody td:first-child, #it_myqueue tbody td:first-child {
                    border-left: 1px solid var(--ticket-border) !important;
                    border-radius: 14px 0 0 14px;
                }

                #it_ticketqueue tbody td:last-child, #it_myqueue tbody td:last-child {
                    border-right: 1px solid var(--ticket-border) !important;
                    border-radius: 0 14px 14px 0;
                }

        .dataTables_wrapper .dataTables_filter input,
        .dataTables_wrapper .dataTables_length select {
            border: 1px solid var(--ticket-border) !important;
            border-radius: 10px !important;
            padding: 7px 10px !important;
            outline: none !important;
        }

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
            if (disabled) return '<span class="badge badge-secondary" style="font-size:100%!important;">' + item.AssignName + '</span>';
            var htmldrp = '<div class="input-group input-group-sm" style="min-width:210px;">';
            htmldrp += '<select class="form-control it-tq-assignto" data-ticketid="' + it_tq_text(ticketId) + '">';
            htmldrp += '<option value="0">Select user</option>';
            $.each(it_tq_departmentUsers, function (i, emp) {
                var empId = it_tq_value(emp, ['EmpId', 'EmployeeId','EmployeeID', 'UserId', 'ID', 'Id', 'EmpID']);
                var empText = it_tq_value(emp, ['EmpName1', 'EmployeeName', 'Name', 'FullName', 'FirstName']);
                var code = it_tq_value(emp, ['Code', 'EmployeeCode', 'EmpCode']);
                if (code) empText = code + ' - ' + empText;
                if (empId) htmldrp += '<option value="' + it_tq_text(empId) + '">' + it_tq_text(empText) + '</option>';
            });
            htmldrp += '</select><div class="input-group-append"><button type="button" class="btn btn-primary" onclick="return it_tq_assignSelected(this);">Assign</button></div></div>';
            return htmldrp;
        }

        function it_tq_actionHtml(item) {
            var ticketId = it_tq_getTicketId(item);
            if (item.CanTakeAction === false || item.CanTakeAction === 'False' || item.CanTakeAction === 'false') {
                var assignedName = item.AssignedToUserName ? ' to ' + it_tq_text(item.AssignedToUserName) : '';
                return '<button type="button" class="btn btn-sm btn-secondary" disabled title="Ticket is already assigned' + assignedName + '">Locked</button>';
            }
            return '<a class="btn btn-sm btn-primary" href="AddTicketRemark.aspx?TicketId=' + it_tq_text(ticketId) + '">Update</a>';
        }

        function it_tq_selfAssignHtml(item) {
            var ticketId = it_tq_getTicketId(item);
            var assignedToMe = item.IsAssignedToMe === true || item.IsAssignedToMe === 'True' || item.IsAssignedToMe === 'true';
            var assigned = item.IsAssigned === true || item.IsAssigned === 'True' || item.IsAssigned === 'true';
            if (assignedToMe) return '<span class="badge badge-success">My Queue</span>';
            if (assigned) return '';
            //if (assigned) return '<button type="button" class="btn btn-sm btn-outline-secondary btn-self-assign" disabled>Assigned</button>';
            return '<button type="button" class="btn btn-sm btn-outline-primary btn-self-assign" onclick="return it_tq_assignSelf(' + parseInt(ticketId, 10) + ');">Take Ticket</button>';
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
                            '<td>' + it_tq_actionHtml(item) + '</td>' +
                            '<td style="display:none;">' + it_tq_text(ticketId) + '</td>' +
                            '<td>' + it_tq_assignDropdown(ticketId, disableAssign || assignedToMe, item) + '</td>' +
                            '<td>' + it_tq_selfAssignHtml(item) + '</td>' +
                            '<td>' + it_tq_text(it_tq_value(item, ['TicketNo', 'Ticket'])) + '</td>' +
                            '<td>' + it_tq_text(it_tq_value(item, ['RequestDateTime', 'RequestDate', 'CreatedDate'])) + '</td>' +
                            '<td>' + it_tq_text(it_tq_value(item, ['ExpectedTAT', 'TAT'])) + '</td>' +
                            '<td>' + it_tq_text(it_tq_value(item, ['Code', 'EmployeeCode'])) + '</td>' +
                            '<td>' + it_tq_text(it_tq_value(item, ['WorkingBranch', 'Location'])) + '</td>' +
                            '<td>' + it_tq_text(it_tq_value(item, ['RequestB', 'Request', 'RequestRelatedTo'])) + '</td>' +
                            '<td>' + it_tq_text(it_tq_value(item, ['Priority'])) + '</td>' +
                            '<td>' + it_tq_text(it_tq_value(item, ['Subject'])) + '</td>' +
                            '<td>' + it_tq_text(it_tq_value(item, ['ElapsedTime'])) + '</td>' +
                            '</tr>';
                        tbody.append(html);
                    });
                    console.log(tbody.html());
                    $('#it_ticketqueue').DataTable({ scrollX: true, autoWidth: false, pageLength: 25, order: [] });
                }
            });
        }

        function it_tq_assignSelected(btn) {
            var $wrap = $(btn).closest('.input-group');
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
            $('.queue-panel').removeClass('active');
            $('#' + panel).addClass('active');
            $('[data-panel="' + panel + '"]').addClass('active');
            if (panel === 'panelMyQueue') it_mq_bindgrid();
        }

        function it_tq_assignSelf(ticketId) {
            if (!ticketId) return false;
            $('#load1').show();
            $.ajax({
                type: 'POST',
                url: 'TIcketQueue.aspx/AssignTicketToSelf',
                data: JSON.stringify({ TicketID: parseInt(ticketId, 10) }),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (r) {
                    $('#load1').hide();
                    if (parseInt(r.d, 10) > 0) {
                        alert('Ticket assigned to your queue.');
                        it_tq_bindgrid();
                        it_mq_bindgrid();
                    } else { alert('Ticket could not be assigned.'); }
                },
                error: function () { $('#load1').hide(); alert('Ticket could not be assigned.'); }
            });
            return false;
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
                            '<td><a class="btn btn-sm btn-primary" href="AddTicketRemark.aspx?TicketId=' + it_tq_text(ticketId) + '">Update</a></td>' +
                            '<td style="display:none;">' + it_tq_text(ticketId) + '</td>' +
                            '<td>' + it_tq_text(it_tq_value(item, ['TicketNo', 'Ticket'])) + '</td>' +
                            '<td>' + it_tq_text(it_tq_value(item, ['RequestDateTime', 'RequestDate', 'CreatedDate'])) + '</td>' +
                            '<td>' + it_tq_text(it_tq_value(item, ['ExpectedTAT', 'TAT'])) + '</td>' +
                            '<td>' + it_tq_text(it_tq_value(item, ['Code', 'EmployeeCode'])) + '</td>' +
                            '<td>' + it_tq_text(it_tq_value(item, ['WorkingBranch', 'Location'])) + '</td>' +
                            '<td>' + it_tq_text(it_tq_value(item, ['RequestB', 'Request', 'RequestRelatedTo'])) + '</td>' +
                            '<td>' + it_tq_text(it_tq_value(item, ['Priority'])) + '</td>' +
                            '<td>' + it_tq_text(it_tq_value(item, ['Subject'])) + '</td>' +
                            '<td>' + it_tq_text(it_tq_value(item, ['Status'])) + '</td>' +
                            '<td>' + it_tq_text(it_tq_value(item, ['ElapsedTime'])) + '</td>' +
                            '</tr>';
                        tbody.append(html);
                    });
                    $('#it_myqueue').DataTable({ scrollX: true, autoWidth: false, pageLength: 25, order: [] });
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
                    <div class="queue-tabs">
                        <button type="button" class="queue-tab active" data-panel="panelDepartmentQueue" onclick="showQueuePanel('panelDepartmentQueue');">Department Queue</button>
                        <button type="button" class="queue-tab" data-panel="panelMyQueue" onclick="showQueuePanel('panelMyQueue');">My Queue</button>
                    </div>
                    <div id="panelDepartmentQueue" class="queue-panel active">
                    <div class="ticket-table-wrap">
                        <table class="table" id="it_ticketqueue" style="width: 100%;">
                            <thead>
                                <tr>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Actions</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; display: none;">Ticket Id</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Assign Ticket</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;"></th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Ticket #</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Ticket Raised On</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Expected TAT</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Code</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Location</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Request Related To</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Priority</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Subject</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Elapsed Time</th>
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
                                        <th class="sort border-top" style="text-wrap: nowrap;">Actions</th>
                                        <th class="sort border-top" style="text-wrap: nowrap; display: none;">Ticket Id</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">Ticket #</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">Ticket Raised On</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">Expected TAT</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">Code</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">Location</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">Request Related To</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">Priority</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">Subject</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">Status</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">Elapsed Time</th>
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
