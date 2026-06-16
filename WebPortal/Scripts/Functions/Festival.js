var global_FestivalID = 0;

function festival_bindGrid() {

    $('#load1').show();

    $.ajax({
        url: "FestivalWishesMaster.aspx/GetFestivalMaster",
        type: "POST",
        contentType: "application/json",
        success: function (data) {

            var dataArray = JSON.parse(data.d);

            // Destroy old DataTable
            if ($.fn.DataTable.isDataTable('#table_festival')) {
                $('#table_festival').DataTable().clear().destroy();
            }

            $('#table_festival').DataTable({
                dom: 'lfrtip',
                data: dataArray,
                scrollX: false,
                paging: true,
                processing: true,
                ordering: false,
                serverSide: false,

                columns: [
                    {
                        data: "FestivalId",
                        className: "text-center",
                        render: function (data) {
                            return '<a title="Delete Record" class="dropdown-item" href="#!" id="Actions" onclick="festWish_delete(' + data + ');"><span style="color: dodgerblue; font-size:15px;"><i class="uil uil-trash-alt"></i></span></a>'
                        }
                    },
                    {
                        data: null,
                        render: function (data, type, row, meta) {
                            return meta.row + 1;
                        }
                    },

                    { data: "Title" },

                    //{
                    //    data: "Path1",
                    //    className: "text-center",
                    //    render: function (data) {

                    //        if (data == null || data == "") {
                    //            return "";
                    //        }

                    //        return '<img src="../FestivalWishesImages/' + data +
                    //            '" class="festivalImg" style="height:60px;width:60px;border-radius:6px;cursor:pointer;">';
                    //    }
                    //},

                    {
                        data: "Path1",
                        className: "text-center",
                        render: function (data, type, row) {

                            if (data == null || data == "") {
                                return "";
                            }

                            return '<img src="../FestivalWishesImages/' + data +
                                '" class="festivalImg" style="height:60px;width:60px;border-radius:6px;cursor:pointer;" onclick="showImage(\'' + data + '\', \'' + row.Title + '\')">';
                        }
                    },

                    { data: "OnDate" },
                    { data: "UploadedBy" },
                    { data: "UploadedDate" }
                ],

                //buttons: [
                //    {
                //        extend: 'excelHtml5',
                //        text: 'Export Excel',
                //        title: 'Festival Wishes'
                //    }
                //],

                initComplete: function () {
                    $('#load1').hide();
                }
            });

        },

        error: function (error) {
            $('#load1').hide();
            alert('Error: ' + error.responseText);
        }

    });
}

function coRe_festWish_SubmitData() {

    var title = $("#festWish_title").val();
    var date = $("#festWish_date").val();
    var gender = $("#festWish_gender").val();

    var fileInput = document.getElementById("festWish_attachment");

    if (fileInput.files.length === 0) {

        Swal.fire({
            icon: 'warning',
            title: 'File Required',
            text: 'Please select file.'
        });

        return false;
    }

    if (title == "") {

        Swal.fire({
            icon: 'warning',
            title: 'Title Required',
            text: 'Please select Title.'
        });

        return false;
    }

    if (date == "") {

        Swal.fire({
            icon: 'warning',
            title: 'Date Required',
            text: 'Please select Date.'
        });

        return false;
    }
    // Get Locations
    var locations = [];
    $(".location_checkbox:checked").each(function () {
        locations.push($(this).val());
    });

    // Get Departments
    var departments = [];
    $(".department_checkbox:checked").each(function () {
        departments.push($(this).val());
    });

    // Get Designations
    var designations = [];
    $(".designation_checkbox:checked").each(function () {
        designations.push($(this).val());
    });

    // Get Users
    var users = [];
    $(".user_checkbox:checked").each(function () {
        users.push($(this).val());
    });


    // ✅ Call PageMethod
    PageMethods.InsertFestiveData(title, date, locations.join(','), departments.join(','), designations.join(','), users.join(','), gender,

        function (response) {

            Swal.fire({
                icon: 'success',
                title: 'Success',
                text: response,
            }).then(function () {
                location.reload();
            });
        },

        function (error) {
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: error.get_message()
            });
        }
    );
}

