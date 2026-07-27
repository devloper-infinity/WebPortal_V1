<%@ Page Title="" Language="C#" MasterPageFile="~/Vendor/VendorMaster.Master" AutoEventWireup="true" CodeBehind="ProcessOrder.aspx.cs" Inherits="WebPortal.Vendor.ProcessOrder" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
    .erp-page { padding: 15px; }
    .erp-hero { background: #fff; border: 1px solid #d9e2ec; border-left: 4px solid #3f6f9f; border-radius: 6px; padding: 14px 18px; margin-bottom: 14px; }
    .erp-hero h2 { margin: 0; font-size: 21px; font-weight: 600; color: #243b53; }
    .erp-hero .crumb { margin-top: 4px; color: #829ab1; font-size: 12px; }
    .erp-panel { background: #fff; border: 1px solid #d9e2ec; border-radius: 6px; margin-bottom: 14px; overflow: hidden; }
    .erp-panel-title { padding: 10px 14px; font-weight: 600; color: #334e68; background: #f7f9fc; border-bottom: 1px solid #d9e2ec; }
    .erp-panel-body { padding: 14px; }
    .erp-row { display: flex; flex-wrap: wrap; margin: 0 -7px; }
    .erp-col-3, .erp-col-4, .erp-col-6, .erp-col-12 { padding: 0 7px; box-sizing: border-box; margin-bottom: 12px; }
    .erp-col-3 { width: 25%; } .erp-col-4 { width: 33.333%; } .erp-col-6 { width: 50%; } .erp-col-12 { width: 100%; }
    .erp-label { display: block; font-size: 12px; font-weight: 600; color: #486581; margin-bottom: 5px; }
    .erp-control { width: 100%; height: 34px; border: 1px solid #bcccdc; border-radius: 4px; padding: 6px 9px; box-sizing: border-box; background: #fff; color: #243b53; }
    textarea.erp-control { height: 70px; resize: vertical; }
    .erp-control[readonly] { background: #f5f7fa; }
    .erp-options { display: flex; flex-wrap: wrap; gap: 16px; align-items: center; min-height: 34px; }
    .erp-options label { margin: 0; font-weight: 500; color: #334e68; cursor: pointer; }
    .erp-options input { margin-right: 5px; }
    .erp-actions { display: flex; gap: 8px; justify-content: flex-end; padding-top: 6px; }
    .erp-btn { border: 0; border-radius: 4px; padding: 8px 14px; font-size: 13px; cursor: pointer; }
    .erp-btn-primary { background: #3f6f9f; color: #fff; }
    .erp-btn-light { background: #e9eff5; color: #334e68; }
    .erp-btn-link { background: transparent; color: #286090; padding: 2px 5px; }
    .erp-message { display: none; margin-bottom: 14px; padding: 10px 13px; border-radius: 4px; font-size: 13px; }
    .erp-message.success { display: block; background: #eaf7ef; border: 1px solid #a7d7b8; color: #25633b; }
    .erp-message.error { display: block; background: #fff1f0; border: 1px solid #efb3ae; color: #9f2d24; }
    .erp-grid-wrap { position: relative; overflow: auto; }
    table.dataTable thead th { white-space: nowrap; background: #edf2f7; color: #334e68; }
    table.dataTable tbody td { white-space: nowrap; vertical-align: middle; }
    .row-transfer { background: #fff7cc !important; opacity: .75; }
    .erp-loader { display: none; position: absolute; inset: 0; background: rgba(255,255,255,.75); z-index: 20; align-items: center; justify-content: center; font-weight: 600; color: #486581; }
    .erp-loader.show { display: flex; }
    .required { color: #c0392b; }
    .file-note { color: #829ab1; font-size: 11px; margin-top: 4px; }
    @media (max-width: 900px) { .erp-col-3, .erp-col-4, .erp-col-6 { width: 100%; } }
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="erp-page">
    <div class="erp-hero">
        <h2>Process Order</h2>
        <div class="crumb">Vendor / Process Order</div>
    </div>

    <div id="messageBox" class="erp-message"></div>

    <div class="erp-panel">
        <div class="erp-panel-title">Order Selection</div>
        <div class="erp-panel-body">
            <div class="erp-row">
                <div class="erp-col-6">
                    <label class="erp-label" for="ddlOrder">Assigned Order <span class="required">*</span></label>
                    <select id="ddlOrder" class="erp-control"><option value="0">Select</option></select>
                </div>
                <div class="erp-col-3">
                    <label class="erp-label" for="txtProcess">Current Process</label>
                    <input id="txtProcess" class="erp-control" type="text" readonly />
                    <input id="hdnProcessId" type="hidden" />
                </div>
                <div class="erp-col-3">
                    <label class="erp-label">Order Details</label>
                    <button id="btnRefresh" type="button" class="erp-btn erp-btn-light">Refresh</button>
                </div>
            </div>
        </div>
    </div>

    <div class="erp-panel">
        <div class="erp-panel-title">Process Tasks</div>
        <div class="erp-panel-body erp-grid-wrap">
            <div id="taskLoader" class="erp-loader">Loading...</div>
            <table id="taskTable" class="display nowrap" style="width:100%">
                <thead><tr></tr></thead><tbody></tbody>
            </table>
        </div>
    </div>

    <div class="erp-panel">
        <div class="erp-panel-title">Completion Details</div>
        <div class="erp-panel-body">
            <div class="erp-row">
                <div class="erp-col-12">
                    <label class="erp-label">Action</label>
                    <div class="erp-options">
                        <label><input type="radio" name="orderAction" value="complete" checked /> Complete</label>
                        <label><input type="radio" name="orderAction" value="dispatch" /> Dispatch</label>
                        <label><input type="radio" name="orderAction" value="cancel" /> Cancel</label>
                        <label><input type="radio" name="orderAction" value="hold" /> Hold</label>
                        <label><input type="radio" name="orderAction" value="partial" /> Partial</label>
                        <label><input id="chkNoError" type="checkbox" /> No Error</label>
                    </div>
                </div>
                <div class="erp-col-6">
                    <label class="erp-label" for="txtRemark">Remark</label>
                    <textarea id="txtRemark" class="erp-control" maxlength="4000"></textarea>
                </div>
                <div class="erp-col-6">
                    <label class="erp-label" for="fileAttach">Attachment <span class="required">*</span></label>
                    <input id="fileAttach" class="erp-control" type="file" />
                    <div class="file-note">The attachment name, excluding extension, must match the Client Order No.</div>
                </div>
                <div class="erp-col-12 erp-actions">
                    <button id="btnClear" type="button" class="erp-btn erp-btn-light">Clear</button>
                    <button id="btnSubmit" type="button" class="erp-btn erp-btn-primary">Submit</button>
                </div>
            </div>
        </div>
    </div>

    <div class="erp-panel">
        <div class="erp-panel-title">Order Process History</div>
        <div class="erp-panel-body erp-grid-wrap">
            <div id="historyLoader" class="erp-loader">Loading...</div>
            <table id="historyTable" class="display nowrap" style="width:100%">
                <thead><tr></tr></thead><tbody></tbody>
            </table>
        </div>
    </div>
</div>

<script>
    (function () {
        'use strict';
        var taskTable = null, historyTable = null, currentTasks = [];

        $(function () {
            bindEvents();
            loadInitialData();
        });

        function bindEvents() {
            $('#ddlOrder').on('change', function () {
                var orderId = parseInt($(this).val() || '0', 10);
                if (orderId > 0) loadOrder(orderId); else resetOrder();
            });
            $('#btnRefresh').on('click', function () {
                var orderId = parseInt($('#ddlOrder').val() || '0', 10);
                if (orderId > 0) loadOrder(orderId); else loadInitialData();
            });
            $('#btnClear').on('click', clearCompletion);
            $('#btnSubmit').on('click', submitOrder);
            $('#taskTable').on('change', '.row-select', syncSelectAll);
            $('#taskTable').on('change', '#selectAllTasks', function () {
                $('.row-select:not(:disabled)').prop('checked', this.checked);
            });
            $('#historyTable').on('click', '.download-attachment', function () {
                downloadAttachment($(this).attr('data-path'));
            });
        }

        function ajax(method, payload, done, fail) {
            $.ajax({
                type: 'POST',
                url: 'ProcessOrder.aspx/' + method,
                data: JSON.stringify(payload || {}),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (r) { done(r.d); },
                error: function (xhr) {
                    var msg = 'Unexpected server error.';
                    try { msg = JSON.parse(xhr.responseText).Message || msg; } catch (e) { }
                    (fail || showError)(msg);
                }
            });
        }

        function loadInitialData() {
            showLoader('#taskLoader', true);
            ajax('GetInitialData', {}, function (result) {
                showLoader('#taskLoader', false);
                if (!result.Success) return showError(result.Message);
                var ddl = $('#ddlOrder').empty().append('<option value="0">Select</option>');
                $.each(result.Orders || [], function (_, x) {
                    ddl.append($('<option/>').val(x.Value).text(x.Text));
                });
            }, function (m) { showLoader('#taskLoader', false); showError(m); });
        }

        function loadOrder(orderId) {
            hideMessage();
            showLoader('#taskLoader', true);
            showLoader('#historyLoader', true);
            ajax('GetOrderData', { orderId: orderId }, function (result) {
                showLoader('#taskLoader', false); showLoader('#historyLoader', false);
                if (!result.Success) return showError(result.Message);
                $('#txtProcess').val(result.ProcessName || '');
                $('#hdnProcessId').val(result.ProcessId || 0);
                $('#txtRemark').val(result.Remark || '');
                currentTasks = result.Tasks || [];
                bindDynamicTable('#taskTable', currentTasks, true);
                bindDynamicTable('#historyTable', result.History || [], false);
                if ((result.ProcessName || '').toLowerCase() === 'dispatch') {
                    $('input[name="orderAction"][value="dispatch"]').prop('checked', true);
                    $('.row-select:not(:disabled)').prop('checked', true);
                    $('#selectAllTasks').prop('checked', true);
                }
            }, function (m) {
                showLoader('#taskLoader', false); showLoader('#historyLoader', false); showError(m);
            });
        }

        function bindDynamicTable(selector, rows, selectable) {
            var table = selector === '#taskTable' ? taskTable : historyTable;
            if (table) { table.destroy(); $(selector + ' thead tr').empty(); $(selector + ' tbody').empty(); }
            var columns = [];
            $.each(rows, function (_, row) {
                $.each(row, function (key) { if ($.inArray(key, columns) < 0) columns.push(key); });
            });
            var head = $(selector + ' thead tr');
            if (selectable) head.append('<th><input id="selectAllTasks" type="checkbox" /></th>');
            head.append('<th>Sr. #</th>');
            $.each(columns, function (_, col) { head.append($('<th/>').text(formatHeader(col))); });
            var body = $(selector + ' tbody');
            $.each(rows, function (i, row) {
                var disabled = selectable && String(row.TransferAssignedId || row.TransferAssignedID || '') !== '' && String(row.TransferAssignedId || row.TransferAssignedID) !== '0';
                var tr = $('<tr/>').toggleClass('row-transfer', disabled);
                if (selectable) tr.append('<td><input type="checkbox" class="row-select" data-index="' + i + '" ' + (disabled ? 'disabled' : '') + ' /></td>');
                tr.append($('<td/>').text(i + 1));
                $.each(columns, function (_, col) {
                    var value = row[col] == null ? '' : row[col];
                    if (!selectable && /attachment/i.test(col) && value) {
                        tr.append($('<td/>').append($('<button type="button" class="erp-btn erp-btn-link download-attachment">Download</button>').attr('data-path', value)));
                    } else {
                        tr.append($('<td/>').text(value));
                    }
                });
                body.append(tr);
            });
            var options = { scrollX: true, scrollY: '45vh', scrollCollapse: true, paging: false, searching: true, ordering: false, info: true, autoWidth: false };
            table = $(selector).DataTable(options);
            if (selector === '#taskTable') taskTable = table; else historyTable = table;
        }

        function submitOrder() {
            hideMessage();
            var orderId = parseInt($('#ddlOrder').val() || '0', 10);
            var processId = parseInt($('#hdnProcessId').val() || '0', 10);
            var action = $('input[name="orderAction"]:checked').val();
            var remark = $.trim($('#txtRemark').val());
            var selected = [];
            $('.row-select:checked').each(function () { selected.push(currentTasks[parseInt($(this).attr('data-index'), 10)]); });
            var file = $('#fileAttach')[0].files[0];

            if (!orderId) return showError('Please select an order.');
            if (!selected.length) return showError('Please select at least one task.');
            if ((action === 'cancel' || action === 'hold' || action === 'partial') && !remark) return showError('Please enter a remark.');
            if (!file) return showError('Please choose an attachment.');
            if ((action === 'dispatch' || action === 'cancel' || action === 'hold') && !window.confirm('Do you want to ' + action + ' this order?')) return;

            readFile(file, function (base64) {
                var input = {
                    OrderId: orderId,
                    ProcessId: processId,
                    ProcessName: $('#txtProcess').val(),
                    Action: action,
                    Remark: remark,
                    NoError: $('#chkNoError').is(':checked'),
                    FileName: file.name,
                    FileBase64: base64,
                    Tasks: $.map(selected, function (x) {
                        return {
                            TaskId: parseInt(x.Taskid || x.TaskId || 0, 10),
                            DocId: parseInt(x.Docid || x.DocId || 0, 10),
                            Project: x.Project || x.ProjectName || '',
                            ClientOrderNo: x.ClientOrderNo || x.OrderNo || ''
                        };
                    })
                };
                $('#btnSubmit').prop('disabled', true).text('Processing...');
                ajax('CompleteProcess', { input: input }, function (result) {
                    $('#btnSubmit').prop('disabled', false).text('Submit');
                    if (!result.Success) return showError(result.Message);
                    showSuccess(result.Message);
                    if (result.RedirectUrl) { window.location.href = result.RedirectUrl; return; }
                    clearCompletion();
                    loadInitialData();
                    resetOrder();
                }, function (m) { $('#btnSubmit').prop('disabled', false).text('Submit'); showError(m); });
            });
        }

        function readFile(file, done) {
            var reader = new FileReader();
            reader.onload = function (e) { done(String(e.target.result).split(',')[1]); };
            reader.onerror = function () { showError('Unable to read the selected file.'); };
            reader.readAsDataURL(file);
        }

        function downloadAttachment(path) {
            ajax('DownloadAttachment', { virtualPath: path }, function (result) {
                if (!result.Success) return showError(result.Message);
                var bytes = atob(result.FileBase64), arr = new Uint8Array(bytes.length);
                for (var i = 0; i < bytes.length; i++) arr[i] = bytes.charCodeAt(i);
                var blob = new Blob([arr], { type: result.ContentType || 'application/octet-stream' });
                var a = document.createElement('a');
                a.href = window.URL.createObjectURL(blob); a.download = result.FileName; document.body.appendChild(a); a.click(); document.body.removeChild(a);
            });
        }

        function clearCompletion() {
            $('#txtRemark').val(''); $('#fileAttach').val(''); $('#chkNoError').prop('checked', false);
            $('input[name="orderAction"][value="complete"]').prop('checked', true);
        }
        function resetOrder() {
            $('#txtProcess').val(''); $('#hdnProcessId').val('0'); currentTasks = [];
            bindDynamicTable('#taskTable', [], true); bindDynamicTable('#historyTable', [], false); clearCompletion();
        }
        function syncSelectAll() {
            var enabled = $('.row-select:not(:disabled)'), checked = enabled.filter(':checked');
            $('#selectAllTasks').prop('checked', enabled.length > 0 && enabled.length === checked.length);
        }
        function formatHeader(v) { return String(v).replace(/_/g, ' ').replace(/([a-z])([A-Z])/g, '$1 $2'); }
        function showLoader(id, show) { $(id).toggleClass('show', show); }
        function showSuccess(m) { $('#messageBox').removeClass('error').addClass('success').text(m); }
        function showError(m) { $('#messageBox').removeClass('success').addClass('error').text(m); }
        function hideMessage() { $('#messageBox').removeClass('success error').hide().text(''); }
    })();
</script>
</asp:Content>
