<%@ Page Title="Tracking Sheet" Language="C#" MasterPageFile="~/Production/Production.Master" AutoEventWireup="true" CodeBehind="TrackingSheet.aspx.cs" Inherits="WebPortal.TrackingSheet.TrackingSheetPage" %>

<asp:Content ID="Head" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="OLTracking.css" />
    <style>
        .ots-tabs {
            display: flex;
            gap: 8px;
            margin-bottom: 14px;
            border-bottom: 1px solid #d7e2ee
        }

        .ots-tab {
            padding: 12px 18px;
            border: 0;
            border-bottom: 3px solid transparent;
            background: transparent;
            color: #496078;
            font-weight: 800;
            cursor: pointer
        }

            .ots-tab.active {
                border-bottom-color: #0f6b8f;
                color: #0f6b8f
            }

        .ots-panel {
            display: none
        }

            .ots-panel.active {
                display: block
            }

        .ots-status {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 12px;
            background: #e8f3f7;
            color: #0f6b8f;
            font-size: 11px;
            font-weight: 800
        }

        .ots-step {
            display: none
        }

            .ots-step.active {
                display: block
            }

        .ots-disabled {
            background: #edf2f7 !important;
            color: #344a60 !important
        }

        .ots-note {
            margin: 8px 0;
            padding: 9px 11px;
            border-radius: 6px;
            background: #f1f7fb;
            color: #486174;
            font-size: 12px
        }
    </style>
</asp:Content>
<asp:Content ID="Body" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="olt-page">
        <div class="olt-hero">
            <div>
                <h2>Tracking Sheet</h2>
                <p>Allocate eligible loans, update your queue, and review daily status.</p>
            </div>
            <div class="olt-links"><a href="ProcessFlowConfiguration.aspx">Process flow</a><a href="ImportData.aspx">Import data</a></div>
        </div>
        <div id="oltAlert" class="olt-alert"></div>
        <div class="ots-tabs">
            <button type="button" class="ots-tab active" data-panel="allocation">1. Order Allocation</button>
            <button type="button" class="ots-tab" data-panel="status">2. Update Status</button>
            <button type="button" class="ots-tab" data-panel="daily">3. Daily Status</button>
        </div>
        <section id="allocation" class="ots-panel active">
            <div class="olt-card">
                <div class="olt-card-head">Allocate one eligible loan</div>
                <div class="olt-card-body">
                    <div class="olt-form">
                        <div class="olt-field wide">
                            <label>Project #</label><select id="project"></select>
                        </div>
                        <div class="olt-field wide">
                            <label>Process</label><select id="process"><option value="">Select process</option>
                            </select>
                        </div>
                        <div class="olt-field wide">
                            <label>Deal #</label><select id="deal"><option value="">Select deal</option>
                            </select>
                        </div>
                        <div class="olt-field wide">
                            <label>Loan #</label><select id="loan" class="ots-disabled" disabled><option value="">Select project, process and deal</option>
                            </select>
                        </div>
                        <div class="olt-field full">
                            <div class="ots-note">The first eligible loan is populated automatically and cannot be changed. A maximum of two Pending/In Process loans is allowed.</div>
                            <button type="button" class="olt-btn" onclick="allocateLoan()">Allocate</button>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <section id="status" class="ots-panel">
            <div class="olt-card">
                <div class="olt-card-head">My allocated loan queue</div>
                <div class="olt-table-wrap">
                    <table class="olt-table">
                        <thead>
                            <tr>
                                <th>Project</th>
                                <th>Deal #</th>
                                <th>Loan #</th>
                                <th>Process</th>
                                <th>Status</th>
                                <th>Assigned</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody id="queueRows">
                            <tr>
                                <td colspan="7" class="olt-empty">Loading queue...</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>
        <section id="daily" class="ots-panel">
            <div class="olt-card">
                <div class="olt-card-head">Daily status filters</div>
                <div class="olt-card-body">
                    <div class="olt-form">
                        <div class="olt-field">
                            <label>From date</label><input id="fromDate" type="date" />
                        </div>
                        <div class="olt-field">
                            <label>To date</label><input id="toDate" type="date" />
                        </div>
                        <div class="olt-field">
                            <label>Month</label><input id="monthFilter" type="month" onchange="applyMonth()" />
                        </div>
                        <div class="olt-field">
                            <label>Process</label><select id="dailyProcess"><option value="">All processes</option>
                            </select>
                        </div>
                        <div class="olt-field full">
                            <button type="button" class="olt-btn" onclick="loadDaily()">Show</button>
                        </div>
                    </div>
                </div>
                <div class="olt-table-wrap">
                    <table id="dailyTable" class="olt-table">
                        <thead>
                            <tr>
                                <th>Project</th>
                                <th>Deal #</th>
                                <th>Loan #</th>
                                <th>Process</th>
                                <th>Status</th>
                                <th>Assigned</th>
                                <th>Started</th>
                                <th>Completed</th>
                                <th>Remark</th>
                            </tr>
                        </thead>
                        <tbody id="dailyRows"></tbody>
                    </table>
                </div>
            </div>
        </section>
    </div>
    <div id="completeModal" class="olt-modal">
        <div class="olt-dialog">
            <div class="olt-dialog-head">
                <span>Complete loan</span>
                <button type="button" onclick="closeComplete()">×</button>
            </div>
            <div class="olt-dialog-body">
                <input id="assignmentId" type="hidden" /><div id="feedbackStep" class="ots-step">
                    <h4>Feedback</h4>
                    <p class="olt-muted">Feedback is mandatory for this process. Add one or more entries before continuing.</p>
                    <div id="feedbackRows"></div>
                    <div class="olt-actions" style="margin-top: 10px">
                        <button type="button" class="olt-btn secondary" onclick="addFeedback()">Add feedback</button>
                        <button type="button" class="olt-btn" onclick="continueToComplete()">Continue</button>
                    </div>
                </div>
                <div id="completeStep" class="ots-step">
                    <div class="olt-form">
                        <div class="olt-field wide">
                            <label>Status</label><input value="Completed" class="ots-disabled" disabled />
                        </div>
                        <div class="olt-field full">
                            <label>Remark</label><textarea id="completeRemark" maxlength="1000"></textarea>
                        </div>
                        <div class="olt-field full olt-actions">
                            <button type="button" class="olt-btn" onclick="submitCompletion()">Submit</button>
                            <button type="button" class="olt-btn secondary" onclick="closeComplete()">Cancel</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="OLTracking.js"></script>
    <script>
