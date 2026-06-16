<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="CreateProfile.aspx.cs" Inherits="WebPortal.Admin.CreateProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style id="st_mainheader">
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

    <style id="st_mainLayout">
        .modern-card {
            background: #fff;
            border-radius: 14px;
            box-shadow: 0 8px 24px rgba(0,0,0,.08);
            border: 1px solid #e9ecef;
            margin-bottom: 20px;
            overflow: hidden;
            width: 100%;
        }

        .modern-card-header {
            padding: 16px 20px;
            background: linear-gradient(135deg, #0d6efd, #4dabf7);
            color: #fff;
            font-size: 18px;
            font-weight: 600;
        }

        .modern-card-body {
            padding: 15px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 3px 25px; /* row-gap column-gap */
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

            .form-group label {
                font-weight: 600;
                margin-bottom: 6px;
                color: #343a40;
            }

        .required {
            color: red;
            font-size: 8px;
            vertical-align: middle;
        }

        .form-control {
            width: 100%;
            border-radius: 8px;
            border: 1px solid #ced4da;
            padding: 9px 9px;
            height: 35px;
        }

        textarea.form-control {
            height: 50px;
            resize: vertical;
        }

        .span-2 {
            grid-column: span 2;
        }

        .span-4 {
            grid-column: span 4;
        }

        .name-row {
            display: grid;
            grid-template-columns: 80px 1fr 1fr 1fr;
            gap: 10px;
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-top: 28px;
            font-weight: 600;
        }

        @media (max-width: 992px) {
            .form-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .span-2,
            .span-4 {
                grid-column: span 2;
            }
        }

        @media (max-width: 576px) {
            .form-grid,
            .name-row {
                grid-template-columns: 1fr;
            }

            .span-2,
            .span-4 {
                grid-column: span 1;
            }
        }
    </style>

    <style id="st_button">
        .card-footer-modern {
            display: flex;
            justify-content: center;
            padding: 24px;
            border-top: 1px solid #e9ecef;
            margin-top: 20px;
        }

        .btn-submit {
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            color: #fff;
            border: none;
            border-radius: 10px;
            padding: 12px 100px;
            font-size: 24px;
            font-weight: 700;
            cursor: pointer;
            transition: all .3s ease;
            display: flex;
            align-items: center;
            justify-content: center; /* Center content horizontally */
            gap: 8px;
        }

            .btn-submit:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(13,110,253,.25);
            }

            .btn-submit:active {
                transform: translateY(0);
            }
    </style>

    <style id="st_toggle">
        .switch {
            position: relative;
            display: inline-block;
            width: 52px;
            height: 28px;
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
            background-color: #dee2e6;
            transition: .3s;
        }

            .slider:before {
                position: absolute;
                content: "";
                height: 22px;
                width: 22px;
                left: 3px;
                bottom: 3px;
                background: white;
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
            cursor: pointer;
            margin-bottom: 2px;
        }

        .agreement-subtitle {
            font-size: 13px;
            color: #6c757d;
        }

        .gap-3 {
            gap: 12px;
        }
    </style>

    <style>
        .empdoc-header {
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            border-radius: 15px;
            padding: 12px;
            color: white;
            position: relative;
            overflow: hidden;
            margin-bottom: 25px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        }

            .empdoc-header h4 {
                margin: 0;
                font-size: 18px;
                font-weight: 700;
            }

            .empdoc-header p {
                margin: 3px 0 0;
                font-size: 12px;
                opacity: .9;
            }
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

    <script src="https://jsuites.net/v5/jsuites.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="../Scripts/Functions/CreateprofileNew.js"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="fdaccountattachment" style="display: none;" />

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

    <div class="empdoc-header">
        <div class="d-flex justify-content-between align-items-start mb-1">
            <div>
                <div class="dashboard-title">
                    <i class="fas fa-user-edit mr-2"></i>
                    Create/View/Update Employee Profile
                </div>
                <div class="dashboard-subtitle">
                    Create new employee records, update existing information, and maintain employee profiles.
                </div>
            </div>
            <div>
                <a href="#" id="aBack" runat="server" class="btn btn-light btn-back" onclick="window.history.go(-1); return false;">
                    <i class="fas fa-arrow-left"></i>
                    Back
                </a>
            </div>
        </div>
    </div>

    <div class="col-lg-12">
        <div id="crp_personal" class="modern-card">
            <div class="modern-card-header">
                <i class="fas fa-edit"></i>&nbsp;&nbsp;Personal Information
            </div>

            <div class="modern-card-body">
                <div class="form-grid">
                    <div class="form-group span-4">
                        <label><span class="required">★</span> Requisition</label>
                        <select id="requisition" name="requisition" class="form-control">
                            <option value="">Select</option>
                        </select>
                    </div>

                    <div class="form-group span-2">
                        <label><span class="required">★</span> Name</label>
                        <div class="name-row">
                            <select id="title" name="title" class="form-control">
                                <option value="">Select</option>
                                <option value="Mr.">Mr.</option>
                                <option value="Ms.">Ms.</option>
                                <option value="Mrs.">Mrs.</option>
                            </select>
                            <input type="text" id="firstname" name="firstname" placeholder="First Name" class="form-control" style="text-transform: uppercase;" />
                            <input type="text" id="middlename" name="middlename" placeholder="Middle Name" class="form-control" style="text-transform: uppercase;" />
                            <input type="text" id="lastname" name="lastname" placeholder="Last Name" class="form-control" style="text-transform: uppercase;" />
                        </div>
                    </div>

                    <div class="form-group">
                        <label><span class="required">★</span> Employee Type</label>
                        <select id="employeetype" name="employeetype" class="form-control" onchange="GenerateEmpCode();">
                            <option value="">Select</option>
                            <option value="Consultant">Consultant</option>
                            <option value="Employee">Employee</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label><span class="required">★</span> Code</label>
                        <input type="text" id="code" name="code" class="form-control"
                            style="font-weight: bold; text-transform: uppercase;" />
                    </div>

                    <div class="form-group">
                        <label><span class="required">★</span> Gender</label>
                        <select id="gender" name="gender" class="form-control">
                            <option value="">Select</option>
                            <option value="Female">Female</option>
                            <option value="Male">Male</option>
                        </select>
                    </div>


                    <div class="form-group">
                        <label><span class="required">★</span> Birth Date</label>
                        <input type="date" id="birthdate" name="birthdate" class="form-control" />
                    </div>

                    <div class="form-group">
                        <label><span class="required">★</span> Mobile #</label>
                        <input type="text" id="cellno" name="cellno" class="form-control" />
                    </div>

                    <div class="form-group">
                        <label>Res. Tel #</label>
                        <input type="text" id="restelno" name="restelno" class="form-control" />
                    </div>
                    <div class="form-group">
                        <label><span class="required">★</span> Blood Group</label>
                        <select id="bloodgroup" name="bloodgroup" class="form-control">
                            <option value="">Select</option>
                            <option value="A+">A+</option>
                            <option value="A-">A-</option>
                            <option value="B+">B+</option>
                            <option value="B-">B-</option>
                            <option value="AB+">AB+</option>
                            <option value="AB-">AB-</option>
                            <option value="O+">O+</option>
                            <option value="O-">O</option>
                            <option value="NA">NA</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label><span class="required">★</span> Email ID</label>
                        <input type="email" id="email" name="email" class="form-control" />
                    </div>
                    <div class="form-group">
                        <label><span class="required">★</span> Qualification</label>
                        <input type="text" id="qualification" name="qualification" class="form-control" />
                    </div>
                    <div class="form-group">
                        <label><span class="required">★</span> PAN</label>
                        <input type="text" id="pan" name="pan" class="form-control" style="text-transform: uppercase;" oninput="this.value = this.value.toUpperCase().replace(/[^A-Z0-9]/g, '');" />
                    </div>
                    <div class="form-group span-4">
                        <div class="d-flex align-items-center gap-3">

                            <label class="switch mb-0">
                                <input type="checkbox" id="chkaddress" name="chkaddress" onchange="getaddress(this);">
                                <span class="slider round"></span>
                            </label>

                            <div class="agreement-content">
                                <label for="chkaddress" class="agreement-title mb-0">
                                    Address
                                </label>
                                <div class="agreement-subtitle">
                                    Enable if both the permanent and present addresses are the same.
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="form-group span-2">
                        <label><span class="required">★</span> Present Address</label>
                        <textarea id="presentaddress" name="presentaddress" class="form-control"></textarea>
                    </div>

                    <div class="form-group span-2">
                        <label><span class="required">★</span> Permanent Address</label>
                        <textarea id="permanentaddress" name="permanentaddress" class="form-control"></textarea>
                    </div>

                </div>
            </div>
        </div>

        <div id="crp_official" class="modern-card">
            <div class="modern-card-header">
                <i class="fas fa-briefcase"></i>&nbsp;
                Official Information
            </div>

            <div class="modern-card-body">
                <div class="form-grid">

                    <!-- Row 1 -->
                    <div class="form-group">
                        <label><span class="required">★</span> Joining Date</label>
                        <input type="date" id="joiningdate" name="joiningdate" class="form-control" onchange="validateAppointmentDate();">
                    </div>

                    <div class="form-group">
                        <label><span class="required">★</span> Salary</label>
                        <input type="number" id="salary" name="salary" class="form-control" onchange="showSalaryInWords();" oninput="this.value = this.value.replace(/\D/g, '');">
                    </div>

                    <div class="form-group">
                        <label><span class="required">★</span> Working Branch</label>
                        <select id="branch" name="branch" class="form-control">
                            <option value="">Select</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label><span class="required">★</span> Department</label>
                        <select id="department" name="department" class="form-control">
                            <option value="">Select</option>
                        </select>
                    </div>

                    <!-- Row 2 -->

                    <div class="form-group">
                        <label><span class="required">★</span> Designation</label>
                        <select id="designation" name="designation" class="form-control">
                            <option value="">Select</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label><span class="required">★</span> Reporting Manager</label>
                        <select id="reportingmanager" name="reportingmanager" class="form-control">
                            <option value="">Select</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label><span class="required">★</span> Shift</label>
                        <select id="shift" name="shift" class="form-control" onchange="getcutoff(this);">
                            <option value="">Select</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label><span class="required">★</span> Cut Off Time</label>
                        <input type="text" id="cutofftime" name="cutofftime" class="form-control">
                    </div>

                    <!-- Row 3 -->

                    <div class="form-group">
                        <label><span class="required">★</span> Working Hours</label>
                        <select id="workinghours" name="workinghours" class="form-control">
                            <option value="">Select</option>
                            <option value="2">08</option>
                            <option value="3">10</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label><span class="required">★</span> Weekly Holiday</label>
                        <select id="weeklyholiday" name="weeklyholiday" class="form-control">
                            <option value="">Select</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label><span class="required">★</span> Project</label>
                        <select id="projects" name="projects" class="form-control">
                            <option value="">Select</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Process</label>
                        <input type="text" id="process" name="process" class="form-control">
                    </div>

                    <!-- Row 4 -->

                    <div class="form-group">
                        <label><span class="required">★</span> Task/Productive</label>
                        <select id="taskproductive" name="taskproductive" class="form-control">
                            <option value="">Select</option>
                            <option value="Task">Task</option>
                            <option value="Productivity">Productivity</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label><span class="required">★</span> Domain</label>
                        <select id="domain" name="domain" class="form-control">
                            <option value="">Select</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label><span class="required">★</span> Subdomain</label>
                        <select id="subdomain" name="subdomain" class="form-control">
                            <option value="">Select</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label><span class="required">★</span> Appointment Date</label>
                        <input type="date" id="appointmentdate" name="appointmentdate" class="form-control" onchange="validateAppointmentDate();">
                    </div>

                    <!-- Identity Details -->

                    <div class="form-group">
                        <label>Aadhar #</label>
                        <input type="text" id="aadharno" name="aadharno" class="form-control" oninput="this.value = this.value.replace(/\D/g, '');">
                    </div>

                    <div class="form-group">
                        <label>UAN</label>
                        <input type="text" id="uan" name="uan" class="form-control" oninput="this.value = this.value.replace(/\D/g, '');">
                    </div>

                    <div class="form-group">
                        <label>ESIC #</label>
                        <input type="text" id="esicno" name="esicno" class="form-control" style="text-transform: uppercase;" oninput="this.value = this.value.replace(/\D/g, '');">
                    </div>

                    <div class="form-group">
                        <label>PF #</label>
                        <input type="text" id="pfno" name="pfno" class="form-control" style="text-transform: uppercase;">
                    </div>

                    <!-- Row -->

                    <div class="form-group">
                        <label>Official Email</label>
                        <input type="email" id="officialemail" name="officialemail" class="form-control">
                    </div>

                    <div class="form-group">
                        <label>Job Type</label>
                        <select id="jobtype" name="jobtype" class="form-control">
                            <option value="">Select</option>
                            <option value="Work From Home">Work From Home</option>
                            <option value="Work From Office">Work From Office</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Policy Applicable</label>
                        <select id="policy" name="policy" class="form-control">
                            <option value="">Select</option>
                            <option value="Yes">Yes</option>
                            <option value="No">No</option>
                        </select>
                    </div>

                    <!-- Remark -->

                    <div class="form-group">
                        <label>Remark</label>
                        <textarea id="remark" name="remark" class="form-control" placeholder="Training For 'Process Name' ('Training Start Date' to 'Training End Date')"></textarea>
                    </div>
                </div>
                <div class="form-group span-2">
                    <div class="d-flex align-items-center gap-3">
                        <label class="switch mb-0">
                            <input type="checkbox" id="chkagreement" name="chkagreement" onchange="getagreementdetails();"><span class="slider round"></span>
                        </label>

                        <div class="agreement-content">
                            <label for="chkagreement" class="agreement-title">Agreement Applicable</label>
                            <div class="agreement-subtitle">Enable this option if an Employee Agreement is applicable</div>
                        </div>
                    </div>
                </div>

                <div id="tragreement" class="agreement-section d-none">
                    <div class="form-grid">
                        <div class="form-group">
                            <label>Agreement Period</label>
                            <select id="agreementperiod" name="agreementperiod" class="form-control" onchange="setAgreementExpiryDate();">
                                <option value="">Select</option>
                                <option value="1">1 Year</option>
                                <option value="2">2 Years</option>
                                <option value="3">3 Years</option>
                                <option value="4">4 Years</option>
                                <option value="5">5 Years</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Agreement Date</label>
                            <input type="date" id="agreementdate" name="agreementdate" class="form-control" onchange="setAgreementExpiryDate();" />
                        </div>

                        <div class="form-group">
                            <label>Expiry Date</label>
                            <input type="date" id="agreementexpirydate" name="agreementexpirydate" class="form-control" readonly style="background-color: white;" />
                        </div>

                        <!-- Optional empty column to keep 4-column alignment -->
                        <div class="form-group"></div>

                    </div>
                </div>
            </div>
        </div>

        <div id="crp_bank" class="modern-card mt-4">

            <div class="modern-card-header">
                <i class="fas fa-university"></i>&nbsp;Bank Details
            </div>

            <div class="modern-card-body">

                <div class="form-grid">

                    <div class="form-group">
                        <label>Bank Name</label>
                        <select id="bankname" name="bankname" class="form-control">
                            <option value="">Select</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Account Number</label>
                        <input type="text" id="accountno" name="accountno" class="form-control">
                    </div>

                    <div class="form-group">
                        <label>Re-enter Account Number</label>
                        <input type="text" id="reaccountno" name="reaccountno" class="form-control">
                    </div>

                    <div class="form-group">
                        <label>IFSC Code</label>
                        <input type="text" id="ifsccode" name="ifsccode" class="form-control">
                    </div>

                    <div class="form-group">
                        <label>Re-enter IFSC Code</label>
                        <input type="text" id="reifsccode" name="reifsccode" class="form-control">
                    </div>

                    <div class="form-group">
                        <label>Bank Proof</label>
                        <input type="file"
                            id="accountattachment"
                            name="accountattachment"
                            class="form-control">
                    </div>
                </div>
            </div>
        </div>

        <div class="card-footer-modern">
            <button type="button" id="btnSubmit" onclick="return create_submitdata();" class="btn-submit"><i class="fa fa-save"></i>Submit</button>
        </div>
    </div>

</asp:Content>
