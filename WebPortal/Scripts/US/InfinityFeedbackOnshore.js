var InfinityFeedbackOnshore_html;
var InfinityFeedbackOnshore_table;
var InfinityFeedbackOnshore_selectedRow = null;


function encodeInfinityOnshoreHtml(value) {
    return $('<div/>').text(blankForNull(value)).html();
}

function renderInfinityOnshoreActionLink(row) {
    var feedbackId = parseInt(row.FeedbackID || row.FeedbackId || row.ID || 0, 10) || 0;

    if (!feedbackId) {
        return '';
    }

    return '<a href="#" class="feedback-action-link" title="Add remark" onclick="return showInfinityOnshoreRemarkPopup(' + feedbackId + ');"><i class="fas fa-comment-dots"></i></a>';
}

function showInfinityOnshoreRemarkPopup(feedbackId) {
    var table = $('#table_InfinityFeedbackOnShore').DataTable();
    var matchedRow = null;

    table.rows().every(function () {
        var row = this.data();
        var rowFeedbackId = parseInt(row.FeedbackID || row.FeedbackId || row.ID || 0, 10) || 0;
        if (rowFeedbackId === parseInt(feedbackId, 10)) {
            matchedRow = row;
            return false;
        }
    });

    if (!matchedRow) {
        alert('Feedback details are not available for this row.');
        return false;
    }

    InfinityFeedbackOnshore_selectedRow = matchedRow;
    $('#hdnInfinityOnshoreFeedbackId').val(feedbackId);
    $('#spnInfinityOnshoreLoanNumber').text(blankForNull(matchedRow.LoanNumber) || '-');
    $('#spnInfinityOnshoreClient').text(blankForNull(matchedRow.Client) || '-');
    $('#spnInfinityOnshoreRCA').text(blankForNull(matchedRow.RCA) || '-');
    $('#spnInfinityOnshoreComments').text(blankForNull(matchedRow.Comments) || '-');
    $('#txtInfinityOnshoreRemark').val(blankForNull(matchedRow.OnshoreRemark || matchedRow.Remark || ''));
    $('#popUp_InfinityOnshoreRemark').modal('show');

    return false;
}

function core_saveInfinityOnshoreRemark() {
    var feedbackId = parseInt($('#hdnInfinityOnshoreFeedbackId').val(), 10) || 0;
    var client = $('#spnInfinityOnshoreClient').text();
    var remark = $.trim($('#txtInfinityOnshoreRemark').val());
    var findingStatus = $("#ddlInfinityOnshore_RebuttalStatus").val();

    if (!feedbackId) {
        alert('Please select feedback row.');
        return false;
    }

    if (findingStatus === '') {
        alert('Please select Finding status.');
        $('#ddlInfinityOnshore_RebuttalStatus').focus();
        return false;
    }
    if (remark === '') {
        alert('Please enter remark.');
        $('#txtInfinityOnshoreRemark').focus();
        return false;
    }

    $('#btnSaveInfinityOnshoreRemark').prop('disabled', true).html('<i class="fas fa-spinner fa-spin mr-1"></i>Saving...');

    $.ajax({
        url: 'InfinityFeedbackOnshore.aspx/SaveInfinityOnshoreRemark',
        type: 'POST',
        dataType: 'json',
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify({ FeedbackID: feedbackId, Client: client, Remark: remark, RebuttalStatus:findingStatus }),
        success: function (response) {
            var message = response.d || '';

            if (message.indexOf('Error') === 0) {
                alert(message);
                return;
            }

            if (InfinityFeedbackOnshore_selectedRow) {
                InfinityFeedbackOnshore_selectedRow.OnshoreRemark = remark;
                InfinityFeedbackOnshore_selectedRow.Remark = remark;
            }

            $('#popUp_InfinityOnshoreRemark').modal('hide');
            alert(message || 'Remark saved successfully.');
            showdata1();
        },
        error: function (error) {
            alert('Error: ' + error.responseText);
        },
        complete: function () {
            $('#btnSaveInfinityOnshoreRemark').prop('disabled', false).html('<i class="fas fa-save mr-1"></i>Save Remark');
        }
    });

    return false;
}


