<%@ Page Title="Diwali Expenses" Language="C#" MasterPageFile="~/Accounts/Accounts.Master" AutoEventWireup="true" CodeBehind="DiwaliExpenses.aspx.cs" Inherits="WebPortal.Accounts.DiwaliExpenses" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .de-page { padding:12px 15px 25px; }
        .de-panel { background:#fff; border:1px solid #e4e8ee; border-radius:7px; margin-bottom:15px; box-shadow:0 1px 4px rgba(0,0,0,.05); }
        .de-panel-title { padding:11px 15px; border-bottom:1px solid #e8ebef; font-weight:600; color:#33445c; background:#f8fafc; }
        .de-panel-body { padding:15px; }
        .de-label { display:block; font-size:12px; font-weight:600; color:#536174; margin-bottom:5px; }
        .de-table-wrap { width:100%; overflow-x:auto; }
        .de-table thead th { white-space:nowrap; background:#5a78a8; color:#fff; font-size:12px; text-align:center; }
        .de-table tbody td, .de-table tfoot th { white-space:nowrap; font-size:12px; vertical-align:middle; }
        .de-table tfoot th { background:#eaf0f8; color:#33445c; font-weight:700; }
        .de-empty { padding:28px; text-align:center; color:#778397; }
        .de-help { color:#6c7889; font-size:12px; margin-top:7px; }
        .de-money { text-align:right; }
        #deLoader { display:none; position:fixed; inset:0; z-index:99999; background:rgba(255,255,255,.72); }
        #deLoader div { position:absolute; top:50%; left:50%; transform:translate(-50%,-50%); text-align:center; font-size:12px; font-weight:600; color:#33445c; }
        #deLoader img { display:block; width:70px; margin:0 auto 8px; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="deLoader"><div><img src="../images/Load_1.gif" alt="Loading" />One moment, please...</div></div>
    <div class="de-page">
        <div class="content-header"><div class="container"><div class="row mb-2 callout callout-info"><div class="col-sm-8">
            <h6 class="m-0"><i class="fas fa-coins"></i>&nbsp;&nbsp;<b>Diwali Expenses</b></h6>
        </div></div></div></div>

        <div class="de-panel">
            <div class="de-panel-title">Year and Excel Import</div>
            <div class="de-panel-body">
                <div class="row align-items-end">
                    <div class="col-md-2"><label class="de-label" for="deYear">Display year</label><select id="deYear" class="form-control"></select></div>
                    <div class="col-md-2"><button type="button" id="deShow" class="btn btn-primary btn-block"><i class="fas fa-search mr-1"></i>Show</button></div>
                    <div class="col-md-2"><label class="de-label" for="deImportYear">Import year</label><input id="deImportYear" type="number" min="2000" max="2100" class="form-control" /></div>
                    <div class="col-md-4"><label class="de-label" for="deFile">Expense workbook (.xlsx)</label><input id="deFile" type="file" accept=".xlsx" class="form-control-file" /></div>
                    <div class="col-md-2"><button type="button" id="deImport" class="btn btn-success btn-block"><i class="fas fa-file-import mr-1"></i>Import</button></div>
                </div>
                <div class="row mt-3"><div class="col-md-2 offset-md-2"><button type="button" id="deExport" class="btn btn-outline-success btn-block"><i class="fas fa-file-excel mr-1"></i>Export All Tabs</button></div></div>
                <div class="de-help">Importing a year replaces that year's existing Diwali expense data after the entire workbook passes validation.</div>
            </div>
        </div>

        <div id="deNoData" class="de-panel" style="display:none;">
            <div class="de-empty">
                <i class="fas fa-file-excel fa-2x mb-2"></i><br />
                No Diwali expense data has been imported yet.<br />
                Select the expense workbook above and click <b>Import</b>. The year will be detected from the file name when possible.
            </div>
        </div>

        <div id="deResults" style="display:none;">
            <ul class="nav nav-tabs" id="deTabs" role="tablist">
                <li class="nav-item"><a class="nav-link active" data-toggle="tab" href="#deSummary">Summary</a></li>
                <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#deGeneral">General Expenses</a></li>
                <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#deFood">Food</a></li>
                <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#deSweets">Sweets</a></li>
                <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#deCoins">Silver Coins</a></li>
                <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#deGifts">Senior Gifts</a></li>
                <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#deDistribution">Distribution Summary</a></li>
                <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#deEmployees">Employee Distribution</a></li>
            </ul>
            <div class="tab-content de-panel">
                <div id="deSummary" class="tab-pane fade show active de-panel-body"><div class="de-table-wrap"><table class="table table-bordered de-table"></table></div></div>
                <div id="deGeneral" class="tab-pane fade de-panel-body"><div class="de-table-wrap"><table class="table table-bordered de-table"></table></div></div>
                <div id="deFood" class="tab-pane fade de-panel-body"><div class="de-table-wrap"><table class="table table-bordered de-table"></table></div></div>
                <div id="deSweets" class="tab-pane fade de-panel-body"><div class="de-table-wrap"><table class="table table-bordered de-table"></table></div></div>
                <div id="deCoins" class="tab-pane fade de-panel-body"><div class="de-table-wrap"><table class="table table-bordered de-table"></table></div></div>
                <div id="deGifts" class="tab-pane fade de-panel-body"><div class="de-table-wrap"><table class="table table-bordered de-table"></table></div></div>
                <div id="deDistribution" class="tab-pane fade de-panel-body"><div class="de-table-wrap"><table class="table table-bordered de-table"></table></div></div>
                <div id="deEmployees" class="tab-pane fade de-panel-body"><div class="de-table-wrap"><table class="table table-bordered de-table"></table></div></div>
            </div>
        </div>
    </div>

    <script>
        var deTables = [];
        $(function () {
            deLoadYears();
            $('#deShow').on('click', deLoad);
            $('#deImport').on('click', deImport);
            $('#deExport').on('click', function(){var year=parseInt($('#deYear').val(),10);if(!year){deNotify('Select a year with imported data.');return;}window.location='DiwaliExpenses.aspx?export=1&year='+encodeURIComponent(year);});
            $('#deFile').on('change', function () {
                var file=this.files&&this.files[0], match=file&&file.name.match(/(?:19|20)\d{2}/);
                if(match) $('#deImportYear').val(match[0]);
            });
            $('a[data-toggle="tab"]').on('shown.bs.tab', function () { $.each(deTables, function (_, t) { t.columns.adjust(); }); });
        });
        function deCall(method, payload) { return $.ajax({ type:'POST', url:'DiwaliExpenses.aspx/' + method, data:JSON.stringify(payload || {}), contentType:'application/json; charset=utf-8', dataType:'json' }).then(function(r){ return r.d; }); }
        function deNotify(message, type) { if (window.toastr) toastr[type || 'warning'](message); else alert(message); }
        function deError(xhr) { var m=xhr.responseJSON&&xhr.responseJSON.Message?xhr.responseJSON.Message:'Unable to complete the request.'; deNotify(m,'error'); }
        function deLoadYears(selected) {
            deCall('GetYears', {}).done(function(years){
                years=years||[]; var s=$('#deYear').empty();
                if(!years.length){s.append($('<option/>').val('').text('No data imported'));$('#deResults').hide();$('#deNoData').show();return;}
                $.each(years,function(_,y){s.append($('<option/>').val(y).text(y));}); if(selected)s.val(selected);
                $('#deNoData').hide(); if(s.val()){ $('#deImportYear').val(s.val()); deLoad(); }
            }).fail(deError);
        }
        function deLoad() {
            var year=parseInt($('#deYear').val(),10); if(!year)return;
            $('#deLoader').show(); deCall('GetExpenses',{year:year}).done(function(r){
                deGrid('#deSummary table', r.Summary, [{title:'Sr. No.',data:'SerialNo'},{title:'Particular',data:'Particular'},{title:'Amount',data:'Amount',render:deAmount,className:'de-money'},{title:'Remark',data:'Remark'}]);
                var expenseCols=[{title:'Sr. No.',data:'SerialNo'},{title:'Date',data:'ExpenseDate'},{title:'Particular',data:'Particular'},{title:'Location',data:'Location'},{title:'Count',data:'Quantity'},{title:'Rate',data:'Rate',render:deAmount,className:'de-money'},{title:'Amount',data:'Amount',render:deAmount,className:'de-money'},{title:'Remark',data:'Remark'}];
                deGrid('#deGeneral table',deItems(r.Items,'General Expense'),expenseCols); deGrid('#deFood table',deItems(r.Items,'Food Arrangement'),expenseCols); deGrid('#deSweets table',deItems(r.Items,'Sweet Boxes'),expenseCols); deGrid('#deCoins table',deItems(r.Items,'Silver Coins'),expenseCols); deGrid('#deGifts table',deItems(r.Items,'Senior Gifts'),expenseCols);
                deGrid('#deDistribution table',deItems(r.Items,'Distribution Summary'),[{title:'Branch',data:'Location'},{title:'Item',data:'Particular'},{title:'Quantity',data:'Quantity'},{title:'Rate',data:'Rate',render:deAmount,className:'de-money'},{title:'Amount',data:'Amount',render:deAmount,className:'de-money'}]);
                deGrid('#deEmployees table',deItems(r.Items,'Employee Distribution'),[{title:'Sr. No.',data:'SerialNo'},{title:'Code',data:'EmployeeCode'},{title:'Name',data:'EmployeeName'},{title:'Branch',data:'Branch'},{title:'Sweet Box',data:'SweetBoxStatus'},{title:'Gift',data:'GiftStatus'},{title:'Silver Coin',data:'SilverCoinStatus'},{title:'Remark',data:'Remark'}]);
                $('#deResults').show();
            }).fail(deError).always(function(){$('#deLoader').hide();});
        }
        function deItems(rows,category){return $.grep(rows||[],function(x){return x.Category===category;});}
        function deAmount(v){ if(v===null||v===undefined||v==='')return ''; return Number(v).toLocaleString('en-IN',{minimumFractionDigits:2,maximumFractionDigits:2}); }
        function deGrid(selector,rows,columns){
            rows=rows||[]; if($.fn.DataTable.isDataTable(selector))$(selector).DataTable().clear().destroy(); $(selector).empty();
            var cells=[], amountIndex=-1, quantityIndex=-1; for(var i=0;i<columns.length;i++){cells.push('');if(columns[i].data==='Amount')amountIndex=i;if(columns[i].data==='Quantity')quantityIndex=i;}
            cells[0]='Total'; if(cells.length>1)cells[1]='Count: '+rows.length;
            if(quantityIndex>=0){var qty=0,$hasQty=false;$.each(rows,function(_,r){if(r.Quantity!==null&&r.Quantity!==undefined&&r.Quantity!==''){$hasQty=true;qty+=parseFloat(r.Quantity)||0;}});if($hasQty)cells[quantityIndex]=qty.toLocaleString('en-IN',{maximumFractionDigits:2});}
            if(amountIndex>=0){var amount=0,totalRow=null;$.each(rows,function(_,r){if(/^(grand total|total diwali expenses)$/i.test(String(r.Particular||'').trim()))totalRow=r;});if(totalRow)amount=parseFloat(totalRow.Amount)||0;else $.each(rows,function(_,r){amount+=parseFloat(r.Amount)||0;});cells[amountIndex]=deAmount(amount);}
            var foot='<tfoot><tr>';$.each(cells,function(_,v){foot+='<th>'+deHtml(v)+'</th>';});foot+='</tr></tfoot>';$(selector).append(foot);
            var t=$(selector).DataTable({data:rows,columns:columns,pageLength:10,lengthMenu:[[10,25,50,100,-1],[10,25,50,100,'All']],searching:true,paging:true,ordering:true,autoWidth:false,scrollX:true,columnDefs:[{targets:'_all',defaultContent:''}],language:{emptyTable:'No data available'}}); deTables.push(t);
        }
        function deHtml(v){return $('<div/>').text(v==null?'':v).html();}
        function deImport(){
            var year=parseInt($('#deImportYear').val(),10), input=$('#deFile')[0], file=input.files&&input.files[0];
            if(!year||year<2000||year>2100){deNotify('Enter a valid import year.');return;} if(!file){deNotify('Select an .xlsx workbook.');return;} if(!/\.xlsx$/i.test(file.name)){deNotify('Only .xlsx workbooks are supported.');return;}
            var form=new FormData(); form.append('file',file); form.append('year',year);
            $('#deLoader').show(); $.ajax({url:'DiwaliExpenses.aspx?action=import',type:'POST',data:form,processData:false,contentType:false,dataType:'json'}).done(function(r){if(!r.success){deNotify(r.message||'Import failed.','error');return;} deNotify(r.message,'success'); input.value=''; deLoadYears(year);}).fail(deError).always(function(){$('#deLoader').hide();});
        }
    </script>
</asp:Content>
