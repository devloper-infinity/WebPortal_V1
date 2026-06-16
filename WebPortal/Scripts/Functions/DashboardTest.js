
let dashboardAlerts = [];
let currentAlertIndex = 0;

console.log('JS loaded');

document.addEventListener("DOMContentLoaded", async () => {

    const dashboard = document.getElementById("dash_board");
    const onlyMgmt = document.getElementById("onlymgmt");

    const managementUsers = [12, 7036, 8082, 8938];

    /* */

    try {
        await testDashboard_BindFormInformation();
        await testDashboard_GetDashboardAlerts();
    } catch (e) {
        console.error("BindForm Error:", e);
    }

    const currentusername = parseInt(document.getElementById("hdUser").innerHTML);

    dashboard.style.display = (currentusername === 10161) ? 'none' : '';

    if (managementUsers.includes(currentusername)) {

        testDashboard_GetManpowerSumary('All');
        onlyMgmt.style.display = '';
    } else {
        onlyMgmt.style.display = 'none';
    }
});

async function testDashboard_BindFormInformation() {

    try {

        const data = await apiCall("DashboardEmployee.aspx/BindInformation");

        if (!data || data.length === 0) return;

        const info = data[0];

        // 🔹 USER INFO
        document.getElementById("dashboard_spnusername").textContent = info.Name || "";
        document.getElementById("dashboard_spndesignation").textContent = info.Designation || "";

        // 🔹 USER IMAGE
        if (info.PhotoPath) {
            document.getElementById("dashboard_userimg").src = info.PhotoPath;
        }

        // 🔹 SUMMARY COUNTS (if present in your data)
        if (document.getElementById("dashboard_totalemployees"))
            document.getElementById("dashboard_totalemployees").textContent = info.TotalEmployees || 0;

        if (document.getElementById("dashboard_onfloormployees"))
            document.getElementById("dashboard_onfloormployees").textContent = info.OnFloor || 0;

        if (document.getElementById("dashboard_resignedemployees"))
            document.getElementById("dashboard_resignedemployees").textContent = info.Resigned || 0;

        if (document.getElementById("dashboard_abscondingemployees"))
            document.getElementById("dashboard_abscondingemployees").textContent = info.Absconding || 0;

        // 🔹 SHOW DASHBOARD AFTER LOAD
        const dashboard = document.getElementById("dash_board");
        if (dashboard) dashboard.style.display = "flex";

    } catch (e) {
        console.error("testDashboard_BindFormInformation Error:", e);
    }
}

async function testDashboard_GetDashboardAlerts() {

    try {

        dashboardAlerts = await apiCall("DashboardEmployee.aspx/GetDashboardAlerts");

        console.log("Alerts Data:", dashboardAlerts);

        const table = $('#dashboard_alert_table');

        // 🔹 Destroy existing DataTable (VERY IMPORTANT)
        if ($.fn.DataTable.isDataTable('#dashboard_alert_table')) {
            table.DataTable().clear().destroy();
        }

        const tbody = table.find('tbody');
        tbody.empty();

        if (!dashboardAlerts || dashboardAlerts.length === 0) {
            tbody.append(`<tr><td colspan="5" class="text-center">No alerts found</td></tr>`);
            return;
        }

        dashboardAlerts.forEach((alert, index) => {

            const row = `
                <tr>
                    <td style="display:none">${alert.AlertId}</td>
                    <td style="display:none">${index + 1}</td>
                    <td>${alert.Subject || ""}</td>

                    <td>
                        ${alert.FileName
                    ? `<a href="${alert.FilePath}" target="_blank">Download</a>`
                    : ""}
                    </td>

                    <td>
                        <a href="#!" class="view-alert" onclick="testBindAlertDetails(${alert.AlertId}, ${index})">
                            <span style="color:dodgerblue;">
                                <i class="uil uil-search-alt"></i>
                            </span>
                        </a>
                    </td>

                    <td style="display:none">${alert.FilePath || ""}</td>
                </tr>
            `;

            tbody.append(row);
        });

        // 🔥 DATATABLE INITIALIZATION (PAGING HERE)
        table.DataTable({
            pageLength: 4,
            paging: true,
            searching: false,
            lengthChange: false,
            ordering: true,
            info: false, // hide "Showing X to Y"
            autoWidth: false,
            destroy: true,

            pagingType: "simple", // 🔥 ONLY Previous & Next

            columnDefs: [
                { targets: [0, 1, 5], visible: false }
            ],
            language: {
                paginate: {
                    previous: "⬅ Prev",
                    next: "Next ➡"
                }
            }
        });

    } catch (e) {
        console.error("testDashboard_GetDashboardAlerts Error:", e);
    }
}
async function testBindAlertDetails(alertId, index = 0) {

    try {

        currentAlertIndex = index;

        const data = await apiCall("DashboardEmployee.aspx/BindAlertDetails", { AlertId: alertId });

        if (!data || data.length === 0) return;

        const alert = data[0];

        // 🔹 SET DATA
        document.getElementById("dasboard_popalertsubject").textContent = alert.Subject || "";
        document.getElementById("dasboard_popalertmessage").textContent = alert.Message || "";

        // 🔹 ATTACHMENT HANDLING
        const attachmentDiv = document.getElementById("attachmentDiv");
        const downloadLink = document.getElementById("downloadFile");

        if (alert.FilePath) {

            attachmentDiv.style.display = "block";
            downloadLink.href = alert.FilePath;

        } else {

            attachmentDiv.style.display = "none";
        }

        // 🔹 OPEN MODAL
        const modal = new bootstrap.Modal(document.getElementById("alertModal"));
        modal.show();

    } catch (e) {
        console.error("testBindAlertDetails Error:", e);
    }
}

