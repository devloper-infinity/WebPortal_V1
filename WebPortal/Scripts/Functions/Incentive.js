
var global_incentiveID = 0;
var global_prodIncentiveID = 0;

function incentive_bindEmployees() {

    var select = document.getElementById("incentive_employee");
    let options = select.getElementsByTagName('incentive_employee');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#incentive_employee").append($("<option></option>").val("Select").html("Select"));

    $.ajax({
        type: "POST", url: "IncentiveMaster.aspx/GetAllUsers", dataType: "json", contentType: "application/json",
        success: function (res) {

            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (data, value) {

                $("#incentive_employee").append($("<option></option>").val(value.Code).html(value.FullName));
            })
        }
    });
}

function incentive_bindYear() {

    var currentYear = new Date().getFullYear();
    var startYear = currentYear - 5;
    var endYear = currentYear;

    var $year = $("#incentive_year");
    $year.empty();
    $year.append('<option value="">Select</option>');

    for (var y = startYear; y <= endYear; y++) {
        $year.append('<option value="' + y + '">' + y + '</option>');
    }
}

function Incentive_bindGrid(month, year) {

    month = "june";
    year = "2017";

    $('#load1').show();
    $.ajax({
        type: "POST",
        url: "IncentiveMaster.aspx/GetAllIncentives",
        dataType: "json",
        data: "{Month:'" + month + "',Year:'" + year + "'}",
        contentType: "application/json",
        success: function (data) {

            var dataArray = JSON.parse(data.d);

            var rowCount = data.d.length;

            if ($.fn.DataTable.isDataTable('#table_incentive')) {
                $('#table_incentive').DataTable().clear().destroy();
            }

            var table = $('#table_incentive').DataTable({
                dom: 'lBftp',
                data: dataArray,
                scrollX: false,
                paging: true,

                //autoWidth: true,
                processing: true,
                ordering: false,
                serverSide: false,
                columns: [
                    {
                        data: null,
                        render: function (data, type, row, meta) {
                            return `
                                <a href="javascript:void(0);" title="Edit" onclick="edit_Incentive(${row.ID}, ${meta.row});"><i class="uil uil-edit-alt text-primary"></i></a>
                                &nbsp;&nbsp;
                                <a href="javascript:void(0);" title="Delete" onclick="incentive_delete(${row.ID});"><i class="uil uil-trash-alt text-danger"></i></a>`;
                        }
                    },
                    { data: "SrNo", className: "text-center" },
                    { data: "Code" },
                    { data: "FullName" },
                    { data: "Month" },
                    { data: "Year" },
                    { data: "Amount", className: "text-center" },
                    { data: "Status" },
                    { data: "Remark" },
                    { data: "AddedByName" },
                    { data: "AddedDate" },
                    { data: "ID", visible: false }
                ],

                buttons: [
                    {
                        extend: 'excelHtml5',
                        text: 'Export Excel',
                        title: 'Incentive Master',
                        exportOptions: { columns: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }
                    }
                ],
                initComplete: function () {
                    $('#load1').hide();
                }
            });
        },

        error: function (error) {
            alert('Error: ' + error.responseText);
        }
    });

    return false;
}

/* edit */
function edit_Incentive(id, index) {

    var table = $('#table_incentive').DataTable();

    global_incentiveID = id;

    // ✅ Remove highlight from all rows first
    $('#table_incentive tbody tr').removeClass("highlightRow");

    // ✅ Get row data & node
    var rowData = table.row(index).data();
    var rowNode = table.row(index).node();

    if (!rowData) {
        alert("Row data not found");
        return;
    }

    // ✅ Add highlight to selected row
    $(rowNode).addClass("highlightRow");

    // Show reset button
    $("#incentive_btnreset").show();

    // Focus
    $("#incentive_employee").focus();

    // Bind values
    $("#incentive_employee").val(rowData.Code).trigger('change');
    $("#incentive_month").val(rowData.Month);
    $("#incentive_year").val(rowData.Year);
    $("#incentive_amount").val(rowData.Amount);
    $("#incentive_remark").val(rowData.Remark);

    // Make fields non-editable
    $("#incentive_employee").prop("disabled", true);
    $("#incentive_month").prop("disabled", true);
    $("#incentive_year").prop("disabled", true);
    $("#incentive_remark").prop("readonly", true);

    // Change button text
    $("#incentive_btnsubmit").text("Update");
}

