<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="StampPaperInvoice.aspx.cs" Inherits="WebPortal.Admin.StampPaperInvoice" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%--  <style>
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
    </style>--%>

    <style>
        .btn-gradient-primary {
            background: linear-gradient(135deg, #2563eb, #06b6d4);
            color: #fff;
            border-radius: 12px;
            height: 40px;
            font-weight: 400;
            transition: 0.3s;
        }

            .btn-gradient-primary:hover {
                transform: translateY(-2px);
                color: #fff;
            }

        .btn-gradient-success {
            background: linear-gradient(to right, #ffbf96, #fe7096);
            color: #fff;
            border-radius: 12px;
            height: 40px;
            width: 60%;
            font-weight: 400;
            transition: 0.3s;
        }

            .btn-gradient-success:hover {
                transform: translateY(-2px);
                color: #fff;
            }
    </style>
        <style>
        .dashboard-header {
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            border-radius: 15px;
            padding: 12px;
            color: white;
            position: relative;
            overflow: hidden;
            margin-bottom: 25px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        }

            .dashboard-header::after {
                content: '';
                position: absolute;
                right: -70px;
                top: -50px;
                width: 220px;
                height: 220px;
                background: rgba(255,255,255,0.12);
                border-radius: 50%;
            }

        .dashboard-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .dashboard-subtitle {
            font-size: 12px;
            opacity: 0.9;
            /*text-transform: uppercase;*/
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:UpdatePanel ID="up1" runat="server">
        <ContentTemplate>
            <asp:Button ID="btnStampInvoice" runat="server" OnClick="btnStampInvoice_Click" Style="display: none;" />
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnStampInvoice" EventName="Click" />
        </Triggers>
    </asp:UpdatePanel>
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="dashboard-header">
        <div class="d-flex justify-content-between align-items-start mb-1">
            <div>
                <div class="dashboard-title">
                     <i class="fas fa-file-invoice-dollar"></i>&nbsp;&nbsp;
                    Stamp Paper Invoice
                </div>

                <div class="dashboard-subtitle">
                    Track and manage stamp paper invoice records and payments.
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <%--    <table class="table">
                    <tr>
                        <td><b>From Date:</b></td>
                        <td>
                            <input type="date" id="stampinvoice_fromdate" name="stampinvoice_fromdate" max="2999-12-31" class="form-control" style="width: 120px;" />
                        </td>
                        <td><b>To Date:</b></td>
                        <td>
                            <input type="date" id="stampinvoice_todate" name="stampinvoice_todate" max="2999-12-31" class="form-control" style="width: 120px;" />
                        </td>
                        <td><b>Voucher #:</b></td>
                        <td>
                            <input type="text" id="stampinvoice_voucherno" name="stampinvoice_voucherno" class="form-control" style="width: 120px;" />
                        </td>
                        <td><b>Voucher Date:</b></td>
                        <td>
                            <input type="date" id="stampinvoice_voucherdate" name="stampinvoice_voucherdate" max="2999-12-31" class="form-control" style="width: 120px;" />
                        </td>
                        <td>
                            <button id="stampinvoice_btnsubmit" class="btn btn-primary" onclick="return stampinvoice_submit();">Show</button>
                        </td>
                    </tr>
                </table>--%>
                <div class="row g-3 align-items-end">
                    <div class="col-md-2">
                        <label for="stampinvoice_fromdate" class="form-label fw-bold">From Date</label>
                        <input type="date" id="stampinvoice_fromdate" name="stampinvoice_fromdate" max="2999-12-31" class="form-control">
                    </div>

                    <div class="col-md-2">
                        <label for="stampinvoice_todate" class="form-label fw-bold">To Date</label>
                        <input type="date" id="stampinvoice_todate" name="stampinvoice_todate" max="2999-12-31" class="form-control">
                    </div>

                    <div class="col-md-2">
                        <label for="stampinvoice_voucherno" class="form-label fw-bold">Voucher #</label>
                        <input type="text" id="stampinvoice_voucherno" name="stampinvoice_voucherno" class="form-control">
                    </div>

                    <div class="col-md-2">
                        <label for="stampinvoice_voucherdate" class="form-label fw-bold">Voucher Date</label>
                        <input type="date" id="stampinvoice_voucherdate" name="stampinvoice_voucherdate" max="2999-12-31" class="form-control">
                    </div>

                    <div class="col-md-2">
                        <button id="stampinvoice_btnsubmit" class="btn btn-gradient-primary w-100" onclick="return stampinvoice_submit();">Show</button>
                    </div>
                    <div class="col-md-2">
                        <button id="btnExport" class="btn btn-gradient-success w-100" onclick="return getExportedExcel();">Export Excel</button>
                    </div>
                </div>
                <hr />

                <table class="table table-bordered" id="stampinvoice_table" style="width: 100%;">
                    <thead>
                        <tr>
                            <th colspan="3" style="text-align: center;">
                                <label style="font-weight: bold!important;">INFINITY DATA TECHNOLOGIES PVT. LTD.</label></th>
                            <th colspan="5" style="text-align: center;">
                                <label style="font-weight: bold!important;" id="stampinvoice_lblinvoiceno"></label>
                            </th>
                            <th colspan="3" style="text-align: center;">Date:
                                <label style="font-weight: bold!important;" id="stampinvoice_lblinvoicedate"></label>
                            </th>
                        </tr>
                        <tr>
                            <th colspan="3" style="text-align: center;"></th>
                            <th colspan="2" style="text-align: center;">
                                <label style="font-weight: bold!important;">Joining</label>
                            </th>
                            <th style="text-align: center;">
                                <label style="font-weight: bold!important;">Exit</label>
                            </th>
                            <th colspan="2" style="text-align: center;"></th>
                            <th colspan="3" style="text-align: center;"></th>
                        </tr>
                        <tr>
                            <th style="text-wrap: nowrap;">Branch</th>
                            <th style="text-wrap: nowrap;">Code</th>
                            <th style="text-wrap: nowrap;">Name</th>
                            <th style="text-wrap: nowrap;">Agreement</th>
                            <th style="text-wrap: nowrap;">Addendum</th>
                            <th style="text-wrap: nowrap;">Undertaking</th>
                            <th style="text-wrap: nowrap;">No. of Stamps Used</th>
                            <th style="text-wrap: nowrap;">Cost</th>
                            <th style="text-wrap: nowrap;">Dept./Design</th>
                            <th style="text-wrap: nowrap;">Version</th>
                            <th style="text-wrap: nowrap;">Stamp Paper #</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>

            </div>
        </div>
    </div>
</asp:Content>
