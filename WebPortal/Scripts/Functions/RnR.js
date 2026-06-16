var rnr_table;
var html;
var rnr_snap_table;
var rnr_snap_html;

function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

function rnr_BindYear() {

    var start = new Date().getFullYear();

    var select = document.getElementById("rnr_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    var selectSnap = document.getElementById("rnrSnap_year");
    let optionsSnap = selectSnap.getElementsByTagName('option');

    for (var i = optionsSnap.length; i--;) {
        selectSnap.removeChild(optionsSnap[i]);
    }

    $("#rnr_year").append($("<option></option>").val("Select").html("Select"));
    $("#rnrSnap_year").append($("<option></option>").val("Select").html("Select"));

    for (var i = start; i > start - 5; i--) {
        $("#rnr_year").append($("<option></option>").val(i).html(i));
        $("#rnrSnap_year").append($("<option></option>").val(i).html(i));
    }
}

function rnr_bindusers() {
    var select = document.getElementById("rnr_employee");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#rnr_employee").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "RewardAndRecognition.aspx/GetAllEmployees", dataType: "json", contentType: "application/json",
        success: function (res1) {
            var dataArray = JSON.parse(res1.d);
            $.each(dataArray, function (data1, value1) {
                $("#rnr_employee").append($("<option></option>").val(value1.EmployeeID).html(value1.Code1));
            });
        }
    });
}

function rnr_bindbranches() {
    var select = document.getElementById("rnrSnap_location");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#rnrSnap_location").append($("<option></option>").val("Select").html("Select"));
    $.ajax({
        type: "POST", url: "CreateProfile.aspx/GetBranches", dataType: "json", contentType: "application/json",
        success: function (res) {
            $.each(res.d, function (data, value) {
                $("#rnrSnap_location").append($("<option></option>").val(value.BranchID).html(value.BranchName));
            })
        }
    });
}

