<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EKYC.aspx.cs" Inherits="WebPortal.Admin.EKYC" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
    <style>
        .kyc-wrapper {
            padding: 20px;
        }

        .kyc-steps {
            display: flex;
            justify-content: space-between;
            margin-bottom: 25px;
            position: relative;
        }

            .kyc-steps::before {
                content: '';
                position: absolute;
                top: 22px;
                left: 0;
                width: 100%;
                height: 4px;
                background: #dee2e6;
                z-index: 0;
            }

        .kyc-step-item {
            position: relative;
            z-index: 1;
            text-align: center;
            flex: 1;
        }

        .kyc-step-circle {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            background: #dee2e6;
            color: #6c757d;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: auto;
            font-weight: bold;
            transition: .3s;
        }

        .kyc-step-item.active .kyc-step-circle {
            background: #007bff;
            color: white;
            box-shadow: 0 0 10px rgba(0,123,255,.4);
        }

        .kyc-step-item.completed .kyc-step-circle {
            background: #28a745;
            color: white;
        }

        .kyc-step-title {
            margin-top: 10px;
            font-size: 14px;
            font-weight: 600;
        }

        .kyc-step-content {
            display: none;
            animation: fadeIn .3s ease;
        }

            .kyc-step-content.active {
                display: block;
            }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .wizard-footer {
            display: flex;
            justify-content: space-between;
            margin-top: 25px;
        }

        .card {
            border-radius: 12px;
        }

        .card-header {
            background: #fff;
            border-bottom: 1px solid #eee;
            font-size: 18px;
            font-weight: 600;
        }

        .form-control {
            border-radius: 8px;
        }

        .is-invalid {
            border-color: #dc3545 !important;
        }

        .review-box {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
        }
    </style>

    <script>
        var currentStep = 1;

        function showStep(step) {

            $(".kyc-step-content").removeClass("active");
            $("#step-" + step).addClass("active");

            $(".kyc-step-item")
                .removeClass("active completed");

            for (var i = 1; i < step; i++) {
                $("#indicator-" + i).addClass("completed");
            }

            $("#indicator-" + step).addClass("active");

            currentStep = step;
        }

        function validateStep(step) {

            var valid = true;

            $("#step-" + step + " .kyc-required").each(function () {

                $(this).removeClass("is-invalid");

                if ($(this).val() == "") {

                    $(this).addClass("is-invalid");

                    Swal.fire({
                        icon: 'warning',
                        title: 'Required',
                        text: 'Please fill all mandatory fields'
                    });

                    valid = false;
                    return false;
                }
            });

            return valid;
        }

        function nextStep(step) {

            if (!validateStep(step)) {
                return false;
            }

            showStep(step + 1);
        }

        function prevStep(step) {
            showStep(step - 1);
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>KYC Information</b></h6>
                </div>
            </div>
        </div>
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">



                <div class="container-fluid kyc-wrapper">

                    <!-- STEP HEADER -->
                    <div class="kyc-steps">

                        <div class="kyc-step-item active" id="indicator-1">
                            <div class="kyc-step-circle">1</div>
                            <div class="kyc-step-title">Personal</div>
                        </div>

                        <div class="kyc-step-item" id="indicator-2">
                            <div class="kyc-step-circle">2</div>
                            <div class="kyc-step-title">Documents</div>
                        </div>

                        <div class="kyc-step-item" id="indicator-3">
                            <div class="kyc-step-circle">3</div>
                            <div class="kyc-step-title">Nominee</div>
                        </div>

                        <div class="kyc-step-item" id="indicator-4">
                            <div class="kyc-step-circle">4</div>
                            <div class="kyc-step-title">Family</div>
                        </div>

                        <div class="kyc-step-item" id="indicator-5">
                            <div class="kyc-step-circle">5</div>
                            <div class="kyc-step-title">Submit</div>
                        </div>

                    </div>

                    <!-- STEP 1 -->
                    <div class="kyc-step-content active" id="step-1">

                        <div class="card card-primary card-outline">
                            <div class="card-header">
                                Personal Information
                            </div>

                            <div class="card-body">

                                <div class="row">

                                    <div class="col-md-3 mb-3">
                                        <label>Full Name</label>
                                        <input type="text" id="ekyc_fullname" class="form-control" disabled>
                                    </div>

                                    <div class="col-md-3 mb-3">
                                        <label>Joining Date</label>
                                        <input type="text" id="ekyc_doj" class="form-control" disabled>
                                    </div>

                                    <div class="col-md-3 mb-3">
                                        <label>Date of Birth</label>
                                        <input type="date" id="ekyc_dob"
                                            class="form-control kyc-required">
                                    </div>

                                    <div class="col-md-3 mb-3">
                                        <label>Gender</label>
                                        <select id="ekyc_gender"
                                            class="form-control kyc-required">
                                            <option value="">Select</option>
                                            <option value="F">Female</option>
                                            <option value="M">Male</option>
                                        </select>
                                    </div>

                                </div>

                                <div class="row">
                                    <div class="col-md-3 mb-3">
                                        <label>Contact</label>
                                        <input type="tel" id="ekyc_contact"
                                            class="form-control kyc-required">
                                    </div>

                                    <div class="col-md-3 mb-3">
                                        <label>Qualification</label>
                                        <select id="ekyc_qualification"
                                            class="form-control kyc-required">
                                            <option value="">Select</option>
                                            <option value="G">Graduate</option>
                                            <option value="P">Post Graduate</option>
                                        </select>
                                    </div>

                                    <div class="col-md-3 mb-3">
                                        <label>Marital Status</label>
                                        <select id="ekyc_maritalstatus"
                                            class="form-control kyc-required">
                                            <option value="">Select</option>
                                            <option value="M">Married</option>
                                            <option value="U">Unmarried</option>
                                        </select>
                                    </div>

                                    <div class="col-md-3 mb-3">
                                        <label>Marriage Date</label>
                                        <input type="date" id="ekyc_marriagedate"
                                            class="form-control">
                                    </div>

                                </div>

                                <div class="row">

                                    <div class="col-md-6 mb-3">
                                        <label>Present Address</label>
                                        <textarea id="ekyc_presentaddress"
                                            class="form-control kyc-required"></textarea>
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <label>Permanent Address</label>
                                        <textarea id="ekyc_permanentaddress"
                                            class="form-control kyc-required"></textarea>
                                    </div>

                                </div>

                            </div>
                        </div>

                        <div class="wizard-footer">
                            <button type="button" class="btn btn-secondary" disabled>
                                Previous
                            </button>

                            <button type="button" class="btn btn-primary" onclick="nextStep(1)">
                                Next →
                            </button>
                        </div>

                    </div>

                    <!-- STEP 2 -->
                    <div class="kyc-step-content" id="step-2">

                        <div class="card card-primary card-outline">
                            <div class="card-header">
                                Documents Information
                            </div>

                            <div class="card-body">

                                <div class="row">

                                    <div class="col-md-4 mb-3">
                                        <label>Bank Name</label>
                                        <input type="text" id="ekyc_bankname"
                                            class="form-control kyc-required">
                                    </div>

                                    <div class="col-md-4 mb-3">
                                        <label>Account Number</label>
                                        <input type="text" id="ekyc_accno"
                                            class="form-control kyc-required">
                                    </div>

                                    <div class="col-md-4 mb-3">
                                        <label>IFSC Code</label>
                                        <input type="text" id="ekyc_ifsccode"
                                            class="form-control kyc-required">
                                    </div>

                                </div>

                                <div class="row">

                                    <div class="col-md-4 mb-3">
                                        <label>Document Type</label>
                                        <select id="ekyc_documenttype"
                                            class="form-control kyc-required">
                                            <option value="">Select</option>
                                            <option value="PP">Passport</option>
                                            <option value="DL">Driving License</option>
                                        </select>
                                    </div>

                                    <div class="col-md-4 mb-3">
                                        <label>Document Number</label>
                                        <input type="text" id="ekyc_docno"
                                            class="form-control kyc-required">
                                    </div>

                                    <div class="col-md-4 mb-3">
                                        <label>Expiry Date</label>
                                        <input type="date" id="ekyc_expirydate"
                                            class="form-control">
                                    </div>

                                </div>

                            </div>
                        </div>

                        <div class="wizard-footer">
                            <button type="button" class="btn btn-secondary" onclick="prevStep(2)">
                                ← Previous
                            </button>

                            <button type="button" class="btn btn-primary" onclick="nextStep(2)">
                                Next →
                            </button>
                        </div>

                    </div>

                    <!-- STEP 3 -->
                    <div class="kyc-step-content" id="step-3">

                        <div class="card card-primary card-outline">
                            <div class="card-header">
                                Nominee Information
                            </div>

                            <div class="card-body">

                                <div class="row">

                                    <div class="col-md-4 mb-3">
                                        <label>Nominee Name</label>
                                        <input type="text" id="ekyc_nomineename"
                                            class="form-control kyc-required">
                                    </div>

                                    <div class="col-md-4 mb-3">
                                        <label>Relation</label>
                                        <select id="ekyc_nomineerelation"
                                            class="form-control kyc-required">
                                            <option value="">Select</option>
                                            <option>Father</option>
                                            <option>Mother</option>
                                        </select>
                                    </div>

                                    <div class="col-md-4 mb-3">
                                        <label>Birth Date</label>
                                        <input type="date" id="ekyc_nomineebirthdate"
                                            class="form-control kyc-required">
                                    </div>

                                </div>

                            </div>
                        </div>

                        <div class="wizard-footer">
                            <button type="button" class="btn btn-secondary" onclick="prevStep(3)">
                                ← Previous
                            </button>

                            <button type="button" class="btn btn-primary" onclick="nextStep(3)">
                                Next →
                            </button>
                        </div>

                    </div>

                    <!-- STEP 4 -->
                    <div class="kyc-step-content" id="step-4">

                        <div class="card card-primary card-outline">

                            <div class="card-header">
                                Family Information
                            </div>

                            <div class="card-body">

                                <div class="row">

                                    <div class="col-md-3 mb-3">
                                        <label>Name</label>
                                        <input type="text"
                                            id="ekcy_familyname"
                                            class="form-control">
                                    </div>

                                    <div class="col-md-3 mb-3">
                                        <label>Relation</label>
                                        <select id="ekyc_familyrelation"
                                            class="form-control">
                                            <option value="">Select</option>
                                            <option>Father</option>
                                            <option>Mother</option>
                                        </select>
                                    </div>

                                    <div class="col-md-3 mb-3">
                                        <label>Occupation</label>
                                        <select id="ekyc_familyoccupation"
                                            class="form-control">
                                            <option value="">Select</option>
                                            <option>Farmer</option>
                                            <option>Service</option>
                                        </select>
                                    </div>

                                    <div class="col-md-3 mb-3">
                                        <label>Birth Date</label>
                                        <input type="date"
                                            id="ekyc_familybirthdate"
                                            class="form-control">
                                    </div>

                                </div>

                                <button class="btn btn-info"
                                    onclick="ekyc_addfamilyinfo()">
                                    Add Family Member
                                </button>

                            </div>
                        </div>

                        <div class="wizard-footer">

                            <button class="btn btn-secondary" onclick="prevStep(4)">
                                ← Previous
                            </button>

                            <button class="btn btn-success" onclick="nextStep(4)">
                                Review →
                            </button>

                        </div>

                    </div>

                    <!-- STEP 5 -->
                    <div class="kyc-step-content" id="step-5">

                        <div class="card card-success card-outline">

                            <div class="card-header">
                                Review & Submit
                            </div>

                            <div class="card-body">

                                <div class="review-box">

                                    <h5 class="mb-3">Please review all information before submission.
                                    </h5>

                                    <p>
                                        Ensure all mandatory fields are correctly filled.
                                    </p>

                                </div>

                            </div>
                        </div>

                        <div class="wizard-footer">

                            <button class="btn btn-secondary"
                                onclick="prevStep(5)">
                                ← Previous
                            </button>

                            <button class="btn btn-primary btn-lg"
                                onclick="ekyc_submit()">
                                Submit KYC
                            </button>

                        </div>

                    </div>

                </div>

            </div>
        </div>
    </div>

</asp:Content>
