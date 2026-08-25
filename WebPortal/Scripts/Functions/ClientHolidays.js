

/*------- Holidays --------*/

function cl_bindHoliday() {

    $.ajax({
        type: "POST",
        url: "ClientHolidayMaster.aspx/GetHolidayList",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {

            var ddl = $("#choliday_desc");
            ddl.empty();

            ddl.append($("<option></option>").val("Select").text("Select Holidays"));

            var data = JSON.parse(response.d);

            $.each(data, function (i, item) {
                ddl.append($("<option></option>").val(item.HolidayName).text(item.HolidayName));
            });
        },
        error: function (xhr, status, error) {
            console.log(error);
            alert("Unable to load holiday list.");
        }
    });
}


/*------- Location --------*/

function choliday_bindlocation() {

    $("#choliday_locationlist").html("");

    $.ajax({
        type: "POST",
        url: "CreateProfile.aspx/GetBranches",
        dataType: "json",
        contentType: "application/json",

        success: function (res) {

            $.each(res.d, function (i, value) {
                var checkbox = `
                        <label>
                        <input type="checkbox" class="choliday_location_checkbox" value="${value.BranchID}">
                        <span>${value.BranchName}</span>
                        </label>`;

                $("#choliday_locationlist").append(checkbox);
            });
        }
    });
}

$(document).on("change", "#choliday_select_all_location", function () {

    if ($(this).is(":checked")) {
        $(".choliday_location_checkbox").prop("checked", true);
    } else {
        $(".choliday_location_checkbox").prop("checked", false);
    }

    choliday_updateLocationText();
});

$(document).on("change", ".choliday_location_checkbox", function () {

    var total = $(".choliday_location_checkbox").length;
    var checked = $(".choliday_location_checkbox:checked").length;

    if (total == checked) {
        $("#choliday_select_all_location").prop("checked", true);
    } else {
        $("#choliday_select_all_location").prop("checked", false);
    }

    choliday_updateLocationText();
});

function choliday_updateLocationText() {

    var total = $(".choliday_location_checkbox").length;
    var checked = $(".choliday_location_checkbox:checked").length;

    if (checked == 0) {
        $("#choliday_location_drpbtn").text("Select Location");
    }
    else if (checked == total) {
        $("#choliday_location_drpbtn").text("All Selected");
    }
    else {
        $("#choliday_location_drpbtn").text(checked + " Selected");
    }

}


/*------- Domain --------*/
function choliday_binddomain() {

    $("#choliday_domainlist").html("");

    $.ajax({
        type: "POST",
        url: "CreateProfile.aspx/GetAllDomains",
        dataType: "json",
        contentType: "application/json",

        success: function (res) {

            $.each(res.d, function (i, value) {
                var checkbox = `
                        <label>
                        <input type="checkbox" class="choliday_domain_checkbox" value="${value.DomainID}">
                        <span>${value.DomainName}</span>
                        </label>`;

                $("#choliday_domainlist").append(checkbox);

            });
        }
    });
}

$(document).on("change", "#choliday_select_all_domain", function () {

    if ($(this).is(":checked")) {
        $(".choliday_domain_checkbox").prop("checked", true);
    } else {
        $(".choliday_domain_checkbox").prop("checked", false);
    }

    choliday_updateDomainText();
});

$(document).on("change", ".choliday_domain_checkbox", function () {

    var total = $(".choliday_domain_checkbox").length;
    var checked = $(".choliday_domain_checkbox:checked").length;

    if (total == checked) {
        $("#choliday_select_all_domain").prop("checked", true);
    } else {
        $("#choliday_select_all_domain").prop("checked", false);
    }

    choliday_updateDomainText();
});

function choliday_updateDomainText() {

    var total = $(".choliday_domain_checkbox").length;
    var checked = $(".choliday_domain_checkbox:checked").length;

    if (checked == 0) {
        $("#choliday_domain_drpbtn").text("Select Location");
    }
    else if (checked == total) {
        $("#choliday_domain_drpbtn").text("All Selected");
    }
    else {
        $("#choliday_domain_drpbtn").text(checked + " Selected");
    }

}

/*--- Department ---*/
function choliday_bindDepartment() {

    $("#choliday_departmentlist").html("");

    $.ajax({
        type: "POST",
        url: "CreateProfile.aspx/GetDepartment",
        dataType: "json",
        contentType: "application/json",

        success: function (res) {

            $.each(res.d, function (i, value) {

                var checkbox = `
                <label>
                    <input type="checkbox" class="choliday_department_checkbox" value="${value.DepartmentID}">
                    <span>${value.DepartmentName}</span>
                </label>`;

                $("#choliday_departmentlist").append(checkbox);

            });

        }
    });
}

$(document).on("change", "#choliday_select_all_department", function () {

    $(".choliday_department_checkbox").prop("checked", this.checked);

    choliday_updateDepartmentText();

});

