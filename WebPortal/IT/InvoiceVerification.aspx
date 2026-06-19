<%@ Page Title="" Language="C#" MasterPageFile="~/IT/Admin.Master" AutoEventWireup="true" CodeBehind="~/IT/InvoiceVerification.aspx.cs" Inherits="WebPortal.IT.InvoiceVerification" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --inv-ink: #132238;
            --inv-muted: #64748b;
            --inv-border: #dbe5f1;
            --inv-soft: #f5f8fc;
            --inv-blue: #1d4ed8;
            --inv-teal: #0f766e;
            --inv-red: #b91c1c;
        }

        .invoice-page {
            padding: 0px 0 28px;
            color: var(--inv-ink);
            font-size: 13px;
        }

        .invoice-shell {
            width: 100%;
            max-width: 1480px;
            margin: 0 auto;
        }

        .invoice-hero {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            min-height: 78px;
            padding: 16px 18px;
            border-radius: 8px;
            color: #fff;
            background: linear-gradient(135deg, #173567 0%, #0f766e 100%);
            box-shadow: 0 14px 34px rgba(15, 23, 42, .16);
        }

        .invoice-title {
            display: flex;
            align-items: center;
            gap: 13px;
            min-width: 0;
        }

        .invoice-title .icon-box {
            width: 44px;
            height: 44px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.16);
            font-size: 18px;
        }

        .invoice-title h1 {
            margin: 0;
            font-size: 22px;
            line-height: 1.15;
            font-weight: 800;
            letter-spacing: 0;
        }

        .invoice-title p {
            margin: 4px 0 0;
            color: rgba(255,255,255,.82);
            font-size: 12px;
        }

        .invoice-chip-row {
            display: flex;
            flex-wrap: wrap;
            justify-content: flex-end;
            gap: 8px;
        }

        .invoice-chip {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 8px 11px;
            border-radius: 999px;
            background: rgba(255,255,255,.14);
            color: #fff;
            font-weight: 800;
            white-space: nowrap;
        }

        .invoice-panel {
            margin-top: 14px;
            border: 1px solid var(--inv-border);
            border-radius: 8px;
            background: #fff;
            box-shadow: 0 10px 26px rgba(15, 23, 42, .07);
            overflow: hidden;
        }

        .invoice-panel-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 14px 16px;
            border-bottom: 1px solid var(--inv-border);
            background: #f8fafc;
        }

        .invoice-section-title {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .invoice-section-title i {
            width: 34px;
            height: 34px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: #e9f2ff;
            color: var(--inv-blue);
        }

        .invoice-section-title h2 {
            margin: 0;
            font-size: 16px;
            line-height: 1.2;
            font-weight: 800;
            letter-spacing: 0;
        }

        .invoice-panel-body {
            padding: 16px;
        }

        .invoice-filter-grid,
        .invoice-form-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 12px;
            align-items: end;
        }

        .invoice-form-grid.two-col {
            grid-template-columns: repeat(2, minmax(0, 1fr));
        }

        .invoice-field {
            min-width: 0;
        }

        .invoice-field.full {
            grid-column: 1 / -1;
        }

        .invoice-field label {
            display: block;
            margin: 0 0 6px;
            color: #526179;
            font-size: 11px;
            font-weight: 900 !important;
            text-transform: uppercase;
            border: 0 !important;
        }

        .invoice-page .form-control,
        .invoice-modal .form-control {
            width: 100% !important;
            min-height: 38px;
            border: 1px solid #cfd9e6;
            border-radius: 7px;
            color: #172033;
            font-size: 13px;
            box-shadow: none;
        }

        .invoice-readonly {
            display: flex;
            align-items: center;
            width: 100%;
            min-height: 38px;
            margin: 0;
            padding: 8px 10px;
            border: 1px solid #d9e3ef !important;
            border-radius: 7px;
            background: #f8fafc;
            color: #172033;
            font-weight: 700 !important;
            word-break: break-word;
        }

        .invoice-actions {
            display: flex;
            flex-wrap: wrap;
            justify-content: flex-end;
            gap: 10px;
        }

        .btn-invoice {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-height: 38px;
            padding: 8px 14px;
            border: 1px solid transparent;
            border-radius: 7px;
            font-size: 13px;
            font-weight: 800;
            line-height: 1;
            cursor: pointer;
            transition: transform .16s ease, box-shadow .16s ease, background .16s ease;
        }

        .btn-invoice:hover {
            transform: translateY(-1px);
            text-decoration: none;
        }

        .btn-invoice-primary {
            background: var(--inv-blue);
            color: #fff;
            box-shadow: 0 8px 18px rgba(29, 78, 216, .2);
        }

        .btn-invoice-primary:hover,
        .btn-invoice-primary:focus {
            color: #fff;
            background: #1e40af;
        }

        .btn-invoice-soft {
            border-color: #cbd5e1;
            background: #fff;
            color: #20304a;
        }

        .btn-invoice-soft:hover,
        .btn-invoice-soft:focus {
            color: var(--inv-teal);
            border-color: #99f6e4;
            background: #ecfeff;
        }

        .invoice-table-shell {
            width: 100%;
            overflow: auto;
        }

        #invtable,
        #inv_details {
            width: 100% !important;
            margin-bottom: 0 !important;
        }

        .table.dataTable th,
        #invtable thead th,
        #inv_details thead th {
            border-bottom: 1px solid var(--inv-border) !important;
            background: #f8fafc !important;
            color: #1d3557 !important;
            font-size: 11px;
            font-weight: 900;
            text-transform: uppercase;
            white-space: nowrap;
        }

        .table.dataTable tr td,
        #invtable tbody td,
        #inv_details tbody td {
            vertical-align: middle;
            background: #fff !important;
            color: #172033;
            font-size: 12px;
        }

        #invtable input,
        #invtable select,
        #invtable textarea {
            min-height: 32px;
            border: 1px solid #cfd9e6;
            border-radius: 6px;
            padding: 4px 7px;
            font-size: 12px;
        }

        #invtable textarea {
            min-width: 160px;
            min-height: 36px;
        }

        .dataTables_length,
        .dataTables_info {
            float: left !important;
        }

        .dataTables_wrapper .dataTables_filter input {
            border: 1px solid #cfd9e6;
            border-radius: 7px;
            min-height: 34px;
            padding: 5px 9px;
        }

        .dt-buttons {
            position: static;
            padding-left: 0;
            float: left;
        }

        .buttons-excel,
        .buttons-html5 {
            border: 0;
            border-radius: 7px;
            background: var(--inv-blue);
            color: #fff;
            box-shadow: none;
            font-weight: 800;
            margin: 0 8px 8px 0;
        }

        /* Page loader - fixed to viewport center and independent from master-page styles */
        #load1.invoice-loading-overlay {
            display: none;
            position: fixed !important;
            top: 0 !important;
            right: 0 !important;
            bottom: 0 !important;
            left: 0 !important;
            width: 100vw !important;
            height: 100vh !important;
            z-index: 999999 !important;
            background: rgba(15, 23, 42, .36);
            align-items: center !important;
            justify-content: center !important;
        }

        #load1.invoice-loading-overlay.is-active {
            display: flex !important;
        }

        #load1 .invoice-loading-card {
            width: 230px;
            min-height: 140px;
            padding: 24px 22px;
            border: 1px solid rgba(203, 213, 225, .9);
            border-radius: 12px;
            background: #fff;
            text-align: center;
            box-shadow: 0 24px 70px rgba(15, 23, 42, .30);
        }

        #load1 .invoice-loading-card img {
            display: block;
            width: 68px;
            height: 68px;
            margin: 0 auto 10px;
            object-fit: contain;
        }

        #load1 .invoice-loading-card .invoice-loading-text {
            margin-top: 8px;
            color: #334155;
            font-size: 13px;
            font-weight: 900;
        }



        /* Loader hard fix: master pages / old jQuery .show() may inject display:block. Force true viewport centering. */
        #load1.invoice-loading-overlay,
        #load1.invoice-loading-overlay[style],
        #load1.invoice-loading-overlay[style*="display: block"],
        #load1.invoice-loading-overlay[style*="display:block"] {
            position: fixed !important;
            inset: 0 !important;
            top: 0 !important;
            left: 0 !important;
            width: 100vw !important;
            height: 100vh !important;
            z-index: 2147483647 !important;
            background: rgba(15, 23, 42, .42) !important;
            align-items: center !important;
            justify-content: center !important;
            text-align: center !important;
        }

        #load1.invoice-loading-overlay.is-active,
        #load1.invoice-loading-overlay[style*="display: block"],
        #load1.invoice-loading-overlay[style*="display:block"] {
            display: flex !important;
        }

        #load1.invoice-loading-overlay:not(.is-active):not([style*="display: block"]):not([style*="display:block"]) {
            display: none !important;
        }

        #load1 .invoice-loading-card {
            position: fixed !important;
            top: 50% !important;
            left: 50% !important;
            transform: translate(-50%, -50%) !important;
            margin: 0 !important;
            z-index: 2147483647 !important;
        }

        /* DataTable usability: fixed header + sticky first 4 visible columns fallback. */
        .invoice-table-shell {
           /* max-height: calc(100vh - 290px);*/
            overflow: auto !important;
            border: 1px solid var(--inv-border);
            border-radius: 8px;
            background: #fff;
        }

        #invtable {
            border-collapse: separate !important;
            border-spacing: 0 !important;
            min-width: 2450px;
        }

        #invtable thead th {
            position: sticky !important;
            top: 0 !important;
            z-index: 40 !important;
            box-shadow: inset 0 -1px 0 var(--inv-border);
        }

        #invtable thead th:nth-child(2),
        #invtable tbody td:nth-child(2) {
            position: sticky !important;
            left: 0 !important;
            min-width: 72px;
            width: 72px;
            z-index: 55 !important;
            box-shadow: 2px 0 3px rgba(15, 23, 42, .08);
        }

        #invtable thead th:nth-child(4),
        #invtable tbody td:nth-child(4) {
            position: sticky !important;
            left: 72px !important;
            min-width: 170px;
            width: 170px;
            z-index: 54 !important;
            box-shadow: 2px 0 3px rgba(15, 23, 42, .08);
        }

        #invtable thead th:nth-child(5),
        #invtable tbody td:nth-child(5) {
            position: sticky !important;
            left: 242px !important;
            min-width: 150px;
            width: 150px;
            z-index: 53 !important;
            box-shadow: 2px 0 3px rgba(15, 23, 42, .08);
        }

        #invtable thead th:nth-child(6),
        #invtable tbody td:nth-child(6) {
            position: sticky !important;
            left: 392px !important;
            min-width: 190px;
            width: 190px;
            z-index: 52 !important;
            box-shadow: 2px 0 3px rgba(15, 23, 42, .08);
        }

        #invtable tbody td:nth-child(2),
        #invtable tbody td:nth-child(4),
        #invtable tbody td:nth-child(5),
        #invtable tbody td:nth-child(6) {
            background: #fff !important;
        }

        #invtable thead th:nth-child(2),
        #invtable thead th:nth-child(4),
        #invtable thead th:nth-child(5),
        #invtable thead th:nth-child(6) {
            background: #eef6ff !important;
            z-index: 75 !important;
        }

        #invtable th,
        #invtable td {
            white-space: nowrap !important;
        }

        #invtable td:nth-child(6),
        #invtable td:nth-child(17),
        #invtable td:nth-child(18) {
            white-space: normal !important;
        }

        .invoice-modal.modal.fade .modal-dialog {
            transform: translate3d(0, 24px, 0) scale(.98);
            transition: transform .24s ease, opacity .24s ease;
        }

        .invoice-modal.modal.show .modal-dialog {
            transform: translate3d(0, 0, 0) scale(1);
        }

        .invoice-modal .modal-dialog {
            max-width: min(1120px, calc(100vw - 48px));
        }

        .invoice-modal .modal-content {
            border: 0;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 26px 80px rgba(15, 23, 42, .32);
        }

        .invoice-modal .modal-header {
            align-items: center;
            min-height: 64px;
            padding: 17px 22px;
            border-bottom: 0;
            color: #fff;
            background: linear-gradient(135deg, #173567 0%, #0f766e 100%);
        }

        .invoice-modal .modal-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0;
            color: #fff;
            font-size: 19px;
            font-weight: 800;
            letter-spacing: 0;
        }

        .invoice-modal .modal-title i {
            width: 34px;
            height: 34px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.16);
        }

        .invoice-modal .close {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 34px;
            height: 34px;
            margin: 0;
            padding: 0;
            border-radius: 50%;
            background: rgba(255,255,255,.14);
            color: #fff;
            text-shadow: none;
            opacity: 1;
        }

        .invoice-modal .modal-body {
            max-height: calc(100vh - 190px);
            overflow-y: auto;
            padding: 22px;
            background: var(--inv-soft);
        }

        .invoice-modal .modal-footer {
            gap: 10px;
            padding: 15px 22px;
            border-top: 1px solid #e5e7eb;
            background: #fff;
        }

        @media (max-width: 991.98px) {
            .invoice-filter-grid,
            .invoice-form-grid,
            .invoice-form-grid.two-col {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 767.98px) {
            .invoice-hero,
            .invoice-panel-head {
                align-items: flex-start;
                flex-direction: column;
            }

            .invoice-chip-row,
            .invoice-actions {
                justify-content: flex-start;
            }

            .invoice-filter-grid,
            .invoice-form-grid,
            .invoice-form-grid.two-col {
                grid-template-columns: 1fr;
            }

            .invoice-modal .modal-dialog {
                max-width: calc(100vw - 18px);
                margin: .75rem auto;
            }

            .invoice-modal .modal-body {
                max-height: calc(100vh - 150px);
                padding: 14px;
            }
        }
    </style>
    <script> 

        function showInvoiceLoader() {
            var loader = document.getElementById('load1');
            if (loader) {
                loader.classList.add('is-active');
                loader.style.setProperty('display', 'flex', 'important');
                loader.style.setProperty('position', 'fixed', 'important');
                loader.style.setProperty('inset', '0', 'important');
            }
        }

        function hideInvoiceLoader() {
            var loader = document.getElementById('load1');
            if (loader) {
                loader.classList.remove('is-active');
                loader.style.removeProperty('display');
            }
        }

        window.addEventListener('error', function () {
            hideInvoiceLoader();
        });

        window.addEventListener('unhandledrejection', function () {
            hideInvoiceLoader();
        });

        const getFileName = (event) => {
            const files = event.target.files;
            if (!files || !files.length) {
                return;
            }
            var file = files[0];
            document.getElementById("filep_inv").value = file.name;

            const fd = new FormData();

            // add all selected files
            fd.append(event.target.name, file, file.name);
            // create the request
            const xhr = new XMLHttpRequest();

            xhr.onload = () => {
                if (xhr.status >= 200 && xhr.status < 300) {
                    // we done!
                }
            };
            var url = window.location.href;
            // path to server would be where you'd normally post the form to
            xhr.open('POST', url, true);
            xhr.send(fd);
        }

        $(document).ready(function () {
            document.getElementById("lbl_LoginEmpID").innerHTML = '<%= HttpContext.Current.User.Identity.Name.ToString() %>';
            //BindInvoiceGrid();
            BindYear_INV();
            invver_bindusers();
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="filep_inv" style="display: none;" />
    <label id="lbl_LoginEmpID" style="display: none;"></label>
    <div class="invoice-loading-overlay" id="load1" aria-hidden="true" style="display:none;">
        <div class="invoice-loading-card">
            <img src="../images/Load_1.gif" alt="Loading" />
            <div class="invoice-loading-text">One moment, please...</div>
        </div>
    </div>

    <div class="invoice-page">
        <div class="invoice-shell">
            <header class="invoice-hero">
                <div class="invoice-title">
                    <span class="icon-box"><i class="fas fa-file-invoice-dollar"></i></span>
                    <div>
                        <h1>Credit Card Reconciliation</h1>
                        <p>Verify monthly IT invoices, attachments, utilization, and card mapping</p>
                    </div>
                </div>
                <div class="invoice-chip-row">
                    <span class="invoice-chip"><i class="fas fa-calendar-check"></i>Monthly Verification</span>
                    <span class="invoice-chip"><i class="fas fa-credit-card"></i>Card Tracking</span>
                </div>
            </header>

            <section class="invoice-panel">
                <div class="invoice-panel-head">
                    <div class="invoice-section-title">
                        <i class="fas fa-filter"></i>
                        <h2>Invoice Period</h2>
                    </div>
                    <div class="invoice-actions">
                        <button id="inv_btnupdate" class="btn-invoice btn-invoice-soft" style="display: none;" onclick="return InsertInvoiceDetails();">
                            <i class="fas fa-sync-alt"></i>Update Data
                        </button>
                        <button id="inv_btnaddNewProduct" name="inv_btnaddNewProduct" type="button" class="btn-invoice btn-invoice-primary" onclick="return addNewProduct();">
                            <i class="fas fa-plus"></i>Add New Product
                        </button>
                    </div>
                </div>
                <div class="invoice-panel-body">
                    <div class="invoice-filter-grid">
                        <div class="invoice-field">
                            <label for="inv_month">Month</label>
                            <select id="inv_month" name="inv_month" class="form-control">
                                <option value="">Select</option>
                                <option value="All">All</option>
                                <option value="January">January</option>
                                <option value="February">February</option>
                                <option value="March">March</option>
                                <option value="April">April</option>
                                <option value="May">May</option>
                                <option value="June">June</option>
                                <option value="July">July</option>
                                <option value="August">August</option>
                                <option value="September">September</option>
                                <option value="October">October</option>
                                <option value="November">November</option>
                                <option value="December">December</option>
                            </select>
                        </div>
                        <div class="invoice-field">
                            <label for="inv_year">Year</label>
                            <select id="inv_year" name="inv_year" class="form-control">
                                <option value="">Select</option>
                            </select>
                        </div>
                        <div class="invoice-field">
                            <button id="btnShow" type="button" class="btn-invoice btn-invoice-primary" onclick="return BindInvoiceGrid();">
                                <i class="fas fa-search"></i>Show
                            </button>
                        </div>
                    </div>
                </div>
            </section>

            <section class="invoice-panel">
                <div class="invoice-panel-head">
                    <div class="invoice-section-title">
                        <i class="fas fa-table"></i>
                        <h2>Invoice Verification Details</h2>
                    </div>
                </div>
                <div class="invoice-panel-body">
                    <div class="invoice-table-shell">
                        <table class="table table-striped table-hover" id="invtable">
                            <thead>
                                <tr>
                                    <th class="sort border-top" style="display: none;">HeaderID</th>
                                    <th class="sort border-top">Details</th>
                                    <th class="sort border-top" style="display: none;">SubHeader</th>
                                    <th class="sort border-top">Header</th>
                                    <th class="sort border-top">Domain</th>
                                    <th class="sort border-top">Product</th>
                                    <th class="sort border-top">Pay To</th>
                                    <th class="sort border-top">Payment Frequency</th>
                                    <th class="sort border-top">Cost Type</th>
                                    <th class="sort border-top text-center">Contractual Quantity</th>
                                    <th class="sort border-top text-center">Contractual Per Unit Cost</th>
                                    <th class="sort border-top text-center">Chargeable Amount</th>
                                    <th class="sort border-top text-center">Prev. Month Charged Amount</th>
                                    <th class="sort border-top text-center">Prev. Month Quantity</th>
                                    <th class="sort border-top text-center">Current Quantity</th>
                                    <th class="sort border-top text-center">Amount Charged</th>
                                    <th class="sort border-top">Difference</th>
                                    <th class="sort border-top">Remark</th>
                                    <th class="sort border-top">Invoice #</th>
                                    <th class="sort border-top">Invoice Attachment</th>
                                    <th class="sort border-top">Utilization</th>
                                    <th class="sort border-top" style="display: none;">Provider</th>
                                    <th class="sort border-top" style="display: none;">Product</th>
                                    <th class="sort border-top">Update</th>
                                    <th class="sort border-top">CC #</th>
                                    <th class="sort border-top" style="display: none;">HeaderStatus</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </section>
        </div>
    </div>

    <div class="modal fade invoice-modal" id="inv_detailspop" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title"><i class="fas fa-list"></i>Details</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <label id="invdetails_headerid" style="display: none;"></label>
                    <div class="invoice-actions" style="margin-bottom: 12px;">
                        <button id="invdetails_btnadd" type="button" onclick="return invdeatails_addnewuser();" class="btn-invoice btn-invoice-primary">
                            <i class="fas fa-user-plus"></i>Add User
                        </button>
                    </div>
                    <div class="invoice-table-shell">
                        <table class="table table-striped table-hover" id="inv_details">
                            <thead>
                                <tr>
                                    <th class="sort border-top" style="display: none;">Sr. #</th>
                                    <th class="sort border-top">Sr. #</th>
                                    <th class="sort border-top" id="inv_headername">Number</th>
                                    <th class="sort border-top" id="inv_headercost">Cost</th>
                                    <th class="sort border-top">Code</th>
                                    <th class="sort border-top">Name</th>
                                    <th class="sort border-top">Pseudoname</th>
                                    <th class="sort border-top">Branch</th>
                                    <th class="sort border-top">Domain</th>
                                    <th class="sort border-top">Current Status</th>
                                    <th class="sort border-top">Remove User</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
                <div class="modal-footer justify-content-end">
                    <button type="button" class="btn-invoice btn-invoice-soft" data-dismiss="modal"><i class="fas fa-times"></i>Close</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade invoice-modal" id="invdetailspopup_AddUser" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title"><i class="fas fa-user-plus"></i>Add New User</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="invoice-form-grid">
                        <div class="invoice-field full">
                            <label for="invdetails_users">Employee</label>
                            <select id="invdetails_users" name="invdetails_users" class="form-control" onchange="return addOtherUser(this);"></select>
                        </div>
                        <div class="invoice-field full" id="trOtherUser" style="display: none;">
                            <label for="invetails_otheruser">Other</label>
                            <input type="text" id="invetails_otheruser" name="invetails_otheruser" class="form-control" />
                        </div>
                        <div class="invoice-field full">
                            <label for="invetails_effectivedate">Effective Date</label>
                            <input type="date" id="invetails_effectivedate" name="invetails_effectivedate" class="form-control" />
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn-invoice btn-invoice-soft" onclick="return invdetails_closeuser();"><i class="fas fa-times"></i>Close</button>
                    <button id="invdetails_btnSubmitUser" type="button" onclick="return invdetails_SubmitUser();" class="btn-invoice btn-invoice-primary"><i class="fas fa-plus"></i>Add</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade invoice-modal" id="invdetailspopup_removeUser" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title"><i class="fas fa-user-minus"></i>Remove User</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="invoice-form-grid">
                        <div class="invoice-field full">
                            <label>Employee</label>
                            <label id="invdetails_InvID" name="invdetails_InvID" class="invoice-readonly" style="display: none;"></label>
                            <label id="invdetails_delusers" name="invdetails_delusers" class="invoice-readonly"></label>
                        </div>
                        <div class="invoice-field full">
                            <label for="invetails_deleffectivedate">Effective Date</label>
                            <input type="date" id="invetails_deleffectivedate" name="invetails_deleffectivedate" class="form-control" />
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn-invoice btn-invoice-soft" onclick="return invdetails_closedeluser();"><i class="fas fa-times"></i>Close</button>
                    <button id="invdetails_btnSubmitdelUser" type="button" onclick="return invdetails_SubmitdelUser();" class="btn-invoice btn-invoice-primary"><i class="fas fa-user-minus"></i>Remove</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade invoice-modal" id="invdetailspopup_AddNewProduct" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title"><i class="fas fa-plus-square"></i>Add New Product</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="invoice-form-grid two-col">
                        <div class="invoice-field">
                            <label for="invdetails_NewProdHeader">Header</label>
                            <input type="text" id="invdetails_NewProdHeader" name="invdetails_NewProdHeader" class="form-control" />
                        </div>
                        <div class="invoice-field">
                            <label for="invetails_NewProdDomain">Domain</label>
                            <input type="text" id="invetails_NewProdDomain" name="invetails_NewProdDomain" class="form-control" />
                        </div>
                        <div class="invoice-field">
                            <label for="invetails_NewProdProduct">Product</label>
                            <input type="text" id="invetails_NewProdProduct" name="invetails_NewProdProduct" class="form-control" />
                        </div>
                        <div class="invoice-field">
                            <label for="invdetails_NewProdPayTo">Pay To</label>
                            <input type="text" id="invdetails_NewProdPayTo" name="invdetails_NewProdPayTo" class="form-control" />
                        </div>
                        <div class="invoice-field">
                            <label for="invdetails_NewProdPaymentFreq">Payment Frequency</label>
                            <select id="invdetails_NewProdPaymentFreq" name="invdetails_NewProdPaymentFreq" class="form-control">
                                <option value="Select">Select</option>
                                <option value="Monthly">Monthly</option>
                                <option value="Yearly">Yearly</option>
                            </select>
                        </div>
                        <div class="invoice-field">
                            <label for="invdetails_NewProdCostType">Cost Type</label>
                            <select id="invdetails_NewProdCostType" name="invdetails_NewProdCostType" class="form-control">
                                <option value="Select">Select</option>
                                <option value="Variable">Variable</option>
                                <option value="Fixed">Fixed</option>
                            </select>
                        </div>
                        <div class="invoice-field">
                            <label for="invdetails_NewProdEffDate">Effective Date</label>
                            <input type="date" id="invdetails_NewProdEffDate" name="invdetails_NewProdEffDate" class="form-control" />
                        </div>
                        <div class="invoice-field">
                            <label for="invdetails_NewProdContQuantity">Contractual Quantity</label>
                            <input type="number" id="invdetails_NewProdContQuantity" name="invdetails_NewProdContQuantity" class="form-control" />
                        </div>
                        <div class="invoice-field">
                            <label for="invdetails_NewProdContPerUnitCost">Contractual Per Unit Cost</label>
                            <input type="number" id="invdetails_NewProdContPerUnitCost" name="invdetails_NewProdContPerUnitCost" class="form-control" />
                        </div>
                        <div class="invoice-field">
                            <label for="invdetails_NewProdCharAmt">Chargeable Amount</label>
                            <input type="number" id="invdetails_NewProdCharAmt" name="invdetails_NewProdCharAmt" class="form-control" />
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn-invoice btn-invoice-soft" data-dismiss="modal"><i class="fas fa-times"></i>Close</button>
                    <button id="invdetails_btnNewProd" type="button" onclick="return invdetails_btnAddNewProd();" class="btn-invoice btn-invoice-primary"><i class="fas fa-plus"></i>Add Product</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade invoice-modal" id="invdetailspopup_AddEnableDisable" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title"><i class="fas fa-toggle-on"></i><span id="invdetails_EnableDisableLbl"></span></h6>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="invoice-form-grid">
                        <div class="invoice-field full">
                            <label for="nvdetails_EnableDisableRemark">Remark</label>
                            <textarea id="nvdetails_EnableDisableRemark" name="nvdetails_EnableDisableRemark" class="form-control"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn-invoice btn-invoice-soft" data-dismiss="modal"><i class="fas fa-times"></i>Close</button>
                    <button id="invdetails_btnEnableDisable" type="button" onclick="return invdetails_btnSetEnableDisable();" class="btn-invoice btn-invoice-primary">Update</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
