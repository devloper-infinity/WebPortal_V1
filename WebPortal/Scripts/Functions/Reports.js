var newjoineetable;
var newjoinee_html;
var attritiontable;
var attrition_html;
var excludetable;
var exclude_html;
var table_empveri = '';

var abscondleavelist;
var ableave_html;

var totalleavelist;
var leaveab_html;

function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

function BindYear_NewJoin() {
    var start = new Date().getFullYear();

    var select = document.getElementById("newjoin_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#newjoin_year").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#newjoin_year").append($("<option></option>").val(i).html(i));
    }
}

function BindYear_Attrition() {
    var start = new Date().getFullYear();

    var select = document.getElementById("attrition_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#attrition_year").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#attrition_year").append($("<option></option>").val(i).html(i));
    }
}

function newjoin_Submit() {
    //var ddlmonth = document.getElementById("newjoin_month");
    //var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    //var ddlyear = document.getElementById("newjoin_year");
    //var year = ddlyear.options[ddlyear.selectedIndex].value;
    var month = document.getElementById("newjoin_from").value;
    var year = document.getElementById("newjoin_to").value;
    if (month == "") {
        alert("Please select from date");
        return false;
    }
    if (year == "") {
        alert("Please select to date");
        return false;
    }
    $('#load1').show();
    newjoinee_html = '';
    $.ajax({
        url: "NewJoineeReport.aspx/GetNewJoineeReport",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                newjoinee_html += '<tr>';
                newjoinee_html += '<td>' + blankForNull(value.Code) + '</td>';
                newjoinee_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.EmployeeName) + '</td>';
                newjoinee_html += '<td>' + blankForNull(value.JoiningDate) + '</td>';
                newjoinee_html += '<td>' + blankForNull(value.BranchName) + '</td>';
                newjoinee_html += '<td>' + blankForNull(value.DepartmentName) + '</td>';
                newjoinee_html += '<td>' + blankForNull(value.DesignationName) + '</td>';
                newjoinee_html += '<td>' + blankForNull(value.ReportingManager) + '</td>';
                newjoinee_html += '<td>' + blankForNull(value.DomainHead) + '</td>';
                newjoinee_html += '<td>' + blankForNull(value.Domain) + '</td>';
                newjoinee_html += '<td>' + blankForNull(value.Subdomain) + '</td>';
                newjoinee_html += '<td>' + blankForNull(value.Tenure) + '</td>';
                newjoinee_html += '<td>' + blankForNull(value.LatestLoginDate) + '</td>';
                newjoinee_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#newjoineetable')) {
                newjoineetable.destroy();
            }
            $('#newjoineetable tbody').html(newjoinee_html);
            //else
            newjoineetable = $('#newjoineetable').DataTable({
                dom: 'lftip',
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
                "rowCallback": function (row, data) {
                    var val = data[3];
                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: 'New Joinee Report', autoFilter: true,
                        exportOptions: {
                            columns: [0, 1, 2, 3, 4, 5, 6]
                        }
                    },
                ],
            });
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}

function attrition_Submit() {
    var month = document.getElementById("attrition_from").value;
    var year = document.getElementById("attrition_to").value;
    var ddldomain = document.getElementById("attrition_domain");
    var domain = ddldomain.options[ddldomain.selectedIndex].value;
    if (domain == "")
        domain = 0;
    if (month == "") {
        alert("Please select from date");
        return false;
    }
    if (year == "") {
        alert("Please select to date");
        return false;
    }
    $('#load1').show();
    attrition_html = '';
    AttritionDetails(month, year, domain);

    return false;
}

