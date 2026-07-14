
var InfinityFeedback_html;
var InfinityFeedback_table;

function btnEditFeedbackShowReport() {

    var FromDate = document.getElementById("infFeedback_FromDate").value;
    var ToDate = document.getElementById("infFeedback_ToDate").value;

    var ddldomain = document.getElementById("inffeedback_domain");
    var subdomain = ddldomain.options[ddldomain.selectedIndex].value;

    if (FromDate == "") {
        alert("please enter From Date.");
        return false;
    }
    if (ToDate == "") {
        alert("please enter To Date.");
        return false;
    }

    if ((FromDate != "" || FromDate != null) && (ToDate != "" || ToDate != null)) {

        BindInfinityFeedbackGrid(FromDate, ToDate, subdomain);
    }
}

function BindInfinityFeedbackGrid(FromDate, ToDate, subdomain) {

    $('#load1').show();

    InfinityFeedback_html = '';
    $.ajax({
        url: "InfinityFeedback.aspx/GetAllFeedbackByDateRange_NewFormat",
        type: "POST",
        dataType: "json",
        data: "{FromDate:'" + FromDate + "',ToDate:'" + ToDate + "', SubDomain : '" + subdomain + "'}",
        contentType: "application/json; charset=utf-8",

        success: function(data) {
            var dataArray = JSON.parse(data.d);
            $.each(dataArray, function(index, value) {

                var approveddate = '';
                /*   if (value.FeedbackReceivedDate != null && value.FeedbackReceivedDate != '') {
                       FeedbackReceivedDate = eval(value.FeedbackReceivedDate.replace(/\/Date\((\d+)\)\//gi, "new Date($1).toLocaleDateString(\"en-US\")"));
                   }*/
                InfinityFeedback_html += '<tr>';
                InfinityFeedback_html += '<td style="text-align:center;"><a class="dropdown-item" target="_blank" href="EditInfinityFeedback.aspx?FID=' + value.FeedbackID + '&s=' + subdomain.substring(0, 1) + '" title="Edit Feedback"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-pen" style="font-size:16px;"></i></span></a></td>';
                InfinityFeedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.FeedbackID) + '</td>';
                InfinityFeedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.LoanNumber) + '</td>';
                InfinityFeedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Client) + '</td>';
                InfinityFeedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.UWName) + '</td>';
                InfinityFeedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.QCName) + '</td>';
                InfinityFeedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.DateReviewed) + '</td>';
                InfinityFeedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.QCDate) + '</td>';
                InfinityFeedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Category) + '</td>';
                InfinityFeedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Subcategory) + '</td>';
                InfinityFeedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ErrorField) + '</td>';
                InfinityFeedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Screen) + '</td>';
                InfinityFeedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ErrorType) + '</td>';
                InfinityFeedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Finding) + '</td>';
                InfinityFeedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.FeedbackType) + '</td>';
                InfinityFeedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Severity) + '</td>';
                InfinityFeedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.RCA) + '</td>';
                InfinityFeedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Comments) + '</td>';
                InfinityFeedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Source) + '</td>';
                InfinityFeedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.FeedbackReceivedDate) + '</td>';
                InfinityFeedback_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#table_InfinityFeedback')) {
                InfinityFeedback_table.destroy();
            }
            $('#table_InfinityFeedback tbody').html(InfinityFeedback_html);
            //else
            InfinityFeedback_table = $('#table_InfinityFeedback').DataTable({
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
                initComplete: function() {

                    $('#load1').hide();
                },
            });
        },

        error: function(error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}

function infinityfeecback_bindsubdomain() {
    $.ajax({
        url: "ImportFeedback.aspx/GetUserInfo",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function(data) {
            dataArray = JSON.parse(data.d);

            $.each(dataArray, function(data, value) {

                if (blankForNull(value.SubDomain) == "Credit" || blankForNull(value.SubDomain) == "Servicing") {
                    $("#inffeedback_domain").val(blankForNull(value.SubDomain));
                    document.getElementById("tddomainhead").style.display = "none";
                    // document.getElementById("tddomainrow").style.display = "none";
                }
                else {
                    $("#inffeedback_domain").val("");
                    document.getElementById("tddomainhead").style.display = "";
                    // document.getElementById("tddomainrow").style.display = "";
                }
            })
        }
    });
}



