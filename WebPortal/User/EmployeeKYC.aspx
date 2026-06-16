<%@ Page Title="" Language="C#" MasterPageFile="~/User/User.Master" AutoEventWireup="true" CodeBehind="EmployeeKYC.aspx.cs" Inherits="WebPortal.User.EmployeeKYC" %>

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
            /*    background: linear-gradient(to bottom, #007bff, 3%, #fff) !important;*/
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
            BindEmployeeKYCInfo();
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>KYC Information</b></h6>
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
                        <td colspan="6">
                            <h6 class="mb-0">Employee Information</h6>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Full Name:</b></td>
                        <td>
                            <input type="text" id="ekyc_fullname" class="form-control" style="width: 250px;" disabled="disabled" />
                        </td>
                        <td><b>Joining Date:</b></td>
                        <td>
                            <input type="text" id="ekyc_doj" class="form-control" style="width: 250px;" disabled="disabled" />
                        </td>
                        <td><b>Date of Birth:</b></td>
                        <td>
                            <input type="date" id="ekyc_dob" class="form-control" style="width: 250px;" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Gender:</b></td>
                        <td>
                            <select id="ekyc_gender" name="ekyc_gender" class="form-control" style="width: 250px;">
                                <option value="">Select</option>
                                <option value="F">Female</option>
                                <option value="M">Male</option>
                            </select>
                        </td>
                        <td>
                            <b>Contact #:</b>
                        </td>
                        <td>
                            <input type="number" id="ekyc_contact" name="ekyc_contact" class="form-control" style="width: 250px;" />
                        </td>
                        <td><b>Qualification:</b></td>
                        <td>
                            <select id="ekyc_qualification" name="ekyc_qualification" class="form-control" style="width: 250px;">
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
                        </td>
                    </tr>
                    <tr>
                        <td><b>Marital Status:</b></td>
                        <td>
                            <select id="ekyc_maritalstatus" name="ekyc_maritalstatus" class="form-control" style="width: 250px;" onchange="return getmarriagedate(this);">
                                <option value="">Select</option>
                                <option value="M">MARRIED</option>
                                <option value="U">UNMARRIED</option>
                                <option value="W">WIDOW/WIDOWER</option>
                                <option value="D">DIVORCEE</option>
                            </select>
                        </td>
                        <td><b>Marriage Date:</b></td>
                        <td>
                            <input type="date" id="ekyc_marriagedate" name="ekyc_marriagedate" class="form-control" style="width: 250px;" disabled="disabled" />
                        </td>
                        <td><b>Father/ Husband Name:</b></td>
                        <td>
                            <input type="text" id="ekyc_fatherhusbandname" name="ekyc_fatherhusbandname" class="form-control" style="width: 250px;" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Physically Handicapped?</b></td>
                        <td>
                            <select id="ekyc_physicalhandicap" name="ekyc_physicalhandicap" class="form-control" style="width: 250px;">
                                <option value="">Select</option>
                                <option value="Y">Yes</option>
                                <option value="N">No</option>
                            </select>
                        </td>
                        <td><b>Handicap Category:</b></td>
                        <td>
                            <select id="ekyc_handicapcategory" name="ekyc_handicapcategory" class="form-control" style="width: 250px;">
                                <option value="">Select</option>
                                <option value="L">LOCOMOTIVE DISABILITY</option>
                                <option value="V">VISUAL</option>
                                <option value="H">HEARING</option>
                            </select>
                        </td>
                        <td><b>Present Address:</b></td>
                        <td>
                            <textarea id="ekyc_presentaddress" name="ekyc_presentaddress" class="form-control" style="width: 250px;"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Permanent Address:</b></td>
                        <td>
                            <textarea id="ekyc_permanentaddress" name="ekyc_permanentaddress" class="form-control" style="width: 250px;"></textarea>
                        </td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td colspan="6">
                            <h6 class="mb-0">Documents Information</h6>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Bank Name:</b></td>
                        <td>
                            <input type="text" id="ekyc_bankname" name="ekyc_bankname" class="form-control" style="width: 250px;" />
                        </td>
                        <td><b>Account #:</b></td>
                        <td>
                            <input type="text" id="ekyc_accno" name="ekyc_accno" class="form-control" style="width: 250px;" />
                        </td>
                        <td><b>IFSC Code:</b></td>
                        <td>
                            <input type="text" id="ekyc_ifsccode" name="ekyc_ifsccode" class="form-control" style="width: 250px;" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Bank Name:</b></td>
                        <td>
                            <select id="ekyc_documenttype" name="ekyc_documenttype" class="form-control" style="width: 250px;">
                                <option value="">Select</option>
                                <option value="PP">Passport</option>
                                <option value="D">Driving Licence</option>
                            </select>
                        </td>
                        <td><b>Document #:</b></td>
                        <td>
                            <input type="text" id="ekyc_docno" name="ekyc_docno" class="form-control" style="width: 250px;" />
                        </td>
                        <td><b>IFSC Code:</b></td>
                        <td>
                            <input type="date" id="ekyc_expirydate" name="ekyc_expirydate" class="form-control" style="width: 250px;" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Aadhar Card #</b></td>
                        <td>
                            <input type="text" id="ekyc_aadharno" name="ekyc_aadharno" class="form-control" style="width: 250px;" />
                        </td>
                        <td><b>PAN:</b></td>
                        <td>
                            <input type="text" id="ekyc_panno" name="ekyc_panno" class="form-control" style="width: 250px;" />
                        </td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td colspan="6">
                            <h6 class="mb-0">Documents Information</h6>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Name:</b></td>
                        <td>
                            <input tye="text" id="ekyc_nomineename" name="ekyc_nomineename" class="form-control" style="width: 250px;" />
                        </td>
                        <td><b>Relation:</b></td>
                        <td>
                            <select id="ekyc_nomineerelation" name="ekyc_nomineerelation" class="form-control" style="width: 250px;">
                                <option value="">Select</option>
                                <option value="Father">Father</option>
                                <option value="Mother">Mother</option>
                                <option value="Husband">Husband</option>
                                <option value="Wife">Wife</option>
                                <option value="Son">Son</option>
                                <option value="Daughter">Daughter</option>
                                <option value="Sister">Sister</option>
                                <option value="Brother">Brother</option>
                            </select>
                        </td>

                        <td><b>Birth Date:</b></td>
                        <td>
                            <input type="date" id="ekyc_nomineebirthdate" name="ekyc_nomineebirthdate" class="form-control" style="width: 250px;" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Contact #:</b></td>
                        <td>
                            <input type="number" id="ekyc_nomineecontact" name="ekyc_nomineecontact" class="form-control" style="width: 250px;" />
                        </td>
                        <td><b>Address:</b></td>
                        <td>
                            <textarea id="ekyc_nomineeaddress" name="ekyc_nomineeaddress" class="form-control" style="width: 250px;"></textarea></td>
                    </tr>
                    <tr>
                        <td colspan="6">
                            <h6 class="mb-0">Family Information</h6>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2"><b>Full Name</b></td>
                        <td><b>Relation</b></td>
                        <td><b>Occupation</b></td>
                        <td><b>Birth Date</b></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <input type="text" id="ekcy_familyname" name="ekcy_familyname" class="form-control" style="width: 350px;" />
                        </td>
                        <td>
                            <select id="ekyc_familyrelation" name="ekyc_familyrelation" class="form-control" style="width: 100px;">
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
                        </td>
                        <td>
                            <select id="ekyc_familyoccupation" name="ekyc_familyoccupation" class="form-control" style="width: 250px;">
                                <option value="">Select</option>
                                <option value="Farmer">Farmer</option>
                                <option value="Service">Service</option>
                                <option value="Retired">Retired</option>
                                <option value="Student">Student</option>
                                <option value="Business">Business</option>
                                <option value="HouseWife">HouseWife</option>
                                <option value="UnEmployed">UnEmployed</option>
                                <option value="SelfEmployee">Self-Employed</option>
                            </select>
                        </td>
                        <td>
                            <input type="date" id="ekyc_familybirthdate" name="ekyc_familybirthdate" class="form-control" style="width: 120px;" />
                        </td>
                        <td>
                            <button id="ekyc_btnaddfamilyinfo" class="btn btn-secondary" onclick="return ekyc_addfamilyinfo();">ADD</button>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="6">
                            <table class="table" id="ekyc_familytable" style="width: 100%;">
                                <thead>
                                    <tr>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Relation</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Occupation</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Birth Date</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Delete</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="6" style="text-align:center;">
                            <button id="ekyc_btnsubmit" name="ekyc_btnsubmit" class="btn btn-primary" onclick="return ekyc_submit();"></button>
                        </td>
                    </tr>
                </table>
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
                    <button class="btn btn-primary" type="button" id="ekyc_btnMessage" onclick="location.reload();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>
