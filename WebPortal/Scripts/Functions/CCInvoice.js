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
var invoiceProjects = [];
var invoiceProjectsLoaded = false;
var invoiceStatusTab = 'active';
var invoiceStatusFilterRegistered = false;

function invoiceHeaderIsDeactivated(value) {
    return /^(1|true|yes|disable|disabled|deactivated|inactive)$/.test($.trim(String(value == null ? '' : value)).toLowerCase());
}

function registerInvoiceStatusFilter() {
    if (invoiceStatusFilterRegistered || !$.fn.dataTable) return;
    $.fn.dataTable.ext.search.push(function (settings, data) {
        if (!settings.nTable || settings.nTable.id !== 'invtable') return true;
        var disabled = invoiceHeaderIsDeactivated(data[28]);
        return invoiceStatusTab === 'deactivated' ? disabled : !disabled;
    });
    invoiceStatusFilterRegistered = true;
}

function applyInvoiceStatusTab(tab) {
    invoiceStatusTab = tab === 'deactivated' ? 'deactivated' : 'active';
    $('#invtab_active').attr('aria-selected', invoiceStatusTab === 'active' ? 'true' : 'false');
    $('#invtab_deactivated').attr('aria-selected', invoiceStatusTab === 'deactivated' ? 'true' : 'false');
    registerInvoiceStatusFilter();
    if ($.fn.dataTable.isDataTable('#invtable')) $('#invtable').DataTable().draw();
}

function invoiceEscape(value) {
    return $('<div/>').text(value == null ? '' : String(value)).html();
}

function invoiceText(value) {
    return value == null || typeof value === 'object' ? '' : $.trim(String(value));
}

