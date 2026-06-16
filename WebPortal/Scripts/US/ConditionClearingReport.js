var ConditionClearing_html;
var ConditionClearing_table;

function btnConditionShowReport() {

    var FromDate = $('#Condition_FromDate').val();// document.getElementById("Condition_FromDate").value;
    var ToDate = $('#Condition_ToDate').val();//  document.getElementById("Condition_ToDate").value;

    if (FromDate == "" || FromDate == 'undefined') {
        alert("please enter From Date.");
        return false;
    }
    if (ToDate == "" || ToDate == 'undefined') {
        alert("please enter To Date.");
        return false;
    }

    if ((FromDate != "" || FromDate != null) && (ToDate != "" || ToDate != null)) {
        BindInfinityFeedbackGridOnshore(FromDate, ToDate);
    }
}

function BindInfinityFeedbackGridOnshore(FromDate, ToDate) {

    $('#load1').show();

    ConditionClearing_html = '';
    $.ajax({
        url: "ConditionClearingReport.aspx/GetAllConditionClearing",
        type: "POST",
        dataType: "json",
        data: "{FromDate:'" + FromDate + "',ToDate:'" + ToDate + "'}",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);
            $.each(dataArray, function (index, value) {

                var approveddate = '';

                ConditionClearing_html += '<tr>';

                ConditionClearing_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.DealNo) + '</td>';
                ConditionClearing_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.LoanNo) + '</td>';
                ConditionClearing_html += '<td style="white-space: normal; word-break: break-word;">' + blankForNull(value.InfinityCondition) + '</td>';
                ConditionClearing_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ClientsRebuttal) + '</td>';
                ConditionClearing_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ReceivedDate) + '</td>';
                ConditionClearing_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ReviewDate) + '</td>';
                ConditionClearing_html += '<td style="white-space: normal; word-break: break-word;">' + blankForNull(value.InfinityResponse) + '</td>';
                ConditionClearing_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Cleared) + '</td>';
                ConditionClearing_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.InitialExceptionGrade) + '</td>';
                ConditionClearing_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.FinalExceptionGrade) + '</td>';
                ConditionClearing_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.TotalTime) + '</td>';
                ConditionClearing_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.AddedName) + '</td>';
                ConditionClearing_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.AddedDate) + '</td>';
                ConditionClearing_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.UpdateByName) + '</td>';
                ConditionClearing_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.UpdateDate) + '</td>';
            });

            if ($.fn.dataTable.isDataTable('#table_InfinityCondition')) {
                table_InfinityCondition.destroy();
            }
            $('#table_InfinityCondition tbody').html(ConditionClearing_html);
            //else
            table_InfinityCondition = $('#table_InfinityCondition').DataTable({
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
                        extend: 'excelHtml5', title: 'Condition Details', autoFilter: true
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