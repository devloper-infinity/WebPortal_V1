<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="MasterData.aspx.cs" Inherits="WebPortal.Admin.MasterData" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
       <link rel="stylesheet" href="https://cdn.datatables.net/1.13.8/css/jquery.dataTables.min.css" />
    <link rel="stylesheet" href="https://cdn.datatables.net/fixedcolumns/4.3.0/css/fixedColumns.dataTables.min.css" />
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/fixedcolumns/4.3.0/js/dataTables.fixedColumns.min.js"></script>

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

        .dataTables_scrollBody {
            min-height: 100px !important;
            height: auto;
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
    <script>
        $(document).ready(function () {
            //md_BindMasterData();
            md_html = '';
            $.ajax({
                url: "MasterData.aspx/GetMasterData",
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                beforeSend: function () {
                    $("#load1").show();
                },
                success: function (data) {
                    try {
                        let result = data.d;

                        if (typeof result === "string") {
                            result = JSON.parse(result);
                        }

                        // If result is DataSet style
                        let response = result.Table || result.Data || result.Rows || result;

                        console.log("Final data:", response);
                        console.log("Rows:", response.length);

                        BuildDynamicDataTable(response);
                    }
                    catch (ex) {
                        console.log(ex);
                    }
                    finally {
                        $("#load1").hide();
                    }
                },
                error: function (error) {
                    $('#load1').hide();
                    alert('error; ' + eval(error));
                    alert('error; ' + error.responseText);
                }
            });
        });

        function BuildDynamicDataTable(data) {

            if (typeof data === "string") {
                data = JSON.parse(data);
            }

            if (data.d) {
                data = typeof data.d === "string" ? JSON.parse(data.d) : data.d;
            }

            if (data.Table) {
                data = data.Table;
            }

            if (!Array.isArray(data) || data.length === 0) {
                console.log("No data:", data);
                return;
            }

            if ($.fn.DataTable.isDataTable("#tblReport")) {
                $("#tblReport").DataTable().clear().destroy();
            }

            $("#tblReport thead").empty();
            $("#tblReport tbody").empty();

            let cols = Object.keys(data[0]);

            let topHeaders = [];
            let subHeaders = [];

            cols.forEach(function (col) {

                let group = "";
                let title = col;

                if (col.startsWith("AgreementVersion_")) {
                    group = "Agreement " + col.replace("AgreementVersion_", "");
                    title = "Version";
                }
                else if (col.startsWith("AgreementDate_")) {
                    group = "Agreement " + col.replace("AgreementDate_", "");
                    title = "Agreement Date";
                }
                else if (col.startsWith("AgreementExpiryDate_")) {
                    group = "Agreement " + col.replace("AgreementExpiryDate_", "");
                    title = "Expiry Date";
                }
                else if (col.startsWith("AgreementStampPaperNo_")) {
                    group = "Agreement " + col.replace("AgreementStampPaperNo_", "");
                    title = "Stamp Paper #";
                }
                else if (col.startsWith("AddendumVersion_")) {
                    group = "Addendum " + col.replace("AddendumVersion_", "");
                    title = "Version";
                }
                else if (col.startsWith("AddendumDate_")) {
                    group = "Addendum " + col.replace("AddendumDate_", "");
                    title = "Agreement Date";
                }
                else if (col.startsWith("AddendumExpiryDate_")) {
                    group = "Addendum " + col.replace("AddendumExpiryDate_", "");
                    title = "Expiry Date";
                }
                else if (col.startsWith("AddendumStampPaperNo_")) {
                    group = "Addendum " + col.replace("AddendumStampPaperNo_", "");
                    title = "Stamp Paper #";
                }
                else if (
                    col.startsWith("Agreement_") ||
                    col.startsWith("Addendum_")
                ) {
                    let parts = col.split("_");

                    let type = parts[0];      // Agreement / Addendum
                    let version = parts[1];   // 5 / 2_8_5 / 1_1

                    group = type + " " + version;

                    if (col.includes("NonSolicitationClauseNo"))
                        title = "Non Solicitation Clause";

                    else if (col.includes("NonSolicitationPenalty"))
                        title = "Non Solicitation Penalty";

                    else if (col.includes("MinimumCommitmentClauseNo"))
                        title = "Minimum Commitment Clause";

                    else if (col.includes("MinimumCommitmentPenalty"))
                        title = "Minimum Commitment Penalty";

                    else if (col.includes("ThreeMonthsNoticeClauseNo"))
                        title = "3 Months Notice Clause";

                    else if (col.includes("ThreeMonthsNoticePenalty"))
                        title = "3 Months Notice Penalty";
                }
                else if (col.startsWith("ClientList_")) {
                    group = "Client List";
                    title = col.replace("ClientList_", "").replaceAll("_", " ");
                }
                else if (col.startsWith("Pseudoname_")) {
                    group = "Pseudo Name";
                    title = col.replace("Pseudoname_", "").replaceAll("_", " ");
                }
                else if (col.startsWith("Undertaking_")) {
                    group = "Undertaking";
                    title = col.replace("Undertaking_", "").replaceAll("_", " ");
                }
                else if (col.startsWith("USVisa_")) {
                    group = "US Visa";
                    title = col.replace("USVisa_", "").replaceAll("_", " ");
                }

                topHeaders.push(group);
                subHeaders.push(title);
            });

            let row1 = "<tr>";
            let row2 = "<tr>";

            for (let i = 0; i < cols.length; i++) {

                if (topHeaders[i] === "") {
                    row1 += `<th rowspan="2">${subHeaders[i]}</th>`;
                }
                else {
                    let colspan = 1;

                    while (
                        i + colspan < cols.length &&
                        topHeaders[i + colspan] === topHeaders[i]
                    ) {
                        colspan++;
                    }

                    row1 += `<th colspan="${colspan}" style="text-align:center">${topHeaders[i]}</th>`;

                    for (let j = 0; j < colspan; j++) {
                        row2 += `<th>${subHeaders[i + j]}</th>`;
                    }

                    i += colspan - 1;
                }
            }

            row1 += "</tr>";
            row2 += "</tr>";

            $("#tblReport thead").html(row1 + row2);

            let dtColumns = cols.map(function (c) {
                return {
                    data: c,
                    defaultContent: ""
                };
            });

            $("#tblReport").DataTable({
                data: data,
                columns: dtColumns,
                scrollX: true,
                autoWidth: false,
                pageLength: 10,
                fixedColumns: {
                    left: 2
                }
            });
            console.log($.fn.dataTable.version);
            console.log($.fn.dataTable.FixedColumns?.version);
        }
    </script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script src="https://cdn.datatables.net/1.11.4/js/jquery.dataTables.min.js"></script>

<script src="https://cdn.datatables.net/fixedcolumns/4.0.1/js/dataTables.fixedColumns.min.js"></script>
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Master Data</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body" style="width: 100%; overflow: auto;">
                <table id="tblReport" class="display nowrap table-bordered" style="width: 100%">
                    <thead></thead>
                    <tbody></tbody>
                </table>
                <table class="table table-bordered" id="md_table" style="padding-top: 0px; font-size: 11px; width: 100%; display: none;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Sr. #</th>
                            <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">EmployeeID</th>
                            <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Code</th>
                            <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Name</th>
                            <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Salary</th>
                            <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Joining Date</th>
                            <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Date Of Birth</th>
                            <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Branch</th>
                            <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Department</th>
                            <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Designation</th>
                            <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Domain</th>
                            <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Subdomain</th>
                            <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Reporting Manager</th>
                            <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Domain Head</th>
                            <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Contact #</th>
                            <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Email Address</th>
                            <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Present Address</th>
                            <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Permanent Address</th>
                            <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">UAN</th>
                            <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">ESIC #</th>
                            <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Latest Login Date</th>
                            <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Current Status</th>
                            <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Productivity/Task</th>


                            <%--Agreement 2017--%>
                            <th class="sort border-top ps-3" style="text-align: center;" colspan="4">Agreement 2017</th>

                            <%--Agreement 2018--%>
                            <th class="sort border-top ps-3" style="text-align: center;" colspan="4">Agreement 2018</th>

                            <%--Agreement 2019--%>
                            <th class="sort border-top ps-3" style="text-align: center;" colspan="4">Agreement 2019</th>

                            <%--Agreement 1.1--%>
                            <th class="sort border-top ps-3" style="text-align: center;" colspan="4">Agreement 1.1</th>

                            <%--Agreement 2--%>
                            <th class="sort border-top ps-3" style="text-align: center;" colspan="4">Agreement 2.0</th>

                            <%--Agreement 2.8.5--%>
                            <th class="sort border-top ps-3" style="text-align: center;" colspan="11">Agreement 2.8.5</th>

                            <%--Agreement 2.9--%>
                            <th class="sort border-top ps-3" style="text-align: center;" colspan="11">Agreement 2.9</th>

                            <%--Agreement 3.0--%>
                            <th class="sort border-top ps-3" style="text-align: center;" colspan="11">Agreement 3.0</th>

                            <%--Add Agreement Details, clause and History details--%>
                            <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Add Agreement</th>

                            <%--View agreement history--%>
                            <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Agreement History</th>

                            <%--Add Agreement clause--%>
                            <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Add Clause</th>

                            <%--Addendum 1.0--%>
                            <th class="sort border-top ps-3" style="text-align: center;" colspan="10">Addendum 1.0</th>

                            <%--Addendum 2.0--%>
                            <th class="sort border-top ps-3" style="text-align: center;" colspan="10">Addendum 2.0</th>

                            <%--Addendum 2.5--%>
                            <th class="sort border-top ps-3" style="text-align: center;" colspan="10">Addendum 2.5</th>

                            <%--Add Addendum Details, clause and History details--%>
                            <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Add Addendum</th>

                            <%--Add Addendum clause--%>
                            <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Add Clause</th>

                            <%--Client List--%>
                            <th class="sort border-top ps-3" style="vertical-align: middle;" colspan="4">Client List</th>

                            <%--Pseudoname--%>
                            <th class="sort border-top ps-3" style="text-align: center;" colspan="5">Pseudoname</th>

                            <%--Pseudoname--%>
                            <th class="sort border-top ps-3" style="text-align: center;" colspan="5">Undertaking</th>

                            <%--File Tracker--%>
                            <th class="sort border-top ps-3" style="text-align: center;" colspan="2">File Tracker</th>

                            <%--US Visa--%>
                            <th class="sort border-top ps-3" style="text-align: center;" colspan="3">US Visa</th>

                            <%--Scanned Copy--%>
                            <th class="sort border-top ps-3" style="text-align: center;" colspan="2">Scanned Copy</th>

                        </tr>
                        <tr>


                            <%--Agreement 2017--%>
                            <th class="sort border-top ps-3" rowspan="2">Version</th>
                            <th class="sort border-top ps-3" rowspan="2">Agreement Date</th>
                            <th class="sort border-top ps-3" rowspan="2">Expiry Date</th>
                            <th class="sort border-top ps-3" rowspan="2">Stamp Paper #</th>

                            <%--Agreement 2018--%>
                            <th class="sort border-top ps-3" rowspan="2">Version</th>
                            <th class="sort border-top ps-3" rowspan="2">Agreement Date</th>
                            <th class="sort border-top ps-3" rowspan="2">Expiry Date</th>
                            <th class="sort border-top ps-3" rowspan="2">Stamp Paper #</th>

                            <%--Agreement 2019--%>
                            <th class="sort border-top ps-3" rowspan="2">Version</th>
                            <th class="sort border-top ps-3" rowspan="2">Agreement Date</th>
                            <th class="sort border-top ps-3" rowspan="2">Expiry Date</th>
                            <th class="sort border-top ps-3" rowspan="2">Stamp Paper #</th>

                            <%--Agreement 1.1--%>
                            <th class="sort border-top ps-3" rowspan="2">Version</th>
                            <th class="sort border-top ps-3" rowspan="2">Agreement Date</th>
                            <th class="sort border-top ps-3" rowspan="2">Expiry Date</th>
                            <th class="sort border-top ps-3" rowspan="2">Stamp Paper #</th>

                            <%--Agreement 2--%>
                            <th class="sort border-top ps-3" rowspan="2">Version</th>
                            <th class="sort border-top ps-3" rowspan="2">Agreement Date</th>
                            <th class="sort border-top ps-3" rowspan="2">Expiry Date</th>
                            <th class="sort border-top ps-3" rowspan="2">Stamp Paper #</th>

                            <%--Agreement 2.8.5--%>
                            <th class="sort border-top ps-3" rowspan="2">Version</th>
                            <th class="sort border-top ps-3" rowspan="2">Agreement Date</th>
                            <th class="sort border-top ps-3" rowspan="2">Expiry Date</th>
                            <th class="sort border-top ps-3" rowspan="2">Stamp Paper #</th>
                            <th class="sort border-top ps-3" colspan="2">Non Solicitation Clause/Non Compete Clause</th>
                            <th class="sort border-top ps-3" colspan="2">3 Months' Notice</th>
                            <th class="sort border-top ps-3" colspan="3">Minimum Commitment Service</th>

                            <%--Agreement 2.9--%>
                            <th class="sort border-top ps-3" rowspan="2">Version</th>
                            <th class="sort border-top ps-3" rowspan="2">Agreement Date</th>
                            <th class="sort border-top ps-3" rowspan="2">Expiry Date</th>
                            <th class="sort border-top ps-3" rowspan="2">Stamp Paper #</th>
                            <th class="sort border-top ps-3" colspan="2">Non Solicitation Clause/Non Compete Clause</th>
                            <th class="sort border-top ps-3" colspan="2">3 Months' Notice</th>
                            <th class="sort border-top ps-3" colspan="3">Minimum Commitment Service</th>

                            <%--Agreement 3.0--%>
                            <th class="sort border-top ps-3" rowspan="2">Version</th>
                            <th class="sort border-top ps-3" rowspan="2">Agreement Date</th>
                            <th class="sort border-top ps-3" rowspan="2">Expiry Date</th>
                            <th class="sort border-top ps-3" rowspan="2">Stamp Paper #</th>
                            <th class="sort border-top ps-3" colspan="2">Non Solicitation Clause/Non Compete Clause</th>
                            <th class="sort border-top ps-3" colspan="2">3 Months' Notice</th>
                            <th class="sort border-top ps-3" colspan="3">Minimum Commitment Service</th>

                            <%--Addendum 1.0--%>
                            <th class="sort border-top ps-3" rowspan="2">Version</th>
                            <th class="sort border-top ps-3" rowspan="2">Signed Date</th>
                            <th class="sort border-top ps-3" rowspan="2">Stamp Paper #</th>
                            <th class="sort border-top ps-3" colspan="2">Non Solicitation Clause/Non Compete Clause</th>
                            <th class="sort border-top ps-3" colspan="2">3 Months' Notice</th>
                            <th class="sort border-top ps-3" colspan="3">Minimum Commitment Service</th>

                            <%--Addendum 2.0--%>
                            <th class="sort border-top ps-3" rowspan="2">Version</th>
                            <th class="sort border-top ps-3" rowspan="2">Signed Date</th>
                            <th class="sort border-top ps-3" rowspan="2">Stamp Paper #</th>
                            <th class="sort border-top ps-3" colspan="2">Non Solicitation Clause/Non Compete Clause</th>
                            <th class="sort border-top ps-3" colspan="2">3 Months' Notice</th>
                            <th class="sort border-top ps-3" colspan="3">Minimum Commitment Service</th>

                            <%--Addendum 2.5--%>
                            <th class="sort border-top ps-3" rowspan="2">Version</th>
                            <th class="sort border-top ps-3" rowspan="2">Signed Date</th>
                            <th class="sort border-top ps-3" rowspan="2">Stamp Paper #</th>
                            <th class="sort border-top ps-3" colspan="2">Non Solicitation Clause/Non Compete Clause</th>
                            <th class="sort border-top ps-3" colspan="2">3 Months' Notice</th>
                            <th class="sort border-top ps-3" colspan="3">Minimum Commitment Service</th>

                            <%--Client List --%>
                            <th class="sort border-top ps-3" rowspan="2">Version</th>
                            <th class="sort border-top ps-3" rowspan="2">Status</th>
                            <th class="sort border-top ps-3" rowspan="2">Add Client List</th>
                            <th class="sort border-top ps-3" rowspan="2">Client List History</th>

                            <%--Pseudoname--%>
                            <th class="sort border-top ps-3" rowspan="2">Pseudoname</th>
                            <th class="sort border-top ps-3" rowspan="2">Agreement Status</th>
                            <th class="sort border-top ps-3" rowspan="2">Acknowledgement Date</th>
                            <th class="sort border-top ps-3" rowspan="2">Penalty for Breach - Pseudoname Undertaking</th>
                            <th class="sort border-top ps-3" rowspan="2">Add Pseudoname Details</th>

                            <%--Undertaking--%>
                            <th class="sort border-top ps-3" rowspan="2">Version</th>
                            <th class="sort border-top ps-3" rowspan="2">Signed Date</th>
                            <th class="sort border-top ps-3" rowspan="2">Stamp Paper #</th>
                            <th class="sort border-top ps-3" rowspan="2">Cost</th>
                            <th class="sort border-top ps-3" rowspan="2">Add Undertaking</th>

                            <%--File Tracker--%>
                            <th class="sort border-top ps-3" rowspan="2">File #</th>
                            <th class="sort border-top ps-3" rowspan="2">File Tracker</th>

                            <%--US Visa--%>
                            <th class="sort border-top ps-3" rowspan="2">Visa #</th>
                            <th class="sort border-top ps-3" rowspan="2">Valid Till</th>
                            <th class="sort border-top ps-3" rowspan="2">Update Visa #</th>

                            <%--US Visa--%>
                            <th class="sort border-top ps-3" rowspan="2">Is Scanned Copy Updated?</th>
                            <th class="sort border-top ps-3" rowspan="2">Update Scanned Copy</th>

                        </tr>
                        <tr>
                            <%--Agreement 2.8.5 clause Non-Solicitation--%>
                            <th class="sort border-top ps-3">Clause #</th>
                            <th class="sort border-top ps-3">Penalty for breaching clause</th>

                            <%--Agreement 2.8.5 clause 3month notice--%>
                            <th class="sort border-top ps-3">Clause #</th>
                            <th class="sort border-top ps-3">Penalty for breaching clause</th>

                            <%--Agreement 2.8.5 clause minimum commitment service--%>
                            <th class="sort border-top ps-3">Clause #</th>
                            <th class="sort border-top ps-3">Penalty for breaching clause</th>
                            <th class="sort border-top ps-3">Minimum service commitment upto (Years)</th>

                            <%--Agreement 2.9 clause Non-Solicitation--%>
                            <th class="sort border-top ps-3">Clause #</th>
                            <th class="sort border-top ps-3">Penalty for breaching clause</th>

                            <%--Agreement 2.9 clause 3month notice--%>
                            <th class="sort border-top ps-3">Clause #</th>
                            <th class="sort border-top ps-3">Penalty for breaching clause</th>

                            <%--Agreement 2.9 clause minimum commitment service--%>
                            <th class="sort border-top ps-3">Clause #</th>
                            <th class="sort border-top ps-3">Penalty for breaching clause</th>
                            <th class="sort border-top ps-3">Minimum service commitment upto (Years)</th>

                            <%--Agreement 3.0 clause Non-Solicitation--%>
                            <th class="sort border-top ps-3">Clause #</th>
                            <th class="sort border-top ps-3">Penalty for breaching clause</th>

                            <%--Agreement 3.0 clause 3month notice--%>
                            <th class="sort border-top ps-3">Clause #</th>
                            <th class="sort border-top ps-3">Penalty for breaching clause</th>

                            <%--Agreement 3.0 clause minimum commitment service--%>
                            <th class="sort border-top ps-3">Clause #</th>
                            <th class="sort border-top ps-3">Penalty for breaching clause</th>
                            <th class="sort border-top ps-3">Minimum service commitment upto (Years)</th>

                            <%--Addendum 1.0 clause Non-Solicitation--%>
                            <th class="sort border-top ps-3">Clause #</th>
                            <th class="sort border-top ps-3">Penalty for breaching clause</th>

                            <%--Addendum 1.0 clause 3month notice--%>
                            <th class="sort border-top ps-3">Clause #</th>
                            <th class="sort border-top ps-3">Penalty for breaching clause</th>

                            <%--Addendum 1.0 clause minimum commitment service--%>
                            <th class="sort border-top ps-3">Clause #</th>
                            <th class="sort border-top ps-3">Penalty for breaching clause</th>
                            <th class="sort border-top ps-3">Minimum service commitment upto (Years)</th>


                            <%--Addendum 2.0 clause Non-Solicitation--%>
                            <th class="sort border-top ps-3">Clause #</th>
                            <th class="sort border-top ps-3">Penalty for breaching clause</th>

                            <%--Addendum 2.0 clause 3month notice--%>
                            <th class="sort border-top ps-3">Clause #</th>
                            <th class="sort border-top ps-3">Penalty for breaching clause</th>

                            <%--Addendum 2.0 clause minimum commitment service--%>
                            <th class="sort border-top ps-3">Clause #</th>
                            <th class="sort border-top ps-3">Penalty for breaching clause</th>
                            <th class="sort border-top ps-3">Minimum service commitment upto (Years)</th>

                            <%--Addendum 2.5 clause Non-Solicitation--%>
                            <th class="sort border-top ps-3">Clause #</th>
                            <th class="sort border-top ps-3">Penalty for breaching clause</th>

                            <%--Addendum 2.5 clause 3month notice--%>
                            <th class="sort border-top ps-3">Clause #</th>
                            <th class="sort border-top ps-3">Penalty for breaching clause</th>

                            <%--Addendum 2.5 clause minimum commitment service--%>
                            <th class="sort border-top ps-3">Clause #</th>
                            <th class="sort border-top ps-3">Penalty for breaching clause</th>
                            <th class="sort border-top ps-3">Minimum service commitment upto (Years)</th>

                        </tr>


                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
        </div>
    </div>


    <%--Add Agreement Popup--%>
    <div class="modal fade" id="addagreement" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="addagreementLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addagreementLabel">Add Agreement - </h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table" style="width: 100%;">
                        <tr>
                            <td><b>No. of Years:</b></td>
                            <td>
                                <select id="md_addagg_years" name="md_addagg_years" class="form-control" style="width: 300px;" onchange="return getagreementexpirydate();">
                                    <option value="">Select</option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                </select>
                            </td>
                            <td><b>Agreement Date:</b></td>
                            <td>
                                <input type="date" id="md_agg_agreementdate" name="md_agg_agreementdate" max="2999-12-31" onkeydown="return false" class="form-control" style="width: 300px;" onchange="return getagreementexpirydate();" />
                            </td>
                        </tr>
                        <tr>
                            <td><b>Expiry Date:</b></td>
                            <td>
                                <input type="date" id="md_agg_expirydate" name="md_agg_expirydate" max="2999-12-31" onkeydown="return false" class="form-control" style="width: 300px;" />
                            </td>
                            <td><b>Stamp Papers Used:</b></td>
                            <td>
                                <select id="md_addagg_stamppaperused" name="md_addagg_stamppaperused" class="form-control" style="width: 300px;">
                                    <option value="">Select</option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Stamp Paper #:</b></td>
                            <td>
                                <input type="text" id="md_addagg_stamppaperno" name="md_addagg_stamppaperno" class="form-control" style="width: 300px;" />
                            </td>
                            <td><b>File #:</b></td>
                            <td>
                                <input type="text" id="md_addagg_fileno" name="md_addagg_fileno" class="form-control" style="width: 300px;" />
                            </td>
                        </tr>
                        <tr>
                            <td><b>Cost:</b></td>
                            <td>
                                <input type="number" id="md_addagg_stamppapercost" name="md_addagg_stamppapercost" class="form-control" style="width: 300px;" />
                            </td>
                            <td><b>Document Version:</b></td>
                            <td>
                                <select id="md_addagg_version" name="md_addagg_version" class="form-control" style="width: 300px;">
                                    <option value="">Select</option>
                                    <option value="2019">2019</option>
                                    <option value="1.1">1.1</option>
                                    <option value="2">2.0</option>
                                    <option value="2.8.5">2.8.5</option>
                                    <option value="2.9">2.9</option>
                                    <option value="3">3.0</option>
                                    <option value="4">4.0</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Acknowledgement Date:</b></td>
                            <td>
                                <input type="date" id="md_agg_ackdate" name="md_agg_ackdate" max="2999-12-31" onkeydown="return false" class="form-control" style="width: 300px;" />
                            </td>
                            <td><b>Remark:</b></td>
                            <td>
                                <textarea id="md_addagg_remark" name="md_addagg_remark" class="form-control" style="width: 300px;"></textarea>
                            </td>
                        </tr>
                    </table>
                    <label id="md_addagreement_employeeid" class="bootstrap-switch-label" style="display: none;"></label>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" onclick="return md_addagg_submit();">Submit</button>
                </div>
            </div>
        </div>
    </div>


    <%--Show Agreement History--%>
    <div class="modal fade" id="agreementhistory" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="agreementhistoryLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="agreementhistoryLabel">Agreement History - </h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table table-bordered" id="md_agr_history_table" style="padding-top: 0px; font-size: 11px; width: 100%;">
                        <thead>
                            <tr>
                                <th class="sort border-top ps-3">Sr. #</th>
                                <th class="sort border-top ps-3">Type</th>
                                <th class="sort border-top ps-3">Duration</th>
                                <th class="sort border-top ps-3">Papers Used</th>
                                <th class="sort border-top ps-3">Stamp Paper #</th>
                                <th class="sort border-top ps-3">Agreement Date</th>
                                <th class="sort border-top ps-3">Expiry Date</th>
                                <th class="sort border-top ps-3">Version</th>
                                <th class="sort border-top ps-3">File #</th>
                                <th class="sort border-top ps-3">Added By</th>
                                <th class="sort border-top ps-3">Added Date</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                    <label id="md_agreementhistory_employeeid" class="bootstrap-switch-label" style="display: none;"></label>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <%--Add agreement clause--%>
    <div class="modal fade" id="agreementclause" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="agreementclauseLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="agreementclauseLabel">Add Agreement Clause - </h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table" style="width: 100%;">
                        <tr>
                            <td><b>Agreement Version:</b></td>
                            <td>
                                <select id="md_agrclause_version" name="md_agrclause_version" class="form-control" style="width: 300px;">
                                    <option value="">Select</option>
                                    <option value="2.8.5">2.8.5</option>
                                    <option value="2.9">2.9</option>
                                    <option value="3">3.0</option>
                                </select>
                            </td>
                            <td><b>Clause</b></td>
                            <td>
                                <select id="md_agrclause_clause" name="md_agrclause_clause" class="form-control" style="width: 300px;">
                                    <option value="">Select</option>
                                    <option value="Non Solicitation Clause/Non Compete Clause">Non Solicitation Clause/Non Compete Clause</option>
                                    <option value="3 Months Notice">3 Months Notice</option>
                                    <option value="Minimum Commitment Service">Minimum Commitment Service</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Clause #:</b></td>
                            <td>
                                <input type="text" id="md_agrclause_clauseno" name="md_agrclause_clauseno" class="form-control" style="width: 300px;" />
                            </td>
                            <td><b>Penalty for breaching clause:</b></td>
                            <td>
                                <textarea id="md_agrclause_penalty" name="md_agrclause_penalty" class="form-control" style="width: 300px;"></textarea>
                            </td>
                        </tr>
                    </table>
                    <label id="md_agreementclause_employeeid" class="bootstrap-switch-label" style="display: none;"></label>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" onclick="return md_agrclause_submit();">Submit</button>
                </div>
            </div>
        </div>
    </div>

    <%--Add Addendum Popup--%>
    <div class="modal fade" id="addaddendum" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="addaddendumLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addaddendumLabel">Add Addendum - </h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table" style="width: 100%;">
                        <tr>
                            <td><b>Stamp Paper #:</b></td>
                            <td>
                                <input type="text" id="md_addadm_stamppaperno" name="md_addadm_stamppaperno" class="form-control" style="width: 300px;" />
                            </td>
                            <td><b>Document Version:</b></td>
                            <td>
                                <select id="md_addadm_version" name="md_addadm_version" class="form-control" style="width: 300px;">
                                    <option value="">Select</option>
                                    <option value="1.5">1.5</option>
                                    <option value="2.0">2.0</option>
                                    <option value="2.5">2.5</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Signed Date:</b></td>
                            <td>
                                <input type="date" id="md_addadm_signeddate" name="md_addadm_signeddate" max="2999-12-31" onkeydown="return false" class="form-control" style="width: 300px;" onchange="return getagreementexpirydate();" />
                            </td>
                            <td><b>Acknowledgement Date:</b></td>
                            <td>
                                <input type="date" id="md_addadm_ackdate" name="md_addadm_ackdate" max="2999-12-31" onkeydown="return false" class="form-control" style="width: 300px;" onchange="return getagreementexpirydate();" />
                            </td>
                        </tr>
                        <tr>
                            <td><b>Cost:</b></td>
                            <td>
                                <input type="number" id="md_addadm_cost" name="md_addadm_cost" class="form-control" style="width: 300px;" />
                            </td>
                            <td><b>Remark:</b></td>
                            <td>
                                <textarea id="md_addadm_remark" name="md_addadm_remark" class="form-control" style="width: 300px;"></textarea>
                            </td>
                        </tr>
                    </table>
                    <label id="md_addaddendum_employeeid" class="bootstrap-switch-label" style="display: none;"></label>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" onclick="return md_addadm_submit();">Submit</button>
                </div>
            </div>
        </div>
    </div>

    <%--Add Addendum clause--%>
    <div class="modal fade" id="addaddendumclause" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="addaddendumclauseLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addaddendumclauseLabel">Add Addendum Clause - </h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <label id="md_addaddendumclause_employeeid" class="bootstrap-switch-label" style="display: none;"></label>
                    <table class="table" style="width: 100%;">
                        <tr>
                            <td><b>Addendum Version:</b></td>
                            <td>
                                <select id="md_addmclause_version" name="md_addmclause_version" class="form-control" style="width: 300px;">
                                    <option value="">Select</option>
                                    <option value="2.8.5">2.8.5</option>
                                    <option value="2.9">2.9</option>
                                    <option value="3">3.0</option>
                                </select>
                            </td>
                            <td><b>Clause</b></td>
                            <td>
                                <select id="md_addmclause_clause" name="md_addmclause_clause" class="form-control" style="width: 300px;">
                                    <option value="">Select</option>
                                    <option value="Non Solicitation Clause/Non Compete Clause">Non Solicitation Clause/Non Compete Clause</option>
                                    <option value="3 Months Notice">3 Months Notice</option>
                                    <option value="Minimum Commitment Service">Minimum Commitment Service</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Clause #:</b></td>
                            <td>
                                <input type="text" id="md_addmclause_clauseno" name="md_addmclause_clauseno" class="form-control" style="width: 300px;" />
                            </td>
                            <td><b>Penalty for breaching clause:</b></td>
                            <td>
                                <input type="text" id="md_addmclause_penalty" name="md_addmclause_penalty" class="form-control" style="width: 300px;" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" onclick="return md_addmclause_submit();">Submit</button>
                </div>
            </div>
        </div>
    </div>

    <%--Add Client List Popup--%>
    <div class="modal fade" id="addclientlist" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="addclientlistLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addclientlistLabel">Add Client List - </h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <label id="md_addclientlist_employeeid" class="bootstrap-switch-label" style="display: none;"></label>
                    <table class="table">
                        <tr>
                            <td>
                                <b>Signed Date :</b>
                            </td>
                            <td>
                                <input type="date" id="md_clilst_signdate" name="md_clilst_signdate" max="2999-12-31" onkeydown="return false" class="form-control" style="width: 300px;" />
                            </td>
                            <td align="left"><b>Document Version:</b>
                            </td>
                            <td>
                                <input type="text" id="md_clilst_version" name="md_clilst_version" class="form-control" style="width: 300px;" />
                                <%-- <select id="md_clilst_version" name="md_clilst_version" class="form-control" style="width: 300px;">
                                    <option value="">Select</option>
                                    <option value="1.5">1.5</option>
                                    <option value="2.0">2.0</option>
                                    <option value="2.5">2.5</option>
                                </select>--%>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Remark:</b></td>
                            <td colspan="3">
                                <textarea id="md_clilst_remark" name="md_clilst_remark" class="form-control" style="width: 300px;"></textarea>
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" onclick="return md_clilst_submit();">Submit</button>
                </div>
            </div>
        </div>
    </div>

    <%--Show Client List History--%>
    <div class="modal fade" id="clientlisthistory" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="clientlisthistoryLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="clientlisthistoryLabel">Client List History - </h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <label id="md_clientlisthistory_employeeid" class="bootstrap-switch-label" style="display: none;"></label>
                    <table class="table table-bordered" id="md_clientlist_history_table" style="padding-top: 0px; font-size: 11px; width: 100%;">
                        <thead>
                            <tr>
                                <th class="sort border-top ps-3">Sr. #</th>
                                <th class="sort border-top ps-3">Type</th>
                                <th class="sort border-top ps-3">Signed Date</th>
                                <th class="sort border-top ps-3">Version</th>
                                <th class="sort border-top ps-3">Remark</th>
                                <th class="sort border-top ps-3">Added By</th>
                                <th class="sort border-top ps-3">Added Date</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <%--Add Pseudoname Popup--%>
    <div class="modal fade" id="addpseudoname" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="addpseudonameLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addpseudonameLabel">Add Pseudoname - </h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <label id="md_addpseudoname_employeeid" class="bootstrap-switch-label" style="display: none;"></label>
                    <table class="table">
                        <tr>
                            <td>
                                <b>Acknowledgement Date :</b>
                            </td>
                            <td>
                                <input type="date" id="md_addpseudoname_ackdate" name="md_addpseudoname_ackdate" max="2999-12-31" onkeydown="return false" class="form-control" style="width: 300px;" />
                            </td>
                            <td><b>Penalty for breaching clause:</b></td>
                            <td>
                                <input type="text" id="md_addpseudoname_penalty" name="md_addpseudoname_penalty" class="form-control" style="width: 300px;" />
                            </td>
                        </tr>
                        <tr>
                            <td><b>Remark:</b></td>
                            <td>
                                <textarea id="md_addpseudoname_remark" name="md_addpseudoname_remark" class="form-control" style="width: 300px;"></textarea>
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" onclick="return md_addpseudoname_submit();">Submit</button>
                </div>
            </div>
        </div>
    </div>

    <%--Add Undertaking Popup--%>
    <div class="modal fade" id="addundertaking" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="addundertakingLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addundertakingLabel">Add Undertaking - </h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <label id="md_addundertaking_employeeid" class="bootstrap-switch-label" style="display: none;"></label>
                    <table class="table">
                        <tr>
                            <td>
                                <b>Signed Date :</b>
                            </td>
                            <td>
                                <input type="date" id="md_addundertaking_signdate" name="md_addundertaking_signdate" max="2999-12-31" onkeydown="return false" class="form-control" style="width: 300px;" />
                            </td>
                            <td><b>Stamp Paper # :</b></td>
                            <td>
                                <input type="text" id="md_addundertaking_stampno" name="md_addundertaking_stampno" class="form-control" style="width: 300px;" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <b>Document Version:</b>
                            </td>
                            <td>
                                <select id="md_addundertaking_version" name="md_addundertaking_version" class="form-control" style="width: 300px;">
                                    <option value="">Select</option>
                                    <option value="1.5">1.5</option>
                                    <option value="2.0">2.0</option>
                                    <option value="2.5">2.5</option>
                                </select>
                            </td>
                            <td><b>Cost :</b></td>
                            <td>
                                <input type="text" id="md_addundertaking_cost" name="md_addundertaking_cost" class="form-control" style="width: 300px;" />
                            </td>
                        </tr>
                        <tr>
                            <td><b>Remark:</b></td>
                            <td>
                                <textarea id="md_addundertaking_remark" name="md_addundertaking_remark" class="form-control" style="width: 300px;"></textarea>
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" onclick="return md_addundertaking_submit();">Submit</button>
                </div>
            </div>
        </div>
    </div>

    <%--File Tracker Popup--%>
    <div class="modal fade" id="filetracker" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="filetrackerLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="filetrackerLabel">File Tracker - </h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <label id="md_filetracker_employeeid" class="bootstrap-switch-label" style="display: none;"></label>
                    <table class="table">
                        <tr>
                            <td><b>File #:</b></td>
                            <td>
                                <input type="text" id="md_filetracker_fileNo" name="md_filetracker_fileNo" class="form-control" style="width: 300px;" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" onclick="return md_filetracker_submit();">Submit</button>
                </div>
            </div>
        </div>
    </div>

    <%--US Visa Popup--%>
    <div class="modal fade" id="usvisa" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="usvisaLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="usvisaLabel">US Visa - </h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <label id="md_usvisa_employeeid" class="bootstrap-switch-label" style="display: none;"></label>
                    <table class="table">
                        <tr>
                            <td><b>US Visa #:</b></td>
                            <td>
                                <input type="text" id="md_usvisano" name="md_usvisano" class="form-control" style="width: 300px;" />
                            </td>
                            <td><b>Valid Till:</b></td>
                            <td>
                                <input type="date" id="md_usvisa_validdate" name="md_usvisa_validdate" max="2999-12-31" onkeydown="return false" class="form-control" style="width: 300px;" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" onclick="return md_usvisa_submit();">Submit</button>
                </div>
            </div>
        </div>
    </div>

    <%--US ScannedCopy Popup--%>
    <div class="modal fade" id="scannedcopy" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="scannedcopyLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="scannedcopyLabel">Scanned Copy - </h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <label id="md_scannedcopy_employeeid" class="bootstrap-switch-label" style="display: none;"></label>
                    <table class="table">
                        <tr>
                            <td><b>Scanned Copy?:</b></td>
                            <td>
                                <select id="md_scannedcopy_scancopy" name="md_scannedcopy_scancopy" class="form-control" style="width: 300px;">
                                    <option value="">Select</option>
                                    <option value="Yes">Yes</option>
                                    <option value="No">No</option>
                                </select>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" onclick="return md_scannedcopy_submit();">Submit</button>
                </div>
            </div>
        </div>
    </div>

    <%--Message Popup--%>
    <div class="modal fade" id="md_dverror" data-backdrop="static" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="md_errmsg"></h6>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="md_btnMessage" onclick="return md_Message();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>
