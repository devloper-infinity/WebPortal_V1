
var title;
var remark_orderid = 0;
var verifyBillingSummaryRequest = null;

function blankForNull(s) {
    return s == "null" || s == null ? "" : s;

}

function getFirstDayOfMonth(date) {
    return new Date(date.getFullYear(), date.getMonth(), 1);
}

function VerifyOrdres_Show() {

    var ddlprjNo = document.getElementById("VerifyOrdres_projectno");
    var prjValue = ddlprjNo ? ddlprjNo.value : "";
    var prjNo = ddlprjNo.options[ddlprjNo.selectedIndex].text;

    var ddlBillCyc = document.getElementById("VerifyOrdres_BillingCycle");
    var billCycValue = ddlBillCyc ? ddlBillCyc.value : "";
    var billCyc = ddlBillCyc.options[ddlBillCyc.selectedIndex].text;

    var ddldateprd = document.getElementById("VerifyOrdres_dateperild");
    var dateprdValue = ddldateprd ? ddldateprd.value : "";
    var dateprd = ddldateprd.options[ddldateprd.selectedIndex].text;

    if (!prjValue) {

        alert("Please select Project No.");
        return false;
    }
    if (!billCycValue) {

        alert("Please select Billing Cycle.");
        return false;
    }

    if (!dateprdValue) {

        alert("Please select Date Period.");
        return false;
    }

    var dates = dateprd.split('~');
    if (dates.length < 2) {
        alert("Please select a valid Date Period.");
        return false;
    }

    var date1 = dates[0].trim();
    var date2 = dates[1].trim();

    title = "VerifyBilling_" + prjNo + "_" + billCyc + "_" + dateprd;

    Bind_TotalOrders_Summary(prjNo, date1, date2);
    Bind_SearchBilling_Grid(prjNo, date1, date2);
    return false;
}

function BindDatePeriod() {
    var select = document.getElementById("VerifyOrdres_dateperild");
    select.options.length = 0;

    $("#VerifyOrdres_dateperild").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "VerifyBilling.aspx/getBillingPeriod", dataType: "json", contentType: "application/json",
        success: function (res) {

            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (data, value) {

                $("#VerifyOrdres_dateperild").append($("<option></option>").val(value.ID).html(value.BillingPeriod));
            })
        }
    });

}

function BindBillingCycle(Project) {

    var ProjectId = Project.options[Project.selectedIndex].value;
    var select = document.getElementById("VerifyOrdres_BillingCycle");
    select.options.length = 0;

    $("#VerifyOrdres_BillingCycle").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "VerifyBilling.aspx/GetProjectBillingCycle", dataType: "json", contentType: "application/json", data: "{ProjectId : " + ProjectId + "}",
        success: function (res) {

            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (data, value) {

                $("#VerifyOrdres_BillingCycle").append($("<option></option>").val(value.BillingCycle).html(value.BillingCycle));
            })
        }
    });

}

function verifyOrdres_BindProject() {

    var select = document.getElementById("VerifyOrdres_projectno");
    select.options.length = 0;

    $("#VerifyOrdres_projectno").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "VerifyBilling.aspx/GetAllProjectNo", dataType: "json", contentType: "application/json",
        success: function (res) {

            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (data, value) {

                $("#VerifyOrdres_projectno").append($("<option></option>").val(value.ProjectID).html(value.ProjectName));
            })
        }
    });
}

