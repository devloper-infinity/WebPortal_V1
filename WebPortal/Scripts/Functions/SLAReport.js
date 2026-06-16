

/* ------------------- SLA Timeline ------------------- */


function sla_bindYears() {

    let currentYear = new Date().getFullYear();
    let ddl = $('#sla_Year');

    ddl.empty();
    ddl.append('<option value="">Select Year</option>');

    for (let i = currentYear; i >= currentYear - 5; i--) {
        ddl.append('<option value="' + i + '">' + i + '</option>');
    }

    // auto-select current year
    ddl.val(currentYear);
}


function sla_Project(empID) {

    $.ajax({
        type: "POST",
        url: "DailyProductivity.aspx/GetProjects",
        dataType: "json",
        data: JSON.stringify({ EmpID: empID }),
        contentType: "application/json; charset=utf-8",

        success: function (res) {

            var ddl = $("#sla_Project");

            ddl.empty(); // clear first

            // ✅ Add default option at index 0
            ddl.append('<option value="">-- Select Project --</option>');

            // ✅ Bind data
            $.each(res.d, function (i, item) {
                ddl.append(
                    $("<option></option>").val(item.ProjectID).text(item.ProjectName)
                );
            });
        },
        error: function (err) {
            console.log(err);
        }
    });

}


function sla_save() {

    let Project = $("#sla_Project").val();
    let Process = $("#sla_DealNo").val();
    let Timeline = $("#sla_Timeline").val();
    let TimelineType = $("#sla_TimelineType").val();

    // Validation
    if (Project == "") {
        Swal.fire({
            icon: 'warning',
            title: 'Validation',
            text: 'Please select Project'
        });
        return;
    }

    if (Process == "") {
        Swal.fire({
            icon: 'warning',
            title: 'Validation',
            text: 'Please select Process'
        });
        return;
    }

    if (Timeline == "") {
        Swal.fire({
            icon: 'warning',
            title: 'Validation',
            text: 'Please enter Timeline'
        });
        return;
    }

    if (TimelineType == "") {
        Swal.fire({
            icon: 'warning',
            title: 'Validation',
            text: 'Please select Timeline Type'
        });
        return;
    }

    // Loader Button
    $("#sla_btnSubmit").prop("disabled", true);
    $("#sla_btnSubmit .btn-text").addClass("d-none");
    $("#sla_btnSubmit .btn-loader").removeClass("d-none").html('<span class="spinner-border spinner-border-sm"></span> Saving...');

    $.ajax({
        type: "POST",
        url: "SLATimeline.aspx/InsertSLATimeline",
        data: JSON.stringify({
            Project: parseInt(Project),
            Process: Process,
            Timeline: Timeline,
            TimelineType: TimelineType
        }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        success: function (response) {

            // Reset Button
            $("#sla_btnSubmit").prop("disabled", false);
            $("#sla_btnSubmit .btn-text").removeClass("d-none");
            $("#sla_btnSubmit .btn-loader").addClass("d-none");

            if (response.d > 0) {

                Swal.fire({
                    icon: 'success',
                    title: 'Success',
                    text: 'SLA Timeline Saved Successfully',
                }).then(function () {

                    slarTimeline_bindgrid();

                    // Clear Fields
                    $("#sla_Project").val('');
                    $("#sla_DealNo").val('');
                    $("#sla_Timeline").val('');
                    $("#sla_TimelineType").val('');
                });
            }
            else {

                Swal.fire({
                    icon: 'error',
                    title: 'Failed',
                    text: 'Unable to save SLA Timeline'
                });
            }
        },

        error: function (xhr, status, error) {

            // Reset Button
            $("#sla_btnSubmit").prop("disabled", false);
            $("#sla_btnSubmit .btn-text").removeClass("d-none");
            $("#sla_btnSubmit .btn-loader").addClass("d-none");

            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'Something went wrong while saving data'
            });

            console.log(error);
        }
    });

    return false;
}


