<%@ Page Title="Buy Back Settlement" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="BuybackSettlement.aspx.cs" Inherits="WebPortal.Admin.BuybackSettlement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../plugins/toastr/toastr.min.css" />
    <link rel="stylesheet" href="../Content/erp-modern-common.css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="erp-dashboard-header">
        <div class="erp-dashboard-header-content">
            <div class="erp-dashboard-icon" aria-hidden="true"><i class="fas fa-hand-holding-usd"></i></div>
            <div>
                <h1 class="erp-dashboard-title">Buy Back Settlement</h1>
                <p class="erp-dashboard-subtitle">Manage employee notice-period buyback settlements, payment details, and supporting documents.</p>
            </div>
        </div>
    </div>
    <div class="col-lg-12">
        <div class="card erp-section-card">
            <div class="card-header"><h3 class="card-title" id="bbsFormTitle">Settlement Details</h3></div>
            <div class="card-body erp-modern-form">
                <div id="bbsLoader" class="overlay d-none"><i class="fas fa-2x fa-sync-alt fa-spin"></i></div>
                <div id="bbsForm">
                    <div class="row">
                        <div class="col-lg-4 col-md-6 form-group"><label for="bbsEmployee">Employee <span class="text-danger">*</span></label><select id="bbsEmployee" class="form-control" required><option value="">Select</option></select></div>
                        <div class="col-lg-4 col-md-6 form-group"><label for="bbsActualNotice">Actual Notice Period <span class="text-danger">*</span></label><input id="bbsActualNotice" class="form-control" maxlength="100" required /></div>
                        <div class="col-lg-4 col-md-6 form-group"><label for="bbsBuybackNotice">Buy Back Notice Period <span class="text-danger">*</span></label><input id="bbsBuybackNotice" class="form-control" maxlength="100" required /></div>
                        <div class="col-lg-4 col-md-6 form-group"><label for="bbsOriginalSalary">Original Salary <span class="text-danger">*</span></label><input id="bbsOriginalSalary" class="form-control" maxlength="100" inputmode="decimal" required /></div>
                        <div class="col-lg-4 col-md-6 form-group"><label for="bbsSalarySlip">Salary Slip</label><div class="custom-file"><input type="file" id="bbsSalarySlip" class="custom-file-input" /><label class="custom-file-label" for="bbsSalarySlip">Choose file</label></div></div>
                        <div class="col-lg-4 col-md-6 form-group"><label for="bbsBuybackAmount">Buy Back Amount <span class="text-danger">*</span></label><input id="bbsBuybackAmount" class="form-control" maxlength="100" inputmode="decimal" required /></div>
                        <div class="col-lg-4 col-md-6 form-group"><label for="bbsAmountFile">Other Attachment</label><div class="custom-file"><input type="file" id="bbsAmountFile" class="custom-file-input" /><label class="custom-file-label" for="bbsAmountFile">Choose file</label></div></div>
                        <div class="col-lg-4 col-md-6 form-group"><label for="bbsPaidAmount">Infinity Paid Amount <span class="text-danger">*</span></label><input id="bbsPaidAmount" class="form-control" maxlength="100" inputmode="decimal" required /></div>
                        <div class="col-lg-4 col-md-6 form-group"><label for="bbsPaidDate">Infinity Paid Date <span class="text-danger">*</span></label><input type="date" id="bbsPaidDate" class="form-control" required /></div>
                        <div class="col-12 form-group"><label for="bbsRemark">Remark</label><textarea id="bbsRemark" class="form-control" maxlength="4000" rows="3"></textarea></div>
                    </div>
                    <button type="submit" id="bbsSubmit" class="btn btn-primary"><i class="fas fa-save mr-1"></i>Submit</button>
                    <button type="button" id="bbsClear" class="btn btn-secondary ml-1"><i class="fas fa-undo mr-1"></i>Clear</button>
                </div>
            </div>
        </div>
        <div class="card erp-section-card"><div class="card-header"><h3 class="card-title">Settlement Records</h3></div><div class="card-body"><div class="erp-table-wrap"><table id="bbsTable" class="table table-bordered table-hover" style="width:100%"></table></div></div></div>
    </div>
    <script src="../plugins/toastr/toastr.min.js"></script>
    <script>
        var bbsTable;
        $(function(){ bbsLoadEmployees(); bbsLoadGrid(); $('#bbsSubmit').on('click',bbsSave); $('#bbsClear').on('click',bbsClear); $('.custom-file-input').on('change',function(){var name=this.files.length?this.files[0].name:'Choose file';$(this).next('.custom-file-label').text(name);}); });
        function bbsCall(method,payload){return $.ajax({type:'POST',url:'BuybackSettlement.aspx/'+method,data:JSON.stringify(payload),contentType:'application/json; charset=utf-8',dataType:'json'}).then(function(r){return r.d;});}
        function bbsNotify(message,type){if(window.toastr){toastr.options={closeButton:true,progressBar:true,positionClass:'toast-top-right'};toastr[type||'warning'](message);}else alert(message);}
        function bbsError(xhr){bbsNotify(xhr.responseJSON&&xhr.responseJSON.Message?xhr.responseJSON.Message:'Unable to complete the request.','error');}
        function bbsLoadEmployees(){bbsCall('GetEmployees',{}).done(function(rows){$.each(rows||[],function(_,x){$('#bbsEmployee').append($('<option/>').val(x.EmployeeID).text(x.FullName));});}).fail(bbsError);}
        function bbsLoadGrid(){bbsCall('GetSettlements',{}).done(function(rows){if($.fn.DataTable.isDataTable('#bbsTable'))$('#bbsTable').DataTable().clear().destroy();$('#bbsTable').empty();bbsTable=$('#bbsTable').DataTable({data:rows||[],pageLength:20,searching:true,paging:true,ordering:true,autoWidth:false,scrollX:true,columns:[{title:'Sr. #',data:null,render:function(_,__,___,m){return m.row+1;}},{title:'Employee',data:'EmployeeName'},{title:'Actual Notice Period',data:'ActualNoticePeriod'},{title:'Buy Back Notice Period',data:'BuybackNoticePeriod'},{title:'Original Salary',data:'OriginalSalary'},{title:'Salary Slip',data:null,orderable:false,render:function(_,__,r){return r.HasSalarySlip?'<button type="button" class="btn btn-link btn-sm bbs-download" data-employee="'+r.EmployeeID+'" data-kind="salary">Download</button>':'-';}},{title:'Buy Back Amount',data:'BuybackAmount'},{title:'Other Attachment',data:null,orderable:false,render:function(_,__,r){return r.HasAmountAttachment?'<button type="button" class="btn btn-link btn-sm bbs-download" data-employee="'+r.EmployeeID+'" data-kind="amount">Download</button>':'-';}},{title:'Infinity Paid Amount',data:'InfinityPaidAmount'},{title:'Infinity Paid Date',data:'InfinityPaidDate'},{title:'Remark',data:'Remark'},{title:'Added By',data:'AddedByName'},{title:'Updated By',data:'UpdatedByName'},{title:'Edit',data:null,orderable:false,render:function(){return '<button type="button" class="btn btn-sm btn-outline-primary bbs-edit" title="Edit"><i class="fas fa-edit"></i></button>';}}],columnDefs:[{targets:'_all',defaultContent:'',className:'text-center'}]});$('#bbsTable tbody').off('click','.bbs-edit').on('click','.bbs-edit',function(){bbsEdit(bbsTable.row($(this).closest('tr')).data());});$('#bbsTable tbody').off('click','.bbs-download').on('click','.bbs-download',function(){window.location='BuybackSettlement.aspx?download='+encodeURIComponent($(this).data('kind'))+'&employeeId='+encodeURIComponent($(this).data('employee'));});}).fail(bbsError);}
        function bbsEdit(r){$('#bbsEmployee').val(r.EmployeeID);$('#bbsActualNotice').val(r.ActualNoticePeriod);$('#bbsBuybackNotice').val(r.BuybackNoticePeriod);$('#bbsOriginalSalary').val(r.OriginalSalary);$('#bbsBuybackAmount').val(r.BuybackAmount);$('#bbsPaidAmount').val(r.InfinityPaidAmount);$('#bbsPaidDate').val(r.InfinityPaidDateInput);$('#bbsRemark').val(r.Remark);$('#bbsFormTitle').text('Edit Settlement Details');window.scrollTo({top:0,behavior:'smooth'});}
        function bbsClear(){$('#bbsForm').find('input,textarea').val('');$('#bbsEmployee').val('');$('#bbsFormTitle').text('Settlement Details');$('.custom-file-label').text('Choose file');}
        function bbsFile(file,done){if(!file){done('', '');return;}if(file.size>5*1024*1024){bbsNotify('Each attachment must be 5 MB or smaller.');done(null,null);return;}var reader=new FileReader();reader.onload=function(e){done(file.name,String(e.target.result).split(',')[1]||'');};reader.onerror=function(){bbsNotify('The selected attachment could not be read.','error');done(null,null);};reader.readAsDataURL(file);}
        function bbsSave(e){e.preventDefault();var invalid=null;$('#bbsForm [required]').each(function(){if(!this.checkValidity()&&!invalid)invalid=this;});if(invalid){invalid.reportValidity();invalid.focus();return;}var salary=$('#bbsSalarySlip')[0].files[0],amount=$('#bbsAmountFile')[0].files[0];bbsFile(salary,function(sn,sb){if(sn===null)return;bbsFile(amount,function(an,ab){if(an===null)return;$('#bbsLoader').removeClass('d-none');bbsCall('SaveSettlement',{request:{EmployeeID:+$('#bbsEmployee').val(),ActualNoticePeriod:$('#bbsActualNotice').val().trim(),BuybackNoticePeriod:$('#bbsBuybackNotice').val().trim(),OriginalSalary:$('#bbsOriginalSalary').val().trim(),BuybackAmount:$('#bbsBuybackAmount').val().trim(),InfinityPaidAmount:$('#bbsPaidAmount').val().trim(),InfinityPaidDate:$('#bbsPaidDate').val(),Remark:$('#bbsRemark').val().trim(),SalarySlipName:sn,SalarySlipBase64:sb,AmountFileName:an,AmountFileBase64:ab}}).done(function(r){if(r.Success){bbsNotify(r.Message,'success');bbsClear();bbsLoadGrid();}else bbsNotify(r.Message,'error');}).fail(bbsError).always(function(){$('#bbsLoader').addClass('d-none');});});});}
    </script>
</asp:Content>
