
var DomainWiseColMaster_table;
var DomainWiseColMaster_html;
var DomainFieldID = 0;

var PrjWiseColMaster_table;
var PrjWiseColMaster_html;
var ProjectFieldID = 0;

var ColumnMapping_table;
var ColumnMapping_html;
var ColumnMapID = 0;

function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

//----------------------- Domainwise Column Configuration ----------------------- 

function Bind_Domain() {

    var select = document.getElementById("track_domain");
    let options = select.getElementsByTagName('option');

    var PopUpselect = document.getElementById("PopUptrack_domain");
    let PopUpoptions = PopUpselect.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    for (var i = PopUpoptions.length; i--;) {
        PopUpselect.removeChild(PopUpoptions[i]);
    }

    $("#track_domain").append($("<option></option>").val("").html("Select"));
    $("#PopUptrack_domain").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "TrackingSheetConfiguration.aspx/GetDomain", dataType: "json", contentType: "application/json",
        success: function (res) {

            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {

                $("#track_domain").append($("<option></option>").val(value.DomainID).html(value.DomainName));
                $("#PopUptrack_domain").append($("<option></option>").val(value.DomainID).html(value.DomainName));
            })
        }
    });
}

function BindDomainwiseColConfig_Grid(DomainID) {

    $('#load1').show();
    DomainWiseColMaster_html = '';

    $.ajax({
        url: "TrackingSheetConfiguration.aspx/GetAllFieldbyDomain",
        type: "POST",
        data: "{Domain:'" + DomainID + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {

            var dataArray = JSON.parse(data.d);
            $.each(dataArray, function (index, value) {

                DomainWiseColMaster_html += '<tr>';
                DomainWiseColMaster_html += '<td style="text-align: center;" class=""><div class="btn-group">';
                DomainWiseColMaster_html += '<div class="btn-group">';
                DomainWiseColMaster_html += '<div type="button" data-toggle="dropdown" aria-expanded="false"><i style="color: dodgerblue; font-size:14px;" class="uil fs-0 me-2 uil-cog"></i>';
                DomainWiseColMaster_html += '<span class="sr-only"></span></div><div class="dropdown-menu" role="menu" style="">';

                DomainWiseColMaster_html += '<a class="dropdown-item" href="#!" id="editConf" onclick="EditDomainWise_ColConf(' + value.DomainFieldID + ',' + index + ',1);"><span style="color: forestgreen;"><i class="uil fs-0 me-2 uil-pen" style="font-size:14px;"></i></span>&nbsp;&nbsp;Edit Configuration</a>';
                DomainWiseColMaster_html += '<a class="dropdown-item" href="#url" id="deleteConf" onclick="DeleteDomainWise_ColConf(' + value.DomainFieldID + ',' + index + ');"><span style="color: brown;"><i class="uil fs-0 me-2 uil-trash"></i></span>&nbsp;&nbsp;Delete Configuration</a></div></div></td> ';

                DomainWiseColMaster_html += '<td style="text-align: center;">' + blankForNull(index + 1) + '</td>';
                DomainWiseColMaster_html += '<td>' + blankForNull(value.FieldName) + '</td>';

                if (value.NameColumn == "True")
                    DomainWiseColMaster_html += '<td style="text-wrap: nowrap; text-align:center;"><input type="checkbox" disabled checked class="custom-checkbox" id="chk' + blankForNull(value.DomainFieldID) + '"></td>';
                else
                    DomainWiseColMaster_html += '<td style="text-wrap: nowrap; text-align:center;"><input type="checkbox" disabled class="custom-checkbox" id="chk' + blankForNull(value.DomainFieldID) + '"></td>';

                DomainWiseColMaster_html += '<td style="text-wrap: nowrap;text-align: center;">' + blankForNull(value.DomainName) + '</td>';
                DomainWiseColMaster_html += '<td style="text-wrap: nowrap;text-align: center;">' + blankForNull(value.AddedByName) + '</td>';
                DomainWiseColMaster_html += '<td style="text-wrap: nowrap;text-align: center;">' + blankForNull(value.AddedDate1) + '</td>';
                DomainWiseColMaster_html += '<td style="text-wrap: nowrap;text-align: center;">' + blankForNull(value.UpdatedByName) + '</td>';
                DomainWiseColMaster_html += '<td style="text-wrap: nowrap;text-align: center;">' + blankForNull(value.UpdatedDate1) + '</td>';
                DomainWiseColMaster_html += '<td style="text-wrap: nowrap;text-align: center; display:none;">' + blankForNull(value.DomainID) + '</td>';
                DomainWiseColMaster_html += '<td style="text-wrap: nowrap;text-align: center; display:none;">' + blankForNull(value.NameColumn) + '</td>';
                DomainWiseColMaster_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#table_DomainWiseColMaster')) {
                DomainWiseColMaster_table.destroy();
            }
            $('#table_DomainWiseColMaster tbody').html(DomainWiseColMaster_html);

            DomainWiseColMaster_table = $('#table_DomainWiseColMaster').DataTable({
                dom: 'lftip',
                scrollX: true,
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
                "rowCallback": function (row, data) {
                    // Cell at index 5 in the row is 'Active'.
                    var val = data[3];
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

function btnSubmit_DomainWiseColConfg() {

    var FieldName = document.getElementById("track_FieldName").value;

    var Domain = document.getElementById("track_domain");
    var DomainID = Domain.options[Domain.selectedIndex].text;

    var IsNameColume = document.getElementById("chkNameColumn").value;

    if (FieldName == "") {
        alert("Please enter FieldName.");
        document.getElementById("track_FieldName").focus();
        return false;
    }

    if (DomainID == "Select") {
        alert("Please select  Domain.");
        document.getElementById("track_domain").focus();
        return false;
    }

    PageMethods.InsertDomainWiseField(FieldName, DomainID, IsNameColume, DomainWiseColConfg_OnSuccess, DomainWiseColConfg_OnError);
}

function DomainWiseColConfg_OnSuccess(result) {
    if (result > 0) {
        document.getElementById("tracking_errmsg").innerHTML = "Column configuration set successfully!";
    }
    else {
        document.getElementById("tracking_errmsg").innerHTML = "Oops! Error occured while setting configuration. Please contact administrator!";
    }
    document.getElementById("tracking_errmsg").style.color = 'red';
    $('#tracking_dverror').modal('show');
    return false;
}

function DomainWiseColConfg_OnError(error) {
    alert(error);
}

function EditDomainWise_ColConf(DFieldID, index) {
    DomainFieldID = DFieldID;
    var row = DomainWiseColMaster_table.row(index).data();

    document.getElementById("PopUptrack_FieldName").value = row[2];

    var select = document.getElementById("PopUptrack_domain");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#PopUptrack_domain").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "TrackingSheetConfiguration.aspx/GetDomain", dataType: "json", contentType: "application/json",
        success: function (res) {

            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                $("#PopUptrack_domain").append($("<option></option>").val(value.DomainID).html(value.DomainName));
            })
            $("#PopUptrack_domain").val(row[9]);
        }
    });

    if (row[10] == "True")
        $('#PopUpchkNameColumn').prop('checked', true);
    else
        $('#PopUpchkNameColumn').prop('checked', false);

    $('#PopUptrack_UpdateColConfiguration').modal('show');
}

function Update_ColConfiguration() {

    var PopUpFieldName = document.getElementById("PopUptrack_FieldName").value;

    var PopUpDomain = document.getElementById("PopUptrack_domain");
    var PopUpDomainID = PopUpDomain.options[PopUpDomain.selectedIndex].text;

    var IsNameColume = document.getElementById("chkNameColumn").value;

    if (PopUpFieldName == "") {
        alert("Please enter FieldName.");
        document.getElementById("track_FieldName").focus();
        return false;
    }

    if (PopUpDomainID == "Select") {
        alert("Please select  Domain.");
        document.getElementById("track_domain").focus();
        return false;
    }

    PageMethods.UpdateDomainWiseField(FieldName, DomainID, DomainFieldID, ColConfig_UpdateOnSuccess, ColConfig_UpdateOnError);
}

function ColConfig_UpdateOnSuccess(result) {
    if (result > 0) {
        $('#PopUp_DeleteColConfiguration').modal('hide');
        document.getElementById("tracking_errmsg").innerHTML = "Column configuration updated successfully!";
        $('#tracking_dverror').modal('show');
        return false;
    }
    else {
        $('#PopUp_DeleteColConfiguration').modal('hide');
        document.getElementById("tracking_errmsg").innerHTML = "Oops! Error occured while updated configuration. Please contact administrator!";
        document.getElementById("tracking_errmsg").style.color = 'red';
        $('#tracking_dverror').modal('show');
        return false;
    }
    return false;
}

function ColConfig_UpdateOnError(error) {
    alert(error);
}

function DeleteDomainWise_ColConf(DFieldID, index) {
    DomainFieldID = DFieldID;

    document.getElementById("lblConfigType").value = "Domain";

    $('#PopUp_DeleteColConfiguration').modal('show');
}

function delete_ColConfiguration() {

    if (document.getElementById("lblConfigType").value = "Domain") {
        PageMethods.DeleteFieldByDomain(DomainFieldID, ColConfig_DeleteOnSuccess, ColConfig_DeleteOnError);
        return false;
    }

    if (document.getElementById("lblConfigType").value = "Project") {
        PageMethods.DeleteFieldByDomainAndProject(DomainFieldID, ColConfig_DeleteOnSuccess, ColConfig_DeleteOnError);
        return false;
    }
}

function ColConfig_DeleteOnSuccess(result) {
    if (result > 0) {
        $('#PopUp_DeleteColConfiguration').modal('hide');
        document.getElementById("tracking_errmsg").innerHTML = "Column configuration deleted successfully!";
        $('#tracking_dverror').modal('show');
        return false;
    }
    else {
        $('#PopUp_DeleteColConfiguration').modal('hide');
        document.getElementById("tracking_errmsg").innerHTML = "Oops! Error occured while deleting configuration. Please contact administrator!";
        document.getElementById("tracking_errmsg").style.color = 'red';
        $('#tracking_dverror').modal('show');
        return false;
    }
    return false;
}

function ColConfig_DeleteOnError(error) {
    alert(error);
}


//----------------------- Column Configuration ----------------------- 

function BindProjectWiseColConfig_Domain() {

    var PrjColConfigdomainSelect = document.getElementById("track_PrjColConfigdomain");
    let PrjColConfigdomainoptions = PrjColConfigdomainSelect.getElementsByTagName('option');

    for (var i = PrjColConfigdomainoptions.length; i--;) {
        PrjColConfigdomainSelect.removeChild(PrjColConfigdomainoptions[i]);
    }

    $("#track_PrjColConfigdomain").append($("<option></option>").val("Select").html("Select"));

    $.ajax({
        type: "POST", url: "TrackingSheetConfiguration.aspx/GetAllDomainByConfigureField", dataType: "json", contentType: "application/json",
        success: function (res) {

            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {

                $("#track_PrjColConfigdomain").append($("<option></option>").val(value.DomainID).html(value.DomainName));
            })
        }
    });
}

function BindProjectWiseColConfig_Project(DomainID) {

    var PrjColConfigdomainSelect = document.getElementById("track_PrjColConfigProject");
    let PrjColConfigdomainoptions = PrjColConfigdomainSelect.getElementsByTagName('option');

    for (var i = PrjColConfigdomainoptions.length; i--;) {
        PrjColConfigdomainSelect.removeChild(PrjColConfigdomainoptions[i]);
    }

    $("#track_PrjColConfigProject").append($("<option></option>").val("Select").html("Select"));

    $.ajax({
        type: "POST", url: "TrackingSheetConfiguration.aspx/GetAllProjectByDomainWise", dataType: "json", data: "{DomainID:" + DomainID.value + "}", contentType: "application/json",
        success: function (res) {

            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {

                $("#track_PrjColConfigProject").append($("<option></option>").val(value.ProjectId).html(value.ProjectName));
            })
        }
    });
}

function BindProjectWiseColConfig_Field(ProjectID) {

    var DomainCtrl = document.getElementById("track_PrjColConfigdomain");

    var PrjColConfigFieldSelect = document.getElementById("track_PrjColConfigFieldName");
    let PrjColConfigFieldoptions = PrjColConfigFieldSelect.getElementsByTagName('option');

    for (var i = PrjColConfigFieldoptions.length; i--;) {
        PrjColConfigFieldSelect.removeChild(PrjColConfigFieldoptions[i]);
    }

    $("#track_PrjColConfigFieldName").append($("<option></option>").val("Select").html("Select"));

    $.ajax({
        type: "POST", url: "TrackingSheetConfiguration.aspx/GetFieldNameForProjectConfig", dataType: "json",
        data: "{DomainID:" + DomainCtrl.value + ",ProjectID:" + ProjectID.value + "}",
        contentType: "application/json",
        success: function (res) {

            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {

                $("#track_PrjColConfigFieldName").append($("<option></option>").val(value.DomainFieldID).html(value.FieldName));
            })
        }
    });
}

function BindProjectwiseColConfig_Grid(DomainID) {

    $('#load1').show();
    PrjWiseColMaster_html = '';

    $.ajax({
        url: "TrackingSheetConfiguration.aspx/GetAllFieldByProjectAndDomain",
        type: "POST",
        data: "{Domain:" + DomainID + "}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = JSON.parse(data.d);
            $.each(dataArray, function (index, value) {

                PrjWiseColMaster_html += '<tr>';
                PrjWiseColMaster_html += '<td style="text-align: center;" class=""><div class="btn-group">';
                PrjWiseColMaster_html += '<div class="btn-group">';
                PrjWiseColMaster_html += '<div type="button" data-toggle="dropdown" aria-expanded="false"><i style="color: dodgerblue; font-size:14px;" class="uil fs-0 me-2 uil-cog"></i>';
                PrjWiseColMaster_html += '<span class="sr-only"></span></div><div class="dropdown-menu" role="menu" style="">';

                PrjWiseColMaster_html += '<a class="dropdown-item" href="#!" id="editConf" onclick="EditProjectWise_ColConf(' + value.ProjectFieldId + ',' + index + ');"><span style="color: forestgreen;"><i class="uil fs-0 me-2 uil-pen" style="font-size:14px;"></i></span>&nbsp;&nbsp;Edit Configuration</a>';
                PrjWiseColMaster_html += '<a class="dropdown-item" href="#url" id="deleteConf" onclick="DeleteProjectWise_ColConf(' + value.ProjectFieldId + ',' + index + ');"><span style="color: brown;"><i class="uil fs-0 me-2 uil-trash"></i></span>&nbsp;&nbsp;Delete Configuration</a></div></div></td> ';

                PrjWiseColMaster_html += '<td style="text-align: center;">' + blankForNull(index + 1) + '</td>';
                PrjWiseColMaster_html += '<td style="text-align: center;">' + blankForNull(value.DomainName) + '</td>';
                PrjWiseColMaster_html += '<td style="text-align: center;">' + blankForNull(value.ProjectName) + '</td>';
                PrjWiseColMaster_html += '<td>' + blankForNull(value.Field) + '</td>';

                if (value.Visible == "True")
                    PrjWiseColMaster_html += '<td style="text-wrap: nowrap; text-align:center;"><input type="checkbox" disabled checked class="custom-checkbox" id="chkPrjVisible' + blankForNull(value.ProjectFieldId) + '"></td>';
                else
                    PrjWiseColMaster_html += '<td style="text-wrap: nowrap; text-align:center;"><input type="checkbox" disabled class="custom-checkbox" id="chkPrjVisible' + blankForNull(value.ProjectFieldId) + '"></td>';

                if (value.Editable == "True")
                    PrjWiseColMaster_html += '<td style="text-wrap: nowrap; text-align:center;"><input type="checkbox" disabled checked class="custom-checkbox" id="chkPrjEditable' + blankForNull(value.ProjectFieldId) + '"></td>';
                else
                    PrjWiseColMaster_html += '<td style="text-wrap: nowrap; text-align:center;"><input type="checkbox" disabled class="custom-checkbox" id="chkPrjEditable' + blankForNull(value.ProjectFieldId) + '"></td>';

                PrjWiseColMaster_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.AddedByName) + '</td>';
                PrjWiseColMaster_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.AddedDate1) + '</td>';
                PrjWiseColMaster_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.UpdatedByName) + '</td>';
                PrjWiseColMaster_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.UpdatedDate1) + '</td>';
                PrjWiseColMaster_html += '<td style="text-wrap: nowrap;text-align: center; display:none;">' + blankForNull(value.DomainId) + '</td>';
                PrjWiseColMaster_html += '<td style="text-wrap: nowrap;text-align: center; display:none;">' + blankForNull(value.ProjectId) + '</td>';
                PrjWiseColMaster_html += '<td style="text-wrap: nowrap;text-align: center; display:none;">' + blankForNull(value.FieldName) + '</td>';
                PrjWiseColMaster_html += '<td style="text-wrap: nowrap;text-align: center; display:none;">' + blankForNull(value.Visible) + '</td>';
                PrjWiseColMaster_html += '<td style="text-wrap: nowrap;text-align: center; display:none;">' + blankForNull(value.Editable) + '</td>';
                PrjWiseColMaster_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#table_PrjWiseColMaster')) {
                PrjWiseColMaster_table.destroy();
            }

            $('#table_PrjWiseColMaster tbody').html(PrjWiseColMaster_html);

            PrjWiseColMaster_table = $('#table_PrjWiseColMaster').DataTable({
                dom: 'lftip',
                scrollX: true,
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
                "rowCallback": function (row, data) {
                    // Cell at index 5 in the row is 'Active'.
                    var val = data[3];
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

function btnSubmit_PrjColumnConfig() {

    var FieldName = document.getElementById("track_FieldName").value;

    var Domain = document.getElementById("track_PrjColConfigdomain");
    var DomainID = Domain.options[Domain.selectedIndex].text;

    var Project = document.getElementById("track_PrjColConfigProject");
    var ProjectID = Project.options[Project.selectedIndex].text;

    var FieldName = document.getElementById("track_PrjColConfigFieldName");
    var FieldNameID = FieldName.options[FieldName.selectedIndex].text;

    var IsVisible = document.getElementById("track_PrjColConfigVisible").value;
    var IsEditable = document.getElementById("track_PrjColConfigEditable").value;

    if (DomainID == "Select") {
        alert("Please select  Domain.");
        document.getElementById("track_PrjColConfigdomain").focus();
        return false;
    }
    if (ProjectID == "Select") {
        alert("Please select Project.");
        document.getElementById("track_PrjColConfigProject").focus();
        return false;
    }
    if (FieldName == "Select") {
        alert("Please select FieldName.");
        document.getElementById("track_PrjColConfigFieldName").focus();
        return false;
    }
    PageMethods.InsertProjectWiseField(DomainID, ProjectID, FieldNameID, IsVisible, IsEditable, DomainWiseColConfg_OnSuccess, DomainWiseColConfg_OnError);
}

function ProjectWiseColConfg_OnSuccess(result) {
    if (result > 0) {
        document.getElementById("tracking_errmsg").innerHTML = "Column configuration set successfully!";
    }
    else {
        document.getElementById("tracking_errmsg").innerHTML = "Oops! Error occured while deleting configuration. Please contact administrator!";
    }
    document.getElementById("tracking_errmsg").style.color = 'red';
    $('#tracking_dverror').modal('show');
    return false;
}

function ProjectWiseColConfg_OnError(error) {
    alert(error);
}

function Update_ColConfiguration() {

    var PopUpFieldName = document.getElementById("PopUptrack_FieldName").value;

    var PopUpDomain = document.getElementById("PopUptrack_domain");
    var PopUpDomainID = PopUpDomain.options[PopUpDomain.selectedIndex].text;

    var IsNameColume = document.getElementById("chkNameColumn").value;

    if (PopUpFieldName == "") {
        alert("Please enter FieldName.");
        document.getElementById("track_FieldName").focus();
        return false;
    }

    if (PopUpDomainID == "Select") {
        alert("Please select  Domain.");
        document.getElementById("track_domain").focus();
        return false;
    }

    PageMethods.UpdateDomainWiseField(FieldName, DomainID, DomainFieldID, ColConfig_UpdateOnSuccess, ColConfig_UpdateOnError);
}

function ColConfig_UpdateOnSuccess(result) {
    if (result > 0) {
        $('#PopUp_DeleteColConfiguration').modal('hide');
        document.getElementById("tracking_errmsg").innerHTML = "Column configuration updated successfully!";
        $('#tracking_dverror').modal('show');
        return false;
    }
    else {
        $('#PopUp_DeleteColConfiguration').modal('hide');
        document.getElementById("tracking_errmsg").innerHTML = "Oops! Error occured while updated configuration. Please contact administrator!";
        document.getElementById("tracking_errmsg").style.color = 'red';
        $('#tracking_dverror').modal('show');
        return false;
    }
    return false;
}

function ColConfig_UpdateOnError(error) {
    alert(error);
}

function DeleteProjectWise_ColConf(ProjectFieldId, index) {
    ProjectFieldID = ProjectFieldId;

    document.getElementById("lblConfigType").value = "Project";

    $('#PopUp_DeleteColConfiguration').modal('show');
}

function EditProjectWise_ColConf(PFieldID, index) {

    // alert(PFieldID);

    ProjectFieldID = PFieldID;
    var row = PrjWiseColMaster_table.row(index).data();

    if (row[14] == "True") {
        $('#PopUptrack_PrjColConfigVisible').prop('checked', true);
    }
    else {
        $('#PopUptrack_PrjColConfigVisible').prop('checked', false);
    }

    if (row[15] == "True") {
        $('#PopUptrack_PrjColConfigEditable').prop('checked', true);
    }
    else {
        $('#PopUptrack_PrjColConfigEditable').prop('checked', false);
    }

    var select = document.getElementById("PopUptrackProject_domain");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#PopUptrackProject_domain").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "TrackingSheetConfiguration.aspx/GetDomain", dataType: "json", contentType: "application/json",
        success: function (res) {

            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                $("#PopUptrackProject_domain").append($("<option></option>").val(value.DomainID).html(value.DomainName));
            })
            $("#PopUptrackProject_domain").val(row[11]);
        }
    });


    var selectPrj = document.getElementById("PopUptrackProject_project");
    let optionsPrj = selectPrj.getElementsByTagName('option');

    for (var i = optionsPrj.length; i--;) {
        selectPrj.removeChild(optionsPrj[i]);
    }

    $("#PopUptrackProject_project").append($("<option></option>").val("Select").html("Select"));
    $.ajax({
        type: "POST", url: "TrackingSheetConfiguration.aspx/GetAllProject", dataType: "json",
        contentType: "application/json",

        success: function (res) {

            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (data, value) {

                $("#PopUptrackProject_project").append($("<option></option>").val(value.ProjectID).html(value.ProjectName));
            })

            $("#PopUptrackProject_project").val(row[12]);
        }
    });

    var selectField = document.getElementById("PopUptrackProject_FieldName");
    let optionsField = selectField.getElementsByTagName('option');

    for (var i = optionsField.length; i--;) {
        selectField.removeChild(optionsField[i]);
    }

    $("#PopUptrackProject_FieldName").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "TrackingSheetConfiguration.aspx/GetAllTrackingSheetsColumnsbyProject", dataType: "json",
        data: "{ProjectFieldID:" + ProjectFieldID + "}",
        contentType: "application/json",
        success: function (res) {

            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {

                $("#PopUptrackProject_FieldName").append($("<option></option>").val(value.FieldName).html(value.Field));
            })

            $("#PopUptrackProject_FieldName").val(row[13]);
        }
    });

    $('#PopUptrack_UpdateProjectColConfiguration').modal('show');
}


