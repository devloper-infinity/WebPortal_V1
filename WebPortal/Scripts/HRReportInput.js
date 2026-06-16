
var dropoutemployee_table;
var allresigned_table;
var dropoutemployee_html;
var allresigned_html;
var bankapproval_table;
var bankapproval_html;
var bankpending_table;
var bankpending_html;
var socialsite_table;
var socialsite_html;
var glassrating_table;
var glassrating_html;
var glasscomp_table;
var glasscomp_html;


var newcompany_table;
var newcompany_html;

function socialsite_bindusers() {

    var select = document.getElementById("socialsite_employee");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#socialsite_employee").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "HRReportInput.aspx/GetAllEmployees", dataType: "json", contentType: "application/json",
        success: function (res1) {
            var dataArray = JSON.parse(res1.d);
            $.each(dataArray, function (data1, value1) {
                $("#socialsite_employee").append($("<option></option>").val(value1.EmployeeID).html(value1.FullName));
            });
        }
    });
}

function newCompany_BindGrid() {

    $('#load1').show();

    newcompany_html = '';
    $.ajax({
        url: "HRReportInput.aspx/GetAllGlassDoorCompetitors",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = JSON.parse(data.d);
            $.each(dataArray, function (index, value) {
                newcompany_html += '<tr>';
                newcompany_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(index + 1) + '</td>';
                newcompany_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.CompanyName) + '</td>';
                newcompany_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.AddedByName) + '</td>';
                newcompany_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.AddedDate1) + '</td>';
                newcompany_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#table_newcompany')) {
                newcompany_table.destroy();
            }
            $('#table_newcompany tbody').html(newcompany_html);
            //else
            newcompany_table = $('#table_newcompany').DataTable({
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
                    jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');
                },

                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Glass Door Competitors', autoFilter: true,
                        exportOptions: {
                            columns: [0, 1, 2, 3],
                        }
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

function newcompany_submit() {

    var newcompany = document.getElementById("newcompany_add").value;

    if (newcompany == "") {
        alert("Please enter company");
        return false;
    }

    PageMethods.InsertCompetitor(newcompany, newcompany_OnSuccess, newcompany_OnError);
    return false;
}

function newcompany_OnSuccess(result) {
    if (result > 0) {
        document.getElementById("socialsite_errmsg").innerHTML = "Data saved successfully!";
        $('#socialsite_dverror').modal('show');
    }
    else {
        document.getElementById("socialsite_errmsg").innerHTML = "Record already exists!";
        document.getElementById("socialsite_errmsg").style.color = 'red';
        $('#socialsite_dverror').modal('show');
        return false;
    }
    return false;
}

function newcompany_OnError(error) {
    alert(error);
}

