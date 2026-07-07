<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ViewSelectedCandidates.aspx.cs" Inherits="WebPortal.Admin.ViewSelectedCandidates" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --vsc-primary: #1d4ed8;
            --vsc-primary-2: #2563eb;
            --vsc-cyan: #22c1dc;
            --vsc-dark: #0f172a;
            --vsc-muted: #64748b;
            --vsc-border: #e2e8f0;
            --vsc-soft: #f8fafc;
            --vsc-success: #16a34a;
            --vsc-danger: #dc2626;
        }

        .loading {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 190px;
            min-height: 160px;
            padding: 22px 18px;
            z-index: 99999;
            border-radius: 22px;
            background: rgba(255,255,255,.96);
            box-shadow: 0 20px 60px rgba(15,23,42,.18);
            text-align: center;
            color: var(--vsc-dark);
        }

        .loading img {
            width: 58px;
            height: 58px;
            object-fit: contain;
            margin-bottom: 12px;
        }
        .vsc-hero {
            position: relative;
            overflow: hidden;
            border-radius: 24px;
            padding: 24px 28px;
            margin-bottom: 22px;
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 62%, #22c1dc 100%);
            box-shadow: 0 18px 40px rgba(37,99,235,.22);
        }

        .vsc-hero:before,
        .vsc-hero:after {
            content: "";
            position: absolute;
            border-radius: 999px;
            background: rgba(255,255,255,.16);
            pointer-events: none;
        }

        .vsc-hero:before {
            width: 180px;
            height: 180px;
            right: -55px;
            top: -70px;
        }

        .vsc-hero:after {
            width: 120px;
            height: 120px;
            right: 90px;
            bottom: -65px;
        }

        .vsc-hero-content {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            flex-wrap: wrap;
        }

        .vsc-title-wrap {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .vsc-hero-icon {
            width: 62px;
            height: 62px;
            min-width: 62px;
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.18);
            border: 1px solid rgba(255,255,255,.28);
            box-shadow: inset 0 1px 0 rgba(255,255,255,.22);
            font-size: 28px;
        }

        .vsc-hero h4 {
            margin: 0;
            font-size: 24px;
            line-height: 1.2;
            font-weight: 800;
            letter-spacing: .2px;
        }

        .vsc-hero p {
            margin: 6px 0 0;
            color: rgba(255,255,255,.86);
            font-size: 13px;
        }

        .vsc-chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 16px;
            border-radius: 999px;
            background: rgba(255,255,255,.16);
            border: 1px solid rgba(255,255,255,.25);
            font-weight: 700;
            font-size: 12px;
            white-space: nowrap;
        }

        .vsc-panel {
            border: 1px solid var(--vsc-border);
            border-radius: 22px;
            background: #fff;
            box-shadow: 0 14px 35px rgba(15,23,42,.08);
            overflow: hidden;
        }

        .vsc-panel-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            padding: 18px 22px;
            background: linear-gradient(180deg, #f8fbff 0%, #ffffff 100%);
            border-bottom: 1px solid var(--vsc-border);
            flex-wrap: wrap;
        }

        .vsc-panel-title {
            display: flex;
            align-items: center;
            gap: 12px;
            color: var(--vsc-dark);
        }

        .vsc-panel-title i {
            width: 40px;
            height: 40px;
            border-radius: 14px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: #eff6ff;
            color: var(--vsc-primary-2);
            font-size: 18px;
        }

        .vsc-panel-title h5 {
            margin: 0;
            font-size: 16px;
            font-weight: 800;
        }

        .vsc-panel-title span {
            display: block;
            margin-top: 2px;
            color: var(--vsc-muted);
            font-size: 12px;
        }

        .vsc-table-wrap {
            padding: 18px;
        }

        #applicant {
            width: 100% !important;
            border-collapse: separate !important;
            border-spacing: 0;
            margin: 0 !important;
        }

        #applicant thead th {
            background: #edf3f6 !important;
            color: #0f172a !important;
            font-size: 12px;
            font-weight: 800;
            height: 42px;
            vertical-align: middle;
            border-bottom: 1px solid #dbe5ea !important;
            white-space: nowrap;
            text-align: center;
        }

        #applicant tbody td {
            font-size: 12px;
            vertical-align: middle;
            color: #334155;
            border-top: 1px solid #eef2f7;
            white-space: nowrap;
        }

        #applicant tbody tr:hover td {
            background: #f8fbff !important;
        }

        #applicant tbody tr.selected td {
            background: #eff6ff !important;
        }

        .vsc-action-trigger {
            width: 34px;
            height: 34px;
            border: 0;
            border-radius: 12px;
            background: #eff6ff;
            color: var(--vsc-primary-2);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: .25s ease;
            cursor: pointer;
        }

        .vsc-action-trigger:hover {
            color: #fff;
            background: linear-gradient(135deg, var(--vsc-primary-2), var(--vsc-cyan));
            box-shadow: 0 10px 20px rgba(37,99,235,.22);
            transform: translateY(-1px);
        }

        .dropdown-menu {
            border: 1px solid var(--vsc-border);
            border-radius: 14px;
            box-shadow: 0 18px 40px rgba(15,23,42,.14);
            padding: 8px;
            font-size: 12px;
        }

        .dropdown-item {
            border-radius: 10px;
            padding: 9px 12px;
            font-weight: 600;
            color: #334155;
        }

        .dropdown-item:hover {
            background: #eff6ff;
            color: var(--vsc-primary-2);
        }

        .isDisabled {
            pointer-events: none;
            opacity: .45;
            cursor: not-allowed;
        }

        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dataTables_filter,
        .dataTables_wrapper .dataTables_info,
        .dataTables_wrapper .dataTables_paginate {
            font-size: 12px;
            color: var(--vsc-muted);
        }

        .dataTables_wrapper .dataTables_length {
            float: left !important;
            margin-bottom: 12px;
        }

        .dataTables_wrapper .dataTables_filter {
            float: right !important;
            margin-bottom: 12px;
        }

        .dataTables_wrapper .dataTables_filter input,
        .dataTables_wrapper .dataTables_length select {
            border: 1px solid var(--vsc-border);
            border-radius: 10px;
            padding: 6px 10px;
            outline: none;
        }

        .dataTables_wrapper .dataTables_filter input:focus {
            border-color: var(--vsc-primary-2);
            box-shadow: 0 0 0 3px rgba(37,99,235,.12);
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button {
            border-radius: 10px !important;
            border: 1px solid transparent !important;
            padding: 5px 10px !important;
            margin: 0 2px;
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button.current,
        .dataTables_wrapper .dataTables_paginate .paginate_button.current:hover {
            background: linear-gradient(135deg, var(--vsc-primary-2), var(--vsc-cyan)) !important;
            color: #fff !important;
            border: none !important;
        }

        .buttons-excel,
        .buttons-html5 {
            color: #fff !important;
            box-shadow: none;
            background: linear-gradient(135deg, #2563eb, #22c1dc) !important;
            border: 0 !important;
            font-weight: 700;
            border-radius: 10px !important;
            margin: 0 6px;
            padding: 7px 14px !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 14px;
            float: left;
        }

        .vselect-modal .modal-content {
            border: 0;
            border-radius: 18px;
            overflow: hidden;
            box-shadow: 0 24px 70px rgba(15,23,42,.22);
        }

        .vselect-modal .modal-header {
            background: linear-gradient(135deg, #1d4ed8, #22c1dc);
            color: #fff;
            border: 0;
            padding: 18px;
        }

        .vselect-modal .modal-title {
            font-size: 14px;
            line-height: 1.6;
            font-weight: 700;
        }

        .vselect-modal .modal-footer {
            border: 0;
            justify-content: center;
            padding: 16px;
        }

        .btn-vselect-primary {
            border: 0;
            border-radius: 10px;
            padding: 9px 24px;
            color: #fff;
            font-weight: 700;
            background: linear-gradient(135deg, #2563eb, #22c1dc);
            box-shadow: 0 10px 18px rgba(37,99,235,.18);
        }

        @media (max-width: 767px) {
            .vsc-page { padding: 10px; }
            .vsc-hero { padding: 20px; border-radius: 18px; }
            .vsc-hero h4 { font-size: 19px; }
            .vsc-hero-icon { width: 52px; height: 52px; min-width: 52px; }
            .vsc-chip { width: 100%; justify-content: center; }
            .vsc-panel-head { padding: 16px; }
            .vsc-table-wrap { padding: 12px; }
            .dataTables_wrapper .dataTables_filter,
            .dataTables_wrapper .dataTables_length { float: none !important; text-align: left !important; }
        }
    </style>
    <script id="data">
        var table;
        var userID;
        var selectedrow;
        var html = '';
        // DataTable
        function blankForNull(s) {
            return s == "null" || s == null ? "" : s;
        }
        $(document).ready(function () {
            $('#load1').show();
            html = '';
            $.ajax({
                url: "ViewSelectedCandidates.aspx/GetSelectedCandidates",
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    var dataArray = JSON.parse(data.d);//
                    $.each(dataArray, function (index, value) {

                        var date = eval(value.ApplicationDate.replace(/\/Date\((\d+)\)\//gi, "new Date($1).toLocaleDateString(\"en-US\")"));
                        html += '<tr>';

                        html += '<td class="text-center"><div class="btn-group">';
                        html += '<button type="button" class="vsc-action-trigger" data-toggle="dropdown" aria-expanded="false"><i class="fas fa-cog"></i></button>';
                        html += '<span class="sr-only"></span><div class="dropdown-menu" role="menu">';
                        html += '<a class="dropdown-item" href="#!" id="Actions" onclick="AddSalaryJustification(' + value.AppID + ',' + index + ');"><span style="color: forestgreen;"><i class="fas fa-pen"></i></span>&nbsp;&nbsp;Add Salary Justification</a>';
                        html += '<a class="dropdown-item" href="#!" id="ActionsEx" onclick="ViewApplication(' + value.AppID + ',' + index + ');"><span style="color: dodgerblue;"><i class="fas fa-file-alt"></i></span>&nbsp;&nbsp;View Application</a>';

                        if (blankForNull(value.IsCreated) == '1')
                            html += '<a class="dropdown-item isDisabled" href="#!" id="ActionsExCreate"><span style="color: dodgerblue;"><i class="fas fa-user-plus"></i></span>&nbsp;&nbsp;Create Profile</a><div class="dropdown-divider"></div></div></div></td>';
                        else
                            html += '<a class="dropdown-item" href="#!" id="ActionsExCreate" onclick="CreateProfile(' + value.AppID + ',' + index + ');"><span style="color: dodgerblue;"><i class="fas fa-user-plus"></i></span>&nbsp;&nbsp;Create Profile</a><div class="dropdown-divider"></div></div></div></td>';

                        html += '<td>' + value.AppID + '</td>';
                        html += '<td>' + value.Location + '</td>';
                        html += '<td>' + value.PositionAppliedName + '</td>';
                        html += '<td>' + date + '</td>';
                        html += '<td>' + value.Fullname + '</td>';
                        html += '<td>' + value.CellPhoneNo + '</td>';
                        html += '<td>' + blankForNull(value.EmailID) + '</td>';
                        html += '<td>' + blankForNull(value.DomainName) + '</td>';
                        html += '<td>' + blankForNull(value.Process) + '</td>';
                        html += '<td style="display:none;">' + blankForNull(value.IsResult) + '</td>';
                        html += '<td style="display:none;">' + blankForNull(value.IsCreated) + '</td>';
                        html += '</tr>';
                    });

                    $('#applicant tbody').html(html);
                    if ($.fn.dataTable.isDataTable('#applicant')) {
                        table.destroy();
                    }
                    //else
                    table = $('#applicant').DataTable({
                        dom: 'lBftip',
                        scrollX: true,
                        destroy: true,
                        "paging": true,
                        "autoWidth": false,
                        select: true,
                        processing: true,
                        pageLength: 35,
                        lengthMenu: [[10, 25, 35, 50, 100, -1], [10, 25, 35, 50, 100, "All"]],
                        order: [],
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



        function AddSalaryJustification(AppId, index) {
            row = table.row(index).data();
            location.href = encodeURI('AddApplicantRemark.aspx?InResult=' + row[1]);
        }

        function ViewApplication(AppId, index) {
            row = table.row(index).data();
            location.href = encodeURI('ApplicationForm.aspx?AppId=' + row[1]);
        }

        function CreateProfile(AppId, index) {
            row = table.row(index).data();
            var IsResult = row[10];
            if (IsResult == "false") {
                document.getElementById("vselect_errmsg").innerHTML = "Please enter salary justification first. Please click on <b style='color:dodgerblue;'>Add Salary Justification</b> link in <b>Actions</b> Menu.";
                $("#vselect_dverror").modal("show");
                return false;
            }
            else {
                location.href = "CreateProfile.aspx?AppID=" + AppId;
            }
        }

        function vselect_Message() {
            $("#vselect_dverror").modal("hide");
        }

        function getResult(Type, Content) {
            alert(Content.value);

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
    <div class="vsc-page">
        <div class="vsc-hero">
            <div class="vsc-hero-content">
                <div class="vsc-title-wrap">
                    <div class="vsc-hero-icon">
                        <i class="fas fa-user-check"></i>
                    </div>
                    <div>
                        <h4>View Selected Applicants</h4>
                        <p>Review selected candidates, add salary justification, view applications and create employee profiles.</p>
                    </div>
                </div>
                <div class="vsc-chip">
                    <i class="fas fa-users"></i>
                    Recruitment Selection
                </div>
            </div>
        </div>

        <div class="vsc-panel">
            <div class="vsc-panel-head">
                <div class="vsc-panel-title">
                    <i class="fas fa-list-check"></i>
                    <div>
                        <h5>Selected Candidate List</h5>
                        <span>Use the action menu to manage candidate workflow.</span>
                    </div>
                </div>
            </div>
            <div class="vsc-table-wrap">
                <table class="table table-hover table-bordered" id="applicant">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3">Actions</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Application ID</th>
                            <th class="sort border-top ps-3">Location</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Position Applied</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Application Date</th>
                            <th class="sort border-top ps-3">Name</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Contact #</th>
                            <th class="sort border-top ps-3">Email</th>
                            <th class="sort border-top ps-3">Domain</th>
                            <th class="sort border-top ps-3">Process</th>
                            <th class="sort border-top ps-3" style="display: none;">Is Result</th>
                            <th class="sort border-top ps-3" style="display: none;">Is Created</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>


            </div>
        </div>
    </div>

    <div class="modal fade vselect-modal" id="vselect_dverror" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="ClientHolidaysLabel" aria-hidden="true">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="vselect_errmsg"></h6>
                    <%--<button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>--%>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn-vselect-primary" type="button" id="vselect_btnMessage" onclick="return vselect_Message();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>
