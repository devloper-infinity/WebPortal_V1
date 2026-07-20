var bank_table;
var bank_html;
var bankapprv_html;
var bankapprv_table;
var pendingBankdetails_table;
var pendingBankdetails_html;

var acc_changeID = 0;

function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

function bank_Message() {
    $('#bank_dverror').modal('hide');
    document.getElementById("bank_name").value = '';
    bank_Binddata();
}

function bank_Binddata() {

    bank_html = '';
    $.ajax({
        url: "BankNameMaster.aspx/GetAllBankNames",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                var addeddate = eval(value.AddedDate.replace(/\/Date\((\d+)\)\//gi, "new Date($1).toLocaleDateString(\"en-US\")"));
                bank_html += '<tr>';
                bank_html += '<td style="text-wrap: nowrap;text-align:center;">' + blankForNull((index + 1)) + '</td>';
                bank_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.BankName) + '</td>';
                bank_html += '<td style="text-wrap: nowrap; ">' + blankForNull(value.AddedByName) + '</td>';
                bank_html += '<td style="text-wrap: nowrap; ">' + blankForNull(addeddate) + '</td>';
                bank_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#bank_table')) {
                bank_table.destroy();
            }
            $('#bank_table tbody').html(bank_html);
            //else
            bank_table = $('#bank_table').DataTable({
                dom: 'lBftip',
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

                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Bank Names', autoFilter: true,
                        exportOptions: {
                            columns: [0, 1, 2],
                        }

                    },


                ],

            });

            //$('#fnalize tbody').on('click', 'tr', function () {
            //    row = table.row(this).data();
            //});
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}

function bank_submit() {

    var bank_profile = $("#bank_name").val().trim();

    if (!bank_profile) {
        Swal.fire({
            icon: "warning",
            title: "Bank Required",
            text: "Please enter bank name."
        });

        $("#bank_name").focus();
        return false;
    }

    PageMethods.InsertBank(
        bank_profile,

        function (result) {

            if (result > 0) {

                Swal.fire({
                    icon: "success",
                    title: "Success",
                    text: "Bank name added successfully!",
                    confirmButtonColor: "#28a745"
                }).then(() => {
                    $("#bank_name").val("");
                });

            } else {

                Swal.fire({
                    icon: "error",
                    title: "Failed",
                    text: "Oops! Error occurred while adding bank name. Please contact administrator."
                });
            }
        },

        function (error) {

            Swal.fire({
                icon: "error",
                title: "Error",
                text: error.get_message
                    ? error.get_message()
                    : "Something went wrong. Please contact administrator."
            });
        }
    );

    return false;
}


/*-------------- Change Bank Account Details  --------------*/

function showSwal(type, title, text) {
    Swal.fire({
        icon: type,
        title: title,
        text: text,
        confirmButtonText: "OK"
    });
}

function change_bindBankName() {

    $.ajax({
        url: "CreateProfile.aspx/GetBankNames",
        type: "POST",
        data: "{}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var banks = data.d || [];
            var ddl = $("#bank_BankName");

            ddl.empty();
            ddl.append('<option value="">Select Bank</option>');

            $.each(banks, function (i, bank) {
                ddl.append($("<option></option>").val(bank.BankName).text(bank.BankName));
            });
        },

        error: function () {
            showSwal("error", "Error", "Unable to bind bank names.");
        }
    });
}

function change_bindUsers() {
    $.ajax({
        url: "HRReportInput.aspx/GetAllEmployees",
        type: "POST",
        data: "{}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var users = JSON.parse(data.d || "[]");
            var ddl = $("#bank_Employee");

            ddl.empty();
            ddl.append('<option value="">Select Employee</option>');

            $.each(users, function (i, user) {
                ddl.append($("<option></option>").val(user.Code).text(user.FullName));
            });
        },

        error: function () {
            showSwal("error", "Error", "Unable to bind employees.");
        }
    });
}

