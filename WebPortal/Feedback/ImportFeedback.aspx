<%@ Page Title="" Language="C#" MasterPageFile="~/Feedback/Feedback.Master" AutoEventWireup="true" CodeBehind="ImportFeedback.aspx.cs" Inherits="WebPortal.Feedback.ImportFeedback" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .fb-page { color: #172737; font-size: 13px; padding: 18px 0 28px; }
        .fb-hero { align-items: center; background: linear-gradient(135deg, #0f766e 0%, #1d4ed8 100%); border-radius: 8px; color: #fff; display: flex; justify-content: space-between; margin-bottom: 16px; padding: 20px 22px; }
        .fb-title { font-size: 22px; font-weight: 800; margin: 0; }
        .fb-subtitle { color: rgba(255,255,255,.9); font-size: 12px; margin: 6px 0 0; }
        .fb-panel { background: #fff; border: 1px solid #dce5ec; border-radius: 8px; margin-bottom: 16px; overflow: hidden; }
        .fb-panel-header { align-items: center; border-bottom: 1px solid #e7edf2; display: flex; gap: 10px; justify-content: space-between; padding: 14px 16px; }
        .fb-panel-title { font-size: 15px; font-weight: 800; margin: 0; }
        .fb-panel-body { padding: 16px; }
        .fb-tabs { display: flex; gap: 8px; margin-bottom: 14px; }
        .fb-tab { background: #eef3f7; border: 1px solid #d6e1ea; border-radius: 6px; color: #17324d; cursor: pointer; font-weight: 800; padding: 8px 12px; }
        .fb-tab.active { background: #0f766e; border-color: #0f766e; color: #fff; }
        .fb-tab-panel { display: none; }
        .fb-tab-panel.active { display: block; }
        .fb-grid-form { display: grid; gap: 12px 14px; grid-template-columns: repeat(4, minmax(0, 1fr)); }
        .fb-field label { color: #46596b; display: block; font-size: 12px; font-weight: 700; margin-bottom: 5px; }
        .fb-field .form-control { border-color: #cfdbe5; border-radius: 6px; font-size: 13px; min-height: 36px; width: 100%; }
        .fb-btn { border: 1px solid transparent; border-radius: 6px; cursor: pointer; font-size: 13px; font-weight: 800; min-height: 36px; padding: 7px 13px; }
        .fb-btn-primary { background: #0f766e; border-color: #0f766e; color: #fff; }
        .fb-btn-light { background: #eef3f7; border-color: #d6e1ea; color: #17324d; }
        .fb-message { display: none; font-weight: 700; margin-bottom: 12px; padding: 10px 12px; }
        .fb-message.success { background: #e8f7ef; border: 1px solid #b7e2c8; color: #136c34; }
        .fb-message.error { background: #fff1f0; border: 1px solid #ffc9c4; color: #b42318; }
        .fb-summary { display: flex; flex-wrap: wrap; gap: 12px; margin-top: 14px; }
        .fb-pill { background: #f4f7fa; border: 1px solid #dce5ec; border-radius: 6px; font-weight: 800; padding: 8px 10px; }
        .fb-table-wrap { overflow-x: auto; padding: 0 16px 16px; }
        .table.dataTable thead th { background: #edf3f6 !important; color: #263747; font-size: 12px; text-align: center; white-space: nowrap; }
        .table.dataTable tbody td { font-size: 12px; vertical-align: middle; }
        @media (max-width: 980px) { .fb-grid-form { grid-template-columns: repeat(2, minmax(0, 1fr)); } }
        @media (max-width: 640px) { .fb-hero, .fb-panel-header { align-items: flex-start; flex-direction: column; } .fb-grid-form { grid-template-columns: 1fr; } }
    </style>
    <script type="text/javascript">
        var addedTable = null;
        var rejectedTable = null;

        $(document).ready(function () {
            $('.fb-tab').on('click', function () { showTab($(this).data('tab')); });
            $('#importSearchUpload').on('click', function () { uploadImport('Search'); });
            $('#importUWUpload').on('click', function () { uploadImport('UW'); });
            $('#importDownloadFormat').on('click', downloadFormat);
            loadImportProjects();
            showTab('searchImportPanel');
        });

        function showTab(tabId) {
            $('.fb-tab').removeClass('active');
            $('.fb-tab-panel').removeClass('active');
            $('.fb-tab[data-tab="' + tabId + '"]').addClass('active');
            $('#' + tabId).addClass('active');
        }

        function importPageMethod(method, data, done) {
            $.ajax({
                type: 'POST',
                url: 'ImportFeedback.aspx/' + method,
                data: JSON.stringify(data || {}),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (res) { if (done) done(res.d); },
                error: function (xhr) { showMessage('error', ajaxError(xhr)); }
            });
        }

        function loadImportProjects() {
            importPageMethod('GetProjects', {}, function (rows) {
                fillSelect('#importUWProject', rows || [], ['ProjectID', 'ProjectId'], ['ProjectName'], 'Select');
            });
        }

        function uploadImport(mode) {
            var fileInput = mode === 'UW' ? $('#importUWFile')[0] : $('#importSearchFile')[0];
            if (!fileInput.files || !fileInput.files.length) { showMessage('error', 'Please select Excel file.'); return; }
            if (!/\.(xls|xlsx)$/i.test(fileInput.files[0].name)) { showMessage('error', 'Please select only .xls or .xlsx file.'); return; }

            var formData = new FormData();
            formData.append('FeedbackFile', fileInput.files[0]);
            formData.append('ProjectID', $('#importUWProject').val() || '');
            formData.append('DealNo', $('#importUWDealNo').val() || '');
            formData.append('OrderNo', $('#importUWOrderNo').val() || '');

            $.ajax({
                type: 'POST',
                url: 'ImportFeedback.aspx?handler=Upload&mode=' + encodeURIComponent(mode),
                data: formData,
                cache: false,
                contentType: false,
                processData: false,
                success: function (result) {
                    if (typeof result === 'string') result = JSON.parse(result);
                    showMessage(result.Success ? 'success' : 'error', result.Message);
                    bindImportResult(result);
                },
                error: function (xhr) { showMessage('error', ajaxError(xhr)); }
            });
        }

        function bindImportResult(result) {
            $('#importTotal').text('Total Count : ' + (result.TotalCount || 0));
            $('#importAdded').text('Added Count : ' + (result.AddedCount || 0));
            $('#importRejected').text('Not Added Count : ' + (result.RejectedCount || 0));
            bindDynamicTable('#importAddedTable', result.AddedRows || [], true);
            bindDynamicTable('#importRejectedTable', result.RejectedRows || [], false);
        }

        function bindDynamicTable(selector, rows, added) {
            var table = added ? addedTable : rejectedTable;
            if (table) table.destroy();
            var columns = [];
            $.each(rows, function (_, row) {
                $.each(row, function (key) { if ($.inArray(key, columns) === -1) columns.push(key); });
            });
            var head = $(selector + ' thead tr').empty();
            $.each(columns, function (_, col) { head.append($('<th/>').text(col)); });
            var body = $(selector + ' tbody').empty();
            $.each(rows, function (_, row) {
                var tr = $('<tr/>');
                $.each(columns, function (_, col) { tr.append($('<td/>').text(row[col] == null ? '' : row[col])); });
                tr.appendTo(body);
            });
            var newTable = $(selector).DataTable({ responsive: false, scrollX: true, pageLength: 10, dom: 'Bfrtip', buttons: ['excelHtml5', 'print'] });
            if (added) addedTable = newTable; else rejectedTable = newTable;
        }

        function downloadFormat() {
            var headers = ['Deal No', 'Order #', 'Order Date', 'Project #', 'Process', 'Error Done By', 'Feedback given By', 'Error Field', 'Section', 'Field', 'Error', 'Should be', 'Error Type', 'Fatal/Non-Fatal', 'Feedback Type', 'Feedback Received Date', 'Remark'];
            var csv = headers.join(',') + '\n';
            var blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
            var link = document.createElement('a');
            link.href = URL.createObjectURL(blob);
            link.download = 'FeedbackImportFormat.csv';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }

        function fillSelect(selector, rows, valueKeys, textKeys, firstText) {
            var ddl = $(selector).empty();
            $('<option/>').val('').text(firstText || 'Select').appendTo(ddl);
            $.each(rows || [], function (_, row) {
                $('<option/>').val(valueOf(row, valueKeys)).text(valueOf(row, textKeys)).appendTo(ddl);
            });
        }

        function valueOf(row, keys) {
            for (var i = 0; i < keys.length; i++) if (row && row[keys[i]] !== undefined && row[keys[i]] !== null) return row[keys[i]];
            return '';
        }

        function showMessage(type, message) {
            $('#importMessage').removeClass('success error').addClass(type).text(message).show();
            setTimeout(function () { $('#importMessage').fadeOut(); }, 6000);
        }

        function ajaxError(xhr) {
            try { return xhr.responseJSON.Message || xhr.responseText || 'Unexpected error occurred.'; } catch (e) { return 'Unexpected error occurred.'; }
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="fb-page">
        <div class="fb-hero">
            <div>
                <h1 class="fb-title">Import Feedback</h1>
                <p class="fb-subtitle">Upload feedback Excel files and review added or rejected rows.</p>
            </div>
            <button id="importDownloadFormat" type="button" class="fb-btn fb-btn-light">Download Format</button>
        </div>

        <div id="importMessage" class="fb-message"></div>

        <div class="fb-panel">
            <div class="fb-panel-body">
                <div class="fb-tabs">
                    <button type="button" class="fb-tab active" data-tab="searchImportPanel">Import Feedback</button>
                    <button type="button" class="fb-tab" data-tab="uwImportPanel">Import Feedback For UW</button>
                </div>

                <div id="searchImportPanel" class="fb-tab-panel active">
                    <div class="fb-grid-form">
                        <div class="fb-field">
                            <label for="importSearchFile">Excel File</label>
                            <input id="importSearchFile" type="file" class="form-control" accept=".xls,.xlsx" />
                        </div>
                        <div class="fb-field">
                            <label>&nbsp;</label>
                            <button id="importSearchUpload" type="button" class="fb-btn fb-btn-primary">Upload</button>
                        </div>
                    </div>
                </div>

                <div id="uwImportPanel" class="fb-tab-panel">
                    <div class="fb-grid-form">
                        <div class="fb-field">
                            <label for="importUWProject">Project</label>
                            <select id="importUWProject" class="form-control"></select>
                        </div>
                        <div class="fb-field">
                            <label for="importUWDealNo">Deal No</label>
                            <input id="importUWDealNo" type="text" class="form-control" />
                        </div>
                        <div class="fb-field">
                            <label for="importUWOrderNo">Order No</label>
                            <input id="importUWOrderNo" type="text" class="form-control" />
                        </div>
                        <div class="fb-field">
                            <label for="importUWFile">Excel File</label>
                            <input id="importUWFile" type="file" class="form-control" accept=".xls,.xlsx" />
                        </div>
                        <div class="fb-field">
                            <label>&nbsp;</label>
                            <button id="importUWUpload" type="button" class="fb-btn fb-btn-primary">Upload</button>
                        </div>
                    </div>
                </div>

                <div class="fb-summary">
                    <span id="importTotal" class="fb-pill">Total Count : 0</span>
                    <span id="importAdded" class="fb-pill">Added Count : 0</span>
                    <span id="importRejected" class="fb-pill">Not Added Count : 0</span>
                </div>
            </div>
        </div>

        <div class="fb-panel">
            <div class="fb-panel-header"><h2 class="fb-panel-title">Feedback Added</h2></div>
            <div class="fb-table-wrap">
                <table id="importAddedTable" class="table table-bordered table-striped" style="width: 100%;">
                    <thead><tr></tr></thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>

        <div class="fb-panel">
            <div class="fb-panel-header"><h2 class="fb-panel-title">Feedback Not Added</h2></div>
            <div class="fb-table-wrap">
                <table id="importRejectedTable" class="table table-bordered table-striped" style="width: 100%;">
                    <thead><tr></tr></thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
