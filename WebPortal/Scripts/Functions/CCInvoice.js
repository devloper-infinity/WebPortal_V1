var inv_table;
var inv_html = '';
var invd_html = '';
var inv_details;
var invtable_rec;
var inv_html_rec = '';
var sum_html = '';
var invtable_summary;
var inv_Disable_HeaderID = 0;
var DisableEnableStatus = '';
var cardnames = '';

function socialsite_bindusers() {
    var select = document.getElementById("invdetails_users");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#invdetails_users").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "../Admin/HRReportInput.aspx/GetAllEmployees", dataType: "json", contentType: "application/json",
        success: function (res1) {
            var dataArray = JSON.parse(res1.d);
            $.each(dataArray, function (data1, value1) {
                $("#invdetails_users").append($("<option></option>").val(value1.Code).html(value1.FullName));
            });
            $("#invdetails_users").append($("<option></option>").val("Other").html("Other"));
        }
    });
}

function BindYear_INV() {
    var start = new Date().getFullYear();

    var select = document.getElementById("inv_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#inv_year").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#inv_year").append($("<option></option>").val(i).html(i));
    }
}

function BindYear_INV_Rec() {
    var start = new Date().getFullYear();

    var select = document.getElementById("inv_year_rec");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#inv_year_rec").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#inv_year_rec").append($("<option></option>").val(i).html(i));
    }
}

function addOtherUser(option) {

    var option1 = option.options[option.selectedIndex].value;

    if (option1 == "Other") {

        document.getElementById("trOtherUser").style.display = '';
    }
    else {
        document.getElementById("invetails_otheruser").Value = '';
        document.getElementById("invetails_effectivedate").Value = '';
        document.getElementById("trOtherUser").style.display = 'none';
    }
}

/* update row data */
function updaterowdata(HeaderID) {
   
    var Invoiceamount = document.getElementById("inv_invoiceAmount_" + HeaderID).value;
    var remark = document.getElementById("inv_remark_" + HeaderID).value;
    var invoiceno = document.getElementById("inv_invoiceno_" + HeaderID).value;
    var utilization = document.getElementById("inv_utilization_" + HeaderID).value;
    var ddlmonth = document.getElementById("inv_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("inv_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    var diff = document.getElementById("inv_AmountDifference_" + HeaderID).value;


    var ddlCC = document.getElementById("sel_cardname_" + HeaderID);
    var ccNo = ddlCC.options[ddlCC.selectedIndex].value;

    if (ccNo == "") {
        alert("Please select Credit Card.");
        return false;
    }

    PageMethods.InsertCCMonthlyData(HeaderID, month, year, remark, invoiceno, Invoiceamount, utilization, diff, inv_OnSuccess, inv_OnError);
    return false;
}

function inv_OnSuccess(result) {
    if (result > 0) {
        alert('Details updated successfully!');
        BindInvoiceGrid();
    }
    else {
        alert('Error occured while updating details!');
    }
    return false;
}

function inv_OnError(error) {
    alert(error);
}

function GetDifference(invamt, HeaderID, Index) {

    var row = inv_table.row(Index).data();
    var contamount = row[12];

    var amount = document.getElementById(invamt.id).value;
    var diff = parseFloat(amount) - parseFloat(contamount);
    document.getElementById("inv_AmountDifference_" + HeaderID).value = parseFloat(diff).toFixed(2);
    if (parseFloat(diff) > 0) {
        alert("Header is overcharged. Please specify the reason.");
        document.getElementById("inv_AmountDifference_" + HeaderID).style.color = "red";
    }
    else if (parseFloat(diff) < 0) {
        document.getElementById("inv_AmountDifference_" + HeaderID).style.color = "green";
    }
    else {
        document.getElementById("inv_remark_" + HeaderID).value = "Contractual cost match with charged amount";
        document.getElementById("inv_AmountDifference_" + HeaderID).style.color = "black";
    }
    return false;
}

function GetCardNames() {
    $.ajax({
        type: "POST", url: "../Accounts/CreditCardMonthlyTransaction.aspx/GetCreditCards", dataType: "json", contentType: "application/json",
        success: function (res) {
          
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value1) {
                if (cardnames == "")
                    cardnames = value1.CardName1;
                else
                    cardnames = cardnames + "/" + value1.CardName1;
            })
        }
    });
}

