<%@ Page Title="" Language="C#" MasterPageFile="~/Vendor/VendorMaster.Master" AutoEventWireup="true" CodeBehind="VendorRegistration.aspx.cs" Inherits="WebPortal.Vendor.VendorRegistration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .erp-page {
            padding: 0px;
        }

        .erp-hero {
            display: flex;
            align-items: center;
            padding: 22px 28px;
            border-radius: 18px;
            color: #fff;
            margin-bottom: 20px;
            background: linear-gradient(90deg,#274b9f,#2f80ed,#38c6e8);
            position: relative;
            overflow: hidden;
        }

            .erp-hero:after {
                content: '';
                position: absolute;
                right: -80px;
                top: -50px;
                width: 220px;
                height: 220px;
                background: rgba(255,255,255,.08);
                border-radius: 50%;
            }

        .erp-hero-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: rgba(255,255,255,.15);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            margin-right: 18px;
        }

        .erp-hero h2 {
            margin: 0;
            font-size: 32px;
            font-weight: 600;
            color: white !important;
        }

        .erp-hero p {
            margin: 6px 0 0;
            font-size: 15px;
            opacity: .95;
        }

        .erp-hero h2 {
            margin: 0;
            font-size: 21px;
            color: #2f4050;
            font-weight: 600;
        }

        .erp-breadcrumb {
            margin-top: 5px;
            color: #7b8794;
            font-size: 12px;
        }

        .erp-panel {
            background: #fff;
            border: 1px solid #dfe5ec;
            border-radius: 6px;
            margin-bottom: 15px;
            box-shadow: 0 1px 2px rgba(0,0,0,.04);
        }

        .erp-panel-title {
            padding: 11px 15px;
            border-bottom: 1px solid #e7ebf0;
            font-size: 15px;
            font-weight: 600;
            color: #34495e;
            background: #fafbfc;
        }

        .erp-panel-body {
            padding: 15px;
        }

        .erp-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(180px, 1fr));
            gap: 13px 15px;
        }

        .erp-field {
            min-width: 0;
        }

            .erp-field.span-2 {
                grid-column: span 2;
            }

            .erp-field.span-4 {
                grid-column: span 4;
            }

        .erp-label {
            display: block;
            font-size: 12px;
            font-weight: 600;
            color: #475569;
            margin-bottom: 5px;
        }

        .required {
            color: #d9534f;
        }

        .erp-control {
            width: 100%;
            height: 34px;
            border: 1px solid #cbd5e1;
            border-radius: 4px;
            padding: 6px 9px;
            font-size: 13px;
            background: #fff;
            box-sizing: border-box;
        }

        textarea.erp-control {
            height: 70px;
            resize: vertical;
        }

        .erp-control:focus {
            border-color: #7aa7d9;
            outline: 0;
            box-shadow: 0 0 0 2px rgba(80,130,180,.12);
        }

        .erp-control[readonly], .erp-control:disabled {
            background: #f1f5f9;
            cursor: not-allowed;
        }

        .name-row {
            display: grid;
            grid-template-columns: 105px 1fr 1fr 1fr;
            gap: 8px;
        }

        .erp-actions {
            padding-top: 2px;
            display: flex;
            gap: 8px;
        }

        .erp-btn {
            border: 0;
            border-radius: 4px;
            padding: 8px 16px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
        }

        .erp-btn-primary {
            background: #337ab7;
            color: #fff;
        }

            .erp-btn-primary:hover {
                background: #286090;
            }

        .erp-btn-light {
            background: #eef2f6;
            color: #334155;
            border: 1px solid #cbd5e1;
        }

            .erp-btn-light:hover {
                background: #e2e8f0;
            }

        .erp-btn:disabled {
            opacity: .65;
            cursor: not-allowed;
        }

        .erp-alert {
            display: none;
            margin-bottom: 14px;
            padding: 10px 13px;
            border-radius: 4px;
            font-size: 13px;
        }

            .erp-alert.success {
                display: block;
                color: #256029;
                background: #edf7ed;
                border: 1px solid #b7dfb9;
            }

            .erp-alert.error {
                display: block;
                color: #a12622;
                background: #fff0ef;
                border: 1px solid #efc2bf;
            }

        .field-error {
            border-color: #d9534f !important;
        }

        .error-text {
            color: #d9534f;
            font-size: 11px;
            margin-top: 3px;
            min-height: 14px;
        }

        .grid-wrap {
            position: relative;
            overflow: hidden;
        }

        .grid-loader {
            display: none;
            position: absolute;
            inset: 0;
            z-index: 10;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.72);
        }

            .grid-loader.show {
                display: flex;
            }

        .loader-box {
            padding: 10px 16px;
            border: 1px solid #ccd5df;
            background: #fff;
            border-radius: 4px;
            box-shadow: 0 2px 8px rgba(0,0,0,.08);
            font-size: 13px;
        }

        #vendorTable {
            width: 100% !important;
            white-space: nowrap;
        }

            #vendorTable th {
                background: #eef3f8;
                color: #34495e;
                font-size: 12px;
            }

            #vendorTable td {
                font-size: 12px;
                vertical-align: middle;
            }

        .edit-icon {
            display: inline-flex;
            width: 28px;
            height: 26px;
            align-items: center;
            justify-content: center;
            border: 1px solid #cbd5e1;
            border-radius: 4px;
            background: #fff;
            cursor: pointer;
        }

            .edit-icon:hover {
                background: #eef5fb;
            }

            .edit-icon img {
                width: 16px;
                height: 16px;
            }

        div.dataTables_wrapper div.dataTables_filter input {
            height: 30px;
            border: 1px solid #cbd5e1;
            border-radius: 4px;
        }

        div.dataTables_wrapper div.dataTables_length select {
            height: 30px;
            border: 1px solid #cbd5e1;
            border-radius: 4px;
        }

        @media (max-width: 1100px) {
            .erp-grid {
                grid-template-columns: repeat(2, minmax(180px, 1fr));
            }

            .erp-field.span-4 {
                grid-column: span 2;
            }
        }

        @media (max-width: 700px) {
            .erp-grid {
                grid-template-columns: 1fr;
            }

            .erp-field.span-2, .erp-field.span-4 {
                grid-column: span 1;
            }

            .name-row {
                grid-template-columns: 1fr;
            }
        }

        .dataTables_wrapper {
            font-size: 13px;
        }

        table.dataTable {
            border-collapse: collapse !important;
        }

            table.dataTable thead th {
                background: #f4f7fb;
                color: #243b63;
                font-weight: 600;
                border-bottom: 2px solid #d9e2ef;
                white-space: nowrap;
                padding: 12px;
            }

            table.dataTable tbody td {
                white-space: nowrap;
                padding: 9px 12px;
                border-bottom: 1px solid #eef2f7;
            }

            table.dataTable tbody tr:hover {
                background: #eef7ff;
            }

        .dataTables_scrollHead {
            border: 1px solid #dbe5ef;
            border-bottom: none;
        }

        .dataTables_scrollBody {
            border: 1px solid #dbe5ef;
        }

        .dataTables_filter input {
            border: 1px solid #c8d3df;
            border-radius: 20px;
            padding: 6px 14px;
        }

        .dataTables_filter {
            margin-bottom: 12px;
        }

        .DTFC_LeftWrapper {
            background: #fff;
        }

        .grid-icon {
            width: 30px;
            height: 30px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 6px;
            color: #fff;
            margin-right: 5px;
            cursor: pointer;
            transition: .2s;
        }

            .grid-icon.edit {
                background: #2f80ed;
            }

            .grid-icon.delete {
                background: #eb5757;
            }

            .grid-icon.view {
                background: #27ae60;
            }

            .grid-icon:hover {
                transform: scale(1.08);
                opacity: .9;
            }

        .page-loading-overlay {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 99999;
            background: rgba(15, 23, 42, .48);
            align-items: center;
            justify-content: center;
            backdrop-filter: blur(1px);
        }

            .page-loading-overlay.show {
                display: flex;
            }

        .page-loading-card {
            min-width: 260px;
            padding: 24px 28px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 16px 42px rgba(15, 23, 42, .28);
            text-align: center;
            color: #334155;
        }

        .page-loading-spinner {
            width: 42px;
            height: 42px;
            margin: 0 auto 14px;
            border: 4px solid #dbeafe;
            border-top-color: #2f80ed;
            border-radius: 50%;
            animation: vendorSpin .8s linear infinite;
        }

        .page-loading-title {
            font-size: 15px;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .page-loading-text {
            font-size: 12px;
            color: #64748b;
        }

        @keyframes vendorSpin {
            to {
                transform: rotate(360deg);
            }
        }

        .status-popup-overlay {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 100000;
            background: rgba(15, 23, 42, .38);
            align-items: center;
            justify-content: center;
        }

            .status-popup-overlay.show {
                display: flex;
            }

        .status-popup-card {
            width: min(420px, calc(100% - 32px));
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 18px 50px rgba(15, 23, 42, .30);
            overflow: hidden;
            animation: popupIn .18s ease-out;
        }

        .status-popup-head {
            padding: 18px 20px 12px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .status-popup-icon {
            width: 42px;
            height: 42px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 20px;
            flex: 0 0 42px;
        }

        .status-popup-card.success .status-popup-icon {
            background: #22c55e;
        }

        .status-popup-card.error .status-popup-icon {
            background: #ef4444;
        }

        .status-popup-title {
            font-size: 17px;
            font-weight: 700;
            color: #1e293b;
        }

        .status-popup-message {
            padding: 0 20px 18px 74px;
            color: #475569;
            font-size: 13px;
            line-height: 1.55;
        }

        .status-popup-actions {
            padding: 12px 20px 18px;
            text-align: right;
            border-top: 1px solid #eef2f7;
        }

        .status-popup-ok {
            border: 0;
            border-radius: 5px;
            padding: 8px 22px;
            background: #2f80ed;
            color: #fff;
            font-weight: 600;
            cursor: pointer;
        }

        @keyframes popupIn {
            from {
                opacity: 0;
                transform: translateY(-8px) scale(.98);
            }

            to {
                opacity: 1;
                transform: none;
            }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="erp-page">
        <div class="erp-hero">
            <div class="erp-hero-icon">
                <i class="fas fa-users mr-2"></i>
            </div>

            <div class="erp-hero-content">
                <h2>Vendor Registration</h2>
                <p>Manage vendor information, contact details and reporting manager.</p>
            </div>
        </div>

        <div id="messageBox" class="erp-alert"></div>

        <div class="erp-panel">
            <div class="erp-panel-title">Vendor Details</div>
            <div class="erp-panel-body">
                <input type="hidden" id="vendorId" value="0" />

                <div class="erp-grid">
                    <div class="erp-field">
                        <label class="erp-label">Vendor Code</label>
                        <input type="text" id="vendorCode" class="erp-control" readonly="readonly" />
                    </div>

                    <div class="erp-field span-4">
                        <label class="erp-label"><span class="required">*</span> Name</label>
                        <div class="name-row">
                            <select id="title" class="erp-control">
                                <option value="">Select Title</option>
                                <option value="Ms.">Ms.</option>
                                <option value="Mrs.">Mrs.</option>
                                <option value="Mr.">Mr.</option>
                            </select>
                            <input type="text" id="firstName" class="erp-control alpha-only upper" maxlength="100" placeholder="First Name" />
                            <input type="text" id="middleName" class="erp-control alpha-only upper" maxlength="100" placeholder="Middle Name" />
                            <input type="text" id="lastName" class="erp-control alpha-only upper" maxlength="100" placeholder="Last Name" />
                        </div>
                        <div id="nameError" class="error-text"></div>
                    </div>

                    <div class="erp-field">
                        <label class="erp-label"><span class="required">*</span> Vendor Type</label>
                        <select id="vendorType" class="erp-control">
                            <option value="">Select Vendor Type</option>
                            <option value="Admin">Admin</option>
                            <option value="Abstractor">Abstractor</option>
                            <option value="Search Firm">Search Firm</option>
                            <option value="Attorney">Attorney</option>
                        </select>
                        <div class="error-text"></div>
                    </div>

                    <div class="erp-field">
                        <label class="erp-label"><span id="managerRequired" class="required">*</span> Reporting Manager</label>
                        <select id="reportingManager" class="erp-control">
                            <option value="0">Select Reporting Manager</option>
                        </select>
                        <div class="error-text"></div>
                    </div>

                    <div class="erp-field span-2">
                        <label class="erp-label"><span class="required">*</span> Company Name</label>
                        <input type="text" id="companyName" class="erp-control upper" maxlength="250" />
                        <div class="error-text"></div>
                    </div>

                    <div class="erp-field span-4">
                        <label class="erp-label"><span class="required">*</span> Address</label>
                        <textarea id="address" class="erp-control" maxlength="1000"></textarea>
                        <div class="error-text"></div>
                    </div>

                    <div class="erp-field">
                        <label class="erp-label"><span class="required">*</span> Contact #1</label>
                        <input type="text" id="contact1" class="erp-control numeric-only" maxlength="15" />
                        <div class="error-text"></div>
                    </div>

                    <div class="erp-field">
                        <label class="erp-label"><span class="required">*</span> Extension</label>
                        <input type="text" id="extension" class="erp-control numeric-only" maxlength="6" />
                        <div class="error-text"></div>
                    </div>

                    <div class="erp-field">
                        <label class="erp-label">Contact #2</label>
                        <input type="text" id="contact2" class="erp-control numeric-only" maxlength="15" />
                    </div>

                    <div class="erp-field">
                        <label class="erp-label">Mobile #</label>
                        <input type="text" id="mobile" class="erp-control numeric-only" maxlength="15" />
                    </div>

                    <div class="erp-field">
                        <label class="erp-label"><span class="required">*</span> Fax #</label>
                        <input type="text" id="fax" class="erp-control numeric-only" maxlength="15" />
                        <div class="error-text"></div>
                    </div>

                    <div class="erp-field span-2">
                        <label class="erp-label"><span class="required">*</span> Email Address</label>
                        <input type="email" id="emailAddress" class="erp-control" maxlength="250" />
                        <div class="error-text"></div>
                    </div>

                    <div class="erp-field span-4">
                        <div class="erp-actions">
                            <button type="button" id="btnSubmit" class="erp-btn erp-btn-primary">Submit</button>
                            <button type="button" id="btnClear" class="erp-btn erp-btn-light">Clear</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="erp-panel">
            <div class="erp-panel-title">Registered Vendors</div>
            <div class="erp-panel-body grid-wrap">
                <div id="gridLoader" class="grid-loader">
                    <div class="loader-box">Loading vendor records...</div>
                </div>
                <table id="vendorTable" class="display compact stripe" cellspacing="0">
                    <thead>
                        <tr></tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>


    <div id="pageLoading" class="page-loading-overlay" aria-hidden="true">
        <div class="page-loading-card">
            <div class="page-loading-spinner"></div>
            <div id="pageLoadingTitle" class="page-loading-title">Please wait...</div>
            <div id="pageLoadingText" class="page-loading-text">Processing your request.</div>
        </div>
    </div>

    <div id="statusPopup" class="status-popup-overlay" aria-hidden="true">
        <div id="statusPopupCard" class="status-popup-card success" role="dialog" aria-modal="true" aria-labelledby="statusPopupTitle">
            <div class="status-popup-head">
                <div id="statusPopupIcon" class="status-popup-icon"><i class="fa fa-check"></i></div>
                <div id="statusPopupTitle" class="status-popup-title">Success</div>
            </div>
            <div id="statusPopupMessage" class="status-popup-message"></div>
            <div class="status-popup-actions">
                <button type="button" id="btnStatusOk" class="status-popup-ok">OK</button>
            </div>
        </div>
    </div>

    <script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/fixedheader/3.4.0/js/dataTables.fixedHeader.min.js"></script>

    <script type="text/javascript">
        var vendorTable = null;
        var pageUrl = 'VendorRegistration.aspx/';

        $(function () {
            bindEvents();
            loadReportingManagers(function () {
                var id = getQueryString('VendorID');
                if (id) loadVendor(id);
            });
            loadVendors();
        });

        function bindEvents() {
            $('#btnSubmit').on('click', saveVendor);
            $('#btnClear').on('click', clearForm);
            $('#vendorType, #firstName, #middleName, #lastName').on('change blur', generateVendorCode);
            $('#vendorType').on('change', function () {
                toggleReportingManager();
                generateVendorCode(true);
            });
            $('#btnStatusOk').on('click', hideStatusPopup);
            $('#statusPopup').on('click', function (e) { if (e.target === this) hideStatusPopup(); });

            $('.alpha-only').on('input', function () {
                this.value = this.value.replace(/[^a-zA-Z\s.'-]/g, '');
            });
            $('.numeric-only').on('input', function () {
                this.value = this.value.replace(/[^0-9]/g, '');
            });
            $('.upper').on('input', function () {
                this.value = this.value.toUpperCase();
            });
        }

        function ajaxCall(method, data, success, failure) {
            $.ajax({
                type: 'POST',
                url: pageUrl + method,
                data: JSON.stringify(data || {}),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (response) { if (success) success(response.d); },
                error: function (xhr) {
                    var message = 'Something went wrong while processing the request.';
                    try { message = JSON.parse(xhr.responseText).Message || message; } catch (e) { }
                    if (failure) failure(message); else showMessage(message, false);
                }
            });
        }

        function loadReportingManagers(callback) {
            ajaxCall('GetReportingManagers', {}, function (rows) {
                var ddl = $('#reportingManager').empty().append($('<option/>').val('0').text('Select Reporting Manager'));
                $.each(rows || [], function (_, row) {
                    ddl.append($('<option/>').val(row.Value).text(row.Text));
                });
                if (callback) callback();
            });
        }

        function generateVendorCode(showPopup) {
            var type = $('#vendorType').val();
            var first = $.trim($('#firstName').val());
            var middle = $.trim($('#middleName').val());
            var last = $.trim($('#lastName').val());

            if (!type || !first || !last || Number($('#vendorId').val()) > 0) return;

            if (showPopup) showLoading('Generating Vendor Code', 'Please wait while the vendor code is generated.');

            ajaxCall('ValidateCode', {
                firstname: first,
                middlename: middle,
                lastname: last,
                EmployeeType: type
            }, function (code) {
                if (showPopup) hideLoading();
                $('#vendorCode').val(code || '');
                if (!code) showStatusPopup('Unable to generate vendor code. Please contact the administrator.', false);
            }, function (message) {
                if (showPopup) hideLoading();
                showStatusPopup(message, false);
            });
        }

        function toggleReportingManager() {
            var isAdmin = $('#vendorType').val() === 'Admin';
            $('#managerRequired').toggle(!isAdmin);
            if (isAdmin) $('#reportingManager').val('0');
        }

        function loadVendors() {
            $('#gridLoader').addClass('show');
            ajaxCall('GetVendors', {}, function (rows) {
                bindVendorTable(rows || []);
                $('#gridLoader').removeClass('show');
            }, function (message) {
                $('#gridLoader').removeClass('show');
                showMessage(message, false);
            });
        }

        function bindVendorTable(rows) {
            if (vendorTable) {
                vendorTable.destroy();
                $('#vendorTable thead tr').empty();
                $('#vendorTable tbody').empty();
            }

            var columns = [
                { title: 'Action', data: null, orderable: false, searchable: false, render: renderEdit },
                { title: 'Sr. #', data: null, orderable: false, searchable: false, render: function (_, __, ___, meta) { return meta.row + 1; } },
                { title: 'Vendor Code', data: 'VendorCode', defaultContent: '' },
                { title: 'Vendor Name', data: 'VendorName', defaultContent: '' },
                { title: 'Vendor Type', data: 'VendorType', defaultContent: '' },
                { title: 'Reporting Manager', data: 'ReportingManager', defaultContent: '' },
                { title: 'Company Name', data: 'ComapanyName', defaultContent: '' },
                { title: 'Address', data: 'Address', defaultContent: '' },
                { title: 'Contact #1', data: 'ContactNo', defaultContent: '' },
                { title: 'Contact #2', data: 'AlternateContactNo', defaultContent: '' },
                { title: 'Extension', data: 'Extension', defaultContent: '' },
                { title: 'Mobile #', data: 'MobileNo', defaultContent: '' },
                { title: 'Fax #', data: 'FaxNo', defaultContent: '' },
                { title: 'Email Address', data: 'EmailID', defaultContent: '' }
            ];

            vendorTable = $('#vendorTable').DataTable({
                data: rows,
                columns: columns,
                scrollX: true,
                scrollY: '55vh',
                scrollCollapse: true,
                paging: false,
                fixedHeader: true,
                autoWidth: false,
                order: [[2, 'asc']],
                language: { emptyTable: 'No vendor records found.' }
            });
        }

        function renderEdit(_, __, row) {
            var id = Number(row.VendorID || 0);
            return '<a class="grid-icon edit" onclick = "loadVendor(' + id + ')" ><i class="fa fa-edit"></i></a>';
            // <button type="button" class="edit-icon" title="Edit vendor" onclick="loadVendor(' + id + ')">' +
            //                 '<img src="../Images/Edit.png" alt="Edit" /></button>';
        }

        function loadVendor(vendorId) {
            ajaxCall('GetVendor', { vendorId: Number(vendorId) }, function (row) {
                if (!row || !row.VendorID) {
                    showMessage('Vendor record was not found.', false);
                    return;
                }

                $('#vendorId').val(row.VendorID);
                $('#vendorCode').val(row.VendorCode || '');
                $('#title').val(row.Title || '');
                $('#firstName').val(row.FirstName || '');
                $('#middleName').val(row.MiddleName || '');
                $('#lastName').val(row.LastName || '');
                $('#vendorType').val(row.VendorType || '');
                $('#reportingManager').val(String(row.ProjectManger || '0'));
                $('#companyName').val(row.ComapanyName || '');
                $('#address').val(row.Address || '');
                $('#contact1').val(row.ContactNo || '');
                $('#contact2').val(row.AlternateContactNo || '');
                $('#extension').val(row.Extension || '');
                $('#mobile').val(row.MobileNo || '');
                $('#fax').val(row.FaxNo || '');
                $('#emailAddress').val(row.EmailID || '');

                $('#title, #firstName, #middleName, #lastName, #vendorType').prop('disabled', true);
                $('#btnSubmit').text('Update');
                toggleReportingManager();
                $('html, body').animate({ scrollTop: $('.erp-hero').offset().top }, 250);
            });
        }

        function saveVendor() {
            clearValidation();
            if (!validateForm()) return;

            var input = {
                VendorID: Number($('#vendorId').val() || 0),
                VendorCode: $.trim($('#vendorCode').val()).toUpperCase(),
                Title: $('#title').val(),
                FirstName: $.trim($('#firstName').val()).toUpperCase(),
                MiddleName: $.trim($('#middleName').val()).toUpperCase(),
                LastName: $.trim($('#lastName').val()).toUpperCase(),
                VendorType: $('#vendorType').val(),
                ReportingManager: $('#reportingManager').val() || '0',
                CompanyName: $.trim($('#companyName').val()),
                Address: $.trim($('#address').val()),
                Contact1: $.trim($('#contact1').val()),
                Contact2: $.trim($('#contact2').val()),
                Extension: $.trim($('#extension').val()),
                Mobile: $.trim($('#mobile').val()),
                Fax: $.trim($('#fax').val()),
                EmailID: $.trim($('#emailAddress').val())
            };

            var isUpdate = input.VendorID > 0;
            $('#btnSubmit').prop('disabled', true).text(isUpdate ? 'Updating...' : 'Saving...');
            showLoading(isUpdate ? 'Updating Vendor' : 'Saving Vendor', isUpdate ? 'Please wait while the vendor details are updated.' : 'Please wait while the vendor details are saved.');
            ajaxCall('SaveVendor', { input: input }, function (result) {
                hideLoading();
                $('#btnSubmit').prop('disabled', false);
                if (result && result.Success) {
                    showStatusPopup(result.Message, true);
                    clearForm();
                    loadVendors();
                } else {
                    $('#btnSubmit').text(input.VendorID > 0 ? 'Update' : 'Submit');
                    showStatusPopup((result && result.Message) || 'Unable to save vendor registration.', false);
                }
            }, function (message) {
                hideLoading();
                $('#btnSubmit').prop('disabled', false).text(input.VendorID > 0 ? 'Update' : 'Submit');
                showStatusPopup(message, false);
            });
        }

        function validateForm() {
            var valid = true;
            valid = requireValue('#title', 'Please select title.') && valid;
            valid = requireValue('#firstName', 'Please enter first name.') && valid;
            valid = requireValue('#lastName', 'Please enter last name.') && valid;
            valid = requireValue('#vendorType', 'Please select vendor type.') && valid;

            if ($('#vendorType').val() !== 'Admin')
                valid = requireValue('#reportingManager', 'Please select reporting manager.', '0') && valid;

            valid = requireValue('#companyName', 'Please enter company name.') && valid;
            valid = requireValue('#address', 'Please enter address.') && valid;
            valid = requireValue('#contact1', 'Please enter contact number.') && valid;
            valid = requireValue('#extension', 'Please enter extension.') && valid;
            valid = requireValue('#fax', 'Please enter fax number.') && valid;
            valid = requireValue('#emailAddress', 'Please enter email address.') && valid;

            var email = $.trim($('#emailAddress').val());
            if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                setError('#emailAddress', 'Please enter a valid email address.');
                valid = false;
            }

            if (!$.trim($('#vendorCode').val())) {
                showMessage('Vendor code could not be generated. Verify the name and vendor type.', false);
                valid = false;
            }
            return valid;
        }

        function requireValue(selector, message, invalidValue) {
            var value = $.trim($(selector).val());
            if (!value || (invalidValue !== undefined && value === invalidValue)) {
                setError(selector, message);
                return false;
            }
            return true;
        }

        function setError(selector, message) {
            var control = $(selector).addClass('field-error');
            var field = control.closest('.erp-field');
            field.find('.error-text').first().text(message);
            if (selector === '#title' || selector === '#firstName' || selector === '#lastName') $('#nameError').text(message);
        }

        function clearValidation() {
            $('.erp-control').removeClass('field-error');
            $('.error-text').text('');
        }

        function clearForm() {
            $('#vendorId').val('0');
            $('#vendorCode, #firstName, #middleName, #lastName, #companyName, #address, #contact1, #contact2, #extension, #mobile, #fax, #emailAddress').val('');
            $('#title, #vendorType').val('');
            $('#reportingManager').val('0');
            $('#title, #firstName, #middleName, #lastName, #vendorType').prop('disabled', false);
            $('#btnSubmit').prop('disabled', false).text('Submit');
            clearValidation();
            toggleReportingManager();
            history.replaceState(null, document.title, 'VendorRegistration.aspx');
        }


        function showLoading(title, text) {
            $('#pageLoadingTitle').text(title || 'Please wait...');
            $('#pageLoadingText').text(text || 'Processing your request.');
            $('#pageLoading').addClass('show').attr('aria-hidden', 'false');
        }

        function hideLoading() {
            $('#pageLoading').removeClass('show').attr('aria-hidden', 'true');
        }

        function showStatusPopup(message, success) {
            var card = $('#statusPopupCard').removeClass('success error').addClass(success ? 'success' : 'error');
            $('#statusPopupTitle').text(success ? 'Success' : 'Error');
            $('#statusPopupIcon').html('<i class="fa ' + (success ? 'fa-check' : 'fa-times') + '"></i>');
            $('#statusPopupMessage').text(message || (success ? 'Operation completed successfully.' : 'Unable to complete the operation.'));
            $('#statusPopup').addClass('show').attr('aria-hidden', 'false');
            window.setTimeout(function () { $('#btnStatusOk').focus(); }, 50);
        }

        function hideStatusPopup() {
            $('#statusPopup').removeClass('show').attr('aria-hidden', 'true');
        }

        function showMessage(message, success) {
            var box = $('#messageBox').removeClass('success error').addClass(success ? 'success' : 'error').text(message).stop(true, true).show();
            window.setTimeout(function () { box.fadeOut(); }, 5000);
        }

        function getQueryString(name) {
            var match = new RegExp('[?&]' + name + '=([^&]*)').exec(window.location.search);
            return match ? decodeURIComponent(match[1].replace(/\+/g, ' ')) : '';
        }
 </script>
</asp:Content>
