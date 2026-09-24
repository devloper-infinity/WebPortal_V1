<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ExpensesAdmin.aspx.cs" Inherits="WebPortal.Admin.ExpensesAdmin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        :root {
            --posh-primary: #1d4ed8;
            --posh-primary-2: #2563eb;
            --posh-accent: #22c1dc;
            --posh-bg: #f4f7fb;
            --posh-card: #ffffff;
            --posh-border: #dbe5f1;
            --posh-text: #0f172a;
            --posh-muted: #64748b;
            --posh-soft: #eef6ff;
        }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            margin: auto;
            width: 192px;
            height: 192px;
            opacity: .9;
            border-radius: 25px;
            z-index: 99999;
            text-align: center;
            background: rgba(255,255,255,.85);
            box-shadow: 0 20px 45px rgba(15, 23, 42, .18);
            padding-top: 28px;
        }


        .Expenses-hero {
            position: relative;
            overflow: hidden;
            border-radius: 22px;
            padding: 20px 22px;
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 62%, #22c1dc 100%);
            box-shadow: 0 18px 38px rgba(37, 99, 235, .24);
            margin-bottom: 18px;
        }

            .Expenses-hero:before,
            .Expenses-hero:after {
                content: "";
                position: absolute;
                border-radius: 999px;
                background: rgba(255,255,255,.15);
            }

            .Expenses-hero:before {
                width: 230px;
                height: 230px;
                top: -120px;
                right: -80px;
            }

            .Expenses-hero:after {
                width: 140px;
                height: 140px;
                bottom: -70px;
                left: 34%;
            }

        .Expenses-hero-inner {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            flex-wrap: wrap;
        }

        .Expenses-title-wrap {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .Expenses-hero-icon {
            width: 58px;
            height: 58px;
            border-radius: 18px;
            background: rgba(255,255,255,.18);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 26px;
            box-shadow: inset 0 0 0 1px rgba(255,255,255,.25);
        }

        .Expenses-hero h3 {
            margin: 0;
            font-size: 21px;
            font-weight: 800;
            letter-spacing: .2px;
        }

        .Expenses-hero p {
            margin: 4px 0 0;
            color: rgba(255,255,255,.88);
            font-size: 12px;
        }

        .Expenses-chip {
            padding: 9px 15px;
            border-radius: 999px;
            background: rgba(255,255,255,.16);
            color: #fff;
            font-weight: 700;
            font-size: 12px;
            border: 1px solid rgba(255,255,255,.22);
        }

        .Expenses-card {
            background: var(--posh-card);
            border: 1px solid var(--posh-border);
            border-radius: 20px;
            box-shadow: 0 10px 28px rgba(15, 23, 42, .07);
            margin-bottom: 18px;
            overflow: hidden;
        }

        .Expenses-card-header {
            padding: 17px 20px;
            border-bottom: 1px solid #edf2f7;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            flex-wrap: wrap;
            background: linear-gradient(180deg, #ffffff 0%, #f8fbff 100%);
        }

        .Expenses-section-title {
            display: flex;
            align-items: center;
            gap: 5px;
            font-weight: 800;
            color: var(--posh-text);
            margin: 0;
            font-size: 16px;
        }

            .Expenses-section-title i {
                width: 30px;
                height: 30px;
                border-radius: 12px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                color: #fff;
                background: linear-gradient(135deg, var(--posh-primary-2), var(--posh-accent));
                margin-left: 10px;
                margin-right: 5px;
            }

        .Expenses-card-body {
            padding: 22px;
        }




        .Expenses-hint {
            color: var(--posh-muted);
            font-size: 12px;
            margin: 0;
        }

        .Expenses-grid-wrap {
            width: 100%;
            overflow-x: auto;
            padding: 4px;
        }




        @media (max-width: 768px) {


            .Expenses-hero {
                padding: 20px;
                border-radius: 18px;
            }

                .Expenses-hero h3 {
                    font-size: 20px;
                }

            .Expenses-card-body {
                padding: 16px;
            }


            .Expenses-actions {
                justify-content: stretch;
            }

            #Expenses_btnsubmit {
                width: 100%;
            }
        }

        .dp-field .form-control,
        .dp-field select,
        .dp-field textarea,
        .dp-inline-time select {
            width: 100% !important;
            border: 1px solid #d9e2ef;
            border-radius: 12px;
            min-height: 42px;
            font-size: 13px;
            box-shadow: none !important;
        }

        .dp-field textarea {
            min-height: 84px;
            resize: vertical;
        }

        .dp-form-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(220px, 1fr));
            gap: 16px;
            align-items: end;
        }

            .dp-form-grid.two {
                grid-template-columns: repeat(2, minmax(220px, 1fr));
            }

            .dp-form-grid .span-2 {
                grid-column: span 2;
            }

            .dp-form-grid .span-3 {
                grid-column: span 3;
            }

        .btn-submit {
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            color: #fff;
            border: none;
            padding: 9px 18px;
            border-radius: 12px;
            font-weight: 500;
            box-shadow: 0 10px 20px rgba(37,99,235,.20);
            font-size: 12px;
        }

            .btn-submit:hover {
                transform: translateY(-2px);
            }

        .action-row {
            grid-column: 1 / -1;
            display: flex;
            justify-content: flex-end;
        }

        .btn-clear {
            background: #475569;
            color: #fff;
            border: none;
            padding: 9px 18px;
            border-radius: 12px;
            font-weight: 500;
            box-shadow: 0 10px 20px rgba(37,99,235,.20);
            font-size: 12px;
            margin-left: 8px;
        }

            .btn-clear:hover {
                transform: translateY(-2px);
            }

        #AdminExpense_table tbody tr {
            height: 35px;
        }

            #AdminExpense_table tbody tr:hover {
                background-color: #f1f5f9 !important;
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
            min-height: 35px;
            border-radius: 12px;
            padding: 9px 18px;
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



        .nj-btn-success {
            background: linear-gradient(135deg, #16a34a, #22c55e);
            color: #fff !important;
            box-shadow: 0 12px 25px rgba(22,163,74,.20);
        }

        .nj-btn:hover {
            transform: translateY(-2px);
            filter: brightness(1.02);
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
<script src="https://cdn.jsdelivr.net/npm/xlsx-js-style@1.2.0/dist/xlsx.min.js"></script>
    <script>
        $(document).ready(function () {
            bindLocation();
           // BindAdminExpenseData();
            //bindPlannedMonth();
            bindExpensesRecreationActivity();
            bindExpdetailsRecreationActivity();
        });


    </script>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const today = new Date();
            const year = today.getFullYear();
            const month = String(today.getMonth() + 1).padStart(2, '0');
            const maxDate = `${year}-${month}`;

            const monthInput = document.getElementById('expActivitiesMonth');
            if (monthInput) {
                monthInput.max = maxDate;
                monthInput.value = maxDate;
            }
        });
    </script>
    <script src="../Scripts/Functions/ExpensesAdmin.js" type="text/javascript"></script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold; margin-top: 8px;">One moment, please . . . .</div>
    </div>

    <div class="Expenses-page">
        <div class="Expenses-hero">
            <div class="Expenses-hero-inner">
                <div class="Expenses-title-wrap">
                    <div class="Expenses-hero-icon">
                        <i class="fas fa-receipt"></i>
                    </div>
                    <div>
                        <h3>Expenses</h3>
                        <p>Track office outgoings,vendor payments, and bills.</p>
                    </div>
                </div>
                <div class="Expenses-chip">
                    <i class="fas fa-sliders-h"></i>&nbsp; Expenses Configuration
                </div>
            </div>
        </div>



        <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
           <li class="nav-item">
        <a class="nav-link active" id="custom-tabs-one-home-tab_RecreationActivity" data-toggle="pill" href="#custom-tabs-one-home-tab_Recreation" role="tab" aria-controls="custom-tabs-one-home-tab_Recreation" aria-selected="true">
            <b><i class="fas fa-edit"></i> Recreation Activity Master</b>
        </a>
    </li>
            <li class="nav-item">
                <a class="nav-link" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true"><b><i class="fas fa-edit"></i>Expenses Details & List</b></a>
            </li>
            <li class="nav-item">
                <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">
                    <b><i class="fas fa-file-alt"></i> Expenses Report</b>
                </a>
            </li>
        </ul>

        <div class="tab-content" id="custom-tabs-one-tabContent">


             <div class="tab-pane fade show active" id="custom-tabs-one-home-tab_Recreation" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab_RecreationActivity">
        <div class="p-3">
            <ul class="nav nav-tabs" id="sub-tabs-recreation" role="tablist">
    <li class="nav-item">
        <a class="nav-link active" id="recreation-activity-tab" data-toggle="pill" href="#recreation-activity-content" role="tab" aria-controls="recreation-activity-content" aria-selected="true">
            <b><i class="fas fa-edit"></i> Recreation Activity</b>
        </a>
    </li>
    <li class="nav-item">
        <a class="nav-link" id="yearly-budget-tab" data-toggle="pill" href="#yearly-budget-content" role="tab" aria-controls="yearly-budget-content" aria-selected="false">
            <b><i class="fas fa-wallet"></i> Yearly Budget</b>
        </a>
    </li>
