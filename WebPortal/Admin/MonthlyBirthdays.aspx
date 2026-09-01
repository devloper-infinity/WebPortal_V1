<%@ Page Title="Monthly Birthdays" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="MonthlyBirthdays.aspx.cs" Inherits="WebPortal.Admin.MonthlyBirthdays" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .mb-page { padding: 18px; color: #26364a; }
        .mb-hero { border-radius: 14px; padding: 22px 24px; color: #fff; background: linear-gradient(120deg,#253f75,#6d4da2); box-shadow: 0 8px 24px rgba(38,55,110,.18); }
        .mb-hero h4 { margin: 0 0 5px; font-weight: 700; }
        .mb-hero p { margin: 0; opacity: .88; }
        .mb-card { margin-top: 18px; border: 1px solid #e4eaf2; border-radius: 12px; background: #fff; box-shadow: 0 4px 15px rgba(31,50,81,.06); }
        .mb-card-head { padding: 14px 18px; border-bottom: 1px solid #e8edf4; font-weight: 600; }
        .mb-card-body { padding: 18px; }
        .mb-filters { display: grid; grid-template-columns: repeat(3,minmax(170px,1fr)) auto; gap: 14px; align-items: end; }
        .mb-field label { display: block; margin-bottom: 6px; font-size: 13px; font-weight: 600 !important; }
        .mb-actions { display: flex; gap: 8px; }
        .mb-btn { height: 38px; border: 0; border-radius: 7px; padding: 0 15px; color: #fff; font-weight: 600; cursor: pointer; white-space: nowrap; }
        .mb-btn-primary { background: #315ca8; }
        .mb-btn-success { background: #26845b; }
        .mb-btn:disabled { opacity: .55; cursor: default; }
        .mb-table-wrap { overflow-x: auto; }
        .mb-table { width: 100%; min-width: 1120px; border-collapse: collapse; }
        .mb-table th { padding: 11px 12px; background: #f4f7fb; border-bottom: 2px solid #dfe7f1; font-size: 12px; text-transform: uppercase; white-space: nowrap; }
        .mb-table td { padding: 10px 12px; border-bottom: 1px solid #edf1f6; font-size: 13px; white-space: nowrap; }
        .mb-table tbody tr:hover { background: #fafbfe; }
        .mb-status { display: inline-block; border-radius: 20px; padding: 3px 9px; font-size: 11px; font-weight: 700; }
        .mb-active { color: #17653e; background: #dff5e9; }
        .mb-inactive { color: #9a3b3b; background: #fde5e5; }
        .mb-empty { padding: 42px !important; text-align: center; color: #738197; }
        .mb-summary { float: right; color: #67758a; font-weight: 500; }
        .mb-required { color: #c83737; }
        @media (max-width: 992px) { .mb-filters { grid-template-columns: repeat(2,minmax(160px,1fr)); } }
        @media (max-width: 600px) { .mb-page { padding: 10px; } .mb-filters { grid-template-columns: 1fr; } .mb-actions,.mb-btn { width: 100%; } }
    </style>
    <script>
        var mbRows = [];
        $(document).ready(function () {
            mbBindMonths();
            mbLoadFilters();
        });

        function mbBindMonths() {
            var names = ['January','February','March','April','May','June','July','August','September','October','November','December'];
            var ddl = $('#mb_month').empty().append($('<option>').val('').text('Select Month'));
            $.each(names, function (i, name) { ddl.append($('<option>').val(i + 1).text(name)); });
            ddl.val(new Date().getMonth() + 1);
        }

        function mbLoadFilters() {
            mbBusy(true);
            $.ajax({ type: 'POST', url: 'MonthlyBirthdays.aspx/GetFilters', contentType: 'application/json; charset=utf-8', dataType: 'json' })
                .done(function (result) {
                    var data = JSON.parse(result.d);
                    mbBindLookup('#mb_location', data.Branches, 'BranchID', 'BranchName', 'All Locations');
                    mbBindLookup('#mb_domain', data.Domains, 'DomainID', 'DomainName', 'All Domains');
                }).fail(mbError).always(function () { mbBusy(false); });
        }

        function mbBindLookup(selector, rows, valueField, textField, allText) {
            var ddl = $(selector).empty().append($('<option>').val('0').text(allText));
            $.each(rows || [], function (_, row) { ddl.append($('<option>').val(row[valueField]).text(row[textField])); });
        }

        function mbShow() {
            var month = parseInt($('#mb_month').val(), 10);
            if (!month) { Swal.fire('Month required', 'Please select a month.', 'warning'); return false; }
            mbBusy(true);
            $.ajax({
                type: 'POST', url: 'MonthlyBirthdays.aspx/GetMonthlyBirthdayReport',
                data: JSON.stringify({ month: month, branchId: parseInt($('#mb_location').val(), 10) || 0, domainId: parseInt($('#mb_domain').val(), 10) || 0 }),
                contentType: 'application/json; charset=utf-8', dataType: 'json'
            }).done(function (result) { mbRows = JSON.parse(result.d); mbRender(); })
              .fail(mbError).always(function () { mbBusy(false); });
            return false;
        }

        function mbRender() {
            var body = $('#mb_table tbody').empty();
            if (!mbRows.length) body.append($('<tr>').append($('<td>').attr('colspan', 9).addClass('mb-empty').text('No birthdays found for the selected filters.')));
            $.each(mbRows, function (_, row) {
                var tr = $('<tr>');
                $.each(['Code','Full Name','Joining Date','Date of Birth','Branch','Reporting Manager','Domain','Subdomain'], function (_, key) { tr.append($('<td>').text(mbValue(row[key]))); });
                var status = mbValue(row['Current Status']);
                tr.append($('<td>').append($('<span>').addClass('mb-status ' + (status === 'On Floor' ? 'mb-active' : 'mb-inactive')).text(status)));
                body.append(tr);
            });
            $('#mb_count').text(mbRows.length + (mbRows.length === 1 ? ' employee' : ' employees'));
            $('#mb_export').prop('disabled', !mbRows.length);
        }

        function mbValue(value) {
            if (value === null || value === undefined || value === '') return '-';
            var match = /^\/Date\((\d+)\)\/$/.exec(value);
            if (match) return new Date(parseInt(match[1], 10)).toLocaleDateString('en-GB', { day:'2-digit', month:'short', year:'numeric' });
            return String(value);
        }

        function mbExport() {
            if (!mbRows.length) return false;
            __doPostBack('<%= btnExport.UniqueID %>', '');
            return false;
        }

        function mbBusy(isBusy) { $('#mb_show').prop('disabled', isBusy); $('#mb_export').prop('disabled', isBusy || !mbRows.length); $('#mb_loading').toggle(isBusy); }
        function mbError(xhr) { var message = 'Unable to load the report.'; try { message = JSON.parse(xhr.responseText).Message || message; } catch (e) { } Swal.fire('Monthly Birthdays', message, 'error'); }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Button ID="btnExport" runat="server" Style="display:none" OnClick="btnExport_Click" />
    <div class="mb-page">
        <div class="mb-hero"><h4><i class="fas fa-birthday-cake"></i>&nbsp; Monthly Birthdays</h4><p>Find employee birthdays by month, location and domain.</p></div>
        <div class="mb-card"><div class="mb-card-head"><i class="fas fa-filter"></i>&nbsp; Search Filters</div><div class="mb-card-body">
            <div class="mb-filters">
                <div class="mb-field"><label for="mb_month">Month <span class="mb-required">*</span></label><select id="mb_month" name="mb_month" class="form-control"></select></div>
                <div class="mb-field"><label for="mb_location">Location</label><select id="mb_location" name="mb_location" class="form-control"><option value="0">All Locations</option></select></div>
                <div class="mb-field"><label for="mb_domain">Domain</label><select id="mb_domain" name="mb_domain" class="form-control"><option value="0">All Domains</option></select></div>
                <div class="mb-actions">
                    <button type="button" id="mb_show" class="mb-btn mb-btn-primary" onclick="return mbShow();"><i class="fas fa-search"></i>&nbsp; Show</button>
                    <button type="button" id="mb_export" class="mb-btn mb-btn-success" onclick="return mbExport();" disabled><i class="fas fa-file-excel"></i>&nbsp; Export</button>
                </div>
            </div>
        </div></div>
        <div class="mb-card"><div class="mb-card-head">Birthday List <span id="mb_count" class="mb-summary">0 employees</span></div>
            <div class="mb-table-wrap"><table id="mb_table" class="mb-table"><thead><tr><th>Code</th><th>Full Name</th><th>Joining Date</th><th>Date of Birth</th><th>Branch</th><th>Reporting Manager</th><th>Domain</th><th>Subdomain</th><th>Current Status</th></tr></thead><tbody><tr><td colspan="9" class="mb-empty">Select filters and click Show.</td></tr></tbody></table></div>
        </div>
        <div id="mb_loading" style="display:none;text-align:center;padding:12px;color:#607089"><i class="fas fa-spinner fa-spin"></i>&nbsp; Loading...</div>
    </div>
</asp:Content>
