<%@ Page Title="Complaints And Suggestion Report" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ComplaintsAndSuggestionReport.aspx.cs" Inherits="WebPortal.Admin.ComplaintsAndSuggestionReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .csr-header { background: linear-gradient(90deg, #1f3c88, #2575fc 60%, #1bc5e8); border-radius: 15px; padding: 18px 22px; color: #fff; margin-bottom: 20px; box-shadow: 0 8px 20px rgba(0,0,0,.12); }
        .csr-header h4 { margin: 0 0 4px; font-weight: 700; }
        .csr-header p { margin: 0; font-size: 13px; opacity: .9; }
        .csr-card { background: #fff; border: 1px solid #e5edf6; border-radius: 15px; padding: 18px; box-shadow: 0 8px 24px rgba(15,23,42,.06); }
        .csr-toolbar { display: flex; justify-content: space-between; align-items: center; gap: 12px; margin-bottom: 15px; }
        .csr-search { width: 280px; max-width: 100%; border: 1px solid #dbe5f0; border-radius: 9px; padding: 9px 12px; }
        .csr-table th { white-space: nowrap; background: #f5f8fc; color: #334155; }
        .csr-empty { text-align: center; color: #64748b; padding: 28px !important; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="csr-header">
        <h4><i class="fas fa-comments mr-2"></i>Complaints And Suggestion Report</h4>
        <p>View complaints and suggestions submitted by employees.</p>
    </div>
    <div class="csr-card">
        <div class="csr-toolbar">
            <strong>Complaint &amp; Suggestion Details</strong>
            <input id="reportSearch" class="csr-search" type="search" placeholder="Search records..." />
        </div>
        <div class="table-responsive">
            <table class="table table-hover table-striped table-bordered csr-table" style="width:100%">
                <thead><tr><th>Sr. #</th><th>Type</th><th>Subject</th><th>Description</th><th>Added By</th><th>Added DateTime</th></tr></thead>
                <tbody id="reportBody"><tr><td colspan="6" class="csr-empty">Loading...</td></tr></tbody>
            </table>
        </div>
    </div>

    <script>
        (function () {
            var rows = [];
            function value(row, key) { return row[key] == null ? '' : String(row[key]); }
            function dateTime(value) {
                var match = String(value || '').match(/\/Date\((-?\d+)(?:[+-]\d+)?\)\//);
                if (!match) return value || '';
                var date = new Date(parseInt(match[1], 10));
                return date.toLocaleString('en-IN', {
                    day: '2-digit', month: 'short', year: 'numeric',
                    hour: '2-digit', minute: '2-digit', hour12: true
                });
            }
            function render(filter) {
                var body = document.getElementById('reportBody');
                var term = (filter || '').toLowerCase();
                var visible = rows.filter(function (row) {
                    return !term || ['Type', 'Subject', 'Description', 'EmpName', 'AddedDate'].some(function (key) { return value(row, key).toLowerCase().indexOf(term) >= 0; });
                });
                body.innerHTML = '';
                if (!visible.length) {
                    var emptyRow = body.insertRow(), emptyCell = emptyRow.insertCell();
                    emptyCell.colSpan = 6; emptyCell.className = 'csr-empty'; emptyCell.textContent = 'No records found.';
                    return;
                }
                visible.forEach(function (row, index) {
                    var tr = body.insertRow();
                    [index + 1, value(row, 'Type'), value(row, 'Subject'), value(row, 'Description'), value(row, 'EmpName'), dateTime(row.AddedDate)].forEach(function (item) {
                        tr.insertCell().textContent = item;
                    });
                });
            }
            document.addEventListener('DOMContentLoaded', function () {
                document.getElementById('reportSearch').addEventListener('input', function () { render(this.value); });
                fetch('ComplaintsAndSuggestionReport.aspx/GetReport', { method: 'POST', headers: { 'Content-Type': 'application/json; charset=utf-8' }, body: '{}' })
                    .then(function (response) { if (!response.ok) throw new Error(); return response.json(); })
                    .then(function (result) { rows = result.d || []; render(''); })
                    .catch(function () { document.getElementById('reportBody').innerHTML = '<tr><td colspan="6" class="csr-empty">Unable to load records.</td></tr>'; });
            });
        }());
    </script>
</asp:Content>
