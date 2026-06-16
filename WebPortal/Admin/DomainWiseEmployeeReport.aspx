<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="DomainWiseEmployeeReport.aspx.cs" Inherits="WebPortal.Admin.DomainWiseEmployeeReport" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script src="https://cdn.datatables.net/buttons/2.4.2/js/dataTables.buttons.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.html5.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>

    <style>
        body {
            background: #f4f7fb;
        }

        .dashboard-header {
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            border-radius: 15px;
            padding: 12px;
            color: white;
            position: relative;
            overflow: hidden;
            margin-bottom: 25px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        }

            .dashboard-header::after {
                content: '';
                position: absolute;
                right: -70px;
                top: -50px;
                width: 220px;
                height: 220px;
                background: rgba(255,255,255,0.12);
                border-radius: 50%;
            }

        .dashboard-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .dashboard-subtitle {
            font-size: 12px;
            opacity: 0.9;
            /*text-transform: uppercase;*/
        }
    </style>


    <script>
        $(document).ready(function () {

            domainreport_bindYear();
            /* report_bindgrid('January', '2015');*/

        });


        function getdomainReport() {

            let month = $('#domainreport_month').val();
            let year = $('#domainreport_year').val();

            if (!month || !year) {
                alert("Please select Month and Year");
                return;
            }

            report_bindgrid(month, year);
        }

        function report_bindgrid(month, year) {

            $('#load1').show();

            if ($.fn.DataTable.isDataTable('#table_domainwiseReport')) {
                $('#table_domainwiseReport').DataTable().clear().destroy();
            }

            var table = $('#table_domainwiseReport').DataTable({

                dom: 'frtip',
                paging: false,
                autoWidth: false,
                ordering: false,


                ajax: {
                    url: "DomainWiseEmployeeReport.aspx/DomainWiseEmployeeCount",
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
                        render: function (data) { return data || 0; }
                    },

                    {
                        data: 'NightCount',
                        className: 'text-center',
                        render: function (data) { return data || 0; }
                    },

                    {
                        data: 'GrandTotal',
                        className: 'text-center fw-bold',
                        render: function (data) { return data || 0; }
                    },

                    {
                        data: 'TenureLessThan1Year',
                        className: 'text-center',
                        render: function (data) { return data || 0; }
                    },

                    {
                        data: 'TenureAbove1Year',
                        className: 'text-center',
                        render: function (data) { return data || 0; }
                    }
                ],

                order: [[1, 'asc']],

                drawCallback: function () {

                    var api = this.api();
                    var rows = api.rows({ page: 'current' }).nodes();
                    var data = api.rows({ page: 'current' }).data();

                    // 🔥 IMPORTANT: use FILTERED data
                    var filteredData = api.rows({ search: 'applied' }).data();

                    $('#table_domainwiseReport tbody tr.group-row').remove();

                    // =========================
                    // MERGE DOMAIN COLUMN
                    // =========================

                    var lastGroup = null;
                    var rowspan = 1;
                    var firstRow = null;

                    api.column(1, { page: 'current' }).data().each(function (group, i) {

                        var row = $(rows).eq(i);
                        row.attr('data-domain', group);

                        if (lastGroup === group) {

                            rowspan++;

                            row.find('td:eq(1)').hide();
                            firstRow.find('td:eq(1)').attr('rowspan', rowspan);

                        } else {

                            lastGroup = group;
                            rowspan = 1;
                            firstRow = row;

                            row.find('td:eq(1)').show();
                        }
                    });

                    // =========================
                    // GROUP HEADER (FILTER SAFE)
                    // =========================

                    var last = null;

                    api.column(1, { page: 'current' }).data().each(function (group, i) {

                        if (last !== group) {

                            let totalDay = 0;
                            let totalNight = 0;
                            let totalGrand = 0;
                            let totalBelow = 0;
                            let totalAbove = 0;

                            // ✅ FILTERED DATA USED HERE
                            filteredData.each(function (row) {

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
                                '<td colspan="5" style="font-weight:bold;">' + '<span class="toggle-icon">▼</span> DOMAIN : ' + group + '</td>' +
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

                    // =========================
                    // COLLAPSE / EXPAND
                    // =========================

                    $('#table_domainwiseReport tbody')
                        .off('click', '.group-row')
                        .on('click', '.group-row', function () {

                            var group = $(this).data('name');

                            var childRows = $('#table_domainwiseReport tbody tr[data-domain="' + group + '"]');

                            childRows.toggle();

                            var icon = $(this).find('.toggle-icon');

                            icon.text(icon.text() === '▼' ? '▶' : '▼');

                            table.columns.adjust();
                        });
                },

                // =========================
                // FOOTER TOTALS (FILTER SAFE)
                // =========================

                footerCallback: function (row, data, start, end, display) {

                    var api = this.api();

                    var intVal = function (i) { return typeof i === 'string' ? i.replace(/[\$,]/g, '') * 1 : typeof i === 'number' ? i : 0; };

                    // 🔥 FILTER APPLIED FIX
                    var totalDay = api.column(5, { search: 'applied' }).data().reduce(function (a, b) { return intVal(a) + intVal(b); }, 0);
                    var totalNight = api.column(6, { search: 'applied' }).data().reduce(function (a, b) { return intVal(a) + intVal(b); }, 0);
                    var totalGrand = api.column(7, { search: 'applied' }).data().reduce(function (a, b) { return intVal(a) + intVal(b); }, 0);
                    var totalBelow = api.column(8, { search: 'applied' }).data().reduce(function (a, b) { return intVal(a) + intVal(b); }, 0);
                    var totalAbove = api.column(9, { search: 'applied' }).data().reduce(function (a, b) { return intVal(a) + intVal(b); }, 0);

                    $(api.column(0).footer()).html('<div style="font-weight:bold;text-align:right;">TOTAL :</div>');

                    $(api.column(5).footer()).html('<div style="text-align:center;font-weight:bold;background:#cfe2ff;">' + totalDay + '</div>');
                    $(api.column(6).footer()).html('<div style="text-align:center;font-weight:bold;background:#cfe2ff;">' + totalNight + '</div>');
                    $(api.column(7).footer()).html('<div style="text-align:center;font-weight:bold;background:#fff3cd;">' + totalGrand + '</div>');
                    $(api.column(8).footer()).html('<div style="text-align:center;font-weight:bold;background:#cfe2ff;">' + totalBelow + '</div>');
                    $(api.column(9).footer()).html('<div style="text-align:center;font-weight:bold;background:#cfe2ff;">' + totalAbove + '</div>');
                },

                initComplete: function () {

                    $('#load1').hide();

                    var api = this.api();

                    // =========================================
                    // MULTI DOMAIN FILTER
                    // =========================================

                    var column = api.column(1);

                    // remove old filter if exists
                    $('#domainFilter').remove();

                    // create multi select
                    //var select = $(`<select id="domainFilter" multiple style="width:250px;margin-left:10px;"></select>`).appendTo('#table_domainwiseReport_filter');

                    var select = $(`<select id="domainFilter" multiple class="domain-filter"></select>`).appendTo('#table_domainwiseReport_filter');

                    // add options
                    column.data().unique().sort().each(function (d) {

                        if (d) {
                            select.append('<option value="' + d + '">' + d + '</option>');
                        }
                    });

                    // apply select2
                    $('#domainFilter').select2({

                        placeholder: "Filter Domain",
                        allowClear: true,
                        width: 'resolve'
                    });

                    // filter logic
                    $('#domainFilter').on('change', function () {

                        var selected = $(this).val();

                        if (selected && selected.length > 0) {

                            // regex OR condition
                            var searchTerm = selected.join('|');

                            column.search(searchTerm, true, false).draw();

                        } else {

                            column.search('').draw();
                        }
                    });
                }
            });
        }

    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="dashboard-header">
        <div class="d-flex justify-content-between align-items-start mb-1">
            <div>
                <div class="dashboard-title">
                    <i class="fas fa-briefcase mr-2"></i>
                    Domainwise Employee Report
                </div>

                <div class="dashboard-subtitle">
                    Monitor employee distribution by domain to support resource planning, utilization, and strategic decision-making.
                </div>
            </div>
        </div>
    </div>


    <div class="col-lg-12"  style="background-color:white;">
        <div class="card">

            <div class="card-body">
                <div class="row align-items-end g-4">

                    <!-- From Date -->
                    <div class="col-md-3">
                        <label class="form-label" style="color: #6c757d">Month</label>
                        <div class="input-group">
                            <select id="domainreport_month" class="form-control" style="height: 40px;">
                                <option value="">Select Month</option>
                                <option value="January">January</option>
                                <option value="February">February</option>
                                <option value="March">March</option>
                                <option value="April">April</option>
                                <option value="May">May</option>
                                <option value="June">June</option>
                                <option value="July">July</option>
                                <option value="August">August</option>
                                <option value="September">September</option>
                                <option value="October">October</option>
                                <option value="November">November</option>
                                <option value="December">December</option>
                            </select>
                        </div>
                    </div>

                    <!-- To Date -->
                    <div class="col-md-3">
                        <label class="form-label" style="color: #6c757d">Year</label>
                        <div class="input-group">
                            <select id="domainreport_year" class="form-control" style="height: 40px;"></select>
                        </div>
                    </div>

                    <!-- Get Report -->
                    <div class="col-md-3" style="height: 40px; margin-bottom: 12px;">
                        <button type="button" class="btn btn-gradient-primary w-100" onclick="getdomainReport();"><i class="bi bi-bar-chart-line"></i>Get Report</button>
                    </div>

                    <!-- Export -->
                    <div class="col-md-3" style="height: 40px; margin-bottom: 12px;">
                        <asp:Button ID="btn_exportDomainWise" Text="Export Excel" class="btn btn-gradient-success flex-grow-1" Style="background: linear-gradient(to right,  #fe7096, #ffbf96);" runat="server" OnClick="btn_exportDomainWise_Click" />
                    </div>
                </div>
            </div>

            <div class="card-body">
                <table id="table_domainwiseReport" class="table table-bordered table-striped w-100">
                    <thead>

                        <!-- level 1 -->
                        <tr>
                            <th rowspan="2" style="text-align: center; font-size: 12px;">sr #</th>
                            <th rowspan="2" style="text-align: center; font-size: 12px;">domain</th>
                            <th rowspan="2" style="text-align: center; font-size: 12px;">sub domain</th>
                            <th rowspan="2" style="text-align: center; font-size: 12px;">location</th>
                            <th rowspan="2" style="text-align: center; font-size: 12px;">segment</th>
                            <th colspan="2" style="text-align: center; font-size: 12px; background: #99caff;">working shift</th>
                            <th rowspan="2" style="text-align: center; font-size: 12px;">grand total</th>
                            <th colspan="2" style="text-align: center; font-size: 12px; background: #99caff;">employees tenure</th>
                        </tr>

                        <!-- level 2 -->
                        <tr>
                            <th style="text-align: center; font-size: 12px; background: #99caff;">day</th>
                            <th style="text-align: center; font-size: 12px; background: #99caff;">night</th>
                            <th style="text-align: center; font-size: 12px; background: #99caff;">tenure below 1 year</th>
                            <th style="text-align: center; font-size: 12px; background: #99caff;">tenure above 1 year</th>
                        </tr>
                    </thead>


                    <tbody></tbody>
                    <tfoot>
                        <tr>
                            <th colspan="5"></th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    </div>

    <style>
        /* Container feel */

        #table_domainwiseReport {
            border-collapse: separate;
            border-spacing: 0;
          /*  background: #fff;*/
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08);
            font-family: "Segoe UI", Roboto, Arial, sans-serif;
            width: 100% !important;
        }

            /* Header styling */
            #table_domainwiseReport thead {
                /*   background: linear-gradient(90deg, #4f46e5, #6366f1);*/
                /*  color: white;*/
                text-transform: uppercase !important;
            }


            /* Body cells */
            #table_domainwiseReport tbody td {
                padding: 6px 8px;
                border-bottom: 1px solid #f1f1f1;
                font-size: 12px;
                color: #333;
            }

            /* Hover effect */
            #table_domainwiseReport tbody tr {
                transition: all 0.2s ease-in-out;
            }

                #table_domainwiseReport tbody tr:hover {
                    background: #f8fafc;
                    transform: scale(1.00);
                }

                /* Zebra striping */
                #table_domainwiseReport tbody tr:nth-child(even) {
                    background: none;
                }

                /* Rounded bottom */
                #table_domainwiseReport tbody tr:last-child td {
                    border-bottom: none;
                }

        /* Optional: small badge style (for status columns etc.) */
        .badge-soft {
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
            background: #eef2ff;
            color: #4f46e5;
        }


        #table_domainwiseReport th,
        #table_domainwiseReport td {
            white-space: nowrap;
            vertical-align: middle !important;
            box-sizing: border-box;
        }

        #table_domainwiseReport thead th {
            padding: 10px 16px;
            font-weight: 600;
            text-transform: uppercase !important;
            font-size: 13px;
            letter-spacing: 0.5px;
        }

        .dataTables_scrollHeadInner,
        .dataTables_scrollHeadInner table,
        .dataTables_scrollBody table,
        .dataTables_scrollFootInner table {
            width: 100% !important;
        }

        table.dataTable {
            border-collapse: collapse !important;
        }


        .grandtotal-col {
            font-weight: bold;
            background: #eaf4df;
        }

        .domain-header {
            font-weight: bold !important;
            background-color: #cdebfa !important;
            /* color: #000 !important;*/
            padding: 8px !important;
        }

        .group-row td {
            /*  border-top: 2px solid #9ec5fe !important;
            border-bottom: 2px solid #9ec5fe !important;
            font-size: 14px;
            background-color: #cfe2ff !important;
            font-weight: bold !important;*/

            border-top: 1px solid #9ec5fe !important;
            border-bottom: 1px solid #9ec5fe !important;
            font-size: 14px;
            background-color: #cfe2ff !important;
            font-weight: bold !important;
        }

        .group-row:hover {
            opacity: 0.95;
        }

        /* .icon {
            display: inline-block;
            transition: transform 0.3s ease, opacity 0.3s ease;
        }*/

        .icon {
            display: inline-block;
            font-size: 18px;
            color: #4f46e5;
            cursor: pointer;
            transition: all 0.3s ease;
        }

            .icon:hover {
                color: #3730a3;
                transform: scale(1.15);
            }

        .btn-gradient-primary {
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            color: #fff;
            border-radius: 12px;
            height: 40px;
            font-weight: 400;
            transition: 0.3s;
        }

            .btn-gradient-primary:hover {
                transform: translateY(-2px);
                background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
                color: #fff;
            }

        .loading {
            display: none;
            position: fixed;
            top: 350px;
            left: 50%;
            margin-top: -96px;
            margin-left: -96px;
            opacity: .85;
            border-radius: 25px;
            width: 192px;
            height: 192px;
            z-index: 99999;
        }
    </style>

    <style>
        .btn-gradient-success {
            background: linear-gradient(135deg, #1cc88a, #13855c);
            color: #fff;
            border-radius: 12px;
            height: 40px;
            width: 100%;
            font-weight: 400;
            transition: 0.3s;
        }

            .btn-gradient-success:hover {
                transform: translateY(-2px);
                color: #fff;
            }

        /* Main Bands */
        .band-loan {
            background: #cce5ff; /* light blue */
            color: #1e3a8a;
            font-weight: 600;
            text-align: center;
        }

        .band-credit {
            background: #99caff; /* light green */
            color: #065f46;
            font-weight: 600;
            text-align: center;
        }

        .band-compliance {
            background: #66b0ff; /* light yellow */
            color: #92400e;
            font-weight: 600;
            text-align: center;
        }

        /* Sub Bands */
        .band-loan-sub {
            background: #cce5ff;
        }

        .band-credit-sub {
            background: #ecfdf5;
        }

        .band-compliance-sub {
            background: #fffbeb;
        }

        /* Lowest Level */
        .band-loan-light {
            background: #f8fbff;
        }

        .band-credit-light {
            background: #f3fdf8;
        }

        .band-compliance-light {
            background: #fffdf5;
        }

        /* General header styling */
        #table_slareport thead th {
            text-align: center;
            vertical-align: middle;
            font-size: 12px;
        }
    </style>

    <style>
        /* Container look */
        #table_domainwiseReport_filter {
            display: flex;
            align-items: center;
            gap: 10px;
            /* width:200px;*/
        }

        /* Select2 main box */
        .domain-filter + .select2-container--default .select2-selection--multiple {
            min-height: 38px;
            border-radius: 10px;
            border: 1px solid #d0d7de;
            padding: 4px 6px;
            background: linear-gradient(145deg, #ffffff, #f7f9fc);
            box-shadow: 0 2px 6px rgba(0,0,0,0.08);
            transition: all 0.2s ease-in-out;
            width: 200px;
        }

        /* Focus effect */
        .domain-filter + .select2-container--default.select2-container--focus .select2-selection--multiple {
            border-color: #4a90e2;
            box-shadow: 0 0 0 3px rgba(74,144,226,0.2);
        }

        /* Selected tags (chips) */
        .select2-container--default .select2-selection--multiple .select2-selection__choice {
            background: linear-gradient(135deg, #4a90e2, #357abd);
            color: #fff;
            border: none;
            border-radius: 20px;
            padding: 2px 10px;
            font-size: 12px;
            font-weight: 500;
            margin-top: 4px;
        }

        /* Remove icon inside chip */
        .select2-container--default .select2-selection--multiple .select2-selection__choice__remove {
            color: #fff;
            margin-right: 5px;
        }

        /* Dropdown box */
        .select2-dropdown {
            border-radius: 10px;
            overflow: hidden;
            border: 1px solid #d0d7de;
            box-shadow: 0 6px 18px rgba(0,0,0,0.12);
        }

        /* Search inside dropdown */
        .select2-search--dropdown .select2-search__field {
            border-radius: 6px;
            padding: 6px;
        }
    </style>

    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />

    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
</asp:Content>


