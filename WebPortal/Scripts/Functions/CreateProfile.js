function showError(message, elementId) {

    Swal.fire({
        icon: 'warning',
        title: 'Validation Message',
        text: message,
        confirmButtonColor: '#3085d6'
    });

    if (elementId != "") {
        document.getElementById(elementId).focus();
    }

    return false;
}

function create_submitdata() {

    var ddlrequisition = document.getElementById("requisition");
    var requisition = ddlrequisition.options[ddlrequisition.selectedIndex].value;

    var code = document.getElementById("code").value;

    var ddlTitle = document.getElementById("title");
    var title = ddlTitle.options[ddlTitle.selectedIndex].value;

    var firstname = document.getElementById("firstname").value;
    var middlename = document.getElementById("middlename").value;
    var lastname = document.getElementById("lastname").value;

    var ddlemployeetype = document.getElementById("employeetype");
    var employeetype = ddlemployeetype.options[ddlemployeetype.selectedIndex].value;

    var ddlgender = document.getElementById("gender");
    var gender = ddlgender.options[ddlgender.selectedIndex].value;

    var pan = document.getElementById("pan").value;
    var presentaddress = document.getElementById("presentaddress").value;
    var permanentaddress = document.getElementById("permanentaddress").value;
    var email = document.getElementById("email").value;
    var qualification = document.getElementById("qualification").value;
    var cellno = document.getElementById("cellno").value;
    var restelno = document.getElementById("restelno").value;
    var birthdate = document.getElementById("birthdate").value;

    var ddlbloodgroup = document.getElementById("bloodgroup");
    var bloodgroup = ddlbloodgroup.options[ddlbloodgroup.selectedIndex].value;

    var ddlbranch = document.getElementById("branch");
    var branch = ddlbranch.options[ddlbranch.selectedIndex].value;
    var branchname = ddlbranch.options[ddlbranch.selectedIndex].text;

    var ddldepartment = document.getElementById("department");
    var department = ddldepartment.options[ddldepartment.selectedIndex].value;
    var departmentname = ddldepartment.options[ddldepartment.selectedIndex].text;

    var ddldesignation = document.getElementById("designation");
    var designation = ddldesignation.options[ddldesignation.selectedIndex].value;
    var designationname = ddldesignation.options[ddldesignation.selectedIndex].text;

    var ddlreportingmanager = document.getElementById("reportingmanager");
    var reportingmanager = ddlreportingmanager.options[ddlreportingmanager.selectedIndex].value;
    var reportingmanagername = ddlreportingmanager.options[ddlreportingmanager.selectedIndex].text;

    var ddlshift = document.getElementById("shift");
    var shift = ddlshift.options[ddlshift.selectedIndex].value;
    var shiftname = ddlshift.options[ddlshift.selectedIndex].text;

    var cutofftime = document.getElementById("cutofftime").value;
    var joiningdate = document.getElementById("joiningdate").value;
    var salary = document.getElementById("salary").value;

    var ddlworkinghours = document.getElementById("workinghours");
    var workinghours = ddlworkinghours.options[ddlworkinghours.selectedIndex].value;
    var workinghourstext = ddlworkinghours.options[ddlworkinghours.selectedIndex].text;

    /*alert(workinghourstext);*/

    var ddlweeklyholiday = document.getElementById("weeklyholiday");
    var weeklyholiday = ddlweeklyholiday.options[ddlweeklyholiday.selectedIndex].value;
    var weeklyholidayname = ddlweeklyholiday.options[ddlweeklyholiday.selectedIndex].text;

    var ddlprojects = document.getElementById("projects");
    var projectsname = ddlprojects.options[ddlprojects.selectedIndex].text;

    var projects = ddlprojects.options[ddlprojects.selectedIndex].value;

    if (projects == "")
        projects = 0;

    var process = document.getElementById("process").value;

    var ddltaskproductive = document.getElementById("taskproductive");
    var taskproductive = ddltaskproductive.options[ddltaskproductive.selectedIndex].value;

    var ddldomain = document.getElementById("domain");
    var domain = ddldomain.options[ddldomain.selectedIndex].value;
    var domainname = ddldomain.options[ddldomain.selectedIndex].text;

    var ddlsubdomain = document.getElementById("subdomain");
    var subdomainvalue = ddlsubdomain.options[ddlsubdomain.selectedIndex].value;
    var subdomain = ddlsubdomain.options[ddlsubdomain.selectedIndex].text;

    var employeeremark = document.getElementById("remark").value;
    var appointmentdate = document.getElementById("appointmentdate").value;
    var aadharNo = document.getElementById("aadharno").value;
    var uan = document.getElementById("uan").value;
    var esicno = document.getElementById("esicno").value;
    var pfno = document.getElementById("pfno").value;
    var officialemail = document.getElementById("officialemail").value;

    var ddlpolicy = document.getElementById("policy");
    var policy = ddlpolicy.options[ddlpolicy.selectedIndex].value;

    var ddljobtype = document.getElementById("jobtype");
    var e_jobtype = ddljobtype.options[ddljobtype.selectedIndex].value;

    var chkagreement = document.getElementById("chkagreement");

    var reaccountno = document.getElementById("reaccountno").value;
    var reifsccode = document.getElementById("reifsccode").value;

    var agreementdate = '';
    var expirydate = '';

    var ddlPeriod = document.getElementById("agreementperiod");
    var period = ddlPeriod.options[ddlPeriod.selectedIndex].value;

    if (period == "")
        period = "0";

    if (chkagreement.checked == true) {

        agreementdate = document.getElementById("agreementdate").value;
        expirydate = document.getElementById("agreementexpirydate").value;

    } else {

        agreementdate = '';
        expirydate = '';
    }

    var ddlbankname = document.getElementById("bankname");
    var bankname = ddlbankname.options[ddlbankname.selectedIndex].value;

    var accountno = document.getElementById("accountno").value;
    var ifsccode = document.getElementById("ifsccode").value;
    var attachment = document.getElementById("accountattachment").value;

    // Validation

    if (requisition == "")
        return showError("Please select requisition.", "requisition");

    if (title == "")
        return showError("Please select title.", "title");

    if (employeetype == "")
        return showError("Please select employee type.", "employeetype");

    if (gender == "")
        return showError("Please select gender.", "gender");

    if (pan == "")
        return showError("Please enter PAN.", "pan");

    if (presentaddress == "")
        return showError("Please enter present address.", "presentaddress");

    if (permanentaddress == "")
        return showError("Please enter permanent address.", "permanentaddress");

    if (email == "")
        return showError("Please enter email address.", "email");

    if (qualification == "")
        return showError("Please enter qualification.", "qualification");

    if (cellno == "")
        return showError("Please enter mobile number.", "cellno");

    if (birthdate == "")
        return showError("Please select birth date.", "birthdate");

    if (bloodgroup == "")
        return showError("Please select blood group.", "bloodgroup");

    if (joiningdate == "")
        return showError("Please select joining date.", "joiningdate");

    if (salary == "")
        return showError("Please enter salary.", "salary");

    if (branch == "")
        return showError("Please select branch.", "branch");

    if (department == "")
        return showError("Please select department.", "department");

    if (designation == "")
        return showError("Please select designation.", "designation");

    if (reportingmanager == "")
        return showError("Please select reporting manager.", "reportingmanager");

    if (shift == "")
        return showError("Please select shift.", "shift");

    if (cutofftime == "")
        return showError("Please enter cutoff time.", "cutofftime");

    if (workinghours == "")
        return showError("Please select working hours.", "workinghours");

    if (weeklyholiday == "")
        return showError("Please select weekly holiday.", "weeklyholiday");

    if (projects == "")
        return showError("Please select projects.", "projects");

    if (taskproductive == "")
        return showError("Please select task/productive.", "taskproductive");

    if (domain == "")
        return showError("Please select domain.", "domain");

    if (subdomainvalue == "")
        return showError("Please select subdomain.", "subdomain");

    if (appointmentdate == "")
        return showError("Please select appointment date.", "appointmentdate");

    if (aadharNo == "")
        return showError("Please enter Aadhar number.", "aadharno");

    if (e_jobtype == "")
        return showError("Please select Job Type.", "jobtype");

    document.getElementById("btnSubmit").disabled = true;

    if (document.getElementById("btnSubmit").innerHTML == "Submit") {

        PageMethods.InsertProfile(
            code, title, firstname, middlename, lastname, gender,
            presentaddress, permanentaddress, email, qualification,
            cellno, restelno, birthdate, bloodgroup, requisition, pan,
            joiningdate, salary, branch, branchname, department,
            departmentname, designation, designationname, appointmentdate,
            projects, projectsname, process, reportingmanager,
            reportingmanagername, shift, shiftname, cutofftime,
            workinghours, workinghourstext, employeeremark,
            chkagreement.checked, period, agreementdate, expirydate,
            officialemail, bankname, accountno, ifsccode, aadharNo,
            uan, esicno, pfno, weeklyholiday, weeklyholidayname,
            employeetype, domain, subdomain, taskproductive,
            policy, domainname, e_jobtype,
            OnSuccessSubmit,
            OnErrorSubmit
        );

    }
    else if (document.getElementById("btnSubmit").innerHTML == "Update") {

        PageMethods.UpdateEmployeeInfo(
            code, title, firstname, middlename, lastname, gender,
            presentaddress, permanentaddress, email, qualification,
            cellno, restelno, birthdate, bloodgroup, requisition, pan,
            joiningdate, salary, branch, branchname, department,
            departmentname, designation, designationname, appointmentdate,
            projects, projectsname, process, reportingmanager,
            reportingmanagername, shift, shiftname, cutofftime,
            workinghours, workinghourstext, employeeremark,
            chkagreement.checked, period, agreementdate, expirydate,
            officialemail, bankname, accountno, ifsccode, aadharNo,
            uan, esicno, pfno, weeklyholiday, weeklyholidayname,
            employeetype, domain, subdomain, taskproductive,
            policy, domainname, reaccountno, reifsccode,
            e_jobtype,
            OnSuccessUpdate,
            OnErrorUpdate
        );
    }

    return false;
}

