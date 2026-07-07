<%@ Page Title="" Language="C#" MasterPageFile="~/Feedback/Feedback.Master" AutoEventWireup="true" CodeBehind="AddFeedbackForSearchProject.aspx.cs" Inherits="WebPortal.Feedback.AddFeedbackForSearchProject" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .fb-page {
            color: #172737;
            font-size: 13px;
            padding: 18px 0 28px;
        }

        .fb-hero {
            align-items: center;
            background: linear-gradient(135deg, #0f766e 0%, #1d4ed8 100%);
            border-radius: 8px;
            color: #fff;
            display: flex;
            justify-content: space-between;
            margin-bottom: 16px;
            padding: 20px 22px;
        }

        .fb-title {
            font-size: 22px;
            font-weight: 800;
            margin: 0;
        }

        .fb-subtitle {
            color: rgba(255,255,255,.9);
            font-size: 12px;
            margin: 6px 0 0;
        }

        .fb-panel {
            background: #fff;
            border: 1px solid #dce5ec;
            border-radius: 8px;
            margin-bottom: 16px;
            overflow: hidden;
        }

        .fb-panel-header {
            align-items: center;
            border-bottom: 1px solid #e7edf2;
            display: flex;
            justify-content: space-between;
            padding: 14px 16px;
        }

        .fb-panel-title {
            font-size: 15px;
            font-weight: 800;
            margin: 0;
        }

        .fb-panel-body {
            padding: 16px;
        }

        .fb-grid-form {
            display: grid;
            gap: 12px 14px;
            grid-template-columns: repeat(3, minmax(0, 1fr));
        }

        .fb-field label {
            color: #46596b;
            display: block;
            font-size: 12px;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .fb-field .form-control {
            border-color: #cfdbe5;
            border-radius: 6px;
            font-size: 13px;
            min-height: 36px;
            width: 100%;
        }

        textarea.form-control {
            min-height: 74px;
            resize: vertical;
        }

        .fb-span-2 {
            grid-column: span 2;
        }

        .fb-span-3 {
            grid-column: span 3;
        }

        .fb-actions {
            align-items: center;
            border-top: 1px solid #e7edf2;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 16px;
            padding-top: 14px;
        }

        .fb-btn {
            border: 1px solid transparent;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 800;
            min-height: 36px;
            padding: 7px 13px;
        }

        .fb-btn-primary {
            background: #0f766e;
            border-color: #0f766e;
            color: #fff;
        }

        .fb-btn-light {
            background: #eef3f7;
            border-color: #d6e1ea;
            color: #17324d;
        }

        .fb-message {
            display: none;
            font-weight: 700;
            margin-bottom: 12px;
            padding: 10px 12px;
        }

            .fb-message.success {
                background: #e8f7ef;
                border: 1px solid #b7e2c8;
                color: #136c34;
            }

            .fb-message.error {
                background: #fff1f0;
                border: 1px solid #ffc9c4;
                color: #b42318;
            }

        .fb-progress {
            color: #5d6f80;
            font-weight: 800;
        }

        .fb-table-wrap {
            overflow-x: auto;
            padding: 0 16px 16px;
        }

        .table.dataTable thead th, .fb-mini-table th {
            background: #edf3f6 !important;
            color: #263747;
            font-size: 12px;
            text-align: center;
            white-space: nowrap;
        }

        .table.dataTable tbody td, .fb-mini-table td {
            font-size: 12px;
            vertical-align: middle;
        }

        @media (max-width: 980px) {
            .fb-grid-form {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .fb-span-3 {
                grid-column: span 2;
            }
        }

        @media (max-width: 640px) {
            .fb-hero, .fb-panel-header {
                align-items: flex-start;
                flex-direction: column;
                gap: 10px;
            }

            .fb-grid-form, .fb-span-2, .fb-span-3 {
                display: block;
                grid-column: auto;
            }

            .fb-field {
                margin-bottom: 12px;
            }
        }
    </style>
    <script type="text/javascript">
        var afContext = { Mode: 'New', Index: 0, Total: 0, BackUrl: 'ViewAllFeedbackByUserWise.aspx' };
        var recentTable = null;

        $(document).ready(function () {
            $('.fb-date').datepicker({ dateFormat: 'dd-M-yy', changeMonth: true, changeYear: true });
            $('#afProject').on('change', function () { loadProcesses($(this).val()); loadSections($(this).val()); });
            $('#afSection').on('change', function () { loadFields($('#afProject').val(), $(this).val()); });
            $('#afErrorType').on('change', syncErrorTypeState);
            $('#afFeedbackType').on('change', syncFeedbackTypeState);
            $('#afSave').on('click', saveFeedback);
            $('#afClear').on('click', clearFeedbackOnly);
            $('#afBack').on('click', function () { window.location.href = afContext.BackUrl || 'ViewAllFeedbackByUserWise.aspx'; });
            loadPageContext();
        });

        function afPageMethod(method, data, done) {
            $.ajax({
                type: 'POST',
                url: 'AddFeedbackForSearchProject.aspx/' + method,
                data: JSON.stringify(data || {}),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (res) { if (done) done(res.d); },
                error: function (xhr) { showMessage('error', ajaxError(xhr)); }
            });
        }

        function loadPageContext() {
            afPageMethod('GetPageContext', {}, function (ctx) {
                afContext = ctx || afContext;
                fillSelect('#afProject', afContext.Projects, ['ProjectID', 'ProjectId'], ['ProjectName'], 'Select');
                $('#afFeedbackGivenBy').val(afContext.CurrentUserCode || '');
                $('#afOrderDate').val(afContext.Today || '');
                $('#afMode').val(afContext.Mode || 'New');
                $('#afSourceEmployeeID').val(afContext.SourceEmployeeID || '');
                $('#afSourceFatal').val(afContext.Fatal || '');
                $('#afSourceOrderNo').val(afContext.OrderNo || '');
                $('#afProgress').text(progressText());
                setStatusPanels();
                bindRecentOrders(afContext.NewOrders || []);

                if (afContext.Record) bindRecord(afContext.Record);
                else syncErrorTypeState();
            });
        }

        function bindRecord(row) {
            $('#afFeedDetailsId').val(valueOf(row, ['FeedDetailsId']));
            $('#afOrderNo').val(valueOf(row, ['OrderNo']));
            $('#afOrderDate').val(valueOf(row, ['OrderDate']));
            $('#afProject').val(valueOf(row, ['ProjectID', 'ProjectId']));
            $('#afErrorDoneBy').val(valueOf(row, ['ErrorDoneBY', 'ErrorDoneBy']));
            $('#afFeedbackGivenBy').val(valueOf(row, ['FeedbackBy', 'FeedbackGivenBy']) || afContext.CurrentUserCode || '');
            $('#afErrorType').val(valueOf(row, ['ErrorType']) || 'Select');
            $('#afFatalType').val(valueOf(row, ['Critical', 'Fatal']) || 'Select');
            $('#afErrorField').val(valueOf(row, ['FeildName', 'ErrorField']));
            $('#afError').val(valueOf(row, ['Error']));
            $('#afShouldBe').val(valueOf(row, ['ShouldBe']));
            $('#afFeedbackType').val(valueOf(row, ['FeedbackType']) || 'Select');
            $('#afFeedbackReceivedDate').val(valueOf(row, ['FeedbackRecivedDate', 'FeedbackReceivedDate']));
            $('#afRemark').val(valueOf(row, ['Remark']));
            $('#afEDBStatus').val(valueOf(row, ['EDBStatus']) || 'Select');
            $('#afEDBExplanation').val(valueOf(row, ['EDBRemark', 'EDBExplanation']));
            $('#afPMStatus').val(valueOf(row, ['PMStatus']) || 'Select');
            $('#afPMRemark').val(valueOf(row, ['PMRemark', 'PMExplanation']));

            var projectId = $('#afProject').val();
            loadProcesses(projectId, valueOf(row, ['ProcessID', 'ProcessId']));
            loadSections(projectId, valueOf(row, ['Section']), valueOf(row, ['Field']));
            setReadOnly(afContext.IsReadOnly === true);
            syncErrorTypeState();
            syncFeedbackTypeState();
        }

        function loadProcesses(projectId, selectedValue) {
            fillSelect('#afProcess', [], ['ProcessID'], ['ProcessName'], 'Select');
            if (!projectId) return;
            afPageMethod('GetProcesses', { projectId: parseInt(projectId, 10) || 0 }, function (rows) {
                fillSelect('#afProcess', rows, ['ProcessID', 'ProcessId'], ['ProcessName'], 'Select');
                if (selectedValue) $('#afProcess').val(selectedValue);
            });
        }

        function loadSections(projectId, selectedSection, selectedField) {
            fillSelect('#afSection', [], ['Section'], ['Section'], 'Select');
            fillSelect('#afField', [], ['FieldName'], ['FieldName'], 'Select');
            $('#afSectionBlock').hide();
            $('#afErrorFieldBlock').show();
            if (!projectId) return;
            afPageMethod('GetSections', { projectId: parseInt(projectId, 10) || 0 }, function (rows) {
                if (rows && rows.length) {
                    $('#afSectionBlock').show();
                    $('#afErrorFieldBlock').hide();
                    fillSelect('#afSection', rows, ['Section'], ['Section'], 'Select');
                    if (selectedSection) $('#afSection').val(selectedSection);
                    loadFields(projectId, $('#afSection').val(), selectedField);
                }
            });
        }

        function loadFields(projectId, section, selectedField) {
            fillSelect('#afField', [], ['FieldName'], ['FieldName'], 'Select');
            if (!projectId || !section) return;
            afPageMethod('GetFields', { projectId: parseInt(projectId, 10) || 0, section: section }, function (rows) {
                fillSelect('#afField', rows, ['FieldName', 'Field'], ['FieldName', 'Field'], 'Select');
                if (selectedField) $('#afField').val(selectedField);
            });
        }

        function saveFeedback() {
            var model = collectModel();
            var message = validateModel(model);
            if (message) { showMessage('error', message); return; }
            $('#afSave').prop('disabled', true);
            afPageMethod('SaveFeedback', { model: model }, function (result) {
                $('#afSave').prop('disabled', false);
                showMessage(result.Success ? 'success' : 'error', result.Message);
                if (!result.Success) return;
                if (result.RedirectUrl) { window.location.href = result.RedirectUrl; return; }
                if (result.Record) {
                    afContext.Index = result.Index || 0;
                    afContext.Total = result.Total || afContext.Total;
                    afContext.Record = result.Record;
                    $('#afProgress').text(progressText());
                    bindRecord(result.Record);
                } else {
                    clearFeedbackOnly();
                    loadRecentOrders();
                }
            });
        }

        function collectModel() {
            return {
                Mode: $('#afMode').val(),
                SourceEmployeeID: $('#afSourceEmployeeID').val(),
                Fatal: $('#afSourceFatal').val(),
                SourceOrderNo: $('#afSourceOrderNo').val(),
                Index: afContext.Index || 0,
                FeedDetailsId: parseInt($('#afFeedDetailsId').val() || '0', 10),
                OrderNo: $.trim($('#afOrderNo').val()),
                DealNo: $.trim($('#afDealNo').val()),
                OrderDate: $.trim($('#afOrderDate').val()),
                ProjectID: parseInt($('#afProject').val() || '0', 10),
                ProcessID: parseInt($('#afProcess').val() || '0', 10),
                ErrorDoneBy: $.trim($('#afErrorDoneBy').val()).toUpperCase(),
                FeedbackGivenBy: $.trim($('#afFeedbackGivenBy').val()).toUpperCase(),
                ErrorType: $('#afErrorType').val(),
                FatalType: $('#afFatalType').val(),
                ErrorField: $.trim($('#afErrorField').val()),
                Section: $('#afSection').val(),
                Field: $('#afField').val(),
                Error: $.trim($('#afError').val()),
                ShouldBe: $.trim($('#afShouldBe').val()),
                FeedbackType: $('#afFeedbackType').val(),
                FeedbackRecivedDate: $.trim($('#afFeedbackReceivedDate').val()),
                Remark: $.trim($('#afRemark').val()),
                EDBStatus: $('#afEDBStatus').val(),
                EDBExplanation: $.trim($('#afEDBExplanation').val()),
                PMStatus: $('#afPMStatus').val(),
                PMExplanation: $.trim($('#afPMRemark').val())
            };
        }

        function validateModel(model) {
            var statusMode = afContext.ShowEDB || afContext.ShowPM;
            if (statusMode) {
                if (afContext.ShowEDB && (!model.EDBStatus || model.EDBStatus === 'Select')) return 'Please select Status.';
                if (afContext.ShowEDB && model.EDBStatus === 'Rejected' && !model.EDBExplanation) return 'Please enter Explanation.';
                if (afContext.ShowPM && (!model.PMStatus || model.PMStatus === 'Select')) return 'Please select PM Status.';
                if (afContext.ShowPM && !model.PMExplanation) return 'Please enter PM Remark.';
                return '';
            }

            var noFeedback = model.ErrorType === 'NoFeedback';
            if (!model.ProjectID) return 'Please select Project.';
            if (!model.ProcessID) return 'Please select Process.';
            if (!model.OrderNo) return 'Please enter Order #.';
            if (!model.OrderDate) return 'Please select Order Date.';
            if (!model.ErrorDoneBy) return 'Please enter Error Done By.';
            if (!model.FeedbackGivenBy) return 'Please enter Feedback given By.';
            if (model.ErrorDoneBy === model.FeedbackGivenBy) return 'Feedback Given By and Error Done By both are same is not valid, please check.';
            if (!model.ErrorType || model.ErrorType === 'Select') return 'Please select Error Type.';
            if (!noFeedback && (!model.FatalType || model.FatalType === 'Select')) return 'Please select Critical/Non-Critical.';
            if (!noFeedback && $('#afSectionBlock').is(':visible') && (!model.Section || model.Section === 'Select')) return 'Please select Section.';
            if (!noFeedback && $('#afSectionBlock').is(':visible') && (!model.Field || model.Field === 'Select')) return 'Please select Field.';
            if (!noFeedback && $('#afErrorFieldBlock').is(':visible') && !model.ErrorField) return 'Please enter Error Field.';
            if (!noFeedback && !model.Error) return 'Please enter Error.';
            if (!noFeedback && !model.ShouldBe) return 'Please enter Should be.';
            if (!model.FeedbackType || model.FeedbackType === 'Select') return 'Please select Feedback Type.';
            if (model.FeedbackType === 'Client' && !model.FeedbackRecivedDate) return 'Please select Feedback Received Date.';
            return '';
        }

        function syncErrorTypeState() {
            var noFeedback = $('#afErrorType').val() === 'NoFeedback';
            $('#afFatalType,#afErrorField,#afSection,#afField,#afError,#afShouldBe,#afRemark').prop('disabled', noFeedback);
            if (noFeedback) {
                $('#afFatalType,#afSection,#afField').val('Select');
                $('#afErrorField,#afError,#afShouldBe,#afRemark').val('');
                showMessage('success', 'NoFeedback selected. Error detail fields are disabled.');
            }
        }

        function syncFeedbackTypeState() {
            $('#afFeedbackReceivedBlock').toggle($('#afFeedbackType').val() === 'Client');
        }

        function setStatusPanels() {
            $('#afEDBPanel').toggle(afContext.ShowEDB === true);
            $('#afPMPanel').toggle(afContext.ShowPM === true);
            $('#afSave').text(afContext.ButtonText || 'ADD');
        }

        function setReadOnly(readOnly) {
            $('#afProject,#afProcess,#afOrderNo,#afOrderDate,#afErrorDoneBy,#afFeedbackGivenBy,#afErrorType,#afFatalType,#afErrorField,#afSection,#afField,#afError,#afShouldBe,#afFeedbackType,#afFeedbackReceivedDate,#afRemark')
                .prop('disabled', readOnly);
        }

        function clearFeedbackOnly() {
            $('#afFeedDetailsId').val('0');
            $('#afOrderNo,#afDealNo,#afErrorDoneBy,#afErrorField,#afError,#afShouldBe,#afFeedbackReceivedDate,#afRemark,#afEDBExplanation,#afPMRemark').val('');
            $('#afProject,#afProcess,#afSection,#afField,#afErrorType,#afFatalType,#afFeedbackType,#afEDBStatus,#afPMStatus').val('Select');
            $('#afOrderDate').val(afContext.Today || '');
            setReadOnly(false);
            syncFeedbackTypeState();
            syncErrorTypeState();
        }

        function loadRecentOrders() {
            afPageMethod('GetNewOrderRows', {}, function (rows) { bindRecentOrders(rows || []); });
        }

        function bindRecentOrders(rows) {
            if (recentTable) recentTable.destroy();
            var tbody = $('#afRecentTable tbody').empty();
            $.each(rows || [], function (i, row) {
                var id = valueOf(row, ['FeedDetailsId']);
                $('<tr/>')
                    .append('<td><button type="button" class="fb-btn fb-btn-light" onclick="window.location.href=\'AddFeedbackForSearchProject.aspx?Edit=' + id + '\'">View</button></td>')
                    .append($('<td/>').text(i + 1))
                    .append($('<td/>').text(valueOf(row, ['OrderNo'])))
                    .append($('<td/>').text(valueOf(row, ['ProjectName'])))
                    .append($('<td/>').text(valueOf(row, ['ProcessName'])))
                    .append($('<td/>').text(valueOf(row, ['ErrorDoneBY', 'ErrorDoneBy'])))
                    .append($('<td/>').text(valueOf(row, ['FeedbackBy'])))
                    .appendTo(tbody);
            });
            recentTable = $('#afRecentTable').DataTable({ pageLength: 10, dom: 'frtip' });
        }

        function progressText() {
            return afContext.Total > 0 ? ('Feedback ' + ((afContext.Index || 0) + 1) + ' - ' + afContext.Total) : '';
        }

        function fillSelect(selector, rows, valueKeys, textKeys, firstText) {
            var ddl = $(selector).empty();
            $('<option/>').val('Select').text(firstText || 'Select').appendTo(ddl);
            $.each(rows || [], function (_, row) {
                $('<option/>').val(valueOf(row, valueKeys)).text(valueOf(row, textKeys)).appendTo(ddl);
            });
        }

        function valueOf(row, keys) {
            for (var i = 0; i < keys.length; i++) if (row && row[keys[i]] !== undefined && row[keys[i]] !== null) return row[keys[i]];
            return '';
        }

        function showMessage(type, message) {
            $('#afMessage').removeClass('success error').addClass(type).text(message).show();
            setTimeout(function () { $('#afMessage').fadeOut(); }, 5000);
        }

        function ajaxError(xhr) {
            try { return xhr.responseJSON.Message || xhr.responseText || 'Unexpected error occurred.'; } catch (e) { return 'Unexpected error occurred.'; }
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="fb-page">
        <div class="fb-hero">
            <div>
                <h1 class="fb-title">Add / Update Feedback</h1>
                <p class="fb-subtitle">Create new feedback and record user or PM acceptance for this domain.</p>
            </div>
            <button id="afBack" type="button" class="fb-btn fb-btn-light">Back</button>
        </div>

        <div id="afMessage" class="fb-message"></div>

        <div class="fb-panel">
            <div class="fb-panel-header">
                <h2 class="fb-panel-title">Feedback Details</h2>
                <span id="afProgress" class="fb-progress"></span>
            </div>
            <div class="fb-panel-body">
                <input id="afMode" type="hidden" />
                <input id="afSourceEmployeeID" type="hidden" />
                <input id="afSourceFatal" type="hidden" />
                <input id="afSourceOrderNo" type="hidden" />
                <input id="afFeedDetailsId" type="hidden" value="0" />

                <div class="fb-grid-form">
                    <div class="fb-field">
                        <label for="afProject">Project #</label>
                        <select id="afProject" class="form-control"></select>
                    </div>
                    <div class="fb-field">
                        <label for="afProcess">Process</label>
                        <select id="afProcess" class="form-control"></select>
                    </div>
                    <div class="fb-field">
                        <label for="afOrderNo">Order #</label>
                        <input id="afOrderNo" type="text" class="form-control" />
                    </div>
                    <div class="fb-field">
                        <label for="afDealNo">Deal No</label>
                        <input id="afDealNo" type="text" class="form-control" />
                    </div>
                    <div class="fb-field">
                        <label for="afOrderDate">Order Date</label>
                        <input id="afOrderDate" type="text" class="form-control fb-date" />
                    </div>
                    <div class="fb-field">
                        <label for="afErrorDoneBy">Error Done By</label>
                        <input id="afErrorDoneBy" type="text" class="form-control" />
                    </div>
                    <div class="fb-field">
                        <label for="afFeedbackGivenBy">Feedback given By</label>
                        <input id="afFeedbackGivenBy" type="text" class="form-control" />
                    </div>
                    <div class="fb-field">
                        <label for="afErrorType">Error Type</label>
                        <select id="afErrorType" class="form-control">
                            <option value="Select">Select</option>
                            <option value="Careless">Careless</option>
                            <option value="Conceptual">Conceptual</option>
                            <option value="NoFeedback">NoFeedback</option>
                            <option value="None">None</option>
                        </select>
                    </div>
                    <div class="fb-field">
                        <label for="afFatalType">Critical/Non-Critical</label>
                        <select id="afFatalType" class="form-control">
                            <option value="Select">Select</option>
                            <option value="Critical">Critical</option>
                            <option value="Non-Critical">Non-Critical</option>
                            <option value="Fatal">Fatal</option>
                            <option value="Non-Fatal">Non-Fatal</option>
                        </select>
                    </div>
                    <div id="afErrorFieldBlock" class="fb-field">
                        <label for="afErrorField">Error Field</label>
                        <input id="afErrorField" type="text" class="form-control" />
                    </div>
                    <div id="afSectionBlock" class="fb-field fb-span-2" style="display: none;">
                        <div class="fb-grid-form" style="grid-template-columns: repeat(2, minmax(0, 1fr)); padding: 0;">
                            <div class="fb-field">
                                <label for="afSection">Section</label>
                                <select id="afSection" class="form-control"></select>
                            </div>
                            <div class="fb-field">
                                <label for="afField">Field</label>
                                <select id="afField" class="form-control"></select>
                            </div>
                        </div>
                    </div>
                    <div class="fb-field">
                        <label for="afFeedbackType">Feedback Type</label>
                        <select id="afFeedbackType" class="form-control">
                            <option value="Select">Select</option>
                            <option value="Internal">Internal</option>
                            <option value="Client">Client</option>
                        </select>
                    </div>
                    <div id="afFeedbackReceivedBlock" class="fb-field" style="display: none;">
                        <label for="afFeedbackReceivedDate">Feedback Received Date</label>
                        <input id="afFeedbackReceivedDate" type="text" class="form-control fb-date" />
                    </div>
                    <div class="fb-field fb-span-3">
                        <label for="afError">Error</label>
                        <textarea id="afError" class="form-control"></textarea>
                    </div>
                    <div class="fb-field fb-span-3">
                        <label for="afShouldBe">Should be</label>
                        <textarea id="afShouldBe" class="form-control"></textarea>
                    </div>
                    <div class="fb-field fb-span-3">
                        <label for="afRemark">Remark</label>
                        <textarea id="afRemark" class="form-control"></textarea>
                    </div>
                </div>

                <div id="afEDBPanel" class="fb-panel" style="display: none; margin-top: 16px;">
                    <div class="fb-panel-header">
                        <h2 class="fb-panel-title">Acceptance Status</h2>
                    </div>
                    <div class="fb-panel-body">
                        <div class="fb-grid-form">
                            <div class="fb-field">
                                <label for="afEDBStatus">Status</label>
                                <select id="afEDBStatus" class="form-control">
                                    <option value="Select">Select</option>
                                    <option value="Accepted">Accepted</option>
                                    <option value="Rejected">Rejected</option>
                                </select>
                            </div>
                            <div class="fb-field fb-span-2">
                                <label for="afEDBExplanation">Explanation</label>
                                <textarea id="afEDBExplanation" class="form-control"></textarea>
                            </div>
                        </div>
                    </div>
                </div>

                <div id="afPMPanel" class="fb-panel" style="display: none; margin-top: 16px;">
                    <div class="fb-panel-header">
                        <h2 class="fb-panel-title">PM Status</h2>
                    </div>
                    <div class="fb-panel-body">
                        <div class="fb-grid-form">
                            <div class="fb-field">
                                <label for="afPMStatus">PM Status</label>
                                <select id="afPMStatus" class="form-control">
                                    <option value="Select">Select</option>
                                    <option value="Searcherfeedback">Searcher feedback</option>
                                    <option value="Researcherfeedback">Researcher feedback</option>
                                    <option value="BothRight">BothRight</option>
                                    <option value="BothWrong">BothWrong</option>
                                </select>
                            </div>
                            <div class="fb-field fb-span-2">
                                <label for="afPMRemark">PM Remark</label>
                                <textarea id="afPMRemark" class="form-control"></textarea>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="fb-actions">
                    <button id="afSave" type="button" class="fb-btn fb-btn-primary">ADD</button>
                    <button id="afClear" type="button" class="fb-btn fb-btn-light">Clear</button>
                </div>
            </div>
        </div>

        <div class="fb-panel">
            <div class="fb-panel-header">
                <h2 class="fb-panel-title">Recent New Order Feedback</h2>
            </div>
            <div class="fb-table-wrap">
                <table id="afRecentTable" class="table table-bordered table-striped fb-mini-table" style="width: 100%;">
                    <thead>
                        <tr>
                            <th>Action</th>
                            <th>Sr. #</th>
                            <th>Order #</th>
                            <th>Project</th>
                            <th>Process</th>
                            <th>Error Done By</th>
                            <th>Feedback By</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
