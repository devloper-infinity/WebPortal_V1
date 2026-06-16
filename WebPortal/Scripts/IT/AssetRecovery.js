let draggedLi = null;
let draggedItems = [];

function assetrec_bindUsers() {

    var select = document.getElementById("assetrec_user");
    let options = select.getElementsByTagName('assetrec_user');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#assetrec_user").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "AssetRecovery.aspx/GetAllUsers", dataType: "json", contentType: "application/json",
        success: function (res) {

            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (data, value) {

                $("#assetrec_user").append($("<option></option>").val(value.EmployeeID).html(value.FullName));
            })
        }
    });
}

function bindAssets(EmpID) {

   /* EmpID = 10244;*/

    $.ajax({
        type: "POST",
        url: "AssetRecovery.aspx/GetAllEmployeeDetailsbyPM",
        dataType: "json",
        data: "{EmpID:" + EmpID + "}",
        contentType: "application/json",

        success: function (res) {

            let ul = $("#assetrec_assign");
            ul.empty();

            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (i, item) {

                let li = $("<li>")
                    .text(item.Asset)          // display text
                    .attr("data-id", item.AssetId)
                    .attr("draggable", true)
                    .on("dragstart", dragLi);

                ul.append(li);
            });
        },
        error: function () {
            alert("Error loading assets");
        }
    });
}

/* ---------- CLICK SELECT ---------- */
$(document).on("click", ".listbox-ul li", function (e) {

    if (!e.ctrlKey) {
        $(".listbox-ul li").removeClass("selected");
    }

    $(this).toggleClass("selected");
});

/* ---------- DRAG ---------- */
function dragLi(e) {

    // alert(e.target);
    draggedLi = e.target;
}

/* ---------- DROP ---------- */
function allowDrop(e) {
    e.preventDefault();
}

function dropLi(e) {
    e.preventDefault();
    e.currentTarget.appendChild(draggedLi);
}

function BindAssetRecovery_Grid() {

    $('#load1').show();

    $.ajax({
        url: 'AssetRecovery.aspx/GetAssetRecovery',
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = JSON.parse(data.d);

            if ($.fn.DataTable.isDataTable('#table_assetrec')) {
                $('#table_assetrec').DataTable().clear().destroy();
            }

            table = $('#table_assetrec').DataTable({
                dom: 'lBftp',
                data: dataArray,
                scrollX: true,
                paging: true,
                autoWidth: true,
                processing: true,
                ordering: false,
                serverSide: false,

                columns: [

                    { data: 'SrNo', className: 'text-center' },
                    { data: 'Code' },
                    { data: 'AssetCode' },
                    { data: 'OtherAsset' },
                    { data: 'EmpStatus' },
                    { data: 'Remark' },
                    { data: 'AddedByName' },
                    { data: 'AddedDate' }
                ],

                initComplete: function () {

                    $('#load1').hide();
                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: "Assets Recovery",
                    },
                ],
            });
        },

        error: function (error) {
            alert('Error: ' + error.responseText);
        }
    });

    return false;
}

function bindprevassets(empid) {

    var user = empid.options[empid.selectedIndex].value;

    document.getElementById("assetrec_assign").innerHTML = "";
    document.getElementById("assetrec_recover").innerHTML = "";

    if (user != "") {
        bindAssets(user);
    }
}

function assetrec_submit() {

    let assetrec_assetIds = [];

    $("#assetrec_recover li").each(function () {
        assetrec_assetIds.push($(this).data("id"));
    });

    var ddlemp = document.getElementById("assetrec_user");
    var user = ddlemp.options[ddlemp.selectedIndex].value;

    var assetrec_status = document.getElementById("assetrec_status").value;
    var assetrec_desc = document.getElementById("assetrec_otherAsset").value;
    var assetrec_remark = document.getElementById("assetrec_remark").value;

    if (user == "Select") {
        alert("Please select user.");
        document.getElementById("assetrec_user").focus();
        return false;
    }
    if (assetrec_desc == "") {
        alert("Please enter other asset.");
        document.getElementById("assetrec_otherAsset").focus();
        return false;
    }
    if (assetrec_remark == "") {
        alert("Please enter remark.");
        document.getElementById("assetrec_remark").focus();
        return false;
    }
    if (assetrec_status == "") {
        alert("Please select status.");
        document.getElementById("assetrec_status").focus();
        return false;
    }

    PageMethods.InsertAssetRecovery(user, assetrec_assetIds, assetrec_desc, assetrec_remark, assetrec_status, assetrec_OnSuccess, assetrec_OnError)
    return false;
}

function assetrec_OnSuccess(result) {

    success_msg = "Asset recovered successfully!";
    err_msg = "Oops! Error occured while recovering assets. Please contact administrator!!";

    if (result > 0) {

        document.getElementById("assetrec_status").value = '';
        document.getElementById("assetrec_errmsg").innerHTML = "Asset recovered successfully!";

        $('#assetrec_dverror').modal('show');
        clearAssetRecFields();
        Bindassetrec_Grid();
        return false;
    }
    else {
        document.getElementById("assetrec_errmsg").innerHTML = "Oops! Error occured while recovering assets. Please contact administrator!!";
        document.getElementById("assetrec_errmsg").style.color = 'red';
        $('#assetrec_dverror').modal('show');
        return false;
    }
}

function assetrec_OnError(error) {
    alert(error.responseText);
}

function clearAssetRecFields() {

    // Reset dropdowns
    document.getElementById("assetrec_user").selectedIndex = 0;
    document.getElementById("assetrec_status").selectedIndex = 0;

    // Clear textbox & textarea
    document.getElementById("assetrec_otherAsset").value = "";
    document.getElementById("assetrec_remark").value = "";

    // Clear asset lists (UL)
    document.getElementById("assetrec_assign").innerHTML = "";
    document.getElementById("assetrec_recover").innerHTML = "";

}