<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="CutOffTimeExceptions.aspx.cs" Inherits="WebPortal.Admin.CutOffTimeExceptions" %>



<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/css/select2.min.css" rel="stylesheet" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/js/select2.min.js"></script>

    <style>
        :root {
            --cotexp-primary: #2563eb;
            --cotexp-primary-dark: #1d4ed8;
            --cotexp-bg: #f5f7fb;
            --cotexp-card: #ffffff;
            --cotexp-text: #111827;
            --cotexp-muted: #6b7280;
            --cotexp-border: #e5e7eb;
            --cotexp-soft: #eff6ff;
            --cotexp-shadow: 0 18px 45px rgba(15, 23, 42, .08);
            --cotexp-radius: 18px;
        }

        .cotexp-page {
            background: var(--cotexp-bg);
        }

        .cotexp-shell {
            max-width: 100%;
            margin: 0 auto;
        }

        .cotexp-hero {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 18px;
            padding: 18px 20px;
            margin-bottom: 18px;
            border-radius: var(--cotexp-radius);
            background: linear-gradient(135deg, #1d4ed8 0%, #2563eb 45%, #60a5fa 100%);
            color: #fff;
            box-shadow: var(--cotexp-shadow);
        }

        .cotexp-title {
            margin: 0;
            font-size: 20px;
            font-weight: 800;
            letter-spacing: -.02em;
        }

        .cotexp-subtitle {
            margin: 6px 0 0;
            color: rgba(255,255,255,.85);
            font-size: 13px;
        }

        .cotexp-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 12px;
            border-radius: 999px;
            background: rgba(255,255,255,.16);
            border: 1px solid rgba(255,255,255,.22);
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
        }

        .cotexp-card {
            background: var(--cotexp-card);
            border: 1px solid var(--cotexp-border);
            border-radius: var(--cotexp-radius);
            box-shadow: var(--cotexp-shadow);
            overflow: hidden;
            margin-bottom: 18px;
        }

        .cotexp-card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 14px;
            padding: 18px 22px;
            border-bottom: 1px solid var(--cotexp-border);
            background: #fff;
        }

        .cotexp-card-title {
            margin: 0;
            color: var(--cotexp-text);
            font-size: 16px;
            font-weight: 800;
        }

        .cotexp-card-note {
            margin: 4px 0 0;
            color: var(--cotexp-muted);
            font-size: 12px;
        }

        .cotexp-form {
            padding: 22px;
        }

        .cotexp-grid {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr;
            gap: 16px;
        }

        .cotexp-grid-full {
            grid-column: 1 / -1;
        }

        .cotexp-field label {
            display: block;
            margin-bottom: 7px;
            color: #374151;
            font-size: 12px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: .04em;
        }

        .cotexp-field .form-control,
        .cotexp-field select,
        .cotexp-field textarea {
            min-height: 44px;
            border: 1px solid #d9e1ec;
            border-radius: 12px;
            color: var(--cotexp-text);
            box-shadow: none;
            transition: border-color .2s, box-shadow .2s;
        }

        .cotexp-field textarea {
            min-height: 88px;
            resize: vertical;
        }

        .cotexp-field .form-control:focus,
        .cotexp-field select:focus,
        .cotexp-field textarea:focus {
            border-color: var(--cotexp-primary);
            box-shadow: 0 0 0 4px rgba(37, 99, 235, .12);
        }

        .select2-container { width: 100% !important; }

        .select2-container--default .select2-selection--multiple {
            min-height: 44px;
            border: 1px solid #d9e1ec !important;
            border-radius: 12px !important;
            padding: 4px 7px;
        }

        .select2-container--default.select2-container--focus .select2-selection--multiple {
            border-color: var(--cotexp-primary) !important;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, .12);
        }

        .select2-container--default .select2-selection--multiple .select2-selection__choice {
            color: #1e3a8a !important;
            background: var(--cotexp-soft) !important;
            border: 1px solid #bfdbfe !important;
            border-radius: 999px !important;
            padding: 3px 9px !important;
            font-size: 12px;
            font-weight: 700;
        }

        .cotexp-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 18px;
        }

        .btn-cotexp-primary {
            min-height: 44px;
            padding: 0 22px;
            border: 0;
            border-radius: 12px;
            background: linear-gradient(135deg, var(--cotexp-primary), var(--cotexp-primary-dark));
            color: #fff;
            font-weight: 800;
            box-shadow: 0 12px 24px rgba(37, 99, 235, .25);
            transition: transform .2s, box-shadow .2s;
        }

        .btn-cotexp-primary:hover {
            transform: translateY(-1px);
            color: #fff;
            box-shadow: 0 16px 28px rgba(37, 99, 235, .32);
        }

        .cotexp-table-wrap {
            padding: 0 18px 18px;
        }

        #cotexp_table {
            border-collapse: separate !important;
            border-spacing: 0 8px !important;
        }

        #cotexp_table thead th {
            background: #f8fafc !important;
            color: #475569 !important;
            border: 0 !important;
        /*    padding: 13px 14px !important;*/
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: .04em;
            white-space: nowrap;
        }

        #cotexp_table tbody td {
            background: #fff !important;
            border-top: 1px solid var(--cotexp-border) !important;
            border-bottom: 1px solid var(--cotexp-border) !important;
            padding: 13px 14px !important;
            vertical-align: middle;
            color: #1f2937;
        }

        #cotexp_table tbody tr td:first-child {
            border-left: 1px solid var(--cotexp-border) !important;
            border-radius: 12px 0 0 12px;
            text-align: center;
            font-weight: 800;
            color: var(--cotexp-primary);
        }

        #cotexp_table tbody tr td:last-child {
            border-right: 1px solid var(--cotexp-border) !important;
            border-radius: 0 12px 12px 0;
        }

        #cotexp_table tbody tr:hover td {
            background: #f8fbff !important;
        }

        .dataTables_filter input {
            height: 40px;
            border: 1px solid #d9e1ec;
            border-radius: 999px;
            padding: 0 14px;
            outline: none;
            margin-left: 8px;
        }

        .dataTables_filter input:focus {
            border-color: var(--cotexp-primary);
            box-shadow: 0 0 0 4px rgba(37, 99, 235, .12);
        }

        .dataTables_paginate,
        .dataTables_info {
            padding-top: 12px !important;
        }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, .28);
            z-index: 99999;
        }

        .loading-inner {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 16px 18px;
            border-radius: 16px;
            background: #fff;
            box-shadow: var(--cotexp-shadow);
            color: var(--cotexp-text);
            font-weight: 800;
        }

        .loading-inner img {
            width: 34px;
            height: 34px;
        }

        .modal-content {
            border: 0;
            border-radius: 18px;
            box-shadow: var(--cotexp-shadow);
        }

        .modal-header, .modal-footer {
            border: 0;
        }

        @media (max-width: 768px) {
            .cotexp-hero, .cotexp-card-header {
                align-items: flex-start;
                flex-direction: column;
            }

            .cotexp-grid {
                grid-template-columns: 1fr;
            }

            .cotexp-actions {
                justify-content: stretch;
            }

            .btn-cotexp-primary {
                width: 100%;
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            cotexp_bindusers();
            cotexp_bindtable();

            const today = new Date().toISOString().split("T")[0];
            $("#cotexp_fromdate, #cotexp_todate").attr("min", today);

            $("#cotexp_user").select2({
                placeholder: "Select employees",
                allowClear: true,
                closeOnSelect: false,
                templateResult: function (data) {
                    if (data.id === '') return data.text;
                    return $('<span><input type="checkbox" style="margin-right:8px;"> ' + data.text + '</span>');
                }
            });
        });

        function cotexp_bindusers() {
            var select = document.getElementById("cotexp_user");
            let options = select.getElementsByTagName('option');
            for (var i = options.length; i--;) select.removeChild(options[i]);

            $("#cotexp_user").append($("<option></option>").val("").html("Select"));

            $.ajax({
                type: "POST",
                url: "AttendanceCorrectionpm.aspx/GteAllUsers",
                dataType: "json",
                contentType: "application/json",
                success: function (res) {
                    var dataArray = JSON.parse(res.d);
                    $.each(dataArray, function (data, value) {
                        $("#cotexp_user").append($("<option></option>").val(value.Code).html(value.Code + ' : ' + value.Name));
                    });
                }
            });
        }

        function cotexp_submit() {
            let selectedValues = $("#cotexp_user").val();
            if (!selectedValues || selectedValues == '') {
                alert("Please select at least one user.");
                return false;
            }

            var fromdate = document.getElementById("cotexp_fromdate").value;
            var todate = document.getElementById("cotexp_todate").value;
            var reason = document.getElementById("cotexp_reason").value.trim();

            if (fromdate == "") { alert("Please select From date"); return false; }
            if (todate == "") { alert("Please select To date"); return false; }
            if (todate < fromdate) { alert("To date should be greater than or equal to From date"); return false; }
            if (reason == "") { alert("Please enter reason"); document.getElementById("cotexp_reason").focus(); return false; }
            if (reason.length < 10) { alert("Reason should be more than 10 characters."); return false; }

            PageMethods.InsertERPCutOffTimeException(selectedValues, fromdate, todate, reason, cotexp_OnSuccess, cotexp_OnError);
            return false;
        }

        function cotexp_OnSuccess(result) {
            document.getElementById("cotexp_errmsg").innerHTML = "Codes added in exception list successfully!";
            $("#cotexp_dverror").modal("show");
            cotexp_bindtable();
            return false;
        }

        function cotexp_OnError(error) {
            alert(error.responseText);
        }

        function blankForNull(s) {
            return s == "null" || s == null ? "" : s;
        }

        function cotexp_bindtable() {
            $('#load1').show();

            if ($.fn.dataTable.isDataTable('#cotexp_table')) {
                $('#cotexp_table').DataTable().destroy();
                $('#cotexp_table tbody').empty();
            }

            $.ajax({
                url: "CutOffTimeExceptions.aspx/GetERpCutOffTimeException",
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    let dataArray = JSON.parse(data.d);

                    $('#cotexp_table').DataTable({
                        data: dataArray,
                        columns: [
                            { data: null, title: "Sr. #", className: "dt-center", render: function (data, type, row, meta) { return meta.row + 1; } },
                            { data: "Code", title: "Code", render: blankForNull },
                            { data: "Name", title: "Name", render: blankForNull },
                            { data: "FromDate", title: "From Date", render: blankForNull },
                            { data: "ToDate", title: "To Date", render: blankForNull },
                            { data: "Remark", title: "Remark", render: blankForNull },
                            { data: "AddedByName", title: "Added By", render: blankForNull }
                        ],
                        dom: '<"row align-items-center mb-3"<"col-md-6"f><"col-md-6 text-md-right"i>>rt<"row align-items-center mt-2"<"col-md-12"p>>',
                        scrollX: true,
                        paging: true,
                        autoWidth: false,
                        ordering: true,
                        processing: true,
                        deferRender: true,
                        language: {
                            search: "",
                            searchPlaceholder: "Search exceptions...",
                            emptyTable: "No exceptions found"
                        },
                        initComplete: function () {
                            $('#load1').hide();
                            this.api().columns.adjust();
                        }
                    });
                },
                error: function (error) {
                    $('#load1').hide();
                    alert('Error: ' + error.responseText);
                }
            });

            return false;
        }
    </script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <div class="loading-inner">
            <img src="../images/Load_1.gif" alt="Loading" />
            <span>One moment, please...</span>
        </div>
    </div>

    <div class="cotexp-page">
        <div class="cotexp-shell">
            <section class="cotexp-hero">
                <div>
                    <h1 class="cotexp-title"><i class="fas fa-clock"></i>&nbsp; Cut Off Time Exceptions</h1>
                    <p class="cotexp-subtitle">Add employee-wise exceptions and track existing requests in one place.</p>
                </div>
                <div class="cotexp-badge">
                    <i class="fas fa-shield-alt"></i>
                    Admin Panel
                </div>
            </section>

            <section class="cotexp-card">
                <div class="cotexp-card-header">
                    <div>
                        <h2 class="cotexp-card-title">Add New Exception</h2>
                        <p class="cotexp-card-note">Select employees, date range, and enter a clear reason.</p>
                    </div>
                </div>

                <div class="cotexp-form">
                    <div class="cotexp-grid">
                        <div class="cotexp-field">
                            <label for="cotexp_user">Employee</label>
                            <select id="cotexp_user" class="form-control" multiple></select>
                        </div>

                        <div class="cotexp-field">
                            <label for="cotexp_fromdate">From Date</label>
                            <input type="date" id="cotexp_fromdate" class="form-control" />
                        </div>

                        <div class="cotexp-field">
                            <label for="cotexp_todate">To Date</label>
                            <input type="date" id="cotexp_todate" class="form-control" />
                        </div>

                        <div class="cotexp-field cotexp-grid-full">
                            <label for="cotexp_reason">Reason</label>
                            <textarea id="cotexp_reason" class="form-control" placeholder="Enter reason, minimum 10 characters"></textarea>
                        </div>
                    </div>

                    <div class="cotexp-actions">
                        <button type="button" class="btn btn-cotexp-primary" onclick="return cotexp_submit();">
                            <i class="fas fa-paper-plane"></i>&nbsp; Submit Request
                        </button>
                    </div>
                </div>
            </section>

            <section class="cotexp-card">
                <div class="cotexp-card-header">
                    <div>
                        <h2 class="cotexp-card-title">Exception History</h2>
                        <p class="cotexp-card-note">Review all cut off time exception entries.</p>
                    </div>
                </div>

                <div class="cotexp-table-wrap">
                    <table class="table" id="cotexp_table" style="width: 100%;">
                        <thead>
                            <tr>
                                <th>Sr. #</th>
                                <th>Code</th>
                                <th>Name</th>
                                <th>From Date</th>
                                <th>To Date</th>
                                <th>Remark</th>
                                <th>Added By</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </section>
        </div>
    </div>

    <div class="modal fade" id="cotexp_dverror">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header justify-content-center">
                    <h6 class="modal-title text-center" id="cotexp_errmsg"></h6>
                </div>
                <div class="modal-footer justify-content-center">
                    <button class="btn btn-cotexp-primary" type="button" id="cotexp_btnMessage" onclick="location.reload();">Okay</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>


