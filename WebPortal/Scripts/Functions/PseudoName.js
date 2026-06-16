
var updatePseudoName_table;
var updatePseudoName_html;
var popUp_EmpConfigID;


function bindPseudoNameGrid() {

    $('#load1').show();
    updatePseudoName_html = '';
    $.ajax({
        url: "PseudoName.aspx/GetAllPsuedoName",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);
            $.each(dataArray, function (index, value) {
                updatePseudoName_html += '<tr>';
                updatePseudoName_html += '<td style="text-align:center;"><a class="dropdown-item" href="#!" id="pseudoName_Actions" onclick="pseudoName_Delete(' + blankForNull(value.EmpConfigrationID) + ',' + index + ');"><span style="color: dodgerblue;"><i class="uil-trash-alt"></i></span></a></td>';
                updatePseudoName_html += '<td style="text-wrap: nowrap;text-align:center;">' + blankForNull((index + 1)) + '</td>';
                updatePseudoName_html += '<td style="text-wrap: nowrap; display:none;">' + blankForNull(value.EmpConfigrationID) + '</td>';
                updatePseudoName_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.LocationCode) + '</td>';
                updatePseudoName_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Code) + '</td>';
                updatePseudoName_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Name) + '</td>';
                updatePseudoName_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.PsuedoName) + '</td>';
                updatePseudoName_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.AddedByName) + '</td>';
                updatePseudoName_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.AddedDate1) + '</td>';
                updatePseudoName_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#table_updatePseudoName')) {
                updatePseudoName_table.destroy();
            }
            $('#table_updatePseudoName tbody').html(updatePseudoName_html);
            //else
            updatePseudoName_table = $('#table_updatePseudoName').DataTable({
                dom: 'lBftip',
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

                buttons: [
                    {
                        extend: 'excelHtml5',
                        text: 'Export Excel',
                        title: 'Pseudo Name Report',
                        exportOptions: { columns: ':visible:not(:first-child)' }
                    }
                ],

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


function bindEmployee() {

    var select = document.getElementById("pseudoName_Employee");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#pseudoName_Employee").append($("<option></option>").val("Select").html("Select Employee"));
    $("#pseudoName_Employee").append($("<option></option>").val("Other").html("Other"));

    $.ajax({
        type: "POST",
        url: "PseudoName.aspx/GetAllUsersUpdatePsuedoName",
        dataType: "json", contentType: "application/json",

        success: function (res) {

            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (data, value) {

                $("#pseudoName_Employee").append($("<option></option>").val(value.Code).html(value.Fullname));
            })
        }
    });
}


function pseudoName_Delete(id, index) {

    if (confirm("Are you sure you want to delete record?") == true) {

        PageMethods.DeletePsuedoName(id, OnSuccess_PNameDelete, OnError_PNameDelete);
        return false;
    }
    else
        return false;
}

function OnSuccess_PNameDelete(result) {
    if (result > 0) {
        alert("Record deleted successfully");
        location.reload();
        return false;
    }
    else {
        alert("Oops! Error occured while deleting record. Please contact administrator");
        return false;
    }
}

function OnError_PNameDelete(error) {

    alert(error.responseText);
}

function displayCompany(id) {

    var otherEmp = id.options[id.selectedIndex].text;

    if (otherEmp == "Other") {
        tdcompField.style.display = '';
    }
    else {
        tdcompField.style.display = 'none';
    }
}

function pseudoName_submit() {

    var pseudoName_Employee = document.getElementById("pseudoName_Employee");
    var Code = pseudoName_Employee.options[pseudoName_Employee.selectedIndex].value;

    var Pname = document.getElementById("pseudoName_Name").value;
    var Pcompany = document.getElementById("pseudoName_Company").value;

    var pseudoName_Location = document.getElementById("pseudoName_Location");
    var Plocation = pseudoName_Location.options[pseudoName_Location.selectedIndex].value;

    if (Code == "Select") {
        alert("Please select Employee.");
        document.getElementById("pseudoName_Employee").focus();
        return false;
    }


    if (Pname == " " || Pname == "") {
        alert("Please enter Pseudo Name.");
        document.getElementById("pseudoName_Name").focus();
        return false;
    }

    if (Code == "Other" && (Pcompany == "" || Pcompany == " ")) {
        alert("Please enter Company.");
        document.getElementById("pseudoName_Company").focus();
        return false;
    }

    if (Plocation == "Select") {
        alert("Please select Location.");
        document.getElementById("pseudoName_Location").focus();
        return false;
    }

    PageMethods.InseartPsuedoName(Code, Pname, Pcompany, Plocation, OnSuccess_PNameSubmit, OnError_PNameSubmit);
    return false;
}

function OnSuccess_PNameSubmit(result) {
    if (result > 0) {
        alert("Pseudo name set successfully");
        location.reload();
        return false;
    }
    else {
        alert("Oops! Error occured while submitting data. Please contact administrator");
        return false;
    }
}

function OnError_PNameSubmit(error) {

    alert(error.responseText);
}