/* delete */
function incentive_delete(id) {
    global_incentiveID = id;
    $('#incentive_delete').modal('show');
}

function incentive_btndelete() {

    PageMethods.DeleteIncentive(global_incentiveID, incentive_DeleteOnSuccess, incentive_DeleteOnError);
    return false;
}

function incentive_DeleteOnSuccess(result) {

    if (result > 0) {
        $('#incentive_delete').modal('hide');
        document.getElementById("incentive_errmsg").innerHTML = "Record deleted successfully!";
        global_incentiveID = 0;
        $('#incentive_dverror').modal('show');
    }

    else {
        $('#incentive_delete').modal('hide');
        document.getElementById("incentive_errmsg").innerHTML = "Oops! Error occured while deleting record. Please contact administrator!";
        document.getElementById("incentive_errmsg").style.color = 'red';
        $('#incentive_dverror').modal('show');
    }

    return false;
}

function incentive_DeleteOnError(error) {
    alert(error);
}

function incentive_Message() {

    $('#incentive_dverror').modal('hide');

    //document.getElementById("roam_employee").selectedIndex = 0;
    //document.getElementById("roam_branch").selectedIndex = 0;
    //roam_Binddata();
}

function incentive_submit() {

    var emp = $("#incentive_employee").val();
    var month = $("#incentive_month").val();
    var year = $("#incentive_year").val();
    var amount = $("#incentive_amount").val().trim();
    var remark = $("#incentive_remark").val().trim();

    // 🔴 Mandatory Validation
    if (!emp || emp === "Select") {
        alert("Please select Employee");
        return false;
    }

    if (!month || month === "Select") {
        alert("Please select Month");
        return false;
    }

    if (!year || year === "Select") {
        alert("Please select Year");
        return false;
    }

    if (amount === "") {
        alert("Please enter Amount");
        return false;
    }

    if (isNaN(amount)) {
        alert("Amount must be numeric");
        return false;
    }

    if (remark === "") {
        alert("Please enter Remark");
        return false;
    }

    // ✅ Call PageMethod
    PageMethods.SaveIncentive(global_incentiveID, emp, month, year, amount, remark,
        function (response) {
            alert(response);
            incentive_clearForm();
            $("#incentive_btnreset").hide();

            var today = new Date();
            var currentMonth = today.toLocaleString('default', { month: 'long' });
            var currentYear = today.getFullYear();     // e.g., 2026

            Incentive_bindTable(currentMonth, currentYear);
        },
        function (error) {
            alert("Error: " + error.get_message());
        }
    );

    return false; // prevent postback
}

function incentive_clearForm() {

    incentive_bindEmployees();
    incentive_bindYear();

    $("#incentive_amount").val("");
    $("#incentive_remark").val("");
    $("#incentive_employee").val("Select");

    var today = new Date();
    var currentMonth = today.toLocaleString('default', { month: 'long' });
    var currentYear = today.getFullYear();

    alert(currentMonth);

    $("#incentive_month").val(currentMonth);
    $("#incentive_year").val(currentYear);

    Incentive_bindGrid(currentMonth, currentYear);

    $("#incentive_employee").prop("disabled", false);
    $("#incentive_month").prop("disabled", false);
    $("#incentive_year").prop("disabled", false);
    $("#incentive_remark").prop("readonly", false);
}


/*---------- Incentive Report-----------*/

function incentiveReport_btnShow() {

    var month = $("#incentiveReport_month").val();
    var year = $("#incentiveReport_year").val();

    if (!month || !year) {
        alert("Please select Month and Year");
        return;
    }

    IncentiveReport_bindGrid(month, year);
}

