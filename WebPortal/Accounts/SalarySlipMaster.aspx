<%@ Page Title="" Language="C#" MasterPageFile="~/Accounts/Accounts.Master" AutoEventWireup="true" CodeBehind="SalarySlipMaster.aspx.cs" Inherits="WebPortal.Accounts.SalarySlipMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        .dashboard-card {
            color: white;
            border-radius: 10px;
        }

            .dashboard-card h6 {
                font-size: 14px;
                opacity: .9;
            }

            .dashboard-card h3 {
                font-weight: 700;
            }

        .card {
            border-radius: 10px;
        }

        #table_SalaryMaster tbody tr:hover {
            background: #f4f7ff;
        }

        table.dataTable thead th {
            white-space: nowrap;
        }
    </style>

    <style>
        @media print {

            #tblslip {
                border: 4px double #000 !important;
            }

                #tblslip td {
                    border: 1px solid black;
                }
        }

        #tblslip {
            border: double 4px #000;
            padding: 12px;
            font-size: 12px;
            margin: auto;
        }

        #popUpSalarySlip .modal-dialog {
            margin: 10px auto;
            max-width: 1120px;
            width: calc(100vw - 24px);
        }

        #popUpSalarySlip .modal-content {
            background: #f3f6f8;
            border: 0;
            border-radius: 8px;
            box-shadow: 0 24px 60px rgba(15, 23, 42, 0.28);
            overflow: hidden;
        }

        #popUpSalarySlip .modal-header {
            align-items: center;
            background: linear-gradient(135deg, #164e63 0%, #1d4ed8 100%);
            border-bottom: 0;
            color: #fff;
            padding: 12px 18px;
        }

        #popUpSalarySlip .modal-title {
            align-items: center;
            color: #fff;
            display: flex;
            font-size: 20px;
            font-weight: 700;
            gap: 12px;
            line-height: 1.2;
            margin: 0;
        }

        #popUpSalarySlip .modal-title:before {
            background:
                radial-gradient(circle at 25px 15px, #fff 0 3.5px, transparent 4px),
                radial-gradient(circle at 14px 33px, #fff 0 3.5px, transparent 4px),
                radial-gradient(circle at 25px 33px, #fff 0 3.5px, transparent 4px),
                radial-gradient(circle at 36px 33px, #fff 0 3.5px, transparent 4px),
                linear-gradient(#fff, #fff) 24px 18px / 2px 10px no-repeat,
                linear-gradient(#fff, #fff) 11px 27px / 28px 2px no-repeat,
                linear-gradient(#fff, #fff) 13px 27px / 2px 7px no-repeat,
                linear-gradient(#fff, #fff) 24px 27px / 2px 7px no-repeat,
                linear-gradient(#fff, #fff) 35px 27px / 2px 7px no-repeat,
                rgba(255, 255, 255, 0.16);
            border: 1px solid rgba(255, 255, 255, 0.22);
            border-radius: 18px;
            content: "";
            display: inline-block;
            flex-shrink: 0;
            height: 44px;
            width: 44px;
        }

        #popUpSalarySlip .salary-slip-close {
            background: rgba(255, 255, 255, 0.96) !important;
            border: 1px solid rgba(255, 255, 255, 0.96) !important;
            color: #17324d !important;
            gap: 8px;
            min-height: 36px;
            padding: 7px 13px;
        }

        #popUpSalarySlip .salary-slip-modal-body {
            background: #eef3f7;
            margin: 0 !important;
            overflow: hidden;
            padding: 10px 14px;
            width: auto !important;
        }

        #popUpSalarySlip .salary-slip-preview-frame {
            background: #fff;
            border: 1px solid #dce5ec;
            border-radius: 8px;
            box-shadow: 0 14px 34px rgba(31, 51, 71, 0.12);
            margin: 0 auto;
            max-width: 100%;
            overflow: hidden;
            padding: 10px;
            width: max-content;
        }

        #popUpSalarySlip #divsal {
            margin: 0 auto;
            min-width: 700px;
            transform-origin: top center;
            width: max-content;
        }

        #popUpSalarySlip #tblslip {
            background: #fff;
            border: 4px double #1f2937 !important;
            box-shadow: none;
            margin: 0 auto;
        }

        #popUpSalarySlip #imglogo {
            max-height: 70px;
            max-width: 260px;
        }

        #popUpSalarySlip .modal-footer {
            background: #fff;
            border-top: 1px solid #e7edf2;
            gap: 10px;
            justify-content: flex-end;
            padding: 10px 16px;
        }

        #popUpSalarySlip .salary-slip-print-btn {
            background: #0f766e !important;
            border: 1px solid #0f766e !important;
            color: #fff !important;
            min-width: 110px;
        }

        #popUpSalarySlip .salary-slip-print-btn:hover,
        #popUpSalarySlip .salary-slip-print-btn:focus {
            background: #0b5f59 !important;
            border-color: #0b5f59 !important;
            color: #fff !important;
        }

        @media (max-width: 767px) {
            #popUpSalarySlip .modal-dialog {
                margin: 8px;
                width: calc(100vw - 16px);
            }

            #popUpSalarySlip .modal-header {
                align-items: flex-start;
                gap: 10px;
                padding: 12px;
            }

            #popUpSalarySlip .modal-title {
                font-size: 18px;
            }

            #popUpSalarySlip .salary-slip-print-btn {
                width: 100%;
            }

            #popUpSalarySlip .salary-slip-modal-body {
                padding: 8px;
            }

            #popUpSalarySlip .salary-slip-preview-frame {
                padding: 8px;
            }
        }
    </style>

    <style>
        .salary-slip {
            width: 68px;
            margin: auto;
            font-family: Calibri, Arial;
            font-size: 13px;
            border: 1px solid #333;
            padding: 10px;
            background: #fff;
        }

        .salary-header {
            text-align: center;
        }

            .salary-header img {
                height: 60px;
                margin-bottom: 5px;
            }

        .company-name {
            font-size: 22px;
            font-weight: bold;
        }

        .salary-title {
            font-size: 18px;
            font-weight: bold;
            margin-top: 5px;
        }

        .salary-month {
            font-weight: bold;
        }

        .salary-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 8px;
        }

            .salary-table td {
                padding: 4px 6px;
            }

        .salary-border td {
            border: 1px solid #ccc;
        }

        .salary-table .label {
            font-weight: 600;
        }

        .salary-table .value {
            text-align: right;
        }

        .salary-highlight {
            font-weight: bold;
            background: #f3f3f3;
        }

        .net-salary {
            font-weight: bold;
            font-size: 14px;
            background: #eaf5ff;
        }

        .watermark img {
            opacity: 0.08;
            width: 120px;
        }

        hr {
            margin: 3px 0;
        }
    </style>

    <script>

        $(document).ready(function () {

            salmaster_bindGrid();
        });

        $('#table_SalaryMaster').DataTable({

            responsive: true,
            scrollX: true,
            pageLength: 10,

            dom: 'Bfrtip',

            buttons: [
                {
                    extend: 'excel',
                    text: 'Excel',
                    className: 'btn btn-success btn-sm'
                },
                {
                    extend: 'pdf',
                    text: 'PDF',
                    className: 'btn btn-danger btn-sm'
                },
                {
                    extend: 'print',
                    text: 'Print',
                    className: 'btn btn-primary btn-sm'
                }
            ]

        });

        function fitSalarySlipPopup() {
            var modal = document.getElementById('popUpSalarySlip');
            if (!modal) return;

            var body = modal.querySelector('.salary-slip-modal-body');
            var frame = modal.querySelector('.salary-slip-preview-frame');
            var slip = modal.querySelector('#divsal');
            var table = modal.querySelector('#tblslip');
            var dialog = modal.querySelector('.modal-dialog');
            var header = modal.querySelector('.modal-header');
            var footer = modal.querySelector('.modal-footer');

            if (!body || !frame || !slip || !table || !dialog) return;

            slip.style.zoom = '1';
            slip.style.transform = 'none';
            slip.style.height = '';
            slip.style.width = 'max-content';
            body.style.height = '';

            var bodyStyles = window.getComputedStyle(body);
            var frameStyles = window.getComputedStyle(frame);
            var bodyPaddingY = parseFloat(bodyStyles.paddingTop) + parseFloat(bodyStyles.paddingBottom);
            var bodyPaddingX = parseFloat(bodyStyles.paddingLeft) + parseFloat(bodyStyles.paddingRight);
            var framePaddingY = parseFloat(frameStyles.paddingTop) + parseFloat(frameStyles.paddingBottom);
            var framePaddingX = parseFloat(frameStyles.paddingLeft) + parseFloat(frameStyles.paddingRight);
            var chromeHeight = (header ? header.offsetHeight : 0) + (footer ? footer.offsetHeight : 0);
            var availableHeight = window.innerHeight - chromeHeight - bodyPaddingY - framePaddingY - 34;
            var availableWidth = dialog.clientWidth - bodyPaddingX - framePaddingX - 18;
            var naturalWidth = table.offsetWidth;
            var naturalHeight = table.offsetHeight;

            if (!naturalWidth || !naturalHeight) return;

            var scale = Math.min(1, availableWidth / naturalWidth, availableHeight / naturalHeight);
            scale = Math.max(0.55, Math.min(1, scale));

            slip.style.zoom = scale.toString();
            frame.style.width = Math.ceil(naturalWidth * scale) + 'px';
            body.style.height = Math.ceil(naturalHeight * scale + framePaddingY) + 'px';
        }

        $(document).on('shown.bs.modal', '#popUpSalarySlip', function () {
            setTimeout(fitSalarySlipPopup, 60);
        });

        $(window).on('resize', function () {
            if ($('#popUpSalarySlip').hasClass('show')) {
                fitSalarySlipPopup();
            }
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
                    <h6 class="m-0"><i class="fa fa-money-bill-wave"></i>&nbsp;&nbsp;<b>Salary Slip Master</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <table class="table table-hover table-striped align-middle" id="table_SalaryMaster" style="width: 100%">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Status</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Joining Date</th>
                           <%-- <th class="sort border-top ps-3" style="text-wrap: nowrap;">Last Working Date</th>--%>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Email</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Month-1</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Month-2</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Month-3</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Month-4</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>


    <div class="modal fade salary-slip-popup" id="popUpSalarySlip" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered salary-slip-dialog">
            <div class="modal-content salary-slip-content">
                <div class="modal-header salary-slip-modal-header">
                    <h4 class="modal-title">Salary Slip</h4>
                    <button type="button" class="btn btn-secondary salary-slip-close" data-dismiss="modal"><i class="fas fa-times"></i><span>Close</span></button>
                </div>

                <div class="modal-body salary-slip-modal-body">
                    <div class="salary-slip-preview-frame">
                    <div id="divsal">
                        <table style="border: double; font-size: 12px; padding: 15px;" id="tblslip">
                            <tr>
                                <td>
                                    <table class="table1" style="width: 700px;" id="tblsal">
                                        <tr>
                                            <td colspan="5" style="text-align: center;">
                                                <img id="imglogo" src="../images/logo.png" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="7" style="text-align: center;">
                                                <span id="lblCompanyAddress"></span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="6">
                                                <div align="center">
                                                    <span id="lblCityPincode"></span>
                                                    <span id="lblState"></span>
                                                    <span id="lblCountry"></span>
                                                    <span id="lblPhoneNo"></span>
                                                    <span id="lblFax"></span>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <hr style="margin-top: 2px; border: none; border-top: 1px solid #999;">
                                            </td>
                                        </tr>

                                        <tr>
                                            <td>
                                                <div align="center" style="margin-top: -7px;">
                                                    <span style="font-size: 18px; font-weight: bold;">Salary Slip</span>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <hr style="margin-top: 2px; border: none; border-top: 1px solid #999;">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div align="center" style="margin-top: -5px;">
                                                    <span id="lblSalarymonth">Salary for the month</span>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <hr style="margin-top: 2px; border: none; border-top: 1px solid #999;">
                                            </td>
                                        </tr>
                                    </table>

                                    <table class="table1" style="width: 700px;">
                                        <tr>
                                            <td>Code :</td>
                                            <td style="width: 140px;"><span id="lblCode"></span></td>
                                            <td rowspan="19" style="text-align: center;">
                                                <img id="imgWatermark" src="../images/InfinityWatermark.JPG" style="opacity: 0.06; width: 160px;" />
                                            </td>
                                            <td></td>
                                            <td>Head Office :</td>
                                            <td><span id="lblBranch"></span></td>
                                        </tr>
                                        <tr>
                                            <td>Name :</td>
                                            <td colspan="2"><span id="lblName"></span></td>
                                            <td></td>
                                            <td>Department :</td>
                                            <td><span id="lbldepartment"></span></td>
                                        </tr>

                                        <tr>
                                            <td>ESIC No.:</td>
                                            <td><span id="lblESICNo"></span></td>
                                            <td></td>

                                            <td>Designation:</td>
                                            <td><span id="lblDesignation"></span></td>
                                        </tr>

                                        <tr>
                                            <td>PF No.:</td>
                                            <td><span id="lblPfNo"></span></td>
                                            <td></td>

                                            <td>Total Days:</td>
                                            <td><span id="lblTotalDays"></span></td>
                                        </tr>

                                        <tr>
                                            <td colspan="6">
                                                <hr style="margin-top: 2px; border: none; border-top: 1px solid #999;">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Basic+DA:</td>
                                            <td style="text-align: right"><span id="lblbasicDA"></span></td>
                                            <td></td>


                                            <td>Basic+DA:</td>
                                            <td style="text-align: right"><span id="lblBasicDA1"></span></td>
                                        </tr>

                                        <tr>
                                            <td>H.R.A.:</td>
                                            <td style="text-align: right"><span id="lblHRA"></span></td>
                                            <td></td>

                                            <td>H.R.A.:</td>
                                            <td style="text-align: right"><span id="lblHRA1"></span></td>
                                        </tr>

                                        <tr id="mr" style="display: none;">
                                            <td>Medical Reimbursement:</td>
                                            <td style="text-align: right"><span id="lblMedicle"></span></td>
                                            <td></td>

                                            <td>Medical Reimbursement:</td>
                                            <td style="text-align: right"><span id="lblMedicle1"></span></td>
                                        </tr>

                                        <tr id="tr" style="display: none;">
                                            <td>Transport Allowance:</td>
                                            <td style="text-align: right"><span id="lblTransportAllowance"></span></td>
                                            <td></td>

                                            <td>Transport Allowance:</td>
                                            <td style="text-align: right"><span id="lblTransportAllowance1"></span></td>
                                        </tr>

                                        <tr id="ea" style="display: none;">
                                            <td>Education Allowance:</td>
                                            <td style="text-align: right"><span id="lblEducationAllowance"></span></td>
                                            <td></td>

                                            <td>Education Allowance:</td>
                                            <td style="text-align: right"><span id="lblEducationAllowance1"></span></td>
                                        </tr>

                                        <tr id="ha" style="display: none;">
                                            <td>Hostel Allowance:</td>
                                            <td style="text-align: right"><span id="lblHostelAllowance"></span></td>
                                            <td></td>

                                            <td>Hostel Allowance:</td>
                                            <td style="text-align: right"><span id="lblHostelAllowance1"></span></td>
                                        </tr>

                                        <tr>
                                            <td>Attendance Bonus:</td>
                                            <td style="text-align: right"><span id="lblAttendanceBonus"></span></td>
                                            <td></td>

                                            <td>Attendance Bonus:</td>
                                            <td style="text-align: right"><span id="lblAttendanceBonus1"></span></td>
                                        </tr>

                                        <tr>
                                            <td>Quality Bonus:</td>
                                            <td style="text-align: right"><span id="lblQualityBonus"></span></td>
                                            <td></td>

                                            <td>Quality Bonus:</td>
                                            <td style="text-align: right"><span id="lblQualityBonus1"></span></td>
                                        </tr>

                                        <tr>
                                            <td style="font-weight: bold">
                                                <hr style="margin-top: 2px;">
                                                Salary:<hr style="margin-top: 2px;">
                                            </td>

                                            <td style="text-align: right">
                                                <hr style="margin-top: 2px;">
                                                <span id="lblSalary"></span>
                                                <hr style="margin-top: 2px;">
                                            </td>
                                            <td></td>

                                            <td style="font-weight: bold; width: 130px;">
                                                <hr style="margin-top: 2px;">
                                                Total Due Salary:<hr style="margin-top: 2px;">
                                            </td>

                                            <td style="text-align: right">
                                                <hr style="margin-top: 2px;">
                                                <span id="lblTotalDueSalary"></span>
                                                <hr style="margin-top: 2px;">
                                            </td>
                                        </tr>

                                        <tr>
                                            <td>Advances:</td>
                                            <td style="text-align: right"><span id="lblAdvances"></span></td>
                                            <td></td>

                                            <td>Bonus:</td>
                                            <td style="text-align: right"><span id="lblBonus"></span></td>
                                        </tr>

                                        <tr>
                                            <td>E.S.I.:</td>
                                            <td style="text-align: right"><span id="lblESI"></span></td>
                                            <td></td>

                                            <td>Spl.Incentive:</td>
                                            <td style="text-align: right"><span id="lblIncentive"></span></td>
                                        </tr>

                                        <tr>
                                            <td>P.F.:</td>
                                            <td style="text-align: right"><span id="lblPF"></span></td>
                                            <td></td>

                                            <td>Allowences:</td>
                                            <td style="text-align: right"><span id="lblAllowences"></span></td>
                                        </tr>

                                        <tr>
                                            <td>MLWF:</td>
                                            <td style="text-align: right"><span id="lblMLWF"></span></td>
                                            <td></td>

                                            <td>Salary Arrears:</td>
                                            <td style="text-align: right"><span id="lblSalaryArrears"></span></td>
                                        </tr>

                                        <tr>
                                            <td>Prof. Tax:</td>
                                            <td style="text-align: right"><span id="lblProfTax"></span></td>
                                            <td></td>

                                            <td>Deduction:</td>
                                            <td style="text-align: right"><span id="lblDeduction"></span></td>
                                        </tr>

                                        <tr>
                                            <td>Other:</td>
                                            <td style="text-align: right"><span id="lblOther"></span></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                        </tr>

                                        <tr>
                                            <td>T.D.S.:</td>
                                            <td style="text-align: right"><span id="lblTDS"></span></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                        </tr>

                                        <tr>
                                            <td style="font-weight: bold">
                                                <hr style="margin-top: 2px;">
                                                Total Deduction:<hr style="margin-top: 2px;">
                                            </td>
                                            <td style="text-align: right">
                                                <hr style="margin-top: 2px;">
                                                <span id="lblTotalDeduction"></span>
                                                <hr style="margin-top: 2px;">
                                            </td>
                                            <td></td>
                                            <td style="font-weight: bold">
                                                <hr style="margin-top: 2px;">
                                                Net Salary:<hr style="margin-top: 2px;">
                                            </td>
                                            <td style="text-align: right">
                                                <hr style="margin-top: 2px;">
                                                <span id="lblNetSalary"></span>
                                                <hr style="margin-top: 2px;">
                                            </td>
                                        </tr>
                                    </table>

                                </td>
                            </tr>
                        </table>
                    </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-success salary-slip-print-btn" onclick="printSlip()"><i class="fas fa-print"></i><span>Print</span></button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

