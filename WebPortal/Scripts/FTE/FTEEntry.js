
var FTEDataEntry_html;
var FTEDataEntry_table;
var prjID = 0;
var prcID = 0;

function BindFteProject() {

    var select = document.getElementById("fteEntry_project");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#fteEntry_project").append($("<option></option>").val("Select").html("Select"));

    $(document).ready(function () {
        $.ajax({
            type: "POST", url: "FTEMaster.aspx/GetAllProjectByUserRights", dataType: "json", contentType: "application/json",

            success: function (res) {

                var dataArray = JSON.parse(res.d);

                $.each(dataArray, function (data, value) {

                    $("#fteEntry_project").append($("<option></option>").val(value.ProjectID || value.ProjectId).html(value.ProjectName || value.Project));
                })
            }
        });
    })
}

function BindFteProcess(ProjectID) {

    var select = document.getElementById("fteEntry_process");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#fteEntry_process").append($("<option></option>").val("Select").html("Select"));

    $(document).ready(function () {
        $.ajax({
            type: "POST", url: "FTEMaster.aspx/GetProcessByProjectWise", dataType: "json", contentType: "application/json",
            data: "{ProjectID:" + ProjectID + "}",

            success: function (res) {

                var dataArray = JSON.parse(res.d);

                $.each(dataArray, function (data, value) {

                    $("#fteEntry_process").append($("<option></option>").val(value.ProcessID || value.ProcessId).html(value.ProcessName || value.Process));
                })
            }
        });
    })
}

function getfteProcess(Project) {

    var ProjectID = Project.options[Project.selectedIndex].value;
    toggleAverageFteField();

    $("#fteEntry_appFTEcount").val("");
    $("#fteEntry_process").html('<option value="Select">Select</option>');

    if (ProjectID != "Select") {
        BindFteProcess(ProjectID);
    }

    clearFteEntryGrid();
    return false;
}

function onFteProcessChange() {
    bindApprovedFteCount();
    return bindGrid();
}

function bindApprovedFteCount() {

    var Project = document.getElementById("fteEntry_project");
    var ProjectID = Project.options[Project.selectedIndex].value;

    var Process = document.getElementById("fteEntry_process");
    var ProcessID = Process.options[Process.selectedIndex].value;

    $("#fteEntry_appFTEcount").val("");

    if (ProjectID == "Select" || ProcessID == "Select") {
        return false;
    }

    PageMethods.GetApprovedFTECount(ProjectID, ProcessID, function (result) {
        $("#fteEntry_appFTEcount").val(result || "");
    }, function (error) {
        alert(error.responseText);
    });

    return false;
}

function BindGrid_FTEEntry(ProjectID, ProcessID) {

    $('#load1').show();
    FTEDataEntry_html = '';

    //alert("ProjectID: " + ProjectID + ", ProcessID:" + ProcessID);

    $.ajax({
        url: "FTEEntry.aspx/GetTop50FTEEntry",
        type: "POST",
        dataType: "json",
        data: "{ProjectID:" + ProjectID + ",ProcessID:" + ProcessID + "}",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = JSON.parse(data.d);

            $.each(dataArray, function (index, value) {

                FTEDataEntry_html += '<tr>';
                FTEDataEntry_html += '<td style="text-align:center;"><a class="dropdown-item" href="#url" id="editEntry_Actions" onclick="prj_EditFteEntry(' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-pen"></i></span></a></td>';
                FTEDataEntry_html += '<td style="text-wrap: nowrap;text-align:center;">' + blankForNull((index + 1)) + '</td>';
                FTEDataEntry_html += '<td style="text-wrap: nowrap; display:none;">' + blankForNull(value.ProjectID) + '</td>';
                FTEDataEntry_html += '<td style="text-wrap: nowrap; display:none;">' + blankForNull(value.ProcessID) + '</td>';
                FTEDataEntry_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ProjectName) + '</td>';
                FTEDataEntry_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ProcessName) + '</td>';
                FTEDataEntry_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ApprovedCount) + '</td>';
                FTEDataEntry_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Date) + '</td>';
                FTEDataEntry_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ActualCount) + '</td>';
                FTEDataEntry_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.AverageFTE) + '</td>';
                FTEDataEntry_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.BilledFTE) + '</td>';
                FTEDataEntry_html += '</tr>';

            });

            if ($.fn.dataTable.isDataTable('#table_FTEDataEntry')) {
                FTEDataEntry_table.destroy();
            }
            $('#table_FTEDataEntry tbody').html(FTEDataEntry_html);

            FTEDataEntry_table = $('#table_FTEDataEntry').DataTable({
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
            $('#load1').hide();
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });

    return false;
}

function bindGrid() {

    var Project = document.getElementById("fteEntry_project");
    var ProjectID = Project.options[Project.selectedIndex].value;

    var Process = document.getElementById("fteEntry_process");
    var ProcessID = Process.options[Process.selectedIndex].value;

    if (ProjectID == "Select") {
        alert("Please select Project.");
        return false;
    }
    if (ProcessID == "Select") {
        alert("Please select Process.");
        return false;
    }

    if (ProjectID != null && ProcessID != null) {
        BindGrid_FTEEntry(ProjectID, ProcessID);
    }
}

