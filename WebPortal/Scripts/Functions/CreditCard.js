var cardmaster_mastergrid;
var cardmaster_html = '';
var cardheader_mastergrid;
var cardheader_html = '';
var cc_masterid;
var cc_headerid;
var addinvoice_mastergrid;
var addinvoice_html = '';
var cancelinvoice_mastergrid;
var cancelinvoice_html = '';

function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

function cardmaster_bindfrom() {
    var start = 1;

    var select = document.getElementById("cardmaster_from");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#cardmaster_from").append($("<option></option>").val("").html("Select"));
    for (var i = start; i <= 31; i++) {
        $("#cardmaster_from").append($("<option></option>").val(i).html(i));
    }
}

function cardmaster_bindto() {
    var start = 1;

    var select = document.getElementById("cardmaster_to");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#cardmaster_to").append($("<option></option>").val("").html("Select"));
    for (var i = start; i <= 31; i++) {
        $("#cardmaster_to").append($("<option></option>").val(i).html(i));
    }
}

function cardmaster_submit() {
    var cardname = document.getElementById("cardmaster_cardname").value;
    var cardnumber = document.getElementById("cardmaster_cardno").value;
    var ddlstatus = document.getElementById("cardmaster_cardstatus");
    var cardstatus = ddlstatus.options[ddlstatus.selectedIndex].value;
    var ddlfrom = document.getElementById("cardmaster_from");
    var cardfrom = ddlfrom.options[ddlfrom.selectedIndex].value;
    var ddlto = document.getElementById("cardmaster_to");
    var cardto = ddlto.options[ddlto.selectedIndex].value;
    var description = document.getElementById("cardmaster_description").value;

    if (cardname == "") {
        alert("Please enter card name.");
        return false;
    }
    if (cardnumber == "") {
        alert("Please enter card number.");
        return false;
    }
    if (cardstatus == "") {
        alert("Please enter card status.");
        return false;
    }
    if (cardfrom == "") {
        alert("Please enter billing cycle (from).");
        return false;
    }
    if (cardto == "") {
        alert("Please enter billing cycle (to).");
        return false;
    }
    if (cc_masterid != '' && cc_masterid != undefined)
        PageMethods.EditCreditCardMaster(cc_masterid, cardname, cardnumber, cardstatus, cardfrom, cardto, description, cardmaster_OnSuccess, cardmaster_OnError);
    else
        PageMethods.InsertCreditCardMaster(cardname, cardnumber, cardstatus, cardfrom, cardto, description, cardmaster_OnSuccess, cardmaster_OnError);
    return false;
}

function cardmaster_OnSuccess(result) {
    if (result == -1) {
        alert("Card Number alredy exists.");
        return false;
    }
    alert("Credit card inserted successfully.");
    cardmaster_bindgrid();
    document.getElementById("cardmaster_btnreset").style.display = 'none';
    document.getElementById("cardmaster_cardname").value = "";
    document.getElementById("cardmaster_cardno").value = "";
    document.getElementById("cardmaster_cardstatus").selectedIndex = 0;
    document.getElementById("cardmaster_from").selectedIndex = 0;
    document.getElementById("cardmaster_to").selectedIndex = 0;
    document.getElementById("cardmaster_description").value = "";
    cc_masterid = '';
    return false;
}

function cardmaster_OnError(error) {
    alert(error);
}

function Edit_CardMaster(Index, MasterID) {
    cc_masterid = MasterID;
    var row = cardmaster_mastergrid.row(Index).data();
    document.getElementById("cardmaster_cardname").value = row[1];
    document.getElementById("cardmaster_cardno").value = row[2];
    $("#cardmaster_cardstatus").val(row[3]);
    $("#cardmaster_from").val(row[4]);
    $("#cardmaster_to").val(row[5]);
    document.getElementById("cardmaster_description").value = row[6];
    document.getElementById("cardmaster_btnreset").style.display = '';
}

