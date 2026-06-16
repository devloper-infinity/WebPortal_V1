<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ProjectConfiguration.aspx.cs" Inherits="WebPortal.Admin.ProjectConfiguration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .edit-btn:hover {
            color: #dc3545;
            transform: scale(1.1);
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
            /*background:linear-gradient(to bottom, #0070C0, 80%, #ffffff);*/
            background: linear-gradient(to bottom, #cbd0dd, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none;
        }

        .dataTables_scrollHeadInner {
            width: 100% !important;
        }

        .no-footer {
            width: 100% !important;
        }



        /*.form-control {
            font-size: 11px !important;
        }*/
    </style>
    <style>
        .form-label {
            margin-bottom: 5px;
            font-size: 14px;
        }

        .form-control,
        .form-control {
            border-radius: 6px;
            min-height: 38px;
        }

        .compact-month-card {
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            padding: 10px 6px;
            text-align: center;
            cursor: pointer;
            transition: 0.2s;
            background: #fff;
            position: relative;
            min-height: 85px;
        }

            .compact-month-card:hover {
                border-color: #0d6efd;
                transform: translateY(-2px);
            }

            .compact-month-card input[type=radio] {
                position: absolute;
                top: 8px;
                left: 8px;
                transform: scale(1.1);
            }

            .compact-month-card .month-name {
                font-weight: 700;
                font-size: 15px;
                margin-top: 10px;
                color: #374151;
            }

            .compact-month-card .month-target {
                margin-top: 8px;
                background: #eef2ff;
                color: #3730a3;
                border-radius: 8px;
                padding: 4px;
                font-size: 13px;
                font-weight: 700;
            }


        /* SELECTED */

        .month-radio:checked + .month-name {
            color: #0d6efd;
        }

        .compact-month-card.selected {
            border-color: #0d6efd;
            background: #eff6ff;
            box-shadow: 0 0 0 3px rgba(13,110,253,0.15);
        }

        .modal-content {
            border-radius: 18px;
        }

        .spinner-border {
            animation-duration: 0.8s;
        }

        .page-card {
            background: #fff;
            border-radius: 14px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            padding: 24px;
        }

        .page-title {
            font-size: 24px;
            font-weight: 600;
            color: #1f2937;
        }

        .sub-title {
            color: #6b7280;
            font-size: 14px;
        }

        .search-panel {
            background: #f9fafb;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: 20px;
        }

        .btn-primary-custom {
            background: #0d6efd;
            border: none;
            border-radius: 8px;
            padding: 10px 22px;
            font-weight: 600;
        }

        .btn-success-custom {
            background: #10b981;
            border: none;
            border-radius: 8px;
            padding: 10px 22px;
            font-weight: 600;
            color: #fff;
        }

        .table-section {
            display: none;
        }

        table.dataTable thead th {
            background: #eef2ff;
            color: #374151;
            font-weight: 600;
            border-bottom: 1px solid #dbeafe !important;
        }

        .dataTables_wrapper .dataTables_filter input {
            border-radius: 8px;
            border: 1px solid #d1d5db;
            padding: 5px 10px;
        }

        .badge-domain {
            background: #e0f2fe;
            color: #0369a1;
            padding: 6px 10px;
            border-radius: 20px;
            font-size: 12px;
        }

        .action-bar {
            background: #f9fafb;
            border: 1px solid #e5e7eb;
            border-radius: 10px;
            padding: 15px;
        }

        .tab-custom .nav-link {
            color: #374151;
            font-weight: 600;
            border-radius: 10px 10px 0 0;
        }

            .tab-custom .nav-link.active {
                background: #0d6efd;
                color: #fff;
            }

        .main-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
        }

        .section-title {
            font-size: 24px;
            font-weight: 700;
            color: #1f2937;
        }

        .section-subtitle {
            color: #6b7280;
            font-size: 14px;
        }

        .month-card {
            border: 2px solid #e5e7eb;
            border-radius: 14px;
            transition: 0.2s;
            cursor: pointer;
            height: 100%;
        }

            .month-card:hover {
                border-color: #0d6efd;
                transform: translateY(-3px);
                box-shadow: 0 5px 14px rgba(0,0,0,0.08);
            }

            .month-card.selected {
                border-color: #0d6efd;
                background: #eff6ff;
            }

        .month-title {
            font-size: 15px;
            font-weight: 700;
            color: #374151;
        }

        .target-badge {
            background: #eef2ff;
            color: #3730a3;
            border-radius: 10px;
            padding: 10px;
            font-size: 14px;
            font-weight: 700;
            margin-top: 10px;
        }

        .month-radio {
            transform: scale(1.2);
            cursor: pointer;
        }

        .btn-primary-custom {
            background: #2563eb;
            border: none;
            border-radius: 10px;
            padding: 10px 20px;
            font-weight: 600;
        }

        .btn-success-custom {
            background: #10b981;
            border: none;
            border-radius: 10px;
            padding: 10px 20px;
            font-weight: 600;
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        function proconf_getsecondtab() {
            processconf_bindproject();
            processconf_getprocesslist();
            return false;
        }
        function proconf_getthirdtab() {
            productconf_bindproject();
            productconf_bindgrid();
            return false;
        }
        function proconf_getforthtab() {
            targetconf_bindlist();
            return false;
        }
        function proconf_getfifthtab() {
            projectrights_bindprojectslist();
            projectrights_loadUsers();
            specialtarget_loadUsers();
            specialtarget_loadAssignedTargets();
            return false;
        }

        $(document).ready(function () {
            projectconf_binddomaingroups();
            projectconf_getprojectslist();

            $('#specialtarget_btnLoadTargets').click(function (e) {

                e.preventDefault();

                let employeeId = $('#specialtarget_ddlEmployee').val();
                let projectId = $('#specialtarget_ddlProject').val();
                let processId = $('#specialtarget_ddlProcess').val();

                if (employeeId == '') {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Warning',
                        text: 'Please select employee.',
                        timer: 1500,
                        showConfirmButton: false
                    });


                    return;
                }
                if (projectId == '') {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Warning',
                        text: 'Please select project.',
                        timer: 1500,
                        showConfirmButton: false
                    });


                    return;
                }
                if (processId == '') {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Warning',
                        text: 'Please select process.',
                        timer: 1500,
                        showConfirmButton: false
                    });


                    return;
                }

                specialtarget_loadMonthTargets(projectId, processId);

            });

            $(document).on('change', '.month-radio', function () {

                $('.month-card').removeClass('selected');

                $(this).closest('.month-card').addClass('selected');

            });


            $('#specialtarget_btnAssignTarget').click(function (e) {


                let tid =
                    $('#specialtarget_hdnTID').val();

                let code =
                    $('#specialtarget_ddlEmployee').val();

                let projectId =
                    $('#specialtarget_ddlProject').val();

                let processId =
                    $('#specialtarget_ddlProcess').val();

                let month =
                    $('input[name=selectedMonth]:checked').val();

                let remark =
                    $('#specialtarget_txtRemark').val();

                // VALIDATION
                if (code == '') {

                    toastr.warning('Please select employee.');
                    return;
                }

                if (projectId == '') {

                    toastr.warning('Please select project.');
                    return;
                }

                if (processId == '') {

                    toastr.warning('Please select process.');
                    return;
                }

                if (month == undefined) {

                    toastr.warning('Please select month.');
                    return;
                }

                // SHOW LOADER
                $('#specialtarget_processingModal').modal({

                    backdrop: 'static',

                    keyboard: false

                });


                $('#specialtarget_processingModal')
                    .modal('show');

                // DISABLE BUTTON
                $('#specialtarget_btnAssignTarget')
                    .prop('disabled', true);

                $.ajax({

                    type: "POST",

                    url: "ProjectConfiguration.aspx/SaveSpecialTarget",

                    data: JSON.stringify({

                        TID: tid == '' ? null : tid,

                        Code: code,

                        Month: month,

                        Remark: remark,

                        ProjectID: projectId,

                        ProcessID: processId

                    }),

                    contentType: "application/json; charset=utf-8",

                    dataType: "json",

                    success: function (response) {

                        // HIDE MODAL
                        $('#specialtarget_processingModal')
                            .modal('hide');

                        // ENABLE BUTTON
                        $('#specialtarget_btnAssignTarget')
                            .prop('disabled', false);

                        if (response.d > 0) {

                            if (tid == '') {

                                toastr.success(
                                    'Special target assigned successfully.'
                                );

                            }
                            else {

                                toastr.success(
                                    'Special target updated successfully.'
                                );

                            }

                            // RESET FORM
                            specialtarget_resetForm();

                            // RELOAD GRID
                            specialtarget_loadAssignedTargets();

                        }
                        else {

                            toastr.warning(
                                'Target already assigned.'
                            );

                        }

                    },

                    error: function () {

                        $('#specialtarget_processingModal')
                            .modal('hide');

                        $('#specialtarget_btnAssignTarget')
                            .prop('disabled', false);

                        toastr.error(
                            'Error while saving target.'
                        );

                    }

                });

            });



            $('#specialtarget_ddlEmployee').change(function () {

                let employeeId = $(this).val();

                // CLEAR DROPDOWNS
                $('#specialtarget_ddlProject').html(
                    '<option value="">Select Project</option>'
                );

                $('#specialtarget_ddlProcess').html(
                    '<option value="">Select Process</option>'
                );

                $('#specialtarget_monthContainer').html('');

                if (employeeId == '') {
                    return;
                }

                specialtarget_loadProjects(employeeId);

            });

            // $('#specialtarget_ddlProject').change(function () {
            $(document).on('change', '#specialtarget_ddlProject', function () {
                let projectId = $(this).val();
                $('#specialtarget_ddlProcess').html(
                    '<option value="">Select Process</option>'
                );

                $('#specialtarget_monthContainer').html('');

                if (projectId == '') {
                    return;
                }

                specialtarget_loadProcesses(projectId);

            });

            $(document).on('click', '.btnEditTarget', function () {

                let tid =
                    $(this).data('id');

                let code =
                    $(this).data('employeeid');


                let projectId =
                    $(this).data('projectid');

                let processId =
                    $(this).data('processid');

                let month =
                    $(this).data('month');

                let remark =
                    $(this).data('remark');

                // SET VALUES
                $('#specialtarget_hdnTID').val(tid);

                $('#specialtarget_ddlEmployee')
                    .val(code);
                specialtarget_loadProjects(code);

                setTimeout(function () {

                    $('#specialtarget_ddlProject')
                        .val(projectId);

                }, 1000);
                // LOAD PROCESS FIRST
                specialtarget_loadProcesses(projectId);

                setTimeout(function () {

                    $('#specialtarget_ddlProcess')
                        .val(processId);

                }, 1500);

                $('#specialtarget_txtRemark')
                    .val(remark);

                // SELECT MONTH
                $('input[name=selectedMonth]')
                    .prop('checked', false);

                $('.compact-month-card')
                    .removeClass('selected');

                $('input[name=selectedMonth][value="' + month + '"]')
                    .prop('checked', true)
                    .closest('.compact-month-card')
                    .addClass('selected');

                // CHANGE BUTTON TEXT
                $('#specialtarget_btnAssignTarget')
                    .html('<i class="fa fa-save"></i> Update Target');

                $('html, body').animate({

                    scrollTop: 0

                }, 300);

            });
            $(document).on('click', '.btnDeleteTarget', function () {

                if (!confirm('Delete special target?')) {
                    return;
                }

                let id = $(this).data('id');

                $.ajax({

                    type: "POST",

                    url: "ProjectConfiguration.aspx/DeleteTarget",

                    data: JSON.stringify({
                        ID: id
                    }),

                    contentType: "application/json; charset=utf-8",

                    dataType: "json",

                    success: function () {

                        toastr.success('Deleted successfully.');

                        specialtarget_loadAssignedTargets();

                    }

                });

            });


            toastr.options = {

                closeButton: true,

                progressBar: true,

                positionClass: "toast-top-right",

                timeOut: "3000"

            };
            var monthCount = 36;

            // Apply same value to all months
            $('#targetconf_applySame').click(function () {
                var val = prompt("Enter value to apply to all months:");
                if (val !== null) {
                    $('.month-input').val(val);
                }
                return false;
            });


        });
    </script>

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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;Project Configuration</h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">

                <div class="card card-tabs">
                    <div class="card-header p-0 pt-1">
                        <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Project Creation</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" onclick="return proconf_getsecondtab();" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">Process Creation</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" onclick="return proconf_getthirdtab();" id="custom-tabs-one-producttype-tab" data-toggle="pill" href="#custom-tabs-one-producttype" role="tab" aria-controls="custom-tabs-one-producttype" aria-selected="false">Product Type</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" onclick="return proconf_getforthtab();" id="custom-tabs-one-targetmatrix-tab" data-toggle="pill" href="#custom-tabs-one-targetmatrix" role="tab" aria-controls="custom-tabs-one-targetmatrix" aria-selected="false">Target Matrix</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" onclick="return proconf_getfifthtab();" id="custom-tabs-one-projectrights-tab" data-toggle="pill" href="#custom-tabs-one-projectrights" role="tab" aria-controls="custom-tabs-one-projectrights" aria-selected="false">Project Rights</a>
                            </li>
                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                                <input type="hidden" id="projectconf_projectid" value="0" />
                                <!-- =========================
     PROJECT CONFIGURATION