function IncentiveReport_bindGrid(month, year) {


    //month = "june";
    //year = "2017";

    $('#load1').show();

    $.ajax({
        type: "POST",
        url: "IncentiveMaster.aspx/GetAllIncentivesForReport",
        dataType: "json",
        data: "{Month:'" + month + "',Year:'" + year + "'}",
        contentType: "application/json",
        success: function (data) {

            var dataArray = JSON.parse(data.d);

            var rowCount = data.d.length;

            if ($.fn.DataTable.isDataTable('#table_incentiveReport')) {
                $('#table_incentiveReport').DataTable().clear().destroy();
            }

            var table = $('#table_incentiveReport').DataTable({
                dom: 'lBftp',
                data: dataArray,
                scrollX: false,
                paging: true,

                //autoWidth: true,
                processing: true,
                ordering: false,
                serverSide: false,
                columns: [
                    { data: "SrNo", className: "text-center" },
                    { data: "Code" },
                    { data: "FullName" },
                    { data: "BankName" },
                    { data: "BankAccNo" },
                    { data: "IFSCCode" },
                    { data: "Month" },
                    { data: "Year" },
                    { data: "Amount", className: "text-center" },
                    { data: "Status" },
                    { data: "Remark" },
                    { data: "AddedByName" },
                    { data: "AddedDate" }
                ],

                footerCallback: function (row, data, start, end, display) {
                    var api = this.api();

                    // Remove formatting and convert to number
                    var intVal = function (i) {
                        return typeof i === 'string'
                            ? i.replace(/[\₹,]/g, '') * 1
                            : typeof i === 'number'
                                ? i
                                : 0;
                    };

                    // Total of all pages
                    var total = api
                        .column(8)
                        .data()
                        .reduce(function (a, b) {
                            return intVal(a) + intVal(b);
                        }, 0);

                    // Update footer
                    $(api.column(8).footer()).html(
                        '₹ ' + total.toLocaleString('en-IN')
                    );
                },


                buttons: [
                    {
                        extend: 'excelHtml5', text: 'Export Excel', title: 'Incentive Report_' + month + '_' + year,
                    }
                ],
                initComplete: function () {
                    $('#load1').hide();
                }
            });
        },

        error: function (error) {
            alert('Error: ' + error.responseText);
        }
    });

    return false;
}

function incentiveReport_bindYear() {

    var currentYear = new Date().getFullYear();
    var startYear = currentYear - 5;
    var endYear = currentYear;

    var $year = $("#incentiveReport_year");
    $year.empty();
    $year.append('<option value="">Select</option>');

    //var $yearProd = $("incentiveReport_year");
    //$yearProd.empty();
    //$yearProd.append('<option value="">Select</option>');

    for (var y = startYear; y <= endYear; y++) {
        $year.append('<option value="' + y + '">' + y + '</option>');
        /*   $yearProd.append('<option value="' + y + '">' + y + '</option>');*/
    }
}


/*---------- Production Incentive -----------*/

function prodIncv_bindEmployees() {

    var select = document.getElementById("prodIncv_employee");
    let options = select.getElementsByTagName('prodIncv_employee');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#prodIncv_employee").append($("<option></option>").val("Select").html("Select"));

    $.ajax({
        type: "POST", url: "IncentiveMaster.aspx/GetAllUsers", dataType: "json", contentType: "application/json",
        success: function (res) {

            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (data, value) {

                $("#prodIncv_employee").append($("<option></option>").val(value.Code).html(value.FullName));
            })
        }
    });
}

function prodIncv_bindYear() {

    var currentYear = new Date().getFullYear();
    var startYear = currentYear - 5;
    var endYear = currentYear;

    var $year = $("#prodIncv_year");
    $year.empty();
    $year.append('<option value="">Select</option>');

    for (var y = startYear; y <= endYear; y++) {
        $year.append('<option value="' + y + '">' + y + '</option>');
    }
}

