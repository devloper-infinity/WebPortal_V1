<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AttendanceCorrectionSelf.aspx.cs" Inherits="WebPortal.Admin.AttendanceCorrectionSelf" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

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

        .dataTables_scrollBody {
            min-height: 100px !important;
            height: auto;
        }

        .dataTables_length, .dataTables_info {
            float: left !important;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: normal !important;
            border: none !important;
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
            /*    background: linear-gradient(to bottom, #007bff, 3%, #fff) !important;*/
            color: #000;
        }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
        }



        /*.form-control {
            font-size: 11px !important;
        }*/
    </style>
    <script>
        $(document).ready(function () {
            getattendancecountSelf();
            selfatt_bindReasons();
            selfatt_BindGrid();
        });
        function getattendancecountSelf() {
            PageMethods.getAttendanceCount(attcountself_OnSuccess, attcountself_OnError);
            return false;
        }
        function attcountself_OnSuccess(result) {
            if (result >= 4) {
                document.getElementById("tblselfatt").style.display = 'none';
                alert("You have already exceeded maximum number of attendance correction request limit.!");
            }
            else {
                document.getElementById("tblselfatt").style.display = '';

            }

            return false;
        }

        function attcountself_OnError(error) {
            alert(error.get_message());
        }

    </script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>


    <style>
        :root {
            --ac-primary: #2454d6;
            --ac-primary-2: #2f7cf6;
            --ac-cyan: #36c4df;
            --ac-bg: #f5f7fb;
            --ac-card: #ffffff;
            --ac-text: #172033;
            --ac-muted: #667085;
            --ac-border: #e6eaf2;
            --ac-success: #16a34a;
            --ac-warning: #f59e0b;
            --ac-danger: #ef4444;
            --ac-radius: 20px;
            --ac-shadow: 0 14px 35px rgba(15,23,42,.08);
        }

        body {
            background: var(--ac-bg) !important;
            color: var(--ac-text);
        }

        .content-header {
            display: none !important;
        }

        .ac-page {
            padding: 10px 6px 28px;
        }

        .ac-hero {
            position: relative;
            overflow: hidden;
            border-radius: 15px;
            background: linear-gradient(135deg,#2442a6 0%,#2563eb 48%,#3ec7df 100%);
            color: #fff;
            padding: 15px;
            margin: 0 0 22px;
            box-shadow: 0 18px 45px rgba(37,99,235,.22);
        }

            .ac-hero:before {
                content: "";
                position: absolute;
                right: -70px;
                top: -90px;
                width: 310px;
                height: 310px;
                border-radius: 50%;
                background: rgba(255,255,255,.18);
            }

            .ac-hero:after {
                content: "";
                position: absolute;
                left: 30%;
                bottom: -80px;
                width: 190px;
                height: 190px;
                border-radius: 50%;
                background: rgba(255,255,255,.08);
            }

        .ac-hero-content {
            position: relative;
            z-index: 1;
            max-width: 760px;
        }

        .ac-pill {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 7px 14px;
            border-radius: 999px;
            background: rgba(255,255,255,.18);
            font-size: 12px;
            font-weight: 800;
            letter-spacing: .35px;
            text-transform: uppercase;
        }

        .ac-hero h1 {
            margin: 14px 0 8px;
            font-size: clamp(25px,2.2vw,32px);
            line-height: 1.15;
            font-weight: 800;
            font-size: 20px;
        }

        .ac-hero p {
            margin: 0;
            max-width: 640px;
            color: rgba(255,255,255,.92);
            font-size: 13px;
            line-height: 1.65;
            font-weight: 600;
        }

        .ac-stats {
            display: grid;
            grid-template-columns: repeat(4,minmax(0,1fr));
            gap: 14px;
            margin: 0 0 20px;
        }

        .ac-stat {
            background: var(--ac-card);
            border: 1px solid var(--ac-border);
            border-radius: 18px;
            padding: 16px 18px;
            box-shadow: var(--ac-shadow);
            display: flex;
            align-items: center;
            gap: 13px;
        }

        .ac-stat-icon {
            width: 42px;
            height: 42px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg,rgba(37,99,235,.12),rgba(54,196,223,.16));
            color: var(--ac-primary);
            font-size: 18px;
        }

        .ac-stat label {
            /*  display: block;*/
            margin: 0;
            color: var(--ac-muted);
            font-size: 12px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: .25px;
        }

        .ac-stat strong {
            display: block;
            margin-top: 3px;
            font-size: 20px;
            color: var(--ac-text);
        }

        .card, .box, .panel, .white-box {
            border: 1px solid var(--ac-border) !important;
            border-radius: var(--ac-radius) !important;
            box-shadow: var(--ac-shadow) !important;
            background: var(--ac-card) !important;
            overflow: hidden;
        }

        .card-header, .box-header, .panel-heading {
            background: #fff !important;
            border-bottom: 1px solid var(--ac-border) !important;
            padding: 18px 22px !important;
        }

        .card-body, .box-body, .panel-body {
            padding: 22px !important;
        }

        .form-control, select, input[type="text"], input[type="date"], input[type="time"], textarea {
            border: 1px solid #d8deea !important;
            border-radius: 13px !important;
            min-height: 42px;
            box-shadow: none !important;
            transition: .2s ease;
        }

            .form-control:focus, select:focus, input:focus, textarea:focus {
                border-color: var(--ac-primary-2) !important;
                box-shadow: 0 0 0 4px rgba(37,99,235,.12) !important;
            }

        label {
            color: #344054;
            font-size: 13px;
            font-weight: 800;
            margin-bottom: 7px;
        }

        .btn, .buttons-excel, .buttons-html5, input[type="submit"], button {
            border-radius: 13px !important;
            font-weight: 800 !important;
            min-height: 40px;
            border: 0 !important;
        }

        .btn-primary, .buttons-excel, .buttons-html5, input[type="submit"] {
            background: linear-gradient(135deg,var(--ac-primary),var(--ac-primary-2)) !important;
            color: #fff !important;
            box-shadow: 0 10px 20px rgba(37,99,235,.20);
            font-size: 15px;
        }

        .btn-secondary, .btn-default {
            background: #eef2f7 !important;
            color: #344054 !important;
        }

        .table-responsive {
            border-radius: 18px;
            overflow: auto;
        }

        table.dataTable, .table {
            width: 100% !important;
            border-collapse: separate !important;
            border-spacing: 0 !important;
        }

            .table thead th, table.dataTable thead th {
                background: #f1f5fb !important;
                color: #344054 !important;
                border-bottom: 1px solid var(--ac-border) !important;
                font-size: 12px !important;
                font-weight: 900 !important;
                text-transform: uppercase;
                letter-spacing: .25px;
                /* padding: 13px 14px !important;*/
                white-space: nowrap;
            }

            .table tbody td, table.dataTable tbody td {
                padding: 12px 14px !important;
                border-top: 1px solid #edf1f7 !important;
                color: #344054;
                vertical-align: middle !important;
            }

            .table tbody tr:hover, table.dataTable tbody tr:hover {
                background: #f8fbff !important;
            }

        .dataTables_wrapper .dataTables_filter input {
            border: 1px solid #d8deea !important;
            border-radius: 999px !important;
            padding: 9px 14px !important;
            margin-left: 8px;
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button {
            border-radius: 10px !important;
            border: 1px solid var(--ac-border) !important;
            margin: 0 2px !important;
        }

            .dataTables_wrapper .dataTables_paginate .paginate_button.current {
                background: var(--ac-primary) !important;
                color: #fff !important;
            }

        .badge, .label {
            border-radius: 999px !important;
            padding: 6px 10px !important;
            font-weight: 800 !important;
        }

        .status-approved, .badge-success {
            background: #dcfce7 !important;
            color: #166534 !important;
        }

        .status-pending, .badge-warning {
            background: #fef3c7 !important;
            color: #92400e !important;
        }

        .status-rejected, .badge-danger {
            background: #fee2e2 !important;
            color: #991b1b !important;
        }

        #load, #load1, .loader {
            border-radius: 18px !important;
        }

        @media(max-width:992px) {
            .ac-stats {
                grid-template-columns: repeat(2,minmax(0,1fr));
            }

            .ac-hero {
                padding: 24px 22px;
                border-radius: 22px;
            }
        }

        @media(max-width:576px) {
            .ac-stats {
                grid-template-columns: 1fr;
            }

            .ac-hero h1 {
                font-size: 24px;
            }
        }
    </style>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="ac-page">
        <section class="ac-hero">
            <div class="ac-hero-content">

                <h1><i class="fas fa-clock"></i>&nbsp;Attendance Correction</h1>
                <p>Submit correction requests, review previous entries, and track approval status in one clean workspace.</p>
            </div>
        </section>

        <section class="ac-stats">
            <div class="ac-stat">
                  <div class="ac-stat-icon"><i class="fa fa-ticket"></i></div>
                <div>
                    <label>Requests</label><strong id="acTotalRequests"></strong>
                </div>
            </div>
            <div class="ac-stat">
                <div class="ac-stat-icon"><i class="fa fa-hourglass-half"></i></div>
                <div>
                    <label>Pending</label><strong id="acPendingRequests"></strong>
                </div>
            </div>
            <div class="ac-stat">
                <div class="ac-stat-icon"><i class="fa fa-check"></i></div>
                <div>
                    <label>Approved</label><strong id="acApprovedRequests"></strong>
                </div>
            </div>
            <div class="ac-stat">
                <div class="ac-stat-icon"><i class="fa fa-times"></i></div>
                <div>
                    <label>Rejected</label><strong id="acRejectedRequests"></strong>
                </div>
            </div>
        </section>

        <div class="col-lg-12">
            <div class="card">
                <div class="card-body">

                    <div class="attendance-card">

                        <div class="attendance-grid">

                            <div class="form-group">
                                <label>Reason Type</label>
                                <select id="selfatt_reason" class="form-control"
                                    onchange="return selfatt_getIndates(this);">
                                </select>
                            </div>

                            <div class="form-group">
                                <label>In Date</label>
                                <select id="selfatt_indate" class="form-control"
                                    onchange="return selfatt_getInTime(this);">
                                </select>
                            </div>

                            <div class="form-group">
                                <label>In Time</label>
                                <input type="time" id="selfatt_intime"
                                    class="form-control"
                                    onchange="return checkcutofftimetovalidate(this);" />
                            </div>

                            <div class="form-group">
                                <label>Out Date</label>
                                <select id="selfatt_outdate" class="form-control"></select>
                            </div>

                            <div class="form-group">
                                <label>Out Time</label>
                                <input type="time" id="selfatt_outtime"
                                    class="form-control"
                                    onchange="return selfatt_GetTotalHours();" />
                            </div>

                            <div class="form-group">
                                <label>Total Hours</label>
                                <input type="text" id="selfatt_totaltime"
                                    class="form-control" readonly style="background-color: white; font-weight: bold;" />
                            </div>

                            <!-- Full Width Reason -->
                            <div class="form-group full-width">
                                <label>Reason</label>
                                <textarea id="selfatt_userreason"
                                    class="form-control"
                                    rows="4"
                                    placeholder="Enter attendance correction reason..."></textarea>
                            </div>

                            <!-- Weekly Off -->
                            <div id="weeklyoffContainer"
                                class="weekly-off full-width"
                                style="display: none;">
                                <strong>Weekly Off :</strong>
                                <span id="weeklyofftext"></span>
                            </div>

                        </div>

                        <div class="action-row">
                            <button class="btn-submit" id="selfatt_btnsubmit" name="selfatt_btnsubmit" onclick="return selfatt_submit();">
                                <i class="fa fa-paper-plane"></i>
                                Submit Request
   
                            </button>
                        </div>

                    </div>

               
                    <hr />
                    <table class="table" id="selfatt_table" style="width: 100%;">
                        <thead>
                            <tr>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">In Date</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">In Time</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Out Date</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Out Time</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Reason</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added On</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Status</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Updated By</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Updated On</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Remark</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="modal fade" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
            <div class="modal-dialog text-center">
                <img src="../Images/Load.gif" />
                <br />
                <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">System is sending email notification. Please wait</span>
                <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
            </div>
        </div>

        <div class="modal fade" id="selfatt_dverror">
            <div class="modal-dialog modal-sm">
                <div class="modal-content">
                    <div class="modal-header">
                        <h6 class="modal-title" id="selfatt_errmsg"></h6>
                    </div>

                    <div class="modal-footer align-content-center">
                        <button class="btn btn-primary" type="button" id="bank_btnMessage" onclick="location.reload();">Okay</button>
                    </div>
                </div>
                <!-- /.modal-content -->
            </div>
            <!-- /.modal-dialog -->
        </div>

        <style>
            .attendance-card {
                background: #fff;
                padding: 25px;
                border-radius: 18px;
                box-shadow: 0 8px 25px rgba(0,0,0,.08);
            }

            .attendance-grid {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 20px;
            }

            .form-group {
                display: flex;
                flex-direction: column;
            }

                .form-group label {
                    font-size: 13px;
                    font-weight: 700;
                    color: #344054;
                    margin-bottom: 8px;
                }

            .form-control {
                width: 100%;
                height: 44px;
                border-radius: 10px;
                border: 1px solid #d0d5dd;
            }

                .form-control:focus {
                    border-color: #2563eb;
                    box-shadow: 0 0 0 4px rgba(37,99,235,.12);
                }

            textarea.form-control {
                height: 70px;
                padding: 12px;
                resize: vertical;
            }

            .full-width {
                grid-column: 1 / -1;
            }

            .weekly-off {
                background: #ecfdf3;
                border: 1px solid #abefc6;
                padding: 12px;
                border-radius: 10px;
                color: #027a48;
                font-weight: 600;
            }

            .btn-section {
                text-align: center;
                margin-top: 25px;
            }

            .btn-submit {
                background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
                color: #fff;
                border: none;
                padding: 12px 35px;
                border-radius: 12px;
                font-weight: 700;
                box-shadow: 0 10px 20px rgba(37,99,235,.20);
                font-size: 15px;
            }

                .btn-submit:hover {
                    transform: translateY(-2px);
                }

            @media (max-width: 992px) {
                .attendance-grid {
                    grid-template-columns: repeat(2, 1fr);
                }
            }

            @media (max-width: 768px) {
                .attendance-grid {
                    grid-template-columns: 1fr;
                }
            }

            .action-row {
                display: flex;
                justify-content: flex-end;
                margin-top: 20px;
            }

            .btn-submit {
                min-width: 180px;
            }
        </style>

    </div>

    <script>
        (function () {
            function normalizeStatus(text) {
                return (text || "").toString().toLowerCase().trim();
            }
            function updateAttendanceCards() {
                var table = document.querySelector("table.dataTable") || document.querySelector("table");
                if (!table) { return; }

                var rows = table.querySelectorAll("tbody tr");
                var total = 0, pending = 0, approved = 0, rejected = 0;

                rows.forEach(function (row) {
                    if (row.querySelector(".dataTables_empty")) { return; }
                    total++;
                    var text = normalizeStatus(row.innerText);
                    if (text.indexOf("approved") > -1 || text.indexOf("approve") > -1) { approved++; }
                    else if (text.indexOf("rejected") > -1 || text.indexOf("reject") > -1) { rejected++; }
                    else if (text.indexOf("pending") > -1 || text.indexOf("waiting") > -1) { pending++; }
                });

                var set = function (id, val) {
                    var el = document.getElementById(id);
                    if (el) { el.textContent = val; }
                };
                set("acTotalRequests", total);
                set("acPendingRequests", pending);
                set("acApprovedRequests", approved);
                set("acRejectedRequests", rejected);
            }

            document.addEventListener("DOMContentLoaded", function () {
                setTimeout(updateAttendanceCards, 700);
                setTimeout(updateAttendanceCards, 1600);
                if (window.jQuery) {
                    jQuery(document).on("draw.dt", updateAttendanceCards);
                }
            });
        })();
