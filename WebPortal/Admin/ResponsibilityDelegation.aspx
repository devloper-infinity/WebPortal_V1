<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ResponsibilityDelegation.aspx.cs" Inherits="WebPortal.Admin.ResponsibilityDelegation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="../assets/css/PMDelegationMaster.css" rel="stylesheet" />
    <style>
        .pm-hero-wrap {
            margin-bottom: 18px;
        }

        .pm-hero {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            padding: 20px 22px;
            border-radius: 18px;
            background: linear-gradient(120deg,#1d4ed8 0%,#2563eb 65%,#22c1dc 100%);
            color: #fff;
            box-shadow: 0 12px 28px rgba(37,99,235,.22);
        }

        .pm-hero-left {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .pm-hero-icon {
            width: 54px;
            height: 54px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.18);
            font-size: 25px;
        }

        .pm-hero-title {
            margin: 0;
            font-size: 23px;
            font-weight: 800;
        }

        .pm-hero-subtitle {
            margin: 4px 0 0;
            font-size: 13px;
            opacity: .92;
        }

        .pm-chip {
            background: rgba(255,255,255,.18);
            border: 1px solid rgba(255,255,255,.30);
            border-radius: 999px;
            padding: 9px 13px;
            font-weight: 700;
            font-size: 13px;
            white-space: nowrap;
        }

        .pm-card {
            background: #fff;
            border-radius: 18px;
            padding: 18px;
            box-shadow: 0 10px 25px rgba(15,23,42,.08);
            border: 1px solid #e5e7eb;
            margin-bottom: 18px;
        }

        .pm-form-grid {
            display: grid;
            grid-template-columns: repeat(4,minmax(0,1fr));
            gap: 14px;
        }

        .pm-field label {
            font-weight: 700;
            color: #334155;
            margin-bottom: 6px;
            display: block;
            font-size: 13px;
        }

        .pm-control {
            width: 100%;
            height: 40px;
            border: 1px solid #cbd5e1;
            border-radius: 10px;
            padding: 7px 10px;
            background: #fff;
        }

        .pm-field-full {
            grid-column: 1/-1;
        }

        .pm-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 16px;
        }

        .btn-pm {
            border: 0;
            border-radius: 10px;
            padding: 9px 18px;
            font-weight: 800;
            cursor: pointer;
        }

        .btn-pm-save {
            background: #2563eb;
            color: #fff;
        }

        .btn-pm-clear {
            background: #e2e8f0;
            color: #0f172a;
        }

        .pm-table-wrap {
            overflow-x: auto;
        }

        #tblPMDelegation {
            width: 100% !important;
        }

        .status-active {
            background: #dcfce7;
            color: #166534;
            padding: 4px 9px;
            border-radius: 999px;
            font-weight: 800;
            font-size: 12px;
        }

        .status-expired {
            background: #fee2e2;
            color: #991b1b;
            padding: 4px 9px;
            border-radius: 999px;
            font-weight: 800;
            font-size: 12px;
        }

        @media(max-width:992px) {
            .pm-form-grid {
                grid-template-columns: repeat(2,minmax(0,1fr));
            }

            .pm-hero {
                align-items: flex-start;
                flex-direction: column;
            }
        }

        @media(max-width:576px) {
            .pm-form-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>

    <script>

        $(document).ready(function () {

            pm_bindEmployees();
            pm_bindDelegationGrid();
        });

    </script>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

    <script src="../Scripts/Functions/Delegation.js?v=@DateTime.Now.Ticks"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="pm-hero-wrap">
        <div class="pm-hero">
            <div class="pm-hero-left">
                <div class="pm-hero-icon">
                    <i class="bi bi-person-check-fill"></i>
                </div>
                <div>
                    <h1 class="pm-hero-title">PM Responsibility Delegation</h1>
                    <p class="pm-hero-subtitle">Assign temporary PM responsibility to another user during absence.</p>
                </div>
            </div>
            <div class="pm-chip">
                <i class="bi bi-shield-check"></i>Acting PM Rights
           
            </div>
        </div>
    </div>

    <div class="pm-card">
        <input type="hidden" id="hdnDelegationID" value="0" />

        <div class="pm-form-grid">
            <div class="pm-field">
                <label>PM Name <span class="text-danger">*</span></label>
                <select id="ddlPMEmployee" class="pm-control"></select>
            </div>

            <div class="pm-field">
                <label>Acting PM Name <span class="text-danger">*</span></label>
                <select id="ddlActingEmployee" class="pm-control"></select>
            </div>

            <div class="pm-field">
                <label>From Date <span class="text-danger">*</span></label>
                <input type="date" id="txtFromDate" class="pm-control" />
            </div>

            <div class="pm-field">
                <label>To Date <span class="text-danger">*</span></label>
                <input type="date" id="txtToDate" class="pm-control" />
            </div>

            <div class="pm-field pm-field-full">
                <label>Remark</label>
                <textarea id="txtRemark" class="pm-control" style="height: 75px; resize: vertical;" maxlength="500"></textarea>
            </div>
        </div>

        <div class="pm-actions">
            <button type="button" class="btn-pm btn-pm-clear" onclick="pm_clearForm();">
                <i class="bi bi-arrow-clockwise"></i>Clear
           
            </button>
            <button type="button" class="btn-pm btn-pm-save" onclick="pm_saveDelegation();">
                <i class="bi bi-save"></i>Save
           
            </button>
        </div>
    </div>

    <div class="pm-card">
        <div class="pm-table-wrap">
            <table id="tblPMDelegation" class="table table-bordered table-striped">
                <thead>
                    <tr>
                        <th>Action</th>
                        <th>Sr #</th>
                        <th>PM Code</th>
                        <th>PM Name</th>
                        <th>Acting Code</th>
                        <th>Acting PM Name</th>
                        <th>From Date</th>
                        <th>To Date</th>
                        <th>Remark</th>
                        <th>Status</th>
                        <th>Added By</th>
                        <th>Added Date</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>

    <script src="../assets/js/PMDelegationMaster.js"></script>
</asp:Content>

