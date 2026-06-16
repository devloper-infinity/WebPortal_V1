/* Optimized CreateProfile.js */
// (function (window, document, $) {
// 'use strict';

var PAGE = 'CreateProfile.aspx/';
var SELECT_TEXT = 'Select';


function create_submitdata() {

    function val(id) {
        return document.getElementById(id).value;
    }

    function ddlVal(id) {
        var ddl = document.getElementById(id);
        return ddl.options[ddl.selectedIndex].value;
    }

    function ddlText(id) {
        var ddl = document.getElementById(id);
        return ddl.options[ddl.selectedIndex].text;
    }

    var requisition = ddlVal("requisition");
    var code = val("code");
    var title = ddlVal("title");

    var firstname = val("firstname");
    var middlename = val("middlename");
    var lastname = val("lastname");

    var employeetype = ddlVal("employeetype");
    var gender = ddlVal("gender");

    var pan = val("pan");
    var presentaddress = val("presentaddress");
    var permanentaddress = val("permanentaddress");
    var email = val("email");
    var qualification = val("qualification");
    var cellno = val("cellno");
    var restelno = val("restelno");
    var birthdate = val("birthdate");

    var bloodgroup = ddlVal("bloodgroup");

    var branch = ddlVal("branch");
    var branchname = ddlText("branch");

    var department = ddlVal("department");
    var departmentname = ddlText("department");

    var designation = ddlVal("designation");
    var designationname = ddlText("designation");

    var reportingmanager = ddlVal("reportingmanager");
    var reportingmanagername = ddlText("reportingmanager");

    var shift = ddlVal("shift");
    var shiftname = ddlText("shift");

    var cutofftime = val("cutofftime");
    var joiningdate = val("joiningdate");
    var salary = val("salary");

    var workinghours = ddlVal("workinghours");
    var workinghourstext = ddlText("workinghours");

    var weeklyholiday = ddlVal("weeklyholiday");
    var weeklyholidayname = ddlText("weeklyholiday");

    var projects = ddlVal("projects");
    var projectsname = ddlText("projects");

    if (projects == "") {
        projects = 0;
    }

    var process = val("process");
    var taskproductive = ddlVal("taskproductive");

    var domain = ddlVal("domain");
    var domainname = ddlText("domain");

    var subdomainvalue = ddlVal("subdomain");
    var subdomain = ddlText("subdomain");

    var employeeremark = val("remark");
    var appointmentdate = val("appointmentdate");
    var aadharNo = val("aadharno");
    var uan = val("uan");
    var esicno = val("esicno");
    var pfno = val("pfno");
    var officialemail = val("officialemail");

    var policy = ddlVal("policy");
    var e_jobtype = ddlVal("jobtype");

    var chkagreement = document.getElementById("chkagreement");

    var reaccountno = val("reaccountno");
    var reifsccode = val("reifsccode");

    var period = ddlVal("agreementperiod");
    if (period == "") {
        period = "0";
    }

    var agreementdate = "";
    var expirydate = "";

    if (chkagreement.checked == true) {
        agreementdate = val("agreementdate");
        expirydate = val("agreementexpirydate");
    }

    var bankname = ddlVal("bankname");
    var accountno = val("accountno");
    var ifsccode = val("ifsccode");

    if (!validateAgreementDetails()) {
        return;
    }

    var validations = [
        [requisition, "Please select requisition.", "requisition"],
        [title, "Please select title.", "title"],
        [employeetype, "Please select employee type.", "employeetype"],
        [gender, "Please select gender.", "gender"],
        [pan, "Please enter PAN.", "pan"],
        [presentaddress, "Please enter present address.", "presentaddress"],
        [permanentaddress, "Please enter permanent address.", "permanentaddress"],
        [email, "Please enter email address.", "email"],
        [qualification, "Please enter qualification.", "qualification"],
        [cellno, "Please enter mobile number.", "cellno"],
        [birthdate, "Please select birth date.", "birthdate"],
        [bloodgroup, "Please select blood group.", "bloodgroup"],
        [joiningdate, "Please select joining date.", "joiningdate"],
        [salary, "Please enter salary.", "salary"],
        [branch, "Please select branch.", "branch"],
        [department, "Please select department.", "department"],
        [designation, "Please select designation.", "designation"],
        [reportingmanager, "Please select reporting manager.", "reportingmanager"],
        [shift, "Please select shift.", "shift"],
        [cutofftime, "Please enter cutoff time.", "cutofftime"],
        [workinghours, "Please select working hours.", "workinghours"],
        [weeklyholiday, "Please select weekly holiday.", "weeklyholiday"],
        [taskproductive, "Please select task/productive.", "taskproductive"],
        [domain, "Please select domain.", "domain"],
        [subdomainvalue, "Please select subdomain.", "subdomain"],
        [appointmentdate, "Please select appointment date.", "appointmentdate"],
        [aadharNo, "Please enter Aadhar number.", "aadharno"],
        [e_jobtype, "Please select Job Type.", "jobtype"]
    ];

    for (var i = 0; i < validations.length; i++) {
        if (validations[i][0] == "") {
            return showError(validations[i][1], validations[i][2]);
        }
    }

    var btnSubmit = document.getElementById("btnSubmit");
    btnSubmit.disabled = true;

    if (btnSubmit.innerHTML == "Submit") {

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

            function () {
                Swal.fire({
                    icon: "success",
                    title: "Success",
                    text: "Profile has been created successfully.",
                    confirmButtonColor: "#28a745"
                }).then(function (result) {
                    if (result.isConfirmed) {
                        window.location.href = "ViewEmployee.aspx";
                    }
                });

                btnSubmit.disabled = false;
            },

            function () {
                Swal.fire({
                    icon: "error",
                    title: "Error",
                    text: "Oops! Technical error occurred while creating profile.",
                    confirmButtonColor: "#d33"
                });

                btnSubmit.disabled = false;
            }
        );

    } else if (btnSubmit.innerHTML == "Update") {

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

            function () {
                Swal.fire({
                    icon: "success",
                    title: "Updated",
                    text: "Employee information updated successfully.",
                    confirmButtonColor: "#28a745"
                }).then(function (result) {
                    if (result.isConfirmed) {
                        window.location.href = "ViewEmployee.aspx";
                    }
                });

                btnSubmit.disabled = false;
            },

            function () {
                Swal.fire({
                    icon: "error",
                    title: "Error",
                    text: "Oops! Technical error occurred while updating employee information.",
                    confirmButtonColor: "#d33"
                });

                btnSubmit.disabled = false;
            }
        );
    }

    return false;
}