<%--<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .loading {
            display: none;
            position: fixed;
            top: 350px;
            left: 50%;
            margin-top: -96px;
            margin-left: -96px;
            /*  background-color: #ccc;*/
            opacity: .85;
            border-radius: 25px;
            width: 192px;
            height: 192px;
            z-index: 99999;
        }

        .dataTables_paginate {
            float: left !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 50px;
            float: left;
        }

        .buttons-excel {
            color: #fff;
            /*     background-color: #28a745;
            border-color: #28a745;*/
            box-shadow: none;
            background: linear-gradient(to right, #ffbf96, #fe7096);
            border: 0;
            font-weight: bold;
            margin: 0px 10px;
        }

        .table.dataTable th {
            /*background:linear-gradient(to bottom, #0070C0, 80%, #ffffff);*/
            background: linear-gradient(to bottom, #cbd0dd, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none;
        }

        .dt-center {
            text-align: center;
        }

        .select2-container--default .select2-selection--multiple .select2-selection__choice {
            color: #000 !important;
        }

        .btn-gradient-primary {
            background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;
            color: #fff;
            border-radius: 12px;
            height: 40px;
            font-weight: 400;
            transition: 0.3s;
        }

            .btn-gradient-primary:hover {
                transform: translateY(-2px);
                /*background: linear-gradient(135deg, #4da6ff, #1a8cff);*/
                background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;
                color: #fff;
            }
    </style>

    <script>
        $(document).ready(function () {

            cotexp_bindusers();
            cotexp_bindtable();

            const today = new Date().toISOString().split("T")[0];
            document.getElementById("cotexp_fromdate").setAttribute("min", today);
            document.getElementById("cotexp_todate").setAttribute("min", today);

            $("#cotexp_user").select2({
                placeholder: "Select",
                allowClear: true,
                closeOnSelect: false,
                templateResult: function (data) {
                    if (data.id === '') {
                        return data.text;
                    }
                    var checkbox = $('<span><input type="checkbox" style="margin-right:6px;"> ' + data.text + '</span>');
                    return checkbox;
                }
            });
        });

        function cotexp_bindusers() {
            var select = document.getElementById("cotexp_user");
            let options = select.getElementsByTagName('option');

            for (var i = options.length; i--;) {
                select.removeChild(options[i]);
            }
            $("#cotexp_user").append($("<option></option>").val("").html("Select"));
            $.ajax({
                type: "POST", url: "AttendanceCorrectionpm.aspx/GteAllUsers", dataType: "json", contentType: "application/json",
                success: function (res) {
                    var dataArray = JSON.parse(res.d);
                    $.each(dataArray, function (data, value) {
                        $("#cotexp_user").append($("<option></option>").val(value.Code).html(value.Code + ' : ' + value.Name));
                    })
                }
            });
        }

        function cotexp_submit() {
            let selectedValues = $("#cotexp_user").val();
            if (!selectedValues || selectedValues == '') {
                alert("Please select at least one user.");
                return false;
            }
            var fromdate = document.getElementById("cotexp_fromdate").value;
            var todate = document.getElementById("cotexp_todate").value;
            if (fromdate == "") {
                alert("Please select From date");
                return false;
            }
            if (todate == "") {
                alert("Please select To date");
                return false;
            }
            var reason = document.getElementById("cotexp_reason").value;
            if (reason == "") {
                alert("Please enter reason");
                document.getElementById("cotexp_reason").focus();
                return false;
            }
            if (reason.length < 10) {
                alert("Reason should be more than 10 characters.");
                return false;
            }
            PageMethods.InsertERPCutOffTimeException(selectedValues, fromdate, todate, reason, cotexp_OnSuccess, cotexp_OnError);
            return false;
        }

        function cotexp_OnSuccess(result) {
            document.getElementById("cotexp_errmsg").innerHTML = "Codes added in exception list successfully!";
            $("#cotexp_dverror").modal("show");
            cotexp_bindtable();
            return false;
        }

        function cotexp_OnError(error) {
            alert(error.responseText);
        }

        function blankForNull(s) {
            return s == "null" || s == null ? "" : s;
        }


        function cotexp_bindtable() {
            $('#load1').show();

            if ($.fn.dataTable.isDataTable('#cotexp_table')) {
                $('#cotexp_table').DataTable().destroy();
                $('#cotexp_table tbody').empty(); // important
            }

            $.ajax({
                url: "CutOffTimeExceptions.aspx/GetERpCutOffTimeException",
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",

                success: function (data) {

                    let dataArray = JSON.parse(data.d);

                    $('#cotexp_table').DataTable({
                        data: dataArray,   // 🔥 direct binding (no loop)

                        columns: [
                            {
                                data: null, title: "Sr. #", render: function (data, type, row, meta) { return meta.row + 1; }
                            },
                            { data: "Code", title: "Code", render: blankForNull },
                            { data: "Name", title: "Name", render: blankForNull },
                            { data: "FromDate", title: "From Date", render: blankForNull },
                            { data: "ToDate", title: "To Date", render: blankForNull },
                            { data: "Remark", title: "Remark", render: blankForNull },
                            { data: "AddedByName", title: "Added By", render: blankForNull }
                        ],

                        dom: 'pfti',
                        scrollX: true,
                        paging: true,
                        autoWidth: false,
                        ordering: true,
                        processing: true,
                        deferRender: true, // ⚡ BIG performance boost

                        initComplete: function () {
                            $('#load1').hide();
                        }
                    });
                },

                error: function (error) {
                    $('#load1').hide();
                    alert('Error: ' + error.responseText);
                }
            });

            return false;
        }

    </script>

    <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/css/select2.min.css" rel="stylesheet" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/js/select2.min.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Add Exception for Cut off time</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <div class="container mt-4">
                    <div class="card shadow-sm">

                        <!-- Row 1 -->
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label><b>Employee</b></label>
                                <select id="cotexp_user" class="form-control" multiple></select>
                            </div>

                            <div class="col-md-3">
                                <label><b>From Date</b></label>
                                <input type="date" id="cotexp_fromdate" class="form-control" />
                            </div>

                            <div class="col-md-3">
                                <label><b>To Date</b></label>
                                <input type="date" id="cotexp_todate" class="form-control" />
                            </div>
                        </div>

                        <!-- Row 2 -->
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label><b>Reason</b></label>
                                <textarea id="cotexp_reason" class="form-control"></textarea>
                            </div>

                            <div class="col-md-3 d-flex align-items-end">
                                <button class="btn btn-gradient-primary w-100" onclick="return cotexp_submit();">
                                    Submit Request
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <table class="table" id="cotexp_table" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">From Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">To Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Remark</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added By</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr></tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="modal fade" id="cotexp_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="cotexp_errmsg"></h6>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="cotexp_btnMessage" onclick="location.reload();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>--%>
