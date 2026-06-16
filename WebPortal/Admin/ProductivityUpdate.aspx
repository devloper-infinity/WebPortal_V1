<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ProductivityUpdate.aspx.cs" Inherits="WebPortal.Admin.ProductivityUpdate" %>

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

        .dt-center {
            text-align: center;
        }
        /*.form-control {
            font-size: 11px !important;
        }*/
    </style>
    <script>
        $(document).ready(function () {
        });

        function blankForNull(s) {
            return s == "null" || s == null ? "" : s;
        }

        $(document).on("click", ".singleCheck", function (e) {
            // Ignore datatable redraw / script trigger
            if (!e.originalEvent) return;

            const id = $(this).attr("id").split("_")[1]; // row index
            const type = $(this).hasClass("nodata") ? "No Volume" : "Low Volume";
            const isChecked = $(this).is(":checked");

            if (type === "No Volume") {
                UpdateNoVolume(id, isChecked);
            } else {
                UpdateLowVolume(id, isChecked);
            }
        });

        $(document).on("change", ".remarkInput", function (e) {
            if (!e.originalEvent) return; // ignore programmatic changes

            let rowId = $(this).attr("id").split("_")[1];
            let value = $(this).val();

            UpdateRemark(rowId, value);
        });

        function BindGridView() {
            $('#load1').show();
            var FromDate = document.getElementById("updup_fromdate").value;
            var ToDate = document.getElementById("updup_todate").value;
            FromDate = '31-Oct-2025'
            ToDate = '31-Oct-2025'
            var columns = [];
            $.ajax({
                url: "ProductivityUpdate.aspx/GetProductivityForUpdate",
                type: "POST",
                dataType: "json",
                data: "{FromDate:'" + FromDate + "', ToDate:'" + ToDate + "'}",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    var columncount = 0;
                    var dataArray = JSON.parse(data.d);//
                    $.each(dataArray[0], function (key, value) {
                        var my_item = {};
                        my_item.data = key;
                        my_item.title = key;
                        columns.push(my_item);
                        columncount++;
                    });
                    $('#updup_tableprod').DataTable({
                        dom: 'ft',
                        destroy: true,
                        orderCellsTop: true,
                        fixedColumns: {
                            leftColumns: 2,
                        },
                        scrollCollapse: false,
                        scrollY: '400px',
                        scrollX: true,
                        "paging": false,
                        "autoWidth": true,
                        select: true,
                        "ordering": true,
                        processing: true,
                        'select': {
                            'style': 'single'
                        },
                        "data": dataArray,
                        "columns": columns,

                        initComplete: function () {
                            $("#load1").hide();
                        },
                        buttons: [

                            {
                                extend: 'excelHtml5', title: 'Daily Production Update', autoFilter: true,
                                className: 'btn btn-datatable',
                                exportOptions: {
                                    columns: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
                                }
                            }
                        ],
                        columnDefs: [
                            {
                                targets: (columncount - 3),
                                "width": "45px",
                                render: function (data, type, row, meta) {
                                    if (parseFloat(row.TotalProduction) < 100) {
                                        if (blankForNull(row.Actions) == "Zero Volume") {
                                            return '<input type="checkbox" checked="checked" id="nodata_' + meta.row + '" name="volume_' + meta.row + '" class="singleCheck nodata" value="No Volume" /> No Volume &nbsp;&nbsp;' +
                                                '<input type="checkbox" id="lowdata_' + meta.row + '" name="volume_' + meta.row + '" class="singleCheck lowdata" value="Low Volume" /> Low Volume';
                                        }
                                        else if (blankForNull(row.Actions) == "Low Volume") {
                                            return '<input type="checkbox" id="nodata_' + meta.row + '" name="volume_' + meta.row + '" class="singleCheck nodata" value="No Volume" /> No Volume &nbsp;&nbsp;' +
                                                '<input type="checkbox" checked="checked" id="lowdata_' + meta.row + '" name="volume_' + meta.row + '" class="singleCheck lowdata" value="Low Volume" /> Low Volume';
                                        }
                                        else {
                                            return '<input type="checkbox" id="nodata_' + meta.row + '" name="volume_' + meta.row + '" class="singleCheck nodata" value="No Volume" /> No Volume &nbsp;&nbsp;' +
                                                '<input type="checkbox" id="lowdata_' + meta.row + '" name="volume_' + meta.row + '" class="singleCheck lowdata" value="Low Volume" /> Low Volume';
                                        }
                                    }
                                    else {
                                        return '<input type="checkbox" disabled="disabled" name="volume_' + meta.row + '" class="singleCheck" value="No Volume" onclick="return UpdateNoVolume(\'' + meta.row + '\');" /> No Volume &nbsp;&nbsp;' +
                                            '<input type="checkbox" disabled="disabled" name="volume_' + meta.row + '" class="singleCheck" value="Low Volume" onclick="return UpdateLowVolume(\'' + meta.row + '\');" /> Low Volume';
                                    }
                                }
                            },
                            {
                                targets: (columncount - 2),
                                "width": "45px",
                                render: function (data, type, row, meta) {
                                    if (parseFloat(row.TotalProduction) < 100) {
                                        if (blankForNull(row.Remark) != "")
                                            return '<input type="text" value="' + row.Remark + '" id="remark_' + meta.row + '" class="form-control remarkInput" style="width:250px;" /> ';
                                        else
                                            return '<input type="text" id="remark_' + meta.row + '" class="form-control remarkInput" style="width:250px;" /> ';
                                    }
                                    else {
                                        return '<input type="text" id="remark_' + meta.row + '" disabled="disabled" class="form-control" style="width:250px;" /> ';
                                    }
                                }

                            },
                            {
                                targets: (columncount - 1),
                                visible: false
                            }
                        ],

                        fnCreatedRow: function (nRow, aData, iDataIndex) {
                            $(nRow).children("td").css("text-wrap", "nowrap");
                            $(nRow).children("td").css("text-align", "center");
                        },
                    });

                },
                error: function (error) {
                    alert('error; ' + eval(error));
                    alert('error; ' + error.responseText);
                }
            });
            return false;
        }

        function UpdateNoVolume(index, value) {
            var rows = $('#updup_tableprod').DataTable().row(index).data();
            var Code = rows["Code"];
            var Project = rows["Project #"];
            var Process = rows["Process"];
            var ProcessDate = rows["Process Date"];
            var radiono = document.getElementById("nodata_" + index);
            if (value == true) {
                document.getElementById("lowdata_" + index).checked = false;
            }
            var VolumeData = "Zero Volume";
            var Type = "Volume";
            var Remark = "";
            var checked = value;
            PageMethods.UpdateVolumeData(Code, Project, Process, ProcessDate, VolumeData, Remark, Type, checked, updatenovolume_OnSuccess, updatenovolume_OnError);
            return false;
        }
        function updatenovolume_OnSuccess(result) {

            return false;
        }
        function updatenovolume_OnError(error) {
            alert(error.get_message());
            return false;
        }
        function UpdateLowVolume(index, value) {
            var rows = $('#updup_tableprod').DataTable().row(index).data();
            var Code = rows["Code"];
            var Project = rows["Project #"];
            var Process = rows["Process"];
            var ProcessDate = rows["Process Date"];
            var radiono = document.getElementById("lowdata_" + index);
            if (value == true) {
                document.getElementById("nodata_" + index).checked = false;
            }
            var VolumeData = "Low Volume";
            var Type = "Volume";
            var checked = value;
            var Remark = "";
            PageMethods.UpdateVolumeData(Code, Project, Process, ProcessDate, VolumeData, Remark, Type, checked, updatelowvolume_OnSuccess, updatelowvolume_OnError);
            return false;
        }
        function updatelowvolume_OnSuccess(result) {
            return false;
        }
        function updatelowvolume_OnError(error) {
            alert(error.get_message());
            return false;
        }

        function UpdateRemark(index, value) {
            var rows = $('#updup_tableprod').DataTable().row(index).data();
            var Code = rows["Code"];
            var Project = rows["Project #"];
            var Process = rows["Process"];
            var ProcessDate = rows["Process Date"];
            var radiono = document.getElementById("lowdata_" + index);
            if (radiono.checked == true) {
                document.getElementById("nodata_" + index).checked = false;
            }
            var VolumeData = "";
            var Type = "Remark";
            var Remark = value;
            var checked = false;
            PageMethods.UpdateVolumeData(Code, Project, Process, ProcessDate, VolumeData, Remark, Type, checked, updatelowvolume_OnSuccess, updatelowvolume_OnError);
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>User Production Updates</b></h6>
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
                        <td><b>From Date:</b></td>
                        <td>
                            <input type="date" id="updup_fromdate" name="updup_fromdate" class="form-control" style="width: 250px;" />
                        </td>
                        <td><b>To Date:</b></td>
                        <td>
                            <input type="date" id="updup_todate" name="updup_todate" class="form-control" style="width: 250px;" />
                        </td>
                        <td>
                            <button id="updup_btnsubmit" name="updup_btnsubmit" onclick="return BindGridView();" class="btn btn-primary">Submit</button>
                            <button id="updup_btnexport" name="updup_btnsubmit" style="display: none;" onclick="return updup_export();" class="btn btn-primary">Export to excel</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <table class="table table-bordered" id="updup_tableprod" style="width: 100%;">
                </table>
            </div>
        </div>
    </div>
    <div class="modal fade" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">System is updating details. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>
</asp:Content>
