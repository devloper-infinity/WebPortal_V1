<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="FunFriday.aspx.cs" Inherits="WebPortal.Admin.FunFriday" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --ff-ink: #172033;
            --ff-muted: #64748b;
            --ff-line: #e5e7eb;
            --ff-surface: #ffffff;
            --ff-pink: #db2777;
            --ff-orange: #f97316;
            --ff-teal: #0f766e;
            --ff-violet: #6d28d9;
            --ff-shadow: 0 16px 38px rgba(23, 32, 51, .12);
        }

        .funfriday-page {
            position: relative;
            isolation: isolate;
            min-height: calc(100vh - 150px);
                       color: var(--ff-ink);
            background:
                linear-gradient(90deg, rgba(249, 115, 22, .08) 1px, transparent 1px),
                linear-gradient(180deg, rgba(219, 39, 119, .07) 1px, transparent 1px),
                linear-gradient(180deg, #fff7ed 0%, #ffffff 48%, #f0fdfa 100%);
            background-size: 34px 34px, 34px 34px, auto;
        }

            .funfriday-page::before {
                content: '';
                position: absolute;
                inset: 0;
                z-index: -1;
                opacity: .46;
                pointer-events: none;
                background-image:
                    linear-gradient(135deg, transparent 0 44%, rgba(219, 39, 119, .18) 44% 50%, transparent 50% 100%),
                    linear-gradient(45deg, transparent 0 46%, rgba(15, 118, 110, .16) 46% 52%, transparent 52% 100%);
                background-size: 76px 76px, 96px 96px;
            }

        .funfriday-shell {
            position: relative;
            z-index: 1;
        }

        .ff-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            gap: 18px;
            margin-bottom: 20px;
            padding: 22px 26px;
            border: 1px solid rgba(255, 255, 255, .48);
            border-radius: 8px;
            color: #fff;
            background: linear-gradient(135deg, rgba(109, 40, 217, .98) 0%, rgba(219, 39, 119, .95) 48%, rgba(249, 115, 22, .96) 100%);
            box-shadow: var(--ff-shadow);
        }

            .ff-hero::before {
                content: '';
                position: absolute;
                inset: 0;
                opacity: .22;
                pointer-events: none;
                background:
                    linear-gradient(135deg, rgba(255, 255, 255, .68) 0 8px, transparent 8px 34px),
                    linear-gradient(45deg, rgba(255, 255, 255, .34) 0 7px, transparent 7px 30px);
                background-size: 46px 46px, 58px 58px;
            }

        .ff-hero-icon,
        .ff-section-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            flex: 0 0 auto;
            border-radius: 8px;
        }

        .ff-hero-icon {
            position: relative;
            z-index: 1;
            width: 56px;
            height: 56px;
            border: 2px solid rgba(255, 255, 255, .78);
            background: rgba(255, 255, 255, .14);
            transform-origin: center bottom;
            animation: ffIconBounce 1.8s cubic-bezier(.34, 1.56, .64, 1) infinite;
        }

            .ff-hero-icon i {
                color: #fff;
                font-size: 30px;
            }

        @keyframes ffIconBounce {
            0%, 100% {
                transform: translateY(0) scale(1) rotate(0deg);
            }

            24% {
                transform: translateY(-9px) scale(1.07) rotate(-5deg);
            }

            44% {
                transform: translateY(0) scale(.98) rotate(4deg);
            }

            64% {
                transform: translateY(-4px) scale(1.03) rotate(-2deg);
            }

            80% {
                transform: translateY(0) scale(1) rotate(0deg);
            }
        }

        .ff-hero-copy {
            position: relative;
            z-index: 1;
        }

        .ff-title {
            margin: 0;
            color: #fff;
            font-size: 26px;
            font-weight: 800;
            letter-spacing: 0;
        }

        .ff-subtitle {
            max-width: 760px;
            margin: 7px 0 0;
            color: rgba(255, 255, 255, .92);
            font-size: 14px;
            line-height: 1.55;
        }

        .ff-card {
            overflow: hidden;
            margin-bottom: 22px;
            border: 1px solid rgba(226, 232, 240, .95);
            border-radius: 8px;
            background: rgba(255, 255, 255, .96);
            box-shadow: var(--ff-shadow);
        }

        .ff-section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            padding: 18px 20px;
            border-bottom: 1px solid var(--ff-line);
            background: linear-gradient(90deg, rgba(255, 247, 237, .95), rgba(240, 253, 250, .78));
        }

        .ff-section-title-wrap {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .ff-section-icon {
            width: 38px;
            height: 38px;
            color: #fff;
            background: linear-gradient(135deg, var(--ff-violet), var(--ff-pink), var(--ff-orange));
            box-shadow: 0 8px 18px rgba(219, 39, 119, .20);
        }

        .ff-section-title {
            margin: 0;
            color: var(--ff-ink);
            font-size: 18px;
            font-weight: 800;
            letter-spacing: 0;
        }

        .ff-section-subtitle {
            margin: 4px 0 0;
            color: var(--ff-muted);
            font-size: 13px;
        }

        .ff-card .card-body {
            padding: 20px;
            background: transparent;
            border-radius: 0;
        }

        .funfriday-page label:not(.form-check-label):not(.custom-file-label) {
            display: block;
            margin-bottom: 7px;
            border: 0 !important;
            color: #334155;
            font-size: 13px;
            font-weight: 700 !important;
        }

        .funfriday-page .form-control,
        .funfriday-page select.form-control,
        .funfriday-page input.form-control,
        .funfriday-page textarea.form-control {
            min-height: 42px;
            border: 1px solid #dbe3ef;
            border-radius: 8px;
            background-color: #fff;
            color: var(--ff-ink);
            box-shadow: 0 1px 2px rgba(15, 23, 42, .04);
            transition: border-color .18s ease, box-shadow .18s ease;
        }

            .funfriday-page .form-control:focus {
                border-color: var(--ff-pink);
                box-shadow: 0 0 0 3px rgba(219, 39, 119, .14);
                outline: 0;
            }

        .funfriday-page textarea.form-control {
            min-height: 96px;
            resize: vertical;
        }

        .ff-upload-preview {
            display: none;
            margin-top: 10px;
            padding: 10px 12px;
            border: 1px dashed #f9a8d4;
            border-radius: 8px;
            color: #831843;
            background: #fdf2f8;
            font-size: 13px;
            font-weight: 700;
            word-break: break-word;
        }

            .ff-upload-preview.is-visible {
                display: block;
            }

        .ff-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            padding-top: 14px;
            border-top: 1px dashed #d9e1ec;
        }

        .ff-submit-btn {
            min-height: 40px;
            border: 0;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 9px 18px;
            color: #fff;
            font-size: 13px;
            font-weight: 800;
            cursor: pointer;
            background: linear-gradient(90deg, var(--ff-violet), var(--ff-pink) 52%, var(--ff-orange));
            box-shadow: 0 12px 22px rgba(219, 39, 119, .20);
            transition: transform .18s ease, box-shadow .18s ease;
        }

            .ff-submit-btn:hover,
            .ff-submit-btn:focus {
                color: #fff;
                transform: translateY(-1px);
                box-shadow: 0 16px 26px rgba(219, 39, 119, .25);
                outline: 0;
            }

        .ff-table-wrap {
            overflow-x: auto;
        }

        #funfriday_table {
            width: 100% !important;
            border-collapse: separate !important;
            border-spacing: 0;
            border: 1px solid var(--ff-line);
            border-radius: 8px;
            overflow: hidden;
            background: #fff;
        }

            #funfriday_table thead th,
            .table.dataTable th {
                background: #fff7ed !important;
                color: #7c2d12;
                border-bottom: 1px solid #fed7aa !important;
                font-size: 12px;
                font-weight: 800;
                text-transform: uppercase;
                letter-spacing: 0;
                white-space: nowrap;
            }

            #funfriday_table tbody td,
            .table.dataTable tr td {
                vertical-align: middle;
                border-color: #eef2f7;
                background: #fff !important;
                color: #334155;
                font-size: 13px;
            }

            #funfriday_table tbody tr:hover td {
                background: #fffbeb !important;
            }

        .dataTables_length,
        .dataTables_info {
            float: left !important;
        }

        div.dt-buttons {
            position: static;
            float: left;
            padding-left: 16px;
        }

        .buttons-excel,
        .buttons-html5 {
            margin: 0 8px;
            border: 0 !important;
            border-radius: 8px !important;
            color: #fff !important;
            background: linear-gradient(135deg, var(--ff-teal), var(--ff-orange)) !important;
            box-shadow: none;
            font-weight: 800;
            padding: 7px 15px !important;
        }

        .ff-image-action,
        .ff-image-action-disabled {
            width: 34px;
            height: 34px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: transform .18s ease, background .18s ease, color .18s ease;
        }

        .ff-image-action {
            border: 1px solid #bae6fd;
            color: #0369a1;
            background: #f0f9ff;
            cursor: pointer;
        }

            .ff-image-action:hover,
            .ff-image-action:focus {
                color: #fff;
                background: #0369a1;
                transform: translateY(-1px);
                outline: 0;
            }

        .ff-image-action-disabled {
            border: 1px solid #e5e7eb;
            color: #94a3b8;
            background: #f8fafc;
        }

        .ff-carousel-image {
            display: block;
            max-width: 100%;
            max-height: 560px;
            margin: 0 auto;
            border-radius: 8px;
            object-fit: contain;
            box-shadow: 0 14px 30px rgba(15, 23, 42, .18);
        }

        .modal-content {
            overflow: hidden;
            border: 0;
            border-radius: 8px;
            box-shadow: 0 24px 70px rgba(15, 23, 42, .30);
        }

        .modal-header {
            border-bottom: 1px solid var(--ff-line);
            background: linear-gradient(90deg, #fff7ed, #f0fdfa);
        }

        .modal-title,
        #displayfunfriday_Header {
            margin: 0;
            color: var(--ff-ink);
            font-size: 18px;
            font-weight: 800 !important;
        }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 99999;
            width: 210px;
            height: 150px;
            margin: auto;
            padding: 22px;
            border: 1px solid var(--ff-line);
            border-radius: 8px;
            background: rgba(255, 255, 255, .94);
            box-shadow: var(--ff-shadow);
            text-align: center;
        }

            .loading img {
                max-width: 64px;
                margin-bottom: 12px;
            }

            .loading .loading-text {
                color: #334155;
                font-size: 12px;
                font-weight: 800;
            }

        @media (max-width: 767px) {
            .funfriday-page {
                padding: 12px 0 28px;
            }

            .ff-hero {
                align-items: flex-start;
                padding: 18px;
            }

            .ff-title {
                font-size: 22px;
            }

            .ff-card .card-body,
            .ff-section-header {
                padding-left: 16px;
                padding-right: 16px;
            }

            .ff-actions {
                justify-content: stretch;
            }

            .ff-submit-btn {
                width: 100%;
            }
        }
    </style>

    <script>
        var funFridayFilesList = '';
        var funFridayUploadData = new FormData();

        function uploadFunFridayFiles(event) {
            var files = event.target.files;
            funFridayFilesList = '';
            funFridayUploadData = new FormData();

            for (var i = 0; i < files.length; i++) {
                if (funFridayFilesList !== '') {
                    funFridayFilesList += ', ';
                }

                funFridayFilesList += files[i].name;
                funFridayUploadData.append(event.target.name, files[i], files[i].name);
            }

            document.getElementById('funfriday_file').value = funFridayFilesList;

            if (files.length > 0) {
                var xhr = new XMLHttpRequest();
                xhr.open('POST', window.location.href, true);
                xhr.send(funFridayUploadData);
            }

            $('#dropzone').toggleClass('dz-max-files-reached', files.length > 0);
            $('#conentdiv').toggleClass('is-visible', files.length > 0);
            $('#filesdiv').text(funFridayFilesList);
        }

        window.getFileName = uploadFunFridayFiles;

        $(document).ready(function () {
            $('#funfriday_attachment').on('change', uploadFunFridayFiles);
            funfriday_bindlocation();
            funfriday_binddata();

            var dtToday = new Date();
            var month = dtToday.getMonth() + 1;
            var day = dtToday.getDate();
            var year = dtToday.getFullYear();

            if (month < 10) {
                month = '0' + month.toString();
            }
            if (day < 10) {
                day = '0' + day.toString();
            }

            $('#funfriday_date').attr('max', year + '-' + month + '-' + day);
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="funfriday_file" type="hidden" />

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" alt="Loading" />
        <div class="loading-text">One moment, please...</div>
    </div>

    <div class="funfriday-page">
        <div class="funfriday-shell">
            <div class="ff-hero">
                <span class="ff-hero-icon" aria-hidden="true">
                  <%--  <i class="fas fa-glass-cheers"></i>--%>
                 <i class="fas fa-gamepad"></i>
                </span>
                <div class="ff-hero-copy">
                    <h1 class="ff-title">Fun Friday</h1>
                    <p class="ff-subtitle">Plan the activity, save the location, and keep the celebration snaps together.</p>
                </div>
            </div>

            <div class="col-lg-12 px-0">
                <div class="ff-card">
                    <div class="ff-section-header">
                        <div class="ff-section-title-wrap">
                            <span class="ff-section-icon" aria-hidden="true"><i class="fas fa-calendar-check"></i></span>
                            <div>
                                <h3 class="ff-section-title">Create Activity</h3>
                                <p class="ff-section-subtitle">New Fun Friday entry</p>
                            </div>
                        </div>
                    </div>

                    <div class="card-body">
                        <div class="row mb-3">
                            <div class="col-md-3">
                                <label for="funfriday_date">Date :</label>
                                <input type="date" id="funfriday_date" onkeydown="return false" name="funfriday_date" class="form-control" required />
                            </div>
                            <div class="col-md-3">
                                <label for="funfriday_location">Location :</label>
                                <select id="funfriday_location" name="funfriday_location" class="form-control" required>
                                    <option value="">Select</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label for="funfriday_activity">Activity :</label>
                                <textarea id="funfriday_activity" name="funfriday_activity" class="form-control" required></textarea>
                            </div>
                            <div class="col-md-3">
                                <label for="funfriday_details">Details :</label>
                                <textarea id="funfriday_details" name="funfriday_details" class="form-control" required></textarea>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="funfriday_attachment">Snaps :</label>
                                <input type="file" id="funfriday_attachment" name="funfriday_attachment" class="form-control" multiple />
                                <div class="dropzone dropzone-multiple p-0 dz-clickable" id="dropzone">
                                    <div class="ff-upload-preview" id="conentdiv">
                                        <i class="fas fa-paperclip mr-1" aria-hidden="true"></i>
                                        <span id="filesdiv"></span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="ff-actions">
                            <button id="funfriday_btnsubmit" type="button" class="ff-submit-btn" onclick="return funfriday_SubmitData();">
                                <i class="fas fa-paper-plane" aria-hidden="true"></i>
                                <span>Submit</span>
                            </button>
                        </div>
                    </div>
                </div>

                <div class="ff-card">
                    <div class="ff-section-header">
                        <div class="ff-section-title-wrap">
                            <span class="ff-section-icon" aria-hidden="true"><i class="fas fa-images"></i></span>
                            <div>
                                <h3 class="ff-section-title">Fun Friday List</h3>
                                <p class="ff-section-subtitle">Saved activities and snaps</p>
                            </div>
                        </div>
                    </div>

                    <div class="card-body">
                        <div class="ff-table-wrap">
                            <table class="table table-hover align-middle" id="funfriday_table">
                                <thead>
                                    <tr>
                                        <th>Action</th>
                                        <th>Date</th>
                                        <th>Activity</th>
                                        <th>Location</th>
                                        <th>Details</th>
                                        <th>Images</th>
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

    <div class="modal fade" id="funfriday_dverror" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-sm modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="funfriday_errmsg"></h6>
                </div>
                <div class="modal-footer justify-content-center">
                    <button class="ff-submit-btn" type="button" id="btnMessage" onclick="return funfriday_Message();">Okay</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="funfriday_displayimages" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 id="displayfunfriday_Header" name="displayfunfriday_Header">Fun Friday Snaps</h6>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="dvslidermain"></div>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
