<%@ Page Title="Monthly Billing" Language="C#" MasterPageFile="~/Production/Production.Master" AutoEventWireup="true" CodeBehind="MonthlyBilling.aspx.cs" Inherits="WebPortal.TrackingSheet.MonthlyBilling" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../plugins/sweetalert2/sweetalert2.min.css" />
    <style>
        .mb-page{padding:18px;color:#17324d}.mb-hero,.mb-card{background:#fff;border:1px solid #d7e3ef;border-radius:10px;margin-bottom:20px}.mb-hero{border-left:6px solid #117a9b;padding:20px 26px}.mb-hero h2{margin:0 0 6px;font-weight:700}.mb-tabs{margin-bottom:18px}.mb-tabs .nav-link{font-weight:700}.mb-head{padding:14px 20px;background:#f3f7fb;border-bottom:1px solid #d7e3ef;font-weight:700}.mb-body{padding:20px}.mb-filters{display:grid;grid-template-columns:minmax(240px,1fr) 180px 160px auto;gap:16px;align-items:end}.mb-filters label{display:block;margin-bottom:6px;font-weight:600}.mb-actions{display:flex;gap:10px;align-items:center;margin:14px 0}.mb-summary{color:#415d76;font-weight:600}.mb-wrap{width:100%;overflow:auto}.mb-wrap table{width:100%!important}.mb-wrap th,.mb-wrap td{white-space:nowrap}.mb-loading{display:none;margin-left:8px;color:#117a9b;font-weight:600}.mb-status{display:inline-block;padding:3px 8px;border-radius:12px;font-size:12px;font-weight:700}.mb-verified{background:#dff4e8;color:#176b41}.mb-sent{background:#dceeff;color:#145a86}.mb-pending{background:#fff3cd;color:#856404}@media(max-width:900px){.mb-filters{grid-template-columns:1fr 1fr}}@media(max-width:600px){.mb-filters{grid-template-columns:1fr}}
    </style>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="mb-page">
        <div class="mb-hero"><h2>Monthly Billing</h2><div>Verify records dispatched in a billing period and send verified billing to Accounts.</div></div>
        <ul class="nav nav-pills mb-tabs" role="tablist">
            <li class="nav-item"><a class="nav-link active" data-toggle="pill" href="#mbVerification" role="tab">Verification &amp; Send to Accounts</a></li>
            <li class="nav-item"><a class="nav-link" data-toggle="pill" href="#mbHistory" role="tab">Billing History</a></li>
        </ul>
        <div class="tab-content">
            <div id="mbVerification" class="tab-pane fade show active" role="tabpanel">
                <div class="mb-card"><div class="mb-head">Billing Period</div><div class="mb-body"><div class="mb-filters">
                    <div><label for="mbProject">Project #</label><select id="mbProject" class="form-control"><option value="">Select Project</option></select></div>
                    <div><label for="mbMonth">Billing Month</label><select id="mbMonth" class="form-control"></select></div>
                    <div><label for="mbYear">Billing Year</label><select id="mbYear" class="form-control"></select></div>
                    <div><button type="button" id="mbShow" class="btn btn-primary">Show</button><span id="mbLoading" class="mb-loading">Loading...</span></div>
                </div></div></div>
                <div id="mbResult" class="mb-card" style="display:none"><div class="mb-head">Dispatched Records</div><div class="mb-body">
                    <div id="mbSummary" class="mb-summary"></div><div class="mb-actions"><button type="button" id="mbVerify" class="btn btn-success" disabled>Verify Selected</button><button type="button" id="mbSend" class="btn btn-info" disabled>Send to Accounts</button></div>
                    <div class="mb-wrap"><table id="mbTable" class="table table-bordered table-striped table-hover"></table></div>
                </div></div>
            </div>
            <div id="mbHistory" class="tab-pane fade" role="tabpanel">
                <div class="mb-card"><div class="mb-head">Billing History Filters</div><div class="mb-body"><div class="mb-filters">
                    <div><label for="mbHistoryProject">Project #</label><select id="mbHistoryProject" class="form-control"><option value="">Select Project</option></select></div>
                    <div><label for="mbHistoryMonth">Billing Month</label><select id="mbHistoryMonth" class="form-control"></select></div>
                    <div><label for="mbHistoryYear">Billing Year</label><select id="mbHistoryYear" class="form-control"></select></div>
                    <div><button type="button" id="mbHistoryShow" class="btn btn-primary">Show History</button><span id="mbHistoryLoading" class="mb-loading">Loading...</span></div>
                </div></div></div>
                <div id="mbHistoryResult" class="mb-card" style="display:none"><div class="mb-head">Records Sent to Accounts</div><div class="mb-body"><div id="mbHistorySummary" class="mb-summary"></div><div class="mb-wrap"><table id="mbHistoryTable" class="table table-bordered table-striped table-hover"></table></div></div></div>
            </div>
        </div>
    </div>
    <script src="../plugins/sweetalert2/sweetalert2.all.min.js"></script>
    <script src="../Scripts/TrackingSheet/MonthlyBilling.js"></script>
</asp:Content>
