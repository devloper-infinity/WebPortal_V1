<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="HoursSpent.aspx.cs" Inherits="WebPortal.Admin.HoursSpent" %>

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

        .dataTables_length, .dataTables_info {
            float: left !important;
        }

        .dataTables_scrollHeadInner {
            width: 100% !important;
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
            /*   margin: 0px 10px;*/
            border-radius: 12px;
            height: 40px;
            width: 95%;
            font-weight: 400;
            transition: 0.3s;
        }

        .table {
            width: 100% !important;
        }

        .dataTable {
            width: 100% !important;
        }

        .no-footer {
            width: 100% !important;
        }

        .table.dataTable th {
            background: linear-gradient(to bottom, #007bff, 3%, #fff) !important;
            color: #000;
            text-align: left;
        }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
        }

        .dataTables_scrollBody {
            min-height: 20px !important;
            height: auto !important;
        }

        .tab-pane {
            height: auto !important;
        }

        .dataTables_wrapper {
            margin-top: 0 !important;
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
                /*background: linear-gradient(135deg, #4da6ff, #1a8cff);*/
                background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;
                color: #fff;
            }
    </style>

    <script>
        //$(document).ready(function () {
        //    bindProjectWiseData("26-Nov-2025", "12-Dec-2025");
        //});

        $(document).ready(function () {

            bindProjectWiseData("26-Nov-2025", "12-Dec-2025");

            //$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {

            //    var activeTab = $(e.target).attr('href');

            //    // Destroy tables in NON-active tabs only
            //    if (activeTab !== '#custom-tabs-one-home-tab') {
            //        destroyTable('#hoursSpent_project');
            //    }
            //    if (activeTab !== '#custom-tabs-two-tab') {
            //        destroyTable('#hoursSpenttable_prjprc');
            //    }
            //    if (activeTab !== '#custom-tabs-three-tab') {
            //        destroyTable('#hoursSpenttable_prjprcuser');
            //    }
            //    if (activeTab !== '#custom-tabs-four-tab') {
            //        destroyTable('#hoursSpenttable_proddata');
            //    }
            //});
        });

        //function destroyTable(tableId) {
        //    if ($.fn.DataTable.isDataTable(tableId)) {
        //        $(tableId).DataTable().clear().destroy();
        //        $(tableId + ' tbody').empty();
        //    }
        //}

        function hoursSpent_Exporttoexcel() {
            __doPostBack("<%= btnHoursSpent.UniqueID %>", '');
            return false;
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Button ID="btnHoursSpent" runat="server" Style="display: none;" OnClick="btnHoursSpent_Click" />
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Hours Spent</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <div class="row align-items-end g-4">
                    <div class="col-md-4">
                        <label class="form-label"><b>From Date</b></label>
                        <div class="input-group">
                            <input type="date" id="hoursSpent_from" name="hoursSpent_from" class="form-control" />
                        </div>
                    </div>

                    <!-- Year -->
                    <div class="col-md-4">
                        <label class="form-label"><b>To Date </b></label>
                        <div class="input-group">
                            <input type="date" id="hoursSpent_to" name="hoursSpent_to" class="form-control" />
                        </div>
                    </div>

                    <!-- Get Report -->
                    <div class="col-md-2">
                        <button id="ackMonthly_btnShow" type="button" class="btn btn-gradient-primary w-100" onclick="return hoursSpent_show()">Get Record</button>
                    </div>
                    <div class="col-md-2">
                        <button class="btn btn-secondary buttons-excel buttons-html5 btn-success" id="hoursSpent_btnExporttoexcel" onclick="return hoursSpent_Exporttoexcel();" type="button"><span>Export to Excel</span></button>
                    </div>
                </div>
                <br />
                <div class="card card-tabs">
                    <div class="card-header p-0 pt-1">
                        <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist" style="font-weight: bold;">
                            <li class="nav-item">
                                <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-project" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Project</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-two-tab" onclick="return bindprjprc();" data-toggle="pill" href="#custom-tabs-two-prjprc" role="tab" aria-controls="custom-tabs-ctrl-two-prjprc" aria-selected="false">Project + Process</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-three-tab" onclick="return binduserwise();" data-toggle="pill" href="#custom-tabs-three-prjprcuser" role="tab" aria-controls="custom-tabs-ctrl-three-prjprcuser" aria-selected="false">Project + User +Process</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-four-tab" onclick="return bindprodData();" data-toggle="pill" href="#custom-tabs-four-proddata" role="tab" aria-controls="custom-tabs-ctrl-four-proddata" aria-selected="false">Production Data</a>
                            </li>
                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-project" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                                <table class="table" id="hoursSpent_project" style="padding-top: 10px; width: 100%!important;"></table>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-two-prjprc" role="tabpanel" aria-labelledby="custom-tabs-two-prjprc-tab">
                                <table class="table" id="hoursSpenttable_prjprc" style="padding-top: 10px; width: 100%!important;">
                                    <thead style="text-align: left;"></thead>
                                </table>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-three-prjprcuser" role="tabpanel" aria-labelledby="custom-tabs-three-prjprcuser-tab">
                                <table class="table" id="hoursSpenttable_prjprcuser" style="padding-top: 10px; width: 100%!important;">
                                    <thead style="text-align: left;"></thead>
                                </table>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-four-proddata" role="tabpanel" aria-labelledby="custom-tabs-four-proddata-tab">
                                <table class="table" id="hoursSpenttable_proddata" style="padding-top: 10px; width: 100%!important;"></table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="Prodwaitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">System is updating details. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>
</asp:Content>
