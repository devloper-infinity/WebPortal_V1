<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="OtherTask.aspx.cs" Inherits="WebPortal.Admin.OtherTask" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style id="st1">
        .main-container {
            width: 100%;
            padding: 15px 25px;
        }

        /* Custom Grid */
        .my-row {
            display: flex;
            flex-wrap: wrap;
            margin-bottom: 15px;
            width: 100%;
        }

        .my-col-4 {
            width: 33.33%;
            padding-right: 15px;
        }

        .my-col-2 {
            width: 10%;
            padding-left: 90px;
        }

        .my-col-12 {
            width: 100%;
        }

        .my-input:focus, .my-select:focus {
            border-color: #b5d3ff;
            box-shadow: 0 0 4px rgba(181, 211, 255, 0.6);
            outline: none;
        }
        /* Inputs */
        .my-input, .my-select {
            width: 100%;
            height: 34px;
            border: 1px solid #dcdcdc;
            padding: 6px;
            border-radius: 5px;
            font-size: 12px;
            background-color: #fff;
            transition: all 0.2s ease;
        }

        textarea.my-input {
            height: 70px;
            resize: none;
        }

        label {
            font-size: 12px;
            margin-bottom: 4px;
            display: block;
        }

        .my-btn {
            padding: 6px 18px;
            border-radius: 4px;
            border: none;
            color: #fff;
            font-size: 14px;
            margin-right: 8px;
        }

        .primary {
            background: #2f7ed8;
        }

        .success {
            background: #28a745;
        }

        .warning {
            background: #f0ad4e;
        }

        .my-btn:hover {
            opacity: 0.9;
        }

        .req {
            color: red;
            font-weight: bold;
            margin-left: 3px;
        }


        .top {
            display: flex;
            align-items: center;
        }

        .dataTables_length {
            margin-right: 10px;
        }

        .dt-buttons {
            margin-right: auto;
        }

        .dataTables_filter {
            margin-left: auto;
        }

        .card {
            transition: 0.3s ease;
        }

            .card:hover {
                transform: translateY(-3px);
            }

        .btn {
            border-radius: 10px;
            font-weight: 400;
        }

        .form-select {
            border-radius: 10px;
        }

        h5, h6 {
            letter-spacing: 0.5px;
        }

        .btn-gradient-primary {
            background: linear-gradient(135deg, #2563eb, #06b6d4);
            color: #fff;
            border-radius: 12px;
            height: 40px;
            font-weight: 400;
            transition: 0.3s;
        }

            .btn-gradient-primary:hover {
                transform: translateY(-2px);
                background: linear-gradient(135deg, #2563eb, #06b6d4);
                color: #fff;
            }

        .btn-gradient-success {
            background: linear-gradient(135deg, #1cc88a, #13855c);
            color: #fff;
            border-radius: 12px;
            height: 40px;
            width: 60%;
            font-weight: 400;
            transition: 0.3s;
        }

            .btn-gradient-success:hover {
                transform: translateY(-2px);
                color: #fff;
            }

        .icon-btn {
            height: 40px;
            width: 50px;
            background: linear-gradient(135deg, #85e0e0, #33cccc);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #99e6e6;
            border: 1px solid #29a3a3;
            transition: 0.3s;
            margin-left: 15px;
        }

            .icon-btn:hover {
                background: #adebeb;
                transform: translateY(-2px);
            }

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
    </style>

    <script>

        $(document).ready(function () {

            var userId = '<%= HttpContext.Current.User.Identity.Name.ToString() %>';

            otherTask_Project(userId);
        });

        window.onload = function () {
            document.getElementById('otherTask_fileUploads').addEventListener('change', getFileName);
        }

        const getFileName = (event) => {
            const files = event.target.files;
            var file = files[0];
            document.getElementById("file_otherTask").value = files[0].name;

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
        }


    </script>


    <script>
        // Enable tooltip
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
        tooltipTriggerList.map(function (el) {
            return new bootstrap.Tooltip(el)
        })
    </script>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="file_otherTask" style="display: none;" />

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Other Task</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <div class="main-container">

                    <!-- Row 1 -->
                    <div class="my-row">
                        <div class="my-col-4">
                            <label>Project # <b><span class="req">*</span></b></label>
                            <select class="my-select" id="otherTask_project" onchange="otherTask_bindProcess(this)"></select>
                        </div>

                        <div class="my-col-4">
                            <label>Process<b><span class="req">*</span></b></label>
                            <select class="my-select" id="otherTask_process"></select>
                        </div>

                        <div class="my-col-4">
                            <label>Upload File<b><span class="req">*</span></b></label>
                            <input type="file" id="otherTask_fileUploads" class="form-control file-input" accept=".xlsx" />
                        </div>
                    </div>

                    <!-- Row 2 -->
                    <div class="my-row">
                        <div class="my-col-4">
                            <button type="submit" class="btn btn-gradient-primary w-100" onclick="return otherTask_uploadData();"><i class="bi bi-cloud-upload"></i>&nbsp; Upload File</button>
                        </div>

                        <div class="my-col-4">
                            <button type="button" class="btn btn-outline-danger w-100" style="height: 50px;" onclick="return otherTask_clearData();"><i class="bi bi-x-circle"></i>&nbsp; Clear Uploaded Data</button>
                        </div>

                        <div class="my-col-4">
                            <div class="d-flex align-items-center gap-4" style="height: 50px;">
                                <button type="submit" id="otherTask_verify" class="btn btn-gradient-success flex-grow-1" onclick="return otherTask_VerifyData();"><i class="bi bi-check-circle"></i>&nbsp; Verify & Submit</button>
                                <a href="OtherTaskImportFormat.xlsx" class="icon-btn" data-bs-toggle="tooltip" title="Download Standard Format Excel"><i class="bi bi-download" style="font-size: 150%;"></i></a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-body">
                <div style="align-content: center;">
                    <label id="otherTask_alert" style="font-weight: bold; font-size: 14px; color: red;"></label>
                </div>
                <div>
                    <table class="table" id="table_otherTask" style="width: 100%;">
                        <thead></thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="othertask_waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">System is updating details. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>

</asp:Content>
