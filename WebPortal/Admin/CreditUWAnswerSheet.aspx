<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="CreditUWAnswerSheet.aspx.cs" Inherits="WebPortal.Admin.CreditUWAnswerSheet" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .loading {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 99999;
            background: rgba(255, 255, 255, .78);
            align-items: center;
            justify-content: center;
            flex-direction: column;
            backdrop-filter: blur(3px);
        }

        .loading img {
            width: 70px;
            height: 70px;
        }

        .loading div {
            margin-top: 10px;
            font-size: 13px;
            font-weight: 700;
            color: #1e293b;
        }

        .cruw-page {
          /*  padding: 18px 14px 28px;*/
        }

        .cruw-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            padding: 26px 30px;
            margin-bottom: 22px;
            border-radius: 18px;
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 55%, #22c1dc 100%);
            box-shadow: 0 14px 32px rgba(37, 99, 235, .24);
        }

        .cruw-hero::before {
            content: "";
            position: absolute;
            top: -95px;
            left: -35px;
            width: 420px;
            height: 220px;
            border-radius: 50%;
            background: rgba(255, 255, 255, .14);
            transform: rotate(-8deg);
        }

        .cruw-hero::after {
            content: "";
            position: absolute;
            right: -90px;
            bottom: -105px;
            width: 360px;
            height: 260px;
            border-radius: 50%;
            background: rgba(255, 255, 255, .12);
        }

        .cruw-hero-left,
        .cruw-hero-action {
            position: relative;
            z-index: 2;
        }

        .cruw-hero-left {
            display: flex;
            align-items: center;
            gap: 18px;
        }

        .cruw-hero-icon {
            width: 72px;
            height: 72px;
            min-width: 72px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            border: 2px solid rgba(255, 255, 255, .70);
            background: rgba(255, 255, 255, .13);
            box-shadow: inset 0 0 18px rgba(255, 255, 255, .12);
        }

        .cruw-hero-icon i {
            font-size: 31px;
            color: #fff;
        }

        .cruw-kicker {
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 1.8px;
            text-transform: uppercase;
            opacity: .9;
            margin-bottom: 5px;
        }

        .cruw-title {
            margin: 0;
            color: #fff;
            font-size: 28px;
            line-height: 1.2;
            font-weight: 800;
        }

        .cruw-subtitle {
            margin: 7px 0 0;
            color: rgba(255, 255, 255, .92);
            font-size: 14px;
            line-height: 1.5;
        }

        .cruw-back-btn {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            color: #1d4ed8 !important;
            background: #fff;
            border-radius: 999px;
            padding: 9px 16px;
            font-size: 13px;
            font-weight: 800;
            text-decoration: none !important;
            box-shadow: 0 10px 22px rgba(15, 23, 42, .14);
        }

        .cruw-card {
            border: 0;
            border-radius: 18px;
            background: #fff;
            box-shadow: 0 10px 30px rgba(15, 23, 42, .08);
            margin-bottom: 20px;
            overflow: hidden;
        }

        .cruw-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 16px 18px;
            background: linear-gradient(180deg, #f8fbff 0%, #eef5ff 100%);
            border-bottom: 1px solid #e5edf8;
        }

        .cruw-section-title {
            margin: 0;
            display: flex;
            align-items: center;
            gap: 9px;
            color: #0f172a;
            font-size: 16px;
            font-weight: 800;
        }

        .cruw-section-title i {
            color: #2563eb;
        }

        .cruw-card-body {
            padding: 18px;
        }

        .cruw-info-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(220px, 1fr));
            gap: 16px;
        }

        .cruw-info-box {
            padding: 13px 14px;
            border: 1px solid #e5edf8;
            border-radius: 14px;
            background: #fbfdff;
        }

        .cruw-info-label {
            display: flex;
            align-items: center;
            gap: 7px;
            margin-bottom: 7px;
            color: #64748b;
            font-size: 12px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: .4px;
        }

        .cruw-info-label i {
            color: #2563eb;
        }

        .cruw-value {
            display: block;
            min-height: 38px;
            width: 100%;
            padding: 9px 11px;
            border-radius: 10px;
            border: 1px solid #e2e8f0;
            background: #fff;
            color: #0f172a;
            font-size: 13px;
            font-weight: 700;
            line-height: 18px;
        }

        #answer_result.cruw-value {
            font-size: 14px;
            color: #1d4ed8;
            background: #eff6ff;
            border-color: #bfdbfe;
        }

        #cruw_ans_table {
            width: 100% !important;
            margin: 0 !important;
        }

        #cruw_ans_table thead th,
        .table.dataTable thead th {
            background: #edf3f6 !important;
            color: #0f172a !important;
            font-size: 12px;
            font-weight: 800;
            white-space: nowrap;
            padding: 12px 10px !important;
            border-bottom: 1px solid #dbe6ee !important;
        }

        #cruw_ans_table tbody td,
        .table.dataTable tbody td {
            background: #fff !important;
            color: #334155;
            font-size: 12px;
            vertical-align: middle;
            padding: 10px !important;
            white-space: nowrap;
        }

        #cruw_ans_table tbody tr:hover td {
            background: #f8fbff !important;
        }

        .dataTables_wrapper .dataTables_filter {
            float: right;
            margin-bottom: 12px;
        }

        .dataTables_wrapper .dataTables_filter input {
            border: 1px solid #dbe6ee;
            border-radius: 10px;
            padding: 6px 10px;
            outline: none;
        }

        .dataTables_length,
        .dataTables_info {
            float: left !important;
            font-size: 12px;
            color: #64748b;
        }

        div.dt-buttons {
            position: static;
            float: left;
            padding-left: 14px;
            margin-bottom: 12px;
        }

        .buttons-excel,
        .buttons-html5 {
            color: #fff !important;
            background: linear-gradient(120deg, #16a34a 0%, #22c55e 100%) !important;
            border: 0 !important;
            border-radius: 10px !important;
            box-shadow: 0 8px 18px rgba(34, 197, 94, .20) !important;
            font-weight: 800 !important;
            padding: 7px 14px !important;
            margin: 0 8px 8px 0 !important;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: 600 !important;
            border: none !important;
        }

        @media (max-width: 992px) {
            .cruw-info-grid {
                grid-template-columns: repeat(2, minmax(220px, 1fr));
            }

            .cruw-title {
                font-size: 24px;
            }
        }

        @media (max-width: 768px) {
            .cruw-hero {
                flex-direction: column;
                align-items: flex-start;
                padding: 22px;
            }

            .cruw-hero-left {
                align-items: flex-start;
            }

            .cruw-info-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            cruw_ans_BindGrid();
            cruw_ans_BindHeader();
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div>One moment, please...</div>
    </div>

    <div class="cruw-page">
        <div class="cruw-hero">
            <div class="cruw-hero-left">
                <span class="cruw-hero-icon">
                    <i class="fas fa-clipboard-check"></i>
                </span>
                <div>
                 <%--   <div class="cruw-kicker">Credit Underwriting Test</div>--%>
                    <h1 class="cruw-title">Answer Sheet</h1>
                    <p class="cruw-subtitle">Review candidate answers, scoring details, and category-wise performance in one place.</p>
                </div>
            </div>

            <div class="cruw-hero-action">
                <a href="#utl" id="aBack" runat="server" class="cruw-back-btn" onclick="window.history.go(-1); return false;">
                    <i class="fas fa-arrow-left"></i> Go Back
                </a>
            </div>
        </div>

        <div class="cruw-card">
            <div class="cruw-card-header">
                <h5 class="cruw-section-title">
                    <i class="fas fa-user-graduate"></i> Exam Details
                </h5>
            </div>
            <div class="cruw-card-body">
                <div class="cruw-info-grid">
                    <div class="cruw-info-box">
                        <div class="cruw-info-label"><i class="fas fa-user"></i> Name</div>
                        <label id="cruw_ans_name" class="cruw-value"></label>
                    </div>

                    <div class="cruw-info-box">
                        <div class="cruw-info-label"><i class="fas fa-calendar-alt"></i> Exam Date</div>
                        <label id="cruw_ans_examdate" class="cruw-value"></label>
                    </div>

                    <div class="cruw-info-box">
                        <div class="cruw-info-label"><i class="fas fa-star"></i> Marks Obtained</div>
                        <label id="cruw_ans_marks" class="cruw-value"></label>
                    </div>

                    <div class="cruw-info-box">
                        <div class="cruw-info-label"><i class="fas fa-university"></i> Credit</div>
                        <label id="cruw_ans_credit" class="cruw-value"></label>
                    </div>

                    <div class="cruw-info-box">
                        <div class="cruw-info-label"><i class="fas fa-shield-alt"></i> Compliance</div>
                        <label id="cruw_ans_compliance" class="cruw-value"></label>
                    </div>

                    <div class="cruw-info-box">
                        <div class="cruw-info-label"><i class="fas fa-home"></i> Collateral</div>
                        <label id="cruw_ans_collateral" class="cruw-value"></label>
                    </div>

                    <div class="cruw-info-box">
                        <div class="cruw-info-label"><i class="fas fa-award"></i> Result</div>
                        <label id="answer_result" class="cruw-value"></label>
                    </div>
                </div>
            </div>
        </div>

        <div class="cruw-card">
            <div class="cruw-card-header">
                <h5 class="cruw-section-title">
                    <i class="fas fa-list-check"></i> Answer Sheet
                </h5>
            </div>
            <div class="cruw-card-body">
                <table class="table table-hover table-bordered nowrap" id="cruw_ans_table">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3">Sr. #</th>
                            <th class="sort border-top ps-3">Question</th>
                            <th class="sort border-top ps-3">Question Type</th>
                            <th class="sort border-top ps-3">Answer by Candidate</th>
                            <th class="sort border-top ps-3">Correct Answer</th>
                            <th class="sort border-top ps-3">Weightage</th>
                            <th class="sort border-top ps-3">Marks</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
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
            cruw_ans_BindGrid();
            cruw_ans_BindHeader();
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Credit Underwriting Test > Answer Sheet</b></h6>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right" style="font-size: 12px; font-weight: bold;">
                        <li class="breadcrumb-item"><a href="#utl" id="aBack" runat="server" style="color: saddlebrown" onclick="window.history.go(-1); return false;"><< Go back </a></li>

                    </ol>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <div class="card card-primary card-outline">
                    <div class="card-header">
                        <div class="card-title">
                            <i class="fas fa-edit"></i>
                            Exam Details:
                        </div>
                    </div>
                    <table class="table">
                        <tr>
                            <td><b>Name:</b></td>
                            <td>
                                <label id="cruw_ans_name" class="form-control" style="width: 300px;"></label>
                            </td>
                            <td><b>Exam Date:</b></td>
                            <td>
                                <label id="cruw_ans_examdate" class="form-control" style="width: 300px;"></label>
                            </td>
                            <td><b>Marks Obtained:</b></td>
                            <td>
                                <label id="cruw_ans_marks" class="form-control" style="width: 300px;"></label>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Credit:</b></td>
                            <td>
                                <label id="cruw_ans_credit" class="form-control" style="width: 300px;"></label>
                            </td>
                            <td><b>Compliance:</b></td>
                            <td>
                                <label id="cruw_ans_compliance" class="form-control" style="width: 300px;"></label>
                            </td>
                            <td><b>Collateral:</b></td>
                            <td>
                                <label id="cruw_ans_collateral" class="form-control" style="width: 300px;"></label>
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td></td>
                            <td><b style="font-size:14px;">Result:</b></td>
                            <td>
                                <label id="answer_result" class="form-control" style="width: 300px; font-size:14px;"></label>
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                    </table>
                </div>
                <div class="card card-primary card-outline">
                    <div class="card-header">
                        <div class="card-title">
                            <i class="fas fa-edit"></i>
                            Answer Sheet:
                        </div>
                    </div>
                    <table class="table" id="cruw_ans_table" style="width: 100%;">
                        <thead>
                            <tr>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Question</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Question Type</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Answer by Candidate</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Correct Answer</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Weightage</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Marks</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>--%>
