var abbreviation;
function addasset_bindlocation() {
    var select = document.getElementById("addasset_location");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#addasset_location").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "AddAsset.aspx/GetBranches", dataType: "json", contentType: "application/json; charset=utf-8",
        success: function (res) {
            var dataArray = res.d;//
            $.each(dataArray, function (index, value) {
                $("#addasset_location").append($("<option></option>").val(value.BranchID).html(value.BranchName));
            })
        },
        error: function (error) {
            alert('error; ' + error.responseText);
        }
    });
}

function addasset_bindgroup() {
    var select = document.getElementById("addasset_group");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#addasset_group").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "AssetGroup.aspx/GetAllAssetGroups", dataType: "json", contentType: "application/json; charset=utf-8",
        success: function (res) {
            var dataArray = JSON.parse(res.d);//
            $.each(dataArray, function (index, value) {
                $("#addasset_group").append($("<option></option>").val(value.GroupId).html(value.AssetGroupName));
            })
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
}

function addasset_getassettypes() {
    var ddlgroup = document.getElementById("addasset_group");
    var groupid = ddlgroup.options[ddlgroup.selectedIndex].value;
    var select = document.getElementById("addasset_type");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#addasset_type").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "AddAsset.aspx/GetAllAssetsTypesByGroupID", dataType: "json", contentType: "application/json; charset=utf-8",
        data: "{GroupID:" + groupid + "}",
        success: function (res) {
            var dataArray = JSON.parse(res.d);//
            $.each(dataArray, function (index, value) {
                $("#addasset_type").append($("<option></option>").val(value.AssetsTypeId).html(value.AssetsTypeName));
            })
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
}

function addasset_generatebarcode() {
    var ddltype = document.getElementById("addasset_type");
    var assettype = ddltype.options[ddltype.selectedIndex].text;
    PageMethods.GetAssetAbbreviation(assettype, abbr_OnSuccess, abbr_OnError);
    return false;
}

function abbr_OnSuccess(result) {
    abbreviation = result;
    var ddlassettype = document.getElementById("addasset_type");
    var assettype = ddlassettype.options[ddlassettype.selectedIndex].value;
    PageMethods.GetAssetCount(assettype, abbr1_OnSuccess, abbr1_OnError);
    return false;
}
function abbr_OnError(error) {
    alert(error.responseText);
}

function abbr1_OnSuccess(result) {
    var company = "IN";
    var assetcount = result;
    var ddlloc = document.getElementById("addasset_location");
    var location = ddlloc.options[ddlloc.selectedIndex].text;
    var ddlassettype = document.getElementById("addasset_type");
    var assettype = ddlassettype.options[ddlassettype.selectedIndex].value;
    var loc = location.substring(0, 2).toUpperCase();
    if (result < 10) {
        document.getElementById("addasset_barcode").value = company + "" + loc + "" + abbreviation + "0000" + result;
    }
    else if (result >= 10 && result < 100) {
        document.getElementById("addasset_barcode").value = company + "" + loc + "" + abbreviation + "000" + result;
    }
    else if (result >= 100 && result < 1000) {
        document.getElementById("addasset_barcode").value = company + "" + loc + "" + abbreviation + "00" + result;
    }
    else if (result >= 1000 && result < 10000) {
        document.getElementById("addasset_barcode").value = company + "" + loc + "" + abbreviation + "0" + result;
    }
    else
        document.getElementById("addasset_barcode").value = company + "" + loc + "" + abbreviation + "" + result;
    return false;
}
function abbr1_OnError(error) {
    alert(error.responseText);
}

function addasset_bindbrand() {
    var select = document.getElementById("addasset_brand");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#addasset_brand").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "Brand.aspx/GetAllBrand", dataType: "json", contentType: "application/json; charset=utf-8",
        success: function (res) {
            var dataArray = JSON.parse(res.d);//
            $.each(dataArray, function (index, value) {
                $("#addasset_brand").append($("<option></option>").val(value.BrandID).html(value.Brand));
            })
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
}

function addasset_bindstatus() {
    var select = document.getElementById("addasset_status");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#addasset_status").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "AssetMasterReport.aspx/GetAllAssetsStatus", dataType: "json", contentType: "application/json; charset=utf-8",
        success: function (res) {
            var dataArray = JSON.parse(res.d);//
            $.each(dataArray, function (index, value) {
                $("#addasset_status").append($("<option></option>").val(value.StatusId).html(value.AssetStatus));
            })
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
}

function addasset_bindvendors() {
    var select = document.getElementById("addasset_vendor");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#addasset_vendor").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "AddAsset.aspx/GetAssetVendor", dataType: "json", contentType: "application/json; charset=utf-8",
        success: function (res) {
            var dataArray = JSON.parse(res.d);//
            $.each(dataArray, function (index, value) {
                $("#addasset_vendor").append($("<option></option>").val(value.VendorID).html(value.VendorName));
            })
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
}

function addasset_binddepartment() {
    var select = document.getElementById("addasset_department");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#addasset_department").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "AddAsset.aspx/GetDepartment", dataType: "json", contentType: "application/json; charset=utf-8",
        success: function (res) {
            $.each(res.d, function (index, value) {
                $("#addasset_department").append($("<option></option>").val(value.DepartmentID).html(value.DepartmentName));
            })
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
}

function core_addasset_submit() {

    var ddlloc = document.getElementById("addasset_location");
    var loc = ddlloc.value;

    if (loc == "") {
        Swal.fire({ icon: 'warning', title: 'Required', text: 'Please select location' });
        return false;
    }

    var assetname = document.getElementById("addasset_name").value;

    var ddlassettype = document.getElementById("addasset_type");
    var assettype = ddlassettype.value;

    if (assettype == "") {
        Swal.fire({ icon: 'warning', title: 'Required', text: 'Please select asset type' });
        return false;
    }

    var assetsrno = document.getElementById("addasset_srno").value;
    if (assetsrno == "") {
        Swal.fire({ icon: 'warning', title: 'Required', text: 'Please enter asset serial number' });
        return false;
    }

    var barcode = document.getElementById("addasset_barcode").value;
    var companyid = 1;

    var brand = document.getElementById("addasset_brand").value;
    if (brand == "") {
        Swal.fire({ icon: 'warning', title: 'Required', text: 'Please select brand' });
        return false;
    }

    var dept = document.getElementById("addasset_department").value;
    if (dept == "") {
        Swal.fire({ icon: 'warning', title: 'Required', text: 'Please select department' });
        return false;
    }

    var purchasecost = document.getElementById("addasset_purchasecost").value || "0";

    var vendor = document.getElementById("addasset_vendor").value;
    if (vendor == "") {
        Swal.fire({ icon: 'warning', title: 'Required', text: 'Please select vendor' });
        return false;
    }

    var status = document.getElementById("addasset_status").value;
    if (status == "") {
        Swal.fire({ icon: 'warning', title: 'Required', text: 'Please select asset status' });
        return false;
    }

    var group = document.getElementById("addasset_group").value;
    if (group == "") {
        Swal.fire({ icon: 'warning', title: 'Required', text: 'Please select asset group' });
        return false;
    }

    var remark = document.getElementById("addasset_remark").value;
    var ponumber = document.getElementById("addasset_ponumber").value;
    var invoicenumber = document.getElementById("addasset_invoicenumber").value;
    var purchasedate = document.getElementById("addasset_purchasedate").value;
    var taxamount = document.getElementById("addasset_taxamount").value;

    // loader
    Swal.fire({
        title: 'Saving...',
        text: 'Please wait',
        allowOutsideClick: false,
        didOpen: () => {
            Swal.showLoading();
        }
    });

    PageMethods.InsertAssets(
        assetname, assettype, assetsrno, barcode, companyid,
        brand, dept, loc, purchasecost, vendor,
        "01/01/1900", "01/01/1900",
        status, group, remark,
        ponumber, invoicenumber, purchasedate, taxamount,
        function (result) {

            Swal.fire({
                icon: result > 0 ? 'success' : 'error',
                title: result > 0 ? 'Success' : 'Failed',
                text: result > 0
                    ? 'Asset added successfully!'
                    : 'Error while adding asset. Please contact administrator.'
            });

        },
        function (error) {

            Swal.fire({
                icon: 'error',
                title: 'Server Error',
                text: error.responseText || 'Something went wrong'
            });

        }
    );

    return false;
}


function c555_addasset_submit() {

    // ---------- VALIDATION (TOAST MESSAGES) ----------

    if (document.getElementById("addasset_location").value == "") {
        showToast("Please select location", "warning");
        return false;
    }

    if (document.getElementById("addasset_group").value == "") {
        showToast("Please select asset group", "warning");
        return false;
    }

    if (document.getElementById("addasset_type").value == "") {
        showToast("Please select asset type", "warning");
        return false;
    }

    if (document.getElementById("addasset_name").value.trim() == "") {
        showToast("Please enter asset name", "warning");
        return false;
    }

    if (document.getElementById("addasset_srno").value.trim() == "") {
        showToast("Please enter asset serial number", "warning");
        return false;
    }

    if (document.getElementById("addasset_brand").value == "") {
        showToast("Please select brand", "warning");
        return false;
    }

    if (document.getElementById("addasset_department").value == "") {
        showToast("Please select department", "warning");
        return false;
    }

    if (document.getElementById("addasset_vendor").value == "") {
        showToast("Please select vendor", "warning");
        return false;
    }

    if (document.getElementById("addasset_status").value == "") {
        showToast("Please select asset status", "warning");
        return false;
    }

    // ---------- DATA ----------
    var assetname = document.getElementById("addasset_name").value;
    var assettype = document.getElementById("addasset_type").value;
    var assetsrno = document.getElementById("addasset_srno").value;
    var barcode = document.getElementById("addasset_barcode").value;
    var companyid = 1;

    var brand = document.getElementById("addasset_brand").value;
    var dept = document.getElementById("addasset_department").value;
    var loc = document.getElementById("addasset_location").value;
    var purchasecost = document.getElementById("addasset_purchasecost").value || "0";
    var vendor = document.getElementById("addasset_vendor").value;
    var status = document.getElementById("addasset_status").value;
    var group = document.getElementById("addasset_group").value;

    var remark = document.getElementById("addasset_remark").value;
    var ponumber = document.getElementById("addasset_ponumber").value;
    var invoicenumber = document.getElementById("addasset_invoicenumber").value;
    var purchasedate = document.getElementById("addasset_purchasedate").value;
    var taxamount = document.getElementById("addasset_taxamount").value;

    // ---------- LOADING (SWAL) ----------
    Swal.fire({
        title: 'Saving...',
        text: 'Please wait',
        allowOutsideClick: false,
        didOpen: () => {
            Swal.showLoading();
        }
    });

    // ---------- SAVE ----------
    PageMethods.InsertAssets(
        assetname, assettype, assetsrno, barcode, companyid,
        brand, dept, loc, purchasecost, vendor,
        "01/01/1900", "01/01/1900",
        status, group, remark,
        ponumber, invoicenumber, purchasedate, taxamount,

        function (result) {

            Swal.fire({
                icon: result > 0 ? 'success' : 'error',
                title: result > 0 ? 'Success' : 'Failed',
                text: result > 0
                    ? 'Asset added successfully!'
                    : 'Error while adding asset. Please contact administrator.'
            }).then(function () {

                if (result > 0) {
                    clearAssetForm();
                }

            });

        },

        function (error) {

            Swal.fire({
                icon: 'error',
                title: 'Server Error',
                text: error.responseText || 'Something went wrong'
            });

        }
    );

    return false;
}

function core_showToast(message, type = "error") {
    var toast = document.getElementById("toastMsg");

    toast.innerHTML = message;
    toast.style.display = "block";

    if (type === "success") {
        toast.style.background = "#28a745";
    } else if (type === "warning") {
        toast.style.background = "#ffc107";
        toast.style.color = "#000";
    } else {
        toast.style.background = "#dc3545";
        toast.style.color = "#fff";
    }

    setTimeout(function () {
        toast.style.display = "none";
    }, 2500);
}

function showToast(message, type = "error") {

    var container = document.getElementById("toastContainer");

    var toast = document.createElement("div");
    toast.className = "toast-box toast-" + type;
    toast.innerHTML = message;

    container.appendChild(toast);

    setTimeout(function () {
        toast.remove();
    }, 2500);
}

function c2_addasset_submit() {

    alert('message');

    // ---------- RESET ERRORS ----------
    var fields = [
        "addasset_location",
        "addasset_group",
        "addasset_type",
        "addasset_name",
        "addasset_srno",
        "addasset_barcode",
        "addasset_brand",
        "addasset_department",
        "addasset_vendor",
        "addasset_status",
        "addasset_purchasecost",
        "addasset_purchasedate",
        "addasset_ponumber",
        "addasset_invoicenumber",
        "addasset_taxamount",
        "addasset_remark"
    ];

    fields.forEach(f => clearFieldError(f));

    // ---------- VALIDATION FUNCTION ----------
    function fail(id, msg) {
        setFieldError(id);
        showToast(msg, "warning");
        document.getElementById(id).focus();
        return false;
    }

    // ---------- VALIDATION (ALL 16 FIELDS) ----------

    if (document.getElementById("addasset_location").value == "")
        return fail("addasset_location", "Please select location");

    if (document.getElementById("addasset_group").value == "")
        return fail("addasset_group", "Please select asset group");

    if (document.getElementById("addasset_type").value == "")
        return fail("addasset_type", "Please select asset type");

    if (document.getElementById("addasset_name").value.trim() == "")
        return fail("addasset_name", "Please enter asset name");

    if (document.getElementById("addasset_srno").value.trim() == "")
        return fail("addasset_srno", "Please enter asset serial number");

    if (document.getElementById("addasset_barcode").value.trim() == "")
        return fail("addasset_barcode", "Please generate barcode");

    if (document.getElementById("addasset_brand").value == "")
        return fail("addasset_brand", "Please select brand");

    if (document.getElementById("addasset_department").value == "")
        return fail("addasset_department", "Please select department");

    if (document.getElementById("addasset_vendor").value == "")
        return fail("addasset_vendor", "Please select vendor");

    if (document.getElementById("addasset_status").value == "")
        return fail("addasset_status", "Please select asset status");

    if (document.getElementById("addasset_purchasecost").value.trim() == "")
        return fail("addasset_purchasecost", "Please enter purchase cost");

    if (document.getElementById("addasset_purchasedate").value == "")
        return fail("addasset_purchasedate", "Please select purchase date");

    if (document.getElementById("addasset_ponumber").value.trim() == "")
        return fail("addasset_ponumber", "Please enter PO number");

    if (document.getElementById("addasset_invoicenumber").value.trim() == "")
        return fail("addasset_invoicenumber", "Please enter invoice number");

    if (document.getElementById("addasset_taxamount").value.trim() == "")
        return fail("addasset_taxamount", "Please enter tax amount");

    if (document.getElementById("addasset_remark").value.trim() == "")
        return fail("addasset_remark", "Please enter asset configuration");

    // ---------- BUTTON DISABLE ----------
    var btn = document.getElementById("addasset_btnsubmit");
    btn.disabled = true;

    // ---------- LOADING ----------
    Swal.fire({
        title: 'Saving...',
        text: 'Please wait',
        allowOutsideClick: false,
        didOpen: () => Swal.showLoading()
    });

    // ---------- SAVE ----------
    PageMethods.InsertAssets(

        document.getElementById("addasset_name").value,
        document.getElementById("addasset_type").value,
        document.getElementById("addasset_srno").value,
        document.getElementById("addasset_barcode").value,
        1,
        document.getElementById("addasset_brand").value,
        document.getElementById("addasset_department").value,
        document.getElementById("addasset_location").value,
        document.getElementById("addasset_purchasecost").value,
        document.getElementById("addasset_vendor").value,
        "01/01/1900",
        "01/01/1900",
        document.getElementById("addasset_status").value,
        document.getElementById("addasset_group").value,
        document.getElementById("addasset_remark").value,
        document.getElementById("addasset_ponumber").value,
        document.getElementById("addasset_invoicenumber").value,
        document.getElementById("addasset_purchasedate").value,
        document.getElementById("addasset_taxamount").value,

        function (result) {

            btn.disabled = false;

            Swal.fire({
                icon: result > 0 ? 'success' : 'error',
                title: result > 0 ? 'Success' : 'Failed',
                text: result > 0
                    ? 'Asset added successfully!'
                    : 'Error while adding asset'
            }).then(function () {

                if (result > 0) {
                    clearAssetForm();
                }

            });

        },

        function (error) {

            btn.disabled = false;

            Swal.fire({
                icon: 'error',
                title: 'Server Error',
                text: error.responseText || 'Something went wrong'
            });

        }
    );

    return false;
}


function addasset_submit() {

    // ---------- VALIDATION (TOAST MESSAGES) ----------

    if (document.getElementById("addasset_location").value == "") {
        showToast("Please select location", "warning");
        return false;
    }

    if (document.getElementById("addasset_group").value == "") {
        showToast("Please select asset group", "warning");
        return false;
    }

    if (document.getElementById("addasset_type").value == "") {
        showToast("Please select asset type", "warning");
        return false;
    }

    if (document.getElementById("addasset_name").value.trim() == "") {
        showToast("Please enter asset name", "warning");
        return false;
    }

    if (document.getElementById("addasset_srno").value.trim() == "") {
        showToast("Please enter asset serial number", "warning");
        return false;
    }

    if (document.getElementById("addasset_barcode").value.trim() == "") {
        showToast("Please generate barcode", "warning");
        return false;
    }

    if (document.getElementById("addasset_brand").value == "") {
        showToast("Please select brand", "warning");
        return false;
    }

    if (document.getElementById("addasset_department").value == "") {
        showToast("Please select department", "warning");
        return false;
    }

    if (document.getElementById("addasset_vendor").value == "") {
        showToast("Please select vendor", "warning");
        return false;
    }

    if (document.getElementById("addasset_status").value == "") {
        showToast("Please select asset status", "warning");
        return false;
    }

    if (document.getElementById("addasset_purchasecost").value.trim() == "") {
        showToast("Please enter purchase cost", "warning");
        return false;
    }

    if (document.getElementById("addasset_purchasedate").value == "") {
        showToast("Please select purchase date", "warning");
        return false;
    }

    if (document.getElementById("addasset_ponumber").value.trim() == "") {
        showToast("Please enter PO number", "warning");
        return false;
    }

    if (document.getElementById("addasset_invoicenumber").value.trim() == "") {
        showToast("Please enter invoice number", "warning");
        return false;
    }

    if (document.getElementById("addasset_taxamount").value.trim() == "") {
        showToast("Please enter tax amount", "warning");
        return false;
    }

    if (document.getElementById("addasset_remark").value.trim() == "") {
        showToast("Please enter asset configuration", "warning");
        return false;
    }

    // ---------- DATA ----------
    var assetname = document.getElementById("addasset_name").value;
    var assettype = document.getElementById("addasset_type").value;
    var assetsrno = document.getElementById("addasset_srno").value;
    var barcode = document.getElementById("addasset_barcode").value;
    var companyid = 1;

    var brand = document.getElementById("addasset_brand").value;
    var dept = document.getElementById("addasset_department").value;
    var loc = document.getElementById("addasset_location").value;
    var purchasecost = document.getElementById("addasset_purchasecost").value;
    var vendor = document.getElementById("addasset_vendor").value;
    var status = document.getElementById("addasset_status").value;
    var group = document.getElementById("addasset_group").value;

    var remark = document.getElementById("addasset_remark").value;
    var ponumber = document.getElementById("addasset_ponumber").value;
    var invoicenumber = document.getElementById("addasset_invoicenumber").value;
    var purchasedate = document.getElementById("addasset_purchasedate").value;
    var taxamount = document.getElementById("addasset_taxamount").value;

    // ---------- LOADING (SWAL) ----------
    Swal.fire({
        title: 'Saving...',
        text: 'Please wait',
        allowOutsideClick: false,
        didOpen: () => {
            Swal.showLoading();
        }
    });

    // ---------- SAVE ----------
    PageMethods.InsertAssets(
        assetname, assettype, assetsrno, barcode, companyid,
        brand, dept, loc, purchasecost, vendor,
        "01/01/1900", "01/01/1900",
        status, group, remark,
        ponumber, invoicenumber, purchasedate, taxamount,

        function (result) {

            Swal.fire({
                icon: result > 0 ? 'success' : 'error',
                title: result > 0 ? 'Success' : 'Failed',
                text: result > 0
                    ? 'Asset added successfully!'
                    : 'Error while adding asset. Please contact administrator.'
            }).then(function () {

                if (result > 0) {
                    clearAssetForm();
                }

            });

        },

        function (error) {

            Swal.fire({
                icon: 'error',
                title: 'Server Error',
                text: error.responseText || 'Something went wrong'
            });

        }
    );

    return false;
}

function clearAssetForm() {

    document.getElementById("addasset_location").value = "";
    document.getElementById("addasset_group").value = "";
    document.getElementById("addasset_type").value = "";

    document.getElementById("addasset_name").value = "";
    document.getElementById("addasset_srno").value = "";
    document.getElementById("addasset_barcode").value = "";

    document.getElementById("addasset_brand").value = "";
    document.getElementById("addasset_department").value = "";
    document.getElementById("addasset_vendor").value = "";
    document.getElementById("addasset_status").value = "";

    document.getElementById("addasset_purchasecost").value = "";
    document.getElementById("addasset_purchasedate").value = "";
    document.getElementById("addasset_ponumber").value = "";
    document.getElementById("addasset_invoicenumber").value = "";
    document.getElementById("addasset_taxamount").value = "";

    document.getElementById("addasset_remark").value = "";
}

function setFieldError(id) {
    document.getElementById(id).classList.add("input-error");
}