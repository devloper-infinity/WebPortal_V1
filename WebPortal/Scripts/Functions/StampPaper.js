var stampinvoice_table;
var stampinvoice_html;
var stampinfo_html;
var stampinfo_table;

function stampinfo_bindemployees() {
    var select = document.getElementById("stampinfo_employee");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#stampinfo_employee").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "StampPaperInformation.aspx/GetAllEmployees", dataType: "json", contentType: "application/json",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                $("#stampinfo_employee").append($("<option></option>").val(value.Code).html(value.FullName));
            })
        }
    });
}

function stampinfo_submit() {
    var ddlcode = document.getElementById("stampinfo_employee");
    var stampinfo_employee = ddlcode.options[ddlcode.selectedIndex].text;
    var ddltype = document.getElementById("stampinfo_stamppapertype");
    var stampinfo_stamppapertype = ddltype.options[ddltype.selectedIndex].value;
    var stampinfo_stamppaperno = document.getElementById("stampinfo_stamppaperno").value;
    var stampinfo_stamppapercost = document.getElementById("stampinfo_stamppapercost").value;
    var stampinfo_stamppaperversion = document.getElementById("stampinfo_stamppaperversion").value;
    var ddlinfo = document.getElementById("stampinfo_stamppapercount");
    var stampinfo_stamppapercount = ddlinfo.options[ddlinfo.selectedIndex].value;
    var stampinfo_stamppaperreceiveddate = document.getElementById("stampinfo_stamppaperreceiveddate").value;
    var stampinfo_remark = document.getElementById("stampinfo_remark").value;



    if (stampinfo_employee == "Select") {
        alert("Please select employee");
        return false;
    }
    if (stampinfo_stamppapertype == "") {
        alert("Please select stamp paper type");
        return false;
    }
    if (stampinfo_stamppaperno == "") {
        alert("Please select stamp paper #");
        return false;
    }
    if (stampinfo_stamppapercost == "") {
        alert("Please select stamp paper cost");
        return false;
    }
    if (stampinfo_stamppaperversion == "") {
        alert("Please select stamp paper version");
        return false;
    }
    if (stampinfo_stamppapercount == "") {
        alert("Please select stamp paper count");
        return false;
    }
    if (stampinfo_stamppaperreceiveddate == "") {
        alert("Please select received date");
        return false;
    }
    if (stampinfo_remark == "") {
        alert("Please select remark");
        return false;
    }

    PageMethods.InsertStampPaperInfo(stampinfo_employee, stampinfo_stamppapertype, stampinfo_stamppaperno, stampinfo_stamppapercost, stampinfo_stamppaperversion, stampinfo_stamppapercount, stampinfo_stamppaperreceiveddate, stampinfo_remark, stampinfo_OnSuccess, stampinfo_OnError)
    return false;
}

function stampinfo_OnSuccess(result) {
    if (result > 0) {
        document.getElementById("selfleave_errmsg").innerHTML = "Record added successfully!";
        $('#stampinfo_dverror').modal('show');
        return false;
    }
    else {
        document.getElementById("selfleave_errmsg").innerHTML = "Oops! Error occured while adding record. Please contact administrator!";
        document.getElementById("selfleave_errmsg").style.color = 'red';
        $('#stampinfo_dverror').modal('show');
        return false;
    }
    return false;
}
function stampinfo_OnError(error) {
    alert(error);
}

function stampinfo_Message() {
    $('#stampinfo_dverror').modal('hide');
    document.getElementById("stampinfo_employee").selectedIndex = 0;
    document.getElementById("stampinfo_stamppapertype").selectedIndex = 0;
    document.getElementById("stampinfo_stamppaperno").value = '';
    document.getElementById("stampinfo_stamppapercost").value = '';
    document.getElementById("stampinfo_stamppaperversion").value = '';
    document.getElementById("stampinfo_stamppapercount").selectedIndex = 0;
    document.getElementById("stampinfo_stamppaperreceiveddate").value = '';
    document.getElementById("stampinfo_remark").value = '';
    stampinfo_BindStampPaperInfo();
}

