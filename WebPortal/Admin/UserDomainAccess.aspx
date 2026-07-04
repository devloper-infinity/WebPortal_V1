<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="UserDomainAccess.aspx.cs" Inherits="WebPortal.Admin.UserDomainAccess" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .erp-wrapper {
            padding: 24px;
            background: #f5f7fb;
        }

        .erp-hero {
            background: linear-gradient(135deg, #182334, #2d3a4d);
            color: #fff;
            padding: 22px 26px;
            border-radius: 12px;
            margin-bottom: 18px;
            box-shadow: 0 8px 22px rgba(15, 23, 42, .18);
        }

            .erp-hero h3 {
                margin: 0;
                font-size: 26px;
                font-weight: 700;
            }

            .erp-hero small {
                color: #e5e7eb;
            }

        .erp-panel {
            background: #fff;
            border-radius: 14px;
            padding: 24px 18px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, .08);
            margin-bottom: 18px;
        }

        .erp-label {
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 8px;
            display: block;
        }

        .form-control {
            height: 38px;
            border-radius: 9px;
            border: 1px solid #cbd5e1;
        }

        .btn-primary {
            height: 42px;
            border-radius: 10px;
            border: none;
            font-weight: 700;
            background: linear-gradient(135deg, #14b8a6, #5eead4);
            box-shadow: 0 10px 20px rgba(20, 184, 166, .25);
        }

        .table-wrapper {
            background: #fff;
            border-radius: 14px;
            padding: 14px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, .08);
        }

        #tblAccess thead th {
            background: #eef6ff;
            color: #111827;
            font-weight: 700;
            border-bottom: 1px solid #bfdbfe;
        }

        #tblAccess tbody td {
            vertical-align: middle;
        }

        .action-icon {
            width: 22px;
            height: 22px;
            cursor: pointer;
            transition: .2s;
        }

            .action-icon:hover {
                transform: scale(1.12);
                opacity: .75;
            }

        /* Multi select dropdown */
        .multi-select {
            position: relative;
            width: 100%;
        }

        .multi-select-btn {
            width: 100%;
            height: 38px;
            background: #fff;
            border: 1px solid #cbd5e1;
            border-radius: 9px;
            padding: 8px 12px;
            text-align: left;
            color: #111827;
            font-size: 13px;
        }

            .multi-select-btn .arrow {
                float: right;
                font-size: 11px;
                margin-top: 2px;
            }

        .multi-select-menu {
            display: none;
            position: absolute;
            width: 100%;
            max-height: 280px;
            overflow-y: auto;
            background: #fff;
            border: 1px solid #cbd5e1;
            border-radius: 10px;
            margin-top: 6px;
            z-index: 9999;
            padding: 8px;
            box-shadow: 0 12px 26px rgba(15, 23, 42, .16);
        }

        .multi-select-search input {
            width: 100%;
            height: 34px;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            padding: 6px 10px;
            margin-bottom: 8px;
        }

        .multi-select-item {
            display: block;
            padding: 7px 9px;
            border-radius: 7px;
            font-size: 13px;
            cursor: pointer;
            margin-bottom: 2px;
        }

            .multi-select-item:hover {
                background: #f1f5f9;
            }

            .multi-select-item input {
                margin-right: 8px;
            }

        .select-all {
            font-weight: 700;
            background: #f8fafc;
        }

        .table-wrapper {
            position: relative;
            background: #fff;
            border-radius: 10px;
            padding: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,.08);
        }

        .grid-loader {
            display: none;
            position: absolute;
            inset: 0;
            background: rgba(255,255,255,.75);
            z-index: 20;
            align-items: center;
            justify-content: center;
            font-weight: 600;
        }

        table.dataTable thead th {
            white-space: nowrap;
        }

        table.dataTable tbody td {
            white-space: nowrap;
            vertical-align: middle;
        }

        .domain-box {
            height: 180px;
            overflow-y: auto;
            border: 1px solid #ced4da;
            border-radius: 6px;
            padding: 10px;
            background: #fff;
        }

        .domain-item {
            display: block;
            padding: 5px 8px;
            margin-bottom: 4px;
            border-radius: 4px;
            cursor: pointer;
        }

            .domain-item:hover {
                background: #f1f5f9;
            }

            .domain-item input {
                margin-right: 8px;
            }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="erp-wrapper">

        <div class="erp-hero">
            <h3>User Domain Access Master</h3>
            <small>Admin / Masters / User Domain Access</small>
        </div>

        <div class="erp-panel">
            <div class="row">

                <div class="col-md-5">
                    <label class="erp-label">Select User</label>
                    <select id="ddlEmployee" class="form-control"></select>
                </div>

                <div class="col-md-5">
                    <label class="erp-label">Select Domains</label>

                    <div class="multi-select">
                        <button type="button" id="btnDomainDropdown" class="multi-select-btn">
                            Select Domains
           
                            <span class="arrow">▼</span>
                        </button>

                        <div id="domainDropdown" class="multi-select-menu">
                            <div class="multi-select-search">
                                <input type="text" id="txtDomainSearch" placeholder="Search domain..." />
                            </div>

                            <label class="multi-select-item select-all">
                                <input type="checkbox" id="chkAllDomains" />
                                Select All
           
                            </label>

                            <div id="domainList"></div>
                        </div>
                    </div>
                </div>

                <div class="col-md-2">
                    <label class="erp-label">&nbsp;</label>
                    <button type="button" id="btnSave" class="btn btn-primary btn-block">
                        Assign
                   
                    </button>
                </div>

            </div>
        </div>

        <div class="table-wrapper">
            <div class="grid-loader" id="gridLoader">Loading...</div>

            <table id="tblAccess" class="display nowrap table table-bordered table-striped" style="width: 100%">
                <thead>
                    <tr>
                        <th>Action</th>
                        <th>Employee Code</th>
                        <th>Employee Name</th>
                        <th>Domain</th>
                        <th>Assigned Date</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>

    </div>

    <script>
        var accessTable = null;

        $(document).ready(function () {
            bindEmployees();
            bindDomains();

            accessTable = $("#tblAccess").DataTable({
                scrollX: true,
                pageLength: 25,
                ordering: true,
                destroy: true
            });

            $("#ddlEmployee").change(function () {
                bindAssignedDomains();
            });

            $("#btnSave").click(function () {
                saveAccess();
            });
        });

        function showLoader() {
            $("#gridLoader").css("display", "flex");
        }

        function hideLoader() {
            $("#gridLoader").hide();
        }

        function ajaxPost(url, data, successCallback) {
            $.ajax({
                type: "POST",
                url: url,
                data: JSON.stringify(data || {}),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: successCallback,
                error: function (xhr) {
                    alert("Error: " + xhr.responseText);
                }
            });
        }

        function bindEmployees() {
            ajaxPost("UserDomainAccess.aspx/GetEmployees", {}, function (res) {
                var data = JSON.parse(res.d);
                var ddl = $("#ddlEmployee");

                ddl.empty();
                ddl.append('<option value="0">Select User</option>');

                $.each(data, function (i, item) {
                    ddl.append('<option value="' + item.EmployeeID + '">' + item.EmployeeName + '</option>');
                });
            });
        }

        $(document).on("click", "#btnDomainDropdown", function () {
            $("#domainDropdown").toggle();
        });

        $(document).on("click", function (e) {
            if (!$(e.target).closest(".multi-select").length) {
                $("#domainDropdown").hide();
            }
        });

        function bindDomains() {
            ajaxPost("UserDomainAccess.aspx/GetDomains", {}, function (res) {
                var data = JSON.parse(res.d);
                var box = $("#domainList");

                box.empty();

                $.each(data, function (i, item) {
                    box.append(
                        '<label class="multi-select-item domain-option">' +
                        '<input type="checkbox" class="chkDomain" value="' + item.DomainGroupID + '" data-name="' + item.DomainGroupName + '" /> ' +
                        '<span>' + item.DomainGroupName + '</span>' +
                        '</label>'
                    );
                });

                updateDomainButtonText();
            });
        }

        $(document).on("change", ".chkDomain", function () {
            updateDomainButtonText();

            var total = $(".chkDomain").length;
            var checked = $(".chkDomain:checked").length;

            $("#chkAllDomains").prop("checked", total > 0 && total === checked);
        });

        $(document).on("change", "#chkAllDomains", function () {
            $(".chkDomain").prop("checked", $(this).is(":checked"));
            updateDomainButtonText();
        });

        function updateDomainButtonText() {
            var selected = [];

            $(".chkDomain:checked").each(function () {
                selected.push($(this).attr("data-name"));
            });

            if (selected.length === 0) {
                $("#btnDomainDropdown").html('Select Domains <span class="arrow">▼</span>');
            }
            else if (selected.length <= 2) {
                $("#btnDomainDropdown").html(selected.join(", ") + ' <span class="arrow">▼</span>');
            }
            else {
                $("#btnDomainDropdown").html(selected.length + ' Domains Selected <span class="arrow">▼</span>');
            }
        }

        $("#txtDomainSearch").on("keyup", function () {
            var value = $(this).val().toLowerCase();

            $(".domain-option").filter(function () {
                $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
            });
        });

        function bindAssignedDomains() {
            var employeeId = $("#ddlEmployee").val();

            accessTable.clear().draw();

            if (employeeId === "0") {
                return;
            }

            showLoader();

            ajaxPost("UserDomainAccess.aspx/GetAssignedDomains", {
                employeeId: parseInt(employeeId)
            }, function (res) {
                hideLoader();

                var data = JSON.parse(res.d);
                $(".chkDomain").prop("checked", false);

                $.each(data, function (i, item) {
                    $(".chkDomain[value='" + item.DomainID + "']").prop("checked", true);
                });

                updateDomainButtonText();

                var total = $(".chkDomain").length;
                var checked = $(".chkDomain:checked").length;
                $("#chkAllDomains").prop("checked", total > 0 && total === checked);
                $.each(data, function (i, item) {
                    accessTable.row.add([
                        '<img src="../Images/delete.png" class="action-icon" title="Remove Access" onclick="deleteAccess(' + item.AccessID + ')" />',
                        item.Code,
                        item.EmployeeName,
                        item.DomainGroupName,
                        item.AddedDate
                    ]);
                });

                accessTable.draw();
            });

          
        }

        function saveAccess() {
            var employeeId = $("#ddlEmployee").val();

            if (employeeId === "0") {
                alert("Please select user.");
                return;
            }

            var domainIds = [];

            $(".chkDomain:checked").each(function () {
                domainIds.push(parseInt($(this).val()));
            });

            if (domainIds.length === 0) {
                alert("Please select at least one domain.");
                return;
            }

            ajaxPost("UserDomainAccess.aspx/SaveMultipleAccess", {
                employeeId: parseInt(employeeId),
                domainIds: domainIds
            }, function (res) {
                alert(res.d);
                bindAssignedDomains();
            });
        }

        function deleteAccess(accessId) {
            if (!confirm("Are you sure you want to remove this domain access?")) {
                return;
            }

            ajaxPost("UserDomainAccess.aspx/DeleteAccess", {
                accessId: accessId
            }, function (res) {
                alert(res.d);
                bindAssignedDomains();
            });
        }
</script>
</asp:Content>