========================= -->

                                <div class="row g-3">

                                    <!-- Project No -->
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold">Project #</label>
                                        <input type="text"
                                            id="projectconf_projectno"
                                            name="projectconf_projectno"
                                            class="form-control" />
                                    </div>

                                    <!-- Domain -->
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold">Domain</label>
                                        <select id="projectconf_domain"
                                            name="projectconf_domain"
                                            class="form-control"
                                            onchange="return projectconf_domainchange();">
                                        </select>
                                    </div>

                                    <!-- Subdomain -->
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold">Sub Domain</label>
                                        <select id="projectconf_subdomain"
                                            name="projectconf_subdomain"
                                            class="form-control">
                                        </select>
                                    </div>

                                    <!-- Start Date -->
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold">Project Start Date</label>
                                        <input type="date"
                                            id="projectconf_startdate"
                                            name="projectconf_startdate"
                                            class="form-control" />
                                    </div>

                                    <!-- Billing Cycle -->
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold">Billing Cycle</label>
                                        <select id="projectconf_billingcycle"
                                            name="projectconf_billingcycle"
                                            class="form-control">
                                            <option value="">Select</option>
                                            <option value="Weekly">Weekly</option>
                                            <option value="Bi-Monthly">Bi-Monthly</option>
                                            <option value="Monthly">Monthly</option>
                                            <option value="DealWise">DealWise</option>
                                        </select>
                                    </div>

                                    <!-- Due Days -->
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold">Due Days</label>
                                        <input type="number"
                                            id="projectconf_duedays"
                                            name="projectconf_duedays"
                                            class="form-control" />
                                    </div>

                                    <!-- Client Process -->
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold">Client Process Name</label>
                                        <input type="text"
                                            id="projectconf_clientprocessname"
                                            name="projectconf_clientprocessname"
                                            class="form-control" />
                                    </div>

                                    <!-- Project Type -->
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold">Project Type</label>
                                        <select id="projectconf_projecttype"
                                            name="projectconf_projecttype"
                                            class="form-control">
                                            <option value="">Select</option>
                                            <option value="OnShore">OnShore</option>
                                            <option value="OffShore">OffShore</option>
                                        </select>
                                    </div>

                                    <!-- Project Status -->
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold">Project Status</label>
                                        <select id="projectconf_projectstatus"
                                            name="projectconf_projectstatus"
                                            class="form-control">
                                            <option value="">Select</option>
                                            <option value="Active">Active</option>
                                            <option value="Stopped">Stopped</option>
                                            <option value="On Hold">On Hold</option>
                                        </select>
                                    </div>

                                    <!-- Type -->
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold">Type</label>
                                        <select id="projectconf_type"
                                            name="projectconf_type"
                                            class="form-control">
                                            <option value="">Select</option>
                                            <option value="Live">Live</option>
                                            <option value="Demo">Demo</option>
                                            <option value="Test">Test</option>
                                            <option value="Practice">Practice</option>
                                            <option value="Training">Training</option>
                                        </select>
                                    </div>

                                    <!-- Remark -->
                                    <div class="col-md-8">
                                        <label class="form-label fw-bold">Remark</label>
                                        <textarea id="projectconf_remark"
                                            name="projectconf_remark"
                                            class="form-control"
                                            rows="2"></textarea>
                                    </div>

                                </div>

                                <!-- Buttons -->
                                <div class="text-end mt-4">
                                    <button id="projectconf_btnsubmit"
                                        name="projectconf_btnsubmit"
                                        class="btn btn-primary px-4"
                                        onclick="return projectconf_submit();">
                                        <i class="fa fa-save"></i>&nbsp;Add Project
                                    </button>
                                </div>


                                <!-- =========================
     PROJECT LIST