function festWish_SubmitData() {

    var title = $("#festWish_title").val().trim();
    var date = $("#festWish_date").val().trim();
    var gender = $("#festWish_gender").val();

    var fileInput = document.getElementById("festWish_attachment");

    // Get Locations
    var locations = [];
    $(".location_checkbox:checked").each(function () {
        locations.push($(this).val());
    });

    // Get Departments
    var departments = [];
    $(".department_checkbox:checked").each(function () {
        departments.push($(this).val());
    });

    // Get Designations
    var designations = [];
    $(".designation_checkbox:checked").each(function () {
        designations.push($(this).val());
    });

    // Get Users
    var users = [];
    $(".user_checkbox:checked").each(function () {
        users.push($(this).val());
    });


    // Validation

    if (title == "") {

        Swal.fire({
            icon: 'warning',
            title: 'Title Required',
            text: 'Please enter title.'
        });

        $("#festWish_title").focus();
        return false;
    }

    if (date == "") {

        Swal.fire({
            icon: 'warning',
            title: 'Date Required',
            text: 'Please select date.'
        });

        $("#festWish_date").focus();
        return false;
    }

    if (gender == "" || gender == null || gender == "Select") {

        Swal.fire({
            icon: 'warning',
            title: 'Gender Required',
            text: 'Please select gender.'
        });

        $("#festWish_gender").focus();
        return false;
    }

    if (fileInput.files.length === 0) {

        Swal.fire({
            icon: 'warning',
            title: 'File Required',
            text: 'Please select attachment file.'
        });

        return false;
    }

    if (locations.length === 0) {

        Swal.fire({
            icon: 'warning',
            title: 'Location Required',
            text: 'Please select at least one location.'
        });

        return false;
    }

    if (departments.length === 0) {

        Swal.fire({
            icon: 'warning',
            title: 'Department Required',
            text: 'Please select at least one department.'
        });

        return false;
    }

    if (designations.length === 0) {

        Swal.fire({
            icon: 'warning',
            title: 'Designation Required',
            text: 'Please select at least one designation.'
        });

        return false;
    }

    if (users.length === 0) {

        Swal.fire({
            icon: 'warning',
            title: 'User Required',
            text: 'Please select at least one user.'
        });

        return false;
    }


    // Submit Data

    PageMethods.InsertFestiveData(
        title,
        date,
        locations.join(','),
        departments.join(','),
        designations.join(','),
        users.join(','),
        gender,

        function (response) {

            Swal.fire({
                icon: 'success',
                title: 'Success',
                text: response
            }).then(function () {

                location.reload();

            });
        },

        function (error) {

            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: error.get_message()
            });

        }
    );
}

function festWish_delete(id) {

    Swal.fire({
        title: 'Confirm Action',
        html: 'Are you sure you want to delete record?',
        icon: 'question',
        allowOutsideClick: false,
        showCancelButton: true,
        confirmButtonText: 'Yes',
        cancelButtonText: 'Cancel',
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33'
    }).then((result) => {

        if (result.isConfirmed) {

            PageMethods.DeleteFestivalImages(id,

                function (response) {

                    // success callback
                    Swal.fire({
                        icon: 'success',
                        title: 'Deleted!',
                        text: response
                    }).then(() => {

                        festival_bindGrid();

                    });

                },

                function (error) {

                    // error callback
                    Swal.fire({
                        icon: 'error',
                        title: 'Server Error',
                        text: error.get_message()
                    });

                }
            );
        }
    });

    return false;
}


function festWish_SubmitData_Core() {

    var title = $("#festWish_title").val();
    var date = $("#festWish_date").val().trim();

    // 🔴 Mandatory validation
    if (!title || title === "Select") {
        alert("Please select Title");
        return false;
    }

    if (!date || date === "") {
        alert("Please select date");
        return false;
    }

    // ✅ PageMethod Call
    PageMethods.InsertFestiveData(title, date,
        function (response) {
            alert(response);
            $("#festWish_date").val("");
            $("#festWish_title").val("Select");

            festival_bindGrid();
        },
        function (error) {
            alert("Error: " + error.get_message());

        }
    );

    return false; // prevent postback
}


