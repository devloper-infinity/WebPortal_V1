
var global_invoiceid = 0;


/*bind dropdown */
function hrinv_bindLocation() {

    //Working branch selection
    var select = document.getElementById("hrinv_location");
    let options = select.getElementsByTagName('option');


    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#hrinv_location").append($("<option></option>").val("Select").html("Select"));
    $.ajax({
        type: "POST", url: "CreateProfile.aspx/GetBranches", dataType: "json", contentType: "application/json",
        success: function (res) {
            $.each(res.d, function (data, value) {
                $("#hrinv_location").append($("<option></option>").val(value.BranchName).html(value.BranchName));
            })
        }
    });
}

function hrinv_bindAssignTo() {
    var select = $("#hrinv_assignto");
    select.empty(); // clear existing options
    select.append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST",
        url: "HRInvoice.aspx/GetDepartmentForInvoice",
        data: "{}", // must send JSON string
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (res) {
            console.log(res.d); // check the response in browser console
            //$.each(res.d, function (index, value) {
            //    select.append($("<option></option>").val(value.DepartmentID).html(value.DepartmentName));
            //});


            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (data, value) {

                $("#hrinv_assignto").append($("<option></option>").val(value.DepartmentID).html(value.DepartmentName));
            })

        },
        error: function (xhr, status, error) {
            console.log("AJAX Error: " + error);
        }
    });
}

function hrinv_bindEmployees() {

    var select = $("#hrinv_user");
    select.empty(); // clear existing options
    select.append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "SkipLevelMeeting.aspx/GetAllEmployees", dataType: "json", contentType: "application/json",
        success: function (res) {

            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (data, value) {

                $("#hrinv_user").append($("<option></option>").val(value.EmployeeID).html(value.FullName));
            })
        }
    });
}

function hrinv_bindemployeeInfo(dropdown) {

    var empId = $(dropdown).val(); // get selected value from dropdown

    $.ajax({
        type: "POST",
        url: "EmployeeComments.aspx/GetUserInformation",
        dataType: "json",
        data: "{EmployeeId:" + empId + "}",
        contentType: "application/json",

        success: function (res) {
            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (data, value) {

                $("#hrinv_joiningdate").val(value.JoiningDate || "-");
                $("#hrinv_salary").val(value.Salary || "-");
                $("#hrinv_ctc").val(value.YearSalary || "-");
                $("#hrinv_tenure").val(value.Tenure || "-");
            })
        }
    });
    return false;
}

function core_hrinv_SubmitData() {

    // var btntext = $("#hrinv_btn").text();

    // Collect form data
    var code = $("#hrinv_user option:selected").text().substring(0, 3)
    var empid = $("#hrinv_user").val();
    var location = $("#hrinv_location").val();

    alert(location);

    var invoiceType = $("#hrinv_invtype").val();
    var invoiceNo = $("#hrinv_invNo").val().trim();
    var consultancy = $("#hrinv_consultancy").val().trim();
    var accountNo = $("#hrinv_accountNo").val().trim();
    var circuitID = $("#hrinv_circuitID").val().trim();
    var fromDate = $("#hrinv_fromdate").val();
    var toDate = $("#hrinv_todate").val();
    var dueDate = $("#hrinv_duedate").val();
    var amount = $("#hrinv_amount").val();
    var gstNo = $("#hrinv_gstNo").val().trim();
    var pan = $("#hrinv_PAN").val().trim();
    var assignTo = $("#hrinv_assignto").val();
    var category = $("#hrinv_category").val();
    var remark = $("#hrinv_remark").val().trim();
    var contractCondition = $("#hrinv_contractCondition").val().trim();
    var vendorPayment = $("#hrinv_vendorPayment").val().trim();

    // Validation
    if (location === "") { alert("Please select Location"); return false; }
    if (invoiceType === "") { alert("Please select Invoice Type"); return false; }
    if (invoiceNo === "") { alert("Please enter Invoice #"); return false; }
    if (consultancy === "") { alert("Please enter Consultancy"); return false; }
    if (accountNo === "") { alert("Please enter Account #"); return false; }
    if (circuitID === "") { alert("Please enter Circuit ID"); return false; }
    if (fromDate === "") { alert("Please select From Date"); return false; }
    if (toDate === "") { alert("Please select To Date"); return false; }
    if (new Date(toDate) < new Date(fromDate)) { alert("To Date cannot be earlier than From Date"); return false; }
    if (dueDate === "") { alert("Please select Due Date"); return false; }
    if (amount === "" || isNaN(amount) || Number(amount) <= 0) { alert("Please enter a valid Amount"); return false; }

    if (parseFloat(amount) > 5000) {
        if (gstNo === "") { alert("Please enter GST #"); return false; }
        if (pan === "") { alert("Please enter PAN"); return false; }
    }
    if (assignTo === "") { alert("Please select Assign To"); return false; }
    if (category === "") { alert("Please select Category"); return false; }
    if (remark === "") { alert("Please enter Remark"); return false; }
    if (contractCondition === "") { alert("Please enter Contract Condition"); return false; }
    if (vendorPayment === "") { alert("Please enter Vendor Payment details"); return false; }

    // Optional: validate invoice file
    var invoiceFile = $("#hrinv_invoiceImage").val();
    if (invoiceFile === "") { alert("Please upload Invoice file"); return false; }

    // ✅ Call PageMethod
    PageMethods.SaveInvoice(global_invoiceid, empid, code,
        location, invoiceType, invoiceNo, consultancy, accountNo, circuitID,
        fromDate, toDate, dueDate, amount, gstNo, pan, assignTo, category,
        remark, contractCondition, vendorPayment,
        function (response) {
            alert(response);
            hrinv_ClearAllData(); // clear form
            hr_bindInvoice();
        },
        function (error) {
            alert("Error: " + error.get_message());
        }
    );

    return false; // prevent default form submit
}

