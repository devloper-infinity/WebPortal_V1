
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

function Core_BindInfinityFeedbackGrid(FromDate, ToDate, subdomain) {

    $('#load1').show();

    InfinityFeedback_html = '';
    $.ajax({
        url: "InfinityFeedback.aspx/GetAllFeedbackByDateRange_NewFormat",
        type: "POST",
        dataType: "json",
        data: "{FromDate:'" + FromDate + "',ToDate:'" + ToDate + "', SubDomain : '" + subdomain + "'}",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);
            $.each(dataArray, function (index, value) {

                var approveddate = '';
                InfinityFeedback_html += '<tr>';
                InfinityFeedback_html += '<td style="text-align:center;"><a class="dropdown-item" target="_blank" href="EditInfinityFeedback.aspx?FID=' + value.FeedbackID + '&s=' + subdomain.substring(0, 1) + '" title="Edit Feedback"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-pen" style="font-size:16px;"></i></span></a></td>';
                InfinityFeedback_html += '<td style="text-wrap: nowrap; display:none;">' + blankForNull(value.FeedbackID) + '</td>';
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
                InfinityFeedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.OnshoreRebuttalResponse) + '</td>';
                InfinityFeedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.OnshoreRebuttalComments) + '</td>';
                InfinityFeedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ManagerFinalStatus) + '</td>';
                InfinityFeedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ManagerFinalComments) + '</td>';
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
                dom: 'ftip',
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

function BindInfinityFeedbackGrid(FromDate, ToDate, subdomain) {

    $('#load1').show();

    $.ajax({
        type: "POST",
        url: "InfinityFeedback.aspx/GetAllFeedbackByDateRange_NewFormat",
        data: JSON.stringify({
            FromDate: FromDate,
            ToDate: ToDate,
            SubDomain: subdomain
        }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        success: function (response) {

            let dataArray = [];

            try {
                dataArray = typeof response.d === "string"
                    ? JSON.parse(response.d || "[]")
                    : (response.d || []);
            }
            catch (error) {
                console.error("Invalid JSON response:", error);
                dataArray = [];
            }

            // Destroy existing DataTable
            if ($.fn.DataTable.isDataTable('#table_InfinityFeedback')) {
                $('#table_InfinityFeedback').DataTable().clear().destroy();
            }

            InfinityFeedback_table = $('#table_InfinityFeedback').DataTable({

                data: dataArray,

                dom: 'Bftip',
                destroy: true,
                processing: true,
                paging: true,
                searching: true,
                ordering: false,
                autoWidth: false,
                scrollX: true,
                scrollCollapse: true,

                select: {
                    style: 'single'
                },

                columns: [
                    {
                        data: null,
                        title: "Actions",
                        orderable: false,
                        searchable: false,
                        className: "text-center",
                        width: "60px",

                        render: function (data, type, row) {

                            if (!row.FeedbackID) {
                                return "";
                            }

                            const feedbackID = encodeURIComponent(row.FeedbackID);
                            const subDomainCode = encodeURIComponent((subdomain || "").substring(0, 1));

                            return `<a class="dropdown-item" target="_blank" href="EditInfinityFeedback.aspx?FID=${feedbackID}&s=${subDomainCode}"
                                   title="Edit Feedback"><span style="color:dodgerblue;"><i class="uil uil-pen"style="font-size:16px;"></i></span></a>`;
                        }
                    },

                    {
                        data: "FeedbackID",
                        title: "FeedbackID",
                        visible: false,
                        defaultContent: ""
                    },

                    {
                        data: "LoanNumber",
                        title: "Loan Number",
                        defaultContent: ""
                    },
                    {
                        data: "Client",
                        title: "Client",
                        defaultContent: ""
                    },
                    {
                        data: "UWName",
                        title: "UW Name",
                        defaultContent: ""
                    },
                    {
                        data: "QCName",
                        title: "QC Name",
                        defaultContent: ""
                    },
                    {
                        data: "DateReviewed",
                        title: "Date Reviewed",
                        defaultContent: ""
                    },
                    {
                        data: "QCDate",
                        title: "QC Date",
                        defaultContent: ""
                    },
                    {
                        data: "Category",
                        title: "Category",
                        defaultContent: ""
                    },
                    {
                        data: "Subcategory",
                        title: "Sub category",
                        defaultContent: ""
                    },
                    {
                        data: "ErrorField",
                        title: "Error Field",
                        defaultContent: ""
                    },
                    {
                        data: "Screen",
                        title: "Screen",
                        defaultContent: ""
                    },
                    {
                        data: "ErrorType",
                        title: "Error Type",
                        defaultContent: ""
                    },
                    {
                        data: "Finding",
                        title: "Finding",
                        defaultContent: ""
                    },
                    {
                        data: "FeedbackType",
                        title: "Feedback Type",
                        defaultContent: ""
                    },
                    {
                        data: "Severity",
                        title: "Severity",
                        defaultContent: ""
                    },

                    // This column was missing in your old row generation
                    {
                        data: "FeedbackStatus",
                        title: "Feedback Status",
                        defaultContent: ""
                    },

                    {
                        data: "RCA",
                        title: "RCA/Rebuttal Comments",
                        defaultContent: ""
                    },
                    {
                        data: "RebuttalStatus",
                        title: "Onshore Rebuttal Response",
                        defaultContent: ""
                    },
                    {
                        data: "RebuttalRemark",
                        title: "Onshore Rebuttal Comments",
                        defaultContent: ""
                    },
                    {
                        data: "FinalStatus",
                        title: "Manager Final Status",
                        defaultContent: ""
                    },
                    {
                        data: "FinalComments",
                        title: "Manager Final Comments",
                        defaultContent: ""
                    },
                    {
                        data: "Source",
                        title: "Source",
                        defaultContent: ""
                    },
                    {
                        data: "FeedbackReceivedDate",
                        title: "Feedback Received Date",
                        defaultContent: ""
                    }
                ],

                columnDefs: [
                    {
                        targets: '_all',
                        className: 'text-nowrap'
                    }
                ],
                createdRow: function (row, data, dataIndex) {

                    if ((data.OnshoreRebuttalResponse || "").toString().trim().toLowerCase() === "") {
                        $(row).addClass("row-rebuttal");
                    }

                },

                buttons: [
                    {
                        extend: 'excelHtml5',
                        title: 'Feedback Details',
                        filename: 'Feedback_Details',
                        autoFilter: true,

                        // Exclude Actions and hidden FeedbackID
                        exportOptions: {
                            columns: ':visible:not(:first-child)'
                        }
                    }
                ],

                language: {
                    emptyTable: "No feedback records found.",
                    processing: "Loading feedback records..."
                },

                initComplete: function () {
                    $('#load1').hide();
                }
            });

            $('#load1').hide();
        },

        error: function (xhr, status, error) {
            console.error("AJAX Error:", error);
            console.error("Response:", xhr.responseText);

            Swal.fire({
                icon: "error",
                title: "Unable to Load Data",
                text: "An error occurred while loading feedback records."
            });
        },

        complete: function () {
            $('#load1').hide();
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

        success: function (data) {
            dataArray = JSON.parse(data.d);

            $.each(dataArray, function (data, value) {

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



