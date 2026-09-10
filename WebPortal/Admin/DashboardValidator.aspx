<%@ Page Title="Dashboard Validator" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="DashboardValidator.aspx.cs" Inherits="WebPortal.Admin.DashboardValidator" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../Content/erp-modern-common.css" />
    <style>
        .dv-form { max-width: 900px; }
        .dv-actions { display: flex; align-items: center; gap: 12px; margin-top: 18px; }
        .dv-note { color: #64748b; font-size: 13px; margin-top: 6px; }
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid">
        <div class="erp-dashboard-header">
            <div class="erp-dashboard-header-content">
                <div class="erp-dashboard-icon"><i class="fas fa-file-excel"></i></div>
                <div>
                    <h1 class="erp-dashboard-title">Dashboard Validator</h1>
                    <p class="erp-dashboard-subtitle">Generate the cleaned dashboard workbook from the uploaded report.</p>
                </div>
            </div>
        </div>

        <% if (!string.IsNullOrWhiteSpace(ErrorMessage)) { %>
        <div class="alert alert-danger"><%= Server.HtmlEncode(ErrorMessage) %></div>
        <% } %>

        <section class="erp-section-card p-4 dv-form erp-modern-form">
            <div class="form-group">
                <label for="dashboardReportFile">Dashboard Report</label>
                <input id="dashboardReportFile" name="dashboardReportFile" type="file" class="form-control" accept=".xlsx" required />
            </div>
            <div class="form-group mt-3">
                <label for="validationFile">Validation File</label>
                <input id="validationFile" name="validationFile" type="file" class="form-control" accept=".xlsx" required />
                <div class="dv-note">Required for the workflow. Its data is reserved for future validation logic.</div>
            </div>
            <div class="dv-actions">
                <button id="generateButton" type="submit" class="btn btn-success">
                    <i class="fas fa-download"></i> Generate Cleaned Report
                </button>
                <span id="generateStatus" class="dv-note" style="display:none">Processing workbook...</span>
            </div>
        </section>
    </div>
    <script>
        (function () {
            var button = document.getElementById('generateButton');
            if (!button) return;
            button.closest('form').addEventListener('submit', function () {
                if (!this.checkValidity()) return;
                button.disabled = true;
                document.getElementById('generateStatus').style.display = 'inline';
                window.setTimeout(function () {
                    button.disabled = false;
                    document.getElementById('generateStatus').style.display = 'none';
                }, 5000);
            });
        })();
    </script>
</asp:Content>
