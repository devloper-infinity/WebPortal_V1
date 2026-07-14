
/*------------- Other Billing Report ------------- */

var Research_table;
var Rebuttal_table;

function BindDomainWise_Project(DomainID) {

    var select = document.getElementById("otherBilling_Project");
    let options = select.getElementsByTagName('otherBilling_Project');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#otherBilling_Project").append($("<option></option>").val("Select").html("Select"));

    $.ajax({
        type: "POST", url: "OtherBilling.aspx/GetAllProjectByDomainWise", dataType: "json",
        data: "{DomainID:" + DomainID + "}",
        contentType: "application/json",
        success: function (res) {

            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {

                $("#otherBilling_Project").append($("<option></option>").val(value.ProjectId).html(value.ProjectName));
            })
        }
    });
}

function otherbil_bindDeals(ddlprojectId) {

    alert(ddlprojectId);

    var projectID = ddlprojectId.options[ddlprojectId.selectedIndex].value;

    alert(projectID);

    var Select = document.getElementById("otherBilling_DealNo");
    let options = Select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        Select.removeChild(options[i]);
    }

    $("#otherBilling_DealNo").append($("<option></option>").val("Select").html("Select"));

    $.ajax({
        type: "POST", url: "OtherBilling.aspx/GetAllDealNumber", dataType: "json",
        data: "{ProjectID:" + projectID + "}",
        contentType: "application/json",
        success: function (res) {

            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {

                $("#otherBilling_DealNo").append($("<option></option>").val(value.DealNo).html(value.DealNo));
            })
        }
    });
}

function btnOtherBilling_Import() {

    //$('#OtherBilling_Waitingpanel').modal('show');

    document.getElementById("spntext").innerHTML = "Reading data from excel . . . .";

    PageMethods.ImportExcel(import_OnSuccess, import_OnError);

    return false;
}

function import_OnSuccess(result) {

    if (result > 0) {

        $('#OtherBilling_Waitingpanel').modal('hide');

        var ddlProjectType = document.getElementById('otherBilling_ProjectType');
        var ProjectType = ddlProjectType.options[ddlProjectType.selectedIndex].value;

        document.getElementById("table_Research").style.display = "none";
        document.getElementById("table_Rebuttal").style.display = "none";

        if (ProjectType == "Research") {

            document.getElementById("table_Research").style.display = "";
            research_BindGrid();
        }
        if (ProjectType == 'Rebuttal') {

            document.getElementById("table_Rebuttal").style.display = "";
            rebuttal_BindGrid();
        }
    }
    else if (result == -1) {
        alert("Please select an Excel file with the .xlsx extension.");
    }
    else {
        alert("Something went wrong, Please contact administrator.");
    }
    return false;
}

function import_OnError(error) {
    alert(error.responseText);
    return false;
}

function btnOtherBilling_Verify() {

    var ddlProjectType = document.getElementById('otherBilling_ProjectType');
    var ProjectType = ddlProjectType.options[ddlProjectType.selectedIndex].value;

    var ddlProject = document.getElementById('otherBilling_Project');
    var Project = ddlProject.options[ddlProject.selectedIndex].value;

    var ddlDeal = document.getElementById('otherBilling_DealNo');
    var DealNo = ddlDeal.options[ddlDeal.selectedIndex].value;

    $('#OtherBilling_Waitingpanel').modal('show');
    document.getElementById("spntext").innerHTML = "Please wait… The system is verifying and submitting your data";

    PageMethods.VerifyAndSubmitData(ProjectType, Project, DealNo, verify_OnSuccess, verify_OnError);

    return false;
} 

function verify_OnSuccess(result) {

    $('#waitingpanel').modal('hide');

    if (result > 0) {

        $('#billingMessage').modal('show');

    }
    return false;
}

function verify_OnError(error) {
    alert(error.responseText);
    return false;
}

