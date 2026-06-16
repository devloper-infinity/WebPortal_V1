<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AgreementVersionsHistoryReport.aspx.cs" Inherits="WebPortal.Admin.AgreementVersionsHistoryReport" %>

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

        .dataTables_scrollHeadInner {
            width: 100% !important;
        }

        .dataTables_scroll {
            overflow: auto;
        }

        /*.form-control {
            font-size: 11px !important;
        }*/

        .clause-row:first-child .delete-clause {
            display: none;
        }

        #table_agreeVerReport thead th {
            text-align: center !important;
            text-wrap: nowrap !important;
        }

        /*   #table_agreeTypeReport th {
            text-align: center !important;
        }*/
    </style>

    <script>

        $(document).ready(function () {

            bind_AgrVersionReportTable();
            bind_AgrTypeReportTable();

        });

    </script>

    <%--    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>--%>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/exceljs/4.3.0/exceljs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.5/FileSaver.min.js"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">
            One moment, please . . . .
        </div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Agreement Versions Report</b></h6>
                </div>
                <div class="col-sm-6" style="text-align: right;">
                    <a href="AgreementVersionControl.aspx" class="m-0" style="font-size: 13px; text-decoration: underline; margin-right: 100px; font-weight: bold;"><< Back </a>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <button onclick="exportBothTablesToExcel();" class="btn btn-primary">Export Excel</button><%--exportBothTablesToExcel--%>

                <div class="card-header p-0 pt-1">
                    <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist" style="font-weight: bold;">
                        <li class="nav-item">
                            <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Version History</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="custom-tabs-one-excel-tab" data-toggle="pill" href="#custom-tabs-one-excel" role="tab" aria-controls="custom-tabs-one-excel" aria-selected="false">Type History</a>
                        </li>
                    </ul>
                </div>
                <div class="card-body">
                    <div class="tab-content" id="custom-tabs-one-tabContent">
                        <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                            <table class="table" id="table_agreeVerReport" style="width: 100%;"></table>
                        </div>

                        <div class="tab-pane fade" id="custom-tabs-one-excel" role="tabpanel" aria-labelledby="custom-tabs-one-excel-tab">
                            <table class="table" id="table_agreeTypeReport" style="width: 100%">
                                <thead>
                                    <tr>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; width: 90px; text-align: center;">Sr. #</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; width: 300px;">Agreement Type</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; width: 300px;">Minimum Service Commitment Period</th>
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
</asp:Content>
