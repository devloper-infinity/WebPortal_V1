<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ProductivityUpdate.aspx.cs" Inherits="WebPortal.Admin.ProductivityUpdate" %>



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

        body { background: var(--ud-bg); }

        .ud-page { width: 100%; }

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

        .ud-hero:before { width: 220px; height: 220px; right: 70px; top: -120px; }
        .ud-hero:after { width: 300px; height: 300px; right: -90px; bottom: -170px; }

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

        .ud-hero-content { position: relative; z-index: 1; }
        .ud-title { margin: 0; font-size: 19px; font-weight: 800; letter-spacing: -.02em; }
        .ud-subtitle { margin: 8px 0 0; font-size: 12px; opacity: .9; }

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

        .ud-filter-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(220px, 280px)) auto;
            align-items: end;
            gap: 16px;
            margin-bottom: 18px;
        }

        .ud-field label {
            display: block;
            margin-bottom: 8px;
            color: var(--ud-muted);
            font-size: 12px;
            font-weight: 800;
            letter-spacing: .02em;
        }

        .form-control,
        input[type="date"],
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
        input[type="date"]:focus,
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
        }

        .btn:hover,
        button:hover,
        .dt-button:hover,
        .buttons-excel:hover {
            transform: translateY(-1px);
            box-shadow: 0 16px 30px rgba(37, 99, 235, .30) !important;
        }

        #updup_btnexport { background: linear-gradient(135deg, #22c55e, #15803d) !important; }

        .ud-table-wrap {
            width: 100%;
            overflow-x: auto;
            border: 1px solid var(--ud-border);
            border-radius: 18px;
            background: #fff;
        }

        #updup_tableprod,
        table.dataTable {
            width: 100% !important;
            margin: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0;
            white-space: nowrap;
        }

        #updup_tableprod thead th,
        table.dataTable thead th,
        .table.dataTable th {
            border: 0 !important;
            font-size: 12px;
            font-weight: 900;
            text-align: center;
            vertical-align: middle;
            letter-spacing: .02em;
        }

        #updup_tableprod tbody td,
        table.dataTable tbody td,
        .table.dataTable tr td {
            padding: 11px 12px !important;
            border-bottom: 1px solid var(--ud-border) !important;
            color: #334155;
            font-size: 13px;
            vertical-align: middle;
            background: #fff !important;
        }

        #updup_tableprod tbody tr:hover td,
        table.dataTable tbody tr:hover td { background: #f8fbff !important; }

        table.dataTable thead th::before,
        table.dataTable thead th::after { display: none !important; }

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

        .dataTables_filter { margin-left: auto; }
        .dataTables_filter input,
        .dataTables_length select {
            min-height: 34px;
            border: 1px solid var(--ud-border);
            border-radius: 12px;
            padding: 6px 10px;
            font-size: 12px;
            outline: none;
        }

        .dataTables_paginate { float: left !important; }
        .dt-center { text-align: center; }

        .singleCheck { accent-color: var(--ud-primary); margin: 0 6px 0 0; }
        .remarkInput { min-width: 250px; }

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

        .loading img { max-width: 72px; margin-bottom: 12px; }
        .loading div { color: var(--ud-text); font-size: 12px; font-weight: 800; }

        #waitingpanel .modal-dialog {
            min-height: 60vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        @media (max-width: 768px) {
            .ud-page { padding: 0 8px 20px; }
            .ud-hero { padding: 20px; align-items: flex-start; }
            .ud-filter-grid { grid-template-columns: 1fr; }
            .ud-card { padding: 16px; }
        }
    </style>
    <script>
        $(document).ready(function () {
        });

        function blankForNull(s) {
            return s == "null" || s == null ? "" : s;
        }

        $(document).on("click", ".singleCheck", function (e) {
            // Ignore datatable redraw / script trigger
            if (!e.originalEvent) return;

            const id = $(this).attr("id").split("_")[1]; // row index
            const type = $(this).hasClass("nodata") ? "No Volume" : "Low Volume";
            const isChecked = $(this).is(":checked");

            if (type === "No Volume") {
                UpdateNoVolume(id, isChecked);
            } else {
                UpdateLowVolume(id, isChecked);
            }
        });

        $(document).on("change", ".remarkInput", function (e) {
            if (!e.originalEvent) return; // ignore programmatic changes

            let rowId = $(this).attr("id").split("_")[1];
            let value = $(this).val();

            UpdateRemark(rowId, value);
        });

        function BindGridView() {
            $('#load1').show();
            var FromDate = document.getElementById("updup_fromdate").value;
            var ToDate = document.getElementById("updup_todate").value;
            FromDate = '31-Oct-2025'
            ToDate = '31-Oct-2025'
            var columns = [];
            $.ajax({
                url: "ProductivityUpdate.aspx/GetProductivityForUpdate",
                type: "POST",
                dataType: "json",
                data: "{FromDate:'" + FromDate + "', ToDate:'" + ToDate + "'}",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    var columncount = 0;
                    var dataArray = JSON.parse(data.d);//
                    $.each(dataArray[0], function (key, value) {
                        var my_item = {};
                        my_item.data = key;
                        my_item.title = key;
                        columns.push(my_item);
                        columncount++;
                    });
                    $('#updup_tableprod').DataTable({
                        dom: 'ft',
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

                        initComplete: function () {
                            $("#load1").hide();
                        },
                        buttons: [

                            {
                                extend: 'excelHtml5', title: 'Daily Production Update', autoFilter: true,
                                className: 'btn btn-datatable',
                                exportOptions: {
                                    columns: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
                                }
                            }
                        ],
                        columnDefs: [
                            {
                                targets: (columncount - 3),
                                "width": "45px",
                                render: function (data, type, row, meta) {
                                    if (parseFloat(row.TotalProduction) < 100) {
                                        if (blankForNull(row.Actions) == "Zero Volume") {
                                            return '<input type="checkbox" checked="checked" id="nodata_' + meta.row + '" name="volume_' + meta.row + '" class="singleCheck nodata" value="No Volume" /> No Volume &nbsp;&nbsp;' +
                                                '<input type="checkbox" id="lowdata_' + meta.row + '" name="volume_' + meta.row + '" class="singleCheck lowdata" value="Low Volume" /> Low Volume';
                                        }
                                        else if (blankForNull(row.Actions) == "Low Volume") {
                                            return '<input type="checkbox" id="nodata_' + meta.row + '" name="volume_' + meta.row + '" class="singleCheck nodata" value="No Volume" /> No Volume &nbsp;&nbsp;' +
                                                '<input type="checkbox" checked="checked" id="lowdata_' + meta.row + '" name="volume_' + meta.row + '" class="singleCheck lowdata" value="Low Volume" /> Low Volume';
                                        }
                                        else {
                                            return '<input type="checkbox" id="nodata_' + meta.row + '" name="volume_' + meta.row + '" class="singleCheck nodata" value="No Volume" /> No Volume &nbsp;&nbsp;' +
                                                '<input type="checkbox" id="lowdata_' + meta.row + '" name="volume_' + meta.row + '" class="singleCheck lowdata" value="Low Volume" /> Low Volume';
                                        }
                                    }
                                    else {
                                        return '<input type="checkbox" disabled="disabled" name="volume_' + meta.row + '" class="singleCheck" value="No Volume" onclick="return UpdateNoVolume(\'' + meta.row + '\');" /> No Volume &nbsp;&nbsp;' +
                                            '<input type="checkbox" disabled="disabled" name="volume_' + meta.row + '" class="singleCheck" value="Low Volume" onclick="return UpdateLowVolume(\'' + meta.row + '\');" /> Low Volume';
                                    }
                                }
                            },
                            {
                                targets: (columncount - 2),
                                "width": "45px",
                                render: function (data, type, row, meta) {
                                    if (parseFloat(row.TotalProduction) < 100) {
                                        if (blankForNull(row.Remark) != "")
                                            return '<input type="text" value="' + row.Remark + '" id="remark_' + meta.row + '" class="form-control remarkInput" style="width:250px;" /> ';
                                        else
                                            return '<input type="text" id="remark_' + meta.row + '" class="form-control remarkInput" style="width:250px;" /> ';
                                    }
                                    else {
                                        return '<input type="text" id="remark_' + meta.row + '" disabled="disabled" class="form-control" style="width:250px;" /> ';
                                    }
                                }

                            },
                            {
                                targets: (columncount - 1),
                                visible: false
                            }
                        ],

                        fnCreatedRow: function (nRow, aData, iDataIndex) {
                            $(nRow).children("td").css("text-wrap", "nowrap");
                            $(nRow).children("td").css("text-align", "center");
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

        function UpdateNoVolume(index, value) {
            var rows = $('#updup_tableprod').DataTable().row(index).data();
            var Code = rows["Code"];
            var Project = rows["Project #"];
            var Process = rows["Process"];
            var ProcessDate = rows["Process Date"];
            var radiono = document.getElementById("nodata_" + index);
            if (value == true) {
                document.getElementById("lowdata_" + index).checked = false;
            }
            var VolumeData = "Zero Volume";
            var Type = "Volume";
            var Remark = "";
            var checked = value;
            PageMethods.UpdateVolumeData(Code, Project, Process, ProcessDate, VolumeData, Remark, Type, checked, updatenovolume_OnSuccess, updatenovolume_OnError);
            return false;
        }
        function updatenovolume_OnSuccess(result) {

            return false;
        }
        function updatenovolume_OnError(error) {
            alert(error.get_message());
            return false;
        }
        function UpdateLowVolume(index, value) {
            var rows = $('#updup_tableprod').DataTable().row(index).data();
            var Code = rows["Code"];
            var Project = rows["Project #"];
            var Process = rows["Process"];
            var ProcessDate = rows["Process Date"];
            var radiono = document.getElementById("lowdata_" + index);
            if (value == true) {
                document.getElementById("nodata_" + index).checked = false;
            }
            var VolumeData = "Low Volume";
            var Type = "Volume";
            var checked = value;
            var Remark = "";
            PageMethods.UpdateVolumeData(Code, Project, Process, ProcessDate, VolumeData, Remark, Type, checked, updatelowvolume_OnSuccess, updatelowvolume_OnError);
            return false;
        }
        function updatelowvolume_OnSuccess(result) {
            return false;
        }
        function updatelowvolume_OnError(error) {
            alert(error.get_message());
            return false;
        }

        function UpdateRemark(index, value) {
            var rows = $('#updup_tableprod').DataTable().row(index).data();
            var Code = rows["Code"];
            var Project = rows["Project #"];
            var Process = rows["Process"];
            var ProcessDate = rows["Process Date"];
            var radiono = document.getElementById("lowdata_" + index);
            if (radiono.checked == true) {
                document.getElementById("nodata_" + index).checked = false;
            }
            var VolumeData = "";
            var Type = "Remark";
            var Remark = value;
            var checked = false;
            PageMethods.UpdateVolumeData(Code, Project, Process, ProcessDate, VolumeData, Remark, Type, checked, updatelowvolume_OnSuccess, updatelowvolume_OnError);
            return false;
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" alt="Loading" />
        <div>One moment, please . . . .</div>
    </div>

    <div class="ud-page">
        <div class="ud-hero">
            <div class="ud-hero-icon"><i class="bi bi-clipboard-data"></i></div>
            <div class="ud-hero-content">
                <h1 class="ud-title">User Production Updates</h1>
                <p class="ud-subtitle">Review production volume, mark low or zero volume entries, and update remarks from one workspace.</p>
            </div>
        </div>

        <div class="ud-card">
            <div class="ud-section-title">
                <i class="bi bi-funnel"></i>
                <span>Filter Production Data</span>
            </div>

            <div class="ud-filter-grid">
                <div class="ud-field">
                    <label for="updup_fromdate">From Date</label>
                    <input type="date" id="updup_fromdate" name="updup_fromdate" class="form-control" />
                </div>
                <div class="ud-field">
                    <label for="updup_todate">To Date</label>
                    <input type="date" id="updup_todate" name="updup_todate" class="form-control" />
                </div>
                <div class="ud-field">
                    <button id="updup_btnsubmit" name="updup_btnsubmit" onclick="return BindGridView();" class="btn btn-primary">
                        <i class="bi bi-search"></i> Submit
                    </button>
                    <button id="updup_btnexport" name="updup_btnsubmit" style="display: none;" onclick="return updup_export();" class="btn btn-primary">
                        <i class="bi bi-file-earmark-excel"></i> Export to Excel
                    </button>
                </div>
            </div>
        </div>

        <div class="ud-card">
            <div class="ud-section-title">
                <i class="bi bi-table"></i>
                <span>Production Update List</span>
            </div>
            <div class="ud-table-wrap">
                <table class="table table-bordered" id="updup_tableprod" style="width: 100%;"></table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" alt="Loading" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">System is updating details. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>
</asp:Content>


<%--<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
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
        /*.form-control {
            font-size: 11px !important;
        }*/
    </style>
    <script>
        $(document).ready(function () {
        });

        function blankForNull(s) {
            return s == "null" || s == null ? "" : s;
        }

        $(document).on("click", ".singleCheck", function (e) {
            // Ignore datatable redraw / script trigger
            if (!e.originalEvent) return;

            const id = $(this).attr("id").split("_")[1]; // row index
            const type = $(this).hasClass("nodata") ? "No Volume" : "Low Volume";
            const isChecked = $(this).is(":checked");

            if (type === "No Volume") {
                UpdateNoVolume(id, isChecked);
            } else {
                UpdateLowVolume(id, isChecked);
            }
        });

        $(document).on("change", ".remarkInput", function (e) {
            if (!e.originalEvent) return; // ignore programmatic changes

            let rowId = $(this).attr("id").split("_")[1];
            let value = $(this).val();

            UpdateRemark(rowId, value);
        });

        function BindGridView() {
            $('#load1').show();
            var FromDate = document.getElementById("updup_fromdate").value;
            var ToDate = document.getElementById("updup_todate").value;
            FromDate = '31-Oct-2025'
            ToDate = '31-Oct-2025'
            var columns = [];
            $.ajax({
                url: "ProductivityUpdate.aspx/GetProductivityForUpdate",
                type: "POST",
                dataType: "json",
                data: "{FromDate:'" + FromDate + "', ToDate:'" + ToDate + "'}",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    var columncount = 0;
                    var dataArray = JSON.parse(data.d);//
                    $.each(dataArray[0], function (key, value) {
                        var my_item = {};
                        my_item.data = key;
                        my_item.title = key;
                        columns.push(my_item);
                        columncount++;
                    });
                    $('#updup_tableprod').DataTable({
                        dom: 'ft',
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

                        initComplete: function () {
                            $("#load1").hide();
                        },
                        buttons: [

                            {
                                extend: 'excelHtml5', title: 'Daily Production Update', autoFilter: true,
                                className: 'btn btn-datatable',
                                exportOptions: {
                                    columns: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
                                }
                            }
                        ],
                        columnDefs: [
                            {
                                targets: (columncount - 3),
                                "width": "45px",
                                render: function (data, type, row, meta) {
                                    if (parseFloat(row.TotalProduction) < 100) {
                                        if (blankForNull(row.Actions) == "Zero Volume") {
                                            return '<input type="checkbox" checked="checked" id="nodata_' + meta.row + '" name="volume_' + meta.row + '" class="singleCheck nodata" value="No Volume" /> No Volume &nbsp;&nbsp;' +
                                                '<input type="checkbox" id="lowdata_' + meta.row + '" name="volume_' + meta.row + '" class="singleCheck lowdata" value="Low Volume" /> Low Volume';
                                        }
                                        else if (blankForNull(row.Actions) == "Low Volume") {
                                            return '<input type="checkbox" id="nodata_' + meta.row + '" name="volume_' + meta.row + '" class="singleCheck nodata" value="No Volume" /> No Volume &nbsp;&nbsp;' +
                                                '<input type="checkbox" checked="checked" id="lowdata_' + meta.row + '" name="volume_' + meta.row + '" class="singleCheck lowdata" value="Low Volume" /> Low Volume';
                                        }
                                        else {
                                            return '<input type="checkbox" id="nodata_' + meta.row + '" name="volume_' + meta.row + '" class="singleCheck nodata" value="No Volume" /> No Volume &nbsp;&nbsp;' +
                                                '<input type="checkbox" id="lowdata_' + meta.row + '" name="volume_' + meta.row + '" class="singleCheck lowdata" value="Low Volume" /> Low Volume';
                                        }
                                    }
                                    else {
                                        return '<input type="checkbox" disabled="disabled" name="volume_' + meta.row + '" class="singleCheck" value="No Volume" onclick="return UpdateNoVolume(\'' + meta.row + '\');" /> No Volume &nbsp;&nbsp;' +
                                            '<input type="checkbox" disabled="disabled" name="volume_' + meta.row + '" class="singleCheck" value="Low Volume" onclick="return UpdateLowVolume(\'' + meta.row + '\');" /> Low Volume';
                                    }
                                }
                            },
                            {
                                targets: (columncount - 2),
                                "width": "45px",
                                render: function (data, type, row, meta) {
                                    if (parseFloat(row.TotalProduction) < 100) {
                                        if (blankForNull(row.Remark) != "")
                                            return '<input type="text" value="' + row.Remark + '" id="remark_' + meta.row + '" class="form-control remarkInput" style="width:250px;" /> ';
                                        else
                                            return '<input type="text" id="remark_' + meta.row + '" class="form-control remarkInput" style="width:250px;" /> ';
                                    }
                                    else {
                                        return '<input type="text" id="remark_' + meta.row + '" disabled="disabled" class="form-control" style="width:250px;" /> ';
                                    }
                                }

                            },
                            {
                                targets: (columncount - 1),
                                visible: false
                            }
                        ],

                        fnCreatedRow: function (nRow, aData, iDataIndex) {
                            $(nRow).children("td").css("text-wrap", "nowrap");
                            $(nRow).children("td").css("text-align", "center");
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

        function UpdateNoVolume(index, value) {
            var rows = $('#updup_tableprod').DataTable().row(index).data();
            var Code = rows["Code"];
            var Project = rows["Project #"];
            var Process = rows["Process"];
            var ProcessDate = rows["Process Date"];
            var radiono = document.getElementById("nodata_" + index);
            if (value == true) {
                document.getElementById("lowdata_" + index).checked = false;
            }
            var VolumeData = "Zero Volume";
            var Type = "Volume";
            var Remark = "";
            var checked = value;
            PageMethods.UpdateVolumeData(Code, Project, Process, ProcessDate, VolumeData, Remark, Type, checked, updatenovolume_OnSuccess, updatenovolume_OnError);
            return false;
        }
        function updatenovolume_OnSuccess(result) {

            return false;
        }
        function updatenovolume_OnError(error) {
            alert(error.get_message());
            return false;
        }
        function UpdateLowVolume(index, value) {
            var rows = $('#updup_tableprod').DataTable().row(index).data();
            var Code = rows["Code"];
            var Project = rows["Project #"];
            var Process = rows["Process"];
            var ProcessDate = rows["Process Date"];
            var radiono = document.getElementById("lowdata_" + index);
            if (value == true) {
                document.getElementById("nodata_" + index).checked = false;
            }
            var VolumeData = "Low Volume";
            var Type = "Volume";
            var checked = value;
            var Remark = "";
            PageMethods.UpdateVolumeData(Code, Project, Process, ProcessDate, VolumeData, Remark, Type, checked, updatelowvolume_OnSuccess, updatelowvolume_OnError);
            return false;
        }
        function updatelowvolume_OnSuccess(result) {
            return false;
        }
        function updatelowvolume_OnError(error) {
            alert(error.get_message());
            return false;
        }

        function UpdateRemark(index, value) {
            var rows = $('#updup_tableprod').DataTable().row(index).data();
            var Code = rows["Code"];
            var Project = rows["Project #"];
            var Process = rows["Process"];
            var ProcessDate = rows["Process Date"];
            var radiono = document.getElementById("lowdata_" + index);
            if (radiono.checked == true) {
                document.getElementById("nodata_" + index).checked = false;
            }
            var VolumeData = "";
            var Type = "Remark";
            var Remark = value;
            var checked = false;
            PageMethods.UpdateVolumeData(Code, Project, Process, ProcessDate, VolumeData, Remark, Type, checked, updatelowvolume_OnSuccess, updatelowvolume_OnError);
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>User Production Updates</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <table class="table">
                    <tr>
                        <td><b>From Date:</b></td>
                        <td>
                            <input type="date" id="updup_fromdate" name="updup_fromdate" class="form-control" style="width: 250px;" />
                        </td>
                        <td><b>To Date:</b></td>
                        <td>
                            <input type="date" id="updup_todate" name="updup_todate" class="form-control" style="width: 250px;" />
                        </td>
                        <td>
                            <button id="updup_btnsubmit" name="updup_btnsubmit" onclick="return BindGridView();" class="btn btn-primary">Submit</button>
                            <button id="updup_btnexport" name="updup_btnsubmit" style="display: none;" onclick="return updup_export();" class="btn btn-primary">Export to excel</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <table class="table table-bordered" id="updup_tableprod" style="width: 100%;">
                </table>
            </div>
        </div>
    </div>
    <div class="modal fade" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">System is updating details. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>
</asp:Content>--%>
