<%@ Page Title="RNR Feedback Report" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="RNRReport.aspx.cs" Inherits="WebPortal.Admin.RNRReport" %>

<asp:Content ID="Head" ContentPlaceHolderID="head" runat="server">
    <style>
        .rr { padding:20px 0 32px; color:#343a40 }
        .rr h2 { margin:0 0 18px; font-size:1.8rem; font-weight:400 }
        .rr-card { margin-bottom:18px; padding:18px; background:#fff; border:1px solid rgba(0,0,0,.125); border-top:3px solid #007bff; border-radius:.25rem; box-shadow:0 0 1px rgba(0,0,0,.125),0 1px 3px rgba(0,0,0,.18) }
        .report-tabs { display:flex; gap:6px; margin-bottom:16px; border-bottom:1px solid #dee2e6 }
        .report-tab { margin:0!important; padding:.65rem 1.2rem!important; color:#495057!important; background:transparent!important; border:0!important; border-bottom:3px solid transparent!important; border-radius:0!important; font-weight:600 }
        .report-tab.active { color:#007bff!important; border-bottom-color:#007bff!important }
        .filters { display:grid; grid-template-columns:repeat(auto-fit,minmax(155px,1fr)); gap:12px }
        .filter-field label { display:block; margin-bottom:5px; color:#59636e; font-size:12px; font-weight:600 }
        .rr input,.rr select { width:100%; height:38px; padding:.375rem .65rem; color:#495057; border:1px solid #ced4da; border-radius:.25rem; background:#fff }
        .actions { margin-top:14px }
        .rr button { margin:0 5px 5px 0; padding:.48rem .9rem; color:#fff; background:#007bff; border:1px solid #007bff; border-radius:.25rem }
        .rr button:hover { background:#0069d9 }
        .stats { display:flex; gap:14px }
        .stat { flex:1; padding:14px; background:#f8f9fa; border-left:4px solid #007bff }
        .stat b { color:#343a40; font-size:1.5rem }
        .table-scroll { overflow-x:auto }
        .rr table { width:100%; border-collapse:collapse }
        .rr th { background:#f8f9fa; white-space:nowrap }
        .rr th,.rr td { padding:.7rem; border-top:1px solid #dee2e6; text-align:left; vertical-align:top }
        .link { color:#007bff; cursor:pointer; font-weight:600 }
        .view-panel { display:none }
        .view-panel.active { display:block }
        .department-tabs { display:flex; flex-wrap:wrap; gap:7px; margin-bottom:16px }
        .department-tab { color:#495057!important; background:#f4f6f9!important; border:1px solid #d8dee5!important }
        .department-tab.active { color:#fff!important; background:#007bff!important; border-color:#007bff!important }
        .employee-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(420px,1fr)); gap:16px }
        .employee-card { overflow:hidden; background:#fff; border:1px solid #dfe4ea; border-radius:.35rem; box-shadow:0 2px 8px rgba(0,0,0,.06) }
        .employee-card-header { padding:12px 15px; background:#eaf3ff; border-bottom:1px solid #d5e5f8 }
        .employee-card-header strong { display:block; color:#173b7a }
        .employee-meta { margin-top:3px; color:#617080; font-size:12px }
        .status { float:right; padding:3px 8px; border-radius:12px; font-size:11px; font-weight:600 }
        .status.completed { color:#137333; background:#dff4e5 }
        .status.pending { color:#8a5a00; background:#fff2cc }
        .employee-card table { font-size:13px }
        .employee-card th:first-child,.employee-card td:first-child { width:54px; text-align:center }
        .employee-card th:last-child,.employee-card td:last-child { width:36% }
        .empty { padding:24px; color:#6c757d; text-align:center }
        .modal { display:none; position:fixed; inset:0; z-index:9999; background:#0008 }
        .modal>div { max-width:760px; max-height:80vh; margin:8vh auto; padding:20px; overflow:auto; background:#fff; border-radius:.25rem }
        .rnr-loading { display:none; position:fixed; inset:0; z-index:20000; align-items:center; justify-content:center; background:rgba(15,23,42,.58) }
        .rnr-loading.show { display:flex }
        .rnr-loading-box { padding:24px 34px; text-align:center; font-weight:600; background:#fff; border-radius:.35rem; box-shadow:0 18px 50px rgba(0,0,0,.3) }
        .rnr-spinner { width:42px; height:42px; margin:0 auto 12px; border:4px solid #dbeafe; border-top-color:#007bff; border-radius:50%; animation:rnr-spin .8s linear infinite }
        @keyframes rnr-spin { to { transform:rotate(360deg) } }
        @media(max-width:600px) { .stats { flex-direction:column } .employee-grid { grid-template-columns:1fr } }
    </style>
</asp:Content>

<asp:Content ID="Body" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="rr">
        <h2>R &amp; R Response Report</h2>
        <div class="report-tabs">
            <button type="button" class="report-tab active" onclick="switchView('summary',this)">Summary</button>
            <button type="button" class="report-tab" onclick="switchView('details',this)">Details</button>
        </div>

        <div class="rr-card">
            <div class="filters">
                <div class="filter-field"><label>Questionnaire</label><select id="q"></select></div>
                <div class="filter-field"><label>Domain</label><select id="d"></select></div>
                <div class="filter-field"><label>Location</label><select id="l"></select></div>
                <div class="filter-field"><label>Department</label><select id="dep"></select></div>
                <div class="filter-field"><label>Status</label><select id="s"><option value="">All statuses</option><option>Pending</option><option>Completed</option></select></div>
                <div class="filter-field"><label>Year</label><select id="year"></select></div>
                <div class="filter-field"><label>Quarter</label><select id="quarter"><option value="0">All quarters</option><option value="1">January - March</option><option value="2">April - June</option><option value="4">July - September</option><option value="8">October - December</option></select></div>
                <div class="filter-field"><label>Employee numeric ID</label><input id="emp" type="number" min="0" placeholder="All employees"></div>
                <div class="filter-field"><label>Assigned from</label><input id="from" type="date"></div>
                <div class="filter-field"><label>Assigned to</label><input id="to" type="date"></div>
            </div>
            <div class="actions"><button onclick="loadActiveView()" type="button"><i class="fas fa-filter"></i> Apply filters</button><button onclick="exportExcel()" type="button"><i class="fas fa-file-excel"></i> Export Excel</button></div>
        </div>

        <section id="summaryView" class="view-panel active">
            <div class="rr-card stats">
                <div class="stat">Assigned<br><b id="assigned">0</b></div>
                <div class="stat">Completed<br><b id="completed">0</b></div>
                <div class="stat">Pending<br><b id="pending">0</b></div>
            </div>
            <div class="rr-card table-scroll"><table><thead><tr><th>Employee ID</th><th>Name</th><th>Domain</th><th>Location</th><th>Department</th><th>Year</th><th>Quarter</th><th>Assigned</th><th>Submitted</th><th>Status</th></tr></thead><tbody id="rows"></tbody></table></div>
        </section>

        <section id="detailsView" class="view-panel">
            <div class="rr-card"><div id="departmentTabs" class="department-tabs"></div><div id="departmentContent"></div></div>
        </section>
    </div>

    <div id="modal" class="modal" onclick="if(event.target===this)this.style.display='none'"><div><button type="button" style="float:right" onclick="document.getElementById('modal').style.display='none'">Close</button><h3>Submitted answers</h3><div id="answers"></div></div></div>
    <div id="rnrLoading" class="rnr-loading" role="status" aria-live="polite"><div class="rnr-loading-box"><div class="rnr-spinner"></div><span id="rnrLoadingText">Please wait...</span></div></div>

    <script>
let loadingCount=0,activeView='summary',detailsData=null,departments=[];
function showLoading(text){loadingCount++;document.getElementById('rnrLoadingText').textContent=text||'Please wait...';document.getElementById('rnrLoading').classList.add('show')}
function hideLoading(){loadingCount=Math.max(0,loadingCount-1);if(!loadingCount)document.getElementById('rnrLoading').classList.remove('show')}
async function call(name,arg,text){showLoading(text||'Processing...');try{let response=await fetch('RNRReport.aspx/'+name,{method:'POST',cache:'no-store',headers:{'Content-Type':'application/json','Cache-Control':'no-cache'},body:JSON.stringify(arg||{})}),json;try{json=await response.json()}catch(_){throw Error('The ERP returned an invalid response. Please sign in again and retry.')}if(!response.ok)throw Error(json.Message||'Request failed');return json.d}finally{hideLoading()}}
function esc(value){return String(value??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]))}
function cleanAnswer(value){let answer=String(value??'').trim();return answer==='—'||answer.indexOf('â€”')===0?'':answer}
function fill(id,items,value,text,allValue,allText){document.getElementById(id).innerHTML=`<option value="${allValue===undefined?0:allValue}">${esc(allText||'All')}</option>`+items.map(item=>`<option value="${esc(item[value])}">${esc(item[text])}</option>`).join('')}
function args(){let get=id=>document.getElementById(id);return{questionnaire:Number(get('q').value||0),domain:get('d').value||'',location:Number(get('l').value||0),department:Number(get('dep').value||0),employee:Number(get('emp').value||0),status:get('s').value,year:Number(get('year').value||0),quarter:Number(get('quarter').value||0),from:get('from').value||null,to:get('to').value||null}}
async function init(){try{let data=await call('Lookups',{},'Loading report filters...');fill('q',data.Questionnaires,'QuestionnaireID','Title');fill('d',data.Domains,'Value','Text','','All domains');fill('l',data.Locations,'Value','Text');fill('dep',data.Departments,'Value','Text');fill('year',data.Years,'Value','Text',0,'All years');await loadSummary()}catch(error){alert(error.message)}}
function switchView(view,button){activeView=view;document.querySelectorAll('.report-tab').forEach(tab=>tab.classList.remove('active'));button.classList.add('active');document.querySelectorAll('.view-panel').forEach(panel=>panel.classList.remove('active'));document.getElementById(view+'View').classList.add('active');loadActiveView()}
function loadActiveView(){return activeView==='summary'?loadSummary():loadDetails()}
async function loadSummary(){try{let data=await call('Report',args(),'Loading summary...'),counts=data.Counts||{},get=id=>document.getElementById(id);get('assigned').textContent=counts.TotalAssigned||0;get('completed').textContent=counts.Completed||0;get('pending').textContent=counts.Pending||0;get('rows').innerHTML=data.Rows.length?data.Rows.map(row=>`<tr><td>${esc(row.EmployeeID)}</td><td class="${row.Status==='Completed'?'link':''}" onclick="${row.Status==='Completed'?`showAnswers(${Number(row.AssignmentID)})`:''}">${esc(row.EmployeeName)}</td><td>${esc(row.DomainName)}</td><td>${esc(row.Location)}</td><td>${esc(row.Department)}</td><td>${esc(row.SurveyYear)}</td><td>${esc(row.Quarter)}</td><td>${formatDate(row.AssignedDate)}</td><td>${formatDate(row.SubmittedDate)}</td><td>${esc(row.Status)}</td></tr>`).join(''):'<tr><td colspan="10" class="empty">No records found for the selected filters.</td></tr>'}catch(error){alert(error.message)}}
async function loadDetails(){try{detailsData=await call('Details',args(),'Loading department details...');departments=[...new Set(detailsData.Employees.map(row=>row.Department||'Unassigned'))];let tabs=document.getElementById('departmentTabs');tabs.innerHTML=departments.map((name,index)=>`<button type="button" class="department-tab ${index===0?'active':''}" onclick="selectDepartment(${index},this)">${esc(name)}</button>`).join('');if(!departments.length){document.getElementById('departmentContent').innerHTML='<div class="empty">No employees found for the selected filters.</div>';return}renderDepartment(0)}catch(error){alert(error.message)}}
function selectDepartment(index,button){document.querySelectorAll('.department-tab').forEach(tab=>tab.classList.remove('active'));button.classList.add('active');renderDepartment(index)}
function renderDepartment(index){let name=departments[index],employees=detailsData.Employees.filter(row=>(row.Department||'Unassigned')===name),answers=detailsData.Answers,html='<div class="employee-grid">';employees.forEach(employee=>{let employeeAnswers=answers.filter(answer=>Number(answer.AssignmentID)===Number(employee.AssignmentID));html+=`<article class="employee-card"><div class="employee-card-header"><span class="status ${String(employee.Status).toLowerCase()}">${esc(employee.Status)}</span><strong>${esc(employee.EmployeeID)} : ${esc(employee.EmployeeName)}</strong><div class="employee-meta">${esc(employee.Questionnaire)} | ${esc(employee.SurveyYear)} | ${esc(employee.Quarter)} | ${esc(employee.DomainName)} | ${esc(employee.Location)}</div></div><div class="table-scroll"><table><thead><tr><th>Sr. #</th><th>Question</th><th>Answer</th></tr></thead><tbody>`;if(employeeAnswers.length)html+=employeeAnswers.map(answer=>`<tr><td>${esc(answer.SortOrder)}</td><td>${esc(answer.QuestionText)}</td><td>${esc(cleanAnswer(answer.Answer))}</td></tr>`).join('');else html+='<tr><td colspan="3" class="empty">No submitted answers.</td></tr>';html+='</tbody></table></div></article>'});document.getElementById('departmentContent').innerHTML=html+'</div>'}
function formatDate(value){if(!value)return'';let match=String(value).match(/\d+/);return match?new Date(Number(match[0])).toLocaleString():esc(value)}
async function showAnswers(id){try{let data=await call('Answers',{assignmentId:id},'Loading submitted answers...');document.getElementById('answers').innerHTML=data.map(answer=>`<p><b>${esc(answer.SortOrder)}. ${esc(answer.QuestionText)}</b><br>${esc(answer.Answer)}</p>`).join('');document.getElementById('modal').style.display='block'}catch(error){alert(error.message)}}
function exportExcel(){showLoading('Preparing Excel export...');let values=args();values.view=activeView;let query=new URLSearchParams(values);window.location.href='RNRReport.aspx?export=1&'+query.toString();setTimeout(hideLoading,3000)}
init();
    </script>
</asp:Content>
