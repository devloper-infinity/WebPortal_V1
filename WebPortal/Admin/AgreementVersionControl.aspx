<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AgreementVersionControl.aspx.cs" Inherits="WebPortal.Admin.AgreementVersionControl" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" />

    <style>
    :root {
        --avc-primary: #2457e6;
        --avc-primary-dark: #173bb8;
        --avc-cyan: #25bfd4;
        --avc-success: #16a34a;
        --avc-danger: #ef4444;
        --avc-bg: #f4f7fb;
        --avc-card: #ffffff;
        --avc-text: #172033;
        --avc-muted: #667085;
        --avc-border: #d9e2ef;
        --avc-soft: #eef4ff;
        --avc-shadow: 0 18px 45px rgba(15, 23, 42, .09);
        --avc-radius: 22px;
    }

    .loading {
        display: none;
        position: fixed;
        top: 350px;
        left: 50%;
        margin-top: -96px;
        margin-left: -96px;
        opacity: .85;
        border-radius: 25px;
        width: 192px;
        height: 192px;
        z-index: 99999;
        text-align: center;
    }

    .agreement-page {
      
        background: var(--avc-bg);
        min-height: calc(100vh - 80px);
    }

    .modern-header-wrap {
        margin-bottom: 18px;
    }

    .modern-page-hero {
        position: relative;
        overflow: hidden;
        display: flex;
        align-items: center;
        gap: 18px;
        padding: 10px 24px;
        border-radius: 15px;
        color: #fff;
        background:
            radial-gradient(circle at top right, rgba(37, 191, 212, .65), transparent 34%),
            linear-gradient(135deg, #172554 0%, #2457e6 52%, #23bfd5 100%);
        box-shadow: 0 22px 45px rgba(36, 87, 230, .22);
    }

    .modern-page-hero:before {
        content: "";
        position: absolute;
        inset: -80px auto auto -80px;
        width: 210px;
        height: 210px;
        border-radius: 50%;
        background: rgba(255,255,255,.14);
    }

    .modern-page-icon {
        position: relative;
        z-index: 1;
        width: 50px;
        height: 50px;
        border-radius: 15px;
        display: flex;
        align-items: center;
        justify-content: center;
        flex-shrink: 0;
        background: rgba(255,255,255,.18);
        border: 1px solid rgba(255,255,255,.28);
        box-shadow: inset 0 1px 0 rgba(255,255,255,.3), 0 14px 25px rgba(0,0,0,.16);
        backdrop-filter: blur(8px);
    }

    .modern-page-icon i {
        display: block;
        line-height: 1;
        font-size: 36px;
        color: #fff;
    }

    .modern-page-copy {
        position: relative;
        z-index: 1;
        flex: 1;
        min-width: 0;
        padding:3px;
    }

    .modern-page-title {
        margin: 0;
        font-size: 22px;
        line-height: 1.2;
        font-weight: 800;
        letter-spacing: -.4px;
    }

    .modern-page-subtitle {
        margin: 7px 0 0;
        color: rgba(255,255,255,.82);
        font-size: 14px;
        font-weight: 500;
    }

    .hero-actions {
        position: relative;
        z-index: 1;
        display: flex;
        align-items: center;
        gap: 10px;
        flex-wrap: wrap;
        justify-content: flex-end;
    }

    .hero-chip,
    .hero-report-link {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        border-radius: 999px;
        padding: 9px 14px;
        font-size: 12px;
        font-weight: 800;
        color: #fff;
        background: rgba(255,255,255,.16);
        border: 1px solid rgba(255,255,255,.25);
        text-decoration: none !important;
        white-space: nowrap;
    }

    .hero-report-link:hover {
        color: #fff;
        background: rgba(255,255,255,.24);
        transform: translateY(-1px);
    }

    .modern-card {
        border: 0;
        border-radius: var(--avc-radius);
        overflow: hidden;
        background: var(--avc-card);
        box-shadow: var(--avc-shadow);
    }

    .modern-card .card-header {
        padding: 14px 16px 0 !important;
        background: #fff;
        border-bottom: 1px solid var(--avc-border);
    }

    .modern-card .card-body {
        padding: 20px;
    }

    .nav-tabs {
        border: 0;
        gap: 8px;
    }

    .nav-tabs .nav-link {
        border: 0 !important;
        border-radius: 14px 14px 0 0;
        padding: 12px 18px;
        color: var(--avc-muted);
        font-weight: 800;
        background: #f3f6fb;
    }

    .nav-tabs .nav-link.active {
        color: var(--avc-primary);
        background: #fff;
        box-shadow: 0 -2px 0 var(--avc-primary) inset;
    }

    .modern-section {
        border: 1px solid var(--avc-border);
        border-radius: 20px;
        padding: 18px;
        background: linear-gradient(180deg, #fff, #fbfdff);
        margin-bottom: 18px;
    }

    .section-title {
        display: flex;
        align-items: center;
        gap: 10px;
        margin: 0 0 16px;
        font-size: 16px;
        font-weight: 800;
        color: var(--avc-text);
    }

    .section-title i {
        width: 34px;
        height: 34px;
        border-radius: 12px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        color: #fff;
        background: linear-gradient(135deg, var(--avc-primary), var(--avc-cyan));
    }

    .modern-form-row {
        align-items: end;
        row-gap: 14px;
    }

    .modern-label,
    .agreement-page label {
        color: #344054;
        font-size: 12px;
        font-weight: 800;
        margin-bottom: 7px;
    }

    .agreement-page .form-control {
        border: 1px solid var(--avc-border);
        border-radius: 13px;
        min-height: 42px;
        color: var(--avc-text);
        box-shadow: none;
        font-size: 13px;
    }

    .agreement-page textarea.form-control {
        min-height: 92px;
        resize: vertical;
    }

    .agreement-page .form-control:focus {
        border-color: var(--avc-primary);
        box-shadow: 0 0 0 4px rgba(36, 87, 230, .11);
    }

    .clause-row,
    .type-row {
        border: 1px solid var(--avc-border) !important;
        border-radius: 18px !important;
        background: #fff;
        box-shadow: 0 10px 22px rgba(15, 23, 42, .04);
    }

    .btn {
        border-radius: 12px !important;
        font-weight: 800 !important;
        font-size: 13px !important;
        padding: 9px 15px !important;
        border: 0 !important;
    }

    .btn-info,
    .btn-primary,
    .gradient-btn {
        color: #fff !important;
        background: linear-gradient(135deg, var(--avc-primary), var(--avc-cyan)) !important;
        box-shadow: 0 10px 20px rgba(36, 87, 230, .18);
    }

    .btn-danger {
        color: #fff !important;
        background: linear-gradient(135deg, #ef4444, #f97316) !important;
        min-width: 38px;
    }

    .btn-light,
    .btn-cancel {
        color: #344054 !important;
        background: #eef2f7 !important;
    }

    .table-card {
        margin-top: 20px;
        padding: 16px;
        border: 1px solid var(--avc-border);
        border-radius: 20px;
        background: #fff;
    }

    .table-card .table {
        width: 100% !important;
        border-collapse: separate !important;
        border-spacing: 0;
        margin-bottom: 0 !important;
    }

    .table.dataTable thead th,
    table.dataTable thead th {
        font-size: 12px;
        font-weight: 800;
        padding: 12px 14px !important;
        border: 0 !important;
        white-space: nowrap;
    }

    .table.dataTable thead th:first-child {
        border-top-left-radius: 14px;
    }

    .table.dataTable thead th:last-child {
        border-top-right-radius: 14px;
    }

    .table.dataTable tbody td {
        padding: 11px 14px !important;
        border-bottom: 1px solid #edf1f7 !important;
        color: #344054;
        font-size: 12px;
        background: #fff !important;
        vertical-align: top;
    }

    .table.dataTable tbody tr:hover td {
        background: var(--avc-soft) !important;
    }

    .dataTables_wrapper .dataTables_length,
    .dataTables_wrapper .dataTables_filter {
        margin-bottom: 12px;
        color: var(--avc-muted);
        font-size: 12px;
        font-weight: 700;
    }

    .dataTables_wrapper .dataTables_filter input,
    .dataTables_wrapper .dataTables_length select {
        border: 1px solid var(--avc-border);
        border-radius: 10px;
        padding: 6px 9px;
        outline: none;
    }

    .dataTables_paginate {
        float: left !important;
        margin-top: 12px !important;
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
        box-shadow: none;
        background: linear-gradient(135deg, #16a34a, #22c55e) !important;
        border: 0;
        font-weight: bold;
    }

    .modal-content {
        border: 0;
        border-radius: 22px;
        overflow: hidden;
        box-shadow: 0 24px 60px rgba(15, 23, 42, .18);
    }

    .modal-header {
        color: #fff;
        background: linear-gradient(135deg, #172554, #2457e6);
        border: 0;
    }

    .modal-header .close {
        color: #fff;
        opacity: 1;
    }

    .modal-body,
    .modal-footer {
        background: #fbfdff;
    }

    @media (max-width: 768px) {
        .modern-page-hero {
            align-items: flex-start;
            flex-direction: column;
            padding: 20px;
        }
        .hero-actions {
            justify-content: flex-start;
        }
        .modern-page-title {
            font-size: 22px;
        }
    }
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

    <div class="agreement-page">
        <div class="modern-header-wrap">
            <div class="modern-page-hero">
                <div class="modern-page-icon">
                    <i class="bi bi-file-earmark-check-fill"></i>
                </div>
                <div class="modern-page-copy">
                    <h1 class="modern-page-title">Agreement Version Control</h1>
                    <p class="modern-page-subtitle">Create, track and review agreement clauses and agreement type history.</p>
                </div>
                <div class="hero-actions">
                    <span class="hero-chip"><i class="bi bi-shield-check"></i> Controlled Agreement Records</span>
                    <a href="AgreementVersionsHistoryReport.aspx" class="hero-report-link"><i class="bi bi-box-arrow-up-right"></i> Version Report</a>
                </div>
            </div>
        </div>

        <div class="col-lg-12 p-0">
            <div class="card modern-card">
            <div class="card-header p-0 pt-1">
                <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist" style="font-weight: bold;">
                    <li class="nav-item">
                        <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true"><i class="bi bi-clock-history"></i> Version History</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" id="custom-tabs-one-excel-tab" data-toggle="pill" href="#custom-tabs-one-excel" role="tab" aria-controls="custom-tabs-one-excel" aria-selected="false"><i class="bi bi-tags-fill"></i> Type History</a>
                    </li>
                </ul>
            </div>
            <div class="card-body">
                <div class="tab-content" id="custom-tabs-one-tabContent">
                    <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                        <%--<div class="card-body"></div>--%>

                        <div class="modern-section">
                            <h5 class="section-title"><i class="bi bi-file-earmark-text-fill"></i> Version Details</h5>
                            <div class="row mb-4 modern-form-row">


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
                        </div>

                        <!-- Clause Section -->
                        <div class="modern-section">
                        <h5 class="section-title"><i class="bi bi-list-check"></i> Clauses</h5>
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

                        <div class="modern-section">
                            <h5 class="section-title"><i class="bi bi-file-earmark-text-fill"></i> Type Version Details</h5>
                        <div class="row mb-4 modern-form-row">
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
                        </div>
                        <!-- Type Section -->
                        <div class="modern-section">
                        <h5 class="section-title"><i class="bi bi-tags-fill"></i> Types</h5>
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
                            <button type="button" class="btn btn-info" onclick="addtype()"><i class="bi bi-plus-circle"></i> Add Type</button>
                            <button type="button" id="btnTypeSaveAll" class="btn btn-primary"><i class="bi bi-send-check"></i> Submit</button>
                        </div>
                        </div>
                        <div class="table-card">
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
