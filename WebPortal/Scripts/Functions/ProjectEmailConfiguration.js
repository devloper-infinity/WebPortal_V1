(function ($) {
    'use strict';

    var pageUrl = 'ProjectEmailConfiguration.aspx/';
    var maxEmailsPerType = 50;
    var configurationTable = null;
    var historyTable = null;
    var projectNames = {};

    $(function () {
        bindEvents();
        resetRecipientRows([], []);
        loadProjects();
    });

    function bindEvents() {
        $('.pec-btn-add').on('click', function () {
            var type = $(this).data('email-type');
            var context = $(this).data('edit-context') || 'main';
            var $list = getEmailList(type, context);

            if ($list.find('.pec-email-row').length >= maxEmailsPerType) {
                showMessage('warning', 'Email Limit Reached', 'A maximum of 50 ' + type + ' addresses can be configured.');
                return;
            }

            addEmailRow(type, null, true, context);
        });

        $('.pec-email-list').on('click', '.pec-btn-remove', function () {
            var $button = $(this);
            var $row = $button.closest('.pec-email-row');
            var $list = $button.closest('.pec-email-list');
            var configurationId = parseInt($row.data('configuration-id'), 10) || 0;

            function removeRow() {
                $row.remove();
                if (!$list.find('.pec-email-row').length) {
                    addEmailRow($list.data('email-type'), null, false, getListContext($list));
                }
            }

            if (!configurationId) {
                removeRow();
                return;
            }

            Swal.fire({
                icon: 'warning',
                title: 'Deactivate Email?',
                text: 'This email will be marked inactive immediately.',
                showCancelButton: true,
                confirmButtonText: 'Yes, remove it',
                cancelButtonText: 'Keep Email',
                confirmButtonColor: '#dc3545'
            }).then(function (result) {
                if (!result.isConfirmed) { return; }

                var projectId = getProjectIdForList($list);
                showSaving('Deactivating Email', 'Please wait while the selected email is removed...');
                callPageMethod('DeactivateProjectEmail', {
                    configurationId: configurationId,
                    projectId: projectId
                })
                    .done(function (response) {
                        var resultData = response.d || {};
                        if (!resultData.Success) {
                            showMessage('error', 'Unable to Remove', resultData.Message || 'The email could not be removed.');
                            return;
                        }

                        removeRow();
                        loadConfigurations();
                        if ($('#pecProject').val() === String(projectId)) {
                            loadProjectEmails(projectId);
                        }
                        showMessage('success', 'Email Removed', resultData.Message || 'The email address was deactivated successfully.');
                    })
                    .fail(handleRequestError);
            });
        });

        $('#pecProject').on('change', function () {
            loadProjectEmails($(this).val());
        });

        $('#pecSave').on('click', saveConfiguration);
        $('#pecUpdateTo').on('click', function () { updateTypeConfiguration('TO'); });
        $('#pecUpdateCc').on('click', function () { updateTypeConfiguration('CC'); });

        $('#pecConfigurationTable tbody').on('click', '.pec-edit-to-btn', function () {
            var rowData = configurationTable.row($(this).closest('tr')).data();
            openTypeEditModal(rowData, 'TO');
        });

        $('#pecConfigurationTable tbody').on('click', '.pec-edit-cc-btn', function () {
            var rowData = configurationTable.row($(this).closest('tr')).data();
            openTypeEditModal(rowData, 'CC');
        });

        $('#pecConfigurationTable tbody').on('click', '.pec-history-btn', function () {
            var rowData = configurationTable.row($(this).closest('tr')).data();
            openHistoryModal(rowData.ProjectID);
        });
    }

    function loadProjects() {
        setLoading(true);

        callPageMethod('GetAllProjectNo', {})
            .done(function (response) {
                var projects = parseRows(response.d);
                var $project = $('#pecProject').empty().append($('<option>', { value: '', text: 'Select Project' }));

                projectNames = {};

                $.each(projects, function (_, project) {
                    var projectId = String(project.ProjectID);
                    projectNames[projectId] = project.ProjectName;
                    $('<option>', { value: projectId, text: project.ProjectName }).appendTo($project);
                });

                if (!projects.length) {
                    showMessage('info', 'No Projects Available', 'No projects are assigned to your user account.');
                }

                loadConfigurations();
            })
            .fail(handleRequestError)
            .always(function () { setLoading(false); });
    }

    function loadProjectEmails(projectId) {
        clearStatus();

        if (!projectId) {
            resetRecipientRows([], []);
            return;
        }

        setLoading(true);

        callPageMethod('GetProjectEmails', { projectId: parseInt(projectId, 10) })
            .done(function (response) {
                var rows = parseRows(response.d);
                var toEmails = [];
                var ccEmails = [];

                $.each(rows, function (_, row) {
                    (String(row.EmailType).toUpperCase() === 'CC' ? ccEmails : toEmails).push(row);
                });

                resetRecipientRows(toEmails, ccEmails);
                showStatus(rows.length ? rows.length + ' saved recipient(s) loaded' : 'No saved recipients');
            })
            .fail(function (xhr) {
                resetRecipientRows([], []);
                handleRequestError(xhr);
            })
            .always(function () { setLoading(false); });
    }

    function saveConfiguration() {
        var projectId = $.trim($('#pecProject').val());
        var toResult = collectEmails('TO', true, 'main');
        var ccResult = collectEmails('CC', false, 'main');

        if (!projectId) {
            showValidation('Project Required', 'Please select a project.', $('#pecProject'));
            return;
        }

        if (!toResult.isValid) {
            showValidation('Check To Addresses', toResult.message, toResult.$focus);
            return;
        }

        if (!ccResult.isValid) {
            showValidation('Check CC Addresses', ccResult.message, ccResult.$focus);
            return;
        }

        $('#pecSave').prop('disabled', true);
        showSaving('Saving Configuration', 'Updating To and CC email recipients...');

        callPageMethod('SaveProjectEmailConfiguration', {
            originalProjectId: parseInt(projectId, 10),
            projectId: parseInt(projectId, 10),
            emailItems: toResult.items.concat(ccResult.items)
        })
            .done(function (response) {
                var result = response.d || {};
                showMessage(result.Success ? 'success' : 'error', result.Success ? 'Configuration Saved' : 'Unable to Save', result.Message || 'The request could not be completed.');

                if (result.Success) {
                    showStatus(result.EmailCount + ' recipient(s) configured');
                    loadProjectEmails(projectId);
                    loadConfigurations();
                }
            })
            .fail(handleRequestError)
            .always(function () { $('#pecSave').prop('disabled', false); });
    }

    function loadConfigurations() {
        callPageMethod('GetConfigurations', {}).done(function (response) {
                bindConfigurationTable(parseRows(response.d));
            }).fail(handleRequestError);
    }

    function bindConfigurationTable(rows) {

        console.log(rows);

        var groupedRows = groupConfigurationsByProject(rows);

        console.log(groupedRows);

        if ($.fn.DataTable.isDataTable('#pecConfigurationTable')) {
            $('#pecConfigurationTable').DataTable().clear().destroy();
        }

        configurationTable = $('#pecConfigurationTable').DataTable({
            data: groupedRows,
            responsive: false,
            scrollX: true,
            autoWidth: false,
            pageLength: 10,
            lengthMenu: [[10, 25, 50, -1], [10, 25, 50, 'All']],
            order: [[0, 'asc']],
            language: { emptyTable: 'No email configurations found.', search: 'Search:' },
            columns: [
                { data: null, orderable: false, searchable: false, className: 'text-center', render: renderProjectActions },
                { data: 'ProjectID', render: function (value) { return encode(projectNames[String(value)] || value); } },
                { data: 'ToEmails', orderable: false, render: function (records) { return renderEmailChips(records, 'TO'); } },
                { data: 'CcEmails', orderable: false, render: function (records) { return renderEmailChips(records, 'CC'); } },
                { data: 'AddedByDisplay', className: 'text-center', render: renderAuditValue },
                { data: 'AddedDateDisplay', render: formatDateTime },
                { data: 'UpdatedByDisplay', className: 'text-center', render: renderAuditValue },
                { data: 'UpdatedDateDisplay', render: formatDateTime }
               
            ],
            columnDefs: [
                { targets: 0, width: '135px' },
                { targets: [1, 2], width: '260px' },
                { targets: [3, 5], width: '75px' },
                { targets: [4, 6], width: '145px' },
                { targets: 7, width: '225px' }
            ]
        });
    }

    function groupConfigurationsByProject(rows) {
        var groups = {};

        $.each(rows || [], function (_, record) {
            var projectKey = String(record.ProjectID);
            var group = groups[projectKey];

            if (!group) {
                group = groups[projectKey] = {
                    ProjectID: record.ProjectID,
                    ToEmails: [],
                    CcEmails: [],
                    Records: [],
                    AddedByValues: [],
                    AddedDates: [],
                    UpdatedByValues: [],
                    UpdatedDates: []
                };
            }

            group.Records.push(record);
            (String(record.EmailType).toUpperCase() === 'CC' ? group.CcEmails : group.ToEmails).push(record);
            pushUnique(group.AddedByValues, record.AddedBy);
            pushDate(group.AddedDates, record.AddedDate);
            pushUnique(group.UpdatedByValues, record.UpdatedBy);
            pushDate(group.UpdatedDates, record.UpdatedDate);
        });

        return $.map(groups, function (group) {
            group.AddedByDisplay = group.AddedByValues.join(', ');
            group.AddedDateDisplay = earliestDateValue(group.AddedDates);
            group.UpdatedByDisplay = group.UpdatedByValues.join(', ');
            group.UpdatedDateDisplay = latestDateValue(group.UpdatedDates);
            return group;
        });
    }

    function renderEmailChips(records, type) {
        if (!records || !records.length) { return '<span class="text-muted">-</span>'; }

        return '<div class="pec-email-chips">' + $.map(records, function (record) {
            return '<span class="pec-email-chip ' + type.toLowerCase() + '-chip"><i class="fas fa-envelope"></i>' + encode(record.EmailID) + '</span>';
        }).join('') + '</div>';
    }

    function renderProjectActions() {
        return '<div class="pec-row-actions">' +
            '<button type="button" class="pec-edit-btn pec-project-action to-action pec-edit-to-btn" title="Edit To email addresses"><i class="fas fa-paper-plane"></i>&nbsp;Edit To</button>' +
            '<button type="button" class="pec-edit-btn pec-project-action cc-action pec-edit-cc-btn" title="Edit CC email addresses"><i class="fas fa-copy"></i>&nbsp;Edit CC</button>' +
            '<button type="button" class="pec-edit-btn pec-project-action pec-history-btn" title="View complete history"><i class="fas fa-history"></i>&nbsp;History</button>' +
            '</div>';
    }

    function pushUnique(values, value) {
        if (value === null || value === undefined || value === '') { return; }
        var text = String(value);
        if ($.inArray(text, values) === -1) { values.push(text); }
    }

    function pushDate(values, value) {
        if (value) { values.push(value); }
    }

    function earliestDateValue(values) {
        return getDateBoundary(values, false);
    }

    function latestDateValue(values) {
        return getDateBoundary(values, true);
    }

    function getDateBoundary(values, latest) {
        var selectedValue = '';
        var selectedTime = latest ? -Infinity : Infinity;

        $.each(values || [], function (_, value) {
            var time = parseDateValue(value).getTime();
            if (!isNaN(time) && ((latest && time > selectedTime) || (!latest && time < selectedTime))) {
                selectedTime = time;
                selectedValue = value;
            }
        });

        return selectedValue;
    }

    function openTypeEditModal(row, type) {
        if (!row) { return; }

        var isCc = type === 'CC';
        var context = isCc ? 'edit-cc' : 'edit-to';
        var records = isCc ? row.CcEmails : row.ToEmails;
        var prefix = isCc ? '#pecEditCc' : '#pecEditTo';

        $(prefix + 'ProjectId').val(row.ProjectID);
        $(prefix + 'Project').val(projectNames[String(row.ProjectID)] || row.ProjectID);
        resetTypeRows(type, records, context);
        $(prefix + 'Modal').modal('show');
    }

    function updateTypeConfiguration(type) {
        var isCc = type === 'CC';
        var prefix = isCc ? '#pecEditCc' : '#pecEditTo';
        var context = isCc ? 'edit-cc' : 'edit-to';
        var projectId = parseInt($(prefix + 'ProjectId').val(), 10);
        var emailResult = collectEmails(type, !isCc, context);

        if (!emailResult.isValid) {
            showValidation('Check ' + type + ' Addresses', emailResult.message, emailResult.$focus);
            return;
        }

        var $saveButton = $(isCc ? '#pecUpdateCc' : '#pecUpdateTo');
        $saveButton.prop('disabled', true);
        showSaving('Updating ' + type + ' Emails', 'Processing added, updated, and removed recipients...');

        callPageMethod('SaveProjectEmailType', {
            projectId: projectId,
            emailType: type,
            emailItems: emailResult.items
        })
            .done(function (response) {
                var result = response.d || {};
                if (result.Success) { $(prefix + 'Modal').modal('hide'); }
                showMessage(result.Success ? 'success' : 'error', result.Success ? type + ' Emails Updated' : 'Unable to Update', result.Message || 'The request could not be completed.');

                if (result.Success) {
                    loadConfigurations();
                    if ($('#pecProject').val() === String(projectId)) {
                        loadProjectEmails(projectId);
                    }
                }
            })
            .fail(handleRequestError)
            .always(function () { $saveButton.prop('disabled', false); });
    }

    function openHistoryModal(projectId) {
        callPageMethod('GetProjectEmailHistory', { projectId: parseInt(projectId, 10) })
            .done(function (response) {
                bindHistoryTable(parseRows(response.d));
                $('#pecHistoryTitle').html('<i class="fas fa-history mr-2"></i>Email History - ' + encode(projectNames[String(projectId)] || projectId));
                $('#pecHistoryModal').modal('show');
            })
            .fail(handleRequestError);
    }

    function bindHistoryTable(rows) {
        if ($.fn.DataTable.isDataTable('#pecHistoryTable')) {
            $('#pecHistoryTable').DataTable().clear().destroy();
        }

        historyTable = $('#pecHistoryTable').DataTable({
            data: rows,
            scrollX: true,
            autoWidth: false,
            pageLength: 10,
            order: [[7, 'desc']],
            language: { emptyTable: 'No history is available for this project.' },
            columns: [
                { data: 'ActionType', render: renderHistoryAction },
                { data: 'EmailType', className: 'text-center' },
                { data: 'PreviousEmailAddress', render: renderAuditValue },
                { data: 'NewEmailAddress', render: renderAuditValue },
                { data: 'PreviousStatus', className: 'text-center', render: renderStatus },
                { data: 'NewStatus', className: 'text-center', render: renderStatus },
                { data: 'ChangedBy', className: 'text-center', render: renderAuditValue },
                { data: 'ChangedDateTime', render: formatDateTime }
            ]
        });
    }

    function collectEmails(type, required, context) {
        var emails = [];
        var items = [];
        var keys = {};
        var result = { isValid: true, emails: emails, items: items };

        getEmailList(type, context).find('.pec-email-input').each(function () {
            var $input = $(this);
            var email = $.trim($input.val()).toLowerCase();

            if (!result.isValid || !email) { return; }

            if (!isValidEmail(email)) {
                result = { isValid: false, message: 'Invalid email address: ' + email, $focus: $input };
            } else if (keys[email]) {
                result = { isValid: false, message: 'Duplicate ' + type + ' email address found: ' + email, $focus: $input };
            } else {
                keys[email] = true;
                emails.push(email);
                items.push({
                    ConfigurationId: parseInt($input.closest('.pec-email-row').data('configuration-id'), 10) || 0,
                    EmailType: type,
                    EmailAddress: email
                });
            }
        });

        if (result.isValid && required && !emails.length) {
            result = { isValid: false, message: 'Please enter at least one To email address.', $focus: getEmailList(type, context).find('.pec-email-input').first() };
        }

        return result;
    }

    function addEmailRow(type, record, focusInput, context) {
        var $list = getEmailList(type, context);
        var rowNumber = $list.find('.pec-email-row').length + 1;
        var inputId = 'pec' + type + 'Email_' + new Date().getTime() + '_' + rowNumber;
        var email = record && typeof record === 'object' ? record.EmailID : (record || '');
        var configurationId = record && typeof record === 'object' ? record.ProjectEmailConfigurationID : 0;
        var $input = $('<input>', { id: inputId, type: 'email', class: 'pec-control pec-email-input', maxlength: 254, placeholder: 'name@example.com', value: email, 'aria-label': type + ' Email ID ' + rowNumber }).attr('autocomplete', 'off');
        var $wrap = $('<div>', { class: 'pec-input-wrap' }).append($('<i>', { class: 'fas fa-envelope' }), $input);
        var $remove = $('<button>', { type: 'button', class: 'pec-btn pec-btn-remove', title: 'Remove email', 'aria-label': 'Remove email' }).append($('<i>', { class: 'fas fa-trash-alt' }));

        $list.append($('<div>', { class: 'pec-email-row' }).attr('data-configuration-id', configurationId || '').append($wrap, $remove));
        if (focusInput) { $input.focus(); }
    }

    function resetRecipientRows(toEmails, ccEmails, context) {
        getEmailList('TO', context).empty();
        getEmailList('CC', context).empty();
        $.each(toEmails && toEmails.length ? toEmails : [null], function (_, record) { addEmailRow('TO', record, false, context); });
        $.each(ccEmails && ccEmails.length ? ccEmails : [null], function (_, record) { addEmailRow('CC', record, false, context); });
    }

    function resetTypeRows(type, records, context) {
        var $list = getEmailList(type, context).empty();
        $.each(records && records.length ? records : [null], function (_, record) {
            addEmailRow(type, record, false, context);
        });
        return $list;
    }

    function getEmailList(type, context) {
        if (context === 'edit-to') { return $('#pecEditToEmailList'); }
        if (context === 'edit-cc') { return $('#pecEditCcEmailList'); }
        return type === 'CC' ? $('#pecCcEmailList') : $('#pecToEmailList');
    }

    function getListContext($list) {
        if ($list.attr('id') === 'pecEditToEmailList') { return 'edit-to'; }
        if ($list.attr('id') === 'pecEditCcEmailList') { return 'edit-cc'; }
        return 'main';
    }

    function getProjectIdForList($list) {
        var context = getListContext($list);
        if (context === 'edit-to') { return parseInt($('#pecEditToProjectId').val(), 10); }
        if (context === 'edit-cc') { return parseInt($('#pecEditCcProjectId').val(), 10); }
        return parseInt($('#pecProject').val(), 10);
    }
    function callPageMethod(method, data)
    {
        return $.ajax({ type: 'POST', url: pageUrl + method, data: JSON.stringify(data || {}), contentType: 'application/json; charset=utf-8', dataType: 'json' });
    }

    function parseRows(json) { return !json ? [] : (typeof json === 'string' ? JSON.parse(json) : json); }

    function isValidEmail(email) { return email.length <= 254 && /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/.test(email); }

    function renderAuditValue(value) { return value === null || value === undefined || value === '' ? '-' : encode(value); }

    function renderHistoryAction(value) {
        var action = String(value || '').toLowerCase();
        var icon = action === 'insert' ? 'fa-plus' : action === 'update' ? 'fa-edit' : action === 'activate' ? 'fa-toggle-on' : action === 'deactivate' ? 'fa-toggle-off' : 'fa-trash-alt';
        return '<span class="pec-history-action pec-history-' + encode(action) + '"><i class="fas ' + icon + '"></i>' + encode(value || '-') + '</span>';
    }

    function renderStatus(value) {
        if (value === null || value === undefined || value === '') { return '-'; }
        var active = value === true || value === 1 || String(value).toLowerCase() === 'true';
        return '<span class="pec-status-pill ' + (active ? 'pec-status-active' : 'pec-status-inactive') + '">' + (active ? 'Active' : 'Inactive') + '</span>';
    }

    function formatDateTime(value) {
        if (!value) { return '-'; }
        var date = parseDateValue(value);
        if (isNaN(date.getTime())) { return encode(value); }
        return ('0' + date.getDate()).slice(-2) + '-' + getMonthName(date.getMonth()) + '-' + date.getFullYear() + ' ' + ('0' + date.getHours()).slice(-2) + ':' + ('0' + date.getMinutes()).slice(-2);
    }

    function parseDateValue(value) {
        var match = /\/Date\((\d+)\)\//.exec(String(value || ''));
        return match ? new Date(parseInt(match[1], 10)) : new Date(value);
    }

    function getMonthName(index) { return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][index]; }

    function encode(value) { return $('<div>').text(value === null || value === undefined ? '' : String(value)).html(); }

    function setLoading(value) { $('#pecConfigurationCard').toggleClass('pec-loading', value); }

    function showStatus(message) { $('#pecStatus').css('display', 'inline-flex').find('span').text(message); }

    function clearStatus() { $('#pecStatus').hide().find('span').text(''); }

    function showSaving(title, text) { Swal.fire({ title: title, text: text, allowOutsideClick: false, allowEscapeKey: false, showConfirmButton: false, didOpen: function () { Swal.showLoading(); } }); }

    function showValidation(title, message, $focus) { showMessage('warning', title, message).then(function () { if ($focus && $focus.length) { $focus.focus(); } }); }

    function showMessage(icon, title, message) { return Swal.fire({ icon: icon, title: title, text: message, confirmButtonColor: '#0f8a7d' }); }

    function handleRequestError(xhr) {
        var message = 'The request could not be completed. Please try again.';
        if (xhr && xhr.responseJSON && xhr.responseJSON.Message) { message = xhr.responseJSON.Message; }
        Swal.fire({ icon: 'error', title: 'Request Failed', text: message, confirmButtonColor: '#0f8a7d' });
    }
})(jQuery);
