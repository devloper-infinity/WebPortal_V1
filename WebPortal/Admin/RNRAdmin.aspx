<%@ Page Title="RNR Feedback Administration" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="RNRAdmin.aspx.cs" Inherits="WebPortal.Admin.RNRAdmin" %>

<asp:Content ID="Head" ContentPlaceHolderID="head" runat="server">
    <style>
        .rnr {
            padding: 20px 0
        }

            .rnr > h2 {
                font-size: 1.8rem;
                font-weight: 400;
                margin: 0 0 18px;
                color: #343a40
            }

        .rnr-card {
            background: #fff;
            border: 1px solid rgba(0,0,0,.125);
            border-top: 3px solid #007bff;
            border-radius: .25rem;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 0 1px rgba(0,0,0,.125),0 1px 3px rgba(0,0,0,.2)
        }

            .rnr-card > h3 {
                font-size: 1.1rem;
                font-weight: 400;
                margin: -20px -20px 18px;
                padding: 13px 20px;
                border-bottom: 1px solid rgba(0,0,0,.125);
                color: #343a40
            }

        .rnr-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit,minmax(190px,1fr));
            gap: 15px
        }

        .rnr label {
            font-size: .875rem;
            color: #495057;
            margin-bottom: 5px
        }

        .rnr input, .rnr select, .rnr textarea {
            width: 100%;
            padding: .375rem .75rem;
            border: 1px solid #ced4da;
            border-radius: .25rem;
            background: #fff;
            color: #495057;
            min-height: 38px
        }

        .rnr textarea {
            min-height: 72px
        }

        .rnr button {
            padding: .45rem .8rem;
            border: 1px solid #007bff;
            border-radius: .25rem;
            background: #007bff;
            color: #fff;
            margin: 8px 4px 4px 0
        }

            .rnr button:hover {
                background: #0069d9;
                border-color: #0062cc
            }

        .rnr table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 12px
        }

        .rnr th {
            background: #f8f9fa
        }

        .rnr th, .rnr td {
            padding: .75rem;
            border-top: 1px solid #dee2e6;
            text-align: left;
            vertical-align: middle
        }

        .question {
            border: 1px solid #dee2e6;
            padding: 14px;
            margin: 10px 0;
            border-radius: .25rem;
            background: #f8f9fa
        }

        .muted {
            color: #6c757d
        }

        #quarters label {
            display: block;
            padding: 3px 0;
            font-weight: 400
        }

        #quarters input {
            width: auto;
            min-height: auto;
            margin-right: 6px
        }

        .question .opts {
            min-height: 105px;
            line-height: 1.6;
        }

        .rnr-loading {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 20000;
            background: rgba(15,23,42,.58);
            align-items: center;
            justify-content: center;
        }

            .rnr-loading.show {
                display: flex;
            }

        .rnr-loading-box {
            background: #fff;
            border-radius: .35rem;
            padding: 24px 34px;
            text-align: center;
            box-shadow: 0 18px 50px rgba(0,0,0,.3);
            font-weight: 600;
        }

        .rnr-spinner {
            width: 42px;
            height: 42px;
            margin: 0 auto 12px;
            border: 4px solid #dbeafe;
            border-top-color: #007bff;
            border-radius: 50%;
            animation: rnr-spin .8s linear infinite;
        }

        @keyframes rnr-spin {
            to {
                transform: rotate(360deg);
            }
        }

        .invoice-chip {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 8px 11px;
            border-radius: 999px;
                background-color: cadetblue;
            color: #fff;
            font-weight: 800;
            white-space: nowrap;
            float:right;
            margin-top:-50px;
        }
    </style>
