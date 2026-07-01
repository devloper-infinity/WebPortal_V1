var pmDelegationTable = null;

console.log('delegates');


function pm_parseResponse(res, fallback) {
    var data = res && res.d !== undefined ? res.d : res;

    if (typeof data === "string") {
        try {
            data = JSON.parse(data);
        } catch (e) {
            data = fallback;
        }
    }

    return data || fallback;
}


function pm_bindEmployees() {

    $.ajax({
        type: "POST",
        url: "EmployeeLeaves.aspx/BindUsers",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        success: function (res) {

            var data = [];

            try {
                data = res.d;

                if (typeof data === "string") {
                    data = JSON.parse(data);
                }

                if (!Array.isArray(data)) {
                    data = [];
                }
            }
            catch (e) {
                console.log(e);
                Swal.fire("Invalid Data", "Employee list data is not valid.", "error");
                return;
            }

            var html = '<option value="0">Select Employee</option>';

            $.each(data, function (i, item) {
                html += '<option value="' + item.EMPID + '">' +
                    item.Code + ' : ' + item.NAME +
                    '</option>';
            });

            $("#ddlPMEmployee").html(html);
            $("#ddlActingEmployee").html(html);
        },

        error: function (xhr) {
            console.log(xhr.responseText);
            Swal.fire("Error", "Unable to bind employee list.", "error");
        }
    });
}

function pm_bindDelegationGrid() {
    if ($.fn.DataTable.isDataTable("#tblPMDelegation")) {
        $("#tblPMDelegation").DataTable().clear().destroy();
    }

    pmDelegationTable = $("#tblPMDelegation").DataTable({
        serverSide: false,
        processing: true,
        searching: true,
        ordering: false,
        autoWidth: false,
        scrollX: true,
        pageLength: 35,
        lengthMenu: [[10, 25, 35, 50, 100], [10, 25, 35, 50, 100]],
        ajax: {
            type: "POST",
            url: "PMDelegationMaster.aspx/GetDelegations",
            data: "{}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            dataSrc: function (res) {
                return pm_parseResponse(res, []);
            }
        },
        columns: [
            {
                data: null,
                render: function (data, type, row) {
                    var edit = '<button type="button" class="btn btn-sm btn-primary" title="Edit" onclick="pm_editDelegation(this)"><i class="bi bi-pencil-square"></i></button>';
                    var del = ' <button type="button" class="btn btn-sm btn-danger" title="Deactivate" onclick="pm_deactivateDelegation(' + row.DelegationID + ')"><i class="bi bi-trash"></i></button>';
                    return edit + del;
                }
            },
            {
                data: null,
                render: function (data, type, row, meta) {
                    return meta.row + 1;
                }
            },
            { data: "PMCode" },
            { data: "PMName" },
            { data: "ActingCode" },
            { data: "ActingName" },
            { data: "FromDate" },
            { data: "ToDate" },
            { data: "Remark" },
            {
                data: "StatusText",
                render: function (data) {
                    if (data === "Active") {
                        return '<span class="status-active">Active</span>';
                    }
                    return '<span class="status-expired">' + data + '</span>';
                }
            },
            { data: "AddedByName" },
            { data: "AddedDate" }
        ]
    });
}

function pm_saveDelegation() {

    // var delegationId = parseInt($("#hdnDelegationID").val() || "0");
    var pmEmployeeId = parseInt($("#ddlPMEmployee").val() || "0");
    var actingEmployeeId = parseInt($("#ddlActingEmployee").val() || "0");
    var fromDate = $("#txtFromDate").val();
    var toDate = $("#txtToDate").val();
    var remark = $("#txtRemark").val().trim();


    if (pmEmployeeId <= 0) {
        Swal.fire("Validation", "Please select PM Name.", "warning");
        return;
    }

    if (actingEmployeeId <= 0) {
        Swal.fire("Validation", "Please select Acting PM Name.", "warning");
        return;
    }

    if (pmEmployeeId === actingEmployeeId) {
        Swal.fire("Validation", "PM and Acting PM cannot be same.", "warning");
        return;
    }

    if (!fromDate) {
        Swal.fire("Validation", "Please select From Date.", "warning");
        return;
    }

    if (!toDate) {
        Swal.fire("Validation", "Please select To Date.", "warning");
        return;
    }

    if (new Date(toDate) < new Date(fromDate)) {
        Swal.fire("Validation", "To Date cannot be less than From Date.", "warning");
        return;
    }

    // beforeSend: function () {
    //     Swal.fire({
    //         title: "Please wait",
    //         text: "Saving delegation...",
    //         allowOutsideClick: false,
    //         didOpen: function () {
    //             Swal.showLoading();
    //         }
    //     });
    // },

    $.ajax({
        type: "POST",
        url: "ResponsibilityDelegation.aspx/SaveDelegation",
        data: JSON.stringify({
            // DelegationID: delegationId,
            PMEmployeeID: pmEmployeeId,
            ActingEmployeeID: actingEmployeeId,
            FromDate: fromDate,
            ToDate: toDate,
            Remark: remark
        }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        success: function (res) {
            var data = pm_parseResponse(res, { Success: false, Message: "Something went wrong." });
            // Swal.close();

            if (data.Success) {
                Swal.fire("Success", data.Message, "success");
                pm_clearForm();
                pmDelegationTable.ajax.reload(null, false);
            } else {
                Swal.fire("Warning", data.Message, "warning");
            }
        },
        error: function () {
            Swal.close();
            Swal.fire("Error", "Unable to save delegation.", "error");
        }
    });
}

function pm_editDelegation(btn) {
    var rowData = pmDelegationTable.row($(btn).closest("tr")).data();

    if (!rowData) {
        rowData = pmDelegationTable.row($(btn).closest("tr").prev()).data();
    }

    if (!rowData) {
        Swal.fire("Error", "Unable to read selected row.", "error");
        return;
    }

    $("#hdnDelegationID").val(rowData.DelegationID);
    $("#ddlPMEmployee").val(rowData.PMEmployeeID);
    $("#ddlActingEmployee").val(rowData.ActingEmployeeID);
    $("#txtFromDate").val(rowData.FromDateValue);
    $("#txtToDate").val(rowData.ToDateValue);
    $("#txtRemark").val(rowData.Remark || "");

    $("html, body").animate({ scrollTop: 0 }, 300);
}

function pm_deactivateDelegation(delegationId) {
    Swal.fire({
        icon: "question",
        title: "Deactivate Delegation?",
        text: "This Acting PM responsibility will be stopped.",
        showCancelButton: true,
        confirmButtonText: "Yes, Deactivate",
        cancelButtonText: "Cancel"
    }).then(function (result) {
        if (!result.isConfirmed) {
            return;
        }

        $.ajax({
            type: "POST",
            url: "PMDelegationMaster.aspx/DeactivateDelegation",
            data: JSON.stringify({ DelegationID: delegationId }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (res) {
                var data = pm_parseResponse(res, { Success: false, Message: "Something went wrong." });

                if (data.Success) {
                    Swal.fire("Success", data.Message, "success");
                    pmDelegationTable.ajax.reload(null, false);
                } else {
                    Swal.fire("Warning", data.Message, "warning");
                }
            },
            error: function () {
                Swal.fire("Error", "Unable to deactivate delegation.", "error");
            }
        });
    });
}

function pm_clearForm() {
    $("#hdnDelegationID").val("0");
    $("#ddlPMEmployee").val("0");
    $("#ddlActingEmployee").val("0");
    $("#txtFromDate").val("");
    $("#txtToDate").val("");
    $("#txtRemark").val("");
}
