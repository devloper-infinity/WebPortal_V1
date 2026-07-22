<%@ Page Title="Import Tracking Data" Language="C#" MasterPageFile="~/Production/Production.Master" AutoEventWireup="true" CodeBehind="ImportData.aspx.cs" Inherits="WebPortal.TrackingSheet.ImportData" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .ol-import {
            padding: 18px;
            color: #17324d;
        }

        .ol-import-header {
            background: #fff;
            border: 1px solid #d7e3ef;
            border-left: 6px solid #117a9b;
            border-radius: 10px;
            padding: 20px 26px;
            margin-bottom: 20px;
        }

            .ol-import-header h2 {
                margin: 0 0 6px;
                font-weight: 700;
            }

        .ol-import-card {
            background: #fff;
            border: 1px solid #d7e3ef;
            border-radius: 10px;
            margin-bottom: 20px;
            overflow: hidden;
        }

            .ol-import-card h4 {
                margin: 0;
                padding: 14px 20px;
                background: #f3f7fb;
                border-bottom: 1px solid #d7e3ef;
                font-weight: 700;
            }

        .ol-import-body {
            padding: 20px;
        }

        .ol-import-grid {
            display: grid;
            grid-template-columns: minmax(260px, 1fr) auto;
            gap: 16px;
            align-items: end;
        }

        .ol-import-upload {
            display: grid;
            grid-template-columns: minmax(320px, 1fr) auto;
            gap: 16px;
            align-items: end;
        }

        .ol-help {
            color: #5d7287;
            margin-top: 8px;
        }

        .ol-message {
            display: block;
            margin: 0 0 18px;
            padding: 12px 16px;
            border-radius: 6px;
            font-weight: 600;
        }

        .ol-success {
            background: #e8f7ef;
            color: #176b41;
            border: 1px solid #a8dfc1;
        }

        .ol-error {
            background: #fff0f0;
            color: #9f2424;
            border: 1px solid #efb8b8;
            white-space: pre-line;
        }

        .ol-field-summary {
            margin-top: 12px;
            padding: 10px 12px;
            background: #f7fafc;
            border-radius: 6px;
        }

        .ol-destination {
            display: block;
            margin: 0 0 16px;
            padding: 14px 16px;
            background: #eaf5fb;
            border: 1px solid #a9d4e7;
            border-left: 5px solid #117a9b;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 700;
        }

        .ol-history {
            width: 100%;
            border-collapse: collapse;
        }

            .ol-history th, .ol-history td {
                padding: 10px;
                border-bottom: 1px solid #e2eaf2;
                text-align: left;
            }

            .ol-history th {
                background: #f6f9fc;
            }

        @media (max-width:760px) {
            .ol-import-grid, .ol-import-upload {
                grid-template-columns: 1fr;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="ol-import">
        <div class="ol-import-header">
            <h2>Import Tracking Data</h2>
            <div>Download a project-specific template and import tracking rows from Excel.</div>
        </div>

        <asp:Label ID="lblMessage" runat="server" Visible="false" />

        <div class="ol-import-card">
            <h4>1. Download Template</h4>
            <div class="ol-import-body">
                <div class="ol-import-grid">
                    <div>
                        <label for="ddlProject">Project</label>
                        <asp:DropDownList ID="ddlProject" runat="server" CssClass="form-control" AutoPostBack="true" onchange="OLT.showLoading('Loading project import configuration...');" OnSelectedIndexChanged="ddlProject_SelectedIndexChanged" />
                    </div>
                    <asp:Button ID="btnDownloadTemplate" runat="server" Text="Download Import Template" CssClass="btn btn-primary" OnClientClick="OLT.showLoading('Preparing import template...'); window.setTimeout(function(){ OLT.hideLoading(true); }, 5000);" OnClick="btnDownloadTemplate_Click" />
                </div>
                <asp:Label ID="lblConfiguredFields" runat="server" CssClass="ol-field-summary" />
                <div class="ol-help">The template contains only fields marked <strong>For Import</strong>. Its hidden identity sheet lets the upload recognize the project automatically.</div>
            </div>
        </div>

        <div class="ol-import-card">
            <h4>2. Import Completed Template</h4>
            <div class="ol-import-body">
                <asp:Label ID="lblImportProject" runat="server" CssClass="ol-destination" />
                <div class="ol-import-upload">
                    <div>
                        <label for="fuImportFile">Excel file (.xlsx)</label>
                        <asp:FileUpload ID="fuImportFile" runat="server" CssClass="form-control" accept=".xlsx" />
                    </div>
                    <asp:Button ID="btnImport" runat="server" Text="Import into Selected Project" CssClass="btn btn-success" OnClientClick="OLT.showLoading('Validating and importing data...');" OnClick="btnImport_Click" />
                </div>
                <div class="ol-help">The selected project must match the project identified inside the template. A mismatch is rejected before any data is saved.</div>
            </div>
        </div>

        <div class="ol-import-card">
            <h4>Recent Imports</h4>
            <div class="ol-import-body">
                <asp:GridView ID="gvRecentImports" runat="server" AutoGenerateColumns="false" CssClass="ol-history" EmptyDataText="No imports completed yet.">
                    <Columns>
                        <asp:BoundField DataField="ImportBatchId" HeaderText="Batch #" />
                        <asp:BoundField DataField="ProjectName" HeaderText="Project" />
                        <asp:BoundField DataField="OriginalFileName" HeaderText="File" />
                        <asp:BoundField DataField="TotalRows" HeaderText="Rows" />
                        <asp:BoundField DataField="ImportStatus" HeaderText="Status" />
                        <asp:BoundField DataField="ImportedDate" HeaderText="Imported On" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
    <script src="OLTracking.js"></script>
</asp:Content>
