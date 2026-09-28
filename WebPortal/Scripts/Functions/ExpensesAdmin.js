//Submit Activity Category
function ExpensesActivityCategorySubmit() {
    var AdminExp_ActivityCategory = $("#AdminExp_ActivityCategory").val();
    var activityId = $('#hdnActivityCategoryId').val(); // <--- इथून ID घेतला
    if (AdminExp_ActivityCategory === "") {
        Swal.fire("Validation", "Please Select Activity Category", "warning");
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
            if (serverMessage === "Activity Category saved successfully!") {
                Swal.fire("Success", serverMessage, "success").then((result) => {
                    if (result.isConfirmed) {
                        ClearActivityCategory();
                        GetAdminExpActivityCategory();
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
    $("#AdminExp_ActivityCategory").val("");
    $('#AdminExpActivityCategorybtnText').text("Submit");
    $('#AdminExpActivityCategory_btnIcon').removeClass("fa-edit").addClass("fa-paper-plane");
    $("#adminexpactivity").val("");
    $("#dlladminExpensesActivity").val("").trigger('change');
    $('#adminexpactivitybtnText').text("Submit");
    $('#adminexpactivitybtnicon').removeClass("fa-edit").addClass("fa-paper-plane");

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
            if (serverMessage === "Activity saved successfully!") {
                Swal.fire("Success", serverMessage, "success").then((result) => {
                    if (result.isConfirmed) {
                        GetAdminExpActivity();
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
$(document).on('change', '#dllExpensesBudgetActivityCategory', function () {
    var categoryId = $(this).val();
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
            var preSelectedActivity = $activityDropdown.data('selected-activity');
            if (preSelectedActivity) {
                $activityDropdown.val(preSelectedActivity);
                $activityDropdown.removeData('selected-activity');
            }
        },
        error: function (xhr, status, error) {
            console.log("Error fetching activities: " + error);
        }
    });
});
// Bind Location
function bindAdminExpLocation() {
    var select = document.getElementById("dllAdminExpLocation");
    let options = select.getElementsByTagName('option');
    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#dllAdminExpLocation").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "CreateProfile.aspx/GetBranches", dataType: "json", contentType: "application/json",
        success: function (res) {
            $.each(res.d, function (data, value) {
                $("#dllAdminExpLocation").append($("<option></option>").val(value.BranchID).html(value.BranchName));
            })
        }
    });

}
function ExpensesAdminYearlybudgetSubmit() {
    var budgetId = $('#hdnExpensesBugetId').val();
    var categoryId = $('#dllExpensesBudgetActivityCategory').val();
    var activityId = $('#dllExpensesActivity').val();
    var locationId = $('#dllAdminExpLocation').val();
    var year = $('#yearly_year_dropdown').val();
    var budget = $('#yearly_budget_input').val();
    if (!categoryId) { alert('Krupaya Activity Category select kara!'); $('#dllExpensesBudgetActivityCategory').focus(); return; }
    if (!activityId) { alert('Krupaya Activity select kara!'); $('#dllExpensesActivity').focus(); return; }
    if (!locationId) { alert('Krupaya Location select kara!'); $('#dllAdminExpLocation').focus(); return; }
    if (!year) { alert('Krupaya Year select kara!'); $('#yearly_year_dropdown').focus(); return; }
    if (!budget || budget <= 0) { alert('Krupaya yogya Budget amount taka!'); $('#yearly_budget_input').focus(); return; }

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
            if (resMsg.indexOf("successfully") !== -1) {
                alert(resMsg);
            } else {
                alert(resMsg);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr.responseText);
            alert('Server sobat connect hotana error ala.');
        },
        complete: function () {
            $btn.prop('disabled', false);
            $icon.removeClass('fa-spinner fa-spin').addClass('fa-paper-plane');
            $text.text('Submit');
        }
    });
}
// Clear Function
function ClearActivityCategory() {
    $('#dllExpensesBudgetActivityCategory').val('').trigger('change');
    $('#dllExpensesActivity').empty().append('<option value="">-- Select Activity --</option>');
    $('#dllAdminExpLocation').val('');
    $('#yearly_year_dropdown').val('');
    $('#yearly_budget_input').val('');
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
    $('#yearly_year_dropdown').val(year);
    $('#yearly_budget_input').val(budget);
    $('#adminexpYearlybudgetbtnText').text('Update');
    $('#adminexpYearlybudgetbtnicon').removeClass('fa-paper-plane').addClass('fa-edit');
}

















//Fetch Recreation Activity For Details
function bindExpdetailsRecreationActivity() {
    var select = document.getElementById("dllexpdetailsRecreationActivity");
    let options = select.getElementsByTagName('option');
    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#dllexpdetailsRecreationActivity").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "ExpensesAdmin.aspx/GetRecreationActivity", dataType: "json", contentType: "application/json",
        success: function (res) {
            $.each(res.d, function (data, value) {
                $("#dllexpdetailsRecreationActivity").append($("<option></option>").val(value.RecreationActivityId).html(value.RecreationActivity));
            })
        }
    });

}

