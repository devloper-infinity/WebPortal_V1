
/*--------------- Loan Details Functions--------------- */


var USLoanDetails_html;
var USLoanDetails_table;

function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

function BindUSLoanDetails_Grid() {

    $('#load1').show();

    USLoanDetails_html = '';
    $.ajax({
        url: "LoanDetails.aspx/GetLoanDetails_RemoteUW_REQC",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            $.each(dataArray, function (index, value) {

                USLoanDetails_html += '<tr>';
                USLoanDetails_html += '<td style="text-align:center; display:none;"><a title="Complete Loan" class="dropdown-item" href="#!" id="Actions" onclick="complete_Loan(' + value.ProcessID + ',' + index + ');"><span style="color: green;"><i class="uil uil-stop-circle" style="font-size:16px;"></i></span></a></td>';
                USLoanDetails_html += '<td style="text-wrap: nowrap;"><input type="datetime-local" id="us_add_date_start_' + blankForNull(value.ProcessID) + '" class="start-dt form-control" style="width:190px;" /> </td>';
                // USLoanDetails_html += '<td style="text-wrap: nowrap;"><input type="datetime-local" id="us_add_date_end_' + blankForNull(value.ProcessID) + '" class="end-dt form-control" style="width:190px;" /> </td>';
                USLoanDetails_html += '<td style="text-wrap: nowrap;">' + '<input type="datetime-local" ' + 'id="us_add_date_end_' + blankForNull(value.ProcessID) + '" ' + 'class="end-dt form-control" ' + 'style="width:190px;" disabled/>' + '</td>';
                USLoanDetails_html += '<td style="text-wrap: nowrap; display:none;" class="processid">' + blankForNull(value.ProcessID1) + '</td>';
                USLoanDetails_html += '<td style="text-wrap: nowrap;" class="client">' + blankForNull(value.ProjectNo) + '</td>';
                USLoanDetails_html += '<td style="text-wrap: nowrap;" class="deal">' + blankForNull(value.DealNo) + '</td>';
                USLoanDetails_html += '<td style="text-wrap: nowrap;" class="loan">' + blankForNull(value.LoanNo) + '</td>';
                USLoanDetails_html += '<td style="text-wrap: nowrap;" class="recdate">' + blankForNull(value.OrderDate) + '</td>';
                USLoanDetails_html += '<td style="text-wrap: nowrap;" class="process">' + blankForNull(value.Process) + '</td>';
                USLoanDetails_html += '<td style="text-wrap: nowrap; display:none;" class="uwname">' + blankForNull(value.RemoteUW) + '</td>';
                USLoanDetails_html += '<td style="text-wrap: nowrap; display:none;">' + blankForNull(value.ProcessDate) + '</td>';
                USLoanDetails_html += '</tr>';

            });

            if ($.fn.dataTable.isDataTable('#table_USLoanDetails')) {
                USLoanDetails_table.destroy();
            }
            $('#table_USLoanDetails tbody').html(USLoanDetails_html);

            USLoanDetails_table = $('#table_USLoanDetails').DataTable({
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
            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}


$(document).on('change input', '#table_USLoanDetails .start-dt', function () {
    var $row = $(this).closest('tr');
    var $endDate = $row.find('.end-dt');

    if ($(this).val() !== '') {
        $endDate.prop('disabled', false);
        $endDate.attr('min', $(this).val());
    } else {
        $endDate.val('');
        $endDate.prop('disabled', true);
        $endDate.removeAttr('min');
    }
});


$(document).on('change', '.end-dt', function () {

    var processId = $(this).attr('id').replace('us_add_date_end_', '');
    var index = USLoanDetails_table.row($(this).closest('tr')).index();

    complete_Loan(processId, index);
});


function complete_Loan(ProcessID, index) {

    var rowNode = USLoanDetails_table.row(index).node();
    var $row = $(rowNode);

    var startTime = $row.find('.start-dt').val();
    var endTime = $row.find('.end-dt').val();

    if (!startTime) {
        Swal.fire('Warning', 'Please select Start Date/Time.', 'warning');
        return false;
    }

    if (!endTime) {
        Swal.fire('Warning', 'Please select End Date/Time.', 'warning');
        return false;
    }

    ProcessFeedbackID = ProcessID;

    PageMethods.InsertModifyUWOrderOC22Servicing(
        $row.find('.client').text().trim(),   // ProjectNumber
        $row.find('.deal').text().trim(),     // DealNo
        $row.find('.loan').text().trim(),     // OrderNumber
        $row.find('.process').text().trim(),  // Process
        $row.find('.uwname').text().trim(),   // Review
        startTime,                            // StartTime
        endTime,                              // EndTime

        function (result) {

            if (result > 0) {
                Swal.fire({
                    title: 'Success!',
                    text: 'Loan completed successfully. You will now be redirected to the Feedback page.',
                    icon: 'success',
                    allowOutsideClick: false,
                    allowEscapeKey: false,
                    confirmButtonText: 'Continue'
                }).then(() => {
                    window.location.href = "AddFeedback.aspx?ProcessID=" + ProcessFeedbackID;
                });
            } else {
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'Oops! Error occurred while completing the loan.'
                });
            }
        },

        function (error) {
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: error.get_message ? error.get_message() : error.responseText
            });
        }
    );

    return false;
}



