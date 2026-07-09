<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AddApplicantRemark.aspx.cs" Inherits="WebPortal.Admin.AddApplicantRemark" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        @keyframes animate {
            0% {
                opacity: 0;
            }

            50% {
                opacity: 0.7;
            }

            100% {
                opacity: 0;
            }
        }
    </style>
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

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: normal !important;
            border: none !important;
        }


        div.dt-buttons {
            position: static;
            padding-left: 50px;
            float: left;
        }

        .table.dataTable th {
            background: linear-gradient(to bottom, darkcyan, 20%, #ffffff);
            /*color:white;*/
        }

        .table.dataTable tr td {
            background: none;
        }
      
    </style>
    <script>
        function sleep(milliseconds) {
            var start = new Date().getTime();
            for (var i = 0; i < 1e7; i++) {
                if ((new Date().getTime() - start) > milliseconds) {
                    break;
                }
            }
        }


        $(document).ready(function () {
            $("#load1").show();
            binddomains();
            bindrequistions();
            bindbranches();
            bindprojectamanagers();
            bindddepartment();
            binddshift();
            binddesignation();
            $("#load1").show();

            const urlParams = new URLSearchParams(window.location.search);
            var res1 = urlParams;
            var res2 = urlParams.toString().indexOf("InResult");
            var AppId = urlParams.get('AppId');
            if (AppId == null) {
                AppId = urlParams.get('ShortlistedRemark');
            }
            if (AppId == null) {
                AppId = urlParams.get('InResult');
            }
            $.ajax({

                url: "AddApplicantRemark.aspx/GetApplicantDetails",
                type: "POST",
                dataType: "json",
                data: "{AppId:" + AppId + "}",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    var dataArray = JSON.parse(data.d);//
                    $.each(dataArray, function (index, value) {

                        document.getElementById("name").value = value.Title + ' ' + value.FirstName + ' ' + value.MiddleName + ' ' + value.LastName;
                        document.getElementById("position").value = value.PositionAppliedName;

                        var select = document.getElementById("domain");
                        var options = select.getElementsByTagName('option');

                        for (var i = options.length; i--;) {
                            select.removeChild(options[i]);
                        }

                        $("#domain").append($("<option></option>").val("").html("Select"));

                        $.ajax({
                            type: "POST", url: "AddApplicantRemark.aspx/GetAllDomains", dataType: "json", contentType: "application/json",
                            success: function (res) {
                                $.each(res.d, function (data, value) {
                                    $("#domain").append($("<option></option>").val(value.DomainID).html(value.DomainName));
                                })
                                $("#domain").val(value.Domain);
                            }

                        });

                        select = document.getElementById("requisition");
                        options = select.getElementsByTagName('option');

                        for (var i = options.length; i--;) {
                            select.removeChild(options[i]);
                        }

                        $("#requisition").append($("<option></option>").val("").html("Select"));
                        $.ajax({
                            type: "POST", url: "AddApplicantRemark.aspx/GetAllRequisitions", dataType: "json", contentType: "application/json",
                            success: function (res) {
                                $.each(res.d, function (data, value) {
                                    $("#requisition").append($("<option></option>").val(value.RecId).html(value.RequisitionProfile));
                                })
                                $("#requisition").append($("<option></option>").val("0").html("Other"));
                                $("#requisition").val(value.RequisitionID);
                            }

                        });
                        document.getElementById("process").value = value.Process;
                        document.getElementById("currentsalary").value = value.CurrentSalary;
                        document.getElementById("expectedsalary").value = value.ExpectedSalary;

                        if (res2 != -1) {
                            $("#status").val("Selected");
                            getFields(document.getElementById("status"));
                            document.getElementById("finalsalary").value = value.FinalSalary;
                            //Expected Joining Date
                            if (value.JoiningDate != null && value.JoiningDate != "") {
                                var date = new Date(value.JoiningDate);
                                var day = date.getDate();
                                if (day < 10)
                                    day = '0' + day
                                var month = date.getMonth() + 1;
                                if (month < 10)
                                    month = '0' + month
                                var year = date.getFullYear();
                                var actualdate = year + "-" + (month) + "-" + (day);
                                $("#expjoiningdate").val(actualdate);

                                //Department Name
                                var select = document.getElementById("department");
                                var options = select.getElementsByTagName('option');

                                for (var i = options.length; i--;) {
                                    select.removeChild(options[i]);
                                }

                                $("#department").append($("<option></option>").val("").html("Select"));
                                $.ajax({
                                    type: "POST", url: "AddApplicantRemark.aspx/GetDepartment", dataType: "json", contentType: "application/json",
                                    success: function (res) {
                                        $.each(res.d, function (data, valuedpt) {
                                            $("#department").append($("<option></option>").val(valuedpt.DepartmentID).html(valuedpt.DepartmentName));
                                        })
                                        $("#department").val(value.DepartmentName);
                                    }

                                });

                                //Shift 
                                var select = document.getElementById("shift");
                                var options = select.getElementsByTagName('option');

                                for (var i = options.length; i--;) {
                                    select.removeChild(options[i]);
                                }

                                $("#shift").append($("<option></option>").val("").html("Select"));
                                $.ajax({
                                    type: "POST", url: "AddApplicantRemark.aspx/GetShift", dataType: "json", contentType: "application/json",
                                    success: function (res) {
                                        $.each(res.d, function (data, value) {
                                            $("#shift").append($("<option></option>").val(value.ShiftID).html(value.ShiftTime));
                                        })
                                        $("#shift").val(value.ShiftName);
                                    }

                                });
                                $("#cutofftime").val(value.Cutofftime);
                                //Designation
                                var select = document.getElementById("designation");
                                var options = select.getElementsByTagName('option');

                                for (var i = options.length; i--;) {
                                    select.removeChild(options[i]);
                                }

                                $("#designation").append($("<option></option>").val("").html("Select"));
                                $.ajax({
                                    type: "POST", url: "AddApplicantRemark.aspx/GetDesignation", dataType: "json", contentType: "application/json",
                                    success: function (res) {
                                        $.each(res.d, function (data, valudsge) {
                                            $("#designation").append($("<option></option>").val(valudsge.DesignationID).html(valudsge.DesignationName));
                                        })
                                        $("#designation").val(value.DesignationName);
                                    }

                                });
                                //Reporting Manager
                                var select = document.getElementById("manager");
                                var options = select.getElementsByTagName('option');

                                for (var i = options.length; i--;) {
                                    select.removeChild(options[i]);
                                }
                                $("#manager").append($("<option></option>").val("").html("Select"));
                                $.ajax({
                                    type: "POST", url: "AddApplicantRemark.aspx/GetProjectManagers", dataType: "json", contentType: "application/json",
                                    success: function (res) {
                                        $.each(res.d, function (data, valuerp) {
                                            $("#manager").append($("<option></option>").val(valuerp.ProjectManagerID).html(valuerp.PmCodeName));
                                        })
                                        $("#manager").val(value.ReportingManagerName);
                                    }

                                });

                            }
                        }
                    });
                    $("#load1").hide();
                },
                error: function (error) {
                    alert('error; ' + eval(error));
                    alert('error; ' + error.responseText);
                }
            });
        });


        function AddRemark(AppId, index) {



        }

        function getResult(Type, Content) {


        }

        function binddomains() {
            var select = document.getElementById("domain");
            var options = select.getElementsByTagName('option');

            for (var i = options.length; i--;) {
                select.removeChild(options[i]);
            }

            $("#domain").append($("<option></option>").val("").html("Select"));

            $.ajax({
                type: "POST", url: "AddApplicantRemark.aspx/GetAllDomains", dataType: "json", contentType: "application/json",
                success: function (res) {
                    $.each(res.d, function (data, value) {
                        $("#domain").append($("<option></option>").val(value.DomainID).html(value.DomainName));
                    })
                }

            });
        }

        function bindrequistions() {
            var select = document.getElementById("requisition");
            var options = select.getElementsByTagName('option');

            for (var i = options.length; i--;) {
                select.removeChild(options[i]);
            }

            $("#requisition").append($("<option></option>").val("").html("Select"));

            $.ajax({
                type: "POST", url: "AddApplicantRemark.aspx/GetAllRequisitions", dataType: "json", contentType: "application/json",
                success: function (res) {
                    $.each(res.d, function (data, value) {
                        $("#requisition").append($("<option></option>").val(value.RecId).html(value.RequisitionProfile));
                    })
                    $("#requisition").append($("<option></option>").val("Other").html("Other"));
                }

            });
        }
        function bindbranches() {


            $.ajax({
                type: "POST", url: "AddApplicantRemark.aspx/GetBranches", dataType: "json", contentType: "application/json",
                success: function (res) {
                    $.each(res.d, function (data, value) {
                        $("#location").append($("<option></option>").val(value.BranchName).html(value.BranchName));
                    })
                }

            });
        }
        function bindprojectamanagers() {

            $.ajax({
                type: "POST", url: "AddApplicantRemark.aspx/GetProjectManagers", dataType: "json", contentType: "application/json",
                success: function (res) {
                    $.each(res.d, function (data, value) {
                        $("#interviewer").append($("<option></option>").val(value.ProjectManagerID).html(value.PmCodeName));
                        $("#manager").append($("<option></option>").val(value.ProjectManagerID).html(value.PmCodeName));
                    })
                }

            });
        }
        function bindddepartment() {
            var select = document.getElementById("department");
            var options = select.getElementsByTagName('option');

            for (var i = options.length; i--;) {
                select.removeChild(options[i]);
            }

            $("#department").append($("<option></option>").val("").html("Select"));
            $.ajax({
                type: "POST", url: "AddApplicantRemark.aspx/GetDepartment", dataType: "json", contentType: "application/json",
                success: function (res) {
                    $.each(res.d, function (data, value) {
                        $("#department").append($("<option></option>").val(value.DepartmentID).html(value.DepartmentName));
                    })
                }

            });
        }
        function binddshift() {
            var select = document.getElementById("shift");
            var options = select.getElementsByTagName('option');

            for (var i = options.length; i--;) {
                select.removeChild(options[i]);
            }

            $("#shift").append($("<option></option>").val("").html("Select"));
            $.ajax({
                type: "POST", url: "AddApplicantRemark.aspx/GetShift", dataType: "json", contentType: "application/json",
                success: function (res) {
                    $.each(res.d, function (data, value) {
                        $("#shift").append($("<option></option>").val(value.ShiftID).html(value.ShiftTime));
                    })
                }

            });
        }
        function binddesignation() {
            var select = document.getElementById("designation");
            var options = select.getElementsByTagName('option');

            for (var i = options.length; i--;) {
                select.removeChild(options[i]);
            }

            $("#designation").append($("<option></option>").val("").html("Select"));
            $.ajax({
                type: "POST", url: "AddApplicantRemark.aspx/GetDesignation", dataType: "json", contentType: "application/json",
                success: function (res) {
                    $.each(res.d, function (data, value) {
                        $("#designation").append($("<option></option>").val(value.DesignationID).html(value.DesignationName));
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
                select1.style.display = 'none';
                select2.style.display = 'none';
                select3.style.display = 'none';
                //if (document.getElementById("currentsalary").value == '')
                current.style.display = '';
                salRemark.style.display = '';
                tdSalRemark.innerHTML = "<b>Remark:</b>";
                trotherremark.style.display = 'none';
                //else
                //    current.style.display = 'none';
            }
            else if (text == "Selected") {
                select1.style.display = '';
                select2.style.display = '';
                select3.style.display = '';
                tdmethod1.style.display = 'none';
                tdmethod2.style.display = 'none';
                tdlocation1.style.display = 'none';
                tdlocation2.style.display = 'none';
                trnextround.style.display = 'none';
                current.style.display = 'none';
                const urlParams = new URLSearchParams(window.location.search);
                var res1 = urlParams;
                var res2 = urlParams.toString().indexOf("InResult");
                if (res2 != -1) {
                    salRemark.style.display = '';
                    tdSalRemark.innerHTML = "<b>Salary justification-(Please explain in detail):</b>";
                    trotherremark.style.display = 'none';
                }
                else {
                    salRemark.style.display = 'none';
                    tdSalRemark.innerHTML = "<b>Remark:</b>";
                    trotherremark.style.display = '';
                }
            }
            else {
                tdmethod1.style.display = 'none';
                tdmethod2.style.display = 'none';
                tdlocation1.style.display = 'none';
                tdlocation2.style.display = 'none';
                trnextround.style.display = 'none';
                select1.style.display = 'none';
                select2.style.display = 'none';
                select3.style.display = 'none';
                select3.style.display = 'none';
                // if (document.getElementById("currentsalary").value == '')
                current.style.display = '';
                salRemark.style.display = '';
                tdSalRemark.innerHTML = "<b>Remark:</b>";
                trotherremark.style.display = 'none';
                // else
                //     current.style.display = 'none';
            }
        }
    </script>

    <style>
        :root {
            --ar-primary: #1d4ed8;
            --ar-primary2: #22c1dc;
            --ar-dark: #0f172a;
            --ar-muted: #64748b;
            --ar-line: #dbe7f3;
            --ar-card: #ffffff;
            --ar-bg: #f4f8fc;
        }

        .ar-page {
           
            background: linear-gradient(180deg,#f6faff 0%,#eef5fb 100%);
            border-radius: 18px;
        }

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

        .ar-card {
            background: #fff;
            border: 1px solid #e3edf7;
            border-radius: 18px;
            box-shadow: 0 14px 32px rgba(15,23,42,.07);
            overflow: hidden;
            margin-bottom: 18px;
        }

        .ar-card-head {
            padding: 16px 20px;
            border-bottom: 1px solid #e8f0f8;
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: linear-gradient(180deg,#ffffff 0%,#f8fbff 100%);
        }

        .ar-section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 15px;
            font-weight: 800;
            color: #0f172a;
            margin: 0;
        }

            .ar-section-title i {
                color: #2563eb;
                font-size: 17px;
            }

        .ar-card-body {
            padding: 20px;
        }

        .ar-grid {
            display: flex;
            flex-wrap: wrap;
            margin: -8px;
        }

        .ar-col-3, .ar-col-4, .ar-col-6, .ar-col-8, .ar-col-12 {
            padding: 8px;
        }

        .ar-col-3 {
            width: 25%;
        }

        .ar-col-4 {
            width: 33.333%;
        }

        .ar-col-6 {
            width: 50%;
        }

        .ar-col-8 {
            width: 66.666%;
        }

        .ar-col-12 {
            width: 100%;
        }

        .ar-field label:first-child, .ar-label {
            display: block;
            font-size: 11px;
            letter-spacing: .25px;
            text-transform: uppercase;
            color: #475569;
            font-weight: 800 !important;
            margin-bottom: 6px;
        }

        .ar-field .form-control,
        .ar-field select,
        .ar-field input,
        .ar-field textarea {
            width: 100%;
            min-height: 39px;
            border: 1px solid #cfdcea !important;
            border-radius: 10px !important;
            background: #fff !important;
            color: #0f172a;
            font-size: 12px !important;
            font-weight: 600;
            padding: 8px 11px !important;
            box-shadow: none !important;
            transition: .2s ease;
        }

            .ar-field .form-control:focus,
            .ar-field select:focus,
            .ar-field input:focus,
            .ar-field textarea:focus {
                border-color: #2563eb !important;
                box-shadow: 0 0 0 3px rgba(37,99,235,.12) !important;
                outline: none !important;
            }

        .ar-readonly {
            display: flex !important;
            align-items: center;
            background: #f8fbff !important;
            border: 1px solid #dce8f4 !important;
            min-height: 39px;
            border-radius: 10px !important;
            color: #0f172a !important;
            font-weight: 800 !important;
        }

        .ar-wide-textarea textarea {
            min-height: 72px !important;
            resize: vertical;
        }

        .ar-inline-row {
            display: flex;
            flex-wrap: wrap;
            width: 100%;
            margin: 0 !important;
        }

        .ar-actions {
            display: flex;
            justify-content: flex-end;
            padding-top: 10px;
        }

        .ar-btn-primary {
            border: 0 !important;
            background: linear-gradient(135deg,#2563eb 0%,#22c1dc 100%) !important;
            color: #fff !important;
            padding: 11px 24px !important;
            border-radius: 12px !important;
            font-weight: 800 !important;
            box-shadow: 0 10px 22px rgba(37,99,235,.25);
            transition: .25s ease;
        }

            .ar-btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 14px 28px rgba(37,99,235,.32);
            }

        .ar-history-wrap {
            overflow: auto;
            border-radius: 14px;
            border: 1px solid #e0e9f3;
        }

            .ar-history-wrap .table {
                margin-bottom: 0 !important;
                font-size: 11px;
                background: #fff;
            }

                .ar-history-wrap .table th {
                    background: #edf3f8 !important;
                    color: #0f172a !important;
                    font-weight: 800 !important;
                    text-align: center !important;
                    vertical-align: middle !important;
                    white-space: nowrap;
                    border-color: #dce6f1 !important;
                    padding: 10px 8px !important;
                }

                .ar-history-wrap .table td {
                    border-color: #e5edf5 !important;
                    vertical-align: middle !important;
                    padding: 9px 8px !important;
                    color: #1f2937;
                }

                .ar-history-wrap .table tr:hover td {
                    background: #f8fbff !important;
                }

        .loading {
            top: 50% !important;
            left: 50% !important;
            transform: translate(-50%,-50%);
            margin: 0 !important;
            text-align: center;
        }

        @media(max-width:991px) {
            .ar-col-3, .ar-col-4, .ar-col-6, .ar-col-8 {
                width: 50%;
            }

            .ar-hero {
                align-items: flex-start;
                flex-direction: column;
            }
        }

        @media(max-width:575px) {
            .ar-col-3, .ar-col-4, .ar-col-6, .ar-col-8 {
                width: 100%;
            }

            .ar-page {
                padding: 10px
            }

            .ar-card-body {
                padding: 14px
            }

            .ar-hero h4 {
                font-size: 18px
            }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="ar-page">
        <div class="ar-hero">
            <div class="ar-title-wrap">
                <div class="ar-icon"><i class="fas fa-user-tie"></i></div>
                <div>
                    <h4>Add Interview Remark</h4>
                    <p>Update candidate status, salary details, joining information and remark history.</p>
                </div>
            </div>
            <a href="#!" id="aBack" runat="server" class="ar-back" onclick="window.history.go(-1); return false;">Go Back
            </a>
        </div>

        <div class="ar-card">
            <div class="ar-card-head">
                <h5 class="ar-section-title"><i class="fas fa-id-card"></i>Candidate & Remark Details</h5>
            </div>
            <div class="ar-card-body">
                <div class="ar-grid">
                    <div class="ar-col-12 ar-field">
                        <label>Requisition</label><select id="requisition" name="requisition" class="form-control"><option value="">Select</option>
                        </select>
                    </div>

                    <div class="ar-col-4 ar-field">
                        <label>Name</label><input id="name" name="name" type="text" class="form-control ar-readonly" />
                    </div>
                    <div class="ar-col-4 ar-field">
                        <label>Position Applied</label><input id="position" type="text" name="position" class="form-control ar-readonly" />
                    </div>
                    <div class="ar-col-4 ar-field">
                        <label>Domain</label><select id="domain" name="domain" class="form-control"><option value="">Select</option>
                        </select>
                    </div>

                    <div class="ar-col-4 ar-field">
                        <label>Process</label><input type="text" id="process" name="process" class="form-control" />
                    </div>

                    <div class="ar-col-4 ar-field">
                        <label>Status</label><select id="status" name="status" class="form-control" onchange="getFields(this);"><option value="">Select</option>
                            <option>Hold</option>
                            <option>No Response</option>
                            <option>Proceed For Next Round</option>
                            <option>Rejected</option>
                            <option>Shortlisted for Future Reference</option>
                            <option>Selected</option>
                        </select>
                    </div>

                    <div class="ar-col-4 ar-field" id="tdmethod2" style="display: none;">
                        <label id="tdmethod1">Interview Method</label><select id="method" name="method" class="form-control"><option>Select</option>
                            <option>Walkin</option>
                            <option>Telephonic</option>
                        </select>
                    </div>
                    <div class="ar-col-4 ar-field" id="tdlocation2" style="display: none;">
                        <label id="tdlocation1">Interview Location</label><select id="location" name="location" class="form-control"><option>Select</option>
                        </select>
                    </div>

                    <div id="trnextround" class="ar-inline-row" style="display: none;">
                        <div class="ar-col-4 ar-field">
                            <label>Interview Date</label><input type="date" id="intdate" name="intdate" class="form-control" />
                        </div>
                        <div class="ar-col-4 ar-field">
                            <label>Interview Time</label><input type="time" id="inttime" name="inttime" class="form-control" />
                        </div>
                        <div class="ar-col-4 ar-field">
                            <label>Interviewer</label><select id="interviewer" name="interviewer" class="form-control"><option>Select</option>
                            </select>
                        </div>
                    </div>

                    <div id="current" class="ar-inline-row" style="display: none;">
                        <div class="ar-col-4 ar-field">
                            <label>Current Salary</label><input id="currentsalary" name="currentsalary" class="form-control" />
                        </div>
                        <div class="ar-col-4 ar-field">
                            <label>Expected Salary</label><input id="expectedsalary" name="expectedsalary" class="form-control" />
                        </div>
                    </div>

                    <div id="salRemark" class="ar-col-12 ar-field ar-wide-textarea" style="display: none;">
                        <label id="tdSalRemark">Remark</label><textarea id="remark" name="remark" class="form-control"></textarea>
                    </div>

                    <div id="select1" class="ar-inline-row" style="display: none;">
                        <div class="ar-col-4 ar-field">
                            <label>Final Salary</label><input id="finalsalary" name="finalsalary" class="form-control" />
                        </div>
                        <div class="ar-col-4 ar-field">
                            <label>Expected Joining Date</label><input type="date" id="expjoiningdate" name="expjoiningdate" class="form-control" />
                        </div>
                        <div class="ar-col-4 ar-field">
                            <label>Department</label><select id="department" name="department" class="form-control"><option>Select</option>
                            </select>
                        </div>
                    </div>

                    <div id="select2" class="ar-inline-row" style="display: none;">
                        <div class="ar-col-4 ar-field">
                            <label>Shift</label><select id="shift" name="shift" class="form-control"><option>Select</option>
                            </select>
                        </div>
                        <div class="ar-col-4 ar-field">
                            <label>Cut Off Time</label><input type="time" id="cutofftime" name="cutofftime" class="form-control" />
                        </div>
                        <div class="ar-col-4 ar-field">
                            <label>Designation</label><select id="designation" name="designation" class="form-control"><option>Select</option>
                            </select>
                        </div>
                    </div>

                    <div id="select3" class="ar-inline-row" style="display: none;">
                        <div class="ar-col-4 ar-field">
                            <label>Reporting Manager</label><select id="manager" name="manager" class="form-control"><option>Select</option>
                            </select>
                        </div>
                    </div>

                    <div id="trotherremark" class="ar-col-12 ar-field ar-wide-textarea" style="display: none;">
                        <label>Other Remark / Comments</label><textarea id="otherremark" name="otherremark" class="form-control"></textarea>
                    </div>

                    <div class="ar-col-12 ar-actions">
                        <button class="btn ar-btn-primary" type="button" id="btnapprove" onclick="AddRemarkDB();"><i class="fas fa-plus-circle"></i>&nbsp;&nbsp;Add Remark</button>
                    </div>
                </div>

                <div class="modal fade" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
                    <div class="modal-dialog text-center">
                        <img src="../Images/Load.gif" />
                        <br />
                        <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;">System is updating details. Please wait</span>
                        <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
                    </div>
                </div>
                <script type="text/javascript">
                    function AddRemarkDB() {
                        $('#waitingpanel').modal('show');
                        var name = document.getElementById("name").innerHTML;
                        var position = document.getElementById("position").innerHTML;
                        var ddldomain = document.getElementById("domain");
                        var domain = ddldomain.options[ddldomain.selectedIndex].value;
                        var ddlreq = document.getElementById("requisition");
                        var reqvalue = ddlreq.options[ddlreq.selectedIndex].value;
                        var reqtext = ddlreq.options[ddlreq.selectedIndex].text;
                        var process = document.getElementById("process").value;
                        var ddlstatus = document.getElementById("status");
                        var status = ddlstatus.options[ddlstatus.selectedIndex].text;
                        var ddlmethod = document.getElementById("method");
                        var method = ddlmethod.options[ddlmethod.selectedIndex].text;
                        var ddllocation = document.getElementById("location");
                        var location = ddllocation.options[ddllocation.selectedIndex].text;
                        var intdate = document.getElementById("intdate").value;
                        var inttime = document.getElementById("inttime").value;
                        var newtime = intdate + ' ' + inttime;
                        var dates = new Date(newtime);
                        var hours = dates.getHours();
                        var minutes = dates.getMinutes();
                        var ampm = hours >= 12 ? 'PM' : 'AM';
                        hours = hours % 12;
                        hours = hours ? hours : 12; // the hour '0' should be '12'
                        hours = hours < 10 ? '0' + hours : hours;
                        minutes = minutes < 10 ? '0' + minutes : minutes;
                        var strTime = hours + ':' + minutes + ' ' + ampm;

                        var ddlinterviewer = document.getElementById("interviewer");
                        var interviewer = ddlinterviewer.options[ddlinterviewer.selectedIndex].value;
                        var currentsalary = document.getElementById("currentsalary").value;
                        var expectedsalary = document.getElementById("expectedsalary").value;
                        var remark = document.getElementById("remark").value;
                        var finalsalary = document.getElementById("finalsalary").value;
                        var expjoiningdate = document.getElementById("expjoiningdate").value;

                        var ddldepartment = document.getElementById("department");
                        var department = ddldepartment.options[ddldepartment.selectedIndex].value;
                        var departmentName = ddldepartment.options[ddldepartment.selectedIndex].text;
                        var ddlshift = document.getElementById("shift");
                        var shift = ddlshift.options[ddlshift.selectedIndex].value;
                        var ddldesignation = document.getElementById("designation");
                        var designation = ddldesignation.options[ddldesignation.selectedIndex].value;
                        var designationName = ddldesignation.options[ddldesignation.selectedIndex].text;
                        var ddlmanager = document.getElementById("manager");
                        var manager = ddlmanager.options[ddlmanager.selectedIndex].value;
                        var managerName = ddlmanager.options[ddlmanager.selectedIndex].text;
                        var cutofftime = document.getElementById("cutofftime").value;
                        var otherremark = document.getElementById("otherremark").value;
                        if (status == 'Select') {
                            alert("Please select status");
                            return;
                        }

                        if (status == "Proceed For Next Round") {
                            if (intdate == '') {
                                alert("Please select interview date");
                                return;
                            }
                            if (inttime == '') {
                                alert("Please select interview time");
                                return;
                            }
                            if (interviewer == '') {
                                alert("Please select interviewer");
                                return;
                            }
                            if (remark == '') {
                                alert("Please enter remark");
                                return;
                            }
                            expjoiningdate = '';
                            department = '0';
                            designation = '0';
                            manager = '0';
                            shift = '0';
                            cutofftime = '';
                            otherremark = '';

                        }
                        else if (status == "Selected") {
                            if (finalsalary == '') {
                                alert("Please enter final salary");
                                return;
                            }
                            if (expjoiningdate == '') {
                                alert("Please enter expected joining date");
                                return;
                            }
                            if (department == '') {
                                alert("Please select department");
                                return;
                            }
                            if (shift == '') {
                                alert("Please select shift");
                                return;
                            }
                            if (cutofftime == '') {
                                alert("Please enter cut off time");
                                return;
                            }
                            if (designation == '') {
                                alert("Please select designation");
                                return;
                            }
                            if (manager == '') {
                                alert("Please select reporting manager");
                                return;
                            }
                            intdate = '';
                            inttime = '';
                            interviewer = '0';
                            method = '';
                            location = '';
                        }
                        else {
                            intdate = '';
                            inttime = '';
                            interviewer = '0';
                            method = '';
                            location = '';
                            expjoiningdate = '';
                            department = '0';
                            designation = '0';
                            manager = '0';
                            shift = '0';
                            cutofftime = '';
                            otherremark = '';
                            finalsalary = '';
                            if (reqvalue == '')
                                reqvalue = 0;
                        }
                        const urlParams1 = new URLSearchParams(window.location.search);
                        var AppId1 = urlParams1.get('AppId');
                        if (AppId1 == null) {
                            AppId1 = urlParams1.get('ShortlistedRemark');
                        }
                        if (AppId1 == null) {
                            AppId1 = urlParams1.get('InResult');
                        }
                        //PageMethods.InsertApplicantRemark(AppId1, remark, domain, process, status, intdate, inttime, interviewer, method, location, currentsalary, expectedsalary, finalsalary, OnSucceed, OnError);
                        alert(reqvalue);
                        PageMethods.InsertApplicantRemark(AppId1, remark, domain, process, status, intdate, inttime, interviewer, method, location, currentsalary, expectedsalary, finalsalary, expjoiningdate, department, designation, manager, shift, cutofftime, otherremark, reqvalue, reqtext, name, position, departmentName, designationName, managerName, OnSucceed, OnError);

                        return false;

                    }
                    function OnSucceed(result) {
                        alert('Remark added successfully!');
                        $('#waitingpanel').modal('hide');
                        location.reload();

                    }
                    function OnError(error) {
                        alert(error.responseText);
                    }
                    </script>
            </div>

        </div>
    </div>

    <div class="ar-card">
        <div class="ar-card-head">
            <h5 class="ar-section-title"><i class="fas fa-history"></i>Remark History</h5>
        </div>
        <div class="ar-card-body">
            <div class="ar-history-wrap">
                <asp:GridView ID="grdRemark" runat="server" AutoGenerateColumns="false" CssClass="table table-bordered table-striped table-sm align-content-center">
                    <Columns>
                        <asp:BoundField DataField="Status" HeaderText="Status" />
                        <asp:BoundField DataField="Remark" HeaderText="Remark" />
                        <asp:BoundField DataField="InterviewMethod" HeaderText="Interview Method" />
                        <asp:BoundField DataField="InterviewLocation" HeaderText="Interview Location" />
                        <asp:BoundField DataField="InterviewerName" HeaderText="Interviewer" />
                        <asp:BoundField DataField="InterviewDate1" HeaderText="Interview Datetime" />
                        <asp:BoundField DataField="FinalSalary" HeaderText="FinalSalary" />
                        <asp:BoundField DataField="DepartmentName" HeaderText="Department" />
                        <asp:BoundField DataField="DesignationName" HeaderText="Designation" />
                        <asp:BoundField DataField="ShiftName" HeaderText="Shift" />
                        <asp:BoundField DataField="CutOffTime" HeaderText="Cut Off Time" />
                        <asp:BoundField DataField="ReportingManagerName" HeaderText="Reporting Manager" />
                        <asp:BoundField DataField="AddedByName" HeaderText="Added By" />
                        <asp:BoundField DataField="AddedDate" HeaderText="Added Date" />

                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>
