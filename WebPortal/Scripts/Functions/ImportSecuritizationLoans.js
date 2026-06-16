
var ExistingLoanList_table;
var NewLoanList_table;



/*---------------- Bind Method ----------------*/

function impSerc_bindDeals() {

    var Select = document.getElementById("importSerc_DealNo");
    let options = Select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        Select.removeChild(options[i]);
    }

    $("#importSerc_DealNo").append($("<option></option>").val("Select").html("Select"));

    $.ajax({

        type: "POST", url: "ImportSecuritizationLoans.aspx/GetAllDealsFromProjectTracking", dataType: "json",
        contentType: "application/json",
        success: function (data) {

            var dataArray = JSON.parse(data.d);
            $.each(dataArray, function (data, value) {

                $("#importSerc_DealNo").append($("<option></option>").val(value.SecureID).html(value.DealNo));
            })
        }
    });
}

function NewLoanDetails_BindGrid() {

    $('#load1').show();

    $.ajax({
        url: "ImportSecuritizationLoans.aspx/VerifySecRelLoans",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            NewLoanList_table = $('#table_NewLoanList').DataTable({
                dom: 'fti',
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                "paging": false,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                filter: true,
                'select': {
                    'style': 'single'
                },
                "serverSide": false,
                "data": dataArray,

                columns: [
                    { data: 'SrNo' },
                    { data: 'Project #' },
                    { data: 'Deal #' },
                    { data: 'Loan #1' },
                    { data: 'Loan #2' },
                    { data: 'Received Date' },
                    { data: 'Delivered Date' },
                    { data: 'Source' },
                    { data: 'Remark' }
                ],

                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                },

                initComplete: function () {

                    $('#load1').hide();
                },
            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}


/*---------------- Upload Data ----------------*/
function btnImportSerc_Upload() {

    var ddlDeal = document.getElementById('importSerc_DealNo');
    var dealNo = ddlDeal.options[ddlDeal.selectedIndex].value;

    var remark = document.getElementById('importSerc_Remark').value;

    if (dealNo == "Select") {
        // alert("Please select Deal #.");
        Swal.fire({
            icon: "Validation",
            title: "warning",
            text: "Please select Deal #."
        });

        document.getElementById("importSerc_DealNo").focus();
        return false;
    }

    //if (remark == "") {
    //    alert("Please select remark");
    //    document.getElementById("importSerc_Remark").focus();
    //    return false;
    //}

    const filters = {
        DealNo: dealNo,
        Remark: remark
    };

    $.ajax({
        type: "POST",
        url: "ImportSecuritizationLoans.aspx/ReadExcel",
        data: JSON.stringify(filters),
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        beforeSend: function () {
            Swal.fire({
                title: "Please wait...",
                text: "Reading excel file...",
                allowOutsideClick: false,
                allowEscapeKey: false,
                showConfirmButton: false,
                didOpen: function () {
                    Swal.showLoading();
                }
            });
        },

        success: function (res) {
            NewLoanDetails_BindGrid();
        },

        error: function (xhr) {
            console.log(xhr);

            Swal.fire({
                icon: "error",
                title: "Error",
                text: "Something went wrong while uploading data."
            });
        },

        complete: function () {
            if (Swal.isLoading()) {
                Swal.close();
            }
        }
    });

    return false;
}



/*---------------- Cleared Data ----------------*/

function btnImportSerc_ClearData() {

    PageMethods.ClearLoanList(

        function (result) {

            if (result > 0) {

                $("#table_NewLoanList tbody").empty();

                ClearImportSercControls();

                Swal.fire({
                    icon: "success",
                    title: "Success",
                    text: "Data cleared successfully."
                });
            }
            else {

                Swal.fire({
                    icon: "info",
                    title: "Information",
                    text: "No data found to clear."
                });
            }
        },

        function (error) {

            Swal.close();

            console.log(error);

            Swal.fire({
                icon: "error",
                title: "Error",
                text: error.get_message ? error.get_message() : "Something went wrong while clearing data."
            });
        }
    );

    return false;
}



/*---------------- Import Data ----------------*/

function btnImportSerc_ImportToDatabase() {

    var ddlDeal = document.getElementById('importSerc_DealNo');
    var dealNo = ddlDeal.options[ddlDeal.selectedIndex].value;

    var remark = document.getElementById('importSerc_Remark').value;

    if (dealNo == "Select") {
        Swal.fire({
            icon: "warning",
            title: "Validation",
            text: "Please select Deal #."
        });

        document.getElementById("importSerc_DealNo").focus();
        return false;
    }

    Swal.fire({
        title: "Please wait...",
        text: "Importing data to database...",
        allowOutsideClick: false,
        allowEscapeKey: false,
        showConfirmButton: false,
        didOpen: function () {
            Swal.showLoading();
        }
    });

    PageMethods.ImportData(
        dealNo,

        function (result) {

            Swal.close();

            Swal.fire({
                icon: "success",
                title: "Success",
                text: "Data imported successfully."
            }).then(() => {
                // ClearImportSercControls();
                NewLoanDetails_BindGrid(); // Refresh grid if required
            });
        },

        function (error) {

            Swal.close();

            console.log(error);

            Swal.fire({
                icon: "error",
                title: "Error",
                text: "Something went wrong while importing data."
            });
        }
    );

    return false;
}



function ClearImportSercControls() {

    // Reset Deal No dropdown
    document.getElementById("importSerc_DealNo").selectedIndex = 0;

    // Clear file input
    document.getElementById("importSerc_attachment").value = "";

    // Clear remark
    document.getElementById("importSerc_Remark").value = "";

    // Hide file preview section
    document.getElementById("conentdiv").style.display = "none";

    // Clear uploaded file name/details
    document.getElementById("importSercfilesdiv").innerHTML = "";
}




function ExistingLoanDetails_BindGrid() {

    $('#load1').show();

    $.ajax({
        url: "ImportSecuritizationLoans.aspx/GetExistingLoanList",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            ExistingLoanList_table = $('#table_ExistingLoanList').DataTable({
                dom: 'lftip',
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                filter: true,
                'select': {
                    'style': 'single'
                },
                "serverSide": false,
                "data": dataArray,

                columns: [
                    { data: 'SrNo' },
                    { data: 'BillingDealNo' },
                    { data: 'ProjectNo' },
                    { data: 'TrackingDealNo' },
                    { data: 'LoanNo' },
                    { data: 'LoanNo2' },
                    { data: 'ReceivedDate' },
                    { data: 'DeliveredDate' },
                    { data: 'Source' }
                ],

                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                },
                initComplete: function () {

                    var api = this.api();

                    // Create textboxes in header
                    api.columns().every(function (colIdx) {
                        var cell = $('.filters th').eq(colIdx);
                        $(cell).html(
                            '<input type="text" placeholder="Search" style="width:100%" />'
                        );

                        $('input', cell)
                            .off('keyup change')
                            .on('keyup change', function (e) {
                                e.stopPropagation();

                                api
                                    .column(colIdx)
                                    .search(this.value)
                                    .draw();
                            });
                    });
                    $('#load1').hide();
                },
            });
        },

        buttons: [
            {
                extend: 'excelHtml5', title: 'Existing Loan List', autoFilter: true,
            },
        ],

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });



    return false;
}

function ExistingLoanDetails_BindGrid_Core() {

    $('#load1').show();

    $.ajax({
        url: "ImportSecuritizationLoans.aspx/GetExistingLoanList",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            ExistingLoanList_table = $('#table_ExistingLoanList').DataTable({
                dom: 'ftip',
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                filter: true,
                'select': {
                    'style': 'single'
                },
                "serverSide": false,
                "data": dataArray,

                columns: [
                    { data: 'SrNo' },
                    { data: 'BillingDealNo' },
                    { data: 'ProjectNo' },
                    { data: 'TrackingDealNo' },
                    { data: 'LoanNo' },
                    { data: 'LoanNo2' },
                    { data: 'ReceivedDate' },
                    { data: 'DeliveredDate' },
                    { data: 'Source' }
                ],

                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                },
                initComplete: function () {

                    $('#load1').hide();
                },
            });
        },

        buttons: [
            {
                extend: 'excelHtml5', title: 'Existing Loan List', autoFilter: true,
            },
        ],

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });



    return false;
}