</ul>
             
            <div class="tab-content" id="sub-tabs-content">
                <div class="tab-pane fade show active" id="recreation-activity-content" role="tabpanel" aria-labelledby="recreation-activity-tab">
                    <div class="card p-3">
    <div class="row align-items-end">
        <!-- Input Field Column -->
        <div class="col-md-5">
            <div class="dp-field mb-0">
                <label>Recreation Activity</label>
                <input type="text" id="Expensesrecreationactivity" name="Expensesrecreationactivity" class="form-control" />
            </div>           
        </div>
        
        <!-- Button Column -->
        <div class="col-md-2">
            <button type="button" class="btn btn-submit w-100" id="Expensesrecreationactivity_btnsubmit" name="Expensesrecreationactivity_btnsubmit" onclick="ExpensesRecreationActivitySubmit();">
                <i class="fa fa-paper-plane"></i>
                <span id="ExpensesrecreationactivitybtnText">Submit</span>
            </button>
        </div>
    </div>
</div>
                </div>
                 
              <div class="tab-pane fade" id="yearly-budget-content" role="tabpanel" aria-labelledby="yearly-budget-tab">
    <div class="card p-3">
        <div class="row align-items-end g-3">
            
            <!-- 1. Activity Dropdown -->
            <div class="col-md-3">
                <div class="dp-field mb-0">
                    <label for="ExpensesRecreationActivity" class="form-label">Recreation Activity</label>
                    <select id="dllExpensesRecreationActivity" name="dllExpensesRecreationActivity" class="form-control">
                       
                    </select>
                </div>
            </div>

            <!-- 2. Budget Textbox -->
            <div class="col-md-3">
                <div class="dp-field mb-0">
                    <label for="yearly_budget_input" class="form-label">Budget</label>
                    <input type="number" id="yearly_budget_input" name="yearly_budget_input" class="form-control" placeholder="Enter budget" />
                </div>
            </div>

            <!-- 3. Year Dropdown -->
            <div class="col-md-3">
                <div class="dp-field mb-0">
                    <label for="yearly_year_dropdown" class="form-label">Year</label>
                    <select id="yearly_year_dropdown" name="yearly_year_dropdown" class="form-control">
                        <option value="">Select Year</option>
                        <option value="2024">2024</option>
                        <option value="2025">2025</option>
                        <option value="2026">2026</option>
                    </select>
                </div>
            </div>

            <!-- 4. Submit Button -->
            <div class="col-md-3">
                <button type="button" class="btn btn-submit w-100" id="yearly_budget_btnsubmit" name="yearly_budget_btnsubmit">
    <i class="fa fa-paper-plane"></i>
    <span id="yearly_budget_btnsubmitspan">Submit</span>
