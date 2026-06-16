<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="FestivalWishesMaster.aspx.cs" Inherits="WebPortal.Admin.FestivalWishesMaster" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --fw-primary: #4f46e5;
            --fw-primary-dark: #3730a3;
            --fw-accent: #06b6d4;
            --fw-bg: #f6f8ff;
            --fw-surface: rgba(255, 255, 255, 0.92);
            --fw-text: #111827;
            --fw-muted: #6b7280;
            --fw-border: #e5e7eb;
            --fw-shadow: 0 18px 45px rgba(17, 24, 39, 0.10);
        }

        body {
            background: radial-gradient(circle at top left, rgba(79, 70, 229, 0.12), transparent 34rem), radial-gradient(circle at top right, rgba(6, 182, 212, 0.16), transparent 28rem), var(--fw-bg);
            color: var(--fw-text);
        }

        label:not(.form-check-label):not(.custom-file-label),
        label {
            font-size: 13px;
            font-weight: 700 !important;
            color: #374151;
            margin-bottom: 7px;
            border: none !important;
        }

        .festival-page {
            padding: 8px 4px 28px;
        }

        .dashboard-header {
            background: linear-gradient(135deg, rgba(79, 70, 229, 0.96), rgba(6, 182, 212, 0.9)), url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='160' height='160' viewBox='0 0 160 160'%3E%3Cg fill='none' stroke='%23ffffff' stroke-opacity='.18' stroke-width='2'%3E%3Cpath d='M0 80h160M80 0v160M24 24l112 112M136 24L24 136'/%3E%3C/g%3E%3C/svg%3E");
            border-radius: 24px;
            padding: 26px 30px;
            color: #fff;
            position: relative;
            overflow: hidden;
            margin-bottom: 24px;
            box-shadow: var(--fw-shadow);
        }

            .dashboard-header::before,
            .dashboard-header::after {
                content: '';
                position: absolute;
                border-radius: 50%;
                background: rgba(255,255,255,0.14);
                pointer-events: none;
            }

            .dashboard-header::before {
                width: 160px;
                height: 160px;
                right: 110px;
                bottom: -90px;
            }

            .dashboard-header::after {
                width: 240px;
                height: 240px;
                right: -80px;
                top: -95px;
            }

        .dashboard-title {
            font-size: 26px;
            line-height: 1.2;
            font-weight: 800;
            letter-spacing: -0.02em;
            margin-bottom: 7px;
            position: relative;
            z-index: 1;
        }

            .dashboard-title i {
                width: 42px;
                height: 42px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                margin-right: 10px;
                border-radius: 14px;
                background: rgba(255,255,255,0.18);
                backdrop-filter: blur(8px);
            }

        .dashboard-subtitle {
            font-size: 14px;
            opacity: 0.92;
            max-width: 720px;
            position: relative;
            z-index: 1;
        }

        .festival-card {
            border: 1px solid rgba(229, 231, 235, 0.85);
            border-radius: 24px;
            background: var(--fw-surface);
            box-shadow: var(--fw-shadow);
            overflow: hidden;
            backdrop-filter: blur(10px);
            margin-bottom: 24px;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            padding: 22px 24px 0;
        }

        .section-title {
            font-size: 18px;
            font-weight: 800;
            margin: 0;
            color: var(--fw-text);
        }

        .section-subtitle {
            margin: 4px 0 0;
            color: var(--fw-muted);
            font-size: 13px;
        }

        .card-body {
            background: transparent;
            padding: 22px 24px 24px;
            border-radius: 0;
        }

        .form-control,
        select.form-control,
        input.form-control,
        .dropdown-toggle.form-control {
            min-height: 44px;
            border-radius: 13px;
            border: 1px solid var(--fw-border);
            background-color: #fff;
            color: var(--fw-text);
            box-shadow: 0 1px 2px rgba(15, 23, 42, 0.03);
            transition: border-color .2s ease, box-shadow .2s ease, transform .2s ease;
        }

            .form-control:focus,
            .dropdown-toggle.form-control:focus {
                border-color: rgba(79, 70, 229, 0.65);
                box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.12);
                outline: none;
            }

        .dropdown-toggle.form-control {
            text-align: left;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .multi-dropdown-menu {
            max-height: 260px;
            overflow-y: auto;
            width: 100%;
            padding: 10px;
            border: 1px solid var(--fw-border);
            border-radius: 14px;
            box-shadow: 0 18px 34px rgba(15, 23, 42, 0.16);
        }

            .multi-dropdown-menu label {
                display: flex;
                align-items: center;
                gap: 9px;
                margin-bottom: 7px;
                cursor: pointer;
                color: #374151;
                font-weight: 600 !important;
            }

            .multi-dropdown-menu input[type="checkbox"] {
                width: 16px;
                height: 16px;
                accent-color: var(--fw-primary);
            }

        .btn-primary {
            min-height: 42px;
            padding: 9px 26px;
            border-radius: 999px;
            border: 0;
            font-weight: 800;
            letter-spacing: .01em;
            background: linear-gradient(135deg, var(--fw-primary), var(--fw-accent));
            box-shadow: 0 12px 24px rgba(79, 70, 229, 0.24);
            transition: transform .2s ease, box-shadow .2s ease;
        }

            .btn-primary:hover {
                transform: translateY(-1px);
                box-shadow: 0 16px 28px rgba(79, 70, 229, 0.30);
            }

        .table-responsive-modern {
            overflow-x: auto;
        }

        #table_festival {
            width: 100% !important;
            border-collapse: separate !important;
            border-spacing: 0;
            border: 1px solid var(--fw-border);
            border-radius: 18px;
            overflow: hidden;
            background: #fff;
        }

            .table.dataTable th,
            #table_festival thead th {
                background: #f8fafc !important;
                color: #334155;
                font-size: 12px;
                text-transform: uppercase;
                letter-spacing: .04em;
                border-bottom: 1px solid var(--fw-border) !important;
                white-space: nowrap;
            }

            .table.dataTable tr td,
            #table_festival tbody td {
                background: #fff;
                color: #334155;
                vertical-align: middle;
                border-color: #eef2f7;
            }

            #table_festival tbody tr:hover td {
                background: #f8fbff;
            }

        .dataTables_paginate {
            float: left !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 16px;
            float: left;
        }

        .buttons-excel,
        .buttons-html5 {
            color: #fff !important;
            box-shadow: none;
            background: linear-gradient(135deg, #10b981, #06b6d4) !important;
            border: 0 !important;
            border-radius: 999px !important;
            font-weight: 800;
            margin: 0 8px;
            padding: 7px 15px !important;
        }

        .festivalImg {
            transition: transform .25s ease, box-shadow .25s ease;
            border-radius: 12px;
        }

            .festivalImg:hover {
                transform: scale(1.06);
                box-shadow: 0 12px 24px rgba(0,0,0,0.20);
            }

        .modal-content {
            border: 0;
            border-radius: 22px;
            box-shadow: 0 24px 70px rgba(15, 23, 42, 0.30);
            overflow: hidden;
        }

        .modal-header {
            border-bottom: 1px solid var(--fw-border);
            background: #f8fafc;
        }

        .modal-title {
            font-weight: 800;
            color: var(--fw-text);
        }

        .modal-body {
            color: #374151;
        }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            margin: auto;
            width: 210px;
            height: 150px;
            z-index: 99999;
            text-align: center;
            background: rgba(255,255,255,.92);
            border: 1px solid var(--fw-border);
            border-radius: 24px;
            box-shadow: var(--fw-shadow);
            padding: 22px;
        }

        textarea {
            resize: none;
        }

        .dropzone {
            min-height: 44px;
        }

        @media (max-width: 767px) {
            .dashboard-header {
                padding: 22px;
                border-radius: 20px;
            }

            .dashboard-title {
                font-size: 22px;
            }

            .card-body, .section-header {
                padding-left: 18px;
                padding-right: 18px;
            }
        }

        .actions-row {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            padding-top: 8px;
            border-top: 1px dashed var(--resg-border);
            color: darkgray;
        }

        .btn-resg {
            min-height: 36px;
            border: 0;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 8px 14px;
            font-size: 12px;
            font-weight: 800;
            cursor: pointer;
        }

        .btn-resg-primary {
            color: #fff;
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
        }

        .btn-resg-green {
            color: #fff;
            background: var(--resg-green);
        }

        .btn-resg-red {
            color: #fff;
            background: var(--resg-red);
        }
    </style>

    <script>
        var fd = new FormData();

        window.onload = function () {
            var attachment = document.getElementById('festWish_attachment');
            if (attachment) {
                attachment.addEventListener('change', getFileName);
            }
        };

        function getFileName(event) {
            var file = event.target.files[0];
            if (!file) return;

            document.getElementById("festWish_file").value = file.name;

            fd = new FormData();
            fd.append("file", file);

            const xhr = new XMLHttpRequest();
            xhr.onload = function () {
                if (xhr.status >= 200 && xhr.status < 300) {
                    console.log("File uploaded successfully");
                }
            };

            xhr.open("POST", window.location.href, true);
            xhr.send(fd);
        }

        $(document).ready(function () {
            festival_bindGrid();
            festWish_bindEmployee();
            festWish_bindlocation();
            festWish_bindDepartment();
            festWish_bindDesignation();
        });
    </script>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/exceljs/4.3.0/exceljs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.5/FileSaver.min.js"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="festWish_file" style="display: none;" />

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="festival-page">
        <div class="dashboard-header">
            <div class="d-flex justify-content-between align-items-start mb-1">
                <div>
                    <div class="dashboard-title">
                        <i class="fas fa-gifts mr-2"></i>
                        Festival Wishes  
               
                    </div>
                    <div class="dashboard-subtitle">
                        Create, schedule, and manage festival wishes to engage and celebrate with your workforce.
               
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-12 px-0">
            <div class="festival-card">
                <div class="section-header">
                    <div>
                        <h3 class="section-title">Create festival wish</h3>
                        <p class="section-subtitle">Choose audience filters, set a display date, and upload the celebration image.</p>
                    </div>
                </div>
                <div class="card-body">

                    <div class="row mb-3">
                        <div class="col-md-3">
                            <label>Title :</label>
                            <select id="festWish_title" name="festWish_title" class="form-control">
                                <option value="">Select</option>
                                <option value="Christmas">Christmas</option>
                                <option value="Diwali">Diwali</option>
                                <option value="Dusshera">Dusshera</option>
                                <option value="Eid">Eid</option>
                                <option value="Fun Activity">Fun Activity</option>
                                <option value="Ganesh Chaturthy">Ganesh Chaturthy</option>
                                <option value="Gudi Padwa">Gudi Padwa</option>
                                <option value="Holi">Holi</option>
                                <option value="Independence Day">Independence Day</option>
                                <option value="IPL">IPL</option>
                                <option value="Thanks Giving">Thanks Giving</option>
                                <option value="Women's Day">Women's Day</option>
                            </select>
                        </div>

                        <!-- Date -->
                        <div class="col-md-3">
                            <label>Date :</label>
                            <input type="date" id="festWish_date" class="form-control" onkeydown="return false">
                        </div>

                        <!-- Location -->
                        <div class="col-md-3">
                            <label>Location :</label>
                            <div class="dropdown">
                                <button id="locationDropdownBtn"
                                    class="form-control dropdown-toggle text-left"
                                    type="button"
                                    data-bs-toggle="dropdown">
                                    Select Location
                           
                                </button>

                                <div class="dropdown-menu multi-dropdown-menu">
                                    <label>
                                        <input type="checkbox" id="select_all_location">
                                        <b>Select All</b>
                                    </label>

                                    <div id="locationList"></div>

                                </div>

                            </div>

                        </div>

                        <!-- Department -->
                        <div class="col-md-3">
                            <label>Department :</label>
                            <div class="dropdown">
                                <button id="departmentDropdownBtn" class="form-control dropdown-toggle text-left" type="button" data-bs-toggle="dropdown">Select Department</button>
                                <div class="dropdown-menu multi-dropdown-menu">
                                    <label>
                                        <input type="checkbox" id="select_all_department">
                                        <b>Select All</b>
                                    </label>
                                    <div id="departmentList"></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-3">
                            <label>Designation :</label>
                            <div class="dropdown">
                                <button id="designationDropdownBtn" class="form-control dropdown-toggle text-left" type="button" data-bs-toggle="dropdown">Select Designation</button>
                                <div class="dropdown-menu multi-dropdown-menu">
                                    <label>
                                        <input type="checkbox" id="select_all_designation"><b>Select All</b></label>
                                    <div id="designationList"></div>
                                </div>
                            </div>
                        </div>

                        <!-- User -->
                        <div class="col-md-3">
                            <label>User :</label>
                            <div class="dropdown">
                                <button id="userDropdownBtn" class="form-control dropdown-toggle text-left" type="button" data-bs-toggle="dropdown">Select Employee</button>
                                <div class="dropdown-menu multi-dropdown-menu">
                                    <label>
                                        <input type="checkbox" id="select_all_user"><b>Select All</b></label>
                                    <div id="userList"></div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-3">
                            <label>Gender :</label>
                            <select id="festWish_gender" name="festWish_gender" class="form-control">
                                <option value="">Select</option>
                                <option value="All">All</option>
                                <option value="Female">Female</option>
                                <option value="Male">Male</option>
                            </select>
                        </div>

                        <!-- Image -->
                        <div class="col-md-3">
                            <label>Image :</label>
                            <input type="file" id="festWish_attachment" class="form-control">
                        </div>
                    </div>
                    <div class="field col-12 actions-row">
                        <button type="button" class="btn-resg btn-resg-primary" id="festWish_btnsubmit" onclick="return festWish_SubmitData();"><i class="fas fa-paper-plane"></i>Submit</button>
                    </div>
                </div>
                <hr />
                <div class="section-header">
                    <div>
                        <h3 class="section-title">Festival wishes list</h3>
                        <p class="section-subtitle">Review uploaded wishes and manage existing records.</p>
                    </div>
                </div>
                <div class="card-body">
                    <div class="table-responsive-modern">
                        <table id="table_festival" class="table table-hover align-middle">
                            <thead>
                                <tr>
                                    <th>Action</th>
                                    <th>Sr. #</th>
                                    <th>Title</th>
                                    <th>Image</th>
                                    <th>Display Date</th>
                                    <th>Uploaded By</th>
                                    <th>Uploaded Date</th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <!-- Image Preview Modal -->
    <div class="modal fade" id="imagePreviewModal">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">

                <div class="modal-header">
                    <%-- <h5 class="modal-title">Image Preview</h5>--%>
                    <h5 class="modal-title" id="festivalTitle"></h5>
                    <%-- <button class="btn-close" data-bs-dismiss="modal"></button>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>--%>
                    <button type="button" class="close" data-bs-dismiss="modal" style="border: none; background: none; font-size: 24px;">
                        &times;
                   
                    </button>
                </div>

                <div class="modal-body text-center">
                    <img id="previewImage" style="width: 100%; max-height: 450px;">
                </div>

            </div>
        </div>
    </div>


    <div class="modal fade" id="festWish_deletePopUp">
        <div class="modal-dialog modal-l">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Delete Record</h4>
                    <button type="button" class="close" data-bs-dismiss="modal" style="border: none; background: none;">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p><b>Are you sure you want to delete this record?</b></p>
                </div>
                <div class="modal-footer justify-content-between">
                    <%--<button type="button" class="btn btn-default" data-dismiss="modal">No</button>--%>
                    <button type="button" class="close" data-bs-dismiss="modal" style="border: none; background: none;">No</button>
                    <button class="btn btn-primary" type="button" id="festWish_btnYes" onclick="return festWish_btndelete();">Yes</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>