function OnSuccessSubmit(result) {

    Swal.fire({
        icon: 'success',
        title: 'Success',
        text: 'Profile has been created successfully.',
        confirmButtonColor: '#28a745'
    }).then((result) => {
        if (result.isConfirmed) {
            window.location.href = 'ViewEmployee.aspx';
        }
    });

    document.getElementById("btnSubmit").disabled = false;

    return false;
}

function OnErrorSubmit(error) {

    Swal.fire({
        icon: 'error',
        title: 'Error',
        text: 'Oops! Technical error occurred while creating profile.',
        confirmButtonColor: '#d33'
    });

    document.getElementById("btnSubmit").disabled = false;

    return false;
}

function OnSuccessUpdate(result) {

    Swal.fire({
        icon: 'success',
        title: 'Updated',
        text: 'Employee information updated successfully.',
        confirmButtonColor: '#28a745'
    }).then((result) => {
        if (result.isConfirmed) {
            window.location.href = 'ViewEmployee.aspx'; // redirect page
        }
    });
    document.getElementById("btnSubmit").disabled = false;

    return false;
}

function OnErrorUpdate(error) {

    Swal.fire({
        icon: 'error',
        title: 'Error',
        text: 'Oops! Technical error occurred while updating employee information.',
        confirmButtonColor: '#d33'
    });

    document.getElementById("btnSubmit").disabled = false;

    return false;
}


