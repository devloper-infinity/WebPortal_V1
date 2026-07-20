<%--<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProjectProcessSequence.aspx.cs" Inherits="WebPortal.ProjectProcessSequence" %>--%>

<%@ Page Title="ProjectProcessSequence" Language="C#" MasterPageFile="~/Tracking/Tracking.Master" AutoEventWireup="true" CodeBehind="ProjectProcessSequence.aspx.cs" Inherits="WebPortal.Tracking.ProjectProcessSequence" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <!-- Replace these references with your existing ERP local CSS/JS files. -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.8/css/jquery.dataTables.min.css" />
    <style>
        body {
            background: #f3f6fa;
            font-family: "Segoe UI",Arial,sans-serif;
            color: #29384a
        }

        .page-hero {
            background: linear-gradient(135deg,#355d8a,#527ba8);
            border-radius: 8px;
            padding: 17px 22px;
            color: #fff;
            box-shadow: 0 3px 12px rgba(36,69,105,.18);
            margin-bottom: 15px
        }

            .page-hero h3 {
                font-size: 22px;
                font-weight: 600;
                margin: 0 0 3px
            }

        .breadcrumb-line {
            font-size: 12px;
            opacity: .9
        }

        .erp-panel {
            background: #fff;
            border: 1px solid #dfe6ee;
            border-radius: 7px;
            box-shadow: 0 2px 8px rgba(30,55,80,.07);
            margin-bottom: 15px
        }

        .erp-panel-header {
            padding: 13px 17px;
            border-bottom: 1px solid #e1e7ee;
            font-size: 15px;
            font-weight: 600;
            color: #344b63
        }

        .erp-panel-body {
            padding: 17px
        }

        .filter-panel {
            background: #f8fafc;
            border: 1px solid #e2e8ef;
            border-radius: 6px;
            padding: 14px 14px 3px;
            margin-bottom: 14px
        }

        label {
            font-size: 12px;
            font-weight: 600;
            color: #46596d;
            margin-bottom: 5px
        }

        .form-control {
            height: 36px;
            border-color: #ccd6e1;
            font-size: 13px
        }

        .custom-control-label {
            font-size: 13px;
            font-weight: 500;
            padding-top: 1px
        }

        .btn {
            font-size: 13px;
            font-weight: 600;
            border-radius: 4px;
            padding: 7px 16px
        }

        .btn-erp {
            background: #315f91;
            border-color: #315f91;
            color: #fff
        }

            .btn-erp:hover {
                background: #284f79;
                color: #fff
            }

        .btn-clear {
            background: #fff;
            border: 1px solid #b8c4d0;
            color: #536579
        }

        .table-wrap {
            position: relative;
            border: 1px solid #dde5ed;
            border-radius: 5px;
            background: #fff;
            padding: 8px
        }

        .grid-loader {
            display: none;
            position: absolute;
            inset: 0;
            background: rgba(255,255,255,.76);
            z-index: 20;
            align-items: center;
            justify-content: center
        }

            .grid-loader.show {
                display: flex
            }

        table.dataTable thead th {
            background: #eaf0f6;
            color: #344b63;
            border-bottom: 1px solid #ccd7e2;
            font-size: 12px
        }

        table.dataTable tbody td {
            font-size: 12px;
            vertical-align: middle
        }

        .status {
            padding: 4px 9px;
            border-radius: 11px;
            background: #edf2f7;
            font-weight: 600
        }

        .edit-btn {
            padding: 4px 10px
        }

        .required {
            color: #c0392b
        }

        .form-note {
            font-size: 12px;
            color: #6b7c8f;
            margin-top: 7px
        }

        @media(max-width:768px) {
            .page-content {
                padding: 10px
            }

            .page-hero {
                padding: 14px
            }
        }
    </style>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>
    <script>
        var table;
        $(function () {
            table = $('#tblSequence').DataTable({ paging: false, scrollX: true, autoWidth: false, searching: false, ordering: false, info: true });
            loadProjects();
            $('#ddlProject').change(function () { loadProcesses(); loadGrid(); return false; });
            $('#btnSave').click(saveSequence);
            $('#btnClear').click(function () { clearEntry(false); });
        });

        function call(method, payload, success, complete) { $.ajax({ url: 'ProjectProcessSequence.aspx/' + method, type: 'POST', data: JSON.stringify(payload || {}), contentType: 'application/json; charset=utf-8', dataType: 'json', success: function (r) { success(r.d); }, error: function (x) { alert((x.responseJSON && x.responseJSON.Message) || 'Request failed.'); }, complete: complete }); }

        function loadProjects() { call('GetProjects', {}, function (rows) { var h = '<option value="">-- Select Project --</option>'; $.each(rows, function (_, r) { h += '<option value="' + r.ProjectID + '">' + esc(r.ProjectName) + '</option>'; }); $('#ddlProject').html(h); }); }

        function loadProcesses(selected) {  var projectID = $('#ddlProject').val(), sequenceID = nullable($('#hdnSequenceID').val()); $('#ddlProcess').html('<option value="">-- Select Process --</option>'); if (!projectID) return; call('GetProcesses', { projectID: parseInt(projectID, 10), sequenceID: sequenceID }, function (rows) { var h = '<option value="">-- Select Process --</option>'; $.each(rows, function (_, r) { h += '<option value="' + r.ProcessID + '">' + esc(r.ProcessName) + '</option>'; }); $('#ddlProcess').html(h); if (selected) $('#ddlProcess').val(selected); }); }

        function loadGrid() { var projectID = $('#ddlProject').val();  table.clear().draw(); if (!projectID) return; $('#gridLoader').addClass('show'); call('List', { projectID: parseInt(projectID, 10) }, function (rows) { $.each(rows, function (_, r) { table.row.add([r.SequenceNo, esc(r.ProjectName), esc(r.ProcessName), r.IsMandatory ? 'Yes' : 'No', '<span class="status">' + (r.IsActive ? 'Active' : 'Inactive') + '</span>', fmt(r.AddedDate), '<button type="button" class="btn btn-sm btn-erp edit-btn" onclick="editSequence(' + r.ProjectProcessSequenceID + ')">Edit</button>']); }); table.draw(); }, function () { $('#gridLoader').removeClass('show'); }); }

        function editSequence(id) { call('Get', { sequenceID: id }, function (r) { if (!r) return; $('#hdnSequenceID').val(r.ProjectProcessSequenceID); $('#ddlProject').val(r.ProjectID).prop('disabled', true); $('#txtSequenceNo').val(r.SequenceNo); $('#chkMandatory').prop('checked', r.IsMandatory); $('#chkActive').prop('checked', r.IsActive); loadProcesses(r.ProcessID); $('html,body').animate({ scrollTop: 0 }, 250); }); }

        function saveSequence() { var projectID = $('#ddlProject').val(), processID = $('#ddlProcess').val(), sequenceNo = parseInt($('#txtSequenceNo').val(), 10); if (!projectID) { alert('Select Project.'); return; } if (!processID) { alert('Select Process.'); return; } if (!sequenceNo || sequenceNo < 1) { alert('Enter a valid sequence number.'); return; } var input = { ProjectProcessSequenceID: nullable($('#hdnSequenceID').val()), ProjectID: parseInt(projectID, 10), ProcessID: parseInt(processID, 10), SequenceNo: sequenceNo, IsMandatory: $('#chkMandatory').is(':checked'), IsActive: $('#chkActive').is(':checked') }; $('#btnSave').prop('disabled', true).text('Saving...'); call('Save', { input: input }, function (r) { alert(r.Message); if (r.IsSuccess) { var p = projectID; clearEntry(true); $('#ddlProject').val(p); loadProcesses(); loadGrid(); } }, function () { $('#btnSave').prop('disabled', false).text('Save'); }); }

        function clearEntry(keepProject) { var p = keepProject ? $('#ddlProject').val() : ''; $('#hdnSequenceID').val(''); $('#ddlProject').prop('disabled', false); if (!keepProject) $('#ddlProject').val(''); $('#ddlProcess').html('<option value="">-- Select Process --</option>'); $('#txtSequenceNo').val(''); $('#chkMandatory,#chkActive').prop('checked', true); if (keepProject) { $('#ddlProject').val(p); loadProcesses(); } }

        function nullable(v) { return v ? parseInt(v, 10) : null; } function esc(v) { return $('<div/>').text(v == null ? '' : v).html(); } function fmt(v) { if (!v) return ''; var d = new Date(v); return isNaN(d) ? v : d.toLocaleString(); }
</script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <%-- <div class="page-content"></div>--%>
    <div class="page-hero">
        <h3>Project Process Sequence</h3>
        <div class="breadcrumb-line">Masters / Project Process Sequence</div>
    </div>

    <div class="erp-panel">
        <div class="erp-panel-header">Add / Edit Process Sequence</div>
        <div class="erp-panel-body">
            <input type="hidden" id="hdnSequenceID" />
            <div class="filter-panel">
                <div class="form-row">
                    <div class="form-group col-md-4">
                        <label>Project <span class="required">*</span></label>
                        <select id="ddlProject" class="form-control"></select>
                    </div>
                    <div class="form-group col-md-4">
                        <label>Process <span class="required">*</span></label>
                        <select id="ddlProcess" class="form-control">
                            <option value="">-- Select Process --</option>
                        </select>
                    </div>
                    <div class="form-group col-md-2">
                        <label>Sequence No. <span class="required">*</span></label>
                        <input type="number" id="txtSequenceNo" min="1" class="form-control" />
                    </div>
                    <div class="form-group col-md-2 pt-md-4">
                        <div class="custom-control custom-checkbox mb-2">
                            <input type="checkbox" class="custom-control-input" id="chkMandatory" checked="checked" />
                            <label class="custom-control-label" for="chkMandatory">Mandatory</label>
                        </div>
                        <div class="custom-control custom-checkbox">
                            <input type="checkbox" class="custom-control-input" id="chkActive" checked="checked" />
                            <label class="custom-control-label" for="chkActive">Active</label>
                        </div>
                    </div>
                </div>
            </div>
            <button type="button" id="btnSave" class="btn btn-erp">Save</button>
            <button type="button" id="btnClear" class="btn btn-clear">Clear</button>
            <div class="form-note">Changing a sequence number automatically reorders the other configured processes.</div>
        </div>
    </div>

    <div class="erp-panel">
        <div class="erp-panel-header">Configured Process Flow</div>
        <div class="erp-panel-body">
            <div class="table-wrap">
                <div id="gridLoader" class="grid-loader">
                    <div class="spinner-border text-primary"></div>
                </div>
                <table id="tblSequence" class="display nowrap" style="width: 100%">
                    <thead>
                        <tr>
                            <th>Sequence</th>
                            <th>Project</th>
                            <th>Process</th>
                            <th>Mandatory</th>
                            <th>Status</th>
                            <th>Added Date</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>



</asp:Content>
