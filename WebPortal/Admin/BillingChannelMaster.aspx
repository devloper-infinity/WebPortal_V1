<%@ Page Title="Billing Channel Master" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="BillingChannelMaster.aspx.cs" Inherits="WebPortal.Admin.BillingChannelMaster" %>

<asp:Content ID="BillingChannelHead" ContentPlaceHolderID="head" runat="server">
    <link href="../Content/DataTables/css/jquery.dataTables.min.css" rel="stylesheet" />
    <link href="../plugins/sweetalert2/sweetalert2.min.css" rel="stylesheet" />
    <style>
        .bcm-page,.bcm-page input,.bcm-page select,.bcm-page button,.bcm-loading{font-family:Bahnschrift,"Segoe UI",Arial,sans-serif}.bcm-page{padding:10px 14px 26px;color:#27364b;font-size:12px}.bcm-header{display:flex;align-items:center;justify-content:space-between;gap:14px;margin-bottom:15px;padding:17px 20px;border:1px solid #dce4ed;border-left:4px solid #5476a5;border-radius:8px;background:#fff;box-shadow:0 4px 16px rgba(32,52,78,.07)}.bcm-heading{display:flex;align-items:center;gap:14px}.bcm-header-icon{display:flex;align-items:center;justify-content:center;width:45px;height:45px;border-radius:10px;color:#fff;background:linear-gradient(135deg,#405f8b,#6d8db8);font-size:19px}.bcm-header h2{margin:0;font-size:21px;font-weight:600}.bcm-header p{margin:3px 0 0;color:#77859a}.bcm-card{border:1px solid #dfe5ec;border-radius:8px;background:#fff;box-shadow:0 3px 13px rgba(32,52,78,.06);overflow:hidden}.bcm-card-head{padding:12px 16px;border-bottom:1px solid #e5eaf0;background:#f8fafc;color:#354a67;font-weight:600}.bcm-table-wrap{width:100%;padding:14px;overflow-x:auto}.bcm-table{width:100%!important}.bcm-table thead th{white-space:nowrap;background:#eaf0f7;color:#334a69;font-size:11px}.bcm-table tbody td{vertical-align:middle;font-size:11px}.bcm-btn{padding:8px 14px;border-radius:6px;font-weight:600}.bcm-btn-primary{color:#fff;background:#5778a7;border:1px solid #5778a7}.bcm-btn-primary:hover{color:#fff;background:#466690}.bcm-btn-light{color:#526278;background:#fff;border:1px solid #cbd5df}.bcm-edit{padding:4px 10px;border:1px solid #b9cbe0;border-radius:5px;color:#3f628f;background:#edf4fb}.bcm-required{color:#c63d34}.bcm-control{width:100%;height:40px;padding:8px 11px;border:1px solid #cad5e1;border-radius:6px;background:#fff;color:#24364d;outline:none}.bcm-control:focus{border-color:#6685af;box-shadow:0 0 0 3px rgba(90,120,168,.12)}.bcm-control[readonly]{background:#eef2f6;color:#65748a}.bcm-field{margin-bottom:15px}.bcm-field label{display:block;margin-bottom:6px;color:#516177;font-weight:600}.bcm-message{display:none;margin-bottom:12px;padding:10px 13px;border-radius:6px;color:#19653f;background:#eaf7f0}.bcm-message.error{color:#a42f29;background:#fff0ef}.bcm-loading{display:none;position:fixed;inset:0;z-index:10050;align-items:center;justify-content:center;background:rgba(244,247,251,.72)}.bcm-loading.show{display:flex}.bcm-loading-box{display:flex;align-items:center;gap:10px;padding:14px 18px;border:1px solid #dae2eb;border-radius:7px;background:#fff;box-shadow:0 5px 18px rgba(0,0,0,.13)}.bcm-spinner{width:20px;height:20px;border:3px solid #d7dfe8;border-top-color:#5778a7;border-radius:50%;animation:bcm-spin .8s linear infinite}@keyframes bcm-spin{to{transform:rotate(360deg)}}.bcm-modal .modal-header{background:#f8fafc;border-bottom-color:#e5eaf0}.bcm-modal .modal-title{color:#354a67;font-size:17px;font-weight:600}.bcm-modal .modal-footer{border-top-color:#edf0f4}@media(max-width:650px){.bcm-page{padding:8px}.bcm-header{align-items:stretch;flex-direction:column}.bcm-header .bcm-btn{width:100%}.bcm-table-wrap{padding:8px}}
    </style>
</asp:Content>

<asp:Content ID="BillingChannelContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="bcm-page">
        <div class="bcm-header">
            <div class="bcm-heading"><span class="bcm-header-icon"><i class="fas fa-stream"></i></span><div><h2>Billing Channel Master</h2><p>Maintain billing channels and their clean-loan values.</p></div></div>
            <button type="button" id="bcmAddNew" class="btn bcm-btn bcm-btn-primary"><i class="fas fa-plus mr-1"></i>Add New Channel</button>
        </div>
        <div id="bcmMessage" class="bcm-message" role="status"></div>
        <section class="bcm-card">
            <div class="bcm-card-head"><i class="fas fa-list mr-1"></i>Existing Channels</div>
            <div class="bcm-table-wrap">
                <table id="bcmTable" class="display nowrap table table-bordered table-sm bcm-table">
                    <thead><tr><th>Sr. No.</th><th>Channel</th><th>Clean Loan</th><th>Added By (Employee Code)</th><th>Added Date</th><th>Action</th></tr></thead><tbody></tbody>
                </table>
            </div>
        </section>
    </div>

    <div class="modal fade bcm-modal" id="bcmEditorModal" tabindex="-1" role="dialog" aria-labelledby="bcmEditorTitle" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document"><div class="modal-content">
            <div class="modal-header"><h5 class="modal-title" id="bcmEditorTitle">Add New Channel</h5><button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button></div>
            <div class="modal-body">
                <input type="hidden" id="bcmChannelId" value="0" />
                <div class="bcm-field"><label for="bcmChannel">Channel <span class="bcm-required">*</span></label><input type="text" id="bcmChannel" class="bcm-control" maxlength="100" autocomplete="off" /></div>
                <div class="bcm-field"><label for="bcmCleanLoan">Clean Loan <span class="bcm-required">*</span></label><select id="bcmCleanLoan" class="bcm-control"><option value="">Select</option><option value="Yes">Yes</option><option value="No">No</option></select></div>
            </div>
            <div class="modal-footer"><button type="button" id="bcmCancel" class="btn bcm-btn bcm-btn-light" data-dismiss="modal">Cancel</button><button type="button" id="bcmSave" class="btn bcm-btn bcm-btn-primary"><i class="fas fa-save mr-1"></i><span>Save</span></button></div>
        </div></div>
    </div>
    <div id="bcmLoading" class="bcm-loading"><div class="bcm-loading-box"><span class="bcm-spinner"></span><span>Processing...</span></div></div>
    <script src="../plugins/sweetalert2/sweetalert2.all.min.js"></script>
    <script>
        (function ($) {
            'use strict';
            var bcmDataTable = null, bcmRows = [];
            $(function () {
                $('#bcmAddNew').on('click', bcmOpenAdd);
                $('#bcmSave').on('click', bcmSaveChannel);
                $('#bcmTable').on('click', '.bcm-edit', bcmOpenEdit);
                $('#bcmEditorModal').on('shown.bs.modal', function () { ($('#bcmChannel').prop('readonly') ? $('#bcmCleanLoan') : $('#bcmChannel')).trigger('focus'); });
                bcmLoadChannels();
            });
            function bcmCall(method, payload) { return $.ajax({ type: 'POST', url: 'BillingChannelMaster.aspx/' + method, data: JSON.stringify(payload || {}), contentType: 'application/json; charset=utf-8', dataType: 'json' }); }
            function bcmLoadChannels() {
                bcmSetLoading(true);
                bcmCall('GetChannels').done(function (response) {
                    var result = response.d;
                    if (!result || !result.Success) { bcmNotify(result && result.Message || 'Unable to load channels.', true); return; }
                    bcmBindTable(result.Rows || []);
                }).fail(function () { bcmNotify('Unable to load channels.', true); }).always(function () { bcmSetLoading(false); });
            }
            function bcmBindTable(rows) {
                bcmRows = rows;
                if (bcmDataTable) bcmDataTable.destroy();
                bcmDataTable = $('#bcmTable').DataTable({ data: bcmRows, autoWidth: false, scrollX: true, scrollCollapse: true, pageLength: 25, order: [[1, 'asc']], columns: [
                    { data: null, orderable: false, searchable: false, render: function (_, type, row, meta) { return type === 'display' ? meta.row + meta.settings._iDisplayStart + 1 : meta.row; } },
                    { data: 'Channel', render: $.fn.dataTable.render.text() },
                    { data: 'CleanLoan', render: $.fn.dataTable.render.text() },
                    { data: 'AddedBy', render: $.fn.dataTable.render.text() },
                    { data: 'AddedDate', render: $.fn.dataTable.render.text() },
                    { data: null, orderable: false, searchable: false, render: function (_, __, row) { return '<button type="button" class="bcm-edit" data-id="' + row.ChannelID + '"><i class="fas fa-edit mr-1"></i>Edit</button>'; } }
                ] });
                bcmDataTable.columns.adjust();
            }
            function bcmOpenAdd() { bcmResetEditor(); $('#bcmEditorModal').modal('show'); }
            function bcmOpenEdit() {
                var channelId = parseInt($(this).data('id'), 10), row = $.grep(bcmRows, function (item) { return item.ChannelID === channelId; })[0];
                if (!row) return;
                $('#bcmChannelId').val(row.ChannelID); $('#bcmChannel').val(row.Channel).prop('readonly', true); $('#bcmCleanLoan').val(row.CleanLoan);
                $('#bcmEditorTitle').text('Edit Channel'); $('#bcmSave span').text('Update'); $('#bcmEditorModal').modal('show');
            }
            function bcmResetEditor() { $('#bcmChannelId').val('0'); $('#bcmChannel,#bcmCleanLoan').val(''); $('#bcmChannel').prop('readonly', false); $('#bcmEditorTitle').text('Add New Channel'); $('#bcmSave span').text('Save'); }
            function bcmSaveChannel() {
                var channelId = parseInt($('#bcmChannelId').val(), 10) || 0, channel = $.trim($('#bcmChannel').val()), cleanLoan = $.trim($('#bcmCleanLoan').val());
                if (!channel) { bcmNotify('Channel is required.', true); $('#bcmChannel').trigger('focus'); return; }
                if (!cleanLoan) { bcmNotify('Please select Clean Loan.', true); $('#bcmCleanLoan').trigger('focus'); return; }
                bcmSetLoading(true);
                bcmCall('SaveChannel', { request: { ChannelID: channelId, Channel: channel, CleanLoan: cleanLoan } }).done(function (response) {
                    var result = response.d;
                    if (!result || !result.Success) { bcmNotify(result && result.Message || 'Unable to save channel.', true); return; }
                    $('#bcmEditorModal').modal('hide'); bcmResetEditor(); bcmNotify(result.Message, false); bcmLoadChannels();
                }).fail(function () { bcmNotify('Unable to save channel.', true); }).always(function () { bcmSetLoading(false); });
            }
            function bcmNotify(message, isError) { $('#bcmMessage').toggleClass('error', !!isError).text(message).show(); if (window.Swal) Swal.fire({ icon: isError ? 'error' : 'success', title: isError ? 'Error' : 'Success', text: message, confirmButtonColor: '#5778a7' }); }
            function bcmSetLoading(show) { $('#bcmLoading').toggleClass('show', show); $('#bcmSave,#bcmAddNew,#bcmCancel').prop('disabled', show); }
        }(jQuery));
    </script>
</asp:Content>
