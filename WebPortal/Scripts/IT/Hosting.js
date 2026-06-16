var global_hostID = 0;
var hostingMaster_table;

function BindHostingMaster_Grid() {

    $('#load1').show();

    $.ajax({
        url: 'HostingMaster.aspx/GetAllHostingDetails',
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = JSON.parse(data.d);

            if ($.fn.DataTable.isDataTable('#table_hostingMaster')) {
                $('#table_hostingMaster').DataTable().clear().destroy();
            }

            table = $('#table_hostingMaster').DataTable({
                dom: 'lBftp',
                data: dataArray,
                scrollX: true,
                paging: true,
                autoWidth: true,
                processing: true,
                ordering: false,
                serverSide: false,

                columns: [
                    {
                        data: null,
                        className: 'text-center',
                        orderable: false,
                        render: function (data, type, row, meta) {
                            return '<a class="dropdown-item" href="#!" ' + 'data-bs-toggle="tooltip" data-bs-placement="top" title="Edit Hosting" ' + 'onclick="Edit_hosting(' + row.HostID + ',' + meta.row + ');">' + '<span style="color: forestgreen;">' + '<i class="uil-edit-alt"></i>' + '</span></a>';
                        }
                    },
                    { data: 'SrNo', className: 'text-center' },
                    { data: 'HostingType' },
                    { data: 'DomainName' },
                    { data: 'Provider' },
                    { data: 'RenewedDate' },
                    { data: 'ExpiryDate' },
                    { data: 'RenewelPeriod' },
                    { data: 'CostPaid' },
                    { data: 'NextRenewalCost' },
                    { data: 'CreditCardNo' },
                    { data: 'AveragePerYear' },
                    { data: 'EmailID' },
                    { data: 'CPanelLink' },
                    { data: 'WebLink' },
                    { data: 'Remark' }
                ],

                initComplete: function () {
                    hostingMaster_table = $('#table_hostingMaster').DataTable();
                    $('#load1').hide();
                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: "Hosting Master",
                    },
                ],
            });
        },

        error: function (error) {
            alert('Error: ' + error.responseText);
        }
    });

    return false;
}

function host_submit() {

    var ddlType = document.getElementById("host_type");
    var host_type = ddlType.options[ddlType.selectedIndex].value;

    var host_domainname = document.getElementById("host_domainname").value;
    var host_provider = document.getElementById("host_provider").value;

    var host_renewdate = document.getElementById("host_renewdate").value;
    var host_advrendate = document.getElementById("host_advrendate").value;
    var host_expdate = document.getElementById("host_expdate").value;

    var ddlRenew = document.getElementById("host_renewperiod");
    var host_renewperiod = ddlRenew.options[ddlRenew.selectedIndex].value;

    var host_costpaid = document.getElementById("host_costpaid").value;
    var host_nextrenewalcost = document.getElementById("host_nextrenewalcost").value;

    var host_avgyear = document.getElementById("host_avgyear").value;
    var host_email = document.getElementById("host_email").value;
    var host_creditcard = document.getElementById("host_creditcard").value;

    var host_cplink = document.getElementById("host_cplink").value;

    var host_weblink = document.getElementById("host_weblink").value;
    var host_remark = document.getElementById("host_remark").value;

    if (!isValidEmail(host_email)) {
        alert("Please enter a valid Email ID.");
        document.getElementById("host_email").focus();
        return false;
    }

    if (host_type === "Select") {
        alert("Please select Type.");
        document.getElementById("host_type").focus();
        return false;
    }

    if (host_domainname.trim() === "") {
        alert("Please enter Domain Name.");
        document.getElementById("host_domainname").focus();
        return false;
    }

    if (host_provider.trim() === "") {
        alert("Please enter Provider.");
        document.getElementById("host_provider").focus();
        return false;
    }

    if (host_renewdate.trim() === "") {
        alert("Please enter Renewed Date.");
        document.getElementById("host_renewdate").focus();
        return false;
    }

    if (host_advrendate.trim() === "") {
        alert("Please enter Advance Renewal Date.");
        document.getElementById("host_advrendate").focus();
        return false;
    }

    if (host_expdate.trim() === "") {
        alert("Please enter Expiry Date.");
        document.getElementById("host_expdate").focus();
        return false;
    }

    if (host_renewperiod === "Select") {
        alert("Please select Renewed Period.");
        document.getElementById("host_renewperiod").focus();
        return false;
    }

    if (host_costpaid === "" || Number(host_costpaid) <= 0) {
        alert("Please enter Cost Paid.");
        document.getElementById("host_costpaid").focus();
        return false;
    }

    if (host_nextrenewalcost === "" || Number(host_nextrenewalcost) <= 0) {
        alert("Please enter Next Renewal Cost.");
        document.getElementById("host_nextrenewalcost").focus();
        return false;
    }

    if (host_avgyear === "" || Number(host_avgyear) <= 0) {
        alert("Please enter Average / Year.");
        document.getElementById("host_avgyear").focus();
        return false;
    }

    if (host_email.trim() === "") {
        alert("Please enter Registered Email Address.");
        document.getElementById("host_email").focus();
        return false;
    }

    if (host_creditcard.trim() === "") {
        alert("Please enter Credit Card number.");
        document.getElementById("host_creditcard").focus();
        return false;
    }

    if (host_cplink.trim() === "") {
        alert("Please enter C Panel Link.");
        document.getElementById("host_cplink").focus();
        return false;
    }

    if (host_weblink.trim() === "") {
        alert("Please enter Web Link.");
        document.getElementById("host_weblink").focus();
        return false;
    }

    if (host_remark.trim() === "") {
        alert("Please enter Remark.");
        document.getElementById("host_remark").focus();
        return false;
    }

    PageMethods.InsertAssets(host_type, host_domainname, host_provider, host_renewdate, host_advrendate, host_expdate, host_renewperiod, host_costpaid, host_nextrenewalcost, host_avgyear, host_email, host_creditcard, host_cplink, host_weblink, host_remark, host_OnSuccess, host_OnError)
    return false;
}

