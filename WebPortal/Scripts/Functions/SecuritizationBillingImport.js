var secBillImportDealRecs_table;
var secBillImportNewLoanList_table;
var secBillImportExistingLoanList_table;
var secBillImportFileUploaded = false;

$(document).ready(function () {
    secBillImport_BindDeals();
    secBillImport_InitEnhancements();
});

function secBillImport_InitEnhancements() {
    $("#secBillImport_attachment").on("change", secBillImport_HandleFileChange);

    $("#secBillImport_ClearForm").on("click", function () {
        secBillImport_ClearEntryForm(true);
        return false;
    });

    $("#secBillImport_BillingType, #secBillImport_NoOfLoans").on("change input", function () {
        secBillImport_ResetBillingState();
    });

    $("#secBillImport_ToggleDealRecords").on("click", function () {
        secBillImport_ToggleDealRecords();
        return false;
    });

    $("#secBillImport_tabs a[data-toggle='pill']").on("shown.bs.tab", function () {
        secBillImport_AdjustVisibleTables();
    });
}

function secBillImport_blankForNull(value) {
    return value === null || value === undefined ? "" : value;
}

function secBillImport_BindDeals() {
    var select = $("#secBillImport_DealNo");
    select.empty();
    select.append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST",
        url: "SecuritizationBillingImport.aspx/GetAllDealsFromProjectTracking_Billing",
        dataType: "json",
        contentType: "application/json",
        success: function (res) {
            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (data, value) {
                select.append($("<option></option>").val(value.ClientDealName).html(value.ClientDealName));
            });
        }
    });
}

function secBillImport_ChangeDealLoans(ddldeal) {
    var deal = ddldeal.options[ddldeal.selectedIndex].value;
    secBillImport_ResetBillingState();

    if (deal === "") {
        $("#table_secBillImportDealRecs tbody").empty();
        $("#secBillImport_DealRecordCount").text("0 records");
        return false;
    }

    $("#load1").show();

    $.ajax({
        url: "SecuritizationBillingImport.aspx/GetDealDetails",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ DealNo: deal }),
        success: function (data) {
            var dataArray = JSON.parse(data.d);
            var html = "";

            $.each(dataArray, function (index, value) {
                if (index === 0) {
                    $("#secBillImport_NoOfLoans").val(secBillImport_blankForNull(value.LoanCount));
                    $("#secBillImport_lblProjectId").text(secBillImport_blankForNull(value.ProjectId));
                    $("#secBillImport_lblClientDealName").text(secBillImport_blankForNull(value.ClientDealName));
                    $("#secBillImport_lblProjectName").text(secBillImport_blankForNull(value.ProjectName));
                }

                html += "<tr>";
                html += '<td style="text-wrap: nowrap;">' + secBillImport_blankForNull(value.SrNo) + "</td>";
                html += '<td style="text-wrap: nowrap;">' + secBillImport_blankForNull(value.ClientName) + "</td>";
                html += '<td style="text-wrap: nowrap;">' + secBillImport_blankForNull(value.ClientDealName) + "</td>";
                html += '<td style="text-wrap: nowrap; text-align:center;">' + secBillImport_blankForNull(value.LoanCount) + "</td>";
                html += '<td style="text-wrap: nowrap;">' + secBillImport_blankForNull(value.TaskName) + "</td>";
                html += '<td style="text-wrap: nowrap; text-align:center;">' + secBillImport_blankForNull(value.Copies) + "</td>";
                html += '<td style="text-wrap: nowrap; text-align:center;">' + secBillImport_blankForNull(value.RequestedDate) + "</td>";
                html += '<td style="text-wrap: nowrap; text-align:center;">' + secBillImport_blankForNull(value.ActualDeliveredDate) + "</td>";
                html += '<td style="text-wrap: nowrap; text-align:center;">' + secBillImport_blankForNull(value.BillingHours) + "</td>";
                html += "</tr>";
            });

            $("#secBillImport_DealRecordCount").text(dataArray.length + (dataArray.length === 1 ? " record" : " records"));

            if ($.fn.dataTable.isDataTable("#table_secBillImportDealRecs")) {
                secBillImportDealRecs_table.destroy();
            }

            $("#table_secBillImportDealRecs tbody").html(html);
            secBillImportDealRecs_table = $("#table_secBillImportDealRecs").DataTable({
                dom: "t",
                destroy: true,
                scrollX: true,
                paging: false,
                autoWidth: false,
                select: true,
                ordering: false,
                processing: true,
                initComplete: function () {
                    secBillImport_AdjustTable("#table_secBillImportDealRecs");
                    $("#load1").hide();
                }
            });
        },
        error: function (error) {
            $("#load1").hide();
            alert("error; " + error.responseText);
        }
    });

    return false;
}

