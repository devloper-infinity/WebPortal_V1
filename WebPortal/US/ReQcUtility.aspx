<%@ Page Title="" Language="C#" MasterPageFile="~/US/USAdmin.Master" AutoEventWireup="true" CodeBehind="ReQcUtility.aspx.cs" Inherits="WebPortal.US.ReQcUtility" %>

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
    </style>
    <script>
        $(document).ready(function () {
            //bindSummary_Grid(10);
            //bindLoan_Grid(10);
        });

        window.onload = function () {
            document.getElementById('reqcUtility_attachment').addEventListener('change', getFileName);
        }

        const getFileName = (event) => {
            const files = event.target.files;
            var file = files[0];
            document.getElementById("file_reqcUtility").value = files[0].name;

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
            //document.getElementById("dropzone").classList.add("dz-max-files-reached");
            //document.getElementById("conentdiv").style.display = '';
            //document.getElementById("importSercfilesdiv").innerHTML = file.name;
        }
    </script>

    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.2/css/buttons.dataTables.min.css">
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/dataTables.buttons.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.html5.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
    <script src="https://cdn.sheetjs.com/xlsx-latest/package/dist/xlsx.full.min.js"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="file_reqcUtility" style="display: none;" />

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>ReQC Utility</b></h6>
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
                        <td style="font-size: 14px;">
                            <b>Re-QC % :</b>
                        </td>
                        <td>
                            <input type="text" name="reqcUtility_perc" id="reqcUtility_perc" class="form-control" style="width: 250px;" />
                        </td>
                        <td style="font-size: 14px;"><b>Excel:</b></td>
                        <td>
                            <input type="file" id="reqcUtility_attachment" name="reqcUtility_attachment" class="form-control" style="width: 250px;" />
                        </td>
                        <td>
                            <button type="button" id="reqcUtility_Import" class="btn btn-primary" onclick="return btnreqcUtility_Import();">Import Data</button>
                            &nbsp;&nbsp;
                            <button type="button" id="reqcUtility_GetFiles" onclick="return btnreqcUtility_Import();" class="btn btn-primary">Re-Calculate</button>
                            &nbsp;&nbsp;
                            <button type="button" id="reqcUtility_ExportToExcel" onclick="return btnreqcUtility_ExportToExcel();" class="btn btn-primary">Export To Excel</button>

                        </td>
                        <td>
                            <a href="ReQcUtility.xlsx" style="font-family: Verdana; font-size: 12px; font-weight: bold; color: blue;">Download Format</a>
                        </td>
                    </tr>
                </table>
                <hr />
                <div class="row">
                    <div class="col-lg-4">
                        <div class="card card-primary card-outline">
                            <div class="card-header">
                                <%-- <div class="card-title">
                                    <i class="fas fa-edit"></i>--%>
                                <h6>Summary :<label id="reqcUtility_Summary"></label></h6>
                                <hr />
                                <table class="table table-bordered" style="width: 100%; font-size: 11px;" id="table_reQcsummary">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center; width: 150px;">QC</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Loan Count</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">ReQc Loans</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                                <%-- </div>--%>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-8">
                        <div class="card card-primary card-outline">
                            <div class="card-header">
                                <%--  <div class="card-title">--%>
                                <%-- <i class="fas fa-edit"></i>--%>
                                <h6>Loan Details :<label id="reqcUtility_LoanDetails"></label></h6>
                                <table class="table table-bordered" style="width: 100%; font-size: 11px;" id="table_reQcLoanDetails">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Deal #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Loan #-1</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Loan #-2</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center; width: 150px;">Review</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center; width: 150px;">QC</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Review Status</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Random #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Total Loans</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                        <%-- </div>--%>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="reqc_popUp_Waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">System is updating details. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>

</asp:Content>
