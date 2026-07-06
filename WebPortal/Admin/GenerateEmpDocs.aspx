<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="GenerateEmpDocs.aspx.cs" Inherits="WebPortal.Admin.GenerateEmpDocs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        .empdoc-page {
            background: linear-gradient(135deg, #eef4ff, #f8fbff);
            padding: 12px;
            border-radius: 18px;
        }

        .empdoc-shell {
            max-width: 100%;
            margin: 0 auto;
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 12px 32px rgba(35, 76, 140, 0.12);
            overflow: hidden;
            border: 1px solid #e8eef8;
        }

        .empdoc-header {
            /*   background: linear-gradient(135deg, #1d4ed8, #2563eb, #38bdf8);
            color: #fff;
            padding: 14px 22px 30px;*/
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            gap: 22px;
            padding: 20px 25px;
            margin-bottom: 22px;
            border-radius: 18px;
            color: #fff;
            background: linear-gradient(115deg, #0a5fd7 0%, #1976f3 38%, #1da8ea 72%, #22d3ee 100%);
            box-shadow: 0 12px 28px rgba(21, 98, 228, .25);
        }

            .empdoc-header::before {
                content: "";
                position: absolute;
                top: -80px;
                left: -5%;
                width: 115%;
                height: 170px;
                border-radius: 50%;
                background: rgba(255,255,255,.10);
                transform: rotate(-4deg);
            }

            .empdoc-header::after {
                content: "";
                position: absolute;
                right: -85px;
                bottom: -90px;
                width: 290px;
                height: 290px;
                border-radius: 50%;
                background: rgba(255,255,255,.12);
            }

        .empdoc-hero > * {
            position: relative;
            z-index: 2;
        }

        .empdoc-header-icon {
            width: 60px;
            height: 60px;
            min-width: 60px;
            border-radius: 20%;
            border: 2px solid rgba(255,255,255,.78);
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.12);
            box-shadow: inset 0 0 0 8px rgba(255,255,255,.05);
        }

            .empdoc-header-icon i {
                font-size: 27px;
                color: #fff;
            }

        .empdoc-header-title {
            margin: 0;
            font-size: 20px;
            font-weight: 800;
            color: #fff;
        }

        .empdoc-header-subtitle {
            margin: 8px 0 0;
            font-size: 13px;
            color: rgba(255,255,255,.93);
            line-height: 1.55;
            /*  max-width: 1050px;*/
        }

        .empdoc-header-back {
            border-radius: 10px;
            background: linear-gradient(115deg, #0a5fd7 0%, #1976f3 38%, #1da8ea 72%, #22d3ee 100%);
            box-shadow: 0 12px 28px rgba(21, 98, 228, .25);
            text-align: right !important;
            margin-right: 10% !important;
            color: #fff !important;
            font-size: 15px;
            padding: 10px;
        }

        .employee-card {
            margin: 10px 18px 14px;
            background: #fff;
            border-radius: 18px;
            padding: 16px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            box-shadow: 0 10px 28px rgba(0,0,0,.08);
            position: relative;
            z-index: 10;
        }

        .employee-left {
            display: flex;
            align-items: center;
            gap: 15px;
            min-width: 0;
            flex: 0 1 360px;
        }

        .profile-avatar {
            flex: 0 0 55px;
            width: 55px;
            height: 55px;
            min-width: 55px;
            min-height: 55px;
            max-width: 55px;
            max-height: 55px;
            border-radius: 50%;
            overflow: hidden;
            background: linear-gradient(135deg, #2563eb, #06b6d4);
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            font-weight: 700;
        }

        .profile-details {
            min-width: 0;
            flex: 1;
        }

            .profile-details h4 {
                margin: 0;
                width: auto;
                max-width: 100%;
                font-size: 17px;
                font-weight: 700;
                color: #1e293b;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

        .designation-badge {
            display: inline-block;
            margin-top: 5px;
            background: #dbeafe;
            color: #2563eb;
            padding: 4px 10px;
            border-radius: 50px;
            font-size: 11px;
            font-weight: 600;
            white-space: nowrap;
        }

        .employee-right {
            flex: 1;
            display: grid;
            grid-template-columns: repeat(3, minmax(150px, 1fr));
            gap: 10px;
            min-width: 0;
        }

        .info-box {
            display: flex;
            gap: 10px;
            align-items: center;
            padding: 10px 12px;
            border-radius: 14px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            min-height: 58px;
            min-width: 0;
        }

            .info-box i {
                flex: 0 0 32px;
                width: 32px;
                height: 32px;
                border-radius: 10px;
                background: #eff6ff;
                color: #2563eb;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 13px;
            }

            .info-box small {
                display: block;
                color: #64748b;
                font-size: 13px;
                font-weight: 600;
            }

            .info-box strong {
                display: block;
                color: #0f172a;
                font-size: 15px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

        .doc-panel {
            margin: 0 18px 18px;
            background: #fff;
            border-radius: 18px;
            border: 1px solid #e5e7eb;
            box-shadow: 0 8px 22px rgba(15, 23, 42, .06);
            overflow: hidden;
        }

        .doc-panel-header {
            padding: 11px 16px;
            border-bottom: 1px solid #e5e7eb;
            display: flex;
            align-items: center;
            gap: 10px;
            background: #f8fafc;
        }

            .doc-panel-header i {
                width: 32px;
                height: 32px;
                border-radius: 10px;
                background: #dbeafe;
                color: #1d4ed8;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .doc-panel-header h5 {
                margin: 0;
                font-size: 16px;
                font-weight: 700;
                color: #172554;
            }

        .doc-form {
            padding: 16px;
        }

        .form-row-modern {
            display: grid;
            grid-template-columns: 150px 1fr;
            gap: 14px;
            align-items: center;
            margin-bottom: 12px;
        }

            .form-row-modern label {
                font-size: 12px;
                font-weight: 700;
                color: #334155;
                margin: 0;
            }

            .form-row-modern .form-control {
                height: 36px;
                border-radius: 12px;
                border: 1px solid #cbd5e1;
                font-size: 12px;
                box-shadow: none;
            }

                .form-row-modern .form-control:focus {
                    border-color: #2563eb;
                    box-shadow: 0 0 0 3px rgba(37, 99, 235, .12);
                }

        .btn-generate {
            border: none;
            border-radius: 12px;
            padding: 9px 24px;
            font-size: 13px;
            font-weight: 700;
            color: #fff;
            background: linear-gradient(135deg, #2563eb, #06b6d4);
            box-shadow: 0 10px 22px rgba(37, 99, 235, .25);
            transition: .25s ease;
            width: 100%;
        }

            .btn-generate:hover {
                transform: translateY(-2px);
                color: #fff;
            }

        @media (max-width: 992px) {
            .employee-card {
                flex-direction: column;
                align-items: stretch;
            }

            .employee-left {
                flex: none;
                width: 100%;
            }

            .employee-right {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 576px) {
            .employee-right {
                grid-template-columns: 1fr;
            }

            .form-row-modern {
                grid-template-columns: 1fr;
            }
        }
    </style>

    <script>
        $(document).ready(function () {

            bindEmpInfoForDocs();

            var currentUserName = '<%= HttpContext.Current.User.Identity.Name.ToString() %>';
            if (currentUserName == 8082 || currentUserName == 10447)
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
            $("#empdoc_doctype").append($("<option></option>").val("NoDueCertificate").html("No Due Certificate"));
            $("#empdoc_doctype").append($("<option></option>").val("ExitInterviewForm").html("Exit Interview Form"));
            $("#empdoc_doctype").append($("<option></option>").val("UnderTakingLetterUnderwriter").html("UnderTaking Letter"));
            $("#empdoc_doctype").append($("<option></option>").val("ExitChecklist").html("Exit Checklist"));
            $("#empdoc_doctype").append($("<option></option>").val("ExitDocumentsChecklist").html("Exit Documents Checklist"));
            $("#empdoc_doctype").append($("<option></option>").val("EmployeeAgreement5").html("Employee Agreement 5"));
            $("#empdoc_doctype").append($("<option></option>").val("EmployeeAgreementWithoutBondForExpAnalyst5").html("Employee Agreement 5 Analyst"));
        }

        window.onload = function () {
            Swal.close();
        };

        function empdoc_generatedocs() {

            document.getElementById("empdoc_doctype_hid").value = $("#empdoc_doctype").val();
            document.getElementById("empdoc_appdate_hid").value = $("#empdoc_appoint").val();

            // alert(empdoc_appdate_hid);

            // 🔥 SHOW SWEETALERT LOADER
            Swal.fire({
                title: 'Generating Document',
                text: 'Please wait while your document is being prepared...',
                allowOutsideClick: false,
                allowEscapeKey: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });

            // small delay so swal renders before postback
            setTimeout(function () {
                __doPostBack("ctl00$ContentPlaceHolder1$btn1", '');
            }, 100);

            // auto-close after a safe delay (important)
            setTimeout(function () {
                Swal.close();
            }, 3000); // adjust based on typical generation time


            return false;
        }

       
    </script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Button ID="btn1" runat="server" Style="display: none;" OnClick="btn1_Click" />
    <input type="hidden" id="empdoc_doctype_hid" name="empdoc_doctype_hid" />
    <input type="hidden" id="empdoc_subdomain_hid" name="empdoc_subdomain_hid" />
    <input type="hidden" id="empdoc_appdate_hid" name="empdoc_appdate_hid" />


    <div class="col-lg-12">
        <div class="empdoc-shell">
        

            <div class="empdoc-header">
                <span class="empdoc-header-icon">
                    <i class="fas fa-file-signature"></i>
                </span>
                <div style="width: 90%;">
                    <h1 class="empdoc-header-title">Employee Document Generator</h1>
                    <p class="empdoc-header-subtitle">
                        View employee details and generate official documents instantly.
                    </p>
                </div>
                <div style="text-align: right!important; width: 100px;">
                    <a href="#" class="empdoc-header-back" onclick="window.history.go(-1); return false;">&lt;&lt; Back</a>
                </div>
            </div>



            <div class="employee-card">
                <div class="employee-left">
                    <div class="profile-avatar">
                        <strong id="empdoc_code"></strong>
                    </div>
                    <div class="profile-details">
                        <h4 id="empdoc_name" style="text-wrap: nowrap;"></h4>
                        <span class="designation-badge" id="empdoc_designation"></span>
                    </div>
                </div>

                <div class="employee-right">
                    <div class="info-box">
                        <i class="fas fa-building"></i>
                        <div>
                            <small>Department</small>
                            <strong id="empdoc_department"></strong>
                        </div>
                    </div>

                    <div class="info-box">
                        <i class="fas fa-map-marker-alt"></i>
                        <div>
                            <small>Branch</small>
                            <strong id="empdoc_branch"></strong>
                        </div>
                    </div>

                    <div class="info-box">
                        <i class="fas fa-calendar-alt"></i>
                        <div>
                            <small>Joining Date</small>
                            <strong id="empdoc_joining"></strong>
                        </div>
                    </div>

                </div>

            </div>

            <section class="doc-panel">
                <div class="doc-panel-header">
                    <i class="fas fa-magic"></i>
                    <h5>Generate Documents</h5>
                </div>

                <div class="doc-form">
                    <div class="form-row-modern">
                        <label>Document Type</label>
                        <select id="empdoc_doctype" name="empdoc_doctype" class="form-control" onchange="getoptions();"></select>
                    </div>

                    <div class="form-row-modern" id="trprocess" style="display: none;">
                        <label>Process</label>
                        <select id="empdoc_process" name="empdoc_process" class="form-control" onchange="getamount();">
                            <option value="">Select</option>
                            <option value="Loan Set-up">Loan Set-up</option>
                            <option value="Credit Analyst">Credit Analyst</option>
                            <option value="Compliance Analyst">Compliance Analyst</option>
                            <option value="Process Lead (QC)">Process Lead (QC)</option>
                            <option value="Supervisor/Manager">Supervisor/Manager</option>
                        </select>
                    </div>

                    <div class="form-row-modern" id="trincentive" style="display: none;">
                        <label>Incentive Amount</label>
                        <input type="number" id="empdoc_incentive" name="empdoc_incentive" class="form-control" />
                    </div>

                    <div class="form-row-modern" id="trAppoint" style="display: none;">
                        <label>Appointment Letter Date</label>
                        <input type="date" id="empdoc_appoint" name="empdoc_appoint" class="form-control" />
                    </div>

                    <div class="form-row-modern">
                        <label></label>
                        <button id="btngenerateempdoc" name="btngenerateempdoc" class="btn btn-generate" onclick="return empdoc_generatedocs();"><i class="fas fa-download"></i>&nbsp;&nbsp;Generate Document</button>
                    </div>
                </div>
            </section>
        </div>
    </div>
</asp:Content>