function Bind_SearchBilling_Grid_1(prjno, fromdate, todate) {

    $('#load1').show();
    var table;

    $.ajax({
        url: "VerifyBilling.aspx/GetDataForBilling",
        type: "POST",
        data: "{ProjectNo:'" + prjno + "',FromDate:'" + fromdate + "',ToDate:'" + todate + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = JSON.parse(data.d);

            if ($.fn.DataTable.isDataTable('#VerifyOrders_Search_Billing')) {
                $('#VerifyOrders_Search_Billing').DataTable().clear().destroy();
            }

            table = $('#VerifyOrders_Search_Billing').DataTable({
                dom: 'Bftp',
                data: dataArray,
                scrollX: true,
                paging: false,
                autoWidth: true,
                processing: true,
                ordering: false,
                serverSide: false,

                columns: [
                    { data: "" },
                    { data: "SrNo" },
                    { data: "ClientOrderNo" },
                    { data: "State" },
                    { data: "County" },
                    { data: "OrderDate" },
                    { data: "DeliveredDate" },
                    { data: "NoOfDocuments" },
                    { data: "NoOfPages" },
                    { data: "TaxInformation" },
                    { data: "CalledTaxes" },
                    { data: "PropertySearchCost" },
                    { data: "DocumentDownloadCost" },
                    { data: "TotalRetrievalCostSearchingDownloading" },
                    { data: "PropertyType" },
                    { data: "ProductType" },
                    { data: "ProcessDone" },
                    { data: "ProcessStatus" },
                    { data: "OnOffLine" },
                    { data: "Typing" },
                    { data: "SnippingTools" },
                    { data: "Remark" },
                    { data: "AbstractorSearchCost" },
                    { data: "AbstractorCopyCostCost" },
                    { data: "Abstractorpaid" },
                    { data: "AbstractorName" },
                    { data: "OrderCost" },
                    { data: "OrderID" }
                ],

                columnDefs: [
                    {
                        targets: 0,
                        orderable: false,
                        className: "text-center",
                        render: function (data, type, row) {
                            return `<input type="checkbox" class="row-checkbox" value="${row.OrderID}">`;
                        }
                    },
                    {
                        targets: [1, 3, 7, 8, 9, 10, 11, 12, 13, 19, 20, 22, 23, 24, 26],
                        className: "text-center"
                    },
                    { targets: 27, visible: false }
                ],

                initComplete: function () {
                    updateCounts();
                    $('#load1').hide();
                }
            });

            /* ================= COUNT FUNCTION ================= */
            function updateCounts() {

                var totalRows = table.rows().count();

                var selectedFiltered = table
                    .rows({ search: 'applied' })
                    .nodes()
                    .to$()
                    .find('input.row-checkbox:checked')
                    .length;

                $('#lbltotalcount').text("Total Orders : " + totalRows);
                $('#lblfiltercount').text(
                    "Total Selected Orders For Verification : " + selectedFiltered
                );

                var totalFiltered = table
                    .rows({ search: 'applied' })
                    .nodes()
                    .to$()
                    .find('input.row-checkbox')
                    .length;

                $('#chkall').prop(
                    'checked',
                    totalFiltered > 0 && selectedFiltered === totalFiltered
                );
            }

            /* ================= CHECK ALL (FIXED) ================= */
            $('#chkall').off('change').on('change', function () {

                var isChecked = this.checked;

                table
                    .rows({ search: 'applied' })
                    .nodes()
                    .to$()
                    .find('input.row-checkbox')
                    .prop('checked', isChecked)
                    .closest('tr')
                    .toggleClass('selected-row', isChecked);

                updateCounts();
            });

            /* ================= ROW CHECKBOX ================= */
            $('#VerifyOrders_Search_Billing tbody')
                .off('change', 'input.row-checkbox')
                .on('change', 'input.row-checkbox', function () {

                    $(this).closest('tr')
                        .toggleClass('selected-row', this.checked);

                    updateCounts();
                });

            /* ================= SEARCH / DRAW ================= */
            table.on('draw search.dt', function () {

                table.$('input.row-checkbox').each(function () {
                    $(this).closest('tr')
                        .toggleClass('selected-row', this.checked);
                });

                updateCounts();
            });
        },

        error: function (error) {
            $('#load1').hide();
            alert('Error: ' + error.responseText);
        }
    });

    return false;
}


function updateCounts() {

    var totalRows = $('#VerifyOrders_Search_Billing').DataTable().rows().count();

    var selectedFiltered = table.rows({ search: 'applied' }).nodes().to$().find('input.row-checkbox:checked').length;

    $('#lbltotalcount').text(totalRows);
    $('#lblfiltercount').text("Total Selected Orders For Verification : " + selectedFiltered);

    var totalFiltered = table.rows({ search: 'applied' }).nodes().to$().find('input.row-checkbox').length;

    $('#chkall').prop('checked', totalFiltered > 0 && selectedFiltered === totalFiltered);
}


