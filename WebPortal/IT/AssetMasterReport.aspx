<%@ Page Title="" Language="C#" MasterPageFile="~/IT/Admin.Master" AutoEventWireup="true" CodeBehind="AssetMasterReport.aspx.cs" Inherits="WebPortal.IT.AssetMasterReport" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
            /*background: linear-gradient(to bottom, #007bff, 3%, #fff) !important;*/
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



    <style>
        :root {
            --asset-primary: #2563eb;
            --asset-primary-dark: #1e40af;
            --asset-accent: #06b6d4;
            --asset-bg: #f4f7fb;
            --asset-card: #ffffff;
            --asset-text: #1f2937;
            --asset-muted: #6b7280;
            --asset-border: #e5e7eb;
            --asset-shadow: 0 18px 45px rgba(15, 23, 42, .08);
        }

        .asset-page-shell {
            padding: 18px;
            background: var(--asset-bg);
            border-radius: 24px;
        }

        .asset-hero {
            position: relative;
            overflow: hidden;
            color: #fff;
            padding: 24px 28px;
            border-radius: 24px;
            background: linear-gradient(135deg, var(--asset-primary), var(--asset-primary-dark));
            box-shadow: var(--asset-shadow);
            margin-bottom: 20px;
        }

            .asset-hero:after {
                content: "";
                position: absolute;
                right: -70px;
                top: -80px;
                width: 240px;
                height: 240px;
                border-radius: 50%;
                background: rgba(255,255,255,.13);
            }

            .asset-hero .eyebrow {
                font-size: 11px;
                text-transform: uppercase;
                letter-spacing: 1.8px;
                opacity: .8;
                margin-bottom: 6px;
            }

            .asset-hero h4 {
                margin: 0;
                font-weight: 800;
            }

            .asset-hero p {
                margin: 7px 0 0;
                max-width: 720px;
                opacity: .9;
            }

        .asset-panel {
            background: var(--asset-card);
            border: 1px solid var(--asset-border);
            border-radius: 20px;
            box-shadow: var(--asset-shadow);
            margin-bottom: 20px;
        }

        .asset-panel-header {
            padding: 18px 22px;
            border-bottom: 1px solid var(--asset-border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
        }

            .asset-panel-header h5 {
                margin: 0;
                font-size: 16px;
                font-weight: 800;
                color: var(--asset-text);
            }

            .asset-panel-header span {
                color: var(--asset-muted);
                font-size: 12px;
            }

        .asset-panel-body {
            padding: 22px;
        }

        .asset-form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(230px, 1fr));
            gap: 18px;
            align-items: end;
        }

        .asset-field label {
            color: var(--asset-text) !important;
            font-weight: 700 !important;
            font-size: 13px;
            margin-bottom: 7px;
        }

        .asset-field .form-control, .asset-field select, .asset-field textarea {
            width: 100% !important;
            border: 1px solid var(--asset-border);
            border-radius: 12px;
            min-height: 42px;
            box-shadow: none;
        }

        .asset-field textarea {
            min-height: 88px;
        }

        .asset-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            align-items: center;
        }

            .asset-actions .btn, .asset-panel .btn {
                border-radius: 999px;
                padding: 9px 20px;
                font-weight: 700;
                box-shadow: none !important;
            }

            .asset-actions .btn-primary, .asset-panel .btn-primary {
                border: 0;
                background: linear-gradient(135deg, var(--asset-primary), var(--asset-accent));
            }

            .asset-actions .btn-secondary {
                border: 0;
                background: #e5e7eb;
                color: #374151;
            }

        .asset-table-wrap {
            overflow-x: auto;
        }

        .asset-panel table.dataTable, .asset-panel table.table {
            margin-bottom: 0;
            border-collapse: separate !important;
            border-spacing: 0;
            width: 100% !important;
        }

        .asset-panel table thead th {
            background: #eef5ff !important;
            color: #1e3a8a !important;
            border-top: 0 !important;
            border-bottom: 1px solid #dbeafe !important;
            white-space: nowrap;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: .35px;
        }

        .asset-panel table tbody td {
            vertical-align: middle;
            background: #fff !important;
            border-color: #eef2f7 !important;
        }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            margin: auto;
            width: 210px;
            height: 210px;
            z-index: 99999;
            background: rgba(255,255,255,.94);
            border-radius: 24px;
            box-shadow: var(--asset-shadow);
            text-align: center;
            padding-top: 35px;
        }

            .loading img {
                max-width: 72px;
            }

        .modal-content {
            border: 0;
            border-radius: 20px;
            box-shadow: var(--asset-shadow);
        }

        .modal-header {
            border-bottom: 1px solid var(--asset-border);
        }

        .modal-footer {
            border-top: 1px solid var(--asset-border);
        }

        .listbox-ul {
            width: 100% !important;
            min-height: 170px;
            border: 1px dashed #bfdbfe;
            border-radius: 16px;
            background: #f8fbff;
            padding: 10px;
            list-style: none;
            overflow-y: auto;
        }

            .listbox-ul li {
                padding: 8px 10px;
                margin-bottom: 8px;
                background: #fff;
                border: 1px solid var(--asset-border);
                border-radius: 10px;
                cursor: grab;
            }

                .listbox-ul li:hover, .listbox-ul li.selected {
                    background: linear-gradient(135deg, var(--asset-primary), var(--asset-accent));
                    color: #fff;
                }

        @media (max-width: 768px) {
            .asset-page-shell {
                padding: 10px;
            }

            .asset-hero {
                padding: 20px;
            }

            .asset-panel-header {
                display: block;
            }
        }
    </style>

    <script type="text/javascript">
        $(document).ready(function () {
            BindAllAssets();
            BindAssetStatus();

        });

    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" /><div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="asset-page-shell">
        <div class="asset-hero">
            <h4><i class="fas fa-copy"></i>&nbsp;&nbsp;Asset Master Report</h4>
            <p>Review the complete asset inventory with inline filtering and quick edit access.</p>
        </div>
        <div class="asset-panel">
            <div class="asset-panel-header">
                <div>
                    <h5>All Assets</h5>
                    <span>Use the table filters to find and edit asset master records.</span>
                </div>
            </div>
            <div class="asset-panel-body asset-table-wrap">
                <table class="table table-hover" id="allassetslist" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top" style="text-wrap: nowrap;">Edit</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Asset Serial #</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Asset Type</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Barcode</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Location</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Vendor</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Day User</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Purchase Cost</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Tax Amount</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Purchase Date</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">PO #</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Invoice #</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Asset Configuration</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Desk #</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Group</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Asset Name</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Brand</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Model</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Department</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Section</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Status</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Evening User</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Night User</th>
                        </tr>
                        <tr>
                            <th class="sort border-top" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Asset Serial #</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Asset Type</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Barcode</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Location</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Vendor</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Day User</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Purchase Cost</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Tax Amount</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Purchase Date</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">PO #</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Invoice #</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Asset Configuration</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Desk #</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Group</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Asset Name</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Brand</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Model</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Department</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Section</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Status</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Evening User</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Night User</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="modal fade" id="assetmaster_editpopup">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Edit Asset Details</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <%--<div class="row g-3">

                        <!-- Asset # -->
                        <div class="col-md-4">
                            <label for="assetedit_name" class="form-label fw-bold">Asset #</label>
                            <input type="text"
                                id="assetedit_name"
                                name="assetedit_name"
                                class="form-control"
                                disabled="disabled" />
                        </div>

                        <!-- Asset Type -->
                        <div class="col-md-4">
                            <label for="assetedit_type" class="form-label fw-bold">Asset Type</label>
                            <input type="text"
                                id="assetedit_type"
                                name="assetedit_type"
                                class="form-control"
                                disabled="disabled" />
                        </div>

                        <!-- Location -->
                        <div class="col-md-4">
                            <label for="assetedit_location" class="form-label fw-bold">Location</label>
                            <input type="text"
                                id="assetedit_location"
                                name="assetedit_location"
                                class="form-control"
                                disabled="disabled" />
                        </div>

                        <!-- Barcode -->
                        <div class="col-md-4">
                            <label for="assetedit_barcode" class="form-label fw-bold">Barcode</label>
                            <input type="text"
                                id="assetedit_barcode"
                                name="assetedit_barcode"
                                class="form-control"
                                disabled="disabled" />
                        </div>

                        <!-- Asset Status -->
                        <div class="col-md-4">
                            <label for="assetedit_status" class="form-label fw-bold">Asset Status</label>
                            <select id="assetedit_status" name="assetedit_status" class="form-select" style="height: 35px; width:300px;"></select>
                        </div>

                    </div>--%>
                       <table class="table">
                        <tr>
                            <td><b>Asset #:</b></td>
                            <td>
                                <input type="text" id="assetedit_name" name="assetedit_name" class="form-control" style="width: 300px;" disabled="disabled" />
                            </td>
                            <td>
                                <b>Asset Type:</b>
                            </td>
                            <td>
                                <input type="text" id="assetedit_type" name="assetedit_type" class="form-control" style="width: 300px;" disabled="disabled" />
                            </td>

                        </tr>
                        <tr>
                            <td>
                                <b>Location:</b>
                            </td>
                            <td>
                                <input type="text" id="assetedit_location" name="assetedit_location" class="form-control" style="width: 300px;" disabled="disabled" />
                            </td>
                            <td>
                                <b>Barcode:</b>
                            </td>
                            <td>
                                <input type="text" id="assetedit_barcode" name="assetedit_barcode" class="form-control" style="width: 300px;" disabled="disabled" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <b>Asset Status:</b>
                            </td>
                            <td>
                                <select id="assetedit_status" name="assetedit_status" class="form-control" style="width: 300px;"></select>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button class="btn btn-primary" type="button" id="assetmaster_btneditasset" onclick="return assetmaster_EditAssetSubmit();">Submit</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

</asp:Content>
