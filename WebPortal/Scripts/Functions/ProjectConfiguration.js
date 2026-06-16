function formatJsonDate(jsonDate) {

    if (!jsonDate)
        return '';

    let timestamp =
        parseInt(
            jsonDate.replace('/Date(', '')
                .replace(')/', '')
        );

    let date = new Date(timestamp);

    return date.toLocaleDateString('en-GB') + ' ' +

        date.toLocaleTimeString('en-GB', {

            hour: '2-digit',
            minute: '2-digit'

        });

}
/*-------------------  Project Configuration -------------------*/

function projectconf_binddomaingroups() {
    var select = document.getElementById("projectconf_domain");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#projectconf_domain").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "ProjectConfiguration.aspx/GetAllDomainGroups", dataType: "json", contentType: "application/json",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                $("#projectconf_domain").append($("<option></option>").val(value.DomainID).html(value.DomainName));
            })
        }

    });
}

function projectconf_domainchange() {
    var select = document.getElementById("projectconf_subdomain");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    var ddlDomain = document.getElementById('projectconf_domain');
    var index = ddlDomain.selectedIndex;
    var DomainGroupId = ddlDomain.options[index].value;
    $("#projectconf_subdomain").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "ProjectConfiguration.aspx/GetSubdomains", dataType: "json", contentType: "application/json",
        data: "{DomainGroupId:" + DomainGroupId + "}",
        success: function (res) {
            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (data, value) {
                $("#projectconf_subdomain").append($("<option></option>").val(value.SubdomainID).html(value.SubdomainName));
            })
        }
    });
    return false;
}

function projectconf_getprojectslist() {
    if ($.fn.DataTable.isDataTable('#projectconf_projectslist')) {
        $('#projectconf_projectslist').DataTable().clear().destroy();
        /* $('#table_slareport').empty();*/
    }

    $('#projectconf_projectslist').DataTable({
        destroy: true,
        scrollX: true,
        scrollCollapse: true,
        autoWidth: false,
        dom: "lftp",

        ajax: {
            type: "POST",
            url: "ProjectConfiguration.aspx/GetAllProjects",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            dataSrc: function (json) {
                return JSON.parse(json.d);
            }
        },
        columns: [
            {
                data: null,
                orderable: false,
                searchable: false,
                className: 'dt-center',
                render: function (data, type, row) {

                    return `
                            <i class="fa fa-edit text-primary edit-btn"
                               title="Edit Project"
                               style="cursor:pointer;font-size:12px;"
                               onclick="projectconf_editproject('${row.ProjectID}')">
                            </i>
                        `;
                }
            },
            { data: "ProjectID", visible: false },
            { data: "ProjectName" },
            { data: "DomainName" },
            { data: "SubdomainName" },
            { data: "Process" },
            { data: "ProjectStartDate" },
            { data: "BillingCycle" },
            { data: "DueDays" },
            { data: "ProjectType" },
            { data: "Type" },
            { data: "Remark" },
            { data: "ProjectActiveStatus" },
            { data: "DeactivetdDate" },
            { data: "Reason" },
            { data: "AddedByName" },
            { data: "AddedDate1" },
            { data: "SubdomainID", visible: false },
            { data: "DomainID", visible: false }

        ],
        fnCreatedRow: function (nRow, aData, iDataIndex) {
            $(nRow).children("td").css("text-wrap", "nowrap");
        },

        initComplete: function () {
        }
    });

}