function slarTimeline_bindgrid() {

    $('#load1').show();

    if ($.fn.DataTable.isDataTable('#table_slaTimeline')) {
        $('#table_slaTimeline').DataTable().clear().destroy();
    }

    $('#table_slaTimeline').DataTable({

        dom: 'Bfrtip',

        ajax: {
            url: "SLATimeline.aspx/GetAllSLATimeline",
            type: "POST",
            contentType: "application/json; charset=utf-8",

            dataSrc: function (response) {

                console.log(response);

                if (!response || !response.d) {
                    return [];
                }

                try {
                    return JSON.parse(response.d);
                }
                catch (e) {
                    console.error("JSON Parse Error:", e);
                    return [];
                }
            }
        },

        columns: [
            {
                data: null,
                title: 'Sr. #',
                className: 'text-center',
                render: function (d, t, r, m) {
                    return m.row + 1;
                }
            },
            { data: 'ProjectName', title: 'Project' },
            { data: 'DealNo', title: 'Deal #' },
            { data: 'Process', title: 'Process' },
            { data: 'SLA', title: 'Timeline' },
            { data: 'AddedByName', title: 'Added By' },
            { data: 'AddedDate', title: 'Added Date' }
        ],
        buttons: [
            {
                extend: 'excelHtml5',
                text: 'Export Excel',
                title: 'SLA Timeline',
                className: 'btn btn-success'
            }
        ],
        initComplete: function () {
            $('#load1').hide();
        }
    });
}


/* ------------------- SLA Report ------------------- */

function loadSLAReport() {

    let fromDate = $('#slareport_fromDate').val();
    let toDate = $('#slareport_toDate').val();

    if (!fromDate || !toDate) {
        alert("Please select From Date and To Date");
        return;
    }

    if (new Date(fromDate) > new Date(toDate)) {
        alert("From Date cannot be greater than To Date");
        return;
    }

    slareport_bindgrid(fromDate, toDate);
}

function slareport_bindgrid(fromDate, toDate) {

    $('#load1').show();

    if ($.fn.DataTable.isDataTable('#table_slareport')) {
        $('#table_slareport').DataTable().clear().destroy();
        /* $('#table_slareport').empty();*/
    }

    $('#table_slareport').DataTable({

        dom: 'frtip', // ✅ FIXED

        ajax: {
            url: "SLAReport.aspx/GetSLAReport",
            type: "POST",
            contentType: "application/json; charset=utf-8",
            data: function () {
                return JSON.stringify({ FromDate: fromDate, ToDate: toDate });
            },
            dataSrc: function (response) {

                return typeof response.d === "string" ? JSON.parse(response.d) : response.d;
            }
        },


        columns: [
            { data: null, render: (d, t, r, m) => m.row + 1 },
            { data: 'DealNo' },
            { data: 'LoanNo' },
            { data: 'UniqueLoanNo' },
            { data: 'OrderDate', render: data => data ? data.replace('T', ' ') : '' },
            { data: 'DueDate', render: data => data ? data.replace('T', ' ') : '' },
            { data: 'ElapsTime' },

            { data: r => r["Loan Setup"] },
            { data: r => r["Loan Setup Start Date"] },
            { data: r => r["Loan Setup End Date"] },
            { data: r => r["Loan Setup TAT"] },

            { data: 'Credit' },
            { data: r => r["Credit Start Date"] },
            { data: r => r["Credit End Date"] },
            { data: r => r["Credit TAT"] },

            { data: 'ComplianceReview' },
            { data: r => r["ComplianceReview Start Date"] },
            { data: r => r["ComplianceReview End Date"] },
            { data: r => r["ComplianceReview TAT"] },

            { data: r => r["Compliance QC"] },
            { data: r => r["Compliance QC Start Date"] },
            { data: r => r["Compliance QC End Date"] },
            { data: r => r["Compliance QC TAT"] },

            { data: 'AddedDate' },
            { data: 'TotalTAT_Format' },
            { data: 'OrderTAT_BusinessDays' }
        ],

        initComplete: function () {
            $('#load1').hide();
        },

        // 🔴 Highlight row 
        rowCallback: function (row, data) {

            let elaps = (data.ElapsTime || '').toLowerCase();

            // extract number
            let match = elaps.match(/\d+/);
            let hrs = match ? parseInt(match[0], 10) : null;

            // ignore "sent to client"
            if (!elaps.includes('sent to client')) {

                if (elaps.includes('left') && hrs !== null) {

                    if (hrs < 13) {
                        $(row).addClass('row-left');
                        $('td:eq(6)', row).css('font-weight', 'bold');
                    }
                    else
                        $('td:eq(6)', row).css('font-weight', 'bold');
                }
                else if (elaps.includes('overdue')) {
                    $(row).addClass('row-overdue');
                }
            }
        }
    });
}


