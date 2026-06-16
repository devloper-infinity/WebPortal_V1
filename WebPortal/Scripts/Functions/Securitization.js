var ProjectId = 0;
var ProjectName = '';
var ClientDealName = '';
var DealName = '';
var sec561_table;
var sec561_html = '';


function sectrack_BindDeals() {

    var select = document.getElementById("sectrack_DealNo");
    let options = select.getElementsByTagName('sectrack_DealNo');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#sectrack_DealNo").append($("<option></option>").val("").html("Select"));
    $("#sectrack_DealNo").append($("<option></option>").val("0").html("Add New"));


    $.ajax({
        type: "POST", url: "SecuritizationTracking.aspx/GetAllDealsFromProjectTracking", dataType: "json", contentType: "application/json",
        success: function (res) {

            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (data, value) {

                $("#sectrack_DealNo").append($("<option></option>").val(value.ClientDealName).html(value.ClientDealName));
            })
        }
    });

}

function sectrack_BindClient2() {

    var select = document.getElementById("sectrack_Project");
    let options = select.getElementsByTagName('sectrack_Project');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#sectrack_Project").append($("<option></option>").val("").html("Select"));
    $("#sectrack_Project").append($("<option></option>").val("0").html("Add New"));

    $(document).ready(function () {
        $.ajax({
            type: "POST", url: "SecuritizationTracking.aspx/GetUWProjects", dataType: "json", contentType: "application/json",
            success: function (res) {
                var dataArray = JSON.parse(res.d);
                $.each(dataArray, function (data, value) {
                    $("#sectrack_Project").append($("<option></option>").val(value.ProjectId).html(value.ProjectName));
                })
            }
        });
    })
}

function sectrack_GetNewDeal(ddldeal) {

    var value = ddldeal.selectedIndex;

    if (value == 1) {
        document.getElementById("tdnewdealheader").style.display = "";
        document.getElementById("tdnewdealdetail").style.display = "";

    }
    else {
        document.getElementById("tdnewdealheader").style.display = "none";
        document.getElementById("tdnewdealdetail").style.display = "none";
    }
    return false;
}

function sectrack_GetNewProject(ddlclient) {

    var value = ddlclient.selectedIndex;
    if (value == 1) {
        $('#popup_addNewClient').modal('show');
        //document.getElementById("tdnewclientheader").style.display = "";
        //document.getElementById("tdnewclientdetail").style.display = "";
    }
    else {
        document.getElementById("tdnewclientheader").style.display = "none";
        document.getElementById("tdnewclientdetail").style.display = "none";
    }
    return false;
}

function sectracking_submit() {

    var ddlProject = document.getElementById("sectrack_Project");
    var projectid = ddlProject.options[ddlProject.selectedIndex].value;

    var ddlDealNo = document.getElementById("sectrack_DealNo");
    var dealno = ddlDealNo.options[ddlDealNo.selectedIndex].value;

    if (dealno == "0") {
        dealno = document.getElementById("sectrack_newdealno").value;
    }
    var clientname = "";
    if (projectid == "0") {
        clientname = document.getElementById("sectrack_newdealno").value;
    }
    else {
        var ddlclientname = document.getElementById("sectrack_Project");
        clientname = ddlclientname.options[ddlclientname.selectedIndex].text;
    }

    var clientdealname = document.getElementById("sectrack_ClientDealName").value;
    var loancount = document.getElementById("sectrack_NoOfLoans").value;
    var requesteddate = document.getElementById("sectrack_RequestedDate").value;
    var sladeliverydate = document.getElementById("sectrack_SLADeliveryDate").value;
    var actualdelivereddate = document.getElementById("sectrack_ActualDeliveredDate").value;
    var sladeliverydays = document.getElementById("sectrack_SLADeliveryDays").value;
    var billingHours = document.getElementById("sectrack_BillingHours").value;
    var CLientNameAddress = document.getElementById("sectrack_ClientNameAddress").value;
    var RecepientNameAddress = document.getElementById("sectrack_RecipientNameAddress").value;
    var AgencyNameAddress = document.getElementById("sectrack_sAgencyNameAddress").value;
    var Remark = document.getElementById("sectrack_Remark").value;

    var ddltaskname = document.getElementById("sectrack_TaskName");
    var taskname = ddltaskname.options[ddltaskname.selectedIndex].value;

    var ddlRLSigned = document.getElementById("sectrack_RLSigned");
    var RLSigned = ddlRLSigned.options[ddlRLSigned.selectedIndex].value;

    var ddlStatus = document.getElementById("sectrack_Status");
    var Status = ddlStatus.options[ddlStatus.selectedIndex].value;

    PageMethods.InsertSecuritizationRelianceLetter(projectid, dealno, clientname, clientdealname, loancount, taskname, requesteddate, sladeliverydate, actualdelivereddate, Remark, Status, sladeliverydays, RLSigned, billingHours, CLientNameAddress, RecepientNameAddress, AgencyNameAddress, sectracking_OnSuccess, sectracking_OnError);

    return false;
}

function sectracking_OnSuccess(result) {

    if (result > 0) {
        document.getElementById("sectrack_errmsg").innerHTML = "Data added successfully!";
        document.getElementById("sectrack_errmsg").style.color = 'green';
        $('#sectrack_dverror').modal('show');
        sectrack561_BindDeals();
        return false;
    }
    else {
        document.getElementById("sectrack_errmsg").innerHTML = "Data already exists.";
        document.getElementById("sectrack_errmsg").style.color = 'red';
        $('#sectrack_dverror').modal('show');
        return false;
    }
    return false;
}

function sectracking_OnError(error) {
    alert(error);
}

function sectrack561_BindDeals() {

    var select = document.getElementById("sec561_dealno");
    let options = select.getElementsByTagName('sec561_dealno');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#sec561_dealno").append($("<option></option>").val("").html("Select"));


    $.ajax({
        type: "POST", url: "SecuritizationTracking.aspx/GetAllDealsFromProjectTracking", dataType: "json", contentType: "application/json",
        success: function (res) {

            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (data, value) {

                $("#sec561_dealno").append($("<option></option>").val(value.ClientDealName).html(value.ClientDealName));
            })
        }
    });
}