//function showImage(imagePath, title) {

//    $("#previewImage").attr("src", "../FestivalWishesImages/" + imagePath);

//    $("#festivalTitle").text(title);   // set title in <h5>

//    $("#imagePreviewModal").modal("show");
//}

$(document).on("click", ".festivalImg", function () {

    var imgSrc = $(this).attr("src");
    var title = $(this).data("Title");

    $("#festivalTitle").text("Preview");

    $("#previewImage").attr("src", imgSrc);
    $("#imagePreviewModal").modal("show");
});


/*--- Location ---*/
function festWish_bindlocation() {

    $("#locationList").html("");

    $.ajax({
        type: "POST",
        url: "CreateProfile.aspx/GetBranches",
        dataType: "json",
        contentType: "application/json",

        success: function (res) {

            $.each(res.d, function (i, value) {

                //var checkbox = `
                //<label style="display:block;">
                //    <input type="checkbox" class="location_checkbox" value="${value.BranchID}">
                //    ${value.BranchName}
                //</label>`;

                var checkbox = `
<label>
<input type="checkbox" class="location_checkbox" value="${value.BranchID}">
<span>${value.BranchName}</span>
</label>`;

                $("#locationList").append(checkbox);

            });
        }
    });
}

$(document).on("change", "#select_all_location", function () {

    if ($(this).is(":checked")) {
        $(".location_checkbox").prop("checked", true);
    } else {
        $(".location_checkbox").prop("checked", false);
    }

    updateLocationText();
});

$(document).on("change", ".location_checkbox", function () {

    var total = $(".location_checkbox").length;
    var checked = $(".location_checkbox:checked").length;

    if (total == checked) {
        $("#select_all_location").prop("checked", true);
    } else {
        $("#select_all_location").prop("checked", false);
    }

    updateLocationText();
});

function updateLocationText() {

    var total = $(".location_checkbox").length;
    var checked = $(".location_checkbox:checked").length;

    if (checked == 0) {
        $("#locationDropdownBtn").text("Select Location");
    }
    else if (checked == total) {
        $("#locationDropdownBtn").text("All Selected");
    }
    else {
        $("#locationDropdownBtn").text(checked + " Selected");
    }

}


/*--- Department ---*/
function festWish_bindDepartment() {

    $("#departmentList").html("");

    $.ajax({
        type: "POST",
        url: "CreateProfile.aspx/GetDepartment",
        dataType: "json",
        contentType: "application/json",

        success: function (res) {

            $.each(res.d, function (i, value) {

                var checkbox = `
                <label>
                    <input type="checkbox" class="department_checkbox" value="${value.DepartmentID}">
                    <span>${value.DepartmentName}</span>
                </label>`;

                $("#departmentList").append(checkbox);

            });

        }
    });
}

$(document).on("change", "#select_all_department", function () {

    $(".department_checkbox").prop("checked", this.checked);

    updateDepartmentText();

});

$(document).on("change", ".department_checkbox", function () {

    var total = $(".department_checkbox").length;
    var checked = $(".department_checkbox:checked").length;

    $("#select_all_department").prop("checked", total === checked);

    updateDepartmentText();

});

function updateDepartmentText() {

    var total = $(".department_checkbox").length;
    var checked = $(".department_checkbox:checked").length;

    if (checked == 0) {
        $("#departmentDropdownBtn").text("Select Department");
    }
    else if (checked == total) {
        $("#departmentDropdownBtn").text("All Selected");
    }
    else {
        $("#departmentDropdownBtn").text(checked + " Selected");
    }

}


/*--- Designation ---*/
function festWish_bindDesignation() {

    $("#designationList").html("");

    $.ajax({
        type: "POST",
        url: "CreateProfile.aspx/GetDesignation",
        dataType: "json",
        contentType: "application/json",

        success: function (res) {

            $.each(res.d, function (i, value) {

                var checkbox = `
                <label>
                    <input type="checkbox" class="designation_checkbox" value="${value.DesignationID}">
                    <span>${value.DesignationName}</span>
                </label>`;

                $("#designationList").append(checkbox);

            });

        }
    });

}

