<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="POSHQuestionMaster.aspx.cs" Inherits="WebPortal.Admin.POSHQuestionMaster" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        :root {
            --posh-primary: #1d4ed8;
            --posh-primary-2: #2563eb;
            --posh-accent: #22c1dc;
            --posh-bg: #f4f7fb;
            --posh-card: #ffffff;
            --posh-border: #dbe5f1;
            --posh-text: #0f172a;
            --posh-muted: #64748b;
            --posh-soft: #eef6ff;
        }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            margin: auto;
            width: 192px;
            height: 192px;
            opacity: .9;
            border-radius: 25px;
            z-index: 99999;
            text-align: center;
            background: rgba(255,255,255,.85);
            box-shadow: 0 20px 45px rgba(15, 23, 42, .18);
            padding-top: 28px;
        }

        .posh-page {
            background: var(--posh-bg);
          
        }

        .posh-hero {
            position: relative;
            overflow: hidden;
            border-radius: 22px;
            padding: 20px 22px;
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 62%, #22c1dc 100%);
            box-shadow: 0 18px 38px rgba(37, 99, 235, .24);
            margin-bottom: 18px;
        }

        .posh-hero:before,
        .posh-hero:after {
            content: "";
            position: absolute;
            border-radius: 999px;
            background: rgba(255,255,255,.15);
        }

        .posh-hero:before {
            width: 230px;
            height: 230px;
            top: -120px;
            right: -80px;
        }

        .posh-hero:after {
            width: 140px;
            height: 140px;
            bottom: -70px;
            left: 34%;
        }

        .posh-hero-inner {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            flex-wrap: wrap;
        }

        .posh-title-wrap {
            display: flex;
            align-items: center;
            gap: 15px;
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

        .posh-hero h3 {
            margin: 0;
            font-size: 21px;
            font-weight: 800;
            letter-spacing: .2px;
        }

        .posh-hero p {
            margin: 4px 0 0;
            color: rgba(255,255,255,.88);
            font-size: 12px;
        }

        .posh-chip {
            padding: 9px 15px;
            border-radius: 999px;
            background: rgba(255,255,255,.16);
            color: #fff;
            font-weight: 700;
            font-size: 12px;
            border: 1px solid rgba(255,255,255,.22);
        }

        .posh-card {
            background: var(--posh-card);
            border: 1px solid var(--posh-border);
            border-radius: 20px;
            box-shadow: 0 10px 28px rgba(15, 23, 42, .07);
            margin-bottom: 18px;
            overflow: hidden;
        }

        .posh-card-header {
            padding: 17px 20px;
            border-bottom: 1px solid #edf2f7;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            flex-wrap: wrap;
            background: linear-gradient(180deg, #ffffff 0%, #f8fbff 100%);
        }

        .posh-section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 800;
            color: var(--posh-text);
            margin: 0;
            font-size: 16px;
        }

        .posh-section-title i {
            width: 34px;
            height: 34px;
            border-radius: 12px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            background: linear-gradient(135deg, var(--posh-primary-2), var(--posh-accent));
        }

        .posh-card-body {
            padding: 22px;
        }

        .posh-field {
            margin-bottom: 16px;
        }

        .posh-field label {
            display: block;
            margin-bottom: 7px;
            color: #334155;
            font-size: 13px;
            font-weight: 700 !important;
            border: none !important;
        }

        .posh-field .form-control {
            width: 100% !important;
            min-height: 42px;
            border-radius: 12px;
            border: 1px solid #d7e0ea;
            background: #fff;
            box-shadow: none;
            transition: .2s ease;
            font-size: 13px;
        }

        .posh-field textarea.form-control {
            min-height: 96px;
            resize: vertical;
        }

        .posh-field .form-control:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37,99,235,.10);
        }

        .posh-option-box {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            background: #fbfdff;
            transition: .2s ease;
        }

        .posh-option-box:hover {
            border-color: #bfdbfe;
            background: #f8fbff;
        }

        .posh-option-box .form-control {
            flex: 1;
            display: block !important;
        }

        .posh-answer-check {
            position: relative;
            min-width: 94px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            padding: 9px 10px;
            border-radius: 999px;
            background: #eef6ff;
            color: #2563eb;
            font-size: 12px;
            font-weight: 800;
            cursor: pointer;
            border: 1px solid #cfe4ff;
        }

        .posh-answer-check input {
            margin: 0;
            width: 16px;
            height: 16px;
            accent-color: #2563eb;
        }

        .posh-actions {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
            padding-top: 4px;
        }

        #posh_btnsubmit,
        #posh_btnMessage {
            border: 0;
            border-radius: 12px;
            padding: 11px 26px;
            font-weight: 800;
            color: #fff;
            background: linear-gradient(135deg, #2563eb, #22c1dc);
            box-shadow: 0 10px 22px rgba(37,99,235,.24);
            transition: .2s ease;
        }

        #posh_btnsubmit:hover,
        #posh_btnMessage:hover {
            transform: translateY(-2px);
            box-shadow: 0 14px 26px rgba(37,99,235,.32);
            color: #fff;
        }

        .posh-hint {
            color: var(--posh-muted);
            font-size: 12px;
            margin: 0;
        }

        .posh-grid-wrap {
            width: 100%;
            overflow-x: auto;
            padding: 4px;
        }

        #table_posh {
            width: 100% !important;
            border-collapse: separate !important;
            border-spacing: 0;
            margin: 0 !important;
            font-size: 13px;
        }

        #table_posh thead th,
        .table.dataTable th {
            background: #edf3f6 !important;
            color: #0f172a !important;
            font-weight: 800 !important;
            height: 42px;
            vertical-align: middle !important;
            border-bottom: 1px solid #dbe5f1 !important;
            white-space: nowrap;
        }

        #table_posh tbody td,
        .table.dataTable tr td {
            background: #fff !important;
            vertical-align: middle !important;
            border-bottom: 1px solid #edf2f7 !important;
        }

        #table_posh tbody tr:hover td {
            background: #f8fbff !important;
        }

        .dataTables_wrapper .dataTables_filter input,
        .dataTables_wrapper .dataTables_length select {
            border: 1px solid #d7e0ea;
            border-radius: 10px;
            padding: 6px 10px;
            outline: none;
        }

        .dataTables_scrollBody {
            min-height: 100px !important;
            height: auto;
        }

        .dataTables_length, .dataTables_info {
            float: left !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 20px;
            float: left;
        }

        .buttons-excel, .buttons-html5 {
            color: #fff !important;
            box-shadow: none;
            background: linear-gradient(135deg, #2563eb, #22c1dc) !important;
            border: 0 !important;
            font-weight: 800;
            border-radius: 10px !important;
            margin: 0 8px;
            padding: 7px 14px !important;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: normal !important;
            border: none !important;
        }

        .posh-modal .modal-content {
            border: 0;
            border-radius: 18px;
            box-shadow: 0 20px 45px rgba(15,23,42,.25);
            overflow: hidden;
        }

        .posh-modal .modal-header {
            background: linear-gradient(135deg, #2563eb, #22c1dc);
            color: #fff;
            border: 0;
        }

        .posh-modal .modal-footer {
            border: 0;
            justify-content: center;
        }

        @media (max-width: 768px) {
            .posh-page {
                padding: 12px 8px 24px;
            }

            .posh-hero {
                padding: 20px;
                border-radius: 18px;
            }

            .posh-hero h3 {
                font-size: 20px;
            }

            .posh-card-body {
                padding: 16px;
            }

            .posh-option-box {
                align-items: stretch;
                flex-direction: column;
            }

            .posh-answer-check {
                width: 100%;
            }

            .posh-actions {
                justify-content: stretch;
            }

            #posh_btnsubmit {
                width: 100%;
            }
        }
    </style>
    <script>
        $(document).ready(function () {
            posh_BindGrid();
            posh_bindSection();
        });
    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold; margin-top: 8px;">One moment, please . . . .</div>
    </div>

    <div class="posh-page">
        <div class="posh-hero">
            <div class="posh-hero-inner">
                <div class="posh-title-wrap">
                    <div class="posh-hero-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <div>
                        <h3>POSH Question Master</h3>
                        <p>Manage POSH test questions, sections, answer options and weightage.</p>
                    </div>
                </div>
                <div class="posh-chip">
                    <i class="fas fa-clipboard-check"></i>&nbsp; Question Configuration
                </div>
            </div>
        </div>

        <div class="posh-card">
            <div class="posh-card-header">
                <h4 class="posh-section-title">
                    <i class="fas fa-edit"></i>
                    Question Details
                </h4>
                <p class="posh-hint">Select the correct answer using the checkbox beside each option.</p>
            </div>

            <div class="posh-card-body">
                <div class="row">
                    <div class="col-lg-12">
                        <div class="posh-field">
                            <label for="posh_question">Question</label>
                            <textarea id="posh_question" name="posh_question" class="form-control" placeholder="Enter POSH question"></textarea>
                        </div>
                    </div>

                    <div class="col-lg-6 col-md-6">
                        <div class="posh-field">
                            <label for="posh_section">Section</label>
                            <select id="posh_section" name="posh_section" class="form-control">
                                <option value="Select">Select</option>
                            </select>
                        </div>
                    </div>

                    <div class="col-lg-6 col-md-6">
                        <div class="posh-field">
                            <label for="posh_marks">Marks</label>
                            <input type="number" id="posh_marks" name="posh_marks" class="form-control" placeholder="Enter marks" />
                        </div>
                    </div>

                    <div class="col-lg-6 col-md-6">
                        <div class="posh-field">
                            <label for="posh_option1">Option 1</label>
                            <div class="posh-option-box">
                                <input type="text" id="posh_option1" name="posh_option1" class="form-control" placeholder="Enter option 1" />
                                <label class="posh-answer-check" for="posh_A_option1">
                                    <input type="checkbox" class="custom-checkbox" id="posh_A_option1" />
                                    Correct
                                </label>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-6 col-md-6">
                        <div class="posh-field">
                            <label for="posh_option2">Option 2</label>
                            <div class="posh-option-box">
                                <input type="text" id="posh_option2" name="posh_option2" class="form-control" placeholder="Enter option 2" />
                                <label class="posh-answer-check" for="posh_A_option2">
                                    <input type="checkbox" class="custom-checkbox" id="posh_A_option2" />
                                    Correct
                                </label>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-6 col-md-6">
                        <div class="posh-field">
                            <label for="posh_option3">Option 3</label>
                            <div class="posh-option-box">
                                <input type="text" id="posh_option3" name="posh_option3" class="form-control" placeholder="Enter option 3" />
                                <label class="posh-answer-check" for="posh_A_option3">
                                    <input type="checkbox" class="custom-checkbox" id="posh_A_option3" />
                                    Correct
                                </label>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-6 col-md-6">
                        <div class="posh-field">
                            <label for="posh_option4">Option 4</label>
                            <div class="posh-option-box">
                                <input type="text" id="posh_option4" name="posh_option4" class="form-control" placeholder="Enter option 4" />
                                <label class="posh-answer-check" for="posh_A_option4">
                                    <input type="checkbox" class="custom-checkbox" id="posh_A_option4" />
                                    Correct
                                </label>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-12">
                        <div class="posh-actions">
                            <button id="posh_btnsubmit" class="btn btn-primary" onclick="return posh_Questionsubmit();">
                                <i class="fas fa-save"></i>&nbsp; Submit
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="posh-card">
            <div class="posh-card-header">
                <h4 class="posh-section-title">
                    <i class="fas fa-list-ul"></i>
                    POSH Question List
                </h4>
                <p class="posh-hint">Review existing POSH questions and answer configuration.</p>
            </div>

            <div class="posh-card-body">
                <div class="posh-grid-wrap">
                    <table class="table" id="table_posh" style="width: 100%;">
                        <thead>
                            <tr>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Section</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Question</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align:center;">Weightage</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Option 1</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Option 2</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Option 3</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Option 4</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Answer</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added By</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added Date</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade posh-modal" id="posh_dverror">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="posh_errmsg"></h6>
                </div>
                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="posh_btnMessage" onclick="return posh_Message();">Okay</button>
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
            posh_BindGrid();
            posh_bindSection();
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>POSH Question Master</b></h6>
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
                        <td><b>Question:</b></td>
                        <td colspan="3">
                            <textarea id="posh_question" name="posh_question" class="form-control" style="width: 600px;"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Section:</b></td>
                        <td>
                            <select id="posh_section" name="posh_section" class="form-control" style="width: 300px;">
                                <option value="Select">Select</option>
                            </select>
                        </td>
                        <td><b>Marks:</b></td>
                        <td>
                            <input type="number" id="posh_marks" name="posh_marks" class="form-control" style="width: 300px;" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Option 1:</b></td>
                        <td>
                            <input type="text" id="posh_option1" name="posh_option1" class="form-control" style="width: 300px; display: inline;" />
                            <input type="checkbox" class="custom-checkbox" id="posh_A_option1" />
                        </td>
                        <td><b>Option 2:</b></td>
                        <td>
                            <input type="text" id="posh_option2" name="posh_option2" class="form-control" style="width: 300px; display: inline;" />
                            <input type="checkbox" class="custom-checkbox" id="posh_A_option2" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Option 3:</b></td>
                        <td>
                            <input type="text" id="posh_option3" name="posh_option3" class="form-control" style="width: 300px; display: inline;" />
                            <input type="checkbox" class="custom-checkbox" id="posh_A_option3" />
                        </td>
                        <td><b>Option 4:</b></td>
                        <td>
                            <input type="text" id="posh_option4" name="posh_option4" class="form-control" style="width: 300px; display: inline;" />
                            <input type="checkbox" class="custom-checkbox" id="posh_A_option4" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4" style="text-align: center;">
                            <button id="posh_btnsubmit" class="btn btn-primary" onclick="return posh_Questionsubmit();">Submit</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <table class="table" id="table_posh" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Section</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Question</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align:center;">Weightage</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Option 1</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Option 2</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Option 3</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Option 4</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Answer</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added By</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added Date</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

     <div class="modal fade" id="posh_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="posh_errmsg"></h6>
                </div>
                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="posh_btnMessage" onclick="return posh_Message();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>--%>