function sec561_Getdealdetails(ddldeal) {
    var dealno = ddldeal.options[ddldeal.selectedIndex].text;
    $.ajax({
        type: "POST", url: "Securitization561.aspx/GetDealDetails", dataType: "json", contentType: "application/json",
        data: "{DealNo:'" + dealno + "'}",
        success: function (res) {

            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                ProjectId = value.ProjectId;
                ProjectName = value.ProjectName;
                ClientDealName = value.ClientDealName;
                DealName = dealno;
            })
            sec561_GetdealData(ProjectId, ddldeal);
        }
    });
}

function sec561_GetdealData(ProjectId, ddldeal) {
    var dealno = ddldeal.options[ddldeal.selectedIndex].text;
    sec561_html = '';
    $.ajax({
        type: "POST", url: "Securitization561.aspx/GetDealData", dataType: "json", contentType: "application/json",
        data: "{ProjectId:" + ProjectId + ", DealNo:'" + dealno + "'}",
        success: function (res) {

            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (index, value) {
                sec561_html += '<tr>';
                sec561_html += '<td style="text-wrap: nowrap; text-align:center;">' + (index + 1) + '</td>';
                sec561_html += '<td style="text-wrap: nowrap;display:none;">' + blankForNull(value.BillingID) + '</td>';
                sec561_html += '<td style="text-wrap: nowrap;display:none;">' + blankForNull(value.ProjectID) + '</td>';
                sec561_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Description) + '</td>';
                sec561_html += '<td style="text-wrap: nowrap;text-align:center;">' + blankForNull(value.NoOfLoans) + '</td>';
                sec561_html += '<td style="text-wrap: nowrap;text-align:center;">' + blankForNull(value.NoofHours) + '</td>';
                sec561_html += '</tr>';

            });

            if ($.fn.dataTable.isDataTable('#sec561_table')) {
                sec561_table.destroy();
            }
            $('#sec561_table tbody').html(sec561_html);
            //else
            sec561_table = $('#sec561_table').DataTable({
                dom: 't',
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
            });
        }
    });
}

function sec561_submit() {
    if (ProjectId != 0 && ProjectId != '') {
        var BillingPeriod = DealName + "_" + ProjectName + "_" + ClientDealName;
        var ddltype = document.getElementById("sec561_type");
        var type = ddltype.options[ddltype.selectedIndex].value;
        var loancount = document.getElementById("sec561_loancount").value;
        PageMethods.InsertBillingData(ProjectId, BillingPeriod, type, ddltype.selectedIndex, DealName, loancount, sec561_OnSuccess, sec561_OnError);
        return false;
    }
    else {
        document.getElementById("sectrack_errmsg").innerHTML = "Oops! Error occured while adding data Please contact administrator!";
        document.getElementById("sectrack_errmsg").style.color = 'red';
        $('#sectrack_dverror').modal('show');
        return false;
    }
    return false;
}

function sec561_OnSuccess(result) {
    if (result > 0) {
        document.getElementById("sectrack_errmsg").innerHTML = "Data added successfully!";
        document.getElementById("sectrack_errmsg").style.color = 'green';
        $('#sectrack_dverror').modal('show');
        sectrack561_BindDeals();
        return false;
    }
    else {
        document.getElementById("sectrack_errmsg").innerHTML = "Data already exists.";
        document.getElementById("sectrack_errmsg").style.color = 'red';
        $('#sectrack_dverror').modal('show');
        return false;
    }
    return false;
}

function sec561_OnError(error) {
    alert(error);
}

function sec561_Message() {
    sec561_GetdealData(ProjectId, document.getElementById("sec561_dealno"));
    $('#sectrack_dverror').modal('hide');
}

function sec561_sendBilling() {
    var table = $('#sec561_table').DataTable();

    table.rows().every(function () {
        var rowData = this.data();

        var cellValue = rowData[2]; // Accessing the 3rd cell (index 2)

    });


    return false;
}

function addNewClient_btnSubmit() {

    var projectNo = document.getElementById("addNewClient_prjNo").value;
    var company = document.getElementById("addNewClient_company").value;
    var contactPerson = document.getElementById("addNewClient_cntPerson").value;
    var contactNo = document.getElementById("addNewClient_cntNo").value;
    var email = document.getElementById("addNewClient_email").value;
    var website = document.getElementById("addNewClient_website").value;
    var address = document.getElementById("addNewClient_address").value;
    var remark = document.getElementById("addNewClient_remark").value;


    if (!isValidPhone(contactNo)) {
        alert("Please enter a valid 10-digit contact number.");
        document.getElementById("addNewClient_cntNo").focus();
        return false;
    }

    if (!isValidEmail(email)) {
        alert("Please enter a valid Email ID.");
        document.getElementById("addNewClient_email").focus();
        return false;
    }

    if (!isValidURL(website)) {
        alert("Please enter a valid Website URL.");
        document.getElementById("addNewClient_website").focus();
        return false;
    }

    if (projectNo == "") {
        alert("Please enter Project #.");
        document.getElementById("addNewClient_prjNo").focus();
        return false;
    }

    if (company == "") {
        alert("Please enter Company name.");
        document.getElementById("addNewClient_company").focus();
        return false;
    }

    if (contactPerson === "") {
        alert("Please enter Contact Person.");
        document.getElementById("addNewClient_cntPerson").focus();
        return false;
    }

    if (contactNo === "") {
        alert("Please enter Contact #.");
        document.getElementById("addNewClient_cntNo").focus();
        return false;
    }

    if (email === "") {
        alert("Please enter Email ID.");
        document.getElementById("addNewClient_email").focus();
        return false;
    }

    if (website === "") {
        alert("Please enter Website URL.");
        document.getElementById("addNewClient_website").focus();
        return false;
    }

    if (address === "") {
        alert("Please enter Address.");
        document.getElementById("addNewClient_address").focus();
        return false;
    }

    if (remark === "") {
        alert("Please enter Remark.");
        document.getElementById("addNewClient_remark").focus();
        return false;
    }

    PageMethods.InsertProjectInfo(projectNo, company, contactPerson, contactNo, email, website, address, remark, addNewClient_OnSuccess, addNewClient_OnError);
    return false;
}

