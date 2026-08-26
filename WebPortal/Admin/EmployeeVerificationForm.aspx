<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EmployeeVerificationForm.aspx.cs" Inherits="WebPortal.Admin.EmployeeVerificationForm" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --ev-primary: #1d4ed8;
            --ev-primary-2: #2563eb;
            --ev-cyan: #22c1dc;
            --ev-dark: #0f172a;
            --ev-muted: #64748b;
            --ev-border: #dbe4f0;
            --ev-soft: #f5f8fc;
            --ev-white: #ffffff;
        }

        .loading {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            opacity: .95;
            border-radius: 18px;
            width: 190px;
            min-height: 160px;
            z-index: 99999;
            background: #fff;
            box-shadow: 0 18px 45px rgba(15, 23, 42, .18);
            text-align: center;
            padding: 22px 16px;
        }

        .loading img {
            width: 70px;
            height: 70px;
        }

        .ev-page {
            background: #f3f6fb;
            min-height: calc(100vh - 80px);
        }

        .ev-hero {
            background: linear-gradient(120deg, var(--ev-primary) 0%, var(--ev-primary-2) 62%, var(--ev-cyan) 100%);
            border-radius: 20px;
            color: #fff;
            padding: 20px 22px;
            box-shadow: 0 16px 40px rgba(37, 99, 235, .22);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            margin-bottom: 18px;
        }

        .ev-hero-left {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .ev-hero-icon {
            width: 58px;
            height: 58px;
            border-radius: 17px;
            background: rgba(255, 255, 255, .18);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 25px;
            border: 1px solid rgba(255, 255, 255, .28);
        }

        .ev-hero h4 {
            margin: 0;
            font-weight: 800;
            letter-spacing: .2px;
        }

        .ev-hero p {
            margin: 4px 0 0;
            opacity: .9;
            font-size: 13px;
        }

        .ev-back {
            color: #fff !important;
            background: rgba(255, 255, 255, .18);
            border: 1px solid rgba(255, 255, 255, .30);
            border-radius: 999px;
            padding: 9px 16px;
            font-size: 12px;
            font-weight: 700;
            text-decoration: none !important;
            white-space: nowrap;
            transition: .25s ease;
        }

        .ev-back:hover {
            background: #fff;
            color: var(--ev-primary) !important;
            transform: translateY(-1px);
        }

        .ev-shell {
            background: #fff;
            border-radius: 20px;
            border: 1px solid rgba(219, 228, 240, .95);
            box-shadow: 0 12px 32px rgba(15, 23, 42, .06);
            padding: 18px;
        }

        .ev-section {
            border: 1px solid var(--ev-border);
            border-radius: 18px;
            background: #fff;
            overflow: hidden;
            margin-bottom: 18px;
        }

        .ev-section:last-child {
            margin-bottom: 0;
        }

        .ev-section-header {
            padding: 14px 18px;
            background: linear-gradient(90deg, #eff6ff 0%, #f8fbff 100%);
            border-bottom: 1px solid var(--ev-border);
            display: flex;
            align-items: center;
            gap: 10px;
            color: var(--ev-dark);
            font-weight: 800;
        }

        .ev-section-header i {
            color: var(--ev-primary-2);
            font-size: 15px;
        }

        .ev-section-body {
            padding: 18px;
        }

        .ev-field {
            margin-bottom: 15px;
        }

        .ev-field label {
            display: block;
            font-size: 12px;
            font-weight: 800;
            color: #334155;
            margin-bottom: 6px;
        }

        .ev-field .form-control,
        .ev-field input,
        .ev-field textarea {
            width: 100% !important;
            border: 1px solid #cbd5e1;
            border-radius: 11px;
            min-height: 38px;
            font-size: 12px;
            color: #0f172a;
            background: #fff;
            box-shadow: none;
            transition: .2s ease;
        }

        .ev-field textarea {
            min-height: 78px;
            resize: vertical;
        }

        .ev-field .form-control:focus,
        .ev-field input:focus,
        .ev-field textarea:focus {
            border-color: var(--ev-primary-2);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, .12);
            outline: none;
        }

        .ev-readonly-label {
            display: flex;
            align-items: center;
            padding: 9px 12px;
            min-height: 38px;
            border: 1px solid #cbd5e1;
            border-radius: 11px;
            background: #f8fafc;
            color: #0f172a;
            font-weight: 700;
            font-size: 12px;
        }

        .ev-upload-wrap {
            position: relative;
        }

        .ev-file-native {
            position: absolute;
            width: 1px !important;
            height: 1px;
            opacity: 0;
            overflow: hidden;
            pointer-events: none;
        }

        .ev-dropzone {
            border: 2px dashed #bfdbfe;
            background: #f8fbff;
            border-radius: 16px;
            padding: 18px;
            min-height: 120px;
            display: flex;
            align-items: center;
            gap: 14px;
            cursor: pointer;
            transition: .25s ease;
        }

        .ev-dropzone:hover,
        .ev-dropzone.ev-dragover {
            border-color: var(--ev-primary-2);
            background: #eff6ff;
            transform: translateY(-2px);
            box-shadow: 0 14px 28px rgba(37, 99, 235, .12);
        }

        .ev-upload-icon {
            width: 54px;
            height: 54px;
            border-radius: 16px;
            background: linear-gradient(135deg, var(--ev-primary-2), var(--ev-cyan));
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            animation: evFloat 2.2s ease-in-out infinite;
            flex: 0 0 auto;
        }

        @keyframes evFloat {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-6px); }
        }

        .ev-upload-title {
            font-weight: 800;
            color: var(--ev-dark);
            margin-bottom: 2px;
        }

        .ev-upload-sub {
            color: var(--ev-muted);
            font-size: 12px;
        }

        .ev-selected-file {
            display: none;
            margin-top: 10px;
            border: 1px solid #bbf7d0;
            background: #f0fdf4;
            border-radius: 13px;
            padding: 10px 12px;
            font-size: 12px;
            font-weight: 700;
            color: #166534;
        }

        .ev-actionbar {
            display: flex;
            align-items: center;
            justify-content: center;
            padding-top: 6px;
        }

        .ev-btn-primary {
            border: 0;
            border-radius: 12px;
            padding: 11px 34px;
            background: linear-gradient(135deg, var(--ev-primary-2), var(--ev-cyan));
            color: #fff;
            font-size: 13px;
            font-weight: 800;
            box-shadow: 0 12px 24px rgba(37, 99, 235, .24);
            transition: .25s ease;
        }

        .ev-btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 16px 30px rgba(37, 99, 235, .30);
            color: #fff;
        }

        .ev-modal .modal-content {
            border-radius: 16px;
            border: 0;
            box-shadow: 0 24px 54px rgba(15, 23, 42, .22);
        }

        .ev-modal .modal-header {
            background: linear-gradient(120deg, var(--ev-primary), var(--ev-cyan));
            color: #fff;
            border-radius: 16px 16px 0 0;
            border-bottom: 0;
        }

        @media (max-width: 767px) {
            .ev-page {
                padding: 10px;
            }

            .ev-hero {
                align-items: flex-start;
                flex-direction: column;
            }

            .ev-shell,
            .ev-section-body {
                padding: 14px;
            }

            .ev-dropzone {
                align-items: flex-start;
                flex-direction: column;
            }
        }
    </style>

    <script>
        var exEmpFormUploadInProgress = false;

        window.onload = function () {
            var uploadInput = document.getElementById('ExEmpForm_attachment');
            if (uploadInput) {
                uploadInput.addEventListener('change', getFileName);
            }

            initExEmpDragDrop();
        }

        const getFileName = (event) => {
            const files = event.target.files;
            if (!files || files.length === 0) {
                return;
            }

            var file = files[0];
            document.getElementById("filep").value = file.name;

            const fd = new FormData();
            fd.append(event.target.name, file, file.name);

            const xhr = new XMLHttpRequest();

            exEmpFormUploadInProgress = true;
            var submitButton = document.getElementById("ExEmpForm_btnSubmit");
            if (submitButton) submitButton.disabled = true;

            xhr.onload = () => {
                exEmpFormUploadInProgress = false;
                if (submitButton) submitButton.disabled = false;

                if (xhr.status >= 200 && xhr.status < 300) {
                    return;
                }

                showExEmpFormMessage("The attachment could not be uploaded. Please select it again.", true);
            };

            xhr.onerror = () => {
                exEmpFormUploadInProgress = false;
                if (submitButton) submitButton.disabled = false;
                showExEmpFormMessage("The attachment could not be uploaded. Please check your connection and try again.", true);
            };

            var url = window.location.href;
            xhr.open('POST', url, true);
            xhr.send(fd);

            var oldDropzone = document.getElementById("dropzone");
            var oldContent = document.getElementById("conentdiv");
            var oldFileDiv = document.getElementById("filesdiv");

            if (oldDropzone) oldDropzone.classList.add("dz-max-files-reached");
            if (oldContent) oldContent.style.display = '';
            if (oldFileDiv) oldFileDiv.innerHTML = file.name;

            var selectedFile = document.getElementById("ExEmpForm_selectedFile");
            var selectedFileName = document.getElementById("ExEmpForm_selectedFileName");

            if (selectedFile && selectedFileName) {
                selectedFile.style.display = "block";
                selectedFileName.innerHTML = '<i class="fas fa-check-circle"></i>&nbsp;' + file.name;
            }
        }

        function initExEmpDragDrop() {
            var dropArea = document.getElementById("ExEmpForm_dropArea");
            var fileInput = document.getElementById("ExEmpForm_attachment");

            if (!dropArea || !fileInput) {
                return;
            }

            dropArea.addEventListener("click", function () {
                fileInput.click();
            });

            dropArea.addEventListener("dragover", function (e) {
                e.preventDefault();
                dropArea.classList.add("ev-dragover");
            });

            dropArea.addEventListener("dragleave", function () {
                dropArea.classList.remove("ev-dragover");
            });

            dropArea.addEventListener("drop", function (e) {
                e.preventDefault();
                dropArea.classList.remove("ev-dragover");

                if (e.dataTransfer.files && e.dataTransfer.files.length > 0) {
                    fileInput.files = e.dataTransfer.files;
                    getFileName({ target: fileInput });
                }
            });
        }

        $(document).ready(function () {
            BindFormInformation();
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="filep" style="display: none;" />

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="ev-page">
        <div class="ev-hero">
            <div class="ev-hero-left">
                <div class="ev-hero-icon">
                    <i class="fas fa-user-check"></i>
                </div>
                <div>
                    <h4>Ex Employer Verification Form</h4>
                    <p>Capture previous employer, reporting manager and HR verification details.</p>
                </div>
            </div>

            <a href="#utl" id="aBack" runat="server" class="ev-back" onclick="window.history.go(-1); return false;">
                <i class="fas fa-arrow-left"></i>&nbsp; Go Back
            </a>
        </div>

        <div class="ev-shell">
            <div class="ev-section">
                <div class="ev-section-header">
                    <i class="fas fa-id-card"></i>
                    <span>Basic Details</span>
                </div>

                <div class="ev-section-body">
                    <div class="row">
                        <div class="col-lg-6 col-md-6 col-sm-12">
                            <div class="ev-field">
                                <label>Employee</label>
                                <input type="text" id="ExEmpForm_name" name="ExEmpForm_name" class="form-control" />
                              <%--  <label id="ExEmpForm_name" name="ExEmpForm_name" class="ev-readonly-label"></label>--%>
                            </div>
                        </div>

                        <div class="col-lg-6 col-md-6 col-sm-12">
                            <div class="ev-field">
                                <label for="ExEmpForm_organizationname">Name of Organization</label>
                                <input type="text" id="ExEmpForm_organizationname" name="ExEmpForm_organizationname" class="form-control" />
                            </div>
                        </div>

                        <div class="col-lg-6 col-md-6 col-sm-12">
                            <div class="ev-field">
                                <label for="ExEmpForm_candidatename">Candidate Name</label>
                                <input type="text" id="ExEmpForm_candidatename" name="ExEmpForm_candidatename" class="form-control" />
                            </div>
                        </div>

                        <div class="col-lg-6 col-md-6 col-sm-12">
                            <div class="ev-field">
                                <label for="ExEmpForm_employeeid">Employee ID / Code</label>
                                <input type="text" id="ExEmpForm_employeeid" name="ExEmpForm_employeeid" class="form-control" />
                            </div>
                        </div>

                        <div class="col-lg-6 col-md-6 col-sm-12">
                            <div class="ev-field">
                                <label for="ExEmpForm_designation">Designation</label>
                                <input type="text" id="ExEmpForm_designation" name="ExEmpForm_designation" class="form-control" />
                            </div>
                        </div>

                        <div class="col-lg-6 col-md-6 col-sm-12">
                            <div class="ev-field">
                                <label for="ExEmpForm_employmentperiod">Period of Employment</label>
                                <input type="text" id="ExEmpForm_employmentperiod" name="ExEmpForm_employmentperiod" class="form-control" />
                            </div>
                        </div>

                        <div class="col-lg-6 col-md-6 col-sm-12">
                            <div class="ev-field">
                                <label for="ExEmpForm_salary">Salary</label>
                                <input type="text" id="ExEmpForm_salary" name="ExEmpForm_salary" class="form-control" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="ev-section">
                <div class="ev-section-header">
                    <i class="fas fa-user-tie"></i>
                    <span>Reporting Manager Details</span>
                </div>

                <div class="ev-section-body">
                    <div class="row">
                        <div class="col-lg-6 col-md-6 col-sm-12">
                            <div class="ev-field">
                                <label for="ExEmpForm_reportingmanager">Name</label>
                                <input type="text" id="ExEmpForm_reportingmanager" name="ExEmpForm_reportingmanager" class="form-control" />
                            </div>
                        </div>

                        <div class="col-lg-6 col-md-6 col-sm-12">
                            <div class="ev-field">
                                <label for="ExEmpForm_reportingdesignation">Designation</label>
                                <input type="text" id="ExEmpForm_reportingdesignation" name="ExEmpForm_reportingdesignation" class="form-control" />
                            </div>
                        </div>

                        <div class="col-lg-6 col-md-12 col-sm-12">
                            <div class="ev-field">
                                <label for="ExEmpForm_reportingmanageremail">Contact No. & E-Mail</label>
                                <textarea id="ExEmpForm_reportingmanageremail" name="ExEmpForm_reportingmanageremail" class="form-control"></textarea>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="ev-section">
                <div class="ev-section-header">
                    <i class="fas fa-clipboard-check"></i>
                    <span>HR Related Details</span>
                </div>

                <div class="ev-section-body">
                    <div class="row">
                        <div class="col-lg-6 col-md-6 col-sm-12">
                            <div class="ev-field">
                                <label for="ExEmpForm_hrname">HR Name</label>
                                <input type="text" id="ExEmpForm_hrname" name="ExEmpForm_hrname" class="form-control" />
                            </div>
                        </div>

                        <div class="col-lg-6 col-md-6 col-sm-12">
                            <div class="ev-field">
                                <label for="ExEmpForm_hremail">Contact No. & E-Mail</label>
                                <input type="text" id="ExEmpForm_hremail" name="ExEmpForm_hremail" class="form-control" />
                            </div>
                        </div>

                        <div class="col-lg-6 col-md-12 col-sm-12">
                            <div class="ev-field">
                                <label for="ExEmpForm_reasonforleaving">Reason for Leaving the Organization</label>
                                <textarea id="ExEmpForm_reasonforleaving" name="ExEmpForm_reasonforleaving" class="form-control"></textarea>
                            </div>
                        </div>

                        <div class="col-lg-6 col-md-6 col-sm-12">
                            <div class="ev-field">
                                <label for="ExEmpForm_exitformality">Any Exit Formalities Pending (YES / NO)</label>
                                <input type="text" id="ExEmpForm_exitformality" name="ExEmpForm_exitformality" class="form-control" />
                            </div>
                        </div>

                        <div class="col-lg-6 col-md-12 col-sm-12">
                            <div class="ev-field">
                                <label for="ExEmpForm_eligibility">Eligible for Rehire (If No, Please Specify Reason)</label>
                                <textarea id="ExEmpForm_eligibility" name="ExEmpForm_eligibility" class="form-control"></textarea>
                            </div>
                        </div>

                        <div class="col-lg-6 col-md-6 col-sm-12">
                            <div class="ev-field">
                                <label for="ExEmpForm_verifiedby">Verified By (Name & Designation)</label>
                                <input type="text" id="ExEmpForm_verifiedby" name="ExEmpForm_verifiedby" class="form-control" />
                            </div>
                        </div>

                        <div class="col-lg-6 col-md-6 col-sm-12">
                            <div class="ev-field">
                                <label for="ExEmpForm_receiver">Receiver Email Address</label>
                                <input type="email" id="ExEmpForm_receiver" name="ExEmpForm_receiver" class="form-control" />
                            </div>
                        </div>

                        <div class="col-lg-6 col-md-12 col-sm-12">
                            <div class="ev-field">
                                <label for="ExEmpForm_attachment">Attachment</label>

                                <div class="ev-upload-wrap">
                                    <input type="file" id="ExEmpForm_attachment" name="ExEmpForm_attachment" class="form-control ev-file-native" />

                                    <div id="ExEmpForm_dropArea" class="ev-dropzone">
                                        <div class="ev-upload-icon">
                                            <i class="fas fa-cloud-upload-alt"></i>
                                        </div>

                                        <div>
                                            <div class="ev-upload-title">Drag & Drop attachment here</div>
                                            <div class="ev-upload-sub">or click to browse file from your system</div>
                                        </div>
                                    </div>

                                    <div id="ExEmpForm_selectedFile" class="ev-selected-file">
                                        <span id="ExEmpForm_selectedFileName"></span>
                                    </div>
                                </div>

                                <div class="dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete" id="dropzone" style="display:none;">
                                    <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column" id="conentdiv" style="display: none!important;">
                                        <div class="flex-1 d-flex flex-between-center">
                                            <div id="filesdiv" style="margin-top: 10px; margin-bottom: 10px;"></div>
                                            <div class="dropdown font-sans-serif">
                                                <button class="btn btn-link text-600 btn-sm dropdown-toggle btn-reveal dropdown-caret-none" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                    <span class="fas fa-ellipsis-h"></span>
                                                </button>
                                                <div class="dropdown-menu dropdown-menu-end border py-2">
                                                    <a class="dropdown-item" href="#!" data-dz-remove="data-dz-remove">Remove File</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>

                    <div class="ev-actionbar">
                        <button id="ExEmpForm_btnSubmit" type="button" class="ev-btn-primary" onclick="return ExEmpForm_SubmitData();">
                            <i class="fas fa-paper-plane"></i>&nbsp; Submit Verification
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade ev-modal" id="form_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="form_errmsg"></h6>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="btnMessage" onclick="return ExForm_Message();">Okay</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
