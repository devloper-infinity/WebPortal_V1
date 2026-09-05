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


function hr_BindYear() {
    var start = new Date().getFullYear();

    var select = document.getElementById("hr_year");
    let options = select.getElementsByTagName('option');
    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#hr_year").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#hr_year").append($("<option></option>").val(i).html(i));
    }
}

/*----------- Glass Competitors -----------*/

function glasscomp_BindYear() {
    var start = new Date().getFullYear();

    var select = document.getElementById("glasscomp_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#glasscomp_year").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#glasscomp_year").append($("<option></option>").val(i).html(i));
    }
}

function glasscomp_BindGrid() {
    $('#load1').show();

    glasscomp_html = '';
    $.ajax({
        url: "HRReportInput.aspx/GetGlassDoorCompetitors",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                glasscomp_html += '<tr>';
                glasscomp_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(index + 1) + '</td>';
                glasscomp_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.CompetitorName) + '</td>';
                glasscomp_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Month) + '</td>';
                glasscomp_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.Year) + '</td>';
                glasscomp_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.CompanyRating) + '</td>';
                glasscomp_html += '<td style="text-wrap: nowrap; text-align:center;"><a href="#!" id="Actions" onclick="socialsite_download(' + value.GlassID + ',' + index + ');" title="Download Attachment"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-cloud-download" style="font-size:14px;"></i></span></a></td>';
                glasscomp_html += '<td style="text-wrap: nowrap; display:none;">' + blankForNull(value.Attachment) + '</td>';
                glasscomp_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#glasscomp_table')) {
                glasscomp_table.destroy();
            }
            $('#glasscomp_table tbody').html(glasscomp_html);
            //else
            glasscomp_table = $('#glasscomp_table').DataTable({
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

function glasscomp_submit() {
    var ddlcompany = document.getElementById("glasscomp_company");
    var glasscomp_company = ddlcompany.options[ddlcompany.selectedIndex].value;
    var ddlmonth = document.getElementById("glasscomp_month");
    var glasscomp_month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("glasscomp_year");
    var glasscomp_year = ddlyear.options[ddlyear.selectedIndex].value;
    var glasscomp_companyrating = document.getElementById("glasscomp_companyrating").value;

    if (glasscomp_company == "") {
        alert("Please select cometitor");
        return false;
    }
    if (glasscomp_month == "") {
        alert("Please select month");
        return false;
    }
    if (glasscomp_year == "") {
        alert("Please select year");
        return false;
    }
    if (glasscomp_companyrating == "") {
        alert("Please enter company rating");
        return false;
    }

    PageMethods.InsertGlassDoorCompetitors(glasscomp_company, glasscomp_month, glasscomp_year, glasscomp_companyrating, glasscomp_OnSuccess, glasscomp_OnError);
    return false;
}

function glasscomp_OnSuccess(result) {
    if (result > 0) {
        document.getElementById("socialsite_errmsg").innerHTML = "Data saved successfully!";
        $('#socialsite_dverror').modal('show');
    }
    else {
        document.getElementById("socialsite_errmsg").innerHTML = "Record already exists for the selected competitor and month-year!";
        document.getElementById("socialsite_errmsg").style.color = 'red';
        $('#socialsite_dverror').modal('show');
        return false;
    }
    //location.reload();
    return false;
}

function glasscomp_OnError(error) {
    alert(error);
}

function glasscomp_bindcompetitors() {
    var select = document.getElementById("glasscomp_company");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#glasscomp_company").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "HRReportInput.aspx/GetAllCompetitors", dataType: "json", contentType: "application/json",
        success: function (res1) {
            var dataArray = JSON.parse(res1.d);
            $.each(dataArray, function (data1, value1) {
                $("#glasscomp_company").append($("<option></option>").val(value1.CompanyName).html(value1.CompanyName));
            });
        }
    });
}


/*----------- Glass Door Rating -----------*/

function glassrating_BindYear() {
    var start = new Date().getFullYear();

    var select = document.getElementById("glassrating_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#glassrating_year").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#glassrating_year").append($("<option></option>").val(i).html(i));
    }
}

function glassrating_submit() {
    var ddlmonth = document.getElementById("glassrating_month");
    var glassrating_month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("glassrating_year");
    var glassrating_year = ddlyear.options[ddlyear.selectedIndex].value;
    var glassrating_companyrating = document.getElementById("glassrating_companyrating").value;

    if (glassrating_month == "") {
        alert("Please select month");
        return false;
    }
    if (glassrating_year == "") {
        alert("Please select year");
        return false;
    }
    if (glassrating_companyrating == "") {
        alert("Please enter company rating");
        return false;
    }

    PageMethods.InsertGlassDoorRating(glassrating_month, glassrating_year, glassrating_companyrating, glassrating_OnSuccess, glassrating_OnError);
    return false;
}

