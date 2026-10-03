<%@ Page Title="Client Billing Email Configuration" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ClientBillingEmailMaster.aspx.cs" Inherits="WebPortal.Admin.ClientBillingEmailMaster" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <link href="../Content/DataTables/css/jquery.dataTables.min.css" rel="stylesheet" />
    <link href="../plugins/sweetalert2/sweetalert2.min.css" rel="stylesheet" />
    <style>
        .cbem-page,.cbem-page input,.cbem-page select,.cbem-page button,.cbem-loading{font-family:Bahnschrift,"Segoe UI",Arial,sans-serif}.cbem-page{padding:10px 14px 26px;color:#27364b;font-size:12px}.cbem-header{display:flex;align-items:center;gap:14px;margin-bottom:15px;padding:17px 20px;border:1px solid #dce4ed;border-left:4px solid #5476a5;border-radius:8px;background:#fff;box-shadow:0 4px 16px rgba(32,52,78,.07)}.cbem-header-icon{display:flex;align-items:center;justify-content:center;width:45px;height:45px;border-radius:10px;color:#fff;background:linear-gradient(135deg,#405f8b,#6d8db8);font-size:19px}.cbem-header h2{margin:0;font-size:21px;font-weight:600}.cbem-header p{margin:3px 0 0;color:#77859a}.cbem-card{margin-bottom:15px;border:1px solid #dfe5ec;border-radius:8px;background:#fff;box-shadow:0 3px 13px rgba(32,52,78,.06);overflow:hidden}.cbem-card-head{padding:12px 16px;border-bottom:1px solid #e5eaf0;background:#f8fafc;color:#354a67;font-weight:600}.cbem-card-body{padding:17px}.cbem-grid{display:grid;grid-template-columns:minmax(220px,.9fr) repeat(3,minmax(230px,1fr));gap:14px}.cbem-field label{display:block;margin-bottom:6px;color:#516177;font-weight:600}.cbem-required{color:#c63d34}.cbem-control{width:100%;height:40px;padding:8px 11px;border:1px solid #cad5e1;border-radius:6px;background:#fff;color:#24364d;outline:none}.cbem-control:focus{border-color:#6685af;box-shadow:0 0 0 3px rgba(90,120,168,.12)}.cbem-help{display:block;margin-top:4px;color:#8792a1;font-size:10px}.cbem-actions{display:flex;justify-content:flex-end;gap:9px;margin-top:16px;padding-top:14px;border-top:1px solid #edf0f4}.cbem-btn{min-width:115px;padding:8px 14px;border-radius:6px;font-weight:600}.cbem-btn-primary{color:#fff;background:#5778a7;border:1px solid #5778a7}.cbem-btn-primary:hover{color:#fff;background:#466690}.cbem-btn-light{color:#526278;background:#fff;border:1px solid #cbd5df}.cbem-table-wrap{width:100%;padding:14px;overflow-x:auto}.cbem-table{width:100%!important}.cbem-table thead th{white-space:nowrap;background:#eaf0f7;color:#334a69;font-size:11px}.cbem-table tbody td{vertical-align:middle;font-size:11px}.cbem-email-cell{min-width:190px;white-space:normal;word-break:break-word}.cbem-edit{padding:4px 10px;border:1px solid #b9cbe0;border-radius:5px;color:#3f628f;background:#edf4fb}.cbem-message{display:none;margin-bottom:12px;padding:10px 13px;border-radius:6px;color:#19653f;background:#eaf7f0}.cbem-message.error{color:#a42f29;background:#fff0ef}.cbem-loading{display:none;position:fixed;inset:0;z-index:10050;align-items:center;justify-content:center;background:rgba(244,247,251,.72)}.cbem-loading.show{display:flex}.cbem-loading-box{display:flex;align-items:center;gap:10px;padding:14px 18px;border:1px solid #dae2eb;border-radius:7px;background:#fff;box-shadow:0 5px 18px rgba(0,0,0,.13)}.cbem-spinner{width:20px;height:20px;border:3px solid #d7dfe8;border-top-color:#5778a7;border-radius:50%;animation:cbem-spin .8s linear infinite}@keyframes cbem-spin{to{transform:rotate(360deg)}}@media(max-width:1100px){.cbem-grid{grid-template-columns:repeat(2,minmax(220px,1fr))}}@media(max-width:650px){.cbem-grid{grid-template-columns:1fr}.cbem-actions{flex-direction:column}.cbem-btn{width:100%}}
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="cbem-page">
        <div class="cbem-header"><span class="cbem-header-icon"><i class="fas fa-envelope-open-text"></i></span><div><h2>Client Billing Email Configuration</h2><p>Maintain project-wise billing email recipients.</p></div></div>
        <div id="cbemMessage" class="cbem-message"></div>
        <section class="cbem-card">
            <div class="cbem-card-head"><i class="fas fa-sliders-h mr-1"></i> Email Settings</div>
            <div class="cbem-card-body">
                <input type="hidden" id="cbemMasterId" value="0" />
                <div class="cbem-grid">
                    <div class="cbem-field"><label for="cbemProject">Project <span class="cbem-required">*</span></label><select id="cbemProject" class="cbem-control"><option value="">Select Project</option></select></div>
                    <div class="cbem-field"><label for="cbemTo">To Email ID(s) <span class="cbem-required">*</span></label><input id="cbemTo" class="cbem-control" type="text" maxlength="4000" placeholder="user@domain.com; user2@domain.com" /><small class="cbem-help">Separate multiple addresses using semicolons (;).</small></div>
                    <div class="cbem-field"><label for="cbemCc">CC Email ID(s)</label><input id="cbemCc" class="cbem-control" type="text" maxlength="4000" placeholder="Optional" /><small class="cbem-help">Separate multiple addresses using semicolons (;).</small></div>
                    <div class="cbem-field"><label for="cbemBcc">BCC Email ID(s)</label><input id="cbemBcc" class="cbem-control" type="text" maxlength="4000" placeholder="Optional" /><small class="cbem-help">Separate multiple addresses using semicolons (;).</small></div>
                </div>
                <div class="cbem-actions"><button type="button" id="cbemClear" class="btn cbem-btn cbem-btn-light"><i class="fas fa-eraser mr-1"></i>Clear</button><button type="button" id="cbemSave" class="btn cbem-btn cbem-btn-primary"><i class="fas fa-save mr-1"></i><span>Save</span></button></div>
            </div>
        </section>
        <section class="cbem-card">
            <div class="cbem-card-head"><i class="fas fa-list mr-1"></i> Existing Configurations</div>
            <div class="cbem-table-wrap"><table id="cbemTable" class="display nowrap table table-bordered table-sm cbem-table"><thead><tr><th>Project</th><th>To</th><th>CC</th><th>BCC</th><th>Updated By</th><th>Updated Date</th><th>Action</th></tr></thead><tbody></tbody></table></div>
        </section>
    </div>
    <div id="cbemLoading" class="cbem-loading"><div class="cbem-loading-box"><span class="cbem-spinner"></span><span>Processing...</span></div></div>
    <script src="../plugins/sweetalert2/sweetalert2.all.min.js"></script>
    <script>
        (function ($) {
            'use strict';
            var table = null, rows = [];
            $(function () { $('#cbemSave').on('click', save); $('#cbemClear').on('click', clearForm); $('#cbemTable').on('click', '.cbem-edit', edit); load(); });
            function load() {
                loading(true);
                $.ajax({ type: 'POST', url: 'ClientBillingEmailMaster.aspx/LoadData', data: '{}', contentType: 'application/json; charset=utf-8', dataType: 'json' })
                    .done(function (r) { var x = r.d; if (!x || !x.Success) { notify(x && x.Message || 'Unable to load configurations.', true); return; } bindProjects(x.Projects || []); bindTable(x.Rows || []); })
                    .fail(function () { notify('Unable to load configurations.', true); }).always(function () { loading(false); });
            }
            function bindProjects(projects) { var selected = $('#cbemProject').val(), $p = $('#cbemProject').empty().append($('<option/>', { value: '', text: 'Select Project' })); $.each(projects, function (_, p) { $p.append($('<option/>', { value: p.ProjectID, text: p.ProjectName })); }); if (selected) $p.val(selected); }
            function bindTable(data) {
                rows = data;
                if (table) table.destroy();
                table = $('#cbemTable').DataTable({ data: rows, autoWidth: false, scrollX: true, scrollCollapse: true, pageLength: 25, order: [[0, 'asc']], columns: [
                    { data: 'ProjectName', render: $.fn.dataTable.render.text() },
                    { data: 'TOID', className: 'cbem-email-cell', render: $.fn.dataTable.render.text() },
                    { data: 'CCID', className: 'cbem-email-cell', render: emptyText },
                    { data: 'BCCID', className: 'cbem-email-cell', render: emptyText },
                    { data: 'UpdatedBy', render: $.fn.dataTable.render.text() },
                    { data: 'UpdatedDate', render: $.fn.dataTable.render.text() },
                    { data: null, orderable: false, searchable: false, render: function (_, __, row) { return '<button type="button" class="cbem-edit" data-id="' + row.MasterID + '"><i class="fas fa-edit mr-1"></i>Edit</button>'; } }
                ] });
            }
            function emptyText(value, type) { if (type !== 'display') return value || ''; return value ? $('<div/>').text(value).html() : '—'; }
            function edit() { var id = parseInt($(this).data('id'), 10), row = $.grep(rows, function (x) { return x.MasterID === id; })[0]; if (!row) return; $('#cbemMasterId').val(row.MasterID); $('#cbemProject').val(row.ProjectID); $('#cbemTo').val(row.TOID); $('#cbemCc').val(row.CCID); $('#cbemBcc').val(row.BCCID); $('#cbemSave span').text('Update'); $('html,body').animate({ scrollTop: $('.cbem-card').first().offset().top - 15 }, 160); }
            function clearForm() { $('#cbemMasterId').val('0'); $('#cbemProject,#cbemTo,#cbemCc,#cbemBcc').val(''); $('#cbemSave span').text('Save'); $('#cbemMessage').hide(); }
            function validList(value, required, label) { var v = $.trim(value || ''); if (!v) return required ? label + ' is mandatory.' : ''; if (v.indexOf(',') >= 0) return label + ' must use semicolons (;) between addresses.'; var email = /^[^\s@;]+@[^\s@;]+\.[^\s@;]+$/; var parts = v.split(';'); for (var i = 0; i < parts.length; i++) { var x = $.trim(parts[i]); if (x && !email.test(x)) return 'Invalid ' + label + ': ' + x; } return ''; }
            function save() {
                var rawProject = $('#cbemProject').val(), projectId = parseInt(rawProject, 10), error = rawProject === '' || isNaN(projectId) ? 'Please select a project.' : '';
                if (!error) error = validList($('#cbemTo').val(), true, 'To Email ID');
                if (!error) error = validList($('#cbemCc').val(), false, 'CC Email ID');
                if (!error) error = validList($('#cbemBcc').val(), false, 'BCC Email ID');
                if (error) { notify(error, true); return; }
                var request = { MasterID: parseInt($('#cbemMasterId').val(), 10) || 0, ProjectID: projectId, TOID: $('#cbemTo').val(), CCID: $('#cbemCc').val(), BCCID: $('#cbemBcc').val() };
                loading(true);
                $.ajax({ type: 'POST', url: 'ClientBillingEmailMaster.aspx/Save', data: JSON.stringify({ request: request }), contentType: 'application/json; charset=utf-8', dataType: 'json' })
                    .done(function (r) { var x = r.d; if (!x || !x.Success) { notify(x && x.Message || 'Unable to save configuration.', true); return; } clearForm(); notify(x.Message, false); load(); })
                    .fail(function () { notify('Unable to save configuration.', true); }).always(function () { loading(false); });
            }
            function notify(message, error) { $('#cbemMessage').toggleClass('error', !!error).text(message).show(); if (window.Swal) Swal.fire({ icon: error ? 'error' : 'success', title: error ? 'Validation' : 'Success', text: message, confirmButtonColor: '#5778a7' }); }
            function loading(show) { $('#cbemLoading').toggleClass('show', show); $('#cbemSave,#cbemClear').prop('disabled', show); }
        }(jQuery));
    </script>
</asp:Content>
