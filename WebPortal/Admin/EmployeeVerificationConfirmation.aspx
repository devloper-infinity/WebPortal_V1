<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EmployeeVerificationConfirmation.aspx.cs" Inherits="WebPortal.Admin.EmployeeVerificationConfirmation" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .loading {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: rgba(255,255,255,.95);
            border-radius: 18px;
            width: 190px;
            min-height: 150px;
            z-index: 99999;
            box-shadow: 0 18px 45px rgba(15, 23, 42, .18);
            text-align: center;
            padding: 22px 15px;
        }

        .ev-page {
            background: #f4f7fb;
        }

        .ev-hero {
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 62%, #22c1dc 100%);
            border-radius: 18px;
            padding: 22px 24px;
            color: #fff;
            box-shadow: 0 18px 40px rgba(37, 99, 235, .25);
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
        }

        .ev-hero-left {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .ev-hero-icon {
            width: 56px;
            height: 56px;
            border-radius: 16px;
            background: rgba(255,255,255,.18);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            box-shadow: inset 0 0 0 1px rgba(255,255,255,.22);
        }

        .ev-hero h4 {
            margin: 0;
            font-size: 21px;
            font-weight: 800;
            letter-spacing: .2px;
        }

        .ev-hero p {
            margin: 4px 0 0;
            color: rgba(255,255,255,.88);
            font-size: 13px;
            font-weight: 500;
        }

        .ev-back {
            color: #fff !important;
            background: rgba(255,255,255,.16);
            border: 1px solid rgba(255,255,255,.28);
            border-radius: 999px;
            padding: 9px 14px;
            font-size: 12px;
            font-weight: 700;
            text-decoration: none !important;
            white-space: nowrap;
            transition: .25s ease;
        }

        .ev-back:hover {
            background: #fff;
            color: #1d4ed8 !important;
        }

        .ev-card {
            background: #fff;
            border: 1px solid #e7edf6;
            border-radius: 18px;
            box-shadow: 0 12px 32px rgba(15,23,42,.08);
            overflow: hidden;
        }

        .ev-card-header {
            padding: 18px 22px;
            border-bottom: 1px solid #edf2f7;
            background: linear-gradient(180deg, #ffffff 0%, #f8fbff 100%);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            flex-wrap: wrap;
        }

        .ev-candidate {
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 900;
            font-size:16px;
            color: #0f172a;
        }

        .ev-candidate i {
            width: 38px;
            height: 38px;
            border-radius: 12px;
            background: #eff6ff;
            color: #2563eb;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .ev-chip {
            background: #ecfeff;
            color: #0891b2;
            border: 1px solid #cffafe;
            border-radius: 999px;
            padding: 7px 12px;
            font-size: 12px;
            font-weight: 800;
        }

        .ev-form {
            padding: 20px 22px 24px;
        }

        .ev-section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #0f172a;
            font-size: 15px;
            font-weight: 800;
            margin: 4px 0 14px;
        }

        .ev-section-title:before {
            content: "";
            width: 5px;
            height: 22px;
            border-radius: 12px;
            background: linear-gradient(180deg, #2563eb, #22c1dc);
        }

        .ev-field-row {
            display: grid;
            grid-template-columns: minmax(180px, .9fr) minmax(230px, 1.15fr) minmax(230px, 1.15fr);
            gap: 14px;
            align-items: end;
            padding: 14px;
            border: 1px solid #edf2f7;
            border-radius: 15px;
            margin-bottom: 12px;
            background: #fbfdff;
            transition: .22s ease;
        }

        .ev-field-row:hover {
            border-color: #bfdbfe;
            box-shadow: 0 8px 24px rgba(37,99,235,.08);
            transform: translateY(-1px);
        }

        .ev-label-main {
            font-weight: 800;
            color: #334155;
            font-size: 12px;
            line-height: 1.35;
            padding-bottom: 10px;
        }

        .ev-input-group label {
            display: block;
            margin-bottom: 6px;
            font-size: 11px;
            font-weight: 800;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: .35px;
        }

        .ev-input-group .form-control,
        .ev-input-group input,
        .ev-input-group textarea {
            width: 100% !important;
            min-height: 38px;
            border-radius: 10px;
            border: 1px solid #d8e1ee;
            background: #fff;
            font-size: 12px;
            font-weight: 600;
            color: #0f172a;
            box-shadow: none;
            transition: .2s ease;
        }

        .ev-input-group textarea {
            min-height: 68px;
            resize: vertical;
        }

        .ev-input-group .form-control:focus,
        .ev-input-group input:focus,
        .ev-input-group textarea:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37,99,235,.12);
        }

        .ev-upload-row {
            display: grid;
            grid-template-columns: minmax(180px, .9fr) minmax(230px, 1.15fr) minmax(230px, 1.15fr);
            gap: 14px;
            align-items: stretch;
            padding: 14px;
            border: 1px solid #edf2f7;
            border-radius: 15px;
            margin-bottom: 12px;
            background: #fbfdff;
        }

        .ev-file-box {
            border: 2px dashed #bfdbfe;
            border-radius: 15px;
            background: linear-gradient(180deg, #f8fbff 0%, #eff6ff 100%);
            padding: 18px;
            min-height: 112px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .ev-file-box input[type=file] {
            width: 100% !important;
            max-width: 280px;
            font-size: 12px;
            margin-top: 10px;
        }

        .ev-file-icon {
            width: 46px;
            height: 46px;
            border-radius: 14px;
            background: linear-gradient(135deg, #2563eb, #22c1dc);
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 19px;
            margin-bottom: 8px;
            animation: evFloat 2.4s ease-in-out infinite;
        }

        @keyframes evFloat {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-6px); }
        }

        .ev-file-title {
            font-size: 13px;
            font-weight: 800;
            color: #0f172a;
        }

        .ev-file-subtitle {
            font-size: 11px;
            color: #64748b;
            margin-top: 2px;
        }

        .dropzone_conf {
            width: 100%;
            min-height: 112px;
            border: 1px solid #d8e1ee;
            border-radius: 15px;
            background: #fff;
            padding: 18px !important;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #475569;
            font-weight: 700;
            font-size: 12px;
        }

        .dropzone_conf:before {
            content: "Selected attachment will appear here";
            color: #94a3b8;
            font-weight: 700;
        }

        .dropzone_conf.dz-max-files-reached:before {
            content: "";
        }

        #filesdiv_conf {
            padding: 9px 12px;
            background: #ecfdf5;
            color: #047857;
            border: 1px solid #bbf7d0;
            border-radius: 999px;
            font-weight: 800;
            word-break: break-word;
        }

        .ev-actions {
            display: flex;
            justify-content: center;
            padding-top: 16px;
        }

        #ExEmpConf_btnSubmit {
            border: 0;
            border-radius: 999px;
            background: linear-gradient(135deg, #2563eb, #22c1dc);
            color: #fff;
            min-width: 150px;
            padding: 11px 26px;
            font-size: 13px;
            font-weight: 800;
            box-shadow: 0 12px 25px rgba(37,99,235,.25);
            transition: .25s ease;
        }

        #ExEmpConf_btnSubmit:hover {
            transform: translateY(-2px);
            box-shadow: 0 16px 32px rgba(37,99,235,.32);
        }

        @media (max-width: 991px) {
            .ev-field-row,
            .ev-upload-row {
                grid-template-columns: 1fr;
                gap: 10px;
            }

            .ev-label-main {
                padding-bottom: 0;
            }
        }

        @media (max-width: 576px) {
            .ev-page { padding: 10px; }
            .ev-hero { padding: 18px; align-items: flex-start; flex-direction: column; }
            .ev-hero h4 { font-size: 18px; }
            .ev-card-header, .ev-form { padding-left: 14px; padding-right: 14px; }
        }
    </style>
    <script>
        window.onload = function () {
            document.getElementById('ExEmpConf_attachment').addEventListener('change', getFileName);
        }
        const getFileName = (event) => {
            const files = event.target.files;
            var file = files[0];
            document.getElementById("filep_conf").value = files[0].name;

            const fd = new FormData();

            // add all selected files
            fd.append(event.target.name, file, file.name);
            // create the request
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
            document.getElementById("dropzone_conf").classList.add("dz-max-files-reached");
            document.getElementById("conentdiv_conf").style.display = '';
            document.getElementById("filesdiv_conf").innerHTML = file.name;
        }

        $(document).ready(function () {
            BindFormInformation_Conf();
        });

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="filep_conf" style="display: none;" />

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold; margin-top:8px;">One moment, please . . . .</div>
    </div>

    <div class="ev-page">
        <div class="ev-hero">
            <div class="ev-hero-left">
                <div class="ev-hero-icon">
                    <i class="fas fa-user-check"></i>
                </div>
                <div>
                    <h4>Ex Employer Verification Form</h4>
                    <p>Verify previous employment details with provided and confirmed information side by side.</p>
                </div>
            </div>
            <a href="#utl" id="aBack" runat="server" class="ev-back" onclick="window.history.go(-1); return false;">
                <i class="fas fa-arrow-left"></i> Go Back
            </a>
        </div>

        <div class="ev-card">
            <div class="ev-card-header">
                <div class="ev-candidate">
                    <i class="fas fa-id-card-alt"></i>
                    <label id="ExEmpConf_name" name="ExEmpConf_name"></label>
                </div>
                <span class="ev-chip"><i class="fas fa-shield-alt"></i> Verification Confirmation</span>
            </div>

            <div class="ev-form">
                <div class="ev-section-title">Employment Verification Details</div>
                        <div class="ev-field-row">
                            <div class="ev-label-main">Name of Organisation</div>
                            <div class="ev-input-group">
                                <label>Information Provided</label>
                                <input type="text" id="ExEmpConf_organizationname" name="ExEmpConf_organizationname" class="form-control" />
                            </div>
                            <div class="ev-input-group">
                                <label>Information Verified</label>
                                <input type="text" id="ExEmpConf_organizationnameVer" name="ExEmpConf_organizationnameVer" class="form-control" />
                            </div>
                        </div>
                        <div class="ev-field-row">
                            <div class="ev-label-main">Candidate Name</div>
                            <div class="ev-input-group">
                                <label>Information Provided</label>
                                <input type="text" id="ExEmpConf_candidatename" name="ExEmpConf_candidatename" class="form-control" />
                            </div>
                            <div class="ev-input-group">
                                <label>Information Verified</label>
                                <input type="text" id="ExEmpConf_candidatenameVer" name="ExEmpConf_candidatenameVer" class="form-control" />
                            </div>
                        </div>
                        <div class="ev-field-row">
                            <div class="ev-label-main">Employee ID / Code</div>
                            <div class="ev-input-group">
                                <label>Information Provided</label>
                                <input type="text" id="ExEmpConf_employeeid" name="ExEmpConf_employeeid" class="form-control" />
                            </div>
                            <div class="ev-input-group">
                                <label>Information Verified</label>
                                <input type="text" id="ExEmpConf_employeeidVer" name="ExEmpConf_employeeidVer" class="form-control" />
                            </div>
                        </div>
                        <div class="ev-field-row">
                            <div class="ev-label-main">Designation</div>
                            <div class="ev-input-group">
                                <label>Information Provided</label>
                                <input type="text" id="ExEmpConf_designation" name="ExEmpConf_designation" class="form-control" />
                            </div>
                            <div class="ev-input-group">
                                <label>Information Verified</label>
                                <input type="text" id="ExEmpConf_designationVer" name="ExEmpConf_designationVer" class="form-control" />
                            </div>
                        </div>
                        <div class="ev-field-row">
                            <div class="ev-label-main">Period of Employment</div>
                            <div class="ev-input-group">
                                <label>Information Provided</label>
                                <input type="text" id="ExEmpConf_employmentperiod" name="ExEmpConf_employmentperiod" class="form-control" />
                            </div>
                            <div class="ev-input-group">
                                <label>Information Verified</label>
                                <input type="text" id="ExEmpConf_employmentperiodVer" name="ExEmpConf_employmentperiodVer" class="form-control" />
                            </div>
                        </div>
                        <div class="ev-field-row">
                            <div class="ev-label-main">Salary</div>
                            <div class="ev-input-group">
                                <label>Information Provided</label>
                                <input type="text" id="ExEmpConf_salary" name="ExEmpConf_salary" class="form-control" />
                            </div>
                            <div class="ev-input-group">
                                <label>Information Verified</label>
                                <input type="text" id="ExEmpConf_salaryVer" name="ExEmpConf_salaryVer" class="form-control" />
                            </div>
                        </div>
                        <div class="ev-field-row">
                            <div class="ev-label-main">Reporting Manager - Name</div>
                            <div class="ev-input-group">
                                <label>Information Provided</label>
                                <input type="text" id="ExEmpConf_reportingmanager" name="ExEmpConf_reportingmanager" class="form-control" />
                            </div>
                            <div class="ev-input-group">
                                <label>Information Verified</label>
                                <input type="text" id="ExEmpConf_reportingmanagerVer" name="ExEmpConf_reportingmanagerVer" class="form-control" />
                            </div>
                        </div>
                        <div class="ev-field-row">
                            <div class="ev-label-main">Reporting Manager - Designation</div>
                            <div class="ev-input-group">
                                <label>Information Provided</label>
                                <input type="text" id="ExEmpConf_reportingdesignation" name="ExEmpConf_reportingdesignation" class="form-control" />
                            </div>
                            <div class="ev-input-group">
                                <label>Information Verified</label>
                                <input type="text" id="ExEmpConf_reportingdesignationVer" name="ExEmpConf_reportingdesignationVer" class="form-control" />
                            </div>
                        </div>
                        <div class="ev-field-row">
                            <div class="ev-label-main">Reporting Manager Contact No. & E-Mail</div>
                            <div class="ev-input-group">
                                <label>Information Provided</label>
                                <textarea id="ExEmpConf_reportingmanageremail" name="ExEmpConf_reportingmanageremail" class="form-control"></textarea>
                            </div>
                            <div class="ev-input-group">
                                <label>Information Verified</label>
                                <textarea id="ExEmpConf_reportingmanageremailVer" name="ExEmpConf_reportingmanageremailVer" class="form-control"></textarea>
                            </div>
                        </div>
                        <div class="ev-field-row">
                            <div class="ev-label-main">HR Name</div>
                            <div class="ev-input-group">
                                <label>Information Provided</label>
                                <input type="text" id="ExEmpConf_hrname" name="ExEmpConf_hrname" class="form-control" />
                            </div>
                            <div class="ev-input-group">
                                <label>Information Verified</label>
                                <input type="text" id="ExEmpConf_hrnameVer" name="ExEmpConf_hrnameVer" class="form-control" />
                            </div>
                        </div>
                        <div class="ev-field-row">
                            <div class="ev-label-main">HR Contact No. & E-Mail</div>
                            <div class="ev-input-group">
                                <label>Information Provided</label>
                                <input type="text" id="ExEmpConf_hremail" name="ExEmpConf_hremail" class="form-control" />
                            </div>
                            <div class="ev-input-group">
                                <label>Information Verified</label>
                                <input type="text" id="ExEmpConf_hremailVer" name="ExEmpConf_hremailVer" class="form-control" />
                            </div>
                        </div>
                        <div class="ev-field-row">
                            <div class="ev-label-main">Reason for Leaving the Organization</div>
                            <div class="ev-input-group">
                                <label>Information Provided</label>
                                <textarea id="ExEmpConf_reasonforleaving" name="ExEmpConf_reasonforleaving" class="form-control"></textarea>
                            </div>
                            <div class="ev-input-group">
                                <label>Information Verified</label>
                                <textarea id="ExEmpConf_reasonforleavingVer" name="ExEmpConf_reasonforleavingVer" class="form-control"></textarea>
                            </div>
                        </div>
                        <div class="ev-field-row">
                            <div class="ev-label-main">Any Exit Formalities Pending (YES / NO)</div>
                            <div class="ev-input-group">
                                <label>Information Provided</label>
                                <input type="text" id="ExEmpConf_exitformality" name="ExEmpConf_exitformality" class="form-control" />
                            </div>
                            <div class="ev-input-group">
                                <label>Information Verified</label>
                                <input type="text" id="ExEmpConf_exitformalityVer" name="ExEmpConf_exitformalityVer" class="form-control" />
                            </div>
                        </div>
                        <div class="ev-field-row">
                            <div class="ev-label-main">Eligible for rehire (Based on job performance). If No, please specify reason</div>
                            <div class="ev-input-group">
                                <label>Information Provided</label>
                                <textarea id="ExEmpConf_eligibility" name="ExEmpConf_eligibility" class="form-control"></textarea>
                            </div>
                            <div class="ev-input-group">
                                <label>Information Verified</label>
                                <textarea id="ExEmpConf_eligibilityVer" name="ExEmpConf_eligibilityVer" class="form-control"></textarea>
                            </div>
                        </div>
                        <div class="ev-field-row">
                            <div class="ev-label-main">Verified by (Name & Designation)</div>
                            <div class="ev-input-group">
                                <label>Information Provided</label>
                                <input type="text" id="ExEmpConf_verifiedby" name="ExEmpConf_verifiedby" class="form-control" />
                            </div>
                            <div class="ev-input-group">
                                <label>Information Verified</label>
                                <input type="text" id="ExEmpConf_verifiedbyVer" name="ExEmpConf_verifiedbyVer" class="form-control" />
                            </div>
                        </div>

                <div class="ev-upload-row">
                    <div class="ev-label-main">Attachment</div>
                    <div class="ev-input-group">
                        <label>Upload Document</label>
                        <div class="ev-file-box">
                            <div class="ev-file-icon"><i class="fas fa-cloud-upload-alt"></i></div>
                            <div class="ev-file-title">Choose verification attachment</div>
                            <div class="ev-file-subtitle">Uploaded file name will appear on the right side</div>
                            <input type="file" id="ExEmpConf_attachment" name="ExEmpConf_attachment" class="form-control" />
                        </div>
                    </div>
                    <div class="ev-input-group">
                        <label>Selected File</label>
                        <div class="dropzone_conf dropzone_conf-multiple p-0 dz-clickable dz-file-processing dz-file-complete" id="dropzone_conf">
                            <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column" id="conentdiv_conf" style="display: none!important;">
                                <div class="flex-1 d-flex flex-between-center">
                                    <div id="filesdiv_conf"></div>
                                    <div class="dropdown font-sans-serif">
                                        <button class="btn btn-link text-600 btn-sm dropdown-toggle btn-reveal dropdown-caret-none" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                            <svg class="svg-inline--fa fa-ellipsis" style="display: none!important" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="ellipsis" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg="">
                                                <path fill="currentColor" d="M120 256C120 286.9 94.93 312 64 312C33.07 312 8 286.9 8 256C8 225.1 33.07 200 64 200C94.93 200 120 225.1 120 256zM280 256C280 286.9 254.9 312 224 312C193.1 312 168 286.9 168 256C168 225.1 193.1 200 224 200C254.9 200 280 225.1 280 256zM328 256C328 225.1 353.1 200 384 200C414.9 200 440 225.1 440 256C440 286.9 414.9 312 384 312C353.1 312 328 286.9 328 256z"></path>
                                            </svg>
                                        </button>
                                        <div class="dropdown-menu dropdown-menu-end border py-2"><a class="dropdown-item" href="#!" data-dz-remove="data-dz-remove">Remove File</a></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="ev-actions">
                    <button id="ExEmpConf_btnSubmit" class="btn btn-primary" onclick="return ExEmpConf_SubmitData();">
                        <i class="fas fa-paper-plane"></i> Submit
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="formCof_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="formCof_errmsg"></h6>
                </div>
                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="btnMessageConf" onclick="return ExFormConf_Message();">Okay</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>