/*--------------- Add Feedback Functions--------------- */

var LoanNo = "";
var usfeedback_html;
var usfeedback_table;
var ProcessFeedbackID = 0;

function BindInfinityFeedback_US(ProcessID) {

    $.ajax({
        url: "AddFeedback.aspx/GetLoanDetails_RemoteUW_ByID",
        type: "POST",
        dataType: "json",
        data: "{ProcessID:" + ProcessID + "}",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = JSON.parse(data.d);

            $.each(dataArray, function (index, value) {

                LoanNo = value.LoanNo;

                BindUSFeedbackDetails_Grid(LoanNo);

                document.getElementById("USLoanDetails_LoanNo").value = value.LoanNo;
                document.getElementById("USLoanDetails_Client").value = value.ProjectNo;
                document.getElementById("USLoanDetails_UWName").value = value.RemoteUW.toUpperCase();


                var date = new Date();
                var day = date.getDate();
                if (day < 10)
                    day = '0' + day
                var month = date.getMonth() + 1;
                if (month < 10)
                    month = '0' + month
                var year = date.getFullYear();

                var actualdate = (month) + "/" + (day) + "/" + year;

                $("#USLoanDetails_QcDate").val(actualdate);
                $("#USLoanDetails_DateReviewed").val(actualdate);
            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}

function OnClickAddFeedback() {

    var LoanNo = document.getElementById("USLoanDetails_LoanNo").value;
    var Client = document.getElementById("USLoanDetails_Client").value;
    var UWName = document.getElementById("USLoanDetails_UWName").value;
    var DateReviewed = document.getElementById("USLoanDetails_DateReviewed").value;
    var Finding = document.getElementById("USLoanDetails_Finding").value;
    var inf_Severity = document.getElementById("USLoanDetails_Severity");
    var Severity = inf_Severity.options[inf_Severity.selectedIndex].value;

    var FeedbackRecDate = document.getElementById("USLoanDetails_DateReviewed").value;
    var QcDate = document.getElementById("USLoanDetails_QcDate").value;
    var Source = "ReQC";

    if (Finding == "") {
        Swal.fire({
            icon: 'warning',
            title: 'Validation',
            text: 'Please enter Finding.'
        });
        document.getElementById("USLoanDetails_Finding").focus();
        return false;
    }

    if (Severity == "") {
        Swal.fire({
            icon: 'warning',
            title: 'Validation',
            text: 'Please select Severity.'
        });
        return false;
    }

    PageMethods.InsertUSImportedFeedback_NewERP(
        LoanNo,
        Client,
        UWName,
        DateReviewed,
        QcDate,
        Finding,
        Severity,
        Source,
        FeedbackRecDate,

        function (result) {

            if (result > 0) {

                BindUSFeedbackDetails_Grid(LoanNo);

                Swal.fire({
                    icon: 'success',
                    title: 'Success',
                    text: 'Feedback added successfully.'
                }).then(() => {
                    location.reload();
                });

            } else {

                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'Oops! Error occurred while adding feedback. Please contact administrator.'
                }).then(() => {
                    location.reload();
                });
            }
        },

        function (error) {

            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: error.responseText
            });
        }
    );

    return false;
}