function secBillImport_HandleFileChange(event) {
    var files = event.target.files;

    if (!files || files.length === 0) {
        return;
    }

    var file = files[0];
    var fileName = file.name || "";

    if (!/\.xlsx$/i.test(fileName)) {
        secBillImportFileUploaded = false;
        $("#secBillImport_attachment").val("");
        $("#secBillImport_contentdiv").attr("style", "display: none!important;");

        Swal.fire({
            icon: "warning",
            title: "Validation",
            text: "Please select an .xlsx file."
        });

        return;
    }

    $("#secBillImport_fileName").val(fileName);
    $("#secBillImport_filesdiv").html(fileName);
    $("#secBillImport_contentdiv").attr("style", "");
    secBillImportFileUploaded = false;

    var fd = new FormData();
    fd.append(event.target.name, file, file.name);

    var xhr = new XMLHttpRequest();
    xhr.onload = function () {
        secBillImportFileUploaded = xhr.status >= 200 && xhr.status < 300;

        if (!secBillImportFileUploaded) {
            Swal.fire({
                icon: "error",
                title: "Error",
                text: "File upload failed. Please select the attachment again."
            });
        }
    };

    xhr.open("POST", window.location.href.split("#")[0], true);
    xhr.send(fd);
}

function btnSecBillImport_Upload() {
    if (!secBillImport_ValidateUploadInputs()) {
        return false;
    }

    if (!secBillImportFileUploaded) {
        Swal.fire({
            icon: "info",
            title: "Please wait",
            text: "The attachment is still being prepared. Try Upload again in a moment."
        });

        return false;
    }

    var billingId = parseInt($("#secBillImport_BillingId").val(), 10) || 0;

    if (billingId > 0) {
        secBillImport_ReadExcel(billingId);
    }
    else {
        secBillImport_GenerateBillingPeriod(function (newBillingId) {
            secBillImport_ReadExcel(newBillingId);
        });
    }

    return false;
}

function secBillImport_ValidateUploadInputs() {
    var billingType = $("#secBillImport_BillingType").val();
    var dealNo = $("#secBillImport_DealNo").val();
    var loanCount = $("#secBillImport_NoOfLoans").val();

    if (billingType === "" || billingType === "Select") {
        Swal.fire({ icon: "warning", title: "Validation", text: "Please select Billing Type." });
        $("#secBillImport_BillingType").focus();
        return false;
    }

    if (dealNo === "") {
        Swal.fire({ icon: "warning", title: "Validation", text: "Please select Deal #." });
        $("#secBillImport_DealNo").focus();
        return false;
    }

    if (loanCount === "" || parseInt(loanCount, 10) <= 0) {
        Swal.fire({ icon: "warning", title: "Validation", text: "Please enter # of Loans." });
        $("#secBillImport_NoOfLoans").focus();
        return false;
    }

    if ($("#secBillImport_attachment").val() === "") {
        Swal.fire({ icon: "warning", title: "Validation", text: "Please select Attachment." });
        $("#secBillImport_attachment").focus();
        return false;
    }

    if ($("#secBillImport_lblProjectId").text() === "") {
        Swal.fire({ icon: "warning", title: "Validation", text: "Please re-select Deal # to load project details." });
        $("#secBillImport_DealNo").focus();
        return false;
    }

    return true;
}

function secBillImport_GenerateBillingPeriod(onGenerated) {
    var billingType = $("#secBillImport_BillingType").val();
    var dealNo = $("#secBillImport_DealNo").val();
    var loanCount = $("#secBillImport_NoOfLoans").val();
    var projectId = $("#secBillImport_lblProjectId").text();
    var clientDealName = $("#secBillImport_lblClientDealName").text();
    var projectName = $("#secBillImport_lblProjectName").text();

    Swal.fire({
        title: "Please wait...",
        text: "Generating billing period...",
        allowOutsideClick: false,
        allowEscapeKey: false,
        showConfirmButton: false,
        didOpen: function () {
            Swal.showLoading();
        }
    });

    PageMethods.InsertSecuritizationRelianceLetter_Billing(
        billingType,
        dealNo,
        projectId,
        clientDealName,
        projectName,
        loanCount,
        loanCount,
        "",
        function (result) {
            Swal.close();

            if (result > 0) {
                $("#secBillImport_BillingId").val(result);
                $("#secBillImport_StatusText").html("Billing period generated. <strong>ID: " + result + "</strong>");
                onGenerated(result);
            }
            else {
                Swal.fire({
                    icon: "error",
                    title: "Error",
                    text: "Error in generating billing period."
                });
            }
        },
        function (error) {
            Swal.close();
            Swal.fire({
                icon: "error",
                title: "Error",
                text: error.get_message ? error.get_message() : "Something went wrong while generating billing period."
            });
        }
    );
}

