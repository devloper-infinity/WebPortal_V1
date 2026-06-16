<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="SegmentUpdates.aspx.cs" Inherits="WebPortal.Admin.SegmentUpdates" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
        <%--   <button onclick="return closePopup();">Cancel</button>data-dismiss="modal"--%>
    </div>
</asp:Content>
