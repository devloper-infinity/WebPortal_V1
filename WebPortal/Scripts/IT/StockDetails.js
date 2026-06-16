
function BindStockDetail_Grid() {

    $('#load1').show();

    $.ajax({
        url: 'StockReport.aspx/ViewStockDetailsReport',
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = JSON.parse(data.d);

            if ($.fn.DataTable.isDataTable('#table_stockDetails')) {
                $('#table_stockDetails').DataTable().clear().destroy();
            }

            table = $('#table_stockDetails').DataTable({
                dom: 'lBftp',
                data: dataArray,
                scrollX: true,
                paging: true,
                autoWidth: true,
                processing: true,
                ordering: false,
                serverSide: false,

                columns: [
                    { data: 'SrNo', className: 'text-center' },
                    { data: 'Section' },
                    { data: 'DeskNo' },
                    { data: 'KeyboardBarcode' },
                    { data: 'KeyboardSrNo' },
                    { data: 'MouseBarcode' },
                    { data: 'MouseSrNo' },
                    { data: 'MonitorBarcode' },
                    { data: 'MonitorSrNo' },
                    { data: 'CPUBarcode' },
                    { data: 'CPUSrNo' },
                    { data: 'IPAddress' },
                    { data: 'DayUser1' },
                    { data: 'EveUser1' },
                    { data: 'NgtUser1' },
                    { data: 'IsDedicated' },
                    { data: 'Remark' }
                ],

                initComplete: function () {

                    $('#load1').hide();
                },

                buttons: [
                    {
                        extend: 'excelHtml5', title: "Stock Detail Report",
                    },
                ],
            });
        },

        error: function (error) {
            alert('Error: ' + error.responseText);
        }
    });

    return false;
}
