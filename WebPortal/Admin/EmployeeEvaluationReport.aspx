<%@ Page Title="Employee Evaluation Report" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EmployeeEvaluationReport.aspx.cs" Inherits="WebPortal.Admin.EmployeeEvaluationReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../plugins/datatables-fixedcolumns/css/fixedColumns.bootstrap4.min.css" />
    <script src="../plugins/jszip/jszip.min.js"></script>
    <style>
        .evaluation-shell { background:#f5f7fb; min-height:calc(100vh - 120px); padding:16px; }
        .evaluation-card { background:#fff; border:1px solid #dce3ec; margin:0 auto; max-width:1600px; }
        .evaluation-header { align-items:center; border-left:4px solid #0f766e; display:flex; justify-content:space-between; padding:16px 18px; }
        .evaluation-header h1 { color:#172033; font-size:22px; font-weight:700; margin:0; }
        .evaluation-header p { color:#667085; font-size:13px; margin:4px 0 0; }
        .evaluation-tabs { background:#f8fafc; border-bottom:1px solid #dce3ec; border-top:1px solid #dce3ec; padding:0 14px; }
        .evaluation-tabs .nav-link { border-radius:0; color:#475467; font-weight:700; padding:13px 18px; }
        .evaluation-tabs .nav-link.active { background:#fff; border-top:3px solid #0f766e; color:#0f172a; }
        .evaluation-body { padding:16px; }
        .evaluation-toolbar { align-items:center; display:flex; flex-wrap:wrap; gap:10px; justify-content:space-between; margin-bottom:12px; }
        .evaluation-filter { align-items:center; display:flex; flex-wrap:wrap; gap:8px; }
        .evaluation-filter label { color:#344054; font-size:12px; font-weight:700 !important; margin:0; }
        .evaluation-filter .form-control { min-width:220px; }
        .evaluation-kpis { display:grid; gap:10px; grid-template-columns:repeat(4,minmax(145px,1fr)); margin-bottom:14px; }
        .evaluation-kpi { border:1px solid #e2e8f0; border-top:3px solid #0f766e; border-radius:7px; padding:11px; }
        .evaluation-kpi span { color:#64748b; display:block; font-size:11px; font-weight:700; text-transform:uppercase; }
        .evaluation-kpi strong { color:#111827; display:block; font-size:21px; margin-top:3px; }
        .evaluation-table { border-collapse:collapse !important; width:100% !important; }
        .evaluation-table th,.evaluation-table td { font-size:11px; vertical-align:middle !important; white-space:nowrap; }
        .evaluation-table thead th { background:#eef3f8; color:#1f2937; font-weight:700; }
        .evaluation-table tbody tr { cursor:pointer; }
        .evaluation-table tbody tr:hover { background:#ecfdf5; }
        .period-badge { background:#ecfdf3; border:1px solid #abefc6; border-radius:6px; color:#027a48; font-size:12px; font-weight:700; padding:7px 10px; }
        .section-title { color:#172033; font-size:15px; font-weight:700; margin:18px 0 8px; }
        .user-detail-grid { align-items:start; display:grid; gap:14px; grid-template-columns:minmax(0,1fr) minmax(0,1fr); }
        .user-detail-panel { min-width:0; }
        .user-sheet-tabs { border-bottom:1px solid #cbd5e1; display:flex; flex-wrap:nowrap; gap:3px; margin-bottom:14px; overflow-x:auto; padding:0 2px 2px; scrollbar-width:thin; }
        .user-sheet-tabs .nav-link { background:#eef2f6; border:1px solid #cbd5e1; border-bottom:0; border-radius:5px 5px 0 0; color:#334155; cursor:pointer; flex:0 0 auto; font-size:11px; font-weight:700; padding:7px 11px; white-space:nowrap; }
        .user-sheet-tabs .nav-link.active { background:#0f766e; border-color:#0f766e; color:#fff; }
        .empty-note { color:#667085; padding:18px; text-align:center; }
        .evaluation-loading { align-items:center; background:rgba(15,23,42,.55); bottom:0; display:none; justify-content:center; left:0; position:fixed; right:0; top:0; z-index:99999; }
        .evaluation-loading div { background:#fff; border-radius:8px; box-shadow:0 18px 50px rgba(15,23,42,.2); padding:18px 28px; }
        .dt-buttons .btn,.dt-buttons button { background:#0f766e !important; border:0 !important; color:#fff !important; font-size:12px; font-weight:700; margin-right:5px; }
        @media(max-width:1100px){ .user-detail-grid{grid-template-columns:1fr} }
        @media(max-width:900px){ .evaluation-header{align-items:flex-start;flex-direction:column}.evaluation-kpis{grid-template-columns:repeat(2,1fr)} }
        @media(max-width:575px){ .evaluation-kpis{grid-template-columns:1fr}.evaluation-shell{padding:8px} }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="evaluation-shell">
        <div class="evaluation-card">
            <div class="evaluation-header">
                <div>
                    <h1>Employee Evaluation Report</h1>
                    <p>Underwriting increment evaluation and user-wise production/quality details</p>
                </div>
                <div>
                    <a href="EmployeeEvaluationReport.aspx?exportAll=1" class="btn btn-success btn-sm"><i class="fas fa-file-excel"></i> Export All Details</a>
                    <button type="button" id="btnRefresh" class="btn btn-outline-secondary btn-sm"><i class="fas fa-sync-alt"></i> Refresh</button>
                </div>
            </div>
            <ul class="nav nav-tabs evaluation-tabs" role="tablist">
                <li class="nav-item"><a class="nav-link active" data-toggle="tab" href="#evaluationTab">Evaluation grid</a></li>
                <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#userWiseTab">User-wise details</a></li>
            </ul>
            <div class="tab-content evaluation-body">
                <div id="evaluationTab" class="tab-pane fade show active">
                    <div class="evaluation-kpis">
                        <div class="evaluation-kpi"><span>Employees</span><strong id="kpiEmployees">0</strong></div>
                        <div class="evaluation-kpi"><span>Productivity users</span><strong id="kpiProductivity">0</strong></div>
                        <div class="evaluation-kpi"><span>Task users</span><strong id="kpiTask">0</strong></div>
                        <div class="evaluation-kpi"><span>Average increment %</span><strong id="kpiIncrement">0.00</strong></div>
                    </div>
                    <div class="table-responsive">
                        <table id="tblEvaluation" class="table table-bordered table-hover evaluation-table">
                            <thead>
                                <tr>
                                    <th>Sr. #</th><th>Productive Task</th><th>Domain</th><th>Branch</th><th>Code</th><th>Name</th><th>Joining Date</th><th>Reporting Manager</th><th>Tenure Since Last Increment</th>
                                    <th>Production %</th><th>Production Grade</th><th>Qcer %</th><th>Qcer Grade</th><th>Attendance %</th><th>Attendance Grade</th><th>IncrementPercentageByPM</th>
                                    <th>Appreciation</th><th>Disciplinary</th><th>Incentive</th><th>Salary</th><th>Increment Percentage</th><th>Increment Amount</th><th>Salary After Increment</th><th>Month</th><th>Year</th>
                                    <th>Error Per Loan</th><th>Critical Per Loan</th><th>Non-Critical Per Loan</th><th>LoanCount</th><th>Critical Error Count</th><th>Non Critical Error Count</th>
                                </tr>
                            </thead><tbody></tbody>
                        </table>
                    </div>
                </div>
                <div id="userWiseTab" class="tab-pane fade">
                    <div id="userTabs" class="nav user-sheet-tabs" role="tablist"></div>
                    <div class="evaluation-toolbar">
                        <div>
                            <strong id="lblSelectedEmployee">No employee selected</strong>
                            <div class="text-muted small">Select an employee tab to view that user-wise sheet.</div>
                        </div>
                        <span id="lblPeriod" class="period-badge">No evaluation period selected.</span>
                    </div>
                    <div class="user-detail-grid">
                        <div class="user-detail-panel">
                            <h2 class="section-title">Quality feedback</h2>
                            <div class="table-responsive"><table id="tblFeedback" class="table table-bordered table-hover evaluation-table"><thead><tr><th>Feedback ID</th><th>Loan Number</th><th>Client</th><th>UW Name</th><th>QC Name</th><th>Date Reviewed</th><th>QC Date</th><th>Category</th><th>Sub category</th><th>Error Field</th><th>Screen</th><th>Error Type</th><th>Finding</th><th>Feedback Type</th><th>Severity</th><th>RCA</th><th>Finding Status</th></tr></thead><tbody></tbody></table></div>
                        </div>
                        <div class="user-detail-panel">
                            <h2 class="section-title">Production data</h2>
                            <div class="table-responsive"><table id="tblProduction" class="table table-bordered table-hover evaluation-table"><thead><tr><th>ProjectName</th><th>Code</th><th>Employee</th><th>LocationCode</th><th>Process</th><th>ProcessDate</th><th>Target</th><th>LoanCount</th></tr></thead><tbody></tbody></table></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="evaluationLoading" class="evaluation-loading"><div><i class="fas fa-spinner fa-spin"></i> Loading report data...</div></div>
    <script>
        (function () {
            var evaluationTable, productionTable, feedbackTable, evaluationRows = [];
            function value(row) { for (var i=1;i<arguments.length;i++){ var k=arguments[i]; if(row && row[k]!==undefined && row[k]!==null && row[k]!=="") return row[k]; } return ""; }
            function number(row) { var n=parseFloat(value.apply(null,arguments)); return isNaN(n)?0:n; }
            function esc(v){ return $("<div/>").text(v===null||v===undefined?"":v).html(); }
            function notify(type,message){ if(window.toastr && typeof window.toastr[type]==="function"){window.toastr[type](message);return;} if(window.console){(type==="error"?console.error:console.warn)(message);} if(type==="error") window.alert(message); }
            function call(method,data,done){
                $("#evaluationLoading").css("display","flex");
                $.ajax({type:"POST",url:"EmployeeEvaluationReport.aspx/"+method,data:JSON.stringify(data||{}),contentType:"application/json; charset=utf-8",dataType:"json"})
                    .done(function(r){ var payload=typeof r.d==="string"?JSON.parse(r.d):r.d; done(payload||{}); })
                    .fail(function(xhr){ var msg="Unable to load report data."; try{var error=JSON.parse(xhr.responseText);msg=error.Message||error.ExceptionMessage||msg;}catch(e){if(xhr.responseText)msg=xhr.responseText.substring(0,500);} if(window.console)console.error("Employee evaluation request failed",xhr); notify("error",msg); })
                    .always(function(){ $("#evaluationLoading").hide(); });
            }
            function baseOptions(title,showAll){ return {destroy:true,scrollX:true,autoWidth:false,pageLength:showAll?-1:50,lengthMenu:[[10,25,50,100,-1],[10,25,50,100,"All"]],dom:"Bfrtip",buttons:[{extend:"excelHtml5",title:title,text:"Export Excel",className:"btn btn-success btn-sm"},{extend:"csvHtml5",title:title,text:"Export CSV",className:"btn btn-secondary btn-sm"}],order:[]}; }
            function loadEvaluation(){ call("GetEvaluationData",{},function(p){ evaluationRows=p.Rows||[]; bindEvaluation(); if((p.Errors||[]).length) notify("warning",p.Errors.join("\n")); }); }
            function bindEvaluation(){
                if(evaluationTable) evaluationTable.destroy(); var body=$("#tblEvaluation tbody").empty(), prod=0, task=0, inc=0;
                $.each(evaluationRows,function(i,r){
                    var dp=value(r,"DPType","DailyTaskProductivity","ProductiveTask"); if((dp+"").toLowerCase()==="task") task++; else prod++;
                    inc+=number(r,"CalculatedIncrementPercentage");
                    var code=value(r,"Code"), name=value(r,"Name","FullName");
                    var cells=[i+1,dp,value(r,"D_Name","DomainName","Domain"),value(r,"BranchName","Branch"),code,name,value(r,"JoiningDate"),value(r,"ReportingManager"),value(r,"TenureSinceLastInc","TenureSinceLastIncrement"),value(r,"ProductionPerc","ProductionPercentage"),r.CalculatedProductionGrade,value(r,"CalculatedQcPercentage"),r.CalculatedQualityGrade,value(r,"OnWorkingDays","AttendancePerc","AttendancePercentage"),r.CalculatedAttendanceGrade,value(r,"CalculatedIncrementPercentage"),value(r,"TotalAppreciations","Appreciation"),value(r,"TotalError","Disciplinary"),value(r,"Incentive"),value(r,"Salary"),value(r,"CalculatedIncrementPercentage"),value(r,"IncrementAmount"),value(r,"SalaryAfterIncrement","GrandTotal"),value(r,"IncMonth","Month"),value(r,"Year"),value(r,"ErrorPerLoan"),value(r,"CriticalPerLoan"),value(r,"NonCriticalPerLoan"),value(r,"LoanCount"),value(r,"CriticalErrorCount"),value(r,"NonCriticalErrorCount")];
                    var tr=$("<tr/>").attr("data-code",code); $.each(cells,function(_,c){tr.append($("<td/>").html(esc(c)));}); body.append(tr);
                });
                $("#kpiEmployees").text(evaluationRows.length); $("#kpiProductivity").text(prod); $("#kpiTask").text(task); $("#kpiIncrement").text(evaluationRows.length?(inc/evaluationRows.length).toFixed(2):"0.00");
                bindUserTabs();
                evaluationTable=$("#tblEvaluation").DataTable(baseOptions("Employee Evaluation Report",true));
            }
            function bindUserTabs(){
                var tabs=$("#userTabs").empty(), seen={};
                $.each(evaluationRows,function(_,r){
                    var code=(value(r,"Code")+"").trim(), name=value(r,"Name","FullName");
                    if(!code || seen[code.toUpperCase()]) return;
                    seen[code.toUpperCase()]=true;
                    tabs.append($("<a/>",{href:"#",class:"nav-link user-sheet-tab",role:"tab","data-code":code,title:name}).text(code));
                });
            }
            function selectUserTab(code){
                $("#userTabs .user-sheet-tab").removeClass("active");
                var selected=$("#userTabs .user-sheet-tab").filter(function(){return (($(this).data("code")||"")+"").toUpperCase()===(code+"").toUpperCase();}).first();
                selected.addClass("active");
                if(selected.length && selected[0].scrollIntoView) selected[0].scrollIntoView({behavior:"smooth",block:"nearest",inline:"center"});
            }
            function loadUser(code){ if(!code){notify("warning","Please select an employee.");return;} call("GetUserWiseData",{Code:code},function(p){ bindDetails(p); if((p.Errors||[]).length) notify("warning",p.Errors.join("\n")); }); }
            function bindSimple(tableId,rows,fields,title){ var selector="#"+tableId; if($.fn.DataTable.isDataTable(selector)) $(selector).DataTable().destroy(); var body=$(selector+" tbody").empty(); $.each(rows,function(_,r){var tr=$("<tr/>");$.each(fields,function(_,f){tr.append($("<td/>").html(esc(value(r,f))));});body.append(tr);}); return $(selector).DataTable(baseOptions(title,false)); }
            function bindDetails(p){ var row=null; for(var i=0;i<evaluationRows.length;i++){if((value(evaluationRows[i],"Code")+"").toUpperCase()===(p.Code+"").toUpperCase()){row=evaluationRows[i];break;}} selectUserTab(p.Code); $("#lblSelectedEmployee").text(p.Code+(row?" : "+value(row,"Name","FullName"):"")); $("#lblPeriod").text(p.FromDate&&p.ToDate?(p.FromDate+" to "+p.ToDate):"No UW increment date range found"); productionTable=bindSimple("tblProduction",p.Production||[],["ProjectName","Code","Employee","LocationCode","Process","ProcessDate","Target","LoanCount"],"Production Data - "+p.Code); feedbackTable=bindSimple("tblFeedback",p.Feedback||[],["FeedbackID","Loan Number","Client","UW Name","QC Name","Date Reviewed","QC Date","Category","Sub category","Error Field","Screen","Error Type","Finding","Feedback Type","Severity","RCA","Finding Status"],"Quality Feedback - "+p.Code); }
            $(function(){ loadEvaluation(); $("#btnRefresh").on("click",loadEvaluation); $("#userTabs").on("click",".user-sheet-tab",function(e){e.preventDefault();loadUser($(this).data("code"));}); $("#tblEvaluation tbody").on("click","tr",function(){var c=$(this).data("code");$('a[href="#userWiseTab"]').tab("show");loadUser(c);}); $('a[href="#userWiseTab"]').on("shown.bs.tab",function(){if(!$("#userTabs .user-sheet-tab.active").length){var first=$("#userTabs .user-sheet-tab").first();if(first.length)loadUser(first.data("code"));}}); $('a[data-toggle="tab"]').on("shown.bs.tab",function(){if(evaluationTable)evaluationTable.columns.adjust();if(productionTable)productionTable.columns.adjust();if(feedbackTable)feedbackTable.columns.adjust();}); });
        })();
    </script>
</asp:Content>
