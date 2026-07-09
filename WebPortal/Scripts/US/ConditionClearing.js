
var projectId;
var dealno;
let projects = [];

function bindProjects() {

    fetch("ConditionClearing.aspx/GetProjects", {
        method: "POST",
        headers: {
            "Content-Type": "application/json; charset=utf-8"
        },
        body: "{}"
    })
        .then(function (response) {
            return response.json();
        })
        .then(function (result) {

            var data = result.d || [];

            // If WebMethod returns JSON string
            if (typeof data === "string") {
                data = JSON.parse(data);
            }

            projects = data;

            var ddl = document.getElementById("conclUS_project");

            var html = "<option value=''>Select Project</option>";

            for (var i = 0; i < data.length; i++) {
                html += "<option value='" + data[i].ProjectID + "'>" +
                    data[i].ProjectName +
                    "</option>";
            }

            ddl.innerHTML = html;

            // If using Select2
            if ($("#conclUS_project").hasClass("select2-hidden-accessible")) {
                $("#conclUS_project").trigger("change.select2");
            }
        })
        .catch(function (error) {
            console.error("Project binding error:", error);
        });
}

function bindDeals(id) {

    projectId = id.value;

    fetch("ConditionClearing.aspx/GetDeals", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ ProjectID: projectId })
    })
        .then(res => res.json())
        .then(result => {
            var data = result.d;
            var ddl = document.getElementById("conclUS_dealNo");
            ddl.innerHTML = "<option value=''>Select Deal</option>";

            for (var i = 0; i < data.length; i++) {
                var option = document.createElement("option");
                option.value = data[i].DealNo;     // Column name from DataTable
                option.text = data[i].DealNo;    // Column name from DataTable
                ddl.appendChild(option);
            }
        });
}

function bindLoans(id) {

    dealno = id.value;

    fetch("ConditionClearing.aspx/GetLoans", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ ProjectID: projectId, DealNo: dealno })
    })
        .then(res => res.json())
        .then(result => {
            var data = result.d;
            var ddl = document.getElementById("conclUS_loanNo");
            ddl.innerHTML = "<option value=''>Select Deal</option>";

            for (var i = 0; i < data.length; i++) {
                var option = document.createElement("option");
                option.value = data[i].OrderNo;     // Column name from DataTable
                option.text = data[i].OrderNo;    // Column name from DataTable
                ddl.appendChild(option);
            }
        });
}

function GetDealFromLoan(id) {

    var loanNo = $(id).val();

    if (!loanNo) {
        $("#conclUS_dealNo").val("");
        return;
    }

    // Show loading message
    Swal.fire({
        title: "Please wait...",
        text: "Fetching deal number...",
        allowOutsideClick: false,
        allowEscapeKey: false,
        didOpen: () => {
            Swal.showLoading();
        }
    });

    fetch("ConditionClearing.aspx/GetDealFromLoan", {
        method: "POST",
        headers: {
            "Content-Type": "application/json; charset=utf-8"
        },
        body: JSON.stringify({ LoanNo: loanNo })
    })
        .then(response => response.json())
        .then(result => {

            var data = result.d;

            if (typeof data === "string") {
                data = JSON.parse(data);
            }

            if (data && data.length > 0) {
                $("#conclUS_dealNo").val(data[0].DealNo);
                Swal.close();
            } else {

                Swal.close();   // Close loading popup first

                alert("No deal number is available for Loan No. " + loanNo + ".");
                // Swal.fire({
                //     icon: "warning",
                //     title: "Loan Not Found",
                //     text: "Deal number is not available for the selected loan number.",
                //     confirmButtonText: "OK"
                // });
                $("#conclUS_dealNo").val("");
            }

            Swal.close(); // Close loading popup
        })
        .catch(error => {

            console.error(error);
            $("#conclUS_dealNo").val("");

            Swal.close();

            Swal.fire({
                icon: "error",
                title: "Error",
                text: "Unable to fetch deal number."
            });
        });
}

function condclearing_bindGrid() {

    $.ajax({
        url: "ConditionClearing.aspx/ViewAllConditionClearing",
        type: "POST",
        contentType: "application/json; charset=utf-8",
        data: '{}', // required for ASP.NET WebMethods
        dataType: "json",

        success: function (data) {

            var dataArray = data.d || [];

            // Destroy old DataTable
            if ($.fn.DataTable.isDataTable('#table_condclear')) {
                $('#table_condclear').DataTable().clear().destroy();
            }

            $('#table_condclear').DataTable({
                dom: '<"top"lBf>rt<"bottom"ip>', /*'lBftip',*/
                data: dataArray,
                scrollX: false,
                paging: true,
                processing: true,
                ordering: false,
                serverSide: false,

                columns: [
                    {
                        data: null, title: 'Sr. #',
                        render: function (data, type, row, meta) {
                            return meta.row + 1;
                        }
                    },

                    { data: 'ProjectName', title: 'Project' },
                    { data: 'DealNo', title: 'Deal #', width: '8%' },
                    { data: 'LoanNo', title: 'Loan #' },
                    { data: 'InfinityCondition', title: 'Infinity Conditions' },
                    { data: 'ClientsRebuttal', title: 'Clients Rebuttal' },
                    { data: 'ReceivedDate', title: 'Received Date' },
                    { data: 'AddedName', title: 'Added  By' },
                    { data: 'AddedDate1', title: 'Added Date' }
                ],
                buttons: [
                    {
                        extend: 'excelHtml5',
                        title: 'Condition Clearing'
                    }
                ],

                initComplete: function () {
                    $('#load1').hide();
                }
            });
        },

        error: function (error) {
            $('#load1').hide();
            alert('Error: ' + error.responseText);
        }

    });
}

