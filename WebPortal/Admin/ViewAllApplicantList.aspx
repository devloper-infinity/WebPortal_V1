<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ViewAllApplicantList.aspx.cs" Inherits="WebPortal.Admin.ViewAllApplicantList" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        :root {
            --app-primary: #1d4ed8;
            --app-secondary: #2563eb;
            --app-accent: #22c1dc;
            --app-dark: #0f172a;
            --app-muted: #64748b;
            --app-border: #e2e8f0;
            --app-soft: #f8fafc;
        }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, .72);
            backdrop-filter: blur(3px);
            z-index: 99999;
            text-align: center;
        }

        .loading img {
            position: absolute;
            top: 43%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 72px;
            height: 72px;
        }

        .loading div {
            position: absolute;
            top: calc(43% + 52px);
            left: 50%;
            transform: translateX(-50%);
            font-size: 13px;
            font-weight: 700;
            color: var(--app-primary);
            background: #fff;
            border: 1px solid var(--app-border);
            border-radius: 999px;
            padding: 8px 18px;
            box-shadow: 0 12px 35px rgba(15, 23, 42, .14);
        }

        .applicant-page {
            background: #f3f6fb;
            min-height: calc(100vh - 80px);
        }

        .applicant-hero {
            position: relative;
            overflow: hidden;
            border-radius: 20px;
            padding: 22px 26px;
            margin-bottom: 18px;
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 62%, #22c1dc 100%);
            box-shadow: 0 18px 42px rgba(37, 99, 235, .24);
        }

        .applicant-hero:before,
        .applicant-hero:after {
            content: "";
            position: absolute;
            border-radius: 50%;
            background: rgba(255, 255, 255, .14);
        }

        .applicant-hero:before {
            width: 160px;
            height: 160px;
            right: -46px;
            top: -60px;
        }

        .applicant-hero:after {
            width: 110px;
            height: 110px;
            right: 115px;
            bottom: -55px;
        }

        .applicant-hero-inner {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            flex-wrap: wrap;
        }

        .applicant-title-wrap {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .applicant-hero-icon {
            width: 58px;
            height: 58px;
            border-radius: 18px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: rgba(255, 255, 255, .18);
            border: 1px solid rgba(255, 255, 255, .22);
            box-shadow: inset 0 1px 0 rgba(255, 255, 255, .16);
            font-size: 25px;
        }

        .applicant-hero h3 {
            margin: 0;
            font-size: 22px;
            font-weight: 800;
            letter-spacing: .2px;
        }

        .applicant-hero p {
            margin: 4px 0 0;
            font-size: 13px;
            color: rgba(255, 255, 255, .86);
        }

        .applicant-chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 14px;
            border-radius: 999px;
            background: rgba(255, 255, 255, .16);
            border: 1px solid rgba(255, 255, 255, .22);
            color: #fff;
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
        }

        .applicant-shell {
            background: #fff;
            border: 1px solid var(--app-border);
            border-radius: 18px;
            box-shadow: 0 14px 36px rgba(15, 23, 42, .08);
            overflow: hidden;
        }

        .applicant-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            flex-wrap: wrap;
            padding: 18px 20px;
            border-bottom: 1px solid var(--app-border);
            background: linear-gradient(180deg, #fff 0%, #f8fafc 100%);
        }

        .applicant-card-title {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .applicant-card-title i {
            width: 38px;
            height: 38px;
            border-radius: 12px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: var(--app-primary);
            background: #eaf2ff;
            font-size: 16px;
        }

        .applicant-card-title h5 {
            margin: 0;
            font-size: 15px;
            font-weight: 800;
            color: var(--app-dark);
        }

        .applicant-card-title span {
            display: block;
            margin-top: 2px;
            font-size: 12px;
            color: var(--app-muted);
        }

        .applicant-grid-wrap {
            padding: 16px 18px 20px;
        }

        #applicant {
            width: 100% !important;
            margin: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0;
            font-size: 12px;
            color: #111827;
        }

        #applicant thead th {
            background: #edf3f6 !important;
            color: #0f172a !important;
            font-size: 11px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: .25px;
            height: 42px;
            vertical-align: middle;
            border-top: 1px solid #d9e2ec !important;
            border-bottom: 1px solid #d9e2ec !important;
            white-space: nowrap;
        }

        #applicant tbody td {
            vertical-align: middle;
            border-color: #eef2f7;
            white-space: nowrap;
            padding: 10px 8px;
        }

        #applicant tbody tr {
            transition: all .18s ease;
        }

        #applicant tbody tr:hover {
            background: #f8fbff;
            box-shadow: inset 3px 0 0 #2563eb;
        }

        .applicant-action-btn {
            width: 32px;
            height: 32px;
            border-radius: 10px;
            border: 1px solid #dbe7ff;
            background: #eff6ff;
            color: #2563eb;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all .2s ease;
        }

        .applicant-action-btn:hover {
            background: linear-gradient(120deg, #1d4ed8, #22c1dc);
            color: #fff;
            transform: translateY(-1px);
            box-shadow: 0 8px 18px rgba(37, 99, 235, .22);
        }

        .dropdown-menu {
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            box-shadow: 0 14px 30px rgba(15, 23, 42, .14);
            padding: 8px;
            font-size: 12px;
        }

        .dropdown-item {
            border-radius: 9px;
            padding: 9px 12px;
            font-weight: 600;
        }

        .dropdown-item:hover {
            background: #eff6ff;
            color: #1d4ed8;
        }

        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dataTables_filter,
        .dataTables_wrapper .dt-buttons {
            margin-bottom: 12px;
        }

        .dataTables_wrapper .dataTables_length {
            float: left !important;
        }

        .dataTables_wrapper .dataTables_filter {
            float: right !important;
        }

        div.dt-buttons {
            float: left;
            margin-left: 16px;
        }

        .dt-button,
        .dataTables_wrapper .dataTables_paginate .paginate_button {
            border-radius: 10px !important;
            border: 1px solid #dbe3ef !important;
            background: #fff !important;
            color: #334155 !important;
            font-size: 12px !important;
            font-weight: 700 !important;
            padding: 6px 12px !important;
        }

        .dt-button:hover,
        .dataTables_wrapper .dataTables_paginate .paginate_button:hover {
            background: #eff6ff !important;
            color: #1d4ed8 !important;
            border-color: #bfdbfe !important;
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button.current {
            background: linear-gradient(120deg, #1d4ed8, #22c1dc) !important;
            color: #fff !important;
            border-color: transparent !important;
        }

        .dataTables_wrapper select,
        .dataTables_wrapper input {
            border: 1px solid #dbe3ef;
            border-radius: 10px;
            padding: 6px 10px;
            outline: none;
            font-size: 12px;
        }

        @media (max-width: 767px) {
            .applicant-page {
                padding: 10px;
            }

            .applicant-hero {
                padding: 18px;
                border-radius: 16px;
            }

            .applicant-hero-icon {
                width: 48px;
                height: 48px;
                border-radius: 14px;
            }

            .applicant-hero h3 {
                font-size: 18px;
            }

            .dataTables_wrapper .dataTables_filter,
            .dataTables_wrapper .dataTables_length,
            div.dt-buttons {
                float: none !important;
                margin-left: 0;
                text-align: left;
            }
        }
    </style>

    <script id="data">
        var table;
        var userID;
        var selectedrow;
        var html = '';

        $(document).ready(function () {
            $('#load1').show();
            html = '';

            $.ajax({
                url: "ViewAllApplicantList.aspx/GetApplicantListByEmployeeId",
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    var dataArray = JSON.parse(data.d || "[]");

                    $('#applicant tbody').html(html);

                    if ($.fn.dataTable.isDataTable('#applicant')) {
                        table.clear().destroy();
                    }

                    table = $('#applicant').DataTable({
                        dom: 'lBftip',
                        scrollX: true,
                        destroy: true,
                        paging: true,
                        pageLength: 35,
                        lengthMenu: [[10, 25, 35, 50, 100, -1], [10, 25, 35, 50, 100, "All"]],
                        autoWidth: false,
                        ordering: false,
                        select: {
                            style: 'single'
                        },
                        processing: true,
                        data: dataArray,
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
                                width: "55px",
                                orderable: false,
                                searchable: false,
                                render: function (data, type, row, meta) {
                                    return '<div class="btn-group">' +
                                        '<button type="button" class="applicant-action-btn" data-toggle="dropdown" aria-expanded="false" title="Actions">' +
                                        '<i class="fas fa-cog"></i>' +
                                        '</button>' +
                                        '<div class="dropdown-menu" role="menu">' +
                                        '<a class="dropdown-item" href="#!" onclick="AddRemarkAllApp(\'' + meta.row + '\');">' +
                                        '<span style="color:#16a34a;"><i class="fas fa-pen"></i></span>&nbsp;&nbsp;Add/View Remark</a>' +
                                        '<a class="dropdown-item" href="#!" onclick="ViewApplicationAllApp(\'' + meta.row + '\');">' +
                                        '<span style="color:#2563eb;"><i class="fas fa-file-alt"></i></span>&nbsp;&nbsp;View Application</a>' +
                                        '</div>' +
                                        '</div>';
                                }
                            }
                        ],
                        initComplete: function () {
                            $('#load1').hide();
                            setTimeout(function () {
                                if (table) {
                                    table.columns.adjust();
                                }
                            }, 200);
                        },
                        buttons: [
                            {
                                extend: 'copy',
                                title: 'All Candidates',
                                text: '<i class="fas fa-copy"></i> Copy',
                                exportOptions: { columns: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }
                            },
                            {
                                extend: 'excelHtml5',
                                title: 'All Candidates',
                                text: '<i class="fas fa-file-excel"></i> Excel',
                                autoFilter: true,
                                exportOptions: { columns: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }
                            },
                            {
                                extend: 'csv',
                                title: 'All Candidates',
                                text: '<i class="fas fa-file-csv"></i> CSV',
                                exportOptions: { columns: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }
                            },
                            {
                                extend: 'pdfHtml5',
                                orientation: 'landscape',
                                title: 'All Candidates',
                                text: '<i class="fas fa-file-pdf"></i> PDF',
                                exportOptions: { columns: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }
                            },
                            {
                                extend: 'print',
                                title: 'All Candidates',
                                text: '<i class="fas fa-print"></i> Print',
                                exportOptions: { columns: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }
                            }
                        ]
                    });
                },
                error: function (error) {
                    $('#load1').hide();

                    if (typeof Swal !== "undefined") {
                        Swal.fire({
                            icon: 'error',
                            title: 'Error',
                            text: 'Unable to load applicant list.',
                            zIndex: 999999
                        });
                    }
                    else {
                        alert('Unable to load applicant list.');
                    }

                    console.log(error.responseText || error);
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
        <div>One moment, please . . .</div>
    </div>

    <div class="applicant-page">

        <section class="applicant-hero">
            <div class="applicant-hero-inner">
                <div class="applicant-title-wrap">
                    <div class="applicant-hero-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <div>
                        <h3>View All Applicants</h3>
                        <p>Review applicant details, interview status, remarks and application information.</p>
                    </div>
                </div>

                <div class="applicant-chip">
                    <i class="fas fa-user-check"></i>
                    Recruitment Records
                </div>
            </div>
        </section>

        <section class="applicant-shell">
            <div class="applicant-card-header">
                <div class="applicant-card-title">
                    <i class="fas fa-list-check"></i>
                    <div>
                        <h5>Applicant List</h5>
                        <span>Use action menu to add remarks or view full application.</span>
                    </div>
                </div>
            </div>

            <div class="applicant-grid-wrap">
                <table class="table table-bordered table-hover" id="applicant">
                    <thead>
                        <tr>
                            <th>Actions</th>
                            <th>Application ID</th>
                            <th>Location</th>
                            <th>Position Applied</th>
                            <th>Application Date</th>
                            <th>Interview Status</th>
                            <th>Name</th>
                            <th>Contact #</th>
                            <th>Email</th>
                            <th>Domain</th>
                            <th>Subdomain</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </section>

    </div>

</asp:Content>

<%--<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
</asp:Content>--%>
