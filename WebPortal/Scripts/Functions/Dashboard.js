var dashboard_alert_table;
var log_table;
var dasboard_currentmanpower_table;
var dasboard_currentmanpower_html;
var details_table;
var details_html;
var html = '';
var summary_total;
var summary_onfloor;
var summary_resigned;
var summary_absconding;
var bd_html;
var bdmsg_html;
var bd_table;

summary_total = 0;
summary_onfloor = 0;
summary_resigned = 0;
summary_absconding = 0;

function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

function log_BindLogDetails() {
    $('#load1').show();
    html = '';
    $.ajax({
        url: "Log.aspx/GetDailyLog",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function(data) {
            var dataArray = JSON.parse(data.d);//  
            $.each(dataArray, function(index, value) {
                html += '<tr>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Date) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.InTime) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.OutTime) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ShiftTime) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.BreakOutTime) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.BreakInTime) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.TotalBreakHours) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Hours) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ExtraHours) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.NoofHours) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.LateMark) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Partial) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ShiftRemark) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.LeaveType) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.INIP) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.OutIP) + '</td>';
                html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#log_table')) {
                log_table.destroy();
            }
            $('#log_table tbody').html(html);
            //else
            log_table = $('#log_table').DataTable({
                dom: 't',
                scrollX: true,
                destroy: true,
                "paging": false,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                'select': {
                    'style': 'single'
                },

                initComplete: function() {
                    $('#load1').hide();
                },
                "rowCallback": function(row, data) {
                    var val = data[3];
                },

                buttons: [
                    {
                        extend: 'excelHtml5', title: 'New Joinee HR Follow up', autoFilter: true,
                        exportOptions: {
                            columns: [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
                        }
                    },
                ],
            });

            //$('#fnalize tbody').on('click', 'tr', function () {
            //    row = table.row(this).data();
            //});
        },
        error: function(error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}

function dashboard_profileinfo() {

    $.ajax({
        type: "POST", url: "DashboardEmployee.aspx/BindInformation", dataType: "json", contentType: "application/json",
        success: function(res1) {
            var dataArray = JSON.parse(res1.d);
            $.each(dataArray, function(data1, value1) {
                document.getElementById("dasboard_popname").innerHTML = value1.FirstName + ' ' + value1.lastName;
                document.getElementById("dasboard_popdob").innerHTML = value1.DateOfBirth;
                document.getElementById("dasboard_poppresentaddress").innerHTML = value1.PresentAddress;
                document.getElementById("dasboard_poppermanentaddress").innerHTML = value1.PermenentAddress;
                document.getElementById("dasboard_popcontact").innerHTML = value1.CellNo;
                document.getElementById("dasboard_poppan").innerHTML = value1.PAN;
                document.getElementById("dasboard_popqualification").innerHTML = value1.Qualification;
                document.getElementById("dasboard_popbloodgroup").innerHTML = value1.BloodGroup;
                document.getElementById("dasboard_popemail").innerHTML = value1.EmailID;

                document.getElementById("dasboard_popemployeeid").innerHTML = value1.EmployeeID;
                document.getElementById("dasboard_popcode").innerHTML = value1.Code;
                document.getElementById("dasboard_popjoiningdate").innerHTML = value1.JoiningDate;
                document.getElementById("dasboard_popbranch").innerHTML = value1.WorkingBranchName;
                document.getElementById("dasboard_popdepartment").innerHTML = value1.DepartmentName;
                document.getElementById("dasboard_popdesignation").innerHTML = value1.DesignationName;
                document.getElementById("dasboard_popshift").innerHTML = value1.ShiftName;
                document.getElementById("dasboard_popworkinghours").innerHTML = value1.WorkTime;
                document.getElementById("dasboard_popcutofftime").innerHTML = value1.CutOffTime;
                document.getElementById("dasboard_popweeklyholiday").innerHTML = value1.WeeklyHolidayName;
                document.getElementById("dasboard_popofficialemail").innerHTML = value1.OfficialEmailID;
                document.getElementById("dasboard_popbankname").innerHTML = value1.BankName;
                document.getElementById("dasboard_popaccountno").innerHTML = value1.BankAccNo;
                document.getElementById("dasboard_popifsccode").innerHTML = value1.IFSCCode;
                document.getElementById("dasboard_popesicno").innerHTML = value1.ESICNo;
                document.getElementById("dasboard_poppfno").innerHTML = value1.PFNp;
                document.getElementById("dasboard_popuan").innerHTML = value1.UAN;
                document.getElementById("dasboard_popreportingmanager").innerHTML = value1.ReportingManager;

                //var myModal = new bootstrap.Modal(document.getElementById('womensDayModal'));
            });
        }
    });
    $('#dashboard_profileinfopopup').modal('show');

}

function Dashboard_BindFormInformation() {
    $.ajax({
        type: "POST", url: "DashboardEmployee.aspx/BindInformation", dataType: "json", contentType: "application/json",
        success: function(res1) {

            var dataArray = JSON.parse(res1.d);

            $.each(dataArray, function(data1, value1) {

                document.getElementById("dashboard_spnusername").innerHTML = value1.FirstName + ' ' + value1.lastName;
                document.getElementById("dashboard_spndesignation").innerHTML = value1.DesignationName;

                document.getElementById("popupGreeting").innerText = " 🌸 " + "Hi " + value1.FirstName + " 🌸 ";
                $("#festivalImage").attr("src", "../FestivalWishesImages/" + value1.FestiveImgPath);

                if (value1.Gender == "Male") {
                    document.getElementById("dashboard_userimg").src = "../dist/img/Male.png";

                    if (value1.title != "Women's Day" && value1.FestiveImgPath != null) {
                  /*      $('#festWish_PopUp').modal('show');*/
                    }
                }
                else {
                    document.getElementById("dashboard_userimg").src = "../dist/img/Female.png";

                    if (value1.FestiveImgPath != null) {
                      /*  $('#festWish_PopUp').modal('show');*/
                    }
                }
            });
        }
    });
}

function Dashboard_GetDashboardAlerts() {

    $('#load1').show();
    html = '';
    $.ajax({
        url: "DashboardEmployee.aspx/GetDashboardAlerts",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function(data) {
            var dataArray = JSON.parse(data.d);        
            var i = 0;
            $.each(dataArray, function(index, value) {
                i++;
                html += '<tr>';
                html += '<td style="display:none;">' + blankForNull(value.AlertId) + '</td>';
                html += '<td style="display:none;">' + blankForNull(i) + '</td>';
                html += '<td>' + blankForNull(value.Subject) + '</td>';
                html += '<td style="text-align:center;"><a class="dropdown-item" href="#!" id="Actions" onclick="dashboard_downloadattachment(' + value.AlertId + ',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-cloud-download"></i></span></a></td>';
                html += '<td style="text-align:center;"><a class="dropdown-item" href="#!" id="Actions" onclick="dashboard_viewalertdetails(' + value.AlertId + ',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-search-alt"></i></span></a></td>';
                html += '<td style="text-wrap: nowrap;display:none;">' + blankForNull(value.Attachment) + '</td>';
                html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#dashboard_alert_table')) {
                dashboard_alert_table.destroy();
            }
            $('#dashboard_alert_table tbody').html(html);
            
            dashboard_alert_table = $('#dashboard_alert_table').DataTable({
                dom: 't',
                scrollX: true,
                destroy: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                "pageLength": 5,
                'select': {
                    'style': 'single'
                },

                initComplete: function() {
                    $('#load1').hide();
                },

                "rowCallback": function(row, data) {
                    var val = data[3];
                },

                buttons: [
                    {
                        extend: 'excelHtml5', title: 'New Joinee HR Follow up', autoFilter: true,
                        exportOptions: {
                            columns: [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
                        }
                    },
                ],
            });

            //$('#fnalize tbody').on('click', 'tr', function () {
            //    row = table.row(this).data();
            //});
        },
        error: function(error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}

function dashboard_viewalertdetails(AlertId, Index) {
    $.ajax({
        type: "POST", url: "DashboardEmployee.aspx/BindAlertDetails", dataType: "json", contentType: "application/json",
        data: "{AlertId:" + AlertId + " }",
        success: function(res1) {
            var dataArray = JSON.parse(res1.d);
            $.each(dataArray, function(data1, value1) {
                document.getElementById("dasboard_popalertsubject").innerHTML = value1.Subject;
                document.getElementById("dasboard_popalertmessage").innerHTML = value1.Message;

            });
        }
    });
    $('#dashboard_alertdetails').modal('show');
}

function summary_totalclick(WorkingBranch, DomainId, Subdomain, Criteria) {
    var Type = document.getElementById("summary_gridheaderfilter").innerHTML;
    Dashboard_GetManpowerSumaryDetails(Type, WorkingBranch, DomainId, Subdomain, Criteria);
    $("#dashboard_summarydetails").modal("show");
}

function Dashboard_GetManpowerSumaryDetails(Type, Branch, Domain, Subdomain, Column) {
    $('#load1').show();
    details_html = '';
    $.ajax({
        url: "DashboardEmployee.aspx/CurrentManpowerSummaryDetails",
        type: "POST",
        data: "{Type:'" + Type + "', Branch:" + Branch + ", Domain:" + Domain + ", Subdomain:'" + Subdomain + "', Criteria:" + Column + "}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function(data) {
            var dataArray = JSON.parse(data.d);//          

            var i = 0;
            $.each(dataArray, function(index, value) {
                i++;
                details_html += '<tr>';
                details_html += '<td>' + blankForNull(i) + '</td>';
                details_html += '<td style="text-wrap:none;">' + blankForNull(value.Code) + '</td>';
                details_html += '<td style="text-wrap:none;">' + blankForNull(value.Name) + '</td>';
                details_html += '<td style="text-wrap:none;">' + blankForNull(value.JoiningDate) + '</td>';
                details_html += '<td style="text-wrap:none;">' + blankForNull(value.BranchName) + '</td>';
                details_html += '<td style="text-wrap:none;">' + blankForNull(value.Domain) + '</td>';
                details_html += '<td style="text-wrap:none;">' + blankForNull(value.Subdomain) + '</td>';
                details_html += '<td style="text-wrap:none;">' + blankForNull(value.DepartmentName) + '</td>';
                details_html += '<td style="text-wrap:none;">' + blankForNull(value.DesignationName) + '</td>';
                details_html += '<td style="text-wrap:none;">' + blankForNull(value.ReportingManager) + '</td>';
                details_html += '<td style="text-wrap:none;">' + blankForNull(value.DomainHead) + '</td>';
                details_html += '<td style="text-wrap:none;">' + blankForNull(value.ResignationType) + '</td>';
                details_html += '<td style="text-wrap:none;">' + blankForNull(value.ResignationDate) + '</td>';
                details_html += '<td style="text-wrap:none;">' + blankForNull(value.LastWorkingDate) + '</td>';
            });

            if ($.fn.dataTable.isDataTable('#details_table')) {
                details_table.destroy();
            }
            $('#details_table tbody').html(details_html);
            //else
            details_table = $('#details_table').DataTable({
                dom: 'Btip',
                destroy: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                "pageLength": 10,
                'select': {
                    'style': 'single'
                },

                initComplete: function() {
                    $('#load1').hide();
                },
                "rowCallback": function(row, data) {
                    var val = data[3];
                },

                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Current Manpower Details', autoFilter: true,
                        exportOptions: {
                            columns: [0, 1, 2, 3, 4, 5, 6, 7]
                        }
                    },
                ],
            });

            //$('#fnalize tbody').on('click', 'tr', function () {
            //    row = table.row(this).data();
            //});
        },
        error: function(error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}

function Dashboard_GetManpowerSumary(Type) {
    $('#load1').show();
    dasboard_currentmanpower_html = '';
    $.ajax({
        url: "DashboardEmployee.aspx/CurrentManpowerSummary",
        type: "POST",
        data: "{Type:'" + Type + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function(data) {
            var dataArray = JSON.parse(data.d);//            
            var i = 0;
            summary_total = 0;
            summary_onfloor = 0;
            summary_resigned = 0;
            summary_absconding = 0;
            $.each(dataArray, function(index, value) {
                i++;
                dasboard_currentmanpower_html += '<tr>';
                dasboard_currentmanpower_html += '<td style="display:none;">' + blankForNull(value.DomainId) + '</td>';
                dasboard_currentmanpower_html += '<td style="display:none;">' + blankForNull(value.WorkingBranch) + '</td>';
                dasboard_currentmanpower_html += '<td style="display:none;">' + blankForNull(i) + '</td>';
                dasboard_currentmanpower_html += '<td>' + blankForNull(value.BranchName) + '</td>';
                dasboard_currentmanpower_html += '<td>' + blankForNull(value.DomainGroupName) + '</td>';
                dasboard_currentmanpower_html += '<td>' + blankForNull(value.Subdomain) + '</td>';
                dasboard_currentmanpower_html += '<td style="text-align:center;"><a href="#url" onclick="summary_totalclick(' + value.WorkingBranch + ',' + value.DomainId + ',\'' + value.Subdomain + '\',1); " >' + blankForNull(value.Total) + '</a></td>';
                dasboard_currentmanpower_html += '<td style="text-align:center;"><a href="#url" onclick="summary_totalclick(' + value.WorkingBranch + ',' + value.DomainId + ',\'' + value.Subdomain + '\',2); " >' + blankForNull(value.OnFloor) + '</a></td>';
                dasboard_currentmanpower_html += '<td style="text-align:center;"><a href="#url" onclick="summary_totalclick(' + value.WorkingBranch + ',' + value.DomainId + ',\'' + value.Subdomain + '\',3); " >' + blankForNull(value.Resigned) + '</a></td>';
                dasboard_currentmanpower_html += '<td style="text-align:center;"><a href="#url" onclick="summary_totalclick(' + value.WorkingBranch + ',' + value.DomainId + ',\'' + value.Subdomain + '\',4); " >' + blankForNull(value.Absconding) + '</a></td>';
                summary_total = summary_total + parseInt(value.Total);
                summary_onfloor = summary_onfloor + parseInt(value.OnFloor);
                summary_resigned = summary_resigned + parseInt(value.Resigned);
                summary_absconding = summary_absconding + parseInt(value.Absconding);
                dasboard_currentmanpower_html += '</tr>';
                document.getElementById("dashboard_graphperiod").innerHTML = 'Period: ' + blankForNull(value.Period);
            });

            if ($.fn.dataTable.isDataTable('#dasboard_currentmanpower')) {
                dasboard_currentmanpower_table.destroy();
            }
            $('#dasboard_currentmanpower tbody').html(dasboard_currentmanpower_html);
            //else
            dasboard_currentmanpower_table = $('#dasboard_currentmanpower').DataTable({
                dom: 'tBp',
                scrollX: true,
                destroy: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                "pageLength": 10,
                'select': {
                    'style': 'single'
                },

                initComplete: function() {
                    $('#load1').hide();
                    document.getElementById("dashboard_totalemployees").innerHTML = summary_total;
                    document.getElementById("dashboard_onfloormployees").innerHTML = summary_onfloor;
                    document.getElementById("dashboard_resignedemployees").innerHTML = summary_resigned;
                    document.getElementById("dashboard_abscondingemployees").innerHTML = summary_absconding;
                    if (Type == "All")
                        document.getElementById("summary_gridheaderfilter").innerHTML = 'All Employees';
                    else if (Type == "Present")
                        document.getElementById("summary_gridheaderfilter").innerHTML = 'Present Today';
                    else if (Type == "Leave")
                        document.getElementById("summary_gridheaderfilter").innerHTML = 'Users on Leave';

                },
                "rowCallback": function(row, data) {
                    var val = data[3];
                },

                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Current Manpower Summary', autoFilter: true,
                        exportOptions: {
                            columns: [3, 4, 5, 6, 7, 8, 9]
                        }
                    },
                ],
            });

            //$('#fnalize tbody').on('click', 'tr', function () {
            //    row = table.row(this).data();
            //});
        },
        error: function(error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}

function ViewBirthdayMessages(EmployeeID) {
    location.href = 'ViewBirthdayMessages.aspx?EmployeeID=' + EmployeeID;
}

function BD_BindAllBirthdays() {
    $('#load1').show();
    bd_html = '';
    $.ajax({
        url: "ViewBirthdays.aspx/GetAllBirthdays",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function(data) {
            var dataArray = JSON.parse(data.d);//            
            $.each(dataArray, function(index, value) {
                bd_html += '<tr>';
                bd_html += '<td style="text-wrap: nowrap;text-align:center;">' + blankForNull((index + 1)) + '</td>';
                bd_html += '<td style="text-align:center;"><a class="dropdown-item" href="#!" id="Actions" onclick="ViewBirthdayMessages(' + value.EmployeeID + ',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-pen"></i></span></a></td>';
                bd_html += '<td style="display:none;">' + blankForNull(value.EmployeeID) + '</td>';
                bd_html += '<td>' + blankForNull(value.Code) + '</td>';
                bd_html += '<td>' + blankForNull(value.Name) + '</td>';
                bd_html += '<td>' + blankForNull(value.DateOfBirth) + '</td>';
                bd_html += '<td>' + blankForNull(value.BranchName) + '</td>';
                bd_html += '<td>' + blankForNull(value.DepartmentName) + '</td>';
                bd_html += '<td>' + blankForNull(value.DesignationName) + '</td>';
                bd_html += '<td>' + blankForNull(value.ReportingManager) + '</td>';
                bd_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#bdash_list')) {
                bd_table.destroy();
            }
            $('#bdash_list tbody').html(bd_html);
            //else
            bd_table = $('#bdash_list').DataTable({
                dom: 'tp',
                scrollX: true,
                destroy: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                "pageLength": 10,
                'select': {
                    'style': 'single'
                },

                initComplete: function() {
                    $('#load1').hide();
                },
                "rowCallback": function(row, data) {
                },
            });

            //$('#fnalize tbody').on('click', 'tr', function () {
            //    row = table.row(this).data();
            //});
        },

        error: function(error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}

function BD_BindAllBirthdayMessages() {
    $('#load1').show();
    bdmsg_html = '';
    const urlParams = new URLSearchParams(window.location.search);
    var EmpID = urlParams.get('EmployeeID');
    if (EmpID == null) {
        EmpID = 0;
    }
    $.ajax({
        url: "ViewBirthdayMessages.aspx/GetAllBirthdaysMessages",
        type: "POST",
        data: "{EmployeeID:" + EmpID + "}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function(data) {
            var dataArray = JSON.parse(data.d);// 
            if (dataArray != "") {
                bdmsg_html = '<div class="timeline">';
                $.each(dataArray, function(index, value) {

                    var addeddate = eval(value.AddedDate.replace(/\/Date\((\d+)\)\//gi, "new Date($1).toLocaleDateString(\"en-US\")+' '+new Date($1).toLocaleTimeString(\"en-US\")"));
                    bdmsg_html += '<div>';
                    bdmsg_html += '<i class="fas fa-user-tie"></i>';
                    bdmsg_html += '<div class="timeline-item"><span class="time" ><i class="fas fa-clock"></i> ' + addeddate + '</span><h6 class="timeline-header" style="font-size:12px!important;">';
                    bdmsg_html += '<a href="#">' + value.FromName + '</a> sent you wishes</h6><div class="timeline-body"><h5 style="font-size:14px!important;">';
                    bdmsg_html += value.Message + '</h5></div><div class="timeline-footer"></div></div></div>';
                    //if (value.Gender == 'Female')
                    //    bdmsg_html += '<div class="item item-visible"><div class="image"><img src="../dist/img/Female.png" Width="50" alt="User"></div>';
                    //else
                    //    bdmsg_html += '<div class="item item-visible"><div class="image"><img src="../dist/img/Male.png" Width="50" alt="User"></div>';
                    //bdmsg_html += '<div class="text"><div class="heading" style="font-style:italic;font-family:Verdana!important;font-size:16px!important;"><a href="#"><span>' + value.Message + '</a></span></div>';
                    //bdmsg_html += '<span>' + value.FromName + '</span><span class="date" style="float:right;"><span>' + addeddate + '</span></span></div></div>';
                });
                bdmsg_html += '</div>';
            }
            else {
                bdmsg_html += '<div>';
                bdmsg_html += '<span>Sorry! Currently you dont have any message.You can check messages later by clicking SATR Icon on the right top corner of website.</span ></div ></div > ';
            }
            document.getElementById("dvMessages").innerHTML = bdmsg_html;

            $("#load1").hide();
        },
        error: function(error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}

function getPendingTaskNotifications() {
    var dash_nothtml;
    var dash_tblnotifications;
    var sidebarnot = '';
    dash_nothtml = '';
    $.ajax({
        url: "DashboardEmployee.aspx/GetPendingTask",
        type: "POST",
        data: "{Type:'" + Type + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function(data) {
            var dataArray = JSON.parse(data.d);//   

            if (dataArray == "" || dataArray == null) {
                $("#dash_notifications").modal("hide");
                return;
            }
            else {
                $("#dash_notifications").modal("show");

            }
            $.each(dataArray, function(index, value) {
                dash_nothtml += '<tr>';
                dash_nothtml += '<td style="text-align:left;"><a style="font-size:13px; color:black; text-decoration:underline; font-style:italic;" href="' + value.Url + '">' + blankForNull(value.Text) + '</a></td>';
                dash_nothtml += '</tr>';
            });
            if ($.fn.dataTable.isDataTable('#dash_tblnotifications')) {
                dash_tblnotifications.destroy();
            }
            $('#dash_tblnotifications tbody').html(dash_nothtml);
            //else
            dash_tblnotifications = $('#dash_tblnotifications').DataTable({
                dom: 'tp',

                destroy: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                'select': {
                    'style': 'single'
                },

                initComplete: function() {
                    $('#load1').hide();
                },

                "rowCallback": function(row, data) {
                },

            });

            //$('#fnalize tbody').on('click', 'tr', function () {
            //    row = table.row(this).data();
            //});
        },

        error: function(error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}

function getPendingTaskNotifications_Sidebar() {
    var sidebarnot = '';
    var i = 0;
    dash_nothtml = '';
    $.ajax({
        url: "DashboardEmployee.aspx/GetPendingTask",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function(data) {
            var dataArray = JSON.parse(data.d);//   
            //if (dataArray == null || dataArray == "") {
            //    $("#dash_notifications").modal("hide");
            //    return;
            //}
            //else {
            //    $("#dash_notifications").modal("show");
            //}
            $.each(dataArray, function(index, value) {
                i++;
                sidebarnot += '<div class="mb-3" style="text-align:left;"><span><a style="font-size:13px; color:white; text-decoration:underline; font-style:italic;" href="' + value.Url + '">' + blankForNull(value.Text) + '</a></span></div>';
            });
            if (i > 0) {
                document.getElementById("admin_pendingtask").innerHTML = i;
            }
            document.getElementById("dvsidebar").innerHTML = sidebarnot;

        },

        error: function(error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}

function GetDashboardPerformanceDetails() {
    $('#load1').show();

    var html = '';
    $.ajax({
        url: "DasboardPerformanceDetails.aspx/GetDashboardPerformanceDetails",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function(data) {

            var dataArray = JSON.parse(data.d);//  
            $.each(dataArray, function(index, item) {
                html += '<tr>';
                html += '<td style="text-wrap: nowrap;">' + item.MonthYear + '</td>';
                html += '<td style="text-wrap: nowrap;">' + item.Code + '</td>';
                html += '<td style="text-wrap: nowrap;">' + item.Name + '</td>';
                html += '<td style="text-wrap: nowrap;">' + item.JoiningDate + '</td>';
                html += '<td style="text-wrap: nowrap;">' + item.Tenure + '</td>';
                html += '<td style="text-wrap: nowrap;">' + item.DaysWorked + '</td>';
                html += '<td style="text-wrap: nowrap;"><a href="#">' + item.Production + '</a></td>';
                html += '<td style="text-wrap: nowrap;">' + item.ExpectedProductivity + '</td>';
                html += '<td style="text-wrap: nowrap;">' + item.AvgTarget + '</td>';
                html += '<td style="text-wrap: nowrap;"><a href="#">' + item.InternalError + '</a></td>';
                html += '<td style="text-wrap: nowrap;"><a href="#">' + item.ClientError + '</a></td>';
                html += '<td style="text-wrap: nowrap;">' + item.TotalError + '</td>';
                html += '<td style="text-wrap: nowrap;">' + item.Appreciations + '</td>';
                html += '<td style="text-wrap: nowrap;">' + item.Warnings + '</td>';
                html += '<td style="text-wrap: nowrap;"><a href="#">' + item.ProductionPerc + '</a></td>';
                html += '<td style="text-wrap: nowrap;">' + item.Accuracy + '</td>';
                html += '<td style="text-wrap: nowrap;">' + item.Attendance + '</td>';
                html += '<td style="text-wrap: nowrap;background:salmon">' + item.ProdGrade + '</td>';
                html += '<td style="text-wrap: nowrap;background:salmon">' + item.QAGrade + '</td>';
                html += '<td style="text-wrap: nowrap;background:salmon">' + item.AttendanceGrade + '</td>';
                html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#dup_table')) {
                dup_table.destroy();
            }
            $('#dup_table tbody').html(html);
            //else
            dup_table = $('#dup_table').DataTable({
                dom: 't',
                scrollX: true,
                destroy: true,
                "paging": false,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                'select': {
                    'style': 'single'
                },

                initComplete: function() {
                    $('#load1').hide();
                },
            });

            //$('#fnalize tbody').on('click', 'tr', function () {
            //    row = table.row(this).data();
            //});
        },
        error: function(error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}

function GetDashboardAttendanceDetails() {

    $('#grdAttendancePerMonthwise').DataTable({

        "ajax": {
            "url": "DetailedAttendancePercentage.aspx/GetMonthwiseAttendance",
            "type": "POST",
            "datatype": "json",
            "contentType": "application/json; charset=utf-8",
            "dataSrc": function(json) {
                return JSON.parse(json.d);
            }
        },
        "columns": [
            { "data": "Code" },
            { "data": "Month" },
            { "data": "Year" },
            { "data": "TotalCalenderDays" },
            { "data": "AbsentDays" },
            { "data": "PartialCount" },
            { "data": "PartialDays" },
            { "data": "TotalAbsentDays" },
            { "data": "SalaryPresentDays" },
            {
                data: "AttendancePercOnTotalDays",
                render: function(data) {

                    var val = parseFloat(data);

                    if (val < 95)
                        return '<span style="background:red;color:white;padding:4px 8px;border-radius:3px;">' + data + '</span>';
                    else
                        return data;
                }
            },

            { "data": "Latemarks" },
            { "data": "RemovedLatemarks" },
            { "data": "TotalLatemarks" }
        ],
        "pageLength": 20,
        "responsive": true
    });

    return false;
}

function SendWish() {

    var msg = $("#txtWish").val().trim();
    if (msg == "") {
        alert("Please write a birthday wish.");
        return;
    }
    var urlParams = new URLSearchParams(window.location.search);
    var empId = urlParams.get("EmployeeID");

    $.ajax({
        type: "POST",
        url: "ViewBirthdayMessages.aspx/SendBirthdayWish",
        data: JSON.stringify({
            message: msg,
            EmployeeID: empId
        }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        success: function() {

            $("#txtWish").val("");

            BD_BindAllBirthdayMessages(); // reload wishes
        }
    });

}

function checkBirthday1() {

    $.ajax({
        type: "POST",
        url: "DashboardEmployee.aspx/CheckBirthday",
        data: '{}',
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        success: function(res) {

            if (res.d.IsBirthday) {

                $("#lblBirthdayName").text(res.d.Name);

                $("#birthdayModal").modal("show");
                confetti({
                    particleCount: 200,
                    spread: 120,
                    origin: { y: 0.6 }
                });
            }
        }
    });
}

function loadUserprojectnotifications() {
    $.ajax({
        type: "POST",
        url: "DashboardEmployee.aspx/GetDashboardProjectAlerts",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function(res) {
            if (!res.d) return;

            alertsQueue = JSON.parse(res.d);

            if (alertsQueue.length > 0) {
                currentIndex = 0;
                showNextAlert();
                //setTimeout(showNextAlert, 300);
            }
        }
    });
}

function showNextAlert() {

    if (currentIndex >= alertsQueue.length) return;

    var alert = alertsQueue[currentIndex];

    $("#alertTitle").text(alert.Subject);
    $("#alertMessage").text(alert.Message);

    if (alert.Attachment && alert.Attachment !== "") {
        $("#attachmentDiv").show();

        // $("#downloadFile").attr("href", alert.Attachment);
        $("#downloadFile").attr("href", alert.Attachment).attr("download", "");   // forces download
    } else {
        $("#attachmentDiv").hide();
    }

    if (currentIndex === alertsQueue.length - 1) {
        $("#btnClose").show();
    } else {
        $("#btnClose").hide();
    }

    $("#alertModal").modal("show");
}

function GotToNextAlert() {
    var alert1 = alertsQueue[currentIndex];
    markAsRead(alert1.AlertId);

    currentIndex++;

    if (currentIndex < alertsQueue.length) {
        showNextAlert();
    }
    return false;
}

function markAsRead(alertId) {
    $.ajax({
        type: "POST",
        url: "DashboardEmployee.aspx/UpdateProjectReadAlertStatus",
        data: "{ AlertID: " + alertId + " }",
        contentType: "application/json; charset=utf-8"
    });

}


/*---------Employee Work Anniversary ---------*/

function workAnniversary() {

    $.ajax({
        type: "POST",
        url: "DashboardEmployee.aspx/GetEmpWorkAnniversary",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function(response) {

            var data = response.d;

            if (data.length > 0) {

                var html = "";

                for (var i = 0; i < data.length; i++) {

                    let jubilee = getJubileeDetails(data[i].YearsCompleted);

                    if (jubilee) {
                        document.getElementById("workAnn_header").innerHTML =
                            `<b>💐  WORK  ANNIVERSARY - <span style="color:${jubilee.color}; font-weight:bold;">${jubilee.title}💐</b> </span>`;
                    } else {
                        document.getElementById("workAnn_header").innerHTML = `<b>💐 WORK  ANNIVERSARY 💐</b>`;
                    }

                    html += `
<div class="employees-card premium-card">

    <div class="company-logo">🏆</div>

    <div class="emps-name">
        ${data[i].EmpName}
    </div>

    <div class="emp-designation">
        ${data[i].Designation}
    </div>

    <div class="divider" ></div>

    <div class="emp-years">
        ${data[i].YearsCompleted} Years of Excellence
    </div>

 <div class="anniversary-msg">
        ${(jubilee.length > 0) ? jubilee.message: getAnniversaryMessage(data[i].YearsCompleted)}
</div>

</div>
`;
                }

                $("#anniversaryContainer").html(html);

                setTimeout(function() {
                    $("#anniversaryModal").modal("show");
                    startConfetti({
                        particleCount: 120,
                        spread: 80,
                        origin: { y: 0.6 }
                    });
                }, 500);
            }
        }
    });
}

function startConfetti() {
    var duration = 3 * 1000;
    var end = Date.now() + duration;

    (function frame() {
        confetti({
            particleCount: 5,
            angle: 60,
            spread: 55,
            origin: { x: 0 }
        });
        confetti({
            particleCount: 5,
            angle: 120,
            spread: 55,
            origin: { x: 1 }
        });

        if (Date.now() < end) {
            requestAnimationFrame(frame);
        }
    }());
}

function createBalloons() {
    for (let i = 0; i < 15; i++) {
        let balloon = document.createElement("div");
        balloon.className = "balloon";
        balloon.style.left = Math.random() * 100 + "%";
        balloon.style.background = getRandomColor();
        balloon.style.animationDuration = (6 + Math.random() * 5) + "s";
        document.getElementById("balloons").appendChild(balloon);
    }
}

function getRandomColor() {
    var colors = ["red", "blue", "green", "orange", "purple", "gold"];
    return colors[Math.floor(Math.random() * colors.length)];
}

function getAnniversaryMessage(years) {

    if (years <= 1)
        return "Wishing you a great start to a wonderful journey with us.";
    else if (years <= 3)
        return "Thank you for growing with us and being a valuable team member.";
    else if (years <= 5)
        return "Your dedication and hard work inspire everyone around you.";
    else if (years <= 10)
        return "We truly appreciate your long-term commitment and contribution.";
    else if (years <= 15)
        return "Your experience and dedication are truly valuable to our organization.";
    else if (years <= 20)
        return "Two decades of dedication – we sincerely appreciate your journey with us.";
    else if (years < 25)
        return "Your long-term commitment and contribution mean a lot to us.";

    // Jubilee Messages
    else if (years == 25)
        return "Happy Silver Jubilee! Celebrating 25 years of dedication, loyalty, and excellence.";
    else if (years == 30)
        return "Happy Pearl Jubilee! Your journey with us is truly inspiring.";
    else if (years == 35)
        return "Happy Coral Jubilee! Thank you for your continued dedication and service.";
    else if (years == 40)
        return "Happy Ruby Jubilee! Your contribution over the years has been invaluable.";
    else if (years == 45)
        return "Happy Sapphire Jubilee! We deeply appreciate your incredible journey with us.";
    else if (years >= 50)
        return "Happy Golden Jubilee! A legendary milestone of dedication and loyalty.";

    else
        return "You are a pillar of our organization. Thank you for everything.";
}

function getJubileeDetails(years) {

    if (years == 25) {
        return {
            title: "Silver Jubilee",
            message: "Celebrating 25 years of dedication, loyalty, and excellence. Your contribution has been invaluable to our organization.",
            color: "#C0C0C0"
        };
    }
    else if (years == 30) {
        return {
            title: "Pearl Jubilee",
            message: "30 years of commitment and dedication is truly inspiring. Thank you for being an integral part of our journey.",
            color: "#FDEEF4"
        };
    }
    else if (years == 35) {
        return {
            title: "Coral Jubilee",
            message: "Celebrating 35 years of incredible service and dedication. We truly appreciate your journey with us.",
            color: "#FF7F50"
        };
    }
    else if (years == 40) {
        return {
            title: "Ruby Jubilee",
            message: "40 years of loyalty and dedication is a remarkable achievement. Thank you for your priceless contribution.",
            color: "#9B111E"
        };
    }
    else if (years == 45) {
        return {
            title: "Sapphire Jubilee",
            message: "Your 45 years of dedication and commitment are deeply respected and appreciated.",
            color: "#0F52BA"
        };
    }
    else if (years >= 50) {
        return {
            title: "Golden Jubilee",
            message: "A Golden Jubilee milestone! Thank you for your legendary dedication and lifetime contribution.",
            color: "#D4AF37"
        };
    }
    else {
        return ""; /* {title: "Work Anniversary",message: getAnniversaryMessage(years),color: "#00b3b3"};*/
    }
}

function showantherPopUp() {
   
    location.reload();
} 


/*---------All Emps Work Anniversary ---------*/

function loadHrAnniversary() {

    $.ajax({
        type: "POST",
        url: "DashboardEmployee.aspx/GetTodayAnniversaries",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {

            var data = response.d;

            var html = "";

            if (data.length > 0) {

                for (var i = 0; i < data.length; i++) {

                    html += "<div class='hr-card'>";
                    html += "<div class='hr-card-name'>" + data[i].EmpName + "</div>";
                    html += "<div class='hr-card-dept'>" + data[i].DepartmentName + "</div>";
                    html += "<div class='hr-card-years'>" + data[i].YearsCompleted + " Years Completed</div>";
                    html += "</div>";
                }

                $("#hrAnniversaryCards").html(html);

                // OPEN MODAL
                $("#hrAnniversaryModal").fadeIn();
            }
        }
    });
}

function closeHrModal() {
    $("#hrAnniversaryModal").fadeOut();
}

/*--------- Password Reset Alert ---------*/

function closePasswprdPopUp() {
    document.getElementById("expiryModal").style.display = "none";
    return false;
}


/*--------- Pop-Up Sequence ---------*/
function handlePopupsInSequence() {

    const today = new Date().toISOString().split('T')[0];

    // 🔢 EXACT SEQUENCE (1 → 9)
    const popupQueue = [

        // 1. First Time Only
        { seq: 1, type: "first_time", key: "welcomeIntroShown", id: "welcomeIntro", custom: true },

        // 2. Once in Day
        { seq: 2, type: "daily", key: "birthdayModal", id: "birthdayModal" },

        // 3. Once in Day
        { seq: 3, type: "daily", key: "anniversaryModal", id: "anniversaryModal" },

        // 4. Once in Day
        { seq: 4, type: "daily", key: "birthdayModal_all", id: "birthdayModal_all" },

        // 5. Once in Day
        { seq: 5, type: "daily", key: "festWish_PopUp", id: "festWish_PopUp" },

        // 6. Once in Day
        { seq: 6, type: "daily", key: "alertModal", id: "alertModal" },

        // 7. Each Login
        { seq: 7, type: "always", id: "dashboard_alertdetails" },

        // 8. Each Login
        { seq: 8, type: "always", id: "expiryModal" },

        // 9. Each Login
        { seq: 9, type: "always", id: "dash_notifications" }
    ];

    let index = 0;

    function processNext() {

        if (index >= popupQueue.length) return;

        let popup = popupQueue[index];
        let shouldShow = false;

        // ✅ Frequency Check
        if (popup.type === "first_time") {
            if (!localStorage.getItem(popup.key)) {
                shouldShow = true;
                localStorage.setItem(popup.key, "true");
            }
        }
        else if (popup.type === "daily") {
            if (localStorage.getItem(popup.key) !== today) {
                shouldShow = true;
                localStorage.setItem(popup.key, today);
            }
        }
        else if (popup.type === "always") {
            shouldShow = true;
        }

        // ✅ Show Popup
        if (shouldShow) {

            let el = document.getElementById(popup.id);

            if (!el) {
                index++;
                processNext();
                return;
            }

            // 🔹 Custom Intro (Non-Bootstrap)
            if (popup.custom) {
                el.style.display = "block";

                // You must have a close button with class "closeIntro"
                el.querySelector(".closeIntro")?.addEventListener("click", function () {
                    el.style.display = "none";
                    index++;
                    processNext();
                });
            }
            else {
                let modal = new bootstrap.Modal(el);
                modal.show();

                // When closed → next popup
                el.addEventListener('hidden.bs.modal', function handler() {
                    el.removeEventListener('hidden.bs.modal', handler);
                    index++;
                    processNext();
                });
            }

        } else {
            // Skip if not needed
            index++;
            processNext();
        }
    }

    processNext();
}

