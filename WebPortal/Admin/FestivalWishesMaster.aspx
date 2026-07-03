<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="FestivalWishesMaster.aspx.cs" Inherits="WebPortal.Admin.FestivalWishesMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../plugins/sweetalert2-theme-bootstrap-4/bootstrap-4.min.css" />

    <style>
        :root {
            --fw-ink: #1f2937;
            --fw-muted: #64748b;
            --fw-line: #e5e7eb;
            --fw-saffron: #f59e0b;
            --fw-rose: #e11d48;
            --fw-emerald: #047857;
            --fw-shadow: 0 16px 38px rgba(31, 41, 55, 0.12);
        }

        .festival-page {
            position: relative;
            isolation: isolate;
            min-height: calc(100vh - 150px);
            background: linear-gradient(90deg, rgba(245, 158, 11, 0.10) 1px, transparent 1px), linear-gradient(180deg, rgba(225, 29, 72, 0.08) 1px, transparent 1px), linear-gradient(180deg, #fff7ed 0%, #ffffff 45%, #ecfdf5 100%);
            background-size: 34px 34px, 34px 34px, auto;
            color: var(--fw-ink);
        }

            .festival-page::before {
                content: '';
                position: absolute;
                inset: 0;
                z-index: -1;
                opacity: .55;
                pointer-events: none;
                background-image: linear-gradient(135deg, transparent 0 44%, rgba(245, 158, 11, .22) 44% 50%, transparent 50% 100%), linear-gradient(45deg, transparent 0 46%, rgba(4, 120, 87, .14) 46% 52%, transparent 52% 100%);
                background-size: 72px 72px, 96px 96px;
            }

        .festival-shell {
            position: relative;
            z-index: 1;
        }

        .festival-page label:not(.form-check-label):not(.custom-file-label) {
            display: block;
            margin-bottom: 7px;
            border: 0 !important;
            color: #334155;
            font-size: 13px;
            font-weight: 700 !important;
        }

        .sec-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            gap: 18px;
            padding: 22px 26px;
            margin-bottom: 20px;
            border: 1px solid rgba(255, 255, 255, .45);
            border-radius: 8px;
            color: #fff;
            background: linear-gradient(135deg, rgba(124, 58, 237, .98) 0%, rgba(236, 72, 153, .95) 48%, rgba(245, 158, 11, .95) 100%);
            box-shadow: var(--fw-shadow);
        }

            .sec-hero::before {
                content: '';
                position: absolute;
                inset: 0;
                opacity: .22;
                background: linear-gradient(135deg, rgba(255, 255, 255, .70) 0 8px, transparent 8px 34px), linear-gradient(45deg, rgba(255, 255, 255, .36) 0 7px, transparent 7px 30px);
                background-size: 46px 46px, 58px 58px;
                pointer-events: none;
            }
        .sec-hero-icon,
        .section-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            flex: 0 0 auto;
        }

        .sec-hero-icon {
            position: relative;
            z-index: 1;
            width: 56px;
            height: 56px;
            border: 2px solid rgba(255, 255, 255, .78);
            border-radius: 8px;
            background: rgba(255, 255, 255, .14);
            transform-origin: center bottom;
            will-change: transform;
            animation: bdPartyBounce 1.6s cubic-bezier(.34, 1.56, .64, 1) infinite !important;
        }

            .sec-hero-icon i {
                font-size: 30px;
                color: #fff;
            }

        @keyframes bdPartyBounce {
            0%, 100% {
                transform: translateY(0) scale(1) rotate(0deg);
            }

            22% {
                transform: translateY(-10px) scale(1.08) rotate(-5deg);
            }

            42% {
                transform: translateY(0) scale(.98) rotate(4deg);
            }

            62% {
                transform: translateY(-5px) scale(1.04) rotate(-2deg);
            }

            78% {
                transform: translateY(0) scale(1) rotate(0deg);
            }
        }

        .sec-hero-copy {
            position: relative;
            z-index: 1;
        }

        .sec-kicker {
            margin: 0 0 4px;
            color: rgba(255, 255, 255, .84);
            font-size: 12px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0;
        }

        .sec-title {
            margin: 0;
            color: #fff;
            font-size: 26px;
            font-weight: 800;
            letter-spacing: 0;
        }

        .sec-subtitle {
            max-width: 760px;
            margin: 7px 0 0;
            color: rgba(255, 255, 255, .92);
            font-size: 14px;
            line-height: 1.55;
        }

        .festival-card {
            overflow: hidden;
            margin-bottom: 22px;
            border: 1px solid rgba(226, 232, 240, .95);
            border-radius: 8px;
            background: rgba(255, 255, 255, .96);
            box-shadow: var(--fw-shadow);
        }

        .section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            padding: 18px 20px;
            border-bottom: 1px solid var(--fw-line);
            background: linear-gradient(90deg, rgba(255, 247, 237, .92), rgba(236, 253, 245, .74));
        }

        .section-title-wrap {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .section-icon {
            width: 38px;
            height: 38px;
            border-radius: 8px;
            color: #fff;
            background:linear-gradient(135deg, rgba(124, 58, 237, .98) 0%, rgba(236, 72, 153, .95) 48%, rgba(245, 158, 11, .95) 100%);
            box-shadow: 0 8px 18px rgba(225, 29, 72, .20);
        }

        .section-title {
            margin: 0;
            color: var(--fw-ink);
            font-size: 18px;
            font-weight: 800;
            letter-spacing: 0;
        }

        .section-subtitle {
            margin: 4px 0 0;
            color: var(--fw-muted);
            font-size: 13px;
        }

        .festival-card .card-body {
            padding: 20px;
            background: transparent;
            border-radius: 0;
        }

        .festival-divider {
            margin: 0;
            border-top: 1px solid var(--fw-line);
        }

        .festival-page .form-control,
        .festival-page select.form-control,
        .festival-page input.form-control,
        .festival-page .dropdown-toggle.form-control {
            min-height: 42px;
            border: 1px solid #dbe3ef;
            border-radius: 8px;
            background-color: #fff;
            color: var(--fw-ink);
            box-shadow: 0 1px 2px rgba(15, 23, 42, .04);
            transition: border-color .18s ease, box-shadow .18s ease;
        }

            .festival-page .form-control:focus,
            .festival-page .dropdown-toggle.form-control:focus {
                border-color: var(--fw-saffron);
                box-shadow: 0 0 0 3px rgba(245, 158, 11, .18);
                outline: 0;
            }

        .festival-page .dropdown-toggle.form-control {
            display: flex;
            align-items: center;
            justify-content: space-between;
            text-align: left;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .multi-dropdown-menu {
            width: 100%;
            min-width: 100%;
            max-height: 260px;
            overflow-y: auto;
            padding: 10px;
            border: 1px solid #dbe3ef;
            border-radius: 8px;
            box-shadow: 0 18px 34px rgba(15, 23, 42, .16);
        }

            .multi-dropdown-menu label {
                display: flex !important;
                align-items: center;
                gap: 9px;
                margin-bottom: 8px !important;
                color: #334155 !important;
                cursor: pointer;
                font-size: 13px !important;
                font-weight: 600 !important;
            }

                .multi-dropdown-menu label:last-child {
                    margin-bottom: 0 !important;
                }

            .multi-dropdown-menu input[type="checkbox"] {
                width: 16px;
                height: 16px;
                accent-color: var(--fw-rose);
            }

        .actions-row {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            padding-top: 14px;
            border-top: 1px dashed #d9e1ec;
        }

        .festival-submit-btn {
            min-height: 40px;
            border: 0;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 9px 18px;
            color: #fff;
            font-size: 13px;
            font-weight: 800;
            cursor: pointer;
            background: linear-gradient(135deg, rgba(124, 58, 237, .98) 0%, rgba(236, 72, 153, .95) 48%, rgba(245, 158, 11, .95) 100%);
            box-shadow: 0 12px 22px rgba(190, 18, 60, .20);
            transition: transform .18s ease, box-shadow .18s ease;
        }

            .festival-submit-btn:hover,
            .festival-submit-btn:focus {
                color: #fff;
                transform: translateY(-1px);
                box-shadow: 0 16px 26px rgba(190, 18, 60, .25);
                outline: 0;
            }

        .table-responsive-modern {
            overflow-x: auto;
        }

        #table_festival {
            width: 100% !important;
            border-collapse: separate !important;
            border-spacing: 0;
            border: 1px solid var(--fw-line);
            border-radius: 8px;
            overflow: hidden;
            background: #fff;
        }

            #table_festival thead th,
            .table.dataTable th {
                background: #fff7ed !important;
                color: #7c2d12;
                border-bottom: 1px solid #fed7aa !important;
                font-size: 12px;
                font-weight: 800;
                text-transform: uppercase;
                letter-spacing: 0;
                white-space: nowrap;
            }

            #table_festival tbody td,
            .table.dataTable tr td {
                vertical-align: middle;
                border-color: #eef2f7;
                background: #fff;
                color: #334155;
                font-size: 13px;
            }

            #table_festival tbody tr:hover td {
                background: #fffbeb;
            }

        .dataTables_wrapper .dataTables_length select,
        .dataTables_wrapper .dataTables_filter input {
            border: 1px solid #dbe3ef;
            border-radius: 8px;
            padding: 5px 8px;
        }

        .dataTables_paginate {
            float: left !important;
        }

        .festivalImg {
            width: 62px;
            height: 62px;
            border: 2px solid #fff7ed;
            border-radius: 8px;
            object-fit: cover;
            cursor: pointer;
            box-shadow: 0 8px 16px rgba(15, 23, 42, .12);
            transition: transform .18s ease, box-shadow .18s ease;
        }

            .festivalImg:hover {
                transform: scale(1.05);
                box-shadow: 0 12px 22px rgba(15, 23, 42, .18);
            }

        .festival-delete-action {
            width: 34px;
            height: 34px;
            border: 1px solid #fecdd3;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: #be123c;
            background: #fff1f2;
            cursor: pointer;
            transition: transform .18s ease, background .18s ease, color .18s ease;
        }

            .festival-delete-action:hover,
            .festival-delete-action:focus {
                color: #fff;
                background: #be123c;
                transform: translateY(-1px);
                outline: 0;
            }

        .modal-content {
            overflow: hidden;
            border: 0;
            border-radius: 8px;
            box-shadow: 0 24px 70px rgba(15, 23, 42, .30);
        }

        .modal-header {
            border-bottom: 1px solid var(--fw-line);
            background: linear-gradient(90deg, #fff7ed, #ecfdf5);
        }

        .modal-title {
            color: var(--fw-ink);
            font-weight: 800;
        }

        .festival-preview-image {
            width: 100%;
            max-height: 520px;
            border-radius: 8px;
            object-fit: contain;
        }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 99999;
            width: 210px;
            height: 150px;
            margin: auto;
            padding: 22px;
            border: 1px solid var(--fw-line);
            border-radius: 8px;
            background: rgba(255, 255, 255, .94);
            box-shadow: var(--fw-shadow);
            text-align: center;
        }

            .loading img {
                max-width: 64px;
                margin-bottom: 12px;
            }

            .loading .loading-text {
                color: #334155;
                font-size: 12px;
                font-weight: 800;
            }

        @media (max-width: 767px) {
            .festival-page {
                padding: 12px 0 28px;
            }

            .sec-hero {
                align-items: flex-start;
                padding: 18px;
            }

            .sec-title {
                font-size: 22px;
            }

            .festival-card .card-body,
            .section-header {
                padding-left: 16px;
                padding-right: 16px;
            }

            .actions-row {
                justify-content: stretch;
            }

            .festival-submit-btn {
                width: 100%;
            }
        }
    </style>

    <script src="../plugins/sweetalert2/sweetalert2.all.min.js"></script>
    <script>
        var festivalWishUploadData = new FormData();

        function showFestivalUploadError(message) {
            if (window.Swal) {
                Swal.fire({ icon: 'error', title: 'Upload Error', text: message });
                return;
            }

            alert(message);
        }

        function uploadFestivalWishFile(event) {
            var file = event.target.files[0];
            if (!file) {
                return;
            }

            document.getElementById('festWish_file').value = file.name;

            festivalWishUploadData = new FormData();
            festivalWishUploadData.append('file', file);

            var xhr = new XMLHttpRequest();
            xhr.onload = function () {
                if (xhr.status < 200 || xhr.status >= 300) {
                    showFestivalUploadError('Image could not be uploaded. Please try again.');
                }
            };
            xhr.onerror = function () {
                showFestivalUploadError('Image could not be uploaded. Please try again.');
            };

            xhr.open('POST', window.location.href, true);
            xhr.send(festivalWishUploadData);
        }

        window.getFileName = uploadFestivalWishFile;

        $(document).ready(function () {
            $('#festWish_attachment').on('change', uploadFestivalWishFile);
            festival_bindGrid();
            festWish_bindEmployee();
            festWish_bindlocation();
            festWish_bindDepartment();
            festWish_bindDesignation();
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="festWish_file" type="hidden" />

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" alt="Loading" />
        <div class="loading-text">One moment, please...</div>
    </div>

    <div class="festival-page">
        <div class="festival-shell">
            <div class="sec-hero">
                <span class="sec-hero-icon" aria-hidden="true">
                    <i class="fas fa-gifts"></i>
                </span>
                <div class="sec-hero-copy">
                    <%--   <p class="sec-kicker">Admin celebration center</p>--%>
                    <h1 class="sec-title">Festival Wishes</h1>
                    <p class="sec-subtitle">Create festive greetings, choose the right audience, and keep every celebration image ready for its display date.</p>
                </div>
            </div>

            <div class="col-lg-12 px-0">
                <div class="festival-card">
                    <div class="section-header">
                        <div class="section-title-wrap">
                            <span class="section-icon" aria-hidden="true"><i class="fas fa-calendar-day"></i></span>
                            <div>
                                <h3 class="section-title">Create Festival Wish</h3>
                                <p class="section-subtitle">Set the occasion, audience filters, display date, and celebration image.</p>
                            </div>
                        </div>
                    </div>

                    <div class="card-body">
                        <div class="row mb-3">
                            <div class="col-md-3">
                                <label for="festWish_title">Title :</label>
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

                            <div class="col-md-3">
                                <label for="festWish_date">Date :</label>
                                <input type="date" id="festWish_date" class="form-control" onkeydown="return false" />
                            </div>

                            <div class="col-md-3">
                                <label for="locationDropdownBtn">Location :</label>
                                <div class="dropdown">
                                    <button id="locationDropdownBtn" class="form-control dropdown-toggle text-left" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Select Location</button>
                                    <div class="dropdown-menu multi-dropdown-menu">
                                        <label>
                                            <input type="checkbox" id="select_all_location" />
                                            <b>Select All</b>
                                        </label>
                                        <div id="locationList"></div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-3">
                                <label for="departmentDropdownBtn">Department :</label>
                                <div class="dropdown">
                                    <button id="departmentDropdownBtn" class="form-control dropdown-toggle text-left" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Select Department</button>
                                    <div class="dropdown-menu multi-dropdown-menu">
                                        <label>
                                            <input type="checkbox" id="select_all_department" />
                                            <b>Select All</b>
                                        </label>
                                        <div id="departmentList"></div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-3">
                                <label for="designationDropdownBtn">Designation :</label>
                                <div class="dropdown">
                                    <button id="designationDropdownBtn" class="form-control dropdown-toggle text-left" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Select Designation</button>
                                    <div class="dropdown-menu multi-dropdown-menu">
                                        <label>
                                            <input type="checkbox" id="select_all_designation" />
                                            <b>Select All</b>
                                        </label>
                                        <div id="designationList"></div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-3">
                                <label for="userDropdownBtn">User :</label>
                                <div class="dropdown">
                                    <button id="userDropdownBtn" class="form-control dropdown-toggle text-left" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Select Employee</button>
                                    <div class="dropdown-menu multi-dropdown-menu">
                                        <label>
                                            <input type="checkbox" id="select_all_user" />
                                            <b>Select All</b>
                                        </label>
                                        <div id="userList"></div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-3">
                                <label for="festWish_gender">Gender :</label>
                                <select id="festWish_gender" name="festWish_gender" class="form-control">
                                    <option value="">Select</option>
                                    <option value="All">All</option>
                                    <option value="Female">Female</option>
                                    <option value="Male">Male</option>
                                </select>
                            </div>

                            <div class="col-md-3">
                                <label for="festWish_attachment">Image :</label>
                                <input type="file" id="festWish_attachment" class="form-control" />
                            </div>
                        </div>

                        <div class="actions-row">
                            <button type="button" class="festival-submit-btn" id="festWish_btnsubmit" onclick="return festWish_SubmitData();">
                                <i class="fas fa-paper-plane" aria-hidden="true"></i>
                                <span>Submit</span>
                            </button>
                        </div>
                    </div>

                    <hr class="festival-divider" />

                    <div class="section-header">
                        <div class="section-title-wrap">
                            <span class="section-icon" aria-hidden="true"><i class="fas fa-images"></i></span>
                            <div>
                                <h3 class="section-title">Festival Wishes List</h3>
                                <p class="section-subtitle">Review uploaded wishes and remove records that are no longer needed.</p>
                            </div>
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
    </div>

    <div class="modal fade" id="imagePreviewModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="festivalTitle">Festival Preview</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body text-center">
                    <img id="previewImage" class="festival-preview-image" alt="Festival preview" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>




