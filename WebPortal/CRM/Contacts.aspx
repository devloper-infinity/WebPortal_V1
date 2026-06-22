<%@ Page Title="" Language="C#" MasterPageFile="~/CRM/CRM.Master" AutoEventWireup="true" CodeBehind="Contacts.aspx.cs" Inherits="WebPortal.CRM.Contacts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="crm-page" data-crm-page="list" data-crm-entity="Contact">
        <div class="crm-module-header">
            <div>
                <span class="crm-eyebrow">People and relationships</span>
                <h1>Contacts</h1>
                <p>Track buyers, influencers, support contacts, communication preferences, and relationship ownership.</p>
            </div>
            <button type="button" class="btn btn-primary crm-open-editor" data-entity="Contact"><i class="fas fa-user-plus"></i> New contact</button>
        </div>
        <div class="crm-toolbar">
            <div class="crm-search"><i class="fas fa-search"></i><input type="text" class="form-control crm-search-input" placeholder="Search name, account, email, phone"></div>
            <select class="form-control crm-status-filter" data-placeholder="All designations"></select>
            <select class="form-control crm-owner-filter"></select>
        </div>
        <div class="crm-table-wrap crm-panel">
            <table class="table table-hover crm-record-table" id="crmContactTable">
                <thead>
                    <tr>
                        <th>Contact</th>
                        <th>Account</th>
                        <th>Title</th>
                        <th>Email</th>
                        <th>Owner</th>
                        <th>Last contacted</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>
</asp:Content>