function prodIncv_bindGrid(month, year) {

    //month = "February";
    //year = "2025";

    $('#load1').show();
    $.ajax({
        type: "POST",
        url: "IncentiveMaster.aspx/GetAllOtherSalaryDetails",
        dataType: "json",
        data: "{Month:'" + month + "',Year:'" + year + "'}",
        contentType: "application/json",

        success: function (data) {

            var dataArray = JSON.parse(data.d);

            var rowCount = data.d.length;

            if ($.fn.DataTable.isDataTable('#table_prodIncentive')) {
                $('#table_prodIncentive').DataTable().clear().destroy();
            }

            var table = $('#table_prodIncentive').DataTable({
                dom: 'lBftp',
                data: dataArray,
                scrollX: false,
                paging: true,

                //autoWidth: true,
                processing: true,
                ordering: false,
                serverSide: false,
                columns: [
                    {
                        data: null,
                        render: function (data, type, row, meta) {
                            return `
                                <a href="javascript:void(0);" title="Edit" onclick="prodIncv_edit(${row.ID}, ${meta.row});"><i class="uil uil-edit-alt text-primary"></i></a>
                                &nbsp;&nbsp;
                                <a href="javascript:void(0);" title="Delete" onclick="prodIncv_delete(${row.ID});"><i class="uil uil-trash-alt text-danger"></i></a>`;
                        }
                    },
                    { data: "SrNo", className: "text-center" },
                    { data: "Code" },
                    { data: "FullName" },
                    { data: "Month" },
                    { data: "Year" },
                    { data: "Amount", className: "text-center" },
                    { data: "Remark" },
                    { data: "AddedByName" },
                    { data: "AddedDate" },
                    { data: "ID", visible: false }
                ],

                buttons: [
                    {
                        extend: 'excelHtml5',
                        text: 'Export Excel',
                        title: 'Production Incentive_' + month + '_' + year,
                        exportOptions: { columns: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] } 
                    }
                ],

                initComplete: function () {
                    $('#load1').hide();
                }
            });
        },

        error: function (error) {
            alert('Error: ' + error.responseText);
        }
    });

    return false;
}

/* edit */
function prodIncv_edit(id, index) {

    var table = $('#table_prodIncentive').DataTable();

    global_prodIncentiveID = id;

    // ✅ Remove highlight from all rows first
    $('#table_prodIncentive tbody tr').removeClass("highlightRow");

    // ✅ Get row data & node
    var rowData = table.row(index).data();
    var rowNode = table.row(index).node();

    if (!rowData) {
        alert("Row data not found");
        return;
    }

    // ✅ Add highlight to selected row
    $(rowNode).addClass("highlightRow");

    // Show reset button
    $("#prodIncv_btnreset").show();

    // Focus
    $("#prodIncv_employee").focus();

    // Bind values
    $("#prodIncv_employee").val(rowData.Code).trigger('change');
    $("#prodIncv_month").val(rowData.Month);
    $("#prodIncv_year").val(rowData.Year);
    $("#prodIncv_amount").val(rowData.Amount);
    $("#prodIncv_remark").val(rowData.Remark);

    // Make fields non-editable
    $("#prodIncv_employee").prop("disabled", true);
    $("#prodIncv_month").prop("disabled", true);
    $("#prodIncv_year").prop("disabled", true);
    $("#prodIncv_remark").prop("readonly", true);

    // Change button text
    $("#prodIncv_btnsubmit").text("Update");
}

/* delete */
function prodIncv_delete(id) {

    global_prodIncentiveID = id;

    $('#prodIncv_delete').modal('show');
}

function prodincv_btndelete() {

    PageMethods.DeleteIncentive_production(global_prodIncentiveID, prodIncv_DeleteOnSuccess, prodIncv_DeleteOnError);
    return false;
}

function prodIncv_submit() {

    var emp = $("#prodIncv_employee").val();
    var month = $("#prodIncv_month").val();
    var year = $("#prodIncv_year").val();
    var amount = $("#prodIncv_amount").val().trim();
    var remark = $("#prodIncv_remark").val().trim();

    // 🔴 Mandatory validation
    if (!emp || emp === "Select") {
        alert("Please select Employee");
        return false;
    }

    if (!month || month === "Select") {
        alert("Please select Month");
        return false;
    }

    if (!year || year === "Select") {
        alert("Please select Year");
        return false;
    }

    if (amount === "") {
        alert("Please enter Amount");
        return false;
    }

    if (isNaN(amount)) {
        alert("Amount must be numeric");
        return false;
    }

    if (remark === "") {
        alert("Please enter Remark");
        return false;
    }

    // Disable button to prevent double click
    $("#prodIncv_btnsubmit").prop("disabled", true);

    // ✅ PageMethod Call
    PageMethods.SaveIncentive_production(global_prodIncentiveID, emp, month, year, amount, remark,
        function (response) {
            alert(response);
            clearProdForm();
            $("#prodIncv_btnsubmit").prop("disabled", false);
        },
        function (error) {
            alert("Error: " + error.get_message());
            $("#prodIncv_btnsubmit").prop("disabled", false);
        }
    );

    return false; // prevent postback
}