var page='TrackingSheet.aspx',flow=[],queue=[];document.addEventListener('DOMContentLoaded',function(){bindTabs();setToday();OLT.call(page,'GetProjects').then(function(r){OLT.options(project,r,['ProjectID','projectID'],['ProjectName','ProjectNo','Name'],'Select project');});OLT.call(page,'GetDailyProcesses').then(function(r){OLT.options(dailyProcess,r,['ProcessID'],['ProcessName'],'All processes');});project.onchange=loadProject;process.onchange=tryLoadLoan;deal.onchange=tryLoadLoan;loadQueue();loadDaily();});
function bindTabs(){[].slice.call(document.querySelectorAll('.ots-tab')).forEach(function(b){b.onclick=function(){document.querySelector('.ots-tab.active').classList.remove('active');document.querySelector('.ots-panel.active').classList.remove('active');b.classList.add('active');document.getElementById(b.dataset.panel).classList.add('active');if(b.dataset.panel==='status')loadQueue();if(b.dataset.panel==='daily')loadDaily();};});}
function loadProject(){if(!project.value)return;Promise.all([OLT.call(page,'GetDeals',{projectId:+project.value}),OLT.call(page,'GetFlow',{projectId:+project.value})]).then(function(r){OLT.options(deal,r[0],['DealNo','DealNumber','Deal'],['DealNo','DealNumber','Deal'],'Select deal');flow=r[1];OLT.options(process,flow,['ProcessID'],['ProcessName'],'Select process');loan.innerHTML='<option value="">Select process and deal</option>';}).catch(showError);}
function tryLoadLoan(){if(!project.value||!process.value||!deal.value)return;var selected=process.options[process.selectedIndex];OLT.call(page,'GetAvailableLoan',{projectId:+project.value,dealNumber:deal.value,processId:+process.value,processName:selected.text}).then(function(r){OLT.options(loan,r,['LoanNumber'],['LoanNumber'],'No eligible loan available');}).catch(showError);}
function allocateLoan(){if(!loan.value){OLT.alert('No eligible loan is available for the selected process and deal.',true);return;}OLT.call(page,'Allocate',{projectId:+project.value,processId:+process.value,loanNumber:loan.value,dealNumber:deal.value}).then(function(){OLT.alert('Loan allocated successfully.');tryLoadLoan();loadQueue();}).catch(showError);}
function loadQueue(){OLT.call(page,'GetQueue').then(function(r){queue=r;queueRows.innerHTML=r.length?r.map(function(x){return'<tr><td>'+x.ProjectID+'</td><td>'+OLT.esc(x.DealNumber)+'</td><td>'+OLT.esc(x.LoanNumber)+'</td><td>'+OLT.esc(x.ProcessName)+'</td><td><span class="ots-status">'+x.AssignmentStatus+'</span></td><td>'+fmt(x.AssignedDate)+'</td><td>'+(x.AssignmentStatus==='Pending'?'<button type="button" class="olt-btn secondary" onclick="startLoan('+x.AssignmentID+')">Start Work</button> ':'')+'<button type="button" class="olt-btn" onclick="openComplete('+x.AssignmentID+')">Update Status</button></td></tr>';}).join(''):'<tr><td colspan="7" class="olt-empty">No Pending/In Process loans.</td></tr>';}).catch(showError);}
function startLoan(id){OLT.call(page,'StartLoan',{assignmentId:id}).then(function(){OLT.alert('Loan marked In Process.');loadQueue();}).catch(showError);}function openComplete(id){var x=queue.filter(function(q){return q.AssignmentID===id;})[0];assignmentId.value=id;completeRemark.value='';feedbackRows.innerHTML='';feedbackStep.classList.remove('active');completeStep.classList.remove('active');if(x&&x.FeedbackRequiredOnComplete){feedbackStep.classList.add('active');addFeedback();}else completeStep.classList.add('active');completeModal.classList.add('open');}function closeComplete(){completeModal.classList.remove('open');}
function addFeedback(){var d=document.createElement('div');d.className='olt-feedback-row';d.innerHTML='<textarea class="feedbackText" maxlength="2000" placeholder="Feedback"></textarea><button type="button" class="olt-btn danger" onclick="this.parentNode.remove()">Remove</button>';feedbackRows.appendChild(d);}function feedbackValues(){return [].slice.call(document.querySelectorAll('.feedbackText')).map(function(e){return e.value.trim();}).filter(Boolean);}function continueToComplete(){if(!feedbackValues().length){OLT.alert('At least one feedback entry is required.',true);return;}feedbackStep.classList.remove('active');completeStep.classList.add('active');}function submitCompletion(){if(!completeRemark.value.trim()){OLT.alert('Remark is required.',true);return;}OLT.call(page,'CompleteLoan',{assignmentId:+assignmentId.value,remark:completeRemark.value,feedbacks:feedbackValues()}).then(function(){closeComplete();OLT.alert('Loan completed.');loadQueue();loadDaily();}).catch(showError);}
function setToday(){var d=new Date().toISOString().slice(0,10);fromDate.value=toDate.value=d;}function applyMonth(){if(!monthFilter.value)return;var p=monthFilter.value.split('-'),start=new Date(+p[0],+p[1]-1,1),end=new Date(+p[0],+p[1],0);fromDate.value=localIso(start);toDate.value=localIso(end);}function localIso(d){return d.getFullYear()+'-'+String(d.getMonth()+1).padStart(2,'0')+'-'+String(d.getDate()).padStart(2,'0');}
function loadDaily(){OLT.call(page,'GetDailyStatus',{processId:+dailyProcess.value||0,fromDate:fromDate.value,toDate:toDate.value}).then(function(r){if(window.jQuery&&$.fn.DataTable&&$.fn.DataTable.isDataTable('#dailyTable'))$('#dailyTable').DataTable().destroy();dailyRows.innerHTML=r.length?r.map(function(x){return'<tr><td>'+x.ProjectID+'</td><td>'+OLT.esc(x.DealNumber)+'</td><td>'+OLT.esc(x.LoanNumber)+'</td><td>'+OLT.esc(x.ProcessName)+'</td><td>'+x.AssignmentStatus+'</td><td>'+fmt(x.AssignedDate)+'</td><td>'+fmt(x.StartedDate)+'</td><td>'+fmt(x.CompletedDate)+'</td><td>'+OLT.esc(x.LastRemark)+'</td></tr>';}).join(''):'<tr><td colspan="9" class="olt-empty">No loans found.</td></tr>';if(r.length&&window.jQuery&&$.fn.DataTable)$('#dailyTable').DataTable({pageLength:25,order:[]});}).catch(showError);}function fmt(v){var n=parseInt(String(v||'').replace(/\D/g,''),10);return n?new Date(n).toLocaleString():'';}function showError(e){OLT.alert(e.message||String(e),true);}
</script>
</asp:Content>