function stampinfo_BindStampPaperInfo() {

    stampinfo_html = '';
    $.ajax({
        url: "StampPaperInformation.aspx/BindStampPaperInformation",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                stampinfo_html += '<tr>';
                stampinfo_html += '<td style="text-wrap: nowrap;text-align:center;">' + blankForNull(value.Code) + '</td>';
                stampinfo_html += '<td style="text-align:center;">' + blankForNull(value.PaperType) + '</td>';
                stampinfo_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.StampPaperNo) + '</td>';
                stampinfo_html += '<td style="text-align:center;">' + blankForNull(value.StampPaperCost) + '</td>';
                stampinfo_html += '<td style="text-align:center;">' + blankForNull(value.Version) + '</td>';
                stampinfo_html += '<td style="text-align:center;">' + blankForNull(value.StampPaperUsed) + '</td>';
                stampinfo_html += '<td style="text-align:center;">' + blankForNull(value.ReceivedDate) + '</td>';
                stampinfo_html += '<td style="text-align:center;">' + blankForNull(value.Remark) + '</td>';
                stampinfo_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#stampinfo_table')) {
                stampinfo_table.destroy();
            }
            $('#stampinfo_table tbody').html(stampinfo_html);
            //else
            stampinfo_table = $('#stampinfo_table').DataTable({
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
                        extend: 'excelHtml5', title: 'Stamp Paper Information', autoFilter: true,
                        exportOptions: {
                            columns: [0, 1, 2, 3, 4, 5, 6, 7],
                        }

                    },


                ],

            });

            //$('#fnalize tbody').on('click', 'tr', function () {
            //    row = table.row(this).data();
            //});
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}

function getExportedExcel() {
    
}

function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

