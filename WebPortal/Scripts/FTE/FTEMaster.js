
var FTE_UserConfig_table;
var FTE_UserConfig_html;

var FTEProjectConfig_table;
var FTEProjectConfig_html;

var FTE_ClientHoliday_table;

/*------------------- Project Configuration -----------------*/

function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

function BindProject_All() {

    var select = document.getElementById("fte_project");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    var Userprojectselect = document.getElementById("fte_Userproject");
    let Userprojectoptions = Userprojectselect.getElementsByTagName('option');

    for (var i = Userprojectoptions.length; i--;) {
        Userprojectselect.removeChild(Userprojectoptions[i]);
    }

    var CHprojectselect = document.getElementById("fte_clientHolidayproject");
    let CHptions = CHprojectselect.getElementsByTagName('option');

    for (var i = CHptions.length; i--;) {
        CHprojectselect.removeChild(CHptions[i]);
    }

    $("#fte_project").append($("<option></option>").val("Select").html("Select"));
    $("#fte_Userproject").append($("<option></option>").val("Select").html("Select"));
    $("#fte_clientHolidayproject").append($("<option></option>").val("Select").html("Select"));

    $(document).ready(function () {
        $.ajax({
            type: "POST", url: "FTEMaster.aspx/GetAllProjectByUserRights", dataType: "json", contentType: "application/json",

            success: function (res) {

                var dataArray = JSON.parse(res.d);

                $.each(dataArray, function (data, value) {

                    $("#fte_project").append($("<option></option>").val(value.ProjectID).html(value.ProjectName));
                    $("#fte_Userproject").append($("<option></option>").val(value.ProjectID).html(value.ProjectName));
                    $("#fte_clientHolidayproject").append($("<option></option>").val(value.ProjectID).html(value.ProjectName));
                })
            }
        });
    })
}

function getProcess(Project) {

    var ProjectID = Project.options[Project.selectedIndex].value;

    if (ProjectID != "Select") {
        BindProcess(ProjectID);
    }
}

function BindProcess(ProjectID) {

    var select = document.getElementById("fte_process");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#fte_process").append($("<option></option>").val("Select").html("Select"));

    $(document).ready(function () {
        $.ajax({
            type: "POST", url: "FTEMaster.aspx/GetProcessByProjectWise", dataType: "json", contentType: "application/json",
            data: "{ProjectID:" + ProjectID + "}",

            success: function (res) {

                var dataArray = JSON.parse(res.d);

                $.each(dataArray, function (data, value) {

                    $("#fte_process").append($("<option></option>").val(value.ProcessID).html(value.ProcessName));
                })
            }
        });
    })
}

function BindGrid_ProjConfig() {

    $('#load1').show();
    FTEProjectConfig_html = '';

    $.ajax({
        url: "FTEMaster.aspx/GetFTEDetails",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);
            $.each(dataArray, function (index, value) {

                FTEProjectConfig_html += '<tr>';
                FTEProjectConfig_html += '<td style="text-align:center;"><a class="dropdown-item" href="#url" id="prj_Actions" onclick="prj_EditprjConfig(' + blankForNull(value.FteId) + ',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-pen"></i></span></a></td>';
                FTEProjectConfig_html += '<td style="text-wrap: nowrap;text-align:center;">' + blankForNull((index + 1)) + '</td>';
                FTEProjectConfig_html += '<td style="text-wrap: nowrap; display:none;">' + blankForNull(value.ProjectID) + '</td>';
                FTEProjectConfig_html += '<td style="text-wrap: nowrap; display:none;">' + blankForNull(value.ProcessID) + '</td>';
                FTEProjectConfig_html += '<td>' + blankForNull(value.ProjectName) + '</td>';
                FTEProjectConfig_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ProcessName) + '</td>';
                FTEProjectConfig_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ApprovedFTECount) + '</td>';
                FTEProjectConfig_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.BillableStandardHours) + '</td>';
                FTEProjectConfig_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.BillingType) + '</td>';
                FTEProjectConfig_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.WeekendAllowed) + '</td>';
                FTEProjectConfig_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.USHolidayAllowed) + '</td>';
                FTEProjectConfig_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#table_FTEProjectConfig')) {
                FTEProjectConfig_table.destroy();
            }
            $('#table_FTEProjectConfig tbody').html(FTEProjectConfig_html);
            //else
            FTEProjectConfig_table = $('#table_FTEProjectConfig').DataTable({
                dom: 'lftip',
                destroy: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                'select': {
                    'style': 'single'
                },

                initComplete: function () {
                    $('#load1').hide();
                },
            });

        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });

    return false;
}