function core_OnClickAddFeedback() {

    var LoanNo = document.getElementById("USLoanDetails_LoanNo").value;
    var Client = document.getElementById("USLoanDetails_Client").value;
    var UWName = document.getElementById("USLoanDetails_UWName").value;
    var DateReviewed = document.getElementById("USLoanDetails_DateReviewed").value;
    var Finding = document.getElementById("USLoanDetails_Finding").value;
    var inf_Severity = document.getElementById("USLoanDetails_Severity");
    var Severity = inf_Severity.options[inf_Severity.selectedIndex].value;

    var FeedbackRecDate = document.getElementById("USLoanDetails_DateReviewed").value;
    var QcDate = document.getElementById("USLoanDetails_QcDate").value;
    var Source = "ReQC";


    if (Finding == "") {
        alert("Please enter Finding.");
        document.getElementById("USLoanDetails_Finding").focus();
        return false;
    }
    if (Severity == "") {
        alert("Please select Severity.");
        return false;
    }

    PageMethods.InsertUSImportedFeedback_NewERP(LoanNo, Client, UWName, DateReviewed, QcDate, Finding, Severity, Source, FeedbackRecDate, OnSuccessUSFeedback, OnErrorUSFeedback);
    return false;
}

function OnSuccessUSFeedback(result) {

    if (result > 0) {
        BindUSFeedbackDetails_Grid(LoanNo);
        alert("Feedback added successfully.");
        location.reload();
        return false;
    }
    else {
        alert("Oops! Error occured while updating status. Please contact administrator");
        location.reload();
        return false;
    }
}

function OnErrorUSFeedback(error) {
    alert(error.responseText);
}

function BindUSFeedbackDetails_Grid(loanNo) {

    $('#load1').show();

    usfeedback_html = '';
    $.ajax({
        url: "AddFeedback.aspx/GetUSImportedFeedback_ByUser_NewERP",
        type: "POST",
        data: "{LoanNo:'" + loanNo + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            $.each(dataArray, function (index, value) {

                usfeedback_html += '<tr>';
                usfeedback_html += '<td style="text-wrap: nowrap;text-align: center;">' + blankForNull(value.SrNo) + '</td>';
                usfeedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.LoanNo) + '</td>';
                usfeedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Severity) + '</td>';
                usfeedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Finding) + '</td>';
                usfeedback_html += '<td style="text-wrap: nowrap; display:none;">' + blankForNull(value.AddedByName) + '</td>';
                usfeedback_html += '<td style="text-wrap: nowrap; display:none;">' + blankForNull(value.AddedDate) + '</td>';

                usfeedback_html += '</tr>';

            });

            if ($.fn.dataTable.isDataTable('#table_usfeedback')) {
                usfeedback_table.destroy();
            }
            $('#table_usfeedback tbody').html(usfeedback_html);

            usfeedback_table = $('#table_usfeedback').DataTable({
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
            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}


/* ---- Global Search -- */

function us_getloansforglobalsearch() {
    $('#load1').show();
    var columns = [];
    $.ajax({
        url: "GlobalSearch.aspx/getLoansForGlobalSearch",
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
            columns.push({
                data: null,
                title: "Action",
                orderable: false,
                searchable: false,
                render: function (data, type, row, meta) {
                    return `
            <button class="btn btn-sm btn-primary view-btn">
                Get
            </button>
        `;
                }
            });


            $('#usglobalsearch_table').DataTable({
                dom: 'lBftip',
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
                columns: columns,
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                },

                initComplete: function () {
                    $('#load1').hide();
                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Summary Report', autoFilter: true,
                    },
                ],
            });
            $('#usglobalsearch_table tbody').on('click', '.view-btn', function () {
                var table = $('#usglobalsearch_table').DataTable();
                var rowData = table.row($(this).closest('tr')).data();

                console.log(rowData);

                // Example usage
                GetFeedbackPage(rowData["Loan #"], rowData["Deal #"]);
                return false;
            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });


    return false;
}

function GetFeedbackPage(loanno, dealno) {
    const payload = {
        ln: loanno,
        dn: dealno
    };

    const encoded = btoa(JSON.stringify(payload));
    location.href = "FeedbackDetails.aspx?data=" + encodeURIComponent(encoded);
    //location.href = "FeedbackDetails.aspx?ln=" + loanno;
}

function GetLoggedInUserDetails() {
    $.ajax({
        type: "POST", url: "FeedbackDetails.aspx/GetLoggedInUser", dataType: "json", contentType: "application/json",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                document.getElementById("usfeedback_reviewer").value = blankForNull(value.FullName);
                document.getElementById("usfeedback_reviewer").readonly = true;

            })
        }
    });
}