function secBillImport_ReadExcel(billingId) {
    var dealNo = $("#secBillImport_DealNo").val();

    $.ajax({
        type: "POST",
        url: "SecuritizationBillingImport.aspx/ReadExcel",
        data: JSON.stringify({ BillingId: billingId, DealNo: dealNo, Remark: "" }),
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
            Swal.close();

            if (res.d > 0) {
                secBillImport_NewLoanDetails_BindGrid();
                secBillImport_ShowImportTabs();
            }
            else if (res.d === 0) {
                Swal.fire({
                    icon: "info",
                    title: "Information",
                    text: "No data found in uploaded file."
                });
            }
            else {
                Swal.fire({
                    icon: "error",
                    title: "Error",
                    text: "Please upload a valid loan list .xlsx file."
                });
            }
        },
        error: function (xhr) {
            Swal.close();
            console.log(xhr);

            Swal.fire({
                icon: "error",
                title: "Error",
                text: "Something went wrong while uploading data."
            });
        }
    });
}

function secBillImport_NewLoanDetails_BindGrid() {
    $("#load1").show();

    $.ajax({
        url: "SecuritizationBillingImport.aspx/VerifySecRelLoans",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);

            secBillImportNewLoanList_table = $("#table_secBillImportNewLoanList").DataTable({
                dom: "fti",
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                paging: false,
                autoWidth: false,
                select: true,
                ordering: false,
                processing: true,
                filter: true,
                serverSide: false,
                data: dataArray,
                columns: [
                    { data: "SrNo" },
                    { data: "Project #" },
                    { data: "Deal #" },
                    { data: "Loan #1" },
                    { data: "Loan #2" },
                    { data: "Received Date" },
                    { data: "Delivered Date" },
                    { data: "Source" },
                    { data: "Remark" }
                ],
                fnCreatedRow: function (nRow) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                },
                initComplete: function () {
                    secBillImport_AdjustTable("#table_secBillImportNewLoanList");
                    $("#load1").hide();
                }
            });
        },
        error: function (error) {
            $("#load1").hide();
            alert("error; " + error.responseText);
        }
    });

    return false;
}

function secBillImport_ToggleDealRecords() {
    var body = $("#secBillImport_DealRecordsBody");
    var isOpen = !body.hasClass("is-open");

    body.toggleClass("is-open", isOpen);
    $("#secBillImport_ToggleDealRecords").attr("aria-expanded", isOpen ? "true" : "false");
    $("#secBillImport_DealRecordIcon")
        .toggleClass("fa-chevron-down", !isOpen)
        .toggleClass("fa-chevron-up", isOpen);

    if (isOpen && $.fn.dataTable.isDataTable("#table_secBillImportDealRecs")) {
        $("#table_secBillImportDealRecs").DataTable().columns.adjust();
    }
}

function secBillImport_ShowImportTabs() {
    var tabs = document.getElementById("secBillImport_tabs");

    if (tabs) {
        tabs.scrollIntoView({ behavior: "smooth", block: "start" });
        setTimeout(secBillImport_AdjustVisibleTables, 250);
    }
}

function secBillImport_AdjustTable(selector) {
    setTimeout(function () {
        if ($.fn.dataTable.isDataTable(selector)) {
            $(selector).DataTable().columns.adjust();
        }
    }, 50);
}

function secBillImport_AdjustVisibleTables() {
    secBillImport_AdjustTable("#table_secBillImportDealRecs");
    secBillImport_AdjustTable("#table_secBillImportNewLoanList");
    secBillImport_AdjustTable("#table_secBillImportExistingLoanList");
}

