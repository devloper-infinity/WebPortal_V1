
console.log('JS Loaded');

var global_emp = 0;
var updomain_List = [];
var updomain_selectedEmployees = [];


/*-------------------- Bind Methods --------------------*/

function updomain_bindDomains() {

    const ddl = $('#updomain_domain');
    ddl.empty(); // clear existing

    $.ajax({
        type: "POST",
        url: "CreateProfile.aspx/GetAllDomains",
        data: '{}',
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (res) {

            var dataArray = res.d; // ✅ no JSON.parse

            $('#updomain_domain').append('<option value="">-- Select Domain --</option>');

            $.each(dataArray, function (i, item) {
                $('#updomain_domain').append(
                    `<option value="${item.DomainID}">${item.DomainName}</option>`
                );
            });
        },

        error: function (err) {
            console.error(err);
            alert("Error loading domains");
        }
    });
}

function updomain_bindSubDomains() {

    const ddl = $('#updomain_subdomain');
    ddl.empty(); // clear existing

    $.ajax({
        type: "POST",
        url: "CreateProfile.aspx/GetSubdomains",
        data: '{}',
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (response) {

            const data = response.d;

            // Default option
            ddl.append('<option value="">-- Select Sub Domain --</option>');

            $.each(data, function (i, item) {

                // adjust field names based on your API
                ddl.append(`<option value="${item.SubdomainID}">${item.SubdomainName}</option>`
                );
            });
        },

        error: function (err) {
            console.error(err);
            alert("Error loading sub domains");
        }
    });
}

function popUpdomain_bindDomains() {

    const ddl = $('#popUp_domain');
    ddl.empty(); // clear existing

    $.ajax({
        type: "POST",
        url: "CreateProfile.aspx/GetAllDomains",
        data: '{}',
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (res) {

            var dataArray = res.d; // ✅ no JSON.parse

            $('#popUp_domain').append('<option value="">-- Select Domain --</option>');

            $.each(dataArray, function (i, item) {
                $('#popUp_domain').append(
                    `<option value="${item.DomainID}">${item.DomainName}</option>`
                );
            });
        },

        error: function (err) {
            console.error(err);
            alert("Error loading domains");
        }
    });
}

function popUpdomain_bindSubDomains() {

    const ddl = $('#popUp_subdomain');
    ddl.empty(); // clear existing

    $.ajax({
        type: "POST",
        url: "CreateProfile.aspx/GetSubdomains",
        data: '{}',
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (response) {

            const data = response.d;

            // Default option
            ddl.append('<option value="">-- Select Sub Domain --</option>');

            $.each(data, function (i, item) {

                // adjust field names based on your API
                ddl.append(`<option value="${item.SubdomainID}">${item.SubdomainName}</option>`
                );
            });
        },

        error: function (err) {
            console.error(err);
            alert("Error loading sub domains");
        }
    });
}

