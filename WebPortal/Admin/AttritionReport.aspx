<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AttritionReport.aspx.cs" Inherits="WebPortal.Admin.AttritionReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        :root {
            --att-primary: #1d4ed8;
            --att-primary-2: #2563eb;
            --att-cyan: #22c1dc;
            --att-bg: #f4f7fb;
            --att-card: #ffffff;
            --att-text: #1f2937;
            --att-muted: #64748b;
            --att-border: #e5e7eb;
            --att-shadow: 0 12px 30px rgba(15, 23, 42, .08);
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

        .loading div {
            margin-top: 10px;
            color: var(--att-text);
            font-size: 13px;
            font-weight: 700;
        }

        .att-page {
          /*  padding: 18px 18px 30px;*/
            background: var(--att-bg);
            min-height: calc(100vh - 90px);
        }

        .att-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            gap: 22px;
            padding: 20px 25px;
            margin-bottom: 22px;
            border-radius: 20px;
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 55%, #22c1dc 100%);
            box-shadow: 0 18px 38px rgba(37, 99, 235, .24);
        }

        .att-hero:before {
            content: "";
            position: absolute;
            top: -95px;
            right: -70px;
            width: 310px;
            height: 310px;
            border-radius: 50%;
            background: rgba(255,255,255,.14);
        }

        .att-hero:after {
            content: "";
            position: absolute;
            left: -55px;
            bottom: -92px;
            width: 360px;
            height: 180px;
            border-radius: 50%;
            border: 2px solid rgba(255,255,255,.18);
            box-shadow: 38px -26px 0 rgba(255,255,255,.08), 90px -45px 0 rgba(255,255,255,.06);
        }

        .att-hero > * { position: relative; z-index: 2; }

        .att-hero-icon {
            width: 60px;
            height: 60px;
            min-width: 60px;
            border-radius: 20%;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 2px solid rgba(255,255,255,.75);
            background: rgba(255,255,255,.13);
            box-shadow: inset 0 0 0 6px rgba(255,255,255,.08);
        }

        .att-hero-icon i { font-size: 32px; color: #fff; }

        .att-kicker {
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 2px;
            text-transform: uppercase;
            opacity: .92;
            margin-bottom: 4px;
        }

        .att-title {
            margin: 0;
            font-size: 22px;
            font-weight: 800;
            color: #fff;
            line-height: 1.2;
        }

        .att-subtitle {
            margin: 8px 0 0;
            max-width: 850px;
            color: rgba(255,255,255,.92);
            font-size: 13px;
            line-height: 1.6;
        }

        .att-panel {
            background: var(--att-card);
            border: 1px solid var(--att-border);
            border-radius: 18px;
            box-shadow: var(--att-shadow);
            margin-bottom: 18px;
        }

        .att-panel-body { padding: 20px; }

        .att-filter-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(180px, 1fr));
            gap: 16px;
            align-items: end;
        }

        .att-field label {
            display: block;
            margin-bottom: 6px;
            color: #334155;
            font-size: 13px;
            font-weight: 700 !important;
        }

        .att-field .form-control {
            height: 40px;
            border-radius: 10px;
            border: 1px solid #dbe3ef;
            font-size: 13px;
            box-shadow: none;
        }

        .att-field .form-control:focus {
            border-color: var(--att-primary-2);
            box-shadow: 0 0 0 .15rem rgba(37, 99, 235, .14);
        }

        .att-actions {
            display: flex;
            gap: 12px;
            align-items: end;
        }

        .att-btn {
            height: 40px;
            min-width: 120px;
            border: 0;
            border-radius: 10px;
            color: #fff !important;
            font-weight: 700;
            font-size: 13px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: .2s ease;
        }

        .att-btn:hover { transform: translateY(-1px); box-shadow: 0 10px 18px rgba(15,23,42,.16); }
        .att-btn-primary { background: linear-gradient(120deg, #1d4ed8, #22c1dc); }
        .att-btn-success { background: linear-gradient(120deg, #10b981, #22c55e); }
        .att-btn-danger { background: linear-gradient(120deg, #ef4444, #f97316); }
        .att-btn-muted { background: #f1f5f9; color: #334155 !important; border: 1px solid #dbe3ef; }

        .att-tabs-card {
            background: var(--att-card);
            border: 1px solid var(--att-border);
            border-radius: 18px;
            box-shadow: var(--att-shadow);
            overflow: hidden;
        }

        .att-tabs-card .card-header {
            background: #f8fafc;
            border-bottom: 1px solid var(--att-border);
            padding: 12px 14px 0 !important;
        }

        .att-tabs-card .nav-tabs { border-bottom: 0; gap: 8px; }

        .att-tabs-card .nav-tabs .nav-link {
            border: 0;
            border-radius: 12px 12px 0 0;
            color: #475569;
            font-weight: 700;
            font-size: 13px;
            padding: 11px 18px;
            background: transparent;
        }

        .att-tabs-card .nav-tabs .nav-link.active {
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8, #22c1dc);
            box-shadow: 0 8px 18px rgba(37,99,235,.20);
        }

        .att-section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 8px 0 12px;
            color: #0f172a;
            font-size: 16px;
            font-weight: 800;
        }

        .att-section-title i {
            width: 34px;
            height: 34px;
            border-radius: 10px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8, #22c1dc);
        }

        .att-table-wrap {
            border: 1px solid var(--att-border);
            border-radius: 14px;
            padding: 10px;
            background: #fff;
            margin-bottom: 18px;
            overflow: hidden;
        }

        .table { margin-bottom: 0; }

        .table.dataTable thead th,
        .att-table-wrap table thead th {
            background: #edf3f6 !important;
            color: #0f172a !important;
            font-size: 12px;
            font-weight: 800;
            height: 42px;
            vertical-align: middle;
            border-bottom: 1px solid #dbe3ef !important;
            white-space: nowrap;
        }

        .table.dataTable tbody td,
        .att-table-wrap table tbody td {
            font-size: 12px;
            vertical-align: middle;
            color: #334155;
            background: #fff !important;
            white-space: nowrap;
        }

        .table.dataTable tbody tr:hover td { background: #f8fbff !important; }

        .dataTables_wrapper .dataTables_filter input,
        .dataTables_wrapper .dataTables_length select {
            border: 1px solid #dbe3ef;
            border-radius: 8px;
            padding: 5px 9px;
            height: 34px;
        }

        div.dt-buttons { float: left; margin-left: 12px; }
        .buttons-excel, .buttons-html5 {
            color: #fff !important;
            background: linear-gradient(120deg, #10b981, #22c55e) !important;
            border: 0 !important;
            border-radius: 9px !important;
            font-weight: 700 !important;
            padding: 6px 14px !important;
            margin: 0 6px 8px 0 !important;
        }

        #attexclude .modal-dialog { max-width: 1080px; }

        #attexclude .modal-content {
            border: 0;
            border-radius: 16px;
            overflow: hidden;
            background: #f8fafc;
            box-shadow: 0 26px 70px rgba(15, 23, 42, .28);
        }

        #attexclude .modal-header {
            position: relative;
            align-items: center;
            padding: 18px 22px;
            color: #fff;
            border-bottom: 0;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 52%, #22c1dc 100%);
        }

        #attexclude .att-popup-title {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 0;
        }

        #attexclude .att-popup-title i {
            width: 42px;
            height: 42px;
            min-width: 42px;
            border-radius: 12px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.16);
            border: 1px solid rgba(255,255,255,.34);
        }

        #attexclude .modal-title {
            margin: 0;
            color: #fff;
            font-size: 18px;
            font-weight: 800;
            line-height: 1.25;
        }

        #attexclude .modal-header .close {
            position: relative;
            z-index: 1;
            width: 38px;
            height: 38px;
            margin: 0 0 0 auto;
            padding: 0;
            border-radius: 50%;
            color: #fff;
            opacity: 1;
            text-shadow: none;
            background: rgba(255,255,255,.14);
            transition: .2s ease;
        }

        #attexclude .modal-header .close:hover {
            background: rgba(255,255,255,.24);
            transform: translateY(-1px);
        }

        #attexclude .modal-body {
            padding: 22px;
            max-height: calc(100vh - 220px);
            overflow-y: auto;
        }

        #attexclude .att-popup-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(220px, 1fr));
            gap: 14px;
        }

        #attexclude .att-popup-field {
            min-width: 0;
            padding: 12px 14px;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            background: #fff;
            box-shadow: 0 8px 20px rgba(15, 23, 42, .04);
        }

        #attexclude .att-popup-field-wide { grid-column: 1 / -1; }

        #attexclude .att-popup-label {
            display: block;
            margin: 0 0 7px;
            color: #64748b;
            font-size: 11px;
            font-weight: 800 !important;
            letter-spacing: 0;
            text-transform: uppercase;
        }

        #attexclude .att-readonly {
            min-height: 22px;
            margin: 0;
            padding: 0;
            color: #0f172a;
            background: transparent;
            border: 0 !important;
            box-shadow: none;
            display: block;
            font-size: 13px;
            font-weight: 700 !important;
            line-height: 1.5;
            white-space: normal;
            word-break: break-word;
        }

        #attexclude #attpop_reasontoexclude {
            width: 100%;
            min-height: 112px;
            resize: vertical;
            border-radius: 11px;
            border: 1px solid #cbd5e1;
            color: #0f172a;
            font-size: 13px;
            box-shadow: none;
        }

        #attexclude #attpop_reasontoexclude:focus {
            border-color: var(--att-primary-2);
            box-shadow: 0 0 0 .16rem rgba(37, 99, 235, .14);
        }

        #attexclude .modal-footer {
            gap: 10px;
            padding: 14px 22px;
            border-top: 1px solid #e2e8f0;
            background: #fff;
        }

        #attexclude .att-btn { min-width: 110px; }

        .text-nowrap, .nowrap { white-space: nowrap !important; }
        label:not(.form-check-label):not(.custom-file-label) { font-weight: 700 !important; border: none !important; }

        @media (max-width: 992px) {
            .att-filter-grid { grid-template-columns: repeat(2, minmax(180px, 1fr)); }
            .att-actions { grid-column: 1 / -1; }
            #attexclude .att-popup-grid { grid-template-columns: repeat(2, minmax(210px, 1fr)); }
        }

        @media (max-width: 576px) {
            .att-page { padding: 12px; }
            .att-hero { padding: 22px; align-items: flex-start; }
            .att-title { font-size: 24px; }
            .att-hero-icon { width: 58px; height: 58px; min-width: 58px; }
            .att-hero-icon i { font-size: 24px; }
            .att-filter-grid, #attexclude .att-popup-grid { grid-template-columns: 1fr; }
            .att-actions { flex-direction: column; align-items: stretch; }
            .att-btn { width: 100%; }
            #attexclude .modal-dialog { margin: .5rem; }
            #attexclude .modal-header,
            #attexclude .modal-body,
            #attexclude .modal-footer { padding: 16px; }
            #attexclude .modal-footer { flex-direction: column-reverse; }
        }
    </style>

    <script>
        $(document).ready(function () {
            attrition_binddomains();
            BindYear_Attrition();

            // AttritionDetails('26-May-2026', '25-Jun-2026', 9);
        });

        function attrition_Exporttoexcel() {
            __doPostBack("<%= btn21.UniqueID %>", '');
            return false;
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Button ID="btn21" runat="server" Style="display: none;" OnClick="btn1_Click" />

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div>One moment, please...</div>
    </div>

    <div class="att-page">
        <div class="att-hero">
            <span class="att-hero-icon"><i class="fas fa-chart-line"></i></span>
            <div>
                <h1 class="att-title">Attrition Report</h1>
                <p class="att-subtitle">Analyze employee exits, attrition percentage, cost impact and summary trends by month, location, domain and leadership group.</p>
            </div>
        </div>

        <div class="att-panel">
            <div class="att-panel-body">
                <div class="att-filter-grid">
                    <div class="att-field">
                        <label for="attrition_from"><i class="far fa-calendar-alt mr-1"></i>From Date</label>
                        <input type="date" id="attrition_from" name="attrition_from" class="form-control" />
                        <select id="attrition_month" name="attrition_month" class="form-control" style="display: none;">
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

                    <div class="att-field">
                        <label for="attrition_to"><i class="far fa-calendar-check mr-1"></i>To Date</label>
                        <input type="date" id="attrition_to" name="attrition_to" class="form-control" />
                        <select id="attrition_year" name="attrition_year" class="form-control" style="display: none;">
                            <option value="">Select</option>
                        </select>
                    </div>

                    <div class="att-field">
                        <label for="attrition_domain"><i class="fas fa-sitemap mr-1"></i>Domain</label>
                        <select id="attrition_domain" name="attrition_domain" class="form-control"></select>
                    </div>

                    <div class="att-actions">
                        <button id="attrition_btnShow" type="button" class="att-btn att-btn-primary" onclick="return attrition_Submit();">
                            <i class="fas fa-search"></i> Show
                        </button>
                        <button id="attrition_btnExporttoexcel" type="button" class="att-btn att-btn-success" onclick="return attrition_Exporttoexcel();">
                            <i class="fas fa-file-excel"></i> Export
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <div class="card card-tabs att-tabs-card">
            <div class="card-header p-0 pt-1">
                <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true"><i class="fas fa-chart-pie mr-1"></i>Summary</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false"><i class="fas fa-list mr-1"></i>Details</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" onclick="return bindexcludedemployees();" id="custom-tabs-one-exclude-tab" data-toggle="pill" href="#custom-tabs-one-exclude" role="tab" aria-controls="custom-tabs-one-exclude" aria-selected="false"><i class="fas fa-user-slash mr-1"></i>Excluded Employees</a>
                    </li>
                </ul>
            </div>

            <div class="card-body">
                <div class="tab-content" id="custom-tabs-one-tabContent">
                    <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                        <div class="att-section-title"><i class="fas fa-calendar-alt"></i>Month wise Summary</div>
                        <div class="att-table-wrap">
                            <table class="table table-hover table-bordered nowrap" id="attrition_monthsummary" style="width: 100%;">
                                <thead>
                                    <tr>
                                        <th>Month</th><th>Year</th><th>Opening Count</th><th>New Joiners</th><th>Exit Employees</th><th>Remaining Employees</th><th>Excluded Employees</th><th>Attrition %</th><th>Attrition Cost</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>

                        <div class="att-section-title"><i class="fas fa-map-marker-alt"></i>Location wise Summary</div>
                        <div class="att-table-wrap">
                            <table class="table table-hover table-bordered nowrap" id="attrition_locationsummary" style="width: 100%;">
                                <thead>
                                    <tr>
                                        <th>Branch</th><th>Opening Count</th><th>New Joiners</th><th>Exit Employees</th><th>Remaining Employees</th><th>Excluded Employees</th><th>Attrition %</th><th>Attrition Cost</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>

                        <div class="att-section-title"><i class="fas fa-sitemap"></i>Domain wise Summary</div>
                        <div class="att-table-wrap">
                            <table class="table table-hover table-bordered nowrap" id="attrition_domainsummary" style="width: 100%;">
                                <thead>
                                    <tr>
                                        <th>Domain</th><th>Opening Count</th><th>New Joiners</th><th>Exit Employees</th><th>Remaining Employees</th><th>Excluded Employees</th><th>Attrition %</th><th>Attrition Cost</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>

                        <div class="att-section-title"><i class="fas fa-tags"></i>Category wise Summary</div>
                        <div class="att-table-wrap">
                            <table class="table table-hover table-bordered nowrap" id="attrition_categorysummary" style="width: 100%;">
                                <thead style="text-align: center;"><tr></tr></thead>
                                <tbody></tbody>
                            </table>
                        </div>

                        <div class="att-section-title"><i class="fas fa-user-tie"></i>Domain Head wise Summary</div>
                        <div class="att-table-wrap">
                            <table class="table table-hover table-bordered nowrap" id="attrition_domainheadsummary" style="width: 100%;">
                                <thead>
                                    <tr>
                                        <th>Domain Head</th><th>Opening Count</th><th>New Joiners</th><th>Exit Employees</th><th>Remaining Employees</th><th>Excluded Employees</th><th>Attrition %</th><th>Attrition Cost</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>

                        <div class="att-section-title"><i class="fas fa-user-friends"></i>Location Head wise Summary</div>
                        <div class="att-table-wrap">
                            <table class="table table-hover table-bordered nowrap" id="attrition_locationheadsummary" style="width: 100%;">
                                <thead>
                                    <tr>
                                        <th>Location Head</th><th>Opening Count</th><th>New Joiners</th><th>Exit Employees</th><th>Remaining Employees</th><th>Excluded Employees</th><th>Attrition %</th><th>Attrition Cost</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                        <div class="att-section-title"><i class="fas fa-users"></i>Attrition Details</div>
                        <div class="att-table-wrap" style="overflow:auto;">
                            <table class="table table-hover table-bordered nowrap" id="attritiontable" style="width: 100%;">
                                <thead>
                                    <tr>
                                        <th>Actions</th><th>Month</th><th>Year</th><th>Code</th><th>Employee Name</th><th>Pseudo Name</th><th>Joining Date</th><th>Branch</th><th>Domain</th><th>Subdomain</th><th>Department</th><th>Designation</th><th>Reporting Manager</th><th>Domain Head</th><th>Location Head</th><th>Tenure</th><th>Current Status</th><th>Resignation Date</th><th>Last Working Date</th><th>PM/ System Remark</th><th>Domain Head Remark</th><th>Category</th><th>Attrition Cost</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="custom-tabs-one-exclude" role="tabpanel" aria-labelledby="custom-tabs-one-exclude-tab">
                        <div class="att-section-title"><i class="fas fa-user-slash"></i>Excluded Employees</div>
                        <div class="att-table-wrap">
                            <table class="table table-hover table-bordered nowrap" id="excludetable" style="width: 100%;">
                                <thead>
                                    <tr>
                                        <th>Code</th><th>Employee Name</th><th>Pseudoname</th><th>Joining Date</th><th>Branch</th><th>Domain</th><th>Subdomain</th><th>Department</th><th>Designation</th><th>Reporting Manager</th><th>Tenure</th><th>Current Status</th><th>Resignation Date</th><th>Last Working Date</th><th>PM/ System Remark</th><th>Domain Head Remark</th><th>Category</th><th>Reason to exclude</th>
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

    <div class="modal fade" id="attexclude">
        <div class="modal-dialog modal-xl modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="att-popup-title">
                        <i class="fas fa-user-slash"></i>
                        <h4 class="modal-title">Exclude Employee From Report</h4>
                    </div>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="att-popup-grid">
                        <div class="att-popup-field">
                            <label class="att-popup-label">Employee</label>
                            <label id="attpop_empname" name="attpop_empname" class="att-readonly"></label>
                        </div>
                        <div class="att-popup-field">
                            <label class="att-popup-label">Joining Date</label>
                            <label id="attpop_doj" name="attpop_doj" class="att-readonly"></label>
                        </div>
                        <div class="att-popup-field">
                            <label class="att-popup-label">Reporting Manager</label>
                            <label id="attpop_reportingmanager" name="attpop_reportingmanager" class="att-readonly"></label>
                        </div>
                        <div class="att-popup-field">
                            <label class="att-popup-label">Resignation Type</label>
                            <label id="attpop_resignationtype" name="attpop_resignationtype" class="att-readonly"></label>
                        </div>
                        <div class="att-popup-field">
                            <label class="att-popup-label">Resignation Date</label>
                            <label id="attpop_resignationdate" name="attpop_resignationdate" class="att-readonly"></label>
                        </div>
                        <div class="att-popup-field">
                            <label class="att-popup-label">Last Working Date</label>
                            <label id="attpop_lastworkingdate" name="attpop_lastworkingdate" class="att-readonly"></label>
                        </div>
                        <div class="att-popup-field">
                            <label class="att-popup-label">Step 1 Remark</label>
                            <label id="attpop_step1remark" name="attpop_step1remark" class="att-readonly"></label>
                        </div>
                        <div class="att-popup-field">
                            <label class="att-popup-label">Step 2 Remark</label>
                            <label id="attpop_step2remark" name="attpop_step2remark" class="att-readonly"></label>
                        </div>
                        <div class="att-popup-field">
                            <label class="att-popup-label">Step 3 Remark</label>
                            <label id="attpop_step3remark" name="attpop_step3remark" class="att-readonly"></label>
                        </div>
                        <div class="att-popup-field att-popup-field-wide">
                            <label class="att-popup-label">Reason to exclude</label>
                            <textarea id="attpop_reasontoexclude" name="attpop_reasontoexclude" class="form-control" maxlength="500"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="att-btn att-btn-muted" data-dismiss="modal"><i class="fas fa-times"></i> Close</button>
                    <button class="att-btn att-btn-primary" type="button" id="attpop_btnexclude" onclick="attpop_Addexcluderemark();"><i class="fas fa-save"></i> Update</button>
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

        .dataTables_scrollBody {
            min-height: 20px !important;
            height: auto !important;
        }

        .btn-gradient-primary {
            /*  background: linear-gradient(135deg, #4da6ff, #1a8cff);*/
            background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;
            color: #fff;
            border-radius: 7px;
            width: 100%;
            height: 35px;
            font-weight: 400;
            transition: 0.3s;
        }

            .btn-gradient-primary:hover {
                transform: translateY(-2px);
                /*background: linear-gradient(135deg, #4da6ff, #1a8cff);*/
                background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;
                color: #fff;
            }

        .btn-gradient-success {
            background: linear-gradient(135deg, #1cc88a, #13855c);
            color: #fff;
            border-radius: 7px;
            height: 35px;
            width: 100%;
            font-weight: 400;
            transition: 0.3s;
        }

            .btn-gradient-success:hover {
                transform: translateY(-2px);
                color: #fff;
            }
    </style>

    <script>
        $(document).ready(function () {
            // AttritionDetails("26-Jun-2025", "25-Jul-2025", 0);
            attrition_binddomains();
            BindYear_Attrition();
        });

        function attrition_Exporttoexcel() {
            __doPostBack("<%= btn21.UniqueID %>", '');
            return false;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Button ID="btn21" runat="server" Style="display: none;" OnClick="btn1_Click" />
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Attrition Report</b></h6>
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
                        <td><b>From Date:</b></td>
                        <td>
                            <input type="date" id="attrition_from" name="attrition_from" class="form-control" style="width: 170px;" />
                            <select id="attrition_month" name="attrition_month" class="form-control" style="display: none;">
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
                        <td>
                            <b>To Date:</b>
                        </td>
                        <td>
                            <input type="date" id="attrition_to" name="attrition_to" class="form-control" style="width: 170px;" />
                            <select id="attrition_year" name="attrition_year" class="form-control" style="display: none;">
                                <option value="">Select</option>
                            </select>
                        </td>
                        <td><b>Domain:</b></td>
                        <td>
                            <select id="attrition_domain" name="attrition_domain" class="form-control" style="width: 170px;"></select>
                        </td>
                        <td>
                            <button id="attrition_btnShow" class="btn btn-gradient-primary w-100" onclick="return attrition_Submit()">Show</button>
                        </td>
                        <td>
                            <button id="attrition_btnExporttoexcel" class="btn btn-gradient-success flex-grow-1" style="background: linear-gradient(to right, #ffbf96, #fe7096);" onclick="return attrition_Exporttoexcel();">Export to excel</button>

                        </td>
                    </tr>
                </table>
                <hr />
                <div class="card card-tabs">
                    <div class="card-header p-0 pt-1">
                        <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Summary</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">Details</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" onclick="return bindexcludedemployees();" id="custom-tabs-one-exclude-tab" data-toggle="pill" href="#custom-tabs-one-exclude" role="tab" aria-controls="custom-tabs-one-exclude" aria-selected="false">Excluded Employees</a>
                            </li>

                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                                <div class="col-lg-12">
                                    <div class="row">
                                        <div class="col-lg-12">
                                            <h5 class="card-title">Month wise Summary</h5>
                                            <table class="table" id="attrition_monthsummary" style="padding-top: 10px; width: 100%;">
                                                <thead>
                                                    <tr>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Month</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Year</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Opening Count</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">New Joiners</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Exit Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Remaining Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Excluded Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attrition %</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attrition Cost</th>
                                                    </tr>
                                                </thead>
                                                <tbody></tbody>
                                            </table>
                                            <hr />
                                        </div>
                                        <div class="col-lg-12">
                                            <h5 class="card-title">Location wise Summary</h5>
                                            <table class="table" id="attrition_locationsummary" style="padding-top: 10px; width: 100%;">
                                                <thead>
                                                    <tr>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Branch</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Opening Count</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">New Joiners</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Exit Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Remaining Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Excluded Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attrition %</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attrition Cost</th>
                                                    </tr>
                                                </thead>
                                                <tbody></tbody>
                                            </table>
                                            <hr />
                                        </div>
                                        <div class="col-lg-12">
                                            <h5 class="card-title">Domain wise Summary</h5>
                                            <table class="table" id="attrition_domainsummary" style="padding-top: 10px; width: 100%;">
                                                <thead>
                                                    <tr>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Domain</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Opening Count</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">New Joiners</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Exit Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Remaining Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Excluded Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attrition %</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attrition Cost</th>
                                                    </tr>
                                                </thead>
                                                <tbody></tbody>
                                            </table>
                                            <hr />
                                        </div>
                                        <div class="col-lg-12">
                                            <h5 class="card-title">Category wise Summary</h5>
                                            <table class="table" id="attrition_categorysummary" style="padding-top: 10px; width: 100%;">
                                                <thead style="text-align: center;">
                                                    <tr></tr>
                                                </thead>
                                            </table>
                                            <hr />
                                        </div>
                                        <div class="col-lg-12">
                                            <h5 class="card-title">Domain Head wise Summary</h5>
                                            <table class="table" id="attrition_domainheadsummary" style="padding-top: 10px; width: 100%;">
                                                <thead>
                                                    <tr>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Domain Head</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Opening Count</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">New Joiners</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Exit Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Remaining Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Excluded Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attrition %</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attrition Cost</th>
                                                    </tr>
                                                </thead>
                                                <tbody></tbody>
                                            </table>
                                            <hr />
                                        </div>
                                        <div class="col-lg-12">
                                            <h5 class="card-title">Location Head wise Summary</h5>
                                            <table class="table" id="attrition_locationheadsummary" style="padding-top: 10px; width: 100%;">
                                                <thead>
                                                    <tr>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Location Head</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Opening Count</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">New Joiners</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Exit Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Remaining Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Excluded Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attrition %</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attrition Cost</th>
                                                    </tr>
                                                </thead>
                                                <tbody></tbody>
                                            </table>
                                            <hr />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                                <table class="table" id="attritiontable" style="padding-top: 10px; width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Actions</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Month</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Year</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: left;">Employee Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Pseudo Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Joining Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Domain</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Subdomain</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Department</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Designation</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Reporting Manager</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Domain Head</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Location Head</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Tenure</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Current Status</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Resignation Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Last Working Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: left;">PM/ System Remark</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Domain Head Remark</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Category</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Attrition Cost</th>
                                        </tr>

                                    </thead>
                                    <tbody></tbody>

                                </table>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-exclude" role="tabpanel" aria-labelledby="custom-tabs-one-exclude-tab">
                                <table class="table" id="excludetable" style="padding-top: 10px; width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Employee Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Pseudoname</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Joining Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Domain</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Subdomain</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Department</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Designation</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Reporting Manager</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Tenure</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Current Status</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Resignation Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Last Working Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">PM/ System Remark</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Domain Head Remark</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Category</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Reason to exclude</th>
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

    <div class="modal fade" id="attexclude">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Exclude Employee From Report</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table table-responsive">
                        <tr>
                            <td><b>Employee:</b></td>
                            <td>
                                <label id="attpop_empname" name="attpop_empname" class="form-control" style="width: 300px;"></label>
                            </td>
                            <td><b>Joining Date:</b></td>
                            <td>
                                <label id="attpop_doj" name="attpop_doj" class="form-control" style="width: 300px;"></label>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Reporting Manager</b></td>
                            <td>
                                <label id="attpop_reportingmanager" name="attpop_reportingmanager" class="form-control" style="width: 300px;"></label>
                            </td>
                            <td><b>Resignation Type:</b></td>
                            <td>
                                <label id="attpop_resignationtype" name="attpop_resignationtype" class="form-control" style="width: 300px;"></label>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Resignation Date:</b></td>
                            <td>
                                <label id="attpop_resignationdate" name="attpop_resignationdate" class="form-control" style="width: 300px;"></label>
                            </td>
                            <td><b>Last Working Date:</b></td>
                            <td>
                                <label id="attpop_lastworkingdate" name="attpop_lastworkingdate" class="form-control" style="width: 300px;"></label>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Step 1 Remark:</b></td>
                            <td>
                                <label id="attpop_step1remark" name="attpop_step1remark" class="form-control" style="width: 300px;"></label>
                            </td>
                            <td><b>Step 2 Remark:</b></td>
                            <td>
                                <label id="attpop_step2remark" name="attpop_step2remark" class="form-control" style="width: 300px;"></label>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Step 3 Remark:</b></td>
                            <td>
                                <label id="attpop_step3remark" name="attpop_step3remark" class="form-control" style="width: 300px;"></label>
                            </td>
                            <td><b>Reason to exclude:</b></td>
                            <td>
                                <textarea id="attpop_reasontoexclude" name="attpop_reasontoexclude" class="form-control" style="width: 300px;" maxlength="500"></textarea>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button class="btn btn-primary" type="button" id="attpop_btnexclude" onclick="attpop_Addexcluderemark();">Update</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>--%>
