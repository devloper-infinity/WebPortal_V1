<%@ Page Title="" Language="C#" MasterPageFile="~/Vendor/VendorMaster.Master" AutoEventWireup="true" CodeBehind="ProjectWiseSummary.aspx.cs" Inherits="WebPortal.Vendor.ProjectWiseSummary" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
     <style type="text/css">
     .vws-page { padding: 15px; }
     .erp-hero { display:flex; align-items:center; justify-content:space-between; padding:18px 22px; margin-bottom:16px; border-radius:8px; background:linear-gradient(135deg,#123d68,#245f9e); color:#fff; box-shadow:0 4px 12px rgba(15,50,85,.14); }
     .erp-hero h1 { margin:0 0 5px; font-size:23px; font-weight:600; color:#fff; }
     .erp-breadcrumb { font-size:13px; color:rgba(255,255,255,.82); }
     .erp-breadcrumb span { margin:0 7px; color:rgba(255,255,255,.55); }

     .vws-panel { background:#fff; border:1px solid #dfe5ec; border-radius:7px; margin-bottom:16px; overflow:hidden; }
     .vws-panel-title { display:flex; align-items:center; justify-content:space-between; gap:12px; padding:14px 20px; font-size:17px; font-weight:600; border-bottom:1px solid #e5ebf1; background:#f8fafc; }
     .vws-panel-body { padding:20px; }
     .vws-summary { display:grid; grid-template-columns:repeat(4,minmax(170px,1fr)); gap:12px; }
     .vws-card { min-height:94px; padding:15px 16px; border:1px solid #dce4ed; border-radius:7px; background:#fbfcfe; }
     .vws-card-label { margin-bottom:7px; color:#607086; font-size:13px; font-weight:600; }
     .vws-card-value { color:#15273b; font-size:20px; font-weight:700; overflow-wrap:anywhere; }
     .vws-toolbar { display:flex; align-items:center; justify-content:space-between; gap:12px; margin-bottom:14px; }
     .vws-count { font-weight:600; color:#283645; }
     .vws-btn { border:0; border-radius:5px; padding:8px 17px; font-weight:600; cursor:pointer; }
     .vws-btn-light { color:#334155; background:#e8edf3; }
     .vws-btn-light:hover { background:#dce4ed; }
     .vws-table-wrap { position:relative; width:100%; overflow:hidden; }
     .vws-loader { display:none; position:absolute; inset:0; z-index:20; background:rgba(255,255,255,.78); align-items:center; justify-content:center; font-weight:600; color:#245f9e; }
     .vws-loader.show { display:flex; }
     .vws-message { display:none; margin-bottom:14px; padding:10px 14px; border-radius:5px; font-weight:600; }
     .vws-message.error { display:block; color:#8a2830; background:#fdecee; border:1px solid #efc2c7; }

     .dataTables_wrapper { width:100%; font-size:13px; color:#344258; }
     .dataTables_wrapper .dataTables_filter { float:right; margin:0 0 14px; }
     .dataTables_wrapper .dataTables_filter label { display:flex; align-items:center; gap:8px; font-weight:500; color:#344258; }
     .dataTables_wrapper .dataTables_filter input { width:225px; height:38px; margin-left:0; padding:6px 11px; border:1px solid #ccd7e3; border-radius:18px; background:#fff; outline:none; }
     .dataTables_wrapper .dataTables_filter input:focus { border-color:#2c70ad; box-shadow:0 0 0 2px rgba(44,112,173,.12); }
     table.dataTable { width:100% !important; margin:0 !important; border-collapse:separate !important; border-spacing:0; border:1px solid #d8e1ea; border-radius:7px; overflow:hidden; }
     table.dataTable thead th { padding:12px 14px !important; white-space:nowrap; color:#173c62; background:#eaf2f9; border-right:1px solid #d4dee8 !important; border-bottom:1px solid #cbd7e3 !important; font-weight:700; }
     table.dataTable tbody td { padding:11px 14px !important; white-space:nowrap; border-right:1px solid #e2e8ef; border-bottom:1px solid #e2e8ef; vertical-align:middle; }
     table.dataTable tbody tr:nth-child(even) { background:#f8fafc; }
     table.dataTable tbody tr:hover { background:#eef5fb; }
     table.dataTable.no-footer { border-bottom:1px solid #d8e1ea; }
     div.dataTables_scrollHead table.dataTable { border-bottom-left-radius:0; border-bottom-right-radius:0; }
     div.dataTables_scrollBody table.dataTable { border-top:0; border-top-left-radius:0; border-top-right-radius:0; }

     .vws-edit { display:inline-flex; align-items:center; justify-content:center; width:31px; height:31px; padding:0; border:1px solid #bdd0e2; border-radius:5px; color:#1f619c; background:#eef6fc; cursor:pointer; }
     .vws-edit:hover { color:#fff; background:#245f9e; border-color:#245f9e; }
     .vws-edit svg { width:16px; height:16px; fill:currentColor; }
     .status-pill { display:inline-block; min-width:72px; padding:4px 10px; border-radius:14px; text-align:center; font-size:12px; font-weight:700; }
     .status-pending { color:#8a5b00; background:#fff4cf; }
     .status-completed { color:#1f683b; background:#e6f5eb; }

     @media (max-width:1100px) { .vws-summary { grid-template-columns:repeat(2,minmax(170px,1fr)); } }
     @media (max-width:650px) { .vws-page { padding:10px; } .vws-summary { grid-template-columns:1fr; } .erp-hero { padding:15px; } .dataTables_wrapper .dataTables_filter { float:none; } .dataTables_wrapper .dataTables_filter input { width:100%; } }
 </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <div class="vws-page">
     <div class="erp-hero">
         <div>
             <h1>Vendor Wise Project Summary</h1>
             <div class="erp-breadcrumb">Vendor Billing <span>/</span> Vendor Wise Project Summary</div>
         </div>
         <button id="btnBack" type="button" class="vws-btn vws-btn-light">Back</button>
     </div>

     <div id="messageBox" class="vws-message"></div>

     <div class="vws-panel">
         <div class="vws-panel-title">Billing Summary</div>
         <div class="vws-panel-body">
             <div class="vws-summary">
                 <div class="vws-card"><div class="vws-card-label">Vendor Code</div><div id="vendorCode" class="vws-card-value">-</div></div>
                 <div class="vws-card"><div class="vws-card-label">No. of Projects</div><div id="projectCount" class="vws-card-value">0</div></div>
                 <div class="vws-card"><div class="vws-card-label">Total Files</div><div id="totalFiles" class="vws-card-value">0</div></div>
                 <div class="vws-card"><div class="vws-card-label">Verified Files</div><div id="verifiedFiles" class="vws-card-value">0</div></div>
                 <div class="vws-card"><div class="vws-card-label">Unverified Files</div><div id="unverifiedFiles" class="vws-card-value">0</div></div>
                 <div class="vws-card"><div class="vws-card-label">Total Cost</div><div id="totalCost" class="vws-card-value">0</div></div>
                 <div class="vws-card"><div class="vws-card-label">Status</div><div id="status" class="vws-card-value">-</div></div>
             </div>
         </div>
     </div>

     <div class="vws-panel">
         <div class="vws-panel-title">
             <span>Project Details</span>
             <span class="vws-count">Total Count: <span id="rowCount">0</span></span>
         </div>
         <div class="vws-panel-body">
             <div class="vws-table-wrap">
                 <div id="gridLoader" class="vws-loader">Loading...</div>
                 <table id="projectTable" class="display nowrap" style="width:100%">
                     <thead>
                         <tr>
                             <th>Sr. #</th>
                             <th>Project Name</th>
                             <%--<th>Project Name</th>--%>
                             <th>Total Files</th>
                             <th>Verified Files</th>
                             <th>Unverified Files</th>
                             <th>Calculated Cost</th>
                             <th>Status</th>
                             <th>Action</th>
                         </tr>
                     </thead>
                     <tbody></tbody>
                 </table>
             </div>
         </div>
     </div>
 </div>

 <script src="<%= ResolveUrl("~/Scripts/jquery-3.6.0.min.js") %>"></script>
 <script src="<%= ResolveUrl("~/Scripts/DataTables/jquery.dataTables.min.js") %>"></script>
 <script type="text/javascript">
     var projectTable;
     var pageUrl = '<%= ResolveUrl("~/Vendor/ProjectWiseSummary.aspx") %>';
     var backUrl = '<%= ResolveUrl("~/Vendor/VendorBillingGeneratePeriod.aspx") %>';
     var fileListUrl = '<%= ResolveUrl("~/Vendor/ProjectWiseFileList.aspx") %>';
     var vendorCode = getQueryString('VendorCode') || getQueryString('vendorCode') || '';
     var invoiceId = parseInt(getQueryString('InvoiceId') || '0', 10);
     var pageStatus = getQueryString('Status') || '';

     $(function () {
         projectTable = $('#projectTable').DataTable({
             paging: false,
             searching: true,
             info: false,
             ordering: true,
             scrollX: true,
             scrollY: '55vh',
             scrollCollapse: true,
             autoWidth: false,
             columnDefs: [
                 { orderable: false, targets: [0, 7] },
                 { className: 'dt-center', targets: [0, 7] }
             ],
             language: { emptyTable: 'No project records found' }
         });

         $('#btnBack').on('click', function () { window.location.href = backUrl; });
         $('#projectTable tbody').on('click', '.js-edit', function () {
             var row = projectTable.row($(this).closest('tr')).data();
             openProjectFiles(row);
         });

         loadData();
     });

     function loadData() {
         if (!vendorCode || !invoiceId) {
             showMessage('Vendor Code and Invoice ID are required.');
             return;
         }

         showLoader(true);
         callPageMethod('GetSummary', { vendorCode: vendorCode, invoiceId: invoiceId, status: pageStatus })
             .done(function (response) {
                 var result = unwrap(response);
                 if (!result || !result.Success) {
                     showMessage(result ? result.Message : 'Unable to load project details.');
                     return;
                 }
                 bindSummary(result.Data.Summary || {});
                 bindGrid(result.Data.Rows || []);
             })
             .fail(showAjaxError)
             .always(function () { showLoader(false); });
     }

     function bindSummary(summary) {
         $('#vendorCode').text(summary.VendorCode || vendorCode || '-');
         $('#projectCount').text(summary.NoOfProjects || 0);
         $('#totalFiles').text(formatNumber(summary.TotalFiles));
         $('#verifiedFiles').text(formatNumber(summary.VerifiedFiles));
         $('#unverifiedFiles').text(formatNumber(summary.UnverifiedFiles));
         $('#totalCost').text(formatAmount(summary.TotalCost));
         $('#status').html(statusHtml(summary.Status || pageStatus));
     }

     function bindGrid(rows) {
         projectTable.clear();
         $.each(rows, function (i, row) {
             var projectNumber = valAny(row, ['projectnumber', 'ProjectNumber', 'Project No', 'ProjectNo']);
             var verified = valAny(row, ['VarifiedFiles', 'VerifiedFiles']);
             var unverified = valAny(row, ['UnVarifiedFiles', 'UnVerifiedFiles']);
             var status = val(row, 'Status') || pageStatus;

             projectTable.row.add([
                 i + 1,
                 projectNumber,
                 
                 formatNumber(val(row, 'TotalFiles')),
                 formatNumber(verified),
                 formatNumber(unverified),
                 formatAmount(valAny(row, ['Total Cost', 'CalculatedCost', 'TotalCost'])),
                 statusHtml(status),
                 editButton()
             ]);
         });
         projectTable.draw(false);
         $('#rowCount').text(rows.length);
         setTimeout(function () { projectTable.columns.adjust(); }, 100);
     }

     function openProjectFiles(row) {
         window.location.href = fileListUrl + '?' + $.param({
             VendorCode: vendorCode,
             InvoiceId: invoiceId,
             ProjectNumber: row[1],
             VerifiedFiles: stripHtml(row[4]),
             UnVerifiedFiles: stripHtml(row[5]),
             Status: stripHtml(row[7])
         });
     }

     function editButton() {
         return '<button type="button" class="vws-edit js-edit" title="View/Edit Project Files" aria-label="View/Edit Project Files">' +
             '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zm17.71-10.04a.996.996 0 0 0 0-1.41l-2.5-2.5a.996.996 0 0 0-1.41 0l-1.96 1.96 3.75 3.75 2.12-1.8z"/></svg>' +
             '</button>';
     }

     function statusHtml(value) {
         value = value == null ? '' : String(value);
         var css = value.toLowerCase() === 'completed' ? 'status-completed' : 'status-pending';
         return '<span class="status-pill ' + css + '">' + escapeHtml(value || '-') + '</span>';
     }

     function callPageMethod(method, data) {
         return $.ajax({ type:'POST', url:pageUrl + '/' + method, data:JSON.stringify(data), contentType:'application/json; charset=utf-8', dataType:'json' });
     }
     function unwrap(response) { return response && response.d ? response.d : response; }
     function val(row, key) { return row && row[key] != null ? row[key] : ''; }
     function valAny(row, keys) { for (var i=0;i<keys.length;i++) if (row && row[keys[i]] != null) return row[keys[i]]; return ''; }
     function getQueryString(name) { var p = new URLSearchParams(window.location.search); return p.get(name); }
     function formatNumber(value) { var n = parseInt(value || 0, 10); return isNaN(n) ? 0 : n.toLocaleString('en-IN'); }
     function formatAmount(value) { var n = parseFloat(value || 0); return isNaN(n) ? '0.00' : n.toLocaleString('en-IN', { minimumFractionDigits:2, maximumFractionDigits:2 }); }
     function stripHtml(value) { return $('<div/>').html(value == null ? '' : value).text(); }
     function escapeHtml(value) { return $('<div/>').text(value == null ? '' : value).html(); }
     function showLoader(show) { $('#gridLoader').toggleClass('show', show); }
     function showMessage(message) { $('#messageBox').removeClass('error').addClass('error').text(message).show(); }
     function showAjaxError(xhr) { var msg='Unable to complete the request.'; if (xhr.responseJSON && xhr.responseJSON.Message) msg=xhr.responseJSON.Message; else if (xhr.status) msg='Request failed. HTTP ' + xhr.status + ' - ' + xhr.statusText; showMessage(msg); }
 </script>
</asp:Content>
