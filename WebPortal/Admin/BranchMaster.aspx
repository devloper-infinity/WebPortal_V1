<%@ Page Title="Branch Master" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="BranchMaster.aspx.cs" Inherits="WebPortal.Admin.BranchMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .bm-hero{background:linear-gradient(90deg,#1f3c88,#2575fc 60%,#1bc5e8);border-radius:15px;padding:18px 22px;color:#fff;margin-bottom:20px;box-shadow:0 8px 20px rgba(0,0,0,.12)}
        .bm-hero h4{margin:0 0 4px;font-weight:700}.bm-hero p{margin:0;font-size:13px;opacity:.9}
        .bm-card{background:#fff;border:1px solid #e5edf6;border-radius:15px;padding:18px;margin-bottom:18px;box-shadow:0 8px 24px rgba(15,23,42,.06)}
        .bm-form{display:flex;gap:10px;align-items:end;flex-wrap:wrap}.bm-field{flex:1;min-width:240px}.bm-field label{display:block;font-weight:600;margin-bottom:6px}.bm-field input{height:40px;border-radius:9px}
        .bm-toolbar{display:flex;justify-content:space-between;align-items:center;gap:12px;margin-bottom:14px}.bm-search{width:280px;max-width:100%;border:1px solid #dbe5f0;border-radius:9px;padding:9px 12px}
        .bm-table th{white-space:nowrap;background:#f5f8fc;color:#334155}.bm-empty{text-align:center;color:#64748b;padding:25px!important}.bm-alert{display:none;margin-bottom:15px}
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="bm-hero"><h4><i class="fas fa-code-branch mr-2"></i>Branch Master</h4><p>Create and manage organization branches.</p></div>
    <div id="message" class="alert bm-alert"></div>
    <div class="bm-card">
        <div class="bm-form">
            <div class="bm-field"><label for="branchName">Branch Name</label><input id="branchName" class="form-control" maxlength="100" placeholder="Enter branch name" /></div>
            <button id="saveButton" type="button" class="btn btn-primary" onclick="saveBranch()"><i class="fas fa-save mr-1"></i>Save</button>
            <button id="cancelButton" type="button" class="btn btn-light" onclick="cancelEdit()" style="display:none">Cancel</button>
        </div>
    </div>
    <div class="bm-card">
        <div class="bm-toolbar"><strong>Branch Details</strong><input id="branchSearch" class="bm-search" type="search" placeholder="Search branches..." /></div>
        <div class="table-responsive"><table class="table table-hover table-striped table-bordered bm-table"><thead><tr><th>Sr. #</th><th>Branch Name</th><th>Added By</th><th>Added DateTime</th><th>Actions</th></tr></thead><tbody id="branchBody"></tbody></table></div>
    </div>
    <script>
        var branches=[], editingId=0;
        function post(method,data){return fetch('BranchMaster.aspx/'+method,{method:'POST',headers:{'Content-Type':'application/json; charset=utf-8'},body:JSON.stringify(data||{})}).then(function(r){if(!r.ok)throw Error();return r.json()}).then(function(r){return r.d})}
        function text(row,key){return row[key]==null?'':String(row[key])}
        function dateTime(value){var m=String(value||'').match(/\/Date\((-?\d+)(?:[+-]\d+)?\)\//);if(!m)return value||'';return new Date(parseInt(m[1],10)).toLocaleString('en-IN',{day:'2-digit',month:'short',year:'numeric',hour:'2-digit',minute:'2-digit',hour12:true})}
        function notify(message,success){var el=document.getElementById('message');el.className='alert bm-alert '+(success?'alert-success':'alert-danger');el.textContent=message;el.style.display='block';setTimeout(function(){el.style.display='none'},5000)}
        function loadBranches(){post('GetBranches').then(function(data){branches=data||[];render()}).catch(function(){notify('Unable to load branches.',false)})}
        function render(){var term=document.getElementById('branchSearch').value.toLowerCase(),body=document.getElementById('branchBody');body.innerHTML='';var list=branches.filter(function(x){return text(x,'BranchName').toLowerCase().indexOf(term)>=0});if(!list.length){body.innerHTML='<tr><td colspan="5" class="bm-empty">No branches found.</td></tr>';return}list.forEach(function(row,i){var tr=body.insertRow();[i+1,text(row,'BranchName'),text(row,'AddedByName'),dateTime(row.AddedDate)].forEach(function(v){tr.insertCell().textContent=v});var actions=tr.insertCell();var edit=document.createElement('button');edit.className='btn btn-sm btn-primary mr-1';edit.innerHTML='<i class="fas fa-edit"></i> Edit';edit.onclick=function(){startEdit(row)};var del=document.createElement('button');del.className='btn btn-sm btn-danger';del.innerHTML='<i class="fas fa-trash"></i> Delete';del.onclick=function(){deleteBranch(row.BranchID)};actions.appendChild(edit);actions.appendChild(del)})}
        function startEdit(row){editingId=parseInt(row.BranchID,10);document.getElementById('branchName').value=text(row,'BranchName');document.getElementById('saveButton').innerHTML='<i class="fas fa-save mr-1"></i>Update';document.getElementById('cancelButton').style.display='inline-block';document.getElementById('branchName').focus()}
        function cancelEdit(){editingId=0;document.getElementById('branchName').value='';document.getElementById('saveButton').innerHTML='<i class="fas fa-save mr-1"></i>Save';document.getElementById('cancelButton').style.display='none'}
        function saveBranch(){var name=document.getElementById('branchName').value.trim();if(!name||!/^[a-zA-Z ]+$/.test(name)){notify('Please enter a valid branch name using letters only.',false);return}post('SaveBranch',{branchId:editingId,branchName:name}).then(function(result){if(result>0){notify(editingId?'Branch updated successfully.':'Branch added successfully.',true);cancelEdit();loadBranches()}else if(result===-1&&confirm('Branch already exists. Do you want to retrieve it?')){post('RestoreBranch',{branchName:name}).then(function(r){if(r===-3||r>0){notify('Branch restored successfully.',true);cancelEdit();loadBranches()}else notify('Unable to restore branch.',false)})}else notify('Branch already exists.',false)}).catch(function(){notify('Unable to save branch.',false)})}
        function deleteBranch(id){if(!confirm('Delete this branch?'))return;post('DeleteBranch',{branchId:parseInt(id,10)}).then(function(r){if(r>0){notify('Branch deleted successfully.',true);loadBranches()}else notify('Unable to delete branch.',false)}).catch(function(){notify('Unable to delete branch.',false)})}
        document.addEventListener('DOMContentLoaded',function(){document.getElementById('branchSearch').addEventListener('input',render);document.getElementById('branchName').addEventListener('keydown',function(e){if(e.key==='Enter')saveBranch()});loadBranches();document.getElementById('branchName').focus()});
    </script>
</asp:Content>