/*--------------- bind user info ---------------*/

function BindExistingInfo(Code) {

    if (Code != '') {
        $("#load1").show();
        $.ajax({
            type: "POST", url: "CreateProfile.aspx/GetEmployeeDetailsByCode", dataType: "json", contentType: "application/json", data: "{Code:'" + Code + "'}",
            success: function (res) {
                var dataArray = JSON.parse(res.d);//
                $.each(dataArray, function (index, value) {
                    document.getElementById("code").value = value.Code;
                    document.getElementById("firstname").value = value.FirstName;
                    document.getElementById("middlename").value = value.MiddleName;
                    document.getElementById("lastname").value = value.lastName;
                    document.getElementById("code").disabled = true;
                    $("#employeetype").val(value.EmployeeType);
                    $("#gender").val(value.Gender);
                    document.getElementById("pan").value = value.PAN;
                    document.getElementById("presentaddress").value = value.PresentAddress;
                    document.getElementById("permanentaddress").value = value.PermenentAddress;
                    document.getElementById("email").value = value.EmailID;
                    document.getElementById("qualification").value = value.Qualification;
                    document.getElementById("cellno").value = value.CellNo;
                    document.getElementById("restelno").value = value.ResTelNo;
                    document.getElementById("aadharno").value = value.AadharNo;

                    var date = new Date(value.DateOfBirth);
                    var day = date.getDate();
                    if (day < 10)
                        day = '0' + day
                    var month = date.getMonth() + 1;
                    if (month < 10)
                        month = '0' + month
                    var year = date.getFullYear();
                    var actualdate = year + "-" + (month) + "-" + (day);
                    $("#birthdate").val(actualdate);

                    date = new Date(value.JoiningDate);
                    day = date.getDate();
                    if (day < 10)
                        day = '0' + day
                    month = date.getMonth() + 1;
                    if (month < 10)
                        month = '0' + month
                    year = date.getFullYear();
                    actualdate = year + "-" + (month) + "-" + (day);
                    $("#joiningdate").val(actualdate);
                    $("#bloodgroup").val(value.BloodGroup);
                    $("#title").val(value.Title);
                    document.getElementById("salary").value = value.Salary;

                    //Working branch selection
                    var select = document.getElementById("branch");
                    let options = select.getElementsByTagName('option');


                    for (var i = options.length; i--;) {
                        select.removeChild(options[i]);
                    }
                    $("#branch").append($("<option></option>").val("").html("Select"));
                    $.ajax({
                        type: "POST", url: "CreateProfile.aspx/GetBranches", dataType: "json", contentType: "application/json",
                        success: function (res) {
                            $.each(res.d, function (data, value) {
                                $("#branch").append($("<option></option>").val(value.BranchID).html(value.BranchName));
                            })
                            $("#branch").val(value.WorkingBranch);
                        }
                    });
                    //Department Selection
                    select = document.getElementById("department");
                    options = select.getElementsByTagName('option');

                    for (var i = options.length; i--;) {
                        select.removeChild(options[i]);
                    }
                    $.ajax({
                        type: "POST", url: "CreateProfile.aspx/GetDepartment", dataType: "json", contentType: "application/json",
                        success: function (res) {
                            $.each(res.d, function (data, value) {
                                $("#department").append($("<option></option>").val(value.DepartmentID).html(value.DepartmentName));
                            })
                            $("#department").val(value.Department);
                        }
                    });

                    //Designation Selection
                    select = document.getElementById("designation");
                    options = select.getElementsByTagName('option');

                    for (var i = options.length; i--;) {
                        select.removeChild(options[i]);
                    }
                    $("#designation").append($("<option></option>").val("").html("Select"));
                    $.ajax({
                        type: "POST", url: "CreateProfile.aspx/GetDesignation", dataType: "json", contentType: "application/json",
                        success: function (res) {
                            $.each(res.d, function (data, value) {
                                $("#designation").append($("<option></option>").val(value.DesignationID).html(value.DesignationName));
                            })
                            $("#designation").val(value.Designation);
                        }
                    });

                    //Reporting Manager Selection
                    select = document.getElementById("reportingmanager");
                    options = select.getElementsByTagName('option');

                    for (var i = options.length; i--;) {
                        select.removeChild(options[i]);
                    }
                    $("#reportingmanager").append($("<option></option>").val("").html("Select"));
                    $.ajax({
                        type: "POST", url: "CreateProfile.aspx/GetProjectManagers", dataType: "json", contentType: "application/json",
                        success: function (res) {
                            $.each(res.d, function (data, value) {
                                $("#reportingmanager").append($("<option></option>").val(value.ProjectManagerID).html(value.PmCodeName));
                            })
                            $("#reportingmanager").val(value.ProjectManager);
                        }
                    });

                    //Shift Selection
                    select = document.getElementById("shift");
                    options = select.getElementsByTagName('option');

                    for (var i = options.length; i--;) {
                        select.removeChild(options[i]);
                    }
                    $("#shift").append($("<option></option>").val("").html("Select"));
                    $.ajax({
                        type: "POST", url: "CreateProfile.aspx/GetShift", dataType: "json", contentType: "application/json",
                        success: function (res) {
                            $.each(res.d, function (data, value) {
                                $("#shift").append($("<option></option>").val(value.ShiftID).html(value.ShiftTime));
                            })
                            $("#shift").val(value.Shift);
                        }

                    });

                    document.getElementById("cutofftime").value = value.CutOffTime;
                    $("#workinghours").val(value.WorkingHours);

                    //Weekly Holiday Selection
                    select = document.getElementById("weeklyholiday");
                    options = select.getElementsByTagName('option');

                    for (var i = options.length; i--;) {
                        select.removeChild(options[i]);
                    }

                    $("#weeklyholiday").append($("<option></option>").val("").html("Select"));
                    $.ajax({
                        type: "POST", url: "CreateProfile.aspx/GetWeeklyHolidaysByShift", dataType: "json", contentType: "application/json",
                        data: "{Hours:" + value.WorkingHours + "}",
                        success: function (res) {
                            $.each(res.d, function (data, value) {
                                $("#weeklyholiday").append($("<option></option>").val(value.HolidayID).html(value.Holidays));
                            })
                            $("#weeklyholiday").val(value.WeeklyHoliday);
                        }
                    });

                    console.log('prj');
                    console.log(value.Project);

                    //Project # selection
                    select = document.getElementById("projects");
                    options = select.getElementsByTagName('option');

                    for (var i = options.length; i--;) {
                        select.removeChild(options[i]);
                    }
                    $("#projects").append($("<option></option>").val("").html("Select"));
                    $(document).ready(function () {
                        $.ajax({
                            type: "POST", url: "CreateProfile.aspx/GetProjects", dataType: "json", contentType: "application/json",
                            success: function (res) {
                                $.each(res.d, function (data, valueprj) {
                                    $("#projects").append($("<option></option>").val(valueprj.ProjectID).html(valueprj.ProjectName));
                                })
                                if (value.Project == '' || value.Project == 77) {
                                    console.log('In');
                                    $("#projects").val(501);
                                }
                                else if (Number(value.Project) >= 0)
                                    $("#projects").val(value.Project);
                                else
                                    $("#projects").val(334);
                            }
                        });
                    });


                    document.getElementById("process").value = value.Process;
                    $("#taskproductive").val(value.DailyTaskProductivity);

                    //Domain Selection
                    select = document.getElementById("domain");
                    options = select.getElementsByTagName('option');

                    for (var i = options.length; i--;) {
                        select.removeChild(options[i]);
                    }
                    $("#domain").append($("<option></option>").val("").html("Select"));
                    $.ajax({
                        type: "POST", url: "CreateProfile.aspx/GetAllDomains", dataType: "json", contentType: "application/json",
                        success: function (res) {
                            $.each(res.d, function (data, value) {
                                $("#domain").append($("<option></option>").val(value.DomainID).html(value.DomainName));
                            })
                            $("#domain").val(value.Domain);
                        }
                    });
                    //Subdomain selection
                    select = document.getElementById("subdomain");
                    options = select.getElementsByTagName('option');

                    for (var i = options.length; i--;) {
                        select.removeChild(options[i]);
                    }
                    $("#subdomain").append($("<option></option>").val("").html("Select"));
                    $.ajax({
                        type: "POST", url: "CreateProfile.aspx/GetSubdomains", dataType: "json", contentType: "application/json",
                        success: function (res) {
                            $.each(res.d, function (data, value) {
                                $("#subdomain").append($("<option></option>").val(value.SubdomainID).html(value.SubdomainName));
                            })
                            $("#subdomain option").filter(function () {
                                return this.text == value.SubDomain;
                            }).attr('selected', true);
                        }
                    });

                    document.getElementById("remark").value = value.EmployeeRemark;

                    // var appDate = eval(value.AppointmentDate.replace(/\/Date\((\d+)\)\//gi, "new Date($1).toLocaleDateString(\"en-US\")"));
                    // date = new Date(appDate);
                    // day = date.getDate();
                    // if (day < 10)
                    //     day = '0' + day
                    // month = date.getMonth() + 1;
                    // if (month < 10)
                    //     month = '0' + month
                    // year = date.getFullYear();
                    // actualdate = year + "-" + (month) + "-" + (day);
                    // $("#appointmentdate").val(actualdate);

                    if (value.AppointmentDate && value.AppointmentDate.trim() !== "") {

                        var appDate = eval(
                            value.AppointmentDate.replace(
                                /\/Date\((\d+)\)\//gi,
                                'new Date($1).toLocaleDateString("en-US")'
                            )
                        );

                        var date = new Date(appDate);
                        var day = date.getDate();
                        if (day < 10) day = '0' + day;

                        var month = date.getMonth() + 1;
                        if (month < 10) month = '0' + month;

                        var year = date.getFullYear();
                        var actualdate = year + "-" + month + "-" + day;

                        $("#appointmentdate").val(actualdate);
                    }
                    // else do nothing, keep the existing value

                    document.getElementById("uan").value = value.UAN;
                    document.getElementById("esicno").value = value.ESICNo;
                    document.getElementById("pfno").value = value.PFNo;
                    document.getElementById("officialemail").value = value.OfficialEmailID;

                    if (value.IsPolicy == "0") {
                        $("#policy").val("No");
                    }
                    else if (value.IsPolicy == "1") {
                        $("#policy").val("Yes");
                    }
                    else
                        $("#policy").val("");

                    $("#jobtype").val(value.JobType);

                    if (value.IsAgreement == "0") {
                        $("#chkagreement").attr("checked", false);
                        tragreement.style.display = 'none';
                    }
                    else if (value.IsAgreement == "1") {
                        $("#chkagreement").attr("checked", true);
                        tragreement.style.display = '';
                    }
                    else {
                        $("#chkagreement").attr("checked", false);
                        tragreement.style.display = 'none';
                    }

                    $("#agreementperiod").val(value.Period);
                    date = new Date(value.DateOfAgreement);
                    day = date.getDate();
                    if (day < 10)
                        day = '0' + day
                    month = date.getMonth() + 1;
                    if (month < 10)
                        month = '0' + month
                    year = date.getFullYear();
                    actualdate = year + "-" + (month) + "-" + (day);
                    $("#agreementdate").val(actualdate);

                    date = new Date(value.AgreementExpiraryDate);
                    day = date.getDate();
                    if (day < 10)
                        day = '0' + day
                    month = date.getMonth() + 1;
                    if (month < 10)
                        month = '0' + month
                    year = date.getFullYear();
                    actualdate = year + "-" + (month) + "-" + (day);
                    $("#agreementexpirydate").val(actualdate);

                    //Bank Selection
                    select = document.getElementById("bankname");
                    options = select.getElementsByTagName('option');

                    for (var i = options.length; i--;) {
                        select.removeChild(options[i]);
                    }
                    $("#bankname").append($("<option></option>").val("").html("Select"));
                    $.ajax({
                        type: "POST", url: "CreateProfile.aspx/GetBankNames", dataType: "json", contentType: "application/json",
                        success: function (res) {
                            $.each(res.d, function (data, value) {
                                $("#bankname").append($("<option></option>").val(value.BankName).html(value.BankName));
                            })
                            $("#bankname").val(value.BankName);
                            $("#accountno").val(value.BankAccNo);
                            $("#ifsccode").val(value.IFSCCode);
                            $("#reaccountno").val(value.BankAccNo);
                            $("#reifsccode").val(value.IFSCCode);


                        }
                    });

                    select = document.getElementById("requisition");
                    options = select.getElementsByTagName('option');

                    for (var i = options.length; i--;) {
                        select.removeChild(options[i]);
                    }
                    $("#requisition").append($("<option></option>").val("").html("Select"));


                    $.ajax({
                        type: "POST", url: "CreateProfile.aspx/GetAllRequisitions", dataType: "json", contentType: "application/json",
                        success: function (res) {

                            $.each(res.d, function (data, value) {
                                $("#requisition").append($("<option></option>").val(value.RecId).html(value.RequisitionProfile));
                            })
                            $("#requisition").append($("<option></option>").val("0").html("Other"));
                            //if (value.RequisitionID == "0")
                            //    $("#requisition").val("Other");
                            //else
                            $("#requisition").val(value.RequisitionID);
                        }
                    });
                });
            }
        });
        $("#load1").hide();
    }
}



