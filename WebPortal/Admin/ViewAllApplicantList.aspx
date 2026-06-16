<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ViewAllApplicantList.aspx.cs" Inherits="WebPortal.Admin.ViewAllApplicantList" %>

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

        div.dt-buttons {
            position: static;
            padding-left: 50px;
            float: left;
        }

        .table.dataTable th {
            background: linear-gradient(to bottom, #007bff, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none;
        }
        /*.form-control {
            font-size: 11px !important;
        }*/
    </style>
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
                url: "ViewAllApplicantList.aspx/GetApplicantListByEmployeeId",
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    var dataArray = JSON.parse(data.d);

                    $('#applicant tbody').html(html);
                    if ($.fn.dataTable.isDataTable('#applicant')) {
                        table.destroy();
                    }
                    //else
                    table = $('#applicant').DataTable({
                        dom: 'lftip',
                        scrollX: true,
                        destroy: true,
                        "paging": true,
                        "autoWidth": true,
                        select: true,
                        processing: true,
                        'select': {
                            'style': 'single'
                        }, "data": dataArray,
                        columns: [
                            { data: '' },
                            { data: 'AppId' },
                            { data: 'Location' },
                            { data: 'PositionAppliedName' },
                            { data: 'ApplicationDate' },
                            { data: 'Status' },
                            { data: 'Name' },
                            { data: 'CellPhoneNo' },
                            { data: 'EmailID' },
                            { data: 'Domain' },
                            { data: 'Subdomain' }
                        ],

                        columnDefs: [
                            {
                                targets: 0,
                                "width": "45px",
                                render: function (data, type, row, meta) {

                                    return '<div class="btn-group">' +
                                        '<div class="btn-group">' +
                                        '<div type="button" data-toggle="dropdown" aria-expanded="false"><i style="color: dodgerblue; font-size:14px;" class="uil fs-0 me-2 uil-cog"></i>' +
                                        '<span class="sr-only"></span></div > <div class="dropdown-menu" role="menu">' +
                                        '<a class="dropdown-item" href="#!" id="Actions" onclick="AddRemarkAllApp(\'' + meta.row + '\');"><span style="color: forestgreen;"><i class="uil fs-0 me-2 uil-pen"></i></span>&nbsp;&nbsp;Add/View Remark</a>' +
                                        '<a class="dropdown-item" href="#!" id="ActionsEx" onclick="ViewApplicationAllApp(\'' + meta.row + '\');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-file"></i></span>&nbsp;&nbsp;View Application</a><div class="dropdown-divider"></div></div></div>';

                                }
                            }
                        ],



                        initComplete: function () {
                            $('#load1').hide();
                        },
                        "rowCallback": function (row, data) {
                            // Cell at index 5 in the row is 'Active'.
                            var val = data[3];
                        },

                        buttons: [
                            {
                                extend: 'copy', title: 'All Candidates',
                                exportOptions: {
                                    columns: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                                }
                            },
                            {
                                extend: 'excelHtml5', title: 'All Candidates', autoFilter: true,
                                exportOptions: {
                                    columns: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                                }

                            },
                            {
                                extend: 'csv', title: 'All Candidates',
                                exportOptions: {
                                    columns: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                                }
                            },

                            {
                                extend: 'pdfHtml5', orientation: 'landscape', title: 'All Candidates',
                                exportOptions: {
                                    columns: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                                }
                            },
                            {
                                extend: 'print', title: 'All Candidates',
                                exportOptions: {
                                    columns: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                                }
                            },

                        ],

                    });

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

        function AddRemarkAllApp(index) {

            row = table.row(index).data();

            location.href = encodeURI('AddApplicantRemark.aspx?AppId=' + row.AppId);
        }

        function ViewApplicationAllApp(index) {
            row = table.row(index).data();
            location.href = encodeURI('ApplicationForm.aspx?AppId=' + row.AppId);
        }

        function getResult(Type, Content) {
            alert(Content.value);

        }

        function binddomains() {

            $.ajax({
                type: "POST", url: "ViewAllApplicantList.aspx/GetAllRequisitions", dataType: "json", contentType: "application/json",
                success: function (res) {
                    $.each(res.d, function (data, value) {
                        $("#requisition").append($("<option></option>").val(value.RecId).html(value.RequisitionProfile));
                    })
                    $("#requisition").append($("<option></option>").val("Other").html("Other"));
                }

            });


            $.ajax({
                type: "POST", url: "ViewAllApplicantList.aspx/GetAllDomains", dataType: "json", contentType: "application/json",
                success: function (res) {
                    $.each(res.d, function (data, value) {
                        $("#domain").append($("<option></option>").val(value.DomainID).html(value.DomainName));
                    })
                }

            });

            $.ajax({
                type: "POST", url: "ViewAllApplicantList.aspx/GetBranches", dataType: "json", contentType: "application/json",
                success: function (res) {
                    $.each(res.d, function (data, value) {
                        $("#location").append($("<option></option>").val(value.BranchName).html(value.BranchName));
                    })
                }

            });

            $.ajax({
                type: "POST", url: "ViewAllApplicantList.aspx/GetProjectManagers", dataType: "json", contentType: "application/json",
                success: function (res) {
                    $.each(res.d, function (data, value) {
                        $("#interviewer").append($("<option></option>").val(value.ProjectManagerID).html(value.PmCodeName));
                    })
                }

            });

            $.ajax({
                type: "POST", url: "ViewAllApplicantList.aspx/GetDepartment", dataType: "json", contentType: "application/json",
                success: function (res) {
                    $.each(res.d, function (data, value) {
                        $("#department").append($("<option></option>").val(value.DepartmentID).html(value.DepartmentName));
                    })
                }

            });

            $.ajax({
                type: "POST", url: "ViewAllApplicantList.aspx/GetShift", dataType: "json", contentType: "application/json",
                success: function (res) {
                    $.each(res.d, function (data, value) {
                        $("#shift").append($("<option></option>").val(value.ShiftID).html(value.ShiftTime));
                    })
                }

            });

        }

        function getFields(ddlstatus) {
            var text = ddlstatus.options[ddlstatus.selectedIndex].text;
            if (text == "Proceed For Next Round") {
                tdmethod1.style.display = '';
                tdmethod2.style.display = '';
                tdlocation1.style.display = '';
                tdlocation2.style.display = '';
                trnextround.style.display = '';
            }
            else {
                tdmethod1.style.display = 'none';
                tdmethod2.style.display = 'none';
                tdlocation1.style.display = 'none';
                tdlocation2.style.display = 'none';
                trnextround.style.display = 'none';
            }
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>View All Applicants</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <h5 class="card-title"></h5>
                <table class="table" id="applicant" style="padding-top: 10px; width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Actions</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Application ID</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Location</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Position Applied</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Application Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Interview Status</th>
                            <th class="sort border-top ps-3">Name</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Contact #</th>
                            <th class="sort border-top ps-3">Email</th>
                            <th class="sort border-top ps-3">Domain</th>
                            <th class="sort border-top ps-3">Subdomain</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