========================= -->

                                <div class="card shadow-sm border-0 mt-4">

                                    <div class="card-body">

                                        <div class="table-responsive">

                                            <table id="projectconf_projectslist"
                                                class="table table-bordered table-hover align-middle nowrap w-100">

                                                <thead class="table-light">
                                                    <tr>
                                                        <th>Edit</th>
                                                        <th style="display: none;">Id</th>
                                                        <th>Project</th>
                                                        <th>Domain</th>
                                                        <th>Subdomain</th>
                                                        <th>Client Process</th>
                                                        <th>Start Date</th>
                                                        <th>Billing Cycle</th>
                                                        <th>Due Days</th>
                                                        <th>Project Type</th>
                                                        <th>Type</th>
                                                        <th>Remark</th>
                                                        <th>Project Status</th>
                                                        <th>Stop Date</th>
                                                        <th>Reason</th>
                                                        <th>Added By</th>
                                                        <th>Added Date</th>
                                                        <th style="display: none;">SubdomainID</th>
                                                        <th style="display: none;">DomainID</th>
                                                    </tr>
                                                </thead>

                                                <tbody>
                                                </tbody>

                                            </table>

                                        </div>

                                    </div>

                                </div>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                                <input type="hidden" id="processconf_processid" value="0" />
                                <!-- =========================
     PROCESS CONFIGURATION
