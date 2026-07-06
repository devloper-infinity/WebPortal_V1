<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="NewJoineeHRFollowup.aspx.cs" Inherits="WebPortal.Admin.NewJoineeHRFollowup" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --nj-ink: #0f172a;
            --nj-muted: #64748b;
            --nj-border: #dbe3ef;
            --nj-soft: #f4f7fb;
            --nj-blue: #2563eb;
            --nj-cyan: #22c1dc;
        }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 999999;
            background: rgba(255,255,255,.68);
            text-align: center;
        }

        #load1 .loading-inner {
            position: absolute !important;
            top: 50% !important;
            left: 50% !important;
            transform: translate(-50%, -50%) !important;
            width: min(280px, calc(100vw - 32px));
            max-width: calc(100vw - 32px);
            border-radius: 22px;
            background: #fff;
            padding: 24px 22px;
            box-shadow: 0 24px 55px rgba(15, 23, 42, .28);
        }

        #load1.loading img {
            display: block;
            width: 82px;
            max-width: 82px;
            height: auto;
            margin: 0 auto;
        }

        .loading-text {
            margin-top: 10px;
            font-size: 13px;
            font-weight: 800;
            color: var(--resg-ink);
        }

        .nj-page {
            background: var(--nj-soft);
            min-height: calc(100vh - 80px);
        }

        .nj-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            gap: 22px;
            padding: 15px 15px;
            margin-bottom: 22px;
            border-radius: 18px;
            color: #fff;
            background: linear-gradient(115deg, #0a5fd7 0%, #1976f3 38%, #1da8ea 72%, #22d3ee 100%);
            box-shadow: 0 12px 28px rgba(21, 98, 228, .25);
        }

            .nj-hero::before {
                content: "";
                position: absolute;
                top: -82px;
                left: -6%;
                width: 116%;
                height: 175px;
                border-radius: 50%;
                background: rgba(255,255,255,.10);
                transform: rotate(-4deg);
            }

            .nj-hero::after {
                content: "";
                position: absolute;
                right: -85px;
                bottom: -90px;
                width: 285px;
                height: 285px;
                border-radius: 50%;
                background: rgba(255,255,255,.13);
            }

            .nj-hero > * {
                position: relative;
                z-index: 2;
            }

        .nj-hero-icon {
            width: 60px;
            height: 60px;
            min-width: 60px;
            border-radius: 50%;
            border: 2px solid rgba(255,255,255,.75);
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.12);
        }

            .nj-hero-icon i {
                font-size: 30px;
                color: #fff;
            }

        .nj-kicker {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 2px;
            font-weight: 700;
            opacity: .9;
            margin-bottom: 4px;
        }

        .nj-title {
            margin: 0;
            font-size: 22px;
            font-weight: 800;
            color: #fff;
        }

        .nj-subtitle {
            margin: 8px 0 0;
            font-size: 13px;
            color: rgba(255,255,255,.92);
            line-height: 1.5;
        }

        .nj-filter-card,
        .nj-grid-card {
            border: 0;
            border-radius: 16px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, .08);
        }

        .nj-card-title {
            display: flex;
            align-items: center;
            gap: 9px;
            margin-bottom: 16px;
            color: var(--nj-ink);
            font-size: 15px;
            font-weight: 800;
        }

            .nj-card-title i {
                color: var(--nj-blue);
            }

        .nj-filter-grid {
            display: grid;
            grid-template-columns: minmax(180px, 260px) minmax(160px, 220px) auto;
            gap: 16px;
            align-items: end;
        }

        .nj-field label {
            display: block;
            font-size: 13px;
            font-weight: 700 !important;
            color: #334155;
            margin-bottom: 6px;
            border: none !important;
        }

        .nj-field .form-control {
            height: 40px;
            border-radius: 10px;
            font-size: 13px;
            border: 1px solid var(--nj-border);
        }

            .nj-field .form-control:focus {
                border-color: var(--nj-blue);
                box-shadow: 0 0 0 3px rgba(37,99,235,.12);
            }

        .nj-btn-primary {
            border: 0;
            color: #fff;
            font-weight: 700;
            border-radius: 10px;
            padding: 9px 20px;
            background: linear-gradient(120deg, var(--nj-blue), var(--nj-cyan));
            box-shadow: 0 8px 18px rgba(37, 99, 235, .25);
            height: 40px;
        }

            .nj-btn-primary:hover {
                color: #fff;
                transform: translateY(-1px);
            }

        .nj-btn-secondary {
            border: 0;
            color: #fff;
            font-weight: 700;
            border-radius: 10px;
            padding: 9px 18px;
            background: linear-gradient(120deg, #64748b, #334155);
        }

        .nj-table-wrap {
            width: 100%;
            overflow: hidden;
        }

        #followup_table {
            width: 100% !important;
            margin-bottom: 0;
        }

            .table.dataTable th,
            #followup_table thead th {
                background: #edf3f8 !important;
                color: #111827 !important;
                font-size: 12px;
                font-weight: 800;
                white-space: nowrap;
                border-bottom: 1px solid #dbe3ef !important;
            }

            .table.dataTable td,
            #followup_table tbody td {
                background-color: #fff !important;
                font-size: 12px;
                vertical-align: middle;
                white-space: nowrap;
            }

            #followup_table tbody tr:hover td {
                background-color: #f8fbff !important;
            }

        .dataTables_length,
        .dataTables_info {
            float: left !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 50px;
            float: left;
        }

        .buttons-excel,
        .buttons-html5 {
            color: #fff !important;
            box-shadow: none;
            background: linear-gradient(to right, #22c55e, #16a34a) !important;
            border: 0 !important;
            font-weight: bold;
            margin: 0 10px;
            border-radius: 8px !important;
        }

        .dataTables_scrollHeadInner,
        .dataTables_scrollHeadInner table {
            width: 100% !important;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: normal !important;
            border: none !important;
        }

        .nj-modal .modal-content {
            border: 0;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 24px 60px rgba(15, 23, 42, .24);
        }

        .nj-modal .modal-header {
            color: #fff;
            background: linear-gradient(120deg, #2563eb, #22c1dc);
            border-bottom: 0;
        }

        .nj-modal .modal-title {
            font-size: 18px;
            font-weight: 800;
        }

        .nj-modal .close {
            color: #fff;
            opacity: 1;
        }

        .nj-modal-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: 14px;
        }

        .nj-readonly-label {
            min-height: 40px;
            display: flex;
            align-items: center;
            background: #f8fafc;
        }

        #followup_remark {
            min-height: 120px;
            resize: vertical;
        }

        @media (max-width: 768px) {
            .nj-filter-grid {
                grid-template-columns: 1fr;
            }

            .nj-btn-primary {
                width: 100%;
            }
        }

        @media (max-width: 576px) {
            .nj-page {
                padding: 10px;
            }

            .nj-hero {
                flex-direction: column;
                align-items: flex-start;
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            Followup_BindYear();
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="loading" id="load1">
        <div class="loading-inner">
            <img src="../images/Load_1.gif" />
            <div class="loading-text">One moment, please...</div>
        </div>
    </div>

    <div class="nj-page">
        <div class="nj-hero">
            <span class="nj-hero-icon">
                <i class="fas fa-user-check"></i>
            </span>
            <div>
                <h1 class="nj-title">New Joinee HR Follow Up</h1>
                <p class="nj-subtitle">Review new joinee details, capture HR observations, and track follow-up status by month and year.</p>
            </div>
        </div>

        <div class="card nj-filter-card mb-3">
            <div class="card-body">
                <div class="nj-card-title">
                    <i class="fas fa-filter"></i>
                    Search Filters
               
                </div>
                <div class="nj-filter-grid">
                    <div class="nj-field">
                        <label>Month</label>
                        <select id="followup_month" name="followup_month" class="form-control">
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

                    <div class="nj-field">
                        <label>Year</label>
                        <select id="followup_year" name="followup_year" class="form-control">
                            <option value="">Select</option>
                        </select>
                    </div>

                    <div>
                        <button id="followup_btnShow" class="nj-btn-primary" onclick="return followup_Submit();">
                            <i class="fas fa-search mr-1"></i>Show
                       
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <div class="card nj-grid-card">
            <div class="card-body"></div>
            <div class="nj-card-title">
                <i class="fas fa-table"></i>
                Follow Up Details
            </div>
            <div style="overflow: auto;">
                <table class="table" id="followup_table" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="display: none;">Employee ID</th>
                            <th class="sort border-top ps-3">Actions</th>
                            <th class="sort border-top ps-3">Code</th>
                            <th class="sort border-top ps-3">Employee Name</th>
                            <th class="sort border-top ps-3">Joining Date</th>
                            <th class="sort border-top ps-3">Branch</th>
                            <th class="sort border-top ps-3">Contact #</th>
                            <th class="sort border-top ps-3">Designation</th>
                            <th class="sort border-top ps-3">Domain</th>
                            <th class="sort border-top ps-3">Reporting Manager</th>
                            <th class="sort border-top ps-3">Observations of New Joiner by HR</th>
                            <th class="sort border-top ps-3">Added By</th>
                            <th class="sort border-top ps-3">Added Date</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade nj-modal" id="followupremarkpopup">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">
                        <i class="fas fa-comment-dots mr-2"></i>Observations by HR
                    </h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="nj-modal-grid">
                        <div class="nj-field">
                            <label>Employee Name</label>
                            <label id="followup_empname" class="form-control nj-readonly-label"></label>
                        </div>

                        <div class="nj-field">
                            <label>Observations</label>
                            <textarea id="followup_remark" name="followup_remark" class="form-control"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">
                        <i class="fas fa-times mr-1"></i>Close
                   
                    </button>
                    <button class="nj-btn-primary" type="button" id="followup_btnupdateremark" onclick="return followup_updateremark();">
                        <i class="fas fa-save mr-1"></i>Update Remark
                   
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade nj-modal" id="followup_dverror">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="followup_errmsg"></h6>
                </div>
                <div class="modal-footer justify-content-center">
                    <button class="nj-btn-primary" type="button" id="followup_btnMessage" onclick="return followup_Message();">
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
            Followup_BindYear();
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>New Joinee HR Follow up</b></h6>
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
                        <td style="width: 50px;"><b>Month:</b></td>
                        <td style="width: 150px;">
                            <select id="followup_month" name="followup_month" class="form-control">
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
                            <select id="followup_year" name="followup_year" class="form-control">
                                <option value="">Select</option>
                            </select>
                        </td>
                        <td style="width: 100px;">
                            <button id="followup_btnShow" class="btn btn-primary" onclick="return followup_Submit()">Show</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <table class="table" id="followup_table" style="padding-top: 10px; width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="display: none;">Employee ID</th>
                            <th class="sort border-top ps-3">Actions</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Employee Name</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Joining Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Contact #</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Designation</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Domain</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Reporting Manager</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Observations of New Joiner by HR</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added By</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="followupremarkpopup">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Observations by HR</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table">
                        <tr>
                            <td><b>Employee Name:</b></td>
                            <td>
                                <label id="followup_empname" class="form-control" style="width: 300px;"></label>
                            </td>
                        </tr>

                        <tr>
                            <td><b>Observations:</b></td>
                            <td>
                                <textarea id="followup_remark" name="followup_remark" class="form-control" style="width: 300px;"></textarea>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button class="btn btn-primary" type="button" id="followup_btnupdateremark" onclick="return followup_updateremark();">Update Remark</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
  
    <div class="modal fade" id="followup_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="followup_errmsg"></h6>
                  
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="followup_btnMessage" onclick="return followup_Message();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>--%>