function projectconf_editproject(projectid) {

    var table = $('#projectconf_projectslist').DataTable();

    var data = table.rows().data().toArray();

    var row = data.find(x => x.ProjectID == projectid);

    if (row == null)
        return;

    $('#projectconf_projectid').val(row.ProjectID);

    $('#projectconf_projectno').val(row.ProjectName);

    $('#projectconf_domain').val(row.DomainID).trigger('change');

    setTimeout(function () {
        $('#projectconf_subdomain').val(row.SubdomainID);
    }, 300);

    if (row.ProjectStartDate != null && row.ProjectStartDate != '') {

        var dt = new Date(row.ProjectStartDate);

        var formattedDate =
            dt.getFullYear() + '-' +
            String(dt.getMonth() + 1).padStart(2, '0') + '-' +
            String(dt.getDate()).padStart(2, '0');

        $('#projectconf_startdate').val(formattedDate);
    }

    //  $('#projectconf_startdate').val(row.ProjectStartDate);

    $('#projectconf_billingcycle').val(row.BillingCycle);

    $('#projectconf_duedays').val(row.DueDays);

    $('#projectconf_clientprocessname').val(row.Process);

    $('#projectconf_projecttype').val(row.ProjectType);

    $('#projectconf_projectstatus').val(row.ProjectActiveStatus);

    $('#projectconf_type').val(row.Type);

    $('#projectconf_remark').val(row.Remark);

    $('#projectconf_btnsubmit')
        .removeClass('btn-primary')
        .addClass('btn-warning')
        .text('Update');
}

function projectconf_submit() {

    var projectid = $('#projectconf_projectid').val();

    var obj = {

        ProjectID: projectid,

        ProjectName: $('#projectconf_projectno').val(),

        DomainID: $('#projectconf_domain').val(),

        SubdomainID: $('#projectconf_subdomain').val(),

        ProjectStartDate: $('#projectconf_startdate').val(),

        BillingCycle: $('#projectconf_billingcycle').val(),

        DueDays: $('#projectconf_duedays').val(),

        Process: $('#projectconf_clientprocessname').val(),

        ProjectType: $('#projectconf_projecttype').val(),

        ProjectActiveStatus: $('#projectconf_projectstatus').val(),

        Type: $('#projectconf_type').val(),

        Remark: $('#projectconf_remark').val()
    };

    $.ajax({

        type: "POST",

        url: "ProjectConfiguration.aspx/SaveProject",

        data: JSON.stringify({ obj: obj }),

        contentType: "application/json; charset=utf-8",

        dataType: "json",

        success: function (response) {
            Swal.fire({
                icon: 'success',
                title: 'Success',
                text: 'Project saved successfully',
                confirmButtonColor: '#3085d6'
            });
            //alert('Project Updated Successfully');

            projectconf_clear();

            projectconf_getprojectslist();
        },

        error: function () {
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'Something went wrong',
                confirmButtonColor: '#d33'
            });
            //alert('Error while updating');
        }
    });

    return false;
}

function projectconf_clear() {

    $('#projectconf_projectid').val('0');

    $('#projectconf_projectno').val('');

    $('#projectconf_domain').val('').trigger('change');

    $('#projectconf_subdomain').empty();

    $('#projectconf_startdate').val('');

    $('#projectconf_billingcycle').val('');

    $('#projectconf_duedays').val('');

    $('#projectconf_clientprocessname').val('');

    $('#projectconf_projecttype').val('');

    $('#projectconf_projectstatus').val('');

    $('#projectconf_type').val('');

    $('#projectconf_remark').val('');

    $('#projectconf_btnsubmit')
        .removeClass('btn-warning')
        .addClass('btn-primary')
        .text('Submit');
}


/*-------------------  Process Configuration -------------------*/
function processconf_getprocesslist() {
    if ($.fn.DataTable.isDataTable('#projectconf_processlist')) {
        $('#projectconf_processlist')
            .DataTable()
            .clear()
            .destroy();
    }
    $('#projectconf_processlist').DataTable({
        destroy: true,
        processing: false,
        scrollX: true,
        autoWidth: true,
        ajax: {
            type: "POST",
            url: "ProjectConfiguration.aspx/GetAllProcess",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            dataSrc: function (json) {
                return JSON.parse(json.d);
            }
        },

        columns: [
            {
                data: null,
                orderable: false,
                searchable: false,
                render: function (data, type, row) {
                    return `
                        <i class="fa fa-edit text-primary edit-btn"
                           title="Edit Process"
                           style="cursor:pointer;font-size:12px;"
                           onclick="processconf_editprocess('${row.ProcessID}')">
                        </i>
                    `;
                }
            },
            { data: "ProcessID", visible: false },
            { data: "projectname", defaultContent: '' },
            { data: "ProcessName", defaultContent: '' },
            { data: "AddedByName", defaultContent: '' },
            { data: "AddedDate1", defaultContent: '' }
        ],
        initComplete: function () {
            jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');
        }
    });
}

