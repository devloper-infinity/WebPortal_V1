<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="DropoutEmployeeReport.aspx.cs" Inherits="WebPortal.Admin.DropoutEmployeeReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .dropout-page {
            background: #f4f7fb;
        }

        .dropout-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            gap: 22px;
            padding: 20px 25px;
            margin-bottom: 22px;
            border-radius: 18px;
            color: #fff;
            background: linear-gradient(115deg, #0a5fd7 0%, #1976f3 38%, #1da8ea 72%, #22d3ee 100%);
            box-shadow: 0 12px 28px rgba(21, 98, 228, .25);
        }

            .dropout-hero::before {
                content: "";
                position: absolute;
                top: -80px;
                left: -5%;
                width: 115%;
                height: 170px;
                border-radius: 50%;
                background: rgba(255,255,255,.10);
                transform: rotate(-4deg);
            }

            .dropout-hero::after {
                content: "";
                position: absolute;
                right: -85px;
                bottom: -90px;
                width: 290px;
                height: 290px;
                border-radius: 50%;
                background: rgba(255,255,255,.12);
            }

            .dropout-hero > * {
                position: relative;
                z-index: 2;
            }

        .dropout-hero-icon {
            width: 60px;
            height: 60px;
            min-width: 60px;
            border-radius: 20%;
            border: 2px solid rgba(255,255,255,.78);
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.12);
            box-shadow: inset 0 0 0 8px rgba(255,255,255,.05);
        }

            .dropout-hero-icon i {
                font-size: 27px;
                color: #fff;
            }

        .dropout-title {
            margin: 0;
            font-size: 20px;
            font-weight: 800;
            color: #fff;
        }

        .dropout-subtitle {
            margin: 8px 0 0;
            font-size: 13px;
            color: rgba(255,255,255,.93);
            line-height: 1.55;
            max-width: 920px;
        }

        .dropout-table-card {
            border: 0;
            border-radius: 18px;
            box-shadow: 0 10px 28px rgba(15, 23, 42, .08);
            overflow: hidden;
        }

        .dropout-card-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            padding: 18px 20px;
            border-bottom: 1px solid #e7eef8;
            background: linear-gradient(180deg, #ffffff 0%, #f8fbff 100%);
        }

        .dropout-card-title {
            margin: 0;
            color: #0f172a;
            font-size: 17px;
            font-weight: 800;
        }

            .dropout-card-title i {
                color: #2563eb;
                margin-right: 8px;
            }

        .dropout-chip {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 7px 14px;
            border-radius: 999px;
            color: #1d4ed8;
            font-size: 12px;
            font-weight: 800;
            background: #eaf3ff;
            border: 1px solid #cfe3ff;
            white-space: nowrap;
        }

        .dropout-table-wrap {
            padding: 18px;
        }

        #dropoutemployee_table {
            width: 100% !important;
            margin-bottom: 0;
        }

            #dropoutemployee_table thead th,
            .table.dataTable th {
                background: #edf3f8 !important;
                color: #111827 !important;
                font-size: 12px;
                font-weight: 800;
                white-space: nowrap;
                border-bottom: 1px solid #dbe6f2 !important;
                padding: 11px 12px;
            }

            #dropoutemployee_table tbody td,
            .table.dataTable td {
                font-size: 12px;
                vertical-align: middle;
                white-space: nowrap;
                background-color: #fff !important;
                padding: 10px 12px;
            }

            #dropoutemployee_table tbody tr:hover td {
                background: #f8fbff !important;
            }

        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dataTables_info {
            float: left !important;
            font-size: 12px;
            color: #475569;
            font-weight: 600;
        }

        .dataTables_wrapper .dataTables_filter {
            float: right !important;
            font-size: 12px;
            color: #475569;
            font-weight: 700;
        }

            .dataTables_wrapper .dataTables_filter input,
            .dataTables_wrapper .dataTables_length select {
                border: 1px solid #dbe7f3;
                border-radius: 10px;
                padding: 5px 10px;
                font-size: 12px;
                outline: none;
            }

        .dataTables_wrapper .dataTables_paginate {
            float: left !important;
            margin-top: 10px;
        }

            .dataTables_wrapper .dataTables_paginate .paginate_button {
                border-radius: 8px !important;
                border: 1px solid #dbe7f3 !important;
                background: #fff !important;
                color: #334155 !important;
                margin: 0 3px;
                padding: 5px 10px !important;
                font-size: 12px;
                font-weight: 700;
            }

                .dataTables_wrapper .dataTables_paginate .paginate_button.current {
                    color: #fff !important;
                    border: 0 !important;
                    background: linear-gradient(120deg, #2563eb, #22c1dc) !important;
                }

        div.dt-buttons {
            position: static;
            padding-left: 50px;
            float: left;
        }

        .buttons-excel,
        .buttons-html5 {
            color: #fff !important;
            box-shadow: none !important;
            background: linear-gradient(120deg, #22c55e, #16a34a) !important;
            border: 0 !important;
            font-weight: 800 !important;
            margin: 0 10px !important;
            border-radius: 9px !important;
            padding: 6px 14px !important;
            font-size: 12px !important;
        }

        .dataTables_scrollHeadInner,
        .dataTables_scrollHeadInner table {
            width: 100% !important;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: normal !important;
            border: none !important;
        }

        @media (max-width: 768px) {
            .dropout-page {
                padding: 12px;
            }

            .dropout-hero {
                flex-direction: column;
                align-items: flex-start;
                padding: 24px;
            }

            .dropout-title {
                font-size: 24px;
            }

            .dropout-card-head {
                flex-direction: column;
                align-items: flex-start;
            }

            div.dt-buttons {
                padding-left: 0;
                margin-top: 8px;
            }
        }
    </style>

    <style>
        .setappr-loading {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 20000;
            background: rgba(15, 23, 42, .28);
        }

        .setappr-loading-card {
            position: absolute;
            top: 50%;
            left: 50%;
            width: 220px;
            min-height: 150px;
            padding: 22px;
            border: 1px solid rgba(203, 213, 225, .8);
            border-radius: 8px;
            background: rgba(255,255,255,.96);
            text-align: center;
            box-shadow: 0 24px 70px rgba(15, 23, 42, .26);
            transform: translate(-50%, -50%);
        }

            .setappr-loading-card img {
                width: 70px;
                height: 70px;
                object-fit: contain;
            }

            .setappr-loading-card div {
                margin-top: 8px;
                color: #334155;
                font-size: 12px;
                font-weight: 900;
            }
    </style>

    <script>
        $(document).ready(function () {
            var currEmp = $("#<%= hdnEmpID.ClientID %>").val();
            dropoutemployee_bindgrid(currEmp);
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="setappr-loading" id="load1" aria-hidden="true">
        <div class="setappr-loading-card">
            <img src="../images/Load_1.gif" alt="Loading" />
            <div>One moment, please...</div>
        </div>
    </div>

    <div class="dropout-page">
        <div class="dropout-hero">
            <span class="dropout-hero-icon">
                <i class="fas fa-user-slash"></i>
            </span>

            <div>
                <h1 class="dropout-title">Dropout Employees Report</h1>
                <p class="dropout-subtitle">
                    View dropout employee details including resignation information, exit remarks and formalities status in one organized report.
              
                </p>
            </div>
        </div>

        <div class="card dropout-table-card">
            <div class="dropout-card-head">
                <h5 class="dropout-card-title">
                    <i class="fas fa-table"></i>
                    Dropout Employee Records
                </h5>

                <span class="dropout-chip">
                    <i class="fas fa-database"></i>
                    Live Employee Report
                </span>
            </div>

            <div style="overflow: auto; padding: 20px 20px;">
                <table class="table table-bordered table-hover nowrap" id="dropoutemployee_table" style="width: 100%;">
                    <thead></thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>

    </div>
    <asp:HiddenField ID="hdnEmpID" runat="server" />
</asp:Content>
