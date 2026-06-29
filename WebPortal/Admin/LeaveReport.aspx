<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="LeaveReport.aspx.cs" Inherits="WebPortal.Admin.LeaveReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --lr-primary: #1d4ed8;
            --lr-primary-2: #2563eb;
            --lr-cyan: #22c1dc;
            --lr-bg: #f4f7fb;
            --lr-card: #ffffff;
            --lr-text: #172033;
            --lr-muted: #64748b;
            --lr-border: #e4eaf3;
            --lr-soft: #eef6ff;
            --lr-shadow: 0 14px 35px rgba(15, 23, 42, .09);
        }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, .72);
            z-index: 99999;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            backdrop-filter: blur(2px);
        }

        .loading img {
            width: 72px;
            height: 72px;
        }

        .loading div {
            margin-top: 10px;
            font-size: 13px;
            font-weight: 700;
            color: var(--lr-primary);
        }

        .lr-page {
          /*  padding: 14px 12px 28px;*/
            background: var(--lr-bg);
            min-height: calc(100vh - 120px);
        }

        .lr-hero {
            position: relative;
            overflow: hidden;
            border-radius: 22px;
            padding: 22px 24px;
            margin-bottom: 18px;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%);
            color: #fff;
            box-shadow: var(--lr-shadow);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            flex-wrap: wrap;
        }

        .lr-hero:before {
            content: "";
            position: absolute;
            right: -80px;
            top: -90px;
            width: 240px;
            height: 240px;
            border-radius: 50%;
            background: rgba(255, 255, 255, .18);
        }

        .lr-hero-left {
            position: relative;
            display: flex;
            align-items: center;
            gap: 15px;
            z-index: 1;
        }

        .lr-hero-icon {
            width: 58px;
            height: 58px;
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255, 255, 255, .18);
            border: 1px solid rgba(255, 255, 255, .28);
            box-shadow: inset 0 1px 0 rgba(255, 255, 255, .18);
        }

        .lr-hero-icon i {
            font-size: 26px;
            color: #fff;
        }

        .lr-hero-title {
            margin: 0;
            font-size: 23px;
            font-weight: 800;
            letter-spacing: .2px;
        }

        .lr-hero-subtitle {
            margin: 4px 0 0;
            font-size: 13px;
            color: rgba(255, 255, 255, .86);
        }

        .lr-hero-chip {
            position: relative;
            z-index: 1;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 13px;
            border-radius: 999px;
            background: rgba(255, 255, 255, .16);
            border: 1px solid rgba(255, 255, 255, .24);
            color: #fff;
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
        }

        .lr-card {
            background: var(--lr-card);
            border: 1px solid var(--lr-border);
            border-radius: 20px;
            box-shadow: var(--lr-shadow);
            overflow: hidden;
        }

        .lr-card-head {
            padding: 16px 18px;
            border-bottom: 1px solid var(--lr-border);
            background: linear-gradient(180deg, #ffffff 0%, #f8fbff 100%);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            flex-wrap: wrap;
        }

        .lr-card-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0;
            color: var(--lr-text);
            font-size: 16px;
            font-weight: 800;
        }

        .lr-card-title i {
            color: var(--lr-primary);
        }

        .lr-filter-panel {
            padding: 18px;
        }

        .lr-filter-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(180px, 1fr));
            gap: 14px;
            align-items: end;
        }

        .lr-field label {
            display: block;
            margin-bottom: 7px;
            color: var(--lr-text);
            font-size: 12px;
            font-weight: 800 !important;
            border: none !important;
        }

        .lr-field .form-control {
            height: 42px;
            border-radius: 12px;
            border: 1px solid var(--lr-border);
            box-shadow: none;
            font-size: 13px;
        }

        .lr-field .form-control:focus {
            border-color: var(--lr-primary-2);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, .12);
        }

        .lr-action-wrap {
            display: flex;
            justify-content: flex-start;
            align-items: end;
        }

        .lr-btn {
            min-height: 42px;
            border: none;
            border-radius: 12px;
            padding: 10px 18px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            font-weight: 800;
            font-size: 13px;
            transition: all .2s ease;
            cursor: pointer;
        }

        .lr-btn-primary {
            color: #fff;
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            box-shadow: 0 10px 20px rgba(37, 99, 235, .25);
        }

        .lr-btn-primary:hover {
            transform: translateY(-1px);
            box-shadow: 0 14px 24px rgba(37, 99, 235, .32);
            color: #fff;
        }

        .lr-table-wrap {
            padding: 0 18px 18px;
        }

        .lr-table-shell {
            border: 1px solid var(--lr-border);
            border-radius: 16px;
            overflow: hidden;
            background: #fff;
        }

        .lr-scroll {
            width: 100%;
            overflow: auto;
        }

        .table.dataTable {
            margin: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0;
        }

        .table.dataTable thead th {
            background: #edf3f6 !important;
            color: #172033 !important;
            font-size: 12px;
            font-weight: 800;
            vertical-align: middle;
            height: 42px;
            border-bottom: 1px solid #d8e1ea !important;
            white-space: nowrap;
        }

        .table.dataTable tbody td {
            background: #fff !important;
            color: #263244;
            font-size: 12px;
            vertical-align: middle;
            border-color: #eef2f7 !important;
        }

        .table.dataTable tbody tr:hover td {
            background: #f8fbff !important;
        }

        #table_leaveDetails tfoot,
        #table_leaveDetails_1 tfoot {
            font-weight: 800;
            background-color: #f8fafc;
        }

        #filterRow th {
            background: #f8fafc !important;
            padding: 7px !important;
        }

        #filterRow input {
            width: 100%;
            height: 30px;
            min-width: 80px;
            padding: 4px 8px;
            border: 1px solid var(--lr-border);
            border-radius: 8px;
            outline: none;
            font-size: 11px;
            font-weight: 600;
        }

        #filterRow input:focus {
            border-color: var(--lr-primary-2);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, .10);
        }

        .dataTables_wrapper {
            padding: 12px;
        }

        .dataTables_length,
        .dataTables_info {
            float: left !important;
            font-size: 12px;
            color: var(--lr-muted);
        }

        div.dt-buttons {
            position: static;
            padding-left: 12px;
            float: left;
        }

        .buttons-excel,
        .buttons-html5 {
            box-shadow: none !important;
            background: linear-gradient(90deg, #16a34a 0%, #22c55e 100%) !important;
            border: 0 !important;
            border-radius: 10px !important;
            color: #fff !important;
            font-weight: 800 !important;
            margin: 0 8px !important;
            padding: 7px 13px !important;
        }

        .dataTables_filter input,
        .dataTables_length select {
            border: 1px solid var(--lr-border) !important;
            border-radius: 9px !important;
            padding: 5px 8px !important;
            outline: none !important;
        }

        .modal-content.lr-modal-content {
            border: none;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 24px 60px rgba(15, 23, 42, .22);
        }

        .lr-modal-header {
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%);
            color: #fff;
            border: none;
            padding: 16px 20px;
        }

        .lr-modal-title {
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 16px;
            font-weight: 800;
        }

        .lr-modal-title label {
            margin: 0;
            color: #fff;
            font-size: 15px !important;
            font-weight: 800 !important;
        }

        .lr-modal-header .close {
            color: #fff;
            opacity: 1;
            text-shadow: none;
        }

        .lr-modal-body {
            padding: 18px;
            background: #f8fbff;
        }

        .lr-modal-footer {
            border-top: 1px solid var(--lr-border);
            background: #fff;
            padding: 12px 18px;
        }

        @media (max-width: 991px) {
            .lr-filter-grid {
                grid-template-columns: repeat(2, minmax(160px, 1fr));
            }
        }

        @media (max-width: 575px) {
            .lr-page {
                padding: 10px 6px 20px;
            }

            .lr-hero {
                padding: 18px;
                border-radius: 18px;
            }

            .lr-hero-left {
                align-items: flex-start;
            }

            .lr-hero-title {
                font-size: 19px;
            }

            .lr-filter-grid {
                grid-template-columns: 1fr;
            }

            .lr-action-wrap .lr-btn {
                width: 100%;
            }
        }
    </style>

    <script type="text/javascript">
        $(document).ready(function () {
            // BindViewLeaveDetails_Grid();
        });
    </script>
    <script src="../Scripts/Functions/Leaves.js?v=@DateTime.Now.Ticks"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div>One moment, please . . . .</div>
    </div>

    <div class="lr-page">
        <div class="lr-hero">
            <div class="lr-hero-left">
                <div class="lr-hero-icon">
                    <i class="fas fa-calendar-check"></i>
                </div>
                <div>
                    <h1 class="lr-hero-title">Leave Detail Report</h1>
                    <p class="lr-hero-subtitle">View, filter and export employee leave details quickly.</p>
                </div>
            </div>
            <div class="lr-hero-chip">
                <i class="fas fa-file-alt"></i>
                Leave Analytics
            </div>
        </div>

        <div class="lr-card">
            <div class="lr-card-head">
                <h2 class="lr-card-title">
                    <i class="fas fa-filter"></i>
                    Report Filters
                </h2>
            </div>

            <div class="lr-filter-panel">
                <div class="lr-filter-grid">
                    <div class="lr-field">
                        <label for="leaveReport_FromDate">From Date</label>
                        <input type="date" id="leaveReport_FromDate" name="leaveReport_FromDate" class="form-control" />
                    </div>

                    <div class="lr-field">
                        <label for="leaveReport_ToDate">To Date</label>
                        <input type="date" id="leaveReport_ToDate" name="leaveReport_ToDate" class="form-control" />
                    </div>

                    <div class="lr-action-wrap">
                        <button class="lr-btn lr-btn-primary" type="button" id="leaveReport__Show" onclick="return BindViewLeaveDetails_Grid();">
                            <i class="fas fa-search"></i>
                            <span>Show Report</span>
                        </button>
                    </div>
                </div>
            </div>

            <div class="lr-table-wrap">
                <div class="lr-table-shell">
                    <div class="lr-scroll">
                        <table class="table table-bordered table-striped" id="table_leaveDetails" style="width: 100%;">
                            <thead>
                                <tr>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; width: 50px; text-align: center;">Sr. #</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; width: 50px;">Code</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Employee Name</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Branch</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Department</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Designation</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Domain</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Reporting Manager</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Leave Type</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Days</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; width: 80px;">Leave From</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; width: 80px;">Leave To</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Leave Status</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Actual Days</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Paid</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Un-Paid</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; width: 300px;">Reason For Leave</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; width: 400px;">Approval Remark</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Approved By</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Approved Date</th>
                                </tr>
                                <tr class="filters" id="filterRow">
                                    <th></th>
                                    <th><input type="text" placeholder="Search" /></th>
                                    <th><input type="text" placeholder="Search" /></th>
                                    <th><input type="text" placeholder="Search" /></th>
                                    <th><input type="text" placeholder="Search" /></th>
                                    <th><input type="text" placeholder="Search" /></th>
                                    <th><input type="text" placeholder="Search" /></th>
                                    <th><input type="text" placeholder="Search" /></th>
                                    <th><input type="text" placeholder="Search" /></th>
                                    <th><input type="text" placeholder="Search" /></th>
                                    <th><input type="text" placeholder="Search" /></th>
                                    <th><input type="text" placeholder="Search" /></th>
                                    <th><input type="text" placeholder="Search" /></th>
                                    <th><input type="text" placeholder="Search" /></th>
                                    <th><input type="text" placeholder="Search" /></th>
                                    <th><input type="text" placeholder="Search" /></th>
                                    <th><input type="text" placeholder="Search" /></th>
                                    <th><input type="text" placeholder="Search" /></th>
                                    <th><input type="text" placeholder="Search" /></th>
                                    <th><input type="text" placeholder="Search" /></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                            <tfoot>
                                <tr>
                                    <th colspan="8"></th>
                                    <th style="text-align: left;">Total :</th>
                                    <th style="text-align: center;"></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th style="text-align: center;"></th>
                                    <th style="text-align: center;"></th>
                                    <th style="text-align: center;"></th>
                                    <th colspan="4"></th>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>

                <table class="table table-bordered table-striped" id="table_leaveReport_1" style="width: 100%; display: none;">
                    <thead>
                        <tr>
                            <th class="sort border-top" style="text-wrap: nowrap;">Action</th>
                            <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Code</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Leave Type</th>
                            <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Days</th>
                            <th class="sort border-top" style="text-wrap: nowrap; width: 80px;">Leave From</th>
                            <th class="sort border-top" style="text-wrap: nowrap; width: 80px;">Leave To</th>
                            <th class="sort border-top" style="text-wrap: nowrap; width: 400px;">Reason For Leave</th>
                            <th class="sort border-top" style="text-wrap: nowrap; width: 400px;">Approval Remark</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Approved By</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Approved Date</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                    <tfoot>
                        <tr>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="popUpViewLeaveDetails">
        <div class="modal-dialog modal-xl">
            <div class="modal-content lr-modal-content">
                <div class="modal-header lr-modal-header">
                    <h1 class="modal-title lr-modal-title">
                        <i class="fas fa-user-clock"></i>
                        <label id="leaveReport_empInfo" name="leaveReport_empInfo"></label>
                    </h1>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body lr-modal-body">
                    <div class="lr-table-shell">
                        <div class="lr-scroll">
                            <table class="table table-bordered table-striped" id="table_leaveDetails_1" style="width: 100%;">
                                <thead>
                                    <tr>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">Leave Type</th>
                                        <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Days</th>
                                        <th class="sort border-top" style="text-wrap: nowrap; width: 80px;">Leave From</th>
                                        <th class="sort border-top" style="text-wrap: nowrap; width: 80px;">Leave To</th>
                                        <th class="sort border-top" style="text-wrap: nowrap; width: 300px;">Reason For Leave</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">Leave Status</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">Actual Days</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">Paid</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">Un-Paid</th>
                                        <th class="sort border-top" style="text-wrap: nowrap; width: 400px;">Approval Remark</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">Approved By</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">Approved Date</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                                <tfoot>
                                    <tr>
                                        <th colspan="2" style="text-align: right">Total:</th>
                                        <th style="text-align: center"></th>
                                        <th></th>
                                        <th></th>
                                        <th></th>
                                        <th></th>
                                        <th style="text-align: center"></th>
                                        <th style="text-align: center"></th>
                                        <th style="text-align: center"></th>
                                        <th></th>
                                        <th></th>
                                        <th></th>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="modal-footer lr-modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">
                        <i class="fas fa-times"></i> Close
                    </button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
