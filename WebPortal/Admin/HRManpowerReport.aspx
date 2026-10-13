<%@ Page Title="HR Manpower Report" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="HRManpowerReport.aspx.cs" Inherits="WebPortal.Admin.HRManpowerReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .hrmr { color:#243041; font-family:Bahnschrift,Arial,sans-serif; }
        .hrmr-shell { max-width:1480px; margin:0 auto; }
        .hrmr-head,.hrmr-panel,.hrmr-kpi { background:#fff; border:1px solid #e5e9f0; border-radius:8px; box-shadow:0 6px 18px rgba(35,48,65,.05); }
        .hrmr-head { padding:20px 28px; margin-bottom:14px; color:#fff; background:linear-gradient(105deg,#244edb 0%,#2879ed 61%,#37c3d3 100%); border-color:rgba(255,255,255,.22); border-radius:16px; }
        .hrmr-title { margin:0; font-size:24px; font-weight:700; color:#fff; }
        .hrmr-subtitle { margin:4px 0 0; color:rgba(255,255,255,.88); }
        .hrmr-tabs { display:flex; gap:4px; border-bottom:1px solid #dfe5ee; margin-bottom:14px; overflow-x:auto; }
        .hrmr-tab { border:0; background:transparent; padding:12px 16px; font-weight:700; color:#667085; white-space:nowrap; }
        .hrmr-tab.active { color:#244edb; border-bottom:3px solid #2879ed; }
        .hrmr-tab.future { opacity:.65; cursor:not-allowed; }
        .hrmr-sheet-tabs { display:flex; gap:4px; margin:0 0 14px; overflow-x:auto; }
        .hrmr-sheet-tab { border:1px solid #d8dee8; background:#fff; padding:9px 13px; border-radius:6px; font-weight:700; color:#475467; white-space:nowrap; }
        .hrmr-sheet-tab.active { background:#2879ed; border-color:#2879ed; color:#fff; }
        .hrmr-view { display:none; }
        .hrmr-view.active { display:block; }
        .hrmr-filter { padding:14px; margin-bottom:14px; }
        .hrmr-filter-grid { display:grid; grid-template-columns:repeat(4,minmax(150px,1fr)) auto auto; gap:10px; align-items:end; }
        .hrmr-filter label { display:block; color:#475467; font-size:12px; font-weight:700; margin-bottom:4px; }
        .hrmr-filter .form-control,.hrmr-btn { height:38px; border-radius:6px; font-size:13px; }
        .hrmr-btn { padding:0 14px; font-weight:700; }
        .hrmr-kpis { display:grid; grid-template-columns:repeat(7,1fr); gap:0; margin-bottom:14px; overflow:hidden; }
        .hrmr-kpi { border:0; border-right:1px solid #edf0f4; border-radius:0; padding:14px 16px; box-shadow:none; }
        .hrmr-kpi:last-child { border-right:0; }
        .hrmr-kpi span { display:block; color:#667085; font-size:12px; }
        .hrmr-kpi strong { display:block; margin-top:4px; color:#182334; font-size:25px; }
        .hrmr-toolbar { display:flex; justify-content:space-between; gap:10px; padding:13px 15px; border-bottom:1px solid #eef1f6; align-items:center; flex-wrap:wrap; }
        .hrmr-toolbar h2 { margin:0; font-size:17px; font-weight:700; }
        .hrmr-table { margin:0; font-size:13px; }
        .hrmr-table thead th { background:#f5f7fb; color:#344054; border-bottom:1px solid #dfe5ee; white-space:nowrap; }
        .hrmr-table td { vertical-align:middle; }
        .hrmr-table thead .part-location,.hrmr-table thead .part-active,.hrmr-table thead .part-exit,.hrmr-table thead .part-trend { background:#244edb; color:#fff; text-align:center; }
        .hrmr-table thead .column-head th { background:#2879ed; color:#fff; text-align:center; vertical-align:middle; }
        .hrmr-total { font-weight:800; background:#eefaf7; }
        .hrmr-muted { color:#667085; }
        .hrmr-empty { padding:40px; text-align:center; color:#667085; }
        .hrmr-badge { padding:3px 8px; border-radius:999px; background:#eef9f8; color:#0f766e; font-weight:700; }
        @media(max-width:1000px){.hrmr-filter-grid{grid-template-columns:repeat(2,1fr)}.hrmr-kpis{grid-template-columns:repeat(2,1fr)}}
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="hrmr"><div class="hrmr-shell">
        <header class="hrmr-head">
            <h1 class="hrmr-title">HR Reports</h1>
            <p class="hrmr-subtitle">A modular workspace for manpower and future HR reporting areas.</p>
        </header>

        <nav class="hrmr-tabs" aria-label="HR report sections">
            <button type="button" class="hrmr-tab active" data-tab="manpower">Manpower</button>
            <button type="button" class="hrmr-tab future" title="Reserved for a future report">Skip Level <small>(Coming soon)</small></button>
            <button type="button" class="hrmr-tab future" title="Reserved for a future report">Other Activities <small>(Coming soon)</small></button>
            <button type="button" class="hrmr-tab future" title="Reserved for a future report">Social Media <small>(Coming soon)</small></button>
        </nav>

        <section id="manpowerTab">
            <div class="hrmr-panel hrmr-filter">
                <div class="hrmr-filter-grid">
                    <div><label for="hrmrLocation">Location</label><select id="hrmrLocation" class="form-control"><option value="">All Locations</option></select></div>
                    <div><label for="hrmrDomain">Domain</label><select id="hrmrDomain" class="form-control"><option value="">All Domains</option></select></div>
                    <div><label for="hrmrMonth">Month / Year</label><input id="hrmrMonth" type="month" class="form-control" /></div>
                    <div><label for="hrmrSearch">Search</label><input id="hrmrSearch" class="form-control" placeholder="Location or domain" /></div>
                    <button id="hrmrApply" type="button" class="btn btn-primary hrmr-btn">Apply</button>
                    <button id="hrmrReset" type="button" class="btn btn-outline-secondary hrmr-btn">Reset</button>
                </div>
            </div>

            <div class="hrmr-kpis">
                <div class="hrmr-kpi"><span>Total Employees</span><strong id="hrmrTotal">0</strong></div>
                <div class="hrmr-kpi"><span>On Floor</span><strong id="hrmrOnFloor">0</strong></div>
                <div class="hrmr-kpi"><span>Resigned</span><strong id="hrmrResigned">0</strong></div>
                <div class="hrmr-kpi"><span>Absconding</span><strong id="hrmrAbsconding">0</strong></div>
                <div class="hrmr-kpi"><span>Work From Home</span><strong id="hrmrWfh">0</strong></div>
                <div class="hrmr-kpi"><span>Work From Office</span><strong id="hrmrWfo">0</strong></div>
                <div class="hrmr-kpi"><span>Attrition</span><strong id="hrmrAttrition">0%</strong></div>
            </div>

            <div class="hrmr-sheet-tabs" role="tablist">
                <button type="button" class="hrmr-sheet-tab active" data-view="location">Location Wise</button>
                <button type="button" class="hrmr-sheet-tab" data-view="domain">Domain Wise</button>
                <button type="button" class="hrmr-sheet-tab" data-view="tenure">Employee Tenure</button>
                <button type="button" class="hrmr-sheet-tab" data-view="domain-tenure">Domain Wise Employee Tenure</button>
                <button type="button" class="hrmr-sheet-tab" data-view="month">Month Wise Manpower</button>
                <button type="button" class="hrmr-sheet-tab" data-view="current">Current Manpower</button>
            </div>

            <div id="hrmr-view-location" class="hrmr-panel hrmr-view active">
                <div class="hrmr-toolbar">
                    <div><h2>Location Wise Employee Dashboard</h2><span id="hrmrResultText" class="hrmr-muted">Loading manpower data...</span></div>
                    <button id="hrmrExport" type="button" class="btn btn-outline-primary btn-sm">Export current view</button>
                </div>
                <div class="table-responsive">
                    <table class="table table-bordered table-hover hrmr-table">
                        <thead>
                            <tr><th colspan="2" class="part-location">LOCATION / PART</th><th colspan="7" class="part-active">PART 1: ACTIVE &amp; PRODUCTIVITY MANPOWER BREAKDOWN</th><th colspan="3" class="part-exit">PART 2: EXIT &amp; DROP OUT BREAKDOWN</th><th colspan="5" class="part-trend">PART 3: ATTRITION &amp; COMPARATIVE TRENDS</th></tr>
                            <tr class="column-head"><th>Month/Year</th><th>Location</th><th>WFH</th><th>WFO</th><th>Total<br/>Employees</th><th>Productive<br/>Employees</th><th>Non-Productive<br/>Employees</th><th>On Leave</th><th>Notice<br/>Period</th><th>Absconded</th><th>Left / Exit<br/>Recorded</th><th>Total<br/>Drop Out</th><th>Attrition<br/>Rate</th><th>Prev. Month<br/>Drop Out</th><th>Prev. Month<br/>Attrition</th><th>Attrition<br/>Trend</th><th>Status</th></tr>
                        </thead>
                        <tbody id="hrmrBody"><tr><td colspan="17" class="hrmr-empty">Loading manpower data</td></tr></tbody>
                    </table>
                </div>
            </div>

            <div id="hrmr-view-domain" class="hrmr-panel hrmr-view"><div class="hrmr-toolbar"><h2>Domain Wise Manpower Summary</h2></div><div id="hrmrDomainTable" class="table-responsive"></div></div>
            <div id="hrmr-view-tenure" class="hrmr-panel hrmr-view"><div class="hrmr-toolbar"><h2>Employee Tenure Wise Dashboard</h2></div><div class="table-responsive"><table class="table table-bordered hrmr-table"><thead><tr><th colspan="2" class="part-location">LOCATION / PART</th><th colspan="7" class="part-active">ACTIVE EMPLOYEES BY TENURE / WORK MODE</th><th colspan="5" class="part-exit">DROP OUT / EXIT BY TENURE</th></tr><tr class="column-head"><th>Month/Year</th><th>Location</th><th>WFH</th><th>WFO</th><th>Total Employees</th><th>Less Than 6 Months</th><th>6M - 1 Year</th><th>1 Year - 2 Years</th><th>Above 2 Years</th><th>Less Than 6 Months</th><th>6M - 1 Year</th><th>1 Year - 2 Years</th><th>Above 2 Years</th><th>Total Drop Out</th></tr></thead><tbody id="hrmrTenureBody"></tbody></table></div></div>
            <div id="hrmr-view-domain-tenure" class="hrmr-panel hrmr-view"><div class="hrmr-toolbar"><h2>Domain Wise Employee Tenure</h2></div><div id="hrmrDomainTenureTable" class="table-responsive"></div></div>
            <div id="hrmr-view-month" class="hrmr-panel hrmr-view"><div class="hrmr-toolbar"><h2>Month Wise Summary</h2></div><div id="hrmrMonthTable" class="table-responsive"></div></div>
            <div id="hrmr-view-current" class="hrmr-panel hrmr-view"><div class="hrmr-toolbar"><h2>Current Manpower</h2></div><div class="table-responsive"><table class="table table-bordered hrmr-table"><thead><tr class="column-head"><th>Sr No</th><th>Branch</th><th>Department</th><th>Emp Code</th><th>Emp Full Name</th><th>Emp Pseudo Name</th><th>Gender</th><th>Designation</th><th>Joining Date</th><th>Date Of Birth</th><th>Last Login Date</th><th>Domain</th><th>Subdomain</th><th>Reporting Manager</th><th>Domain Head</th><th>Location Head</th><th>Employee Status</th><th>Work Mode</th><th>Resignation Date</th><th>Last Working Date</th><th>Attendance Percent</th><th>Total Leave</th><th>Remark</th></tr></thead><tbody id="hrmrCurrentBody"></tbody></table></div></div>
        </section>
    </div></div>

    <script>
        var hrmrRows = [], hrmrDetails = [], hrmrDomainRows = [], hrmrVisible = [];
        $(function(){
            $.ajax({url:'HRManpowerReport.aspx/GetManpowerData',type:'POST',data:'{}',contentType:'application/json; charset=utf-8',dataType:'json'})
                .done(function(r){ var x=JSON.parse(r.d||'{}'); hrmrRows=x.Rows||[]; hrmrDetails=x.Details||[]; bindFilters(); render(); })
                .fail(function(){ $('#hrmrBody').html('<tr><td colspan="17" class="hrmr-empty">Unable to load manpower data.</td></tr>'); });
            var now=new Date(); $('#hrmrMonth').val(now.getFullYear()+'-'+String(now.getMonth()+1).padStart(2,'0'));
            $('#hrmrApply').on('click',render); $('#hrmrReset').on('click',function(){ $('#hrmrLocation,#hrmrDomain').val(''); $('#hrmrSearch').val(''); render(); });
            $('#hrmrSearch').on('keyup',function(e){ if(e.keyCode===13) render(); });
            $('#hrmrExport').on('click',exportCsv);
            $('.hrmr-sheet-tab').on('click',function(){var view=$(this).data('view');$('.hrmr-sheet-tab').removeClass('active');$(this).addClass('active');$('.hrmr-view').removeClass('active');$('#hrmr-view-'+view).addClass('active');if(view==='domain')loadDomainWise();if(view==='month')loadMonthwise();});
        });
        function value(row,names){ for(var i=0;i<names.length;i++){ if(row[names[i]]!==undefined&&row[names[i]]!==null) return row[names[i]]; } return ''; }
        function number(row,names){ var n=parseFloat(value(row,names)); return isNaN(n)?0:n; }
        function locationOf(r){ return String(value(r,['BranchName','Location','Branch'])||'Unassigned'); }
        function domainOf(r){ return String(value(r,['DomainGroupName','DomainName','Domain'])||'Unassigned'); }
        function modeOf(r){var m=String(value(r,['JobType','WorkMode','WorkingMode','WorkLocation','AttendanceMode','WorkType'])||'').toLowerCase();return m==='wfh'||m.indexOf('home')>=0?'WFH':(m==='wfo'||m.indexOf('office')>=0?'WFO':'');}
        function bindFilters(){fill('#hrmrLocation',unique(hrmrRows.map(locationOf).concat(hrmrDetails.map(locationOf))),'All Locations');fill('#hrmrDomain',unique(hrmrRows.map(domainOf).concat(hrmrDetails.map(domainOf))),'All Domains');}
        function unique(a){ return a.filter(function(v,i){return v&&a.indexOf(v)===i;}).sort(); }
        function fill(id,items,label){ var e=$(id).empty().append($('<option/>').val('').text(label)); $.each(items,function(_,x){e.append($('<option/>').val(x).text(x));}); }
        function filtered(){ var l=$('#hrmrLocation').val(),d=$('#hrmrDomain').val(),q=$.trim($('#hrmrSearch').val()).toLowerCase(); return hrmrRows.filter(function(r){return (!l||locationOf(r)===l)&&(!d||domainOf(r)===d)&&(!q||(locationOf(r)+' '+domainOf(r)).toLowerCase().indexOf(q)>=0);}); }
        function detailsFiltered(){var l=$('#hrmrLocation').val(),d=$('#hrmrDomain').val(),q=$.trim($('#hrmrSearch').val()).toLowerCase();return hrmrDetails.filter(function(r){return(!l||locationOf(r)===l)&&(!d||domainOf(r)===d)&&(!q||(locationOf(r)+' '+domainOf(r)+' '+value(r,['EmpFullName','EmployeeName','EmpName'])).toLowerCase().indexOf(q)>=0);});}
        function totals(rows){var x={Total:0,OnFloor:0,Resigned:0,Absconding:0,WFH:0,WFO:0,Leaves:0};$.each(rows,function(_,r){x.Total+=number(r,['Total']);x.OnFloor+=number(r,['OnFloor']);x.Resigned+=number(r,['Resigned']);x.Absconding+=number(r,['Absconding']);x.WFH+=number(r,['WorkFromHome','WFH']);x.WFO+=number(r,['WorkFromOffice','WFO']);x.Leaves+=number(r,['ApprovedLeaves','Leaves']);});return x;}
        function addModes(x,location,domain){var ds=detailsFiltered().filter(function(r){return !isExit(r)&&(!location||locationOf(r)===location)&&(!domain||domainOf(r)===domain);});x.WFH=ds.filter(function(r){return modeOf(r)==='WFH';}).length;x.WFO=ds.filter(function(r){return modeOf(r)==='WFO';}).length;x.Total=x.WFH+x.WFO;x.Leaves=totals(ds).Leaves;return x;}
        function pct(x){ return x.Total?((x.Resigned+x.Absconding)*100/x.Total).toFixed(2)+'%':'0.00%'; }
        function monthLabel(){var v=$('#hrmrMonth').val();if(!v)return 'Current';var p=v.split('-');return new Date(+p[0],+p[1]-1,1).toLocaleString('en',{month:'long',year:'numeric'});}
        function reportRow(label,x,totalRow){var drop=x.Resigned+x.Absconding,rate=pct(x),trend=x.Total?((drop*100/x.Total).toFixed(2)+'%'):'0.00%';return '<tr class="'+(totalRow?'hrmr-total':'')+'"><td>'+escapeHtml(totalRow?'Total / Average':monthLabel())+'</td><td>'+escapeHtml(label)+'</td><td>'+x.WFH+'</td><td>'+x.WFO+'</td><td>'+x.Total+'</td><td>'+x.OnFloor+'</td><td>'+Math.max(0,x.Total-x.OnFloor-x.Resigned-x.Absconding)+'</td><td>'+x.Leaves+'</td><td>0</td><td>'+x.Absconding+'</td><td>'+x.Resigned+'</td><td>'+drop+'</td><td>'+rate+'</td><td>0</td><td>0.00%</td><td>'+trend+'</td><td>'+(drop?'Increase':'Decrease')+'</td></tr>';}
        function render(){hrmrVisible=filtered();var all=addModes(totals(hrmrVisible),'','');$('#hrmrTotal').text(all.Total);$('#hrmrOnFloor').text(all.OnFloor);$('#hrmrResigned').text(all.Resigned);$('#hrmrAbsconding').text(all.Absconding);$('#hrmrWfh').text(all.WFH);$('#hrmrWfo').text(all.WFO);$('#hrmrAttrition').text(pct(all));var groups={},html='';$.each(hrmrVisible,function(_,r){var k=locationOf(r);(groups[k]=groups[k]||[]).push(r);});$.each(Object.keys(groups).sort(),function(_,k){html+=reportRow(k,addModes(totals(groups[k]),k,''),false);});if(html)html+=reportRow('',all,true);$('#hrmrBody').html(html||'<tr><td colspan="17" class="hrmr-empty">No manpower records match the selected filters.</td></tr>');$('#hrmrResultText').text(Object.keys(groups).length+' locations - '+monthLabel());renderOtherSheets();}
        function renderOtherSheets(){safeRender(renderDomainSheet,'#hrmrDomainTable');safeRender(renderTenureSheet,'#hrmrTenureBody');safeRender(renderDomainTenureSheet,'#hrmrDomainTenureTable');safeRender(renderCurrentSheet,'#hrmrCurrentBody');if($('#hrmr-view-month').hasClass('active')) loadMonthwise();}
        function safeRender(fn,target){try{fn();}catch(e){$(target).html('<tr><td class="hrmr-empty">Unable to render report: '+escapeHtml(e.message||e)+'</td></tr>');}}
        function locations(){return unique(filtered().map(locationOf));}
        function domains(){return unique(filtered().map(domainOf));}
        function subset(domain,location){return filtered().filter(function(r){return(!domain||domainOf(r)===domain)&&(!location||locationOf(r)===location);});}
        function renderDomainSheet(){var data=hrmrDomainRows,l=$('#hrmrLocation').val(),dFilter=$('#hrmrDomain').val();if(l)data=data.filter(function(r){return r.Location===l;});if(dFilter)data=data.filter(function(r){return r.Domain===dFilter;});var ls=unique(data.map(function(r){return String(r.Location);})),ds=unique(data.map(function(r){return String(r.Domain);})),head='<tr><th rowspan="2" class="part-location">Month</th><th rowspan="2" class="part-location">Year</th><th rowspan="2" class="part-location">Domain</th>';$.each(ls,function(_,loc){head+='<th colspan="7" class="part-active">'+escapeHtml(loc)+'</th>';});head+='</tr><tr class="column-head">';$.each(ls,function(){head+='<th>WFH</th><th>WFO</th><th>Total Emp.</th><th>Total Leaves</th><th>Absconded</th><th>Left / Exit</th><th>Attrition</th>';});head+='</tr>';var body='';$.each(ds,function(_,domain){body+='<tr><td>'+monthLabel().split(' ')[0]+'</td><td>'+monthLabel().split(' ')[1]+'</td><td>'+escapeHtml(domain)+'</td>';$.each(ls,function(_,loc){var r=data.filter(function(x){return x.Domain===domain&&x.Location===loc;})[0]||{},wfh=+(r.WFH||0),wfo=+(r.WFO||0),total=wfh+wfo,drop=+(r.Absconded||0)+ +(r.Exited||0);body+='<td>'+wfh+'</td><td>'+wfo+'</td><td>'+total+'</td><td>'+(r.Leaves||0)+'</td><td>'+(r.Absconded||0)+'</td><td>'+(r.Exited||0)+'</td><td>'+(total?(drop*100/total).toFixed(2):'0.00')+'%</td>';});body+='</tr>';});$('#hrmrDomainTable').html('<table class="table table-bordered hrmr-table"><thead>'+head+'</thead><tbody>'+(body||'<tr><td class="hrmr-empty">No domain records found.</td></tr>')+'</tbody></table>');}
        function loadDomainWise(){$('#hrmrDomainTable').html('<div class="hrmr-empty">Loading domain wise records...</div>');$.ajax({url:'HRManpowerReport.aspx/GetDomainWiseManpower',type:'POST',data:'{}',contentType:'application/json; charset=utf-8',dataType:'json',cache:false}).done(function(r){var x=JSON.parse(r.d||'{}');hrmrDomainRows=x.Rows||[];renderDomainSheet();}).fail(function(x){$('#hrmrDomainTable').html('<div class="hrmr-empty">Unable to load domain records: '+escapeHtml((x.responseJSON&&x.responseJSON.Message)||x.statusText)+'</div>');});}
        function dateOf(r,names){var v=value(r,names);if(!v)return null;var s=String(v),m=/\/Date\((\d+)/.exec(s),p=/^(\d{1,2})[-\/]([A-Za-z]{3}|\d{1,2})[-\/](\d{4})/.exec(s),d;if(m)d=new Date(+m[1]);else if(p){var mon=isNaN(p[2])?['jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec'].indexOf(p[2].toLowerCase()):(+p[2]-1);d=new Date(+p[3],mon,+p[1]);}else d=new Date(v);return isNaN(d.getTime())?null:d;}
        function isExit(r){var s=String(value(r,['EmployeeStatus','Status','SubStatus'])||'').toLowerCase(),del=String(value(r,['IsDelete'])||'').toLowerCase();return del==='true'||del==='1'||!!value(r,['ResignationDate','LastWorkingDate'])||s.indexOf('resign')>=0||s.indexOf('left')>=0||s.indexOf('exit')>=0||s.indexOf('abscond')>=0;}
        function tenure(r){var d=dateOf(r,['JoiningDate','DateOfJoining','DOJ']);if(!d)return -1;var end=dateOf(r,['LastWorkingDate','ResignationDate'])||new Date(),m=(end.getFullYear()-d.getFullYear())*12+end.getMonth()-d.getMonth();return m<6?0:(m<12?1:(m<24?2:3));}
        function tenureCounts(rows){var x={active:[0,0,0,0],exit:[0,0,0,0],total:0,wfh:0,wfo:0};$.each(rows,function(_,r){var t=tenure(r),mode=modeOf(r);if(t<0)return;if(isExit(r))x.exit[t]++;else if(mode){x.active[t]++;if(mode==='WFH')x.wfh++;else x.wfo++;}});x.total=x.wfh+x.wfo;return x;}
        function renderTenureSheet(){var ds=detailsFiltered(),groups={},body='';$.each(ds,function(_,r){var k=locationOf(r);(groups[k]=groups[k]||[]).push(r);});$.each(Object.keys(groups).sort(),function(_,k){var x=tenureCounts(groups[k]);body+='<tr><td>'+monthLabel()+'</td><td>'+escapeHtml(k)+'</td><td>'+x.wfh+'</td><td>'+x.wfo+'</td><td>'+x.total+'</td>'+x.active.map(td).join('')+x.exit.map(td).join('')+'<td>'+x.exit.reduce(function(a,b){return a+b;},0)+'</td></tr>';});$('#hrmrTenureBody').html(body||'<tr><td colspan="14" class="hrmr-empty">No tenure records found.</td></tr>');}
        function td(v){return '<td>'+v+'</td>';}
        function renderDomainTenureSheet(){var ds=detailsFiltered(),ls=unique(ds.map(locationOf)),head='<tr><th rowspan="2" class="part-location">Month/Year</th><th rowspan="2" class="part-location">Domain</th>';$.each(ls,function(_,l){head+='<th colspan="9" class="part-active">'+escapeHtml(l)+'</th>';});head+='</tr><tr class="column-head">';$.each(ls,function(){head+='<th>WFH</th><th>WFO</th><th>Total</th><th>&lt;6M</th><th>6M-1Y</th><th>1Y-2Y</th><th>&gt;2Y</th><th>Drop Out</th><th>Attrition</th>';});head+='</tr>';var body='';$.each(unique(ds.map(domainOf)),function(_,d){body+='<tr><td>'+monthLabel()+'</td><td>'+escapeHtml(d)+'</td>';$.each(ls,function(_,l){var x=tenureCounts(ds.filter(function(r){return domainOf(r)===d&&locationOf(r)===l;})),drop=x.exit.reduce(function(a,b){return a+b;},0);body+='<td>'+x.wfh+'</td><td>'+x.wfo+'</td><td>'+x.total+'</td>'+x.active.map(td).join('')+'<td>'+drop+'</td><td>'+(x.total?(drop*100/x.total).toFixed(2):'0.00')+'%</td>';});body+='</tr>';});$('#hrmrDomainTenureTable').html('<table class="table table-bordered hrmr-table"><thead>'+head+'</thead><tbody>'+(body||'<tr><td colspan="'+(2+ls.length*9)+'" class="hrmr-empty">No domain tenure records found.</td></tr>')+'</tbody></table>');}
        function renderCurrentSheet(){var cols=[['BranchName','Branch','Location'],['DepartmentName','Department'],['Code','EmpCode','EmployeeCode'],['FullName','EmpFullName','EmployeeName','EmpName'],['Pseudoname','EmpPseudoName','PseudoName'],['Gender'],['DesignationName','Designation'],['JoiningDate','DateOfJoining','DOJ'],['DateOfBirth','DOB'],['LastLoginDate'],['DomainName','DomainGroupName','Domain'],['Subdomain','SubDomain','SubDomainName'],['ReportingManager','ManagerName'],['DomainHeadName','DomainHead'],['LocationHeadName','LocationHead'],['EmployeeStatus','Status'],['JobType','WorkMode','WorkingMode','WorkLocation','AttendanceMode','WorkType'],['ResignationDate'],['LastWorkingDate'],['AttendancePercent','AttendancePercentage'],['ApprovedLeaves','TotalLeave','TotalLeaves'],['ExitRemark','Remark','Remarks']],body='',n=0;$.each(detailsFiltered(),function(_,r){if(isExit(r))return;n++;body+='<tr><td>'+n+'</td>';$.each(cols,function(_,c){body+='<td>'+escapeHtml(value(r,c))+'</td>';});body+='</tr>';});$('#hrmrCurrentBody').html(body||'<tr><td colspan="23" class="hrmr-empty">No current manpower records found.</td></tr>');}
        function loadMonthwise(){var v=$('#hrmrMonth').val(),p=v?v.split('-'):[],year=p[0]||new Date().getFullYear(),till=+(p[1]||new Date().getMonth()+1);$('#hrmrMonthTable').html('<div class="hrmr-empty">Loading month wise records...</div>');$.ajax({url:'HRManpowerReport.aspx/GetMonthWiseManpower',type:'POST',data:JSON.stringify({Year:String(year),TillMonth:till}),contentType:'application/json; charset=utf-8',dataType:'json'}).done(function(r){var x=JSON.parse(r.d||'{}');renderMonthSheet(x.Rows||[]);}).fail(function(x){$('#hrmrMonthTable').html('<div class="hrmr-empty">Unable to load month wise records: '+escapeHtml((x.responseJSON&&x.responseJSON.Message)||x.statusText)+'</div>');});}
        function renderMonthSheet(rows){var ls=unique(rows.map(function(r){return String(r.Location||'Unassigned');})),head='<tr><th rowspan="2" class="part-location">Month</th><th rowspan="2" class="part-location">Year</th>';$.each(ls,function(_,l){head+='<th colspan="6" class="part-active">'+escapeHtml(l)+'</th>';});head+='</tr><tr class="column-head">';$.each(ls,function(){head+='<th>WFH</th><th>WFO</th><th>Total Emp.</th><th>Total Leaves</th><th>Drop Out / Left</th><th>Attrition Rate</th>';});head+='</tr>';var months=unique(rows.map(function(r){return String(r.MonthNumber).padStart(2,'0')+'|'+r.Month+'|'+r.Year;})),body='';$.each(months,function(_,m){var p=m.split('|');body+='<tr><td>'+escapeHtml(p[1])+'</td><td>'+escapeHtml(p[2])+'</td>';$.each(ls,function(_,l){var found=rows.filter(function(r){return String(r.MonthNumber)===String(+p[0])&&String(r.Location)===l;})[0]||{},wfh=+(found.WorkFromHome||0),wfo=+(found.WorkFromOffice||0);body+='<td>'+wfh+'</td><td>'+wfo+'</td><td>'+(wfh+wfo)+'</td><td>'+(found.Leaves||0)+'</td><td>'+(found.Dropout||0)+'</td><td>'+Number(found.Attrition||0).toFixed(2)+'%</td>';});body+='</tr>';});$('#hrmrMonthTable').html('<table class="table table-bordered hrmr-table"><thead>'+head+'</thead><tbody>'+(body||'<tr><td class="hrmr-empty">No month-wise records found.</td></tr>')+'</tbody></table>');}
        function exportCsv(){ var lines=['Location,Domain,Total,On Floor,Resigned,Absconding,Attrition']; $.each(hrmrVisible,function(_,r){var x=totals([r]);lines.push([locationOf(r),domainOf(r),x.Total,x.OnFloor,x.Resigned,x.Absconding,pct(x)].map(csv).join(','));}); var b=new Blob([lines.join('\r\n')],{type:'text/csv;charset=utf-8;'}),a=document.createElement('a');a.href=URL.createObjectURL(b);a.download='HR_Manpower_Report.csv';a.click();URL.revokeObjectURL(a.href); }
        function csv(v){return '"'+String(v).replace(/"/g,'""')+'"';} function escapeHtml(v){return $('<div/>').text(v).html();}
    </script>
</asp:Content>