function invoiceCardOptions(value) {
    var saved = invoiceText(value.CreditCard) || invoiceText(value.CreditCardNumber) || invoiceText(value.CreditCardNo);
    var options = '<option value="">Select</option>', found = false, seen = {};
    $.each(cardnames ? cardnames.split('/') : [], function (_, name) {
        name = invoiceText(name);
        var key = name.toLowerCase();
        if (!name || seen[key]) return;
        seen[key] = true;
        var selected = saved && key === saved.toLowerCase();
        if (selected) found = true;
        options += '<option value="' + invoiceEscape(name).replace(/"/g, '&quot;') + '"' + (selected ? ' selected' : '') + '>' + invoiceEscape(name) + '</option>';
    });
    if (saved && !found)
        options += '<option value="' + invoiceEscape(saved).replace(/"/g, '&quot;') + '" selected>' + invoiceEscape(saved) + '</option>';
    return options;
}

function invoiceAttachmentLink(value, month, year) {
    var url = '';
    if (invoiceText(value.Attachment)) {
        url = 'DownloadFiles.aspx?HeaderID=' + encodeURIComponent(value.HeaderID) + '&amp;Month=' + encodeURIComponent(month) + '&amp;Year=' + encodeURIComponent(year);
    } else if (parseInt(value.DocumentID, 10) > 0 && invoiceText(value.DocumentPath)) {
        url = 'InvoiceVerificationUpload.ashx?DocumentID=' + parseInt(value.DocumentID, 10);
    }
    return url ? '<a class="btn-invoice btn-invoice-soft" href="' + url + '"><i class="fas fa-download" aria-hidden="true"></i>Download</a>' : '<span class="text-muted">No attachment</span>';
}

function invoiceDateValue(value) {
    if (value == null || value === '' || typeof value === 'object') return '';
    var text = String(value), isoDate = /^(\d{4}-\d{2}-\d{2})/.exec(text);
    if (isoDate) return isoDate[1];
    var dotNetDate = /^\/Date\((-?\d+)(?:[+-]\d{4})?\)\/$/.exec(text);
    var date = new Date(dotNetDate ? Number(dotNetDate[1]) : text);
    if (isNaN(date.getTime())) return '';
    var year = dotNetDate ? date.getUTCFullYear() : date.getFullYear();
    var month = (dotNetDate ? date.getUTCMonth() : date.getMonth()) + 1;
    var day = dotNetDate ? date.getUTCDate() : date.getDate();
    return year + '-' + ('0' + month).slice(-2) + '-' + ('0' + day).slice(-2);
}

function invoiceProjectName(value) {
    if (value.ProjectName) return value.ProjectName;
    for (var i = 0; i < invoiceProjects.length; i++)
        if (String(invoiceProjects[i].ProjectID) === String(value.ProjectID)) return invoiceProjects[i].ProjectName || '';
    return '';
}

function BindInvoiceProjects() {
    if (invoiceProjectsLoaded) return $.Deferred().resolve().promise();
    return $.ajax({ type: 'POST', url: 'InvoiceVerification.aspx/GetInvoiceProjects', data: '{}', dataType: 'json', contentType: 'application/json; charset=utf-8' })
        .done(function (response) { invoiceProjects = JSON.parse(response.d || '[]'); invoiceProjectsLoaded = true; });
}

function BindInvoiceDomains(selectedDomain) {
    return $.ajax({ type: 'POST', url: 'InvoiceVerification.aspx/GetInvoiceDomains', data: '{}', dataType: 'json', contentType: 'application/json; charset=utf-8' })
        .done(function (response) {
            var domains = JSON.parse(response.d || '[]'), filter = $('#inv_domain'), product = $('#invetails_NewProdDomain');
            var selected = selectedDomain || filter.val() || '';
            filter.empty().append($('<option>').val('').text('All Domains'));
            product.empty().append($('<option>').val('').text('Select'));
            $.each(domains, function (_, domain) {
                filter.append($('<option>').val(domain).text(domain));
                product.append($('<option>').val(domain).text(domain));
            });
            product.append($('<option>').val('__add_new__').text('Add New Domain'));
            filter.val(selected);
        });
}

function invoiceDomainChanged() {
    $('#invdetails_NewDomainField').toggle($('#invetails_NewProdDomain').val() === '__add_new__');
}

function invoiceFileChanged(input) {
    var file = input.files[0], box = $(input).closest('.invoice-upload');
    if (file && (file.size > 10 * 1024 * 1024 || !/\.(pdf|png|jpe?g|docx?|xlsx?)$/i.test(file.name))) {
        alert('Choose a PDF, image, Word or Excel file up to 10 MB.');
        input.value = ''; file = null;
    }
    box.toggleClass('has-file', !!file);
    box.find('.invoice-file-name').text(file ? file.name : 'Choose or drop a file');
    box.find('.invoice-file-remove').prop('hidden', !file);
}

function invoiceFileDrop(event, id) {
    event.preventDefault();
    var input = document.getElementById('inv_attach_' + id);
    $(input).closest('.invoice-upload').removeClass('drag-over');
    if (input.disabled || !event.dataTransfer || !event.dataTransfer.files.length) return;
    if (event.dataTransfer.files.length !== 1) { alert('Choose one file per invoice.'); return; }
    try { input.files = event.dataTransfer.files; invoiceFileChanged(input); }
    catch (error) { alert('Use Choose file to attach your document.'); }
}

function invoiceFileRemove(button) {
    var input = $(button).closest('.invoice-upload').find('input[type=file]')[0];
    input.value = ''; invoiceFileChanged(input);
}

function invver_bindusers() {
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
        document.getElementById("invetails_otheruser").value = '';
        document.getElementById("invetails_effectivedate").value = '';
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

    var billingdate = document.getElementById("inv_billingdate_" + HeaderID).value;


    if (ccNo == "") {
        alert("Please select Credit Card.");
        return false;
    }

    if (billingdate == "") {
        alert("Please enter Billing Date.");
        return false;
    }

    if (!month || month === 'All' || !year) { alert('Please select a specific invoice month and year.'); return false; }
    if (Invoiceamount === '' || !isFinite(Number(Invoiceamount)) || Number(Invoiceamount) < 0) { alert('Please enter a valid invoice amount.'); return false; }
    var input = document.getElementById('inv_attach_' + HeaderID);
    var file = input && input.files.length ? input.files[0] : null;
    if (file && (!file.size || file.size > 10 * 1024 * 1024 || !/\.(pdf|png|jpe?g|docx?|xlsx?)$/i.test(file.name))) {
        alert('Choose a non-empty PDF, image, Word or Excel file up to 10 MB.');
        return false;
    }
    var button = $('#btn_inv_' + HeaderID);
    if (button.prop('disabled')) return false;
    var form = new FormData();
    form.append('HeaderID', HeaderID); form.append('Month', month); form.append('Year', year);
    form.append('Remark', remark); form.append('InvoiceNo', invoiceno); form.append('InvoiceAmount', Invoiceamount);
    form.append('Utilization', utilization); form.append('Difference', diff); form.append('CCNo', ccNo); form.append('BillingDate', billingdate);
    if (file) form.append('InvoiceFile', file, file.name);
    button.prop('disabled', true);
    showInvoiceLoader();
    $.ajax({ url: 'InvoiceVerificationUpload.ashx', type: 'POST', data: form, processData: false, contentType: false, dataType: 'json' })
        .done(function (result) {
            if (result && result.success) inv_OnSuccess(1);
            else alert(result && result.message ? result.message : 'Unable to save the invoice.');
        })
        .fail(function (request) {
            alert(request.responseJSON && request.responseJSON.message ? request.responseJSON.message : 'Unable to save the invoice. Please retry.');
        })
        .always(function () { button.prop('disabled', false); hideInvoiceLoader(); });
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

    var amount = parseFloat(document.getElementById(invamt.id).value) || 0;
    var contractAmount = parseFloat(contamount) || 0;
    var diff = amount - contractAmount;
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
    cardnames = '';
    return $.ajax({
        type: "POST", url: "../Accounts/CreditCardMonthlyTransaction.aspx/GetCreditCards", dataType: "json", contentType: "application/json",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value1) {
                if (cardnames == "")
                    cardnames = value1.CardName1;
                else
                    cardnames = cardnames + "/" + value1.CardName1;
            })
        },
        error: function () {
            cardnames = '';
        }
    });
}

