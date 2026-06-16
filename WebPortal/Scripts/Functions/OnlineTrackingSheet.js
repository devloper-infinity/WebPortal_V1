function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}


function otsheet_bindprojects() {
    var select = document.getElementById("otsheet_project");
    var options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#otsheet_project").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "OnlineTrackingSheet.aspx/GetProjects", dataType: "json",
        contentType: "application/json",
        success: function (res) {
            $.each(res.d, function (data, value) {
                $("#otsheet_project").append($("<option></option>").val(value.ProjectID).html(value.ProjectName));
            })
        }
    });
}

function otsheet_submit() {
    $("#load1").show();
    var ddlProject = document.getElementById("otsheet_project");
    var projectid = ddlProject.options[ddlProject.selectedIndex].value;
    var fromdate = document.getElementById("otsheet_from").value;
    var todate = document.getElementById("otsheet_to").value;
    if (projectid == "") {
        alert("Please select project.");
        return false;
    }
    if (fromdate == "") {
        alert("Please select from date.");
        return false;
    }
    if (todate == "") {
        alert("Please select to date.");
        return false;
    }
    var columns = [];
    $.ajax({
        url: "OnlineTrackingSheet.aspx/GetProjectandDatewiseTrackingSheetData",
        type: "POST",
        data: "{ProjectID:" + projectid + ", FromDate:'" + fromdate + "', ToDate:'" + todate + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//

            //alert(data.d);

            $.each(dataArray[0], function (key, value) {
                // alert(key);
                var my_item = {};
                my_item.data = key;
                my_item.title = key;
                columns.push(my_item);
            });

            $('#otsheet_table').DataTable({
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
                "data": dataArray,
                "columns": columns,

                initComplete: function () {
                    $("#load1").hide();
                },

                "rowCallback": function (row, data) {
                    var val = data[3];
                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Online Tracking Sheet', autoFilter: true,
                    },
                ],

                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                    $(nRow).children("td").css("text-align", "center");
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