//Quater Dropdown Enable when select RnR Value
$(document).on('change', '#dllexpdetailsRecreationActivity', function () {
    // ID aivaji selected option cha visible text milvnyasathi:
    let selectedText = $("#dllexpdetailsRecreationActivity option:selected").text();
    let isRewards = selectedText.trim() === "Rewards and Recognition";

    console.log("Selected Text:", selectedText);
    console.log("Is Rewards and Recognition?", isRewards);

    $('#quarterDropdownBtn').prop('disabled', !isRewards);

    $('#otherFieldContainer').css({
        'opacity': isRewards ? '1' : '0.5',
        'pointer-events': isRewards ? 'auto' : 'none'
    });

    if (!isRewards) {
        $('#otherFieldContainer input[type="checkbox"]').prop('checked', false);
        $('#select_all_quarter').prop('checked', false);
        $('#quarterDropdownBtn').text('Select Quarter');
    }
});


// Bind Location
function bindLocation() {
    var select = document.getElementById("location");
    let options = select.getElementsByTagName('option');


    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#location").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "CreateProfile.aspx/GetBranches", dataType: "json", contentType: "application/json",
        success: function (res) {
            $.each(res.d, function (data, value) {
                $("#location").append($("<option></option>").val(value.BranchID).html(value.BranchName));
            })
        }
    });

}

// //Bind Planned Month dropdown
// function bindPlannedMonth() {
//     const dropdown = document.getElementById("PlannedMonth");
//     const currentYear = new Date().getFullYear();
//     $("#PlannedMonth").append($("<option></option>").val("").html("Select"));
//     for (let m = 0; m < 12; m++) {
//         const monthName = new Date(currentYear, m).toLocaleString('default', { month: 'short' });
//         dropdown.innerHTML += `<option value="${monthName}-${currentYear}">${monthName}-${currentYear}</option>`;
//     }

// }