function hrinv_SubmitData() {

    var code = $("#hrinv_user option:selected").text().substring(0, 3);
    var empid = $("#hrinv_user").val();
    var location = $("#hrinv_location").val();

    var invoiceType = $("#hrinv_invtype").val();
    var invoiceNo = $("#hrinv_invNo").val().trim();
    var consultancy = $("#hrinv_consultancy").val().trim();
    var accountNo = $("#hrinv_accountNo").val().trim();
    var circuitID = $("#hrinv_circuitID").val().trim();
    var fromDate = $("#hrinv_fromdate").val();
    var toDate = $("#hrinv_todate").val();
    var dueDate = $("#hrinv_duedate").val();
    var amount = $("#hrinv_amount").val();
    var gstNo = $("#hrinv_gstNo").val().trim();
    var pan = $("#hrinv_PAN").val().trim();
    var assignTo = $("#hrinv_assignto").val();
    var category = $("#hrinv_category").val();
    var remark = $("#hrinv_remark").val().trim();
    var contractCondition = $("#hrinv_contractCondition").val().trim();
    var vendorPayment = $("#hrinv_vendorPayment").val().trim();

    // Validation
    if (location === "") {
        swal("Validation", "Please select Location", "warning");
        return false;
    }

    if (invoiceType === "") {
        swal("Validation", "Please select Invoice Type", "warning");
        return false;
    }

    if (invoiceNo === "") {
        swal("Validation", "Please enter Invoice #", "warning");
        return false;
    }

    if (consultancy === "") {
        swal("Validation", "Please enter Consultancy", "warning");
        return false;
    }

    if (accountNo === "") {
        swal("Validation", "Please enter Account #", "warning");
        return false;
    }

    if (circuitID === "") {
        swal("Validation", "Please enter Circuit ID", "warning");
        return false;
    }

    if (fromDate === "") {
        swal("Validation", "Please select From Date", "warning");
        return false;
    }

    if (toDate === "") {
        swal("Validation", "Please select To Date", "warning");
        return false;
    }

    if (new Date(toDate) < new Date(fromDate)) {
        swal("Validation", "To Date cannot be earlier than From Date", "error");
        return false;
    }

    if (dueDate === "") {
        swal("Validation", "Please select Due Date", "warning");
        return false;
    }

    if (amount === "" || isNaN(amount) || Number(amount) <= 0) {
        swal("Validation", "Please enter a valid Amount", "warning");
        return false;
    }

    if (parseFloat(amount) > 5000) {
        if (gstNo === "") {
            swal("Validation", "Please enter GST #", "warning");
            return false;
        }

        if (pan === "") {
            swal("Validation", "Please enter PAN", "warning");
            return false;
        }
    }

    if (assignTo === "") {
        swal("Validation", "Please select Assign To", "warning");
        return false;
    }

    if (category === "") {
        swal("Validation", "Please select Category", "warning");
        return false;
    }

    if (remark === "") {
        swal("Validation", "Please enter Remark", "warning");
        return false;
    }

    if (contractCondition === "") {
        swal("Validation", "Please enter Contract Condition", "warning");
        return false;
    }

    if (vendorPayment === "") {
        swal("Validation", "Please enter Vendor Payment details", "warning");
        return false;
    }

    var invoiceFile = $("#hrinv_invoiceImage").val();

    if (invoiceFile === "") {
        swal("Validation", "Please upload Invoice file", "warning");
        return false;
    }

    // Save Data
    PageMethods.SaveInvoice(global_invoiceid, empid, code, location, invoiceType, invoiceNo, consultancy, accountNo, circuitID, fromDate, toDate, dueDate, amount, gstNo, pan, assignTo, category, remark, contractCondition, vendorPayment,
        function (response) {

            if (response.includes("Invoice Created successfully")) {

                swal("Success", response, "success");

                hrinv_ClearAllData();
                hr_bindInvoice();
            }
            else if (response.includes("Invoice Updated Successfully")) {

                swal("Success", response, "success");

                hrinv_ClearAllData();
                hr_bindInvoice();
            }
            else if (response.includes("Invoice already exist")) {

                swal("Duplicate", response, "warning");
            }
            else if (response.includes("Error while creating the invoice")) {

                swal("Error", response, "error");
            }
            else {

                swal("Info", response, "info");
            }
        },

        function (error) {

            swal("Error", error.get_message(), "error");
        }
    );

    return false;
}

