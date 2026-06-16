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
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Detailed Feedback Output</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <table class="table">
                    <tr>
                        <td><b>Attachment:</b></td>
                        <td>
                            <input type="file" id="feedbackreport_file" name="feedbackreport_file" class="form-control" style="width: 250px;" />
                            <div class="dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete" id="dropzone">
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
                            </div>
                        </td>
                        <td><b>Report Base:</b></td>
                        <td>
                            <select id="feedbackreport_base" name="feedbackreport_base" class="form-control" style="width: 250px;">
                                <option value="">Select</option>
                                <option value="QC Date">QC Date</option>
                                <option value="Review Date">Review Date</option>
                            </select>
                        </td>
                        <td>
                            <button id="feedbackreport_btngenerate" name="feedbackreport_btngenerate" class="btn btn-primary" onclick="return feedbackreport_generate();">Generate Output File</button>
                            <asp:Button ID="btn1" runat="server" Style="display: none;" OnClick="btn1_Click" />
                        </td>
                        <td>
                            <button id="feedbackreport_btnGenerateDB" name="feedbackreport_btnGenerateDB" class="btn btn-success" onclick="return feedbackreport_getreportfromdatabase();">Generate Report from Database</button>
                            <asp:Button ID="fr_newdownload" runat="server" Style="display: none;" OnClick="fr_newdownload_Click" />
                        </td>
                    </tr>
                </table>
                <hr />
                <table class="table table-bordered" id="dfr_table" style="width: 100%;"></table>
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
