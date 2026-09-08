<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="PMWiseAttritionReport.aspx.cs" Inherits="WebPortal.Admin.PMWiseAttritionReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --pmatr-navy: #102a43;
            --pmatr-blue: #1769e0;
            --pmatr-cyan: #19a7ce;
            --pmatr-bg: #f4f7fb;
            --pmatr-border: #e3eaf3;
            --pmatr-muted: #6b7c93;
        }

        .content-wrapper {
            background: var(--pmatr-bg);
        }

        .pmatr-page {
            width: 100%;
            max-width: 1600px;
            margin: 0 auto;
        }

        .pmatr-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: flex-start;
            gap: 16px;
            margin-bottom: 18px;
            padding: 20px 24px;
            border-radius: 18px;
            color: #fff;
            background: linear-gradient(120deg, #102a43 0%, #1556a8 55%, #19a7ce 100%);
            box-shadow: 0 16px 38px rgba(16, 42, 67, .18);
        }

            .pmatr-hero::after {
                content: "";
                position: absolute;
                right: -55px;
                bottom: -90px;
                width: 240px;
                height: 240px;
                border: 42px solid rgba(255, 255, 255, .08);
                border-radius: 50%;
            }

        .pmatr-hero-copy,
        .pmatr-hero-icon {
            position: relative;
            z-index: 1;
        }

        .pmatr-hero-copy {
            text-align: left;
        }

        .pmatr-eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            margin-bottom: 6px;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: .12em;
            text-transform: uppercase;
            color: #bdefff;
        }

        .pmatr-hero h1 {
            margin: 0;
            font-size: 20px;
            font-weight: 700;
            letter-spacing: -.02em;
        }

        .pmatr-hero p {
            margin: 6px 0 0;
            color: rgba(255, 255, 255, .78);
            font-size: 12px;
        }

        .pmatr-hero-icon {
            display: grid;
            flex: 0 0 58px;
            width: 58px;
            height: 58px;
            place-items: center;
            border: 1px solid rgba(255, 255, 255, .22);
            border-radius: 16px;
            background: rgba(255, 255, 255, .12);
            font-size: 25px;
            backdrop-filter: blur(8px);
        }

        .pmatr-panel {
            margin-bottom: 18px;
            border: 1px solid var(--pmatr-border);
            border-radius: 16px;
            background: #fff;
            box-shadow: 0 8px 26px rgba(26, 54, 93, .07);
        }

        .pmatr-filter-panel {
            padding: 20px 22px;
        }

        .pmatr-panel-heading {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 16px;
        }

        .pmatr-panel-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0;
            color: var(--pmatr-navy);
            font-size: 15px;
            font-weight: 700;
        }

            .pmatr-panel-title span {
                display: grid;
                width: 32px;
                height: 32px;
                place-items: center;
                border-radius: 9px;
                color: var(--pmatr-blue);
                background: #eaf2ff;
            }

        .pmatr-required-note {
            color: var(--pmatr-muted);
            font-size: 11px;
        }

        .pmatr-filter-grid {
            display: grid;
            grid-template-columns: minmax(240px, 1.35fr) minmax(180px, 1fr) minmax(180px, 1fr) auto;
            align-items: end;
            gap: 14px;
        }

        .pmatr-field label {
            display: block;
            margin: 0 0 7px;
            color: #44566c;
            font-size: 12px;
            font-weight: 700;
        }

            .pmatr-field label i {
                width: 16px;
                color: #7f94aa;
            }

        .pmatr-field .form-control {
            width: 100%;
            height: 42px;
            border: 1px solid #d9e2ec;
            border-radius: 10px;
            background-color: #fbfcfe;
            color: #23384d;
            font-size: 13px;
            box-shadow: none;
            transition: border-color .2s, box-shadow .2s, background-color .2s;
        }

            .pmatr-field .form-control:focus {
                border-color: #66a3f2;
                background: #fff;
                box-shadow: 0 0 0 3px rgba(23, 105, 224, .11);
            }

        .pmatr-actions {
            display: flex;
            gap: 9px;
        }

        .pmatr-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-height: 42px;
            padding: 0 17px;
            border: 0;
            border-radius: 10px;
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
            transition: transform .18s, box-shadow .18s, opacity .18s;
        }

            .pmatr-btn:hover {
                transform: translateY(-1px);
            }

        .pmatr-btn-primary {
            color: #fff;
            background: linear-gradient(135deg, #1769e0, #1854b5);
            box-shadow: 0 7px 15px rgba(23, 105, 224, .22);
        }

        .pmatr-btn-secondary {
            border: 1px solid #cfe0f3;
            color: #23527c;
            background: #f3f8fd;
        }

        .pmatr-btn:disabled {
            cursor: not-allowed;
            opacity: .55;
            transform: none;
            box-shadow: none;
        }

        .pmatr-validation {
            display: none;
            align-items: center;
            gap: 7px;
            margin: 12px 0 0;
            color: #b42318;
            font-size: 12px;
            font-weight: 600;
        }

        .pmatr-report-panel {
            overflow: hidden;
        }

        .pmatr-tabs-wrap {
            padding: 10px 12px 0;
            border-bottom: 1px solid var(--pmatr-border);
            background: #fbfcfe;
        }

        .pmatr-tabs {
            gap: 7px;
            border: 0;
        }

            .pmatr-tabs .nav-link {
                display: flex;
                align-items: center;
                gap: 8px;
                padding: 11px 16px;
                border: 0;
                border-radius: 10px 10px 0 0;
                color: #60758a;
                font-size: 12px;
                font-weight: 700;
            }

                .pmatr-tabs .nav-link:hover {
                    color: var(--pmatr-blue);
                    background: #f0f5fb;
                }

                .pmatr-tabs .nav-link.active {
                    position: relative;
                    color: var(--pmatr-blue);
                    background: #fff;
                }

                    .pmatr-tabs .nav-link.active::after {
                        content: "";
                        position: absolute;
                        right: 14px;
                        bottom: 0;
                        left: 14px;
                        height: 3px;
                        border-radius: 3px 3px 0 0;
                        background: linear-gradient(90deg, var(--pmatr-blue), var(--pmatr-cyan));
                    }

        .pmatr-tab-body {
            min-height: 330px;
            padding: 18px;
        }

        .pmatr-table-shell {
            width: 100%;
            overflow-x: auto;
            border: 1px solid var(--pmatr-border);
            border-radius: 12px;
        }

            .pmatr-table-shell:empty {
                display: none;
            }

        .pmatr-empty-state {
            display: flex;
            min-height: 275px;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            padding: 35px 20px;
            text-align: center;
            color: var(--pmatr-muted);
        }

        .pmatr-empty-icon {
            display: grid;
            width: 58px;
            height: 58px;
            margin-bottom: 14px;
            place-items: center;
            border-radius: 18px;
            color: var(--pmatr-blue);
            background: #edf4ff;
            font-size: 23px;
        }

        .pmatr-empty-state h3 {
            margin: 0 0 5px;
            color: #34495e;
            font-size: 15px;
            font-weight: 700;
        }

        .pmatr-empty-state p {
            max-width: 430px;
            margin: 0;
            font-size: 12px;
        }

        #load1.loading {
            display: none;
            position: fixed !important;
            inset: 0 !important;
            top: 0 !important;
            right: 0 !important;
            bottom: 0 !important;
            left: 0 !important;
            z-index: 999999 !important;
            width: 100vw !important;
            height: 100vh !important;
            margin: 0 !important;
            border-radius: 0 !important;
            opacity: 1 !important;
            align-items: center;
            justify-content: center;
            background: rgba(15, 35, 58, .28);
            backdrop-filter: blur(2px);
        }

        #load1 .pmatr-loader-card {
            position: static !important;
            transform: none !important;
            min-width: 190px;
            max-width: calc(100vw - 32px);
            margin: 0 !important;
            padding: 24px;
            border-radius: 16px;
            background: #fff;
            text-align: center;
            color: var(--pmatr-navy);
            box-shadow: 0 20px 60px rgba(15, 35, 58, .22);
        }

        .pmatr-spinner {
            width: 34px;
            height: 34px;
            margin: 0 auto 12px;
            border: 3px solid #dbe8f7;
            border-top-color: var(--pmatr-blue);
            border-radius: 50%;
            animation: pmatr-spin .8s linear infinite;
        }

        @keyframes pmatr-spin {
            to {
                transform: rotate(360deg);
            }
        }

        .pmatr-page .dataTables_wrapper {
            padding: 14px;
            color: #53677c;
            font-size: 12px;
        }

            .pmatr-page .dataTables_wrapper .dataTables_length,
            .pmatr-page .dataTables_wrapper .dataTables_filter {
                margin-bottom: 12px;
            }

            .pmatr-page .dataTables_wrapper .form-control,
            .pmatr-page .dataTables_wrapper select {
                min-height: 34px;
                border: 1px solid #d9e2ec;
                border-radius: 8px;
                box-shadow: none;
            }

        .pmatr-page table.dataTable {
            margin: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0;
        }

        .pmatr-page .table.dataTable th {
            padding: 12px 10px;
            border: 0 !important;
            border-bottom: 1px solid #dbe5ef !important;
            background: #edf3f9 !important;
            color: #29445e;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: .025em;
            white-space: nowrap;
        }

        .pmatr-page .table.dataTable td {
            padding: 11px 10px;
            border-color: #edf1f5;
            background: #fff;
            color: #465b70;
            font-size: 12px;
            vertical-align: middle;
        }

        .pmatr-page .table.dataTable tbody tr:hover td {
            background: #f7faff;
        }

        .pmatr-page .page-item .page-link {
            margin: 0 2px;
            border: 0;
            border-radius: 7px;
            color: #587086;
        }

        .pmatr-page .page-item.active .page-link {
            background: var(--pmatr-blue);
            box-shadow: 0 4px 10px rgba(23, 105, 224, .2);
        }

        .dataTables_scrollHeadInner,
        .dataTables_scrollHeadInner table {
            width: 100% !important;
        }

        @media (max-width: 1050px) {
            .pmatr-filter-grid {
                grid-template-columns: repeat(3, minmax(0, 1fr));
            }

            .pmatr-actions {
                grid-column: 1 / -1;
            }
        }

        @media (max-width: 767px) {
            .pmatr-page {
                padding: 14px 10px 24px;
            }

            .pmatr-hero {
                padding: 20px;
                border-radius: 14px;
            }

                .pmatr-hero h1 {
                    font-size: 20px;
                }

            .pmatr-hero-icon {
                display: none;
            }

            .pmatr-filter-grid {
                grid-template-columns: 1fr;
            }

            .pmatr-actions {
                display: grid;
                grid-column: auto;
                grid-template-columns: 1fr 1fr;
            }

            .pmatr-panel-heading {
                align-items: flex-start;
                flex-direction: column;
            }

            .pmatr-tabs {
                flex-wrap: nowrap;
                overflow-x: auto;
            }

                .pmatr-tabs .nav-link {
                    white-space: nowrap;
                }

            .pmatr-tab-body {
                padding: 10px;
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            pmatr_bindpm();
            clearAllTables();

            $('a[data-toggle="pill"], a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
                var targetTab = $(e.target).attr("href");

                if (targetTab === "#custom-tabs-one-profile") {
                    if (window.isSearched && window.pmatrDataReady) {
                        pmatr_bindnew();
                    }
                } else if (targetTab === "#custom-tabs-one-exclude") {
                    if (window.isSearched && window.pmatrDataReady) {
                        pmatr_bindresigned();
                    }
                } else {
                    $.fn.dataTable.tables({ visible: true, api: true }).columns.adjust();
                }
            });
        });

        window.isSearched = false;
        window.pmatrDataReady = false;

        function pmatr_setLoading(show) {
            $('#load1').css('display', show ? 'flex' : 'none');
        }

        function pmatr_setValidation(message) {
            var $message = $('#pmatr_validation');
            $message.find('span').text(message || '');
            $message.css('display', message ? 'flex' : 'none');
        }

        function pmatr_setTableState(tableId, emptyId, hasRows, emptyTitle, emptyText) {
            var $empty = $('#' + emptyId);
            $('#' + tableId).closest('.pmatr-table-shell').toggle(hasRows);
            $empty.toggle(!hasRows);

            if (!hasRows && emptyTitle) {
                $empty.find('h3').text(emptyTitle);
                $empty.find('p').text(emptyText || '');
            }
        }

        function clearAllTables() {
            window.isSearched = false;
            window.pmatrDataReady = false;

            if ($.fn.DataTable.isDataTable('#pmatr_table')) {
                $('#pmatr_table').DataTable().clear().destroy();
            }
            $('#pmatr_table').html('');

            if ($.fn.DataTable.isDataTable('#pmatrnew_table')) {
                $('#pmatrnew_table').DataTable().clear().destroy();
            }
            $('#pmatrnew_table').html('');

            if ($.fn.DataTable.isDataTable('#pmatrRes_table')) {
                $('#pmatrRes_table').DataTable().clear().destroy();
            }
            $('#pmatrRes_table').html('');

            pmatr_setTableState('pmatr_table', 'pmatr_summary_empty', false, 'Your report will appear here', 'Select a domain and date range, then click View report.');
            pmatr_setTableState('pmatrnew_table', 'pmatr_new_empty', false, 'No report loaded', 'Run the report to view employees who joined during the selected period.');
            pmatr_setTableState('pmatrRes_table', 'pmatr_resigned_empty', false, 'No report loaded', 'Run the report to view absconding and resigned employees.');
            $('#pmatr_btnExporttoexcel').prop('disabled', true);
        }

        function pmatr_bindpm() {
            var $pm = $("#pmatr_pm").prop('disabled', true).html('<option value="">Loading domains...</option>');

            $.ajax({
                type: "POST",
                url: "CreateProfile.aspx/GetAllDomains",
                data: "{}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (res) {
                    $pm.html('<option value="">Select a domain</option>');
                    $.each(res.d || [], function (_, item) {
                        $pm.append(
                            $("<option>", {
                                value: item.DomainID,
                                text: item.DomainName
                            })
                        );
                    });
                    $pm.prop('disabled', false);
                },
                error: function (xhr) {
                    console.error(xhr.responseText);
                    $pm.html('<option value="">Unable to load domains</option>');
                    pmatr_setValidation('Domains could not be loaded. Please refresh the page and try again.');
                }
            });
        }

        function pmatr_Submit() {


            var fromdate = document.getElementById("pmatr_from").value;
            var todate = document.getElementById("pmatr_to").value;
            var ddldomainID = document.getElementById("pmatr_pm");
            var domainID = ddldomainID.options[ddldomainID.selectedIndex].value;

            pmatr_setValidation('');

            if (!fromdate && !todate && !domainID) {
                pmatr_setValidation('Select a domain, from date, and to date to continue.');
                document.getElementById('pmatr_pm').focus();
                return false;
            }
            if (!domainID) {
                pmatr_setValidation('Please select a domain.');
                document.getElementById('pmatr_pm').focus();
                return false;
            }
            if (!fromdate || !todate) {
                pmatr_setValidation('Please select both the from date and to date.');
                document.getElementById(!fromdate ? 'pmatr_from' : 'pmatr_to').focus();
                return false;
            }
            if (new Date(fromdate) > new Date(todate)) {
                pmatr_setValidation('From date cannot be later than to date.');
                document.getElementById('pmatr_from').focus();
                return false;
            }

            window.isSearched = true;

            clearAllTables();
            window.isSearched = true;

            pmatr_setLoading(true);
            $('#pmatr_btnShow').prop('disabled', true).find('span').text('Loading...');

            $.ajax({
                url: "PMWiseAttritionReport.aspx/GetReportingManagerWiseAttrition",
                type: "POST",
                cache: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ FromDate: fromdate, ToDate: todate, DomainID: parseInt(domainID, 10) }),
                success: function (data) {
                    var dataArray = JSON.parse(data.d);
                    window.pmatrDataReady = true;
                    if (!dataArray || dataArray.length === 0) {
                        pmatr_setTableState('pmatr_table', 'pmatr_summary_empty', false, 'No results found', 'There is no attrition data for the selected domain and date range.');
                        pmatr_setLoading(false);
                        $('#pmatr_btnShow').prop('disabled', false).find('span').text('View report');
                        pmatr_loadActiveDetailTab();
                        return;
                    }

                    pmatr_setTableState('pmatr_table', 'pmatr_summary_empty', true);
                    $('#pmatr_btnExporttoexcel').prop('disabled', false);

                    var columns = [];
                    $.each(dataArray[0], function (key, value) {
                        var my_item = {};
                        my_item.data = key;
                        my_item.title = key;
                        columns.push(my_item);
                    });

                    $('#pmatr_table').DataTable({
                        dom: 'lftip',
                        destroy: true,
                        orderCellsTop: true,
                        fixedHeader: true,
                        scrollX: true,
                        paging: true,
                        autoWidth: true,
                        select: true,
                        ordering: false,
                        processing: true,
                        filter: true,
                        select: { style: 'single' },
                        serverSide: false,
                        data: dataArray,
                        columns: columns,
                        fnCreatedRow: function (nRow, aData, iDataIndex) {
                            $(nRow).children("td").css("text-wrap", "nowrap");
                        },
                        initComplete: function () {
                            var table = this.api();
                            setTimeout(function () {
                                table.columns.adjust();
                            }, 150);
                            pmatr_setLoading(false);
                            $('#pmatr_btnShow').prop('disabled', false).find('span').text('View report');
                            pmatr_loadActiveDetailTab();
                        }
                    });
                },
                error: function (error) {
                    console.error(error.responseText);
                    pmatr_setLoading(false);
                    $('#pmatr_btnShow').prop('disabled', false).find('span').text('View report');
                    pmatr_setValidation('The report could not be loaded. Please try again.');
                }
            });

            return false;
        }

        function pmatr_loadActiveDetailTab() {
            var activeTab = $('#custom-tabs-one-tab .nav-link.active').attr('href');
            if (activeTab === "#custom-tabs-one-profile") {
                pmatr_bindnew();
            } else if (activeTab === "#custom-tabs-one-exclude") {
                pmatr_bindresigned();
            }
        }

        function pmatr_bindnew() {
            if (!window.isSearched) return;

            pmatr_setLoading(true);
            var columns = [];

            $.ajax({
                url: "PMWiseAttritionReport.aspx/GetNewJoined",
                type: "POST",
                cache: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    var dataArray = JSON.parse(data.d);
                    if (!dataArray || dataArray.length === 0) {
                        if ($.fn.DataTable.isDataTable('#pmatrnew_table')) {
                            $('#pmatrnew_table').DataTable().clear().destroy();
                        }
                        pmatr_setTableState('pmatrnew_table', 'pmatr_new_empty', false, 'No new joiners found', 'No employees joined during the selected period.');
                        pmatr_setLoading(false);
                        return;
                    }

                    $('#pmatrnew_table').empty();
                    pmatr_setTableState('pmatrnew_table', 'pmatr_new_empty', true);
                    $('#pmatr_btnExporttoexcel').prop('disabled', false);
                    $.each(dataArray[0], function (key, value) {
                        var my_item = {};
                        my_item.data = key;
                        my_item.title = key;
                        columns.push(my_item);
                    });

                    $('#pmatrnew_table').DataTable({
                        dom: 'lftip',
                        destroy: true,
                        scrollX: true,
                        scrollCollapse: true,
                        paging: true,
                        autoWidth: false,
                        select: true,
                        ordering: false,
                        processing: true,
                        filter: true,
                        serverSide: false,
                        data: dataArray,
                        columns: columns,
                        initComplete: function () {
                            var table = this.api();
                            pmatr_setLoading(false);
                            table.columns.adjust();
                        }
                    });
                },
                error: function (error) {
                    console.error(error.responseText);
                    pmatr_setLoading(false);
                    pmatr_setValidation('New joiner details could not be loaded. Please try again.');
                }
            });
        }

        function pmatr_bindresigned() {
            if (!window.isSearched) return;

            pmatr_setLoading(true);
            var columns = [];

            $.ajax({
                url: "PMWiseAttritionReport.aspx/GetResignedEmployees",
                type: "POST",
                cache: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    var dataArray = JSON.parse(data.d);

                    if (!dataArray || dataArray.length === 0) {
                        if ($.fn.DataTable.isDataTable('#pmatrRes_table')) {
                            $('#pmatrRes_table').DataTable().clear().destroy();
                        }
                        pmatr_setTableState('pmatrRes_table', 'pmatr_resigned_empty', false, 'No exits found', 'No absconding or resigned employees were found for this report.');
                        pmatr_setLoading(false);
                        return;
                    }

                    $('#pmatrRes_table').empty();
                    pmatr_setTableState('pmatrRes_table', 'pmatr_resigned_empty', true);
                    $('#pmatr_btnExporttoexcel').prop('disabled', false);

                    $.each(dataArray[0], function (key, value) {
                        var my_item = {};
                        my_item.data = key;
                        my_item.title = key;
                        my_item.className = "text-nowrap";
                        columns.push(my_item);
                    });

                    $('#pmatrRes_table').DataTable({
                        dom: 'lftip',
                        destroy: true,
                        scrollX: false,
                        scrollCollapse: true,
                        paging: true,
                        autoWidth: true,
                        select: true,
                        ordering: false,
                        processing: true,
                        filter: true,
                        serverSide: false,
                        data: dataArray,
                        columns: columns,
                        initComplete: function () {
                            var table = this.api();
                            setTimeout(function () {
                                table.columns.adjust().draw();
                            }, 200);
                            pmatr_setLoading(false);
                        }
                    });
                },
                error: function (error) {
                    console.error(error.responseText);
                    pmatr_setLoading(false);
                    pmatr_setValidation('Absconding and resigned employee details could not be loaded. Please try again.');
                }
            });
        }

        function pmatr_Exporttoexcel() {
            var activeTab = $('#custom-tabs-one-tab .nav-link.active').attr('href');
            var tableId = "#pmatr_table"; // Default Summary table

            if (activeTab === "#custom-tabs-one-profile") {
                tableId = "#pmatrnew_table";
            } else if (activeTab === "#custom-tabs-one-exclude") {
                tableId = "#pmatrRes_table";
            }

            // Check if DataTable exists and has rows
            if ($.fn.DataTable.isDataTable(tableId)) {
                var tableApi = $(tableId).DataTable();
                var rowCount = tableApi.rows({ search: 'applied' }).count();

                if (rowCount === 0) {
                    pmatr_setValidation('There is no data to export on the selected tab.');
                    return false;
                }
            } else {
                pmatr_setValidation('Load the selected report before exporting.');
                return false;
            }
            pmatr_setValidation('');
            pmatr_setLoading(true);

            __doPostBack("<%= btn21.UniqueID %>", '');

            return false;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Button ID="btn21" runat="server" Style="display: none;" OnClick="btn21_Click" />
    <div class="loading" id="load1" role="status" aria-live="polite" aria-label="Loading report">
        <div class="pmatr-loader-card">
            <div class="pmatr-spinner" aria-hidden="true"></div>
            <strong>Preparing your report</strong>
            <div class="small text-muted mt-1">This should only take a moment.</div>
        </div>
    </div>

    <main class="pmatr-page">
        <section class="pmatr-hero" aria-labelledby="pmatr_page_title">
            <div class="pmatr-hero-icon" aria-hidden="true"><i class="fas fa-users"></i></div>
            <div class="pmatr-hero-copy">
                <h1 id="pmatr_page_title">Reporting Manager Attrition</h1>
                <p>Review workforce movement by domain and reporting period.</p>
            </div>
        </section>

        <section class="pmatr-panel pmatr-filter-panel" aria-labelledby="pmatr_filter_title">
            <div class="pmatr-panel-heading">
                <h2 class="pmatr-panel-title" id="pmatr_filter_title">
                    <span><i class="fas fa-sliders-h"></i></span>
                    Report filters
                </h2>
                <div class="pmatr-required-note">All fields are required</div>
            </div>

            <div class="pmatr-filter-grid">
                <div class="pmatr-field">
                    <label for="pmatr_pm"><i class="fas fa-layer-group"></i>Domain</label>
                    <select id="pmatr_pm" name="pmatr_pm" class="form-control" aria-required="true"></select>
                </div>
                <div class="pmatr-field">
                    <label for="pmatr_from"><i class="far fa-calendar-alt"></i>From date</label>
                    <input type="date" id="pmatr_from" name="pmatr_from" class="form-control" aria-required="true" />
                </div>
                <div class="pmatr-field">
                    <label for="pmatr_to"><i class="far fa-calendar-check"></i>To date</label>
                    <input type="date" id="pmatr_to" name="pmatr_to" class="form-control" aria-required="true" />
                </div>
                <div class="pmatr-actions">
                    <button type="button" id="pmatr_btnShow" class="pmatr-btn pmatr-btn-primary" onclick="return pmatr_Submit();">
                        <i class="fas fa-search"></i><span>View report</span>
                    </button>
                    <button type="button" id="pmatr_btnExporttoexcel" class="pmatr-btn pmatr-btn-secondary" onclick="return pmatr_Exporttoexcel();" disabled>
                        <i class="fas fa-file-excel"></i><span>Export</span>
                    </button>
                </div>
            </div>
            <div class="pmatr-validation" id="pmatr_validation" role="alert">
                <i class="fas fa-exclamation-circle" aria-hidden="true"></i><span></span>
            </div>
        </section>

        <section class="pmatr-panel pmatr-report-panel" aria-label="Attrition report results">
            <div class="pmatr-tabs-wrap">
                <ul class="nav nav-tabs pmatr-tabs" id="custom-tabs-one-tab" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">
                            <i class="fas fa-chart-pie"></i>Summary
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">
                            <i class="fas fa-user-plus"></i>New joined
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" id="custom-tabs-one-exclude-tab" data-toggle="pill" href="#custom-tabs-one-exclude" role="tab" aria-controls="custom-tabs-one-exclude" aria-selected="false">
                            <i class="fas fa-user-minus"></i>Absconding / Resigned
                        </a>
                    </li>
                </ul>
            </div>

            <div class="pmatr-tab-body">
                <div class="tab-content" id="custom-tabs-one-tabContent">
                    <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                        <div class="pmatr-empty-state" id="pmatr_summary_empty">
                            <div class="pmatr-empty-icon"><i class="far fa-chart-bar"></i></div>
                            <h3>Your report will appear here</h3>
                            <p>Select a domain and date range, then click View report.</p>
                        </div>
                        <div class="pmatr-table-shell" style="display: none;">
                            <table class="table" style="width: 100%;" id="pmatr_table"></table>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                        <div class="pmatr-empty-state" id="pmatr_new_empty">
                            <div class="pmatr-empty-icon"><i class="fas fa-user-plus"></i></div>
                            <h3>No report loaded</h3>
                            <p>Run the report to view employees who joined during the selected period.</p>
                        </div>
                        <div class="pmatr-table-shell" style="display: none;">
                            <table class="table" style="width: 100%;" id="pmatrnew_table"></table>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="custom-tabs-one-exclude" role="tabpanel" aria-labelledby="custom-tabs-one-exclude-tab">
                        <div class="pmatr-empty-state" id="pmatr_resigned_empty">
                            <div class="pmatr-empty-icon"><i class="fas fa-user-minus"></i></div>
                            <h3>No report loaded</h3>
                            <p>Run the report to view absconding and resigned employees.</p>
                        </div>
                        <div class="pmatr-table-shell" style="display: none;">
                            <table class="table" style="width: 100%; white-space: nowrap;" id="pmatrRes_table"></table>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>

</asp:Content>