</asp:Content>
<asp:Content ID="Body" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="rnr">
        <h2>R & R Feedback Administration</h2>
        <span>
            <a href="RNRReport.aspx" class="invoice-chip">R & R Feedback Report</a>
        </span>
        <div id="msg"></div>
        <div class="rnr-card">
            <h3>Questionnaire Master</h3>
            <div class="rnr-grid">
                <div>
                    <label>Questionnaire</label><select id="questionnaires"></select>
                </div>
                <div>
                    <label>Title</label><input id="title" maxlength="200" />
                </div>
                <div>
                    <label>Status</label><select id="status"><option>Draft</option>
                        <option>Published</option>
                    </select>
                </div>
                <div>
                    <label>Priority</label><input id="priority" type="number" value="0" />
                </div>
            </div>
            <label>Description</label><textarea id="description"></textarea><label><input id="active" type="checkbox" checked style="width: auto" />
                Active</label><div id="questions"></div>
            <button type="button" onclick="addQuestion()">Add question</button>
            <button type="button" onclick="saveQuestionnaire()">Save questionnaire</button>
            <button type="button" onclick="setActive()">Apply active/inactive only</button>
            <button type="button" onclick="newQuestionnaire()">New</button>
        </div>
        <div class="rnr-card">
            <h3>Assign &amp; Publish</h3>
            <div class="rnr-grid">
                <div>
                    <label>Questionnaire</label><select id="assignQuestionnaire"></select>
                </div>
                <div>
                    <label>Year</label><select id="surveyYear"></select>
                </div>
                <div>
                    <label>Quarter (multiple allowed)</label><div id="quarters">
                        <label>
                            <input type="checkbox" value="1">
                            January - March</label><label><input type="checkbox" value="2">
                                April - June</label><label><input type="checkbox" value="4">
                                    July - September</label><label><input type="checkbox" value="8">
                                        October - December</label>
                    </div>
                </div>
                <div>
                    <label>Domain</label><select id="domain"></select>
                </div>
                <div>
                    <label>Location</label><select id="location"></select>
                </div>
            </div>
            <button type="button" onclick="loadEmployees(this)">Show employees</button>
            <button type="button" onclick="assign()">Publish to selected</button><table id="employees">
                <thead>
                    <tr>
                        <th>
                            <input type="checkbox" onclick="document.querySelectorAll('.emp').forEach(x=>x.checked=this.checked)" /></th>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Domain</th>
                        <th>Location</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>
    <div id="rnrLoading" class="rnr-loading" role="status" aria-live="polite">
        <div class="rnr-loading-box">
            <div class="rnr-spinner"></div>
            <span id="rnrLoadingText">Please wait...</span>
        </div>
    </div>
    <script>
