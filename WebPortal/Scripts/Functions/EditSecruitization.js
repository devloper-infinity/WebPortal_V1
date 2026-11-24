
var secureID = 0;

var editSectracking_html;
var editSectracking_table;
var editSectrackNoticeTimer;

/* In-page notices avoid browser dialogs, which can be suppressed by browsers. */
function editSectrackEnsureNoticeUI() {
    if (!document.getElementById("editSectrackNoticeStyles")) {
        var style = document.createElement("style");
        style.id = "editSectrackNoticeStyles";
        style.textContent = "#editSectrackNotice{position:fixed;top:20px;right:20px;z-index:20000;max-width:min(420px,calc(100vw - 40px));padding:14px 18px;border-radius:6px;box-shadow:0 4px 16px rgba(0,0,0,.2);color:#fff;font:14px/1.45 Arial,sans-serif;display:none}#editSectrackNotice.success{background:#218838}#editSectrackNotice.warning{background:#a66b00}#editSectrackNotice.error{background:#b02a37}#editSectrackBusy{position:fixed;top:20px;left:50%;transform:translateX(-50%);z-index:19999;padding:11px 18px;border-radius:6px;background:#263746;color:#fff;box-shadow:0 4px 16px rgba(0,0,0,.2);font:14px Arial,sans-serif;display:none}";
        document.head.appendChild(style);
    }
    if (!document.getElementById("editSectrackNotice")) {
        var notice = document.createElement("div");
        notice.id = "editSectrackNotice";
        notice.setAttribute("role", "alert");
        notice.setAttribute("aria-live", "assertive");
        document.body.appendChild(notice);
    }
    if (!document.getElementById("editSectrackBusy")) {
        var busy = document.createElement("div");
        busy.id = "editSectrackBusy";
        busy.setAttribute("role", "status");
        busy.setAttribute("aria-live", "polite");
        document.body.appendChild(busy);
    }
}

function editSectrackNotify(message, type) {
    editSectrackEnsureNoticeUI();
    var notice = document.getElementById("editSectrackNotice");
    window.clearTimeout(editSectrackNoticeTimer);
    notice.className = type || "warning";
    notice.textContent = message;
    notice.style.display = "block";
    editSectrackNoticeTimer = window.setTimeout(function () {
        notice.style.display = "none";
    }, 5000);
}

function editSectrackSetBusy(message) {
    editSectrackEnsureNoticeUI();
    var busy = document.getElementById("editSectrackBusy");
    busy.textContent = message || "";
    busy.style.display = message ? "block" : "none";
}


/*---------------- Bind Methods  ----------------*/

function editSectrack_BindDeals() {

    var select = document.getElementById("editSectrack_DealNo");
    let options = select.getElementsByTagName('editSectrack_DealNo');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#editSectrack_DealNo").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "SecuritizationBilling.aspx/GetAllDealsFromProjectTracking_Billing", dataType: "json", contentType: "application/json",
        success: function (res) {

            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (data, value) {

                $("#editSectrack_DealNo").append($("<option></option>").val(value.ClientDealName).html(value.ClientDealName));
            })
        }
    });

}

function sectrack_BindClient() {

    var select = document.getElementById("editSectrack_Project");
    let options = select.getElementsByTagName('editSectrack_Project');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#editSectrack_Project").append($("<option></option>").val("").html("Select"));

    $(document).ready(function () {
        $.ajax({
            type: "POST", url: "SecuritizationTracking.aspx/GetUWProjects", dataType: "json", contentType: "application/json",
            success: function (res) {
                var dataArray = JSON.parse(res.d);
                $.each(dataArray, function (data, value) {
                    $("#editSectrack_Project").append($("<option></option>").val(value.ProjectId).html(value.ProjectName));
                })
            }
        });
    })
}