function BindInvoiceGrid() {
    var LoginID = document.getElementById("lbl_LoginEmpID").innerHTML;
    var ddlmonth = document.getElementById("inv_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("inv_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    var domain = document.getElementById("inv_domain").value;

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
    registerInvoiceStatusFilter();
    $.when(GetCardNames(), BindInvoiceProjects()).always(function () {
        $.ajax({
            url: "InvoiceVerification.aspx/getAllInvocieHeaders",
            type: "POST",
            data: JSON.stringify({ Month: month, Year: year, Domain: domain }),
            dataType: "json",
            contentType: "application/json; charset=utf-8",

            success: function (data) {
                try {
                var dataArray = JSON.parse(data.d);//
                $.each(dataArray, function (index, value) {

                    var isDisabled = invoiceHeaderIsDeactivated(value.HeaderStatus);
                    inv_html += '<tr' + (isDisabled ? ' class="invoice-row-disabled"' : '') + '>';
                    inv_html += '<td style="display:none;">' + invoiceEscape(invoiceText(value.Attachment)) + '</td>';
                    inv_html += '<td class="invoice-details-cell"><div class="btn-group">';
                    inv_html += '<a href="#" role="button" class="invoice-settings" data-toggle="dropdown" aria-expanded="false" aria-label="Invoice actions"><i class="uil uil-cog" aria-hidden="true"></i></a><div class="dropdown-menu" role="menu">';
                    inv_html += '<a class="dropdown-item" href="' + invoice_UserMappingUrl(value.HeaderID, month, year) + '" id="ActionsEx"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-file"></i></span>&nbsp;&nbsp;View Details</a>';
                    inv_html += '<a class="dropdown-item" href="#!" onclick="invoice_ViewDetailsLegacy(' + value.HeaderID + ',' + index + ');"><span style="color: slategray;"><i class="uil uil-window"></i></span>&nbsp;&nbsp;Legacy Details Popup</a>';

                    if (LoginID == 9858) {
                        if (value.HeaderStatus == "Enable")
                            inv_html += '<a class="dropdown-item" href="#!" id="ActionsDisb" onclick="invoice_EnableDisabled(' + value.HeaderID + ',' + index + ');"><span style="color: red;"><i class=" uil-toggle-off"></i></span>&nbsp;&nbsp;Disable</a>';
                        else
                            inv_html += '<a class="dropdown-item" href="#!" id="ActionsDisb" onclick="invoice_EnableDisabled(' + value.HeaderID + ',' + index + ');"><span style="color: green;"><i class=" uil-toggle-on"></i></span>&nbsp;&nbsp;Enable</a>';
                    }

                    inv_html += '<a class="dropdown-item" href="#!" id="Actions" onclick="invoice_downloadinvoice(' + value.HeaderID + ',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-cloud-download"></i></span>&nbsp;&nbsp;Download Attachment</a><div class="dropdown-divider"></div></div></div></td>';
                    inv_html += '<td style="display:none;">' + blankForNull(value.Header) + '</td>';
                    inv_html += '<td>' + blankForNull(value.Subheader) + '</td>';
                    inv_html += '<td style="text-wrap: wrap;">' + blankForNull(value.DomainName) + '</td>';
                    // inv_html += '<td>' + invoiceEscape(invoiceProjectName(value)) + '<input type="hidden" id="inv_project_' + value.HeaderID + '" value="' + (parseInt(value.ProjectID, 10) || '') + '" /></td>';
                    inv_html += '<td class="invoice-product-cell"><span class="invoice-product-text">' + invoiceEscape(value.Product) + '</span></td>';
                    inv_html += '<td style="text-wrap: wrap;">' + blankForNull(value.PayTo) + '</td>';
                    inv_html += '<td>' + blankForNull(value.Subscription) + '</td>';
                    inv_html += '<td>' + blankForNull(value.CostType) + '</td>';
                    inv_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.ContractualQuantity) + '</td>';
                    inv_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.PerUnit) + '</td>';
                    inv_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.ContractualCost) + '</td>';
                    inv_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.PrevMonthContCost) + '</td>';
                    inv_html += '<td style="text-wrap: wrap; text-align:center;">' + blankForNull(value.PrevMonthQuantity) + '</td>';
                    inv_html += '<td style="text-wrap: wrap; text-align:center;">' + blankForNull(value.CurrentQuantity) + '</td>';
                    inv_html += '<td style="text-wrap: wrap; text-align:center;">' + blankForNull(value.ContractualUsage) + '</td>';
                    var activeFrom = invoiceDateValue(value.EffectiveFrom);
                    var activeThrough = invoiceDateValue(value.EffectiveTo);
                    // inv_html += '<td id="inv_activefrom_' + value.HeaderID + '" data-date-value="' + activeFrom + '">' + invoiceEscape(activeFrom) + '</td>';
                    // inv_html += '<td id="inv_activethrough_' + value.HeaderID + '" data-date-value="' + activeThrough + '">' + invoiceEscape(activeThrough) + '</td>';

                    // inv_html += '<td style="text-wrap: wrap; text-align:center;">' + blankForNull(value.EffectiveDate) + '</td>';
                    // inv_html += '<td style="text-wrap: wrap; text-align:center;">' + blankForNull(value.DisabledDate) + '</td>';

                    inv_html += '<td style="text-wrap: wrap; text-align:center;">' + invoiceEscape(activeFrom) + '</td>';
                    inv_html += '<td style="text-wrap: wrap; text-align:center;">' + invoiceEscape(activeThrough) + '</td>';

                    inv_html += '<td><input  type="number" step="0.01" onpaste="return false;" style="width:70px;" id="inv_invoiceAmount_' + value.HeaderID + '" value="' + blankForNull(value.ContractualCost1) + '" onchange="return GetDifference(this,' + value.HeaderID + ',' + index + ');" /></td>';

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
                    inv_html += '<td><input type="date" id="inv_billingdate_' + value.HeaderID + '" aria-label="Billing Date" value="' + invoiceDateValue(value.BillingDate) + '" /></td>';
                    inv_html += '<td>';
                    inv_html += '<div class="invoice-upload" ondragover="event.preventDefault(); if (!this.querySelector(\'input\').disabled) this.classList.add(\'drag-over\');" ondragleave="this.classList.remove(\'drag-over\');" ondrop="invoiceFileDrop(event,' + value.HeaderID + ')"><label class="invoice-file-picker"><input type="file" id="inv_attach_' + value.HeaderID + '" accept=".pdf,.png,.jpg,.jpeg,.doc,.docx,.xls,.xlsx" onchange="invoiceFileChanged(this)" /><span class="invoice-file-name">Choose or drop a file</span><small>PDF, image, Word, Excel · Max 10 MB</small></label><button type="button" class="invoice-file-remove" hidden onclick="invoiceFileRemove(this)" aria-label="Remove selected file">&times;</button></div></td>';
                    if (blankForNull(value.Utilization) != '' && blankForNull(value.Utilization) != null)
                        inv_html += '<td><input type="text" style="width:100px;" id="inv_utilization_' + value.HeaderID + '" value="' + blankForNull(value.Utilization) + '" /></td>';
                    else
                        inv_html += '<td><input type="text" style="width:100px;" id="inv_utilization_' + value.HeaderID + '" /></td>';
                    inv_html += '<td style="display:none;">' + blankForNull(value.Provider) + '</td>';
                    inv_html += '<td style="display:none;">' + blankForNull(value.Product) + '</td>';
                    /* inv_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.CreditCardNumber) + '</td>';*/

                    inv_html += '<td style="text-wrap:nowrap;"><select id="sel_cardname_' + value.HeaderID + '">';
                    inv_html += invoiceCardOptions(value);
                    inv_html += '</select></td>';

                    inv_html += '<td style="display:none;">' + blankForNull(value.HeaderStatus) + '</td>';
                    inv_html += '<td><button type="button" id="btn_inv_' + value.HeaderID + '" class="invoice-update-btn" onclick="return updaterowdata(' + value.HeaderID + ')"><i class="fas fa-check" aria-hidden="true"></i><span>Update</span></button></td>';
                    inv_html += '<td>' + invoiceAttachmentLink(value, month, year) + '</td>';
                    inv_html += '</tr>';
                });

                if ($.fn.dataTable.isDataTable('#invtable')) {
                    $('#invtable').DataTable().clear().destroy();
                }
                $('#invtable tbody').empty();
                $('#invtable tbody').html(inv_html);

                inv_table = $('#invtable').DataTable({
                    // One table inside a scroll container keeps header/body widths identical.
                    dom: '<"invoice-grid-toolbar"lf><"invoice-grid-scroll"t><"invoice-grid-footer"ip>',
                    scrollX: false,
                    destroy: true,
                    paging: true,
                    pageLength: 25,
                    lengthMenu: [[10, 25, 50, -1], [10, 25, 50, 'All']],
                    autoWidth: false,
                    select: true,
                    ordering: true,
                    order: [],
                    columnDefs: [{ targets: [0, 1, 2, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30], orderable: false }],
                    language: { search: '', searchPlaceholder: 'Search invoices...', lengthMenu: 'Show _MENU_', info: '_START_–_END_ of _TOTAL_ invoices', infoEmpty: 'No invoices', emptyTable: 'No invoices available', zeroRecords: 'No invoices match your search', paginate: { previous: 'Previous', next: 'Next' } },
                    processing: true,
                    'select': {
                        'style': 'single'
                    },

                    initComplete: function () {
                        var disabledCount = dataArray.filter(function (item) { return invoiceHeaderIsDeactivated(item.HeaderStatus); }).length;
                        $('#invtab_active .invoice-tab-count').text(dataArray.length - disabledCount);
                        $('#invtab_deactivated .invoice-tab-count').text(disabledCount);
                        $('<button type="button" class="invoice-search-clear">Clear search</button>').appendTo('#invtable_wrapper .invoice-grid-toolbar').on('click', function () { inv_table.search('').draw(); });
                        $('#load1').hide();
                    },

                    "rowCallback": function (row, data) {
                        // HeaderStatus is the same hidden column used by Enable/Disable.
                        var disabled = invoiceHeaderIsDeactivated(data[28]);
                        $(row).toggleClass('invoice-row-disabled', disabled);
                        $(row).find('input, textarea, select, button')
                            .prop('disabled', disabled)
                            .attr('aria-disabled', disabled ? 'true' : 'false');
                    },
                });

                //$('#fnalize tbody').on('click', 'tr', function () {
                //    row = table.row(this).data();
                //});
                } catch (error) {
                    $('#load1').hide();
                    alert('Unable to display invoices: ' + error.message);
                }
            },

            error: function (error) {
                $('#load1').hide();
                var response = error.responseJSON;
                alert(response && response.Message ? response.Message : 'Unable to load invoices. Please retry.');
            }
        });
    });
    return false;
}


