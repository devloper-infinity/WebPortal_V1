<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="PMWiseAttritionReport.aspx.cs" Inherits="WebPortal.Admin.PMWiseAttritionReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /*.loading {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 999999;
            background: rgba(255,255,255,.65);
            text-align: center;
            width: 300px;
            height: 300px;
        }

            .loading img {
                position: absolute;
                top: 50%;
                left: 50%;
                width: 70px;
                transform: translate(-50%, -60%);
            }*/

        #load1 .loading-inner {
            position: absolute !important;
            top: 50% !important;
            left: 50% !important;
            transform: translate(-50%, -50%) !important;
            width: min(280px, calc(100vw - 32px));
            max-width: calc(100vw - 32px);
            border-radius: 22px;
            background: #fff;
            padding: 24px 22px;
            box-shadow: 0 24px 55px rgba(15, 23, 42, .28);
        }

        #load1.loading img {
            display: block;
            width: 82px;
            max-width: 82px;
            height: auto;
            margin: 0 auto;
        }

        .loading-text {
            margin-top: 10px;
            font-size: 13px;
            font-weight: 800;
            color: var(--resg-ink);
        }


        .loading div {
            position: absolute;
            top: calc(50% + 45px);
            left: 50%;
            transform: translateX(-50%);
            font-size: 13px;
            font-weight: 700;
            color: #1f2937;
        }

        .pmatr-page {
            background: #f4f7fb;
        }

        .att-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            gap: 22px;
            padding: 20px 25px;
            margin-bottom: 22px;
            border-radius: 20px;
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 55%, #22c1dc 100%);
            box-shadow: 0 18px 38px rgba(37, 99, 235, .24);
        }

            .att-hero:before {
                content: "";
                position: absolute;
                top: -95px;
                right: -70px;
                width: 310px;
                height: 310px;
                border-radius: 50%;
                background: rgba(255,255,255,.14);
            }

            .att-hero:after {
                content: "";
                position: absolute;
                left: -55px;
                bottom: -92px;
                width: 360px;
                height: 180px;
                border-radius: 50%;
                border: 2px solid rgba(255,255,255,.18);
                box-shadow: 38px -26px 0 rgba(255,255,255,.08), 90px -45px 0 rgba(255,255,255,.06);
            }

            .att-hero > * {
                position: relative;
                z-index: 2;
            }

        .att-hero-icon {
            width: 60px;
            height: 60px;
            min-width: 60px;
            border-radius: 20%;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 2px solid rgba(255,255,255,.75);
            background: rgba(255,255,255,.13);
            box-shadow: inset 0 0 0 6px rgba(255,255,255,.08);
        }

            .att-hero-icon i {
                font-size: 32px;
                color: #fff;
            }

        .att-kicker {
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 2px;
            text-transform: uppercase;
            opacity: .92;
            margin-bottom: 4px;
        }

        .att-title {
            margin: 0;
            font-size: 22px;
            font-weight: 800;
            color: #fff;
            line-height: 1.2;
        }

        .att-subtitle {
            margin: 8px 0 0;
            max-width: 850px;
            color: rgba(255,255,255,.92);
            font-size: 13px;
            line-height: 1.6;
        }

        .pmatr-filter-card,
        .pmatr-table-card {
            border: 0;
            border-radius: 16px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, .08);
        }

        .pmatr-filter-grid {
            display: grid;
            grid-template-columns: 1.2fr 1fr 1fr auto;
            gap: 16px;
            align-items: end;
        }

        .pmatr-field label {
            font-size: 13px;
            font-weight: 700;
            color: #334155;
            margin-bottom: 6px;
        }

        .pmatr-field .form-control {
            height: 38px;
            border-radius: 10px;
            font-size: 13px;
        }

        .pmatr-actions {
            display: flex;
            gap: 10px;
            white-space: nowrap;
        }

        .pmatr-btn-primary {
            border: 0;
            color: #fff;
            font-weight: 700;
            border-radius: 10px;
            padding: 9px 18px;
            background: linear-gradient(120deg, #2563eb, #22c1dc);
            box-shadow: 0 8px 18px rgba(37, 99, 235, .25);
        }

        .pmatr-btn-secondary {
            border: 0;
            color: #fff;
            font-weight: 700;
            border-radius: 10px;
            padding: 9px 18px;
            background: linear-gradient(120deg, #10b981, #22c55e) !important;
        }

        .pmatr-tabs .card-header {
            background: #fff;
            border-bottom: 1px solid #e5e7eb;
            border-radius: 16px 16px 0 0;
        }

        .pmatr-tabs .nav-tabs {
            border-bottom: 0;
            gap: 8px;
            padding: 10px;
        }

            .pmatr-tabs .nav-tabs .nav-link {
                border: 0;
                border-radius: 999px;
                color: #475569;
                font-weight: 700;
                font-size: 13px;
                padding: 9px 18px;
                background: #f1f5f9;
            }

                .pmatr-tabs .nav-tabs .nav-link.active {
                    color: #fff;
                    background: linear-gradient(120deg, #2563eb, #22c1dc);
                    box-shadow: 0 6px 14px rgba(37, 99, 235, .22);
                }

        .table.dataTable th {
            background: #edf3f8 !important;
            color: #111827 !important;
            font-size: 12px;
            font-weight: 800;
            white-space: nowrap;
        }

        .table.dataTable td {
            font-size: 12px;
            vertical-align: middle;
            white-space: nowrap;
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
            color: #fff !important;
            box-shadow: none;
            background: linear-gradient(to right, #22c55e, #16a34a) !important;
            border: 0 !important;
            font-weight: bold;
            margin: 0 10px;
            border-radius: 8px !important;
        }

        .dataTables_scrollHeadInner,
        .dataTables_scrollHeadInner table {
            width: 100% !important;
        }

        @media (max-width: 992px) {
            .pmatr-filter-grid {
                grid-template-columns: 1fr 1fr;
            }

            .pmatr-actions {
                grid-column: span 2;
            }
        }

        @media (max-width: 576px) {
            .pmatr-hero {
                flex-direction: column;
                align-items: flex-start;
            }

            .pmatr-filter-grid {
                grid-template-columns: 1fr;
            }

            .pmatr-actions {
                grid-column: span 1;
                flex-direction: column;
            }

            .pmatr-btn-primary,
            .pmatr-btn-secondary {
                width: 100%;
            }
        }
    </style>


    <script>

        $(document).ready(function () {
            pmatr_bindpm();
        });

<%--        function attrition_Exporttoexcel() {
            __doPostBack("<%= btn21.UniqueID %>", '');
            return false;
        }--%>


        function pmatr_bindpm() {
            var select = document.getElementById("pmatr_pm");
            let options = select.getElementsByTagName('option');

            for (var i = options.length; i--;) {
                select.removeChild(options[i]);
            }
            $("#pmatr_pm").append($("<option></option>").val("").html("Select"));
            $.ajax({
                type: "POST", url: "PMWiseAttritionReport.aspx/GetReportingManagerList", dataType: "json", contentType: "application/json",
                success: function (res) {
                    var dataArray = JSON.parse(res.d);
                    $.each(dataArray, function (data, value) {
                        $("#pmatr_pm").append($("<option></option>").val(value.PMID).html(value.PMName));
                    })
                }
            });
        }

        function pmatr_Submit() {
            $('#load1').show();
            var columns = [];
            var fromdate = document.getElementById("pmatr_from").value;
            var todate = document.getElementById("pmatr_to").value;
            var ddlpm = document.getElementById("pmatr_pm");
            var pm = ddlpm.options[ddlpm.selectedIndex].value;

            $.ajax({
                url: "PMWiseAttritionReport.aspx/GetReportingManagerWiseAttrition",
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data: "{FromDate:'" + fromdate + "', ToDate:'" + todate + "',PMID:" + pm + "}",
                success: function (data) {
                    var dataArray = JSON.parse(data.d);//

                    $.each(dataArray[0], function (key, value) {

                        var my_item = {};
                        my_item.data = key;
                        my_item.title = key;
                        columns.push(my_item);
                    });
                    $('#pmatr_table').DataTable({
                        dom: 'lBftip',
                        destroy: true,
                        orderCellsTop: true,
                        fixedHeader: true,
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

        function pmatr_bindnew() {
            $('#load1').show();
            var columns = [];

            $.ajax({
                url: "PMWiseAttritionReport.aspx/GetNewJoined",
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    var dataArray = JSON.parse(data.d);//
                    $.each(dataArray[0], function (key, value) {

                        var my_item = {};
                        my_item.data = key;
                        my_item.title = key;
                        columns.push(my_item);
                    });
                    $('#pmatrnew_table').DataTable({
                        dom: 'lBftip',
                        destroy: true,
                        // scrollX: true,
                        scrollCollapse: true,
                        paging: true,
                        autoWidth: false,   // 🔥 IMPORTANT
                        select: true,
                        ordering: false,
                        processing: true,
                        filter: true,
                        serverSide: false,
                        data: dataArray,
                        columns: columns,


                        initComplete: function () {
                            $('#load1').hide();
                        },
                        buttons: [
                            {
                                extend: 'excelHtml5', title: 'New Joined Employees', autoFilter: true,
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

        function pmatr_bindresigned() {
            $('#load1').show();
            var columns = [];

            $.ajax({
                url: "PMWiseAttritionReport.aspx/GetResignedEmployees",
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    var dataArray = JSON.parse(data.d);//
                    $.each(dataArray[0], function (key, value) {

                        var my_item = {};
                        my_item.data = key;
                        my_item.title = key;
                        columns.push(my_item);
                    });
                    $('#pmatrRes_table').DataTable({
                        dom: 'lBftip',
                        destroy: true,
                        orderCellsTop: true,
                        fixedHeader: true,
                        // scrollX: true,
                        scrollCollapse: true,
                        paging: true,
                        autoWidth: false,   // 🔥 IMPORTANT
                        select: true,
                        ordering: false,
                        processing: true,
                        filter: true,
                        serverSide: false,
                        data: dataArray,
                        columns: columns,
                        fnCreatedRow: function (nRow, aData, iDataIndex) {
                            $(nRow).children("td").css("text-wrap", "nowrap");
                        },

                        initComplete: function () {
                            $('#load1').hide();
                        },
                        buttons: [
                            {
                                extend: 'excelHtml5', title: 'Resigned Employees', autoFilter: true,
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

        function pmatr_Exporttoexcel() {
            __doPostBack("<%= btn21.UniqueID %>", '');
            return false;
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:Button ID="btn21" runat="server" Style="display: none;" OnClick="btn21_Click" />

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div>One moment, please...</div>
    </div>

    <div class="pmatr-page">

        <div class="att-hero">
            <span class="att-hero-icon"><i class="fas fa-chart-line"></i></span>
            <div>
                <h1 class="att-title">Attrition Report - Reporting Manager</h1>
                <p class="att-subtitle">Review employee attrition, new joining, resignation and absconding details by reporting manager and date range.</p>
            </div>
        </div>
        <div class="card pmatr-filter-card mb-3">
            <div class="card-body">
                <div class="pmatr-filter-grid">

                    <div class="pmatr-field">
                        <label>Reporting Manager</label>
                        <select id="pmatr_pm" name="pmatr_pm" class="form-control"></select>
                    </div>

                    <div class="pmatr-field">
                        <label>From Date</label>
                        <input type="date" id="pmatr_from" name="pmatr_from" class="form-control" />
                    </div>

                    <div class="pmatr-field">
                        <label>To Date</label>
                        <input type="date" id="pmatr_to" name="pmatr_to" class="form-control" />
                    </div>

                    <div class="pmatr-actions">
                        <button id="pmatr_btnShow" class="pmatr-btn-primary" onclick="return pmatr_Submit();">
                            <i class="fas fa-search mr-1"></i>Show
                        </button>

                        <button id="pmatr_btnExporttoexcel" class="pmatr-btn-secondary" onclick="return pmatr_Exporttoexcel();">
                            <i class="fas fa-file-excel mr-1"></i>Export
                        </button>
                    </div>

                </div>
            </div>
        </div>

        <div class="card pmatr-table-card pmatr-tabs">
            <div class="card-header p-0">
                <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link active"
                            id="custom-tabs-one-home-tab"
                            data-toggle="pill"
                            href="#custom-tabs-one-home"
                            role="tab"
                            aria-controls="custom-tabs-one-home"
                            aria-selected="true">
                            <i class="fas fa-chart-pie mr-1"></i>Summary
                        </a>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link"
                            onclick="return pmatr_bindnew();"
                            id="custom-tabs-one-profile-tab"
                            data-toggle="pill"
                            href="#custom-tabs-one-profile"
                            role="tab"
                            aria-controls="custom-tabs-one-profile"
                            aria-selected="false">
                            <i class="fas fa-user-plus mr-1"></i>New Joined
                        </a>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link"
                            onclick="return pmatr_bindresigned();"
                            id="custom-tabs-one-exclude-tab"
                            data-toggle="pill"
                            href="#custom-tabs-one-exclude"
                            role="tab"
                            aria-controls="custom-tabs-one-exclude"
                            aria-selected="false">
                            <i class="fas fa-user-minus mr-1"></i>Absconding / Resigned
                        </a>
                    </li>
                </ul>
            </div>

            <div class="card-body">
                <div class="tab-content" id="custom-tabs-one-tabContent">

                    <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                        <div style="overflow: auto">
                            <table class="table table-bordered table-hover nowrap" style="width: 100%;" id="pmatr_table"></table>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                        <div style="overflow: auto">
                            <table class="table table-bordered table-hover nowrap" style="width: 100%;" id="pmatrnew_table"></table>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="custom-tabs-one-exclude" role="tabpanel" aria-labelledby="custom-tabs-one-exclude-tab">
                        <div style="overflow: auto">
                            <table class="table table-bordered table-hover nowrap" style="width: 100%;" id="pmatrRes_table"></table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