function bindexcludedemployees() {
    var month = document.getElementById("attrition_from").value;
    var year = document.getElementById("attrition_to").value;
    var ddldomain = document.getElementById("attrition_domain");
    var domain = ddldomain.options[ddldomain.selectedIndex].value;
    if (domain == "")
        domain = 0;
    if (month == "") {
        alert("Please select from date");
        return false;
    }
    if (year == "") {
        alert("Please select to date");
        return false;
    }
    $('#load1').show();
    exclude_html = '';
    $.ajax({
        url: "AttritionReport.aspx/GetAllExcludedEmployees",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "', DomainID:" + domain + "}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                exclude_html += '<tr>';
                exclude_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Code) + '</td>';
                exclude_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Name) + '</td>';
                exclude_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Pseudoname) + '</td>';
                exclude_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.JoiningDate) + '</td>';
                exclude_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Branch) + '</td>';
                exclude_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Domain) + '</td>';
                exclude_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Subdomain) + '</td>';
                exclude_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Department) + '</td>';
                exclude_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Designation) + '</td>';
                exclude_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ReportingManager) + '</td>';
                exclude_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Tenure) + '</td>';
                exclude_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.CurrentStatus) + '</td>';
                exclude_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ResignationDate) + '</td>';
                exclude_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.LastWorkingDate) + '</td>';
                exclude_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.PMSystemRemark) + '</td>';
                exclude_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.DomainHeadRemark) + '</td>';
                exclude_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Category) + '</td>';
                exclude_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.RemarkforExclusion) + '</td>';
                exclude_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#excludetable')) {
                excludetable.destroy();
            }
            $('#excludetable tbody').html(exclude_html);
            //else
            excludetable = $('#excludetable').DataTable({
                dom: 'lftip',
                destroy: true,
                scrollX: true,
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

                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                    $(nRow).children("td").css("text-align", "center");
                },
            });
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
}

function attrition1_Submit() {
    $('#load1').show();
    var columns = [];
    var month = document.getElementById("attrition_from").value;
    var year = document.getElementById("attrition_to").value;
    var ddldomain = document.getElementById("attrition_domain");
    var domain = ddldomain.options[ddldomain.selectedIndex].value;
    if (domain == "")
        domain = 0;
    if (month == "") {
        alert("Please select from date");
        return false;
    }
    if (year == "") {
        alert("Please select to date");
        return false;
    }

    return false;
}

function att_excludeuser(EmployeeID, Index) {
    $.ajax({
        url: "AttritionReport.aspx/GetDetailsForExcludeRemark",
        type: "POST",
        data: "{EmployeeID:" + EmployeeID + "}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                document.getElementById("attpop_empname").innerHTML = blankForNull(value.Code) + " : " + blankForNull(value.FirstName) + " " + blankForNull(value.lastName);
                document.getElementById("attpop_doj").innerHTML = blankForNull(value.JoiningDate);
                document.getElementById("attpop_reportingmanager").innerHTML = blankForNull(value.ReportingManager);
                document.getElementById("attpop_resignationtype").innerHTML = blankForNull(value.ResignationType);
                document.getElementById("attpop_resignationdate").innerHTML = blankForNull(value.ResignationDate);
                document.getElementById("attpop_lastworkingdate").innerHTML = blankForNull(value.LastWorkingDate);
                document.getElementById("attpop_step1remark").innerHTML = blankForNull(value.Step1Remark);
                document.getElementById("attpop_step2remark").innerHTML = blankForNull(value.UnitHeadRemark);
                document.getElementById("attpop_step3remark").innerHTML = blankForNull(value.HRRemark);
            });
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });

    $("#attexclude").modal("show");
}

function attpop_Addexcluderemark() {
    var code = document.getElementById("attpop_empname").innerHTML.substring(0, 3);
    var remark = document.getElementById("attpop_reasontoexclude").value;
    var resgdate = document.getElementById("attpop_resignationdate").innerHTML;
    if (remark == "") {
        alert("Please enter reason to exclude.");
        return;
    }
    PageMethods.InsertAttritioNRemark(code, remark, resgdate, att_sub_OnSuccess, att_sub_OnError);
    return false;

}

function att_sub_OnSuccess(result) {
    if (result > 0) {
        document.getElementById("attpop_reasontoexclude").value = "";
        $('#attexclude').modal('hide');
        alert("Reason updated successfully.");
        attrition_Submit();
        return false;
    }
    else {
        document.getElementById("attpop_reasontoexclude").value = "";
        $('#attexclude').modal('hide');
        alert("User record already exists.");
        return false;
    }
    return false;
}

function att_sub_OnError(error) {
    alert(error.responseText);
}

