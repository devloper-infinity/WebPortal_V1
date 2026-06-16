<%@ Page Title="" Language="C#" MasterPageFile="~/IT/Admin.Master" AutoEventWireup="true" CodeBehind="~/IT/InvoiceVerification.aspx.cs" Inherits="WebPortal.IT.InvoiceVerification" %>

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

        const getFileName = (event) => {
            const files = event.target.files;
            var file = files[0];
            document.getElementById("filep_inv").value = files[0].name;

            const fd = new FormData();

            // add all selected files
            fd.append(event.target.name, file, file.name);
            // create the request
            const xhr = new XMLHttpRequest();

            xhr.onload = () => {
                if (xhr.status >= 200 && xhr.status < 300) {
                    // we done!
                }
            };
            var url = window.location.href;
            // path to server would be where you'd normally post the form to
            xhr.open('POST', url, true);
            xhr.send(fd);
        }

        $(document).ready(function () {
            document.getElementById("lbl_LoginEmpID").innerHTML = '<%= HttpContext.Current.User.Identity.Name.ToString() %>';
            //BindInvoiceGrid();
            BindYear_INV();
            socialsite_bindusers();
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="filep_inv" style="display: none;" />
    <label id="lbl_LoginEmpID" style="display: none;"></label>
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Credit Card Reconciliation</b></h6>
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
                            <select id="inv_month" name="inv_month" class="form-control">
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
                            <select id="inv_year" name="inv_year" class="form-control">
                                <option value="">Select</option>
                            </select>
                        </td>
                        <td style="width: 100px;">
                            <button id="btnShow" class="btn btn-primary" onclick="return BindInvoiceGrid();">Show</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <button id="inv_btnupdate" class="btn btn-primary" style="display: none;" onclick="return InsertInvoiceDetails();">Update Data</button>
                <button id="inv_btnaddNewProduct" name="inv_btnaddNewProduct" type="button" class="btn btn-primary" onclick="return addNewProduct();">Add New Product</button>
                <hr />
                <table class="table" id="invtable" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top" style="text-wrap: nowrap; display: none;">HeaderID</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Details</th>
                            <th class="sort border-top" style="text-wrap: nowrap; display: none;">SubHeader</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Header</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Domain</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Product</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Pay To</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Payment Frequency</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Cost Type</th>
                            <th class="sort border-top" style="text-wrap: wrap; text-align: center;">Contractual Quantity</th>
                            <th class="sort border-top" style="text-wrap: wrap; text-align: center;">Contractual Per Unit Cost</th>
                            <th class="sort border-top" style="text-wrap: wrap; text-align: center;">Chargeable Amount</th>
                            <th class="sort border-top" style="text-wrap: wrap; text-align: center;">Prev. Month Charged Amount</th>
                            <th class="sort border-top" style="text-wrap: wrap; text-align: center;">Prev. Month Quantity</th>
                            <th class="sort border-top" style="text-wrap: wrap; text-align: center;">Current Quantity</th>
                            <th class="sort border-top" style="text-wrap: wrap; text-align: center;">Amount Charged</th>
                            <th class="sort border-top" style="text-wrap: wrap;">Difference</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Remark</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Invoice #</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Invoice Attachment</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Utilization</th>
                            <th class="sort border-top" style="text-wrap: nowrap; display: none;">Provider</th>
                            <th class="sort border-top" style="text-wrap: nowrap; display: none;">Product</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Update</th>
                            <%--<th class="sort border-top" style="text-wrap: nowrap;">CC No</th>--%>
                            <th class="sort border-top" style="text-wrap: nowrap;">CC #</th>
                            <th class="sort border-top" style="display: none;">HeaderStatus</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="inv_detailspop">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Details</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <label id="invdetails_headerid" style="display: none;"></label>
                    <button id="invdetails_btnadd" onclick="return invdeatails_addnewuser();" class="btn btn-secondary">Add User</button>
                    <table class="table table-responsive" id="inv_details" style="width: 100%;">
                        <thead>
                            <tr>
                                <th class="sort border-top" style="text-wrap: nowrap; display: none;">Sr. #</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Sr. #</th>
                                <th class="sort border-top" style="text-wrap: nowrap;" id="inv_headername">Number</th>
                                <th class="sort border-top" style="text-wrap: nowrap;" id="inv_headercost">Cost</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Code</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Name</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Pseudoname</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Branch</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Domain</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Current Status</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Remove User</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>

            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>


    <div class="modal fade" id="invdetailspopup_AddUser">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Add New User</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table">
                        <tr>
                            <td><b>Employee:</b></td>
                            <td>
                                <select id="invdetails_users" name="invdetails_users" class="form-control" style="width: 250px;" onchange="return addOtherUser(this);"></select>
                            </td>
                        </tr>
                        <tr id="trOtherUser" style="display: none;">
                            <td>
                                <b>Other :</b>
                            </td>
                            <td>
                                <input type="text" id="invetails_otheruser" name="invetails_otheruser" class="form-control" style="width: 250px;" />
                            </td>
                        </tr>
                        <tr>
                            <td><b>Effective Date:</b></td>
                            <td>
                                <input type="date" id="invetails_effectivedate" name="invetails_effectivedate" class="form-control" style="width: 250px;" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" onclick="return invdetails_closeuser();">Close</button>
                    <button id="invdetails_btnSubmitUser" onclick="return invdetails_SubmitUser();" class="btn btn-primary">Add</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

    <div class="modal fade" id="invdetailspopup_removeUser">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Remove User</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table">
                        <tr>
                            <td><b>Employee:</b></td>
                            <td>
                                <label id="invdetails_InvID" name="invdetails_InvID" class="form-control" style="width: 250px; display: none;"></label>
                                <label id="invdetails_delusers" name="invdetails_delusers" class="form-control" style="width: 250px;"></label>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Effective Date:</b></td>
                            <td>
                                <input type="date" id="invetails_deleffectivedate" name="invetails_deleffectivedate" class="form-control" style="width: 250px;" />
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <button id="invdetails_btnSubmitdelUser" onclick="return invdetails_SubmitdelUser();" class="btn btn-primary">Remove</button>
                                <button type="button" class="btn btn-default" onclick="return invdetails_closedeluser();">Close</button>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                </div>

            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

    <div class="modal fade" id="invdetailspopup_AddNewProduct">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Add New Product</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table">
                        <tr>
                            <td><b>Header:</b></td>
                            <td>
                                <input type="text" id="invdetails_NewProdHeader" name="invdetails_NewProdHeader" class="form-control" style="width: 250px;" />
                            </td>
                            <td>
                                <b>Domain :</b>
                            </td>
                            <td>
                                <input type="text" id="invetails_NewProdDomain" name="invetails_NewProdDomain" class="form-control" style="width: 250px;" />
                            </td>
                        </tr>
                        <tr>
                            <td><b>Product:</b></td>
                            <td>
                                <input type="text" id="invetails_NewProdProduct" name="invetails_NewProdProduct" class="form-control" style="width: 250px;" />
                            </td>

                            <td><b>Pay To:</b></td>
                            <td>
                                <input type="text" id="invdetails_NewProdPayTo" name="invdetails_NewProdPayTo" class="form-control" style="width: 250px;" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <b>Payment Frequency :</b>
                            </td>
                            <td>
                                <select id="invdetails_NewProdPaymentFreq" name="invdetails_NewProdPaymentFreq" class="form-control" style="width: 250px;">
                                    <option value="Select">Select</option>
                                    <option value="Monthly">Monthly</option>
                                    <option value="Yearly">Yearly</option>
                                </select>
                            </td>
                            <td><b>Cost Type:</b></td>
                            <td>
                                <select id="invdetails_NewProdCostType" name="invdetails_NewProdCostType" class="form-control" style="width: 250px;">
                                    <option value="Select">Select</option>
                                    <option value="Variable">Variable</option>
                                    <option value="Fixed">Fixed</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Effective Date:</b></td>
                            <td>
                                <input type="date" id="invdetails_NewProdEffDate" name="invdetails_NewProdEffDate" class="form-control" style="width: 250px;" />
                            </td>
                            <td><b>Contractual Quantity:</b></td>
                            <td>
                                <input type="number" id="invdetails_NewProdContQuantity" name="invdetails_NewProdContQuantity" class="form-control" style="width: 250px;" />
                            </td>
                        </tr>
                        <tr>
                            <td><b>Contractual Per Unit Cost:</b></td>
                            <td>
                                <input type="number" id="invdetails_NewProdContPerUnitCost" name="invdetails_NewProdContPerUnitCost" class="form-control" style="width: 250px;" />
                            </td>
                            <td><b>Chargeable Amount:</b></td>
                            <td>
                                <input type="number" id="invdetails_NewProdCharAmt" name="invdetails_NewProdCharAmt" class="form-control" style="width: 250px;" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button id="invdetails_btnNewProd" type="button" onclick="return invdetails_btnAddNewProd();" class="btn btn-primary">Add Product</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

    <div class="modal fade" id="invdetailspopup_AddEnableDisable">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="invdetails_EnableDisableLbl"></h6>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table">
                        <tr>
                            <td><b>Remark :</b></td>
                            <td>
                                <textarea id="nvdetails_EnableDisableRemark" name="nvdetails_EnableDisableRemark" class="form-control"></textarea>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button id="invdetails_btnEnableDisable" type="button" onclick="return invdetails_btnSetEnableDisable();" class="btn btn-primary">Add Product</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>