function validateBankDetails() {

    var code = $.trim($("#bank_Employee").val());
    var bankName = $.trim($("#bank_BankName").val());
    var accountNo = $.trim($("#bank_AccountNo").val());
    var confirmAccountNo = $.trim($("#bank_ReAccountNo").val());
    var ifsc = $.trim($("#bank_IFSCCode").val());
    var confirmifsc = $.trim($("#bank_ReIFSCCode").val());

    var ifscRegex = /^[A-Z]{4}0[A-Z0-9]{6}$/;
    var accountRegex = /^[0-9]{9,18}$/;

    var filename = "";
    var fileupload = $("#fuattachment")[0];

    if (code === "") {
        showSwal("warning", "Validation", "Please select Employee.");
        $("#bank_Employee").focus();
        return false;
    }

    if (bankName === "") {
        showSwal("warning", "Validation", "Please select bank name.");
        $("#bank_BankName").focus();
        return false;
    }

    if (accountNo === "") {
        showSwal("warning", "Validation", "Please enter account number.");
        $("#bank_AccountNo").focus();
        return false;
    }

    if (!accountRegex.test(accountNo)) {
        showSwal("warning", "Validation", "Account number must be 9 to 18 digits.");
        $("#bank_AccountNo").focus();
        return false;
    }

    if (confirmAccountNo === "") {
        showSwal("warning", "Validation", "Please confirm account number.");
        $("#bank_AccountNo").focus();
        return false;
    }

    if (accountNo !== confirmAccountNo) {
        showSwal("warning", "Validation", "Account number and confirm account number do not match.");
        $("#bank_ReAccountNo").focus();
        return false;
    }

    if (ifsc !== confirmifsc) {
        showSwal("warning", "Validation", "Account IFSC and confirm account IFSC do not match.");
        $("#bank_ReAccountNo").focus();
        return false;
    }

    if (ifsc === "") {
        showSwal("warning", "Validation", "Please enter IFSC code.");
        $("#bank_IFSCCode").focus();
        return false;
    }

    if (!ifscRegex.test(ifsc.toUpperCase())) {
        showSwal("warning", "Validation", "Please enter valid IFSC code.");
        $("#bank_IFSCCode").focus();
        return false;
    }

    if (fileupload === "") {
        showSwal("warning", "Validation", "Please select attachmnent.");
        return false;
    }

    return true;
}

function saveBankDetails() {


    var file = $('#fpBankProof').val();

    if (!file) {
        Swal.fire({
            icon: 'warning',
            title: 'Validation Error',
            text: 'Please upload Bank Proof.',
            confirmButtonText: 'OK'
        });

        $('#fpBankProof').focus();
        return false;
    }

    $("#bank_btnAccSave").prop("disabled", true);
    $("#btnBankIcon").removeClass("fa-paper-plane").addClass("fa-spinner fa-spin");
    $("#btnBankText").text("Saving Data...");

    if (!validateBankDetails()) {
        return false;
    }

    var Code = $.trim($("#bank_Employee").val());
    var BankName = $.trim($("#bank_BankName").val());
    var AccountNo = $.trim($("#bank_AccountNo").val());
    var IFSCCode = $.trim($("#bank_IFSCCode").val()).toUpperCase();

    PageMethods.InsertBankAccountDetails(Code, BankName, AccountNo, IFSCCode,
        function (result) {

            $("#load1").hide();

            if (result === 1) {
                Swal.fire({ icon: "success", title: "Updated", text: "Bank details updated successfully.", confirmButtonText: "OK" }).then(function () {
                    clearBankDetailsForm();

                    $("#bank_btnAccSave").prop("disabled", false);
                    $("#btnBankIcon").removeClass("fa-spinner fa-spin").addClass("fa-paper-plane");
                    $("#btnBankText").text("Submit Bank Details");
                });
            }
            else
                if (result > 0) {
                    Swal.fire({ icon: "success", title: "Success", text: "Bank details saved successfully.", confirmButtonText: "OK" }).then(function () {
                        clearBankDetailsForm();

                        $("#bank_btnAccSave").prop("disabled", false);
                        $("#btnBankIcon").removeClass("fa-spinner fa-spin").addClass("fa-paper-plane");
                        $("#btnBankText").text("Submit Bank Details");
                    });
                }
            else {
                showSwal("error", "Error", "Unable to save bank details. Please contact administrator.");
            }
        },
        function (error) {

            $("#load1").hide();

            showSwal("error", "Error", error.get_message ? error.get_message() : "Something went wrong while saving bank details.");
        }
    );


    return false;
}

function clearBankDetailsForm() {

    $("#bank_Employee").prop("selectedIndex", 0);
    $("#bank_BankName").prop("selectedIndex", 0);
    $("#bank_AccountNo").val("");
    $("#bank_ReAccountNo").val("");
    $("#bank_IFSCCode").val("");
    $("#bank_ReIFSCCode").val("");

    // Clear file upload
    $("#fpBankProof").val("");
    $("#bank_BankProof").text("");

}



/*-------------- Approve Bank Account Details  --------------*/

