<%@ Page Title="" Language="C#" MasterPageFile="~/Search/Search.Master" AutoEventWireup="true" CodeBehind="AbstractorReport.aspx.cs" Inherits="WebPortal.Search.AbstractorReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --order-bg: #f4f6f8;
            --order-surface: #ffffff;
            --order-border: #d9e1e8;
            --order-border-soft: #eef2f5;
            --order-text: #1f2937;
            --order-muted: #667085;
            --order-primary: #0f766e;
            --order-primary-dark: #115e59;
            --order-accent: #2563eb;
        }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 99999;
            background: rgba(248, 250, 252, .72);
            backdrop-filter: blur(2px);
            align-items: center;
            justify-content: center;
            text-align: center;
        }

            .loading img {
                width: 64px;
                height: 64px;
                display: block;
                margin: 0 auto 10px;
            }

            .loading div {
                font-size: 12px;
                font-weight: 700;
                color: var(--order-text);
            }

        .abstractor-report-page {
            background: var(--order-bg);
            min-height: calc(100vh - 72px);
            padding: 18px;
        }

        .order-page-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            max-width: 1440px;
            margin: 0 auto 14px;
            padding: 14px 18px;
            background: var(--order-surface);
            border: 1px solid var(--order-border);
            border-left: 4px solid var(--order-primary);
            border-radius: 8px;
            box-shadow: 0 10px 24px rgba(31, 41, 55, .05);
        }

        .order-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0;
            color: var(--order-text);
            font-size: 22px;
            font-weight: 700;
        }

            .order-title i {
                width: 36px;
                height: 36px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                color: #ffffff;
                background: var(--order-primary);
                border-radius: 8px;
                font-size: 15px;
            }

        .order-context {
            color: var(--order-muted);
            font-size: 12px;
            font-weight: 600;
            margin-top: 2px;
        }

        .order-shell {
            max-width: 1440px;
            margin: 0 auto;
            background: var(--order-surface);
            border: 1px solid var(--order-border);
            border-radius: 8px;
            box-shadow: 0 12px 30px rgba(31, 41, 55, .06);
            overflow: hidden;
        }

        .order-section {
            padding: 16px;
            border-bottom: 1px solid var(--order-border-soft);
        }

            .order-section:last-child {
                border-bottom: 0;
            }

        .section-title {
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 0 0 12px;
            color: var(--order-text);
            font-size: 14px;
            font-weight: 700;
        }

            .section-title i {
                color: var(--order-primary);
            }

        .report-table-wrap {
            width: 100%;
            overflow: auto;
            border: 1px solid var(--order-border);
            border-radius: 8px;
            background: #fff;
        }

        #allAbstractorlist,
        #tblAbstractorCosting,
        #tblAttachment {
            width: 100% !important;
            margin: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0;
            font-size: 12px;
        }

            #allAbstractorlist thead th,
            #tblAbstractorCosting thead th,
            #tblAttachment thead th,
            .table.dataTable th {
                vertical-align: middle !important;
                text-align: center;
                color: var(--order-text) !important;
                background: #f8fafc !important;
                border-color: var(--order-border) !important;
                font-weight: 700;
                white-space: nowrap;
            }

            #allAbstractorlist tbody td,
            #tblAbstractorCosting tbody td,
            #tblAttachment tbody td,
            .table.dataTable tr td {
                background: #fff !important;
                border-color: var(--order-border-soft) !important;
                color: var(--order-text);
                vertical-align: middle;
                white-space: nowrap;
            }

            #allAbstractorlist tbody tr:hover td,
            #tblAbstractorCosting tbody tr:hover td,
            #tblAttachment tbody tr:hover td {
                background: #f9fbfb !important;
            }

        .dataTables_wrapper {
            color: var(--order-text);
            font-size: 12px;
        }

        .dataTables_length,
        .dataTables_info {
            float: left !important;
            color: var(--order-muted);
            font-size: 12px;
        }

        div.dt-buttons {
            position: static;
            padding-left: 16px;
            float: left;
        }

        .buttons-excel,
        .buttons-html5 {
            color: #fff !important;
            background: var(--order-primary) !important;
            border: 0 !important;
            border-radius: 6px !important;
            font-weight: 700;
            margin: 0 8px;
            box-shadow: 0 8px 16px rgba(15, 118, 110, .18);
        }

            .buttons-excel:hover,
            .buttons-html5:hover {
                background: var(--order-primary-dark) !important;
            }

        .custom-comp-modal,
        .modal-content {
            border: 1px solid var(--order-border);
            border-radius: 10px;
            box-shadow: 0 20px 44px rgba(31, 41, 55, .20);
            overflow: hidden;
        }

        .custom-comp-header,
        .modal-header {
            background: var(--order-primary) !important;
            color: #fff !important;
            border-bottom: 0;
            padding: 14px 18px;
        }

            .custom-comp-header .modal-title,
            .modal-header .modal-title {
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 16px;
                font-weight: 700;
            }

        .modal-body {
            background: #fbfcfd;
            padding: 16px;
        }

        .modal-footer {
            background: #fff;
            border-top: 1px solid var(--order-border-soft);
            padding: 12px 16px;
        }

            .modal-footer .btn,
            .btn-default {
                min-height: 36px;
                padding: 8px 18px;
                color: var(--order-text) !important;
                background: #fff !important;
                border: 1px solid var(--order-border) !important;
                border-radius: 6px;
                font-size: 13px;
                font-weight: 700;
            }

                .modal-footer .btn:hover,
                .btn-default:hover {
                    background: #f8fafc !important;
                    border-color: var(--order-primary) !important;
                    color: var(--order-primary-dark) !important;
                }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: normal !important;
            border: none !important;
        }

        @media (max-width: 575px) {
            .abstractor-report-page {
                padding: 12px;
            }

            .order-page-header {
                align-items: flex-start;
                flex-direction: column;
            }
        }
    </style>
    <link rel="stylesheet" href="dist/css/adminlte.min.css">
    <link rel="stylesheet" href="dist/css/custom-style.css">

    <script type="text/javascript">
        $(document).ready(function () {
            BindAllAbstractorReport();
        });

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <div>
            <img src="../images/Load_1.gif" />
            <div>One moment, please . . . .</div>
        </div>
    </div>

    <div class="abstractor-report-page">
        <div class="order-page-header">
            <div>
                <h1 class="order-title"><i class="fas fa-copy"></i><span>Abstractor Report</span></h1>
                <div class="order-context">View abstractor details, coverage costing, and uploaded attachments</div>
            </div>
        </div>

        <div class="order-shell">
            <div class="order-section">
                <h2 class="section-title"><i class="fas fa-table"></i><span>Abstractor Details</span></h2>
                <div class="report-table-wrap">
                    <table class="table" id="allAbstractorlist" style="width: 100%;">
                        <thead>
                            <tr>
                                <th class="sort border-top" style="text-wrap: nowrap;">Action</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">SrNo</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Company Name</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Abstractor Name</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Expiry Date</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Address</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Contact #1</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Mobile #</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Email</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Status</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Remark</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="modal fade" id="popUpShowCoverage" data-backdrop="static" tabindex="-1">
            <div class="modal-dialog modal-xl modal-dialog-centered">
                <div class="modal-content custom-comp-modal">
                    <div class="modal-header custom-comp-header">
                        <h5 class="modal-title"><i class="fas fa-th-list"></i>&nbsp;&nbsp;Abstractor Report</h5>
                        <button type="button" class="close text-white" data-dismiss="modal">
                            <span>&times;</span>
                        </button>
                    </div>

                    <div class="modal-body">
                        <div class="report-table-wrap">
                            <table class="table" id="tblAbstractorCosting">
                                <thead>
                                    <tr>
                                        <th class="sort border-top" style="text-wrap: nowrap;">Sr. #</th>
                                        <th class="sort border-top" style="text-wrap: nowrap; width: 200px;">Abstractor</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">State</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">County</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">Online</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">Current</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">TwoOwner</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">FullSearch</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">30Year</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">40Year</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">50Year</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">60Year</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">DocRequest</th>
                                        <th class="sort border-top" style="text-wrap: nowrap; width: 100px;">LVCost</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">Update</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">Judgment</th>
                                        <th class="sort border-top" style="text-wrap: nowrap; width: 200px;">CopyCost</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- Rows will be populated via jQuery -->
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="modal-footer justify-content-between">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal fade" id="popUpShowAttachment" data-backdrop="static" tabindex="-1">
            <div class="modal-dialog modal-xl modal-dialog-centered">
                <div class="modal-content custom-comp-modal">
                    <div class="modal-header custom-comp-header">
                        <h5 class="modal-title"><i class="fas fa-image me-2"></i>&nbsp;&nbsp;Attachments</h5>
                        <button type="button" class="close text-white" data-dismiss="modal">
                            <span>&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="report-table-wrap">
                            <table class="table" id="tblAttachment">
                                <thead>
                                    <tr>
                                        <th class="sort border-top" style="text-wrap: nowrap; width: 100px;">Action</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">Sr. #</th>
                                        <th class="sort border-top" style="text-wrap: nowrap; width: 200px;">Abstractor</th>
                                        <th class="sort border-top" style="text-wrap: nowrap; width: 200px;">Document</th>
                                        <th class="sort border-top" style="text-wrap: nowrap; width: 300px;">Uploaded By</th>
                                        <th class="sort border-top" style="text-wrap: nowrap;">Uploaded Date</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                    <div class="modal-footer justify-content-between">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>