function bindloanDetails_feedback() {
    const params = new URLSearchParams(window.location.search);
    const encoded = params.get('data');
    if (!encoded) return;
    const decoded = JSON.parse(atob(encoded));

    $.ajax({
        url: "FeedbackDetails.aspx/GetLoanDetailsbyLoanNo",
        type: "POST",
        dataType: "json",
        data: "{DealNo:'" + decoded.dn + "',LoanNo:'" + decoded.ln + "'}",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);
            $.each(dataArray, function (index, value) {

                document.getElementById("usfeedback_projectno").value = value.ProjectName;
                document.getElementById("usfeedback_dealno").value = value.DealNo;
                document.getElementById("usfeedback_loanno").value = value.LoanNo;
                document.getElementById("usfeedback_projectid").value = value.ProjectID;


                usfeedback_bindProcessTask(value.ProjectID);


            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;

}

function usfeedback_bindProcessTask(Projectid) {

    $("#usfeedback_task").empty()
        .append('<option value="">Select</option>');

    $.ajax({
        type: "POST",
        url: "FeedbackDetails.aspx/GetUSProcessTask",
        dataType: "json",
        contentType: "application/json",
        data: JSON.stringify({ ProjectID: Projectid }),

        success: function (res) {

            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (index, value) {

                // Prevent duplicate option
                if ($("#usfeedback_task option[value='" + value.ProcessID + "']").length === 0) {
                    $("#usfeedback_task").append(
                        $("<option></option>")
                            .val(value.ProcessID)
                            .text(value.ProcessName)
                    );
                }
            });

            const params = new URLSearchParams(window.location.search);
            const encoded = params.get('data');

            if (!encoded) return;

            const decoded = JSON.parse(atob(encoded));

            if (decoded.tp) {

                $("#usfeedback_task").val(decoded.tp);

                // Call only once
                getTaskwiseDetails(document.getElementById("usfeedback_task"));

                document.getElementById("usfeedback_back").href = "LoanDetails.aspx";
            }
        }
    });
}

function core_usfeedback_bindProcessTask(Projectid) {
    var select = document.getElementById("usfeedback_task");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#usfeedback_task").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "FeedbackDetails.aspx/GetUSProcessTask", dataType: "json", contentType: "application/json",
        data: "{ProjectID:" + Projectid + "}",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                $("#usfeedback_task").append($("<option></option>").val(value.ProcessID).html(value.ProcessName));
            })
            const params = new URLSearchParams(window.location.search);
            const encoded = params.get('data');
            if (!encoded) return;
            const decoded = JSON.parse(atob(encoded));
            if (decoded.tp != null) {
                $("#usfeedback_task").val(decoded.tp);
                getTaskwiseDetails(document.getElementById("usfeedback_task"));
                document.getElementById("usfeedback_back").href = "LoanDetails.aspx";
            }
        }
    });
}