/*--------------- bind applicant info ---------------*/

function BindInfoFromApplicationForm(AppID) {
    if (AppID != '') {
        $("#load1").show();
        $.ajax({
            type: "POST", url: "CreateProfile.aspx/GetApplicantDetails", dataType: "json", contentType: "application/json", data: "{AppId:'" + AppID + "'}",
            success: function (res) {
                var dataArray = JSON.parse(res.d);//
                $.each(dataArray, function (index, value) {
                    document.getElementById("firstname").value = value.FirstName;
                    document.getElementById("middlename").value = value.MiddleName;
                    document.getElementById("lastname").value = value.LastName;
                    document.getElementById("code").disabled = true;
                    $("#gender").val(value.Gender);
                    document.getElementById("presentaddress").value = value.PresentAddress;
                    document.getElementById("permanentaddress").value = value.PermanentAddress;
                    document.getElementById("email").value = value.EmailID;
                    document.getElementById("qualification").value = value.Qualification;
                    document.getElementById("cellno").value = value.CellPhoneNo;
                    document.getElementById("restelno").value = value.ResTelNo;
                    var date = new Date(value.JoiningDate);
                    var day = date.getDate();
                    if (day < 10)
                        day = '0' + day
                    var month = date.getMonth() + 1;
                    if (month < 10)
                        month = '0' + month
                    var year = date.getFullYear();
                    actualdate = year + "-" + (month) + "-" + (day);
                    $("#joiningdate").val(actualdate);
                    $("#bloodgroup").val(value.BloodGroup);
                    $("#title").val(value.Title);
                    document.getElementById("salary").value = value.FinalSalary;


                    //Department Selection
                    select = document.getElementById("department");
                    options = select.getElementsByTagName('option');

                    for (var i = options.length; i--;) {
                        select.removeChild(options[i]);
                    }
                    $.ajax({
                        type: "POST", url: "CreateProfile.aspx/GetDepartment", dataType: "json", contentType: "application/json",
                        success: function (res) {
                            $.each(res.d, function (data, value) {
                                $("#department").append($("<option></option>").val(value.DepartmentID).html(value.DepartmentName));
                            })
                            $("#department").val(value.DepartmentName);
                        }

                    });
                    //Designation Selection
                    select = document.getElementById("designation");
                    options = select.getElementsByTagName('option');

                    for (var i = options.length; i--;) {
                        select.removeChild(options[i]);
                    }
                    $("#designation").append($("<option></option>").val("").html("Select"));
                    $.ajax({
                        type: "POST", url: "CreateProfile.aspx/GetDesignation", dataType: "json", contentType: "application/json",
                        success: function (res) {
                            $.each(res.d, function (data, value) {
                                $("#designation").append($("<option></option>").val(value.DesignationID).html(value.DesignationName));
                            })
                            $("#designation").val(value.DesignationName);
                        }

                    });
                    //Reporting Manager Selection
                    select = document.getElementById("reportingmanager");
                    options = select.getElementsByTagName('option');

                    for (var i = options.length; i--;) {
                        select.removeChild(options[i]);
                    }
                    $("#reportingmanager").append($("<option></option>").val("").html("Select"));
                    $.ajax({
                        type: "POST", url: "CreateProfile.aspx/GetProjectManagers", dataType: "json", contentType: "application/json",
                        success: function (res) {
                            $.each(res.d, function (data, value) {
                                $("#reportingmanager").append($("<option></option>").val(value.ProjectManagerID).html(value.PmCodeName));
                            })
                            $("#reportingmanager").val(value.ReportingManagerName);
                        }

                    });

                    //Shift Selection
                    select = document.getElementById("shift");
                    options = select.getElementsByTagName('option');

                    for (var i = options.length; i--;) {
                        select.removeChild(options[i]);
                    }
                    $("#shift").append($("<option></option>").val("").html("Select"));
                    $.ajax({
                        type: "POST", url: "CreateProfile.aspx/GetShift", dataType: "json", contentType: "application/json",
                        success: function (res) {
                            $.each(res.d, function (data, value) {
                                $("#shift").append($("<option></option>").val(value.ShiftID).html(value.ShiftTime));
                            })
                            $("#shift").val(value.ShiftName);
                        }
                    });

                    document.getElementById("cutofftime").value = value.Cutofftime;

                    select = document.getElementById("requisition");
                    options = select.getElementsByTagName('option');

                    for (var i = options.length; i--;) {
                        select.removeChild(options[i]);
                    }
                    $("#requisition").append($("<option></option>").val("").html("Select"));
                    $.ajax({
                        type: "POST", url: "CreateProfile.aspx/GetAllRequisitions", dataType: "json", contentType: "application/json",
                        success: function (res) {
                            $.each(res.d, function (data, value) {
                                $("#requisition").append($("<option></option>").val(value.RecId).html(value.RequisitionProfile));
                            })
                            $("#requisition").append($("<option></option>").val("0").html("Other"));
                            if (value.RequisitionID == "0")
                                $("#requisition").val("");
                            else
                                $("#requisition").val(value.RequisitionID);
                        }
                    });

                    bindbranches();
                    bindweeklyholiday();
                    bindprojects();
                    binddomains();
                    bindsubdomains();
                    bindbanks();
                });
            }
        });
        $("#load1").hide();
    }
}


