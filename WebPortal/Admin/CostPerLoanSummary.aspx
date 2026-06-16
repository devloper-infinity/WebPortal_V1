<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="CostPerLoanSummary.aspx.cs" Inherits="WebPortal.Admin.CostPerLoanSummary" %>

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

        .dataTables_paginate {
            float: left !important;
        }

        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dt-buttons {
            display: flex;
            align-items: center;
        }

        .dataTables_wrapper .dataTables_length {
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
        }

        .table.dataTable th {
            /*background:linear-gradient(to bottom, #0070C0, 80%, #ffffff);*/
            background: linear-gradient(to bottom, #cbd0dd, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none;
        }
        /*.form-control {
            font-size: 11px !important;
        }*/

        #cploansum_table thead th.month-group-end {
            border-right: 3px solid #444 !important;
        }

        /* right border for last column of month (second header row + body) */
        #cploansum_table th.month-end,
        #cploansum_table td.month-end {
            border-right: 3px solid #444 !important;
        }

        /* optional polish */
        #cploansum_table thead th {
            text-align: center;
            vertical-align: middle;
            white-space: nowrap;
        }

        /* optional: subtle background per month */
        #cploansum_table th[class^="month-group-"] {
            background-color: #f5f7fa;
            font-weight: 600;
        }

        /* keep alignment clean */
        #cploansum_table thead th {
            text-align: center;
            vertical-align: middle;
        }
    </style>
    <script>
        $(document).ready(function () {

           
            cploansum_bindyear();
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Cost Per Loan</b></h6>
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
                        <td style="width: 50px;">
                            <b>Year:</b>
                        </td>
                        <td style="width: 150px;">
                            <select id="cploansum_year" name="cploansum_year" class="form-control" style="width: 250px;">
                                <option value="">Select</option>
                            </select>
                        </td>
                        <td><b>Domain:</b></td>
                        <td>
                            <select id="cploansum_domain" name="cploansum_domain" class="form-control" style="width: 250px;">
                                <option value="">Select</option>
                                <option value="Credit">Credit</option>
                                <option value="Servicing">Servicing</option>
                            </select>
                        </td>
                        <td>
                            <button id="cploansum_btnShow" class="btn btn-primary" onclick="return cploansum_bindallgrids();">Show</button>&nbsp;
                                            <button id="cploansum_btnExport" class="btn btn-primary" onclick="return cploansum_export();" style="display: none;">Export to excel</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <table class="table table-bordered" style="width: 100%;" id="cploansum_table">
                    <thead></thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
