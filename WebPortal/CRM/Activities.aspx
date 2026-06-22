<%@ Page Title="" Language="C#" MasterPageFile="~/CRM/CRM.Master" AutoEventWireup="true" CodeBehind="Activities.aspx.cs" Inherits="WebPortal.CRM.Activities" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="crm-page" data-crm-page="list" data-crm-entity="Activity">
        <div class="crm-module-header">
            <div>
                <span class="crm-eyebrow">Tasks, calls, meetings</span>
                <h1>Activities</h1>
                <p>Schedule follow-ups, record conversations, and keep every customer commitment visible.</p>
            </div>
            <button type="button" class="btn btn-primary crm-open-editor" data-entity="Activity"><i class="fas fa-calendar-plus"></i> New activity</button>
        </div>
        <div class="crm-toolbar">
            <div class="crm-search"><i class="fas fa-search"></i><input type="text" class="form-control crm-search-input" placeholder="Search subject, related record, notes"></div>
            <select class="form-control crm-status-filter" data-placeholder="All statuses"></select>
            <select class="form-control crm-owner-filter"></select>
        </div>
        <div class="crm-table-wrap crm-panel">
            <table class="table table-hover crm-record-table" id="crmActivityTable">
                <thead>
                    <tr>
                        <th>Activity</th>
                        <th>Type</th>
                        <th>Related to</th>
                        <th>Status</th>
                        <th>Due date</th>
                        <th>Owner</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>
</asp:Content>