function processconf_editprocess(processid) {
    var table = $('#projectconf_processlist').DataTable();
    var data = table.rows().data().toArray();
    var row = data.find(x => x.ProcessID == processid);
    if (row == null)
        return;
    $('#processconf_processid').val(row.ProcessID);
    $('#processconf_project').val(row.ProjectID);
    $('#processconf_processname').val(row.ProcessName);
    $('#processconf_btnsubmit')
        .removeClass('btn-primary')
        .addClass('btn-warning')
        .text('Update');
}

function processconf_clear() {
    $('#processconf_processid').val('0');
    $('#processconf_project').val('');
    $('#processconf_processname').val('');
    $('#processconf_btnsubmit')
        .removeClass('btn-warning')
        .addClass('btn-primary')
        .text('Submit');
    return false;
}

function processconf_submit() {
    var obj = {
        ProcessID: $('#processconf_processid').val(),
        ProjectID: $('#processconf_project').val(),
        ProcessName: $('#processconf_processname').val()
    };
    $.ajax({
        type: "POST",
        url: "ProjectConfiguration.aspx/SaveProcess",
        data: JSON.stringify({ obj: obj }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            Swal.fire({
                icon: 'success',
                title: 'Success',
                text: 'Process saved successfully',
                timer: 2000,
                showConfirmButton: false
            });
            processconf_clear();
            // processconf_getprocesslist();
            $('#projectconf_processlist')
                .DataTable()
                .ajax
                .reload(null, false);
        },
        error: function () {
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'Error while saving process'
            });
        }
    });
    return false;
}

function processconf_bindproject() {
    $.ajax({
        type: "POST",
        url: "ProjectConfiguration.aspx/GetAllProjects",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var data = JSON.parse(response.d);
            $('#processconf_project').empty();
            $('#processconf_project').append(
                '<option value="">Select Project</option>'
            );
            $.each(data, function (i, item) {
                $('#processconf_project').append(
                    $('<option>', {
                        value: item.ProjectID,
                        text: item.ProjectName
                    })
                );
            });
        },

        error: function () {
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'Unable to load project list'
            });
        }
    });
}

/*-------------------  Product Type Configuration -------------------*/

function productconf_bindproject() {
    $.ajax({
        type: "POST",
        url: "ProjectConfiguration.aspx/GetAllProjects",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var data = JSON.parse(response.d);
            $('#productconf_project').empty();
            $('#productconf_project').append(
                '<option value="">Select Project</option>'
            );
            $.each(data, function (i, item) {
                $('#productconf_project').append(
                    $('<option>', {
                        value: item.ProjectID,
                        text: item.ProjectName
                    })
                );
            });
        },

        error: function () {
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'Unable to load project list'
            });
        }
    });
}

function productconf_bindprocess() {
    var project = $("#productconf_project").val();

    $.ajax({
        type: "POST",
        url: "ProjectConfiguration.aspx/GetProcessByProject",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: "{ProjectID:" + project + "}",
        success: function (response) {
            var data = JSON.parse(response.d);
            $('#productconf_process').empty();
            $('#productconf_process').append(
                '<option value="">Select Process</option>'
            );
            $.each(data, function (i, item) {
                $('#productconf_process').append(
                    $('<option>', {
                        value: item.ProcessID,
                        text: item.ProcessName
                    })
                );
            });
        },

        error: function () {
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'Unable to load process list'
            });
        }
    });
    return false;
}