let data,editing=0,loadingCount=0;
function showLoading(text){loadingCount++;document.getElementById('rnrLoadingText').textContent=text||'Please wait...';document.getElementById('rnrLoading').classList.add('show')}
function hideLoading(){loadingCount=Math.max(0,loadingCount-1);if(!loadingCount)document.getElementById('rnrLoading').classList.remove('show')}
function localLoading(text){showLoading(text);setTimeout(hideLoading,300)}
async function call(name,arg,text){showLoading(text||'Processing...');try{let r=await fetch('RNRAdmin.aspx/'+name,{method:'POST',cache:'no-store',headers:{'Content-Type':'application/json','Cache-Control':'no-cache'},body:JSON.stringify(arg||{})}),x;try{x=await r.json()}catch(_){throw Error('The ERP returned an invalid response. Please sign in again and retry.')}if(!r.ok)throw Error(x.Message||'Request failed');return x.d}finally{hideLoading()}}
function option(v,t){return `<option value="${v}">${esc(t)}</option>`} function esc(s){return String(s??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]))}
async function init(){try{data=await call('Load');fill('questionnaires',data.Questionnaires,'QuestionnaireID','Title',true);fill('assignQuestionnaire',data.Questionnaires.filter(x=>x.Status==='Published'&&x.IsActive),'QuestionnaireID','Title');fill('domain',data.Domains,'Value','Text',true);fill('location',data.Locations,'Value','Text',true);let now=new Date(),y=now.getFullYear(),years=[];for(let i=y+1;i>=y-5;i--)years.push({Value:i,Text:i});fill('surveyYear',years,'Value','Text',false);document.querySelector(`#quarters input[value="${1<<Math.floor(now.getMonth()/3)}"]`).checked=true}catch(e){document.getElementById('msg').textContent=e.message}}
function fill(id,a,v,t,all){document.getElementById(id).innerHTML=(all?option(0,'All / select'):'')+a.map(x=>option(x[v],x[t])).join('')}
document.getElementById('questionnaires').onchange=async function(){if(Number(this.value)<=0)return;let x=await call('GetQuestionnaire',{id:+this.value}),g=id=>document.getElementById(id);editing=+this.value;g('title').value=x.Header.Title;g('description').value=x.Header.Description||'';g('status').value=x.Header.Status;g('active').checked=x.Header.IsActive;g('priority').value=x.Header.Priority;g('questions').innerHTML='';x.Questions.forEach(q=>addQuestion(q,x.Options.filter(o=>o.QuestionID===q.QuestionID).map(o=>o.OptionText)))};
function addQuestion(q,o){localLoading('Adding question...');q=q||{QuestionText:'',QuestionType:'Text',IsRequired:true,RatingMin:1,RatingMax:5};let d=document.createElement('div');d.className='question';d.innerHTML=`<input class="qt" placeholder="Question" value="${esc(q.QuestionText)}"><div class="rnr-grid"><select class="qy" onchange="localLoading('Updating question type...');this.closest('.question').querySelector('.opts').style.display=['SingleChoice','MultipleChoice'].includes(this.value)?'block':'none'">${['Text','SingleChoice','MultipleChoice','YesNo','Rating'].map(x=>`<option ${x===q.QuestionType?'selected':''}>${x}</option>`).join('')}</select><label><input class="qr" type="checkbox" ${q.IsRequired?'checked':''} style="width:auto"> Required</label><input class="qmin" type="number" value="${q.RatingMin||1}" title="Rating min"><input class="qmax" type="number" value="${q.RatingMax||5}" title="Rating max"></div><textarea class="opts" placeholder="Enter one option per line" style="display:${['SingleChoice','MultipleChoice'].includes(q.QuestionType)?'block':'none'}">${esc((o||[]).join('\n'))}</textarea><button type="button" onclick="localLoading('Moving question...');this.parentNode.previousElementSibling&&this.parentNode.parentNode.insertBefore(this.parentNode,this.parentNode.previousElementSibling)">Move up</button><button type="button" onclick="localLoading('Moving question...');this.parentNode.nextElementSibling&&this.parentNode.parentNode.insertBefore(this.parentNode.nextElementSibling,this.parentNode)">Move down</button><button type="button" onclick="localLoading('Deleting question...');this.parentNode.remove()">Delete</button>`;document.getElementById('questions').appendChild(d)}
function newQuestionnaire(){let g=id=>document.getElementById(id);editing=0;g('title').value='';g('description').value='';g('status').value='Draft';g('active').checked=true;g('priority').value=0;g('questions').innerHTML='';addQuestion()}
async function saveQuestionnaire(){try{let g=id=>document.getElementById(id),qs=[...document.querySelectorAll('.question')].map(x=>({Text:x.querySelector('.qt').value,Type:x.querySelector('.qy').value,Required:x.querySelector('.qr').checked,RatingMin:+x.querySelector('.qmin').value,RatingMax:+x.querySelector('.qmax').value,Options:x.querySelector('.opts').value.split(/\r?\n|\|/).map(s=>s.trim()).filter(Boolean)}));await call('Save',{input:{QuestionnaireID:editing,Title:g('title').value,Description:g('description').value,Status:g('status').value,IsActive:g('active').checked,Priority:+g('priority').value,Questions:qs}},'Saving questionnaire...');window.location.reload()}catch(e){document.getElementById('msg').textContent=e.message}}
async function setActive(){try{if(!editing)throw Error('Select a questionnaire first.');await call('SetActive',{questionnaireId:editing,active:document.getElementById('active').checked});document.getElementById('msg').textContent='Questionnaire state updated.'}catch(e){document.getElementById('msg').textContent=e.message}}
async function loadEmployees(button){let message=document.getElementById('msg');try{message.textContent='Loading employees...';if(button)button.disabled=true;let domainValue=parseInt(document.getElementById('domain').value,10),locationValue=parseInt(document.getElementById('location').value,10),a=await call('Employees',{domain:Number.isFinite(domainValue)?domainValue:0,location:Number.isFinite(locationValue)?locationValue:0});if(window.jQuery&&$.fn.DataTable&&$.fn.DataTable.isDataTable('#employees'))$('#employees').DataTable().clear().destroy();let body=document.querySelector('#employees tbody');body.innerHTML=a.length?a.map(x=>`<tr><td><input class="emp" type="checkbox" value="${x.EmployeeID}"></td><td>${esc(x.EmployeeCode)}</td><td>${esc(x.EmployeeName)}</td><td>${esc(x.DomainName)}</td><td>${esc(x.Location)}</td></tr>`).join(''):'<tr><td colspan="5" class="text-center text-muted">No active employees found for the selected filters.</td></tr>';if(a.length&&window.jQuery&&$.fn.DataTable)$('#employees').DataTable({responsive:true,pageLength:1200,order:[[2,'asc']]});message.textContent=a.length+' employee(s) loaded.'}catch(e){message.textContent='Unable to load employees: '+e.message}finally{if(button)button.disabled=false}}
async function assign(){try{let ids=[...document.querySelectorAll('.emp:checked')].map(x=>+x.value),quarterMask=[...document.querySelectorAll('#quarters input:checked')].reduce((n,x)=>n+Number(x.value),0);let n=await call('Assign',{questionnaireId:Number(document.getElementById('assignQuestionnaire').value||0),surveyYear:Number(document.getElementById('surveyYear').value||0),quarterMask:quarterMask,employeeIds:ids});document.getElementById('msg').textContent=n+' new assignment(s) created; overlapping active assignments skipped.'}catch(e){document.getElementById('msg').textContent=e.message}}
init();
</script>
</asp:Content>