//----------------------- Column Mapping ----------------------- 

function BindColumnMapping_Grid() {

    $('#load1').show();
    ColumnMapping_html = '';

    $.ajax({
        url: "TrackingSheetConfiguration.aspx/GetAllColumnMappingDetails",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = JSON.parse(data.d);
            $.each(dataArray, function (index, value) {

                ColumnMapping_html += '<tr>';
                ColumnMapping_html += '<td style="text-align: center;" class=""><div class="btn-group">';
                ColumnMapping_html += '<div class="btn-group">';
                ColumnMapping_html += '<div type="button" data-toggle="dropdown" aria-expanded="false"><i style="color: dodgerblue; font-size:14px;" class="uil fs-0 me-2 uil-cog"></i>';
                ColumnMapping_html += '<span class="sr-only"></span></div><div class="dropdown-menu" role="menu" style="">';

                ColumnMapping_html += '<a class="dropdown-item" href="#!" id="editColMapConf" onclick="EditColumnMapping_Conf(' + value.ColumnMapID + ',' + index + ');"><span style="color: forestgreen;"><i class="uil fs-0 me-2 uil-pen" style="font-size:14px;"></i></span>&nbsp;&nbsp;Edit Configuration</a>';
                ColumnMapping_html += '<a class="dropdown-item" href="#url" id="deleteColMapConf" onclick="DeleteColumnMapping_Conf(' + value.ColumnMapID + ',' + index + ');"><span style="color: brown;"><i class="uil fs-0 me-2 uil-trash"></i></span>&nbsp;&nbsp;Delete Configuration</a></div></div></td> ';

                ColumnMapping_html += '<td style="text-align: center;">' + blankForNull(index + 1) + '</td>';
                ColumnMapping_html += '<td style="text-align: center;">' + blankForNull(value.Project) + '</td>';
                ColumnMapping_html += '<td style="text-align: center;">' + blankForNull(value.ColumnName) + '</td>';
                ColumnMapping_html += '<td style="width:200px;">' + blankForNull(value.Field) + '</td>';
                ColumnMapping_html += '<td style="text-align: center;">' + blankForNull(value.SequenceNo) + '</td>';

                if (value.Billing == "True")
                    ColumnMapping_html += '<td style="text-wrap: nowrap; text-align:center;"><input type="checkbox" disabled checked class="custom-checkbox" id="chkMapBilling' + blankForNull(value.ColumnMapID) + '"></td>';
                else
                    ColumnMapping_html += '<td style="text-wrap: nowrap; text-align:center;"><input type="checkbox" disabled class="custom-checkbox" id="chkMapBilling' + blankForNull(value.ColumnMapID) + '"></td>';

                if (value.Import == "True")
                    ColumnMapping_html += '<td style="text-wrap: nowrap; text-align:center;"><input type="checkbox" disabled checked class="custom-checkbox" id="chkMapImport' + blankForNull(value.ColumnMapID) + '"></td>';
                else
                    ColumnMapping_html += '<td style="text-wrap: nowrap; text-align:center;"><input type="checkbox" disabled class="custom-checkbox" id="chkMapImport' + blankForNull(value.ColumnMapID) + '"></td>';

                if (value.Unique == "True")
                    ColumnMapping_html += '<td style="text-wrap: nowrap; text-align:center;"><input type="checkbox" disabled checked class="custom-checkbox" id="chkMapUnique' + blankForNull(value.ColumnMapID) + '"></td>';
                else
                    ColumnMapping_html += '<td style="text-wrap: nowrap; text-align:center;"><input type="checkbox" disabled class="custom-checkbox" id="chkMapUnique' + blankForNull(value.ColumnMapID) + '"></td>';

                ColumnMapping_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.DateFormat) + '</td>';
                ColumnMapping_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.FieldLength) + '</td>';

                ColumnMapping_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.AddedByName) + '</td>';
                ColumnMapping_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.AddedDate1) + '</td>';
                ColumnMapping_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.UpdatedByName) + '</td>';
                ColumnMapping_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.UpdatedDate1) + '</td>';
                ColumnMapping_html += '<td style="text-wrap: nowrap;text-align: center; display:none;">' + blankForNull(value.ProjectID) + '</td>';
                ColumnMapping_html += '<td style="text-wrap: nowrap;text-align: center; display:none;">' + blankForNull(value.ProjectFieldID) + '</td>';
                ColumnMapping_html += '<td style="text-wrap: nowrap;text-align: center; display:none;">' + blankForNull(value.ColumnID) + '</td>';
                ColumnMapping_html += '<td style="text-wrap: nowrap;text-align: center; display:none;">' + blankForNull(value.Billing) + '</td>';
                ColumnMapping_html += '<td style="text-wrap: nowrap;text-align: center; display:none;">' + blankForNull(value.Import) + '</td>';
                ColumnMapping_html += '<td style="text-wrap: nowrap;text-align: center; display:none;">' + blankForNull(value.Unique) + '</td>';
                ColumnMapping_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#table_ColumnMapping')) {
                ColumnMapping_table.destroy();
            }

            $('#table_ColumnMapping tbody').html(ColumnMapping_html);

            ColumnMapping_table = $('#table_ColumnMapping').DataTable({
                dom: 'lftip',
                scrollX: true,
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
                "rowCallback": function (row, data) {
                    // Cell at index 5 in the row is 'Active'.
                    var val = data[3];
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

function BindColMapping_Project() {

    var clmMapPrjSelect = document.getElementById("track_ColumnMappingProject");
    let clmMapPrjoptions = clmMapPrjSelect.getElementsByTagName('option');

    for (var i = clmMapPrjoptions.length; i--;) {
        clmMapPrjSelect.removeChild(clmMapPrjoptions[i]);
    }

    $("#track_ColumnMappingProject").append($("<option></option>").val("Select").html("Select"));

    $.ajax({
        type: "POST", url: "TrackingSheetConfiguration.aspx/GetAllProjectByDefineField", dataType: "json", contentType: "application/json",
        success: function (res) {

            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {

                $("#track_ColumnMappingProject").append($("<option></option>").val(value.ProjectId).html(value.ProjectName));
            })
        }
    });
}

function BindColMapping_Column(ProjectID) {

    var clmMapColSelect = document.getElementById("track_ColumnMappingColumn");
    let clmMapColoptions = clmMapColSelect.getElementsByTagName('option');

    for (var i = clmMapColoptions.length; i--;) {
        clmMapColSelect.removeChild(clmMapColoptions[i]);
    }

    $("#track_ColumnMappingColumn").append($("<option></option>").val("Select").html("Select"));

    $.ajax({
        type: "POST", url: "TrackingSheetConfiguration.aspx/GetAllColumnByProject", dataType: "json",
        data: "{ProjectID:" + ProjectID.value + "}",
        contentType: "application/json",
        success: function (res) {

            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {

                $("#track_ColumnMappingColumn").append($("<option></option>").val(value.ColumnId).html(value.ColumnName));
            })
        }
    });
    BindColMapping_Field(ProjectID.value);
    BindColMapping_Sequence(ProjectID.value);
}

function BindColMapping_Field(ProjectID) {

    var clmMapFieldSelect = document.getElementById("track_ColumnMappingFieldName");
    let clmMapFieldoptions = clmMapFieldSelect.getElementsByTagName('option');

    for (var i = clmMapFieldoptions.length; i--;) {
        clmMapFieldSelect.removeChild(clmMapFieldoptions[i]);
    }

    $("#track_ColumnMappingFieldName").append($("<option></option>").val("Select").html("Select"));

    $.ajax({
        type: "POST", url: "TrackingSheetConfiguration.aspx/GetAllFieldNameByProject", dataType: "json",
        data: "{ProjectID:" + ProjectID + "}",
        contentType: "application/json",
        success: function (res) {

            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {

                $("#track_ColumnMappingFieldName").append($("<option></option>").val(value.ProjectFieldId).html(value.Field));
            })
        }
    });
}

