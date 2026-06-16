
var edittable;
var html;


function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

function viewdocuments(Code, Index) {
    //location.href = "EmployeeDocuments.aspx?Exists=" + Code;

    location.href = "GenerateEmpDocs.aspx?Exists=" + Code;
}

function editprofile(Code, Index) {
    location.href = "CreateProfile.aspx?Code=" + Code;
}

function uploaddocuments(Code, Index) {

    var row = edittable.row(Index).data();
    var codename = row[2] + ' : ' + row[3];
    document.getElementById("viewemp_uploaddocsLabel").innerHTML = "Upload Documents ~ " + codename;
    document.getElementById("viewemp_code").innerHTML = Code;
    $("#viewemp_uploaddocs").modal("show");
}

function viewEmployee_Grid(currentUserName) {
    $('#load1').show();

    html = '';

    $.ajax({
        url: "ViewEmployee.aspx/GetAllEmployees",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);

            $.each(dataArray, function (index, value) {
                html += '<tr>';
                if (currentUserName == 7036 || currentUserName == 8938 || currentUserName == 8082 || currentUserName == 10447) {
                    html += '<td class=""><div class="btn-group">';
                    html += '<div class="btn-group">';
                    html += '<div type="button" data-toggle="dropdown" aria-expanded="false"><i style="color: dodgerblue; font-size:14px;" class="uil fs-0 me-2 uil-cog"></i>';
                    html += '<span class="sr-only"></span></div><div class="dropdown-menu" role="menu" style="">';
                    html += '<a class="dropdown-item" href="#!" id="Actions" onclick="editprofile(\'' + value.Code + '\',' + index + ',1);"><span style="color: forestgreen;"><i class="uil fs-0 me-2 uil-pen"></i></span>&nbsp;&nbsp;Edit Profile</a>';
                    html += '<a class="dropdown-item" href="#!" id="Actions" onclick="uploaddocuments(\'' + value.Code + '\',' + index + ',1);"><span style="color: orange;"><i class="uil-folder-upload"></i></span>&nbsp;&nbsp;Upload Documents</a>';

                    if (value.DocCount > 0) {
                        html += '<a class="dropdown-item" href="#!" id="Actionsdown" onclick="downloaddocuments(\'' + value.Code + '\',' + index + ');"><span style="color: #8403fc;"><i class="uil-cloud-download"></i></span>&nbsp;&nbsp;Download Documents</a>';
                    }
                    else {
                        html += '<a class="dropdown-item disabled" href="#!" id="Actionsdown" onclick="downloaddocuments(\'' + value.Code + '\',' + index + ');"><span style="color: #8403fc;"><i class="uil-cloud-download"></i></span>&nbsp;&nbsp;Download Documents</a>';
                    }
                    html += '<a class="dropdown-item" href="#!" id="ActionsEx" onclick="viewdocuments(\'' + value.Code + '\',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-file"></i></span>&nbsp;&nbsp;View Documents</a><div class="dropdown-divider"></div></div></div></td>';
                }
                else if (currentUserName == 255 || currentUserName == 9267 || currentUserName == 291) {
                    html += '<td class=""><div class="btn-group">';
                    html += '<div class="btn-group">';
                    html += '<div type="button" data-toggle="dropdown" aria-expanded="false"><i style="color: dodgerblue; font-size:14px;" class="uil fs-0 me-2 uil-cog"></i>';
                    html += '<span class="sr-only"></span></div><div class="dropdown-menu" role="menu" style="">';
                    html += '<a class="dropdown-item" href="#!" id="ActionsEx" onclick="viewdocuments(\'' + value.Code + '\',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-file"></i></span>&nbsp;&nbsp;View Documents</a><div class="dropdown-divider"></div></div></div></td>';
                }
                else {
                    html += '<td class=""><div class="btn-group">';
                    html += '<div class="btn-group">';
                    html += '<div type="button" data-toggle="dropdown" aria-expanded="false"><i style="color: dodgerblue; font-size:14px;" class="uil fs-0 me-2 uil-cog"></i>';
                    html += '</div></div></td>';
                }

                //html += '<td class="align-middle white-space-nowrap pe-0"><div class="font-sans-serif btn-reveal-trigger position-static">';
                //html += '<button class="btn btn-sm dropdown-toggle dropdown-caret-none transition-none btn-reveal fs--2" type="button" data-bs-toggle="dropdown" data-boundary="window" aria-haspopup="true" aria-expanded="false" data-bs-reference="parent">';
                //html += '<span style="color: Mediumslateblue;"><i class="fa-solid fa-cog"></i></span></button><div class="dropdown-menu dropdown-menu-end py-2" style="">';
                //html += '<a class="dropdown-item" href="#!" id="edit" onclick="editprofile(\'' + value.Code + '\',' + index + ',0);"><span style="color: green;"><i class="fa-solid fa-pen"></i></span>&nbsp;&nbsp;Edit Profile</a>';
                //html += '<a class="dropdown-item" href="#!" id="view" onclick="viewdocuments(\'' + value.Code + '\',' + index + ');"><span style="color: dodgerblue;"><i class="fa-solid fa-file"></i></span>&nbsp;&nbsp;View Documents</a>';
                //html += '</div></div></td>';
                html += '<td>' + blankForNull(value.EmployeeID) + '</td>';
                html += '<td>' + blankForNull(value.Code) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.FullName) + '</td>';
                html += '<td>' + blankForNull(value.JoiningDate) + '</td>';
                html += '<td>' + blankForNull(value.CutOffTime) + '</td>';
                html += '<td>' + blankForNull(value.DateOfBirth) + '</td>';
                html += '<td>' + blankForNull(value.Gender) + '</td>';
                html += '<td>' + blankForNull(value.BranchName) + '</td>';
                html += '<td>' + blankForNull(value.DepartmentName) + '</td>';
                html += '<td>' + blankForNull(value.DesignationName) + '</td>';
                html += '<td>' + blankForNull(value.DomainName) + '</td>';
                html += '<td>' + blankForNull(value.Subdomain) + '</td>';
                html += '<td>' + blankForNull(value.ReportingManager) + '</td>';
                html += '<td>' + blankForNull(value.JobType) + '</td>';
                html += '<td>' + blankForNull(value.CurrentLogin) + '</td>';
                html += '<td>' + blankForNull(value.CurrentStatus) + '</td>';
                html += '<td>' + blankForNull(value.TaskProductive) + '</td>';
                html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#viewemployee')) {
                edittable.destroy();
            }
            $('#viewemployee tbody').html(html);

            //else
            {
                edittable = $('#viewemployee').DataTable({
                    dom: 'pBfti',
                    scrollX: true,
                    destroy: true,
                    "paging": true,
                    "autoWidth": true,
                    select: true,
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

                    columnDefs: [{ orderable: false, targets: 2 }],

                    buttons: [
                        {
                            extend: 'excelHtml5', title: 'Employee Details',
                            exportOptions: {
                                columns: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16],
                                format: {
                                    header: function (data, columnIdx) {
                                        // Return ONLY the first header row text
                                        return $('#viewemployee thead tr:eq(0) th').eq(columnIdx).text();
                                    }
                                }
                            },

                            //autoFilter: true,
                            //exportOptions: {

                            //},
                            //customize: function (xlsx) {
                            //    var sheet = xlsx.xl.worksheets['sheet1.xml'];
                            //    var freezePanes =
                            //        '<sheetViews><sheetView tabSelected="1" workbookViewId="0"><pane xSplit="1" ySplit="1" topLeftCell="B2"  activePane="bottomRight" state="frozen"/></sheetView></sheetViews>';
                            //    var current = sheet.children[0].innerHTML;
                            //    current = freezePanes + current;
                            //    sheet.children[0].innerHTML = current;
                            //},
                        },
                    ],
                });
            }

            //$('#fnalize tbody').on('click', 'tr', function () {
            //    row = table.row(this).data();
            //});
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });

    var isrch = 0;
    $('#viewemployee thead tr:eq(1) th').each(function () {
        if (isrch > 0 && isrch < 4) {
            var title = $(this).text();
            $(this).html('<input type="text" placeholder="Search ' + title + '" class="column_search" />');
        }
        else {
            $(this).html('');
        }
        isrch++;
    });

    $('#viewemployee thead').on('keyup', ".column_search", function () {

        edittable
            .column($(this).parent().index())
            .search(this.value)
            .draw();
    });
}

function downloaddocuments(Code, index) {

    window.location.href = "DownloadFiles.aspx?Code=" + Code;
}

function viewemp_uploaddocs_submit() {
    $('#empdocs_waitingpanel').modal('show');
    var emp_Code = document.getElementById("viewemp_code").innerHTML;

    PageMethods.uploadEmpDocuments(emp_Code, updocs_OnSuccess, updocs_OnError);
}

function updocs_OnSuccess(result) {
    if (result > 0) {
        $('#empdocs_waitingpanel').modal('hide');

        alert("File uploaded successfully");
        $("#viewemp_uploaddocs").modal("hide");
        return false;
    }
}

function updocs_OnError(error) {
    alert(error);
}
