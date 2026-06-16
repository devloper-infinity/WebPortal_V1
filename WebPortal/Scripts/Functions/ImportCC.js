
var invVerification;
var ver_html = '';
const chkIds = [];

var VerID_Edit;

function GetCheckedCheckboxes(ID) {
    if (ID.checked) {
        if (!chkIds.includes(ID.id)) {
            chkIds.push(ID.id);
        }
    }
    else {
        if (chkIds.includes(ID.id)) {
            chkIds.splice(chkIds.indexOf(ID.id), 1);
        }
    }
    if (chkIds.length > 0) {
        tblsendemail.style.display = '';
    }
    else {
        tblsendemail.style.display = 'none';
    }
    return false;
}


function BindYear_Import() {
    var start = new Date().getFullYear();

    var select = document.getElementById("import_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#import_year").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#import_year").append($("<option></option>").val(i).html(i));
    }
}

function ImportCCStatement() {
    var ddlmonth = document.getElementById("import_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("import_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    PageMethods.VerifyAndImport(month, year, import_OnSuccess, import_OnError);
    return false;
}

function import_OnSuccess(result) {
    
    BindVerificationGrid();
    return false;
}
function import_OnError(error) {
    alert(error);
}

function VerifyCCStatement() {
    var ddlmonth = document.getElementById("import_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("import_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;

    PageMethods.FinalVerifyStatement(month, year, final_verifyCC_OnSuccess, final_verifyCC_OnError);
    return false;
}

function final_verifyCC_OnSuccess(result) {
    alert("Statement verified successfully.");
    BindVerificationGrid();
    return false;
}
function final_verifyCC_OnError(error) {
    alert(error);
}

function SendToDepartment(Index, VerID) {
    var row = invVerification.row(Index).data();
    VerID_Edit = row[0];
    document.getElementById("import_remark_header").innerHTML = row[8];// "<b>Statement Header: </b>" + row[8];
    document.getElementById("import_remark_amount").innerHTML = row[11];//"<b>Amount: </b>" + row[11];
    document.getElementById("import_remark_systemremark").innerHTML = row[5];// "<b>system Remark: </b>" + row[5];
    $("#import_raise_popup").modal("show");
    return false;
}

function import_remark_AddRemark() {
    var VerID = VerID_Edit;
    var ddlmonth = document.getElementById("import_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("import_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    var remark = document.getElementById("import_remark_remark").value;
    var paidDate = document.getElementById("import_remark_UpPaidDate").value;

    if (remark == "") {
        alert("Please enter remark.");
        return false;
    }

    PageMethods.InsertAccountsRemark(VerID, remark, paidDate, month, year, import_remark_OnSuccess, import_remark_OnError);

    return false;
}

function import_remark_OnSuccess(result) {
    alert("Remark updated successfully.");
    BindVerificationGrid();
    $("#import_raise_popup").modal("hide");
    VerID_Edit = '';
    return false;
}

function import_remark_OnError(error) {
    alert(error);
}


function import_raise_submit() {
    $('#load1').show();
    if (chkIds.length > 0) {
        var ddlEmp = document.getElementById("import_raise_employee");
        var empid = ddlEmp.options[ddlEmp.selectedIndex].value;
        var ddlmonth = document.getElementById("import_month");
        var month = ddlmonth.options[ddlmonth.selectedIndex].value;
        var ddlyear = document.getElementById("import_year");
        var year = ddlyear.options[ddlyear.selectedIndex].value;
        var verids = "";
        for (let i = 0; i < chkIds.length; i++) {
            if (i == 0) {
                verids = chkIds[i];
            }
            else {
                verids = verids + "," + chkIds[i];
            }
        }

        if (verids != "") {
            PageMethods.SendEmailToConcernDepartment(empid, verids, month, year, import_raise_OnSuccess, import_raise_OnError);
        }
        else {
            alert("Please select at least one checkbox.");
            return false;
        }

    }
    else {
        alert("Please select at least one checkbox.");
        return false;
    }
    return false;
}

function import_raise_OnSuccess(result) {
    $('#load1').hide();
    alert("Email sent successfully.");
    BindVerificationGrid();
    return false;
}
function import_raise_OnError(error) {
    alert(error);
}

function getExistingData() {
    BindVerificationGrid();
    return false;
}



function BindVerificationGrid() {
    var ddlmonth = document.getElementById("import_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("import_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    //var month = 'December';
    //var year = '2024';
    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }
    //$('#load1').show();
    ver_html = '';
    $.ajax({
        url: "ImportCCStatement.aspx/GetCCDataForVerification",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                ver_html += '<tr>';
                ver_html += '<td style="display:none;">' + blankForNull(value.VerID) + '</td>';
                ver_html += '<td style="display:none;">' + blankForNull(value.HeaderID) + '</td>';
                if (blankForNull(value.Header) == '')
                    ver_html += '<td><input type="checkbox" id="' + value.VerID + '" onchange="return GetCheckedCheckboxes(this);" /></td>';
                else if (blankForNull(value.SystemRemark) != "Statement amount matched with charged amount")
                    ver_html += '<td><input type="checkbox" id="' + value.VerID + '" onchange="return GetCheckedCheckboxes(this);" /></td>';
                else
                    ver_html += '<td></td>';
                if (blankForNull(value.Header) == '')
                    ver_html += '<td><a href="#url" onclick="return SendToDepartment(' + index + ',' + value.VerID + ');">Add Remark</a></td>';
                else if (blankForNull(value.SystemRemark) != "Statement amount matched with charged amount")
                    ver_html += '<td><a href="#url" onclick="return SendToDepartment(' + index + ',' + value.VerID + ');">Add Remark</a></td>';
                else
                    ver_html += '<td></td>';
                if (blankForNull(value.EmailFlag1) == 'Email Sent')
                    ver_html += '<td style="text-wrap: nowrap;  color:green;">' + blankForNull(value.EmailFlag1) + '</td>';
                else if (blankForNull(value.SystemRemark) != "Statement amount matched with charged amount")
                    ver_html += '<td style="text-wrap: nowrap; ">' + blankForNull(value.EmailFlag1) + '</td>';
                else
                    ver_html += '<td style="text-wrap: nowrap; "></td>';
                if (blankForNull(value.SystemRemark) == "Statement amount matched with charged amount")
                    ver_html += '<td style="text-wrap: nowrap; color:green;">' + blankForNull(value.SystemRemark) + '</td>';
                else if (blankForNull(value.SystemRemark) == "Invoice over charged")
                    ver_html += '<td style="text-wrap: nowrap; color:red;">' + blankForNull(value.SystemRemark) + '</td>';
                else if (blankForNull(value.SystemRemark) == "Invoice over charged")
                    ver_html += '<td style="text-wrap: nowrap; color:red;">' + blankForNull(value.SystemRemark) + '</td>';
                else if (blankForNull(value.SystemRemark) == "Record not matching with system")
                    ver_html += '<td style="text-wrap: nowrap; color:brown;">' + blankForNull(value.SystemRemark) + '</td>';
                else
                    ver_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.SystemRemark) + '</td>';
                ver_html += '<td>' + blankForNull(value.Header) + '</td>';
                ver_html += '<td>' + blankForNull(value.Product) + '</td>';
                ver_html += '<td>' + blankForNull(value.StatementHeader) + '</td>';
                ver_html += '<td>' + blankForNull(value.InvoiceNo) + '</td>';
                ver_html += '<td style="text-wrap: wrap; text-align: center;"><label style=" width:150px;">' + blankForNull(value.ContractualCost) + '</label></td>';
                ver_html += '<td style="text-wrap: wrap; text-align: center;"><label style=" width:150px;">' + blankForNull(value.StatementAmount) + '</label></td>';
                ver_html += '<td style="text-wrap: wrap; text-align: center;"><label style=" width:150px;">' + blankForNull(value.InvoiceAmount) + '</label></td>';
                ver_html += '<td style="text-wrap: wrap; text-align: center;">' + blankForNull(value.Difference) + '</td>';
                ver_html += '<td style="text-wrap: wrap; text-align: center;">' + blankForNull(value.AccountsRemark) + '</td>';

                ver_html += '</tr>';

            });
            if ($.fn.dataTable.isDataTable('#invVerification')) {
                invVerification.destroy();
            }
            $('#invVerification tbody').html(ver_html);
            //else
            invVerification = $('#invVerification').DataTable({
                dom: 'lftip',
                scrollX: true,
                destroy: true,
                "paging": false,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                'select': {
                    'style': 'single'
                },

                initComplete: function () {
                    //$('#load1').hide();
                },
                "rowCallback": function (row, data) {
                    // Cell at index 5 in the row is 'Active'.
                    var val = data[3];
                },


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