function addNewClient_OnSuccess(result) {

    $('#popup_addNewClient').modal('hide');

    if (result > 0) {

        clearAddNewClientForm();

        document.getElementById("sectrack_errmsg").innerHTML = "New client added successfully!";
        document.getElementById("sectrack_errmsg").style.color = 'green';
        $('#sectrack_dverror').modal('show');
        sectrack_BindClient2();

        return false;
    }
    else if (result = -1) {
        document.getElementById("sectrack_errmsg").innerHTML = "Client alreday exists.";
        document.getElementById("sectrack_errmsg").style.color = 'red';
        $('#sectrack_dverror').modal('show');
        return false;
    }
    else {
        document.getElementById("sectrack_errmsg").innerHTML = "Oops! Error occurred while adding new client. Please contact administrator!";
        document.getElementById("sectrack_errmsg").style.color = 'red';
        $('#sectrack_dverror').modal('show');
        return false;
    }
}

function addNewClient_OnError(error) {
    alert(error.responseText);
}

function clearAddNewClientForm() {

    document.getElementById("addNewClient_prjNo").value = '';
    document.getElementById("addNewClient_company").value = '';
    document.getElementById("addNewClient_cntPerson").value = '';
    document.getElementById("addNewClient_cntNo").value = '';
    document.getElementById("addNewClient_email").value = '';
    document.getElementById("addNewClient_website").value = '';
    document.getElementById("addNewClient_address").value = '';
    document.getElementById("addNewClient_remark").value = '';
}

function isValidEmail(email) {
    var regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return regex.test(email);
}

function isValidPhone(phone) {
    var regex = /^[0-9]{10}$/;   // 10-digit number
    return regex.test(phone);
}

function isValidURL(url) {
    var regex = /^(https?:\/\/)?([\w-]+\.)+[\w-]{2,}(\/.*)?$/;
    return regex.test(url);
}


/*--------------- Code By NGK ---------------*/

const copyFields = [
    "Requested Date",
    "SLA/Client Delivery Date",
    "SLA/Client Delivery Days",
    "Actual Delivered Date",
    "Achieved TAT (In Days)",
    "# of days leading/delayed",
    "% saving in Turntime",
    "15E or RL Signed?",
    "Billing Hours",
    "Status",
    "Full Name and Address of Client/Seller",
    "Full Name and Address of Recipient/Buyer",
    "Full Name of Rating Agencies",
    "Remark",
    "Billed?"
];


var g_copies = [];
var g_copyFields = [];
var g_finalData = [];

function sectrack_BindPivotGrid() {
    $('#load1').show();
    $.ajax({
        type: "POST",
        url: "SecuritizationTracking.aspx/GetAllSecuritizationData",
        dataType: "json",
        contentType: "application/json",

        success: function (res) {
            var raw = JSON.parse(res.d);
            let copies = [...new Set(raw.map(r => r["Copies"]))];

            // --- Build thead properly so headers align (put this before DataTable init)
            // Clear any existing DataTable to avoid duplicate initialization
            if ($.fn.DataTable.isDataTable('#sectracking_table')) {
                $('#sectracking_table').DataTable().clear().destroy();
            }

            // ensure table thead is clean
            $('#sectracking_table thead').empty();

            // create the two header rows
            const $topTr = $('<tr id="hdrTop"></tr>');
            const $subTr = $('<tr id="hdrSub"></tr>');

            // Fixed first 6 headers should span both rows
            const fixedHeaders = [
                "Deal #", "Client", "Sales Person", "Client Deal #", "Loan Count", "Task Name"
            ];
            fixedHeaders.forEach(h => {
                $topTr.append(`<th rowspan="2">${h}</th>`);
            });

            // If no copies, still append an empty placeholder so structure remains valid
            if (copies.length === 0) {
                $topTr.append('<th colspan="1">No Copies</th>');
                $subTr.append('<th> </th>');
            } else {
                // For each copy add a grouped header with colspan = number of fields
                copies.forEach(c => {
                    $topTr.append(`<th colspan="${copyFields.length}">${c}</th>`);
                });

                // Sub header — one <th> per copyField for each copy
                copies.forEach(c => {
                    copyFields.forEach(f => {
                        $subTr.append(`<th>${f}</th>`);
                    });
                });
            }
            g_copies = copies;
            g_copyFields = copyFields;
            // Append constructed rows into the thead
            $('#sectracking_table thead').append($topTr).append($subTr);

            //  Step 4: Pivot rows into ONE row per deal
            let pivot = {};

            raw.forEach(r => {

                let key = r["Deal #"];

                if (!pivot[key]) {
                    // Create base row
                    pivot[key] = {
                        "Deal #": r["Deal #"],
                        "Client": r["Client"],
                        "Sales Person": r["Sales Person"],
                        "Client Deal #": r["Client Deal #"],
                        "Loan Count": r["Loan Count"],
                        "Task Name": r["Task Name"]
                    };
                }

                // ensure all copy fields exist for each copy in pivot (initialize)
                copies.forEach(copyName => {
                    copyFields.forEach(f => {
                        // Initialize only if not already present
                        const keyName = `${copyName}_${f}`;
                        if (pivot[key][keyName] === undefined) pivot[key][keyName] = "";
                    });
                });

                // Then fill only the copy that exists in the SQL row
                let c = r["Copies"]; // e.g., "Copy 1"
                if (c) {
                    copyFields.forEach(f => {
                        pivot[key][`${c}_${f}`] = r[f] ?? "";
                    });
                }
            });

            let finalData = Object.values(pivot);
            g_finalData = finalData;
            //  Step 5: Build DataTables column definitions
            let dtCols = [
                { data: "Deal #", title: "Deal #" },
                { data: "Client", title: "Client" },
                { data: "Sales Person", title: "Sales Person" },
                { data: "Client Deal #", title: "Client Deal #" },
                { data: "Loan Count", title: "Loan Count" },
                { data: "Task Name", title: "Task Name" }
            ];

            copies.forEach(c => {
                copyFields.forEach(f => {
                    dtCols.push({
                        data: `${c}_${f}`,
                        title: f
                    });
                });
            });

            //  Step 6: Initialize DataTable
            $('#sectracking_table').DataTable({
                dom: "rtip",
                data: finalData,
                columns: dtCols,
                scrollX: true,
                scrollCollapse: true,
                autoWidth: false,
                deferRender: true,
                paging: true,
                pageLength: 10,
                ordering: false,
                language: {
                    emptyTable: "No securitization tracking records found",
                    info: "Showing _START_ to _END_ of _TOTAL_ deals",
                    infoEmpty: "No deals to show",
                    zeroRecords: "No matching tracking records"
                },

                initComplete: function () {
                    $('#load1').hide();
                    if (typeof window.sectrack_OnPivotBound === "function") {
                        window.sectrack_OnPivotBound(finalData, copies, copyFields);
                    }
                },

                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    // Use CSS property 'white-space' via css('white-space', 'nowrap')
                    $(nRow).children("td").css("white-space", "nowrap");
                    $(nRow).children("td").css("text-align", "center");
                },
            });
        },

        error: function (xhr, status, err) {
            console.error('Error fetching data:', status, err);
            $('#load1').hide();
        }
    });
}

