<%@ Page Title="Tracking Sheet" Language="C#" MasterPageFile="~/Production/Production.Master" AutoEventWireup="true" CodeBehind="TrackingSheet.aspx.cs" Inherits="WebPortal.TrackingSheet.TrackingSheetPage" %>

<asp:Content ID="Head" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="OLTracking.css" />
    <link rel="stylesheet" href="TrackingSheetFeedback.css" />
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

        .ots-daily-table-wrap {
            box-sizing: border-box;
            padding: 0 15px 15px;
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
                            <label>Deal #</label><select id="deal"><option value="">Select deal</option>
                            </select>
                        </div>
                        <div class="olt-field wide">
                            <label>Process</label><select id="process" disabled><option value="">Select deal first</option>
                            </select>
                        </div>
                        <div class="olt-field wide">
                            <label>Loan #</label><select id="loan" class="ots-disabled" disabled><option value="">Select project, deal and process</option>
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
                <div class="olt-table-wrap ots-daily-table-wrap">
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
        <div class="olt-dialog olt-dialog-large" role="dialog" aria-modal="true" aria-labelledby="completeDialogTitle">
            <div class="olt-dialog-head">
                <span id="completeDialogTitle">Update loan status</span>
                <button type="button" class="olt-dialog-close" onclick="closeComplete()" aria-label="Close popup">&times;</button>
                <button type="button" onclick="closeComplete()">×</button>
            </div>
            <div class="olt-dialog-body">
                <input id="assignmentId" type="hidden" />
                <div id="statusStep" class="ots-step">
                    <div class="olt-form">
                        <div class="olt-field wide"><label>Status</label><select id="updateStatus" onchange="changeCompletionStatus()"><option value="">Select status</option><option value="Completed">Completed</option><option value="Hold">Hold</option></select></div>
                        <div id="holdReasonField" class="olt-field wide" style="display:none"><label>Hold Reason</label><select id="holdReason"><option value="">Select</option><option>PDF Issue</option><option>Audit Worksheet Not available in Box</option><option>Partially Review in Scienna</option><option>Wrongly pulled in ERP</option><option value="Miscellaneous - Any other issue with comments">Miscellaneous &ndash; Any other issue with comments</option></select></div>
                        <div class="olt-field full olt-actions"><button id="statusContinueButton" type="button" class="olt-btn" onclick="selectCompletionStatus()">Continue</button></div>
                    </div>
                </div>
                <div id="feedbackStep" class="ots-step">
                    <div class="olt-feedback-heading">
                        <div><h3>Add Feedback</h3><p>At least one feedback entry is mandatory before the loan can be completed.</p></div>
                        <span id="savedFeedbackCount" class="olt-feedback-count">0 feedback added</span>
                    </div>
                    <div class="olt-feedback-form">
                        <div class="olt-field"><label>Loan #</label><input id="fbLoanNumber" class="ots-disabled" disabled /></div>
                        <div class="olt-field"><label>Client</label><input id="fbClient" class="ots-disabled" disabled /></div>
                        <div class="olt-field"><label>UW Name</label><select id="fbErrorBy" onchange="bindFeedbackOwner()"><option value="">Select</option></select></div>
                        <div class="olt-field"><label>Previous Process</label><input id="fbMarkedTo" class="ots-disabled" disabled /></div>
                        <div class="olt-field"><label>Date Reviewed</label><input id="fbDateReviewed" class="ots-disabled" disabled /></div>
                        <div class="olt-field"><label>QC Name</label><input id="fbFeedbackBy" class="ots-disabled" disabled /></div>
                        <div class="olt-field"><label>QC Date</label><input id="fbQCDate" class="ots-disabled" disabled /></div>
                        <div class="olt-field"><label>Category</label><select id="fbCategory" onchange="loadFeedbackSubcategories()"><option value="">Select</option></select></div>
                        <div class="olt-field"><label>Subcategory</label><select id="fbSubcategory"><option value="">Select</option></select></div>
                        <div class="olt-field"><label>Error Field</label><input id="fbErrorField" maxlength="500" /></div>
                        <div class="olt-field"><label>Screen</label><input id="fbScreen" maxlength="1000" /></div>
                        <div class="olt-field"><label>Error Type</label><input id="fbErrorType" maxlength="100" /></div>
                        <div class="olt-field"><label>Feedback Type</label><input id="fbFeedbackType" maxlength="100" /></div>
                        <div class="olt-field"><label>Severity</label><select id="fbSeverity"><option value="">Select</option><option>Non-Critical</option><option>Critical</option><option>Critical-Saleable</option></select></div>
                        <div class="olt-field"><label>Feedback Status</label><input id="fbFeedbackStatus" value="Pending" class="ots-disabled" disabled /></div>
                        <div class="olt-field"><label>Source</label><input id="fbSource" value="Internal" class="ots-disabled" disabled /></div>
                        <div class="olt-field"><label>Feedback Received Date</label><input id="fbReceivedDate" class="ots-disabled" disabled /></div>
                        <div class="olt-field span-3"><label>Finding</label><textarea id="fbError" maxlength="2000"></textarea></div>
                    </div>
                    <div class="olt-actions olt-feedback-actions">
                        <button type="button" class="olt-btn" onclick="saveFeedback()">Add Feedback</button>
                        <button id="continueAfterFeedback" type="button" class="olt-btn secondary" onclick="continueToComplete()" disabled>Continue to Update Loan</button>
                    </div>
                    <div id="savedFeedbackList" class="olt-saved-feedback"></div>
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
                            <button type="button" class="olt-btn" onclick="submitCompletion()">Update Loan</button>
                            <button type="button" class="olt-btn secondary" onclick="closeComplete()">Cancel</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="OLTracking.js"></script>
    <script>
var page='TrackingSheet.aspx',flow=[],queue=[];document.addEventListener('DOMContentLoaded',function(){bindTabs();setToday();OLT.call(page,'GetProjects').then(function(r){OLT.options(project,r,['ProjectID','projectID'],['ProjectName','ProjectNo','Name'],'Select project');});OLT.call(page,'GetDailyProcesses').then(function(r){OLT.options(dailyProcess,r,['ProcessID'],['ProcessName'],'All processes');});project.onchange=loadProject;deal.onchange=selectDeal;process.onchange=tryLoadLoan;loadQueue();loadDaily();});
function bindTabs(){[].slice.call(document.querySelectorAll('.ots-tab')).forEach(function(b){b.onclick=function(){document.querySelector('.ots-tab.active').classList.remove('active');document.querySelector('.ots-panel.active').classList.remove('active');b.classList.add('active');document.getElementById(b.dataset.panel).classList.add('active');if(b.dataset.panel==='status')loadQueue();if(b.dataset.panel==='daily')loadDaily();};});}
function loadProject(){if(!project.value)return;process.disabled=true;loan.innerHTML='<option value="">Select deal and process</option>';Promise.all([OLT.call(page,'GetDeals',{projectId:+project.value}),OLT.call(page,'GetFlow',{projectId:+project.value})]).then(function(r){OLT.options(deal,r[0],['DealNo','DealNumber','Deal'],['DealNo','DealNumber','Deal'],'Select deal');flow=r[1];OLT.options(process,flow,['ProcessID'],['ProcessName'],'Select deal first');process.disabled=true;}).catch(showError);}
function selectDeal(){process.disabled=!deal.value;process.value='';if(process.options.length)process.options[0].text=deal.value?'Select process':'Select deal first';loan.innerHTML='<option value="">Select process</option>';}
function tryLoadLoan(){if(!project.value||!process.value||!deal.value)return;var selected=process.options[process.selectedIndex];loan.innerHTML='<option value="">Checking eligibility...</option>';OLT.call(page,'GetAvailableLoan',{projectId:+project.value,dealNumber:deal.value,processId:+process.value,processName:selected.text}).then(function(r){if(typeof r==='string'){try{r=JSON.parse(r);}catch(e){r={LoanNumber:r};}}var number=r&&r.LoanNumber?String(r.LoanNumber):'';loan.innerHTML='';var option=document.createElement('option');option.value=number;option.textContent=number||'No eligible loan available';loan.appendChild(option);}).catch(showError);}
function allocateLoan(){if(!loan.value){OLT.alert('No eligible loan is available for the selected process and deal.',true);return;}OLT.call(page,'Allocate',{projectId:+project.value,processId:+process.value,loanNumber:loan.value,dealNumber:deal.value}).then(function(r){if(!actionSucceeded(r))return;OLT.alert(r.Message||'Loan allocated successfully.');tryLoadLoan();loadQueue();}).catch(showError);}
function loadQueue(){OLT.call(page,'GetQueue').then(function(r){queue=r;queueRows.innerHTML=r.length?r.map(function(x){return'<tr><td>'+OLT.esc(x.ProjectName||x.ProjectID)+'</td><td>'+OLT.esc(x.DealNumber)+'</td><td>'+OLT.esc(x.LoanNumber)+'</td><td>'+OLT.esc(x.ProcessName)+'</td><td><span class="ots-status">'+x.AssignmentStatus+'</span></td><td>'+fmt(x.AssignedDate)+'</td><td>'+(x.AssignmentStatus==='Pending'?'<button type="button" class="olt-btn secondary" onclick="startLoan('+x.AssignmentID+')">Start Work</button> ':'')+'<button type="button" class="olt-btn" onclick="openComplete('+x.AssignmentID+')">Update Status</button></td></tr>';}).join(''):'<tr><td colspan="7" class="olt-empty">No Pending/In Process loans.</td></tr>';}).catch(showError);}
function startLoan(id){OLT.call(page,'StartLoan',{assignmentId:id}).then(function(r){if(!actionSucceeded(r))return;OLT.alert(r.Message||'Loan marked In Process.');loadQueue();}).catch(showError);}
var activeAssignment=null,feedbackRequired=false,savedFeedbacks=0,feedbackOwners=[];
function openComplete(id){activeAssignment=queue.filter(function(q){return q.AssignmentID===id;})[0]||null;feedbackRequired=!!(activeAssignment&&activeAssignment.FeedbackRequiredOnComplete);savedFeedbacks=0;assignmentId.value=id;completeRemark.value='';updateStatus.value='';holdReason.value='';changeCompletionStatus();savedFeedbackList.innerHTML='';savedFeedbackCount.textContent='0 feedback added';continueAfterFeedback.disabled=true;[statusStep,feedbackStep,completeStep].forEach(function(s){s.classList.remove('active');});statusStep.classList.add('active');completeModal.classList.add('open');}
function closeComplete(){completeModal.classList.remove('open');activeAssignment=null;}
function changeCompletionStatus(){var isHold=updateStatus.value==='Hold';holdReasonField.style.display=isHold?'block':'none';statusContinueButton.textContent=isHold?'Place on Hold':'Continue';}
function selectCompletionStatus(){if(updateStatus.value==='Hold'){if(!holdReason.value){OLT.alert('Please select a hold reason.',true);return;}statusContinueButton.disabled=true;OLT.call(page,'HoldLoan',{assignmentId:+assignmentId.value,holdReason:holdReason.value}).then(function(r){if(!actionSucceeded(r))return;closeComplete();OLT.alert(r.Message||'Loan placed on hold successfully.');loadQueue();loadDaily();}).catch(showError).then(function(){statusContinueButton.disabled=false;});return;}if(updateStatus.value!=='Completed'){OLT.alert('Please select a status.',true);return;}statusStep.classList.remove('active');if(!feedbackRequired){completeStep.classList.add('active');return;}feedbackStep.classList.add('active');loadFeedbackForm();}
function parseJsonResult(r){if(typeof r==='string'){try{return JSON.parse(r);}catch(e){return {};}}return r||{};}
function fillSelect(el,rows,valueName,textName,placeholder){el.innerHTML='<option value="">'+placeholder+'</option>';(rows||[]).forEach(function(x){var o=document.createElement('option');o.value=x[valueName];o.textContent=x[textName];el.appendChild(o);});}
function loadFeedbackForm(){OLT.call(page,'GetFeedbackDefaults',{assignmentId:+assignmentId.value}).then(function(r){r=parseJsonResult(r);var context=(r.table0||[])[0]||{};feedbackOwners=r.table2||[];fillSelect(fbErrorBy,feedbackOwners,'AssignmentID','UserName','Select');if(feedbackOwners.length)fbErrorBy.value=String(feedbackOwners[0].AssignmentID);bindFeedbackOwner();fbLoanNumber.value=context.LoanNumber||'';fbClient.value=context.Client||'';fbFeedbackBy.value=context.FeedbackBy||'';fbQCDate.value=context.QCDate||'';fbReceivedDate.value=context.QCDate||'';savedFeedbacks=+(context.FeedbackCount||0);updateFeedbackState();OLT.call(page,'GetFeedbackCategories').then(function(c){fillSelect(fbCategory,c,'Value','Text','Select');}).catch(showError);}).catch(showError);}
function bindFeedbackOwner(){var assignment=String(fbErrorBy.value||''),owner=feedbackOwners.filter(function(x){return String(x.AssignmentID)===assignment;})[0]||{};fbMarkedTo.value=owner.ProcessName||'';fbDateReviewed.value=formatFeedbackDate(owner.CompletedDate);}
function formatFeedbackDate(value){if(!value)return'';var n=parseInt(String(value).replace(/\D/g,''),10),d=n?new Date(n):new Date(value);if(isNaN(d.getTime()))return'';return String(d.getMonth()+1).padStart(2,'0')+'/'+String(d.getDate()).padStart(2,'0')+'/'+d.getFullYear();}
function loadFeedbackSubcategories(){fbSubcategory.innerHTML='<option value="">Select</option>';if(!fbCategory.value)return;OLT.call(page,'GetFeedbackSubcategories',{categoryId:+fbCategory.value}).then(function(r){fillSelect(fbSubcategory,r,'Value','Text','Select');}).catch(showError);}
function feedbackModel(){var owner=feedbackOwners.filter(function(x){return String(x.AssignmentID)===String(fbErrorBy.value);})[0]||{};return{AssignmentID:+assignmentId.value,MarkedTo:owner.ProcessName||'',ErrorBy:owner.UserName||'',FeedbackBy:fbFeedbackBy.value,DateReviewed:fbDateReviewed.value,ErrorType:fbErrorType.value.trim(),CategoryID:+fbCategory.value||0,Category:fbCategory.options[fbCategory.selectedIndex]?fbCategory.options[fbCategory.selectedIndex].text:'',SubcategoryID:+fbSubcategory.value||0,Subcategory:fbSubcategory.options[fbSubcategory.selectedIndex]?fbSubcategory.options[fbSubcategory.selectedIndex].text:'',Severity:fbSeverity.value,ErrorField:fbErrorField.value.trim(),Screen:fbScreen.value.trim(),FeedbackType:fbFeedbackType.value.trim(),Error:fbError.value.trim(),ShouldBe:'',Remark:''};}
function validateFeedback(m){if(!m.MarkedTo||!m.ErrorBy)return'Please select UW Name.';if(!m.ErrorType)return'Please enter Error Type.';if(!m.CategoryID)return'Please select Category.';if(!m.SubcategoryID)return'Please select Subcategory.';if(!m.Severity)return'Please select Severity.';if(!m.ErrorField)return'Please enter Error Field.';if(!m.FeedbackType)return'Please enter Feedback Type.';if(!m.Error)return'Please enter Finding.';return'';}
function saveFeedback(){var m=feedbackModel(),error=validateFeedback(m);if(error){OLT.alert(error,true);return;}OLT.call(page,'SaveFeedback',{model:m}).then(function(r){if(!actionSucceeded(r))return;savedFeedbacks=+(r.FeedbackCount||savedFeedbacks+1);var item=document.createElement('div');item.textContent='Feedback #'+r.FeedbackID+' added successfully.';savedFeedbackList.appendChild(item);clearFeedbackEntry();updateFeedbackState();OLT.alert(r.Message||'Feedback added successfully.');}).catch(showError);}
function clearFeedbackEntry(){fbErrorType.value='';fbCategory.value='';fbSubcategory.innerHTML='<option value="">Select</option>';fbSeverity.value='';fbErrorField.value='';fbScreen.value='';fbFeedbackType.value='';fbError.value='';}
function updateFeedbackState(){savedFeedbackCount.textContent=savedFeedbacks+' feedback '+(savedFeedbacks===1?'added':'entries added');continueAfterFeedback.disabled=savedFeedbacks<1;}
function continueToComplete(){if(feedbackRequired&&savedFeedbacks<1){OLT.alert('At least one feedback entry is required.',true);return;}feedbackStep.classList.remove('active');completeStep.classList.add('active');}
function submitCompletion(){if(!completeRemark.value.trim()){OLT.alert('Remark is required.',true);return;}OLT.call(page,'CompleteLoan',{assignmentId:+assignmentId.value,remark:completeRemark.value,feedbacks:[]}).then(function(r){if(!actionSucceeded(r))return;closeComplete();OLT.alert(r.Message||'Loan completed.');loadQueue();loadDaily();}).catch(showError);}
function setToday(){var d=new Date().toISOString().slice(0,10);fromDate.value=toDate.value=d;}function applyMonth(){if(!monthFilter.value)return;var p=monthFilter.value.split('-'),start=new Date(+p[0],+p[1]-1,1),end=new Date(+p[0],+p[1],0);fromDate.value=localIso(start);toDate.value=localIso(end);}function localIso(d){return d.getFullYear()+'-'+String(d.getMonth()+1).padStart(2,'0')+'-'+String(d.getDate()).padStart(2,'0');}
function loadDaily(){OLT.call(page,'GetDailyStatus',{processId:+dailyProcess.value||0,fromDate:fromDate.value,toDate:toDate.value}).then(function(r){if(window.jQuery&&$.fn.DataTable&&$.fn.DataTable.isDataTable('#dailyTable'))$('#dailyTable').DataTable().destroy();dailyRows.innerHTML=r.length?r.map(function(x){return'<tr><td>'+OLT.esc(x.ProjectName||x.ProjectID)+'</td><td>'+OLT.esc(x.DealNumber)+'</td><td>'+OLT.esc(x.LoanNumber)+'</td><td>'+OLT.esc(x.ProcessName)+'</td><td>'+x.AssignmentStatus+'</td><td>'+fmt(x.AssignedDate)+'</td><td>'+fmt(x.StartedDate)+'</td><td>'+fmt(x.CompletedDate)+'</td><td>'+OLT.esc(x.LastRemark)+'</td></tr>';}).join(''):'<tr><td colspan="9" class="olt-empty">No loans found.</td></tr>';if(r.length&&window.jQuery&&$.fn.DataTable)$('#dailyTable').DataTable({pageLength:25,order:[]});}).catch(showError);}function actionSucceeded(r){if(typeof r==='string'){try{r=JSON.parse(r);}catch(e){r={Success:false,Message:'The requested action could not be completed.'};}}if(!r||r.Success!==true){OLT.alert(r&&r.Message?r.Message:'The requested action could not be completed.',true);return false;}return true;}function fmt(v){var n=parseInt(String(v||'').replace(/\D/g,''),10);return n?new Date(n).toLocaleString():'';}function showError(e){OLT.alert('The requested action could not be completed. Please refresh the page and try again.',true);}
</script>
</asp:Content>