<%--<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
 
    <link rel="stylesheet" href="dist/css/adminlte.min.css">
    <link rel="stylesheet" href="dist/css/custom-style.css">

    <script type="text/javascript">
        $(document).ready(function () {
            BindAllAbstractorReport();
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Abstractor Report</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>


    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <table class="table" id="allAbstractorlist" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top" style="text-wrap: nowrap;">Action</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">SrNo</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Company Name</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Abstractor Name</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Expiry Date</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Address</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Contact #1</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Mobile #</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Email</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Status</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Remark</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="popUpShowCoverage" data-backdrop="static" tabindex="-1">
        <div class="modal-dialog modal-xl modal-dialog-centered">
            <div class="modal-content custom-comp-modal">

                <!-- Header -->
                <div class="modal-header custom-comp-header">
                    <h5 class="modal-title"><i class="fas fa-th-list"></i>&nbsp;&nbsp;Abstractor Report</h5>
                    <button type="button" class="close text-white" data-dismiss="modal">
                        <span>&times;</span>
                    </button>
                </div>

                <div class="modal-body">
                    <div style="width: 100%; overflow: auto;">
                        <table class="table" id="tblAbstractorCosting">
                            <thead>
                                <tr>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Sr. #</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; width: 200px;">Abstractor</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">State</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">County</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Online</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Current</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">TwoOwner</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">FullSearch</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">30Year</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">40Year</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">50Year</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">60Year</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">DocRequest</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; width: 100px;">LVCost</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Update</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Judgment</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; width: 200px;">CopyCost</th>
                                </tr>
                            </thead>
                            <tbody>
                                <!-- Rows will be populated via jQuery -->
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>


    <div class="modal fade" id="popUpShowAttachment" data-backdrop="static" tabindex="-1">
        <div class="modal-dialog modal-xl modal-dialog-centered">
            <div class="modal-content custom-comp-modal">

                <!-- Header -->
                <div class="modal-header custom-comp-header">
                    <h5 class="modal-title"><i class="fas fa-image me-2"></i>&nbsp;&nbsp;Attachments</h5>
                    <button type="button" class="close text-white" data-dismiss="modal">
                        <span>&times;</span>
                    </button>
                </div>


                <div class="modal-body">
                    <div style="width: 100%; overflow: auto;">
                        <table class="table" id="tblAttachment">
                            <thead>
                                <tr>
                                    <th class="sort border-top" style="text-wrap: nowrap; width: 100px;">Action</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Sr. #</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; width: 200px;">Abstractor</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; width: 200px;">Document</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; width: 300px;">Uploaded By</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Uploaded Date</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>

                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

</asp:Content>--%>
