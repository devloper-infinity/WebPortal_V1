<%@ Page Title="" Language="C#" MasterPageFile="~/CRM/CRM.Master" AutoEventWireup="true" CodeBehind="Deals.aspx.cs" Inherits="WebPortal.CRM.Deals" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="crm-page" data-crm-page="deals" data-crm-entity="Deal">
        <div class="crm-module-header">
            <div>
                <span class="crm-eyebrow">Opportunity pipeline</span>
                <h1>Deals</h1>
                <p>Forecast revenue, move opportunities through stages, and coordinate account-level sales action.</p>
            </div>
            <button type="button" class="btn btn-primary crm-open-editor" data-entity="Deal"><i class="fas fa-handshake"></i> New deal</button>
        </div>
        <div class="crm-toolbar">
            <div class="crm-search"><i class="fas fa-search"></i><input type="text" class="form-control crm-search-input" placeholder="Search deal, account, contact"></div>
            <select class="form-control crm-status-filter" data-placeholder="All stages"></select>
            <select class="form-control crm-owner-filter"></select>
        </div>
        <div class="crm-kanban" id="crmDealKanban"></div>
        <div class="crm-table-wrap crm-panel">
            <table class="table table-hover crm-record-table" id="crmDealTable">
                <thead>
                    <tr>
                        <th>Deal</th>
                        <th>Account</th>
                        <th>Stage</th>
                        <th>Amount</th>
                        <th>Close date</th>
                        <th>Owner</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>
</asp:Content>
