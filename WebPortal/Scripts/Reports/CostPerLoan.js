function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

function cploan_bindyear() {

    var start = new Date().getFullYear();

    var select = document.getElementById("cploan_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#cploan_year").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#cploan_year").append($("<option></option>").val(i).html(i));
    }
}

function cploansum_bindyear() {

    var start = new Date().getFullYear();

    var select = document.getElementById("cploansum_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#cploansum_year").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#cploansum_year").append($("<option></option>").val(i).html(i));
    }
}

function cploan_bindallgrids() {
    cploan_bindgrid();
    return false;
}

function cploan_bindgrid() {
    $('#load1').show();
    var columns = [];
    var ddlmonth = document.getElementById("cploan_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("cploan_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    var ddldomain = document.getElementById("cploan_domain");
    var domain = ddldomain.options[ddldomain.selectedIndex].value;

    $.ajax({
        url: "CostPerLoan.aspx/GetCostperLoanReport",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: "{Month:'" + month + "', Year:'" + year + "',Domain:'" + domain + "'}",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray[0], function (key, value) {

                var my_item = {};
                my_item.data = key;
                my_item.title = key;
                columns.push(my_item);
            });
            $('#cploan_table').DataTable({
                dom: 'lBftip',
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                filter: true,
                'select': {
                    'style': 'single'
                },
                "serverSide": false,
                "data": dataArray,
                columns: columns,
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                },

                initComplete: function () {
                    $('#load1').hide();
                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Summary Report', autoFilter: true,
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

function cploan_bindprodgrid() {

    $('#load1').show();

    var columns2 = [];       // IMPORTANT: reset every time
    var ddlmonth = document.getElementById("cploan_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("cploan_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    var ddldomain = document.getElementById("cploan_domain");
    var domain = ddldomain.options[ddldomain.selectedIndex].value;

    $.ajax({
        url: "CostPerLoan.aspx/GetCostperLoanReportProduction",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: "{Month:'" + month + "', Year:'" + year + "',Domain:'" + domain + "'}",

        success: function (data) {

            var dataArray = JSON.parse(data.d);

            // build column list
            $.each(dataArray[0], function (key, value) {
                columns2.push({ data: key, title: key });
            });

            // destroy old instance safely
            if ($.fn.DataTable.isDataTable('#cploan_prodtable')) {
                $('#cploan_prodtable').DataTable().clear().destroy();
            }

            // initialize new table
            var dt = $('#cploan_prodtable').DataTable({
                dom: 'lBftip',
                orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                paging: true,
                autoWidth: true,
                select: true,
                ordering: false,
                processing: true,
                filter: true,
                serverSide: false,

                data: dataArray,
                columns: columns2,

                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).find("td").css("white-space", "nowrap");
                },

                initComplete: function () {
                    $('#load1').hide();

                    // adjust after table becomes visible
                    setTimeout(() => {
                        dt.columns.adjust();
                    }, 50);
                },

                buttons: [
                    {
                        extend: 'excelHtml5',
                        title: 'Summary Report',
                        autoFilter: true,
                    },
                ]
            });
        },

        error: function (error) {
            alert('Error: ' + error.responseText);
        }
    });

    return true;
}

function cploansum_bindallgrids_Exisintg() {
    $('#load1').show();
    var columns = [];
    var ddlyear = document.getElementById("cploansum_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    var ddldomain = document.getElementById("cploansum_domain");
    var domain = ddldomain.options[ddldomain.selectedIndex].value;

    $.ajax({
        url: "CostPerLoanSummary.aspx/GetCostPerLoanSummary",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: "{Year:'" + year + "',Domain:'" + domain + "'}",

        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray[0], function (key, value) {

                var my_item = {};
                my_item.data = key;
                my_item.title = key;
                columns.push(my_item);
            });
            $('#cploansum_table').DataTable({
                dom: 'lBftip',
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                filter: true,
                'select': {
                    'style': 'single'
                },
                "serverSide": false,
                "data": dataArray,
                columns: columns,
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                },

                initComplete: function () {
                    $('#load1').hide();
                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Summary Report', autoFilter: true,
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

function cploansum_bindallgrids() {
    $('#load1').show();
    var columns = [];
    var ddlyear = document.getElementById("cploansum_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    var ddldomain = document.getElementById("cploansum_domain");
    var domain = ddldomain.options[ddldomain.selectedIndex].value;

    $.ajax({
        url: "CostPerLoanSummary.aspx/GetCostPerLoanSummary",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: "{Year:'" + year + "',Domain:'" + domain + "'}",

        success: function (data) {

            var dataArray = JSON.parse(data.d);//

            // ===============================
            // STEP 1: Parse headers dynamically
            // ===============================

            if ($.fn.dataTable.isDataTable('#cploansum_table')) {
                $('#cploansum_table').DataTable().destroy();
            }
            var sampleRow = dataArray[0];

            var staticCols = [];
            var monthCols = {}; // { Month: [ {key,title}, ... ] }

            // month detection (robust)
            var monthRegex = /^(January|February|March|April|May|June|July|August|September|October|November|December)/i;

            $.each(sampleRow, function (key) {

                var match = key.match(monthRegex);

                if (!match) {
                    // static column
                    staticCols.push({ key: key, title: key });
                } else {
                    var month = match[0];
                    var metric = key.replace(month, '').trim();

                    if (!monthCols[month]) {
                        monthCols[month] = [];
                    }

                    monthCols[month].push({
                        key: key,
                        title: metric || key
                    });
                }
            });

            // ===============================
            // STEP 2: Financial year ordering
            // ===============================

            var fyOrder = [
                "January", 
                "February",
                "March",
                "April",
                "May",
                "June",
                "July",
                "August",
                "September",
                "October",
                "November",
                "December"
              
            ];

            var months = Object.keys(monthCols).sort(function (a, b) {
                return fyOrder.indexOf(a) - fyOrder.indexOf(b);
            });

            // ===============================
            // STEP 3: Build THEAD (2 rows)
            // ===============================

            var topRow = "<tr>";
            var secondRow = "<tr>";

            // static columns
            staticCols.forEach(function (c) {
                topRow += `<th rowspan="2">${c.title}</th>`;
            });

            // month columns
            months.forEach(function (m, mi) {

                const monthClass = 'month-group-' + mi;

                topRow += `<th colspan="${monthCols[m].length}" class="${monthClass} month-group-end">${m}</th>`;

                monthCols[m].forEach(function (c, ci) {
                    let extraClass = monthClass;

                    // add right border on last column of month
                    if (ci === monthCols[m].length - 1) {
                        extraClass += ' month-end';
                    }

                    secondRow += `<th class="${extraClass}">${c.title}</th>`;
                });
            });

            topRow += "</tr>";
            secondRow += "</tr>";

            $('#cploansum_table thead').html(topRow + secondRow);

            // ===============================
            // STEP 4: Build DataTable columns[]
            // ===============================

            var columns = [];

            // 1️⃣ Static columns (NO month class)
            staticCols.forEach(function (c) {
                columns.push({
                    data: c.key
                });
            });

            // 2️⃣ Month columns (apply month classes correctly)
            months.forEach(function (m, mi) {

                const monthClass = 'month-group-' + mi;

                monthCols[m].forEach(function (c, ci) {

                    let cellClass = monthClass;

                    // add right border on last column of month
                    if (ci === monthCols[m].length - 1) {
                        cellClass += ' month-end';
                    }

                    columns.push({
                        data: c.key,
                        className: cellClass
                    });
                });
            });

            // ===============================
            // STEP 5: Initialize DataTable
            // ===============================
            $('#cploansum_table').DataTable({
                dom: 'lBftip',
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                filter: true,
                'select': {
                    'style': 'single'
                },
                "serverSide": false,
                "data": dataArray,
                columns: columns,
                fixedColumns: {
                    leftColumns: staticCols.length
                },
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                    $(nRow).children("td").css("text-align", "center");
                },

                initComplete: function () {
                    $('#load1').hide();
                },
                buttons: [
                    {
                        extend: 'excelHtml5',
                        text: 'Export to Excel',
                        filename: 'Summary Report',
                        exportOptions: {
                            columns: ':visible',
                            modifier: { header: false }
                        },
                        customize: function (xlsx) {
                            const sheetDoc = xlsx.xl.worksheets['sheet1.xml'];
                            const worksheet = sheetDoc.documentElement;
                            const sheetData = worksheet.getElementsByTagName('sheetData')[0];
                            const $worksheet = $(worksheet);

                            // Remove all existing rows (clean slate)
                            $worksheet.find('row').remove();

                            // Remove existing mergeCells if any
                            $worksheet.find('mergeCells').remove();

                            function colLetter(n) {
                                let s = '', t;
                                while (n > 0) {
                                    t = (n - 1) % 26;
                                    s = String.fromCharCode(65 + t) + s;
                                    n = Math.floor((n - 1) / 26);
                                }
                                return s;
                            }

                            const occupied = {};
                            const mergeRanges = [];

                            const stylesDoc = xlsx.xl['styles.xml'];
                            const fonts = stylesDoc.getElementsByTagName('fonts')[0];
                            const borders = stylesDoc.getElementsByTagName('borders')[0];
                            const cellXfs = stylesDoc.getElementsByTagName('cellXfs')[0];

                            // --- Create bold font for header
                            const headerFont = stylesDoc.createElement('font');
                            const bold = stylesDoc.createElement('b');
                            const color = stylesDoc.createElement('color');
                            color.setAttribute('rgb', 'FF000000'); // black
                            headerFont.appendChild(bold);
                            headerFont.appendChild(color);
                            fonts.appendChild(headerFont);

                            const globalFont = stylesDoc.createElement('font');

                            const globalFontName = stylesDoc.createElement('name');
                            globalFontName.setAttribute('val', 'biome');
                            headerFont.appendChild(globalFontName);

                            const globalFontSize = stylesDoc.createElement('sz');
                            globalFontSize.setAttribute('val', '8');
                            headerFont.appendChild(globalFontSize);

                            fonts.appendChild(headerFont);

                            const headerFontId = fonts.childNodes.length - 1;
                            fonts.setAttribute('count', fonts.childNodes.length.toString());

                            // --- Create border for all cells
                            const border = stylesDoc.createElement('border');
                            ['left', 'right', 'top', 'bottom'].forEach(side => {
                                const sideElem = stylesDoc.createElement(side);
                                sideElem.setAttribute('style', 'thin');
                                const colorElem = stylesDoc.createElement('color');
                                colorElem.setAttribute('auto', '1');
                                sideElem.appendChild(colorElem);
                                border.appendChild(sideElem);
                            });

                            borders.appendChild(border);
                            const borderId = borders.childNodes.length - 1;
                            borders.setAttribute('count', borders.childNodes.length.toString());

                            // add header color
                            const fills = stylesDoc.getElementsByTagName('fills')[0];
                            const headerFill = stylesDoc.createElement('fill');
                            const patternFill = stylesDoc.createElement('patternFill');
                            patternFill.setAttribute('patternType', 'solid');

                            const fgColor = stylesDoc.createElement('fgColor');
                            fgColor.setAttribute('rgb', 'ffe2efda'); // Yellow fill (ARGB format)

                            const bgColor = stylesDoc.createElement('bgColor');
                            bgColor.setAttribute('indexed', '64');

                            patternFill.appendChild(fgColor);
                            patternFill.appendChild(bgColor);

                            headerFill.appendChild(patternFill);
                            fills.appendChild(headerFill);

                            const headerFillId = fills.childNodes.length - 1;
                            fills.setAttribute('count', fills.childNodes.length.toString());

                            const headerStyle = stylesDoc.createElement('xf');
                            headerStyle.setAttribute('numFmtId', '0');
                            headerStyle.setAttribute('fontId', headerFontId.toString());
                            headerStyle.setAttribute('applyFont', '1');
                            headerStyle.setAttribute('fillId', headerFillId.toString());
                            headerStyle.setAttribute('applyFill', '1');
                            headerStyle.setAttribute('xfId', '0');
                            headerStyle.setAttribute('applyFont', '1');
                            headerStyle.setAttribute('borderId', borderId.toString());
                            headerStyle.setAttribute('applyBorder', '1');
                            headerStyle.setAttribute('applyAlignment', '1');

                            // Add alignment child
                            const alignment = stylesDoc.createElement('alignment');
                            alignment.setAttribute('horizontal', 'center');
                            alignment.setAttribute('vertical', 'center');
                            alignment.setAttribute('wrapText', '1');
                            headerStyle.appendChild(alignment);

                            cellXfs.appendChild(headerStyle);

                            // Append the new xf
                            //cellXfs.appendChild(headerAlignXf);
                            const headerStyleIndex = cellXfs.childNodes.length - 1;
                            cellXfs.setAttribute('count', cellXfs.childNodes.length.toString());

                            // Start rowIndex at 1 to insert headers at the top
                            let rowIndex = 1;

                            // 1. Add header rows from thead
                            $('#cploansum_table thead tr').each(function () {
                                let colIndex = 1;
                                const trElm = sheetDoc.createElement('row');
                                trElm.setAttribute('r', rowIndex);

                                $(this).children('th, td').each(function () {
                                    const $cell = $(this);
                                    const colspan = parseInt($cell.attr('colspan')) || 1;
                                    const rowspan = parseInt($cell.attr('rowspan')) || 1;

                                    while (occupied[rowIndex + '-' + colIndex]) {
                                        colIndex++;
                                    }

                                    const startCol = colIndex;
                                    const endCol = colIndex + colspan - 1;
                                    const endRow = rowIndex + rowspan - 1;

                                    const cellRef = colLetter(startCol) + rowIndex;
                                    const c = sheetDoc.createElement('c');
                                    c.setAttribute('r', cellRef);
                                    c.setAttribute('t', 'str');
                                    //if (colIndex > 2)
                                    c.setAttribute('s', headerStyleIndex.toString());

                                    const v = sheetDoc.createElement('v');
                                    let cellText = $cell.text().trim().replace(/\s+/g, ' ');
                                    if (!cellText) cellText = ' ';
                                    v.textContent = cellText;
                                    c.appendChild(v);
                                    trElm.appendChild(c);

                                    for (let rr = rowIndex; rr <= endRow; rr++) {
                                        for (let cc = startCol; cc <= endCol; cc++) {
                                            occupied[rr + '-' + cc] = true;
                                        }
                                    }

                                    //if (colspan > 1 || rowspan > 1) {
                                    //    mergeRanges.push(colLetter(startCol) + rowIndex + ':' + colLetter(endCol) + endRow);
                                    //}
                                    if (colspan > 1 || rowspan > 1) {
                                        mergeRanges.push(colLetter(startCol) + rowIndex + ':' + colLetter(endCol) + endRow);

                                        // --- ADD DUMMY CELLS INSIDE MERGED RANGE TO FIX BORDER ---
                                        for (let cc = startCol + 1; cc <= endCol; cc++) {
                                            const cellRef2 = colLetter(cc) + rowIndex;
                                            const c2 = sheetDoc.createElement('c');
                                            c2.setAttribute('r', cellRef2);
                                            c2.setAttribute('s', headerStyleIndex.toString()); // apply header border + color

                                            const v2 = sheetDoc.createElement('v');
                                            v2.textContent = ""; // empty cell
                                            c2.appendChild(v2);

                                            trElm.appendChild(c2);
                                        }
                                    }

                                    colIndex += colspan;
                                });

                                sheetData.appendChild(trElm);
                                rowIndex++;
                            });

                            // Create global font (e.g., Calibri 11)

                            const globalFont1 = stylesDoc.createElement('font');

                            const globalFontName1 = stylesDoc.createElement('name');
                            globalFontName1.setAttribute('val', 'biome');
                            globalFont1.appendChild(globalFontName1);

                            const globalFontSize1 = stylesDoc.createElement('sz');
                            globalFontSize1.setAttribute('val', '8');
                            globalFont1.appendChild(globalFontSize1);
                            fonts.appendChild(globalFont1);

                            const globalFontId = fonts.childNodes.length - 1;
                            fonts.setAttribute('count', fonts.childNodes.length.toString());



                            const dataStyle = stylesDoc.createElement('xf');
                            dataStyle.setAttribute('numFmtId', '0');
                            dataStyle.setAttribute('fontId', globalFontId.toString());
                            dataStyle.setAttribute('applyFont', '1');
                            dataStyle.setAttribute('fillId', '0');
                            dataStyle.setAttribute('xfId', '0');
                            dataStyle.setAttribute('borderId', borderId.toString());
                            dataStyle.setAttribute('applyBorder', '1');
                            dataStyle.setAttribute('applyAlignment', '1');

                            const dataAlignment = stylesDoc.createElement('alignment');
                            dataAlignment.setAttribute('horizontal', 'center');
                            dataAlignment.setAttribute('vertical', 'center');
                            dataAlignment.setAttribute('wrapText', '1');
                            dataStyle.appendChild(dataAlignment);

                            cellXfs.appendChild(dataStyle);
                            const centerStyleIndex = cellXfs.childNodes.length - 1;
                            cellXfs.setAttribute('count', cellXfs.childNodes.length.toString());


                            // 2. Add data rows from tbody
                            $('#cploansum_table tbody tr').each(function () {
                                let colIndex = 1;
                                const trElm = sheetDoc.createElement('row');
                                trElm.setAttribute('r', rowIndex);

                                $(this).children('td').each(function () {
                                    const $cell = $(this);
                                    const colspan = parseInt($cell.attr('colspan')) || 1;
                                    const rowspan = parseInt($cell.attr('rowspan')) || 1;

                                    while (occupied[rowIndex + '-' + colIndex]) {
                                        colIndex++;
                                    }

                                    const startCol = colIndex;
                                    const endCol = colIndex + colspan - 1;
                                    const endRow = rowIndex + rowspan - 1;

                                    const cellRef = colLetter(startCol) + rowIndex;
                                    const c = sheetDoc.createElement('c');
                                    c.setAttribute('r', cellRef);
                                    c.setAttribute('t', 'str');
                                    //if (colIndex > 2)
                                    c.setAttribute('s', centerStyleIndex.toString());

                                    const v = sheetDoc.createElement('v');
                                    let cellText = $cell.text().trim().replace(/\s+/g, ' ');
                                    if (!cellText) cellText = ' ';
                                    v.textContent = cellText;
                                    c.appendChild(v);
                                    trElm.appendChild(c);

                                    for (let rr = rowIndex; rr <= endRow; rr++) {
                                        for (let cc = startCol; cc <= endCol; cc++) {
                                            occupied[rr + '-' + cc] = true;
                                        }
                                    }

                                    if (colspan > 1 || rowspan > 1) {
                                        mergeRanges.push(colLetter(startCol) + rowIndex + ':' + colLetter(endCol) + endRow);
                                    }

                                    colIndex += colspan;
                                });

                                sheetData.appendChild(trElm);
                                rowIndex++;
                            });

                            // Add mergeCells element if any merges needed
                            if (mergeRanges.length > 0) {
                                const mergeCells = sheetDoc.createElement('mergeCells');
                                mergeCells.setAttribute('count', mergeRanges.length);

                                mergeRanges.forEach(range => {
                                    const mergeCell = sheetDoc.createElement('mergeCell');
                                    mergeCell.setAttribute('ref', range);
                                    mergeCells.appendChild(mergeCell);
                                });

                                if (sheetData.nextSibling) {
                                    worksheet.insertBefore(mergeCells, sheetData.nextSibling);
                                } else {
                                    worksheet.appendChild(mergeCells);
                                }
                            }


                        }
                    }

                ]

,
            });

        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });


    return false;
}



