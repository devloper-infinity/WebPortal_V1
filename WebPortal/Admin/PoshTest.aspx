<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="PoshTest.aspx.cs" Inherits="WebPortal.Admin.PoshTest" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>

        .posh-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            gap: 22px;
            padding: 28px 34px;
            margin-bottom: 22px;
            border-radius: 20px;
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 55%, #22c1dc 100%);
            box-shadow: 0 16px 34px rgba(37, 99, 235, .25);
        }

        .posh-hero::before {
            content: "";
            position: absolute;
            inset: -90px auto auto -70px;
            width: 260px;
            height: 260px;
            border-radius: 50%;
            background: rgba(255, 255, 255, .13);
        }

        .posh-hero::after {
            content: "";
            position: absolute;
            right: -70px;
            bottom: -90px;
            width: 340px;
            height: 220px;
            border-radius: 50%;
            background: rgba(255, 255, 255, .12);
            box-shadow: -70px -25px 0 rgba(255, 255, 255, .06);
        }

        .posh-hero-icon {
            position: relative;
            z-index: 2;
            width: 60px;
            height: 60px;
            min-width: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 2px solid rgba(255, 255, 255, .65);
            background: rgba(255, 255, 255, .14);
            backdrop-filter: blur(5px);
        }

        .posh-hero-icon i {
            font-size: 30px;
            color: #fff;
        }

        .posh-hero-content {
            position: relative;
            z-index: 2;
        }

        .posh-kicker {
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 2px;
            text-transform: uppercase;
            opacity: .9;
            margin-bottom: 5px;
        }

        .posh-title {
            margin: 0;
            font-size: 25px;
            font-weight: 800;
            color: #fff;
        }

        .posh-subtitle {
            margin: 8px 0 0;
            max-width: 850px;
            font-size: 13px;
            line-height: 1.6;
            color: rgba(255, 255, 255, .94);
        }

        .posh-shell-card {
            border: 0;
            border-radius: 18px;
            background: #fff;
            box-shadow: 0 12px 30px rgba(15, 23, 42, .08);
            overflow: hidden;
        }

        .posh-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            padding: 18px 22px;
            background: linear-gradient(180deg, #f8fbff 0%, #eef6ff 100%);
            border-bottom: 1px solid #e5eefb;
        }

        .posh-card-heading {
            display: flex;
            align-items: center;
            gap: 12px;
            color: #0f172a;
        }

        .posh-card-heading span {
            width: 42px;
            height: 42px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #2563eb;
            background: #dbeafe;
        }

        .posh-card-heading h5 {
            margin: 0;
            font-size: 17px;
            font-weight: 800;
        }

        .posh-card-heading p {
            margin: 3px 0 0;
            font-size: 12px;
            color: #64748b;
        }

        .posh-status-chip {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 7px 13px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
            color: #075985;
            background: #e0f2fe;
            white-space: nowrap;
        }

        .posh-body {
            padding: 22px;
        }

        #dvposhtest {
            min-height: 190px;
        }

        #dvposhtest .table {
            width: 100% !important;
            margin-bottom: 0;
        }

        #dvposhtest .table th,
        .table.dataTable th {
            background: #edf3f6 !important;
            color: #263238 !important;
            font-size: 13px;
            font-weight: 800;
            height: 42px;
            white-space: nowrap;
            vertical-align: middle;
        }

        #dvposhtest .table td,
        .table.dataTable td {
            font-size: 13px;
            white-space: nowrap;
            vertical-align: middle;
        }

        .dataTables_wrapper .dataTables_filter input,
        .dataTables_wrapper .dataTables_length select {
            border: 1px solid #dbe3ef;
            border-radius: 10px;
            padding: 6px 10px;
            outline: none;
        }

        .dataTables_wrapper .dt-buttons {
            margin-bottom: 12px;
        }

        .buttons-excel,
        .buttons-html5 {
            color: #fff !important;
            background: linear-gradient(120deg, #1d4ed8, #22c1dc) !important;
            border: 0 !important;
            border-radius: 10px !important;
            font-weight: 700 !important;
            padding: 7px 15px !important;
            box-shadow: 0 8px 18px rgba(37, 99, 235, .18) !important;
        }

        .posh-loader {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 99999;
            align-items: center;
            justify-content: center;
            background: rgba(248, 250, 252, .78);
            backdrop-filter: blur(3px);
        }

        .posh-loader-box {
            min-width: 210px;
            padding: 24px 26px;
            border-radius: 18px;
            text-align: center;
            background: #fff;
            box-shadow: 0 18px 45px rgba(15, 23, 42, .18);
        }

        .posh-loader-box img {
            width: 62px;
            height: 62px;
        }

        .posh-loader-text {
            margin-top: 10px;
            font-size: 13px;
            font-weight: 800;
            color: #334155;
        }

        .modal-modern .modal-content {
            border: 0;
            border-radius: 18px;
            box-shadow: 0 18px 45px rgba(15, 23, 42, .22);
        }

        .modal-modern .modal-header {
            border-bottom: 1px solid #e5e7eb;
            background: linear-gradient(120deg, #1d4ed8, #22c1dc);
            color: #fff;
            border-radius: 18px 18px 0 0;
        }

        .modal-modern .modal-title {
            font-weight: 800;
        }

        @media (max-width: 768px) {
            .posh-hero {
                align-items: flex-start;
                padding: 22px;
            }

            .posh-hero-icon {
                width: 58px;
                height: 58px;
                min-width: 58px;
            }

            .posh-hero-icon i {
                font-size: 25px;
            }

            .posh-title {
                font-size: 24px;
            }

            .posh-card-header {
                align-items: flex-start;
                flex-direction: column;
            }
        }
    </style>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        $(document).ready(function () {
            ChekIfPoshTestExists();
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="posh-loader" id="load1">
        <div class="posh-loader-box">
            <img src="../images/Load_1.gif" alt="Loading" />
            <div class="posh-loader-text">One moment, please...</div>
        </div>
    </div>

    <div class="posh-page">
        <div class="posh-hero">
            <span class="posh-hero-icon">
                <i class="fas fa-shield-alt"></i>
            </span>
            <div class="posh-hero-content">
               <%-- <div class="posh-kicker">Employee Compliance</div>--%>
                <h1 class="posh-title">POSH - Induction Test</h1>
                <p class="posh-subtitle">
                    Complete your POSH awareness induction test and review your completion status in one place.
                </p>
            </div>
        </div>

        <div class="card posh-shell-card">
            <div class="posh-card-header">
                <div class="posh-card-heading">
                    <span><i class="fas fa-clipboard-check"></i></span>
                    <div>
                        <h5>Test Details</h5>
                        <p>Questions, answers and status will appear below.</p>
                    </div>
                </div>
                <div class="posh-status-chip">
                    <i class="fas fa-info-circle"></i>
                    POSH Compliance
                </div>
            </div>
            <div class="posh-body">
                <div id="dvposhtest"></div>
            </div>
        </div>
    </div>

    <div class="modal fade modal-modern" id="posh_dverror" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="posh_errmsg"></h6>
                </div>
                <div class="modal-footer justify-content-center">
                    <button class="btn btn-primary" type="button" id="posh_btnMessage" onclick="return posh_Message();">
                        Okay
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered justify-content-center text-center">
            <div>
                <img src="../Images/Load.gif" alt="Loading" />
                <br />
                <span style="color:#fff;font-size:24px;font-weight:bold;font-style:italic;" id="spntext">
                    System is updating details. Please wait
                </span>
                <span style="color:#fff;font-size:48px;font-weight:bold;font-style:italic;animation:animate 1s linear infinite;">
                    &nbsp;. . . .
                </span>
            </div>
        </div>
    </div>
</asp:Content>
