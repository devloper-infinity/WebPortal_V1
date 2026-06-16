var funfriday_table;
var funfriday_selectedrow;
var html = '';

function funfriday_bindlocation() {
    var select = document.getElementById("funfriday_location");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#funfriday_location").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "FunFriday.aspx/GetBranches", dataType: "json", contentType: "application/json",
        success: function (res) {
            $.each(res.d, function (data, value) {
                $("#funfriday_location").append($("<option></option>").val(value.BranchID).html(value.BranchName));
            })
        }
    });
}

function funfriday_binddata() {

    $('#load1').show();
    html = '';
    $.ajax({
        url: "FunFriday.aspx/GetFunFridayData",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {

                html += '<tr>';
                if (value.ImgCount > 0)
                    html += '<td style="text-wrap: nowrap; text-align:center;"><a class="dropdown-item" href=#! onclick="display_funfridayImages(\'' + blankForNull(value.Path1) + '\')"><span style="color: dodgerblue; font-size:large;"><i class="uil-images"></i></span></a></td>';
                else
                   /* html += '<td style="text-wrap: nowrap; text-align:center;"><a class="dropdown-item isDisabled" href=#! onclick="display_funfridayImages(\'' + blankForNull(value.Path1) + '\')"><span style="color: dodgerblue; font-size:large;"><i class="uil-images"></i></span></a></td>';*/
                    html += '<td style="text-wrap: nowrap; text-align:center;"><a class="dropdown-item isDisabled" href=#!"><span style="color: dodgerblue; font-size:large;"><i class="uil-images"></i></span></a></td>';

                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Date1) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Activity) + '</td>';
                html += '<td>' + blankForNull(value.Location1) + '</td>';
                html += '<td>' + blankForNull(value.Details) + '</td>';
                html += '<td>' + blankForNull(value.ImgCount) + '</td>';
                html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#funfriday_table')) {
                funfriday_table.destroy();
            }
            $('#funfriday_table tbody').html(html);
            //else
            funfriday_table = $('#funfriday_table').DataTable({
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
                        extend: 'excelHtml5', title: 'Fun Friday Report', autoFilter: true,
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

function display_funfridayImages(imgpath) {

    $("#funfriday_displayimages").modal('show')

   // alert(imgpath);

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
    var ols = document.createElement("ol");
    ols.classList.add("carousel-indicators");

    for (let index = 0; index < images.length; index++) {
        if (images[index] != "") {

            if (index == 0) {
                document.getElementById("displayfunfriday_Header").innerHTML = images[index];
            }

            if (index > 0) {
                var lis = document.createElement("li");
                lis.setAttribute("data-target", "#carouselExampleIndicators");
                lis.setAttribute("data-slide-to", index);

                if (index == 1) {
                    lis.classList.add("active");
                }
                // dvinner2.appendChild(lis);

                var dvslide = document.createElement("div");
                dvslide.classList.add("carousel-item");
                if (index == 1)
                    dvslide.classList.add("active");
                var dvouter12 = document.createElement("div");
                dvouter12.classList.add("col-lg-12");
                dvouter12.style.textAlign = "center";

              //  alert(images[index].replace("\\", "//"));

                var img = document.createElement("IMG");
                img.setAttribute("src", images[index].replace("\\", "//"));
                img.setAttribute("width", "650");
                img.setAttribute("height", "500");
                dvouter12.appendChild(img);

                dvslide.appendChild(dvouter12);
                // dvslide.appendChild(lis);
                // dvslide.appendChild(ols);
                dvinner2.appendChild(dvslide);
                //dvinner2.appendChild(lis);
                //dvinner2.appendChild(ols);
                dvinner.appendChild(dvinner2);
                dvmain.appendChild(dvinner);
            }
        }
    }

    $('#load1').hide();
    return false;
}

function display_funfridayImages_Old(imgpath) {

    $("#funfriday_displayimages").modal('show')

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
    var ols = document.createElement("ol");
    ols.classList.add("carousel-indicators");
    ols.style.justifyContent = 'flex-end';
    ols.style.alignItems = 'center';

    for (let index = 0; index < images.length; index++) {
        if (images[index] != "") {
          
            if (index == 0) {
                document.getElementById("displayfunfriday_Header").innerHTML = images[index];
            }

            if (index > 0) {
                var lis = document.createElement("li");
                lis.setAttribute("data-target", "#carouselExampleIndicators");
                lis.setAttribute("data-slide-to", index);

                if (index == 1) {
                    lis.classList.add("active");
                }
                // dvinner2.appendChild(lis);

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

                ols.appendChild(lis);
                dvslide.appendChild(ols);
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

function funfriday_SubmitData() {
    var funfriday_date = document.getElementById("funfriday_date").value;
    var funfriday_activity = document.getElementById("funfriday_activity").value;
    var ddllocation = document.getElementById("funfriday_location");
    var funfriday_location = ddllocation.options[ddllocation.selectedIndex].value;
    var funfriday_details = document.getElementById("funfriday_details").value;
    if (funfriday_date == "") {
        alert("Please select date.");
        document.getElementById("funfriday_date").focus();
        return false;
    }
    if (funfriday_activity == "") {
        alert("Please enter activity.");
        document.getElementById("funfriday_activity").focus();
        return false;
    }
    if (ddllocation.selectedIndex == 0) {
        alert("Please select location.");
        document.getElementById("funfriday_location").focus();
        return false;
    }
    if (funfriday_details == "") {
        alert("Please enter details.");
        document.getElementById("funfriday_details").focus();
        return false;
    }
    PageMethods.InsertFunFridayData(funfriday_date, funfriday_activity, funfriday_location, funfriday_details, funriday_OnSuccess, funfriday_OnError);
    return false;
}

function funriday_OnSuccess(result) {
    if (result > 0) {
        document.getElementById("funfriday_errmsg").innerHTML = "Data saved successfully!";
        $('#funfriday_dverror').modal('show');
    }
    else {
        document.getElementById("funfriday_errmsg").innerHTML = "Oops! Error occured while submitting data. Please contact administrator!";
        document.getElementById("funfriday_errmsg").style.color = 'red';
        $('#funfriday_dverror').modal('show');
        return false;
    }
    //location.reload();
    return false;
}

function funfriday_OnError(error) {
    alert(error);
}

function funfriday_Message() {
    location.reload();
}