function invoice_ViewDetails(HeaderID, Index, periodContext) {
    var suffix = periodContext === 'rec' ? '_rec' : '';
    var month = $('#inv_month' + suffix).val() || '';
    var year = $('#inv_year' + suffix).val() || '';
    window.location.href = 'UserMapping.aspx?HeaderID=' + encodeURIComponent(HeaderID) + '&Month=' + encodeURIComponent(month) + '&Year=' + encodeURIComponent(year);
    return false;
}

function invoice_UserMappingUrl(HeaderID, month, year) {
    
    return 'UserMapping.aspx?HeaderID=' + encodeURIComponent(HeaderID) + '&amp;Month=' + encodeURIComponent(month || '') + '&amp;Year=' + encodeURIComponent(year || '');
}

function invoice_ViewDetailsLegacy(HeaderID, Index) {
    document.getElementById("invdetails_headerid").innerHTML = HeaderID;
    BindInvDetails(HeaderID);
    $("#inv_detailspop").modal("show");
    return false;
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
    DisableEnableStatus = row[28];

    if (DisableEnableStatus == "Enable") {
        lblName = "Disable : " + row[3] + ' - ' + row[25];
        invdetails_btnEnableDisable.textContent = 'Disable';
    }
    else {
        lblName = "Enable : " + row[3] + ' - ' + row[25];
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
    var ContractualUsage = document.getElementById("invdetails_ContractualUsage").value;

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
    if (ContractualUsage == "") {
        alert("Please enter Contractual Usage.");
        document.getElementById("invdetails_ContractualUsage").focus();
        return false;
    }
    if (ChargeableAmt == "") {
        alert("Please enter Chargeable Amount.");
        document.getElementById("invdetails_NewProdCharAmt").focus();
        return false;
    }

    PageMethods.InsertCCInvoiceHeaders(PopUp_Header, PopUp_Domain, PopUp_Product, PopUp_PayTo, PopUp_PaymentFreq, PopUp_CostType, PopUp_EffDate, ContQuantity, ContPerUnitCost, ChargeableAmt, ContractualUsage, OnSuccess_AddNewProd, OnError_AddNewProd)
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
    var HeaderID = document.getElementById("invdetails_headerid").innerHTML;
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
    var HeaderID = document.getElementById("invdetails_headerid").innerHTML;
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
                invd_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Project) + '</td>';
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
    ID.onchange = getFileName;
    return true;
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
    var lastindex = Math.max(row[0].lastIndexOf('\\'), row[0].lastIndexOf('/'));
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
                inv_html_rec += '<a class="dropdown-item" href="' + invoice_UserMappingUrl(value.HeaderID, month, year) + '" id="ActionsEx"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-file"></i></span>&nbsp;&nbsp;View Details</a>';
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





