<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="LogInDetailsOld.aspx.cs" Inherits="WebPortal.Admin.LogInDetailsOld" %>

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

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: normal !important;
            border: none !important;
        }

        .dataTables_paginate {
            float: left !important;
        }

        .table td, .table th {
            padding: 5px 10px !important;
        }

        .table.dataTable th {
            /*background:linear-gradient(to bottom, #0070C0, 80%, #ffffff);*/
            background: linear-gradient(to bottom, #cbd0dd, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none;
        }
    </style>

   

    <script>
        var PMCode;
        var html;
        var logtable;
        var edittable;

        $(document).ready(function () {
            BindLogGrid('');
        });

        function blankForNull(s) {
            return s == "null" || s == null ? "" : s;
        }

        function BindLogGrid(NewDate) {
            var currentUserName = '<%= HttpContext.Current.User.Identity.Name.ToString() %>';
            const urlParams = new URLSearchParams(window.location.search);
            const Code = urlParams.get('EmployeeID');
            if (Code == "" || Code == null) {
                PMCode = <%= HttpContext.Current.User.Identity.Name.ToString() %>;

            }
            else {
                PMCode = Code;
            }
            var date;
            if (NewDate == '')
                // date = new Date(Date.now()).toLocaleString().split(',')[0];
                date = new Date().toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' }).replace(/ /g, '-');
            else
                date = new Date(NewDate).toLocaleString().split(',')[0];;
            html = '';
            $('#load1').show();
            $.ajax({
                url: "LogInDetails.aspx/BindLogGrid",
                type: "POST",
                dataType: "json",
                data: "{Code:'" + PMCode + "', Date:'" + date + "'}",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    var dataArray = JSON.parse(data.d);//
                    $.each(dataArray, function (index, value) {

                        //var date = eval(value.LastLoginDate.replace(/\/Date\((\d+)\)\//gi, "new Date($1).toLocaleDateString(\"en-US\")"));
                        if (value.ACTIVE == "Block")
                            html += '<tr style="color:brown;">';
                        else if (value.COT.includes("Awaited"))
                            html += '<tr style="color:red;">';
                        else
                            html += '<tr>';
                        html += '<td class=""><div class="btn-group">';
                        html += '<div class="btn-group">';
                        html += '<div type="button" data-toggle="dropdown" aria-expanded="false"><i style="color: dodgerblue; font-size:14px;" class="uil fs-0 me-2 uil-cog"></i>';
                        html += '<span class="sr-only"></span></div><div class="dropdown-menu" role="menu" style="">';
                        if (currentUserName == 12 || currentUserName == 7036 || currentUserName == 216 || currentUserName == 8082 || currentUserName == 285 || currentUserName == 255 || currentUserName == 291 || currentUserName == 8535 || currentUserName == 277 || currentUserName == 9738 || currentUserName == 99) {
                            if (value.ACTIVE == "Block")
                                html += '<a class="dropdown-item" href="#!" id="Actions" onclick="block(\'' + value.code + '\',' + index + ',1);"><span style="color: forestgreen;"><i class="uil fs-0 me-2 uil-check-square"></i></span>&nbsp;&nbsp;Activate ERP Login</a>';
                            else
                                html += '<a class="dropdown-item" href="#!" id="Actions" onclick="block(\'' + value.code + '\',' + index + ',0);"><span style="color: red;"><i class="uil fs-0 me-2 uil-check-square"></i></span>&nbsp;&nbsp;Block ERP Login</a>';
                        }
                        else
                            html += '<a class="dropdown-item isDisabled" href="#!" id="Actions" ><span style="color: red;"><i class="uil fs-0 me-2 uil-check-square"></i></span>&nbsp;&nbsp;Block/Activate ERP Login</a>';
                        html += '<a class="dropdown-item" href="#!" id="ActionsEx" onclick="ViewLog(\'' + value.code + '\',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-pen"></i></span>&nbsp;&nbsp;View Log Details</a><div class="dropdown-divider"></div></div ></div></td>';

                        //html += '<button class="btn btn-secondary buttons-collection dropdown-toggle buttons-colvis" tabindex="0" aria-controls="example1" type="button" aria-haspopup="true" aria-expanded="false"">';
                        //html += '<span style="color: Mediumslateblue;" class="dt-down-arrow"><i class="fa-solid fa-cog"></i></span></button><div class="dt-button-background" style=""></div><div class="dt-button-collection" style=""><div class="dropdown-menu">';
                        //if (value.ACTIVE == "Block")
                        //    html += '<a class="dropdown-item" href="#!" id="Actions" onclick="block(\'' + value.code + '\',' + index + ',1);"><span style="color: forestgreen;"><i class="fa-solid fa-check"></i></span>&nbsp;&nbsp;Activate ERP Login</a>';
                        //else
                        //    html += '<a class="dropdown-item" href="#!" id="Actions" onclick="block(\'' + value.code + '\',' + index + ',0);"><span style="color: red;"><i class="fa-solid fa-xmark"></i></span>&nbsp;&nbsp;Block ERP Login</a>';
                        //html += '<a class="dropdown-item" href="#!" id="ActionsEx" onclick="ViewLog(\'' + value.code + '\',' + index + ');"><span style="color: dodgerblue;"><i class="fa-solid fa-pen"></i></span>&nbsp;&nbsp;View Log Details</a>';
                        //html += '</div></div></div></td>';
                        html += '<td>' + value.code + '</td>';
                        html += '<td>' + value.name + '</td>';
                        html += '<td>' + value.COT + '</td>';
                        html += '<td>' + blankForNull(value.in) + '</td>';
                        html += '<td>' + blankForNull(value.out) + '</td>';
                        html += '<td>' + blankForNull(value.LastLoginDate) + '</td>';
                        html += '<td>' + blankForNull(value.in_ip) + '</td>';
                        html += '<td>' + blankForNull(value.out_ip) + '</td>';
                        html += '</tr>';
                    });

                    if ($.fn.dataTable.isDataTable('#log')) {
                        edittable.destroy();
                    }
                    $('#log tbody').html(html);

                    //else
                    {
                        edittable = $('#log').DataTable({
                            dom: 'pfti',
                            scrollX: false,
                            destroy: true,
                            fixedHeader: true,
                            paging: true,
                            "autoWidth": true,
                            select: true,
                            processing: true,
                            'select': {
                                'style': 'single'
                            },

                            initComplete: function () {
                                $('#load1').hide();
                            },
                            "rowCallback": function (row, data) {
                                // Cell at index 5 in the row is 'Active'.
                                var val = data[3];
                            },
                        });
                    }

                    //$('#fnalize tbody').on('click', 'tr', function () {
                    //    row = table.row(this).data();
                    //});
                },

                error: function (error) {
                    alert('error; ' + eval(error));
                    alert('error; ' + error.responseText);
                }
            });
        }

        function ViewLog(Code, Index) {
            var row = edittable.row(Index).data();
            location.href = "ViewLog.aspx?Code=" + Code;
        }

        function block(Code, Index, Type) {
            var row = edittable.row(Index).data();
            if (Type == 0) {
                document.getElementById("blockunblockLabel").innerHTML = "Block ERP Login";
                document.getElementById("btnApprove").innerHTML = "Block";
                document.getElementById("lblcurrentstatus").innerHTML = "Active";
            }
            else {
                document.getElementById("blockunblockLabel").innerHTML = "Activate ERP Login";
                document.getElementById("btnApprove").innerHTML = "Activate";
                document.getElementById("lblcurrentstatus").innerHTML = "Blocked";
            }
            document.getElementById("lblcode").innerHTML = Code;
            document.getElementById("lblname").innerHTML = row[2];
            document.getElementById("lbllatestlogindate").innerHTML = row[6];
            $('#blockunblock').modal("show");
        }

        function bindchangegrid(ddldate) {
            var date = ddldate.options[ddldate.selectedIndex].text;
            BindLogGrid(date);
        }

        function blankForNull(s) {
            return s == "null" || s == null ? "" : s;
        }

        function SubmitAction() {
            var code = document.getElementById("lblcode").innerHTML;
            var status = document.getElementById("lblcurrentstatus").innerHTML;
            var tobestatus;
            if (status == "Active")
                tobestatus = "Blocked"
            else
                tobestatus = "Activated"
            var remark = document.getElementById("remark").value;
            if (remark == "") {
                alert("Please enter remark");
                return;
            }
            if (remark.length < 10) {
                alert("Remark should be more than 10 characters.");
                return;
            }

            $('#waitingpanel').modal('show');
            $('#blockunblock').modal("hide");
            PageMethods.BlockUnblockLogin(code, tobestatus, remark, OnSuccedd, OnError)
            return false;
        }

        function OnSuccedd(result) {
            $('#blockunblock').modal("hide");
            $('#waitingpanel').modal('hide');
            alert('Status updated successfully!');
            location.reload();
        }

        function OnError() {
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Log Details</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="modal fade" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;">System is updating details. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">

                  <table class="table" id="log" style="padding-top: 10px; width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top" style="text-wrap: avoid;">Actions</th>
                            <th class="sort border-top">Code</th>
                            <th class="sort border-top">Name</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Cut Off Time</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">In Time</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Out Time</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Latest Login Date</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">IN IP</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Out IP</th>

                        </tr>
                    </thead>
                    <tbody></tbody>

                </table>


            </div>
        </div>
    </div>


    <div class="modal fade" id="blockunblock">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="blockunblockLabel">Activate/ Block ERP Login</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table table-responsive">
                        <tr>
                            <td><b>Code:</b></td>
                            <td>
                                <label id="lblcode" name="lblcode" class="form-control" style="width: 300px;"></label>
                            </td>
                            <td><b>Name:</b></td>
                            <td>
                                <label id="lblname" name="lblname" class="form-control" style="width: 300px;"></label>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Latest Login Date:</b></td>
                            <td>
                                <label id="lbllatestlogindate" name="lbllatestlogindate" class="form-control" style="width: 300px;"></label>
                            </td>
                            <td><b>Current Status:</b></td>
                            <td>
                                <label id="lblcurrentstatus" name="lblcurrentstatus" class="form-control" style="width: 300px;"></label>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Remark:</b></td>
                            <td>
                                <textarea id="remark" name="remark" class="form-control" style="width: 300px;"></textarea>
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button class="btn btn-primary" type="button" id="btnApprove" onclick="SubmitAction();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

</asp:Content>
