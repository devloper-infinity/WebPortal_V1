//Submit Activity Category
function ExpensesActivityCategorySubmit() {
    var AdminExp_ActivityCategory = $("#AdminExp_ActivityCategory").val();
    var activityId = $('#hdnActivityCategoryId').val(); 
    if (AdminExp_ActivityCategory === "") {
        Swal.fire("Validation", "Please Add Activity Category", "warning");
        return false;
    }
    $("#load1").show();

    var formData = {
        AdminExp_ActivityCategory: AdminExp_ActivityCategory,
        ActivityCategoryId: activityId,
    };

    $.ajax({
        type: "POST",
        url: "ExpensesAdmin.aspx/SaveExpenseActivityCategory",
        data: JSON.stringify(formData),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var serverMessage = response.d;
            if (serverMessage === "Activity Category saved successfully!" || serverMessage === "Activity Category updated successfully!") {
                Swal.fire("Success", serverMessage, "success").then((result) => {
                    if (result.isConfirmed) {
                        ClearActivityCategory();
                        GetAdminExpActivityCategory();
                        bindExpensesActivityCategory("dlladminExpensesActivity");
                        GetAdminExpActivity();
                        GetAdminExpensesYearlyBudget();
                        bindExpensesActivityCategory("dllExpensesBudgetActivityCategory");
                        bindExpensesActivityCategory("dllExpensesActivityCategory");
                        BindAdminExpenseData();
                    }
                });
            }
            else if (serverMessage === "Activity Category already exists!") {
                Swal.fire("Warning", serverMessage, "warning");
            }
            else {
                Swal.fire("Error", serverMessage, "error");
            }
        },
        error: function (xhr, status, error) {
            Swal.fire("Error", "Server Error: " + error, "error");
        },
        complete: function () {
            $("#load1").hide();
        }
    });
    return false;
}

//Get Activity Category
function GetAdminExpActivityCategory() {
    $.ajax({
        type: "POST",
        url: "ExpensesAdmin.aspx/GetAdminExpActivityCategory",
        data: '{}',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var data = JSON.parse(response.d);
            if ($.fn.DataTable.isDataTable('#AdminActivityCategory_table')) {
                $('#AdminActivityCategory_table').DataTable().destroy();
            }

            if (data.length > 0) {
                var colNames = Object.keys(data[0]).filter(item => item !== "ActivityCategoryId");
                var actualDataColumn = colNames[0]; 

                var columnsConfig = [
                    {
                        title: "Action",
                        className: "text-end",
                        width: "25%",
                        orderable: false, 
                        data: null,
                        render: function (row, type, full) {
                            var id = full.ActivityCategoryId || '';
                            var name = full[actualDataColumn] || '';
                            var clickAction = "$('#hdnActivityCategoryId').val('" + id + "'); " +
                                "$('#AdminExp_ActivityCategory').val(`" + name + "`); " +
                                "$('#AdminExpActivityCategorybtnText').text('Update'); " +
                                "$('#AdminExpActivityCategory_btnIcon').removeClass('fa-paper-plane').addClass('fa-edit');";
                            return '<i class="fas fa-edit text-primary" style="cursor:pointer;" onclick="' + clickAction + '" title="Update"></i>';
                        }
                    },
                    {
                        title: "Activity Category",
                        data: actualDataColumn,
                        width: "75%"
                    }
                ];
                $('#AdminActivityCategory_table').DataTable({
                    data: data,
                    columns: columnsConfig,
                    destroy: true,
                    paging: true,
                    searching: true,
                    info: true,
                    ordering: false,
                    lengthChange: true,
                    autoWidth: false
                });

            } else {
                $('#AdminActivityCategory_table').empty();
                $('#AdminActivityCategory_table').html('<tbody><tr><td colspan="2" class="text-center">No data available</td></tr></tbody>');
            }
        },
        error: function (xhr, status, error) {
            console.log("Error: " + error);
        }
    });
}

//Clear Input Field
function ClearActivityCategory() {
    $('#hdnActivityCategoryId').val('0');
    $('#hdnActivityId').val('0');
    $('#hdnExpensesBugetId').val('0');

    $("#AdminExp_ActivityCategory").val("");
    $('#AdminExpActivityCategorybtnText').text("Submit");
    $('#AdminExpActivityCategory_btnIcon').removeClass("fa-edit").addClass("fa-paper-plane");
    $("#adminexpactivity").val("");
    $("#dlladminExpensesActivity").val("").trigger('change');
    $('#adminexpactivitybtnText').text("Submit");
    $('#adminexpactivitybtnicon').removeClass("fa-edit").addClass("fa-paper-plane");
    $('#dllExpensesBudgetActivityCategory').val('').trigger('change');
    $('#dllExpensesActivity').empty().append('<option value="">-- Select Activity --</option>');
    $('#adminexpYearlybudgetbtnText').text("Submit");
    $('#adminexpYearlybudgetbtnicon').removeClass("fa-edit").addClass("fa-paper-plane");
    $('#dllAdminExpLocation').val('');
    $('#AdminExpYear').val('');
    $('#AdminExpBudget').val('');
    $('#AdminExp_ActivityCategory').val('');
    $('#adminexpactivity').val('');
    $('#AdminExpYear').val('').trigger('change');
    $('#AdminExpBudget').val('');
}

//Fetch Activity Category
function bindExpensesActivityCategory(dropdownId) {
    var selector = "#" + dropdownId;
    $(selector).html('<option value="">Select</option>');
    $.ajax({
        type: "POST",
        url: "ExpensesAdmin.aspx/FetchAdminExpActivityCategory",
        dataType: "json",
        contentType: "application/json",
        success: function (res) {
            $.each(res.d, function (data, value) {
                $(selector).append($("<option></option>").val(value.ActivityCategoryId).html(value.ActivityCategory));
            });
        }
    });
}

//Submit Activity 
function ExpensesAdminActivitySubmit() {
    var AdminExp_ActivityCategory = $("#dlladminExpensesActivity").val();
    var AdminExp_Activity = $("#adminexpactivity").val();
    var activityId = $('#hdnActivityId').val(); 
    if (AdminExp_ActivityCategory === "") {
        Swal.fire("Validation", "Please Select Activity Category", "warning");
        return false;
    }
    if (AdminExp_Activity === "") {
        Swal.fire("Validation", "Please Add Activity", "warning");
        return false;
    }
    $("#load1").show();

    var formData = {
        AdminExp_ActivityCategory: AdminExp_ActivityCategory,
        AdminExp_Activity: AdminExp_Activity,
        activityId: activityId,
    };

    $.ajax({
        type: "POST",
        url: "ExpensesAdmin.aspx/SaveExpenseActivity",
        data: JSON.stringify(formData),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var serverMessage = response.d;
            if (serverMessage === "Activity saved successfully!" || serverMessage === "Activity updated successfully!") {
                Swal.fire("Success", serverMessage, "success").then((result) => {
                    if (result.isConfirmed) {
                        GetAdminExpActivity();
                        bindExpensesActivityCategory("dlladminExpensesActivity");
                        bindExpensesActivityCategory("dllExpensesBudgetActivityCategory");
                        bindExpensesActivityCategory("dllExpensesActivityCategory");
                        GetAdminExpensesYearlyBudget();
                        ClearActivityCategory();
                        bindExpensesActivityCategory("dllExpensesActivityCategory");
                        BindAdminExpenseData();
                    }
                });
            }
            else if (serverMessage === "Activity already exists!") {
                Swal.fire("Warning", serverMessage, "warning");
            }
            else {
                Swal.fire("Error", serverMessage, "error");
            }
        },
        error: function (xhr, status, error) {
            Swal.fire("Error", "Server Error: " + error, "error");
        },
        complete: function () {
            $("#load1").hide();
        }
    });
    return false;
}

