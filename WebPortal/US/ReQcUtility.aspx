<%@ Page Title="" Language="C#" MasterPageFile="~/US/USAdmin.Master" AutoEventWireup="true" CodeBehind="ReQcUtility.aspx.cs" Inherits="WebPortal.US.ReQcUtility" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --reqc-primary: #2563eb;
            --reqc-primary-dark: #1d4ed8;
            --reqc-success: #16a34a;
            --reqc-warning: #f97316;
            --reqc-bg: #f4f7fb;
            --reqc-card: #ffffff;
            --reqc-border: #e5e7eb;
            --reqc-text: #111827;
            --reqc-muted: #6b7280;
            --reqc-shadow: 0 14px 35px rgba(15, 23, 42, .08);
        }

        .reqc-page {
            background: radial-gradient(circle at top left, rgba(37, 99, 235, .08), transparent 28%), var(--reqc-bg);
            min-height: calc(100vh - 80px);
        }

        .reqc-shell {
            max-width: 1440px;
            margin: 0 auto;
        }

        .reqc-hero {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 18px;
            padding: 22px 24px;
            margin-bottom: 18px;
            color: #fff;
            border-radius: 20px;
            background: linear-gradient(135deg, #1d4ed8, #38bdf8);
            box-shadow: var(--reqc-shadow);
        }

        .reqc-hero h4 {
            margin: 0 0 5px;
            font-weight: 800;
            letter-spacing: .2px;
        }

        .reqc-hero p {
            margin: 0;
            color: rgba(255,255,255,.86);
            font-size: 13px;
        }

        .reqc-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 13px;
            border-radius: 999px;
            background: rgba(255,255,255,.16);
            border: 1px solid rgba(255,255,255,.28);
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
        }

        .reqc-card {
            background: var(--reqc-card);
            border: 1px solid var(--reqc-border);
            border-radius: 18px;
            box-shadow: var(--reqc-shadow);
        }

        .reqc-toolbar {
            padding: 18px;
            margin-bottom: 18px;
        }

        .reqc-form-grid {
            display: grid;
            grid-template-columns: minmax(180px, 240px) minmax(250px, 1fr) auto;
            gap: 16px;
            align-items: end;
        }

        .reqc-field label {
            display: block;
            margin-bottom: 7px;
            color: var(--reqc-muted);
            font-size: 12px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: .05em;
        }

        .reqc-input,
        .reqc-file {
            width: 100%;
            min-height: 42px;
            border: 1px solid var(--reqc-border);
            border-radius: 12px;
            box-shadow: none;
            font-size: 14px;
            transition: border-color .2s ease, box-shadow .2s ease;
        }

        .reqc-input:focus,
        .reqc-file:focus {
            border-color: rgba(37,99,235,.75);
            box-shadow: 0 0 0 4px rgba(37,99,235,.12);
            outline: none;
        }

        .reqc-actions {
            display: flex;
            flex-wrap: wrap;
            justify-content: flex-end;
            gap: 10px;
        }

        .reqc-btn {
            min-height: 42px;
            padding: 10px 14px;
            border: 0;
            border-radius: 12px;
            color: #fff;
            font-size: 13px;
            font-weight: 800;
            box-shadow: 0 8px 18px rgba(37, 99, 235, .22);
            transition: transform .15s ease, box-shadow .15s ease, background .15s ease;
        }

        .reqc-btn:hover {
            color: #fff;
            transform: translateY(-1px);
            box-shadow: 0 12px 22px rgba(37, 99, 235, .26);
        }

        .reqc-btn-primary { background: linear-gradient(135deg, var(--reqc-primary), #38bdf8); }
        .reqc-btn-success { background: linear-gradient(135deg, var(--reqc-success), #22c55e); }
        .reqc-btn-warning { background: linear-gradient(135deg, var(--reqc-warning), #fb7185); }

        .reqc-format-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            min-height: 42px;
            padding: 10px 13px;
            color: var(--reqc-primary-dark);
            border: 1px solid rgba(37, 99, 235, .18);
            border-radius: 12px;
            background: rgba(37, 99, 235, .06);
            font-size: 13px;
            font-weight: 800;
            text-decoration: none;
            white-space: nowrap;
        }

        .reqc-format-link:hover {
            color: var(--reqc-primary-dark);
            background: rgba(37, 99, 235, .11);
            text-decoration: none;
        }

        .reqc-content-grid {
            display: grid;
            grid-template-columns: minmax(330px, .72fr) minmax(520px, 1.28fr);
            gap: 18px;
        }

        .reqc-panel-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 16px 18px 12px;
            border-bottom: 1px solid var(--reqc-border);
        }

        .reqc-panel-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0;
            color: var(--reqc-text);
            font-size: 15px;
            font-weight: 850;
        }

        .reqc-panel-title i {
            width: 30px;
            height: 30px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 10px;
            color: var(--reqc-primary);
            background: rgba(37,99,235,.1);
        }

        .reqc-count-label {
            color: var(--reqc-muted);
            font-size: 12px;
            font-weight: 700;
        }

        .reqc-table-wrap {
            padding: 14px 14px 18px;
            overflow-x: auto;
        }

        .reqc-table {
            width: 100% !important;
            margin: 0 !important;
            font-size: 12px;
            border-collapse: separate !important;
            border-spacing: 0;
        }

        .reqc-table thead th,
        .table.dataTable th {
            color: #374151 !important;
            background: #f8fafc !important;
            border-top: 0 !important;
            border-bottom: 1px solid var(--reqc-border) !important;
            font-size: 11px;
            font-weight: 850;
            text-transform: uppercase;
            letter-spacing: .04em;
            white-space: nowrap;
            text-align: center;
        }

        .reqc-table tbody td,
        .table.dataTable tr td {
            vertical-align: middle;
            color: #1f2937;
            background: #fff !important;
            border-color: #eef2f7 !important;
        }

        .reqc-table tbody tr:hover td {
            background: #f9fbff !important;
        }

        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dt-buttons {
            display: flex;
            align-items: center;
        }

        .dataTables_wrapper .dataTables_length {
            float: left !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 18px;
            float: left;
        }

        .buttons-excel {
            color: #fff;
            box-shadow: none;
            background: linear-gradient(135deg, var(--reqc-success), #22c55e);
            border: 0;
            border-radius: 10px;
            font-weight: 800;
        }

        .loading {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 210px;
            min-height: 190px;
            padding: 22px 18px;
            text-align: center;
            border-radius: 22px;
            background: rgba(255,255,255,.96);
            box-shadow: 0 24px 70px rgba(15, 23, 42, .24);
            z-index: 99999;
        }

        .loading img {
            max-width: 95px;
        }

        .loading div {
            margin-top: 10px;
            color: var(--reqc-text);
            font-size: 13px;
            font-weight: 800;
        }

        @media (max-width: 1199px) {
            .reqc-form-grid,
            .reqc-content-grid {
                grid-template-columns: 1fr;
            }
            .reqc-actions {
                justify-content: flex-start;
            }
        }

        @media (max-width: 576px) {
            .reqc-hero {
                align-items: flex-start;
                flex-direction: column;
                border-radius: 16px;
            }
            .reqc-toolbar,
            .reqc-panel-header {
                padding: 14px;
            }
            .reqc-actions,
            .reqc-btn,
            .reqc-format-link {
                width: 100%;
            }
        }
    </style>
    <script>
        $(document).ready(function () {
            //bindSummary_Grid(10);
            //bindLoan_Grid(10);
        });

        window.onload = function () {
            document.getElementById('reqcUtility_attachment').addEventListener('change', getFileName);
        }

        const getFileName = (event) => {
            const files = event.target.files;
            var file = files[0];
            document.getElementById("file_reqcUtility").value = files[0].name;

            const fd = new FormData();
            fd.append(event.target.name, file, file.name);

            const xhr = new XMLHttpRequest();
            xhr.onload = () => {
                if (xhr.status >= 200 && xhr.status < 300) {
                    // Upload completed.
                }
            };
            var url = window.location.href;
            xhr.open('POST', url, true);
            xhr.send(fd);
        }
    </script>

    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.2/css/buttons.dataTables.min.css">
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/dataTables.buttons.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.html5.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
    <script src="https://cdn.sheetjs.com/xlsx-latest/package/dist/xlsx.full.min.js"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="file_reqcUtility" style="display: none;" />

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" alt="Loading" />
        <div>One moment, please . . . .</div>
    </div>

    <section class="reqc-page">
        <div class="reqc-shell">
            <div class="reqc-hero">
                <div>
                    <h4><i class="fas fa-copy"></i>&nbsp; ReQC Utility</h4>
                    <p>Import QC loan data, calculate Re-QC samples, review summaries, and export results.</p>
                </div>
                <div class="reqc-badge"><i class="fas fa-file-excel"></i> Excel workflow</div>
            </div>

            <div class="reqc-card reqc-toolbar">
                <div class="reqc-form-grid">
                    <div class="reqc-field">
                        <label for="reqcUtility_perc">Re-QC Percentage</label>
                        <input type="text" name="reqcUtility_perc" id="reqcUtility_perc" class="form-control reqc-input" placeholder="Enter %" />
                    </div>
                    <div class="reqc-field">
                        <label for="reqcUtility_attachment">Upload Excel File</label>
                        <input type="file" id="reqcUtility_attachment" name="reqcUtility_attachment" class="form-control reqc-file" />
                    </div>
                    <div class="reqc-actions">
                        <button type="button" id="reqcUtility_Import" class="reqc-btn reqc-btn-primary" onclick="return btnreqcUtility_Import();"><i class="fas fa-upload"></i>&nbsp; Import Data</button>
                        <button type="button" id="reqcUtility_GetFiles" onclick="return btnreqcUtility_Import();" class="reqc-btn reqc-btn-warning"><i class="fas fa-sync-alt"></i>&nbsp; Re-Calculate</button>
                        <button type="button" id="reqcUtility_ExportToExcel" onclick="return btnreqcUtility_ExportToExcel();" class="reqc-btn reqc-btn-success"><i class="fas fa-file-export"></i>&nbsp; Export</button>
                        <a href="ReQcUtility.xlsx" class="reqc-format-link"><i class="fas fa-download"></i> Download Format</a>
                    </div>
                </div>
            </div>

            <div class="reqc-content-grid">
                <div class="reqc-card">
                    <div class="reqc-panel-header">
                        <h6 class="reqc-panel-title"><i class="fas fa-chart-pie"></i> Summary</h6>
                        <span class="reqc-count-label"><label id="reqcUtility_Summary"></label></span>
                    </div>
                    <div class="reqc-table-wrap">
                        <table class="table table-bordered reqc-table" id="table_reQcsummary">
                            <thead>
                                <tr>
                                    <th class="sort border-top ps-3">Sr. #</th>
                                    <th class="sort border-top ps-3" style="width: 150px;">QC</th>
                                    <th class="sort border-top ps-3">Loan Count</th>
                                    <th class="sort border-top ps-3">ReQc Loans</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>

                <div class="reqc-card">
                    <div class="reqc-panel-header">
                        <h6 class="reqc-panel-title"><i class="fas fa-list-check"></i> Loan Details</h6>
                        <span class="reqc-count-label"><label id="reqcUtility_LoanDetails"></label></span>
                    </div>
                    <div class="reqc-table-wrap">
                        <table class="table table-bordered reqc-table" id="table_reQcLoanDetails">
                            <thead>
                                <tr>
                                    <th class="sort border-top ps-3">Sr. #</th>
                                    <th class="sort border-top ps-3">Deal #</th>
                                    <th class="sort border-top ps-3">Loan #-1</th>
                                    <th class="sort border-top ps-3">Loan #-2</th>
                                    <th class="sort border-top ps-3" style="width: 150px;">Review</th>
                                    <th class="sort border-top ps-3" style="width: 150px;">QC</th>
                                    <th class="sort border-top ps-3">Review Status</th>
                                    <th class="sort border-top ps-3">Random #</th>
                                    <th class="sort border-top ps-3">Total Loans</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <div class="modal fade" id="reqc_popUp_Waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
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



        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dt-buttons {
            display: flex;
            align-items: center;
        }

        .dataTables_wrapper .dataTables_length {
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
        }

        .table.dataTable th {
            /*background:linear-gradient(to bottom, #0070C0, 80%, #ffffff);*/
            background: linear-gradient(to bottom, #cbd0dd, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none;
        }
        /*.form-control {
            font-size: 11px !important;
        }*/
    </style>
    <script>
        $(document).ready(function () {
            //bindSummary_Grid(10);
            //bindLoan_Grid(10);
        });

        window.onload = function () {
            document.getElementById('reqcUtility_attachment').addEventListener('change', getFileName);
        }

        const getFileName = (event) => {
            const files = event.target.files;
            var file = files[0];
            document.getElementById("file_reqcUtility").value = files[0].name;

            const fd = new FormData();

            // add all selected files
            fd.append(event.target.name, file, file.name);
            // create the request
            const xhr = new XMLHttpRequest();

            xhr.onload = () => {
                if (xhr.status >= 200 && xhr.status < 300) {
                    // we done!
                }
            };
            var url = window.location.href;
            // path to server would be where you'd normally post the form to
            xhr.open('POST', url, true);
            xhr.send(fd);
            //document.getElementById("dropzone").classList.add("dz-max-files-reached");
            //document.getElementById("conentdiv").style.display = '';
            //document.getElementById("importSercfilesdiv").innerHTML = file.name;
        }
    </script>

    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.2/css/buttons.dataTables.min.css">
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/dataTables.buttons.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.html5.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
    <script src="https://cdn.sheetjs.com/xlsx-latest/package/dist/xlsx.full.min.js"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="file_reqcUtility" style="display: none;" />

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>ReQC Utility</b></h6>
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
                        <td style="font-size: 14px;">
                            <b>Re-QC % :</b>
                        </td>
                        <td>
                            <input type="text" name="reqcUtility_perc" id="reqcUtility_perc" class="form-control" style="width: 250px;" />
                        </td>
                        <td style="font-size: 14px;"><b>Excel:</b></td>
                        <td>
                            <input type="file" id="reqcUtility_attachment" name="reqcUtility_attachment" class="form-control" style="width: 250px;" />
                        </td>
                        <td>
                            <button type="button" id="reqcUtility_Import" class="btn btn-primary" onclick="return btnreqcUtility_Import();">Import Data</button>
                            &nbsp;&nbsp;
                            <button type="button" id="reqcUtility_GetFiles" onclick="return btnreqcUtility_Import();" class="btn btn-primary">Re-Calculate</button>
                            &nbsp;&nbsp;
                            <button type="button" id="reqcUtility_ExportToExcel" onclick="return btnreqcUtility_ExportToExcel();" class="btn btn-primary">Export To Excel</button>

                        </td>
                        <td>
                            <a href="ReQcUtility.xlsx" style="font-family: Verdana; font-size: 12px; font-weight: bold; color: blue;">Download Format</a>
                        </td>
                    </tr>
                </table>
                <hr />
                <div class="row">
                    <div class="col-lg-4">
                        <div class="card card-primary card-outline">
                            <div class="card-header">
                                <h6>Summary :<label id="reqcUtility_Summary"></label></h6>
                                <hr />
                                <table class="table table-bordered" style="width: 100%; font-size: 11px;" id="table_reQcsummary">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center; width: 150px;">QC</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Loan Count</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">ReQc Loans</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-8">
                        <div class="card card-primary card-outline">
                            <div class="card-header">
                                <h6>Loan Details :<label id="reqcUtility_LoanDetails"></label></h6>
                                <table class="table table-bordered" style="width: 100%; font-size: 11px;" id="table_reQcLoanDetails">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Deal #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Loan #-1</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Loan #-2</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center; width: 150px;">Review</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center; width: 150px;">QC</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Review Status</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Random #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Total Loans</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="reqc_popUp_Waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">System is updating details. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>

</asp:Content>--%>
