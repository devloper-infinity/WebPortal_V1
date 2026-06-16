<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Segmentwisemanpower.aspx.cs" Inherits="WebPortal.Admin.Segmentwisemanpower" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">


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
</asp:Content>
