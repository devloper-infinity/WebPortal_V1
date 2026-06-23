<%@ Page Title="" Language="C#" MasterPageFile="~/IT/Admin.Master" AutoEventWireup="true" CodeBehind="AddTicketRemark.aspx.cs" Inherits="WebPortal.IT.AddTicketRemark" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --remark-primary: #2563eb;
            --remark-primary-dark: #1d4ed8;
            --remark-accent: #f97316;
            --remark-bg: #f6f8fb;
            --remark-card: #ffffff;
            --remark-text: #172033;
            --remark-muted: #64748b;
            --remark-border: #e5e7eb;
            --remark-soft: #eff6ff;
            --remark-shadow: 0 12px 30px rgba(15, 23, 42, .08);
        }

        .loading {
            display: none;
            position: fixed;
            top: 350px;
            left: 50%;
            margin-top: -96px;
            margin-left: -96px;
            opacity: .85;
            border-radius: 25px;
            width: 192px;
            height: 192px;
            z-index: 99999;
            text-align: center;
        }

        .remark-page {
            width: 100%;
            background: var(--remark-bg);
            border-radius: 18px;
        }

        .remark-hero {
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

            .remark-hero:after {
                content: "";
                position: absolute;
                width: 280px;
                height: 280px;
                right: -80px;
                top: -110px;
                background: rgba(255, 255, 255, .16);
                border-radius: 50%;
            }

            .remark-hero h4,
            .remark-hero p,
            .remark-hero .btn {
                position: relative;
                z-index: 1;
            }

            .remark-hero h4 {
                margin: 0;
                font-weight: 800;
                letter-spacing: .2px;
            }

            .remark-hero p {
                margin: 7px 0 0;
                color: rgba(255, 255, 255, .86);
            }

            .remark-hero .btn {
                border-radius: 999px;
                font-weight: 700;
                box-shadow: none;
            }

        .remark-section-card {
            border: 1px solid var(--remark-border);
            border-radius: 18px;
            box-shadow: var(--remark-shadow);
            background: var(--remark-card);
            margin-bottom: 18px;
            overflow: hidden;
        }

        .remark-section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 18px 20px;
            border-bottom: 1px solid var(--remark-border);
        }

            .remark-section-header h5 {
                margin: 0;
                color: var(--remark-text);
                font-weight: 800;
            }

            .remark-section-header span {
                color: var(--remark-muted);
                font-size: 13px;
            }

        .remark-info-grid {
            display: grid;
            grid-template-columns: repeat(5, minmax(180px, 1fr));
            gap: 18px;
            padding: 20px;
        }

        .remark-form-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(180px, 1fr));
            gap: 18px;
            padding: 20px;
            align-items: start;
        }

        .remark-field.full {
            grid-column: 1 / -1;
            padding-bottom: 5px;
        }

        .remark-field.wide {
            grid-column: span 2;
        }

        .remark-inline-group {
            display: contents;
        }

        .remark-tat-field,
        .remark-subject-field {
            grid-column: span 2;
            width: 100px;
        }

        .remark-field label,
        .remark-field .remark-label {
            display: block;
            margin-bottom: 7px;
            color: var(--remark-text);
            font-size: 13px;
            font-weight: 700 !important;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: normal !important;
            border: none !important;
        }

        .remark-field label,
        .remark-field .remark-label {
            font-weight: 700 !important;
        }

        .remark-value,
        .remark-field .form-control,
        .remark-field select,
        .remark-field textarea {
            width: 100% !important;
            border: 1px solid var(--remark-border);
            border-radius: 12px;
            min-height: 42px;
            box-shadow: none;
            background: #fff;
            transition: border-color .2s ease, box-shadow .2s ease;
        }

        .form-control.remark-value {
            display: flex;
            align-items: center;
            margin: 0;
            color: var(--remark-text);
            background: #f8fafc;
            overflow-wrap: anywhere;
            height: auto;
            min-height: 42px;
        }

        input.form-control.remark-value,
        textarea.form-control.remark-value {
            cursor: default;
        }

        .remark-field .form-control:focus,
        .remark-field select:focus,
        .remark-field textarea:focus {
            border-color: var(--remark-primary);
            box-shadow: 0 0 0 .18rem rgba(37, 99, 235, .12);
        }

        .remark-field textarea {
            min-height: 300px;
            resize: vertical;
        }

        .remark-tat-row {
            display: grid;
            grid-template-columns: minmax(80px, 1fr) auto minmax(80px, 1fr) auto minmax(80px, 1fr) auto;
            align-items: center;
            gap: 10px;
        }

            .remark-tat-row select {
                width: 100% !important;
                display: block !important;
            }

            .remark-tat-row span {
                color: var(--remark-muted);
                font-weight: 700;
                font-size: 13px;
                white-space: nowrap;
            }

        .remark-actions {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 0 20px 22px;
        }

            .remark-actions .btn-primary,
            .modal-footer .btn-primary {
                border: 0;
                border-radius: 999px;
                padding: 10px 22px;
                font-weight: 800;
                background: linear-gradient(135deg, var(--remark-primary), #7c3aed);
                box-shadow: 0 10px 20px rgba(37, 99, 235, .22);
            }

        .remark-download-btn {
            width: 42px;
            height: 42px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
        }

        .remark-history-wrap {
            padding: 0 20px 20px;
        }

        #table_ticketRemarkHistory {
            width: 100% !important;
            border-collapse: separate !important;
            border-spacing: 0;
            overflow: hidden;
            border: 1px solid var(--remark-border);
            border-radius: 14px;
        }

            #table_ticketRemarkHistory thead th {
                background: var(--remark-soft);
                color: var(--remark-text);
                font-weight: 800;
                border-bottom: 1px solid var(--remark-border) !important;
                white-space: nowrap;
            }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
            vertical-align: middle;
        }

        .dataTables_length, .dataTables_info {
            float: left !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 50px;
            float: left;
        }

        .buttons-excel, .buttons-html5 {
            color: #fff;
            box-shadow: none;
            background: linear-gradient(to right, #ffbf96, #fe7096);
            border: 0;
            font-weight: bold;
            margin: 0px 10px;
            border-radius: 999px;
        }

        .dropzone {
            border: 1px dashed var(--remark-primary);
            border-radius: 14px;
            background: var(--remark-soft);
            margin-top: 10px;
            padding: 10px !important;
        }

        #filesdivticketRemark {
            color: var(--remark-text);
            font-size: 13px;
            font-weight: 700;
        }

        .modal-content {
            border: 0;
            border-radius: 18px;
            box-shadow: var(--remark-shadow);
        }

        .modal-header {
            border-bottom: 1px solid var(--remark-border);
        }

        @media (max-width: 991px) {
            .remark-info-grid,
            .remark-form-grid {
                grid-template-columns: repeat(2, minmax(220px, 1fr));
            }

            .remark-field.wide,
            .remark-tat-field,
            .remark-subject-field {
                grid-column: 1 / -1;
            }
        }

        @media (max-width: 767px) {
            .remark-page {
                padding: 12px;
            }

            .remark-hero {
                align-items: flex-start;
                flex-direction: column;
                padding: 20px;
            }

            .remark-info-grid,
            .remark-form-grid {
                grid-template-columns: 1fr;
                padding: 16px;
            }

            .remark-history-wrap {
                padding: 0 16px 16px;
                overflow-x: auto;
            }

            .remark-section-header {
                align-items: flex-start;
                flex-direction: column;
            }
        }
    </style>

    <script type="text/javascript">
        $(document).ready(function () {

            const urlParams = new URLSearchParams(window.location.search);

            const TicketId = urlParams.get('TicketId');

            bind_TicketRemarkHistory(TicketId);
            bindticketremarkfields(TicketId);
            syncTicketDetailInputs();

            ticketRemark_Bindminutes();
            ticketRemark_Bindhours();
            ticketRemark_Binddays();

        });

        function syncTicketDetailInputs() {
            var detailIds = [
                'ticketremark_ticketno',
                'ticketremark_requestrelatedto',
                'ticketremark_requestby',
                'ticketremark_requestdatetime',
                'ticketremark_deskno',
                'ticketremark_requestonbehalf',
                'ticketremark_reportingmanager',
                'ticketremark_subject',
                'ticketremark_description'
            ];

            var sync = function () {
                detailIds.forEach(function (id) {
                    var el = document.getElementById(id);
                    if (!el) return;

                    var populatedText = (el.textContent || el.innerHTML || '').trim();
                    if (populatedText && !el.value) {
                        el.value = populatedText;
                    }
                });
            };

            sync();
            setTimeout(sync, 300);
            setTimeout(sync, 1000);
            setTimeout(sync, 2000);
        }

        var fileslist = '';
        var fd = new FormData();

        window.onload = function () {

            document.getElementById('ticketRemark_file').addEventListener('change', getFileName);
        }

        const getFileName = (event) => {

            for (var i = 0; i < event.target.files.length; i++) {
                const files = event.target.files;
                var file = files[i];
                document.getElementById("fp_ticketRemark").value = files[i].name;
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
            document.getElementById("dropzoneticketRemark").classList.add("dz-max-files-reached");
            document.getElementById("conentdivticketRemark").style.display = '';
            document.getElementById("filesdivticketRemark").innerHTML = fileslist;
        }

    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   
    <input id="fp_ticketRemark" style="display: none;" />
    <label id="lbl_downloadPath" name="lbl_downloadPath" style="display: none;"></label>

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="container-fluid remark-page">
        <div class="remark-hero">
            <div>
                <h4><i class="fas fa-comment-dots"></i>&nbsp;&nbsp;Add Remark</h4>
                <p>Review the ticket details, update status, add remarks, and track remark history.</p>
            </div>
            <a href="TIcketQueue.aspx" class="btn btn-secondary buttons-excel buttons-html5"><i class="fas fa-arrow-left"></i>&nbsp;Back</a>
        </div>

        <div class="remark-section-card">
            <div class="remark-section-header">
                <div>
                    <h5>Ticket Details</h5>
                    <span>Current request information</span>
                </div>
                <a id="downloadLink" class="btn btn-primary remark-download-btn" onclick="return downloadImg();" style="display: none;"><i class="fa fa-download"></i></a>
            </div>
            <div class="remark-info-grid">
                <div class="remark-field">
                    <span class="remark-label">Ticket #</span>
                    <input type="text" id="ticketremark_ticketno" name="ticketremark_ticketno" class="form-control remark-value" readonly />
                </div>
                <div class="remark-field">
                    <span class="remark-label">Request Related To</span>
                    <input type="text" id="ticketremark_requestrelatedto" name="ticketremark_requestrelatedto" class="form-control remark-value" readonly />
                </div>
                <div class="remark-field">
                    <span class="remark-label">Request By</span>
                    <input type="text" id="ticketremark_requestby" name="ticketremark_requestby" class="form-control remark-value" readonly />
                </div>

                <div class="remark-field">
                    <span class="remark-label">Request Datetime</span>
                    <input type="text" id="ticketremark_requestdatetime" name="ticketremark_requestdatetime" class="form-control remark-value" readonly />
                </div>
                <div class="remark-field">
                    <span class="remark-label">Desk #</span>
                    <input type="text" id="ticketremark_deskno" name="ticketremark_deskno" class="form-control remark-value" readonly />
                </div>
                <div class="remark-field">
                    <span class="remark-label">Request On Behalf</span>
                    <input type="text" id="ticketremark_requestonbehalf" name="ticketremark_requestonbehalf" class="form-control remark-value" readonly />
                </div>
                <div class="remark-field">
                    <span class="remark-label">Reporting Manager</span>
                    <input type="text" id="ticketremark_reportingmanager" name="ticketremark_reportingmanager" class="form-control remark-value" readonly />
                </div>
                <div class="remark-field wide">
                    <span class="remark-label">Subject</span>
                    <input type="text" id="ticketremark_subject" name="ticketremark_subject" class="form-control remark-value" readonly />
                </div>
                <div class="remark-field full">
                    <span class="remark-label">Description</span>
                    <textarea id="ticketremark_description" name="ticketremark_description" class="form-control remark-value" style="height: 100px;" readonly></textarea>
                </div>
            </div>
        </div>

        <div class="remark-section-card">
            <div class="remark-section-header">
                <div>
                    <h5>Add New Remark</h5>
                    <span>Set next action details and submit your update</span>
                </div>
            </div>
            <div class="remark-form-grid">
                <div id="trReqTypePriority" class="remark-inline-group" style="display: none;">
                    <div class="remark-field">
                        <label for="ticketRemark_ReqType">Request Type</label>
                        <select id="ticketRemark_ReqType" name="ticketRemark_ReqType" class="form-control">
                            <option value="">Select</option>
                            <option value="Request">Request</option>
                            <option value="Change">Change</option>
                            <option value="Incident">Incident</option>
                        </select>
                    </div>
                    <div class="remark-field">
                        <label for="ticketRemark_Priority">Priority</label>
                        <select id="ticketRemark_Priority" name="ticketRemark_Priority" class="form-control">
                            <option value="">Select</option>
                            <option value="Major">Major</option>
                            <option value="Minor">Minor</option>
                            <option value="Critical">Critical</option>
                        </select>
                    </div>
                </div>
                <div class="remark-field">
                    <label for="ticketRemark_NextStatus">Status</label>
                    <select id="ticketRemark_NextStatus" name="ticketRemark_NextStatus" class="form-control">
                        <option value="">Select</option>
                        <option value="Open">Open</option>
                        <option value="Closed">Closed</option>
                    </select>
                </div>
                <div class="remark-field">
                    <label for="ticketRemark_file">Attachment</label>
                    <input type="file" id="ticketRemark_file" name="ticketRemark_file" class="form-control" />
                    <div class="dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete" id="dropzoneticketRemark" style="display: none;">
                        <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column" id="conentdivticketRemark" style="display: none!important;">
                            <div class="flex-1 d-flex flex-between-center">
                                <div id="filesdivticketRemark" style="margin-top: 10px; margin-bottom: 10px;"></div>
                                <div class="dropdown font-sans-serif">
                                    <button class="btn btn-link text-600 btn-sm dropdown-toggle btn-reveal dropdown-caret-none" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="true"></button>
                                    <div class="dropdown-menu dropdown-menu-end border py-2"><a class="dropdown-item" href="#!" data-dz-remove="data-dz-remove">Remove File</a></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="remark-field remark-tat-field">
                    <label>Expected TAT</label>
                    <div class="remark-tat-row">
                        <select id="ticketRemark_days" name="ticketRemark_days" class="form-control"></select><span>Days</span>
                        <select id="ticketRemark_hours" name="ticketRemark_hours" class="form-control"></select><span>Hours</span>
                        <select id="ticketRemark_minutes" name="ticketRemark_minutes" class="form-control"></select><span>Minutes</span>
                    </div>
                </div>
                <div class="remark-field full">
                    <label for="ticketRemark_Description">Description</label>
                    <textarea id="ticketRemark_Description" name="ticketRemark_Description" class="form-control" style="height: 100px;"></textarea>
                </div>
            </div>
            <div class="remark-actions">
                <button type="button" class="btn btn-primary" onclick="return btnUpdateTicket_newRemark();"><i class="fas fa-paper-plane"></i>&nbsp;Submit Remark</button>
            </div>
        </div>

        <div class="remark-section-card">
            <div class="remark-section-header">
                <div>
                    <h5>Remark History</h5>
                    <span>Previous ticket updates and status changes</span>
                </div>
            </div>
            <div class="remark-history-wrap">
                <table id="table_ticketRemarkHistory" class="table table-hover">
                    <thead>
                        <tr>
                            <th class="sort border-top" style="width: 50px;">Sr. #</th>
                            <th class="sort border-top" style="width: 100px;">Ticket #</th>
                            <th class="sort border-top" style="width: 450px;">Remark</th>
                            <th class="sort border-top" style="width: 70px;">Status</th>
                            <th class="sort border-top" style="width: 150px;">Remark Added By</th>
                            <th class="sort border-top" style="width: 150px;">Added Date</th>
                        </tr>
                    </thead>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="ticketremark_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="ticketremark_errmsg"></h6>
                </div>
                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="ticketremark_btnMessage" onclick="location.reload();">Okay</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="waitingpanelTicket" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">System is updating details. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>

</asp:Content>
