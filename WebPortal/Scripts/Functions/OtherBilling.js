
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

    var projectID = ddlprojectId.options[ddlprojectId.selectedIndex].value;

    var Select = document.getElementById("otherBilling_DealNo");
    let options = Select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        Select.removeChild(options[i]);
    }

    $("#otherBilling_DealNo").append($("<option></option>").val("Select").html("Select"));
    $("#otherBilling_DealNo").append($("<option></option>").val("AddNew").html("Add New"));

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

function getNewDalNo(obj) {
    if (obj.value === "AddNew") {
        document.getElementById("divNewDealNo").style.display = "block";
    } else {
        document.getElementById("divNewDealNo").style.display = "none";
    }
}

function btnOtherBilling_Import() {

    document.getElementById("spntext").innerHTML = "Reading data from Excel...";
    $('#OtherBilling_Waitingpanel').modal('show');

    PageMethods.ImportExcel(

        function (result) {

            $('#OtherBilling_Waitingpanel').modal('hide');

            if (result > 0) {

                Swal.fire({
                    icon: "success",
                    title: "Import Successful",
                    text: "Excel data imported successfully.",
                    confirmButtonText: "OK"
                }).then(function () {

                    var ProjectType = $("#otherBilling_ProjectType").val();

                    $("#table_Research").hide();
                    $("#table_Rebuttal").hide();

                    if (ProjectType === "Research") {
                        $("#table_Research").show();
                        research_BindGrid();
                    }
                    else if (ProjectType === "Rebuttal") {
                        $("#table_Rebuttal").show();
                        rebuttal_BindGrid();
                    }
                });
            }
            else if (result === -1) {

                Swal.fire({
                    icon: "warning",
                    title: "Invalid File",
                    text: "Please select an Excel file with the .xlsx extension.",
                    confirmButtonText: "OK"
                });
            }
            else {

                Swal.fire({
                    icon: "error",
                    title: "Import Failed",
                    text: "Something went wrong. Please contact the administrator.",
                    confirmButtonText: "OK"
                });
            }
        },

        function (error) {

            $('#OtherBilling_Waitingpanel').modal('hide');

            Swal.fire({
                icon: "error",
                title: "Error",
                text: error.get_message ? error.get_message() : error.responseText,
                confirmButtonText: "OK"
            });
        }
    );

    return false;
}

async function btnOtherBilling_Verify() {

    const projectType = document.getElementById("otherBilling_ProjectType").value.trim();
    const project = document.getElementById("otherBilling_Project").value.trim();
    const selectedDealNo = document.getElementById("otherBilling_DealNo").value.trim();
    const newDealNo = document.getElementById("otherBilling_NewDealNo").value.trim();

    if (!projectType) {
        await showValidationMessage("Project Type Required", "Please select a project type.");

        document.getElementById("otherBilling_ProjectType").focus();
        return false;
    }

    if (!project) {
        await showValidationMessage("Project Required", "Please select a project.");

        document.getElementById("otherBilling_Project").focus();
        return false;
    }

    if (!selectedDealNo) {
        await showValidationMessage("Deal Number Required", "Please select a deal number.");
        document.getElementById("otherBilling_DealNo").focus();
        return false;
    }

    if (selectedDealNo === "AddNew" && !newDealNo) {
        await showValidationMessage("New Deal Number Required", "Please enter a new deal number.");
        document.getElementById("otherBilling_NewDealNo").focus();
        return false;
    }

    const dealNo = selectedDealNo === "AddNew" ? newDealNo : selectedDealNo;

    Swal.fire({
        title: "Please wait", html: "The system is verifying and submitting your data.",
        allowOutsideClick: false, allowEscapeKey: false, showConfirmButton: false, didOpen: function () {
            Swal.showLoading();
        }
    });

    try {
        const result = await verifyAndSubmitData(projectType, project, dealNo);

        if (Number(result) > 0) {
            await Swal.fire({
                icon: "success",
                title: "Submitted Successfully",
                text: "Your billing information has been verified and submitted successfully.",
                confirmButtonText: "OK"
            }).then(function () {

                clearOtherBillingControls();
            });
        } else {
            await Swal.fire({ icon: "warning", title: "Submission Not Completed", text: "No record was submitted. Please verify the entered information.", confirmButtonText: "OK" });
        }
    } catch (error) {
        const errorMessage =
            error?.get_message?.() ||
            error?.responseText ||
            error?.message ||
            "An unexpected error occurred while submitting the data.";

        await Swal.fire({ icon: "error", title: "Submission Failed", text: errorMessage, confirmButtonText: "OK" });
    }

    return false;
}

function showValidationMessage(title, message) {
    return Swal.fire({ icon: "warning", title: title, text: message, confirmButtonText: "OK" });
}

function verifyAndSubmitData(projectType, project, dealNo) {
    return new Promise(function (resolve, reject) {
        PageMethods.VerifyAndSubmitData(projectType, project, dealNo, resolve, reject);
    });
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

function getGridValue(row) {
    if (!row) {
        return '';
    }

    for (var i = 1; i < arguments.length; i++) {
        var propertyName = arguments[i];

        if (
            Object.prototype.hasOwnProperty.call(row, propertyName) &&
            row[propertyName] !== null &&
            row[propertyName] !== undefined
        ) {
            return row[propertyName];
        }
    }

    return '';
}

function clearOtherBillingControls() {

    $('#otherBilling_ProjectType').val('Select');

    $('#otherBilling_Project').html('<option value="">Select</option>');

    $('#otherBilling_DealNo').html('<option value="">Select</option>');

    BindDomainWise_Project(9);

    $('#otherBilling_NewDealNo').val('');
    $('#divNewDealNo').hide();

    $('#otherBilling_attachment').val('');
    $('#otherbillingfilesdiv').empty();
    $('#conentdiv').attr('style', 'display: none !important;');
    $('#otherBilling_uploadArea').show();

    clearOtherBillingTables();

    $('#load1').hide();
    $('#OtherBilling_Waitingpanel').modal('hide');

    $('#otherBilling_Import, #otherBilling_Verify')
        .prop('disabled', false);
}

function clearOtherBillingTables() {
    ['#table_Research', '#table_Rebuttal'].forEach(function (selector) {
        if ($.fn.DataTable.isDataTable(selector)) {
            $(selector).DataTable().clear().destroy();
        }

        $(selector).find('thead, tbody, tfoot').empty();
        $(selector).hide();
    });
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
