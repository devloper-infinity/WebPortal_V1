<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EmployeeInformation.aspx.cs" Inherits="WebPortal.Admin.EmployeeInformation" %>

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
    <script>
        $(document).ready(function () {
            EmployeeInformationDetails();
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Employee Verification Details</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <table class="table table-bordered" id="empveri_table" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top" style="text-wrap: nowrap;">Code</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Name</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Salary</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Joining Date</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Date of Birth</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Branch</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Domain</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Subdomain</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Process</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Department</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Designation</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Reporting Manager</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Present Address</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Permanent Address</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Contact #</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">ESIC #</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">PF #</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">UAN</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Personal Email</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Official Email</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Current Status</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Resignation Date</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Last Working Date</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Latest Login Date</th>
                        </tr>
                        <tr>
                            <th class="sort border-top" style="text-wrap: nowrap;">Code</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Name</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Salary</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Joining Date</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Date of Birth</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Branch</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Domain</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Subdomain</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Process</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Department</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Designation</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Reporting Manager</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Present Address</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Permanent Address</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Contact #</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">ESIC #</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">PF #</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">UAN</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Personal Email</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Official Email</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Current Status</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Resignation Date</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Last Working Date</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Latest Login Date</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