function getTaskwiseDetails(ddl) {

    var value = ddl.options[ddl.selectedIndex].text;
    var id = ddl.options[ddl.selectedIndex].value;
    if (value == "" || value == "Select") {
        document.getElementById("trOther").style.display = 'none';
        document.getElementById("tratr1").style.display = 'none';
        document.getElementById("tratr2").style.display = 'none';
        document.getElementById("tratr3").style.display = 'none';
        document.getElementById("tratr4").style.display = 'none';
        document.getElementById("tratr5").style.display = 'none';
    }
    else if (value == "ATR Review") {
        document.getElementById("trOther").style.display = 'none';
        document.getElementById("tratr1").style.display = '';
        document.getElementById("tratr2").style.display = '';
        document.getElementById("tratr3").style.display = '';
        document.getElementById("tratr4").style.display = '';
        document.getElementById("tratr5").style.display = '';
        var date = new Date();
        var day = String(date.getDate()).padStart(2, '0');
        var month = String(date.getMonth() + 1).padStart(2, '0');
        var year = date.getFullYear();

        var actualdate = year + "-" + month + "-" + day;

        document.getElementById("usfeedback_reviewdate").value = actualdate;

        usfeedback_atr_bindgrid("ATR", id);
    }
    else {
        document.getElementById("trOther").style.display = '';
        document.getElementById("tratr1").style.display = 'none';
        document.getElementById("tratr2").style.display = 'none';
        document.getElementById("tratr3").style.display = 'none';
        document.getElementById("tratr4").style.display = 'none';
        document.getElementById("tratr5").style.display = 'none';
        usfeedback_atr_bindgrid("Other", id);

    }
}

function usfeedback_submit() {
    var projectid = document.getElementById("usfeedback_projectid").value;
    var dealno = document.getElementById("usfeedback_dealno").value;
    var loanno = document.getElementById("usfeedback_loanno").value;
    var ddl = document.getElementById("usfeedback_task");
    var processid = ddl.options[ddl.selectedIndex].value;
    var value = ddl.options[ddl.selectedIndex].text;
    if (value == "" || value == "Select") {
        alert("Please select task");
        return;
    }
    else if (value == "ATR Review") {
        var reviewer = document.getElementById("usfeedback_reviewer").value;
        var reviewdate = document.getElementById("usfeedback_reviewdate").value;
        var ddlatrsupported = document.getElementById("usfeedback_atrsupported");
        var atrsupported = ddlatrsupported.options[ddlatrsupported.selectedIndex].value;
        if (atrsupported == "") {
            alert("Please select 'ATR Supported?'");
            document.getElementById("usfeedback_atrsupported").focus();
            return false;
        }
        var noofbwr = document.getElementById("usfeedback_noofbwr").value;
        if (noofbwr == "") {
            alert("Please enter '# of Borrowers'");
            document.getElementById("usfeedback_noofbwr").focus();
            return false;
        }
        var reviewfinding = document.getElementById("usfeedback_reviewfindings").value;
        if (reviewfinding == "") {
            alert("Please enter 'Review Findings'");
            document.getElementById("usfeedback_reviewfindings").focus();
            return false;
        }
        var dtiissue = document.getElementById("usfeedback_dtiissue").value;
        var incometype = document.getElementById("usfeedback_incometype").value;
        var sebusiness = document.getElementById("usfeedback_noofsebus").value;
        if (sebusiness == "") {
            alert("Please enter '# SE businesses'");
            document.getElementById("usfeedback_noofsebus").focus();
            return false;
        }
        var rental = document.getElementById("usfeedback_noofrental").value;
        if (rental == "") {
            alert("Please enter '# Rental Properties'");
            document.getElementById("usfeedback_noofrental").focus();
            return false;
        }
        var comments = document.getElementById("usfeedback_comments").value;
        PageMethods.InsertATRFeedbacks(projectid, processid, dealno, loanno, reviewer, reviewdate, atrsupported,
            reviewfinding, dtiissue, noofbwr, incometype, sebusiness, rental, comments, usfeedback_atr_OnSuccess, usfeedback_atr_OnError)
    }
    else {
        var ddlseverity = document.getElementById("usfeedback_severity");
        var severity = ddlseverity.options[ddlseverity.selectedIndex].value;
        var findings = document.getElementById("usfeedback_finding").value;
        PageMethods.InsertOtherFeedbacks(projectid, processid, dealno, loanno, findings, severity, usfeedback_other_OnSuccess, usfeedback_other_OnError);
        return false;
    }
    return false;
}