========================= -->


                                <div class="row g-3 align-items-end">

                                    <!-- Project -->
                                    <div class="col-md-5">
                                        <label class="form-label fw-bold">Project #</label>
                                        <select id="processconf_project"
                                            name="processconf_project"
                                            class="form-control">
                                        </select>
                                    </div>

                                    <!-- Process Name -->
                                    <div class="col-md-5">
                                        <label class="form-label fw-bold">Process Name</label>
                                        <input type="text"
                                            id="processconf_processname"
                                            name="processconf_processname"
                                            class="form-control" />
                                    </div>

                                    <!-- Button -->
                                    <div class="col-md-2 d-grid">
                                        <button id="processconf_btnsubmit"
                                            name="processconf_btnsubmit"
                                            class="btn btn-primary"
                                            onclick="return processconf_submit();">
                                            <i class="fa fa-save"></i>Add
                                        </button>
                                    </div>

                                </div>


                                <div class="card shadow-sm border-0 mt-4">


                                    <div class="card-body">

                                        <div class="table-responsive">

                                            <table id="projectconf_processlist"
                                                class="table table-bordered table-hover align-middle nowrap w-100">

                                                <thead class="table-light">
                                                    <tr>
                                                        <th>Edit</th>
                                                        <th style="display: none;">ProcessID</th>
                                                        <th>Project</th>
                                                        <th>Process</th>
                                                        <th>Added By</th>
                                                        <th>Added Date</th>
                                                    </tr>
                                                </thead>

                                                <tbody>
                                                </tbody>

                                            </table>

                                        </div>

                                    </div>

                                </div>



                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-producttype" role="tabpanel" aria-labelledby="custom-tabs-one-producttype-tab">
                                <input type="hidden" id="productconf_productid" value="0" />
                                <!-- =========================
     PRODUCT CONFIGURATION