//Submit Data
function ExpenseSubmitData() {
    var expenseId = $("#hdnExpenseId").val() || 0;

    var locationId = $("#location").val();
    var expdetailsRecreationActivity = $("#dllexpdetailsRecreationActivity").val();
    var selectedQuarters = [];
    $("input[name='ExpAdminQuarter']:checked").each(function () {
        selectedQuarters.push($(this).val());
    });
    var quarter = selectedQuarters.join(", ");
    var expActivitiesMonth = $("#expActivitiesMonth").val();
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
        Swal.fire("Validation", "Please Select Recreation Activity", "warning");
        return;
    }
    if (expActivitiesMonth === "" || expActivitiesMonth === "Select") {
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
    var formData = {
        expenseId: expenseId,
        LocationId: locationId,
        RecreationActivity: expdetailsRecreationActivity,
        Quarter: quarter,
        ActivitiesMonth: expActivitiesMonth,
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
            Swal.fire("Success", "Data saved successfully!", "success").then((result) => {
                if (result.isConfirmed) {
                    $("#hdnExpenseId").val("0");
                    BindAdminExpenseData();
                    ClearExpenseForm();
                }
            });
        },
        error: function (xhr, status, error) {
            alert("Error" + error);
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
                var defaultColumns = ['Location', 'Recreation Activity', 'Date', 'Completed Date', 'Actual Expense', 'Status', 'Remark'];
                var headerHtml = "<tr><th>Action</th>" + defaultColumns.map(c => "<th>" + c + "</th>").join("") + "</tr>";
                $thead.append(headerHtml);

                $tbody.append("<tr><td colspan='" + (defaultColumns.length + 1) + "' style='text-align:center;'>No data found</td></tr>");
                $('#load1').hide();
                return;
            }
            var columns = Object.keys(data[0]).filter(c => c !== 'ExpensesId');

            var headerHtml = "<tr><th>Action</th>" + columns.map(c => "<th>" + c + "</th>").join("") + "</tr>";
            $thead.append(headerHtml);
            var rowsHtml = data.map((row, index) => {
                var actionCell = `<td><a href='javascript:void(0);' class='update-btn text-primary' onclick='EditExpenseRow(${index})' title='Update'><i class='fas fa-edit fa-lg'></i></a></td>`;
                var cells = columns.map(c => "<td>" + (row[c] !== null ? row[c] : "") + "</td>").join("");
                return `<tr id='row_${index}'>` + actionCell + cells + "</tr>";
            }).join("");

            $tbody.append(rowsHtml);
            window.adminExpenseData = data;
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
                        "targets": 9, 
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
    $('#location option').each(function () {
        if ($(this).text().trim() === locName.trim() || $(this).val() == locName) {
            $('#location').val($(this).val());
            return false;
        }
    });

    var recActivity = data["Recreation Activity"] || data["RecreationActivity"] || 'Select';
    var matched = false;

    $('#RecreationActivity option').each(function () {
        if (($(this).val() === recActivity || $(this).text().trim() === recActivity.trim()) && $(this).val() !== "Other") {
            matched = true;
            $('#RecreationActivity').val($(this).val());
        }
    });

    if (!matched && recActivity && recActivity !== 'Select') {
        $('#RecreationActivity').val("Other");
        $('#RecreationActivity').trigger('change');
        $('#otherActivity').val(recActivity);
        $('#otherActivity').removeAttr("readonly"); 
    } else {
        $('#RecreationActivity').trigger('change');
       // showSelectedValue();
    }

    // 1. Fixed Date Bind (Converted to YYYY-MM-DD format)
    var expenseDateStr = data["Date"] || '';
    if (expenseDateStr) {
        var parsedDate = new Date(expenseDateStr);
        if (!isNaN(parsedDate.getTime())) {
            $('#Date').val(parsedDate.toISOString().split('T')[0]);
        } else {
            $('#Date').val(expenseDateStr);
        }
    } else {
        $('#Date').val('');
    }

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

    $("#location").val("").trigger('change'); 
    $("#RecreationActivity").val("Select").trigger('change');
    $("#otherActivity").val("").attr("readonly", true);
    $("#Date").val("");
    $("#CompletedDate").val("");
    $("#ActualExpense").val("");
    $("#Status").val("Select");
    $("#remark").val("");

    $('#btnText').text("Submit");
    $('#btnIcon').removeClass("fa-edit").addClass("fa-paper-plane");
}


//Report Table Bind Data

