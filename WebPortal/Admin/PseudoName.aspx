<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="PseudoName.aspx.cs" Inherits="WebPortal.Admin.PseudoName" %>

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

        .dataTables_scrollBody {
            min-height: 100px !important;
            height: auto;
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
    </style>--%>

    <style>
        .main-container {
            width: 100%;
            padding: 15px 25px;
        }

        /* Custom Grid */
        .my-row {
            display: flex;
            flex-wrap: wrap;
            margin-bottom: 15px;
            width: 100%;
        }

        .my-col-3 {
            width: 25%;
            padding-right: 15px;
        }

        .my-col-12 {
            width: 100%;
        }

        .my-input:focus, .my-select:focus {
            border-color: #b5d3ff;
            box-shadow: 0 0 4px rgba(181, 211, 255, 0.6);
            outline: none;
        }
        /* Inputs */
        .my-input, .my-select {
            width: 100%;
            height: 40px;
            border: 1px solid #dcdcdc;
            padding: 6px;
            border-radius: 5px;
            font-size: 12px;
            background-color: #fff;
            transition: all 0.2s ease;
        }

        textarea.my-input {
            height: 70px;
            resize: none;
        }

        label {
            font-size: 12px;
            margin-bottom: 4px;
            display: block;
        }

        .my-btn {
            padding: 6px 18px;
            border-radius: 4px;
            border: none;
            color: #fff;
            font-size: 14px;
            margin-right: 8px;
        }

        .primary {
            background: #2f7ed8;
        }

        .success {
            background: #28a745;
        }

        .warning {
            background: #f0ad4e;
        }

        .my-btn:hover {
            opacity: 0.9;
        }

        .req {
            color: red;
            font-weight: bold;
            margin-left: 3px;
        }

        .top {
            display: flex;
            align-items: center;
        }

        .dataTables_length {
            margin-right: 10px;
        }

        .dt-buttons {
            margin-right: auto;
        }

    /*    .dataTables_filter {
            margin-left: auto;
        }*/

        .dataTables_filter {
            float: right !important;
            text-align: right !important;
        }

            .dataTables_filter input {
                margin-left: 5px;
            }


        .card {
            transition: 0.3s ease;
        }

            .card:hover {
                transform: translateY(-3px);
            }

        .btn {
            border-radius: 10px;
            font-weight: 400;
        }

        .form-select {
            border-radius: 10px;
        }

        h5, h6 {
            letter-spacing: 0.5px;
        }

        .btn-gradient-primary {
            /* background: linear-gradient(135deg, #4e73df, #224abe);*/
            background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;
            color: #fff;
            border-radius: 12px;
            height: 40px;
            font-weight: 400;
            transition: 0.3s;
        }

            .btn-gradient-primary:hover {
                transform: translateY(-2px);
                background: linear-gradient(135deg, #224abe, #1a3a8f);
                color: #fff;
            }

        .btn-gradient-success {
            background: linear-gradient(135deg, #1cc88a, #13855c);
            color: #fff;
            border-radius: 12px;
            height: 50px;
            width: 60%;
            font-weight: 400;
            transition: 0.3s;
        }

            .btn-gradient-success:hover {
                transform: translateY(-2px);
                color: #fff;
            }

        table.dataTable thead th::before,
        table.dataTable thead th::after {
            display: none !important;
        }

        #filter_rows input {
            width: 100%;
            height: 30px;
            padding: 3px;
            font-size: 12px;
            box-sizing: border-box;
        }


        #filter_row input,
        #filter_row select {
            /* width: 100%;*/
            height: 22px;
            font-size: 12px;
            padding: 4px;
            border-radius: 4px;
            border: 1px solid #ced4da;
        }

        #filter_row {
            background-color: #f8f9fa;
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
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Update Pseudo Name</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>

    <div class="col-lg-12">
        <div class="card">
            <%-- <div class="card-body">--%>

            <%-- <table class="table">
                    <tr>
                        <td>
                            <b>Employee :</b>
                        </td>
                        <td>
                            <select id="pseudoName_Employee" name="pseudoName_Employee" onchange="return displayCompany(this);" class="form-control" style="width: 300px;">
                                <option value="Select">Select</option>
                            </select>
                        </td>
                        <td>
                            <b>Pseudo Name :</b>
                        </td>
                        <td>
                            <input type="text" id="pseudoName_Name" name="pseudoName_Name" class="form-control" style="width: 300px;" />
                        </td>
                        <td id="tdcompHeader" style="display: none;">
                            <b>Company :</b>
                        </td>
                        <td id="tdcompField" style="display: none;">
                            <input type="text" id="pseudoName_Company" name="pseudoName_Company" class="form-control" style="width: 300px;" />
                        </td>
                        <td>
                            <b>Location :</b>
                        </td>
                        <td>
                            <select id="pseudoName_Location" name="pseudoName_Location" class="form-control" style="width: 300px;">
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
                            <br />
                        </td>

                    </tr>

                    <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td style="text-align: center;">
                            <button type="button" class="btn btn-primary" onclick="return pseudoName_submit();">Submit</button>
                        </td>
                        <td></td>
                        <td></td>

                    </tr>
                </table>--%>

            <div class="card sla-card">
                <div class="card-body">
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

            <div class="card">
                <div class="card-body">
                    <div style="overflow: auto; height: 600px;">
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
            <%--   </div>--%>
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