function sectracking_exportpivot(e) {
    if (!g_finalData.length) {
        alert("No data to export");
        return;
    }

    let wb = XLSX.utils.book_new();
    let wsData = [];

    // ---------- HEADER ROW 1 ----------
    let row1 = [
        "Deal #", "Client", "Sales Person",
        "Client Deal #", "Loan Count", "Task Name"
    ];

    g_copies.forEach(c => {
        row1.push(c);
        for (let i = 1; i < g_copyFields.length; i++) row1.push("");
    });
    wsData.push(row1);

    // ---------- HEADER ROW 2 ----------
    let row2 = ["", "", "", "", "", ""];
    g_copies.forEach(() => {
        g_copyFields.forEach(f => row2.push(f));
    });
    wsData.push(row2);

    // ---------- DATA ----------
    g_finalData.forEach(r => {

        let row = [
            r["Deal #"],
            r["Client"],
            r["Sales Person"],
            r["Client Deal #"],
            r["Loan Count"],
            r["Task Name"]
        ];

        g_copies.forEach(c => {
            g_copyFields.forEach(f => {
                row.push(r[`${c}_${f}`] || "");
            });
        });

        wsData.push(row);
    });

    let ws = XLSX.utils.aoa_to_sheet(wsData);

    // ---------- MERGES ----------
    ws['!merges'] = [];

    // fixed headers rowspan
    for (let i = 0; i < 6; i++) {
        ws['!merges'].push({ s: { r: 0, c: i }, e: { r: 1, c: i } });
    }

    // copy headers colspan
    let col = 6;
    g_copies.forEach(() => {
        ws['!merges'].push({
            s: { r: 0, c: col },
            e: { r: 0, c: col + g_copyFields.length - 1 }
        });
        col += g_copyFields.length;
    });

    XLSX.utils.book_append_sheet(wb, ws, "Securitization");
    XLSX.writeFile(wb, "Securitization_Tracking.xlsx");

    return false;
}


function sectrack_BindPivotGrid_OLD() {
    $('#load1').show();
    $.ajax({
        type: "POST",
        url: "SecuritizationTracking.aspx/GetAllSecuritizationData",
        dataType: "json",
        contentType: "application/json",
        success: function (res) {
            var raw = JSON.parse(res.d);
            let copies = [...new Set(raw.map(r => r["Copies"]))];

            // --- Build thead properly so headers align (put this before DataTable init)
            // Clear any existing DataTable to avoid duplicate initialization
            if ($.fn.DataTable.isDataTable('#sectracking_table')) {
                $('#sectracking_table').DataTable().clear().destroy();
            }

            // ensure table thead is clean
            $('#sectracking_table thead').empty();

            // create the two header rows
            const $topTr = $('<tr id="hdrTop"></tr>');
            const $subTr = $('<tr id="hdrSub"></tr>');

            // Fixed first 6 headers should span both rows
            const fixedHeaders = [
                "Deal #", "Client", "Sales Person", "Client Deal #", "Loan Count", "Task Name"
            ];
            fixedHeaders.forEach(h => {
                $topTr.append(`<th rowspan="2">${h}</th>`);
            });

            // If no copies, still append an empty placeholder so structure remains valid
            if (copies.length === 0) {
                $topTr.append('<th colspan="1">No Copies</th>');
                $subTr.append('<th> </th>');
            } else {
                // For each copy add a grouped header with colspan = number of fields
                copies.forEach(c => {
                    $topTr.append(`<th colspan="${copyFields.length}">${c}</th>`);
                });

                // Sub header — one <th> per copyField for each copy
                copies.forEach(c => {
                    copyFields.forEach(f => {
                        $subTr.append(`<th>${f}</th>`);
                    });
                });
            }

            // Append constructed rows into the thead
            $('#sectracking_table thead').append($topTr).append($subTr);

            //  Step 4: Pivot rows into ONE row per deal
            let pivot = {};

            raw.forEach(r => {

                let key = r["Deal #"];

                if (!pivot[key]) {
                    // Create base row
                    pivot[key] = {
                        "Deal #": r["Deal #"],
                        "Client": r["Client"],
                        "Sales Person": r["Sales Person"],
                        "Client Deal #": r["Client Deal #"],
                        "Loan Count": r["Loan Count"],
                        "Task Name": r["Task Name"]
                    };
                }

                // ensure all copy fields exist for each copy in pivot (initialize)
                copies.forEach(copyName => {
                    copyFields.forEach(f => {
                        // Initialize only if not already present
                        const keyName = `${copyName}_${f}`;
                        if (pivot[key][keyName] === undefined) pivot[key][keyName] = "";
                    });
                });

                // Then fill only the copy that exists in the SQL row
                let c = r["Copies"]; // e.g., "Copy 1"
                if (c) {
                    copyFields.forEach(f => {
                        pivot[key][`${c}_${f}`] = r[f] ?? "";
                    });
                }
            });

            let finalData = Object.values(pivot);

            //  Step 5: Build DataTables column definitions
            let dtCols = [
                { data: "Deal #", title: "Deal #" },
                { data: "Client", title: "Client" },
                { data: "Sales Person", title: "Sales Person" },
                { data: "Client Deal #", title: "Client Deal #" },
                { data: "Loan Count", title: "Loan Count" },
                { data: "Task Name", title: "Task Name" }
            ];

            copies.forEach(c => {
                copyFields.forEach(f => {
                    dtCols.push({
                        data: `${c}_${f}`,
                        title: f
                    });
                });
            });

            //  Step 6: Initialize DataTable
            $('#sectracking_table').DataTable({
                data: finalData,
                columns: dtCols,
                scrollX: true,
                autoWidth: false,
                paging: true,

                dom: 'Bfrtip',   // ✅ REQUIRED FOR EXPORT BUTTON

                buttons: [
                    {
                        extend: 'excelHtml5',
                        text: 'Export to Excel',
                        filename: 'Securitization_Tracking',
                        title: null,

                        exportOptions: {
                            columns: ':visible'
                        },

                        customize: function (xlsx) {

                            var sheet = xlsx.xl.worksheets['sheet1.xml'];
                            var $sheet = $(sheet);

                            // Row indexes in Excel (1-based)
                            var topHeaderRow = 1;
                            var subHeaderRow = 2;

                            // Fixed columns count
                            var fixedColCount = 6;

                            // Merge fixed headers vertically (rowspan=2)
                            for (var i = 0; i < fixedColCount; i++) {
                                var col = String.fromCharCode(65 + i); // A, B, C...
                                $sheet.find('mergeCells').append(
                                    '<mergeCell ref="' + col + topHeaderRow + ':' + col + subHeaderRow + '"/>'
                                );
                            }

                            // Dynamic copy columns
                            var colIndex = fixedColCount;
                            var copyFieldCount = copyFields.length;

                            copies.forEach(function (copyName) {

                                var startCol = String.fromCharCode(65 + colIndex);
                                var endCol = String.fromCharCode(65 + colIndex + copyFieldCount - 1);

                                // Merge copy group header horizontally
                                $sheet.find('mergeCells').append(
                                    '<mergeCell ref="' + startCol + topHeaderRow + ':' + endCol + topHeaderRow + '"/>'
                                );

                                colIndex += copyFieldCount;
                            });

                            // Update mergeCells count
                            var mergeCount = $sheet.find('mergeCell').length;
                            $sheet.find('mergeCells').attr('count', mergeCount);
                        }
                    }
                ],

                initComplete: function () {
                    $('#load1').hide();
                },

                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    // Use CSS property 'white-space' via css('white-space', 'nowrap')
                    $(nRow).children("td").css("white-space", "nowrap");
                    $(nRow).children("td").css("text-align", "center");
                },
            });

        },
        error: function (xhr, status, err) {
            console.error('Error fetching data:', status, err);
            $('#load1').hide();
        }
    });
}

