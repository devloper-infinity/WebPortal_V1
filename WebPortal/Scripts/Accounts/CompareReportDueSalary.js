function BindMonthDropdowns() {
    var months = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
    ];
    var currentDate = new Date();
    var previousDate = new Date(currentDate.getFullYear(), currentDate.getMonth() - 1, 1);
    var options = '';

    $.each(months, function (_, month) {
        options += $('<option></option>').val(month).text(month).prop('outerHTML');
    });

    $('#comparedue_ddlCurrentMonth').html(options).val(months[currentDate.getMonth()]);
    $('#comparedue_ddlPreviousMonth').html(options).val(months[previousDate.getMonth()]);
}

function BindYearDropdowns() {
    var currentDate = new Date();
    var previousDate = new Date(currentDate.getFullYear(), currentDate.getMonth() - 1, 1);
    var firstYear = currentDate.getFullYear() + 1;
    var lastYear = currentDate.getFullYear() - 10;
    var options = '';

    for (var year = firstYear; year >= lastYear; year--) {
        options += $('<option></option>').val(year).text(year).prop('outerHTML');
    }

    $('#comparedue_ddlCurrentYear').html(options).val(currentDate.getFullYear());
    $('#comparedue_ddlPreviousYear').html(options).val(previousDate.getFullYear());
}

function comparedue_BindCompareDueReport() {
    comparedue_BindReport(
        'GetCompareDueReport',
        '#comparedue_tblCompareReport',
        'Due Salary Comparison'
    );
}

function comparedue_BindCompareNetReport() {
    comparedue_BindReport(
        'GetCompareNetReport',
        '#comparenet_tblCompareReport',
        'Net Salary Comparison'
    );
}

function comparedue_BindReport(methodName, tableSelector, reportTitle) {
    var request = {
        CurrentMonth: $('#comparedue_ddlCurrentMonth').val(),
        CurrentYear: $('#comparedue_ddlCurrentYear').val(),
        PreviousMonth: $('#comparedue_ddlPreviousMonth').val(),
        PreviousYear: $('#comparedue_ddlPreviousYear').val()
    };

    $('#reportLoader').show();
    $('#comparedue_btnCompare').addClass('loading');

    $.ajax({
        type: 'POST',
        url: 'CompareReportDueSalary.aspx/' + methodName,
        data: JSON.stringify(request),
        contentType: 'application/json; charset=utf-8',
        dataType: 'json',
        success: function (response) {
            var rows = JSON.parse(response.d || '[]');
            comparedue_RenderReport(tableSelector, rows, reportTitle);
        },
        error: function (xhr) {
            console.error('Unable to load ' + reportTitle, xhr.responseText);
            alert('Unable to load ' + reportTitle + '.');
        },
        complete: function () {
            $('#reportLoader').hide();
            $('#comparedue_btnCompare').removeClass('loading');
        }
    });
}

function comparedue_RenderReport(tableSelector, rows, reportTitle) {
    if ($.fn.DataTable.isDataTable(tableSelector)) {
        $(tableSelector).DataTable().clear().destroy();
    }

    $(tableSelector + ' thead').empty();
    $(tableSelector + ' tbody').empty();

    if (!rows.length) {
        $(tableSelector + ' thead').html('<tr><th>Result</th></tr>');
        $(tableSelector + ' tbody').html('<tr><td>No records found</td></tr>');
        return;
    }

    var keys = Object.keys(rows[0]);
    var columns = $.map(keys, function (key) {
        return {
            data: function (row) {
                return row[key] == null ? '' : row[key];
            },
            title: key,
            defaultContent: ''
        };
    });
    var hasButtons = $.fn.dataTable.Buttons !== undefined;

    $(tableSelector).DataTable({
        data: rows,
        columns: columns,
        dom: hasButtons ? 'Bfrtip' : 'lfrtip',
        buttons: hasButtons ? [{ extend: 'excelHtml5', title: reportTitle }] : [],
        scrollX: true,
        paging: true,
        searching: true,
        ordering: false,
        processing: true,
        autoWidth: false,
        createdRow: function (row, data) {
            var rowText = $.map(keys, function (key) {
                return data[key];
            }).join(' ').toLowerCase();

            if (rowText.indexOf('difference') !== -1) {
                $(row).addClass('difference-row');
            } else if (rowText.indexOf('new joinee') !== -1 || rowText.indexOf('drop out') !== -1) {
                $(row).addClass('movement-row');
            }
        }
    });
}

$(document).ready(function () {

    console.log('Compare Due');

    BindMonthDropdowns();
    BindYearDropdowns();

    //$('#comparedue_btnCompare').on('click', function () {
    //    comparedue_BindCompareDueReport();
    //});
    $('#comparedue_btnCompare').on('click', function () {
        comparedue_BindCompareDueReport();

        if ($('.tab-btn[data-target="net"]').hasClass('active')) {
            comparedue_BindCompareNetReport();
        }
    });
    $('#comparedue_btnExportExcel').on('click', function () {
        $('.buttons-excel').click();
    });

    $(document).on('click', '.tab-btn', function () {
        var target = $(this).data('target');

        $('.tab-btn').removeClass('active');
        $(this).addClass('active');

        $('.tab-content').removeClass('active');

        if (target === 'due') {
            $('#dueTab').addClass('active');

            setTimeout(function () {
                if ($.fn.DataTable.isDataTable('#comparedue_tblCompareReport')) {
                    $('#comparedue_tblCompareReport').DataTable().columns.adjust();
                }
            }, 100);
        }

        if (target === 'net') {
            $('#netTab').addClass('active');

            if (!$.fn.DataTable.isDataTable('#comparenet_tblCompareReport')) {
                comparedue_BindCompareNetReport();
            } else {
                setTimeout(function () {
                    $('#comparenet_tblCompareReport').DataTable().columns.adjust();
                }, 100);
            }
        }
    });
});