function research_BindGrid() {

    $('#OtherBilling_Waitingpanel').modal('hide');

    $('#load1').show();

    $.ajax({
        url: "OtherBilling.aspx/GetExcelDataToBindGrid",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);

            Research_table = $('#table_Research').DataTable({
                dom: 'ftip',
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                filter: true,
                'select': {
                    'style': 'single'
                },
                "serverSide": false,
                "data": dataArray,

                columns: [
                    /*  { data: 'SrNo' },*/
                    { data: 'Deal No' },
                    { data: 'Deal Name' },
                    { data: 'Subject Line' },
                    { data: 'No of Loans/Docs' },
                    { data: 'Requested Docs/Tasks Performed' },
                    { data: 'Total Time Taken (in Minutes)' },
                    { data: 'Request Received from' },
                    { data: 'Request Received Date' },
                    { data: 'Documents Delivered Date' },
                    { data: 'Remark' },
                    { data: 'Time (In Hours)' }
                ],

                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                },
                initComplete: function () {
                    $('#load1').hide();
                },
                //footerCallback: function (row, data, start, end, display) {
                //    let api = this.api();

                //    // Remove the formatting to get integer data for summation
                //    let intVal = function (i) {
                //        return typeof i === 'string' ? i.replace(/[\$,]/g, '') * 1 : typeof i === 'number' ? i : 0;
                //    };

                //    // Total over all pages
                //    var totalAmt = api.column(6).data().reduce((a, b) => intVal(a) + intVal(b), 0);

                //    // Total over this page

                //    // Update footer
                //    api.column(6).footer().innerHTML = Number(totalAmt).toFixed(2);
                //}
            });
        },

        //buttons: [
        //    {
        //        extend: 'excelHtml5', title: 'Securitization-Reliance Letter Billing', autoFilter: true,
        //    },
        //],

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}

function rebuttal_BindGrid() {

    $('#OtherBilling_Waitingpanel').modal('hide');
    $('#load1').show();

    $.ajax({
        url: "OtherBilling.aspx/GetExcelDataToBindGrid",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);

            Rebuttal_table = $('#table_Rebuttal').DataTable({
                dom: 'ftip',
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                filter: true,
                'select': {
                    'style': 'single'
                },
                "serverSide": false,
                "data": dataArray,
                columns: [
                    /*  { data: 'SrNo' },*/
                    { data: 'Deal Number' },
                    { data: 'Loan Number' },
                    { data: 'Condition' },
                    { data: 'Client Rebuttal' },
                    { data: 'Status' },
                    { data: 'Rebuttal Received Date' },
                    { data: 'Rebuttal Response Date' },
                    { data: 'Review Time (In Minutes)' },
                    { data: 'Time' },
                    //{ data: 'Amount' },
                    //{ data: 'Rate' },
                    { data: 'Billing Type' }
                ],
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                },
                initComplete: function () {

                    $('#load1').hide();
                    //  $('#OtherBilling_Waitingpanel').modal('hide');
                },

                //footerCallback: function (row, data, start, end, display) {
                //    let api = this.api();

                //    // Remove the formatting to get integer data for summation
                //    let intVal = function (i) {
                //        return typeof i === 'string' ? i.replace(/[\$,]/g, '') * 1 : typeof i === 'number' ? i : 0;
                //    };

                //    // Total over all pages
                //    var totalAmt = api.column(6).data().reduce((a, b) => intVal(a) + intVal(b), 0);

                //    // Total over this page

                //    // Update footer
                //    api.column(6).footer().innerHTML = Number(totalAmt).toFixed(2);
                //}
            });
        },

        //buttons: [
        //    {
        //        extend: 'excelHtml5', title: 'Securitization-Reliance Letter Billing', autoFilter: true,
        //    },
        //],


        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}


/*------------- Excel Billing Report ------------- */

var excelRebuttal_table;
var excelResearch_table;

function btnexcelBilling_Submit() {

    var ddl_ProjectType = document.getElementById('excelBilling_ProjectType');
    var Project_Type = ddl_ProjectType.options[ddl_ProjectType.selectedIndex].value;

    var ddl_Project = document.getElementById('excelBilling_Project');
    var projetId = ddl_Project.options[ddl_Project.selectedIndex].value;

    var ProjectName = ddl_Project.options[ddl_Project.selectedIndex].text;

    var ddl_Deal = document.getElementById('excelBilling_DealNo');
    var dealno = ddl_Deal.options[ddl_Deal.selectedIndex].value;

    if (Project_Type == "Select") {
        alert("Please select Project Type");
        document.getElementById('excelBilling_ProjectType').focus();
        return false;
    }
    if (projetId == "") {
        alert("Please select Project");
        document.getElementById('excelBilling_Project').focus();
        return false;
    }
    if (dealno == "") {
        alert("Please select Deal #");
        document.getElementById('excelBilling_DealNo').focus();
        return false;
    }

    document.getElementById("table_excelRebuttal").style.display = "none";
    document.getElementById("table_excelResearch").style.display = "none";

    if (projetId != "" && dealno != "") {

        if (Project_Type == "Rebuttal") {

            document.getElementById("table_excelRebuttal").style.display = "";
            ExcelRebuttal_BindGrid(projetId, dealno, ProjectName);
        }
        else if (Project_Type == "Research") {

            document.getElementById("table_excelResearch").style.display = "";
            ExcelResearch_BindGrid(projetId, dealno, ProjectName);
        }
    }
}

