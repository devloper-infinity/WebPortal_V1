<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="BranchAndDateWiseAttendanceReport.aspx.cs" Inherits="WebPortal.Admin.BranchAndDateWiseAttendanceReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --bda-primary: #1f3c88;
            --bda-blue: #2575fc;
            --bda-cyan: #1bc5e8;
            --bda-bg: #f4f7fb;
            --bda-card: #ffffff;
            --bda-text: #172033;
            --bda-muted: #64748b;
            --bda-border: #dbe3ef;
            --bda-shadow: 0 12px 28px rgba(21, 98, 228, .12);
        }

        body {
            background: var(--bda-bg);
        }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 99999;
            background: rgba(255,255,255,.72);
            backdrop-filter: blur(3px);
            align-items: center;
            justify-content: center;
            flex-direction: column;
            text-align: center;
        }

            .loading img {
                width: 70px;
                height: 70px;
            }

            .loading div {
                margin-top: 10px;
                color: var(--bda-text);
                font-size: 12px;
                font-weight: 700;
            }

        .bda-page {
            background: var(--bda-bg);
            min-height: calc(100vh - 90px);
        }

        .bda-hero {
            display: flex;
            align-items: center;
            gap: 20px;
            padding: 17px 35px;
            margin-bottom: 22px;
            border-radius: 20px;
            color: #fff;
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            box-shadow: var(--bda-shadow);
        }

        .bda-hero-icon {
            width: 50px;
            height: 50px;
            min-width: 50px;
            border-radius: 8px;
            border: 2px solid rgba(255,255,255,.75);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.10);
        }

            .bda-hero-icon i {
                color: #fff;
                font-size: 28px;
            }

        .bda-title {
            margin: 0;
            color: #fff;
            font-size: 20px;
            font-weight: 800;
            line-height: 1.2;
        }

        .bda-subtitle {
            margin: 8px 0 0;
            color: rgba(255,255,255,.92);
            font-size: 13px;
            line-height: 1.5;
        }

        .bda-panel {
            margin-bottom: 18px;
            border: 1px solid var(--bda-border);
            border-radius: 8px;
            background: var(--bda-card);
            box-shadow: 0 10px 24px rgba(15, 23, 42, .06);
        }

        .bda-panel-body {
            padding: 18px;
        }

        .bda-filter-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(180px, 1fr));
            gap: 14px;
            align-items: end;
        }

        .bda-field label {
            display: block;
            margin-bottom: 6px;
            color: #334155;
            font-size: 13px;
            font-weight: 700 !important;
        }

        .bda-field .form-control {
            min-height: 42px;
            border-radius: 8px;
            border: 1px solid #d1d5db;
            background: #fff;
            color: var(--bda-text);
            font-size: 13px;
            box-shadow: 0 1px 2px rgba(15, 23, 42, .03);
        }

            .bda-field .form-control:focus {
                border-color: rgba(37, 117, 252, .68);
                box-shadow: 0 0 0 .15rem rgba(37, 117, 252, .14);
            }

        .bda-actions {
            display: flex;
            gap: 10px;
            align-items: end;
        }

        .bda-btn {
            min-height: 42px;
            min-width: 122px;
            border: 0;
            border-radius: 8px;
            color: #fff !important;
            font-size: 13px;
            font-weight: 800;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: .2s ease;
        }

            .bda-btn:hover {
                color: #fff !important;
                transform: translateY(-1px);
                box-shadow: 0 10px 18px rgba(15, 23, 42, .14);
            }

        .bda-btn-primary {
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 60%, #1bc5e8 100%);
        }

        .bda-btn-muted {
            background: #f1f5f9;
            color: #334155 !important;
            border: 1px solid #dbe3ef;
        }

            .bda-btn-muted:hover {
                color: #334155 !important;
            }

        .bda-table-panel {
            border: 1px solid var(--bda-border);
            border-radius: 8px;
            overflow: hidden;
            background: #fff;
            box-shadow: 0 10px 24px rgba(15, 23, 42, .06);
        }

        .bda-table-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            padding: 14px 16px;
            border-bottom: 1px solid var(--bda-border);
            background: #f8fafc;
        }

        .bda-table-title {
            margin: 0;
            color: #0f172a;
            font-size: 16px;
            font-weight: 800;
        }

        .bda-count {
            color: var(--bda-muted);
            font-size: 12px;
            font-weight: 700;
        }

        .bda-table-wrap {
            padding: 12px;
            overflow-x: auto;
        }

        #bda_table {
            width: 100% !important;
            margin-bottom: 0;
        }

            #bda_table thead th {
                background: #edf3f6 !important;
                color: #0f172a !important;
                font-size: 12px;
                font-weight: 800;
                white-space: nowrap;
                vertical-align: middle;
                border-bottom: 1px solid #dbe3ef !important;
                text-align: center;
            }

            #bda_table tbody td {
                color: #334155;
                font-size: 12px;
                vertical-align: middle;
                white-space: nowrap;
                text-align: center;
            }

                #bda_table tbody td:first-child {
                    text-align: left;
                }

            #bda_table tbody tr:hover td {
                background: #f8fbff !important;
            }

        .dataTables_wrapper .dataTables_filter input,
        .dataTables_wrapper .dataTables_length select {
            height: 34px;
            border: 1px solid #dbe3ef;
            border-radius: 8px;
            padding: 5px 9px;
        }

        div.dt-buttons {
            float: left;
            margin: 0 0 8px 12px;
        }

        .buttons-excel,
        .buttons-html5,
        .dt-button {
            border: 0 !important;
            border-radius: 8px !important;
            color: #fff !important;
            background: linear-gradient(90deg, #10b981, #22c55e) !important;
            font-size: 12px !important;
            font-weight: 800 !important;
            padding: 6px 13px !important;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            border: none !important;
        }

        @media (max-width: 992px) {
            .bda-filter-grid {
                grid-template-columns: repeat(2, minmax(180px, 1fr));
            }

            .bda-actions {
                grid-column: 1 / -1;
            }
        }

        @media (max-width: 576px) {
            .bda-hero {
                padding: 16px;
                align-items: flex-start;
            }

            .bda-hero-icon {
                width: 46px;
                height: 46px;
                min-width: 46px;
            }

            .bda-filter-grid {
                grid-template-columns: 1fr;
            }

            .bda-actions {
                flex-direction: column;
                align-items: stretch;
            }

            .bda-btn {
                width: 100%;
            }

            .bda-table-head {
                align-items: flex-start;
                flex-direction: column;
            }
        }

        /* DataTable Footer */
        #bda_table tfoot th {
            background: #EDF3F6 !important;
            font-weight: 700;
            text-align: center !important;
            vertical-align: middle;
            border: 1px solid #d6e4f0;
            padding: 10px 8px;
            white-space: nowrap;
        }

            #bda_table tfoot th:first-child {
                text-align: center !important;
            }
    </style>

    <script>
        var bdaTable = null;

        $(document).ready(function () {
            bdaBindMonthYear();
            // bdaRenderTable([]);
        });

        function bdaBindMonthYear() {
            var months = [
                "January", "February", "March", "April", "May", "June",
                "July", "August", "September", "October", "November", "December"
            ];
            var now = new Date();
            var ddlMonth = $("#bda_month");
            var ddlYear = $("#bda_year");
            var currentYear = now.getFullYear();
            var i;

            ddlMonth.empty();
            ddlMonth.append($("<option></option>").val("").text("Select Month"));

            for (i = 0; i < months.length; i++) {
                ddlMonth.append($("<option></option>").val(months[i]).text(months[i]));
            }

            ddlMonth.val(months[now.getMonth()]);

            ddlYear.empty();
            ddlYear.append($("<option></option>").val("").text("Select Year"));

            for (i = currentYear - 5; i <= currentYear + 1; i++) {
                ddlYear.append($("<option></option>").val(String(i)).text(String(i)));
            }

            ddlYear.val(String(currentYear));
        }

        function bdaShowReport() {

            var month = $("#bda_month").val();
            var year = $("#bda_year").val();

            if (month === "") {
                bdaNotify("Please select month.");
                $("#bda_month").focus();
                return false;
            }

            if (year === "") {
                bdaNotify("Please select year.");
                $("#bda_year").focus();
                return false;
            }

            $("#load1").css("display", "flex");

            bd_bindGrid(month, year);

            return false;
        }

        var bda_table = null;

        var bda_table = null;

        function bd_bindGrid(month, year) {

            $('#load1').show();

            $.ajax({
                type: "POST",
                url: "BranchAndDateWiseAttendanceReport.aspx/GetBranchAndDateWiseAttendanceReport",
                data: JSON.stringify({ Month: month, Year: year }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (data) {

                    var result = JSON.parse(data.d || "{}");
                    var dataArray = result.Rows || [];

                    console.log(dataArray);

                    if ($.fn.DataTable.isDataTable('#bda_table')) {
                        $('#bda_table').DataTable().clear().destroy();
                    }

                    bda_table = $('#bda_table').DataTable({
                        data: dataArray,
                        dom: 'Bfrtip',
                        paging: false,
                        searching: true,
                        info: true,
                        autoWidth: false,
                        ordering: false,
                        processing: true,
                        deferRender: true,

                        buttons: [
                            {
                                extend: 'excelHtml5',
                                text: 'Excel',
                                className: 'btn btn-success',
                                title: 'Date Wise Attendance Details',
                                footer: true
                            }
                        ],

                        columns: [
                            {
                                data: null,
                                className: "text-center text-nowrap",
                                render: function (data, type, row, meta) {
                                    return meta.row + 1;
                                }
                            },
                            { data: "AttendanceDate", defaultContent: "" },
                            { data: "DayName", defaultContent: "" },
                            // { data: "DomainName", defaultContent: "" },
                            // { data: "SubDomain", defaultContent: "" },
                            { data: "AJ", defaultContent: "0" },
                            { data: "KP", defaultContent: "0" },
                            { data: "Akola", defaultContent: "0" },
                            { data: "Bangalore", defaultContent: "0" },
                            { data: "Solapur", defaultContent: "0" },
                            { data: "Total", defaultContent: "0" }
                        ],

                        footerCallback: function () {

                            var api = this.api();

                            var intVal = function (i) {
                                return parseInt(i, 10) || 0;
                            };

                            for (var col = 3; col <= 8; col++) {

                                var total = api.column(col).data().reduce(function (a, b) {
                                    return intVal(a) + intVal(b);
                                }, 0);

                                $(api.column(col).footer())
                                    .html(total)
                                    .css({
                                        "text-align": "center",
                                        "font-weight": "700",
                                        "vertical-align": "middle"
                                    });
                            }

                            $(api.column(0).footer())
                                .attr("colspan", 3)
                                .html("Grand Total")
                                .css({
                                    "text-align": "center",
                                    "font-weight": "700"
                                });
                        },

                        initComplete: function () {
                            $('#load1').hide();
                            this.api().columns.adjust();
                        }
                    });
                },

                error: function (error) {
                    $('#load1').hide();
                    alert('error: ' + error.responseText);
                }
            });

            return false;
        }



        function bdaClearReport() {
            bdaBindMonthYear();
            return false;
        }


        function bdaNotify(message) {
            if (window.Swal) {
                Swal.fire("Validation", message, "warning");
            }
            else {
                alert(message);
            }
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div>One moment, please...</div>
    </div>

    <div class="bda-page">
        <div class="bda-hero">
            <span class="bda-hero-icon">
                <i class="fas fa-calendar-check"></i>
            </span>
            <div>
                <h1 class="bda-title">Branch And Date Wise Attendance Report</h1>
                <p class="bda-subtitle">View daily attendance counts branch wise for the selected month and year.</p>
            </div>
        </div>

        <div class="bda-panel">
            <div class="bda-panel-body">
                <div class="bda-filter-grid">
                    <div class="bda-field">
                        <label for="bda_month"><i class="far fa-calendar-alt mr-1"></i>Month</label>
                        <select id="bda_month" class="form-control"></select>
                    </div>

                    <div class="bda-field">
                        <label for="bda_year"><i class="far fa-calendar-check mr-1"></i>Year</label>
                        <select id="bda_year" class="form-control"></select>
                    </div>

                    <div class="bda-actions">
                        <button type="button" id="bda_btnshow" class="bda-btn bda-btn-primary" onclick="return bdaShowReport();">
                            <i class="fas fa-search"></i>Show
                       
                        </button>
                        <button type="button" id="bda_btnclear" class="bda-btn bda-btn-muted" onclick="return bdaClearReport();">
                            <i class="fas fa-undo"></i>Clear
                       
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <div class="bda-table-panel">
            <div class="bda-table-head">
                <h2 class="bda-table-title"><i class="fas fa-table mr-2"></i>Date Wise Attendance Details</h2>
                <span class="bda-count" id="bda_count">0 records</span>
            </div>
            <table id="bda_table" class="table table-bordered" style="width: 100%;">
                <thead>
                    <tr>
                        <th>Sr. #</th>
                        <th>Date</th>
                        <th>Day</th>
                      <%--  <th>Domain</th>
                        <th>Sub-Domain</th>--%>
                        <th>AJ</th>
                        <th>KP</th>
                        <th>Akola</th>
                        <th>Bangalore</th>
                        <th>Solapur</th>
                        <th>Total</th>
                    </tr>
                </thead>

                <tbody></tbody>

                <tfoot>
                    <tr>
                        <th colspan="3" class="text-right">Grand Total</th>
                        <th></th>
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
</asp:Content>
