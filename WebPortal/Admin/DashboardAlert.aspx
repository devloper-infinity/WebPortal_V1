<%@ Page Title="Dashboard Alerts" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="DashboardAlert.aspx.cs" Inherits="WebPortal.Admin.DashboardAlert" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root { --da-primary:#2563eb; --da-dark:#0f172a; --da-muted:#64748b; --da-line:#e2e8f0; --da-bg:#f8fafc; }
        .da-page { color:var(--da-dark); }
        .da-hero { display:flex; align-items:center; gap:16px; padding:22px 24px; margin-bottom:20px; border-radius:10px; color:#fff; background:linear-gradient(135deg,#0f172a,#1d4ed8 65%,#06b6d4); box-shadow:0 14px 30px rgba(15,23,42,.18); }
        .da-hero-icon,.da-section-icon { display:flex; align-items:center; justify-content:center; flex:0 0 auto; border-radius:9px; color:#fff; }
        .da-hero-icon { width:54px; height:54px; font-size:25px; background:rgba(255,255,255,.15); border:1px solid rgba(255,255,255,.35); }
        .da-hero h1 { margin:0; font-size:25px; font-weight:800; }
        .da-hero p { margin:5px 0 0; color:rgba(255,255,255,.86); font-size:13px; }
        .da-card { margin-bottom:20px; overflow:hidden; border:1px solid var(--da-line); border-radius:10px; background:#fff; box-shadow:0 8px 24px rgba(15,23,42,.07); }
        .da-card-header { display:flex; align-items:center; justify-content:space-between; gap:12px; padding:16px 18px; border-bottom:1px solid var(--da-line); background:linear-gradient(90deg,#f8fafc,#eff6ff); }
        .da-heading { display:flex; align-items:center; gap:11px; }
        .da-section-icon { width:38px; height:38px; background:linear-gradient(135deg,#2563eb,#0891b2); }
        .da-card-header h2 { margin:0; font-size:17px; font-weight:800; }
        .da-card-header p { margin:3px 0 0; color:var(--da-muted); font-size:12px; }
        .da-body { padding:20px; }
        .da-page label { margin-bottom:6px; color:#334155; font-size:13px; font-weight:700; }
        .da-page .form-control { min-height:40px; border-color:#cbd5e1; border-radius:7px; }
        .da-page .form-control:focus { border-color:var(--da-primary); box-shadow:0 0 0 3px rgba(37,99,235,.12); }
        #daMessage { min-height:115px; resize:vertical; }
        .da-audience { display:none; padding:14px; margin-top:5px; border:1px solid var(--da-line); border-radius:8px; background:var(--da-bg); }
        .da-audience-list { height:205px; overflow:auto; padding:8px; border:1px solid #cbd5e1; border-radius:7px; background:#fff; }
        .da-user { display:flex; align-items:center; gap:8px; padding:7px 8px; margin:0; border-bottom:1px solid #f1f5f9; font-weight:500!important; cursor:pointer; }
        .da-user:last-child { border-bottom:0; }
        .da-user input { margin:0; }
        .da-count { color:var(--da-primary); font-weight:700; }
        .da-actions { display:flex; justify-content:flex-end; gap:10px; margin-top:18px; }
        .da-btn { min-height:40px; padding:9px 17px; border:0; border-radius:7px; font-weight:700; transition:.15s ease; }
        .da-btn:hover { transform:translateY(-1px); }
        .da-btn-primary { color:#fff; background:linear-gradient(135deg,#2563eb,#0891b2); }
        .da-btn-light { color:#334155; background:#e2e8f0; }
        .da-table-wrap { overflow-x:auto; }
        .da-page table.dataTable { width:100%!important; }
        .da-page table.dataTable thead th { white-space:nowrap; color:#334155; background:#f8fafc; border-bottom:2px solid #cbd5e1; }
        .da-message-cell { min-width:240px; max-width:420px; white-space:pre-line; }
        .da-status { display:inline-block; padding:4px 9px; border-radius:999px; font-size:11px; font-weight:800; }
        .da-status-read { color:#166534; background:#dcfce7; }
        .da-status-unread { color:#9a3412; background:#ffedd5; }
        .da-empty { padding:18px; color:var(--da-muted); text-align:center; }
        .da-loading { opacity:.6; pointer-events:none; }
        @media(max-width:767px) { .da-hero{padding:18px}.da-body{padding:15px}.da-actions{flex-direction:column}.da-btn{width:100%} }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="da-page">
        <section class="da-hero">
            <span class="da-hero-icon"><i class="fas fa-bell"></i></span>
            <div><h1>Dashboard Alert Center</h1><p>Create targeted alerts and review delivery/read activity from one place.</p></div>
        </section>

        <section class="da-card">
            <div class="da-card-header">
                <div class="da-heading"><span class="da-section-icon"><i class="fas fa-paper-plane"></i></span><div><h2>Create Alert</h2><p>Compose the message, select its audience, and schedule the effective date.</p></div></div>
            </div>
            <div class="da-body">
                <div class="row">
                    <div class="col-lg-8 form-group"><label for="daSubject">Subject <span class="text-danger">*</span></label><input id="daSubject" class="form-control" maxlength="250" autocomplete="off" /></div>
                    <div class="col-lg-4 form-group"><label for="daEffectiveDate">Effective date <span class="text-danger">*</span></label><input id="daEffectiveDate" type="date" class="form-control" /></div>
                    <div class="col-12 form-group"><label for="daMessage">Alert message <span class="text-danger">*</span></label><textarea id="daMessage" class="form-control" maxlength="4000" placeholder="Enter the alert message"></textarea></div>
                    <div class="col-lg-4 form-group"><label for="daDisplayTo">Display to <span class="text-danger">*</span></label>
                        <select id="daDisplayTo" class="form-control"><option value="">Select audience</option><option value="All">All users</option><option value="Branch wise">Branch wise</option><option value="PMAndAbove">PM and above</option><option value="Senior">Senior management</option></select>
                    </div>
                    <div id="daBranchWrap" class="col-lg-4 form-group" style="display:none"><label for="daBranch">Branch <span class="text-danger">*</span></label><select id="daBranch" class="form-control"><option value="">Select branch</option></select></div>
                    <div class="col-lg-4 form-group"><label for="daAttachment">Attachment <small class="text-muted">(max 5 MB)</small></label><input id="daAttachment" type="file" class="form-control" accept=".pdf,.doc,.docx,.xls,.xlsx,.png,.jpg,.jpeg,.txt,.zip" /></div>
                </div>
                <div id="daAudience" class="da-audience">
                    <div class="d-flex justify-content-between align-items-center mb-2"><label class="mb-0"><input id="daSelectAll" type="checkbox" /> Select all</label><span class="da-count"><span id="daSelectedCount">0</span> selected</span></div>
                    <input id="daUserSearch" class="form-control mb-2" placeholder="Search employee..." />
                    <div id="daAudienceList" class="da-audience-list"><div class="da-empty">Choose an audience to load employees.</div></div>
                </div>
                <div class="da-actions"><button id="daReset" type="button" class="da-btn da-btn-light"><i class="fas fa-undo mr-1"></i>Reset</button><button id="daSubmit" type="button" class="da-btn da-btn-primary"><i class="fas fa-paper-plane mr-1"></i>Publish alert</button></div>
            </div>
        </section>

        <section class="da-card">
            <div class="da-card-header"><div class="da-heading"><span class="da-section-icon"><i class="fas fa-list"></i></span><div><h2>Alert History</h2><p>All dashboard alerts created in the ERP.</p></div></div></div>
            <div class="da-body da-table-wrap"><table id="daAlertTable" class="table table-hover table-bordered"><thead><tr><th>Sr. #</th><th>Subject</th><th>Message</th><th>Effective Date</th><th>Added By</th><th>Added Date</th></tr></thead></table></div>
        </section>

        <section class="da-card">
            <div class="da-card-header"><div class="da-heading"><span class="da-section-icon"><i class="fas fa-chart-bar"></i></span><div><h2>Recipient Report</h2><p>Filter an alert to review delivery, login, and read status.</p></div></div></div>
            <div class="da-body">
                <div class="row align-items-end"><div class="col-lg-8 form-group"><label for="daReportAlert">Alert subject</label><select id="daReportAlert" class="form-control"><option value="">Select alert</option></select></div><div class="col-lg-4 form-group"><button id="daShowReport" type="button" class="da-btn da-btn-primary btn-block"><i class="fas fa-search mr-1"></i>Show report</button></div></div>
                <div class="da-table-wrap"><table id="daReportTable" class="table table-hover table-bordered"><thead><tr><th>Sr. #</th><th>Message To</th><th>Project Manager</th><th>Last Login</th><th>Effective Date</th><th>Added Date</th><th>Read Status</th><th>Read Date</th></tr></thead></table></div>
            </div>
        </section>
    </div>

    <script>
        (function ($) {
            'use strict';
            var alertTable, reportTable, users = [], selectedUsers = {};
            function call(method, data) {
                return $.ajax({ type:'POST', url:'DashboardAlert.aspx/' + method, data:JSON.stringify(data || {}), contentType:'application/json; charset=utf-8', dataType:'json' })
                    .then(function (r) { var value = r.d; return typeof value === 'string' ? JSON.parse(value) : value; });
            }
            function text(value) { return $('<div>').text(value == null ? '' : value).html(); }
            function value(row, names) { for (var i=0;i<names.length;i++) if (row[names[i]] != null) return row[names[i]]; return ''; }
            function notify(icon, title, message) { if (window.Swal) Swal.fire({icon:icon,title:title,text:message}); else alert(message); }
            function errorMessage(xhr) { try { return JSON.parse(xhr.responseText).Message || 'Request failed.'; } catch(e) { return 'Request failed. Please try again.'; } }
            function renderUsers() {
                var q = ($('#daUserSearch').val() || '').toLowerCase(), html = '';
                $.each(users, function (_, u) { if (!q || u.Name.toLowerCase().indexOf(q) >= 0 || u.Code.toLowerCase().indexOf(q) >= 0) html += '<label class="da-user"><input class="da-user-check" type="checkbox" value="' + text(u.EmployeeID) + '"' + (selectedUsers[u.EmployeeID] ? ' checked' : '') + '> <span>' + text((u.Code ? u.Code + ' : ' : '') + u.Name) + '</span></label>'; });
                $('#daAudienceList').html(html || '<div class="da-empty">No employees found.</div>'); updateCount();
            }
            function updateCount() { var total=Object.keys(selectedUsers).length, visible=$('.da-user-check').length, visibleChecked=$('.da-user-check:checked').length; $('#daSelectedCount').text(total); $('#daSelectAll').prop('checked', visible > 0 && visible === visibleChecked); }
            function loadUsers() {
                var type=$('#daDisplayTo').val(), branch=parseInt($('#daBranch').val(),10)||0;
                selectedUsers={};
                if (!type || (type === 'Branch wise' && !branch)) { users=[]; renderUsers(); return; }
                $('#daAudience').show().addClass('da-loading');
                call('GetAudience',{displayTo:type,branchId:branch}).done(function(data){ users=data||[]; renderUsers(); }).fail(function(x){ notify('error','Unable to load employees',errorMessage(x)); }).always(function(){ $('#daAudience').removeClass('da-loading'); });
            }
            function loadBranches() { call('GetBranches').done(function(rows){ var html='<option value="">Select branch</option>'; $.each(rows||[],function(_,r){html+='<option value="'+text(value(r,['BranchId','BranchID']))+'">'+text(value(r,['BranchName','Name']))+'</option>';}); $('#daBranch').html(html); }); }
            function loadAlerts() {
                call('GetAlerts').done(function(rows){
                    if (alertTable) alertTable.destroy();
                    alertTable=$('#daAlertTable').DataTable({data:rows||[],responsive:true,pageLength:10,order:[[5,'desc']],columns:[
                        {data:null,render:function(d,t,r,m){return m.row+1;}},{data:null,render:function(d,t,r){return text(value(r,['Subject']));}},
                        {data:null,className:'da-message-cell',render:function(d,t,r){return text(value(r,['Message']));}},{data:null,render:function(d,t,r){return text(value(r,['EffectiveDate']));}},
                        {data:null,render:function(d,t,r){return text(value(r,['AddedByName','AddedBy']));}},{data:null,render:function(d,t,r){return text(value(r,['AddedDate']));}}
                    ]});
                });
            }
            function loadSubjects() { call('GetAlertSubjects').done(function(rows){var html='<option value="">Select alert</option>';$.each(rows||[],function(_,r){html+='<option value="'+text(value(r,['AlertId','AlertID']))+'">'+text(value(r,['SubjectDetails','Subject']))+'</option>';});$('#daReportAlert').html(html);}); }
            function showReport() {
                var id=parseInt($('#daReportAlert').val(),10); if(!id){notify('warning','Select an alert','Please select an alert subject.');return;}
                call('GetAlertReport',{alertId:id}).done(function(rows){
                    if(reportTable) reportTable.destroy();
                    reportTable=$('#daReportTable').DataTable({data:rows||[],responsive:true,pageLength:20,dom:'Bfrtip',buttons:['excelHtml5','csvHtml5','print'],columns:[
                        {data:null,render:function(d,t,r,m){return m.row+1;}},{data:null,render:function(d,t,r){return text(value(r,['EmpName']));}},
                        {data:null,render:function(d,t,r){return text(value(r,['PMName']));}},{data:null,render:function(d,t,r){return text(value(r,['LatestLoginDate']));}},
                        {data:null,render:function(d,t,r){return text(value(r,['EffectiveDate']));}},{data:null,render:function(d,t,r){return text(value(r,['AddedDate']));}},
                        {data:null,render:function(d,t,r){var s=String(value(r,['ReadFlag'])||'Unread'),read=/^(1|true|read|yes)$/i.test(s);return '<span class="da-status '+(read?'da-status-read':'da-status-unread')+'">'+text(s)+'</span>';}},
                        {data:null,render:function(d,t,r){return text(value(r,['ReadDate']));}}
                    ]});
                }).fail(function(x){notify('error','Unable to load report',errorMessage(x));});
            }
            function resetForm(){ $('#daSubject,#daMessage,#daAttachment,#daUserSearch').val('');$('#daEffectiveDate').val(new Date().toISOString().slice(0,10));$('#daDisplayTo,#daBranch').val('');$('#daBranchWrap,#daAudience').hide();users=[];selectedUsers={};renderUsers(); }
            function publish() {
                var subject=$.trim($('#daSubject').val()),message=$.trim($('#daMessage').val()),date=$('#daEffectiveDate').val(),display=$('#daDisplayTo').val(),ids=Object.keys(selectedUsers),file=$('#daAttachment')[0].files[0];
                if(!subject||!message||!date||!display){notify('warning','Required fields','Complete subject, message, effective date, and audience.');return;}
                if(!ids.length){notify('warning','Select recipients','Select at least one employee.');return;}
                if(file && file.size>5*1024*1024){notify('warning','File too large','Attachment must be 5 MB or smaller.');return;}
                function save(base64){$('#daSubmit').prop('disabled',true);call('SaveAlert',{subject:subject,message:message,effectiveDate:date,displayTo:display,userIds:ids,attachmentName:file?file.name:'',attachmentBase64:base64||''}).done(function(r){if(r.Success){notify('success','Alert published',r.Message);resetForm();loadAlerts();loadSubjects();}else notify('error','Unable to publish',r.Message);}).fail(function(x){notify('error','Unable to publish',errorMessage(x));}).always(function(){$('#daSubmit').prop('disabled',false);});}
                if(file){var reader=new FileReader();reader.onload=function(e){save(String(e.target.result).split(',')[1]||'');};reader.onerror=function(){notify('error','Attachment error','The selected file could not be read.');};reader.readAsDataURL(file);}else save('');
            }
            $(function(){
                $('#daEffectiveDate').val(new Date().toISOString().slice(0,10)); loadBranches(); loadAlerts(); loadSubjects();
                $('#daDisplayTo').on('change',function(){var branch=this.value==='Branch wise';$('#daBranchWrap').toggle(branch);$('#daAudience').toggle(!!this.value&&!branch);if(!branch)loadUsers();else{users=[];renderUsers();}});
                $('#daBranch').on('change',loadUsers);$('#daUserSearch').on('input',renderUsers);$('#daAudienceList').on('change','.da-user-check',function(){if(this.checked)selectedUsers[this.value]=true;else delete selectedUsers[this.value];updateCount();});
                $('#daSelectAll').on('change',function(){var checked=this.checked;$('.da-user-check').each(function(){this.checked=checked;if(checked)selectedUsers[this.value]=true;else delete selectedUsers[this.value];});updateCount();});
                $('#daReset').on('click',resetForm);$('#daSubmit').on('click',publish);$('#daShowReport').on('click',showReport);
            });
        })(jQuery);
    </script>
</asp:Content>