function usfeedback_atr_OnSuccess(result) {
    if (result > 0) {
        alert("Record added successfully.");
        location.reload();
        return false;
    }
    else {
        alert("Oops! Error occured while completing loan. Please contact administrator");
        return false;
    }
}

function usfeedback_atr_OnError(error) {
    alert(error.get_message());
}

function usfeedback_other_OnSuccess(result) {
    if (result > 0) {
        alert("Record added successfully.");
        location.reload();
        return false;
    }
    else {
        alert("Oops! Error occured while completing loan. Please contact administrator");
        return false;
    }
}

function usfeedback_other_OnError(error) {
    alert(error.get_message());
}

function usfeedback_atr_bindgrid(type, processid) {
    $('#load1').show();
    var columns = [];
    var dealno = document.getElementById("usfeedback_dealno").value;
    var loanno = document.getElementById("usfeedback_loanno").value;

    $.ajax({
        url: "FeedbackDetails.aspx/GetATRDetails",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: "{DealNo:'" + dealno + "', LoanNo:'" + loanno + "', Type:'" + type + "', ProcessID:" + processid + "}",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            if ($.fn.DataTable.isDataTable('#usfeedback_table')) {
                $('#usfeedback_table').DataTable().clear().destroy();
            }
            if (dataArray != '') {
                $.each(dataArray[0], function (key, value) {

                    var my_item = {};
                    my_item.data = key;
                    my_item.title = key;
                    columns.push(my_item);
                });
                $('#usfeedback_table').DataTable({
                    dom: 'lBftip',
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
                    columns: columns,
                    fnCreatedRow: function (nRow, aData, iDataIndex) {
                        $(nRow).children("td").css("text-wrap", "nowrap");
                    },

                    initComplete: function () {
                        $('#load1').hide();
                    },
                    buttons: [
                        {
                            extend: 'excelHtml5', title: 'Summary Report', autoFilter: true,
                        },
                    ],
                });

            }
            else {
                $('#load1').hide();
            }
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });


    return false;
}


// ----------- Production Summary

var maindate, startIdx, endIdx, totalTimeIdx, TargetIdx, LoanIdx, ProductionIdx, ErrorPerLoanIdx, TotalErrorIdx, CommentsIdx;

function us_prodsum_bindyear() {
    var start = new Date().getFullYear();

    var select = document.getElementById("us_prodsum_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#us_prodsum_year").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#us_prodsum_year").append($("<option></option>").val(i).html(i));
    }
}

function getColumnIndex(columns, name) {
    return columns.findIndex(c => c.data === name);
}


