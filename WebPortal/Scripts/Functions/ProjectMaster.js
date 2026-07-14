var ProjectMaster = (function () {
    var rows = [];
    var table = null;

    function init() {
        bindEvents();
        initTable();
        loadProjects();
    }

    function bindEvents() {
        $('#pm_btnCreate').off('click.projectmaster').on('click.projectmaster', createProject);
        $('#pm_btnRefresh').off('click.projectmaster').on('click.projectmaster', loadProjects);
        $('#pm_btnSaveEdit').off('click.projectmaster').on('click.projectmaster', saveEditedProject);
        $('#pm_statusFilter').off('change.projectmaster').on('change.projectmaster', applyStatusFilter);

        $('#pm_projectName').off('keydown.projectmaster').on('keydown.projectmaster', function (event) {
            if (event.key === 'Enter') {
                event.preventDefault();
                createProject();
            }
        });

        $('#pm_table')
            .off('click.projectmaster', '.pm-edit')
            .on('click.projectmaster', '.pm-edit', function () {
                openEditModal(parseInt($(this).attr('data-id'), 10));
            })
            .off('click.projectmaster', '.pm-delete')
            .on('click.projectmaster', '.pm-delete', function () {
                confirmDelete(parseInt($(this).attr('data-id'), 10));
            });
    }

    function pageMethod(method, data, success, error) {
        $.ajax({
            type: 'POST',
            url: 'ProjectMaster.aspx/' + method,
            data: JSON.stringify(data || {}),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (response) {
                if (success) success(response.d);
            },
            error: function (xhr) {
                var message = 'Unable to complete the request.';
                try {
                    message = (xhr.responseJSON && xhr.responseJSON.Message) || xhr.responseText || message;
                } catch (e) { }

                if (error) error(message);
                else showMessage('error', message);
            }
        });
    }

    function initTable() {
        if (!$.fn.DataTable || $.fn.DataTable.isDataTable('#pm_table')) {
            return;
        }

        table = $('#pm_table').DataTable({
            data: [],
            paging: true,
            pageLength: 10,
            lengthMenu: [[10, 25, 50, -1], [10, 25, 50, 'All']],
            searching: true,
            info: true,
            ordering: true,
            order: [[3, 'asc']],
            autoWidth: false,
            responsive: false,
            language: {
                emptyTable: 'No projects found.',
                search: '',
                searchPlaceholder: 'Search projects...'
            },
            columns: [
                {
                    data: null,
                    width: '52px',
                    orderable: false,
                    render: function (data, type, row, meta) {
                        return meta.row + meta.settings._iDisplayStart + 1;
                    }
                },
                { data: 'ProjectId', width: '78px', render: renderText },
                { data: 'DomainName', render: renderText },
                {
                    data: 'ProjectName',
                    render: function (value, type) {
                        if (type !== 'display') return value || '';
                        return '<span class="pm-project-name">' + escapeHtml(value || '-') + '</span>';
                    }
                },
                { data: 'AddedByName', render: renderText },
                { data: 'AddedDate', render: renderText },
                {
                    data: 'ProjectStatus',
                    render: function (value, type) {
                        var status = normalizeStatus(value);
                        if (type !== 'display') return status;
                        var inactiveClass = status === 'Active' ? '' : ' is-inactive';
                        var icon = status === 'Active' ? 'fa-check-circle' : 'fa-pause-circle';
                        var label = status === 'Active' ? 'Active' : 'Inactive';
                        return '<span class="pm-status-badge' + inactiveClass + '"><i class="fas ' + icon + '"></i>' + label + '</span>';
                    }
                },
                {
                    data: null,
                    orderable: false,
                    searchable: false,
                    width: '160px',
                    render: function (data, type, row) {
                        return '<div class="pm-row-actions">'
                            + '<button type="button" class="pm-action-btn pm-edit" data-id="' + Number(row.ProjectId || 0) + '"><i class="fas fa-edit"></i>Edit</button>'
                            + '<button type="button" class="pm-action-btn pm-delete" data-id="' + Number(row.ProjectId || 0) + '"><i class="fas fa-trash-alt"></i>Delete</button>'
                            + '</div>';
                    }
                }
            ]
        });
    }

    function renderText(value, type) {
        var text = value === undefined || value === null || String(value).trim() === '' ? '-' : String(value);
        return type === 'display' ? escapeHtml(text) : text;
    }

    function escapeHtml(value) {
        return $('<div></div>').text(value === undefined || value === null ? '' : String(value)).html();
    }

    function normalizeStatus(value) {
        var text = String(value === undefined || value === null ? '' : value).toLowerCase();
        return text === 'active' || text === 'true' || text === '1' ? 'Active' : 'Deactive';
    }

    function loadProjects() {
        showLoading('Loading project directory...');
        $('#pm_btnRefresh').prop('disabled', true);

        pageMethod('GetProjects', {}, function (result) {
            hideLoading();
            $('#pm_btnRefresh').prop('disabled', false);
            result = result || {};

            if (!result.Success) {
                showMessage('error', result.Message || 'Unable to load projects.');
                return;
            }

            rows = $.map(result.Rows || [], function (row) {
                row.ProjectStatus = normalizeStatus(row.ProjectStatus);
                return row;
            });
            drawTable();
            updateSummary();
        }, function (message) {
            hideLoading();
            $('#pm_btnRefresh').prop('disabled', false);
            showMessage('error', message || 'Unable to load projects.');
        });

        return false;
    }

    function drawTable() {
        if (table) {
            table.clear().rows.add(rows).draw(false);
            applyStatusFilter();
            return;
        }

        var $body = $('#pm_table tbody').empty();
        $.each(rows, function (index, row) {
            var status = normalizeStatus(row.ProjectStatus);
            var $tr = $('<tr></tr>').attr('data-status', status);
            $('<td></td>').text(row.SrNo).appendTo($tr);
            $('<td></td>').text(row.ProjectId || '').appendTo($tr);
            $('<td></td>').text(row.DomainName || '').appendTo($tr);
            $('<td></td>').addClass('pm-project-name').text(row.ProjectName || '-').appendTo($tr);
            $('<td></td>').text(row.AddedByName || '').appendTo($tr);
            $('<td></td>').text(row.AddedDate || '').appendTo($tr);
            $('<td></td>').text(status === 'Active' ? 'Active' : 'Inactive').appendTo($tr);

            var $actions = $('<td></td>');
            $('<button type="button" class="pm-action-btn pm-edit"><i class="fas fa-edit"></i> Edit</button>').attr('data-id', row.ProjectId).appendTo($actions);
            $('<button type="button" class="pm-action-btn pm-delete ml-1"><i class="fas fa-trash-alt"></i> Delete</button>').attr('data-id', row.ProjectId).appendTo($actions);
            $actions.appendTo($tr);
            $tr.appendTo($body);
        });

        applyStatusFilter();
    }

    function updateSummary() {
        var active = 0;
        var domains = {};

        $.each(rows, function (_, row) {
            if (normalizeStatus(row.ProjectStatus) === 'Active') active++;
            var domain = $.trim(row.DomainName || '');
            if (domain) domains[domain.toLowerCase()] = true;
        });

        $('#pm_statTotal').text(rows.length);
        $('#pm_statActive').text(active);
        $('#pm_statInactive').text(rows.length - active);
        $('#pm_statDomains').text(Object.keys(domains).length);
    }

    function applyStatusFilter() {
        var status = $('#pm_statusFilter').val() || '';

        if (table) {
            table.column(6).search(status ? '^' + status + '$' : '', true, false).draw();
            return;
        }

        $('#pm_table tbody tr').each(function () {
            $(this).toggle(!status || $(this).attr('data-status') === status);
        });
    }

    function validateProjectName(value) {
        value = $.trim(value || '');
        if (!value) return 'Please enter Project name.';
        if (value.length > 100) return 'Project name cannot exceed 100 characters.';
        if (!/^[0-9A-Za-z-]+(?: [0-9A-Za-z-]+)*$/.test(value)) {
            return 'Use only letters, numbers, spaces, and hyphens.';
        }
        return '';
    }

    function createProject() {
        var projectName = $.trim($('#pm_projectName').val() || '');
        var validation = validateProjectName(projectName);
        if (validation) {
            showMessage('warning', validation);
            return false;
        }

        $('#pm_btnCreate').prop('disabled', true);
        showLoading('Creating project...');
        saveProject({ ProjectId: 0, ProjectName: projectName, IsActive: true }, function (result) {
            $('#pm_btnCreate').prop('disabled', false);

            if (result.RequiresRestore) {
                confirmRestore(projectName, result.Message);
                return;
            }

            if (!result.Success) {
                showMessage('warning', result.Message || 'Project already exists.');
                return;
            }

            $('#pm_projectName').val('').trigger('focus');
            showMessage('success', result.Message || 'Project created successfully.');
            loadProjects();
        });

        return false;
    }

    function openEditModal(projectId) {
        var row = findProject(projectId);
        if (!row) {
            showMessage('warning', 'Project record was not found.');
            return;
        }

        $('#pm_editId').val(row.ProjectId);
        $('#pm_editName').val(row.ProjectName || '');
        $('#pm_editStatus').val(normalizeStatus(row.ProjectStatus));
        $('#pm_editModal').modal('show');
    }

    function saveEditedProject() {
        var projectId = parseInt($('#pm_editId').val() || '0', 10);
        var projectName = $.trim($('#pm_editName').val() || '');
        var validation = validateProjectName(projectName);

        if (!projectId) {
            showMessage('warning', 'Invalid project record.');
            return false;
        }

        if (validation) {
            showMessage('warning', validation);
            return false;
        }

        $('#pm_btnSaveEdit').prop('disabled', true);
        showLoading('Saving project changes...');
        saveProject({
            ProjectId: projectId,
            ProjectName: projectName,
            IsActive: $('#pm_editStatus').val() === 'Active'
        }, function (result) {
            $('#pm_btnSaveEdit').prop('disabled', false);

            if (!result.Success) {
                showMessage('warning', result.Message || 'Project already exists.');
                return;
            }

            $('#pm_editModal').modal('hide');
            showMessage('success', result.Message || 'Project updated successfully.');
            loadProjects();
        });

        return false;
    }

    function saveProject(request, complete) {
        pageMethod('SaveProject', { request: request }, function (result) {
            hideLoading();
            if (complete) complete(result || {});
        }, function (message) {
            hideLoading();
            $('#pm_btnCreate,#pm_btnSaveEdit').prop('disabled', false);
            showMessage('error', message || 'Unable to save project.');
        });
    }

    function confirmRestore(projectName, message) {
        Swal.fire({
            icon: 'question',
            title: 'Restore project?',
            text: message || 'This project was previously deleted. Do you want to restore it?',
            showCancelButton: true,
            confirmButtonText: 'Yes, restore',
            cancelButtonText: 'No',
            confirmButtonColor: '#1d4ed8'
        }).then(function (choice) {
            if (!choice.isConfirmed) return;

            showLoading('Restoring project...');
            pageMethod('RestoreProject', { projectName: projectName }, function (result) {
                hideLoading();
                result = result || {};
                showMessage(result.Success ? 'success' : 'warning', result.Message || 'Unable to restore project.');
                if (result.Success) {
                    $('#pm_projectName').val('');
                    loadProjects();
                }
            }, function (error) {
                hideLoading();
                showMessage('error', error || 'Unable to restore project.');
            });
        });
    }

    function confirmDelete(projectId) {
        var row = findProject(projectId);
        if (!row) {
            showMessage('warning', 'Project record was not found.');
            return;
        }

        Swal.fire({
            icon: 'warning',
            title: 'Delete project?',
            html: 'Delete <strong>' + escapeHtml(row.ProjectName || 'this project') + '</strong>?',
            showCancelButton: true,
            confirmButtonText: 'Delete',
            cancelButtonText: 'Cancel',
            confirmButtonColor: '#dc2626'
        }).then(function (choice) {
            if (!choice.isConfirmed) return;

            showLoading('Deleting project...');
            pageMethod('DeleteProject', { projectId: projectId }, function (result) {
                hideLoading();
                result = result || {};
                showMessage(result.Success ? 'success' : 'warning', result.Message || 'Unable to delete project.');
                if (result.Success) loadProjects();
            }, function (message) {
                hideLoading();
                showMessage('error', message || 'Unable to delete project.');
            });
        });
    }

    function findProject(projectId) {
        for (var i = 0; i < rows.length; i++) {
            if (parseInt(rows[i].ProjectId, 10) === projectId) return rows[i];
        }
        return null;
    }

    function showLoading(message) {
        $('#pm_loadingText').text(message || 'Please wait...');
        $('#pm_loading').css('display', 'flex').attr('aria-hidden', 'false');
    }

    function hideLoading() {
        $('#pm_loading').hide().attr('aria-hidden', 'true');
    }

    function showMessage(type, message) {
        var title = type === 'success' ? 'Success' : type === 'error' ? 'Error' : type === 'warning' ? 'Validation' : 'Information';

        if (window.Swal) {
            Swal.fire({ icon: type, title: title, text: message });
        } else {
            alert(message);
        }
    }

    return {
        init: init,
        loadProjects: loadProjects,
        createProject: createProject
    };
})();

$(document).ready(function () {
    ProjectMaster.init();
});
