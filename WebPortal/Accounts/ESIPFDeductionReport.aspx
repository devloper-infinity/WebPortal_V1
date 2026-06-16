<%@ Page Title="" Language="C#" MasterPageFile="~/Accounts/Accounts.Master" AutoEventWireup="true" CodeBehind="ESIPFDeductionReport.aspx.cs" Inherits="WebPortal.Accounts.ESIPFDeductionReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
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

        .dataTables_paginate {
            float: left !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 50px;
            float: left;
        }

        .buttons-excel {
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
            /*background:linear-gradient(to bottom, #0070C0, 80%, #ffffff);*/
            background: linear-gradient(to bottom, #cbd0dd, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none;
        }
        /*.form-control {
            font-size: 11px !important;
        }*/
    </style>
    <script>
        $(document).ready(function () {
            esipfreport_bindyear();
        });
        function esipfreport_bindyear() {
            var start = new Date().getFullYear();

            var select = document.getElementById("esipfreport_year");
            let options = select.getElementsByTagName('option');

            for (var i = options.length; i--;) {
                select.removeChild(options[i]);
            }

            $("#esipfreport_year").append($("<option></option>").val("").html("Select"));
            for (var i = start; i > start - 5; i--) {
                $("#esipfreport_year").append($("<option></option>").val(i).html(i));
            }
        }
        function esipfreport_bindgrid() {
            $('#load1').show();
            var ddlmonth = document.getElementById("esipfreport_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("esipfreport_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            var table_empveri = '';
            $.ajax({
                url: "ESIPFDeductionReport.aspx/GetESIPFDeductionReport",
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data: "{Month:'" + month + "', Year:" + year + "}",
                success: function (data) {
                    var dataArray = JSON.parse(data.d);//

                    table_empveri = $('#esipfreport_table').DataTable({
                        dom: 'Bftip',
                        destroy: true,
                        orderCellsTop: true,
                        fixedHeader: true,
                        scrollX: true,
                        "paging": true,
                        "autoWidth": true,
                        select: true,
                        "ordering": false,
                        processing: true,
                        filter: true,
                        'select': {
                            'style': 'single'
                        },
                        "serverSide": false,
                        "data": dataArray,
                        columns: [
                            { data: 'Code' },
                            { data: 'FullName' },
                            { data: 'Branch' },
                            { data: 'DomainName' },
                            { data: 'SubDomain' },
                            { data: 'DepartmentName' },
                            { data: 'DesignationName' },
                            { data: 'JoiningDate' },
                            { data: 'DOB' },
                            { data: 'Gender' },
                            { data: 'PAN' },
                            { data: 'AdahrNo' },
                            { data: 'PerAddress' },
                            { data: 'Account' },
                            { data: 'TotalMonths' },
                            { data: 'Basic' },
                            { data: 'HRA' },
                            { data: 'AttendanceBonusSTD' },
                            { data: 'Salary' },
                            { data: 'ActualDays' },
                            { data: 'FullDay' },
                            { data: 'PartialDayCount' },
                            { data: 'PartialDay' },
                            { data: 'Basic1' },
                            { data: 'HRA1' },
                            { data: 'AttendanceBonus' },
                            { data: 'Incentive1' },
                            { data: 'SalaryArrears' },
                            { data: 'NightBonus' },
                            { data: 'Allowance' },
                            { data: 'DueSalary' },
                            { data: 'Advance' },
                            { data: 'Penalty' },
                            { data: 'ESI' },
                            { data: 'PF' },
                            { data: 'ProfTax' },
                            { data: 'TDS' },
                            { data: 'MLWF' },
                            { data: 'Other' },
                            { data: 'TotalDeduction' },
                            { data: 'NetSalary' },
                            { data: 'LatestLoginDate' },
                            { data: 'CurrentStatus' },
                            { data: 'HoldRemark' },
                            { data: 'FeedbackCount' }
                        ],
                        fnCreatedRow: function (nRow, aData, iDataIndex) {
                            $(nRow).children("td").css("text-wrap", "nowrap");
                        },

                        initComplete: function () {
                            $('#load1').hide();
                        },
                        buttons: [
                            {
                                extend: 'excelHtml5', title: 'ESI PF Deduction Report', autoFilter: true,
                            },
                        ],
                    });

                },

                error: function (error) {
                    alert('error; ' + eval(error));
                    alert('error; ' + error.responseText);
                }
            });

            var isSearch = 0;
            $('#esipfreport_table thead tr:eq(1) th').each(function () {

                //if (isSearch < 2) {
                var title = $(this).text();
                $(this).html('<input type="text" placeholder="Search ' + title + '" class="column_search" />');
                //}
                //else {
                //    $(this).html('');
                //}
                isSearch++;
            });

            $('#esipfreport_table thead').on('keyup', ".column_search", function () {
                table_empveri
                    .column($(this).parent().index())
                    .search(this.value)
                    .draw();
            });

            return false;
        }
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>ESI PF Deduction Report</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12" id="mainleaveuser">
        <div class="card">
            <div class="card-body">
                <table class="table">
                    <tr>
                        <td style="width: 50px;"><b>Month:</b></td>
                        <td style="width: 150px;">
                            <select id="esipfreport_month" name="esipfreport_month" class="form-control">
                                <option value="">Select</option>
                                <option value="All">All</option>
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
                        <td style="width: 50px;">
                            <b>Year:</b>
                        </td>
                        <td style="width: 150px;">
                            <select id="esipfreport_year" name="esipfreport_year" class="form-control">
                                <option value="">Select</option>
                            </select>
                        </td>
                        <td style="width: 100px;">
                            <button id="esipfreport_btnShow" class="btn btn-primary" onclick="return esipfreport_bindgrid();">Show</button>

                        </td>
                    </tr>
                </table>
                <hr />
                <table class="table" id="esipfreport_table" style="padding-top: 10px; width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Domain</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Subdomain</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Department</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Designation</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Joining Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Date of Birth</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Gender</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">PAN</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Aadhar #</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Permanent Address</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Account #</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Total Months</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Basic</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">HRA</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Attendance Bonus</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Salary</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Total Days</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Full Days</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Partial Days Count</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Actual Partial Days</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Calculated Basic</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Calculated HRA</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Calculated Attendance Bonus</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Special Incentive</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Salary Arrears</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Night Bonus</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Allowances</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Due Salary</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Advance</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Penalty</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">ESI</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">PF</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Prof. Tax</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">TDS</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">MLWF</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Other</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Total Deduction</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Net Salary</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Latest Login Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Current Status</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Remark</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Feedback Count</th>
                        </tr>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"></th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
