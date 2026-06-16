<%@ Page Title="" Language="C#" MasterPageFile="~/Accounts/Accounts.Master" AutoEventWireup="true" CodeBehind="SalarySlipMaster.aspx.cs" Inherits="WebPortal.Accounts.SalarySlipMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <%-- <style>
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

        .dataTables_scrollBody {
            min-height: 100px !important;
            height: auto;
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
            /*    background: linear-gradient(to bottom, #007bff, 3%, #fff) !important;*/
            color: #000;
        }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
        }

        .form-grid select {
            width: 250px;
        }
    </style>--%>


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


    <div class="modal fade" id="popUpSalarySlip">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Salary Slip</h4>
                    <button class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>

                <div class="modal-body" style="width: 700px; margin-left: 25px; margin-right: 25px;">
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

                <div class="modal-footer">
                    <button class="btn btn-success" onclick="printSlip()">Print</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