async function core_testDashboard_GetManpowerSumary(type = "All") {

    try {

        // 🔹 Update dropdown text
        const header = document.getElementById("summary_gridheaderfilter");
        if (header) {
            header.textContent =
                type === "All" ? "All Employees" :
                    type === "Present" ? "Present Today" :
                        type === "Leave" ? "Users on Leave" : type;
        }

        // 🔹 API CALL
        const data = await apiCall("DashboardEmployee.aspx/CurrentManpowerSummary", { Type: type });

        const tabledata = $('#dasboard_currentmanpower');
        const tbody = document.querySelector("#dasboard_currentmanpower tbody");
        if (!tbody) return;

        tbody.innerHTML = "";

        if (!data || data.length === 0) {

            const tr = document.createElement("tr");
            tr.innerHTML = `<td colspan="10" class="text-center">No data available</td>`;
            tbody.appendChild(tr);
            return;
        }

        let totalEmployees = 0;
        let totalOnFloor = 0;
        let totalResigned = 0;
        let totalAbsconding = 0;

        // 🔹 LOOP DATA
        data.forEach((row, index) => {

            totalEmployees += Number(row.Total || 0);
            totalOnFloor += Number(row.OnFloor || 0);
            totalResigned += Number(row.Resigned || 0);
            totalAbsconding += Number(row.Absconding || 0);

            const tr = document.createElement("tr");

            tr.innerHTML = `
                <td style="display:none">${index + 1}</td>
                <td style="display:none"></td>
                <td style="display:none"></td>
                <td>${row.BranchName || ""}</td>
                <td>${row.DomainGroupName || ""}</td>
                <td>${row.Subdomain || ""}</td>
                <td class="text-center">${row.Total || 0}</td>
                <td class="text-center">${row.OnFloor || 0}</td>
                <td class="text-center">${row.Resigned || 0}</td>
                <td class="text-center">${row.Absconding || 0}</td>
            `;

            tbody.appendChild(tr);
        });

        tabledata.DataTable({
            pageLength: 10,
            paging: true,
            searching: false,
            lengthChange: false,
            ordering: true,
            info: false, // hide "Showing X to Y"
            autoWidth: false,
            destroy: true,

            pagingType: "simple", // 🔥 ONLY Previous & Next

            columnDefs: [
                { targets: [0, 1, 2], visible: false }
            ],
            language: {
                paginate: {
                    previous: "⬅ Prev",
                    next: "Next ➡"
                }
            }
        });

        // 🔹 UPDATE SUMMARY FOOTER
        setText("dashboard_totalemployees", totalEmployees);
        setText("dashboard_onfloormployees", totalOnFloor);
        setText("dashboard_resignedemployees", totalResigned);
        setText("dashboard_abscondingemployees", totalAbsconding);

    } catch (e) {
        console.error("testDashboard_GetManpowerSumary Error:", e);
    }

    return false;
}