/*--------------- bind existing user info ---------------*/
function BindExistingInfo(Code) {

    if (!Code) return;

    $("#load1").show();

    enabledisable_bankDetails("Code");

    $.ajax({
        type: "POST",
        url: "CreateProfile.aspx/GetEmployeeDetailsByCode",
        dataType: "json",
        contentType: "application/json",
        data: JSON.stringify({ Code: Code }),

        success: function (res) {

            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (_, value) {

                $("#code").val(value.Code).prop("disabled", true).css({ "background": "linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%)", "color": "#fff" });
                $("#firstname").val(value.FirstName);
                $("#middlename").val(value.MiddleName);
                $("#lastname").val(value.lastName);

                $("#employeetype").val(value.EmployeeType);
                $("#gender").val(value.Gender);
                $("#pan").val(value.PAN);

                $("#presentaddress").val(value.PresentAddress);
                $("#permanentaddress").val(value.PermenentAddress);

                $("#email").val(value.EmailID);
                $("#qualification").val(value.Qualification);
                $("#cellno").val(value.CellNo);
                $("#restelno").val(value.ResTelNo);
                $("#aadharno").val(value.AadharNo);

                $("#birthdate").val(formatDate(value.DateOfBirth));
                $("#joiningdate").val(formatDate(value.JoiningDate));

                $("#bloodgroup").val(value.BloodGroup);
                $("#title").val(value.Title);
                $("#salary").val(value.Salary);

                $("#cutofftime").val(value.CutOffTime);
                $("#workinghours").val(value.WorkingHours);

                $("#process").val(value.Process);
                $("#taskproductive").val(value.DailyTaskProductivity);
                $("#remark").val(value.EmployeeRemark);

                $("#appointmentdate").val(formatDate(value.AppointmentDate));

                $("#uan").val(value.UAN);
                $("#esicno").val(value.ESICNo);
                $("#pfno").val(value.PFNo);
                $("#officialemail").val(value.OfficialEmailID);

                $("#policy").val(value.IsPolicy == "1" ? "Yes" : value.IsPolicy == "0" ? "No" : "");

                $("#jobtype").val(value.JobType);

                $("#chkagreement").prop("checked", value.IsAgreement == "1");

                // document.getElementById("tragreement").style.display = value.IsAgreement == "1" ? "" : "none";
                document.getElementById("tragreement").classList.toggle("d-none", value.IsAgreement != "1");


                $("#agreementperiod").val(value.Period);
                $("#agreementdate").val(formatDate(value.DateOfAgreement));
                $("#agreementexpirydate").val(formatDate(value.AgreementExpiraryDate));

                bindbranchesSelected(value.WorkingBranch);
                binddepartmentSelected(value.Department);
                binddesignationSelected(value.Designation);
                bindmanagerSelected(value.ProjectManager);
                bindshiftSelected(value.Shift);
                binddomainSelected(value.Domain);

                bindrequisitionSelected(value.RequisitionID);
                bindprojectSelected(value.Project);
                bindweeklyholidaySelected(value.WorkingHours, value.WeeklyHoliday);

                bindsubdomainsSelected(value.SubDomain);

                bindbankSelected(value.BankName);

                $("#accountno").val(value.BankAccNo);
                $("#ifsccode").val(value.IFSCCode);
                $("#reaccountno").val(value.BankAccNo);
                $("#reifsccode").val(value.IFSCCode);


                setTimeout(function () {
                    $("#subdomain option").filter(function () {
                        return this.text == value.SubDomain;
                    }).prop("selected", true);
                }, 500);
            });
        },

        error: function () {

            Swal.fire({
                icon: "error",
                title: "Error",
                text: "Unable to load employee details.",
                confirmButtonColor: "#d33"
            });

        },

        complete: function () {
            $("#load1").hide();
        }
    });
}


