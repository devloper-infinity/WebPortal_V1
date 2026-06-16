<%@ Page Title="" Language="C#" MasterPageFile="~/IT/Admin.Master" AutoEventWireup="true" CodeBehind="AddAsset.aspx.cs" Inherits="WebPortal.IT.AddAsset" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        :root {
            --asset-primary: #2563eb;
            --asset-primary-dark: #1d4ed8;
            --asset-accent: #7c3aed;
            --asset-bg: #f5f7fb;
            --asset-card: #ffffff;
            --asset-border: #e5e7eb;
            --asset-text: #111827;
            --asset-muted: #6b7280;
            --asset-success: #16a34a;
            --asset-error: #dc2626;
            --asset-warning: #f59e0b;
        }

        .loading {
            position: fixed;
            inset: 0;
            background: rgba(255, 255, 255, 0.78);
            z-index: 99998;
            display: none;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            backdrop-filter: blur(3px);
        }

        .content-header .callout {
            border-radius: 16px;
            border-left: 4px solid var(--asset-primary);
            background: #eff6ff;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.06);
        }

        .asset-page {
            margin: 0 auto 32px;
            background-color: white;
            width: 100%;
        }

        .asset-shell {
            background: linear-gradient(180deg, #f8fbff 0%, var(--asset-bg) 100%);
            border: 1px solid #edf2f7;
            border-radius: 24px;
            padding: 22px;
            box-shadow: 0 18px 45px rgba(15, 23, 42, 0.08);
        }

        .asset-hero {
            display: flex;
            justify-content: space-between;
            gap: 16px;
            align-items: center;
            margin-bottom: 22px;
            padding: 22px;
            border-radius: 22px;
            color: #fff;
            /*background: radial-gradient(circle at top left, rgba(255,255,255,.24), transparent 32%), linear-gradient(135deg, var(--asset-primary), var(--asset-accent));*/
            /* box-shadow: 0 14px 30px rgba(37, 99, 235, 0.24);*/
            background: linear-gradient(135deg, var(--asset-primary), var(--asset-primary-dark));
            box-shadow: var(--asset-shadow);
        }

            .asset-hero h4 {
                margin: 0 0 5px;
                font-weight: 800;
                letter-spacing: -0.02em;
            }

            .asset-hero p {
                margin: 0;
                opacity: .88;
                font-size: 14px;
            }

        .asset-hero-icon {
            width: 58px;
            height: 58px;
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.18);
            font-size: 26px;
            flex: 0 0 auto;
        }

        .custom-tabs {
            border: 0;
            gap: 10px;
            margin-bottom: 18px;
            background: #edf2ff;
            border-radius: 18px;
            padding: 8px;
            display: flex;
        }

            .custom-tabs .nav-item {
                flex: 1 1 0;
                margin: 0;
            }

            .custom-tabs .nav-link {
                width: 100%;
                border: 0 !important;
                border-radius: 14px;
                color: #334155;
                background: transparent;
                padding: 13px 18px;
                font-weight: 700;
                text-align: center;
                transition: all .22s ease;
                white-space: nowrap;
            }

                .custom-tabs .nav-link i {
                    margin-right: 8px;
                }

                .custom-tabs .nav-link:hover {
                    background: rgba(255,255,255,.58);
                    color: var(--asset-primary-dark);
                }

                .custom-tabs .nav-link.active {
                    background: var(--asset-card);
                    color: var(--asset-primary-dark);
                    box-shadow: 0 8px 20px rgba(15, 23, 42, .10);
                }

        .tab-card {
            background: var(--asset-card);
            border: 1px solid var(--asset-border);
            border-radius: 22px;
            padding: 24px;
            box-shadow: 0 10px 28px rgba(15, 23, 42, 0.06);
        }

        .section-heading {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 22px;
            padding-bottom: 16px;
            border-bottom: 1px solid var(--asset-border);
        }

        .section-title {
            margin: 0;
            font-size: 19px;
            line-height: 1.2;
            font-weight: 800;
            color: var(--asset-text);
        }

        .section-subtitle {
            margin: 5px 0 0;
            color: var(--asset-muted);
            font-size: 13px;
        }

        .modern-form .form-group {
            margin-bottom: 18px;
        }

        .modern-form label {
            display: block;
            margin-bottom: 7px;
            font-size: 13px;
            font-weight: 800 !important;
            color: #475569 !important;
        }

        .modern-form .form-control {
            border-radius: 13px;
            border: 1px solid #d7deea;
            padding: 11px 13px;
            min-height: 44px;
            height: auto;
            color: var(--asset-text);
            background-color: #fff;
            transition: border-color .2s ease, box-shadow .2s ease, background .2s ease;
        }

            .modern-form .form-control:focus {
                border-color: var(--asset-primary);
                box-shadow: 0 0 0 .18rem rgba(37,99,235,.14);
            }

            .modern-form .form-control:disabled {
                background: #f1f5f9;
                color: #64748b;
                cursor: not-allowed;
            }

        .asset-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 2px 18px;
        }

        .full-width {
            grid-column: 1 / -1;
        }

        .upload-panel {
            border: 1.5px dashed #bfd0ff;
            border-radius: 20px;
            padding: 26px;
            background: linear-gradient(180deg, #f8fbff, #ffffff);
        }

        .upload-panel-inner {
            display: grid;
            grid-template-columns: 70px 1fr auto;
            gap: 18px;
            align-items: end;
        }

        .upload-icon {
            width: 64px;
            height: 64px;
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--asset-primary);
            background: #eaf1ff;
            font-size: 28px;
            margin-bottom: 18px;
        }

        .download-format {
            width: 64px;
            height: 64px;
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #ecfdf5;
            color: var(--asset-success);
            font-size: 24px;
            transition: all .2s ease;
            text-decoration: none !important;
        }

            .download-format:hover {
                transform: translateY(-2px);
                color: #15803d;
                box-shadow: 0 10px 22px rgba(22, 163, 74, .18);
            }

        .gradient-btn {
            border: 0;
            border-radius: 13px;
            color: #fff;
            min-height: 44px;
            padding: 11px 24px;
            font-weight: 800;
            background: linear-gradient(135deg, var(--asset-primary), var(--asset-accent));
            box-shadow: 0 10px 20px rgba(37, 99, 235, .20);
            transition: transform .2s ease, box-shadow .2s ease, opacity .2s ease;
        }

            .gradient-btn:hover,
            .gradient-btn:focus {
                /*                color: #fff;*/
                background: linear-gradient(135deg, var(--asset-primary), var(--asset-accent));
                opacity: .96;
                transform: translateY(-1px);
                box-shadow: 0 14px 26px rgba(37, 99, 235, .25);
            }

            .gradient-btn i {
                margin-right: 7px;
            }

        .action-row {
            margin-top: 8px;
            display: flex;
            justify-content: flex-end;
        }

        #toastContainer {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 99999;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .toast-box {
            min-width: 260px;
            max-width: 340px;
            padding: 13px 15px;
            border-radius: 12px;
            color: #fff;
            font-size: 14px;
            box-shadow: 0 12px 26px rgba(15, 23, 42, .18);
            animation: slideIn .3s ease, fadeOut .3s ease 2.2s forwards;
        }

        .toast-success {
            background: var(--asset-success);
        }

        .toast-error {
            background: var(--asset-error);
        }

        .toast-warning {
            background: var(--asset-warning);
            color: #111827;
        }

        .input-error {
            border: 2px solid var(--asset-error) !important;
            box-shadow: 0 0 0 .18rem rgba(220, 38, 38, .14) !important;
        }

        @keyframes slideIn {
            from {
                transform: translateX(120%);
                opacity: 0;
            }

            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        @keyframes fadeOut {
            to {
                opacity: 0;
                transform: translateX(120%);
            }
        }

        @media (max-width: 991px) {
            .asset-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .upload-panel-inner {
                grid-template-columns: 1fr;
                align-items: stretch;
            }

            .download-format {
                width: 100%;
                height: 52px;
            }
        }

        @media (max-width: 767px) {
            .asset-shell {
                padding: 14px;
                border-radius: 18px;
            }

            .asset-hero {
                align-items: flex-start;
                padding: 18px;
            }

            .asset-hero-icon {
                display: none;
            }

            .custom-tabs {
                display: block;
                background: transparent;
                padding: 0;
            }

                .custom-tabs .nav-item {
                    margin-bottom: 8px;
                }

                .custom-tabs .nav-link {
                    background: #edf2ff;
                    text-align: left;
                }

            .asset-grid {
                grid-template-columns: 1fr;
            }

            .tab-card {
                padding: 18px;
            }
        }
    </style>

    <script type="text/javascript">
        $(document).ready(function () {
            addasset_bindlocation();
            addasset_bindgroup();
            addasset_bindbrand();
            addasset_bindstatus();
            addasset_bindvendors();
            addasset_binddepartment();
        });

        $(function () {
            $('[data-toggle="tooltip"]').tooltip();
        });
    </script>
    <script src="https://jsuites.net/v5/jsuites.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" alt="Loading" />
        <div style="font-size: 12px; font-weight: bold; margin-top: 8px;">One moment, please . . . .</div>
    </div>
    <div class="asset-hero">
        <div>
            <h4>Asset Management</h4>
            <p>Import assets in bulk, attach purchase orders, or register a single asset manually.</p>
        </div>
        <div class="asset-hero-icon">
            <i class="fa fa-cubes"></i>
        </div>
    </div>

    <div class="asset-page">
        <div class="asset-shell">
            <ul class="nav nav-tabs custom-tabs" id="assetTabs" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" id="excel-tab" data-toggle="tab" href="#excel" role="tab">
                        <i class="fa fa-file-import"></i>Import Excel
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="po-tab" data-toggle="tab" href="#purchaseorder" role="tab">
                        <i class="fa fa-cloud-upload-alt"></i>Import Purchase Order
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="asset-tab" data-toggle="tab" href="#addasset" role="tab">
                        <i class="fa fa-cubes"></i>Add Asset
                    </a>
                </li>
            </ul>

            <div class="tab-content">
                <div class="tab-pane fade show active" id="excel" role="tabpanel">
                    <div class="tab-card">
                        <div class="section-heading">
                            <div>
                                <h5 class="section-title">Import Excel File</h5>
                                <p class="section-subtitle">Upload the standard asset template to create multiple assets at once.</p>
                            </div>
                        </div>

                        <div class="upload-panel modern-form">
                            <div class="upload-panel-inner">
                                <%--   <ul>

                                    <li><i class="fa fa-file-import"></i>Import Purchase Orders</li>
                                    <li><i class="fa fa-upload"></i>Upload Purchase Orders</li>
                                    <li><i class="fa fa-cart-plus"></i>Purchase Order Import</li>
                                    <li><i class="fa fa-file-excel"></i>Import PO from Excel</li>
                                    <li><i class="fa fa-download"></i>Bulk PO Upload</li>
                                    <li><i class="fa fa-truck-loading"></i>PO Data Import</li>
                                    <li><i class="fa fa-database"></i>Import Procurement Data</li>
                                    <li><i class="fa fa-exchange-alt"></i>Purchase Order Transfer</li>
                                    <li><i class="fa fa-cloud-upload-alt"></i>Upload PO File</li>
                                    <li><i class="fa fa-shopping-basket"></i>Purchase Order Management</li>
                                </ul>--%>
                                <a href="#url" class="download-format" data-toggle="tooltip" data-placement="top" title="Download Excel Format">
                                    <i class="fa fa-download"></i>

                                </a>
                                <div class="form-group">
                                    <label>Attachment</label>
                                    <input type="file" id="importasset_file" name="importasset_file" class="form-control" />
                                </div>
                                <div class="form-group">
                                    <label>&nbsp;</label>
                                    <button id="importasset_btnimport" type="button" class="gradient-btn" onclick="importasset_import();">
                                        <i class="fa fa-upload"></i>Import Excel
                                   
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="tab-pane fade" id="purchaseorder" role="tabpanel">
                    <div class="tab-card">
                        <div class="section-heading">
                            <div>
                                <h5 class="section-title">Import Purchase Order</h5>
                                <p class="section-subtitle">Save purchase order details and upload the related file.</p>
                            </div>
                        </div>
                        <div class="modern-form">
                            <div class="row">
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>PO Number</label>
                                        <input type="text" id="addpo_ponumber" class="form-control" />
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Attachment</label>
                                        <input type="file" id="addpo_file" class="form-control" />
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>&nbsp;</label>
                                        <button id="addpo_btnimport" type="button" class="gradient-btn w-100" onclick="addpo_add();">
                                            <i class="fa fa-upload"></i>Import PO
                                       
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="tab-pane fade" id="addasset" role="tabpanel">
                    <div class="tab-card">
                        <div class="section-heading">
                            <div>
                                <h5 class="section-title">Asset Details</h5>
                                <p class="section-subtitle">Fill in identification, purchase, vendor, and configuration details.</p>
                            </div>
                        </div>

                        <div class="modern-form asset-grid">
                            <div id="toastContainer"></div>

                            <div class="form-group">
                                <label>Location</label>
                                <select id="addasset_location" class="form-control"></select>
                            </div>
                            <div class="form-group">
                                <label>Group</label>
                                <select id="addasset_group" class="form-control" onchange="addasset_getassettypes();"></select>
                            </div>
                            <div class="form-group">
                                <label>Type</label>
                                <select id="addasset_type" class="form-control" onchange="addasset_generatebarcode();"></select>
                            </div>
                            <div class="form-group">
                                <label>Asset Name</label>
                                <input type="text" id="addasset_name" class="form-control" />
                            </div>
                            <div class="form-group">
                                <label>Asset Serial #</label>
                                <input type="text" id="addasset_srno" class="form-control" />
                            </div>
                            <div class="form-group">
                                <label>Barcode</label>
                                <input type="text" id="addasset_barcode" class="form-control" disabled />
                            </div>
                            <div class="form-group">
                                <label>Brand</label>
                                <select id="addasset_brand" class="form-control"></select>
                            </div>
                            <div class="form-group">
                                <label>Asset Status</label>
                                <select id="addasset_status" class="form-control"></select>
                            </div>
                            <div class="form-group">
                                <label>Vendor</label>
                                <select id="addasset_vendor" class="form-control"></select>
                            </div>
                            <div class="form-group">
                                <label>Department</label>
                                <select id="addasset_department" class="form-control"></select>
                            </div>
                            <div class="form-group">
                                <label>Purchase Cost</label>
                                <input type="text" id="addasset_purchasecost" class="form-control" />
                            </div>
                            <div class="form-group">
                                <label>Purchase Date</label>
                                <input type="date" id="addasset_purchasedate" class="form-control" />
                            </div>
                            <div class="form-group">
                                <label>PO #</label>
                                <input type="text" id="addasset_ponumber" class="form-control" />
                            </div>
                            <div class="form-group">
                                <label>Invoice #</label>
                                <input type="text" id="addasset_invoicenumber" class="form-control" />
                            </div>
                            <div class="form-group">
                                <label>Tax Amount / %</label>
                                <input type="text" id="addasset_taxamount" class="form-control" />
                            </div>
                            <div class="form-group full-width">
                                <label>Asset Configuration</label>
                                <textarea id="addasset_remark" class="form-control" rows="4"></textarea>
                            </div>
                            <div class="form-group full-width action-row">
                                <button id="addasset_btnsubmit" type="button" class="gradient-btn" onclick="return addasset_submit();">
                                    <i class="fa fa-plus-circle"></i>Add Asset
                               
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<%--<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    
    <style>
        .toast-msg {
            position: fixed;
            top: 20px;
            right: 20px;
            background: #dc3545;
            color: #fff;
            padding: 12px 18px;
            border-radius: 6px;
            font-size: 14px;
            display: none;
            z-index: 9999;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        }

        .asset-wrapper {
            background: #f4f7fb;
            border-radius: 18px;
            padding: 20px;
        }

        .custom-tabs {
            border: none;
            gap: 12px;
            margin-bottom: 25px;
        }

            .custom-tabs .nav-link {
                border: none;
                border-radius: 14px;
                padding: 14px 28px;
                font-weight: 600;
                color: #555;
                background: #ffffff;
                box-shadow: 0 4px 12px rgba(0,0,0,0.08);
                transition: all 0.3s ease;
            }

                .custom-tabs .nav-link.active {
                    background: linear-gradient(135deg, #4f46e5, #7c3aed);
                    color: #fff;
                    transform: translateY(-2px);
                }

        .tab-card {
            background: #fff;
            border-radius: 18px;
            padding: 25px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.08);
        }

        .section-title {
            font-size: 20px;
            font-weight: 700;
            color: #222;
            margin-bottom: 20px;
        }

        .modern-form .form-group {
            margin-bottom: 18px;
        }

            .modern-form .form-group label {
                font-weight: 700 !important;
                color: #6c757d !important;
            }

        .modern-form label {
            margin-bottom: 6px;
            font-weight: 600;
            color: #444;
        }

        .modern-form .form-control {
            border-radius: 12px;
            border: 1px solid #dbe1ea;
            padding: 12px;
            height: auto;
            transition: 0.3s;
        }

            .modern-form .form-control:focus {
                border-color: #7c3aed;
                box-shadow: 0 0 0 0.15rem rgba(124,58,237,.15);
            }

        .gradient-btn {
            background: linear-gradient(135deg, #4f46e5, #7c3aed);
            border: none;
            color: #fff;
            padding: 12px 30px;
            border-radius: 12px;
            font-weight: 600;
            transition: 0.3s;
        }

            .gradient-btn:hover {
                opacity: 0.9;
                transform: translateY(-2px);
            }

        .upload-box {
            border: 2px dashed #c7d2fe;
            border-radius: 16px;
            padding: 25px;
            background: #f8faff;
            text-align: center;
        }

            .upload-box i {
                font-size: 42px;
                color: #6366f1;
                margin-bottom: 12px;
            }

        .asset-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 10px;
        }

        .full-width {
            grid-column: 1 / -1;
        }
    </style>


    <script type="text/javascript">
        $(document).ready(function () {
            addasset_bindlocation();
            addasset_bindgroup();
            addasset_bindbrand();
            addasset_bindstatus();
            addasset_bindvendors();
            addasset_binddepartment();
        });

        $(function () {
            $('[data-toggle="tooltip"]').tooltip();
        });
    </script>
    <script src="https://jsuites.net/v5/jsuites.js"></script>
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Add New Asset</b></h6>
                </div>
            </div>
        </div>
    </div>

    <div class="asset-wrapper">

        <!-- Tabs -->
        <ul class="nav nav-tabs custom-tabs" id="assetTabs" role="tablist">

            <li class="nav-item">
                <a class="nav-link active"
                    id="excel-tab"
                    data-toggle="tab"
                    href="#excel"
                    role="tab">
                    <i class="fa fa-file-excel-o"></i>Import Excel
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link"
                    id="po-tab"
                    data-toggle="tab"
                    href="#purchaseorder"
                    role="tab">
                    <i class="fa fa-shopping-cart"></i>Import Purchase Order
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link"
                    id="asset-tab"
                    data-toggle="tab"
                    href="#addasset"
                    role="tab">
                    <i class="fa fa-cubes"></i>Add Asset
                </a>
            </li>

        </ul>

        <div class="tab-content">

            <!-- Import Excel -->
            <div class="tab-pane fade show active" id="excel" role="tabpanel">
                <div class="tab-card">
                    <div class="section-title">
                        Import Excel File
                    </div>

                    <div class="upload-box">
                        <div class="modern-form">

                            <div class="inline-controls">
                                <div class="form-group file-input">

                                    <a href="#url" data-toggle="tooltip" data-placement="top" title="Download Excel Format">><i class="fa fa-download"></i></a>
                                </div>


                                <div class="form-group file-input">
                                    <label style="text-align: left;">Attachment</label>
                                    <input type="file"
                                        id="importasset_file"
                                        name="importasset_file"
                                        class="form-control">
                                </div>

                                <div class="form-group">
                                    <label>&nbsp;</label><br>

                                    <button id="importasset_btnimport"
                                        class="gradient-btn"
                                        onclick="importasset_import();">
                                        Import Excel
           
                                    </button>
                                    &nbsp;&nbsp;

                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>

            <!-- Import PO -->
            <div class="tab-pane fade" id="purchaseorder" role="tabpanel">
                <div class="tab-card">
                    <div class="section-title">
                        Import Purchase Order
                    </div>

                    <div class="modern-form">
                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>PO Number</label>
                                    <input type="text" id="addpo_ponumber" class="form-control">
                                </div>
                            </div>

                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>Attachment</label>
                                    <input type="file" id="addpo_file" class="form-control">
                                </div>
                            </div>

                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>&nbsp;</label>
                                    <button id="addpo_btnimport" class="gradient-btn w-100" onclick="addpo_add();">Import PO</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Add Asset -->
            <div class="tab-pane fade" id="addasset" role="tabpanel">

                <div class="tab-card">
                    <div class="modern-form asset-grid">
                        <div id="toastContainer"></div>

                        <div class="form-group">
                            <label>Location</label>
                            <select id="addasset_location" class="form-control"></select>
                        </div>

                        <div class="form-group">
                            <label>Group</label>
                            <select id="addasset_group"
                                class="form-control"
                                onchange="addasset_getassettypes();">
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Type</label>
                            <select id="addasset_type"
                                class="form-control"
                                onchange="addasset_generatebarcode();">
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Asset Name</label>
                            <input type="text"
                                id="addasset_name"
                                class="form-control">
                        </div>

                        <div class="form-group">
                            <label>Asset Serial #</label>
                            <input type="text"
                                id="addasset_srno"
                                class="form-control">
                        </div>

                        <div class="form-group">
                            <label>Barcode</label>
                            <input type="text"
                                id="addasset_barcode"
                                class="form-control"
                                disabled>
                        </div>

                        <div class="form-group">
                            <label>Brand</label>
                            <select id="addasset_brand"
                                class="form-control">
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Asset Status</label>
                            <select id="addasset_status"
                                class="form-control">
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Vendor</label>
                            <select id="addasset_vendor"
                                class="form-control">
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Department</label>
                            <select id="addasset_department"
                                class="form-control">
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Purchase Cost</label>
                            <input type="text"
                                id="addasset_purchasecost"
                                class="form-control">
                        </div>

                        <div class="form-group">
                            <label>Purchase Date</label>
                            <input type="date"
                                id="addasset_purchasedate"
                                class="form-control">
                        </div>

                        <div class="form-group">
                            <label>PO #</label>
                            <input type="text"
                                id="addasset_ponumber"
                                class="form-control">
                        </div>

                        <div class="form-group">
                            <label>Invoice #</label>
                            <input type="text"
                                id="addasset_invoicenumber"
                                class="form-control">
                        </div>

                        <div class="form-group">
                            <label>Tax Amount / %</label>
                            <input type="text"
                                id="addasset_taxamount"
                                class="form-control">
                        </div>

                        <div class="form-group full-width">
                            <label>Asset Configuration</label>
                            <textarea id="addasset_remark"
                                class="form-control"
                                rows="4"></textarea>
                        </div>

                        <div class="form-group full-width text-right">
                            <button id="addasset_btnsubmit" type="button" class="gradient-btn" onclick="return addasset_submit();">
                                <i class="fa fa-plus-circle"></i>Add Asset</button>
                        </div>

                    </div>

                </div>

            </div>

        </div>

    </div>

    <style>
        #toastContainer {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 99999;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .toast-box {
            min-width: 260px;
            max-width: 320px;
            padding: 12px 15px;
            border-radius: 8px;
            color: #fff;
            font-size: 14px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.15);
            animation: slideIn 0.3s ease, fadeOut 0.3s ease 2.2s forwards;
        }

        .toast-success {
            background: #28a745;
        }

        .toast-error {
            background: #dc3545;
        }

        .toast-warning {
            background: #ffc107;
            color: #000;
        }

        @keyframes slideIn {
            from {
                transform: translateX(120%);
                opacity: 0;
            }

            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        @keyframes fadeOut {
            to {
                opacity: 0;
                transform: translateX(120%);
            }
        }

        .input-error {
            border: 2px solid #dc3545 !important;
            box-shadow: 0 0 4px rgba(220, 53, 69, 0.4);
        }
    </style>

</asp:Content>--%>