</script>

</asp:Content>


<%--<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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

        .dataTables_scrollBody {
            min-height: 100px !important;
            height: auto;
        }

        .dataTables_length, .dataTables_info {
            float: left !important;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: normal !important;
            border: none !important;
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
            /*    background: linear-gradient(to bottom, #007bff, 3%, #fff) !important;*/
            color: #000;
        }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
        }



        /*.form-control {
            font-size: 11px !important;
        }*/
    </style>
    <script>
        $(document).ready(function () {
            getattendancecountSelf();
            selfatt_bindReasons();
            selfatt_BindGrid();
        });
        function getattendancecountSelf() {
            PageMethods.getAttendanceCount(attcountself_OnSuccess, attcountself_OnError);
            return false;
        }
        function attcountself_OnSuccess(result) {
            if (result >= 4) {
                document.getElementById("tblselfatt").style.display = 'none';
                alert("You have already exceeded maximum number of attendance correction request limit.!");
            }
            else {
                document.getElementById("tblselfatt").style.display = '';

            }

            return false;
        }

        function attcountself_OnError(error) {
            alert(error.get_message());
        }

    </script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Attendance Correction</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <table class="table" id="tblselfatt">
                    <tr>
                        <td><b>Reason Type:</b></td>
                        <td>
                            <select id="selfatt_reason" name="selfatt_reason" class="form-control" style="width: 250px;" onchange="return selfatt_getIndates(this);"></select>
                        </td>
                        <td><b>In Date:</b></td>
                        <td>
                            <select id="selfatt_indate" name="selfatt_indate" class="form-control" style="width: 250px;" onchange="return selfatt_getInTime(this);"></select>
                        </td>
                        <td><b>In Time:</b></td>
                        <td>
                            <input type="time" id="selfatt_intime" name="selfatt_intime" class="form-control" style="width: 250px;" onchange="return checkcutofftimetovalidate(this);" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Out Date:</b></td>
                        <td>
                            <select id="selfatt_outdate" name="selfatt_outdate" class="form-control" style="width: 250px;"></select>
                        </td>
                        <td><b>Out Time:</b></td>
                        <td>
                            <input type="time" id="selfatt_outtime" name="selfatt_outtime" class="form-control" style="width: 250px;" onchange="return selfatt_GetTotalHours();" />
                        </td>
                        <td><b>Total Hours:</b></td>
                        <td>
                            <input type="text" id="selfatt_totaltime" name="selfatt_totaltime" class="form-control" style="width: 250px;" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Reason:</b></td>
                        <td colspan="3">
                            <textarea id="selfatt_userreason" name="selfatt_userreason" class="form-control" style="width: 700px;"></textarea>
                        </td>
                        <td id="weeklyofflabel" style="display: none;"><b>Weekly Off:</b></td>
                        <td id="weeklyofftext" style="display: none; color: green; font-weight: bold;"></td>
                    </tr>
                    <tr>
                        <td colspan="6" style="text-align: center;">
                            <button id="selfatt_btnsubmit" name="selfatt_btnsubmit" class="btn btn-primary" onclick="return selfatt_submit();">Submit</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <table class="table" id="selfatt_table" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">In Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">In Time</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Out Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Out Time</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Reason</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added On</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Status</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Updated By</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Updated On</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Remark</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">System is sending email notification. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>

    <div class="modal fade" id="selfatt_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="selfatt_errmsg"></h6>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="bank_btnMessage" onclick="location.reload();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>--%>
