(function ($, window, document) {
    'use strict';

    var um = { headerID: 0, month: '', year: '', context: null, employees: [], projects: [], resources: [], userTable: null, resourceTable: null, mappingTable: null, reportTable: null, confirmAction: null, editingMappingID: 0 };
    var months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

    function esc(value) { return $('<div>').text(value == null ? '' : String(value)).html(); }

    function date(value) {
        if (value == null || value === '') return '';
        var match = String(value).match(/^(\d{4}-\d{2}-\d{2})/);
        if (match) return match[1];
        var parsed = new Date(value);
        return isNaN(parsed.getTime()) ? '' : parsed.toISOString().substring(0, 10);
    }

    function api(method, args) {
        var url = 'UserMapping.aspx/' + method, query = [];
        if (um.month) query.push('Month=' + encodeURIComponent(um.month));
        if (um.year) query.push('Year=' + encodeURIComponent(um.year));
        if (query.length) url += '?' + query.join('&');
        return $.ajax({ type: 'POST', url: url, data: JSON.stringify(args || {}), dataType: 'json', contentType: 'application/json; charset=utf-8' });
    }

    function showMessage(title, message) {
        $('#um_message_title').text(title || 'Notice'); $('#um_message_body').text(message || ''); $('#um_message_modal').modal('show');
    }

    function errorMessage(xhr) {
        return xhr && xhr.responseJSON && xhr.responseJSON.Message ? xhr.responseJSON.Message : (xhr && xhr.responseText ? $('<div>').html(xhr.responseText).text().substring(0, 300) : 'The request could not be completed. Please try again.');
    }

    function busy(show) { $('#um_loader').toggleClass('show', !!show); }

    function fail(selector, message) { $(selector).text(message).show(); }

    function clearError(selector) { $(selector).hide().text(''); }

    function formatStatus(active) { return '<span class="um-status' + (active ? '' : ' off') + '">' + (active ? 'Active' : 'Deactivated') + '</span>'; }

    function refreshUsers() { return api('GetInvoiceUsers', { headerID: um.headerID, month: um.month, year: um.year }).done(function (res) { drawUsers(JSON.parse(res.d || '[]')); }); }

    function drawUsers(rows) {
        var config = {
            data: rows, destroy: true, scrollX: true, ordering: false, pageLength: 35, columns: [
                { data: null, render: function (v, t, r, meta) { return meta.row + 1; } },
                { data: 'Number', defaultContent: '' }, { data: 'Cost', defaultContent: '' }, { data: 'Code', defaultContent: '' },
                { data: 'Name', defaultContent: '' }, { data: 'PsuedoName', defaultContent: '' }, { data: 'Branch', defaultContent: '' },
                { data: 'Domain', defaultContent: '' }, { data: 'Project', defaultContent: '' }, { data: 'CurrentStatus', defaultContent: '' },
                { data: null, render: function (v, t, row) { return '<button type="button" class="btn btn-sm btn-outline-danger um-end-user" data-id="' + Number(row.InvID || 0) + '" data-name="' + esc((row.Code || '') + ' ' + (row.Name || '')).replace(/"/g, '&quot;') + '">End mapping</button>'; } }
            ]
        };
        if (um.userTable) { um.userTable.clear().destroy(); um.userTable = null; }
        um.userTable = $('#um_users_table').DataTable(config);
    }

    function loadEmployees() {
        return api('GetEmployees', { headerID: um.headerID }).done(function (res) {
            um.employees = JSON.parse(res.d || '[]');
            var select = $('#um_employee').empty().append($('<option>').val('').text('Select'));
            var multi = $('#um_mapping_employees').empty();
            $.each(um.employees, function (_, item) {
                $('<option>').val(item.Code).text(item.FullName).attr('data-email', item.EmailAddress || '').appendTo(select);
                $('<option>').val(item.Code).text(item.FullName + ' (' + item.Code + ')').appendTo(multi);
            });
            $('<option>').val('Other').text('Other').appendTo(select);
        });
    }

    function loadProjects() {
        return api('GetProjects', { headerID: um.headerID }).done(function (res) {
            um.projects = JSON.parse(res.d || '[]');
            var project = $('#um_project').empty(), filter = $('#um_resource_filter_project').empty(), report = $('#um_report_project').empty().append($('<option>').val('').text('All'));
            $.each(um.projects, function (_, item) {
                report.append($('<option>').val(item.ProjectID).text(item.ProjectName));
                if (um.context && String(item.ProjectID) === String(um.context.ProjectID)) {
                    project.append($('<option>').val(item.ProjectID).text(item.ProjectName));
                    filter.append($('<option>').val(item.ProjectID).text(item.ProjectName));
                }
            });
            project.val(um.context && um.context.ProjectID ? String(um.context.ProjectID) : '');
            filter.val(um.context && um.context.ProjectID ? String(um.context.ProjectID) : '');
        });
    }

    function loadDomains() {
        return api('GetDomains', { headerID: um.headerID }).done(function (res) {
            var domains = JSON.parse(res.d || '[]');
            $.each(domains, function (_, item) {
                var value = typeof item === 'string' ? item : (item.DomainName || '');
                if (value) {
                    $('#um_domain').append($('<option>').val(value).text(value));
                    $('#um_report_domain').append($('<option>').val(value).text(value));
                }
            });
            if (um.context && um.context.DomainName) $('#um_domain').val(um.context.DomainName);
        });
    }

    function bindResources() {
        var projectID = Number($('#um_resource_filter_project').val() || (um.context && um.context.ProjectID) || 0);
        return api('GetResources', { headerID: um.headerID, projectID: projectID }).done(function (res) {
            um.resources = JSON.parse(res.d || '[]');
            var employeeNames = {};
            $.each(um.employees, function (_, employee) { employeeNames[String(employee.Code).toLowerCase()] = employee.FullName; });
            $.each(um.resources, function (_, row) {
                row.MappedEmployees = (row.MappedEmployees || '').split(',').map(function (code) { code = $.trim(code); return employeeNames[code.toLowerCase()] ? employeeNames[code.toLowerCase()] + ' (' + code + ')' : code; }).filter(Boolean).join(', ');
            });
            var select = $('#um_mapping_resource').empty().append($('<option>').val('').text('Select resource'));
            $.each(um.resources, function (_, row) {
                $('<option>').val(row.ResourceID).text(row.ResourceName + ' (' + row.ResourceType + ')').appendTo(select);
            });
            if (um.resourceTable) { um.resourceTable.clear().destroy(); um.resourceTable = null; }
            um.resourceTable = $('#um_resources_table').DataTable({
                data: um.resources, destroy: true, scrollX: true, ordering: false, pageLength: 35,
                dom: 'Bfrtip', buttons: [{ extend: 'excelHtml5', title: 'Corporate Resources' }],
                columns: [
                    { data: 'ResourceID' }, { data: 'ResourceName' }, { data: 'ResourceType' }, { data: 'AccountIdentifier', defaultContent: '' },
                    { data: 'ProjectName' }, { data: 'DepartmentDomain', defaultContent: '' }, { data: 'MappedEmployees', defaultContent: '' },
                    { data: 'EffectiveFrom', render: function (v) { return date(v); } }, { data: 'EffectiveTo', render: function (v) { return date(v); } },
                    { data: 'IsActive', render: function (v) { return formatStatus(v === true || v === 'True' || v === 1); } }, { data: 'Remark', defaultContent: '' },
                    {
                        data: null, render: function (v, t, row) {
                            var active = row.IsActive === true || row.IsActive === 'True' || row.IsActive === 1;
                            return '<div class="um-actions"><button type="button" class="btn btn-sm btn-outline-info um-view-resource" data-id="' + Number(row.ResourceID) + '">View</button><button type="button" class="btn btn-sm btn-outline-primary um-edit-resource" data-id="' + Number(row.ResourceID) + '">Edit</button>' +
                                '<button type="button" class="btn btn-sm btn-outline-secondary um-toggle-resource" data-id="' + Number(row.ResourceID) + '" data-active="' + (active ? '0' : '1') + '">' + (active ? 'Deactivate' : 'Activate') + '</button>' +
                                '<button type="button" class="btn btn-sm btn-outline-info um-manage-resource" data-id="' + Number(row.ResourceID) + '">Manage Mapping</button></div>';
                        }
                    }
                ]
            });
        });
    }

    function bindMappings() {
        var id = Number($('#um_mapping_resource').val() || 0);
        if (!id) { drawMappings([]); return $.Deferred().resolve().promise(); }
        return api('GetMappings', { headerID: um.headerID, resourceID: id }).done(function (res) { drawMappings(JSON.parse(res.d || '[]')); });
    }

    function drawMappings(rows) {
        var names = {};
        $.each(um.employees, function (_, employee) { names[String(employee.Code).toLowerCase()] = employee.FullName; });
        $.each(rows, function (_, row) { var code = String(row.EmployeeCode || ''); row.EmployeeDisplay = (names[code.toLowerCase()] || code) + ' (' + code + ')'; });
        if (um.mappingTable) { um.mappingTable.clear().destroy(); um.mappingTable = null; }
        um.mappingTable = $('#um_mappings_table').DataTable({
            data: rows, destroy: true, scrollX: true, ordering: false, pageLength: 35, columns: [
                { data: 'EmployeeDisplay' }, { data: 'EffectiveFrom', render: function (v) { return date(v); } }, { data: 'EffectiveTo', render: function (v) { return date(v); } },
                { data: 'IsActive', render: function (v, t, row) { return row.IsHistory ? '<span class="um-status off">Historical revision</span>' : formatStatus(v === true || v === 'True' || v === 1); } },
                {
                    data: null, render: function (v, t, row) {
                        if (row.IsHistory || !(row.IsActive === true || row.IsActive === 'True' || row.IsActive === 1)) return '';
                        return '<div class="um-actions"><button type="button" class="btn btn-sm btn-outline-primary um-edit-mapping" data-id="' + Number(row.MappingID) + '">Edit dates</button><button type="button" class="btn btn-sm btn-outline-danger um-end-mapping" data-id="' + Number(row.MappingID) + '">End mapping</button></div>';
                    }
                }
            ]
        });
    }

    function clearResourceForm() {
        $('#um_resource_id').val(0); $('#um_resource_name,#um_account,#um_resource_from,#um_resource_to,#um_description,#um_remark').val('');
        $('#um_resource_type').val(''); $('#um_resource_status').val('1'); $('#um_project').val(String((um.context && um.context.ProjectID) || ''));
        $('#um_domain').val((um.context && um.context.DomainName) || ''); $('#um_save_resource').html('<i class="fas fa-save"></i> Save Resource'); clearError('#um_resource_error');
    }

    function saveResource() {

        alert($('#um_resource_name').val());

        //clearError('#um_resource_error');

        var name = $.trim($('#um_resource_name').val()),
            type = $('#um_resource_type').val(),
            projectID = Number($('#um_project').val() || 0),
            from = $('#um_resource_from').val(),
            to = $('#um_resource_to').val();

        alert(name = $.trim($('#um_resource_name').val()),
            type = $('#um_resource_type').val(),
            projectID = Number($('#um_project').val() || 0),
            from = $('#um_resource_from').val(),
            to = $('#um_resource_to').val());


        if (!name || !type || !projectID || !from)
            return fail('#um_resource_error', 'Resource Name, Resource Type, Project and Effective From are required.');
        if (to && to < from) return fail('#um_resource_error', 'Effective To cannot be earlier than Effective From.');

        busy(true);

        api('SaveResource', {
            headerID: um.headerID, resourceID: Number($('#um_resource_id').val() || 0), resourceName: name, resourceType: type,
            accountIdentifier: $.trim($('#um_account').val()), projectID: projectID, departmentDomain: $('#um_domain').val(),
            description: $('#um_description').val(), effectiveFrom: from, effectiveTo: to, isActive: $('#um_resource_status').val() === '1', remark: $('#um_remark').val()
        })
            .done(function (res) {
                var savedID = Number(res && res.d || 0);
                if (savedID <= 0) return fail('#um_resource_error', 'The server did not confirm that the resource was saved.');
                clearResourceForm();
                bindResources().done(function () { showMessage('Saved', 'Corporate resource saved successfully.'); })
                    .fail(function (xhr) { showMessage('Saved, but list refresh failed', errorMessage(xhr)); });
            })
            .fail(function (xhr) { fail('#um_resource_error', errorMessage(xhr)); })
            .always(function () { busy(false); });
    }

    function ask(message, action, dateInputId) {
        $('#um_confirm_body').text(message);
        if (dateInputId) $('<input type="date" class="form-control mt-2">').attr('id', dateInputId).val(new Date().toISOString().substring(0, 10)).appendTo('#um_confirm_body');
        um.confirmAction = action; $('#um_confirm_modal').modal('show');
    }

    function runReport() {
        busy(true);
        api('GetReport', {
            headerID: um.headerID, month: $('#um_report_month').val(), year: $('#um_report_year').val(), recordType: $('#um_report_type').val(),
            projectID: Number($('#um_report_project').val() || 0), departmentDomain: $('#um_report_domain').val(), resourceType: $('#um_report_resource_type').val(),
            status: $('#um_report_status').val(), effectiveFrom: $('#um_report_from').val(), effectiveTo: $('#um_report_to').val()
        })
            .done(function (res) {
                var rows = JSON.parse(res.d || '[]');
                if (um.reportTable) { um.reportTable.clear().destroy(); um.reportTable = null; }
                um.reportTable = $('#um_report_table').DataTable({
                    data: rows, destroy: true, scrollX: true, ordering: false, pageLength: 35, dom: 'Bfrtip', buttons: [{ extend: 'excelHtml5', title: 'Credit Card Reconciliation User Mapping' }], columns: [
                        { data: 'RecordType' }, { data: 'DisplayName' }, { data: 'Code' }, { data: 'ResourceType' }, { data: 'AccountIdentifier' }, { data: 'Project' }, { data: 'Department' }, { data: 'Domain' },
                        { data: 'MappedEmployees' }, { data: 'BillingMonth' }, { data: 'BillingYear' }, { data: 'BillingDate', render: function (v) { return date(v); } },
                        { data: 'EffectiveFrom', render: function (v) { return date(v); } }, { data: 'EffectiveTo', render: function (v) { return date(v); } }, { data: 'BillingAmount' }, { data: 'Status' }, { data: 'Remark' }
                    ]
                });
            }).fail(function (xhr) { showMessage('Unable to load report', errorMessage(xhr)); }).always(function () { busy(false); });
    }

    function init() {
        if (!$('#um_page').length) return;
        um.headerID = Number($('#um_page').attr('data-header-id') || 0); um.month = $('#um_page').attr('data-month') || ''; um.year = $('#um_page').attr('data-year') || '';
        if (!um.headerID) {
            $('#um_context').text(window.umLoadError || 'The selected invoice could not be opened. Check that it is assigned to a project and that you have access.');
            return;
        }
        var now = new Date().getFullYear(), years = $('#um_report_year');
        for (var y = now; y >= now - 7; y--) years.append($('<option>').val(y).text(y));
        if (months.indexOf(um.month) >= 0) $('#um_report_month').val(um.month);
        if (um.year) $('#um_report_year').val(um.year);
        busy(true);
        api('GetContext', { headerID: um.headerID }).done(function (res) {
            um.context = JSON.parse(res.d || '{}');
            $('#um_context').text((um.context.Header || 'Invoice') + ' · ' + (um.context.ProjectName || 'Project not assigned') + ' · ' + (um.context.DomainName || ''));
            $.when(loadEmployees(), loadProjects(), loadDomains(), refreshUsers()).done(function () { bindResources(); }).fail(function (xhr) { showMessage('Unable to load page', errorMessage(xhr)); }).always(function () { busy(false); });
        }).fail(function (xhr) { busy(false); showMessage('Unable to open invoice', errorMessage(xhr)); });

        $('#um_employee').on('change', function () { $('#um_other_wrap').toggle($(this).val() === 'Other'); });

        $('#um_add_user').on('click', function () {
            clearError('#um_user_error');
            var code = $('#um_employee').val(), dateValue = $('#um_user_from').val(), selected = $('#um_employee option:selected');
            if (!code || !dateValue) return fail('#um_user_error', 'Select an employee and effective date.');
            if (code === 'Other' && !$.trim($('#um_other').val())) return fail('#um_user_error', 'Enter the other user name.');
            busy(true);
            api('AddInvoiceUser', { headerID: um.headerID, code: code, otherUser: $('#um_other').val(), emailAddress: selected.attr('data-email') || '', effectiveDate: dateValue })
                .done(function (res) { if (Number(res.d) > 0) { $('#um_employee').val(''); $('#um_other,#um_user_from').val(''); $('#um_other_wrap').hide(); refreshUsers(); showMessage('Saved', 'Invoice user added successfully.'); } else fail('#um_user_error', 'The user was not added. Check for a duplicate mapping.'); })
                .fail(function (xhr) { fail('#um_user_error', errorMessage(xhr)); }).always(function () { busy(false); });
        });

        $('#um_users_table').on('click', '.um-end-user', function () {
            var id = Number($(this).data('id')), name = $(this).attr('data-name');
            if (!id) return;
            ask('End invoice user mapping for ' + name + '? Choose the effective date.', function () {
                var effectiveDate = $('#um_end_user_date').val(); if (!effectiveDate) return showMessage('Validation', 'Select an effective date.');
                busy(true); api('EndInvoiceUser', { headerID: um.headerID, invoiceUserID: id, effectiveDate: effectiveDate }).done(function (res) { if (Number(res.d) > 0) { refreshUsers(); showMessage('Updated', 'Invoice user mapping ended.'); } else showMessage('Unable to update', 'The user mapping was not changed.'); }).fail(function (xhr) { showMessage('Unable to update', errorMessage(xhr)); }).always(function () { busy(false); });
            }, 'um_end_user_date');
        });

        $('#um_save_resource').on('click', saveResource); $('#um_clear_resource').on('click', clearResourceForm);

        $('#um_resource_filter_project').on('change', bindResources);

        $('#um_resources_table').on('click', '.um-edit-resource', function () {
            var row = um.resources.filter(function (item) { return Number(item.ResourceID) === Number($(this).data('id')); }.bind(this))[0]; if (!row) return;
            $('#um_resource_id').val(row.ResourceID); $('#um_resource_name').val(row.ResourceName); $('#um_resource_type').val(row.ResourceType); $('#um_account').val(row.AccountIdentifier);
            $('#um_project').val(row.ProjectID); $('#um_domain').val(row.DepartmentDomain); $('#um_resource_from').val(date(row.EffectiveFrom)); $('#um_resource_to').val(date(row.EffectiveTo));
            $('#um_resource_status').val(row.IsActive === true || row.IsActive === 'True' || row.IsActive === 1 ? '1' : '0'); $('#um_description').val(row.Description); $('#um_remark').val(row.Remark);
            $('#um_save_resource').html('<i class="fas fa-save"></i> Update Resource'); window.scrollTo(0, 0);
        });

        $('#um_resources_table').on('click', '.um-view-resource', function () {
            var row = um.resources.filter(function (item) { return Number(item.ResourceID) === Number($(this).data('id')); }.bind(this))[0];
            if (!row) return;
            $('#um_message_title').text('Corporate Resource');
            $('#um_message_body').empty().append($('<dl class="row mb-0">')
                .append($('<dt class="col-sm-4">').text('Resource')).append($('<dd class="col-sm-8">').text(row.ResourceName))
                .append($('<dt class="col-sm-4">').text('Type')).append($('<dd class="col-sm-8">').text(row.ResourceType))
                .append($('<dt class="col-sm-4">').text('Account')).append($('<dd class="col-sm-8">').text(row.AccountIdentifier || ''))
                .append($('<dt class="col-sm-4">').text('Purpose')).append($('<dd class="col-sm-8">').text(row.Description || ''))
                .append($('<dt class="col-sm-4">').text('Remark')).append($('<dd class="col-sm-8">').text(row.Remark || '')));
            $('#um_message_modal').modal('show');
        });

        $('#um_resources_table').on('click', '.um-toggle-resource', function () {
            var id = Number($(this).data('id')), active = String($(this).data('active')) === '1';
            ask((active ? 'Activate' : 'Deactivate') + ' this corporate resource?', function () {
                busy(true); api('SetResourceStatus', { headerID: um.headerID, resourceID: id, isActive: active }).done(function () { bindResources(); showMessage('Updated', 'Corporate resource status updated.'); }).fail(function (xhr) { showMessage('Unable to update', errorMessage(xhr)); }).always(function () { busy(false); });
            });
        });

        $('#um_resources_table').on('click', '.um-manage-resource', function () { $('#um_mapping_resource').val(String($(this).data('id'))); bindMappings(); $('#um_mapping_resource')[0].scrollIntoView({ behavior: 'smooth', block: 'center' }); });

        $('#um_mapping_resource').on('change', bindMappings);

        $('#um_save_mapping').on('click', function () {
            clearError('#um_mapping_error'); var id = Number($('#um_mapping_resource').val() || 0), codes = $('#um_mapping_employees').val() || [], from = $('#um_mapping_from').val(), to = $('#um_mapping_to').val();
            if (!id || (!um.editingMappingID && !codes.length) || !from) return fail('#um_mapping_error', 'Select a resource, at least one employee and an effective from date.');
            if (to && to < from) return fail('#um_mapping_error', 'Mapping Effective To cannot be earlier than Effective From.');
            busy(true);
            var request = um.editingMappingID
                ? api('UpdateMapping', { headerID: um.headerID, mappingID: um.editingMappingID, effectiveFrom: from, effectiveTo: to })
                : api('SaveMappings', { headerID: um.headerID, resourceID: id, employeeCodes: codes, effectiveFrom: from, effectiveTo: to });
            request.done(function () { $('#um_mapping_employees').val([]).prop('disabled', false); $('#um_mapping_resource').prop('disabled', false); $('#um_mapping_from,#um_mapping_to').val(''); um.editingMappingID = 0; $('#um_save_mapping').html('<i class="fas fa-user-plus"></i> Add Employee Mapping'); $('#um_cancel_mapping_edit').hide(); bindMappings(); bindResources(); showMessage('Saved', 'Employee mappings saved. Previous values are retained in history.'); })
                .fail(function (xhr) { fail('#um_mapping_error', errorMessage(xhr)); }).always(function () { busy(false); });
        });

        $('#um_cancel_mapping_edit').on('click', function () { um.editingMappingID = 0; $('#um_mapping_employees').val([]).prop('disabled', false); $('#um_mapping_resource').prop('disabled', false); $('#um_mapping_from,#um_mapping_to').val(''); $('#um_save_mapping').html('<i class="fas fa-user-plus"></i> Add Employee Mapping'); $('#um_cancel_mapping_edit').hide(); clearError('#um_mapping_error'); });

        $('#um_mappings_table').on('click', '.um-edit-mapping', function () {
            var id = Number($(this).data('id')), apiTable = um.mappingTable, data = apiTable.row($(this).closest('tr')).data();
            if (!data) return;
            um.editingMappingID = id; $('#um_mapping_resource').val(String(data.ResourceID)).prop('disabled', true);
            $('#um_mapping_employees').val([data.EmployeeCode]).prop('disabled', true); $('#um_mapping_from').val(date(data.EffectiveFrom)); $('#um_mapping_to').val(date(data.EffectiveTo));
            $('#um_save_mapping').html('<i class="fas fa-save"></i> Update Mapping'); $('#um_cancel_mapping_edit').show();
        });

        $('#um_associate_billing').on('click', function () {
            var resourceID = Number($('#um_mapping_resource').val() || 0), month = um.month, year = um.year;
            if (!resourceID) return fail('#um_mapping_error', 'Select a corporate resource first.');
            if (!month || !year || month === 'All') return fail('#um_mapping_error', 'Open this page from a specific invoice billing month and year to associate a corporate resource.');
            ask('Associate this corporate resource with the selected invoice and billing period?', function () {
                busy(true); api('AssociateBilling', { headerID: um.headerID, month: month, year: year, resourceID: resourceID }).done(function () { showMessage('Saved', 'Corporate resource associated with this billing period.'); }).fail(function (xhr) { showMessage('Unable to associate', errorMessage(xhr)); }).always(function () { busy(false); });
            });
        });

        $('#um_mappings_table').on('click', '.um-end-mapping', function () {
            var id = Number($(this).data('id'));
            ask('End employee mapping? Choose the effective date.', function () { var end = $('#um_end_mapping_date').val(); if (!end) return showMessage('Validation', 'Select an effective date.'); busy(true); api('EndMapping', { headerID: um.headerID, mappingID: id, effectiveTo: end }).done(function () { bindMappings(); bindResources(); showMessage('Updated', 'Mapping history was retained and the mapping ended.'); }).fail(function (xhr) { showMessage('Unable to update', errorMessage(xhr)); }).always(function () { busy(false); }); }, 'um_end_mapping_date');
        });

        $('#um_run_report').on('click', runReport);

        $('#um_confirm_yes').on('click', function () { var action = um.confirmAction; um.confirmAction = null; $('#um_confirm_modal').modal('hide'); if (action) action(); });

        $('a[data-toggle="tab"]').on('shown.bs.tab', function () { $.fn.dataTable.tables({ visible: true, api: true }).columns.adjust(); });
    }

    $(document).ready(init);
})(jQuery, window, document);