/*--------------- bind applicant info ---------------*/
function BindInfoFromApplicationForm(AppID) {

    if (!AppID) return;

    $("#load1").show();

    enabledisable_bankDetails("AppID");

    $.ajax({
        type: "POST",
        url: "CreateProfile.aspx/GetApplicantDetails",
        dataType: "json",
        contentType: "application/json",
        data: JSON.stringify({ AppId: AppID }),

        success: function (res) {

            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (_, value) {

                $("#firstname").val(value.FirstName);
                $("#middlename").val(value.MiddleName);
                $("#lastname").val(value.LastName);

                $("#code").prop("disabled", true);

                $("#gender").val(value.Gender);

                $("#presentaddress").val(value.PresentAddress);
                $("#permanentaddress").val(value.PermanentAddress);

                $("#email").val(value.EmailID);
                $("#qualification").val(value.Qualification);

                $("#cellno").val(value.CellPhoneNo);
                $("#restelno").val(value.ResTelNo);

                $("#joiningdate").val(formatDate(value.JoiningDate));

                $("#bloodgroup").val(value.BloodGroup);
                $("#title").val(value.Title);
                $("#salary").val(value.FinalSalary);

                $("#cutofftime").val(value.Cutofftime);

                binddepartmentSelected(value.DepartmentName);
                binddesignationSelected(value.DesignationName);
                bindmanagerSelected(value.ReportingManagerName);
                bindshiftSelected(value.ShiftName);
                bindrequisitionSelected(value.RequisitionID == "0" ? "" : value.RequisitionID);
                bindbranches();
                bindweeklyholiday();
                bindprojects();
                binddomains();
                bindsubdomains();
                bindbanks();
            });
        },

        error: function () {

            Swal.fire({
                icon: "error",
                title: "Error",
                text: "Unable to load applicant information.",
                confirmButtonColor: "#d33"
            });

        },

        complete: function () {

            $("#load1").hide();
        }
    });
}