========================= -->

                                

                                        <div class="row g-3 align-items-end">

                                            <!-- Project -->
                                            <div class="col-md-4">
                                                <label class="form-label fw-bold">Project #</label>
                                                <select id="productconf_project"
                                                    name="productconf_project"
                                                    class="form-control"
                                                    onchange="return productconf_bindprocess();">
                                                </select>
                                            </div>

                                            <!-- Process -->
                                            <div class="col-md-4">
                                                <label class="form-label fw-bold">Process</label>
                                                <select id="productconf_process"
                                                    name="productconf_process"
                                                    class="form-control">
                                                </select>
                                            </div>

                                            <!-- Product Type -->
                                            <div class="col-md-3">
                                                <label class="form-label fw-bold">Product Type</label>
                                                <input type="text"
                                                    id="productconf_producttype"
                                                    name="productconf_producttype"
                                                    class="form-control" />
                                            </div>

                                            <!-- Button -->
                                            <div class="col-md-1 d-grid">
                                                <button id="productconf_btnsubmit"
                                                    name="productconf_btnsubmit"
                                                    class="btn btn-primary"
                                                    onclick="return productconf_submit();">
                                                    <i class="fa fa-save"></i>Add
                                                </button>
                                            </div>

                                        </div>


                                <!-- =========================
     PRODUCT LIST
