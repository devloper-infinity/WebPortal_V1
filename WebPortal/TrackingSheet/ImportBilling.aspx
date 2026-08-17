<%@ Page Title="Import Billing" Language="C#" MasterPageFile="~/TrackingSheet/TrackingSheetMaster.Master" AutoEventWireup="true" CodeBehind="ImportBilling.aspx.cs" Inherits="WebPortal.TrackingSheet.ImportBilling" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../plugins/sweetalert2/sweetalert2.min.css" />
    <style>
        .ib-page {
            color: #17324d
        }

        .ib-hero, .ib-card {
            background: #fff;
            border: 1px solid #d7e3ef;
            border-radius: 10px;
            margin-bottom: 20px
        }

        .ib-hero {
            border-left: 6px solid #117a9b;
            padding: 20px 26px
        }

            .ib-hero h2 {
                margin: 0 0 6px;
                font-weight: 700
            }

        .ib-tabs {
            margin-bottom: 18px
        }

            .ib-tabs .nav-link {
                font-weight: 700
            }

        .ib-head {
            padding: 14px 20px;
            background: #f3f7fb;
            border-bottom: 1px solid #d7e3ef;
            font-weight: 700
        }

        .ib-body {
            padding: 20px
        }

        .ib-filters {
            display: grid;
            grid-template-columns: minmax(230px,1fr) 170px 150px minmax(250px,1fr) 190px auto;
            gap: 16px;
            align-items: end
        }

        .ib-history-filters {
            grid-template-columns: minmax(240px,1fr) 180px 160px auto
        }

        .ib-filters label {
            display: block;
            margin-bottom: 6px;
            font-weight: 600
        }

        .ib-actions {
            display: flex;
            gap: 10px;
            align-items: center;
            margin: 14px 0
        }

        .ib-summary {
            color: #415d76;
            font-weight: 600
        }

        .ib-wrap {
            width: 100%;
            overflow: auto
        }

            .ib-wrap table {
                width: 100% !important
            }

            .ib-wrap th, .ib-wrap td {
                white-space: nowrap
            }

        .ib-loading {
            display: none;
            margin-left: 8px;
            color: #117a9b;
            font-weight: 600
        }

        .ib-file {
            padding: 4px;
            height: auto
        }

        .ib-template-btn {
            width: 100%;
            white-space: nowrap
        }

        .ib-status {
            display: inline-block;
            padding: 3px 9px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 700
        }

        .ib-verified {
            background: #dff4e8;
            color: #176b41
        }

        @media(max-width:1200px) {
            .ib-filters {
                grid-template-columns: 1fr 1fr 1fr
            }
        }

        @media(max-width:760px) {
            .ib-filters {
                grid-template-columns: 1fr
            }
        }
    </style>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="ib-page">
        <div class="ib-hero">
            <h2>Import Billing</h2>
            <div>Import the monthly billing Excel, verify the preview, and send approved billing to Accounts.</div>
        </div>
        <ul class="nav nav-pills ib-tabs" role="tablist">
            <li class="nav-item"><a class="nav-link active" data-toggle="pill" href="#ibImportTab" role="tab">Import Billing</a></li>
            <li class="nav-item"><a class="nav-link" data-toggle="pill" href="#ibHistoryTab" role="tab">Billing History</a></li>
        </ul>
        <div class="tab-content">
            <div id="ibImportTab" class="tab-pane fade show active" role="tabpanel">
                <div class="ib-card">
                    <div class="ib-head">Monthly Billing Import</div>
                    <div class="ib-body">
                        <div class="ib-filters">
                            <div>
                                <label for="ibProject">Project #</label><select id="ibProject" class="form-control"><option value="">Select Project</option>
                                </select></div>
                            <div>
                                <label for="ibMonth">Billing Month</label><select id="ibMonth" class="form-control"></select></div>
                            <div>
                                <label for="ibYear">Billing Year</label><select id="ibYear" class="form-control"></select></div>
                            <div>
                                <label for="ibFile">Billing Excel (.xls/.xlsx)</label><input id="ibFile" type="file" accept=".xls,.xlsx" class="form-control ib-file" /></div>
                            <div>
                                <label>Project Template</label>
                                <button type="button" id="ibDownloadTemplate" class="btn btn-outline-success ib-template-btn" disabled><i class="fas fa-file-excel"></i>Download Template</button></div>
                            <div>
                                <button type="button" id="ibImport" class="btn btn-primary">Import</button><span id="ibLoading" class="ib-loading">Importing...</span></div>
                        </div>
                    </div>
                </div>
                <div id="ibPreviewCard" class="ib-card" style="display: none">
                    <div class="ib-head">Imported Billing Preview</div>
                    <div class="ib-body">
                        <div id="ibSummary" class="ib-summary"></div>
                        <div class="ib-actions">
                            <button type="button" id="ibVerify" class="btn btn-success">Verify</button>
                            <button type="button" id="ibSend" class="btn btn-info" disabled>Send to Accounts</button></div>
                        <div class="ib-wrap">
                            <table id="ibTable" class="table table-bordered table-striped table-hover"></table>
                        </div>
                    </div>
                </div>
            </div>
            <div id="ibHistoryTab" class="tab-pane fade" role="tabpanel">
                <div class="ib-card">
                    <div class="ib-head">Billing History Filters</div>
                    <div class="ib-body">
                        <div class="ib-filters ib-history-filters">
                            <div>
                                <label for="ibHistoryProject">Project #</label><select id="ibHistoryProject" class="form-control"><option value="">Select Project</option>
                                </select></div>
                            <div>
                                <label for="ibHistoryMonth">Billing Month</label><select id="ibHistoryMonth" class="form-control"></select></div>
                            <div>
                                <label for="ibHistoryYear">Billing Year</label><select id="ibHistoryYear" class="form-control"></select></div>
                            <div>
                                <button type="button" id="ibHistoryShow" class="btn btn-primary">Show History</button><span id="ibHistoryLoading" class="ib-loading">Loading...</span></div>
                        </div>
                    </div>
                </div>
                <div id="ibHistoryCard" class="ib-card" style="display: none">
                    <div class="ib-head">Records Sent to Accounts</div>
                    <div class="ib-body">
                        <div id="ibHistorySummary" class="ib-summary"></div>
                        <div class="ib-wrap">
                            <table id="ibHistoryTable" class="table table-bordered table-striped table-hover"></table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="../plugins/sweetalert2/sweetalert2.all.min.js"></script>
    <script src="../Scripts/TrackingSheet/ImportBilling.js"></script>
</asp:Content>
