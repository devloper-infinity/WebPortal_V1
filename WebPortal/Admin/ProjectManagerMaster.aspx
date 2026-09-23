<%@ Page Title="Project Manager Master" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ProjectManagerMaster.aspx.cs" Inherits="WebPortal.Admin.ProjectManagerMaster" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <style>
        .pmm { color:#172737; }
        .pmm-hero { background:linear-gradient(135deg,#0f766e,#1d4ed8); color:#fff; padding:20px 24px; border-radius:8px; margin-bottom:18px; }
        .pmm-card { background:#fff; border:1px solid #dce5ec; border-radius:8px; margin-bottom:18px; }
        .pmm-title { padding:15px 18px; border-bottom:1px solid #e7edf2; font-weight:700; }
        .pmm-body { padding:18px; }
        .pmm-form { display:flex; gap:12px; align-items:end; max-width:760px; }
        .pmm-field { flex:1; }
        .pmm-field label { display:block; font-size:12px; font-weight:700; margin-bottom:6px; }
        .pmm-button { border:0; border-radius:6px; padding:8px 16px; font-weight:700; background:#0f766e; color:#fff; }
        .pmm-delete { border:1px solid #fecaca; border-radius:5px; padding:5px 10px; background:#fff; color:#b91c1c; }
        .pmm-message { display:none; margin-bottom:14px; padding:10px 14px; border-radius:6px; font-size:13px; font-weight:700; }
        .pmm-message.success { display:block; background:#dcfce7; color:#166534; }
        .pmm-message.error { display:block; background:#fee2e2; color:#991b1b; }
        .pmm-table-wrap { overflow:auto; max-height:600px; }
        .pmm table { width:100%; border-collapse:collapse; }
        .pmm th,.pmm td { padding:9px 11px; border-bottom:1px solid #e2e9ef; font-size:12px; white-space:nowrap; text-align:left; }
        .pmm th { position:sticky; top:0; background:#edf3f6; }
        @media(max-width:700px) { .pmm-form { display:block; } .pmm-field { margin-bottom:12px; } }
    </style>
    <script>
        $(function () { loadProjectManagers(); $('#pmmAdd').on('click', addProjectManager); });
        function pmmCall(method, data) { return $.ajax({ url:'ProjectManagerMaster.aspx/' + method, type:'POST', data:JSON.stringify(data || {}), contentType:'application/json; charset=utf-8', dataType:'json' }); }
        function pmmMessage(text, type) { $('#pmmMessage').removeClass('success error').addClass(type).text(text); }
        function pmmError(xhr) { pmmMessage((xhr.responseJSON && xhr.responseJSON.Message) || 'Operation failed.', 'error'); }
        function loadProjectManagers() {
            pmmCall('GetPageData').done(function (response) {
                var data = response.d, select = $('#pmmEmployee').empty().append($('<option>').val('').text('Select an employee'));
                $.each(data.Users, function (_, user) { select.append($('<option>').val(user.Code).text(user.DisplayName)); });
                var rows = $('#pmmRows').empty();
                $.each(data.ProjectManagers, function (index, manager) {
                    var row = $('<tr>');
                    $('<td>').text(index + 1).appendTo(row); $('<td>').text(manager.PMName).appendTo(row);
                    $('<td>').text(manager.AddedByName).appendTo(row); $('<td>').text(manager.AddedDate).appendTo(row);
                    $('<td>').append($('<button type="button" class="pmm-delete">').text('Delete').on('click', function () { deleteProjectManager(manager.ProjectManagerID, manager.PMName); })).appendTo(row);
                    rows.append(row);
                });
                if (!data.ProjectManagers.length) rows.append('<tr><td colspan="5">No project managers found.</td></tr>');
            }).fail(pmmError);
        }
        function addProjectManager() {
            var code = $('#pmmEmployee').val(); if (!code) { pmmMessage('Please select a project manager.', 'error'); return; }
            pmmCall('AddProjectManager', { projectManagerCode:code, restore:false }).done(function (response) {
                if (response.d === -1 && window.confirm('This project manager was deleted earlier. Do you want to restore it?')) {
                    pmmCall('AddProjectManager', { projectManagerCode:code, restore:true }).done(function () { pmmMessage('Project manager restored successfully.', 'success'); loadProjectManagers(); }).fail(pmmError);
                } else if (response.d === 0) pmmMessage('Project manager already exists.', 'error');
                else if (response.d > 0) { pmmMessage('Project manager added successfully.', 'success'); loadProjectManagers(); }
            }).fail(pmmError);
        }
        function deleteProjectManager(id, name) {
            if (!window.confirm('Delete project manager ' + name + '?')) return;
            pmmCall('DeleteProjectManager', { projectManagerId:id }).done(function () { pmmMessage('Project manager deleted successfully.', 'success'); loadProjectManagers(); }).fail(pmmError);
        }
    </script>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="pmm">
        <div class="pmm-hero"><h2>Project Manager Master</h2><div>Add or remove employees from the project-manager list.</div></div>
        <div id="pmmMessage" class="pmm-message" role="status"></div>
        <div class="pmm-card"><div class="pmm-title">Add Project Manager</div><div class="pmm-body"><div class="pmm-form">
            <div class="pmm-field"><label for="pmmEmployee">Employee</label><select id="pmmEmployee" class="form-control"></select></div>
            <button id="pmmAdd" class="pmm-button" type="button">Add Project Manager</button>
        </div></div></div>
        <div class="pmm-card"><div class="pmm-title">Existing Project Managers</div><div class="pmm-table-wrap"><table>
            <thead><tr><th>Sr. #</th><th>Project Manager</th><th>Added By</th><th>Added Date</th><th>Action</th></tr></thead><tbody id="pmmRows"></tbody>
        </table></div></div>
    </div>
</asp:Content>
