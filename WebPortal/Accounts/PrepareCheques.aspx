<%@ Page Title="" Language="C#" MasterPageFile="~/Accounts/Accounts.Master" AutoEventWireup="true" CodeBehind="PrepareCheques.aspx.cs" Inherits="WebPortal.Accounts.PrepareCheques" %>

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
    </style>
    <script>
        $(document).ready(function () {
            preparecheque_bindyear();
            preparehold_bindyear();
            preparechequeother_bindyear();
        });
        function preparecheque_generatebankfile() {
            $('#waitingpanel').modal('show');
            var ddlmonth = document.getElementById("preparecheque_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("preparecheque_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            var ddlbank = document.getElementById("preparecheque_bank");
            var bank = ddlbank.options[ddlbank.selectedIndex].value;
            PageMethods.getRegularSalaryExport(month, year, bank, preparecheque_excel_OnSuccess, preparecheque_excel_OnError);
            return false;
        }

        function preparecheque_excel_OnSuccess(result) {
            document.getElementById("<%= btn1_excel.ClientID %>").click();
            $('#waitingpanel').modal('hide');
            return false;
        }

        function preparecheque_excel_OnError(error) {
            alert(error.get_message());
        }

        function preparehold_submitchequeno() {

            var table = $('#preparehold_table').DataTable();

            var selectedRows = [];

            // Loop through all checked checkboxes
            $('#preparehold_table tbody input.empCheckbox:checked').each(function () {

                var row = $(this).closest('tr');
                var rowData = table.row(row).data();

                selectedRows.push(rowData);
            });

            if (selectedRows.length === 0) {
                alert("Please select at least one record.");
                return;
            }
            var paramData = "";
            var params = "";
            //console.log(selectedRows); // See selected data in console
            selectedRows.forEach(function (item) {
                params = "";
                var empId = item.EmployeeID;
                var salary = item.NetSalary;
                var ddlmonth = document.getElementById("preparehold_month");
                var month = ddlmonth.options[ddlmonth.selectedIndex].value;
                var ddlyear = document.getElementById("preparehold_year");
                var year = ddlyear.options[ddlyear.selectedIndex].value;
                var chequeno = document.getElementById("preparehold_chequeno").value;

                params = empId + '|' + salary + '|' + chequeno + '|' + month + '|' + year;
                if (paramData == "")
                    paramData = params;
                else
                    paramData = paramData + "," + params;
            });
          
            if (paramData != "")
                PageMethods.InsertChequeDetails(paramData, preparehold_insert_OnSuccess, preparehold_insert_OnError);
            else
                alert("Please select at least one employee.");
            return false;
        }

        function preparehold_insert_OnSuccess(result) {
            alert("Cheque # updated successfully.");
            $('#preparehold_addchequeno').hide();
            document.getElementById("preparehold_chequeno").value = "";
            preparehold_show();
            return false;
        }

        function preparehold_insert_OnError(error) {
            alert(error.get_message());
        }


        //Other Salary types (Bonus/Incentive/Leave Encashment)
        function prepare_other_submitchequeno() {

            var table = $('#preparecheque_other_table').DataTable();

            var selectedRows = [];

            // Loop through all checked checkboxes
            $('#preparecheque_other_table tbody input.empCheckbox:checked').each(function () {

                var row = $(this).closest('tr');
                var rowData = table.row(row).data();

                selectedRows.push(rowData);
            });

            if (selectedRows.length === 0) {
                alert("Please select at least one record.");
                return;
            }
            var paramData = "";
            var params = "";
            //console.log(selectedRows); // See selected data in console
            selectedRows.forEach(function (item) {
                params = "";
                var empId = item.EmployeeID;
                var salary = item.NetSalary;
                var ddlmonth = document.getElementById("preparechequeother_month");
                var month = ddlmonth.options[ddlmonth.selectedIndex].value;
                var ddlyear = document.getElementById("preparechequeother_year");
                var year = ddlyear.options[ddlyear.selectedIndex].value;
                var ddltype = document.getElementById("preparechequeother_type");
                var type = ddltype.options[ddltype.selectedIndex].value;
                var chequeno = document.getElementById("prepare_other_chequeno").value;

                params = empId + '|' + salary + '|' + chequeno + '|' + month + '|' + year + '|' + type;
                if (paramData == "")
                    paramData = params;
                else
                    paramData = paramData + "," + params;
            });
            if (paramData != "")
                PageMethods.InsertChequeDetails_OtherThanSalary(paramData, prepare_other_insert_OnSuccess, prepare_other_insert_OnError);
            else
                alert("Please select at least one employee.");
            return false;
        }

        function prepare_other_insert_OnSuccess(result) {
            alert("Cheque # updated successfully.");
            $('#prepare_other_addchequeno').hide();
            document.getElementById("prepare_other_chequeno").value = "";
            preparechequeother_show();
            return false;
        }

        function prepare_other_insert_OnError(error) {
            alert(error.get_message());
        }

        function preparechequeother_generatebankfile() {
            $('#waitingpanel').modal('show');
            var ddlmonth = document.getElementById("preparechequeother_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("preparechequeother_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            var ddlbank = document.getElementById("preparechequeother_bank");
            var bank = ddlbank.options[ddlbank.selectedIndex].value;
            var ddltype = document.getElementById("preparechequeother_type");
            var type = ddltype.options[ddltype.selectedIndex].value;
            PageMethods.getOtherSalaryExport(month, year, bank, type, preparechequeother_excel_OnSuccess, preparechequeother_excel_OnError);
            return false;
        }

        function preparechequeother_excel_OnSuccess(result) {
            document.getElementById("<%= btn2.ClientID %>").click();
            $('#waitingpanel').modal('hide');
            return false;
        }

        function preparechequeother_excel_OnError(error) {
            alert(error.get_message());
        }

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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Prepare Cheques</b></h6>
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
                                <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Regular Salary</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">Hold Employees</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-profile-tab-Gen" data-toggle="pill" href="#custom-tabs-one-profile-Gen" role="tab" aria-controls="custom-tabs-one-profile-Gen" aria-selected="false">Bonus/Incentive/Leave Encashment</a>
                            </li>
                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                                <table class="table">
                                    <tr>
                                        <td><b>Month:</b></td>
                                        <td>
                                            <select id="preparecheque_month" name="preparecheque_month" class="form-control" style="width: 250px;">
                                                <option value="">Select</option>
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
                                        <td>
                                            <b>Year:</b>
                                        </td>
                                        <td>
                                            <select id="preparecheque_year" name="preparecheque_year" class="form-control" style="width: 250px;">
                                                <option value="">Select</option>
                                            </select>
                                        </td>
                                        <td>
                                            <button id="preparecheque_btnShow" class="btn btn-primary" onclick="return preparecheque_show();">Show</button>
                                        </td>
                                        <td id="preparecheque_generate_1" style="display: none;">
                                            <select id="preparecheque_bank" name="preparecheque_bank" class="form-control" style="width: 250px;">
                                                <option value="">Select</option>
                                                <option value="Axis Bank">Axis Bank</option>
                                                <option value="ICICI Bank">ICICI Bank</option>
                                            </select>
                                        </td>
                                        <td id="preparecheque_generate_2" style="display: none;">
                                            <button id="preparecheque_btngenerate" class="btn btn-primary" onclick="return preparecheque_generatebankfile();">Generate</button>
                                            <asp:Button ID="btn1_excel" runat="server" Style="display: none;" OnClick="btn1_Click" />
                                        </td>
                                    </tr>
                                </table>
                                <hr />
                                <table class="table table-bordered" style="width: 100%;" id="preparecheque_regular_table">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Department</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Bank Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Account #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">IFSC Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Amount</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Cheque #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Release Date</th>
                                        </tr>
                                    </thead>
                                    <tfoot>
                                        <tr>
                                            <th colspan="8" style="text-align: right">Total:</th>
                                            <th></th>
                                            <th colspan="2"></th>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                                <table class="table">
                                    <tr>
                                        <td><b>Month:</b></td>
                                        <td>
                                            <select id="preparehold_month" name="preparehold_month" class="form-control" style="width: 250px;">
                                                <option value="">Select</option>
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
                                        <td>
                                            <b>Year:</b>
                                        </td>
                                        <td>
                                            <select id="preparehold_year" name="preparehold_year" class="form-control" style="width: 250px;">
                                                <option value="">Select</option>
                                            </select>
                                        </td>
                                        <td>
                                            <button id="preparehold_btnShow" class="btn btn-primary" onclick="return preparehold_show();">Show</button>
                                        </td>
                                    </tr>
                                </table>
                                <hr />
                                <table id="preparehold_addchequeno" style="display: none;">
                                    <tr>
                                        <td><b>Cheque #:</b></td>
                                        <td>
                                            <input type="text" id="preparehold_chequeno" name="preparehold_chequeno" style="width: 150px;" class="form-control" />
                                        </td>
                                        <td>
                                            <button type="submit" id="preparehold_btnsubmitchequeno" name="preparehold_btnsubmitchequeno" class="btn btn-secondary" onclick="return preparehold_submitchequeno();">Submit</button>
                                        </td>
                                    </tr>
                                </table>
                                <table class="table table-bordered" style="width: 100%;" id="preparehold_table">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Action</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Department</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Bank Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Account #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">IFSC Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Amount</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Hold Remark</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Latest Login Date</th>
                                        </tr>
                                    </thead>
                                    <tfoot>
                                        <tr>
                                            <th colspan="8" style="text-align: right">Total:</th>
                                            <th></th>
                                            <th colspan="2"></th>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-profile-Gen" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab-Gen">
                                <table class="table">
                                    <tr>
                                        <td><b>Month:</b></td>
                                        <td>
                                            <select id="preparechequeother_month" name="preparechequeother_month" class="form-control" style="width: 250px;">
                                                <option value="">Select</option>
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
                                        <td>
                                            <b>Year:</b>
                                        </td>
                                        <td>
                                            <select id="preparechequeother_year" name="preparechequeother_year" class="form-control" style="width: 250px;">
                                                <option value="">Select</option>
                                            </select>
                                        </td>
                                        <td><b>Type:</b></td>
                                        <td>
                                            <select id="preparechequeother_type" name="preparechequeother_type" class="form-control" style="width: 250px;">
                                                <option value="">Select</option>
                                                <option value="Bonus">Bonus</option>
                                                <option value="Increment Difference">Increment Difference</option>
                                                <option value="Leave Encashment">Leave Encashment</option>
                                                <option value="Other Incentive/Salary">Other Incentive/Salary</option>
                                            </select>
                                        </td>

                                        <td>
                                            <button id="preparechequeother_btnShow" class="btn btn-primary" onclick="return preparechequeother_show();">Show</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td id="preparechequeother_generate_1" style="display: none;">
                                            <select id="preparechequeother_bank" name="preparechequeother_bank" class="form-control" style="width: 250px;">
                                                <option value="">Select</option>
                                                <option value="Axis Bank">Axis Bank</option>
                                                <option value="ICICI Bank">ICICI Bank</option>
                                            </select>
                                        </td>
                                        <td id="preparechequeother_generate_2" style="display: none;">
                                            <button id="preparechequeother_btngenerate" class="btn btn-primary" onclick="return preparechequeother_generatebankfile();">Generate</button>
                                            <asp:Button ID="Button1" runat="server" Style="display: none;" OnClick="btn1_Click" />
                                        </td>
                                    </tr>
                                </table>
                                <hr />
                                <table id="prepare_other_addchequeno" style="display: none;">
                                    <tr>
                                        <td><b>Cheque #:</b></td>
                                        <td>
                                            <input type="text" id="prepare_other_chequeno" name="prepare_other_chequeno" style="width: 150px;" class="form-control" />
                                        </td>
                                        <td>
                                            <button type="submit" id="prepare_other_btnsubmitchequeno" name="prepare_other_btnsubmitchequeno" class="btn btn-secondary" onclick="return prepare_other_submitchequeno();">Submit</button>
                                            <asp:Button ID="btn2" runat="server" Style="display: none;" OnClick="btn2_Click" />
                                        </td>
                                    </tr>
                                </table>
                                <table class="table table-bordered" style="width: 100%;" id="preparecheque_other_table">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Action</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Department</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Bank Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Account #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">IFSC Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Amount</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Cheque #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Release Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Current Status</th>
                                        </tr>
                                    </thead>
                                    <tfoot>
                                        <tr>
                                            <th colspan="8" style="text-align: right">Total:</th>
                                            <th></th>
                                            <th colspan="2"></th>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="preparecheque_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="preparecheque_errmsg"></h6>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="empleave_btnMessage" onclick="location.reload();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

    <div class="modal fade" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">System is generating excel. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>
</asp:Content>
