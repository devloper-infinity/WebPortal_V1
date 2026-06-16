var letterhead_table;
var html = '';
var followup_EmpID;

function Letterhead_BindCodes() {
    var select = document.getElementById("letterhead_employee");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#letterhead_employee").append($("<option></option>").val("").html("Select"));
    
    $.ajax({
        type: "POST", url: "LetterHeadManagement.aspx/GetAllUsers", dataType: "json", contentType: "application/json",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                $("#letterhead_employee").append($("<option></option>").val(value.Code).html(value.Code1));
            })
        }
    });
}

function letterhead_submit() {
    var ddlcode = document.getElementById("letterhead_employee");
    var code = ddlcode.options[ddlcode.selectedIndex].value;
    var letterhead_date = document.getElementById("letterhead_date").value;
    var letterhead_reason = document.getElementById("letterhead_reason").value;
    var letterhead_count = document.getElementById("letterhead_count").value;

    PageMethods.InsertLetterHeadCount(code, letterhead_date, letterhead_reason, letterhead_count, letterhead_OnSuccess, letterhead_OnError);
    return false;
}

function Letterhead_BindGrid() {
    $('#load1').show();
    html = '';
    var FromDate = ''
    var ToDate = ''
    $.ajax({
        url: "LetterHeadManagement.aspx/BindGrid",
        type: "POST",
        data: "{FromDate:'" + FromDate + "', ToDate:'" + ToDate + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                html += '<tr>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Date) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Code) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Name) + '</td>';
                html += '<td>' + blankForNull(value.Branch) + '</td>';
                html += '<td>' + blankForNull(value.Domain) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Reason) + '</td>';
                html += '<td>' + blankForNull(value.Count) + '</td>';
                html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#letterhead_table')) {
                letterhead_table.destroy();
            }
            $('#letterhead_table tbody').html(html);
            //else
            letterhead_table = $('#letterhead_table').DataTable({
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

                initComplete: function () {
                    $('#load1').hide();

                },
                "rowCallback": function (row, data) {
                    // Cell at index 5 in the row is 'Active'.
                    var val = data[3];
                },

                buttons: [

                    {
                        extend: 'excelHtml5', title: 'Letterhead Count', autoFilter: true,
                        exportOptions: {
                            columns: [0, 1, 2, 3, 4, 5, 6]
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

function letterhead_OnSuccess(result) {
    if (result > 0) {
        document.getElementById("letterhead_errmsg").innerHTML = "Data added successfully!";
        $('#letterhead_dverror').modal('show');
    }
    else {
        document.getElementById("letterhead_errmsg").innerHTML = "Oops! Error occured while adding data. Please contact administrator!";
        document.getElementById("letterhead_errmsg").style.color = 'red';
        $('#letterhead_dverror').modal('show');
        return false;
    }
    //location.reload();
    return false;
}
function letterhead_OnError(error) {
    alert(error);
}

function letterhead_Message() {
    Letterhead_BindGrid();
    $('#letterhead_dverror').modal('hide');
}