function saveInfinityOnshoreRemark() {

    var feedbackId = parseInt($('#hdnInfinityOnshoreFeedbackId').val(), 10) || 0;
    var client = $('#spnInfinityOnshoreClient').text();
    var remark = $.trim($('#txtInfinityOnshoreRemark').val());
    var findingStatus = $("#ddlInfinityOnshore_RebuttalStatus").val();

    if (!feedbackId) {
        Swal.fire({
            icon: 'warning',
            title: 'Validation',
            text: 'Please select a feedback row.'
        });
        return false;
    }

    if (findingStatus === '') {
        Swal.fire({
            icon: 'warning',
            title: 'Validation',
            text: 'Please select the finding status.'
        }).then(() => {
            $('#ddlInfinityOnshore_RebuttalStatus').focus();
        });
        return false;
    }

    if (remark === '') {
        Swal.fire({
            icon: 'warning',
            title: 'Validation',
            text: 'Please enter a remark.'
        }).then(() => {
            $('#txtInfinityOnshoreRemark').focus();
        });
        return false;
    }

    $('#btnSaveInfinityOnshoreRemark')
        .prop('disabled', true)
        .html('<i class="fas fa-spinner fa-spin me-1"></i> Saving...');

    $.ajax({
        url: 'InfinityFeedbackOnshore.aspx/SaveInfinityOnshoreRemark',
        type: 'POST',
        dataType: 'json',
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify({
            FeedbackID: feedbackId,
            Client: client,
            Remark: remark,
            RebuttalStatus: findingStatus
        }),

        success: function (response) {

            var message = response.d || "Remark saved successfully.";

            if (message.indexOf("Error") === 0) {
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: message
                });
                return;
            }

            if (InfinityFeedbackOnshore_selectedRow) {
                InfinityFeedbackOnshore_selectedRow.OnshoreRemark = remark;
                InfinityFeedbackOnshore_selectedRow.Remark = remark;
            }

            $('#popUp_InfinityOnshoreRemark').modal('hide');
            Swal.fire({
                icon: 'success',
                title: 'Success',
                text: message,
                confirmButtonText: 'OK',
                allowOutsideClick: false,
                allowEscapeKey: false
            }).then((result) => {
                if (result.isConfirmed) {
                    showdata1();
                }
            });
        },

        error: function (xhr) {
            Swal.fire({
                icon: 'error',
                title: 'Request Failed',
                text: xhr.responseText || 'Something went wrong. Please try again.'
            });
        },

        complete: function () {
            $('#btnSaveInfinityOnshoreRemark')
                .prop('disabled', false)
                .html('<i class="fas fa-save me-1"></i> Save Remark');
        }
    });

    return false;
}





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
                InfinityFeedbackOnshore_html += '<td style="text-align:center; text-wrap: nowrap;">' + renderInfinityOnshoreActionLink(value) + '</td>';
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
    bindATRReviewFeedback(fromDate, toDate);
    bindCollectionCommentsFeedback(fromDate, toDate);
    return false;
}

