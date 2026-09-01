<%@ Page Title="Tracking Sheet Report" Language="C#" MasterPageFile="~/TrackingSheet/TrackingSheetMaster.Master" AutoEventWireup="true" CodeBehind="TrackingSheetReport.aspx.cs" Inherits="WebPortal.TrackingSheet.TrackingSheetReport" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../plugins/sweetalert2/sweetalert2.min.css" />
    <style>
        .tr-page {
            color: #17324d
        }

        .tr-hero, .tr-card {
            background: #fff;
            border: 1px solid #d7e3ef;
            border-radius: 10px;
            margin-bottom: 20px
        }

        .tr-hero {
            border-left: 6px solid #117a9b;
            padding: 16px 17px;
        }

            .tr-hero h2 {
                margin: 0 0 6px;
                font-weight: 700;
                font-size: 22px;
            }

        .tr-body {
            padding: 20px
        }

        .tr-filters {
            display: grid;
            grid-template-columns: minmax(240px,1fr) 200px 200px auto;
            gap: 16px;
            align-items: end
        }

            .tr-filters label {
                display: block;
                margin-bottom: 6px;
                font-weight: 600
            }

        .tr-results {
            display: none
        }

        .tr-summary {
            margin-bottom: 12px;
            color: #415d76;
            font-weight: 600
        }

        .tr-view-tabs { display:flex; gap:8px; padding:10px 20px 0; background:#f3f7fb }
        .tr-view-tab { padding:8px 14px; border:1px solid #cbd9e6; border-bottom:0; border-radius:7px 7px 0 0; background:#eaf1f7; color:#415d76; font-weight:700; cursor:pointer }
        .tr-view-tab.active { background:#fff; color:#075985 }
        .tr-deal-view { display:none }
        .tr-kpis { display:grid; grid-template-columns:repeat(4,minmax(120px,1fr)); gap:10px; margin-bottom:12px }
        .tr-kpi { padding:10px 12px; border:1px solid #d7e3ef; border-radius:8px; background:#f8fbfd }
        .tr-kpi span { display:block; color:#64748b; font-size:11px; font-weight:700; text-transform:uppercase }
        .tr-kpi strong { display:block; margin-top:2px; color:#17324d; font-size:20px }
        .tr-deal-filters { display:grid; grid-template-columns:minmax(220px,360px) 170px; justify-content:end; gap:8px; margin-bottom:10px }
        .tr-deal-filters .form-control { height:32px; padding:5px 9px; font-size:11px; border-color:#ccd9e7 }
        .tr-deal-list { display:grid; gap:10px }
        .tr-deal-card { border:1px solid #d7e3ef; border-radius:7px; overflow:hidden; background:#fff; box-shadow:0 2px 8px rgba(15,42,75,.05) }
        .tr-deal-overview { display:grid; grid-template-columns:170px 190px minmax(310px,1.3fr) minmax(360px,1.5fr); gap:7px; padding:7px; background:#f8fafc }
        .tr-deal-identity,.tr-summary-panel { min-width:0; padding:9px 10px; border:1px solid #dbe5ef; border-radius:6px; background:#fff }
        .tr-deal-identity { display:flex; flex-direction:column; justify-content:center }
        .tr-deal-title strong { display:block; color:#102b4e; font-size:17px }
        .tr-deal-title span { display:block; margin-top:8px; color:#285b91; font-size:11px; font-weight:700 }
        .tr-panel-label { display:block; margin-bottom:7px; color:#17324d; font-size:10px; font-weight:800 }
        .tr-overall-value { display:flex; justify-content:space-between; align-items:end; margin-bottom:7px }
        .tr-overall-value strong { color:#07806c; font-size:21px; line-height:1 }
        .tr-overall-value span { color:#64748b; font-size:9px }
        .tr-status-counters { display:grid; grid-template-columns:repeat(5,minmax(48px,1fr)); gap:5px }
        .tr-status-counter { padding:5px 3px; border:1px solid #e2e8f0; border-radius:5px; background:#f8fafc; text-align:center }
        .tr-status-counter span { display:block; font-size:9px; font-weight:700 }
        .tr-status-counter strong { display:block; margin-top:2px; color:#17324d; font-size:17px; line-height:1.15 }
        .tr-status-counter.assigned span,.tr-status-counter.inprocess span { color:#1768c4 }
        .tr-status-counter.pending { background:#fffbeb }.tr-status-counter.pending span { color:#b7791f }
        .tr-status-counter.hold span { color:#64748b }.tr-status-counter.completed { background:#f0fdf4 }.tr-status-counter.completed span { color:#15803d }
        .tr-review-list { display:grid; grid-template-columns:repeat(2,minmax(150px,1fr)); gap:5px 12px }
        .tr-review-row { display:grid; grid-template-columns:80px 1fr; gap:7px; align-items:center; color:#64748b; font-size:9px; white-space:nowrap }
        .tr-review-row > strong { overflow:hidden; color:#334e68; text-overflow:ellipsis }
        .tr-review-counts .done { color:#15803d }.tr-review-counts .active { color:#1768c4 }.tr-review-counts .waiting { color:#b7791f }.tr-review-counts .held { color:#64748b }
        .tr-deal-toolbar { display:flex; justify-content:space-between; align-items:center; min-height:37px; padding:5px 10px; border-top:1px solid #dbe5ef; border-bottom:1px solid #dbe5ef; background:#fff }
        .tr-deal-toolbar strong { color:#17324d; font-size:12px }
        .tr-deal-expand { min-width:86px; padding:4px 9px; white-space:nowrap; font-size:10px }
        .tr-deal-detail { display:none; padding:0 10px 7px; background:#fff; overflow-x:auto }
        .tr-deal-detail table { min-width:1050px; margin:7px 0 0; border-collapse:separate; border-spacing:0; background:#fff; font-size:10px }
        .tr-deal-detail table th { padding:7px 8px; border-color:#315270; background:#092f57; color:#fff; font-weight:700; vertical-align:middle }
        .tr-deal-detail table td { padding:6px 8px; border-color:#dbe5ef; color:#233f5d; vertical-align:middle }
        .tr-deal-detail table tbody tr:nth-child(even) { background:#fbfdff }
        .tr-deal-detail table tbody tr:hover { background:#f0f7ff }
        .tr-deal-detail table tfoot th { padding:6px 8px; border-color:#dbe5ef; background:#f8fafc; color:#17324d }
        .tr-loan-link { color:#0969da; font-weight:800 }
        .tr-loan-completion { color:#075985 }
        .tr-status { display:inline-block; padding:3px 7px; border-radius:999px; font-size:10px; font-weight:700; white-space:nowrap }
        .tr-status.completed { background:#eaf8f1; color:#166534 }
        .tr-status.in-process { background:#e9f6fd; color:#075985 }
        .tr-status.hold { background:#fff1e8; color:#9a3412 }
        .tr-status.pending { background:#fff8df; color:#854d0e }
        .tr-empty { padding:24px; border:1px dashed #cbd5e1; border-radius:8px; text-align:center; color:#64748b }

        .tr-wrap {
            width: 100%;
            overflow: auto
        }
        .tr-legend { display:flex; flex-wrap:wrap; gap:12px; margin:0 0 14px }
        .tr-process-summary { width:240px; white-space:normal }
        .tr-progress-track { height:8px; overflow:hidden; border-radius:999px; background:#e2e8f0 }
        .tr-progress-value { height:100%; border-radius:999px; background:linear-gradient(90deg,#0f7899,#16a085) }
        .tr-progress-head,.tr-progress-meta { display:flex; justify-content:space-between; gap:12px; margin-bottom:6px }
        .tr-progress-head strong { color:#17324d }
        .tr-progress-meta { margin:6px 0 0; color:#64748b; font-size:11px }
        .tr-current-process { margin-top:7px; color:#075985; font-size:12px; font-weight:700 }
        .tr-flow-toggle { margin-top:7px; padding:0; border:0; background:transparent; color:#117a9b; font-size:12px; font-weight:800; cursor:pointer }
        .tr-flow-toggle:hover { text-decoration:underline }
        .tr-flow-detail { padding:14px 16px; border-left:4px solid #117a9b; background:#f8fbfd }
        .tr-flow-detail-head { display:flex; justify-content:space-between; gap:16px; margin-bottom:14px }
        .tr-flow-detail-head h4 { margin:0; color:#17324d; font-size:16px }
        .tr-flow-detail-head span { color:#64748b; font-size:12px }
        .tr-stage-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(180px,1fr)); gap:10px }
        .tr-stage { min-width:0; padding:10px; border:1px solid #d7e3ef; border-radius:10px; background:#fff }
        .tr-stage.current { border-color:#70b7dc; box-shadow:0 0 0 3px rgba(17,122,155,.12) }
        .tr-stage-title { display:flex; justify-content:space-between; margin-bottom:9px; color:#526b82; font-size:11px; font-weight:800; text-transform:uppercase }
        .tr-stage-processes { display:grid; grid-template-columns:repeat(auto-fit,minmax(120px,1fr)); gap:7px }
        .tr-process-step { position:relative; min-width:0; padding:7px 9px; border:1px solid #cbd5e1; border-radius:8px; background:#f8fafc; white-space:normal }
        .tr-process-step strong { display:block; font-size:11px }
        .tr-process-step small { color:#64748b }
        .tr-process-user { display:block; margin-top:4px; color:#475569; font-size:10px; font-weight:700 }
        .tr-process-step.completed { border-color:#86d2ad; background:#eaf8f1; color:#166534 }
        .tr-process-step.pending { border-color:#f0cf75; background:#fff8df; color:#854d0e }
        .tr-process-step.skipped { border-color:#cbd5e1; background:#f1f5f9; color:#64748b }
        .tr-process-step.in-process,.tr-process-step.hold { border-color:#70b7dc; background:#e9f6fd; color:#075985 }
        .tr-process-step.current { box-shadow:0 0 0 3px rgba(17,122,155,.2) }
        .tr-status-dot { display:inline-block; width:9px; height:9px; border-radius:50%; margin-right:5px; background:currentColor }

            .tr-wrap table {
                width: 100% !important
            }

                .tr-wrap table th, .tr-wrap table td {
                    white-space: nowrap
                }

        .tr-loading {
            display: none;
            margin-left: 8px;
            color: #117a9b;
            font-weight: 600
        }

        @media(max-width:900px) {
            .tr-filters {
                grid-template-columns: 1fr 1fr
            }
            .tr-deal-overview { grid-template-columns:1fr 1fr }
        }

        @media(max-width:600px) {
            .tr-filters {
                grid-template-columns: 1fr
            }
            .tr-stage-grid { grid-template-columns:1fr }
            .tr-process-summary { width:210px }
            .tr-flow-detail-head { display:block }
            .tr-kpis { grid-template-columns:1fr 1fr }
            .tr-deal-filters,.tr-deal-overview { grid-template-columns:1fr }
            .tr-review-list { grid-template-columns:1fr }
        }
    </style>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="tr-page">
        <div class="tr-hero">
            <h2>Tracking Sheet Report</h2>
            <div>Project and Order Date-wise read-only view of imported Tracking Sheet data.</div>
        </div>
        <div class="tr-card">
            <div class="tr-head">Report Filters</div>
            <div class="tr-body">
                <div class="tr-filters">
                    <div>
                        <label for="trProject">Project</label><select id="trProject" class="form-control" style="height:34px;"><option value="">Select Project</option>
                        </select></div>
                    <div>
                        <label for="trFromDate">From Order Date</label><input id="trFromDate" type="date" class="form-control" /></div>
                    <div>
                        <label for="trToDate">To Order Date</label><input id="trToDate" type="date" class="form-control" /></div>
                    <div>
                        <button type="button" id="trShow" class="btn btn-primary">Show Report</button><span id="trLoading" class="tr-loading">Loading...</span></div>
                </div>
            </div>
        </div>
        <div id="trResults" class="tr-card tr-results">
            <div class="tr-head">Tracking Sheet Report</div>
            <div class="tr-view-tabs" role="tablist">
                <button type="button" class="tr-view-tab active" data-view="loan">Loan Wise Report</button>
                <button type="button" class="tr-view-tab" data-view="deal">Deal Wise Status</button>
            </div>
            <div id="trLoanView" class="tr-body">
                <div id="trSummary" class="tr-summary"></div>
                <div class="tr-legend"><span class="tr-process-step completed"><span class="tr-status-dot"></span>Completed</span><span class="tr-process-step pending"><span class="tr-status-dot"></span>Pending</span><span class="tr-process-step skipped"><span class="tr-status-dot"></span>Skipped</span><span class="tr-process-step in-process current"><span class="tr-status-dot"></span>Current process</span></div>
                <div class="tr-wrap">
                    <table id="trTable" class="table table-bordered table-striped table-hover"></table>
                </div>
            </div>
            <div id="trDealView" class="tr-body tr-deal-view">
                <div id="trDealKpis" class="tr-kpis"></div>
                <div class="tr-deal-filters">
                    <input type="search" id="trDealSearch" class="form-control" placeholder="Search Deal" aria-label="Search Deal" />
                    <select id="trDealStatus" class="form-control" aria-label="Deal Status">
                        <option value="">All statuses</option>
                        <option value="Completed">Completed</option>
                        <option value="In Process">In Process</option>
                        <option value="Pending">Pending</option>
                        <option value="Hold">Hold</option>
                    </select>
                </div>
                <div id="trDealList" class="tr-deal-list"></div>
            </div>
        </div>
    </div>
    <script src="../plugins/sweetalert2/sweetalert2.all.min.js"></script>
    <script src="../Scripts/TrackingSheet/TrackingSheetReport.js?v=20260831.1"></script>
</asp:Content>
