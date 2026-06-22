<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EditAttendanceCorrectionRequest.aspx.cs" Inherits="WebPortal.Admin.EditAttendanceCorrectionRequest" %>

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

        .edit-attendance-header {
            position: relative;
            overflow: hidden;
            margin-bottom: 22px;
            padding: 14px 16px;
            border-radius: 8px;
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            color: #fff;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
        }

            .edit-attendance-header::after {
                content: '';
                position: absolute;
                right: -72px;
                top: -64px;
                width: 220px;
                height: 220px;
                border-radius: 50%;
                background: rgba(255, 255, 255, 0.12);
            }

        .edit-attendance-header-row {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 16px;
        }

        .edit-attendance-title {
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 0;
            font-size: 20px;
            font-weight: 700;
        }

        .edit-attendance-subtitle {
            margin: 5px 0 0;
            font-size: 12px;
            opacity: 0.92;
        }

        .edit-attendance-back {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            min-height: 34px;
            padding: 7px 12px;
            border: 1px solid rgba(255, 255, 255, 0.42);
            border-radius: 6px;
            background: rgba(255, 255, 255, 0.14);
            color: #fff;
            font-size: 12px;
            font-weight: 700;
            text-decoration: none;
            white-space: nowrap;
        }

            .edit-attendance-back:hover,
            .edit-attendance-back:focus {
                color: #fff;
                text-decoration: none;
                background: rgba(255, 255, 255, 0.22);
            }

        .edit-attendance-page {
            width: 100%;
            padding: 0 2px 26px;
        }

        .edit-attendance-panel {
            background: #fff;
            border: 1px solid #dbe5ec;
            border-radius: 8px;
            box-shadow: 0 10px 28px rgba(15, 23, 42, 0.07);
        }

        .edit-attendance-panel-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            padding: 16px 18px;
            border-bottom: 1px solid #e5edf3;
        }

        .edit-attendance-panel-title {
            margin: 0;
            color: #172033;
            font-size: 15px;
            font-weight: 700;
        }

        .edit-attendance-panel-subtitle {
            margin: 4px 0 0;
            color: #6b7788;
            font-size: 12px;
        }

        .edit-attendance-panel-body {
            padding: 18px;
        }

        .edit-attendance-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 15px;
        }

        .edit-attendance-field {
            min-width: 0;
        }

            .edit-attendance-field label {
                display: block;
                margin-bottom: 6px;
                color: #344054;
                font-size: 12px;
                font-weight: 700 !important;
                border: none !important;
            }

            .edit-attendance-field .form-control,
            .edit-attendance-field input,
            .edit-attendance-field select,
            .edit-attendance-field textarea {
                width: 100%;
                min-height: 38px;
                border: 1px solid #cad6e2;
                border-radius: 6px;
                box-shadow: none;
                color: #172033;
                font-size: 13px;
            }

            .edit-attendance-field textarea {
                min-height: 86px;
                resize: vertical;
            }

        .edit-attendance-field--wide {
            grid-column: span 2;
        }

        .edit-attendance-value {
            display: flex !important;
            align-items: center;
            min-height: 38px;
            margin: 0;
            padding: 8px 12px;
            border: 1px solid #d7e2ea;
            border-radius: 6px;
            background: #f8fafc;
            color: #172033;
            font-weight: 700;
            white-space: normal;
        }

        .edit-attendance-value--muted {
            font-weight: 600;
            color: #475569;
        }

        .edit-attendance-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 18px;
        }

        .edit-attendance-primary,
        .edit-attendance-modal .btn-primary {
            min-width: 108px;
            border: 0;
            border-radius: 6px;
            background: #1f6feb;
            box-shadow: 0 8px 18px rgba(31, 111, 235, 0.22);
            font-weight: 700;
        }

        .edit-attendance-secondary {
            min-width: 92px;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            background: #fff;
            color: #334155;
            font-weight: 700;
        }

        .edit-attendance-modal .modal-content {
            border: 0;
            border-radius: 10px;
            box-shadow: 0 24px 70px rgba(15, 23, 42, 0.24);
        }

        .edit-attendance-modal .modal-header {
            border-bottom: 1px solid #e5edf3;
            padding: 16px 18px;
        }

        .edit-attendance-modal .modal-title {
            color: #172033;
            font-size: 15px;
            font-weight: 700;
        }

        .edit-attendance-modal .modal-footer {
            justify-content: center;
            border-top: 1px solid #e5edf3;
            padding: 14px 18px;
        }

        .edit-attendance-waiting .modal-dialog {
            margin-top: 22vh;
        }

        .edit-attendance-waiting-content {
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

            .edit-attendance-waiting-content img {
                width: 44px;
                height: 44px;
            }

        @media (max-width: 1199px) {
            .edit-attendance-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 767px) {
            .edit-attendance-header-row {
                flex-direction: column;
            }

            .edit-attendance-back {
                width: 100%;
                justify-content: center;
            }

            .edit-attendance-grid {
                grid-template-columns: 1fr;
            }

            .edit-attendance-field--wide {
                grid-column: span 1;
            }

            .edit-attendance-actions {
                flex-direction: column;
            }

                .edit-attendance-actions .btn {
                    width: 100%;
                }
        }
    </style>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        $(document).ready(function () {
            Edit_BindInformation();
            editatt_bindbranches();
        });
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="edit-attendance-header">
        <div class="edit-attendance-header-row">
            <div>
                <h1 class="edit-attendance-title">
                    <i class="fas fa-user-check"></i>
                    Approve / Reject Attendance Correction
                </h1>
                <p class="edit-attendance-subtitle">Review the requested correction, adjust timing if needed, and submit the final status.</p>
            </div>
            <a class="edit-attendance-back" href="AttendanceCorrectionpm.aspx">
                <i class="fas fa-arrow-left"></i>
                Go back
            </a>
        </div>
    </div>

    <div class="edit-attendance-page" id="rightsdiv">
        <div class="edit-attendance-panel">
            <div class="edit-attendance-panel-header">
                <div>
                    <h3 class="edit-attendance-panel-title">Correction Details</h3>
                    <p class="edit-attendance-panel-subtitle">Confirm attendance timing and choose an approval status.</p>
                </div>
            </div>
            <div class="edit-attendance-panel-body">
                <div class="edit-attendance-grid">
                    <div class="edit-attendance-field">
                        <label for="editatt_user">User</label>
                        <input id="editatt_user" name="editatt_user" class="form-control" disabled />
                    </div>

                    <div class="edit-attendance-field">
                        <label for="editatt_indate">In Date</label>
                        <input id="editatt_indate" class="form-control" type="date" />
                    </div>

                    <div class="edit-attendance-field">
                        <label for="editatt_intime">In Time</label>
                        <input id="editatt_intime" class="form-control" type="time" />
                    </div>

                    <div class="edit-attendance-field">
                        <label for="editatt_outdate">Out Date</label>
                        <input id="editatt_outdate" class="form-control" type="date" />
                    </div>

                    <div class="edit-attendance-field">
                        <label for="editatt_outtime">Out Time</label>
                        <input id="editatt_outtime" class="form-control" type="time" />
                    </div>

                    <div class="edit-attendance-field">
                        <label for="editatt_totalhours">Total Hours</label>
                        <input id="editatt_totalhours" name="editatt_reason" class="form-control" disabled />
                    </div>

                    <div class="edit-attendance-field">
                        <label for="editatt_status">Status</label>
                        <select id="editatt_status" name="editatt_status" class="form-control">
                            <option value="">Select</option>
                            <option value="Approve">Approve</option>
                            <option value="Reject">Reject</option>
                        </select>
                    </div>

                    <div class="edit-attendance-field">
                        <label for="editatt_location">Location</label>
                        <select id="editatt_location" name="editatt_location" class="form-control"></select>
                    </div>

                    <div class="edit-attendance-field edit-attendance-field--wide">
                        <label for="editatt_reason">Reason</label>
                        <textarea id="editatt_reason" name="editatt_reason" class="form-control" disabled></textarea>
                    </div>

                    <div class="edit-attendance-field edit-attendance-field--wide">
                        <label for="editatt_remark">Remark</label>
                        <textarea id="editatt_remark" name="editatt_remark" class="form-control"></textarea>
                    </div>
                </div>

                <div class="edit-attendance-actions">
                    <a class="btn edit-attendance-secondary" href="AttendanceCorrectionpm.aspx">Cancel</a>
                    <button id="editatt_btnsubmit" name="editatt_btnsubmit" class="btn btn-primary edit-attendance-primary" onclick="return editatt_submit();">Submit</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade edit-attendance-waiting" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <div class="edit-attendance-waiting-content">
                <img src="../Images/Load.gif" />
                <span id="spntext">System is sending email notification. Please wait . . .</span>
            </div>
        </div>
    </div>

    <div class="modal fade edit-attendance-modal" id="editatt_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="editatt_errmsg"></h6>
                </div>

                <div class="modal-footer">
                    <button class="btn btn-primary" type="button" id="editatt_btnMessage" onclick="editatt_gotodashboard();">Okay</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