function hr_bindInvoice() {

    $('#load1').show();

    $.ajax({
        url: 'HRInvoice.aspx/GetHRInvoice',
        type: "POST",
        contentType: "application/json",
        success: function (data) {

            var dataArray = JSON.parse(data.d);

            // Destroy existing DataTable
            if ($.fn.DataTable.isDataTable('#table_hrInvoice')) {
                $('#table_hrInvoice').DataTable().clear().destroy();
            }

            $('#table_hrInvoice tbody').empty();

            $('#table_hrInvoice').DataTable({
                dom: 'lBfrtip',
                data: dataArray,
                scrollX: true,
                paging: true,
                processing: true,
                ordering: false,
                serverSide: false,
                autoWidth: false,
                columns: [

                    //  Action
                    {
                        data: "HRInvoiceId",
                        render: function (data, type, row, meta) {
                            // meta.row is the index
                            return '<a href="#!" onclick="edit_hrinvoice(' + data + ', ' + meta.row + ')">' +
                                '<i class="uil-edit" style="color:blue"></i></a>';
                        }
                    },

                    // Attachment  FilePath
                    {
                        data: "FPath1",
                        render: function (data, type, row) {

                            if (data && data.trim() !== "") {
                                return '<a href="#!" onclick="download_hrinvoice(\'' + data + '\')">' +
                                    '<i class="uil-cloud-download" style="color:green"></i></a>';
                            }
                            else {
                                return '<span style="color:lightgray"><i class="uil-cloud-download"></i></span>';
                            }
                        }
                    },

                    // Sr No
                    {
                        data: null,
                        className: "text-center",
                        render: function (data, type, row, meta) {
                            return meta.row + 1;
                        }
                    },

                    { data: "InvoiceNo" },
                    { data: "HRInvoiceType" },
                    { data: "Category" },
                    { data: "EmployeeName" },
                    { data: "Location" },
                    { data: "VendorName" },
                    { data: "AccountNo" },
                    { data: "GSTNO" },
                    { data: "PAN" },
                    { data: "CircuitNo" },
                    { data: "FromDate" },
                    { data: "ToDate" },
                    { data: "DueDate" },
                    { data: "BillAmount" },
                    { data: "AssignTo" },
                    { data: "Remark" },
                    {
                        data: "VendorConditions",
                        render: function (data) {
                            return '<div style="width:1200px; white-space:normal;">' + (data || '') + '</div>';
                        }
                    },
                    {
                        data: "PaymentConditions",
                        render: function (data) {
                            return '<div style="width:1200px; white-space:normal;">' + (data || '') + '</div>';
                        }
                    },
                    { data: "AddedBy" },
                    { data: "AddedDate" },
                    { data: "EmpID", visible: false },
                    { data: "AssignToDept", visible: false }
                ],
                buttons: [
                    {
                        extend: 'excelHtml5',
                        text: 'Export Excel',
                        title: 'HR Invoice Report',
                        exportOptions: {
                            columns: ':not(:nth-child(1)):not(:nth-child(2)):not(:nth-last-child(1)):not(:nth-last-child(2))'
                        }
                    }
                ],

                initComplete: function () {
                    $('#load1').hide();
                }
            });
        },

        error: function (error) {
            $('#load1').hide();
            alert(error.responseText);
        }
    });
}


