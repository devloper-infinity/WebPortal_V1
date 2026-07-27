<%@ Page Title="" Language="C#" MasterPageFile="~/Vendor/VendorMaster.Master" AutoEventWireup="true" CodeBehind="VendorDetails.aspx.cs" Inherits="WebPortal.Vendor.VendorDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .erp-page {
            padding: 15px
        }

        .erp-tabs {
            display: flex;
            gap: 5px;
            border-bottom: 1px solid #d9e0e7;
            margin-bottom: 15px;
            flex-wrap: wrap
        }

        .erp-tab {
            border: 0;
            background: #edf2f7;
            color: #334155;
            padding: 10px 18px;
            font-weight: 600;
            border-radius: 5px 5px 0 0;
            cursor: pointer
        }

            .erp-tab.active {
                background: #2f6fa5;
                color: #fff
            }

        .erp-tab-panel {
            display: none
        }

            .erp-tab-panel.active {
                display: block
            }

        .erp-panel {
            background: #fff;
            border: 1px solid #d9e0e7;
            border-radius: 5px;
            margin-bottom: 15px;
            box-shadow: 0 1px 3px rgba(0,0,0,.05)
        }

        .erp-panel-title {
            background: #f5f8fb;
            border-bottom: 1px solid #d9e0e7;
            padding: 10px 14px;
            font-size: 15px;
            font-weight: 700;
            color: #2f4f6f
        }

        .erp-panel-body {
            padding: 15px
        }

        .erp-form-grid {
            display: grid;
            grid-template-columns: repeat(4,minmax(180px,1fr));
            gap: 14px
        }

        .erp-field.span-2 {
            grid-column: span 2
        }

        .erp-field.span-4 {
            grid-column: span 4
        }

        .erp-field label {
            display: block;
            font-weight: 600;
            margin-bottom: 5px;
            color: #374151
        }

        .erp-required {
            color: #d32f2f
        }

        .erp-control {
            width: 100%;
            height: 34px;
            border: 1px solid #cbd5e1;
            border-radius: 4px;
            padding: 6px 9px;
            box-sizing: border-box;
            background: #fff
        }

        textarea.erp-control {
            height: 75px;
            resize: vertical
        }

        .erp-actions {
            display: flex;
            gap: 8px;
            margin-top: 15px;
            flex-wrap: wrap
        }

        .erp-btn {
            border: 0;
            border-radius: 4px;
            padding: 8px 14px;
            font-weight: 600;
            cursor: pointer
        }

        .erp-btn-primary {
            background: #2f6fa5;
            color: #fff
        }

        .erp-btn-light {
            background: #e9eef3;
            color: #334155
        }

        .erp-btn-danger {
            background: #c94b4b;
            color: #fff
        }

        .erp-btn-success {
            background: #3f8f60;
            color: #fff
        }

        .erp-btn-sm {
            padding: 5px 8px;
            font-size: 12px
        }

        .erp-message {
            display: none;
            padding: 10px 14px;
            border-radius: 4px;
            margin-bottom: 12px;
            font-weight: 600
        }

            .erp-message.success {
                display: block;
                background: #e8f5ec;
                color: #267443
            }

            .erp-message.error {
                display: block;
                background: #fdecec;
                color: #b42318
            }

        .grid-wrap {
            position: relative;
            overflow: auto
        }

        .grid-loader {
            display: none;
            position: absolute;
            inset: 0;
            background: rgba(255,255,255,.72);
            z-index: 5;
            align-items: center;
            justify-content: center;
            font-weight: 700
        }

            .grid-loader.show {
                display: flex
            }

        table.dataTable thead th {
            white-space: nowrap;
            background: #eef3f7;
            color: #334155
        }

        table.dataTable tbody td {
            white-space: nowrap;
            vertical-align: middle
        }

        .action-cell {
            display: flex;
            gap: 5px;
            justify-content: center
        }

        .file-name {
            font-size: 12px;
            color: #64748b;
            margin-top: 4px
        }

        @media(max-width:1100px) {
            .erp-form-grid {
                grid-template-columns: repeat(2,minmax(180px,1fr))
            }

            .erp-field.span-4 {
                grid-column: span 2
            }
        }

        @media(max-width:650px) {
            .erp-form-grid {
                grid-template-columns: 1fr
            }

            .erp-field.span-2, .erp-field.span-4 {
                grid-column: span 1
            }
        }

        .action-col {
            white-space: nowrap;
            text-align: center;
        }

        .dt-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 30px;
            height: 30px;
            border-radius: 4px;
            text-decoration: none;
            margin: 0 2px;
            transition: .2s;
            font-size: 14px;
        }

            .dt-icon.edit {
                background: #0d6efd;
                color: #fff;
            }

                .dt-icon.edit:hover {
                    background: #0b5ed7;
                    color: #fff;
                }

            .dt-icon.delete {
                background: #dc3545;
                color: #fff;
            }

                .dt-icon.delete:hover {
                    background: #bb2d3b;
                    color: #fff;
                }

        table.dataTable {
            width: 100% !important;
            border-collapse: collapse !important;
            font-size: 13px;
        }

            table.dataTable thead th {
                background: #2f5d8a;
                color: #fff;
                font-weight: 600;
                text-align: center;
                border: 1px solid #d7d7d7;
                padding: 8px;
                white-space: nowrap;
            }

            table.dataTable tbody td {
                border: 1px solid #e3e3e3;
                padding: 6px 8px;
                vertical-align: middle;
            }

            table.dataTable tbody tr:nth-child(even) {
                background: #f8f9fb;
            }

            table.dataTable tbody tr:hover {
                background: #eef6ff;
            }

        .dataTables_wrapper .dataTables_filter input {
            border: 1px solid #ccc;
            border-radius: 4px;
            padding: 5px 8px;
        }

        .dataTables_wrapper .dataTables_length select {
            border: 1px solid #ccc;
            border-radius: 4px;
            padding: 4px 6px;
        }

        .dataTables_wrapper .dataTables_info {
            font-size: 12px;
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button {
            border-radius: 3px !important;
            padding: 4px 10px !important;
        }

            .dataTables_wrapper .dataTables_paginate .paginate_button.current {
                background: #2f5d8a !important;
                color: #fff !important;
                border: none !important;
            }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="erp-page">
        <div id="pageMessage" class="erp-message"></div>
        <div class="erp-tabs">
            <button type="button" class="erp-tab active" data-tab="vendorTab">Vendor Details</button>
            <button type="button" class="erp-tab" data-tab="userTab">User Registration</button>
            <button type="button" class="erp-tab" data-tab="costTab">Cost Information</button>
            <button type="button" class="erp-tab" data-tab="documentTab">Upload Documents</button>
        </div>

        <section id="vendorTab" class="erp-tab-panel active">
            <div class="erp-panel">
                <div class="erp-panel-title">Vendor Details</div>
                <div class="erp-panel-body">
                    <input type="hidden" id="vendorId" value="0" />
                    <div class="erp-form-grid">
                        <div class="erp-field">
                            <label>Received Date</label><input id="receivedDate" type="date" class="erp-control" />
                        </div>
                        <div class="erp-field span-2">
                            <label><span class="erp-required">*</span> Company Name</label><input id="companyName" class="erp-control" maxlength="1000" />
                        </div>
                        <div class="erp-field">
                            <label>Vendor Name</label><input id="vendorName" class="erp-control" maxlength="4000" />
                        </div>
                        <div class="erp-field">
                            <label>No. of Seats</label><input id="noOfSeat" class="erp-control" />
                        </div>
                        <div class="erp-field">
                            <label>Mobile Number</label><input id="cellNumber" class="erp-control" maxlength="20" />
                        </div>
                        <div class="erp-field">
                            <label>Landline Number</label><input id="contactNumber" class="erp-control" maxlength="20" />
                        </div>
                        <div class="erp-field span-2">
                            <label>Address</label><textarea id="address" class="erp-control"></textarea>
                        </div>
                        <div class="erp-field">
                            <label>State</label><input id="vendorState" class="erp-control" />
                        </div>
                        <div class="erp-field">
                            <label><span class="erp-required">*</span> Email Address</label><input id="emailId" type="email" class="erp-control" />
                        </div>
                        <div class="erp-field">
                            <label>Website</label><input id="website" class="erp-control" />
                        </div>
                        <div class="erp-field">
                            <label>Working With Us</label><select id="working" class="erp-control"><option value="">Select</option>
                                <option value="Yes">Yes</option>
                                <option value="No">No</option>
                            </select>
                        </div>
                        <div class="erp-field span-2">
                            <label>Attachment</label><input id="vendorAttachment" type="file" class="erp-control" />
                        </div>
                        <div class="erp-field span-2">
                            <label>Project Description</label><textarea id="projectDescription" class="erp-control"></textarea>
                        </div>
                    </div>
                    <div class="erp-actions">
                        <button type="button" id="btnSaveVendor" class="erp-btn erp-btn-primary">Submit</button>
                        <button type="button" id="btnClearVendor" class="erp-btn erp-btn-light">Clear</button>
                    </div>
                </div>
            </div>
            <div class="erp-panel">
                <div class="erp-panel-title">Vendor List</div>
                <div class="erp-panel-body">
                    <div class="erp-actions" style="margin-top: 0; margin-bottom: 10px">
                        <button type="button" id="btnVendorExcel" class="erp-btn erp-btn-success">Export To Excel</button>
                    </div>
                    <div class="grid-wrap">
                        <div id="vendorLoader" class="grid-loader">Loading...</div>
                        <table id="vendorTable" class="display nowrap" style="width: 100%">
                            <thead>
                                <tr></tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </section>

        <section id="userTab" class="erp-tab-panel">
            <div class="erp-panel">
                <div class="erp-panel-title">Vendor Login Details</div>
                <div class="erp-panel-body">
                    <input type="hidden" id="registrationId" value="0" />
                    <div class="erp-form-grid">
                        <div class="erp-field">
                            <label><span class="erp-required">*</span> Company Name</label><select id="userCompany" class="erp-control"></select>
                        </div>
                        <div class="erp-field">
                            <label><span class="erp-required">*</span> User Code</label><input id="userCode" class="erp-control" style="text-transform: uppercase" />
                        </div>
                        <div class="erp-field">
                            <label><span class="erp-required">*</span> Password</label><input id="password" type="password" class="erp-control" />
                        </div>
                        <div class="erp-field">
                            <label><span class="erp-required">*</span> Confirm Password</label><input id="confirmPassword" type="password" class="erp-control" />
                        </div>
                        <div class="erp-field">
                            <label>Active</label><label style="font-weight: normal"><input id="isActive" type="checkbox" />
                                Yes</label>
                        </div>
                    </div>
                    <div class="erp-actions">
                        <button type="button" id="btnSaveUser" class="erp-btn erp-btn-primary">Submit</button>
                        <button type="button" id="btnClearUser" class="erp-btn erp-btn-light">Clear</button>
                    </div>
                </div>
            </div>
            <div class="erp-panel">
                <div class="erp-panel-title">Registered Users</div>
                <div class="erp-panel-body">
                    <div class="grid-wrap">
                        <div id="userLoader" class="grid-loader">Loading...</div>
                        <table id="userTable" class="display nowrap" style="width: 100%">
                            <thead>
                                <tr></tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </section>

        <section id="costTab" class="erp-tab-panel">
            <div class="erp-panel">
                <div class="erp-panel-title">Cost Information Details</div>
                <div class="erp-panel-body">
                    <div class="erp-form-grid">
                        <div class="erp-field">
                            <label><span class="erp-required">*</span> Company Name</label><select id="costCompany" class="erp-control"></select>
                        </div>
                        <div class="erp-field">
                            <label><span class="erp-required">*</span> State</label><select id="costState" class="erp-control"></select>
                        </div>
                        <div class="erp-field">
                            <label><span class="erp-required">*</span> County</label><select id="county" class="erp-control"></select>
                        </div>
                        <div class="erp-field">
                            <label><span class="erp-required">*</span> Product</label><select id="product" class="erp-control"></select>
                        </div>
                        <div class="erp-field">
                            <label>Minimum TAT</label><input id="minTat" class="erp-control" />
                        </div>
                        <div class="erp-field">
                            <label>Maximum TAT</label><input id="maxTat" class="erp-control" />
                        </div>
                        <div class="erp-field">
                            <label>Product Fees</label><input id="productFees" class="erp-control" />
                        </div>
                        <div class="erp-field">
                            <label>No. of Free Copies</label><input id="freeCopies" class="erp-control" />
                        </div>
                        <div class="erp-field">
                            <label>First Page Charges</label><input id="firstPageCharges" class="erp-control" />
                        </div>
                        <div class="erp-field">
                            <label>Subsequent Page Charges</label><input id="subPageCharges" class="erp-control" />
                        </div>
                        <div class="erp-field">
                            <label>Cancellation Time</label><input id="cancellationTime" class="erp-control" />
                        </div>
                        <div class="erp-field">
                            <label>Cancellation Charges</label><input id="cancellationCharges" class="erp-control" />
                        </div>
                        <div class="erp-field span-4">
                            <label>Remark</label><textarea id="costRemark" class="erp-control"></textarea>
                        </div>
                    </div>
                    <div class="erp-actions">
                        <button type="button" id="btnSaveCost" class="erp-btn erp-btn-primary">Submit</button>
                        <button type="button" id="btnClearCost" class="erp-btn erp-btn-light">Clear</button>
                    </div>
                </div>
            </div>
            <div class="erp-panel">
                <div class="erp-panel-title">Costing List</div>
                <div class="erp-panel-body">
                    <div class="grid-wrap">
                        <div id="costLoader" class="grid-loader">Loading...</div>
                        <table id="costTable" class="display nowrap" style="width: 100%">
                            <thead>
                                <tr></tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </section>

        <section id="documentTab" class="erp-tab-panel">
            <div class="erp-panel">
                <div class="erp-panel-title">Upload Documents</div>
                <div class="erp-panel-body">
                    <div class="erp-form-grid">
                        <div class="erp-field">
                            <label><span class="erp-required">*</span> Company Name</label><select id="documentCompany" class="erp-control"></select>
                        </div>
                        <div class="erp-field">
                            <label><span class="erp-required">*</span> Document</label><select id="documentName" class="erp-control"><option value="">Select</option>
                                <option value="ApplicationForm">Application Form</option>
                                <option value="W-9Form">W-9 Form</option>
                                <option value="EandOCopy">E&amp;O Copy</option>
                                <option value="Aggrement">Agreement</option>
                                <option value="RateCard">Rate Card</option>
                            </select>
                        </div>
                        <div class="erp-field span-2">
                            <label><span class="erp-required">*</span> File</label><input id="documentFile" type="file" class="erp-control" />
                        </div>
                    </div>
                    <div class="erp-actions">
                        <button type="button" id="btnUploadDocument" class="erp-btn erp-btn-primary">Upload</button>
                        <button type="button" id="btnClearDocument" class="erp-btn erp-btn-light">Clear</button>
                    </div>
                </div>
            </div>
            <div class="erp-panel">
                <div class="erp-panel-title">Uploaded Documents</div>
                <div class="erp-panel-body">
                    <div class="grid-wrap">
                        <div id="documentLoader" class="grid-loader">Loading...</div>
                        <table id="documentTable" class="display nowrap" style="width: 100%">
                            <thead>
                                <tr></tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </section>
    </div>

    <script>
        (function () {
            'use strict';
            if (!window.jQuery) { alert('jQuery could not be loaded. Please verify the Scripts path.'); return; }
            var vendorTable, userTable, costTable, documentTable;
            var initial = null;

            $(function () {
                bindEvents();
                loadInitialData();
            });

            function bindEvents() {
                $('.erp-tab').on('click', function () { activateTab($(this).data('tab')); });
                $('#btnSaveVendor').on('click', saveVendor); $('#btnClearVendor').on('click', clearVendor);
                $('#btnSaveUser').on('click', saveUser); $('#btnClearUser').on('click', clearUser);
                $('#btnSaveCost').on('click', saveCost); $('#btnClearCost').on('click', clearCost);
                $('#btnUploadDocument').on('click', uploadDocument); $('#btnClearDocument').on('click', clearDocument);
                $('#costState').on('change', loadCounties); $('#costCompany').on('change', loadCostings); $('#documentCompany').on('change', loadDocuments);
                $('#userCode').on('change', checkUserCode);
                $('#btnVendorExcel').on('click', function () { exportTableToExcel('vendorTable', 'Vendor Details'); });
            }

            function activateTab(id) { $('.erp-tab').removeClass('active'); $('.erp-tab[data-tab="' + id + '"]').addClass('active'); $('.erp-tab-panel').removeClass('active'); $('#' + id).addClass('active'); setTimeout(function () { $.fn.dataTable.tables({ visible: true, api: true }).columns.adjust(); }, 100); }
            function ajax(method, data, ok) { $.ajax({ type: 'POST', url: 'VendorDetails.aspx/' + method, data: JSON.stringify(data || {}), contentType: 'application/json; charset=utf-8', dataType: 'json', success: function (r) { var x = r.d; if (x && x.Success === false) { showMessage(x.Message || 'Operation failed.', false); return; } ok(x); }, error: function (x) { showMessage((x.responseJSON && x.responseJSON.Message) || 'Unexpected server error.', false); } }); }
            function showMessage(text, success) { var m = $('#pageMessage').removeClass('success error').addClass(success ? 'success' : 'error').text(text || ''); $('html,body').animate({ scrollTop: 0 }, 200); setTimeout(function () { m.fadeOut(300, function () { m.removeClass('success error').show().hide(); }); }, 5000); }
            function showLoader(id, show) { $('#' + id).toggleClass('show', show); }
            function v(row, names) { for (var i = 0; i < names.length; i++) { if (row[names[i]] !== undefined && row[names[i]] !== null) return row[names[i]]; } return ''; }
            function esc(x) { return $('<div/>').text(x == null ? '' : x).html(); }
            function fillSelect(selector, rows, valueKeys, textKeys) { var s = $(selector).empty().append('<option value="">Select</option>'); $.each(rows || [], function (_, r) { s.append($('<option/>').val(v(r, valueKeys)).text(v(r, textKeys))); }); }

            function loadInitialData() { showLoader('vendorLoader', true); ajax('GetInitialData', {}, function (r) { initial = r; fillSelect('#userCompany', r.Companies, ['AbstractorID', 'ApplicationID'], ['AbstractorCode', 'CompanyName']); fillSelect('#costCompany', r.Companies, ['AbstractorID', 'ApplicationID'], ['AbstractorCode', 'CompanyName']); fillSelect('#documentCompany', r.Companies, ['AbstractorID', 'ApplicationID'], ['AbstractorCode', 'CompanyName']); fillSelect('#costState', r.States, ['StateCode'], ['StateCode']); fillSelect('#product', r.Products, ['ProductID'], ['ProductType']); bindVendorTable(r.Vendors || []); bindUserTable(r.Users || []); if (r.SelectedVendor) bindVendorForm(r.SelectedVendor); if (r.SelectedUser) { bindUserForm(r.SelectedUser); activateTab('userTab'); } showLoader('vendorLoader', false); }); }

            function bindVendorTable(rows) {
                if (vendorTable) vendorTable.destroy();
                var cols = ['Action', 'Sr. #', 'Company Name', 'Vendor Name', 'No. of Seats', 'Cell Number', 'Contact Number', 'Address', 'State', 'Email', 'Website', 'Attachment', 'Working', 'Project Description', 'Received Date'];
                var h = $('#vendorTable thead tr').empty();
                $.each(cols, function (_, c) {
                    h.append('<th>' + c + '</th>');
                });
                var b = $('#vendorTable tbody').empty();
                $.each(rows, function (i, r) {
                    var id = v(r, ['ApplicationID', 'AbstractorID']);
                    b.append('<tr><td class="action-col"><a href = "javascript:void(0)" class= "dt-icon edit" onclick = "editVendor(1)" title = "Edit"><i class="fa fa-edit"></i></a><a href="javascript:void(0)" class="dt-icon delete" onclick="deleteVendor(1)" title="Delete"><i class="fa fa-trash"></i></a></td ><td>' + (i + 1) + '</td><td>' + esc(v(r, ['CompanyName'])) + '</td><td>' + esc(v(r, ['VendorName'])) + '</td><td>' + esc(v(r, ['NoofSeat'])) + '</td><td>' + esc(v(r, ['CellNumber'])) + '</td><td>' + esc(v(r, ['ContactNumber', 'ContactNumber1'])) + '</td><td>' + esc(v(r, ['Address'])) + '</td><td>' + esc(v(r, ['State'])) + '</td><td>' + esc(v(r, ['EmailId'])) + '</td><td>' + esc(v(r, ['WebSite'])) + '</td><td>' + esc(v(r, ['Attachement', 'Attachment'])) + '</td><td>' + esc(v(r, ['Working'])) + '</td><td>' + esc(v(r, ['ProjectDescription'])) + '</td><td>' + esc(v(r, ['ReceivedDate'])) + '</td></tr>');
                });
                vendorTable = $('#vendorTable').DataTable({ paging: false, scrollX: true, scrollY: '55vh', scrollCollapse: true, fixedHeader: true, order: [] }); $('.edit-vendor').on('click', function () { window.location = 'VendorDetails.aspx?AbstractorID=' + encodeURIComponent($(this).data('id')); }); $('.delete-vendor').on('click', function () { deleteVendor($(this).data('id')); });
            }
            function bindUserTable(rows) { if (userTable) userTable.destroy(); var keys = getColumns(rows, ['Password', 'ConfirmPassword']); var h = $('#userTable thead tr').empty().append('<th>Action</th><th>Sr. #</th>'); $.each(keys, function (_, k) { h.append('<th>' + esc(k) + '</th>'); }); var b = $('#userTable tbody').empty(); $.each(rows, function (i, r) { var id = v(r, ['RId']); var tr = '<tr><td><button class="erp-btn erp-btn-light erp-btn-sm edit-user" data-id="' + esc(id) + '">Edit</button></td><td>' + (i + 1) + '</td>'; $.each(keys, function (_, k) { tr += '<td>' + esc(r[k]) + '</td>'; }); b.append(tr + '</tr>'); }); userTable = $('#userTable').DataTable({ paging: false, scrollX: true, scrollY: '55vh', scrollCollapse: true, order: [] }); $('.edit-user').on('click', function () { window.location = 'VendorDetails.aspx?RegId=' + encodeURIComponent($(this).data('id')); }); }
            function bindCostTable(rows) { if (costTable) costTable.destroy(); bindDynamic('#costTable', rows, function (t) { costTable = t; }); }
            function bindDocumentTable(rows) { if (documentTable) documentTable.destroy(); var keys = getColumns(rows, ['Path', 'Resume1']); var h = $('#documentTable thead tr').empty().append('<th>Document</th><th>Sr. #</th>'); $.each(keys, function (_, k) { h.append('<th>' + esc(k) + '</th>'); }); var b = $('#documentTable tbody').empty(); $.each(rows, function (i, r) { var path = v(r, ['Path', 'Resume1', 'DocumentPath']); var tr = '<tr><td><button class="erp-btn erp-btn-primary erp-btn-sm download-doc" data-path="' + esc(path) + '">Download</button></td><td>' + (i + 1) + '</td>'; $.each(keys, function (_, k) { tr += '<td>' + esc(r[k]) + '</td>'; }); b.append(tr + '</tr>'); }); documentTable = $('#documentTable').DataTable({ paging: false, scrollX: true, scrollY: '55vh', scrollCollapse: true, order: [] }); $('.download-doc').on('click', function () { downloadFile($(this).data('path')); }); }
            function bindDynamic(selector, rows, setter) { var keys = getColumns(rows, []); var h = $(selector + ' thead tr').empty().append('<th>Sr. #</th>'); $.each(keys, function (_, k) { h.append('<th>' + esc(k) + '</th>'); }); var b = $(selector + ' tbody').empty(); $.each(rows || [], function (i, r) { var tr = '<tr><td>' + (i + 1) + '</td>'; $.each(keys, function (_, k) { tr += '<td>' + esc(r[k]) + '</td>'; }); b.append(tr + '</tr>'); }); setter($(selector).DataTable({ paging: false, scrollX: true, scrollY: '55vh', scrollCollapse: true, order: [] })); }
            function getColumns(rows, exclude) { var a = []; $.each(rows || [], function (_, r) { $.each(r, function (k) { if ($.inArray(k, exclude) < 0 && $.inArray(k, a) < 0) a.push(k); }); }); return a; }

            function saveVendor() { var company = $.trim($('#companyName').val()), email = $.trim($('#emailId').val()); if (!company) { showMessage('Please enter Company Name.', false); return; } if (!email) { showMessage('Please enter Email Address.', false); return; } readFile($('#vendorAttachment')[0].files[0], function (file) { var input = { CompanyName: company, VendorName: $('#vendorName').val(), NoofSeat: $('#noOfSeat').val(), CellNumber: $('#cellNumber').val(), ContactNumber1: $('#contactNumber').val(), Address: $('#address').val(), State: $('#vendorState').val(), EmailId: email, WebSite: $('#website').val(), Working: $('#working').val(), ReceivedDate: $('#receivedDate').val(), ProjectDescription: $('#projectDescription').val(), FileName: file.name, FileBase64: file.data }; ajax('SaveVendor', { input: input }, function (r) { showMessage(r.Message || 'Vendor details saved successfully.', true); clearVendor(); loadInitialData(); }); }); }
            function deleteVendor(id) { if (!confirm('Are you sure you want to delete this vendor?')) return; ajax('DeleteVendor', { applicationId: parseInt(id, 10) }, function (r) { showMessage(r.Message || 'Vendor deleted successfully.', true); loadInitialData(); }); }
            function bindVendorForm(r) { $('#vendorId').val(v(r, ['ApplicationID', 'AbstractorID'])); $('#companyName').val(v(r, ['CompanyName'])); $('#vendorName').val(v(r, ['VendorName'])); $('#noOfSeat').val(v(r, ['NoofSeat'])); $('#cellNumber').val(v(r, ['CellNumber'])); $('#contactNumber').val(v(r, ['ContactNumber', 'ContactNumber1'])); $('#address').val(v(r, ['Address'])); $('#vendorState').val(v(r, ['State'])); $('#emailId').val(v(r, ['EmailId'])); $('#website').val(v(r, ['WebSite'])); $('#working').val(v(r, ['Working'])); $('#projectDescription').val(v(r, ['ProjectDescription'])); }
            function clearVendor() { $('#vendorTab input:not([type=file]),#vendorTab textarea').val(''); $('#vendorTab select').val(''); $('#vendorAttachment').val(''); $('#vendorId').val('0'); }

            function checkUserCode() { var code = $.trim($('#userCode').val()); if (!code) return; ajax('CheckUserExist', { code: code }, function (r) { if (r.Exists) { showMessage('User already exists. Please create another user code.', false); $('#password,#confirmPassword').val('').prop('readonly', true); } else { $('#password,#confirmPassword').prop('readonly', false); } }); }
            function saveUser() { var input = { AbstractorID: parseInt($('#userCompany').val() || 0, 10), UserCode: $.trim($('#userCode').val()).toUpperCase(), Password: $('#password').val(), ConfirmPassword: $('#confirmPassword').val(), Activate: $('#isActive').is(':checked') }; if (!input.AbstractorID || !input.UserCode || !input.Password) { showMessage('Please complete all required user fields.', false); return; } if (input.Password !== input.ConfirmPassword) { showMessage('Password and Confirm Password do not match.', false); return; } ajax('SaveUser', { input: input }, function (r) { showMessage(r.Message || 'User registration saved successfully.', true); clearUser(); loadInitialData(); }); }
            function bindUserForm(r) { $('#registrationId').val(v(r, ['RId'])); $('#userCode').val(v(r, ['UserCode'])); $('#password').val(v(r, ['Password'])); $('#confirmPassword').val(v(r, ['ConfirmPassword'])); $('#isActive').prop('checked', String(v(r, ['Activate'])).toLowerCase() === 'true'); $('#userCompany').val(v(r, ['AbstractorID'])); }
            function clearUser() { $('#registrationId').val('0'); $('#userCompany').val(''); $('#userCode,#password,#confirmPassword').val('').prop('readonly', false); $('#isActive').prop('checked', false); }

            function loadCounties() { var state = $('#costState').val(); if (!state) { fillSelect('#county', [], ['CountyID'], ['County']); return; } ajax('GetCounties', { stateCode: state }, function (r) { fillSelect('#county', r.Rows || [], ['CountyID'], ['County']); }); }
            function saveCost() { var input = { AbstractorID: parseInt($('#costCompany').val() || 0, 10), CountyId: parseInt($('#county').val() || 0, 10), ProductId: parseInt($('#product').val() || 0, 10), MinTAT: $('#minTat').val(), MaxTAT: $('#maxTat').val(), ProductFees: $('#productFees').val(), NofFreeCopies: $('#freeCopies').val(), FirstPageCharges: $('#firstPageCharges').val(), SubPageCharges: $('#subPageCharges').val(), CancellationTime: $('#cancellationTime').val(), CancellationCharges: $('#cancellationCharges').val(), Remark: $('#costRemark').val() }; if (!input.AbstractorID || !input.CountyId || !input.ProductId) { showMessage('Please select Company, County and Product.', false); return; } ajax('SaveCosting', { input: input }, function (r) { showMessage(r.Message || 'Costing added successfully.', true); clearCost(); loadCostings(); }); }
            function loadCostings() { var id = parseInt($('#costCompany').val() || 0, 10); if (!id) { bindCostTable([]); return; } showLoader('costLoader', true); ajax('GetCostings', { abstractorId: id }, function (r) { bindCostTable(r.Rows || []); showLoader('costLoader', false); }); }
            function clearCost() { $('#costTab input,#costTab textarea').val(''); $('#costTab select').val(''); bindCostTable([]); }

            function uploadDocument() { var file = $('#documentFile')[0].files[0]; var input = { AbstractorID: parseInt($('#documentCompany').val() || 0, 10), DocumentName: $('#documentName').val() }; if (!input.AbstractorID || !input.DocumentName || !file) { showMessage('Please select Company, Document and File.', false); return; } readFile(file, function (f) { input.FileName = f.name; input.FileBase64 = f.data; ajax('UploadDocument', { input: input }, function (r) { showMessage(r.Message || 'Document uploaded successfully.', true); $('#documentName,#documentFile').val(''); loadDocuments(); }); }); }
            function loadDocuments() { var id = parseInt($('#documentCompany').val() || 0, 10); if (!id) { bindDocumentTable([]); return; } showLoader('documentLoader', true); ajax('GetDocuments', { abstractorId: id }, function (r) { bindDocumentTable(r.Rows || []); showLoader('documentLoader', false); }); }
            function clearDocument() { $('#documentCompany,#documentName,#documentFile').val(''); bindDocumentTable([]); }

            function readFile(file, done) { if (!file) { done({ name: '', data: '' }); return; } var reader = new FileReader(); reader.onload = function (e) { done({ name: file.name, data: String(e.target.result).split(',')[1] || '' }); }; reader.onerror = function () { showMessage('Unable to read selected file.', false); }; reader.readAsDataURL(file); }
            function downloadFile(path) { if (!path) { showMessage('Document path is not available.', false); return; } ajax('DownloadFile', { path: path }, function (r) { var a = document.createElement('a'); a.href = 'data:' + (r.ContentType || 'application/octet-stream') + ';base64,' + r.FileBase64; a.download = r.FileName || 'document'; document.body.appendChild(a); a.click(); document.body.removeChild(a); }); }
            function exportTableToExcel(tableId, fileName) { var table = document.getElementById(tableId); var html = '<html><head><meta charset="utf-8"></head><body>' + table.outerHTML + '</body></html>'; var blob = new Blob([html], { type: 'application/vnd.ms-excel' }); var a = document.createElement('a'); a.href = URL.createObjectURL(blob); a.download = fileName + '.xls'; a.click(); URL.revokeObjectURL(a.href); }
        })();
</script>
</asp:Content>
