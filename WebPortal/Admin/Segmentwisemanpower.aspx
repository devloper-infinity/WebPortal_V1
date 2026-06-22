<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Segmentwisemanpower.aspx.cs" Inherits="WebPortal.Admin.Segmentwisemanpower" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">


    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />

    <style>
        :root {
            --ud-primary: #2563eb;
            --ud-primary-dark: #1d4ed8;
            --ud-accent: #22c1dc;
            --ud-bg: #f5f7fb;
            --ud-card: #ffffff;
            --ud-text: #0f172a;
            --ud-muted: #64748b;
            --ud-border: #e2e8f0;
            --ud-soft: #eff6ff;
            --ud-shadow: 0 18px 45px rgba(15, 23, 42, .08);
        }

        body {
            background: var(--ud-bg);
        }

        .ud-page {
            width: 100%;
        }

        .ud-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            gap: 18px;
            padding: 22px 28px;
            border-radius: 22px;
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%);
            box-shadow: var(--ud-shadow);
        }

            .ud-hero:before,
            .ud-hero:after {
                content: "";
                position: absolute;
                border-radius: 999px;
                background: rgba(255, 255, 255, .12);
            }

            .ud-hero:before {
                width: 220px;
                height: 220px;
                right: 70px;
                top: -120px;
            }

            .ud-hero:after {
                width: 300px;
                height: 300px;
                right: -90px;
                bottom: -170px;
            }

        .ud-hero-icon {
            position: relative;
            z-index: 1;
            width: 50px;
            height: 50px;
            display: grid;
            place-items: center;
            flex-shrink: 0;
            border-radius: 18px;
            background: rgba(255, 255, 255, .16);
            border: 1px solid rgba(255, 255, 255, .22);
            font-size: 24px;
        }

        .ud-hero-content {
            position: relative;
            z-index: 1;
        }

        .ud-title {
            margin: 0;
            font-size: 19px;
            font-weight: 800;
            letter-spacing: -.02em;
        }

        .ud-subtitle {
            margin: 8px 0 0;
            font-size: 12px;
            opacity: .9;
        }

        .ud-card {
            margin-top: 22px;
            padding: 22px;
            border: 1px solid var(--ud-border);
            border-radius: 22px;
            background: var(--ud-card);
            box-shadow: var(--ud-shadow);
        }

        .ud-section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 18px;
            color: var(--ud-text);
            font-size: 16px;
            font-weight: 800;
        }

            .ud-section-title i {
                width: 34px;
                height: 34px;
                display: inline-grid;
                place-items: center;
                border-radius: 12px;
                background: var(--ud-soft);
                color: var(--ud-primary);
            }

        .ud-table-wrap {
            width: 100%;
            overflow-x: auto;
            border-radius: 18px;
            background: #fff;
        }

        .ud-actions {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
            margin-bottom: 16px;
        }

        .nav-tabs {
            gap: 8px;
            border-bottom: 1px solid var(--ud-border);
        }

            .nav-tabs .nav-link {
                border: 0 !important;
                border-radius: 14px 14px 0 0;
                padding: 12px 18px;
                color: var(--ud-muted);
                font-size: 13px;
                font-weight: 900;
                background: #f8fafc;
            }

                .nav-tabs .nav-link.active {
                    color: #fff !important;
                    background: linear-gradient(135deg, var(--ud-primary), var(--ud-accent)) !important;
                    box-shadow: 0 12px 24px rgba(37, 99, 235, .18);
                }

        label,
        .form-label {
            display: block;
            margin-bottom: 8px;
            color: var(--ud-muted);
            font-size: 12px;
            font-weight: 800;
            letter-spacing: .02em;
        }

        .form-control,
        .form-select,
        select,
        input[type="text"] {
            width: 100%;
            min-height: 42px;
            border: 1px solid var(--ud-border);
            padding: 8px 12px;
            border-radius: 14px;
            font-size: 13px;
            color: var(--ud-text);
            background-color: #fff;
            outline: none;
            box-shadow: none;
            transition: border-color .18s ease, box-shadow .18s ease;
        }

            .form-control:focus,
            .form-select:focus,
            select:focus,
            input[type="text"]:focus {
                border-color: var(--ud-primary);
                box-shadow: 0 0 0 4px rgba(37, 99, 235, .12);
            }

        .btn,
        button,
        .dt-button,
        .buttons-excel {
            display: inline-flex !important;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-height: 42px;
            padding: 0 16px !important;
            border: 0 !important;
            border-radius: 14px !important;
            font-size: 13px !important;
            font-weight: 800 !important;
            cursor: pointer;
            color: #fff !important;
            background: linear-gradient(135deg, var(--ud-primary), var(--ud-accent)) !important;
            box-shadow: 0 12px 24px rgba(37, 99, 235, .22) !important;
            transition: transform .18s ease, box-shadow .18s ease;
            width:150px!important;
        }

            .btn:hover,
            button:hover,
            .dt-button:hover,
            .buttons-excel:hover {
                transform: translateY(-1px);
                box-shadow: 0 16px 30px rgba(37, 99, 235, .30) !important;
            }

        #seg_btnExport {
            background: linear-gradient(135deg, #22c55e, #15803d) !important;
        }

        #branchPivot,
        #mapo_emplist,
        #pivotContainer table.pvtTable {
            width: 100% !important;
            margin: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0;
            white-space: nowrap;
        }

            #branchPivot thead th,
            #mapo_emplist thead th,
            #pivotContainer table.pvtTable thead th,
            #pivotContainer table.pvtTable tbody th,
            table.dataTable thead th {
                border: 0 !important;
                font-size: 12px;
                font-weight: 900;
                text-align: center;
                vertical-align: middle;
                letter-spacing: .02em;
            }

            #branchPivot tbody td,
            #branchPivot tfoot th,
            #mapo_emplist tbody td,
            #pivotContainer table.pvtTable tbody td {
                padding: 11px 12px !important;
                border-bottom: 1px solid var(--ud-border) !important;
                color: #334155;
                font-size: 13px;
                vertical-align: middle;
                background: #fff;
            }

            #branchPivot tbody tr:hover td,
            #mapo_emplist tbody tr:hover td {
                background: #f8fbff !important;
            }

            #branchPivot tfoot th {
                background: #f8fafc !important;
                color: var(--ud-text) !important;
                font-weight: 900;
            }

        table.dataTable thead th::before,
        table.dataTable thead th::after {
            display: none !important;
        }

        .top,
        .dataTables_wrapper .dt-buttons,
        div.dt-buttons {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
            float: none !important;
            position: static !important;
            padding-left: 0 !important;
            margin-bottom: 12px;
        }

        .dataTables_filter {
            margin-left: auto;
        }

            .dataTables_filter input,
            .dataTables_length select {
                min-height: 34px;
                border: 1px solid var(--ud-border);
                border-radius: 12px;
                padding: 6px 10px;
                font-size: 12px;
                outline: none;
            }

        .dataTables_paginate {
            float: left !important;
        }

        .panel {
            padding: 18px;
            border: 1px solid var(--ud-border);
            border-radius: 18px;
            background: #f8fafc;
            width: 100%;
            max-width: 780px;
            margin-bottom: 20px;
        }

            .panel h3 {
                margin: 0 0 14px;
                color: var(--ud-text);
                font-size: 16px;
                font-weight: 900;
            }

        #pivotContainer {
            margin-top: 20px;
            overflow-x: auto;
            border: 1px solid var(--ud-border);
            border-radius: 18px;
            background: #fff;
            padding: 14px;
        }

        .loading {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            padding: 22px;
            width: 210px;
            min-height: 190px;
            text-align: center;
            background: rgba(255,255,255,.92);
            border: 1px solid var(--ud-border);
            border-radius: 24px;
            box-shadow: var(--ud-shadow);
            z-index: 99999;
        }

        .empFilter {
            width: 100px !important;
            padding: 2px;
            font-size: 12px;
        }

        .ms-dd {
            position: relative;
            width: 150px;
        }

        .ms-btn {
            width: 100%;
            min-height: 34px !important;
            border: 1px solid rgba(255,255,255,.35) !important;
            background: rgba(255,255,255,.15) !important;
            /*   color: #fff !important;*/
            font-size: 12px;
            padding: 4px 8px !important;
            text-align: left !important;
            cursor: pointer;
            box-shadow: none !important;
        }

        .ms-panel {
            display: none;
            position: absolute;
            top: calc(100% + 6px);
            left: 0;
            background: #fff;
            border: 1px solid var(--ud-border);
            box-shadow: var(--ud-shadow);
            min-width: 240px;
            max-height: 240px;
            overflow-y: auto;
            padding: 8px;
            z-index: 99999 !important;
            white-space: normal;
            border-radius: 14px;
            text-align: left !important;
        }

        .ms-dd.open .ms-panel {
            display: block;
        }

        .ms-panel label {
            display: block;
            color: #334155;
            font-size: 12px;
            padding: 5px 6px;
            margin: 0;
            border-radius: 8px;
            text-align: left !important;
        }

            .ms-panel label:hover {
                background: #f1f5f9;
            }

        .ms-panel input[type="checkbox"] {
            accent-color: var(--ud-primary);
            margin-right: 6px;
        }

        div.dataTables_scrollHead,
        div.dataTables_scrollHeadInner {
            pointer-events: none !important;
        }

        .ms-dd,
        .ms-dd * {
            pointer-events: auto !important;
        }

        @media (max-width: 991px) {
            .ud-page {
                padding: 16px;
            }

            .dataTables_filter {
                margin-left: 0;
            }
        }

        @media (max-width: 575px) {
            .ud-hero {
                align-items: flex-start;
                padding: 20px;
            }

            .ud-title {
                font-size: 20px;
            }

            .ud-actions {
                flex-direction: column;
                align-items: stretch;
            }
        }
    </style>
    <script>
        var pivotData = [];
        var pivotOptions = {
            rows: [],
            cols: [],
            vals: [],
            aggregatorName: "Count"
        };


        // Load data from WebMethod
        function loadPivotData() {
            $.ajax({
                url: "Segmentwisemanpower.aspx/GetSegmentwiseManpowerList",
                type: "POST",
                contentType: "application/json",
                success: function (res) {
                    pivotData = JSON.parse(res.d);


                    let fields = Object.keys(pivotData[0]);


                    // Populate dropdowns
                    fields.forEach(f => {
                        $("#ddlRow").append(`<option value="${f}">${f}</option>`);
                        $("#ddlColumn").append(`<option value="${f}">${f}</option>`);
                        $("#ddlValue").append(`<option value="${f}">${f}</option>`);
                    });


                    // Initialize Pivot UI only once
                    initializePivot();
                }
            });
        }


        // Create unified pivot instance
        function initializePivot() {
            $("#pivotContainer").pivotUI(pivotData, pivotOptions, true);
        }


        // Update pivot using dropdown selections
        $("#btnGenerate").click(function () {
            pivotOptions.rows = $("#ddlRow").val() ? [$("#ddlRow").val()] : [];
            pivotOptions.cols = $("#ddlColumn").val() ? [$("#ddlColumn").val()] : [];
            pivotOptions.vals = $("#ddlValue").val() ? [$("#ddlValue").val()] : [];
            pivotOptions.aggregatorName = $("#ddlAggregator").val();

            $("#pivotContainer").pivotUI(pivotData, pivotOptions, true);
        });

        function exportPivotToExcel() {
            var table = $("#pivotContainer table.pvtTable");

            if (table.length === 0) {
                alert("No Pivot Table Found!");
                return;
            }

            var uri = "data:application/vnd.ms-excel;base64,";
            var template = `
        <html xmlns:o="urn:schemas-microsoft-com:office:office"
              xmlns:x="urn:schemas-microsoft-com:office:excel"
              xmlns="http://www.w3.org/TR/REC-html40">
        <head><meta charset="UTF-8"></head>
        <body>${table.prop("outerHTML")}</body>
        </html>`;

            var base64 = s => window.btoa(unescape(encodeURIComponent(s)));

            var downloadLink = document.createElement("a");
            downloadLink.href = uri + base64(template);
            downloadLink.download = "ManpowerSummary.xls";

            document.body.appendChild(downloadLink);
            downloadLink.click();
            document.body.removeChild(downloadLink);
        }



        // Load everything on page ready
        $(document).ready(function () {
            loadPivotData();

        });
        $(document).ready(function () {
            BindGridView();

        });


        function excelCol(n) {
            let s = "";
            while (n > 0) {
                let m = (n - 1) % 26;
                s = String.fromCharCode(65 + m) + s;
                n = Math.floor((n - m) / 26);
            }
            return s;
        }

        function createNode(doc, nodeName, attrs = {}, text = null) {
            let node = doc.createElement(nodeName);
            Object.keys(attrs).forEach(k => node.setAttribute(k, attrs[k]));
            if (text !== null) {
                let is = doc.createElement("is");
                let t = doc.createElement("t");
                t.appendChild(doc.createTextNode(text));
                is.appendChild(t);
                node.appendChild(is);
            }
            return node;
        }
        function BindGridView() {
            var columns = [];
            let dayCols = [];
            let nightCols = [];
            $.ajax({
                url: "Segmentwisemanpower.aspx/GetSegmentwiseManpower",
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",

                success: function (data) {

                    var res = JSON.parse(data.d);
                    res = res.map(r => {
                        let total = 0;

                        Object.keys(r).forEach(col => {
                            if (col.endsWith(" - Day") || col.endsWith(" - Night")) {
                                total += parseFloat(r[col]) || 0;
                            }
                        });

                        r["Grand Total"] = total;
                        return r;
                    });

                    let cols = Object.keys(res[0]);
                    dayCols = cols.filter(c => c.endsWith(" - Day"));
                    nightCols = cols.filter(c => c.endsWith(" - Night"));

                    //  cols.push("Grand Total");

                    let domains = [...new Set(res.map(x => x.Domain))];
                    let segments = [...new Set(res.map(x => x.Segment))];

                    let h1 = `
                                <th>Domain</th>
                                <th>Segment</th>
                                <th colspan="${dayCols.length}">Day</th>
                                <th colspan="${nightCols.length}">Night</th>
                                <th rowspan="2">Grand Total</th>
                            `;

                    let h2 = `
                            <th>
                                <div class="ms-dd" data-col="0">
                                    <input type="text" class="ms-btn" readonly value="Domain ▾">
                                    <div class="ms-panel">
                                        <label><input type="checkbox" value="__ALL__" checked> All</label>
                                        ${domains.map(d => `<label><input type="checkbox" value="${d}"> ${d}</label>`).join("")}
                                    </div>
                                </div>
                            </th>

                            <th>
                                <div class="ms-dd" data-col="1">
                                    <input type="text" class="ms-btn" readonly value="Segment ▾">
                                    <div class="ms-panel">
                                        <label><input type="checkbox" value="__ALL__" checked> All</label>
                                        ${segments.map(s => `<label><input type="checkbox" value="${s}"> ${s}</label>`).join("")}
                                    </div>
                                </div>
                            </th>
                            `;

                    dayCols.forEach(c => h2 += `<th>${c.replace(" - Day", "")}</th>`);
                    nightCols.forEach(c => h2 += `<th>${c.replace(" - Night", "")}</th>`);
                    //h2 += `<th></th>`;

                    $('#branchPivot thead').html('<tr></tr><tr></tr>');
                    $('#branchPivot thead tr:eq(0)').html(h1);
                    $('#branchPivot thead tr:eq(1)').html(h2);

                    let footerHtml = cols.map((c, i) => {
                        if (i === 0) return "<th><b>Total</b></th>";
                        if (i === 1) return "<th></th>";
                        return "<th class='text-end'></th>";
                    }).join("");

                    $('#branchPivot tfoot tr').html(footerHtml);

                    var table = $('#branchPivot').DataTable({
                        data: res,
                        columns: cols.map(c => ({ data: c })),
                        destroy: true,
                        paging: false,
                        dom: "Bfrtip",
                        orderCellsTop: true,
                        fixedHeader: true,
                        autoWidth: false,
                        retrieve: true,
                        buttons: [
                            {
                                extend: "excelHtml5",
                                filename: "SegmentWise_Manpower_Summary",
                                title: null,
                                exportOptions: {
                                    header: false,       // prevent DataTables from writing its own header
                                    columns: ':visible'
                                },

                            }
                        ],



                        footerCallback: function (row, data, start, end, display) {
                            const api = this.api();

                            const toNum = v => isNaN(parseFloat(v)) ? 0 : parseFloat(v);

                            api.columns().every(function (idx) {
                                if (idx <= 1) return;

                                let sum = 0;

                                api.rows({ filter: "applied" }).every(function () {
                                    const val = this.data()[api.column(idx).dataSrc()];
                                    sum += toNum(val);
                                });

                                $(api.column(idx).footer()).html(`<b>${sum}</b>`);
                            });
                        }
                    });

                    $(document).on("click", ".ms-btn", function (e) {
                        e.stopPropagation();
                        $(".ms-dd").not($(this).parent()).removeClass("open");
                        $(this).parent().toggleClass("open");
                    });

                    $(document).on("click", ".ms-panel", function (e) {
                        e.stopPropagation();
                    });

                    $(document).on("click", function () {
                        $(".ms-dd").removeClass("open");
                    });

                    $(document).on("change", ".ms-panel input[type=checkbox]", function () {

                        const panel = $(this).closest(".ms-panel");
                        const colIndex = $(this).closest(".ms-dd").data("col");

                        // NOT ALL → uncheck ALL
                        if (this.value !== "__ALL__") {
                            panel.find(`input[value="__ALL__"]`).prop("checked", false);
                        }

                        // ALL clicked → uncheck others
                        if (this.value === "__ALL__" && this.checked) {
                            panel.find("input[type=checkbox]").not(this).prop("checked", false);
                            table.column(colIndex).search("").draw();
                            return;
                        }

                        // Collect checked items
                        let values = panel.find("input:checked").map(function () {
                            return this.value;
                        }).get();

                        // Build regex OR pattern
                        let regex = values.map(v => "^" + v + "$").join("|");

                        table.column(colIndex).search(regex, true, false).draw();
                    });

                }
            });




            return false;
        }



        function BindManpowerList() {
            $('#load1').show();
            var columns = [];
            $.ajax({
                url: "Segmentwisemanpower.aspx/GetSegmentwiseManpowerList",
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    var columncount = 0;
                    var dataArray = JSON.parse(data.d);//

                    $.each(dataArray[0], function (key, value) {
                        var my_item = {};
                        my_item.data = key;
                        my_item.title = key;
                        columns.push(my_item);
                    });
                    if ($.fn.DataTable.isDataTable('#mapo_emplist')) {
                        $('#mapo_emplist').DataTable().destroy();
                    }

                    var table = $('#mapo_emplist').DataTable({
                        dom: 'Bft',
                        destroy: true,
                        orderCellsTop: true,
                        fixedColumns: {
                            leftColumns: 2,
                        },
                        scrollCollapse: false,
                        scrollY: '400px',
                        scrollX: true,
                        "paging": false,
                        "autoWidth": true,
                        select: true,
                        "ordering": true,
                        processing: true,
                        'select': {
                            'style': 'single'
                        },
                        "data": dataArray,
                        "columns": columns,
                        buttons: [
                            {
                                extend: 'excelHtml5',
                                filename: 'SegmentWise_Manpower_Details'
                            }
                        ],
                        rowGroup: {
                            dataSrc: null // 👉 Will set dynamically
                        },

                        initComplete: function () {
                            $("#load1").hide();
                        },
                        fnCreatedRow: function (nRow, aData, iDataIndex) {
                            $(nRow).children("td").css("text-wrap", "nowrap");
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



    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="ud-page">
        <section class="ud-hero">
            <div class="ud-hero-icon"><i class="bi bi-bar-chart-line-fill"></i></div>
            <div class="ud-hero-content">
                <h1 class="ud-title">Segment Wise Manpower</h1>
                <p class="ud-subtitle">View manpower summary, employee details and pivot analysis in one place.</p>
            </div>
        </section>

        <div class="ud-card">
            <div class="ud-section-title"><i class="bi bi-grid-3x3-gap"></i><span>Manpower Dashboard</span></div>
            <div class="card card-tabs border-0 shadow-none mb-0">
                <div class="card-header p-0 bg-transparent border-0">
                    <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true"><i class="bi bi-table"></i>&nbsp; Manpower Summary</a>
                        </li>
                        <li class="nav-item" onclick="return BindManpowerList();">
                            <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false"><i class="bi bi-people"></i>&nbsp; Employee Details</a>
                        </li>
                    </ul>
                </div>

                <div class="card-body px-0 pb-0">
                    <div class="tab-content" id="custom-tabs-one-tabContent">
                        <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                            <div class="ud-table-wrap">
                                <table id="branchPivot" class="table table-bordered display nowrap compact" style="width: 100%">
                                    <thead>
                                        <tr></tr>
                                        <tr></tr>
                                    </thead>
                                    <tfoot>
                                        <tr></tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>

                        <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                            <div class="panel" style="display: none;">
                                <h3><i class="bi bi-sliders"></i>&nbsp; Pivot Controls</h3>

                                <label>Row Field</label>
                                <select id="ddlRow" class="form-control"></select>

                                <label>Column Field</label>
                                <select id="ddlColumn" class="form-control"></select>

                                <label>Value Field</label>
                                <select id="ddlValue" class="form-control"></select>

                                <label>Aggregator</label>
                                <select id="ddlAggregator" class="form-control">
                                    <option>Count</option>
                                    <option>Sum</option>
                                    <option>Average</option>
                                    <option>Minimum</option>
                                    <option>Maximum</option>
                                </select>

                                <br />
                                <button id="btnGenerate" type="button"><i class="bi bi-play-fill"></i>Generate Pivot</button>
                            </div>

                            <div class="ud-actions">
                                <button id="seg_btnshowpivot" type="button" onclick="return seg_btnshowpivotclick();"><i class="bi bi-diagram-3"></i>Generate Pivot</button>
                                <button id="seg_btnExport" type="button" style="display: none;"><i class="bi bi-file-earmark-excel"></i>Export to Excel</button>
                            </div>

                            <div id="pivotContainer" style="display: none;"></div>

                            <div class="ud-table-wrap mt-3">
                                <table id="mapo_emplist" class="table table-bordered" style="width: 100%"></table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        function seg_btnshowpivotclick() {
            document.getElementById("seg_btnExport").style.display = '';
            document.getElementById("pivotContainer").style.display = '';
            return false;
        }
        $(function () {


            $(document).on("click", "#btnGenerate", function () {
                console.log("Generate Click Fired");

                pivotOptions.rows = $("#ddlRow").val() ? [$("#ddlRow").val()] : [];
                pivotOptions.cols = $("#ddlColumn").val() ? [$("#ddlColumn").val()] : [];
                pivotOptions.vals = $("#ddlValue").val() ? [$("#ddlValue").val()] : [];
                pivotOptions.aggregatorName = $("#ddlAggregator").val();

                $("#pivotContainer").pivotUI(pivotData, pivotOptions, true);
            });

            $(document).on("click", "#seg_btnExport", function () {
                console.log("Export Click Fired");   // test
                exportPivotToExcel();
            });


        });
    </script>
</asp:Content>


<%--<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">


    <style>
        .panel {
            padding: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
            width: 400px;
            margin-bottom: 20px;
        }

        #pivotContainer {
            margin-top: 20px;
        }

        label {
            margin-top: 10px;
            font-weight: bold;
            display: block;
        }

        .loading {
            display: none;
            position: fixed;
            top: 350px;
            left: 50%;
            margin-top: -96px;
            margin-left: -96px;
            /*  background-color: #ccc;*/
            opacity: .85;
            border-radius: 25px;
            width: 192px;
            height: 192px;
            z-index: 99999;
        }


        .dataTables_paginate {
            float: left !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 50px;
            float: left;
        }

        .buttons-excel {
            color: #fff;
            /*     background-color: #28a745;
            border-color: #28a745;*/
            box-shadow: none;
            background: linear-gradient(to right, #ffbf96, #fe7096);
            border: 0;
            font-weight: bold;
            margin: 0px 10px;
        }

        .table.dataTable th {
            /*background:linear-gradient(to bottom, #0070C0, 80%, #ffffff);*/
            background: linear-gradient(to bottom, #cbd0dd, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none;
        }

        .dt-center {
            text-align: center;
        }

        .empFilter {
            width: 100px !important;
            padding: 2px;
            font-size: 12px;
        }

        /* container and panel */
        .ms-dd {
            position: relative;
            width: 150px;
        }

        .ms-btn {
            width: 100%;
            border: 1px solid #ccc;
            background: #fff;
            font-size: 12px;
            padding: 3px 6px;
            text-align: left;
            cursor: pointer;
        }

        /* the dropdown */
        .ms-panel {
            display: none;
            position: absolute; /* keep it under the button */
            top: calc(100% + 2px);
            left: 0;
            background: #fff;
            border: 1px solid #ccc;
            box-shadow: 0 4px 8px rgba(0,0,0,.15);
            min-width: 220px;
            max-height: 220px;
            overflow-y: auto;
            padding: 6px;
            z-index: 99999 !important; /* above DT header/body */
            white-space: normal; /* wrap long text */
        }

        /* show when open */
        .ms-dd.open .ms-panel {
            display: block;
        }

        /* make items vertical & clickable */
        .ms-panel label {
            display: block;
            font-size: 12px;
            padding: 2px 4px;
        }

        div.dataTables_scrollHead,
        div.dataTables_scrollHeadInner {
            pointer-events: none !important;
        }

        .ms-dd,
        .ms-dd * {
            pointer-events: auto !important;
        }
    </style>
    <script>
        var pivotData = [];
        var pivotOptions = {
            rows: [],
            cols: [],
            vals: [],
            aggregatorName: "Count"
        };


        // Load data from WebMethod
        function loadPivotData() {
            $.ajax({
                url: "Segmentwisemanpower.aspx/GetSegmentwiseManpowerList",
                type: "POST",
                contentType: "application/json",
                success: function (res) {
                    pivotData = JSON.parse(res.d);


                    let fields = Object.keys(pivotData[0]);


                    // Populate dropdowns
                    fields.forEach(f => {
                        $("#ddlRow").append(`<option value="${f}">${f}</option>`);
                        $("#ddlColumn").append(`<option value="${f}">${f}</option>`);
                        $("#ddlValue").append(`<option value="${f}">${f}</option>`);
                    });


                    // Initialize Pivot UI only once
                    initializePivot();
                }
            });
        }


        // Create unified pivot instance
        function initializePivot() {
            $("#pivotContainer").pivotUI(pivotData, pivotOptions, true);
        }


        // Update pivot using dropdown selections
        $("#btnGenerate").click(function () {
            pivotOptions.rows = $("#ddlRow").val() ? [$("#ddlRow").val()] : [];
            pivotOptions.cols = $("#ddlColumn").val() ? [$("#ddlColumn").val()] : [];
            pivotOptions.vals = $("#ddlValue").val() ? [$("#ddlValue").val()] : [];
            pivotOptions.aggregatorName = $("#ddlAggregator").val();

            $("#pivotContainer").pivotUI(pivotData, pivotOptions, true);
        });

        function exportPivotToExcel() {
            var table = $("#pivotContainer table.pvtTable");

            if (table.length === 0) {
                alert("No Pivot Table Found!");
                return;
            }

            var uri = "data:application/vnd.ms-excel;base64,";
            var template = `
        <html xmlns:o="urn:schemas-microsoft-com:office:office"
              xmlns:x="urn:schemas-microsoft-com:office:excel"
              xmlns="http://www.w3.org/TR/REC-html40">
        <head><meta charset="UTF-8"></head>
        <body>${table.prop("outerHTML")}</body>
        </html>`;

            var base64 = s => window.btoa(unescape(encodeURIComponent(s)));

            var downloadLink = document.createElement("a");
            downloadLink.href = uri + base64(template);
            downloadLink.download = "ManpowerSummary.xls";

            document.body.appendChild(downloadLink);
            downloadLink.click();
            document.body.removeChild(downloadLink);
        }



        // Load everything on page ready
        $(document).ready(function () {
            loadPivotData();
            
        });
        $(document).ready(function () {
            BindGridView();

        });


        function excelCol(n) {
            let s = "";
            while (n > 0) {
                let m = (n - 1) % 26;
                s = String.fromCharCode(65 + m) + s;
                n = Math.floor((n - m) / 26);
            }
            return s;
        }

        function createNode(doc, nodeName, attrs = {}, text = null) {
            let node = doc.createElement(nodeName);
            Object.keys(attrs).forEach(k => node.setAttribute(k, attrs[k]));
            if (text !== null) {
                let is = doc.createElement("is");
                let t = doc.createElement("t");
                t.appendChild(doc.createTextNode(text));
                is.appendChild(t);
                node.appendChild(is);
            }
            return node;
        }
        function BindGridView() {
            var columns = [];
            let dayCols = [];
            let nightCols = [];
            $.ajax({
                url: "Segmentwisemanpower.aspx/GetSegmentwiseManpower",
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",

                success: function (data) {

                    var res = JSON.parse(data.d);
                    res = res.map(r => {
                        let total = 0;

                        Object.keys(r).forEach(col => {
                            if (col.endsWith(" - Day") || col.endsWith(" - Night")) {
                                total += parseFloat(r[col]) || 0;
                            }
                        });

                        r["Grand Total"] = total;
                        return r;
                    });

                    let cols = Object.keys(res[0]);
                    dayCols = cols.filter(c => c.endsWith(" - Day"));
                    nightCols = cols.filter(c => c.endsWith(" - Night"));

                    //  cols.push("Grand Total");

                    let domains = [...new Set(res.map(x => x.Domain))];
                    let segments = [...new Set(res.map(x => x.Segment))];

                    let h1 = `
                                <th>Domain</th>
                                <th>Segment</th>
                                <th colspan="${dayCols.length}">Day</th>
                                <th colspan="${nightCols.length}">Night</th>
                                <th rowspan="2">Grand Total</th>
                            `;

                    let h2 = `
                            <th>
                                <div class="ms-dd" data-col="0">
                                    <input type="text" class="ms-btn" readonly value="Domain ▾">
                                    <div class="ms-panel">
                                        <label><input type="checkbox" value="__ALL__" checked> All</label>
                                        ${domains.map(d => `<label><input type="checkbox" value="${d}"> ${d}</label>`).join("")}
                                    </div>
                                </div>
                            </th>

                            <th>
                                <div class="ms-dd" data-col="1">
                                    <input type="text" class="ms-btn" readonly value="Segment ▾">
                                    <div class="ms-panel">
                                        <label><input type="checkbox" value="__ALL__" checked> All</label>
                                        ${segments.map(s => `<label><input type="checkbox" value="${s}"> ${s}</label>`).join("")}
                                    </div>
                                </div>
                            </th>
                            `;

                    dayCols.forEach(c => h2 += `<th>${c.replace(" - Day", "")}</th>`);
                    nightCols.forEach(c => h2 += `<th>${c.replace(" - Night", "")}</th>`);
                    //h2 += `<th></th>`;

                    $('#branchPivot thead').html('<tr></tr><tr></tr>');
                    $('#branchPivot thead tr:eq(0)').html(h1);
                    $('#branchPivot thead tr:eq(1)').html(h2);

                    let footerHtml = cols.map((c, i) => {
                        if (i === 0) return "<th><b>Total</b></th>";
                        if (i === 1) return "<th></th>";
                        return "<th class='text-end'></th>";
                    }).join("");

                    $('#branchPivot tfoot tr').html(footerHtml);

                    var table = $('#branchPivot').DataTable({
                        data: res,
                        columns: cols.map(c => ({ data: c })),
                        destroy: true,
                        paging: false,
                        dom: "Bfrtip",
                        orderCellsTop: true,
                        fixedHeader: true,
                        autoWidth: false,
                        retrieve: true,
                        buttons: [
                            {
                                extend: "excelHtml5",
                                filename: "SegmentWise_Manpower_Summary",
                                title: null,
                                exportOptions: {
                                    header: false,       // prevent DataTables from writing its own header
                                    columns: ':visible'
                                },

                            }
                        ],



                        footerCallback: function (row, data, start, end, display) {
                            const api = this.api();

                            const toNum = v => isNaN(parseFloat(v)) ? 0 : parseFloat(v);

                            api.columns().every(function (idx) {
                                if (idx <= 1) return;

                                let sum = 0;

                                api.rows({ filter: "applied" }).every(function () {
                                    const val = this.data()[api.column(idx).dataSrc()];
                                    sum += toNum(val);
                                });

                                $(api.column(idx).footer()).html(`<b>${sum}</b>`);
                            });
                        }
                    });

                    $(document).on("click", ".ms-btn", function (e) {
                        e.stopPropagation();
                        $(".ms-dd").not($(this).parent()).removeClass("open");
                        $(this).parent().toggleClass("open");
                    });

                    $(document).on("click", ".ms-panel", function (e) {
                        e.stopPropagation();
                    });

                    $(document).on("click", function () {
                        $(".ms-dd").removeClass("open");
                    });

                    $(document).on("change", ".ms-panel input[type=checkbox]", function () {

                        const panel = $(this).closest(".ms-panel");
                        const colIndex = $(this).closest(".ms-dd").data("col");

                        // NOT ALL → uncheck ALL
                        if (this.value !== "__ALL__") {
                            panel.find(`input[value="__ALL__"]`).prop("checked", false);
                        }

                        // ALL clicked → uncheck others
                        if (this.value === "__ALL__" && this.checked) {
                            panel.find("input[type=checkbox]").not(this).prop("checked", false);
                            table.column(colIndex).search("").draw();
                            return;
                        }

                        // Collect checked items
                        let values = panel.find("input:checked").map(function () {
                            return this.value;
                        }).get();

                        // Build regex OR pattern
                        let regex = values.map(v => "^" + v + "$").join("|");

                        table.column(colIndex).search(regex, true, false).draw();
                    });

                }
            });




            return false;
        }



        function BindManpowerList() {
            $('#load1').show();
            var columns = [];
            $.ajax({
                url: "Segmentwisemanpower.aspx/GetSegmentwiseManpowerList",
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    var columncount = 0;
                    var dataArray = JSON.parse(data.d);//

                    $.each(dataArray[0], function (key, value) {
                        var my_item = {};
                        my_item.data = key;
                        my_item.title = key;
                        columns.push(my_item);
                    });
                    if ($.fn.DataTable.isDataTable('#mapo_emplist')) {
                        $('#mapo_emplist').DataTable().destroy();
                    }

                    var table = $('#mapo_emplist').DataTable({
                        dom: 'Bft',
                        destroy: true,
                        orderCellsTop: true,
                        fixedColumns: {
                            leftColumns: 2,
                        },
                        scrollCollapse: false,
                        scrollY: '400px',
                        scrollX: true,
                        "paging": false,
                        "autoWidth": true,
                        select: true,
                        "ordering": true,
                        processing: true,
                        'select': {
                            'style': 'single'
                        },
                        "data": dataArray,
                        "columns": columns,
                        buttons: [
                            {
                                extend: 'excelHtml5',
                                filename: 'SegmentWise_Manpower_Details'
                            }
                        ],
                        rowGroup: {
                            dataSrc: null // 👉 Will set dynamically
                        },

                        initComplete: function () {
                            $("#load1").hide();
                        },
                        fnCreatedRow: function (nRow, aData, iDataIndex) {
                            $(nRow).children("td").css("text-wrap", "nowrap");
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

        

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Segment wise manpower</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <div class="card card-tabs">
                    <div class="card-header p-0 pt-1">
                        <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Manpower Summary</a>
                            </li>
                            <li class="nav-item" onclick="return BindManpowerList();">
                                <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">Employee Details</a>
                            </li>

                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                                <table id="branchPivot" class="table table-bordered display nowrap compact" style="width: 100%">
                                    <thead>
                                        <tr></tr>
                                        <tr></tr>
                                    </thead>
                                    <tfoot>
                                        <tr></tr>
                                        <!-- footer will be filled dynamically -->
                                    </tfoot>
                                </table>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                                <div class="panel" style="display:none;">
                                    <h3>Pivot Controls</h3>


                                    <label>Row Field</label>
                                    <select id="ddlRow" class="form-control"></select>


                                    <label>Column Field</label>
                                    <select id="ddlColumn" class="form-control"></select>


                                    <label>Value Field</label>
                                    <select id="ddlValue" class="form-control"></select>


                                    <label>Aggregator</label>
                                    <select id="ddlAggregator" class="form-control">
                                        <option>Count</option>
                                        <option>Sum</option>
                                        <option>Average</option>
                                        <option>Minimum</option>
                                        <option>Maximum</option>
                                    </select>


                                    <br />
                                    <button id="btnGenerate" type="button">Generate Pivot</button>
                                </div>

                                <button id="seg_btnshowpivot" type="button" onclick="return seg_btnshowpivotclick();">Generate Pivot</button>
                                <button id="seg_btnExport" type="button" style="display:none;">Export to Excel</button>
                                <!-- Pivot Output -->
                                <div id="pivotContainer" style="display:none;"></div>

                                <table id="mapo_emplist" class="table table-bordered" style="width: 100%">
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        function seg_btnshowpivotclick() {
            document.getElementById("seg_btnExport").style.display = '';
            document.getElementById("pivotContainer").style.display = '';
            return false;
        }
        $(function () {


            $(document).on("click", "#btnGenerate", function () {
                console.log("Generate Click Fired");

                pivotOptions.rows = $("#ddlRow").val() ? [$("#ddlRow").val()] : [];
                pivotOptions.cols = $("#ddlColumn").val() ? [$("#ddlColumn").val()] : [];
                pivotOptions.vals = $("#ddlValue").val() ? [$("#ddlValue").val()] : [];
                pivotOptions.aggregatorName = $("#ddlAggregator").val();

                $("#pivotContainer").pivotUI(pivotData, pivotOptions, true);
            });

            $(document).on("click", "#seg_btnExport", function () {
                console.log("Export Click Fired");   // test
                exportPivotToExcel();
            });

           
        });
    </script>
</asp:Content>--%>
