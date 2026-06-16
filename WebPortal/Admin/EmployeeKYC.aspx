<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EmployeeKYC.aspx.cs" Inherits="WebPortal.Admin.EmployeeKYC" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

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
                <!-- Personal Information -->
                <div class="card card-primary card-outline">
                    <div class="card-header">
                        <div class="card-title" style="font-size: 13px;">
                            <i class="fas fa-edit"></i>&nbsp;
                            Personal Information:
                        </div>
                    </div>
                    <div class="card-body">
                        <!-- Row 1 -->
                        <div class="row mb-3">

                            <div class="col-md-3">
                                <label for="ekyc_fullname"><b>Name</b></label>
                                <input type="text" id="ekyc_fullname" class="form-control" disabled style="background-color: white;" />
                            </div>

                            <div class="col-md-3">
                                <label for="ekyc_doj"><b>Joining Date</b></label>
                                <input type="text" id="ekyc_doj" class="form-control" disabled style="background-color: white;" />
                            </div>

                            <div class="col-md-3">
                                <label for="ekyc_dob"><b>Date of Birth</b></label>
                                <input type="date" id="ekyc_dob" class="form-control" />
                            </div>

                            <div class="col-md-3">
                                <label for="ekyc_gender"><b>Gender</b></label>
                                <select id="ekyc_gender" class="form-control">
                                    <option value="">Select</option>
                                    <option value="F">Female</option>
                                    <option value="M">Male</option>
                                </select>
                            </div>
                        </div>

                        <!-- Row 2 -->
                        <div class="row mb-3">

                            <div class="col-md-3">
                                <label for="ekyc_contact"><b>Contact #</b></label>
                                <input type="number" id="ekyc_contact"
                                    class="form-control" />
                            </div>

                            <div class="col-md-3">
                                <label for="ekyc_qualification"><b>Qualification</b></label>
                                <select id="ekyc_qualification"
                                    class="form-control">
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

                            <div class="col-md-3">
                                <label for="ekyc_maritalstatus"><b>Marital Status</b></label>
                                <select id="ekyc_maritalstatus"
                                    class="form-control"
                                    onchange="return getmarriagedate(this);">
                                    <option value="">Select</option>
                                    <option value="M">MARRIED</option>
                                    <option value="U">UNMARRIED</option>
                                    <option value="W">WIDOW/WIDOWER</option>
                                    <option value="D">DIVORCEE</option>
                                </select>
                            </div>

                            <div class="col-md-3">
                                <label for="ekyc_marriagedate"><b>Marriage Date</b></label>
                                <input type="date" id="ekyc_marriagedate" style="background-color: white" class="form-control" disabled />
                            </div>

                        </div>

                        <!-- Row 3 -->
                        <div class="row mb-3">

                            <div class="col-md-3">
                                <label for="ekyc_fatherhusbandname">
                                    <b>Father/Husband Name</b>
                                </label>
                                <input type="text"
                                    id="ekyc_fatherhusbandname"
                                    class="form-control" />
                            </div>

                            <div class="col-md-3">
                                <label for="ekyc_physicalhandicap">
                                    <b>Physically Handicapped?</b>
                                </label>
                                <select id="ekyc_physicalhandicap"
                                    class="form-control">
                                    <option value="">Select</option>
                                    <option value="Y">Yes</option>
                                    <option value="N">No</option>
                                </select>
                            </div>

                            <div class="col-md-3">
                                <label for="ekyc_handicapcategory">
                                    <b>Handicap Category</b>
                                </label>
                                <select id="ekyc_handicapcategory"
                                    class="form-control">
                                    <option value="">Select</option>
                                    <option value="L">LOCOMOTIVE DISABILITY</option>
                                    <option value="V">VISUAL</option>
                                    <option value="H">HEARING</option>
                                </select>
                            </div>


                        </div>

                        <!-- Row 4 -->
                        <div class="row mb-4">

                            <div class="col-md-6 mb-3">
                                <label for="ekyc_presentaddress">
                                    <b>Present Address</b>
                                </label>
                                <textarea id="ekyc_presentaddress"
                                    class="form-control"></textarea>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="ekyc_permanentaddress">
                                    <b>Permanent Address</b>
                                </label>
                                <textarea id="ekyc_permanentaddress"
                                    class="form-control"></textarea>
                            </div>

                        </div>
                    </div>
                </div>

                <!-- Documents Information -->
                <div class="card card-primary card-outline">
                    <div class="card-header">
                        <div class="card-title" style="font-size: 13px;"><i class="fas fa-edit"></i>&nbsp;Documents Information</div>
                    </div>
                    <div class="card-body">

                        <!-- Row 1 -->
                        <div class="row g-3 mb-3">

                            <div class="col-md-3">
                                <label for="ekyc_bankname" class="form-label">
                                    <b>Bank Name</b>
                                </label>
                                <input type="text"
                                    id="ekyc_bankname"
                                    class="form-control" />
                            </div>

                            <div class="col-md-3">
                                <label for="ekyc_accno" class="form-label">
                                    <b>Account #</b>
                                </label>
                                <input type="text"
                                    id="ekyc_accno"
                                    class="form-control" />
                            </div>

                            <div class="col-md-3">
                                <label for="ekyc_ifsccode" class="form-label">
                                    <b>IFSC Code</b>
                                </label>
                                <input type="text"
                                    id="ekyc_ifsccode"
                                    class="form-control" />
                            </div>
                            <div class="col-md-3">
                                <label for="ekyc_aadharno" class="form-label">
                                    <b>Aadhaar #</b>
                                </label>
                                <input type="text"
                                    id="ekyc_aadharno"
                                    name="ekyc_aadharno"
                                    class="form-control" />
                            </div>
                        </div>

                        <!-- Row 2 -->
                        <div class="row g-3 mb-3">
                            <div class="col-md-3">
                                <label for="ekyc_panno" class="form-label">
                                    <b>PAN #</b>
                                </label>
                                <input type="text"
                                    id="ekyc_panno"
                                    name="ekyc_panno"
                                    class="form-control" />
                            </div>


                            <div class="col-md-3">
                                <label for="ekyc_documenttype" class="form-label">
                                    <b>Document Type</b>
                                </label>

                                <select id="ekyc_documenttype"
                                    class="form-control">

                                    <option value="">Select</option>
                                    <option value="PP">Passport</option>
                                    <option value="D">Driving Licence</option>

                                </select>
                            </div>


                            <div class="col-md-3">
                                <label for="ekyc_docno" class="form-label">
                                    <b>Document #</b>
                                </label>
                                <input type="text"
                                    id="ekyc_docno"
                                    class="form-control" />
                            </div>

                            <div class="col-md-3">
                                <label for="ekyc_expirydate" class="form-label">
                                    <b>Expiry Date</b>
                                </label>
                                <input type="date"
                                    id="ekyc_expirydate"
                                    class="form-control" />
                            </div>



                        </div>

                    </div>
                    <%--   <div class="card-body">
                        <div class="row mb-3">

                            <div class="col-md-4">
                                <label for="ekyc_bankname"><b>Bank Name</b></label>
                                <input type="text"
                                    id="ekyc_bankname"
                                    class="form-control" />
                            </div>

                            <div class="col-md-4">
                                <label for="ekyc_accno"><b>Account #</b></label>
                                <input type="text"
                                    id="ekyc_accno"
                                    class="form-control" />
                            </div>

                            <div class="col-md-4">
                                <label for="ekyc_ifsccode"><b>IFSC Code</b></label>
                                <input type="text"
                                    id="ekyc_ifsccode"
                                    class="form-control" />
                            </div>
                        </div>

                        <div class="row mb-3">

                            <div class="col-md-4">
                                <label for="ekyc_documenttype"><b>Document Type</b></label>
                                <select id="ekyc_documenttype"
                                    class="form-control">
                                    <option value="">Select</option>
                                    <option value="PP">Passport</option>
                                    <option value="D">Driving Licence</option>
                                </select>
                            </div>

                            <div class="col-md-4">
                                <label for="ekyc_docno"><b>Document #</b></label>
                                <input type="text"
                                    id="ekyc_docno"
                                    class="form-control" />
                            </div>

                            <div class="col-md-4">
                                <label for="ekyc_expirydate"><b>Expiry Date</b></label>
                                <input type="date"
                                    id="ekyc_expirydate"
                                    class="form-control" />
                            </div>
                        </div>
                        <div class="row mb-3">

                            <div class="col-md-4">
                                <label for="ekyc_documenttype"><b>Aaadhar #</b></label>
                                <input type="text" id="ekyc_aadharno" name="ekyc_aadharno" class="form-control" />
                            </div>

                            <div class="col-md-4">
                                <label for="ekyc_docno"><b>PAN #</b></label>
                                <input type="text" id="ekyc_panno" name="ekyc_panno" class="form-control" />
                            </div>
                        </div>
                    </div>--%>
                </div>

                <!-- Nominee Information -->
                <div class="card card-primary card-outline">
                    <div class="card-header">
                        <div class="card-title" style="font-size: 13px;"><i class="fas fa-edit"></i>&nbsp;Nominee Information</div>
                    </div>
                    <div class="card-body">
                        <div class="row mb-3">

                            <div class="col-md-4">
                                <label for="ekyc_nomineename"><b>Name</b></label>
                                <input type="text"
                                    id="ekyc_nomineename"
                                    class="form-control" />
                            </div>

                            <div class="col-md-4">
                                <label for="ekyc_nomineerelation"><b>Relation</b></label>
                                <select id="ekyc_nomineerelation"
                                    class="form-control">
                                    <option value="">Select</option>
                                    <option value="Father">Father</option>
                                    <option value="Mother">Mother</option>
                                    <option value="Husband">Husband</option>
                                    <option value="Wife">Wife</option>
                                </select>
                            </div>

                            <div class="col-md-4">
                                <label for="ekyc_nomineebirthdate"><b>Birth Date</b></label>
                                <input type="date"
                                    id="ekyc_nomineebirthdate"
                                    class="form-control" />
                            </div>

                        </div>
                        <div class="row mb-3">
                            <div class="col-md-4">
                                <label for="ekyc_nomineename"><b>Contact #</b></label>
                                <input type="number" id="ekyc_nomineecontact" name="ekyc_nomineecontact" class="form-control" />
                            </div>
                            <div class="col-md-4">
                                <label for="ekyc_nomineerelation"><b>Address</b></label>
                                <textarea id="ekyc_nomineeaddress" name="ekyc_nomineeaddress" class="form-control"></textarea>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Family Information -->
                <div class="card card-primary card-outline">
                    <div class="card-header">
                        <div class="card-title" style="font-size: 13px;"><i class="fas fa-edit"></i>&nbsp;Family Information</div>
                    </div>
                    <div class="card-body">
                        <div class="row mb-3 align-items-end">

                            <div class="col">
                                <label for="ekcy_familyname"><b>Full Name</b></label>
                                <input type="text" id="ekcy_familyname" class="form-control" />
                            </div>

                            <div class="col">
                                <label for="ekyc_familyrelation"><b>Relation</b></label>
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

                            <div class="col">
                                <label for="ekyc_familyoccupation"><b>Occupation</b></label>
                                <select id="ekyc_familyoccupation"
                                    class="form-control">
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

                            <div class="col">
                                <label for="ekyc_familybirthdate"><b>Birth Date</b></label>
                                <input type="date"
                                    id="ekyc_familybirthdate"
                                    class="form-control" />
                            </div>

                            <div class="col-auto">
                                <button id="ekyc_btnaddfamilyinfo"
                                    class="btn btn-secondary w-100"
                                    onclick="return ekyc_addfamilyinfo();">
                                    ADD
                                </button>
                            </div>
                        </div>

                        <!-- Family Table -->
                        <div class="row mb-4">
                            <div class="col-md-12">
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
                    </div>
                </div>

                <div class="row">
                    <div class="col d-flex justify-content-center">
                        <button type="button" id="ekyc_btnsubmit" class="btn btn-gradient-primary" onclick="return ekyc_submit();" style="width: 150px;">Submit</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="ekyc_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="ekyc_errmsg"></h6>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="empleave_btnMessage" onclick="location.reload();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>
