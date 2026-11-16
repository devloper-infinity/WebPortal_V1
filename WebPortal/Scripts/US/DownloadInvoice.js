//Get Invoice Data
function GetAllLogInOutDatafordownInvoice() {
    $.ajax({
        type: "POST",
        url: "DownloadInvoice.aspx/GetAllLogInOutDataForInvoice",
        data: {},
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var data = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;

            var $thead = $("#downloadinvoice_table thead tr");
            var $tbody = $("#downloadinvoice_table tbody");
            $thead.empty();
            $tbody.empty();

            if (data && data.length > 0) {
                $thead.append(`
                    <th>Employee Name</th>
                    <th>Period</th>
                    <th>Total Hours</th>
                    <th class="text-center">View</th>
                    <th class="text-center">Download</th>
                    <th class="text-center">Excel</th>
                    <th class="text-center">Approve</th>
                `);

                data.forEach(function (row) {
                    var employeeCode = (row.Code !== null && row.Code !== undefined) ? row.Code : '';
                    var pseudoName = (row.PsuedoName !== null && row.PsuedoName !== undefined) ? row.PsuedoName : '';
                    var StartDate = row.StartDate;
                    var timestamp = parseInt(StartDate.replace(/\/Date\((\d+)\)\//, '$1'));
                    var date = new Date(timestamp);
                    var formattedStartDate = (date.getMonth() + 1) + '/' + date.getDate() + '/' + date.getFullYear();

                    var EndDate = row.EndDate;
                    var timestampend = parseInt(EndDate.replace(/\/Date\((\d+)\)\//, '$1'));
                    var dateend = new Date(timestampend);
                    var formattedEndDate = (dateend.getMonth() + 1) + '/' + dateend.getDate() + '/' + dateend.getFullYear();

                    var employeeName = (row.EmployeeName !== null && row.EmployeeName !== undefined) ? row.EmployeeName : '';
                    var totalHours = (row.TotalHours !== null && row.TotalHours !== undefined) ? row.TotalHours : '';
                    var Period = (row.Period !== null && row.Period !== undefined) ? row.Period : '';


                    var tr = `<tr data-code="${employeeCode}" data-pseudoname="${pseudoName}" data-StartDate="${formattedStartDate}" data-EndDate="${formattedEndDate}">`;
                    tr += `<td class="align-middle">${employeeName}</td>`;
                    tr += `<td class="align-middle">${Period}</td>`;
                    tr += `<td class="align-middle">${totalHours}</td>`;

                    tr += `<td class="text-center align-middle"><button type="button" class="btn btn-link text-dark view-btn p-1 border-0 bg-transparent" title="View"><i class="fas fa-eye fa-lg"></i></button></td>`;
                    tr += `<td class="text-center align-middle"><button type="button" class="btn btn-link text-primary download-btn p-1 border-0 bg-transparent" title="Download"><i class="fas fa-download fa-lg"></i></button></td>`;
                    tr += `<td class="text-center align-middle"><button type="button" class="btn btn-link  text-success excel-btn p-1 border-0 bg-transparent" title="Excel"><i class="fas fa-file-excel fa-lg"></i></button></td>`;
                    tr += `<td class="text-center align-middle"><button type="button" class="btn btn-link text-primary approve-btn p-1 border-0 bg-transparent" title="Approve"><i class="fas fa-check-circle fa-lg"></i></button></td>`;
                    tr += `</tr>`;

                    $tbody.append(tr);
                });
            } else {
                $thead.append(`<th>Data</th>`);
                $tbody.append(`<tr><td colspan="7" class="text-center text-muted">No data found</td></tr>`);
            }
        },
        error: function (xhr, status, error) {
            console.error("Error: ", error);
        }
    });
}

//View Invoice
$(document).on('click', '.view-btn', function () {
    var $row = $(this).closest('tr');
    var pseudoName = $row.attr('data-pseudoname');


    var formatDate = (text) => { var d = new Date(text); return String(d.getMonth() + 1).padStart(2, '0') + '/' + String(d.getDate()).padStart(2, '0') + '/' + d.getFullYear(); };

    var StartDate = formatDate($row.attr('data-StartDate'));
    var EndDate = formatDate($row.attr('data-EndDate'));

    var employeeCode = $row.attr('data-code');
    var employeeName = $row.find('td').eq(0).text();
    var period = $row.find('td').eq(1).text();
    var hours = $row.find('td').eq(2).text();

    var numericHours = parseFloat(hours) || 0;
    var hourlyRate = 35.00;
    var calculatedTotal = numericHours * hourlyRate;
    var formattedAmount = "$" + calculatedTotal.toLocaleString('en-US', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
    });
    $("#modalPeriod").text(period);
    $("#modalHours").text(hours);
    $("#modalClientName").text("Infinity IPS");
    $("#modalEmpNameSpan").text(employeeName);
    $("#modalAmount").text(formattedAmount);
    $("#modalTotalAmount").text(formattedAmount);
    var modalEl = document.getElementById('invoiceModal');
    var invoiceViewModal = new bootstrap.Modal(modalEl);
    invoiceViewModal.show();

    var $modalTbody = $("#modalDetailedTable tbody");
    $modalTbody.html(`<tr><td colspan="5" class="text-center text-muted py-3"><i class="fas fa-spinner fa-spin"></i> Loading details...</td></tr>`);

    $.ajax({
        type: "POST",
        url: "DownloadInvoice.aspx/GetUserWiseLogInOutDataForInvoice",
        data: JSON.stringify({ Code: employeeCode, StartDate: StartDate, EndDate: EndDate }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var detailsData = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
            $modalTbody.empty();
            var totalMinutesSum = 0
            if (detailsData && detailsData.length > 0) {
                detailsData.forEach(function (item) {
                    var dateVal = item.Date ? new Date(item.Date).toLocaleDateString() : '';
                    var startTime = item["Start Time"] || '';
                    var endTime = item["End Time"] || '';
                    var breakTime = item["Break time"] !== null && item["Break time"] !== undefined ? item["Break time"] : '0';
                    var totalTime = item["Total Time"] || '';
                    if (totalTime) {
                        var parts = totalTime.toString().split(':');
                        if (parts.length === 2) {
                            totalMinutesSum += (parseInt(parts[0]) || 0) * 60 + (parseInt(parts[1]) || 0);
                        } else {
                            totalMinutesSum += parseFloat(totalTime) || 0;                        }
                    }
                    var dTr = `<tr>
                        <td>${dateVal}</td>
                        <td>${startTime}</td>
                        <td>${endTime}</td>
                        <td>${breakTime}</td>
                        <td>${totalTime}</td>
                    </tr>`;
                    $modalTbody.append(dTr);
                });

                var finalHours = Math.floor(totalMinutesSum / 60);
                var finalMinutes = totalMinutesSum % 60;
                var formattedTotalTime = String(finalHours).padStart(2, '0') + ':' + String(finalMinutes).padStart(2, '0');
                var totalTr = `<tr class="fw-bold" style="background-color: #d0d5db; color: black;">
                     <td colspan="4" style="padding: 6px; border: 0.5px solid #b4c6e7; text-align: right;"><strong>Total Hours:</strong></td>
                    <td style="padding: 6px; border: 0.5px solid #b4c6e7; text-align: center;">${formattedTotalTime}</td>
                </tr>`;
                $modalTbody.append(totalTr);
            } else {
                $modalTbody.append(`<tr><td colspan="5" class="text-center text-muted">No log details found</td></tr>`);
            }
        },
        error: function (xhr, status, error) {
            console.error("Error fetching user details: ", error);
            $modalTbody.append(`<tr><td colspan="5" class="text-center text-danger">Error loading data</td></tr>`);
        }
    });

    // ==========================================
    // 2. AJAX CALL: Get Vendor Information
    // ==========================================
    $.ajax({
        type: "POST",
        url: "DownloadInvoice.aspx/GetVendorsInformation",
        data: JSON.stringify({ EmpName: pseudoName }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var vendorData = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;

            if (vendorData && vendorData.length > 0) {
                var vendor = vendorData[0];

                $("#modalVendorName").text(vendor.VendorName || '');
                $("#modalVendorAddress").html((vendor.Address || '').replace(/\n/g, '<br>'));
                $("#modalVendorPhone").text(vendor.ContactNo || '');
                $("#modalVendorEmail").text(vendor.EmailID || '');
                $("#modalVendorEmailLink").attr("href", "mailto:" + vendor.EmailID).text(vendor.EmailID);
            } else {
                console.warn("No vendor information found for: " + pseudoName);
            }
        },
        error: function (xhr, status, error) {
            console.error("Error fetching vendor information: ", error);
        }
    });





    // ==========================================
    // 2. NAVIN AJAX CALL: Loan Production Track
    // ==========================================
    var $loanThead = $("#LoanProductionTrackTable thead");
    var $loanTbody = $("#LoanProductionTrackTable tbody");
    $loanThead.empty();
    $loanTbody.html(`<tr><td colspan="9" class="text-center text-muted py-3"><i class="fas fa-spinner fa-spin"></i> Loading production track...</td></tr>`);

    $.ajax({
        type: "POST",
        url: "DownloadInvoice.aspx/GetAllUSLoanProductionTrack",
        data: JSON.stringify({ EmpName: pseudoName, StartDate: StartDate, EndDate: EndDate }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var trackData = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
            $loanThead.empty();
            $loanTbody.empty();

            if (trackData && trackData.length > 0) {
                var headers = Object.keys(trackData[0]);
                headers.unshift("Sr.No");

                var headerHtml = "<tr>";
                headers.forEach(function (colName) {
                    headerHtml += `<th>${colName}</th>`;
                });
                headerHtml += "</tr>";
                $loanThead.append(headerHtml);

                trackData.forEach(function (row, index) {
                    var tr = "<tr>";

                    headers.forEach(function (colName, colIndex) {
                        var val = "";

                        if (colIndex === 0) {
                            val = index + 1; 
                        } else {
                            var originalColName = Object.keys(trackData[0])[colIndex - 1];
                            val = row[originalColName] !== null && row[originalColName] !== undefined ? row[originalColName] : '';

                            if (originalColName.toLowerCase().includes('datetime') && val) {
                                var parsedDate;
                                if (typeof val === 'string' && val.indexOf('/Date(') > -1) {
                                    var timestamp = parseInt(val.replace(/\/Date\((\d+)\)\//, '$1'));
                                    parsedDate = new Date(timestamp);
                                } else {
                                    parsedDate = new Date(val.replace(" ", "T"));
                                }

                                if (!isNaN(parsedDate.getTime())) {
                                    var year = parsedDate.getFullYear();
                                    var month = String(parsedDate.getMonth() + 1).padStart(2, '0');
                                    var day = String(parsedDate.getDate()).padStart(2, '0');
                                    var hours = String(parsedDate.getHours()).padStart(2, '0');
                                    var minutes = String(parsedDate.getMinutes()).padStart(2, '0');
                                    var seconds = String(parsedDate.getSeconds()).padStart(2, '0');

                                    val = `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
                                }
                            }
                        }

                        tr += `<td>${val}</td>`;
                    });
                    tr += "</tr>";
                    $loanTbody.append(tr);
                });
            } else {
                $loanThead.append(`<tr><th>Sr.No</th><th>Production Track</th></tr>`);
                $loanTbody.append(`<tr><td colspan="2" class="text-center text-muted">No production track data found</td></tr>`);
            }
        },
        error: function (xhr, status, error) {
            console.error("Error fetching loan production track: ", error);
            $loanThead.append(`<tr><th>Error</th></tr>`);
            $loanTbody.append(`<tr><td class="text-center text-danger">Error loading production data</td></tr>`);
        }
    });


    // ==========================================
    // 1.5. NAVIN AJAX CALL: Non-Productive Hours
    // ==========================================
    var $nonProdContainer = $("#tabNonProductiveContent");
    var $nonProdDivider = $("#nonProductiveDivider");
    var $nonProdTbody = $("#modalNonProductiveTable tbody");

    // Hide initially until data arrives
    $nonProdContainer.hide();
    $nonProdDivider.hide();
    $nonProdTbody.empty();

    $.ajax({
        type: "POST",
        url: "DownloadInvoice.aspx/GetAllNonProductiveHoursForInvoice",
        data: JSON.stringify({ Code: employeeCode,StartDate: StartDate, EndDate: EndDate }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var nonProdData = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;

            if (nonProdData && nonProdData.length > 0) {
                nonProdData.forEach(function (item) {
                    var entryDate = item.EntryDate; 
                    var timestamp = parseInt(entryDate.replace(/\/Date\((\d+)\)\//, '$1'));
                    var date = new Date(timestamp);
                    var formattedDate = (date.getMonth() + 1) + '/' + date.getDate() + '/' + date.getFullYear();
                    var startTime = item.StartTime || '';
                    var endTime = item.EndTime || '';
                    var totalDuration = item.TotalDuration || '';
                    var reason = item.Reason || '';

                    var npTr = `<tr>
                        <td>${formattedDate}</td>
                        <td>${startTime}</td>
                        <td>${endTime}</td>
                        <td>${totalDuration}</td>
                        <td>${reason}</td>
                    </tr>`;
                    $nonProdTbody.append(npTr);
                });

                // Show the section only if records exist
                $nonProdContainer.show();
                $nonProdDivider.show();
            }
        },
        error: function (xhr, status, error) {
            console.error("Error fetching non-productive hours: ", error);
        }
    });
});




//Close Popup
$(document).on('click', '[data-bs-dismiss="modal"]', function () {
    var modalEl = document.getElementById('invoiceModal');

    try {
        var modalInstance = bootstrap.Modal.getInstance(modalEl);
        if (modalInstance) {
            modalInstance.hide();
        } else {
            $(modalEl).modal('hide');
        }
    } catch (err) {
        $(modalEl).removeClass('show').css('display', 'none');
        $('.modal-backdrop').remove();
        $('body').removeClass('modal-open').css('overflow', '').css('padding-right', '');
    }
});

//Pdf Download
$(document).ready(function () {
    $(document).on('click', '.download-btn', function () {
        $('#load1').show();
        var $row = $(this).closest('tr');
        var employeeCode = $row.attr('data-code');
        var pseudoName = $row.attr('data-pseudoname');
        var formatDate = (text) => { var d = new Date(text); return String(d.getMonth() + 1).padStart(2, '0') + '/' + String(d.getDate()).padStart(2, '0') + '/' + d.getFullYear(); };

        var StartDate = formatDate($row.attr('data-StartDate'));
        var EndDate = formatDate($row.attr('data-EndDate'));
        var employeeName = $row.find('td').eq(0).text();
        var period = $row.find('td').eq(1).text();
        var hours = $row.find('td').eq(2).text();
        var invoiceNo = "1";
        var clientName = "Infinity IPS";
        var rate = "35.00";
        var numericHours = parseFloat(hours) || 0;
        var calculatedTotal = numericHours * rate;
     
        var totalAmountDecimal = "$" + calculatedTotal.toLocaleString('en-US', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        });

        // 1. Fetch User Log-In/Out Data
        $.ajax({
            type: "POST",
            url: "DownloadInvoice.aspx/GetUserWiseLogInOutDataForInvoice",
            data: JSON.stringify({ Code: employeeCode, StartDate: StartDate, EndDate: EndDate }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                var detailsData = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
                var tableRowsHTML = '';
                var totalMinutesSum = 0;
                if (detailsData && detailsData.length > 0) {
                    detailsData.forEach(function (item) {
                        var dateVal = item.Date ? new Date(item.Date).toLocaleDateString() : '';
                        var startTime = item["Start Time"] || '';
                        var endTime = item["End Time"] || '';
                        var breakTime = item["Break time"] !== null && item["Break time"] !== undefined ? item["Break time"] : '0';
                        var totalTime = item["Total Time"] || '';
                        if (totalTime) {
                            var parts = totalTime.toString().split(':');
                            if (parts.length === 2) {
                                totalMinutesSum += (parseInt(parts[0]) || 0) * 60 + (parseInt(parts[1]) || 0);
                            } else {
                                totalMinutesSum += parseFloat(totalTime) || 0;
                            
                            }
                        }
                        tableRowsHTML += `
                            <tr>
                                <td style="padding: 4px; border: 0.5px solid #b4c6e7; text-align: center;">${dateVal}</td>
                                <td style="padding: 4px; border: 0.5px solid #b4c6e7; text-align: center;">${startTime}</td>
                                <td style="padding: 4px; border: 0.5px solid #b4c6e7; text-align: center;">${endTime}</td>
                                <td style="padding: 4px; border: 0.5px solid #b4c6e7; text-align: center;">${breakTime}</td>
                                <td style="padding: 4px; border: 0.5px solid #b4c6e7; text-align: center;">${totalTime}</td>
                            </tr>`;
                    });

                    var finalHours = Math.floor(totalMinutesSum / 60);
                    var finalMinutes = totalMinutesSum % 60;
                    var formattedTotalTime = String(finalHours).padStart(2, '0') + ':' + String(finalMinutes).padStart(2, '0');

                    tableRowsHTML += `
                    <tr style="background-color: #f2f5f9; font-weight: bold;">
                        <td colspan="4" style="padding: 4px; border: 0.5px solid #b4c6e7; text-align: right;">Total Hours:</td>
                        <td style="padding: 4px; border: 0.5px solid #b4c6e7; text-align: center;">${formattedTotalTime}</td>
                    </tr>`;
                } else {
                    tableRowsHTML = `<tr><td colspan="5" style="padding: 8px; border: 1px solid #b4c6e7; text-align: center; color: #777;">No log details found</td></tr>`;
                }

                // 2. Fetch Non-Productive Hours Data
                $.ajax({
                    type: "POST",
                    url: "DownloadInvoice.aspx/GetAllNonProductiveHoursForInvoice",
                    data: JSON.stringify({ Code: employeeCode,StartDate: StartDate, EndDate: EndDate }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (npResponse) {
                        var nonProdData = typeof npResponse.d === 'string' ? JSON.parse(npResponse.d) : npResponse.d;
                        var nonProdSectionHTML = '';

                        if (nonProdData && nonProdData.length > 0) {
                            var npRowsHTML = '';
                            var npSrNo = 0;

                            nonProdData.forEach(function (npItem) {
                                npSrNo++;
                                var formattedDate = npItem.EntryDate;
                                var timestamp = parseInt(formattedDate.replace(/\/Date\((\d+)\)\//, '$1'));
                                var date = new Date(timestamp);
                                var entryDate = (date.getMonth() + 1) + '/' + date.getDate() + '/' + date.getFullYear();


                                var npStartTime = npItem.StartTime || '';
                                var npEndTime = npItem.EndTime || '';
                                var npDuration = npItem.TotalDuration || '';
                                var npReason = npItem.Reason || '';

                                npRowsHTML += `
                                    <tr>
                                        <td style="padding: 3px 2px; border: 0.5px solid #b4c6e7; text-align: center; font-size: 9px; width: 6%;">${npSrNo}</td>
                                        <td style="padding: 3px 2px; border: 0.5px solid #b4c6e7; text-align: center; font-size: 9px; width: 18%;">${entryDate}</td>
                                        <td style="padding: 3px 2px; border: 0.5px solid #b4c6e7; text-align: center; font-size: 9px; width: 15%;">${npStartTime}</td>
                                        <td style="padding: 3px 2px; border: 0.5px solid #b4c6e7; text-align: center; font-size: 9px; width: 15%;">${npEndTime}</td>
                                        <td style="padding: 3px 2px; border: 0.5px solid #b4c6e7; text-align: center; font-size: 9px; width: 15%;">${npDuration}</td>
                                        <td style="padding: 3px 2px; border: 0.5px solid #b4c6e7; text-align: left; font-size: 9px; width: 31%;">${npReason}</td>
                                    </tr>`;
                            });

                            nonProdSectionHTML = `
                                <div style="page-break-before: always;"></div>
                                <div style="margin-top: 20px; width: 100%;">
                                    <div style="background-color: #143961; color: white; padding: 10px; font-weight: bold; font-size: 14px; margin-bottom: 10px;">
                                        Non-Productive Hours
                                    </div>
                                    <table style="width: 100%; font-size: 9px; border-collapse: collapse; table-layout: fixed;" border="1" bordercolor="#b4c6e7">
                                        <thead style="background-color: #143961; color: white;">
                                            <tr>
                                                <th style="padding: 3px 2px; text-align: center; border: 0.5px solid #b4c6e7; font-size: 9px; width: 6%;">Sr.</th>
                                                <th style="padding: 3px 2px; text-align: center; border: 0.5px solid #b4c6e7; font-size: 9px; width: 18%;">Entry Date</th>
                                                <th style="padding: 3px 2px; text-align: center; border: 0.5px solid #b4c6e7; font-size: 9px; width: 15%;">Start Time</th>
                                                <th style="padding: 3px 2px; text-align: center; border: 0.5px solid #b4c6e7; font-size: 9px; width: 15%;">End Time</th>
                                                <th style="padding: 3px 2px; text-align: center; border: 0.5px solid #b4c6e7; font-size: 9px; width: 15%;">Duration</th>
                                                <th style="padding: 3px 2px; text-align: left; border: 0.5px solid #b4c6e7; font-size: 9px; width: 31%;">Reason</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            ${npRowsHTML}
                                        </tbody>
                                    </table>
                                </div>
                            `;
                        }

                        // 3. Fetch Loan Production Track Data
                        $.ajax({
                            type: "POST",
                            url: "DownloadInvoice.aspx/GetAllUSLoanProductionTrack",
                            data: JSON.stringify({ EmpName: pseudoName, StartDate: StartDate, EndDate: EndDate }),
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (prodResponse) {
                                var trackData = typeof prodResponse.d === 'string' ? JSON.parse(prodResponse.d) : prodResponse.d;
                                var loanProductionPagesHTML = '';
                                var serialNumber = 0;

                                if (trackData && trackData.length > 0) {
                                    var headers = Object.keys(trackData[0]);
                                    var totalCols = headers.length + 1;

                                    var dealNoWidthPercent = 18;
                                    var remainingPercent = 100 - dealNoWidthPercent;
                                    var defaultColWidth = (remainingPercent / (totalCols - 1)).toFixed(2) + "%";
                                    var dealNoWidthStr = dealNoWidthPercent + "%";

                                    var prodHeadersHTML = "<tr>";
                                    prodHeadersHTML += `<th style="padding: 3px 2px; text-align: center; border: 0.5px solid #b4c6e7; font-size: 9px; width: 6%;">Sr.</th>`;

                                    headers.forEach(function (colName) {
                                        var isDealNo = colName.toLowerCase().includes('dealno') || colName.toLowerCase().includes('deal no');
                                        var widthStyle = isDealNo ? `width: ${dealNoWidthStr};` : `width: ${defaultColWidth};`;
                                        prodHeadersHTML += `<th style="padding: 3px 2px; text-align: center; border: 0.5px solid #b4c6e7; font-size: 9px; word-break: break-word; overflow: hidden; ${widthStyle}">${colName}</th>`;
                                    });
                                    prodHeadersHTML += "</tr>";

                                    var pageSize = 25;

                                    for (var i = 0; i < trackData.length; i += pageSize) {
                                        var chunk = trackData.slice(i, i + pageSize);
                                        var prodRowsHTML = '';
                                        var batchIndex = Math.floor(i / pageSize);

                                        chunk.forEach(function (row) {
                                            serialNumber++;
                                            prodRowsHTML += "<tr>";
                                            prodRowsHTML += `<td style="padding: 3px 2px; border: 0.5px solid #b4c6e7; text-align: center; font-size: 9px; width: 6%;">${serialNumber}</td>`;

                                            headers.forEach(function (colName) {
                                                var val = row[colName] !== null && row[colName] !== undefined ? row[colName] : '';
                                                var isDealNo = colName.toLowerCase().includes('dealno') || colName.toLowerCase().includes('deal no');
                                                var widthStyle = isDealNo ? `width: ${dealNoWidthStr};` : `width: ${defaultColWidth};`;

                                                if (colName.toLowerCase().includes('datetime') && val) {
                                                    var parsedDate;
                                                    if (typeof val === 'string' && val.indexOf('/Date(') > -1) {
                                                        var timestamp = parseInt(val.replace(/\/Date\((\d+)\)\//, '$1'));
                                                        parsedDate = new Date(timestamp);
                                                    } else {
                                                        parsedDate = new Date(val.replace(" ", "T"));
                                                    }

                                                    if (!isNaN(parsedDate.getTime())) {
                                                        var year = parsedDate.getFullYear();
                                                        var month = String(parsedDate.getMonth() + 1).padStart(2, '0');
                                                        var day = String(parsedDate.getDate()).padStart(2, '0');
                                                        var hours = String(parsedDate.getHours()).padStart(2, '0');
                                                        var minutes = String(parsedDate.getMinutes()).padStart(2, '0');
                                                        var seconds = String(parsedDate.getSeconds()).padStart(2, '0');
                                                        val = `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
                                                    }
                                                }

                                                prodRowsHTML += `<td style="padding: 3px 2px; border: 0.1px solid #b4c6e7; text-align: center; font-size: 9px; word-break: break-word; overflow: hidden; ${widthStyle}">${val}</td>`;
                                            });
                                            prodRowsHTML += "</tr>";
                                        });

                                        if (batchIndex === 0) {
                                            loanProductionPagesHTML += `
                                                <div style="page-break-before: always;"></div>
                                                <div style="margin-top: 20px; width: 100%;">
                                                    <div style="background-color: #143961; color: white; padding: 10px; font-weight: bold; font-size: 14px; margin-bottom: 10px;">
                                                        Loan Production Track
                                                    </div>
                                                    <table style="width: 100%; font-size: 9px; border-collapse: collapse; table-layout: fixed;" border="1" bordercolor="#b4c6e7">
                                                        <thead style="background-color: #143961; color: white;">
                                                            ${prodHeadersHTML}
                                                        </thead>
                                                        <tbody>
                                                            ${prodRowsHTML}
                                                        </tbody>
                                                    </table>
                                                </div>
                                            `;
                                        } else {
                                            loanProductionPagesHTML += `
                                                <div style="page-break-before: always;"></div>
                                                <div style="margin-top: 20px; width: 100%;">
                                                    <table style="width: 100%; font-size: 9px; border-collapse: collapse; table-layout: fixed;" border="1" bordercolor="#b4c6e7">
                                                        <tbody>
                                                            ${prodRowsHTML}
                                                        </tbody>
                                                    </table>
                                                </div>
                                            `;
                                        }
                                    }
                                } else {
                                    loanProductionPagesHTML = `
                                        <div style="page-break-before: always;"></div>
                                        <div style="margin-top: 20px; width: 100%;">
                                            <div style="background-color: #143961; color: white; padding: 10px; font-weight: bold; font-size: 14px; margin-bottom: 10px;">
                                                Loan Production Track
                                            </div>
                                            <table style="width: 100%; font-size: 9px; border-collapse: collapse;" border="1" bordercolor="#b4c6e7">
                                                <tbody>
                                                    <tr><td style="padding: 8px; border: 1px solid #b4c6e7; text-align: center; color: #777; font-size: 10px;" colspan="8">No production track data found</td></tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    `;
                                }

                                // 4. Construct Full HTML Template
                                var elementHTML = `
                                <div style="padding: 10px; font-family: Arial, sans-serif; color: #333; background: #fff; font-size: 14px; box-sizing: border-box;">
                                    <!-- Page 1: Invoice Main -->
                                    <div style="display: flex; justify-content: space-between; margin-bottom: 30px;">
                                        <div>
                                            <h4 style="font-weight: bold; margin: 0 0 5px 0; font-size: 18px;">RJOstrom LLC</h4>
                                            <div style="font-size: 13px; line-height: 1.4; color: #444;">
                                                Robin Ostrom<br>17730 Eureka Ave W<br>Farmington, MN 55024<br>612-358-0115<br>
                                                <a href="mailto:rjostromllc@gmail.com" style="color: #0d6efd; text-decoration: none;">rjostromllc@gmail.com</a>
                                            </div>
                                        </div>
                                        <div style="text-align: right;">
                                            <h1 style="font-size: 32px; font-weight: bold; color: #5b73a7; margin: 0 0 15px 0; letter-spacing: 1px;">INVOICE</h1>
                                            <table style="width: 220px; font-size: 12px; border-collapse: collapse; margin-left: auto;" border="1" bordercolor="#b4c6e7">
                                                <thead style="background-color: #d9e1f2; font-weight: bold;">
                                                    <tr><th style="padding: 4px;">INVOICE #</th><th style="padding: 4px;">DATE</th></tr>
                                                </thead>
                                                <tbody>
                                                    <tr><td style="padding: 4px; text-align:center;">${invoiceNo}</td><td style="padding: 4px; text-align:center;">10/16/2026</td></tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>

                                    <!-- Bill To Section -->
                                    <div style="margin-bottom: 30px; width: 50%;">
                                        <table style="width: 100%; font-size: 13px; border-collapse: collapse;" border="1" bordercolor="#b4c6e7">
                                            <thead style="background-color: #d9e1f2; font-weight: bold;">
                                                <tr><th style="padding: 4px; text-align: left;">BILL TO</th></tr>
                                            </thead>
                                            <tbody>
                                                <tr><td style="padding: 8px; line-height: 1.5;"><strong>${clientName}</strong><br>1 Research Court, Suite 450<br>Rockville, MD 20850<br>Phone: (877)-463-8485</td></tr>
                                            </tbody>
                                        </table>
                                    </div>

                                    <!-- Main Items Table -->
                                    <table style="width: 100%; font-size: 13px; border-collapse: collapse; margin-bottom: 30px;" border="1" bordercolor="#b4c6e7">
                                        <thead style="background-color: #d9e1f2; font-weight: bold;">
                                            <tr>
                                                <th style="padding: 6px; text-align: left; width: 75%;">DESCRIPTION</th>
                                                <th style="padding: 6px; text-align: right; width: 25%;">AMOUNT</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td style="padding: 12px; height: 110px; vertical-align: top; line-height: 1.6;">
                                                    Hours: <strong>${hours}</strong> <span style="background-color: #ffff00; padding: 2px 4px;">Hours worked</span> hours at $${rate} hr.<br>
                                                    Period: <strong>${period}</strong><br><br>
                                                    <strong>Please provide payment within our agreed upon contract period, thank you!</strong><br>
                                                    See 1099 Tracker and Feedback Worksheets for productivity details
                                                </td>
                                                <td style="padding: 12px; text-align: right; vertical-align: top; font-weight: bold; font-size: 15px;">
                                                    ${totalAmountDecimal}
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding: 8px; text-align: left; vertical-align: middle;">
                                                    Thank you for your business!<br>
                                                    <small style="color: #555;">If you have any questions about this invoice, please contact me.</small>
                                                </td>
                                                <td style="padding: 8px; text-align: right; vertical-align: middle; font-weight: bold; font-size: 15px;">
                                                    ${totalAmountDecimal}.00
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Page 2: Daily Log-In/Out Details -->
                                    <div style="page-break-before: always;"></div>
                                    <div style="margin-top: 20px;">
                                        <div style="background-color: #143961; color: white; padding: 10px; font-weight: bold; font-size: 14px; margin-bottom: 10px;">
                                            Daily Log-In/Out (${employeeName})
                                        </div>
                                        <table style="width: 100%; font-size: 13px; border-collapse: collapse;" border="1" bordercolor="#b4c6e7">
                                            <thead style="background-color: #143961; color: white;">
                                                <tr>
                                                    <th style="padding: 8px; text-align: center;">Date</th>
                                                    <th style="padding: 8px; text-align: center;">Start Time</th>
                                                    <th style="padding: 8px; text-align: center;">End Time</th>
                                                    <th style="padding: 8px; text-align: center;">Break Time</th>
                                                    <th style="padding: 8px; text-align: center;">Total Time</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                ${tableRowsHTML}
                                            </tbody>
                                        </table>
                                    </div>

                                    <!-- Non-Productive Hours Section (Appears only if data exists) -->
                                    ${nonProdSectionHTML}

                                    <!-- Loan Production Track Pages -->
                                    ${loanProductionPagesHTML}
                                </div>
                                `;

                                var opt = {
                                    margin: 0.3,
                                    filename: 'Invoice_' + period + '_' + pseudoName + '.pdf',
                                    image: { type: 'jpeg', quality: 0.98 },
                                    html2canvas: { scale: 2, useCORS: true },
                                    jsPDF: { unit: 'in', format: 'letter', orientation: 'portrait' }
                                };

                                html2pdf().set(opt).from(elementHTML).save().then(function () {
                                    $('#load1').hide();
                                }).catch(function (err) {
                                    console.error("PDF generation error: ", err);
                                    $('#load1').hide();
                                });
                            },
                            error: function (xhr, status, error) {
                                console.error("Error fetching loan production track for PDF: ", error);
                                alert("Error generating PDF with production track data.");
                                $('#load1').hide();
                            }
                        });
                    },
                    error: function (xhr, status, error) {
                        console.error("Error fetching non-productive hours for PDF: ", error);
                        alert("Error generating PDF with non-productive hours data.");
                        $('#load1').hide();
                    }
                });
            },
            error: function (xhr, status, error) {
                console.error("Error fetching user details for PDF: ", error);
                alert("Error generating PDF with log details.");
                $('#load1').hide();
            }
        });
    });
});


