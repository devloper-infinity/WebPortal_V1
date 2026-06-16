<%@ Page Title="" Language="C#" MasterPageFile="~/US/USAdmin.Master" AutoEventWireup="true" CodeBehind="ProductionReport.aspx.cs" Inherits="WebPortal.US.ProductionReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        .production-report-redesign {
            background: #f5f7fb;
            min-height: calc(100vh - 80px);
        }

            .production-report-redesign .report-hero {
                background: linear-gradient(135deg, #2563eb 0%, #7c3aed 100%);
                color: #fff;
                border-radius: 18px;
                padding: 24px 28px;
                margin-bottom: 20px;
                box-shadow: 0 12px 28px rgba(31,79,143,.22);
                position: relative;
                overflow: hidden;
                font-weight: 500!important;
            }

                .production-report-redesign .report-hero:after {
                    content: "";
                    position: absolute;
                    right: -48px;
                    top: -48px;
                    width: 170px;
                    height: 170px;
                    border-radius: 50%;
                    background: rgba(255,255,255,.12);
                }

                .production-report-redesign .report-hero h2 {
                    margin: 0;
                    color: #fff;
                    font-weight: 800;
                    letter-spacing: .2px;
                }

                .production-report-redesign .report-hero p {
                    margin: 7px 0 0;
                    font-size: 14px;
                    opacity: .92;
                }

            .production-report-redesign .report-stat-row {
                display: grid;
                grid-template-columns: repeat(4,minmax(160px,1fr));
                gap: 14px;
                margin-bottom: 20px;
            }

            .production-report-redesign .report-stat-card {
                background: #fff;
                border: 1px solid #e5ebf3;
                border-radius: 16px;
                padding: 16px 18px;
                box-shadow: 0 6px 20px rgba(20,37,63,.06);
            }

            .production-report-redesign .report-stat-label {
                color: #667085;
                font-size: 12px;
                font-weight: 800;
                text-transform: uppercase;
                letter-spacing: .04em;
                margin-bottom: 5px;
            }

            .production-report-redesign .report-stat-value {
                color: #1f2d3d;
                font-size: 20px;
                font-weight: 800;
            }

            .production-report-redesign .report-card {
                background: #fff;
                border: 1px solid #e5ebf3;
                border-radius: 16px;
                box-shadow: 0 8px 24px rgba(20,37,63,.06);
                margin-bottom: 20px;
                overflow: hidden;
            }

            .production-report-redesign .report-card-header {
                padding: 15px 20px;
                border-bottom: 1px solid #edf1f7;
                background: #fbfcff;
                display: flex;
                align-items: center;
                justify-content: space-between;
                gap: 12px;
            }

                .production-report-redesign .report-card-header h4 {
                    margin: 0;
                    color: #1f2d3d;
                    font-size: 16px;
                    font-weight: 800;
                }

            .production-report-redesign .report-card-body {
                padding: 20px;
            }

            .production-report-redesign label, .production-report-redesign .modern-label {
                display: block;
                margin-bottom: 7px;
                color: #344054;
                font-size: 13px;
                font-weight: 700;
            }

            .production-report-redesign input[type="text"], .production-report-redesign input[type="password"], .production-report-redesign input[type="number"], .production-report-redesign input[type="date"], .production-report-redesign select, .production-report-redesign textarea, .production-report-redesign .form-control {
                width: 100% !important;
                min-height: 38px;
                border: 1px solid #d7deea;
                border-radius: 10px;
                padding: 8px 11px;
                color: #1f2937;
                background: #fff;
                box-shadow: none;
                outline: none;
                transition: border-color .15s ease,box-shadow .15s ease;
            }

            .production-report-redesign textarea {
                min-height: 84px;
                resize: vertical;
            }

                .production-report-redesign input:focus, .production-report-redesign select:focus, .production-report-redesign textarea:focus {
                    border-color: #2f80ed;
                    box-shadow: 0 0 0 3px rgba(47,128,237,.12);
                }

            .production-report-redesign input[type="submit"], .production-report-redesign input[type="button"], .production-report-redesign button, .production-report-redesign .btn {
                border-radius: 10px !important;
                padding: 8px 18px !important;
                font-weight: 700;
            }

            .production-report-redesign .btn-primary, .production-report-redesign input[type="submit"] {
                background: linear-gradient(135deg, #2563eb 0%, #7c3aed 100%) !important;
                background: #1f4f8f;
                border-color: #1f4f8f;
                color: #fff;
            }

            .production-report-redesign table {
                width: 100%;
            }

            .production-report-redesign th, .production-report-redesign td {
                vertical-align: middle !important;
            }

            .production-report-redesign .table th, .production-report-redesign .Grid th, .production-report-redesign .gridview th {
                background: #f1f6fc;
                color: #1f2d3d;
                font-weight: 800;
            }

            .production-report-redesign .report-note {
                color: #667085;
                font-size: 13px;
            }

        @media(max-width:1200px) {
            .production-report-redesign .report-stat-row {
                grid-template-columns: repeat(2,minmax(160px,1fr));
            }
        }

        @media(max-width:768px) {
            .production-report-redesign {
                padding: 12px
            }

                .production-report-redesign .report-hero {
                    padding: 18px;
                    border-radius: 14px
                }

                .production-report-redesign .report-stat-row {
                    grid-template-columns: 1fr
                }

                .production-report-redesign .report-card-body {
                    padding: 15px
                }

                .production-report-redesign table, .production-report-redesign tbody, .production-report-redesign tr, .production-report-redesign td {
                    display: block;
                    width: 100% !important
                }

                .production-report-redesign td {
                    padding-bottom: 12px !important
                }
        }
    </style>
    <script>
        $(document).ready(function () {
            us_prodsum_rpt_bindyear();
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="production-report-redesign feedback-details-page">
        <div class="report-hero">
         
              <h5><i class="fas fa-copy"></i>&nbsp;&nbsp;Production Report</h5>
            <p>View production report filters, actions, and result details in the same modern style as the above pages.</p>
        </div>


        <div class="report-card">
            <div class="report-card-header">
                <h4>Report Details</h4>
            </div>
            <div class="report-card-body">
                <div class="loading" id="usload1">
                    <img src="../images/Load_1.gif" />
                    <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
                </div>

                <div class="col-lg-12">
                    <div class="card">
                        <div class="card-body">
                            <div class="row align-items-end">
                                <div class="col-md-4">
                                    <label for="us_prodsum_rpt_month"><b>Month</b></label>
                                    <select id="us_prodsum_rpt_month" name="us_prodsum_rpt_month" class="form-control">
                                        <option value="">Select</option>
                                        <option value="January">January</option>
                                        <option value="February">February</option>
                                        <option value="March">March</option>
                                        <option value="April">April</option>
                                        <option value="May">May</option>
                                        <option value="June">June</option>
                                        <option value="July">July</option>
                                        <option value="August">August</option>
                                        <option value="September">September</option>
                                        <option value="October">October</option>
                                        <option value="November">November</option>
                                        <option value="December">December</option>
                                    </select>
                                </div>

                                <div class="col-md-4">
                                    <label for="us_prodsum_rpt_year"><b>Year</b></label>
                                    <select id="us_prodsum_rpt_year" name="us_prodsum_rpt_year" class="form-control">
                                        <option value="">Select</option>
                                    </select>
                                </div>

                                <div class="col-md-4">
                                    <button id="us_prodsum_rpt_btnShow" class="btn btn-primary" style="width: 100%;" onclick="return us_rpt_getproductionSummary();">Show</button>
                                </div>
                                <hr />
                                <table class="table table-bordered" style="width: 100%;" id="usprodsum_rpt_table"></table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
