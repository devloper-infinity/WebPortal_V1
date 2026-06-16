<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EmployeeComments.aspx.cs" Inherits="WebPortal.Admin.EmployeeComments" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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


    <style>
        .form-readonly {
            background: #f8f9fa;
            min-height: 38px;
            display: flex;
            align-items: center;
            padding-left: 10px;
        }

        .info-box {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 12px 15px;
            border: 1px solid #e6e6e6;
            transition: all .25s ease;
        }

            .info-box:hover {
                transform: translateY(-3px);
                box-shadow: 0 6px 14px rgba(0,0,0,0.08);
            }

            .info-box label {
                font-size: 13px;
                color: #6c757d;
                margin-bottom: 3px;
                display: block;
            }

        .info-value {
            font-size: 15px;
            font-weight: 600;
            color: #2c3e50;
            min-height: 22px;
        }
    </style>


    <script>
        var fd = new FormData();

        window.onload = function () {
            document.getElementById('ecom_attachment').addEventListener('change', getFileName);
        };

        function getFileName(event) {

            var file = event.target.files[0]; // get single file

            if (!file) return;

            document.getElementById("ecom_file").value = file.name;

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

            ecom_bindEmployees();
            hrinv_bindLocation();
        });

    </script>

    <style>
        .employee-form {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 18px 24px;
            padding: 20px;
            background: #fff;
            border-radius: 8px;
        }

            .employee-form label {
                font-weight: 600;
                margin-bottom: 6px;
                display: block;
            }

            .employee-form .form-control {
                width: 100%;
            }

            .employee-form .full-width {
                grid-column: span 3;
            }

            .employee-form .form-actions {
                grid-column: span 3;
                text-align: center;
                margin-top: 10px;
            }

        @media (max-width: 768px) {
            .employee-form {
                grid-template-columns: 1fr;
            }

                .employee-form .full-width,
                .employee-form .form-actions {
                    grid-column: span 1;
                }
        }
    </style>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <%-- <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-..." crossorigin="anonymous" referrerpolicy="no-referrer" />--%>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <input id="ecom_file" style="display: none;" />

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="dashboard-header">
        <div class="d-flex justify-content-between align-items-start mb-1">
            <div>
                <div class="dashboard-title">
                  <i class="fas fa-comment-dots mr-2"></i>
                    Employee Comments
                </div>

                <div class="dashboard-subtitle">
                     Add, manage, and track employee comments and feedback records.
                </div>
            </div>
        </div>
    </div>
    <div class="card">
        <div class="card-body">
            <div class="card-header p-0 pt-1">
                <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist" style="font-weight: bold;">
                    <li class="nav-item">
                        <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Add Comment</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" id="custom-tabs-one-report-tab" data-toggle="pill" href="#custom-tabs-one-report" role="tab" aria-controls="custom-tabs-one-report" aria-selected="false" onclick="ecom_bindReport();">Report</a>
                    </li>
                </ul>
            </div>
            <div class="card-body">
                <div class="tab-content" id="custom-tabs-one-tabContent">
                    <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                        <div class="form-grid">

                            <div class="field">
                                <label>Employee</label>
                                <select id="ecom_user" name="ecom_user" onchange="return ecom_bindemployeeInfo(this);"></select>
                            </div>

                            <div class="field">
                                <label>Branch</label>
                                <input type="text" id="ecom_branch" name="ecom_branch" />
                            </div>

                            <div class="field">
                                <label>Domain</label>
                                <input type="text" id="ecom_domain" name="ecom_domain" />
                            </div>

                            <div class="field">
                                <label>Department</label>
                                <input type="text" id="ecom_department" name="ecom_department" />
                            </div>

                            <div class="field">
                                <label>Designation</label>
                                <input type="text" id="ecom_designation" name="ecom_designation" />
                            </div>

                            <div class="field">
                                <label>Reporting Manager</label>
                                <input type="text" id="ecom_reportMan" name="ecom_reportMan" />
                            </div>

                            <div class="field">
                                <label>Joining Date</label>
                                <input type="text" id="ecom_joiningdate" name="ecom_joiningdate" />
                            </div>

                            <div class="field">
                                <label>Subject</label>
                                <input type="text" id="ecom_subject" name="ecom_subject" />
                            </div>

                            <div class="field">
                                <label>Attachment</label>
                                <input type="file" id="ecom_attachment" />
                            </div>

                            <div class="field full">
                                <label>Comments</label>
                                <textarea id="ecom_comment" name="ecom_comment" rows="4"></textarea>
                            </div>

                            <div class="actions">
                                <button type="button" id="ecom_btnsubmit" onclick="return ecom_SubmitData();">
                                    Submit Comment
                                </button>
                            </div>

                        </div>

                    </div>
                    <div class="tab-pane fade" id="custom-tabs-one-report" role="tabpanel" aria-labelledby="custom-tabs-one-report-tab">
                        <table class="table" id="table_ecomreport" style="width: 100%">
                            <thead>
                                <tr>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Action</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Subject</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Comment</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added By</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added Date</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <style>
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

        .employee-panel {
            padding: 24px;
            background: linear-gradient(135deg, #f8fbff, #eef4ff);
            border-radius: 18px;
            box-shadow: 0 12px 35px rgba(31, 45, 61, 0.12);
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 22px;
        }

        .field label {
            display: block;
            font-size: 13px;
            font-weight: 700;
            color: #344767;
            margin-bottom: 7px;
        }

        .field input,
        .field select,
        .field textarea {
            width: 100%;
            border: 1px solid #d9e2ef;
            border-radius: 12px;
            padding: 11px 14px;
            font-size: 14px;
            background: #fff;
            color: #263238;
            outline: none;
            transition: 0.25s ease;
        }

            .field input:focus,
            .field select:focus,
            .field textarea:focus {
                border-color: #3b82f6;
                box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.12);
            }

        .full {
            grid-column: span 3;
        }

        .actions {
            grid-column: span 3;
            text-align: center;
        }

            .actions button {
                border: none;
                border-radius: 30px;
                padding: 11px 34px;
                /* background: linear-gradient(135deg, #eef4ff, #f8fbff);*/
                background: linear-gradient(135deg, #2563eb, #06b6d4);
                color: #fff;
                font-weight: 700;
                font-size: 14px;
                box-shadow: 0 8px 18px rgba(37, 99, 235, 0.3);
                cursor: pointer;
            }

                .actions button:hover {
                    transform: translateY(-1px);
                    box-shadow: 0 12px 22px rgba(37, 99, 235, 0.4);
                }

        @media (max-width: 992px) {
            .form-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .full,
            .actions {
                grid-column: span 2;
            }
        }

        @media (max-width: 576px) {
            .form-grid {
                grid-template-columns: 1fr;
            }

            .full,
            .actions {
                grid-column: span 1;
            }
        }
    </style>

</asp:Content>