function cardmaster_bindgrid() {
    $('#load1').show();
    cardmaster_html = '';
    $.ajax({
        url: "CreditCardMaster.aspx/GetAllCC_Master",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                var addeddate = eval(value.AddedDate.replace(/\/Date\((\d+)\)\//gi, "new Date($1).toLocaleDateString(\"en-US\")"));
                cardmaster_html += '<tr>';
                cardmaster_html += '<td><a href="#url" onclick="return Edit_CardMaster(' + index + ',' + value.masterID + ');"><i style="color: dodgerblue; font-size:14px;" class="uil fs-0 me-2 uil-pen"></i></a></td>';
                cardmaster_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.CardName) + '</td>';
                cardmaster_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.CardNo) + '</td>';
                cardmaster_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.Status) + '</td>';
                cardmaster_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.BillingFrom) + '</td>';
                cardmaster_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.BillingTo) + '</td>';
                cardmaster_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Description) + '</td>';
                cardmaster_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.AddedByName) + '</td>';
                cardmaster_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(addeddate) + '</td>';
                cardmaster_html += '<td style="text-wrap: nowrap; text-align:center; display:none;">' + blankForNull(value.masterID) + '</td>';
                cardmaster_html += '</tr>';

            });

            if ($.fn.dataTable.isDataTable('#cardmaster_mastergrid')) {
                cardmaster_mastergrid.destroy();
            }
            $('#cardmaster_mastergrid tbody').html(cardmaster_html);
            //else
            cardmaster_mastergrid = $('#cardmaster_mastergrid').DataTable({
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

function Edit_CardHeaderMaster(Index, HeaderID) {
    cc_headerid = HeaderID;
    var row = cardheader_mastergrid.row(Index).data();
    document.getElementById("cardheader_header").value = row[1];
    $("#cardheader_cardstatus").val(row[2]);
    document.getElementById("cardheader_description").value = row[3];
    document.getElementById("cardheader_btnreset").style.display = '';
}

function cardheader_bindgrid() {
    $('#load1').show();
    cardheader_html = '';
    $.ajax({
        url: "CreditCardMaster.aspx/GetCreditCardHeaderMaster",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                var addeddate = eval(value.AddedDate.replace(/\/Date\((\d+)\)\//gi, "new Date($1).toLocaleDateString(\"en-US\")"));
                cardheader_html += '<tr>';
                cardheader_html += '<td><a href="#url" onclick="return Edit_CardHeaderMaster(' + index + ',' + value.HeaderID + ');"><i style="color: dodgerblue; font-size:14px;" class="uil fs-0 me-2 uil-pen"></i></a></td>';
                cardheader_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.Header) + '</td>';
                cardheader_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.Status) + '</td>';
                cardheader_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.Description) + '</td>';
                cardheader_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.AddedByName) + '</td>';
                cardheader_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(addeddate) + '</td>';
                cardheader_html += '<td style="text-wrap: nowrap; text-align:center; display:none;">' + blankForNull(value.HeaderID) + '</td>';
                cardheader_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#cardheader_mastergrid')) {
                cardheader_mastergrid.destroy();
            }
            $('#cardheader_mastergrid tbody').html(cardheader_html);
            //else
            cardheader_mastergrid = $('#cardheader_mastergrid').DataTable({
                dom: 'lftip',
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
                    jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');
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

function cardheader_submit() {
    var cardheader = document.getElementById("cardheader_header").value;
    var headerddlstatus = document.getElementById("cardheader_cardstatus");
    var headerstatus = headerddlstatus.options[headerddlstatus.selectedIndex].value;
    var headerdescription = document.getElementById("cardheader_description").value;
    if (cardheader == "") {
        alert("Please enter card header.");
        return false;
    }
    if (headerstatus == "") {
        alert("Please enter header status.");
        return false;
    }
    if (headerdescription == "") {
        alert("Please enter header description.");
        return false;
    }
    if (cc_headerid != '' && cc_headerid != undefined)
        PageMethods.EditCreditCardHeaderMaster(cc_headerid, cardheader, headerstatus, headerdescription, header_OnSucess, header_OnError);
    else
        PageMethods.InsertCreditCardHeaderMaster(cardheader, headerstatus, headerdescription, header_OnSucess, header_OnError);
    return false;
}

function header_OnSucess(result) {
    if (result == -1) {
        alert("Card Header alredy exists.");
        return false;
    }
    alert("Header updated successfully.");
    cardheader_bindgrid();
    document.getElementById("cardheader_btnreset").style.display = 'none';
    document.getElementById("cardheader_header").value = "";
    document.getElementById("cardheader_cardstatus").selectedIndex = 0;
    document.getElementById("cardheader_description").value = "";
    cc_headerid = '';
    return false;
}

function header_OnError(error) {
    alert(error);
}

function addinvoice_submit() {
    var ddlcard = document.getElementById("addinvoice_creditcard");
    var cardid = ddlcard.options[ddlcard.selectedIndex].value;
    var ddlusedfor = document.getElementById("addinvoice_usedfor");
    var usedfor = ddlusedfor.options[ddlusedfor.selectedIndex].text;
    var ddlusedby = document.getElementById("addinvoice_usedby");
    var usedby = ddlusedfor.options[ddlusedby.selectedIndex].text;
    var invoiceno = document.getElementById("addinvoice_invoiceno").value;
    var amount = document.getElementById("addinvoice_amount").value;
    var ddlcurrency = document.getElementById("addinvoice_currency");
    var currency = ddlcurrency.options[ddlcurrency.selectedIndex].value;
    var invoicedate = document.getElementById("addinvoice_invoicedate").value;
    var paiddate = document.getElementById("addinvoice_paiddate").value;
    var remark = document.getElementById("addinvoice_remark").value;
    if (cardid == "") {
        alert("Please select credit card");
        return false;
    }
    if (usedfor == "") {
        alert("Please select Used For (Header)");
        return false;
    }
    if (usedby == "") {
        alert("Please select Used By");
        return false;
    }
    if (invoiceno == "") {
        alert("Please enter invoice number");
        return false;
    }
    if (invoicedate == "") {
        alert("Please enter invoice date");
        return false;
    }
    if (amount == "") {
        alert("Please enter amount");
        return false;
    }
    if (currency == "") {
        alert("Please select currency");
        return false;
    }
    if (paiddate == "") {
        alert("Please enter paid date");
        return false;
    }
    PageMethods.InsertCreditCardInvoice(cardid, usedfor, usedby, invoiceno, invoicedate, amount, currency, paiddate, remark, addinvoice_OnSuccess, addinvoice_OnError);
    return false;
}

function addinvoice_OnSuccess(result) {
    alert("Invoice updated successfully.");
    addinvoice_bindgrid();
    document.getElementById("addinvoice_invoiceno").value = "";
    document.getElementById("addinvoice_creditcard").selectedIndex = 0;
    document.getElementById("addinvoice_usedfor").selectedIndex = 0;
    document.getElementById("addinvoice_usedby").selectedIndex = 0;
    document.getElementById("addinvoice_currency").selectedIndex = 0;
    document.getElementById("addinvoice_paiddate").value = "";
    document.getElementById("addinvoice_remark").value = "";
    document.getElementById("addinvoice_attachment").value = "";
    document.getElementById("filesdiv").innerHTML = "";

    //cc_headerid = '';
    return false;
}

function addinvoice_OnError(error) {
    alert(error);
}

function BindCreditCards() {
    var select = document.getElementById("addinvoice_creditcard");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#addinvoice_creditcard").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "CreditCardMonthlyTransaction.aspx/GetCreditCards", dataType: "json", contentType: "application/json",
        success: function (res1) {
            var dataArray = JSON.parse(res1.d);
            $.each(dataArray, function (data1, value1) {
                $("#addinvoice_creditcard").append($("<option></option>").val(value1.masterID).html(value1.CardName));
            });
        }
    });
}

function BindUsedBy() {
    var select = document.getElementById("addinvoice_usedby");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#addinvoice_usedby").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "../Admin/HRReportInput.aspx/GetAllEmployees", dataType: "json", contentType: "application/json",
        success: function (res1) {
            var dataArray = JSON.parse(res1.d);
            $.each(dataArray, function (data1, value1) {
                $("#addinvoice_usedby").append($("<option></option>").val(value1.Code).html(value1.FullName));
            });
        }
    });
}

