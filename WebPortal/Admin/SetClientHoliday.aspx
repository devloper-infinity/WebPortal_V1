<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="SetClientHoliday.aspx.cs" Inherits="WebPortal.Admin.SetClientHoliday" %>

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
            background: linear-gradient(to bottom, #007bff, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
        }
    </style>
    <script>
        $(document).ready(function () {
            posh_BindGrid();
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>POSH Qusetion Paper</b></h6>
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
                        <td><b>Client Holiday :</b></td>
                        <td>
                            <select id="clientHoliday_name" name="clientHoliday_name" class="form-control" style="width: 300px;">
                                <option value="Select">Select</option>
                                <option value="MemorialDay">Memorial Day</option>
                                <option value="IndependenceDay">Independence Day</option>
                                <option value="LaborDay">Labor Day</option>
                                <option value="ThanksgivingDay">Thanksgiving Day</option>
                                <option value="ChristmasDay">Christmas Day</option>
                                <option value="NewYearDay">New Year's Day</option>
                            </select>
                        </td>
                        <td>
                            <b>Date :</b>
                        </td>
                        <td>
                            <input type="date" id="clientHoliday_date" name="clientHoliday_date" class="form-control" style="width: 300px;" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
