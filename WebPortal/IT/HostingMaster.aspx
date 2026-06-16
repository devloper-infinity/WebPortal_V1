<%@ Page Title="" Language="C#" MasterPageFile="~/IT/Admin.Master" AutoEventWireup="true" CodeBehind="HostingMaster.aspx.cs" Inherits="WebPortal.IT.HostingMaster" %>
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
            padding: 18px;
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
            align-items: start;
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

        .asset-field .form-control:focus, .asset-field textarea:focus, .asset-field select:focus {
            border-color: #93c5fd;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, .12);
            outline: 0;
        }

        .asset-field textarea {
            min-height: 82px;
            resize: vertical;
        }

        .asset-field.full-width { grid-column: 1 / -1; }
        .asset-field.half-width { grid-column: span 2; }

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

        .asset-table-wrap { overflow-x: auto; }

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

        .dataTables_length, .dataTables_info, .dataTables_paginate { float: left !important; }
        div.dt-buttons { position: static; padding-left: 20px; float: left; }
        .buttons-excel, .buttons-html5 {
            color: #fff !important;
            box-shadow: none !important;
            background: linear-gradient(135deg, var(--asset-primary), var(--asset-accent)) !important;
            border: 0 !important;
            font-weight: 700 !important;
            border-radius: 999px !important;
            margin: 0 8px !important;
            padding: 7px 16px !important;
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

        .loading img { max-width: 72px; }
        .dt-center { text-align: center; }
        .selected-row { background-color: #dbeafe !important; font-weight: bold; }

        .modal-content {
            border: 0;
            border-radius: 20px;
            box-shadow: var(--asset-shadow);
        }

        @media (max-width: 1199px) { .asset-form-grid { grid-template-columns: repeat(3, 1fr); } }
        @media (max-width: 991px) { .asset-form-grid { grid-template-columns: repeat(2, 1fr); } .asset-field.half-width { grid-column: span 1; } }
        @media (max-width: 575px) { .asset-page-shell { padding: 10px; } .asset-form-grid { grid-template-columns: 1fr; } .asset-field.half-width { grid-column: span 1; } }
    </style>

    <script type="text/javascript">
        $(document).ready(function () {
            BindHostingMaster_Grid();

            $('#host_btnreset').on('click', function () {
                $('#table_hostingMaster')
                    .removeAttr('style')
                    .removeClass('table-highlight table-striped table-bordered')
                    .find('tr')
                    .removeAttr('style')
                    .removeClass('highlight bold-row selected')
                    .css({
                        'background-color': '',
                        'font-weight': 'normal'
                    });
            });
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="asset-page-shell">
        <div class="asset-hero">
            <div class="eyebrow">Hosting Management</div>
            <h4><i class="fas fa-copy"></i>&nbsp;&nbsp;Hosting Master</h4>
            <p>Maintain hosting, domain, SSL renewal, provider, billing, and account details.</p>
        </div>

        <div class="asset-panel">
            <div class="asset-panel-header">
                <div>
                    <h5>Hosting Details</h5>
                    <span>Fill in domain, renewal, cost, email, card, link, and remark details.</span>
                </div>
            </div>
            <div class="asset-panel-body">
                <div class="asset-form-grid">
                    <div class="asset-field">
                        <label for="host_type">Type</label>
                        <select id="host_type" name="host_type" class="form-control">
                            <option value="Select">Select</option>
                            <option value="Hosting">Hosting</option>
                            <option value="Domain">Domain</option>
                            <option value="SSL">SSL</option>
                        </select>
                    </div>

                    <div class="asset-field">
                        <label for="host_domainname">Domain Name</label>
                        <input type="text" id="host_domainname" name="host_domainname" class="form-control" />
                    </div>

                    <div class="asset-field">
                        <label for="host_provider">Provider</label>
                        <input type="text" id="host_provider" name="host_provider" class="form-control" />
                    </div>

                    <div class="asset-field">
                        <label for="host_renewdate">Renewed Date</label>
                        <input type="date" id="host_renewdate" name="host_renewdate" class="form-control" />
                    </div>

                    <div class="asset-field">
                        <label for="host_advrendate">Advance Renewal Date</label>
                        <input type="date" id="host_advrendate" name="host_advrendate" class="form-control" />
                    </div>

                    <div class="asset-field">
                        <label for="host_expdate">Expiry Date</label>
                        <input type="date" id="host_expdate" name="host_expdate" class="form-control" />
                    </div>

                    <div class="asset-field">
                        <label for="host_renewperiod">Renewed Period</label>
                        <select id="host_renewperiod" name="host_renewperiod" class="form-control">
                            <option value="Select">Select</option>
                            <option value="Monthly">Monthly</option>
                            <option value="Half Yearly">Half Yearly</option>
                            <option value="Yearly">Yearly</option>
                            <option value="2 Years">2 Years</option>
                            <option value="3 Years">3 Years</option>
                            <option value="4 Years">4 Years</option>
                            <option value="5 Years">5 Years</option>
                            <option value="9 Years">9 Years</option>
                        </select>
                    </div>

                    <div class="asset-field">
                        <label for="host_costpaid">Cost Paid</label>
                        <input type="text" id="host_costpaid" name="host_costpaid" class="form-control" />
                    </div>

                    <div class="asset-field">
                        <label for="host_nextrenewalcost">Next Renewal Cost</label>
                        <input type="text" id="host_nextrenewalcost" name="host_nextrenewalcost" class="form-control" />
                    </div>

                    <div class="asset-field">
                        <label for="host_avgyear">Average/Year</label>
                        <input type="text" id="host_avgyear" name="host_avgyear" class="form-control" />
                    </div>

                    <div class="asset-field">
                        <label for="host_email">Registered Email Address</label>
                        <input type="text" id="host_email" name="host_email" class="form-control" />
                    </div>

                    <div class="asset-field">
                        <label for="host_creditcard">Credit Card #</label>
                        <input type="text" id="host_creditcard" name="host_creditcard" class="form-control" />
                    </div>

                    <div class="asset-field half-width">
                        <label for="host_cplink">C Panel Link</label>
                        <input type="text" id="host_cplink" name="host_cplink" class="form-control" />
                    </div>

                    <div class="asset-field half-width">
                        <label for="host_weblink">Web Link</label>
                        <input type="text" id="host_weblink" name="host_weblink" class="form-control" />
                    </div>

                    <div class="asset-field full-width">
                        <label for="host_remark">Remark</label>
                        <textarea id="host_remark" name="host_remark" class="form-control"></textarea>
                    </div>

                    <div class="asset-actions">
                        <button type="submit" id="host_btnsubmit" name="host_btnsubmit" class="btn btn-primary" onclick="return host_submit();">Submit</button>
                        <button type="button" id="host_btnreset" name="host_btnreset" class="btn btn-secondary" onclick="host_reset();" style="display: none;">Reset</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="asset-panel">
            <div class="asset-panel-header">
                <div>
                    <h5>Hosting List</h5>
                    <span>View and manage all hosting master records.</span>
                </div>
            </div>
            <div class="asset-panel-body">
                <div class="asset-table-wrap">
                    <table class="table" id="table_hostingMaster" style="width: 100%;">
                        <thead>
                            <tr>
                                <th class="sort border-top" style="text-wrap: nowrap;">Action</th>
                                <th class="sort border-top" style="text-wrap: nowrap; width: 90px;">Sr. #</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Type</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Domain Name</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Provider</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Renewed Date</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Expiry Date</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Renewal Period</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Cost Paid</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Next Renewal Cost</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Credit Card #</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Average/Year</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Registered Email Address</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">C Panel Link</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Web Link</th>
                                <th class="sort border-top" style="text-wrap: nowrap; width: 300px;">Remark</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="host_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="host_errmsg"></h6>
                </div>
                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="host_btnMessage" onclick="location.reload();">Okay</button>
                </div>
            </div>
        </div>
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

        .dataTables_paginate {
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
            margin: 0px 10px;
        }

        .table.dataTable th {
            /*background:linear-gradient(to bottom, #0070C0, 80%, #ffffff);*/
            background: linear-gradient(to bottom, #cbd0dd, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none;
        }

        .dt-center {
            text-align: center;
        }

        .selected-row {
            background-color: #84d9d2 !important;
            font-weight: bold;
            color: white;
        }
    </style>

    <script type="text/javascript">
        $(document).ready(function () {
            BindHostingMaster_Grid();

            $('#host_btnreset').on('click', function () {
                $('#table_hostingMaster')
                    .removeAttr('style')
                    .removeClass('table-highlight table-striped table-bordered')
                    .find('tr')
                    .removeAttr('style')
                    .removeClass('highlight bold-row selected')
                    .css({
                        'background-color': '',
                        'font-weight': 'normal'
                    });
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Hosting Master</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <table class="table">
                    <tr>
                        <td><b>Type :</b></td>
                        <td>
                            <select id="host_type" name="host_type" class="form-control" style="width: 200px;">
                                <option value="Select">Select</option>
                                <option value="Hosting">Hosting</option>
                                <option value="Domain">Domain</option>
                                <option value="SSL">SSL</option>
                            </select>
                        </td>
                        <td><b>Domain Name :</b></td>
                        <td>
                            <input type="text" id="host_domainname" name="host_domainname" class="form-control" style="width: 200px;" />
                        </td>
                        <td><b>Provider :</b></td>
                        <td>
                            <input type="text" id="host_provider" name="host_provider" class="form-control" style="width: 200px;" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Renewed Date :</b></td>
                        <td>
                            <input type="date" id="host_renewdate" name="host_renewdate" class="form-control" style="width: 200px;" />
                        </td>
                        <td><b>Advance Renewal Date :</b></td>
                        <td>
                            <input type="date" id="host_advrendate" name="host_advrendate" class="form-control" style="width: 200px;" />
                        </td>
                        <td><b>Expiry Date :</b></td>
                        <td>
                            <input type="date" id="host_expdate" name="host_expdate" class="form-control" style="width: 200px;" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Renewed Period :</b></td>
                        <td>
                            <select id="host_renewperiod" name="host_renewperiod" class="form-control" style="width: 200px;">
                                <option value="Select">Select</option>
                                <option value="Monthly">Monthly</option>
                                <option value="Half Yearly">Half Yearly</option>
                                <option value="Yearly">Yearly</option>
                                <option value="2 Years">2 Years</option>
                                <option value="3 Years">3 Years</option>
                                <option value="4 Years">4 Years</option>
                                <option value="5 Years">5 Years</option>
                                <option value="9 Years">9 Years</option>
                            </select>
                        </td>
                        <td><b>Cost Paid :</b></td>
                        <td>
                            <input type="text" id="host_costpaid" name="host_costpaid" class="form-control" style="width: 200px;" />
                        </td>
                        <td><b>Next Renewal Cost :</b></td>
                        <td>
                            <input type="text" id="host_nextrenewalcost" name="host_nextrenewalcost" class="form-control" style="width: 200px;" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Average/Year :</b></td>
                        <td>
                            <input type="text" id="host_avgyear" name="host_avgyear" class="form-control" style="width: 200px;" />
                        </td>
                        <td><b>Registered Email Address :</b></td>
                        <td>
                            <input type="text" id="host_email" name="host_email" class="form-control" style="width: 200px;" />
                        </td>
                        <td><b>Credit Card # :</b></td>
                        <td>
                            <input type="text" id="host_creditcard" name="host_creditcard" class="form-control" style="width: 200px;" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>C Panel Link :</b></td>
                        <td>
                            <input type="text" id="host_cplink" name="host_cplink" class="form-control" style="width: 200px;" />
                        </td>
                        <td><b>Web Link :</b></td>
                        <td>
                            <input type="text" id="host_weblink" name="host_weblink" class="form-control" style="width: 200px;" />
                        </td>
                        <td><b>Remark :</b></td>
                        <td>
                            <textarea id="host_remark" name="host_remark" class="form-control" style="width: 200px;"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="6" style="text-align: center;">
                            <button type="submit" id="host_btnsubmit" name="host_btnsubmit" class="btn btn-primary" onclick="return host_submit();">Submit</button>
                            <button type="button" id="host_btnreset" name="host_btnreset" class="btn btn-secondary" onclick="host_reset();" style="display: none;">Reset</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <table class="table" id="table_hostingMaster" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top" style="text-wrap: nowrap;">Action</th>
                            <th class="sort border-top" style="text-wrap: nowrap; width: 90px;">Sr. #</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Type</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Domain Name</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Provider</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Renewed Date</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Expiry Date</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Renewal Period</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Cost Paid</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Next Renewal Cost</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Credit Card #</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Average/Year</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Registered Email Address</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">C Panel Link</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Web Link</th>
                            <th class="sort border-top" style="text-wrap: nowrap; width: 300px;">Remark</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="host_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="host_errmsg"></h6>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="host_btnMessage" onclick="location.reload();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>--%>
