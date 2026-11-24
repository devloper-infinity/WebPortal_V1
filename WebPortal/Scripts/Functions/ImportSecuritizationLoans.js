
var ExistingLoanList_table;
var NewLoanList_table;
var impSercNoticeTimer;

/* Use page content for notices so browser dialog suppression cannot hide them. */
function impSercEnsureNoticeUI() {
    if (!document.getElementById("impSercNoticeStyles")) {
        var style = document.createElement("style");
        style.id = "impSercNoticeStyles";
        style.textContent = "#impSercNotice{position:fixed;top:20px;right:20px;z-index:20000;max-width:min(420px,calc(100vw - 40px));padding:14px 18px;border-radius:6px;box-shadow:0 4px 16px rgba(0,0,0,.2);color:#fff;font:14px/1.45 Arial,sans-serif;display:none}#impSercNotice.success{background:#218838}#impSercNotice.info{background:#286090}#impSercNotice.warning{background:#a66b00}#impSercNotice.error{background:#b02a37}#impSercBusy{position:fixed;top:20px;left:50%;transform:translateX(-50%);z-index:19999;padding:11px 18px;border-radius:6px;background:#263746;color:#fff;box-shadow:0 4px 16px rgba(0,0,0,.2);font:14px Arial,sans-serif;display:none}";
        document.head.appendChild(style);
    }
    if (!document.getElementById("impSercNotice")) {
        var notice = document.createElement("div");
        notice.id = "impSercNotice";
        notice.setAttribute("role", "alert");
        notice.setAttribute("aria-live", "assertive");
        document.body.appendChild(notice);
    }
    if (!document.getElementById("impSercBusy")) {
        var busy = document.createElement("div");
        busy.id = "impSercBusy";
        busy.setAttribute("role", "status");
        busy.setAttribute("aria-live", "polite");
        document.body.appendChild(busy);
    }
}

function impSercShowMessage(message, type) {
    impSercEnsureNoticeUI();
    var notice = document.getElementById("impSercNotice");
    window.clearTimeout(impSercNoticeTimer);
    notice.className = type || "info";
    notice.textContent = message;
    notice.style.display = "block";
    impSercNoticeTimer = window.setTimeout(function () { notice.style.display = "none"; }, 5000);
}

function impSercSetBusy(message) {
    impSercEnsureNoticeUI();
    var busy = document.getElementById("impSercBusy");
    busy.textContent = message || "";
    busy.style.display = message ? "block" : "none";
}



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
            var details = error && error.responseText ? error.responseText : "Unable to load the new loan list.";
            impSercShowMessage("Error: " + details, "error");
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
        impSercShowMessage("Please select Deal #.", "warning");

        document.getElementById("importSerc_DealNo").focus();
        return false;
    }

    //if (remark == "") {
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
            impSercSetBusy("Reading Excel file...");
        },

        success: function (res) {
            NewLoanDetails_BindGrid();
        },

        error: function (xhr) {
            console.log(xhr);

            impSercShowMessage("Something went wrong while uploading data.", "error");
        },

        complete: function () {
            impSercSetBusy("");
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

                impSercShowMessage("Data cleared successfully.", "success");
            }
            else {

                impSercShowMessage("No data found to clear.", "info");
            }
        },

        function (error) {

            console.log(error);

            impSercShowMessage(error.get_message ? error.get_message() : "Something went wrong while clearing data.", "error");
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
        impSercShowMessage("Please select Deal #.", "warning");

        document.getElementById("importSerc_DealNo").focus();
        return false;
    }

    impSercSetBusy("Importing data to database...");

    PageMethods.ImportData(
        dealNo,

        function (result) {

            impSercSetBusy("");
            impSercShowMessage("Data imported successfully.", "success");
            // ClearImportSercControls();
            NewLoanDetails_BindGrid(); // Refresh grid if required
        },

        function (error) {

            impSercSetBusy("");

            console.log(error);

            impSercShowMessage("Something went wrong while importing data.", "error");
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
            var details = error && error.responseText ? error.responseText : "Unable to load existing loan details.";
            impSercShowMessage("Error: " + details, "error");
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
            var details = error && error.responseText ? error.responseText : "Unable to load existing loan details.";
            impSercShowMessage("Error: " + details, "error");
        }
    });



    return false;
}


