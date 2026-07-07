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


        .app-hero {
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%);
            border-radius: 18px;
            padding: 22px 26px;
            color: #fff;
            box-shadow: 0 14px 35px rgba(37,99,235,.22);
            margin-bottom: 18px;
        }

            .app-hero .hero-title {
                font-size: 22px;
                font-weight: 800;
                margin: 0;
                display: flex;
                align-items: center;
                gap: 12px;
            }

                .app-hero .hero-title i {
                    width: 42px;
                    height: 42px;
                    border-radius: 14px;
                    background: rgba(255,255,255,.18);
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                }

            .app-hero .hero-subtitle {
                margin: 7px 0 0 54px;
                opacity: .92;
                font-size: 13px;
            }

            .app-hero .btn-back-modern {
                background: rgba(255,255,255,.16);
                color: #fff !important;
                border: 1px solid rgba(255,255,255,.35);
                padding: 9px 16px;
                border-radius: 999px;
                font-weight: 700;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }

                .app-hero .btn-back-modern:hover {
                    background: #fff;
                    color: #1d4ed8 !important;
                    text-decoration: none;
                }

        .app-card {
            border: 0;
            border-radius: 18px;
            box-shadow: 0 12px 32px rgba(15,23,42,.08);
            overflow: hidden;
        }

        .app-section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 800;
            color: #0f172a;
            margin-bottom: 18px;
        }

            .app-section-title span {
                width: 34px;
                height: 34px;
                border-radius: 10px;
                background: #eff6ff;
                color: #2563eb;
                display: inline-flex;
                align-items: center;
                justify-content: center;
            }

        .app-form-grid {
            display: grid;
            grid-template-columns: repeat(12,1fr);
            gap: 18px;
        }

        .app-field {
            grid-column: span 3;
        }

            .app-field.span-4 {
                grid-column: span 4;
            }

            .app-field.span-6 {
                grid-column: span 6;
            }

            .app-field.span-8 {
                grid-column: span 8;
            }

            .app-field.span-12 {
                grid-column: span 12;
            }

            .app-field label {
                display: block;
                font-weight: 700 !important;
                color: #334155;
                margin-bottom: 7px;
                font-size: 13px;
            }

            .app-field .form-control {
                width: 100% !important;
                min-height: 40px;
                border-radius: 10px;
                border: 1px solid #dbe3ef;
                font-size: 13px;
                box-shadow: none;
            }

            .app-field textarea.form-control {
                min-height: 82px;
                resize: vertical;
            }

        .name-grid {
            display: grid;
            grid-template-columns: 120px repeat(3,1fr);
            gap: 12px;
        }

        .same-address-box {
            grid-column: span 12;
            display: flex;
            align-items: center;
            gap: 10px;
            background: #f8fbff;
            border: 1px dashed #c7d2fe;
            padding: 12px 14px;
            border-radius: 12px;
        }

            .same-address-box input {
                width: 18px;
                height: 18px;
            }

        .upload-modern {
            position: relative;
            border: 2px dashed #c7d2fe;
            border-radius: 16px;
            background: #f8fbff;
            padding: 22px;
            text-align: center;
            transition: .25s;
        }

            .upload-modern:hover {
                border-color: #2563eb;
                transform: translateY(-2px);
                box-shadow: 0 10px 24px rgba(37,99,235,.13);
            }

            .upload-modern input[type=file] {
                width: 100% !important;
                cursor: pointer;
                border: 0;
                background: transparent;
                padding: 10px;
            }

        .upload-icon-modern {
            width: 58px;
            height: 58px;
            border-radius: 18px;
            margin: 0 auto 10px;
            color: #fff;
            background: linear-gradient(135deg,#2563eb,#22c1dc);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            animation: appFloat 2.2s ease-in-out infinite;
        }

        @keyframes appFloat {
            0%,100% {
                transform: translateY(0)
            }

            50% {
                transform: translateY(-7px)
            }
        }

        .dz-preview {
            background: #ecfdf5;
            border: 1px solid #bbf7d0;
            border-radius: 10px;
            padding: 9px 12px;
            margin-top: 10px !important;
        }

        .app-actions {
            display: flex;
            justify-content: flex-end;
            margin-top: 22px;
            padding-top: 18px;
            border-top: 1px solid #e5e7eb;
        }

        .btn-app-primary {
            border: 0;
            border-radius: 12px;
            padding: 11px 30px;
            color: #fff;
            font-weight: 800;
            background: linear-gradient(135deg,#2563eb,#22c1dc);
            box-shadow: 0 10px 20px rgba(37,99,235,.22);
        }

            .btn-app-primary:hover {
                color: #fff;
                transform: translateY(-1px);
                box-shadow: 0 14px 26px rgba(37,99,235,.28);
            }

        @media(max-width:991px) {
            .app-field, .app-field.span-4, .app-field.span-6, .app-field.span-8 {
                grid-column: span 6;
            }

            .name-grid {
                grid-template-columns: 1fr 1fr;
            }
        }

        @media(max-width:576px) {
            .app-field, .app-field.span-4, .app-field.span-6, .app-field.span-8 {
                grid-column: span 12;
            }

            .name-grid {
                grid-template-columns: 1fr;
            }

            .app-hero .hero-subtitle {
                margin-left: 0;
            }
        }
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
        <div class="container-fluid">
            <div class="app-hero d-flex justify-content-between align-items-center flex-wrap">
                <div>
                    <h6 class="hero-title"><i class="fas fa-file-signature"></i><b>Application Form</b></h6>
                    <div class="hero-subtitle">Capture candidate profile, contact, address and resume details.</div>
                </div>
                <a href="#utl" id="aBack" runat="server" class="btn-back-modern mt-2 mt-sm-0" onclick="window.history.go(-1); return false;">
                    <i class="fas fa-arrow-left"></i>Go Back
                </a>
            </div>
        </div>
    </div>
    <div class="col-lg-12">
        <div class="card app-card">
            <div class="card-body p-4">
                <div class="app-section-title">
                    <span><i class="fas fa-user-edit"></i></span>
                    <div>Candidate Application Details</div>
                </div>

                <div class="app-form-grid">
                    <div class="app-field span-12">
                        <label>Name</label>
                        <div class="name-grid">
                            <select id="title" name="title" class="form-control">
                                <option value="Select">Select</option>
                                <option value="Mr.">Mr.</option>
                                <option value="Ms.">Ms.</option>
                            </select>
                            <input id="lastname" name="lastname" class="form-control" placeholder="Last Name" />
                            <input id="firstname" name="firstname" class="form-control" placeholder="First Name" />
                            <input id="middlename" name="middlename" class="form-control" placeholder="Middle Name" />
                        </div>
                    </div>

                    <div class="app-field span-4">
                        <label for="profile">Profile</label>
                        <select id="profile" name="profile" class="form-control" required>
                            <option value="Select">Select</option>
                        </select>
                    </div>
                    <div class="app-field span-4">
                        <label for="location">Location</label>
                        <select id="location" name="location" class="form-control" required>
                            <option value="Select">Select</option>
                            <option value="Akola">Akola</option>
                            <option value="Bangalore">Bangalore</option>
                            <option value="Pune-Kothrud">Pune-Kothrud</option>
                            <option value="Pune-KP">Pune-KP</option>
                            <option value="Pune-Swargate">Pune-Swargate</option>
                            <option value="Solapur">Solapur</option>
                        </select>
                    </div>

                    <div class="app-field span-4">
                        <label for="source">Source</label>
                        <select id="source" name="source" class="form-control" required onchange="getOptions(this);">
                            <option value="Select">Select</option>
                            <option value="Advertisement">Advertisement</option>
                            <option value="OnlinePortal">Online Portal</option>
                            <option value="Other">Other</option>
                            <option value="Reference">Reference</option>
                        </select>
                    </div>
                    <div class="app-field span-4" id="sourcedetails" style="display: none;">
                        <label id="sourcelabel" style="display: none;"></label>
                        <input type="text" id="reference" name="reference" class="form-control" style="display: none;" />
                        <select id="portal" name="portal" class="form-control">
                            <option value="Select">Select</option>
                            <option value="LinkedIn">LinkedIn</option>
                            <option value="Naukri">Naukri</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>

                    <div class="app-field span-4">
                        <label for="domain">Domain</label>
                        <select id="domain" name="domain" class="form-control" required onchange="ondomainclick();">
                            <option value="Select">Select</option>
                        </select>
                    </div>
                    <div class="app-field span-4">
                        <label for="subdomain">Subdomain</label>
                        <select id="subdomain" name="subdomain" class="form-control" required>
                            <option value="Select">Select</option>
                        </select>
                    </div>

                    <div class="app-field span-4">
                        <label for="gender">Gender</label>
                        <select id="gender" name="gender" class="form-control" required>
                            <option value="Select">Select</option>
                            <option value="Female">Female</option>
                            <option value="Male">Male</option>
                        </select>
                    </div>
                    <div class="app-field span-4">
                        <label for="birthdate">Birth Date</label>
                        <input type="date" id="birthdate" name="birthdate" class="form-control" />
                    </div>

                    <div class="app-field span-4">
                        <label for="email">Email Address</label>
                        <input type="text" id="email" name="email" class="form-control" />
                    </div>
                    <div class="app-field span-4">
                        <label for="contact">Contact #</label>
                        <input type="text" id="contact" name="contact" class="form-control" />
                    </div>

                    <div class="app-field span-8">
                        <label for="presentaddress">Present Address</label>
                        <textarea id="presentaddress" name="presentaddress" class="form-control"></textarea>
                    </div>
                    <div class="app-field span-4">
                        <label for="presentpincode">Present Pincode</label>
                        <input type="number" id="presentpincode" name="presentpincode" class="form-control" />
                    </div>

                    <div class="same-address-box">
                        <input type="checkbox" id="chkpresentaddress" name="chkpresentaddress" class="form-check" onchange="getaddress(this);" />
                        <label for="chkpresentaddress" class="mb-0"><b>Is Permanent Address same as Present Address?</b></label>
                    </div>

                    <div class="app-field span-8">
                        <label for="permanentaddress">Permanent Address</label>
                        <textarea id="permanentaddress" name="permanentaddress" class="form-control"></textarea>
                    </div>
                    <div class="app-field span-4">
                        <label for="permanentpincode">Permanent Pincode</label>
                        <input type="number" id="permanentpincode" name="permanentpincode" class="form-control" />
                    </div>

                    <div class="app-field span-6">
                        <label for="remark">Remark</label>
                        <textarea id="remark" name="remark" class="form-control"></textarea>
                    </div>
                    <div class="app-field span-6">
                        <label for="attachment">Upload Resume</label>
                        <div class="upload-modern">
                            <div class="upload-icon-modern"><i class="fas fa-cloud-upload-alt"></i></div>
                            <div class="font-weight-bold">Choose resume / attachment</div>
                            <small class="text-muted d-block mb-2">Click below to select file</small>
                            <input type="file" id="attachment" name="attachment" class="form-control" />
                            <div class="dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete" id="dropzone">
                                <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column" id="conentdiv" style="display: none!important;">
                                    <div class="flex-1 d-flex flex-between-center">
                                        <div id="filesdiv" style="margin-top: 10px; margin-bottom: 10px;"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="app-actions">
                    <button id="btnSubmit" type="button" onclick="submitdata();" class="btn btn-app-primary">
                        <i class="fas fa-paper-plane"></i>&nbsp; Submit Application
                   
                    </button>
                </div>

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

<%--<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
</asp:Content>--%>