<%--<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
    </style>
    <script>
        window.onload = function () {
            document.getElementById('ExEmpConf_attachment').addEventListener('change', getFileName);
        }
        const getFileName = (event) => {
            const files = event.target.files;
            var file = files[0];
            document.getElementById("filep_conf").value = files[0].name;

            const fd = new FormData();

            // add all selected files
            fd.append(event.target.name, file, file.name);
            // create the request
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
            document.getElementById("dropzone_conf").classList.add("dz-max-files-reached");
            document.getElementById("conentdiv_conf").style.display = '';
            document.getElementById("filesdiv_conf").innerHTML = file.name;
        }

        $(document).ready(function () {
            BindFormInformation_Conf();
        });

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="filep_conf" style="display: none;" />
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Ex Employer Verification Form</b></h6>
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
                            <label id="ExEmpConf_name" name="ExEmpConf_name" style="width: 350px"></label>
                        </div>
                    </div>
                    <table class="table">
                        <tr style="background: linear-gradient(to right, #ffbf96, #fe7096);">
                            <th>Particulars</th>
                            <th>Information Provided</th>
                            <th>Information Verified</th>
                        </tr>

                        <tr>
                            <td><b>Name of Organiation:</b></td>
                            <td>
                                <input type="text" id="ExEmpConf_organizationname" name="ExEmpConf_organizationname" class="form-control" style="width: 350px;" />
                            </td>
                            <td>
                                <input type="text" id="ExEmpConf_organizationnameVer" name="ExEmpConf_organizationnameVer" class="form-control" style="width: 350px;" />
                            </td>
                        </tr>
                        <tr>
                            <td><b>Candidate Name:</b></td>
                            <td>
                                <input type="text" id="ExEmpConf_candidatename" name="ExEmpConf_candidatename" class="form-control" style="width: 350px;" />
                            </td>
                            <td>
                                <input type="text" id="ExEmpConf_candidatenameVer" name="ExEmpConf_candidatenameVer" class="form-control" style="width: 350px;" />
                            </td>
                        </tr>
                        <tr>
                            <td><b>Employee ID/Code:</b></td>
                            <td>
                                <input type="text" id="ExEmpConf_employeeid" name="ExEmpConf_employeeid" class="form-control" style="width: 350px;" />
                            </td>
                            <td>
                                <input type="text" id="ExEmpConf_employeeidVer" name="ExEmpConf_employeeidVer" class="form-control" style="width: 350px;" />
                            </td>
                        </tr>
                        <tr>
                            <td><b>Designation:</b></td>
                            <td>
                                <input type="text" id="ExEmpConf_designation" name="ExEmpConf_designation" class="form-control" style="width: 350px;" />
                            </td>
                            <td>
                                <input type="text" id="ExEmpConf_designationVer" name="ExEmpConf_designationVer" class="form-control" style="width: 350px;" />
                            </td>
                        </tr>
                        <tr>
                            <td><b>Period of Employment:</b></td>
                            <td>
                                <input type="text" id="ExEmpConf_employmentperiod" name="ExEmpConf_employmentperiod" class="form-control" style="width: 350px;" />
                            </td>
                            <td>
                                <input type="text" id="ExEmpConf_employmentperiodVer" name="ExEmpConf_employmentperiodVer" class="form-control" style="width: 350px;" />
                            </td>
                        </tr>
                        <tr>
                            <td><b>Salary:</b></td>
                            <td>
                                <input type="text" id="ExEmpConf_salary" name="ExEmpConf_salary" class="form-control" style="width: 350px;" />
                            </td>
                            <td>
                                <input type="text" id="ExEmpConf_salaryVer" name="ExEmpConf_salaryVer" class="form-control" style="width: 350px;" />
                            </td>
                        </tr>

                        <tr>
                            <td><b>Name:</b></td>
                            <td>
                                <input type="text" id="ExEmpConf_reportingmanager" name="ExEmpConf_reportingmanager" class="form-control" style="width: 350px;" />
                            </td>
                            <td>
                                <input type="text" id="ExEmpConf_reportingmanagerVer" name="ExEmpConf_reportingmanagerVer" class="form-control" style="width: 350px;" />
                            </td>
                        </tr>

                        <tr>
                            <td><b>Designation:</b></td>
                            <td>
                                <input type="text" id="ExEmpConf_reportingdesignation" name="ExEmpConf_reportingdesignation" class="form-control" style="width: 350px;" />
                            </td>
                            <td>
                                <input type="text" id="ExEmpConf_reportingdesignationVer" name="ExEmpConf_reportingdesignationVer" class="form-control" style="width: 350px;" />
                            </td>
                        </tr>
                        <tr>
                            <td><b>Contact No. & E-Mail:</b></td>
                            <td>
                                <textarea type="text" id="ExEmpConf_reportingmanageremail" name="ExEmpConf_reportingmanageremail" class="form-control" style="width: 350px;"></textarea>
                            </td>
                            <td>
                                <textarea type="text" id="ExEmpConf_reportingmanageremailVer" name="ExEmpConf_reportingmanageremailVer" class="form-control" style="width: 350px;"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td><b>HR Name:</b></td>
                            <td>
                                <input type="text" id="ExEmpConf_hrname" name="ExEmpConf_hrname" class="form-control" style="width: 350px;" />
                            </td>
                            <td>
                                <input type="text" id="ExEmpConf_hrnameVer" name="ExEmpConf_hrnameVer" class="form-control" style="width: 350px;" />
                            </td>
                        </tr>
                        <tr>
                            <td><b>Contact No. & E-Mail:</b></td>
                            <td>
                                <input type="text" id="ExEmpConf_hremail" name="ExEmpConf_hremail" class="form-control" style="width: 350px;" />
                            </td>
                            <td>
                                <input type="text" id="ExEmpConf_hremailVer" name="ExEmpConf_hremailVer" class="form-control" style="width: 350px;" />
                            </td>
                        </tr>
                        <tr>
                            <td><b>Reason for Leaving the Organization:</b></td>
                            <td>
                                <textarea type="text" id="ExEmpConf_reasonforleaving" name="ExEmpConf_reasonforleaving" class="form-control" style="width: 350px;"></textarea>
                            </td>
                            <td>
                                <textarea type="text" id="ExEmpConf_reasonforleavingVer" name="ExEmpConf_reasonforleavingVer" class="form-control" style="width: 350px;"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Any Exit Formalities Pending:(YES/NO):</b></td>
                            <td>
                                <input type="text" id="ExEmpConf_exitformality" name="ExEmpConf_exitformality" class="form-control" style="width: 350px;" />
                            </td>
                            <td>
                                <input type="text" id="ExEmpConf_exitformalityVer" name="ExEmpConf_exitformalityVer" class="form-control" style="width: 350px;" />
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 250px;"><b>Eligible for rehire (Based on job performance) (If No, please Specify Reason):</b></td>
                            <td>
                                <textarea type="text" id="ExEmpConf_eligibility" name="ExEmpConf_eligibility" class="form-control" style="width: 350px;"></textarea>
                            </td>
                            <td>
                                <textarea type="text" id="ExEmpConf_eligibilityVer" name="ExEmpConf_eligibilityVer" class="form-control" style="width: 350px;"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Verified by (Name & Designation):</b>
                            </td>
                            <td>
                                <input type="text" id="ExEmpConf_verifiedby" name="ExEmpConf_verifiedby" class="form-control" style="width: 350px;" />
                            </td>
                            <td>
                                <input type="text" id="ExEmpConf_verifiedbyVer" name="ExEmpConf_verifiedbyVer" class="form-control" style="width: 350px;" />
                            </td>
                        </tr>
                        <tr>
                            <td><b>Attachment:</b></td>
                            <td>
                                <input type="file" id="ExEmpConf_attachment" name="ExEmpConf_attachment" class="form-control" style="width: 350px;" />

                            </td>
                            <td>
                                <div class="dropzone_conf dropzone_conf-multiple p-0 dz-clickable dz-file-processing dz-file-complete" id="dropzone_conf">
                                    <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column" id="conentdiv_conf" style="display: none!important;">

                                        <div class="flex-1 d-flex flex-between-center">
                                            <div id="filesdiv_conf" style="margin-top: 10px; margin-bottom: 10px;"></div>
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
                            <td colspan="4" align="center">
                                <button id="ExEmpConf_btnSubmit" class="btn btn-primary" onclick="return ExEmpConf_SubmitData();">Submit</button>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <div class="modal fade" id="formCof_dverror">
            <div class="modal-dialog modal-sm">
                <div class="modal-content">
                    <div class="modal-header">
                        <h6 class="modal-title" id="formCof_errmsg"></h6>
                    </div>

                    <div class="modal-footer align-content-center">
                        <button class="btn btn-primary" type="button" id="btnMessageConf" onclick="return ExFormConf_Message();">Okay</button>
                    </div>
                </div>
                <!-- /.modal-content -->
            </div>
            <!-- /.modal-dialog -->
        </div>
</asp:Content>--%>
