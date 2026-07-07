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
        /*.form-control {
            font-size: 11px !important;
        }*/
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

                        document.getElementById("name").innerHTML = value.Title + ' ' + value.FirstName + ' ' + value.MiddleName + ' ' + value.LastName;
                        document.getElementById("position").innerHTML = value.PositionAppliedName;

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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Add Interview Remark</b></h6>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right" style="font-size: 12px; font-weight: bold;">
                        <li class="breadcrumb-item"><a href="#utl" id="aBack" runat="server" style="color: saddlebrown" onclick="window.history.go(-1); return false;"><< Go back </a></li>

                    </ol>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <h5 class="card-title"></h5>
                <div>
                    <table class="table table-responsive">
                        <tr>
                            <td><b>Name:</b></td>
                            <td>
                                <label id="name" name="name" class="form-control" style="width: 250px;"></label>
                            </td>
                            <td><b>Position Applied:</b></td>
                            <td>
                                <label id="position" name="position" class="form-control" style="width: 250px;"></label>
                            </td>
                            <td><b>Domain:</b></td>
                            <td>
                                <select id="domain" name="domain" class="form-control" style="width: 250px;">
                                    <option value="">Select</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Process:</b></td>
                            <td>
                                <input type="text" id="process" name="process" class="form-control" style="width: 250px;" />
                            </td>
                            <td><b>Requisition:</b></td>
                            <td colspan="3">
                                <select id="requisition" name="requisition" class="form-control">
                                    <option value="">Select</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Status:</b></td>
                            <td>
                                <select id="status" name="status" class="form-control" style="width: 250px;" onchange="getFields(this);">
                                    <option value="">Select</option>
                                    <option value="Hold">Hold</option>
                                    <option value="No Response">No Response</option>
                                    <option value="Proceed For Next Round">Proceed For Next Round</option>
                                    <option value="Rejected">Rejected</option>
                                    <option value="Shortlisted for Future Reference">Shortlisted for Future Reference</option>
                                    <option value="Selected">Selected</option>
                                </select>
                            </td>
                            <td id="tdmethod1" style="display: none;"><b>Interview Method:</b></td>
                            <td id="tdmethod2" style="display: none;">
                                <select id="method" name="method" class="form-control" style="width: 250px;">
                                    <option value="">Select</option>
                                    <option value="Walkin">Walkin</option>
                                    <option value="Telephonic">Telephonic</option>
                                </select>
                            </td>
                            <td id="tdlocation1" style="display: none;"><b>Interview Location:</b></td>
                            <td id="tdlocation2" style="display: none;">
                                <select id="location" name="location" class="form-control" style="width: 250px;">
                                    <option value="">Select</option>
                                </select>
                            </td>
                        </tr>
                        <tr id="trnextround" style="display: none;">
                            <td><b>Interview Date:</b></td>
                            <td>
                                <input type="date" id="intdate" name="intdate" class="form-control" style="width: 250px;" />
                            </td>
                            <td><b>Interview Time:</b></td>
                            <td>
                                <input type="time" id="inttime" min="0" max="12" name="inttime" class="form-control" style="width: 250px;" />
                            </td>
                            <td><b>Interviewer:</b></td>
                            <td>
                                <select id="interviewer" name="interviewer" class="form-control" style="width: 250px;">
                                    <option value="">Select</option>
                                </select>
                            </td>
                        </tr>
                        <tr id="current" style="display: none;">
                            <td><b>Current Salary:</b></td>
                            <td>
                                <input id="currentsalary" name="currentsalary" class="form-control" style="width: 250px;" />
                            </td>
                            <td><b>Expected Salary:</b></td>
                            <td>
                                <input id="expectedsalary" name="expectedsalary" class="form-control" style="width: 250px;" />
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="salRemark" style="display: none;">
                            <td id="tdSalRemark"><b>Remark:</b></td>
                            <td colspan="3">
                                <textarea id="remark" name="remark" class="form-control"></textarea>
                            </td>

                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="select1" style="display: none;">
                            <td><b>Final Salary:</b></td>
                            <td>
                                <input id="finalsalary" name="finalsalary" class="form-control" style="width: 250px;" />
                            </td>
                            <td><b>Expected Joining Date:</b></td>
                            <td>
                                <input type="date" id="expjoiningdate" name="expjoiningdate" class="form-control" style="width: 250px;" />
                            </td>
                            <td><b>Department:</b></td>
                            <td>
                                <select id="department" name="department" class="form-control" style="width: 250px;">
                                    <option value="">Select</option>
                                </select>
                            </td>
                        </tr>
                        <tr id="select2" style="display: none;">
                            <td><b>Shift:</b></td>
                            <td>
                                <select id="shift" name="shift" class="form-control" style="width: 250px;">
                                    <option value="">Select</option>
                                </select>
                            </td>
                            <td><b>Cut Off Time:</b></td>
                            <td>
                                <input type="time" id="cutofftime" name="cutofftime" min="01:00" max="23:59" class="form-control" style="width: 250px;" />
                            </td>
                            <td><b>Designation:</b></td>
                            <td>
                                <select id="designation" name="designation" class="form-control" style="width: 250px;">
                                    <option value="">Select</option>
                                </select>
                            </td>
                        </tr>
                        <tr id="select3" style="display: none;">
                            <td><b>Reporting Manager:</b></td>
                            <td>
                                <select id="manager" name="manager" class="form-control" style="width: 250px;">
                                    <option value="">Select</option>
                                </select>
                            </td>

                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="trotherremark" style="display: none;">
                            <td><b>Other Remark/ Comments:</b></td>
                            <td colspan="3">
                                <textarea id="otherremark" name="otherremark" class="form-control"></textarea>
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td colspan="6" style="text-align: center;">
                                <button class="btn btn-primary" type="button" id="btnapprove" onclick="AddRemarkDB();">Add Remark</button>
                            </td>
                        </tr>
                    </table>
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
                <div>
                    <h5 class="mb-2">Remark History</h5>
                    <hr />
                    <div class="table-responsive">
                        <asp:GridView ID="grdRemark" runat="server" AutoGenerateColumns="false" CssClass="table table-bordered table-striped table-sm align-content-center ">
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
        </div>
    </div>

</asp:Content>