function bank_BindApprovalData() {
    $('#load1').show();

    $.ajax({
        url: "ApprovedBankDeatils.aspx/GetBankDetailsforApproval",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d || "[]");

            if ($.fn.dataTable.isDataTable('#bankapprv_list')) {
                bankapprv_table.clear();
                bankapprv_table.rows.add(dataArray);
                bankapprv_table.draw();
                $('#load1').hide();
                return;
            }

            bankapprv_table = $('#bankapprv_list').DataTable({
                data: dataArray,
                dom: 'lftip',
                scrollX: true,
                paging: true,
                autoWidth: false,
                ordering: false,
                processing: true,
                deferRender: true,
                select: {
                    style: 'single'
                },
                columns: [
                    {
                        data: null,
                        orderable: false,
                        render: function (data, type, row, meta) {
                            return `
                                <div class="btn-group">
                                    <div class="btn-group">
                                        <div type="button" data-toggle="dropdown" aria-expanded="false">
                                            <i style="color:dodgerblue;font-size:14px;" class="uil fs-0 me-2 uil-cog"></i>
                                            <span class="sr-only"></span>
                                        </div>
                                        <div class="dropdown-menu" role="menu">
                                            <a class="dropdown-item" href="#!" onclick="bankapprv_Approve(${row.AccNoChangeID},${meta.row},1);">
                                                <span style="color:forestgreen;">
                                                    <i class="uil fs-0 me-2 uil-check-circle"></i>
                                                </span>&nbsp;&nbsp;Approve
                                            </a>
                                            <a class="dropdown-item" href="#!" onclick="bankapprv_Download(${row.AccNoChangeID},${meta.row});">
                                                <span style="color:dodgerblue;">
                                                    <i class="uil fs-0 me-2 uil-cloud-download"></i>
                                                </span>&nbsp;&nbsp;Download Attachment
                                            </a>
                                            <div class="dropdown-divider"></div>
                                        </div>
                                    </div>
                                </div>`;
                        }
                    },
                    {
                        data: null,
                        className: "text-center text-nowrap",
                        render: function (data, type, row, meta) {
                            return meta.row + 1;
                        }
                    },
                    { data: "AccNoChangeID", visible: false },
                    { data: "TicketNo", defaultContent: "", className: "text-nowrap" },
                    { data: "Code", defaultContent: "", className: "text-nowrap" },
                    { data: "EmployeeName", defaultContent: "", className: "text-nowrap" },
                    { data: "Branch", defaultContent: "", className: "text-nowrap" },
                    { data: "Department", defaultContent: "", className: "text-nowrap" },
                    { data: "Designation", defaultContent: "", className: "text-nowrap" },
                    { data: "Domain", defaultContent: "", className: "text-nowrap" },
                    { data: "ReportingManager", defaultContent: "", className: "text-nowrap" },
                    { data: "AddedBy", defaultContent: "", className: "text-nowrap" },
                    { data: "AddedDate", className: "text-nowrap", render: function (data) { return formatJsonDate(data); } },
                    { data: "Attachment", visible: false },
                    { data: "OldBankName", visible: false },
                    { data: "OldBankAccNo", visible: false },
                    { data: "OldBankIFSCCode", visible: false },
                    { data: "NewBankName", visible: false },
                    { data: "NewBankAccNo", visible: false },
                    { data: "NewBankIFSCCode", visible: false }
                ],
                initComplete: function () {
                    $('#load1').hide();
                }
            });
        },

        error: function (error) {
            $('#load1').hide();
            alert('error: ' + error.responseText);
        }
    });

    return false;
}

function bankapprv_Download(accNoChangeID, rowIndex) {

    var rowData = bankapprv_table.row(rowIndex).data();

    if (!rowData || !rowData.Attachment) {
        Swal.fire({
            icon: 'warning',
            title: 'File Not Found',
            text: 'Attachment is not available.'
        });
        return;
    }

    var filePath = rowData.Attachment;
   
    window.location.href = 'FileDownload.aspx?ChangeID=' + accNoChangeID;

}

function formatJsonDate(value) {
    if (!value) return "";

    var match = /\/Date\((\d+)\)\//.exec(value);
    if (!match) return "";

    return new Date(parseInt(match[1], 10)).toLocaleDateString("en-US");
}

function bankapprv_Approve(AccCnahgeID, Index) {

    var row = bankapprv_table.row(Index).data();
    acc_changeID = AccCnahgeID;

    document.getElementById("app_bankDetailsHeader").innerText = "Approved Bank Account Details -  " + row.Code + " : " + row.EmployeeName;
    document.getElementById("bankapprv_oldbankname").innerHTML = row.OldBankName;
    document.getElementById("bankapprv_oldaccno").innerHTML = row.OldBankAccNo;
    document.getElementById("bankapprv_oldifsc").innerHTML = row.OldBankIFSCCode;
    document.getElementById("bankapprv_newbankname").innerHTML = row.NewBankName;
    document.getElementById("bankapprv_newaccno").innerHTML = row.NewBankAccNo;
    document.getElementById("bankapprv_newifsc").innerHTML = row.NewBankIFSCCode;

    $("#bankapprv_Approval").modal("show");
}