/*--------------- bind methods ---------------*/

function bindrequistions() {
    var select = document.getElementById("requisition");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#requisition").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "CreateProfile.aspx/GetAllRequisitions", dataType: "json", contentType: "application/json",
        success: function (res) {
            $.each(res.d, function (data, value) {
                $("#requisition").append($("<option></option>").val(value.RecId).html(value.RequisitionProfile));
            })
            $("#requisition").append($("<option></option>").val("0").html("Other"));
        }
    });
}

function bindbranches() {
    var select = document.getElementById("branch");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#branch").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "CreateProfile.aspx/GetBranches", dataType: "json", contentType: "application/json",
        success: function (res) {
            $.each(res.d, function (data, value) {
                $("#branch").append($("<option></option>").val(value.BranchID).html(value.BranchName));
            })
        }
    });
}

function bindprojectamanagers() {
    var select = document.getElementById("reportingmanager");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#reportingmanager").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "CreateProfile.aspx/GetProjectManagers", dataType: "json", contentType: "application/json",
        success: function (res) {
            $.each(res.d, function (data, value) {
                $("#reportingmanager").append($("<option></option>").val(value.ProjectManagerID).html(value.PmCodeName));
            })
        }

    });
}

function bindddepartment() {
    var select = document.getElementById("department");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#department").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "CreateProfile.aspx/GetDepartment", dataType: "json", contentType: "application/json",
        success: function (res) {
            $.each(res.d, function (data, value) {
                $("#department").append($("<option></option>").val(value.DepartmentID).html(value.DepartmentName));
            })
        }

    });
}

