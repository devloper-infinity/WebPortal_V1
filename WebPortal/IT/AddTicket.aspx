<%@ Page Title="" Language="C#" MasterPageFile="~/IT/Admin.Master" AutoEventWireup="true" CodeBehind="AddTicket.aspx.cs" Inherits="WebPortal.IT.AddTicket" %>

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
            /*background: linear-gradient(to bottom, #007bff, 3%, #fff) !important;*/
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

    <script type="text/javascript">
        $(document).ready(function () {
            addticket_bindrequestonbehalf();
            addticket_bindrequestrelatedto();
            addticket_Binddays();
            addticket_Bindhours();
            addticket_Bindminutes();
            addticket_bindgrid();
        });

        var fileslist = '';
        var fd = new FormData();

        window.onload = function () {

            document.getElementById('updateTicket_file').addEventListener('change', getFileName);
            document.getElementById('addticket_file').addEventListener('change', getFileName);
        }

        const getFileName = (event) => {

            for (var i = 0; i < event.target.files.length; i++) {
                const files = event.target.files;
                var file = files[i];
                document.getElementById("fpAddTckAttach").value = files[i].name;
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
            document.getElementById("dropzone").classList.add("dz-max-files-reached");
            document.getElementById("conentdiv").style.display = '';
            document.getElementById("filesdiv").innerHTML = fileslist;
        }

    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="fpAddTckAttach" style="display: none;" />
    <input id="fpUpdateTckAttach" style="display: none;" />

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Add New Ticket</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <h5 class="card-title"></h5>
                <table class="table">
                    <tr>
                        <td><b>Request Related To:</b></td>
                        <td>
                            <select id="addticket_requestrelatedto" name="addticket_requestrelatedto" class="form-control" style="width: 250px;" onchange="getrequestdepartment(this);"></select>
                        </td>
                        <td><b>Department:</b></td>
                        <td>
                            <select id="addticket_department" name="addticket_department" class="form-control" style="width: 250px;"></select>
                           
                        </td>
                        <td><b>Request On Behalf:</b></td>
                        <td>
                            <select id="addticket_onbehalf" name="addticket_onbehalf" class="form-control" style="width: 250px;"></select>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Subject:</b></td>
                        <td>
                            <input type="text" id="addticket_subject" name="addticket_subject" class="form-control" style="width: 250px;" />
                        </td>
                        <td><b>Desk #:</b></td>
                        <td>
                            <input type="text" id="addticket_deskno" name="addticket_deskno" class="form-control" style="width: 250px;" />
                        </td>
                        <td><b>Attachment:</b></td>
                        <td>
                            <%-- <input type="file" id="addticket_file" name="addticket_file" class="form-control" style="width: 250px;" />
                            <input type="file" id="addticket_file" name="addticket_file" class="form-control" style="width: 250px;" multiple />
                            <div class="dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete" id="dropzoneaddticketdoc" style="display: none;">
                                <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column" id="conentdivaddticketdoc" style="display: none!important;">
                                    <div class="flex-1 d-flex flex-between-center">
                                        <div id="filesdivaddticketdoc" style="margin-top: 10px; margin-bottom: 10px;"></div>
                                        <div class="dropdown font-sans-serif">
                                            <button class="btn btn-link text-600 btn-sm dropdown-toggle btn-reveal dropdown-caret-none" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="true"></button>
                                            <div class="dropdown-menu dropdown-menu-end border py-2"><a class="dropdown-item" href="#!" data-dz-remove="data-dz-remove">Remove File</a></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </td>
                        <td></td>
                    </tr>
                    <tr>
                        <td><b>Expected TAT:</b></td>
                        <td colspan="2">
                            <select id="addticket_days" name="addticket_days" class="form-control" style="width: 75px; display: inline;"></select>
                            &nbsp;&nbsp; <span><b>Days</b></span>&nbsp;&nbsp; 
                            <select id="addticket_hours" name="addticket_hours" class="form-control" style="width: 75px; display: inline;"></select>
                            &nbsp;&nbsp; <span><b>Hours</b></span>
                            &nbsp;&nbsp; 
                            <select id="addticket_minutes" name="addticket_minutes" class="form-control" style="width: 75px; display: inline;"></select>
                            &nbsp;&nbsp; <span><b>Minutes</b></span>
                        </td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td><b>Description:</b></td>
                        <td colspan="5">
                            <textarea id="addticket_description" name="addticket_description" class="form-control" style="width: 600px; height: 120px;"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="6" style="text-align: center;">
                            <button id="addticket_btnsubmit" name="addticket_btnsubmit" class="btn btn-primary" onclick="return addticket_submit();">Submit</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <table class="table" id="addticket_table" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center; display: none;">TicketId</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center; display: none;">RequestId</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Actions</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Ticket #</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Request Related To</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Request Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Department</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Subject</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Description</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Status</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="addTicket_reOpen" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="addTicket_reOpenLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addTicket_reOpenLabel"></h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <label id="addTicket_reOpenMsg" class="form-control" style="color: red; font-weight: bold; font-size: medium; display: none;"></label>
                    <table class="table">
                        <tr>
                            <td><b>Status</b></td>
                            <td>
                                <input type="text" id="addTicket_reOpenStatus" name="addTicket_reOpenStatus" class="form-control" style="width: 250px;" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <b>Remark</b>
                            </td>
                            <td>
                                <textarea type="text" id="addTicket_reOpenRemark" name="addTicket_reOpenRemark" class="form-control" style="width: 670px; height: 100px;"></textarea>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" id="btnReopenTicket" onclick="return btnaddTicket_reOpen();">Re-Open</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="addTicket_closure" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="addTicket_closureLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addTicket_closureLabel"></h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table">
                        <tr>
                            <td><b>Status</b></td>
                            <td>
                                <input type="text" id="addTicket_closureStatus" name="addTicket_reOpenStatus" class="form-control" style="width: 250px;" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <b>Remark</b>
                            </td>
                            <td>
                                <textarea type="text" id="addTicket_closureRemark" name="addTicket_closureRemark" class="form-control" style="width: 670px; height: 100px;"></textarea>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" onclick="return btnaddTicket_closure();">Submit</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="addTicket_view" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="addTicket_viewLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addTicket_viewLabel"></h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table">
                        <tr>
                            <td>
                                <b>Description :</b>
                            </td>
                            <td>
                                <textarea id="updateTicket_Description" name="updateTicket_Description" class="form-control" style="width: 400px;"></textarea>
                            </td>
                            <td>
                                <b>Status :</b>
                            </td>
                            <td>
                                <select id="updateTicket_Status" name="updateTicket_Status" class="form-control" style="width: 250px;">
                                    <option value="Select">Select</option>
                                    <option value="Open">Open</option>
                                    <option value="Closed">Closed</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="updateTicket_TATlabel" class="form-control" style="font-weight: bold; font-size: 11px;"></label>
                            </td>
                            <td>
                                <select id="updateTicket_days" name="updateTicket_days" class="form-control" style="width: 75px; display: inline;"></select>
                                &nbsp;&nbsp; <span><b>Days</b></span>&nbsp;&nbsp;&nbsp;  
                            <select id="updateTicket_hours" name="updateTicket_hours" class="form-control" style="width: 75px; display: inline;"></select>
                                &nbsp;&nbsp; <span><b>Hours</b></span>
                                &nbsp;&nbsp;&nbsp;  
                            <select id="updateTicket_minutes" name="updateTicket_minutes" class="form-control" style="width: 75px; display: inline;"></select>
                                &nbsp;&nbsp; <span><b>Minutes</b></span>
                            </td>
                            <td><b>Attachment:</b></td>
                            <td>
                                <%-- <input type="file" id="updateTicket_file" name="updateTicket_file" class="form-control" style="width: 250px;" />
                                <input type="file" id="updateTicket_file" name="updateTicket_file" class="form-control" style="width: 250px;" />
                                <div class="dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete" id="dropzoneupdatedoc" style="display: none;">
                                    <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column" id="conentdivupdatedoc" style="display: none!important;">
                                        <div class="flex-1 d-flex flex-between-center">
                                            <div id="filesdivupdatedoc" style="margin-top: 10px; margin-bottom: 10px;"></div>
                                            <div class="dropdown font-sans-serif">
                                                <button class="btn btn-link text-600 btn-sm dropdown-toggle btn-reveal dropdown-caret-none" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="true"></button>
                                                <div class="dropdown-menu dropdown-menu-end border py-2"><a class="dropdown-item" href="#!" data-dz-remove="data-dz-remove">Remove File</a></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td style="text-align: right;">
                                <button type="button" class="btn btn-primary" onclick="return btnaddTicket_newRemark();">Submit</button>
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                    </table>
                    <br />
                    <table id="table_ticketHistory" class="table">
                        <thead>
                            <tr>
                                <th class="sort border-top" style="width: 50px;">Sr. #</th>
                                <th class="sort border-top" style="width: 100px;">Tickect #</th>
                                <th class="sort border-top" style="width: 450px;">Remark</th>
                                <th class="sort border-top" style="width: 70px;">Status</th>
                                <th class="sort border-top" style="width: 150px;">Remark Added By</th>
                                <th class="sort border-top" style="width: 150px;">Added Date</th>
                            </tr>
                        </thead>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="addticket_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="addticket_errmsg"></h6>
                </div>
                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="addticket_btnMessage" onclick="location.reload();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

    <div class="modal fade" id="waitingpanelAddTicket" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">System is updating details. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>

</asp:Content>--%>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --ticket-primary: #2563eb;
            --ticket-primary-dark: #1d4ed8;
            --ticket-accent: #f97316;
            --ticket-bg: #f6f8fb;
            --ticket-card: #ffffff;
            --ticket-text: #172033;
            --ticket-muted: #64748b;
            --ticket-border: #e5e7eb;
            --ticket-soft: #eff6ff;
            --ticket-shadow: 0 12px 30px rgba(15, 23, 42, .08);
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

        .ticket-page {
            background: var(--ticket-bg);
            padding: 18px 18px 30px;
            border-radius: 18px;
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
            box-shadow: var(--ticket-shadow);
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

            .ticket-hero h4 {
                position: relative;
                z-index: 1;
                margin: 0;
                font-weight: 800;
                letter-spacing: .2px;
            }

            .ticket-hero p {
                position: relative;
                z-index: 1;
                margin: 7px 0 0;
                color: rgba(255, 255, 255, .86);
            }

        .ticket-section-card {
            border: 1px solid var(--ticket-border);
            border-radius: 18px;
            box-shadow: var(--ticket-shadow);
            background: var(--ticket-card);
            margin-bottom: 18px;
        }

        .ticket-section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 18px 20px;
            border-bottom: 1px solid var(--ticket-border);
        }

            .ticket-section-header h5 {
                margin: 0;
                color: var(--ticket-text);
                font-weight: 800;
            }

            .ticket-section-header span {
                color: var(--ticket-muted);
                font-size: 13px;
            }

        .ticket-form-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(220px, 1fr));
            gap: 18px;
            padding: 20px;
        }

        .ticket-field.full {
            grid-column: 1 / -1;
        }

        .ticket-field.tat {
            grid-column: span 2;
        }

        .ticket-field label,
        .modal-ticket-label {
            display: block;
            margin-bottom: 7px;
            color: var(--ticket-text);
            font-size: 13px;
            font-weight: 700 !important;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: normal !important;
            border: none !important;
        }

        .ticket-field label,
        .modal-ticket-label {
            font-weight: 700 !important;
        }

        .ticket-field .form-control,
        .ticket-field select,
        .ticket-field textarea,
        .modal-body .form-control {
            width: 100% !important;
            border: 1px solid var(--ticket-border);
            border-radius: 12px;
            min-height: 42px;
            box-shadow: none;
            transition: border-color .2s ease, box-shadow .2s ease;
        }

            .ticket-field .form-control:focus,
            .ticket-field select:focus,
            .ticket-field textarea:focus,
            .modal-body .form-control:focus {
                border-color: var(--ticket-primary);
                box-shadow: 0 0 0 .18rem rgba(37, 99, 235, .12);
            }

        .ticket-field textarea {
            min-height: 128px;
            resize: vertical;
        }

        .ticket-tat-row {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 10px;
        }

            .ticket-tat-row select {
                max-width: 90px;
                display: inline-block !important;
            }

            .ticket-tat-row span {
                color: var(--ticket-muted);
                font-weight: 700;
                margin-right: 8px;
            }

        .ticket-actions {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 12px;
            padding: 0 20px 20px;
        }

            .ticket-actions .btn,
            .modal-footer .btn {
                border-radius: 999px;
                padding: 9px 22px;
                font-weight: 700;
            }

        .btn-primary {
            background: linear-gradient(135deg, var(--ticket-primary), var(--ticket-primary-dark));
            border: 0;
            box-shadow: 0 8px 18px rgba(37, 99, 235, .24);
        }

            .btn-primary:hover,
            .btn-primary:focus {
                background: linear-gradient(135deg, var(--ticket-primary-dark), #1e40af);
            }

        .ticket-file-note {
            margin-top: 8px;
            color: var(--ticket-muted);
            font-size: 12px;
        }

        .ticket-table-wrap {
            padding: 18px 20px 20px;
            overflow-x: auto;
        }

            .ticket-table-wrap table.dataTable,
            .ticket-table-wrap .table {
                border-collapse: separate !important;
                border-spacing: 0 8px !important;
            }

            .ticket-table-wrap thead th {
                color: var(--ticket-muted) !important;
                background: var(--ticket-soft);
                border: 0 !important;
                font-size: 12px;
                text-transform: uppercase;
                letter-spacing: .04em;
            }

            .ticket-table-wrap tbody td {
                border-top: 1px solid var(--ticket-border) !important;
                border-bottom: 1px solid var(--ticket-border) !important;
                background: #fff !important;
                vertical-align: middle;
            }

                .ticket-table-wrap tbody td:first-child {
                    border-left: 1px solid var(--ticket-border) !important;
                    border-radius: 12px 0 0 12px;
                }

                .ticket-table-wrap tbody td:last-child {
                    border-right: 1px solid var(--ticket-border) !important;
                    border-radius: 0 12px 12px 0;
                }

        .dataTables_length, .dataTables_info {
            float: left !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 20px;
            float: left;
        }

        .buttons-excel, .buttons-html5 {
            color: #fff;
            box-shadow: none;
            background: linear-gradient(to right, #ffbf96, #fe7096);
            border: 0;
            font-weight: bold;
            margin: 0 10px;
            border-radius: 999px;
        }

        .modal-content {
            border: 0;
            border-radius: 18px;
            box-shadow: var(--ticket-shadow);
        }

        .modal-header {
            background: linear-gradient(135deg, #eff6ff, #ffffff);
            border-bottom: 1px solid var(--ticket-border);
            border-radius: 18px 18px 0 0;
        }

        .modal-title {
            color: var(--ticket-text);
            font-weight: 800;
        }

        .modal-form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(220px, 1fr));
            gap: 16px;
        }

            .modal-form-grid .full {
                grid-column: 1 / -1;
            }

            .modal-form-grid textarea {
                min-height: 110px;
            }

        .history-wrap {
            overflow-x: auto;
            margin-top: 16px;
        }

        #table_ticketHistory th {
            background: var(--ticket-soft);
            color: var(--ticket-muted);
            border: 0;
            font-size: 12px;
            text-transform: uppercase;
        }

        @media (max-width: 992px) {
            .ticket-form-grid,
            .modal-form-grid {
                grid-template-columns: repeat(2, minmax(200px, 1fr));
            }

            .ticket-field.tat {
                grid-column: 1 / -1;
            }
        }

        @media (max-width: 576px) {
            .ticket-page {
                padding: 12px;
            }

            .ticket-hero {
                padding: 20px;
                align-items: flex-start;
                flex-direction: column;
            }

            .ticket-form-grid,
            .modal-form-grid {
                grid-template-columns: 1fr;
                padding: 16px;
            }

            .ticket-actions {
                justify-content: stretch;
                padding: 0 16px 16px;
            }

                .ticket-actions .btn {
                    width: 100%;
                }
        }
    </style>

    <script type="text/javascript">
        $(document).ready(function () {
            addticket_bindrequestonbehalf();
            addticket_bindrequestrelatedto();
            addticket_Binddays();
            addticket_Bindhours();
            addticket_Bindminutes();
            addticket_bindgrid();
        });

        var fileslist = '';
        var fd = new FormData();

        window.onload = function () {
            document.getElementById('updateTicket_file').addEventListener('change', getFileName);
            document.getElementById('addticket_file').addEventListener('change', getFileName);
        }

        const getFileName = (event) => {
            for (var i = 0; i < event.target.files.length; i++) {
                const files = event.target.files;
                var file = files[i];
                document.getElementById("fpAddTckAttach").value = files[i].name;
                if (fileslist != '')
                    fileslist = fileslist + ',' + file.name;
                else
                    fileslist = file.name;
                fd.append(event.target.name, file, file.name);
            }

            const xhr = new XMLHttpRequest();

            xhr.onload = () => {
                if (xhr.status >= 200 && xhr.status < 300) {
                    // Upload completed.
                }
            };
            var url = window.location.href;
            xhr.open('POST', url, true);
            xhr.send(fd);

            var isAddTicket = event.target.id === 'addticket_file';
            var dropzoneId = isAddTicket ? 'dropzoneaddticketdoc' : 'dropzoneupdatedoc';
            var contentId = isAddTicket ? 'conentdivaddticketdoc' : 'conentdivupdatedoc';
            var filesId = isAddTicket ? 'filesdivaddticketdoc' : 'filesdivupdatedoc';

            if (document.getElementById(dropzoneId)) document.getElementById(dropzoneId).classList.add("dz-max-files-reached");
            if (document.getElementById(contentId)) document.getElementById(contentId).style.display = '';
            if (document.getElementById(filesId)) document.getElementById(filesId).innerHTML = fileslist;
        }
    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="fpAddTckAttach" style="display: none;" />
    <input id="fpUpdateTckAttach" style="display: none;" />

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <%-- <div class="content-header" style="width: 100%;">
        <div class="container-fluid"> </div>
    </div>--%>
    <div class="ticket-page">
        <div class="ticket-hero">
            <div>
                <h4><i class="fas fa-ticket-alt"></i>&nbsp;&nbsp;Add New Ticket</h4>
                <p>Create, track, update, and close support tickets from one place.</p>
            </div>
        </div>

        <div class="ticket-section-card">
            <div class="ticket-section-header">
                <div>
                    <h5>Ticket Details</h5>
                    <span>Fill in the request information and expected turnaround time.</span>
                </div>
            </div>

            <div class="ticket-form-grid">
                <div class="ticket-field">
                    <label for="addticket_requestrelatedto">Request Related To</label>
                    <select id="addticket_requestrelatedto" name="addticket_requestrelatedto" class="form-control" onchange="getrequestdepartment(this);"></select>
                </div>

                <div class="ticket-field">
                    <label for="addticket_department">Department</label>
                    <select id="addticket_department" name="addticket_department" class="form-control"></select>
                </div>

                <div class="ticket-field">
                    <label for="addticket_onbehalf">Request On Behalf</label>
                    <select id="addticket_onbehalf" name="addticket_onbehalf" class="form-control"></select>
                </div>

                <div class="ticket-field">
                    <label for="addticket_subject">Subject</label>
                    <input type="text" id="addticket_subject" name="addticket_subject" class="form-control" placeholder="Enter ticket subject" />
                </div>

                <div class="ticket-field">
                    <label for="addticket_deskno">Desk #</label>
                    <input type="text" id="addticket_deskno" name="addticket_deskno" class="form-control" placeholder="Enter desk number" />
                </div>

                <div class="ticket-field">
                    <label for="addticket_file">Attachment</label>
                    <input type="file" id="addticket_file" name="addticket_file" class="form-control" multiple />
                    <div class="ticket-file-note">You can attach multiple files.</div>
                    <div class="dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete" id="dropzoneaddticketdoc" style="display: none;">
                        <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column" id="conentdivaddticketdoc" style="display: none!important;">
                            <div class="flex-1 d-flex flex-between-center">
                                <div id="filesdivaddticketdoc" style="margin-top: 10px; margin-bottom: 10px;"></div>
                                <div class="dropdown font-sans-serif">
                                    <button class="btn btn-link text-600 btn-sm dropdown-toggle btn-reveal dropdown-caret-none" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="true"></button>
                                    <div class="dropdown-menu dropdown-menu-end border py-2"><a class="dropdown-item" href="#!" data-dz-remove="data-dz-remove">Remove File</a></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="ticket-field tat">
                    <label>Expected TAT</label>
                    <div class="ticket-tat-row">
                        <select id="addticket_days" name="addticket_days" class="form-control"></select><span>Days</span>
                        <select id="addticket_hours" name="addticket_hours" class="form-control"></select><span>Hours</span>
                        <select id="addticket_minutes" name="addticket_minutes" class="form-control"></select><span>Minutes</span>
                    </div>
                </div>

                <div class="ticket-field full">
                    <label for="addticket_description">Description</label>
                    <textarea id="addticket_description" name="addticket_description" class="form-control" placeholder="Describe the issue or request clearly"></textarea>
                </div>
            </div>

            <div class="ticket-actions">
                <button id="addticket_btnsubmit" name="addticket_btnsubmit" class="btn btn-primary" onclick="return addticket_submit();">
                    <i class="fas fa-paper-plane"></i>&nbsp; Submit Ticket
                       
                </button>
            </div>
        </div>

        <div class="ticket-section-card">
            <div class="ticket-section-header">
                <div>
                    <h5>My Tickets</h5>
                    <span>Review submitted tickets and take available actions.</span>
                </div>
            </div>
            <div class="ticket-table-wrap">
                <table class="table" id="addticket_table" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center; display: none;">TicketId</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center; display: none;">RequestId</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Actions</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Ticket #</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Request Related To</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Request Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Department</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Subject</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Description</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Status</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>


    <div class="modal fade" id="addTicket_reOpen" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="addTicket_reOpenLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addTicket_reOpenLabel"></h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                </div>
                <div class="modal-body">
                    <label id="addTicket_reOpenMsg" class="form-control" style="color: red; font-weight: bold; font-size: medium; display: none;"></label>
                    <div class="modal-form-grid">
                        <div>
                            <label class="modal-ticket-label" for="addTicket_reOpenStatus">Status</label>
                            <input type="text" id="addTicket_reOpenStatus" name="addTicket_reOpenStatus" class="form-control" />
                        </div>
                        <div class="full">
                            <label class="modal-ticket-label" for="addTicket_reOpenRemark">Remark</label>
                            <textarea type="text" id="addTicket_reOpenRemark" name="addTicket_reOpenRemark" class="form-control"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" id="btnReopenTicket" onclick="return btnaddTicket_reOpen();">Re-Open</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="addTicket_closure" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="addTicket_closureLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addTicket_closureLabel"></h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                </div>
                <div class="modal-body">
                    <div class="modal-form-grid">
                        <div>
                            <label class="modal-ticket-label" for="addTicket_closureStatus">Status</label>
                            <input type="text" id="addTicket_closureStatus" name="addTicket_reOpenStatus" class="form-control" />
                        </div>
                        <div class="full">
                            <label class="modal-ticket-label" for="addTicket_closureRemark">Remark</label>
                            <textarea type="text" id="addTicket_closureRemark" name="addTicket_closureRemark" class="form-control"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" onclick="return btnaddTicket_closure();">Submit</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="addTicket_view" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="addTicket_viewLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addTicket_viewLabel"></h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                </div>
                <div class="modal-body">
                    <div class="modal-form-grid">
                        <div class="full">
                            <label class="modal-ticket-label" for="updateTicket_Description">Description</label>
                            <textarea id="updateTicket_Description" name="updateTicket_Description" class="form-control"></textarea>
                        </div>
                        <div>
                            <label class="modal-ticket-label" for="updateTicket_Status">Status</label>
                            <select id="updateTicket_Status" name="updateTicket_Status" class="form-control">
                                <option value="Select">Select</option>
                                <option value="Open">Open</option>
                                <option value="Closed">Closed</option>
                            </select>
                        </div>
                        <div>
                            <label id="updateTicket_TATlabel" class="modal-ticket-label"></label>
                            <div class="ticket-tat-row">
                                <select id="updateTicket_days" name="updateTicket_days" class="form-control"></select><span>Days</span>
                                <select id="updateTicket_hours" name="updateTicket_hours" class="form-control"></select><span>Hours</span>
                                <select id="updateTicket_minutes" name="updateTicket_minutes" class="form-control"></select><span>Minutes</span>
                            </div>
                        </div>
                        <div>
                            <label class="modal-ticket-label" for="updateTicket_file">Attachment</label>
                            <input type="file" id="updateTicket_file" name="updateTicket_file" class="form-control" />
                            <div class="dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete" id="dropzoneupdatedoc" style="display: none;">
                                <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column" id="conentdivupdatedoc" style="display: none!important;">
                                    <div class="flex-1 d-flex flex-between-center">
                                        <div id="filesdivupdatedoc" style="margin-top: 10px; margin-bottom: 10px;"></div>
                                        <div class="dropdown font-sans-serif">
                                            <button class="btn btn-link text-600 btn-sm dropdown-toggle btn-reveal dropdown-caret-none" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="true"></button>
                                            <div class="dropdown-menu dropdown-menu-end border py-2"><a class="dropdown-item" href="#!" data-dz-remove="data-dz-remove">Remove File</a></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="history-wrap">
                        <table id="table_ticketHistory" class="table">
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
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" onclick="return btnaddTicket_newRemark();">Submit</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="addticket_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="addticket_errmsg"></h6>
                </div>
                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="addticket_btnMessage" onclick="location.reload();">Okay</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="waitingpanelAddTicket" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">System is updating details. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>
</asp:Content>

