<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="OnlineTrackingSheet.aspx.cs" Inherits="WebPortal.Admin.OnlineTrackingSheet" %>

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
        /*.form-control {
            font-size: 11px !important;
        }*/
    </style>
    <script>
        $(document).ready(function () {
            otsheet_bindprojects();
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Online Tracking Sheet</b></h6>
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
                        <td><b>Project #:</b></td>
                        <td>
                            <select id="otsheet_project" name="otsheet_project" class="form-control" style="width: 250px;"></select>
                        </td>
                        <td><b>From Date:</b></td>
                        <td>
                            <input type="date" id="otsheet_from" name="otsheet_from" class="form-control" style="width: 250px;" />
                        </td>
                        <td><b>To Date:</b></td>
                        <td>
                            <input type="date" id="otsheet_to" name="otsheet_to" class="form-control" style="width: 250px;" />
                        </td>
                        <td>
                            <button type="button" id="otsheet_btnsubmit" name="otsheet_btnsubmit" class="btn btn-primary" onclick="return otsheet_submit();">Show</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <table class="table" id="otsheet_table" style="padding-top: 10px; width: 100%;">
                </table>
            </div>
        </div>
    </div>
</asp:Content>