function glassrating_OnSuccess(result) {
    if (result > 0) {
        document.getElementById("socialsite_errmsg").innerHTML = "Data saved successfully!";
        $('#socialsite_dverror').modal('show');
    }
    else {
        document.getElementById("socialsite_errmsg").innerHTML = "Record already exists for the selected month and year. Please contact administrator!";
        document.getElementById("socialsite_errmsg").style.color = 'red';
        $('#socialsite_dverror').modal('show');
        return false;
    }
    //location.reload();
    return false;
}

function glassrating_OnError(error) {
    alert(error);
}

function glassrating_BindGrid() {
    $('#load1').show();

    glassrating_html = '';
    $.ajax({
        url: "HRReportInput.aspx/GetGlassDoorRatings",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                glassrating_html += '<tr>';
                glassrating_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(index + 1) + '</td>';
                glassrating_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Month) + '</td>';
                glassrating_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.Year) + '</td>';
                glassrating_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.CompanyRating) + '</td>';
                glassrating_html += '<td style="text-wrap: nowrap; text-align:center;"><a href="#!" id="Actions" onclick="socialsite_download(' + value.GlassID + ',' + index + ');" title="Download Attachment"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-cloud-download" style="font-size:14px;"></i></span></a></td>';
                glassrating_html += '<td style="text-wrap: nowrap; display:none;">' + blankForNull(value.Attachment) + '</td>';
                glassrating_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#glassrating_table')) {
                glassrating_table.destroy();
            }
            $('#glassrating_table tbody').html(glassrating_html);
            //else
            glassrating_table = $('#glassrating_table').DataTable({
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
                        extend: 'excelHtml5', title: 'Glass Door Ratings', autoFilter: true,
                        exportOptions: {
                            columns: [0, 1, 2, 3],
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


/*----------- Social Site Visit -----------*/

function socialsite_BindYear() {

    var start = new Date().getFullYear();

    var select = document.getElementById("socialsite_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#socialsite_year").append($("<option></option>").val("Select").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#socialsite_year").append($("<option></option>").val(i).html(i));
    }
}

function socialsite_download(VisitorID, Index) {

    //window.location.href = "DownloadFiles.aspx?VisitorID=" + VisitorID;

    var row = socialsite_table.row(Index).data();
    var fileurl = row[6];

    if (fileurl == "" || fileurl == null) {
        alert("No attachment found.");
        return;
    }

    var lastindex = row[6].lastIndexOf('/');
    var filename = row[6].substring(lastindex + 1, row[6].length);

    var currenturl = window.location.href;
    var urlindex = currenturl.lastIndexOf('/');
    var firstpart = currenturl.substring(0, urlindex + 1);
    var secondpart = "DownloadFiles.aspx?VisitorID=" + VisitorID;
    var actualurl = firstpart + secondpart;

    fetch(actualurl)
        // check to make sure you didn't have an unexpected failure (may need to check other things here depending on use case / backend)
        .then(resp => resp.status === 200 ? resp.blob() : Promise.reject('something went wrong'))
        .then(blob => {
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.style.display = 'none';
            a.href = url;
            // the filename you want
            a.download = filename;
            document.body.appendChild(a);
            a.click();
            window.URL.revokeObjectURL(url);
            // or you know, something with better UX...
        })
        .catch(() => alert('Oops! It seems that there is an error while retriving attachment. Please contact administrator.'));
}

function socialsite_download1(FileName, Index) {
    var row = socialsite_table.row(Index).data();
    if (row[6] == '') {
        alert("No attachment found!");
        return;
    }
    else {
        var url = row[5];
        //var url = row[5].replace("D:\\WebHosting\\Webportal\\", "http://localhost:51887/");
        var link = document.createElement("a");
        // If you don't know the name or want to use
        // the webserver default set name = ''
        link.setAttribute('download', FileName);
        link.href = url;
        document.body.appendChild(link);
        link.click();
        link.remove();
    }

}

function socialsite_bindgrid() {
    $('#load1').show();

    socialsite_html = '';
    $.ajax({
        url: "HRReportInput.aspx/GetAllSocialSiteVisitors",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                socialsite_html += '<tr>';
                socialsite_html += '<td style="text-wrap: nowrap;">' + blankForNull(index + 1) + '</td>';
                socialsite_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Name) + '</td>';
                socialsite_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.SocialSite) + '</td>';
                socialsite_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.DateVisited) + '</td>';
                socialsite_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Month) + '</td>';
                socialsite_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Year) + '</td>';
                socialsite_html += '<td><a href="#!" id="Actions" onclick="socialsite_download(' + value.VisitorID + ',' + index + ');" title="Download Attachment"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-cloud-download" style="font-size:14px;"></i></span></a></td>';
                socialsite_html += '<td style="text-wrap: nowrap; display:none;">' + blankForNull(value.Attachment) + '</td>';
                socialsite_html += '<td style="text-wrap: nowrap; display:none;">' + blankForNull(value.Filepath) + '</td>';
                socialsite_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#socialsite_table')) {
                socialsite_table.destroy();
            }
            $('#socialsite_table tbody').html(socialsite_html);
            //else
            socialsite_table = $('#socialsite_table').DataTable({
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
                        extend: 'excelHtml5', title: 'Social Site Visitors', autoFilter: true,
                        exportOptions: {
                            columns: [0, 1, 2, 3],
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

async function socialsite_submit() {
    const employee = document
        .getElementById("socialsite_employee")
        .value
        .trim();

    const socialSite = document
        .getElementById("socialsite_site")
        .value
        .trim();

    const dateVisited = document
        .getElementById("socialsite_datevisited")
        .value
        .trim();

    if (!employee) {
        await Swal.fire({
            icon: "warning",
            title: "Employee Required",
            text: "Please select an employee.",
            confirmButtonText: "OK"
        });

        document.getElementById("socialsite_employee").focus();
        return false;
    }

    if (!socialSite) {
        await Swal.fire({
            icon: "warning",
            title: "Social Site Required",
            text: "Please select a social site.",
            confirmButtonText: "OK"
        });

        document.getElementById("socialsite_site").focus();
        return false;
    }

    if (!dateVisited) {
        await Swal.fire({
            icon: "warning",
            title: "Date Required",
            text: "Please select the date visited.",
            confirmButtonText: "OK"
        });

        document.getElementById("socialsite_datevisited").focus();
        return false;
    }

    Swal.fire({
        title: "Please wait",
        text: "The system is submitting your data.",
        allowOutsideClick: false,
        allowEscapeKey: false,
        showConfirmButton: false,
        didOpen: function () {
            Swal.showLoading();
        }
    });

    try {
        const result = await insertSocialSiteVisitor(
            employee,
            socialSite,
            dateVisited
        );

        Swal.close();

        if (Number(result) === -1) {
            await Swal.fire({
                icon: "warning",
                title: "Record Already Exists",
                text: "A record already exists for the same month and year.",
                confirmButtonText: "OK",
                allowOutsideClick: false
            });

            return false;
        }

        if (Number(result) > 0) {
            await Swal.fire({
                icon: "success",
                title: "Saved Successfully",
                text: "The social site visitor record was saved successfully.",
                confirmButtonText: "OK",
                allowOutsideClick: false
            });

            document.getElementById("socialsite_employee").value = "";
            document.getElementById("socialsite_site").value = "";
            document.getElementById("socialsite_datevisited").value = "";

            return false;
        }

        await Swal.fire({
            icon: "error",
            title: "Submission Failed",
            text: "An error occurred while submitting the data. Please contact the administrator.",
            confirmButtonText: "OK",
            allowOutsideClick: false
        });
    } catch (error) {
        Swal.close();

        const errorMessage =
            error?.get_message?.() ||
            error?.responseText ||
            error?.message ||
            "An unexpected error occurred while submitting the data.";

        await Swal.fire({
            icon: "error",
            title: "Error",
            text: errorMessage,
            confirmButtonText: "OK",
            allowOutsideClick: false
        });
    }

    return false;
}

function insertSocialSiteVisitor(employee, socialSite, dateVisited) {
    return new Promise(function (resolve, reject) {
        PageMethods.InsertSocialSiteVisitors(
            employee,
            socialSite,
            dateVisited,
            resolve,
            reject
        );
    });
}

function socialsite_bindusersNew() {

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

function socialsite_submit() {
    var ddlemp = document.getElementById("socialsite_employee");
    var socialsite_employee = ddlemp.options[ddlemp.selectedIndex].value;
    var ddlsite = document.getElementById("socialsite_site");
    var socialsite_site = ddlsite.options[ddlsite.selectedIndex].value;
    var socialsite_datevisited = document.getElementById("socialsite_datevisited").value;

    var year = $("#socialsite_year").val();
    var month = $("#socialsite_month").val();

    if (socialsite_employee == "") {
        alert("Please select employee");
        return false;
    }
    if (socialsite_site == "") {
        alert("Please select social site");
        return false;
    }
    if (socialsite_datevisited == "") {
        alert("Please select date visited");
        return false;
    }

    PageMethods.InsertSocialSiteVisitors(socialsite_employee, socialsite_site, socialsite_datevisited, month, year, socialsite_OnSuccess, socialsite_OnError);
    return false;
}

function socialsite_OnSuccess(result) {

    if (result > 0) {
        document.getElementById("socialsite_errmsg").innerHTML = "Data saved successfully!";
        $('#socialsite_dverror').modal('show');
    }
    else if (result == -1) {
        document.getElementById("socialsite_errmsg").innerHTML = "Data already exists for the selected employee, month, and year.";
        $('#socialsite_dverror').modal('show');
    }
    else {
        document.getElementById("socialsite_errmsg").innerHTML = "Oops! Error occured while submitting data. Please contact administrator!";
        document.getElementById("socialsite_errmsg").style.color = 'red';
        $('#socialsite_dverror').modal('show');
        return false;
    }
    //location.reload();
    return false;
}

function socialsite_OnError(error) {
    alert(error);
}

function socialsite_Message() {
    location.reload();
}


/*----------- Bank Approval -----------*/

function bankapproval_bindgrid() {
    $('#load1').show();
    bankapproval_html = '';
    $.ajax({
        url: "BankDeatailsApprovalReport.aspx/GetApprovedBankDetails",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                var addeddate;
                var verfieddate;
                if (value.AddedDate != null)
                    var addeddate = eval(value.AddedDate.replace(/\/Date\((\d+)\)\//gi, "new Date($1).toLocaleDateString(\"en-US\")"));
                if (value.VerifiedDate != null)
                    var verfieddate = eval(value.VerifiedDate.replace(/\/Date\((\d+)\)\//gi, "new Date($1).toLocaleDateString(\"en-US\")"));
                bankapproval_html += '<tr>';
                bankapproval_html += '<td style="text-wrap: nowrap;">' + blankForNull(index + 1) + '</td>';
                bankapproval_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Code) + '</td>';
                bankapproval_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.EmpName) + '</td>';
                bankapproval_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.BranchName) + '</td>';
                bankapproval_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.DepartmentName) + '</td>';
                bankapproval_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.DesignationName) + '</td>';
                bankapproval_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ProjectManagerName) + '</td>';
                bankapproval_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.BankName) + '</td>';
                bankapproval_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.AccountNo) + '</td>';
                bankapproval_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.IFSCCode) + '</td>';
                bankapproval_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.AddedByName) + '</td>';
                bankapproval_html += '<td style="text-wrap: nowrap;">' + blankForNull(addeddate) + '</td>';
                bankapproval_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.VerifiedByName) + '</td>';
                bankapproval_html += '<td style="text-wrap: nowrap;">' + blankForNull(verfieddate) + '</td>';
                bankapproval_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#bankapproval_table')) {
                bankapproval_table.destroy();
            }
            $('#bankapproval_table tbody').html(bankapproval_html);
            //else
            bankapproval_table = $('#bankapproval_table').DataTable({
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
                        extend: 'excelHtml5', title: 'Approved Bank Details', autoFilter: true,
                        exportOptions: {
                            columns: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13],
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

function bankpending_bindgrid() {
    $('#load1').show();
    bankpending_html = '';
    $.ajax({
        url: "BankDeatailsApprovalReport.aspx/GetPendingBankDetails",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                var addeddate;
                if (value.AddedDate != null)
                    var addeddate = eval(value.AddedDate.replace(/\/Date\((\d+)\)\//gi, "new Date($1).toLocaleDateString(\"en-US\")"));
                bankpending_html += '<tr>';
                bankpending_html += '<td style="text-wrap: nowrap;">' + blankForNull(index + 1) + '</td>';
                bankpending_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Code) + '</td>';
                bankpending_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.EmpName) + '</td>';
                bankpending_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.BranchName) + '</td>';
                bankpending_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.DepartmentName) + '</td>';
                bankpending_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.DesignationName) + '</td>';
                bankpending_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ProjectManagerName) + '</td>';
                bankpending_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.BankName) + '</td>';
                bankpending_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.AccountNo) + '</td>';
                bankpending_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.IFSCCode) + '</td>';
                bankpending_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.AddedByName) + '</td>';
                bankpending_html += '<td style="text-wrap: nowrap;">' + blankForNull(addeddate) + '</td>';
                bankpending_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#bankpending_table')) {
                bankpending_table.destroy();
            }
            $('#bankpending_table tbody').html(bankpending_html);
            //else
            bankpending_table = $('#bankpending_table').DataTable({
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
                        extend: 'excelHtml5', title: 'Pending Bank Details', autoFilter: true,
                        exportOptions: {
                            columns: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13],
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

function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

function allresigned_BindYear() {
    var start = new Date().getFullYear();

    var select = document.getElementById("allresigned_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#allresigned_year").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#allresigned_year").append($("<option></option>").val(i).html(i));
    }
}

function allresigned_Submit() {
    $('#load1').show();
    //var ddlmonth = document.getElementById("allresigned_month");
    //var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    //var ddlyear = document.getElementById("allresigned_year");
    //var year = ddlyear.options[ddlyear.selectedIndex].value;
    var month = document.getElementById("allresigned_from").value;
    var year = document.getElementById("allresigned_to").value;
    if (month == "") {
        alert("Please select from date");
        return false;
    }
    if (year == "") {
        alert("Please select to date");
        return false;
    }

    dropoutemployeeSummary_bindgrid(month, year);

    allresigned_html = '';
    $.ajax({
        url: "AllResignedEmployees.aspx/GetAllResignedEmployees",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//

            $.each(dataArray, function (index, value) {

                allresigned_html += '<tr>';
                allresigned_html += '<td style="text-wrap: nowrap;">' + blankForNull(index + 1) + '</td>';
                allresigned_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Code) + '</td>';
                allresigned_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.EmployeeName) + '</td>';
                allresigned_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.JoiningDate) + '</td>';
                allresigned_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.DateOfBirth) + '</td>';
                allresigned_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.BranchName) + '</td>';
                allresigned_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.DepartmentName) + '</td>';
                allresigned_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.DesignationName) + '</td>';
                allresigned_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Domain) + '</td>';
                allresigned_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Subdomain) + '</td>';
                allresigned_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ReportingManager) + '</td>';
                allresigned_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.DomainHead) + '</td>';
                allresigned_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.LatestLoginDate) + '</td>';
                allresigned_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ResignationType) + '</td>';
                allresigned_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ResignationDate) + '</td>';
                allresigned_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.LastWorkingDate) + '</td>';
                allresigned_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Step1Remark) + '</td>';
                allresigned_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Step2Remark) + '</td>';
                allresigned_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Step3Remark) + '</td>';
                allresigned_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#allresigned_table')) {
                five_table.destroy();
            }
            $('#allresigned_table tbody').html(allresigned_html);
            //else
            {
                five_table = $('#allresigned_table').DataTable({
                    dom: 'lftip',
                    scrollX: true,
                    destroy: true,
                    "paging": true,
                    "autoWidth": true,
                    select: true,
                    processing: true,
                    "ordering": false,
                    'select': {
                        'style': 'single'
                    },
                    initComplete: function () {
                        $('#load1').hide();
                    },
                    "rowCallback": function (row, data) {
                        // Cell at index 5 in the row is 'Active'.
                    },
                    buttons: [
                        {
                            extend: 'excelHtml5', title: 'Resigned Employees', autoFilter: true,
                            exportOptions: {
                                columns: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18]
                            },

                        },
                    ],
                });
            }
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}



/*----------- Dropout Employee -----------*/

function dropoutemployeeSummary_bindgrid(fromdate, todate) {

    var columns = [];

    $.ajax({
        url: "AllResignedEmployees.aspx/GetResignedEmployeeSummary_MonthWise",
        type: "POST",
        data: "{FromDate:'" + fromdate + "', ToDate:'" + todate + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            if ($.fn.dataTable.isDataTable('#table_resignedSummary')) {
                $('#table_resignedSummary').DataTable().destroy();
            }

            dataArray = JSON.parse(data.d);

            $.each(dataArray[0], function (key, value) {

                var my_item = {};
                my_item.data = key;
                my_item.title = key;
                columns.push(my_item);
            });

            $('#table_resignedSummary').DataTable({
                dom: 'lBftp',
                destroy: true,
                paging: true,
                "autoWidth": true,
                select: true,
                processing: true,
                'select': {
                    'style': 'single'
                },
                "data": dataArray,
                "columns": columns,

                initComplete: function () {
                    jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');
                    $('#load1').hide();
                },
                buttons: [
                    {
                        // extend: 'excelHtml5', title: ExcelTitle, autoFilter: true,
                    },
                ],

            });
        }
    });
}
