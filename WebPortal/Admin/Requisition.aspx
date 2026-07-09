<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Requisition.aspx.cs" Inherits="WebPortal.Admin.Requisition" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
      #load1.loading {
          display:none;
          position:fixed;
          top:50%;
          left:50%;
          transform:translate(-50%,-50%);
          margin:0;
          width:auto;
          height:auto;
          padding:22px 28px;
          background:rgba(255,255,255,.96);
          border-radius:18px;
          box-shadow:0 18px 45px rgba(15,23,42,.18);
          text-align:center;
          z-index:99999;
          opacity:1;
      }

      #load1 img {
          max-width:70px;
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

        .req-page-shell {
            padding: 0 18px 28px;
        }

        /*   .req-hero {
            background: linear-gradient(105deg, #2854df 0%, #245fe5 42%, #2294e7 78%, #4bc2d7 100%);
            border-radius: 22px;
            box-shadow: 0 16px 34px rgba(37, 99, 235, .18);
            color: #ffffff;
            margin-bottom: 12px;
            min-height: 110px;
            overflow: hidden;
            padding: 24px 28px;
            position: relative;
        }

            .req-hero::before,
            .req-hero::after {
                border-radius: 50%;
                content: "";
                pointer-events: none;
                position: absolute;
            }

            .req-hero::before {
                background: rgba(255, 255, 255, .15);
                height: 190px;
                right: -24px;
                top: -78px;
                width: 146px;
            }

            .req-hero::after {
                background: rgba(255, 255, 255, .12);
                bottom: -84px;
                height: 156px;
                right: 90px;
                width: 118px;
            }

            .req-hero > * {
                position: relative;
                z-index: 1;
            }

        .req-title {
            align-items: center;
            color: #ffffff;
            display: flex;
            font-size: 24px;
            font-weight: 800;
            gap: 15px;
            letter-spacing: 0;
            margin: 0;
        }

            .req-title i {
                align-items: center;
                background: rgba(255, 255, 255, .16);
                border: 1px solid rgba(255, 255, 255, .30);
                border-radius: 20px;
                box-shadow: inset 0 1px 0 rgba(255, 255, 255, .16);
                display: inline-flex;
                font-size: 27px;
                height: 62px;
                justify-content: center;
                width: 62px;
            }

        .req-subtitle {
            color: rgba(255, 255, 255, .92);
            font-size: 12px;
            font-weight: 700;
            margin: 6px 0 0 77px;
        }

        .req-hero-right {
            align-items: center;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: flex-end;
        }

        .req-badge {
            align-items: center;
            background: rgba(255, 255, 255, .13);
            border: 1px solid rgba(255, 255, 255, .30);
            border-radius: 999px;
            box-shadow: inset 0 1px 0 rgba(255, 255, 255, .14);
            color: #ffffff;
            display: inline-flex;
            font-size: 12px;
            font-weight: 800;
            gap: 8px;
            min-height: 38px;
            padding: 9px 16px;
            white-space: nowrap;
        }*/


        .ar-hero {
            background: linear-gradient(120deg,#1d4ed8 0%,#2563eb 58%,#22c1dc 100%);
            border-radius: 18px;
            color: #fff;
            padding: 20px 24px;
            box-shadow: 0 18px 38px rgba(37,99,235,.24);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 18px;
            position: relative;
            overflow: hidden;
        }

            .ar-hero:after {
                content: "";
                position: absolute;
                width: 220px;
                height: 220px;
                right: -70px;
                top: -90px;
                background: rgba(255,255,255,.14);
                border-radius: 50%;
            }

        .ar-title-wrap {
            display: flex;
            align-items: center;
            gap: 14px;
            position: relative;
            z-index: 1;
        }

        .ar-icon {
            width: 54px;
            height: 54px;
            border-radius: 16px;
            background: rgba(255,255,255,.18);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            box-shadow: inset 0 0 0 1px rgba(255,255,255,.28);
        }

        .ar-hero h4 {
            margin: 0;
            font-size: 21px;
            font-weight: 800;
            letter-spacing: .2px;
        }

        .ar-hero p {
            margin: 4px 0 0;
            color: rgba(255,255,255,.86);
            font-size: 13px;
        }

        .ar-back {
            position: relative;
            z-index: 1;
            color: #fff !important;
            border: 1px solid rgba(255,255,255,.38);
            padding: 9px 15px;
            border-radius: 999px;
            font-weight: 700;
            font-size: 12px;
            text-decoration: none !important;
            background: rgba(255,255,255,.12);
            transition: .25s ease;
        }

            .ar-back:hover {
                background: #fff;
                color: #1d4ed8 !important;
                transform: translateY(-1px);
            }


        .req-panel,
        .req-table-panel {
            background: #ffffff;
            border: 1px solid #dbe5ef;
            border-radius: 8px;
            box-shadow: 0 14px 34px rgba(15, 23, 42, .08);
            margin-bottom: 16px;
            overflow: hidden;
        }

        .req-section {
            padding: 20px 22px;
        }

        .req-section-title {
            align-items: center;
            color: #172033;
            display: flex;
            font-size: 15px;
            font-weight: 800;
            gap: 10px;
            margin-bottom: 14px;
        }

            .req-section-title span {
                align-items: center;
                background: #edf4ff;
                border-radius: 8px;
                color: #245fe5;
                display: inline-flex;
                flex: 0 0 32px;
                height: 32px;
                justify-content: center;
                width: 32px;
            }

            .req-section-title small {
                color: #667085;
                display: block;
                font-size: 12px;
                font-weight: 500;
                margin-top: 2px;
            }

        .req-form-grid,
        .req-modal-grid {
            display: grid;
            gap: 14px 16px;
            grid-template-columns: repeat(12, minmax(0, 1fr));
        }

        .req-field {
            grid-column: span 3;
        }

            .req-field.span-4 {
                grid-column: span 4;
            }

            .req-field.span-6 {
                grid-column: span 6;
            }

            .req-field.span-8 {
                grid-column: span 8;
            }

            .req-field.span-12 {
                grid-column: span 12;
            }

            .req-field label {
                color: #344054;
                display: block;
                font-size: 12px;
                font-weight: 700 !important;
                margin-bottom: 7px;
            }

        .req-panel .req-field > label,
        .req-modal .req-field > label {
            font-weight: 700 !important;
        }

        .req-field .form-control,
        .req-readonly-value {
            border: 1px solid #cfd8e3;
            border-radius: 7px;
            box-shadow: none;
            display: block;
            font-size: 13px;
            min-height: 38px;
            padding: .375rem .75rem;
            width: 100% !important;
        }

            .req-field .form-control:focus {
                border-color: #245fe5;
                box-shadow: 0 0 0 .18rem rgba(36, 95, 229, .14);
            }

        .req-field textarea.form-control {
            min-height: 86px;
            resize: vertical;
        }

        .req-readonly-value {
            align-items: center;
            background: #f8fafc;
            color: #172033;
            display: flex;
            margin-bottom: 0;
            overflow-wrap: anywhere;
        }

        .req-actions {
            align-items: center;
            background: #f8fafc;
            border-top: 1px solid #e8eef5;
            display: flex;
            justify-content: flex-end;
            padding: 16px 22px;
        }

        .btn-req-primary {
            background: linear-gradient(105deg, #2854df 0%, #2294e7 100%);
            border: 0;
            border-radius: 8px;
            box-shadow: 0 10px 20px rgba(37, 99, 235, .22);
            color: #ffffff !important;
            font-weight: 800;
            min-height: 40px;
            padding: 9px 24px;
        }

            .btn-req-primary:hover,
            .btn-req-primary:focus {
                background: linear-gradient(105deg, #2047c7 0%, #1687d8 100%);
                box-shadow: 0 12px 24px rgba(37, 99, 235, .28);
                color: #ffffff !important;
            }

        .btn-req-light {
            background: #ffffff;
            border: 1px solid #cfd8e3;
            border-radius: 8px;
            color: #344054;
            font-weight: 700;
            min-height: 40px;
            padding: 9px 20px;
        }

        .req-table-header {
            align-items: center;
            border-bottom: 1px solid #e8eef5;
            display: flex;
            justify-content: space-between;
            padding: 18px 22px;
        }

        .req-table-wrap {
            padding: 16px 22px 22px;
        }

        .req-table {
            margin-bottom: 0 !important;
        }

            .req-table th {
                color: #172033;
                font-size: 12px;
                white-space: nowrap;
            }

        .table.dataTable th {
            background: #edf4ff !important;
            color: #172033 !important;
        }

        .table.dataTable tr td {
            background-color: #ffffff !important;
            font-size: 13px;
            vertical-align: middle;
        }

        div.dt-buttons {
            float: left;
            padding-left: 18px;
            position: static;
        }

        .buttons-excel,
        .buttons-html5,
        .btn-datatable {
            background: linear-gradient(105deg, #2854df 0%, #2294e7 100%) !important;
            border: 0 !important;
            border-radius: 8px !important;
            box-shadow: 0 8px 18px rgba(37, 99, 235, .18) !important;
            color: #ffffff !important;
            font-weight: 800 !important;
            margin: 0 6px 8px !important;
            padding: 7px 14px !important;
        }

        .req-action-trigger {
            align-items: center;
            background: #edf4ff;
            border: 1px solid #c7dcff;
            border-radius: 8px;
            color: #245fe5;
            display: inline-flex;
            height: 34px;
            justify-content: center;
            width: 38px;
        }

        .req-action-menu {
            border: 1px solid #dbe5ef;
            border-radius: 8px;
            box-shadow: 0 14px 34px rgba(15, 23, 42, .16);
            font-size: 13px;
            min-width: 150px;
        }

        .req-modal .modal-content {
            border: 0;
            border-radius: 10px;
            box-shadow: 0 24px 55px rgba(15, 23, 42, .28);
            overflow: hidden;
        }

        .req-modal .modal-header {
            background: linear-gradient(105deg, #2854df 0%, #2294e7 100%);
            color: #ffffff;
        }

        .req-modal .modal-title {
            font-size: 18px;
            font-weight: 800;
        }

        .req-modal .close {
            color: #ffffff;
            opacity: .95;
        }

        .is-invalid-field {
            border-color: #dc3545 !important;
            box-shadow: 0 0 0 .16rem rgba(220, 53, 69, .14) !important;
        }

        .loading {
            align-items: center;
            background: rgba(15, 23, 42, .36);
            height: auto;
            inset: 0;
            left: 0;
            margin: 0;
            opacity: 1;
            top: 0;
            width: auto;
        }

            .loading[style*="display: block"] {
                display: flex !important;
            }

        .loading-card {
            align-items: center;
            background: #ffffff;
            border-radius: 8px;
            box-shadow: 0 18px 45px rgba(15, 23, 42, .22);
            color: #344054;
            display: flex;
            gap: 12px;
            min-width: 260px;
            padding: 18px 20px;
        }

            .loading-card img {
                height: 38px;
                width: 38px;
            }

        @media(max-width:991px) {
            .req-field,
            .req-field.span-4,
            .req-field.span-6,
            .req-field.span-8 {
                grid-column: span 6;
            }
        }

        @media(max-width:576px) {
            .req-page-shell {
                padding: 0 12px 22px;
            }

            .req-section,
            .req-table-header,
            .req-table-wrap {
                padding: 16px 14px;
            }

            .req-field,
            .req-field.span-4,
            .req-field.span-6,
            .req-field.span-8 {
                grid-column: span 12;
            }

            .req-subtitle {
                margin-left: 0;
            }

            .req-hero-right {
                justify-content: stretch;
                width: 100%;
            }

            .req-badge,
            .req-actions .btn-req-primary {
                justify-content: center;
                width: 100%;
            }

            .req-actions {
                padding: 14px;
            }
        }
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
            // $('#load1').show();
             $('.loading-overlay, .loading').show();
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
                        html += '<td><div class="dropdown req-row-actions">';
                        html += '<button type="button" class="btn req-action-trigger" data-toggle="dropdown" aria-expanded="false" title="Actions"><i class="fas fa-ellipsis-h"></i><span class="sr-only">Actions</span></button>';
                        html += '<div class="dropdown-menu dropdown-menu-right req-action-menu" role="menu">';
                        html += '<a class="dropdown-item" href="#!" id="Actions" onclick="Approve(' + value.RecId + ',' + index + ',1);"><span class="text-success"><i class="fas fa-check-circle"></i></span>&nbsp;&nbsp;Approve</a>';
                        html += '<a class="dropdown-item" href="#!" id="ActionsEx" onclick="Close(' + value.RecId + ',' + index + ');"><span class="text-primary"><i class="fas fa-times-circle"></i></span>&nbsp;&nbsp;Close</a></div></div></td>';
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
                                // $('#load1').hide();
                                $('.loading-overlay, .loading').hide();
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
        function showReqValidation(message, fieldId) {
            alert(message);
            var field = document.getElementById(fieldId);
            if (field) {
                field.focus();
                field.classList.add("is-invalid-field");
                setTimeout(function () {
                    field.classList.remove("is-invalid-field");
                }, 1800);
            }
            return false;
        }

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

            if (designation == "") {
                return showReqValidation("Please select profile.", "reqprofile");
            }
            if ($.trim(noofpositions) == "" || parseInt(noofpositions, 10) <= 0) {
                return showReqValidation("Please enter valid number of positions.", "NoOfPositions");
            }
            if (domain == "") {
                return showReqValidation("Please select domain.", "domain");
            }
            if (projects == "") {
                return showReqValidation("Please select project.", "projects");
            }
            if (process == "") {
                return showReqValidation("Please select process.", "process");
            }
            if (shift == "") {
                return showReqValidation("Please select shift.", "shift");
            }
            if (location == "Select" || location == "") {
                return showReqValidation("Please select location.", "location");
            }
            if (employmenttype == "Select" || employmenttype == "") {
                return showReqValidation("Please select employment type.", "employmenttype");
            }
            if (department == "") {
                return showReqValidation("Please select department.", "department");
            }
            if (source == "Select" || source == "") {
                return showReqValidation("Please select source.", "source");
            }

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
        <div class="loading-card">
            <img src="../images/Load_1.gif" alt="" />
            <div>
                <strong>Loading requisitions</strong>
                <div class="text-muted small">One moment, please.</div>
            </div>
        </div>
    </div>
    <%--  <div class="content-header">
        <div class="container-fluid">
            <div class="req-hero d-flex justify-content-between align-items-center flex-wrap">
                <div>
                    <h1 class="req-title"><i class="fas fa-user-plus"></i><b>Manpower Requisition</b></h1>
                    <div class="req-subtitle">Create staffing requests, track approval status and manage closure.</div>
                </div>
                <div class="req-hero-right mt-3 mt-sm-0">
                    <div class="req-badge"><i class="fas fa-users-cog"></i> Recruitment Request</div>
                </div>
            </div>
        </div>
    </div>--%>


    <div class="ar-hero">
        <div class="ar-title-wrap">
            <div class="ar-icon"><i class="fas fa-user-tie"></i></div>
            <div>
                <h4>Manpower Requisition</h4>
                <p>Create staffing requests, track approval status and manage closure.</p>
            </div>
        </div>
        <div class="applicant-chip">
            <i class="fas fa-users-cog"></i>
            Recruitment Request
 
        </div>
    </div>
    <div class="container-fluid req-page-shell">
        <div class="req-panel">
            <div class="req-section">
                <div class="req-section-title">
                    <span><i class="fas fa-clipboard-list"></i></span>
                    <div>
                        New Requisition
                       
                        <small>Fill the hiring need, workstream and sourcing details.</small>
                    </div>
                </div>

                <div class="req-form-grid">
                    <div class="req-field span-4">
                        <label for="reqprofile">Profile</label>
                        <select id="reqprofile" name="reqprofile" class="form-control" required>
                            <option value="">Select</option>
                        </select>
                    </div>
                    <div class="req-field span-4">
                        <label for="NoOfPositions">No. of Positions</label>
                        <input type="number" id="NoOfPositions" name="NoOfPositions" class="form-control" min="1" required />
                    </div>
                    <div class="req-field span-4">
                        <label for="domain">Domain</label>
                        <select id="domain" name="domain" class="form-control" required>
                            <%--onchange="ondomainclick();"--%>
                            <option value="">Select</option>
                        </select>
                    </div>
                    <div class="req-field span-4" style="display: none;">
                        <label for="subdomain">Subdomain</label>
                        <select id="subdomain" name="subdomain" class="form-control" required>
                            <option value="">Select</option>
                        </select>
                    </div>
                    <div class="req-field span-4" id="trProject">
                        <label for="projects">Project #</label>
                        <select id="projects" name="projects" class="form-control" onchange="onprojectclick();" required>
                            <option value="">Select</option>
                        </select>
                    </div>
                    <div class="req-field span-4">
                        <label for="process">Process</label>
                        <select id="process" name="process" class="form-control" required>
                            <option value="">Select</option>
                        </select>
                    </div>
                    <div class="req-field span-4">
                        <label for="shift">Shift</label>
                        <select id="shift" name="shift" class="form-control" required>
                            <option value="">Select</option>
                        </select>
                    </div>
                    <div class="req-field span-4">
                        <label for="location">Location</label>
                        <select id="location" name="location" class="form-control" required>
                            <option value="">Select</option>
                            <option value="Akola">Akola</option>
                            <option value="Bangalore">Bangalore</option>
                            <option value="Kothrud">Kothrud</option>
                            <option value="KP">KP</option>
                            <option value="Solapur">Solapur</option>
                            <option value="Swargate">Swargate</option>
                        </select>
                    </div>
                    <div class="req-field span-4">
                        <label for="employmenttype">Employment Type</label>
                        <select id="employmenttype" name="employmenttype" class="form-control" required>
                            <option value="">Select</option>
                            <option value="Employee">Employee</option>
                            <option value="Consultant">Consultant</option>
                            <option value="Vendor(Part Time)">Vendor (Part Time)</option>
                            <option value="Vendor(Full Time)">Vendor (Full Time)</option>
                        </select>
                    </div>
                    <div class="req-field span-4">
                        <label for="department">Department</label>
                        <select id="department" name="department" class="form-control" required>
                            <option value="">Select</option>
                        </select>
                    </div>
                    <div class="req-field span-4">
                        <label for="source">Source</label>
                        <select id="source" name="source" class="form-control" required>
                            <option value="">Select</option>
                            <option value="Advertisement">Advertisement</option>
                            <option value="Database">Database</option>
                            <option value="Online Portal">Online Portal</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                    <div class="req-field span-4">
                        <label for="deadline">Deadline</label>
                        <input type="date" id="deadline" name="deadline" class="form-control" max="2999-12-31" />
                    </div>
                    <div class="req-field span-8">
                        <label for="remark">Remark</label>
                        <textarea id="remark" name="remark" class="form-control"></textarea>
                    </div>
                </div>
            </div>
            <div class="req-actions">
                <button type="button" class="btn btn-req-primary" onclick="submitdata();">
                    <i class="fas fa-plus-circle"></i>&nbsp; Add Requisition
               
                </button>
            </div>
        </div>

        <div class="req-table-panel">
            <div class="req-table-header">
                <div class="req-section-title mb-0">
                    <span><i class="fas fa-table"></i></span>
                    <div>
                        Requisition List
                       
                        <small>Approval, status and deadline tracking.</small>
                    </div>
                </div>
            </div>
            <div class="req-table-wrap">
                <table class="table table-hover req-table" id="manpower" style="width: 100%;">
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


    <div class="modal fade req-modal" id="approve">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Approve Requisition</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <%--   <div class="req-modal-grid">
                        <div class="req-field span-3">
                            <label>Profile</label>
                            <label id="profilepop" name="profilepop" class="req-readonly-value"></label>
                            <label id="lblRecId" style="display: none;"></label>
                        </div>
                        <div class="req-field span-3">
                            <label># of Positions</label>
                            <label id="NoOfPositionspop" name="NoOfPositionspop" class="req-readonly-value"></label>
                        </div>
                        <div class="req-field span-3">
                            <label>Domain</label>
                            <label id="domainpop" name="domainpop" class="req-readonly-value"></label>
                        </div>
                        <div class="req-field span-3">
                            <label>Subdomain</label>
                            <label id="subdomainpop" name="subdomainpop" class="req-readonly-value"></label>
                        </div>
                        <div class="req-field span-3">
                            <label>Project #</label>
                            <label id="projectspop" name="projectspop" class="req-readonly-value"></label>
                        </div>
                        <div class="req-field span-3">
                            <label>Process</label>
                            <label id="processpop" name="processpop" class="req-readonly-value"></label>
                        </div>
                        <div class="req-field span-3">
                            <label>Shift</label>
                            <label id="shiftpop" name="shiftpop" class="req-readonly-value"></label>
                        </div>
                        <div class="req-field span-3">
                            <label>Location</label>
                            <label id="locationpop" name="locationpop" class="req-readonly-value"></label>
                        </div>
                        <div class="req-field span-6">
                            <label for="costapproved">Salary Range</label>
                            <input id="costapproved" name="costapproved" class="form-control" required />
                        </div>
                    </div>--%>

                    <div class="req-modern-card">
                        <div class="req-modern-grid">

                            <div class="req-info-box">
                                <span class="req-label">Profile</span>
                                <span id="profilepop" class="req-value"></span>
                                <span id="lblRecId" style="display: none;"></span>
                            </div>

                            <div class="req-info-box">
                                <span class="req-label"># of Positions</span>
                                <span id="NoOfPositionspop" class="req-value"></span>
                            </div>

                            <div class="req-info-box">
                                <span class="req-label">Domain</span>
                                <span id="domainpop" class="req-value"></span>
                            </div>

                            <div class="req-info-box">
                                <span class="req-label">Subdomain</span>
                                <span id="subdomainpop" class="req-value"></span>
                            </div>

                            <div class="req-info-box">
                                <span class="req-label">Project #</span>
                                <span id="projectspop" class="req-value"></span>
                            </div>

                            <div class="req-info-box">
                                <span class="req-label">Process</span>
                                <span id="processpop" class="req-value"></span>
                            </div>

                            <div class="req-info-box">
                                <span class="req-label">Shift</span>
                                <span id="shiftpop" class="req-value"></span>
                            </div>

                            <div class="req-info-box">
                                <span class="req-label">Location</span>
                                <span id="locationpop" class="req-value"></span>
                            </div>

                            <div class="req-input-box">
                                <label for="costapproved">Salary Range</label>
                                <input id="costapproved" name="costapproved" class="form-control" required placeholder="Enter salary range" />
                            </div>

                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-req-light" data-dismiss="modal">Close</button>
                    <button class="btn btn-req-primary" type="button" id="btnapprove" onclick="ApproveRequisition();">Approve</button>
                </div>
                <script type="text/javascript">
                    function ApproveRequisition() {
                        var RecId = document.getElementById("lblRecId").innerHTML;
                        var costapproved = document.getElementById("costapproved").value;
                        if ($.trim(costapproved) == "") {
                            return showReqValidation("Please enter salary range.", "costapproved");
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

    <div class="modal fade req-modal" id="close">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Close Requisition</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="req-modal-grid">
                        <div class="req-field span-12">
                            <label>Requisition</label>
                            <label id="profilepopclose" name="profilepopclose" class="req-readonly-value"></label>
                            <label id="lblRecIdclose" style="display: none;"></label>
                        </div>
                        <div class="req-field span-12">
                            <label for="closureremark">Closure Remark</label>
                            <textarea id="closureremark" name="closureremark" class="form-control" required></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-req-light" data-dismiss="modal">Close</button>
                    <button class="btn btn-req-primary" type="button" id="btnclose" onclick="CloseRequisition();">Close Requisition</button>
                </div>
                <script type="text/javascript">
                    function CloseRequisition() {
                        var RecId = document.getElementById("lblRecIdclose").innerHTML;
                        var closureremark = document.getElementById("closureremark").value;
                        if ($.trim(closureremark) == "") {
                            return showReqValidation("Please enter closure remark.", "closureremark");
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


    <style>
        .req-modern-card {
            background: #ffffff;
            border-radius: 18px;
            padding: 18px;
            box-shadow: 0 12px 35px rgba(15, 23, 42, 0.10);
            border: 1px solid #e5e7eb;
        }

        .req-modern-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 14px;
        }

        .req-info-box,
        .req-input-box {
            background: linear-gradient(180deg, #f8fbff 0%, #ffffff 100%);
            border: 1px solid #dbeafe;
            border-radius: 14px;
            padding: 12px 14px;
            min-height: 74px;
            transition: all 0.25s ease;
        }

            .req-info-box:hover,
            .req-input-box:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 22px rgba(37, 99, 235, 0.12);
                border-color: #93c5fd;
            }

            .req-label,
            .req-input-box label {
                display: block;
                font-size: 12px;
                font-weight: 700;
                color: #2563eb;
                text-transform: uppercase;
                letter-spacing: 0.4px;
                margin-bottom: 6px;
            }

        .req-value {
            display: block;
            font-size: 14px;
            font-weight: 700;
            color: #111827;
            word-break: break-word;
        }

        .req-input-box {
            grid-column: span 2;
        }

            .req-input-box .form-control {
                height: 38px;
                border-radius: 10px;
                border: 1px solid #cbd5e1;
                font-weight: 600;
            }

                .req-input-box .form-control:focus {
                    border-color: #2563eb;
                    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15);
                }

        @media (max-width: 992px) {
            .req-modern-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .req-input-box {
                grid-column: span 2;
            }
        }

        @media (max-width: 576px) {
            .req-modern-card {
                padding: 12px;
            }

            .req-modern-grid {
                grid-template-columns: 1fr;
            }

            .req-input-box {
                grid-column: span 1;
            }
        }
    </style>



</asp:Content>