function bindGrid_forEdit() {

    $('#load1').show();

    editSectracking_html = '';

    $.ajax({
        url: "EditSecuritizationTracking.aspx/GetReportData",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            $.each(dataArray, function (index, value) {
                editSectracking_html += '<tr>';
                editSectracking_html += '<td style="text-align:center;"><a title="Edit Deal" class="dropdown-item" href="#!" id="Actions" onclick="edit_deal(' + value.SecureID + ',' + index + ');"><span style="color: DodgerBlue;"><i class="fas fa-edit" style="font-size:16px;"></i></span></a></td>';
                editSectracking_html += '<td style="text-wrap: nowrap; display:none;">' + blankForNull(value.ProjectId) + '</td>';
                editSectracking_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.DealNo) + '</td>';//---------2
                editSectracking_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ProjectName) + '</td>';
                editSectracking_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.SalesPerson) + '</td>';
                /*editSectracking_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.OriginalClientRequestReceivedDateTime) + '</td>';*/
                editSectracking_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ClientDealName) + '</td>'; //---------  6
                editSectracking_html += '<td style="text-wrap: nowrap; text-align:center;" >' + blankForNull(value.LoanCount) + '</td>';
                editSectracking_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.TaskName) + '</td>';
                editSectracking_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Copies) + '</td>';//---------9
                editSectracking_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.RequestedDate) + '</td>';
                editSectracking_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.SLADeliveryDate) + '</td>';
                editSectracking_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.SLADeliveryDays) + '</td>';//---------12
                editSectracking_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ActualDeliveredDate) + '</td>';
                editSectracking_html += '<td style="text-wrap: nowrap; text-align:center">' + blankForNull(value.TAT) + '</td>';
                editSectracking_html += '<td style="text-wrap: nowrap; text-align:center">' + blankForNull(value.LeadingDelayedDays) + '</td>';//---------15
                editSectracking_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.SavingTAT) + '</td>';
                editSectracking_html += '<td style="text-wrap: nowrap; text-align:center">' + blankForNull(value.RLSigned) + '</td>';
                editSectracking_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.BillingHours) + '</td>';//---------18
                editSectracking_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Status) + '</td>';
                editSectracking_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Remark) + '</td>';
                editSectracking_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ClientFullNameAddress) + '</td>';//---------21
                editSectracking_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.RecipientFullNameAddress) + '</td>';
                editSectracking_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.RatingAgencyFullNameAddress) + '</td>';
                editSectracking_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#table_editSectracking')) {
                $('#table_editSectracking').DataTable().clear().destroy();
            }
            $('#table_editSectracking tbody').html(editSectracking_html);

            editSectracking_table = $('#table_editSectracking').DataTable({
                dom: 'rtip',
                destroy: true,
                scrollX: true,
                scrollCollapse: true,
                paging: true,
                pageLength: 10,
                autoWidth: false,
                deferRender: true,
                ordering: false,
                processing: true,
                select: {
                    style: 'single'
                },
                language: {
                    emptyTable: 'No securitization tracking records found',
                    info: 'Showing _START_ to _END_ of _TOTAL_ records',
                    infoEmpty: 'No records to show',
                    zeroRecords: 'No matching tracking records'
                },

                initComplete: function () {
                    $('#load1').hide();
                    if (typeof window.editSectrack_OnGridBound === "function") {
                        window.editSectrack_OnGridBound(dataArray);
                    }
                },
            });
        },

        error: function (error) {
            var details = error && error.responseText ? error.responseText : "Unable to load securitization tracking data.";
            editSectrackNotify("Error: " + details, "error");
        }
    });
    return false;
}


/*---------------- Bind Info for edit  ----------------*/
function edit_deal(secID, index) {

    secureID = secID;

    $('#table_editSectracking tr')
        .removeClass('edit-sec-selected-row')
        .css('background-color', '')
        .css('font-weight', 'normal');

    document.getElementById("editSectrack_DealNo").focus();

    var rows = editSectracking_table.row(index).data();
    var rowNode = editSectracking_table.row(index).node();

    $(rowNode).addClass('edit-sec-selected-row').css({ 'background-color': '#84d9d2', 'font-weight': 'bold' });

    if (typeof window.editSectrack_OnRecordSelected === "function") {
        window.editSectrack_OnRecordSelected(rows);
    }

    $("#editSectrack_RequestedDate").val(formatDateForInput(rows[9]));
    $("#editSectrack_SLADeliveryDate").val(formatDateForInput(rows[10]));
    $("#editSectrack_ActualDeliveredDate").val(formatDateForInput(rows[12]));

    document.getElementById("editSectrack_ClientDealName").value = rows[5];
    document.getElementById("editSectrack_NoOfLoans").value = rows[6];
    $("#editSectrack_TaskName").val(rows[7]);
    document.getElementById("editSectrack_SLADeliveryDays").value = rows[11];
    $("#editSectrack_RLSigned").val(rows[16]);
    document.getElementById("editSectrack_BillingHours").value = rows[17];
    $("#editSectrack_Status").val(rows[18]);
    document.getElementById("editSectrack_Remark").value = rows[19];

    document.getElementById("editSectrack_ClientNameAddress").value = rows[20];
    document.getElementById("editSectrack_RecipientNameAddress").value = rows[21];
    document.getElementById("editSectrack_AgencyNameAddress").value = rows[22];

    // Deal selection
    $("#editSectrack_DealNo").empty();
    $("#editSectrack_DealNo").append($("<option></option>").val("").html("Select"));
    $("#editSectrack_DealNo").append($("<option></option>").val("0").html("Add New"));

    $.ajax({
        type: "POST",
        url: "SecuritizationTracking.aspx/GetAllDealsFromProjectTracking",
        dataType: "json",
        contentType: "application/json",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                $("#editSectrack_DealNo").append(
                    $("<option></option>").val(value.ClientDealName).html(value.ClientDealName)
                );
            });
            $("#editSectrack_DealNo").val(rows[2]);
        }
    });

    // Project selection
    $("#editSectrack_Project").empty();
    $("#editSectrack_Project").append($("<option></option>").val("").html("Select"));
    $("#editSectrack_Project").append($("<option></option>").val("0").html("Add New"));

    $.ajax({
        type: "POST",
        url: "SecuritizationTracking.aspx/GetUWProjects",
        dataType: "json",
        contentType: "application/json",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                $("#editSectrack_Project").append(
                    $("<option></option>").val(value.ProjectId).html(value.ProjectName)
                );
            });
            $("#editSectrack_Project").val(rows[1]);
        }
    });
}


