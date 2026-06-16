<%@ Page Title="" Language="C#" MasterPageFile="~/Accounts/Accounts.Master" AutoEventWireup="true" CodeBehind="AdvanceMaster.aspx.cs" Inherits="WebPortal.Accounts.AdvanceMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        body {
            background: #f4f7fb;
        }

        .dashboard-header {
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            border-radius: 15px;
            padding: 12px;
            color: white;
            position: relative;
            overflow: hidden;
            margin-bottom: 25px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        }

            .dashboard-header::after {
                content: '';
                position: absolute;
                right: -70px;
                top: -50px;
                width: 220px;
                height: 220px;
                background: rgba(255,255,255,0.12);
                border-radius: 50%;
            }

        .dashboard-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .dashboard-subtitle {
            font-size: 12px;
            opacity: 0.9;
        }
    </style>

    <style>
        .card {
            border-radius: 12px;
        }

        .form-label {
            margin-bottom: 6px;
            color: #495057;
            font-size: 13px;
             
        }

        .form-control,
        .form-select {
            height: 35px;
            width: 100%;
            border-radius: 8px;
        margin-bottom: 15px;    
        }

        #adv_btnSubmit {
            min-width: 160px;
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
        }

        .card-header {
            border-radius: 12px 12px 0 0 !important;
        }
    </style>

    <script>
        $(document).ready(function () {
            BindYears();
            BindUsers();
            GetAllAdvanceEntries();
        });

    </script>

    <script src="../Scripts/Accounts/Advance.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="dashboard-header">
        <div class="d-flex justify-content-between align-items-start mb-1">
            <div>
                <div class="dashboard-title">
                    <i class="fas fa-money-check-alt mr-2"></i>
                    Advance Master
                </div>

                <div class="dashboard-subtitle">
                    Manage employee advance payments, installments, balances, and repayment tracking.
                </div>
            </div>
        </div>
    </div>

    <div class="card shadow-sm border-0">
        <div class="card-body">
            <!-- Row 1 -->
            <div class="row g-3">

                <div class="col-md-3">
                    <label class="form-label fw-semibold">Employee</label>
                    <select id="adv_employee" class="form-select" onchange="adv_getSalary(this);">
                        <option value="">Select Employee</option>
                    </select>
                </div>

                <div class="col-md-3">
                    <label class="form-label fw-semibold">Month</label>
                    <select id="adv_Month" class="form-select">
                        <option value="Select">Select</option>
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

                <div class="col-md-3">
                    <label class="form-label fw-semibold">Year</label>
                    <select id="adv_Year" class="form-select"></select>
                </div>

                <div class="col-md-3">
                    <label class="form-label fw-semibold">Salary</label>
                    <input type="text" id="adv_Salary" class="form-control bg-light" readonly />
                </div>

            </div>

            <!-- Row 2 -->
            <div class="row g-3 mt-1">

                <div class="col-md-3">
                    <label class="form-label fw-semibold">Amount</label>
                    <input type="number" id="adv_Amount" class="form-control" />
                </div>

                <div class="col-md-3">
                    <label class="form-label fw-semibold">Installment</label>
                    <input type="number" id="adv_Installment" class="form-control" />
                </div>

                <div class="col-md-6">
                    <label class="form-label fw-semibold">Remark</label>
                    <input type="text" id="adv_Remark" class="form-control" />
                </div>
            </div>

            <!-- Row 3 -->
            <div class="row mt-4">
                <div class="col-md-6">
                    <div class="modern-switch">
                        <label class="switch">
                            <input type="checkbox" id="adv_chkDoNotDeduct"><span class="slider"></span></label>
                        <div class="switch-content">
                            <label for="adv_chkDoNotDeduct" class="switch-title"><b>Do Not Deduct</b></label>
                            <small class="switch-subtitle">Skip deduction for current month only</small>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <button type="button" id="adv_btnSubmit" onclick="InsertAdvance()" class="btn btn-primary px-4"><i class="fa fa-save"></i>&nbsp;&nbsp;Save Advance</button>
                </div>
            </div>
        </div>
    </div>

    <hr />

    <table id="adv_tblAdvance" class="display table table-bordered" style="width: 100%">
        <thead>
            <tr>
                <th>Action</th>
                <th>Sr. No</th>
                <th>Code</th>
                <th>Name</th>
                <th>Month</th>
                <th>Year</th>
                <th>Amount</th>
                <th>Installment</th>
                <th>Balance</th>
                <th>Remark</th>
                <th>Status</th>
                <th>Added By</th>
                <th>Added Date</th>

            </tr>
        </thead>
    </table>

    <style>
        .modern-switch {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 15px;
            border: 1px solid #e5e7eb;
            border-radius: 10px;
            background: #f8fafc;
        }

        .switch {
            position: relative;
            display: inline-block;
            width: 52px;
            height: 28px;
            margin: 0;
        }

            .switch input {
                opacity: 0;
                width: 0;
                height: 0;
            }

        .slider {
            position: absolute;
            cursor: pointer;
            inset: 0;
            background-color: #d1d5db;
            transition: .3s;
            border-radius: 50px;
        }

            .slider:before {
                position: absolute;
                content: "";
                height: 22px;
                width: 22px;
                left: 3px;
                bottom: 3px;
                background-color: white;
                transition: .3s;
                border-radius: 50%;
            }

        .switch input:checked + .slider {
            background-color: #0d6efd;
        }

            .switch input:checked + .slider:before {
                transform: translateX(24px);
            }

        .switch-content {
            display: flex;
            flex-direction: column;
        }

        .switch-title {
            margin: 0;
            font-weight: 600;
            color: #212529;
            cursor: pointer;
        }

        .switch-subtitle {
            color: #6c757d;
            font-size: 12px;
        }
    </style>
</asp:Content>
