<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="UnapprovedLeaveCount.aspx.cs" Inherits="WebPortal.Admin.UnapprovedLeaveCount" %>

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

        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dt-buttons {
            display: flex;
            align-items: center;
        }

        .dataTables_wrapper .dataTables_length {
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
            unappleave_bindyear();
        });

        function unappleave_bindyear() {
            var start = new Date().getFullYear();

            var select = document.getElementById("unappleave_year");
            let options = select.getElementsByTagName('option');

            for (var i = options.length; i--;) {
                select.removeChild(options[i]);
            }

            $("#unappleave_year").append($("<option></option>").val("0").html("Select"));
            for (var i = start; i > start - 5; i--) {
                $("#unappleave_year").append($("<option></option>").val(i).html(i));
            }
        }

        function unapprove_submit() {
            $('#load1').show();
            var ddldomain = document.getElementById("unappleave_domain");
            var ddlmonth = document.getElementById("unappleave_month");
            var ddlyear = document.getElementById("unappleave_year");
            var domainname = ddldomain.options[ddldomain.selectedIndex].text;
            var domain = ddldomain.options[ddldomain.selectedIndex].value;
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            var filename = domainname + "_" + month + "_" + year + "_Unapproved leaves count.xlsx";
            
            $.ajax({
                url: "UnapprovedLeaveCount.aspx/Getunapprovedleavecount",
                type: "POST",
                dataType: "json",
                data: "{DomainID:" + domain + ",Month:'" + month + "',Year:'" + year + "'}",
                contentType: "application/json; charset=utf-8",
                success: function (data) {


                    var dataArray = JSON.parse(data.d);//
                    $('#unappleave_table').DataTable({
                        dom: 'Bftip',
                        destroy: true,
                        orderCellsTop: true,
                        fixedHeader: true,
                        scrollY: "400px",       // Fixed height
                        scrollCollapse: true,   // Remove extra empty space
                        scrollX: true,
                        "paging": false,
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
                            { data: 'BranchName' },
                            { data: 'Domain' },
                            { data: 'Subdomain' },
                            { data: 'Current Status' },
                            { data: 'Latest Login Date' },
                            { data: 'LeaveCount' }
                        ],
                        fnCreatedRow: function (nRow, aData, iDataIndex) {
                            $(nRow).children("td").css("text-wrap", "nowrap");
                            $(nRow).children("td").css("text-align", "center");
                        },


                        initComplete: function () {
                            $('#load1').hide();

                        },
                        buttons: [
                            {
                                extend: 'excelHtml5', title: filename, autoFilter: true,


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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Unapproved Leave Count</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <table class="table">
                    <tr>
                        <td><b>Domain:</b></td>
                        <td>
                            <select id="unappleave_domain" name="unappleave_domain" class="form-control" style="width: 250px;">
                                <option value="">Select</option>
                                <option value="1">Non-DD</option>
                                <option value="2">Credit</option>
                                <option value="3">Servicing</option>
                            </select>
                        </td>
                        <td><b>Month:</b></td>
                        <td>
                            <select id="unappleave_month" name="unappleave_month" class="form-control" style="width: 250px;">
                                <option value="">Select</option>
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
                        <td><b>Year:</b></td>
                        <td>
                            <select id="unappleave_year" name="unappleave_year" class="form-control" style="width: 250px;">
                                <option value="">Select</option>
                            </select>
                        </td>
                        <td>
                            <button type="submit" id="btn_unappleave_search" name="btn_unappleave_search" onclick="return unapprove_submit();" class="btn btn-primary">Show</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <table class="table table-bordered" style="width: 100%;" id="unappleave_table">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align:center;">Code</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align:center;">Name</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align:center;">Branch</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align:center;">Domain</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align:center;">Subdomain</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align:center;">Current Status</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align:center;">Latest Login Dae</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align:center;"># of Absent Days</th>
                        </tr>
                    </thead>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
