<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="LetterHeadManagement.aspx.cs" Inherits="WebPortal.Admin.LetterHeadManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .loading {
            display: none;
            position: fixed;
            inset: 0;
            margin: auto;
            width: 192px;
            height: 192px;
            z-index: 99999;
            text-align: center;
            background: rgba(255,255,255,.92);
            border-radius: 24px;
            box-shadow: 0 18px 45px rgba(15,23,42,.18);
            padding-top: 28px;
        }

        .lhm-page {
            background: #f6f9ff;
            min-height: calc(100vh - 80px);
        }

        .lhm-hero {
            position: relative;
            overflow: hidden;
            border-radius: 22px;
            padding: 24px 28px;
            margin-bottom: 18px;
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%);
            box-shadow: 0 18px 38px rgba(37, 99, 235, .26);
        }

        .lhm-hero:before,
        .lhm-hero:after {
            content: "";
            position: absolute;
            border-radius: 999px;
            background: rgba(255,255,255,.14);
        }

        .lhm-hero:before {
            width: 180px;
            height: 180px;
            right: -45px;
            top: -70px;
        }

        .lhm-hero:after {
            width: 120px;
            height: 120px;
            right: 110px;
            bottom: -65px;
        }

        .lhm-hero-inner {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            flex-wrap: wrap;
        }

        .lhm-title-wrap {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .lhm-hero-icon {
            width: 58px;
            height: 58px;
            border-radius: 18px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.2);
            border: 1px solid rgba(255,255,255,.25);
            font-size: 26px;
            box-shadow: inset 0 1px 0 rgba(255,255,255,.25);
        }

        .lhm-hero h3 {
            margin: 0;
            font-size: 24px;
            font-weight: 800;
            letter-spacing: .2px;
        }

        .lhm-hero p {
            margin: 4px 0 0;
            color: rgba(255,255,255,.9);
            font-size: 13px;
        }

        .lhm-chip {
            padding: 8px 14px;
            border-radius: 999px;
            background: rgba(255,255,255,.18);
            border: 1px solid rgba(255,255,255,.24);
            font-weight: 700;
            font-size: 12px;
            white-space: nowrap;
        }

        .lhm-card {
            background: #fff;
            border: 1px solid #e5edf8;
            border-radius: 20px;
            box-shadow: 0 12px 30px rgba(15, 23, 42, .08);
            margin-bottom: 18px;
            overflow: hidden;
        }

        .lhm-card-header {
            padding: 16px 20px;
            border-bottom: 1px solid #e8eef7;
            background: linear-gradient(180deg, #fff 0%, #f8fbff 100%);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            flex-wrap: wrap;
        }

        .lhm-card-title {
            margin: 0;
            font-size: 16px;
            font-weight: 800;
            color: #0f172a;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .lhm-card-title i {
            color: #2563eb;
        }

        .lhm-card-body {
            padding: 20px;
        }

        .lhm-field {
            margin-bottom: 16px;
        }

        .lhm-field label {
            display: block;
            margin-bottom: 7px;
            color: #334155;
            font-size: 13px;
            font-weight: 700 !important;
            border: none !important;
        }

        .lhm-field label i {
            color: #2563eb;
            margin-right: 6px;
        }

        .lhm-field .form-control,
        .lhm-field select {
            width: 100% !important;
            min-height: 42px;
            border: 1px solid #d7e0ec;
            border-radius: 12px;
            box-shadow: none;
            font-size: 13px;
            transition: .22s ease;
        }

        .lhm-field .form-control:focus,
        .lhm-field select:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, .1);
        }

        .lhm-actions {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
            padding-top: 8px;
        }

        .btn-lhm-primary {
            border: 0;
            color: #fff !important;
            background: linear-gradient(120deg, #1d4ed8, #22c1dc);
            border-radius: 12px;
            padding: 10px 24px;
            font-weight: 800;
            box-shadow: 0 10px 22px rgba(37, 99, 235, .24);
            transition: .22s ease;
        }

        .btn-lhm-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 14px 28px rgba(37, 99, 235, .30);
        }

        .lhm-table-wrap {
            padding: 16px 18px 20px;
        }

        #letterhead_table {
            width: 100% !important;
            border-collapse: separate !important;
            border-spacing: 0;
            font-size: 13px;
        }

        #letterhead_table thead th {
            background: #edf3f6 !important;
            color: #0f172a !important;
            font-weight: 800;
            text-align: center;
            height: 42px;
            white-space: nowrap;
            border-bottom: 1px solid #d9e4ef !important;
        }

        #letterhead_table tbody td {
            background: #fff !important;
            vertical-align: middle;
            border-bottom: 1px solid #edf2f7;
        }

        #letterhead_table tbody tr:hover td {
            background: #f8fbff !important;
        }

        .dataTables_length,
        .dataTables_info {
            float: left !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 12px;
            float: left;
        }

        .buttons-excel,
        .buttons-html5 {
            color: #fff !important;
            box-shadow: none;
            background: linear-gradient(120deg, #1d4ed8, #22c1dc) !important;
            border: 0 !important;
            font-weight: 700;
            border-radius: 9px !important;
            margin: 0 8px;
        }

        .modal-content {
            border: 0;
            border-radius: 18px;
            box-shadow: 0 18px 45px rgba(15,23,42,.2);
        }

        .modal-header {
            border-bottom: 1px solid #edf2f7;
        }

        @media (max-width: 767px) {
            .lhm-page {
                padding: 12px;
            }

            .lhm-hero {
                padding: 20px;
                border-radius: 18px;
            }

            .lhm-hero h3 {
                font-size: 20px;
            }

            .lhm-actions {
                justify-content: stretch;
            }

            .btn-lhm-primary {
                width: 100%;
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            Letterhead_BindCodes();
            Letterhead_BindGrid();
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold; margin-top: 10px;">One moment, please . . . .</div>
    </div>

    <div class="lhm-page">
        <div class="lhm-hero">
            <div class="lhm-hero-inner">
                <div class="lhm-title-wrap">
                    <div class="lhm-hero-icon">
                        <i class="fas fa-file-signature"></i>
                    </div>
                    <div>
                        <h3>Letter Head Management</h3>
                        <p>Manage employee letterhead requests, reasons, dates and issued count in one place.</p>
                    </div>
                </div>
                <div class="lhm-chip">
                    <i class="fas fa-copy"></i> HR Operations
                </div>
            </div>
        </div>

        <div class="lhm-card">
            <div class="lhm-card-header">
                <h5 class="lhm-card-title"><i class="fas fa-edit"></i> Letterhead Request Details</h5>
            </div>
            <div class="lhm-card-body">
                <div class="row">
                    <div class="col-lg-3 col-md-6 col-sm-12">
                        <div class="lhm-field">
                            <label for="letterhead_employee"><i class="fas fa-user-tie"></i>Employee</label>
                            <select id="letterhead_employee" name="letterhead_employee" class="form-control" required>
                                <option value="">Select</option>
                            </select>
                        </div>
                    </div>

                    <div class="col-lg-3 col-md-6 col-sm-12">
                        <div class="lhm-field">
                            <label for="letterhead_date"><i class="fas fa-calendar-alt"></i>Date</label>
                            <input type="date" id="letterhead_date" name="letterhead_date" class="form-control" required />
                        </div>
                    </div>

                    <div class="col-lg-3 col-md-6 col-sm-12">
                        <div class="lhm-field">
                            <label for="letterhead_reason"><i class="fas fa-comment-dots"></i>Reason</label>
                            <input type="text" id="letterhead_reason" name="letterhead_reason" class="form-control" required />
                        </div>
                    </div>

                    <div class="col-lg-3 col-md-6 col-sm-12">
                        <div class="lhm-field">
                            <label for="letterhead_count"><i class="fas fa-sort-numeric-up"></i>Letterhead Count</label>
                            <input type="number" id="letterhead_count" name="letterhead_count" class="form-control" required />
                        </div>
                    </div>
                </div>

                <div class="lhm-actions">
                    <button type="button" id="letterhead_btnsubmit" class="btn btn-lhm-primary" onclick="return letterhead_submit();">
                        <i class="fas fa-paper-plane"></i> Submit
                    </button>
                </div>
            </div>
        </div>

        <div class="lhm-card">
            <div class="lhm-card-header">
                <h5 class="lhm-card-title"><i class="fas fa-clipboard-list"></i> Letterhead Request Report</h5>
            </div>
            <div class="lhm-table-wrap">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover" id="letterhead_table" style="width: 100%;">
                        <thead>
                            <tr>
                                <th class="sort border-top ps-3">Date</th>
                                <th class="sort border-top ps-3">Code</th>
                                <th class="sort border-top ps-3">Employee Name</th>
                                <th class="sort border-top ps-3">Branch</th>
                                <th class="sort border-top ps-3">Domain</th>
                                <th class="sort border-top ps-3">Reason</th>
                                <th class="sort border-top ps-3">Count</th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="letterhead_dverror">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="letterhead_errmsg"></h6>
                </div>
                <div class="modal-footer justify-content-center">
                    <button class="btn btn-lhm-primary" type="button" id="letterhead_btnMessage" onclick="return letterhead_Message();">
                        Okay
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
            background: linear-gradient(to bottom, #007bff, 3%, #fff) !important;
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
        $(document).ready(function () {
            Letterhead_BindCodes();
            Letterhead_BindGrid();
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Letter Head Management</b></h6>
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
                        <td><b>Employee:</b></td>
                        <td>
                            <select id="letterhead_employee" name="letterhead_employee" class="form-control" style="width: 300px;" required>
                                <option value="">Select</option>
                            </select>
                        </td>
                        <td><b>Date:</b></td>
                        <td>
                            <input type="date" id="letterhead_date" name="letterhead_date" class="form-control" style="width: 300px" required />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Reason:</b></td>
                        <td>
                            <input type="text" id="letterhead_reason" name="letterhead_reason" class="form-control" style="width: 300px;" required />
                        </td>
                        <td><b>Letterhead Count:</b></td>
                        <td>
                            <input type="number" id="letterhead_count" name="letterhead_count" class="form-control" style="width: 300px;" required />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4" align="center">
                            <button id="letterhead_btnsubmit" class="btn btn-primary" onclick="return letterhead_submit();">Submit</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <table class="table" id="letterhead_table" style="padding-top: 10px; width: 100%;"">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Employee Name</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Domain</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Reason</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Count</th>
                        </tr>
                    </thead>
                    <tbody>
                        
                    </tbody>
                </table>

            </div>
        </div>
    </div>


    <div class="modal fade" id="letterhead_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="letterhead_errmsg"></h6>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="letterhead_btnMessage" onclick="return letterhead_Message();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>--%>