function BindColMapping_Sequence(ProjectID) {

    var clmMapSeqSelect = document.getElementById("track_ColumnMappingSequence");
    let clmMapSeqoptions = clmMapSeqSelect.getElementsByTagName('option');

    for (var i = clmMapSeqoptions.length; i--;) {
        clmMapSeqSelect.removeChild(clmMapSeqoptions[i]);
    }

    $("#track_ColumnMappingSequence").append($("<option></option>").val("Select").html("Select"));

    $.ajax({
        type: "POST", url: "TrackingSheetConfiguration.aspx/GetSequenceNoByProject", dataType: "json",
        data: "{ProjectID:" + ProjectID + "}",
        contentType: "application/json",
        success: function (res) {

            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {

                $("#track_ColumnMappingSequence").append($("<option></option>").val(value.Sequence).html(value.Sequence));
            })
        }
    });
}

function btnSubmit_ColumnMapping() {

    var FieldName = document.getElementById("track_FieldName").value;

    var Domain = document.getElementById("track_PrjColConfigdomain");
    var DomainID = Domain.options[Domain.selectedIndex].text;

    var Project = document.getElementById("track_PrjColConfigProject");
    var ProjectID = Project.options[Project.selectedIndex].text;

    var FieldName = document.getElementById("track_PrjColConfigFieldName");
    var FieldNameID = FieldName.options[FieldName.selectedIndex].text;

    var IsVisible = document.getElementById("track_PrjColConfigVisible").value;
    var IsEditable = document.getElementById("track_PrjColConfigEditable").value;

    if (DomainID == "Select") {
        alert("Please select  Domain.");
        document.getElementById("track_PrjColConfigdomain").focus();
        return false;
    }
    if (ProjectID == "Select") {
        alert("Please select Project.");
        document.getElementById("track_PrjColConfigProject").focus();
        return false;
    }
    if (FieldName == "Select") {
        alert("Please select FieldName.");
        document.getElementById("track_PrjColConfigFieldName").focus();
        return false;
    }
    PageMethods.InsertColumnMapping(DomainID, ProjectID, FieldNameID, IsVisible, IsEditable, DomainWiseColConfg_OnSuccess, DomainWiseColConfg_OnError);
}

function ColMapping_OnSuccess(result) {
    if (result > 0) {
        document.getElementById("tracking_errmsg").innerHTML = "Column configuration set successfully!";
    }
    else {
        document.getElementById("tracking_errmsg").innerHTML = "Oops! Error occured while deleting configuration. Please contact administrator!";
    }
    document.getElementById("tracking_errmsg").style.color = 'red';
    $('#tracking_dverror').modal('show');
    return false;
}

function ColMapping_OnError(error) {
    alert(error);
}


function addNewColumn() {

    //  PageMethods.InsertNewColumn(addNewColumn_OnSuccess, addNewColumn_OnError);
}

function addNewColumn_OnSuccess(result) {
    if (result > 0) {
        document.getElementById("tracking_errmsg").innerHTML = "New column added successfully!";
        $('#tracking_dverror').modal('show');
        return false;
    }
    else {
        document.getElementById("tracking_errmsg").innerHTML = "Oops! Error occured while updated configuration. Please contact administrator!";
        document.getElementById("tracking_errmsg").style.color = 'red';
        $('#tracking_dverror').modal('show');
        return false;
    }
    return false;
}

function addNewColumn_OnError(error) {
    alert(error);
}