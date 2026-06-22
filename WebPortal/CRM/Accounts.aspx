<%@ Page Title="" Language="C#" MasterPageFile="~/CRM/CRM.Master" AutoEventWireup="true" CodeBehind="Accounts.aspx.cs" Inherits="WebPortal.CRM.Accounts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="crm-page" data-crm-page="list" data-crm-entity="Account">
        <div class="crm-module-header">
            <div>
                <span class="crm-eyebrow">Customer companies</span>
                <h1>Accounts</h1>
                <p>Manage companies, industries, account ownership, relationship value, and active customer status.</p>
            </div>
            <button type="button" class="btn btn-primary crm-open-editor" data-entity="Account"><i class="fas fa-building"></i> New account</button>
        </div>
        <div class="crm-toolbar">
            <div class="crm-search"><i class="fas fa-search"></i><input type="text" class="form-control crm-search-input" placeholder="Search account, website, city"></div>
            <select class="form-control crm-status-filter" data-placeholder="All types"></select>
            <select class="form-control crm-owner-filter"></select>
        </div>
        <div class="crm-table-wrap crm-panel">
            <table class="table table-hover crm-record-table" id="crmAccountTable">
                <thead>
                    <tr>
                        <th>Account</th>
                        <th>Industry</th>
                        <th>Type</th>
                        <th>Owner</th>
                        <th>Annual revenue</th>
                        <th>Updated</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>
</asp:Content>