function productconf_bindgrid() {
    if ($.fn.DataTable.isDataTable('#productconf_list')) {
        $('#productconf_list')
            .DataTable()
            .clear()
            .destroy();
    }

    $('#productconf_list').DataTable({
        destroy: true,
        processing: false,
        scrollX: true,
        autoWidth: true,
        ajax: {
            type: "POST",
            url: "ProjectConfiguration.aspx/GetProductTypeList",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            dataSrc: function (json) {
                return JSON.parse(json.d);
            }
        },

        columns: [
            {
                data: null,
                orderable: false,
                searchable: false,
                className: 'dt-center',
                render: function (data, type, row) {
                    return `
                        <i class="fa fa-edit text-primary edit-btn"
                           style="cursor:pointer;font-size:18px;"
                           onclick="productconf_edit('${row.ProductId}')">
                        </i>
                    `;
                }
            },

            {
                data: null,
                render: function (data, type, row, meta) {
                    return meta.row + 1;
                }
            },

            { data: "ProjectName" },
            { data: "ProcessName" },
            { data: "ProductType" },
            { data: "AddedByName" },
            { data: "AddedDate1" }
        ]
    });
}

function productconf_edit(productId) {
    var table = $('#productconf_list').DataTable();
    var data = table.rows().data().toArray();
    var row = data.find(x => x.ProductId == productId);
    if (row == null)
        return;
    $('#productconf_productid').val(row.ProductId);
    $('#productconf_project').val(row.ProjectId);
    productconf_bindprocess();
    setTimeout(function () {
        $('#productconf_process').val(row.ProcessId);

    }, 300);
    $('#productconf_producttype').val(row.ProductType);
    $('#productconf_btnsubmit')
        .removeClass('btn-primary')
        .addClass('btn-warning')
        .text('Update');
}

function productconf_clear() {
    $('#productconf_productid').val(0);
    $('#productconf_project').val('');
    $('#productconf_process').empty();
    $('#productconf_producttype').val('');
    $('#productconf_btnsubmit')
        .removeClass('btn-warning')
        .addClass('btn-primary')
        .text('Add');
}

function productconf_submit() {
    var obj = {
        ProductId: $('#productconf_productid').val(),
        ProjectId: $('#productconf_project').val(),
        ProcessId: $('#productconf_process').val(),
        ProductType: $('#productconf_producttype').val()
    };
    $.ajax({
        type: "POST",
        url: "ProjectConfiguration.aspx/SaveProductType",
        data: JSON.stringify({ obj: obj }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            Swal.fire({
                icon: 'success',
                title: 'Success',
                text: 'Saved successfully',
                timer: 1500,
                showConfirmButton: false
            });

            productconf_clear();

            $('#productconf_list')
                .DataTable()
                .ajax
                .reload(null, false);
        },

        error: function (xhr) {
            console.log(xhr.responseText);
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'Error while saving'
            });
        }
    });
    return false;
}

/*-------------------  Product Type Configuration -------------------*/