function BindDomainWise_ExcelProject(DomainID) {

    var select1 = document.getElementById("excelBilling_Project");
    let options1 = select1.getElementsByTagName('excelBilling_Project');

    for (var i = options1.length; i--;) {
        select1.removeChild(options1[i]);
    }

    $("#excelBilling_Project").append($("<option></option>").val("Select").html("Select"));

    $.ajax({
        type: "POST", url: "OtherBilling.aspx/GetAllProjectByDomainWise", dataType: "json",
        data: "{DomainID:" + DomainID + "}",
        contentType: "application/json",
        success: function (res) {

            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {

                $("#excelBilling_Project").append($("<option></option>").val(value.ProjectId).html(value.ProjectName));
            })
        }
    });
}

function Excel_bindDeals(ddlprojectId) {

    var projectID = ddlprojectId.options[ddlprojectId.selectedIndex].value;

    var SelectDeal = document.getElementById("excelBilling_DealNo");
    let optionsDeal = SelectDeal.getElementsByTagName('option');

    for (var i = optionsDeal.length; i--;) {
        SelectDeal.removeChild(optionsDeal[i]);
    }

    $("#excelBilling_DealNo").append($("<option></option>").val("Select").html("Select"));

    $.ajax({
        type: "POST", url: "ExcelBillingReport.aspx/GetAllDealNumberForSentToBilling", dataType: "json",
        data: "{ProjectID:" + projectID + "}",
        contentType: "application/json",
        success: function (res) {

            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {

                $("#excelBilling_DealNo").append($("<option></option>").val(value.DealNo).html(value.DealNo));
            })
        }
    });
}

function ExcelResearch_BindGrid(projetId, dealno, ProjectName) {

    $('#load1').show();

    //projetId = 358;
    //dealno = '661-023';

    var Title = ProjectName + " - " + dealno;

    $.ajax({
        url: "ExcelBillingReport.aspx/GetGridData_Research",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: "{ProjectID:" + projetId + ", DealNo:'" + dealno + "'}",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            excelResearch_table = $('#table_excelResearch').DataTable({
                dom: 'fBtip',
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                filter: true,
                'select': {
                    'style': 'single'
                },
                "serverSide": false,
                "data": dataArray,

                columns: [
                    { data: 'SrNo' },
                    { data: 'Deal No' },
                    { data: 'PRP Deal Name' },
                    { data: 'Subject Line' },
                    { data: 'Requested Docs/Tasks Performed' },
                    { data: 'No of Docs Researched' },
                    { data: 'Total Time Taken (in Minutes)' },
                    { data: 'Request Received from' },
                    { data: 'Request Received Date' },
                    { data: 'Documents Delivered Date' },
                    { data: 'Remark' },
                    { data: 'Time' }
                ],

                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                },
                initComplete: function () {
                    $('#load1').hide();
                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: Title, autoFilter: true,
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

function ExcelRebuttal_BindGrid(projetId, dealno, ProjectName) {

    //projetId = 165;
    //dealno = '592_Feb To Apr-2020_Stips Clearing'

    var Title = ProjectName + " - " + dealno;

    $('#load1').show();

    $.ajax({
        url: "ExcelBillingReport.aspx/GetGridData_Rebuttal",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: "{ProjectID:" + projetId + ", DealNo:'" + dealno + "'}",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            excelRebuttal_table = $('#table_excelRebuttal').DataTable({
                dom: 'Bftip',
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                filter: true,
                'select': {
                    'style': 'single'
                },
                "serverSide": false,
                "data": dataArray,
                columns: [
                    { data: 'SrNo' },
                    { data: 'Deal Number' },
                    { data: 'Loan Number' },
                    { data: 'Condition' },
                    { data: 'Clients Rebuttal' },
                    { data: 'Cleared (Yes/No)' },
                    { data: 'Start Date/Time' },
                    { data: 'Total Time' },
                    { data: 'Infinity Response' },
                    { data: 'Time' },
                    { data: 'BillingType' }
                ],
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                },
                initComplete: function () {

                    $('#load1').hide();
                },

                buttons: [
                    {
                        extend: 'excelHtml5', title: Title, autoFilter: true,
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