function rnr_bidgrid() {
    $('#load1').show();
    html = '';
    $.ajax({
        url: "RewardAndRecognition.aspx/GetGridData",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            var date;
            $.each(dataArray, function (index, value) {

                html += '<tr>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Quarter) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Code) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Name) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.JoiningDate) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.DateofBirth) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Branch) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Domain) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Subdomain) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Department) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Designation) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ReportingManager) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.CurrentStatus) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.LatestLoginDate) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.DailyTaskProductivity) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.FinalStatus) + '</td>';
                html += '</tr>';


            });

            if ($.fn.dataTable.isDataTable('#rnr_table')) {
                rnr_table.destroy();
            }
            $('#rnr_table tbody').html(html);
            //else
            rnr_table = $('#rnr_table').DataTable({
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
                    var val = data[3];
                },

                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Reward and Recognition', autoFilter: true,
                        exportOptions: {
                            columns: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
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

function rnr_Submit() {

    var ddlyear = document.getElementById("rnr_year");
    var rnr_year = ddlyear.options[ddlyear.selectedIndex].value;
    var ddlquarter = document.getElementById("rnr_quarter");
    var rnr_quarter = ddlquarter.options[ddlquarter.selectedIndex].value;
    var ddlemp = document.getElementById("rnr_employee");
    var rnr_employee = ddlemp.options[ddlemp.selectedIndex].value;

    PageMethods.InsertRewardDetails(rnr_year, rnr_quarter, 'Completed', rnr_employee, rnr_OnSuccess, rnr_OnError);
    return false;
}

function rnr_OnSuccess(result) {

    if (result > 0) {
        document.getElementById("rnr_errmsg").innerHTML = "Data saved successfully!";
        $('#rnr_dverror').modal('show');
    }
    else {
        document.getElementById("rnr_errmsg").innerHTML = "Error occured while saving data. Please contact administrator!";
        document.getElementById("rnr_errmsg").style.color = 'red';
        $('#rnr_dverror').modal('show');
        return false;
    }
    rnr_Message();
    return false;
}

function rnr_OnError(error) {
    alert(error);
}

function rnrSnap_Submit() {

    var ddlSyear = document.getElementById("rnrSnap_year");
    var rnrS_year = ddlSyear.options[ddlSyear.selectedIndex].value;
    var ddlSquarter = document.getElementById("rnrSnap_quarter");
    var rnrS_quarter = ddlSquarter.options[ddlSquarter.selectedIndex].value;
    var ddl_Location = document.getElementById("rnrSnap_location");
    var rnr_Location = ddl_Location.options[ddl_Location.selectedIndex].value;

    var locationName = ddl_Location.options[ddl_Location.selectedIndex].text;

    PageMethods.InsertRnRSnaps(rnrS_year, rnrS_quarter, rnr_Location, locationName, rnrSnap_OnSuccess, rnrSnap_OnError);
    return false;
}

function rnrSnap_OnSuccess(result) {
    if (result > 0) {
        document.getElementById("rnr_errmsg").innerHTML = "Snaps uploaded successfully!";
        $('#rnr_dverror').modal('show');
    }
    else {
        document.getElementById("rnr_errmsg").innerHTML = "Error occured while uploading snaps. Please contact administrator!";
        document.getElementById("rnr_errmsg").style.color = 'red';
        $('#rnr_dverror').modal('show');
        return false;
    }
   // rnr_Message();
    return false;
}

function rnrSnap_OnError(error) {
    alert(error);
}

function rnr_Message() {
    location.reload();
}

function rnr_snap_binddata() {

    $('#load1').show();
    rnr_snap_html = '';
    $.ajax({
        url: "RewardAndRecognition.aspx/GetAllRnRSnaps",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {

                rnr_snap_html += '<tr>';
                if (value.ImgCount > 0)
                    rnr_snap_html += '<td style="text-wrap: nowrap; text-align:center;"><a class="dropdown-item" href=#! onclick="display_rnr_snap(\'' + blankForNull(value.Path1) + '\')"><span style="color: dodgerblue; font-size:large;"><i class="uil-images"></i></span></a></td>';
                else
                    rnr_snap_html += '<td style="text-wrap: nowrap; text-align:center;"><a class="dropdown-item isDisabled" href=#!><span style="color: dodgerblue; font-size:large;"><i class="uil-images"></i></span></a></td>';

                rnr_snap_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.LocationName) + '</td>';
                rnr_snap_html += '<td>' + blankForNull(value.Year) + '</td>';
                rnr_snap_html += '<td>' + blankForNull(value.Quarter) + '</td>';
                rnr_snap_html += '<td>' + blankForNull(value.UploadedBy) + '</td>';
                rnr_snap_html += '<td>' + blankForNull(value.UploadedDate) + '</td>';
                rnr_snap_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#table_rnr_snap')) {
                rnr_snap_table.destroy();
            }
            $('#table_rnr_snap tbody').html(rnr_snap_html);
            //else
            rnr_snap_table = $('#table_rnr_snap').DataTable({
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

                    var val = data[3];
                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Reward And Recognition Report', autoFilter: true,
                        exportOptions: {
                            columns: [0, 1, 2, 3]
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

function display_rnr_snap(imgpath) {

    $("#rnr_snap_display").modal('show')

    const images = imgpath.split(",");

    var dvmain = document.getElementById("dvslidermain");
    dvmain.innerHTML = "";
    var dvinner = document.createElement("div");
    dvinner.id = "carouselExampleIndicators";
    dvinner.setAttribute("data-ride", "carousel");
    dvinner.classList.add("carousel");
    dvinner.classList.add("slide");

    if (images.length > 1) {

        var a = document.createElement("a");
        a.classList.add("carousel-control-prev");
        a.setAttribute("href", "#carouselExampleIndicators");
        a.setAttribute("role", "button");
        a.setAttribute("data-slide", "prev");
        var span = document.createElement("span");
        span.classList.add("carousel-control-prev-icon");
        a.appendChild(span);
        dvinner.appendChild(a);
        a = document.createElement("a");
        a.classList.add("carousel-control-next");
        a.setAttribute("href", "#carouselExampleIndicators");
        a.setAttribute("role", "button");
        a.setAttribute("data-slide", "next");
        span = document.createElement("span");
        span.classList.add("carousel-control-next-icon");
        a.appendChild(span);
        dvinner.appendChild(a);
    }

    var dvinner2 = document.createElement("div");
    dvinner2.classList.add("carousel-inner");
    dvinner2.setAttribute("role", "listbox");

    for (let index = 0; index < images.length; index++) {
        if (images[index] != "") {

            if (index == 0) {
                document.getElementById("displayrnr_snap_Header").innerHTML = images[index];
            }

            if (index > 0) {

                //  alert(images[index]);

                var dvslide = document.createElement("div");
                dvslide.classList.add("carousel-item");
                if (index == 1)
                    dvslide.classList.add("active");
                var dvouter12 = document.createElement("div");
                dvouter12.classList.add("col-lg-12");
                dvouter12.style.textAlign = "center";

                var img = document.createElement("IMG");
                img.setAttribute("src", images[index].replace("\\", "//"));
                img.setAttribute("width", "650");
                img.setAttribute("height", "500");
                dvouter12.appendChild(img);

                dvslide.appendChild(dvouter12);
                dvinner2.appendChild(dvslide);
                dvinner.appendChild(dvinner2);
                dvmain.appendChild(dvinner);
            }
        }
    }

    $('#load1').hide();
    return false;
}