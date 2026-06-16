<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AgreementVersionControl.aspx.cs" Inherits="WebPortal.Admin.AgreementVersionControl" %>

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

        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dt-buttons {
            display: flex;
            align-items: center;
        }

        .dataTables_wrapper .dataTables_length {
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
    </style>


    <%--Clause Functions--%>
    <script>
        var global_agrChangeID = 0;
        var agreeVersion_table;


        $(document).ready(function () {
            BindAgreementVersionGrid();
            updateDeleteButtons();

            $("#btnSaveAll").click(function () {

                var version = $("#txtVersion").val().trim();
                var versionDate = $("#txtVersionDate").val();

                if (version === "") {
                    alert("Please enter Version");
                    return;
                }

                if (versionDate === "") {
                    alert("Please select Version Date");
                    return;
                }

                var clauseList = [];

                $(".clause-row").each(function () {

                    var clauseNo = $(this).find(".clause-no").val().trim();
                    var clauseDetails = $(this).find(".clause-details").val().trim();

                    if (clauseNo !== "" && clauseDetails !== "") {
                        clauseList.push({
                            ClauseNo: clauseNo,
                            ClauseDetails: clauseDetails
                        });
                    }
                });

                if (clauseList.length === 0) {
                    alert("Please enter at least one clause");
                    return;
                }

                PageMethods.SaveAgreement_Versions(version, versionDate, clauseList,
                    function (response) {
                        if (response === "Success") {
                            alert("Details Saved Successfully");
                            location.reload();
                        } else {
                            alert(response);
                        }
                    },
                    function (error) {
                        alert("Error: " + error.get_message());
                    }
                );
            });
        });


        function addClause() {

            var newRow = $(".clause-row:first").clone();

            newRow.find("input").val("");
            newRow.find("textarea").val("");

            $("#clauseContainer").append(newRow);

            updateDeleteButtons();
            updateClauseNumbers();
        }

        $(document).on("click", ".delete-clause", function () {
            $(this).closest(".clause-row").remove();
            updateDeleteButtons();
            updateClauseNumbers();
        });

        function updateDeleteButtons() {

            $(".clause-row").each(function (index) {
                if (index === 0) {
                    $(this).find(".delete-clause").hide();
                } else {
                    $(this).find(".delete-clause").show();
                }
            });
        }

        function updateClauseNumbers() {

            $(".clause-row").each(function (index) {

                var serial = index + 1;

                $(this).find(".clause-label").html("<b>Clause " + serial + " :</b>");

            });
        }

        function BindAgreementVersionGrid() {
            $.ajax({
                url: "AgreementVersionControl.aspx/GetAgreementVersionHistory",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {

                    var data = JSON.parse(response.d);

                    $('#table_agreeVerControl').DataTable({
                        destroy: true,
                        dom: 'lftip',
                        data: data,
                        order: false,
                        columns: [
                            //{
                            //    className: 'text-center',
                            //    orderable: false,
                            //    render: function (data, type, row, meta) {
                            //        return '<a class="dropdown-item" href="#!" ' + 'data-bs-toggle="tooltip" data-bs-placement="top" title="Edit" ' + 'onclick="Edit_Clause(' + row.AgrChangeID + ',' + meta.row + ');">' + '<span style="color: forestgreen;">' + '<i class="uil-edit-alt"></i>' + '</span></a>';
                            //    }
                            //},
                            { data: 'AgrChangeID', visible: false },
                            { data: "SrNo" },
                            { data: "Version" },
                            { data: "VersionDate" },
                            { data: "ClauseNo" },
                            { data: "Clause" },
                            { data: "AddedByName" },
                            { data: "AddedDate" }
                        ],

                        initComplete: function () {

                            $('#load1').hide();
                        }
                    });
                }
            });
        }

        function Edit_Clause(id, index) {

            var table = $('#table_agreeVerControl').DataTable();
            var row = table.row(index).data();

            document.getElementById('editagrheadercontrol_clauseNo').value = row["ClauseNo"];
            document.getElementById('editagrheadercontrol_clausedetails').value = row["Clause"];

            global_agrChangeID = id;

            var hh = "Edit Clause - " + row["Version"] + " : " + row["VersionDate"];

            $('#editagrheadercontrol_lbldetails').text(hh);
            $('#popUp_editagrversioncontrol').modal('show');
        }

        function agrversioncontrol_btnSubmit() {

            var AgrChangeID = $("#hdnAgrChangeID").val(); // hidden field (you must have this)
            var ClauseNo = $("#editagrheadercontrol_clauseNo").val().trim();
            var ClauseDetails = $("#editagrheadercontrol_clausedetails").val().trim();

            if (ClauseNo == "") {
                alert("Please enter Clause No");
                return false;
            }

            if (ClauseDetails == "") {
                alert("Please enter Clause Details");
                return false;
            }

            PageMethods.UpdateAgreementVersionHistory(global_agrChangeID, ClauseNo, ClauseDetails, function (response) {
                if (response > 0) {
                    global_agrChangeID = 0;
                    alert("Record Updated Successfully");
                    $('#popUp_editagrversioncontrol').modal('hide');  // replace with actual modal id
                    // refresh grid if needed
                    BindAgreementVersionGrid();
                }
                else {
                    alert("Update Failed");
                }
            },
                function (error) {  // Error
                    alert("Error: " + error.get_message());
                }
            );

            return false;
        }

    </script>



    <%--Type Functions--%>
    <script>

        $(document).ready(function () {

            BindAgreementTypeGrid();
            updateTypeDeleteButtons();
            updateTypeNumbers();

            $("#btnTypeSaveAll").click(function () {

                var version1 = $("#txttypeVersion").val().trim();
                var versionDate1 = $("#txttypeVersionDate").val();

                if (version1 === "") {
                    alert("Please enter Version");
                    return;
                }

                if (versionDate1 === "") {
                    alert("Please select Version Date");
                    return;
                }

                var typeList = [];

                $(".type-row").each(function () {

                    var typeText = $(this).find(".type-no").val();
                    var minServicePeriod = $(this).find(".type-details").val();

                    typeText = typeText ? typeText.trim() : "";
                    minServicePeriod = minServicePeriod ? minServicePeriod.trim() : "";

                    if (typeText !== "" && minServicePeriod !== "") {

                        typeList.push({
                            TypeText: typeText,
                            MinServicePeriod: minServicePeriod
                        });
                    }
                });

                if (typeList.length === 0) {
                    alert("Please enter at least one Type");
                    return;
                }

                // 🔹 AJAX CALL
                $.ajax({
                    type: "POST",
                    url: "AgreementVersionControl.aspx/SaveAgreement_Types",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    data: JSON.stringify({
                        version: version1,
                        versionDate: versionDate1,
                        typeList: typeList
                    }),
                    success: function (response) {

                        if (response.d === "Success") {
                            alert("Details Saved Successfully");
                            location.reload();
                        } else {
                            alert(response.d);
                        }
                    },
                    error: function (xhr) {
                        alert("Error: " + xhr.responseText);
                    }
                });
            });
        });

        // Add New Type Row
        function addtype() {

            var newRow = $(".type-row:first").clone();

            // Clear values
            newRow.find("textarea").val("");

            // Append
            $("#typeContainer").append(newRow);

            updateTypeDeleteButtons();
            updateTypeNumbers();
        }


        // Delete Type Row
        $(document).on("click", ".delete-type", function () {
            $(this).closest(".type-row").remove();
            updateTypeDeleteButtons();
            updateTypeNumbers();
        });


        // Hide delete button for first row
        function updateTypeDeleteButtons() {

            $(".type-row").each(function (index) {
                if (index === 0) {
                    $(this).find(".delete-type").hide();
                } else {
                    $(this).find(".delete-type").show();
                }
            });
        }


        // Update Type Number Label (Type 1, Type 2, etc.)
        function updateTypeNumbers() {

            $(".type-row").each(function (index) {

                var serial = index + 1;

                $(this).find(".type-label").html("<b>Type " + serial + " :</b>");

            });
        }


        function BindAgreementTypeGrid() {
            $.ajax({
                url: "AgreementVersionControl.aspx/GetAgreementTypeHistory",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {

                    var data = JSON.parse(response.d);

                    $('#table_agreeType').DataTable({
                        destroy: true,
                        dom: 'lftip',
                        data: data,
                        columns: [

                            { data: "SrNo" },
                            { data: "Version" },
                            { data: "VersionDate" },
                            { data: "AgreementType" },
                            { data: "MinServicePeriod" },
                            { data: "AddedByName" },
                            { data: "AddedDate1" }
                        ],

                        initComplete: function () {

                            $('#load1').hide();
                        }
                    });
                }
            });
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Agreement Version Control</b></h6>
                </div>
                <div class="col-sm-6" style="text-align: right;">
                    <a href="AgreementVersionsHistoryReport.aspx" class="m-0" style="font-size: 13px; text-decoration: underline; margin-right: 100px; font-weight: bold;">Agreement Version Report</a>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-header p-0 pt-1">
                <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist" style="font-weight: bold;">
                    <li class="nav-item">
                        <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Version History</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" id="custom-tabs-one-excel-tab" data-toggle="pill" href="#custom-tabs-one-excel" role="tab" aria-controls="custom-tabs-one-excel" aria-selected="false">Type History</a>
                    </li>
                </ul>
            </div>
            <div class="card-body">
                <div class="tab-content" id="custom-tabs-one-tabContent">
                    <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                        <%--<div class="card-body"></div>--%>

                        <div class="row mb-4">


                            <%--  <div class="col-md-6">
                                    <labe class="clause-label"><b>Version :</b></labe>
                                    <input type="text" id="txtVersion" class="form-control" placeholder="Enter Version" />
                                </div>
                                <div class="col-md-6">
                                    <labe class="clause-label"><b>Version :</b></labe>
                                    <input type="date" id="txtVersionDate" class="form-control" placeholder="Enter Version Date" />
                                </div>--%>
                            <div class="col-md-1">
                                <label><b>Version :</b></label>
                            </div>
                            <div class="col-md-4">
                                <input type="text" id="txtVersion" class="form-control" placeholder="Enter Version" />
                            </div>

                            <div class="col-md-2" style="text-align: right;">
                                <label><b>Version Date :</b></label>
                            </div>
                            <div class="col-md-4">
                                <input type="date" id="txtVersionDate" class="form-control" />
                            </div>
                        </div>

                        <!-- Clause Section -->
                        <h5><b>Clauses</b></h5>
                        <div id="clauseContainer">
                            <div class="clause-row mb-3 p-3 border rounded">
                                <div class="row">
                                    <div class="col-md-3">
                                        <label class="clause-label"><b>Clause 1 :</b></label>
                                        <input type="text" class="form-control clause-no" placeholder="Enter Clause No" />
                                    </div>
                                    <div class="col-md-8">
                                        <label><b>Clause Details :</b></label>
                                        <textarea class="form-control clause-details" rows="3"
                                            placeholder="Enter Clause Details"></textarea>
                                    </div>
                                    <div class="col-md-1 d-flex align-items-end">
                                        <button type="button" class="btn btn-danger btn-sm delete-clause">X</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- Bottom Buttons -->
                        <div class="text-right">
                            <button type="button" class="btn btn-info" onclick="addClause()">+ Add Clause</button>
                            <button type="button" id="btnSaveAll" class="btn btn-primary">Submit</button>
                        </div>


                        <div class="card-body">
                            <table class="table" id="table_agreeVerControl" style="width: 100%;">
                                <thead>
                                    <tr>
                                        <%-- <th class="sort border-top ps-3" style="text-wrap: nowrap;">Action</th>--%>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; display: none;">AgrChangeID</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Version</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Version Date</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Clause #</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Clause </th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added By</th>
                                        <th class="sort border-top ps-3">Added Date</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="custom-tabs-one-excel" role="tabpanel" aria-labelledby="custom-tabs-one-excel-tab">

                        <div class="row mb-4">
                            <div class="col-md-1">
                                <label><b>Version :</b></label>
                            </div>
                            <div class="col-md-4">
                                <input type="text" id="txttypeVersion" class="form-control" placeholder="Enter Version" />
                            </div>
                            <div class="col-md-2" style="text-align: right;">
                                <label><b>Version Date :</b></label>
                            </div>
                            <div class="col-md-4">
                                <input type="date" id="txttypeVersionDate" class="form-control" />
                            </div>
                        </div>
                        <!-- Type Section -->
                        <h5><b>Types</b></h5>
                        <div id="typeContainer">
                            <div class="type-row mb-3 p-3 border rounded">
                                <div class="row">
                                    <div class="col-md-6">
                                        <label class="type-label"><b>Type 1 :</b></label>
                                        <%-- <textarea type="text" class="form-control type-no" rows="3" placeholder="Enter type"></textarea>--%>
                                        <textarea class="form-control type-no"></textarea>
                                    </div>
                                    <div class="col-md-5">
                                        <label><b>Minimum Service Commitment Period :</b></label>
                                        <%-- <textarea class="form-control type-details" rows="3"
                                            placeholder="Enter Minimum Service Commitment Period"></textarea>--%>
                                        <textarea class="form-control type-details"></textarea>
                                    </div>
                                    <div class="col-md-1 d-flex align-items-end">
                                        <button type="button" class="btn btn-danger btn-sm delete-type">X</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- Bottom Buttons -->
                        <div class="text-right">
                            <button type="button" class="btn btn-info" onclick="addtype()">+ Add Type</button>
                            <button type="button" id="btnTypeSaveAll" class="btn btn-primary">Submit</button>
                        </div>
                        <div class="card-body">
                            <table class="table" id="table_agreeType" style="width: 100%;">
                                <thead>
                                    <tr>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Version</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Version Date</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Agreement Type</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Minimum Service Commitment Period </th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added By</th>
                                        <th class="sort border-top ps-3">Added Date</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="popUp_editagrversioncontrol">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <!-- Header -->
                <div class="modal-header">
                    <h5 class="modal-title">
                        <span id="editagrheadercontrol_lbldetails" style="font-weight: 600; font-size: 18px;"></span>
                    </h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>

                <!-- Body -->
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6 mb-4">
                            <label><b>Clause # :</b></label>
                            <input type="text" id="editagrheadercontrol_clauseNo" class="form-control" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-6">
                            <label><b>Clause Details :</b></label>
                            <textarea type="text" id="editagrheadercontrol_clausedetails" class="form-control" style="height: 200px; width: 1100px;"></textarea>
                        </div>
                    </div>
                </div>

                <!-- Footer -->
                <div class="modal-footer">
                    <button type="button" class="btn btn-light btn-cancel" data-dismiss="modal">Cancel</button>
                    <button type="button" class="btn gradient-btn" onclick="return agrversioncontrol_btnSubmit();">Update</button>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