function core_updomain_bindgrid() {

    $('#load1').show();
    var table = $('#table_updomain').DataTable({
        processing: false,
        serverSide: false,
        orderable: false,
        paging: false,

        dom: 'ifrti',
        ajax: {
            url: "SegmentUpdates.aspx/GetAllEmployees",
            type: "POST",
            contentType: "application/json; charset=utf-8",
            dataSrc: function (response) {

                // Handle ASP.NET WebMethod response
                var data = response.d;

                if (typeof data === "string") {
                    data = JSON.parse(data);
                }

                return data;
            }
        },
        columns: [
            {
                data: null,
                render: function (data, type, row, meta) {
                    return meta.row + 1;
                }
            },
            // ✅ Checkbox column
            {
                data: null,
                orderable: false,
                render: function (data, type, row) {
                    return `<input type="checkbox" class="row_checkbox" data-id="${row.EmployeeID}">`;
                }
            },

            {
                data: null,
                orderable: false,
                render: function (data, type, row) {

                    const empId = row.EmployeeID;
                    const code = (row.Code || '').replace(/'/g, "\\'");
                    const fullName = (row.FullName || '').replace(/'/g, "\\'");

                    return `<i class="uil fs-0 me-2 uil-pen" style="color:dodgerblue;cursor:pointer;" onclick="return updomain_Edit('${empId}','${code}','${fullName}')"></i>`;
                }
            },

            { data: "Code" },
            { data: "FullName" },
            { data: "JoiningDate" },
            { data: "BranchName" },
            { data: "DepartmentName" },
            { data: "DesignationName" },
            { data: "DomainName" },
            { data: "Subdomain" },
            { data: "Segment" },
            { data: "ReportingManager" },
            { data: "JobType" },
            { data: "CurrentLogin" },
            { data: "CurrentStatus" }
        ],

        initComplete: function () {

            $('#load1').hide();

            var table = this.api();

            // Columns: Department, Designation, Domain, JobType, Status
            var dropdownColumns = [6, 7, 8, 12, 14];

            dropdownColumns.forEach(function (colIndex) {

                var column = table.column(colIndex);
                var select = $('#filter_row th').eq(colIndex).find('select');

                var uniqueValues = [];

                column.data().each(function (d) {
                    if (d && uniqueValues.indexOf(d) === -1) {
                        uniqueValues.push(d);
                    }
                });

                uniqueValues.sort();

                uniqueValues.forEach(function (val) {
                    select.append(`<option value="${val}">${val}</option>`);
                });
            });
        }
    });

    // ✅ Select All checkbox
    $('#updomain_selectAll').on('click', function () {
        var rows = table.rows({ search: 'applied' }).nodes();

        $('input.row_checkbox', rows).prop('checked', this.checked);
    });


    $('#table_updomain tbody').on('change', '.row_checkbox', function () {

        var empID = $(this).data('id');

        if ($(this).is(':checked')) {
            console.log("Checked EmployeeID:", empID);
        } else {
            console.log("Unchecked EmployeeID:", empID);
        }
    });

    // ✅ If any row checkbox unchecked → uncheck Select All
    $('#table_updomain tbody').on('change', '.row_checkbox', function () {

        if (!this.checked) {
            $('#updomain_selectAll').prop('checked', false);
        }

        // If all checked → check Select All
        if ($('.row_checkbox:checked').length === $('.row_checkbox').length) {
            $('#updomain_selectAll').prop('checked', true);
        }
    });

    $(document).on('keyup change', '#table_updomain .column-filter', function () {
        var index = $(this).closest('th').index();
        var value = this.value;

        if ($(this).is('select')) {

            table.column(index)
                .search(value ? '^' + value + '$' : '', true, false)
                .draw();

        } else {

            table.column(index)
                .search(value)
                .draw();
        }
    });

    $('#clear_filters').on('click', function () {

        $('.column-filter').val('');

        var table = $('#table_updomain').DataTable();
        table.columns().search('').draw();
    });
}

function updomain_bindgrid() {

    $('#load1').show();

    // Destroy if already initialized
    if ($.fn.DataTable.isDataTable('#table_updomain')) {
        $('#table_updomain').DataTable().destroy();
    }

    var table = $('#table_updomain').DataTable({

        processing: false,
        serverSide: false,

        paging: false,          // ✅ No paging
        ordering: false,
        searching: true,
        orderCellsTop: true,

        scrollX: true,          // ✅ REQUIRED
        scrollY: "500px",       // optional
        scrollCollapse: true,

        fixedHeader: true,      // ✅ Fixed header

        fixedColumns: {
            leftColumns: 5      // ✅ Fix first 5 columns
        },

        dom: 'ifrti',

        ajax: {
            url: "SegmentUpdates.aspx/GetAllEmployees",
            type: "POST",
            contentType: "application/json; charset=utf-8",

            dataSrc: function (response) {

                var data = response.d;

                if (typeof data === "string") {
                    data = JSON.parse(data);
                }

                return data;
            }
        },

        columns: [

            {
                data: null,
                render: function (data, type, row, meta) {
                    return meta.row + 1;
                }
            },

            {
                data: null,
                orderable: false,
                render: function (data, type, row) {
                    return `<input type="checkbox" class="row_checkbox" data-id="${row.EmployeeID}">`;
                }
            },

            {
                data: null,
                orderable: false,
                render: function (data, type, row) {

                    const empId = row.EmployeeID;
                    const code = (row.Code || '').replace(/'/g, "\\'");
                    const fullName = (row.FullName || '').replace(/'/g, "\\'");

                    return `
                        <i class="uil fs-0 me-2 uil-pen"
                           style="color:dodgerblue;cursor:pointer;"
                           onclick="return updomain_Edit('${empId}','${code}','${fullName}')">
                        </i>`;
                }
            },

            { data: "Code" },
            { data: "FullName", className: "text-nowrap" },
            { data: "JoiningDate" },
            { data: "BranchName" },
            { data: "DepartmentName", className: "text-nowrap" },
            { data: "DesignationName", className: "text-nowrap" },
            { data: "DomainName", className: "text-nowrap" },
            { data: "Subdomain", className: "text-nowrap" },
            { data: "Segment", className: "text-nowrap" },
            { data: "ReportingManager", className: "text-nowrap" },
            { data: "JobType", className: "text-nowrap" },
            { data: "CurrentLogin", className: "text-nowrap" },
            { data: "CurrentStatus", className: "text-nowrap" }
        ],

        initComplete: function () {

            $('#load1').hide();

            // var table = this.api();

            // var dropdownColumns = [6, 7, 8, 12, 14];

            // dropdownColumns.forEach(function (colIndex) {

            //     var column = table.column(colIndex);
            //     var select = $('#filter_row th').eq(colIndex).find('select');

            //     var uniqueValues = [];

            //     column.data().each(function (d) {
            //         if (d && uniqueValues.indexOf(d) === -1) {
            //             uniqueValues.push(d);
            //         }
            //     });

            //     uniqueValues.sort();

            //     uniqueValues.forEach(function (val) {
            //         select.append(`<option value="${val}">${val}</option>`);
            //     });
            // });
        }
    });

    // Select All
    $('#updomain_selectAll').on('click', function () {

        var rows = table.rows({ search: 'applied' }).nodes();

        $('input.row_checkbox', rows).prop('checked', this.checked);
    });

    $('#table_updomain tbody').on('change', '.row_checkbox', function () {

        if (!this.checked) {
            $('#updomain_selectAll').prop('checked', false);
        }

        if ($('.row_checkbox:checked').length === $('.row_checkbox').length) {
            $('#updomain_selectAll').prop('checked', true);
        }
    });

    // $('#table_updomain thead').on('keyup change', '.column-filter', function () {

    //     var index = $(this).closest('th').index();
    //     var value = this.value;

    //     if ($(this).is('select')) {
    //         table.column(index).search(value ? '^' + value + '$' : '', true, false).draw();
    //     } else {
    //         table.column(index).search(value).draw();
    //     }
    // });

    // $('#clear_filters').on('click', function () {

    //     $('.column-filter').val('');
    //     table.columns().search('').draw();
    // });
}



/*-------------------- submit method --------------------*/

function updomain_submit() {

    var domain = $('#updomain_domain').val();
    var subdomain = $('#updomain_subdomain option:selected').text();
    var process = $('#updomain_process').val();

    if (domain === "") {
        alert("Please select Domain.");
        return false;
    }

    if (subdomain === "") {
        alert("Please select Sub-Domain.");
        return false;
    }


    //var table = $('#table_updomain').DataTable();
    var AllocatedEmpIDs = [];

    $('#table_updomain tbody tr').each(function () {
        var checkbox = $(this).find('.row_checkbox');

        $('.row_checkbox:checked').each(function () {
            AllocatedEmpIDs.push($(this).data('id'));
        });
    });

    if (AllocatedEmpIDs.length > 0) {
        $('#updomain_waitingpanel').modal('show');

        ChangeDomain(AllocatedEmpIDs, domain, subdomain, process);

        $('#updomain_waitingpanel').modal('hide');
    }
    else {
        Swal.fire({
            icon: 'warning',
            title: 'User Missing',
            text: 'Please select at least one user.',
            zIndex: 999999
        });

        $('#updomain_waitingpanel').modal('hide');
    }

    return false;
}

function updomain_Edit(empId, code, fullname) {

    global_emp = empId;

    $('#popUp_process').val('');
    popUpdomain_bindDomains();
    popUpdomain_bindSubDomains();

    $('#updomain_Header').text("Update Data : " + code + " - " + fullname);
    $('#updomain_popUp').modal('show');
}

function popUp_submit() {

    var domain = $('#popUp_domain').val();
    var subdomain = $('#popUp_subdomain option:selected').text();
    var process = $('#popUp_process').val();

    if (domain === "") {
        alert("Please select Domain.");
        return false;
    }

    if (subdomain === "") {
        alert("Please select Sub-Domain.");
        return false;
    }

    ChangeDomain(global_emp, domain, subdomain, process);

    return false;
}

function ChangeDomain(EmployeeIDs, Domain, SubDomain, process) {

    $.ajax({
        url: "UpdateDomain.aspx/ChangeDomain",
        type: "POST",
        data: "{EmployeeIDs:'" + EmployeeIDs + "',DomainID:" + Domain + ",SubDomain:'" + SubDomain + "',Process:'" + process + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        success: function (response) {

            if (response.d > 0) {
                Swal.fire({
                    icon: 'success',
                    title: 'Success',
                    text: 'Data updated successfully.',
                    zIndex: 999999
                }).then(function () {
                    global_emp = 0;
                    location.reload();
                });
            }
            else {

                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'Oops! Error occured while updating data. Please contact administrator!',
                    zIndex: 999999
                });
            }
        },

        error: function (err) {

            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: err.responseText,
                zIndex: 999999
            });
        }
    });

    return false;
}

