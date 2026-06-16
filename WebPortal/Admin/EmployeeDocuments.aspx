<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EmployeeDocuments.aspx.cs" Inherits="WebPortal.Admin.EmployeeDocuments" %>

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
            bindemployeedocumentheader();
            var currentUserName = '<%= HttpContext.Current.User.Identity.Name.ToString() %>';
            if (currentUserName == 8082)
                empdoc_bindddl_SpecialCase();
            else
                empdoc_bindddl();
        });

        function empdoc_bindddl_SpecialCase() {

            $("#empdoc_doctype").append($("<option></option>").val("").html("Select"));
            $("#empdoc_doctype").append($("<option></option>").val("OfferLetter").html("Offer Letter"));
            $("#empdoc_doctype").append($("<option></option>").val("AppointmentLetter").html("Appointment Letter"));
            $("#empdoc_doctype").append($("<option></option>").val("ConfirmationLetter").html("Confirmation Letter"));
            $("#empdoc_doctype").append($("<option></option>").val("IdemnityBond").html("Idemnity Bond"));
            $("#empdoc_doctype").append($("<option></option>").val("AppendixA").html("Appendix A"));
            $("#empdoc_doctype").append($("<option></option>").val("EmployeeAgreementWithoutBond").html("Employee Agreement 3"));
            $("#empdoc_doctype").append($("<option></option>").val("PromotionLetter").html("Promotion Letter"));
            $("#empdoc_doctype").append($("<option></option>").val("SalaryRivisionLetter").html("Salary Revision Letter"));
            $("#empdoc_doctype").append($("<option></option>").val("AddressVerificationLetter").html("Address Verification Letter"));
            /*$("#empdoc_doctype").append($("<option></option>").val("SelfTransport").html("Self Transport Affidavit (Undertaking)"));*/
            $("#empdoc_doctype").append($("<option></option>").val("Annexure").html("Annexure"));
            $("#empdoc_doctype").append($("<option></option>").val("Account Transfer Letter").html("Account Transfer Letter"));
            $("#empdoc_doctype").append($("<option></option>").val("Renewal Agreement").html("Renewal Agreement"));
            $("#empdoc_doctype").append($("<option></option>").val("Psuedo Name").html("Psuedo Name"));
            /*$("#empdoc_doctype").append($("<option></option>").val("Transfer Letter").html("Transfer Letter"));*/
            $("#empdoc_doctype").append($("<option></option>").val("Addendum to the Employment Agreement - 2").html("Addendum 2"));
            $("#empdoc_doctype").append($("<option></option>").val("Addendum to the Employment Agreement").html("Addendum 2.5"));
            $("#empdoc_doctype").append($("<option></option>").val("EmployeeAgreementWithoutBondForExpAnalyst").html("Employee Agreement - Analyst"));
            $("#empdoc_doctype").append($("<option></option>").val("ClientAcknowledgementLetterNew").html("Client Acknowledgement Letter"));
            /*$("#empdoc_doctype").append($("<option></option>").val("ShowCauseNotice").html("Show Cause Notice"));*/
            $("#empdoc_doctype").append($("<option></option>").val("JoiningDocumentsChecklist").html("Joining Documents Checklist"));
            $("#empdoc_doctype").append($("<option></option>").val("PersonalDetailsForm").html("Personal Details Form"));
            $("#empdoc_doctype").append($("<option></option>").val("BackgroundVerificationForm").html("Background Verification Form"));
            $("#empdoc_doctype").append($("<option></option>").val("AppendixB").html("Appendix B"));
            $("#empdoc_doctype").append($("<option></option>").val("EmployeeAgreementWithoutBond4").html("Employee Agreement 4"));
            $("#empdoc_doctype").append($("<option></option>").val("EmployeeAgreementWithoutBondForExpAnalyst4").html("Employee Agreement 4 - Analyst"));
            $("#empdoc_doctype").append($("<option></option>").val("POSH Policy - Acknowledgement Form").html("POSH Policy - Acknowledgement Form"));
            $("#empdoc_doctype").append($("<option></option>").val("POSH Policy Document").html("POSH Policy Document"));
            $("#empdoc_doctype").append($("<option></option>").val("PF Declaration Form - 11 - 2017").html("PF Declaration Form - 11 - 2017"));
            $("#empdoc_doctype").append($("<option></option>").val("PF Declaration Form - 11 - 2019").html("PF Declaration Form - 11 - 2019"));
            $("#empdoc_doctype").append($("<option></option>").val("Relievingletter").html("Relieving Letter"));
            $("#empdoc_doctype").append($("<option></option>").val("Experienceletter").html("Experience Letter"));
            $("#empdoc_doctype").append($("<option></option>").val("ClientAcknowledgementLetterNew").html("Client Acknowledgement Letter"));
            $("#empdoc_doctype").append($("<option></option>").val("NoDueCertificate").html("No Due Certificate"));
            $("#empdoc_doctype").append($("<option></option>").val("ExitInterviewForm").html("Exit Interview Form"));
            $("#empdoc_doctype").append($("<option></option>").val("UnderTakingLetterUnderwriter").html("UnderTaking Letter"));
            $("#empdoc_doctype").append($("<option></option>").val("ExitChecklist").html("Exit Checklist"));
            $("#empdoc_doctype").append($("<option></option>").val("ExitDocumentsChecklist").html("Exit Documents Checklist"));


        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Button ID="btn1" runat="server" Style="display: none;" OnClick="btn1_Click" />
    <input type="hidden" id="empdoc_doctype_hid" name="empdoc_doctype_hid" />
    <input type="hidden" id="empdoc_subdomain_hid" name="empdoc_subdomain_hid" />
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Employee Documentation</b></h6>
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
                <h5 class="card-title"></h5>
                <div class="card card-primary card-outline">
                    <div class="card-header">
                        <div class="card-title">
                            <i class="fas fa-edit"></i>
                            Employee Information:
                        </div>
                    </div>
                    <table class="table" style="width: 100%;">
                        <tr>
                            <td><b>Code:</b></td>
                            <td>
                                <label id="empdoc_code" class="form-control"></label>
                            </td>
                            <td><b>Name:</b></td>
                            <td>
                                <label id="empdoc_name" class="form-control"></label>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Joining Date:</b></td>
                            <td>
                                <label id="empdoc_joiningdate" class="form-control"></label>
                            </td>
                            <td><b>Working Branch:</b></td>
                            <td>
                                <label id="empdoc_branch" class="form-control"></label>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Department:</b></td>
                            <td>
                                <label id="empdoc_department" class="form-control"></label>
                            </td>
                            <td><b>Designation:</b></td>
                            <td>
                                <label id="empdoc_designation" class="form-control"></label>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="card card-primary card-outline">
                    <div class="card-header">
                        <div class="card-title">
                            <i class="fas fa-edit"></i>
                            Generate Documents:
                        </div>
                    </div>
                    <table class="table" style="width: 100%;">
                        <tr>
                            <td><b>Document Type:</b></td>
                            <td>
                                <select id="empdoc_doctype" name="empdoc_doctype" class="form-control" style="width: 500px;" onchange="getoptions();"></select>
                            </td>
                        </tr>
                        <tr id="trprocess" style="display: none;">
                            <td><b>Process:</b></td>
                            <td>
                                <select id="empdoc_process" name="empdoc_process" class="form-control" style="width: 500px;" onchange="getamount();">
                                    <option value="">Select</option>
                                    <option value="Loan Set-up">Loan Set-up</option>
                                    <option value="Credit Analyst">Credit Analyst</option>
                                    <option value="Compliance Analyst">Compliance Analyst</option>
                                    <option value="Process Lead (QC)">Process Lead (QC)</option>
                                    <option value="Supervisor/Manager">Supervisor/Manager</option>
                                </select>
                            </td>
                        </tr>
                        <tr id="trincentive" style="display: none;">
                            <td><b>Incentive Amount:</b></td>
                            <td>
                                <input type="number" id="empdoc_incentive" name="empdoc_incentive" class="form-control" style="width: 500px;" />
                            </td>
                        </tr>
                        <tr id="trAppoint" style="display: none;">
                            <td><b>Appointment Letter Date:</b></td>
                            <td>
                                <input type="date" id="empdoc_appoint" name="empdoc_appoint" class="form-control" style="width: 500px;" />
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <button id="btngenerateempdoc" name="btngenerateempdoc" class="btn btn-primary" onclick="return empdoc_generatedocs();">Generate Document</button>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