$(document).on("change", ".choliday_department_checkbox", function () {

    var total = $(".choliday_department_checkbox").length;
    var checked = $(".choliday_department_checkbox:checked").length;

    $("#choliday_select_all_department").prop("checked", total === checked);

    choliday_updateDepartmentText();

});

function choliday_updateDepartmentText() {

    var total = $(".choliday_department_checkbox").length;
    var checked = $(".choliday_department_checkbox:checked").length;

    if (checked == 0) {
        $("#choliday_department_drpbtn").text("Select Department");
    }
    else if (checked == total) {
        $("#choliday_department_drpbtn").text("All Selected");
    }
    else {
        $("#choliday_department_drpbtn").text(checked + " Selected");
    }

}

/*--- Shift ---*/
function choliday_bindShift() {

    $("#choliday_shiftlist").html("");
    var checkbox = `
                <label>
                    <input type="checkbox" class="choliday_shift_checkbox" value="Day">
                    <span>Day</span>
                </label>`;

    $("#choliday_shiftlist").append(checkbox);

    checkbox = '';
    checkbox = `
                <label>
                    <input type="checkbox" class="choliday_shift_checkbox" value="Night">
                    <span>Night</span>
                </label>`;

    $("#choliday_shiftlist").append(checkbox);

}

$(document).on("change", "#choliday_select_all_shift", function () {

    $(".choliday_shift_checkbox").prop("checked", this.checked);

    choliday_updateShiftText();

});

$(document).on("change", ".choliday_shift_checkbox", function () {

    var total = $(".choliday_shift_checkbox").length;
    var checked = $(".choliday_shift_checkbox:checked").length;

    $("#choliday_select_all_shift").prop("checked", total === checked);

    choliday_updateShiftText();

});

function choliday_updateShiftText() {

    var total = $(".choliday_shift_checkbox").length;
    var checked = $(".choliday_shift_checkbox:checked").length;

    if (checked == 0) {
        $("#choliday_shift_drpbtn").text("Select Shift");
    }
    else if (checked == total) {
        $("#choliday_shift_drpbtn").text("All Selected");
    }
    else {
        $("#choliday_shift_drpbtn").text(checked + " Selected");
    }

}



/*-------- For Submit  --------*/

function choliday_InsertHoliday() {

    // alert($("#choliday_date").val());

    const requestData = {
        EmpIDs: choliday_getSelectedEmployees() || [],
        Date: $("#choliday_date").val(),
        Remark: $.trim($$("#choliday_desc").val())
    };

    // alert(EmpIDs);
    // alert(requestData.Date);

    if (requestData.EmpIDs.length === 0) {
        Swal.fire({
            icon: "warning",
            title: "Validation",
            text: "Please select at least one employee."
        });
        return false;
    }

    // alert(requestData.EmpIDs.lengt);

    if (!requestData.Date) {
        Swal.fire({
            icon: "warning",
            title: "Validation",
            text: "Please select holiday date."
        });
        return false;
    }

    // alert(requestData.Date);


    $.ajax({
        type: "POST",
        url: "ClientHolidayMaster.aspx/SaveHolidayData",
        data: JSON.stringify(requestData),
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        beforeSend: function () {

            $("#choliday_btnapplyHoliday").prop("disabled", true);

            Swal.fire({
                title: "Please Wait...",
                text: "Applying holiday for selected employees...",
                allowOutsideClick: false,
                allowEscapeKey: false,
                showConfirmButton: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });
        },

        success: function (res) {

            Swal.fire({
                icon: "success",
                title: "Success",
                text: "Holiday applied successfully."
            });

            choliday_clearFields();
        },

        error: function (xhr) {

            console.log(xhr.responseText);

            Swal.fire({
                icon: "error",
                title: "Error",
                text: "Failed to apply holiday."
            });
        },

        complete: function () {

            $("#choliday_btnapplyHoliday").prop("disabled", false);

            // Close loading popup if still open
            if (Swal.isLoading()) {
                Swal.close();
            }
        }
    });

    return false;
}


/*------- Supportive Methods --------*/

function getSelectedValues(className) {
    var selected = [];

    $("." + className + ":checked").each(function () {
        selected.push($(this).val());
    });

    return selected;
}

$(document).on("change", "#chkSelectAll", function () {
    $("#choliday_table tbody input[type='checkbox']")
        .prop("checked", this.checked);
});

$(document).on("change", "#choliday_table tbody input[type='checkbox']", function () {
    if (!this.checked) {
        $("#chkSelectAll").prop("checked", false);
    } else {
        var total = $("#choliday_table tbody input[type='checkbox']").length;
        var checked = $("#choliday_table tbody input[type='checkbox']:checked").length;

        if (total === checked) {
            $("#chkSelectAll").prop("checked", true);
        }
    }
});

