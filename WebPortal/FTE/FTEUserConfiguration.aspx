<%@ Page Title="" Language="C#" MasterPageFile="~/FTE/FTE.Master" AutoEventWireup="true" CodeBehind="FTEUserConfiguration.aspx.cs" Inherits="WebPortal.FTE.FTEUserConfiguration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .fteu-page {
            --fteu-blue: #2563eb;
            --fteu-green: #059669;
            --fteu-red: #dc2626;
            --fteu-ink: #0f172a;
            --fteu-muted: #64748b;
            --fteu-border: #d8e2ee;
            color: var(--fteu-ink);
            padding: 0px 0 28px;
        }

        .fteu-shell {
            width: 100%;
            max-width: 1480px;
            margin: 0 auto;
        }

        .fteu-hero {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            min-height: 78px;
            padding: 16px 18px;
            margin-bottom: 16px;
            border: 1px solid var(--fteu-border);
            border-radius: 8px;
            background: linear-gradient(135deg, #0f172a 0%, #1d4ed8 56%, #0891b2 100%);
            color: #fff;
            box-shadow: 0 14px 32px rgba(15, 23, 42, .12);
        }

        .fteu-title {
            display: flex;
            align-items: center;
            gap: 13px;
            min-width: 0;
        }

        .fteu-title .icon-box {
            width: 44px;
            height: 44px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.15);
            font-size: 18px;
        }

        .fteu-title h1 {
            margin: 0;
            font-size: 22px;
            font-weight: 800;
            line-height: 1.15;
            letter-spacing: 0;
        }

        .fteu-title p {
            margin: 4px 0 0;
            color: rgba(255,255,255,.78);
            font-size: 12px;
        }

        .fteu-chip {
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

        .fteu-chip:hover {
            color: #fff;
            text-decoration: none;
            background: rgba(255,255,255,.22);
        }

        .fteu-metrics {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 12px;
            margin-bottom: 16px;
        }

        .fteu-metric {
            min-height: 78px;
            padding: 14px 16px;
            border: 1px solid var(--fteu-border);
            border-radius: 8px;
            background: #fff;
            box-shadow: 0 8px 20px rgba(31, 41, 55, .05);
        }

        .fteu-metric span {
            display: block;
            color: var(--fteu-muted);
            font-size: 12px;
            font-weight: 800;
            text-transform: uppercase;
        }

        .fteu-metric strong {
            display: block;
            margin-top: 8px;
            color: var(--fteu-ink);
            font-size: 24px;
            line-height: 1;
        }

        .fteu-panel {
            margin-bottom: 16px;
            border: 1px solid var(--fteu-border);
            border-radius: 8px;
            background: #fff;
            box-shadow: 0 10px 28px rgba(15, 23, 42, .07);
            overflow: hidden;
        }

        .fteu-panel-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 14px 16px;
            border-bottom: 1px solid var(--fteu-border);
            background: #f8fafc;
        }

        .fteu-panel-header h2 {
            margin: 0;
            color: #1e3356;
            font-size: 16px;
            font-weight: 800;
            letter-spacing: 0;
        }

        .fteu-panel-body {
            padding: 16px;
        }

        .fteu-form-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 13px 16px;
            align-items: end;
        }

        .fteu-field label {
            display: block;
            margin: 0 0 6px;
            color: #1e3356;
            font-size: 11px;
            font-weight: 800 !important;
            border: 0 !important;
        }

        .fteu-page .form-control {
            width: 100% !important;
            min-height: 38px;
            border: 1px solid var(--fteu-border) !important;
            border-radius: 8px !important;
            box-shadow: none !important;
            font-size: 12px !important;
        }

        .fteu-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            padding-top: 16px;
        }

        .fteu-actions .btn {
            min-height: 36px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 800;
        }

        .fteu-alert {
            display: none;
            margin-bottom: 14px;
            border-radius: 8px;
            font-weight: 700;
        }

        .table-shell {
            width: 100%;
            overflow-x: hidden;
            overflow-y: visible;
            border: 1px solid var(--fteu-border);
            border-radius: 8px;
            background: #fff;
        }

        .fteu-page table.dataTable,
        .fteu-page .table {
            width: 100% !important;
            margin: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0 !important;
        }

        .fteu-page table.dataTable thead th,
        .fteu-page .table thead th {
            white-space: nowrap !important;
            background: #f8fafc !important;
            color: #1e3356 !important;
            border-bottom: 1px solid var(--fteu-border) !important;
            padding: 10px 12px !important;
            font-size: 11px !important;
            font-weight: 900 !important;
            vertical-align: middle !important;
        }

        .fteu-page table.dataTable tbody td,
        .fteu-page .table tbody td {
            background: #fff !important;
            border-top: 1px solid #eef2f7 !important;
            color: #1f2937 !important;
            padding: 10px 12px !important;
            font-size: 12px !important;
            vertical-align: middle !important;
        }

        .fteu-page .dataTables_wrapper {
            width: 100%;
            max-width: 100%;
            box-sizing: border-box;
            padding: 12px;
            overflow-x: hidden;
        }

        .fteu-page .dataTables_filter input {
            max-width: 180px;
        }

        .fteu-page .dt-buttons .btn,
        .fteu-page .dt-button {
            border-radius: 8px !important;
            border: 1px solid var(--fteu-border) !important;
            background: #fff !important;
            color: #1e3356 !important;
            font-size: 12px !important;
            font-weight: 800 !important;
            padding: 6px 10px !important;
            margin-right: 6px;
        }

        .status-pill {
            display: inline-flex;
            align-items: center;
            border-radius: 999px;
            padding: 4px 9px;
            font-size: 11px;
            font-weight: 800;
            background: #eef6ff;
            color: #1d4ed8;
        }

        .row-actions {
            display: inline-flex;
            gap: 6px;
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
            .fteu-form-grid,
            .fteu-metrics {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 760px) {
            .fteu-hero,
            .fteu-panel-header,
            .fteu-actions {
                align-items: flex-start;
                flex-direction: column;
            }

            .fteu-form-grid,
            .fteu-metrics {
                grid-template-columns: 1fr;
            }

            .fteu-chip,
            .fteu-actions .btn {
                justify-content: center;
                width: 100%;
            }
        }
    </style>

    <script>
        var userConfigTable = null;
        var userConfigRows = [];
        var loadingDepth = 0;
        var loadingGuard = null;

        $(document).ready(function () {
            wireUserConfigEvents();
            loadProjects();
            loadEmployees();
            loadUserConfigurations(function () {
                applyQueryEdit();
            });
        });

        function wireUserConfigEvents() {
            $('#fteUserProject').on('change', function () {
                loadProcesses($(this).val());
            });

            $('#fteUserEmployee').on('change', function () {
                loadPseudoName();
            });

            $('#btnSaveFteUser').on('click', saveUserConfiguration);
            $('#btnResetFteUser').on('click', resetUserForm);

            $(document).on('click', '.js-edit-user-config', function () {
                var row = getTableRow(this);
                if (row) {
                    populateUserForm(row);
                }
            });

            $(document).on('click', '.js-delete-user-config', function () {
                var row = getTableRow(this);
                if (row && confirm('Delete this FTE user configuration?')) {
                    deleteUserConfiguration(getValue(row, ['ConfigId', 'ConfigID']));
                }
            });
        }

        function loadProjects() {
            setLoading(true);
            PageMethods.GetAllProjectByUserRights(function (result) {
                try {
                    var rows = parseResult(result);
                    var $project = $('#fteUserProject');
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

        function loadProcesses(projectId, selectedProcessId, done) {
            var $process = $('#fteUserProcess');
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
                            $process.append($('<option/>', { value: processId, text: processName || processId }));
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

        function loadEmployees() {
            setLoading(true);
            PageMethods.GetAllEmployeeDetailsbyPM(function (result) {
                try {
                    var rows = parseResult(result);
                    var $employee = $('#fteUserEmployee');
                    $employee.empty().append('<option value="">Select employee</option>');

                    $.each(rows, function (_, row) {
                        var employeeId = getValue(row, ['EMPID', 'EmployeeID', 'EmployeeId']);
                        var name = getValue(row, ['NAME', 'EmployeeName', 'Name']);
                        if (employeeId) {
                            $employee.append($('<option/>', { value: employeeId, text: name || employeeId }));
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

        function loadPseudoName() {
            var text = $('#fteUserEmployee option:selected').text();
            if (!text || !$('#fteUserEmployee').val()) {
                $('#ftePseudoName').val('');
                return;
            }

            setLoading(true);
            PageMethods.GetPseudoName(text, function (result) {
                try {
                    var rows = parseResult(result);
                    $('#ftePseudoName').val(rows.length ? getValue(rows[0], ['PsuedoName', 'PseudoName', 'Pseudoname']) : '');
                }
                catch (ex) {
                    showMessage('Unable to load pseudo name. ' + ex.message, 'danger');
                }
                finally {
                    setLoading(false);
                }
            }, requestFailed);
        }

        function loadUserConfigurations(done) {
            setLoading(true);
            PageMethods.GetFTEUserDetails(function (result) {
                try {
                    userConfigRows = parseResult(result);
                    bindUserConfigTable(userConfigRows);
                    updateMetrics(userConfigRows);
                    if (done) {
                        done();
                    }
                }
                catch (ex) {
                    showMessage('Unable to load FTE users. ' + ex.message, 'danger');
                }
                finally {
                    setLoading(false);
                }
            }, requestFailed);
        }

        function saveUserConfiguration() {
            var projectId = $('#fteUserProject').val();
            var processId = $('#fteUserProcess').val();
            var employeeId = $('#fteUserEmployee').val();
            var pseudoName = $.trim($('#ftePseudoName').val());
            var employeeStatus = $('#fteEmployeeStatus').val();
            var effectiveDate = $('#fteEffectiveDate').val();
            var noticePeriodDays = $.trim($('#fteNoticePeriodDays').val());

            if (!projectId || !processId || !employeeId || !pseudoName || !employeeStatus || !effectiveDate) {
                showMessage('Please complete all required fields before saving.', 'warning');
                return;
            }

            setLoading(true);
            PageMethods.InsertFTEUserDetails(
                parseInt(projectId, 10),
                parseInt(processId, 10),
                parseInt(employeeId, 10),
                pseudoName,
                employeeStatus,
                formatDateForServer(effectiveDate),
                noticePeriodDays,
                function (returnValue) {
                    try {
                        if (parseInt(returnValue, 10) > 0) {
                            showMessage('FTE user configuration saved successfully.', 'success');
                            resetUserForm();
                            loadUserConfigurations();
                        }
                        else {
                            showMessage('Unable to save FTE user configuration.', 'danger');
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

        function deleteUserConfiguration(configId) {
            if (!configId) {
                return;
            }

            setLoading(true);
            PageMethods.DeleteUser(parseInt(configId, 10), function (returnValue) {
                try {
                    if (parseInt(returnValue, 10) > 0) {
                        showMessage('User deleted successfully.', 'success');
                        loadUserConfigurations();
                    }
                    else {
                        showMessage('Unable to delete user.', 'danger');
                    }
                }
                finally {
                    setLoading(false);
                }
            }, requestFailed);
        }

        function bindUserConfigTable(rows) {
            if (userConfigTable) {
                userConfigTable.clear().rows.add(rows).draw();
                return;
            }

            userConfigTable = $('#tableFTEUserConfiguration').DataTable({
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
                        render: function () {
                            return '<span class="row-actions">' +
                                '<button type="button" class="btn btn-outline-primary btn-sm js-edit-user-config" title="Edit"><i class="fas fa-pen"></i></button>' +
                                '<button type="button" class="btn btn-outline-danger btn-sm js-delete-user-config" title="Delete"><i class="fas fa-trash"></i></button>' +
                                '</span>';
                        }
                    },
                    {
                        data: null,
                        className: 'text-center',
                        render: function (_data, _type, _row, meta) {
                            return meta.row + 1;
                        }
                    },
                    { data: null, render: function (_data, _type, row) { return escapeHtml(getValue(row, ['ProjectName', 'Project'])); } },
                    { data: null, render: function (_data, _type, row) { return escapeHtml(getValue(row, ['ProcessName', 'Process'])); } },
                    { data: null, render: function (_data, _type, row) { return escapeHtml(getValue(row, ['EmployeeName', 'Employee'])); } },
                    { data: null, render: function (_data, _type, row) { return escapeHtml(getValue(row, ['Pseudoname', 'PseudoName'])); } },
                    { data: null, render: function (_data, _type, row) { return '<span class="status-pill">' + escapeHtml(getValue(row, ['EmployeeStatus'])) + '</span>'; } },
                    { data: null, render: function (_data, _type, row) { return escapeHtml(getValue(row, ['EffectiveDate'])); } },
                    { data: null, className: 'text-right', render: function (_data, _type, row) { return escapeHtml(getValue(row, ['NoticePeriodDays'])); } }
                ]
            });
        }

        function populateUserForm(row) {
            var projectId = getValue(row, ['ProjectID', 'ProjectId']);
            var processId = getValue(row, ['ProcessID', 'ProcessId']);
            $('#fteUserProject').val(String(projectId));
            loadProcesses(projectId, processId);
            $('#fteUserEmployee').val(String(getValue(row, ['EmployeeID', 'EmployeeId'])));
            $('#ftePseudoName').val(getValue(row, ['Pseudoname', 'PseudoName']));
            $('#fteEmployeeStatus').val(getValue(row, ['EmployeeStatus']));
            $('#fteEffectiveDate').val(toInputDate(getValue(row, ['EffectiveDate'])));
            $('#fteNoticePeriodDays').val(getValue(row, ['NoticePeriodDays']));
            $('#formModeLabel').text('Editing selected user');
            $('#btnSaveFteUser').html('<i class="fas fa-save"></i> Update User');
            $('html, body').animate({ scrollTop: $('.fteu-panel').first().offset().top - 12 }, 250);
        }

        function resetUserForm() {
            $('#fteUserProject').val('');
            $('#fteUserProcess').empty().append('<option value="">Select process</option>');
            $('#fteUserEmployee').val('');
            $('#ftePseudoName').val('');
            $('#fteEmployeeStatus').val('');
            $('#fteEffectiveDate').val('');
            $('#fteNoticePeriodDays').val('');
            $('#formModeLabel').text('New user');
            $('#btnSaveFteUser').html('<i class="fas fa-save"></i> Save User');
        }

        function applyQueryEdit() {
            var configId = getQueryParam('ConfigId');
            if (!configId) {
                return;
            }

            $.each(userConfigRows, function (_, row) {
                if (String(getValue(row, ['ConfigId', 'ConfigID'])) === configId) {
                    populateUserForm(row);
                    return false;
                }
            });
        }

        function updateMetrics(rows) {
            var live = 0;
            var hold = 0;
            var extra = 0;

            $.each(rows, function (_, row) {
                var status = String(getValue(row, ['EmployeeStatus'])).toLowerCase();
                if (status === 'live') {
                    live += 1;
                }
                else if (status === 'on hold') {
                    hold += 1;
                }
                else if (status === 'extra') {
                    extra += 1;
                }
            });

            $('#metricConfiguredUsers').text(rows.length);
            $('#metricLiveUsers').text(live);
            $('#metricHoldUsers').text(hold);
            $('#metricExtraUsers').text(extra);
        }

        function getTableRow(button) {
            var row = userConfigTable.row($(button).closest('tr')).data();
            if (!row && $(button).closest('tr').hasClass('child')) {
                row = userConfigTable.row($(button).closest('tr').prev()).data();
            }
            return row;
        }

        function showMessage(message, type) {
            var $alert = $('#userConfigAlert');
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
                        $('#btnSaveFteUser, #btnResetFteUser').prop('disabled', false);
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

            $('#btnSaveFteUser, #btnResetFteUser').prop('disabled', loadingDepth > 0);
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

        function formatDateForServer(value) {
            if (!value) {
                return '';
            }
            var parts = value.split('-');
            if (parts.length !== 3) {
                return value;
            }
            var date = new Date(parseInt(parts[0], 10), parseInt(parts[1], 10) - 1, parseInt(parts[2], 10));
            return date.toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' }).replace(/ /g, '-');
        }

        function toInputDate(value) {
            if (!value) {
                return '';
            }
            var date = new Date(value);
            if (isNaN(date.getTime())) {
                return '';
            }
            var month = String(date.getMonth() + 1).padStart(2, '0');
            var day = String(date.getDate()).padStart(2, '0');
            return date.getFullYear() + '-' + month + '-' + day;
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

    <div class="fteu-page">
        <div class="fteu-shell">
            <header class="fteu-hero">
                <div class="fteu-title">
                    <span class="icon-box"><i class="fas fa-users-cog"></i></span>
                    <div>
                        <h1>FTE User Configuration</h1>
                        <p>Assign employees to project processes and maintain FTE user status.</p>
                    </div>
                </div>
                <a class="fteu-chip" href="#url">
                    <i class="fas fa-sliders-h"></i>
                    FTE Configuration
                </a>
            </header>

            <div class="fteu-metrics" style="display:none;">
                <div class="fteu-metric">
                    <span>Configured Users</span>
                    <strong id="metricConfiguredUsers">0</strong>
                </div>
                <div class="fteu-metric">
                    <span>Live</span>
                    <strong id="metricLiveUsers">0</strong>
                </div>
                <div class="fteu-metric">
                    <span>On Hold</span>
                    <strong id="metricHoldUsers">0</strong>
                </div>
                <div class="fteu-metric">
                    <span>Extra</span>
                    <strong id="metricExtraUsers">0</strong>
                </div>
            </div>

            <div id="userConfigAlert" class="alert fteu-alert" role="alert"></div>

            <section class="fteu-panel">
                <div class="fteu-panel-header">
                    <h2><i class="fas fa-user-plus"></i>&nbsp; User Details</h2>
                    <small id="formModeLabel">New user</small>
                </div>
                <div class="fteu-panel-body">
                    <div class="fteu-form-grid">
                        <div class="fteu-field">
                            <label for="fteUserProject">Project</label>
                            <select id="fteUserProject" class="form-control">
                                <option value="">Select project</option>
                            </select>
                        </div>
                        <div class="fteu-field">
                            <label for="fteUserProcess">Process</label>
                            <select id="fteUserProcess" class="form-control">
                                <option value="">Select process</option>
                            </select>
                        </div>
                        <div class="fteu-field">
                            <label for="fteUserEmployee">Employee</label>
                            <select id="fteUserEmployee" class="form-control">
                                <option value="">Select employee</option>
                            </select>
                        </div>
                        <div class="fteu-field">
                            <label for="ftePseudoName">Pseudo Name</label>
                            <input id="ftePseudoName" class="form-control" />
                        </div>
                        <div class="fteu-field">
                            <label for="fteEmployeeStatus">Employee Status</label>
                            <select id="fteEmployeeStatus" class="form-control">
                                <option value="">Select status</option>
                                <option value="Live">Live</option>
                                <option value="On Hold">On Hold</option>
                                <option value="Extra">Extra</option>
                            </select>
                        </div>
                        <div class="fteu-field">
                            <label for="fteEffectiveDate">Effective Date</label>
                            <input type="date" id="fteEffectiveDate" class="form-control" />
                        </div>
                        <div class="fteu-field">
                            <label for="fteNoticePeriodDays">Notice Period Days</label>
                            <input type="number" id="fteNoticePeriodDays" class="form-control" min="0" />
                        </div>
                    </div>

                    <div class="fteu-actions">
                        <button type="button" id="btnResetFteUser" class="btn btn-outline-secondary">
                            <i class="fas fa-undo"></i>
                            Reset
                        </button>
                        <button type="button" id="btnSaveFteUser" class="btn btn-primary">
                            <i class="fas fa-save"></i>
                            Save User
                        </button>
                    </div>
                </div>
            </section>

            <section class="fteu-panel">
                <div class="fteu-panel-header">
                    <h2><i class="fas fa-table"></i>&nbsp; User Configuration Report</h2>
                    <small>Current records</small>
                </div>
                <div class="fteu-panel-body">
                    <div class="table-shell">
                        <table id="tableFTEUserConfiguration" class="table table-bordered table-hover">
                            <thead>
                                <tr>
                                    <th style="width: 92px;">Action</th>
                                    <th style="width: 70px;">Sr #</th>
                                    <th>Project</th>
                                    <th>Process</th>
                                    <th>Employee</th>
                                    <th>Pseudo Name</th>
                                    <th>Status</th>
                                    <th>Effective Date</th>
                                    <th>Notice Days</th>
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
