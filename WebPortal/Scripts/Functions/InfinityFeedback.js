
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

            let result = response.d || {};
            let dataArray = [];

            /*
             * Depending on the .NET configuration, response.d might occasionally
             * be returned as a JSON string.
             */
            if (typeof result === "string") {
                try {
                    result = JSON.parse(result);
                }
                catch (error) {
                    console.error("Invalid JSON response:", error);

                    Swal.fire({
                        icon: "error",
                        title: "Invalid Response",
                        text: "The server returned an invalid response."
                    });

                    return;
                }
            }

            if (!result.Success) {
                Swal.fire({
                    icon: "error",
                    title: "Unable to Load Data",
                    text: result.Message ||
                        "An error occurred while loading feedback records."
                });

                return;
            }

            dataArray = Array.isArray(result.GridData)
                ? result.GridData
                : [];

            // Destroy existing DataTable
            if ($.fn.DataTable.isDataTable('#table_InfinityFeedback')) {
                $('#table_InfinityFeedback')
                    .DataTable()
                    .clear()
                    .destroy();
            }

            InfinityFeedback_table =
                $('#table_InfinityFeedback').DataTable({

                    data: dataArray,

                    dom: 'ftip',
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

                                const feedbackID =
                                    encodeURIComponent(row.FeedbackID);

                                const subDomainCode =
                                    encodeURIComponent(
                                        (subdomain || "").substring(0, 1)
                                    );

                                return `
                            <a class="dropdown-item"
                               target="_blank"
                               href="EditInfinityFeedback.aspx?FID=${feedbackID}&s=${subDomainCode}"
                               title="Edit Feedback">
                                <span style="color:dodgerblue;">
                                    <i class="uil uil-pen"
                                       style="font-size:16px;"></i>
                                </span>
                            </a>`;
                            }
                        },
                        {
                            data: "FeedbackID",
                            title: "FeedbackID",
                            visible: true,
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
                            title: "Sub Category",
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
                        { data: "ErrorType1Name", title: "Error Type 1", defaultContent: "" },
                        { data: "ErrorType2Name", title: "Error Type 2", defaultContent: "" },
                        { data: "ErrorType3Name", title: "Error Type 3", defaultContent: "" },
                        { data: "ErrorType4Name", title: "Error Type 4", defaultContent: "" },
                        { data: "ErrorType5Name", title: "Error Type 5", defaultContent: "" },
                        { data: "ErrorType6Name", title: "Error Type 6", defaultContent: "" },
                        { data: "ErrorType7Name", title: "Error Type 7", defaultContent: "" },
                        { data: "ErrorType8Name", title: "Error Type 8", defaultContent: "" },
                        { data: "ErrorType9Name", title: "Error Type 9", defaultContent: "" },
                        {
                            data: "ErrorType1Name",
                            title: "Error Type 1",
                            defaultContent: ""
                        },
                        {
                            data: "ErrorType2Name",
                            title: "Error Type 2",
                            defaultContent: ""
                        },
                        {
                            data: "ErrorType3Name",
                            title: "Error Type 3",
                            defaultContent: ""
                        },
                        {
                            data: "ErrorType4Name",
                            title: "Error Type 4",
                            defaultContent: ""
                        },
                        {
                            data: "ErrorType5Name",
                            title: "Error Type 5",
                            defaultContent: ""
                        },
                        {
                            data: "ErrorType6Name",
                            title: "Error Type 6",
                            defaultContent: ""
                        },
                        {
                            data: "ErrorType7Name",
                            title: "Error Type 7",
                            defaultContent: ""
                        },
                        {
                            data: "ErrorType8Name",
                            title: "Error Type 8",
                            defaultContent: ""
                        },
                        {
                            data: "ErrorType9Name",
                            title: "Error Type 9",
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
                            defaultContent: "",
                            createdCell: function (cell, value) {
                                var status = (value || "").toString().trim().toLowerCase();
                                if (status === "rebuttal") {
                                    $(cell).addClass("rebuttal-status");
                                }
                                else if (status === "agree") {
                                    $(cell).addClass("agree-status");
                                }
                            }
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

                    createdRow: function (row, data) {

                        const rebuttalStatus =
                            (data.RebuttalStatus || "")
                                .toString()
                                .trim()
                                .toLowerCase();

                        if (rebuttalStatus === "rebuttal") {
                            $(row).addClass("row-rebuttal");
                        }
                        else if (rebuttalStatus === "agree") {
                            $(row).addClass("row-rebuttal");
                        }
                    },

                    buttons: [
                        {
                            extend: 'excelHtml5',
                            title: 'Feedback Details',
                            filename: 'Feedback_Details',
                            autoFilter: true,
                            exportOptions: {
                                columns: ':visible:not(:first-child)'
                            }
                        }
                    ],

                    language: {
                        emptyTable: result.HasExportData
                            ? "No records are available for grid display. Use the Excel export option to view all records."
                            : "No feedback records found.",
                        processing: "Loading feedback records..."
                    },

                    initComplete: function () {
                        $('#load1').hide();
                    }
                });

            /*
             * Case 1:
             * dt_Export contains data, but dt1/grid data is empty.
             */
            if (result.HasExportData && !result.HasGridData) {

                Swal.fire({
                    icon: "info",
                    title: "No Records for Grid Display",
                    html:
                        `<p>${result.Message}</p>` +
                        `<p><strong>Excel records available:</strong> ` +
                        `${result.ExportRecordCount}</p>`,
                    confirmButtonText: "OK"
                });
            }

            /*
             * Case 2:
             * No data is available in either the grid or Excel export.
             */
            else if (!result.HasExportData) {

                Swal.fire({
                    icon: "info",
                    title: "No Data Available",
                    text: result.Message ||
                        "No feedback records are available for the selected criteria.",
                    confirmButtonText: "OK"
                });
            }

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



