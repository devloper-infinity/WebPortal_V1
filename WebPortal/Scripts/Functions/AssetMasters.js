
var brandlist;
var prev_brand;
var brand_id;

var vendorlist;
var vendor_html;
var vendor_id = 0;
var vendor_url;

var allassetslist;
var assetlist_html;

/*-------------- Brand --------------*/

function BindBrandGrid() {

    $('#load1').show();

    $.ajax({
        url: "Brand.aspx/GetAllBrand",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (response) {

            const dataArray = JSON.parse(response.d || "[]");

            if ($.fn.DataTable.isDataTable('#brandlist')) {
                $('#brandlist').DataTable().destroy();
            }

            brandlist = $('#brandlist').DataTable({

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
                        data: "BrandID",
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

                    // INDEX
                    {
                        data: null,
                        render: function (data, type, row, meta) {
                            return meta.row + 1;
                        }
                    },

                    // BRAND NAME
                    {
                        data: "Brand",
                        className: "brandname",
                        render: function (data) {
                            return blankForNull(data);
                        }
                    },

                    // ADDED BY
                    {
                        data: "AddedByName",
                        className: "addedby",
                        render: function (data) {
                            return blankForNull(data);
                        }
                    },

                    // ADDED DATE
                    {
                        data: "AddedDate",
                        render: function (data) {
                            return blankForNull(data);
                        }
                    },
                ],

                buttons: [
                    {
                        extend: 'excelHtml5',
                        title: 'Brand List',
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
            alert("Error loading brands");
        }
    });
}

function brand_submit() {

    var brandname = document.getElementById("brand_name").value;

    if (brandname == "") {
        Swal.fire({ icon: 'warning', title: 'Required', text: 'Please enter Brand.' });
        return false;
    }

    PageMethods.InsertBrand(brandname,

        // Success Callback
        function (response) {
            Swal.fire({ icon: 'success', title: 'Success', text: 'Data added successfully' }).then(function () {

                document.getElementById("brand_name").value = '';
                BindBrandGrid();

            });
        },

        // Error Callback
        function (error) {
            Swal.fire({ icon: 'error', title: 'Error', text: 'Failed to add Brand.' });

            console.log(error);
        }
    );

    return false;
}

// Edit
$(document).on('click', '#brandlist .edit-btn', function () {

    const $row = $(this).closest('tr');

    const brand = $row.find('td.brandname').text().trim();
    prev_brand = brand;

    // STORE ORIGINAL VALUE
    $row.data('original-brand', brand);

    // CONVERT TO INPUT
    $row.find('td.brandname').html(`<input type="text" class="form-control form-control-sm edit-brand" value="${brand}">`);

    // TOGGLE BUTTONS
    $row.find('.edit-btn').addClass('d-none');
    $row.find('.save-btn, .cancel-btn').removeClass('d-none');
});

// Cancel
$(document).on('click', '#brandlist .cancel-btn', function () {

    const $row = $(this).closest('tr');

    // GET ORIGINAL VALUE
    const originalBrand = $row.data('original-brand');

    // RESTORE TEXT
    $row.find('td.brandname').html(originalBrand);

    // TOGGLE BUTTONS
    $row.find('.edit-btn').removeClass('d-none');
    $row.find('.save-btn, .cancel-btn').addClass('d-none');
});

// Save
$(document).on('click', '#brandlist .save-btn', function () {

    const $btn = $(this);
    const $row = $btn.closest('tr');

    const brandId = $btn.data('id');

    const original = $row.data('original');

    const brand = $row.find('.edit-brand').val().trim();

    if (brand === "") {
        alert("Please enter Brand Name");
        return;
    }

    // no change check
    if (brand === prev_brand) {
        Swal.fire({ icon: 'info', title: 'No Changes' });
        return;
    }

    $.ajax({
        url: "Brand.aspx/UpdateBrand",
        type: "POST",
        data: JSON.stringify({ BrandID: brandId, BrandName: brand }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        success: function (result) {
            if (result > 0) {

                Swal.fire({
                    icon: 'success', title: 'Updated', text: 'Brand updated successfully'
                }).then(function () {
                    prev_brand = '';
                    BindBrandGrid();

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




/*-------------- Vendor --------------*/

function BindVendorMaster() {

    $('#load1').show();

    $.ajax({
        url: "VendorMaster.aspx/GetAllVendors",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (response) {

            let dataArray = JSON.parse(response.d || "[]");

            // Destroy Existing Table
            if ($.fn.DataTable.isDataTable('#vendorlist')) {
                $('#vendorlist').DataTable().destroy();
            }

            // Initialize DataTable
            vendorlist = $('#vendorlist').DataTable({

                data: dataArray,

                destroy: true,
                scrollX: true,
                paging: true,
                autoWidth: false,
                ordering: false,
                processing: true,
                select: {
                    style: 'single'
                },

                dom: 'Bftip',

                columns: [

                    {
                        data: null,
                        render: function (data, type, row, meta) {

                            return `
                                <a class="dropdown-item"
                                   href="#!"
                                   onclick="assetvendor_edit(${row.vendorId}, ${meta.row});">

                                    <span style="color:forestgreen;">
                                        <i class="uil fs-0 me-2 uil-pen"></i>
                                    </span>

                                </a>
                            `;
                        }
                    },

                    { data: 'SrNo' },
                    { data: 'VendorName', defaultContent: '' },
                    { data: 'Description', defaultContent: '' },
                    { data: 'Contact_Person', defaultContent: '' },
                    { data: 'Address', defaultContent: '', width: '350px' },
                    { data: 'EmailId', defaultContent: '' },
                    { data: 'Phone', defaultContent: '' },
                    { data: 'Fax', defaultContent: '' },
                    { data: 'Web_url', defaultContent: '' },
                    { data: 'AccountHolderName', defaultContent: '' },
                    { data: 'BankName', defaultContent: '' },
                    { data: 'BranchNameAddr', defaultContent: '' },
                    { data: 'AccountType', defaultContent: '' },
                    { data: 'AccountNumber', defaultContent: '' },
                    { data: 'MICRCode', defaultContent: '' },
                    { data: 'IFSCCode', defaultContent: '' },
                    { data: 'GSTNo' },
                    { data: 'PANNo' },
                    { data: 'AddedByName', defaultContent: '' },
                    { data: 'AddedDate', defaultContent: '' }

                ],

                buttons: [
                    {
                        extend: 'excelHtml5',
                        title: 'Vendor Master List',
                        autoFilter: true
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

            alert('Error loading vendor data.');
        }
    });

    return false;
}

function showToast(message) {
    Toastify({
        text: message,
        duration: 3000,
        gravity: "top",
        position: "right",
        backgroundColor: "#dc3545",
        stopOnFocus: true
    }).showToast();
}

function vendor_submit() {

    // Get values
    let vendor_name = $("#vendor_name").val().trim();
    let vendor_gstno = $("#vendor_gstno").val().trim();
    let vendor_contactperson = $("#vendor_contactperson").val().trim();
    let vendor_phonenumber = $("#vendor_phonenumber").val().trim();
    let vendor_email = $("#vendor_email").val().trim();
    let vendor_fax = $("#vendor_fax").val().trim();
    let vendor_weburl = $("#vendor_weburl").val().trim();
    let vendor_accountholder = $("#vendor_accountholder").val().trim();
    let vendor_bank = $("#vendor_bank").val().trim();
    let vendor_branchaddress = $("#vendor_branchaddress").val().trim();
    let vendor_accounttype = $("#vendor_accounttype").val().trim();
    let vendor_accountno = $("#vendor_accountno").val().trim();
    let vendor_micrcode = $("#vendor_micrcode").val().trim();
    let vendor_ifsccode = $("#vendor_ifsccode").val().trim();
    let vendor_pan = $("#vendor_pan").val().trim();
    let vendor_description = $("#vendor_description").val().trim();
    let vendor_address = $("#vendor_address").val().trim();

    // VALIDATION

    if (vendor_name === "") {
        Swal.fire("Validation Error", "Vendor Name is required", "warning");
        return false;
    }

    if (vendor_gstno === "") {
        Swal.fire("Validation Error", "GST Number is required", "warning");
        return false;
    }

    if (vendor_contactperson === "") {
        Swal.fire("Validation Error", "Contact Person is required", "warning");
        return false;
    }

    if (vendor_phonenumber === "") {
        Swal.fire("Validation Error", "Phone Number is required", "warning");
        return false;
    }

    if (vendor_email === "") {
        Swal.fire("Validation Error", "Email is required", "warning");
        return false;
    }

    // if (vendor_fax === "") {
    //     Swal.fire("Validation Error", "Fax is required", "warning");
    //     return false;
    // }

    if (vendor_weburl === "") {
        Swal.fire("Validation Error", "Website URL is required", "warning");
        return false;
    }

    if (vendor_accountholder === "") {
        Swal.fire("Validation Error", "Account Holder Name is required", "warning");
        return false;
    }

    if (vendor_bank === "") {
        Swal.fire("Validation Error", "Bank Name is required", "warning");
        return false;
    }

    if (vendor_branchaddress === "") {
        Swal.fire("Validation Error", "Branch Address is required", "warning");
        return false;
    }

    if (vendor_accounttype === "") {
        Swal.fire("Validation Error", "Account Type is required", "warning");
        return false;
    }

    if (vendor_accountno === "") {
        Swal.fire("Validation Error", "Account Number is required", "warning");
        return false;
    }

    if (vendor_micrcode === "") {
        Swal.fire("Validation Error", "MICR Code is required", "warning");
        return false;
    }

    if (vendor_ifsccode === "") {
        Swal.fire("Validation Error", "IFSC Code is required", "warning");
        return false;
    }

    if (vendor_pan === "") {
        Swal.fire("Validation Error", "PAN Number is required", "warning");
        return false;
    }

    if (vendor_description === "") {
        Swal.fire("Validation Error", "Description is required", "warning");
        return false;
    }

    if (vendor_address === "") {
        Swal.fire("Validation Error", "Address is required", "warning");
        return false;
    }

    // Email Validation
    let emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (vendor_email !== "" && !emailPattern.test(vendor_email)) {
        Swal.fire("Validation Error", "Please enter valid Email Address", "warning");
        return false;
    }

    // Phone Validation
    let phonePattern = /^[0-9]{10}$/;
    if (!phonePattern.test(vendor_phonenumber)) {
        Swal.fire("Validation Error", "Please enter valid 10 digit Phone Number", "warning");
        return false;
    }

    // PAN Validation
    let panPattern = /^[A-Z]{5}[0-9]{4}[A-Z]{1}$/;
    if (vendor_pan !== "" && !panPattern.test(vendor_pan)) {
        Swal.fire("Validation Error", "Please enter valid PAN Number", "warning");
        return false;
    }

    // IFSC Validation
    let ifscPattern = /^[A-Z]{4}0[A-Z0-9]{6}$/;
    if (vendor_ifsccode !== "" && !ifscPattern.test(vendor_ifsccode)) {
        Swal.fire("Validation Error", "Please enter valid IFSC Code", "warning");
        return false;
    }

    var msg;
    if (vendor_id > 0)
        msg = "Data updated successfully";
    else
        msg = "Data submitted successfully";

    Swal.fire({
        title: 'Saving...',
        text: 'Please wait',
        allowOutsideClick: false,
        didOpen: () => { Swal.showLoading(); }
    });

    // AJAX CALL
    $.ajax({
        url: "VendorMaster.aspx/InsertVendor",
        type: "POST",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({
            VendorID: vendor_id,
            VendorName: vendor_name,
            Description: vendor_description,
            ContactPerson: vendor_contactperson,
            Address: vendor_address,
            EmailID: vendor_email,
            Phone: vendor_phonenumber,
            Fax: vendor_fax,
            WebUrl: vendor_weburl,
            AcctHolderName: vendor_accountholder,
            BankName: vendor_bank,
            BranchNameAddr: vendor_branchaddress,
            AccountType: vendor_accounttype,
            AccountNum: vendor_accountno,
            MICR: vendor_micrcode,
            IFSC: vendor_ifsccode,
            GstNo: vendor_gstno,
            PANNo: vendor_pan
        }),

        success: function (response) {

            let result = response.d;

            Swal.fire({
                icon: 'success',
                title: 'Success',
                text: msg,
                confirmButtonColor: '#3085d6'
            }).then(function () {
                location.reload();
            });
        },

        error: function (xhr) {

            $('#load1').hide();

            console.error(xhr.responseText);

            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'Failed to submit vendor details'
            });
        }
    });

    return false;
}

function assetvendor_edit(vendorId, rowIndex) {

    vendor_id = vendorId;

    // Get selected row data from datatable
    const rowData = vendorlist.row(rowIndex).data();

    // Bind Values
    $('#vendor_name').val(rowData.VendorName);
    $('#vendor_gstno').val(rowData.GSTNo);
    $('#vendor_contactperson').val(rowData.Contact_Person);
    $('#vendor_phonenumber').val(rowData.Phone);

    $('#vendor_email').val(rowData.EmailId);
    $('#vendor_fax').val(rowData.Fax);
    $('#vendor_weburl').val(rowData.Web_url);

    $('#vendor_accountholder').val(rowData.AccountHolderName);
    $('#vendor_bank').val(rowData.BankName);
    $('#vendor_branchaddress').val(rowData.BranchNameAddr);

    $('#vendor_accounttype').val(rowData.AccountType);
    $('#vendor_accountno').val(rowData.AccountNumber);

    $('#vendor_micrcode').val(rowData.MICRCode);
    $('#vendor_ifsccode').val(rowData.IFSCCode);

    $('#vendor_pan').val(rowData.PAN);
    $('#vendor_description').val(rowData.Description);
    $('#vendor_address').val(rowData.Address);

    // Change Button UI
    $('#vendor_btnsubmit').text('Update Vendor');//.removeClass('btn-primary').addClass('btn-warning');
    $('#vendor_btnreset').show();

    // Scroll top
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

/* Update */
function vendor_update() {

    const vendorObj = {

        vendorId: editVendorId,

        VendorName: $('#vendor_name').val().trim(),
        GSTNo: $('#vendor_gstno').val().trim(),
        Contact_Person: $('#vendor_contactperson').val().trim(),
        Phone: $('#vendor_phonenumber').val().trim(),

        EmailId: $('#vendor_email').val().trim(),
        Fax: $('#vendor_fax').val().trim(),
        Web_url: $('#vendor_weburl').val().trim(),

        AccountHolderName: $('#vendor_accountholder').val().trim(),
        BankName: $('#vendor_bank').val().trim(),
        BranchNameAddr: $('#vendor_branchaddress').val().trim(),

        AccountType: $('#vendor_accounttype').val().trim(),
        AccountNumber: $('#vendor_accountno').val().trim(),

        MICRCode: $('#vendor_micrcode').val().trim(),
        IFSCCode: $('#vendor_ifsccode').val().trim(),

        PAN: $('#vendor_pan').val().trim(),

        Description: $('#vendor_description').val().trim(),
        Address: $('#vendor_address').val().trim()
    };

    $('#load1').show();

    $.ajax({

        url: "VendorMaster.aspx/UpdateVendor",
        type: "POST",
        data: JSON.stringify({ vendor: vendorObj }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (response) {

            $('#load1').hide();

            alert('Vendor updated successfully.');

            // Reload table
            BindVendorMaster();

            // Reset form
            clearVendorForm();
        },

        error: function (xhr) {

            $('#load1').hide();

            console.error(xhr.responseText);

            alert('Error updating vendor.');
        }
    });

    return false;
}







// Apply the search
function BindAllAssets() {
    $('#load1').show();
    assetlist_html = '';
    $.ajax({
        url: "AssetMasterReport.aspx/GetAllAssets",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//

            allassetslist = $('#allassetslist').DataTable({
                dom: 'Bftip',
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                filter: true,
                'select': {
                    'style': 'single'
                },
                "serverSide": false,
                "data": dataArray,
                columns: [
                    { data: '' },
                    { data: 'assetslno' },
                    { data: 'AssetsTypeName' },
                    { data: 'Barcode' },
                    { data: 'BranchName' },
                    { data: 'vendorName' },
                    { data: 'DayUserCode' },
                    { data: 'PurchaseCost' },
                    { data: 'TaxAmount' },
                    { data: 'PurchaseDate' },
                    { data: 'PONumber' },
                    { data: 'InvoiceNumber' },
                    { data: 'Remark' },
                    { data: 'DeskNo' },
                    { data: 'AssetGroupName' },
                    { data: 'AssetName' },
                    { data: 'Brand' },
                    { data: 'Model' },
                    { data: 'DepartmentName' },
                    { data: 'SECTION' },
                    { data: 'AssetStatus' },
                    { data: 'EveUserCode' },
                    { data: 'NgtUserCode' }

                ],
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                },
                columnDefs: [
                    {
                        targets: 0,
                        "width": "45px",
                        render: function (data, type, row, meta) {
                            return '<a class="dropdown-item" href="#!" id="Actions" onclick="assetmaster_EditAsset(\'' + meta.row + '\');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-pen"></i></span></a>';
                            //return '<input type="button" class="btn-primary" id=viewdetails-"' + meta.row + '" value="Details" onclick="return ViewPolicyDetails(\'' + meta.row + '\');" />&nbsp;<input type="button" class="btn-default" id=viewtasks-"' + meta.row + '" value="Tasks"  onclick="return ViewTaskDetails(\'' + meta.row + '\');"/>';
                        }

                    }
                ],

                initComplete: function () {
                    $('#load1').hide();

                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Asset Master Report', autoFilter: true,


                    },


                ],

            });
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    $('#allassetslist thead tr:eq(1) th').each(function () {
        var title = $(this).text();
        $(this).html('<input type="text" placeholder="Search ' + title + '" class="column_search" />');
    });

    $('#allassetslist thead').on('keyup', ".column_search", function () {

        allassetslist
            .column($(this).parent().index())
            .search(this.value)
            .draw();
    });
    return false;
}

function assetmaster_EditAsset(index) {
    var row = $('#allassetslist').DataTable().row(index).data();
    document.getElementById("assetedit_name").value = row.assetslno;
    document.getElementById("assetedit_type").value = row.AssetsTypeName;
    document.getElementById("assetedit_location").value = row.BranchName;
    document.getElementById("assetedit_barcode").value = row.Barcode;
    $("#assetmaster_editpopup").modal("show");
}

function BindAssetStatus() {
    var select = document.getElementById("assetedit_status");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }


    $("#assetedit_status").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "AssetMasterReport.aspx/GetAllAssetsStatus", dataType: "json", contentType: "application/json",
        success: function (res) {
            $.each(res.d, function (data1, value1) {
                $("#assetedit_status").append($("<option></option>").val(value1.StatusId1).html(value1.AssetStatus1));
            })
        }

    });
}
