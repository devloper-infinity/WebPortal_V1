<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ViewEmployee.aspx.cs" Inherits="WebPortal.Admin.ViewEmployee" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        body {
            background: #f3f6fb;
        }

        .view-employee-page {
            width: 100%;
        }

        .dashboard-header {
            min-height: 94px;
            display: flex;
            align-items: center;
            position: relative;
            overflow: hidden;
            margin-bottom: 20px;
            padding: 20px 28px;
            color: #fff;
            background: linear-gradient(105deg, #244edb 0%, #2879ed 61%, #37c3d3 100%);
            border: 1px solid rgba(255,255,255,.22);
            border-radius: 22px;
            box-shadow: 0 14px 30px rgba(31,78,166,.18);
        }

            .dashboard-header::before,
            .dashboard-header::after {
                content: "";
                position: absolute;
                border-radius: 50%;
                pointer-events: none;
            }

            .dashboard-header::before {
                width: 240px;
                height: 240px;
                right: 72px;
                top: -145px;
                background: rgba(255,255,255,.11);
            }

            .dashboard-header::after {
                width: 185px;
                height: 185px;
                right: -18px;
                bottom: -120px;
                background: rgba(255,255,255,.10);
            }

        .dashboard-header-content {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            gap: 18px;
            min-width: 0;
        }

        .dashboard-icon {
            width: 54px;
            height: 54px;
            flex: 0 0 54px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            color: #fff;
            background: rgba(255,255,255,.14);
            border: 1px solid rgba(255,255,255,.28);
            border-radius: 16px;
            box-shadow: inset 0 1px 0 rgba(255,255,255,.16);
        }

        .dashboard-title {
            margin: 0 0 5px;
            font-size: 21px;
            line-height: 1.25;
            font-weight: 700;
            letter-spacing: -.2px;
        }

        .dashboard-subtitle {
            margin: 0;
            max-width: 760px;
            color: rgba(255,255,255,.88);
            font-size: 12px;
            line-height: 1.55;
            font-weight: 500;
        }

        .view-employee-section {
            padding: 0 !important;
        }

        .view-employee-card {
            overflow: hidden;
            border: 1px solid #dbe4f0;
            border-radius: 16px;
            background: #fff;
            box-shadow: 0 8px 24px rgba(31,47,75,.07);
        }

            .view-employee-card .card-body {
                padding: 18px;
                overflow-x: auto;
                scrollbar-color: #9aa9bd #edf2f7;
                scrollbar-width: thin;
            }

            .view-employee-card .card-title {
                display: none;
            }

        #viewemployee {
            width: 100% !important;
            min-width: 1780px;
            margin: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0;
        }

        #viewemployee_wrapper .dataTables_scrollHead table.dataTable thead th {
            padding: 12px 11px !important;
            color: #193354;
            background: #eaf1f8 !important;
            border-top: 0 !important;
            border-bottom: 1px solid #d5e0ec !important;
            font-size: 11px;
            font-weight: 700;
            white-space: nowrap;
            vertical-align: middle;
        }

        #viewemployee_wrapper .dataTables_scrollHead table.dataTable thead tr:first-child th:first-child {
            border-top-left-radius: 10px;
        }

        #viewemployee_wrapper .dataTables_scrollHead table.dataTable thead tr:first-child th:last-child {
            border-top-right-radius: 10px;
        }

        #viewemployee_wrapper .dataTables_scrollBody #viewemployee thead {
            visibility: hidden;
        }

            #viewemployee_wrapper .dataTables_scrollBody #viewemployee thead tr,
            #viewemployee_wrapper .dataTables_scrollBody #viewemployee thead th {
                height: 0 !important;
                min-height: 0 !important;
                padding-top: 0 !important;
                padding-bottom: 0 !important;
                border: 0 !important;
                line-height: 0 !important;
                font-size: 0 !important;
            }

                #viewemployee_wrapper .dataTables_scrollBody #viewemployee thead th > * {
                    height: 0 !important;
                    overflow: hidden !important;
                }

        #viewemployee.dataTable tbody td {
            padding: 11px !important;
            color: #334b68;
            background: #fff;
            border-top: 0;
            border-bottom: 1px solid #edf1f6;
            font-size: 11px;
            vertical-align: middle;
            white-space: nowrap;
        }

        #viewemployee.dataTable tbody tr:hover td {
            background: #f5f9ff;
        }

        #viewemployee_wrapper .dataTables_scrollHead .column_search {
            width: 100%;
            min-width: 92px;
            height: 31px;
            padding: 5px 9px;
            color: #314b68;
            background: #fff;
            border: 1px solid #cbd8e6;
            border-radius: 7px;
            outline: none;
            font-size: 10px;
            font-weight: 500;
        }

            #viewemployee_wrapper .dataTables_scrollHead .column_search:focus {
                border-color: #2c78e8;
                box-shadow: 0 0 0 3px rgba(44,120,232,.1);
            }

        #viewemployee tbody .btn-group > .btn-group > div[data-toggle="dropdown"] {
            width: 30px;
            height: 30px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            background: #eaf3ff;
            border: 1px solid #cfe2fa;
            border-radius: 8px;
            transition: background .2s ease, transform .2s ease;
        }

            #viewemployee tbody .btn-group > .btn-group > div[data-toggle="dropdown"]:hover {
                background: #dcecff;
                transform: translateY(-1px);
            }

        #viewemployee .dropdown-menu {
            padding: 7px;
            border: 1px solid #dce5ef;
            border-radius: 10px;
            box-shadow: 0 12px 28px rgba(28,48,75,.14);
        }

        #viewemployee .dropdown-item {
            padding: 8px 10px;
            border-radius: 7px;
            color: #344c68;
            font-size: 11px;
        }

            #viewemployee .dropdown-item:hover {
                color: #165ebd;
                background: #edf5ff;
            }

        #viewemployee_wrapper {
            min-width: 100%;
            display: grid;
            grid-template-columns: max-content max-content minmax(230px, 1fr);
            align-items: center;
            column-gap: 10px;
        }

            #viewemployee_wrapper .row {
                align-items: center;
                row-gap: 10px;
                margin-left: 0;
                margin-right: 0;
            }

            #viewemployee_wrapper > .dataTables_paginate {
                grid-column: 1;
            }

            #viewemployee_wrapper > .dt-buttons {
                grid-column: 2;
            }

            #viewemployee_wrapper > .dataTables_filter {
                grid-column: 3;
                justify-self: end;
                display: inline-flex;
                align-items: center;
                float: none !important;
                width: auto;
                margin: 0 0 14px;
                white-space: nowrap;
            }

            #viewemployee_wrapper > .dataTables_scroll,
            #viewemployee_wrapper > table.dataTable {
                grid-column: 1 / -1;
                width: 100% !important;
                min-width: 0;
            }

            #viewemployee_wrapper > .dataTables_info {
                grid-column: 1 / -1;
            }

            #viewemployee_wrapper .dataTables_length,
            #viewemployee_wrapper .dataTables_filter,
            #viewemployee_wrapper .dataTables_info {
                color: #52677f;
                font-size: 11px;
            }

                #viewemployee_wrapper .dataTables_filter input,
                #viewemployee_wrapper .dataTables_length select {
                    height: 36px;
                    color: #283f5b;
                    background: #fff;
                    border: 1px solid #cbd7e5;
                    border-radius: 9px;
                    outline: none;
                }

                #viewemployee_wrapper .dataTables_filter input {
                    min-width: 210px;
                    padding: 6px 11px;
                }

                    #viewemployee_wrapper .dataTables_filter input:focus,
                    #viewemployee_wrapper .dataTables_length select:focus {
                        border-color: #2b73e8;
                        box-shadow: 0 0 0 3px rgba(43,115,232,.12);
                    }

        div.dt-buttons {
            position: static;
            float: none;
            display: inline-flex !important;
            align-items: center;
            width: auto;
            margin: 0 0 14px;
            padding-left: 0;
            vertical-align: middle;
        }

        .buttons-excel {
            min-height: 36px;
            margin: 0 !important;
            padding: 7px 14px !important;
            color: #fff !important;
            background: linear-gradient(105deg, #176e91, #119b94) !important;
            border: 0 !important;
            border-radius: 9px !important;
            box-shadow: 0 6px 14px rgba(17,126,132,.18) !important;
            font-size: 11px !important;
            font-weight: 700 !important;
        }

        .dataTables_paginate {
            float: none !important;
            display: inline-flex !important;
            align-items: center;
            width: auto;
            margin: 0 0 14px !important;
            vertical-align: middle;
        }

        #viewemployee_wrapper .dataTables_paginate .pagination {
            display: inline-flex;
            align-items: center;
            margin: 0;
        }

        #viewemployee_wrapper .pagination .page-link {
            margin: 0 2px;
            color: #31506f;
            border: 1px solid #d5dfeb;
            border-radius: 8px;
            font-size: 11px;
        }

        #viewemployee_wrapper .pagination .active .page-link {
            color: #fff;
            background: #2474e5;
            border-color: #2474e5;
        }

        .loading {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            width: 176px;
            min-height: 150px;
            z-index: 99999;
            padding: 18px;
            color: #243b58;
            text-align: center;
            background: rgba(255,255,255,.96);
            border: 1px solid #dce5ef;
            border-radius: 18px;
            box-shadow: 0 18px 45px rgba(25,43,68,.2);
            transform: translate(-50%,-50%);
        }

            .loading img {
                max-width: 90px;
                height: auto;
            }

        #viewemp_uploaddocs .modal-content,
        #empdocs_waitingpanel .modal-content {
            overflow: hidden;
            border: 0;
            border-radius: 15px;
            box-shadow: 0 20px 55px rgba(26,43,65,.22);
        }

        #viewemp_uploaddocs .modal-header {
            color: #17324f;
            background: #f1f6fb;
            border-bottom-color: #dce5ef;
        }

        #viewemp_uploaddocs input[type="file"] {
            width: 100% !important;
            min-width: 230px;
        }

        @media (max-width: 991.98px) {
            .view-employee-page {
                padding: 14px 6px 22px;
            }

            .dashboard-header {
                min-height: 88px;
                padding: 18px 20px;
                border-radius: 18px;
            }

            .view-employee-card .card-body {
                padding: 14px;
            }
        }

        @media (max-width: 575.98px) {
            .dashboard-header {
                padding: 16px;
            }

            .dashboard-header-content {
                gap: 12px;
            }

            .dashboard-icon {
                width: 46px;
                height: 46px;
                flex-basis: 46px;
                border-radius: 13px;
                font-size: 19px;
            }

            .dashboard-title {
                font-size: 17px;
            }

            .dashboard-subtitle {
                font-size: 10px;
            }

            .view-employee-card .card-body {
                padding: 10px;
            }

            #viewemployee_wrapper .dataTables_filter {
                text-align: left;
            }

                #viewemployee_wrapper .dataTables_filter input {
                    width: calc(100% - 52px);
                    min-width: 0;
                }

            #viewemp_uploaddocs .modal-body table,
            #viewemp_uploaddocs .modal-body tbody,
            #viewemp_uploaddocs .modal-body tr,
            #viewemp_uploaddocs .modal-body td {
                display: block;
                width: 100%;
            }
        }
    </style>

    <style>
        #viewemployee thead th::before,
        #viewemployee thead th::after,
        #viewemployee thead th .dt-column-order {
            display: none !important;
        }

        #viewemployee th,
        #viewemployee td {
            white-space: nowrap;
        }

        #viewemployee thead tr:nth-child(2) th {
            cursor: default !important;
        }

        #viewemployee .column_search {
            width: 100%;
            min-width: 100px;
            padding: 6px 8px;
            border: 1px solid #ccd6e0;
            border-radius: 6px;
        }

        .employee-action-btn {
            width: 30px;
            height: 30px;
            border: 1px solid #bfdbfe;
            border-radius: 7px;
            background: #eff6ff;
            color: dodgerblue;
        }

 /* Same alignment and spacing for header and body */
