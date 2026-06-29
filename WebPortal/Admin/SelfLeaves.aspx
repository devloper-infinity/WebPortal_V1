<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="SelfLeaves.aspx.cs" Inherits="WebPortal.Admin.SelfLeaves" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --sl-primary: #2563eb;
            --sl-primary-dark: #1d4ed8;
            --sl-accent: #06b6d4;
            --sl-success: #16a34a;
            --sl-warning: #f59e0b;
            --sl-danger: #ef4444;
            --sl-bg: #f6f8fc;
            --sl-card: #ffffff;
            --sl-text: #0f172a;
            --sl-muted: #64748b;
            --sl-border: #e2e8f0;
            --sl-shadow: 0 18px 45px rgba(15, 23, 42, .08);
            --sl-radius: 22px;
        }

        .self-leaves-page {
            background: var(--sl-bg);
            min-height: calc(100vh - 80px);
            /*padding: 22px 18px 36px;*/
        }

        .self-leaves-shell {
            max-width: 1320px;
            margin: 0 auto;
        }

        .sl-hero {
            position: relative;
            overflow: hidden;
            border-radius: 15px;
            padding: 15px;
            color: #fff;
            background: radial-gradient(circle at 92% 12%, rgba(255,255,255,.28), transparent 24%), linear-gradient(135deg, #1e3a8a 0%, #2563eb 54%, #06b6d4 100%);
            box-shadow: var(--sl-shadow);
            margin-bottom: 22px;
        }

            .sl-hero:after {
                content: "";
                position: absolute;
                right: -70px;
                bottom: -90px;
                width: 260px;
                height: 260px;
                border-radius: 50%;
                background: rgba(255, 255, 255, .16);
            }

        .sl-kicker {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 7px 12px;
            border-radius: 999px;
            background: rgba(255,255,255,.18);
            backdrop-filter: blur(8px);
            font-size: 12px;
            font-weight: 700;
            letter-spacing: .04em;
            text-transform: uppercase;
        }

        .sl-hero h1 {
            margin: 14px 0 7px;
            font-size: clamp(15px, 3vw, 15px);
            font-weight: 800;
        }

        .sl-hero p {
            margin: 0;
            max-width: 720px;
            color: rgba(255,255,255,.86);
            font-size: 12px;
        }

        .sl-card {
            border: 1px solid rgba(226, 232, 240, .8);
            border-radius: var(--sl-radius);
            background: var(--sl-card);
            box-shadow: var(--sl-shadow);
            overflow: hidden;
            margin-bottom: 22px;
        }

        .sl-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            padding: 20px 24px;
            border-bottom: 1px solid var(--sl-border);
            background: linear-gradient(180deg, #fff, #f8fafc);
        }

        .sl-title-wrap {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .sl-icon {
            width: 44px;
            height: 44px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 14px;
            color: #fff;
            background: linear-gradient(135deg, var(--sl-primary), var(--sl-accent));
            box-shadow: 0 10px 24px rgba(37, 99, 235, .24);
            flex: 0 0 auto;
        }

        .sl-card-header h2 {
            margin: 0;
            color: var(--sl-text);
            font-size: 18px;
            font-weight: 800;
        }

        .sl-card-header span {
            display: block;
            color: var(--sl-muted);
            font-size: 13px;
            margin-top: 2px;
        }

        .sl-card-body {
            padding: 24px;
        }

        .sl-form-grid {
            display: grid;
            grid-template-columns: repeat(12, minmax(0, 1fr));
            gap: 18px;
        }

        .sl-field {
            grid-column: span 3;
        }

        .sl-field-wide {
            grid-column: span 9;
        }

        .sl-field-action {
            grid-column: span 3;
            display: flex;
            align-items: end;
        }

        .sl-label {
            display: block;
            color: #334155;
            font-size: 13px;
            font-weight: 800 !important;
            margin-bottom: 8px;
            border: none !important;
        }

        .self-leaves-page .form-control,
        .self-leaves-page select,
        .self-leaves-page textarea {
            min-height: 44px;
            border: 1px solid var(--sl-border);
            border-radius: 14px;
            color: var(--sl-text);
            background-color: #fff;
            box-shadow: none;
            transition: border-color .2s ease, box-shadow .2s ease, transform .2s ease;
        }

            .self-leaves-page textarea.form-control {
                min-height: 96px;
                resize: vertical;
            }

            .self-leaves-page .form-control:focus,
            .self-leaves-page select:focus,
            .self-leaves-page textarea:focus {
                border-color: rgba(37, 99, 235, .55);
                box-shadow: 0 0 0 4px rgba(37, 99, 235, .12);
            }

        .sl-help-text {
            margin-top: 6px;
            color: var(--sl-muted);
            font-size: 12px;
        }

        .sl-submit-btn,
        #selfleave_btnsubmit,
        #btnMessage {
            min-height: 46px;
            border: 0;
            border-radius: 14px;
            padding: 11px 18px;
            color: #fff;
            font-weight: 800;
            letter-spacing: .01em;
            background: linear-gradient(135deg, var(--sl-primary), var(--sl-accent));
            box-shadow: 0 12px 24px rgba(37, 99, 235, .22);
            transition: transform .18s ease, box-shadow .18s ease, filter .18s ease;
        }

            .sl-submit-btn:hover,
            #selfleave_btnsubmit:hover,
            #btnMessage:hover {
                transform: translateY(-1px);
                filter: brightness(1.03);
                box-shadow: 0 16px 30px rgba(37, 99, 235, .28);
            }

        .sl-table-card .sl-card-body {
            padding: 0;
        }

        .sl-table-toolbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 18px 24px;
            border-bottom: 1px solid var(--sl-border);
        }

        .sl-table-wrap {
            padding: 0 18px 18px;
        }

        #selfleave_table {
            width: 100% !important;
            border-collapse: separate !important;
            border-spacing: 0 10px !important;
            margin-top: 8px !important;
        }

            #selfleave_table thead th {
                border: 0 !important;
                color: #475569;
                background: #f8fafc !important;
                font-size: 12px;
                font-weight: 800;
                text-transform: uppercase;
                letter-spacing: .04em;
                white-space: nowrap;
                /*  padding: 14px 14px !important;*/
            }

            #selfleave_table tbody tr {
                background: #fff;
                box-shadow: 0 8px 20px rgba(15, 23, 42, .05);
            }

            #selfleave_table tbody td {
                border-top: 1px solid var(--sl-border) !important;
                border-bottom: 1px solid var(--sl-border) !important;
                color: #334155;
                /*     padding: 14px !important;*/
                vertical-align: middle;
                background: #fff !important;
            }

                #selfleave_table tbody td:first-child {
                    border-left: 1px solid var(--sl-border) !important;
                    border-radius: 14px 0 0 14px;
                }

                #selfleave_table tbody td:last-child {
                    border-right: 1px solid var(--sl-border) !important;
                    border-radius: 0 14px 14px 0;
                }

        .dataTables_wrapper {
            padding-top: 8px;
        }

        .dataTables_filter {
            padding: 0 0 12px;
        }

            .dataTables_filter label {
                color: var(--sl-muted);
                font-weight: 700 !important;
            }

            .dataTables_filter input {
                border: 1px solid var(--sl-border) !important;
                border-radius: 12px !important;
                /*  padding: 8px 12px !important;*/
                margin-left: 8px !important;
            }

        .dataTables_paginate {
            float: left !important;
            margin-top: 12px !important;
        }

        .dataTables_info {
            color: var(--sl-muted);
            padding-top: 18px !important;
        }

        .page-link {
            border-radius: 10px !important;
            margin: 0 3px;
            border-color: var(--sl-border);
        }

        .page-item.active .page-link {
            background: var(--sl-primary);
            border-color: var(--sl-primary);
        }

        div.dt-buttons {
            position: static;
            padding-left: 12px;
            float: left;
        }

        .buttons-excel, .buttons-html5 {
            color: #fff !important;
            border: 0 !important;
            border-radius: 12px !important;
            padding: 8px 14px !important;
            font-weight: 800 !important;
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            box-shadow: 0 10px 20px rgba(22, 163, 74, .2) !important;
            margin: 0 8px !important;
            margin-bottom: -20px!important;
        }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 99999;
            background: rgba(15, 23, 42, .32);
            backdrop-filter: blur(4px);
            align-items: center;
            justify-content: center;
            width: auto;
            height: auto;
            margin: 0;
            opacity: 1;
            border-radius: 0;
        }

        .sl-loader-box {
            width: 210px;
            min-height: 160px;
            border-radius: 24px;
            background: #fff;
            box-shadow: 0 24px 60px rgba(15, 23, 42, .22);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 12px;
            color: var(--sl-text);
            font-weight: 800;
        }

        .sl-spinner {
            width: 54px;
            height: 54px;
            border: 5px solid #dbeafe;
            border-top-color: var(--sl-primary);
            border-radius: 50%;
            animation: sl-spin .85s linear infinite;
        }

        @keyframes sl-spin {
            to {
                transform: rotate(360deg);
            }
        }

        #slefleave_waitingpanel .modal-dialog {
            min-height: 80vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

            #slefleave_waitingpanel .modal-dialog img {
                width: 80px;
            }

        #slefleave_waitingpanel span {
            text-shadow: 0 2px 8px rgba(0,0,0,.35);
        }

        #selfleave_dverror .modal-content {
            border: 0;
            border-radius: 20px;
            box-shadow: 0 24px 60px rgba(15, 23, 42, .22);
            overflow: hidden;
        }

        #selfleave_dverror .modal-header {
            border: 0;
            padding: 22px 22px 8px;
        }

        #selfleave_dverror .modal-title {
            color: var(--sl-text);
            font-weight: 800;
            line-height: 1.45;
        }

        #selfleave_dverror .modal-footer {
            border: 0;
            justify-content: center;
            padding: 10px 22px 22px;
        }

        @media (max-width: 991.98px) {
            .sl-field {
                grid-column: span 6;
            }

            .sl-field-wide {
                grid-column: span 12;
            }

            .sl-field-action {
                grid-column: span 12;
            }
        }

        @media (max-width: 575.98px) {
            .self-leaves-page {
                padding: 14px 10px 28px;
            }

            .sl-hero, .sl-card-body, .sl-card-header, .sl-table-toolbar {
                padding: 18px;
            }

            .sl-field {
                grid-column: span 12;
            }

            .sl-table-wrap {
                padding: 0 10px 14px;
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            selfleave_load();
        });

        document.addEventListener("DOMContentLoaded", function () {
            let tomorrow = new Date();
            tomorrow.setDate(tomorrow.getDate() + 1);

            const minDate = tomorrow.toISOString().split("T")[0];
            document.getElementById("selfleave_fromdate").setAttribute("min", minDate);
        });


        function selfleave_load() {
            selfleave_bindgrid();
            $.ajax({
                type: "POST", url: "SelfLeaves.aspx/BindInformation", dataType: "json", contentType: "application/json",
                success: function (res1) {
                    var dataArray = JSON.parse(res1.d);
                    $.each(dataArray, function (data1, value1) {
                        selfleave_empId = value1.EmployeeID;
                        selfleave_branch = value1.WorkingBranch;
                    });
                }
            });
        }
    </script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="../Scripts/Functions/Leaves.js?v=@DateTime.Now.Ticks"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <div class="sl-loader-box">
            <div class="sl-spinner"></div>
            <div>One moment, please...</div>
        </div>
    </div>

    <div class="self-leaves-page">
        <div class="self-leaves-shell">
            <section class="sl-hero">
                <h1><i class="fa fa-calendar"></i>&nbsp;Add Leaves</h1>
                <p>Submit a leave request with type, duration, dates, and reason. Your previous leave requests and approval status are listed below.</p>
            </section>

            <section class="sl-card">
                <div class="sl-card-header">
                    <div class="sl-title-wrap">
                        <div class="sl-icon"><i class="fas fa-plus"></i></div>
                        <div>
                            <h6>New Leave Request</h6>
                            <span>Fill all required details before submitting.</span>
                        </div>
                    </div>
                </div>

                <div class="sl-card-body">
                    <div class="sl-form-grid">
                        <div class="sl-field">
                            <label class="sl-label" for="selfleave_leavetype">Leave Type</label>
                            <select id="selfleave_leavetype" name="selfleave_leavetype" class="form-control" required>
                                <option value="">Select leave type</option>
                                <option value="Personal">Personal</option>
                                <option value="Sick">Sick</option>
                                <option value="Casual">Casual</option>
                                <option value="Maternity/Paternity">Maternity/Paternity</option>
                                <option value="Marriage">Marriage</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>

                        <div class="sl-field">
                            <label class="sl-label" for="selfleave_days">Days</label>
                            <select id="selfleave_days" name="selfleave_days" class="form-control" onchange="return selfleave_validatedates();" required>
                                <option value="0">Select days</option>
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="4">4</option>
                                <option value="5">5</option>
                                <option value="6">6</option>
                                <option value="7">7</option>
                                <option value="8">8</option>
                                <option value="9">9</option>
                                <option value="10">10</option>
                                <option value="11">11</option>
                                <option value="12">12</option>
                                <option value="13">13</option>
                                <option value="14">14</option>
                                <option value="15">15</option>
                                <option value="16">16</option>
                                <option value="17">17</option>
                                <option value="18">18</option>
                                <option value="19">19</option>
                                <option value="20">20</option>
                            </select>
                        </div>

                        <div class="sl-field">
                            <label class="sl-label" for="selfleave_fromdate">From Date</label>
                            <input type="date" id="selfleave_fromdate" name="selfleave_fromdate" class="form-control" onchange="return selfleave_validatedates();" />
                            <div class="sl-help-text">Date must be from tomorrow onward.</div>
                        </div>

                        <div class="sl-field">
                            <label class="sl-label" for="selfleave_todate">To Date</label>
                            <input type="date" id="selfleave_todate" name="selfleave_todate" class="form-control" readonly />
                            <div class="sl-help-text">Auto-calculated from selected days.</div>
                        </div>

                        <div class="sl-field-wide">
                            <label class="sl-label" for="selfleave_reason">Reason</label>
                            <textarea id="selfleave_reason" name="selfleave_reason" class="form-control" placeholder="Enter the reason for your leave request" required></textarea>
                        </div>

                        <div class="sl-field-action">
                            <button id="selfleave_btnsubmit" class="btn sl-submit-btn w-100" onclick="return selfleave_Submit();">
                                <i class="fas fa-paper-plane"></i>&nbsp; Submit Request
                           
                            </button>
                        </div>
                    </div>
                </div>
            </section>

            <section class="sl-card sl-table-card">
                <div class="sl-table-toolbar">
                    <div class="sl-title-wrap">
                        <div class="sl-icon"><i class="fas fa-list"></i></div>
                        <div>
                            <h6>Leave History</h6>
                            <span>Track submitted requests and current approval status.</span>
                        </div>
                    </div>
                </div>

                <div class="sl-card-body">
                    <div class="sl-table-wrap">
                        <table class="table" id="selfleave_table" style="width: 100%;" data-order="">
                            <thead>
                                <tr>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Leave Type</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;"># of days</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">From Date</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">To Date</th>
                                    <th class="sort border-top ps-3">Reason</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added Date</th>
                                    <th class="sort border-top ps-3">Status</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Status Updated By</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Status Updated Date</th>
                                    <th class="sort border-top ps-3">Remark</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </section>
        </div>
    </div>

    <div class="modal fade" id="slefleave_waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;">System is sending email notification. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>

    <div class="modal fade" id="selfleave_dverror">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="selfleave_errmsg"></h6>
                </div>
                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="btnMessage" onclick="return selfleave_Message();">Okay</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
