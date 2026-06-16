<%@ Page Title="" Language="C#" MasterPageFile="~/Accounts/Accounts.Master" AutoEventWireup="true" CodeBehind="CreditCardMonthlyTransaction.aspx.cs" Inherits="WebPortal.Accounts.CreditCardMonthlyTransaction" %>

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
        var fileslist = '';
        var fd = new FormData();
        window.onload = function () {
            document.getElementById('addinvoice_attachment').addEventListener('change', getFileName);
            document.getElementById('cancelinvoice_pop_attachment').addEventListener('change', getFileName_cancel);
        }
        const getFileName = (event) => {

            for (var i = 0; i < event.target.files.length; i++) {
                const files = event.target.files;
                var file = files[i];
                document.getElementById("addinvoice_file").value = files[i].name;
                if (fileslist != '')
                    fileslist = fileslist + ' || ' + file.name;
                else
                    fileslist = file.name;
                // add all selected files
                fd.append(event.target.name, file, file.name);
                // create the request

            }
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
            document.getElementById("filesdiv").innerHTML = fileslist;
        }

        const getFileName_cancel = (event) => {

            for (var i = 0; i < event.target.files.length; i++) {
                const files = event.target.files;
                var file = files[i];
                document.getElementById("cancelinvoice_file").value = files[i].name;
                if (fileslist != '')
                    fileslist = fileslist + ' || ' + file.name;
                else
                    fileslist = file.name;
                // add all selected files
                fd.append(event.target.name, file, file.name);
                // create the request

            }
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
            document.getElementById("dropzone_cancel").classList.add("dz-max-files-reached");
            document.getElementById("conentdiv_cancel").style.display = '';
            document.getElementById("filesdiv_cancel").innerHTML = fileslist;
        }

        $(document).ready(function () {
            BindCreditCards();
            addinvoice_bindgrid();
            BindUsedFor();
            BindUsedBy();
            BindCreditCards_Cancel();
        });

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="addinvoice_file" style="display: none;" />
    <input id="cancelinvoice_file" style="display: none;" />
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Credit Card Master</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <div class="card card-tabs">
                    <div class="card-header p-0 pt-1">
                        <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Add Invoice</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">Cancel invoice</a>
                            </li>

                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                                <table class="table">
                                    <tr>
                                        <td><b>Credit Card</b></td>
                                        <td>
                                            <select id="addinvoice_creditcard" name="addinvoice_creditcard" class="form-control" style="width: 250px;"></select>
                                        </td>
                                        <td><b>Used For (Header):</b></td>
                                        <td>
                                            <select id="addinvoice_usedfor" name="addinvoice_usedfor" class="form-control" style="width: 250px;"></select>
                                        </td>
                                        <td><b>Used By:</b></td>
                                        <td>
                                            <select id="addinvoice_usedby" name="addinvoice_usedby" class="form-control" style="width: 250px;"></select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><b>Invoice #:</b></td>
                                        <td>
                                            <input type="text" id="addinvoice_invoiceno" name="addinvoice_invoiceno" class="form-control" style="width: 250px;" />
                                        </td>
                                        <td><b>Invoice Date:</b></td>
                                        <td>
                                            <input type="date" id="addinvoice_invoicedate" name="addinvoice_invoicedate" class="form-control" style="width: 250px;" />
                                        </td>
                                        <td><b>Amount:</b></td>
                                        <td>
                                            <input type="text" id="addinvoice_amount" name="addinvoice_amount" class="form-control" style="width: 250px;" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><b>Currency:</b></td>
                                        <td>
                                            <select type="text" id="addinvoice_currency" name="addinvoice_currency" class="form-control" style="width: 250px;">
                                                <option value="">Select</option>
                                                <option value="USD">USD</option>
                                                <option value="INR">INR</option>
                                            </select>
                                        </td>


                                        <td><b>Paid Date:</b></td>
                                        <td>
                                            <input type="date" id="addinvoice_paiddate" name="addinvoice_paiddate" class="form-control" style="width: 250px;" />
                                        </td>
                                        <td><b>Attachment:</b></td>
                                        <td>
                                            <input type="file" id="addinvoice_attachment" name="addinvoice_attachment" class="form-control" style="width: 250px;" />
                                            <div class="dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete" id="dropzone">
                                                <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column" id="conentdiv" style="display: none!important;">
                                                    <div class="flex-1 d-flex flex-between-center">
                                                        <div id="filesdiv" style="margin-top: 10px; margin-bottom: 10px;"></div>
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
                                    </tr>
                                    <tr>
                                        <td><b>Remark:</b></td>
                                        <td>
                                            <textarea id="addinvoice_remark" name="addinvoice_remark" class="form-control" style="width: 250px;"></textarea>
                                        </td>


                                        <td colspan="4" style="vertical-align: middle;">
                                            <button id="addinvoice_btnsubmit" name="addinvoice_btnsubmit" class="btn btn-primary" onclick="return addinvoice_submit();">Submit</button>
                                        </td>
                                    </tr>
                                </table>
                                <hr />
                                <table class="table" id="addinvoice_mastergrid" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top" style="text-wrap: nowrap; display: none;">Edit</th>
                                            <th class="sort border-top" style="text-wrap: wrap; text-align: center;">Credit Card</th>
                                            <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Used For (Header)</th>
                                            <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Used By</th>
                                            <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Invoice #</th>
                                            <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Invoice Date</th>
                                            <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Amount</th>
                                            <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Currency</th>
                                            <th class="sort border-top" style="text-wrap: wrap; text-align: center;">Paid Date</th>
                                            <th class="sort border-top" style="text-wrap: wrap; text-align: center;">Remark</th>
                                            <th class="sort border-top" style="text-wrap: wrap; text-align: center;">Added By</th>
                                            <th class="sort border-top" style="text-wrap: wrap; text-align: center;">Added Date</th>
                                            <th class="sort border-top" style="text-wrap: wrap; text-align: center; display: none;">Invoice ID</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                                <table class="table">
                                    <tr>
                                        <td><b>Credit Card</b></td>
                                        <td>
                                            <select id="cancelinvoice_creditcard" name="cancelinvoice_creditcard" class="form-control" style="width: 250px;"></select>
                                        </td>
                                        <td><b>From Date:</b></td>
                                        <td>
                                            <input type="date" id="cancelinvoice_from" name="cancelinvoice_from" class="form-control" style="width: 250px;" />
                                        </td>
                                        <td><b>To Date:</b></td>
                                        <td>
                                            <input type="date" id="cancelinvoice_to" name="cancelinvoice_to" class="form-control" style="width: 250px;" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="6" style="text-align: center;">
                                            <button id="cancelinvoice_btnshow" class="btn btn-primary" onclick="return cancelinvoice_show();">Show</button>
                                        </td>
                                    </tr>
                                </table>
                                <hr />
                                <table class="table" id="cancelinvoice_mastergrid" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Edit</th>
                                            <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Used For (Header)</th>
                                            <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Used By</th>
                                            <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Invoice #</th>
                                            <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Invoice Date</th>
                                            <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Amount</th>
                                            <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Currency</th>
                                            <th class="sort border-top" style="text-wrap: wrap; text-align: center;">Paid Date</th>
                                            <th class="sort border-top" style="text-wrap: wrap; text-align: center;">Remark</th>
                                            <th class="sort border-top" style="text-wrap: wrap; text-align: center;">Added By</th>
                                            <th class="sort border-top" style="text-wrap: wrap; text-align: center; display: none;">Invoice ID</th>
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
    </div>

    <div class="modal fade" id="cancelinvoice_popup">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Cancel Invoice</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table">
                        <tr>
                            <td><b>Credit Card:</b></td>
                            <td>
                                <label id="cancelinvoice_pop_ID" name="cancelinvoice_pop_ID" class="form-control" style="width: 250px; display: none;"></label>
                                <label id="cancelinvoice_pop_creditcard" name="cancelinvoice_pop_creditcard" class="form-control" style="width: 250px;"></label>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Refund Amount:</b></td>
                            <td>
                                <input type="text" id="cancelinvoice_pop_refundamount" name="cancelinvoice_pop_refundamount" class="form-control" style="width: 250px; display: inline" />
                                &nbsp;&nbsp;<label id="cancelinvoice_pop_currency" name="cancelinvoice_pop_currency" class="form-control" style="display: inline;"></label>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Credit Amount:</b></td>
                            <td>
                                <input type="text" id="cancelinvoice_pop_creditamount" name="cancelinvoice_pop_creditamount" class="form-control" style="width: 250px;" />
                            </td>
                        </tr>
                        <tr>
                            <td><b>Attachment:</b></td>
                            <td>
                                <input type="file" id="cancelinvoice_pop_attachment" name="cancelinvoice_pop_attachment" class="form-control" style="width: 250px;" />
                                <div class="dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete" id="dropzone_cancel">
                                    <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column" id="conentdiv_cancel" style="display: none!important;">
                                        <div class="flex-1 d-flex flex-between-center">
                                            <div id="filesdiv_cancel" style="margin-top: 10px; margin-bottom: 10px;"></div>
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
                        </tr>
                        <tr>
                            <td><b>Cancellation Remark:</b></td>
                            <td>
                                <textarea id="cancelinvoice_pop_remark" name="cancelinvoice_pop_remark" class="form-control" style="width: 250px;"></textarea>
                            </td>
                        </tr>

                        <tr>
                            <td></td>
                            <td>
                                <button id="cancelinvoice_pop_btncancel" onclick="return cancelinvoice_pop_cancelinvoice();" class="btn btn-primary">Cancel</button>
                                <button type="button" class="btn btn-default" onclick="return cancelinvoice_pop_closeinvoice();">Close</button>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                </div>

            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>
