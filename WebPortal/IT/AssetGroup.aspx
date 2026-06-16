<%@ Page Title="" Language="C#" MasterPageFile="~/IT/Admin.Master" AutoEventWireup="true" CodeBehind="AssetGroup.aspx.cs" Inherits="WebPortal.IT.AssetGroup" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
            width: 100%;
            padding: 3px;
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
            BindAssetGroupGrid();
        });

    </script>

    <script src="../Scripts/IT/AssetGroup.js"></script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="asset-hero">
        <h4><i class="fas fa-copy"></i>&nbsp;&nbsp;Asset Group Master</h4>
        <p>Maintain high-level asset categories used across the asset lifecycle.</p>
    </div>

    <div class="asset-page-shell">
        <div class="asset-panel">
            <div class="asset-panel-header">
                <div>
                    <h5>Add Asset Group</h5>
                    <span>Create or update an asset group master record.</span>
                </div>
            </div>
            <div class="asset-panel-body">
                <div class="asset-form-grid">
                    <div class="asset-field">
                        <label>Asset Group Name</label>
                        <input type="text" id="assetgroup_name" name="assetgroup_name" class="form-control" required />
                    </div>
                    <div class="asset-actions">
                        <button id="asssetgroup_btnsubmit" name="asssetgroup_btnsubmit" class="btn btn-primary" onclick="return asssetgroup_submit();">Submit</button>
                        <button id="asssetgroup_btnreset" name="asssetgroup_btnreset" class="btn btn-secondary" onclick="location.reload();" style="display: none;">Reset</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="asset-panel">
            <div class="asset-panel-header">
                <div>
                    <h5>Records</h5>
                    <span>Search, export, and manage saved entries.</span>
                </div>
            </div>
            <div class="asset-panel-body asset-table-wrap">
                <table class="table table-bordered table-hover" id="assetgrouplist" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top" style="text-wrap: nowrap;">Edit</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Sr. #</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Asset Group Name</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Added By</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Added Date</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="modal fade" id="assetgroup_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="assetgroup_errmsg"></h6>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="bank_btnMessage" onclick="return assetgroup_Message();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

</asp:Content>
