<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="PseudoName.aspx.cs" Inherits="WebPortal.Admin.PseudoName" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --pn-primary: #1d4ed8;
            --pn-primary-2: #2563eb;
            --pn-cyan: #22c1dc;
            --pn-bg: #f4f7fb;
            --pn-card: #ffffff;
            --pn-text: #0f172a;
            --pn-muted: #64748b;
            --pn-border: #dbe7f5;
            --pn-shadow: 0 18px 45px rgba(15, 23, 42, .10);
            --pn-soft-shadow: 0 10px 28px rgba(15, 23, 42, .08);
        }

        body {
            background: var(--pn-bg) !important;
        }

        .pn-page {
            width: 100%;
            color: var(--pn-text);
        }

        .pn-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            gap: 18px;
            padding: 28px 32px;
            margin-bottom: 24px;
            border-radius: 24px;
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%);
            box-shadow: var(--pn-shadow);
        }

        .pn-hero:before,
        .pn-hero:after {
            content: "";
            position: absolute;
            border-radius: 999px;
            background: rgba(255, 255, 255, .13);
            pointer-events: none;
        }

        .pn-hero:before {
            width: 230px;
            height: 230px;
            right: 100px;
            top: -135px;
        }

        .pn-hero:after {
            width: 340px;
            height: 340px;
            right: -120px;
            bottom: -210px;
        }

        .pn-hero-icon {
            position: relative;
            z-index: 1;
            width: 50px;
            height: 50px;
            flex: 0 0 50px;
            display: grid;
            place-items: center;
            border-radius: 18px;
            background: rgba(255, 255, 255, .16);
            border: 1px solid rgba(255, 255, 255, .24);
            box-shadow: inset 0 1px 0 rgba(255, 255, 255, .20);
            font-size: 25px;
        }

        .pn-hero-content {
            position: relative;
            z-index: 1;
        }

        .pn-title {
            margin: 0;
            font-size: 19px;
            line-height: 1.15;
            font-weight: 800;
            letter-spacing: -.03em;
        }

        .pn-subtitle {
            margin: 10px 0 0;
            font-size: 12px;
            font-weight: 500;
            opacity: .92;
        }

        .pn-card {
            border: 1px solid rgba(219, 231, 245, .95) !important;
            border-radius: 22px !important;
            background: rgba(255, 255, 255, .94) !important;
            box-shadow: var(--pn-soft-shadow) !important;
            margin-bottom: 24px;
            overflow: hidden;
        }

        .pn-card:hover {
            transform: none !important;
        }

        .pn-card .card-body {
            padding: 22px 24px 24px !important;
        }

        .pn-section-title {
            display: inline-flex;
            align-items: center;
            gap: 9px;
            margin-bottom: 18px;
            color: #0f172a;
            font-size: 14px;
            font-weight: 800;
            letter-spacing: .01em;
        }

        .pn-section-title i {
            width: 30px;
            height: 30px;
            display: grid;
            place-items: center;
            border-radius: 10px;
            color: #1d4ed8;
            background: #eaf2ff;
            font-size: 16px;
        }

        .main-container {
            width: 100%;
            padding: 0;
        }

        .my-row {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 18px;
            align-items: end;
            width: 100%;
            margin-bottom: 20px;
        }

        .my-col-3,
        .my-col-12 {
            width: 100%;
            padding-right: 0;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #475569;
            font-size: 12px;
            font-weight: 700;
        }

        .req {
            color: #ef4444;
            font-weight: 900;
            margin-left: 3px;
        }

        .my-input,
        .my-select,
        .form-control,
        .form-select {
            width: 100%;
            min-height: 44px;
            border: 1px solid var(--pn-border) !important;
            border-radius: 13px !important;
            padding: 9px 13px !important;
            color: #0f172a;
            background-color: #fff !important;
            font-size: 13px;
            font-weight: 600;
            box-shadow: 0 1px 2px rgba(15, 23, 42, .03);
            transition: border-color .2s ease, box-shadow .2s ease, transform .2s ease;
        }

        .my-input:focus,
        .my-select:focus,
        .form-control:focus,
        .form-select:focus {
            border-color: #60a5fa !important;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, .12) !important;
            outline: none;
        }

        textarea.my-input {
            min-height: 80px;
            resize: none;
        }

        .btn,
        .my-btn {
            border-radius: 13px !important;
            border: 0 !important;
            font-weight: 800 !important;
        }

        .btn-gradient-primary,
        .primary {
            height: 44px;
            min-height: 44px;
            border-radius: 13px !important;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%) !important;
            color: #fff !important;
            box-shadow: 0 12px 26px rgba(37, 99, 235, .25);
            transition: transform .2s ease, box-shadow .2s ease, filter .2s ease;
        }

        .btn-gradient-primary:hover,
        .primary:hover {
            transform: translateY(-2px);
            filter: brightness(1.03);
            box-shadow: 0 16px 34px rgba(37, 99, 235, .32);
            color: #fff !important;
        }

        .btn-gradient-success,
        .success {
            background: linear-gradient(120deg, #16a34a, #22c55e) !important;
            color: #fff !important;
        }

        .warning {
            background: linear-gradient(120deg, #f59e0b, #f97316) !important;
            color: #fff !important;
        }

        .pn-table-wrap {
            width: 100%;
            overflow-x: auto;
            border-radius: 18px;
            background: #fff;
        }

        .top {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 14px;
            flex-wrap: wrap;
        }

        .dataTables_length {
            margin-right: 0;
            color: var(--pn-muted);
            font-size: 13px;
            font-weight: 600;
        }

        .dataTables_length select,
        .dataTables_filter input {
            height: 38px;
            border: 1px solid var(--pn-border) !important;
            border-radius: 12px !important;
            outline: none;
            background: #fff;
        }

        .dt-buttons {
            margin-right: auto;
        }

        .dt-button,
        button.dt-button,
        div.dt-button,
        a.dt-button,
        input.dt-button {
            border: 0 !important;
            border-radius: 13px !important;
            padding: 10px 18px !important;
            background: linear-gradient(120deg, #fb7185, #f472b6) !important;
            color: #fff !important;
            font-weight: 800 !important;
            box-shadow: 0 10px 22px rgba(244, 114, 182, .25) !important;
        }

        .dataTables_filter {
            margin-left: auto;
            float: none !important;
            text-align: right !important;
            color: var(--pn-muted);
            font-size: 13px;
            font-weight: 600;
        }

        .dataTables_filter input {
            margin-left: 8px;
        }

        table.dataTable,
        #table_updatePseudoName {
            width: 100% !important;
            margin: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0 !important;
            color: #0f172a;
            font-size: 12px;
        }

        table.dataTable thead th,
        #table_updatePseudoName thead th {
            border: 0 !important;
            text-align: left;
            font-size: 12px;
            font-weight: 800;
            letter-spacing: .02em;
            vertical-align: middle;
            white-space: nowrap;
        }

        table.dataTable thead th:first-child,
        #table_updatePseudoName thead th:first-child {
            border-top-left-radius: 16px;
        }

        table.dataTable thead th:last-child,
        #table_updatePseudoName thead th:last-child {
            border-top-right-radius: 16px;
        }

        table.dataTable thead th::before,
        table.dataTable thead th::after {
            display: none !important;
        }

        table.dataTable tbody td,
        #table_updatePseudoName tbody td {
            padding: 5px !important;
            border-top: 1px solid #e8eef7 !important;
            vertical-align: middle;
            background: #fff;
        }

        table.dataTable tbody tr:hover td,
        #table_updatePseudoName tbody tr:hover td {
            background: #f8fbff !important;
        }

        table.dataTable.no-footer {
            border-bottom: 0 !important;
        }

        .dataTables_info,
        .dataTables_paginate {
            margin-top: 14px;
            color: var(--pn-muted) !important;
            font-size: 13px;
            font-weight: 600;
        }

        .dataTables_paginate .paginate_button {
            border: 1px solid var(--pn-border) !important;
            border-radius: 11px !important;
            margin: 0 3px !important;
            color: #334155 !important;
            background: #fff !important;
        }

        .dataTables_paginate .paginate_button.current,
        .dataTables_paginate .paginate_button.current:hover {
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%) !important;
            color: #fff !important;
            border-color: transparent !important;
        }

        #filter_rows input {
            width: 100%;
            height: 32px;
            padding: 5px 100px;
            font-size: 12px;
            box-sizing: border-box;
        }

        #filter_row input,
        #filter_row select {
            height: 30px;
            font-size: 12px;
            padding: 5px 100px;
            border-radius: 10px;
            border: 1px solid var(--pn-border);
        }

        #filter_row {
            background-color: #f8fbff;
        }

        .modal-content {
            border: 0;
            border-radius: 22px;
            box-shadow: var(--pn-shadow);
            overflow: hidden;
        }

        .modal-header {
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%);
            border-bottom: 0;
        }

        .modal-title {
            font-weight: 800;
        }

        .modal-footer {
            border-top: 1px solid var(--pn-border);
        }

        .loading {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            opacity: .95;
            border-radius: 24px;
            width: 192px;
            min-height: 192px;
            z-index: 99999;
            padding: 18px;
            text-align: center;
            background: rgba(255, 255, 255, .92);
            box-shadow: var(--pn-shadow);
        }

        @media (max-width: 992px) {
            .my-row {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 576px) {
            .pn-page {
                padding: 16px 12px 28px;
            }

            .pn-hero {
                align-items: flex-start;
                padding: 22px;
            }

            .pn-title {
                font-size: 24px;
            }

            .my-row {
                grid-template-columns: 1fr;
            }

            .top,
            .dataTables_filter {
                width: 100%;
                text-align: left !important;
            }
        }
</style>

    <script>
        $(document).ready(function () {

            bindEmployee();
            bindPseudoNameGrid();

        });
    </script>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="pn-page">
        <section class="pn-hero">
            <div class="pn-hero-icon"><i class="fas fa-copy"></i></div>
            <div class="pn-hero-content">
                <h1 class="pn-title">Update Pseudo Name</h1>
                <p class="pn-subtitle">Assign and maintain employee pseudo names with location details.</p>
            </div>
        </section>

        <div class="col-lg-12 p-0">
            <div>
       

            <div class="card pn-card sla-card">
                <div class="card-body">
                    <div class="pn-section-title"><i class="bi bi-person-badge"></i><span>Pseudo Name Details</span></div>
                    <div class="main-container">
                        <div class="my-row">
                            <div class="my-col-3">
                                <label>Employee<b><span class="req">*</span></b></label>
                                <select id="pseudoName_Employee" name="pseudoName_Employee" onchange="return displayCompany(this);" class="my-select">
                                    <option value="Select">Select</option>
                                </select>
                            </div>

                            <div class="my-col-3">
                                <label>Pseudo Name<b><span class="req">*</span></b></label>
                                <input type="text" id="pseudoName_Name" name="pseudoName_Name" class="my-select" />
                            </div>

                            <div class="my-col-3">
                                <label>Location<span class="req"></span></label>
                                <select id="pseudoName_Location" name="pseudoName_Location" class="my-select">
                                    <option value="Select">Select Location</option>
                                    <option value="Akola">Akola</option>
                                    <option value="Mumbai">Mumbai</option>
                                    <option value="Pune">Pune</option>
                                    <option value="Solapur">Solapur</option>
                                    <option value="Philippines">Philippines</option>
                                    <option value="India Remote Employee">India Remote Employee</option>
                                    <option value="India Remote Vendor">India Remote Vendor</option>
                                    <option value="India Ex-Employee">India Ex-Employee</option>
                                    <option value="India Remote Employee B'lore">India Remote Employee B'lore</option>
                                    <option value="India Remote Employee Chennai">India Remote Employee Chennai</option>
                                    <option value="US Remote Employee">US Remote Employee</option>
                                    <option value="US Remote Vendor">US Remote Vendor</option>
                                </select>
                            </div>

                            <div class="my-col-3">
                                <label><b><span class="req"></span></b></label>
                                <button type="submit" id="pseudoName_btn" class="btn btn-gradient-primary w-100" onclick="return pseudoName_submit();"><i class="bi bi-arrow-repeat"></i>&nbsp; Update</button>
                            </div>
                        </div>
                        <div class="my-row" id="tdcompField" style="display: none;">
                            <div class="my-col-3">
                                <label>Company<b><span class="req">*</span></b></label>
                                <input type="text" id="pseudoName_Company" name="pseudoName_Company" class="my-select" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card pn-card">
                <div class="card-body">
                    <div class="pn-section-title"><i class="bi bi-table"></i><span>Pseudo Name List</span></div>
                    <div class="pn-table-wrap">
                        <table class="table" id="table_updatePseudoName" style="padding-top: 10px; width: 100%;">
                            <thead>
                                <tr>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center; width: 70px;">Action</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center; width: 150px;">Sr. #</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; display: none;">EmpConfigrationID</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; width: 120px;">Location</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; width: 100px;">Code</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Employee Name</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Psuedo Name</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added By</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added DateTime</th>
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

    <div class="modal fade" id="popup_ChangeLocation">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Change Location</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table" style="font-size: 12px;">
                        <tr>
                            <td>
                                <label id="popup_EmpName" name="popup_EmpName" class="form-control" style="width: 350px;"></label>
                            </td>
                            <td>
                                <label id="popup_PseudoName" name="popup_PseudoName" class="form-control" style="width: 200px;"></label>
                            </td>
                            <td>
                                <label id="popup_PrevLocation" name="popup_PrevLocation" class="form-control" style="width: 200px;"></label>
                            </td>
                        </tr>
                    </table>
                    <table class="table">
                        <tr>
                            <td>
                                <b>New Location :</b>
                            </td>
                            <td>
                                <select id="popUp_NewLocation" name="pseudoName_Location" class="form-control" style="width: 300px;">
                                    <option value="Select">Select</option>
                                    <option value="Akola">Akola</option>
                                    <option value="Mumbai">Mumbai</option>
                                    <option value="Pune">Pune</option>
                                    <option value="Solapur">Solapur</option>
                                    <option value="Philippines">Philippines</option>
                                    <option value="India Remote Employee">India Remote Employee</option>
                                    <option value="India Remote Vendor">India Remote Vendor</option>
                                    <option value="India Ex-Employee">India Ex-Employee</option>
                                    <option value="India Remote Employee B'lore">India Remote Employee B'lore</option>
                                    <option value="India Remote Employee Chennai">India Remote Employee Chennai</option>
                                    <option value="US Remote Employee">US Remote Employee</option>
                                    <option value="US Remote Vendor">US Remote Vendor</option>
                                </select>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button class="btn btn-primary" type="button" id="ac_btnApprove" onclick="ac_ApprvoveCost();">Approve</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>
