<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="LoanLevelHistory.aspx.cs" Inherits="WebPortal.Admin.LoanLevelHistory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <portal:VersionedScript Src="~/Scripts/Functions/LoanTrackingHistory.js" runat="server"></portal:VersionedScript>

    <style>

        body {
            background: #f3f6f8;
        }

        .loan-page {
            color: #16202a;
            padding-bottom: 28px;
        }

        .loan-hero {
            align-items: center;
            background: linear-gradient(135deg, #0f766e 0%, #1d4ed8 100%);
            border-radius: 8px;
            box-shadow: 0 14px 28px rgba(28, 58, 85, 0.16);
            color: #fff;
            display: flex;
            justify-content: space-between;
            gap: 20px;
            margin-bottom: 18px;
            padding: 22px 24px;
        }

        .loan-kicker {
            color: rgba(255,255,255,.82);
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
        }

        .loan-title {
            font-size: 26px;
            font-weight: 700;
            margin: 0;
        }

        .loan-subtitle {
            font-size: 13px;
            color: rgba(255,255,255,.9);
            margin-top: 8px;
        }

        .loan-panel {
            background: #fff;
            border: 1px solid #dce5ec;
            border-radius: 8px;
            box-shadow: 0 10px 24px rgba(31, 51, 71, 0.06);
            margin-bottom: 18px;
        }

        .loan-panel-header {
            padding: 16px 18px;
            border-bottom: 1px solid #e7edf2;
        }

        .loan-panel-title {
            font-size: 16px;
            font-weight: 700;
            margin: 0;
        }

        .loan-panel-body {
            padding: 18px;
        }

        .loan-form-grid {
            display: grid;
            grid-template-columns: repeat(4,minmax(0,1fr));
            gap: 15px;
        }

        .loan-field label {
            display: block;
            font-size: 12px;
            font-weight: 700;
            margin-bottom: 6px;
            color: #46596b;
        }

        .loan-field .form-control {
            border-radius: 6px;
            min-height: 38px;
        }

        .loan-action-row {
            margin-top: 18px;
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }

        .loan-btn {
            min-width: 120px;
        }

        .loan-table-wrap {
            padding: 18px;
            overflow-x: auto;
        }

        #tblLoanTrackingHistory {
            width: 100% !important;
        }

        #tblLoanTrackingHistory thead th {
            background: #edf3f6 !important;
            font-size: 12px;
            white-space: nowrap;
        }

        #tblLoanTrackingHistory tbody td {
            font-size: 12px;
        }

       .loading {
    align-items: center;
    background: rgba(255,255,255,0.92);
    border: 1px solid #dce5ec;
    border-radius: 8px;
    box-shadow: 0 18px 40px rgba(20, 33, 45, 0.18);
    color: #263747;
    display: none;
    font-size: 12px;
    font-weight: 700;
    left: 50%;
    min-width: 220px;
    padding: 18px;
    position: fixed;
    text-align: center;
    top: 42%;
    transform: translate(-50%, -50%);
    z-index: 99999;
}

    .loading img {
        display: block;
        margin: 0 auto 10px;
        max-width: 44px;
    }
        @media(max-width:991px) {
            .loan-form-grid {
                grid-template-columns: repeat(2,minmax(0,1fr));
            }
        }

        @media(max-width:767px) {

            .loan-hero {
                flex-direction: column;
                align-items: flex-start;
            }

            .loan-form-grid {
                grid-template-columns: 1fr;
            }
        }

    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="load1" class="loading">
        <img src="../images/Load_1.gif" />
        <div>Please wait...</div>
    </div>

    <div class="loan-page">

        <div class="loan-hero">

            <div>

                <div class="loan-kicker">
                    Tracking
                </div>

                <h1 class="loan-title">
                    <i class="fas fa-history mr-2"></i>
                    Loan Tracking History
                </h1>

                <div class="loan-subtitle">
                    Project wise loan tracking history with dynamic columns.
                </div>

            </div>

        </div>

        <div class="loan-panel">

            <div class="loan-panel-header">
                <h2 class="loan-panel-title">
                    <i class="fas fa-filter mr-2"></i>
                    Search Filters
                </h2>
            </div>

            <div class="loan-panel-body">

                <div class="loan-form-grid">

                    <div class="loan-field">

                        <label>Project #</label>

                        <select id="ddlProject"
                            class="form-control">
                        </select>

                    </div>

                    <div class="loan-field">

                        <label>From Date</label>

                        <input type="date"
                            id="txtFromDate"
                            class="form-control" />

                    </div>

                    <div class="loan-field">

                        <label>To Date</label>

                        <input type="date"
                            id="txtToDate"
                            class="form-control" />

                    </div>

                    <div class="loan-field">

                        <label>&nbsp;</label>

                        <div>

                            <button type="button"
                                id="btnSearch"
                                class="btn btn-success loan-btn">

                                <i class="fas fa-search"></i>
                                Search

                            </button>

                            <button type="button"
                                id="btnReset"
                                class="btn btn-secondary loan-btn">

                                <i class="fas fa-rotate-left"></i>
                                Reset

                            </button>

                        </div>

                    </div>

                </div>

                <div class="loan-action-row" style="display:none;">

                    <button type="button"
                        id="btnExport"
                        class="btn btn-primary loan-btn">

                        <i class="fas fa-file-excel"></i>
                        Export Excel

                    </button>

                </div>

            </div>

        </div>

        <div class="loan-panel">

            <div class="loan-panel-header">

                <h2 class="loan-panel-title">

                    <i class="fas fa-table mr-2"></i>

                    Loan Tracking History

                </h2>

            </div>

            <div class="loan-table-wrap">

                <table id="tblLoanTrackingHistory"
                    class="table table-bordered table-striped">
                </table>

            </div>

        </div>

    </div>
</asp:Content>