function targetconf_bindlist() {
    if ($.fn.DataTable.isDataTable('#targetconf_list')) {
        $('#targetconf_list')
            .DataTable()
            .clear()
            .destroy();
    }

    $('#targetconf_list').DataTable({
        destroy: true,
        processing: false,
        scrollX: true,
        autoWidth: false,
        orderCellsTop: true,
        fixedHeader: true,

        ajax: {
            type: "POST",
            url: "ProjectConfiguration.aspx/GetTargetMatrixSetup",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            dataSrc: function (json) {
                return JSON.parse(json.d);
            }
        },

        columns: [
            {
                data: null,
                render: function (data, type, row, meta) {
                    return meta.row + 1;
                }
            },
            { data: "ProjectName" },
            { data: "ProcessName" },
            { data: "ProductType" },
            {
                data: null, orderable: false, searchable: false,
                className: 'dt-center',
                render: function (data, type, row) {
                    if (row.IsConfigured == 1) {
                        return `
                            <button class="btn btn-sm btn-success editTargets" style="padding:1px 5px!important; font-size:13px;"
                                    data-project="${row.ProjectID}"
                                    data-process="${row.ProcessID}"
                                    data-product="${row.ProductID}"
                                    data-projectname="${row.ProjectName}"
                                    data-processname="${row.ProcessName}"
                                    data-producttype="${row.ProductType}">
                                Edit
                            </button>
                        `;
                    }
                    else {
                        return `
                            <button class="btn btn-sm btn-info editTargets" style="padding:1px 5px!important; font-size:13px;"
                                    data-project="${row.ProjectID}"
                                    data-process="${row.ProcessID}"
                                    data-product="${row.ProductID}"
                                    data-projectname="${row.ProjectName}"
                                    data-processname="${row.ProcessName}"
                                    data-producttype="${row.ProductType}">
                                Setup
                            </button>
                        `;
                    }
                }
            }
        ],
        initComplete: function () {
            var api = this.api();
            api.columns().every(function (index) {
                var column = this;
                if (index == 0 || index == 4)
                    return;
                var title = $('.filters th')
                    .eq(index)
                    .text();
                $('.filters th')
                    .eq(index)
                    .html(
                        `<input type="text"
                            class="form-control form-control-sm"
                            placeholder="Search ${title}" />`
                    );
                $('input', $('.filters th').eq(index))
                    .on('keyup change clear', function () {
                        if (column.search() !== this.value) {
                            column
                                .search(this.value)
                                .draw();
                        }
                    });
            });
        }
    });
    $('#targetconf_list').on('click', '.editTargets', function () {
        var projectId = $(this).data('project');
        var processId = $(this).data('process');
        var productId = $(this).data('product');
        var projectName = $(this).data('projectname');

        var processName = $(this).data('processname');

        var productType = $(this).data('producttype');

        $('#targetsModalTitle').html(

            `<b>Monthly Targets for Project:</b> ${projectName}
         &nbsp;&nbsp; | &nbsp;&nbsp;
         <b>Process:</b> ${processName}
         ${productType != '' && productType != null ? '&nbsp;&nbsp; | &nbsp;&nbsp;<b>Product:</b> ' + productType : ''}`
        );

        loadMonthInputs(projectId, processId, productId);

        $('#targetconf_saveTargets')
            .data('project', projectId)
            .data('process', processId)
            .data('product', productId);

        $('#targetsModal').modal('show');

        return false;
    });

    $(document).on('click', '#targetconf_saveTargets', function () {
        var projectId = $(this).data('project');
        var processId = $(this).data('process');
        var productId = $(this).data('product');
        if (productId == 'undefined' || productId == null)
            productId = 0;

        var months = [];

        //$('.month-input').each(function () {
        //    months.push({
        //        MonthNo: $(this).data('month'),
        //        TargetValue: $(this).val()
        //    });
        //});

        var obj = {
            ProjectID: projectId,
            ProcessID: processId,
            ProductID: productId,
            Maturity: $('#Maturity').val()
        };
        for (var i = 1; i <= 36; i++) {

            obj['Month' + i] = $('#Month' + i).val();
        }
        console.log(obj);

        $.ajax({
            type: "POST",
            url: "ProjectConfiguration.aspx/SaveTargetMatrix",
            //data: JSON.stringify({
            //    projectId: projectId,
            //    processId: processId,
            //    productId: productId,
            //    months: months
            //}),
            data: JSON.stringify({ obj: obj }),

            contentType: "application/json; charset=utf-8",

            dataType: "json",

            success: function () {

                Swal.fire({

                    icon: 'success',

                    title: 'Success',

                    text: 'Target matrix saved successfully',

                    timer: 1500,

                    showConfirmButton: false
                });

                $('#targetsModal').modal('hide');

                $('#targetconf_list')
                    .DataTable()
                    .ajax
                    .reload(null, false);
            },

            error: function () {

                Swal.fire({

                    icon: 'error',

                    title: 'Error',

                    text: 'Error while saving target matrix'
                });
            }
        });
        return false;
    });
    return false;
}

function loadMonthInputs(projectId, processId, productId) {
    var monthCount = 36;
    if (productId == 'undefined' || productId == null)
        productId = 0;

    $.ajax({
        type: "POST",
        url: "ProjectConfiguration.aspx/GetTargetMatrixFoprProject",
        data: JSON.stringify({
            projectId: projectId,
            processId: processId,
            productId: productId
        }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var data = JSON.parse(response.d);
            var row = null;
            if (data.length > 0)
                row = data[0];
            var html = '';
            for (var i = 1; i <= monthCount; i++) {
                var val = '';
                if (row != null &&
                    row['Month' + i] != null) {
                    val = row['Month' + i];
                }
                html += `
                    <div class="col-md-2 mb-2">
                        <label>Month ${i}</label>
                        <input type="number"
                               class="form-control form-control-sm month-input"
                               id="Month${i}"
                               value="${val}" />
                    </div>
                `;
            }
            var maturity = '';
            if (row != null &&
                row.Maturity != null) {
                maturity = row.Maturity;
            }
            html += `
                <div class="col-md-2 mb-2">
                    <label>Maturity</label>
                    <input type="number"
                           class="form-control form-control-sm month-input"
                           id="Maturity"
                           value="${maturity}" />
                </div>
            `;
            $('#monthInputs').html(html);
            $('#targetsModal').modal('show');
        }
    });
}

