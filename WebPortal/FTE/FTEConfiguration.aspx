<%@ Page Title="" Language="C#" MasterPageFile="~/FTE/FTE.Master" AutoEventWireup="true" CodeBehind="FTEConfiguration.aspx.cs" Inherits="WebPortal.FTE.FTEConfiguration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .fte-page {
            --fte-blue: #2563eb;
            --fte-cyan: #0891b2;
            --fte-ink: #0f172a;
            --fte-muted: #64748b;
            --fte-border: #d8e2ee;
            --fte-surface: #ffffff;
            --fte-soft: #f4f7fb;
            color: var(--fte-ink);
            padding: 0px 0 28px;
        }

        .fte-shell {
            width: 100%;
            max-width: 1480px;
            margin: 0 auto;
        }

        .fte-hero {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            min-height: 78px;
            padding: 16px 18px;
            margin-bottom: 16px;
            border: 1px solid var(--fte-border);
            border-radius: 8px;
            background: linear-gradient(135deg, #0f172a 0%, #1d4ed8 56%, #0891b2 100%);
            color: #ffffff;
            box-shadow: 0 14px 32px rgba(15, 23, 42, .12);
        }

        .fte-title {
            display: flex;
            align-items: center;
            gap: 13px;
            min-width: 0;
        }

        .fte-title .icon-box {
            width: 44px;
            height: 44px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: rgba(255, 255, 255, .15);
            font-size: 18px;
        }

        .fte-title h1 {
            margin: 0;
            font-size: 22px;
            font-weight: 800;
            line-height: 1.15;
            letter-spacing: 0;
        }

        .fte-title p {
            margin: 4px 0 0;
            color: rgba(255, 255, 255, .78);
            font-size: 12px;
        }

        .fte-quick-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            min-height: 36px;
            padding: 8px 12px;
            border-radius: 999px;
            color: #ffffff;
            background: rgba(255, 255, 255, .14);
            border: 1px solid rgba(255, 255, 255, .26);
            font-size: 12px;
            font-weight: 800;
            white-space: nowrap;
        }

        .fte-quick-link:hover {
            color: #ffffff;
            text-decoration: none;
            background: rgba(255, 255, 255, .22);
        }

        .fte-metrics {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 12px;
            margin-bottom: 16px;
        }

        .fte-metric {
            min-height: 78px;
            padding: 14px 16px;
            border: 1px solid #d8dee9;
            border-radius: 6px;
            background: #ffffff;
        }

        .fte-metric span {
            display: block;
            font-size: 12px;
            color: #667085;
            font-weight: 700;
            text-transform: uppercase;
        }

        .fte-metric strong {
            display: block;
            margin-top: 8px;
            font-size: 24px;
            line-height: 1;
            color: #1f2937;
        }

        .fte-panel {
            margin-bottom: 16px;
            border: 1px solid #d8dee9;
            border-radius: 6px;
            background: #ffffff;
            box-shadow: 0 8px 20px rgba(31, 41, 55, .06);
        }

        .fte-panel-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 14px 16px;
            border-bottom: 1px solid #e7ebf0;
        }

        .fte-panel-header h2 {
            margin: 0;
            color: #1f2937;
            font-size: 15px;
            font-weight: 700;
            letter-spacing: 0;
        }

        .fte-panel-header small {
            color: #667085;
            font-weight: 600;
        }

        .fte-panel-body {
            padding: 16px;
        }

        .fte-form-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 14px 16px;
        }

        .fte-field label {
            display: flex;
            align-items: center;
            gap: 6px;
            min-height: 20px;
            margin-bottom: 6px;
            color: #344054;
            font-size: 13px;
            font-weight: 700 !important;
            border: 0 !important;
        }

        .fte-field .form-control {
            min-height: 38px;
            border-color: #cfd6df;
            border-radius: 4px;
            font-size: 14px;
        }

        .fte-actions {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 10px;
            padding-top: 16px;
        }

        .fte-actions .btn {
            min-height: 38px;
            border-radius: 4px;
            font-weight: 700;
        }

        .fte-alert {
            display: none;
            margin-bottom: 14px;
            border-radius: 4px;
            font-weight: 600;
        }

        .fte-table-wrap {
            overflow-x: auto;
        }

        #tableFteConfiguration {
            width: 100% !important;
        }

        #tableFteConfiguration thead th {
            color: #1f2937;
            background: #f4f7fb;
            border-bottom: 1px solid #d8dee9;
            font-size: 12px;
            text-transform: uppercase;
            vertical-align: middle;
            white-space: nowrap;
        }

        #tableFteConfiguration tbody td {
            vertical-align: middle;
            color: #344054;
            font-size: 13px;
        }

        .fte-badge {
            display: inline-flex;
            align-items: center;
            min-height: 24px;
            padding: 3px 9px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
        }

        .fte-badge-yes {
            color: #086c4f;
            background: #dff7ed;
        }

        .fte-badge-no {
            color: #92400e;
            background: #ffedd5;
        }

        .fte-badge-neutral {
            color: #475467;
            background: #eef2f6;
        }

        .action-column {
            width: 72px;
        }

        .dataTables_wrapper .dataTables_filter {
            text-align: right;
        }

        .dataTables_wrapper .dataTables_filter input,
        .dataTables_wrapper .dataTables_length select {
            border: 1px solid #cfd6df;
            border-radius: 4px;
        }

        div.dt-buttons {
            float: none;
            padding-left: 0;
            text-align: center;
        }

        .dt-buttons .btn {
            border-radius: 4px;
            font-weight: 700;
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
            background: #ffffff;
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
            font-size: 13px;
            font-weight: 800;
            color: #0f172a;
        }

        @media (max-width: 991.98px) {
            .fte-form-grid,
            .fte-metrics {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 767.98px) {
            .fte-hero {
                align-items: flex-start;
                flex-direction: column;
            }

            .fte-panel-header,
            .fte-actions {
                align-items: stretch;
                flex-direction: column;
            }

            .fte-quick-link,
            .fte-actions .btn {
                justify-content: center;
                width: 100%;
            }

            .fte-form-grid,
            .fte-metrics {
                grid-template-columns: 1fr;
            }

            .dataTables_wrapper .dataTables_filter {
                margin-top: 8px;
                text-align: left;
            }
        }
    </style>

    <script>
        var configurationTable = null;
        var configurationRows = [];
        var loadingDepth = 0;
        var loadingGuard = null;

        $(document).ready(function () {
            wireFteConfigurationEvents();
            loadProjects(function () {
                loadConfigurations(function () {
                    applyQueryEdit();
                });
            });
        });

        function wireFteConfigurationEvents() {
            $('#fteProject').on('change', function () {
                loadProcesses($(this).val());
            });

            $('#btnSaveConfiguration').on('click', function () {
                saveConfiguration();
            });

            $('#btnResetConfiguration').on('click', function () {
                resetConfigurationForm();
            });

            $(document).on('click', '.js-edit-config', function () {
                var row = configurationTable.row($(this).closest('tr')).data();

                if (!row && $(this).closest('tr').hasClass('child')) {
                    row = configurationTable.row($(this).closest('tr').prev()).data();
                }

                if (row) {
                    populateConfigurationForm(row);
                }
            });
        }

        function loadProjects(done) {
            setLoading(true);
            PageMethods.GetAllProjectByUserRights(function (result) {
                try {
                    var rows = parseResult(result);
                    var $project = $('#fteProject');

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

                    if (done) {
                        done();
                    }
                }
                catch (ex) {
                    showMessage('Unable to load projects. ' + ex.message, 'danger');
                }
                finally {
                    setLoading(false);
                }
            }, requestFailed);
        }

        function loadProcesses(projectId, selectedProcessId, done) {
            var $process = $('#fteProcess');
            $process.empty().append('<option value="">Select process</option>');

            if (!projectId) {
                if (done) {
                    done();
                }

                return;
            }

            setLoading(true);
            PageMethods.GetProcessByProjectWise(parseInt(projectId, 10), function (result) {
                try {
                    var rows = parseResult(result);

                    $.each(rows, function (_, row) {
                        var processId = getValue(row, ['ProcessID', 'ProcessId']);
                        var processName = getValue(row, ['ProcessName', 'Process']);

                        if (processId) {
                            $process.append($('<option/>', {
                                value: processId,
                                text: processName || processId
                            }));
                        }
                    });

                    if (selectedProcessId) {
                        $process.val(String(selectedProcessId));
                    }

                    if (done) {
                        done();
                    }
                }
                catch (ex) {
                    showMessage('Unable to load processes. ' + ex.message, 'danger');
                }
                finally {
                    setLoading(false);
                }
            }, requestFailed);
        }

        function loadConfigurations(done) {
            setLoading(true);
            PageMethods.GetFTEDetails(function (result) {
                try {
                    configurationRows = parseResult(result);
                    bindConfigurationTable(configurationRows);
                    updateMetrics(configurationRows);

                    if (done) {
                        done();
                    }
                }
                catch (ex) {
                    showMessage('Unable to load FTE configurations. ' + ex.message, 'danger');
                }
                finally {
                    setLoading(false);
                }
            }, requestFailed);
        }

        function bindConfigurationTable(rows) {
            if (configurationTable) {
                configurationTable.clear().rows.add(rows).draw();
                return;
            }

            configurationTable = $('#tableFteConfiguration').DataTable({
                data: rows,
                responsive: true,
                autoWidth: false,
                pageLength: 10,
                order: [[1, 'asc']],
                dom: "<'row align-items-center mb-2'<'col-md-4'l><'col-md-4 text-center'B><'col-md-4'f>>" +
                    "rt<'row align-items-center mt-2'<'col-md-5'i><'col-md-7'p>>",
                buttons: [
                    {
                        extend: 'excelHtml5',
                        text: '<i class="fas fa-file-excel"></i> Excel',
                        className: 'btn btn-success btn-sm'
                    },
                    {
                        extend: 'print',
                        text: '<i class="fas fa-print"></i> Print',
                        className: 'btn btn-secondary btn-sm'
                    }
                ],
                columns: [
                    {
                        data: null,
                        orderable: false,
                        searchable: false,
                        className: 'text-center action-column',
                        render: function () {
                            return '<button type="button" class="btn btn-outline-primary btn-sm js-edit-config" title="Edit configuration">' +
                                '<i class="fas fa-pen"></i>' +
                                '</button>';
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
                            return escapeHtml(getValue(row, ['ProjectName', 'Project']));
                        }
                    },
                    {
                        data: null,
                        render: function (_data, _type, row) {
                            return escapeHtml(getValue(row, ['ProcessName', 'Process']));
                        }
                    },
                    {
                        data: null,
                        className: 'text-right',
                        render: function (_data, _type, row) {
                            return escapeHtml(getValue(row, ['ApprovedFTECount', 'ApprovedCount']));
                        }
                    },
                    {
                        data: null,
                        className: 'text-right',
                        render: function (_data, _type, row) {
                            return escapeHtml(getValue(row, ['BillableStandardHours', 'BillableHours']));
                        }
                    },
                    {
                        data: null,
                        render: function (_data, _type, row) {
                            return escapeHtml(getValue(row, ['BillingType']));
                        }
                    },
                    {
                        data: null,
                        className: 'text-center',
                        render: function (_data, _type, row) {
                            return renderYesNoBadge(getValue(row, ['WeekendAllowed']));
                        }
                    },
                    {
                        data: null,
                        className: 'text-center',
                        render: function (_data, _type, row) {
                            return renderYesNoBadge(getValue(row, ['USHolidayAllowed', 'UsHolidayAllowed']));
                        }
                    }
                ]
            });
        }

        function saveConfiguration() {
            var projectId = $('#fteProject').val();
            var processId = $('#fteProcess').val();
            var approvedFteCount = $.trim($('#approvedFteCount').val());
            var billableStandardHours = $.trim($('#billableStandardHours').val());
            var billingType = $('#billingType').val();
            var weekendAllowed = $('#weekendAllowed').val();
            var usHolidayAllowed = $('#usHolidayAllowed').val();

            if (!projectId || !processId || !billableStandardHours || !billingType || !weekendAllowed || !usHolidayAllowed) {
                showMessage('Please complete all required fields before saving.', 'warning');
                return;
            }

            if ((approvedFteCount && isNaN(Number(approvedFteCount))) || isNaN(Number(billableStandardHours))) {
                showMessage('FTE count and standard hours must be numeric values.', 'warning');
                return;
            }

            setLoading(true);
            PageMethods.InsertFTEDetails(
                parseInt(projectId, 10),
                parseInt(processId, 10),
                approvedFteCount,
                billableStandardHours,
                billingType,
                weekendAllowed,
                usHolidayAllowed,
                function (returnValue) {
                    try {
                        if (parseInt(returnValue, 10) > 0) {
                            showMessage('FTE configuration saved successfully.', 'success');
                            resetConfigurationForm();
                            loadConfigurations();
                        }
                        else if (parseInt(returnValue, 10) === -1) {
                            showMessage('A configuration already exists for this project and process.', 'warning');
                        }
                        else {
                            showMessage('Unable to save the FTE configuration.', 'danger');
                        }
                    }
                    catch (ex) {
                        showMessage('Unable to complete save. ' + ex.message, 'danger');
                    }
                    finally {
                        setLoading(false);
                    }
                },
                requestFailed
            );
        }

        function populateConfigurationForm(row) {
            var projectId = getValue(row, ['ProjectID', 'ProjectId']);
            var processId = getValue(row, ['ProcessID', 'ProcessId']);

            $('#fteProject').val(String(projectId));
            loadProcesses(projectId, processId);
            $('#approvedFteCount').val(getValue(row, ['ApprovedFTECount', 'ApprovedCount']));
            $('#billableStandardHours').val(getValue(row, ['BillableStandardHours', 'BillableHours']));
            $('#billingType').val(getValue(row, ['BillingType']));
            $('#weekendAllowed').val(getValue(row, ['WeekendAllowed']));
            $('#usHolidayAllowed').val(getValue(row, ['USHolidayAllowed', 'UsHolidayAllowed']));
            $('#formModeLabel').text('Editing selected configuration');
            $('#btnSaveConfiguration').html('<i class="fas fa-save"></i> Update Configuration');

            $('html, body').animate({ scrollTop: $('.fte-panel').first().offset().top - 12 }, 250);
        }

        function resetConfigurationForm() {
            $('#fteProject').val('');
            $('#fteProcess').empty().append('<option value="">Select process</option>');
            $('#approvedFteCount').val('');
            $('#billableStandardHours').val('');
            $('#billingType').val('');
            $('#weekendAllowed').val('');
            $('#usHolidayAllowed').val('');
            $('#formModeLabel').text('New configuration');
            $('#btnSaveConfiguration').html('<i class="fas fa-save"></i> Save Configuration');
        }

        function updateMetrics(rows) {
            var totalFte = 0;
            var weekendCount = 0;
            var holidayCount = 0;

            $.each(rows, function (_, row) {
                var approved = parseFloat(getValue(row, ['ApprovedFTECount', 'ApprovedCount']));
                var weekendAllowed = String(getValue(row, ['WeekendAllowed'])).toLowerCase() === 'yes';
                var holidayAllowed = String(getValue(row, ['USHolidayAllowed', 'UsHolidayAllowed'])).toLowerCase() === 'yes';

                if (!isNaN(approved)) {
                    totalFte += approved;
                }

                if (weekendAllowed) {
                    weekendCount += 1;
                }

                if (holidayAllowed) {
                    holidayCount += 1;
                }
            });

            $('#metricConfigurations').text(rows.length);
            $('#metricApprovedFte').text(formatMetric(totalFte));
            $('#metricWeekend').text(weekendCount);
            $('#metricHoliday').text(holidayCount);
        }

        function applyQueryEdit() {
            var projectId = getQueryParam('ProjectID');
            var processId = getQueryParam('ProcessID');

            if (!projectId || !processId) {
                return;
            }

            var match = null;

            $.each(configurationRows, function (_, row) {
                if (String(getValue(row, ['ProjectID', 'ProjectId'])) === projectId &&
                    String(getValue(row, ['ProcessID', 'ProcessId'])) === processId) {
                    match = row;
                    return false;
                }
            });

            if (match) {
                populateConfigurationForm(match);
            }
        }

        function showMessage(message, type) {
            var $alert = $('#configurationAlert');
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

            var message = 'Request failed. Please try again.';
            if (error && error.get_message) {
                message = error.get_message();
            }

            showMessage(message, 'danger');
        }

        function setLoading(isLoading) {
            if (isLoading) {
                loadingDepth += 1;
                $('#load1').stop(true, true).css('display', 'block');

                if (!loadingGuard) {
                    loadingGuard = window.setTimeout(function () {
                        loadingDepth = 0;
                        $('#load1').stop(true, true).css('display', 'none');
                        $('#btnSaveConfiguration, #btnResetConfiguration').prop('disabled', false);
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

            $('#btnSaveConfiguration, #btnResetConfiguration').prop('disabled', loadingDepth > 0);
        }

        function parseResult(result) {
            var payload = result && result.d ? result.d : result;

            if (!payload) {
                return [];
            }

            if ($.isArray(payload)) {
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

        function renderYesNoBadge(value) {
            var label = escapeHtml(value || 'No');
            var normalized = String(value).toLowerCase();
            var badgeClass = normalized === 'yes'
                ? 'fte-badge-yes'
                : normalized === 'no'
                    ? 'fte-badge-no'
                    : 'fte-badge-neutral';

            return '<span class="fte-badge ' + badgeClass + '">' + label + '</span>';
        }

        function escapeHtml(value) {
            return $('<div/>').text(value === undefined || value === null ? '' : value).html();
        }

        function formatMetric(value) {
            if (Math.round(value) === value) {
                return String(value);
            }

            return value.toFixed(2);
        }

        function getQueryParam(name) {
            name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
            var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
            var results = regex.exec(location.search);
            return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
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

    <div class="fte-page">
        <div class="fte-shell">
            <header class="fte-hero">
                <div class="fte-title">
                    <span class="icon-box"><i class="fas fa-project-diagram"></i></span>
                    <div>
                        <h1>FTE Project Configuration</h1>
                        <p>Configure project capacity, billable standards, and holiday rules.</p>
                    </div>
                </div>
                <a class="fte-quick-link" href="#url">
                    <i class="fas fa-layer-group"></i>
                    FTE Master
                </a>
            </header>

            <div class="fte-metrics">
                <div class="fte-metric">
                    <span>Configurations</span>
                    <strong id="metricConfigurations">0</strong>
                </div>
                <div class="fte-metric">
                    <span>Approved FTE</span>
                    <strong id="metricApprovedFte">0</strong>
                </div>
                <div class="fte-metric">
                    <span>Weekend Allowed</span>
                    <strong id="metricWeekend">0</strong>
                </div>
                <div class="fte-metric">
                    <span>US Holiday Allowed</span>
                    <strong id="metricHoliday">0</strong>
                </div>
            </div>

            <div id="configurationAlert" class="alert fte-alert" role="alert"></div>

            <section class="fte-panel">
                <div class="fte-panel-header">
                    <h2><i class="fas fa-sliders-h"></i>&nbsp; Configuration Details</h2>
                    <small id="formModeLabel">New configuration</small>
                </div>
                <div class="fte-panel-body">
                    <div class="fte-form-grid">
                        <div class="fte-field">
                            <label for="fteProject"><i class="fas fa-briefcase"></i>Project</label>
                            <select id="fteProject" class="form-control">
                                <option value="">Select project</option>
                            </select>
                        </div>

                        <div class="fte-field">
                            <label for="fteProcess"><i class="fas fa-stream"></i>Process</label>
                            <select id="fteProcess" class="form-control">
                                <option value="">Select process</option>
                            </select>
                        </div>

                        <div class="fte-field">
                            <label for="approvedFteCount"><i class="fas fa-users"></i>Approved FTE Count</label>
                            <input type="number" id="approvedFteCount" class="form-control" min="0" step="0.01" />
                        </div>

                        <div class="fte-field">
                            <label for="billableStandardHours"><i class="fas fa-clock"></i>Billable Standard Hours</label>
                            <input type="number" id="billableStandardHours" class="form-control" min="0" step="0.01" />
                        </div>

                        <div class="fte-field">
                            <label for="billingType"><i class="fas fa-file-invoice-dollar"></i>Billing Type</label>
                            <select id="billingType" class="form-control">
                                <option value="">Select billing type</option>
                                <option value="Hourly">Hourly</option>
                                <option value="RecordBase">Record Base</option>
                                <option value="WeekAverage">Week Average</option>
                                <option value="OtherCount">Other Count</option>
                            </select>
                        </div>

                        <div class="fte-field">
                            <label for="weekendAllowed"><i class="fas fa-calendar-week"></i>Weekend Allowed</label>
                            <select id="weekendAllowed" class="form-control">
                                <option value="">Select option</option>
                                <option value="Yes">Yes</option>
                                <option value="No">No</option>
                            </select>
                        </div>

                        <div class="fte-field">
                            <label for="usHolidayAllowed"><i class="fas fa-calendar-check"></i>US Holiday Allowed</label>
                            <select id="usHolidayAllowed" class="form-control">
                                <option value="">Select option</option>
                                <option value="Yes">Yes</option>
                                <option value="No">No</option>
                            </select>
                        </div>
                    </div>

                    <div class="fte-actions">
                        <button type="button" id="btnResetConfiguration" class="btn btn-outline-secondary">
                            <i class="fas fa-undo"></i>
                            Reset
                        </button>
                        <button type="button" id="btnSaveConfiguration" class="btn btn-primary">
                            <i class="fas fa-save"></i>
                            Save Configuration
                        </button>
                    </div>
                </div>
            </section>

            <section class="fte-panel">
                <div class="fte-panel-header">
                    <h2><i class="fas fa-table"></i>&nbsp; Configuration Report</h2>
                    <small>Current records</small>
                </div>
                <div class="fte-panel-body">
                    <div class="fte-table-wrap">
                        <table id="tableFteConfiguration" class="table table-bordered table-striped table-hover">
                            <thead>
                                <tr>
                                    <th>Action</th>
                                    <th>Sr #</th>
                                    <th>Project</th>
                                    <th>Process</th>
                                    <th>Approved FTE</th>
                                    <th>Billable Hours</th>
                                    <th>Billing Type</th>
                                    <th>Weekend</th>
                                    <th>US Holiday</th>
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