function BindUsedFor() {
    var select = document.getElementById("addinvoice_usedfor");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#addinvoice_usedfor").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "CreditCardMaster.aspx/GetCreditCardHeaderMaster", dataType: "json", contentType: "application/json",
        success: function (res1) {
            var dataArray = JSON.parse(res1.d);
            $.each(dataArray, function (data1, value1) {
                $("#addinvoice_usedfor").append($("<option></option>").val(value1.HeaderID).html(value1.Header));
            });
        }
    });
}

function addinvoice_bindgrid() {
    $('#load1').show();
    addinvoice_html = '';
    $.ajax({
        url: "CreditCardMonthlyTransaction.aspx/GetCreditCardInvoice",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                var addeddate = eval(value.AddedDate.replace(/\/Date\((\d+)\)\//gi, "new Date($1).toLocaleDateString(\"en-US\")"));
                addinvoice_html += '<tr>';
                addinvoice_html += '<td style="display:none;"><a href="#url" onclick="return Edit_CardHeaderMaster(' + index + ',' + value.InvoiceID + ');"><i style="color: dodgerblue; font-size:14px;" class="uil fs-0 me-2 uil-pen"></i></a></td>';
                addinvoice_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.CreditCard) + '</td>';
                addinvoice_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.UsedFor) + '</td>';
                addinvoice_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.UsedBy) + '</td>';
                addinvoice_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.InvoiceNo) + '</td>';
                addinvoice_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.InvoiceDate) + '</td>';
                addinvoice_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.Amount) + '</td>';
                addinvoice_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.Currency) + '</td>';
                addinvoice_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.PaidDate) + '</td>';
                addinvoice_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.Remark) + '</td>';
                addinvoice_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(addeddate) + '</td>';
                addinvoice_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.AddedByName) + '</td>';
                addinvoice_html += '<td style="text-wrap: nowrap; text-align:center; display:none;">' + blankForNull(value.InvoiceID) + '</td>';
                addinvoice_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#addinvoice_mastergrid')) {
                addinvoice_mastergrid.destroy();
            }
            $('#addinvoice_mastergrid tbody').html(addinvoice_html);
            //else
            addinvoice_mastergrid = $('#addinvoice_mastergrid').DataTable({
                dom: 'lftip',
                destroy: true,
                scrollX: true,
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
                    //jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');
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

function BindCreditCards_Cancel() {
    var select = document.getElementById("cancelinvoice_creditcard");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#cancelinvoice_creditcard").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "CreditCardMonthlyTransaction.aspx/GetCreditCards", dataType: "json", contentType: "application/json",
        success: function (res1) {
            var dataArray = JSON.parse(res1.d);
            $.each(dataArray, function (data1, value1) {
                $("#cancelinvoice_creditcard").append($("<option></option>").val(value1.masterID).html(value1.CardName));
            });
        }
    });
}