// Get Activity function 
function GetAdminExpActivity() {
    $.ajax({
        type: "POST",
        url: "ExpensesAdmin.aspx/GetAdminExpActivity",
        data: '{}',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var data = JSON.parse(response.d);
            if ($.fn.DataTable.isDataTable('#AdminActivity_table')) {
                $('#AdminActivity_table').DataTable().destroy();
            }

            if (data.length > 0) {
                var columnsConfig = [
                    {
                        title: "Action",
                        className: "text-end",
                        width: "25%",
                        orderable: false,
                        data: null,
                        render: function (row, type, full) {
                            var id = full.ActivityId || '';
                            var categoryId = full.ActivityCategoryId || ''; 
                            var name = full.ActivityName || '';
                            var clickAction = "$('#hdnActivityId').val('" + id + "'); " +
                                "$('#dlladminExpensesActivity').val('" + categoryId + "').trigger('change'); " +
                                "$('#adminexpactivity').val(`" + name + "`); " +
                                "$('#adminexpactivitybtnText').text('Update'); " +
                                "$('#adminexpactivitybtnicon').removeClass('fa-paper-plane').addClass('fa-edit');";

                            return '<i class="fas fa-edit text-primary" style="cursor:pointer;" onclick="' + clickAction + '" title="Update"></i>';
                        }
                    },
                    {
                        title: "Activity Category",
                        data: "ActivityCategory",
                        width: "35%"
                    },
                    {
                        title: "Activity Name",
                        data: "ActivityName",
                        width: "40%"
                    }
                ];

                $('#AdminActivity_table').DataTable({
                    data: data,
                    columns: columnsConfig,
                    destroy: true,
                    paging: true,
                    searching: true,
                    info: true,
                    ordering: false,
                    lengthChange: true,
                    autoWidth: false
                });

            } else {
                $('#AdminActivity_table').empty();
                $('#AdminActivity_table').html('<tbody><tr><td colspan="3" class="text-center">No data available</td></tr></tbody>');
            }
        },
        error: function (xhr, status, error) {
            console.log("Error: " + error);
        }
    });
}

//Fetch activities based on selected category
function loadActivities(categoryId, preSelectedValue) {
    var $activityDropdown = $('#dllExpensesActivity');
    if (!categoryId) {
        $activityDropdown.empty();
        $activityDropdown.append('<option value="">-- Select Activity --</option>');
        return;
    }
    $.ajax({
        url: 'ExpensesAdmin.aspx/GetActivitiesByCategory',
        type: 'POST',
        dataType: 'json',
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify({ categoryId: categoryId }),
        success: function (response) {
            $activityDropdown.empty();
            $activityDropdown.append('<option value="">-- Select Activity --</option>');

            var data = typeof response.d === 'string' ? JSON.parse(response.d) : (response.d || response);

            $.each(data, function (index, activity) {
                $activityDropdown.append(
                    '<option value="' + activity.ActivityId + '">' + activity.ActivityName + '</option>'
                );
            });
            var selectedVal = preSelectedValue || $activityDropdown.data('selected-activity');
            if (selectedVal) {
                $activityDropdown.val(selectedVal);
                $activityDropdown.removeData('selected-activity');
            }
        },
        error: function (xhr, status, error) {
        }
    });
}

$(document).on('change', '#dllExpensesBudgetActivityCategory', function () {
    var categoryId = $(this).val();
    loadActivities(categoryId);
});

$(document).ready(function () {
    var initialCategory = $('#dllExpensesBudgetActivityCategory').val();
    if (initialCategory) {
        var existingActivity = $('#dllExpensesActivity').val();
        loadActivities(initialCategory, existingActivity);
    }
});
// Bind Location
function bindAdminExpLocation() {
    // Donhi dropdowns che references ghya
    var select1 = document.getElementById("adminexplocation");
    var select2 = document.getElementById("dllAdminExpLocation");

    // Pahilya dropdown che options clear kara
    if (select1) {
        let options1 = select1.getElementsByTagName('option');
        for (var i = options1.length; i--;) {
            select1.removeChild(options1[i]);
        }
        $("#adminexplocation").append($("<option></option>").val("").html("Select"));
    }

    // Dusrya dropdown che options clear kara
    if (select2) {
        let options2 = select2.getElementsByTagName('option');
        for (var j = options2.length; j--;) {
            select2.removeChild(options2[j]);
        }
        $("#dllAdminExpLocation").append($("<option></option>").val("").html("Select"));
    }

    // AJAX Call
    $.ajax({
        type: "POST",
        url: "CreateProfile.aspx/GetBranches",
        dataType: "json",
        contentType: "application/json",
        success: function (res) {
            $.each(res.d, function (data, value) {
                // Donhi dropdowns madhye options append kara
                $("#adminexplocation").append($("<option></option>").val(value.BranchID).html(value.BranchName));
                $("#dllAdminExpLocation").append($("<option></option>").val(value.BranchID).html(value.BranchName));
            });
        }
    });
}

function ExpensesAdminYearlybudgetSubmit() {
    var budgetId = $('#hdnExpensesBugetId').val();
    var categoryId = $('#dllExpensesBudgetActivityCategory').val();
    var activityId = $('#dllExpensesActivity').val();
    var locationId = $('#dllAdminExpLocation').val();
    var year = $('#AdminExpYear').val();
    var budget = $('#AdminExpBudget').val();

    if (!categoryId)
    {
        Swal.fire("Validation", "Please Select Activity Category", "warning");
        return false;
    }
    if (!activityId)
    {
        Swal.fire("Validation", "Please Select Activity", "warning");
        return false;
    }
    if (!locationId)
    {
        Swal.fire("Validation", "Please Select Location", "warning");
        return false;
    }

    if (!year)
    {
        Swal.fire("Validation", "Please Select Year", "warning");
        return false;
    }

    if (!budget || budget <= 0)
    {
        Swal.fire("Validation", "Please Add Budget", "warning");
        return false;
    }

    var $btn = $('#adminexpaYearlybudget_btnsubmit');
    var $icon = $('#adminexpYearlybudgetbtnicon');
    var $text = $('#adminexpYearlybudgetbtnText');

    $btn.prop('disabled', true);
    $icon.removeClass('fa-paper-plane').addClass('fa-spinner fa-spin');
    $text.text('Saving...');

    $.ajax({
        url: 'ExpensesAdmin.aspx/SaveYearlyBudget',
        type: 'POST',
        dataType: 'json',
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify({
            budgetId: parseInt(budgetId || 0),
            categoryId: parseInt(categoryId),
            activityId: parseInt(activityId),
            locationId: parseInt(locationId),
            year: parseInt(year),
            budget: parseFloat(budget)
        }),
        success: function (response) {
            var resMsg = response.d;
            if (resMsg === "Budget saved successfully!" || serverMessage === "Budget updated successfully!") {
                Swal.fire("Success", resMsg, "success").then((result) => {
                    if (result.isConfirmed) {
                        GetAdminExpensesYearlyBudget();
                        ClearActivityCategory();
                    }
                });
            }
            else if (resMsg === "Budget for this year already exists!") {
                Swal.fire("Warning", resMsg, "warning");
            }
            else {
                Swal.fire("Error", resMsg, "error");
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr.responseText);
            alert('Error');
        },
        complete: function () {
            $btn.prop('disabled', false);
            $icon.removeClass('fa-spinner fa-spin').addClass('fa-paper-plane');
            $text.text('Submit');
        }
    });
}

