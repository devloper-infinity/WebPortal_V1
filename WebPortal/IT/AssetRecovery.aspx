<%@ Page Title="" Language="C#" MasterPageFile="~/IT/Admin.Master" AutoEventWireup="true" CodeBehind="AssetRecovery.aspx.cs" Inherits="WebPortal.IT.AssetRecovery" %>


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
            /*color: #fff;
                background-color: #28a745;
            border-color: #28a745;*/
            box-shadow: none;
            background: linear-gradient(to right, #ffbf96, #fe7096);
            border: 0;
            font-weight: bold;
            margin: 0px 10px;
        }

        .table.dataTable th {
            background: linear-gradient(to bottom, #dddbdb, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
        }
    </style>

    <style>
        .listbox-ul {
            width: 250px;
            height: 150px;
            border: 1px solid #d1d9e6;
            border-radius: 12px;
            background: #f8f9fa;
            padding: 6px;
            list-style: none;
            overflow-y: auto;
        }

            .listbox-ul li {
                padding: 6px 8px;
                margin-bottom: 6px;
                background: #ffffff;
                border-radius: 6px;
                cursor: grab;
                font-weight: 400;
            }

                .listbox-ul li:hover {
                    background: linear-gradient(135deg, #84d9d2, #9BEBDE); /*#07cdae*/
                    color: #fff;
                }

                .listbox-ul li.selected {
                    background: linear-gradient(135deg, #9BEBDE, #b9f1e7);
                    color: #fff;
                }

            .listbox-ul.drag-over {
                border: 2px dashed #07cdae;
                background-color: #daecef;
            }
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

        @media (max-width: 100%) {
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

            assetrec_bindUsers();
            BindAssetRecovery_Grid();
        });

        $(".sortable").sortable({
            connectWith: ".sortable"
        }).disableSelection();

    </script>

    <%-- <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>--%>
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="asset-page-shell">
        <div class="asset-hero">
            <div class="eyebrow">IT Asset Management</div>
            <h4><i class="fas fa-copy"></i>&nbsp;&nbsp;Asset Recovery</h4>
            <p>Record recovered assets during exits or in-office handovers with cleaner visibility.</p>
        </div>

        <div class="asset-panel">
            <div class="asset-panel-header">
                <div>
                    <h5>Recovery Entry</h5>
                    <span>Select an employee, mark recovery status, and drag assets between assigned and recovered lists.</span>
                </div>
            </div>
            <div class="asset-panel-body">
                <div class="asset-form-grid">
                    <div class="asset-field">
                        <label>Employee</label><select id="assetrec_user" name="assetrec_user" class="form-control" onchange="bindprevassets(this);"></select>
                    </div>
                    <div class="asset-field">
                        <label>Status</label><select id="assetrec_status" name="assetrec_status" class="form-control"><option value="Select">Select</option>
                            <option value="For Exit">For Exit</option>
                            <option value="In Office">In Office</option>
                        </select>
                    </div>
                    <div class="asset-field">
                        <label>Other Asset</label><input id="assetrec_otherAsset" name="assetrec_otherAsset" class="form-control" />
                    </div>
                    <div class="asset-field">
                        <label>Remark</label><textarea id="assetrec_remark" name="assetrec_remark" class="form-control"></textarea>
                    </div>
                </div>
                <div class="asset-form-grid" style="margin-top: 18px; align-items: start;">
                    <div class="asset-field">
                        <label>Assigned Assets</label><ul id="assetrec_assign" class="listbox-ul" ondragover="allowDrop(event)" ondrop="dropLi(event)"></ul>
                    </div>
                    <div class="asset-field">
                        <label>Recovered Assets</label><ul id="assetrec_recover" class="listbox-ul" ondragover="allowDrop(event)" ondrop="dropLi(event)"></ul>
                    </div>
                    <div class="asset-actions" style="align-self: end;">
                        <button type="submit" id="assetrec_btnsubmit" name="assetrec_btnsubmit" class="btn btn-primary" onclick="return assetrec_submit();">Submit</button>
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
                <table class="table table-bordered table-hover" id="table_assetrec" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top" style="text-wrap: nowrap; width: 90px;">Sr. #</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Code</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Asset</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Other Asset</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Status</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Remark</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Added By</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Added Date</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="modal fade" id="assetrec_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="assetrec_errmsg"></h6>
                </div>
                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" data-dismiss="modal" id="assetrec_btnMessage">Okay</button><%--onclick="return assetrec_Message();"--%>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

</asp:Content>