/*--------------- bind methods ---------------*/
function bindDropdown(id, url, valueField, textField, addOther, selectedValue, afterBind) {

    var $ddl = $("#" + id);

    $ddl.empty();
    $ddl.append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST",
        url: url,
        dataType: "json",
        contentType: "application/json",

        success: function (res) {

            $.each(res.d, function (_, item) {
                $ddl.append(
                    $("<option></option>")
                        .val(item[valueField])
                        .html(item[textField])
                );
            });

            if (addOther) {
                $ddl.append(
                    $("<option></option>").val("0").html("Other")
                );
            }

            if (selectedValue !== undefined && selectedValue !== null) {
                // $ddl.val(selectedValue);

                if ($ddl.find("option[value='" + selectedValue + "']").length > 0) {
                    $ddl.val(selectedValue);
                } else {
                    $ddl.prop("selectedIndex", 0); // Select "Select"
                }
            }

            if (typeof afterBind === "function") {
                afterBind();
            }
        },

        error: function () {
            Swal.fire({
                icon: "error",
                title: "Error",
                text: "Unable to load dropdown data.",
                confirmButtonColor: "#d33"
            });
        }
    });
}


/* user Info */
function bindbranchesSelected(value) {
    bindDropdown("branch", "CreateProfile.aspx/GetBranches", "BranchID", "BranchName", false, value);
}

function binddepartmentSelected(value) {
    bindDropdown("department", "CreateProfile.aspx/GetDepartment", "DepartmentID", "DepartmentName", false, value);
}

function binddesignationSelected(value) {
    bindDropdown("designation", "CreateProfile.aspx/GetDesignation", "DesignationID", "DesignationName", false, value);
}

function bindmanagerSelected(value) {
    bindDropdown("reportingmanager", "CreateProfile.aspx/GetProjectManagers", "ProjectManagerID", "PmCodeName", false, value);
}

function bindshiftSelected(value) {
    bindDropdown("shift", "CreateProfile.aspx/GetShift", "ShiftID", "ShiftTime", false, value);
}

function binddomainSelected(value) {
    bindDropdown("domain", "CreateProfile.aspx/GetAllDomains", "DomainID", "DomainName", false, value);
}

function bindsubdomainsSelected(value) {

    bindDropdown("subdomain", "CreateProfile.aspx/GetSubdomains", "SubdomainName", "SubdomainName", false, value);
}

function bindbankSelected(value) {
    bindDropdown("bankname", "CreateProfile.aspx/GetBankNames", "BankName", "BankName", false, value);
}

function bindrequisitionSelected(value) {
    bindDropdown("requisition", "CreateProfile.aspx/GetAllRequisitions", "RecId", "RequisitionProfile", true, value);
}

function bindprojectSelected(projectValue) {

    var selectedProject = projectValue;

    if (projectValue == "" || projectValue == 77) {
        selectedProject = 501;
    } else if (Number(projectValue) >= 0) {
        selectedProject = projectValue;
    } else {
        selectedProject = 334;
    }

    bindDropdown("projects", "CreateProfile.aspx/GetProjects", "ProjectID", "ProjectName", false, selectedProject);
}