function BindInvoiceGrid() {
    GetCardNames();

    var LoginID = document.getElementById("lbl_LoginEmpID").innerHTML;
    var ddlmonth = document.getElementById("inv_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("inv_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;

    /// month = "July";
    //year = "2025";

    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }
    $('#load1').show();
    inv_html = '';
    $.ajax({
        url: "InvoiceVerification.aspx/getAllInvocieHeaders",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {

                inv_html += '<tr>';
                inv_html += '<td style="display:none;">' + value.Attachment + '</td>';
                inv_html += '<td class=""><div class="btn-group">';
                inv_html += '<div class="btn-group">';
                inv_html += '<div type="button" data-toggle="dropdown" aria-expanded="false"><i style="color: dodgerblue; font-size:14px;" class="uil fs-0 me-2 uil-cog"></i>';
                inv_html += '<span class="sr-only"></span></div><div class="dropdown-menu" role="menu" style="">';
                inv_html += '<a class="dropdown-item" href="#!" id="ActionsEx" onclick="invoice_ViewDetails(' + value.HeaderID + ',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-file"></i></span>&nbsp;&nbsp;View Details</a>';

                if (LoginID == 9858) {
                    if (value.HeaderStatus == "Enable")
                        inv_html += '<a class="dropdown-item" href="#!" id="ActionsDisb" onclick="invoice_EnableDisabled(' + value.HeaderID + ',' + index + ');"><span style="color: red;"><i class=" uil-toggle-off"></i></span>&nbsp;&nbsp;Disable</a>';
                    else
                        inv_html += '<a class="dropdown-item" href="#!" id="ActionsDisb" onclick="invoice_EnableDisabled(' + value.HeaderID + ',' + index + ');"><span style="color: green;"><i class=" uil-toggle-on"></i></span>&nbsp;&nbsp;Enable</a>';
                }

                inv_html += '<a class="dropdown-item" href="#!" id="Actions" onclick="invoice_downloadinvoice(' + value.HeaderID + ',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-cloud-download"></i></span>&nbsp;&nbsp;Download Attachment</a><div class="dropdown-divider"></div></div></td>';
                inv_html += '<td style="display:none;">' + blankForNull(value.Header) + '</td>';
                inv_html += '<td>' + blankForNull(value.Subheader) + '</td>';
                inv_html += '<td style="text-wrap: wrap;">' + blankForNull(value.DomainName) + '</td>';
                inv_html += '<td style="text-wrap: wrap;"><label style=" width:150px;">' + blankForNull(value.Product) + '</label></td>';
                inv_html += '<td style="text-wrap: wrap;">' + blankForNull(value.PayTo) + '</td>';
                inv_html += '<td>' + blankForNull(value.Subscription) + '</td>';
                inv_html += '<td>' + blankForNull(value.CostType) + '</td>';
                inv_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.ContractualQuantity) + '</td>';
                inv_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.PerUnit) + '</td>';
                inv_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.ContractualCost) + '</td>';
                inv_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.PrevMonthContCost) + '</td>';
                inv_html += '<td style="text-wrap: wrap; text-align:center;">' + blankForNull(value.PrevMonthQuantity) + '</td>';
                inv_html += '<td style="text-wrap: wrap; text-align:center;">' + blankForNull(value.CurrentQuantity) + '</td>';
                inv_html += '<td><input type="text" style="width:70px;" id="inv_invoiceAmount_' + value.HeaderID + '" value="' + blankForNull(value.ContractualCost1) + '" onchange="return GetDifference(this,' + value.HeaderID + ',' + index + ');" /></td>';

                if (blankForNull(value.Diff) != null && blankForNull(value.Diff) != '') {
                    if (parseFloat(blankForNull(value.Diff)) > 0)
                        inv_html += '<td style="text-wrap: nowrap; text-align:center;"><input type="text" style="width:70px; color:red;" id="inv_AmountDifference_' + value.HeaderID + '" value="' + blankForNull(value.Diff) + '" /></td>';
                    else if (parseFloat(blankForNull(value.Diff)) < 0)
                        inv_html += '<td style="text-wrap: nowrap; text-align:center;"><input type="text" style="width:70px; color:green;" id="inv_AmountDifference_' + value.HeaderID + '" value="' + blankForNull(value.Diff) + '" /></td>';
                    else
                        inv_html += '<td style="text-wrap: nowrap; text-align:center;"><input type="text" style="width:70px; color:black;" id="inv_AmountDifference_' + value.HeaderID + '" value="' + blankForNull(value.Diff) + '" /></td>';
                }
                else
                    inv_html += '<td style="text-wrap: nowrap; text-align:center;"><input type="text" style="width:70px;" id="inv_AmountDifference_' + value.HeaderID + '" /></td>';
                if (blankForNull(value.Remark) != '' && blankForNull(value.Remark) != null)
                    inv_html += '<td><textarea type="text" id="inv_remark_' + value.HeaderID + '"  >' + blankForNull(value.Remark) + '</textarea></td>';
                else
                    inv_html += '<td><textarea type="text" id="inv_remark_' + value.HeaderID + '" ></textarea></td>';
                if (blankForNull(value.InvoiceNo) != '' && blankForNull(value.InvoiceNo) != null)
                    inv_html += '<td><input type="text" id="inv_invoiceno_' + value.HeaderID + '"  value="' + blankForNull(value.InvoiceNo) + '"/></td>';
                else
                    inv_html += '<td><input type="text" id="inv_invoiceno_' + value.HeaderID + '" /></td>';
                inv_html += '<td><input type="file" id="inv_attach_' + value.HeaderID + '" class="upload" onclick="return GetFiles(this);" /></td>';
                if (blankForNull(value.Utilization) != '' && blankForNull(value.Utilization) != null)
                    inv_html += '<td><input type="text" style="width:100px;" id="inv_utilization_' + value.HeaderID + '" value="' + blankForNull(value.Utilization) + '" /></td>';
                else
                    inv_html += '<td><input type="text" style="width:100px;" id="inv_utilization_' + value.HeaderID + '" /></td>';
                inv_html += '<td style="display:none;">' + blankForNull(value.Provider) + '</td>';
                inv_html += '<td style="display:none;">' + blankForNull(value.Product) + '</td>';
                inv_html += '<td style="text-wrap: nowrap;"><button id="btn_inv_' + value.HeaderID + '" class="btn btn-primary" onclick="return updaterowdata(' + value.HeaderID + ')";>Update</button></td>';
                /* inv_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.CreditCardNumber) + '</td>';*/
              
                if (cardnames != '') {
                    inv_html += '<td style="text-wrap:nowrap;"><select id="sel_cardname_' + value.HeaderID + '">';
                    inv_html += '<option value="">Select</option>';
                    const cardname = cardnames.split("/");
                    for (let i = 0; i < cardname.length; i++) {
                        let options = cardname[i];

                        if (value.CreditCardNumber == options) {

                            inv_html += '<option value="' + options + '" selected>' + options + '</option>';
                        }
                        else
                            inv_html += '<option value="' + options + '">' + options + '</option>';
                    }
                    inv_html += '</select></td>';
                }

                inv_html += '<td style="display:none;">' + blankForNull(value.HeaderStatus) + '</td>';
                inv_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#invtable')) {
                inv_table.destroy();
            }
            $('#invtable tbody').html(inv_html);

            inv_table = $('#invtable').DataTable({
                dom: 'lftip',
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

function invoice_ViewDetails(HeaderID, Index) {
    document.getElementById("invdetails_headerid").innerHTML = HeaderID;
    BindInvDetails(HeaderID);
    $("#inv_detailspop").modal("show");
}

function invdeatails_addnewuser() {
    var HeaderID = document.getElementById("invdetails_headerid").innerHTML;
    $("#inv_detailspop").modal("hide");
    $("#invdetailspopup_AddUser").modal("show");
    return false;
}

/* Enable - Disable */
function invoice_EnableDisabled(HeaderID, index) {

    var row = inv_table.row(index).data();
    var lblName = "";

    document.getElementById("nvdetails_EnableDisableRemark").value = '';

    inv_Disable_HeaderID = HeaderID;
    DisableEnableStatus = row[25];

    if (DisableEnableStatus == "Enable") {
        lblName = "Disable : " + row[3] + ' - ' + row[22];
        invdetails_btnEnableDisable.textContent = 'Disable';
    }
    else {
        lblName = "Enable : " + row[3] + ' - ' + row[22];
        invdetails_btnEnableDisable.textContent = 'Enable';
    }

    document.getElementById("invdetails_EnableDisableLbl").innerHTML = lblName;
    $('#invdetailspopup_AddEnableDisable').modal('show');
}

function invdetails_btnSetEnableDisable() {

    var remark = document.getElementById("nvdetails_EnableDisableRemark").value;

    var Status;

    if (DisableEnableStatus == "Enable")
        Status = true;
    else
        Status = false;

    if (remark == "") {
        alert("Please enter Remark.");
        document.getElementById("nvdetails_EnableDisableRemark").focus();
        return false;
    }

    PageMethods.DisabledCCHeader(inv_Disable_HeaderID, Status, remark, OnSuccess_EnableDisable, OnError_EnableDisable);
    return false;
}

function OnSuccess_EnableDisable(result) {

    $('#invdetailspopup_AddEnableDisable').modal('hide');

    var NewStatus;

    if (DisableEnableStatus == "Enable")
        NewStatus = "disabl";
    else
        NewStatus = "enabl";

    if (result > 0) {
        alert("Record " + NewStatus + "ed successfully.");
        BindInvoiceGrid();
        return false;
    }
    else {
        alert("Oops! Error occured while  " + NewStatus + "ing. Please contact administrator");
        return false;
    }
}

function OnError_EnableDisable(error) {
    alert(error.responseText);
}

/* Remove User */
function invdetails_Removeuser(InvID, Index) {
    var HeaderID = document.getElementById("invdetails_headerid").innerHTML;
    var row = inv_details.row(Index).data();
    document.getElementById("invdetails_InvID").innerHTML = InvID;
    document.getElementById("invdetails_delusers").innerHTML = row[4] + " : " + row[5];
    $("#inv_detailspop").modal("hide");
    $("#invdetailspopup_removeUser").modal("show");
    return false;
}

function invdetails_SubmitUser() {
    var HeaderID = document.getElementById("invdetails_headerid").innerHTML;
    var ddlCode = document.getElementById("invdetails_users");
    var code = ddlCode.options[ddlCode.selectedIndex].value;
    var effectivedate = document.getElementById("invetails_effectivedate").value;
    var otherUser = document.getElementById("invetails_otheruser").value;

    if (code == "") {
        alert("Please select user");
        return false;
    }

    if (code == "Other" && (otherUser == "" || otherUser == " ")) {
        alert("Please enter other");
        document.getElementById("invetails_otheruser").focus();
        return false;
    }

    if (effectivedate == "") {
        alert("Please select effective date");
        document.getElementById("invetails_effectivedate").focus();
        return false;
    }

    PageMethods.InsertCCDetails(HeaderID, code, otherUser, effectivedate, invuser_OnSuccess, invuser_OnError);
    return false;
}

function invuser_OnSuccess(result) {
    if (result > 0) {
        BindInvDetails(document.getElementById("invdetails_headerid").innerHTML);
        alert("User added successfully.");

        document.getElementById("invetails_effectivedate").value = '';
        document.getElementById("invetails_otheruser").value = '';

        $("select#invdetails_users").prop('selectedIndex', 0);
        $("#invdetailspopup_AddUser").modal("hide");
        $("#inv_detailspop").modal("show");

        return false;
    }
    else {
        alert("Error occured while adding user.");
        $("#invdetailspopup_AddUser").modal("show");
        $("#inv_detailspop").modal("hide");
        // BindInvDetails(HeaderID);
        return false;
    }
    return false;
}

function invuser_OnError(error) {
    alert(error);
}

/* Add New Product */
function addNewProduct() {

    $('#invdetailspopup_AddNewProduct').modal('show');

}

function invdetails_btnAddNewProd() {

    var PopUp_Header = document.getElementById("invdetails_NewProdHeader").value;
    var PopUp_Domain = document.getElementById("invetails_NewProdDomain").value;
    var PopUp_Product = document.getElementById("invetails_NewProdProduct").value;
    var PopUp_PayTo = document.getElementById("invdetails_NewProdPayTo").value;
    var PopUp_EffDate = document.getElementById("invdetails_NewProdEffDate").value;
    var ContQuantity = document.getElementById("invdetails_NewProdContQuantity").value;
    var ContPerUnitCost = document.getElementById("invdetails_NewProdContPerUnitCost").value;
    var ChargeableAmt = document.getElementById("invdetails_NewProdCharAmt").value;


    var PaymentFreq = document.getElementById("invdetails_NewProdPaymentFreq");
    var PopUp_PaymentFreq = PaymentFreq.options[PaymentFreq.selectedIndex].value;

    var CostType = document.getElementById("invdetails_NewProdCostType");
    var PopUp_CostType = CostType.options[CostType.selectedIndex].value;

    if (PopUp_Header == "") {
        alert("Please enter Header.");
        document.getElementById("invdetails_NewProdHeader").focus();
        return false;
    }
    if (PopUp_Domain == "") {
        alert("Please enter Domain.");
        document.getElementById("invetails_NewProdDomain").focus();
        return false;
    }
    if (PopUp_Product == "") {
        alert("Please enter Product.");
        document.getElementById("invetails_NewProdProduct").focus();
        return false;
    }
    if (PopUp_PayTo == "") {
        alert("Please enter Pay To.");
        document.getElementById("invdetails_NewProdPayTo").focus();
        return false;
    }

    if (PopUp_PaymentFreq == "Select") {
        alert("Please select Payment Frequency.");
        document.getElementById("invdetails_NewProdPaymentFreq").focus();
        return false;
    }
    if (PopUp_CostType == "Select") {
        alert("Please select Cost Type.");
        document.getElementById("invdetails_NewProdCostType").focus();
        return false;
    }
    if (PopUp_EffDate == "") {
        alert("Please enter Effective Date.");
        document.getElementById("invdetails_NewProdEffDate").focus();
        return false;
    }
    if (ContQuantity == "") {
        alert("Please enter Contractual Quantity.");
        document.getElementById("invdetails_NewProdContQuantity").focus();
        return false;
    }
    if (ContPerUnitCost == "") {
        alert("Please enter Contractual Per Unit Cost.");
        document.getElementById("invdetails_NewProdContPerUnitCost").focus();
        return false;
    }
    if (ChargeableAmt == "") {
        alert("Please enter Chargeable Amount.");
        document.getElementById("invdetails_NewProdCharAmt").focus();
        return false;
    }

    PageMethods.InsertCCInvoiceHeaders(PopUp_Header, PopUp_Domain, PopUp_Product, PopUp_PayTo, PopUp_PaymentFreq, PopUp_CostType, PopUp_EffDate, ContQuantity, ContPerUnitCost, ChargeableAmt, OnSuccess_AddNewProd, OnError_AddNewProd)
    return false
}

function OnSuccess_AddNewProd(result) {

    if (result > 0) {

        alert("Data added successfully.");
        // BindInvoiceGrid();
        location.reload();
        return false;
    }
    else {
        alert("Oops! Error occured while updating status. Please contact administrator");
        //location.reload();
        return false;
    }
}

function OnError_AddNewProd(error) {
    alert(error.responseText);
}

/* Delete User */
function invdetails_closeuser() {
    $("#invdetailspopup_AddUser").modal("hide");
    $("#inv_detailspop").modal("show");
    BindInvDetails(HeaderID);
    return false;
}

function invdetails_SubmitdelUser() {
    var HeaderID = document.getElementById("invdetails_headerid").innerHTML;
    var InvID = document.getElementById("invdetails_InvID").innerHTML;
    var effectivedate = document.getElementById("invetails_deleffectivedate").value;
    if (effectivedate == "") {
        alert("Please select effective date");
        return false;
    }
    PageMethods.RemoveCCUser(InvID, effectivedate, invuser_OnSuccessDel, invuser_OnErrorDel);
    return false;
}

function invuser_OnSuccessDel(result) {
    if (result > 0) {
        BindInvDetails(document.getElementById("invdetails_headerid").innerHTML);
        alert("User removed successfully.");
        $("#invdetailspopup_removeUser").modal("hide");
        $("#inv_detailspop").modal("show");
        return false;
    }
    else {
        alert("Error occured while removing user.");
        $("#invdetailspopup_removeUser").modal("show");
        $("#inv_detailspop").modal("hide");
        // BindInvDetails(HeaderID);
        return false;
    }
    return false;
}

function invuser_OnErrorDel(error) {
    alert(error);
}

function invdetails_closedeluser() {
    $("#invdetailspopup_removeUser").modal("hide");
    $("#inv_detailspop").modal("show");
    BindInvDetails(HeaderID);
    return false;
}


function BindInvDetails(HeaderID) {
    var ddlmonth = document.getElementById("inv_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("inv_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    $('#load1').show();
    invd_html = '';
    var i = 0;
    $.ajax({
        url: "../IT/InvoiceVerification.aspx/GetHeaderwiseDetailsRevised",
        type: "POST",
        data: "{HeaderID:" + HeaderID + ",Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                invd_html += '<tr>';
                invd_html += '<td style="text-wrap: nowrap; display:none;">' + blankForNull(value.InvID) + '</td>';
                invd_html += '<td>' + (i + 1) + '</td>';
                if (HeaderID == 27 || HeaderID == 46 || HeaderID == 48) {
                    invd_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Number) + '</td>';
                    document.getElementById("inv_headercost").style.display = "";
                    document.getElementById("inv_headername").style.display = "";
                    document.getElementById("inv_headername").innerHTML = "Calling Number";
                    invd_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Cost) + '</td>';
                }
                else if (HeaderID == 2 || HeaderID == 4) {
                    invd_html += '<td style="display:none;">' + blankForNull(value.Number) + '</td>';
                    document.getElementById("inv_headername").style.display = "none";
                    document.getElementById("inv_headercost").style.display = "none";
                    document.getElementById("inv_headername").innerHTML = "Calling Number";
                    invd_html += '<td style="text-wrap: nowrap; display:none;">' + blankForNull(value.Cost) + '</td>';
                }
                else {
                    invd_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Number) + '</td>';
                    document.getElementById("inv_headercost").style.display = "none";
                    document.getElementById("inv_headername").style.display = "";
                    document.getElementById("inv_headername").innerHTML = "Email Address";
                    invd_html += '<td style="text-wrap: nowrap;display:none;">' + blankForNull(value.Cost) + '</td>';
                }
                invd_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Code) + '</td>';
                invd_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Name) + '</td>';
                invd_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.PsuedoName) + '</td>';
                invd_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Branch) + '</td>';
                invd_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Domain) + '</td>';
                invd_html += '<td>' + blankForNull(value.CurrentStatus) + '</td>';
                invd_html += '<td style="text-align:center;"><a class="dropdown-item" href="#!" id="ActionsEx1" onclick="invdetails_Removeuser(' + value.InvID + ',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-1 me-2 uil-x"></i></span></a></td>';
                invd_html += '</tr>';
                i++;
            });

            if ($.fn.dataTable.isDataTable('#inv_details')) {
                inv_details.destroy();
            }
            $('#inv_details tbody').html(invd_html);
            //else
            inv_details = $('#inv_details').DataTable({
                dom: 'ltip',
                destroy: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                scroll: true,
                'select': {
                    'style': 'single'
                },

                initComplete: function () {
                    $('#load1').hide();
                },
                "rowCallback": function (row, data) {
                    var val = data[3];
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

function GetFiles(ID) {
    ID.addEventListener('change', getFileName);
}

function invoice_downloadinvoice(HeaderID, Index) {
    var ddlmonth = document.getElementById("inv_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("inv_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    var row = inv_table.row(Index).data();
    var fileurl = row[0];

    if (fileurl == "" || fileurl == null) {
        alert("No attachment found.");
        return;
    }
    var lastindex = row[0].lastIndexOf('\\');
    var filename = row[0].substring(lastindex + 1, row[0].length);
    var url = '/DownloadAttachment';
    var currenturl = window.location.href;
    var urlindex = currenturl.lastIndexOf('/');
    var firstpart = currenturl.substring(0, urlindex + 1);
    var secondpart = "DownloadFiles.aspx?HeaderID=" + HeaderID + "&Month=" + month + "&Year=" + year;
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

function invoice_downloadinvoice_Rec(HeaderID, Index) {
    var ddlmonth = document.getElementById("inv_month_rec");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("inv_year_rec");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    var row = invtable_rec.row(Index).data();
    var fileurl = row[0];

    if (fileurl == "" || fileurl == null) {
        alert("No attachment found.");
        return;
    }
    var lastindex = row[0].lastIndexOf('\\');
    var filename = row[0].substring(lastindex + 1, row[0].length);
    var url = '/DownloadAttachment';
    var currenturl = window.location.href;
    var urlindex = currenturl.lastIndexOf('/');
    var firstpart = currenturl.substring(0, urlindex + 1);
    var secondpart = "DownloadFiles.aspx?HeaderID=" + HeaderID + "&Month=" + month + "&Year=" + year;
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

// -------------- Approval -------------- // 

function BindInvoiceGrid_Rec() {
    BindInvoiceGrid_Rec_Summary();
    var ddlmonth = document.getElementById("inv_month_rec");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("inv_year_rec");
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
    $('#load1').show();
    inv_html_rec = '';
    $.ajax({
        url: "CreditCardReconiliation.aspx/getAllInvocieHeaders",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {

                inv_html_rec += '<tr>';
                inv_html_rec += '<td style="display:none;">' + value.Attachment + '</td>';
                inv_html_rec += '<td class=""><div class="btn-group">';
                inv_html_rec += '<div class="btn-group">';
                inv_html_rec += '<div type="button" data-toggle="dropdown" aria-expanded="false"><i style="color: dodgerblue; font-size:14px;" class="uil fs-0 me-2 uil-cog"></i>';
                inv_html_rec += '<span class="sr-only"></span></div><div class="dropdown-menu" role="menu" style="">';
                inv_html_rec += '<a class="dropdown-item" href="#!" id="ActionsEx" onclick="invoice_ViewDetails(' + value.HeaderID + ',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-file"></i></span>&nbsp;&nbsp;View Details</a>';
                inv_html_rec += '<a class="dropdown-item" href="#!" id="Actions" onclick="invoice_downloadinvoice_Rec(' + value.HeaderID + ',' + index + ');"><span style="color: forestgreen;"><i class="uil fs-0 me-2 uil-cloud-download"></i></span>&nbsp;&nbsp;Download Attachment</a><div class="dropdown-divider"></div></div></td>';
                inv_html_rec += '<td style="display:none;">' + blankForNull(value.Header) + '</td>';
                inv_html_rec += '<td>' + blankForNull(value.VStatus) + '</td>';
                inv_html_rec += '<td>' + blankForNull(value.Subheader) + '</td>';
                inv_html_rec += '<td style="text-wrap: wrap;">' + blankForNull(value.DomainName) + '</td>';
                inv_html_rec += '<td style="text-wrap: wrap;"><label style=" width:150px;">' + blankForNull(value.Product) + '</label></td>';
                inv_html_rec += '<td>' + blankForNull(value.Subscription) + '</td>';
                inv_html_rec += '<td>' + blankForNull(value.CostType) + '</td>';
                inv_html_rec += '<td style="text-wrap: wrap; text-align:center;">' + blankForNull(value.ContractualQuantity) + '</td>';
                inv_html_rec += '<td style="text-wrap: wrap; text-align:center;">' + blankForNull(value.PerUnit) + '</td>';
                inv_html_rec += '<td style="text-wrap: wrap; text-align:center;">' + blankForNull(value.ContractualCost) + '</td>';
                inv_html_rec += '<td style="text-wrap: wrap; text-align:center;">' + blankForNull(value.CurrentQuantity) + '</td>';
                inv_html_rec += '<td>' + blankForNull(value.AmountEntered) + '</td>';
                if (blankForNull(value.Diff) != null && blankForNull(value.Diff) != '') {
                    if (parseFloat(blankForNull(value.Diff)) > 0) {
                        inv_html_rec += '<td><label style="color:red;">' + blankForNull(value.Diff) + '</label></td>';
                    }
                    else if (parseFloat(blankForNull(value.Diff)) < 0) {
                        inv_html_rec += '<td><label style="color:green;">' + blankForNull(value.Diff) + '</label></td>';
                    }
                    else
                        inv_html_rec += '<td>' + blankForNull(value.Diff) + '</td>';
                }
                else
                    inv_html_rec += '<td>' + blankForNull(value.Diff) + '</td>';
                inv_html_rec += '<td>' + blankForNull(value.Remark) + '</td>';
                inv_html_rec += '<td>' + blankForNull(value.InvoiceNo) + '</td>';
                inv_html_rec += '<td style="display:none;"></td>';
                inv_html_rec += '<td>' + blankForNull(value.Utilization) + '</td>';
                inv_html_rec += '<td style="text-wrap: nowrap;">' + blankForNull(value.CreditCardNumber) + '</td>';
                inv_html_rec += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#invtable_rec')) {
                invtable_rec.destroy();
            }
            $('#invtable_rec tbody').html(inv_html_rec);
            //else
            invtable_rec = $('#invtable_rec').DataTable({
                dom: 'lftip',
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

function BindInvoiceGrid_Rec_Summary() {
    var ddlmonth = document.getElementById("inv_month_rec");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("inv_year_rec");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    document.getElementById("summonth").innerHTML = month + '-' + year;
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
    $('#load1').show();
    sum_html = '';
    $.ajax({
        url: "CreditCardReconiliation.aspx/getAllInvocieHeadersSummary",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                sum_html += '<tr>';
                sum_html += '<td style=" text-align:center;">' + blankForNull(value.CreditCardNumber) + '</td>';
                sum_html += '<td style=" text-align:center;">' + blankForNull(value.ContractualCost) + '</td>';
                sum_html += '<td style=" text-align:center;">' + blankForNull(value.InvoiceGenerated) + '</td>';
                sum_html += '<td style=" text-align:center;">' + blankForNull(value.Difference) + '</td>';
                sum_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#invtable_summary')) {
                invtable_summary.destroy();
            }
            $('#invtable_summary tbody').html(sum_html);
            //else
            invtable_summary = $('#invtable_summary').DataTable({
                dom: 't',
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
                    $('#load1').hide();
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