function edit_hrinvoice(id, index) {

    $("#hrinv_btn").text("Update");

    global_invoiceid = id;

    var table = $('#table_hrInvoice').DataTable();
    var data = table.row(index).data();

    //Location
    var select = document.getElementById("hrinv_location");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#hrinv_location").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "CreateProfile.aspx/GetBranches", dataType: "json", contentType: "application/json",
        success: function (res) {
            $.each(res.d, function (data, value) {
                $("#hrinv_location").append($("<option></option>").val(value.BranchName).html(value.BranchName));
            })
            $('#hrinv_location').val(data.Location);
        }
    });


    ////Asign To
    //var select = $("#hrinv_assignto");
    //select.empty();
    //select.append($("<option></option>").val("").html("Select"));
    //$.ajax({
    //    type: "POST",
    //    url: "HRInvoice.aspx/GetDepartmentForInvoice",
    //    data: "{}",
    //    dataType: "json",
    //    contentType: "application/json; charset=utf-8",
    //    success: function (res) {

    //        var dataArray = JSON.parse(res.d);

    //        $.each(dataArray, function (data, value) {

    //            $("#hrinv_assignto").append($("<option></option>").val(value.DepartmentID).html(value.DepartmentName));
    //        })
    //        $('#hrinv_assignto').val(data.AssignToDept);
    //    },
    //    error: function (xhr, status, error) {
    //        console.log("AJAX Error: " + error);
    //    }
    //});

    //hrinv_bindEmployees();

    // Employee Information

    $('#hrinv_user').focus();
    $('#hrinv_user').val(data.EmpID); // set selected value
    $('#hrinv_joiningdate').val(data.JoiningDate);
    $('#hrinv_tenure').val(data.Tenure);
    $('#hrinv_salary').val(data.Salary);
    $('#hrinv_ctc').val(data.CTC);

    // Invoice Details
    $('#hrinv_location').text(data.Location);
    $('#hrinv_assignto').val(data.AssignToDept);
    $('#hrinv_invtype').val(data.HRInvoiceType);
    $('#hrinv_invNo').val(data.InvoiceNo);
    $('#hrinv_consultancy').val(data.VendorName);
    $('#hrinv_accountNo').val(data.AccountNo);
    $('#hrinv_circuitID').val(data.CircuitNo);
    $('#hrinv_fromdate').val(formatdate(data.FromDate));
    $('#hrinv_todate').val(formatdate(data.ToDate));
    $('#hrinv_duedate').val(formatdate(data.DueDate));
    $('#hrinv_amount').val(data.BillAmount);
    $('#hrinv_gstNo').val(data.GSTNO);
    $('#hrinv_PAN').val(data.PAN);
    $('#hrinv_category').val(data.Category);
    $('#hrinv_remark').val(data.Remark);
    $('#hrinv_contractCondition').val(data.VendorConditions);
    $('#hrinv_vendorPayment').val(data.PaymentConditions);

}

function download_hrinvoice(path) {

    /*   alert(path);*/

    window.location.href = "../Handler/Download.ashx?HrInvoicePath=" + path;
}


// Function to clear all form fields
function hrinv_ClearAllData() {

    // Clear dropdowns
    $("#hrinv_user").val("Select");
    $("#hrinv_location").val("Select");
    $("#hrinv_invtype").val("Select");
    $("#hrinv_assignto").val("Select");
    $("#hrinv_category").val("Select");

    // Clear text inputs
    $("#hrinv_joiningdate").val("");
    $("#hrinv_tenure").val("");
    $("#hrinv_salary").val("");
    $("#hrinv_ctc").val("");
    $("#hrinv_invNo").val("");
    $("#hrinv_consultancy").val("");
    $("#hrinv_accountNo").val("");
    $("#hrinv_circuitID").val("");
    $("#hrinv_fromdate").val("");
    $("#hrinv_todate").val("");
    $("#hrinv_duedate").val("");
    $("#hrinv_amount").val("");
    $("#hrinv_gstNo").val("");
    $("#hrinv_PAN").val("");

    // Clear textareas
    $("#hrinv_remark").val("");
    $("#hrinv_contractCondition").val("");
    $("#hrinv_vendorPayment").val("");

    // Clear file input
    $("#hrinv_attachment").val("");

}

function formatdate(prv_date) {

    var date = new Date(prv_date);
    var day = date.getDate();
    if (day < 10)
        day = '0' + day
    var month = date.getMonth() + 1;
    if (month < 10)
        month = '0' + month
    var year = date.getFullYear();
    var actualdate = year + "-" + (month) + "-" + (day);

    return actualdate;
} 