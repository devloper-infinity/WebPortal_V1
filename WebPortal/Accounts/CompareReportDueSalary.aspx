<%@ Page Title="" Language="C#" MasterPageFile="~/Accounts/Accounts.Master" AutoEventWireup="true" CodeBehind="CompareReportDueSalary.aspx.cs" Inherits="WebPortal.Accounts.CompareReportDueSalary" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <portal:VersionedScript Src="~/Scripts/Reports/CompareReport.js" runat="server"></portal:VersionedScript>
    <style>
        .report-page {
            background: #f4f7fb;
            padding: 18px;
        }

        .report-header {
            background: #ffffff;
            border: 1px solid #dbe3ec;
            border-radius: 10px;
            padding: 16px 20px;
            margin-bottom: 14px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

            .report-header h3 {
                margin: 0;
                font-size: 22px;
                font-weight: 700;
                color: #111827;
            }

            .report-header p {
                margin: 4px 0 0;
                color: #64748b;
                font-size: 13px;
            }

        .filter-panel {
            background: #ffffff;
            border: 1px solid #dbe3ec;
            border-radius: 10px;
            padding: 16px;
            margin-bottom: 16px;
            display: grid;
            grid-template-columns: repeat(4, 1fr) auto;
            gap: 14px;
            align-items: end;
        }

        .filter-item label {
            display: block;
            font-size: 12px;
            font-weight: 700;
            color: #334155;
            margin-bottom: 6px;
        }

        .form-select {
            width: 100%;
            height: 38px;
            border: 1px solid #cbd5e1;
            border-radius: 7px;
            padding: 6px 10px;
            background: #fff;
        }

        .btn {
            height: 38px;
            padding: 0 18px;
            border-radius: 7px;
            border: none;
            font-weight: 700;
            cursor: pointer;
        }

        .btn-primary {
            background: #0f5f73;
            color: #fff;
        }

        .btn-outline {
            background: #fff;
            color: #0f5f73;
            border: 1px solid #0f5f73;
        }

        .report-card {
            background: #ffffff;
            border: 1px solid #dbe3ec;
            border-radius: 10px;
            padding: 14px;
        }

        #comparedue_tblCompareReport thead th {
            background: #eaf3f8;
            color: #111827;
            font-weight: 700;
            text-align: center !important;
            white-space: nowrap;
        }

        #comparedue_tblCompareReport td {
            white-space: nowrap;
            vertical-align: middle !important;
            text-align: center !important;
        }

            #comparedue_tblCompareReport td:not(:first-child):not(:nth-child(2)) {
                text-align: center;
            }

            #comparedue_tblCompareReport td:first-child,
            #comparedue_tblCompareReport td:nth-child(2) {
                font-weight: 700;
            }

        #comparedue_tblCompareReport .difference-row td {
            background: #4f6187 !important;
            color: #fff !important;
            font-weight: 700;
        }

        #comparedue_tblCompareReport td:last-child {
            font-weight: 700;
            background: #f1f5f9;
        }



        @media(max-width: 1000px) {
            .filter-panel {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        #comparenet_tblCompareReport thead th {
            background: #eaf3f8;
            color: #111827;
            font-weight: 700;
            text-align: center !important;
            white-space: nowrap;
        }

        #comparenet_tblCompareReport td {
            white-space: nowrap;
            vertical-align: middle !important;
            text-align: center !important;
        }

            #comparenet_tblCompareReport td:not(:first-child):not(:nth-child(2)) {
                text-align: center;
            }

            #comparenet_tblCompareReport td:first-child,
            #comparenet_tblCompareReport td:nth-child(2) {
                font-weight: 700;
            }

        #comparenet_tblCompareReport .difference-row td {
            background: #4f6187 !important;
            color: #fff !important;
            font-weight: 700;
        }

        #comparenet_tblCompareReport td:last-child {
            font-weight: 700;
            background: #f1f5f9;
        }

        #comparedue_btnCompare.loading {
            pointer-events: none;
            opacity: 0.75;
        }

            #comparedue_btnCompare.loading::after {
                content: " ...";
            }

        div.dataTables_processing {
            position: fixed !important;
            top: 50% !important;
            left: 50% !important;
            transform: translate(-50%, -50%) !important;
            background: #fff !important;
            border-radius: 10px !important;
            padding: 20px 30px !important;
            box-shadow: 0 8px 30px rgba(0,0,0,0.15) !important;
            font-size: 15px !important;
            font-weight: 600 !important;
            color: #0f172a !important;
            border: 1px solid #dbe3ec !important;
            z-index: 99999 !important;
        }

            div.dataTables_processing::before {
                content: "";
                width: 18px;
                height: 18px;
                border: 3px solid #cbd5e1;
                border-top-color: #0f5f73;
                border-radius: 50%;
                display: inline-block;
                margin-right: 10px;
                animation: dtloader 0.8s linear infinite;
                vertical-align: middle;
            }

        @keyframes dtloader {
            to {
                transform: rotate(360deg);
            }
        }

        .report-loader {
            position: absolute;
            inset: 0;
            background: rgba(255,255,255,0.75);
            z-index: 9999;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 160px;
        }

        .loader-box {
            background: #ffffff;
            border: 1px solid #dbe3ec;
            border-radius: 10px;
            padding: 14px 22px;
            font-weight: 700;
            color: #0f172a;
            box-shadow: 0 8px 25px rgba(0,0,0,0.12);
        }

        .loader-spinner {
            width: 18px;
            height: 18px;
            border: 3px solid #cbd5e1;
            border-top-color: #0f5f73;
            border-radius: 50%;
            display: inline-block;
            margin-right: 8px;
            vertical-align: middle;
            animation: spin 0.8s linear infinite;
        }

        @keyframes spin {
            to {
                transform: rotate(360deg);
            }
        }

        #comparedue_tblCompareReport .movement-row td {
            background: #e4f1ff;
            font-weight: 600;
        }

        #comparenet_tblCompareReport .movement-row td {
            background: #e4f1ff;
            font-weight: 600;
        }

        .salary-tabs {
            display: flex;
            gap: 8px;
            border-bottom: 1px solid #dbe3ec;
            margin-bottom: 14px;
        }

        .tab-btn {
            background: #f8fafc;
            border: 1px solid #dbe3ec;
            border-bottom: none;
            padding: 10px 18px;
            font-weight: 700;
            color: #334155;
            border-radius: 8px 8px 0 0;
            cursor: pointer;
        }

            .tab-btn.active {
                background: #0f5f73;
                color: #fff;
                border-color: #0f5f73;
            }

        .tab-content {
            display: none;
        }

            .tab-content.active {
                display: block;
            }
    </style>
    <script>
        $(document).ready(function () {
            BindMonthDropdowns();
            BindYearDropdowns();

            //$('#comparedue_btnCompare').on('click', function () {
            //    comparedue_BindCompareDueReport();
            //});
            $('#comparedue_btnCompare').on('click', function () {
                comparedue_BindCompareDueReport();

                if ($('.tab-btn[data-target="net"]').hasClass('active')) {
                    comparedue_BindCompareNetReport();
                }
            });
            $('#comparedue_btnExportExcel').on('click', function () {
                $('.buttons-excel').click();
            });

            $(document).on('click', '.tab-btn', function () {
                var target = $(this).data('target');

                $('.tab-btn').removeClass('active');
                $(this).addClass('active');

                $('.tab-content').removeClass('active');

                if (target === 'due') {
                    $('#dueTab').addClass('active');

                    setTimeout(function () {
                        if ($.fn.DataTable.isDataTable('#comparedue_tblCompareReport')) {
                            $('#comparedue_tblCompareReport').DataTable().columns.adjust();
                        }
                    }, 100);
                }

                if (target === 'net') {
                    $('#netTab').addClass('active');

                    if (!$.fn.DataTable.isDataTable('#comparenet_tblCompareReport')) {
                        comparedue_BindCompareNetReport();
                    } else {
                        setTimeout(function () {
                            $('#comparenet_tblCompareReport').DataTable().columns.adjust();
                        }, 100);
                    }
                }
            });
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
                    <h6 class="m-0"><i class="fas fa-chart-line"></i>&nbsp;&nbsp;<b>Compare Salary Report</b></h6>
                    <small class="text-muted">Compare due salary, net salary, employee movement, new joinee and drop out branch-wise.</small>
                </div>

            </div>
        </div>
        <!-- /.container-fluid -->
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">

                <div class="report-page">


                    <div class="filter-panel">
                        <div class="filter-item">
                            <label>Current Month</label>
                            <select id="comparedue_ddlCurrentMonth" class="form-select"></select>
                        </div>

                        <div class="filter-item">
                            <label>Current Year</label>
                            <select id="comparedue_ddlCurrentYear" class="form-select"></select>
                        </div>

                        <div class="filter-item">
                            <label>Previous Month</label>
                            <select id="comparedue_ddlPreviousMonth" class="form-select"></select>
                        </div>

                        <div class="filter-item">
                            <label>Previous Year</label>
                            <select id="comparedue_ddlPreviousYear" class="form-select"></select>
                        </div>

                        <div class="filter-action">
                            <button type="button" id="comparedue_btnCompare" class="btn btn-primary">
                                Compare
                            </button>
                        </div>
                    </div>
                    <div id="reportLoader" class="report-loader" style="display: none;">
                        <div class="loader-box">
                            <span class="loader-spinner"></span>
                            Loading report...
       
                        </div>
                    </div>
                    <div class="report-card">

                        <div class="salary-tabs">
                            <button type="button" class="tab-btn active" data-target="due">
                                Due Salary Comparison
                            </button>

                            <button type="button" class="tab-btn" data-target="net">
                                Net Salary Comparison
                            </button>
                        </div>

                        <div id="dueTab" class="tab-content active">
                            <table id="comparedue_tblCompareReport" class="table table-bordered table-striped nowrap" style="width: 100%">
                                <thead></thead>
                                <tbody></tbody>
                            </table>
                        </div>

                        <div id="netTab" class="tab-content">
                            <table id="comparenet_tblCompareReport" class="table table-bordered table-striped nowrap" style="width: 100%">
                                <thead></thead>
                                <tbody></tbody>
                            </table>
                        </div>

                    </div>

                </div>
            </div>
        </div>
    </div>
</asp:Content>