function sectrack_BindPivotGrid_Core() {
    $('#load1').show();
    $.ajax({
        type: "POST",
        url: "SecuritizationTracking.aspx/GetAllSecuritizationData",
        dataType: "json",
        contentType: "application/json",
        success: function (res) {
            var raw = JSON.parse(res.d);
            let copies = [...new Set(raw.map(r => r["Copies"]))];

            // --- Build thead properly so headers align (put this before DataTable init)
            // Clear any existing DataTable to avoid duplicate initialization
            if ($.fn.DataTable.isDataTable('#sectracking_table')) {
                $('#sectracking_table').DataTable().clear().destroy();
            }

            // ensure table thead is clean
            $('#sectracking_table thead').empty();

            // create the two header rows
            const $topTr = $('<tr id="hdrTop"></tr>');
            const $subTr = $('<tr id="hdrSub"></tr>');

            // Fixed first 6 headers should span both rows
            const fixedHeaders = [
                "Deal #", "Client", "Sales Person", "Client Deal #", "Loan Count", "Task Name"
            ];
            fixedHeaders.forEach(h => {
                $topTr.append(`<th rowspan="2">${h}</th>`);
            });

            // If no copies, still append an empty placeholder so structure remains valid
            if (copies.length === 0) {
                $topTr.append('<th colspan="1">No Copies</th>');
                $subTr.append('<th> </th>');
            } else {
                // For each copy add a grouped header with colspan = number of fields
                copies.forEach(c => {
                    $topTr.append(`<th colspan="${copyFields.length}">${c}</th>`);
                });

                // Sub header — one <th> per copyField for each copy
                copies.forEach(c => {
                    copyFields.forEach(f => {
                        $subTr.append(`<th>${f}</th>`);
                    });
                });
            }

            // Append constructed rows into the thead
            $('#sectracking_table thead').append($topTr).append($subTr);

            //  Step 4: Pivot rows into ONE row per deal
            let pivot = {};

            raw.forEach(r => {

                let key = r["Deal #"];

                if (!pivot[key]) {
                    // Create base row
                    pivot[key] = {
                        "Deal #": r["Deal #"],
                        "Client": r["Client"],
                        "Sales Person": r["Sales Person"],
                        "Client Deal #": r["Client Deal #"],
                        "Loan Count": r["Loan Count"],
                        "Task Name": r["Task Name"]
                    };
                }

                // ensure all copy fields exist for each copy in pivot (initialize)
                copies.forEach(copyName => {
                    copyFields.forEach(f => {
                        // Initialize only if not already present
                        const keyName = `${copyName}_${f}`;
                        if (pivot[key][keyName] === undefined) pivot[key][keyName] = "";
                    });
                });

                // Then fill only the copy that exists in the SQL row
                let c = r["Copies"]; // e.g., "Copy 1"
                if (c) {
                    copyFields.forEach(f => {
                        pivot[key][`${c}_${f}`] = r[f] ?? "";
                    });
                }
            });

            let finalData = Object.values(pivot);

            //  Step 5: Build DataTables column definitions
            let dtCols = [
                { data: "Deal #", title: "Deal #" },
                { data: "Client", title: "Client" },
                { data: "Sales Person", title: "Sales Person" },
                { data: "Client Deal #", title: "Client Deal #" },
                { data: "Loan Count", title: "Loan Count" },
                { data: "Task Name", title: "Task Name" }
            ];

            copies.forEach(c => {
                copyFields.forEach(f => {
                    dtCols.push({
                        data: `${c}_${f}`,
                        title: f
                    });
                });
            });

            //  Step 6: Initialize DataTable
            $('#sectracking_table').DataTable({
                data: finalData,
                columns: dtCols,
                scrollX: true,
                autoWidth: false,
                paging: true,

                dom: 'Bfrtip',   // ✅ REQUIRED FOR EXPORT BUTTON

                buttons: [
                    {
                        extend: 'excelHtml5',
                        text: 'Export',
                        filename: 'Securitization_Tracking',
                        title: null,
                        exportOptions: {
                            columns: ':visible'
                        }
                    }
                ],

                initComplete: function () {
                    $('#load1').hide();
                },

                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    // Use CSS property 'white-space' via css('white-space', 'nowrap')
                    $(nRow).children("td").css("white-space", "nowrap");
                    $(nRow).children("td").css("text-align", "center");
                },
            });

        },
        error: function (xhr, status, err) {
            console.error('Error fetching data:', status, err);
            $('#load1').hide();
        }
    });
}