function binddshift() {
    var select = document.getElementById("shift");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#shift").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "CreateProfile.aspx/GetShift", dataType: "json", contentType: "application/json",
        success: function (res) {
            $.each(res.d, function (data, value) {
                $("#shift").append($("<option></option>").val(value.ShiftID).html(value.ShiftTime));
            })
        }

    });
}

function binddesignation() {
    var select = document.getElementById("designation");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#designation").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "CreateProfile.aspx/GetDesignation", dataType: "json", contentType: "application/json",
        success: function (res) {
            $.each(res.d, function (data, value) {
                $("#designation").append($("<option></option>").val(value.DesignationID).html(value.DesignationName));
            })
        }

    });

}

function bindweeklyholiday() {

    $.ajax({
        type: "POST", url: "CreateProfile.aspx/GetWeeklyHolidays", dataType: "json", contentType: "application/json",
        success: function (res) {
            $.each(res.d, function (data, value) {
                $("#weeklyholiday").append($("<option></option>").val(value.HolidayID).html(value.Holidays));
            })
        }

    });

}

function bindprojects() {
    var select = document.getElementById("projects");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#projects").append($("<option></option>").val("").html("Select"));
    $(document).ready(function () {
        $.ajax({
            type: "POST", url: "CreateProfile.aspx/GetProjects", dataType: "json", contentType: "application/json",
            success: function (res) {
                $.each(res.d, function (data, value) {
                    $("#projects").append($("<option></option>").val(value.ProjectID).html(value.ProjectName));
                })
            }
        });
    })
}

