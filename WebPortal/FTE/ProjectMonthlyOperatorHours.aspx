<%@ Page Title="" Language="C#" MasterPageFile="~/FTE/FTE.Master" AutoEventWireup="true" CodeBehind="ProjectMonthlyOperatorHours.aspx.cs" Inherits="WebPortal.FTE.ProjectMonthlyOperatorHours" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
    .erp-page { padding: 14px; }
    .erp-hero {
        background: linear-gradient(135deg,#f8fafc,#eef6ff);
        border: 1px solid #dbe7f3;
        border-radius: 10px;
        padding: 14px 18px;
        margin-bottom: 14px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .erp-hero h2 { margin: 0; font-size: 20px; font-weight: 700; color: #223044; }
    .erp-hero p { margin: 3px 0 0; color: #64748b; font-size: 13px; }
    .erp-panel {
        background: #fff;
        border: 1px solid #dbe3ec;
        border-radius: 10px;
        padding: 14px;
        margin-bottom: 14px;
        box-shadow: 0 1px 3px rgba(15,23,42,.06);
    }
    .erp-panel-title { font-size: 14px; font-weight: 700; color: #334155; margin-bottom: 12px; }
    .erp-form-grid {
        display: grid;
        grid-template-columns: repeat(4,minmax(180px,1fr));
        gap: 12px 14px;
    }
    .erp-form-group label { display: block; font-weight: 600; color: #475569; margin-bottom: 5px; font-size: 12px; }
    .erp-control { width: 100%; height: 34px; border: 1px solid #cbd5e1; border-radius: 6px; padding: 5px 8px; }
    .erp-actions { display: flex; gap: 8px; align-items: center; margin-top: 12px; }
    .erp-actions.right { justify-content: flex-end; }
    .btn-erp { border: 0; border-radius: 7px; padding: 8px 14px; font-weight: 700; cursor: pointer; }
    .btn-primary-erp { background: #2563eb; color: #fff; }
    .btn-success-erp { background: #16a34a; color: #fff; }
    .btn-light-erp { background: #e2e8f0; color: #334155; }
    .summary-grid {
        display: grid;
        grid-template-columns: repeat(6,1fr);
        gap: 10px;
    }
    .summary-item { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 10px; }
    .summary-label { font-size: 11px; color: #64748b; text-transform: uppercase; font-weight: 700; }
    .summary-value { margin-top: 4px; color: #1e293b; font-weight: 800; }
    .table-wrapper { overflow: auto; border: 1px solid #cbd5e1; border-radius: 8px; }
    .erp-table { width: 100%; border-collapse: collapse; font-size: 13px; }
    .erp-table th { background: #c7bea0; color: #000; border: 1px solid #000; padding: 6px; text-align: center; white-space: nowrap; }
    .erp-table td { border: 1px solid #000; padding: 3px; text-align: center; background: #d9d9d9; }
    .erp-table input[type=text] { width: 76px; text-align: center; border: 1px solid transparent; background: transparent; padding: 3px; }
    .erp-table input[type=text]:focus { background: #fff; border-color: #2563eb; outline: none; border-radius: 4px; }
    .holiday-box { color: #3b82f6 !important; font-weight: 700; }
    .msg { display: block; margin-top: 8px; font-weight: 700; }
    @media(max-width:1100px){ .erp-form-grid,.summary-grid{grid-template-columns:repeat(2,1fr);} }
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="erp-page">
    <div class="erp-hero">
        <div>
            <h2>Monthly Operator Hours</h2>
            <p>Generate project-wise operator hour sheet from approved FTE and configured billable hours.</p>
        </div>
    </div>

    <div class="erp-panel">
        <div class="erp-panel-title">Selection</div>
        <div class="erp-form-grid">
            <div class="erp-form-group">
                <label>Month</label>
                <asp:DropDownList ID="ddlMonth" runat="server" CssClass="erp-control" />
            </div>
            <div class="erp-form-group">
                <label>Year</label>
                <asp:TextBox ID="txtYear" runat="server" CssClass="erp-control" />
            </div>
            <div class="erp-form-group">
                <label>Project</label>
                <asp:DropDownList ID="ddlProject" runat="server" CssClass="erp-control" AutoPostBack="true" OnSelectedIndexChanged="ddlProject_SelectedIndexChanged" />
            </div>
            <div class="erp-form-group">
                <label>Extra Operator Columns</label>
                <asp:TextBox ID="txtExtraOperators" runat="server" CssClass="erp-control" Text="2" />
            </div>
        </div>
        <div class="erp-actions right">
            <asp:Button ID="btnLoadConfig" runat="server" Text="Load Config" CssClass="btn-erp btn-light-erp" OnClick="btnLoadConfig_Click" />
            <asp:Button ID="btnGenerate" runat="server" Text="Generate" CssClass="btn-erp btn-primary-erp" OnClick="btnGenerate_Click" />
            <asp:Button ID="btnSave" runat="server" Text="Save Draft" CssClass="btn-erp btn-success-erp" OnClick="btnSave_Click" />
        </div>
        <asp:Label ID="lblMessage" runat="server" CssClass="msg" />
    </div>

    <div class="erp-panel">
        <div class="erp-panel-title">Configuration Summary</div>
        <div class="summary-grid">
            <div class="summary-item"><div class="summary-label">Project</div><div class="summary-value"><asp:Label ID="lblProject" runat="server" Text="-" /></div></div>
            <div class="summary-item"><div class="summary-label">Process</div><div class="summary-value"><asp:Label ID="lblProcess" runat="server" Text="-" /></div></div>
            <div class="summary-item"><div class="summary-label">Approved FTE</div><div class="summary-value"><asp:Label ID="lblFTE" runat="server" Text="-" /></div></div>
            <div class="summary-item"><div class="summary-label">Billable Hours</div><div class="summary-value"><asp:Label ID="lblHours" runat="server" Text="-" /></div></div>
            <div class="summary-item"><div class="summary-label">Weekend</div><div class="summary-value"><asp:Label ID="lblWeekend" runat="server" Text="-" /></div></div>
            <div class="summary-item"><div class="summary-label">US Holiday</div><div class="summary-value"><asp:Label ID="lblUSHoliday" runat="server" Text="-" /></div></div>
        </div>
    </div>

    <div class="erp-panel">
        <div class="erp-panel-title">Monthly Sheet</div>
        <div class="table-wrapper">
            <asp:GridView ID="gvHours" runat="server" CssClass="erp-table" AutoGenerateColumns="false" OnRowDataBound="gvHours_RowDataBound" />
        </div>
    </div>

    <asp:HiddenField ID="hfHeaderId" runat="server" />
</div>
</asp:Content>
