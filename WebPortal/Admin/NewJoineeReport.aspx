<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="NewJoineeReport.aspx.cs" Inherits="WebPortal.Admin.NewJoineeReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        :root {
            --nj-primary: #2563eb;
            --nj-secondary: #22c1dc;
            --nj-dark: #0f172a;
            --nj-muted: #64748b;
            --nj-soft: #f8fafc;
            --nj-border: #dbe5f1;
            --nj-success: #16a34a;
        }

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
            box-shadow: 0 20px 50px rgba(15,23,42,.20);
            padding: 22px;
        }

            .loading img {
                max-width: 84px;
                margin-top: 16px;
            }

        .nj-page {
            background: #eef3f9;
            min-height: calc(100vh - 80px);
        }

        .nj-hero {
            border-radius: 22px;
            padding: 24px 28px;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%);
            color: #fff;
            box-shadow: 0 18px 45px rgba(37,99,235,.28);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            margin-bottom: 18px;
            position: relative;
            overflow: hidden;
        }

            .nj-hero:after {
                content: "";
                position: absolute;
                right: -80px;
                top: -90px;
                width: 260px;
                height: 260px;
                border-radius: 50%;
                background: rgba(255,255,255,.14);
            }

        .nj-hero-left {
            display: flex;
            align-items: center;
            gap: 16px;
            position: relative;
            z-index: 1;
        }

        .nj-hero-icon {
            width: 56px;
            height: 56px;
            border-radius: 18px;
            background: rgba(255,255,255,.18);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            box-shadow: inset 0 0 0 1px rgba(255,255,255,.25);
        }

        .nj-hero h3 {
            margin: 0;
            font-size: 23px;
            font-weight: 800;
            letter-spacing: .2px;
        }

        .nj-hero p {
            margin: 5px 0 0;
            opacity: .92;
            font-size: 13px;
        }

        .nj-chip {
            position: relative;
            z-index: 1;
            background: rgba(255,255,255,.18);
            color: #fff;
            padding: 9px 14px;
            border-radius: 999px;
            font-weight: 700;
            font-size: 12px;
            box-shadow: inset 0 0 0 1px rgba(255,255,255,.25);
            white-space: nowrap;
        }

        .nj-panel {
            background: #fff;
            border: 1px solid var(--nj-border);
            border-radius: 22px;
            box-shadow: 0 14px 35px rgba(15,23,42,.07);
            overflow: hidden;
        }

        .nj-panel-head {
            padding: 16px 20px;
            border-bottom: 1px solid var(--nj-border);
            background: linear-gradient(180deg,#ffffff,#f8fafc);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
        }

        .nj-panel-title {
            margin: 0;
            font-size: 15px;
            font-weight: 800;
            color: var(--nj-dark);
        }

            .nj-panel-title i {
                color: var(--nj-primary);
                margin-right: 8px;
            }

        .nj-filter-body {
            padding: 20px;
        }

        .nj-field label {
            display: block;
            font-size: 12px;
            font-weight: 700 !important;
            color: #334155;
            margin-bottom: 8px;
        }

        .nj-field .form-control {
            height: 42px;
            border-radius: 12px;
            border: 1px solid #cbd5e1;
            font-size: 13px;
            box-shadow: none !important;
        }

            .nj-field .form-control:focus {
                border-color: var(--nj-primary);
                box-shadow: 0 0 0 4px rgba(37,99,235,.10) !important;
            }

        .nj-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            justify-content: flex-end;
            align-items: flex-end;
            height: 100%;
        }

        .nj-btn {
            border: none;
            min-height: 42px;
            border-radius: 12px;
            padding: 10px 17px;
            font-size: 13px;
            font-weight: 800;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: .25s ease;
            text-decoration: none !important;
            white-space: nowrap;
        }

        .nj-btn-primary {
            background: linear-gradient(135deg, var(--nj-primary), var(--nj-secondary));
            color: #fff !important;
            box-shadow: 0 12px 25px rgba(37,99,235,.20);
        }

        .nj-btn-success {
            background: linear-gradient(135deg, #16a34a, #22c55e);
            color: #fff !important;
            box-shadow: 0 12px 25px rgba(22,163,74,.20);
        }

        .nj-btn:hover {
            transform: translateY(-2px);
            filter: brightness(1.02);
        }

        .nj-table-wrap {
            padding: 0 20px 20px;
        }

        .nj-table-card {
            border: 1px solid var(--nj-border);
            border-radius: 18px;
            overflow: hidden;
            background: #fff;
        }

        #newjoineetable {
            margin: 0 !important;
            width: 100% !important;
        }

            #newjoineetable thead th,
            .table.dataTable th {
                background: #edf3f8 !important;
                color: #0f172a !important;
                font-size: 12px;
                font-weight: 800;
                border-bottom: 1px solid #d8e2ee !important;
                white-space: nowrap;
                vertical-align: middle;
            }

            #newjoineetable tbody td,
            .table.dataTable tr td {
                background: #fff !important;
                font-size: 12px;
                color: #1e293b;
                vertical-align: middle;
                padding: 11px 10px !important;
                border-color: #e6edf5 !important;
            }

            #newjoineetable tbody tr:hover td {
                background: #f8fbff !important;
            }

        .dataTables_wrapper {
            padding: 14px;
        }

        .dataTables_length, .dataTables_info {
            float: left !important;
            font-size: 12px;
            color: var(--nj-muted);
        }

        div.dt-buttons {
            position: static;
            padding-left: 12px;
            float: left;
        }

        .buttons-excel, .buttons-html5 {
            color: #fff !important;
            box-shadow: 0 8px 18px rgba(22,163,74,.18);
            background: linear-gradient(135deg, #16a34a, #22c55e) !important;
            border: 0 !important;
            font-weight: 800 !important;
            border-radius: 10px !important;
            margin: 0 8px;
            padding: 7px 14px !important;
            font-size: 12px !important;
        }

        .dataTables_filter input,
        .dataTables_length select {
            border: 1px solid #cbd5e1 !important;
            border-radius: 10px !important;
            padding: 6px 10px !important;
            outline: none !important;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: normal !important;
            border: none !important;
        }

        @media (max-width: 767px) {
            .nj-page {
                padding: 10px;
            }

            .nj-hero {
                padding: 20px;
                align-items: flex-start;
                flex-direction: column;
            }

                .nj-hero h3 {
                    font-size: 20px;
                }

            .nj-actions {
                justify-content: flex-start;
                margin-top: 8px;
            }

            .nj-btn {
                width: 100%;
            }

            div.dt-buttons {
                padding-left: 0;
                margin-top: 8px;
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            BindYear_NewJoin();
        });

        function newjoin_Exporttoexcel() {
            __doPostBack("<%= btn21.UniqueID %>", '');
            return false;
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Button ID="btn21" runat="server" Style="display: none;" OnClick="btn1_Click" />

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold; margin-top: 10px;">One moment, please . . . .</div>
    </div>

    <div class="nj-page">
        <div class="nj-hero">
            <div class="nj-hero-left">
                <div class="nj-hero-icon">
                    <i class="fas fa-user-plus"></i>
                </div>
                <div>
                    <h3>New Joined Employees</h3>
                    <p>View and export newly joined employee details with branch, department and reporting information.</p>
                </div>
            </div>
            <div class="nj-chip">
                <i class="fas fa-users"></i>Employee Report
           
            </div>
        </div>

        <div class="nj-panel">
            <div class="nj-panel-head">
                <h5 class="nj-panel-title"><i class="fas fa-filter"></i>Report Filters</h5>
            </div>

            <div class="nj-filter-body">
                <div class="row align-items-end">
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="nj-field">
                            <label for="newjoin_from">From Date</label>
                            <input type="date" id="newjoin_from" name="newjoin_from" class="form-control" />
                            <select id="newjoin_month" name="newjoin_month" class="form-control" style="display: none;">
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
                    </div>

                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="nj-field">
                            <label for="newjoin_to">To Date</label>
                            <input type="date" id="newjoin_to" name="newjoin_to" class="form-control" />
                            <select id="newjoin_year" name="newjoin_year" class="form-control" style="display: none;">
                                <option value="">Select</option>
                            </select>
                        </div>
                    </div>

                    <div class="col-lg-6 col-md-12 mb-3">
                        <div class="nj-actions">
                            <button type="button" id="newjoin_btnShow" class="nj-btn nj-btn-primary" onclick="return newjoin_Submit();">
                                <i class="fas fa-search"></i><span>Show Report</span>
                            </button>

                            <button type="button" id="newjoin_btnExporttoexcel" class="nj-btn nj-btn-success" onclick="return newjoin_Exporttoexcel();">
                                <i class="fas fa-file-excel"></i><span>Export to Excel</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="nj-table-wrap">
                <div class="nj-panel-head" style="border: 1px solid #dbe5f1; border-radius: 18px 18px 0 0;">
                    <h5 class="nj-panel-title"><i class="fas fa-table"></i>New Joinee Details</h5>
                </div>

                <div class="nj-table-card" style="border-radius: 0 0 18px 18px;">
                    <table class="table table-bordered table-hover" id="newjoineetable" style="padding-top: 10px; width: 100%;">
                        <thead>
                            <tr>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Employee Name</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Joining Date</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Department</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Designation</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Reporting Manager</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Domain Head</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Domain</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Subdomain</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Tenure</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Latest Login</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
