<%@ Page Title="Ticket Report" Language="C#" MasterPageFile="~/IT/Admin.Master" AutoEventWireup="true" CodeBehind="TicketReport.aspx.cs" Inherits="WebPortal.IT.TicketReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root { --tr-primary:#2563eb; --tr-dark:#1d4ed8; --tr-border:#e5e7eb; --tr-text:#0f172a; --tr-muted:#64748b; --tr-shadow:0 18px 45px rgba(15,23,42,.08); }
        .tr-page { background:#f8fafc; min-height:calc(100vh - 90px); padding-bottom:20px; }
        .tr-hero { display:flex; align-items:center; gap:18px; color:#fff; background:linear-gradient(135deg,#2563eb 0%,#7c3aed 58%,#f97316 125%); border-radius:22px; padding:24px 28px; margin-bottom:18px; box-shadow:var(--tr-shadow); }
        .tr-hero-icon { width:52px; height:52px; display:inline-flex; align-items:center; justify-content:center; flex:0 0 52px; border-radius:16px; background:rgba(255,255,255,.18); font-size:22px; }
        .tr-hero h4 { margin:0; font-weight:800; } .tr-hero p { margin:7px 0 0; color:rgba(255,255,255,.86); }
        .tr-panel { background:#fff; border:1px solid var(--tr-border); border-radius:18px; box-shadow:var(--tr-shadow); overflow:hidden; }
        .tr-filter { display:flex; align-items:flex-end; gap:14px; flex-wrap:wrap; padding:20px; border-bottom:1px solid var(--tr-border); }
        .tr-field { min-width:190px; } .tr-field label { display:block; margin-bottom:6px; color:#334155; font-size:12px; font-weight:800; text-transform:uppercase; letter-spacing:.04em; }
        .tr-actions { display:flex; gap:9px; flex-wrap:wrap; } .tr-actions .btn { min-height:38px; border-radius:9px; font-weight:700; }
        .tr-table-wrap { width:100%; overflow-x:auto; padding:20px; }
        #ticketReportTable { width:1550px !important; min-width:1550px; }
        #ticketReportTable thead th { background:#f8fafc !important; color:#334155 !important; font-size:11px; font-weight:800; text-transform:uppercase; letter-spacing:.045em; border:0 !important; border-bottom:1px solid #dbe3ed !important; padding:12px 10px !important; white-space:nowrap; }
        #ticketReportTable thead tr.tr-column-filters th { padding:7px 5px !important; }
        #ticketReportTable thead input { width:100%; min-width:65px; height:30px; padding:4px 7px; border:1px solid #cbd5e1; border-radius:6px; background:#fff; font-size:11px; text-transform:none; letter-spacing:normal; }
        #ticketReportTable tbody td { border:0 !important; border-bottom:1px solid #edf1f5 !important; padding:11px 10px !important; vertical-align:middle; color:#334155; font-size:13px; }
        #ticketReportTable tbody tr:nth-child(even) { background:#fbfdff; } #ticketReportTable tbody tr:hover { background:#f0f7ff; box-shadow:inset 3px 0 0 var(--tr-primary); }
        .tr-view { display:inline-flex; align-items:center; justify-content:center; width:34px; height:34px; border-radius:8px; color:#fff; background:var(--tr-primary); } .tr-view:hover { color:#fff; background:var(--tr-dark); }
        .tr-status { display:inline-flex; border-radius:999px; padding:5px 9px; background:#eef2f6; color:#475467; font-size:11px; font-weight:800; white-space:nowrap; }
        .tr-modal .modal-content { border:0; border-radius:18px; box-shadow:0 24px 70px rgba(15,23,42,.22); overflow:hidden; }
        .tr-modal .modal-header { align-items:center; padding:18px 22px; color:#fff; background:linear-gradient(135deg,var(--tr-primary),#7c3aed); border:0; }
        .tr-modal .modal-title { font-weight:800; } .tr-modal .close { color:#fff; opacity:.85; text-shadow:none; }
        .tr-modal .modal-body { max-height:70vh; overflow-y:auto; padding:22px; background:#f8fafc; }
        .tr-history { position:relative; margin-left:7px; padding-left:28px; }
        .tr-history:before { content:""; position:absolute; top:8px; bottom:8px; left:7px; width:2px; background:#dbeafe; }
        .tr-history-item { position:relative; margin-bottom:16px; padding:16px 18px; background:#fff; border:1px solid var(--tr-border); border-radius:13px; box-shadow:0 5px 16px rgba(15,23,42,.05); }
        .tr-history-item:last-child { margin-bottom:0; } .tr-history-item:before { content:""; position:absolute; left:-28px; top:20px; width:14px; height:14px; border:3px solid #fff; border-radius:50%; background:var(--tr-primary); box-shadow:0 0 0 2px #bfdbfe; }
        .tr-history-meta { display:flex; justify-content:space-between; gap:12px; flex-wrap:wrap; margin-bottom:9px; }
        .tr-history-user { color:var(--tr-text); font-weight:800; } .tr-history-date { color:var(--tr-muted); font-size:12px; }
        .tr-history-remark { color:#334155; line-height:1.55; white-space:pre-wrap; overflow-wrap:anywhere; }
        .tr-history-status { display:inline-flex; margin-top:10px; padding:4px 9px; border-radius:999px; color:#175cd3; background:#dbeafe; font-size:11px; font-weight:800; }
        .tr-history-empty { padding:34px 15px; text-align:center; color:var(--tr-muted); } .tr-history-empty i { display:block; margin-bottom:10px; color:#94a3b8; font-size:30px; }
        .tr-empty { padding:36px !important; text-align:center; color:var(--tr-muted); }
        .loading { align-items:center; background:rgba(255,255,255,.94); border:1px solid #dce5ec; border-radius:8px; box-shadow:0 18px 40px rgba(20,33,45,.18); color:#263747; display:none; font-size:12px; font-weight:700; left:50%; min-width:220px; padding:18px; position:fixed; text-align:center; top:42%; transform:translate(-50%,-50%); z-index:99999; }
        .loading img { display:block; margin:0 auto 10px; max-width:44px; }
        div.dt-buttons { float:none; display:inline-flex; gap:8px; margin-bottom:12px; } div.dt-buttons .btn { border-radius:8px; font-weight:700; }
        @media (max-width:575px) { .tr-hero{padding:20px;} .tr-field{width:100%;} .tr-actions{width:100%;} .tr-actions .btn{flex:1;} .tr-table-wrap{padding:12px;} }
    </style>
    <script type="text/javascript">
        var trTable = null;
        $(document).ready(function () {
            var now = new Date(), first = new Date(now.getFullYear(), now.getMonth(), 1);
            $('#trFromDate').val(trIsoDate(first)); $('#trToDate').val(trIsoDate(now));
            $('#trShow').on('click', trLoad);
            $('#ticketReportTable').on('click', '.tr-view', function () { trShowRemarks($(this).data('ticket-id'), $(this).attr('data-ticket-no')); });
            $('#trReset').on('click', function () { $('#trFromDate,#trToDate').val(''); if (trTable) { trTable.destroy(); trTable=null; } $('#ticketReportTable tbody').html('<tr><td colspan="12" class="tr-empty">Select a date range and click Show Report.</td></tr>'); });
            trLoad();
        });
        function trTwoDigits(value) { return value < 10 ? '0' + value : String(value); }
        function trIsoDate(date) { return date.getFullYear()+'-'+trTwoDigits(date.getMonth()+1)+'-'+trTwoDigits(date.getDate()); }
        function trEscape(value) { return $('<div/>').text(value == null ? '' : value).html(); }
        function trValue(row, names) { for(var i=0;i<names.length;i++){ if(row[names[i]] !== undefined && row[names[i]] !== null) return row[names[i]]; } return ''; }
        function trError(xhr) { var message='Unable to load the ticket report.'; try { var parsed=JSON.parse(xhr.responseText); if(parsed.Message) message=parsed.Message; } catch(e){} alert(message); }
        function trDate(value) { var match=/\/Date\((\d+)\)\//.exec(value || ''); return match ? new Date(parseInt(match[1],10)).toLocaleString() : (value || ''); }
        function trShowRemarks(ticketId, ticketNo) {
            $('#trRemarkTicket').text(ticketNo || ticketId); $('#trRemarkBody').html('<div class="tr-history-empty"><i class="fas fa-spinner fa-spin"></i>Loading remark history...</div>'); $('#trRemarkModal').modal('show');
            $.ajax({ type:'POST', url:'TicketReport.aspx/GetTicketRemarks', data:JSON.stringify({ticketId:parseInt(ticketId,10)}), contentType:'application/json; charset=utf-8', dataType:'json',
                success:function(response){ trRenderRemarks(response && response.d ? JSON.parse(response.d) : []); },
                error:function(xhr){ var message='Unable to load remark history.'; try{var parsed=JSON.parse(xhr.responseText);if(parsed.Message)message=parsed.Message;}catch(e){} $('#trRemarkBody').html('<div class="tr-history-empty"><i class="fas fa-exclamation-circle"></i>'+trEscape(message)+'</div>'); }
            });
        }
        function trRenderRemarks(rows) {
            if(!rows.length){ $('#trRemarkBody').html('<div class="tr-history-empty"><i class="far fa-comment-dots"></i>No remarks have been added to this ticket.</div>'); return; }
            var html='<div class="tr-history">';
            $.each(rows,function(_,r){ var remark=trValue(r,['Remark','Description']), user=trValue(r,['RemarkAddedBy','AddedByName','AddedBy']), date=trDate(trValue(r,['AddedDate','RemarkDate'])), status=trValue(r,['NextState','Status']); html+='<div class="tr-history-item"><div class="tr-history-meta"><span class="tr-history-user"><i class="fas fa-user-circle mr-1"></i>'+trEscape(user || 'System')+'</span><span class="tr-history-date"><i class="far fa-clock mr-1"></i>'+trEscape(date)+'</span></div><div class="tr-history-remark">'+trEscape(remark || 'No description provided.')+'</div>'+(status?'<span class="tr-history-status">'+trEscape(status)+'</span>':'')+'</div>'; });
            $('#trRemarkBody').html(html+'</div>');
        }
        function trLoad() {
            var from=$('#trFromDate').val(), to=$('#trToDate').val();
            if(!from || !to){ alert('Please select From Date and To Date.'); return; }
            if(from > to){ alert('From Date cannot be later than To Date.'); return; }
            $('#load1').show(); $('#trShow').prop('disabled',true);
            $.ajax({ type:'POST', url:'TicketReport.aspx/GetTickets', data:JSON.stringify({fromDate:from,toDate:to}), contentType:'application/json; charset=utf-8', dataType:'json',
                success:function(response){ trRender(response && response.d ? JSON.parse(response.d) : []); },
                error:trError,
                complete:function(){ $('#load1').hide(); $('#trShow').prop('disabled',false); }
            });
        }
        function trRender(rows) {
            if(trTable){ trTable.destroy(); trTable=null; }
            var body=$('#ticketReportTable tbody').empty();
            $.each(rows,function(_,r){
                var id=trValue(r,['TicketId','TicketID']);
                var ticketNo=trValue(r,['TicketNo']);
                body.append('<tr><td><button type="button" class="tr-view border-0" data-ticket-id="'+trEscape(id)+'" data-ticket-no="'+trEscape(ticketNo)+'" title="View remark history"><i class="fas fa-comments"></i></button></td>'+
                    '<td>'+trEscape(trValue(r,['TicketNo']))+'</td><td>'+trEscape(trValue(r,['RequestByName']))+'</td><td>'+trEscape(trValue(r,['RequestDateTime']))+'</td><td>'+trEscape(trValue(r,['RequestName']))+'</td><td>'+trEscape(trValue(r,['Subject']))+'</td><td>'+trEscape(trValue(r,['Description']))+'</td><td><span class="tr-status">'+trEscape(trValue(r,['Status']))+'</span></td><td>'+trEscape(trValue(r,['ClosedByName']))+'</td><td>'+trEscape(trValue(r,['ClosedDate']))+'</td><td>'+trEscape(trValue(r,['ActualTAT']))+'</td></tr>');
            });
            var exportHeaders=['View','Ticket No','Request By','Request Date Time','Request Related To','Subject','Description','Status','Closed By','Closed Date Time','Actual TAT'];
            function trExportOptions(){ return { columns:':not(:first-child)', modifier:{search:'applied',order:'applied',page:'all'}, format:{header:function(data,column){ return exportHeaders[column] || data; }} }; }
            trTable=$('#ticketReportTable').DataTable({ pageLength:25, lengthMenu:[[10,25,50,100,-1],[10,25,50,100,'All']], order:[[3,'desc']], autoWidth:false, scrollX:true, processing:true,
                dom:"<'row mb-2'<'col-sm-12 col-md-6'B><'col-sm-12 col-md-6'f>><'row'<'col-sm-12'tr>><'row mt-2'<'col-sm-12 col-md-5'li><'col-sm-12 col-md-7'p>>",
                buttons:[{extend:'excelHtml5',text:'<i class="fas fa-file-excel"></i> Export Excel',className:'btn btn-success',title:'Departmentwise Ticket Report',exportOptions:trExportOptions()},{extend:'pdfHtml5',text:'<i class="fas fa-file-pdf"></i> Export PDF',className:'btn btn-danger',title:'Departmentwise Ticket Report',orientation:'landscape',pageSize:'A3',exportOptions:trExportOptions()}],
                language:{emptyTable:'No tickets found for the selected date range.'},
                initComplete:function(){ var api=this.api(); api.columns().every(function(index){ if(index===0)return; var column=this,input=$('#ticketReportTable thead tr.tr-column-filters th').eq(index).find('input'); input.off('.tr').on('keyup.tr change.tr',function(){ if(column.search()!==this.value) column.search(this.value).draw(); }); }); }
            });
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1"><img src="../images/Load_1.gif" alt="" /><div>One moment, please . . . .</div></div>
    <div class="tr-page">
        <div class="tr-hero"><span class="tr-hero-icon"><i class="fas fa-chart-bar"></i></span><div><h4>Departmentwise Ticket Report</h4><p>Review tickets raised for your department, closure details and actual turnaround time.</p></div></div>
        <div class="tr-panel">
            <div class="tr-filter">
                <div class="tr-field"><label for="trFromDate">From Date</label><input type="date" id="trFromDate" class="form-control" /></div>
                <div class="tr-field"><label for="trToDate">To Date</label><input type="date" id="trToDate" class="form-control" /></div>
                <div class="tr-actions"><button type="button" id="trShow" class="btn btn-primary"><i class="fas fa-search mr-1"></i> Show Report</button><button type="button" id="trReset" class="btn btn-outline-secondary"><i class="fas fa-undo mr-1"></i> Reset</button></div>
            </div>
            <div class="tr-table-wrap">
                <table class="table" id="ticketReportTable">
                    <thead>
                        <tr><th>View</th><th>Ticket No</th><th>Request By</th><th>Request Date Time</th><th>Request Related To</th><th>Subject</th><th>Description</th><th>Status</th><th>Closed By</th><th>Closed Date Time</th><th>Actual TAT</th></tr>
                        <tr class="tr-column-filters"><th></th><th><input aria-label="Filter Ticket No" /></th><th><input aria-label="Filter Request By" /></th><th><input aria-label="Filter Request Date" /></th><th><input aria-label="Filter Request Related To" /></th><th><input aria-label="Filter Subject" /></th><th><input aria-label="Filter Description" /></th><th><input aria-label="Filter Status" /></th><th><input aria-label="Filter Closed By" /></th><th><input aria-label="Filter Closed Date" /></th><th><input aria-label="Filter Actual TAT" /></th></tr>
                    </thead>
                    <tbody><tr><td colspan="11" class="tr-empty">Loading current month tickets...</td></tr></tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="modal fade tr-modal" id="trRemarkModal" tabindex="-1" role="dialog" aria-labelledby="trRemarkTitle" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered" role="document"><div class="modal-content">
            <div class="modal-header"><h5 class="modal-title" id="trRemarkTitle"><i class="fas fa-comments mr-2"></i>Remark History — Ticket <span id="trRemarkTicket"></span></h5><button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button></div>
            <div class="modal-body" id="trRemarkBody"></div>
            <div class="modal-footer"><button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button></div>
        </div></div>
    </div>
</asp:Content>
