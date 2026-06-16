<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ImportFeedback.aspx.cs" Inherits="WebPortal.Admin.ImportFeedback" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body {
            background: #f3f6f8;
        }

        .inf-page {
            color: #16202a;
            padding-bottom: 28px;
        }

        .inf-hero {
            align-items: center;
            background: linear-gradient(135deg, #0f766e 0%, #1d4ed8 100%);
            border-radius: 8px;
            box-shadow: 0 14px 28px rgba(28, 58, 85, 0.16);
            color: #fff;
            display: flex;
            gap: 20px;
            justify-content: space-between;
            margin-bottom: 18px;
            padding: 22px 24px;
        }

        .inf-kicker {
            color: rgba(255,255,255,0.82);
            font-size: 12px;
            font-weight: 700;
            margin-bottom: 6px;
            text-transform: uppercase;
        }

        .inf-title {
            font-size: 24px;
            font-weight: 700;
            line-height: 1.2;
            margin: 0;
        }

        .inf-subtitle {
            color: rgba(255,255,255,0.88);
            font-size: 13px;
            margin: 8px 0 0;
            max-width: 760px;
        }

        .inf-hero-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: flex-end;
        }

        .inf-btn {
            align-items: center;
            border-radius: 6px;
            display: inline-flex;
            font-size: 13px;
            font-weight: 700;
            gap: 8px;
            justify-content: center;
            min-height: 38px;
            padding: 8px 14px;
        }

        .inf-btn-primary {
            background: #0f766e;
            border: 1px solid #0f766e;
            color: #fff;
        }

        .inf-btn-primary:hover,
        .inf-btn-primary:focus {
            background: #0b5f59;
            border-color: #0b5f59;
            color: #fff;
        }

        .inf-btn-dark {
            background: #172737;
            border: 1px solid #172737;
            color: #fff;
        }

        .inf-btn-dark:hover,
        .inf-btn-dark:focus {
            background: #0f1b26;
            border-color: #0f1b26;
            color: #fff;
        }

        .inf-btn-light {
            background: rgba(255,255,255,0.96);
            border: 1px solid rgba(255,255,255,0.96);
            color: #17324d;
        }

        .inf-panel {
            background: #fff;
            border: 1px solid #dce5ec;
            border-radius: 8px;
            box-shadow: 0 10px 24px rgba(31, 51, 71, 0.06);
            margin-bottom: 18px;
            overflow: hidden;
        }

        .inf-panel-header {
            align-items: center;
            border-bottom: 1px solid #e7edf2;
            display: flex;
            gap: 14px;
            justify-content: space-between;
            padding: 16px 18px;
        }

        .inf-panel-title {
            align-items: center;
            color: #172737;
            display: flex;
            font-size: 16px;
            font-weight: 700;
            gap: 9px;
            margin: 0;
        }

        .inf-panel-subtitle {
            color: #6d7f90;
            font-size: 12px;
            margin: 4px 0 0;
        }

        .inf-panel-body {
            padding: 18px;
        }

        .inf-section-title {
            align-items: center;
            color: #2d3f50;
            display: flex;
            font-size: 13px;
            font-weight: 800;
            gap: 8px;
            margin: 0 0 12px;
        }

        .inf-form-grid {
            display: grid;
            gap: 14px 16px;
            grid-template-columns: repeat(3, minmax(0, 1fr));
        }

        .inf-field {
            min-width: 0;
        }

        .inf-field label {
            color: #46596b;
            display: block;
            font-size: 12px;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .inf-field .form-control {
            border-color: #cfdbe5;
            border-radius: 6px;
            box-shadow: none;
            color: #172737;
            font-size: 13px;
            min-height: 38px;
            width: 100%;
        }

        .inf-field .form-control:focus {
            border-color: #0f766e;
            box-shadow: 0 0 0 3px rgba(15, 118, 110, 0.14);
        }

        .inf-action-row {
            align-items: center;
            border-top: 1px solid #e7edf2;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 18px;
            padding-top: 16px;
        }

        .inf-table-wrap {
            overflow-x: auto;
            padding: 0 18px 18px;
        }

        #importfeedback_table {
            border-collapse: separate !important;
            border-spacing: 0;
            margin: 0 !important;
            width: 100% !important;
        }

        #importfeedback_table thead th,
        .table.dataTable th {
            background: #edf3f6 !important;
            border-color: #d7e2ea !important;
            color: #263747;
            font-size: 12px;
            text-align: center;
            vertical-align: middle;
            white-space: nowrap;
        }

        #importfeedback_table tbody td,
        .table.dataTable tr td {
            background: #fff !important;
            border-color: #edf1f4 !important;
            color: #2d3f50;
            font-size: 12px;
            vertical-align: middle;
        }

        .dataTables_length,
        .dataTables_info {
            color: #5d6f80;
            float: left !important;
            font-size: 12px;
        }

        div.dt-buttons {
            float: left;
            padding-left: 16px;
            position: static;
        }

        .buttons-excel,
        .buttons-html5 {
            background: #0f766e !important;
            border: 1px solid #0f766e !important;
            border-radius: 6px !important;
            box-shadow: none !important;
            color: #fff !important;
            font-size: 12px !important;
            font-weight: 700 !important;
            margin: 0 8px !important;
            padding: 7px 12px !important;
        }

        .loading {
            background: rgba(255,255,255,0.92);
            border: 1px solid #dce5ec;
            border-radius: 14px;
            box-shadow: 0 12px 30px rgba(31, 51, 71, 0.18);
            display: none;
            height: 160px;
            left: 50%;
            margin-left: -80px;
            margin-top: -80px;
            padding: 18px;
            position: fixed;
            text-align: center;
            top: 50%;
            width: 160px;
            z-index: 99999;
        }

        .loading img {
            max-width: 72px;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: 700 !important;
            border: none !important;
        }

        .modal-content {
            border: 0;
            border-radius: 8px;
            box-shadow: 0 14px 30px rgba(31, 51, 71, 0.18);
        }

        .modal-header {
            border-bottom: 1px solid #e7edf2;
        }

        .modal-footer {
            border-top: 1px solid #e7edf2;
            justify-content: center;
        }

        @media (max-width: 991px) {
            .inf-hero {
                align-items: flex-start;
                flex-direction: column;
            }

            .inf-hero-actions {
                justify-content: flex-start;
            }

            .inf-form-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 575px) {
            .inf-form-grid {
                grid-template-columns: 1fr;
            }

            .inf-action-row {
                justify-content: stretch;
            }

            .inf-action-row .inf-btn {
                width: 100%;
            }
        }
    </style>

