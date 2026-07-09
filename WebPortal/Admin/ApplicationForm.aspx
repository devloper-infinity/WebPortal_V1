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

        /* .application-form-shell {
            padding: 0 18px 28px;
        }*/

        /*.app-hero {
            background: linear-gradient(105deg, #2854df 0%, #245fe5 42%, #2294e7 78%, #4bc2d7 100%);
            border: 0;
            border-radius: 22px;
            box-shadow: 0 16px 34px rgba(37, 99, 235, .18);
            color: #ffffff;
            margin-bottom: 12px;*/
        /*    min-height: 110px;*/
        /*overflow: hidden;*/
        /*    padding: 24px 28px;*/
        /*position: relative;
        }

            .app-hero::before,
            .app-hero::after {
                content: "";
                position: absolute;
                border-radius: 50%;
                pointer-events: none;
            }

            .app-hero::before {
                right: -24px;
                top: -78px;
                width: 146px;
                height: 190px;
                background: rgba(255, 255, 255, .15);
            }

            .app-hero::after {
                right: 90px;
                bottom: -84px;
                width: 118px;
                height: 156px;
                background: rgba(255, 255, 255, .12);
            }

            .app-hero > * {
                position: relative;
                z-index: 1;
            }

            .app-hero-content {
                min-width: 260px;
            }

            .app-hero .hero-title {
                color: #ffffff;
                font-size: 24px;
                gap: 15px;
            }

                .app-hero .hero-title i {
                    width: 62px;
                    height: 62px;
                    border-radius: 20px;
                    background: rgba(255, 255, 255, .16);
                    border: 1px solid rgba(255, 255, 255, .30);
                    box-shadow: inset 0 1px 0 rgba(255, 255, 255, .16);
                    color: #ffffff;
                    font-size: 27px;
                }

            .app-hero .hero-subtitle {
                color: rgba(255, 255, 255, .92);
                font-size: 13px;
                font-weight: 700;
                margin: 6px 0 0 77px;
                opacity: 1;
            }

            .app-hero-right {
                align-items: center;
                display: flex;
                flex-wrap: wrap;
                gap: 10px;
                justify-content: flex-end;
            }*/

        .ar-hero {
            background: linear-gradient(120deg,#1d4ed8 0%,#2563eb 58%,#22c1dc 100%);
            border-radius: 18px;
            color: #fff;
            padding: 20px 24px;
            box-shadow: 0 18px 38px rgba(37,99,235,.24);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 18px;
            position: relative;
            overflow: hidden;
        }

            .ar-hero:after {
                content: "";
                position: absolute;
                width: 220px;
                height: 220px;
                right: -70px;
                top: -90px;
                background: rgba(255,255,255,.14);
                border-radius: 50%;
            }

        .ar-title-wrap {
            display: flex;
            align-items: center;
            gap: 14px;
            position: relative;
            z-index: 1;
        }

        .ar-icon {
            width: 54px;
            height: 54px;
            border-radius: 16px;
            background: rgba(255,255,255,.18);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            box-shadow: inset 0 0 0 1px rgba(255,255,255,.28);
        }

        .ar-hero h4 {
            margin: 0;
            font-size: 21px;
            font-weight: 800;
            letter-spacing: .2px;
        }

        .ar-hero p {
            margin: 4px 0 0;
            color: rgba(255,255,255,.86);
            font-size: 13px;
        }

        .ar-back {
            position: relative;
            z-index: 1;
            color: #fff !important;
            border: 1px solid rgba(255,255,255,.38);
            padding: 9px 15px;
            border-radius: 999px;
            font-weight: 700;
            font-size: 12px;
            text-decoration: none !important;
            background: rgba(255,255,255,.12);
            transition: .25s ease;
        }

            .ar-back:hover {
                background: #fff;
                color: #1d4ed8 !important;
                transform: translateY(-1px);
            }


        .hero-badge {
            align-items: center;
            background: rgba(255, 255, 255, .13);
            border: 1px solid rgba(255, 255, 255, .30);
            border-radius: 999px;
            box-shadow: inset 0 1px 0 rgba(255, 255, 255, .14);
            color: #ffffff;
            display: inline-flex;
            font-size: 12px;
            font-weight: 800;
            gap: 8px;
            min-height: 38px;
            padding: 9px 16px;
            white-space: nowrap;
        }

        .app-hero .btn-back-modern {
            background: rgba(255, 255, 255, .13);
            border: 1px solid rgba(255, 255, 255, .30);
            border-radius: 999px;
            color: #ffffff !important;
            min-height: 38px;
            padding: 9px 16px;
        }

            .app-hero .btn-back-modern:hover {
                background: #ffffff;
                border-color: #ffffff;
                color: #2854df !important;
            }

        .app-card {
            border: 1px solid #dbe5ef;
            border-radius: 8px;
            box-shadow: 0 14px 34px rgba(15, 23, 42, .08);
            overflow: hidden;
        }

            .app-card .card-body {
                background: #ffffff;
            }

        .app-section {
            border-top: 1px solid #e8eef5;
            padding: 20px 22px;
        }

        .app-section-first {
            border-top: 0;
        }

        .app-section-title {
            font-size: 15px;
            margin-bottom: 14px;
        }

            .app-section-title span {
                width: 32px;
                height: 32px;
                border-radius: 8px;
                background: #edf4ff;
                color: #245fe5;
                flex: 0 0 32px;
            }

            .app-section-title small {
                color: #667085;
                display: block;
                font-size: 12px;
                font-weight: 500;
                margin-top: 2px;
            }

        .app-form-grid {
            gap: 14px 16px;
        }

        .app-field label {
            color: #344054;
            font-size: 12px;
            font-weight: 700 !important;
        }

        .app-field .form-control {
            border-color: #cfd8e3;
            border-radius: 7px;
            font-size: 13px;
            min-height: 38px;
            transition: border-color .15s ease, box-shadow .15s ease, background-color .15s ease;
        }

            .app-field .form-control:focus {
                border-color: #245fe5;
                box-shadow: 0 0 0 .18rem rgba(36, 95, 229, .14);
            }

        .app-field textarea.form-control {
            min-height: 86px;
        }

        .name-grid {
            grid-template-columns: 105px repeat(3, minmax(0, 1fr));
        }

        .same-address-box {
            background: #f7fbff;
            border-color: #b9d6ff;
            border-radius: 8px;
            color: #24436b;
        }

            .same-address-box label {
                margin-bottom: 0;
            }

        .upload-modern {
            background: #f8fafc;
            border-color: #cbd5e1;
            border-radius: 8px;
            min-height: 151px;
            padding: 18px;
            text-align: left;
        }

            .upload-modern:hover {
                border-color: #245fe5;
                box-shadow: 0 10px 24px rgba(36, 95, 229, .12);
                transform: none;
            }

            .upload-modern input[type=file] {
                background: #ffffff;
                border: 1px solid #d7e0ea;
                border-radius: 7px;
                margin-top: 10px;
                padding: 8px;
            }

            .upload-modern.is-selected {
                background: #f0f7ff;
                border-color: #245fe5;
            }

        .upload-icon-modern {
            animation: none;
            background: linear-gradient(135deg, #2854df, #2294e7);
            border-radius: 8px;
            float: left;
            font-size: 20px;
            height: 46px;
            margin: 0 14px 8px 0;
            width: 46px;
        }

        #filesdiv {
            color: #1d4ed8;
            font-weight: 700;
            overflow-wrap: anywhere;
        }

        .dz-preview {
            background: #edf6ff;
            border-color: #b9d6ff;
            clear: both;
        }

        .app-actions {
            background: #f8fafc;
            border-top: 1px solid #e8eef5;
            margin-top: 0;
            padding: 16px 22px;
        }

        .btn-app-primary {
            background: linear-gradient(105deg, #2854df 0%, #2294e7 100%);
            border-radius: 8px;
            box-shadow: 0 10px 20px rgba(37, 99, 235, .22);
            min-height: 40px;
            padding: 9px 24px;
        }

            .btn-app-primary:hover,
            .btn-app-primary:focus {
                background: linear-gradient(105deg, #2047c7 0%, #1687d8 100%);
                box-shadow: 0 12px 24px rgba(37, 99, 235, .28);
            }

        .is-invalid-field {
            border-color: #dc3545 !important;
            box-shadow: 0 0 0 .16rem rgba(220, 53, 69, .14) !important;
        }

        .loading {
            align-items: center;
            background: rgba(15, 23, 42, .36);
            height: auto;
            inset: 0;
            left: 0;
            margin: 0;
            opacity: 1;
            top: 0;
            width: auto;
        }

            .loading[style*="display: block"] {
                display: flex !important;
            }

        .loading-card {
            align-items: center;
            background: #ffffff;
            border-radius: 8px;
            box-shadow: 0 18px 45px rgba(15, 23, 42, .22);
            color: #344054;
            display: flex;
            gap: 12px;
            min-width: 260px;
            padding: 18px 20px;
        }

            .loading-card img {
                height: 38px;
                width: 38px;
            }

        .app-wait-modal .modal-dialog {
            max-width: 360px;
        }

        .app-wait-modal .modal-content {
            border: 0;
            border-radius: 8px;
            box-shadow: 0 24px 55px rgba(15, 23, 42, .28);
        }

        .app-wait-card {
            color: #172033;
            padding: 28px;
            text-align: center;
        }

        .app-wait-spinner {
            animation: appSpin .85s linear infinite;
            border: 4px solid #d8e7ff;
            border-radius: 50%;
            border-top-color: #245fe5;
            height: 42px;
            margin: 0 auto 14px;
            width: 42px;
        }

        @keyframes appSpin {
            to {
                transform: rotate(360deg);
            }
        }

        @media(max-width:991px) {
            .application-form-shell {
                padding: 0 12px 22px;
            }
        }

        @media(max-width:576px) {
            .app-section {
                padding: 16px 14px;
            }

            .app-actions {
                padding: 14px;
            }

                .app-actions .btn-app-primary {
                    width: 100%;
                }

            .app-hero .hero-subtitle {
                margin-left: 0;
            }

            .app-hero-right {
                justify-content: stretch;
                width: 100%;
            }

            .hero-badge {
                justify-content: center;
                width: 100%;
            }

            .app-hero .btn-back-modern {
                width: 100%;
                justify-content: center;
            }
        }
    </style>

    <script type="text/javascript">
        $(function () {
            var attachment = document.getElementById('attachment');
            if (attachment) {
                attachment.addEventListener('change', getFileName);
            }
        });

        const getFileName = (event) => {
            const files = event.target.files;
            if (!files || !files.length) {
                return;
            }
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
            document.querySelector(".upload-modern").classList.add("is-selected");
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
        <div class="loading-card">
            <img src="../images/Load_1.gif" alt="" />
            <div>
                <strong>Loading form data</strong>
                <div class="text-muted small">One moment, please.</div>
            </div>
        </div>
    </div>
  
    <div class="ar-hero">
        <div class="ar-title-wrap">
            <div class="ar-icon"><i class="fas fa-file-signature"></i></div>
            <div>
                <h4>Application Form</h4>
                <p>Candidate profile, sourcing, contact and resume intake.</p>
            </div>
        </div>
        <a href="#!" id="aBack" runat="server" class="ar-back" onclick="window.history.go(-1); return false;">
           Go Back
      </a>
    </div>

    <div class="container-fluid application-form-shell">
        <div class="card app-card">
            <div class="card-body p-0">
                <div class="app-section app-section-first">
                    <div class="app-section-title">
                        <span><i class="fas fa-user-edit"></i></span>
                        <div>
                            Candidate Details
                           
                            <small>Basic identity, role and sourcing information.</small>
                        </div>
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
                    </div>
                </div>

                <div class="app-section">
                    <div class="app-section-title">
                        <span><i class="fas fa-id-card"></i></span>
                        <div>
                            Contact Details
                           
                            <small>Personal details and communication information.</small>
                        </div>
                    </div>

                    <div class="app-form-grid">

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
                    </div>
                </div>

                <div class="app-section">
                    <div class="app-section-title">
                        <span><i class="fas fa-map-marker-alt"></i></span>
                        <div>
                            Address Details
                           
                            <small>Present and permanent address information.</small>
                        </div>
                    </div>

                    <div class="app-form-grid">

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
                    </div>
                </div>

                <div class="app-section">
                    <div class="app-section-title">
                        <span><i class="fas fa-paperclip"></i></span>
                        <div>
                            Notes & Attachment
                           
                            <small>Internal remarks and candidate resume.</small>
                        </div>
                    </div>

                    <div class="app-form-grid">

                        <div class="app-field span-6">
                            <label for="remark">Remark</label>
                            <textarea id="remark" name="remark" class="form-control"></textarea>
                        </div>
                        <div class="app-field span-6">
                            <label for="attachment">Upload Resume</label>
                            <div class="upload-modern">
                                <div class="upload-icon-modern"><i class="fas fa-cloud-upload-alt"></i></div>
                                <div class="font-weight-bold">Choose resume / attachment</div>
                                <small class="text-muted d-block mb-2">Resume or supporting document</small>
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
                    function showValidation(message, fieldId) {
                        alert(message);
                        var field = document.getElementById(fieldId);
                        if (field) {
                            field.focus();
                            field.classList.add("is-invalid-field");
                            setTimeout(function () {
                                field.classList.remove("is-invalid-field");
                            }, 1800);
                        }
                        return false;
                    }

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
                            sourceparam = source + ' : ' + portal;
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
                            return showValidation("Please select title.", "title");
                        }
                        if ($.trim(firstname) == "") {
                            return showValidation("Please enter firstname.", "firstname");
                        }
                        //if (middlename == " " || middlename == "") {
                        //    alert("Please enter middlename.");
                        //    document.getElementById("middlename").focus();
                        //    return false;
                        //}
                        if ($.trim(lastname) == "") {
                            return showValidation("Please enter lastname.", "lastname");
                        }
                        if (profile == "Select" || profile == "") {
                            return showValidation("Please select profile.", "profile");
                        }
                        if (location == "Select" || location == "") {
                            return showValidation("Please select location.", "location");
                        }
                        if (source == "Select" || source == "") {
                            return showValidation("Please select source.", "source");
                        }
                        if ((source == "Reference" || source == "Recruitment Agency") && $.trim(reference) == "") {
                            return showValidation("Please enter source details.", "reference");
                        }
                        if (source == "Online Portal" && (portal == "Select" || portal == "")) {
                            return showValidation("Please select portal.", "portal");
                        }

                        if (gender == "Select" || gender == "") {
                            return showValidation("Please select gender.", "gender");
                        }
                        if (domain == "Select" || domain == "") {
                            return showValidation("Please select domain.", "domain");
                        }
                        if (subdomain == "Select" || subdomain == "") {
                            return showValidation("Please select subdomain.", "subdomain");
                        }

                        if ($.trim(email) == "") {
                            return showValidation("Please enter email.", "email");
                        }
                        if ($.trim(birthdate) == "") {
                            return showValidation("Please enter birthdate.", "birthdate");
                        }
                        if ($.trim(contact) == "") {
                            return showValidation("Please enter contact.", "contact");
                        }

                        if ($.trim(presentpincode) == "") {
                            return showValidation("Please enter Present address Pin Code.", "presentpincode");
                        }
                        if ($.trim(presentaddress) == "") {
                            return showValidation("Please enter Present Address.", "presentaddress");
                        }
                        if ($.trim(remark) == "") {
                            return showValidation("Please enter remark.", "remark");
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
                        $('#waitingpanel').modal('hide');
                        alert(error && error.get_message ? error.get_message() : error);
                    }
                            </script>
                <div class="modal fade app-wait-modal" id="waitingpanel" tabindex="-1" data-backdrop="static" data-keyboard="false" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content">
                            <div class="app-wait-card">
                                <div class="app-wait-spinner"></div>
                                <strong>Saving application</strong>
                                <div class="text-muted small mt-1">Please wait while the record is prepared.</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