function hideCollectionCommentsTab() { $('#collectionCommentsTabItem').hide(); if ($('#collectionCommentsTab').hasClass('active')) $('#standardFeedbackTab').tab('show'); }
function showCollectionCommentsRemarkPopup(feedbackId) {
    var table = $('#table_CollectionCommentsFeedback').DataTable(), matched = null;
    table.rows().every(function () { var row = this.data(); if ((parseInt(row.FeedbackID, 10) || 0) === feedbackId) { matched = row; return false; } });
    if (!matched) return false;
    InfinityFeedbackOnshore_selectedRow = matched; $('#hdnInfinityOnshoreFeedbackId').val(feedbackId); $('#spnInfinityOnshoreLoanNumber').text(blankForNull(matched.LoanNumber) || '-'); $('#spnInfinityOnshoreClient').text(blankForNull(matched.Client) || '-'); $('#spnInfinityOnshoreRCA').text(blankForNull(matched.RCA) || '-'); $('#spnInfinityOnshoreComments').text(blankForNull(matched.Comments) || '-'); $('#txtInfinityOnshoreRemark').val(blankForNull(matched.OnshoreRemark)); $('#popUp_InfinityOnshoreRemark').modal('show'); return false;
}
function bindCollectionCommentsFeedback(fromDate, toDate) {
    $('#collectionCommentsLoader').show();
    $.ajax({ url: 'InfinityFeedbackOnshore.aspx/GetCollectionCommentsFeedbackByDateRange', type: 'POST', contentType: 'application/json; charset=utf-8', dataType: 'json', data: JSON.stringify({ FromDate: fromDate, ToDate: toDate }), success: function (response) {
        var rows = JSON.parse(response.d || '[]'); if ($.fn.DataTable.isDataTable('#table_CollectionCommentsFeedback')) $('#table_CollectionCommentsFeedback').DataTable().clear().destroy();
        if (!rows.length) { $('#table_CollectionCommentsFeedback').empty(); hideCollectionCommentsTab(); return; }
        $('#collectionCommentsTabItem').show(); $('#table_CollectionCommentsFeedback').DataTable({ dom: 'Bfrtip', data: rows, destroy: true, scrollX: true, paging: true, processing: true, ordering: false,
            columns: [
                { data: null, title: 'Sr. #', render: function (_, type, row, meta) { return meta.row + 1; } },
                { data: null, title: 'Action', orderable: false, render: function (_, type, row) { return type === 'display' ? '<a href="#" class="feedback-action-link" title="Review / respond" onclick="return showCollectionCommentsRemarkPopup(' + (+row.FeedbackID) + ');"><i class="fas fa-comment-dots"></i></a>' : ''; } },
                { data: 'ProjectName', title: 'Project', render: renderATRReviewText }, { data: 'LoanNumber', title: 'Loan #', render: renderATRReviewText }, { data: 'Reviewer', title: 'Reviewer', render: renderATRReviewText },
                { data: 'DataField', title: 'Data Field', render: renderATRReviewText }, { data: 'IsError', title: 'Is Error', render: renderATRReviewText }, { data: 'Finding', title: 'Finding', render: renderATRReviewText },
                { data: 'FeedbackStatus', title: 'Status', render: renderATRReviewText }, { data: 'OnshoreRemark', title: 'Response / Remark', render: renderATRReviewText }, { data: 'AddedByName', title: 'Added By', render: renderATRReviewText }, { data: 'AddedDate', title: 'Added Date', render: renderATRReviewText }
            ], buttons: [{ extend: 'excelHtml5', title: 'Collection Comments ReQC Feedback - OnShore', exportOptions: { columns: ':not(:eq(1))' } }]
        });
    }, error: hideCollectionCommentsTab, complete: function () { $('#collectionCommentsLoader').hide(); } }); return false;
}

function renderATRReviewText(value, type) {
    if (type !== 'display') {
        return blankForNull(value);
    }
    return encodeInfinityOnshoreHtml(value);
}

function hideATRReviewTab() {
    $('#atrReviewTabItem').hide();
    if ($('#atrReviewTab').hasClass('active')) {
        $('#standardFeedbackTab').tab('show');
    }
}