function Bind_SearchBilling_Grid(prjno, fromdate, todate) {
    $('#load1').show();
    var visibleRows = 0;
    var table;

    $.ajax({
        url: "VerifyBilling.aspx/GetDataForBilling",
        type: "POST",
        data: "{ProjectNo:'" + prjno + "',FromDate:'" + fromdate + "',ToDate:'" + todate + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            var rowCount = data.d.length;

            if ($.fn.DataTable.isDataTable('#VerifyOrders_Search_Billing')) {
                $('#VerifyOrders_Search_Billing').DataTable().clear().destroy();
            }

            table = $('#VerifyOrders_Search_Billing').DataTable({
                dom: 'Bftp',
                data: dataArray,
                scrollX: true,
                paging: false,
                autoWidth: true,
                processing: true,
                ordering: false,
                serverSide: false,
                columns: [
                    { data: "" },  // first column for checkbox
                    { data: "" },
                    { data: "SrNo" },
                    { data: "ClientOrderNo" },
                    { data: "State" },
                    { data: "County" },
                    { data: "OrderDate" },
                    { data: "DeliveredDate" },
                    { data: "NoOfDocuments" },
                    { data: "NoOfPages" },
                    { data: "TaxInformation" },
                    { data: "CalledTaxes" },
                    { data: "PropertySearchCost" },
                    { data: "DocumentDownloadCost" },
                    { data: "TotalRetrievalCostSearchingDownloading" },
                    { data: "PropertyType" },
                    { data: "ProductType" },
                    { data: "ProcessDone" },
                    { data: "ProcessStatus" },
                    { data: "OnOffLine" },
                    { data: "Typing" },
                    { data: "SnippingTools" },
                    { data: "Remark" },
                    { data: "AbstractorSearchCost" },
                    { data: "AbstractorCopyCostCost" },
                    { data: "Abstractorpaid" },
                    { data: "AbstractorName" },
                    { data: "OrderCost" },
                    { data: "OrderID" }
                ],
                columnDefs: [
                    {
                        targets: 0, // first column = checkbox
                        orderable: false,
                        className: "text-center",
                        render: function (data, type, row, meta) {
                            return '<input type="checkbox" class="row-checkbox" id="chk_' + row.OrderID + '" value="' + row.OrderID + '"/>'
                                + '<label for="chk_' + row.OrderID + '"></label>';
                        }
                    },
                    {
                        targets: 1, // index 2 = Edit button column
                        orderable: false,
                        className: "text-center",
                        render: function (data, type, row, meta) {

                            var rowIndex = meta.row; // 0-based index

                            return `<a class="dropdown-item" href="#!" onclick="verifyBilling_addRemark(${row.OrderID}, ${rowIndex});"><span style="color: #0f766e;"><i class="uil fs-0 me-2 uil-pen"></i></span>&nbsp;&nbsp;</a>`;
                        }
                    },
                    {
                        targets: [1, 3, 7, 8, 9, 10, 11, 12, 13, 19, 20, 22, 23, 24, 26], // columns 7 to 13 (0-indexed)
                        className: "text-center"
                        /* { targets: "_all", className: "text-center" }*/
                    },
                    {
                        targets: 28, visible: false
                    },
                ],
                initComplete: function () {
                    var table = $('#VerifyOrders_Search_Billing').DataTable();
                    var rowCount = table.rows().count();  // total rows
                    $('#lbltotalcount').text("Total Orders : " + rowCount);
                    $('#load1').hide();
                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: title,
                    },
                ],
            });

            /* var table = $('#VerifyOrders_Search_Billing').DataTable();*/

            // Header checkbox selects/deselects all rows
            $('#chkall').off('click').on('click', function () {

                var isChecked = $(this).is(':checked');

                table.$('input.row-checkbox').each(function () {

                    $(this).prop('checked', isChecked);

                    // Add or remove row highlight
                    if (isChecked) {

                        $(this).closest('tr').addClass('selected-row');

                        visibleRows = table.$('input.row-checkbox:checked').length;

                        $('#lblfiltercount').text("Total Selected Orders For Verification : " + visibleRows);
                    }
                    else {
                        $(this).closest('tr').removeClass('selected-row');
                        $('#lblfiltercount').text("Total Selected Orders For Verification : 0");
                    }
                });
            });

            table.on('draw', function () {

                // visible rows after filter/search

                var visibleRows = table.rows({ filter: 'applied' }).count();
                var selectedFiltered = table.rows({ search: 'applied' }).nodes().to$().find('input.row-checkbox:checked').length;

                $('#lblfiltercount').text("Total Selected Orders For Verification : " + selectedFiltered);

                // restore row highlight
                table.$('input.row-checkbox').each(function () {
                    $(this).closest('tr').toggleClass('selected-row', $(this).is(':checked'));
                });
            });

            // Update header checkbox and row color if any row checkbox is toggled
            $('#VerifyOrders_Search_Billing tbody').off('change', 'input.row-checkbox').on('change', 'input.row-checkbox', function () {

                var totalChecked = table.$('input.row-checkbox:checked').length;
                $('#lblfiltercount').text("Total Selected Orders For Verification: " + totalChecked);

                /*alert($('#lblCheckedCount').text());*/
                var allChecked = table.$('input.row-checkbox').length === totalChecked;
                $('#chkall').prop('checked', allChecked);

                // Add or remove row highlight
                if ($(this).is(':checked')) {
                    $(this).closest('tr').addClass('selected-row');

                } else {
                    $(this).closest('tr').removeClass('selected-row');
                }
            });
        },

        error: function (error) {
            $('#load1').hide();
            alert('Error: ' + error.responseText);
        }
    });
    return false;
}

