<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AddressVerification.aspx.cs" Inherits="WebPortal.Admin.AddressVerification" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <%--    <style>
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

        .dataTables_length, .dataTables_info {
            float: left !important;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: normal !important;
            border: none !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 50px;
            float: left;
        }

        .buttons-excel, .buttons-html5 {
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
            background: linear-gradient(to bottom, #007bff, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
        }
        /*.form-control {
            font-size: 11px !important;
        }*/
    </style>--%>

    <script>
        window.onload = function () {
            document.getElementById('attachment').addEventListener('change', getFileName);
        }
        $(document).ready(function () {
            BindYear();
        });
    </script>

    <style>
        :root {
            --av-primary: #4f46e5;
            --av-primary-dark: #4338ca;
            --av-accent: #06b6d4;
            --av-success: #16a34a;
            --av-text: #0f172a;
            --av-muted: #64748b;
            --av-border: #dbe3ee;
            --av-soft-border: #eef2f7;
            --av-surface: #ffffff;
            --av-bg: #f8fafc;
            --av-radius: 18px;
            --av-shadow: 0 18px 45px rgba(15,23,42,.08);
            --av-soft-shadow: 0 8px 22px rgba(15,23,42,.06);
        }

        body,
        .content-wrapper {
            background: radial-gradient(circle at top left, rgba(79,70,229,.10), transparent 34rem), linear-gradient(180deg,#f8fafc 0%,#eef2ff 100%) !important;
            color: var(--av-text);
        }

        .av-page-header .container,
        .content-header .container {
            max-width: 100% !important;
        }

        .content-header .callout {
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            border-radius: 15px;
            padding: 12px;
            color: white;
            position: relative;
            overflow: hidden;
            margin-bottom: 25px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        }

            .content-header .callout:before {
                content: "";
                position: absolute;
                width: 140px;
                height: 140px;
                right: -50px;
                top: -65px;
                background: rgba(79,70,229,.16);
                border-radius: 999px;
            }

        .content-header h6 {
            color: var(--av-text);
            font-size: 20px;
            letter-spacing: -.02em;
        }

            .content-header h6 i {
                width: 40px;
                height: 40px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                border-radius: 14px;
                color: #fff;
                background: linear-gradient(135deg,var(--av-primary),#7c3aed);
                box-shadow: 0 10px 18px rgba(79,70,229,.25);
            }

        .av-main-wrap {
            padding: 0 16px 24px !important;
        }

        .card.av-panel,
        .card {
            border: 1px solid rgba(226,232,240,.9) !important;
            border-radius: 24px !important;
            box-shadow: var(--av-shadow) !important;
            overflow: hidden;
            background: rgba(255,255,255,.95) !important;
            backdrop-filter: blur(10px);
        }

        .card-body {
            padding: 26px !important;
        }

        .av-filter-table {
            margin-bottom: 6px !important;
            border-collapse: separate !important;
            border-spacing: 0 10px !important;
            background: linear-gradient(135deg,#f8fafc,#ffffff) !important;
            border: 1px solid var(--av-soft-border);
            border-radius: 20px;
            padding: 14px !important;
            box-shadow: inset 0 1px 0 rgba(255,255,255,.65);
        }

            .av-filter-table td {
                border-top: 0 !important;
                padding: 8px 10px !important;
                color: var(--av-muted);
                font-size: 13px;
                white-space: nowrap;
            }

            .av-filter-table b,
            .av-modal-form b {
                color: var(--av-text);
                font-weight: 700;
            }

        .form-control,
        select.form-control,
        input.form-control,
        textarea.form-control,
        label.form-control,
        .dropdown-toggle.form-control {
            min-height: 44px;
            border: 1px solid var(--av-border) !important;
            border-radius: 13px !important;
            background-color: #fff !important;
            color: var(--av-text) !important;
            box-shadow: 0 1px 2px rgba(15,23,42,.03) !important;
            transition: border-color .2s ease, box-shadow .2s ease, transform .2s ease;
            outline: none !important;
        }

        textarea.form-control {
            min-height: 86px;
            resize: vertical;
        }

            .form-control:focus,
            select.form-control:focus,
            input.form-control:focus,
            textarea.form-control:focus {
                border-color: var(--av-primary) !important;
                box-shadow: 0 0 0 4px rgba(79,70,229,.14) !important;
            }

        label.form-control {
            display: flex;
            align-items: center;
            background: #f8fafc !important;
            color: #334155 !important;
        }

        .btn {
            border-radius: 12px !important;
            font-weight: 700 !important;
            letter-spacing: .01em;
            transition: transform .2s ease, box-shadow .2s ease, background .2s ease !important;
        }

            .btn:hover {
                transform: translateY(-1px);
            }

        .btn-primary,
        .buttons-excel,
        .buttons-html5 {
            color: #fff !important;
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            border: 0 !important;
            box-shadow: 0 12px 22px rgba(79,70,229,.22) !important;
            padding: 10px 20px !important;
        }

        .btn-default {
            background: #f1f5f9 !important;
            border: 1px solid #e2e8f0 !important;
            color: #334155 !important;
            padding: 10px 18px !important;
        }

        hr {
            border: 0 !important;
            height: 1px;
            background: linear-gradient(90deg,transparent,#e2e8f0,transparent);
            margin: 24px 0 !important;
        }

        .av-section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 6px 0 12px;
        }

            .av-section-title h6 {
                margin: 0;
                color: var(--av-text);
                font-size: 16px;
                font-weight: 800;
                text-decoration: none !important;
            }

        .av-title-dot {
            width: 10px;
            height: 10px;
            border-radius: 999px;
            background: linear-gradient(135deg,var(--av-accent),var(--av-primary));
            box-shadow: 0 0 0 6px rgba(6,182,212,.10);
        }

        .table {
            width: 100% !important;
            border-collapse: separate !important;
            border-spacing: 0 !important;
            background: #fff !important;
            border: 1px solid var(--av-soft-border);
            border-radius: 18px !important;
            overflow: hidden;
            box-shadow: 0 8px 18px rgba(15,23,42,.04);
        }

            .table.dataTable thead th,
            .table thead th {
                background: #f8fafc !important;
                color: #334155 !important;
                font-size: 12px !important;
                text-transform: uppercase;
                letter-spacing: .04em;
                border-bottom: 1px solid #e2e8f0 !important;
                padding: 13px 14px !important;
            }

            .table td,
            .table th {
                vertical-align: middle !important;
                border-top: 1px solid #f1f5f9 !important;
                padding: 12px 14px !important;
            }

            .table.dataTable tr td,
            .table tbody td {
                background: #fff !important;
                color: #334155;
            }

            .table tbody tr:hover td {
                background: #f8fafc !important;
            }

        .dataTables_wrapper .dataTables_filter input,
        .dataTables_wrapper .dataTables_length select {
            border: 1px solid var(--av-border) !important;
            border-radius: 12px !important;
            padding: 7px 12px !important;
            outline: none !important;
        }

        div.dt-buttons {
            padding-left: 16px !important;
        }

        .dataTables_info,
        .dataTables_length,
        .dataTables_filter,
        .dataTables_paginate {
            color: var(--av-muted) !important;
            font-size: 13px;
        }

        .modal-content.av-modal-content,
        .modal-content {
            border: 0 !important;
            border-radius: 24px !important;
            box-shadow: 0 24px 70px rgba(15,23,42,.20) !important;
            overflow: hidden;
        }

        .modal-header {
            background: linear-gradient(135deg,#f8fafc,#eef2ff) !important;
            border-bottom: 1px solid #e2e8f0 !important;
            padding: 18px 24px !important;
        }

        .modal-title {
            color: var(--av-text);
            font-size: 20px;
            font-weight: 800;
        }

        .modal-body {
            padding: 24px !important;
        }

        .modal-footer {
            background: #f8fafc;
            border-top: 1px solid #e2e8f0 !important;
            padding: 16px 24px !important;
        }

        .av-modal-form {
            box-shadow: none !important;
            border: 0 !important;
        }

            .av-modal-form td {
                border-top: 0 !important;
                padding: 10px !important;
            }

        .dropzone {
            border: 1px dashed #cbd5e1 !important;
            border-radius: 16px !important;
            background: #f8fafc !important;
            margin-top: 10px;
            padding: 10px !important;
        }

        .loading {
            background: rgba(255,255,255,.9) !important;
            box-shadow: 0 20px 45px rgba(15,23,42,.15);
            display: none;
            align-items: center;
            justify-content: center;
            text-align: center;
        }

        @media (max-width: 768px) {
            .card-body {
                padding: 16px !important;
            }

            .av-filter-table,
            .av-filter-table tbody,
            .av-filter-table tr,
            .av-filter-table td,
            .av-modal-form,
            .av-modal-form tbody,
            .av-modal-form tr,
            .av-modal-form td {
                display: block !important;
                width: 100% !important;
            }

                .av-filter-table td,
                .av-modal-form td {
                    padding: 6px 0 !important;
                }

                .form-control,
                .av-modal-form .form-control,
                input[style*="width: 300px"],
                label[style*="width: 300px"],
                textarea[style*="width: 300px"] {
                    width: 100% !important;
                }

            div.dt-buttons {
                padding-left: 0 !important;
                margin-top: 10px;
            }

            .content-header h6 {
                font-size: 18px;
            }
        }
    </style>

    <style>
        body {
            background: #f4f7fb;
        }

        .dashboard-header {
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            border-radius: 15px;
            padding: 12px;
            color: white;
            position: relative;
            overflow: hidden;
            margin-bottom: 25px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        }

            .dashboard-header::after {
                content: '';
                position: absolute;
                right: -70px;
                top: -50px;
                width: 220px;
                height: 220px;
                background: rgba(255,255,255,0.12);
                border-radius: 50%;
            }

        .dashboard-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .dashboard-subtitle {
            font-size: 12px;
            opacity: 0.9;
            /*text-transform: uppercase;*/
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="filep" style="display: none;" />

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="dashboard-header">
        <div class="d-flex justify-content-between align-items-start mb-1">
            <div>
                <div class="dashboard-title">
                    <i class="fas fa-map-marker-alt mr-2"></i>
                    Address Verification
                </div>

                <div class="dashboard-subtitle">
                    Verify and manage employee residential and permanent address details to ensure accurate records and compliance.
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-12 av-main-wrap">
        <div class="card av-panel">
            <div class="card-body">
                <div class="row g-3 align-items-end">

                    <div class="col-md-4">
                        <label for="AV_month" class="form-label fw-bold">Month</label>
                        <select id="AV_month" name="AV_month" class="form-control">
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

                    <div class="col-md-4">
                        <label for="AV_year" class="form-label fw-bold">Year</label>
                        <select id="AV_year" name="AV_year" class="form-control">
                            <option value="">Select</option>
                        </select>
                    </div>

                    <div class="col-md-2">
                        <button id="btnShow"
                            type="button"
                            class="btn btn-primary w-100"
                            onclick="return AddressVerification_Submit();">
                            Show
                        </button>
                    </div>

                </div>
                <hr />
                <div class="av-section-title">
                    <span class="av-title-dot"></span>
                    <h6>Summary</h6>
                </div>
                <br />
                <table class="table" id="table_addVefSummary" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Total</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Completed</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Pending</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
                <hr />
                <div class="av-section-title">
                    <span class="av-title-dot"></span>
                    <h6>Detail</h6>
                </div>
                <br />
                <table class="table" id="addressVerification" style="padding-top: 10px; width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="display: none;">Verification ID</th>
                            <th class="sort border-top ps-3" style="display: none;">Employee ID</th>
                            <th class="sort border-top ps-3">Actions</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Employee Name</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Joining Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Contact #</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Permanent Address</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Address Verification Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Courier Receipt IVR No. For POD</th>
                            <th class="sort border-top ps-3">Remark</th>
                            <th class="sort border-top ps-3" style="display: none;">Attachment</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="updatedetails">
        <div class="modal-dialog modal-xl">
            <div class="modal-content av-modal-content">
                <div class="modal-header">
                    <h4 class="modal-title"><span id="spn_updatedetailsName"></span></h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="row g-4">
                        <!-- Verification Date -->
                        <div class="col-md-6">
                            <label for="AV_verificationdate" class="form-label fw-bold">Address Verification Date</label>
                            <input type="date" id="AV_verificationdate" name="AV_verificationdate" class="form-control" />
                        </div>

                        <!-- Courier Receipt -->
                        <div class="col-md-6">
                            <label for="AV_courier1" class="form-label fw-bold">
                                Courier Receipt / IVR No. for POD
                            </label>
                            <input type="text" id="AV_courier1" name="AV_courier1" class="form-control" placeholder="Enter Courier Receipt / IVR Number" />
                        </div>

                        <!-- Remark -->
                        <div class="col-md-6">
                            <label for="AV_remark1" class="form-label fw-bold">Remark</label>
                            <textarea id="AV_remark1" name="AV_remark1" rows="3" class="form-control" placeholder="Enter remark"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <%--<button type="button" class="btn btn-secondary"data-dismiss="modal">Close</button>--%>
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" id="btnAVUpdateRemark" onclick="return AV_UpdateRemark();"><i class="fas fa-save me-1"></i>Update Details</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="uploaddocument">
        <div class="modal-dialog modal-xl">
            <div class="modal-content av-modal-content">
                <div class="modal-header">
                    <h4 class="modal-title"><span id="spn_updatedetailsdocs"></span></h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label for="AV_verificationdate2" class="form-label fw-bold">Address Verification Date</label>
                            <input type="date" id="AV_verificationdate2" name="AV_verificationdate2" class="form-control" />
                        </div>
                        <div class="col-md-4">
                            <label for="AV_courier2" class="form-label fw-bold">Courier Receipt / IVR No. For POD</label>
                            <input type="text" id="AV_courier2" name="AV_courier2" class="form-control" />
                        </div>
                        <div class="col-md-4">
                            <label for="attachment" class="form-label fw-bold">Attachment</label>
                            <input type="file" id="attachment" name="attachment" class="form-control" />
                            <%-- <div class="dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete mt-2"id="dropzone">
                                <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column"
                                    id="conentdiv"
                                    style="display: none !important;">

                                    <div class="flex-1 d-flex flex-between-center">

                                        <div id="filesdiv"
                                            style="margin-top: 10px; margin-bottom: 10px;">
                                        </div>

                                        <div class="dropdown font-sans-serif">
                                            <button class="btn btn-link text-600 btn-sm dropdown-toggle btn-reveal dropdown-caret-none"
                                                type="button"
                                                data-bs-toggle="dropdown">
                                                <span class="fas fa-ellipsis-h"></span>
                                            </button>

                                            <div class="dropdown-menu dropdown-menu-end border py-2">
                                                <a class="dropdown-item"
                                                    href="#!"
                                                    data-dz-remove="data-dz-remove">Remove File
                                                </a>
                                            </div>
                                        </div>

                                    </div>
                                </div>

                            </div>--%>
                        </div>

                    </div>
                    <div class="row mt-3">
                        <div class="col-md-12">
                            <label for="AV_remark2" class="form-label fw-bold">Remark</label>
                            <textarea id="AV_remark2" name="AV_remark2" rows="4" class="form-control" placeholder="Enter remark..."></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button class="btn btn-primary" type="button" id="btnAVuploaddocument" onclick="return AV_uploaddocument();">Update Details</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
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

        .dataTables_length, .dataTables_info {
            float: left !important;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: normal !important;
            border: none !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 50px;
            float: left;
        }

        .buttons-excel, .buttons-html5 {
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
            background: linear-gradient(to bottom, #007bff, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
        }
        /*.form-control {
            font-size: 11px !important;
        }*/
    </style>

    <script>
        window.onload = function () {
            document.getElementById('attachment').addEventListener('change', getFileName);
        }
        $(document).ready(function () {
            BindYear();
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Address Verification</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <h5 class="card-title"></h5>
                <table class="table">
                    <tr>
                        <td style="width: 50px;"><b>Month:</b></td>
                        <td style="width: 150px;">
                            <select id="AV_month" name="AV_month" class="form-control">
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
                        </td>
                        <td style="width: 50px;">
                            <b>Year:</b>
                        </td>
                        <td style="width: 150px;">
                            <select id="AV_year" name="AV_year" class="form-control">
                                <option value="">Select</option>
                            </select>
                        </td>
                        <td style="width: 100px;">
                            <button id="btnShow" class="btn btn-primary" onclick="return AddressVerification_Submit()">Show</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <h6 style="text-decoration: underline;">Summary</h6>
                <br />
                <table class="table" id="table_addVefSummary" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align:center;">Sr. #</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align:center;">Total</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align:center;">Completed</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align:center;">Pending</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
                <hr />
                <h6 style="text-decoration: underline;">Detail</h6>
                <br />
                <table class="table" id="addressVerification" style="padding-top: 10px; width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="display: none;">Verification ID</th>
                            <th class="sort border-top ps-3" style="display: none;">Employee ID</th>
                            <th class="sort border-top ps-3">Actions</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Employee Name</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Joining Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Contact #</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Permanent Address</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Address Verification Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Courier Receipt IVR No. For POD</th>
                            <th class="sort border-top ps-3">Remark</th>
                            <th class="sort border-top ps-3" style="display: none;">Attachment</th>
                        </tr>

                    </thead>
                    <tbody></tbody>

                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="updatedetails">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Update Courier Details</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table">
                        <tr>
                            <td><b>Employee:</b></td>
                            <td>
                                <label id="AV_empname" class="form-control" style="width: 300px;"></label>
                            </td>
                            <td><b>Address Verification Date:</b></td>
                            <td>
                                <input type="date" id="AV_verificationdate" name="AV_verificationdate" class="form-control" style="width: 300px;" />
                            </td>
                        </tr>
                        <tr>
                            <td><b>Courier Receipt IVR No. For POD:</b></td>
                            <td>
                                <input type="text" id="AV_courier1" name="AV_courier1" class="form-control" style="width: 300px;" />
                            </td>
                            <td><b>Remark:</b></td>
                            <td>
                                <textarea type="date" id="AV_remark1" name="AV_remark1" class="form-control" style="width: 300px;"></textarea>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button class="btn btn-primary" type="button" id="btnAVUpdateRemark" onclick="return AV_UpdateRemark();">Update Remark</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
    <input id="filep" style="display: none;" />
    <div class="modal fade" id="uploaddocument">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Update Courier Details</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">

                    <table class="table">
                        <tr>
                            <td><b>Employee:</b></td>
                            <td>
                                <label id="AV_empname2" class="form-control" style="width: 300px;"></label>
                            </td>
                            <td><b>Address Verification Date:</b></td>
                            <td>
                                <input type="date" id="AV_verificationdate2" name="AV_verificationdate2" class="form-control" style="width: 300px;" />
                            </td>
                        </tr>
                        <tr>
                            <td><b>Courier Receipt IVR No. For POD:</b></td>
                            <td>
                                <input type="text" id="AV_courier2" name="AV_courier2" class="form-control" style="width: 300px;" />
                            </td>
                            <td><b>Remark:</b></td>
                            <td>
                                <textarea type="date" id="AV_remark2" name="AV_remark2" class="form-control" style="width: 300px;"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Attachment:</b></td>
                            <td>
                                <input type="file" id="attachment" name="attachment" class="form-control" style="width: 300px;" />
                                <div class="dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete" id="dropzone">
                                    <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column" id="conentdiv" style="display: none!important;">
                                        <div class="flex-1 d-flex flex-between-center">
                                            <div id="filesdiv" style="margin-top: 10px; margin-bottom: 10px;"></div>
                                            <div class="dropdown font-sans-serif">
                                                <button class="btn btn-link text-600 btn-sm dropdown-toggle btn-reveal dropdown-caret-none" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                    <svg class="svg-inline--fa fa-ellipsis" style="display: none!important" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="ellipsis" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg="">
                                                        <path fill="currentColor" d="M120 256C120 286.9 94.93 312 64 312C33.07 312 8 286.9 8 256C8 225.1 33.07 200 64 200C94.93 200 120 225.1 120 256zM280 256C280 286.9 254.9 312 224 312C193.1 312 168 286.9 168 256C168 225.1 193.1 200 224 200C254.9 200 280 225.1 280 256zM328 256C328 225.1 353.1 200 384 200C414.9 200 440 225.1 440 256C440 286.9 414.9 312 384 312C353.1 312 328 286.9 328 256z"></path></svg><!-- <span class="fas fa-ellipsis-h"></span> Font Awesome fontawesome.com --></button>
                                                <div class="dropdown-menu dropdown-menu-end border py-2"><a class="dropdown-item" href="#!" data-dz-remove="data-dz-remove">Remove File</a></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                    </table>



                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button class="btn btn-primary" type="button" id="btnAVuploaddocument" onclick="return AV_uploaddocument();">Update Details</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>--%>