function bindATRReviewFeedback(fromDate, toDate) {
    $('#atrFeedbackLoader').show();

    $.ajax({
        url: 'InfinityFeedbackOnshore.aspx/GetATRReviewFeedbackByDateRange',
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        dataType: 'json',
        data: JSON.stringify({ FromDate: fromDate, ToDate: toDate }),
        success: function (response) {
            var rows = JSON.parse(response.d || '[]');

            if ($.fn.DataTable.isDataTable('#table_ATRReviewFeedback')) {
                $('#table_ATRReviewFeedback').DataTable().clear().destroy();
            }

            if (!rows.length) {
                $('#table_ATRReviewFeedback').empty();
                hideATRReviewTab();
                return;
            }

            $('#atrReviewTabItem').show();
            $('#table_ATRReviewFeedback').DataTable({
                dom: 'Bfrtip',
                data: rows,
                destroy: true,
                scrollX: true,
                paging: true,
                processing: true,
                ordering: false,
                columns: [
                    {
                        data: null,
                        title: 'Sr. #',
                        render: function (data, type, row, meta) {
                            return meta.row + 1;
                        }
                    },
                    { data: 'ProjectName', title: 'Project Name', render: renderATRReviewText },
                    { data: 'ProcessID', title: 'Process ID', render: renderATRReviewText },
                    { data: 'DealNo', title: 'Deal #', render: renderATRReviewText },
                    { data: 'LoanNo', title: 'Loan #', render: renderATRReviewText },
                    { data: 'Reviewer', title: 'Reviewer', render: renderATRReviewText },
                    { data: 'ReviewDate', title: 'Review Date', render: renderATRReviewText },
                    { data: 'ATRSupported', title: 'ATR Supported?', render: renderATRReviewText },
                    { data: 'ReviewFindings', title: 'Review Findings', render: renderATRReviewText },
                    { data: 'SellerDisclosedDTIIssue', title: 'Seller Disclosed DTI Issue', render: renderATRReviewText },
                    { data: 'NoOfBorrowers', title: '# of Borrowers', render: renderATRReviewText },
                    { data: 'HighestBorrowerIncomeType', title: 'Highest BWR Income Type', render: renderATRReviewText },
                    { data: 'NoOfSEBusiness', title: '# of SE Businesses', render: renderATRReviewText },
                    { data: 'NoOfRentalProperties', title: '# Rental Properties', render: renderATRReviewText },
                    { data: 'Comments', title: 'Comments', render: renderATRReviewText },
                    { data: 'AddedByName', title: 'Added By', render: renderATRReviewText },
                    { data: 'AddedDate', title: 'Added Date', render: renderATRReviewText },
                    { data: 'Script', title: 'Script', render: renderATRReviewText }
                ],
                buttons: [
                    { extend: 'excelHtml5', title: 'ATR Review Feedback - OnShore' }
                ],
                initComplete: function () {
                    $('#atrFeedbackLoader').hide();
                }
            });
        },
        error: function () {
            hideATRReviewTab();
        },
        complete: function () {
            $('#atrFeedbackLoader').hide();
        }
    });

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


                createdRow: function (row, data, dataIndex) {
                    if ((data["Finding Status"] || "").toString().trim().toLowerCase() === "rebuttal") {
                        $(row).addClass("row-disagree");
                    }
                },

                columns: [
                    {
                        data: null, title: 'Sr. #',
                        render: function (data, type, row, meta) {
                            return meta.row + 1;
                        }
                    },
                    {
                        data: null,
                        title: 'Action',
                        className: 'text-center',
                        orderable: false,
                        render: function (data, type, row) {
                            if (type !== 'display') {
                                return '';
                            }
                            return renderInfinityOnshoreActionLink(row);
                        }
                    },
                    {
                        data: 'LoanNumber',
                        title: 'Loan Number',
                        render: function (data, type) {
                            if (type !== 'display') {
                                return blankForNull(data);
                            }
                            return encodeInfinityOnshoreHtml(data);
                        }
                    },
                    { data: 'Client', title: 'Client' },
                    { data: 'UWName', title: 'UW Name', className: 'text-nowrap' },
                    { data: 'QCName', title: 'QC Name', className: 'text-nowrap' },
                    { data: 'DateReviewed', title: 'Date Reviewed' },
                    { data: 'QCDate', title: 'QC Date' },
                    { data: 'Category', title: 'Category' },
                    { data: 'Subcategory', title: 'Subcategory' },
                    { data: 'ErrorField', title: 'Error Field' },
                    { data: 'Screen', title: 'Screen' },
                    { data: 'ErrorType', title: 'Error Type' },
                    { data: 'Finding', title: 'Finding', className:'text-nowrap' },
                    { data: 'FeedbackType', title: 'Feedback Type' },
                    { data: 'Severity', title: 'Severity' },
                    { data: 'RCA', title: 'RCA', className: "nowrap" },
                    { data: 'Finding Status', title: 'Finding Status' },
                    { data: 'Source', title: 'Source', className: "nowrap" },
                    { data: 'FeedbackReceivedDate', title: 'Feedback Received Date' },
                    { data: 'RebuttalRemark', title: 'Rebuttal Remark' },
                    { data: 'RebuttalAddedDate', title: 'Rebuttal AddedDate' }
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
