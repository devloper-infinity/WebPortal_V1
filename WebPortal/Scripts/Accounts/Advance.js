var advancelist = null;

function BindYears() {
    var currentYear = new Date().getFullYear();

    $("#adv_Year").empty();

    $("#adv_Year").append($("<option></option>").val("Select").html("Select"));


    for (var i = currentYear; i >= currentYear - 5; i--) {
        $("#adv_Year").append(
            '<option value="' + i + '">' + i + '</option>'
        );
    }
}

function BindUsers() {
    $.ajax({
        type: "POST",
        url: "BonusMaster.aspx/GetAllUsers",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {

            $("#adv_employee").empty();
            $("#adv_employee").append('<option value="Select">Select</option>');

            var dataArray = JSON.parse(response.d);

            $.each(dataArray, function (data, value) {

                $("#adv_employee").append($("<option></option>").val(value.Code).html(value.FullName));

            });
        }
    });
}

function adv_getSalary(emp) {

    var code = $(emp).val();

    if (code == "") {
        $("#adv_Salary").val("");
        return;
    }

    $.ajax({
        type: "POST",
        url: "IncrementReport.aspx/GetUserInfo",
        data: JSON.stringify({ Code: code }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        success: function (response) {

            var dataArray = JSON.parse(response.d);

            $.each(dataArray, function (data, value) {

                // alert(message);

                $("#adv_Salary").val(value.Salary);
            })
        },

        error: function () {
            alert("Unable to get employee salary.");
        }
    });
}


function GetAllAdvanceEntries() {

    $('#load1').show();

    $.ajax({
        url: "AdvanceMaster.aspx/GetAllAdvanceEntries",
        type: "POST",
        data: "{}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (response) {

            var dataArray = [];

            try {
                dataArray = JSON.parse(response.d || "[]");
            } catch (e) {
                dataArray = response.d || [];
            }

            if ($.fn.DataTable.isDataTable('#adv_tblAdvance')) {
                $('#adv_tblAdvance').DataTable().clear().destroy();
            }

            advancelist = $('#adv_tblAdvance').DataTable({
                data: dataArray,
                dom: 'Bftip',
                scrollX: true,
                paging: true,
                autoWidth: false,
                ordering: false,
                processing: true,

                columns: [
                    {
                        data: "AdvanceId",
                        width: "140px",
                        className: "text-center",
                        render: function (data) {
                            return `
            <button type="button" class="btn btn-sm btn-outline-primary adv-edit-btn me-1" data-id="${data}">
                <i class="uil uil-pen"></i>
            </button>

            <button type="button" class="btn btn-sm btn-success adv-save-btn me-1 d-none" data-id="${data}">
                <i class="uil uil-check"></i>
            </button>

            <button type="button" class="btn btn-sm btn-danger adv-cancel-btn me-1 d-none" data-id="${data}">
                <i class="uil uil-times"></i>
            </button>

            <button type="button" class="btn btn-sm btn-outline-danger adv-delete-btn" data-id="${data}">
                <i class="uil uil-trash"></i>
            </button>
        `;
                        }
                    },
                    {
                        data: null,
                        className: "text-center",
                        render: function (data, type, row, meta) {
                            return meta.row + 1;
                        }
                    },
                    { data: "Code", render: blankForNull },
                    { data: "FullName", render: blankForNull },
                    { data: "Month", render: blankForNull },
                    { data: "Year", render: blankForNull },
                    { data: "AdvanceAmount", render: blankForNull },

                    {
                        data: "installment",
                        className: "adv-installment",
                        render: blankForNull
                    },
                    {
                        data: "Balance",
                        render: blankForNull
                    },
                    {
                        data: "Remark",
                        className: "adv-remark",
                        render: blankForNull
                    },
                    { data: "Status", render: blankForNull },
                    { data: "AddedBy", render: blankForNull },
                    {
                        data: "AddedDate",
                        render: function (data) {
                            return formatAspDate(data);
                        }
                    }
                ],

                buttons: [
                    {
                        extend: 'excelHtml5',
                        title: 'Advance Entries',
                        exportOptions: {
                            columns: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
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
            swal("Error", "Error loading advance entries.", "error");
        }
    });
}


$(document).on("click", ".adv-edit-btn", function () {

    var row = $(this).closest("tr");

    var installmentCell = row.find(".adv-installment");
    var remarkCell = row.find(".adv-remark");

    installmentCell.attr("data-old", installmentCell.text().trim());
    remarkCell.attr("data-old", remarkCell.text().trim());

    installmentCell.html(
        '<input type="text" class="form-control form-control-sm adv-installment-input" value="' +
        installmentCell.text().trim() + '" />'
    );

    remarkCell.html(
        '<input type="text" class="form-control form-control-sm adv-remark-input" value="' +
        remarkCell.text().trim() + '" />'
    );

    row.find(".adv-edit-btn").addClass("d-none");
    row.find(".adv-save-btn, .adv-cancel-btn").removeClass("d-none");
});

$(document).on("click", ".adv-cancel-btn", function () {

    var row = $(this).closest("tr");

    var installmentCell = row.find(".adv-installment");
    var remarkCell = row.find(".adv-remark");

    installmentCell.html(installmentCell.attr("data-old"));
    remarkCell.html(remarkCell.attr("data-old"));

    row.find(".adv-save-btn, .adv-cancel-btn").addClass("d-none");
    row.find(".adv-edit-btn").removeClass("d-none");
});

$(document).on("click", ".adv-save-btn", function () {

    var advanceId = $(this).data("id");
    var row = $(this).closest("tr");

    var installmentCell = row.find(".adv-installment");
    var remarkCell = row.find(".adv-remark");

    var installment = row.find(".adv-installment-input").val().trim();
    var remark = row.find(".adv-remark-input").val().trim();

    if (installment === "" || isNaN(installment) || parseFloat(installment) < 0) {
        Swal.fire({
            icon: 'warning',
            title: 'Validation',
            text: 'Please enter valid installment.'
        });
        return;
    }

    var originalInstallment = (installmentCell.attr("data-old") || "").trim();
    var originalRemark = (remarkCell.attr("data-old") || "").trim();

    if (installment === originalInstallment && remark === originalRemark) {
        Swal.fire({
            icon: 'info',
            title: 'No Changes',
            text: 'Installment and Remark are unchanged.'
        });
        return;
    }

    $.ajax({
        url: "AdvanceMaster.aspx/UpdateAdvance",
        type: "POST",
        data: JSON.stringify({
            AdvanceID: parseInt(advanceId),
            Installment: parseFloat(installment),
            Remark: remark
        }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (response) {
            if (parseInt(response.d) > 0) {
                Swal.fire({
                    icon: 'success',
                    title: 'Updated',
                    text: 'Advance updated successfully'
                }).then(function () {
                    GetAllAdvanceEntries();
                });
            } else {
                Swal.fire({
                    icon: 'warning',
                    title: 'Not Updated'
                });
            }
        },

        error: function (xhr) {
            console.error(xhr.responseText);

            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'Update failed!'
            });
        }
    });
});

// $(document).on("click", ".adv-save-btn", function () {

//     var advanceId = $(this).data("id");
//     var row = $(this).closest("tr");

//     var installment = row.find(".adv-installment-input").val();
//     var remark = row.find(".adv-remark-input").val();

//     if (installment === "" || isNaN(installment) || parseFloat(installment) < 0) {
//         swal("Validation", "Please enter valid installment.", "warning");
//         return;
//     }


//     // const rowData = table.row($row).data();
//     // const original = $row.data('original');


//     // ❌ no change check
//     var originalInstallment = installmentCell.attr("data-old") || "";
//     var originalRemark = remarkCell.attr("data-old") || "";

//     if (installment === originalInstallment && remark === originalRemark) {
//         Swal.fire({
//             icon: 'info',
//             title: 'No Changes',
//             text: 'Installment and Remark are unchanged.'
//         });

//         return;
//     }

//     $.ajax({
//         url: "AdvanceMaster.aspx/UpdateAdvance",
//         type: "POST",
//         data: JSON.stringify({
//             AdvanceID: parseInt(advanceId),
//             Installment: parseFloat(installment),
//             Remark: remark
//         }),
//         dataType: "json",
//         contentType: "application/json; charset=utf-8",

//         success: function (response) {
//             if (response.d > 0) {

//                 alert(response.d);

//                 Swal.fire({
//                     icon: 'success',
//                     title: 'Updated',
//                     text: 'Advance updated successfully'
//                 }).then(function () {

//                     GetAllAdvanceEntries();


//                 });

//             } else {
//                 Swal.fire({
//                     icon: 'warning',
//                     title: 'Not Updated'
//                 });
//             }
//         },

//         error: function (xhr) {
//             console.error(xhr.responseText);

//             Swal.fire({
//                 icon: 'error',
//                 title: 'Error',
//                 text: 'Update failed!'
//             });
//         }
//     });
// });

$(document).on("click", ".adv-delete-btn", function () {

    var advanceId = $(this).data("id");

    var row = $(this).closest("tr");

    var rowData = advancelist.row(row).data();

    var code = rowData.Code;
    var fullName = rowData.FullName;

    Swal.fire({
        title: "Are you sure?",
        html:
            "<b>Code :</b> " + code + "<br>" +
            "<b>Name :</b> " + fullName + "<br><br>" +
            "Do you want to delete this advance entry?",
        icon: "warning",
        showCancelButton: true,
        allowOutsideClick: false,
        confirmButtonColor: "#d33",
        cancelButtonColor: "#3085d6",
        confirmButtonText: "Yes, Delete"
    }).then(function (result) {
        if (result.isConfirmed) {
            DeleteAdvance(advanceId);
        }
    });
});

function DeleteAdvance(advanceId) {

    $('#load1').show();

    $.ajax({
        url: "AdvanceMaster.aspx/DeleteAdvance",
        type: "POST",
        data: JSON.stringify({
            AdvanceID: parseInt(advanceId)
        }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (response) {

            $('#load1').hide();

            if (response.d > 0) {
                Swal.fire("Deleted!", "Advance entry deleted successfully.", "success");
                GetAllAdvanceEntries();
            }
            else {
                Swal.fire("Error", response.d, "error");
            }
        },

        error: function (xhr) {
            $('#load1').hide();
            console.error(xhr.responseText);
            Swal.fire("Error", "Unable to delete advance entry.", "error");
        }
    });
}


function blankForNull(data) {
    return data === null || data === undefined ? "" : data;
}

function formatAspDate(data) {
    if (!data) return "";

    var match = data.toString().match(/\d+/);
    if (match) {
        return new Date(parseInt(match[0])).toLocaleDateString("en-GB");
    }

    return data;
}

function InsertAdvance() {

    var code = $("#adv_employee").val();
    var month = $("#adv_Month").val();
    var year = $("#adv_Year").val();
    var salary = $("#adv_Salary").val();
    var amount = $("#adv_Amount").val();
    var installment = $("#adv_Installment").val();
    var doNotDeduct = $("#adv_chkDoNotDeduct").is(":checked");
    var remark = $("#adv_Remark").val();

    if (installment > amount) {
        Swal.fire({
            icon: 'warning',
            title: 'Validation',
            text: 'Advance Amount must be greater than Installment Amount.'
        });

        $("#adv_Installment").focus();
        return;
    }

    if (code === "Select" || code === null) {
        Swal.fire("Validation", "Please select employee.", "warning");
        return;
    }

    if (month === "Select" || month === null) {
        Swal.fire("Validation", "Please select month.", "warning");
        return;
    }

    if (year === "Select" || year === null) {
        Swal.fire("Validation", "Please select year.", "warning");
        return;
    }

    if (salary === "" || isNaN(salary)) {
        Swal.fire("Validation", "Salary is not available.", "warning");
        return;
    }

    if (amount === "" || isNaN(amount) || parseFloat(amount) <= 0) {
        Swal.fire("Validation", "Please enter valid amount.", "warning");
        return;
    }

    if (installment === "" || isNaN(installment) || parseFloat(installment) <= 0) {
        Swal.fire("Validation", "Please enter valid installment.", "warning");
        return;
    }


    if (remark === "" || remark === null) {
        Swal.fire("Validation", "Please select remark.", "warning");
        return;
    }

    $.ajax({
        type: "POST",
        url: "AdvanceMaster.aspx/InsertAdvance",
        data: JSON.stringify({
            Code: code,
            Month: month,
            Year: year,
            AdvanceAmt: amount,
            Installment: installment,
            Remark: remark,
            DoNotDeduct: doNotDeduct,
        }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {

            if (response.d > 0) {
                swal.fire("Success", "Advance saved successfully.", "success");

                ClearForm();
                GetAllAdvanceEntries();
            }
            else {
                swal.fire("Error", response.d, "error");
            }
        },
        error: function () {
            swal.fire("Error", "Error while saving advance entry.", "error");
        }
    });
}


function ClearForm() {
    $("#adv_employee").prop("selectedIndex", 0);
    $("#adv_Year").prop("selectedIndex", 0);
    $("#adv_Month").prop("selectedIndex", 0);
    $("#adv_Salary").val("");
    $("#adv_Amount").val("");
    $("#adv_Installment").val("");
    $("#adv_chkDoNotDeduct").prop("checked", false);
    $("#adv_Remark").val("");
}