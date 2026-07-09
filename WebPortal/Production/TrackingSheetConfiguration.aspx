<%@ Page Title="" Language="C#" MasterPageFile="~/Production/Production.Master" AutoEventWireup="true" CodeBehind="TrackingSheetConfiguration.aspx.cs" Inherits="WebPortal.Production.TrackingSheetConfiguration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .ts-config-page {
            min-height: calc(100vh - 120px);
            padding: 18px 0 28px;
            color: #172033;
        }

        .ts-config-hero {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            margin-bottom: 14px;
            padding: 16px 18px;
            border: 1px solid #cad8e6;
            border-left: 5px solid #0f6b8f;
            border-radius: 6px;
            background: #fff;
            box-shadow: 0 10px 24px rgba(31, 45, 61, 0.08);
        }

        .ts-config-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0;
            color: #102033;
            font-size: 20px;
            font-weight: 700;
            line-height: 1.25;
        }

        .ts-config-title i {
            color: #0f6b8f;
        }

        .ts-config-subtitle {
            margin-top: 4px;
            color: #64748b;
            font-size: 13px;
            font-weight: 500;
        }

        .ts-config-meta {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            min-height: 34px;
            padding: 7px 11px;
            border: 1px solid #cfe0ec;
            border-radius: 6px;
            color: #0f526b;
            background: #f2fbfd;
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
        }

        .ts-config-card {
            overflow: hidden;
            border: 1px solid #d3dfeb;
            border-radius: 6px;
            background: #fff;
            box-shadow: 0 12px 28px rgba(31, 45, 61, 0.08);
        }

        .ts-config-card > .card-header {
            padding: 8px !important;
            border-bottom: 1px solid #d9e5f4;
            background: #eaf1fb;
        }

        .ts-config-card > .card-body {
            padding: 16px;
            background: #fff;
        }

        .ts-config-tabs {
            display: grid !important;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 8px;
            border-bottom: 0 !important;
        }

        .ts-config-tabs .nav-item {
            min-width: 0;
        }

        .ts-config-tabs .nav-link {
            display: flex !important;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-height: 44px;
            padding: 9px 12px !important;
            border: 1px solid transparent !important;
            border-radius: 6px !important;
            color: #17365d !important;
            background: transparent !important;
            font-size: 12px;
            font-weight: 800 !important;
            text-align: center;
            white-space: normal;
        }

        .ts-config-tabs .nav-link.active {
            border-color: #d7e2f0 !important;
            border-bottom: 3px solid #087c9a !important;
            color: #083344 !important;
            background: #fff !important;
            box-shadow: 0 8px 16px rgba(15, 23, 42, 0.10);
        }

        .ts-panel {
            margin-bottom: 16px;
            border: 1px solid #d8e2ef;
            border-radius: 6px;
            background: #fff;
        }

        .ts-panel-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            min-height: 48px;
            padding: 12px 14px;
            border-bottom: 1px solid #e2e8f0;
            background: #f6f9fc;
        }

        .ts-panel-title {
            display: flex;
            align-items: center;
            gap: 9px;
            margin: 0;
            color: #1f2d3d;
            font-size: 15px;
            font-weight: 700;
        }

        .ts-panel-title span {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 30px;
            height: 30px;
            border-radius: 6px;
            color: #0f6b8f;
            background: #e8f6f8;
        }

        .ts-panel-note {
            color: #64748b;
            font-size: 12px;
            font-weight: 600;
        }

        .ts-panel-body {
            padding: 14px;
        }

        .ts-form-grid {
            display: grid;
            gap: 14px 16px;
            align-items: end;
        }

        .ts-form-grid--domain {
            grid-template-columns: minmax(180px, 1fr) minmax(220px, 1.2fr) minmax(180px, 0.8fr) auto;
        }

        .ts-form-grid--project {
            grid-template-columns: repeat(3, minmax(190px, 1fr)) minmax(170px, 0.8fr) minmax(170px, 0.8fr) auto;
        }

        .ts-form-grid--mapping {
            grid-template-columns: repeat(3, minmax(190px, 1fr));
        }

        .ts-field label,
        .ts-check-field label {
            display: block;
            margin-bottom: 5px;
            color: #384860;
            font-size: 12px;
            font-weight: 700 !important;
        }

        .ts-config-page .form-control {
            width: 100% !important;
            height: 38px;
            min-height: 38px;
            border: 1px solid #bfccd9;
            border-radius: 6px;
            color: #1f2d3d;
            background: #fff;
            font-size: 13px;
            box-shadow: none;
        }

        .ts-config-page .form-control:focus {
            border-color: #0f6b8f;
            box-shadow: 0 0 0 0.12rem rgba(15, 107, 143, 0.16);
        }

        .ts-check-field {
            min-height: 38px;
        }

        .ts-check-line {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            min-height: 38px;
            padding: 0 10px;
            border: 1px solid #d7e2ef;
            border-radius: 6px;
            background: #f8fafc;
        }

        .ts-check-line label {
            margin: 0;
            color: #334155;
            font-weight: 700 !important;
            white-space: nowrap;
        }

        .ts-config-page input[type="checkbox"] {
            width: 16px;
            height: 16px;
            min-width: 16px;
            margin: 0;
            accent-color: #0f6b8f;
        }

        .ts-actions {
            display: flex;
            align-items: end;
            gap: 8px;
            min-height: 38px;
        }

        .ts-config-page .btn {
            min-height: 38px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 700;
        }

        .ts-config-page .btn-primary {
            border-color: #0f6b8f;
            background: #0f6b8f;
            box-shadow: 0 8px 16px rgba(15, 107, 143, 0.18);
        }

        .ts-config-page .btn-primary:hover,
        .ts-config-page .btn-primary:focus {
            border-color: #0b526e;
            background: #0b526e;
        }

        .ts-table-panel {
            overflow: hidden;
            border: 1px solid #d8e2ef;
            border-radius: 6px;
            background: #fff;
        }

        .ts-table-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 12px 14px;
            border-bottom: 1px solid #e2e8f0;
            background: #f8fafc;
        }

        .ts-table-title {
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 0;
            color: #1f2d3d;
            font-size: 14px;
            font-weight: 700;
        }

        .ts-table-title i {
            color: #0f6b8f;
        }

        .ts-table-wrap {
            width: 100%;
            overflow-x: auto;
            padding: 0;
        }

        .ts-table-wrap table,
        .dataTables_wrapper table.dataTable {
            width: 100% !important;
            min-width: 860px;
            margin-bottom: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0 !important;
            color: #334155;
            font-size: 13px;
        }

        .ts-table-wrap table thead th,
        .dataTables_wrapper table.dataTable thead th,
        .dataTables_scrollHead thead th {
            padding: 10px 9px !important;
            border-color: #d8e2ef !important;
            color: #26384d !important;
            background: #e8eef5 !important;
            font-size: 12px !important;
            font-weight: 700 !important;
            vertical-align: middle !important;
            white-space: nowrap !important;
        }

        .ts-table-wrap table tbody td,
        .dataTables_wrapper table.dataTable tbody td {
            padding: 9px 9px !important;
            border-color: #e2e8f0 !important;
            color: #2f3e52;
            background: #fff !important;
            vertical-align: middle !important;
            white-space: nowrap !important;
        }

        .ts-table-wrap table tbody tr:nth-child(even) td,
        .dataTables_wrapper table.dataTable tbody tr:nth-child(even) td {
            background: #fbfdff !important;
        }

        .ts-table-wrap table tbody tr:hover td,
        .dataTables_wrapper table.dataTable tbody tr:hover td {
            background: #eef8fa !important;
        }

        .dataTables_wrapper {
            width: 100%;
            padding: 12px 14px 14px;
        }

        .dataTables_wrapper .row:first-child {
            display: flex !important;
            align-items: center !important;
            gap: 12px !important;
            margin: 0 0 12px !important;
        }

        .dataTables_wrapper .row:nth-child(2) {
            overflow-x: auto;
            margin: 0 !important;
        }

        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dataTables_filter,
        .dataTables_wrapper .dataTables_info,
        .dataTables_wrapper .dataTables_paginate {
            font-size: 12px;
        }

        .dataTables_wrapper .dataTables_length label,
        .dataTables_wrapper .dataTables_filter label {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 0;
            color: #405166;
            font-weight: 600 !important;
        }

        .dataTables_wrapper .dataTables_filter {
            margin-left: auto;
        }

        .dataTables_wrapper .dataTables_filter input,
        .dataTables_wrapper .dataTables_length select {
            height: 34px;
            border: 1px solid #bfccd9;
            border-radius: 6px;
            font-size: 12px;
        }

        .dataTables_wrapper .dataTables_filter input {
            width: 220px !important;
            margin-left: 0 !important;
        }

        .dataTables_scroll,
        .dataTables_scrollHead,
        .dataTables_scrollBody {
            width: 100% !important;
        }

        .dataTables_scrollBody {
            overflow-x: auto !important;
        }

        .dataTables_scrollHeadInner,
        .dataTables_scrollHeadInner table,
        .dataTables_scrollBody table {
            box-sizing: border-box !important;
            margin: 0 !important;
            width: 100% !important;
        }

        .loading {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            z-index: 1070;
            width: 190px;
            min-height: 150px;
            margin: 0;
            padding: 18px;
            transform: translate(-50%, -50%);
            border: 1px solid #d8e2ef;
            border-radius: 6px;
            background: rgba(255, 255, 255, 0.96);
            box-shadow: 0 20px 50px rgba(15, 23, 42, 0.22);
            text-align: center;
            color: #1f2d3d;
        }

        .loading img {
            width: 56px;
            height: 56px;
            object-fit: contain;
            margin-bottom: 10px;
        }

        .ts-modal .modal-content {
            overflow: hidden;
            border: 0;
            border-radius: 6px;
            box-shadow: 0 24px 60px rgba(15, 23, 42, 0.22);
        }

        .ts-modal .modal-header {
            align-items: center;
            border-bottom: 1px solid #d9e5f4;
            background: #f6f9fc;
        }

        .ts-modal .modal-title {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #1f2d3d;
            font-size: 15px;
            font-weight: 700;
        }

        .ts-modal .modal-title i {
            color: #0f6b8f;
        }

        .ts-modal .modal-body {
            background: #fff;
        }

        .ts-modal-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(180px, 1fr));
            gap: 14px 16px;
            align-items: end;
        }

        .ts-modal-grid--three {
            grid-template-columns: repeat(3, minmax(160px, 1fr));
        }

        .ts-modal-actions {
            border-top: 1px solid #e2e8f0;
            background: #f8fafc;
        }

        .ts-message-modal .modal-content {
            border: 0;
            border-radius: 6px;
            box-shadow: 0 18px 45px rgba(15, 23, 42, 0.20);
        }

        .ts-message-modal .modal-header {
            justify-content: center;
            border-bottom: 1px solid #e2e8f0;
            background: #f8fafc;
            text-align: center;
        }

        .ts-message-modal .modal-title {
            color: #1f2d3d;
            font-size: 14px;
            font-weight: 700;
            line-height: 1.5;
        }

        @media (max-width: 1200px) {
            .ts-form-grid--project,
            .ts-form-grid--mapping {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .ts-form-grid--domain {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 768px) {
            .ts-config-hero {
                align-items: flex-start;
                flex-direction: column;
            }

            .ts-config-tabs {
                grid-template-columns: 1fr;
            }

            .ts-form-grid,
            .ts-form-grid--domain,
            .ts-form-grid--project,
            .ts-form-grid--mapping,
            .ts-modal-grid,
            .ts-modal-grid--three {
                grid-template-columns: 1fr;
            }

            .ts-actions {
                align-items: stretch;
            }

            .ts-actions .btn {
                width: 100%;
            }

            .dataTables_wrapper .row:first-child {
                align-items: stretch !important;
                flex-direction: column !important;
            }

            .dataTables_wrapper .dataTables_filter {
                margin-left: 0;
            }

            .dataTables_wrapper .dataTables_filter label,
            .dataTables_wrapper .dataTables_filter input {
                width: 100% !important;
            }
        }
    </style>

    <script>
        $(document).ready(function () {

            Bind_Domain();
            BindDomainwiseColConfig_Grid(0);
            BindProjectWiseColConfig_Domain();
            BindProjectwiseColConfig_Grid(0);

            //---------- Mapping -----------
            BindColMapping_Project();
            BindColumnMapping_Grid();
        });

        function tracking_Message() {
            $('#tracking_dverror').modal('hide');
            return false;
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" alt="Loading" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="ts-config-page">
        <div class="ts-config-hero">
            <div>
                <h4 class="ts-config-title"><i class="fas fa-sliders-h"></i>Tracking Sheet Configuration</h4>
                <div class="ts-config-subtitle">Domain, project and column mapping setup</div>
            </div>
            <div class="ts-config-meta">
                <i class="fas fa-layer-group"></i>
                Production Utility
            </div>
        </div>

        <div class="card card-tabs ts-config-card">
            <div class="card-header">
                <ul class="nav nav-tabs ts-config-tabs" id="custom-tabs-one-tab" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link active" id="custom-tabs-one-domainWiseColumn-tab" data-toggle="pill" href="#custom-tabs-one-domainWiseColumn" role="tab" aria-controls="custom-tabs-one-domainWiseColumn" aria-selected="true">
                            <i class="fas fa-columns"></i><span>Domainwise Column Master</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" id="custom-tabs-one-ColumnConfig-tab" data-toggle="pill" href="#custom-tabs-one-ColumnConfig" role="tab" aria-controls="custom-tabs-one-ColumnConfig" aria-selected="false">
                            <i class="fas fa-project-diagram"></i><span>Projectwise Column Master</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" id="custom-tabs-one-ColumnMapping-tab" data-toggle="pill" href="#custom-tabs-one-ColumnMapping" role="tab" aria-controls="custom-tabs-one-ColumnMapping" aria-selected="false">
                            <i class="fas fa-random"></i><span>Column Mapping</span>
                        </a>
                    </li>
                </ul>
            </div>

            <div class="card-body">
                <div class="tab-content" id="custom-tabs-one-tabContent_addinvocie">
                    <div class="tab-pane fade show active" id="custom-tabs-one-domainWiseColumn" role="tabpanel" aria-labelledby="custom-tabs-one-domainWiseColumn-tab">
                        <div class="ts-panel">
                            <div class="ts-panel-header">
                                <h5 class="ts-panel-title"><span><i class="fas fa-cog"></i></span>Domain Field Setup</h5>
                                <div class="ts-panel-note">Domainwise master</div>
                            </div>
                            <div class="ts-panel-body">
                                <div class="ts-form-grid ts-form-grid--domain">
                                    <div class="ts-field">
                                        <label for="track_domain">Domain</label>
                                        <select id="track_domain" name="track_domain" class="form-control">
                                            <option value="Select">Select</option>
                                        </select>
                                    </div>
                                    <div class="ts-field">
                                        <label for="track_FieldName">Field Name</label>
                                        <input type="text" id="track_FieldName" name="track_FieldName" class="form-control" />
                                    </div>
                                    <div class="ts-check-field">
                                        <label>&nbsp;</label>
                                        <div class="ts-check-line">
                                            <input type="checkbox" id="chkNameColumn" name="chkNameColumn" title="Once you click the checkbox, the username will be auto-filled in this column, and five additional hidden columns will become visible: Assign Date, Start Time, End Time, TAT, and Status." />
                                            <label for="chkNameColumn">Is Name Column</label>
                                        </div>
                                    </div>
                                    <div class="ts-actions">
                                        <button class="btn btn-primary" type="button" id="btnDomainWise" onclick="btnSubmit_DomainWiseColConfg();">
                                            <i class="fas fa-save"></i>&nbsp;Submit
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="ts-table-panel">
                            <div class="ts-table-header">
                                <h5 class="ts-table-title"><i class="fas fa-list-ul"></i>Configured Domain Fields</h5>
                            </div>
                            <div class="ts-table-wrap">
                                <table class="table" id="table_DomainWiseColMaster" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="width: 80px; text-align: center;">Action</th>
                                            <th class="sort border-top ps-3" style="text-align: center; width: 100px;">Sr. #</th>
                                            <th class="sort border-top">Field</th>
                                            <th class="sort border-top" style="width: 80px;">Name Column</th>
                                            <th class="sort border-top" style="text-align: center;">Domain</th>
                                            <th class="sort border-top" style="text-align: center;">Added By</th>
                                            <th class="sort border-top" style="text-align: center;">Added Date</th>
                                            <th class="sort border-top">Updated By</th>
                                            <th class="sort border-top" style="text-align: center;">Updated Date</th>
                                            <th class="sort border-top" style="text-align: center; display: none;">DomainID</th>
                                            <th class="sort border-top" style="text-align: center; display: none;">Chkstatus</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="custom-tabs-one-ColumnConfig" role="tabpanel" aria-labelledby="custom-tabs-one-ColumnConfig-tab">
                        <div class="ts-panel">
                            <div class="ts-panel-header">
                                <h5 class="ts-panel-title"><span><i class="fas fa-tasks"></i></span>Project Field Setup</h5>
                                <div class="ts-panel-note">Projectwise master</div>
                            </div>
                            <div class="ts-panel-body">
                                <div class="ts-form-grid ts-form-grid--project">
                                    <div class="ts-field">
                                        <label for="track_PrjColConfigdomain">Domain</label>
                                        <select id="track_PrjColConfigdomain" name="track_PrjColConfigdomain" onchange="return BindProjectWiseColConfig_Project(this);" class="form-control">
                                            <option value="Select">Select</option>
                                        </select>
                                    </div>
                                    <div class="ts-field">
                                        <label for="track_PrjColConfigProject">Project</label>
                                        <select id="track_PrjColConfigProject" name="track_PrjColConfigProject" onchange="return BindProjectWiseColConfig_Field(this);" class="form-control">
                                            <option value="Select">Select</option>
                                        </select>
                                    </div>
                                    <div class="ts-field">
                                        <label for="track_PrjColConfigFieldName">Field Name</label>
                                        <select id="track_PrjColConfigFieldName" name="track_PrjColConfigFieldName" class="form-control">
                                            <option value="Select">Select</option>
                                        </select>
                                    </div>
                                    <div class="ts-check-field">
                                        <label>&nbsp;</label>
                                        <div class="ts-check-line">
                                            <input type="checkbox" id="track_PrjColConfigVisible" name="track_PrjColConfigVisible" title="When the checkbox is selected, the corresponding field becomes visible to the user." />
                                            <label for="track_PrjColConfigVisible">Visible to user</label>
                                        </div>
                                    </div>
                                    <div class="ts-check-field">
                                        <label>&nbsp;</label>
                                        <div class="ts-check-line">
                                            <input type="checkbox" id="track_PrjColConfigEditable" name="track_PrjColConfigEditable" title="When the checkbox is selected, the corresponding field becomes editable to the user." />
                                            <label for="track_PrjColConfigEditable">Editable to user</label>
                                        </div>
                                    </div>
                                    <div class="ts-actions">
                                        <button class="btn btn-primary" type="button" id="btnPrjColumnConfig" onclick="btnSubmit_PrjColumnConfig();">
                                            <i class="fas fa-save"></i>&nbsp;Submit
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="ts-table-panel">
                            <div class="ts-table-header">
                                <h5 class="ts-table-title"><i class="fas fa-list-ul"></i>Configured Project Fields</h5>
                            </div>
                            <div class="ts-table-wrap">
                                <table class="table" id="table_PrjWiseColMaster" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3">Action</th>
                                            <th class="sort border-top ps-3" style="text-align: center;">Sr. #</th>
                                            <th class="sort border-top" style="text-align: center;">Domain</th>
                                            <th class="sort border-top" style="text-align: center;">Project</th>
                                            <th class="sort border-top">Field</th>
                                            <th class="sort border-top" style="text-align: center;">Visible to user</th>
                                            <th class="sort border-top" style="text-align: center;">Editable to user</th>
                                            <th class="sort border-top" style="text-align: center;">Added By</th>
                                            <th class="sort border-top" style="text-align: center;">Added Date</th>
                                            <th class="sort border-top" style="text-align: center;">Updated By</th>
                                            <th class="sort border-top" style="text-align: center;">Updated Date</th>
                                            <th class="sort border-top" style="text-align: center; display: none;">DomainId</th>
                                            <th class="sort border-top" style="text-align: center; display: none;">DomainId</th>
                                            <th class="sort border-top" style="text-align: center; display: none;">FieldName</th>
                                            <th class="sort border-top" style="text-align: center; display: none;">Visible</th>
                                            <th class="sort border-top" style="text-align: center; display: none;">Editable</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="custom-tabs-one-ColumnMapping" role="tabpanel" aria-labelledby="custom-tabs-one-ColumnMapping-tab">
                        <div class="ts-panel">
                            <div class="ts-panel-header">
                                <h5 class="ts-panel-title"><span><i class="fas fa-link"></i></span>Column Mapping Setup</h5>
                                <div class="ts-panel-note">Mapping master</div>
                            </div>
                            <div class="ts-panel-body">
                                <div class="ts-form-grid ts-form-grid--mapping">
                                    <div class="ts-field">
                                        <label for="track_ColumnMappingProject">Project</label>
                                        <select id="track_ColumnMappingProject" name="track_ColumnMappingProject" onchange="return BindColMapping_Column(this);" class="form-control">
                                            <option value="Select">Select</option>
                                        </select>
                                    </div>
                                    <div class="ts-field">
                                        <label for="track_ColumnMappingColumn">Column</label>
                                        <select id="track_ColumnMappingColumn" name="track_ColumnMappingColumn" class="form-control">
                                            <option value="Select">Select</option>
                                        </select>
                                    </div>
                                    <div class="ts-field">
                                        <label for="track_ColumnMappingFieldName">Field</label>
                                        <select id="track_ColumnMappingFieldName" name="track_ColumnMappingFieldName" class="form-control">
                                            <option value="Select">Select</option>
                                        </select>
                                    </div>
                                    <div class="ts-field">
                                        <label for="track_ColumnMappingSequence">Sequence</label>
                                        <select id="track_ColumnMappingSequence" name="track_ColumnMappingSequence" class="form-control">
                                            <option value="Select">Select</option>
                                        </select>
                                    </div>
                                    <div class="ts-field">
                                        <label for="track_ColumnMappingDate">Date</label>
                                        <select id="track_ColumnMappingDate" name="track_ColumnMappingDate" class="form-control">
                                            <option value="Select">Select</option>
                                            <option value="mm/dd/yyyy">mm/dd/yyyy</option>
                                            <option value="dd-MMM-yyyy">dd-MMM-yyyy</option>
                                            <option value="mm/dd/yyyy hh:mm:ss">mm/dd/yyyy hh:mm:ss</option>
                                            <option value="dd-MMM-yyyy hh:mm:ss">dd-MMM-yyyy hh:mm:ss</option>
                                        </select>
                                    </div>
                                    <div class="ts-field">
                                        <label for="track_ColumnMappingFieldLength">Field Length</label>
                                        <input type="number" id="track_ColumnMappingFieldLength" name="track_ColumnMappingFieldLength" min="1" class="form-control" />
                                    </div>
                                    <div class="ts-check-field">
                                        <label>&nbsp;</label>
                                        <div class="ts-check-line">
                                            <input type="checkbox" id="track_ColumnMappingBilling" name="track_ColumnMappingBilling" title="Check this box to apply this column for billing purposes." />
                                            <label for="track_ColumnMappingBilling">For Billing</label>
                                        </div>
                                    </div>
                                    <div class="ts-check-field">
                                        <label>&nbsp;</label>
                                        <div class="ts-check-line">
                                            <input type="checkbox" id="track_ColumnMappingImport" name="track_ColumnMappingImport" title="By selecting this checkbox, the column becomes available for import." />
                                            <label for="track_ColumnMappingImport">For Import</label>
                                        </div>
                                    </div>
                                    <div class="ts-check-field">
                                        <label>&nbsp;</label>
                                        <div class="ts-check-line">
                                            <input type="checkbox" id="track_ColumnMappingUnique" name="track_ColumnMappingUnique" title="Once you check this box, the column will be set to Unique." />
                                            <label for="track_ColumnMappingUnique">For Unique Column</label>
                                        </div>
                                    </div>
                                    <div class="ts-actions">
                                        <button class="btn btn-primary" type="button" id="btnColumnMapping" onclick="btnSubmit_ColumnMapping();">
                                            <i class="fas fa-save"></i>&nbsp;Submit
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="ts-table-panel">
                            <div class="ts-table-header">
                                <h5 class="ts-table-title"><i class="fas fa-list-ul"></i>Configured Column Mapping</h5>
                            </div>
                            <div class="ts-table-wrap">
                                <table class="table" id="table_ColumnMapping" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3">Action</th>
                                            <th class="sort border-top ps-3" style="text-align: center;">Sr. #</th>
                                            <th class="sort border-top" style="text-align: center;">Project</th>
                                            <th class="sort border-top" style="text-align: center;">Column</th>
                                            <th class="sort border-top" style="width: 200px;">Field</th>
                                            <th class="sort border-top" style="text-align: center;">Sequence</th>
                                            <th class="sort border-top" style="text-align: center;">For Billing</th>
                                            <th class="sort border-top" style="text-align: center;">For Import</th>
                                            <th class="sort border-top" style="text-align: center;">For Unique Column</th>
                                            <th class="sort border-top" style="text-align: center;">Date Format</th>
                                            <th class="sort border-top" style="text-align: center;">Field Length</th>
                                            <th class="sort border-top" style="text-align: center;">Added By</th>
                                            <th class="sort border-top" style="text-align: center;">Added Date</th>
                                            <th class="sort border-top" style="text-align: center;">Updated By</th>
                                            <th class="sort border-top" style="text-align: center;">Updated Date</th>
                                            <th class="sort border-top" style="text-align: center; display: none;">ProjectID</th>
                                            <th class="sort border-top" style="text-align: center; display: none;">ProjectFieldID</th>
                                            <th class="sort border-top" style="text-align: center; display: none;">ColumnID</th>
                                            <th class="sort border-top" style="text-align: center; display: none;">Billing</th>
                                            <th class="sort border-top" style="text-align: center; display: none;">Unique</th>
                                            <th class="sort border-top" style="text-align: center; display: none;">Import</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade ts-modal" id="PopUptrack_UpdateColConfiguration">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-edit"></i>Update Domainwise Column Configuration</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="ts-modal-grid">
                        <div class="ts-field">
                            <label for="PopUptrack_domain">Domain</label>
                            <select id="PopUptrack_domain" name="PopUptrack_domain" class="form-control">
                                <option value="Select">Select</option>
                            </select>
                        </div>
                        <div class="ts-field">
                            <label for="PopUptrack_FieldName">Field Name</label>
                            <input type="text" id="PopUptrack_FieldName" name="PopUptrack_FieldName" class="form-control" />
                        </div>
                        <div class="ts-check-field">
                            <label>&nbsp;</label>
                            <div class="ts-check-line">
                                <input type="checkbox" id="PopUpchkNameColumn" name="PopUpchkNameColumn" title="Once you click on this check box , you will get auto username in this column and other 5 hidden column will be followed by it(Assign date, start time ,End time ,TAT , Status)." />
                                <label for="PopUpchkNameColumn">Is Name Column</label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between ts-modal-actions">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button class="btn btn-primary" type="button" id="btnUpdate_ColConfiguration" onclick="Update_ColConfiguration();">
                        <i class="fas fa-save"></i>&nbsp;Update
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade ts-modal" id="PopUp_DeleteColConfiguration">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title"><i class="fas fa-trash-alt"></i>Delete Configuration</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p class="mb-0">Are you sure you want to delete configuration?</p>
                </div>
                <div class="modal-footer justify-content-between ts-modal-actions">
                    <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
                    <button class="btn btn-primary" type="button" id="ColConfiguration_btnYes" onclick="return delete_ColConfiguration();">Yes</button>
                </div>
                <input type="hidden" id="lblConfigType" name="lblConfigType" />
            </div>
        </div>
    </div>

    <div class="modal fade ts-modal" id="PopUptrack_UpdateProjectColConfiguration">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-edit"></i>Update Projectwise Column Configuration</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="ts-modal-grid ts-modal-grid--three">
                        <div class="ts-field">
                            <label for="PopUptrackProject_domain">Domain</label>
                            <select id="PopUptrackProject_domain" name="PopUptrackProject_domain" class="form-control">
                                <option value="Select">Select</option>
                            </select>
                        </div>
                        <div class="ts-field">
                            <label for="PopUptrackProject_project">Project</label>
                            <select id="PopUptrackProject_project" name="PopUptrackProject_project" class="form-control">
                                <option value="Select">Select</option>
                            </select>
                        </div>
                        <div class="ts-field">
                            <label for="PopUptrackProject_FieldName">Field Name</label>
                            <select id="PopUptrackProject_FieldName" name="PopUptrackProject_FieldName" class="form-control">
                                <option value="Select">Select</option>
                            </select>
                        </div>
                        <div class="ts-check-field">
                            <label>&nbsp;</label>
                            <div class="ts-check-line">
                                <input type="checkbox" id="PopUptrack_PrjColConfigVisible" name="PopUptrack_PrjColConfigVisible" title="When the checkbox is selected, the corresponding field becomes visible to the user." />
                                <label for="PopUptrack_PrjColConfigVisible">Visible to user</label>
                            </div>
                        </div>
                        <div class="ts-check-field">
                            <label>&nbsp;</label>
                            <div class="ts-check-line">
                                <input type="checkbox" id="PopUptrack_PrjColConfigEditable" name="PopUptrack_PrjColConfigEditable" title="When the checkbox is selected, the corresponding field becomes editable to the user." />
                                <label for="PopUptrack_PrjColConfigEditable">Editable to user</label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between ts-modal-actions">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button class="btn btn-primary" type="button" id="btnUpdate_ColProjectConfiguration" onclick="Update_ColConfiguration();">
                        <i class="fas fa-save"></i>&nbsp;Update
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade ts-message-modal" id="tracking_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="tracking_errmsg"></h6>
                </div>
                <div class="modal-footer align-content-center justify-content-center">
                    <button class="btn btn-primary" type="button" id="tracking_btnMessage" onclick="return tracking_Message();">Okay</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
