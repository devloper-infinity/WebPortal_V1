var loanHistoryTable = null;

$(document).ready(function () {

    LoadProjects();

    $('#btnSearch').click(function () {

        LoadLoanTrackingHistory();

    });

    $('#btnReset').click(function () {

        ResetFilters();

    });

    $('#btnExport').click(function () {

        ExportGrid();

    });

});

function ShowLoader() {

    $("#load1").show();

}

function HideLoader() {

    $("#load1").hide();

}

function ResetFilters() {

    $("#ddlProject").val('');

    $("#txtFromDate").val('');

    $("#txtToDate").val('');

    if ($.fn.DataTable.isDataTable('#tblLoanTrackingHistory')) {
        $('#tblLoanTrackingHistory').DataTable().destroy();
        $('#tblLoanTrackingHistory').empty();
        loanHistoryTable = null;
    }

}

function LoadProjects() {

    $.ajax({

        type: "POST",

        url: "LoanLevelHistory.aspx/GetProjects",

        data: "{}",

        contentType: "application/json; charset=utf-8",

        dataType: "json",

        success: function (response) {

            var data = JSON.parse(response.d);

            $("#ddlProject").empty();

            $("#ddlProject").append('<option value="">Select Project</option>');
            $("#ddlProject").append('<option value="0">All</option>');

            $.each(data, function (i, item) {

                $("#ddlProject").append(

                    '<option value="' +
                    item.ProjectID +
                    '">' +
                    item.ProjectName +
                    '</option>'

                );

            });

        },

        error: function () {

            Swal.fire(
                'Error',
                'Unable to load projects.',
                'error'
            );

        }

    });

}

function LoadLoanTrackingHistory() {

    if (!$("#txtFromDate").val() || !$("#txtToDate").val()) {
        Swal.fire('Info', 'Please select both From Date and To Date.', 'info');
        return;
    }

    ShowLoader();

    requestLoanHistoryPage(1, 0, 10, '', function (result) {
        HideLoader();
        if (result.error) {
            Swal.fire('Error', result.error, 'error');
            return;
        }
        BindGrid(result);
    }, showLoadError);

}

function BindGrid(result) {

    if (!result || !result.columns || result.columns.length === 0) {

        $('#tblLoanTrackingHistory').html(
            '<thead><tr><th>No records found</th></tr></thead>'
        );

        return;
    }

    if ($.fn.DataTable.isDataTable('#tblLoanTrackingHistory')) {
        $('#tblLoanTrackingHistory').DataTable().destroy();
    }

    $('#tblLoanTrackingHistory').empty();

    var columns = [];

    $.each(result.columns, function (i, col) {

        columns.push({
            data: col,
            title: col
        });

    });

    loanHistoryTable = $('#tblLoanTrackingHistory').DataTable({
        data: result.data,
        columns: columns,
        destroy: true,
        processing: true,
        serverSide: true,
        deferLoading: result.recordsTotal,
        pageLength: 10,
        ajax: function (request, callback) {
            requestLoanHistoryPage(
                request.draw,
                request.start,
                request.length,
                request.search ? request.search.value : '',
                callback,
                function () {
                    callback({ draw: request.draw, recordsTotal: 0, recordsFiltered: 0, data: [] });
                    showLoadError();
                });
        },
        dom: 'frtip',
        language: {
            emptyTable: 'No records found.'
        }
    });
}

function requestLoanHistoryPage(draw, start, length, searchValue, onSuccess, onError) {
    $.ajax({
        type: "POST",
        url: "LoanLevelHistory.aspx/GetLoanTrackingHistory",
        data: JSON.stringify({
            ProjectID: $("#ddlProject").val() || '0',
            FromDate: $("#txtFromDate").val(),
            ToDate: $("#txtToDate").val(),
            draw: draw,
            start: start,
            length: length,
            searchValue: searchValue || ''
        }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) { onSuccess(response.d); },
        error: onError
    });
}

function showLoadError() {
    HideLoader();
    Swal.fire('Error', 'Unable to load data.', 'error');
}

function ExportGrid() {
    if (!$("#txtFromDate").val() || !$("#txtToDate").val()) {
        Swal.fire('Info', 'Please select both From Date and To Date.', 'info');
        return;
    }
    var search = loanHistoryTable ? loanHistoryTable.search() : '';
    window.location = '../Handler/LoanLevelHistoryExport.ashx?ProjectID=' +
        encodeURIComponent($("#ddlProject").val() || '0') + '&FromDate=' +
        encodeURIComponent($("#txtFromDate").val()) + '&ToDate=' +
        encodeURIComponent($("#txtToDate").val()) + '&SearchValue=' +
        encodeURIComponent(search);
}