function getSelectedEmployees() {
    var ids = [];

    $("#choliday_table tbody input[type='checkbox']:checked").each(function () {
        var row = $(this).closest("tr");
        var id = row.find("td:eq(1)").text();
        ids.push(id);
    });

    return ids.join(",");
}

function choliday_getSelectedEmployees() {
    var empIds = [];

    $(".chkItem:checked").each(function () {
        empIds.push($(this).val());
    });
      
        return empIds;
}

function choliday_getuserslist() {

    var holiday = $("#choliday_desc").val();

    if (holiday === "Select") {

        Swal.fire({ icon: 'warning', title: 'Validation', text: 'Please select Holiday For.' });
        return false;
    }

    const filters = {
        domainIds: getSelectedValues("choliday_domain_checkbox"),
        locationIds: getSelectedValues("choliday_location_checkbox"),
        departmentIds: getSelectedValues("choliday_department_checkbox"),
        shiftIds: getSelectedValues("choliday_shift_checkbox")
    };

    const validations = [
        { key: "domainIds", message: "Please select at least one domain" },
        { key: "locationIds", message: "Please select at least one location" },
        { key: "departmentIds", message: "Please select at least one department" },
        { key: "shiftIds", message: "Please select at least one shift" }
    ];

    for (const item of validations) {
        if (filters[item.key].length === 0) {
            Swal.fire("Validation", item.message, "warning");
            return false;
        }
    }

    $.ajax({
        type: "POST",
        url: "ClientHolidayMaster.aspx/GetUsersByFilters",
        data: JSON.stringify(filters),
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        beforeSend: function () {
            $("#choliday_btngetUsers").prop("disabled", true);

            Swal.fire({
                title: "Please wait...",
                text: "Loading user list...",
                allowOutsideClick: false,
                allowEscapeKey: false,
                showConfirmButton: false,
                didOpen: function () {
                    Swal.showLoading();
                }
            });
        },

        success: function (res) {
            const data = res.d || [];
            const $tbody = $("#choliday_table tbody");

            $("#choliday_btnInsertHoliday").toggle(data.length === 0);

            $tbody.empty();

            const rows = data.map(function (item, i) {
                return `
                    <tr>
                        <td class="text-center">
                            <input type="checkbox" class="chkItem" value="${item.EmployeeID}" />
                        </td>
                        <td style="display:none;">${item.EmployeeID}</td>
                        <td class="text-center">${i + 1}</td>
                        <td class="text-center">${item.Code || ""}</td>
                        <td>${item.EmployeeName || ""}</td>
                        <td class="text-center">${item.Domain || ""}</td>
                        <td class="text-center">${item.Branch || ""}</td>
                        <td class="text-center">${item.Department || ""}</td>
                        <td class="text-center">${item.Shift || ""}</td>
                        <td class="text-center">${item.CutOffTime || ""}</td>
                    </tr>`;
            }).join("");

            $tbody.html(rows);
        },

        error: function (xhr) {
            console.log(xhr);

            Swal.fire({
                icon: "error",
                title: "Error",
                text: "Something went wrong while loading users."
            });
        },

        complete: function () {
            $("#choliday_btngetUsers").prop("disabled", false);

            if (Swal.isLoading()) {
                Swal.close();
            }
        }
    });

    return false;
}

function choliday_clearFields() {

    // Clear inputs
    $("#choliday_date").val('');
    $("#choliday_desc")[0].selectedIndex = 0;

    // Reset dropdown button text
    $("#choliday_domain_drpbtn").html("Select Domain");
    $("#choliday_location_drpbtn").html("Select Location");
    $("#choliday_department_drpbtn").html("Select Department");
    $("#choliday_shift_drpbtn").html("Select Shift");

    // Uncheck Select All
    $("#choliday_select_all_domain").prop("checked", false);
    $("#choliday_select_all_location").prop("checked", false);
    $("#choliday_select_all_department").prop("checked", false);
    $("#choliday_select_all_shift").prop("checked", false);

    // Uncheck all dropdown checkboxes
    $("#choliday_domainlist input[type=checkbox]").prop("checked", false);
    $("#choliday_locationlist input[type=checkbox]").prop("checked", false);
    $("#choliday_departmentlist input[type=checkbox]").prop("checked", false);
    $("#choliday_shiftlist input[type=checkbox]").prop("checked", false);

    // Clear users table
    $("#choliday_table tbody").empty();

    // Uncheck table select all
    $("#chkSelectAll").prop("checked", false);
}

function saveSelectedEmployees() {

    var selectedIds = getSelectedEmployees();

    if (selectedIds.length == 0) {
        alert("Please select at least one employee");
        return;
    }

    $.ajax({
        type: "POST",
        url: "CreateProfile.aspx/SaveSelectedEmployees",
        data: JSON.stringify({ empIds: selectedIds }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            alert("Saved successfully");
        },
        error: function () {
            alert("Error while saving");
        }
    });
}