var globalAdminExpenseData = [];
function BindAdminExpenseDataForReport() {
    $('#load1').show();
    var ExpensesFromDate = document.getElementById("ExpensesFromDate").value;
    var ExpensesToDate = document.getElementById("ExpensesToDate").value;
    if (ExpensesFromDate == "") {
        $('#load1').hide();
        Swal.fire("Validation", "Please select from date", "warning");
        return false;
    }
    if (ExpensesToDate == "") {
        $('#load1').hide();
        Swal.fire("Validation", "Please select to date", "warning");
        return false;
    }
    if (ExpensesToDate < ExpensesFromDate) {
        $('#load1').hide();
        Swal.fire("Validation", "Please ensure that the To Date is after the From Date.", "warning");
        return false;
    }
    if ($.fn.DataTable.isDataTable('#AdminExpenseReport_table')) {
        $('#AdminExpenseReport_table').DataTable().clear().destroy();
    }
    $.ajax({
        type: "POST",
        data: "{FromDate:'" + ExpensesFromDate + "', ToDate:'" + ExpensesToDate + "'}",
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
            // Store all summary datasets in table elements (hidden from UI)
            $('#AdminExpenseReport_table').data('summaryData', summaryData);
            $('#AdminExpenseReport_table').data('locationSummaryData', locationSummaryData);
            $('#AdminExpenseReport_table').data('activitySummaryData', activitySummaryData);

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
    var ExpensesFromDate = document.getElementById("ExpensesFromDate").value;
    var ExpensesToDate = document.getElementById("ExpensesToDate").value;

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
        var maxCols = 3;

        // --- SECTION 1: Month-wise Summary ---
        if (summaryData && summaryData.length > 0) {
            XLSX.utils.sheet_add_aoa(wsSummary, [["Month-wise Expense Summary"]], { origin: { r: currentRow, c: 0 } });
            summaryMerges.push({ s: { r: currentRow, c: 0 }, e: { r: currentRow, c: Object.keys(summaryData[0]).length - 1 } });
            currentRow++;

            XLSX.utils.sheet_add_aoa(wsSummary, [Object.keys(summaryData[0])], { origin: { r: currentRow, c: 0 } });
            currentRow++;

            XLSX.utils.sheet_add_json(wsSummary, summaryData, { origin: { r: currentRow, c: 0 }, skipHeader: true });
            currentRow += summaryData.length;
            var totalRow1 = calculateTotalRow(summaryData);
            XLSX.utils.sheet_add_aoa(wsSummary, [totalRow1], { origin: { r: currentRow, c: 0 } });
            currentRow += 3; 
        }

        // --- SECTION 2: Location-wise Summary ---
        if (locationSummaryData && locationSummaryData.length > 0) {
            XLSX.utils.sheet_add_aoa(wsSummary, [["Location-wise Expense Summary"]], { origin: { r: currentRow, c: 0 } });
            summaryMerges.push({ s: { r: currentRow, c: 0 }, e: { r: currentRow, c: Object.keys(locationSummaryData[0]).length - 1 } });
            currentRow++;

            XLSX.utils.sheet_add_aoa(wsSummary, [Object.keys(locationSummaryData[0])], { origin: { r: currentRow, c: 0 } });
            currentRow++;

            XLSX.utils.sheet_add_json(wsSummary, locationSummaryData, { origin: { r: currentRow, c: 0 }, skipHeader: true });
            currentRow += locationSummaryData.length;

            // Total Row for Section 2
            var totalRow2 = calculateTotalRow(locationSummaryData);
            XLSX.utils.sheet_add_aoa(wsSummary, [totalRow2], { origin: { r: currentRow, c: 0 } });
            currentRow += 3;
        }

        // --- SECTION 3: Activity Category-wise Summary ---
        if (activitySummaryData && activitySummaryData.length > 0) {
            XLSX.utils.sheet_add_aoa(wsSummary, [["Activity Category-wise Summary"]], { origin: { r: currentRow, c: 0 } });
            summaryMerges.push({ s: { r: currentRow, c: 0 }, e: { r: currentRow, c: Object.keys(activitySummaryData[0]).length - 1 } });
            currentRow++;

            XLSX.utils.sheet_add_aoa(wsSummary, [Object.keys(activitySummaryData[0])], { origin: { r: currentRow, c: 0 } });
            currentRow++;

            XLSX.utils.sheet_add_json(wsSummary, activitySummaryData, { origin: { r: currentRow, c: 0 }, skipHeader: true });
            currentRow += activitySummaryData.length;

            // Total Row for Section 3
            var totalRow3 = calculateTotalRow(activitySummaryData);
            XLSX.utils.sheet_add_aoa(wsSummary, [totalRow3], { origin: { r: currentRow, c: 0 } });
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
    var fileName = "Expenses_" + formattedFrom + "_" + formattedTo + ".xlsx";
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