/*--------------- Securitization Summary ---------------*/

function secsummary_bindyear() {
    var start = new Date().getFullYear();

    var select = document.getElementById("secsummary_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#secsummary_year").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#secsummary_year").append($("<option></option>").val(i).html(i));
    }
}

function ResetSecuritizationSummary() {

    $('#secsummary_month').val('');
    $('#secsummary_year').val('');

    if ($.fn.DataTable.isDataTable('#secsummary_rel')) {
        $('#secsummary_rel').DataTable().clear().destroy();
    }

    if ($.fn.DataTable.isDataTable('#secsummary_sec')) {
        $('#secsummary_sec').DataTable().clear().destroy();
    }

    $('#secsummary_rel_head').empty();
    $('#secsummary_sec_head').empty();

    $('#secsummary_rel tbody').remove();
    $('#secsummary_sec tbody').remove();
}

function secsummary_BindAllGrids() {
    secsummary_BindRelGrid();
    secsummary_BindSecGrid();
    return false;
}

function secsummary_BindRelGrid() {
    $('#load1').show();

    const month = $("#secsummary_month").val();
    const year = $("#secsummary_year").val();

    if (!month) {
        alert("Please select month");
        $('#load1').hide();
        return false;
    }
    if (!year) {
        alert("Please select year");
        $('#load1').hide();
        return false;
    }

    const monthNum = parseMonth(month);
    if (isNaN(monthNum)) {
        alert("Invalid month selection");
        $('#load1').hide();
        return false;
    }

    $.ajax({
        url: "SecuritizationSummary.aspx/GetSecurutizationSummary_RelLetter",
        type: "POST",
        data: JSON.stringify({ Month: month, Year: year }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            let rows;
            try {
                rows = JSON.parse(data.d);
            } catch (e) {
                console.error("Failed to parse response:", e);
                $('#load1').hide();
                return;
            }

            if (!rows || rows.length === 0) {
                $('#load1').hide();
                return;
            }

            const sample = rows[0];
            const dateCols = Object.keys(sample).filter(k => /^\d{1,2}-[A-Za-z]{3}$/.test(k));

            if (dateCols.length === 0) {
                $('#load1').hide();
                return;
            }

            const mIndex = monthNum - 1;
            const yearNum = parseInt(year, 10);

            const dateObjects = dateCols.map(k => {
                const day = parseInt(k.split('-')[0], 10);
                return { key: k, date: new Date(yearNum, mIndex, day) };
            });

            dateObjects.sort((a, b) => a.date - b.date);

            const weeksMap = groupByWeekOfMonth(dateObjects);
            const weekIndices = Object.keys(weeksMap).map(Number).sort((a, b) => a - b);

            const { theadHTML, columns } = buildTableStructure(weeksMap, weekIndices, sample);

            $("#secsummary_rel_head").html(theadHTML);

            if ($.fn.DataTable.isDataTable('#secsummary_rel')) {
                $('#secsummary_rel').DataTable().destroy();
            }

            $('#secsummary_rel').DataTable({
                scrollX: true,
                paging: false,
                autoWidth: true,
                ordering: false,
                data: rows,
                columns: columns,
                dom: 'Bt',
                buttons: [
                    {
                        extend: 'excelHtml5',
                        text: 'Export',
                        title: "Monthly Report"
                    }
                ],
                initComplete: function () {
                    $('#load1').hide();
                }
            });
        },
        error: function (xhr, status, err) {
            console.error(err);
            $('#load1').hide();
        }
    });

    return false;
}

// ---------- Helpers ----------

function parseMonth(month) {
    const monthNum = parseInt(month, 10);
    if (!isNaN(monthNum)) return monthNum;

    const mNames = {
        Jan: 1, Feb: 2, Mar: 3, Apr: 4, May: 5, Jun: 6,
        Jul: 7, Aug: 8, Sep: 9, Oct: 10, Nov: 11, Dec: 12
    };
    return mNames[month.substring(0, 3)] || NaN;
}

function getWeekOfMonth(date) {
    const firstOfMonth = new Date(date.getFullYear(), date.getMonth(), 1);
    const mondayIndex = (d) => (d.getDay() + 6) % 7;
    const firstMonIdx = mondayIndex(firstOfMonth);
    const dayNumber = date.getDate();
    return Math.floor((dayNumber + firstMonIdx - 1) / 7) + 1;
}

function groupByWeekOfMonth(dateObjects) {
    const weeksMap = {};
    dateObjects.forEach(obj => {
        const w = getWeekOfMonth(obj.date);
        if (!weeksMap[w]) weeksMap[w] = [];
        weeksMap[w].push(obj.key);
    });
    return weeksMap;
}

function buildTableStructure(weeksMap, weekIndices) {
    let headRow1 = '<tr><th rowspan="2">ClientName</th><th rowspan="2">Brought forward from Previous Month</th>';
    let headRow2 = '<tr>';

    const columns = [
        { data: "ClientName" },
        { data: "Brought forward from Previous Month" }
    ];

    weekIndices.forEach(w => {
        const arr = weeksMap[w];
        headRow1 += `<th colspan="${arr.length}">Week ${w}</th>`;
        arr.forEach(k => {
            headRow2 += `<th>${k}</th>`;
            columns.push({ data: k });
        });
    });

    headRow1 += '<th rowspan="2">Grand Total</th><th rowspan="2">Avg/Day</th></tr>';
    headRow2 += '</tr>';

    columns.push({ data: "Grand Total" });
    columns.push({ data: "Avg/Day" });

    const theadHTML = headRow1 + headRow2;
    return { theadHTML, columns };
}

