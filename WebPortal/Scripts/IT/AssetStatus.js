var global_StatusID = 0;


var prev_assetstatus = '';

function blankForNull(value) {
    return value == null ? "" : value;
}

function BindAssetStatus_Grid() {

    $('#load1').show();

    $.ajax({
        url: 'AssetStatus.aspx/GetAllAssetStatus',
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (response) {

            const dataArray = JSON.parse(response.d || "[]");

            if ($.fn.DataTable.isDataTable('#table_assetstatus')) {
                $('#table_assetstatus').DataTable().destroy();
            }

            table = $('#table_assetstatus').DataTable({
                data: dataArray,
                dom: 'Bftip',
                scrollX: true,
                paging: true,
                autoWidth: false,
                processing: true,
                ordering: false,

                select: {
                    style: 'single'
                },

                columns: [
                    {
                        data: "StatusId",
                        className: "text-center",
                        render: function (data) {
                            return `
                                <button type="button"
                                    class="btn btn-sm btn-outline-primary edit-btn me-1"
                                    data-id="${data}">
                                    <i class="uil uil-pen"></i>
                                </button>

                                <button type="button"
                                    class="btn btn-sm btn-success save-btn me-1 d-none"
                                    data-id="${data}">
                                    <i class="uil uil-check"></i>
                                </button>

                                <button type="button"
                                    class="btn btn-sm btn-danger cancel-btn d-none"
                                    data-id="${data}">
                                    <i class="uil uil-times"></i>
                                </button>
                            `;
                        }
                    },
                    {
                        data: null,
                        className: 'text-center',
                        render: function (data, type, row, meta) {
                            return meta.row + 1;
                        }
                    },
                    {
                        data: 'AssetStatus',
                        className: 'assetstatus',
                        render: function (data) {
                            return blankForNull(data);
                        }
                    },
                    {
                        data: 'Employee',
                        render: function (data) {
                            return blankForNull(data);
                        }
                    },
                    {
                        data: 'AddedDate',
                        render: function (data) {
                            return blankForNull(data);
                        }
                    },
                    {
                        data: 'StatusId',
                        visible: false
                    }
                ],

                buttons: [
                    {
                        extend: 'excelHtml5',
                        title: "Assets Status",
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
            alert('Error loading Asset Status');
        }
    });

    return false;
}

function assetstatus_submit() {

    var asset_status = document.getElementById("assetstatus_status").value.trim();

    if (asset_status === "") {
        Swal.fire({
            icon: "warning",
            title: "Validation",
            text: "Please enter asset status."
        });

        document.getElementById("assetstatus_status").focus();
        return false;
    }

    PageMethods.InsertAssetStatus(asset_status, function (result) {

        if (result > 0) {
            Swal.fire({ icon: "success", title: "Success", text: "Status added successfully!" });

            document.getElementById("assetstatus_status").value = "";
            $('#assetstatus_btnsubmit').text('Submit');
            BindAssetStatus_Grid();

        } else {
            Swal.fire({ icon: "error", title: "Error", text: "Oops! Error occurred while adding status. Please contact administrator!" });
        }

    }, function (error) {
        Swal.fire({ icon: "error", title: "Error", text: error.responseText });
    });



    return false;
}

$(document).on('click', '#table_assetstatus .edit-btn', function () {

    const $row = $(this).closest('tr');

    const assetStatus = $row.find('td.assetstatus').text().trim();
    prev_assetstatus = assetStatus;

    $row.data('original-assetstatus', assetStatus);

    $row.find('td.assetstatus').html(`
        <input type="text" 
               class="form-control form-control-sm edit-assetstatus" 
               value="${assetStatus}">
    `);

    $row.find('.edit-btn').addClass('d-none');
    $row.find('.save-btn, .cancel-btn').removeClass('d-none');
});

$(document).on('click', '#table_assetstatus .cancel-btn', function () {

    const $row = $(this).closest('tr');

    const originalAssetStatus = $row.data('original-assetstatus');

    $row.find('td.assetstatus').html(originalAssetStatus);

    $row.find('.edit-btn').removeClass('d-none');
    $row.find('.save-btn, .cancel-btn').addClass('d-none');
});

$(document).on('click', '#table_assetstatus .save-btn', function () {

    const $btn = $(this);
    const $row = $btn.closest('tr');

    const statusId = $btn.data('id');
    const assetStatus = $row.find('.edit-assetstatus').val().trim();

    if (assetStatus === "") {
        Swal.fire({ icon: 'warning', title: 'Required', text: 'Please enter Asset Status.' });
        return;
    }

    if (assetStatus === prev_assetstatus) {
        Swal.fire({ icon: 'info', title: 'No Changes' });
        return;
    }

    $.ajax({
        url: "AssetStatus.aspx/UpdateAssetStatus",
        type: "POST",
        data: JSON.stringify({ StatusID: statusId, AssetStatus: assetStatus }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        success: function (result) {
            if (result > 0) {
                Swal.fire({
                    icon: 'success', title: 'Updated', text: 'Asset Status updated successfully'
                }).then(function () {
                    prev_assetstatus = '';
                    BindAssetStatus_Grid();
                });

            } else {
                Swal.fire({ icon: "error", title: "Error", text: "Oops! Error occurred while adding status. Please contact administrator!" });
            }
        },
        error: function (xhr) {
            console.error(xhr.responseText);
            Swal.fire({ icon: 'error', title: 'Update failed' });
        }
    });
});