function stampinvoice_submit() {
    var stampinvoice_fromdate = document.getElementById("stampinvoice_fromdate").value;
    var stampinvoice_todate = document.getElementById("stampinvoice_todate").value;
    if (stampinvoice_fromdate == "") {
        alert("Please select From Date");
        return false;
    }
    if (stampinvoice_todate == "") {
        alert("Please select To Date");
        return false;
    }
    $('#load1').show();
    stampinvoice_html = '';
    $.ajax({
        url: "StampPaperInvoice.aspx/GetInvoiceData",
        type: "POST",
        data: "{FromDate:'" + stampinvoice_fromdate + "', ToDate:'" + stampinvoice_todate + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            document.getElementById("stampinvoice_lblinvoiceno").innerHTML = document.getElementById("stampinvoice_voucherno").value;
            document.getElementById("stampinvoice_lblinvoicedate").innerHTML = document.getElementById("stampinvoice_voucherdate").value;
            //stampinvoice_html = '';

            $.each(dataArray, function (index, value) {
                stampinvoice_html += '<tr>';
                stampinvoice_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.BranchName) + '</td>';
                stampinvoice_html += '<td style="text-align:center;">' + blankForNull(value.Code) + '</td>';
                stampinvoice_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Name) + '</td>';
                stampinvoice_html += '<td style="text-align:center;">' + blankForNull(value.Agreement) + '</td>';
                stampinvoice_html += '<td style="text-align:center;">' + blankForNull(value.Addendum) + '</td>';
                stampinvoice_html += '<td style="text-align:center;">' + blankForNull(value.undertaking) + '</td>';
                stampinvoice_html += '<td style="text-align:center;">' + blankForNull(value.StampPapersUsed) + '</td>';
                stampinvoice_html += '<td style="text-align:center;">' + blankForNull(value.Cost) + '</td>';
                stampinvoice_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.DeptDesg) + '</td>';
                stampinvoice_html += '<td style="text-align:center;">' + blankForNull(value.Version) + '</td>';
                stampinvoice_html += '<td style="text-align:center;">' + blankForNull(value.StampPaperNo) + '</td>';
                stampinvoice_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#stampinvoice_table')) {
                stampinvoice_table.destroy();
            }
            $('#stampinvoice_table tbody').html(stampinvoice_html);
            //else
            stampinvoice_table = $('#stampinvoice_table').DataTable({
                dom: 'lftip',
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
                        extend: 'excel', title: 'Stamp Paper Invoice', autoFilter: true,
                        exportOptions: {
                            columns: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
                        },
                        customize: function (xlsx) {
                            //Apply styles, Center alignment of text and making it bold.
                            var sSh = xlsx.xl['styles.xml'];
                            var lastXfIndex = $('cellXfs xf', sSh).length - 1;

                            var n1 = '<numFmt formatCode="##0.0000%" numFmtId="300"/>';
                            var s2 = '<xf numFmtId="0" fontId="2" fillId="0" borderId="0" applyFont="1" applyFill="0" applyBorder="0" xfId="0" applyAlignment="1">' +
                                '<alignment horizontal="center"/></xf>';

                            sSh.childNodes[0].childNodes[0].innerHTML += n1;
                            sSh.childNodes[0].childNodes[5].innerHTML += s2;

                            var greyBoldCentered = lastXfIndex + 1;

                            //Merge cells as per the table's colspan
                            var sheet = xlsx.xl.worksheets['sheet1.xml'];
                            var dt = $('#stampinvoice_table').DataTable();
                            /*alert(dt);*/
                            var frColSpan = $(dt.table().header()).find('th:nth-child(1)').prop('colspan');
                            var srColSpan = $(dt.table().header()).find('th:nth-child(2)').prop('colspan');
                            var columnToStart = 0;

                            var mergeCells = $('mergeCells', sheet);
                            mergeCells[0].appendChild(_createNode(sheet, 'mergeCell', {
                                attr: {
                                    ref: 'A1:' + toColumnName(frColSpan) + '1'
                                }
                            }));

                            mergeCells.attr('count', mergeCells.attr('count') + 1);

                            var columnToStart = 0;

                            while (columnToStart <= frColSpan) {
                                mergeCells[0].appendChild(_createNode(sheet, 'mergeCell', {
                                    attr: {
                                        ref: toColumnName(columnToStart) + '0:' + toColumnName((columnToStart - 1) + srColSpan) + '0'
                                    }
                                }));
                                columnToStart = columnToStart + srColSpan;
                                mergeCells.attr('count', mergeCells.attr('count') + 1);
                            }

                            //Text alignment to center and apply bold
                            $('row:nth-child(1) c:nth-child(1)', sheet).attr('s', greyBoldCentered);
                            for (i = 0; i < frColSpan; i++) {
                                $('row:nth-child(2) c:nth-child(' + i + ')', sheet).attr('s', greyBoldCentered);
                            }

                            function _createNode(doc, nodeName, opts) {
                                var tempNode = doc.createElement(nodeName);
                                if (opts) {
                                    if (opts.attr) {
                                        $(tempNode).attr(opts.attr);
                                    }
                                    if (opts.children) {
                                        $.each(opts.children, function (key, value) {
                                            tempNode.appendChild(value);
                                        });
                                    }
                                    if (opts.text !== null && opts.text !== undefined) {
                                        tempNode.appendChild(doc.createTextNode(opts.text));
                                    }
                                }
                                return tempNode;
                            }

                            //Function to fetch the cell name
                            function toColumnName(num) {
                                for (var ret = '', a = 1, b = 26; (num -= a) >= 0; a = b, b *= 26) {
                                    ret = String.fromCharCode(parseInt((num % b) / a) + 65) + ret;
                                }
                                return ret;
                            }
                        }

                    },


                ],

            });

            //$('#fnalize tbody').on('click', 'tr', function () {
            //    row = table.row(this).data();
            //});
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}