/* ------------------- HR Report ------------------- */

function NewChanges_report_bindgrid() {

    $('#load1').show();

    if ($.fn.DataTable.isDataTable('#table_hrReport')) {
        $('#table_hrReport').DataTable().clear().destroy();
    }

    $('#table_hrReport').DataTable({

        dom: 'frtip',
        paging: false,
        searching: false,
        ordering: false,
        info: false,
        autoWidth: false,

        ajax: {
            url: "Report1.aspx/DomainWiseEmployeeCount",
            type: "POST",
            contentType: "application/json; charset=utf-8",
            dataType: "json",

            dataSrc: function (response) {

                let data = typeof response.d === "string"
                    ? JSON.parse(response.d)
                    : response.d;

                let groupedData = {};
                let domainTotals = {};

                // Group by Domain + SubDomain
                data.forEach(function (item) {

                    let key = item.DomainName + '_' + item.SubDomain;

                    // SubDomain Wise Data
                    if (!groupedData[key]) {

                        groupedData[key] = {
                            DomainName: item.DomainName,
                            SubDomain: item.SubDomain,
                            DayCount: 0,
                            NightCount: 0,
                            GrandTotal: 0,
                            TenureLessThan1Year: 0,
                            TenureAbove1Year: 0
                        };
                    }

                    groupedData[key].DayCount += parseInt(item.DayCount || 0);
                    groupedData[key].NightCount += parseInt(item.NightCount || 0);

                    groupedData[key].TenureLessThan1Year += parseInt(item.TenureLessThan1Year || 0);
                    groupedData[key].TenureAbove1Year += parseInt(item.TenureAbove1Year || 0);

                    // Domain Wise Grand Total
                    if (!domainTotals[item.DomainName]) {
                        domainTotals[item.DomainName] = 0;
                    }

                    domainTotals[item.DomainName] +=
                        parseInt(item.DayCount || 0) +
                        parseInt(item.NightCount || 0);
                });

                // Assign Domain Wise Grand Total
                Object.keys(groupedData).forEach(function (key) {

                    let domain = groupedData[key].DomainName;

                    groupedData[key].GrandTotal = domainTotals[domain];
                });

                return Object.values(groupedData);
            }
        },

        columns: [
            {
                data: 'DomainName',
                className: 'domain-col'
            },
            {
                data: 'SubDomain'
            },
            {
                data: 'DayCount',
                className: 'text-center'
            },
            {
                data: 'NightCount',
                className: 'text-center'
            },
            {
                data: 'GrandTotal',
                className: 'text-center'
            },
            {
                data: 'TenureLessThan1Year',
                className: 'text-center'
            },
            {
                data: 'TenureAbove1Year',
                className: 'text-center'
            }
        ],

        // FOOTER TOTAL
        footerCallback: function (row, data, start, end, display) {

            let api = this.api();

            // Sum function
            let intVal = function (i) {
                return typeof i === 'string' ? i.replace(/[\$,]/g, '') * 1 : typeof i === 'number' ? i : 0;
            };

            // Calculate totals
            let totalDay = api.column(2).data().reduce((a, b) => intVal(a) + intVal(b), 0);
            let totalNight = api.column(3).data().reduce((a, b) => intVal(a) + intVal(b), 0);
            let totalGrand = api.column(4).data().reduce((a, b) => intVal(a) + intVal(b), 0);
            let totalBelow1 = api.column(5).data().reduce((a, b) => intVal(a) + intVal(b), 0);
            let totalAbove1 = api.column(6).data().reduce((a, b) => intVal(a) + intVal(b), 0);

            // Bind footer values
            $(api.column(0).footer()).html('<b>Total</b>');
            $(api.column(1).footer()).html('');

            $(api.column(2).footer()).html('<b>' + totalDay + '</b>');
            $(api.column(3).footer()).html('<b>' + totalNight + '</b>');
            $(api.column(4).footer()).html('<b>' + totalGrand + '</b>');
            $(api.column(5).footer()).html('<b>' + totalBelow1 + '</b>');
            $(api.column(6).footer()).html('<b>' + totalAbove1 + '</b>');
        },

        drawCallback: function () {

            let api = this.api();
            let rows = api.rows({ page: 'current' }).nodes();

            let lastDomain = null;
            let rowspan = 1;
            let firstRow = null;

            api.column(0, { page: 'current' }).data().each(function (domain, i) {

                let currentRow = rows[i];

                if (lastDomain === domain) {

                    rowspan++;

                    // Hide duplicate Domain
                    $('td:eq(0)', currentRow).hide();

                    // Hide duplicate Grand Total
                    $('td:eq(4)', currentRow).hide();

                    // Update rowspan
                    $('td:eq(0)', firstRow).attr('rowspan', rowspan);
                    $('td:eq(4)', firstRow).attr('rowspan', rowspan);

                } else {

                    lastDomain = domain;
                    rowspan = 1;
                    firstRow = currentRow;
                }
            });
        },

        initComplete: function () {
            $('#load1').hide();
        }
    });
}

