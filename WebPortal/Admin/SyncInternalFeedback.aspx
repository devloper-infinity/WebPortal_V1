<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="SyncInternalFeedback.aspx.cs" Inherits="WebPortal.Admin.SyncInternalFeedback" %>




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

        #syncInt_table {
            border-collapse: separate !important;
            border-spacing: 0;
            margin: 0 !important;
            width: 100% !important;
        }

        #syncInt_table thead th,
        .table.dataTable th {
            background: #edf3f6 !important;
            border-color: #d7e2ea !important;
            color: #263747;
            font-size: 12px;
            text-align: center;
            vertical-align: middle;
            white-space: nowrap;
        }

        #syncInt_table tbody td,
        .table.dataTable tr td {
            background: #fff !important;
            border-color: #e2e9ef !important;
            color: #263747;
            font-size: 12px;
            vertical-align: middle;
        }

        #syncInt_table tbody tr:hover td {
            background: #f7fbfa !important;
        }

        .dataTables_wrapper {
            color: #263747;
            font-size: 12px;
        }

        .dataTables_length,
        .dataTables_info {
            float: left !important;
        }

        div.dt-buttons {
            float: left;
            padding-left: 0;
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
            margin: 0 10px 10px 0 !important;
            padding: 7px 12px !important;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            border: none !important;
            font-weight: 700 !important;
        }

        .loading {
            align-items: center;
            background: rgba(255,255,255,0.92);
            border: 1px solid #dce5ec;
            border-radius: 8px;
            box-shadow: 0 18px 40px rgba(20, 33, 45, 0.18);
            color: #263747;
            display: none;
            font-size: 12px;
            font-weight: 700;
            left: 50%;
            min-width: 260px;
            padding: 18px;
            position: fixed;
            text-align: center;
            top: 42%;
            transform: translate(-50%, -50%);
            z-index: 99999;
        }

        .loading img {
            display: block;
            margin: 0 auto 10px;
            max-width: 44px;
        }

        .inf-modal-message {
            color: #172737;
            font-size: 14px;
            font-weight: 700;
            margin: 0;
        }

        @media (max-width: 1199px) {
            .inf-form-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 767px) {
            .inf-hero {
                align-items: flex-start;
                flex-direction: column;
            }

            .inf-hero-actions,
            .inf-action-row {
                align-items: stretch;
                flex-direction: column;
                width: 100%;
            }

            .inf-btn {
                width: 100%;
            }

            .inf-form-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            syncInt_bindsubdomain();
        });

        function syncInt_bindsubdomain() {
            $.ajax({
                url: "ImportFeedback.aspx/GetUserInfo",
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",

                success: function (data) {
                    dataArray = JSON.parse(data.d);
                    $.each(dataArray, function (data, value) {
                        if (blankForNull(value.SubDomain) == "Credit" || blankForNull(value.SubDomain) == "Servicing") {
                            $("#syncInt_domain").val(blankForNull(value.SubDomain));
                            document.getElementById("tddomainhead").style.display = "none";
                            document.getElementById("tddomainrow").style.display = "none";
                        }
                        else {
                            $("#syncInt_domain").val("");
                            document.getElementById("tddomainhead").style.display = "";
                            document.getElementById("tddomainrow").style.display = "";
                        }
                    })
                }
            });
        }

        function syncInt_show() {
            $('#load1').show();
            var ddldomain = document.getElementById("syncInt_domain");
            var subdomain = ddldomain.options[ddldomain.selectedIndex].value;
            var FromDate = document.getElementById("syncInt_FromDate").value;
            var ToDate = document.getElementById("syncInt_ToDate").value;
            if (FromDate == "") {
                alert("Please select From Date.");
                return false;
            }
            if (ToDate == "") {
                alert("Please select To Date.");
                return false;
            }
            if (subdomain == "") {
                alert("Please select Subdomain.");
                return false;
            }
            var FileName = "Internal Feedbacks_" + FromDate + "~" + ToDate + "-" + subdomain;
            var columns = [];
            $.ajax({
                url: "SyncInternalFeedback.aspx/SyncInternalFeedbacks",
                type: "POST",
                dataType: "json",
                data: "{FromDate:'" + FromDate + "', ToDate:'" + ToDate + "', Subdomain:'" + subdomain + "'}",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    var columncount = 0;
                    var dataArray = JSON.parse(data.d);
                    if (dataArray == null || dataArray == "") {
                        document.getElementById("btnsyncInsert").style.display = 'none';
                        document.getElementById("syncInt_errmsg").innerHTML = "<span style='color:red;'>No Records found for selected dates.</span>";
                        $("#syncInt_dverror").modal('show');
                        $("#load1").hide();
                    }
                    else
                        document.getElementById("btnsyncInsert").style.display = '';
                    $.each(dataArray[0], function (key, value) {
                        var my_item = {};
                        my_item.data = key;
                        my_item.title = key;
                        columns.push(my_item);
                        columncount++;
                    });
                    $('#syncInt_table').DataTable({
                        dom: 'Bftip',
                        destroy: true,
                        scrollY: '400px',
                        scrollX: true,
                        "paging": true,
                        "autoWidth": true,
                        select: true,
                        "ordering": true,
                        processing: true,
                        'select': {
                            'style': 'single'
                        },
                        "data": dataArray,
                        "columns": columns,

                        initComplete: function () {
                            $("#load1").hide();
                            document.getElementById("syncInt_errmsg").innerHTML = "<span style='color:green;'>Please check feedback details and click on 'Sync now' button.</span>";
                            $("#syncInt_dverror").modal('show');
                            document.getElementById("btnsyncIntshow").disabled = true;
                            document.getElementById("btnsyncInsert").style.display = '';
                        },
                        buttons: [
                            {
                                extend: 'excelHtml5', title: FileName, autoFilter: true,

                            },
                        ],
                        fnCreatedRow: function (nRow, aData, iDataIndex) {
                            $(nRow).children("td").css("text-wrap", "nowrap");
                            $(nRow).children("td").css("text-align", "center");
                        },
                    });

                },
                error: function (error) {
                    alert('error; ' + eval(error));
                    alert('error; ' + error.responseText);
                }
            });
            return false;
        }
        function syncint_hidepopup() {
            $("#syncInt_dverror").modal('hide');

        }

        function syncInt_Insert() {
            var ddldomain = document.getElementById("syncInt_domain");
            var subdomain = ddldomain.options[ddldomain.selectedIndex].value;
            var FromDate = document.getElementById("syncInt_FromDate").value;
            var ToDate = document.getElementById("syncInt_ToDate").value;
            $('#waitingpanel').modal('show');
            document.getElementById("spntext").innerHTML = "Please wait, while feedback synchronization is in process . . .";
            //PageMethods.ImportExceldata(importexceldata_OnSuccess, importexceldata_OnError);
            PageMethods.InsertSyncedInternalFeedbacks(FromDate, ToDate, subdomain, syncInt_OnSuccess, syncInt_OnError);
            return false;
        }
        function syncInt_OnSuccess(result) {
            $('#waitingpanel').modal('hide');
            document.getElementById("syncInt_errmsg").innerHTML = "<span style='color:green;'>Feedbacks synchronized successfully!</span>";
            $("#syncInt_dverror").modal('show');
            return false;
        }
        function syncInt_OnError(error) {
            alert(error.responseText);
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div>Mapping feedback records with the tracking sheet and fetching accurate data. Please wait . . . .</div>
    </div>

    <div class="inf-page">
        <div class="inf-hero">
            <div>
                <div class="inf-kicker">Quality Feedback</div>
                <h1 class="inf-title">
                    <i class="fas fa-arrows-rotate mr-2"></i>
                    Sync Internal Feedback
                </h1>
                <p class="inf-subtitle">
                    Select a date range and domain, preview internal feedback records, then sync the verified data.
                </p>
            </div>
            <div class="inf-hero-actions">
                <a href="InfinityFeedback.aspx" class="inf-btn inf-btn-light">
                    <i class="fas fa-arrow-left"></i>
                    Go Back
                </a>
            </div>
        </div>

        <div class="inf-panel">
            <div class="inf-panel-header">
                <div>
                    <h2 class="inf-panel-title"><i class="fas fa-filter"></i> Sync Criteria</h2>
                    <div class="inf-panel-subtitle">Labels are placed above each field for a cleaner, responsive form layout.</div>
                </div>
            </div>
            <div class="inf-panel-body">
                <div class="inf-section-title"><i class="fas fa-calendar-days"></i> Date Range And Domain</div>
                <div class="inf-form-grid">
                    <div class="inf-field">
                        <label for="syncInt_FromDate">From Date</label>
                        <input type="date" class="form-control" id="syncInt_FromDate" name="infFeedback_FromDate" />
                    </div>
                    <div class="inf-field">
                        <label for="syncInt_ToDate">To Date</label>
                        <input type="date" class="form-control" id="syncInt_ToDate" name="infFeedback_ToDate" />
                    </div>
                    <div class="inf-field" id="tddomainhead">
                        <label for="syncInt_domain">Domain</label>
                        <select id="syncInt_domain" name="syncInt_domain" class="form-control">
                            <option value="">Select</option>
                            <option value="Credit">Credit</option>
                            <option value="Servicing">Servicing</option>
                        </select>
                    </div>
                    <div id="tddomainrow" style="display:none;"></div>
                </div>

                <div class="inf-action-row">
                    <button class="inf-btn inf-btn-primary" type="button" id="btnsyncIntshow" onclick="return syncInt_show();">
                        <i class="fas fa-magnifying-glass"></i>
                        Show
                    </button>
                    <button class="inf-btn inf-btn-dark" type="button" id="btnsyncInsert" onclick="return syncInt_Insert();" style="display: none;">
                        <i class="fas fa-arrows-rotate"></i>
                        Sync Now
                    </button>
                </div>
            </div>
        </div>

        <div class="inf-panel">
            <div class="inf-panel-header">
                <div>
                    <h2 class="inf-panel-title"><i class="fas fa-table-list"></i> Internal Feedback Preview</h2>
                    <div class="inf-panel-subtitle">Review synced feedback details before inserting them into the system.</div>
                </div>
            </div>
            <div class="inf-table-wrap">
                <table class="table" id="syncInt_table" style="width: 100%;">
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="syncInt_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title inf-modal-message" id="syncInt_errmsg"></h6>
                </div>
                <div class="modal-footer align-content-center">
                    <button class="inf-btn inf-btn-primary" type="button" id="syncInt_btnMessage" onclick="return syncint_hidepopup();">Okay</button>
                </div>
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
        $(document).ready(function () {
            syncInt_bindsubdomain();
        });

        function syncInt_bindsubdomain() {
            $.ajax({
                url: "ImportFeedback.aspx/GetUserInfo",
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",

                success: function (data) {
                    dataArray = JSON.parse(data.d);
                    $.each(dataArray, function (data, value) {
                        if (blankForNull(value.SubDomain) == "Credit" || blankForNull(value.SubDomain) == "Servicing") {
                            $("#syncInt_domain").val(blankForNull(value.SubDomain));
                            document.getElementById("tddomainhead").style.display = "none";
                            document.getElementById("tddomainrow").style.display = "none";
                        }
                        else {
                            $("#syncInt_domain").val("");
                            document.getElementById("tddomainhead").style.display = "";
                            document.getElementById("tddomainrow").style.display = "";
                        }
                    })
                }
            });
        }

        function syncInt_show() {
            $('#load1').show();
            var ddldomain = document.getElementById("syncInt_domain");
            var subdomain = ddldomain.options[ddldomain.selectedIndex].value;
            var FromDate = document.getElementById("syncInt_FromDate").value;
            var ToDate = document.getElementById("syncInt_ToDate").value;
            if (FromDate == "") {
                alert("Please select From Date.");
                return false;
            }
            if (ToDate == "") {
                alert("Please select To Date.");
                return false;
            }
            if (subdomain == "") {
                alert("Please select Subdomain.");
                return false;
            }
            var FileName = "Internal Feedbacks_" + FromDate + "~" + ToDate + "-" + subdomain;
            var columns = [];
            $.ajax({
                url: "SyncInternalFeedback.aspx/SyncInternalFeedbacks",
                type: "POST",
                dataType: "json",
                data: "{FromDate:'" + FromDate + "', ToDate:'" + ToDate + "', Subdomain:'" + subdomain + "'}",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    var columncount = 0;
                    var dataArray = JSON.parse(data.d);
                    if (dataArray == null || dataArray == "") {
                        document.getElementById("btnsyncInsert").style.display = 'none';
                        document.getElementById("syncInt_errmsg").innerHTML = "<span style='color:red;'>No Records found for selected dates.</span>";
                        $("#syncInt_dverror").modal('show');
                        $("#load1").hide();
                    }
                    else
                        document.getElementById("btnsyncInsert").style.display = '';
                    $.each(dataArray[0], function (key, value) {
                        var my_item = {};
                        my_item.data = key;
                        my_item.title = key;
                        columns.push(my_item);
                        columncount++;
                    });
                    $('#syncInt_table').DataTable({
                        dom: 'Bftip',
                        destroy: true,
                        scrollY: '400px',
                        scrollX: true,
                        "paging": true,
                        "autoWidth": true,
                        select: true,
                        "ordering": true,
                        processing: true,
                        'select': {
                            'style': 'single'
                        },
                        "data": dataArray,
                        "columns": columns,

                        initComplete: function () {
                            $("#load1").hide();
                            document.getElementById("syncInt_errmsg").innerHTML = "<span style='color:green;'>Please check feedback details and click on 'Sync now' button.</span>";
                            $("#syncInt_dverror").modal('show');
                            document.getElementById("btnsyncIntshow").disabled = true;
                            document.getElementById("btnsyncInsert").style.display = '';
                        },
                        buttons: [
                            {
                                extend: 'excelHtml5', title: FileName, autoFilter: true,

                            },
                        ],
                        fnCreatedRow: function (nRow, aData, iDataIndex) {
                            $(nRow).children("td").css("text-wrap", "nowrap");
                            $(nRow).children("td").css("text-align", "center");
                        },
                    });

                },
                error: function (error) {
                    alert('error; ' + eval(error));
                    alert('error; ' + error.responseText);
                }
            });
            return false;
        }
        function syncint_hidepopup() {
            $("#syncInt_dverror").modal('hide');

        }

        function syncInt_Insert() {
            var ddldomain = document.getElementById("syncInt_domain");
            var subdomain = ddldomain.options[ddldomain.selectedIndex].value;
            var FromDate = document.getElementById("syncInt_FromDate").value;
            var ToDate = document.getElementById("syncInt_ToDate").value;
            $('#waitingpanel').modal('show');
            document.getElementById("spntext").innerHTML = "Please wait, while feedback synchronization is in process . . .";
            //PageMethods.ImportExceldata(importexceldata_OnSuccess, importexceldata_OnError);
            PageMethods.InsertSyncedInternalFeedbacks(FromDate, ToDate, subdomain, syncInt_OnSuccess, syncInt_OnError);
            return false;
        }
        function syncInt_OnSuccess(result) {
            $('#waitingpanel').modal('hide');
            document.getElementById("syncInt_errmsg").innerHTML = "<span style='color:green;'>Feedbacks synchronized successfully!</span>";
            $("#syncInt_dverror").modal('show');
            return false;
        }
        function syncInt_OnError(error) {
            alert(error.responseText);
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">Mapping feedback records with the tracking sheet… fetching accurate data. Please wait.  . . . .</div>
    </div>

    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Sync Internal Feedback</b></h6>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right" style="font-size: 12px; font-weight: bold;">
                        <li class="breadcrumb-item"><a href="InfinityFeedback.aspx" style="color: saddlebrown"> << Go Back </a></li>
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
                        <td><b>From Date :</b></td>
                        <td>
                            <input type="date" class="form-control" id="syncInt_FromDate" name="infFeedback_FromDate" />
                        </td>
                        <td><b>To Date :</b></td>
                        <td>
                            <input type="date" class="form-control" id="syncInt_ToDate" name="infFeedback_ToDate" />
                        </td>
                        <td id="tddomainhead"><b>Domain:</b></td>
                        <td id="tddomainrow">
                            <select id="syncInt_domain" name="syncInt_domain" class="form-control" style="width: 250px;">
                                <option value="">Select</option>
                                <option value="Credit">Credit</option>
                                <option value="Servicing">Servicing</option>
                            </select>
                        </td>
                        <td>
                            <button class="btn btn-primary" type="button" id="btnsyncIntshow" onclick="return syncInt_show();">Show</button>
                            <button class="btn btn-dark" type="button" id="btnsyncInsert" onclick="return syncInt_Insert();" style="display: none;">Sync Now</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <table class="table" id="syncInt_table" style="width: 100%;">
                </table>
            </div>
        </div>
    </div>
    <div class="modal fade" id="syncInt_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="syncInt_errmsg"></h6>
                </div>
                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="syncInt_btnMessage" onclick="return syncint_hidepopup();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
    <div class="modal fade" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">System is updating details. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>
</asp:Content>--%>
