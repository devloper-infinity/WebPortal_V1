<%@ Page Title="Approve Employee" Language="C#" MasterPageFile="~/Accounts/Accounts.Master" AutoEventWireup="true" CodeBehind="ApprovedEmployee.aspx.cs" Inherits="WebPortal.Accounts.ApprovedEmployee" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .ae-page{padding:12px 15px 30px}.ae-card{background:#fff;border:1px solid #e3e8ef;border-radius:8px;margin-bottom:16px;box-shadow:0 1px 4px rgba(0,0,0,.05)}
        .ae-title{padding:12px 16px;border-bottom:1px solid #e8edf3;background:#f8fafc;color:#33445c;font-weight:600}.ae-body{padding:16px}
        .ae-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:12px 28px}.ae-item{display:grid;grid-template-columns:155px 1fr;border-bottom:1px solid #f0f2f5;padding:6px 0;font-size:13px}.ae-label{font-weight:600;color:#59677a}.ae-value{color:#27384d;word-break:break-word}
        .ae-required:after{content:' *';color:#dc3545}.ae-match-note{font-size:12px;color:#a23535}.ae-table-wrap{overflow-x:auto}.ae-table th{white-space:nowrap;background:#5a78a8;color:#fff;font-size:12px}.ae-table td{white-space:nowrap;font-size:12px;vertical-align:middle}
        .ae-question{margin-bottom:13px}.ae-question label{font-size:13px;font-weight:600;color:#445267}.ae-actions{display:flex;justify-content:flex-end;gap:10px}.ae-loading{display:none;position:fixed;inset:0;background:rgba(255,255,255,.7);z-index:99999}.ae-loading div{position:absolute;left:50%;top:50%;transform:translate(-50%,-50%);font-weight:600;color:#33445c}
        @media(max-width:768px){.ae-grid{grid-template-columns:1fr}.ae-item{grid-template-columns:130px 1fr}}
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="aeLoading" class="ae-loading"><div><i class="fas fa-spinner fa-spin mr-2"></i>Loading...</div></div>
    <div class="ae-page">
        <div class="content-header px-0"><div class="container-fluid px-0"><div class="callout callout-info mb-3"><h6 class="m-0"><i class="fas fa-user-check mr-2"></i><b>Approve Employee</b></h6></div></div></div>
        <div id="aeAlert" class="alert" style="display:none" role="alert"></div>
        <div class="ae-card"><div class="ae-title">Personal Information</div><div class="ae-body"><div id="aePersonal" class="ae-grid"></div></div></div>
        <div class="ae-card"><div class="ae-title">Official Information</div><div class="ae-body"><div id="aeOfficial" class="ae-grid"></div></div></div>
        <div id="aeMatchesCard" class="ae-card" style="display:none"><div class="ae-title">Possible Previous Employee Record</div><div class="ae-body">
            <p class="ae-match-note"><b>A possible match was found.</b> Select exactly one old employee code before approval. Matches are based on name and date of birth.</p>
            <div class="ae-table-wrap"><table id="aeMatches" class="table table-bordered table-hover ae-table"><thead><tr><th>Select</th><th>Code</th><th>Employee Name</th><th>Joining Date</th><th>Date of Birth</th><th>Company</th><th>Branch</th><th>Department</th><th>Designation</th></tr></thead><tbody></tbody></table></div>
        </div></div>
        <div class="ae-card"><div class="ae-title">Approval Details</div><div class="ae-body">
            <div class="row"><div class="col-md-4 form-group"><label class="ae-required" for="aeDate">Approval date</label><input id="aeDate" type="date" class="form-control" /></div><div class="col-md-4 form-group"><label class="ae-required" for="aeJoiningType">Joining type</label><select id="aeJoiningType" class="form-control"><option value="">Select</option><option value="New">New</option><option value="Rejoining">Rejoining</option></select></div></div>
            <div class="form-group"><label class="ae-required" for="aeRemark">Approval remark</label><textarea id="aeRemark" class="form-control" rows="3" maxlength="4000"></textarea></div>
            <div id="aeRejoining" style="display:none">
                <div class="ae-question"><label class="ae-required" for="aeAns1">1. Why is the employee rejoining?</label><textarea id="aeAns1" class="form-control" rows="2" maxlength="4000"></textarea></div>
                <div class="ae-question"><label class="ae-required" for="aeAns2">2. Is approval required from Accounts or a higher authority?</label><textarea id="aeAns2" class="form-control" rows="2" maxlength="4000"></textarea></div>
                <div class="ae-question"><label class="ae-required" for="aeAns3">3. Was the employee's background history checked?</label><textarea id="aeAns3" class="form-control" rows="2" maxlength="4000"></textarea></div>
                <div class="ae-question"><label class="ae-required" for="aeAns4">4. Were the employee's documents checked carefully?</label><textarea id="aeAns4" class="form-control" rows="2" maxlength="4000"></textarea></div>
                <div class="ae-question"><label class="ae-required" for="aeAns5">5. What was the earlier discontinuation reason?</label><textarea id="aeAns5" class="form-control" rows="2" maxlength="4000"></textarea></div>
                <div class="ae-question"><label class="ae-required" for="aeAns6">6. Which project number did the employee work on?</label><textarea id="aeAns6" class="form-control" rows="2" maxlength="4000"></textarea></div>
            </div>
            <div class="ae-actions"><a class="btn btn-outline-secondary" href="ProfileApproval.aspx">Back</a><button type="button" id="aeApprove" class="btn btn-success"><i class="fas fa-check mr-1"></i>Approve Employee</button></div>
        </div></div>
    </div>
    <script>
        var aeCode='',aeHasMatches=false;
        var aePersonal=[['Code','Code'],['Employee Name','EmployeeName'],['Gender','Gender'],['Present Address','PresentAddress'],['Permanent Address','PermenentAddress'],['Email ID','EmailID'],['Qualification','Qualification'],['Cell No.','CellNo'],['Date of Birth','DateOfBirth'],['Blood Group','BloodGroup'],['PAN','PAN']];
        var aeOfficial=[['Employee Type','EmployeeType'],['Joining Date','JoiningDate'],['Salary','Salary'],['Company','CompanyName'],['Working Branch','WorkingBranchName'],['Designation','DesignationName'],['Department','DepartmentName'],['Project','ProjectName'],['Project Manager','ReportingManager'],['Shift','ShiftName'],['Cut Off Time','CutOffTime'],['Working Hours','WorkTime'],['Weekly Holiday','WeeklyHolidayName'],['Agreement Period','Period'],['Agreement Date','DateOfAgreement'],['Agreement Expiry Date','AgreementExpiraryDate'],['Bond Period','BondPeriod'],['Bond Date','DateOfBond'],['Bond Expiry Date','BondExpiraryDate'],['Bank Name','BankName'],['IFSC Code','IFSCCode'],['Bank Account No.','BankAccNo'],['PF No.','PFno'],['UAN','UAN'],['ESIC No.','ESICNo'],['Official Email ID','OfficialEmailID'],['Employee Remark','EmployeeRemark']];
        $(function(){aeCode=new URLSearchParams(window.location.search).get('Code')||'';$('#aeJoiningType').on('change',function(){var r=this.value==='Rejoining';$('#aeRejoining').toggle(r);$('#aeRejoining textarea').prop('required',r);});$('#aeApprove').on('click',aeApprove);if(!aeCode){aeNotify('Employee code is required.','danger');return;}aeLoad();});
        function aeCall(method,data){return $.ajax({type:'POST',url:'ApprovedEmployee.aspx/'+method,data:JSON.stringify(data||{}),contentType:'application/json; charset=utf-8',dataType:'json'}).then(function(r){return r.d;});}
        function aeLoad(){$('#aeLoading').show();aeCall('GetEmployee',{code:aeCode}).done(function(r){aeRender('#aePersonal',aePersonal,r.Employee);aeRender('#aeOfficial',aeOfficial,r.Employee);aeMatches(r.Matches||[]);var d=aeIsoDate(r.Employee.JoiningDate);if(d)$('#aeDate').attr('min',d);}).fail(aeError).always(function(){$('#aeLoading').hide();});}
        function aeRender(target,fields,row){var h='';$.each(fields,function(_,f){h+='<div class="ae-item"><span class="ae-label">'+aeHtml(f[0])+'</span><span class="ae-value">'+aeHtml(row[f[1]])+'</span></div>';});$(target).html(h);}
        function aeMatches(rows){aeHasMatches=rows.length>0;$('#aeMatchesCard').toggle(aeHasMatches);var b=$('#aeMatches tbody').empty();$.each(rows,function(_,r){b.append('<tr><td class="text-center"><input type="radio" name="aeOldCode" value="'+aeAttr(r.Code)+'" /></td><td>'+aeHtml(r.Code)+'</td><td>'+aeHtml(r.FullName)+'</td><td>'+aeHtml(r.JoiningDate)+'</td><td>'+aeHtml(r.DateOfBirth)+'</td><td>'+aeHtml(r.CompanyName)+'</td><td>'+aeHtml(r.BranchName)+'</td><td>'+aeHtml(r.DepartmentName)+'</td><td>'+aeHtml(r.DesignationName)+'</td></tr>');});}
        function aeApprove(){var joining=$('#aeJoiningType').val(),p={code:aeCode,approvedDate:$('#aeDate').val(),remark:$.trim($('#aeRemark').val()),joiningType:joining,oldCode:$('input[name=aeOldCode]:checked').val()||'',answers:[]};for(var i=1;i<=6;i++)p.answers.push($.trim($('#aeAns'+i).val()));if(!p.approvedDate||!p.remark||!joining){aeNotify('Approval date, joining type, and remark are required.','warning');return;}if(aeHasMatches&&!p.oldCode){aeNotify('Select the matching old employee code.','warning');return;}if(joining==='Rejoining'&&p.answers.some(function(x){return !x;})){aeNotify('Answer all rejoining questions.','warning');return;}$('#aeApprove').prop('disabled',true);$('#aeLoading').show();aeCall('Approve',p).done(function(r){aeNotify(r.Message,'success');setTimeout(function(){window.location='ProfileApproval.aspx';},900);}).fail(aeError).always(function(){$('#aeApprove').prop('disabled',false);$('#aeLoading').hide();});}
        function aeNotify(m,t){$('#aeAlert').removeClass('alert-success alert-danger alert-warning').addClass('alert-'+(t||'warning')).text(m).show();window.scrollTo(0,0);}function aeError(x){aeNotify(x.responseJSON&&x.responseJSON.Message?x.responseJSON.Message:'Unable to complete the request.','danger');}function aeHtml(v){return $('<div/>').text(v==null?'':v).html();}function aeAttr(v){return aeHtml(v).replace(/"/g,'&quot;');}function aeIsoDate(v){if(!v)return'';var d=new Date(v);if(isNaN(d.getTime()))return'';return d.toISOString().slice(0,10);}
    </script>
</asp:Content>
