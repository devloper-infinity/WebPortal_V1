<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ApplicationForm.aspx.cs" Inherits="WebPortal.Admin.ApplicationForm" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        @keyframes animate {
            0% {
                opacity: 0;
            }

            50% {
                opacity: 0.7;
            }

            100% {
                opacity: 0;
            }
        }
    </style>
    <style>
        .loading {
            display: none;
            position: fixed;
            top: 350px;
            left: 50%;
            margin-top: -96px;
            margin-left: -96px;
            /*  background-color: #ccc;*/
            opacity: .85;
            border-radius: 25px;
            width: 192px;
            height: 192px;
            z-index: 99999;
        }

        .dataTables_length, .dataTables_info {
            float: left !important;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: normal !important;
            border: none !important;
        }


        div.dt-buttons {
            position: static;
            padding-left: 50px;
            float: left;
        }

        .table.dataTable th {
            background: linear-gradient(to bottom, darkcyan, 20%, #ffffff);
            /*color:white;*/
        }

        .table.dataTable tr td {
            background: none;
        }
        /*.form-control {
            font-size: 11px !important;
        }*/
    </style>
    <script type="text/javascript">
        window.onload = function () {
            document.getElementById('attachment').addEventListener('change', getFileName);
        }
        const getFileName = (event) => {
            const files = event.target.files;
            var file = files[0];
            document.getElementById("filep").value = files[0].name;

            const fd = new FormData();

            // add all selected files
            fd.append(event.target.name, file, file.name);
            // create the request
            const xhr = new XMLHttpRequest();

            xhr.onload = () => {
                if (xhr.status >= 200 && xhr.status < 300) {
                    // we done!
                }
            };
            var url = window.location.href;
            // path to server would be where you'd normally post the form to
            xhr.open('POST', url, true);
            xhr.send(fd);
            document.getElementById("dropzone").classList.add("dz-max-files-reached");
            document.getElementById("conentdiv").style.display = '';
            document.getElementById("filesdiv").innerHTML = file.name;
        }

        $(document).ready(function () {
            $("#load1").show();
            const urlParams = new URLSearchParams(window.location.search);
            const AppId = urlParams.get('AppId');
            if (AppId == '' || AppId == null) {
                BindOthers();
            }
            else {
                $.ajax({

                    url: "ApplicationForm.aspx/GetApplicantDetails",
                    type: "POST",
                    dataType: "json",
                    data: "{AppId:" + AppId + "}",
                    contentType: "application/json; charset=utf-8",
                    success: function (data) {
                        var dataArray = JSON.parse(data.d);//
                        $.each(dataArray, function (index, value) {
                            $("#title").val(value.Title);
                            document.getElementById("firstname").value = value.FirstName;
                            document.getElementById("lastname").value = value.LastName;
                            document.getElementById("middlename").value = value.MiddleName;
                            var select = document.getElementById("profile");
                            var options = select.getElementsByTagName('option');

                            for (var i = options.length; i--;) {
                                select.removeChild(options[i]);
                            }

                            $("#profile").append($("<option></option>").val("").html("Select"));

                            $.ajax({
                                type: "POST", url: "ApplicationForm.aspx/GetRequisitionProfiles", dataType: "json", contentType: "application/json",
                                success: function (res) {
                                    $.each(res.d, function (data, value) {
                                        $("#profile").append($("<option></option>").val(value.ProfileId).html(value.Profile));
                                    })
                                    $("#profile").val(value.PositionApplied);
                                }

                            });

                            select = document.getElementById("domain");
                            options = select.getElementsByTagName('option');

                            for (var i = options.length; i--;) {
                                select.removeChild(options[i]);
                            }

                            $("#domain").append($("<option></option>").val("").html("Select"));

                            $.ajax({
                                type: "POST", url: "ApplicationForm.aspx/GetAllDomainGroups", dataType: "json", contentType: "application/json",
                                success: function (res) {
                                    $.each(res.d, function (data, value) {
                                        $("#domain").append($("<option></option>").val(value.DomainID).html(value.DomainName));
                                    })
                                    $("#domain").val(value.Domain);
                                }

                            });
                            $("#location").val(value.Location);
                            $("#source").val(value.Source);

                            //Bind Source Options
                            var sourcetype = value.Source;
                            if (sourcetype == "RecruitmentAgency" || sourcetype == "Recruitment Agency") {
                                sourcelabel.style.display = '';
                                sourcedetails.style.display = '';
                                sourcelabel.innerHTML = '<b>Agency Name:</b>';
                                document.getElementById("reference").style.display = '';
                                document.getElementById("portal").style.display = 'none';
                            }
                            else if (sourcetype == "Reference") {
                                sourcelabel.style.display = '';
                                sourcedetails.style.display = '';
                                sourcelabel.innerHTML = '<b>Reference:</b>';
                                document.getElementById("reference").style.display = '';
                                document.getElementById("portal").style.display = 'none';
                            }
                            else if (sourcetype == "OnlinePortal" || sourcetype == "Online Portal") {
                                sourcelabel.style.display = '';
                                sourcedetails.style.display = '';
                                sourcelabel.innerHTML = '<b>Portal:</b>';
                                document.getElementById("reference").style.display = 'none';
                                document.getElementById("portal").style.display = '';
                            }
                            else {
                                sourcelabel.style.display = 'none';
                                sourcedetails.style.display = 'none';
                                sourcelabel.innerHTML = '';
                                document.getElementById("reference").style.display = 'none';
                                document.getElementById("portal").style.display = 'none';
                            }

                            select = document.getElementById("subdomain");
                            options = select.getElementsByTagName('option');

                            for (var i = options.length; i--;) {
                                select.removeChild(options[i]);
                            }


                            $("#subdomain").append($("<option></option>").val("").html("Select"));
                            $.ajax({
                                type: "POST", url: "ApplicationForm.aspx/GetSubdomains", dataType: "json", contentType: "application/json",
                                /*data: "{DomainGroupId:" + value.Domain + "}",*/
                                success: function (res) {
                                    $.each(res.d, function (data, value) {
                                        $("#subdomain").append($("<option></option>").val(value.SubdomainID).html(value.SubdomainName));
                                    })
                                    $("#subdomain").val(value.SubDomain);
                                }

                            });

                            $("#gender").val(value.Gender);
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
                            document.getElementById("email").value = value.EmailID;
                            document.getElementById("contact").value = value.CellPhoneNo;
                            document.getElementById("presentaddress").value = value.PresentAddress;
                            document.getElementById("presentpincode").value = value.PreAddPinCode;
                            document.getElementById("permanentaddress").value = value.PermanentAddress;
                            document.getElementById("permanentpincode").value = value.PermenentAddPinCode;
                            document.getElementById("remark").value = value.Remark;





                        });
                    },
                    error: function (error) {
                        alert('error; ' + eval(error));
                        alert('error; ' + error.responseText);
                    }
                });
            }
            $("#load1").hide();

        });

        function BindOthers() {
            var select = document.getElementById("profile");
            var options = select.getElementsByTagName('option');

            for (var i = options.length; i--;) {
                select.removeChild(options[i]);
            }

            $("#profile").append($("<option></option>").val("").html("Select"));

            $.ajax({
                type: "POST", url: "ApplicationForm.aspx/GetRequisitionProfiles", dataType: "json", contentType: "application/json",
                success: function (res) {
                    $.each(res.d, function (data, value) {
                        $("#profile").append($("<option></option>").val(value.ProfileId).html(value.Profile));
                    })
                }

            });

            select = document.getElementById("domain");
            options = select.getElementsByTagName('option');

            for (var i = options.length; i--;) {
                select.removeChild(options[i]);
            }

            $("#domain").append($("<option></option>").val("").html("Select"));

            $.ajax({
                type: "POST", url: "ApplicationForm.aspx/GetAllDomainGroups", dataType: "json", contentType: "application/json",
                success: function (res) {
                    $.each(res.d, function (data, value) {
                        $("#domain").append($("<option></option>").val(value.DomainID).html(value.DomainName));
                    })
                }

            });

        }


        function ondomainclick() {
            var select = document.getElementById("subdomain");
            let options = select.getElementsByTagName('option');

            for (var i = options.length; i--;) {
                select.removeChild(options[i]);
            }

            var ddlDomain = document.getElementById('domain');
            var index = ddlDomain.selectedIndex;
            var DomainGroupId = ddlDomain.options[index].value;
            $("#subdomain").append($("<option></option>").val("").html("Select"));
            $.ajax({
                type: "POST", url: "ApplicationForm.aspx/GetSubdomains", dataType: "json", contentType: "application/json",
                /*data: "{DomainGroupId:" + DomainGroupId + "}",*/
                success: function (res) {
                    $.each(res.d, function (data, value) {
                        $("#subdomain").append($("<option></option>").val(value.SubdomainID).html(value.SubdomainName));
                    })
                }

            });
        }





    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="filep" style="display: none;" />
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Application Form</b></h6>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right" style="font-size: 12px; font-weight: bold;">
                        <li class="breadcrumb-item"><a href="#utl" id="aBack" runat="server" style="color: saddlebrown" onclick="window.history.go(-1); return false;"><< Go back </a></li>

                    </ol>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <h5 class="card-title"></h5>
                <table class="table">
                    <tr>
                        <td><b>Name:</b></td>
                        <td colspan="3">
                            <select id="title" name="title" class="form-control" style="width: 100px; display: inline;">
                                <option value="Select">Select</option>
                                <option value="Mr.">Mr.</option>
                                <option value="Ms.">Ms.</option>
                            </select>
                            &nbsp;
                    <input id="lastname" name="lastname" class="form-control" style="width: 200px; display: inline;" placeholder="Last Name" />
                            &nbsp;
                    <input id="firstname" name="firstname" class="form-control" style="width: 200px; display: inline;" placeholder="First Name" />
                            &nbsp;
                    <input id="middlename" name="middlename" class="form-control" style="width: 200px; display: inline;" placeholder="Middle Name" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Profile:</b></td>
                        <td>
                            <select id="profile" name="profile" class="form-control" style="width: 300px;" required>
                                <option value="Select">Select</option>
                            </select>
                        </td>
                        <td><b>Location:</b></td>
                        <td>
                            <select id="location" name="location" class="form-control" style="width: 300px;" required>
                                <option value="Select">Select</option>
                                <option value="Akola">Akola</option>
                                <option value="Bangalore">Bangalore</option>
                                <option value="Pune-Kothrud">Pune-Kothrud</option>
                                <option value="Pune-KP">Pune-KP</option>
                                <option value="Pune-Swargate">Pune-Swargate</option>
                                <option value="Solapur">Solapur</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Source:</b></td>
                        <td>
                            <select id="source" name="source" class="form-control" style="width: 300px;" required onchange="getOptions(this);">
                                <option value="Select">Select</option>
                                <option value="Advertisement">Advertisement</option>
                                <option value="OnlinePortal">Online Portal</option>
                                <option value="Other">Other</option>
                                <option value="Reference">Reference</option>
                            </select>
                        </td>
                        <td id="sourcelabel" style="display: none;"><b></b></td>
                        <td id="sourcedetails" style="display: none;">
                            <input type="text" id="reference" name="reference" class="form-control" style="width: 300px; display: none;" />
                            <select id="portal" name="portal" class="form-control" style="width: 300px;">
                                <option value="Select">Select</option>
                                <option value="LinkedIn">LinkedIn</option>
                                <option value="Naukri">Naukri</option>
                                <option value="Other">Other</option>
                            </select>


                            <script type="text/javascript">
                                function getOptions(source) {
                                    var sourcetype = source.options[source.selectedIndex].text;
                                    if (sourcetype == "Recruitment Agency") {
                                        sourcelabel.style.display = '';
                                        sourcedetails.style.display = '';
                                        sourcelabel.innerHTML = '<b>Agency Name:</b>';
                                        document.getElementById("reference").style.display = '';
                                        document.getElementById("portal").style.display = 'none';
                                    }
                                    else if (sourcetype == "Reference") {
                                        sourcelabel.style.display = '';
                                        sourcedetails.style.display = '';
                                        sourcelabel.innerHTML = '<b>Reference:</b>';
                                        document.getElementById("reference").style.display = '';
                                        document.getElementById("portal").style.display = 'none';
                                    }
                                    else if (sourcetype == "Online Portal") {
                                        sourcelabel.style.display = '';
                                        sourcedetails.style.display = '';
                                        sourcelabel.innerHTML = '<b>Portal:</b>';
                                        document.getElementById("reference").style.display = 'none';
                                        document.getElementById("portal").style.display = '';
                                    }
                                    else {
                                        sourcelabel.style.display = 'none';
                                        sourcedetails.style.display = 'none';
                                        sourcelabel.innerHTML = '';
                                        document.getElementById("reference").style.display = 'none';
                                        document.getElementById("portal").style.display = 'none';
                                    }
                                }
                            </script>
                        </td>
                    </tr>

                    <tr>
                        <td><b>Domain:</b></td>
                        <td>
                            <select id="domain" name="domain" class="form-control" style="width: 300px;" required onchange="ondomainclick();">
                                <option value="Select">Select</option>
                            </select>
                        </td>

                        <td><b>Subdomain:</b></td>
                        <td>
                            <select id="subdomain" name="subdomain" class="form-control" style="width: 300px;" required>
                                <option value="Select">Select</option>
                            </select></td>
                    </tr>
                    <tr>
                        <td><b>Gender:</b></td>
                        <td>
                            <select id="gender" name="gender" class="form-control" style="width: 300px;" required>
                                <option value="Select">Select</option>
                                <option value="Female">Female</option>
                                <option value="Male">Male</option>
                            </select>
                        </td>

                        <td><b>Birth Date:</b></td>
                        <td>
                            <input type="date" id="birthdate" name="birthdate" class="form-control" style="width: 300px;" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Email Address:</b></td>
                        <td>
                            <input type="text" id="email" name="email" class="form-control" style="width: 300px;" />
                        </td>

                        <td><b>Contact #:</b></td>
                        <td>
                            <input type="text" id="contact" name="contact" class="form-control" style="width: 300px;" />
                        </td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td><b>Present Address:</b></td>
                        <td>
                            <textarea id="presentaddress" name="presentaddress" class="form-control" style="width: 300px;"></textarea>
                        </td>
                        <td style="vertical-align: middle;"><b>Pincode:</b></td>
                        <td style="vertical-align: middle;">
                            <input type="number" id="presentpincode" name="presentpincode" class="form-control" style="width: 300px;" /></td>
                    </tr>
                    <tr>
                        <td style="text-align: right!important;">
                            <input type="checkbox" id="chkpresentaddress" name="chkpresentaddress" class="form-check" style="display: inline;" onchange="getaddress(this);" />

                            <script type="text/javascript">
                                function getaddress(check) {

                                    if (check.checked) {
                                        document.getElementById("permanentaddress").value = document.getElementById("presentaddress").value;
                                        document.getElementById("permanentpincode").value = document.getElementById("presentpincode").value;
                                    }
                                    else {
                                        document.getElementById("permanentaddress").value = "";
                                        document.getElementById("permanentpincode").value = "";
                                    }
                                }
                            </script>
                        </td>
                        <td colspan="3" style="vertical-align: middle;">
                            <label><b>Is Permanent Address same as Present Address?</b></label>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Permanent Address:</b></td>
                        <td>
                            <textarea id="permanentaddress" name="permanentaddress" class="form-control" style="width: 300px;"></textarea>
                        </td>
                        <td style="vertical-align: middle;"><b>Pincode:</b></td>
                        <td style="vertical-align: middle;">
                            <input type="number" id="permanentpincode" name="permanentpincode" class="form-control" style="width: 300px;" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Remark:</b></td>
                        <td>
                            <textarea id="remark" name="remark" class="form-control" style="width: 300px;"></textarea>
                        </td>
                        <td style="vertical-align: middle;"><b>Upload Resume:</b></td>
                        <td style="vertical-align: middle;">
                            <input type="file" id="attachment" name="attachment" class="form-control" style="width: 300px;" />
                            <div class="dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete" id="dropzone">
                                <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column" id="conentdiv" style="display: none!important;">

                                    <div class="flex-1 d-flex flex-between-center">
                                        <div id="filesdiv" style="margin-top: 10px; margin-bottom: 10px;"></div>
                                        <div class="dropdown font-sans-serif">
                                            <button class="btn btn-link text-600 btn-sm dropdown-toggle btn-reveal dropdown-caret-none" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                <svg class="svg-inline--fa fa-ellipsis" style="display: none!important" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="ellipsis" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg="">
                                                    <path fill="currentColor" d="M120 256C120 286.9 94.93 312 64 312C33.07 312 8 286.9 8 256C8 225.1 33.07 200 64 200C94.93 200 120 225.1 120 256zM280 256C280 286.9 254.9 312 224 312C193.1 312 168 286.9 168 256C168 225.1 193.1 200 224 200C254.9 200 280 225.1 280 256zM328 256C328 225.1 353.1 200 384 200C414.9 200 440 225.1 440 256C440 286.9 414.9 312 384 312C353.1 312 328 286.9 328 256z"></path></svg><!-- <span class="fas fa-ellipsis-h"></span> Font Awesome fontawesome.com --></button>
                                            <div class="dropdown-menu dropdown-menu-end border py-2"><a class="dropdown-item" href="#!" data-dz-remove="data-dz-remove">Remove File</a></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4" style="text-align: center;">
                            <button id="btnSubmit" type="button" onclick="submitdata();" class="btn btn-primary">Submit</button>

                            <script type="text/javascript">
                                function submitdata() {

                                    var ddlprofile = document.getElementById("profile");
                                    var profile = ddlprofile.options[ddlprofile.selectedIndex].value;
                                    var ddllocation = document.getElementById("location");
                                    var location = ddllocation.options[ddllocation.selectedIndex].value;
                                    var ddlsource = document.getElementById("source");
                                    var source = ddlsource.options[ddlsource.selectedIndex].text;
                                    var ddlportal = document.getElementById("portal");
                                    var portal = ddlportal.options[ddlportal.selectedIndex].text;
                                    var reference = document.getElementById("reference").value;
                                    var sourceparam = '';
                                    if (source == "Reference" || source == "Recruitment Agency") {
                                        sourceparam = source + ' : ' + reference;
                                    }
                                    else if (source == "Online Portal") {
                                        sourceparam = source + ' : ' + reference;
                                    }
                                    else
                                        sourceparam = source;
                                    var ddltitle = document.getElementById("title");
                                    var title = ddltitle.options[ddltitle.selectedIndex].text;
                                    var firstname = document.getElementById("firstname").value;
                                    var middlename = document.getElementById("middlename").value;
                                    var lastname = document.getElementById("lastname").value;
                                    var ddlgender = document.getElementById("gender");
                                    var gender = ddlgender.options[ddlgender.selectedIndex].text;
                                    var contact = document.getElementById("contact").value;
                                    var birthdate = document.getElementById("birthdate").value;
                                    var email = document.getElementById("email").value;
                                    var presentaddress = document.getElementById("presentaddress").value;
                                    var presentpincode = document.getElementById("presentpincode").value;
                                    var permanentaddress = document.getElementById("permanentaddress").value;
                                    var permanentpincode = document.getElementById("permanentpincode").value;
                                    var ddldomain = document.getElementById("domain");
                                    var domain = ddldomain.options[ddldomain.selectedIndex].value;
                                    var ddlsubdomain = document.getElementById("subdomain");
                                    var subdomain = ddlsubdomain.options[ddlsubdomain.selectedIndex].text;
                                    var remark = document.getElementById("remark").value;

                                    if (title == "Select") {
                                        alert("Please select title.");
                                        document.getElementById("title").focus();
                                        return false;
                                    }
                                    if (firstname == " " || firstname == "") {
                                        alert("Please enter firstname.");
                                        document.getElementById("firstname").focus();
                                        return false;
                                    }
                                    //if (middlename == " " || middlename == "") {
                                    //    alert("Please enter middlename.");
                                    //    document.getElementById("middlename").focus();
                                    //    return false;
                                    //}
                                    if (lastname == " " || lastname == "") {
                                        alert("Please enter lastname.");
                                        document.getElementById("lastname").focus();
                                        return false;
                                    }
                                    if (profile == "Select" || profile == "") {
                                        alert("Please select  profile.");
                                        document.getElementById("profile").focus();
                                        return false;
                                    }
                                    if (location == "Select" || location == "") {
                                        alert("Please select  location.");
                                        document.getElementById("location").focus();
                                        return false;
                                    }

                                    if (gender == "Select" || gender == "") {
                                        alert("Please select gender.");
                                        document.getElementById("track_domain").focus();
                                        return false;
                                    }
                                    if (domain == "Select" || domain == "") {
                                        alert("Please select domain.");
                                        document.getElementById("domain").focus();
                                        return false;
                                    }
                                    if (subdomain == "Select" || subdomain == "") {
                                        alert("Please select subdomain.");
                                        document.getElementById("subdomain").focus();
                                        return false;
                                    }

                                    if (email == "" || email == " ") {
                                        alert("Please enter email.");
                                        document.getElementById("email").focus();
                                        return false;
                                    }
                                    if (birthdate == "" || birthdate == " ") {
                                        alert("Please enter birthdate.");
                                        document.getElementById("birthdate").focus();
                                        return false;
                                    }
                                    if (contact == "" || contact == " ") {
                                        alert("Please enter contact.");
                                        document.getElementById("contact").focus();
                                        return false;
                                    }

                                    if (presentpincode == "" || presentpincode == " ") {
                                        alert("Please enter Present address Pin Code.");
                                        document.getElementById("track_FieldName").focus();
                                        return false;
                                    }
                                    if (presentaddress == "" || presentaddress == " ") {
                                        alert("Please enter Present Address.");
                                        document.getElementById("presentaddress").focus();
                                        return false;
                                    }
                                    if (remark == "" || remark == " ") {
                                        alert("Please enter remark.");
                                        document.getElementById("remark").focus();
                                        return false;
                                    }

                                    $('#waitingpanel').modal('show');
                                    PageMethods.InsertInstantApplication(profile, location, sourceparam, title, firstname, middlename, lastname, gender, contact, birthdate, email,
                                        presentaddress, presentpincode, permanentaddress, permanentpincode, domain, subdomain, remark, OnSucceed, OnError);
                                    return false;
                                }

                                function OnSucceed(result) {

                                    $('#waitingpanel').modal('hide');
                                    $('#approve').modal('hide');
                                    alert('Application added successfully!');
                                    location.reload();

                                }
                                function OnError(error) {
                                    alert(error);
                                }
                            </script>
                        </td>
                    </tr>
                </table>
                <div class="modal fade" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
                    <div class="modal-dialog text-center">
                        <img src="Images/Load.gif" />
                        <br />
                        <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;">System is working on your request. Please wait</span>
                        <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
