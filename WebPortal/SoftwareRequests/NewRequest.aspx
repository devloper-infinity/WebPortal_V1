<%@ Page Title="New Software Request" Language="C#" MasterPageFile="~/IT/Admin.Master" AutoEventWireup="true" CodeBehind="NewRequest.aspx.cs" Inherits="WebPortal.SoftwareRequests.NewRequest" %>

<asp:Content ID="H" ContentPlaceHolderID="head" runat="server">
    <link href="../Content/software-requests.css?v=10" rel="stylesheet" />
</asp:Content>
<asp:Content ID="B" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="srm">
        <div class="srm-head">
            <div>
                <h3>New Software Request</h3>
                <span>Submit a requirement to the Software Department</span></div>
        </div>
        <div id="srmAlert" class="srm-alert"></div>
        <div class="srm-card compact">
            <div class="srm-profile"><b id="profileName"></b><span id="profileDepartment"></span></div>
            <div class="srm-form">
                <div>
                    <label>Request Type *</label><select id="rqType"></select></div>
                <div>
                    <label>Requested Priority *</label><select id="rqPriority"></select></div>
                <div>
                    <label>Software / Application *</label><select id="rqApp"></select></div>
                <div>
                    <label>Module</label><select id="rqModule"></select></div>
                <div class="wide">
                    <label>Title *</label><input id="rqTitle" maxlength="250" /></div>
                <div class="wide">
                    <label>Requirement / Description *</label><textarea id="rqDescription"></textarea></div>
                <div class="wide">
                    <label>Business Justification</label><textarea id="rqJustification"></textarea></div>
                <div>
                    <label>Required By Date</label><input id="rqDate" type="date" /></div>
                <div>
                    <label>Attachment (optional, max 5 MB)</label><input id="rqAttachment" type="file" accept=".pdf,.png,.jpg,.jpeg,.doc,.docx,.xls,.xlsx" /></div>
            </div>
            <button type="button" class="srm-btn" onclick="NewSRM.create()">Submit Request</button></div>
        <div class="srm-card">
            <h4>My Requests / Current Status</h4>
            <div class="srm-table-wrap">
                <table class="srm-table">
                    <thead>
                        <tr>
                            <th>Request ID</th>
                            <th>Date</th>
                            <th>Request</th>
                            <th>Software</th>
                            <th>Module</th>
                            <th>Assigned Developer</th>
                            <th>Status</th>
                            <th>Expected Completion</th>
                            <th>Last Update</th>
                        </tr>
                    </thead>
                    <tbody id="myRequestRows"></tbody>
                </table>
            </div>
        </div>
    </div>
    <script src="../Scripts/software-new-request.js?v=4"></script>
</asp:Content>