/*-------------------  Project Rights Configuration -------------------*/
function projectrights_loadUsers() {

    $.ajax({
        type: "POST",
        url: "ProjectConfiguration.aspx/GetUsers",
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        success: function (response) {

            let data = response.d;

            $('#projectrights_ddlUser').empty();

            $('#projectrights_ddlUser').append(`
                <option value="">-- Select Employee --</option>
            `);

            $.each(data, function (i, item) {
                $('#projectrights_ddlUser').append(`
                    <option value="${item.EmployeeID}">
                        ${item.Code} : ${item.EmployeeName}
                    </option>
                `);
            });
        },

        error: function () {
            alert('Error loading users.');
        }
    });
    return false;
}
function projectrights_bindprojectslist() {

    //// Initialize DataTable
    //$('#projectrights_tblProjectRights').DataTable({
    //    paging: false,
    //    info: false,
    //    searching: true,
    //    ordering: true,
    //    responsive: false,

    //    scrollY: '450px',
    //    scrollCollapse: true,
    //    scrollX: true,

    //    fixedHeader: true,

    //    autoWidth: false
    //});

    // Show grid after user selection
    $('#projectrights_btnLoad').click(function () {

        let user = $('#projectrights_ddlUser').val();
        if (user == '') {
            alert('Please select user.');
            return;
        }
        projectrights_loadProjectRights(user);

        return false;
    });

    // Select All
    $('#projectrights_chkAll').change(function () {
        $('.row-check').prop('checked', $(this).prop('checked'));
    });

    $('#projectrights_btnSaveRights').click(function () {

        let selectedProjects = [];

        $('.row-check:checked').each(function () {
            selectedProjects.push($(this).val());
        });

        let empId = $('#projectrights_ddlUser').val();



        $('#projectrights_processingModal').modal({

            backdrop: 'static',

            keyboard: false

        });
        $('#projectrights_processingModal').modal('show');

        // DISABLE BUTTON
        $('#projectrights_btnSaveRights').prop('disabled', true);


        $.ajax({
            type: "POST",
            url: "ProjectConfiguration.aspx/SaveProjectRights",

            data: JSON.stringify({
                EmployeeId: empId,
                ProjectIds: selectedProjects
            }),

            contentType: "application/json; charset=utf-8",
            dataType: "json",

            success: function () {
                $('#projectrights_processingModal').modal('hide');

                // ENABLE BUTTON
                $('#projectrights_btnSaveRights').prop('disabled', false);

                // SUCCESS MESSAGE
                toastr.success('Rights updated successfully.');
                // alert('Rights updated successfully.');

            },

            error: function () {

                // HIDE LOADER
                processingModal.hide();

                // ENABLE BUTTON
                $('#projectrights_btnSaveRights').prop('disabled', false);

                toastr.error('Error while saving rights.');

            }
        });

    });

    return false;
}

