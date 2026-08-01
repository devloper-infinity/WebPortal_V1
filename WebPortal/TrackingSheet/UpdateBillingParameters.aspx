<%@ Page Title="Update Billing Parameters" Language="C#" MasterPageFile="~/Production/Production.Master" AutoEventWireup="true" CodeBehind="UpdateBillingParameters.aspx.cs" Inherits="WebPortal.TrackingSheet.UpdateBillingParameters" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../plugins/sweetalert2/sweetalert2.min.css" />
    <style>
        .bp-page {
            color: #17324d
        }

        .bp-hero, .bp-card {
            background: #fff;
            border: 1px solid #d7e3ef;
            border-radius: 10px;
            margin-bottom: 20px
        }

        .bp-hero {
            border-left: 6px solid #117a9b;
            padding: 16px 17px;
        }

            .bp-hero h2 {
                margin: 0 0 6px;
                font-weight: 700;
                font-size: 22px;
            }

        .bp-head {
            padding: 14px 20px;
            background: #f3f7fb;
            border-bottom: 1px solid #d7e3ef;
            font-weight: 700
        }

        .bp-body {
            padding: 20px
        }

        .bp-grid {
            display: grid;
            grid-template-columns: minmax(280px,1fr) auto;
            gap: 16px;
            align-items: end
        }

            .bp-grid label {
                display: block;
                margin-bottom: 6px;
                font-weight: 600
            }

        .bp-summary {
            margin-top: 12px;
            padding: 10px 12px;
            background: #f7fafc;
            border-radius: 6px;
            color: #5d7287
        }

        .bp-help {
            margin-top: 10px;
            color: #5d7287
        }

        .bp-loading {
            display: none;
            margin-left: 8px;
            color: #117a9b;
            font-weight: 600
        }

        @media(max-width:760px) {
            .bp-grid {
                grid-template-columns: 1fr
            }
        }
    </style>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="bp-page">
        <div class="bp-hero">
            <h2>Update Billing Parameters</h2>
            <div>Download the project template and update billing values on records imported through Tracking Sheet Import Data.</div>
        </div>
        <div class="bp-card">
            <div class="bp-head">1. Download Template</div>
            <div class="bp-body">
                <div class="bp-grid">
                    <div>
                        <label for="bpProject">Project</label><select id="bpProject" class="form-control" style="height: 42px;"><option value="">Select Project</option>
                        </select>
                    </div>
                    <button type="button" id="bpDownload" class="btn btn-primary">Download Template</button>
                </div>
                <div id="bpFields" class="bp-summary">Select a project to view its billing parameter columns.</div>
                <div class="bp-help">Columns A-D locate the record. Dispatch Date and configured billing parameters are updated.</div>
            </div>
        </div>
        <div class="bp-card">
            <div class="bp-head">2. Import Completed Template</div>
            <div class="bp-body">
                <div class="bp-grid">
                    <div>
                        <label for="bpFile">Excel file (.xlsx)</label><input id="bpFile" type="file" class="form-control" accept=".xlsx" />
                    </div>
                    <div>
                        <button type="button" id="bpImport" class="btn btn-success">Import and Update</button><span id="bpLoading" class="bp-loading">Processing...</span>
                    </div>
                </div>
                <div class="bp-help">Maximum file size: 10 MB. Maximum rows: 5,000.</div>
            </div>
        </div>
    </div>
    <script src="../plugins/sweetalert2/sweetalert2.all.min.js"></script>
    <script src="../Scripts/TrackingSheet/UpdateBillingParameters.js"></script>
</asp:Content>