function conclUS_SaveData() {

    var project = $("#conclUS_project").val();
    var deal = $("#conclUS_dealNo").val();
    var loan = $("#conclUS_loanNo").val();
    var receivedDate = $("#conclUS_receiveddate").val();
    var grade = $("#conclUS_expgrade").val();
    var process = $("#conclUS_process").val();
    var infCondition = $("#conclUS_infcondition").val();
    var rebuttal = $("#conclUS_rebuttal").val();

    // Validation
    if (project == "") {
        Swal.fire({
            icon: 'warning',
            title: 'Validation',
            text: 'Please select Project'
        });
        return false;
    }

    if (deal == "") {
        Swal.fire({
            icon: 'warning',
            title: 'Validation',
            text: 'Please select Deal'
        });
        return false;
    }

    if (grade == "") {
        Swal.fire({
            icon: 'warning',
            title: 'Validation',
            text: 'Please select Initial Exception Grade'
        });
        return false;
    }

    if (process == "") {
        Swal.fire({
            icon: 'warning',
            title: 'Validation',
            text: 'Please select Process'
        });
        return false;
    }

    if (infCondition == "") {
        Swal.fire({
            icon: 'warning',
            title: 'Validation',
            text: 'Please enter Infinity Condition'
        });
        return false;
    }

    if (rebuttal == "") {
        Swal.fire({
            icon: 'warning',
            title: 'Validation',
            text: 'Please enter Clients Rebuttal'
        });
        return false;
    }

    // PageMethod Call
    PageMethods.InsertConditionClearing(project, deal, loan, infCondition, rebuttal, receivedDate, grade, process,

        function (response) {

            if (response.includes("Error")) {

                Swal.fire({ icon: 'error', title: 'Error', text: response });

            } else {

                Swal.fire({ icon: 'success', title: 'Success', text: response });

                conclUS_ClearForm();
                condclearing_bindGrid();
            }
        },

        function (error) {

            Swal.fire({ icon: 'error', title: 'Error', text: error.get_message() });
        }
    );

    return false;
}

function core_conclUS_SaveData() {

    var project = $("#conclUS_project").val();
    var deal = $("#conclUS_dealNo").val();
    var loan = $("#conclUS_loanNo").val();
    var receivedDate = $("#conclUS_receiveddate").val();
    var grade = $("#conclUS_expgrade").val();
    var process = $("#conclUS_process").val();
    var infCondition = $("#conclUS_infcondition").val();
    var rebuttal = $("#conclUS_rebuttal").val();

    // Validation
    if (project == "") {
        alert("Please select Project");
        return false;
    }

    if (deal == "") {
        alert("Please select Deal");
        return false;
    }

    if (grade == "") {
        alert("Please select Initial Exception Grade");
        return false;
    }

    if (process == "") {
        alert("Please select Process");
        return false;
    }

    if (infCondition == "") {
        alert("Please enter Infinity Condition");
        return false;
    }

    if (rebuttal == "") {
        alert("Please enter Clients Rebuttal");
        return false;
    }

    // PageMethod Call
    PageMethods.InsertConditionClearing(project, deal, loan, infCondition, rebuttal, receivedDate, grade, process,

        function (response) {

            const Toast = Swal.mixin({
                width: '700px',
                padding: '2em',
                confirmButtonText: 'OK',
                confirmButtonColor: '#3085d6',
                background: '#fff',
                backdrop: 'rgba(0,0,0,0.5)'
            });

            if (response.includes("Error")) {

                Toast.fire({
                    icon: 'error',
                    title: response
                });

            } else {

                Toast.fire({
                    icon: 'success',
                    title: response
                });
                conclUS_ClearForm();
                condclearing_bindGrid();
            }
        },

        function (error) {

            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: error.get_message()
            });
        }
    );

    return false;
}

function conclUS_ClearForm() {

    $("#conclUS_project").prop("selectedIndex", 0);
    // $("#conclUS_dealNo").html("<option value=''>Select Deal</option>");
    // $("#conclUS_loanNo").html("<option value=''>Select Loan</option>");
    $("#conclUS_dealNo").val("");
    $("#conclUS_loanNo").val("");
    $("#conclUS_receiveddate").val("");
    $("#conclUS_expgrade").prop("selectedIndex", 0);
    $("#conclUS_process").prop("selectedIndex", 0);
    $("#conclUS_infcondition").val("");
    $("#conclUS_rebuttal").val("");
}

function showSuccess(message) {
    Swal.fire({
        icon: 'success',
        title: 'Success',
        text: message
    });
}

function showError(message) {
    Swal.fire({
        icon: 'error',
        title: 'Error',
        text: message
    });
}

function handlePageMethodResponse(response, clearFunction = null) {

    if (response && response.toLowerCase().includes("error")) {

        showError(response);
    } else {


        Swal.fire({
            icon: 'success',
            title: 'Success',
            text: response
        }).then(function () {
            if (clearFunction) {
                clearFunction();
            }
        });
    }
}

