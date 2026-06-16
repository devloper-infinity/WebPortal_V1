<%@ Page Title="" Language="C#" MasterPageFile="~/Accounts/Accounts.Master" AutoEventWireup="true" CodeBehind="SalaryIncrementDueReport.aspx.cs" Inherits="WebPortal.Accounts.SalaryIncrementDueReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
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

        /* ✅ FIX: Required for FixedColumns alignment */
        .dataTables_wrapper {
            width: 100% !important;
        }

        .dataTables_scrollBody {
            overflow: auto !important;
        }

        .dataTables_scrollHead,
        .dataTables_scrollFoot {
            overflow: hidden !important;
        }

        /* ✅ FIX: Prevent column misalignment */
        table.dataTable {
            width: 100% !important;
            border-collapse: collapse !important;
            table-layout: auto !important;
        }

        .dataTables_length, .dataTables_info {
            float: left !important;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: normal !important;
            border: none !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 50px;
            float: left;
        }

        .buttons-excel, .buttons-html5 {
            color: #fff;
            background: linear-gradient(to right, #ffbf96, #fe7096);
            border: 0;
            font-weight: bold;
            margin: 0px 10px;
        }

        .table.dataTable th {
            color: #000;
            text-transform: uppercase !important;
            white-space: nowrap;
        }

        .table.dataTable tr td {
            background-color: #fff !important;
            white-space: nowrap;
        }

        .dataTables_length select {
            min-width: 90px !important;
            padding: 6px 30px 6px 12px !important;
            border: 1px solid #ced4da !important;
            box-shadow: none !important;
            font-size: 14px !important;
        }

        .dataTables_length label {
            font-weight: 600;
            color: #495057;
        }

        .form-grid select {
            width: 250px;
        }

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

        .btn-gradient-primary {
            background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;
            color: #fff;
            border-radius: 12px;
            height: 40px;
            font-weight: 400;
            transition: 0.3s;
        }

            .btn-gradient-primary:hover {
                /* transform: translateY(-2px);*/
                background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;
                color: #fff;
            }

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
                /*   transform: translateY(-2px);*/
                color: #fff;
            }

        /* ✅ FIX: Better hover sync with fixed columns */
        table.dataTable tbody tr:hover td {
            background-color: #f1f5f9 !important;
        }

        /* ✅ FIX: Shadow for frozen columns (professional look) */
        .dtfc-left-top-blocker,
        .dtfc-left-bottom-blocker {
            box-shadow: 4px 0 8px rgba(0,0,0,0.08);
        }
    </style>


    <script>

        function salarinc_bindGrid() {

            var month = $("#salInc_user").val();

            if (month == "") {
                alert("Please select Month");
                return;
            }

            $('#load1').show();

            if ($.fn.DataTable.isDataTable('#table_salInc')) {
                $('#table_salInc').DataTable().clear().destroy();
                $('#table_salInc tbody').empty();
            }

            setTimeout(function () {

                $('#table_salInc').DataTable({
                    destroy: true,

                    scrollX: true,
                    scrollY: "60vh",   // 🔥 REQUIRED for FixedColumns stability
                    scrollCollapse: true,

                    fixedHeader: true,

                    fixedColumns: {
                        leftColumns: 3
                    },

                    ajax: {
                        url: 'SalaryIncrementDueReport.aspx/GetSalaryIncrementDue',
                        type: 'POST',
                        contentType: 'application/json',
                        data: function () {
                            return JSON.stringify({ Month: month });
                        },
                        dataSrc: function (json) {
                            $('#load1').hide();
                            return JSON.parse(json.d);
                        }
                    },

                    columns: [
                        {
                            data: null,
                            render: function (data, type, row, meta) {
                                return meta.row + meta.settings._iDisplayStart + 1;
                            }
                        },
                        { data: "Code" },
                        { data: "NAME" },
                        { data: "DOJ" },
                        { data: "Branch" },
                        { data: "Domain" },
                        { data: "Department" },
                        { data: "Designation" },
                        { data: "DomainHead" },
                        { data: "ReportingPM" },
                        { data: "CurrentSalary" },
                        { data: "PrevIncAmount" },
                        { data: "PreviousSalary" },
                        { data: "PreviousIncMonth" },
                        { data: "TenureLastIncdate" },
                        { data: "MonthRemaining" },
                        { data: "LastLoginDate" },
                        { data: "CurrentStatus" }
                    ],

                    buttons: [
                        {
                            extend: 'excelHtml5',
                            text: 'Export Excel',
                            title: 'Salary Increment Due Report_' + month
                        }
                    ],

                    initComplete: function () {
                        $('#load1').hide();

                        // 🔥 FIX: forces recalculation (CRITICAL)
                        setTimeout(function () {
                            $.fn.dataTable.tables({ visible: true, api: true }).columns.adjust();
                        }, 200);
                    }
                });

            }, 50);
        }

    </script>

    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.8/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/fixedcolumns/4.3.0/css/fixedColumns.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/fixedheader/3.4.0/css/fixedHeader.dataTables.min.css">

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>

    <script src="https://cdn.datatables.net/fixedcolumns/4.3.0/js/dataTables.fixedColumns.min.js"></script>
    <script src="https://cdn.datatables.net/fixedheader/3.4.0/js/dataTables.fixedHeader.min.js"></script>

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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Salary Increment Due Report</b></h6>
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <div class="row mb-4">
                    <div class="col-md-6">
                        <div class="d-flex align-items-center">
                            <label style="color: #6c757d; margin-bottom: 0; margin-right: 15px; white-space: nowrap;">
                                <b>Month :</b>
                            </label>
                            <select id="salInc_user" name="salInc_user" class="form-control" style="height: 40px;">
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
                    <div class="col-md-3">
                        <button type="button" class="btn btn-gradient-primary" onclick="salarinc_bindGrid();" style="height: 40px; width: 200px;">
                            <i class="bi bi-bar-chart-line"></i>Get Report
                        </button>
                    </div>
                    <div class="col-md-3">
                        <asp:Button ID="btn_exportSalIncDue" Text="Export Excel" class="btn btn-gradient-success flex-grow-1" Style="background: linear-gradient(to right, #ffbf96, #fe7096); width: 200px;" runat="server" OnClick="btn_exportSalIncDue_Click" />
                        <%-- <button type="button" class="btn btn-gradient-success" onclick="exportExcel()" style="height: 40px; width: 300px;">
                            <i class="bi bi-filetype-xlsx"></i>Export To Excel 
                        </button>--%>
                    </div>
                </div>
                <hr />
                <table class="table" id="table_salInc">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Joining Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Domain</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Department</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Designation</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Domain Head</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Reporting Manager</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Current Salary</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Previous Increment Amount</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Previous Salary</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Previous Increment Month</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Tenure Since Last Increment</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Next Increment Due</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Latest Login Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Current Status</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

    <style>
        table.dataTable {
            border-collapse: collapse !important;
        }

            table.dataTable th,
            table.dataTable td {
                white-space: nowrap;
                vertical-align: middle;
            }

        /* Better header look */
        .dataTables_scrollHead {
            border-bottom: 2px solid #dee2e6;
        }

        /* Hover sync fix for fixed columns */
        table.dataTable tbody tr:hover td {
            background-color: #f1f5f9 !important;
        }

        /* Fixed columns shadow effect (important UX upgrade) */
        .dtfc-left-top-blocker,
        .dtfc-right-top-blocker,
        .dtfc-left-bottom-blocker,
        .dtfc-right-bottom-blocker {
            background: #fff;
        }

        /* Make fixed columns visually separated */
        .dtfc-left-head,
        .dtfc-left-body {
            box-shadow: 4px 0 6px rgba(0,0,0,0.05);
        }
    </style>
</asp:Content>