function AttritionDetails(month, year, domain) {
    $.ajax({
        url: "AttritionReport.aspx/GetAttritionReport",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "', DomainID:" + domain + "}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);// 

            $.each(dataArray, function (index, value) {
                attrition_html += '<tr>';
                attrition_html += '<td style="text-align:center;"><a class="dropdown-item" href="#!" id="Actions" onclick="att_excludeuser(' + value.EmployeeID + ',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-pen"></i></span></a></td>';
                attrition_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Month) + '</td>';
                attrition_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Year) + '</td>';
                attrition_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Code) + '</td>';
                attrition_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Name) + '</td>';
                attrition_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Pseudoname) + '</td>';
                attrition_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.JoiningDate) + '</td>';
                attrition_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Branch) + '</td>';
                attrition_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Domain) + '</td>';
                attrition_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Subdomain) + '</td>';
                attrition_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Department) + '</td>';
                attrition_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Designation) + '</td>';
                attrition_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ReportingManager) + '</td>';
                attrition_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.DomainHead) + '</td>';
                attrition_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.LocationHead) + '</td>';
                attrition_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Tenure) + '</td>';
                attrition_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.CurrentStatus) + '</td>';
                attrition_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ResignationDate) + '</td>';
                attrition_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.LastWorkingDate) + '</td>';
                attrition_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.PMSystemRemark) + '</td>';
                attrition_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.DomainHeadRemark) + '</td>';
                attrition_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Category) + '</td>';
                attrition_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.AttritionCost) + '</td>';
                attrition_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#attritiontable')) {
                attritiontable.destroy();
            }
            $('#attritiontable tbody').html(attrition_html);
            //else
            attritiontable = $('#attritiontable').DataTable({
                dom: 'lftip',
                destroy: true,
                // scrollX: true,
                "paging": true,
                "autoWidth": false,
                select: true,
                "ordering": false,
                processing: true,
                'select': {
                    'style': 'single'
                },
                initComplete: function () {

                    $('#load1').hide();
                    AttritionMonth(month, year, domain);

                },

                "rowCallback": function (row, data) {
                    var val = data[3];
                },

                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                    // $(nRow).children("td").css("text-align", "center");
                },
            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
}

function AttritionMonth(month, year, domain) {

    var columns = [];
    $.ajax({
        url: "AttritionReport.aspx/GetAttritionSummary_Month",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "', DomainID:" + domain + "}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//

            $.each(dataArray[0], function (key, value) {
                var my_item = {};
                my_item.data = key;
                my_item.title = key;
                columns.push(my_item);
            });

            $('#attrition_monthsummary').DataTable({
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
                "data": dataArray,
                "columns": columns,

                initComplete: function () {

                    AttritionLocation(month, year, domain);
                },

                "rowCallback": function (row, data) {
                    var val = data[3];
                },

                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                    $(nRow).children("td").css("text-align", "center");
                },
            });
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
}

function AttritionLocation(month, year, domain) {
    var columns = [];
    $.ajax({
        url: "AttritionReport.aspx/GetAttritionSummary_Location",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "', DomainID:" + domain + "}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray[0], function (key, value) {
                var my_item = {};
                my_item.data = key;
                my_item.title = key;
                columns.push(my_item);
            });
            $('#attrition_locationsummary').DataTable({
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
                "data": dataArray,
                "columns": columns,

                initComplete: function () {
                    AttritionDomain(month, year, domain);
                },
                "rowCallback": function (row, data) {
                    var val = data[3];
                },
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                    $(nRow).children("td").css("text-align", "center");
                },
            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
}

function AttritionDomain(month, year, domain) {
    var columns = [];
    $.ajax({
        url: "AttritionReport.aspx/GetAttritionSummary_Domain",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "', DomainID:" + domain + "}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray[0], function (key, value) {
                var my_item = {};
                my_item.data = key;
                my_item.title = key;
                columns.push(my_item);
            });
            $('#attrition_domainsummary').DataTable({
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
                "data": dataArray,
                "columns": columns,

                initComplete: function () {
                    AttritionCategory(month, year, domain);
                },
                "rowCallback": function (row, data) {
                    var val = data[3];
                },
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                    $(nRow).children("td").css("text-align", "center");
                },
            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
}

function AttritionCategory(month, year, domain) {
    var columns = [];
    $.ajax({
        url: "AttritionReport.aspx/GetAttritionSummary_Category",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "', DomainID:" + domain + "}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray[0], function (key, value) {
                var my_item = {};
                my_item.data = key;
                my_item.title = key;
                columns.push(my_item);
            });
            $('#attrition_categorysummary').DataTable({
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
                "data": dataArray,
                "columns": columns,

                initComplete: function () {
                    AttritionDomainHead(month, year, domain);
                },
                "rowCallback": function (row, data) {
                    var val = data[3];
                },
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                    $(nRow).children("td").css("text-align", "center");
                },
            });
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
}

function AttritionDomainHead(month, year, domain) {
    var columns = [];
    $.ajax({
        url: "AttritionReport.aspx/GetAttritionSummary_DomainHead",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "', DomainID:" + domain + "}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray[0], function (key, value) {
                var my_item = {};
                my_item.data = key;
                my_item.title = key;
                columns.push(my_item);
            });
            $('#attrition_domainheadsummary').DataTable({
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
                "data": dataArray,
                "columns": columns,

                initComplete: function () {
                    AttritionLocationHead(month, year, domain);
                },
                "rowCallback": function (row, data) {
                    var val = data[3];
                },
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                    $(nRow).children("td").css("text-align", "center");
                },
            });
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
}

function AttritionLocationHead(month, year, domain) {
    var columns = [];
    $.ajax({
        url: "AttritionReport.aspx/GetAttritionSummary_LocationHead",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "', DomainID:" + domain + "}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray[0], function (key, value) {
                var my_item = {};
                my_item.data = key;
                my_item.title = key;
                columns.push(my_item);
            });
            $('#attrition_locationheadsummary').DataTable({
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
                "data": dataArray,
                "columns": columns,

                initComplete: function () {
                    $('#load1').hide();
                },
                "rowCallback": function (row, data) {
                    var val = data[3];
                },
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                    $(nRow).children("td").css("text-align", "center");
                },
            });
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
}