async function testDashboard_GetManpowerSumary(type) {

    try {

         const data = await apiCall("DashboardEmployee.aspx/CurrentManpowerSummary", { Type: type });

      /*  const data = await apiCall("/Admin/DashboardEmployee.aspx/CurrentManpowerSummary",{ Type: type });*/

        console.log("Manpower Data:", data); // ✅ debug instead of alert

        const tbody = document.querySelector('#dasboard_currentmanpower tbody');

        if (!tbody) return;

        // ❌ NO DATA CASE
        if (!data || data.length === 0) {

            tbody.innerHTML = `<tr>
                <td colspan="10" class="text-center">No data available</td>
            </tr>`;

            return;
        }

        let html = "";
        let i = 0;

        let summary_total = 0;
        let summary_onfloor = 0;
        let summary_resigned = 0;
        let summary_absconding = 0;

        data.forEach((row) => {

            i++;

            html += `
            <tr>
                <td style="display:none;">${blankForNull(row.DomainId)}</td>
                <td style="display:none;">${blankForNull(row.WorkingBranch)}</td>
                <td style="display:none;">${i}</td>

                <td>${blankForNull(row.BranchName)}</td>
                <td>${blankForNull(row.DomainGroupName)}</td>
                <td>${blankForNull(row.Subdomain)}</td>

                <td style="text-align:center;">
                    <a href="#!" onclick="summary_totalclick(${row.WorkingBranch},${row.DomainId},'${row.Subdomain}',1)">
                        ${blankForNull(row.Total)}
                    </a>
                </td>

                <td style="text-align:center;">
                    <a href="#!" onclick="summary_totalclick(${row.WorkingBranch},${row.DomainId},'${row.Subdomain}',2)">
                        ${blankForNull(row.OnFloor)}
                    </a>
                </td>

                <td style="text-align:center;">
                    <a href="#!" onclick="summary_totalclick(${row.WorkingBranch},${row.DomainId},'${row.Subdomain}',3)">
                        ${blankForNull(row.Resigned)}
                    </a>
                </td>

                <td style="text-align:center;">
                    <a href="#!" onclick="summary_totalclick(${row.WorkingBranch},${row.DomainId},'${row.Subdomain}',4)">
                        ${blankForNull(row.Absconding)}
                    </a>
                </td>
            </tr>`;

            summary_total += Number(row.Total || 0);
            summary_onfloor += Number(row.OnFloor || 0);
            summary_resigned += Number(row.Resigned || 0);
            summary_absconding += Number(row.Absconding || 0);

            document.getElementById("dashboard_graphperiod").innerHTML =
                'Period: ' + blankForNull(row.Period);
        });

        // 🔥 DESTROY OLD TABLE
        if ($.fn.DataTable.isDataTable('#dasboard_currentmanpower')) {
            $('#dasboard_currentmanpower').DataTable().clear().destroy();
        }

        // 🔥 BIND DATA
        tbody.innerHTML = html;

        // 🔥 DATATABLE CONFIG (ERP CLEAN)
        $('#dasboard_currentmanpower').DataTable({
            paging: true,
            pagingType: "simple",   // ✅ only Prev / Next
            pageLength: 10,
            searching: false,       // ❌ remove search
            lengthChange: false,    // ❌ remove dropdown
            ordering: false,
            info: false,            // ❌ remove "Showing X"
            autoWidth: true,
            destroy: true,
            scrollX: true
        });

        // 🔹 UPDATE SUMMARY
        document.getElementById("dashboard_totalemployees").innerHTML = summary_total;
        document.getElementById("dashboard_onfloormployees").innerHTML = summary_onfloor;
        document.getElementById("dashboard_resignedemployees").innerHTML = summary_resigned;
        document.getElementById("dashboard_abscondingemployees").innerHTML = summary_absconding;

        // 🔹 HEADER TEXT
        let headerText = "All Employees";
        if (type === "Present") headerText = "Present Today";
        if (type === "Leave") headerText = "Users on Leave";

        document.getElementById("summary_gridheaderfilter").innerHTML = headerText;

        document.getElementById('load1').style.display = 'none';

    } catch (error) {

        console.error("Dashboard_GetManpowerSumary Error:", error);
        document.getElementById('load1').style.display = 'none';
    }

    return false;
}
function setText(id, value) {
    const el = document.getElementById(id);
    if (el) el.textContent = value;
}

function changePage(page) {

    const totalPages = Math.ceil(dashboardAlerts.length / rowsPerPage);

    if (page < 1 || page > totalPages) return;

    currentPage = page;

    renderAlertsTable();
}

function renderPagination() {

    const totalPages = Math.ceil(dashboardAlerts.length / rowsPerPage);

    let paginationDiv = document.getElementById("alertPagination");

    if (!paginationDiv) {
        paginationDiv = document.createElement("div");
        paginationDiv.id = "alertPagination";
        paginationDiv.className = "text-center mt-2";
        document.getElementById("dashboard_alert_table").after(paginationDiv);
    }

    paginationDiv.innerHTML = `
        <button class="btn btn-sm btn-secondary" ${currentPage === 1 ? "disabled" : ""}
            onclick="changePage(${currentPage - 1})">Prev</button>

        <span style="margin:0 10px;">Page ${currentPage} of ${totalPages}</span>

        <button class="btn btn-sm btn-secondary" ${currentPage === totalPages ? "disabled" : ""}
            onclick="changePage(${currentPage + 1})">Next</button>
    `;
}

// ==============================
// 🔹 COMMON API FUNCTION
// ==============================
async function apiCall(url, data = {}) {

    try {

        const response = await fetch(url, {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(data)
        });

        const result = await response.json();

        return JSON.parse(result.d);

    } catch (error) {
        console.error("API CALL ERROR:", url, error);
        return [];
    }
}
