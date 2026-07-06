<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ClientHolidayMaster.aspx.cs" Inherits="WebPortal.Admin.ClientHolidayMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .form-control,
        select.form-control,
        input.form-control,
        .dropdown-toggle.form-control {
            border: groove;
            min-height: 44px;
            border-radius: 13px;
            border: 1px solid #d1d5db;
            background-color: #fff;
            color: var(--fw-text);
            box-shadow: 0 1px 2px rgba(15, 23, 42, 0.03);
            transition: border-color .2s ease, box-shadow .2s ease, transform .2s ease;
            outline-color: darkgray;
        }

            .form-control:focus,
            .dropdown-toggle.form-control:focus {
                border-color: rgba(79, 70, 229, 0.65);
                box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.12);
                /*  outline: none;*/
                outline-color: darkgray;
            }

        .dropdown-toggle.form-control {
            text-align: left;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }



        .multi-dropdown-menu {
            /* max-height: 220px;
            overflow-y: auto;
            width: 100%;
            padding: 10px;*/
            max-height: 260px;
            overflow-y: auto;
            width: 100%;
            padding: 10px;
            border: 1px solid var(--fw-border);
            border-radius: 14px;
            box-shadow: 0 18px 34px rgba(15, 23, 42, 0.16);
        }

            .multi-dropdown-menu label {
                /* display: flex;
                align-items: center;
                gap: 8px;
                margin-bottom: 6px;
                cursor: pointer;*/
                display: flex;
                align-items: center;
                gap: 9px;
                margin-bottom: 7px;
                cursor: pointer;
                color: #374151;
                font-weight: 600 !important;
            }

            .multi-dropdown-menu input[type="checkbox"] {
                transform: scale(1.1);
                width: 16px;
                height: 16px;
                accent-color: var(--fw-primary);
            }

        .card {
            border-radius: 12px;
            background-color: white;
            margin-top: 20px;
        }

        /* #choliday_btngetUsers,*/
        #choliday_btnapplyHoliday {
            min-width: 160px;
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
        }
    </style>

    <style>
        body {
            background: #f4f7fb;
        }

        .sec-hero-icon {
            width: 50px;
            height: 50px;
            min-width: 50px;
            border-radius: 20%;
            border: 2px solid rgba(255,255,255,.75);
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.10);
            backdrop-filter: blur(4px);
        }

            .sec-hero-icon i {
                font-size: 34px;
                color: #fff;
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
        }
    </style>

    <style>
        .sec-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            gap: 22px;
            padding: 17px 35px;
            margin-bottom: 25px;
            border-radius: 18px;
            color: #fff;
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            box-shadow: 0 12px 28px rgba(21, 98, 228, .25);
        }

        .sec-hero-icon {
            width: 50px;
            height: 50px;
            min-width: 50px;
            border-radius: 20%;
            border: 2px solid rgba(255,255,255,.75);
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.10);
            backdrop-filter: blur(4px);
        }

            .sec-hero-icon i {
                font-size: 34px;
                color: #fff;
                padding: 10px;
            }

        .sec-kicker {
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 2px;
            opacity: .9;
            margin-bottom: 5px;
            font-weight: 600;
        }

        .sec-title {
            margin: 0;
            font-size: 20px;
            font-weight: 700;
            color: #fff;
            margin-bottom: -10px;
        }

            .sec-title i {
                margin-right: 10px;
            }

        .sec-subtitle {
            margin: 10px 0 0;
            font-size: 14px;
            color: rgba(255,255,255,.92);
            line-height: 1.6;
            max-width: 900px;
        }
    </style>

    <style>
        .smart-btn {
            padding: 6px 14px;
            font-size: 12px;
            border-radius: 18px;
            border: none;
            cursor: pointer;
            background: linear-gradient(to right, #90caf9, 10%, #047edf);
            color: white;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            box-shadow: 0 3px 8px rgba(106, 90, 249, 0.25);
            transition: all 0.2s ease;
        }

            .smart-btn:hover {
                transform: translateY(-1px);
            }

            .smart-btn:active {
                transform: scale(0.96);
            }

            .smart-btn:disabled {
                opacity: 0.7;
                cursor: not-allowed;
            }

        /* Spinner */
        .spinner {
            width: 12px;
            height: 12px;
            border: 2px solid rgba(255,255,255,0.4);
            border-top-color: #fff;
            border-radius: 50%;
            display: none;
            animation: spin 0.7s linear infinite;
        }

        @keyframes spin {
            to {
                transform: rotate(360deg);
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            cl_bindHoliday();
            choliday_binddomain();
            choliday_bindlocation();
            choliday_bindDepartment();
            choliday_bindShift();
        });

    </script>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="sec-hero">
        <span class="sec-hero-icon">
            <i class="fas fa-calendar-alt mr-2"></i>
        </span>
        <div>
            <h1 class="sec-title">Client Holiday Master</h1>
            <p class="sec-subtitle">
                Configure and maintain client holiday calendars to ensure accurate attendance and payroll processing.
            </p>
        </div>
    </div>


    <div class="col-lg-12" style="background-color: white;">
        <div class="card">
            <div class="card-body">
                <div class="container">
                    <div class="row mb-3">
                        <div class="col-md-3">
                            <label><b>Holiday For </b></label>
                            <select id="choliday_desc" class="form-control"></select>
                        </div>
                        <div class="col-md-3">
                            <label><b>Date </b></label>
                            <input type="date" id="choliday_date" class="form-control" onkeydown="return false">
                        </div>
                        <div class="col-md-3">
                            <label><b>Domain </b></label>
                            <div class="dropdown">
                                <button id="choliday_domain_drpbtn" class="form-control dropdown-toggle text-left" type="button" data-toggle="dropdown">Select Domain</button>
                                <div class="dropdown-menu multi-dropdown-menu">
                                    <label>
                                        <input type="checkbox" id="choliday_select_all_domain">
                                        <b>Select All</b>
                                    </label>
                                    <div id="choliday_domainlist"></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label><b>Location </b></label>
                            <div class="dropdown">
                                <button id="choliday_location_drpbtn" class="form-control dropdown-toggle text-left" type="button" data-toggle="dropdown">Select Location</button>
                                <div class="dropdown-menu multi-dropdown-menu">
                                    <label>
                                        <input type="checkbox" id="choliday_select_all_location">
                                        <b>Select All</b>
                                    </label>
                                    <div id="choliday_locationlist"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-3">
                            <label><b>Department </b></label>
                            <div class="dropdown">
                                <button id="choliday_department_drpbtn" class="form-control dropdown-toggle text-left" type="button" data-toggle="dropdown">Select Department</button>
                                <div class="dropdown-menu multi-dropdown-menu">
                                    <label>
                                        <input type="checkbox" id="choliday_select_all_department">
                                        <b>Select All</b>
                                    </label>
                                    <div id="choliday_departmentlist"></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label><b>Shift </b></label>
                            <div class="dropdown">
                                <button id="choliday_shift_drpbtn" class="form-control dropdown-toggle text-left" type="button" data-toggle="dropdown">Select Shift</button>
                                <div class="dropdown-menu multi-dropdown-menu">
                                    <label>
                                        <input type="checkbox" id="choliday_select_all_shift">
                                        <b>Select All</b>
                                    </label>
                                    <div id="choliday_shiftlist"></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6 d-flex align-items-end">
                            <div>
                                <button type="button" id="choliday_btngetUsers" class="btn btn-primary" onclick="return choliday_getuserslist();">Get Users List</button>
                                <button type="button" id="choliday_btnapplyHoliday" class="btn btn-primary ml-2" onclick="return choliday_InsertHoliday();">Apply Holiday</button>
                            </div>
                        </div>
                    </div>
                    <br />
                    <div class="card">
                        <table id="choliday_table" class="table" style="width: 100%">
                            <thead>
                                <tr>
                                    <th style="width: 60px; text-align: center;">
                                        <input type="checkbox" id="chkSelectAll" />
                                    </th>
                                    <th style="width: 60px; display: none;">ID</th>
                                    <th style="width: 60px; text-align: center;">Sr. #</th>
                                    <th style="width: 100px; text-align: center;">Code</th>
                                    <th>Name</th>
                                    <th style="text-align: center;">Domain</th>
                                    <th style="text-align: center;">Branch</th>
                                    <th style="text-align: center;">Department</th>
                                    <th style="text-align: center;">Shift</th>
                                    <th style="text-align: center;">Cut Off Time</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%--    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <div class="card card-tabs">
                    <div class="card-header p-0 pt-1">
                        <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Add Client Holidays</a>
                            </li>
                            <%--  <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">Update Existing Client Holidays</a>
                            </li>
                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">

                                <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>--%>
</asp:Content>