function host_OnSuccess(result) {

    var success_msg = '';
    var err_msg = '';

    if (global_hostID == 0) {
        success_msg = "Hosting saved successfully";
        err_msg = "Oops! Error occured while submitting hosting data. Please contact administrator!";
    }
    else if (global_hostID > 0) {
        $('#host_btnreset').hide();
        global_hostID = 0;
        success_msg = "Hosting updated successfully";
        err_msg = "Oops! Error occured while updating data. Please contact administrator!"
    }

    if (result > 0) {

        document.getElementById("host_errmsg").innerHTML = success_msg;
        $('#host_dverror').modal('show');
        clear_HostFields();
        Bindhost_Grid();
        document.getElementById("host_type").disabled = false;
        document.getElementById("host_domainname").disabled = false;
        return false;
    }
    else {
        document.getElementById("host_errmsg").innerHTML = err_msg;
        document.getElementById("host_errmsg").style.color = 'red';
        $('#host_dverror').modal('show');
        return false;
    }
}

function host_OnError(error) {
    alert(error.responseText);
}

function isValidEmail(email) {
    var regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return regex.test(email);
}

function Edit_hosting(hostId, index) {

    $('#host_btnsubmit').text('Update');

    global_hostID = hostId;

    var table = $('#table_hostingMaster').DataTable();

    hostingMaster_table.$('tr').removeClass('selected-row');

    var rowData = table.row(index).data();
    var rowNode = hostingMaster_table.row(index).node();

    $(rowNode).addClass('selected-row');
    $('#host_btnreset').show();

    document.getElementById("host_type").focus();
    document.getElementById("host_type").disabled = true;
    document.getElementById("host_domainname").disabled = true;
    $("#host_type").val(rowData.HostingType);
    document.getElementById("host_domainname").value = rowData.DomainName;
    document.getElementById("host_provider").value = rowData.Provider;
    document.getElementById("host_renewdate").value = formatdate(rowData.RenewedDate);
    document.getElementById("host_advrendate").value = formatdate(rowData.AdvanceRenewalDate);
    document.getElementById("host_expdate").value = formatdate(rowData.ExpiryDate);
    $("#host_renewperiod").val(rowData.RenewelPeriod);
    document.getElementById("host_costpaid").value = rowData.CostPaid;
    document.getElementById("host_nextrenewalcost").value = rowData.NextRenewalCost;
    document.getElementById("host_avgyear").value = rowData.AveragePerYear;
    document.getElementById("host_email").value = rowData.EmailID;
    document.getElementById("host_creditcard").value = rowData.CreditCardNo;
    document.getElementById("host_cplink").value = rowData.CPanelLink;
    document.getElementById("host_weblink").value = rowData.WebLink;
    document.getElementById("host_remark").value = rowData.Remark;
}

function host_reset() {

    hostingMaster_table.$('tr').removeClass('selected-row');
    document.getElementById("host_type").disabled = false;
    document.getElementById("host_domainname").disabled = false;
    document.getElementById('host_btnsubmit').innerText = 'Submit';
    document.getElementById('host_type').focus();
    $('#host_btnreset').hide();
    clear_HostFields();
}

function formatdate(prv_date) {

    var date = new Date(prv_date);
    var day = date.getDate();
    if (day < 10)
        day = '0' + day
    var month = date.getMonth() + 1;
    if (month < 10)
        month = '0' + month
    var year = date.getFullYear();
    var actualdate = year + "-" + (month) + "-" + (day);

    return actualdate;
}

function clear_HostFields() {

    document.getElementById("host_type").selectedIndex = 0;
    document.getElementById("host_domainname").value = "";
    document.getElementById("host_provider").value = "";
    document.getElementById("host_renewdate").value = "";
    document.getElementById("host_advrendate").value = "";
    document.getElementById("host_expdate").value = "";
    document.getElementById("host_renewperiod").selectedIndex = 0;
    document.getElementById("host_costpaid").value = "";
    document.getElementById("host_nextrenewalcost").value = "";
    document.getElementById("host_avgyear").value = "";
    document.getElementById("host_email").value = "";
    document.getElementById("host_creditcard").value = "";
    document.getElementById("host_cplink").value = "";
    document.getElementById("host_weblink").value = "";
    document.getElementById("host_remark").value = "";
}
