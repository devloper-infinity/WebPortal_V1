<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="CreditUtilizationReport.aspx.cs" Inherits="WebPortal.Admin.CreditUtilizationReport" %>

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

        .btn-gradient-primary {
            background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;
            color: #fff;
            border-radius: 12px;
            height: 40px;
            font-weight: 400;
            transition: 0.3s;
        }

            .btn-gradient-primary:hover {
                transform: translateY(-2px);
                /*background: linear-gradient(135deg, #4da6ff, #1a8cff);*/
                background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;
                color: #fff;
            }


        .btn-gradient-success {
            background: linear-gradient(135deg, #1cc88a, #13855c);
            color: #fff;
            border-radius: 12px;
            height: 50px;
            width: 60%;
            font-weight: 400;
            transition: 0.3s;
        }

            .btn-gradient-success:hover {
                transform: translateY(-2px);
                color: #fff;
            }
    </style>
    <script>
        $(document).ready(function () {
            creditutil_bindyear();
        });

        function creditutil_Submit() {
            $('#waitingpanel').modal('show');
            document.getElementById("spntext").innerHTML = "system is generating excel output. Please wait ";
            var ddlmonth = document.getElementById("creditutil_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("creditutil_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.GenerateOutput(month, year, creditutil_OnSuccess, creditutil_OnError);
            return false;
        }
        function creditutil_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Report Prepeation Completed. Downloading Report";
            __doPostBack("<%= btn1.UniqueID %>", '');
            $('#waitingpanel').modal('hide');
            return false;
        }
        function creditutil_OnError(error) {
            alert(error.responseText);
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Credit Utilization Report</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <%-- <table class="table">
                    <tr>
                        <td style="width: 50px;"><b>Month:</b></td>
                        <td style="width: 150px;">--%>
                <div class="row align-items-end g-4">
                    <div class="col-md-4">
                        <label class="form-label"><b>Month</b></label>
                        <div class="input-group">
                            <select id="creditutil_month" name="creditutil_month" class="form-control" style="height: 40px;">
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
                        </div>
                    </div>

                    <!-- Year -->
                    <div class="col-md-4">
                        <label class="form-label"><b>Year </b></label>
                        <div class="input-group">
                            <select id="creditutil_year" name="creditutil_year" class="form-control" style="height: 40px;">
                                <option value="">Select</option>
                            </select>
                        </div>
                    </div>

                    <!-- Get Report -->
                    <div class="col-md-4">
                        <button id="btnShow" class="btn btn-primary" onclick="return BindUtilReport();" style="display: none;">Show</button>
                        &nbsp;
                            <button id="creditutil_btnexport" class="btn btn-gradient-primary w-100" onclick="return creditutil_Submit()">Export to excel</button>
                        <asp:Button ID="btn1" runat="server" CssClass="btn btn-primary" OnClick="btn1_Click" Style="display: none;" Text="Export to excel" />
                    </div>
                    <%--</td>
                    </tr>
                </table>--%>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">System is updating details. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>
</asp:Content>