function secsummary_BindSecGrid() {
    $('#load1').show();

    const month = $("#secsummary_month").val();
    const year = $("#secsummary_year").val();

    if (!month) {
        alert("Please select month");
        $('#load1').hide();
        return false;
    }
    if (!year) {
        alert("Please select year");
        $('#load1').hide();
        return false;
    }

    const monthNum = parseMonth(month);
    if (isNaN(monthNum)) {
        alert("Invalid month selection");
        $('#load1').hide();
        return false;
    }

    $.ajax({
        url: "SecuritizationSummary.aspx/GetSecurutizationSummary_Sec",
        type: "POST",
        data: JSON.stringify({ Month: month, Year: year }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            let rows;
            try {
                rows = JSON.parse(data.d);
            } catch (e) {
                console.error("Failed to parse response:", e);
                $('#load1').hide();
                return;
            }

            if (!rows || rows.length === 0) {
                $('#load1').hide();
                return;
            }

            const sample = rows[0];
            const dateCols = Object.keys(sample).filter(k => /^\d{1,2}-[A-Za-z]{3}$/.test(k));

            if (dateCols.length === 0) {
                $('#load1').hide();
                return;
            }

            const mIndex = monthNum - 1;
            const yearNum = parseInt(year, 10);

            const dateObjects = dateCols.map(k => {
                const day = parseInt(k.split('-')[0], 10);
                return { key: k, date: new Date(yearNum, mIndex, day) };
            });

            dateObjects.sort((a, b) => a.date - b.date);

            const weeksMap = groupByWeekOfMonth(dateObjects);
            const weekIndices = Object.keys(weeksMap).map(Number).sort((a, b) => a - b);

            const { theadHTML, columns } = buildTableStructure(weeksMap, weekIndices, sample);

            $("#secsummary_sec_head").html(theadHTML);

            if ($.fn.DataTable.isDataTable('#secsummary_sec')) {
                $('#secsummary_sec').DataTable().destroy();
            }

            $('#secsummary_sec').DataTable({
                scrollX: true,
                paging: false,
                autoWidth: true,
                ordering: false,
                data: rows,
                columns: columns,
                dom: 'Bt',
                buttons: [
                    {
                        extend: 'excelHtml5',
                        text: 'Export',
                        title: "Monthly Report"
                    }
                ],
                initComplete: function () {
                    $('#load1').hide();
                }
            });
        },
        error: function (xhr, status, err) {
            console.error(err);
            $('#load1').hide();
        }
    });

    return false;
}

function core_secsummary_BindRelGrid() {
    $('#load1').show();

    var month = $("#secsummary_month").val();
    var year = $("#secsummary_year").val();

    if (!month) { alert("Please select month"); $('#load1').hide(); return; }
    if (!year) { alert("Please select year"); $('#load1').hide(); return; }

    $.ajax({
        url: "SecuritizationSummary.aspx/GetSecurutizationSummary_RelLetter",
        type: "POST",
        data: JSON.stringify({ Month: month, Year: year }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            let rows = JSON.parse(data.d);
            if (!rows || rows.length === 0) {
                $('#load1').hide();
                return;
            }

            // sample object to pick column keys
            let sample = rows[0];

            // 1) detect date-like keys (e.g. "1-Oct", "14-Oct")
            let dateCols = Object.keys(sample).filter(k => /^\d{1,2}-[A-Za-z]{3}$/.test(k));

            // convert dateCols to real Date objects *in this month/year*
            // We'll parse by creating Date(year, monthIndex, day)
            // month is string (e.g. "10" or "Oct") depending on how your dropdown returns it.
            // We'll assume numeric month (1-12). If you store month names, adapt accordingly.
            var monthNum = parseInt(month, 10); // expecting 1..12
            if (isNaN(monthNum)) {
                // try parse short month name (e.g. "Oct")
                const mNames = { Jan: 1, Feb: 2, Mar: 3, Apr: 4, May: 5, Jun: 6, Jul: 7, Aug: 8, Sep: 9, Oct: 10, Nov: 11, Dec: 12 };
                monthNum = mNames[month.substring(0, 3)] || 1;
            }
            const mIndex = monthNum - 1;

            // build an array of {key: "1-Oct", dateObj: Date}
            let dateObjects = dateCols.map(k => {
                const day = parseInt(k.split('-')[0], 10);
                return { key: k, date: new Date(year, mIndex, day) };
            });

            // sort by day
            dateObjects.sort((a, b) => a.date - b.date);

            // 2) compute week-of-month index for each date (weeks start Monday)
            function getWeekOfMonth(date) {
                // date is a JS Date for the day in the month
                const firstOfMonth = new Date(date.getFullYear(), date.getMonth(), 1);

                // Convert JS getDay to Monday-based index: Mon=0, Tue=1, ..., Sun=6
                function mondayIndex(d) { return (d.getDay() + 6) % 7; }

                const firstMonIdx = mondayIndex(firstOfMonth); // 0..6 offset of first day from Monday
                const dayNumber = date.getDate(); // 1..31

                // Week index formula:
                return Math.floor((dayNumber + firstMonIdx - 1) / 7) + 1;
            }

            // group by week index (relative to month)
            let weeksMap = {};
            dateObjects.forEach(obj => {
                const w = getWeekOfMonth(obj.date);
                if (!weeksMap[w]) weeksMap[w] = [];
                weeksMap[w].push(obj.key);
            });

            // 3) Build thead: first row with Week headers (colspan), second row with each date column
            let headRow1 = '<tr><th rowspan="2">ClientName</th><th rowspan="2">Brought forward from Previous Month</th>';
            let headRow2 = '<tr>';

            // ensure weeks are in ascending order
            const weekIndices = Object.keys(weeksMap).map(Number).sort((a, b) => a - b);
            weekIndices.forEach(w => {
                const arr = weeksMap[w];
                headRow1 += `<th colspan="${arr.length}">Week ${w}</th>`;
                arr.forEach(k => headRow2 += `<th>${k}</th>`);
            });

            headRow1 += '<th rowspan="2">Grand Total</th><th rowspan="2">Avg/Day</th></tr>';
            headRow2 += '</tr>';

            // inject head into table (table must have <thead id="secsummary_rel_head"></thead>)
            $("#secsummary_rel_head").html(headRow1 + headRow2);

            // 4) Build DataTables columns mapping (must match order of header)
            let columns = [
                { data: "ClientName" },
                { data: "Brought forward from Previous Month" }
            ];

            // push date columns in order we used in the header
            weekIndices.forEach(w => {
                weeksMap[w].forEach(k => columns.push({ data: k }));
            });

            columns.push({ data: "Grand Total" });
            columns.push({ data: "Avg/Day" });

            // 5) init DataTable
            if ($.fn.DataTable.isDataTable('#secsummary_rel')) {
                $('#secsummary_rel').DataTable().destroy();
            }

            $('#secsummary_rel').DataTable({

                scrollX: true,
                paging: false,
                autoWidth: true,
                aaSorting: [],
                data: rows,
                columns: columns,
                dom: 'Bt',
                buttons: [
                    {
                        extend: 'excelHtml5',
                        text: 'Export',
                        title: "Monthly Report"

                    }],
                initComplete: function () {
                    $('#load1').hide();
                }
            });
        },
        error: function (xhr, status, err) {
            console.error(err);
            $('#load1').hide();
        }
    });

    return false;
}