</button>
               
            </div>

        </div>
    </div>
</div>
            </div>
        </div>
    </div>


            <div class="tab-pane fade" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                <div class="Expenses-card">

                    <div class="Expenses-card-body">
                        <div class="dp-form-grid">
                            <input type="hidden" id="hdnExpenseId" value="0" />
                            <div class="dp-field">
                                <label>Location</label>
                                <select id="location" name="location" class="form-control"></select>
                            </div>

                            <div class="dp-field">
                                <label>Recreation Activity</label>
                               <select id="dllexpdetailsRecreationActivity" name="dllexpdetailsRecreationActivity" class="form-control">
     
  </select>
                            </div>

                            <div class="dp-field" id="otherFieldContainer">
                                <label>Quarter</label>
<div class="dropdown">
    <button id="quarterDropdownBtn" class="form-control dropdown-toggle text-left" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" disabled>
        Select Quarter
    </button>
    
    <div class="dropdown-menu multi-dropdown-menu" style="padding: 10px; width: 100%;">
        <label style="cursor: pointer; display: block; border-bottom: 1px solid #ddd; padding-bottom: 5px; margin-bottom: 5px;">
            <input type="checkbox" id="select_all_quarter" />
            <b>Select All</b>
        </label>
                <div id="quarterList">
            <label style="display: block; cursor: pointer;"><input type="checkbox" name="ExpAdminQuarter" value="January - March">January - March</label>
            <label style="display: block; cursor: pointer;"><input type="checkbox" name="ExpAdminQuarter" value="April - June">April - June</label>
            <label style="display: block; cursor: pointer;"><input type="checkbox" name="ExpAdminQuarter" value="July - September">July - September</label>
            <label style="display: block; cursor: pointer;"><input type="checkbox" name="ExpAdminQuarter" value="October - December">October - December</label>
        </div>
    </div>
