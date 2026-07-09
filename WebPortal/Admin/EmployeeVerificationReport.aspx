<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EmployeeVerificationReport.aspx.cs" Inherits="WebPortal.Admin.EmployeeVerificationReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --ev-primary: #1d4ed8;
            --ev-primary2: #2563eb;
            --ev-cyan: #22c1dc;
            --ev-bg: #f4f7fb;
            --ev-card: #ffffff;
            --ev-text: #0f172a;
            --ev-muted: #64748b;
            --ev-border: #e2e8f0;
        }

        .ev-page {
            background: var(--ev-bg);
        }

        .ev-hero {
            position: relative;
            overflow: hidden;
            border-radius: 18px;
            background: linear-gradient(120deg, var(--ev-primary) 0%, var(--ev-primary2) 62%, var(--ev-cyan) 100%);
            color: #fff;
            padding: 22px 24px;
            box-shadow: 0 14px 30px rgba(37,99,235,.22);
            margin-bottom: 18px;
        }

            .ev-hero:after {
                content: "";
                position: absolute;
                right: -60px;
                top: -80px;
                width: 220px;
                height: 220px;
                border-radius: 50%;
                background: rgba(255,255,255,.16);
            }

        .ev-hero-content {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            flex-wrap: wrap;
        }

        .ev-title-wrap {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .ev-title-icon {
            width: 54px;
            height: 54px;
            border-radius: 16px;
            background: rgba(255,255,255,.18);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            box-shadow: inset 0 0 0 1px rgba(255,255,255,.24);
        }

        .ev-hero h4 {
            margin: 0;
            font-size: 22px;
            font-weight: 800;
            letter-spacing: .2px;
        }

        .ev-hero p {
            margin: 4px 0 0;
            color: rgba(255,255,255,.88);
            font-size: 13px;
        }

        .ev-chip {
            border: 1px solid rgba(255,255,255,.28);
            background: rgba(255,255,255,.16);
            border-radius: 999px;
            padding: 8px 14px;
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
        }

        .ev-card {
            background: var(--ev-card);
            border: 1px solid var(--ev-border);
            border-radius: 18px;
            box-shadow: 0 10px 28px rgba(15,23,42,.07);
            margin-bottom: 18px;
            overflow: hidden;
        }

        .ev-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 16px 18px;
            border-bottom: 1px solid var(--ev-border);
            background: linear-gradient(180deg,#fff,#f8fafc);
        }

        .ev-card-title {
            margin: 0;
            color: var(--ev-text);
            font-size: 16px;
            font-weight: 800;
        }

        .ev-card-subtitle {
            margin: 3px 0 0;
            color: var(--ev-muted);
            font-size: 12px;
        }

        .ev-card-body {
            padding: 18px;
        }

        .ev-field label {
            display: block;
            margin-bottom: 6px;
            color: #334155;
            font-size: 12px;
            font-weight: 700 !important;
        }

        .ev-field .form-control,
        .ev-field select,
        .ev-field textarea {
            min-height: 40px;
            border-radius: 10px !important;
            border: 1px solid #cbd5e1 !important;
            font-size: 13px !important;
            box-shadow: none !important;
            background-color: #fff;
        }

        .ev-field textarea {
            min-height: 92px;
            resize: vertical;
        }

        .ev-label-box {
            display: flex;
            align-items: center;
            min-height: 40px;
            border-radius: 10px;
            border: 1px solid #cbd5e1;
            background: #f8fafc;
            padding: 8px 12px;
            font-size: 13px;
            font-weight: 700;
            color: #0f172a;
            width: 100% !important;
        }

        .ev-actions {
            display: flex;
            align-items: center;
            gap: 10px;
            justify-content: flex-end;
            flex-wrap: wrap;
        }

        .btn-ev-primary {
            border: 0;
            border-radius: 10px;
            background: linear-gradient(120deg,var(--ev-primary2),var(--ev-cyan));
            color: #fff !important;
            font-weight: 800;
            padding: 10px 18px;
            box-shadow: 0 10px 20px rgba(37,99,235,.22);
            transition: .22s ease;
        }

            .btn-ev-primary:hover {
                transform: translateY(-1px);
                box-shadow: 0 12px 24px rgba(37,99,235,.30);
            }

        .btn-ev-light {
            border: 1px solid var(--ev-border);
            border-radius: 10px;
            background: #fff;
            color: #334155 !important;
            font-weight: 800;
            padding: 10px 18px;
        }

        #load1.loading {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%,-50%);
            margin: 0;
            width: auto;
            height: auto;
            padding: 22px 28px;
            background: rgba(255,255,255,.96);
            border-radius: 18px;
            box-shadow: 0 18px 45px rgba(15,23,42,.18);
            text-align: center;
            z-index: 99999;
            opacity: 1;
        }

        #load1 img {
            max-width: 70px;
        }

        .ev-table-wrap {
            width: 100%;
            overflow-x: auto;
        }

        #ExEmployerVerification {
            width: 100% !important;
            margin: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0;
        }

            #ExEmployerVerification thead th,
            .table.dataTable th {
                background: #edf3f6 !important;
                color: #0f172a !important;
                height: 42px;
                vertical-align: middle;
                font-size: 12px;
                font-weight: 800;
                white-space: nowrap;
                border-bottom: 1px solid #dbe4ee !important;
            }

            #ExEmployerVerification tbody td {
                vertical-align: middle;
                font-size: 12px;
                color: #334155;
                background: #fff !important;
                border-color: #edf2f7 !important;
            }

            #ExEmployerVerification tbody tr:hover td {
                background: #f8fbff !important;
            }

        .dataTables_length, .dataTables_info {
            float: left !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 16px;
            float: left;
        }

        .buttons-excel, .buttons-html5 {
            color: #fff !important;
            background: linear-gradient(120deg,#16a34a,#22c55e) !important;
            border: 0 !important;
            border-radius: 9px !important;
            font-weight: 800 !important;
            margin: 0 8px !important;
            box-shadow: 0 8px 18px rgba(22,163,74,.20);
        }

        .modal-content {
            border: 0;
            border-radius: 18px;
            overflow: hidden;
            box-shadow: 0 20px 50px rgba(15,23,42,.28);
        }

        .modal-header {
            background: linear-gradient(120deg,var(--ev-primary2),var(--ev-cyan));
            color: #fff;
            border: 0;
            align-items: center;
        }

            .modal-header .close {
                color: #fff;
                opacity: 1;
                text-shadow: none;
            }

        .modal-title {
            font-size: 17px;
            font-weight: 800;
        }

        .modal-body {
            background: #f8fafc;
            padding: 18px;
        }

        .modal-footer {
            border-top: 1px solid var(--ev-border);
            background: #fff;
        }

        .ev-upload {
            position: relative;
            border: 2px dashed #bfdbfe;
            border-radius: 16px;
            background: #eff6ff;
            padding: 18px;
            text-align: center;
            cursor: pointer;
            transition: .22s ease;
        }

            .ev-upload:hover {
                border-color: #2563eb;
                transform: translateY(-1px);
                box-shadow: 0 10px 22px rgba(37,99,235,.12);
            }

            .ev-upload input[type=file] {
                width: 100%;
                cursor: pointer;
                background: #fff;
            }

        .dropzone {
            margin-top: 10px;
            border: 0 !important;
            background: transparent !important;
        }

        #filesdiv {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border-radius: 999px;
            padding: 8px 12px;
            background: #dcfce7;
            color: #166534;
            font-weight: 800;
            font-size: 12px;
        }

            #filesdiv:before {
                content: "\f1c3";
                font-family: "Font Awesome 5 Free";
                font-weight: 900;
            }

        #waitingpanel .modal-dialog {
            margin-top: 18vh;
        }

        @keyframes animate {
            0% {
                opacity: 0;
            }

            50% {
                opacity: .7;
            }

            100% {
                opacity: 0;
            }
        }

        @media (max-width: 767px) {
            .ev-page {
                padding: 10px;
            }

            .ev-hero {
                padding: 18px;
                border-radius: 14px;
            }

                .ev-hero h4 {
                    font-size: 18px;
                }

            .ev-title-icon {
                width: 46px;
                height: 46px;
            }

            .ev-card-body {
                padding: 14px;
            }

            .ev-actions {
                justify-content: stretch;
            }

                .ev-actions .btn {
                    width: 100%;
                }
        }
    </style>

    <script>
        $(document).ready(function () {
            ExEmployerVerification_BindYear();
        });
    </script>
    <script>
        window.onload = function () {
            document.getElementById('ExEmpResend_attachment').addEventListener('change', getFileName);
        }
        const getFileName = (event) => {
            const files = event.target.files;
            var file = files[0];
            document.getElementById("filep").value = files[0].name;

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
            document.getElementById("dropzone").classList.add("dz-max-files-reached");
            document.getElementById("conentdiv").style.display = '';
            document.getElementById("filesdiv").innerHTML = file.name;
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="filep" style="display: none;" />

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="ev-page">
        <section class="ev-hero">
            <div class="ev-hero-content">
                <div class="ev-title-wrap">
                    <div class="ev-title-icon">
                        <i class="fas fa-user-shield"></i>
                    </div>
                    <div>
                        <h4>Ex Employer Verification</h4>
                        <p>Track background verification status, resend emails and update verification requirement details.</p>
                    </div>
                </div>
                <div class="ev-chip">
                    <i class="fas fa-clipboard-check"></i>
                    Verification Report
               
                </div>
            </div>
        </section>

        <div class="ev-card">
            <div class="ev-card-header">
                <div>
                    <h5 class="ev-card-title">
                        <i class="fas fa-filter text-primary"></i>
                        Search Verification Records
                    </h5>
                    <p class="ev-card-subtitle">Select month and year to view employee verification details.</p>
                </div>
            </div>
            <div class="ev-card-body">
                <div class="row align-items-end">
                    <div class="col-lg-4 col-md-6 col-sm-12">
                        <div class="ev-field form-group">
                            <label for="ExEmp_month">Month</label>
                            <select id="ExEmp_month" name="ExEmp_month" class="form-control">
                                <option value="">Select</option>
                                <option value="All">All</option>
                                <option value="January">January</option>
                                <option value="February">February</option>
                                <option value="March">March</option>
                                <option value="April">April</option>
                                <option value="May">May</option>
                                <option value="June">June</option>
                                <option value="July">July</option>
                                <option value="August">August</option>
                                <option value="September">September</option>
                                <option value="October">October</option>
                                <option value="November">November</option>
                                <option value="December">December</option>
                            </select>
                        </div>
                    </div>

                    <div class="col-lg-4 col-md-6 col-sm-12">
                        <div class="ev-field form-group">
                            <label for="ExEmp_year">Year</label>
                            <select id="ExEmp_year" name="ExEmp_year" class="form-control">
                                <option value="">Select</option>
                            </select>
                        </div>
                    </div>

                    <div class="col-lg-4 col-md-12 col-sm-12">
                        <div class="ev-actions form-group">
                            <button id="btnShow" type="button" class="btn btn-ev-primary" onclick="return ExEmployerVerification_Submit();">
                                <i class="fas fa-search"></i>
                                Show Report
                           
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="ev-card">
            <div class="ev-card-header">
                <div>
                    <h5 class="ev-card-title">
                        <i class="fas fa-table text-primary"></i>
                        Verification Details
                    </h5>
                    <p class="ev-card-subtitle">Review current email and verification status.</p>
                </div>
            </div>
            <div class="ev-card-body">
                <div class="ev-table-wrap">
                    <table class="table table-bordered table-hover" id="ExEmployerVerification">
                        <thead>
                            <tr>
                                <th class="sort border-top ps-3" style="display: none;">Verification ID</th>
                                <th class="sort border-top ps-3" style="display: none;">Employee ID</th>
                                <th class="sort border-top ps-3">Actions</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Employee Name</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Joining Date</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Gender</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Current Status</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Latest Login Date</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Email Status</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Verification Status</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Verified By</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Verified Date</th>
                                <th class="sort border-top ps-3" style="display: none;">Attachment</th>
                                <th class="sort border-top ps-3" style="display: none;">Receiver</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="exemployerisrequired">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">
                        <i class="fas fa-user-check"></i>
                        Is Background Verification Required?
                    </h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>

                <div class="modal-body">
                    <div class="row">
                        <div class="col-lg-6 col-md-12">
                            <div class="ev-field form-group">
                                <label>Employee</label>
                                <label id="ExEmployer_empname" class="ev-label-box"></label>
                            </div>
                        </div>

                        <div class="col-lg-6 col-md-12">
                            <div class="ev-field form-group">
                                <label for="ExEmployer_bgvrequired">Background Verification Required?</label>
                                <select id="ExEmployer_bgvrequired" name="ExEmployer_bgvrequired" class="form-control">
                                    <option value="">Select</option>
                                    <option value="Yes">Yes</option>
                                    <option value="No">No</option>
                                </select>
                            </div>
                        </div>

                        <div class="col-12">
                            <div class="ev-field form-group">
                                <label for="ExEmployer_remark1">Remark</label>
                                <textarea id="ExEmployer_remark1" name="ExEmployer_remark1" class="form-control"></textarea>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-ev-light" data-dismiss="modal">
                        <i class="fas fa-times"></i>
                        Close
                   
                    </button>
                    <button class="btn btn-ev-primary" type="button" id="btnExEmployerUpdateRequired" onclick="return ExEmployer_UpdateRemark();">
                        <i class="fas fa-save"></i>
                        Update
                   
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="resendemail">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">
                        <i class="fas fa-paper-plane"></i>
                        Resend Background Verification Email
                    </h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>

                <div class="modal-body">
                    <div class="row">
                        <div class="col-lg-6 col-md-12">
                            <div class="ev-field form-group">
                                <label>Employee Name</label>
                                <input id="ExEmployer_empnameresend" type="text" class="ev-label-box" />
                            </div>
                        </div>

                        <div class="col-lg-6 col-md-12">
                            <div class="ev-field form-group">
                                <label for="ExEmployer_receiverresend">Receiver Email Address</label>
                                <textarea id="ExEmployer_receiverresend" name="ExEmployer_receiverresend" class="form-control"></textarea>
                            </div>
                        </div>

                        <div class="col-12">
                            <div class="ev-field form-group">
                                <label for="ExEmpResend_attachment">Attachment</label>
                                <div class="ev-upload">
                                    <div style="font-size: 30px; color: #2563eb; margin-bottom: 8px;">
                                        <i class="fas fa-cloud-upload-alt"></i>
                                    </div>
                                    <div style="font-weight: 800; color: #0f172a;">Choose attachment for verification email</div>
                                    <div style="font-size: 12px; color: #64748b; margin: 4px 0 12px;">Selected file name will appear below after upload.</div>
                                    <input type="file" id="ExEmpResend_attachment" name="ExEmpResend_attachment" class="form-control" />
                                </div>

                                <div class="dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete" id="dropzone">
                                    <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column" id="conentdiv" style="display: none!important;">
                                        <div class="flex-1 d-flex flex-between-center">
                                            <div id="filesdiv" style="margin-top: 10px; margin-bottom: 10px;"></div>
                                            <div class="dropdown font-sans-serif">
                                                <button class="btn btn-link text-600 btn-sm dropdown-toggle btn-reveal dropdown-caret-none" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                    <svg class="svg-inline--fa fa-ellipsis" style="display: none!important" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="ellipsis" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg="">
                                                        <path fill="currentColor" d="M120 256C120 286.9 94.93 312 64 312C33.07 312 8 286.9 8 256C8 225.1 33.07 200 64 200C94.93 200 120 225.1 120 256zM280 256C280 286.9 254.9 312 224 312C193.1 312 168 286.9 168 256C168 225.1 193.1 200 224 200C254.9 200 280 225.1 280 256zM328 256C328 225.1 353.1 200 384 200C414.9 200 440 225.1 440 256C440 286.9 414.9 312 384 312C353.1 312 328 286.9 328 256z"></path>
                                                    </svg>
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
                </div>

                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-ev-light" data-dismiss="modal">
                        <i class="fas fa-times"></i>
                        Close
                   
                    </button>
                    <button class="btn btn-ev-primary" type="button" id="btnExEmployerresend" onclick="return ExEmployer_ResendEmail();">
                        <i class="fas fa-paper-plane"></i>
                        Resend Email
                   
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="waitingpanel">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;">System is sending verification email. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>

    <div class="modal fade" id="dverror">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="errmsg"></h6>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-ev-primary" type="button" id="btnMessage" onclick="return ExEmployer_Message();">
                        <i class="fas fa-check"></i>
                        Okay
                   
                    </button>
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
    <style>
        @keyframes animate {
            0% {
                opacity: 0;
            }

            50% {
                opacity: 0.7;
            }

            100% {
                opacity: 0;
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            ExEmployerVerification_BindYear();
        });
    </script>
    <script>
        window.onload = function () {
            document.getElementById('ExEmpResend_attachment').addEventListener('change', getFileName);
        }
        const getFileName = (event) => {
            const files = event.target.files;
            var file = files[0];
            document.getElementById("filep").value = files[0].name;

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
            document.getElementById("dropzone").classList.add("dz-max-files-reached");
            document.getElementById("conentdiv").style.display = '';
            document.getElementById("filesdiv").innerHTML = file.name;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="filep" style="display: none;" />
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Ex Employer Verification</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <h5 class="card-title"></h5>
                <table class="table">
                    <tr>
                        <td style="width: 50px;"><b>Month:</b></td>
                        <td style="width: 150px;">
                            <select id="ExEmp_month" name="ExEmp_month" class="form-control">
                                <option value="">Select</option>
                                <option value="All">All</option>
                                <option value="January">January</option>
                                <option value="February">February</option>
                                <option value="March">March</option>
                                <option value="April">April</option>
                                <option value="May">May</option>
                                <option value="June">June</option>
                                <option value="July">July</option>
                                <option value="August">August</option>
                                <option value="September">September</option>
                                <option value="October">October</option>
                                <option value="November">November</option>
                                <option value="December">December</option>
                            </select>
                        </td>
                        <td style="width: 50px;">
                            <b>Year:</b>
                        </td>
                        <td style="width: 150px;">
                            <select id="ExEmp_year" name="ExEmp_year" class="form-control">
                                <option value="">Select</option>
                            </select>
                        </td>
                        <td style="width: 100px;">
                            <button id="btnShow" class="btn btn-primary" onclick="return ExEmployerVerification_Submit()">Show</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <table class="table" id="ExEmployerVerification" style="padding-top: 10px; width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="display: none;">Verification ID</th>
                            <th class="sort border-top ps-3" style="display: none;">Employee ID</th>
                            <th class="sort border-top ps-3">Actions</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Employee Name</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Joining Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Gender</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Current Status</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Latest Login Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Email Status</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Verification Status</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Verified By</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Verified Date</th>
                            <th class="sort border-top ps-3" style="display: none;">Attachment</th>
                            <th class="sort border-top ps-3" style="display: none;">Receiver</th>
                        </tr>

                    </thead>
                    <tbody></tbody>

                </table>

            </div>
        </div>
    </div>

    <div class="modal fade" id="exemployerisrequired">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Is Background Verification Required?</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table">
                        <tr>
                            <td><b>Employee:</b></td>
                            <td>
                                <label id="ExEmployer_empname" class="form-control" style="width: 300px;"></label>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Background Verification Required?:</b></td>
                            <td>
                                <select id="ExEmployer_bgvrequired" name="ExEmployer_bgvrequired" class="form-control" style="width: 300px;">
                                    <option value="">Select</option>
                                    <option value="Yes">Yes</option>
                                    <option value="No">No</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Remark:</b></td>
                            <td>
                                <textarea type="date" id="ExEmployer_remark1" name="ExEmployer_remark1" class="form-control" style="width: 300px;"></textarea>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button class="btn btn-primary" type="button" id="btnExEmployerUpdateRequired" onclick="return ExEmployer_UpdateRemark();">Update</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

    <div class="modal fade" id="resendemail">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Resend Background Verification Email </h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table">
                        <tr>
                            <td><b>Employee Name:</b></td>
                            <td>
                                <label id="ExEmployer_empnameresend" class="form-control" style="width: 300px;"></label>
                            </td>
                        </tr>

                        <tr>
                            <td><b>Receiver Email Address:</b></td>
                            <td>
                                <textarea type="date" id="ExEmployer_receiverresend" name="ExEmployer_receiverresend" class="form-control" style="width: 300px;"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Attachment:</b></td>
                            <td>
                                <input type="file" id="ExEmpResend_attachment" name="ExEmpResend_attachment" class="form-control" style="width: 350px;" />
                                <div class="dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete" id="dropzone">
                                    <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column" id="conentdiv" style="display: none!important;">
                                        <div class="flex-1 d-flex flex-between-center">
                                            <div id="filesdiv" style="margin-top: 10px; margin-bottom: 10px;"></div>
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
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button class="btn btn-primary" type="button" id="btnExEmployerresend" onclick="return ExEmployer_ResendEmail();">Resend Email</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
    <div class="modal fade" id="waitingpanel">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;">System is sending verification email. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>

    <div class="modal fade" id="dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="errmsg"></h6>
                  
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="btnMessage" onclick="return ExEmployer_Message();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

</asp:Content>--%>