function prj_EditprjConfig(FteId, index) {

    $("#btnfteSubmit").html('Edit');

    $("#btnfteCancel").css("display", "")

    var rows = FTEProjectConfig_table.row(index).data();

    $("#fte_project").val(rows[2]);
    document.getElementById("fte_project").disabled = "disabled";
    // Bind Process -start
    var select = document.getElementById("fte_process");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#fte_process").append($("<option></option>").val("").html("Select"));

    $(document).ready(function () {
        $.ajax({
            type: "POST", url: "FTEMaster.aspx/GetProcessByProjectWise", dataType: "json", contentType: "application/json",
            data: "{ProjectID:" + rows[2] + "}",
            success: function (res) {
                var dataArray = JSON.parse(res.d);
                $.each(dataArray, function (data, value) {
                    $("#fte_process").append($("<option></option>").val(value.ProcessID).html(value.ProcessName));
                })
                $("#fte_process").val(rows[3]);
            }
        });
    })
    document.getElementById("fte_process").disabled = "disabled";
    // Bind process- end
    //$("#fte_process").val(rows[3]);

    $("#fte_appFTEcount").val(rows[6]);
    $("#fte_billableStandHpurs").val(rows[7]);
    $("#fte_billingType").val(rows[8]);
    $("#fte_weekendAllowed").val(rows[9]);
    $("#fte_usHolidayAllowed").val(rows[10]);

}

function btnfteSubmitData() {

    var Project = document.getElementById("fte_project");
    var ProjectID = Project.options[Project.selectedIndex].value;

    var Process = document.getElementById("fte_process");
    var ProcessID = Process.options[Process.selectedIndex].value;

    var weekendAllowedVal = document.getElementById("fte_weekendAllowed");
    var WeekendAllowed = weekendAllowedVal.options[weekendAllowedVal.selectedIndex].value;

    var usHolidayAllowedVal = document.getElementById("fte_usHolidayAllowed");
    var USHolidayAllowed = usHolidayAllowedVal.options[usHolidayAllowedVal.selectedIndex].value;

    var BillingTypeVal = document.getElementById("fte_billingType");
    var BillingType = BillingTypeVal.options[BillingTypeVal.selectedIndex].value;

    var ApprovedFTECount = document.getElementById("fte_appFTEcount").value;
    var BillableStandardHours = document.getElementById("fte_billableStandHpurs").value;

    if (ProjectID == "Select") {
        alert("Please select Project.");
        return false;
    }
    if (ProcessID == "Select") {
        alert("Please select Process.");
        return false;
    }
    if (WeekendAllowed == "Select") {
        alert("Please select Weekend Allowed .");
        return false;
    }
    if (USHolidayAllowed == "Select") {
        alert("Please select US Holiday Allowed.");
        return false;
    }
    if (BillingType == "Select") {
        alert("Please select Billing Type.");
        return false;
    }
    if (ApprovedFTECount == "") {
        alert("Please enter Approved FTE Count .");
        return false;
    }
    if (BillableStandardHours == "") {
        alert("Please select Billable Standard Hours.");
        return false;
    }

    PageMethods.InsertFTEDetails(ProjectID, ProcessID, ApprovedFTECount, BillableStandardHours, BillingType, WeekendAllowed, USHolidayAllowed, OnSuccessFTESubmit, OnErrorFTESubmit);
    return false;
}

