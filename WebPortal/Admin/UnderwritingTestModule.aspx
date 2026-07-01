<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="UnderwritingTestModule.aspx.cs" Inherits="WebPortal.Admin.UnderwritingTestModule" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .uw-page-wrap {
       /*     padding: 16px 18px 28px;*/
            background: #f4f7fb;
        }

        .uw-loader {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 99999;
            background: rgba(255, 255, 255, .72);
            backdrop-filter: blur(2px);
            align-items: center;
            justify-content: center;
            text-align: center;
        }

        .uw-loader-box {
            width: 170px;
            padding: 22px 18px;
            border-radius: 18px;
            background: #fff;
            box-shadow: 0 18px 45px rgba(15, 23, 42, .18);
            color: #334155;
            font-size: 13px;
            font-weight: 700;
        }

        .uw-loader-box img {
            width: 60px;
            height: 60px;
            display: block;
            margin: 0 auto 10px;
        }

        .uw-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            gap: 22px;
            padding: 20px 25px;
            margin-bottom: 20px;
            border-radius: 20px;
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 55%, #22c1dc 100%);
            box-shadow: 0 14px 34px rgba(37, 99, 235, .25);
        }

        .uw-hero::before {
            content: "";
            position: absolute;
            top: -110px;
            right: -70px;
            width: 310px;
            height: 310px;
            border-radius: 50%;
            background: rgba(255, 255, 255, .16);
        }

        .uw-hero::after {
            content: "";
            position: absolute;
            left: -80px;
            bottom: -125px;
            width: 390px;
            height: 260px;
            border-radius: 50%;
            background: rgba(255, 255, 255, .10);
        }

        .uw-hero-icon {
            position: relative;
            z-index: 2;
            width: 60px;
            height: 60px;
            min-width: 60px;
            border-radius: 22px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255, 255, 255, .16);
            border: 1px solid rgba(255, 255, 255, .35);
            box-shadow: inset 0 1px 0 rgba(255, 255, 255, .25);
        }

        .uw-hero-icon i {
            font-size: 30px;
            color: #fff;
        }

        .uw-hero-copy {
            position: relative;
            z-index: 2;
        }

        .uw-kicker {
            font-size: 12px;
            font-weight: 800;
            letter-spacing: 2px;
            text-transform: uppercase;
            opacity: .92;
            margin-bottom: 5px;
        }

        .uw-title {
            margin: 0;
            color: #fff;
            font-size: 31px;
            line-height: 1.15;
            font-weight: 800;
        }

        .uw-subtitle {
            margin: 9px 0 0;
            max-width: 900px;
            color: rgba(255, 255, 255, .93);
            font-size: 13px;
            line-height: 1.55;
        }

        .uw-panel {
            border: 0;
            border-radius: 18px;
            background: #fff;
            box-shadow: 0 10px 30px rgba(15, 23, 42, .08);
            overflow: hidden;
        }

        .uw-panel-body {
            padding: 18px;
        }

        .uw-main-tabs,
        .uw-sub-tabs {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            padding: 12px;
            margin: 0 0 16px;
            border: 1px solid #e5e7eb;
            border-radius: 16px;
            background: #f8fafc;
            list-style: none;
        }

        .uw-main-tabs .nav-link,
        .uw-sub-tabs .nav-link {
            border: 0 !important;
            border-radius: 12px !important;
            color: #475569;
            font-weight: 700;
            padding: 9px 16px;
            background: transparent;
        }

        .uw-main-tabs .nav-link.active,
        .uw-sub-tabs .nav-link.active {
            color: #fff !important;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%) !important;
            box-shadow: 0 8px 18px rgba(37, 99, 235, .25);
        }

        .uw-section-card {
            border: 1px solid #e5e7eb;
            border-radius: 16px;
            background: #fff;
            margin-bottom: 18px;
            overflow: hidden;
        }

        .uw-section-head {
            display: flex;
            align-items: center;
            gap: 11px;
            padding: 14px 18px;
            background: #f8fafc;
            border-bottom: 1px solid #e5e7eb;
        }

        .uw-section-head i {
            width: 34px;
            height: 34px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8 0%, #22c1dc 100%);
        }

        .uw-section-head h5 {
            margin: 0;
            font-size: 15px;
            color: #0f172a;
            font-weight: 800;
        }

        .uw-form-grid {
            display: grid;
            grid-template-columns: repeat(12, 1fr);
            gap: 14px;
            padding: 18px;
        }

        .uw-field {
            grid-column: span 4;
        }

        .uw-field-lg {
            grid-column: span 12;
        }

        .uw-field label {
            display: block;
            margin-bottom: 6px;
            color: #334155;
            font-size: 13px;
            font-weight: 800 !important;
            border: 0 !important;
        }

        .uw-field .form-control {
            height: 38px;
            border-radius: 10px;
            border: 1px solid #dbe3ef;
            box-shadow: none;
            font-size: 13px;
        }

        .uw-field textarea.form-control {
            height: 84px;
            resize: vertical;
        }

        .uw-option-wrap {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .uw-option-wrap .form-control {
            flex: 1;
        }

        .uw-answer-check {
            width: 19px;
            height: 19px;
            accent-color: #2563eb;
        }

        .uw-action-row {
            grid-column: span 12;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            padding-top: 4px;
        }

        .uw-filter-row {
            display: grid;
            grid-template-columns: repeat(12, 1fr);
            gap: 14px;
            padding: 18px;
            align-items: end;
        }

        .uw-filter-row .uw-field {
            grid-column: span 3;
        }

        .uw-filter-row .uw-action-row {
            grid-column: span 6;
            justify-content: flex-start;
            padding-top: 0;
        }

        .uw-btn-primary,
        .uw-btn-secondary {
            border: 0;
            border-radius: 11px;
            padding: 8px 16px;
            font-size: 13px;
            font-weight: 800;
            color: #fff !important;
            box-shadow: 0 8px 18px rgba(37, 99, 235, .18);
        }

        .uw-btn-primary {
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%);
        }

        .uw-btn-secondary {
            background: linear-gradient(120deg, #64748b 0%, #475569 100%);
        }

        .uw-table-card {
            padding: 14px;
            border-top: 1px solid #e5e7eb;
            background: #fff;
        }

        .uw-table-card .table {
            width: 100% !important;
            margin-bottom: 0;
        }

        .uw-table-card .table th,
        .uw-table-card .table td {
            white-space: nowrap;
            vertical-align: middle;
            font-size: 13px;
        }

        .uw-table-card .table thead th {
            background: #edf3f6 !important;
            color: #0f172a !important;
            font-weight: 800;
            border-color: #dce6ee !important;
            height: 42px;
        }

        .uw-table-card .table tbody td {
            background: #fff !important;
        }

        .uw-table-card .table tbody tr:hover td {
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
            background: linear-gradient(120deg, #16a34a 0%, #22c55e 100%) !important;
            border: 0 !important;
            border-radius: 10px !important;
            font-weight: 800 !important;
            box-shadow: none !important;
            margin: 0 8px !important;
            padding: 7px 14px !important;
        }

        .modal-content {
            border: 0;
            border-radius: 16px;
            overflow: hidden;
        }

        .modal-header {
            background: linear-gradient(120deg, #1d4ed8 0%, #22c1dc 100%);
            color: #fff;
        }

        .modal-title {
            color: #fff;
            font-weight: 800;
        }

        @media (max-width: 991px) {
            .uw-field,
            .uw-filter-row .uw-field,
            .uw-filter-row .uw-action-row {
                grid-column: span 12;
            }

            .uw-hero {
                align-items: flex-start;
                padding: 22px;
            }

            .uw-title {
                font-size: 24px;
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            cruw_BindGrid();
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input type="text" id="emailappidser" name="emailappidser" style="display:none;" />
    <input type="text" id="emailappid" name="emailappid" style="display:none;" />

    <asp:Button ID="Button1" runat="server" OnClick="btnMail_Click" Style="display: none;" />
    <asp:Button ID="btnMailSer" runat="server" OnClick="btnMailSer_Click" Style="display: none;" />

    <div class="uw-loader" id="load1">
        <div class="uw-loader-box">
            <img src="../images/Load_1.gif" />
            One moment, please...
        </div>
    </div>

    <div class="uw-page-wrap">
        <div class="uw-hero">
            <div class="uw-hero-icon">
                <i class="fas fa-clipboard-check"></i>
            </div>
            <div class="uw-hero-copy">
               <%-- <div class="uw-kicker">Assessment Module</div>--%>
                <h1 class="uw-title">Underwriting Test</h1>
                <p class="uw-subtitle">Create question sets, review answer papers, and send test links for Credit and Servicing underwriting assessments.</p>
            </div>
        </div>

        <div class="uw-panel">
            <div class="uw-panel-body">
                <ul class="nav nav-tabs uw-main-tabs" id="custom-tabs-one-tab" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">
                            <i class="fas fa-file-invoice mr-1"></i> Credit
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" id="custom-tabs-one-profile-tab" onclick="return getServicingDetails();" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">
                            <i class="fas fa-headset mr-1"></i> Servicing
                        </a>
                    </li>
                </ul>

                <div class="tab-content" id="custom-tabs-one-tabContent">
                    <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                        <ul class="nav nav-tabs uw-sub-tabs" id="custom-tabs-one-tab-sub" role="tablist">
                            <li class="nav-item"><a class="nav-link active" id="custom-tabs-one-home-tab-sub" data-toggle="pill" href="#custom-tabs-one-home-sub" role="tab" aria-controls="custom-tabs-one-home-sub" aria-selected="true"><i class="fas fa-list-check mr-1"></i> Question Set</a></li>
                            <li class="nav-item"><a class="nav-link" id="custom-tabs-one-profile-tab-sub" data-toggle="pill" href="#custom-tabs-one-profile-sub" role="tab" aria-controls="custom-tabs-one-profile-sub" aria-selected="false"><i class="fas fa-clipboard-list mr-1"></i> Check Question Paper</a></li>
                            <li class="nav-item"><a class="nav-link" id="custom-tabs-one-messages-tab-sub" data-toggle="pill" href="#custom-tabs-one-messages-sub" role="tab" aria-controls="custom-tabs-one-messages-sub" aria-selected="false"><i class="fas fa-paper-plane mr-1"></i> Send Test Link</a></li>
                        </ul>

                        <div class="tab-content" id="custom-tabs-one-tabContent-sub">
                            <div class="tab-pane fade show active" id="custom-tabs-one-home-sub" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab-sub">
                                <div class="uw-section-card">
                                    <div class="uw-section-head"><i class="fas fa-question-circle"></i><h5>Credit Question Details</h5></div>
                                    <div class="uw-form-grid">
                                        <div class="uw-field uw-field-lg">
                                            <label>Question</label>
                                            <textarea id="cruw_question" name="cruw_question" class="form-control" placeholder="Enter question"></textarea>
                                        </div>
                                        <div class="uw-field">
                                            <label>Question Type</label>
                                            <select id="cruw_questiontype" name="cruw_questiontype" class="form-control">
                                                <option value="">Select</option>
                                                <option value="Credit">Credit</option>
                                                <option value="Compliance">Compliance</option>
                                                <option value="Collateral">Collateral</option>
                                            </select>
                                        </div>
                                        <div class="uw-field">
                                            <label>Marks</label>
                                            <input type="number" id="cruw_marks" name="cruw_marks" class="form-control" placeholder="Enter marks" />
                                        </div>
                                        <div class="uw-field"></div>

                                        <div class="uw-field">
                                            <label>Option 1</label>
                                            <div class="uw-option-wrap"><input type="text" id="cruw_option1" name="cruw_option1" class="form-control" /><input type="checkbox" class="uw-answer-check custom-checkbox" id="cruw_A_option1" title="Correct Answer" /></div>
                                        </div>
                                        <div class="uw-field">
                                            <label>Option 2</label>
                                            <div class="uw-option-wrap"><input type="text" id="cruw_option2" name="cruw_option2" class="form-control" /><input type="checkbox" class="uw-answer-check custom-checkbox" id="cruw_A_option2" title="Correct Answer" /></div>
                                        </div>
                                        <div class="uw-field">
                                            <label>Option 3</label>
                                            <div class="uw-option-wrap"><input type="text" id="cruw_option3" name="cruw_option3" class="form-control" /><input type="checkbox" class="uw-answer-check custom-checkbox" id="cruw_A_option3" title="Correct Answer" /></div>
                                        </div>
                                        <div class="uw-field">
                                            <label>Option 4</label>
                                            <div class="uw-option-wrap"><input type="text" id="cruw_option4" name="cruw_option4" class="form-control" /><input type="checkbox" class="uw-answer-check custom-checkbox" id="cruw_A_option4" title="Correct Answer" /></div>
                                        </div>
                                        <div class="uw-action-row">
                                            <button id="cruw_btnsubmit" class="uw-btn-primary btn" onclick="return cruw_submit();"><i class="fas fa-save mr-1"></i> Submit</button>
                                        </div>
                                    </div>
                                    <div class="uw-table-card">
                                        <table class="table table-hover table-bordered nowrap" id="cruw_table">
                                            <thead><tr>
                                                <th>Sr. #</th><th>Question</th><th>Question Type</th><th>Marks</th><th>Option 1</th><th>Option 2</th><th>Option 3</th><th>Option 4</th><th>Answer</th><th>Added By</th><th>Added Date</th>
                                            </tr></thead><tbody></tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                            <div class="tab-pane fade" id="custom-tabs-one-profile-sub" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab-sub">
                                <div class="uw-section-card">
                                    <div class="uw-section-head"><i class="fas fa-search"></i><h5>Credit Question Paper Review</h5></div>
                                    <div class="uw-filter-row">
                                        <div class="uw-field"><label>From Date</label><input type="date" id="cruw_paper_from" name="cruw_paper_from" class="form-control" /></div>
                                        <div class="uw-field"><label>To Date</label><input type="date" id="cruw_paper_to" name="cruw_paper_to" class="form-control" /></div>
                                        <div class="uw-action-row"><button id="cruw_paper_btnShow" class="uw-btn-primary btn" onclick="return cruw_paper_Submit();"><i class="fas fa-eye mr-1"></i> Show</button></div>
                                    </div>
                                    <div class="uw-table-card">
                                        <table class="table table-hover table-bordered nowrap" id="cruw_paper_table">
                                            <thead>
                                                <tr><th colspan="6"></th><th colspan="2" style="text-align:center;">Credit</th><th colspan="2" style="text-align:center;">Compliance</th><th colspan="2" style="text-align:center;">Collateral</th></tr>
                                                <tr><th style="display:none;">App ID</th><th style="text-align:center;">Answer Sheet</th><th style="text-align:center;">Sr. #</th><th>Name</th><th>Test Assigned Date</th><th>Test Date</th><th>Attempt</th><th>Marks</th><th>Percentage</th><th>Marks</th><th>Percentage</th><th>Marks</th><th>Percentage</th></tr>
                                            </thead><tbody></tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                            <div class="tab-pane fade" id="custom-tabs-one-messages-sub" role="tabpanel" aria-labelledby="custom-tabs-one-messages-tab-sub">
                                <div class="uw-section-card">
                                    <div class="uw-section-head"><i class="fas fa-envelope"></i><h5>Send Credit Test Link</h5></div>
                                    <div class="uw-filter-row">
                                        <div class="uw-field"><label>From Date</label><input type="date" id="cruw_send_from" name="cruw_paper_from" class="form-control" /></div>
                                        <div class="uw-field"><label>To Date</label><input type="date" id="cruw_send_to" name="cruw_paper_to" class="form-control" /></div>
                                        <div class="uw-action-row"><button id="cruw_send_btnShow" class="uw-btn-primary btn" onclick="return cruw_send_Submit();"><i class="fas fa-eye mr-1"></i> Show</button><button id="cruw_send_btnSendEmail" class="uw-btn-secondary btn" onclick="return cruw_send_SendEmail();"><i class="fas fa-paper-plane mr-1"></i> Send Email</button></div>
                                    </div>
                                    <div class="uw-table-card">
                                        <table class="table table-hover table-bordered nowrap" id="cruw_send_table">
                                            <thead><tr><th style="text-align:center;">Sr. #</th><th style="text-align:center;">Action</th><th style="text-align:center;">Application ID</th><th>Name</th><th>Position Applied For</th><th>Email Address</th><th>Contact #</th><th>Result</th><th>Marks Obtained</th></tr></thead><tbody></tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                        <ul class="nav nav-tabs uw-sub-tabs" id="custom-tabs-one-tab-sub-serv" role="tablist">
                            <li class="nav-item"><a class="nav-link active" id="custom-tabs-one-home-tab-sub-serv" data-toggle="pill" href="#custom-tabs-one-home-sub-serv" role="tab" aria-controls="custom-tabs-one-home-sub-serv" aria-selected="true"><i class="fas fa-list-check mr-1"></i> Question Set</a></li>
                            <li class="nav-item"><a class="nav-link" id="custom-tabs-one-profile-tab-sub-serv" data-toggle="pill" href="#custom-tabs-one-profile-sub-serv" role="tab" aria-controls="custom-tabs-one-profile-sub-serv" aria-selected="false"><i class="fas fa-clipboard-list mr-1"></i> Check Question Paper</a></li>
                            <li class="nav-item"><a class="nav-link" id="custom-tabs-one-messages-tab-sub-serv" data-toggle="pill" href="#custom-tabs-one-messages-sub-serv" role="tab" aria-controls="custom-tabs-one-messages-sub-serv" aria-selected="false"><i class="fas fa-paper-plane mr-1"></i> Send Test Link</a></li>
                        </ul>

                        <div class="tab-content" id="custom-tabs-one-tabContent-sub-serv">
                            <div class="tab-pane fade show active" id="custom-tabs-one-home-sub-serv" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab-sub-serv">
                                <div class="uw-section-card">
                                    <div class="uw-section-head"><i class="fas fa-question-circle"></i><h5>Servicing Question Details</h5></div>
                                    <div class="uw-form-grid">
                                        <div class="uw-field uw-field-lg"><label>Question</label><textarea id="crser_question" name="crser_question" class="form-control" placeholder="Enter question"></textarea></div>
                                        <div class="uw-field" style="display:none;"><label>Question Type</label><select id="crser_questiontype" name="crser_questiontype" class="form-control"><option value="">Select</option><option value="Credit">Credit</option><option value="Compliance">Compliance</option><option value="Collateral">Collateral</option></select></div>
                                        <div class="uw-field"><label>Marks</label><input type="number" id="crser_marks" name="cruw_marks" class="form-control" placeholder="Enter marks" /></div>
                                        <div class="uw-field"></div><div class="uw-field"></div>
                                        <div class="uw-field"><label>Option 1</label><div class="uw-option-wrap"><input type="text" id="crser_option1" name="crser_option1" class="form-control" /><input type="checkbox" class="uw-answer-check custom-checkbox" id="crser_A_option1" /></div></div>
                                        <div class="uw-field"><label>Option 2</label><div class="uw-option-wrap"><input type="text" id="crser_option2" name="crser_option2" class="form-control" /><input type="checkbox" class="uw-answer-check custom-checkbox" id="crser_A_option2" /></div></div>
                                        <div class="uw-field"><label>Option 3</label><div class="uw-option-wrap"><input type="text" id="crser_option3" name="crser_option3" class="form-control" /><input type="checkbox" class="uw-answer-check custom-checkbox" id="crser_A_option3" /></div></div>
                                        <div class="uw-field"><label>Option 4</label><div class="uw-option-wrap"><input type="text" id="crser_option4" name="crser_option4" class="form-control" /><input type="checkbox" class="uw-answer-check custom-checkbox" id="crser_A_option4" /></div></div>
                                        <div class="uw-action-row"><button id="crser_btnsubmit" class="uw-btn-primary btn" onclick="return crser_submit();"><i class="fas fa-save mr-1"></i> Submit</button></div>
                                    </div>
                                    <div class="uw-table-card">
                                        <table class="table table-hover table-bordered nowrap" id="crser_table">
                                            <thead><tr><th>Sr. #</th><th>Question</th><th>Marks</th><th>Option 1</th><th>Option 2</th><th>Option 3</th><th>Option 4</th><th>Answer</th><th>Added By</th><th>Added Date</th></tr></thead><tbody></tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                            <div class="tab-pane fade" id="custom-tabs-one-profile-sub-serv" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab-sub-serv">
                                <div class="uw-section-card">
                                    <div class="uw-section-head"><i class="fas fa-search"></i><h5>Servicing Question Paper Review</h5></div>
                                    <div class="uw-filter-row">
                                        <div class="uw-field"><label>From Date</label><input type="date" id="crser_paper_from" name="crser_paper_from" class="form-control" /></div>
                                        <div class="uw-field"><label>To Date</label><input type="date" id="crser_paper_to" name="crser_paper_to" class="form-control" /></div>
                                        <div class="uw-action-row"><button id="crser_paper_btnShow" class="uw-btn-primary btn" onclick="return crser_paper_Submit();"><i class="fas fa-eye mr-1"></i> Show</button></div>
                                    </div>
                                    <div class="uw-table-card">
                                        <table class="table table-hover table-bordered nowrap" id="crser_paper_table">
                                            <thead><tr><th style="display:none;">App ID</th><th style="text-align:center;">Answer Sheet</th><th style="text-align:center;">Sr. #</th><th>Name</th><th>Test Date</th><th>Attempt</th><th>Marks</th><th>Percentage</th></tr></thead><tbody></tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                            <div class="tab-pane fade" id="custom-tabs-one-messages-sub-serv" role="tabpanel" aria-labelledby="custom-tabs-one-messages-tab-sub-serv">
                                <div class="uw-section-card">
                                    <div class="uw-section-head"><i class="fas fa-envelope"></i><h5>Send Servicing Test Link</h5></div>
                                    <div class="uw-filter-row">
                                        <div class="uw-field"><label>From Date</label><input type="date" id="crser_send_from" name="crser_send_from" class="form-control" /></div>
                                        <div class="uw-field"><label>To Date</label><input type="date" id="crser_send_to" name="crser_send_to" class="form-control" /></div>
                                        <div class="uw-action-row"><button id="crser_send_btnShow" class="uw-btn-primary btn" onclick="return crser_send_Submit();"><i class="fas fa-eye mr-1"></i> Show</button><button id="crcrser_send_btnSendEmail" class="uw-btn-secondary btn" onclick="return crser_send_SendEmail();"><i class="fas fa-paper-plane mr-1"></i> Send Email</button></div>
                                    </div>
                                    <div class="uw-table-card">
                                        <table class="table table-hover table-bordered nowrap" id="crser_send_table">
                                            <thead><tr><th style="text-align:center;">Sr. #</th><th style="text-align:center;">Action</th><th style="text-align:center;">Application ID</th><th>Name</th><th>Position Applied For</th><th>Email Address</th><th>Contact #</th><th>Result</th><th>Marks Obtained</th></tr></thead><tbody></tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="cruw_dverror">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="cruw_errmsg"></h6>
                </div>
                <div class="modal-footer justify-content-center">
                    <button class="uw-btn-primary btn" type="button" id="cruw_btnMessage" onclick="return cruw_Message();">Okay</button>
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
            cruw_BindGrid();
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input type="text" id="emailappidser" name="emailappidser" style="display: none;" />
    <input type="text" id="emailappid" name="emailappid" style="display: none;" />
    <%--<asp:UpdatePanel ID="up1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
    <asp:Button ID="Button1" runat="server" OnClick="btnMail_Click" Style="display: none;" />
    <asp:Button ID="btnMailSer" runat="server" OnClick="btnMailSer_Click" Style="display: none;" />
    <%--</ContentTemplate>
    </asp:UpdatePanel>
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Underwriting Test</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <div class="card card-tabs">
                    <div class="card-header p-0 pt-1">
                        <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Credit</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-profile-tab" onclick="return getServicingDetails();" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">Servicing</a>
                            </li>
                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                                <div class="card card-tabs">
                                    <div class="card-header p-0 pt-1">
                                        <ul class="nav nav-tabs" id="custom-tabs-one-tab-sub" role="tablist">
                                            <li class="nav-item">
                                                <a class="nav-link active" id="custom-tabs-one-home-tab-sub" data-toggle="pill" href="#custom-tabs-one-home-sub" role="tab" aria-controls="custom-tabs-one-home-sub" aria-selected="true">Question Set</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" id="custom-tabs-one-profile-tab-sub" data-toggle="pill" href="#custom-tabs-one-profile-sub" role="tab" aria-controls="custom-tabs-one-profile-sub" aria-selected="false">Check Question Paper</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" id="custom-tabs-one-messages-tab-sub" data-toggle="pill" href="#custom-tabs-one-messages-sub" role="tab" aria-controls="custom-tabs-one-messages-sub" aria-selected="false">Send Test Link</a>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="card-body">
                                        <div class="tab-content" id="custom-tabs-one-tabContent-sub">
                                            <div class="tab-pane fade show active" id="custom-tabs-one-home-sub" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab-sub">
                                               
                                                <table class="table">
                                                    <tr>
                                                        <td><b>Question:</b></td>
                                                        <td colspan="3">
                                                            <textarea id="cruw_question" name="cruw_question" class="form-control" style="width: 600px;"></textarea>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><b>Question Type:</b></td>
                                                        <td>
                                                            <select id="cruw_questiontype" name="cruw_questiontype" class="form-control" style="width: 300px;">
                                                                <option value="">Select</option>
                                                                <option value="Credit">Credit</option>
                                                                <option value="Compliance">Compliance</option>
                                                                <option value="Collateral">Collateral</option>
                                                            </select>
                                                        </td>
                                                        <td><b>Marks:</b></td>
                                                        <td>
                                                            <input type="number" id="cruw_marks" name="cruw_marks" class="form-control" style="width: 300px;" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><b>Option 1:</b></td>
                                                        <td>
                                                            <input type="text" id="cruw_option1" name="cruw_option1" class="form-control" style="width: 300px; display: inline;" />
                                                            <input type="checkbox" class="custom-checkbox" id="cruw_A_option1" />
                                                        </td>
                                                        <td><b>Option 2:</b></td>
                                                        <td>
                                                            <input type="text" id="cruw_option2" name="cruw_option2" class="form-control" style="width: 300px; display: inline;" />
                                                            <input type="checkbox" class="custom-checkbox" id="cruw_A_option2" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><b>Option 3:</b></td>
                                                        <td>
                                                            <input type="text" id="cruw_option3" name="cruw_option3" class="form-control" style="width: 300px; display: inline;" />
                                                            <input type="checkbox" class="custom-checkbox" id="cruw_A_option3" />
                                                        </td>
                                                        <td><b>Option 4:</b></td>
                                                        <td>
                                                            <input type="text" id="cruw_option4" name="cruw_option4" class="form-control" style="width: 300px; display: inline;" />
                                                            <input type="checkbox" class="custom-checkbox" id="cruw_A_option4" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="4" style="text-align: center;">
                                                            <button id="cruw_btnsubmit" class="btn btn-primary" onclick="return cruw_submit();">Submit</button>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <hr />
                                                <table class="table" id="cruw_table" style="width: 100%;">
                                                    <thead>
                                                        <tr>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Question</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Question Type</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Marks</th>
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
                                            <div class="tab-pane fade" id="custom-tabs-one-profile-sub" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab-sub">
                                                <table class="table">
                                                    <tr>
                                                        <td style="width: 50px;"><b>From Date:</b></td>
                                                        <td style="width: 150px;">
                                                            <input type="date" id="cruw_paper_from" name="cruw_paper_from" class="form-control" />
                                                        </td>
                                                        <td style="width: 50px;">
                                                            <b>Year:</b>
                                                        </td>
                                                        <td style="width: 150px;">
                                                            <input type="date" id="cruw_paper_to" name="cruw_paper_to" class="form-control" />
                                                        </td>
                                                        <td style="width: 100px;">
                                                            <button id="cruw_paper_btnShow" class="btn btn-primary" onclick="return cruw_paper_Submit()">Show</button>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <hr />
                                                <table class="table table-bordered" id="cruw_paper_table" style="padding-top: 10px; width: 100%;">
                                                    <thead>
                                                        <tr>
                                                            <th colspan="6"></th>
                                                            <th colspan="2" style="text-align: center;">Credit</th>
                                                            <th colspan="2" style="text-align: center;">Compliance</th>
                                                            <th colspan="2" style="text-align: center;">Collateral</th>
                                                        </tr>
                                                        <tr>
                                                            <th class="sort border-top ps-3" style="display: none;">App ID</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Answer Sheet</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Test Assigned Date</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Test Date</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Attempt</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Marks</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Percentage</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Marks</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Percentage</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Marks</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Percentage</th>
                                                        </tr>

                                                    </thead>
                                                    <tbody></tbody>

                                                </table>
                                            </div>
                                            <div class="tab-pane fade" id="custom-tabs-one-messages-sub" role="tabpanel" aria-labelledby="custom-tabs-one-messages-tab-sub">
                                                <table class="table">
                                                    <tr>
                                                        <td style="width: 50px;"><b>From Date:</b></td>
                                                        <td style="width: 150px;">
                                                            <input type="date" id="cruw_send_from" name="cruw_paper_from" class="form-control" />
                                                        </td>
                                                        <td style="width: 50px;">
                                                            <b>Year:</b>
                                                        </td>
                                                        <td style="width: 150px;">
                                                            <input type="date" id="cruw_send_to" name="cruw_paper_to" class="form-control" />
                                                        </td>

                                                        <td style="width: 100px;">
                                                            <button id="cruw_send_btnShow" class="btn btn-primary" onclick="return cruw_send_Submit();">Show</button>
                                                            <button id="cruw_send_btnSendEmail" class="btn btn-secondary" onclick="return cruw_send_SendEmail();">Send Email</button>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <hr />
                                                <table class="table table-bordered" id="cruw_send_table" style="padding-top: 10px; width: 100%;">
                                                    <thead>
                                                        <tr>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Action</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Application ID</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Position Applied For</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Email Address</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Contact #</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Result</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Marks Obtained</th>
                                                        </tr>

                                                    </thead>
                                                    <tbody></tbody>

                                                </table>

                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">

                                <div class="card card-tabs">
                                    <div class="card-header p-0 pt-1">
                                        <ul class="nav nav-tabs" id="custom-tabs-one-tab-sub-serv" role="tablist">
                                            <li class="nav-item">
                                                <a class="nav-link active" id="custom-tabs-one-home-tab-sub-serv" data-toggle="pill" href="#custom-tabs-one-home-sub-serv" role="tab" aria-controls="custom-tabs-one-home-sub-serv" aria-selected="true">Question Set</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" id="custom-tabs-one-profile-tab-sub-serv" data-toggle="pill" href="#custom-tabs-one-profile-sub-serv" role="tab" aria-controls="custom-tabs-one-profile-sub-serv" aria-selected="false">Check Question Paper</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" id="custom-tabs-one-messages-tab-sub-serv" data-toggle="pill" href="#custom-tabs-one-messages-sub-serv" role="tab" aria-controls="custom-tabs-one-messages-sub-serv" aria-selected="false">Send Test Link</a>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="card-body">
                                        <div class="tab-content" id="custom-tabs-one-tabContent-sub-serv">
                                            <div class="tab-pane fade show active" id="custom-tabs-one-home-sub-serv" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab-sub-serv">
                                             
                                                <table class="table">
                                                    <tr>
                                                        <td><b>Question:</b></td>
                                                        <td colspan="3">
                                                            <textarea id="crser_question" name="crser_question" class="form-control" style="width: 600px;"></textarea>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="display: none;"><b>Question Type:</b></td>
                                                        <td style="display: none;">
                                                            <select id="crser_questiontype" name="crser_questiontype" class="form-control" style="width: 300px;">
                                                                <option value="">Select</option>
                                                                <option value="Credit">Credit</option>
                                                                <option value="Compliance">Compliance</option>
                                                                <option value="Collateral">Collateral</option>
                                                            </select>
                                                        </td>
                                                        <td><b>Marks:</b></td>
                                                        <td>
                                                            <input type="number" id="crser_marks" name="cruw_marks" class="form-control" style="width: 300px;" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><b>Option 1:</b></td>
                                                        <td>
                                                            <input type="text" id="crser_option1" name="crser_option1" class="form-control" style="width: 300px; display: inline;" />
                                                            <input type="checkbox" class="custom-checkbox" id="crser_A_option1" />
                                                        </td>
                                                        <td><b>Option 2:</b></td>
                                                        <td>
                                                            <input type="text" id="crser_option2" name="crser_option2" class="form-control" style="width: 300px; display: inline;" />
                                                            <input type="checkbox" class="custom-checkbox" id="crser_A_option2" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><b>Option 3:</b></td>
                                                        <td>
                                                            <input type="text" id="crser_option3" name="crser_option3" class="form-control" style="width: 300px; display: inline;" />
                                                            <input type="checkbox" class="custom-checkbox" id="crser_A_option3" />
                                                        </td>
                                                        <td><b>Option 4:</b></td>
                                                        <td>
                                                            <input type="text" id="crser_option4" name="crser_option4" class="form-control" style="width: 300px; display: inline;" />
                                                            <input type="checkbox" class="custom-checkbox" id="crser_A_option4" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="4" style="text-align: center;">
                                                            <button id="crser_btnsubmit" class="btn btn-primary" onclick="return crser_submit();">Submit</button>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <hr />
                                                <table class="table" id="crser_table" style="width: 100%;">
                                                    <thead>
                                                        <tr>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Question</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Marks</th>
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
                                            <div class="tab-pane fade" id="custom-tabs-one-profile-sub-serv" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab-sub-serv">
                                                <table class="table">
                                                    <tr>
                                                        <td style="width: 50px;"><b>From Date:</b></td>
                                                        <td style="width: 150px;">
                                                            <input type="date" id="crser_paper_from" name="crser_paper_from" class="form-control" />
                                                        </td>
                                                        <td style="width: 50px;">
                                                            <b>Year:</b>
                                                        </td>
                                                        <td style="width: 150px;">
                                                            <input type="date" id="crser_paper_to" name="crser_paper_to" class="form-control" />
                                                        </td>
                                                        <td style="width: 100px;">
                                                            <button id="crser_paper_btnShow" class="btn btn-primary" onclick="return crser_paper_Submit()">Show</button>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <hr />
                                                <table class="table table-bordered" id="crser_paper_table" style="padding-top: 10px; width: 100%;">
                                                    <thead>
                                                        <tr>
                                                            <th class="sort border-top ps-3" style="display: none;">App ID</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Answer Sheet</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Test Date</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Attempt</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Marks</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Percentage</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody></tbody>
                                                </table>
                                            </div>
                                            <div class="tab-pane fade" id="custom-tabs-one-messages-sub-serv" role="tabpanel" aria-labelledby="custom-tabs-one-messages-tab-sub-serv">
                                                <table class="table">
                                                    <tr>
                                                        <td style="width: 50px;"><b>From Date:</b></td>
                                                        <td style="width: 150px;">
                                                            <input type="date" id="crser_send_from" name="crser_send_from" class="form-control" />
                                                        </td>
                                                        <td style="width: 50px;">
                                                            <b>Year:</b>
                                                        </td>
                                                        <td style="width: 150px;">
                                                            <input type="date" id="crser_send_to" name="crser_send_to" class="form-control" />
                                                        </td>

                                                        <td style="width: 100px;">
                                                            <button id="crser_send_btnShow" class="btn btn-primary" onclick="return crser_send_Submit();">Show</button>
                                                            <button id="crcrser_send_btnSendEmail" class="btn btn-secondary" onclick="return crser_send_SendEmail();">Send Email</button>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <hr />
                                                <table class="table table-bordered" id="crser_send_table" style="padding-top: 10px; width: 100%;">
                                                    <thead>
                                                        <tr>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Action</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Application ID</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Position Applied For</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Email Address</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Contact #</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Result</th>
                                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Marks Obtained</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody></tbody>

                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="cruw_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="cruw_errmsg"></h6>
                    <<button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="cruw_btnMessage" onclick="return cruw_Message();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>--%>