function core_report_bindgrid() {

    $('#load1').show();

    if ($.fn.DataTable.isDataTable('#table_hrReport')) {
        $('#table_hrReport').DataTable().clear().destroy();
        /* $('#table_slareport').empty();*/
    }

    $('#table_hrReport').DataTable({

        dom: 'frtip', // ✅ FIXED
        paging: false,

        ajax: {
            url: "Report1.aspx/DomainWiseEmployeeCount",
            type: "POST",
            contentType: "application/json; charset=utf-8",

            dataSrc: function (response) {

                return typeof response.d === "string" ? JSON.parse(response.d) : response.d;
            }
        },

        columns: [
            { data: null, className: 'text-center', render: (d, t, r, m) => m.row + 1 },
            { data: 'DomainName' },
            { data: 'SubDomain' },
            { data: 'BranchName' },
            { data: 'Segment' },
            { data: 'DayCount' },
            { data: 'NightCount' },
            { data: 'GrandTotal' },
            { data: 'TenureLessThan1Year' },
            { data: 'TenureAbove1Year' }
        ],

        initComplete: function () {
            $('#load1').hide();
        },
    });
}

function c1_report_bindgrid() {

    $('#load1').show();

    if ($.fn.DataTable.isDataTable('#table_hrReport')) {
        $('#table_hrReport').DataTable().clear().destroy();
    }

    var table = $('#table_hrReport').DataTable({

        dom: 'frtip',
        paging: false,
        autoWidth: false,
        //scrollX: true,
        //scrollCollapse: true,
        //fixedHeader: true,

        ajax: {
            url: "Report1.aspx/DomainWiseEmployeeCount",
            type: "POST",
            contentType: "application/json; charset=utf-8",

            dataSrc: function (response) {

                return typeof response.d === "string" ? JSON.parse(response.d) : response.d;
            }
        },

        columns: [

            { data: null, className: 'text-center', render: function (data, type, row, meta) { return meta.row + 1; } },
            { data: 'DomainName', className: 'text-center fw-bold', render: function (data) { return '<span style="display:block;padding:4px 8px;">' + data + '</span>'; } },
            { data: 'SubDomain' },
            { data: 'BranchName' },
            { data: 'Segment' },
            { data: 'DayCount', className: 'text-center', render: function (data) { return data || 0; } },
            { data: 'NightCount', className: 'text-center', render: function (data) { return data || 0; } },
            { data: 'GrandTotal', className: 'text-center fw-bold', render: function (data) { return data || 0; } },
            { data: 'TenureLessThan1Year', className: 'text-center', render: function (data) { return data || 0; } },
            { data: 'TenureAbove1Year', className: 'text-center', render: function (data) { return data || 0; } }
        ],

        order: [[1, 'asc']],

        drawCallback: function () {

            var api = this.api();
            var rows = api.rows({ page: 'current' }).nodes();
            var data = api.rows({ page: 'current' }).data();

            var last = null;

            api.column(1, { page: 'current' }).data().each(function (group, i) {

                // TAG ROWS
                $(rows).eq(i).attr('data-domain', group);

                // NEW GROUP
                if (last !== group) {

                    let totalDay = 0;
                    let totalNight = 0;
                    let totalGrand = 0;
                    let totalBelow = 0;
                    let totalAbove = 0;

                    data.each(function (row) {

                        if (row.DomainName === group) {

                            totalDay += parseInt(row.DayCount || 0);
                            totalNight += parseInt(row.NightCount || 0);
                            totalGrand += parseInt(row.GrandTotal || 0);
                            totalBelow += parseInt(row.TenureLessThan1Year || 0);
                            totalAbove += parseInt(row.TenureAbove1Year || 0);
                        }
                    });

                    // GROUP HEADER
                    $(rows).eq(i).before(

                        '<tr class="group-row" data-name="' + group + '" style="cursor:pointer;background:#cdebfa;">' +
                        '<td colspan="5" style="font-weight:bold;">' + '<span class="toggle-icon">▶</span> DOMAIN : ' + group + '</td>' +
                        '<td style="text-align:center;font-weight:bold;background:#cfe2ff;">' + totalDay + '</td>' +
                        '<td style="text-align:center;font-weight:bold;background:#cfe2ff;">' + totalNight + '</td>' +
                        '<td style="text-align:center;font-weight:bold;background:#fff3cd;">' + totalGrand + '</td>' +
                        '<td style="text-align:center;font-weight:bold;background:#cfe2ff;">' + totalBelow + '</td>' +
                        '<td style="text-align:center;font-weight:bold;background:#cfe2ff;">' + totalAbove + '</td>' +
                        '</tr>'
                    );

                    last = group;
                }
            });

            // COLLAPSE / EXPAND
            $('#table_hrReport tbody').off('click', '.group-row');

            $('#table_hrReport tbody').on('click', '.group-row', function () {

                var group = $(this).data('name');

                var childRows = $('#table_hrReport tbody tr[data-domain="' + group + '"]');

                childRows.toggle();

                var icon = $(this).find('.toggle-icon');

                if (icon.text() === '▼') {

                    icon.text('▶');

                } else {

                    icon.text('▼');
                }

                table.columns.adjust();
            });
        },

        // FOOTER TOTALS
        footerCallback: function (row, data, start, end, display) {

            var api = this.api();

            var intVal = function (i) {

                return typeof i === 'string' ? i.replace(/[\$,]/g, '') * 1 : typeof i === 'number' ? i : 0;
            };

            var totalDay = api.column(5).data().reduce(function (a, b) { return intVal(a) + intVal(b); }, 0);
            var totalNight = api.column(6).data().reduce(function (a, b) { return intVal(a) + intVal(b); }, 0);
            var totalGrand = api.column(7).data().reduce(function (a, b) { return intVal(a) + intVal(b); }, 0);
            var totalBelow = api.column(8).data().reduce(function (a, b) { return intVal(a) + intVal(b); }, 0);
            var totalAbove = api.column(9).data().reduce(function (a, b) { return intVal(a) + intVal(b); }, 0);

            // FOOTER
            $(api.column(0).footer()).html('<div style="font-weight:bold;text-align:right;">TOTAL :</div>');
            $(api.column(5).footer()).html('<div style="text-align:center;font-weight:bold;background:#cfe2ff;">' + totalDay + '</div>');
            $(api.column(6).footer()).html('<div style="text-align:center;font-weight:bold;background:#cfe2ff;">' + totalNight + '</div>');
            $(api.column(7).footer()).html('<div style="text-align:center;font-weight:bold;background:#fff3cd;">' + totalGrand + '</div>');
            $(api.column(8).footer()).html('<div style="text-align:center;font-weight:bold;background:#cfe2ff;">' + totalBelow + '</div>');
            $(api.column(9).footer()).html('<div style="text-align:center;font-weight:bold;background:#cfe2ff;">' + totalAbove + '</div>');
        },

        initComplete: function () {

            $('#load1').hide();
        }
    });
}

