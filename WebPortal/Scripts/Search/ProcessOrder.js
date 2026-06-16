var ProcessOrders_html;
var InvoiceID;


function blankForNull(s) {
    return s == "null" || s == null ? "" : s;

}

function getFirstDayOfMonth(date) {
    return new Date(date.getFullYear(), date.getMonth(), 1);
}


function BindGrid_PendingOrders() {

    $('#load1').show();
    ProcessOrders_html = '';

    $.ajax({
        url: "ProcessOrders.aspx/GetAllPendingOrders",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
           
            var dataArray = JSON.parse(data.d);
            $.each(dataArray, function (index, value) {
                
                ProcessOrders_html += '<tr>';
                ProcessOrders_html += '<td class=""><div class="btn-group">';
                ProcessOrders_html += '<div class="btn-group">';
                ProcessOrders_html += '<div type="button" data-toggle="dropdown" aria-expanded="false"><i style="color: dodgerblue; font-size:14px;" class="uil fs-0 me-2 uil-cog"></i>';
                ProcessOrders_html += '<span class="sr-only"></span></div><div class="dropdown-menu" role="menu" style="">';
                ProcessOrders_html += '<a class="dropdown-item" href="#!" id="Actions" onclick="CompleteOrderProcess(\'' + blankForNull(value.OrderID) + '\',' + index + ',1);"><span style="color: forestgreen;"><i class="uil fs-0 me-2 uil-pen"></i></span>&nbsp;&nbsp;Complete Order</a>';
                ProcessOrders_html += '<a class="dropdown-item" href="#!" id="Actions" onclick="CompleteOrderProcessCosting(\'' + blankForNull(value.OrderID) + '\',' + index + ',1);"><span style="color: forestgreen;"><i class="uil fs-0 me-2 uil-pen"></i></span>&nbsp;&nbsp;Order Costing</a>';
                ProcessOrders_html += '<td style="text-wrap: nowrap;text-align:center;">' + blankForNull((index + 1)) + '</td>';
                ProcessOrders_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.OrderID) + '</td>';
                ProcessOrders_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ProjectNumber) + '</td>';
                ProcessOrders_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ClientOrderNo) + '</td>';
                ProcessOrders_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.OnOffLine) + '</td>';
                ProcessOrders_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.OrderDate) + '</td>';
                ProcessOrders_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ProductType) + '</td>';
                ProcessOrders_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Process) + '</td>';
                ProcessOrders_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.AssignedDate) + '</td>';
                ProcessOrders_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#invrec_SearchProcess')) {
                invrec_SearchProcess.destroy();
            }
            $('#invrec_SearchProcess tbody').html(ProcessOrders_html);

            invrec_SearchProcess = $('#invrec_SearchProcess').DataTable({
                dom: 'lftip',
                destroy: true,
                scrollX: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                'select': {
                    'style': 'single'
                },

                initComplete: function () {
                    /*jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');*/
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

function CompleteOrderProcessCosting(InvoiceId, selected) {
    $('#OrderCosting').modal('show');

}
function CompleteOrderProcess(InvoiceId, selected) {

    var row = invrec_SearchProcess.row(selected).data();
    document.getElementById("lblcompany").innerHTML = "<b>Project No : </b>" + row[3];
    document.getElementById("lblInvoiceType").innerHTML = "<b> Order Date : </b>" + row[6];
    document.getElementById("lblInvoiceNo").innerHTML = "<b>OrderNo # : </b>" + row[4];
    document.getElementById("lblInvoiceAmout").innerHTML = "<b>Process : </b>" + row[8];
    document.getElementById("lblInvoiceDate").innerHTML = "<b>OnOffline : </b>" + row[5];
    popUp_InvID = InvoiceId;
    //popUp_Company = row[3];
    //popUp_InvType = row[6];

    $('#CompleteOrder').modal('show');
}


