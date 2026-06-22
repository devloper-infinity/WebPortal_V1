<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AttendanceCorrectionpm.aspx.cs" Inherits="WebPortal.Admin.AttendanceCorrectionpm" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        body {
            background: #f4f7fb;
        }

        .loading {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            width: 180px;
            min-height: 150px;
            margin-top: -90px;
            margin-left: -90px;
            padding: 22px 18px;
            border-radius: 14px;
            background: rgba(255, 255, 255, 0.94);
            box-shadow: 0 18px 45px rgba(15, 23, 42, 0.18);
            text-align: center;
            z-index: 99999;
        }

            .loading img {
                max-width: 64px;
                margin-bottom: 12px;
            }

        .attendance-header {
            position: relative;
            overflow: hidden;
            margin-bottom: 22px;
            padding: 14px 16px;
            border-radius: 8px;
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            color: #fff;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
        }

            .attendance-header::after {
                content: '';
                position: absolute;
                right: -72px;
                top: -64px;
                width: 220px;
                height: 220px;
                border-radius: 50%;
                background: rgba(255, 255, 255, 0.12);
            }

        .attendance-header-title {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 0;
            font-size: 20px;
            font-weight: 700;
        }

        .attendance-header-subtitle {
            position: relative;
            z-index: 1;
            margin: 5px 0 0;
            font-size: 12px;
            opacity: 0.92;
        }

        .attendance-page {
            width: 100%;
            max-width: 100%;
            padding: 0 2px 26px;
            overflow: hidden;
            box-sizing: border-box;
        }

        .attendance-shell {
            display: grid;
            gap: 18px;
            width: 100%;
            max-width: 100%;
            overflow: hidden;
            box-sizing: border-box;
        }

        .attendance-panel {
            width: 100%;
            max-width: 100%;
            overflow: hidden;
            box-sizing: border-box;
            background: #fff;
            border: 1px solid #dbe5ec;
            border-radius: 8px;
            box-shadow: 0 10px 28px rgba(15, 23, 42, 0.07);
        }

        .attendance-panel-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            padding: 16px 18px;
            border-bottom: 1px solid #e5edf3;
        }

        .attendance-panel-title {
            margin: 0;
            color: #172033;
            font-size: 15px;
            font-weight: 700;
        }

        .attendance-panel-subtitle {
            margin: 4px 0 0;
            color: #6b7788;
            font-size: 12px;
        }

        .attendance-panel-body {
            padding: 18px;
        }

        /* .attendance-form-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 15px;
        }

        .attendance-field {
            min-width: 0;
            width: 300px;
        }

            .attendance-field label {
                display: block;
                margin-bottom: 6px;
                color: #344054;
                font-size: 12px;
                font-weight: 700 !important;
                border: none !important;
            }

            .attendance-field .form-control,
            .attendance-field select,
            .attendance-field input,
            .attendance-field textarea {
                width: 100%;
                min-height: 38px;
                border: 1px solid #cad6e2;
                border-radius: 6px;
                box-shadow: none;
                color: #172033;
                font-size: 13px;
            }

            .attendance-field textarea {
                resize: vertical;
            }*/

        .attendance-form-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 18px;
            align-items: start;
            width: 100%;
            max-width: 100%;
            box-sizing: border-box;
        }

        .attendance-field {
            width: 100%;
            min-width: 0;
            box-sizing: border-box;
        }

            .attendance-field label {
                height: 18px;
                margin-bottom: 6px;
            }

            .attendance-field .form-control,
            .attendance-field select,
            .attendance-field input,
            .attendance-field textarea {
                width: 100% !important;
                max-width: 100%;
                min-height: 40px;
                box-sizing: border-box;
            }

            .attendance-field textarea {
                min-height: 40px;
            }

            .attendance-field .form-control:disabled {
                background: #f1f5f9;
                color: #475569;
                opacity: 1;
            }

        .attendance-weekly-off {
            min-height: 38px;
            display: flex;
            align-items: center;
            padding: 8px 12px;
            border: 1px solid #badbcc;
            border-radius: 6px;
            background: #effaf3;
            color: #0f7a3d;
            font-weight: 700;
        }

        .attendance-actions {
            display: flex;
            justify-content: flex-end;
            margin-top: 18px;
        }

        .attendance-primary-action,
        .attendance-modal .btn-primary {
            min-width: 108px;
            border: 0;
            border-radius: 6px;
            background: #1f6feb;
            box-shadow: 0 8px 18px rgba(31, 111, 235, 0.22);
            font-weight: 700;
        }

        .attendance-table-wrap {
            width: 100%;
            max-width: 100%;
            overflow-x: auto;
            padding: 0 18px 18px;
            box-sizing: border-box;
        }

        .attendance-data-table {
            width: 100% !important;
            margin: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0;
            color: #253044;
            font-size: 12px;
        }

            .attendance-data-table thead th,
            table.dataTable thead th {
                background: #edf3f6 !important;
                border-color: #d7e2ea !important;
                border-bottom: 1px solid #d7e2ea !important;
                color: #263342 !important;
                font-size: 12px;
                font-weight: 700;
                /*  padding: 10px 12px !important;*/
                white-space: nowrap;
            }

            .attendance-data-table tbody td,
            table.dataTable tbody td {
                border-bottom: 1px solid #edf2f7;
                padding: 10px 12px !important;
                vertical-align: top;
                background: #fff !important;
            }

            .attendance-data-table tbody tr:hover td,
            table.dataTable tbody tr:hover td {
                background: #f8fbfd !important;
            }

        .dataTables_scrollBody {
            min-height: 100px !important;
            height: auto;
        }

        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dataTables_filter {
            margin: 0 18px 12px 0;
            color: #64748b;
            font-size: 12px;
        }

        .dataTables_wrapper .dataTables_length {
            margin-left: 18px;
        }

            .dataTables_wrapper .dataTables_filter input,
            .dataTables_wrapper .dataTables_length select {
                height: 34px;
                border: 1px solid #cbd5e1;
                border-radius: 6px;
                padding: 5px 10px;
            }

        .dataTables_wrapper .dataTables_info {
            float: left !important;
            padding: 12px 18px 0;
            color: #64748b;
            font-size: 12px;
        }

        .dataTables_wrapper .dataTables_paginate {
            padding: 12px 18px 0 0;
        }

            .dataTables_wrapper .dataTables_paginate .paginate_button {
                border: 1px solid #d7e2ea !important;
                border-radius: 6px !important;
                background: #fff !important;
                color: #344054 !important;
                margin: 0 3px !important;
                padding: 5px 10px !important;
            }

                .dataTables_wrapper .dataTables_paginate .paginate_button.current {
                    background: #1f6feb !important;
                    border-color: #1f6feb !important;
                    color: #fff !important;
                }

        div.dt-buttons {
            position: static;
            float: left;
            padding: 12px 0 0 14px;
        }

        .buttons-excel,
        .buttons-html5,
        .dt-button {
            border: 1px solid #c7d6e3 !important;
            border-radius: 6px !important;
            background: #fff !important;
            color: #1f2937 !important;
            box-shadow: none !important;
            font-size: 12px !important;
            font-weight: 700 !important;
            margin-right: 8px !important;
            padding: 6px 12px !important;
        }

        #pmatt_table .dropdown-item {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 30px;
            height: 30px;
            border-radius: 6px;
            background: #eef6ff;
        }

        #pmatt_table .isDisabled {
            opacity: 0.45;
            pointer-events: none;
        }

        .attendance-modal .modal-content {
            border: 0;
            border-radius: 10px;
            box-shadow: 0 24px 70px rgba(15, 23, 42, 0.24);
        }

        .attendance-modal .modal-header {
            border-bottom: 1px solid #e5edf3;
            padding: 16px 18px;
        }

        .attendance-modal .modal-title {
            color: #172033;
            font-size: 15px;
            font-weight: 700;
        }

        .attendance-modal .modal-footer {
            justify-content: center;
            border-top: 1px solid #e5edf3;
            padding: 14px 18px;
        }

        .attendance-waiting-panel .modal-dialog {
            margin-top: 22vh;
        }

        .attendance-waiting-content {
            display: inline-flex;
            align-items: center;
            gap: 14px;
            padding: 18px 22px;
            border-radius: 10px;
            background: rgba(15, 23, 42, 0.86);
            color: #fff;
            font-size: 16px;
            font-weight: 700;
        }

            .attendance-waiting-content img {
                width: 44px;
                height: 44px;
            }

        @media (max-width: 1199px) {
            .attendance-form-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 767px) {
            .attendance-header {
                padding: 14px;
            }

            .attendance-panel-header {
                align-items: flex-start;
                flex-direction: column;
            }

            .attendance-form-grid {
                grid-template-columns: 1fr;
            }

            .attendance-actions {
                justify-content: stretch;
            }

            .attendance-primary-action {
                width: 100%;
            }
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        $(document).ready(function () {

            var currentUserName = '<%= HttpContext.Current.User.Identity.Name.ToString() %>';
            $.ajax({
                type: "POST", url: "AttendanceCorrectionpm.aspx/GetLoggedInUser", dataType: "json", contentType: "application/json",
                success: function (res) {
                    var dataArray = JSON.parse(res.d);
                    $.each(dataArray, function (data, value) {
                        if (value.Domain == 9 && value.WorkingBranch == 2) {
                            document.getElementById("attmain").style.display = "";
                            pmatt_bindusers();
                            pmatt_bindReasons();
                            pmatt_BindGrid();
                            setTimeout(function () {
                                if ($.fn.DataTable && $.fn.DataTable.isDataTable('#pmatt_table')) {
                                    $('#pmatt_table').DataTable().columns.adjust();
                                }
                            }, 400);
                        }
                        else if (currentUserName == 7036 || currentUserName == 12 || currentUserName == 216 || currentUserName == 285 || currentUserName == 8535 || currentUserName == 9738 || currentUserName == 277 || currentUserName == 99 || currentUserName == 8128 || currentUserName == 291 || currentUserName == 255 || currentUserName == 209) {
                            document.getElementById("attmain").style.display = "";
                            pmatt_bindusers();
                            pmatt_bindReasons();
                            pmatt_BindGrid();
                            setTimeout(function () {
                                if ($.fn.DataTable && $.fn.DataTable.isDataTable('#pmatt_table')) {
                                    $('#pmatt_table').DataTable().columns.adjust();
                                }
                            }, 400);
                        }
                        else {
                            document.getElementById("attmain").style.display = "none";
                            alert("You are not authorized to view this page. Please contact your domain head.");
                            return;
                        }

                    })
                }
            });
        });
    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="attendance-header">
        <h1 class="attendance-header-title">
            <i class="fas fa-user-clock"></i>
            Attendance Correction
        </h1>
        <p class="attendance-header-subtitle">Manage team attendance correction requests and review request status.</p>
    </div>

    <div class="attendance-page" id="attmain">
        <div class="attendance-shell">
            <div class="attendance-panel">
                <div class="attendance-panel-header">
                    <div>
                        <h3 class="attendance-panel-title">Correction Request</h3>
                        <p class="attendance-panel-subtitle">Select the user, reason, dates, and corrected attendance timing.</p>
                    </div>
                </div>
                <div class="attendance-panel-body">
                    <div class="attendance-form-grid">
                        <div class="attendance-field">
                            <label for="pmatt_user">User</label>
                            <select id="pmatt_user" name="pmatt_user" class="form-control" onchange="return getattendancecount(this);"></select>
                        </div>

                        <div class="attendance-field">
                            <label for="pmatt_reason">Reason Type</label>
                            <select id="pmatt_reason" name="pmatt_reason" class="form-control" onchange="return pmatt_getIndates(this);"></select>
                        </div>

                        <div class="attendance-field">
                            <label for="pmatt_indate">In Date</label>
                            <select id="pmatt_indate" name="pmatt_indate" class="form-control" onchange="return pmatt_getInTime(this);"></select>
                        </div>

                        <div class="attendance-field">
                            <label for="pmatt_intime">In Time</label>
                            <input type="time" id="pmatt_intime" name="pmatt_intime" class="form-control" onchange="return checkcutofftimetovalidate_pm(this);" />
                        </div>

                        <div class="attendance-field">
                            <label for="pmatt_outdate">Out Date</label>
                            <select id="pmatt_outdate" name="pmatt_outdate" class="form-control"></select>
                        </div>

                        <div class="attendance-field">
                            <label for="pmatt_outtime">Out Time</label>
                            <input type="time" id="pmatt_outtime" name="pmatt_outtime" class="form-control" oninput="return pmatt_GetTotalHours();" />
                        </div>

                        <div class="attendance-field">
                            <label for="pmatt_totaltime">Total Hours</label>
                            <input type="text" id="pmatt_totaltime" name="pmatt_totaltime" class="form-control" />
                        </div>

                        <div class="attendance-field">
                            <label for="pmatt_userreason">Reason</label>
                            <textarea id="pmatt_userreason" name="pmatt_userreason" class="form-control"></textarea>
                        </div>

                        <div class="attendance-field" id="pmweeklyofflabel" style="display: none;">
                            <label>Weekly Off</label>
                            <div class="attendance-weekly-off" id="pmweeklyofftext" style="display: none;"></div>
                        </div>
                    </div>

                    <div class="attendance-actions">
                        <button id="selfatt_btnsubmit" name="pmatt_btnsubmit" class="btn btn-primary attendance-primary-action" onclick="return pmatt_submit();">Submit</button>
                    </div>
                </div>
            </div>

            <div class="attendance-panel">
                <div class="attendance-panel-header">
                    <div>
                        <h3 class="attendance-panel-title">Correction History</h3>
                        <p class="attendance-panel-subtitle">Track submitted requests, approvals, remarks, and correction status.</p>
                    </div>
                </div>
               
                <div class="attendance-table-wrap">
                    <table class="table table-hover attendance-data-table" id="pmatt_table">
                        <thead>
                            <tr>
                                <th>Actions</th>
                                <th>Code</th>
                                <th>In Date</th>
                                <th>In Time</th>
                                <th>Out Date</th>
                                <th>Out Time</th>
                                <th>Reason</th>
                                <th>Added On</th>
                                <th>Status</th>
                                <th>Updated By</th>
                                <th>Updated On</th>
                                <th>Remark</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade attendance-waiting-panel" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <div class="attendance-waiting-content">
                <img src="../Images/Load.gif" />
                <span id="spntext">System is sending email notification. Please wait . . .</span>
            </div>
        </div>
    </div>

    <div class="modal fade attendance-modal" id="pmatt_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="pmatt_errmsg"></h6>
                </div>

                <div class="modal-footer">
                    <button class="btn btn-primary" type="button" id="bank_btnMessage" onclick="location.reload();">Okay</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
