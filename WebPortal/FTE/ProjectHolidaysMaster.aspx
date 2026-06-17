<%@ Page Title="" Language="C#" MasterPageFile="~/FTE/FTE.Master" AutoEventWireup="true" CodeBehind="ProjectHolidaysMaster.aspx.cs" Inherits="WebPortal.FTE.ProjectHolidaysMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .holiday-page {
            --holiday-blue: #2563eb;
            --holiday-ink: #0f172a;
            --holiday-muted: #64748b;
            --holiday-border: #d8e2ee;
            color: var(--holiday-ink);
            padding: 0px 0 28px;
        }

        .holiday-shell {
            width: 100%;
            max-width: 1480px;
            margin: 0 auto;
        }

        .holiday-hero {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            min-height: 78px;
            padding: 16px 18px;
            margin-bottom: 16px;
            border: 1px solid var(--holiday-border);
            border-radius: 8px;
            background: linear-gradient(135deg, #0f172a 0%, #1d4ed8 56%, #0891b2 100%);
            color: #fff;
            box-shadow: 0 14px 32px rgba(15, 23, 42, .12);
        }

        .holiday-title {
            display: flex;
            align-items: center;
            gap: 13px;
            min-width: 0;
        }

        .holiday-title .icon-box {
            width: 44px;
            height: 44px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.15);
            font-size: 18px;
        }

        .holiday-title h1 {
            margin: 0;
            font-size: 22px;
            font-weight: 800;
            line-height: 1.15;
            letter-spacing: 0;
        }

        .holiday-title p {
            margin: 4px 0 0;
            color: rgba(255,255,255,.78);
            font-size: 12px;
        }

        .holiday-chip {
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

        .holiday-chip:hover {
            color: #fff;
            text-decoration: none;
            background: rgba(255,255,255,.22);
        }

        .holiday-metrics {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 12px;
            margin-bottom: 16px;
        }

        .holiday-metric {
            min-height: 78px;
            padding: 14px 16px;
            border: 1px solid var(--holiday-border);
            border-radius: 8px;
            background: #fff;
            box-shadow: 0 8px 20px rgba(31, 41, 55, .05);
        }

        .holiday-metric span {
            display: block;
            color: var(--holiday-muted);
            font-size: 12px;
            font-weight: 800;
            text-transform: uppercase;
        }

        .holiday-metric strong {
            display: block;
            margin-top: 8px;
            color: var(--holiday-ink);
            font-size: 24px;
            line-height: 1;
        }

        .holiday-panel {
            margin-bottom: 16px;
            border: 1px solid var(--holiday-border);
            border-radius: 8px;
            background: #fff;
            box-shadow: 0 10px 28px rgba(15, 23, 42, .07);
            overflow: hidden;
        }

        .holiday-panel-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 14px 16px;
            border-bottom: 1px solid var(--holiday-border);
            background: #f8fafc;
        }

        .holiday-panel-header h2 {
            margin: 0;
            color: #1e3356;
            font-size: 16px;
            font-weight: 800;
            letter-spacing: 0;
        }

        .holiday-panel-body {
            padding: 16px;
        }

        .holiday-form-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 13px 16px;
            align-items: end;
        }

        .holiday-field label {
            display: block;
            margin: 0 0 6px;
            color: #1e3356;
            font-size: 11px;
            font-weight: 800 !important;
            border: 0 !important;
        }

        .holiday-page .form-control {
            width: 100% !important;
            min-height: 38px;
            border: 1px solid var(--holiday-border) !important;
            border-radius: 8px !important;
            box-shadow: none !important;
            font-size: 12px !important;
        }

        .holiday-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            padding-top: 16px;
        }

        .holiday-actions .btn {
            min-height: 36px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 800;
        }

        .holiday-alert {
            display: none;
            margin-bottom: 14px;
            border-radius: 8px;
            font-weight: 700;
        }

        .table-shell {
            width: 100%;
            overflow-x: hidden;
            overflow-y: visible;
            border: 1px solid var(--holiday-border);
            border-radius: 8px;
            background: #fff;
        }

        .holiday-page table.dataTable,
        .holiday-page .table {
            width: 100% !important;
            margin: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0 !important;
        }

        .holiday-page table.dataTable thead th,
        .holiday-page .table thead th {
            white-space: nowrap !important;
            background: #f8fafc !important;
            color: #1e3356 !important;
            border-bottom: 1px solid var(--holiday-border) !important;
            padding: 10px 12px !important;
            font-size: 11px !important;
            font-weight: 900 !important;
            vertical-align: middle !important;
        }

        .holiday-page table.dataTable tbody td,
        .holiday-page .table tbody td {
            background: #fff !important;
            border-top: 1px solid #eef2f7 !important;
            color: #1f2937 !important;
            padding: 10px 12px !important;
            font-size: 12px !important;
            vertical-align: middle !important;
        }

        .holiday-page .dataTables_wrapper {
            width: 100%;
            max-width: 100%;
            box-sizing: border-box;
            padding: 12px;
            overflow-x: hidden;
        }

        .holiday-page .dataTables_filter input {
            max-width: 180px;
        }

        .holiday-page .dt-buttons .btn,
        .holiday-page .dt-button {
            border-radius: 8px !important;
            border: 1px solid var(--holiday-border) !important;
            background: #fff !important;
            color: #1e3356 !important;
            font-size: 12px !important;
            font-weight: 800 !important;
            padding: 6px 10px !important;
            margin-right: 6px;
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

        @media (max-width: 900px) {
            .holiday-form-grid,
            .holiday-metrics {
                grid-template-columns: 1fr;
            }

            .holiday-hero,
            .holiday-panel-header,
            .holiday-actions {
                align-items: flex-start;
                flex-direction: column;
            }

            .holiday-chip,
            .holiday-actions .btn {
                justify-content: center;
                width: 100%;
            }
        }
    </style>

    <script>
        var holidayTable = null;
        var holidayRows = [];
        var loadingDepth = 0;
        var loadingGuard = null;

        $(document).ready(function () {
            wireHolidayEvents();
            loadProjects();
            loadHolidays();
        });

        function wireHolidayEvents() {
            $('#btnSaveHoliday').on('click', saveHoliday);
            $('#btnResetHoliday').on('click', resetHolidayForm);
        }

        function loadProjects() {
            setLoading(true);
            PageMethods.GetAllProjectByUserRights(function (result) {
                try {
                    var rows = parseResult(result);
                    var $project = $('#holidayProject');
                    $project.empty().append('<option value="">Select project</option>');

                    $.each(rows, function (_, row) {
                        var projectId = getValue(row, ['ProjectId', 'ProjectID']);
                        var projectName = getValue(row, ['ProjectName', 'Project']);

                        if (projectId) {
                            $project.append($('<option/>', { value: projectId, text: projectName || projectId }));
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

        function loadHolidays() {
            setLoading(true);
            PageMethods.GetClientHoliday(function (result) {
                try {
                    holidayRows = parseResult(result);
                    bindHolidayTable(holidayRows);
                    updateMetrics(holidayRows);
                }
                catch (ex) {
                    showMessage('Unable to load holidays. ' + ex.message, 'danger');
                }
                finally {
                    setLoading(false);
                }
            }, requestFailed);
        }

        function saveHoliday() {
            var projectId = $('#holidayProject').val();
            var holidayDate = $('#holidayDate').val();

            if (!projectId || !holidayDate) {
                showMessage('Please select project and holiday date.', 'warning');
                return;
            }

            setLoading(true);
            PageMethods.InsertClientHoliday(parseInt(projectId, 10), formatDateForServer(holidayDate), function (returnValue) {
                try {
                    if (parseInt(returnValue, 10) > 0) {
                        showMessage('Project holiday saved successfully.', 'success');
                        resetHolidayForm();
                        loadHolidays();
                    }
                    else {
                        showMessage('Unable to save project holiday.', 'danger');
                    }
                }
                catch (ex) {
                    showMessage('Unable to complete save. ' + ex.message, 'danger');
                }
                finally {
                    setLoading(false);
                }
            }, requestFailed);
        }

        function bindHolidayTable(rows) {
            if (holidayTable) {
                holidayTable.clear().rows.add(rows).draw();
                return;
            }

            holidayTable = $('#tableProjectHolidays').DataTable({
                data: rows,
                responsive: true,
                autoWidth: false,
                pageLength: 50,
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
                        className: 'text-center',
                        render: function (_data, _type, _row, meta) {
                            return meta.row + 1;
                        }
                    },
                    { data: null, render: function (_data, _type, row) { return escapeHtml(getValue(row, ['ProjectName', 'Project'])); } },
                    { data: null, render: function (_data, _type, row) { return escapeHtml(formatDisplayDate(getValue(row, ['Date', 'HolidayDate']))); } },
                    { data: null, render: function (_data, _type, row) { return escapeHtml(getValue(row, ['AddedByName', 'AddedBy'])); } },
                    { data: null, render: function (_data, _type, row) { return escapeHtml(formatDisplayDate(getValue(row, ['AddedDate']))); } }
                ]
            });
        }

        function updateMetrics(rows) {
            var projectMap = {};
            var latest = '';

            $.each(rows, function (_, row) {
                var projectId = getValue(row, ['ProjectId', 'ProjectID', 'ProjectName']);
                var date = formatDisplayDate(getValue(row, ['Date', 'HolidayDate']));

                if (projectId) {
                    projectMap[projectId] = true;
                }

                if (date) {
                    latest = date;
                }
            });

            $('#metricTotalHolidays').text(rows.length);
            $('#metricProjects').text(Object.keys(projectMap).length);
            $('#metricLatestHoliday').text(latest || '-');
        }

        function resetHolidayForm() {
            $('#holidayProject').val('');
            $('#holidayDate').val('');
        }

        function showMessage(message, type) {
            var $alert = $('#holidayAlert');
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
                        $('#btnSaveHoliday, #btnResetHoliday').prop('disabled', false);
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

            $('#btnSaveHoliday, #btnResetHoliday').prop('disabled', loadingDepth > 0);
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

        function formatDisplayDate(value) {
            if (!value) {
                return '';
            }

            var text = String(value);
            var dotNetDate = /\/Date\((\d+)(?:[+-]\d+)?\)\//.exec(text);
            if (dotNetDate) {
                return formatDateObject(new Date(parseInt(dotNetDate[1], 10)));
            }

            var isoDate = /^(\d{4})-(\d{2})-(\d{2})/.exec(text);
            if (isoDate) {
                return formatDateObject(new Date(parseInt(isoDate[1], 10), parseInt(isoDate[2], 10) - 1, parseInt(isoDate[3], 10)));
            }

            return text;
        }

        function formatDateForServer(value) {
            if (!value) {
                return '';
            }

            var parts = value.split('-');
            if (parts.length !== 3) {
                return value;
            }

            var date = new Date(parseInt(parts[0], 10), parseInt(parts[1], 10) - 1, parseInt(parts[2], 10));
            return formatDateObject(date);
        }

        function formatDateObject(date) {
            if (!date || isNaN(date.getTime())) {
                return '';
            }

            return date.toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' }).replace(/ /g, '-');
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

    <div class="holiday-page">
        <div class="holiday-shell">
            <header class="holiday-hero">
                <div class="holiday-title">
                    <span class="icon-box"><i class="fas fa-calendar-check"></i></span>
                    <div>
                        <h1>Project Holiday Master</h1>
                        <p>Maintain client holidays for project-wise FTE billing and attendance.</p>
                    </div>
                </div>
                <a class="holiday-chip" href="#url">
                    <i class="fas fa-layer-group"></i>
                    FTE Master
                </a>
            </header>

            <div class="holiday-metrics" style="display:none;">
                <div class="holiday-metric">
                    <span>Total Holidays</span>
                    <strong id="metricTotalHolidays">0</strong>
                </div>
                <div class="holiday-metric">
                    <span>Projects</span>
                    <strong id="metricProjects">0</strong>
                </div>
                <div class="holiday-metric">
                    <span>Latest Holiday</span>
                    <strong id="metricLatestHoliday">-</strong>
                </div>
            </div>

            <div id="holidayAlert" class="alert holiday-alert" role="alert"></div>

            <section class="holiday-panel">
                <div class="holiday-panel-header">
                    <h2><i class="fas fa-plus-circle"></i>&nbsp; Holiday Details</h2>
                </div>
                <div class="holiday-panel-body">
                    <div class="holiday-form-grid">
                        <div class="holiday-field">
                            <label for="holidayProject">Project</label>
                            <select id="holidayProject" class="form-control">
                                <option value="">Select project</option>
                            </select>
                        </div>
                        <div class="holiday-field">
                            <label for="holidayDate">Client Holiday</label>
                            <input type="date" id="holidayDate" class="form-control" />
                        </div>
                    </div>

                    <div class="holiday-actions">
                        <button type="button" id="btnResetHoliday" class="btn btn-outline-secondary">
                            <i class="fas fa-undo"></i>
                            Reset
                        </button>
                        <button type="button" id="btnSaveHoliday" class="btn btn-primary">
                            <i class="fas fa-save"></i>
                            Save Holiday
                        </button>
                    </div>
                </div>
            </section>

            <section class="holiday-panel">
                <div class="holiday-panel-header">
                    <h2><i class="fas fa-table"></i>&nbsp; Project Holiday Report</h2>
                    <small>Current records</small>
                </div>
                <div class="holiday-panel-body">
                    <div class="table-shell">
                        <table id="tableProjectHolidays" class="table table-bordered table-hover">
                            <thead>
                                <tr>
                                    <th style="width: 70px;">Sr #</th>
                                    <th>Project #</th>
                                    <th>Client Holiday</th>
                                    <th>Added By</th>
                                    <th>Added Date</th>
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