function BindYear_AbscondingLeave() {
    var start = new Date().getFullYear();

    var select = document.getElementById("ableave_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#ableave_year").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#ableave_year").append($("<option></option>").val(i).html(i));
    }
}

function ableave_Submit() {
    BindAbscondingGrid();
    BindTotalLeaveGrid();
    return false;
}

var abscondleavelist;
var totalleavelist;

function BindAbscondingGrid() {

    var month = $("#ableave_month").val();
    var year = $("#ableave_year").val();

    if (!month) {
        Swal.fire("Validation", "Please select month.", "warning");
        return false;
    }

    if (!year) {
        Swal.fire("Validation", "Please select year.", "warning");
        return false;
    }

    $('#load1').show();

    $.ajax({
        url: "AbscondingAndLeaveReport.aspx/GetTotalAbsconingEmployees",
        type: "POST",
        data: JSON.stringify({
            Month: month,
            Year: year
        }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (res) {

            var dataArray = JSON.parse(res.d || "[]");

            if ($.fn.DataTable.isDataTable('#abscondleavelist')) {
                abscondleavelist.clear().rows.add(dataArray).draw();
                $('#load1').hide();
                return;
            }

            abscondleavelist = $('#abscondleavelist').DataTable({
                data: dataArray,
                dom: 'lftip',
                paging: true,
                autoWidth: true,
                ordering: false,
                processing: true,
                destroy: true,
                select: {
                    style: 'single'
                },
                columns: [
                    { title: "Code", data: "Code", render: blankForNull },
                    { title: "Name", data: "Name", render: blankForNull },
                    { title: "Joining Date", data: "JoiningDate", render: blankForNull },
                    { title: "Branch", data: "Branch", render: blankForNull },
                    { title: "Domain", data: "Domain", render: blankForNull },
                    { title: "Sub Domain", data: "Subdomain", render: blankForNull },
                    { title: "Reporting Manager", data: "ReportingManager", render: blankForNull },
                    { title: "Domain Head", data: "DomainHead", render: blankForNull },
                    { title: "Tenure", data: "Tenure", render: blankForNull },
                    { title: "Current Status", data: "CurrentStatus", render: blankForNull },
                    { title: "Resignation Date", data: "ResignationDate", render: blankForNull },
                    { title: "Last Working Date", data: "LastWorkingDate", render: blankForNull },
                    { title: "Remark", data: "Remark", render: blankForNull },
                    { title: "Absconded Date", data: "AbscondedDate", render: blankForNull },
                    {
                        title: "Latest Login Date",
                        data: "LatestLoginDate",
                        render: blankForNull,
                        visible: false
                    }
                ],
                columnDefs: [{
                    targets: "_all",
                    className: "text-nowrap"
                }],
                initComplete: function () {
                    $('#load1').hide();
                }
            });
        },

        error: function (xhr) {
            $('#load1').hide();

            Swal.fire({
                icon: "error",
                title: "Error",
                text: xhr.responseText || "Unable to load absconding report."
            });
        }
    });

    return false;
}

function blankForNull(data) {
    return data === null || data === undefined ? "" : data;
}

function BindTotalLeaveGrid() {

    var month = $("#ableave_month").val();
    var year = $("#ableave_year").val();

    if (!month) {
        Swal.fire("Validation", "Please select month.", "warning");
        return false;
    }

    if (!year) {
        Swal.fire("Validation", "Please select year.", "warning");
        return false;
    }

    $("#load1").show();

    $.ajax({
        url: "AbscondingAndLeaveReport.aspx/GetTotalLeaves",
        type: "POST",
        data: JSON.stringify({
            Month: month,
            Year: year
        }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (res) {

            var dataArray = JSON.parse(res.d || "[]");

            if ($.fn.DataTable.isDataTable("#totalleavelist")) {
                totalleavelist.clear().rows.add(dataArray).draw();
                $("#load1").hide();
                return false;
            }

            totalleavelist = $("#totalleavelist").DataTable({
                data: dataArray,
                dom: "lftip",
                paging: true,
                autoWidth: false,
                ordering: false,
                processing: true,
                destroy: true,
                select: {
                    style: "single"
                },

                columns: [
                    { title: "Code", data: "Code", render: blankForNull },
                    { title: "Name", data: "Name", render: blankForNull },
                    { title: "Joining Date", data: "JoiningDate", render: blankForNull },
                    { title: "Branch", data: "Branch", render: blankForNull },
                    { title: "Domain", data: "Domain", render: blankForNull },
                    { title: "Sub Domain", data: "Subdomain", render: blankForNull },
                    { title: "Reporting Manager", data: "ReportingManager", render: blankForNull },
                    { title: "Domain Head", data: "DomainHead", render: blankForNull },
                    { title: "For Days", data: "ForDays", render: blankForNull },
                    { title: "Leave From", data: "LeaveFrom", render: blankForNull },
                    { title: "Leave To", data: "LeaveTo", render: blankForNull },
                    { title: "Reason For Leave", data: "ReasonForLeave", render: blankForNull },
                    { title: "Added By", data: "AddedBy", render: blankForNull },
                    { title: "Added Date", data: "AddedDate", render: formatDotNetDate },
                    { title: "Leave Status", data: "LeaveStatus", render: blankForNull },
                    { title: "Approved By", data: "ApprovedBy", render: blankForNull },
                    { title: "Approval Remark", data: "ApprovalRemark", render: blankForNull },
                    { title: "Approved Date", data: "ApprovedDate", render: formatDotNetDate }
                ],

                columnDefs: [{
                    targets: "_all",
                    className: "text-nowrap"
                }],

                initComplete: function () {
                    $("#load1").hide();
                }
            });
        },

        error: function (xhr) {
            $("#load1").hide();

            Swal.fire({
                icon: "error",
                title: "Error",
                text: xhr.responseText || "Unable to load leave report."
            });
        }
    });

    return false;
}

function formatDotNetDate(data) {
    if (!data) return "";

    var timestamp = parseInt(data.toString().replace(/[^0-9]/g, ""), 10);

    if (isNaN(timestamp)) {
        return data;
    }

    return new Date(timestamp).toLocaleDateString("en-US");
}

function attrition_binddomains() {
    var select = document.getElementById("attrition_domain");
    var options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#attrition_domain").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "AttritionReport.aspx/GetDomainsAsPerEmp", dataType: "json", contentType: "application/json",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {

                $("#attrition_domain").append($("<option></option>").val(value.DomainID).html(value.DomainName));
            })
        }
    });
}