//Excel Download

$(document).ready(function () {
    $(document).on('click', '.excel-btn', function () {
        var $row = $(this).closest('tr');
        var pseudoName = $row.attr('data-pseudoname');
        var employeeName = $row.find('td').eq(0).text();
        var period = $row.find('td').eq(1).text();
        var formatDate = (text) => { var d = new Date(text); return String(d.getMonth() + 1).padStart(2, '0') + '/' + String(d.getDate()).padStart(2, '0') + '/' + d.getFullYear(); };

        var StartDate = formatDate($row.attr('data-StartDate'));
        var EndDate = formatDate($row.attr('data-EndDate'));

        $.ajax({
            type: "POST",
            url: "DownloadInvoice.aspx/GetAllUSLoanProductionTrack",
            data: JSON.stringify({ EmpName: pseudoName,StartDate: StartDate, EndDate: EndDate }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                var trackData = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;

                if (trackData && trackData.length > 0) {

                    trackData.forEach(function (row) {
                        Object.keys(row).forEach(function (colName) {
                            var val = row[colName];
                            if (val) {
                                if (typeof val === 'string' && val.indexOf('/Date(') > -1) {
                                    var timestamp = parseInt(val.replace(/\/Date\((\d+)\)\//, '$1'));
                                    var d = new Date(timestamp);
                                    if (!isNaN(d.getTime())) {
                                        var yr = d.getFullYear();
                                        var mo = String(d.getMonth() + 1).padStart(2, '0');
                                        var dy = String(d.getDate()).padStart(2, '0');
                                        var hr = String(d.getHours()).padStart(2, '0');
                                        var mi = String(d.getMinutes()).padStart(2, '0');
                                        var sc = String(d.getSeconds()).padStart(2, '0');
                                        row[colName] = `${yr}-${mo}-${dy} ${hr}:${mi}:${sc}`;
                                    }
                                }
                                else if (typeof val === 'string' && val.indexOf('.') > -1 && colName.toLowerCase().includes('date')) {
                                    row[colName] = val.split('.')[0];
                                }
                            }
                        });
                    });

                    var processedData = trackData.map(function (item, index) {
                        var newRow = { "Sr. No.": index + 1 };
                        Object.keys(item).forEach(function (key) {
                            newRow[key] = item[key];
                        });
                        return newRow;
                    });

                    var worksheet = XLSX.utils.json_to_sheet(processedData);

                    var range = XLSX.utils.decode_range(worksheet['!ref']);
                    var colWidths = [];

                    for (var C = range.s.c; C <= range.e.c; ++C) {
                        var maxWidth = 12;
                        for (var R = range.s.r; R <= range.e.r; ++R) {
                            var cellAddress = XLSX.utils.encode_cell({ r: R, c: C });
                            var cell = worksheet[cellAddress];
                            if (cell && cell.v !== undefined) {
                                if (!isNaN(cell.v) && cell.v !== "" && typeof cell.v !== 'boolean') {
                                    cell.t = 'n';
                                    cell.v = Number(cell.v);
                                }
                                var cellLength = cell.v.toString().length;
                                if (cellLength > maxWidth) {
                                    maxWidth = cellLength;
                                }
                            }
                        }
                        colWidths.push({ wch: Math.min(Math.max(maxWidth + 4, 12), 45) });
                    }
                    worksheet['!cols'] = colWidths;

                    for (var R = range.s.r; R <= range.e.r; ++R) {
                        for (var C = range.s.c; C <= range.e.c; ++C) {
                            var cellAddress = XLSX.utils.encode_cell({ r: R, c: C });
                            var cell = worksheet[cellAddress];

                            if (!cell) {
                                cell = worksheet[cellAddress] = { t: 's', v: '' };
                            }

                            if (!cell.s) {
                                cell.s = {};
                            }

                            cell.s.border = {
                                top: { style: "thin", color: { rgb: "000000" } },
                                bottom: { style: "thin", color: { rgb: "000000" } },
                                left: { style: "thin", color: { rgb: "000000" } },
                                right: { style: "thin", color: { rgb: "000000" } }
                            };

                            if (R === 0) {
                                cell.s.fill = { patternType: "solid", fgColor: { rgb: "D3D3D3" } }; 
                                cell.s.font = { bold: true, color: { rgb: "000000" } };
                                cell.s.alignment = { horizontal: "center", vertical: "center", wrapText: true };
                            }
                            else {
                                if (C === 0) {
                                    cell.s.alignment = { horizontal: "center", vertical: "center" };
                                } else {
                                    cell.s.alignment = { horizontal: "left", vertical: "center" };
                                }
                            }
                        }
                    }

                    var workbook = XLSX.utils.book_new();
                    XLSX.utils.book_append_sheet(workbook, worksheet, "Loan Production Track");

                    var cleanPeriod = period.replace(/\//g, '-');
                    var fileName = "Loan_Production_Track_" + cleanPeriod + "_" + pseudoName + ".xlsx";

                    XLSX.writeFile(workbook, fileName);
                } else {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Notice',
                        text: 'No production track data found to export.',
                        confirmButtonText: 'OK'
                    });                }
            },
            error: function (xhr, status, error) {
                console.error("Error exporting excel: ", error);
                alert("Error while exporting data to Excel.");
            }
        });
    });
});