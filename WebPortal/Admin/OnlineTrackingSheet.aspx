<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="OnlineTrackingSheet.aspx.cs" Inherits="WebPortal.Admin.OnlineTrackingSheet" %>

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
            grid-template-columns: repeat(4, minmax(180px, 1fr));
            gap: 16px;
            align-items: end;
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
        input[type="date"] {
            width: 100%;
            height: 46px !important;
            border: 1px solid var(--ud-border) !important;
            padding: 9px 14px;
            border-radius: 14px !important;
            font-size: 13px;
            color: var(--ud-text);
            background-color: #fff;
            outline: none;
            box-shadow: none !important;
            transition: border-color .18s ease, box-shadow .18s ease, transform .18s ease;
        }

        .form-control:focus,
        .form-select:focus,
        select:focus,
        input[type="date"]:focus {
            border-color: var(--ud-primary) !important;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, .12) !important;
        }

        .btn,
        .my-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-height: 44px;
            padding: 0 18px;
            border: 0 !important;
            border-radius: 14px !important;
            font-size: 14px;
            font-weight: 800;
            text-decoration: none;
            cursor: pointer;
            transition: transform .18s ease, box-shadow .18s ease, background .18s ease;
        }

        .btn:hover,
        .my-btn:hover { transform: translateY(-1px); text-decoration: none; }

        .btn-gradient-primary,
        .btn-primary,
        .primary {
            background: linear-gradient(135deg, var(--ud-primary), var(--ud-accent)) !important;
            color: #fff !important;
            box-shadow: 0 12px 24px rgba(37, 99, 235, .24);
        }

        .btn-gradient-primary:hover,
        .btn-primary:hover,
        .primary:hover { color: #fff !important; box-shadow: 0 16px 30px rgba(37, 99, 235, .32); }

        .btn-gradient-success,
        .buttons-excel {
            background: linear-gradient(to right, #ffbf96, #fe7096) !important;
            color: #fff !important;
            box-shadow: 0 12px 24px rgba(254, 112, 150, .24) !important;
        }

        .ud-table-wrap {
            width: 100%;
            overflow-x: auto;
            border-radius: 18px;
            background: #fff;
        }

        .ud-table-wrap table {
            width: 100% !important;
            margin: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0;
            white-space: nowrap;
        }

        .ud-table-wrap thead th,
        .table.dataTable thead th {
            border: 0 !important;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%) !important;
            color: #fff !important;
            font-size: 12px !important;
            font-weight: 900 !important;
            text-align: center !important;
            vertical-align: middle !important;
            letter-spacing: .02em;
        }

        .ud-table-wrap tbody td,
        .table.dataTable tbody td {
            padding: 12px !important;
            border-bottom: 1px solid var(--ud-border) !important;
            color: #334155;
            font-size: 13px;
            vertical-align: middle;
            background: #fff;
        }

        .ud-table-wrap tbody tr:hover td,
        .table.dataTable tbody tr:hover td { background: #f8fbff !important; }

        table.dataTable thead th::before,
        table.dataTable thead th::after { display: none !important; }

        .top,
        div.dt-buttons {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
            padding-bottom: 12px;
            float: none !important;
            position: static !important;
            padding-left: 0 !important;
        }

        .dataTables_filter { margin-left: auto; }
        .dataTables_filter input,
        .dataTables_length select {
            min-height: 34px !important;
            height: 34px !important;
            border: 1px solid var(--ud-border) !important;
            border-radius: 12px !important;
            padding: 6px 10px;
            font-size: 12px;
            outline: none;
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

        @media (max-width: 991px) {
            .ud-page { padding: 16px; }
            .ud-filter-grid { grid-template-columns: repeat(2, minmax(160px, 1fr)); }
            .dataTables_filter { margin-left: 0; }
        }

        @media (max-width: 575px) {
            .ud-hero { align-items: flex-start; padding: 20px; }
            .ud-title { font-size: 20px; }
            .ud-filter-grid { grid-template-columns: 1fr; }
        }

        #otsheet_table { padding-top: 10px; }
    </style>
    <script>
        $(document).ready(function () {
            otsheet_bindprojects();
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="ud-page">
        <section class="ud-hero">
            <div class="ud-hero-icon"><i class="bi bi-clipboard-data-fill"></i></div>
            <div class="ud-hero-content">
                <h1 class="ud-title">Online Tracking Sheet</h1>
                <p class="ud-subtitle">Filter project tracking data by project and date range.</p>
            </div>
        </section>

        <div class="ud-card">
            <div class="ud-section-title"><i class="bi bi-funnel"></i><span>Tracking Filters</span></div>
            <div class="ud-filter-grid">
                <div>
                    <label for="otsheet_project">Project #</label>
                    <select id="otsheet_project" name="otsheet_project" class="form-control"></select>
                </div>
                <div>
                    <label for="otsheet_from">From Date</label>
                    <input type="date" id="otsheet_from" name="otsheet_from" class="form-control" />
                </div>
                <div>
                    <label for="otsheet_to">To Date</label>
                    <input type="date" id="otsheet_to" name="otsheet_to" class="form-control" />
                </div>
                <div>
                    <label>&nbsp;</label>
                    <button type="button" id="otsheet_btnsubmit" name="otsheet_btnsubmit" class="btn btn-gradient-primary w-100" onclick="return otsheet_submit();"><i class="bi bi-search"></i> Show</button>
                </div>
            </div>
        </div>

        <div class="ud-card">
            <div class="ud-section-title"><i class="bi bi-table"></i><span>Tracking Sheet Results</span></div>
            <div class="ud-table-wrap">
                <table class="table" id="otsheet_table" style="width: 100%;"></table>
            </div>
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
        /*.form-control {
            font-size: 11px !important;
        }*/
    </style>
    <script>
        $(document).ready(function () {
            otsheet_bindprojects();
        });

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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Online Tracking Sheet</b></h6>
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
                        <td><b>Project #:</b></td>
                        <td>
                            <select id="otsheet_project" name="otsheet_project" class="form-control" style="width: 250px;"></select>
                        </td>
                        <td><b>From Date:</b></td>
                        <td>
                            <input type="date" id="otsheet_from" name="otsheet_from" class="form-control" style="width: 250px;" />
                        </td>
                        <td><b>To Date:</b></td>
                        <td>
                            <input type="date" id="otsheet_to" name="otsheet_to" class="form-control" style="width: 250px;" />
                        </td>
                        <td>
                            <button type="button" id="otsheet_btnsubmit" name="otsheet_btnsubmit" class="btn btn-primary" onclick="return otsheet_submit();">Show</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <table class="table" id="otsheet_table" style="padding-top: 10px; width: 100%;">
                </table>
            </div>
        </div>
    </div>
</asp:Content>--%>
