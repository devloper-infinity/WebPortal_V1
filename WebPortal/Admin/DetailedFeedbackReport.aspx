<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="DetailedFeedbackReport.aspx.cs" Inherits="WebPortal.Admin.DetailedFeedbackReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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

        .dataTables_scrollBody {
            min-height: 100px !important;
            height: auto;
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
            /*    background: linear-gradient(to bottom, #007bff, 3%, #fff) !important;*/
            color: #000;
        }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
        }



        /*.form-control {
            font-size: 11px !important;
        }*/

        .modern-report-header {
            align-items: center;
            background: #fff;
            border: 1px solid #e4e9f2;
            border-left: 4px solid #2563eb;
            border-radius: 8px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, .06);
            display: flex;
            flex-wrap: wrap;
            gap: 14px;
            justify-content: space-between;
            margin: 12px 15px 16px;
            padding: 16px 18px;
        }

        .modern-report-title {
            align-items: center;
            display: flex;
            gap: 12px;
        }

        .modern-report-title-icon {
            align-items: center;
            background: #edf4ff;
            border-radius: 8px;
            color: #1d4ed8;
            display: inline-flex;
            font-size: 18px;
            height: 40px;
            justify-content: center;
            width: 40px;
        }

        .modern-report-title h1 {
            color: #172033;
            font-size: 20px;
            font-weight: 700;
            line-height: 1.2;
            margin: 0;
        }

        .modern-report-title span {
            color: #667085;
            display: block;
            font-size: 12px;
            margin-top: 2px;
        }

        .modern-report-badge {
            align-items: center;
            background: #f8fafc;
            border: 1px solid #e4e9f2;
            border-radius: 6px;
            color: #344054;
            display: inline-flex;
            font-size: 12px;
            font-weight: 600;
            gap: 8px;
            padding: 8px 10px;
        }

        .modern-report-main {
            padding: 0 15px 24px;
        }

        .modern-report-card {
            border: 1px solid #e4e9f2;
            border-radius: 8px;
            box-shadow: 0 10px 28px rgba(15, 23, 42, .06);
            overflow: hidden;
        }

        .modern-report-card .card-body {
            padding: 0;
        }

        .modern-filter-panel {
            background: #fff;
            border-bottom: 1px solid #e4e9f2;
            padding: 16px;
        }

        .modern-filter-grid {
            align-items: flex-end;
            display: grid;
            gap: 14px;
            grid-template-columns: minmax(260px, 1.2fr) minmax(220px, .8fr) auto auto;
        }

        .modern-field label {
            border: none !important;
            color: #475467;
            display: block;
            font-size: 12px;
            font-weight: 700 !important;
            margin-bottom: 6px;
        }

        .modern-field .form-control {
            border-color: #d0d7e2;
            border-radius: 6px;
            box-shadow: none;
            min-height: 38px;
        }

        .modern-field .form-control:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 .15rem rgba(37, 99, 235, .12);
        }

        .modern-btn {
            align-items: center;
            border-radius: 6px;
            display: inline-flex;
            font-weight: 600;
            gap: 8px;
            justify-content: center;
            min-height: 38px;
            padding: 8px 14px;
            white-space: nowrap;
        }

        .modern-btn-primary {
            background: #2563eb;
            border-color: #2563eb;
            color: #fff;
        }

        .modern-btn-primary:hover,
        .modern-btn-primary:focus {
            background: #1d4ed8;
            border-color: #1d4ed8;
            color: #fff;
        }

        .modern-btn-secondary {
            background: #111827;
            border-color: #111827;
            color: #fff;
        }

        .modern-btn-secondary:hover,
        .modern-btn-secondary:focus {
            background: #0f172a;
            border-color: #0f172a;
            color: #fff;
        }

        .modern-table-panel {
            background: #fff;
            padding: 16px;
        }

        .modern-upload-preview {
            background: #f8fafc;
            border: 1px dashed #cbd5e1;
            border-radius: 6px;
            color: #475467;
            margin-top: 8px;
            min-height: 38px;
            padding: 8px 10px;
        }

        .loading {
            background: #fff;
            border: 1px solid #e4e9f2;
            border-radius: 8px;
            box-shadow: 0 18px 40px rgba(15, 23, 42, .16);
            display: none;
            height: auto;
            left: 50%;
            margin: 0;
            min-height: 154px;
            opacity: .96;
            padding: 20px;
            position: fixed;
            text-align: center;
            top: 50%;
            transform: translate(-50%, -50%);
            width: 180px;
            z-index: 99999;
        }

        .loading img {
            max-width: 72px;
        }

        .loading div {
            color: #334155;
            font-size: 12px;
            font-weight: 700;
            margin-top: 12px;
        }

        .table.dataTable th {
            background: #f3f6fb !important;
            border-bottom: 1px solid #d8e0ec !important;
            color: #172033;
            font-weight: 700;
        }

        .table.dataTable tr td {
            background-color: #fff !important;
            color: #344054;
        }

        .table.dataTable tbody tr:hover td {
            background-color: #f8fbff !important;
        }

        .report-waiting-text {
            color: #fff;
            display: inline-block;
            font-size: 22px;
            font-style: normal;
            font-weight: 700;
            margin-top: 10px;
        }

        .report-waiting-dots {
            animation: animate 1s linear infinite;
            color: #fff;
            display: inline-block;
            font-size: 42px;
            font-style: normal;
            font-weight: 700;
        }

        @media (max-width: 991px) {
            .modern-filter-grid {
                grid-template-columns: 1fr 1fr;
            }
        }

        @media (max-width: 767px) {
            .modern-report-header {
                margin-left: 8px;
                margin-right: 8px;
            }

            .modern-report-main {
                padding-left: 8px;
                padding-right: 8px;
            }

            .modern-filter-grid {
                grid-template-columns: 1fr;
            }

            .modern-btn {
                width: 100%;
            }
        }
    </style>

    <script>
        var fr_downloadBtnId = '<%= fr_newdownload.UniqueID %>';
        window.onload = function () {
            document.getElementById('feedbackreport_file').addEventListener('change', getFileName);

        }

        const getFileName = (event) => {
            const files = event.target.files;
            var file = files[0];
            document.getElementById("filep_feedback").value = files[0].name;

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
            document.getElementById("dropzone").classList.add("dz-max-files-reached");
            document.getElementById("conentdiv").style.display = '';
            document.getElementById("filesdivimport").innerHTML = file.name;
            //alert(document.getElementById("filep").value);
        }

        function ValidateExcelSheetInput() {

            var columns = [];
            $.ajax({
                url: "DetailedFeedbackReport.aspx/ValidateExcelSheet",
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    var dataArray = JSON.parse(data.d);//

                    if (dataArray != null && dataArray != '') {
                        $.each(dataArray[0], function (key, value) {
                            var my_item = {};
                            my_item.data = key;
                            my_item.title = key;
                            columns.push(my_item);
                        });
                        $('#dfr_table').DataTable({
                            dom: 't',
                            scrollX: true,
                            destroy: true,
                            "paging": false,
                            "autoWidth": true,
                            select: true,
                            "ordering": false,
                            processing: true,
                            'select': {
                                'style': 'single'
                            },
                            "data": dataArray,
                            "columns": columns,

                            initComplete: function () {
                                $("#waitingpanel").modal("hide");
                            },

                            fnCreatedRow: function (nRow, aData, iDataIndex) {
                                $(nRow).children("td").css("text-wrap", "nowrap");
                                $(nRow).children("td").css("text-align", "center");
                            },
                        });
                    }
                    else {
                        document.getElementById("spntext").innerHTML = "Generating excel sheet with chart : Weekly Graphical View";
                        var ddltype = document.getElementById("feedbackreport_base");
                        var type = ddltype.options[ddltype.selectedIndex].value;
                        PageMethods.getWeeklyGraphicalView(type, feedbackweeklygraphical_OnSuccess, feedbackweeklygraphical_OnError);
                    }
                },
                error: function (error) {
                    alert('error; ' + eval(error));
                    alert('error; ' + error.responseText);
                }
            });
        }

        function feedbackreport_generate() {
            $('#waitingpanel').modal('show');
            document.getElementById("spntext").innerHTML = "Importing excel data into database . . . .";
            Sys.Application.add_load(function () {
                Sys.Net.WebRequestManager.set_defaultTimeout(0);
            });
            PageMethods.ImportExcel(feedbackreport_import_OnSuccess, feedbackreport_import_OnError);
            return false;
        }

        function feedbackreport_import_OnSuccess(result) {

            if (result >= 1) {
                document.getElementById("spntext").innerHTML = "Please wait while system is working on excel validation . . . ";
                var ddltype = document.getElementById("feedbackreport_base");
                var type = ddltype.options[ddltype.selectedIndex].value;
                // PageMethods.getWeeklyGraphicalView(type, feedbackweeklygraphical_OnSuccess, feedbackweeklygraphical_OnError);
                ValidateExcelSheetInput();
                //PageMethods.ValidateExcelSheet(type, validateexcel_OnSuccess, validateexcel_OnError);
            }
            return false;
        }

        function feedbackreport_import_OnError(error) {
            alert(error, get_message());
            alert(error.responseText);
            return false;
        }

        function validateexcel_OnSuccess(result) {
            if (result >= 1) {
                document.getElementById("spntext").innerHTML = "Generating excel sheet with chart : Weekly Graphical View";
                var ddltype = document.getElementById("feedbackreport_base");
                var type = ddltype.options[ddltype.selectedIndex].value;
                PageMethods.getWeeklyGraphicalView(type, feedbackweeklygraphical_OnSuccess, feedbackweeklygraphical_OnError);
            }
            return false;
        }

        function validateexcel_OnError(error) {
            alert(error.responseText);
            return false;
        }

        function feedbackweeklygraphical_OnSuccess(result) {
            if (result >= 1) {
                document.getElementById("spntext").innerHTML = "Generating excel sheet with chart : Client wise Error Trending";
                var ddltype = document.getElementById("feedbackreport_base");
                var type = ddltype.options[ddltype.selectedIndex].value;
                PageMethods.ClientwiseErrorTrending1(type, feedbackclientrending_OnSuccess, feedbackclientrending_OnError);

            }
            return false;
        }

        function feedbackclientrending_OnSuccess(result) {
            if (result >= 1) {
                document.getElementById("spntext").innerHTML = "Generating excel sheet with chart : Reviewer Feedback Summary";
                var ddltype = document.getElementById("feedbackreport_base");
                var type = ddltype.options[ddltype.selectedIndex].value;
                PageMethods.ReviewerFeedbackSummary1(type, feedbackrevsum_OnSuccess, feedbackrevsum_OnError);
            }
            return false;
        }

        function feedbackrevsum_OnSuccess(result) {
            if (result >= 1) {
                document.getElementById("spntext").innerHTML = "Generating excel sheet with chart : Reviewer Vs Qcer Error Count";
                var ddltype = document.getElementById("feedbackreport_base");
                var type = ddltype.options[ddltype.selectedIndex].value;
                PageMethods.ReviewerVsQcerErrorCount1(type, feedbackrevqcerror_OnSuccess, feedbackrevqcerror_OnError);

            }
            return false;
        }

        function feedbackrevqcerror_OnSuccess(result) {
            if (result >= 1) {
                document.getElementById("spntext").innerHTML = "Generating excel sheet with chart : No Error Files Analysis";
                var ddltype = document.getElementById("feedbackreport_base");
                var type = ddltype.options[ddltype.selectedIndex].value;
                PageMethods.NoErrorFileAnalysis1(type, feedbackNoError_OnSuccess, feedbackNoError_OnError);

            }
            return false;
        }

        function feedbackNoError_OnSuccess(result) {
            if (result >= 1) {
                document.getElementById("spntext").innerHTML = "Generating excel sheet with chart : Reviewer wise client wise error";
                var ddltype = document.getElementById("feedbackreport_base");
                var type = ddltype.options[ddltype.selectedIndex].value;
                PageMethods.Reviewerwiseclientwiseerror1(type, feedbackrevclienterror_OnSuccess, feedbackrevclienterror_OnError);
            }
            return false;
        }

        function feedbackrevclienterror_OnSuccess(result) {
            if (result >= 1) {
                document.getElementById("spntext").innerHTML = "Generating excel sheet with chart : Reviewer, QC, client wise error";
                var ddltype = document.getElementById("feedbackreport_base");
                var type = ddltype.options[ddltype.selectedIndex].value;
                PageMethods.ReviewerQCClientwiseerror1(type, feedbackrevqcclienterror_OnSuccess, feedbackrevqcclienterror_OnError);
            }
            return false;
        }

        function feedbackrevqcclienterror_OnSuccess(result) {
            if (result >= 1) {
                document.getElementById("spntext").innerHTML = "Generating excel sheet with chart : QCer Performance";
                var ddltype = document.getElementById("feedbackreport_base");
                var type = ddltype.options[ddltype.selectedIndex].value;
                PageMethods.QCerPerformance1(type, feedbackqcperf_OnSuccess, feedbackqcperf_OnError);
            }
            return false;
        }

        function feedbackqcperf_OnSuccess(result) {
            if (result >= 1) {
                document.getElementById("spntext").innerHTML = "Generating excel sheet with chart : Category and Sub Category";
                var ddltype = document.getElementById("feedbackreport_base");
                var type = ddltype.options[ddltype.selectedIndex].value;
                PageMethods.CategorySubCategory1(type, feedbackcat_OnSuccess, feedbackcat_OnError);
            }
            return false;
        }

        function feedbackcat_OnSuccess(result) {
            if (result >= 1) {
                document.getElementById("spntext").innerHTML = "Generating excel sheet with chart : Internal, ReQC and Client feedbacks";
                var ddltype = document.getElementById("feedbackreport_base");
                var type = ddltype.options[ddltype.selectedIndex].value;
                PageMethods.GetFeedback1(type, feedbackdetails_OnSuccess, feedbackdetails_OnError);
            }
            return false;
        }


        function feedbackdetails_OnSuccess(result) {
            if (result >= 1) {
                document.getElementById("spntext").innerHTML = "Generating excel sheet with chart : Client Quality Report";
                var ddltype = document.getElementById("feedbackreport_base");
                var type = ddltype.options[ddltype.selectedIndex].value;
                // PageMethods.ClientQualityReport(type, feedbackdetails_OnSuccess, feedbackdetails_OnError);
                PageMethods.ClientQualityReport1(type, clientQuality_OnSuccess, clientQuality_OnError);
            }
            return false;
        }

        function clientQuality_OnSuccess(result) {
            if (result >= 1) {
                document.getElementById("spntext").innerHTML = "Downloading Final Output . . .";
                __doPostBack("<%= btn1.UniqueID %>", '');
                $('#waitingpanel').modal('hide');
            }
            return false;
        }

        function clientQuality_OnError(error) {
            alert(error.responseText);
            return false;
        }

        function feedbackdetails_OnError(error) {
            alert(error.responseText);
            return false;
        }

        function feedbackcat_OnError(error) {
            alert(error.responseText);
            return false;
        }

        function feedbackqcperf_OnError(error) {
            alert(error.responseText);
            return false;
        }

        function feedbackrevqcclienterror_OnError(error) {
            alert(error.responseText);
            return false;
        }

        function feedbackrevclienterror_OnError(error) {
            alert(error.responseText);
            return false;
        }

        function feedbackNoError_OnError(error) {
            alert(error.responseText);
            return false;
        }

        function feedbackrevqcerror_OnError(error) {
            alert(error.responseText);
            return false;
        }

        function feedbackrevsum_OnError(error) {
            alert(error.responseText);
            return false;
        }

        function feedbackclientrending_OnError(error) {
            alert(error.responseText);
            return false;
        }

        function feedbackweeklygraphical_OnError(error) {
            alert(error.responseText);
            return false;
        }

        $(document).ready(function () {
            rup_bindusers();
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="filep_feedback" style="display: none;" />
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="modern-report-header">
        <div class="modern-report-title">
            <span class="modern-report-title-icon"><i class="fas fa-file-alt"></i></span>
            <div>
                <h1>Detailed Feedback Output</h1>
                <span>Import feedback data, validate it, and generate the output workbook</span>
            </div>
        </div>
        <div class="modern-report-badge">
            <i class="fas fa-database"></i>
            <span>Excel and database reports</span>
        </div>
    </div>
    <div class="col-lg-12 modern-report-main">
        <div class="card modern-report-card">
            <div class="card-body">
                <div class="modern-filter-panel">
                    <div class="modern-filter-grid">
                        <div class="modern-field">
                            <label for="feedbackreport_file">Attachment</label>
                            <input type="file" id="feedbackreport_file" name="feedbackreport_file" class="form-control" />
                            <%--<div class="dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete modern-upload-preview" id="dropzone">
                                <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column" id="conentdiv" style="display: none!important;">
                                    <div class="flex-1 d-flex flex-between-center">
                                        <div id="filesdivimport" style="margin-top: 10px; margin-bottom: 10px;"></div>
                                        <div class="dropdown font-sans-serif">
                                            <button class="btn btn-link text-600 btn-sm dropdown-toggle btn-reveal dropdown-caret-none" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                <svg class="svg-inline--fa fa-ellipsis" style="display: none!important" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="ellipsis" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg="">
                                                    <path fill="currentColor" d="M120 256C120 286.9 94.93 312 64 312C33.07 312 8 286.9 8 256C8 225.1 33.07 200 64 200C94.93 200 120 225.1 120 256zM280 256C280 286.9 254.9 312 224 312C193.1 312 168 286.9 168 256C168 225.1 193.1 200 224 200C254.9 200 280 225.1 280 256zM328 256C328 225.1 353.1 200 384 200C414.9 200 440 225.1 440 256C440 286.9 414.9 312 384 312C353.1 312 328 286.9 328 256z"></path></svg><!-- <span class="fas fa-ellipsis-h"></span> Font Awesome fontawesome.com --></button>
                                            <div class="dropdown-menu dropdown-menu-end border py-2"><a class="dropdown-item" href="#!" data-dz-remove="data-dz-remove">Remove File</a></div>
                                        </div>
                                    </div>
                                </div>
                            </div>--%>
                        </div>
                        <div class="modern-field">
                            <label for="feedbackreport_base">Report Base</label>
                            <select id="feedbackreport_base" name="feedbackreport_base" class="form-control">
                                <option value="">Select</option>
                                <option value="QC Date">QC Date</option>
                                <option value="Review Date">Review Date</option>
                            </select>
                        </div>
                        <div>
                            <button id="feedbackreport_btngenerate" name="feedbackreport_btngenerate" class="btn modern-btn modern-btn-primary" onclick="return feedbackreport_generate();"><i class="fas fa-file-export"></i><span>Generate Output File</span></button>
                            <asp:Button ID="btn1" runat="server" Style="display: none;" OnClick="btn1_Click" />
                        </div>
                        <div>
                            <button id="feedbackreport_btnGenerateDB" name="feedbackreport_btnGenerateDB" class="btn modern-btn modern-btn-secondary" onclick="return feedbackreport_getreportfromdatabase();"><i class="fas fa-server"></i><span>Generate Report from Database</span></button>
                            <asp:Button ID="fr_newdownload" runat="server" Style="display: none;" OnClick="fr_newdownload_Click" />
                        </div>
                    </div>
                </div>
                <div class="modern-table-panel">
                    <table class="table table-bordered" id="dfr_table" style="width: 100%;"></table>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span class="report-waiting-text" id="spntext">System is updating details. Please wait</span>
            <span class="report-waiting-dots">&nbsp;. . . .</span>
        </div>
    </div>
    <div class="modal fade" id="feedbckreport_companyselection">
        <div class="modal-dialog modal-s">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Criteria</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table table-responsive" style="width: 100%;">
                        <tr id="feedbackreport_tddomainhead">
                            <td><b>Domain:</b></td>
                            <td>
                                <select id="feedbackreport_domain" name="feedbackreport_domain" class="form-control" style="width: 250px;" onchange="return getcanopyinfinity(this);">
                                    <option value="">Select</option>
                                    <option value="Credit">Credit</option>
                                    <option value="Servicing">Servicing</option>
                                </select>
                            </td>
                        </tr>
                        <tr id="feedbackreport_trcompany" style="display:none;">
                            <td><b>Company:</b></td>
                            <td>
                                <select id="feedbackreport_company" name="feedbackreport_company" class="form-control" style="width: 250px;">
                                    <option value="">Select</option>
                                    <option value="Canopy">Canopy</option>
                                    <option value="Infinity">Infinity</option>
                                </select>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button class="btn btn-primary" type="button" id="btnclose" onclick="return feedbackreport_generateNewReport();">Gnerate Report</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>
