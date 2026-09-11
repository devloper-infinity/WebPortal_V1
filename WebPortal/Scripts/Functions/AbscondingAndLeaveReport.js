
//Arti Changes 
function YearWiseBindYear_AbscondingLeave() {
    var start = new Date().getFullYear();

    var select = document.getElementById("yearableave_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#yearableave_year").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#yearableave_year").append($("<option></option>").val(i).html(i));
    }
}

function yearableave_Submit() {
    var year = document.getElementById("yearableave_year").value;

    if (year == "") {
        Swal.fire("Validation", "Please select year.", "warning");
        return false;
    }
    YearWiseBindTotalLeaveGrid();
    YearWiseBindAbscondingGrid();
    return false;
}
function YearWiseBindTotalLeaveGrid() {
    var year = $("#yearableave_year").val();

    if (!year) {
        Swal.fire("Validation", "Please select year.", "warning");
        return false;
    }

    $('#load1').show();

    $.ajax({
        url: "AbscondingAndLeaveReport.aspx/GetYearWiseTotalLeaves",
        type: "POST",
        data: JSON.stringify({ Year: year }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (res) {
            var rawData = JSON.parse(res.d || "[]");

            // Process ASP.NET JSON Date format inside the data array before passing to DataTable
            var dataArray = rawData.map(function (value) {
                var addeddate = '';
                var approveddate = '';

                if (value.AddedDate) {
                    var timestampAdded = parseInt(value.AddedDate.replace(/\/Date\((\d+)\)\//gi, "$1"));
                    addeddate = new Date(timestampAdded).toLocaleDateString("en-US");
                }

                if (value.ApprovedDate) {
                    var timestampApproved = parseInt(value.ApprovedDate.replace(/\/Date\((\d+)\)\//gi, "$1"));
                    approveddate = new Date(timestampApproved).toLocaleDateString("en-US");
                }

                // Create a shallow copy and override date fields with formatted strings
                return Object.assign({}, value, {
                    AddedDate: addeddate,
                    ApprovedDate: approveddate
                });
            });

            if ($.fn.DataTable.isDataTable('#YearWisetotalleavelist')) {
                $('#YearWisetotalleavelist').DataTable().clear().rows.add(dataArray).draw();
                $('#load1').hide();
                return;
            }

            $('#YearWisetotalleavelist').DataTable({
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
                    { title: "Leave Year", data: "LeaveYear", render: blankForNull },
                    { title: "Leave Month", data: "LeaveMonth", render: blankForNull },
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
                    { title: "Added Date", data: "AddedDate", render: blankForNull },
                    { title: "Leave Status", data: "LeaveStatus", render: blankForNull },
                    { title: "Approved By", data: "ApprovedBy", render: blankForNull },
                    { title: "Approval Remark", data: "ApprovalRemark", render: blankForNull },
                    { title: "Approved Date", data: "ApprovedDate", render: blankForNull }
                ],
                columnDefs: [{
                    targets: "_all",
                    className: "text-nowrap"
                }],
                initComplete: function () {
                    $('#load1').hide();
                    if ($('#YearWisetotalleavelist').parent('.dataTables_scroll').length === 0) {
                        $('#YearWisetotalleavelist').wrap('<div class="dataTables_scroll" />');
                    }
                }
            });
        },

        error: function (xhr) {
            $('#load1').hide();

            Swal.fire({
                icon: "error",
                title: "Error",
                text: xhr.responseText || "Unable to load yearly leave report."
            });
        }
    });

    return false;
}


function YearWiseBindAbscondingGrid() {
    var year = $("#yearableave_year").val();

    if (!year) {
        Swal.fire("Validation", "Please select year.", "warning");
        return false;
    }

    $('#load1').show();

    $.ajax({
        url: "AbscondingAndLeaveReport.aspx/GetYearWiseAbscondingEmployees",
        type: "POST",
        data: JSON.stringify({ Year: year }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (res) {
            var dataArray = JSON.parse(res.d || "[]");

            if ($.fn.DataTable.isDataTable('#YearWiseabscondleavelist')) {
                $('#YearWiseabscondleavelist').DataTable().clear().rows.add(dataArray).draw();
                $('#load1').hide();
                return;
            }

            $('#YearWiseabscondleavelist').DataTable({
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
                    { title: "Year", data: "Year", render: blankForNull },
                    { title: "Month", data: "Month", render: blankForNull },
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
                    { title: "Latest Login Date", data: "LatestLoginDate", render: blankForNull }
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
                text: xhr.responseText || "Unable to load yearly absconding report."
            });
        }
    });

    return false;
}