<%--<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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


    <style>
        #loader {
            border: 16px solid #f3f3f3;
            border-radius: 50%;
            border-top: 16px solid #3498db;
            width: 120px;
            height: 120px;
            -webkit-animation: spin 2s linear infinite;
            animation: spin 2s linear infinite;
            margin-left: 250px;
            margin-top: 250px;
        }


        @-webkit-keyframes spin {
            0% {
                -webkit-transform: rotate(0deg);
            }

            100% {
                -webkit-transform: rotate(360deg);
            }
        }

        @keyframes spin {
            0% {
                transform: rotate(0deg);
            }

            100% {
                transform: rotate(360deg);
            }
        }

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

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: normal !important;
            border: none !important;
        }

        .dataTables_paginate {
            float: left !important;
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
            background: none;
        }

        .modal-header .btn-close {
            transform: scale(1.3);

            .btn-close {
                font-size: 20px;
                opacity: 1;
            }
        }

        .multi-dropdown-menu {
            max-height: 220px;
            overflow-y: auto;
            width: 100%;
            padding: 10px;
        }

            .multi-dropdown-menu label {
                display: flex;
                align-items: center;
                gap: 8px;
                margin-bottom: 6px;
                cursor: pointer;
            }

            .multi-dropdown-menu input[type="checkbox"] {
                transform: scale(1.1);
            }
    </style>

    <script>
        var fd = new FormData();

        window.onload = function () {
            document.getElementById('festWish_attachment').addEventListener('change', getFileName);
        };

        function getFileName(event) {

            var file = event.target.files[0]; // get single file

            if (!file) return;

            document.getElementById("festWish_file").value = file.name;

            fd = new FormData(); // reset formdata
            fd.append("file", file);

            const xhr = new XMLHttpRequest();

            xhr.onload = function () {
                if (xhr.status >= 200 && xhr.status < 300) {
                    console.log("File uploaded successfully");
                }
            };

            var url = window.location.href;

            xhr.open("POST", url, true);
            xhr.send(fd);
        }


        $(document).ready(function () {

            festival_bindGrid();

            festWish_bindEmployee();
            festWish_bindlocation();
            festWish_bindDepartment();
            festWish_bindDesignation();
        });

    </script>

    <style>
        .card-body {
            background: #ffff;
            padding: 20px;
            border-radius: 8px;
        }

        label {
            font-size: 14px;
            margin-bottom: 4px;
            color: #6c757d;
        }

        textarea {
            resize: none;
        }

        .form-label {
            font-size: 14px;
            margin-bottom: 4px;
        }

        .btn-primary {
            padding: 6px 20px;
            font-weight: 600;
        }

        .dropzone {
            min-height: 40px;
        }

        .festivalImg {
            transition: 0.3s;
        }

            .festivalImg:hover {
                transform: scale(1.1);
                box-shadow: 0px 3px 10px rgba(0,0,0,0.3);
            }
    </style>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/exceljs/4.3.0/exceljs.min.js"></script>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.5/FileSaver.min.js"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="festWish_file" style="display: none;" />

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="dashboard-header">
        <div class="d-flex justify-content-between align-items-start mb-1">
            <div>
                <div class="dashboard-title">
                   <i class="fas fa-gifts mr-2"></i>
                    Festival Wishesh  
            
                </div>

                <div class="dashboard-subtitle">
                        Create, schedule, and manage festival wishes to engage and celebrate with your workforce.
                </div>
            </div>
        </div>
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">

                <div class="row mb-3">
                    <div class="col-md-3">
                        <label>Title :</label>
                        <select id="festWish_title" name="festWish_title" class="form-control">
                            <option value="">Select</option>
                            <option value="Christmas">Christmas</option>
                            <option value="Diwali">Diwali</option>
                            <option value="Dusshera">Dusshera</option>
                            <option value="Fun Activity">Fun Activity</option>
                            <option value="Ganesh Chaturthy">Ganesh Chaturthy</option>
                            <option value="Gudi Padwa">Gudi Padwa</option>
                            <option value="Holi">Holi</option>
                            <option value="Independence Day">Independence Day</option>
                            <option value="IPL">IPL</option>
                            <option value="Thanks Giving">Thanks Giving</option>
                            <option value="Women's Day">Women's Day</option>
                        </select>
                    </div>

                    <!-- Date -->
                    <div class="col-md-3">
                        <label>Date :</label>
                        <input type="date" id="festWish_date" class="form-control" onkeydown="return false">
                    </div>

                    <!-- Location -->
                    <div class="col-md-3">
                        <label>Location :</label>
                        <div class="dropdown">
                            <button id="locationDropdownBtn"
                                class="form-control dropdown-toggle text-left"
                                type="button"
                                data-toggle="dropdown">
                                Select Location
                            </button>

                            <div class="dropdown-menu multi-dropdown-menu">
                                <label>
                                    <input type="checkbox" id="select_all_location">
                                    <b>Select All</b>
                                </label>

                                <div id="locationList"></div>

                            </div>

                        </div>

                    </div>

                    <!-- Department -->
                    <div class="col-md-3">
                        <label>Department :</label>
                        <div class="dropdown">
                            <button id="departmentDropdownBtn" class="form-control dropdown-toggle text-left" type="button" data-toggle="dropdown">Select Department</button>
                            <div class="dropdown-menu multi-dropdown-menu">
                                <label>
                                    <input type="checkbox" id="select_all_department">
                                    <b>Select All</b>
                                </label>
                                <div id="departmentList"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-3">
                        <label>Designation :</label>
                        <div class="dropdown">
                            <button id="designationDropdownBtn" class="form-control dropdown-toggle text-left" type="button" data-toggle="dropdown">Select Designation</button>
                            <div class="dropdown-menu multi-dropdown-menu">
                                <label>
                                    <input type="checkbox" id="select_all_designation"><b>Select All</b></label>
                                <div id="designationList"></div>
                            </div>
                        </div>
                    </div>

                    <!-- User -->
                    <div class="col-md-3">
                        <label>User :</label>
                        <div class="dropdown">
                            <button id="userDropdownBtn" class="form-control dropdown-toggle text-left" type="button" data-toggle="dropdown">Select Employee</button>
                            <div class="dropdown-menu multi-dropdown-menu">
                                <label>
                                    <input type="checkbox" id="select_all_user"><b>Select All</b></label>
                                <div id="userList"></div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-3">
                        <label>Gender :</label>
                        <select id="festWish_gender" name="festWish_gender" class="form-control">
                            <option value="">Select</option>
                            <option value="All">All</option>
                            <option value="Female">Female</option>
                            <option value="Male">Male</option>
                        </select>
                    </div>

                    <!-- Image -->
                    <div class="col-md-3">
                        <label>Image :</label>
                        <input type="file" id="festWish_attachment" class="form-control">
                    </div>
                </div>

                <div class="text-center mt-4">
                    <button type="button" id="festWish_btnsubmit" class="btn btn-primary" onclick="return festWish_SubmitData();">Submit</button>
                </div>
            </div>

            <div class="card-body">
                <table id="table_festival" class="table table-bordered table-striped">
                    <thead>
                        <tr>
                            <th>Action</th>
                            <th>Sr. #</th>
                            <th>Title</th>
                            <th>Image</th>
                            <th>Display Date</th>
                            <th>Uploaded By</th>
                            <th>Uploaded Date</th>
                        </tr>
                    </thead>
                </table>
            </div>
        </div>
    </div>


    <!-- Image Preview Modal -->
    <div class="modal fade" id="imagePreviewModal">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">

                <div class="modal-header">
                
                    <h5 class="modal-title" id="festivalTitle"></h5>
                  
                    <button type="button" class="close" data-bs-dismiss="modal" style="border: none; background: none; font-size: 24px;">
                        &times;
                    </button>
                </div>

                <div class="modal-body text-center">
                    <img id="previewImage" style="width: 100%; max-height: 450px;">
                </div>

            </div>
        </div>
    </div>


    <div class="modal fade" id="festWish_deletePopUp">
        <div class="modal-dialog modal-l">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Delete Record</h4>
                    <button type="button" class="close" data-bs-dismiss="modal" style="border: none; background: none;">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p><b>Are you sure you want to delete this record?</b></p>
                </div>
                <div class="modal-footer justify-content-between">
                  
                    <button type="button" class="close" data-bs-dismiss="modal" style="border: none; background: none;">No</button>
                    <button class="btn btn-primary" type="button" id="festWish_btnYes" onclick="return festWish_btndelete();">Yes</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>--%>