function projectrights_loadProjectRights(empId) {

    // DESTROY OLD DATATABLE
    if ($.fn.DataTable.isDataTable('#projectrights_tblProjectRights')) {
        $('#projectrights_tblProjectRights').DataTable().destroy();
    }

    // CLEAR BODY
    $('#projectrights_tblProjectRights tbody').html('');

    $.ajax({
        type: "POST",
        url: "ProjectConfiguration.aspx/GetProjectRights",
        data: JSON.stringify({
            EmployeeId: empId
        }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        success: function (response) {

            let data = response.d;

            let html = '';

            $.each(data, function (i, item) {

                html += `
                    <tr>

                        <td class="text-center">
                            <input type="checkbox"
                                   class="row-check"
                                   value="${item.ProjectId}"
                                   ${item.IsAssigned ? 'checked' : ''} />
                        </td>

                        <td>${i + 1}</td>

                        <td>${item.ProjectName}</td>

                        <td>
                            <span class="badge-domain">
                                ${item.DomainName}
                            </span>
                        </td>

                        <td>
                            ${item.IsAssigned
                        ? '<span class="badge bg-success">Assigned</span>'
                        : '<span class="badge bg-light text-dark border">Not Assigned</span>'
                    }
                        </td>

                    </tr>
                `;
            });

            $('#projectrights_tblProjectRights tbody').html(html);

            // SHOW GRID
            $('#projectrights_rightsSection').slideDown();

            // REINITIALIZE DATATABLE
            $('#projectrights_tblProjectRights').DataTable({
                paging: false,
                info: false,
                searching: true,
                ordering: true,
                responsive: false,

                scrollY: '450px',
                scrollCollapse: true,
                scrollX: true,

                fixedHeader: true,

                autoWidth: false
            });

        },

        error: function () {
            alert('Error loading project rights.');
        }
    });
    return false;
}

/*-------------------  Special Target Configuration -------------------*/
function specialtarget_loadAssignedTargets() {

    // DESTROY EXISTING DATATABLE
    if ($.fn.DataTable.isDataTable(
        '#specialtarget_tblTargets')) {

        $('#specialtarget_tblTargets')
            .DataTable()
            .clear()
            .destroy();
    }

    // CLEAR TABLE
    $('#specialtarget_tblTargets tbody')
        .empty();

    $.ajax({

        type: "POST",

        url: "ProjectConfiguration.aspx/GetAssignedTargets",

        contentType: "application/json; charset=utf-8",

        dataType: "json",

        beforeSend: function () {

            $('#specialtarget_tblTargets tbody')
                .html(`
                    <tr>
                        <td colspan="9"
                            class="text-center p-4">

                            Loading...

                        </td>
                    </tr>
                `);

        },

        success: function (response) {

            let data = JSON.parse(response.d);

            let html = '';

            // BUILD HTML STRING
            $.each(data, function (i, item) {

                html += `

                    <tr>

                        <td>${item.Code}</td>

                        <td>${item.ProjectName}</td>

                        <td>${item.ProcessName}</td>

                        <td>Month ${item.Month}</td>

                        <td>${item.Remark || ''}</td>

                        <td>${item.AddedByCode || ''}</td>

                        <td>${formatJsonDate(item.AddedDate)}</td>

                        <td class="text-center">

                            <button type="button"
                                    class="btn btn-sm btn-primary btnEditTarget"

                                data-id="${item.ID}"
                                data-employeeid="${item.EmployeeID}"
                                data-code="${item.Code}"
                                data-projectid="${item.ProjectID}"
                                data-processid="${item.ProcessID}"
                                data-month="${item.Month}"
                                data-remark="${item.Remark}">

                                <i class="fa fa-edit"></i>

                            </button>

                        </td>

                        <td class="text-center">

                            <button type="button"
                                    class="btn btn-sm btn-danger btnDeleteTarget"

                                data-id="${item.ID}">

                                <i class="fa fa-trash"></i>

                            </button>

                        </td>

                    </tr>

                `;

            });

            // APPEND ONCE
            $('#specialtarget_tblTargets tbody')
                .html(html);

            // INITIALIZE DATATABLE
            $('#specialtarget_tblTargets').DataTable({

                destroy: true,

                deferRender: true,

                processing: true,

                paging: true,

                searching: true,

                ordering: true,

                responsive: true,

                pageLength: 25,

                autoWidth: false,

                scrollX: true

            });

        },

        error: function () {

            toastr.error(
                'Error loading assigned targets.'
            );

        }

    });

}

function specialtarget_resetForm() {

    $('#specialtarget_hdnTID').val('');

    $('#specialtarget_txtRemark').val('');

    $('input[name=selectedMonth]')
        .prop('checked', false);

    $('.compact-month-card')
        .removeClass('selected');

    $('#specialtarget_btnAssignTarget')
        .html('<i class="fa fa-save"></i> Assign Special Target');

}

function specialtarget_loadUsers() {

    $.ajax({
        type: "POST",
        url: "ProjectConfiguration.aspx/GetUsers",
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        success: function (response) {

            let data = response.d;

            $('#specialtarget_ddlEmployee').empty();

            $('#specialtarget_ddlEmployee').append(`
                <option value="">-- Select Employee --</option>
            `);

            $.each(data, function (i, item) {
                $('#specialtarget_ddlEmployee').append(`
                    <option value="${item.EmployeeID}">
                        ${item.Code} : ${item.EmployeeName}
                    </option>
                `);
            });
        },

        error: function () {
            alert('Error loading users.');
        }
    });
    return false;
}
function specialtarget_loadMonthTargets(projectId, processId) {
    $('#specialtarget_monthContainer').html('');

    $.ajax({

        type: "POST",

        url: "ProjectConfiguration.aspx/GetAssignedTargtetByProjectProcess",

        data: JSON.stringify({
            ProjectID: projectId,
            ProcessID: processId
        }),

        contentType: "application/json; charset=utf-8",

        dataType: "json",

        success: function (response) {

            let data = JSON.parse(response.d);
            let item = data[0];

            // LOOP 1 TO 36
            for (let i = 1; i <= 36; i++) {

                let targetValue = item['Month' + i];

                // SKIP NULL OR EMPTY
                if (targetValue == null || targetValue == '') {
                    continue;
                }

                $('#specialtarget_monthContainer').append(`

            <div class="col-lg-2 col-md-2 col-sm-3 col-4">

                <label class="compact-month-card w-100">

                    <input type="radio"
                           name="selectedMonth"
                           class="month-radio"
                           value="${i}" />

                    <div class="month-name">

                        Month ${i}

                    </div>

                    <div class="month-target">

                        ${targetValue}

                    </div>

                </label>

            </div>

        `);

            }

            // MATURITY
            if (item.Maturity != null && item.Maturity != '') {

                $('#specialtarget_monthContainer').append(`
                 <div class="col-lg-2 col-md-2 col-sm-3 col-4">

                <label class="compact-month-card w-100">

                 <input type="radio"
                               name="selectedMonth"
                               class="month-radio"
                               value="Maturity" />


                        <div class="month-name">

                            Maturity

                        </div>

                        <div class="month-target">

                            Target : ${item.Maturity}

                        </div>

                </label>

            </div>



        `);

            }

        },

        error: function () {

            toastr.error('Error loading month targets.');

        }

    });
    $(document).on('change', '.month-radio', function () {

        $('.compact-month-card').removeClass('selected');

        $(this).closest('.compact-month-card')
            .addClass('selected');

    });
}
function specialtarget_loadProcesses(projectId) {

    $.ajax({

        type: "POST",

        url: "ProjectConfiguration.aspx/GetProcessByProject",

        data: JSON.stringify({
            ProjectID: projectId

        }),

        contentType: "application/json; charset=utf-8",

        dataType: "json",

        success: function (response) {

            let data = JSON.parse(response.d);

            $.each(data, function (i, item) {

                $('#specialtarget_ddlProcess').append(`

                    <option value="${item.ProcessID}">

                        ${item.ProcessName}

                    </option>

                `);

            });

        },

        error: function () {

            toastr.error('Error loading process.');

        }

    });

}
function specialtarget_loadProjects(employeeId) {

    $.ajax({

        type: "POST",

        url: "ProjectConfiguration.aspx/GetAllProjectByUser",

        data: JSON.stringify({
            EmployeeID: employeeId
        }),

        contentType: "application/json; charset=utf-8",

        dataType: "json",

        success: function (response) {

            let data = JSON.parse(response.d);

            $.each(data, function (i, item) {

                $('#specialtarget_ddlProject').append(`

                    <option value="${item.ProjectID}">

                        ${item.ProjectName}

                    </option>

                `);

            });

        },

        error: function () {

            toastr.error('Error loading projects.');

        }

    });

}