</div>
                            </div>




                            <div class="dp-field">
    <label for="expActivitiesMonth">Activities Month</label>
    
    <input type="month" id="expActivitiesMonth" name="expActivitiesMonth" class="form-control" min="2000-01" >
</div>



                            <div class="dp-field">
                                <label>Shift</label>
                                <select id="ExpShift" name="ExpShift" class="form-control">
                                    <option value="Select">Select</option>
                                    <option value="Day">Day</option>
                                    <option value="Night">Night</option>
                                    <option value="Both">Both</option>

                                </select>
                            </div>
                            <div class="dp-field">
                                <label>Actual Expense</label>
                                <input type="number" id="ActualExpense" name="ActualExpense" class="form-control" />
                            </div>

                            <div class="dp-field">
                                <label>Completed Date</label>
                                <input type="date" id="CompletedDate" name="CompletedDate" class="form-control" />
                            </div>

                       

                            <div class="dp-field">
                                <label>Status</label>
                                <select id="Status" name="Status" class="form-control">
                                    <option value="Select">Select</option>
                                    <option value="Completed">Completed</option>
                                    <option value="Pending">Pending</option>
                                </select>
                            </div>

                            <div class="dp-field">
                                <label>Remark</label>
                                <textarea id="remark" name="remark" style="resize: none;" rows="1" class="form-control"></textarea>
                            </div>


                            <div class="action-row">
                                <button type="button" class="btn-submit" id="Expense_btnsubmit" name="Expense_btnsubmit" onclick="ExpenseSubmitData();">
                                    <i class="fa fa-paper-plane"></i>
                                    <span id="btnText">Submit</span>
                                </button>

                                <button type="button" class="btn-clear" id="Expense_btnClear" onclick="ClearExpenseForm();">
                                    <i class="fa fa-redo"></i>Clear
   
                                </button>
                            </div>
                        </div>
                    </div>



                    <h4 class="Expenses-section-title">
                        <i class="fas fa-list-ul"></i>
                        Expenses List
                    </h4>
                    <hr />
                    <div>
                        <table class="table" id="AdminExpense_table" style="width: 100%;">
                            <thead>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>

                </div>
            </div>

            <!-- Expenses Report Tab -->
            <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                <div class="Expenses-card">
                    <div class="nj-filter-body">
                        <div class="row align-items-end">
                            <div class="col-lg-3 col-md-6 mb-3">
                                <div class="nj-field">
                                    <label for="ExpensesFromDate">From Date</label>
                                    <input type="date" id="ExpensesFromDate" name="ExpensesFromDate" class="form-control" />

                                </div>
                            </div>

                            <div class="col-lg-3 col-md-6 mb-3">
                                <div class="nj-field">
                                    <label for="ExpensesToDate">To Date</label>
                                    <input type="date" id="ExpensesToDate" name="ExpensesToDate" class="form-control" />
                                </div>
                            </div>

                            <div class="col-lg-6 col-md-12 mb-3">
                                <div class="nj-actions">
                                    <button type="button" id="Expenses_btnShow" class="btn-submit" onclick="BindAdminExpenseDataForReport();" >
                                        <i class="fas fa-search"></i><span>Show Report</span>
                                    </button>

                                    <button type="button" id="Expenses_btnExporttoexcel" class="nj-btn nj-btn-success">
                                        <i class="fas fa-file-excel"></i><span>Export to Excel</span>
                                    </button>
                                </div>
                            </div>
                        </div>

                    </div>
                    <div style="padding-left: 20px; padding-right: 20px;">
                        <table class="table" id="AdminExpenseReport_table" style="width: 100%;">
                            <thead>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>





    <div class="modal fade Expenses-modal" id="Expenses_dverror">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="Expenses_errmsg"></h6>
                </div>
                <div class="modal-footer align-content-center">
                </div>
            </div>
        </div>
    </div>
</asp:Content>

