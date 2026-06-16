<%@ Page Title="" Language="C#" MasterPageFile="~/IT/Admin.Master" AutoEventWireup="true" CodeBehind="TicketApproval.aspx.cs" Inherits="WebPortal.IT.TicketApproval" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        :root {
            --ticket-primary: #2563eb;
            --ticket-primary-dark: #1d4ed8;
            --ticket-soft: #eff6ff;
            --ticket-border: #e5e7eb;
            --ticket-text: #0f172a;
            --ticket-muted: #64748b;
            --ticket-card-shadow: 0 18px 45px rgba(15, 23, 42, .08);
        }

        .ticket-page {
            padding: 8px 14px 28px;
            background: #f8fafc;
            min-height: calc(100vh - 90px);
        }

        .ticket-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            color: #fff;
            background: linear-gradient(135deg, #2563eb 0%, #7c3aed 55%, #f97316 120%);
            border-radius: 22px;
            padding: 24px 28px;
            margin-bottom: 18px;
            box-shadow: var(--remark-shadow);
        }

            .ticket-hero:after {
                content: "";
                position: absolute;
                width: 280px;
                height: 280px;
                right: -80px;
                top: -110px;
                background: rgba(255, 255, 255, .16);
                border-radius: 50%;
            }

            .ticket-hero h4,
            .ticket-hero p,
            .ticket-hero .btn {
                position: relative;
                z-index: 1;
            }

            .ticket-hero h4 {
                margin: 0;
                font-weight: 800;
                letter-spacing: .2px;
            }

            .ticket-hero p {
                margin: 7px 0 0;
                color: rgba(255, 255, 255, .86);
            }


        .ticket-hero-icon {
            width: 52px;
            height: 52px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 16px;
            color: #fff;
            background: linear-gradient(135deg, var(--ticket-primary), #7c3aed);
            box-shadow: 0 14px 26px rgba(37, 99, 235, .25);
            font-size: 22px;
        }

        .ticket-card {
            border: 1px solid var(--ticket-border) !important;
            border-radius: 18px !important;
            box-shadow: var(--ticket-card-shadow);
            overflow: hidden;
        }

            .ticket-card .card-body {
                padding: 20px;
            }

        .ticket-table-wrap {
            width: 100%;
            overflow-x: auto;
        }

        #table_approveTicket, #table_AppticketHistory {
            border-collapse: separate !important;
            border-spacing: 0 10px !important;
            margin-top: 0 !important;
        }

            #table_approveTicket thead th, #table_AppticketHistory thead th {
                background: #f1f5f9 !important;
                color: #334155 !important;
                font-size: 12px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: .03em;
                border: 0 !important;
                padding: 12px 14px !important;
                vertical-align: middle;
            }

            #table_approveTicket tbody td, #table_AppticketHistory tbody td {
                background: #fff !important;
                border-top: 1px solid var(--ticket-border) !important;
                border-bottom: 1px solid var(--ticket-border) !important;
                padding: 13px 14px !important;
                vertical-align: middle;
                color: #1f2937;
            }

                #table_approveTicket tbody td:first-child, #table_AppticketHistory tbody td:first-child {
                    border-left: 1px solid var(--ticket-border) !important;
                    border-radius: 14px 0 0 14px;
                }

                #table_approveTicket tbody td:last-child, #table_AppticketHistory tbody td:last-child {
                    border-right: 1px solid var(--ticket-border) !important;
                    border-radius: 0 14px 14px 0;
                }

        .approval-modal .modal-content {
            border: 0;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 24px 80px rgba(15, 23, 42, .24);
        }

        .approval-modal .modal-header {
            background: linear-gradient(135deg, #2563eb, #7c3aed);
            color: #fff;
            border: 0;
            padding: 18px 24px;
        }

        .approval-modal .modal-title {
            font-weight: 800;
        }

        .approval-modal .close {
            color: #fff;
            opacity: 1;
            text-shadow: none;
        }

        .approval-modal .modal-body {
            background: #f8fafc;
            padding: 22px 24px;
        }

        .approval-modal .modal-footer {
            background: #fff;
            border-top: 1px solid var(--ticket-border);
            padding: 16px 24px;
        }

        .approval-panel {
            background: #fff;
            border: 1px solid var(--ticket-border);
            border-radius: 18px;
            padding: 18px;
            box-shadow: 0 10px 30px rgba(15, 23, 42, .06);
        }

        .approval-panel-title {
            margin: 0 0 16px;
            color: var(--ticket-text);
            font-weight: 800;
            font-size: 15px;
        }

        .approval-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 16px;
        }

            .approval-grid .field-wide {
                grid-column: span 2;
            }

            .approval-grid .field-full {
                grid-column: 1 / -1;
            }

        .ticket-field label {
            display: block;
            margin-bottom: 7px;
            color: #334155;
            font-size: 12px;
            font-weight: 700 !important;
            text-transform: uppercase;
            letter-spacing: .03em;
        }

        .ticket-field .form-control, .ticket-field select.form-control, .ticket-field textarea.form-control {
            width: 100% !important;
            min-height: 42px;
            border: 1px solid var(--ticket-border);
            border-radius: 12px;
            font-size: 13px;
            padding: 9px 12px;
            box-shadow: none;
            background: #fff;
        }

        .ticket-field textarea.form-control {
            min-height: 96px;
            resize: vertical;
        }

        .ticket-field .form-control:focus {
            border-color: var(--ticket-primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, .12);
        }

        .history-panel {
            margin-top: 20px;
            background: #fff;
            border: 1px solid var(--ticket-border);
            border-radius: 18px;
            padding: 18px;
        }

        @media (max-width: 991px) {
            .approval-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 575px) {
            .approval-grid {
                grid-template-columns: 1fr;
            }

                .approval-grid .field-wide {
                    grid-column: span 1;
                }
        }
    </style>

    <script type="text/javascript">
        $(document).ready(function () {
            approve_BindGrid();
        });

        var fileslist = '';
        var fd = new FormData();

        window.onload = function () {
            document.getElementById('approveTicket_file').addEventListener('change', getFileName);
        }

        const getFileName = (event) => {

            for (var i = 0; i < event.target.files.length; i++) {

                const files = event.target.files;
                var file = files[i];

                document.getElementById("fpApproveTckAttach").value = files[i].name;

                if (fileslist != '')
                    fileslist = fileslist + ',' + file.name;
                else
                    fileslist = file.name;

                // add all selected files
                fd.append(event.target.name, file, file.name);
                // create the request
            }

            const xhr = new XMLHttpRequest();

            xhr.onload = () => {

                // alert(xhr.status);

                if (xhr.status >= 200 && xhr.status < 300) {
                    // we done!
                }
            };

            var url = window.location.href;
            // path to server would be where you'd normally post the form to
            xhr.open('POST', url, true);
            xhr.send(fd);
            document.getElementById("dropzoneAppTckdoc").classList.add("dz-max-files-reached");
            document.getElementById("conentdivAppTckdoc").style.display = '';
            document.getElementById("filesdivAppTckdoc").innerHTML = fileslist;
        }

    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="fpApproveTckAttach" style="display: none;" />

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="ticket-page">
        <div class="ticket-hero">
            <div>
                <h4><i class="fas fa-copy"></i>&nbsp;&nbsp;Approve Ticket</h4>
                <p>Approve or reject tickets with request details, status and remarks.</p>
            </div>
            <span class="ticket-hero-icon"><i class="fas fa-check-circle"></i></span>
        </div>
        <div class="col-lg-12 p-0">
            <div class="card ticket-card">
                <div class="card-body">
                    <div class="ticket-table-wrap">
                        <table class="table" id="table_approveTicket" style="width: 100%;">
                            <thead>
                                <tr>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Actions</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center; display: none;">TicketId</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Ticket #</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Request By</th>
                                    <%--<th class="sort border-top ps-3" style="text-wrap: nowrap;">Request Related To</th>--%>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Request Date</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Department</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Subject</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Request Type</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Severity</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Priority</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Approval Status</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Approved/Rejected By</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Approved/Rejected Date</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Status</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">New Remark</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade approval-modal" id="approveTicket_popUp" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="approveTicket_popUpLabel" aria-hidden="true">
            <div class="modal-dialog modal-xl" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="approveTicket_popUpLabel"></h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="approval-panel">
                            <h6 class="approval-panel-title">Approval Details</h6>
                            <div class="approval-grid">
                                <div class="ticket-field">
                                    <label for="approveTicket_Status">Status</label>
                                    <select id="approveTicket_Status" name="approveTicket_Status" class="form-control">
                                        <option value="">Select</option>
                                        <option value="Approve">Approve</option>
                                        <option value="Reject">Reject</option>
                                    </select>
                                </div>
                                <div class="ticket-field">
                                    <label for="approveTicket_RqType">Request Type</label>
                                    <select id="approveTicket_RqType" name="approveTicket_RqType" class="form-control">
                                        <option value="">Select</option>
                                        <option value="Request">Request</option>
                                        <option value="Change">Change</option>
                                        <option value="Incident">Incident</option>
                                    </select>
                                </div>
                                <div class="ticket-field">
                                    <label for="approveTicket_Severity">Severity</label>
                                    <select id="approveTicket_Severity" name="approveTicket_Severity" class="form-control">
                                        <option value="">Select</option>
                                        <option value="Minor">Minor</option>
                                        <option value="Major">Major</option>
                                        <option value="Critical">Critical</option>
                                    </select>
                                </div>
                                <div class="ticket-field">
                                    <label for="approveTicket_Priority">Priority</label>
                                    <select id="approveTicket_Priority" name="approveTicket_Priority" class="form-control">
                                        <option value="">Select</option>
                                        <option value="High">High</option>
                                        <option value="Medium">Medium</option>
                                        <option value="Low">Low</option>
                                    </select>
                                </div>
                                <div class="ticket-field field-wide">
                                    <label for="approveTicket_file">Attachment</label>
                                    <input type="file" id="approveTicket_file" name="approveTicket_file" class="form-control" />
                                    <div class="dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete" id="dropzoneAppTckdoc" style="display: none;">
                                        <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column" id="conentdivAppTckdoc" style="display: none!important;">
                                            <div class="flex-1 d-flex flex-between-center">
                                                <div id="filesdivAppTckdoc" style="margin-top: 10px; margin-bottom: 10px;"></div>
                                                <div class="dropdown font-sans-serif">
                                                    <button class="btn btn-link text-600 btn-sm dropdown-toggle btn-reveal dropdown-caret-none" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="true"></button>
                                                    <div class="dropdown-menu dropdown-menu-end border py-2"><a class="dropdown-item" href="#!" data-dz-remove="data-dz-remove">Remove File</a></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="ticket-field field-wide">
                                    <label for="approveTicket_Remark">Remark</label>
                                    <textarea type="text" id="approveTicket_Remark" name="approveTicket_Remark" class="form-control"></textarea>
                                </div>
                            </div>
                        </div>
                        <div class="history-panel">
                            <h6 class="approval-panel-title">Ticket History</h6>
                            <div class="ticket-table-wrap">
                                <table id="table_AppticketHistory" class="table">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top" style="width: 100px;">Ticket #</th>
                                            <th class="sort border-top" style="width: 100px;">Subject</th>
                                            <th class="sort border-top" style="width: 250px;">Description</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Request Type</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Request Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Department</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Status</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Severity</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Priority</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Approval Status</th>
                                            <th class="sort border-top" style="width: 150px;">Approved/Rejected By</th>
                                            <th class="sort border-top" style="width: 150px;">Approved/Rejected Date</th>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer justify-content-between">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-primary" onclick="return btnApproveTicket();">Submit</button>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <div class="modal fade" id="waitingpanelAppTicket" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">System is updating details. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>
</asp:Content>
