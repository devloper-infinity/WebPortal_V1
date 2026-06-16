<%@ Page Title="" Language="C#" MasterPageFile="~/Search/Search.Master" AutoEventWireup="true" CodeBehind="OrderEntry.aspx.cs" Inherits="WebPortal.Search.OrderEntry" %>

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
            /*    background: linear-gradient(to bottom, #007bff, 3%, #fff) !important;*/
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
        /* Tabs container */
        #custom-tabs-one-tab {
            border-bottom: 2px solid #e5e5e5;
        }

            /* Tab links */
            #custom-tabs-one-tab .nav-link {
                color: #6c757d; /*#07cdae*/
                font-weight: 600;
                padding: 12px 20px;
                border: none;
                border-radius: 8px 8px 0 0;
                transition: all 0.3s ease;
                position: relative;
            }

                /* Hover effect */
                #custom-tabs-one-tab .nav-link:hover {
                    color: #007bff;
                    background-color: #f8f9fa;
                }

                /* Active tab */
                #custom-tabs-one-tab .nav-link.active {
                    color: #07cdae;
                    background-color: #ffffff;
                    border-bottom: 3px solid #07cdae;
                }

                /* Smooth underline animation */
                #custom-tabs-one-tab .nav-link::after {
                    content: "";
                    position: absolute;
                    width: 0;
                    height: 3px;
                    bottom: 0;
                    left: 50%;
                    background-color: #07cdae;
                    transition: all 0.3s ease;
                }

                /* Underline animation on hover */
                #custom-tabs-one-tab .nav-link:hover::after {
                    width: 100%;
                    left: 0;
                }

                /* Active underline full width */
                #custom-tabs-one-tab .nav-link.active::after {
                    width: 100%;
                    left: 0;
                }

        /* Tab content card look */
        .tab-content {
            background: #ffffff;
            padding: 20px;
            border-radius: 0 0 10px 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }

        table.dataTable tbody tr.selected-row > td {
            background-color: #84d9d2 !important;
            font-weight: bold;
            color: white;
        }
    </style>

    <script>

        $(document).ready(function () {

            /*document.getElementById("orderentry_btnsubmit").addEventListener("click", orderentry_submit);*/

            OrderEntry_BindProjects();
            OrderEntry_BindState();
            OrderEntry_BindUsers();
            OrderEntry_BindGrid(90);

            // OrderEntry_BindOrderDetails(141405);

            $('#orderentry_btnsubmit').on('click', function () {
                $('#table_orderentry')
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
                     
            $('#orderentry_btnreset_662').on('click', function () {
                $('#orderentry_btnsubmit_662').text('Submit');
            });
        });

    </script>

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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Order Entry</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <div class="card-header p-0 pt-1">
                    <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist" style="font-weight: bold;">
                        <li class="nav-item">
                            <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Single Order Entry</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="custom-tabs-one-excel-tab" data-toggle="pill" href="#custom-tabs-one-excel" role="tab" aria-controls="custom-tabs-one-excel" aria-selected="false">Import Excel</a>
                        </li>
                        <li class="nav-item" style="display: none;">
                            <a class="nav-link" id="custom-tabs-one-662-tab" data-toggle="pill" href="#custom-tabs-one-662" role="tab" aria-controls="custom-tabs-one-662" aria-selected="false">Order Entry - 662-002</a>
                        </li>
                    </ul>
                </div>
                <div class="card-body">
                    <div class="tab-content" id="custom-tabs-one-tabContent">
                        
                        <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                            <table class="table">
                                <tr>
                                    <td><b>Order Date:</b></td>
                                    <td>
                                        <input type="date" id="orderentry_orderdate" name="orderentry_orderdate" class="form-control" style="width: 250px;" />
                                    </td>
                                    <td><b>Received Datetime:</b></td>
                                    <td>
                                        <input type="date" id="orderentry_receiveddate" name="orderentry_receiveddate" class="form-control" style="width: 250px;" />
                                    </td>
                                    <td><b>Order Priority:</b></td>
                                    <td>
                                        <select id="orderentry_orderpriority" name="orderentry_orderpriority" class="form-control" style="width: 250px;">
                                            <option value="">Select</option>
                                            <option value="Normal">Normal</option>
                                            <option value="Rush">Rush</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td><b>Project #:</b></td>
                                    <td>
                                        <select id="orderentry_projectno" name="orderentry_projectno" class="form-control" onchange="return OrderEntry_BindTemplate(this);" style="width: 250px;">
                                        </select>
                                    </td>
                                    <td><b>Client Order #:</b></td>
                                    <td>
                                        <input type="text" id="orderentry_clientorderno" name="orderentry_clientorderno" class="form-control" style="width: 250px;" />
                                    </td>
                                    <td><b>Borrower/ Co-borrower Name:</b></td>
                                    <td>
                                        <input type="text" id="orderentry_borrowername" name="orderentry_borrowername" class="form-control" style="width: 250px;" />
                                    </td>
                                </tr>
                                <tr>
                                    <td><b>Property Address:</b></td>
                                    <td>
                                        <textarea id="orderentry_propertyaddress" name="orderentry_propertyaddress" class="form-control" style="width: 250px;"></textarea>
                                    </td>
                                    <td><b>State:</b></td>
                                    <td>
                                        <select id="orderentry_state" name="orderentry_state" class="form-control" onchange="return OrderEntry_BindCounty(this);" style="width: 250px;">
                                        </select>
                                    </td>
                                    <td><b>County:</b></td>
                                    <td>
                                        <select id="orderentry_county" name="orderentry_county" class="form-control" style="width: 250px;">
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td><b>Product Type:</b></td>
                                    <td>
                                        <select id="orderentry_producttype" name="orderentry_producttype" class="form-control" style="width: 250px;">
                                        </select>
                                    </td>
                                    <td><b>Template:</b></td>
                                    <td>
                                        <select id="orderentry_template" name="orderentry_template" class="form-control" style="width: 250px;">
                                        </select>
                                    </td>
                                    <td><b>Expected TAT:</b></td>
                                    <td>
                                        <select id="orderentry_expectedtat" name="orderentry_expectedtat" class="form-control" style="width: 250px;">
                                            <option value="">Select</option>
                                            <option value="24">24 Hours</option>
                                            <option value="48">48 Hours</option>
                                            <option value="72">72 Hours</option>
                                            <option value="OverNight">OverNight</option>
                                            <option value="Other">Other</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td><b>On/Offline:</b></td>
                                    <td>
                                        <select id="orderentry_onoffline" name="orderentry_onoffline" class="form-control" style="width: 250px;">
                                            <option value="">Select</option>
                                            <option value="Online">Online</option>
                                            <option value="Online-Trace">Online-Trace</option>
                                            <option value="Online-MS">Online-MS</option>
                                            <option value="Offline">Offline</option>
                                            <option value="Offline">Offline</option>
                                            <option value="Online to Offline">Online to Offline</option>
                                            <option value="OnTrace to Offline">On-Trace to Offline</option>
                                        </select>
                                    </td>
                                    <td><b>Exhibit:</b></td>
                                    <td>
                                        <select id="orderentry_exhibit" name="orderentry_exhibit" class="form-control" style="width: 250px;">
                                            <option value="">Select</option>
                                            <option value="Exhibit-B">Exhibit-B</option>
                                            <option value="Exhibit-D">Exhibit-D</option>
                                        </select>
                                    </td>
                                    <td><b>Transaction:</b></td>
                                    <td>
                                        <select id="orderentry_transaction" name="orderentry_transaction" class="form-control" style="width: 250px;">
                                            <option value="">Select</option>
                                            <option value="Refinance">Refinance</option>
                                            <option value="Purchase">Purchase</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td><b>Sales Price:</b></td>
                                    <td>
                                        <input type="text" id="orderentry_salesprice" name="orderentry_salesprice" class="form-control" style="width: 250px;" />
                                    </td>
                                    <td><b>Seller Name:</b></td>
                                    <td>
                                        <input type="text" id="orderentry_sellername" name="orderentry_sellername" class="form-control" style="width: 250px;" />
                                    </td>
                                    <td><b>Client ID:</b></td>
                                    <td>
                                        <input type="text" id="orderentry_clientid" name="orderentry_clientid" class="form-control" style="width: 250px;" />
                                    </td>
                                </tr>
                                <tr>
                                    <td><b>Customer Type:</b></td>
                                    <td>
                                        <select id="orderentry_customertype" name="orderentry_customertype" class="form-control" style="width: 250px;">
                                            <option value="">Select</option>
                                            <option value="NA">NA</option>
                                            <option value="DTO">DTO</option>
                                            <option value="EQUITY">EQUITY</option>
                                            <option value="PostClose">PostClose</option>
                                        </select>
                                    </td>
                                    <td><b>Pin #:</b></td>
                                    <td>
                                        <input type="text" id="orderentry_pinno" name="orderentry_pinno" class="form-control" style="width: 250px;" />
                                    </td>
                                    <td><b>Instruction:</b></td>
                                    <td>
                                        <textarea id="orderentry_instruction" name="orderentry_instruction" class="form-control" style="width: 250px;"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td><b>Attachment:</b></td>
                                    <td>
                                        <input type="file" id="orderentry_attachment" name="orderentry_attachment" class="form-control" style="width: 250px;" />
                                    </td>
                                    <td><b>Searcher:</b></td>
                                    <td>
                                        <select id="orderentry_searcher" name="orderentry_searcher" class="form-control" style="width: 250px;">
                                        </select>
                                    </td>
                                    <td><b>Legal Description:</b></td>
                                    <td>
                                        <textarea id="orderentry_legaldescription" name="orderentry_legaldescription" class="form-control" style="width: 250px;"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="6" style="text-align: center;">
                                        <button type="button" id="orderentry_btnsubmit" class="btn btn-primary" onclick="return orderentry_submit();">Submit</button>
                                        &nbsp;&nbsp;
                                        <button type="button" id="orderentry_btnreset" class="btn btn-primary" onclick="orderentry_reset();" style="display: none;">Reset</button>
                                    </td>
                                </tr>
                            </table>
                            <%--   <hr />--%>
                            <table id="table_orderentry" class="table">
                                <thead>
                                    <tr>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Actions</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Order Date</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Project #</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Order #</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Product Type</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Borrower Name</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center; width: 250p; x">Property Address</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">State</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">County</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Added By</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center; width: 250p;">Added Date</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center; display: none;">OrderID</th>
                                    </tr>
                                </thead>
                            </table>
                        </div>
                        
                        <div class="tab-pane fade" id="custom-tabs-one-excel" role="tabpanel" aria-labelledby="custom-tabs-one-excel-tab">
                            <table class="table">
                                <tr>
                                    <td><b>Excel:</b></td>
                                    <td style="width: 150px;">
                                        <input type="file" id="importorder_attachment" name="importorder_attachment" class="form-control" style="width: 250px;" />
                                    </td>
                                    <td>
                                        <button id="importorder_btnsubmit" class="btn btn-primary" onclick="return importorder_submit();">Import</button>
                                    </td>
                                    <td>
                                        <%--<a href="#url">Download Format</a>--%>
                                        <a href="OSTExcel.xlsx" style="font-family: Verdana; font-size: 11px; font-weight: bold; color: Black;">Download Format</a>
                                    </td>
                                </tr>
                            </table>
                        </div>

                        <div class="tab-pane fade" id="custom-tabs-one-662" role="tabpanel" aria-labelledby="custom-tabs-one-662-tab">
                            <table class="table">
                                <tr>
                                    <td><b>Receiver Datetime:</b></td>
                                    <td>
                                        <input type="datetime" id="orderentry_receiveddate_662" name="orderentry_receiveddate_662" class="form-control" style="width: 250px;" />
                                    </td>
                                    <td><b>Client Order #:</b></td>
                                    <td>
                                        <input type="text" id="orderentry_clientorderno_662" name="orderentry_clientorderno_662" class="form-control" style="width: 250px;" />
                                    </td>
                                    <td><b>Borrower/Co-borrower Name:</b></td>
                                    <td>
                                        <input type="text" id="orderentry_borrowername_662" name="orderentry_borrowername_662" class="form-control" style="width: 250px;" />
                                    </td>
                                </tr>
                                <tr>
                                    <td><b>Seller Name:</b></td>
                                    <td>
                                        <input type="text" id="orderentry_sellername_662" name="orderentry_sellername_662" class="form-control" style="width: 250px;" />
                                    </td>
                                    <td><b>Property Address:</b></td>
                                    <td>
                                        <textarea id="orderentry_propertyaddress_662" name="orderentry_propertyaddress_662" class="form-control" style="width: 250px;"></textarea>
                                    </td>
                                    <td><b>State:</b></td>
                                    <td>
                                        <select id="orderentry_state_662" name="orderentry_state_662" class="form-control" onchange="return OrderEntry662_BindCounty(this);" style="width: 250px;"></select>
                                    </td>
                                </tr>
                                <tr>
                                    <td><b>County:</b></td>
                                    <td>
                                        <select id="orderentry_county_662" name="orderentry_county_662" class="form-control" style="width: 250px;"></select>
                                    </td>
                                    <td><b>Transaction:</b></td>
                                    <td>
                                        <select id="orderentry_loantype_662" name="orderentry_loantype_662" class="form-control" style="width: 250px;">
                                            <option value="">Select</option>
                                            <option value="Refinance">Refinance</option>
                                            <option value="Purchase">Purchase</option>
                                        </select>
                                    </td>
                                    <td><b>Instruction:</b></td>
                                    <td>
                                        <textarea id="orderentry_instruction_662" name="orderentry_instruction_662" class="form-control" style="width: 250px;"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="6" style="text-align: center;">
                                        <button type="submit" id="orderentry_btnsubmit_662" class="btn btn-primary" onclick="return orderentry_submit_662();">Submit</button>
                                        &nbsp;&nbsp;
                                        <button type="reset" id="orderentry_btnreset_662" class="btn btn-primary">Reset</button>
                                    </td>
                                </tr>
                            </table>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="orderentry_deleteOrder">
        <div class="modal-dialog modal-l">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Delete Order</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">

                    <p style="font-size: 15px;">Are you sure you want to delete order?</p>

                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
                    <button class="btn btn-primary" type="button" id="orderentry_btnYes" onclick="return orderentry_deleteOrder();">Yes</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>
