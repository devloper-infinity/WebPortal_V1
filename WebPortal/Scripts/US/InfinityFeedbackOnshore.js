var InfinityFeedbackOnshore_html;
var InfinityFeedbackOnshore_table;

function core_btnEditFeedbackShowReportOnShore() {

    var FromDateOnShore = document.getElementById("infFeedback_FromDateOnShore").value;
    var ToDateOnShore = document.getElementById("infFeedback_ToDateOnShore").value;

    if (FromDateOnShore == "") {
        alert("please enter From Date.");
        return false;
    }
    if (ToDateOnShore == "") {
        alert("please enter To Date.");
        return false;
    }

    if ((FromDateOnShore != "" || FromDateOnShore != null) && (ToDateOnShore != "" || ToDateOnShore != null)) {


        BindInfinityFeedbackGridOnshore(FromDateOnShore, ToDateOnShore);
    }
}

function core_BindInfinityFeedbackGridOnshore(FromDate, ToDate) {

    $('#load1').show();

    InfinityFeedbackOnshore_html = '';
    $.ajax({
        url: "InfinityFeedbackOnshore.aspx/GetAllFeedbackByDateRange_NewFormatOnshore",
        type: "POST",
        dataType: "json",
        data: "{FromDate:'" + FromDate + "',ToDate:'" + ToDate + "'}",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);
            $.each(dataArray, function (index, value) {

                var approveddate = '';

                InfinityFeedbackOnshore_html += '<tr>';
                //InfinityFeedbackOnshore_html += '<td style="text-align:center;"><a class="dropdown-item" target="_blank" href="EditInfinityFeedback.aspx?FID=' + value.FeedbackID + '&s=' + subdomain.substring(0, 1) + '" title="Edit Feedback"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-pen" style="font-size:16px;"></i></span></a></td>';
                //InfinityFeedbackOnshore_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.FeedbackID) + '</td>';
                InfinityFeedbackOnshore_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.LoanNumber) + '</td>';
                InfinityFeedbackOnshore_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Client) + '</td>';
                InfinityFeedbackOnshore_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.UWName) + '</td>';
                InfinityFeedbackOnshore_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.QCName) + '</td>';
                InfinityFeedbackOnshore_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.DateReviewed) + '</td>';
                InfinityFeedbackOnshore_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.QCDate) + '</td>';
                InfinityFeedbackOnshore_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Category) + '</td>';
                InfinityFeedbackOnshore_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Subcategory) + '</td>';
                InfinityFeedbackOnshore_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ErrorField) + '</td>';
                InfinityFeedbackOnshore_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Screen) + '</td>';
                InfinityFeedbackOnshore_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ErrorType) + '</td>';
                InfinityFeedbackOnshore_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Finding) + '</td>';
                InfinityFeedbackOnshore_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.FeedbackType) + '</td>';
                InfinityFeedbackOnshore_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Severity) + '</td>';
                InfinityFeedbackOnshore_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.RCA) + '</td>';
                InfinityFeedbackOnshore_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Comments) + '</td>';
                InfinityFeedbackOnshore_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Source) + '</td>';
                InfinityFeedbackOnshore_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.FeedbackReceivedDate) + '</td>';
                InfinityFeedbackOnshore_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#table_InfinityFeedbackOnShore')) {
                table_InfinityFeedbackOnShore.destroy();
            }
            $('#table_InfinityFeedbackOnShore tbody').html(InfinityFeedbackOnshore_html);
            //else
            InfinityFeedbackOnshore_table = $('#table_InfinityFeedbackOnShore').DataTable({
                dom: 'Bftip',
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
                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Feedback Details', autoFilter: true
                    },
                ],
                initComplete: function () {

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


function showdata1() {

    var fromDate = $('#infFeedback_FromDateOnShore').val();
    var toDate = $('#infFeedback_ToDateOnShore').val();

    if (!fromDate) {
        alert("Please enter From Date.");
        return;
    }

    if (!toDate) {
        alert("Please enter To Date.");
        return;
    }



    bind_onshoredata(fromDate, toDate);
    return false;
}

function bind_onshoredata(date1, date2) {

    // $('#load1').show();
    $('#feedbackLoader').show();

    $.ajax({
        url: "InfinityFeedbackOnshore.aspx/GetAllFeedbackByDateRange_NewFormatOnshore",
        type: "POST",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: "{FromDate:'" + date1 + "',ToDate:'" + date2 + "'}",


        success: function (data) {

            var dataArray = JSON.parse(data.d);

            // Destroy old DataTable
            if ($.fn.DataTable.isDataTable('#table_InfinityFeedbackOnShore')) {
                $('#table_InfinityFeedbackOnShore').DataTable().clear().destroy();
            }

            $('#table_InfinityFeedbackOnShore').DataTable({
                dom: 'Bfrtip',
                data: dataArray,
                scrollX: true,
                paging: true,
                processing: true,
                ordering: false,
                serverSide: false,

                columns: [
                    {
                        data: null, title: 'Sr. #',
                        render: function (data, type, row, meta) {
                            return meta.row + 1;
                        }
                    },
                    { data: 'LoanNumber', title: 'Loan Number' },
                    { data: 'Client', title: 'Client' },
                    { data: 'UWName', title: 'UW Name' },
                    { data: 'QCName', title: 'QC Name' },
                    { data: 'DateReviewed', title: 'Date Reviewed' },
                    { data: 'QCDate', title: 'QC Date' },
                    { data: 'Category', title: 'Category' },
                    { data: 'Subcategory', title: 'Subcategory' },
                    { data: 'ErrorField', title: 'Error Field' },
                    { data: 'Screen', title: 'Screen' },
                    { data: 'ErrorType', title: 'Error Type' },
                    { data: 'Finding', title: 'Finding' },
                    { data: 'FeedbackType', title: 'Feedback Type' },
                    { data: 'Severity', title: 'Severity' },
                    { data: 'RCA', title: 'RCA' },
                    { data: 'Comments', title: 'Comments' },
                    { data: 'Source', title: 'Source' },
                    { data: 'FeedbackReceivedDate', title: 'Feedback Received Date' }
                ],

                buttons: [
                    {
                        extend: 'excelHtml5',
                        title: 'Feedback Details - OnShore'
                    }
                ],

                initComplete: function () {
                    // $('#load1').hide();
                    $('#feedbackLoader').hide();
                }
            });

        },

        error: function (error) {
            $('#load1').hide();
            alert('Error: ' + error.responseText);
        }

    });
}