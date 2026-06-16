var InvoiceID = 0;
var RemoteDD_html = '';
function parseDate(str) {
    var mdy = str.split('/');
    return new Date(mdy[2], mdy[0] - 1, mdy[1]);
}
function datediff(first, second) {
    return Math.round((second - first) / (1000 * 60 * 60 * 24));
}
function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

function BindAllAbstractorReport() {
    $('#load1').show();
    RemoteDD_html = '';

    $.ajax({
        url: "AbstractorReport.aspx/BindAllAbstractorReport",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//

            $.each(dataArray, function (index, value) {

                RemoteDD_html += '<tr>';
                RemoteDD_html += '<td class=""><div class="btn-group">';
                RemoteDD_html += '<div class="btn-group">';
                RemoteDD_html += '<div type="button" data-toggle="dropdown" aria-expanded="false"><i style="color: dodgerblue; font-size:14px;" class="uil fs-0 me-2 uil-cog"></i>';
                RemoteDD_html += '<span class="sr-only"></span></div><div class="dropdown-menu" role="menu" style="">';
                RemoteDD_html += '<a class="dropdown-item" href="#!" id="Actions" onclick="showCoverage(' + value.AbstractorID + ');"><span style="color: forestgreen;"><i class="fas fa-list-alt"></i></span>&nbsp;&nbsp;Show Coverage</a>';
                RemoteDD_html += '<a class="dropdown-item" href="#!" id="Actions" onclick="showAttachment(' + value.AbstractorID + ');"><span style="color: orange;"><i class="fas fa-th-large"></i></span>&nbsp;&nbsp;Show Attachment</a>';
                RemoteDD_html += '</div></div></td>';
                RemoteDD_html += '<td style="text-wrap: nowrap;text-align:center;">' + blankForNull((index + 1)) + '</td>';
                RemoteDD_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.AbstractorCode) + '</td>';
                RemoteDD_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.AbstractorName) + '</td>';
                RemoteDD_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.EandOExpiry) + '</td>';
                RemoteDD_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Address) + '</td>';
                RemoteDD_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ContactNo1) + '</td>';
                RemoteDD_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.MobileNo) + '</td>';
                RemoteDD_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Email) + '</td>';
                RemoteDD_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Status) + '</td>';
                RemoteDD_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Remark) + '</td>';
                RemoteDD_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#allAbstractorlist')) {
                allAbstractorlist.destroy();
            }
            $('#allAbstractorlist tbody').html(RemoteDD_html);

            table_VendorDashbordSummary = $('#allAbstractorlist').DataTable({
                dom: 'lBftip',
                scrollX: true,
                destroy: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                'select': {
                    'style': 'single'
                },

                initComplete: function () {
                    $('#load1').hide();
                },

                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Abstractor Report',
                    },
                ],
            });

        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}

function showCoverage(abstractorId) {

    var myModal = new bootstrap.Modal(document.getElementById('popUpShowCoverage'));
    myModal.show();
    bindAbstractorCosting(abstractorId);
}

function showAttachment(abstractorId) {

    var myModal = new bootstrap.Modal(document.getElementById('popUpShowAttachment'));
    myModal.show();
    bindAbstractorAttachment(abstractorId);
}

function bindAbstractorCosting(abstractorId) {

    $('#load1').show();

    abstractorId = 1951;

    $.ajax({
        type: "POST",
        url: "AbstractorReport.aspx/GetAbstractorCostingCoverage",
        data: JSON.stringify({ AbstractorID: abstractorId }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            if ($.fn.DataTable.isDataTable('#tblAbstractorCosting')) {
                $('#tblAbstractorCosting').DataTable().clear().destroy();
            }

            $('#tblAbstractorCosting').DataTable({
                dom: 'lBftip',
                data: dataArray,
                scrollX: true,
                paging: true,
                autoWidth: true,
                processing: true,
                ordering: false,
                serverSide: false,

                "columns": [
                    { data: "SrNo" },   // FieldName from DevExpress grid
                    { data: "AbstractorName" },
                    { data: "State" },
                    { data: "County" },
                    { data: "Online" },
                    { data: "CurrentOwner" },
                    { data: "TwoOwner" },
                    { data: "FullSearch" },
                    { data: "30Yr" },
                    { data: "40Yr" },
                    { data: "50Yr" },
                    { data: "60Yr" },
                    { data: "DocRequest" },
                    { data: "LandV" },
                    { data: "Update" },
                    { data: "Judgement" },
                    { data: "Copy" }
                ],
                columnDefs: [
                    {
                        targets: "_all",
                        className: "col-border text-center"
                    }
                ],
                initComplete: function () {

                    $('#load1').hide();
                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Abstractor Report',
                        //exportOptions: {
                        //    columns: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17],
                        //    format: {
                        //        header: function (data, columnIdx) {
                        //            // Return ONLY the first header row text
                        //            return $('#table_OSTReport thead tr:eq(0) th').eq(columnIdx).text();
                        //        }
                        //    }
                        //},
                    },
                ],
            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}

function bindAbstractorAttachment(abstractorId) {

    $('#load1').show();

    $.ajax({
        type: "POST",
        url: "AbstractorReport.aspx/GetAbstractorDocuments",
        data: JSON.stringify({ AbstractorID: abstractorId }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            if ($.fn.DataTable.isDataTable('#tblAttachment')) {
                $('#tblAttachment').DataTable().clear().destroy();
            }

            $('#tblAttachment').DataTable({
                dom: 'ti',
                data: dataArray,
                scrollX: true,
                paging: true,
                autoWidth: true,
                processing: true,
                ordering: false,
                serverSide: false,

                "columns": [
                    {
                        data: null,
                        title: "Action",
                        orderable: false,
                        render: function (data, type, row, meta) {

                            const abstractorId = row.AbstractorID + ',' + row.DocumentsID;
                            const url = `DownloadFiles.aspx?AbstractorID=${abstractorId}`;

                            return `<a href="${url}"><i class="uil-cloud-download"></i></a>`;
                        }
                    },
                    { data: "SrNo" },
                    { data: "AbstractorCode" },
                    { data: "DocumentName" },
                    { data: "UploadedByName" },
                    { data: "UploadedDate" }
                ],
                columnDefs: [
                    {
                        targets: "_all",
                        className: "col-border text-center"
                    }
                ],
                initComplete: function () {
                    $('#load1').hide();
                }
            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}