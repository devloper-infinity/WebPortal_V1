<%@ Page Title="Excel Cross-Check" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ExcelCrossCheck.aspx.cs" Inherits="InfinityERP.Admin.ExcelCrossCheck" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../Content/erp-modern-common.css" />
    <style>
        .ecc-stats {
            display: grid;
            grid-template-columns: repeat(5,minmax(130px,1fr));
            gap: 10px;
            margin: 15px 0
        }

        .ecc-stat {
            background: #f8fafc;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 12px
        }

            .ecc-stat b {
                display: block;
                font-size: 20px;
                margin-top: 4px
            }

        .ecc-toolbar {
            display: flex;
            gap: 10px;
            align-items: end;
            flex-wrap: wrap;
            margin: 14px 0
        }

            .ecc-toolbar .filter {
                min-width: 230px
            }

        .badge {
            display: inline-block;
            border-radius: 999px;
            padding: 4px 8px;
            font-size: 11px;
            font-weight: 700;
            white-space: nowrap
        }

        .s-match {
            background: #dcfce7;
            color: #166534
        }

        .s-blank {
            background: #f3f4f6;
            color: #4b5563
        }

        .s-missing {
            background: #fee2e2;
            color: #991b1b
        }

        .s-mismatch {
            background: #ffedd5;
            color: #9a3412
        }

        .s-format {
            background: #fef3c7;
            color: #92400e
        }

        .s-extra {
            background: #ede9fe;
            color: #5b21b6
        }

        .s-notreflect {
            background: #dbeafe;
            color: #1e40af
        }

        .s-type {
            background: #fce7f3;
            color: #9d174d
        }

        #eccProgress {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 10000;
            background: rgba(15,23,42,.45)
        }

        .ecc-progress-box {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%,-50%);
            width: 320px;
            padding: 22px;
            border-radius: 14px;
            background: #fff;
            text-align: center
        }

            .ecc-progress-box .progress {
                height: 12px;
                margin-top: 12px
            }

        @media(max-width:900px) {
            .ecc-stats {
                grid-template-columns: 1fr 1fr
            }
        }
    </style>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid">
        <div class="erp-dashboard-header">
            <div class="erp-dashboard-header-content">
                <div class="erp-dashboard-icon"><i class="fas fa-file-excel"></i></div>
                <div>
                    <h1 class="erp-dashboard-title">Scienna vs Lauramac Cross-Check</h1>
                    <p class="erp-dashboard-subtitle">Compare complete Excel scripts using exact column names, ignoring case only.</p>
                </div>
            </div>
        </div>
        <div id="eccMessage"><%= MessageHtml %></div>
        <section class="erp-section-card p-3 mb-4 erp-modern-form">
            <div id="compareForm" class="row align-items-end">
                <div class="col-md-5">
                    <label for="sciennaFile">Scienna Excel (.xlsx)</label><input id="sciennaFile" name="sciennaFile" type="file" class="form-control" accept=".xlsx" required /></div>
                <div class="col-md-5">
                    <label for="lauramacFile">Lauramac Excel (.xlsx)</label><input id="lauramacFile" name="lauramacFile" type="file" class="form-control" accept=".xlsx" required /></div>
                <div class="col-md-2">
                    <button id="compareButton" class="btn btn-primary" type="submit" name="action" value="compare"><i class="fas fa-search"></i>Compare Files</button></div>
            </div>
        </section>
        <div id="eccResult"><%= ResultHtml %></div>
    </div>
    <div id="eccProgress">
        <div class="ecc-progress-box"><strong>Comparing files - <span id="eccPercent">0%</span></strong><div class="progress">
            <div id="eccBar" class="progress-bar progress-bar-striped progress-bar-animated" style="width: 0%"></div>
        </div>
        </div>
    </div>
    <script>
        (function () { function grid() { if (!$('#crossCheckTable').length) return; var table = $('#crossCheckTable').DataTable({ pageLength: 25, lengthChange: false, paging: true, order: [], scrollX: true }); $('#statusFilter').off('change').on('change', function () { var v = this.value; table.column(5).search(v ? '^' + $.fn.dataTable.util.escapeRegex(v) + '$' : '', true, false).draw(); }); } $('#compareButton').closest('form').on('submit', function (e) { e.preventDefault(); if (!document.getElementById('sciennaFile').checkValidity() || !document.getElementById('lauramacFile').checkValidity()) { this.reportValidity(); return; } var fd = new FormData(); fd.append('sciennaFile', $('#sciennaFile')[0].files[0]); fd.append('lauramacFile', $('#lauramacFile')[0].files[0]); fd.append('action', 'compare'); var x = new XMLHttpRequest(); $('#eccProgress').show(); $('#compareButton').prop('disabled', true); x.upload.onprogress = function (v) { if (v.lengthComputable) { var p = Math.round(v.loaded / v.total * 90); $('#eccPercent').text(p + '%'); $('#eccBar').css('width', p + '%'); } }; x.onload = function () { try { var r = JSON.parse(x.responseText); $('#eccMessage').html(r.MessageHtml); $('#eccResult').html(r.ResultHtml); $('#eccPercent').text('100%'); $('#eccBar').css('width', '100%'); grid(); } catch (err) { $('#eccMessage').html('<div class="alert alert-danger">Unable to process comparison.</div>'); } setTimeout(function () { $('#eccProgress').hide(); $('#eccPercent').text('0%'); $('#eccBar').css('width', '0%'); }, 350); $('#compareButton').prop('disabled', false); }; x.onerror = function () { $('#eccProgress').hide(); $('#compareButton').prop('disabled', false); $('#eccMessage').html('<div class="alert alert-danger">Unable to process comparison.</div>'); }; x.open('POST', 'ExcelCrossCheck.aspx?ajax=1'); x.send(fd); }); grid(); })();
    </script>
</asp:Content>
