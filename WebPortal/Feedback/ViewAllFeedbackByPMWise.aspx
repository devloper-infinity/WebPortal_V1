<%@ Page Title="" Language="C#" MasterPageFile="~/Feedback/Feedback.Master" AutoEventWireup="true" CodeBehind="ViewAllFeedbackByPMWise.aspx.cs" Inherits="WebPortal.Feedback.ViewAllFeedbackByPMWise" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .fb-page { color: #172737; font-size: 13px; padding: 18px 0 28px; }
        .fb-hero { background: linear-gradient(135deg, #0f766e 0%, #1d4ed8 100%); border-radius: 8px; color: #fff; margin-bottom: 16px; padding: 20px 22px; }
        .fb-title { font-size: 22px; font-weight: 800; margin: 0; }
        .fb-subtitle { color: rgba(255,255,255,.9); font-size: 12px; margin: 6px 0 0; }
        .fb-panel { background: #fff; border: 1px solid #dce5ec; border-radius: 8px; margin-bottom: 16px; overflow: hidden; }
        .fb-panel-body { padding: 16px; }
        .fb-filter { align-items: end; display: grid; gap: 12px; grid-template-columns: repeat(5, minmax(0, 1fr)); }
        .fb-field label { color: #46596b; display: block; font-size: 12px; font-weight: 700; margin-bottom: 5px; }
        .fb-field .form-control { border-color: #cfdbe5; border-radius: 6px; font-size: 13px; min-height: 36px; width: 100%; }
        .fb-btn { border: 1px solid transparent; border-radius: 6px; cursor: pointer; font-size: 13px; font-weight: 800; min-height: 36px; padding: 7px 13px; }
        .fb-btn-primary { background: #0f766e; border-color: #0f766e; color: #fff; }
        .fb-btn-light { background: #eef3f7; border-color: #d6e1ea; color: #17324d; }
        .fb-btn-danger { background: #b42318; border-color: #b42318; color: #fff; }
        .fb-message { display: none; font-weight: 700; margin-bottom: 12px; padding: 10px 12px; }
        .fb-message.success { background: #e8f7ef; border: 1px solid #b7e2c8; color: #136c34; }
        .fb-message.error { background: #fff1f0; border: 1px solid #ffc9c4; color: #b42318; }
        .fb-table-wrap { overflow-x: auto; padding: 0 16px 16px; }
        .table.dataTable thead th { background: #edf3f6 !important; color: #263747; font-size: 12px; text-align: center; white-space: nowrap; }
        .table.dataTable tbody td { font-size: 12px; vertical-align: middle; }
        @media (max-width: 1000px) { .fb-filter { grid-template-columns: repeat(2, minmax(0, 1fr)); } }
        @media (max-width: 640px) { .fb-filter { grid-template-columns: 1fr; } }
    </style>
    <script type="text/javascript">
        var pmFeedbackTable = null;
        var pmColumns = [
            ['OrderNo', 'Order #'], ['OrderDate', 'Order Date'], ['ProjectName', 'Project #'], ['ProcessName', 'Process'],
            ['ErrorDoneBY', 'Error Done By'], ['FeedbackBy', 'Feedback given By'], ['ErrorType', 'Error Type'], ['Fatal', 'Critical/Non-Critical'],
            ['FeildName', 'Error Field'], ['Section', 'Section'], ['Field', 'Field'], ['Error', 'Error'], ['ShouldBe', 'Should be'],
            ['FeedbackType', 'Feedback Type'], ['FeedbackRecivedDate', 'Feedback Received Date'], ['FeedbackerrorPath', 'Feedback path'],
            ['Remark', 'Remark'], ['EDBStatus', 'Status'], ['EDBRemark', 'Explanation'], ['PMStatus', 'PM Status'], ['PMRemark', 'PM Remark']
        ];

        $(document).ready(function () {
            $('.fb-date').datepicker({ dateFormat: 'dd-M-yy', changeMonth: true, changeYear: true });
            $('#pmShow').on('click', loadPMFeedback);
            $('#pmFatal').on('click', function () { openAcceptance('Critical'); });
            $('#pmNonFatal').on('click', function () { openAcceptance('Non-Critical'); });
            loadPMFeedback();
        });

        function pmPageMethod(method, data, done) {
            $.ajax({
                type: 'POST',
                url: 'ViewAllFeedbackByPMWise.aspx/' + method,
                data: JSON.stringify(data || {}),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (res) { if (done) done(res.d); },
                error: function (xhr) { showMessage('error', ajaxError(xhr)); }
            });
        }

        function loadPMFeedback() {
            pmPageMethod('GetFeedbacks', { fromDate: $('#pmFrom').val(), toDate: $('#pmTo').val() }, function (rows) {
                bindTable(rows || []);
            });
        }

        function bindTable(rows) {
            if (pmFeedbackTable) pmFeedbackTable.destroy();
            var head = $('#pmTable thead tr').empty();
            head.append('<th>Action</th><th>Sr. #</th>');
            $.each(pmColumns, function (_, col) { head.append($('<th/>').text(col[1])); });

            var body = $('#pmTable tbody').empty();
            $.each(rows, function (i, row) {
                var feedId = valueOf(row, ['FeedDetailsId']);
                var tr = $('<tr/>');
                tr.append('<td><button type="button" class="fb-btn fb-btn-light" onclick="viewFeedback(' + feedId + ')">View</button> <button type="button" class="fb-btn fb-btn-danger" onclick="deleteFeedback(' + feedId + ')">Delete</button></td>');
                tr.append($('<td/>').text(i + 1));
                $.each(pmColumns, function (_, col) { tr.append($('<td/>').text(valueOf(row, [col[0]]))); });
                tr.appendTo(body);
            });

            pmFeedbackTable = $('#pmTable').DataTable({ responsive: false, scrollX: true, pageLength: 25, dom: 'Bfrtip', buttons: ['excelHtml5', 'pdfHtml5', 'print'] });
        }

        function viewFeedback(feedDetailsId) {
            if (feedDetailsId) window.location.href = 'AddFeedbackForSearchProject.aspx?PMWise=' + encodeURIComponent(feedDetailsId);
        }

        function deleteFeedback(feedDetailsId) {
            if (!feedDetailsId || !confirm('Delete this feedback?')) return;
            pmPageMethod('DeleteFeedback', { feedDetailsId: feedDetailsId }, function (result) {
                showMessage(result.Success ? 'success' : 'error', result.Message);
                if (result.Success) loadPMFeedback();
            });
        }

        function openAcceptance(fatal) {
            pmPageMethod('GetAcceptanceLink', { fatal: fatal }, function (result) {
                if (result.Success) window.location.href = result.Url;
                else showMessage('error', result.Message);
            });
        }

        function valueOf(row, keys) {
            for (var i = 0; i < keys.length; i++) if (row && row[keys[i]] !== undefined && row[keys[i]] !== null) return row[keys[i]];
            return '';
        }

        function showMessage(type, message) {
            $('#pmMessage').removeClass('success error').addClass(type).text(message).show();
            setTimeout(function () { $('#pmMessage').fadeOut(); }, 4500);
        }

        function ajaxError(xhr) {
            try { return xhr.responseJSON.Message || xhr.responseText || 'Unexpected error occurred.'; } catch (e) { return 'Unexpected error occurred.'; }
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="fb-page">
        <div class="fb-hero">
            <h1 class="fb-title">View All Feedback</h1>
            <p class="fb-subtitle">PM-wise feedback report with acceptance actions.</p>
        </div>

        <div id="pmMessage" class="fb-message"></div>

        <div class="fb-panel">
            <div class="fb-panel-body">
                <div class="fb-filter">
                    <div class="fb-field">
                        <label for="pmFrom">From Date</label>
                        <input id="pmFrom" type="text" class="form-control fb-date" placeholder="01-Jan-2026" />
                    </div>
                    <div class="fb-field">
                        <label for="pmTo">To Date</label>
                        <input id="pmTo" type="text" class="form-control fb-date" placeholder="01-Jan-2026" />
                    </div>
                    <button id="pmShow" type="button" class="fb-btn fb-btn-primary">Show</button>
                    <button id="pmFatal" type="button" class="fb-btn fb-btn-light">Acceptance Critical</button>
                    <button id="pmNonFatal" type="button" class="fb-btn fb-btn-light">Acceptance Non-Critical</button>
                </div>
            </div>
        </div>

        <div class="fb-panel">
            <div class="fb-table-wrap">
                <table id="pmTable" class="table table-bordered table-striped" style="width: 100%;">
                    <thead><tr></tr></thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
