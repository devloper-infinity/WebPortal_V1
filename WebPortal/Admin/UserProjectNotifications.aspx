<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="UserProjectNotifications.aspx.cs" Inherits="WebPortal.Admin.UserProjectNotifications" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
   

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
</asp:Content>