function GetAdminExpensesYearlyBudget() {
    $.ajax({
        type: "POST",
        url: "ExpensesAdmin.aspx/GetAdminExpensesYearlyBudget",
        data: '{}',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var data = typeof response.d === 'string' ? JSON.parse(response.d) : (response.d || response);

            if ($.fn.DataTable.isDataTable('#AdminExpensesYearlyBuget_table')) {
                $('#AdminExpensesYearlyBuget_table').DataTable().destroy();
            }

            if (data.length > 0) {
                $('#AdminExpensesYearlyBuget_table').DataTable({
                    data: data,
                    destroy: true,
                    paging: true,
                    searching: true,
                    ordering: false,
                    columns: [
                        {
                            title: "Action",
                            className: "text-center",
                            width: "10%",
                            data: null,
                            render: function (row, type, full) {
                                return '<i class="fas fa-edit text-primary" style="cursor:pointer;" onclick="EditYearlyBudget(' +
                                    full.ExpensesBugetId + ', ' +
                                    full.ActivityCategoryId + ', ' +
                                    full.ActivityId + ', ' +
                                    full.LocationId + ', \'' +
                                    full.Year + '\', ' +
                                    full.Budget + ')" title="Update"></i>';
                            }
                        },
                        { title: "Category", data: "ActivityCategory", width: "25%" },
                        { title: "Activity", data: "ActivityName", width: "25%" },
                        { title: "Location", data: "BranchName", width: "25%" },
                        { title: "Year", data: "Year", width: "15%" },
                        { title: "Budget", data: "Budget", width: "25%" }
                    ]
                });
            } else {
                $('#AdminExpensesYearlyBuget_table').html('<tbody><tr><td colspan="5" class="text-center">No data available</td></tr></tbody>');
            }
        },
        error: function (xhr, status, error) {
            console.log("Error: " + error);
        }
    });
}

function EditYearlyBudget(budgetId, categoryId, activityId, locationId, year, budget) {
    $('#hdnExpensesBugetId').val(budgetId);
    $('#dllExpensesActivity').data('selected-activity', activityId);
    $('#dllExpensesBudgetActivityCategory').val(categoryId).trigger('change');
    $('#dllAdminExpLocation').val(locationId);
    $('#AdminExpYear').val(year);
    $('#AdminExpBudget').val(budget);
    $('#adminexpYearlybudgetbtnText').text('Update');
    $('#adminexpYearlybudgetbtnicon').removeClass('fa-paper-plane').addClass('fa-edit');
}

$(document).on('change', '#dllExpensesActivityCategory', function () {
    var categoryId = $(this).val();
    loadExpDetailsActivities(categoryId, null);
});

$(document).ready(function () {
    var initialCategory = $('#dllExpensesActivityCategory').val();
    if (initialCategory) {
        var existingActivity = $('#dllExpensesdetailsActivity').val();
        loadExpDetailsActivities(initialCategory, existingActivity);
    }
});

function loadExpDetailsActivities(categoryId, preSelectedValue) {
    var $activityDropdown = $('#dllExpensesdetailsActivity');

    // Jar category select nsel tar dropdown clear kara
    if (!categoryId) {
        $activityDropdown.html('<option value="">-- Select Activity --</option>');
        return;
    }

    $.ajax({
        url: 'ExpensesAdmin.aspx/GetActivitiesByCategory',
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify({ categoryId: categoryId }),
        dataType: 'json',
        success: function (response) {
            $activityDropdown.empty();
            $activityDropdown.append('<option value="">-- Select Activity --</option>');

            // ASP.NET WebMethod response (.d property handle karne)
            var data = typeof response.d === 'string' ? JSON.parse(response.d) : (response.d || response);

            // Activities dropdown madhe bind karne
            $.each(data, function (index, item) {
                $activityDropdown.append(
                    $('<option></option>').val(item.ActivityId).text(item.ActivityName)
                );
            });

            // Edit mode sathi pre-selected value set karne
            if (preSelectedValue) {
                $activityDropdown.val(preSelectedValue);
            }
        },
        error: function (xhr, status, error) {
            console.error("Error loading activities: " + error);
        }
    });
}

document.addEventListener("DOMContentLoaded", function () {
    const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const maxDate = `${year}-${month}`;

    const monthInput = document.getElementById('expPlannedMonth');
    if (monthInput) {
        monthInput.max = maxDate;
        monthInput.value = maxDate;
    }
});

//Submit Data
function ExpenseSubmitData() {
    var expenseId = $("#hdnExpenseId").val() || 0;

    var locationId = $("#adminexplocation").val();
    var expdetailsRecreationActivity = $("#dllExpensesActivityCategory").val();
    var activityId = $('#dllExpensesdetailsActivity').val();

    var rawPlannedMonth = $("#expPlannedMonth").val();
    var completedDate = $("#CompletedDate").val();
    var expShift = $("#ExpShift").val();
    var actualExpense = $("#ActualExpense").val();
    var status = $("#Status").val();
    var remark = $("#remark").val();

    if (locationId === "" || locationId === "Select") {
        Swal.fire("Validation", "Please Select Location", "warning");
        return;
    }
    if (expdetailsRecreationActivity === "" || expdetailsRecreationActivity === "Select") {
        Swal.fire("Validation", "Please Select Activity Category ", "warning");
        return;
    }
    if (activityId === "" || activityId === "-- Select Activity --") {
        Swal.fire("Validation", "Please Select Activity  ", "warning");
        return;
    }
    if (expPlannedMonth === "" || expPlannedMonth === "Select") {
        Swal.fire("Validation", "Please Select Activities Month", "warning");
        return;
    }
    if (completedDate === "" || completedDate === "Select") {
        Swal.fire("Validation", "Please Select Completed Date", "warning");
        return;
    }
    if (actualExpense === "") {
        Swal.fire("Validation", "Please add Actual Expense", "warning");
        return;
    }

    if (status === "" || status === "Select") {
        Swal.fire("Validation", "Please Select status", "warning");
        return;
    }

    if (expShift === "") {
        Swal.fire("Validation", "Please Select Shift", "warning");
        return;
    }
    var formattedPlannedMonth = "";
    if (rawPlannedMonth) {
        var parts = rawPlannedMonth.split("-");
        var year = parts[0];
        var monthIndex = parseInt(parts[1], 10) - 1;

        var date = new Date(year, monthIndex, 1);
        var monthName = date.toLocaleString('en-US', { month: 'long' });

        formattedPlannedMonth = monthName + "-" + year; 
    }
    var formData = {
        expenseId: expenseId,
        LocationId: locationId,
        RecreationActivity: expdetailsRecreationActivity,
        activityId: activityId,
        formattedPlannedMonth: formattedPlannedMonth,
        CompletedDate: completedDate,
        ExpShift: expShift,
        ActualExpense: actualExpense,
        Status: status,
        Remark: remark
    };

    $.ajax({
        type: "POST",
        url: "ExpensesAdmin.aspx/SaveExpenseData",
        data: JSON.stringify(formData),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var serverMessage = response.d;
            if (serverMessage === "Expense Details saved successfully!" || serverMessage === "Expense Details updated successfully!") {
                Swal.fire("Success", serverMessage, "success").then((result) => {
                    if (result.isConfirmed) {
                        $("#hdnExpenseId").val("0");
                        BindAdminExpenseData();
                        ClearExpenseForm();
                    }
                });
            }
            else {
                Swal.fire("Error", serverMessage, "error");
            }
        },
        error: function (xhr, status, error) {
            Swal.fire("Error", "Server Error: " + error, "error");
        }
    });
    return false;
}