========================= -->

                                <div class="card shadow-sm border-0 mt-4">

                                    <div class="card-body">

                                        <div class="table-responsive">

                                            <table id="productconf_list"
                                                class="table table-bordered table-hover align-middle nowrap w-100">

                                                <thead class="table-light">
                                                    <tr>
                                                        <th>Edit</th>
                                                        <th>Sr#</th>
                                                        <th>Project</th>
                                                        <th>Process</th>
                                                        <th>Product Type</th>
                                                        <th>Added By</th>
                                                        <th>Added Date</th>
                                                    </tr>
                                                </thead>

                                                <tbody>
                                                </tbody>

                                            </table>

                                        </div>

                                    </div>

                                </div>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-targetmatrix" role="tabpanel" aria-labelledby="custom-tabs-one-targetmatrix-tab">
                                <table id="targetconf_list" class="display table table-bordered">
                                    <thead>
                                        <tr>
                                            <th>Sr#</th>
                                            <th>Project</th>
                                            <th>Process</th>
                                            <th>Product Type</th>
                                            <th>Monthly Targets</th>
                                        </tr>
                                        <tr class="filters">
                                            <th></th>
                                            <th>Project</th>
                                            <th>Process</th>
                                            <th>Product Type</th>
                                            <th></th>
                                        </tr>
                                    </thead>

                                    <tbody>
                                    </tbody>
                                </table>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-projectrights" role="tabpanel" aria-labelledby="custom-tabs-one-projectrights-tab">
                                <div>

                                    <div>
                                        <!-- Tabs -->
                                        <ul class="nav nav-tabs mb-4" id="rightsTabs" role="tablist">

                                            <!-- TAB 1 -->
                                            <li class="nav-item" role="presentation">

                                                <a class="nav-link active"
                                                    id="projectrights-tab"
                                                    data-toggle="tab"
                                                    href="#projectrightsTab"
                                                    role="tab">

                                                    <i class="fa fa-user-shield"></i>
                                                    Project Rights

        </a>

                                            </li>

                                            <!-- TAB 2 -->
                                            <li class="nav-item" role="presentation">

                                                <a class="nav-link"
                                                    id="specialtarget-tab"
                                                    data-toggle="tab"
                                                    href="#specialTargetTab"
                                                    role="tab">

                                                    <i class="fa fa-bullseye"></i>
                                                    Assign Special Target
                                                    </a>


                                            </li>

                                        </ul>
                                        <div class="tab-content">

                                            <!-- ================================= -->
                                            <!-- TAB 1 : PROJECT RIGHTS -->
                                            <!-- ================================= -->

                                            <div class="tab-pane fade show active"
                                                id="projectrightsTab"
                                                role="tabpanel">

                                                <!-- PROJECT RIGHTS DESIGN HERE -->

                                                <div class="search-panel mb-4">
                                                    <!-- Search Panel -->
                                                    <div class="search-panel mb-4">

                                                        <div class="row align-items-end">

                                                            <div class="col-lg-5">
                                                                <label class="form-label fw-semibold">
                                                                    Select User
                       
                                                                </label>

                                                                <select class="form-control" id="projectrights_ddlUser">
                                                                    <option value="">-- Select Employee --</option>
                                                                </select>
                                                            </div>

                                                            <div class="col-lg-2">
                                                                <button type="button" class="btn btn-primary-custom w-100" id="projectrights_btnLoad" style="color: white!important;">
                                                                    <i class="fa fa-search"></i>&nbsp;Load Rights
                       
                                                                </button>
                                                            </div>

                                                        </div>

                                                    </div>

                                                    <!-- Grid Section -->
                                                    <div class="table-section" id="projectrights_rightsSection">

                                                        <!-- Action Bar -->
                                                        <div class="action-bar mb-3 d-flex justify-content-between align-items-center">

                                                            <div>
                                                                <h6 class="mb-0 fw-bold">Assigned Projects
