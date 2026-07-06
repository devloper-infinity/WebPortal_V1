var followup_table;
var html = '';
var followup_EmpID;


var absfollowup_table;
var abshtml = '';
var absfollowup_EmpID;
var resigid;

function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

function Followup_BindYear() {
    var start = new Date().getFullYear();

    var select = document.getElementById("followup_year");
    let options = select.getElementsByTagName('option');
   
    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#followup_year").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#followup_year").append($("<option></option>").val(i).html(i));
    }
}


function Followup_BindYear1() {
    var start = new Date().getFullYear();

    var selectYear = document.getElementById("absfollowup_to");
    let optionsYear = selectYear.getElementsByTagName('option');

    for (var i = optionsYear.length; i--;) {
        selectYear.removeChild(optionsYear[i]);
    }

    $("#absfollowup_to").append($("<option></option>").val("Select").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#absfollowup_to").append($("<option></option>").val(i).html(i));
    }
}


function followup_Submit() {
    var ddlmonth = document.getElementById("followup_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("followup_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }
    $('#load1').show();
    html = '';
    $.ajax({
        url: "NewJoineeHRFollowup.aspx/GetFollowupRecords",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            var date;
            $.each(dataArray, function (index, value) {

                if (value.AddedDate != null)
                    date = eval(value.AddedDate.replace(/\/Date\((\d+)\)\//gi, "new Date($1).toLocaleDateString(\"en-US\")"));
                else
                    date = '';
                html += '<tr>';
                html += '<td style="text-wrap: nowrap;display:none;">' + blankForNull(value.EmployeeID) + '</td>';
                html += '<td style="text-align:center;"><a class="dropdown-item" href="#!" id="Actions" onclick="followup_AddRemark(' + value.EmployeeID + ',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-pen"></i></span></a></td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Code) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.FullName) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.JoiningDate) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Branch) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.CellNo) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Designation) + '</td>';
                html += '<td>' + blankForNull(value.DomainName) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ReportingManager) + '</td>';
                html += '<td style="text-wrap: wrap;">' + blankForNull(value.Remark) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.AddedByName) + '</td>';
                html += '<td>' + blankForNull(date) + '</td>';
                html += '</tr>';


            });

            if ($.fn.dataTable.isDataTable('#followup_table')) {
                followup_table.destroy();
            }
            $('#followup_table tbody').html(html);
            //else
            followup_table = $('#followup_table').DataTable({
                dom: 'lBftip',
              
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
                    var val = data[3];
                },

                buttons: [
                    {
                        extend: 'excelHtml5', title: 'New Joinee HR Follow up', autoFilter: true,
                        exportOptions: {
                            columns: [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
                        }
                    },
                ],
            });

            //$('#fnalize tbody').on('click', 'tr', function () {
            //    row = table.row(this).data();
            //});
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}

function absfollowup_Submit() {
    var month = document.getElementById("absfollowup_from").value
    var year = document.getElementById("absfollowup_to").value;
    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }
    $('#load1').show();
    abshtml = '';
    $.ajax({
        url: "AbscondingEmployeeFollowup.aspx/GetFollowupRecords",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            var date;
            $.each(dataArray, function (index, value) {

                if (value.AddedDate != null)
                    date = eval(value.AddedDate.replace(/\/Date\((\d+)\)\//gi, "new Date($1).toLocaleDateString(\"en-US\")"));
                else
                    date = '';
                var abdate = eval(value.AbscondingDate.replace(/\/Date\((\d+)\)\//gi, "new Date($1).toLocaleDateString(\"en-US\")"));
                var FDate = '';
                if (value.FDate != null)
                    FDate = eval(value.FDate.replace(/\/Date\((\d+)\)\//gi, "new Date($1).toLocaleDateString(\"en-US\")"));
                else
                    FDate = '';
                abshtml += '<tr>';
                abshtml += '<td style="text-wrap: nowrap;display:none;">' + blankForNull(value.EmployeeID) + '</td>';
                abshtml += '<td style="text-align:center;"><a class="dropdown-item" href="#!" id="Actions" onclick="absfollowup_AddRemark(' + value.EmployeeID + ',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-pen"></i></span></a></td>';
                abshtml += '<td style="text-wrap: nowrap;">' + blankForNull(value.Code) + '</td>';
                abshtml += '<td style="text-wrap: nowrap;">' + blankForNull(value.Name) + '</td>';
                abshtml += '<td style="text-wrap: nowrap;">' + blankForNull(value.JoiningDate) + '</td>';
                abshtml += '<td style="text-wrap: nowrap;">' + blankForNull(value.BranchName) + '</td>';
                abshtml += '<td style="text-wrap: nowrap;">' + blankForNull(value.DepartmentName) + '</td>';
                abshtml += '<td style="text-wrap: nowrap;">' + blankForNull(value.DesignationName) + '</td>';
                abshtml += '<td>' + blankForNull(value.DomainName) + '</td>';
                abshtml += '<td style="text-wrap: nowrap;">' + blankForNull(value.ProjectManagerName) + '</td>';
                abshtml += '<td style="text-wrap: nowrap;">' + blankForNull(abdate) + '</td>';
                abshtml += '<td style="text-wrap: wrap;">' + blankForNull(value.FRemark) + '</td>';
                abshtml += '<td>' + blankForNull(FDate) + '</td>';
                abshtml += '<td style="display:none;">' + blankForNull(value.ResignationId) + '</td>';
                abshtml += '</tr>';


            });

            if ($.fn.dataTable.isDataTable('#absfollowup_table')) {
                absfollowup_table.destroy();
            }
            $('#absfollowup_table tbody').html(abshtml);
            //else
            absfollowup_table = $('#absfollowup_table').DataTable({
                dom: 'lBftip',
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
                    $("#absfollowup_table").wrap("<div style='overflow:auto; width:100%;position:relative;'></div>");
                },
                "rowCallback": function (row, data) {
                    var val = data[3];
                },

                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Absconding Employees Follow up', autoFilter: true,
                        exportOptions: {
                            columns: [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
                        }
                    },
                ],
            });

            //$('#fnalize tbody').on('click', 'tr', function () {
            //    row = table.row(this).data();
            //});
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}

function followup_AddRemark(EmployeeID, Index) {
    var row = followup_table.row(Index).data();
    document.getElementById("followup_empname").innerHTML = row[2] + ' : ' + row[3];
    followup_EmpID = row[2];
    $('#followupremarkpopup').modal('show');
}

function absfollowup_AddRemark(EmployeeID, Index) {
    var row = absfollowup_table.row(Index).data();
    document.getElementById("absfollowup_empname").innerHTML = row[2] + ' : ' + row[3];
    followup_EmpID = row[0];
    resigid = row[13];
    $('#absfollowupremarkpopup').modal('show');
}

function followup_updateremark() {
    var remark = document.getElementById("followup_remark").value;
    PageMethods.InsertFollowupRemarks(followup_EmpID, remark, followup_Onsuccess, followup_OnError);
    return false;
}

function absfollowup_updateremark() {
    var remark = document.getElementById("absfollowup_remark").value;
    var date = document.getElementById("absfollowup_date").value;
    if (date == "") {
        alert("Please select date");
        return false;
    }
    if (remark == "") {
        alert("Please enter ");
        return false;
    }
    PageMethods.InsertAbscondedEmpsFollowUp(resigid, followup_EmpID, remark, date, absfollowup_Onsuccess, absfollowup_OnError);
    return false;
}

function followup_Onsuccess(result) {
    if (result > 0) {
        $('#followupremarkpopup').modal('hide');
        document.getElementById("followup_errmsg").innerHTML = "Observations updated successfully!";
        document.getElementById("followup_errmsg").style.color = 'green';
        $('#followup_dverror').modal('show');
    }
    else {
        $('#followupremarkpopup').modal('hide');
        document.getElementById("followup_errmsg").innerHTML = "Oops! Error occured while updating observations. Please contact administrator!";
        document.getElementById("followup_errmsg").style.color = 'red';
        $('#followup_dverror').modal('show');
        return false;
    }
    return false;
}

function absfollowup_Onsuccess(result) {
    if (result > 0) {
        $('#absfollowupremarkpopup').modal('hide');
        document.getElementById("absfollowup_errmsg").innerHTML = "Remark updated successfully!";
        document.getElementById("absfollowup_errmsg").style.color = 'green';
        $('#absfollowup_dverror').modal('show');
    }
    else {
        $('#absfollowupremarkpopup').modal('hide');
        document.getElementById("absfollowup_errmsg").innerHTML = "Oops! Error occured while updating remark. Please contact administrator!";
        document.getElementById("absfollowup_errmsg").style.color = 'red';
        $('#absfollowup_dverror').modal('show');
        return false;
    }
    return false;
}

function followup_OnError(error) {
    alert(error);
}

function absfollowup_OnError(error) {
    alert(error);
}

function followup_Message() {
    followup_Submit();
    followup_EmpID = '';
    document.getElementById("followup_remark").value = '';
    $('#followup_dverror').modal('hide');
    $('#followupremarkpopup').modal('hide');
}

function absfollowup_Message() {
    absfollowup_Submit();
    followup_EmpID = '';
    document.getElementById("absfollowup_remark").value = '';
    document.getElementById("absfollowup_date").value = '';
    $('#absfollowup_dverror').modal('hide');
    $('#absfollowupremarkpopup').modal('hide');
}