function bankapprv_submit() {
    var isverify = document.getElementById("bankapprv_checkverify").checked;
    var ddlstatus = document.getElementById("bankapprv_status");
    var status = ddlstatus.options[ddlstatus.selectedIndex].value;
    var remark = document.getElementById("bankapprv_remark").value.trim();

    if (!isverify) {
        Swal.fire("Validation", "Please verify bank name, account number, and IFSC code against the attached proof.", "warning");
        return false;
    }

    if (status === "") {
        Swal.fire("Validation", "Please select appropriate status.", "warning");
        return false;
    }

    if (remark === "") {
        Swal.fire("Validation", "Please enter remark.", "warning");
        return false;
    }

    if (acc_changeID === 0) {
        Swal.fire("Error", "System is unable to collect data for selected user. Please contact administrator.", "error");
        return false;
    }

    PageMethods.ApproveBankDetails(status, remark, acc_changeID, '',
        function (result) {
            acc_changeID = 0;

            document.getElementById("bankapprv_checkverify").checked = false;
            $("#bankapprv_status").prop("selectedIndex", 0);
            $("#bankapprv_remark").val("");

            $("#bankapprv_Approval").modal("hide");

            if (result > 0) {
                Swal.fire("Success", "Details approved successfully!", "success");
            } else {
                Swal.fire("Error", "Oops! Error occurred while approving record. Please contact administrator!", "error");
            }
        },
        function (error) {
            acc_changeID = 0;
            Swal.fire("Error", error.get_message ? error.get_message() : "Something went wrong. Please contact administrator.", "error");
        }
    );

    return false;
}

function Download(attachmentId) {
    var url = '/Visits/DownloadAttachment';
    $.post(url,
        {
            //                  FilePath: filePath
        },
        function (data) {
            var response = JSON.parse(data);
            window.location = '/Visits/Download?attachmentId=' + attachmentId;
        },
        "json");
}

function core_bankapprv_Download(AccChangeID, Index) {

    var row = bankapprv_table.row(Index).data();

    var fileurl = row.Attachment;


    if (fileurl === "" || fileurl === null) {

        Swal.fire("Validation", "No attachment found.", "warning");

        return;
    }

    var lastindex = row.Attachment.lastIndexOf('\\');
    var filename = row.Attachment.substring(lastindex + 1, row.Attachment.length);
    var url = '/DownloadAttachment';
    var currenturl = window.location.href;
    var urlindex = currenturl.lastIndexOf('/');
    var firstpart = currenturl.substring(0, urlindex + 1);
    var secondpart = "DownloadFiles.aspx?ChangeID=" + AccChangeID;
    var actualurl = firstpart + secondpart;
    fetch(actualurl)
        // check to make sure you didn't have an unexpected failure (may need to check other things here depending on use case / backend)
        .then(resp => resp.status === 200 ? resp.blob() : Promise.reject('something went wrong'))
        .then(blob => {
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.style.display = 'none';
            a.href = url;
            // the filename you want
            a.download = filename;
            document.body.appendChild(a);
            a.click();
            window.URL.revokeObjectURL(url);
            // or you know, something with better UX...
            //alert('your file has downloaded!');
        })
        .catch(() => alert('Oops! It seems that there is an error while retriving attachment. Please contact administrator.'));
}



/*-------------- Pending Bank Account Details  --------------*/

function bindPendingToUpdateBankDetails_Grid() {
    $('#load1').show();
    $.ajax({
        url: "PendingToUpdateBankDetails.aspx/GetDataForPendingToUpdateBankDetails",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",


        success: function (data) {
            var dataArray = JSON.parse(data.d);

            $.each(dataArray, function (index, value) {

                pendingBankdetails_html += '<tr>';
                pendingBankdetails_html += '<td style="text-wrap: nowrap;text-align:center;">' + blankForNull((index + 1)) + '</td>';
                pendingBankdetails_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Code) + '</td>';
                pendingBankdetails_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.EmployeeName) + '</td>';
                pendingBankdetails_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.BranchName) + '</td>';
                pendingBankdetails_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.DesignationName) + '</td>';
                pendingBankdetails_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.DepartmentName) + '</td>';
                pendingBankdetails_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ProjectManager) + '</td>';
                pendingBankdetails_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#table_pendingBankdetails')) {
                pendingBankdetails_table.destroy();
            }
            $('#table_pendingBankdetails tbody').html(pendingBankdetails_html);

            pendingBankdetails_table = $('#table_pendingBankdetails').DataTable({
                dom: 'lftip',
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
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
}