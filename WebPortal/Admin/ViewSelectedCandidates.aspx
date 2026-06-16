<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ViewSelectedCandidates.aspx.cs" Inherits="WebPortal.Admin.ViewSelectedCandidates" %>

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

                        html += '<td class=""><div class="btn-group">';
                        html += '<div class="btn-group">';
                        html += '<div type="button" data-toggle="dropdown" aria-expanded="false"><i style="color: dodgerblue; font-size:14px;" class="uil fs-0 me-2 uil-cog"></i>';
                        html += '<span class="sr-only"></span></div><div class="dropdown-menu" role="menu" style="">';
                        html += '<a class="dropdown-item" href="#!" id="Actions" onclick="AddSalaryJustification(' + value.AppID + ',' + index + ');"><span style="color: forestgreen;"><i class="uil fs-0 me-2 uil-pen"></i></span>&nbsp;&nbsp;Add Salary Justification</a>';
                        html += '<a class="dropdown-item" href="#!" id="ActionsEx" onclick="ViewApplication(' + value.AppID + ',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-file"></i></span>&nbsp;&nbsp;View Application</a>';

                        if (blankForNull(value.IsCreated) == '1')
                            html += '<a class="dropdown-item isDisabled" href="#!" id="ActionsExCreate"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-user"></i></span>&nbsp;&nbsp;Create Profile</a><div class="dropdown-divider"></div></div></div></td>';
                        else
                            html += '<a class="dropdown-item" href="#!" id="ActionsExCreate" onclick="CreateProfile(' + value.AppID + ',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-user"></i></span>&nbsp;&nbsp;Create Profile</a><div class="dropdown-divider"></div></div></div></td>';

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
                        dom: 'lftip',
                        scrollX: true,
                        destroy: true,
                        "paging": true,
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
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>View Selected Applicants</b></h6>
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

    <div class="modal fade" id="vselect_dverror" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="ClientHolidaysLabel" aria-hidden="true">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="vselect_errmsg"></h6>
                    <%--<button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>--%>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="vselect_btnMessage" onclick="return vselect_Message();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>
