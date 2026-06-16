<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="PoshTestResult.aspx.cs" Inherits="WebPortal.Admin.PoshTestResult" %>

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

            poshtestres_bindyear();

            var poshmonth = document.getElementById("poshtestres_month");
            var Pmonth = poshmonth.options[poshmonth.selectedIndex].text;

            var poshyear = document.getElementById("poshtestres_year");
            var Pyear = poshyear.options[poshyear.selectedIndex].value;

            if (Pmonth != "Select" && Pyear != "Select") {
                poshtestres_submit(Pmonth, Pyear);
            }
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>POSH Induction Test Result</b></h6>
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
                        <td style="width: 50px;"><b>Month:</b></td>
                        <td style="width: 150px;">
                            <select id="poshtestres_month" name="poshtestres_month" class="form-control">
                                <option value="Select">Select</option>
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
                            <select id="poshtestres_year" name="poshtestres_year" class="form-control">
                                <option value="">Select</option>
                            </select>
                        </td>
                        <td style="width: 100px;">
                            <button id="btnShow" class="btn btn-primary" onclick="return poshtestres_submit();">Show</button>
                        </td>
                    </tr>
                </table>
                <hr />

                <h6 style="text-decoration: underline;">Summary</h6>
                <%-- <br />--%>
                <table class="table" id="table_poshtestSummary" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Total</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Completed</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Pending</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
                <hr />
                <h6 style="text-decoration: underline;">Detail</h6>
                <br />


                <table class="table" id="poshtestres_table" style="padding-top: 10px; width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="display: none;">EmployeeID</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Answer Sheet</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Employee Name</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Joining Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Test Status</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Test Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Marks</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Result</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; display: none;">View Answet Sheet</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
