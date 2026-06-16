// =============================================
// GLOBAL DATATABLE VARIABLE
// =============================================

let assettypelist_new;
var prv_assettype;
var prv_abbr;


function blankForNull(value) {
    return value == null ? '' : value;
}

function BindAssetGroup_Type() {

    $("#assettype_group").empty();
    $("#assettype_group").append(`<option value="">Select</option>`);

    $.ajax({
        url: "AssetGroup.aspx/GetAllAssetGroups",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (response) {
          
            var dataArray = JSON.parse(response.d);

            $.each(dataArray, function (data, value) {

                $("#assettype_group").append($("<option></option>").val(value.GroupId).html(value.AssetGroupName));
            });
        },

        error: function (xhr) {
            console.log("Error:", xhr.responseText);
        }
    });
}


// BIND GRID
function BindAssetTypeGrid() {

    $('#load1').show();

    $.ajax({
        url: "AssetType.aspx/GetAllAssetTypes",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (response) {

            const dataArray = JSON.parse(response.d || "[]");

            // Destroy existing DataTable
            if ($.fn.DataTable.isDataTable('#assettypelist')) {
                $('#assettypelist').DataTable().destroy();
            }

            assettypelist = $('#assettypelist').DataTable({

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
                        data: "AssetsTypeId",
                        className: "text-center",
                        width: "120px",
                        render: function (data) {
                            return `
        <button type="button" class="btn btn-sm btn-outline-primary edit-btn me-1" data-id="${data}"><i class="uil uil-pen"></i></button>
        <button type="button" class="btn btn-sm btn-success save-btn me-1 d-none" data-id="${data}"><i class="uil uil-check"></i></button>
        <button type="button" class="btn btn-sm btn-danger cancel-btn d-none" data-id="${data}"><i class="uil uil-times"></i></button>`;
                        }
                    },

                    // INDEX COLUMN
                    {
                        data: null,
                        render: function (data, type, row, meta) {
                            return meta.row + 1;
                        }
                    },

                    // ASSET GROUP
                    {
                        data: "AssetGroup",
                        className: "assetgroup"
                    },
                    {
                        data: "AssetsTypeName",
                        className: "assetstypename"
                    },
                    {
                        data: "Abbreviation",
                        className: "abbreviation"
                    },

                    // EMPLOYEE
                    {
                        data: "Employee",
                        className: "employee",
                        render: function (data) {
                            return blankForNull(data);
                        }
                    },

                    // ADDED DATE
                    {
                        data: "AddedDate",
                    }
                ],

                buttons: [
                    {
                        extend: 'excelHtml5',
                        title: 'Asset Type',

                        exportOptions: {
                            columns: [1, 2, 3, 4, 5, 6]
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


function asssettype_submit() {

    var ddlassetgroup = document.getElementById("assettype_group");
    var assetgroup = ddlassetgroup.options[ddlassetgroup.selectedIndex].value;

    var assettypename = document.getElementById("assettype_name").value.trim();
    var assettypeabbr = document.getElementById("assettype_abbr").value.trim();

    // Validation with SweetAlert
    if (assettypename == "") {
        Swal.fire("Validation Error", "Please enter asset type name.", "warning");
        return false;
    }

    if (assetgroup == "") {
        Swal.fire("Validation Error", "Please select asset group.", "warning");
        return false;
    }

    if (assettypeabbr == "") {
        Swal.fire("Validation Error", "Please enter asset type abbreviation.", "warning");
        return false;
    }

    // Show loading
    Swal.fire({
        title: "Saving...", text: "Please wait", allowOutsideClick: false, didOpen: () => {
            Swal.showLoading();
        }
    });

    // Call PageMethods (no success/error callbacks)
    PageMethods.InsertAssetType(assetgroup, assettypename, assettypeabbr,
        function (result) {

            Swal.fire({ title: "Success", text: "Asset type saved successfully!", icon: "success" });

        },
        function (error) {

            Swal.fire({ title: "Error", text: error.get_message ? error.get_message() : "Something went wrong", icon: "error" });

        }
    );

    return false;
}


// EDIT BUTTON

$(document).on('click', '#assettypelist .edit-btn', function () {

    const table = $('#assettypelist').DataTable();
    const row = $(this).closest('tr');
    const rowData = table.row(row).data();

    row.data('original', rowData);

    // store old values globally
    prv_assettype = row.find('td.assetstypename').text().trim();
    prv_abbr = row.find('td.abbreviation').text().trim();

    row.find('td.assetstypename').html(`<input type="text" class="form-control form-control-sm edit-assetstypename" value="${prv_assettype}">`);

    row.find('td.abbreviation').html(`<input type="text" class="form-control form-control-sm edit-abbreviation" value="${prv_abbr}">`);

    row.find('.edit-btn').addClass('d-none');
    row.find('.save-btn').removeClass('d-none');
    row.find('.cancel-btn').removeClass('d-none');
});


// CANCEL BUTTON
$(document).on('click', '#assettypelist .cancel-btn', function () {

    const $row = $(this).closest('tr');
    const table = $('#assettypelist').DataTable();

    const original = $row.data('original');

    if (!original) return; // safety check

    // restore original row data
    table.row($row).data(original).draw(false);

    $row.removeClass('editing');

    $row.find('.edit-btn').removeClass('d-none');
    $row.find('.save-btn, .cancel-btn').addClass('d-none');
});


// SAVE BUTTON
$(document).on('click', '#assettypelist .save-btn', function () {

    const $btn = $(this);
    const $row = $btn.closest('tr');

    const table = $('#assettypelist').DataTable();

    const rowData = table.row($row).data();
    const assetTypeId = $btn.data('id');

    const assetstypename = $row.find('.edit-assetstypename').val().trim();
    const abbreviation = $row.find('.edit-abbreviation').val().trim();

    // validation
    if (!assetstypename) {
        Swal.fire({ icon: 'warning', title: 'Enter Asset Type Name' });
        return;
    }

    if (!abbreviation) {
        Swal.fire({ icon: 'warning', title: 'Enter Abbreviation' });
        return;
    }

    // no change check
    if (assetstypename === prv_assettype && abbreviation === prv_abbr) {

        Swal.fire({ icon: 'info', title: 'No Changes' });
        return;
    }


    $('#load1').show();

    $.ajax({
        url: "AssetType.aspx/UpdateAssetType",
        type: "POST",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({ AssetsTypeId: assetTypeId, AssetsTypeName: assetstypename, Abbreviation: abbreviation }),

        success: function () {

            $('#load1').hide();

            Swal.fire({ icon: 'success', title: 'Data updated successfully' }).then(() => {

                BindAssetTypeGrid();
            });
        },

        error: function () {

            $('#load1').hide();

            Swal.fire({ icon: 'error', title: 'Update failed' });
        }
    });
});