function binddomains() {
    var select = document.getElementById("domain");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#domain").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "CreateProfile.aspx/GetAllDomains", dataType: "json", contentType: "application/json",
        success: function (res) {
            $.each(res.d, function (data, value) {
                $("#domain").append($("<option></option>").val(value.DomainID).html(value.DomainName));
            })
        }
    });
}

function bindsubdomains() {
    var select = document.getElementById("subdomain");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#subdomain").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "CreateProfile.aspx/GetSubdomains", dataType: "json", contentType: "application/json",
        success: function (res) {
            $.each(res.d, function (data, value) {
                $("#subdomain").append($("<option></option>").val(value.SubdomainID).html(value.SubdomainName));
            })
        }
    });
}

function getagreementdetails() {
    var chkag = document.getElementById("chkagreement");
    if (chkag.checked)
        tragreement.style.display = '';
    else
        tragreement.style.display = 'none';
}

function bindbanks() {
    var select = document.getElementById("bankname");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#bankname").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "CreateProfile.aspx/GetBankNames", dataType: "json", contentType: "application/json",
        success: function (res) {
            $.each(res.d, function (data, value) {
                $("#bankname").append($("<option></option>").val(value.BankName).html(value.BankName));
            })
        }
    });
}

function GenerateEmpCode() {
    var firstname = document.getElementById("firstname").value;
    var middlename = document.getElementById("middlename").value;
    var lastname = document.getElementById("lastname").value;
    var emptype = document.getElementById("employeetype");
    var type = emptype.options[emptype.selectedIndex].text;
    if (type != "") {
        PageMethods.GenerateCode(firstname, middlename, lastname, type, OnSucceddEmpType, OnErrorType);
        return false;
    }
    else {
        alert("Unable to generate code, Please contact administrator.");
        return;
    }
}