function bindweeklyholidaySelected(workingHours, selectedHoliday) {

    var $weeklyholiday = $("#weeklyholiday");

    $weeklyholiday.empty();
    $weeklyholiday.append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST",
        url: "CreateProfile.aspx/GetWeeklyHolidaysByShift",
        dataType: "json",
        contentType: "application/json",
        data: JSON.stringify({ Hours: workingHours }),

        success: function (res) {

            $.each(res.d, function (_, item) {
                $weeklyholiday.append(
                    $("<option></option>")
                        .val(item.HolidayID)
                        .html(item.Holidays)
                );
            });

            $weeklyholiday.val(selectedHoliday);
        }
    });
}


/* applicant Info */

function app_bindDropdown(id, url, valueField, textField, addOther) {

    var $ddl = $("#" + id);

    $ddl.empty();
    $ddl.append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST",
        url: url,
        dataType: "json",
        contentType: "application/json",

        success: function (res) {

            $.each(res.d, function (_, item) {

                $ddl.append($("<option></option>").val(item[valueField]).html(item[textField]));

            });

            if (addOther) {
                $ddl.append($("<option></option>").val("0").html("Other"));
            }
        },

        error: function () {

            Swal.fire({
                icon: "error",
                title: "Error",
                text: "Unable to load dropdown data.",
                confirmButtonColor: "#d33"
            });

        }
    });
}

function bindbranches() {

    app_bindDropdown(
        "branch",
        "CreateProfile.aspx/GetBranches",
        "BranchID",
        "BranchName"
    );
}

function bindprojectamanagers() {

    app_bindDropdown(
        "reportingmanager",
        "CreateProfile.aspx/GetProjectManagers",
        "ProjectManagerID",
        "PmCodeName"
    );
}

function bindddepartment() {

    app_bindDropdown(
        "department",
        "CreateProfile.aspx/GetDepartment",
        "DepartmentID",
        "DepartmentName"
    );
}

function binddshift() {

    app_bindDropdown(
        "shift",
        "CreateProfile.aspx/GetShift",
        "ShiftID",
        "ShiftTime"
    );
}

function binddesignation() {

    app_bindDropdown(
        "designation",
        "CreateProfile.aspx/GetDesignation",
        "DesignationID",
        "DesignationName"
    );
}

function bindprojects() {

    app_bindDropdown(
        "projects",
        "CreateProfile.aspx/GetProjects",
        "ProjectID",
        "ProjectName"
    );
}

function binddomains() {

    app_bindDropdown(
        "domain",
        "CreateProfile.aspx/GetAllDomains",
        "DomainID",
        "DomainName"
    );
}

function bindsubdomains() {

    app_bindDropdown(
        "subdomain",
        "CreateProfile.aspx/GetSubdomains",
        "SubdomainName",
        "SubdomainName"
    );
}

function bindbanks() {

    app_bindDropdown(
        "bankname",
        "CreateProfile.aspx/GetBankNames",
        "BankName",
        "BankName"
    );
}

function bindweeklyholiday() {


    app_bindDropdown(
        "weeklyholiday",
        "CreateProfile.aspx/GetWeeklyHolidays",
        "HolidayID",
        "Holidays"
    );
}



/*--------------- Supportive methods ---------------*/

function GenerateEmpCode() {

    var firstname = $("#firstname").val();
    var middlename = $("#middlename").val();
    var lastname = $("#lastname").val();

    var type = $("#employeetype option:selected").text();

    if (!type || type === "Select") {
        Swal.fire({
            icon: "warning",
            title: "Validation Message",
            text: "Please select Employee Type.",
            confirmButtonColor: "#3085d6"
        });
        return false;
    }

    Swal.fire({
        title: "Please wait...",
        text: "The system is generating the user code.",
        allowOutsideClick: false,
        allowEscapeKey: false,
        didOpen: function () {
            Swal.showLoading();
        }
    });

    PageMethods.GenerateCode((firstname || '').replace(/\s+/g, ''), (middlename || '').replace(/\s+/g, ''), (lastname || '').replace(/\s+/g, ''), type,

        function (result) {
            Swal.close();

            var txtCode = document.getElementById("code");
            txtCode.disabled = false;
            txtCode.value = result;
            txtCode.disabled = true;

            $("#code")
                .css({
                    "background": "linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%)",
                    "color": "#fff"
                    // "border": "2px solid blue"
                })
                .fadeOut(300)
                .fadeIn(300)
                .fadeOut(300)
                .fadeIn(300);
        },

        function () {
            Swal.close();

            Swal.fire({
                icon: "error",
                title: "Error",
                text: "Unable to generate employee code.",
                confirmButtonColor: "#d33"
            });
        }
    );

    return false;
}

