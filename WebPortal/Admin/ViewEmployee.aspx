<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ViewEmployee.aspx.cs" Inherits="WebPortal.Admin.ViewEmployee" %>

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

        .dataTables_paginate {
            float: left !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 50px;
            float: left;
        }

        .buttons-excel {
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
            /*background:linear-gradient(to bottom, #0070C0, 80%, #ffffff);*/
            background: linear-gradient(to bottom, #cbd0dd, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none;
        }
        /*.form-control {
            font-size: 11px !important;
        }*/
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

    <!-- Header -->
    <div class="dashboard-header">

        <div class="d-flex justify-content-between align-items-start mb-1">

            <div>
                <div class="dashboard-title">
                    <i class="fas fa-users mr-2"></i>
                    View Employee
                </div>
                <div class="dashboard-subtitle">
                    View employee profiles, personal details, employment information, and account status.
                </div>
            </div>
        </div>

    </div>
    <div class="col-lg-12">
        <div class="card">
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
