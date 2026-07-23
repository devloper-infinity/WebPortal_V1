<%@ Page Title="" Language="C#" MasterPageFile="~/Feedback/Feedback.Master" AutoEventWireup="true" CodeBehind="SectionAndFieldMaster.aspx.cs" Inherits="WebPortal.Feedback.SectionAndFieldMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
          .loading {
      display: none;
      position: fixed;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      width: 170px;
      min-height: 155px;
      z-index: 99999;
      background: rgba(255,255,255,.96);
      border-radius: 22px;
      box-shadow: 0 18px 50px rgba(15,23,42,.18);
      text-align: center;
      padding: 22px 14px;
      color: #0f172a;
      font-size: 12px;
      font-weight: 800;
  }

      .loading img {
          max-width: 78px;
          display: block;
          margin: 0 auto 10px;
      }
        .fb-page { color: #172737; font-size: 13px; padding: 0px 0 28px; }
        .fb-hero { align-items: center; background: linear-gradient(135deg, #0f766e 0%, #1d4ed8 100%); border-radius: 8px; color: #fff; display: flex; justify-content: space-between; margin-bottom: 16px; padding: 20px 22px; }
        .fb-title { font-size: 22px; font-weight: 800; margin: 0; }
        .fb-subtitle { color: rgba(255,255,255,.9); font-size: 12px; margin: 6px 0 0; }
        .fb-panel { background: #fff; border: 1px solid #dce5ec; border-radius: 8px; margin-bottom: 16px; overflow: hidden; }
        .fb-panel-header { align-items: center; border-bottom: 1px solid #e7edf2; display: flex; justify-content: space-between; padding: 14px 16px; }
        .fb-panel-title { font-size: 15px; font-weight: 800; margin: 0; }
        .fb-panel-body { padding: 16px; }
        .fb-grid-form { display: grid; gap: 12px 14px; grid-template-columns: repeat(5, minmax(0, 1fr)); }
        .fb-field label { color: #46596b; display: block; font-size: 12px; font-weight: 700; margin-bottom: 5px; }
        .fb-field .form-control { border-color: #cfdbe5; border-radius: 6px; font-size: 13px; min-height: 36px; width: 100%; }
        .fb-actions { align-items: end; display: flex; gap: 8px; }
        .fb-btn { border: 1px solid transparent; border-radius: 6px; cursor: pointer; font-size: 13px; font-weight: 800; min-height: 36px; padding: 7px 13px; }
        .fb-btn-primary { background: #0f766e; border-color: #0f766e; color: #fff; }
        .fb-btn-light { background: #eef3f7; border-color: #d6e1ea; color: #17324d; }
        .fb-btn-danger { background: #b42318; border-color: #b42318; color: #fff; }
        .fb-message { display: none; font-weight: 700; margin-bottom: 12px; padding: 10px 12px; }
        .fb-message.success { background: #e8f7ef; border: 1px solid #b7e2c8; color: #136c34; }
        .fb-message.error { background: #fff1f0; border: 1px solid #ffc9c4; color: #b42318; }
        .fb-table-wrap { overflow-x: auto; padding: 0 16px 16px; }
        .table.dataTable thead th { background: #edf3f6 !important; color: #263747; font-size: 12px; text-align: center; white-space: nowrap; }
        .table.dataTable tbody td { font-size: 12px; vertical-align: middle; }
        @media (max-width: 1100px) { .fb-grid-form { grid-template-columns: repeat(2, minmax(0, 1fr)); } }
        @media (max-width: 700px) { .fb-hero, .fb-panel-header { align-items: flex-start; flex-direction: column; gap: 10px; } .fb-grid-form { grid-template-columns: 1fr; } }
    </style>
    <script type="text/javascript">
        var sectionFieldTable = null;

        $(document).ready(function () {
            $('#sfDomain').on('change', function () { loadProjects($(this).val()); });
            $('#sfSave').on('click', saveSectionField);
            $('#sfClear').on('click', clearForm);
            loadDomains();
            loadSectionFields();
        });

        function sfPageMethod(method, data, done) {
            $.ajax({
                type: 'POST',
                url: 'SectionAndFieldMaster.aspx/' + method,
                data: JSON.stringify(data || {}),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (res) { if (done) done(res.d); },
                error: function (xhr) { showMessage('error', ajaxError(xhr)); }
            });
        }

        function loadDomains() {
            sfPageMethod('GetDomains', {}, function (rows) {
                fillSelect('#sfDomain', rows, 'DomainID', 'DomainName', 'Select');
            });
        }

        function loadProjects(domainId, selectedProject) {
            if (!domainId) { fillSelect('#sfProject', [], 'ProjectID', 'ProjectName', 'Select'); return; }
            sfPageMethod('GetProjects', { domainId: parseInt(domainId, 10) || 0 }, function (rows) {
                fillSelect('#sfProject', rows, 'ProjectID', 'ProjectName', 'Select');
                if (selectedProject) $('#sfProject').val(selectedProject);
            });
        }

        function loadSectionFields() {
            sfPageMethod('GetSectionFields', {}, function (rows) {
                rows = rows || [];
                if (sectionFieldTable) sectionFieldTable.destroy();
                var tbody = $('#sfTable tbody').empty();
                $.each(rows, function (i, row) {
                    $('<tr/>')
                        //.append('<td><button type="button" class="fb-btn fb-btn-light" onclick="editRow(' + i + ')">Edit</button> <button type="button" class="fb-btn fb-btn-danger" onclick="deleteRow(' + valueOf(row, ['SectionFieldID', 'ID']) + ')">Delete</button></td>')
                        .append(
                            '<td class="text-center">' +
                            '<a href="javascript:void(0);" onclick="editRow(' + i + ')" title="Edit">' +
                            '<i class="fa fa-edit text-primary" style="font-size:16px;margin-right:10px;cursor:pointer;"></i>' +
                            '</a>' +
                            '<a href="javascript:void(0);" onclick="deleteRow(' + valueOf(row, ['SectionFieldID', 'ID']) + ')" title="Delete">' +
                            '<i class="fa fa-trash text-danger" style="font-size:16px;cursor:pointer;"></i>' +
                            '</a>' +
                            '</td>'
                        )
                        .append($('<td/>').text(i + 1))
                        .append($('<td/>').text(valueOf(row, ['Domain', 'DomainName'])))
                        .append($('<td/>').text(valueOf(row, ['Project', 'ProjectName'])))
                        .append($('<td/>').text(valueOf(row, ['Section'])))
                        .append($('<td/>').text(valueOf(row, ['FieldName', 'Field'])))
                        .append($('<td/>').text(valueOf(row, ['Weightage'])))
                        .append($('<td/>').text(valueOf(row, ['AddedByName', 'AddedBy'])))
                        .append($('<td/>').text(valueOf(row, ['AddedDate'])))
                        .data('row', row)
                        .appendTo(tbody);
                });
                sectionFieldTable = $('#sfTable').DataTable({ responsive: true, pageLength: 10, dom: 'Bfrtip', buttons: ['excelHtml5', 'pdfHtml5', 'print'] });
            });
        }

        function saveSectionField() {
            $('#load1').show();

            var model = {
                SectionFieldID: parseInt($('#sfId').val() || '0', 10),
                DomainID: parseInt($('#sfDomain').val() || '0', 10),
                ProjectID: parseInt($('#sfProject').val() || '0', 10),
                Section: $.trim($('#sfSection').val()),
                FieldName: $.trim($('#sfFieldName').val()),
                Weightage: $.trim($('#sfWeightage').val())
            };
            if (!model.DomainID) return showMessage('error', 'Please select Domain.');
            if (!model.ProjectID) return showMessage('error', 'Please select Project.');
            if (!model.Section) return showMessage('error', 'Please enter Section.');
            if (!model.FieldName) return showMessage('error', 'Please enter Field Name.');
            if (!model.Weightage) return showMessage('error', 'Please enter Weightage.');

            sfPageMethod('SaveSectionField', { model: model }, function (result) {
                showMessage(result.Success ? 'success' : 'error', result.Message);
                
                if (result.Success) { clearForm(); loadSectionFields(); $('#load1').hide(); }
            });
        }

        function editRow(index) {
            var row = $('#sfTable tbody tr').eq(index).data('row');
            $('#sfId').val(valueOf(row, ['SectionFieldID', 'ID']));
            $('#sfDomain').val(valueOf(row, ['DomainID']));
            loadProjects(valueOf(row, ['DomainID']), valueOf(row, ['ProjectID']));
            $('#sfSection').val(valueOf(row, ['Section']));
            $('#sfFieldName').val(valueOf(row, ['FieldName', 'Field']));
            $('#sfWeightage').val(valueOf(row, ['Weightage']));
            $('#sfSave').text('Update');
            window.scrollTo(0, 0);
        }

        function deleteRow(id) {
            if (!id || !confirm('Delete this section and field?')) return;
            sfPageMethod('DeleteSectionField', { id: id }, function (result) {
                showMessage(result.Success ? 'success' : 'error', result.Message);
                if (result.Success) loadSectionFields();
            });
        }

        function clearForm() {
            $('#sfId').val('0');
            $('#sfDomain,#sfProject').val('');
            $('#sfSection,#sfFieldName,#sfWeightage').val('');
            $('#sfSave').text('Submit');
        }

        function fillSelect(selector, rows, valueKey, textKey, firstText) {
            var ddl = $(selector).empty();
            $('<option/>').val('').text(firstText || 'Select').appendTo(ddl);
            $.each(rows || [], function (_, row) {
                $('<option/>').val(valueOf(row, [valueKey])).text(valueOf(row, [textKey])).appendTo(ddl);
            });
        }

        function valueOf(row, keys) {
            for (var i = 0; i < keys.length; i++) if (row && row[keys[i]] !== undefined && row[keys[i]] !== null) return row[keys[i]];
            return '';
        }

        function showMessage(type, message) {
            $('#sfMessage').removeClass('success error').addClass(type).text(message).show();
            setTimeout(function () { $('#sfMessage').fadeOut(); }, 4500);
        }

        function ajaxError(xhr) {
            try { return xhr.responseJSON.Message || xhr.responseText || 'Unexpected error occurred.'; } catch (e) { return 'Unexpected error occurred.'; }
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
           <div class="loading" id="load1">
    <img src="../images/Load_1.gif" />
    <div>One moment, please . . . .</div>
</div>
    <div class="fb-page">
        <div class="fb-hero">
            <div>
                <h1 class="fb-title">Section And Field Master</h1>
                <p class="fb-subtitle">Configure feedback sections, fields, and weightage for this domain.</p>
            </div>
        </div>

        <div id="sfMessage" class="fb-message"></div>

        <div class="fb-panel">
            <div class="fb-panel-header">
                <h2 class="fb-panel-title">Section Field Details</h2>
            </div>
            <div class="fb-panel-body">
                <input id="sfId" type="hidden" value="0" />
                <div class="fb-grid-form">
                    <div class="fb-field">
                        <label for="sfDomain">Domain</label>
                        <select id="sfDomain" class="form-control"></select>
                    </div>
                    <div class="fb-field">
                        <label for="sfProject">Project</label>
                        <select id="sfProject" class="form-control"></select>
                    </div>
                    <div class="fb-field">
                        <label for="sfSection">Section</label>
                        <input id="sfSection" type="text" class="form-control" />
                    </div>
                    <div class="fb-field">
                        <label for="sfFieldName">Field Name</label>
                        <input id="sfFieldName" type="text" class="form-control" />
                    </div>
                    <div class="fb-field">
                        <label for="sfWeightage">Weightage</label>
                        <input id="sfWeightage" type="text" class="form-control" />
                    </div>
                    <div class="fb-actions">
                        <button id="sfSave" type="button" class="fb-btn fb-btn-primary">Submit</button>
                        <button id="sfClear" type="button" class="fb-btn fb-btn-light">Clear</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="fb-panel">
            <div class="fb-panel-header">
                <h2 class="fb-panel-title">Configured Fields</h2>
            </div>
            <div class="fb-table-wrap">
                <table id="sfTable" class="table table-bordered table-striped" style="width: 100%;">
                    <thead>
                        <tr>
                            <th>Action</th>
                            <th>Sr. #</th>
                            <th>Domain</th>
                            <th>Project</th>
                            <th>Section</th>
                            <th>Field Name</th>
                            <th>Weightage</th>
                            <th>Added By</th>
                            <th>Added DateTime</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