</h6>
                                                            </div>

                                                            <div class="d-flex gap-2">

                                                                <%--    <button class="btn btn-outline-secondary">
                                <i class="fa fa-check-square"></i>Select All
                       
                            </button>--%>

                                                                <button type="button" class="btn btn-success-custom" id="projectrights_btnSaveRights">
                                                                    <i class="fa fa-save"></i>&nbsp;Save Rights
                       
                                                                </button>

                                                            </div>

                                                        </div>

                                                        <!-- DataTable -->
                                                        <table id="projectrights_tblProjectRights" class="table table-bordered table-hover align-middle">
                                                            <thead>
                                                                <tr>
                                                                    <th width="50">
                                                                        <input type="checkbox" id="projectrights_chkAll" />
                                                                    </th>
                                                                    <th>Sr. No.</th>
                                                                    <th>Project Name</th>
                                                                    <th>Domain</th>
                                                                    <th>Status</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                            </tbody>

                                                        </table>

                                                    </div>



                                                </div>

                                            </div>


                                            <!-- ================================= -->
                                            <!-- TAB 2 : SPECIAL TARGET -->
                                            <!-- ================================= -->

                                            <div class="tab-pane fade"
                                                id="specialTargetTab"
                                                role="tabpanel">

                                                <div class="card-body p-4">


                                                    <!-- FILTER SECTION -->
                                                    <div class="row g-3">

                                                        <!-- EMPLOYEE -->
                                                        <div class="col-lg-3">
                                                            <input type="hidden" id="specialtarget_hdnTID" value="" />
                                                            <label class="form-label fw-semibold">
                                                                Employee
                       
                                                            </label>

                                                            <select class="form-control" id="specialtarget_ddlEmployee">

                                                                <option value="">Select Employee
                            </option>

                                                            </select>

                                                        </div>

                                                        <!-- PROJECT -->
                                                        <div class="col-lg-3">

                                                            <label class="form-label fw-semibold">
                                                                Project
                       
                                                            </label>

                                                            <select class="form-control" id="specialtarget_ddlProject">

                                                                <option value="">Select Project
                            </option>

                                                            </select>

                                                        </div>

                                                        <!-- PROCESS -->
                                                        <div class="col-lg-3">

                                                            <label class="form-label fw-semibold">
                                                                Process
                       
                                                            </label>

                                                            <select class="form-control" id="specialtarget_ddlProcess">

                                                                <option value="">Select Process
                            </option>

                                                            </select>

                                                        </div>

                                                        <!-- BUTTON -->
                                                        <div class="col-lg-3 d-flex align-items-end">

                                                            <button type="button"
                                                                class="btn btn-primary-custom w-100"
                                                                id="specialtarget_btnLoadTargets" style="color: white!important;">

                                                                <i class="fa fa-search"></i>
                                                                Load Targets

                       
                                                            </button>

                                                        </div>

                                                    </div>

                                                    <!-- MONTH TARGETS -->
                                                    <div class="mt-5">

                                                        <div class="d-flex justify-content-between align-items-center mb-3">

                                                            <div>

                                                                <h5 class="fw-bold mb-0">Select Month
                            </h5>

                                                                <small class="text-muted">Choose one month for special assignment
                            </small>

                                                            </div>

                                                        </div>

                                                        <!-- DYNAMIC MONTHS -->
                                                        <div class="row g-2" id="specialtarget_monthContainer">
                                                        </div>

                                                    </div>

                                                    <!-- REMARK -->
                                                    <div class="row mt-4">

                                                        <div class="col-lg-8">

                                                            <label class="form-label fw-semibold">
                                                                Remark
                       
                                                            </label>

                                                            <textarea class="form-control"
                                                                rows="3"
                                                                id="specialtarget_txtRemark"
                                                                placeholder="Enter reason for special target assignment"></textarea>

                                                        </div>

                                                    </div>

                                                    <!-- SAVE BUTTON -->
                                                    <div class="mt-4">

                                                        <button type="button"
                                                            class="btn btn-success-custom"
                                                            id="specialtarget_btnAssignTarget">

                                                            <i class="fa fa-save"></i>
                                                            Assign Special Target

                   
                                                        </button>

                                                    </div>
                                                    <div class="mt-5">

                                                        <div class="d-flex justify-content-between align-items-center mb-3">

                                                            <h5 class="fw-bold mb-0">Assigned Special Targets
                                                            </h5>

                                                        </div>

                                                        <table id="specialtarget_tblTargets"
                                                            class="table table-bordered table-hover w-100">

                                                            <thead>

                                                                <tr>

                                                                    <th>Employee</th>

                                                                    <th>Project</th>

                                                                    <th>Process</th>

                                                                    <th>Month</th>

                                                                    <th>Remark</th>

                                                                    <th>Added By</th>

                                                                    <th>Added Date</th>

                                                                    <th width="70">Edit</th>

                                                                    <th width="70">Delete</th>

                                                                </tr>

                                                            </thead>

                                                            <tbody>
                                                            </tbody>

                                                        </table>

                                                    </div>
                                                </div>

                                                <!-- PROCESSING MODAL -->
                                                <div class="modal fade"
                                                    id="specialtarget_processingModal"
                                                    data-bs-backdrop="static"
                                                    data-bs-keyboard="false"
                                                    tabindex="-1">

                                                    <div class="modal-dialog modal-dialog-centered">

                                                        <div class="modal-content border-0 shadow-lg">

                                                            <div class="modal-body text-center p-5">

                                                                <div class="spinner-border text-primary"
                                                                    style="width: 4rem; height: 4rem;">
                                                                </div>

                                                                <h4 class="fw-bold mt-4">Saving...
                    </h4>

                                                                <div class="text-muted">
                                                                    Please wait while special target is assigned.
                   
                                                                </div>

                                                            </div>

                                                        </div>

                                                    </div>

                                                </div>

                                            </div>

                                        </div>


                                    </div>

                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="targetsModal" class="modal fade" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="targetsModalTitle">Edit Monthly Targets</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body">

                    <div class="container-fluid">
                        <div class="row" id="monthInputs"></div>
                    </div>

                </div>
                <div class="modal-footer">
                    <button id="targetconf_applySame" class="btn btn-secondary btn-sm">Apply Same Value</button>
                    <button id="targetconf_saveTargets" class="btn btn-success btn-sm">Save</button>
                    <button class="btn btn-light btn-sm" data-dismiss="modal">Cancel</button>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="projectconf_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="projectconf_errmsg"></h6>
                </div>
                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="projectconf_btnMessage" onclick="location.reload();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
    <!-- PROCESSING MODAL -->
    <div class="modal fade"
        id="projectrights_processingModal"
        data-backdrop="static"
        data-keyboard="false"
        tabindex="-1" role="dialog">

        <div class="modal-dialog modal-dialog-centered">

            <div class="modal-content border-0 shadow-lg">

                <div class="modal-body text-center p-5">

                    <!-- LOADER -->
                    <div class="mb-4">

                        <div class="spinner-border text-primary"
                            style="width: 4rem; height: 4rem;"
                            role="status">
                        </div>

                    </div>

                    <!-- TITLE -->
                    <h4 class="fw-bold mb-2">Saving Rights...
                    </h4>

                    <!-- MESSAGE -->
                    <div class="text-muted">
                        Please wait while system updates project rights.
                    </div>

                </div>

            </div>

        </div>

    </div>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" />
</asp:Content>
