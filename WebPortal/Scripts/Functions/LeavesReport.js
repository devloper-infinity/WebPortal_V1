
var userWiseArray = { table1: [], table2: [] };
function BindViewLeaveReportDetails_Grid() {

    var fromdate = document.getElementById("leaveReport_FromDate").value;
    var todate = document.getElementById("leaveReport_ToDate").value;
    if (!fromdate || !todate) {
        Swal.fire("Validation", "Please select from date to date", "warning");
        return false;
    }
    //fromdate = "26-Dec-2024";
    //todate = "31-Dec-2025";
    $('#load1').show();

    $.when(
        $.ajax({
            url: 'LeaveReport.aspx/GetLeaveReport',
            type: "POST",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({ FromDate: fromdate, ToDate: todate })
        }),
        $.ajax({
            url: 'LeaveReport.aspx/GetUserWiseLeaveDetails',
            type: "POST",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({ FromDate: fromdate, ToDate: todate })
        })
    ).done(function (mainResponse, userWiseResponse) {

        var mainData = mainResponse[0];


        var dataArray = typeof mainData.d === "string" ? JSON.parse(mainData.d) : mainData.d;

        var userWiseDataRaw = userWiseResponse[0];
        var parsedRaw = typeof userWiseDataRaw.d === "string" ? JSON.parse(userWiseDataRaw.d) : userWiseDataRaw.d;

        if (Array.isArray(parsedRaw)) {
            userWiseArray = { table1: parsedRaw, table2: [] };
        } else {
            userWiseArray = parsedRaw;
        }

        if ($.fn.DataTable.isDataTable('#table_leaveDetails')) {
            $('#table_leaveDetails').DataTable().clear().destroy();
        }

        $('#table_leaveDetails').DataTable({
            dom: 'lBftp',
            data: dataArray,
            scrollX: false,
            paging: true,
            processing: true,
            ordering: false,
            serverSide: false,

            columns: [

                {
                    data: null,
                    className: 'text-center',
                    orderable: false,
                    searchable: false,
                    width: "60px",
                    render: function (data, type, row, meta) {

                        // For display in table
                        if (type === 'display') {
                            return meta.row + meta.settings._iDisplayStart + 1;
                        }

                        // For Excel export
                        return meta.row + 1;
                    }
                },
                { data: 'Code', width: "60px" },
                { data: 'EmpName' },
                { data: 'BranchName' },
                { data: 'DepartmentName' },
                { data: 'DesignationName' },
                { data: 'DomainName' },
                { data: 'ReportingManager' },
                { data: 'LeaveType' },
                { data: 'ForDays', className: 'text-center' },
                { data: 'LeaveFrom' },
                { data: 'LeaveTo' },
                { data: 'LeaveStatus', className: 'text-center' },
                { data: 'ActualDays', className: 'text-center' },
                { data: 'PaidLeaves', className: 'text-center' },
                { data: 'UnpaidLeaves', className: 'text-center' },
                { data: 'ReasonForLeave', width: "400px" },
                { data: 'ApprovalRemark' },
                { data: 'ApprovedByName' },
                { data: 'ApprovedDate1' }
            ],

            footerCallback: function (row, data, start, end, display) {

                var api = this.api();

                function intVal(i) {
                    return typeof i === 'string' ? parseFloat(i.replace(/[^0-9.-]/g, '')) || 0 : typeof i === 'number' ? i : 0;
                }

                var totalDays = 0;
                var actualTotal = 0;
                var paidTotal = 0;
                var unpaidTotal = 0;

                api.rows({ search: 'applied' }).every(function () {

                    var d = this.data();

                    totalDays += intVal(d.ForDays);
                    actualTotal += intVal(d.ActualDays);
                    paidTotal += intVal(d.PaidLeaves);
                    unpaidTotal += intVal(d.UnpaidLeaves);
                });

                // Set footer values (adjust index if needed)
                $(api.column(9).footer()).html(totalDays);      // Days
                $(api.column(13).footer()).html(actualTotal);  // Actual Days
                $(api.column(14).footer()).html(paidTotal);    // Paid
                $(api.column(15).footer()).html(unpaidTotal);  // Unpaid
            },

            initComplete: function () {

                var api = this.api();

                $('#table_leaveDetails thead tr.filters th').each(function (i) {

                    if (i === 0) return;

                    var input = $('input', this);

                    // Columns that need 60px width
                    var smallColumns = [1, 3, 4, 5, 7, 8, 9, 10];

                    if (smallColumns.includes(i)) {
                        input.css('width', '60px');
                    } else {
                        input.css('width', '100px');
                    }

                    input.on('keyup change', function () {
                        if (api.column(i).search() !== this.value) {
                            api.column(i).search(this.value).draw();
                        }
                    });

                });

                $('#load1').hide();
            },

            buttons: [
                {
                    extend: 'excelHtml5',
                    footer: true,
                    action: function (e, dt, node, config) {
                        var fromdate = $('#leaveReport_FromDate').val();
                        var todate = $('#leaveReport_ToDate').val();

                        // 1. Check if dates are selected
                        if (!fromdate || !todate) {
                            Swal.fire("Validation", "Please select both From Date and To Date.", "warning");
                            return false;
                        }

                        // 2. Check if the table has any data rows to export
                        if (dt.rows().count() === 0) {
                            Swal.fire("Validation", "No data available to export.", "warning");
                            return false;
                        }

                        $.fn.DataTable.ext.buttons.excelHtml5.action.call(this, e, dt, node, config);
                    },
                    exportOptions: {
                        columns: ':visible',
                        format: {
                            header: function (data, columnIdx) {
                                return $('#table_leaveDetails thead th').eq(columnIdx).text();
                            },
                            body: function (data, row, column, node) {
                                if (column === 0) {
                                    return row + 1;
                                }
                                return data;
                            }
                        }
                    },
                    filename: function () {
                        var code = $('#table_leaveDetails thead tr.filters th').eq(1).find('input').val() || "AllCodes";
                        var fromdate = $('#leaveReport_FromDate').val() || "";
                        var todate = $('#leaveReport_ToDate').val() || "";
                        return 'Leave Report_' + code + '_' + fromdate + '_to_' + todate;
                    },
                    customize: function (xlsx) {
                        var stylesXml = xlsx.xl['styles.xml'];

                        // Helper function to safely add unique elements or return existing indexes
                        function addStyleElements(styles) {
                            var fills = styles.getElementsByTagName('fills')[0];
                            var fillCount = parseInt(fills.getAttribute('count'), 10);
                            var newFill = styles.createElementNS('http://schemas.openxmlformats.org/spreadsheetml/2006/main', 'fill');
                            newFill.innerHTML = '<patternFill patternType="solid"><fgColor rgb="FFD3D3D3"/><bgColor indexed="64"/></patternFill>';
                            fills.appendChild(newFill);
                            fills.setAttribute('count', fillCount + 1);
                            var targetFillIdx = fillCount;

                            var borders = styles.getElementsByTagName('borders')[0];
                            var borderCount = parseInt(borders.getAttribute('count'), 10);
                            var newBorder = styles.createElementNS('http://schemas.openxmlformats.org/spreadsheetml/2006/main', 'border');
                            newBorder.innerHTML = '<left style="thin"><color rgb="FF000000"/></left><right style="thin"><color rgb="FF000000"/></right><top style="thin"><color rgb="FF000000"/></top><bottom style="thin"><color rgb="FF000000"/></bottom>';
                            borders.appendChild(newBorder);
                            borders.setAttribute('count', borderCount + 1);
                            var targetBorderIdx = borderCount;

                            var fonts = styles.getElementsByTagName('fonts')[0];
                            var fontCount = parseInt(fonts.getAttribute('count'), 10);

                            var newBoldFont = styles.createElementNS('http://schemas.openxmlformats.org/spreadsheetml/2006/main', 'font');
                            newBoldFont.innerHTML = '<b/><sz val="11"/><color rgb="FF000000"/><name val="Calibri"/>';
                            fonts.appendChild(newBoldFont);

                            var newNormalFont = styles.createElementNS('http://schemas.openxmlformats.org/spreadsheetml/2006/main', 'font');
                            newNormalFont.innerHTML = '<sz val="11"/><color rgb="FF000000"/><name val="Calibri"/>';
                            fonts.appendChild(newNormalFont);
                            fonts.setAttribute('count', fontCount + 2);

                            var cellXfs = styles.getElementsByTagName('cellXfs')[0];
                            var xfCount = parseInt(cellXfs.getAttribute('count'), 10);

                            // Header Style
                            var headerXf = styles.createElementNS('http://schemas.openxmlformats.org/spreadsheetml/2006/main', 'xf');
                            headerXf.setAttribute('numFmtId', '0');
                            headerXf.setAttribute('fontId', fontCount.toString());
                            headerXf.setAttribute('fillId', targetFillIdx.toString());
                            headerXf.setAttribute('borderId', targetBorderIdx.toString());
                            headerXf.setAttribute('xfId', '0');
                            headerXf.setAttribute('applyFont', '1');
                            headerXf.setAttribute('applyFill', '1');
                            headerXf.setAttribute('applyBorder', '1');

                            var alignment = styles.createElementNS('http://schemas.openxmlformats.org/spreadsheetml/2006/main', 'alignment');
                            alignment.setAttribute('horizontal', 'center');
                            alignment.setAttribute('vertical', 'center');
                            alignment.setAttribute('wrapText', '1');
                            headerXf.appendChild(alignment);
                            cellXfs.appendChild(headerXf);

                            // Data Style
                            var dataXf = styles.createElementNS('http://schemas.openxmlformats.org/spreadsheetml/2006/main', 'xf');
                            dataXf.setAttribute('numFmtId', '0');
                            dataXf.setAttribute('fontId', (fontCount + 1).toString());
                            dataXf.setAttribute('fillId', '0');
                            dataXf.setAttribute('borderId', targetBorderIdx.toString());
                            dataXf.setAttribute('xfId', '0');
                            dataXf.setAttribute('applyFont', '1');
                            dataXf.setAttribute('applyBorder', '1');
                            cellXfs.appendChild(dataXf);

                            cellXfs.setAttribute('count', xfCount + 2);
                            return { header: xfCount.toString(), data: (xfCount + 1).toString() };
                        }

                        var defaultStyles = addStyleElements(stylesXml);
                        var headerStyle = defaultStyles.header;
                        var dataStyle = defaultStyles.data;

                        /* ===== 1. STYLE DETAILS SHEET (Sheet 1) ===== */
                        var sheet1 = xlsx.xl.worksheets['sheet1.xml'];
                        $('row[r="2"] c', sheet1).attr('s', headerStyle);

                        var lastRow = $('row', sheet1).last().attr('r');
                        $('row', sheet1).each(function () {
                            var rowIndex = parseInt($(this).attr('r'));
                            if (rowIndex > 2 && rowIndex < parseInt(lastRow)) {
                                $(this).find('c').attr('s', dataStyle);
                            }
                        });
                        $('row[r="' + lastRow + '"] c', sheet1).attr('s', '22');
                        var headerCells = $('row[r="2"] c', sheet1);
                        var lastCol = 'H'; 
                        if (headerCells.length > 0) {
                            lastCol = getColumnLetter(headerCells.length);
                        }

                        var autoFilter = sheet1.createElementNS('http://schemas.openxmlformats.org/spreadsheetml/2006/main', 'autoFilter');
                        autoFilter.setAttribute('ref', 'A2:' + lastCol + lastRow);

                        var sheetData = sheet1.getElementsByTagName('sheetData')[0];
                        sheetData.parentNode.insertBefore(autoFilter, sheetData.nextSibling);
                        /* ===== 2. BUILD SHEET 2 (UserWise / table1) ===== */
                        var t1Data = userWiseArray.table1 || [];
                        if (t1Data.length > 0) {
                            var keys1 = Object.keys(t1Data[0]);
                            var colWidths1 = {};
                            keys1.forEach(function (key, idx) {
                                colWidths1[idx] = String(key).length;
                            });

                            t1Data.forEach(function (rowObj) {
                                keys1.forEach(function (key, idx) {
                                    var val = rowObj[key] !== null && rowObj[key] !== undefined ? String(rowObj[key]) : '';
                                    if (val.length > colWidths1[idx]) colWidths1[idx] = val.length;
                                });
                            });

                            var sheet2XmlString = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
                                '<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"><cols>';

                            keys1.forEach(function (key, idx) {
                                sheet2XmlString += '<col min="' + (idx + 1) + '" max="' + (idx + 1) + '" width="' + ((colWidths1[idx] || 10) + 4) + '" customWidth="1"/>';
                            });

                            sheet2XmlString += '</cols><sheetData><row r="1" ht="25" customHeight="1">';
                            keys1.forEach(function (key, idx) {
                                sheet2XmlString += '<c r="' + getColumnLetter(idx + 1) + '1" s="' + headerStyle + '" t="inlineStr"><is><t>' + escapeXml(key) + '</t></is></c>';
                            });
                            sheet2XmlString += '</row>';

                            t1Data.forEach(function (rowObj, rowIndex) {
                                var rIndex = rowIndex + 2;
                                sheet2XmlString += '<row r="' + rIndex + '">';
                                keys1.forEach(function (key, colIndex) {
                                    var cellLetter = getColumnLetter(colIndex + 1);
                                    var val = rowObj[key];
                                    if (val === null || val === undefined) {
                                        sheet2XmlString += '<c r="' + cellLetter + rIndex + '" s="' + dataStyle + '"/>';
                                    } else if (!isNaN(val) && String(val).trim() !== '') {
                                        sheet2XmlString += '<c r="' + cellLetter + rIndex + '" s="' + dataStyle + '" t="n"><v>' + val + '</v></c>';
                                    } else {
                                        sheet2XmlString += '<c r="' + cellLetter + rIndex + '" s="' + dataStyle + '" t="inlineStr"><is><t>' + escapeXml(String(val)) + '</t></is></c>';
                                    }
                                });
                                sheet2XmlString += '</row>';
                            });

                            sheet2XmlString += '</sheetData>';

                            var lastCol2 = getColumnLetter(keys1.length);
                            var lastRow2 = t1Data.length + 1;
                            sheet2XmlString += '<autoFilter ref="A1:' + lastCol2 + lastRow2 + '"/>'; 

                            sheet2XmlString += '</worksheet>';
                            xlsx.xl.worksheets['sheet2.xml'] = new DOMParser().parseFromString(sheet2XmlString, 'text/xml');
                        }

                        /* ===== 3. BUILD SHEET 3 (MonthWise / table2) ===== */
                        var t2Data = userWiseArray.table2 || [];
                        if (t2Data.length > 0) {
                            var months = Object.keys(t2Data[0]).filter(function (k) { return k !== "EmployeeName"; });
                            var totalCols2 = 1 + (months.length * 3);

                            var sheet3XmlString = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
                                '<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"><cols>';

                            for (var i = 1; i <= totalCols2; i++) {
                                sheet3XmlString += '<col min="' + i + '" max="' + i + '" width="' + (i === 1 ? 25 : 12) + '" customWidth="1"/>';
                            }
                            sheet3XmlString += '</cols><sheetData><row r="1" ht="25" customHeight="1">';
                            sheet3XmlString += '<c r="A1" s="' + headerStyle + '" t="inlineStr"><is><t>Employee Name</t></is></c>';

                            var currentColIdx = 2;
                            var mergeRanges = ["A1:A2"];
                            months.forEach(function (month) {
                                var startLetter = getColumnLetter(currentColIdx);
                                var endLetter = getColumnLetter(currentColIdx + 2);
                                sheet3XmlString += '<c r="' + startLetter + '1" s="' + headerStyle + '" t="inlineStr"><is><t>' + escapeXml(month) + '</t></is></c>';
                                sheet3XmlString += '<c r="' + getColumnLetter(currentColIdx + 1) + '1" s="' + headerStyle + '"/>';
                                sheet3XmlString += '<c r="' + endLetter + '1" s="' + headerStyle + '"/>';
                                mergeRanges.push(startLetter + "1:" + endLetter + "1");
                                currentColIdx += 3;
                            });
                            sheet3XmlString += '</row><row r="2" ht="20" customHeight="1"><c r="A2" s="' + headerStyle + '"/>';

                            currentColIdx = 2;
                            months.forEach(function () {
                                sheet3XmlString += '<c r="' + getColumnLetter(currentColIdx) + '2" s="' + headerStyle + '" t="inlineStr"><is><t>Total Leave</t></is></c>';
                                sheet3XmlString += '<c r="' + getColumnLetter(currentColIdx + 1) + '2" s="' + headerStyle + '" t="inlineStr"><is><t>Paid</t></is></c>';
                                sheet3XmlString += '<c r="' + getColumnLetter(currentColIdx + 2) + '2" s="' + headerStyle + '" t="inlineStr"><is><t>Unpaid</t></is></c>';
                                currentColIdx += 3;
                            });
                            sheet3XmlString += '</row>';

                            t2Data.forEach(function (rowObj, rowIndex) {
                                var rIndex = rowIndex + 3;
                                sheet3XmlString += '<row r="' + rIndex + '"><c r="A' + rIndex + '" s="' + dataStyle + '" t="inlineStr"><is><t>' + escapeXml(String(rowObj.EmployeeName || '')) + '</t></is></c>';
                                var dataColIdx = 2;
                                months.forEach(function (month) {
                                    var mObj = rowObj[month] || { Total: 0, Paid: 0, Unpaid: 0 };
                                    sheet3XmlString += '<c r="' + getColumnLetter(dataColIdx) + rIndex + '" s="' + dataStyle + '" t="n"><v>' + (mObj.Total || 0) + '</v></c>';
                                    sheet3XmlString += '<c r="' + getColumnLetter(dataColIdx + 1) + rIndex + '" s="' + dataStyle + '" t="n"><v>' + (mObj.Paid || 0) + '</v></c>';
                                    sheet3XmlString += '<c r="' + getColumnLetter(dataColIdx + 2) + rIndex + '" s="' + dataStyle + '" t="n"><v>' + (mObj.Unpaid || 0) + '</v></c>';
                                    dataColIdx += 3;
                                });
                                sheet3XmlString += '</row>';
                            });

                            sheet3XmlString += '</sheetData>';
                            if (mergeRanges.length > 0) {
                                sheet3XmlString += '<mergeCells count="' + mergeRanges.length + '">';
                                mergeRanges.forEach(function (r) { sheet3XmlString += '<mergeCell ref="' + r + '"/>'; });
                                sheet3XmlString += '</mergeCells>';
                            }



                            sheet3XmlString += '</worksheet>';
                            xlsx.xl.worksheets['sheet3.xml'] = new DOMParser().parseFromString(sheet3XmlString, 'text/xml');
                        }

                        /* ===== 4. REGISTER SHEETS, RELS, & CONTENT TYPES ===== */
                        var types = xlsx['[Content_Types].xml'];
                        var rels = xlsx.xl._rels['workbook.xml.rels'];
                        var wb = xlsx.xl['workbook.xml'];

                        if (types && rels && wb) {
                            var defaultType = types.getElementsByTagName('Override')[0];
                            var relationships = rels.getElementsByTagName('Relationships')[0];
                            var relChild = rels.getElementsByTagName('Relationship')[0];
                            var sheets = wb.getElementsByTagName('sheets')[0];
                            var sheetChild = wb.getElementsByTagName('sheet')[0];

                            if (t1Data.length > 0 && defaultType) {
                                var nt2 = defaultType.cloneNode(true);
                                nt2.setAttribute('PartName', '/xl/worksheets/sheet2.xml');
                                nt2.setAttribute('ContentType', 'application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml');
                                types.getElementsByTagName('Types')[0].appendChild(nt2);

                                var nr2 = relChild.cloneNode(true);
                                nr2.setAttribute('Id', 'rId3');
                                nr2.setAttribute('Type', 'http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet');
                                nr2.setAttribute('Target', 'worksheets/sheet2.xml');
                                relationships.appendChild(nr2);

                                var ns2 = sheetChild.cloneNode(true);
                                ns2.setAttribute('name', 'UserWise');
                                ns2.setAttribute('sheetId', '2');
                                ns2.setAttribute('r:id', 'rId3');
                                sheets.appendChild(ns2);
                            }

                            if (t2Data.length > 0 && defaultType) {
                                var nt3 = defaultType.cloneNode(true);
                                nt3.setAttribute('PartName', '/xl/worksheets/sheet3.xml');
                                nt3.setAttribute('ContentType', 'application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml');
                                types.getElementsByTagName('Types')[0].appendChild(nt3);

                                var nr3 = relChild.cloneNode(true);
                                nr3.setAttribute('Id', 'rId4');
                                nr3.setAttribute('Type', 'http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet');
                                nr3.setAttribute('Target', 'worksheets/sheet3.xml');
                                relationships.appendChild(nr3);

                                var ns3 = sheetChild.cloneNode(true);
                                ns3.setAttribute('name', 'MonthWise');
                                ns3.setAttribute('sheetId', '3');
                                ns3.setAttribute('r:id', 'rId4');
                                sheets.appendChild(ns3);
                            }
                        }

                        /* ===== 5. REORDER SHEETS (UserWise -> MonthWise -> Details) ===== */
                        var s1 = xlsx.xl.worksheets['sheet1.xml'];
                        var s2 = xlsx.xl.worksheets['sheet2.xml'];
                        var s3 = xlsx.xl.worksheets['sheet3.xml'];

                        xlsx.xl.worksheets['sheet1.xml'] = s2;
                        xlsx.xl.worksheets['sheet2.xml'] = s3;
                        xlsx.xl.worksheets['sheet3.xml'] = s1;

                        var sheetTags = wb.getElementsByTagName('sheets')[0].getElementsByTagName('sheet');
                        if (sheetTags.length >= 3) {
                            sheetTags[0].setAttribute('name', 'UserWise');
                            sheetTags[1].setAttribute('name', 'MonthWise');
                            sheetTags[2].setAttribute('name', 'Details');
                        }
                    }
                }
            ]
        });

    }).fail(function (error) {
        $('#load1').hide();
        alert('Error: ' + (error.responseText || "Failed to load report data."));
    });

    return false;
}
function getColumnLetter(colIndex) {
    var letter = '';
    while (colIndex > 0) {
        var remainder = (colIndex - 1) % 26;
        letter = String.fromCharCode(65 + remainder) + letter;
        colIndex = Math.floor((colIndex - 1) / 26);
    }
    return letter;
}

function escapeXml(unsafe) {
    return unsafe.replace(/[<>&'"]/g, function (c) {
        switch (c) {
            case '<': return '&lt;';
            case '>': return '&gt;';
            case '&': return '&amp;';
            case '\'': return '&apos;';
            case '"': return '&quot;';
        }
    });
}



 
