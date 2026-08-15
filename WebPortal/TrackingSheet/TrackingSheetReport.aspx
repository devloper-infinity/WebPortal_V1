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

        .tr-head {
            padding: 14px 20px;
            background: #f3f7fb;
            border-bottom: 1px solid #d7e3ef;
            font-weight: 700
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
        }

        @media(max-width:600px) {
            .tr-filters {
                grid-template-columns: 1fr
            }
            .tr-stage-grid { grid-template-columns:1fr }
            .tr-process-summary { width:210px }
            .tr-flow-detail-head { display:block }
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
            <div class="tr-head">Report Results</div>
            <div class="tr-body">
                <div id="trSummary" class="tr-summary"></div>
                <div class="tr-legend"><span class="tr-process-step completed"><span class="tr-status-dot"></span>Completed</span><span class="tr-process-step pending"><span class="tr-status-dot"></span>Pending</span><span class="tr-process-step skipped"><span class="tr-status-dot"></span>Skipped</span><span class="tr-process-step in-process current"><span class="tr-status-dot"></span>Current process</span></div>
                <div class="tr-wrap">
                    <table id="trTable" class="table table-bordered table-striped table-hover"></table>
                </div>
            </div>
        </div>
    </div>
    <script src="../plugins/sweetalert2/sweetalert2.all.min.js"></script>
    <script src="../Scripts/TrackingSheet/TrackingSheetReport.js?v=20260814.4"></script>
</asp:Content>