//Bind Data to datatble for Update
function BindAdminExpenseData() {
    $('#load1').show();
    $.ajax({
        type: "POST",
        url: "ExpensesAdmin.aspx/GetAdminExpenseData",
        data: '{}',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var data = JSON.parse(response.d);
            if ($.fn.DataTable.isDataTable('#AdminExpense_table')) {
                $('#AdminExpense_table').DataTable().clear().destroy();
            }
            var $tbody = $("#AdminExpense_table tbody").empty();
            var $thead = $("#AdminExpense_table thead").empty();

            if (!data.length) {
                var defaultColumns = ['Location', 'Activity Category', 'Activity Name', 'Planned Month', 'Shift', 'Completed Date', 'Actual Expense', 'Status', 'Remark'];
                var headerHtml = "<tr><th>Action</th>" + defaultColumns.map(c => "<th>" + c + "</th>").join("") + "</tr>";
                $thead.append(headerHtml);

                $tbody.append("<tr><td colspan='" + (defaultColumns.length + 1) + "' style='text-align:center;'>No data found</td></tr>");
                $('#load1').hide();
                return;
            }

            // ExpensesId, ActivityId, ani ActivityCategoryId UI la disnar nahiyet, 
            // pan window.adminExpenseData madhe save rahtil!
            var columns = Object.keys(data[0]).filter(c =>
                c !== 'ExpensesId' &&
                c !== 'ActivityId' &&
                c !== 'ActivityCategoryId'
            );
            var headerHtml = "<tr><th>Action</th>" + columns.map(c => "<th>" + c + "</th>").join("") + "</tr>";
            $thead.append(headerHtml);

            var rowsHtml = data.map((row, index) => {
                var actionCell = `<td><a href='javascript:void(0);' class='update-btn text-primary' onclick='EditExpenseRow(${index})' title='Update'><i class='fas fa-edit fa-lg'></i></a></td>`;
                var cells = columns.map(c => "<td>" + (row[c] !== null ? row[c] : "") + "</td>").join("");
                return `<tr id='row_${index}'>` + actionCell + cells + "</tr>";
            }).join("");

            $tbody.append(rowsHtml);
            window.adminExpenseData = data; 

            var remarkColumnIndex = columns.indexOf('Remark') + 1; 

            $('#AdminExpense_table').DataTable({
                "paging": true,
                "pageLength": 10,
                "lengthChange": true,
                "searching": true,
                "ordering": false,
                "info": true,
                "destroy": true,
                "scrollX": true,
                "autoWidth": false,
                "columnDefs": [
                    {
                        "targets": remarkColumnIndex, 
                        "width": "250px",
                        "createdCell": function (td, cellData, rowData, row, col) {
                            $(td).css({
                                "white-space": "normal",
                                "word-break": "break-word",
                                "max-width": "250px"
                            });
                        }
                    }
                ]
            });
            $('#load1').hide();
        },
        error: function (xhr, status, error) {
            console.log("Error: " + error);
            $('#load1').hide();
        }
    });
}

//Update Data
function EditExpenseRow(index) {
    var data = window.adminExpenseData[index];
    if (!data) return;

    $('#hdnExpenseId').val(data.ExpensesId);
    $('#btnText').text("Update");
    $('#btnIcon').removeClass("fa-paper-plane").addClass("fas fa-edit fa-lg");

    var locName = data["Branch Name"] || data["Location"] || data["location"] || '';
    $('#adminexplocation option').each(function () {
        if ($(this).text().trim() === locName.trim() || $(this).val() == locName) {
            $('#adminexplocation').val($(this).val());
            return false;
        }
    });

    var categoryId = data["ActivityCategoryId"] || '';
    var activityId = data["ActivityId"] || '';

    if (categoryId) {
        $('#dllExpensesActivityCategory').val(categoryId);
        loadExpDetailsActivities(categoryId, activityId);
    } else {
        $('#dllExpensesActivityCategory').val("").trigger('change');
    }
    var plannedMonth = data["Planned Month"] || data["PlannedMonth"] || data["plannedMonth"] || '';

    if (plannedMonth) {
        var parts = plannedMonth.split("-");
        if (parts.length === 2 && isNaN(parts[0])) {
            var monthName = parts[0];
            var year = parts[1];
            var dateObj = new Date(monthName + " 1, " + year);
            if (!isNaN(dateObj.getTime())) {
                var m = String(dateObj.getMonth() + 1).padStart(2, '0');
                $('#expPlannedMonth').val(year + "-" + m);
            } else {
                $('#expPlannedMonth').val('');
            }
        } else {
            $('#expPlannedMonth').val(plannedMonth);
        }
    } else {
        $('#expPlannedMonth').val('');
    }
    $('#ExpShift').val(data["Shift"] || data["ExpShift"] || 'Select');

    var compDateStr = data["Completed Date"] || data["CompletedDate"] || '';
    if (compDateStr) {
        try {
            var compParsedDate = new Date(compDateStr);
            if (!isNaN(compParsedDate.getTime())) {
                $('#CompletedDate').val(compParsedDate.toISOString().split('T')[0]);
            } else {
                $('#CompletedDate').val(compDateStr);
            }
        } catch (e) {
            $('#CompletedDate').val('');
        }
    } else {
        $('#CompletedDate').val('');
    }

    var actualVal = (data["Actual Expense"] !== undefined && data["Actual Expense"] !== null) ? data["Actual Expense"] : '';
    $('#ActualExpense').val(actualVal);
    $('#Status').val(data["Status"] || data["status"] || 'Select');
    $('#remark').val(data["Remark"] || data["remark"] || '');
    $('html, body').animate({ scrollTop: 0 }, 'fast');
}

//Clear Input Field
function ClearExpenseForm() {
    $("#hdnExpenseId").val("0");

    $("#adminexplocation").val("").trigger('change'); 
    $("#dllExpensesActivityCategory").val("").trigger('change');
    $("#dllExpensesdetailsActivity").html('<option value="">-- Select Activity --</option>');

    $("#expPlannedMonth").val("");
    $("#CompletedDate").val("");
    $("#ActualExpense").val("");
    $("#Status").val("");
    $("#remark").val("");
    $("#ExpShift").val("");

    $('#btnText').text("Submit");
    $('#btnIcon').removeClass("fa-edit").addClass("fa-paper-plane");
}

//Report Table Bind Data