function domainreport_bindYear() {


    var ddlYear = $('#domainreport_year');
    ddlYear.empty();

    ddlYear.append('<option value="">Select Year</option>');

    var currentYear = new Date().getFullYear();

    for (var year = currentYear; year >= currentYear - 5; year--) {

        console.log(year); // better than alert

        ddlYear.append($('<option></option>').val(year).html(year));
    }
}

function c2_report_bindgrid(month, year) {

    $('#load1').show();

    if ($.fn.DataTable.isDataTable('#table_hrReport')) {
        $('#table_hrReport').DataTable().clear().destroy();
    }

    var table = $('#table_hrReport').DataTable({

        dom: 'frtip',
        paging: false,
        autoWidth: false,

        ajax: {
            url: "Report1.aspx/DomainWiseEmployeeCount",
            type: "POST",
            contentType: "application/json; charset=utf-8",
            data: function () {
                return JSON.stringify({ Month: month, Year: year });
            },
            dataSrc: function (response) {
                return typeof response.d === "string"
                    ? JSON.parse(response.d)
                    : response.d;
            }
        },

        columns: [

            {
                data: null,
                className: 'text-center',
                render: function (data, type, row, meta) {
                    return meta.row + 1;
                }
            },

            {
                data: 'DomainName',
                className: 'text-center fw-bold',
                render: function (data) {
                    return '<span style="display:block;padding:4px 8px;">' + data + '</span>';
                }
            },

            { data: 'SubDomain' },
            { data: 'BranchName' },
            { data: 'Segment' },

            {
                data: 'DayCount',
                className: 'text-center',
                render: function (data) {
                    return data || 0;
                }
            },

            {
                data: 'NightCount',
                className: 'text-center',
                render: function (data) {
                    return data || 0;
                }
            },

            {
                data: 'GrandTotal',
                className: 'text-center fw-bold',
                render: function (data) {
                    return data || 0;
                }
            },

            {
                data: 'TenureLessThan1Year',
                className: 'text-center',
                render: function (data) {
                    return data || 0;
                }
            },

            {
                data: 'TenureAbove1Year',
                className: 'text-center',
                render: function (data) {
                    return data || 0;
                }
            }
        ],

        order: [[1, 'asc']],

        drawCallback: function () {

            var api = this.api();
            var rows = api.rows({ page: 'current' }).nodes();
            var data = api.rows({ page: 'current' }).data();

            // REMOVE OLD GROUP ROWS
            $('#table_hrReport tbody tr.group-row').remove();

            // =========================
            // MERGE DOMAIN COLUMN
            // =========================

            var lastGroup = null;
            var rowspan = 1;
            var firstRow = null;

            api.column(1, { page: 'current' }).data().each(function (group, i) {

                var row = $(rows).eq(i);

                // TAG ROW
                row.attr('data-domain', group);

                if (lastGroup === group) {

                    rowspan++;

                    // HIDE DUPLICATE DOMAIN CELL
                    row.find('td:eq(1)').hide();

                    // APPLY ROWSPAN
                    firstRow.find('td:eq(1)').attr('rowspan', rowspan);

                }
                else {

                    lastGroup = group;
                    rowspan = 1;
                    firstRow = row;

                    row.find('td:eq(1)').show();
                }
            });

            // =========================
            // GROUP HEADER
            // =========================

            var last = null;

            api.column(1, { page: 'current' }).data().each(function (group, i) {

                if (last !== group) {

                    let totalDay = 0;
                    let totalNight = 0;
                    let totalGrand = 0;
                    let totalBelow = 0;
                    let totalAbove = 0;

                    data.each(function (row) {

                        if (row.DomainName === group) {

                            totalDay += parseInt(row.DayCount || 0);
                            totalNight += parseInt(row.NightCount || 0);
                            totalGrand += parseInt(row.GrandTotal || 0);
                            totalBelow += parseInt(row.TenureLessThan1Year || 0);
                            totalAbove += parseInt(row.TenureAbove1Year || 0);
                        }
                    });

                    $(rows).eq(i).before(

                        '<tr class="group-row" data-name="' + group + '" style="cursor:pointer;background:#cdebfa;">' +

                        '<td colspan="5" style="font-weight:bold;">' +
                        '<span class="toggle-icon">▼</span> DOMAIN : ' + group +
                        '</td>' +

                        '<td style="text-align:center;font-weight:bold;background:#cfe2ff;">' +
                        totalDay +
                        '</td>' +

                        '<td style="text-align:center;font-weight:bold;background:#cfe2ff;">' +
                        totalNight +
                        '</td>' +

                        '<td style="text-align:center;font-weight:bold;background:#fff3cd;">' +
                        totalGrand +
                        '</td>' +

                        '<td style="text-align:center;font-weight:bold;background:#cfe2ff;">' +
                        totalBelow +
                        '</td>' +

                        '<td style="text-align:center;font-weight:bold;background:#cfe2ff;">' +
                        totalAbove +
                        '</td>' +

                        '</tr>'
                    );

                    last = group;
                }
            });

            // =========================
            // COLLAPSE / EXPAND
            // =========================

            $('#table_hrReport tbody')
                .off('click', '.group-row')
                .on('click', '.group-row', function () {

                    var group = $(this).data('name');

                    var childRows = $('#table_hrReport tbody tr[data-domain="' + group + '"]');

                    childRows.toggle();

                    var icon = $(this).find('.toggle-icon');

                    if (icon.text() === '▼') {
                        icon.text('▶');
                    }
                    else {
                        icon.text('▼');
                    }

                    table.columns.adjust();
                });
        },

        // =========================
        // FOOTER TOTALS
        // =========================

        footerCallback: function (row, data, start, end, display) {

            var api = this.api();

            var intVal = function (i) {
                return typeof i === 'string'
                    ? i.replace(/[\$,]/g, '') * 1
                    : typeof i === 'number'
                        ? i
                        : 0;
            };

            var totalDay = api.column(5).data().reduce(function (a, b) {
                return intVal(a) + intVal(b);
            }, 0);

            var totalNight = api.column(6).data().reduce(function (a, b) {
                return intVal(a) + intVal(b);
            }, 0);

            var totalGrand = api.column(7).data().reduce(function (a, b) {
                return intVal(a) + intVal(b);
            }, 0);

            var totalBelow = api.column(8).data().reduce(function (a, b) {
                return intVal(a) + intVal(b);
            }, 0);

            var totalAbove = api.column(9).data().reduce(function (a, b) {
                return intVal(a) + intVal(b);
            }, 0);

            $(api.column(0).footer()).html(
                '<div style="font-weight:bold;text-align:right;">TOTAL :</div>'
            );

            $(api.column(5).footer()).html(
                '<div style="text-align:center;font-weight:bold;background:#cfe2ff;">' + totalDay + '</div>'
            );

            $(api.column(6).footer()).html(
                '<div style="text-align:center;font-weight:bold;background:#cfe2ff;">' + totalNight + '</div>'
            );

            $(api.column(7).footer()).html(
                '<div style="text-align:center;font-weight:bold;background:#fff3cd;">' + totalGrand + '</div>'
            );

            $(api.column(8).footer()).html(
                '<div style="text-align:center;font-weight:bold;background:#cfe2ff;">' + totalBelow + '</div>'
            );

            $(api.column(9).footer()).html(
                '<div style="text-align:center;font-weight:bold;background:#cfe2ff;">' + totalAbove + '</div>'
            );
        },

        initComplete: function () {
            $('#load1').hide();
        }
    });
}
