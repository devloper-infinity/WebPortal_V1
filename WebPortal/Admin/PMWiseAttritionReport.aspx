<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="PMWiseAttritionReport.aspx.cs" Inherits="WebPortal.Admin.PMWiseAttritionReport" %>

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
    
        .dataTables_scrollHeadInner,
.dataTables_scrollHeadInner table {
    width: 100% !important;
}
    </style>

    <script>
        $(document).ready(function () {
            pmatr_bindpm();
        });

<%--        function attrition_Exporttoexcel() {
            __doPostBack("<%= btn21.UniqueID %>", '');
            return false;
        }--%>
        function pmatr_bindpm() {
            var select = document.getElementById("pmatr_pm");
            let options = select.getElementsByTagName('option');

            for (var i = options.length; i--;) {
                select.removeChild(options[i]);
            }
            $("#pmatr_pm").append($("<option></option>").val("").html("Select"));
            $.ajax({
                type: "POST", url: "PMWiseAttritionReport.aspx/GetReportingManagerList", dataType: "json", contentType: "application/json",
                success: function (res) {
                    var dataArray = JSON.parse(res.d);
                    $.each(dataArray, function (data, value) {
                        $("#pmatr_pm").append($("<option></option>").val(value.PMID).html(value.PMName));
                    })
                }
            });
        }

        function pmatr_Submit() {
            $('#load1').show();
            var columns = [];
            var fromdate = document.getElementById("pmatr_from").value;
            var todate = document.getElementById("pmatr_to").value;
            var ddlpm = document.getElementById("pmatr_pm");
            var pm = ddlpm.options[ddlpm.selectedIndex].value;

            $.ajax({
                url: "PMWiseAttritionReport.aspx/GetReportingManagerWiseAttrition",
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data: "{FromDate:'" + fromdate + "', ToDate:'" + todate + "',PMID:" + pm + "}",
                success: function (data) {
                    var dataArray = JSON.parse(data.d);//
                    $.each(dataArray[0], function (key, value) {

                        var my_item = {};
                        my_item.data = key;
                        my_item.title = key;
                        columns.push(my_item);
                    });
                    $('#pmatr_table').DataTable({
                        dom: 'lBftip',
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
                        columns: columns,
                        fnCreatedRow: function (nRow, aData, iDataIndex) {
                            $(nRow).children("td").css("text-wrap", "nowrap");
                        },

                        initComplete: function () {
                            $('#load1').hide();
                        },
                        buttons: [
                            {
                                extend: 'excelHtml5', title: 'Summary Report', autoFilter: true,
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

        function pmatr_bindnew() {
            $('#load1').show();
            var columns = [];

            $.ajax({
                url: "PMWiseAttritionReport.aspx/GetNewJoined",
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    var dataArray = JSON.parse(data.d);//
                    $.each(dataArray[0], function (key, value) {

                        var my_item = {};
                        my_item.data = key;
                        my_item.title = key;
                        columns.push(my_item);
                    });
                    $('#pmatrnew_table').DataTable({
                        dom: 'lBftip',
                        destroy: true,
                        scrollX: true,
                        scrollCollapse: true,
                        paging: true,
                        autoWidth: false,   // 🔥 IMPORTANT
                        select: true,
                        ordering: false,
                        processing: true,
                        filter: true,
                        serverSide: false,
                        data: dataArray,
                        columns: columns,
                      

                        initComplete: function () {
                            $('#load1').hide();
                        },
                        buttons: [
                            {
                                extend: 'excelHtml5', title: 'New Joined Employees', autoFilter: true,
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

        function pmatr_bindresigned() {
            $('#load1').show();
            var columns = [];

            $.ajax({
                url: "PMWiseAttritionReport.aspx/GetResignedEmployees",
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    var dataArray = JSON.parse(data.d);//
                    $.each(dataArray[0], function (key, value) {

                        var my_item = {};
                        my_item.data = key;
                        my_item.title = key;
                        columns.push(my_item);
                    });
                    $('#pmatrRes_table').DataTable({
                        dom: 'lBftip',
                        destroy: true,
                        orderCellsTop: true,
                        fixedHeader: true,
                        scrollX: true,
                        scrollCollapse: true,
                        paging: true,
                        autoWidth: false,   // 🔥 IMPORTANT
                        select: true,
                        ordering: false,
                        processing: true,
                        filter: true,
                        serverSide: false,
                        data: dataArray,
                        columns: columns,
                        fnCreatedRow: function (nRow, aData, iDataIndex) {
                            $(nRow).children("td").css("text-wrap", "nowrap");
                        },

                        initComplete: function () {
                            $('#load1').hide();
                        },
                        buttons: [
                            {
                                extend: 'excelHtml5', title: 'Resigned Employees', autoFilter: true,
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

     

        function pmatr_Exporttoexcel() {
            __doPostBack("<%= btn21.UniqueID %>", '');
            return false;
        }


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Button ID="btn21" runat="server" Style="display: none;" OnClick="btn21_Click" />
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Attrition Report - Reporting Manager</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <h5 class="card-title"></h5>
                <table class="table">
                    <tr>
                        <td><b>Reporting Manager:</b></td>
                        <td>
                            <select id="pmatr_pm" name="pmatr_pm" class="form-control" style="width: 250px;"></select>
                        </td>
                        <td><b>From Date:</b></td>
                        <td>
                            <input type="date" id="pmatr_from" name="pmatr_from" class="form-control" style="width: 250px;" />
                        </td>
                        <td>
                            <b>To Date:</b>
                        </td>
                        <td>
                            <input type="date" id="pmatr_to" name="pmatr_to" class="form-control" style="width: 250px;" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="6" style="text-align: center;">
                            <button id="pmatr_btnShow" class="btn btn-primary" onclick="return pmatr_Submit()">Show</button>
                            <button id="pmatr_btnExporttoexcel" class="btn btn-secondary" onclick="return pmatr_Exporttoexcel();">Export to excel</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <div class="card card-tabs">
                    <div class="card-header p-0 pt-1">
                        <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Summary</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" onclick="return pmatr_bindnew();" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">New Joined</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" onclick="return pmatr_bindresigned();" id="custom-tabs-one-exclude-tab" data-toggle="pill" href="#custom-tabs-one-exclude" role="tab" aria-controls="custom-tabs-one-exclude" aria-selected="false">Absconding/ Resigned</a>
                            </li>

                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                                <table class="table table-bordered" style="width: 100%;" id="pmatr_table"></table>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                                <table class="table table-bordered" style="width: 100%;" id="pmatrnew_table"></table>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-exclude" role="tabpanel" aria-labelledby="custom-tabs-one-exclude-tab">
                                <table class="table table-bordered" style="width: 100%;" id="pmatrRes_table"></table>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

</asp:Content>
