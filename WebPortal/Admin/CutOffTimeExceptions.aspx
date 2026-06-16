<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="CutOffTimeExceptions.aspx.cs" Inherits="WebPortal.Admin.CutOffTimeExceptions" %>

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

        .select2-container--default .select2-selection--multiple .select2-selection__choice {
            color: #000 !important;
        }

        .btn-gradient-primary {
            background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;
            color: #fff;
            border-radius: 12px;
            height: 40px;
            font-weight: 400;
            transition: 0.3s;
        }

            .btn-gradient-primary:hover {
                transform: translateY(-2px);
                /*background: linear-gradient(135deg, #4da6ff, #1a8cff);*/
                background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;
                color: #fff;
            }
    </style>

    <script>
        $(document).ready(function () {

            cotexp_bindusers();
            cotexp_bindtable();

            const today = new Date().toISOString().split("T")[0];
            document.getElementById("cotexp_fromdate").setAttribute("min", today);
            document.getElementById("cotexp_todate").setAttribute("min", today);

            $("#cotexp_user").select2({
                placeholder: "Select",
                allowClear: true,
                closeOnSelect: false,
                templateResult: function (data) {
                    if (data.id === '') {
                        return data.text;
                    }
                    var checkbox = $('<span><input type="checkbox" style="margin-right:6px;"> ' + data.text + '</span>');
                    return checkbox;
                }
            });
        });

        function cotexp_bindusers() {
            var select = document.getElementById("cotexp_user");
            let options = select.getElementsByTagName('option');

            for (var i = options.length; i--;) {
                select.removeChild(options[i]);
            }
            $("#cotexp_user").append($("<option></option>").val("").html("Select"));
            $.ajax({
                type: "POST", url: "AttendanceCorrectionpm.aspx/GteAllUsers", dataType: "json", contentType: "application/json",
                success: function (res) {
                    var dataArray = JSON.parse(res.d);
                    $.each(dataArray, function (data, value) {
                        $("#cotexp_user").append($("<option></option>").val(value.Code).html(value.Code + ' : ' + value.Name));
                    })
                }
            });
        }

        function cotexp_submit() {
            let selectedValues = $("#cotexp_user").val();
            if (!selectedValues || selectedValues == '') {
                alert("Please select at least one user.");
                return false;
            }
            var fromdate = document.getElementById("cotexp_fromdate").value;
            var todate = document.getElementById("cotexp_todate").value;
            if (fromdate == "") {
                alert("Please select From date");
                return false;
            }
            if (todate == "") {
                alert("Please select To date");
                return false;
            }
            var reason = document.getElementById("cotexp_reason").value;
            if (reason == "") {
                alert("Please enter reason");
                document.getElementById("cotexp_reason").focus();
                return false;
            }
            if (reason.length < 10) {
                alert("Reason should be more than 10 characters.");
                return false;
            }
            PageMethods.InsertERPCutOffTimeException(selectedValues, fromdate, todate, reason, cotexp_OnSuccess, cotexp_OnError);
            return false;
        }

        function cotexp_OnSuccess(result) {
            document.getElementById("cotexp_errmsg").innerHTML = "Codes added in exception list successfully!";
            $("#cotexp_dverror").modal("show");
            cotexp_bindtable();
            return false;
        }

        function cotexp_OnError(error) {
            alert(error.responseText);
        }

        function blankForNull(s) {
            return s == "null" || s == null ? "" : s;
        }


        function cotexp_bindtable() {
            $('#load1').show();

            if ($.fn.dataTable.isDataTable('#cotexp_table')) {
                $('#cotexp_table').DataTable().destroy();
                $('#cotexp_table tbody').empty(); // important
            }

            $.ajax({
                url: "CutOffTimeExceptions.aspx/GetERpCutOffTimeException",
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",

                success: function (data) {

                    let dataArray = JSON.parse(data.d);

                    $('#cotexp_table').DataTable({
                        data: dataArray,   // 🔥 direct binding (no loop)

                        columns: [
                            {
                                data: null, title: "Sr. #", render: function (data, type, row, meta) { return meta.row + 1; }
                            },
                            { data: "Code", title: "Code", render: blankForNull },
                            { data: "Name", title: "Name", render: blankForNull },
                            { data: "FromDate", title: "From Date", render: blankForNull },
                            { data: "ToDate", title: "To Date", render: blankForNull },
                            { data: "Remark", title: "Remark", render: blankForNull },
                            { data: "AddedByName", title: "Added By", render: blankForNull }
                        ],

                        dom: 'pfti',
                        scrollX: true,
                        paging: true,
                        autoWidth: false,
                        ordering: true,
                        processing: true,
                        deferRender: true, // ⚡ BIG performance boost

                        initComplete: function () {
                            $('#load1').hide();
                        }
                    });
                },

                error: function (error) {
                    $('#load1').hide();
                    alert('Error: ' + error.responseText);
                }
            });

            return false;
        }

    </script>

    <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/css/select2.min.css" rel="stylesheet" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/js/select2.min.js"></script>
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Add Exception for Cut off time</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <div class="container mt-4">
                    <div class="card shadow-sm">

                        <!-- Row 1 -->
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label><b>Employee</b></label>
                                <select id="cotexp_user" class="form-control" multiple></select>
                            </div>

                            <div class="col-md-3">
                                <label><b>From Date</b></label>
                                <input type="date" id="cotexp_fromdate" class="form-control" />
                            </div>

                            <div class="col-md-3">
                                <label><b>To Date</b></label>
                                <input type="date" id="cotexp_todate" class="form-control" />
                            </div>
                        </div>

                        <!-- Row 2 -->
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label><b>Reason</b></label>
                                <textarea id="cotexp_reason" class="form-control"></textarea>
                            </div>

                            <div class="col-md-3 d-flex align-items-end">
                                <button class="btn btn-gradient-primary w-100" onclick="return cotexp_submit();">
                                    Submit Request
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <table class="table" id="cotexp_table" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">From Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">To Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Remark</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added By</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr></tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="modal fade" id="cotexp_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="cotexp_errmsg"></h6>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="cotexp_btnMessage" onclick="location.reload();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>
