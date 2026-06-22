<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="TDSSection.aspx.cs" Inherits="WebPortal.Admin.TDSSection" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.8/css/jquery.dataTables.min.css" />

    <style>
        :root {
            --vl-primary: #2563eb;
            --vl-primary-dark: #172554;
            --vl-accent: #22c1dc;
            --vl-bg: #f5f7fb;
            --vl-card: #ffffff;
            --vl-text: #0f172a;
            --vl-muted: #64748b;
            --vl-border: #e2e8f0;
            --vl-soft: #eff6ff;
            --vl-shadow: 0 18px 45px rgba(15, 23, 42, .08);
        }

        body {
            background: var(--vl-bg);
        }


        .vl-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            gap: 18px;
            padding: 19px 25px;
            border-radius: 15px;
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 48%, #22c1dc 100%);
            box-shadow: var(--vl-shadow);
        }

            .vl-hero:before,
            .vl-hero:after {
                content: "";
                position: absolute;
                border-radius: 999px;
                background: rgba(255, 255, 255, .12);
            }

            .vl-hero:before {
                width: 220px;
                height: 220px;
                right: 70px;
                top: -120px;
            }

            .vl-hero:after {
                width: 300px;
                height: 300px;
                right: -90px;
                bottom: -170px;
            }

        .vl-hero-icon {
            position: relative;
            z-index: 1;
            width: 56px;
            height: 56px;
            display: grid;
            place-items: center;
            border-radius: 18px;
            background: rgba(255, 255, 255, .16);
            border: 1px solid rgba(255, 255, 255, .22);
            font-size: 24px;
            flex-shrink: 0;
        }

        .vl-hero-content {
            position: relative;
            z-index: 1;
        }

        .vl-title {
            margin: 0;
            font-size: 22px;
            font-weight: 800;
            letter-spacing: -.02em;
        }

        .vl-subtitle {
            margin: 8px 0 0;
            font-size: 13px;
            opacity: .9;
        }

        .tds-table-card {
            margin-top: 24px;
            padding: 22px;
            border: 1px solid var(--vl-border);
            border-radius: 22px;
            background: var(--vl-card);
            box-shadow: var(--vl-shadow);
        }

        .tds-card-title {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 16px;
            padding-bottom: 14px;
            border-bottom: 1px solid var(--vl-border);
        }

            .tds-card-title h5 {
                margin: 0;
                color: var(--vl-text);
                font-size: 16px;
                font-weight: 800;
            }

            .tds-card-title span {
                color: var(--vl-muted);
                font-size: 12px;
            }

        .tds-pill {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 13px;
            border-radius: 999px;
            background: var(--vl-soft);
            color: var(--vl-primary);
            font-size: 12px;
            font-weight: 800;
            white-space: nowrap;
        }

        .dataTables_wrapper .dataTables_scroll div.dataTables_scrollBody {
            min-height: 100px !important;
            height: auto;
        }

        .table > :not(caption) > * > * {
            padding: .7rem .75rem;
            border-bottom-color: var(--vl-border) !important;
        }

        #tdsdeduction {
            width: 100% !important;
            font-size: 13px;
            border-collapse: separate;
            border-spacing: 0;
            color: var(--vl-text);
        }

            #tdsdeduction thead th,
            #tdsdeduction th {
                background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%) !important;
                color: #fff !important;
                font-weight: 800;
                text-transform: uppercase;
                letter-spacing: .04em;
                border: 0 !important;
                /*   padding: 13px 14px !important;*/
                font-size: 12px;
            }

                #tdsdeduction thead th:first-child {
                    border-top-left-radius: 14px;
                }

                #tdsdeduction thead th:last-child {
                    border-top-right-radius: 14px;
                }

            #tdsdeduction td {
                vertical-align: middle;
                background: #fff;
                border-color: var(--vl-border) !important;
                font-weight: normal;
                padding: 10px !important;
            }

            #tdsdeduction tbody tr:hover td {
                background: #f8fbff;
            }

            #tdsdeduction td:nth-child(1) {
                font-weight: normal;
                color: #1e293b;
                padding: 10px !important;
            }

            #tdsdeduction td:nth-child(2) {
                text-align: left;
                font-weight: 800;
                color: #0f172a;
                white-space: nowrap;
                font-weight: normal;
                padding: 10px !important;
            }

            #tdsdeduction td:nth-child(3) {
                color: var(--vl-muted);
                font-weight: normal;
                padding: 10px !important;
            }

            #tdsdeduction .summary-row td {
                background: linear-gradient(90deg, #eff6ff 0%, #f8fafc 100%) !important;
                color: #0f172a;
                font-weight: 900;
                border-top: 1px solid #bfdbfe !important;
                border-bottom: 1px solid #bfdbfe !important;
            }

            #tdsdeduction .section-gap td {
                height: 12px;
                background: #f8f9fa;
            }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            width: 100%;
            height: 100%;
            z-index: 99999;
            background: rgba(248, 250, 252, .72);
            backdrop-filter: blur(5px);
            text-align: center;
            padding-top: 260px;
        }

            .loading img {
                width: 76px;
                height: 76px;
            }

            .loading div {
                margin-top: 12px;
                color: var(--vl-text);
                font-size: 13px !important;
                font-weight: 800 !important;
            }

        .card.card-tabs {
            border: 1px solid var(--vl-border);
            border-radius: 18px;
            box-shadow: none;
        }

        .form-control {
            border-radius: 12px;
            border-color: var(--vl-border);
            min-height: 38px;
            font-size: 13px;
        }

        .btn.btn-primary {
            border: 0;
            border-radius: 12px;
            padding: 9px 18px;
            font-weight: 800;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 60%, #22c1dc 100%);
            box-shadow: 0 12px 24px rgba(37, 99, 235, .22);
        }

        @media (max-width: 768px) {
            .vl-hero {
                align-items: flex-start;
                padding: 18px;
            }

            .vl-title {
                font-size: 18px;
            }

            .tds-table-card {
                padding: 14px;
            }

            .tds-card-title {
                align-items: flex-start;
                flex-direction: column;
            }
        }
    </style>

    <script>

        $(document).ready(function () {
            BindTDSDeduction("New");


        });

        var edittable;
        var html;

        function blankForNull(s) {
            return s == "null" || s == null ? "" : s;
        }

        function BindTDSDeduction(slab) {
            let html = '';

            const summaryRows = [
                "Total Salary(Approx)",
                "Balance Salary",
                "Net Taxable Salary",
                "Net Total Income",
                "Gross Total Income",
                "Total Eligible Deductions",
                "Net Taxble Income",
                "Income Tax Liability",
                "Income Tax after rebate u/s 87A",
                "Total Tax Liability",
                "BalancePayble"
            ];

            $.ajax({
                url: "TDSSection.aspx/GetDeductionDetails",
                type: "POST",
                data: JSON.stringify({ TaxSlab: slab }),
                dataType: "json",
                contentType: "application/json; charset=utf-8",

                success: function (data) {
                    const dataArray = JSON.parse(data.d);

                    $.each(dataArray, function (index, value) {
                        const desc = blankForNull(value.Description);
                        const rowClass = summaryRows.includes(desc) ? 'summary-row' : '';

                        html += `
                    <tr class="${rowClass}">
                        <td>${desc}</td>
                        <td>${blankForNull(value.Value)}</td>
                        <td>${blankForNull(value.Details)}</td>
                    </tr>`;
                    });

                    if ($.fn.dataTable.isDataTable('#tdsdeduction')) {
                        $('#tdsdeduction').DataTable().destroy();
                    }

                    $('#tdsdeduction tbody').html(html);

                    edittable = $('#tdsdeduction').DataTable({
                        dom: 'rt',
                        scrollX: true,
                        destroy: true,
                        paging: false,
                        searching: false,
                        ordering: false,
                        info: false,
                        autoWidth: false,
                        processing: true,
                        responsive: true,


                        initComplete: function () {
                            // Header
                            $('#tblAttendance thead th').css({
                                'background': 'linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%)',
                                'color': '#fff',
                                'font-weight': '600',
                                'border': 'none',
                                'text-align': 'center'
                            });
                            $('#load1').hide();
                        }
                    });
                },

                error: function (error) {
                    alert('error: ' + error.responseText);
                }
            });
        }

    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" alt="Loading" />
        <div>One moment, please . . . .</div>
    </div>

    <div class="tds-page">
        <section class="vl-hero">
            <div class="vl-hero-icon"><i class="fas fa-file-invoice-dollar"></i></div>
            <div class="vl-hero-content">
                <h1 class="vl-title">TDS Deduction</h1>
                <p class="vl-subtitle">Review salary, deductions, taxable income and tax liability details.</p>
            </div>
        </section>

        <div class="tds-table-card">
            <div class="tds-card-title">
                <div>
                    <h5>Deduction Summary</h5>
                    <span>Calculated values are loaded automatically as per selected tax slab.</span>
                </div>
                <div class="tds-pill"><i class="fas fa-receipt"></i>New Tax Slab</div>
            </div>

            <table class="table" id="tdsdeduction" style="padding-top: 10px; width: 100%;">
                <thead>
                    <tr>
                        <th class="sort border-top">Description</th>
                        <th class="sort border-top">Value</th>
                        <th class="sort border-top">Details</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>
</asp:Content>