function OnSuccessFTESubmit(result) {

    if (result > 0) {
        EmpConfigID = 0;
        alert("Project has been configured successfully.");
        BindGrid_Detail();
        return false;
    }
    else {
        alert("Oops! Technical error occured while configuring  project. Please contact support department.");
    }
}

function OnErrorFTESubmit(error) {
    alert(error.responseText);
    return false;
}

/*------------------- User Configuration -----------------*/

function BindUsers() {

    var select = document.getElementById("fte_UserEmployee");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#fte_UserEmployee").append($("<option></option>").val("Select").html("Select"));

    $(document).ready(function () {
        $.ajax({
            type: "POST", url: "FTEMaster.aspx/GetAllEmployeeDetailsbyPM", dataType: "json", contentType: "application/json",
            success: function (res) {

                var dataArray = JSON.parse(res.d);

                $.each(dataArray, function (data, value) {

                    $("#fte_UserEmployee").append($("<option></option>").val(value.EMPID).html(value.NAME));
                })
            }
        });
    })
}

function BindUserProcess(ProjectID) {

    var select = document.getElementById("fte_Userprocess");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#fte_Userprocess").append($("<option></option>").val("Select").html("Select"));

    $(document).ready(function () {
        $.ajax({
            type: "POST", url: "FTEMaster.aspx/GetProcessByProjectWise", dataType: "json", contentType: "application/json",
            data: "{ProjectID:" + ProjectID + "}",

            success: function (res) {

                var dataArray = JSON.parse(res.d);

                $.each(dataArray, function (data, value) {

                    $("#fte_Userprocess").append($("<option></option>").val(value.ProcessID).html(value.ProcessName));
                })
            }
        });
    })
}

function BindGrid_UserConfig() {

    $('#load1').show();
    FTE_UserConfig_html = '';

    $.ajax({
        url: "FTEMaster.aspx/GetFTEUserDetails",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);
            $.each(dataArray, function (index, value) {

                FTE_UserConfig_html += '<tr>';
                FTE_UserConfig_html += '<td style="text-align:center;"><a class="dropdown-item" href="#url" id="user_Actions" onclick="user_EditUserConfig(' + blankForNull(value.ConfigId) + ',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-pen"></i></span></a></td>';
                FTE_UserConfig_html += '<td style="text-wrap: nowrap;text-align:center;">' + blankForNull((index + 1)) + '</td>';
                FTE_UserConfig_html += '<td style="text-wrap: nowrap; display:none;">' + blankForNull(value.ProjectID) + '</td>';
                FTE_UserConfig_html += '<td style="text-wrap: nowrap; display:none;">' + blankForNull(value.ProcessID) + '</td>';
                FTE_UserConfig_html += '<td>' + blankForNull(value.ProjectName) + '</td>';
                FTE_UserConfig_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Process) + '</td>';
                FTE_UserConfig_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.EmployeeName) + '</td>';
                FTE_UserConfig_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Pseudoname) + '</td>';
                FTE_UserConfig_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.EmployeeStatus) + '</td>';
                FTE_UserConfig_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.EffectiveDate) + '</td>';
                FTE_UserConfig_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.NoticePeriodDays) + '</td>';
                FTE_UserConfig_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#table_FTE_UserConfig')) {
                FTE_UserConfig_table.destroy();
            }
            $('#table_FTE_UserConfig tbody').html(FTE_UserConfig_html);

            FTE_UserConfig_table = $('#table_FTE_UserConfig').DataTable({
                dom: 'lftip',
                destroy: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                'select': {
                    'style': 'single'
                },

                initComplete: function () {

                    $('#load1').hide();
                },
            });
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });

    return false;
}

function getUserProcess(UserProject) {

    var UserProjectID = UserProject.options[UserProject.selectedIndex].value;

    if (UserProjectID != "Select") {
        BindUserProcess(UserProjectID);
    }
}

