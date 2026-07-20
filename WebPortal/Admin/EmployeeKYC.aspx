<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EmployeeKYC.aspx.cs" Inherits="WebPortal.Admin.EmployeeKYC" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --kyc-primary: #2457e6;
            --kyc-primary-dark: #173ea8;
            --kyc-accent: #25bfd4;
            --kyc-bg: #f4f7fb;
            --kyc-card: #ffffff;
            --kyc-text: #172033;
            --kyc-muted: #68738a;
            --kyc-border: #dfe6f1;
            --kyc-shadow: 0 14px 35px rgba(31, 51, 94, .10);
        }

        .kyc-page {
            background: var(--kyc-bg);
            min-height: calc(100vh - 110px);
        }

        .kyc-container {
            width: 100%;
            max-width: 1480px;
            margin: 0 auto;
        }

        .kyc-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            margin-bottom: 18px;
            padding: 22px 24px;
            border-radius: 18px;
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 62%, #22c1dc 100%);
            box-shadow: 0 15px 36px rgba(37, 99, 235, .22);
        }

        .kyc-hero::after {
            content: "";
            position: absolute;
            right: -65px;
            top: -85px;
            width: 220px;
            height: 220px;
            border-radius: 50%;
            background: rgba(255, 255, 255, .12);
        }

        .kyc-hero-content {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .kyc-hero-icon {
            width: 52px;
            height: 52px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            flex: 0 0 52px;
            border-radius: 15px;
            background: rgba(255, 255, 255, .18);
            border: 1px solid rgba(255, 255, 255, .28);
            font-size: 23px;
        }

        .kyc-hero h1 {
            margin: 0 0 4px;
            font-size: 24px;
            line-height: 1.2;
            font-weight: 700;
        }

        .kyc-hero p {
            margin: 0;
            font-size: 13px;
            color: rgba(255, 255, 255, .88);
        }

        .kyc-hero-chip {
            position: relative;
            z-index: 1;
            display: inline-flex;
            align-items: center;
            gap: 7px;
            white-space: nowrap;
            padding: 8px 13px;
            border-radius: 999px;
            background: rgba(255, 255, 255, .16);
            border: 1px solid rgba(255, 255, 255, .28);
            font-size: 12px;
            font-weight: 600;
        }

        .kyc-form-shell {
            display: grid;
            gap: 18px;
        }

        .kyc-section {
            background: var(--kyc-card);
            border: 1px solid var(--kyc-border);
            border-radius: 17px;
            box-shadow: var(--kyc-shadow);
            overflow: hidden;
        }

        .kyc-section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            padding: 15px 18px;
            border-bottom: 1px solid var(--kyc-border);
            background: linear-gradient(180deg, #ffffff 0%, #f8fbff 100%);
        }

        .kyc-section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0;
            color: var(--kyc-text);
            font-size: 14px;
            font-weight: 700;
        }

        .kyc-section-title .icon-box {
            width: 34px;
            height: 34px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 10px;
            color: var(--kyc-primary);
            background: #eaf0ff;
        }

        .kyc-section-note {
            margin: 0;
            color: var(--kyc-muted);
            font-size: 11px;
        }

        .kyc-section-body {
            padding: 18px;
        }

        .kyc-grid {
            display: grid;
            grid-template-columns: repeat(12, minmax(0, 1fr));
            gap: 16px;
        }

        .kyc-col-3 { grid-column: span 3; }
        .kyc-col-4 { grid-column: span 4; }
        .kyc-col-6 { grid-column: span 6; }
        .kyc-col-12 { grid-column: span 12; }

        .kyc-field {
            min-width: 0;
        }

        .kyc-field label {
            display: block;
            margin-bottom: 7px;
            color: #34405a;
            font-size: 12px;
            font-weight: 700;
        }

        .kyc-field .form-control {
            width: 100%;
            height: 42px;
            border: 1px solid #d5deeb;
            border-radius: 10px;
            background: #fff;
            color: var(--kyc-text);
            font-size: 13px;
            box-shadow: none;
            transition: border-color .2s ease, box-shadow .2s ease, transform .2s ease;
        }

        .kyc-field textarea.form-control {
            height: 96px;
            min-height: 96px;
            resize: vertical;
            padding-top: 10px;
        }

        .kyc-field .form-control:focus {
            border-color: var(--kyc-primary);
            box-shadow: 0 0 0 3px rgba(36, 87, 230, .10);
        }

        .kyc-field .form-control:disabled,
        .kyc-field .form-control[readonly] {
            opacity: 1;
            color: #4a556e;
            background: #f5f7fb !important;
            cursor: not-allowed;
        }

        .kyc-family-entry {
            display: grid;
            grid-template-columns: 1.25fr 1fr 1fr 1fr auto;
            gap: 14px;
            align-items: end;
        }

        .kyc-btn-add,
        .kyc-btn-submit {
            border: 0;
            border-radius: 10px;
            font-weight: 700;
            letter-spacing: .2px;
            transition: transform .2s ease, box-shadow .2s ease, opacity .2s ease;
        }

        .kyc-btn-add {
            min-height: 42px;
            padding: 0 20px;
            color: #fff;
            background: linear-gradient(120deg, #374151 0%, #5b6473 100%);
        }

        .kyc-btn-submit {
            min-width: 170px;
            min-height: 44px;
            padding: 0 26px;
            color: #fff;
            background: linear-gradient(120deg, var(--kyc-primary) 0%, var(--kyc-accent) 100%);
            box-shadow: 0 10px 22px rgba(36, 87, 230, .22);
        }

        .kyc-btn-add:hover,
        .kyc-btn-submit:hover {
            color: #fff;
            transform: translateY(-1px);
            box-shadow: 0 12px 24px rgba(31, 51, 94, .18);
        }

        .kyc-table-wrap {
            margin-top: 18px;
            border: 1px solid var(--kyc-border);
            border-radius: 13px;
            overflow-x: auto;
            background: #fff;
        }

        #ekyc_familytable {
            min-width: 720px;
            margin: 0 !important;
            border-collapse: separate;
            border-spacing: 0;
        }

        #ekyc_familytable thead th {
            padding: 12px 13px;
            border: 0;
            border-bottom: 1px solid var(--kyc-border);
            background: #eef4fb;
            color: #33415c;
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
            vertical-align: middle;
        }

        #ekyc_familytable tbody td {
            padding: 11px 13px;
            border-top: 1px solid #edf1f6;
            color: #4a5568;
            font-size: 12px;
            vertical-align: middle;
        }

        #ekyc_familytable tbody tr:hover {
            background: #f8fbff;
        }

        .kyc-submit-row {
            display: flex;
            justify-content: flex-end;
            padding: 2px 0 0;
        }

        .loading#load1 {
            display: none;
            position: fixed;
            inset: 0;
            width: 100%;
            height: 100%;
            margin: 0;
            z-index: 99999;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            background: rgba(15, 23, 42, .34);
            backdrop-filter: blur(2px);
            color: #fff;
        }

        .loading#load1 img {
            width: 64px;
            height: 64px;
            object-fit: contain;
            margin-bottom: 10px;
        }

        .loading#load1 > div {
            font-size: 13px !important;
            font-weight: 600 !important;
        }

        #ekyc_dverror .modal-content {
            border: 0;
            border-radius: 15px;
            box-shadow: 0 20px 50px rgba(15, 23, 42, .20);
            overflow: hidden;
        }

        #ekyc_dverror .modal-header {
            border-bottom: 1px solid var(--kyc-border);
            background: #f8fbff;
        }

        #ekyc_dverror .modal-title {
            color: var(--kyc-text);
            font-weight: 700;
        }

        @media (max-width: 1199.98px) {
            .kyc-col-3 { grid-column: span 6; }
            .kyc-family-entry { grid-template-columns: repeat(2, minmax(0, 1fr)); }
            .kyc-family-entry .kyc-action-field { grid-column: span 2; }
            .kyc-btn-add { width: 100%; }
        }

        @media (max-width: 767.98px) {
            .kyc-page { padding: 12px 8px 26px; }
            .kyc-hero {
                align-items: flex-start;
                flex-direction: column;
                padding: 18px;
                border-radius: 14px;
            }
            .kyc-hero h1 { font-size: 20px; }
            .kyc-hero-icon {
                width: 46px;
                height: 46px;
                flex-basis: 46px;
            }
            .kyc-section { border-radius: 14px; }
            .kyc-section-header {
                align-items: flex-start;
                flex-direction: column;
                padding: 14px;
            }
            .kyc-section-body { padding: 14px; }
            .kyc-col-3,
            .kyc-col-4,
            .kyc-col-6,
            .kyc-col-12 { grid-column: span 12; }
            .kyc-family-entry { grid-template-columns: 1fr; }
            .kyc-family-entry .kyc-action-field { grid-column: span 1; }
            .kyc-submit-row { justify-content: stretch; }
            .kyc-btn-submit { width: 100%; }
        }
    </style>

    <script>
        $(document).ready(function () {
            BindEmployeeKYCInfo();
            ekyc_BindFamilyGrid();
        });
    </script>

    <script src="https://jsuites.net/v5/jsuites.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" alt="Loading" />
        <div>One moment, please . . . .</div>
    </div>

    <main class="kyc-page">
        <div class="kyc-container">
            <section class="kyc-hero">
                <div class="kyc-hero-content">
                    <div class="kyc-hero-icon">
                        <i class="fas fa-id-card"></i>
                    </div>
                    <div>
                        <h1>Employee KYC Information</h1>
                        <p>Review and update personal, document, nominee and family details.</p>
                    </div>
                </div>
                <div class="kyc-hero-chip">
                    <i class="fas fa-shield-alt"></i>
                    Verified Employee Records
                </div>
            </section>

            <div class="kyc-form-shell">
                <section class="kyc-section">
                    <div class="kyc-section-header">
                        <h2 class="kyc-section-title">
                            <span class="icon-box"><i class="fas fa-user"></i></span>
                            Personal Information
                        </h2>
                        <p class="kyc-section-note">Basic employee and contact details</p>
                    </div>
                    <div class="kyc-section-body">
                        <div class="kyc-grid">
                            <div class="kyc-field kyc-col-3">
                                <label for="ekyc_fullname">Name</label>
                                <input type="text" id="ekyc_fullname" class="form-control" disabled />
                            </div>
                            <div class="kyc-field kyc-col-3">
                                <label for="ekyc_doj">Joining Date</label>
                                <input type="text" id="ekyc_doj" class="form-control" disabled />
                            </div>
                            <div class="kyc-field kyc-col-3">
                                <label for="ekyc_dob">Date of Birth</label>
                                <input type="date" id="ekyc_dob" class="form-control" />
                            </div>
                            <div class="kyc-field kyc-col-3">
                                <label for="ekyc_gender">Gender</label>
                                <select id="ekyc_gender" class="form-control">
                                    <option value="">Select</option>
                                    <option value="F">Female</option>
                                    <option value="M">Male</option>
                                </select>
                            </div>

                            <div class="kyc-field kyc-col-3">
                                <label for="ekyc_contact">Contact #</label>
                                <input type="number" id="ekyc_contact" class="form-control" />
                            </div>
                            <div class="kyc-field kyc-col-3">
                                <label for="ekyc_qualification">Qualification</label>
                                <select id="ekyc_qualification" class="form-control">
                                    <option value="">Select</option>
                                    <option value="I">ILLITERATE</option>
                                    <option value="N">NON MATRIC</option>
                                    <option value="M">MATRIC</option>
                                    <option value="S">SENIOR SECONDARY</option>
                                    <option value="G">GRADUATE</option>
                                    <option value="P">POST GRADUATE</option>
                                    <option value="D">DOCTORATE</option>
                                    <option value="O">OTHER</option>
                                </select>
                            </div>
                            <div class="kyc-field kyc-col-3">
                                <label for="ekyc_maritalstatus">Marital Status</label>
                                <select id="ekyc_maritalstatus" class="form-control" onchange="return getmarriagedate(this);">
                                    <option value="">Select</option>
                                    <option value="M">MARRIED</option>
                                    <option value="U">UNMARRIED</option>
                                    <option value="W">WIDOW/WIDOWER</option>
                                    <option value="D">DIVORCEE</option>
                                </select>
                            </div>
                            <div class="kyc-field kyc-col-3">
                                <label for="ekyc_marriagedate">Marriage Date</label>
                                <input type="date" id="ekyc_marriagedate" class="form-control" disabled />
                            </div>

                            <div class="kyc-field kyc-col-3">
                                <label for="ekyc_fatherhusbandname">Father/Husband Name</label>
                                <input type="text" id="ekyc_fatherhusbandname" class="form-control" />
                            </div>
                            <div class="kyc-field kyc-col-3">
                                <label for="ekyc_physicalhandicap">Physically Handicapped?</label>
                                <select id="ekyc_physicalhandicap" class="form-control">
                                    <option value="">Select</option>
                                    <option value="Y">Yes</option>
                                    <option value="N">No</option>
                                </select>
                            </div>
                            <div class="kyc-field kyc-col-3">
                                <label for="ekyc_handicapcategory">Handicap Category</label>
                                <select id="ekyc_handicapcategory" class="form-control">
                                    <option value="">Select</option>
                                    <option value="L">LOCOMOTIVE DISABILITY</option>
                                    <option value="V">VISUAL</option>
                                    <option value="H">HEARING</option>
                                </select>
                            </div>

                            <div class="kyc-field kyc-col-6">
                                <label for="ekyc_presentaddress">Present Address</label>
                                <textarea id="ekyc_presentaddress" class="form-control"></textarea>
                            </div>
                            <div class="kyc-field kyc-col-6">
                                <label for="ekyc_permanentaddress">Permanent Address</label>
                                <textarea id="ekyc_permanentaddress" class="form-control"></textarea>
                            </div>
                        </div>
                    </div>
                </section>

                <section class="kyc-section">
                    <div class="kyc-section-header">
                        <h2 class="kyc-section-title">
                            <span class="icon-box"><i class="fas fa-file-alt"></i></span>
                            Documents Information
                        </h2>
                        <p class="kyc-section-note">Banking and identity document details</p>
                    </div>
                    <div class="kyc-section-body">
                        <div class="kyc-grid">
                            <div class="kyc-field kyc-col-3">
                                <label for="ekyc_bankname">Bank Name</label>
                                <input type="text" id="ekyc_bankname" class="form-control" />
                            </div>
                            <div class="kyc-field kyc-col-3">
                                <label for="ekyc_accno">Account #</label>
                                <input type="text" id="ekyc_accno" class="form-control" />
                            </div>
                            <div class="kyc-field kyc-col-3">
                                <label for="ekyc_ifsccode">IFSC Code</label>
                                <input type="text" id="ekyc_ifsccode" class="form-control" />
                            </div>
                            <div class="kyc-field kyc-col-3">
                                <label for="ekyc_aadharno">Aadhaar #</label>
                                <input type="text" id="ekyc_aadharno" name="ekyc_aadharno" class="form-control" />
                            </div>
                            <div class="kyc-field kyc-col-3">
                                <label for="ekyc_panno">PAN #</label>
                                <input type="text" id="ekyc_panno" name="ekyc_panno" class="form-control" />
                            </div>
                            <div class="kyc-field kyc-col-3">
                                <label for="ekyc_documenttype">Document Type</label>
                                <select id="ekyc_documenttype" class="form-control">
                                    <option value="">Select</option>
                                    <option value="PP">Passport</option>
                                    <option value="D">Driving Licence</option>
                                </select>
                            </div>
                            <div class="kyc-field kyc-col-3">
                                <label for="ekyc_docno">Document #</label>
                                <input type="text" id="ekyc_docno" class="form-control" />
                            </div>
                            <div class="kyc-field kyc-col-3">
                                <label for="ekyc_expirydate">Expiry Date</label>
                                <input type="date" id="ekyc_expirydate" class="form-control" />
                            </div>
                        </div>
                    </div>
                </section>

                <section class="kyc-section">
                    <div class="kyc-section-header">
                        <h2 class="kyc-section-title">
                            <span class="icon-box"><i class="fas fa-user-check"></i></span>
                            Nominee Information
                        </h2>
                        <p class="kyc-section-note">Nominee contact and relationship details</p>
                    </div>
                    <div class="kyc-section-body">
                        <div class="kyc-grid">
                            <div class="kyc-field kyc-col-4">
                                <label for="ekyc_nomineename">Name</label>
                                <input type="text" id="ekyc_nomineename" class="form-control" />
                            </div>
                            <div class="kyc-field kyc-col-4">
                                <label for="ekyc_nomineerelation">Relation</label>
                                <select id="ekyc_nomineerelation" class="form-control">
                                    <option value="">Select</option>
                                    <option value="Father">Father</option>
                                    <option value="Mother">Mother</option>
                                    <option value="Husband">Husband</option>
                                    <option value="Wife">Wife</option>
                                </select>
                            </div>
                            <div class="kyc-field kyc-col-4">
                                <label for="ekyc_nomineebirthdate">Birth Date</label>
                                <input type="date" id="ekyc_nomineebirthdate" class="form-control" />
                            </div>
                            <div class="kyc-field kyc-col-4">
                                <label for="ekyc_nomineecontact">Contact #</label>
                                <input type="number" id="ekyc_nomineecontact" name="ekyc_nomineecontact" class="form-control" />
                            </div>
                            <div class="kyc-field kyc-col-6">
                                <label for="ekyc_nomineeaddress">Address</label>
                                <textarea id="ekyc_nomineeaddress" name="ekyc_nomineeaddress" class="form-control"></textarea>
                            </div>
                        </div>
                    </div>
                </section>

                <section class="kyc-section">
                    <div class="kyc-section-header">
                        <h2 class="kyc-section-title">
                            <span class="icon-box"><i class="fas fa-users"></i></span>
                            Family Information
                        </h2>
                        <p class="kyc-section-note">Add and manage employee family members</p>
                    </div>
                    <div class="kyc-section-body">
                        <div class="kyc-family-entry">
                            <div class="kyc-field">
                                <label for="ekcy_familyname">Full Name</label>
                                <input type="text" id="ekcy_familyname" class="form-control" />
                            </div>
                            <div class="kyc-field">
                                <label for="ekyc_familyrelation">Relation</label>
                                <select id="ekyc_familyrelation" class="form-control">
                                    <option value="">Select</option>
                                    <option value="Father">Father</option>
                                    <option value="Mother">Mother</option>
                                    <option value="Husband">Husband</option>
                                    <option value="Wife">Wife</option>
                                    <option value="Son">Son</option>
                                    <option value="Daughter">Daughter</option>
                                    <option value="Mother-in-law">Mother-in-law</option>
                                    <option value="Father-in-law">Father-in-law</option>
                                </select>
                            </div>
                            <div class="kyc-field">
                                <label for="ekyc_familyoccupation">Occupation</label>
                                <select id="ekyc_familyoccupation" class="form-control">
                                    <option value="">Select</option>
                                    <option value="Farmer">Farmer</option>
                                    <option value="Service">Service</option>
                                    <option value="Retired">Retired</option>
                                    <option value="Student">Student</option>
                                    <option value="Business">Business</option>
                                    <option value="HouseWife">HouseWife</option>
                                    <option value="UnEmployed">Unemployed</option>
                                    <option value="SelfEmployee">Self-Employed</option>
                                </select>
                            </div>
                            <div class="kyc-field">
                                <label for="ekyc_familybirthdate">Birth Date</label>
                                <input type="date" id="ekyc_familybirthdate" class="form-control" />
                            </div>
                            <div class="kyc-field kyc-action-field">
                                <button id="ekyc_btnaddfamilyinfo" class="kyc-btn-add" onclick="return ekyc_addfamilyinfo();">
                                    <i class="fas fa-plus mr-1"></i> Add
                                </button>
                            </div>
                        </div>

                        <div class="kyc-table-wrap">
                            <table class="table" id="ekyc_familytable" style="width: 100%;">
                                <thead>
                                    <tr>
                                        <th style="text-align: center;">Sr. #</th>
                                        <th>Name</th>
                                        <th>Relation</th>
                                        <th>Occupation</th>
                                        <th>Birth Date</th>
                                        <th>Delete</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </section>

                <div class="kyc-submit-row">
                    <button type="button" id="ekyc_btnsubmit" class="kyc-btn-submit" onclick="return ekyc_submit();">
                        <i class="fas fa-save mr-1"></i> Submit KYC
                    </button>
                </div>
            </div>
        </div>
    </main>

    <div class="modal fade" id="ekyc_dverror">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="ekyc_errmsg"></h6>
                </div>
                <div class="modal-footer justify-content-center">
                    <button class="btn btn-primary" type="button" id="empleave_btnMessage" onclick="location.reload();">Okay</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