var globalAdminExpenseData = [];
function BindAdminExpenseDataForReport() {
    $('#load1').show();
    var ExpenseFromDate = document.getElementById("ExpenseFromDate").value;
    var ExpenseToDate = document.getElementById("ExpenseToDate").value;
    if (ExpenseFromDate == "") {
        $('#load1').hide();
        Swal.fire("Validation", "Please select from date", "warning");
        return false;
    }
    if (ExpenseToDate == "") {
        $('#load1').hide();
        Swal.fire("Validation", "Please select to date", "warning");
        return false;
    }
    if (ExpenseToDate < ExpenseFromDate) {
        $('#load1').hide();
        Swal.fire("Validation", "Please ensure that the To Date is after the From Date.", "warning");
        return false;
    }
    if ($.fn.DataTable.isDataTable('#AdminExpenseReport_table')) {
        $('#AdminExpenseReport_table').DataTable().clear().destroy();
    }
    $.ajax({
        type: "POST",
        data: "{ExpenseFromDate:'" + ExpenseFromDate + "', ExpensesToDate:'" + ExpenseToDate + "'}",
        url: "ExpensesAdmin.aspx/GetAdminExpenseDataForReport",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var responseObj = JSON.parse(response.d);
            var data = responseObj.details;
            var summaryData = responseObj.summary;
            var locationSummaryData = responseObj.locationSummary;
            var activitySummaryData = responseObj.activitySummary;

            globalAdminExpenseData = data || [];
            $('#AdminExpenseReport_table').data('summaryData', summaryData);
            $('#AdminExpenseReport_table').data('locationSummaryData', locationSummaryData);
            $('#AdminExpenseReport_table').data('activitySummaryData', activitySummaryData);
            var yearlyCountSummaryData = responseObj.YearlycountSummary;
            $('#AdminExpenseReport_table').data('yearlyCountSummaryData', yearlyCountSummaryData);
            if (data && data.length > 0) {
                var columns = Object.keys(data[0]);
                var headerHtml = "<tr>";
                columns.forEach(function (col) {
                    headerHtml += "<th>" + col + "</th>";
                });
                headerHtml += "</tr>";
                $("#AdminExpenseReport_table thead").html(headerHtml);

                var bodyHtml = "";
                data.forEach(function (row) {
                    bodyHtml += "<tr>";
                    columns.forEach(function (col) {
                        var val = row[col] !== null && row[col] !== undefined ? row[col] : "";
                        bodyHtml += "<td>" + val + "</td>";
                    });
                    bodyHtml += "</tr>";
                });
                $("#AdminExpenseReport_table tbody").html(bodyHtml);
                if ($.fn.DataTable.isDataTable('#AdminExpenseReport_table')) {
                    $('#AdminExpenseReport_table').DataTable().destroy();
                }

                $('#AdminExpenseReport_table').DataTable({
                    pageLength: 10,
                    responsive: true,
                    "ordering": false,
                    columnDefs: [
                        {
                            targets: -1,
                            className: "text-wrap",
                            render: function (data, type, row) {
                                return '<div style="max-width: 300px; word-break: break-word;">' + (data || '') + '</div>';
                            }
                        }
                    ]
                });
            } else {
                $("#AdminExpenseReport_table tbody").html("<tr><td colspan='100%' style='text-align:center;'>No Data Found</td></tr>");
            }
            $('#load1').hide();
        },
        error: function (xhr, status, error) {
            console.error("Error: ", error);
            $('#load1').hide();
        }
    });
}

// Excel To Export 
$(document).on('click', '#Expenses_btnExporttoexcel', function () {
    var ExpensesFromDate = document.getElementById("ExpenseFromDate").value;
    var ExpensesToDate = document.getElementById("ExpenseToDate").value;

    if (ExpensesFromDate == "") {
        Swal.fire("Validation", "Please select from date", "warning");
        return false;
    }
    if (ExpensesToDate == "") {
        Swal.fire("Validation", "Please select to date", "warning");
        return false;
    }
    if (ExpensesToDate < ExpensesFromDate) {
        Swal.fire("Validation", "Please ensure that the To Date is after the From Date.", "warning");
        return false;
    }

    ExportTableToExcel(ExpensesFromDate, ExpensesToDate);
});

// Safe Date Formatter
function formatFileNameDate(dateStr) {
    if (!dateStr) return "";
    var parts = dateStr.split('-');
    if (parts.length === 3) {
        var year = parts[0];
        var monthIndex = parseInt(parts[1], 10) - 1;
        var day = parts[2];
        var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        if (monthIndex >= 0 && monthIndex < 12) {
            return day + "-" + months[monthIndex] + "-" + year;
        }
    }
    return dateStr;
}