function core_secsummary_BindSecGrid() {
    $('#load1').show();

    var month = $("#secsummary_month").val();
    var year = $("#secsummary_year").val();

    if (!month) { alert("Please select month"); $('#load1').hide(); return; }
    if (!year) { alert("Please select year"); $('#load1').hide(); return; }

    $.ajax({
        url: "SecuritizationSummary.aspx/GetSecurutizationSummary_Sec",
        type: "POST",
        data: JSON.stringify({ Month: month, Year: year }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            let rows = JSON.parse(data.d);
            if (!rows || rows.length === 0) {
                $('#load1').hide();
                return;
            }

            // sample object to pick column keys
            let sample = rows[0];

            // 1) detect date-like keys (e.g. "1-Oct", "14-Oct")
            let dateCols = Object.keys(sample).filter(k => /^\d{1,2}-[A-Za-z]{3}$/.test(k));

            // convert dateCols to real Date objects *in this month/year*
            // We'll parse by creating Date(year, monthIndex, day)
            // month is string (e.g. "10" or "Oct") depending on how your dropdown returns it.
            // We'll assume numeric month (1-12). If you store month names, adapt accordingly.
            var monthNum = parseInt(month, 10); // expecting 1..12
            if (isNaN(monthNum)) {
                // try parse short month name (e.g. "Oct")
                const mNames = { Jan: 1, Feb: 2, Mar: 3, Apr: 4, May: 5, Jun: 6, Jul: 7, Aug: 8, Sep: 9, Oct: 10, Nov: 11, Dec: 12 };
                monthNum = mNames[month.substring(0, 3)] || 1;
            }
            const mIndex = monthNum - 1;

            // build an array of {key: "1-Oct", dateObj: Date}
            let dateObjects = dateCols.map(k => {
                const day = parseInt(k.split('-')[0], 10);
                return { key: k, date: new Date(year, mIndex, day) };
            });

            // sort by day
            dateObjects.sort((a, b) => a.date - b.date);

            // 2) compute week-of-month index for each date (weeks start Monday)
            function getWeekOfMonth(date) {
                // date is a JS Date for the day in the month
                const firstOfMonth = new Date(date.getFullYear(), date.getMonth(), 1);

                // Convert JS getDay to Monday-based index: Mon=0, Tue=1, ..., Sun=6
                function mondayIndex(d) { return (d.getDay() + 6) % 7; }

                const firstMonIdx = mondayIndex(firstOfMonth); // 0..6 offset of first day from Monday
                const dayNumber = date.getDate(); // 1..31

                // Week index formula:
                return Math.floor((dayNumber + firstMonIdx - 1) / 7) + 1;
            }

            // group by week index (relative to month)
            let weeksMap = {};
            dateObjects.forEach(obj => {
                const w = getWeekOfMonth(obj.date);
                if (!weeksMap[w]) weeksMap[w] = [];
                weeksMap[w].push(obj.key);
            });

            // 3) Build thead: first row with Week headers (colspan), second row with each date column
            let headRow1 = '<tr><th rowspan="2">ClientName</th><th rowspan="2">Brought forward from Previous Month</th>';
            let headRow2 = '<tr>';

            // ensure weeks are in ascending order
            const weekIndices = Object.keys(weeksMap).map(Number).sort((a, b) => a - b);
            weekIndices.forEach(w => {
                const arr = weeksMap[w];
                headRow1 += `<th colspan="${arr.length}">Week ${w}</th>`;
                arr.forEach(k => headRow2 += `<th>${k}</th>`);
            });

            headRow1 += '<th rowspan="2">Grand Total</th><th rowspan="2">Avg/Day</th></tr>';
            headRow2 += '</tr>';

            // inject head into table (table must have <thead id="secsummary_rel_head"></thead>)
            $("#secsummary_sec_head").html(headRow1 + headRow2);

            // 4) Build DataTables columns mapping (must match order of header)
            let columns = [
                { data: "ClientName" },
                { data: "Brought forward from Previous Month" }
            ];

            // push date columns in order we used in the header
            weekIndices.forEach(w => {
                weeksMap[w].forEach(k => columns.push({ data: k }));
            });

            columns.push({ data: "Grand Total" });
            columns.push({ data: "Avg/Day" });

            // 5) init DataTable
            if ($.fn.DataTable.isDataTable('#secsummary_sec')) {
                $('#secsummary_sec').DataTable().destroy();
            }

            $('#secsummary_sec').DataTable({
                scrollX: true,
                paging: false,
                autoWidth: true,
                aaSorting: [],
                data: rows,
                columns: columns,
                dom: 'Bt',
                buttons: [
                    {
                        extend: 'excelHtml5',
                        text: 'Export',
                        title: "Monthly Report"

                    }],
                initComplete: function () {
                    $('#load1').hide();
                }
            });
        },
        error: function (xhr, status, err) {
            console.error(err);
            $('#load1').hide();
        }
    });

    return false;
}

function excelColumnName(n) {
    let col = "";
    while (n >= 0) {
        col = String.fromCharCode((n % 26) + 65) + col;
        n = Math.floor(n / 26) - 1;
    }
    return col;
}

// helper: get ISO week number
function getWeekNumber(date) {
    date = new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate()));
    let dayNum = date.getUTCDay() || 7;
    date.setUTCDate(date.getUTCDate() + 4 - dayNum);
    let yearStart = new Date(Date.UTC(date.getUTCFullYear(), 0, 1));
    return Math.ceil((((date - yearStart) / 86400000) + 1) / 7);
}


function secsummary_Exporttoexcel() {
    $("#waitingpanel").modal("show");
    var month = $("#secsummary_month").val();
    var year = $("#secsummary_year").val();
    document.getElementById("spntext").innerHTML = "System is generating excel. Please wait";
    PageMethods.GenerateExcel(month, year, sec_genExcel_OnSuccess, sec_genExcel_OnError);
    return false;
}

function sec_genExcel_OnSuccess(result) {
    $("#waitingpanel").modal("hide");
    sec_genExcel_senttoclient();
    return false;
}

function sec_genExcel_OnError(error) {
    alert(error.responseText);
}














