<%@ Page Title="" Language="C#" MasterPageFile="~/IT/Admin.Master" AutoEventWireup="true" CodeBehind="VendorMaster.aspx.cs" Inherits="WebPortal.IT.VendorMaster" %>

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
            background: var(--asset-bg);
            border-radius: 24px;
            width: 100%;
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
            border: 0;
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(15, 23, 42, .06);
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
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 18px 16px;
            /*  align-items: start;*/
        }

        .asset-field label {
            display: block;
            color: #1e3a5f !important;
            font-weight: 600 !important;
            font-size: 12px;
            margin-bottom: 8px;
        }

        .asset-field .form-control, .asset-field select, .asset-field textarea {
            width: 100% !important;
            border: 1px solid #cbd5e1;
            border-radius: 11px;
            min-height: 40px;
            padding: 8px 14px;
            font-size: 13px;
            color: #0f172a;
            background: #fff;
            box-shadow: none;
        }

            .asset-field .form-control:focus, .asset-field textarea:focus {
                border-color: #93c5fd;
                box-shadow: 0 0 0 3px rgba(37, 99, 235, .12);
                outline: 0;
            }

        .asset-field textarea {
            min-height: 82px;
            resize: vertical;
        }

        .asset-field.half-width {
            grid-column: span 2;
        }


        .asset-actions {
            grid-column: 1 / -1;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            align-items: center;
            justify-content: flex-end;
            margin-top: 6px;
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

        @media (max-width: 1199px) {
            .asset-form-grid {
                grid-template-columns: repeat(3, minmax(0, 1fr));
            }
        }

        @media (max-width: 991px) {
            .asset-form-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 575px) {
            .asset-form-grid {
                grid-template-columns: 1fr;
            }
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
            BindVendorMaster();
        });

    </script>

    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <!-- Toastify CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css">

    <!-- Toastify JS -->
    <script src="https://cdn.jsdelivr.net/npm/toastify-js"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="asset-hero">
        <h4><i class="fas fa-store"></i>&nbsp;&nbsp;Vendor Master</h4>
        <p>Maintain vendor contact, address, tax, and banking information in one organized workspace.</p>
    </div>

    <div class="asset-page-shell">
        <div class="asset-panel">
            <div class="asset-panel-header">
                <div>
                    <h5>Add Vendor</h5>
                    <span>Enter vendor profile, communication details, and account information.</span>
                </div>
            </div>
            <div class="asset-panel-body">
                <div class="asset-form-grid">
                    <div class="asset-field">
                        <label for="vendor_name">Vendor Name</label>
                        <input type="text" id="vendor_name" name="vendor_name" class="form-control" required>
                    </div>
                    <div class="asset-field">
                        <label for="vendor_gstno">GST No</label>
                        <input type="text" id="vendor_gstno" name="vendor_gstno" class="form-control">
                    </div>
                    <div class="asset-field">
                        <label for="vendor_contactperson">Contact Person</label>
                        <input type="text" id="vendor_contactperson" name="vendor_contactperson" class="form-control" required>
                    </div>
                    <div class="asset-field">
                        <label for="vendor_phonenumber">Phone Number</label>
                        <input type="text" id="vendor_phonenumber" name="vendor_phonenumber" class="form-control" required>
                    </div>

                    <div class="asset-field">
                        <label for="vendor_email">Email Address</label>
                        <input type="email" id="vendor_email" name="vendor_email" class="form-control" required>
                    </div>
                    <div class="asset-field">
                        <label for="vendor_fax">Fax</label>
                        <input type="text" id="vendor_fax" name="vendor_fax" class="form-control">
                    </div>
                    <div class="asset-field">
                        <label for="vendor_weburl">Web URL</label>
                        <input type="url" id="vendor_weburl" name="vendor_weburl" class="form-control">
                    </div>
                    <div class="asset-field">
                        <label for="vendor_pan">PAN</label>
                        <input type="text" id="vendor_pan" name="vendor_pan" class="form-control" oninput="this.value = this.value.toUpperCase();" required>
                    </div>

                    <div class="asset-field">
                        <label for="vendor_accountholder">Account Holder</label>
                        <input type="text" id="vendor_accountholder" name="vendor_accountholder" class="form-control" required>
                    </div>
                    <div class="asset-field">
                        <label for="vendor_bank">Bank Name</label>
                        <input type="text" id="vendor_bank" name="vendor_bank" class="form-control" required>
                    </div>
                    <div class="asset-field">
                        <label for="vendor_branchaddress">Branch Address</label>
                        <input type="text" id="vendor_branchaddress" name="vendor_branchaddress" class="form-control" required>
                    </div>
                    <div class="asset-field">
                        <label for="vendor_accounttype">Account Type</label>
                        <input type="text" id="vendor_accounttype" name="vendor_accounttype" class="form-control" required>
                    </div>

                    <div class="asset-field">
                        <label for="vendor_accountno">Account #</label>
                        <input type="text" id="vendor_accountno" name="vendor_accountno" class="form-control" required>
                    </div>
                    <div class="asset-field">
                        <label for="vendor_micrcode">MICR Code</label>
                        <input type="text" id="vendor_micrcode" name="vendor_micrcode" class="form-control" required>
                    </div>
                    <div class="asset-field">
                        <label for="vendor_ifsccode">IFSC Code</label>
                        <input type="text" id="vendor_ifsccode" name="vendor_ifsccode" class="form-control" required>
                    </div>

                    <%-- <div class="asset-field full-width">
                        <label for="vendor_description">Description</label>
                        <textarea id="vendor_description" name="vendor_description" class="form-control" rows="3"></textarea>
                    </div>
                    <div class="asset-field full-width">
                        <label for="vendor_address">Address</label>
                        <textarea id="vendor_address" name="vendor_address" class="form-control" rows="3" required></textarea>
                    </div>--%>
                    <div class="asset-field half-width">
                        <label for="vendor_description">Description</label>
                        <textarea id="vendor_description"
                            name="vendor_description"
                            class="form-control"
                            rows="3"></textarea>
                    </div>

                    <div class="asset-field half-width">
                        <label for="vendor_address">Address</label>
                        <textarea id="vendor_address"
                            name="vendor_address"
                            class="form-control"
                            rows="3"
                            required></textarea>
                    </div>
                    <div class="asset-actions">
                        <button id="vendor_btnsubmit" name="vendor_btnsubmit" class="btn btn-primary" onclick="return vendor_submit();">Submit</button>
                        <button id="vendor_btnreset" name="vendor_btnreset" class="btn btn-secondary" onclick="location.reload();" style="display: none;">Reset</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="asset-panel">
            <div class="asset-panel-header">
                <div>
                    <h5>Records</h5>
                    <span>Search, export, and manage saved vendor entries.</span>
                </div>
            </div>
            <div class="asset-panel-body asset-table-wrap">
                <table class="table table-bordered table-hover" id="vendorlist" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top" style="text-wrap: nowrap;">Edit</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Sr. #</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Vendor Name</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Description</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Contact Person</th>
                            <th class="sort border-top" style="text-wrap: nowrap; width: 350px;">Address</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Email Address</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Phone</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Fax</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Web URL</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Account Holder</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Bank Name</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Branch Address</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Account Type</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Account #</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">MICR Code</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">IFSC Code</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">GST</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">PAN</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Added By</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Added Date</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="vendor_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="vendor_errmsg"></h6>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="vendor_btnMessage" onclick="return vendor_Message();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>


