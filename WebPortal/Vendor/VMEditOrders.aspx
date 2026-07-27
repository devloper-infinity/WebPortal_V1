<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VMEditOrders.aspx.cs" Inherits="WebPortal.Vendor.VMEditOrders" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
     <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
 <link rel="stylesheet" href="https://unicons.iconscout.com/release/v4.0.8/css/line.css">

 <!-- added for New dashboard  -->
 <link href="https://unicons.iconscout.com/release/v4.0.0/css/line.css" rel="stylesheet">

 <!-- Font Awesome Icons -->
 <script src="../plugins/jquery/jquery.min.js"></script>
 <link rel="stylesheet" href="../plugins/fontawesome-free/css/all.min.css">
 <link rel="stylesheet" href="../plugins/datatables-bs4/css/dataTables.bootstrap4.min.css">
 <link rel="stylesheet" href="../plugins/datatables-responsive/css/responsive.bootstrap4.min.css">
 <link rel="stylesheet" href="../plugins/datatables-buttons/css/buttons.bootstrap4.min.css">
 <!-- Theme style -->
 <link rel="stylesheet" href="../dist/css/adminlte.min.css">
    <title></title>
    <style>
        * {
            box-sizing: border-box;
        }

        html, body {
            margin: 0;
            padding: 0;
            background: #f4f6f9;
            color: #344054;
            font-family: Arial, Helvetica, sans-serif;
            font-size: 13px;
        }

        body {
            padding: 14px;
        }

        .erp-page {
            width: 100%;
            max-width: 1050px;
            margin: 0 auto;
        }

        .erp-hero {
            background: #fff;
            border: 1px solid #dfe5ec;
            border-left: 4px solid #3768a8;
            border-radius: 5px;
            padding: 13px 17px;
            margin-bottom: 12px;
            box-shadow: 0 1px 4px rgba(16,24,40,.06);
        }

            .erp-hero h1 {
                margin: 0;
                color: #294f7d;
                font-size: 20px;
                font-weight: 600;
            }

        .erp-breadcrumb {
            margin-top: 4px;
            color: #7a8695;
            font-size: 12px;
        }

        .erp-panel {
            background: #fff;
            border: 1px solid #dfe5ec;
            border-radius: 5px;
            padding: 16px;
            box-shadow: 0 1px 4px rgba(16,24,40,.06);
        }

        .erp-section-title {
            margin: 0 0 13px;
            padding-bottom: 9px;
            border-bottom: 1px solid #eaedf1;
            color: #294f7d;
            font-size: 15px;
            font-weight: 600;
        }

        .erp-message {
            display: none;
            margin-bottom: 12px;
            padding: 10px 12px;
            border-radius: 4px;
            font-weight: 600;
            text-align: center;
        }

            .erp-message.success {
                display: block;
                background: #eaf7ee;
                border: 1px solid #b9dfc5;
                color: #23713a;
            }

            .erp-message.error {
                display: block;
                background: #fff0f0;
                border: 1px solid #efc2c2;
                color: #b42318;
            }

        .erp-tabs {
            display: flex;
            gap: 2px;
            border-bottom: 1px solid #d7dde5;
            margin-bottom: 16px;
        }

        .erp-tab {
            border: 0;
            background: transparent;
            color: #667085;
            padding: 10px 16px;
            font-weight: 600;
            cursor: pointer;
            border-bottom: 3px solid transparent;
        }

            .erp-tab.active {
                color: #294f7d;
                border-bottom-color: #3768a8;
            }

        .tab-content {
            display: none;
        }

            .tab-content.active {
                display: block;
            }

        .table-wrap {
            position: relative;
            width: 100%;
            overflow: auto;
            margin-bottom: 18px;
            border: 1px solid #e2e7ed;
            border-radius: 4px;
        }

        table.dataTable {
            width: 100% !important;
            margin: 0 !important;
            border-collapse: collapse !important;
        }

            table.dataTable thead th {
                background: #eef3f8;
                color: #294f7d;
                border-bottom: 1px solid #cfd8e3 !important;
                padding: 9px 10px !important;
                white-space: nowrap;
                font-size: 12px;
            }

            table.dataTable tbody td {
                padding: 9px 10px !important;
                border-bottom: 1px solid #edf0f3;
                white-space: nowrap;
            }

            table.dataTable tbody tr:hover {
                background: #f8fafc;
            }

        .dataTables_wrapper .dataTables_filter {
            margin: 8px 10px;
        }

            .dataTables_wrapper .dataTables_filter input {
                border: 1px solid #cfd6df;
                border-radius: 4px;
                padding: 6px 8px;
                outline: none;
            }

        .dataTables_wrapper .dataTables_info {
            padding: 10px;
            color: #667085;
        }

        .dataTables_empty {
            text-align: center !important;
            padding: 18px !important;
        }

        .erp-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 14px 18px;
        }

        .erp-field {
            min-width: 0;
        }

            .erp-field.full {
                grid-column: 1 / -1;
            }

            .erp-field label {
                display: block;
                margin-bottom: 5px;
                color: #3d4852;
                font-weight: 600;
            }

        .required {
            color: #d92d20;
        }

        .form-control {
            width: 100%;
            min-height: 35px;
            padding: 7px 10px;
            border: 1px solid #cfd6df;
            border-radius: 4px;
            background: #fff;
            color: #344054;
            font-size: 13px;
            outline: none;
        }

            .form-control:focus {
                border-color: #6f9bc7;
                box-shadow: 0 0 0 2px rgba(55,104,168,.12);
            }

            .form-control[readonly] {
                background: #f3f5f7;
                color: #59636e;
            }

        textarea.form-control {
            min-height: 88px;
            resize: vertical;
        }

        input[type=file].form-control {
            padding: 5px 8px;
        }

        .field-help {
            display: block;
            margin-top: 5px;
            color: #667085;
            font-size: 11px;
        }

        .file-row {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .file-name {
            color: #475467;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .erp-actions {
            display: flex;
            justify-content: flex-end;
            gap: 8px;
            margin-top: 18px;
            padding-top: 14px;
            border-top: 1px solid #eaedf1;
        }

        .erp-btn {
            min-width: 115px;
            border: 1px solid transparent;
            border-radius: 4px;
            padding: 8px 14px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
        }

        .erp-btn-primary {
            background: #3768a8;
            border-color: #3768a8;
            color: #fff;
        }

            .erp-btn-primary:hover {
                background: #2f598f;
            }

        .erp-btn-light {
            background: #fff;
            border-color: #b8c2cc;
            color: #475467;
        }

        .erp-btn-danger {
            background: #fff;
            border-color: #d92d20;
            color: #b42318;
        }

        .erp-btn:disabled {
            opacity: .65;
            cursor: not-allowed;
        }

        .loading-mask {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 99999;
            background: rgba(255,255,255,.75);
            align-items: center;
            justify-content: center;
        }

        .loading-box {
            min-width: 180px;
            padding: 16px 20px;
            border: 1px solid #d7dde5;
            border-radius: 5px;
            background: #fff;
            text-align: center;
            box-shadow: 0 5px 22px rgba(0,0,0,.14);
        }

        .spinner {
            width: 30px;
            height: 30px;
            margin: 0 auto 9px;
            border: 3px solid #dce5ef;
            border-top-color: #3768a8;
            border-radius: 50%;
            animation: spin .8s linear infinite;
        }

        @keyframes spin {
            to {
                transform: rotate(360deg);
            }
        }

        @media (max-width: 760px) {
            body {
                padding: 8px;
            }

            .erp-grid {
                grid-template-columns: 1fr;
            }

            .erp-field.full {
                grid-column: auto;
            }

            .erp-actions {
                flex-direction: column;
            }

            .erp-btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="erp-page">
        <div class="erp-hero">
            <h1>Manage Vendor Order</h1>
            <div class="erp-breadcrumb">Vendor Tracking / Order Processing</div>
        </div>

        <div id="messageBox" class="erp-message"></div>

        <div class="erp-panel">
            <div class="erp-tabs">
                <button type="button" class="erp-tab active" data-tab="processTab">Process Order</button>
                <button type="button" class="erp-tab" data-tab="statusTab">Change Order Status</button>
            </div>

            <div id="processTab" class="tab-content active">
                <h2 class="erp-section-title">Order Summary</h2>
                <div class="table-wrap">
                    <table id="orderTable" class="display nowrap">
                        <thead>
                            <tr>
                                <th>Project #</th>
                                <th>Client Order #</th>
                                <th>Order Date</th>
                                <th>Process</th>
                                <th>VM</th>
                                <th>Vendor</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>

                <h2 class="erp-section-title">Complete Order</h2>
                <div class="erp-grid">
                    <div class="erp-field full">
                        <label>Input File</label>
                        <div class="file-row">
                            <button type="button" id="btnDownloadInput" class="erp-btn erp-btn-light">Download Input File</button>
                            <span id="inputFileName" class="file-name">No input file available</span>
                        </div>
                    </div>
                    <div class="erp-field full">
                        <label for="completedFile">Completed File <span class="required">*</span></label>
                        <input type="file" id="completedFile" class="form-control" />
                        <span class="field-help">The selected filename must contain the client order number.</span>
                    </div>
                    <div class="erp-field full">
                        <label for="completionRemark">Remark</label>
                        <textarea id="completionRemark" class="form-control" maxlength="4000"></textarea>
                    </div>
                </div>
                <div class="erp-actions">
                    <button type="button" class="erp-btn erp-btn-light btn-close">Close</button>
                    <button type="button" id="btnCompleteOrder" class="erp-btn erp-btn-primary">Complete Order</button>
                </div>
            </div>

            <div id="statusTab" class="tab-content">
                <h2 class="erp-section-title">Current Allocation</h2>
                <div class="erp-grid">
                    <div class="erp-field">
                        <label>Project #</label><input id="cosProject" class="form-control" readonly /></div>
                    <div class="erp-field">
                        <label>Client Order #</label><input id="cosOrderNo" class="form-control" readonly /></div>
                    <div class="erp-field">
                        <label>Order Date</label><input id="cosOrderDate" class="form-control" readonly /></div>
                    <div class="erp-field">
                        <label>Process</label><input id="cosProcess" class="form-control" readonly /></div>
                    <div class="erp-field">
                        <label>VM</label><input id="cosVM" class="form-control" readonly /></div>
                    <div class="erp-field">
                        <label>Current Vendor</label><input id="cosVendor" class="form-control" readonly /></div>
                    <div class="erp-field">
                        <label for="newVendor">New Vendor <span class="required">*</span></label>
                        <select id="newVendor" class="form-control">
                            <option value="">Select</option>
                        </select>
                    </div>
                    <div class="erp-field full">
                        <label for="statusRemark">Remark</label>
                        <textarea id="statusRemark" class="form-control" maxlength="4000"></textarea>
                    </div>
                </div>
                <div class="erp-actions">
                    <button type="button" class="erp-btn erp-btn-light btn-close">Close</button>
                    <button type="button" id="btnChangeStatus" class="erp-btn erp-btn-primary">Update Status</button>
                </div>
            </div>
        </div>
    </div>

    <div id="loadingMask" class="loading-mask">
        <div class="loading-box">
            <div class="spinner"></div>
            <div id="loadingText">Processing...</div>
        </div>
    </div>

    <script>
        var pageState = { orderId: '', order: null, orderTable: null };

        $(document).ready(function () {
            pageState.orderId = getQueryString('OrderId') || getQueryString('OrderID');
            console.log(getQueryString('OrderId'));
            console.log(getQueryString('OrderID'));
            initializeTable();
            bindEvents();
            if (!pageState.orderId) { showMessage('Order ID is missing.', false); return; }
            loadPageData();
        });

        function initializeTable() {
            pageState.orderTable = $('#orderTable').DataTable({
                paging: false, searching: false, ordering: false, info: false,
                scrollX: true, autoWidth: false,
                language: { emptyTable: 'No order details available.' }
            });
        }

        function bindEvents() {
            $('.erp-tab').on('click', function () {
                $('.erp-tab').removeClass('active');
                $('.tab-content').removeClass('active');
                $(this).addClass('active');
                $('#' + $(this).data('tab')).addClass('active');
                if (pageState.orderTable) pageState.orderTable.columns.adjust();
            });
            $('#btnCompleteOrder').on('click', completeOrder);
            $('#btnChangeStatus').on('click', changeStatus);
            $('#btnDownloadInput').on('click', downloadInputFile);
            $('.btn-close').on('click', closePopup);
        }

        function loadPageData() {
            showLoader('Loading order details...');
            $.when(
                ajaxCall('GetOrderDetails', { orderId: pageState.orderId }),
                ajaxCall('GetVendors', {})
            ).done(function (orderResponse, vendorResponse) {
                pageState.order = unwrap(orderResponse[0]);
                var vendors = unwrap(vendorResponse[0]) || [];
                bindOrder(pageState.order);
                bindVendors(vendors);
            }).fail(handleAjaxError).always(hideLoader);
        }

        function bindOrder(order) {
            if (!order) { showMessage('Order details were not found.', false); return; }
            pageState.orderTable.clear().row.add([
                safe(order.ProjectNumber), safe(order.OrderNo), safe(order.OrderDate),
                safe(order.Process), safe(order.VM), safe(order.Vendor)
            ]).draw(false);

            $('#cosProject').val(safe(order.ProjectNumber));
            $('#cosOrderNo').val(safe(order.OrderNo));
            $('#cosOrderDate').val(safe(order.OrderDate));
            $('#cosProcess').val(safe(order.Process));
            $('#cosVM').val(safe(order.VM));
            $('#cosVendor').val(safe(order.Vendor));

            $('#inputFileName').text(order.InputFileName || 'No input file available');
            $('#btnDownloadInput').prop('disabled', !order.HasInputFile);
        }

        function bindVendors(rows) {
            var ddl = $('#newVendor').empty().append($('<option/>').val('').text('Select'));
            $.each(rows, function (_, row) {
                ddl.append($('<option/>').val(row.EmployeeID).text(row.FullName));
            });
            ddl.append($('<option/>').val('0').text('Cancel'));
        }

        function completeOrder() {
            var fileInput = document.getElementById('completedFile');
            if (!pageState.order) return showMessage('Order details are not loaded.', false);
            if (!fileInput.files.length) return showMessage('Please select the completed file.', false);

            var file = fileInput.files[0];
            if (file.name.toLowerCase().indexOf(String(pageState.order.OrderNo).toLowerCase()) < 0)
                return showMessage('Order number and attachment filename must match.', false);

            var reader = new FileReader();
            reader.onload = function (e) {
                var base64 = String(e.target.result).split(',')[1];
                var request = {
                    OrderId: pageState.orderId,
                    OrderNo: pageState.order.OrderNo,
                    ProjectNumber: pageState.order.ProjectNumber,
                    OrderDate: pageState.order.OrderDate,
                    Process: pageState.order.Process,
                    VendorName: pageState.order.Vendor,
                    Remark: $.trim($('#completionRemark').val()),
                    FileName: file.name,
                    FileBase64: base64
                };
                submitAction('CompleteOrder', { request: request }, '#btnCompleteOrder', 'Completing order...');
            };
            reader.onerror = function () { showMessage('Unable to read the selected file.', false); };
            reader.readAsDataURL(file);
        }

        function changeStatus() {
            if (!pageState.order) return showMessage('Order details are not loaded.', false);
            var vendorId = $('#newVendor').val();
            if (vendorId === '') return showMessage('Please select the new vendor.', false);

            var request = {
                ProjectNumber: pageState.order.ProjectNumber,
                OrderNumber: pageState.order.OrderNo,
                OrderDate: pageState.order.OrderDate,
                Process: pageState.order.Process,
                VM: pageState.order.VM,
                CurrentVendor: pageState.order.Vendor,
                NewVendorId: vendorId,
                NewVendorName: $('#newVendor option:selected').text(),
                Remark: $.trim($('#statusRemark').val())
            };
            submitAction('ChangeOrderStatus', { request: request }, '#btnChangeStatus', 'Updating status...');
        }

        function downloadInputFile() {
            if (!pageState.order || !pageState.order.HasInputFile) return;
            showLoader('Preparing input file...');
            ajaxCall('GetInputFile', { orderId: pageState.orderId }).done(function (response) {
                var result = unwrap(response);
                if (!result || !result.Success) return showMessage(result ? result.Message : 'File not available.', false);
                var binary = atob(result.FileBase64), bytes = new Uint8Array(binary.length);
                for (var i = 0; i < binary.length; i++) bytes[i] = binary.charCodeAt(i);
                var blob = new Blob([bytes], { type: result.ContentType || 'application/octet-stream' });
                var url = window.URL.createObjectURL(blob);
                var a = document.createElement('a'); a.href = url; a.download = result.FileName; document.body.appendChild(a); a.click();
                document.body.removeChild(a); window.URL.revokeObjectURL(url);
            }).fail(handleAjaxError).always(hideLoader);
        }

        function submitAction(method, data, buttonSelector, loadingText) {
            var button = $(buttonSelector).prop('disabled', true);
            showLoader(loadingText);
            ajaxCall(method, data).done(function (response) {
                var result = unwrap(response);
                showMessage(result.Message, result.Success);
                if (result.Success) setTimeout(closePopup, 700);
            }).fail(handleAjaxError).always(function () { button.prop('disabled', false); hideLoader(); });
        }

        function ajaxCall(method, data) {
            return $.ajax({
                type: 'POST', url: 'VMEditOrders.aspx/' + method,
                data: JSON.stringify(data), contentType: 'application/json; charset=utf-8', dataType: 'json'
            });
        }
        function unwrap(response) { return response && response.d !== undefined ? response.d : response; }
        function handleAjaxError(xhr) {
            var message = 'Unable to process the request.';
            try { message = JSON.parse(xhr.responseText).Message || message; } catch (e) { }
            showMessage(message, false);
        }
        function showMessage(message, success) {
            $('#messageBox').removeClass('success error').addClass(success ? 'success' : 'error').text(message || '').show();
            window.setTimeout(function () { $('#messageBox').fadeOut(); }, 6000);
        }
        function showLoader(text) { $('#loadingText').text(text || 'Processing...'); $('#loadingMask').css('display', 'flex'); }
        function hideLoader() { $('#loadingMask').hide(); }
        function safe(value) { return value === null || value === undefined ? '' : value; }
        function getQueryString(name) { return new URLSearchParams(window.location.search).get(name); }
        function closePopup() {
            try {
                var popup = window.parent && window.parent.window ? window.parent.window['clientpopupEditOrder'] : null;
                if (popup && typeof popup.Hide === 'function') popup.Hide(); else window.close();
            } catch (e) { window.close(); }
        }
    </script>
      <script src="../plugins/datatables/jquery.dataTables.min.js"></script>
  <link rel="stylesheet" href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css" />
  <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>

  <!-- PivotTable.js -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/pivottable/2.23.0/pivot.min.css" />
  <script src="https://cdnjs.cloudflare.com/ajax/libs/pivottable/2.23.0/pivot.min.js"></script>
  <script src="../plugins/datatables-bs4/js/dataTables.bootstrap4.min.js"></script>
  <script src="../plugins/datatables-responsive/js/dataTables.responsive.min.js"></script>
  <script src="../plugins/datatables-responsive/js/responsive.bootstrap4.min.js"></script>
  <script src="../plugins/datatables-buttons/js/dataTables.buttons.min.js"></script>
  <script src="../plugins/datatables-buttons/js/buttons.bootstrap4.min.js"></script>
  <script src="../plugins/jszip/jszip.min.js"></script>
  <script src="../plugins/pdfmake/pdfmake.min.js"></script>
  <script src="../plugins/pdfmake/vfs_fonts.js"></script>
  <script src="../plugins/datatables-buttons/js/buttons.html5.min.js"></script>
  <script src="../plugins/datatables-buttons/js/buttons.print.min.js"></script>
  <script src="../plugins/datatables-buttons/js/buttons.colVis.min.js"></script>
  <!-- AdminLTE App -->
  <script src="../plugins/bootstrap/js/bootstrap.bundle.min.js"></script>

  <script src="../dist/js/adminlte.min.js"></script>
</body>
</html>
