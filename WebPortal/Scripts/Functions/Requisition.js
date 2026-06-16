var rp_table;
var rp_html;
function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

function rp_Message() {
    $('#rp_dverror').modal('hide');
    document.getElementById("rp_profile").value = '';
    rp_Binddata();
}

function rp_Binddata() {
    $('#load1').show();

    rp_html = '';
    $.ajax({
        url: "RequisitionProfile.aspx/GetAllProfiles",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                rp_html += '<tr>';
                rp_html += '<td style="text-wrap: nowrap;text-align:center;">' + blankForNull((index + 1)) + '</td>';
                rp_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Profile) + '</td>';
                rp_html += '<td style="text-wrap: nowrap; ">' + blankForNull(value.AddedByName) + '</td>';
                rp_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#rp_table')) {
                rp_table.destroy();
            }
            $('#rp_table tbody').html(rp_html);
            //else
            rp_table = $('#rp_table').DataTable({
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

                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Requisition Profile', autoFilter: true,
                        exportOptions: {
                            columns: [0, 1, 2],
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

function rp_submit() {
    var rp_profile = document.getElementById("rp_profile").value;
    if (rp_profile == "") {
        alert("Please enter profile");
        document.getElementById("rp_profile").focus();
        return false;
    }

    PageMethods.InsertProfile(rp_profile, rp_OnSuccess, rp_OnError);
    return false;
}

function rp_OnSuccess(result) {
    if (result > 0) {
        document.getElementById("rp_errmsg").innerHTML = "Profile added successfully!";
        $('#rp_dverror').modal('show');
        document.getElementById("rp_btnMessage").focus();
        return false;
    }
    else {
        document.getElementById("rp_errmsg").innerHTML = "Oops! Error occured while adding profile. Please contact administrator!";
        document.getElementById("rp_errmsg").style.color = 'red';
        $('#rp_dverror').modal('show');
        document.getElementById("rp_btnMessage").focus();
        return false;
    }
    return false;
}

function rp_OnError(error) {
    alert(error);
}