function getPsuedoName(UserName) {

    document.getElementById("fte_UserPsuedoName").value = "";

    var Code = UserName.options[UserName.selectedIndex].text;

    $(document).ready(function () {
        $.ajax({
            type: "POST", url: "FTEMaster.aspx/GetPseudoName", dataType: "json", contentType: "application/json",
            data: "{Code:'" + Code + "'}",

            success: function (data) {

                var dataArray = JSON.parse(data.d);

                $.each(dataArray, function (index, value) {

                    document.getElementById("fte_UserPsuedoName").value = value.PsuedoName;
                })
            }
        });
    })
}

function btnfteUserSubmitData() {

    var Project = document.getElementById("fte_Userproject");
    var ProjectID = Project.options[Project.selectedIndex].value;

    var Process = document.getElementById("fte_Userprocess");
    var ProcessID = Process.options[Process.selectedIndex].value;

    var UserEmployeeVal = document.getElementById("fte_UserEmployee");
    var EmployeeID = UserEmployeeVal.options[UserEmployeeVal.selectedIndex].value;

    var EmployeeStatusVal = document.getElementById("fte_UserEmpStatus");
    var EmployeeStatus = EmployeeStatusVal.options[EmployeeStatusVal.selectedIndex].value;

    var EffectiveDate = document.getElementById("fte_UserEffectDate").value;
    var NoticePeriodDays = document.getElementById("fte_UserNoticePeriodDays").value;
    var Pseudoname = document.getElementById("fte_UserPsuedoName").value;

    if (ProjectID == "Select") {
        alert("Please select Project.");
        return false;
    }
    if (ProcessID == "Select") {
        alert("Please select Process.");
        return false;
    }
    if (EmployeeID == "Select") {
        alert("Please select Employee.");
        return false;
    }
    if (EmployeeStatus == "Select") {
        alert("Please select Employee Status.");
        return false;
    }
    if (EffectiveDate == "") {
        alert("Please select Effective Date.");
        return false;
    }
    if (NoticePeriodDays == "") {
        alert("Please select Notice Period Days.");
        return false;
    }

    PageMethods.InsertFTEUserDetails(ProjectID, ProcessID, EmployeeID, Pseudoname, EmployeeStatus, EffectiveDate, NoticePeriodDays, OnSuccessUserSubmit, OnErrorUserSubmit);
    return false;
}

function OnSuccessUserSubmit(result) {

    if (result > 0) {
        alert("User has been configured successfully.");
        window.location.reload();
    }
    else {
        alert("Oops! Technical error occured while configuring  user. Please contact support department.");
    }
}

function OnErrorUserSubmit(error) {
    alert(error.responseText);
    return false;
}

function user_EditUserConfig(ConfigId, index) {

    $("#btnfteUserSubmit").html('Edit');
    $("#btnUserCancel").css("display", "")

    var rows = FTE_UserConfig_table.row(index).data();

    alert(rows);

    $("#fte_Userproject").val(rows[2]);

    document.getElementById("fte_Userproject").disabled = "disabled";

    //-------- Bind Process -start
    var select = document.getElementById("fte_Userprocess");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#fte_Userprocess").append($("<option></option>").val("").html("Select"));

    $(document).ready(function () {
        $.ajax({
            type: "POST", url: "FTEMaster.aspx/GetProcessByProjectWise", dataType: "json", contentType: "application/json",
            data: "{ProjectID:" + rows[2] + "}",
            success: function (res) {
                var dataArray = JSON.parse(res.d);
                $.each(dataArray, function (data, value) {
                    $("#fte_Userprocess").append($("<option></option>").val(value.ProcessID).html(value.ProcessName));
                })
                $("#fte_Userprocess").val(rows[3]);
            }
        });
    })
    document.getElementById("fte_Userprocess").disabled = "disabled";
    //----------- Bind process- end

    $("#fte_UserEmployee").val(rows[4]);
    $("#fte_UserPsuedoName").val(rows[7]);
    $("#fte_UserEmpStatus").val(rows[8]);

    var date = new Date(rows[9]);
    var day = date.getDate();
    if (day < 10)
        day = '0' + day
    var month = date.getMonth() + 1;
    if (month < 10)
        month = '0' + month
    var year = date.getFullYear();
    var actualdate = year + "-" + (month) + "-" + (day);
    $("#fte_UserEffectDate").val(actualdate);

    $("#fte_UserNoticePeriodDays").val(rows[10]);
}

