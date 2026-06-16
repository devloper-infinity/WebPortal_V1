<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ServicingUWAnswerSheet.aspx.cs" Inherits="WebPortal.Admin.ServicingUWAnswerSheet" %>
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
        $(document).ready(function () {
            crser_ans_BindGrid();
            crser_ans_BindHeader();
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Servicing Underwriting Test > Answer Sheet</b></h6>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right" style="font-size: 12px; font-weight: bold;">
                        <li class="breadcrumb-item"><a href="#utl" id="aBack" runat="server" style="color: saddlebrown" onclick="window.history.go(-1); return false;"><< Go back </a></li>

                    </ol>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <div class="card card-primary card-outline">
                    <div class="card-header">
                        <div class="card-title">
                            <i class="fas fa-edit"></i>
                            Exam Details:
                        </div>
                    </div>
                    <table class="table">
                        <tr>
                            <td><b>Name:</b></td>
                            <td>
                                <label id="crser_ans_name" class="form-control" style="width: 300px;"></label>
                            </td>
                            <td><b>Exam Date:</b></td>
                            <td>
                                <label id="crser_ans_examdate" class="form-control" style="width: 300px;"></label>
                            </td>
                            <td><b>Marks Obtained:</b></td>
                            <td>
                                <label id="crser_ans_marks" class="form-control" style="width: 300px;"></label>
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td></td>
                            <td><b style="font-size:14px;">Result:</b></td>
                            <td>
                                <label id="answerser_result" class="form-control" style="width: 300px; font-size:14px;"></label>
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                    </table>
                </div>
                <div class="card card-primary card-outline">
                    <div class="card-header">
                        <div class="card-title">
                            <i class="fas fa-edit"></i>
                            Answer Sheet:
                        </div>
                    </div>
                    <table class="table" id="crser_ans_table" style="width: 100%;">
                        <thead>
                            <tr>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Question</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Answer by Candidate</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Corrent Answer</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Weightage</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Marks</th>
                            </tr>
                        </thead>
                        <tbody></tbody>

                    </table>
                </div>

            </div>
        </div>
    </div>
</asp:Content>