function ExportTableToExcel(fromDate, toDate) {
    var table = document.getElementById("AdminExpenseReport_table");

    if (!table || table.rows.length <= 1) {
        Swal.fire("Validation", "No data available to export.", "warning");
        return;
    }

    var dataArray = [];
    var headers = [];

    var headerCells = table.rows[0].cells;
    for (var h = 0; h < headerCells.length; h++) {
        headers.push(headerCells[h].innerText.trim());
    }

    for (var i = 1; i < table.rows.length; i++) {
        var row = table.rows[i];
        var rowObj = {};
        for (var c = 0; c < row.cells.length; c++) {
            var colName = headers[c];
            var cellText = row.cells[c].innerText.trim();
            rowObj[colName] = cellText;
        }
        dataArray.push(rowObj);
    }

    var wb = XLSX.utils.book_new();
    var ws = XLSX.utils.json_to_sheet(globalAdminExpenseData);
    var headers = Object.keys(globalAdminExpenseData[0]);

    var headerStyle = {
        fill: { fgColor: { rgb: "D3D3D3" } },
        font: { bold: true, color: { rgb: "000000" } },
        alignment: { horizontal: "center", vertical: "center", wrapText: true },
        border: {
            top: { style: "thin", color: { rgb: "000000" } },
            bottom: { style: "thin", color: { rgb: "000000" } },
            left: { style: "thin", color: { rgb: "000000" } },
            right: { style: "thin", color: { rgb: "000000" } }
        }
    };

    var cellStyle = {
        alignment: { vertical: "center", wrapText: false },
        border: {
            top: { style: "thin", color: { rgb: "000000" } },
            bottom: { style: "thin", color: { rgb: "000000" } },
            left: { style: "thin", color: { rgb: "000000" } },
            right: { style: "thin", color: { rgb: "000000" } }
        }
    };

    var remarkStyle = {
        alignment: { vertical: "center", wrapText: true },
        border: {
            top: { style: "thin", color: { rgb: "000000" } },
            bottom: { style: "thin", color: { rgb: "000000" } },
            left: { style: "thin", color: { rgb: "000000" } },
            right: { style: "thin", color: { rgb: "000000" } }
        }
    };

    var titleStyle = {
        fill: { fgColor: { rgb: "4F81BD" } },
        font: { bold: true, color: { rgb: "FFFFFF" }, sz: 12 },
        alignment: { horizontal: "center", vertical: "center" }
    };

    var totalStyle = {
        fill: { fgColor: { rgb: "E0E0E0" } },
        font: { bold: true, color: { rgb: "000000" } },
        alignment: { horizontal: "right", vertical: "center" }, 
        border: {
            top: { style: "thin", color: { rgb: "000000" } },
            bottom: { style: "thin", color: { rgb: "000000" } }, 
            left: { style: "thin", color: { rgb: "000000" } },
            right: { style: "thin", color: { rgb: "000000" } }
        }
    };

    var colWidths = [];
    for (var h = 0; h < headers.length; h++) {
        var hName = headers[h].toLowerCase();
        if (hName.includes("remark")) {
            colWidths[h] = { wch: 25 };
        } else {
            colWidths[h] = { wch: headers[h].length + 5 };
        }
    }

    var range = XLSX.utils.decode_range(ws['!ref']);
    for (var R = range.s.r; R <= range.e.r; ++R) {
        for (var C = range.s.c; C <= range.e.c; ++C) {
            var cellAddress = XLSX.utils.encode_cell({ r: R, c: C });
            if (!ws[cellAddress]) continue;

            var currentHeader = headers[C] ? headers[C].toLowerCase() : "";
            var isRemarkCol = currentHeader.includes("remark");

            if (R === 0) {
                ws[cellAddress].s = headerStyle;
            } else if (isRemarkCol) {
                ws[cellAddress].s = remarkStyle;
            } else {
                ws[cellAddress].s = cellStyle;
            }

            if (!isRemarkCol) {
                var cellValue = ws[cellAddress].v ? ws[cellAddress].v.toString() : "";
                if (cellValue.length > (colWidths[C] ? colWidths[C].wch : 0)) {
                    colWidths[C] = { wch: Math.max(cellValue.length + 3, 10) };
                }
            }
        }
    }
   

    var summaryData = $('#AdminExpenseReport_table').data('summaryData');
    var locationSummaryData = $('#AdminExpenseReport_table').data('locationSummaryData');
    var activitySummaryData = $('#AdminExpenseReport_table').data('activitySummaryData');

    if ((summaryData && summaryData.length > 0) ||
        (locationSummaryData && locationSummaryData.length > 0) ||
        (activitySummaryData && activitySummaryData.length > 0)) {

        var wsSummary = XLSX.utils.aoa_to_sheet([]);
        var summaryMerges = [];
        var currentRow = 0;
        // --- SECTION 4: Yearly Count / Cultural Activity Summary (Location vs Month Pivot) ---
        var yearlyCountSummaryData = $('#AdminExpenseReport_table').data('yearlyCountSummaryData');
        if (yearlyCountSummaryData && yearlyCountSummaryData.length > 0) {
            var locations4 = [];
            var rowKeys4 = []; 
            var pivotMap4 = {};
            var activityMap4 = {};

            yearlyCountSummaryData.forEach(function (item) {
                var loc = item["Location"] || item["BranchName"] || item["Branch"] || "Unknown";
                var mName = item["Month"] || "Unknown";
                var yName = item["Year"] || "Unknown";

                var rowKey = mName + "___" + yName;

                var exp = parseFloat(item["Actual Expense"] || item["ActualExpense"] || item["Expense"] || 0);
                var totalActivity = parseInt(item["Total Activity All Branches"] || 0);
                if (!locations4.includes(loc)) locations4.push(loc);
                if (!rowKeys4.includes(rowKey)) rowKeys4.push(rowKey);

                if (!pivotMap4[rowKey]) pivotMap4[rowKey] = {};
                pivotMap4[rowKey][loc] = (pivotMap4[rowKey][loc] || 0) + exp;

                if (!activityMap4[rowKey]) activityMap4[rowKey] = 0;
                activityMap4[rowKey] += totalActivity;
            });

            locations4.sort();
            rowKeys4.sort(); 

            var matrixHeaders4 = ["Month", "Year"].concat(locations4).concat(["Total", "Total Activity All Branches"]);
            var matrixRows4 = [];

            rowKeys4.forEach(function (rKey) {
                var parts = rKey.split("___");
                var mName = parts[0];
                var yName = parts[1];

                var rowObj = {};
                rowObj["Month"] = mName;
                rowObj["Year"] = yName;
                var rowTotal = 0;

                locations4.forEach(function (loc) {
                    var val = (pivotMap4[rKey] && pivotMap4[rKey][loc] !== undefined) ? pivotMap4[rKey][loc] : 0;
                    rowObj[loc] = Number(val.toFixed(2));
                    rowTotal += val;
                });

                rowObj["Total"] = Number(rowTotal.toFixed(2));
                rowObj["Total Activity All Branches"] = activityMap4[rKey] || 0;
                matrixRows4.push(rowObj);
            });
            XLSX.utils.sheet_add_aoa(wsSummary, [["OFFICE CULTURAL ACTIVITY AND & EXPENSE SUMMARY DASHBOARD"]], { origin: { r: currentRow, c: 0 } });
            summaryMerges.push({ s: { r: currentRow, c: 0 }, e: { r: currentRow, c: matrixHeaders4.length - 1 } });
            currentRow++;

            XLSX.utils.sheet_add_aoa(wsSummary, [matrixHeaders4], { origin: { r: currentRow, c: 0 } });
            currentRow++;

            matrixRows4.forEach(function (rData) {
                var rowArray = [];
                matrixHeaders4.forEach(function (hName) {
                    rowArray.push(rData[hName] !== undefined ? rData[hName] : "");
                });
                XLSX.utils.sheet_add_aoa(wsSummary, [rowArray], { origin: { r: currentRow, c: 0 } });
                currentRow++;
            });

            var matrixTotalRow4 = new Array(matrixHeaders4.length).fill("");
            matrixTotalRow4[0] = "Total";
            matrixTotalRow4[1] = ""; 

            for (var c = 2; c < matrixHeaders4.length; c++) {
                var colName = matrixHeaders4[c];
                var colSum = 0;
                matrixRows4.forEach(function (r) {
                    colSum += parseFloat(r[colName] || 0);
                });
                matrixTotalRow4[c] = Number(colSum.toFixed(2));
            }

            XLSX.utils.sheet_add_aoa(wsSummary, [matrixTotalRow4], { origin: { r: currentRow, c: 0 } });
            currentRow += 3;
        }
        // --- SECTION 1: Month-wise Summary ---
        if (summaryData && summaryData.length > 0) {
            var locations = [];
            var categories = [];
            var pivotMap1 = {};
            var pivotMapPrev = {};
            var pivotMapYearExp = {};

            summaryData.forEach(function (item) {
                var loc = item["Location"] || item["BranchName"] || item["Branch"] || "Unknown";
                var cat = item["Activity Category"] || item["ActivityCategory"] || item["Category"] || "Other";
                var exp = parseFloat(item["Actual Expense"] || item["ActualExpense"] || item["Expense"] || 0);
                var prevExp = parseFloat(item["Previous Month Expense"] || item["PreviousMonthExpense"] || 0);
                var YearTotalExp = parseFloat(item["Yearly Total Expense"] || item["YTDExpense"] || item["Year Month Total Expense"] || 0);

                if (!locations.includes(loc)) locations.push(loc);
                if (!categories.includes(cat)) categories.push(cat);

                if (!pivotMap1[loc]) pivotMap1[loc] = {};
                pivotMap1[loc][cat] = (pivotMap1[loc][cat] || 0) + exp;

                if (!pivotMapPrev[loc]) pivotMapPrev[loc] = {};
                pivotMapPrev[loc][cat] = (pivotMapPrev[loc][cat] || 0) + prevExp;

                if (!pivotMapYearExp[loc]) pivotMapYearExp[loc] = {};
                pivotMapYearExp[loc][cat] = (pivotMapYearExp[loc][cat] || 0) + YearTotalExp;
            });

            categories.sort();
            locations.sort();
            var matrixHeaders1 = ["Location"].concat(categories).concat(["Total", "Previous Month Expense", "Year Month Total Expense"]);
            var matrixRows1 = [];

            locations.forEach(function (loc) {
                var rowObj = {};
                rowObj["Location"] = loc;
                var rowTotal = 0;
                var prevMonthTotal = 0;
                var yearMonthTotal = 0;

                categories.forEach(function (cat) {
                    var val = (pivotMap1[loc] && pivotMap1[loc][cat] !== undefined) ? pivotMap1[loc][cat] : 0;
                    rowObj[cat] = Number(val.toFixed(2));
                    rowTotal += val;
                });

                if (pivotMapPrev[loc]) {
                    categories.forEach(function (cat) {
                        prevMonthTotal += (pivotMapPrev[loc][cat] || 0);
                    });
                }
                if (pivotMapYearExp[loc]) {
                    categories.forEach(function (cat) {
                        yearMonthTotal += (pivotMapYearExp[loc][cat] || 0);
                    });
                }

                rowObj["Total"] = Number(rowTotal.toFixed(2));
                rowObj["Previous Month Expense"] = Number(prevMonthTotal.toFixed(2));
                rowObj["Year Month Total Expense"] = Number(yearMonthTotal.toFixed(2));

                matrixRows1.push(rowObj);
            });

            XLSX.utils.sheet_add_aoa(wsSummary, [["Location and Activity wise Monthly Expense"]], { origin: { r: currentRow, c: 0 } });
            summaryMerges.push({ s: { r: currentRow, c: 0 }, e: { r: currentRow, c: matrixHeaders1.length - 1 } });
            currentRow++;

            XLSX.utils.sheet_add_aoa(wsSummary, [matrixHeaders1], { origin: { r: currentRow, c: 0 } });
            currentRow++;

            matrixRows1.forEach(function (rData) {
                var rowArray = [];
                matrixHeaders1.forEach(function (hName) {
                    rowArray.push(rData[hName] !== undefined ? rData[hName] : "");
                });
                XLSX.utils.sheet_add_aoa(wsSummary, [rowArray], { origin: { r: currentRow, c: 0 } });
                currentRow++;
            });

            var matrixTotalRow1 = new Array(matrixHeaders1.length).fill("");
            matrixTotalRow1[0] = "Total";

            for (var c = 1; c < matrixHeaders1.length; c++) {
                var colCat = matrixHeaders1[c];
                var colSum = 0;
                matrixRows1.forEach(function (r) {
                    colSum += parseFloat(r[colCat] || 0);
                });
                matrixTotalRow1[c] = Number(colSum.toFixed(2));
            }

            XLSX.utils.sheet_add_aoa(wsSummary, [matrixTotalRow1], { origin: { r: currentRow, c: 0 } });
            currentRow += 3;
        }

        // --- SECTION 2: Location-wise & Activity Category Matrix Summary ---
        if (locationSummaryData && locationSummaryData.length > 0) {
            var locations = [];
            var categories = [];
            var pivotMap = {};
            var completedMap = {}; 
            var pendingMap = {};  

            locationSummaryData.forEach(function (item) {
                var loc = item["Location"] || item["BranchName"] || item["Branch"] || "Unknown";
                var cat = item["Activity Category"] || item["ActivityCategory"] || item["Category"] || "Other";
                var cnt = parseInt(item["Activity Count"] || item["ActivityCount"] || item["Count"] || 0);
                var compCnt = parseInt(item["Completed Activity"] || 0);
                var pendCnt = parseInt(item["Pending Activity"] || 0);

                if (!locations.includes(loc)) locations.push(loc);
                if (!categories.includes(cat)) categories.push(cat);

                if (!pivotMap[loc]) pivotMap[loc] = {};
                pivotMap[loc][cat] = (pivotMap[loc][cat] || 0) + cnt;

                if (!completedMap[loc]) completedMap[loc] = {};
                completedMap[loc][cat] = (completedMap[loc][cat] || 0) + compCnt;

                if (!pendingMap[loc]) pendingMap[loc] = {};
                pendingMap[loc][cat] = (pendingMap[loc][cat] || 0) + pendCnt;
            });
            categories.sort();
            var matrixHeaders = ["Location"].concat(categories).concat(["Total", "Completed Activity", "Pending Activity"]);
            var matrixRows = [];

            locations.forEach(function (loc) {
                var rowObj = {};
                rowObj["Location"] = loc;
                var rowTotal = 0;
                var rowCompletedTotal = 0;
                var rowPendingTotal = 0;
                categories.forEach(function (cat) {
                    var val = (pivotMap[loc] && pivotMap[loc][cat] !== undefined) ? pivotMap[loc][cat] : 0;
                    rowObj[cat] = val; 
                    rowTotal += val;
                });
                categories.forEach(function (cat) {
                    rowCompletedTotal += (completedMap[loc] && completedMap[loc][cat] !== undefined) ? completedMap[loc][cat] : 0;
                    rowPendingTotal += (pendingMap[loc] && pendingMap[loc][cat] !== undefined) ? pendingMap[loc][cat] : 0;
                });

                rowObj["Total"] = rowTotal;
                rowObj["Completed Activity"] = rowCompletedTotal;
                rowObj["Pending Activity"] = rowPendingTotal;
              
                matrixRows.push(rowObj);
            });

            XLSX.utils.sheet_add_aoa(wsSummary, [["Location-wise Monthly Activity Count"]], { origin: { r: currentRow, c: 0 } });
            summaryMerges.push({ s: { r: currentRow, c: 0 }, e: { r: currentRow, c: matrixHeaders.length - 1 } });
            currentRow++;

            XLSX.utils.sheet_add_aoa(wsSummary, [matrixHeaders], { origin: { r: currentRow, c: 0 } });
            currentRow++;
            matrixRows.forEach(function (rData) {
                var rowArray = [];
                matrixHeaders.forEach(function (hName) {
                    rowArray.push(rData[hName] !== undefined ? rData[hName] : "");
                });
                XLSX.utils.sheet_add_aoa(wsSummary, [rowArray], { origin: { r: currentRow, c: 0 } });
                currentRow++;
            });

            var matrixTotalRow = new Array(matrixHeaders.length).fill("");
            matrixTotalRow[0] = "Total";

            for (var c = 1; c < matrixHeaders.length; c++) {
                var colCat = matrixHeaders[c];
                var colSum = 0;
                matrixRows.forEach(function (r) {
                    colSum += parseInt(r[colCat] || 0);
                });
                matrixTotalRow[c] = colSum;
            }

            XLSX.utils.sheet_add_aoa(wsSummary, [matrixTotalRow], { origin: { r: currentRow, c: 0 } });
            currentRow += 3;
        }

        // --- SECTION 3: Activity Category-wise Summary ---
        if (activitySummaryData && activitySummaryData.length > 0) {
            var months = [];
            var locations = [];
            var pivotMap3 = {};
            var yearMap = {};
            var activityCountMap = {};

            activitySummaryData.forEach(function (item) {
                var month = item["Month"] || item["Plannedmonth"] || "Unknown";
                var year = item["Year"] || "";
                var loc = item["Location"] || item["BranchName"] || item["Branch"] || "Unknown";
                var exp = parseFloat(item["Actual Expense"] || item["ActualExpense"] || item["Expense"] || 0);
                var actCount = parseInt(item["Activity Count"] || 0);

                if (!months.includes(month)) months.push(month);
                if (!locations.includes(loc)) locations.push(loc);

                if (year) yearMap[month] = year;

                if (!pivotMap3[month]) pivotMap3[month] = {};
                pivotMap3[month][loc] = (pivotMap3[month][loc] || 0) + exp;

                if (!activityCountMap[month]) activityCountMap[month] = {};
                activityCountMap[month][loc] = (activityCountMap[month][loc] || 0) + actCount;
            });

            months.sort();
            locations.sort();

            var matrixHeaders3 = ["Month", "Year"].concat(locations).concat(["Total", "Activity Count"]);
            var matrixRows3 = [];

            months.forEach(function (m) {
                var rowObj = {};
                rowObj["Month"] = m;
                rowObj["Year"] = yearMap[m] || "";
                var rowTotal = 0;
                var rowActivityTotal = 0;

                locations.forEach(function (loc) {
                    var val = (pivotMap3[m] && pivotMap3[m][loc] !== undefined) ? pivotMap3[m][loc] : 0;
                    rowObj[loc] = Number(val.toFixed(2));
                    rowTotal += val;

                    rowActivityTotal += (activityCountMap[m] && activityCountMap[m][loc] !== undefined) ? activityCountMap[m][loc] : 0;
                });

                rowObj["Total"] = Number(rowTotal.toFixed(2));
                rowObj["Activity Count"] = rowActivityTotal;
                matrixRows3.push(rowObj);
            });

            XLSX.utils.sheet_add_aoa(wsSummary, [["Month and Location wise Expenses and Activity Count"]], { origin: { r: currentRow, c: 0 } });
            summaryMerges.push({ s: { r: currentRow, c: 0 }, e: { r: currentRow, c: matrixHeaders3.length - 1 } });
            currentRow++;

            XLSX.utils.sheet_add_aoa(wsSummary, [matrixHeaders3], { origin: { r: currentRow, c: 0 } });
            currentRow++;

            matrixRows3.forEach(function (rData) {
                var rowArray = [];
                matrixHeaders3.forEach(function (hName) {
                    rowArray.push(rData[hName] !== undefined ? rData[hName] : "");
                });
                XLSX.utils.sheet_add_aoa(wsSummary, [rowArray], { origin: { r: currentRow, c: 0 } });
                currentRow++;
            });

            var matrixTotalRow3 = new Array(matrixHeaders3.length).fill("");
            matrixTotalRow3[0] = "Total";
            matrixTotalRow3[1] = "";

            for (var c = 2; c < matrixHeaders3.length; c++) {
                var colName = matrixHeaders3[c];

                if (colName === "Activity Count") {
                    var colActivitySum = 0;
                    matrixRows3.forEach(function (r) {
                        colActivitySum += parseInt(r["Activity Count"] || 0);
                    });
                    matrixTotalRow3[c] = colActivitySum;
                } else if (colName !== "Total") {
                    var colSum = 0;
                    matrixRows3.forEach(function (r) {
                        colSum += parseFloat(r[colName] || 0);
                    });
                    matrixTotalRow3[c] = Number(colSum.toFixed(2));
                } else {
                    var grandTotal = 0;
                    matrixRows3.forEach(function (r) {
                        grandTotal += parseFloat(r["Total"] || 0);
                    });
                    matrixTotalRow3[c] = Number(grandTotal.toFixed(2));
                }
            }

            XLSX.utils.sheet_add_aoa(wsSummary, [matrixTotalRow3], { origin: { r: currentRow, c: 0 } });
            currentRow += 3;
        }

      

        wsSummary['!merges'] = summaryMerges;
        var summaryRange = XLSX.utils.decode_range(wsSummary['!ref'] || "A1:C1");
        var summaryCols = [];

        for (var R = summaryRange.s.r; R <= summaryRange.e.r; ++R) {
            for (var C = summaryRange.s.c; C <= summaryRange.e.c; ++C) {
                var cellAddr = XLSX.utils.encode_cell({ r: R, c: C });
                if (!wsSummary[cellAddr]) continue;

                var isTitleRow = false;
                var isHeaderRow = false;

                for (var m = 0; m < summaryMerges.length; m++) {
                    if (summaryMerges[m].s.r === R) {
                        isTitleRow = true;
                        break;
                    }
                    if (summaryMerges[m].s.r + 1 === R) {
                        isHeaderRow = true;
                        break;
                    }
                }

                var firstCellAddr = XLSX.utils.encode_cell({ r: R, c: 0 });
                var isTotalRow = false;
                if (wsSummary[firstCellAddr] && wsSummary[firstCellAddr].v === "Total") {
                    isTotalRow = true;
                }

                if (isTitleRow) {
                    wsSummary[cellAddr].s = titleStyle;
                } else if (isHeaderRow) {
                    wsSummary[cellAddr].s = headerStyle;
                } else if (isTotalRow) {
                    wsSummary[cellAddr].s = totalStyle;
                } else {
                    wsSummary[cellAddr].s = cellStyle;
                }

                var valStr = wsSummary[cellAddr].v ? wsSummary[cellAddr].v.toString() : "";
                if (!summaryCols[C] || valStr.length + 5 > summaryCols[C].wch) {
                    summaryCols[C] = { wch: Math.max(valStr.length + 5, 18) };
                }
            }
        }
        wsSummary['!cols'] = summaryCols;
        XLSX.utils.book_append_sheet(wb, wsSummary, "Summary");
    }
    ws['!cols'] = colWidths;
    XLSX.utils.book_append_sheet(wb, ws, "Details");
    // 4. Export File
    var formattedFrom = formatFileNameDate(fromDate);
    var formattedTo = formatFileNameDate(toDate);
    var fileName = "RecreationActivities_Expenses_Report_" + formattedFrom + "_" + formattedTo + ".xlsx";
    XLSX.writeFile(wb, fileName);
}

function calculateTotalRow(dataArray) {
    if (!dataArray || dataArray.length === 0) return [];
    var keys = Object.keys(dataArray[0]);
    var totalObj = new Array(keys.length).fill("");

    totalObj[0] = "Total"; 

    for (var c = 1; c < keys.length; c++) {
        var sum = 0;
        var isNumeric = true;
        for (var r = 0; r < dataArray.length; r++) {
            var val = dataArray[r][keys[c]];
            var num = parseFloat(val);
            if (isNaN(num)) {
                isNumeric = false;
                break;
            }
            sum += num;
        }
        if (isNumeric) {
            totalObj[c] = sum.toFixed(2);
        }
    }
    return totalObj;
}

// Get Year
document.addEventListener('DOMContentLoaded', function () {
    const yearSelect = document.getElementById('AdminExpYear');

    if (yearSelect) {
        const currentYear = new Date().getFullYear();

        for (let i = 0; i < 4; i++) {
            let year = currentYear - i; 
            let option = document.createElement('option');
            option.value = year;
            option.textContent = year;
            yearSelect.appendChild(option);
        }
    }
});