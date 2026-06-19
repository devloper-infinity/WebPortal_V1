<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="UserProjectNotifications.aspx.cs" Inherits="WebPortal.Admin.UserProjectNotifications" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --vl-primary: #1d4ed8;
            --vl-primary-2: #2563eb;
            --vl-cyan: #22c1dc;
            --vl-bg: #f4f7fb;
            --vl-card: #ffffff;
            --vl-text: #071426;
            --vl-muted: #64748b;
            --vl-border: #d8e5f7;
            --vl-soft: #eff6ff;
            --vl-shadow: 0 18px 40px rgba(15, 23, 42, .10);
            --vl-radius: 18px;
        }

        body {
            background: var(--vl-bg) !important;
        }

        .ud-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            gap: 18px;
            padding: 22px 28px;
            border-radius: 22px;
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%);
            box-shadow: var(--ud-shadow);
        }

            .ud-hero:before,
            .ud-hero:after {
                content: "";
                position: absolute;
                border-radius: 999px;
                background: rgba(255, 255, 255, .12);
            }

            .ud-hero:before {
                width: 220px;
                height: 220px;
                right: 70px;
                top: -120px;
            }

            .ud-hero:after {
                width: 300px;
                height: 300px;
                right: -90px;
                bottom: -170px;
            }

        .ud-hero-icon {
            position: relative;
            z-index: 1;
            width: 50px;
            height: 50px;
            display: grid;
            place-items: center;
            flex-shrink: 0;
            border-radius: 18px;
            background: rgba(255, 255, 255, .16);
            border: 1px solid rgba(255, 255, 255, .22);
            font-size: 24px;
        }

        .ud-hero-content {
            position: relative;
            z-index: 1;
        }

        .ud-title {
            margin: 0;
            font-size: 19px;
            font-weight: 800;
            letter-spacing: -.02em;
        }

        .ud-subtitle {
            margin: 8px 0 0;
            font-size: 12px;
            opacity: .9;
        }

        .col-lg-12 {
            margin-bottom: 18px;
            background: var(--vl-bg) !important;
            width: 100%;
        }

            .col-lg-12 > .card,
            .container-fluid.mt-3 .card {
                border: 1px solid var(--vl-border) !important;
                border-radius: var(--vl-radius) !important;
                background: #fff !important;
                box-shadow: 0 14px 30px rgba(15, 23, 42, .06) !important;
                overflow: hidden;
                margin-top: 30px;
                width: 100%;
            }

                .col-lg-12 > .card > .card-body {
                    padding: 18px !important;
                }

                    .col-lg-12 > .card > .card-body:before {
                        content: "\f0f3  Project Notification Panel";
                        font-family: "Font Awesome 5 Free", Arial, sans-serif;
                        display: block;
                        margin-bottom: 16px;
                        color: var(--vl-text);
                        font-size: 15px;
                        font-weight: 800;
                    }

        .sla-grid {
            display: grid !important;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 14px 16px;
            align-items: end;
        }

        .sla-field,
        .sla-field-msg,
        .sla-field-btn {
            min-width: 0;
        }

            .sla-field label,
            .sla-field-msg label,
            .sla-field-btn label {
                display: block;
                margin: 0 0 7px;
                color: #334155;
                font-size: 11px;
                font-weight: 700;
                letter-spacing: .02em;
            }

            .sla-field input,
            .sla-field select,
            .sla-field-msg textarea,
            .form-control {
                width: 100%;
                min-height: 36px;
                padding: 8px 12px;
                border: 1px solid #cfdced !important;
                border-radius: 11px !important;
                background: #fff !important;
                color: #0f172a !important;
                font-size: 12px !important;
                box-shadow: none !important;
                outline: none !important;
                transition: all .22s ease;
            }

                .sla-field input:focus,
                .sla-field select:focus,
                .sla-field-msg textarea:focus,
                .form-control:focus {
                    border-color: #2563eb !important;
                    box-shadow: 0 0 0 4px rgba(37, 99, 235, .10) !important;
                }

        .sla-field-msg {
            grid-column: 1 / -1 !important;
        }

            .sla-field-msg textarea {
                min-height: 74px !important;
                resize: vertical;
            }

        #upnot_Project {
            width: calc(100% - 112px) !important;
            display: inline-block !important;
            vertical-align: middle;
        }

        .smart-btn {
            min-height: 36px;
            margin-left: 8px;
            padding: 0 14px;
            border: 0;
            border-radius: 11px;
            color: #fff;
            font-size: 12px;
            font-weight: 800;
            background: linear-gradient(120deg, #2563eb 0%, #0891b2 100%);
            box-shadow: 0 10px 22px rgba(37, 99, 235, .20);
            cursor: pointer;
            transition: all .22s ease;
        }

            .smart-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 14px 28px rgba(37, 99, 235, .28);
            }

        .listbox-ul {
            width: 100% !important;
            height: 142px !important;
            margin: 0;
            padding: 8px;
            list-style: none;
            overflow: auto;
            border: 1px solid #cfdced;
            border-radius: 14px;
            background: #fbfdff;
        }

            .listbox-ul li {
                margin-bottom: 6px;
                padding: 8px 10px;
                border-radius: 10px;
                border: 1px solid #dbeafe;
                background: #eff6ff;
                color: #0f172a;
                font-size: 12px;
                cursor: grab;
            }

        .sla-field-btn {
            display: flex;
            align-items: end;
            height: auto !important;
        }

        .btn-gradient-primary,
        .transfer-btn {
            width: 100%;
            min-height: 38px;
            border: 0 !important;
            border-radius: 12px !important;
            color: #fff !important;
            font-size: 12px !important;
            font-weight: 800 !important;
            background: linear-gradient(120deg, #2563eb 0%, #22c1dc 100%) !important;
            box-shadow: 0 12px 24px rgba(37, 99, 235, .20) !important;
            transition: all .22s ease;
        }

            .btn-gradient-primary:hover,
            .transfer-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 16px 30px rgba(37, 99, 235, .30) !important;
            }

        .container-fluid.mt-3 {
            padding: 0 !important;
        }

            .container-fluid.mt-3 .card {
                margin-top: 18px !important;
            }

        .card-blue.card-outline {
            padding: 18px 18px 14px !important;
            border: 0 !important;
            background: #fff !important;
            color: var(--vl-text) !important;
            font-weight: 800;
        }

            .card-blue.card-outline i {
                width: 30px;
                height: 30px;
                display: inline-grid;
                place-items: center;
                margin-right: 8px;
                border-radius: 10px;
                color: #2563eb;
                background: #eff6ff;
            }

            .card-blue.card-outline b {
                font-size: 15px !important;
            }

        #grdAlert {
            width: 100% !important;
            border-collapse: separate !important;
            border-spacing: 0 !important;
            color: #0f172a;
        }

            #grdAlert thead th {
                padding: 11px 12px !important;
                border: 0 !important;
                border-bottom: 1px solid #60a5fa !important;
                background: linear-gradient(180deg, #eaf5ff 0%, #dbeeff 100%) !important;
                color: #0f172a !important;
                font-size: 11px !important;
                font-weight: 800 !important;
                white-space: nowrap;
            }

            #grdAlert tbody td {
                padding: 12px !important;
                border-top: 1px solid #d6dee9 !important;
                color: #0f172a !important;
                font-size: 12px !important;
                vertical-align: top;
                background: #fff;
            }

            #grdAlert tbody tr:hover td {
                background: #f8fbff !important;
            }

        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dataTables_filter,
        .dataTables_wrapper .dataTables_info,
        .dataTables_wrapper .dataTables_paginate {
            color: #0f172a !important;
            font-size: 11px !important;
            font-weight: 700;
        }

            .dataTables_wrapper .dataTables_length select,
            .dataTables_wrapper .dataTables_filter input {
                height: 34px;
                min-height: 34px;
                border: 1px solid #cfdced !important;
                border-radius: 11px !important;
                padding: 6px 10px !important;
                background: #fff !important;
                outline: none !important;
            }

            .dataTables_wrapper .dataTables_filter input {
                width: 160px;
            }

            .dataTables_wrapper .dataTables_paginate .paginate_button {
                border-radius: 9px !important;
                border: 1px solid #dbeafe !important;
                background: #fff !important;
                color: #0f172a !important;
                margin: 0 2px !important;
                padding: 5px 9px !important;
            }

                .dataTables_wrapper .dataTables_paginate .paginate_button.current {
                    color: #fff !important;
                    border-color: transparent !important;
                    background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%) !important;
                }

        .loading {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            width: 180px;
            min-height: 150px;
            padding: 22px;
            margin: 0;
            transform: translate(-50%, -50%);
            text-align: center;
            background: rgba(255, 255, 255, .96);
            border-radius: 22px;
            box-shadow: 0 24px 60px rgba(15, 23, 42, .22);
            z-index: 99999;
        }

            .loading img {
                max-width: 70px;
            }

        .error {
            border-color: #ef4444 !important;
            box-shadow: 0 0 0 4px rgba(239, 68, 68, .12) !important;
        }

        @media (max-width: 1100px) {
            .sla-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .sla-field-msg,
            .sla-field-btn {
                grid-column: 1 / -1;
            }
        }

        @media (max-width: 640px) {
            .content-header,
            .col-lg-12 {
                padding-left: 12px !important;
                padding-right: 12px !important;
            }

            .sla-grid {
                grid-template-columns: 1fr;
            }

            #upnot_Project {
                width: 100% !important;
                margin-bottom: 8px;
            }

            .smart-btn {
                width: 100%;
                margin-left: 0;
            }
        }
    </style>

    <style>
        .listbox-ul {
            width: 100% !important;
            height: 150px;
            list-style: none;
            overflow-y: auto;
            padding: 4px;
            margin: 0;
            border-radius: 8px;
            border: 1px solid #dcdfe6;
            transition: 0.3s;
            font-size: 12px;
        }

            .listbox-ul li {
                width: 100%;
                padding: 3px 4px; /* smaller padding */
                margin: 1px 0; /* VERY small gap */
                margin-bottom: 6px;
                /* background: #ffffff;*/
                border-radius: 6px;
                cursor: grab;
                font-weight: 400;
                line-height: 1.2;
            }

                .listbox-ul li:hover {
                    background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;
                    color: #fff;
                }

                .listbox-ul li.selected {
                    background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;
                    color: #fff;
                }

            .listbox-ul.drag-over {
                border: 2px dashed #07cdae;
                background-color: #daecef;
            }
    </style>

    <style>
        .smart-btn {
            padding: 6px 14px;
            font-size: 12px;
            border-radius: 18px;
            border: none;
            cursor: pointer;
            background: linear-gradient(to right, #90caf9, 10%, #047edf);
            color: white;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            box-shadow: 0 3px 8px rgba(106, 90, 249, 0.25);
            transition: all 0.2s ease;
        }

            .smart-btn:hover {
                transform: translateY(-1px);
            }

            .smart-btn:active {
                transform: scale(0.96);
            }

            .smart-btn:disabled {
                opacity: 0.7;
                cursor: not-allowed;
            }

        /* Spinner */
        .spinner {
            width: 12px;
            height: 12px;
            border: 2px solid rgba(255,255,255,0.4);
            border-top-color: #fff;
            border-radius: 50%;
            display: none;
            animation: spin 0.7s linear infinite;
        }

        @keyframes spin {
            to {
                transform: rotate(360deg);
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            upnot_binddomains();
            bindalertgrid();
        });
        window.onload = function () {
            document.getElementById('upnot_fpAttach').addEventListener('change', getFileName);
        }
        const getFileName = (event) => {
            const files = event.target.files;
            var file = files[0];
            document.getElementById("upnot_filep").value = files[0].name;

            const fd = new FormData();

            // add all selected files
            fd.append(event.target.name, file, file.name);
            // create the request
            const xhr = new XMLHttpRequest();

            xhr.onload = () => {
                if (xhr.status >= 200 && xhr.status < 300) {
                    // we done!
                }
            };
            var url = window.location.href;
            // path to server would be where you'd normally post the form to
            xhr.open('POST', url, true);
            xhr.send(fd);
            //alert(document.getElementById("filep").value);
        }

    </script>

    <link rel="stylesheet" href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
    <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="upnot_filep" style="display: none;" />

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="ud-page">
        <section class="ud-hero">
            <%--   <div class="ud-hero-icon"><i class="bi bi-megaphone-fill"></i></div>--%>
            <div class="ud-hero-icon"><i class="bi bi-diagram-3-fill"></i></div>

            <div class="ud-hero-content">
                <h1 class="ud-title">Project Notifications Master</h1>
                <p class="ud-subtitle">Configure and manage project notification settings, recipients, and alert triggers.</p>
            </div>
        </section>

        <div class="col-lg-12">
            <div class="card">
                <div class="card-body">
                    <div class="sla-grid">

                        <div class="sla-field">
                            <label>Subject</label>
                            <input type="text" id="upnot_subject" class="form-control" placeholder="Enter subject">
                        </div>

                        <div class="sla-field">
                            <label>Effective Date</label>
                            <input type="date" id="upnot_effectivedate" class="form-control">
                        </div>

                        <div class="sla-field">
                            <label>Attachment</label>
                            <input type="file" id="upnot_fpAttach" class="form-control">
                        </div>

                        <div class="sla-field">
                            <label>Domain</label>
                            <select id="upnot_domain" class="form-control" onchange="upnot_bindsubdomain();"></select>
                        </div>

                        <div class="sla-field">
                            <label>Sub Domain</label>
                            <select id="upnot_subdomain" class="form-control" onchange="upnot_bindprojects();"></select>
                        </div>

                        <div class="sla-field">
                            <label>Project</label>
                            <select id="upnot_Project" class="form-control" style="width: 300px; display: inline!important" onchange="upnot_changeproject();"></select>
                            <button id="btnGetUser" class="smart-btn" onclick="return upnot_binduserlist();"><span class="btn-text">Get Users</span><span class="spinner"></span></button>
                        </div>
                        <div class="sla-field-msg">
                            <label>Alert Message</label>
                            <textarea id="upnot_alertmessage" class="form-control" rows="3" placeholder="Enter alert message"></textarea>
                        </div>
                        <div class="sla-field">
                            <label>Available Users</label>
                            <ul id="upnot_userslist" class="listbox-ul" ondragover="upnot_allowDrop(event)" ondrop="upnot_dropLi(event)" style="width: 250px; height: 150px;"></ul>
                        </div>

                        <div class="sla-field">
                            <label>Selected Users</label>
                            <ul id="upnot_selectedusers" class="listbox-ul" ondragover="upnot_allowDrop(event)" ondrop="upnot_dropLi(event)" style="width: 250px; height: 150px;"></ul>
                        </div>

                        <div class="sla-field-btn">
                            <label>&nbsp;&nbsp;</label>
                            <button id="upnot_btnsubmit" class="btn btn-gradient-primary transfer-btn" onclick="return upnot_submitnotifications(event);">Submit Notification</button>
                        </div>
                    </div>
                    <br />
                    <div class="container-fluid mt-3">
                        <div class="card mt-4 shadow-sm">
                            <div class="card-blue card-outline">
                                &nbsp; &nbsp;  <i class="fas fa-list"></i>
                                <b style="font-size: 14px;">&nbsp;&nbsp; Notification History</b>
                            </div>
                            <div class="card-body">
                                <table id="grdAlert" class="table">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Project</th>
                                            <th class="sort border-top" style="text-wrap: nowrap; width: 200px;">Subject</th>
                                            <th class="sort border-top" style="text-wrap: nowrap; width: 1200px;">Message</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Effective Date</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Added By</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Added Date</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<%--<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
   

    <style>
        /* Container */
        .sla-container {
            padding: 20px;
            background: #f5f7fb;
            min-height: 100vh;
        }

        /* Card */
        .sla-card {
            background: #fff;
            border-radius: 14px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
            overflow: hidden;
        }

        /* Header */
        .sla-header {
            background: linear-gradient(135deg, #4e73df, #224abe);
            color: white;
            padding: 15px 20px;
            font-size: 18px;
            font-weight: 600;
        }

        /* Body */
        .sla-body {
            padding: 25px;
        }

        /* Grid */
        .sla-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }

        /* Fields */
        .sla-field label {
            font-size: 12px;
            font-weight: bold;
            color: #6c757d;
            margin-bottom: 5px;
            display: block;
        }

        .sla-field-btn {
            display: flex;
            justify-content: flex-start; /* left */
            align-items: flex-end; /* bottom */
            height: 150px;
        }

        .sla-field-msg {
            color: #6c757d;
            grid-column: span 3 !important;
        }

            .sla-field-msg textarea {
                width: 100%;
                padding: 10px;
                border-radius: 8px;
                border: 1px solid #dcdfe6;
                font-size: 14px;
                resize: vertical;
            }

        .sla-field input,
        .sla-field select {
            width: 100%;
            padding: 10px;
            border-radius: 8px;
            border: 1px solid #dcdfe6;
            transition: 0.3s;
            font-size: 14px;
        }

            /* Focus Effect */
            .sla-field input:focus,
            .sla-field select:focus {
                border-color: #4e73df;
                box-shadow: 0 0 0 2px rgba(78,115,223,0.15);
                outline: none;
            }

        /* Buttons */
        .sla-actions {
            margin-top: 25px;
            text-align: right;
        }

        .btn-save {
            background: #28a745;
            color: #fff;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            margin-right: 10px;
            cursor: pointer;
        }

        .btn-reset {
            background: #6c757d;
            color: #fff;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
        }

        /* Hover */
        .btn-save:hover {
            background: #218838;
        }

        .btn-reset:hover {
            background: #5a6268;
        }

        /* Validation */
        .error {
            border-color: red !important;
        }

        .sla-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr); /* 3 per row */
            gap: 20px;
        }

        .btn-save {
            background: linear-gradient(135deg, #28a745, #218838);
            color: #fff;
            border: none;
            padding: 10px 22px;
            border-radius: 8px;
            cursor: pointer;
            position: relative;
            font-weight: 600;
            transition: 0.3s;
        }

            .btn-save:hover {
                transform: translateY(-1px);
                box-shadow: 0 5px 12px rgba(0,0,0,0.15);
            }

        /* Loader spinner */
        .btn-loader {
            width: 18px;
            height: 18px;
            border: 2px solid #fff;
            border-top: 2px solid transparent;
            border-radius: 50%;
            display: inline-block;
            animation: spin 0.7s linear infinite;
            margin-left: 8px;
        }

        .btn-gradient-primary {
            background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;
            color: #fff;
            border-radius: 12px;
            height: 40px;
            font-weight: 400;
            transition: 0.3s;
        }

            .btn-gradient-primary:hover {
                transform: translateY(-2px);
                background: linear-gradient(135deg, #224abe, #1a3a8f);
                color: #fff;
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
        }
    </style>

    <style>
        .listbox-ul {
            width: 100% !important;
            height: 150px;
            list-style: none;
            overflow-y: auto;
            padding: 4px;
            margin: 0;
            border-radius: 8px;
            border: 1px solid #dcdfe6;
            transition: 0.3s;
            font-size: 12px;
        }

            .listbox-ul li {
                width: 100%;
                padding: 3px 4px; /* smaller padding */
                margin: 1px 0; /* VERY small gap */
                margin-bottom: 6px;
                /* background: #ffffff;*/
                border-radius: 6px;
                cursor: grab;
                font-weight: 400;
                line-height: 1.2;
            }

                .listbox-ul li:hover {
                    background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;
                    color: #fff;
                }

                .listbox-ul li.selected {
                    background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;
                    color: #fff;
                }

            .listbox-ul.drag-over {
                border: 2px dashed #07cdae;
                background-color: #daecef;
            }
    </style>

    <style>
        .smart-btn {
            padding: 6px 14px;
            font-size: 12px;
            border-radius: 18px;
            border: none;
            cursor: pointer;
            background: linear-gradient(to right, #90caf9, 10%, #047edf);
            color: white;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            box-shadow: 0 3px 8px rgba(106, 90, 249, 0.25);
            transition: all 0.2s ease;
        }

            .smart-btn:hover {
                transform: translateY(-1px);
            }

            .smart-btn:active {
                transform: scale(0.96);
            }

            .smart-btn:disabled {
                opacity: 0.7;
                cursor: not-allowed;
            }

        /* Spinner */
        .spinner {
            width: 12px;
            height: 12px;
            border: 2px solid rgba(255,255,255,0.4);
            border-top-color: #fff;
            border-radius: 50%;
            display: none;
            animation: spin 0.7s linear infinite;
        }

        @keyframes spin {
            to {
                transform: rotate(360deg);
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            upnot_binddomains();
            bindalertgrid();
        });
        window.onload = function () {
            document.getElementById('upnot_fpAttach').addEventListener('change', getFileName);
        }
        const getFileName = (event) => {
            const files = event.target.files;
            var file = files[0];
            document.getElementById("upnot_filep").value = files[0].name;

            const fd = new FormData();

            // add all selected files
            fd.append(event.target.name, file, file.name);
            // create the request
            const xhr = new XMLHttpRequest();

            xhr.onload = () => {
                if (xhr.status >= 200 && xhr.status < 300) {
                    // we done!
                }
            };
            var url = window.location.href;
            // path to server would be where you'd normally post the form to
            xhr.open('POST', url, true);
            xhr.send(fd);
            //alert(document.getElementById("filep").value);
        }

    </script>

    <link rel="stylesheet" href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
    <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="upnot_filep" style="display: none;" />
   
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Project Notifications Master</b></h6>
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <div class="sla-grid">

                    <div class="sla-field">
                        <label>Subject</label>
                        <input type="text" id="upnot_subject" class="form-control" placeholder="Enter subject">
                    </div>

                    <div class="sla-field">
                        <label>Effective Date</label>
                        <input type="date" id="upnot_effectivedate" class="form-control">
                    </div>

                    <div class="sla-field">
                        <label>Attachment</label>
                        <input type="file" id="upnot_fpAttach" class="form-control">
                    </div>

                    <div class="sla-field-msg">
                        <label>Alert Message</label>
                        <textarea id="upnot_alertmessage" class="form-control" rows="3" placeholder="Enter alert message"></textarea>
                    </div>

                    <div class="sla-field">
                        <label>Domain</label>
                        <select id="upnot_domain" class="form-control" onchange="upnot_bindsubdomain();"></select>
                    </div>

                    <div class="sla-field">
                        <label>Sub Domain</label>
                        <select id="upnot_subdomain" class="form-control" onchange="upnot_bindprojects();"></select>
                    </div>

                    <div class="sla-field">
                        <label>Project</label>
                        <select id="upnot_Project" class="form-control" style="width: 300px; display: inline!important" onchange="upnot_changeproject();"></select>
                        <button id="btnGetUser" class="smart-btn" onclick="return upnot_binduserlist();"><span class="btn-text">Get Users</span><span class="spinner"></span></button>
                    </div>

                    <div class="sla-field">
                        <label>Available Users</label>
                        <ul id="upnot_userslist" class="listbox-ul" ondragover="upnot_allowDrop(event)" ondrop="upnot_dropLi(event)" style="width: 250px; height: 150px;"></ul>
                    </div>

                    <div class="sla-field">
                        <label>Selected Users</label>
                        <ul id="upnot_selectedusers" class="listbox-ul" ondragover="upnot_allowDrop(event)" ondrop="upnot_dropLi(event)" style="width: 250px; height: 150px;"></ul>
                    </div>

                    <div class="sla-field-btn">
                        <label>&nbsp;&nbsp;</label>
                        <button id="upnot_btnsubmit" class="btn btn-gradient-primary transfer-btn" onclick="return upnot_submitnotifications(event);">Submit Notification</button>
                    </div>
                </div>
                <br />
                <div class="container-fluid mt-3">
                    <div class="card mt-4 shadow-sm">
                        <div class="card-blue card-outline">
                            &nbsp; &nbsp;  <i class="fas fa-list"></i>
                            <b style="font-size: 14px;">&nbsp;&nbsp; Notification History</b>
                        </div>
                        <div class="card-body">
                            <table id="grdAlert" class="table">
                                <thead>
                                    <tr>
                                        <th class="sort border-top" style="text-wrap: nowrap;">Project</th>
                                        <th class="sort border-top" style="text-wrap: nowrap; width: 200px;">Subject</th>
                                        <th class="sort border-top" style="text-wrap: nowrap; width: 1200px;">Message</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">Effective Date</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">Added By</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">Added Date</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>--%>
