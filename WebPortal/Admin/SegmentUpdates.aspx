<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="SegmentUpdates.aspx.cs" Inherits="WebPortal.Admin.SegmentUpdates" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --seg-primary: #1d4ed8;
            --seg-primary-2: #2563eb;
            --seg-cyan: #22c1dc;
            --seg-ink: #0f172a;
            --seg-muted: #64748b;
            --seg-border: #e2e8f0;
            --seg-soft: #f8fafc;
            --seg-card: #ffffff;
            --seg-shadow: 0 18px 45px rgba(15, 23, 42, .10);
            --seg-radius: 22px;
        }

        .swal2-container {
            z-index: 99999 !important;
        }

        .seg-page {
            background: linear-gradient(180deg, #f8fbff 0%, #f3f6fb 100%);
            min-height: calc(100vh - 90px);
        }

        .seg-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            gap: 18px;
            padding: 21px 26px;
            border-radius: var(--seg-radius);
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%);
            box-shadow: var(--seg-shadow);
            margin-bottom: 18px;
        }

            .seg-hero:before,
            .seg-hero:after {
                content: "";
                position: absolute;
                border-radius: 999px;
                background: rgba(255, 255, 255, .13);
                pointer-events: none;
            }

            .seg-hero:before {
                width: 210px;
                height: 210px;
                right: 90px;
                top: -125px;
            }

            .seg-hero:after {
                width: 310px;
                height: 310px;
                right: -120px;
                bottom: -190px;
            }

        .seg-hero-icon {
            position: relative;
            z-index: 1;
            width: 50px;
            height: 50px;
            display: grid;
            place-items: center;
            flex: 0 0 50px;
            border-radius: 18px;
            background: rgba(255, 255, 255, .17);
            border: 1px solid rgba(255, 255, 255, .25);
            box-shadow: inset 0 1px 0 rgba(255,255,255,.20);
            font-size: 24px;
        }

        .seg-hero-content {
            position: relative;
            z-index: 1;
        }

        .seg-title {
            margin: 0;
            font-size: 19px;
            font-weight: 800;
            letter-spacing: -.02em;
        }

        .seg-subtitle {
            margin: 7px 0 0;
            font-size: 12px;
            line-height: 1.5;
            opacity: .92;
        }

        .seg-card {
            border: 1px solid rgba(226, 232, 240, .95);
            border-radius: var(--seg-radius);
            background: var(--seg-card);
            box-shadow: var(--seg-shadow);
            overflow: hidden;
        }

        .seg-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            padding: 18px 20px;
            border-bottom: 1px solid var(--seg-border);
            background: linear-gradient(180deg, #ffffff 0%, #f8fafc 100%);
        }

        .seg-card-title {
            margin: 0;
            color: var(--seg-ink);
            font-size: 17px;
            font-weight: 800;
        }

        .seg-card-subtitle {
            margin: 4px 0 0;
            color: var(--seg-muted);
            font-size: 12px;
        }

        .seg-card-body {
            padding: 18px 20px 22px;
        }

        #btnBulkUpdate,
        .seg-btn-primary {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
            min-height: 42px;
            padding: 0 18px;
            border: 0 !important;
            border-radius: 14px;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%) !important;
            color: #fff !important;
            font-size: 13px;
            font-weight: 800;
            letter-spacing: .01em;
            box-shadow: 0 12px 24px rgba(37, 99, 235, .28);
            transition: all .22s ease;
            white-space: nowrap;
        }

            #btnBulkUpdate:hover,
            .seg-btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 18px 36px rgba(37, 99, 235, .34);
            }

        .seg-btn-light {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 42px;
            padding: 0 18px;
            border-radius: 14px;
            border: 1px solid var(--seg-border) !important;
            background: #fff !important;
            color: #334155 !important;
            font-weight: 800;
            box-shadow: 0 8px 18px rgba(15,23,42,.06);
        }

        .seg-table-wrap {
            width: 100%;
            overflow: hidden;
            border-radius: 18px;
            background: #fff;
        }

        .table.dataTable {
            width: 100% !important;
            margin: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0 !important;
        }

            .table.dataTable thead th {
                border: none !important;
                font-size: 12px;
                font-weight: 800;
                letter-spacing: .03em;
                text-transform: uppercase;
                vertical-align: middle;
                white-space: nowrap;
            }

            .table.dataTable tbody td {
                padding: 13px 12px !important;
                color: #334155;
                border-top: 1px solid #eef2f7 !important;
                background: #fff !important;
                vertical-align: middle;
                font-size: 13px;
            }

            .table.dataTable tbody tr:hover td {
                background: #f8fbff !important;
            }

        .emp-checkbox,
        #segupdate_selectAll {
            width: 17px;
            height: 17px;
            accent-color: var(--seg-primary-2);
            cursor: pointer;
        }

        .seg-edit-icon,
        .fa-edit.text-primary {
            width: 34px;
            height: 34px;
            display: inline-grid;
            place-items: center;
            border-radius: 12px;
            background: #eff6ff;
            color: #2563eb !important;
            cursor: pointer;
            transition: all .2s ease;
        }

            .seg-edit-icon:hover,
            .fa-edit.text-primary:hover {
                transform: translateY(-2px);
                background: #dbeafe;
            }

        .dataTables_wrapper {
            color: var(--seg-muted);
        }

            .dataTables_wrapper .dataTables_length,
            .dataTables_wrapper .dataTables_filter {
                margin-bottom: 14px;
            }

                .dataTables_wrapper .dataTables_filter input,
                .dataTables_wrapper .dataTables_length select {
                    border: 1px solid var(--seg-border) !important;
                    border-radius: 12px !important;
                    padding: 7px 10px !important;
                    outline: none !important;
                    background: #fff;
                }

                    .dataTables_wrapper .dataTables_filter input:focus {
                        border-color: #2563eb !important;
                        box-shadow: 0 0 0 3px rgba(37,99,235,.12);
                    }

        .dataTables_paginate {
            float: left !important;
            padding-top: 14px !important;
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button {
            border: 1px solid var(--seg-border) !important;
            border-radius: 10px !important;
            padding: 6px 12px !important;
            margin: 0 3px !important;
            background: #fff !important;
            color: #334155 !important;
        }

            .dataTables_wrapper .dataTables_paginate .paginate_button.current,
            .dataTables_wrapper .dataTables_paginate .paginate_button.current:hover {
                background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%) !important;
                color: #fff !important;
                border-color: transparent !important;
            }

        .dataTables_wrapper .dataTables_info {
            padding-top: 18px !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 18px;
            float: left;
        }

        .buttons-excel {
            color: #fff !important;
            box-shadow: 0 10px 22px rgba(34, 197, 94, .20) !important;
            background: linear-gradient(120deg, #16a34a 0%, #22c55e 100%) !important;
            border: 0 !important;
            border-radius: 12px !important;
            font-weight: 800 !important;
        }

        #modalOverlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, .56);
            backdrop-filter: blur(4px);
            z-index: 9998;
        }

        #segmentModal {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: min(430px, calc(100vw - 34px));
            background: #fff;
            padding: 0;
            border-radius: 24px;
            z-index: 9999;
            box-shadow: 0 30px 80px rgba(15, 23, 42, .30);
            overflow: hidden;
        }

        .seg-modal-head {
            padding: 22px 24px;
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%);
        }

            .seg-modal-head h4 {
                margin: 0;
                font-size: 19px;
                font-weight: 800;
            }

            .seg-modal-head p {
                margin: 6px 0 0;
                font-size: 12px;
                opacity: .9;
            }

        .seg-modal-body {
            padding: 22px 24px;
        }

        .seg-modal-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            padding-top: 8px;
        }

        #segmentModal .form-control {
            min-height: 44px;
            border-radius: 14px;
            border: 1px solid var(--seg-border);
            box-shadow: none;
        }

            #segmentModal .form-control:focus {
                border-color: #2563eb;
                box-shadow: 0 0 0 3px rgba(37,99,235,.12);
            }

        .loading {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            padding: 18px;
            text-align: center;
            background: rgba(255,255,255,.94);
            border: 1px solid var(--seg-border);
            border-radius: 22px;
            width: 192px;
            z-index: 99999;
            box-shadow: var(--seg-shadow);
        }

        @media (max-width: 768px) {
            .seg-page {
                padding: 12px;
            }

            .seg-hero {
                align-items: flex-start;
                padding: 18px;
            }

            .seg-title {
                font-size: 20px;
            }

            .seg-card-header {
                flex-direction: column;
                align-items: flex-start;
            }

            #btnBulkUpdate {
                width: 100%;
            }
        }
    </style>

    <script>
        var segmentList = [];
        var segment_selectedEmployees = [];

        $(document).ready(function () {
            segupdate_bindEmployees();
            loadSegments();
        });

        function getsegment_selectedEmployees() {

            var selected = [];

            $('.emp-checkbox:checked').each(function () {
                selected.push($(this).val());
            });

            return selected;
        }

        function updateSelectionUI() {

            var count = segment_selectedEmployees.length;

            if (count > 0) {
                $('#btnBulkUpdate')
                    .show()
                    .text(`Update Selected (${count})`);
            } else {
                $('#btnBulkUpdate').hide();
            }

            // Sync select all
            var totalVisible = $('.emp-checkbox').length;
            var checkedVisible = $('.emp-checkbox:checked').length;

            $('#segupdate_selectAll').prop('checked', totalVisible > 0 && totalVisible === checkedVisible);
        }


        $(document).on('change', '#segupdate_selectAll', function () {
            //$('.emp-checkbox').prop('checked', this.checked);

            //updateSelectionUI();

            var rows = $('#viewemployee').DataTable().rows({ search: 'applied' }).nodes();

            $('input.emp-checkbox', rows).each(function () {

                var empId = $(this).val();

                if ($('#segupdate_selectAll').is(':checked')) {

                    $(this).prop('checked', true);

                    if (!segment_selectedEmployees.includes(empId)) {
                        segment_selectedEmployees.push(empId);
                    }

                } else {

                    $(this).prop('checked', false);
                    segment_selectedEmployees = segment_selectedEmployees.filter(x => x != empId);
                }
            });

            updateSelectionUI();
        });

        $(document).on('change', '.emp-checkbox', function () {
            //updateSelectionUI();
            var empId = $(this).val();

            if ($(this).is(':checked')) {

                if (!segment_selectedEmployees.includes(empId)) {
                    segment_selectedEmployees.push(empId);
                }

            } else {
                segment_selectedEmployees = segment_selectedEmployees.filter(x => x != empId);
            }

            updateSelectionUI();
        });

        function loadSegments() {
            $.ajax({
                type: "POST",
                url: "SegmentUpdates.aspx/GetAllSegments",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (res) {
                    if (typeof res.d === "string") {
                        segmentList = JSON.parse(res.d);
                    } else {
                        segmentList = res.d;
                    }
                },
                error: function (err) {
                    console.log(err);
                }
            });
        }
        function segupdate_bindEmployees() {

            $('#segupdate_viewemployee').DataTable({
                destroy: true,
                processing: true,
                serverSide: false,
                scrollX: true,
                ajax: {
                    url: "SegmentUpdates.aspx/GetAllEmployees",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataSrc: function (json) {
                        return JSON.parse(json.d);
                    }
                },

                dom: '<"seg-dt-top"lfB>rt<"seg-dt-bottom"ip>',
                order: [],
                initComplete: function () {
                    $('#segupdate_viewemployee thead').addClass('seg-dt-header');
                },

                columns: [

                    // ✅ Actions Column
                    {
                        data: null,
                        render: function (data, type, row) {
                            return `<input type="checkbox" class="emp-checkbox" value="${row.EmployeeID}" />`;
                        },
                        orderable: false
                    },

                    // ✅ Action Column (Edit Icon)
                    {
                        data: null,
                        render: function (data, type, row) {
                            return `<i class="fa fa-edit text-primary seg-edit-icon"
                                onclick="return openEditPopup(${row.EmployeeID})"></i>`;
                        },
                        orderable: false
                    },
                    { data: "Code" },
                    { data: "FullName" },
                    { data: "JoiningDate" },
                    { data: "BranchName" },
                    { data: "DepartmentName" },
                    { data: "DesignationName" },
                    { data: "DomainName" },
                    { data: "Subdomain" },
                    { data: "Segment" },

                    { data: "ReportingManager" },
                    { data: "JobType" },
                    { data: "CurrentLogin" },
                    { data: "CurrentStatus" }

                ], buttons: [
                    {
                        extend: 'excelHtml5',
                        title: 'Report Name',
                        text: '<i class="fa fa-file-excel-o"></i>Excel',
                        autoFilter: true
                    }
                ]
            });

            $('#segupdate_viewemployee').on('draw.dt', function () {
                //$('#segupdate_selectAll').prop('checked', false);
                //$('#btnBulkUpdate').hide();
                $('.emp-checkbox').each(function () {

                    var empId = $(this).val();

                    if (segment_selectedEmployees.includes(empId)) {
                        $(this).prop('checked', true);
                    }
                });

                updateSelectionUI();
            });
        }


        // ✅ Open Popup (Single + Bulk)
        function openEditPopup(empId = 0) {

            segment_selectedEmployees = [];

            if (empId > 0) {
                segment_selectedEmployees.push(empId);
            } else {
                //$('.emp-checkbox:checked').each(function () {
                //    segment_selectedEmployees.push($(this).val());
                //});

                segment_selectedEmployees = getsegment_selectedEmployees();

                if (segment_selectedEmployees.length === 0) {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Oops...',
                        text: 'Select at least one employee'
                    });
                    return false;
                }
            }

            loadSegmentDropdown();
            $('#modalOverlay').show();   // 🔥 show overlay
            $('#segmentModal').show();
            return false;
        }


        // ✅ Close Popup
        function closePopup() {
            $('#segmentModal').hide();
            $('#modalOverlay').hide();
            return false;
        }


        // ✅ Load Dropdown in Popup
        function loadSegmentDropdown() {

            var ddl = $('#ddlSegmentPopup');
            ddl.empty();

            ddl.append('<option value="">Select Segment</option>');

            $.each(segmentList, function (i, seg) {
                ddl.append(`<option value="${seg.Segment}">${seg.Segment}</option>`);
            });
            ddl.append('<option value="__addnew__">+ Add New Segment</option>');
        }

        function handleSegmentChange() {

            var val = $('#ddlSegmentPopup').val();

            if (val === "__addnew__") {
                $('#newSegmentDiv').show();
                $('#txtNewSegment').focus();
            } else {
                $('#newSegmentDiv').hide();
                $('#txtNewSegment').val('');
            }
            return false;
        }


        // ✅ Save (Bulk + Single)
        function saveSegment() {

            var selectedVal = $('#ddlSegmentPopup').val();
            var segmentName = "";

            if (selectedVal === "__addnew__") {

                segmentName = $('#txtNewSegment').val().trim();

                if (!segmentName) {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Validation',
                        text: 'Please enter new segment'
                    });
                    return false;
                }

                // 🔥 Prevent duplicate
                var exists = segmentList.some(x => x.Segment.toLowerCase() === segmentName.toLowerCase());

                if (exists) {
                    Swal.fire({
                        icon: 'error',
                        title: 'Duplicate',
                        text: 'Segment already exists'
                    });
                    return false;
                }

            } else {
                segmentName = selectedVal;

                if (!segmentName) {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Validation',
                        text: 'Please select segment'
                    });
                    return false;
                }
            }


            $.ajax({
                type: "POST",
                url: "SegmentUpdates.aspx/UpdateSegmentBulk",
                data: JSON.stringify({
                    empIds: segment_selectedEmployees,
                    newSegment: segmentName
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function () {

                    Swal.fire({
                        icon: 'success',
                        title: 'Success',
                        text: 'Updated successfully',
                        timer: 1500,
                        showConfirmButton: false
                    });
                    if (selectedVal === "__addnew__") {
                        segmentList.push({ Segment: segmentName });
                    }

                    // 🔥 IMPORTANT: Clear selection
                    segment_selectedEmployees = [];

                    // 🔥 Uncheck all checkboxes
                    $('.emp-checkbox').prop('checked', false);
                    $('#segupdate_selectAll').prop('checked', false);

                    // 🔥 Hide button
                    $('#btnBulkUpdate').hide();

                    closePopup();
                    segupdate_bindEmployees(); // reload
                },
                error: function (err) {
                    console.log(err);
                }
            });
            return false;
        }

    </script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="seg-page">
        <div class="loading" id="load1">
            <img src="../images/Load_1.gif" alt="Loading" />
            <div style="font-size: 12px; font-weight: 800; color: #334155; margin-top: 8px;">One moment, please...</div>
        </div>

        <section class="seg-hero">
            <div class="seg-hero-icon">
                <i class="fas fa-layer-group"></i>
            </div>
            <div class="seg-hero-content">
                <h1 class="seg-title">Segment Master</h1>
                <p class="seg-subtitle">View employees, assign segments individually, or update selected employees in bulk.</p>
            </div>
        </section>

        <div class="seg-card">
            <div class="seg-card-header">
                <div>
                    <h2 class="seg-card-title"><i class="fas fa-users-cog"></i>&nbsp; Employee Segment Updates</h2>
                    <p class="seg-card-subtitle">Select employees from the table and update their segment without changing existing functionality.</p>
                </div>
                <button id="btnBulkUpdate" style="display: none;" class="seg-btn-primary" onclick="return openEditPopup(0);">
                    <i class="fas fa-sync-alt"></i>
                    Update Selected
               
                </button>
            </div>

            <div class="seg-card-body">
                <div class="seg-table-wrap">
                    <table class="table" id="segupdate_viewemployee" style="padding-top: 10px; width: 100%;">
                        <thead>
                            <tr>
                                <th>
                                    <input type="checkbox" id="segupdate_selectAll" /></th>
                                <th style="width: 50px;">Actions</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Code</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Name</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Joining Date</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Branch</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Department</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Designation</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Domain</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Subdomain</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Segment</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Reporting Manager</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Job Type</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Latest Login</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Current Status</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>

        <div id="modalOverlay"></div>

        <div id="segmentModal">
            <div class="seg-modal-head">
                <h4><i class="fas fa-tags"></i>&nbsp; Select Segment</h4>
                <p>Choose an existing segment or add a new one.</p>
            </div>
            <div class="seg-modal-body">
                <select id="ddlSegmentPopup" class="form-control" onchange="return handleSegmentChange();"></select>

                <div id="newSegmentDiv" style="display: none; margin-top: 14px;">
                    <input type="text" id="txtNewSegment" class="form-control" placeholder="Enter new segment" />
                </div>

                <div class="seg-modal-actions">
                    <button type="button" class="seg-btn-light" onclick="return closePopup();">Cancel</button>
                    <button type="button" class="seg-btn-primary" onclick="return saveSegment();">Update</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<%--<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .swal2-container {
            z-index: 99999 !important;
        }

        #modalOverlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.3); /* 🔥 change opacity here */
            z-index: 9998;
        }

        /* Modal box */
        #segmentModal {
            display: none;
            position: fixed;
            top: 30%;
            left: 40%;
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            z-index: 9999;
            min-width: 300px;
        }

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

        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dt-buttons {
            display: flex;
            align-items: center;
        }

        .dataTables_wrapper .dataTables_length {
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
        }

        .table.dataTable th {
            background: linear-gradient(to bottom, #cbd0dd, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none;
        }
    </style>

    <script>
        var segmentList = [];
        var segment_selectedEmployees = [];

        $(document).ready(function () {
            segupdate_bindEmployees();
            loadSegments();
        });

        function getsegment_selectedEmployees() {

            var selected = [];

            $('.emp-checkbox:checked').each(function () {
                selected.push($(this).val());
            });

            return selected;
        }

        function updateSelectionUI() {

            var count = segment_selectedEmployees.length;

            if (count > 0) {
                $('#btnBulkUpdate')
                    .show()
                    .text(`Update Selected (${count})`);
            } else {
                $('#btnBulkUpdate').hide();
            }

            // Sync select all
            var totalVisible = $('.emp-checkbox').length;
            var checkedVisible = $('.emp-checkbox:checked').length;

            $('#segupdate_selectAll').prop('checked', totalVisible > 0 && totalVisible === checkedVisible);
        }


        $(document).on('change', '#segupdate_selectAll', function () {
            //$('.emp-checkbox').prop('checked', this.checked);

            //updateSelectionUI();

            var rows = $('#viewemployee').DataTable().rows({ search: 'applied' }).nodes();

            $('input.emp-checkbox', rows).each(function () {

                var empId = $(this).val();

                if ($('#segupdate_selectAll').is(':checked')) {

                    $(this).prop('checked', true);

                    if (!segment_selectedEmployees.includes(empId)) {
                        segment_selectedEmployees.push(empId);
                    }

                } else {

                    $(this).prop('checked', false);
                    segment_selectedEmployees = segment_selectedEmployees.filter(x => x != empId);
                }
            });

            updateSelectionUI();
        });

        $(document).on('change', '.emp-checkbox', function () {
            //updateSelectionUI();
            var empId = $(this).val();

            if ($(this).is(':checked')) {

                if (!segment_selectedEmployees.includes(empId)) {
                    segment_selectedEmployees.push(empId);
                }

            } else {
                segment_selectedEmployees = segment_selectedEmployees.filter(x => x != empId);
            }

            updateSelectionUI();
        });

        function loadSegments() {
            $.ajax({
                type: "POST",
                url: "SegmentUpdates.aspx/GetAllSegments",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (res) {
                    if (typeof res.d === "string") {
                        segmentList = JSON.parse(res.d);
                    } else {
                        segmentList = res.d;
                    }
                },
                error: function (err) {
                    console.log(err);
                }
            });
        }
        function segupdate_bindEmployees() {

            $('#segupdate_viewemployee').DataTable({
                destroy: true,
                processing: true,
                serverSide: false,
                scrollX: true,
                ajax: {
                    url: "SegmentUpdates.aspx/GetAllEmployees",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataSrc: function (json) {
                        return JSON.parse(json.d);
                    }
                },

                columns: [

                    // ✅ Actions Column
                    {
                        data: null,
                        render: function (data, type, row) {
                            return `<input type="checkbox" class="emp-checkbox" value="${row.EmployeeID}" />`;
                        },
                        orderable: false
                    },

                    // ✅ Action Column (Edit Icon)
                    {
                        data: null,
                        render: function (data, type, row) {
                            return `<i class="fa fa-edit text-primary"
                                style="cursor:pointer"
                                onclick="return openEditPopup(${row.EmployeeID})"></i>`;
                        },
                        orderable: false
                    },
                    { data: "Code" },
                    { data: "FullName" },
                    { data: "JoiningDate" },
                    { data: "BranchName" },
                    { data: "DepartmentName" },
                    { data: "DesignationName" },
                    { data: "DomainName" },
                    { data: "Subdomain" },
                    { data: "Segment" },

                    { data: "ReportingManager" },
                    { data: "JobType" },
                    { data: "CurrentLogin" },
                    { data: "CurrentStatus" }

                ]
            });

            $('#segupdate_viewemployee').on('draw.dt', function () {
                //$('#segupdate_selectAll').prop('checked', false);
                //$('#btnBulkUpdate').hide();
                $('.emp-checkbox').each(function () {

                    var empId = $(this).val();

                    if (segment_selectedEmployees.includes(empId)) {
                        $(this).prop('checked', true);
                    }
                });

                updateSelectionUI();
            });
        }


        // ✅ Open Popup (Single + Bulk)
        function openEditPopup(empId = 0) {

            segment_selectedEmployees = [];

            if (empId > 0) {
                segment_selectedEmployees.push(empId);
            } else {
                //$('.emp-checkbox:checked').each(function () {
                //    segment_selectedEmployees.push($(this).val());
                //});

                segment_selectedEmployees = getsegment_selectedEmployees();

                if (segment_selectedEmployees.length === 0) {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Oops...',
                        text: 'Select at least one employee'
                    });
                    return false;
                }
            }

            loadSegmentDropdown();
            $('#modalOverlay').show();   // 🔥 show overlay
            $('#segmentModal').show();
            return false;
        }


        // ✅ Close Popup
        function closePopup() {
            $('#segmentModal').hide();
            $('#modalOverlay').hide();
            return false;
        }


        // ✅ Load Dropdown in Popup
        function loadSegmentDropdown() {

            var ddl = $('#ddlSegmentPopup');
            ddl.empty();

            ddl.append('<option value="">Select Segment</option>');

            $.each(segmentList, function (i, seg) {
                ddl.append(`<option value="${seg.Segment}">${seg.Segment}</option>`);
            });
            ddl.append('<option value="__addnew__">+ Add New Segment</option>');
        }

        function handleSegmentChange() {

            var val = $('#ddlSegmentPopup').val();

            if (val === "__addnew__") {
                $('#newSegmentDiv').show();
                $('#txtNewSegment').focus();
            } else {
                $('#newSegmentDiv').hide();
                $('#txtNewSegment').val('');
            }
            return false;
        }


        // ✅ Save (Bulk + Single)
        function saveSegment() {

            var selectedVal = $('#ddlSegmentPopup').val();
            var segmentName = "";

            if (selectedVal === "__addnew__") {

                segmentName = $('#txtNewSegment').val().trim();

                if (!segmentName) {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Validation',
                        text: 'Please enter new segment'
                    });
                    return false;
                }

                // 🔥 Prevent duplicate
                var exists = segmentList.some(x => x.Segment.toLowerCase() === segmentName.toLowerCase());

                if (exists) {
                    Swal.fire({
                        icon: 'error',
                        title: 'Duplicate',
                        text: 'Segment already exists'
                    });
                    return false;
                }

            } else {
                segmentName = selectedVal;

                if (!segmentName) {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Validation',
                        text: 'Please select segment'
                    });
                    return false;
                }
            }


            $.ajax({
                type: "POST",
                url: "SegmentUpdates.aspx/UpdateSegmentBulk",
                data: JSON.stringify({
                    empIds: segment_selectedEmployees,
                    newSegment: segmentName
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function () {

                    Swal.fire({
                        icon: 'success',
                        title: 'Success',
                        text: 'Updated successfully',
                        timer: 1500,
                        showConfirmButton: false
                    });
                    if (selectedVal === "__addnew__") {
                        segmentList.push({ Segment: segmentName });
                    }

                    // 🔥 IMPORTANT: Clear selection
                    segment_selectedEmployees = [];

                    // 🔥 Uncheck all checkboxes
                    $('.emp-checkbox').prop('checked', false);
                    $('#segupdate_selectAll').prop('checked', false);

                    // 🔥 Hide button
                    $('#btnBulkUpdate').hide();

                    closePopup();
                    segupdate_bindEmployees(); // reload
                },
                error: function (err) {
                    console.log(err);
                }
            });
            return false;
        }

    </script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Segment Master</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <h5 class="card-title"></h5>
                <button id="btnBulkUpdate" style="display: none;" class="btn btn-primary" onclick="return openEditPopup(0);">
                    Update Selected
                </button>
                <table class="table" id="segupdate_viewemployee" style="padding-top: 10px; width: 100%;">
                    <thead>
                        <tr>
                            <th>
                                <input type="checkbox" id="segupdate_selectAll" /></th>
                            <th style="width: 50px;">Actions</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Code</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Name</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Joining Date</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Branch</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Department</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Designation</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Domain</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Subdomain</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Segment</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Reporting Manager</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Job Type</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Latest Login</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Current Status</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
    <div id="modalOverlay"></div>

    <div id="segmentModal">
        <h4>Select Segment</h4>

        <select id="ddlSegmentPopup" class="form-control" onchange="return handleSegmentChange();"></select>

        <br />
        <!-- Hidden input for new segment -->
        <div id="newSegmentDiv" style="display: none;">
            <input type="text" id="txtNewSegment" class="form-control" placeholder="Enter new segment" />
        </div>
        <br />
        <button type="button" class="btn btn-primary" onclick="return saveSegment();">Update</button>
        <button type="button" class="btn btn-default" onclick="return closePopup();">Cancel</button>
      
    </div>
</asp:Content>--%>