function prj_EditFteEntry(index) {

    $("#btnFteEntrySubmit").html('Edit');
    $("#btnFteEntryCancel").css("display", "")

    var rows = FTEDataEntry_table.row(index).data();

    $("#fteEntry_project").val(rows[2]);
    document.getElementById("fteEntry_project").disabled = "disabled";

    // Bind Process -start
    var select = document.getElementById("fteEntry_process");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#fteEntry_process").append($("<option></option>").val("").html("Select"));

    $(document).ready(function () {
        $.ajax({
            type: "POST", url: "FTEMaster.aspx/GetProcessByProjectWise", dataType: "json", contentType: "application/json",
            data: "{ProjectID:" + rows[2] + "}",
            success: function (res) {
                var dataArray = JSON.parse(res.d);

                $.each(dataArray, function (data, value) {
                    $("#fteEntry_process").append($("<option></option>").val(value.ProcessID || value.ProcessId).html(value.ProcessName || value.Process));
                })
                $("#fteEntry_process").val(rows[3]);
            }
        });
    })
    document.getElementById("fteEntry_process").disabled = "disabled";
    // Bind process- end

    $("#fteEntry_appFTEcount").val(rows[6]);

    var date = new Date(rows[7]);
    var day = date.getDate();
    if (day < 10)
        day = '0' + day
    var month = date.getMonth() + 1;
    if (month < 10)
        month = '0' + month
    var year = date.getFullYear();
    var actualdate = year + "-" + (month) + "-" + (day);
    $("#fteEntry_Date").val(actualdate);

    $("#fteEntry_ActualTotalFteCnt").val(rows[8]);
    $("#fteEntry_AverageFTE").val(rows[9]);
    toggleAverageFteField();
}

function isAverageFteProject() {
    var projectText = $("#fteEntry_project option:selected").text() || "";
    return projectText.indexOf("757-004") !== -1 || projectText.indexOf("757-005") !== -1;
}

function toggleAverageFteField() {
    var showAverageFte = isAverageFteProject();
    $("#fteEntry_averageFteField").toggle(showAverageFte);
    if (!showAverageFte) {
        $("#fteEntry_AverageFTE").val("");
    }
}

function btnFteEntrySubmitData() {

    var Project = document.getElementById("fteEntry_project");
    var ProjectID = Project.options[Project.selectedIndex].value;

    var Process = document.getElementById("fteEntry_process");
    var ProcessID = Process.options[Process.selectedIndex].value;

    var ApprovedFTECount = document.getElementById("fteEntry_appFTEcount").value;
    var Date = document.getElementById("fteEntry_Date").value;
    var ActualTotalFteCnt = document.getElementById("fteEntry_ActualTotalFteCnt").value;
    var AverageFTE = document.getElementById("fteEntry_AverageFTE").value;

    prjID = ProjectID;
    prcID = ProcessID;

    if (ProjectID == "Select") {
        alert("Please select Project.");
        return false;
    }
    if (ProcessID == "Select") {
        alert("Please select Process.");
        return false;
    }
    if (ApprovedFTECount == "") {
        alert("Please enter Approved FTE Count .");
        return false;
    }
    if (Date == "") {
        alert("Please select Date.");
        return false;
    }
    if (ActualTotalFteCnt == "") {
        alert("Please select Actual Total FTE Count.");
        return false;
    }
    if (isAverageFteProject() && (AverageFTE == "" || isNaN(AverageFTE) || parseFloat(AverageFTE) < 0)) {
        alert("Please enter a valid Average FTE.");
        return false;
    }

    PageMethods.InsertFTEEntry(ProjectID, ProcessID, ApprovedFTECount, Date, ActualTotalFteCnt, AverageFTE, OnSuccessFteEntrySubmit, OnErrorFteEntrySubmit);
    return false;
}

function OnSuccessFteEntrySubmit(result) {

    if (result > 0) {
        alert("Data entered successfully.");
        // BindGrid_FTEEntry(prjID, prcID);

        window.location.reload();
        prjID = 0;
        prcID = 0;
        return false;
    }
    else {
        alert("Oops! Technical error occured while entering data. Please contact support department.");
    }
}

function OnErrorFteEntrySubmit(error) {
    alert(error.responseText);
    return false;
}

function clearFteEntryGrid() {
    if ($.fn.dataTable.isDataTable('#table_FTEDataEntry')) {
        FTEDataEntry_table.clear().destroy();
    }

    $('#table_FTEDataEntry tbody').html('');
}

function resetFteEntryForm() {
    $("#btnFteEntrySubmit").html('Submit');
    $("#btnFteEntryCancel").hide();
    $("#fteEntry_project").prop("disabled", false).val("Select");
    $("#fteEntry_process").prop("disabled", false).html('<option value="Select">Select</option>');
    $("#fteEntry_appFTEcount").val("");
    $("#fteEntry_Date").val("");
    $("#fteEntry_ActualTotalFteCnt").val("");
    $("#fteEntry_AverageFTE").val("");
    $("#fteEntry_averageFteField").hide();
    clearFteEntryGrid();
    return false;
}
