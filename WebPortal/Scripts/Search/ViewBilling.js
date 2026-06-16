
var table_InterCosting_Report_html;

function blankForNull(s) {
    return s == "null" || s == null ? "" : s;

}

function getFirstDayOfMonth(date) {
    return new Date(date.getFullYear(), date.getMonth(), 1);
}

function ViewBilling_BindProject() {

    var select = document.getElementById("ViewBilling_projectno");
    let options = select.getElementsByTagName('ViewBilling_projectno');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#VerifyOrdres_projectno").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "ViewBilling.aspx/GetAllProjectNo", dataType: "json", contentType: "application/json",
        success: function (res) {

            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (data, value) {

                $("#ViewBilling_projectno").append($("<option></option>").val(value.ProjectID).html(value.ProjectName));
            })
        }
    });
}

function ViewBilling_btnShowDetails() {

    var FromDate1 = document.getElementById("ViewBilling_FromDate").value;
    var ToDate1 = document.getElementById("ViewBilling_ToDate").value;

    var ddl = document.getElementById("ViewBilling_projectno");
    var ProjectNo = ddl.options[ddl.selectedIndex].text;

    if (FromDate1 == "") {
        alert("Please select From Date.");
        return false;
    }
    if (ToDate1 == "") {
        alert("Please select To Date.");
        return false;
    }

    if (ProjectNo == "") {
        alert("Please select ProjectNo.");
        return false;
    }

    if (FromDate1 != null && ToDate1 != null) {
        BindInternal_Costing_Report(ProjectNo, FromDate1, ToDate1)
    }
}

function buildDynamicHeader(config) {
    const thead = $("#dynamicHeader");
    thead.empty();

    config.forEach(row => {
        const tr = $("<tr>");

        row.cells.forEach(cell => {
            const th = $("<th>").text(cell.title);

            if (cell.colspan) th.attr("colspan", cell.colspan);
            if (cell.rowspan) th.attr("rowspan", cell.rowspan);

            tr.append(th);
        });

        thead.append(tr);
    });
}

function BindInternal_Costing_Report(ProjectNo, FromDate, ToDate) {
    $('#load1').show();

    title = "Verify Billing_" + ProjectNo + "_" + FromDate + "_" + ToDate;

    $.ajax({
        url: "ViewBilling.aspx/GetDataInternalCosting",
        type: "POST",
        dataType: "json",
        data: JSON.stringify({ ProjectNo: ProjectNo, FromDate: FromDate, ToDate: ToDate }),
        contentType: "application/json; charset=utf-8",
        success: function (data) {

            var dataArray = JSON.parse(data.d);

            // Destroy existing table if exists
            if ($.fn.DataTable.isDataTable('#costingTable')) {
                $('#costingTable').DataTable().clear().destroy();
            }

            $('#costingTable').DataTable({
                dom: 'Bftip',
                data: dataArray,
                scrollX: true,
                paging: true,
                autoWidth: true,
                processing: true,
                ordering: false,
                serverSide: false,

                columns: [
                    { data: "SrNo" },
                    { data: "ClientOrderNo" },
                    { data: "OrderDate" },
                    { data: "SearchEngine" },
                    { data: "SearchType" },
                    { data: "State" },
                    { data: "County" },
                    { data: "DeliveredDate" },
                    { data: "NoOfDocuments" },
                    { data: "NoOfPages" },
                    { data: "TaxInformation" },
                    { data: "CalledTaxes" },
                    { data: "BName" },
                    { data: "PropertyAddress" },
                    { data: "OnOffLine" },
                    { data: "PropertyType" },
                    { data: "ProductType" },
                    { data: "ProcessDone" },
                    { data: "ProcessStatus" },

                    // Production Costing
                    { data: "SearchCostNoOfSearches" },
                    { data: "SearchCostCost" },
                    { data: "SearchCostTotal" },

                    { data: "SearchCopyCostPattern" },
                    { data: "SearchCopyCostMainNo" },
                    { data: "SearchCopyCostCostMain" },
                    { data: "SearchCopyCostTotalMain" },
                    { data: "SearchCopyCostNo" },
                    { data: "SearchCopyCostCost" },
                    { data: "SearchCopyCostTotal" },
                    { data: "SearchTotalCost" },

                    { data: "JudgmentSearchCostNoOfSeraches" },
                    { data: "JudgmentSearchCostCost" },
                    { data: "JudgmentSearchCostTotal" },

                    { data: "JudgmentCopyCostPattern" },
                    { data: "JudgmentCopyCostMainNo" },
                    { data: "JudgmentCopyCostCostMain" },
                    { data: "JudgmentCopyCostTotalMain" },
                    { data: "JudgmentCopyCostMainNo" },
                    { data: "JudgmentCopyCostCost" },
                    { data: "JudgmentCopyCostTotal" },
                    { data: "JudgmentTotalCost" },

                    { data: "TaxChargesDescription" },
                    { data: "TaxAmount" },
                    { data: "OtherChargesDescription" },
                    { data: "OtherChargesAmount" },
                    { data: "Remark" },
                    { data: "ProductionCost" },

                    // Abstractor
                    { data: "AbstractorSearchCost" },
                    { data: "AbstractorCopyCostPages" },
                    { data: "AbstractorCopyCostCost" },
                    { data: "OtherCost" },
                    { data: "AbstractorTotalCost" },

                    { data: "OrderCost" },

                    // Credit Card
                    { data: "NameOfTheCard1" },
                    { data: "CreditCardNo1" },
                    { data: "NameOfThePlant1" },
                    { data: "SearchingAmount1" },
                    { data: "DownloadingAmount1" },
                    { data: "CRValidUpTo" }
                ],
                initComplete: function () {

                    $('#load1').hide();
                },
                buttons: [
                    {
                        extend: 'excelHtml5', title
                    },
                ],
            });
        },
        error: function (error) {
            alert('Error: ' + error.responseText);
            $('#load1').hide();
        }
    });
}



