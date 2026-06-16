<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ESIPFInformation.aspx.cs" Inherits="WebPortal.Admin.ESIPFInformation" %>

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
            esikyc_bindyear();
        });

        function esikyc_bindyear() {
            var start = new Date().getFullYear();

            var select = document.getElementById("esikyc_year");
            let options = select.getElementsByTagName('option');

            for (var i = options.length; i--;) {
                select.removeChild(options[i]);
            }

            $("#esikyc_year").append($("<option></option>").val("").html("Select"));
            for (var i = start; i > start - 5; i--) {
                $("#esikyc_year").append($("<option></option>").val(i).html(i));
            }
        }

        function esikyc_bindgrid() {
            $('#load1').show();
            var ddlmonth = document.getElementById("esikyc_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("esikyc_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            var table_empveri = '';
            $.ajax({
                url: "ESIPFInformation.aspx/GetESIPFInformationKYC",
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data: "{Month:'" + month + "', Year:" + year + "}",
                success: function (data) {
                    var dataArray = JSON.parse(data.d);//

                    table_empveri = $('#esikyc_table').DataTable({
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
                            { data: 'UserCode' },
                            { data: 'EmpName' },
                            { data: 'BranchName' },
                            { data: 'FatherName' },
                            { data: 'Gender' },
                            { data: 'MariatlStatus' },
                            { data: 'DateOfBirth' },
                            { data: 'AddressPresent' },
                            { data: 'AddressPermanent' },
                            { data: 'DOJ' },
                            { data: 'Nominee' },
                            { data: 'NRelation' },
                            { data: 'NDOB' },
                            { data: 'MemberName' },
                            { data: 'Age' },
                            { data: 'Relation' },
                            { data: 'BANKAccNo' },
                            { data: 'IFSC' },
                            { data: 'PAN' },
                            { data: 'AadharCardNo' },
                            { data: 'EmployeeMobileNo' },
                            { data: 'BasicSalary' }
                        ],
                        fnCreatedRow: function (nRow, aData, iDataIndex) {
                            $(nRow).children("td").css("text-wrap", "nowrap");
                        },

                        initComplete: function () {
                            $('#load1').hide();
                        },
                        buttons: [
                            {
                                extend: 'excelHtml5', title: 'ESI PF Information for KYC', autoFilter: true,
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
            $('#esikyc_table thead tr:eq(1) th').each(function () {

                //if (isSearch < 2) {
                    var title = $(this).text();
                    $(this).html('<input type="text" placeholder="Search ' + title + '" class="column_search" />');
                //}
                //else {
                //    $(this).html('');
                //}
                isSearch++;
            });

            $('#esikyc_table thead').on('keyup', ".column_search", function () {
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>ESI and PF Information for KYC</b></h6>
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
                            <select id="esikyc_month" name="esikyc_month" class="form-control">
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
                            <select id="esikyc_year" name="esikyc_year" class="form-control">
                                <option value="">Select</option>
                            </select>
                        </td>
                        <td style="width: 100px;">
                            <button id="esikyc_btnShow" class="btn btn-primary" onclick="return esikyc_bindgrid();">Show</button>

                        </td>
                    </tr>
                </table>
                <hr />
                <table class="table" id="esikyc_table" style="padding-top: 10px; width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Employee Name</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Father/Husband Name</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Gender</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Marital Status</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Date Of Birth</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Present Address</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Permanent Address</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Date Of Joining</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Nominee Name</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Nominee Relation</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Nominee Date Of Birth</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Family Member Name</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Family Member DOB</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Family Member Relation</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Bank Account #</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">IFSC</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">PAN</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Aadhar Card #</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Employee Mobile #</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Basic Salary</th>
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
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
