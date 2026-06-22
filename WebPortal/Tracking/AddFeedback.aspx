<%@ Page Title="" Language="C#" MasterPageFile="~/Tracking/Tracking.Master" AutoEventWireup="true" CodeBehind="AddFeedback.aspx.cs" Inherits="WebPortal.Tracking.AddFeedback" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .erp-feedback-page { font-family: Verdana, Arial, sans-serif; font-size: 12px; color: #000; }
        .erp-window { border: 1px solid #2f5f82; border-radius: 6px 6px 0 0; background: #f4f4f4; box-shadow: 0 1px 0 #fff inset; }
        .erp-window-title { background: linear-gradient(to bottom, #cfe2f3 0%, #9fc5e8 100%); border-radius: 5px 5px 0 0; padding: 7px 11px; font-size: 12px; color: #000; border-bottom: 1px solid #96b6d2; }
        .erp-window-body { padding: 4px 7px 12px; background: #f3f3f3; }
        .erp-tabs { display: flex; align-items: flex-end; gap: 0; margin-left: 4px; }
        .erp-tab { border: 1px solid #b7b7b7; border-bottom: 0; background: #f8f8f8; color: #000; padding: 5px 10px; min-width: 82px; height: 25px; line-height: 14px; text-align: center; cursor: pointer; font-size: 12px; }
        .erp-tab.active { background: #fff; position: relative; top: 1px; font-weight: normal; }
        .erp-tab-panel { display: none; border: 1px dotted #777; background: #f6f6f6; padding: 5px; min-height: 268px; }
        .erp-tab-panel.active { display: block; }
        .erp-inner-box { border: 1px solid #777; background: #fbfbfb; padding: 6px; }
        .erp-info-strip { width: 100%; border-collapse: collapse; border: 1px solid #777; margin-bottom: 8px; background: #fff; }
        .erp-info-strip td { padding: 5px 26px; font-weight: bold; white-space: nowrap; }
        .erp-info-strip span { font-weight: normal; margin-left: 12px; }
        .erp-form-table { width: 100%; border-collapse: collapse; }
        .erp-form-table td { padding: 3px 3px; vertical-align: middle; }
        .erp-label { font-weight: bold; text-align: right; white-space: nowrap; width: 95px; }
        .erp-control { width: 100%; height: 22px; border: 1px solid #9b9b9b; background: #fff; font-family: Verdana, Arial, sans-serif; font-size: 12px; padding: 1px 4px; box-sizing: border-box; }
        select.erp-control { padding: 1px 2px; }
        .erp-control[disabled], .erp-control.disabled { background: #dfdfdf; }
        textarea.erp-control { height: 41px; resize: none; padding-top: 4px; }
        .erp-wide-label { width: 75px; }
        .erp-upload-row { display: flex; align-items: center; gap: 8px; padding: 3px 8px 7px 8px; }
        .erp-file-text { width: 280px; height: 21px; border: 1px solid #8d8d8d; background: #fff; box-sizing: border-box; }
        .erp-file-hidden { display: none; }
        .erp-btn { border: 1px solid #adadad; background: linear-gradient(to bottom, #fefefe, #dcdcdc); min-width: 74px; height: 28px; font-weight: bold; color: #000; cursor: pointer; font-family: Verdana, Arial, sans-serif; }
        .erp-btn:hover { background: linear-gradient(to bottom, #fff, #cfcfcf); }
        .erp-link { color: blue; text-decoration: underline; margin-left: 20px; font-size: 12px; }
        .erp-grid-area { border: 1px solid #222; background: #aaa; height: 228px; margin: 0 8px; overflow: auto; }
        .erp-grid { width: 100%; border-collapse: collapse; font-size: 12px; background: #fff; display: none; }
        .erp-grid th { background: linear-gradient(to bottom, #cbd0dd, 3%, #fff); border: 1px solid #777; padding: 5px; text-align: center; }
        .erp-grid td { border: 1px solid #aaa; padding: 4px; background: #fff; }
        .erp-actions { text-align: center; padding: 12px 0 4px; }
        .erp-actions .erp-btn { margin: 0 10px; }
        .erp-help { text-align: center; font-weight: bold; font-size: 12px; padding-top: 2px; }
        .loading { display: none; position: fixed; top: 350px; left: 50%; margin-top: -96px; margin-left: -96px; opacity: .85; border-radius: 25px; width: 192px; height: 192px; z-index: 99999; text-align: center; }
        @media (max-width: 900px) {
            .erp-info-strip td { padding: 5px 8px; }
            .erp-form-table, .erp-form-table tbody, .erp-form-table tr, .erp-form-table td { display: block; width: 100%; }
            .erp-label { text-align: left; padding-top: 7px !important; }
            .erp-upload-row { flex-wrap: wrap; }
            .erp-file-text { width: 100%; }
        }
    </style>

    <script type="text/javascript">
        var feedbackState = { activeTab: 'tabAddFeedback', currentRows: [] };

        $(document).ready(function () {
            initFeedbackPage();
            bindFeedbackMasterData();
        });

        function initFeedbackPage() {
            $('.erp-tab').on('click', function () { showFeedbackTab($(this).data('tab')); });
            $('#fuImportFeedback').on('change', function () { onImportFileSelected(this); });
            showFeedbackTab('tabAddFeedback');
        }

        function showFeedbackTab(tabId) {
            feedbackState.activeTab = tabId;
            $('.erp-tab').removeClass('active');
            $('.erp-tab-panel').removeClass('active');
            $('.erp-tab[data-tab="' + tabId + '"]').addClass('active');
            $('#' + tabId).addClass('active');
        }

        function bindFeedbackMasterData() {
            // Replace these sample values with your existing ERP AJAX/API binding calls.
            bindSelect('#ddlMarkedTo', [{ id: '', text: '' }, { id: 'QC', text: 'QC' }, { id: 'Processor', text: 'Processor' }]);
            bindSelect('#ddlErrorBy', [{ id: '', text: '' }, { id: 'QC', text: 'QC' }, { id: 'Auditor', text: 'Auditor' }]);
            bindSelect('#ddlErrorType', [{ id: '', text: '' }, { id: 'Critical', text: 'Critical' }, { id: 'Non Critical', text: 'Non Critical' }]);
            bindSelect('#ddlCategory', [{ id: '', text: '' }, { id: 'Data Entry', text: 'Data Entry' }, { id: 'Document', text: 'Document' }]);
            bindSelect('#ddlSubcategory', [{ id: '', text: '' }, { id: 'Missing', text: 'Missing' }, { id: 'Incorrect', text: 'Incorrect' }]);
            bindSelect('#ddlSeverity', [{ id: '', text: '' }, { id: 'High', text: 'High' }, { id: 'Medium', text: 'Medium' }, { id: 'Low', text: 'Low' }]);
            bindSelect('#ddlFeedbackType', [{ id: '', text: '' }, { id: 'Internal', text: 'Internal' }, { id: 'Client', text: 'Client' }]);
        }

        function bindHeaderData(data) {
            $('#lblProjectNo1').text(data.ProjectNo || '');
            $('#lblDealNo').text(data.DealNo || '');
            $('#lblLoanNo').text(data.LoanNo || '');
            $('#lblOrderDate').text(data.OrderDate || '');
            $('#lblProjectNo2').text(data.ProjectNo2 || data.ProjectNo || '');
        }

        function bindSelect(selector, rows) {
            var ddl = $(selector);
            ddl.empty();
            $.each(rows, function (_, row) { ddl.append($('<option/>').val(row.id).text(row.text)); });
        }

        function collectFeedbackData() {
            return {
                ProjectNo: $('#lblProjectNo1').text(),
                DealNo: $('#lblDealNo').text(),
                LoanNo: $('#lblLoanNo').text(),
                OrderDate: $('#lblOrderDate').text(),
                MarkedTo: $('#ddlMarkedTo').val(),
                ErrorBy: $('#ddlErrorBy').val(),
                FeedbackBy: $('#txtFeedbackBy').val(),
                ErrorType: $('#ddlErrorType').val(),
                Category: $('#ddlCategory').val(),
                Subcategory: $('#ddlSubcategory').val(),
                Severity: $('#ddlSeverity').val(),
                ErrorField: $('#txtErrorField').val(),
                FeedbackType: $('#ddlFeedbackType').val(),
                Error: $('#txtError').val(),
                ShouldBe: $('#txtShouldBe').val(),
                Remark: $('#txtRemark').val()
            };
        }

        function validateFeedback(data) {
            if (!data.MarkedTo) { alert('Please select Marked to.'); $('#ddlMarkedTo').focus(); return false; }
            if (!data.ErrorType) { alert('Please select Error Type.'); $('#ddlErrorType').focus(); return false; }
            if (!data.Error) { alert('Please enter Error.'); $('#txtError').focus(); return false; }
            return true;
        }

        function saveFeedback() {
            if (feedbackState.activeTab === 'tabImportFeedback') { return uploadImportFeedback(); }
            var data = collectFeedbackData();
            if (!validateFeedback(data)) return false;

            // Hook this block to your source page method, e.g. AddFeedback_New.aspx/SaveFeedback.
            $.ajax({
                type: 'POST',
                url: 'AddFeedback_New.aspx/SaveFeedback',
                data: JSON.stringify({ feedback: data }),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                beforeSend: function () { $('#load1').show(); },
                complete: function () { $('#load1').hide(); },
                success: function (res) {
                    var result = res.d || res;
                    alert(result.Message || 'Feedback saved successfully.');
                    if (result.Success !== false) clearFeedbackForm();
                },
                error: function () { alert('Save function is ready. Please connect SaveFeedback web method from source page.'); }
            });
            return false;
        }

        function clearFeedbackForm() {
            $('#ddlMarkedTo,#ddlErrorBy,#ddlErrorType,#ddlCategory,#ddlSubcategory,#ddlSeverity,#ddlFeedbackType').val('');
            $('#txtFeedbackBy,#txtErrorField,#txtError,#txtShouldBe,#txtRemark').val('');
        }

        function closeFeedbackPage() {
            if (window.parent && window.parent !== window && window.parent.$) {
                try { window.parent.$('.ui-dialog-content').dialog('close'); return false; } catch (e) { }
            }
            window.close();
            return false;
        }

        function browseImportFile() { $('#fuImportFeedback').click(); return false; }

        function onImportFileSelected(input) {
            var fileName = input.files && input.files.length > 0 ? input.files[0].name : '';
            $('#txtImportFileName').val(fileName);
        }

        function uploadImportFeedback() {
            var fileInput = document.getElementById('fuImportFeedback');
            if (!fileInput.files || fileInput.files.length === 0) { alert('Please select import file.'); return false; }
            var formData = new FormData();
            formData.append('ImportFeedback', fileInput.files[0]);

            // Hook this URL to the actual source-page upload/import handler.
            $.ajax({
                type: 'POST',
                url: 'AddFeedback_New.aspx?handler=ImportFeedback',
                data: formData,
                cache: false,
                contentType: false,
                processData: false,
                beforeSend: function () { $('#load1').show(); },
                complete: function () { $('#load1').hide(); },
                success: function (rows) { bindImportGrid(rows); alert('Import uploaded successfully.'); },
                error: function () { alert('Upload function is ready. Please connect import handler from source page.'); }
            });
            return false;
        }

        function bindImportGrid(rows) {
            rows = rows && rows.d ? rows.d : rows;
            if (!$.isArray(rows)) rows = [];
            feedbackState.currentRows = rows;
            var tbody = $('#tblImportFeedback tbody').empty();
            $.each(rows, function (i, r) {
                $('<tr/>')
                    .append($('<td/>').text(i + 1))
                    .append($('<td/>').text(r.ProjectNo || ''))
                    .append($('<td/>').text(r.DealNo || ''))
                    .append($('<td/>').text(r.LoanNo || ''))
                    .append($('<td/>').text(r.ErrorType || ''))
                    .append($('<td/>').text(r.Category || ''))
                    .append($('<td/>').text(r.Remark || ''))
                    .appendTo(tbody);
            });
            $('#tblImportFeedback').toggle(rows.length > 0);
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" alt="Loading" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="erp-feedback-page">
        <div class="erp-window">
            <div class="erp-window-title">Add Feedback</div>
            <div class="erp-window-body">
                <div class="erp-tabs">
                    <button type="button" class="erp-tab active" data-tab="tabAddFeedback">Add Feedback</button>
                    <button type="button" class="erp-tab" data-tab="tabImportFeedback">Import Feedback</button>
                </div>

                <div id="tabAddFeedback" class="erp-tab-panel active">
                    <div class="erp-inner-box">
                        <table class="erp-info-strip">
                            <tr>
                                <td>ProjectNo : <span id="lblProjectNo1"></span></td>
                                <td>DealNo : <span id="lblDealNo"></span></td>
                                <td>Loan No : <span id="lblLoanNo"></span></td>
                                <td>OrderDate : <span id="lblOrderDate"></span></td>
                                <td>ProjectNo : <span id="lblProjectNo2"></span></td>
                            </tr>
                        </table>

                        <table class="erp-form-table">
                            <tr>
                                <td class="erp-label">Marked to :</td>
                                <td><select id="ddlMarkedTo" class="erp-control"></select></td>
                                <td class="erp-label">Error By :</td>
                                <td><select id="ddlErrorBy" class="erp-control"></select></td>
                                <td class="erp-label">Feedback By :</td>
                                <td><input id="txtFeedbackBy" type="text" class="erp-control disabled" disabled="disabled" /></td>
                            </tr>
                            <tr>
                                <td class="erp-label">Error Type :</td>
                                <td><select id="ddlErrorType" class="erp-control"></select></td>
                                <td class="erp-label">Category:</td>
                                <td><select id="ddlCategory" class="erp-control"></select></td>
                                <td class="erp-label">Subcategory :</td>
                                <td><select id="ddlSubcategory" class="erp-control"></select></td>
                            </tr>
                            <tr>
                                <td class="erp-label">Severity:</td>
                                <td><select id="ddlSeverity" class="erp-control"></select></td>
                                <td class="erp-label">Error Field :</td>
                                <td><input id="txtErrorField" type="text" class="erp-control" /></td>
                                <td class="erp-label">FeedBack Type :</td>
                                <td><select id="ddlFeedbackType" class="erp-control disabled" disabled="disabled"></select></td>
                            </tr>
                            <tr>
                                <td class="erp-label erp-wide-label">Error :</td>
                                <td colspan="5"><textarea id="txtError" class="erp-control"></textarea></td>
                            </tr>
                            <tr>
                                <td class="erp-label erp-wide-label">Should be :</td>
                                <td colspan="5"><textarea id="txtShouldBe" class="erp-control"></textarea></td>
                            </tr>
                            <tr>
                                <td class="erp-label erp-wide-label">Remark :</td>
                                <td colspan="5"><textarea id="txtRemark" class="erp-control"></textarea></td>
                            </tr>
                        </table>
                    </div>
                </div>

                <div id="tabImportFeedback" class="erp-tab-panel">
                    <div class="erp-upload-row">
                        <input id="txtImportFileName" type="text" class="erp-file-text" readonly="readonly" />
                        <input id="fuImportFeedback" name="fuImportFeedback" type="file" class="erp-file-hidden" accept=".xls,.xlsx" />
                        <button type="button" class="erp-btn" onclick="return browseImportFile();">Browse</button>
                        <button type="button" class="erp-btn" onclick="return uploadImportFeedback();">Upload</button>
                        <a class="erp-link" href="AddFeedbackImportFormat.xlsx">Download Format for Import Feedback</a>
                    </div>
                    <div class="erp-grid-area">
                        <table id="tblImportFeedback" class="erp-grid">
                            <thead>
                                <tr>
                                    <th>Sr. #</th>
                                    <th>Project No</th>
                                    <th>Deal No</th>
                                    <th>Loan No</th>
                                    <th>Error Type</th>
                                    <th>Category</th>
                                    <th>Remark</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>

                <div class="erp-actions">
                    <button type="button" id="btnAddFeedback" class="erp-btn" onclick="return saveFeedback();">ADD</button>
                    <button type="button" id="btnCloseFeedback" class="erp-btn" onclick="return closeFeedbackPage();">Close</button>
                </div>
                <div class="erp-help">Please click on “Add” button to add feedback one by one .</div>
            </div>
        </div>
    </div>
</asp:Content>

