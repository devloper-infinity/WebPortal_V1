<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="POSHAnswerSheet.aspx.cs" Inherits="WebPortal.Admin.POSHAnswerSheet" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --posh-primary: #1d4ed8;
            --posh-secondary: #22c1dc;
            --posh-bg: #f3f7fb;
            --posh-border: #dbe7f3;
            --posh-text: #0f172a;
            --posh-muted: #64748b;
            --posh-success: #16a34a;
            --posh-danger: #dc2626;
        }

        body {
            background: var(--posh-bg);
        }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            margin: auto;
            width: 190px;
            height: 150px;
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 20px 45px rgba(15, 23, 42, .18);
            z-index: 99999;
            text-align: center;
            padding: 22px;
        }

        .loading img {
            width: 58px;
            height: 58px;
            object-fit: contain;
        }

        .loading div {
            margin-top: 12px;
            font-size: 12px;
            font-weight: 700;
            color: var(--posh-text);
        }

        .posh-hero {
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%);
            border-radius: 22px;
            padding: 22px 24px;
            color: #fff;
            box-shadow: 0 14px 35px rgba(37, 99, 235, .24);
            margin-bottom: 18px;
            position: relative;
            overflow: hidden;
        }

        .posh-hero:before {
            content: "";
            position: absolute;
            right: -65px;
            top: -90px;
            width: 230px;
            height: 230px;
            border-radius: 50%;
            background: rgba(255,255,255,.16);
        }

        .posh-hero-content {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            position: relative;
            z-index: 1;
        }

        .posh-hero-left {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .posh-hero-icon {
            width: 58px;
            height: 58px;
            border-radius: 18px;
            background: rgba(255,255,255,.18);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 26px;
            box-shadow: inset 0 0 0 1px rgba(255,255,255,.25);
        }

        .posh-hero h4 {
            margin: 0;
            font-weight: 800;
            letter-spacing: .2px;
        }

        .posh-hero p {
            margin: 4px 0 0;
            color: rgba(255,255,255,.86);
            font-size: 13px;
        }

        .posh-back {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(255,255,255,.16);
            color: #fff !important;
            border: 1px solid rgba(255,255,255,.28);
            border-radius: 999px;
            padding: 9px 15px;
            font-size: 12px;
            font-weight: 700;
            text-decoration: none !important;
            transition: .25s;
            white-space: nowrap;
        }

        .posh-back:hover {
            background: #fff;
            color: var(--posh-primary) !important;
            transform: translateY(-2px);
        }

        .posh-card {
            background: #fff;
            border: 1px solid var(--posh-border);
            border-radius: 20px;
            box-shadow: 0 12px 30px rgba(15, 23, 42, .06);
            margin-bottom: 18px;
            overflow: hidden;
        }

        .posh-card-header {
            min-height: 58px;
            padding: 15px 20px;
            background: linear-gradient(180deg, #ffffff, #f8fbff);
            border-bottom: 1px solid var(--posh-border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
        }

        .posh-card-title {
            display: flex;
            align-items: center;
            gap: 10px;
            color: var(--posh-text);
            font-weight: 800;
            margin: 0;
        }

        .posh-card-title i {
            color: var(--posh-primary);
            font-size: 17px;
        }

        .posh-card-body {
            padding: 20px;
        }

        .exam-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 14px;
        }

        .exam-info-box {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            padding: 14px;
            min-height: 78px;
            transition: .25s;
        }

        .exam-info-box:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 25px rgba(15,23,42,.08);
            border-color: #bfdbfe;
        }

        .exam-info-box span {
            display: block;
            color: var(--posh-muted);
            font-size: 11px;
            text-transform: uppercase;
            font-weight: 800;
            letter-spacing: .5px;
            margin-bottom: 8px;
        }

        .exam-info-box label {
            display: block;
            margin: 0;
            width: 100% !important;
            min-height: 24px;
            border: 0 !important;
            background: transparent !important;
            padding: 0 !important;
            box-shadow: none !important;
            color: var(--posh-text);
            font-weight: 800 !important;
            font-size: 13px;
        }

        #posh_answer_result {
            font-size: 15px !important;
        }

        .answer-table-wrap {
            width: 100%;
            overflow-x: auto;
        }

        #table_posh_ans {
            width: 100% !important;
            border-collapse: separate !important;
            border-spacing: 0;
            margin: 0 !important;
        }

        #table_posh_ans thead th {
            background: #edf3f6 !important;
            color: #0f172a !important;
            font-weight: 800;
            font-size: 12px;
            border-bottom: 1px solid #dbe7f3 !important;
            white-space: nowrap;
            vertical-align: middle;
        }

        #table_posh_ans tbody td {
            background: #fff !important;
            color: #1f2937;
            font-size: 12px;
            padding: 11px 10px !important;
            border-bottom: 1px solid #eef2f7 !important;
            vertical-align: top;
        }

        #table_posh_ans tbody tr:hover td {
            background: #f8fbff !important;
        }

        #table_posh_ans tfoot td {
            background: #f8fafc !important;
            border-top: 2px solid #dbe7f3 !important;
            font-weight: 800;
            color: var(--posh-text);
            padding: 12px 10px !important;
        }

        .dataTables_wrapper {
            font-size: 12px;
        }

        .dataTables_length,
        .dataTables_info {
            float: left !important;
            color: var(--posh-muted);
            font-weight: 600;
        }

        div.dt-buttons {
            position: static;
            padding-left: 14px;
            float: left;
        }

        .buttons-excel,
        .buttons-html5 {
            color: #fff !important;
            background: linear-gradient(135deg, #1d4ed8, #22c1dc) !important;
            border: 0 !important;
            border-radius: 10px !important;
            font-weight: 800 !important;
            box-shadow: 0 10px 20px rgba(37,99,235,.18) !important;
            margin: 0 6px !important;
            padding: 7px 14px !important;
        }

        .dataTables_filter input,
        .dataTables_length select {
            border: 1px solid #cbd5e1 !important;
            border-radius: 10px !important;
            padding: 6px 10px !important;
            outline: none !important;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: 600 !important;
            border: none !important;
        }

        @media (max-width: 991px) {
            .exam-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .posh-hero-content {
                align-items: flex-start;
                flex-direction: column;
            }
        }

        @media (max-width: 575px) {
            .posh-page {
                padding: 10px;
            }

            .exam-grid {
                grid-template-columns: 1fr;
            }

            .posh-hero {
                padding: 18px;
                border-radius: 18px;
            }

            .posh-hero-icon {
                width: 48px;
                height: 48px;
                font-size: 22px;
            }

            .posh-hero h4 {
                font-size: 18px;
            }

            .posh-card-body {
                padding: 14px;
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            posh_ans_BindGrid();
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div>One moment, please . . . .</div>
    </div>

    <div class="posh-page">

        <div class="posh-hero">
            <div class="posh-hero-content">
                <div class="posh-hero-left">
                    <div class="posh-hero-icon">
                        <i class="fas fa-file-signature"></i>
                    </div>
                    <div>
                        <h4>POSH Answer Sheet</h4>
                        <p>Review employee POSH test answers, marks and result details.</p>
                    </div>
                </div>

                <a href="#utl" id="aBack" runat="server" class="posh-back" onclick="window.history.go(-1); return false;">
                    <span>Go Back</span>
                </a>
            </div>
        </div>

        <div class="posh-card">
            <div class="posh-card-header">
                <h6 class="posh-card-title">
                    <i class="fas fa-user-graduate"></i>
                    Exam Details
                </h6>
            </div>

            <div class="posh-card-body">
                <div class="exam-grid">
                    <div class="exam-info-box">
                        <span>Employee Name</span>
                        <label id="posh_ans_name"></label>
                    </div>

                    <div class="exam-info-box">
                        <span>Exam Date</span>
                        <label id="posh_ans_examdate"></label>
                    </div>

                    <div class="exam-info-box">
                        <span>Total Marks</span>
                        <label id="posh_ans_marks"></label>
                    </div>

                    <div class="exam-info-box">
                        <span>Result</span>
                        <label id="posh_answer_result"></label>
                    </div>
                </div>
            </div>
        </div>

        <div class="posh-card">
            <div class="posh-card-header">
                <h6 class="posh-card-title">
                    <i class="fas fa-clipboard-check"></i>
                    Answer Sheet
                </h6>
            </div>

            <div class="posh-card-body">
                <div class="answer-table-wrap">
                    <table class="table table-hover" id="table_posh_ans" style="width: 100%;">
                        <thead>
                            <tr>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Section</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Question</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Answer by Employee</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Correct Answer</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Weightage</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Marks</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                        <tfoot>
                            <tr>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td style="font-weight: bold; font-size: 13px;"></td>
                                <td style="font-weight: bold; font-size: 13px;"></td>
                            </tr>
                        </tfoot>
                    </table>
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

            posh_ans_BindGrid();

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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>POSH Answer Sheet</b></h6>
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
                            <td>
                                <label id="posh_ans_name" class="form-control" style="width: 300px;"></label>
                            </td>
                            <td>
                                <label id="posh_ans_examdate" class="form-control" style="width: 200px;"></label>
                            </td>
                            <td>
                                <label id="posh_ans_marks" class="form-control" style="width: 200px;"></label>
                            </td>
                            <td>
                                <label id="posh_answer_result" class="form-control" style="font-weight: bold; font-size: 14px;"></label>
                            </td>
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
                    <table class="table" id="table_posh_ans" style="width: 100%;">
                        <thead>
                            <tr>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Section</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Question</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Answer by Employee</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Correct Answer</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Weightage</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Marks</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                        <tfoot>
                            <tr>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td style="font-weight: bold; font-size: 13px;"></td>
                                <td style="font-weight: bold; font-size: 13px;"></td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>--%>
