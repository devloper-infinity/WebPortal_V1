
var projectId;
var dealno;
let projects = [];

function bindProjects() {

    fetch("ConditionClearing.aspx/GetProjects", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        }
    })
        .then(response => response.json())
        .then(result => {

            var data = result.d;
            projects = data;  // save to global projects array
            // renderOptions(projects); 

            var ddl = document.getElementById("concl_project");

            ddl.innerHTML = "<option value=''>Select Project</option>";

            for (var i = 0; i < data.length; i++) {

                var option = document.createElement("option");
                option.value = data[i].ProjectID;     // Column name from DataTable
                option.text = data[i].ProjectName;    // Column name from DataTable
                ddl.appendChild(option);

            }
        });
    //  renderOptions(projects);
}

//function renderOptions(list) {
//    optionsContainer.innerHTML = '';
//    list.forEach(proj => {
//        const optionDiv = document.createElement('div');
//        optionDiv.textContent = proj.ProjectName;
//        optionDiv.dataset.value = proj.ProjectID;
//        optionDiv.addEventListener('click', () => {
//            selected.textContent = proj.ProjectName;
//            selected.dataset.value = proj.ProjectID;
//            closeDropdown();
//        });
//        optionsContainer.appendChild(optionDiv);
//    });
//}

//// Open dropdown
//function openDropdown() {
//    menu.classList.remove('hidden');
//    searchBox.value = '';
//    renderOptions(projects);
//    searchBox.focus();
//}

//// Close dropdown
//function closeDropdown() {
//    menu.classList.add('hidden');
//}

//// Toggle dropdown on selected click
//selected.addEventListener('click', () => {
//    if (menu.classList.contains('hidden')) {
//        openDropdown();
//    } else {
//        closeDropdown();
//    }
//});

//// Filter options on typing
//searchBox.addEventListener('input', () => {
//    const filter = searchBox.value.toLowerCase();
//    const filtered = projects.filter(p => p.ProjectName.toLowerCase().includes(filter));
//    renderOptions(filtered);
//});

//// Close dropdown if clicked outside
//document.addEventListener('click', e => {
//    if (!dropdown.contains(e.target)) {
//        closeDropdown();
//    }
//});

//// Initialize on page load
//document.addEventListener('DOMContentLoaded', loadProjects);

//// Function to get selected project info
//function getSelectedProject() {
//    return {
//        projectId: selected.dataset.value || '',
//        projectName: selected.textContent || ''
//    };
//}

//// Function to select project programmatically
//function selectProjectById(id) {
//    const proj = projects.find(p => p.ProjectID === id);
//    if (proj) {
//        selected.textContent = proj.ProjectName;
//        selected.dataset.value = proj.ProjectID;
//    }
//}

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
            var ddl = document.getElementById("concl_dealNo");
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
            var ddl = document.getElementById("concl_loanNo");
            ddl.innerHTML = "<option value=''>Select Deal</option>";

            for (var i = 0; i < data.length; i++) {
                var option = document.createElement("option");
                option.value = data[i].OrderNo;     // Column name from DataTable
                option.text = data[i].OrderNo;    // Column name from DataTable
                ddl.appendChild(option);
            }
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

function concl_SaveData() {

    var project = $("#concl_project").val();
    var deal = $("#concl_dealNo").val();
    var loan = $("#concl_loanNo").val();
    var receivedDate = $("#concl_receiveddate").val();
    var grade = $("#concl_expgrade").val();
    var process = $("#concl_process").val();
    var infCondition = $("#concl_infcondition").val();
    var rebuttal = $("#concl_rebuttal").val();

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

                concl_ClearForm();
                condclearing_bindGrid();
            }
        },

        function (error) {

            Swal.fire({ icon: 'error', title: 'Error', text: error.get_message() });
        }
    );

    return false;
}

function core_concl_SaveData() {

    var project = $("#concl_project").val();
    var deal = $("#concl_dealNo").val();
    var loan = $("#concl_loanNo").val();
    var receivedDate = $("#concl_receiveddate").val();
    var grade = $("#concl_expgrade").val();
    var process = $("#concl_process").val();
    var infCondition = $("#concl_infcondition").val();
    var rebuttal = $("#concl_rebuttal").val();

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
                concl_ClearForm();
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

function concl_ClearForm() {

    $("#concl_project").prop("selectedIndex", 0);
    $("#concl_dealNo").html("<option value=''>Select Deal</option>");
    $("#concl_loanNo").html("<option value=''>Select Loan</option>");
    $("#concl_receiveddate").val("");
    $("#concl_expgrade").prop("selectedIndex", 0);
    $("#concl_process").prop("selectedIndex", 0);
    $("#concl_infcondition").val("");
    $("#concl_rebuttal").val("");
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

