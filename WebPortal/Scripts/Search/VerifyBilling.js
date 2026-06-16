
var title;
var remark_orderid = 0;

function blankForNull(s) {
    return s == "null" || s == null ? "" : s;

}

function getFirstDayOfMonth(date) {
    return new Date(date.getFullYear(), date.getMonth(), 1);
}

function VerifyOrdres_Show() {

    var ddlprjNo = document.getElementById("VerifyOrdres_projectno");
    var prjNo = ddlprjNo.options[ddlprjNo.selectedIndex].text;

    var ddlBillCyc = document.getElementById("VerifyOrdres_BillingCycle");
    var billCyc = ddlBillCyc.options[ddlBillCyc.selectedIndex].text;

    var ddldateprd = document.getElementById("VerifyOrdres_dateperild");
    var dateprd = ddldateprd.options[ddldateprd.selectedIndex].text;

    title = "VerifyBilling_" + prjNo + "_" + billCyc + "_" + dateprd;

    var dates = dateprd.split('~');

    var date1 = dates[0].trim();
    var date2 = dates[1].trim();

    if (prjNo == "") {

        alert("Please select Project No.");
        return false;
    }
    if (billCyc == "") {

        alert("Please select Billing Cycle.");
        return false;
    }

    if (dateprd == "") {

        alert("Please select Date Period.");
        return false;
    }

    if (prjNo != null && billCyc != null && dateprd != null) {

        Bind_TotalOrders_Summary(prjNo, date1, date2);
        Bind_SearchBilling_Grid(prjNo, date1, date2);
    }
}

function BindDatePeriod() {
    var select = document.getElementById("VerifyOrdres_dateperild");
    let options = select.getElementsByTagName('VerifyOrdres_dateperild');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

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
    let options = select.getElementsByTagName('VerifyOrdres_BillingCycle');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

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
    let options = select.getElementsByTagName('VerifyOrdres_projectno');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

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

                            return `<a class="dropdown-item" href="#!" onclick="verifyBilling_addRemark(${row.OrderID}, ${rowIndex});"><span style="color: blue;"><i class="uil fs-0 me-2 uil-pen"></i></span>&nbsp;&nbsp;</a>`;

                            /*return `<a class="dropdown-item edit-order" href="#!" data-orderid="${row.OrderID}"><span style="color: forestgreen;"><i class="uil fs-0 me-2 uil-pen"></i></span>&nbsp;&nbsp;</a>`;*/
                            /*                            return `<a class="dropdown-item edit-order" href="#!" onclick="verifyBilling_addRemark(data-orderid="${row.OrderID} ",data-rowindex="${rowIndex});><span style="color: forestgreen;"><i class="uil fs-0 me-2 uil-pen"></i></span>&nbsp;&nbsp;</a>`;*/

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

    $('#popUp_viewBilling_addRemark').modal('show');
}

function btnverfybilling_AddRemark() {

    var orderCost = $('#vrbil_orderCost').val();
    var remark = $('#vrbil_remark').val();

    if (orderCost === "" || orderCost <= 0) {
        alert("Please enter valid order cost");
        return false;
    }

    if (remark === "") {
        alert("Please enter remark");
        return false;
    }

    $.ajax({
        type: "POST",
        url: "VerifyBilling.aspx/AddRemark_VerifyBilling",
        data: JSON.stringify({
            OrderID: remark_orderid,
            OrderCost: orderCost,
            Remark: remark
        }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (res) {
            alert("Remark added successfully!");

            // optional: clear fields
            $('#vrbil_orderCost').val('');
            $('#vrbil_remark').val('');

            $('#VerifyOrders_Search_Billing tr').css('background-color', '');
            $('#VerifyOrders_Search_Billing tr').css('font-weight', 'normal');

            // optional: close modal
            $('#popUp_viewBilling_addRemark').modal('hide');
        },
        error: function () {
            alert("Error while adding data");
        }
    });

    return false; // 🔥 VERY IMPORTANT: stops form submit
}

function clearBillingFields() {


    $('#VerifyOrders_Search_Billing tr').css('background-color', '');
    $('#VerifyOrders_Search_Billing tr').css('font-weight', 'normal');

    $('#vrbil_orderCost').val('');
    $('#vrbil_remark').val('');
}

function Bind_TotalOrders_Summary(prjno, fromdate, todate) {

    $('#load1').show();

    $.ajax({
        url: "VerifyBilling.aspx/GetDataForSummary",
        type: "POST",
        data: "{ProjectNo:" + prjno + ", FromDate:'" + fromdate + "',ToDate:'" + todate + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

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
                    { data: "Pending" },
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
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}

function VerifyOrdres_Verify() {

    var ddlprj_vrf = document.getElementById("VerifyOrdres_projectno");
    var project = ddlprj_vrf.options[ddlprj_vrf.selectedIndex].text;
    var remark = document.getElementById("VerifyOrdres_Remark").value;

    if (project != "" && remark != "") {

        $('#waitingpanel').modal('show');

        var table = $('#VerifyOrders_Search_Billing').DataTable();
        var selectedOrderIDs = [];

        table.$('input.row-checkbox:checked').each(function () {

            selectedOrderIDs.push($(this).val());
        });

        if (selectedOrderIDs.length === 0) {
            alert('Please select at least one order.');
            return;
        }

        $.ajax({
            url: "VerifyBilling.aspx/VerifyOrders",
            type: "POST",
            data: "{OrderIDs:'" + selectedOrderIDs + "',Project:'" + project + "',Remark:'" + remark + "'}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",

            success: function (response) {

                $('#waitingpanel').modal('hide');

                if (response.d > 0)
                    alert("Selected orders verified successfully!");
                else
                    alert("Oops! Error occured while verifying orders. Please contact administrator!");
            },

            error: function (err) {

                $('#waitingpanel').modal('hide');
                alert("Oops! Error occured while verifying orders. Please contact administrator!");
            }
        });
    }
    else {

        if (remark == "") {

            alert("Please enter Remark!");
        }
    }
}

function VerifyOrdres_SendToAccount() {

    var ddlprj1 = document.getElementById("VerifyOrdres_projectno"); alert(ddlprj1);
    var projectID = ddlprj1.options[ddlprj1.selectedIndex].value;
    var project = ddlprj1.options[ddlprj1.selectedIndex].text;

    var ddlbillCycle = document.getElementById("VerifyOrdres_BillingCycle");
    var billCycle = ddlbillCycle.options[ddlbillCycle.selectedIndex].text;

    var ddldatePeriod = document.getElementById("VerifyOrdres_dateperild");
    var datePeriod = ddldatePeriod.options[ddldatePeriod.selectedIndex].text;

    if (projectID != "" && billCycle != "" && datePeriod != "") {

        $.ajax({
            url: "VerifyBilling.aspx/SendToAccounts",
            type: "POST",
            data: "{ProjectID:'" + projectID + "',Project:'" + project + "',BillingCycle:'" + billCycle + "',BillingPeriod:'" + datePeriod + "'}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",

            success: function (response) {

                $('#waitingpanel').modal('hide');

                if (response.d > 0)
                    alert("Orders send to account successfully!");
                else
                    alert("Oops! Error occured while sending orders. Please contact administrator!");
            },

            error: function (err) {

                $('#waitingpanel').modal('hide');
                alert(err.responseText);
            }
        });
    }
    else {

        if (projectID == "") {

            alert("Please select Project.");
        }
        if (billCycle == "") {

            alert("Please select Billing Cycle!");
        }
        if (datePeriod == "") {

            alert("Please select Billing Period!");
        }
    }
}




