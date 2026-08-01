<%@ Page Title="Tracking Sheet Report" Language="C#" MasterPageFile="~/Production/Production.Master" AutoEventWireup="true" CodeBehind="TrackingSheetReport.aspx.cs" Inherits="WebPortal.TrackingSheet.TrackingSheetReport" %>

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
                <div class="tr-wrap">
                    <table id="trTable" class="table table-bordered table-striped table-hover"></table>
                </div>
            </div>
        </div>
    </div>
    <script src="../plugins/sweetalert2/sweetalert2.all.min.js"></script>
    <script src="../Scripts/TrackingSheet/TrackingSheetReport.js"></script>
</asp:Content>