#viewemployee th,
#viewemployee td {
    white-space: nowrap !important;
    vertical-align: middle !important;
    text-align: left;
    padding: 10px 12px !important;
}

/* Action column */
#viewemployee th:first-child,
#viewemployee td:first-child {
    text-align: center !important;
}

/* Visible cloned header created by scrollX */
.dataTables_scrollHead table th,
.dt-scroll-head table th {
    white-space: nowrap !important;
    vertical-align: middle !important;
    text-align: left;
    padding: 10px 12px !important;
}

.dataTables_scrollHead table th:first-child,
.dt-scroll-head table th:first-child {
    text-align: center !important;
}

/* Filter row */
.employee-filter-row th {
    height: 56px;
    padding: 10px 8px !important;
    background-color: #eaf2f9;
    cursor: default !important;
}

/* Search inputs */
.column_search {
    display: block !important;
    width: 100% !important;
    min-width: 100px;
    height: 34px;
    padding: 6px 10px;
    border: 1px solid #cbd7e5;
    border-radius: 7px;
    background-color: #ffffff;
    font-size: 11px;
    box-sizing: border-box;
}

/* Remove ordering arrows */
#viewemployee thead th::before,
#viewemployee thead th::after,
.dataTables_scrollHead thead th::before,
.dataTables_scrollHead thead th::after,
.dt-scroll-head thead th::before,
.dt-scroll-head thead th::after,
.dt-column-order {
    display: none !important;
    content: none !important;
}
    </style>

    <script>

        $(document).ready(function () {
            var currentUserName = '<%= HttpContext.Current.User.Identity.Name.ToString() %>';
            viewEmployee_Grid(currentUserName);
        });

        var fileslist = '';
        var fd = new FormData();

        window.onload = function () {
            document.getElementById('uploaddocs_emp').addEventListener('change', getFileName);
        }

        const getFileName = (event) => {

            for (var i = 0; i < event.target.files.length; i++) {
                const files = event.target.files;
                var file = files[i];
                document.getElementById("fpviewempdocs").value = files[i].name;
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

                //  alert(xhr.status);

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
            document.getElementById("filesdiv").innerHTML = fileslist;
        }

    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <input id="fpviewempdocs" style="display: none;" />
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="view-employee-page">
        <!-- Header -->
        <div class="dashboard-header">
            <div class="dashboard-header-content">
                <div class="dashboard-icon" aria-hidden="true">
                    <i class="fas fa-address-card"></i>
                </div>
                <div>
                    <h1 class="dashboard-title">View Employees</h1>
                    <p class="dashboard-subtitle">
                        Review employee profiles, employment information, reporting details, and current account status.
                   
                    </p>
                </div>
            </div>
        </div>

        <div class="col-lg-12 view-employee-section">
            <div class="card view-employee-card">
                <div class="card-body">
                    <h5 class="card-title"></h5>
                    <table class="table" id="viewemployee" style="padding-top: 10px; width: 100%;">
                        <thead>
                            <tr>
                                <th style="width: 50px;">Actions</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">EmployeeID</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Code</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Name</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Joining Date</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Cut Off Time</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Date of Birth</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Gender</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Branch</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Department</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Designation</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Domain</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Subdomain</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Reporting Manager</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Job Type</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Latest Login</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Current Status</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Task/Productive</th>
                            </tr>
                            <tr>
                                <th style="width: 50px;"></th>
                                <th class="sort border-top" style="text-wrap: nowrap;">EmployeeID</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Code</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Name</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Joining Date</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Cut Off Time</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Date of Birth</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Gender</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Branch</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Department</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Designation</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Domain</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Subdomain</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Reporting Manager</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Job Type</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Latest Login</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Current Status</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Task/Productive</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="viewemp_uploaddocs" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="viewemp_uploaddocsLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="viewemp_uploaddocsLabel">Upload - </h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <label id="viewemp_code" class="bootstrap-switch-label" style="display: none;"></label>
                    <table class="table">
                        <tr>
                            <td colspan="2" rowspan="2" style="vertical-align: middle;">
                                <b>Please upload required documents</b>
                            </td>
                            <td>
                                <input type="file" id="uploaddocs_emp" name="uploaddocs_emp" class="form-control" style="width: 250px;" multiple />
                                <div class="dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete" id="dropzoneEmpdocsdoc" style="display: none;">
                                    <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column" id="conentdivEmpdocsdoc" style="display: none!important;">
                                        <div class="flex-1 d-flex flex-between-center">
                                            <div id="filesdivEmpdocsdoc" style="margin-top: 10px; margin-bottom: 10px;"></div>
                                            <div class="dropdown font-sans-serif">
                                                <button class="btn btn-link text-600 btn-sm dropdown-toggle btn-reveal dropdown-caret-none" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="true"></button>
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
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" onclick="return viewemp_uploaddocs_submit();">Upload</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="empdocs_waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;"><b>Uploading your files...</b><br />
                Please wait while we process your upload. This may take a few moments.</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>
</asp:Content>