$(document).on("change", "#select_all_designation", function () {

    $(".designation_checkbox").prop("checked", this.checked);

    updateDesignationText();

});

$(document).on("change", ".designation_checkbox", function () {

    var total = $(".designation_checkbox").length;
    var checked = $(".designation_checkbox:checked").length;

    $("#select_all_designation").prop("checked", total === checked);

    updateDesignationText();

});

function updateDesignationText() {

    var total = $(".designation_checkbox").length;
    var checked = $(".designation_checkbox:checked").length;

    if (checked == 0) {
        $("#designationDropdownBtn").text("Select Designation");
    }
    else if (checked == total) {
        $("#designationDropdownBtn").text("All Selected");
    }
    else {
        $("#designationDropdownBtn").text(checked + " Selected");
    }

}


/*--- Users ---*/
function festWish_bindEmployee() {


    $("#userList").html("");

    $.ajax({
        type: "POST",
        url: "RoamingBranch.aspx/GetCodes",
        dataType: "json",
        contentType: "application/json",

        success: function (res) {

            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (i, value) {

                var checkbox = `
                <label>
                    <input type="checkbox" class="user_checkbox" value="${value.EmployeeID}">
                    <span>${value.FullName}</span>
                </label>`;

                $("#userList").append(checkbox);
            });
        }
    });
}

$(document).on("change", "#select_all_user", function () {

    $(".user_checkbox").prop("checked", this.checked);

    updateUserText();

});

$(document).on("change", ".user_checkbox", function () {

    var total = $(".user_checkbox").length;
    var checked = $(".user_checkbox:checked").length;

    $("#select_all_user").prop("checked", total === checked);

    updateUserText();

});

function updateUserText() {

    var total = $(".user_checkbox").length;
    var checked = $(".user_checkbox:checked").length;

    if (checked == 0) {
        $("#userDropdownBtn").text("Select Employee");
    }
    else if (checked == total) {
        $("#userDropdownBtn").text("All Selected");
    }
    else {
        $("#userDropdownBtn").text(checked + " Selected");
    }

}

function getSelected_Locations() {

    var locations = [];

    $(".location_checkbox:checked").each(function () {
        locations.push($(this).val());
    });

    //console.log(locations); // Selected BranchIDs
}

function getSelected_department() {

    var departments = [];

    $(".department_checkbox:checked").each(function () {
        departments.push($(this).val());
    });
}

function getSelected_designations() {

    var designations = [];

    $(".designation_checkbox:checked").each(function () {
        designations.push($(this).val());
    });
}

function getSelected_Employees() {

    var employees = [];

    $(".employee_checkbox:checked").each(function () {
        employees.push($(this).val());
    });

    console.log(employees); // Selected Employee Codes

}


async function exportExcelWithImage() {

    var workbook = new ExcelJS.Workbook();
    var worksheet = workbook.addWorksheet("Festival Data");

    worksheet.columns = [
        { header: "ID", key: "id", width: 10 },
        { header: "Festival Name", key: "festival", width: 25 },
        { header: "Image", key: "image", width: 30 }
    ];

    var table = $('#table_festival').DataTable().rows().data();

    for (var i = 0; i < table.length; i++) {

        var row = worksheet.addRow({
            id: table[i].FestivalID,
            festival: table[i].FestivalName
        });

        var imageUrl = table[i].ImagePath;

        const image = await fetch(imageUrl)
            .then(res => res.blob())
            .then(blob => {
                return new Promise(resolve => {
                    const reader = new FileReader();
                    reader.onload = () => resolve(reader.result);
                    reader.readAsArrayBuffer(blob);
                });
            });

        const imageId = workbook.addImage({
            buffer: image,
            extension: 'png'
        });

        worksheet.addImage(imageId, {
            tl: { col: 2, row: row.number - 1 },
            ext: { width: 80, height: 80 }
        });

        worksheet.getRow(row.number).height = 60;
    }

    const buffer = await workbook.xlsx.writeBuffer();
    saveAs(new Blob([buffer]), "FestivalMaster.xlsx");
} 