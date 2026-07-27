<%@ Page Title="" Language="C#" MasterPageFile="~/Vendor/VendorMaster.Master" AutoEventWireup="true" CodeBehind="ProjectTrackingReportVM.aspx.cs" Inherits="WebPortal.Vendor.ProjectTrackingReportVM" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
    .erp-page { padding: 14px; }
    .erp-hero { background: #fff; border: 1px solid #e4e8ee; border-radius: 6px; padding: 16px 18px; margin-bottom: 14px; }
    .erp-hero h3 { margin: 0; color: #28384d; font-size: 22px; font-weight: 600; }
    .erp-breadcrumb { margin-top: 5px; color: #7b8794; font-size: 12px; }
    .erp-panel { background: #fff; border: 1px solid #e4e8ee; border-radius: 6px; margin-bottom: 14px; }
    .erp-panel-title { padding: 11px 15px; border-bottom: 1px solid #e9edf2; color: #34495e; font-weight: 600; }
    .erp-panel-body { padding: 15px; }
    .erp-label { display: block; margin-bottom: 5px; color: #465568; font-size: 12px; font-weight: 600; }
    .erp-input { width: 100%; height: 34px; padding: 6px 10px; border: 1px solid #ccd4dd; border-radius: 4px; background: #fff; }
    .erp-radio-group { padding-top: 8px; white-space: nowrap; }
    .erp-radio-group label { margin-right: 18px; font-weight: 500; }
    .erp-btn { border: 0; border-radius: 4px; padding: 8px 14px; cursor: pointer; font-size: 13px; }
    .erp-btn-primary { background: #3f6ea8; color: #fff; }
    .erp-btn-light { background: #eef2f6; color: #34495e; border: 1px solid #dce3ea; }
    .erp-btn-success { background: #4f8b69; color: #fff; }
    .erp-btn-danger { background: #b85b5b; color: #fff; }
    .erp-btn-xs { padding: 4px 7px; margin: 1px 2px; font-size: 12px; }
    .erp-toolbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; gap: 10px; }
    .erp-record-count { color: #526274; font-weight: 600; }
    .grid-wrap { position: relative; min-height: 180px; overflow: hidden; }
    .grid-scroll { overflow: auto; max-height: 62vh; }
    .erp-loader { display: none; position: absolute; inset: 0; z-index: 25; background: rgba(255,255,255,.78); align-items: center; justify-content: center; }
    .erp-loader.show { display: flex; }
    .erp-spinner { width: 34px; height: 34px; border: 4px solid #dbe3ec; border-top-color: #3f6ea8; border-radius: 50%; animation: erpSpin .75s linear infinite; }
    @keyframes erpSpin { to { transform: rotate(360deg); } }
    table.dataTable { width: 100% !important; font-size: 12px; }
    table.dataTable thead th { white-space: nowrap; background: #edf2f7; color: #34495e; }
    table.dataTable tbody td { white-space: nowrap; vertical-align: middle; }
    .row-hold td { background: #fff4bf !important; }
    .row-cancel td { background: #f7d1d1 !important; }
    .text-purple { color: #7d3c98 !important; }
    .remark-text { color: #4f88bb; }
    .erp-modal { display: none; position: fixed; z-index: 9999; inset: 0; background: rgba(0,0,0,.45); padding: 30px 15px; overflow-y: auto; }
    .erp-modal-dialog { width: 95%; max-width: 1100px; margin: 0 auto; background: #fff; border-radius: 6px; box-shadow: 0 8px 28px rgba(0,0,0,.25); }
    .erp-modal-header { padding: 12px 15px; border-bottom: 1px solid #e5e9ee; display: flex; justify-content: space-between; align-items: center; }
    .erp-modal-title { margin: 0; font-size: 17px; color: #34495e; }
    .erp-modal-close { border: 0; background: transparent; font-size: 24px; line-height: 1; cursor: pointer; }
    .erp-modal-body { padding: 15px; }
    .erp-modal-footer { padding: 10px 15px; border-top: 1px solid #e5e9ee; text-align: right; }
    .detail-grid { width: 100%; border-collapse: collapse; font-size: 12px; }
    .detail-grid th, .detail-grid td { border: 1px solid #dfe5eb; padding: 7px; white-space: nowrap; }
    .detail-grid th { background: #edf2f7; }
    .action-menu { min-width: 270px; white-space: normal !important; }
    .process-link.disabled { color: #9ba7b3; pointer-events: none; text-decoration: none; }
    @media(max-width: 768px) { .erp-toolbar { display: block; } .erp-toolbar > div { margin-bottom: 8px; } }
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="erp-page">
    <div class="erp-hero">
        <h3>VM Order Queue</h3>
        <div class="erp-breadcrumb">Home / Vendor / VM Order Queue</div>
    </div>

    <div class="erp-panel">
        <div class="erp-panel-title">Search Orders</div>
        <div class="erp-panel-body">
            <div class="row">
                <div class="col-md-3 col-sm-6">
                    <label class="erp-label" for="txtFromDate">From Date</label>
                    <input type="text" id="txtFromDate" class="erp-input erp-date" autocomplete="off" />
                </div>
                <div class="col-md-3 col-sm-6">
                    <label class="erp-label" for="txtToDate">To Date</label>
                    <input type="text" id="txtToDate" class="erp-input erp-date" autocomplete="off" />
                </div>
                <div class="col-md-3 col-sm-6">
                    <label class="erp-label">Order View</label>
                    <div class="erp-radio-group">
                        <label><input type="radio" name="orderView" value="all" id="rdbProjectTracking" /> All Orders</label>
                        <label><input type="radio" name="orderView" value="mine" id="rdbMyOrders" checked /> My Orders</label>
                    </div>
                </div>
                <div class="col-md-3 col-sm-6" style="padding-top:24px;">
                    <button type="button" id="btnShow" class="erp-btn erp-btn-primary"><i class="fa fa-search"></i> Show</button>
                    <button type="button" id="btnClear" class="erp-btn erp-btn-light"><i class="fa fa-eraser"></i> Clear</button>
                </div>
            </div>
        </div>
    </div>

    <div class="erp-panel">
        <div class="erp-panel-title">Order Details</div>
        <div class="erp-panel-body">
            <div class="erp-toolbar">
                <div id="lblRecords" class="erp-record-count">Total Records: 0</div>
                <div>
                    <button type="button" id="btnExportExcel" class="erp-btn erp-btn-success"><i class="fa fa-file-excel-o"></i> Export Excel</button>
                </div>
            </div>
            <div class="grid-wrap">
                <div id="mainLoader" class="erp-loader"><div class="erp-spinner"></div></div>
                <div class="grid-scroll">
                    <table id="grdReport" class="table table-bordered table-hover" style="width:100%">
                        <thead><tr></tr></thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="detailModal" class="erp-modal">
    <div class="erp-modal-dialog">
        <div class="erp-modal-header">
            <h4 id="detailModalTitle" class="erp-modal-title">Details</h4>
            <button type="button" class="erp-modal-close" data-close-modal>&times;</button>
        </div>
        <div class="erp-modal-body">
            <div id="detailLoader" class="text-center" style="display:none;padding:30px;"><div class="erp-spinner" style="display:inline-block;"></div></div>
            <div id="detailContent"></div>
        </div>
        <div class="erp-modal-footer">
            <button type="button" class="erp-btn erp-btn-light" data-close-modal>Close</button>
        </div>
    </div>
</div>

<div id="commentModal" class="erp-modal">
    <div class="erp-modal-dialog" style="max-width:900px;">
        <div class="erp-modal-header">
            <h4 class="erp-modal-title">Order Comments</h4>
            <button type="button" class="erp-modal-close" data-close-modal>&times;</button>
        </div>
        <div class="erp-modal-body">
            <input type="hidden" id="commentOrderId" />
            <div class="row">
                <div class="col-md-4"><label class="erp-label">Order Number</label><input id="commentOrderNo" class="erp-input" readonly /></div>
                <div class="col-md-4"><label class="erp-label">VM Name</label><input id="commentVM" class="erp-input" readonly /></div>
                <div class="col-md-4"><label class="erp-label">Abstractor</label><input id="commentAbstractor" class="erp-input" readonly /></div>
            </div>
            <div class="row" style="margin-top:12px;">
                <div class="col-md-4"><label class="erp-label">Type</label><select id="ddlType" class="erp-input"><option>Connect With Abstractor</option><option>Connect With VM</option><option>Client Follow-up</option><option>Internal Note</option></select></div>
                <div class="col-md-8"><label class="erp-label">Comment</label><textarea id="txtComment" class="erp-input" style="height:70px;resize:vertical;"></textarea></div>
            </div>
            <div style="margin-top:10px;text-align:right;"><button type="button" id="btnSaveComment" class="erp-btn erp-btn-primary"><i class="fa fa-save"></i> Save Comment</button></div>
            <div id="commentsContainer" style="margin-top:15px;"></div>
        </div>
        <div class="erp-modal-footer"><button type="button" class="erp-btn erp-btn-light" data-close-modal>Close</button></div>
    </div>
</div>

<script src="../Scripts/jquery-3.6.0.min.js"></script>
<script src="../Scripts/datatables.min.js"></script>
<script src="../Scripts/dataTables.buttons.min.js"></script>
<script src="../Scripts/jszip.min.js"></script>
<script src="../Scripts/buttons.html5.min.js"></script>

<script type="text/javascript">
    var reportTable = null;
    var reportRows = [];
    var isPM = false;

    $(function () {
        setDefaultDates();
        checkPMAndLoad();

        $('#btnShow').on('click', loadOrders);
        $('#btnClear').on('click', function () { setDefaultDates(); $('#rdbMyOrders').prop('checked', true); loadOrders(); });
        $('#btnExportExcel').on('click', function () { if (reportTable) reportTable.button('.buttons-excel').trigger(); });
        $('[data-close-modal]').on('click', function () { $(this).closest('.erp-modal').hide(); });
        $('.erp-modal').on('click', function (e) { if (e.target === this) $(this).hide(); });
        $('#btnSaveComment').on('click', saveComment);
    });

    function pageMethod(method, data) {
        return $.ajax({
            type: 'POST',
            url: 'ProjectTrackingReportVM.aspx/' + method,
            data: JSON.stringify(data || {}),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json'
        }).then(function (r) { return r.d; });
    }

    function checkPMAndLoad() {
        pageMethod('GetCurrentUserAccess').done(function (r) {
            isPM = r.IsPM === true;
            if (!isPM) { $('#rdbProjectTracking').closest('label').hide(); $('#rdbMyOrders').prop('checked', true); }
            loadOrders();
        }).fail(showAjaxError);
    }

    function setDefaultDates() {
        var d = new Date();
        var text = formatDate(d);
        $('#txtFromDate,#txtToDate').val(text);
    }

    function formatDate(d) {
        var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
        return ('0' + d.getDate()).slice(-2) + '-' + months[d.getMonth()] + '-' + d.getFullYear();
    }

    function loadOrders() {
        $('#mainLoader').addClass('show');
        pageMethod('GetOrders', {
            fromDate: $('#txtFromDate').val(),
            toDate: $('#txtToDate').val(),
            projectId: '591',
            showAll: $('#rdbProjectTracking').is(':checked')
        }).done(function (rows) {
            reportRows = rows || [];
            bindReportTable(reportRows);
            $('#lblRecords').text('Total Records: ' + reportRows.length);
        }).fail(showAjaxError).always(function () { $('#mainLoader').removeClass('show'); });
    }

    function bindReportTable(rows) {
        if (reportTable) { reportTable.destroy(); reportTable = null; }
        var table = $('#grdReport');
        table.find('thead tr').empty();
        table.find('tbody').empty();

        var keys = getColumns(rows);
        var columns = [{ title: 'Action', data: null, orderable: false, searchable: false, render: renderActions }];
        table.find('thead tr').append('<th>Action</th>');

        $.each(keys, function (_, key) {
            table.find('thead tr').append($('<th/>').text(displayName(key)));
            columns.push({ title: displayName(key), data: key, defaultContent: '', render: function (v, type, row) { return renderCell(key, v, row); } });
        });

        reportTable = table.DataTable({
            data: rows,
            columns: columns,
            paging: false,
            searching: true,
            info: false,
            ordering: true,
            autoWidth: false,
            scrollX: true,
            scrollY: '55vh',
            scrollCollapse: true,
            fixedHeader: true,
            dom: 'Bfrtip',
            buttons: [{ extend: 'excelHtml5', title: 'VM Order Queue', className: 'buttons-excel', exportOptions: { columns: ':not(:first-child)' } }],
            createdRow: function (row, data) {
                var status = String(data.ProcessStatus || '').toLowerCase();
                if (status === 'hold') $(row).addClass('row-hold');
                if (status === 'cancel') $(row).addClass('row-cancel');
                if (String(data.LegalDescription || '') === '3422') $(row).addClass('text-purple');
            },
            initComplete: function () { $('.dt-buttons').hide(); }
        });
    }

    function getColumns(rows) {
        var keys = [];
        $.each(rows, function (_, row) {
            $.each(row, function (key) {
                if ($.inArray(key, keys) === -1 && key !== 'TaskAssignedId') keys.push(key);
            });
        });
        return keys;
    }

    function displayName(key) {
        var map = { ClientOrderNo:'Order No', OrderDate:'Order Date', ProcessStatus:'Process Status', SalesPurchaseAmount:'Sales Price', OnOffLine:'On/Offline', DispDate:'Dispatch End Date', DispBy:'Dispatch By' };
        if (map[key]) return map[key];
        return key.replace(/_/g, ' ').replace(/([a-z])([A-Z])/g, '$1 $2');
    }

    function renderCell(key, value, row) {
        var text = value == null ? '' : String(value);
        if (key === 'SalesPurchaseAmount' && text && text.indexOf('$') !== 0 && !isNaN(text.replace(/,/g, ''))) {
            return '$' + Number(text.replace(/,/g, '')).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
        }
        if (key === 'Remark') return '<span class="remark-text">' + html(text) + '</span>';
        if ($.inArray(key, ['SearchBy','ReSearchBy','TypingBy','QABy','DispBy']) >= 0) return renderProcessLink(key, text, row);
        return html(text);
    }

    function renderProcessLink(key, text, row) {
        if (!text) return '';
        var endField = { SearchBy:'SearchDate', ReSearchBy:'ReSearchDate', TypingBy:'TypingDate', QABy:'QADate', DispBy:'DispDate' }[key];
        var allowed = !row[endField] && (Number(row.TaskAssignedId || 0) === Number(<%= CurrentUserId %>) || isPM) && String(row.ProcessStatus || '') === 'In-Process';
        var url = (isPM ? 'ProcessOrderPMPopUp.aspx' : 'ProcessOrderPopUp.aspx') + '?OrderId=' + encodeURIComponent(row.OrderId) + '&Project=' + encodeURIComponent(row.ProjectNumber || '591');
        return '<a class="process-link ' + (allowed ? '' : 'disabled') + '" href="javascript:void(0)" onclick="openProcess(\'' + js(url) + '\')">' + html(text) + '</a>';
    }

    function renderActions(data, type, row) {
        var id = row.OrderId || row.OrderID || row.TaskId || 0;
        var editId = row.TaskId || id;
        return '<div class="action-menu">' +
            btn('fa-edit','Edit','openEdit(' + q(editId) + ')') +
            btn('fa-paperclip','Attachments','openDetail(\'Attachments\',' + q(id) + ')') +
            btn('fa-comment','Comments','openComments(' + q(id) + ')') +
            btn('fa-check-square','Checklist','openDetail(\'Checklist\',' + q(id) + ')') +
            btn('fa-history','History','openDetail(\'History\',' + q(id) + ')') +
            btn('fa-dollar-sign','Costing','openDetail(\'Costing\',' + q(id) + ')') +
            btn('fa-comments','Feedback','openDetail(\'Feedback\',' + q(id) + ')') +
            btn('fa-calculator','Tax','openDetail(\'Tax\',' + q(id) + ')') + '</div>';
    }

    function btn(icon, title, action) { return '<button type="button" class="erp-btn erp-btn-light erp-btn-xs" title="' + title + '" onclick="' + action + '"><i class="fa ' + icon + '"></i></button>'; }
    function q(v) { return "'" + js(String(v)) + "'"; }
    function openEdit(id) { openWindowModal('VMEditOrders.aspx?OrderId=' + encodeURIComponent(id), 'Edit Order'); }
    function openProcess(url) { openWindowModal(url, 'Process Order'); }
    function openWindowModal(url, title) { $('#detailModalTitle').text(title); $('#detailContent').html('<iframe src="' + htmlAttr(url) + '" style="width:100%;height:650px;border:0;"></iframe>'); $('#detailModal').show(); }

    function openDetail(type, orderId) {
        $('#detailModalTitle').text(type);
        $('#detailContent').empty(); $('#detailLoader').show(); $('#detailModal').show();
        pageMethod('GetOrderDetail', { orderId: Number(orderId), detailType: type }).done(function (rows) {
            $('#detailContent').html(buildDetailTable(rows || [], type));
        }).fail(showAjaxError).always(function () { $('#detailLoader').hide(); });
    }

    function buildDetailTable(rows, type) {
        if (!rows.length) return '<div class="alert alert-info">No records found.</div>';
        var keys = getColumns(rows), s = '<div style="overflow:auto;max-height:60vh"><table class="detail-grid"><thead><tr><th>Sr. #</th>';
        $.each(keys, function (_, k) { if (k !== 'Path') s += '<th>' + html(displayName(k)) + '</th>'; });
        if (type === 'Attachments') s += '<th>Download</th>';
        s += '</tr></thead><tbody>';
        $.each(rows, function (i, row) {
            s += '<tr><td>' + (i + 1) + '</td>';
            $.each(keys, function (_, k) { if (k !== 'Path') s += '<td>' + html(row[k] == null ? '' : row[k]) + '</td>'; });
            if (type === 'Attachments') {
                var path = row.Path || '';
                s += '<td>' + (path ? '<a class="erp-btn erp-btn-light erp-btn-xs" href="../OST/DownloadFile.aspx?AttachmentPath=' + encodeURIComponent(path) + '"><i class="fa fa-download"></i></a>' : '') + '</td>';
            }
            s += '</tr>';
        });
        return s + '</tbody></table></div>';
    }

    function openComments(orderId) {
        $('#commentOrderId').val(orderId); $('#txtComment').val(''); $('#commentModal').show();
        pageMethod('GetCommentPopupData', { orderId: Number(orderId) }).done(function (r) {
            $('#commentOrderNo').val(r.OrderNo || ''); $('#commentVM').val(r.VM || ''); $('#commentAbstractor').val(r.Abstractor || '');
            $('#commentsContainer').html(buildDetailTable(r.Comments || [], 'Comments'));
        }).fail(showAjaxError);
    }

    function saveComment() {
        var comment = $.trim($('#txtComment').val());
        if (!comment) { alert('Please enter comment.'); return; }
        pageMethod('SaveComment', { orderId: Number($('#commentOrderId').val()), type: $('#ddlType').val(), comment: comment }).done(function (rows) {
            $('#txtComment').val(''); $('#commentsContainer').html(buildDetailTable(rows || [], 'Comments')); loadOrders();
        }).fail(showAjaxError);
    }

    function showAjaxError(xhr) {
        var message = 'Unable to process request.';
        try { message = xhr.responseJSON.Message || xhr.responseJSON.ExceptionMessage || message; } catch (e) { }
        alert(message);
    }
    function html(v) { return $('<div/>').text(v == null ? '' : String(v)).html(); }
    function htmlAttr(v) { return html(v).replace(/"/g, '&quot;'); }
    function js(v) { return String(v).replace(/\\/g, '\\\\').replace(/'/g, "\\'").replace(/\r?\n/g, ' '); }
</script>
</asp:Content>