function getaddress(chkaddress) {

    document.getElementById("permanentaddress").value =
        chkaddress.checked
            ? document.getElementById("presentaddress").value
            : "";
}

function getcutoff(shift) {

    var shifttime = shift.value;

    PageMethods.getCutoffTime(

        shifttime,

        function (result) {

            var txtCutoff = document.getElementById("cutofftime");

            txtCutoff.disabled = false;
            txtCutoff.value = result || "";
            txtCutoff.disabled = result ? true : false;

        },

        function () {

            Swal.fire({
                icon: "error",
                title: "Error",
                text: "Unable to fetch cutoff time.",
                confirmButtonColor: "#d33"
            });

        }
    );

    return false;
}

function onworkinghoursclick() {

    var workinghours = document.getElementById("workinghours").value;
    var $weeklyholiday = $("#weeklyholiday");

    $weeklyholiday.empty();
    $weeklyholiday.append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST",
        url: "CreateProfile.aspx/GetWeeklyHolidaysByShift",
        dataType: "json",
        contentType: "application/json",
        data: JSON.stringify({ Hours: workinghours }),

        success: function (res) {

            $.each(res.d, function (_, item) {

                $weeklyholiday.append(
                    $("<option></option>")
                        .val(item.HolidayID)
                        .html(item.Holidays)
                );

            });
        },

        error: function () {

            Swal.fire({
                icon: "error",
                title: "Error",
                text: "Unable to load weekly holidays.",
                confirmButtonColor: "#d33"
            });

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

function formatDate(dateValue) {

    if (!dateValue) return "";

    var match = /\/Date\((\d+)\)\//.exec(dateValue);
    var date = match ? new Date(parseInt(match[1])) : new Date(dateValue);

    if (isNaN(date.getTime())) return "";

    var month = String(date.getMonth() + 1);
    var day = String(date.getDate());

    if (month.length < 2) month = "0" + month;
    if (day.length < 2) day = "0" + day;

    return date.getFullYear() + "-" + month + "-" + day;
}

// function formatDate(dateValue) {

//     if (!dateValue) return "";

//     var date = new Date(dateValue);

//     if (isNaN(date.getTime())) return "";

//     var month = String(date.getMonth() + 1);
//     var day = String(date.getDate());

//     if (month.length < 2) month = "0" + month;
//     if (day.length < 2) day = "0" + day;

//     return date.getFullYear() + "-" + month + "-" + day;
// }

function getagreementdetails() {

    var isAgreement = $("#chkagreement").is(":checked");

    $("#tragreement").toggleClass("d-none", !isAgreement);

    if (!isAgreement) {

        $("#agreementperiod").val("");
        $("#agreementdate").val("");
        $("#agreementexpirydate").val("");
        return;
    }

    setAgreementExpiryDate();
}

function setAgreementExpiryDate() {

    var agreementDate = $("#agreementdate").val();
    var agreementPeriod = $("#agreementperiod").val();

    if (agreementDate === "" || agreementPeriod === "") {
        $("#agreementexpirydate").val("");
        return;
    }

    var expiryDate = new Date(agreementDate);

    expiryDate.setFullYear(expiryDate.getFullYear() + parseInt(agreementPeriod));

    var year = expiryDate.getFullYear();
    var month = String(expiryDate.getMonth() + 1).padStart(2, '0');
    var day = String(expiryDate.getDate()).padStart(2, '0');

    $("#agreementexpirydate").val(year + "-" + month + "-" + day);
}

function validateAgreementDetails() {

    if ($("#chkagreement").is(":checked")) {

        if ($("#agreementperiod").val() === "") {
            Swal.fire("Validation", "Please select agreement period.", "warning");
            return false;
        }

        if ($("#agreementdate").val() === "") {
            Swal.fire("Validation", "Please select agreement date.", "warning");
            return false;
        }
    }

    return true;
}

function showSalaryInWords() {

    var salary = $("#salary").val();

    if (!salary || salary <= 0)
        return;

    Swal.fire({
        icon: "info",
        title: "Salary Entered",
        html: "<b>₹ " + salary + "</b><br><br>" +
            numberToWords(parseInt(salary)) + " Only"
    });
}

function numberToWords(num) {

    var a = ['', 'One ', 'Two ', 'Three ', 'Four ', 'Five ', 'Six ',
        'Seven ', 'Eight ', 'Nine ', 'Ten ', 'Eleven ', 'Twelve ',
        'Thirteen ', 'Fourteen ', 'Fifteen ', 'Sixteen ', 'Seventeen ',
        'Eighteen ', 'Nineteen '];

    var b = ['', '', 'Twenty', 'Thirty', 'Forty', 'Fifty',
        'Sixty', 'Seventy', 'Eighty', 'Ninety'];

    if ((num = num.toString()).length > 9)
        return 'Overflow';

    var n = ('000000000' + num)
        .substr(-9)
        .match(/(\d{2})(\d{2})(\d{2})(\d{1})(\d{2})/);

    if (!n) return;

    var str = '';

    str += (n[1] != 0)
        ? (a[Number(n[1])] || b[n[1][0]] + ' ' + a[n[1][1]]) + 'Crore, '
        : '';

    str += (n[2] != 0)
        ? (a[Number(n[2])] || b[n[2][0]] + ' ' + a[n[2][1]]) + 'Lakh, '
        : '';

    str += (n[3] != 0)
        ? (a[Number(n[3])] || b[n[3][0]] + ' ' + a[n[3][1]]) + 'Thousand ,'
        : '';

    str += (n[4] != 0)
        ? (a[Number(n[4])] || b[n[4][0]] + ' ' + a[n[4][1]]) + 'Hundred, '
        : '';

    str += (n[5] != 0)
        ? ((str != '') ? 'and ' : '') +
        (a[Number(n[5])] || b[n[5][0]] + ' ' + a[n[5][1]])
        : '';

    return str.trim();
}

function validateAppointmentDate() {

    var joiningDate = $("#joiningdate").val();
    var appointmentDate = $("#appointmentdate").val();

    if (!joiningDate || !appointmentDate)
        return;

    var joining = new Date(joiningDate);
    var appointment = new Date(appointmentDate);

    // if (appointment < joining) {

    //     Swal.fire({
    //         icon: 'warning',
    //         title: 'Invalid Date',
    //         text: 'Appointment Date must be same as or greater than Joining Date.'
    //     });

    //     $("#appointmentdate").val("");
    //     $("#appointmentdate").focus();
    // }
}

function enabledisable_bankDetails(type) {

    if (type === "AppID") {
        $("#bankname").prop("disabled", false);
        $("#accountno").prop("readonly", false);
        $("#reaccountno").prop("readonly", false);
        $("#ifsccode").prop("readonly", false);
        $("#reifsccode").prop("readonly", false);
        $("#accountattachment").prop("disabled", false);
    }
    else {
        $("#bankname").prop("disabled", true);
        $("#accountno").prop("readonly", true);
        $("#reaccountno").prop("readonly", true);
        $("#ifsccode").prop("readonly", true);
        $("#reifsccode").prop("readonly", true);
        $("#accountattachment").prop("disabled", true);
    }
}