function cancelinvoice_show() {
    cancelinvoice_bindgrid();
    return false;
}

function CancelInvoice(Index, InvoiceID) {
    document.getElementById("cancelinvoice_pop_ID").innerHTML = InvoiceID;
    var row = cancelinvoice_mastergrid.row(Index).data();
    var ddlcancard = document.getElementById("cancelinvoice_creditcard");
    var cancelcard = ddlcancard.options[ddlcancard.selectedIndex].text;
    document.getElementById("cancelinvoice_pop_creditcard").innerHTML = cancelcard;
    document.getElementById("cancelinvoice_pop_refundamount").value = row[5];
    document.getElementById("cancelinvoice_pop_currency").innerHTML = row[6];
    $("#cancelinvoice_popup").modal("show");
}

function cancelinvoice_pop_closeinvoice() {
    document.getElementById("cancelinvoice_pop_creditcard").innerHTML = "";
    document.getElementById("cancelinvoice_pop_refundamount").value = "";
    document.getElementById("cancelinvoice_pop_creditamount").value = "";
    document.getElementById("cancelinvoice_pop_remark").value = "";
    document.getElementById("cancelinvoice_pop_currency").innerHTML = "";
    $("#cancelinvoice_popup").modal("hide");

}

function cancelinvoice_pop_cancelinvoice() {
    var InvoiceID = document.getElementById("cancelinvoice_pop_ID").innerHTML;
    var creditamount = document.getElementById("cancelinvoice_pop_creditamount").value;
    var cancelamount = document.getElementById("cancelinvoice_pop_refundamount").value;
    var cancelremark = document.getElementById("cancelinvoice_pop_remark").value;
    PageMethods.CancelCreditCardInvoice(InvoiceID, creditamount, cancelamount, cancelremark, cancelinvoice_OnSuccess, cancelinvoice_OnError);

    return false;
}

