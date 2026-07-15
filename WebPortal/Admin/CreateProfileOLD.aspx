<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="CreateProfileOLD.aspx.cs" Inherits="WebPortal.Admin.CreateProfileOLD" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://jsuites.net/v5/jsuites.js"></script>

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

        /*.form-control {
            font-size: 11px !important;
        }*/
    </style>

    <script>

        $(document).ready(function () {
            const urlParams = new URLSearchParams(window.location.search);
            var type = '';
            var Code = '';
            var res = urlParams.toString().indexOf("Code");
            if (res != -1) {
                type = "Code";
                Code = urlParams.get('Code');
                /* BindExistingInfo(Code);*/
            }
            res = urlParams.toString().indexOf("AppID");
            if (res != -1) {
                type = "AppID";
                Code = urlParams.get('AppID');
            }

            if (type == "AppID") {
                BindInfoFromApplicationForm(Code);
                document.getElementById("btnSubmit").innerHTML = "Submit";
            }
            else if (type == "Code") {
                document.getElementById("btnSubmit").innerHTML = "Update";
                BindExistingInfo(Code);
            }
            else {
                document.getElementById("btnSubmit").innerHTML = "Submit";
                bindrequistions();
                bindbranches();
                bindddepartment();
                binddesignation();
                bindprojectamanagers();
                binddshift();
                bindweeklyholiday();
                bindprojects();
                binddomains();
                bindsubdomains();
                getagreementdetails();
                bindbanks();
            }

            // alert(document.getElementById("btnSubmit").innerHTML);

        });

        var fileslist = '';
        var fd = new FormData();

        window.onload = function () {

            document.getElementById('accountattachment').addEventListener('change', getFileName);
        }

        const cp_getFileName = (event) => {

            for (var i = 0; i < event.target.files.length; i++) {

                const files = event.target.files;
                var file = files[i];
                document.getElementById("fdaccountattachment").value = files[i].name;

                if (fileslist != '')
                    fileslist = fileslist + ',' + file.name;
                else
                    fileslist = file.name;

                // add all selected files
                fd.append(event.target.name, file, file.name);

                // create the request
            }

            const xhr = new XMLHttpRequest();

            xhr.onload = () => {

                if (xhr.status >= 200 && xhr.status < 300) {
                    // we done!
                }
            };
            var url = window.location.href;
            // path to server would be where you'd normally post the form to
            xhr.open('POST', url, true);
            xhr.send(fd);
            document.getElementById("dropzoneAccattachment").classList.add("dz-max-files-reached");
            document.getElementById("conentdivAccattachment").style.display = '';
            document.getElementById("filesdivAccattachment").innerHTML = fileslist;
        }

    </script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <%--<script src="../Scripts/Functions/CreateProfile.js"></script>--%>
    <portal:VersionedScript Src="~/Scripts/Functions/CreateprofileNew.js" runat="server"></portal:VersionedScript>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <input id="fdaccountattachment" style="display: none;" />
    <%-- <asp:Label ID="lblOldBankAcc" runat="server" Style="display: none;"></asp:Label>
    <asp:Label ID="lblOldIFSC" runat="server" Style="display: none;"></asp:Label>--%>

    <div class="modal fade" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;">System is sending email. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="dashboard-header">
        <div class="d-flex justify-content-between align-items-start mb-1">
            <div>
                <div class="dashboard-title">
                    <i class="fas fa-user-edit mr-2"></i>
                    Create / View / Update Employee Profile
                </div>
                <div class="dashboard-subtitle">
                    Create new employee records, update existing information, and maintain employee profiles.
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <input id="filep" style="display: none;" />
                <div id="dvError" runat="server" style="display: none;"></div>
                <div style="width: 100%;">
                    <span style="float: right; font-weight: bold; text-decoration: underline; font-style: italic;">Fields marked with <i class="fa fa-star" style="font-size: 5px; color: red; text-decoration: underline;"></i>are mandatory.</span><br />

                    <div class="card card-primary card-outline">
                        <div class="card-header">
                            <div class="card-title">
                                <i class="fas fa-edit"></i>
                                Personal Information:
                            </div>
                        </div>
                        <table class="table table-responsive">
                            <tr>
                                <td><i class="fa fa-star" style="font-size: 5px; color: red"></i>&nbsp;<b>Requisition:</b></td>
                                <td colspan="5">
                                    <select id="requisition" name="requisition" style="width: 500px;" class="form-control">
                                        <option value="">Select</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td><i class="fa fa-star" style="font-size: 5px; color: red"></i>&nbsp;<b>Name:</b></td>
                                <td colspan="3">
                                    <select id="title" name="title" class="form-control" style="width: 80px; display: inline;">
                                        <option value="">Select</option>
                                        <option value="Mr.">Mr.</option>
                                        <option value="Ms.">Ms.</option>
                                        <option value="Mrs.">Mrs.</option>
                                    </select>
                                    &nbsp;&nbsp;
                    <input type="text" id="firstname" name="firstname" placeholder="First Name" class="form-control" style="width: 170px; display: inline!important;" />
                                    &nbsp;&nbsp;
                    <input type="text" id="middlename" name="middlename" placeholder="Middle Name" class="form-control" style="width: 170px; display: inline!important;" />
                                    &nbsp;&nbsp;
                    <input type="text" id="lastname" name="lastname" class="form-control" placeholder="Last Name" style="width: 170px; display: inline!important;" />
                                </td>

                                <td><i class="fa fa-star" style="font-size: 5px; color: red"></i>&nbsp;<b>Employee Type:</b></td>
                                <td>
                                    <select id="employeetype" name="employeetype" class="form-control" style="width: 200px;" onchange="GenerateEmpCode();">
                                        <option value="">Select</option>
                                        <option value="Consultant">Consultant</option>
                                        <option value="Employee">Employee</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td><i class="fa fa-star" style="font-size: 5px; color: red"></i>&nbsp;<b>Code:</b></td>
                                <td>
                                    <input type="text" id="code" name="code" class="form-control" style="width: 200px; background-color: white; font-weight: bold; text-transform: uppercase;" />
                                </td>
                                <td><i class="fa fa-star" style="font-size: 5px; color: red"></i>&nbsp;<b>Gender:</b></td>
                                <td>
                                    <select id="gender" name="gender" class="form-control" style="width: 200px; display: inline;">
                                        <option value="">Select</option>
                                        <option value="Female">Female</option>
                                        <option value="Male">Male</option>
                                    </select>
                                </td>
                                <td><i class="fa fa-star" style="font-size: 5px; color: red"></i>&nbsp;<b>PAN:</b></td>
                                <td>
                                    <input type="text" id="pan" name="pan" class="form-control" style="width: 200px;" /></td>
                            </tr>
                            <tr>
                                <td><i class="fa fa-star" style="font-size: 5px; color: red"></i>&nbsp;<b>Present Address:</b></td>
                                <td colspan="3">
                                    <textarea id="presentaddress" name="presentaddress" class="form-control" style="width: 600px;"></textarea>
                                </td>
                                <td colspan="2">
                                    <input type="checkbox" id="chkaddress" name="chkaddress" onclick="getaddress(this);" />
                                    <b>Is permanent address is same as present address?</b>
                                </td>
                            </tr>
                            <tr>
                                <td><i class="fa fa-star" style="font-size: 5px; color: red"></i>&nbsp;<b>Permanent Address:</b></td>
                                <td colspan="3">
                                    <textarea id="permanentaddress" name="permanentaddress" class="form-control" style="width: 600px;"></textarea>
                                </td>
                                <td></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td><i class="fa fa-star" style="font-size: 5px; color: red"></i>&nbsp;<b>Email ID:</b></td>
                                <td>
                                    <input type="email" id="email" name="email" class="form-control" style="width: 200px;" />
                                </td>
                                <td><i class="fa fa-star" style="font-size: 5px; color: red"></i>&nbsp;<b>Qualification:</b></td>
                                <td>
                                    <input type="text" id="qualification" name="qualification" class="form-control" style="width: 200px;" />
                                </td>
                                <td><i class="fa fa-star" style="font-size: 5px; color: red"></i>&nbsp;<b>Mobile #:</b></td>
                                <td>
                                    <input type="text" id="cellno" name="cellno" class="form-control" style="width: 200px;" />
                                </td>
                            </tr>
                            <tr>
                                <td><b>Res. Tel #:</b></td>
                                <td>
                                    <input type="text" id="restelno" name="restelno" class="form-control" style="width: 200px;" />
                                </td>
                                <td><i class="fa fa-star" style="font-size: 5px; color: red"></i>&nbsp;<b>Birth Date:</b></td>
                                <td>
                                    <input type="date" id="birthdate" name="birthdate" class="form-control" style="width: 200px;" />
                                </td>
                                <td><i class="fa fa-star" style="font-size: 5px; color: red"></i>&nbsp;<b>Blood Group:</b></td>
                                <td>
                                    <select id="bloodgroup" name="bloodgroup" class="form-control" style="width: 200px; display: inline;">
                                        <option value="">Select</option>
                                        <option value="A+">A+</option>
                                        <option value="A-">A-</option>
                                        <option value="B+">B+</option>
                                        <option value="B-">B-</option>
                                        <option value="AB+">AB+</option>
                                        <option value="AB-">AB-</option>
                                        <option value="O+">O+</option>
                                        <option value="O-">O-</option>
                                        <option value="NA">NA</option>
                                    </select>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="card card-primary card-outline">
                        <div class="card-header">
                            <div class="card-title">
                                <i class="fas fa-edit"></i>
                                Official Information:
                            </div>
                        </div>
                        <table class="table table-responsive">
                            <tr>
                                <td><i class="fa fa-star" style="font-size: 5px; color: red"></i>&nbsp;<b>Joining Date:</b></td>
                                <td>
                                    <input type="date" id="joiningdate" name="joiningdate" class="form-control" style="width: 200px;" />
                                </td>
                                <td><i class="fa fa-star" style="font-size: 5px; color: red"></i>&nbsp;<b>Salary:</b></td>
                                <td>
                                    <input type="number" id="salary" name="salary" class="form-control" style="width: 200px;" /></td>
                                <td><i class="fa fa-star" style="font-size: 5px; color: red"></i>&nbsp;<b>Working Branch:</b></td>
                                <td>
                                    <select id="branch" name="branch" class="form-control" style="width: 200px; display: inline;">
                                        <option value="">Select</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td><i class="fa fa-star" style="font-size: 5px; color: red"></i>&nbsp;<b>Department:</b></td>
                                <td>
                                    <select id="department" name="department" class="form-control" style="width: 200px; display: inline;">
                                        <option value="">Select</option>
                                    </select>
                                </td>
                                <td><i class="fa fa-star" style="font-size: 5px; color: red"></i>&nbsp;<b>Designation:</b></td>
                                <td>
                                    <select id="designation" name="designation" class="form-control" style="width: 200px; display: inline;">
                                        <option value="">Select</option>
                                    </select>
                                <td><i class="fa fa-star" style="font-size: 5px; color: red"></i>&nbsp;<b>Reporting Manager:</b></td>
                                <td>
                                    <select id="reportingmanager" name="reportingmanager" class="form-control" style="width: 200px; display: inline;">
                                        <option value="">Select</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td><i class="fa fa-star" style="font-size: 5px; color: red"></i>&nbsp;<b>Shift:</b></td>
                                <td>
                                    <select id="shift" name="shift" class="form-control" style="width: 200px;" onchange="getcutoff(this);">
                                        <option value="">Select</option>
                                    </select>
                                </td>
                                <td><i class="fa fa-star" style="font-size: 5px; color: red"></i>&nbsp;<b>Cut Off Time:</b></td>
                                <td>
                                    <input type="text" id="cutofftime" name="cutofftime" class="form-control" style="width: 200px;" data-mask='hh:mm' />
                                <td><i class="fa fa-star" style="font-size: 5px; color: red"></i>&nbsp;<b>Working Hours:</b></td>
                                <td>
                                    <select id="workinghours" name="workinghours" class="form-control" style="width: 200px;" onchange="onworkinghoursclick();">
                                        <option value="">Select</option>
                                        <option value="2">08</option>
                                        <option value="3">10</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td><i class="fa fa-star" style="font-size: 5px; color: red"></i>&nbsp;<b>Weekly Holiday:</b></td>
                                <td>
                                    <select id="weeklyholiday" name="weeklyholiday" class="form-control" style="width: 200px;">
                                        <option value="">Select</option>
                                    </select>
                                </td>
                                <td><i class="fa fa-star" style="font-size: 5px; color: red"></i>&nbsp;<b>Project #:</b></td>
                                <td>
                                    <select id="projects" name="projects" class="form-control" style="width: 200px;">
                                        <option value="">Select</option>
                                    </select>

                                <td><b>Process:</b></td>
                                <td>
                                    <input type="text" id="process" name="process" class="form-control" style="width: 200px;" />
                                </td>
                            </tr>
                            <tr>
                                <td><i class="fa fa-star" style="font-size: 5px; color: red"></i>&nbsp;<b>Task/ Productive?:</b></td>
                                <td>
                                    <select id="taskproductive" name="taskproductive" class="form-control" style="width: 200px;">
                                        <option value="">Select</option>
                                        <option value="Task">Task</option>
                                        <option value="Productivity">Productivity</option>
                                    </select>
                                </td>
                                <td><i class="fa fa-star" style="font-size: 5px; color: red"></i>&nbsp;<b>Domain:</b></td>
                                <td>
                                    <select id="domain" name="domain" class="form-control" style="width: 200px;">
                                        <option value="">Select</option>
                                    </select>

                                <td><i class="fa fa-star" style="font-size: 5px; color: red"></i>&nbsp;<b>Subdomain:</b></td>
                                <td>
                                    <select id="subdomain" name="subdomain" class="form-control" style="width: 200px; display: inline;">
                                        <option value="">Select</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td><b>Remark:</b></td>
                                <td colspan="3">
                                    <textarea id="remark" placeholder="[ Format : Training For 'Process Name' ('Training Start Date' to 'Training End Date')]" name="remark" class="form-control" style="width: 550px;"></textarea>
                                </td>
                                <td><i class="fa fa-star" style="font-size: 5px; color: red"></i>&nbsp;<b>Appointment Date:</b></td>
                                <td>
                                    <input type="date" id="appointmentdate" name="appointmentdate" class="form-control" style="width: 200px;" />
                                </td>
                            </tr>
                            <tr>
                                <td><b>Aadhar #:</b></td>
                                <td>
                                    <input type="text" id="aadharno" name="aadharno" class="form-control" style="width: 200px;" />
                                </td>
                                <td><b>UAN:</b></td>
                                <td>
                                    <input type="text" id="uan" name="uan" class="form-control" style="width: 200px;" />
                                </td>
                                <td><b>ESIC #:</b></td>
                                <td>
                                    <input type="text" id="esicno" name="esicno" class="form-control" style="width: 200px;" />
                                </td>
                            </tr>
                            <tr>
                                <td><b>PF #:</b></td>
                                <td>
                                    <input type="text" id="pfno" name="pfno" class="form-control" style="width: 200px;" />
                                </td>
                                <td><b>Official Email:</b></td>
                                <td>
                                    <input type="text" id="officialemail" name="officialemail" class="form-control" style="width: 200px;" />
                                </td>
                                <td><b>Applicable for policy?:</b></td>
                                <td>
                                    <select id="policy" name="policy" class="form-control" style="width: 200px;">
                                        <option value="">Select</option>
                                        <option value="Yes">Yes</option>
                                        <option value="No">No</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td><b>Job Type:</b></td>
                                <td>
                                    <select id="jobtype" name="jobtype" class="form-control" style="width: 200px;">
                                        <option value="">Select</option>
                                        <option value="Work From Home">Work From Home</option>
                                        <option value="Work From Office">Work From Office</option>
                                    </select>
                                </td>
                                <tr>
                            <tr>
                                <td colspan="6">
                                    <div class="agreement-switch">
                                        <label class="switch">
                                            <input type="checkbox"
                                                id="chkagreement"
                                                name="chkagreement"
                                                onchange="getagreementdetails();">
                                            <span class="slider round"></span>
                                        </label>

                                        <div class="agreement-content">
                                            <label for="chkagreement" class="agreement-title">
                                                Agreement Applicable
                                            </label>
                                            <span class="agreement-subtitle">Enable if employee agreement is applicable
                                            </span>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr id="tragreement">
                                <td><b>Agreement Period:</b></td>
                                <td>
                                    <select id="agreementperiod" name="agreementperiod" class="form-control" style="width: 200px;">
                                        <option value="">Select</option>
                                        <option value="1">1</option>
                                        <option value="2">2</option>
                                        <option value="3">3</option>
                                        <option value="4">4</option>
                                        <option value="5">5</option>
                                    </select>
                                </td>
                                <td><b>Agreement Date:</b></td>
                                <td>
                                    <input type="date" id="agreementdate" name="agreementdate" class="form-control" style="width: 200px;" />
                                </td>
                                <td><b>Expiry Date:</b></td>
                                <td>
                                    <input type="date" id="agreementexpirydate" name="agreementexpirydate" class="form-control" style="width: 200px;" />
                                </td>
                            </tr>

                            <tr>
                                <td colspan="6">
                                    <div class="card-blue card-outline">
                                        <i class="fas fa-barcode"></i>
                                        <b style="font-size: 14px;">Bank Details:</b>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td><b>Bank Name:</b></td>
                                <td>
                                    <select id="bankname" name="bankname" class="form-control" style="width: 200px;">
                                        <option value="">Select</option>
                                    </select>
                                </td>
                                <td><b>Account #:</b></td>
                                <td>
                                    <input type="text" id="accountno" name="accountno" class="form-control" style="width: 200px;" />
                                </td>
                                <td><b>Re-enter Account #:</b></td>
                                <td>
                                    <input type="text" id="reaccountno" name="reaccountno" class="form-control" style="width: 200px;" />
                                </td>
                            </tr>
                            <tr>
                                <td><b>IFSC Code:</b></td>
                                <td>
                                    <input type="text" id="ifsccode" name="ifsccode" class="form-control" style="width: 200px;" />
                                </td>
                                <td><b>Re-enter IFSC Code:</b></td>
                                <td>
                                    <input type="text" id="reifsccode" name="reifsccode" class="form-control" style="width: 200px;" />
                                </td>
                                <td><b>Proof:</b></td>
                                <td>
                                    <input type="file" id="accountattachment" name="accountattachment" class="form-control" style="width: 200px;" />
                                    <div class="dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete" id="dropzoneAccattachment">
                                        <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column" id="conentdivAccattachment" style="display: none!important;">
                                            <div class="flex-1 d-flex flex-between-center">
                                                <div id="filesdivAccattachment" style="margin-top: 10px; margin-bottom: 10px;"></div>
                                                <div class="dropdown font-sans-serif">
                                                    <button class="btn btn-link text-600 btn-sm dropdown-toggle btn-reveal dropdown-caret-none" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                        <svg class="svg-inline--fa fa-ellipsis" style="display: none!important" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="ellipsis" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg="">
                                                            <path fill="currentColor" d="M120 256C120 286.9 94.93 312 64 312C33.07 312 8 286.9 8 256C8 225.1 33.07 200 64 200C94.93 200 120 225.1 120 256zM280 256C280 286.9 254.9 312 224 312C193.1 312 168 286.9 168 256C168 225.1 193.1 200 224 200C254.9 200 280 225.1 280 256zM328 256C328 225.1 353.1 200 384 200C414.9 200 440 225.1 440 256C440 286.9 414.9 312 384 312C353.1 312 328 286.9 328 256z"></path></svg><!-- <span class="fas fa-ellipsis-h"></span> Font Awesome fontawesome.com --></button>
                                                    <div class="dropdown-menu dropdown-menu-end border py-2"><a class="dropdown-item" href="#!" data-dz-remove="data-dz-remove">Remove File</a></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6" style="text-align: center;">
                                    <%--<button id="btnSubmit" onclick="return create_submitdata();" class="btn crp_btnSubmit">Submit</button>--%>
                                    <button type="button" id="btnSubmit" onclick="return create_submitdata()" class="btn btn-primary px-8"><i class="fa fa-save"></i>&nbsp;&nbsp;Submit</button>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="crp_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="crp_errmsg"></h6>
                    <%--<button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>--%>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="crp_btnMessage" onclick="return crp_Message();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>


    <style>
        #btnSubmit {
            min-width: 260px;
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
        }

        .agreement-switch {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 16px;
            border: 1px solid #e5e7eb;
            border-radius: 10px;
            background: #f8fafc;
            margin-top: 10px;
        }

        .switch {
            position: relative;
            display: inline-block;
            width: 52px;
            height: 28px;
            margin: 0;
        }

            .switch input {
                opacity: 0;
                width: 0;
                height: 0;
            }

        .slider {
            position: absolute;
            inset: 0;
            cursor: pointer;
            background-color: #d1d5db;
            transition: .3s;
        }

            .slider:before {
                position: absolute;
                content: "";
                height: 22px;
                width: 22px;
                left: 3px;
                bottom: 3px;
                background-color: white;
                transition: .3s;
            }

        input:checked + .slider {
            background-color: #0d6efd;
        }

            input:checked + .slider:before {
                transform: translateX(24px);
            }

        .slider.round {
            border-radius: 34px;
        }

            .slider.round:before {
                border-radius: 50%;
            }

        .agreement-content {
            display: flex;
            flex-direction: column;
        }

        .agreement-title {
            font-weight: 600;
            color: #212529;
            margin-bottom: 2px;
            cursor: pointer;
        }

        .agreement-subtitle {
            font-size: 12px;
            color: #6c757d;
        }
    </style>


    <style>
        body {
            background: #f4f7fb;
        }

        .dashboard-header {
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            border-radius: 15px;
            padding: 12px;
            color: white;
            position: relative;
            overflow: hidden;
            margin-bottom: 25px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        }

            .dashboard-header::after {
                content: '';
                position: absolute;
                right: -70px;
                top: -50px;
                width: 220px;
                height: 220px;
                background: rgba(255,255,255,0.12);
                border-radius: 50%;
            }

        .dashboard-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .dashboard-subtitle {
            font-size: 12px;
            opacity: 0.9;
            /*text-transform: uppercase;*/
        }
    </style>

</asp:Content>
