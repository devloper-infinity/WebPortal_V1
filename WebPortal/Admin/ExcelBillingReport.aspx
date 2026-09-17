<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ExcelBillingReport.aspx.cs" Inherits="WebPortal.Admin.ExcelBillingReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        .ebr-page { padding: 20px 0 32px; color: #343a40; }
        .ebr-hero { display:flex; align-items:center; justify-content:space-between; gap:18px; margin-bottom:18px; padding:20px 24px; color:#fff; background:linear-gradient(120deg,#173b7a 0%,#2357a7 62%,#2878c8 100%); border-radius:.35rem; box-shadow:0 8px 22px rgba(23,59,122,.22); position:relative; overflow:hidden; }
        .ebr-hero:after { content:""; position:absolute; width:190px; height:190px; right:-58px; top:-92px; border-radius:50%; background:rgba(255,255,255,.1); }
        .ebr-heading { display:flex; align-items:center; gap:14px; position:relative; z-index:1; }
        .ebr-heading-icon { width:48px; height:48px; display:flex; align-items:center; justify-content:center; border-radius:12px; background:rgba(255,255,255,.15); font-size:21px; }
        .ebr-heading h4 { margin:0 0 3px; font-size:21px; font-weight:600; }
        .ebr-heading p { margin:0; color:rgba(255,255,255,.82); font-size:13px; }
        .ebr-back { position:relative; z-index:1; display:inline-flex; align-items:center; gap:7px; padding:9px 13px; border:1px solid rgba(255,255,255,.5); border-radius:.25rem; color:#fff!important; font-size:13px; font-weight:600; text-decoration:none!important; background:rgba(255,255,255,.1); }
        .ebr-back:hover { background:#fff; color:#173b7a!important; }
        .ebr-card { margin-bottom:18px; background:#fff; border:1px solid rgba(0,0,0,.125); border-top:3px solid #007bff; border-radius:.25rem; box-shadow:0 0 1px rgba(0,0,0,.125),0 1px 3px rgba(0,0,0,.16); }
        .ebr-card-header { padding:13px 18px; border-bottom:1px solid #e5e7eb; font-weight:600; font-size:16px; }
        .ebr-card-header i { margin-right:8px; color:#007bff; }
        .ebr-card-body { padding:18px; }
        .ebr-filter-grid { display:grid; grid-template-columns:repeat(3,minmax(190px,1fr)) auto; gap:16px; align-items:end; }
        .ebr-field label { display:block; margin-bottom:6px; color:#495057; font-size:13px; font-weight:600; }
        .ebr-field .form-control { width:100%; height:38px; border-color:#ced4da; border-radius:.25rem; }
        .ebr-show { min-width:105px; height:38px; border:1px solid #007bff; border-radius:.25rem; color:#fff; background:#007bff; font-weight:600; }
        .ebr-show:hover { background:#0069d9; border-color:#0062cc; }
        .ebr-table-card { padding:0; overflow:hidden; }
        .ebr-table-scroll { width:100%; overflow-x:auto; padding:0 16px 16px; }
        .ebr-table-scroll .table { width:100%!important; min-width:1100px; margin-bottom:0; }
        .table.dataTable th { background:#f4f6f9!important; color:#343a40; border-bottom:2px solid #dee2e6!important; white-space:nowrap; font-size:12px; font-weight:600; }
        .table.dataTable td { background:#fff; border-top:1px solid #edf0f2; font-size:12px; vertical-align:middle; }
        .table.dataTable tbody tr:hover td { background:#f8fbff; }
        .dataTables_wrapper { padding-top:14px; }
        .dataTables_paginate { float:right!important; }
        div.dt-buttons { position:static; float:left; padding-left:0; }
        .buttons-excel { margin:0 8px 8px 0!important; padding:.42rem .75rem!important; color:#fff!important; background:#28a745!important; border:1px solid #28a745!important; border-radius:.25rem!important; box-shadow:none!important; font-weight:600; }
        .dt-center { text-align:center; }
        .loading { display:none; position:fixed; inset:0; z-index:99999; width:auto; height:auto; margin:0; padding:0; border-radius:0; background:rgba(15,23,42,.58); align-items:center; justify-content:center; text-align:center; opacity:1; }
        .loading > div { position:absolute; left:50%; top:50%; transform:translate(-50%,-50%); min-width:190px; padding:24px 28px; background:#fff; border-radius:.35rem; box-shadow:0 18px 50px rgba(0,0,0,.3); }
        .loading img { width:52px; height:52px; object-fit:contain; margin-bottom:8px; }
        @media(max-width:991px) { .ebr-filter-grid { grid-template-columns:repeat(2,minmax(180px,1fr)); } }
        @media(max-width:575px) { .ebr-page { padding-top:12px; } .ebr-hero { align-items:flex-start; flex-direction:column; padding:17px; } .ebr-filter-grid { grid-template-columns:1fr; } .ebr-show,.ebr-back { width:100%; justify-content:center; } }
    </style>

    <script>

        $(document).ready(function () {

            BindDomainWise_ExcelProject(9);
            //Excel_bindDeals();
            //excelBilling_BindDetails();
        });

    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="loading" id="load1">
        <div><img src="../images/Load_1.gif" alt="Loading" />
            <div style="font-size: 13px; font-weight: 600;">One moment, please...</div>
        </div>
    </div>

    <div class="ebr-page">
        <div class="ebr-hero">
            <div class="ebr-heading">
                <div class="ebr-heading-icon"><i class="fas fa-file-excel"></i></div>
                <div>
                    <h4>Excel Billing Report</h4>
                    <p>Review and export billing records submitted from imported Excel files.</p>
                </div>
            </div>
            <a href="OtherBilling.aspx" class="ebr-back"><i class="fas fa-arrow-left"></i><span>Import Billing Excel</span></a>
        </div>

        <div class="ebr-card">
            <div class="ebr-card-header"><i class="fas fa-filter"></i>Report Filters</div>
            <div class="ebr-card-body">
                <div class="ebr-filter-grid">
                    <div class="ebr-field"><label for="excelBilling_ProjectType">Project Type</label>
                        <select id="excelBilling_ProjectType" name="excelBilling_ProjectType" class="form-control">
                            <option value="Select">Select</option>
                            <option value="Rebuttal">Condition Clearing</option>
                            <option value="Research">Research</option>
                        </select>
                    </div>
                    <div class="ebr-field"><label for="excelBilling_Project">Project</label>
                        <select id="excelBilling_Project" name="excelBilling_Project" class="form-control" onchange="return Excel_bindDeals(this);"></select>
                    </div>
                    <div class="ebr-field"><label for="excelBilling_DealNo">Deal #</label>
                        <select id="excelBilling_DealNo" name="excelBilling_DealNo" class="form-control"></select>
                    </div>
                    <button type="button" id="excelBilling_Submit" name="excelBilling_Submit" class="ebr-show" onclick="return btnexcelBilling_Submit();"><i class="fas fa-search"></i>&nbsp; Show</button>
                </div>
            </div>
        </div>

        <div class="ebr-card ebr-table-card">
            <div class="ebr-card-header"><i class="fas fa-table"></i>Billing Details</div>
            <div class="ebr-table-scroll">
                <table class="table" id="table_excelRebuttal" style="display: none;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="width: 50px;">Sr. #</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Deal #</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Loan #</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Condition</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Clients Rebuttal</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Cleared (Yes/No)</th>
                            <th class="sort border-top ps-3" style="width: 150px;">End Date/Time</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Total Time</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Infinity Response</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Time</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Billing Type</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>


                <table class="table" id="table_excelResearch" style="display: none;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="width: 50px;">Sr. #</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Deal #</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Deal Name</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Subject Line</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Requested Docs/Tasks Performed</th>
                            <th class="sort border-top ps-3" style="width: 100px;">No of Loans/Docs</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Total Time Taken (in Minutes)</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Request Received from</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Request Received Date</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Documents Delivered Date</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Remark</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Time (In Hours)</th>
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
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    </div>


</asp:Content>
