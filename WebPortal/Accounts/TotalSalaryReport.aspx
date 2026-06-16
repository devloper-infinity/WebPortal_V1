<%@ Page Title="" Language="C#" MasterPageFile="~/Accounts/Accounts.Master" AutoEventWireup="true" CodeBehind="TotalSalaryReport.aspx.cs" Inherits="WebPortal.Accounts.TotalSalaryReport" %>

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
            totalsalaryuser_bindyear();
            totalsalaryall_bindyear();
            totalsalaryuser_bindusers();
        });
        function totalsalaryuser_bindyear() {
            var start = new Date().getFullYear();

            var select = document.getElementById("totalsalaryuser_year");
            let options = select.getElementsByTagName('option');

            for (var i = options.length; i--;) {
                select.removeChild(options[i]);
            }

            $("#totalsalaryuser_year").append($("<option></option>").val("").html("Select"));
            for (var i = start; i > start - 5; i--) {
                $("#totalsalaryuser_year").append($("<option></option>").val((i) + '-' + (i + 1)).html((i) + '-' + (i + 1)));
            }
        }
        function totalsalaryall_bindyear() {
            var start = new Date().getFullYear();

            var select = document.getElementById("totalsalaryall_year");
            let options = select.getElementsByTagName('option');

            for (var i = options.length; i--;) {
                select.removeChild(options[i]);
            }

            $("#totalsalaryall_year").append($("<option></option>").val("").html("Select"));
            for (var i = start; i > start - 5; i--) {
                $("#totalsalaryall_year").append($("<option></option>").val((i) + '-' + (i + 1)).html((i) + '-' + (i + 1)));
            }
        }

        function totalsalaryall_bindyear() {
            var start = new Date().getFullYear();

            var select = document.getElementById("totalsalaryall_year");
            let options = select.getElementsByTagName('option');

            for (var i = options.length; i--;) {
                select.removeChild(options[i]);
            }

            $("#totalsalaryall_year").append($("<option></option>").val("").html("Select"));
            for (var i = start; i > start - 5; i--) {
                $("#totalsalaryall_year").append($("<option></option>").val((i) + '-' + (i + 1)).html((i) + '-' + (i + 1)));
            }
        }

        function totalsalaryuser_bindusers() {
            var select = document.getElementById("totalsalaryuser_employee");
            let options = select.getElementsByTagName('option');

            for (var i = options.length; i--;) {
                select.removeChild(options[i]);
            }
            $("#totalsalaryuser_employee").append($("<option></option>").val("").html("Select"));
            $.ajax({
                type: "POST", url: "TotalSalaryReport.aspx/GetAllCode", dataType: "json", contentType: "application/json",
                success: function (res) {
                    var dataArray = JSON.parse(res.d);
                    $.each(dataArray, function (data, value) {
                        $("#totalsalaryuser_employee").append($("<option></option>").val(value.Code).html(value.Code));
                    })
                }
            });
        }

        function totalsalaryuser_submit() {
            $('#load1').show();
            var ddlmonth = document.getElementById("totalsalaryuser_employee");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("totalsalaryuser_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            var table_empveri = '';
            $.ajax({
                url: "TotalSalaryReport.aspx/GetUserTotalSalaryReport",
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data: "{Code:'" + month + "', Period:'" + year + "'}",
                success: function (data) {
                    var dataArray = JSON.parse(data.d);//

                    table_empveri = $('#totalsalaryuser_table').DataTable({
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
                            { data: 'Name' },
                            { data: 'Month' },
                            { data: 'Year' },
                            { data: 'Basic1' },
                            { data: 'HRA1' },
                            { data: 'Incentive' },
                            { data: 'DueSalary' },
                            { data: 'Advance' },
                            { data: 'ESI' },
                            { data: 'ProfTax' },
                            { data: 'PF' },
                            { data: 'MLWF' },
                            { data: 'TDS' },
                            { data: 'NetSalary' },
                            { data: 'Bonus' },
                            { data: 'Incentive1' },
                            { data: 'LeaveEncashment' },
                            { data: 'TotalSalary' }
                        ],
                        fnCreatedRow: function (nRow, aData, iDataIndex) {
                            $(nRow).children("td").css("text-wrap", "nowrap");
                        },

                        initComplete: function () {
                            $('#load1').hide();
                        },
                        buttons: [
                            {
                                extend: 'excelHtml5', title: 'Total Salary Report', autoFilter: true,
                            },
                        ],
                    });

                },

                error: function (error) {
                    alert('error; ' + eval(error));
                    alert('error; ' + error.responseText);
                }
            });


            return false;
        }

        function totalsalaryall_submit() {
            $('#load1').show();
            var ddlyear = document.getElementById("totalsalaryall_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            var table_empveri = '';
            $.ajax({
                url: "TotalSalaryReport.aspx/GetAllTotalSalaryReport",
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data: "{Period:'" + year + "'}",
                success: function (data) {
                    var dataArray = JSON.parse(data.d);//

                    table_empveri = $('#totalsalaryall_table').DataTable({
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
                            { data: 'Name' },
                            { data: 'Yrs' },
                            { data: 'Basic' },
                            { data: 'HRA' },
                            { data: 'Inct' },
                            { data: 'DueSalary' },
                            { data: 'Advance' },
                            { data: 'ESI' },
                            { data: 'ProfTax' },
                            { data: 'PF' },
                            { data: 'MLWF' },
                            { data: 'TDS' },
                            { data: 'NetSalary' },
                            { data: 'Bonus' },
                            { data: 'Incentive1' },
                            { data: 'LeaveEncashment' },
                            { data: 'TotalSalary' }
                        ],
                        fnCreatedRow: function (nRow, aData, iDataIndex) {
                            $(nRow).children("td").css("text-wrap", "nowrap");
                        },

                        initComplete: function () {
                            $('#load1').hide();
                        },
                        buttons: [
                            {
                                extend: 'excelHtml5', title: 'Total Salary Report', autoFilter: true,
                            },
                        ],
                    });

                },

                error: function (error) {
                    alert('error; ' + eval(error));
                    alert('error; ' + error.responseText);
                }
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Total Salary Report</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12" id="mainleaveuser">
        <div class="card">
            <div class="card-body">
                <div class="card card-tabs">
                    <div class="card-header p-0 pt-1">
                        <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">User wise Report</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">All User Report</a>
                            </li>

                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                                <table class="table">
                                    <tr>
                                        <td><b>Employee:</b></td>
                                        <td>
                                            <select id="totalsalaryuser_employee" name="totalsalaryuser_employee" class="form-control" style="width: 250px;"></select>
                                        </td>
                                        <td><b>Financial Year:</b></td>
                                        <td>
                                            <select id="totalsalaryuser_year" name="totalsalaryuser_year" class="form-control" style="width: 250px;"></select>
                                        </td>
                                        <td>
                                            <button id="totalsalaryuser_btnsubmit" name="totalsalaryuser_btnsubmit" class="btn btn-primary" onclick="return totalsalaryuser_submit();">Show</button>
                                        </td>
                                    </tr>
                                </table>
                                <hr />
                                <table class="table table-bordered" style="width: 100%;" id="totalsalaryuser_table">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Month</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Year</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Basic</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">HRA</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Incentive</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Due Salary</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Advance</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">ESI</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Prof. Tax</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">PF</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">MLWF</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">TDS</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Net Salary</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Bonus</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Incentive</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Leave Encashment</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Total Salary</th>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                                <table class="table">
                                    <tr>
                                        <td><b>Financial Year:</b></td>
                                        <td>
                                            <select id="totalsalaryall_year" name="totalsalaryall_year" class="form-control" style="width: 250px;"></select>
                                        </td>
                                        <td>
                                            <button id="totalsalaryall_btnsubmit" name="totalsalaryall_btnsubmit" class="btn btn-primary" onclick="return totalsalaryall_submit();">Show</button>
                                        </td>
                                    </tr>
                                </table>
                                <hr />
                                <table class="table table-bordered" style="width: 100%;" id="totalsalaryall_table">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Month</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Basic</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">HRA</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Incentive</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Due Salary</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Advance</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">ESI</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Prof. Tax</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">PF</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">MLWF</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">TDS</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Net Salary</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Bonus</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Incentive</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Leave Encashment</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Total Salary</th>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
