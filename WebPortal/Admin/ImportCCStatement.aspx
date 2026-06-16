<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ImportCCStatement.aspx.cs" Inherits="WebPortal.Admin.ImportCCStatement" %>

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
        window.onload = function () {
            document.getElementById('import_attach').addEventListener('change', getFileName);
        }
        const getFileName = (event) => {
            const files = event.target.files;
            var file = files[0];
            document.getElementById("filep_import").value = files[0].name;

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
            document.getElementById("dropzone").classList.add("dz-max-files-reached");
            document.getElementById("conentdiv").style.display = '';
            document.getElementById("filesdivimport").innerHTML = file.name;
        }


        $(document).ready(function () {
            BindYear_Import();

        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <input id="filep_import" style="display: none;" />
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Import Credit Card Statement</b></h6>
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
                            <select id="import_month" name="import_month" class="form-control">
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
                            <select id="import_year" name="import_year" class="form-control">
                                <option value="">Select</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Attachment:</b></td>
                        <td>
                            <input type="file" id="import_attach" name="import_attach" class="form-control" />
                            <div class="dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete" id="dropzone">
                                <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column" id="conentdiv" style="display: none!important;">
                                    <div class="flex-1 d-flex flex-between-center">
                                        <div id="filesdivimport" style="margin-top: 10px; margin-bottom: 10px;"></div>
                                        <div class="dropdown font-sans-serif">
                                            <button class="btn btn-link text-600 btn-sm dropdown-toggle btn-reveal dropdown-caret-none" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                <svg class="svg-inline--fa fa-ellipsis" style="display: none!important" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="ellipsis" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg="">
                                                    <path fill="currentColor" d="M120 256C120 286.9 94.93 312 64 312C33.07 312 8 286.9 8 256C8 225.1 33.07 200 64 200C94.93 200 120 225.1 120 256zM280 256C280 286.9 254.9 312 224 312C193.1 312 168 286.9 168 256C168 225.1 193.1 200 224 200C254.9 200 280 225.1 280 256zM328 256C328 225.1 353.1 200 384 200C414.9 200 440 225.1 440 256C440 286.9 414.9 312 384 312C353.1 312 328 286.9 328 256z"></path></svg><!-- <span class="fas fa-ellipsis-h"></span> Font Awesome fontawesome.com --></button>
                                            <div class="dropdown-menu dropdown-menu-end border py-2"><a class="dropdown-item" href="#!" data-dz-remove="data-dz-remove">Remove File</a></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </td>
                        <td></td>
                        <td style="width: 100px;">
                            <button id="btnShow" class="btn btn-primary" onclick="return ImportCCStatement();">Import</button>
                            <button id="btnccverify" class="btn btn-primary" onclick="return VerifyCCStatement();">Verify and Submit</button>
                        </td>
                    </tr>
                </table>
                <hr />
                
                <table class="table" id="invVerification" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top" style="text-wrap: nowrap; display: none;">VerID</th>
                            <th class="sort border-top" style="text-wrap: nowrap; display: none;">HeaderID</th>
                            <%--<th class="sort border-top" style="text-wrap: nowrap;">Header</th>--%>
                            <th class="sort border-top" style="text-wrap: nowrap;">Select</th>

                            <th class="sort border-top" style="text-wrap: wrap;">System Remark</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Header</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Product</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Statement Header</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Invoice #</th>
                            <th class="sort border-top" style="text-wrap: wrap; text-align: center;">Contractual Cost</th>
                            <th class="sort border-top" style="text-wrap: wrap; text-align: center;">Statement Amount</th>
                            <th class="sort border-top" style="text-wrap: wrap; text-align: center;">Invoice Amount</th>
                            <th class="sort border-top" style="text-wrap: wrap;">Difference</th>

                            <%--<th class="sort border-top" style="text-wrap: nowrap;">Pay To</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Payment Frequency</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Cost Type</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Remark</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Invoice Attachment</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Utilization</th>
                            <th class="sort border-top" style="text-wrap: nowrap; display: none;">Provider</th>
                            <th class="sort border-top" style="text-wrap: nowrap; display: none;">Product</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Update</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">CC #</th>--%>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>


</asp:Content>
