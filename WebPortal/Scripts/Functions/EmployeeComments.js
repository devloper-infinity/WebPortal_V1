
function ecom_bindEmployees() {

    var select = document.getElementById("ecom_user");
    let options = select.getElementsByTagName('ecom_user');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#ecom_user").append($("<option></option>").val("Select").html("Select"));

    $.ajax({
        type: "POST", url: "SkipLevelMeeting.aspx/GetAllEmployees", dataType: "json", contentType: "application/json",
        success: function(res) {

            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function(data, value) {

                $("#ecom_user").append($("<option></option>").val(value.EmployeeID).html(value.FullName));
            })
        }
    });
}

function ecom_bindemployeeInfo(dropdown) {

    var empId = $(dropdown).val(); // get selected value from dropdown

    $.ajax({
        type: "POST",
        url: "EmployeeComments.aspx/GetUserInformation",
        dataType: "json",
        data: "{EmployeeId:" + empId + "}",
        contentType: "application/json",

        success: function(res) {
            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function(data, value) {

                $("#ecom_branch").val(value.WorkingBranchName || "-");
                $("#ecom_domain").val(value.DomainName || "-");
                $("#ecom_department").val(value.DepartmentName || "-");
                $("#ecom_designation").val(value.DesignationName || "-");
                $("#ecom_reportMan").val(value.ReportingManager || "-");
                $("#ecom_joiningdate").val(value.JoiningDate);
            })
        }
    });
    return false;
}

function ecom_SubmitData() {

    var employeeid = $("#ecom_user").val();
    var subject = $("#ecom_subject").val();
    var comments = $("#ecom_comment").val();
    var code = $("#ecom_user option:selected").text().substring(0, 3)

    if (employeeid == "") {
        alert("Please select Employee");
        return false;
    }

    if (subject == "") {
        alert("Please select Title");
        return false;
    }

    if (comments == "") {
        alert("Please select Date");
        return false;
    }

    // ✅ Call PageMethod
    PageMethods.InsertEmployeeComments(employeeid, code, subject, comments,
        function(response) {
            alert(response);

        },
        function(error) {
            alert("Error: " + error.get_message());
        }
    );
}

function ecom_bindReport_core() {

    $('#load1').show();


    alert("message");

    $.ajax({
        url: 'EmployeeComments.aspx/GetEmployeeComment', // API endpoint
        type: 'GET',
        dataType: 'json',
        success: function(response) {
            $('#table_ecomreport tbody').empty();

            if (response && response.length > 0) {
                $.each(response, function(index, item) {
                    // If Attachment exists, create a download link, otherwise show "No File"
                    let downloadLink = item.Attachment
                        ? `<a href="${item.Attachment}" download>Download</a>`
                        : 'No File';

                    let row = `<tr>
                        <td class="ps-3" style="text-wrap: nowrap;">${downloadLink}</td>
                        <td style="text-align: center;">${index + 1}</td>
                        <td>${item.Code}</td>
                        <td>${item.Name}</td>
                        <td>${item.Subject}</td>
                        <td>${item.Comment}</td>
                        <td>${item.AddedByName}</td>
                        <td>${item.AddedDate}</td>
                        <td style="display:none;">${item.CommentID}</td>
                    </tr>`;

                    $('#table_ecomreport tbody').append(row);
                });
            } else {
                $('#table_ecomreport tbody').append('<tr><td colspan="9" style="text-align:center;">No comments found</td></tr>');
            }
        },
        error: function(xhr, status, error) {
            console.error('Error fetching employee comments:', error);
        }
    });
}

function ecom_bindReport() {
    $('#load1').show(); // optional loader

    $.ajax({
        url: 'EmployeeComments.aspx/GetEmployeeComment',
        type: "POST",
        contentType: "application/json",
        success: function(data) {
            var dataArray = JSON.parse(data.d);

            // Destroy old DataTable if exists
            if ($.fn.DataTable.isDataTable('#table_ecomreport')) {
                $('#table_ecomreport').DataTable().clear().destroy();
            }

            $('#table_ecomreport tbody').empty();

            $('#table_ecomreport').DataTable({
                dom: 'lBfrtip',
                data: dataArray,
                scrollX: false,
                paging: true,
                processing: true,
                ordering: false,
                serverSide: false,

                columns: [
                    {
                        data: "FilePath", 
                        className: "text-center",
                        render: function(data, type, row) {
                            if (row.Attachment && row.Attachment.trim() !== "") {
                                // Active download icon
                                return '<a href="#!" onclick="download_ecom(\'' + data + '\');" title="Download File">' +
                                    '<span style="color:dodgerblue; font-size:16px;"><i class="uil-cloud-download"></i></span>' +
                                    '</a>';
                            }
                            else {
                                // Disabled icon
                                return '<span title="No File" style="color:lightgray; font-size:16px; cursor:not-allowed;">' +
                                    '<i class="uil-cloud-download"></i>' +
                                    '</span>';
                            }
                        }
                    },
                    {
                        data: null,
                        render: function(data, type, row, meta) {
                            return meta.row + 1; // Serial number
                        }
                    },
                    { data: "Code" },
                    { data: "Subject" },
                    { data: "Comment" },
                    { data: "AddedByName" },
                    { data: "AddedDate" }
                ],

                buttons: [
                    {
                        extend: 'excelHtml5',
                        text: 'Export Excel',
                        title: 'Employee Comments',
                        exportOptions: {
                            columns: ':not(:first-child)' // Exclude Action column
                        }
                    }
                ],

                initComplete: function() {
                    $('#load1').hide();
                }
            });
        },
        error: function(error) {
            $('#load1').hide();
            alert('Error: ' + error.responseText);
        }
    });
}

function download_ecom(path) {

    alert(path);

    //  window.location.href = "DownloadFiles.aspx?CommentID=" + path

    window.location.href = "DownloadFiles.aspx?FilePath=" + encodeURIComponent(path);

    //window.location.href = "../Handler/Download.ashx?CommentID=" + path;
    //  window.location.href = "../Handler/Download.ashx?EmpComments=" + path;
} 