function verifyBilling_addRemark(orderid, index) {

    $('#VerifyOrders_Search_Billing tr').css('background-color', '');
    $('#VerifyOrders_Search_Billing tr').css('font-weight', 'normal');

    var table = $('#VerifyOrders_Search_Billing').DataTable();
    var rowData = table.row(index).data();
    var rowNode = table.row(index).node();

    // $(rowNode).css({ 'background-color': '#cdf5ee!important', 'font-weight': 'bold' });
    rowNode.style.setProperty('background-color', '#CDF5EE', 'important');
    rowNode.style.setProperty('font-weight', 'bold');

    remark_orderid = orderid;

    $("#lblupdateRemark").text("Add Remark : " + rowData.ClientOrderNo);

    var ddlprjNo = document.getElementById("VerifyOrdres_projectno");
    var prjNo = ddlprjNo.options[ddlprjNo.selectedIndex].text;

    if (prjNo === "735" || prjNo === "547-002" || prjNo === "1017" || prjNo === "669" || prjNo === "591") {
        $('#costingDiffEmail_div').show();
    } else {
        $('#costingDiffEmail_div').hide();
    }

    $('#popUp_viewBilling_addRemark').modal('show');
}

function btnverfybilling_AddRemark() {

    alert("");

    var orderCost = $('#vrbil_orderCost').val();
    var remark = $('#vrbil_remark').val().trim();

    var isAdditionalChecked = $('#vrbil_additional').is(':checked');
    var emailInput = $('#vrbil_EmailNote').val() ? $('#vrbil_EmailNote').val().trim() : '';
    var vrbil_costDiff = $('#vrbil_costDiff').val() ? $('#vrbil_costDiff').val().trim() : '';
    var fileInput = document.getElementById('vrbil_attachment');
    var selectedFile = null;

    if (fileInput && fileInput.files && fileInput.files.length > 0) {
        selectedFile = fileInput.files[0];
    }

    var ddlprjNo = document.getElementById("VerifyOrdres_projectno");
    var prjValue = ddlprjNo ? ddlprjNo.value : "";

    var ddldateprd = document.getElementById("VerifyOrdres_dateperild");
    var dateprd = ddldateprd.options[ddldateprd.selectedIndex].text;

    if (remark === "") {

        Swal.fire({
            icon: "warning", title: "Remark Required", text: "Please enter a remark.", confirmButtonText: "OK"
        }).then(function () {
            $('#vrbil_remark').focus();
        });

        return false;
    }


    // Validate additional fields only when switch is ON

    if (isAdditionalChecked) {

        if (vrbil_costDiff === "" || vrbil_costDiff === null || parseFloat(vrbil_costDiff) <= 0) {

            Swal.fire({
                icon: "warning", title: "Amount Required", text: "Please enter a cost difference.", confirmButtonText: "OK"
            }).then(function () {
                $('#vrbil_costDiff').focus();
            });

            return false;
        }

        if (emailInput === "") {
            Swal.fire({
                icon: "warning", title: "Email Required", text: "Please enter an email address.", confirmButtonText: "OK"
            }).then(function () {
                $('#vrbil_EmailNote').focus();
            });
            return false;
        }

        if (!selectedFile) {
            Swal.fire({ icon: "warning", title: "Attachment Required", text: "Please select a file to upload.", confirmButtonText: "OK" });
            return false;
        }
    }


    // Show loading
    Swal.fire({
        title: "Saving...", text: "Please wait while the details are being saved.", allowOutsideClick: false, allowEscapeKey: false, showConfirmButton: false,
        didOpen: function () {
            Swal.showLoading();
        }
    });

    function showSaveError(error, fallbackMessage) {
        Swal.close();

        var errorMessage = fallbackMessage || "An error occurred while adding the remark.";
        if (error && error.responseJSON && error.responseJSON.Message) {
            errorMessage = error.responseJSON.Message;
        } else if (error && error.responseText) {
            errorMessage = error.responseText;
        } else if (typeof error === "string" && error) {
            errorMessage = error;
        }

        Swal.fire({ icon: "error", title: "Error", text: errorMessage, confirmButtonText: "OK" });
    }

    function saveRemark(attachmentPath) {
        $.ajax({
            type: "POST",
            url: "VerifyBilling.aspx/AddRemark_VerifyBilling",
            data: JSON.stringify({
                Project: prjValue,
                BillingPeriod: dateprd,
                OrderID: remark_orderid,
                OrderCost: isAdditionalChecked ? orderCost : "",
                Remark: remark,
                IsMailInput: isAdditionalChecked,
                EmailInput: isAdditionalChecked ? emailInput : "",
                CostDiff: isAdditionalChecked ? vrbil_costDiff : 0,
                AttachmentPath: attachmentPath || ""
            }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function () {
                Swal.close();
                Swal.fire({
                    icon: "success", title: "Success", text: "Remark and details saved successfully!", confirmButtonText: "OK"
                }).then(function () {
                    vrbil_clearAdditionalFields(2);
                });
            },
            error: function (xhr) {
                showSaveError(xhr, "An error occurred while adding the remark.");
            }
        });
    }

    if (isAdditionalChecked) {
        var attachmentForm = new FormData();
        attachmentForm.append("Project", prjValue);
        attachmentForm.append("BillingPeriod", dateprd);
        attachmentForm.append("OrderID", remark_orderid);
        attachmentForm.append("vrbil_attachment", selectedFile);

        $.ajax({
            type: "POST",
            url: "VerifyBilling.aspx?uploadVerifyBillingAttachment=1",
            data: attachmentForm,
            processData: false,
            contentType: false,
            dataType: "json",
            success: function (result) {
                if (!result || !result.Success) {
                    showSaveError((result && result.Message) || "Unable to upload attachment.", "Unable to upload attachment.");
                    return;
                }

                saveRemark(result.AttachmentPath || "");
            },
            error: function (xhr) {
                showSaveError(xhr, "Unable to upload attachment.");
            }
        });
    } else {
        saveRemark("");
    }


    return false;
}

function clearBillingFields() {


    $('#VerifyOrders_Search_Billing tr').css('background-color', '');
    $('#VerifyOrders_Search_Billing tr').css('font-weight', 'normal');

    $('#vrbil_orderCost').val('');
    $('#vrbil_remark').val('');
}

function Bind_TotalOrders_Summary(prjno, fromdate, todate) {

    $('#load1').show();
    $('#totalOrdersSummary').empty();

    if (verifyBillingSummaryRequest && verifyBillingSummaryRequest.readyState !== 4) {
        verifyBillingSummaryRequest.abort();
    }

    verifyBillingSummaryRequest = $.ajax({
        url: "VerifyBilling.aspx/GetDataForSummary",
        type: "POST",
        data: JSON.stringify({ ProjectNo: prjno, FromDate: fromdate, ToDate: todate }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            renderTotalOrdersSummary(dataArray);

            if ($.fn.DataTable.isDataTable('#table_grdPending')) {
                $('#table_grdPending').DataTable().clear().destroy();
            }

            $('#table_grdPending').DataTable({
                dom: 't',
                data: dataArray,
                scrollX: true,
                paging: true,
                autoWidth: true,
                processing: true,
                ordering: false,
                serverSide: false,

                columns: [
                    { data: "BillingPeriod" },
                    { data: "Received" },
                    { data: "Dispatch" },
                    { data: "Cancel" },
                    { data: "Hold" },
                    { data: "Typing" },
                    { data: "Tax" }
                ],
                columnDefs: [
                    {
                        targets: "_all",
                        className: "col-border text-center"
                    }
                ],
                initComplete: function () {

                    $('#load1').hide();
                }
            });
        },

        error: function (error) {
            $('#load1').hide();

            if (error.statusText === 'abort') {
                return;
            }

            $('#totalOrdersSummary').html('<div class="summary-empty"><i class="fas fa-exclamation-circle"></i><span>Unable to load the order summary.</span></div>');
            alert('Error: ' + error.responseText);
        },

        complete: function () {
            verifyBillingSummaryRequest = null;
        }
    });
    return false;
}

function renderTotalOrdersSummary(dataArray) {
    var $summary = $('#totalOrdersSummary');
    var rows = Array.isArray(dataArray) ? dataArray : [];

    if (!rows.length) {
        $summary.html('<div class="summary-empty"><i class="fas fa-inbox"></i><span>No order summary is available for the selected period.</span></div>');
        return;
    }

    var metrics = [
        { key: 'Received', label: 'Received', icon: 'fa-inbox', tone: 'received' },
        { key: 'Cancel', label: 'Cancel', icon: 'fa-times-circle', tone: 'cancel' },
        { key: 'Dispatch', label: 'Dispatch', icon: 'fa-paper-plane', tone: 'dispatch' },
        { key: 'Pending', label: 'Pending Search', icon: 'fa-search', tone: 'pending-search' },
        { key: 'Hold', label: 'Hold', icon: 'fa-pause-circle', tone: 'hold' },
        { key: 'Typing', label: 'Pending Typing', icon: 'fa-keyboard', tone: 'pending-typing' },
        { key: 'Tax', label: 'Pending Tax', icon: 'fa-receipt', tone: 'pending-tax' }
    ];

    function encode(value) {
        return $('<div/>').text(blankForNull(value)).html();
    }

    var html = rows.map(function (row) {
        var cards = metrics.map(function (metric) {
            return '<div class="summary-metric ' + metric.tone + '">'
                + '<span class="summary-metric-label"><i class="fas ' + metric.icon + ' mr-1"></i>' + metric.label + '</span>'
                + '<span class="summary-metric-value">' + encode(row[metric.key]) + '</span>'
                + '</div>';
        }).join('');

        return '<section class="summary-period">'
            + '<div class="summary-period-header"><i class="fas fa-calendar-alt"></i>'
            + '<span>Order Details For Billing Period : ' + encode(row.BillingPeriod) + '</span>'
            + '<span class="summary-project">Project : ' + encode(row.ProjectNumber) + '</span></div>'
            + '<div class="summary-metrics">' + cards + '</div>'
            + '</section>';
    }).join('');

    $summary.html(html);
}


function VerifyOrdres_Verify() {

    const project = $("#VerifyOrdres_projectno option:selected").text().trim();
    const remark = $("#VerifyOrdres_Remark").val().trim();
    var ddlprj_billPeriod = document.getElementById("VerifyOrdres_BillingCycle");
    var billingPeriod = ddlprj_billPeriod.options[ddlprj_billPeriod.selectedIndex].text;

    if (!project) {
        Swal.fire({
            icon: "warning",
            title: "Project Required",
            text: "Please select a project."
        });
        return;
    }

    if (!remark) {
        Swal.fire({
            icon: "warning",
            title: "Remark Required",
            text: "Please enter a remark."
        });
        $("#VerifyOrdres_Remark").focus();
        return;
    }

    const table = $("#VerifyOrders_Search_Billing").DataTable();
    const selectedOrderIDs = [];

    table.$("input.row-checkbox:checked").each(function () {
        selectedOrderIDs.push($(this).val());
    });

    if (selectedOrderIDs.length === 0) {
        Swal.fire({
            icon: "warning",
            title: "No Orders Selected",
            text: "Please select at least one order."
        });
        return;
    }

    // Modern processing dialog
    Swal.fire({
        title: "Verifying Orders...",
        text: "Please wait while the selected orders are being verified.",
        allowOutsideClick: false,
        allowEscapeKey: false,
        didOpen: () => {
            Swal.showLoading();
        }
    });

    $.ajax({
        url: "VerifyBilling.aspx/VerifyOrders",
        type: "POST",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({
            OrderIDs: selectedOrderIDs.join(","),
            Project: project,
            Remark: remark,
            BillingPeriod: billingPeriod
        }),

        success: function (response) {

            Swal.close();

            if (response.d > 0) {

                Swal.fire({
                    icon: "success",
                    title: "Verification Complete",
                    text: "Selected orders have been verified successfully.",
                    confirmButtonText: "OK"
                }).then(() => {
                    // Refresh grid if required
                    // VerifyOrders_Search();
                });

            } else {

                Swal.fire({
                    icon: "error",
                    title: "Verification Failed",
                    text: "Unable to verify the selected orders. Please contact the administrator."
                });
            }
        },

        error: function () {

            Swal.close();

            Swal.fire({
                icon: "error",
                title: "Server Error",
                text: "An unexpected error occurred while verifying the orders. Please try again or contact the administrator."
            });
        }
    });
}

function VerifyOrdres_SendToAccount() {

    var $project = $('#VerifyOrdres_projectno');
    var $billingCycle = $('#VerifyOrdres_BillingCycle');
    var $billingPeriod = $('#VerifyOrdres_dateperild');
    var $remark = $('#VerifyOrdres_Remark');
    var $sendButton = $('#btnSendToAccount');

    var projectNo = $.trim($project.val());
    var projectName = $.trim($project.find('option:selected').text());
    var billingCycle = $.trim($billingCycle.val());
    var billingPeriod = $.trim($billingPeriod.val());
    var billingPeriodText = $.trim($billingPeriod.find('option:selected').text());
    var remark = $.trim($remark.val());
    var billingDates = billingPeriodText.split('~');
    var fromDate = billingDates.length > 1 ? $.trim(billingDates[0]) : '';
    var toDate = billingDates.length > 1 ? $.trim(billingDates[1]) : '';

    if (!projectNo) {
        Swal.fire({
            icon: 'warning',
            title: 'Project Required',
            text: 'Please select a project.',
            confirmButtonText: 'OK'
        }).then(function () {
            $project.focus();
        });

        return;
    }

    if (!billingCycle) {
        Swal.fire({
            icon: 'warning',
            title: 'Billing Cycle Required',
            text: 'Please select a billing cycle.',
            confirmButtonText: 'OK'
        }).then(function () {
            $billingCycle.focus();
        });

        return;
    }

    if (!billingPeriod) {
        Swal.fire({
            icon: 'warning',
            title: 'Billing Period Required',
            text: 'Please select a billing period.',
            confirmButtonText: 'OK'
        }).then(function () {
            $billingPeriod.focus();
        });

        return;
    }

    // Prevent duplicate clicks.
    $sendButton.prop('disabled', true);

    Swal.fire({
        title: 'Sending to Accounts',
        html:
            '<div class="account-mail-loader">' +
            '<div class="mail-icon-wrapper">' +
            '<i class="fa fa-envelope"></i>' +
            '<span class="mail-send-animation"></span>' +
            '</div>' +
            '<div class="mail-project-name">' + escapeHtml(projectName) + '</div>' +
            '<div class="mail-status-text" id="accountMailStatus">' +
            'Preparing billing summary and attachments...' +
            '</div>' +
            '<div class="mail-progress">' +
            '<div class="mail-progress-bar"></div>' +
            '</div>' +
            '</div>',
        allowOutsideClick: false,
        allowEscapeKey: false,
        showConfirmButton: false,
        didOpen: function () {
            Swal.showLoading();

            setTimeout(function () {
                $('#accountMailStatus').text('Sending email to the Accounting Team...'
                );
            }, 800);
        }
    });

    var toAddress = "anita@infinity-data.com";
    var toCC = "p.patil@infinityinternationals.us,t.jason@infinityinternationals.us,e.mike@infinityinternationals.us,c.eva@infinityinternationals.us ";
    var toBcc = "b.shubhangi@infinityinternationals.us";


    $.ajax({
        url: 'VerifyBilling.aspx/SendToAccounts',
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        dataType: 'json',

        data: JSON.stringify({
            ProjectID: parseInt(projectNo, 10),
            ProjectNo: projectName,
            BillingPeriod: billingPeriodText,
            FromDate: fromDate,
            ToDate: toDate,
            Remark: remark,
            ToAddress: toAddress,
            CC: toCC,
            Bcc: toBcc
        }),

        success: function (response) {

            var result = parseInt(response.d, 10) || 0;

            if (result > 0) {

                Swal.fire({
                    icon: 'success',
                    title: 'Email Sent Successfully',
                    html:
                        '<div class="email-success-details">' +
                        '<div><strong>Project:</strong> ' +
                        escapeHtml(projectName) +
                        '</div>' +
                        '<div><strong>Billing Cycle:</strong> ' +
                        escapeHtml(billingCycle) +
                        '</div>' +
                        '<div><strong>Billing Period:</strong> ' +
                        escapeHtml(billingPeriodText) +
                        '</div>' +
                        '<div class="success-note">' +
                        'The billing details and selected orders have been sent to the Accounting Team.' +
                        '</div>' +
                        '</div>',
                    confirmButtonText: 'Done',
                    confirmButtonColor: '#2563eb'
                });

            } else {

                Swal.fire({
                    icon: 'info',
                    title: 'No Email Sent',
                    text: 'No eligible orders were found for the selected project and billing period.',
                    confirmButtonText: 'Review Details'
                });
            }
        },

        error: function (xhr) {

            var errorMessage =
                'An error occurred while sending the email to the Accounting Team.';

            if (
                xhr.responseJSON &&
                xhr.responseJSON.Message
            ) {
                errorMessage = xhr.responseJSON.Message;
            } else if (xhr.responseText) {
                try {
                    var errorResponse = JSON.parse(xhr.responseText);

                    if (errorResponse.Message) {
                        errorMessage = errorResponse.Message;
                    }
                } catch (e) {
                    // Keep default message.
                }
            }

            Swal.fire({
                icon: 'error',
                title: 'Email Sending Failed',
                text: errorMessage,
                confirmButtonText: 'Close'
            });
        },

        complete: function () {
            $sendButton.prop('disabled', false);
        }
    });
}

function escapeHtml(value) {

    return $('<div>')
        .text(value || '')
        .html();
}

function vrbil_toggleAdditional() {

    var checkbox = document.getElementById("vrbil_additional");
    var section = document.getElementById("vrbil_additionalFields");

    if (!checkbox || !section) {
        return;
    }

    if (checkbox.checked) {

        section.style.display = "block";

        section.animate(
            [
                {
                    opacity: 0,
                    transform: "translateY(-8px)"
                },
                {
                    opacity: 1,
                    transform: "translateY(0)"
                }
            ],
            {
                duration: 220,
                easing: "ease-out"
            }
        );

    } else {

        var animation = section.animate(
            [
                {
                    opacity: 1,
                    transform: "translateY(0)"
                },
                {
                    opacity: 0,
                    transform: "translateY(-6px)"
                }
            ],
            {
                duration: 160,
                easing: "ease-in"
            }
        );

        animation.onfinish = function () {
            section.style.display = "none";

            // Clear all fields
            vrbil_clearAdditionalFields(1);
        };
    }
}

function vrbil_clearAdditionalFields(calltime) {


    var orderCost = document.getElementById("vrbil_orderCost");
    var remark = document.getElementById("vrbil_EmailNote");
    var additionalText = document.getElementById("vrbil_costDiff");
    var attachment = document.getElementById("vrbil_attachment");
    var fileName = document.getElementById("vrbil_fileName");

    if (orderCost) {
        orderCost.value = "";
    }

    if (remark) {
        remark.value = "";
    }

    if (additionalText) {
        additionalText.value = "";
    }

    if (attachment) {
        attachment.value = "";
    }

    if (fileName) {
        fileName.innerHTML = "or click to browse";
    }

    if (calltime == 2) {
        // Clear main fields
        $('#vrbil_orderCost').val('');
        $('#vrbil_remark').val('');

        // Clear additional fields
        $('#vrbil_EmailNote').val('');
        $('#vrbil_costDiff').val('');

        // Clear attachment
        $('#vrbil_attachment').val('');

        // Reset file upload text
        $('#vrbil_fileName').html('or click to browse');

        // Reset checkbox
        $('#vrbil_additional').prop('checked', false);

        // Hide additional section
        $('#vrbil_additionalFields').hide();


        // Reset table row formatting
        $('#VerifyOrders_Search_Billing tr').css({ 'background-color': '', 'font-weight': 'normal' });


        // Close modal
        $('#popUp_viewBilling_addRemark').modal('hide');
    }
}

function vrbil_showFileName(input) {

    var fileNameElement = document.getElementById("vrbil_fileName");

    if (!fileNameElement) {
        return;
    }

    if (input.files && input.files.length > 0) {

        var file = input.files[0];

        fileNameElement.innerHTML =
            "&#10003;&nbsp; " + file.name;

    } else {

        fileNameElement.innerHTML = "";

    }
}


/*
 * Optional drag-over visual feedback.
 * No IDs changed.
 */
(function () {

    var dropzone = document.getElementById("vrbil_dropzone");

    if (!dropzone) {
        return;
    }

    ["dragenter", "dragover"].forEach(function (eventName) {

        dropzone.addEventListener(eventName, function (event) {

            event.preventDefault();

            dropzone.style.borderColor = "#0c8f8f";
            dropzone.style.background = "#f2fbfa";

        });

    });


    ["dragleave", "drop"].forEach(function (eventName) {

        dropzone.addEventListener(eventName, function () {

            dropzone.style.borderColor = "";
            dropzone.style.background = "";

        });

    });

})();
