<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="InfinityFeedback.aspx.cs" Inherits="WebPortal.Admin.InfinityFeedback" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        body {
            background: #f3f6f8;
        }

        .inf-page {
            color: #16202a;
            padding-bottom: 28px;
        }

        .inf-hero {
            align-items: center;
            background: linear-gradient(135deg, #0f766e 0%, #1d4ed8 100%);
            border-radius: 8px;
            box-shadow: 0 14px 28px rgba(28, 58, 85, 0.16);
            color: #fff;
            display: flex;
            gap: 20px;
            justify-content: space-between;
            margin-bottom: 18px;
            padding: 22px 24px;
        }

        .inf-kicker {
            color: rgba(255,255,255,0.82);
            font-size: 12px;
            font-weight: 700;
            margin-bottom: 6px;
            text-transform: uppercase;
        }

        .inf-title {
            font-size: 24px;
            font-weight: 700;
            line-height: 1.2;
            margin: 0;
        }

        .inf-subtitle {
            color: rgba(255,255,255,0.88);
            font-size: 13px;
            margin: 8px 0 0;
            max-width: 760px;
        }

        .inf-hero-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: flex-end;
        }

        .inf-btn {
            align-items: center;
            border-radius: 6px;
            display: inline-flex;
            font-size: 13px;
            font-weight: 700;
            gap: 8px;
            justify-content: center;
            min-height: 38px;
            padding: 8px 14px;
        }

        .inf-btn-primary {
            background: #0f766e;
            border: 1px solid #0f766e;
            color: #fff;
        }

            .inf-btn-primary:hover,
            .inf-btn-primary:focus {
                background: #0b5f59;
                border-color: #0b5f59;
                color: #fff;
            }

        .inf-btn-light {
            background: rgba(255,255,255,0.96);
            border: 1px solid rgba(255,255,255,0.96);
            color: #17324d;
            text-decoration: none;
        }

            .inf-btn-light:hover,
            .inf-btn-light:focus {
                color: #0f766e;
                text-decoration: none;
            }

        .inf-panel {
            background: #fff;
            border: 1px solid #dce5ec;
            border-radius: 8px;
            box-shadow: 0 10px 24px rgba(31, 51, 71, 0.06);
            margin-bottom: 18px;
            overflow: hidden;
        }

        .inf-panel-header {
            align-items: center;
            border-bottom: 1px solid #e7edf2;
            display: flex;
            gap: 14px;
            justify-content: space-between;
            padding: 16px 18px;
        }

        .inf-panel-title {
            align-items: center;
            color: #172737;
            display: flex;
            font-size: 16px;
            font-weight: 700;
            gap: 9px;
            margin: 0;
        }

        .inf-panel-subtitle {
            color: #6d7f90;
            font-size: 12px;
            margin: 4px 0 0;
        }

        .inf-panel-body {
            padding: 18px;
        }

        .inf-filter-grid {
            align-items: end;
            display: grid;
            gap: 14px 16px;
            grid-template-columns: repeat(4, minmax(0, 1fr));
        }

        .inf-field {
            min-width: 0;
        }

            .inf-field label {
                color: #46596b;
                display: block;
                font-size: 12px;
                font-weight: 700 !important;
                margin-bottom: 6px;
            }

            .inf-field .form-control {
                border-color: #cfdbe5;
                border-radius: 6px;
                box-shadow: none;
                color: #172737;
                font-size: 13px;
                min-height: 38px;
                width: 100%;
            }

                .inf-field .form-control:focus {
                    border-color: #0f766e;
                    box-shadow: 0 0 0 3px rgba(15, 118, 110, 0.14);
                }

        .inf-table-wrap {
            overflow-x: auto;
            padding: 0 18px 18px;
        }

        #table_InfinityFeedback {
            border-collapse: separate !important;
            border-spacing: 0;
            margin: 0 !important;
            width: 100% !important;
        }

            #table_InfinityFeedback thead th {
                background: #edf3f6 !important;
                border-color: #d7e2ea !important;
                color: #263747;
                font-size: 12px;
                text-align: center;
                vertical-align: middle;
                white-space: nowrap;
            }

            #table_InfinityFeedback tbody td {
                background: #fff !important;
                border-color: #e2e9ef !important;
                color: #263747;
                font-size: 12px;
                vertical-align: middle;
            }

            #table_InfinityFeedback tbody tr:hover td {
                background: #f7fbfa !important;
            }

        .dataTables_length,
        .dataTables_info {
            float: left !important;
            font-size: 12px;
        }

        div.dt-buttons {
            float: left;
            padding-left: 18px;
            position: static;
        }

        .buttons-excel,
        .buttons-html5 {
            background: #0f766e !important;
            border: 0 !important;
            border-radius: 6px !important;
            box-shadow: none !important;
            color: #fff !important;
            font-weight: 700 !important;
            margin: 0 8px;
            min-height: 34px;
            padding: 7px 12px !important;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            border: none !important;
        }

        .modal-content {
            border: 0;
            border-radius: 8px;
            box-shadow: 0 18px 45px rgba(20, 33, 45, 0.22);
            overflow: hidden;
        }

        .modal-header {
            background: linear-gradient(135deg, #0f766e 0%, #1d4ed8 100%);
            border-bottom: 0;
            color: #fff;
        }

        .modal-title {
            font-size: 18px;
            font-weight: 700;
        }

        .modal-header .close {
            color: #fff;
            opacity: 1;
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

        @media (max-width: 1199px) {
            .inf-filter-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 767px) {
            .inf-hero,
            .inf-panel-header {
                align-items: flex-start;
                flex-direction: column;
            }

            .inf-hero-actions {
                align-items: stretch;
                flex-direction: column;
                width: 100%;
            }

            .inf-btn {
                width: 100%;
            }

            .inf-filter-grid {
                grid-template-columns: 1fr;
            }
        }

        #table_InfinityFeedback tbody tr.row-rebuttal td {
            background-color: #cceeff !important;
            font-weight: 600;
        }

        #table_InfinityFeedback tbody td.rebuttal-status {
            color: red !important;
            font-weight: 700 !important;
            text-align: center;
        }

        #table_InfinityFeedback tbody td.agree-status {
            color: green !important;
            font-weight: 700 !important;
            text-align: center;
        }
    </style>

    <script>       
        $(document).ready(function () {

            infinityfeecback_bindsubdomain();
        });

    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <input id="filep_ap" style="display: none;" />
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div>One moment, please . . . .</div>
    </div>

    <div class="inf-page">
        <div class="inf-hero">
            <div>
                <div class="inf-kicker">Quality Feedback</div>
                <h1 class="inf-title">
                    <i class="fas fa-comment-dots mr-2"></i>
                    Infinity Feedback
                </h1>
                <p class="inf-subtitle">
                    Search, review, export, and edit Infinity feedback records from a cleaner dashboard layout.
                </p>
            </div>
            <div class="inf-hero-actions">
                <a href="ImportFeedback.aspx" class="inf-btn inf-btn-light">
                    <i class="fas fa-file-import"></i>
                    Import Feedbacks
                </a>
                <a href="SyncInternalFeedback.aspx" class="inf-btn inf-btn-light">
                    <i class="fas fa-arrows-rotate"></i>
                    Sync Internal Feedbacks
                </a>
            </div>
        </div>

        <div class="inf-panel">
            <div class="inf-panel-header">
                <div>
                    <h2 class="inf-panel-title"><i class="fas fa-filter"></i>Search Filters</h2>
                    <div class="inf-panel-subtitle">Labels are placed above inputs for a modern, responsive filter area.</div>
                </div>
            </div>
            <div class="inf-panel-body">
                <div class="inf-filter-grid">
                    <div class="inf-field">
                        <label for="infFeedback_FromDate">From Date</label>
                        <input type="date" class="form-control" id="infFeedback_FromDate" name="infFeedback_FromDate" />
                    </div>
                    <div class="inf-field">
                        <label for="infFeedback_ToDate">To Date</label>
                        <input type="date" class="form-control" id="infFeedback_ToDate" name="infFeedback_ToDate" />
                    </div>
                    <div class="inf-field" id="tddomainhead">
                        <label for="inffeedback_domain">Domain</label>
                        <select id="inffeedback_domain" name="inffeedback_domain" class="form-control">
                            <option value="">Select</option>
                            <option value="Credit">Credit</option>
                            <option value="Servicing">Servicing</option>
                        </select>
                    </div>
                    <div class="inf-field" id="tddomainrow">
                        <button class="inf-btn inf-btn-primary" type="button" id="btnEditFeedbackShow" onclick="return btnEditFeedbackShowReport();">
                            <i class="fas fa-magnifying-glass"></i>
                            Show
                        </button>
                        <asp:Button ID="btnExportFeedback" runat="server" Text="Export Excel" CssClass="btn btn-success" Style="height: 37px;" OnClick="btnExportFeedback_Click" />
                    </div>
                </div>
            </div>
        </div>

        <div class="inf-panel">
            <div class="inf-panel-header">
                <div>
                    <h2 class="inf-panel-title"><i class="fas fa-table-list"></i>Feedback Records</h2>
                    <div class="inf-panel-subtitle">Use the action column to edit a selected feedback record.</div>
                </div>
            </div>
            <div class="inf-table-wrap">
                <table class="table" id="table_InfinityFeedback" style="width: 100%;">
                    <thead>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="popUpAddFeedbackUser">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title"><i class="fas fa-pen-to-square mr-2"></i>Edit Feedback</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <%-- Existing edit modal fields were commented in the original page. Kept intentionally blank so existing scripts/markup behavior remains unchanged. --%>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

