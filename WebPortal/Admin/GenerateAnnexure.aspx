<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="GenerateAnnexure.aspx.cs" Inherits="WebPortal.Admin.GenerateAnnexure" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
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
    </style>
    <style>
        @keyframes animate {
            0% {
                opacity: 0;
            }

            50% {
                opacity: 0.7;
            }

            100% {
                opacity: 0;
            }
        }
    </style>
    <script>
        function getprocess(ddltype) {
            var type = ddltype.selectedIndex;
            if (type == 2) {
                document.getElementById("annexure_trproecss").style.display = '';
                document.getElementById("annexure_trincentive").style.display = '';
            }
            else {
                document.getElementById("annexure_trproecss").style.display = 'none';
                document.getElementById("annexure_trincentive").style.display = 'none';
            }
            return false;
        }

        function getincentiveamount(ddlprocess) {
            var process = ddlprocess.options[ddlprocess.selectedIndex].value;
            if (process == "Loan Set-up")
                document.getElementById("annexure_inentive").value = '50000';
            else if (process == "Credit Analyst")
                document.getElementById("annexure_inentive").value = '80000';
            else if (process == "Compliance Analyst")
                document.getElementById("annexure_inentive").value = '80000';
            else if (process == "Process Lead (QC)")
                document.getElementById("annexure_inentive").value = '100000';
            else
                document.getElementById("annexure_inentive").value = '';

        }

        function getsalarydetails() {
            var ddltype = document.getElementById("annexure_type");
            var type = ddltype.options[ddltype.selectedIndex].value;
            var salary = document.getElementById("annexure_salary").value;
            var amount = document.getElementById("annexure_inentive").value;
            $.ajax({
                type: "POST", url: "GenerateAnnexure.aspx/GetVerificationRecords", dataType: "json", contentType: "application/json",
                data: "{Type:'" + type + "',Salary:'" + salary + "',IncentiveAmount:'" + amount + "'}",
                success: function (res) {
                    var dataArray = JSON.parse(res.d);
                    $.each(dataArray, function (data, value) {
                        document.getElementById("ctc").innerHTML = value.TotalCostMonth;
                        document.getElementById("gross").innerHTML = value.GrossSalaryMonth;
                        document.getElementById("inhand").innerHTML = value.NetSalaryMonth;
                        document.getElementById("annexure_btnGenerate").style.display = '';
                    })
                }

            });
            document.getElementById("<%= hdSalary.ClientID %>").Value = document.getElementById("annexure_salary").value;
            document.getElementById("<%= hdSalary.ClientID %>").Value = document.getElementById("annexure_inentive").value;
            return false;
        }

        function annexure_generateannexure() {
           // $('#waitingpanel').modal('show');
            __doPostBack("<%= btn1.UniqueID %>", '');
            return false;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="modal fade" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;">System is generating document. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>
    <asp:HiddenField ID="hdAmount" runat="server" />
    <asp:HiddenField ID="hdSalary" runat="server" />
    <asp:Button ID="btn1" runat="server" Style="display: none;" OnClick="btn1_Click" />
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Generate Annexure</b></h6>
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
                        <td><b>Type:</b></td>
                        <td>
                            <select id="annexure_type" name="annexure_type" class="form-control" style="width: 300px;" onchange="return getprocess(this);">
                                <option value="">Select</option>
                                <option value="Annexure">Annexure</option>
                                <option value="Analyst Annexure">Analyst Annexure</option>
                            </select>
                        </td>
                        <td></td>
                    </tr>
                    <tr style="display: none;" id="annexure_trproecss">
                        <td><b>Process:</b></td>
                        <td>
                            <select id="annexure_process" name="annexure_process" class="form-control" style="width: 300px;" onchange="return getincentiveamount(this);">
                                <option value="">Select</option>
                                <option value="Loan Set-up">Loan Set-up</option>
                                <option value="Credit Analyst">Credit Analyst</option>
                                <option value="Compliance Analyst">Compliance Analyst</option>
                                <option value="Process Lead (QC)">Process Lead (QC)</option>
                                <option value="Supervisor/Manager">Supervisor/Manager</option>
                            </select>
                        </td>
                        <td></td>
                    </tr>
                    <tr style="display: none;" id="annexure_trincentive">
                        <td><b>Incentive Amount:</b></td>
                        <td>
                            <input type="text" id="annexure_inentive" name="annexure_inentive" class="form-control" style="width: 300px;" />
                        </td>
                        <td></td>
                    </tr>
                    <tr>
                        <td><b>Salary:</b></td>
                        <td>
                            <input type="text" id="annexure_salary" name="annexure_salary" class="form-control" style="width: 300px; display: inline;" />
                            <button id="annexure_btndetails" class="btn buttons-excel" onclick="return getsalarydetails();">Get Salary Details</button>
                        </td>
                        <td></td>
                    </tr>
                </table>
                <table class="table">
                    <tr>
                        <th>CTC Amount</th>
                        <th>Gross Amount</th>
                        <th>In hand Amount</th>
                    </tr>
                    <tr>
                        <td>
                            <label id="ctc" class="form-control"></label>
                        </td>
                        <td>
                            <label id="gross" class="form-control"></label>
                        </td>
                        <td>
                            <label id="inhand" class="form-control"></label>
                        </td>
                    </tr>
                </table>
                <div style="text-align: center;">
                    <button id="annexure_btnGenerate" class="btn btn-primary" style="display: none;" onclick="return annexure_generateannexure();">Generate Annexure</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