<script>
    function blankForNull(s) {
        return s == "null" || s == null ? "" : s;
    }
    window.onload = function () {
        importfeecback_bindsubdomain();
        document.getElementById('importfeedback_attachment').addEventListener('change', getFileName);
    }
    const getFileName = (event) => {
        const files = event.target.files;
        var file = files[0];
        document.getElementById("importfeedback_filep").value = files[0].name;

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

    function importfeecback_bindsubdomain() {
        $.ajax({
            url: "ImportFeedback.aspx/GetUserInfo",
            type: "POST",
            dataType: "json",
            contentType: "application/json; charset=utf-8",

            success: function (data) {
                dataArray = JSON.parse(data.d);
                $.each(dataArray, function (data, value) {
                    if (blankForNull(value.SubDomain) == "Credit" || blankForNull(value.SubDomain) == "Servicing") {
                        $("#importfeedback_domain").val(blankForNull(value.SubDomain));
                        document.getElementById("tddomainhead").style.display = "none";
                        document.getElementById("tddomainrow").style.display = "none";
                    }
                    else {
                        $("#importfeedback_domain").val("");
                        document.getElementById("tddomainhead").style.display = "";
                        document.getElementById("tddomainrow").style.display = "";
                    }
                })
            }
        });
    }

    function importfeedback_submit() {
        var ddldomain = document.getElementById("importfeedback_domain");
        var subdomain = ddldomain.options[ddldomain.selectedIndex].value;
        if (subdomain == "") {
            alert("Please select subdomain.");
            return false;
        }
        $('#waitingpanel').modal('show');
        document.getElementById("spntext").innerHTML = "Please wait, Excel validation is in process.";
        PageMethods.ImportFile(subdomain, importfeedback_OnSuccess, importfeedback_OnError);
        return false;
    }

    function importfeedback_OnSuccess(result) {
        $('#waitingpanel').modal('hide');
        if (result != "") {
            const contents = result.split("~");
            let message = contents[0];
            let errorno = contents[1];
            if (errorno == "-1")
                document.getElementById("importfeedback_errmsg").innerHTML = "<span style='color:red;'>" + message + "</span> is missing in input file.";
            else
                document.getElementById("importfeedback_errmsg").innerHTML = message;
            //$("#importfeedback_dverror").modal('show');
            if (message == "Excel validated Successfully.") {
                $("#importfeedback_dverror").modal('hide');
                importfeedback_bindtable();
            }
        }
        //else {
        //    importfeedback_bindtable();
        //}
        return false;
    }
    function importfeedback_OnError(error) {
        alert(error.responseText);
    }

    function getvalidatedfeedbacksClose() {
        $("#importfeedback_dverror").modal('hide');
    }

    function importfeedback_bindtable() {
        $('#load1').show();
        var ddldomain = document.getElementById("importfeedback_domain");
        var subdomain = ddldomain.options[ddldomain.selectedIndex].value;
        if (subdomain == "") {
            alert("Please select subdomain.");
            return false;
        }
        var columns = [];

        $.ajax({
            url: "ImportFeedback.aspx/getValidatedFeedbacks",
            type: "POST",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            data: "{Type:'" + subdomain + "'}",
            success: function (data) {
                if ($.fn.dataTable.isDataTable('#importfeedback_table')) {
                    $('#importfeedback_table').DataTable().destroy();
                }
                dataArray = JSON.parse(data.d);
                if (dataArray == null || dataArray == "") {
                    document.getElementById("importfeedback_errmsg").innerHTML = "<span style='color:green;'>Excel has been validated successfully. Please click on Import button to update feedbacks.</span>";
                    $("#importfeedback_dverror").modal('show');
                    document.getElementById("importfeedback_btnsubmit").disabled = true;
                    document.getElementById("importfeedback_btnImport").style.display = '';
                    $('#load1').hide();
                }
                else {
                    document.getElementById("importfeedback_errmsg").innerHTML = "<span style='color:red;'>Please review Remark column in table and upload revised excel.</span>";
                    $("#importfeedback_dverror").modal('show');
                }
                columnNames = Object.keys(dataArray[0]); //.Table[0]] refers to the propery name of the returned json
                for (var i in columnNames) {
                    columns.push({
                        data: columnNames[i],
                        title: columnNames[i]
                    });
                }
                $('#importfeedback_table').DataTable({
                    dom: 'lBftip',
                    scrollX: true,
                    destroy: true,
                    paging: true,
                    ordering: false,
                    "autoWidth": true,
                    select: true,
                    processing: true,
                    "aaSorting": [],
                    'select': {
                        'style': 'single'
                    },
                    "data": dataArray,
                    columns: columns,
                    buttons: [
                        {
                            extend: 'excelHtml5', title: 'Feedback Details', autoFilter: true,
                        },
                    ],
                    fnCreatedRow: function (nRow, aData, iDataIndex) {
                        $(nRow).children("td").css("text-wrap", "nowrap");
                    },
                    initComplete: function () {
                        $('#load1').hide();
                    },
                });
            }
        });

        return false;
    }

    function importfeedback_import() {
        var ddldomain = document.getElementById("importfeedback_domain");
        var subdomain = ddldomain.options[ddldomain.selectedIndex].value;
        if (subdomain == "") {
            alert("Please select subdomain.");
            return false;
        }
        $('#waitingpanel').modal('show');
        document.getElementById("spntext").innerHTML = "Please wait, database insertion is in process.";
        //PageMethods.ImportExceldata(importexceldata_OnSuccess, importexceldata_OnError);
        PageMethods.InserUpdateFeedbacks(subdomain, importexceldata_OnSuccess, importexceldata_OnError);
        return false;
    }
    function importexceldata_OnSuccess(result) {
        $('#waitingpanel').modal('hide');
        document.getElementById("importfeedback_errmsg").innerHTML = "<span style='color:green;'>Feedbacks imported successfully!</span>";
        $("#importfeedback_dverror").modal('show');
        return false;
    }
    function importexceldata_OnError(error) {
        alert(error.responseText);
    }


    $(document).ready(function () {

    });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="importfeedback_filep" style="display: none;" />

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold; margin-top: 10px;">One moment, please . . . .</div>
    </div>

    <div class="container-fluid inf-page">
        <div class="inf-hero">
            <div>
                <div class="inf-kicker">Infinity Feedback</div>
                <h1 class="inf-title"><i class="fas fa-file-import"></i>&nbsp; Import Feedbacks</h1>
                <p class="inf-subtitle">Upload, validate and import feedback records from the standard Excel format.</p>
            </div>
            <div class="inf-hero-actions">
                <a href="FeedbackImportFormat.xlsx" class="inf-btn inf-btn-light">
                    <i class="fas fa-download"></i> Download Import Format
                </a>
                <a href="InfinityFeedback.aspx" class="inf-btn inf-btn-light">
                    <i class="fas fa-arrow-left"></i> Go Back
                </a>
            </div>
        </div>

        <div class="inf-panel">
            <div class="inf-panel-header">
                <div>
                    <h2 class="inf-panel-title"><i class="fas fa-upload"></i> Upload Feedback Excel</h2>
                    <p class="inf-panel-subtitle">Select the Excel file, choose the domain if required, then validate before importing.</p>
                </div>
            </div>
            <div class="inf-panel-body">
                <div class="inf-section-title"><i class="fas fa-sliders-h"></i> Import Criteria</div>
                <div class="inf-form-grid">
                    <div class="inf-field">
                        <label for="importfeedback_attachment">Attachment</label>
                        <input type="file" id="importfeedback_attachment" name="importfeedback_attachment" class="form-control" />
                    </div>

                    <div class="inf-field" id="tddomainhead">
                        <label for="importfeedback_domain">Domain</label>
                        <select id="importfeedback_domain" name="importfeedback_domain" class="form-control">
                            <option value="">Select</option>
                            <option value="Credit">Credit</option>
                            <option value="Servicing">Servicing</option>
                        </select>
                    </div>

                    <div class="inf-field" id="tddomainrow" style="display:none;"></div>
                </div>

                <div class="inf-action-row">
                    <button id="importfeedback_btnsubmit" name="importfeedback_btnsubmit" class="btn inf-btn inf-btn-primary" onclick="return importfeedback_submit();">
                        <i class="fas fa-check-circle"></i> Validate Excel
                    </button>
                    <button id="importfeedback_btnImport" name="importfeedback_btnImport" class="btn inf-btn inf-btn-dark" onclick="return importfeedback_import();" style="display: none;">
                        <i class="fas fa-database"></i> Import
                    </button>
                </div>
            </div>
        </div>

        <div class="inf-panel">
            <div class="inf-panel-header">
                <div>
                    <h2 class="inf-panel-title"><i class="fas fa-table"></i> Validation Results</h2>
                    <p class="inf-panel-subtitle">Review validation remarks before importing the feedback records.</p>
                </div>
            </div>
            <div class="inf-table-wrap">
                <table class="table table-bordered" id="importfeedback_table" style="width: 100%;"></table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">System is updating details. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>

    <div class="modal fade" id="importfeedback_dverror">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="importfeedback_errmsg"></h6>
                </div>
                <div class="modal-footer align-content-center">
                    <button class="btn inf-btn inf-btn-primary" type="button" id="importfeedback_btnMessage" onclick="return getvalidatedfeedbacksClose();">
                        <i class="fas fa-check"></i> Okay
                    </button>
                </div>
            </div>
        </div>
    </div>
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
            box-shadow: none;
            background: linear-gradient(to right, #ffbf96, #fe7096);
            border: 0;
            font-weight: bold;
            margin: 0px 10px;
        }

        .table.dataTable th {
            background: linear-gradient(to bottom, #cbd0dd, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
        }
    </style>

    <script>
        function blankForNull(s) {
            return s == "null" || s == null ? "" : s;
        }
        window.onload = function () {
            importfeecback_bindsubdomain();
            document.getElementById('importfeedback_attachment').addEventListener('change', getFileName);
        }
        const getFileName = (event) => {
            const files = event.target.files;
            var file = files[0];
            document.getElementById("importfeedback_filep").value = files[0].name;

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

        function importfeecback_bindsubdomain() {
            $.ajax({
                url: "ImportFeedback.aspx/GetUserInfo",
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",

                success: function (data) {
                    dataArray = JSON.parse(data.d);
                    $.each(dataArray, function (data, value) {
                        if (blankForNull(value.SubDomain) == "Credit" || blankForNull(value.SubDomain) == "Servicing") {
                            $("#importfeedback_domain").val(blankForNull(value.SubDomain));
                            document.getElementById("tddomainhead").style.display = "none";
                            document.getElementById("tddomainrow").style.display = "none";
                        }
                        else {
                            $("#importfeedback_domain").val("");
                            document.getElementById("tddomainhead").style.display = "";
                            document.getElementById("tddomainrow").style.display = "";
                        }
                    })
                }
            });
        }

        function importfeedback_submit() {
            var ddldomain = document.getElementById("importfeedback_domain");
            var subdomain = ddldomain.options[ddldomain.selectedIndex].value;
            if (subdomain == "") {
                alert("Please select subdomain.");
                return false;
            }
            $('#waitingpanel').modal('show');
            document.getElementById("spntext").innerHTML = "Please wait, Excel validation is in process.";
            PageMethods.ImportFile(subdomain, importfeedback_OnSuccess, importfeedback_OnError);
            return false;
        }

        function importfeedback_OnSuccess(result) {
            $('#waitingpanel').modal('hide');
            if (result != "") {
                const contents = result.split("~");
                let message = contents[0];
                let errorno = contents[1];
                if (errorno == "-1")
                    document.getElementById("importfeedback_errmsg").innerHTML = "<span style='color:red;'>" + message + "</span> is missing in input file.";
                else
                    document.getElementById("importfeedback_errmsg").innerHTML = message;
                //$("#importfeedback_dverror").modal('show');
                if (message == "Excel validated Successfully.") {
                    $("#importfeedback_dverror").modal('hide');
                    importfeedback_bindtable();
                }
            }
            //else {
            //    importfeedback_bindtable();
            //}
            return false;
        }
        function importfeedback_OnError(error) {
            alert(error.responseText);
        }

        function getvalidatedfeedbacksClose() {
            $("#importfeedback_dverror").modal('hide');
        }

        function importfeedback_bindtable() {
            $('#load1').show();
            var ddldomain = document.getElementById("importfeedback_domain");
            var subdomain = ddldomain.options[ddldomain.selectedIndex].value;
            if (subdomain == "") {
                alert("Please select subdomain.");
                return false;
            }
            var columns = [];

            $.ajax({
                url: "ImportFeedback.aspx/getValidatedFeedbacks",
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data: "{Type:'" + subdomain + "'}",
                success: function (data) {
                    if ($.fn.dataTable.isDataTable('#importfeedback_table')) {
                        $('#importfeedback_table').DataTable().destroy();
                    }
                    dataArray = JSON.parse(data.d);
                    if (dataArray == null || dataArray == "") {
                        document.getElementById("importfeedback_errmsg").innerHTML = "<span style='color:green;'>Excel has been validated successfully. Please click on Import button to update feedbacks.</span>";
                        $("#importfeedback_dverror").modal('show');
                        document.getElementById("importfeedback_btnsubmit").disabled = true;
                        document.getElementById("importfeedback_btnImport").style.display = '';
                        $('#load1').hide();
                    }
                    else {
                        document.getElementById("importfeedback_errmsg").innerHTML = "<span style='color:red;'>Please review Remark column in table and upload revised excel.</span>";
                        $("#importfeedback_dverror").modal('show');
                    }
                    columnNames = Object.keys(dataArray[0]); //.Table[0]] refers to the propery name of the returned json
                    for (var i in columnNames) {
                        columns.push({
                            data: columnNames[i],
                            title: columnNames[i]
                        });
                    }
                    $('#importfeedback_table').DataTable({
                        dom: 'lBftip',
                        scrollX: true,
                        destroy: true,
                        paging: true,
                        ordering: false,
                        "autoWidth": true,
                        select: true,
                        processing: true,
                        "aaSorting": [],
                        'select': {
                            'style': 'single'
                        },
                        "data": dataArray,
                        columns: columns,
                        buttons: [
                            {
                                extend: 'excelHtml5', title: 'Feedback Details', autoFilter: true,
                            },
                        ],
                        fnCreatedRow: function (nRow, aData, iDataIndex) {
                            $(nRow).children("td").css("text-wrap", "nowrap");
                        },
                        initComplete: function () {
                            $('#load1').hide();
                        },
                    });
                }
            });

            return false;
        }

        function importfeedback_import() {
            var ddldomain = document.getElementById("importfeedback_domain");
            var subdomain = ddldomain.options[ddldomain.selectedIndex].value;
            if (subdomain == "") {
                alert("Please select subdomain.");
                return false;
            }
            $('#waitingpanel').modal('show');
            document.getElementById("spntext").innerHTML = "Please wait, database insertion is in process.";
            //PageMethods.ImportExceldata(importexceldata_OnSuccess, importexceldata_OnError);
            PageMethods.InserUpdateFeedbacks(subdomain, importexceldata_OnSuccess, importexceldata_OnError);
            return false;
        }
        function importexceldata_OnSuccess(result) {
            $('#waitingpanel').modal('hide');
            document.getElementById("importfeedback_errmsg").innerHTML = "<span style='color:green;'>Feedbacks imported successfully!</span>";
            $("#importfeedback_dverror").modal('show');
            return false;
        }
        function importexceldata_OnError(error) {
            alert(error.responseText);
        }


        $(document).ready(function () {

        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="importfeedback_filep" style="display: none;" />
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Import Feedbacks</b></h6>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right" style="font-size: 12px; font-weight: bold;">
                        <li class="breadcrumb-item"><a href="FeedbackImportFormat.xlsx" style="color: saddlebrown">Download Import Format</a></li>
                        <li class="breadcrumb-item"><a href="InfinityFeedback.aspx" style="color: saddlebrown"><< Go Back </a></li>
                    </ol>
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <table class="table">
                    <tr>
                        <td style="width: 100px;"><b>Attachment:</b></td>
                        <td style="width: 300px;">
                            <input type="file" id="importfeedback_attachment" name="importfeedback_attachment" class="form-control" style="width: 250px;" />
                        </td>
                        <td id="tddomainhead"><b>Domain:</b></td>
                        <td id="tddomainrow">
                            <select id="importfeedback_domain" name="importfeedback_domain" class="form-control" style="width: 250px;">
                                <option value="">Select</option>
                                <option value="Credit">Credit</option>
                                <option value="Servicing">Servicing</option>
                            </select>
                        </td>
                        <td>
                            <button id="importfeedback_btnsubmit" name="importfeedback_btnsubmit" class="btn btn-primary" onclick="return importfeedback_submit();">Validate Excel</button>
                            <button id="importfeedback_btnImport" name="importfeedback_btnImport" class="btn btn-dark" onclick="return importfeedback_import();" style="display: none;">Import</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <table class="table table-bordered" id="importfeedback_table" style="width: 100%;"></table>
            </div>
        </div>
    </div>
    <div class="modal fade" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">System is updating details. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>
    <div class="modal fade" id="importfeedback_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="importfeedback_errmsg"></h6>
                </div>
                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="importfeedback_btnMessage" onclick="return getvalidatedfeedbacksClose();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>--%>
