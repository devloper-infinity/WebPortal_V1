<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Requisition.aspx.cs" Inherits="WebPortal.Admin.Requisition" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

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
            background: linear-gradient(to bottom, #007bff, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
        }

        /*.form-control {
            font-size: 11px !important;
        }*/
    </style>

    <script type="text/javascript">
        $(document).ready(function () {



            $.ajax({
                type: "POST", url: "Requisition.aspx/GetAllDomainGroups", dataType: "json", contentType: "application/json",
                success: function (res) {
                    $.each(res.d, function (data, value) {
                        $("#domain").append($("<option></option>").val(value.DomainID).html(value.DomainName));
                    })
                }

            });

            $.ajax({
                type: "POST", url: "Requisition.aspx/GetAllRequisitionProfiles", dataType: "json", contentType: "application/json",
                success: function (res) {
                    $.each(res.d, function (data, value) {
                        $("#reqprofile").append($("<option></option>").val(value.ProfileId).html(value.Profile));
                    })
                }

            });

            $.ajax({
                type: "POST", url: "Requisition.aspx/GetProjects", dataType: "json", contentType: "application/json",
                success: function (res) {
                    $.each(res.d, function (data, value) {
                        $("#projects").append($("<option></option>").val(value.ProjectID).html(value.ProjectName));
                    })
                }

            });

            $.ajax({
                type: "POST", url: "Requisition.aspx/GetShift", dataType: "json", contentType: "application/json",
                success: function (res) {
                    $.each(res.d, function (data, value) {
                        $("#shift").append($("<option></option>").val(value.ShiftID).html(value.ShiftTime));
                    })
                }

            });

            $.ajax({
                type: "POST", url: "Requisition.aspx/GetDepartment", dataType: "json", contentType: "application/json",
                success: function (res) {
                    $.each(res.d, function (data, value) {
                        $("#department").append($("<option></option>").val(value.DepartmentID).html(value.DepartmentName));
                    })
                }

            });

        })

        function ondomainclick() {
            var select = document.getElementById("subdomain");
            let options = select.getElementsByTagName('option');

            for (var i = options.length; i--;) {
                select.removeChild(options[i]);
            }

            var ddlDomain = document.getElementById('domain');
            var index = ddlDomain.selectedIndex;
            var DomainGroupId = ddlDomain.options[index].value;
            $("#subdomain").append($("<option></option>").val("").html("Select"));
            $.ajax({
                type: "POST", url: "Requisition.aspx/GetSubdomains", dataType: "json", contentType: "application/json",
                data: "{DomainGroupId:" + DomainGroupId + "}",
                success: function (res) {
                    $.each(res.d, function (data, value) {
                        $("#subdomain").append($("<option></option>").val(value.SubdomainID).html(value.SubdomainName));
                    })
                }

            });
        }

        function onprojectclick() {
            var select = document.getElementById("process");
            let options = select.getElementsByTagName('option');

            for (var i = options.length; i--;) {
                select.removeChild(options[i]);
            }

            var ddlProject = document.getElementById('projects');
            var index = ddlProject.selectedIndex;
            var ProjectID = ddlProject.options[index].value;
            $("#process").append($("<option></option>").val("").html("Select"));
            $.ajax({
                type: "POST", url: "Requisition.aspx/GetProcess", dataType: "json", contentType: "application/json",
                data: "{ProjectID:" + ProjectID + "}",
                success: function (res) {
                    $.each(res.d, function (data, value) {
                        $("#process").append($("<option></option>").val(value.ProcessID).html(value.ProcessName));
                    })
                }

            });
        }
    </script>
    <script id="data">
        var table;
        var userID;
        var selectedrow;
        var html = '';
        // DataTable

        $(document).ready(function () {
            $('#load1').show();
            html = '';
            $.ajax({
                url: "Requisition.aspx/GetAllRequisitions",
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    var dataArray = JSON.parse(data.d);//
                    $.each(dataArray, function (index, value) {
                        var date = eval(value.AddedDate.replace(/\/Date\((\d+)\)\//gi, "new Date($1).toLocaleDateString(\"en-US\")"));
                        html += '<tr>';
                        html += '<td style="display: none;">' + value.RecId + '</td>';
                        html += '<td class=""><div class="btn-group">';
                        html += '<div class="btn-group">';
                        html += '<div type="button" data-toggle="dropdown" aria-expanded="false"><i style="color: dodgerblue; font-size:14px;" class="uil fs-0 me-2 uil-cog"></i>';
                        html += '<span class="sr-only"></span></div><div class="dropdown-menu" role="menu" style="">';
                        html += '<a class="dropdown-item" href="#!" id="Actions" onclick="Approve(' + value.RecId + ',' + index + ',1);"><span style="color: forestgreen;"><i class="uil fs-0 me-2 uil-pen" style="font-size:14px;"></i></span>&nbsp;&nbsp;Approve</a>';
                        html += '<a class="dropdown-item" href="#!" id="ActionsEx" onclick="Close(' + value.RecId + ',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-x" style="font-size:14px;"></i></span>&nbsp;&nbsp;Close</a><div class="dropdown-divider"></div></div></td>';
                        html += '<td>' + value.DesignationName + '</td>';
                        html += '<td>' + value.Noofpositions + '</td>';
                        html += '<td>' + value.Location + '</td>';
                        html += '<td>' + value.ApprovalStatus + '</td>';
                        html += '<td>' + value.Status + '</td>';
                        html += '<td>' + value.Deadline + '</td>';
                        html += '<td>' + value.IntiatedByName + '</td>';
                        html += '<td>' + date + '</td>';
                        html += '</tr>';
                    });

                    $('#manpower tbody').html(html);
                    if ($.fn.dataTable.isDataTable('#manpower')) {
                        table.destroy();
                    }
                    //else
                    {
                        table = $('#manpower').DataTable({
                            dom: 'lBftip',
                            scrollX: true,
                            destroy: true,
                            "paging": true,
                            "autoWidth": true,
                            select: true, processing: true,
                            "ordering": false,

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

                            buttons: [

                                {
                                    extend: 'excelHtml5', title: 'Manpower Requisition', autoFilter: true,
                                    className: 'btn btn-datatable',
                                    exportOptions: {
                                        columns: [2, 3, 4, 5, 6, 7, 8]
                                    },
                                    customize: function (xlsx) {
                                        var sheet = xlsx.xl.worksheets['sheet1.xml'];
                                        var freezePanes =
                                            '<sheetViews><sheetView tabSelected="1" workbookViewId="0"><pane xSplit="1" ySplit="1" topLeftCell="B2"  activePane="bottomRight" state="frozen"/></sheetView></sheetViews>';
                                        var current = sheet.children[0].innerHTML;
                                        current = freezePanes + current;
                                        sheet.children[0].innerHTML = current;
                                    },
                                },

                                {
                                    extend: 'pdfHtml5', orientation: 'landscape', title: 'Manpower Requisition',
                                    className: 'btn btn-datatable',
                                    exportOptions: {
                                        columns: [2, 3, 4, 5, 6, 7, 8]
                                    }
                                },

                            ],

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
        });

        function Approve(RecId, index) {
            row = table.row(index).data();
            if (row[5] == "Approved") {
                alert("Requisition is already approved.");
                return;
            }
            $.ajax({
                url: "Requisition.aspx/GetAllRequisitionsByRecId",
                data: "{RecId:" + RecId + "}",
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    var dataArray = JSON.parse(data.d);
                    $.each(dataArray, function (index1, value) {
                        document.getElementById("lblRecId").innerHTML = value.RecId;
                        document.getElementById("profilepop").innerHTML = value.DesignationName;
                        document.getElementById("NoOfPositionspop").innerHTML = value.Noofpositions;
                        document.getElementById("domainpop").innerHTML = value.DomainName;
                        if (value.Subdomain != null)
                            document.getElementById("subdomainpop").innerHTML = value.Subdomain;
                        else
                            document.getElementById("subdomainpop").innerHTML = 'N/A';
                        document.getElementById("projectspop").innerHTML = value.ProjectName;
                        if (value.ProcessName != null)
                            document.getElementById("processpop").innerHTML = value.ProcessName;
                        else
                            document.getElementById("processpop").innerHTML = 'N/A';
                        document.getElementById("shiftpop").innerHTML = value.ShiftName;
                        document.getElementById("locationpop").innerHTML = value.Location;
                        $('#approve').modal('show');
                    });

                },
                error: function (error) {
                    alert('error; ' + eval(error));
                    alert('error; ' + error.responseText);
                }
            });

        }

        function Close(RecId, index) {
            row = table.row(index).data();
            document.getElementById("lblRecIdclose").innerHTML = RecId;
            var req = row[2] + ' : ' + row[8] + ' : ' + row[9] + ' : ' + row[4];
            document.getElementById("profilepopclose").innerHTML = req;
            $('#close').modal('show');
        }
    </script>
    <script type="text/javascript">
        function submitdata() {
            var ddldsignation = document.getElementById("reqprofile");
            var designation = ddldsignation.options[ddldsignation.selectedIndex].value;

            var noofpositions = document.getElementById("NoOfPositions").value;

            var ddldomain = document.getElementById("domain");
            var domain = ddldomain.options[ddldomain.selectedIndex].value;

            var ddlsubdomain = document.getElementById("subdomain");
            var subdomain = ddlsubdomain.options[ddlsubdomain.selectedIndex].text;

            var ddlproject = document.getElementById("projects");
            var projects = ddlproject.options[ddlproject.selectedIndex].value;

            var ddlprocess = document.getElementById("process");
            var process = ddlprocess.options[ddlprocess.selectedIndex].value;

            var ddlshift = document.getElementById("shift");
            var shift = ddlshift.options[ddlshift.selectedIndex].value;

            var ddllocation = document.getElementById("location");
            var location = ddllocation.options[ddllocation.selectedIndex].text;

            var ddlemploymenttype = document.getElementById("employmenttype");
            var employmenttype = ddlemploymenttype.options[ddlemploymenttype.selectedIndex].text;

            var ddldepartment = document.getElementById("department");
            var department = ddldepartment.options[ddldepartment.selectedIndex].value;

            var ddlsource = document.getElementById("source");
            var source = ddlsource.options[ddlsource.selectedIndex].text;

            var deadline = document.getElementById("deadline").value;
            var remark = document.getElementById("remark").value;

            PageMethods.InsertRequisition(designation, noofpositions, domain, "", projects, process, shift, location, employmenttype, department, remark, deadline, source, OnSucceed, OnError);
            return false;
        }

        function OnSucceed(result) {
            $('#approve').modal('hide');
            alert('Requisition added successfully!');
            location.reload();

        }
        function OnError(error) {
            alert(error);
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Manpower Requisition</b></h6>
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
                        <td><b>Profile:</b></td>
                        <td>
                            <select id="reqprofile" name="reqprofile" class="form-control" style="width: 300px;" required>
                                <option value="">Select</option>
                            </select>
                        </td>
                        <td><b>No. of positions:</b></td>
                        <td>
                            <input type="text" id="NoOfPositions" name="NoOfPositions" class="form-control" style="width: 300px;" required />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Domain:</b></td>
                        <td>
                            <select id="domain" name="domain" class="form-control" style="width: 300px;" required>
                                <%--onchange="ondomainclick();"--%>
                                <option value="">Select</option>
                            </select>
                        </td>
                        <td style="display: none;"><b>Subdomain:</b></td>
                        <td style="display: none;">
                            <select id="subdomain" name="subdomain" class="form-control" style="width: 300px;" required>
                                <option value="">Select</option>
                            </select></td>
                    </tr>
                    <tr id="trProject">
                        <td><b>Project #:</b></td>
                        <td>
                            <select id="projects" name="projects" class="form-control" style="width: 300px;" onchange="onprojectclick();" required>
                                <option value="">Select</option>
                            </select>
                        </td>
                        <td><b>Process:</b></td>
                        <td>
                            <select id="process" name="projects" class="form-control" style="width: 300px;" required>
                                <option value="">Select</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Shift:</b></td>
                        <td>
                            <select id="shift" name="shift" class="form-control" style="width: 300px;" required>
                                <option value="">Select</option>
                            </select>
                        </td>
                        <td><b>Location:</b></td>
                        <td>
                            <select id="location" name="location" class="form-control" style="width: 300px;" required>
                                <option value="">Select</option>
                                <option value="Akola">Akola</option>
                                <option value="Bangalore">Bangalore</option>
                                <option value="Kothrud">Kothrud</option>
                                <option value="KP">KP</option>
                                <option value="Solapur">Solapur</option>
                                <option value="Swargate">Swargate</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Employment Type:</b></td>
                        <td>
                            <select id="employmenttype" name="employmenttype" class="form-control" style="width: 300px;" required>
                                <option value="">Select</option>
                                <option value="Employee">Employee</option>
                                <option value="Consultant">Consultant</option>
                                <option value="Vendor(Part Time)">Vendor (Part Time)</option>
                                <option value="Vendor(Full Time)">Vendor (Full Time)</option>
                            </select>
                        </td>
                        <td><b>Department:</b></td>
                        <td>
                            <select id="department" name="department" class="form-control" style="width: 300px;" required>
                                <option value="">Select</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Source:</b></td>
                        <td>
                            <select id="source" name="source" class="form-control" style="width: 300px;" required>
                                <option value="">Select</option>
                                <option value="Advertisement">Advertisement</option>
                                <option value="Database">Database</option>
                                <option value="Online Portal">Online Portal</option>
                                <option value="Other">Other</option>
                            </select>
                        </td>
                        <td><b>Deadline:</b></td>
                        <td>
                            <input type="date" id="deadline" name="deadline" class="form-control" max="2999-12-31" style="width: 300px;" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Remark:</b></td>
                        <td>
                            <textarea id="remark" name="remark" class="form-control" style="width: 300px;"></textarea>
                        </td>
                        <td>
                            <button class="btn btn-primary" onclick="submitdata();">Add Requisition</button>
                        </td>
                        <td></td>
                    </tr>

                </table>
                <hr />
                <table class="table" id="manpower" style="width: 100%;">
                    <thead>
                        <tr>
                            <th style="display: none;"></th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Actions</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Profile</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">No. of positions</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Location</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Approval Status</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Requisition Status</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Deadline</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Added By</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Added Date</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
    

    <div class="modal fade" id="approve">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Approve Requisition</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table table-responsive" style="width: 100%;">
                        <tr>
                            <td><b>Profile:</b></td>
                            <td>
                                <label id="profilepop" name="profilepop" class="form-control" style="width: 300px;"></label>

                                <label id="lblRecId" style="display: none;"></label>
                            </td>
                            <td><b># of positions:</b></td>
                            <td>
                                <label id="NoOfPositionspop" name="NoOfPositionspop" class="form-control" style="width: 300px;"></label>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Domain:</b></td>
                            <td>
                                <label id="domainpop" name="domainpop" class="form-control" style="width: 300px;"></label>

                            </td>
                            <td><b>Subdomain:</b></td>
                            <td>
                                <label id="subdomainpop" name="subdomainpop" class="form-control" style="width: 300px;"></label>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Project #:</b></td>
                            <td>
                                <label id="projectspop" name="projectspop" class="form-control" style="width: 300px;"></label>
                            </td>
                            <td><b>Process:</b></td>
                            <td>
                                <label id="processpop" name="processpop" class="form-control" style="width: 300px;"></label>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Shift:</b></td>
                            <td>
                                <label id="shiftpop" name="shiftpop" class="form-control" style="width: 300px;"></label>
                            </td>
                            <td><b>Location:</b></td>
                            <td>
                                <label id="locationpop" name="locationpop" class="form-control" style="width: 300px;"></label>
                            </td>

                        </tr>
                        <tr>
                            <td><b>Salary Range:</b></td>
                            <td>
                                <input id="costapproved" name="costapproved" class="form-control" style="width: 300px;" required />
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button class="btn btn-primary" type="button" id="btnapprove" onclick="ApproveRequisition();">Approve</button>
                </div>
                <script type="text/javascript">
                    function ApproveRequisition() {
                        var RecId = document.getElementById("lblRecId").innerHTML;
                        var costapproved = document.getElementById("costapproved").value;
                        if (costapproved == "") {
                            alert("Please enter salary range.");
                            document.getElementById("costapproved").focus();
                            return;
                        }
                        PageMethods.ApproveRequisitions(RecId, costapproved, OnSucceedApprove, OnErrorApprove);

                    }
                    function OnSucceedApprove(result) {
                        $('#approve').modal('hide');
                        alert('Requisition approved successfully!');
                        location.reload();

                    }
                    function OnErrorApprove(error) {
                        alert(error);
                    }
                </script>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

    <div class="modal fade" id="close">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Close Requisition</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table table-responsive" style="width: 100%;">
                        <tr>
                            <td><b>Requisition:</b></td>
                            <td>
                                <label id="profilepopclose" name="profilepopclose" class="form-control"></label>

                                <label id="lblRecIdclose" style="display: none;"></label>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Closure Remark:</b></td>
                            <td>
                                <textarea id="closureremark" name="closureremark" class="form-control" style="width: 300px;" required ></textarea>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button class="btn btn-primary" type="button" id="btnclose" onclick="CloseRequisition();">Close Requisition</button>
                </div>
                <script type="text/javascript">
                    function CloseRequisition() {
                        var RecId = document.getElementById("lblRecIdclose").innerHTML;
                        var closureremark = document.getElementById("closureremark").value;
                        if (closureremark == "") {
                            alert("Please enter closure remark.");
                            document.getElementById("closureremark").focus();
                            return;
                        }
                        PageMethods.CloseRequisitions(RecId, closureremark, OnSucceedClose, OnErrorClose);
                    }
                    function OnSucceedClose(result) {
                        $('#close').modal('hide');
                        alert('Requisition closed successfully!');
                        location.reload();

                    }
                    function OnErrorClose(error) {
                        alert(error);
                    }
                </script>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>






</asp:Content>
