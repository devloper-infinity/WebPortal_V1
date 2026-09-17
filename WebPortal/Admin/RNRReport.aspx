<%@ Page Title="RNR Feedback Report" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="RNRReport.aspx.cs" Inherits="WebPortal.Admin.RNRReport" %>

<asp:Content ID="Head" ContentPlaceHolderID="head" runat="server">
    <style>
        .rr {
            padding: 20px 0
        }

            .rr > h2 {
                font-size: 1.8rem;
                font-weight: 400;
                margin: 0 0 18px;
                color: #343a40
            }

        .rr-card {
            background: #fff;
            border: 1px solid rgba(0,0,0,.125);
            border-top: 3px solid #007bff;
            border-radius: .25rem;
            padding: 18px;
            margin-bottom: 18px;
            box-shadow: 0 0 1px rgba(0,0,0,.125),0 1px 3px rgba(0,0,0,.2)
        }

        .filters {
            display: grid;
            grid-template-columns: repeat(auto-fit,minmax(160px,1fr));
            gap: 12px
        }

        .rr input, .rr select {
            width: 100%;
            height: 38px;
            padding: .375rem .75rem;
            border: 1px solid #ced4da;
            border-radius: .25rem;
            color: #495057
        }

        .rr button {
            padding: .45rem .8rem;
            background: #007bff;
            color: #fff;
            border: 1px solid #007bff;
            border-radius: .25rem;
            margin: 0 4px 12px 0
        }

            .rr button:hover {
                background: #0069d9
            }

        .stats {
            display: flex;
            gap: 14px
        }

        .stat {
            flex: 1;
            background: #f8f9fa;
            border-left: 4px solid #007bff;
            padding: 14px
        }

            .stat b {
                font-size: 1.5rem;
                color: #343a40
            }

        .rr table {
            width: 100%;
            border-collapse: collapse
        }

        .rr th {
            background: #f8f9fa
        }

        .rr th, .rr td {
            padding: .75rem;
            border-top: 1px solid #dee2e6;
            text-align: left
        }

        .link {
            color: #007bff;
            cursor: pointer
        }

        .modal {
            display: none;
            position: fixed;
            inset: 0;
            background: #0008;
            z-index: 9999
        }

            .modal > div {
                background: #fff;
                max-width: 760px;
                max-height: 80vh;
                overflow: auto;
                margin: 8vh auto;
                padding: 20px;
                border-radius: .25rem
            }

        .rnr-loading { display:none; position:fixed; inset:0; z-index:20000; background:rgba(15,23,42,.58); align-items:center; justify-content:center }
        .rnr-loading.show { display:flex }
        .rnr-loading-box { background:#fff; border-radius:.35rem; padding:24px 34px; text-align:center; box-shadow:0 18px 50px rgba(0,0,0,.3); font-weight:600 }
        .rnr-spinner { width:42px; height:42px; margin:0 auto 12px; border:4px solid #dbeafe; border-top-color:#007bff; border-radius:50%; animation:rnr-spin .8s linear infinite }
        @keyframes rnr-spin { to { transform:rotate(360deg) } }
    </style>
</asp:Content>
<asp:Content ID="Body" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="rr">
        <h2>R & R Response Report</h2>
        <div class="rr-card filters">
            <select id="q"></select><select id="d"></select><select id="l"></select><select id="dep"></select><select id="s"><option value="">All statuses</option>
                <option>Pending</option>
                <option>Completed</option>
            </select><input id="emp" type="number" placeholder="Employee numeric ID"><input id="from" type="date"><input id="to" type="date"></div>
        <button onclick="loadReport()" type="button">Filter</button>
        <button onclick="exportExcel()" type="button">Export Excel</button><div class="rr-card stats">
            <div class="stat">Assigned<br>
                <b id="assigned">0</b></div>
            <div class="stat">Completed<br>
                <b id="completed">0</b></div>
            <div class="stat">Pending<br>
                <b id="pending">0</b></div>
        </div>
        <div class="rr-card">
            <table>
                <thead>
                    <tr>
                        <th>Employee ID</th>
                        <th>Name</th>
                        <th>Domain</th>
                        <th>Location</th>
                        <th>Department</th>
                        <th>Year</th>
                        <th>Quarter</th>
                        <th>Assigned</th>
                        <th>Submitted</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody id="rows"></tbody>
            </table>
        </div>
    </div>
    <div id="modal" class="modal" onclick="if(event.target===this)this.style.display='none'">
        <div>
            <button type="button" style="float: right" onclick="showLoading('Closing...');document.getElementById('modal').style.display='none';setTimeout(hideLoading,300)">Close</button><h3>Submitted answers</h3>
            <div id="answers"></div>
        </div>
    </div>
    <div id="rnrLoading" class="rnr-loading" role="status" aria-live="polite"><div class="rnr-loading-box"><div class="rnr-spinner"></div><span id="rnrLoadingText">Please wait...</span></div></div>
    <script>
let loadingCount=0;function showLoading(text){loadingCount++;document.getElementById('rnrLoadingText').textContent=text||'Please wait...';document.getElementById('rnrLoading').classList.add('show')}function hideLoading(){loadingCount=Math.max(0,loadingCount-1);if(!loadingCount)document.getElementById('rnrLoading').classList.remove('show')}async function call(n,a,text){showLoading(text||'Processing...');try{let r=await fetch('RNRReport.aspx/'+n,{method:'POST',cache:'no-store',headers:{'Content-Type':'application/json','Cache-Control':'no-cache'},body:JSON.stringify(a||{})}),x;try{x=await r.json()}catch(_){throw Error('The ERP returned an invalid response. Please sign in again and retry.')}if(!r.ok)throw Error(x.Message||'Request failed');return x.d}finally{hideLoading()}}function e(v){return String(v??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]))}function fill(id,a,v,t,allValue){document.getElementById(id).innerHTML=`<option value="${allValue===undefined?0:allValue}">All</option>`+a.map(x=>`<option value="${x[v]}">${e(x[t])}</option>`).join('')}function args(){let g=id=>document.getElementById(id);return{questionnaire:Number(g('q').value||0),domain:g('d').value||'',location:Number(g('l').value||0),department:Number(g('dep').value||0),employee:Number(g('emp').value||0),status:g('s').value,from:g('from').value||null,to:g('to').value||null}}
async function init(){let x=await call('Lookups',{},'Loading report filters...');fill('q',x.Questionnaires,'QuestionnaireID','Title');fill('d',x.Domains,'Value','Text','');fill('l',x.Locations,'Value','Text');fill('dep',x.Departments,'Value','Text');loadReport()}async function loadReport(){try{let x=await call('Report',args(),'Loading report...'),c=x.Counts||{},g=id=>document.getElementById(id);g('assigned').textContent=c.TotalAssigned||0;g('completed').textContent=c.Completed||0;g('pending').textContent=c.Pending||0;g('rows').innerHTML=x.Rows.map(r=>`<tr><td>${e(r.EmployeeID)}</td><td class="${r.Status==='Completed'?'link':''}" onclick="${r.Status==='Completed'?`details(${r.AssignmentID})`:''}">${e(r.EmployeeName)}</td><td>${e(r.DomainName)}</td><td>${e(r.Location)}</td><td>${e(r.Department)}</td><td>${e(r.SurveyYear)}</td><td>${e(r.Quarter)}</td><td>${fmt(r.AssignedDate)}</td><td>${fmt(r.SubmittedDate)}</td><td>${r.Status}</td></tr>`).join('')}catch(ex){alert(ex.message)}}function fmt(x){return x?new Date(parseInt(String(x).match(/\d+/)[0])).toLocaleString():''}async function details(id){try{let x=await call('Answers',{assignmentId:id},'Loading submitted answers...');document.getElementById('answers').innerHTML=x.map(a=>`<p><b>${e(a.SortOrder)}. ${e(a.QuestionText)}</b><br>${e(a.Answer)}</p>`).join('');document.getElementById('modal').style.display='block'}catch(ex){alert(ex.message)}}function exportExcel(){showLoading('Preparing Excel export...');let p=new URLSearchParams(args());window.location.href='RNRReport.aspx?export=1&'+p.toString();setTimeout(hideLoading,3000)}init();</script>
</asp:Content>
