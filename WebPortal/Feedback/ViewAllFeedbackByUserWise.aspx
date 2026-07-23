<%@ Page Title="" Language="C#" MasterPageFile="~/Feedback/Feedback.Master" AutoEventWireup="true" CodeBehind="ViewAllFeedbackByUserWise.aspx.cs" Inherits="WebPortal.Feedback.ViewAllFeedbackByUserWise" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
            .loading {
      display: none;
      position: fixed;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      width: 170px;
      min-height: 155px;
      z-index: 99999;
      background: rgba(255,255,255,.96);
      border-radius: 22px;
      box-shadow: 0 18px 50px rgba(15,23,42,.18);
      text-align: center;
      padding: 22px 14px;
      color: #0f172a;
      font-size: 12px;
      font-weight: 800;
  }

  .loading img {
      max-width: 78px;
      display: block;
      margin: 0 auto 10px;
  }
        .fb-page { color: #172737; font-size: 13px; padding: 0px 0 28px; }
        .fb-hero { background: linear-gradient(135deg, #0f766e 0%, #1d4ed8 100%); border-radius: 8px; color: #fff; margin-bottom: 16px; padding: 20px 22px; }
        .fb-title { font-size: 22px; font-weight: 800; margin: 0; }
        .fb-subtitle { color: rgba(255,255,255,.9); font-size: 12px; margin: 6px 0 0; }
        .fb-panel { background: #fff; border: 1px solid #dce5ec; border-radius: 8px; margin-bottom: 16px; overflow: hidden; }
        .fb-panel-body { padding: 16px; }
        .fb-filter { align-items: end; display: grid; gap: 12px; grid-template-columns: 180px 1fr 1fr auto auto auto; }
        .fb-field label { color: #46596b; display: block; font-size: 12px; font-weight: 700; margin-bottom: 5px; }
        .fb-field .form-control { border-color: #cfdbe5; border-radius: 6px; font-size: 13px; min-height: 36px; width: 100%; }
        .fb-radio-row { align-items: center; display: flex; gap: 14px; min-height: 36px; }
        .fb-radio-row label { color: #172737; font-weight: 800; margin: 0; }
        .fb-btn { border: 1px solid transparent; border-radius: 6px; cursor: pointer; font-size: 13px; font-weight: 800; min-height: 36px; padding: 7px 13px; }
        .fb-btn-primary { background: #0f766e; border-color: #0f766e; color: #fff; }
        .fb-btn-light { background: #eef3f7; border-color: #d6e1ea; color: #17324d; }
        .fb-message { display: none; font-weight: 700; margin-bottom: 12px; padding: 10px 12px; }
        .fb-message.success { background: #e8f7ef; border: 1px solid #b7e2c8; color: #136c34; }
        .fb-message.error { background: #fff1f0; border: 1px solid #ffc9c4; color: #b42318; }
        .fb-count { color: #b42318; font-weight: 800; margin: 0 16px 12px; }
        .fb-table-wrap { overflow-x: auto; padding: 0 16px 16px; }
        .table.dataTable thead th { background: #edf3f6 !important; color: #263747; font-size: 12px; text-align: center; white-space: nowrap; }
        .table.dataTable tbody td { font-size: 12px; vertical-align: middle; }
        @media (max-width: 1100px) { .fb-filter { grid-template-columns: repeat(2, minmax(0, 1fr)); } }
        @media (max-width: 640px) { .fb-filter { grid-template-columns: 1fr; } }
    </style>
    <script type="text/javascript">
        var userFeedbackTable = null;
        var userColumns = [
            ['OrderNo', 'Order #'], ['OrderDate', 'Order Date'], ['ProjectName', 'Project #'], ['ProcessName', 'Process'],
            ['ErrorDoneBY', 'Error Done By'], ['FeedbackBy', 'Feedback given By'], ['ErrorType', 'Error Type'], ['Fatal', 'Fatal/Non-Fatal'],
            ['FeildName', 'Error Field'], ['Section', 'Section'], ['Field', 'Field'], ['Error', 'Error'], ['ShouldBe', 'Should be'],
            ['FeedbackType', 'Feedback Type'], ['FeedbackRecivedDate', 'Feedback Received Date'], ['Remark', 'Remark'],
            ['FeedbackerrorPath', 'Feedback path'], ['EDBStatus', 'Status'], ['EDBRemark', 'Explanation'], ['PMStatus', 'PM Status'], ['PMRemark', 'PM Remark']
        ];

        $(document).ready(function () {
            $('.fb-date').datepicker({ dateFormat: 'dd-M-yy', changeMonth: true, changeYear: true });
            $('#userShow').on('click', loadUserFeedback);
            $('#userFatal').on('click', function () { openUserAcceptance('Fatal'); });
            $('#userNonFatal').on('click', function () { openUserAcceptance('Non-Fatal'); });
            //loadUserFeedback();
        });

        function userPageMethod(method, data, done) {
            $.ajax({
                type: 'POST',
                url: 'ViewAllFeedbackByUserWise.aspx/' + method,
                data: JSON.stringify(data || {}),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (res) { if (done) done(res.d); },
                error: function (xhr) { showMessage('error', ajaxError(xhr)); }
            });
        }

        function loadUserFeedback() {
            $('#load1').show();
            userPageMethod('GetFeedbacks', {
                feedbackSource: $('input[name="feedbackSource"]:checked').val(),
                fromDate: $('#userFrom').val(),
                toDate: $('#userTo').val()
            }, function (rows) {
                rows = rows || [];
                $('#userCount').text('Total Feedback : ' + rows.length);
                bindUserTable(rows);
            });
        }

        function bindUserTable(rows) {
            if (userFeedbackTable) userFeedbackTable.destroy();
            var head = $('#userTable thead tr').empty();
            head.append('<th>Action</th><th>Sr. #</th>');
            $.each(userColumns, function (_, col) { head.append($('<th/>').text(col[1])); });

            var body = $('#userTable tbody').empty();
            $.each(rows, function (i, row) {
                var orderNo = valueOf(row, ['OrderNo']);
                var tr = $('<tr/>');
//                tr.append('<td><button type="button" class="fb-btn fb-btn-light" onclick="viewUserFeedback(\'' + escapeAttr(orderNo) + '\')">View</button></td>');
                tr.append('<td><a href = "javascript:void(0);" onclick = "viewUserFeedback(' + escapeAttr(orderNo) + ')" title = "View" > ' +
                    '<i class="fa fa-eye text-primary" style="font-size:16px;margin-right:10px;"></i>' +
                    '</a></td > ');
                tr.append($('<td/>').text(i + 1));
                $.each(userColumns, function (_, col) {
                    var td = $('<td/>').text(valueOf(row, [col[0]]));
                    if (col[0] === "Error" || col[0] === "ShouldBe" || col[0] === "Remark" || col[0] === "EDBRemark" || col[0] === "ProcessName") {
                        td.css("white-space", "nowrap");
                    }
                    tr.append(td);
                    //tr.append($('<td/>').text(valueOf(row, [col[0]])));
                });
                tr.appendTo(body);
            });

            userFeedbackTable = $('#userTable').DataTable({
                responsive: false, scrollX: true, pageLength: 25, dom: 'Bfrtip', buttons: ['excelHtml5', 'pdfHtml5', 'print'],
                initComplete: function () {
                    $('#load1').hide();
                }
            });
        }

        function viewUserFeedback(orderNo) {
            if (orderNo) window.location.href = 'AddFeedbackForSearchProject.aspx?OrderNo=' + encodeURIComponent(orderNo);
        }

        function openUserAcceptance(fatal) {
            userPageMethod('GetAcceptanceLink', { fatal: fatal }, function (result) {
                if (result.Success) window.location.href = result.Url;
                else showMessage('error', result.Message);
            });
        }

        function valueOf(row, keys) {
            for (var i = 0; i < keys.length; i++) if (row && row[keys[i]] !== undefined && row[keys[i]] !== null) return row[keys[i]];
            return '';
        }

        function escapeAttr(value) {
            return String(value || '').replace(/\\/g, '\\\\').replace(/'/g, "\\'");
        }

        function showMessage(type, message) {
            $('#userMessage').removeClass('success error').addClass(type).text(message).show();
            setTimeout(function () { $('#userMessage').fadeOut(); }, 4500);
        }

        function ajaxError(xhr) {
            try { return xhr.responseJSON.Message || xhr.responseText || 'Unexpected error occurred.'; } catch (e) { return 'Unexpected error occurred.'; }
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <div class="loading" id="load1">
      <img src="../images/Load_1.gif" />
      <div>One moment, please . . . .</div>
  </div>
    <div class="fb-page">
        <div class="fb-hero">
            <h1 class="fb-title">View All Feedback</h1>
            <p class="fb-subtitle">User-wise internal and client feedback report.</p>
        </div>

        <div id="userMessage" class="fb-message"></div>

        <div class="fb-panel">
            <div class="fb-panel-body">
                <div class="fb-filter">
                    <div class="fb-radio-row">
                        <label><input type="radio" name="feedbackSource" value="Internal" checked="checked" /> Internal</label>
                        <label><input type="radio" name="feedbackSource" value="Client" /> Client</label>
                    </div>
                    <div class="fb-field">
                        <label for="userFrom">From Date</label>
                        <input id="userFrom" type="text" class="form-control fb-date" placeholder="01-Jan-2026" />
                    </div>
                    <div class="fb-field">
                        <label for="userTo">To Date</label>
                        <input id="userTo" type="text" class="form-control fb-date" placeholder="01-Jan-2026" />
                    </div>
                    <button id="userShow" type="button" class="fb-btn fb-btn-primary">Show</button>
                    <button id="userFatal" type="button" class="fb-btn fb-btn-light">Acceptance Fatal</button>
                    <button id="userNonFatal" type="button" class="fb-btn fb-btn-light">Acceptance Non-Fatal</button>
                </div>
            </div>
        </div>

        <div class="fb-panel">
            <div id="userCount" class="fb-count">Total Feedback : 0</div>
            <div class="fb-table-wrap">
                <table id="userTable" class="table table-bordered table-striped" style="width: 100%;">
                    <thead><tr></tr></thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
