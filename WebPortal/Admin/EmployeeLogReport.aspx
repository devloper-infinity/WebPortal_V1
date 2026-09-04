<%@ Page Title="Employee Log Report" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EmployeeLogReport.aspx.cs" Inherits="WebPortal.Admin.EmployeeLogReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.8/css/jquery.dataTables.min.css" />
    <style>
        :root { --el-primary:#2563eb; --el-accent:#22c1dc; --el-text:#0f172a; --el-muted:#64748b; --el-border:#e2e8f0; --el-soft:#eff6ff; }
        .el-hero { margin-bottom:24px; padding:20px 25px; border-radius:15px; color:#fff; background:linear-gradient(120deg,#1d4ed8 0%,#2563eb 48%,#22c1dc 100%); box-shadow:0 18px 45px rgba(15,23,42,.08); }
        .el-hero h1 { margin:0; font-size:22px; font-weight:800; }
        .el-hero p { margin:8px 0 0; font-size:13px; opacity:.9; }
        .el-card { margin-top:24px; padding:24px; border:1px solid var(--el-border); border-radius:22px; background:#fff; box-shadow:0 18px 45px rgba(15,23,42,.08); }
        .el-filter-grid { display:grid; grid-template-columns:2fr 1fr 1fr 160px; gap:16px; align-items:end; }
        .el-field label { display:block; margin-bottom:9px; color:var(--el-muted); font-size:12px; font-weight:800; }
        .el-field .form-control { width:100%; height:46px; border:1px solid var(--el-border); border-radius:14px; box-shadow:none; font-size:13px; font-weight:700; padding:9px 14px; }
        .el-field .form-control:focus { border-color:var(--el-primary); box-shadow:0 0 0 4px rgba(37,99,235,.12); }
        .el-submit { width:100%; height:46px; border:0; border-radius:14px; color:#fff; font-weight:800; background:linear-gradient(135deg,var(--el-primary),var(--el-accent)); box-shadow:0 12px 22px rgba(37,99,235,.22); cursor:pointer; }
        .el-error { display:none; margin-top:15px; padding:11px 14px; border-radius:10px; color:#b91c1c; background:#fef2f2; font-size:13px; font-weight:700; }
        .el-table-wrap { width:100%; overflow-x:auto; border:1px solid var(--el-border); border-radius:16px; }
        #tblEmployeeLog { width:100%!important; margin:0!important; border-collapse:separate!important; border-spacing:0; white-space:nowrap; }
        #tblEmployeeLog thead th { padding:14px 12px!important; border:0!important; border-bottom:1px solid var(--el-border)!important; background:var(--el-soft); color:var(--el-text); font-size:12px; font-weight:900; text-align:center; }
        #tblEmployeeLog tbody td { border-color:var(--el-border)!important; color:#1e293b; font-size:13px; text-align:center; vertical-align:middle; }
        #tblEmployeeLog tbody tr:hover td { background:#f8fafc; }
        .dataTables_wrapper .dataTables_length,.dataTables_wrapper .dataTables_filter,.dataTables_wrapper .dataTables_info,.dataTables_wrapper .dataTables_paginate { display:none; }
        .row-holiday td { background:#e8f4ff!important; color:#1d4ed8!important; }
        .row-leave td { background:#ecfdf5!important; color:#047857!important; }
        .row-worked td { background:#fff7ed!important; color:#c2410c!important; }
        .row-absent td { background:#fef2f2!important; color:#b91c1c!important; }
        .row-current td { background:#d9ead3!important; color:#274e13!important; }
        .el-loader { display:none; position:fixed; inset:0; z-index:99999; background:rgba(248,250,252,.75); }
        .el-loader-box { position:absolute; top:50%; left:50%; transform:translate(-50%,-50%); padding:28px 36px; border-radius:18px; background:#fff; box-shadow:0 24px 60px rgba(15,23,42,.18); font-weight:800; }
        @media(max-width:900px) { .el-filter-grid { grid-template-columns:1fr 1fr; } }
        @media(max-width:600px) { .el-filter-grid { grid-template-columns:1fr; } .el-card { padding:16px; } }
    </style>
    <script type="text/javascript">
        var employeeLogTable = null;

        function showLogError(message) {
            var box = $("#logError");
            if (message) { box.text(message).show(); } else { box.text("").hide(); }
        }

        function applyLogStatus(row, data) {
            var remark = (data.ShiftRemark || "").toLowerCase().trim();
            $(row).removeClass("row-holiday row-leave row-absent row-worked row-current");
            if (remark === "worked holiday") $(row).addClass("row-worked");
            else if (remark === "paid leave") $(row).addClass("row-leave");
            else if (remark === "holiday") $(row).addClass("row-holiday");
            else if (remark === "absent") $(row).addClass("row-absent");
            else if (remark === "currentlogin") $(row).addClass("row-current");
        }

        function loadEmployeeLogs() {
            var code = $("#<%= ddlEmployee.ClientID %>").val();
            var fromMonth = $("#fromMonth").val();
            var toMonth = $("#toMonth").val();
            showLogError("");

            if (!code) { showLogError("Employee is required."); return; }
            if ((fromMonth && !toMonth) || (!fromMonth && toMonth)) { showLogError("Select both From Month-Year and To Month-Year, or leave both blank."); return; }
            if (fromMonth && toMonth && fromMonth > toMonth) { showLogError("From Month-Year must be earlier than or equal to To Month-Year."); return; }

            $("#employeeLogLoader").show();
            $.ajax({
                type:"POST",
                url:"EmployeeLogReport.aspx/BindLogDetails",
                data:JSON.stringify({ Code:code, FromMonth:fromMonth, ToMonth:toMonth }),
                contentType:"application/json; charset=utf-8",
                dataType:"json",
                success:function(response) {
                    var rows = response && response.d ? JSON.parse(response.d) : [];
                    if ($.fn.DataTable.isDataTable("#tblEmployeeLog")) {
                        employeeLogTable.clear().destroy();
                        $("#tblEmployeeLog tbody").empty();
                    }
                    employeeLogTable = $("#tblEmployeeLog").DataTable({
                        data:rows, searching:false, paging:false, info:false, autoWidth:false, order:[],
                        columns:[
                            {data:"AttendanceDate",defaultContent:""},{data:"DayName",defaultContent:""},
                            {data:"InTime",defaultContent:""},{data:"OutTime",defaultContent:""},
                            {data:"Hours",defaultContent:""},{data:"ShiftTime",defaultContent:""},
                            {data:"ExtraHours",defaultContent:""},{data:"LateMark",defaultContent:""},
                            {data:"Partial",defaultContent:""},{data:"ShiftRemark",defaultContent:""},
                            {data:"Remark",defaultContent:""},{data:"INIP",defaultContent:""},{data:"OutIP",defaultContent:""}
                        ],
                        columnDefs:[{targets:"_all",className:"text-center align-middle",render:function(data){ return data == null ? "" : data; }}],
                        rowCallback:applyLogStatus,
                        language:{emptyTable:"No log records found"}
                    });
                },
                error:function(xhr) {
                    var message = "Unable to load log details.";
                    if (xhr.responseJSON && xhr.responseJSON.Message) message = xhr.responseJSON.Message;
                    showLogError(message);
                },
                complete:function() { $("#employeeLogLoader").hide(); }
            });
        }

        $(document).ready(function() { $("#btnSubmitLogs").on("click", loadEmployeeLogs); });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="employeeLogLoader" class="el-loader"><div class="el-loader-box">Loading logs...</div></div>
    <div class="container-fluid">
        <section class="el-hero">
            <h1><i class="fas fa-calendar-check"></i>&nbsp;&nbsp;Employee Log Report</h1>
            <p>Select an employee and an optional month range. With no range, the latest three calendar months are shown.</p>
        </section>
        <section class="el-card">
            <div class="el-filter-grid">
                <div class="el-field">
                    <label for="<%= ddlEmployee.ClientID %>">Employee <span class="text-danger">*</span></label>
                    <asp:DropDownList ID="ddlEmployee" runat="server" CssClass="form-control"></asp:DropDownList>
                </div>
                <div class="el-field"><label for="fromMonth">From Month-Year</label><input type="month" id="fromMonth" class="form-control" /></div>
                <div class="el-field"><label for="toMonth">To Month-Year</label><input type="month" id="toMonth" class="form-control" /></div>
                <div class="el-field"><label>&nbsp;</label><button type="button" id="btnSubmitLogs" class="el-submit"><i class="fas fa-search"></i>&nbsp; Submit</button></div>
            </div>
            <div id="logError" class="el-error" role="alert"></div>
        </section>
        <section class="el-card">
            <div class="el-table-wrap">
                <table id="tblEmployeeLog" class="table table-hover table-bordered nowrap">
                    <thead><tr>
                        <th>Date</th><th>Day</th><th>In Time</th><th>Out Time</th><th>Hours</th>
                        <th>Total Hours</th><th>Extra Hours</th><th>Late Mark</th><th>Partial</th>
                        <th>Shift Remark</th><th>Day Status</th><th>In IP</th><th>Out IP</th>
                    </tr></thead>
                    <tbody></tbody>
                </table>
            </div>
        </section>
    </div>
</asp:Content>