function btnSecBillImport_ImportToDatabase() {
    var billingId = parseInt($("#secBillImport_BillingId").val(), 10) || 0;

    if (billingId <= 0) {
        Swal.fire({
            icon: "warning",
            title: "Validation",
            text: "Please upload the file first so billing period can be generated."
        });

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
        billingId,
        function (result) {
            Swal.close();

            if (result > 0) {
                Swal.fire({
                    icon: "success",
                    title: "Success",
                    text: "Data imported successfully."
                }).then(function () {
                    secBillImport_NewLoanDetails_BindGrid();
                });
            }
            else {
                Swal.fire({
                    icon: "info",
                    title: "Information",
                    text: "No uploaded data found to import."
                });
            }
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

function btnSecBillImport_ClearData() {
    PageMethods.ClearLoanList(
        function (result) {
            if ($.fn.dataTable.isDataTable("#table_secBillImportNewLoanList")) {
                secBillImportNewLoanList_table.clear().draw();
            }
            else {
                $("#table_secBillImportNewLoanList tbody").empty();
            }

            secBillImport_ClearUploadControls();

            if (result > 0) {
                Swal.fire({
                    icon: "success",
                    title: "Success",
                    text: "Uploaded data cleared successfully."
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

function secBillImport_ExistingLoanDetails_BindGrid() {
    $("#load1").show();

    $.ajax({
        url: "SecuritizationBillingImport.aspx/GetExistingLoanList",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);

            secBillImportExistingLoanList_table = $("#table_secBillImportExistingLoanList").DataTable({
                dom: "lftip",
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                paging: true,
                autoWidth: false,
                select: true,
                ordering: false,
                processing: true,
                filter: true,
                serverSide: false,
                data: dataArray,
                columns: [
                    { data: "SrNo" },
                    { data: "BillingDealNo" },
                    { data: "ProjectNo" },
                    { data: "TrackingDealNo" },
                    { data: "LoanNo" },
                    { data: "LoanNo2" },
                    { data: "ReceivedDate" },
                    { data: "DeliveredDate" },
                    { data: "Source" }
                ],
                fnCreatedRow: function (nRow) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                },
                initComplete: function () {
                    var api = this.api();

                    api.columns().every(function (colIdx) {
                        var cell = $("#table_secBillImportExistingLoanList thead tr.filters th").eq(colIdx);
                        $(cell).html('<input type="text" placeholder="Search" style="width:100%" />');

                        $("input", cell)
                            .off("keyup change")
                            .on("keyup change", function (e) {
                                e.stopPropagation();
                                api.column(colIdx).search(this.value).draw();
                            });
                    });

                    $("#load1").hide();
                    secBillImport_AdjustTable("#table_secBillImportExistingLoanList");
                }
            });
        },
        error: function (error) {
            $("#load1").hide();
            alert("error; " + error.responseText);
        }
    });

    return false;
}

function secBillImport_ResetBillingState() {
    $("#secBillImport_BillingId").val("0");
    $("#secBillImport_StatusText").html("Billing period will be generated on Upload.");
}

function secBillImport_ClearUploadControls() {
    $("#secBillImport_attachment").val("");
    $("#secBillImport_fileName").val("");
    $("#secBillImport_filesdiv").html("");
    $("#secBillImport_contentdiv").attr("style", "display: none!important;");
    secBillImportFileUploaded = false;
}

function secBillImport_ClearEntryForm(clearServerData) {
    $("#secBillImport_BillingType").val("Select");
    $("#secBillImport_DealNo").val("");
    $("#secBillImport_NoOfLoans").val("");
    $("#secBillImport_lblProjectId, #secBillImport_lblClientDealName, #secBillImport_lblProjectName").text("");
    $("#secBillImport_BillingId").val("0");
    $("#secBillImport_StatusText").html("Billing period will be generated on Upload.");
    secBillImport_ClearUploadControls();
    $("#table_secBillImportDealRecs tbody").empty();
    $("#secBillImport_DealRecordCount").text("0 records");

    if ($.fn.dataTable.isDataTable("#table_secBillImportDealRecs")) {
        secBillImportDealRecs_table.clear().draw();
    }

    if ($.fn.dataTable.isDataTable("#table_secBillImportNewLoanList")) {
        secBillImportNewLoanList_table.clear().draw();
    }
    else {
        $("#table_secBillImportNewLoanList tbody").empty();
    }

    if (clearServerData) {
        PageMethods.ClearLoanList(function () { }, function () { });
    }
}