function EmployeeInformationDetails() {
    $('#load1').show();

    var table_empveri = '';

    $.ajax({
        url: "EmployeeInformation.aspx/GetAllEmployeeInformation",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            table_empveri = $('#empveri_table').DataTable({
                dom: 'Bftip',
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                paging: true,
                autoWidth: false,
                ordering: false,
                processing: true,
                filter: true,
                serverSide: false,
                select: {
                    style: 'single'
                },

                data: dataArray,

                fixedColumns: {
                    leftColumns: 3   // Sr.No + first 3 columns
                },

                columns: [
                    // {
                    //     data: null,
                    //     render: function (data, type, row, meta) {
                    //         return meta.row + 1;
                    //     }
                    // },
                    {
                        data: null,
                        render: function (data, type, row, meta) {
                            return meta.settings._iDisplayStart + meta.row + 1;
                        }
                    },
                    { data: 'Code' },
                    { data: 'Name' },
                    { data: 'Salary' },
                    { data: 'JoiningDate' },
                    { data: 'DateOfBirth' },
                    { data: 'Branch' },
                    { data: 'Domain' },
                    { data: 'Subdomain' },
                    { data: 'Process' },
                    { data: 'Department' },
                    { data: 'Designation' },
                    { data: 'ReportingManager' },
                    { data: 'PresentAddress' },
                    { data: 'PermanentAddress' },
                    { data: 'ContactNo' },
                    { data: 'ESICNo' },
                    { data: 'PFNo' },
                    { data: 'UAN' },
                    { data: 'PersonalEmail' },
                    { data: 'OfficialEmailID' },
                    { data: 'CurrentStatus' },
                    { data: 'ResignationDate' },
                    { data: 'LastWorkingDate' },
                    { data: 'LatestLoginDate' }
                ],

                columnDefs: [
                    {
                        targets: '_all',
                        className: 'dt-nowrap'
                    },
                    {
                        targets: 0,
                        searchable: false,
                        orderable: false,
                        width: '60px'
                    }
                ],

                initComplete: function () {
                    $('#load1').hide();
                },

                buttons: [
                    {
                        extend: 'excelHtml5',
                        title: 'Employee Verification Details',
                        autoFilter: true
                    }
                ]
            });
        },

        error: function (error) {
            $('#load1').hide();
            alert('error; ' + error.responseText);
        }
    });

    var isSearch = 0;

    $('#empveri_table thead tr:eq(1) th').each(function () {
        if (isSearch === 1 || isSearch === 2) {
            var title = $(this).text();
            $(this).html(
                '<input type="text" placeholder="Search ' + title + '" class="column_search" />'
            );
        } else {
            $(this).html('');
        }
        isSearch++;
    });

    $('#empveri_table thead').on('keyup', ".column_search", function () {
        table_empveri
            .column($(this).parent().index())
            .search(this.value)
            .draw();
    });
}

function EmployeeInformationDetails_OLD() {
    $('#load1').show();

    var columns = [];
    $.ajax({
        url: "EmployeeInformation.aspx/GetAllEmployeeInformation",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray[0], function (key, value) {
                var my_item = {};
                my_item.data = key;
                my_item.title = key;
                columns.push(my_item);
            });
            $('#empveri_table').DataTable({
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
                "data": dataArray,
                "columns": columns,

                initComplete: function () {
                    $('#load1').hide();
                },
                "rowCallback": function (row, data) {
                    var val = data[3];
                },
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                    $(nRow).children("td").css("text-align", "center");
                },
            });
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });

    var isrch = 0;
    $('#empveri_table thead tr:eq(1) th').each(function () {
        if (isrch > 0 && isrch < 3) {
            var title = $(this).text();
            $(this).html('<input type="text" placeholder="Search ' + title + '" class="column_search" />');
        }
        else {
            $(this).html('');
        }
        isrch++;
    });

    $('#empveri_table thead').on('keyup', ".column_search", function () {
        $('#empveri_table thead').DataTable
            .column($(this).parent().index())
            .search(this.value)
            .draw();
    });
}
