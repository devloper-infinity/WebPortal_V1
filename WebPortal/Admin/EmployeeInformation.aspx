<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EmployeeInformation.aspx.cs" Inherits="WebPortal.Admin.EmployeeInformation" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --ei-primary: #2457e6;
            --ei-cyan: #25bfd4;
            --ei-dark: #111827;
            --ei-muted: #667085;
            --ei-border: #e4eaf3;
            --ei-soft: #f5f8fc;
            --ei-white: #ffffff;
        }

        body {
            background: linear-gradient(180deg, #f3f7fb 0%, #eef4f9 100%) !important;
        }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            margin: auto;
            width: 190px;
            height: 190px;
            z-index: 99999;
            background: rgba(255,255,255,.92);
            border: 1px solid rgba(228,234,243,.9);
            border-radius: 26px;
            box-shadow: 0 22px 70px rgba(17,24,39,.18);
            text-align: center;
            padding-top: 28px;
            color: var(--ei-dark);
        }

            .loading img {
                width: 86px;
                height: 86px;
                object-fit: contain;
            }

        .modern-header-wrap {
        }

        .modern-page-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            gap: 18px;
            min-height: 96px;
            border-radius: 20px;
            padding: 24px 30px;
            color: #fff;
            background: linear-gradient(120deg, #2457e6 0%, #2e74ed 48%, #25bfd4 100%);
            box-shadow: 0 22px 48px rgba(36,87,230,.22);
        }

            .modern-page-hero:before,
            .modern-page-hero:after {
                content: "";
                position: absolute;
                border-radius: 999px;
                background: rgba(255,255,255,.14);
                pointer-events: none;
            }

            .modern-page-hero:before {
                width: 220px;
                height: 220px;
                right: 38px;
                top: -118px;
            }

            .modern-page-hero:after {
                width: 170px;
                height: 170px;
                right: -38px;
                bottom: -86px;
            }

        .modern-page-icon {
            position: relative;
            z-index: 1;
            width: 54px;
            height: 54px;
            border-radius: 17px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.16);
            border: 1px solid rgba(255,255,255,.25);
            box-shadow: inset 0 1px 0 rgba(255,255,255,.25);
            flex: 0 0 auto;
        }

            .modern-page-icon i {
                font-size: 26px;
                color: #fff;
            }

        .modern-page-copy {
            position: relative;
            z-index: 1;
            min-width: 0;
        }

        .modern-page-title {
            margin: 0 0 6px;
            font-size: 22px;
            line-height: 1.15;
            font-weight: 850;
            letter-spacing: .1px;
        }

        .modern-page-subtitle {
            margin: 0;
            font-size: 13px;
            font-weight: 650;
            opacity: .93;
        }

        .hero-chip {
            position: relative;
            z-index: 1;
            margin-left: auto;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            white-space: nowrap;
            padding: 10px 15px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 800;
            background: rgba(255,255,255,.16);
            border: 1px solid rgba(255,255,255,.24);
            color: #fff;
        }

        .modern-card-wrap {
            padding-top: 30px;
        }

        .modern-card {
            overflow: hidden;
            border: 1px solid var(--ei-border);
            border-radius: 22px;
            background: var(--ei-white);
            box-shadow: 0 20px 60px rgba(17,24,39,.08);
        }

        .modern-card-head {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 19px 24px;
            border-bottom: 1px solid var(--ei-border);
            background: linear-gradient(180deg, #fff 0%, #f9fbfe 100%);
        }

        .modern-card-icon {
            width: 38px;
            height: 38px;
            border-radius: 13px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: var(--ei-primary);
            background: #eef4ff;
        }

            .modern-card-icon i {
                font-size: 18px;
            }

        .modern-card-title {
            margin: 0;
            color: var(--ei-dark);
            font-size: 16px;
            font-weight: 850;
        }

        .modern-card-subtitle {
            margin: 2px 0 0;
            color: var(--ei-muted);
            font-size: 12px;
            font-weight: 600;
        }

        .modern-card-body {
            padding: 22px 24px 26px;
        }

        .table-responsive-modern {
            width: 100%;
            overflow-x: auto;
            border: 1px solid #edf1f7;
            border-radius: 18px;
            background: #fff;
        }

        #empveri_table {
            margin: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0;
        }

            #empveri_table thead th {
                white-space: nowrap;
                color: #344054 !important;
                background: #f8fafc !important;
                border-color: #edf1f7 !important;
                font-size: 12px;
                font-weight: 800;
                padding: 13px 14px;
                vertical-align: middle;
            }

            #empveri_table thead tr:first-child th {
                background: linear-gradient(180deg, #f8fbff 0%, #f2f6fb 100%) !important;
                color: #111827 !important;
            }

            #empveri_table tbody td {
                background: #fff !important;
                border-color: #edf1f7 !important;
                color: #344054;
                font-size: 12px;
                padding: 12px 14px;
                vertical-align: middle;
            }

            #empveri_table tbody tr:hover td {
                background: #f7fbff !important;
            }

        .dataTables_scrollBody {
            min-height: 180px !important;
            height: auto !important;
            border-bottom-left-radius: 18px;
            border-bottom-right-radius: 18px;
        }

        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dataTables_filter,
        .dataTables_wrapper .dataTables_info,
        .dataTables_wrapper .dataTables_paginate {
            color: var(--ei-muted) !important;
            font-size: 12px;
            font-weight: 650;
        }

        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dataTables_info {
            float: left !important;
        }

            .dataTables_wrapper .dataTables_filter input,
            .dataTables_wrapper .dataTables_length select,
            table.dataTable thead tr:nth-child(2) th input,
            table.dataTable thead tr:nth-child(2) th select {
                border: 1px solid #d8e2ef !important;
                border-radius: 12px !important;
                min-height: 34px;
                padding: 6px 10px !important;
                outline: none !important;
                background: #fff !important;
                color: var(--ei-dark) !important;
                box-shadow: none !important;
            }

                .dataTables_wrapper .dataTables_filter input:focus,
                table.dataTable thead tr:nth-child(2) th input:focus,
                table.dataTable thead tr:nth-child(2) th select:focus {
                    border-color: var(--ei-primary) !important;
                    box-shadow: 0 0 0 4px rgba(36,87,230,.10) !important;
                }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: 650 !important;
            border: none !important;
            color: var(--ei-muted);
        }

        div.dt-buttons {
            position: static;
            padding-left: 18px;
            float: left;
        }

        .buttons-excel,
        .buttons-html5,
        .dt-button {
            color: #fff !important;
            border: 0 !important;
            border-radius: 12px !important;
            padding: 8px 14px !important;
            font-size: 12px !important;
            font-weight: 800 !important;
            background: linear-gradient(135deg, var(--ei-primary), var(--ei-cyan)) !important;
            box-shadow: 0 10px 22px rgba(36,87,230,.16) !important;
            margin: 0 8px !important;
            transition: transform .18s ease, box-shadow .18s ease;
        }

            .buttons-excel:hover,
            .buttons-html5:hover,
            .dt-button:hover {
                transform: translateY(-1px);
                box-shadow: 0 14px 28px rgba(36,87,230,.24) !important;
            }

        .dataTables_paginate .paginate_button {
            border: 1px solid #d8e2ef !important;
            border-radius: 10px !important;
            margin: 0 3px !important;
            padding: 5px 10px !important;
            color: #344054 !important;
            background: #fff !important;
        }

            .dataTables_paginate .paginate_button.current,
            .dataTables_paginate .paginate_button.current:hover {
                color: #fff !important;
                background: linear-gradient(135deg, var(--ei-primary), var(--ei-cyan)) !important;
                border-color: transparent !important;
            }

        @media (max-width: 768px) {
            .modern-header-wrap,
            .modern-card-wrap {
                padding-left: 14px;
                padding-right: 14px;
            }

            .modern-page-hero {
                padding: 20px;
                border-radius: 18px;
            }

            .hero-chip {
                display: none;
            }

            .modern-page-title {
                font-size: 19px;
            }

            .modern-card-body {
                padding: 16px;
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            EmployeeInformationDetails();
        });
    </script>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/fixedcolumns/4.3.0/css/fixedColumns.dataTables.min.css">
    <script src="https://cdn.datatables.net/fixedcolumns/4.3.0/js/dataTables.fixedColumns.min.js"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="modern-header-wrap">
        <div class="modern-page-hero">
            <div class="modern-page-icon">
                <i class="bi bi-person-vcard-fill"></i>
            </div>
            <div class="modern-page-copy">
                <h1 class="modern-page-title">Employee Verification Details</h1>
                <p class="modern-page-subtitle">View, search and export employee information quickly.</p>
            </div>
            <div class="hero-chip"><i class="bi bi-shield-check"></i>Verified Employee Records</div>
        </div>
    </div>

    <div class="modern-card-wrap">
        <div class="modern-card">
            <div class="modern-card-head">
                <div class="modern-card-icon"><i class="bi bi-table"></i></div>
                <div>
                    <h2 class="modern-card-title">Employee Information</h2>
                    <p class="modern-card-subtitle">Complete employee verification and employment details</p>
                </div>
            </div>
            <div class="modern-card-body">
                <div class="table-responsive-modern">
                    <table class="table table-bordered" id="empveri_table" style="width: 100%;">
                        <thead>
                            <tr>
                                <th class="sort border-top" style="text-wrap: nowrap;">Sr. #</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Code</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Name</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Salary</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Joining Date</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Date of Birth</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Branch</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Domain</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Subdomain</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Process</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Department</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Designation</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Reporting Manager</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Present Address</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Permanent Address</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Contact #</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">ESIC #</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">PF #</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">UAN</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Personal Email</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Official Email</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Current Status</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Resignation Date</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Last Working Date</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Latest Login Date</th>
                            </tr>
                            <tr>
                                <th class="sort border-top" style="text-wrap: nowrap;">Sr. #</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Code</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Name</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Salary</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Joining Date</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Date of Birth</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Branch</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Domain</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Subdomain</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Process</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Department</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Designation</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Reporting Manager</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Present Address</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Permanent Address</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Contact #</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">ESIC #</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">PF #</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">UAN</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Personal Email</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Official Email</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Current Status</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Resignation Date</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Last Working Date</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Latest Login Date</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

