

var userappr_gr_html;
var table_userappr_gr;

function userappr_bindgrid() {

    $('#load1').show();

    var userappr_gr_html = '';

    $.ajax({
        url: "UserAppreciationDisciplinaryActionReport.aspx/usp_GetAllAppreciationDescRecords_UserWise",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = JSON.parse(data.d);

            $.each(dataArray, function (index, value) {
                userappr_gr_html += '<tr>';
                userappr_gr_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Code) + '</td>';
                userappr_gr_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Name) + '</td>';
                userappr_gr_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.JoiningDate) + '</td>';
                userappr_gr_html += '<td style="text-wrap: nowrap; ">' + blankForNull(value.BranchName) + '</td>';
                userappr_gr_html += '<td style="text-wrap: nowrap; ">' + blankForNull(value.DepartmentName) + '</td>';
                userappr_gr_html += '<td style="text-wrap: nowrap; ">' + blankForNull(value.DesignationName) + '</td>';
                userappr_gr_html += '<td style="text-wrap: nowrap; ">' + blankForNull(value.ReportingManager) + '</td>';
                userappr_gr_html += '<td style="text-wrap: nowrap; text-align:center;"><a href=#! onclick="userappr_binddetailsbyType(' + blankForNull(value.EmployeeID) + ',\'Appreciation\')">' + blankForNull(value.Appreciation) + '</a></td>';
                userappr_gr_html += '<td style="text-wrap: nowrap; text-align:center;"><a href=#! onclick="userappr_binddetailsbyType(' + blankForNull(value.EmployeeID) + ',\'DisciplinaryAction\')">' + blankForNull(value.Warnings) + '</a></td>';
                userappr_gr_html += '<td style="text-wrap: nowrap; text-align:center;"><a href=#! onclick="userappr_binddetailsbyType(' + blankForNull(value.EmployeeID) + ',\'PerformanceImprovementPlan\')">' + blankForNull(value.PIP) + '</a></td>';

                userappr_gr_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#userappr_gr_table')) {
                userappr_gr_table.destroy();
            }

            $('#userappr_gr_table tbody').html(userappr_gr_html);

            table_userappr_gr = $('#userappr_gr_table').DataTable({
                dom: 'ftip',
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
                }
            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}

function userappr_binddetailsbyType(empid, type) {
    $("#userappr_viewdetails").modal('show')
    $('#load1').show();
    var setapp_gr_html = '';
    $.ajax({
        url: "UserAppreciationDisciplinaryActionReport.aspx/GetAllAppreciationWarningsByType",
        type: "POST",
        dataType: "json",
        data: "{EmployeeID:" + empid + ", Type:'" + type + "'}",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);
            var dvmain = document.getElementById("dvUserslidermain");
            dvmain.innerHTML = "";
            var dvinner = document.createElement("div");
            dvinner.id = "carouselExampleIndicatorsUser";
            dvinner.setAttribute("data-ride", "carousel");
            dvinner.classList.add("carousel");
            dvinner.classList.add("slide");

            if (dataArray.length > 1) {
                var a = document.createElement("a");
                a.classList.add("carousel-control-prev");
                a.setAttribute("href", "#carouselExampleIndicatorsUser");
                a.setAttribute("role", "button");
                a.setAttribute("data-slide", "prev");
                var span = document.createElement("span");
                span.classList.add("carousel-control-prev-icon");
                a.appendChild(span);
                dvinner.appendChild(a);
                a = document.createElement("a");
                a.classList.add("carousel-control-next");
                a.setAttribute("href", "#carouselExampleIndicatorsUser");
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

            $.each(dataArray, function (index, value) {
                var dvslide = document.createElement("div");
                dvslide.classList.add("carousel-item");
                if (index == 0)
                    dvslide.classList.add("active");
                var dvouter12 = document.createElement("div");
                dvouter12.classList.add("col-lg-12");
                var dvrow = document.createElement("div");
                dvrow.classList.add("row");
                var dvleft = document.createElement("div");
                dvleft.classList.add("col-md-10");
                var table = document.createElement("table");
                var tr = document.createElement("tr");
                var td = document.createElement("td");
                td.innerHTML = "<b>Name:</b> " + blankForNull(value.Name);
                tr.appendChild(td);
                table.appendChild(tr);
                tr = document.createElement("tr");
                td = document.createElement("td");
                td.innerHTML = "<b>Joining Date:</b> " + blankForNull(value.JoiningDate);
                tr.appendChild(td);
                table.appendChild(tr);
                tr = document.createElement("tr");
                td = document.createElement("td");
                td.innerHTML = "<b>Location:</b> " + blankForNull(value.BranchName);
                tr.appendChild(td);
                table.appendChild(tr);
                dvleft.appendChild(table);
                dvrow.appendChild(dvleft);
                var dvright = document.createElement("div");
                dvright.classList.add("col-md-2");
                var addeddate = eval(value.AddedDate.replace(/\/Date\((\d+)\)\//gi, "new Date($1).toLocaleDateString(\"en-US\")"));
                dvright.innerHTML = "<b>Date:</b> " + blankForNull(addeddate);
                dvrow.appendChild(dvright);
                dvouter12.appendChild(dvrow);

                dvrow = document.createElement("div");
                dvrow.classList.add("row");
                var dvcenter = document.createElement("div");
                dvcenter.classList.add("col-md-12");
                dvcenter.style.textAlign = "center";
                var hr = document.createElement("hr");
                dvcenter.appendChild(hr);
                var h5 = document.createElement("h5");
                h5.innerHTML = blankForNull(value.Title);
                dvcenter.appendChild(h5);
                hr = document.createElement("hr");
                dvcenter.appendChild(hr);
                dvrow.appendChild(dvcenter);
                dvouter12.appendChild(dvrow);


                dvrow = document.createElement("div");
                dvrow.classList.add("row");
                dvcenter = document.createElement("div");
                dvcenter.classList.add("col-md-12");
                var lbl = document.createElement("label");
                lbl.innerHTML = blankForNull(value.Description);
                dvcenter.appendChild(lbl);
                dvrow.appendChild(dvcenter);
                dvouter12.appendChild(dvrow);
                dvslide.appendChild(dvouter12);
                dvinner2.appendChild(dvslide);
                dvinner.appendChild(dvinner2);

                dvmain.appendChild(dvinner);


            });
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    $('#load1').hide();
    return false;
}
