

let assetgrouplist;

function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

function BindAssetGroupGrid() {

    $('#load1').show();

    $.ajax({
        url: "AssetGroup.aspx/GetAllAssetGroups",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (response) {

            const dataArray = JSON.parse(response.d || "[]");

            if ($.fn.DataTable.isDataTable('#assetgrouplist')) {
                $('#assetgrouplist').DataTable().destroy();
            }

            assetgrouplist = $('#assetgrouplist').DataTable({
                data: dataArray,

                dom: 'Bftip',
                scrollX: true,
                paging: true,
                autoWidth: false,
                ordering: false,
                processing: true,

                select: {
                    style: 'single'
                },

                columns: [

                    // ACTION COLUMN
                    {
                        data: "GroupId",
                        className: "text-center",

                        render: function (data) {
                            return `
            <button type="button" class="btn btn-sm btn-outline-primary edit-btn me-1" data-id="${data}">
                <i class="uil uil-pen"></i>
            </button>

            <button type="button" class="btn btn-sm btn-success save-btn me-1 d-none" data-id="${data}">
                <i class="uil uil-check"></i>
            </button>

            <button type="button" class="btn btn-sm btn-danger cancel-btn d-none" data-id="${data}">
                <i class="uil uil-times"></i>
            </button>
        `;
                        }
                    },

                    // INDEX COLUMN
                    {
                        data: null,
                        render: function (data, type, row, meta) {
                            return meta.row + 1;
                        }
                    },

                    // GROUP NAME (EDITABLE)
                    {
                        data: "AssetGroupName",
                        className: "groupname",
                        render: function (data) {
                            return blankForNull(data);
                        }
                    },

                    // EMPLOYEE (EDITABLE)
                    {
                        data: "Employee",
                        className: "employee",
                        render: function (data) {
                            return blankForNull(data);
                        }
                    },

                    // ADDED DATE (READ ONLY)
                    {
                        data: "AddedDate",
                        render: function (data) {

                            if (!data) return "";

                            const match = data.match(/\d+/);
                            if (!match) return "";

                            return new Date(parseInt(match[0]))
                                .toLocaleDateString("en-US");
                        }
                    }
                ],

                buttons: [
                    {
                        extend: 'excelHtml5',
                        title: 'Asset Group Names',
                        exportOptions: {
                            columns: [1, 2, 3, 4]
                        }
                    }
                ],

                initComplete: function () {
                    $('#load1').hide();
                }
            });
        },

        error: function (xhr) {
            $('#load1').hide();
            console.error(xhr.responseText);
            alert("Error loading data");
        }
    });
}

function asssetgroup_submit() {
    var assetgroupname = document.getElementById("assetgroup_name").value;

    if (assetgroupname == "") {
        Swal.fire({
            icon: 'warning',
            title: 'Required',
            text: 'Please enter asset group name.'
        });
        return false;
    }

    PageMethods.InsertAssetGroup(
        assetgroupname,

        // Success Callback
        function (response) {
            Swal.fire({
                icon: 'success',
                title: 'Success',
                text: 'Asset Group added successfully'
            }).then(function () {

                BindAssetGroupGrid();

            });
        },

        // Error Callback
        function (error) {
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'Failed to add Asset Group.'
            });

            console.log(error);
        }
    );

    return false;
}

$(document).on('click', '.edit-btn', function () {

    const $row = $(this).closest('tr');
    const table = $('#assetgrouplist').DataTable();
    const rowData = table.row($row).data();

    // prevent multiple edit rows
    if ($row.hasClass('editing')) return;

    $row.addClass('editing');

    // store original data (important)
    $row.data('original', { ...rowData });

    // switch buttons
    $row.find('.edit-btn').addClass('d-none');
    $row.find('.save-btn, .cancel-btn').removeClass('d-none');

    // convert to input
    const groupCell = table.cell($row, 2).node();

    $(groupCell).html(`
        <input type="text"
               class="form-control form-control-sm edit-group"
               value="${rowData.AssetGroupName || ''}">
    `);
});

$(document).on('click', '.cancel-btn', function () {

    const $row = $(this).closest('tr');
    const table = $('#assetgrouplist').DataTable();

    const original = $row.data('original');

    const rowData = table.row($row).data(original);

    table.row($row).data(original).invalidate().draw(false);

    $row.removeClass('editing');

    $row.find('.edit-btn').removeClass('d-none');
    $row.find('.save-btn, .cancel-btn').addClass('d-none');
});

$(document).on('click', '.save-btn', function () {

    const $btn = $(this);
    const $row = $btn.closest('tr');
    const table = $('#assetgrouplist').DataTable();

    const rowData = table.row($row).data();
    const original = $row.data('original');

    const updatedGroup = $row.find('.edit-group').val().trim();
    const groupId = $btn.data('id');

    // ❌ no change check
    if (updatedGroup === (original.AssetGroupName || "").trim()) {

        Swal.fire({
            icon: 'info',
            title: 'No Changes',
            text: 'Nothing to update.'
        });

        return;
    }

    // loader state
    $btn.prop('disabled', true);

    $.ajax({
        url: "AssetGroup.aspx/UpdateAssetGroup",
        type: "POST",
        contentType: "application/json; charset=utf-8",

        data: JSON.stringify({
            AssetGroupID: groupId,
            AssetGroupName: updatedGroup
        }),

        success: function (response) {

            const result = response.d;

            if (result > 0) {

                // // update row data (NO FULL RELOAD)
                // rowData.AssetGroupName = updatedGroup;

                // table.row($row).data(rowData).invalidate().draw(false);

                Swal.fire({
                    icon: 'success',
                    title: 'Updated',
                    text: 'Asset Group updated successfully'
                }).then(function () {
                    resetRow($row);

                    BindAssetGroupGrid();

                });


            } else {

                Swal.fire({
                    icon: 'warning',
                    title: 'Not Updated'
                });
            }
        },

        error: function (xhr) {

            console.log(xhr.responseText);

            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'Update failed!'
            });
        },

        complete: function () {
            $btn.prop('disabled', false);
        }
    });
});

function resetRow($row) {

    const table = $('#assetgrouplist').DataTable();
    const original = $row.data('original');

    table.row($row).data(original).invalidate().draw(false);

    $row.removeClass('editing');

    $row.find('.edit-btn').removeClass('d-none');
    $row.find('.save-btn, .cancel-btn').addClass('d-none');
}
