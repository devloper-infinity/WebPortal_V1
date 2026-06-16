<%@ Page Title="" Language="C#" MasterPageFile="~/US/USAdmin.Master" AutoEventWireup="true" CodeBehind="ProductionSummary.aspx.cs" Inherits="WebPortal.US.ProductionSummary" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">


    <!-- ProductionSummary redesigned using FeedbackDetails style reference -->
    <style>
        .production-redesign {
            background: #f5f7fb;
            min-height: calc(100vh - 80px);
        }

            .production-redesign .production-hero {
                background: linear-gradient(135deg, #2563eb 0%, #7c3aed 100%);
                color: #fff;
                border-radius: 18px;
                padding: 24px 28px;
                margin-bottom: 20px;
                box-shadow: 0 12px 28px rgba(31,79,143,.22);
                position: relative;
                overflow: hidden;
                font-size: 20px;
            }

                .production-redesign .production-hero:after {
                    content: "";
                    position: absolute;
                    right: -48px;
                    top: -48px;
                    width: 170px;
                    height: 170px;
                    border-radius: 50%;
                    background: rgba(255,255,255,.12);
                }

                .production-redesign .production-hero h2, .production-redesign .production-hero h3 {
                    margin: 0;
                    color: #fff;
                    font-weight: 800;
                    letter-spacing: .2px;
                }

                .production-redesign .production-hero p {
                    margin: 7px 0 0;
                    font-size: 14px;
                    opacity: .92;
                }

            .production-redesign .summary-stat-row {
                display: grid;
                grid-template-columns: repeat(4,minmax(160px,1fr));
                gap: 14px;
                margin-bottom: 20px;
            }

            .production-redesign .summary-stat-card {
                background: #fff;
                border: 1px solid #e5ebf3;
                border-radius: 16px;
                padding: 16px 18px;
                box-shadow: 0 6px 20px rgba(20,37,63,.06);
            }

            .production-redesign .summary-stat-label {
                color: #667085;
                font-size: 12px;
                font-weight: 800;
                text-transform: uppercase;
                letter-spacing: .04em;
                margin-bottom: 5px;
            }

            .production-redesign .summary-stat-value {
                color: #1f2d3d;
                font-size: 20px;
                font-weight: 800;
            }

            .production-redesign .production-card {
                background: #fff;
                border: 1px solid #e5ebf3;
                border-radius: 16px;
                box-shadow: 0 8px 24px rgba(20,37,63,.06);
                margin-bottom: 20px;
                overflow: hidden;
            }

            .production-redesign .production-card-header {
                padding: 15px 20px;
                border-bottom: 1px solid #edf1f7;
                background: #fbfcff;
                display: flex;
                align-items: center;
                justify-content: space-between;
                gap: 12px;
            }

                .production-redesign .production-card-header h4 {
                    margin: 0;
                    color: #1f2d3d;
                    font-size: 16px;
                    font-weight: 800;
                }

            .production-redesign .production-card-body {
                padding: 20px;
            }

            .production-redesign label, .production-redesign .modern-label {
                display: block;
                margin-bottom: 7px;
                color: #344054;
                font-size: 13px;
                font-weight: 700;
            }

            .production-redesign input[type="text"], .production-redesign input[type="password"], .production-redesign input[type="number"], .production-redesign input[type="date"], .production-redesign select, .production-redesign textarea, .production-redesign .form-control {
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

            .production-redesign textarea {
                min-height: 84px;
                resize: vertical;
            }

                .production-redesign input:focus, .production-redesign select:focus, .production-redesign textarea:focus {
                    border-color: #2f80ed;
                    box-shadow: 0 0 0 3px rgba(47,128,237,.12);
                }

            .production-redesign input[type="submit"], .production-redesign input[type="button"], .production-redesign button, .production-redesign .btn {
                border-radius: 10px !important;
                padding: 8px 18px !important;
                font-weight: 700;
            }

            .production-redesign .btn-primary, .production-redesign input[type="submit"] {
                background: linear-gradient(135deg, #2563eb 0%, #7c3aed 100%) !important;
                background: #1f4f8f;
                border-color: #1f4f8f;
                color: #fff;
            }

            .production-redesign table {
                width: 100%;
            }

            .production-redesign th, .production-redesign td {
                vertical-align: middle !important;
            }

            .production-redesign .table, .production-redesign .Grid, .production-redesign .gridview {
                background: #fff;
                border-radius: 12px;
                overflow: hidden;
            }

                .production-redesign .table th, .production-redesign .Grid th, .production-redesign .gridview th {
                    background: #f1f6fc;
                    color: #1f2d3d;
                    font-weight: 800;
                }

            .production-redesign .summary-note {
                color: #667085;
                font-size: 13px;
            }

        @media(max-width:1200px) {
            .production-redesign .summary-stat-row {
                grid-template-columns: repeat(2,minmax(160px,1fr));
            }
        }

        @media(max-width:768px) {
            .production-redesign {
                padding: 12px
            }

                .production-redesign .production-hero {
                    padding: 18px;
                    border-radius: 14px
                }

                .production-redesign .summary-stat-row {
                    grid-template-columns: 1fr
                }

                .production-redesign .production-card-body {
                    padding: 15px
                }

                .production-redesign table, .production-redesign tbody, .production-redesign tr, .production-redesign td {
                    display: block;
                    width: 100% !important
                }

                .production-redesign td {
                    padding-bottom: 12px !important
                }
        }
    </style>

    <script>
        $(document).ready(function () {
            us_prodsum_bindyear();
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="production-redesign feedback-details-page">
        <div class="production-hero">
            <h5><i class="fas fa-copy"></i>&nbsp;&nbsp;Production Summary</h5>
            <p>Review production counts, filters, and summary details in a FeedbackDetails-style interface.</p>
        </div>

        <div class="production-card">
            <div class="production-card-header">
                <h4>Summary Details</h4>
            </div>
            <div class="production-card-body">

                <div class="loading" id="usload1">
                    <img src="../images/Load_1.gif" />
                    <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
                </div>


                <div class="col-lg-12">
                    <div class="card">
                        <div class="card-body">
                            <div class="container-fluid">
                                <div class="row align-items-end">
                                    <div class="col-md-4">
                                        <label for="us_prodsum_month"><b>Month</b></label>
                                        <select id="us_prodsum_month" name="us_prodsum_month" class="form-control">
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
                                        <label for="us_prodsum_year"><b>Year</b></label>
                                        <select id="us_prodsum_year" name="us_prodsum_year" class="form-control">
                                            <option value="">Select</option>
                                        </select>
                                    </div>

                                    <div class="col-md-4">
                                        <button id="us_prodsum_btnShow"
                                            class="btn btn-primary w-100"
                                            onclick="return getprodsummary();">
                                            Show
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <%-- <table class="table">
                                <tr>
                                    <td style="width: 50px;"><b>Month:</b></td>
                                    <td style="width: 150px;">
                                        <select id="us_prodsum_month" name="us_prodsum_month" class="form-control">
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
                                    </td>
                                    <td style="width: 50px;">
                                        <b>Year:</b>
                                    </td>
                                    <td style="width: 150px;">
                                        <select id="us_prodsum_year" name="us_prodsum_year" class="form-control">
                                            <option value="">Select</option>
                                        </select>
                                    </td>
                                    <td style="width: 100px;">
                                        <button id="us_prodsum_btnShow" class="btn btn-primary" onclick="return getprodsummary();">Show</button>

                                    </td>
                                </tr>
                            </table>--%>
                            <%-- <table class="table" style="display: none;">
                                <tr>
                                    <td><b>Date:</b></td>
                                    <td>
                                        <input type="date" id="us_prodsum_date" name="us_prodsum_date" class="form-control" style="width: 250px;" onchange="return getprodsummary();" />
                                    </td>
                                </tr>
                            </table>--%>
                            <hr />
                            <table class="table table-bordered" style="width: 100%;" id="usprodsum_table"></table>
                            <div style="text-align: center;">
                                <button id="us_prodsum_btnsubmit" name="us_prodsum_btnsubmit" onclick="return us_prodsum_submit();" class="btn btn-primary" style="display: none;">Save</button>
                            </div>
                        </div>
                    </div>
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
        $(document).ready(function () {
            us_prodsum_bindyear();
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="usload1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Production Summary</b></h6>
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <table class="table">
                    <tr>
                        <td style="width: 50px;"><b>Month:</b></td>
                        <td style="width: 150px;">
                            <select id="us_prodsum_month" name="us_prodsum_month" class="form-control">
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
                        </td>
                        <td style="width: 50px;">
                            <b>Year:</b>
                        </td>
                        <td style="width: 150px;">
                            <select id="us_prodsum_year" name="us_prodsum_year" class="form-control">
                                <option value="">Select</option>
                            </select>
                        </td>
                        <td style="width: 100px;">
                            <button id="us_prodsum_btnShow" class="btn btn-primary" onclick="return getprodsummary();">Show</button>

                        </td>
                    </tr>
                </table>
                <table class="table" style="display: none;">
                    <tr>
                        <td><b>Date:</b></td>
                        <td>
                            <input type="date" id="us_prodsum_date" name="us_prodsum_date" class="form-control" style="width: 250px;" onchange="return getprodsummary();" />
                        </td>
                    </tr>
                </table>
                <hr />
                <table class="table table-bordered" style="width: 100%;" id="usprodsum_table"></table>
                <div style="text-align: center;">
                    <button id="us_prodsum_btnsubmit" name="us_prodsum_btnsubmit" onclick="return us_prodsum_submit();" class="btn btn-primary" style="display: none;">Save</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>--%>
