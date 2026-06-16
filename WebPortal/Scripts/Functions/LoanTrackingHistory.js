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

        $('#tblLoanTrackingHistory')
            .DataTable()
            .clear()
            .draw();

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

            $("#ddlProject").append(
                '<option value="">Select Project</option>'
            );

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

    ShowLoader();

    var obj = {

        ProjectID: $("#ddlProject").val(),

        FromDate: $("#txtFromDate").val(),

        ToDate: $("#txtToDate").val()

    };

    $.ajax({

        type: "POST",

        url: "LoanLevelHistory.aspx/GetLoanTrackingHistory",

        data: JSON.stringify(obj),

        contentType: "application/json; charset=utf-8",

        dataType: "json",

        success: function (response) {

            HideLoader();

            //var result = response.d;
            var result = JSON.parse(response.d);
            BindGrid(result);

        },

        error: function () {

            HideLoader();

            Swal.fire(
                'Error',
                'Unable to load data.',
                'error'
            );

        }

    });

}

function BindGrid(result) {

    if (!result || result.length === 0) {

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

    $.each(Object.keys(result[0]), function (i, col) {

        columns.push({
            data: col,
            title: col
        });

    });

    $('#tblLoanTrackingHistory').DataTable({
        data: result,
        columns: columns,
        destroy: true,
        dom: 'Bfrtip',
        buttons: [{
            extend: 'excelHtml5',
            title: 'Loan Tracking History',
            text: '<i class="fas fa-file-excel"></i> Excel'
        }],
        language: {
            emptyTable: 'No records found.'
        }
    });
}

function ExportGrid() {

    if (loanHistoryTable == null) {

        Swal.fire(
            'Info',
            'No data available to export.',
            'info'
        );

        return;

    }

    loanHistoryTable
        .button('.buttons-excel')
        .trigger();

}