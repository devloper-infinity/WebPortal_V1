<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="UserLeaves.aspx.cs" Inherits="WebPortal.Admin.UserLeaves" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        function toUnicodeVariant(str, variant, flags) {
            const offsets = {
                m: [0x1d670, 0x1d7f6],
                b: [0x1d400, 0x1d7ce],
                i: [0x1d434, 0x00030],
                bi: [0x1d468, 0x00030],
                c: [0x1d49c, 0x00030],
                bc: [0x1d4d0, 0x00030],
                g: [0x1d504, 0x00030],
                d: [0x1d538, 0x1d7d8],
                bg: [0x1d56c, 0x00030],
                s: [0x1d5a0, 0x1d7e2],
                bs: [0x1d5d4, 0x1d7ec],
                is: [0x1d608, 0x00030],
                bis: [0x1d63c, 0x00030],
                o: [0x24B6, 0x2460],
                p: [0x249C, 0x2474],
                w: [0xff21, 0xff10],
                u: [0x2090, 0xff10]
            }

            const variantOffsets = {
                'monospace': 'm',
                'bold': 'b',
                'italic': 'i',
                'bold italic': 'bi',
                'script': 'c',
                'bold script': 'bc',
                'gothic': 'g',
                'gothic bold': 'bg',
                'doublestruck': 'd',
                'sans': 's',
                'bold sans': 'bs',
                'italic sans': 'is',
                'bold italic sans': 'bis',
                'parenthesis': 'p',
                'circled': 'o',
                'fullwidth': 'w'
            }

            // special characters (absolute values)
            var special = {
                m: {
                    ' ': 0x2000,
                    '-': 0x2013
                },
                i: {
                    'h': 0x210e
                },
                g: {
                    'C': 0x212d,
                    'H': 0x210c,
                    'I': 0x2111,
                    'R': 0x211c,
                    'Z': 0x2128
                },
                o: {
                    '0': 0x24EA,
                    '1': 0x2460,
                    '2': 0x2461,
                    '3': 0x2462,
                    '4': 0x2463,
                    '5': 0x2464,
                    '6': 0x2465,
                    '7': 0x2466,
                    '8': 0x2467,
                    '9': 0x2468,
                },
                p: {},
                w: {}
            }
            //support for parenthesized latin letters small cases 
            for (var i = 97; i <= 122; i++) {
                special.p[String.fromCharCode(i)] = 0x249C + (i - 97)
            }
            //support for full width latin letters small cases 
            for (var i = 97; i <= 122; i++) {
                special.w[String.fromCharCode(i)] = 0xff41 + (i - 97)
            }

            const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
            const numbers = '0123456789';

            var getType = function (variant) {
                if (variantOffsets[variant]) return variantOffsets[variant]
                if (offsets[variant]) return variant;
                return 'm'; //monospace as default
            }
            var getFlag = function (flag, flags) {
                if (!flags) return false
                return flags.split(',').indexOf(flag) > -1
            }

            var type = getType(variant);
            var underline = getFlag('underline', flags);
            var strike = getFlag('strike', flags);
            var result = '';

            for (var k of str) {
                let index
                let c = k
                if (special[type] && special[type][c]) c = String.fromCodePoint(special[type][c])
                if (type && (index = chars.indexOf(c)) > -1) {
                    result += String.fromCodePoint(index + offsets[type][0])
                } else if (type && (index = numbers.indexOf(c)) > -1) {
                    result += String.fromCodePoint(index + offsets[type][1])
                } else {
                    result += c
                }
                if (underline) result += '\u0332' // add combining underline
                if (strike) result += '\u0336' // add combining strike
            }
            return result
        }

    </script>
    <style>
        #loader {
            border: 16px solid #f3f3f3;
            border-radius: 50%;
            border-top: 16px solid #3498db;
            width: 120px;
            height: 120px;
            -webkit-animation: spin 2s linear infinite;
            animation: spin 2s linear infinite;
            margin-left: 250px;
            margin-top: 250px;
        }


        @-webkit-keyframes spin {
            0% {
                -webkit-transform: rotate(0deg);
            }

            100% {
                -webkit-transform: rotate(360deg);
            }
        }

        @keyframes spin {
            0% {
                transform: rotate(0deg);
            }

            100% {
                transform: rotate(360deg);
            }
        }

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

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: normal !important;
            border: none !important;
        }

        .dataTables_paginate {
            float: left !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 50px;
            float: left;
        }

        .buttons-excel, .buttons-html5 {
            color: #fff;
            /*     background-color: #28a745;
            border-color: #28a745;*/
            box-shadow: none;
            background: linear-gradient(to right, #ffbf96, #fe7096);
            border: 0;
            font-weight: bold;
            margin: 0px 10px;
        }

        .table.dataTable th {
            background: linear-gradient(to bottom, #007bff, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none;
        }
    </style>
    <script>


        var table;
        var userID;
        var selectedrow;
        var html = '';

        $(document).ready(function () {
            var currentUserName = '<%= HttpContext.Current.User.Identity.Name.ToString() %>';
            //if (currentUserName == 7036 || currentUserName == 12 || currentUserName == 216 || currentUserName == 285 || currentUserName == 8535 || currentUserName == 9738 || currentUserName == 277 || currentUserName == 99 || currentUserName == 8128)
            //    document.getElementById("mainleaveuser").style.display = "";
            //else {
            //    document.getElementById("mainleaveuser").style.display = "none";
            //    alert("You are not authorized to view this page. Please contact your domain head.");
            //    return;
            //}

            $.ajax({
                type: "POST", url: "AttendanceCorrectionpm.aspx/GetLoggedInUser", dataType: "json", contentType: "application/json",
                success: function (res) {
                    var dataArray = JSON.parse(res.d);
                    $.each(dataArray, function (data, value) {
                        if (value.Domain == 9 && value.WorkingBranch == 2) {
                            document.getElementById("mainleaveuser").style.display = "";
                            pmatt_bindusers();
                            pmatt_bindReasons();
                            pmatt_BindGrid();
                        }
                        else if (currentUserName == 7036 || currentUserName == 12 || currentUserName == 216 || currentUserName == 285 || currentUserName == 8535 || currentUserName == 9738 || currentUserName == 277 || currentUserName == 99 || currentUserName == 8128 || currentUserName == 291 || currentUserName == 255) {
                            document.getElementById("mainleaveuser").style.display = "";
                            pmatt_bindusers();
                            pmatt_bindReasons();
                            pmatt_BindGrid();
                        }
                        else {
                            document.getElementById("mainleaveuser").style.display = "none";
                            alert("You are not authorized to view this page. Please contact your domain head.");
                            return;
                        }

                    })
                }
            });


            $.ajax({
                type: "POST", url: "UserLeaves.aspx/GetAllEmployees", dataType: "json", contentType: "application/json",
                success: function (res) {
                    $.each(res.d, function (data, value) {
                        $("#users").append($("<option></option>").val(value.EMPID).html(value.Code + ' : ' + value.NAME));
                    })
                    //$("#users").append($("<option></option>").val("Other").html("Other"));
                }

            });

            $('#load1').show();
            $.ajax({
                url: "UserLeaves.aspx/BindUserLeaves",
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    var dataArray = JSON.parse(data.d);
                    $.each(dataArray, function (index, value) {
                          html += '<tr>';
                        html += '<td style="display: none;">' + value.LeaveId + '</td>';
                        html += '<td style="display: none;">' + value.IsApproved + '</td>';

                        html += '<td class=""><div class="btn-group">';
                        html += '<div class="btn-group">';
                        html += '<div type="button" data-toggle="dropdown" aria-expanded="false"><i style="color: dodgerblue; font-size:14px;" class="uil fs-0 me-2 uil-cog"></i>';
                        html += '<span class="sr-only"></span></div><div class="dropdown-menu" role="menu" style="">';
                        html += '<a class="dropdown-item" href="#!" id="Actions" onclick="EditAction(' + value.LeaveId + ',' + index + ',1);"><span style="color: forestgreen;"><i class="uil fs-0 me-2 uil-pen"></i></span>&nbsp;&nbsp;Approve/ Reject</a>';
                        html += '<a class="dropdown-item" href="#!" id="ActionsEx" onclick="ExtendAction(' + value.LeaveId + ',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-file"></i></span>&nbsp;&nbsp;Extend/ Shorten</a><div class="dropdown-divider"></div>';
                        html += '<a class="dropdown-item text-danger" href="#!" id="ActionCancel" onclick="CancelLeave(' + value.LeaveId + ',' + index + ');"><i class="uil fs-0 me-2 uil-x"></i>&nbsp;&nbsp;Cancel Leave</a></div></div></td > ';

                        html += '<td>' + value.Code1 + '</td>';
                        html += '<td>' + value.LeaveType + '</td>';
                        html += '<td>' + value.ForDays + '</td>';
                        html += '<td>' + value.LeaveFrom + '</td>';
                        html += '<td>' + value.LeaveTo + '</td>';
                        html += '<td>' + value.ReasonForLeave + '</td>';
                        html += '<td>' + value.Status + '</td>';
                        html += '<td style="display: none;">' + value.Eligible + '</td>';
                        html += '</tr>';
                    });
                    $('#Leaves tbody').html(html);
                    if ($.fn.dataTable.isDataTable('#Leaves')) {
                        table.destroy();
                    }
                    //else
                    {
                        table = $('#Leaves').DataTable({
                            dom: 'pBfti',
                            scrollX: true,
                            destroy: true,
                            "paging": true,
                            "autoWidth": true,
                            select: true, processing: true,
                            ordering: false,

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
                                    extend: 'excelHtml5', title: 'User Leaves', autoFilter: true,
                                    className: 'btn btn-datatable',
                                    exportOptions: {
                                        columns: [3, 4, 5, 6, 7, 8, 9]
                                    },
                                    customize: function (xlsx) {
                                        var sheet = xlsx.xl.worksheets['sheet1.xml'];
                                        var freezePanes =
                                            '<sheetViews><sheetView tabSelected="1" workbookViewId="0"><pane xSplit="2" ySplit="1" topLeftCell="B2"  activePane="bottomRight" state="frozen"/></sheetView></sheetViews>';
                                        var current = sheet.children[0].innerHTML;
                                        current = freezePanes + current;
                                        sheet.children[0].innerHTML = current;
                                    },
                                },


                                {
                                    extend: 'pdfHtml5', orientation: 'landscape', title: 'User Leaves',
                                    className: 'btn btn-datatable',
                                    exportOptions: {
                                        columns: [3, 4, 5, 6, 7, 8, 9]
                                    }
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
        });


        function EditAction(LeaveID, index) {
           
            var row = table.row(index).data();
            //console.log(thisRowSelected);
            userID = row[0];
            var status = row[9];
            document.getElementById('UserCode').value = row[3];
            document.getElementById('LeaveType').value = row[4];
            document.getElementById('Fordays').value = row[5];
            document.getElementById('DateRange').value = row[5] + ' day(s) From ' + row[6] + ' to ' + row[7];
            document.getElementById('Reason').value = row[8];
            //$('#leaveapprovalrejection').modal('show');
            alert(row[10]);
            if (row[10] == "Eligible") {
                document.getElementById("leavestatus").style.display = '';
                document.getElementById("leavestatusrow").style.display = '';
            }
            else {
                document.getElementById("leavestatus").style.display = 'none';
                document.getElementById("leavestatusrow").style.display = 'none';
            }
            if (status == "Pending")
                $('#leaveapprovalrejection').modal('show');
            else
                alert('Leave is already ' + status);
        }

        function ExtendAction(LeaveID, index) {
            var row = table.row(index).data();
            userID = row[0];
            var status = row[9];
            document.getElementById('UserCodeEx').value = row[3];
            document.getElementById('LeaveTypeEx').value = row[4];
            document.getElementById("<%= hdDays.ClientID %>").Value = row[5];
            document.getElementById('DateRangeFromEx').value = row[6];
            document.getElementById('DateRangeToEx').value = row[7];
            document.getElementById('ReasonEx').value = row[8];
            if (status == "Approved")
                $('#leaveentendshorten').modal('show');
            else
                alert('Leave is not approved.');

        }

        function CancelLeave(LeaveID, index) {
            var row = table.row(index).data();
            //console.log(thisRowSelected);
            var status = row[9];
            if (status == "Approved")
                $('#Cancelleave').modal('show');
            else
                alert('Leave is not approved');
        }

        function SubmitAction() {
            if (document.getElementById("leavestatus").style.display == '') {
                if (document.getElementById('ddlLeaveStatus').selectedIndex == 0) {
                    alert('Please select leave status');
                    document.getElementById('ddlLeaveStatus').focus();
                    return;
                }
            }
            if (document.getElementById('ddlLeaveStatus').selectedIndex == 1) {
                $.ajax({
                    type: "POST",
                    url: "UserLeaves.aspx/getPendingLeaveCount", dataType: "json", contentType: "application/json",
                    data: "{Code: '" + document.getElementById('UserCode').value.substring(0, 3) + "'}",
                    contentType: "application/json; charset=utf-8",
                    success: function (msg) {
                        if (parseFloat(document.getElementById("Fordays").value) <= parseFloat(msg.d)) {
                            var dd = document.getElementById('ddaction');
                            if (dd.selectedIndex == 0) {
                                alert('Please select proper action.');
                                dd.focus();
                                return;
                            }
                            var textarea = document.getElementById('comments');
                            if (comments.value.trim().length < 10) {
                                alert('Comments should be more than 10 charaters long.');
                                return;
                            }
                            var LeaveID = userID;
                            var status = dd.options[dd.selectedIndex].text;
                            var comment = textarea.value;
                            $('#leaveapprovalrejection').modal('hide');
                            $('#waitingpanel').modal('show');
                            PageMethods.UpdateLeaveStatus(LeaveID, status, comment, onSucceed, onError);
                        }
                        else {
                            alert('Applied leave count is greater than actual pending leaves. Please change status to ' + toUnicodeVariant('Unpaid', 'bold sans', 'bold'));
                            return;
                        }
                    }
                });
            }
            else {
                var dd = document.getElementById('ddaction');
                if (dd.selectedIndex == 0) {
                    alert('Please select proper action.');
                    dd.focus();
                    return;
                }
                var textarea = document.getElementById('comments');
                if (comments.value.trim().length < 10) {
                    alert('Comments should be more than 10 charaters long.');
                    return;
                }
                var LeaveID = userID;
                var status = dd.options[dd.selectedIndex].text;
                var comment = textarea.value;
                $('#leaveapprovalrejection').modal('hide');
                $('#waitingpanel').modal('show');
                PageMethods.UpdateLeaveStatus(LeaveID, status, comment, onSucceed, onError);
            }



        }

        function onSucceed(result) {
            if (result > 0) {
                alert('Leave status updated successfully.');
            }
            location.reload(true);
        }

        function onError(result) {

        }

        function SubmitActionCancel() {
            //$('#Cancelleave').modal('show');
        }

        function SubmitActionEx() {
            var dd = document.getElementById('ddactionEx');
            if (dd.selectedIndex == 0) {
                alert('Please select proper action.');
                dd.focus();
                return;
            }
            var textarea = document.getElementById('commentsEx');
            if (comments.value.trim().length < 10) {
                alert('Comments should be more than 10 charaters long.');
                return;
            }
            var LeaveID = userID;
            var status = dd.options[dd.selectedIndex].text;
            var comment = textarea.value;
            PageMethods.UpdateLeaveStatus(LeaveID, status, comment, onSucceedEx, onErrorEx);
        }

        function onSucceedEx(result) {

            location.reload(true);
        }

        function onErrorEx(result) {

        }

        function changebuttontext() {
            var dd = document.getElementById('ddaction');
            if (dd.selectedIndex == 1) {
                document.getElementById('btnApprove').innerHTML = "Approve";
            }
            else if (dd.selectedIndex == 2) {
                document.getElementById('btnApprove').innerHTML = "Reject";
            }
            else
                document.getElementById('btnApprove').innerHTML = "Okay";
        }

        function changebuttontextEx() {
            var noofdays = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"];
            var dd = document.getElementById('ddactionEx');
            if (dd.selectedIndex == 1) {
                var select = document.getElementById("daysEx");
                let options = select.getElementsByTagName('option');

                for (var i = options.length; i--;) {
                    select.removeChild(options[i]);
                }
                for (var i = 0; i < 20; i++) {
                    var option = document.createElement("option"),
                        txt = document.createTextNode(noofdays[i]);
                    option.appendChild(txt);
                    option.setAttribute("value", noofdays[i]);
                    select.insertBefore(option, select.lastChild);
                }
                select.value = document.getElementById("<%= hdDays.ClientID %>").Value;
                document.getElementById('btnApproveEx').innerHTML = "Extend";
            }
            else if (dd.selectedIndex == 2) {
                var select = document.getElementById("daysEx");
                let options = select.getElementsByTagName('option');

                for (var i = options.length; i--;) {
                    select.removeChild(options[i]);
                }
                for (var i = 0; i < parseInt(document.getElementById("<%= hdDays.ClientID %>").Value); i++) {
                    var option = document.createElement("option"),
                        txt = document.createTextNode(noofdays[i]);
                    option.appendChild(txt);
                    option.setAttribute("value", noofdays[i]);
                    select.insertBefore(option, select.lastChild);
                }
                select.value = document.getElementById("<%= hdDays.ClientID %>").Value;
                document.getElementById('btnApproveEx').innerHTML = "Shorten";
            }
            else
                document.getElementById('btnApproveEx').innerHTML = "Okay";
        }

    </script>
    <script>
        function GetLeavesToDate() {
            var FromDate = document.getElementById("<%= txtUserFromDate.ClientID%>").value
            var myDate = new Date(FromDate);
            var today = new Date();
            today.setHours(0, 0, 0, 0);
            //var Days = document.getElementById("<%= ddlUserDays.ClientID%>");
            var Days = document.getElementById("days");

            var valdays = Days.options[Days.selectedIndex].text;

            if (myDate < today) {
                alert('You cannot select past date or todays date!');
                document.getElementById("<%= txtUserFromDate.ClientID%>").value = '';
                return false;
            }
            else if (FromDate != '') {
                PageMethods.GetLeavesToDate(FromDate, valdays, OnSucceededLeaves, onErrorLeaves);
                return false;
            }
            else {

            }
            document.getElementById("<%= txtUserToDate.ClientID%>").value = '';
        }

        function GetLeavesToDateEx() {
            var FromDate = document.getElementById('DateRangeFromEx').value;
            var myDate = new Date(FromDate);
            var today = new Date();
            today.setHours(0, 0, 0, 0);
            var Days = document.getElementById('daysEx');
            var valdays = Days.options[Days.selectedIndex].text;
            if (myDate < today) {
                alert('You cannot select past date or todays date!');
                document.getElementById('DateRangeFromEx').value = '';
                return false;
            }
            else if (FromDate != '') {
                PageMethods.GetLeavesToDate(FromDate, valdays, OnSucceededLeavesEx, onErrorLeavesEx);
                return false;
            }
            else {

            }
            document.getElementById('DateRangeFromEx').value = '';
        }

        function OnSucceededLeavesEx(result) {

            if (result != "") {
                document.getElementById('DateRangeToEx').value = result;
            }
            else {
                document.getElementById('DateRangeToEx').value = '';
            }
        }

        function onErrorLeavesEx(result) {

        }

        function OnSucceededLeaves(result) {

            if (result != "") {

                document.getElementById("<%= txtUserToDate.ClientID %>").value = result;
            }
            else {
                document.getElementById("<%= txtUserToDate.ClientID %>").value = '';
            }
        }

        function onErrorLeaves(result) {

        }

        function getLeavedetails() {
            var ddlUser = document.getElementById("<%= ddlUserLeaves.ClientID %>");
            var index = ddlUser.selectedIndex;
            if (index > 0) {
                var Code = ddlUser.options[index].text.substring(0, 3);

                PageMethods.GetLeaveDetails(Code, OnSucceededDetails, onErrorDetails)
            }
        }


    </script>
    <script id="events">
        function onuserclick() {
            var ddlUser = document.getElementById("users");
            var index = ddlUser.selectedIndex;

            if (index > 0) {
                var Code = ddlUser.options[index].text.substring(0, 3);
                PageMethods.GetLeaveDetails(Code, OnSucceededDetails, onErrorDetails)
            }
        }

        function OnSucceededDetails(result) {
            if (result != "") {
                var xmlDoc = $.parseXML(result);
                var xml = $(xmlDoc);
                var leavetable = xml.find("Leavetable");
                $(leavetable).each(function () {
                    document.getElementById("<%= lblTotalLeavesPM.ClientID %>").innerHTML = $(this).find("TotalLeaves").text();
                    document.getElementById("<%= lblAppliedLeavesPM.ClientID %>").innerHTML = $(this).find("AppliedLeaves").text();
                    document.getElementById("<%= lblPendingLeavesPM.ClientID %>").innerHTML = $(this).find("PendingLeaves").text();
                });
                document.getElementById("<%= ddlPaidUnpaid.ClientID %>").disabled = false;
                document.getElementById("<%= tblLeavesPM.ClientID %>").style.display = '';
            }
            else {
                document.getElementById("<%= ddlPaidUnpaid.ClientID %>").disabled = true;
                document.getElementById("<%= tblLeavesPM.ClientID %>").style.display = 'none';
            }
        }
        function onErrorDetails() {

        }

    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hdLeaveID" runat="server" />
    <asp:HiddenField ID="hdDays" runat="server" />
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Employee Leaves</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12" id="mainleaveuser">
        <div class="card">
            <div class="card-body">
                <h5 class="card-title"></h5>
                <div>
                    <table class="table" id="Table1" runat="server">
                        <tr>
                            <td><b>Code:</b>
                            </td>
                            <td>
                                <select id="users" name="users" class="form-control" style="width: 250px;" onchange="onuserclick();">
                                    <option value="">Select</option>
                                </select>
                                <asp:DropDownList ID="ddlUserLeaves" runat="server" CssClass="form-control" Width="360px" onchange="getLeavedetails();" Style="display: none;"></asp:DropDownList>
                                <%--OnSelectedIndexChanged="ddlUserLeaves_SelectedIndexChanged"--%>
                            </td>
                            <td><b>Inform Type:</b></td>
                            <td>
                                <select id="leavetype" name="leavetype" class="form-control" style="width: 250px;" required>
                                    <option value="">Select</option>
                                    <option value="Inform On CallSMS">Inform On CallSMS</option>
                                    <option value="Inform By Other Person">Inform By Other Person</option>
                                    <option value="ByEmail">By Email</option>
                                    <option value="Other">Other</option>
                                </select>
                                <asp:DropDownList ID="ddlUserLeaveType" CssClass="form-control" Width="360px" Style="display: none;" runat="server">
                                    <asp:ListItem Value="">Select</asp:ListItem>
                                    <asp:ListItem Value="Inform On CallSMS">Inform On Call/SMS</asp:ListItem>
                                    <asp:ListItem Value="Inform By Other Person">Inform By Other Person</asp:ListItem>
                                    <asp:ListItem Value="ByEmail">By Email</asp:ListItem>
                                    <asp:ListItem Value="Other">Other</asp:ListItem>
                                    <%-- <asp:ListItem Value="MaternityPaternity">Maternity/Paternity</asp:ListItem>
                                                        <asp:ListItem Value="Marriage">Marriage</asp:ListItem>
                                    --%>
                                </asp:DropDownList>
                            </td>
                            <td rowspan="4" id="tblLeavesPM" class="text-left mb-2" runat="server" style="display: none;">
                                <b>Total appliable leaves:</b>

                                <asp:Label ID="lblTotalLeavesPM" runat="server" Text="-"></asp:Label>
                                <hr />
                                <b>Applied leaves:</b>

                                <asp:Label ID="lblAppliedLeavesPM" runat="server" Text="-"></asp:Label>
                                <hr />
                                <b>Pending leaves:</b>

                                <asp:Label ID="lblPendingLeavesPM" runat="server" Text="-"></asp:Label>
                                <hr />
                            </td>
                        </tr>

                        <tr>
                            <td><b>Days:</b></td>
                            <td>
                                <select id="days" name="days" class="form-control" style="width: 250px;" onchange="return GetLeavesToDate();" required>
                                    <option value="">Select</option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="6">6</option>
                                    <option value="7">7</option>
                                    <option value="8">8</option>
                                    <option value="9">9</option>
                                    <option value="10">10</option>
                                    <option value="11">11</option>
                                    <option value="12">12</option>
                                    <option value="13">13</option>
                                    <option value="14">14</option>
                                    <option value="15">15</option>
                                    <option value="16">16</option>
                                    <option value="17">17</option>
                                    <option value="18">18</option>
                                    <option value="19">19</option>
                                    <option value="20">20</option>
                                </select>
                                <asp:DropDownList ID="ddlUserDays" CssClass="form-control" Width="360px" runat="server" Style="display: none;" onchange="return GetLeavesToDate();">
                                    <asp:ListItem Value="">Select</asp:ListItem>
                                    <asp:ListItem Value="1">1</asp:ListItem>
                                    <asp:ListItem Value="2">2</asp:ListItem>
                                    <asp:ListItem Value="3">3</asp:ListItem>
                                    <asp:ListItem Value="4">4</asp:ListItem>
                                    <asp:ListItem Value="5">5</asp:ListItem>
                                    <asp:ListItem Value="6">6</asp:ListItem>
                                    <asp:ListItem Value="7">7</asp:ListItem>
                                    <asp:ListItem Value="8">8</asp:ListItem>
                                    <asp:ListItem Value="9">9</asp:ListItem>
                                    <asp:ListItem Value="10">10</asp:ListItem>
                                    <asp:ListItem Value="11">11</asp:ListItem>
                                    <asp:ListItem Value="12">12</asp:ListItem>
                                    <asp:ListItem Value="13">13</asp:ListItem>
                                    <asp:ListItem Value="14">14</asp:ListItem>
                                    <asp:ListItem Value="15">15</asp:ListItem>
                                    <asp:ListItem Value="16">16</asp:ListItem>
                                    <asp:ListItem Value="17">17</asp:ListItem>
                                    <asp:ListItem Value="18">19</asp:ListItem>
                                    <asp:ListItem Value="20">20</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td><b>Date Range:</b></td>
                            <td>
                                <asp:TextBox ID="txtUserFromDate" runat="server" Width="113px" required CssClass="form-control" ReadOnly="true" placeholder="From Date" onchange="return GetLeavesToDate();" Style="display: inline!important"></asp:TextBox>
                                <asp:ImageButton ID="ImgBtnFrom" ImageUrl="../Images/calender.png" Width="20px" Height="25px" ImageAlign="AbsMiddle" runat="server" />
                                <asp:CalendarExtender ID="CalendarExtender2" PopupButtonID="ImgBtnFrom" runat="server" TargetControlID="txtUserFromDate" Format="dd-MMM-yyyy"></asp:CalendarExtender>
                                &nbsp;&nbsp;&nbsp;
                <asp:TextBox ID="txtUserToDate" runat="server" Width="113px" required CssClass="form-control" ReadOnly="true" placeholder="To Date" Style="display: inline!important"></asp:TextBox>
                                <asp:ImageButton ID="imgBtnTo" ImageUrl="../Images/calender.png" Width="20px" Enabled="false" Height="25px" ImageAlign="AbsMiddle" runat="server" />
                                <%-- <asp:CalendarExtender ID="CalendarExtender3" PopupButtonID="imgBtnTo" runat="server" TargetControlID="txtUserToDate" Format="dd-MMM-yyyy"></asp:CalendarExtender>--%>
                            </td>
                        </tr>

                        <tr id="trpaid" runat="server">
                            <td><b>Paid/Unpaid?:</b></td>
                            <td>
                                <select id="paidunpaid" name="paidunpaid" class="form-control" style="width: 250px;" required>
                                    <option value="">Select</option>
                                    <option value="Paid">Paid</option>
                                    <option value="Unpaid">Unpaid</option>
                                </select>
                                <asp:DropDownList ID="ddlPaidUnpaid" runat="server" CssClass="form-control" Width="360px" Style="display: none;">
                                    <asp:ListItem Value="">Select</asp:ListItem>
                                    <asp:ListItem Value="Paid">Paid</asp:ListItem>
                                    <asp:ListItem Value="Unpaid">Unpaid</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td valign="top"><b>Reason:</b></td>
                            <td>
                                <textarea id="reason" name="reason" class="form-control" style="width: 250px;" required></textarea>
                                <asp:TextBox ID="txtUserReason" runat="server" TextMode="MultiLine" CssClass="form-control" Height="50px" Width="360px" Style="border-radius: 4px; resize: none; display: none;"></asp:TextBox>

                            </td>

                        </tr>
                        <tr>
                            <td valign="center" colspan="4" class="text-center">
                                <button class="btn btn-primary" onclick="submitdata();">Submit</button>
                                <asp:Button ID="btnUserLeaves" runat="server" Text="Submit" CssClass="btn btn-primary" OnClick="btnUserLeaves_Click" Style="display: none;" />

                            </td>
                        </tr>
                    </table>
                    <script>
                        function submitdata() {
                            var user = document.getElementById("users");
                            var code = user.options[user.selectedIndex].text.substring(0, 3);
                            var leavetye = document.getElementById("leavetype");
                            var type = leavetype.options[leavetype.selectedIndex].value;
                            var fromdate = document.getElementById("<%= txtUserFromDate.ClientID %>").value;
                            var todate = document.getElementById("<%= txtUserToDate.ClientID %>").value;
                            var days = document.getElementById("days");
                            var noofdays = days.options[days.selectedIndex].text;
                            var paid = document.getElementById("paidunpaid");
                            var paidstatus = paid.options[paid.selectedIndex].text;
                            var remark = document.getElementById("reason").value;

                            if (paidstatus == "Paid") {
                                var currentpendingleave = document.getElementById("<%= lblPendingLeavesPM.ClientID %>").innerHTML;
                                if (parseInt(currentpendingleave) < parseInt(noofdays)) {
                                    alert("Selected employee does not have sufficient paid leaves. Please change no of days");
                                    return;
                                }
                            }
                            if (todate == "") {
                                alert("System unable to collect 'To Date'. Please select 'From Date' again.");
                                return;
                            }
                            if (remark == "") {
                                alert("Please enter reason.");
                                return;
                            }
                            $('#waitingpanel').modal('show');
                            PageMethods.InsertLeave(code, noofdays, fromdate, todate, remark, type, paidstatus, OnSuccess, OnError);
                        }
                        function OnSuccess(result) {
                            $('#waitingpanel').modal('hide');
                            alert('Leave added successfully!');
                            location.reload();
                        }
                        function OnError(result) {
                        }
                    </script>
                </div>
                <hr />
                <table class="table" id="Leaves" style="padding-top: 10px; width: 100%;">
                    <thead>
                        <tr>
                            <th style="display: none;"></th>
                            <th style="display: none;"></th>
                            <th class="sort border-top ps-3">Actions</th>
                            <th class="sort border-top ps-3">Code</th>
                            <th class="sort border-top ps-3">Leave Type</th>
                            <th class="sort border-top ps-3"># of days</th>
                            <th class="sort border-top ps-3">From Date</th>
                            <th class="sort border-top ps-3">To Date</th>
                            <th class="sort border-top ps-3" width="200px">Reason</th>
                            <th class="sort border-top ps-3">Status</th>
                            <th style="display: none;"></th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>

                <div class="modal fade" id="leaveapprovalrejection">
                    <div class="modal-dialog modal-xl">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h4 class="modal-title">Approve/ Reject Leave</h4>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">

                                <table class="table table-responsive">
                                    <tr>
                                        <td><b>Code:</b></td>
                                        <td>
                                            <input class="form-control" id="UserCode" value="Code" style="width: 300px;" />
                                        </td>

                                        <td><b>Leave Type:</b></td>
                                        <td>
                                            <input class="form-control" id="LeaveType" style="width: 300px;" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><b>Date Range:</b></td>
                                        <td>
                                            <input class="form-control" id="DateRange" style="width: 300px;" />
                                            <input class="form-control" id="Fordays" style="display: none;" />
                                        </td>

                                        <td><b>Reason:</b></td>
                                        <td>
                                            <textarea class="form-control" id="Reason" style="width: 300px;"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><b>Action:</b></td>
                                        <td>
                                            <select name="ddaction" required id="ddaction" class="form-control" onchange="changebuttontext();" style="width: 300px;">
                                                <option value="">Select</option>
                                                <option value="Approve">Approve</option>
                                                <option value="Reject">Reject</option>
                                            </select>
                                        </td>
                                        <td><b>Comments:</b></td>
                                        <td>
                                            <textarea name="comments" id="comments" class="form-control" style="width: 300px;"></textarea>
                                        </td>

                                    </tr>
                                    <tr>
                                        <td id="leavestatus"><b>Status:</b></td>
                                        <td id="leavestatusrow">
                                            <select name="ddlLeaveStatus" id="ddlLeaveStatus" class="form-control" style="width: 300px;">
                                                <option value="">Select</option>
                                                <option value="Paid">Paid</option>
                                                <option value="Unpaid">Unpaid</option>
                                            </select>
                                        </td>

                                    </tr>
                                </table>
                            </div>
                            <div class="modal-footer justify-content-between">
                                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                <button class="btn btn-primary" type="button" id="btnApprove" onclick="SubmitAction();">Okay</button>
                            </div>
                        </div>
                        <!-- /.modal-content -->
                    </div>
                    <!-- /.modal-dialog -->
                </div>

                <div class="modal fade" id="leaveentendshorten">
                    <div class="modal-dialog modal-xl">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h4 class="modal-title">Extend/Shorten Leave</h4>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                <table class="table">
                                    <tr>
                                        <td><b>Code:</b></td>
                                        <td>
                                            <input class="form-control" id="UserCodeEx" style="width: 300px;" />
                                        </td>

                                        <td><b>Leave Type:</b></td>
                                        <td>
                                            <input class="form-control" id="LeaveTypeEx" style="width: 300px;" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><b>Reason:</b></td>
                                        <td>
                                            <textarea class="form-control" id="ReasonEx" style="width: 300px;"></textarea>
                                        </td>

                                        <td><b>Action:</b></td>
                                        <td>
                                            <select name="ddactionEx" required id="ddactionEx" class="form-control" onchange="changebuttontextEx();" style="width: 300px;">
                                                <option value="">Select</option>
                                                <option value="Extend">Extend</option>
                                                <option value="Shorten">Shorten</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><b>Days:</b></td>
                                        <td>
                                            <select name="daysEx" id="daysEx" class="form-control" onchange="GetLeavesToDateEx();" style="width: 300px;">
                                            </select>
                                        </td>

                                        <td><b>Date Range:</b></td>
                                        <td>
                                            <input class="form-control" id="DateRangeFromEx" style="display: inline; width: 150px;" />
                                            &nbsp;&nbsp;<input class="form-control" id="DateRangeToEx" style="display: inline; width: 150px;" />
                                        </td>
                                    </tr>


                                    <tr>
                                        <td><b>Comments:</b></td>
                                        <td>
                                            <textarea name="commentsEx" id="commentsEx" class="form-control" style="width: 300px;"></textarea>
                                        </td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                </table>
                            </div>
                            <div class="modal-footer justify-content-between">
                                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                <button class="btn btn-primary" type="button" id="btnApproveEx" onclick="SubmitActionEx();">Okay</button>
                            </div>
                        </div>
                        <!-- /.modal-content -->
                    </div>
                    <!-- /.modal-dialog -->
                </div>

                <div class="modal fade" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-labelledby="waitingLabel" aria-hidden="true">
                    <div class="modal-dialog text-center">
                        <img src="../Images/Load.gif" />
                        <br />
                        <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;">Updating leave status and sending notifications. Please wait</span>
                        <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
                    </div>
                </div>

                <div class="modal fade" id="Cancelleave">
                    <div class="modal-dialog modal-l">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h4 class="modal-title">Cancel Leave</h4>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">

                                <p>Are you sure you want to cancel leave?</p>

                            </div>
                            <div class="modal-footer justify-content-between">
                                <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
                                <button class="btn btn-primary" type="button" id="btnYes" onclick="SubmitActionCancel();">Yes</button>
                            </div>
                        </div>
                        <!-- /.modal-content -->
                    </div>
                    <!-- /.modal-dialog -->
                </div>


            </div>
        </div>
    </div>
</asp:Content>