function OnSucceddEmpType(result) {
    document.getElementById("code").disabled = false;
    document.getElementById("code").value = result;
    document.getElementById("code").disabled = true;
}

function OnErrorType() {
}

function getaddress(chkaddress) {
    if (chkaddress.checked)
        document.getElementById("permanentaddress").value = document.getElementById("presentaddress").value;
    else
        document.getElementById("permanentaddress").value = '';

}

function getcutoff(shift) {
    var shifttime = shift.options[shift.selectedIndex].value;
    PageMethods.getCutoffTime(shifttime, OnSucceddCutoff, OnErrorCutoff);
    return false;
}

function OnSucceddCutoff(result) {
    if (result == "") {
        document.getElementById("cutofftime").disabled = false;
        document.getElementById("cutofftime").value = '';
        return;
    }
    document.getElementById("cutofftime").disabled = false;
    document.getElementById("cutofftime").value = result;
    document.getElementById("cutofftime").disabled = true;
}

function OnErrorCutoff() {
}

function onworkinghoursclick() {
    var select = document.getElementById("weeklyholiday");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    var ddlworkinghours = document.getElementById('workinghours');
    var index = ddlworkinghours.selectedIndex;
    var workinghours = ddlworkinghours.options[index].value;
    $("#weeklyholiday").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "CreateProfile.aspx/GetWeeklyHolidaysByShift", dataType: "json", contentType: "application/json",
        data: "{Hours:" + workinghours + "}",
        success: function (res) {
            $.each(res.d, function (data, value) {
                $("#weeklyholiday").append($("<option></option>").val(value.HolidayID).html(value.Holidays));
            })
        }

    });
}

function crp_Message() {
    $('#crp_dverror').modal('hide');
    location.href = "ViewEmployee.aspx";
}

function sleep(milliseconds) {
    var start = new Date().getTime();
    for (var i = 0; i < 1e7; i++) {
        if ((new Date().getTime() - start) > milliseconds) {
            break;
        }
    }
}