function clearProdForm() {

    prodIncv_bindEmployees();
    prodIncv_bindYear();

    $("#prodIncv_amount").val("");
    $("#prodIncv_remark").val("");
    $("#prodIncv_employee").val("Select");

    var today = new Date();
    var currentMonth = today.toLocaleString('default', { month: 'long' });
    var currentYear = today.getFullYear();

    $("#prodIncv_employee").prop("disabled", false);
    $("#prodIncv_month").prop("disabled", false);
    $("#prodIncv_year").prop("disabled", false);
    $("#prodIncv_remark").prop("readonly", false);

    $("#prodIncv_month").val(currentMonth);
    $("#prodIncv_year").val(currentYear);

    prodIncv_bindGrid(currentMonth, currentYear);
}


/*---------- Production Incentive Report -----------*/

function prodReport_bindYear() {

    var currentYear = new Date().getFullYear();
    var startYear = currentYear - 5;
    var endYear = currentYear;

    var $year = $("#prodreport_year");
    $year.empty();
    $year.append('<option value="">Select</option>');

    for (var y = startYear; y <= endYear; y++) {
        $year.append('<option value="' + y + '">' + y + '</option>');
    }
}

function prodReport_btnShow() {

    var month = $("#prodreport_month").val();
    var year = $("#prodreport_year").val();

    if (!month || !year) {
        alert("Please select Month and Year");
        return;
    }

    prodReport_bindGrid(month, year);
}

function prodReport_bindGrid(month, year) {


    $('#load1').show();

    $.ajax({
        type: "POST",
        url: "IncentiveMaster.aspx/GetAllOtherSalaryDetails_Report",
        dataType: "json",
        data: "{Month:'" + month + "',Year:'" + year + "'}",
        contentType: "application/json",
        success: function (data) {

            var dataArray = JSON.parse(data.d);

            var rowCount = data.d.length;

            if ($.fn.DataTable.isDataTable('#table_prodreport')) {
                $('#table_prodreport').DataTable().clear().destroy();
            }

            var table = $('#table_prodreport').DataTable({
                dom: 'lBftp',
                data: dataArray,
                scrollX: false,
                paging: true,

                //autoWidth: true,
                processing: true,
                ordering: false,
                serverSide: false,
                columns: [
                    { data: "SrNo", className: "text-center" },
                    { data: "Code" },
                    { data: "FullName" },
                    { data: "BankName" },
                    { data: "BankAccNo" },
                    { data: "IFSCCode" },
                    { data: "Month" },
                    { data: "Year" },
                    { data: "Amount", className: "text-center" },
                    { data: "Remark" },
                    { data: "AddedByName" },
                    { data: "AddedDate" }
                ],

                footerCallback: function (row, data, start, end, display) {
                    var api = this.api();

                    // Remove formatting and convert to number
                    var intVal = function (i) {
                        return typeof i === 'string'
                            ? i.replace(/[\₹,]/g, '') * 1
                            : typeof i === 'number'
                                ? i
                                : 0;
                    };

                    // Total of all pages
                    var total = api
                        .column(8)
                        .data()
                        .reduce(function (a, b) {
                            return intVal(a) + intVal(b);
                        }, 0);

                    // Update footer
                    $(api.column(8).footer()).html(
                        '₹ ' + total.toLocaleString('en-IN')
                    );
                },


                buttons: [
                    {
                        extend: 'excelHtml5', text: 'Export Excel', title: 'Production Incentive Report_' + month + '_' + year,
                    }
                ],
                initComplete: function () {
                    $('#load1').hide();
                }
            });
        },

        error: function (error) {
            alert('Error: ' + error.responseText);
        }
    });

    return false;
}




