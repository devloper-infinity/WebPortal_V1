<%@ Page Title="" Language="C#" MasterPageFile="~/FTE/FTE.Master" AutoEventWireup="true" CodeBehind="FTEAttendance.aspx.cs" Inherits="WebPortal.FTE.FTEAttendance" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .ftea-page {
            --ftea-blue: #2563eb;
            --ftea-ink: #0f172a;
            --ftea-muted: #64748b;
            --ftea-border: #d8e2ee;
            color: var(--ftea-ink);
            padding: 0px 0 28px;
        }

        .ftea-shell {
            width: 100%;
            max-width: 1480px;
            margin: 0 auto;
        }

        .ftea-hero {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            min-height: 78px;
            padding: 16px 18px;
            margin-bottom: 16px;
            border: 1px solid var(--ftea-border);
            border-radius: 8px;
            background: linear-gradient(135deg, #0f172a 0%, #1d4ed8 56%, #0891b2 100%);
            color: #fff;
            box-shadow: 0 14px 32px rgba(15, 23, 42, .12);
        }

        .ftea-title {
            display: flex;
            align-items: center;
            gap: 13px;
            min-width: 0;
        }

        .ftea-title .icon-box {
            width: 44px;
            height: 44px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.15);
            font-size: 18px;
        }

        .ftea-title h1 {
            margin: 0;
            font-size: 22px;
            font-weight: 800;
            line-height: 1.15;
            letter-spacing: 0;
        }

        .ftea-title p {
            margin: 4px 0 0;
            color: rgba(255,255,255,.78);
            font-size: 12px;
        }

        .ftea-chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 12px;
            border-radius: 999px;
            background: rgba(255,255,255,.14);
            border: 1px solid rgba(255,255,255,.26);
            color: #fff;
            font-size: 12px;
            font-weight: 800;
            white-space: nowrap;
        }

        .ftea-chip:hover {
            color: #fff;
            text-decoration: none;
            background: rgba(255,255,255,.22);
        }

        .ftea-metrics {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 12px;
            margin-bottom: 16px;
        }

        .ftea-metric {
            min-height: 78px;
            padding: 14px 16px;
            border: 1px solid var(--ftea-border);
            border-radius: 8px;
            background: #fff;
            box-shadow: 0 8px 20px rgba(31, 41, 55, .05);
        }

        .ftea-metric span {
            display: block;
            color: var(--ftea-muted);
            font-size: 12px;
            font-weight: 800;
            text-transform: uppercase;
        }

        .ftea-metric strong {
            display: block;
            margin-top: 8px;
            color: var(--ftea-ink);
            font-size: 24px;
            line-height: 1;
        }

        .ftea-panel {
            margin-bottom: 16px;
            border: 1px solid var(--ftea-border);
            border-radius: 8px;
            background: #fff;
            box-shadow: 0 10px 28px rgba(15, 23, 42, .07);
            overflow: hidden;
        }

        .ftea-panel-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 14px 16px;
            border-bottom: 1px solid var(--ftea-border);
            background: #f8fafc;
        }

        .ftea-panel-header h2 {
            margin: 0;
            color: #1e3356;
            font-size: 16px;
            font-weight: 800;
            letter-spacing: 0;
        }

        .ftea-panel-body {
            padding: 16px;
        }

        .ftea-form-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 13px 16px;
            align-items: end;
        }

        .ftea-field label {
            display: block;
            margin: 0 0 6px;
            color: #1e3356;
            font-size: 11px;
            font-weight: 800 !important;
            border: 0 !important;
        }

        .ftea-page .form-control {
            width: 100% !important;
            min-height: 38px;
            border: 1px solid var(--ftea-border) !important;
            border-radius: 8px !important;
            box-shadow: none !important;
            font-size: 12px !important;
        }

        .ftea-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            padding-top: 16px;
        }

        .ftea-actions .btn {
            min-height: 36px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 800;
        }

        .ftea-alert {
            display: none;
            margin-bottom: 14px;
            border-radius: 8px;
            font-weight: 700;
        }

        .table-shell {
            width: 100%;
            overflow-x: hidden;
            overflow-y: visible;
            border: 1px solid var(--ftea-border);
            border-radius: 8px;
            background: #fff;
        }

        #tableFTEAttendance {
            table-layout: fixed;
        }

        .ftea-page table.dataTable,
        .ftea-page .table {
            width: 100% !important;
            margin: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0 !important;
        }

        .ftea-page table.dataTable thead th,
        .ftea-page .table thead th {
            white-space: nowrap !important;
            background: #f8fafc !important;
            color: #1e3356 !important;
            border-bottom: 1px solid var(--ftea-border) !important;
            padding: 10px 12px !important;
            font-size: 11px !important;
            font-weight: 900 !important;
            vertical-align: middle !important;
        }

        .ftea-page table.dataTable tbody td,
        .ftea-page .table tbody td {
            background: #fff !important;
            border-top: 1px solid #eef2f7 !important;
            color: #1f2937 !important;
            padding: 10px 12px !important;
            font-size: 12px !important;
            vertical-align: middle !important;
        }

        .ftea-page .dataTables_wrapper {
            width: 100%;
            max-width: 100%;
            box-sizing: border-box;
            padding: 12px;
            overflow-x: hidden;
        }

        .ftea-page .dataTables_filter input {
            max-width: 180px;
        }

        .ftea-page .dt-buttons .btn,
        .ftea-page .dt-button {
            border-radius: 8px !important;
            border: 1px solid var(--ftea-border) !important;
            background: #fff !important;
            color: #1e3356 !important;
            font-size: 12px !important;
            font-weight: 800 !important;
            padding: 6px 10px !important;
            margin-right: 6px;
        }

        .date-check {
            width: 18px;
            height: 18px;
            cursor: pointer;
        }

        #load1.loading {
            display: none;
            position: fixed !important;
            top: 0 !important;
            left: 0 !important;
            right: 0 !important;
            bottom: 0 !important;
            width: 100vw !important;
            height: 100vh !important;
            margin: 0 !important;
            padding: 0 !important;
            background: rgba(15, 23, 42, .42) !important;
            z-index: 2147483000 !important;
            text-align: center;
            backdrop-filter: blur(4px);
        }

        #load1 .loading-inner {
            position: fixed !important;
            top: 50vh !important;
            left: 50vw !important;
            width: 280px;
            max-width: calc(100vw - 32px);
            margin-top: -86px;
            margin-left: -140px;
            padding: 24px 22px;
            text-align: center;
            background: #fff;
            border-radius: 22px;
            box-shadow: 0 24px 55px rgba(15, 23, 42, .28);
        }

        #load1.loading img {
            display: block;
            width: 82px;
            max-width: 82px;
            height: auto;
            margin: 0 auto;
        }

        .loading-text {
            margin-top: 10px;
            color: #0f172a;
            font-size: 13px;
            font-weight: 800;
        }

        @media (max-width: 1100px) {
            .ftea-form-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 760px) {
            .ftea-hero,
            .ftea-panel-header,
            .ftea-actions {
                align-items: flex-start;
                flex-direction: column;
            }

            .ftea-form-grid,
            .ftea-metrics {
                grid-template-columns: 1fr;
            }

            .ftea-chip,
            .ftea-actions .btn {
                justify-content: center;
                width: 100%;
            }
        }
    </style>

    <script>
        var attendanceTable = null;
        var attendanceRows = [];
        var loadingDepth = 0;
        var loadingGuard = null;

        $(document).ready(function () {
            wireAttendanceEvents();
            loadProjects();
            bindAttendanceTable([]);
        });

        function wireAttendanceEvents() {
            $('#fteAttProject').on('change', function () {
                resetBillingControls();
                loadBillingCycle();
            });

            $('#fteAttBillingCycle').on('change', function () {
                resetPeriodControls();
                loadBillingPeriods();
            });

            $('#fteAttBillingPeriod').on('change', function () {
                resetUserControl();
                loadUsers();
            });

            $('#btnShowAttendanceDates').on('click', function () {
                loadAttendanceDates();
            });

            $('#btnAddAttendance').on('click', function () {
                addAttendance();
            });

            $('#selectAllDates').on('change', function () {
                $('.date-check').prop('checked', $(this).is(':checked'));
                updateSelectedCount();
            });

            $(document).on('change', '.date-check', updateSelectedCount);
        }

        function loadProjects() {
            setLoading(true);
            PageMethods.GetAllProjectByUserRights(function (result) {
                try {
                    var rows = parseResult(result);
                    var $project = $('#fteAttProject');
                    $project.empty().append('<option value="">Select project</option>');

                    $.each(rows, function (_, row) {
                        var projectId = getValue(row, ['ProjectId', 'ProjectID']);
                        var projectName = getValue(row, ['ProjectName', 'Project']);

                        if (projectId) {
                            $project.append($('<option/>', {
                                value: projectId,
                                text: projectName || projectId
                            }));
                        }
                    });
                }
                catch (ex) {
                    showMessage('Unable to load projects. ' + ex.message, 'danger');
                }
                finally {
                    setLoading(false);
                }
            }, requestFailed);
        }

        function loadBillingCycle() {
            var projectId = $('#fteAttProject').val();

            if (!projectId) {
                return;
            }

            setLoading(true);
            PageMethods.GetBillingCycleByProject(parseInt(projectId, 10), function (billingCycle) {
                try {
                    var $cycle = $('#fteAttBillingCycle');
                    $cycle.empty().append('<option value="">Select billing cycle</option>');

                    if (billingCycle) {
                        $cycle.append($('<option/>', { value: billingCycle, text: billingCycle }));
                    }
                }
                catch (ex) {
                    showMessage('Unable to load billing cycle. ' + ex.message, 'danger');
                }
                finally {
                    setLoading(false);
                }
            }, requestFailed);
        }

        function loadBillingPeriods() {
            var projectId = $('#fteAttProject').val();
            var cycle = $('#fteAttBillingCycle').val();

            if (!projectId || !cycle) {
                return;
            }

            setLoading(true);
            PageMethods.GetBillingPeriods(parseInt(projectId, 10), cycle, function (result) {
                try {
                    var rows = parseResult(result);
                    var $period = $('#fteAttBillingPeriod');
                    $period.empty().append('<option value="">Select billing period</option>');

                    $.each(rows, function (_, row) {
                        var text = typeof row === 'string' ? row : getValue(row, ['BillingPeriod', 'Period', 'Text']);

                        if (text) {
                            $period.append($('<option/>', { value: text, text: text }));
                        }
                    });
                }
                catch (ex) {
                    showMessage('Unable to load billing periods. ' + ex.message, 'danger');
                }
                finally {
                    setLoading(false);
                }
            }, requestFailed);
        }

        function loadUsers() {
            var projectId = $('#fteAttProject').val();

            if (!projectId) {
                return;
            }

            setLoading(true);
            PageMethods.GetFTEUsers(parseInt(projectId, 10), function (result) {
                try {
                    var rows = parseResult(result);
                    var $user = $('#fteAttUser');
                    $user.empty().append('<option value="">Select employee</option>');

                    $.each(rows, function (_, row) {
                        var employeeId = getValue(row, ['EmployeeID', 'EmployeeId']);
                        var name = getValue(row, ['Pseudoname', 'PseudoName', 'EmployeeName', 'Name']);

                        if (employeeId) {
                            $user.append($('<option/>', {
                                value: employeeId,
                                text: name || employeeId
                            }));
                        }
                    });
                }
                catch (ex) {
                    showMessage('Unable to load employees. ' + ex.message, 'danger');
                }
                finally {
                    setLoading(false);
                }
            }, requestFailed);
        }

        function loadAttendanceDates() {
            var projectId = $('#fteAttProject').val();
            var period = $('#fteAttBillingPeriod').val();
            var userId = $('#fteAttUser').val();

            if (!projectId || !period || !userId) {
                showMessage('Please select project, billing period, and employee.', 'warning');
                return;
            }

            setLoading(true);
            PageMethods.GetFTEAttendance(parseInt(projectId, 10), period, parseInt(userId, 10), function (result) {
                try {
                    attendanceRows = parseResult(result);
                    bindAttendanceTable(attendanceRows);
                    $('#metricAvailableDates').text(attendanceRows.length);
                    updateSelectedCount();
                }
                catch (ex) {
                    showMessage('Unable to load attendance dates. ' + ex.message, 'danger');
                }
                finally {
                    setLoading(false);
                }
            }, requestFailed);
        }

        function addAttendance() {
            var projectId = $('#fteAttProject').val();
            var userId = $('#fteAttUser').val();
            var selectedDates = getSelectedDates();

            if (!projectId || !userId) {
                showMessage('Please select project and employee.', 'warning');
                return;
            }

            if (selectedDates.length === 0) {
                showMessage('Please select at least one attendance date.', 'warning');
                return;
            }

            setLoading(true);
            PageMethods.InsertFTEAttendance(
                parseInt(projectId, 10),
                parseInt(userId, 10),
                selectedDates.join('|'),
                function (result) {
                    try {
                        var summary = parseResult(result);
                        var saved = getValue(summary, ['Saved']);
                        var failed = getValue(summary, ['Failed']);
                        showMessage(saved + ' attendance date(s) saved.' + (failed > 0 ? ' ' + failed + ' failed.' : ''), failed > 0 ? 'warning' : 'success');
                        loadAttendanceDates();
                    }
                    catch (ex) {
                        showMessage('Attendance saved, but the response could not be read. ' + ex.message, 'warning');
                    }
                    finally {
                        setLoading(false);
                    }
                },
                requestFailed
            );
        }

        function bindAttendanceTable(rows) {
            if (attendanceTable) {
                attendanceTable.clear().rows.add(rows).draw();
                $('#selectAllDates').prop('checked', false);
                return;
            }

            attendanceTable = $('#tableFTEAttendance').DataTable({
                data: rows,
                responsive: true,
                autoWidth: false,
                paging: false,
                order: [[1, 'asc']],
                dom: "<'row align-items-center mb-2'<'col-md-4'l><'col-md-4 text-center'B><'col-md-4'f>>" +
                    "rt<'row align-items-center mt-2'<'col-md-5'i><'col-md-7'p>>",
                buttons: [
                    { extend: 'excelHtml5', text: '<i class="fas fa-file-excel"></i> Excel', className: 'btn btn-sm' },
                    { extend: 'print', text: '<i class="fas fa-print"></i> Print', className: 'btn btn-sm' }
                ],
                columns: [
                    {
                        data: null,
                        orderable: false,
                        searchable: false,
                        className: 'text-center',
                        render: function (_data, _type, row) {
                            var dateValue = escapeHtml(getValue(row, ['Dates', 'Date']));
                            return '<input type="checkbox" class="date-check" value="' + dateValue + '" />';
                        }
                    },
                    {
                        data: null,
                        className: 'text-center',
                        render: function (_data, _type, _row, meta) {
                            return meta.row + 1;
                        }
                    },
                    {
                        data: null,
                        render: function (_data, _type, row) {
                            return escapeHtml(getValue(row, ['Dates', 'Date']));
                        }
                    }
                ]
            });
        }

        function getSelectedDates() {
            var dates = [];

            $('.date-check:checked').each(function () {
                dates.push($(this).val());
            });

            return dates;
        }

        function updateSelectedCount() {
            $('#metricSelectedDates').text(getSelectedDates().length);
        }

        function resetBillingControls() {
            $('#fteAttBillingCycle').empty().append('<option value="">Select billing cycle</option>');
            resetPeriodControls();
        }

        function resetPeriodControls() {
            $('#fteAttBillingPeriod').empty().append('<option value="">Select billing period</option>');
            resetUserControl();
        }

        function resetUserControl() {
            $('#fteAttUser').empty().append('<option value="">Select employee</option>');
            attendanceRows = [];
            bindAttendanceTable([]);
            $('#metricAvailableDates').text('0');
            $('#metricSelectedDates').text('0');
            $('#selectAllDates').prop('checked', false);
        }

        function showMessage(message, type) {
            var $alert = $('#attendanceAlert');
            $alert
                .removeClass('alert-success alert-warning alert-danger')
                .addClass('alert-' + type)
                .html(escapeHtml(message))
                .fadeIn(120);

            window.setTimeout(function () {
                $alert.fadeOut(180);
            }, 5000);
        }

        function requestFailed(error) {
            setLoading(false);
            showMessage(error && error.get_message ? error.get_message() : 'Request failed. Please try again.', 'danger');
        }

        function setLoading(isLoading) {
            if (isLoading) {
                loadingDepth += 1;
                $('#load1').stop(true, true).css('display', 'block');

                if (!loadingGuard) {
                    loadingGuard = window.setTimeout(function () {
                        loadingDepth = 0;
                        $('#load1').stop(true, true).css('display', 'none');
                        $('#btnShowAttendanceDates, #btnAddAttendance').prop('disabled', false);
                        loadingGuard = null;
                        showMessage('Loading is taking longer than expected. Please refresh and try again.', 'warning');
                    }, 30000);
                }
            }
            else {
                loadingDepth = Math.max(0, loadingDepth - 1);

                if (loadingDepth === 0) {
                    $('#load1').stop(true, true).css('display', 'none');

                    if (loadingGuard) {
                        window.clearTimeout(loadingGuard);
                        loadingGuard = null;
                    }
                }
            }

            $('#btnShowAttendanceDates, #btnAddAttendance').prop('disabled', loadingDepth > 0);
        }

        function parseResult(result) {
            var payload = result && result.d ? result.d : result;

            if (!payload) {
                return [];
            }

            if ($.isArray(payload) || typeof payload === 'object') {
                return payload;
            }

            return JSON.parse(payload);
        }

        function getValue(row, keys) {
            for (var index = 0; index < keys.length; index++) {
                if (row && row[keys[index]] !== undefined && row[keys[index]] !== null) {
                    return row[keys[index]];
                }
            }

            return '';
        }

        function escapeHtml(value) {
            return $('<div/>').text(value === undefined || value === null ? '' : value).html();
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <div class="loading-inner">
            <img src="../images/Load_1.gif" alt="Loading" />
            <div class="loading-text">One moment, please...</div>
        </div>
    </div>

    <div class="ftea-page">
        <div class="ftea-shell">
            <header class="ftea-hero">
                <div class="ftea-title">
                    <span class="icon-box"><i class="fas fa-user-check"></i></span>
                    <div>
                        <h1>FTE Attendance</h1>
                        <p>Select billing period dates and add attendance for configured FTE users.</p>
                    </div>
                </div>
                <a class="ftea-chip" href="FTEConfiguration.aspx">
                    <i class="fas fa-sliders-h"></i>
                    FTE Configuration
                </a>
            </header>

            <div class="ftea-metrics" style="display:none;">
                <div class="ftea-metric">
                    <span>Available Dates</span>
                    <strong id="metricAvailableDates">0</strong>
                </div>
                <div class="ftea-metric">
                    <span>Selected Dates</span>
                    <strong id="metricSelectedDates">0</strong>
                </div>
                <div class="ftea-metric">
                    <span>Attendance Status</span>
                    <strong id="metricStatus">Ready</strong>
                </div>
            </div>

            <div id="attendanceAlert" class="alert ftea-alert" role="alert"></div>

            <section class="ftea-panel">
                <div class="ftea-panel-header">
                    <h2><i class="fas fa-filter"></i>&nbsp; Attendance Filters</h2>
                </div>
                <div class="ftea-panel-body">
                    <div class="ftea-form-grid">
                        <div class="ftea-field">
                            <label for="fteAttProject">Project</label>
                            <select id="fteAttProject" class="form-control">
                                <option value="">Select project</option>
                            </select>
                        </div>
                        <div class="ftea-field">
                            <label for="fteAttBillingCycle">Billing Cycle</label>
                            <select id="fteAttBillingCycle" class="form-control">
                                <option value="">Select billing cycle</option>
                            </select>
                        </div>
                        <div class="ftea-field">
                            <label for="fteAttBillingPeriod">Billing Period</label>
                            <select id="fteAttBillingPeriod" class="form-control">
                                <option value="">Select billing period</option>
                            </select>
                        </div>
                        <div class="ftea-field">
                            <label for="fteAttUser">Employee</label>
                            <select id="fteAttUser" class="form-control">
                                <option value="">Select employee</option>
                            </select>
                        </div>
                    </div>

                    <div class="ftea-actions">
                        <button type="button" id="btnShowAttendanceDates" class="btn btn-primary">
                            <i class="fas fa-search"></i>
                            Show Dates
                        </button>
                        <button type="button" id="btnAddAttendance" class="btn btn-success">
                            <i class="fas fa-plus-circle"></i>
                            Add Attendance
                        </button>
                    </div>
                </div>
            </section>

            <section class="ftea-panel">
                <div class="ftea-panel-header">
                    <h2><i class="fas fa-calendar-alt"></i>&nbsp; Attendance Dates</h2>
                    <label class="m-0">
                        <input type="checkbox" id="selectAllDates" class="date-check" />
                        Select All
                    </label>
                </div>
                <div class="ftea-panel-body">
                    <div class="table-shell">
                        <table id="tableFTEAttendance" class="table table-bordered table-hover">
                            <thead>
                                <tr>
                                    <th style="width: 70px;">Select</th>
                                    <th style="width: 80px;">Sr #</th>
                                    <th>Date</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </section>
        </div>
    </div>
</asp:Content>