/*------------------- Client Holiday -----------------*/

function BindGrid_UserConfig() {

    $('#load1').show();
    FTE_UserConfig_html = '';

    $.ajax({
        url: "FTEMaster.aspx/GetFTEUserDetails",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);
            $.each(dataArray, function (index, value) {

                FTE_UserConfig_html += '<tr>';
                FTE_UserConfig_html += '<td style="text-align:center;"><a class="dropdown-item" href="#url" id="user_Actions" onclick="user_EditUserConfig(' + blankForNull(value.ConfigId) + ',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-pen"></i></span></a></td>';
                FTE_UserConfig_html += '<td style="text-wrap: nowrap;text-align:center;">' + blankForNull((index + 1)) + '</td>';
                FTE_UserConfig_html += '<td style="text-wrap: nowrap; display:none;">' + blankForNull(value.ProjectID) + '</td>';
                FTE_UserConfig_html += '<td style="text-wrap: nowrap; display:none;">' + blankForNull(value.ProcessID) + '</td>';
                FTE_UserConfig_html += '<td>' + blankForNull(value.ProjectName) + '</td>';
                FTE_UserConfig_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Process) + '</td>';
                FTE_UserConfig_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.EmployeeName) + '</td>';
                FTE_UserConfig_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Pseudoname) + '</td>';
                FTE_UserConfig_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.EmployeeStatus) + '</td>';
                FTE_UserConfig_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.EffectiveDate) + '</td>';
                FTE_UserConfig_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.NoticePeriodDays) + '</td>';
                FTE_UserConfig_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#table_FTE_UserConfig')) {
                FTE_UserConfig_table.destroy();
            }
            $('#table_FTE_UserConfig tbody').html(FTE_UserConfig_html);

            FTE_UserConfig_table = $('#table_FTE_UserConfig').DataTable({
                dom: 'lftip',
                destroy: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                'select': {
                    'style': 'single'
                },

                initComplete: function () {

                    $('#load1').hide();
                },
            });
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });

    return false;
}

function BindGrid_ClientHoliday() {

    $('#load1').show();

    $.ajax({
        url: "FTEMaster.aspx/GetClientHoliday",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            FTE_ClientHoliday_table = $('#table_FTE_ClientHoliday').DataTable({
                dom: 'lftip',
                destroy: true,
                orderCellsTop: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                filter: true,
                'select': {
                    'style': 'single'
                },
                "serverSide": false,
                "data": dataArray,
                columns: [
                    { data: 'SrNo' },
                    { data: 'ProjectName' },
                    { data: 'Date' },
                    { data: 'AddedByName' },
                    { data: 'AddedDate1' }
                ],

                initComplete: function () {
                    $('#load1').hide();
                    jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');
                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Client Holiday Master', autoFilter: true,
                    },
                ],
            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });

    return false;
}

function btnClientHolidaySubmit() {

    var Project = document.getElementById("fte_clientHolidayproject");
    var ProjectID = Project.options[Project.selectedIndex].value;

    var HolidayDate = document.getElementById("fte_ClientHoliday").value;

    if (ProjectID == "Select") {
        alert("Please select project.");
        return false;
    }
    if (HolidayDate == "") {
        alert("Please select client holiday .");
        return false;
    }

    PageMethods.InsertClientHoliday(ProjectID, HolidayDate, OnSuccessHolidaySubmit, OnErrorHolidaySubmit);
    return false;
}

function OnSuccessHolidaySubmit(result) {

    if (result > 0) {
        alert("Client holiday set successfully.");
        window.location.reload();
    }
    else {
        alert("Oops! Technical error occured while setting client holiday. Please contact support department.");
    }
}

function OnErrorHolidaySubmit(error) {
    alert(error.responseText);
    return false;
}