function getprodsummary() {
    //var date = document.getElementById("us_prodsum_date").value;
    //if (date != "")
    var ddlmonth = document.getElementById("us_prodsum_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("us_prodsum_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    us_getproductionSummary(month, year);
    return false;
}

function us_getproductionSummary(month, year) {
    if ($.fn.DataTable.isDataTable('#usprodsum_table')) {
        $('#usprodsum_table').DataTable().clear().destroy();
        $('#usprodsum_table tbody').empty();
    }
    $('#load1').show();

    var columns = [];
    $.ajax({
        url: "ProductionSummary.aspx/GetDatewiseOnShoreProduction_Monthly",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        /*data: "{Date:'" + date + "'}",*/
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            if (!dataArray || dataArray.length === 0) {
                $('#load1').hide();
                return;
            }
            $.each(dataArray[0], function (key, value) {

                var my_item = {};
                my_item.data = key;
                my_item.title = key;
                columns.push(my_item);
            });

            $('#usprodsum_table').DataTable({
                dom: 'ft',
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                "paging": false,
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
                columns: columns,
                columnDefs: [
                    { targets: [15, 17, 18], visible: false }
                ],
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                    if (startIdx === undefined) {
                        maindate = getColumnIndex(columns, 'Date');
                        startIdx = getColumnIndex(columns, 'StartTime');
                        endIdx = getColumnIndex(columns, 'EndTime');
                        totalTimeIdx = getColumnIndex(columns, 'TotalTime');
                        TargetIdx = getColumnIndex(columns, 'Target');
                        LoanIdx = getColumnIndex(columns, '# Loans Reviewed');
                        ProductionIdx = getColumnIndex(columns, 'Target vs Production');
                        ErrorPerLoanIdx = getColumnIndex(columns, 'Error Finding Rate');
                        TotalErrorIdx = getColumnIndex(columns, 'Total Errors');
                        CommentsIdx = getColumnIndex(columns, 'Comments');
                    }

                    // Date
                    //if (!aData.maindate) {
                    //    $('td', nRow).eq(maindate).html(
                    //        '<label>' + document.getElementById("us_prodsum_date").value + '</label>'
                    //    );
                    //}

                    // START TIME
                    if (!aData.StartTime) {
                        $('td', nRow).eq(startIdx).html(
                            `<input type="time" class="start-time form-control" />`
                        );
                    }

                    // END TIME
                    if (!aData.EndTime) {
                        $('td', nRow).eq(endIdx).html(
                            `<input type="time" class="end-time form-control" />`
                        );
                    }

                    // Comments
                    if (!aData.StartTime) {
                        $('td', nRow).eq(CommentsIdx).html(
                            `<input type="text" class="comment form-control" style="width:350px;" />`
                        );
                    }

                    $(nRow).children("td").css("white-space", "nowrap");
                    setTimeout(toggleSaveButton, 0);
                },

                initComplete: function () {
                    $('#load1').hide();
                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Summary Report', autoFilter: true,
                    },
                ],
            });

        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    toggleSaveButton();

    return false;
}

function toggleSaveButton() {
    const hasInputs =
        $('#usprodsum_table tbody')
            .find('input.start-time, input.end-time')
            .length > 0;

    if (hasInputs) {
        $('#us_prodsum_btnsubmit').show();
    } else {
        $('#us_prodsum_btnsubmit').hide();
    }
}

$(document).on('change', '.end-time', function () {
    const $row = $(this).closest('tr');
    const start = $row.find('.start-time').val();
    const end = $(this).val();

    if (!start) {
        alert('Please select Start Time first');
        $(this).val('');
        return;
    }

    const startMin = toMinutes(start);
    const endMin = toMinutes(end);

    if (endMin <= startMin) {
        alert('End Time must be greater than Start Time');
        $(this).val('');
        return;
    }

    const totalMinutes = endMin - startMin;
    // Fill Total Time
    $row.find('td').eq(totalTimeIdx)
        .text(formatMinutes(totalMinutes));

    // Auto-fill remaining columns
    calculateRowValues($row, totalMinutes);
});


function toMinutes(time) {
    const [h, m] = time.split(':').map(Number);
    return h * 60 + m;
}

function formatMinutes(min) {
    const h = Math.floor(min / 60);
    const m = min % 60;
    return `${h}:${String(m).padStart(2, '0')}`;
}

function calculateRowValues($row, totalMinutes) {

    const totalHours = totalMinutes / 60;

    const target = parseFloat(
        $row.find('td').eq(TargetIdx).text().trim()
    ) || 0;

    const loans = parseInt(
        $row.find('td').eq(LoanIdx).text().trim()
    ) || 0;

    // Target vs Production
    let prod = 0;
    if (target > 0 && totalHours > 0) {
        prod = ((loans / (target * totalHours)) * 100).toFixed(0);
    }

    $row.find('td').eq(ProductionIdx).text(prod + '%');

    // Example: Error Rate
    const errors = parseInt($row.find('td').eq(TotalErrorIdx).text()) || 0;
    const errorRate = loans > 0 ? (errors / loans).toFixed(2) : 0;

    $row.find('td').eq(ErrorPerLoanIdx).text(errorRate);
}


$(document).on('focus', '.end-time', function () {
    const $row = $(this).closest('tr');
    if (!$row.find('.start-time').val()) {
        alert('Select Start Time first');
        $row.find('.start-time').focus();
    }
});

function us_prodsum_submit() {
    const table = $('#usprodsum_table').DataTable();
    let records = [];

    table.rows().every(function () {

        const $row = $(this.node());

        const start = $row.find('.start-time').val();
        const end = $row.find('.end-time').val();
        if (start || end) {

            const rowData = this.data();
            //alert(rowData.ProjectID);
            //alert(rowData.ProcessID);
            //alert(document.getElementById("us_prodsum_date").value);
            //alert($row.find('td').eq(totalTimeIdx).text());
            //alert(rowData.DealNo);
            //alert(rowData["Task Performed"]);
            //alert(rowData.Target);
            //alert(rowData['# Loans Reviewed']);
            //alert($row.find('td').eq(ProductionIdx).text().replace('%', ''));
            //alert(rowData['Total Errors']);
            //alert(rowData['Total Crtical Errors']);
            //alert(rowData['Total Non-Crtical Errors']);
            //alert(rowData['Incorrect Errors']);
            //alert($row.find('td').eq(ErrorPerLoanIdx).text());
            //alert(rowData['Cost/Loan']);
            //alert($row.find('.comment').val());
            //alert(start);
            //alert(end);
            records.push({
                ProjectID: rowData.ProjectID,
                ProcessID: rowData.ProcessID,
                Date: rowData.Date,
                TotalTime: $row.find('td').eq(totalTimeIdx).text(),
                DealNo: rowData.DealNo,
                TaskPerformed: rowData["Task Performed"],
                Target: rowData.Target,
                LoansReviewed: rowData['# Loans Reviewed'],
                TargetvsProduction: $row.find('td').eq(ProductionIdx).text().replace('%', ''),
                TotalErrors: rowData['Total Errors'],
                TotalCriticalErrors: rowData['Total Crtical Errors'],
                TotalNonCriticalErrors: rowData['Total Non-Crtical Errors'],
                IncorrectErrors: rowData['Incorrect Errors'] === null ? 0 : rowData['Incorrect Errors'],
                ErrorFindingRate: $row.find('td').eq(ErrorPerLoanIdx).text(),
                CostPerLoan: rowData['Cost/Loan'] === null ? 0 : rowData['Cost/Loan'],
                Comments: $row.find('.comment').val(),
                StartTime: start,
                EndTime: end

            });
        }
    });

    if (records.length === 0) {
        alert('No records to save');
        return;
    }

    saveRecords(records);
    return false;
}

function saveRecords(data) {
    $.ajax({
        url: 'ProductionSummary.aspx/SaveProductionSummary',
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        dataType: 'json',
        data: JSON.stringify({ records: data }),
        success: function (res) {
            alert('Records saved successfully');
            $('#btnSave').hide();
        },
        error: function (err) {
            alert('Error while saving data');
            console.error(err);
        }
    });
    getprodsummary();
    return false;
}

// ----- Production Report

function us_prodsum_rpt_bindyear() {
    var start = new Date().getFullYear();

    var select = document.getElementById("us_prodsum_rpt_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#us_prodsum_rpt_year").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#us_prodsum_rpt_year").append($("<option></option>").val(i).html(i));
    }
}

function us_rpt_getproductionSummary() {
    var ddlmonth = document.getElementById("us_prodsum_rpt_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("us_prodsum_rpt_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;

    if ($.fn.DataTable.isDataTable('#usprodsum_table')) {
        $('#usprodsum_table').DataTable().clear().destroy();
        $('#usprodsum_table tbody').empty();
    }
    $('#load1').show();

    var columns = [];
    $.ajax({
        url: "ProductionReport.aspx/GetDatewiseOnShoreProduction_Monthly",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        /*data: "{Date:'" + date + "'}",*/
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            if (!dataArray || dataArray.length === 0) {
                $('#load1').hide();
                return;
            }
            $.each(dataArray[0], function (key, value) {

                var my_item = {};
                my_item.data = key;
                my_item.title = key;
                columns.push(my_item);
            });

            $('#usprodsum_rpt_table').DataTable({
                dom: 'ft',
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                "paging": false,
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
                columns: columns,
                columnDefs: [
                    { targets: [15, 17, 18], visible: false }
                ],
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                },

                initComplete: function () {
                    $('#load1').hide();
                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Production Report', autoFilter: true,
                    },
                ],
            });

        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    toggleSaveButton();

    return false;
}