/*---------------- Update Method  ----------------*/
function EditSectracking_submit1() {

    var ddlProject = document.getElementById("editSectrack_Project");
    var projectid = ddlProject.options[ddlProject.selectedIndex].value;

    var clientdealname = document.getElementById("editSectrack_ClientDealName").value.trim();
    var loancount = document.getElementById("editSectrack_NoOfLoans").value.trim();
    var requesteddate = document.getElementById("editSectrack_RequestedDate").value.trim();
    var sladeliverydate = document.getElementById("editSectrack_SLADeliveryDate").value.trim();
    var actualdelivereddate = document.getElementById("editSectrack_ActualDeliveredDate").value.trim();
    var sladeliverydays = document.getElementById("editSectrack_SLADeliveryDays").value.trim();
    var billingHours = document.getElementById("editSectrack_BillingHours").value.trim();
    var CLientNameAddress = document.getElementById("editSectrack_ClientNameAddress").value.trim();
    var RecepientNameAddress = document.getElementById("editSectrack_RecipientNameAddress").value.trim();
    var AgencyNameAddress = document.getElementById("editSectrack_AgencyNameAddress").value.trim();
    var Remark = document.getElementById("editSectrack_Remark").value.trim();

    var ddltaskname = document.getElementById("editSectrack_TaskName");
    var taskname = ddltaskname.options[ddltaskname.selectedIndex].value;

    var ddlRLSigned = document.getElementById("editSectrack_RLSigned");
    var RLSigned = ddlRLSigned.options[ddlRLSigned.selectedIndex].value;

    var ddlStatus = document.getElementById("editSectrack_Status");
    var Status = ddlStatus.options[ddlStatus.selectedIndex].value;

    function showValidation(message, elementId) {
        editSectrackNotify(message, "warning");
        document.getElementById(elementId).focus();
        return false;
    }

    if (secureID == "" || secureID == 0) {
        return showValidation("Please select record for edit.", "editSectrack_Project");
    }

    if (projectid == "" || projectid == "Select") {
        return showValidation("Please select Client Name.", "editSectrack_Project");
    }

    if (loancount == "") {
        return showValidation("Please enter No of loans.", "editSectrack_NoOfLoans");
    }

    if (taskname == "" || taskname == "Select") {
        return showValidation("Please select Task Name.", "editSectrack_TaskName");
    }

    if (sladeliverydate == "") {
        return showValidation("Please select SLA/Client Delivery Date.", "editSectrack_SLADeliveryDate");
    }

    if (sladeliverydays == "") {
        return showValidation("Please enter SLA/Client Delivery Days.", "editSectrack_SLADeliveryDays");
    }

    if (Status == "" || Status == "Select") {
        return showValidation("Please select Status.", "editSectrack_Status");
    }

    editSectrackSetBusy("Updating securitization tracking data...");

    PageMethods.UpdateSecuritizationRelLetter(secureID, projectid, clientdealname, "", loancount, taskname, requesteddate, sladeliverydate, actualdelivereddate,
        Remark, Status, sladeliverydays, RLSigned, billingHours, CLientNameAddress, RecepientNameAddress, AgencyNameAddress,

        function (result) {

            editSectrackSetBusy("");

            if (result > 0) {

                secureID = 0;

                ClearEditSectrackControls();
                editSectrackNotify("Data updated successfully!", "success");

            } else {

                editSectrackNotify("Data already exists.", "warning");
            }
        },

        function (error) {

            editSectrackSetBusy("");

            console.log(error);

            editSectrackNotify(error.get_message ? error.get_message() : error.responseText || "Something went wrong while updating data.", "error");
        }
    );

    return false;
}



/*---------------- Supportive Method  ----------------*/

function formatDateForInput(dateValue) {
    if (!dateValue) return "";

    var date = new Date(dateValue);
    if (isNaN(date.getTime())) return "";

    var day = date.getDate();
    var month = date.getMonth() + 1;
    var year = date.getFullYear();

    if (day < 10) day = '0' + day;
    if (month < 10) month = '0' + month;

    return year + "-" + month + "-" + day;
}

function ClearEditSectrackControls() {

    $("#editSectrack_Project").prop("selectedIndex", 0);
    $("#editSectrack_TaskName").prop("selectedIndex", 0);
    $("#editSectrack_RLSigned").prop("selectedIndex", 0);
    $("#editSectrack_Status").prop("selectedIndex", 0);

    $("#editSectrack_ClientDealName").val("");
    $("#editSectrack_NoOfLoans").val("");
    $("#editSectrack_RequestedDate").val("");
    $("#editSectrack_SLADeliveryDate").val("");
    $("#editSectrack_ActualDeliveredDate").val("");
    $("#editSectrack_SLADeliveryDays").val("");
    $("#editSectrack_BillingHours").val("");
    $("#editSectrack_ClientNameAddress").val("");
    $("#editSectrack_RecipientNameAddress").val("");
    $("#editSectrack_AgencyNameAddress").val("");
    $("#editSectrack_Remark").val("");
}