function cancelinvoice_OnSuccess(result) {
    if (result == -1) {
        alert("Error occured while cancelling invoice.");
        return false;
    }
    alert("Invoice cancelled successfully.");
    cancelinvoice_bindgrid();
    document.getElementById("cancelinvoice_pop_creditcard").innerHTML = "";
    document.getElementById("cancelinvoice_pop_refundamount").value = "";
    document.getElementById("cancelinvoice_pop_creditamount").value = "";
    document.getElementById("cancelinvoice_pop_remark").value = "";
    document.getElementById("cancelinvoice_pop_currency").innerHTML = "";
    $("#cancelinvoice_popup").modal("hide");
    return false;
}

function cancelinvoice_OnError(error) {
    alert(error);
}

function cancelinvoice_bindgrid() {
    var ddlcard = document.getElementById("cancelinvoice_creditcard");
    var card = ddlcard.options[ddlcard.selectedIndex].value;
    var fromdate = document.getElementById("cancelinvoice_from").value;
    var todate = document.getElementById("cancelinvoice_to").value;
   
    $('#load1').show();
    cancelinvoice_html = '';
    $.ajax({
        url: "CreditCardMonthlyTransaction.aspx/GetCreditCardInvoice_cancel",
        type: "POST",
        dataType: "json",
        data: "{CardId:" + card + ", FromDate:'" + fromdate + "', ToDate:'" + todate + "'}",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                var addeddate = eval(value.AddedDate.replace(/\/Date\((\d+)\)\//gi, "new Date($1).toLocaleDateString(\"en-US\")"));
                cancelinvoice_html += '<tr>';
                cancelinvoice_html += '<td><a href="#url" onclick="return CancelInvoice(' + index + ',' + value.InvoiceID + ');"><i style="color: dodgerblue; font-size:14px;" class="uil fs-0 me-2 uil-pen"></i></a></td>';
                cancelinvoice_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.UsedFor) + '</td>';
                cancelinvoice_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.UsedBy) + '</td>';
                cancelinvoice_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.InvoiceNo) + '</td>';
                cancelinvoice_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.InvoiceDate) + '</td>';
                cancelinvoice_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.Amount) + '</td>';
                cancelinvoice_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.Currency) + '</td>';
                cancelinvoice_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.PaidDate) + '</td>';
                cancelinvoice_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.Remark) + '</td>';
                cancelinvoice_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.AddedByName) + '</td>';
                cancelinvoice_html += '<td style="text-wrap: nowrap; text-align:center; display:none;">' + blankForNull(value.InvoiceID) + '</td>';
                cancelinvoice_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#cancelinvoice_mastergrid')) {
                cancelinvoice_mastergrid.destroy();
            }
            $('#cancelinvoice_mastergrid tbody').html(cancelinvoice_html);
            //else
            cancelinvoice_mastergrid = $('#cancelinvoice_mastergrid').DataTable({
                dom: 'lftip',
                destroy: true,
                scrollX: true,
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
                    //jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');
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



