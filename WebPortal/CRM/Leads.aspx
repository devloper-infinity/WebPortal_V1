<%@ Page Title="" Language="C#" MasterPageFile="~/CRM/CRM.Master" AutoEventWireup="true" CodeBehind="Leads.aspx.cs" Inherits="WebPortal.CRM.Leads" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="crm-page" data-crm-page="list" data-crm-entity="Lead">
        <div class="crm-module-header">
            <div>
                <span class="crm-eyebrow">Lead management</span>
                <h1>Leads</h1>
                <p>Capture prospects, qualify interest, assign ownership, and convert winning conversations into accounts and deals.</p>
            </div>
            <button type="button" class="btn btn-primary crm-open-editor" data-entity="Lead"><i class="fas fa-plus"></i> New lead</button>
        </div>
        <div class="crm-toolbar">
            <div class="crm-search"><i class="fas fa-search"></i><input type="text" class="form-control crm-search-input" placeholder="Search name, company, email, phone"></div>
            <select class="form-control crm-status-filter" data-placeholder="All statuses"></select>
            <select class="form-control crm-owner-filter"></select>
        </div>
        <div class="crm-table-wrap crm-panel">
            <table class="table table-hover crm-record-table" id="crmLeadTable">
                <thead>
                    <tr>
                        <th>Lead</th>
                        <th>Company</th>
                        <th>Status</th>
                        <th>Source</th>
                        <th>Owner</th>
                        <th>Next follow-up</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>
</asp:Content>
