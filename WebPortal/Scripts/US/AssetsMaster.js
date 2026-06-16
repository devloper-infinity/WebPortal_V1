
function Bind_Users() {

    var select = document.getElementById("usassets_user");
    let options = select.getElementsByTagName('usassets_user');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#usassets_user").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "USAssetMaster.aspx/GetUSEmployees",
        dataType: "json",
        contentType: "application/json",
        success: function (res) {

            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (data, value) {

                $("#usassets_user").append($("<option></option>").val(value.Name).html(value.Name));
            })
        }
    });

}

function BindAsset_Grid() {

    $('#load1').show();
    var table;

    $.ajax({
        url: 'USAssetMaster.aspx/GetAllUSAssets',
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = JSON.parse(data.d);

            if ($.fn.DataTable.isDataTable('#table_usassets')) {
                $('#table_usassets').DataTable().clear().destroy();
            }

            table = $('#table_usassets').DataTable({
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
                    { data: 'User' },
                    { data: 'Brand' },
                    { data: 'SerialNo' },
                    { data: 'Status' },
                    { data: 'IssueDate' },
                    { data: 'Remark' },
                    { data: 'AddedByName' },
                    { data: 'AddedDate' }
                ],


                initComplete: function () {

                    $('#load1').hide();
                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: "US Assets",
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

function usassets_submit() {

    var ddluser = document.getElementById("usassets_user");
    var user = ddluser.options[ddluser.selectedIndex].text;
    var brand = document.getElementById("usassets_brand").value;
    var serialNo = document.getElementById("usassets_serialNo").value;
    var issueDate = document.getElementById("usassets_issueDate").value;
    var ddlStatus = document.getElementById("usassets_status");
    var status = ddlStatus.options[ddlStatus.selectedIndex].text;
    var remark = document.getElementById("usassets_remark").value;


    if (user == "Select") {
        alert("Please select User");
        return false;
    }

    if (brand == "") {
        alert("Please enter brand");
        return false;
    }
    if (serialNo == "") {
        alert("Please enter Serial #");
        return false;
    }
    if (status == "Select") {
        alert("Please select Status");
        return false;
    }
    if (issueDate == "") {
        alert("Please  enter Issue Date");
        return false;
    }
    if (remark == "") {
        alert("Please enter remark");
        return false;
    }

    PageMethods.InsertAssets(user, brand, serialNo, status, issueDate, remark, OnSuccess_usassets, OnError_usassets);

    return false;
}

function OnSuccess_usassets(result) {

    if (result > 0) {
        alert("Asset assign successfully");
        clearAssetsForm();
        BindAsset_Grid();
    }
    else {

        alert("Error assigning assets.");
    }
}

function OnError_usassets(error) {

    alert(error.responseText);
    return false;
}

function clearAssetsForm() {
    $('#usassets_user').val('Select');
    $('#usassets_brand').val('');
    $('#usassets_serialNo').val('');
    $('#usassets_status').val('Select');
    $('#usassets_issueDate').val('');
    $('#usassets_remark').val('');
} 