
var secrBillingDealRecs_html;
var secrBillingDealRecs_table;

//------------- Securitization Billing ------------- //

function secrBilling_BindDeals() {

    var select = document.getElementById("secrBilling_DealNo");
    let options = select.getElementsByTagName('secrBilling_DealNo');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#secrBilling_DealNo").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "SecuritizationBilling.aspx/GetAllDealsFromProjectTracking_Billing", dataType: "json", contentType: "application/json",
        success: function (res) {

            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (data, value) {

                $("#secrBilling_DealNo").append($("<option></option>").val(value.ClientDealName).html(value.ClientDealName));
            })
        }
    });
}

function secrBilling_ChnageDealLoans(ddldeal) {

    var deal = ddldeal.options[ddldeal.selectedIndex].value;

    $('#load1').show();

    secrBillingDealRecs_html = '';

    $.ajax({
        url: "SecuritizationBilling.aspx/GetDealDetails",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: "{DealNo:'" + deal + "'}",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            secRBilling_BindDetails();

            $.each(dataArray, function (index, value) {

                if (index == 0) {
                    document.getElementById("secrBilling_NoOfLoans").value = blankForNull(value.LoanCount);
                    document.getElementById("secrBilling_lblProjectId").innerText = blankForNull(value.ProjectId);
                    document.getElementById("secrBilling_lblClientDealName").innerText = blankForNull(value.ClientDealName);
                    document.getElementById("secrBilling_lblProjectName").innerText = blankForNull(value.ProjectName);
                }

                secrBillingDealRecs_html += '<tr>';
                secrBillingDealRecs_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.SrNo) + '</td>';
                secrBillingDealRecs_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ClientName) + '</td>';
                secrBillingDealRecs_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ClientDealName) + '</td>';
                secrBillingDealRecs_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.LoanCount) + '</td>';
                secrBillingDealRecs_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.TaskName) + '</td>';
                secrBillingDealRecs_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.Copies) + '</td>';
                secrBillingDealRecs_html += '<td style="text-wrap: nowrap; text-align:center;" >' + blankForNull(value.RequestedDate) + '</td>';
                secrBillingDealRecs_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.ActualDeliveredDate) + '</td>';
                secrBillingDealRecs_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.BillingHours) + '</td>';
                secrBillingDealRecs_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#table_secrBillingDealRecs')) {
                secrBillingDealRecs_table.destroy();
            }
            $('#table_secrBillingDealRecs tbody').html(secrBillingDealRecs_html);

            secrBillingDealRecs_table = $('#table_secrBillingDealRecs').DataTable({
                dom: 'lti',
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

function btnSecrBilling_SentToAudit1() {

    var ddlBillingType = document.getElementById("secrBilling_BillingType");
    var billingType = ddlBillingType.options[ddlBillingType.selectedIndex].value;

    var ddlDealNo = document.getElementById("secrBilling_DealNo");
    var dealNo = ddlDealNo.options[ddlDealNo.selectedIndex].value;

    var NoOFLoans = document.getElementById("secrBilling_NoOfLoans").value;
    var ProjectId = document.getElementById("secrBilling_lblProjectId").innerText;
    var ClientDealName = document.getElementById("secrBilling_lblClientDealName").innerText;
    var ProjectName = document.getElementById("secrBilling_lblProjectName").innerText
    var Remark = document.getElementById("secrBilling_Remark").value;
    var AssociatedHourd = document.getElementById("secrBilling_AssociatedHourd").value;

    if (billingType == "") {
        alert("Please select Billing Type.");
        document.getElementById("secrBilling_BillingType").focus();
        return false;
    }

    if (dealNo == "") {
        alert("Please select Task Name.");
        document.getElementById("secrBilling_DealNo").focus();
        return false;
    }

    PageMethods.InsertSecuritizationRelianceLetter_Billing(billingType, dealNo, ProjectId, ClientDealName, ProjectName, NoOFLoans, AssociatedHourd, Remark, secrBilling_OnSuccess, secrBilling_OnError);
    //InsertSecuritizationRelianceLetter(BillingType, DealNo, ProjectID, ClientDealName, ProjectName, LoanCount, AssociateHours, Remark)
    return false;
}

function secrBilling_OnSuccess(result) {

    if (result > 0) {

        document.getElementById("secrBilling_errmsg").innerHTML = "Data sent to audit successfully!";
        document.getElementById("secrBilling_errmsg").style.color = 'green';
        $('#secrBilling_dverror').modal('show');
        return false;
    }
    else {
        document.getElementById("secrBilling_errmsg").innerHTML = "Error in sending data to audit.";
        document.getElementById("secrBilling_errmsg").style.color = 'red';
        $('#secrBilling_dverror').modal('show');
        return false;
    }
    return false;
}

function secrBilling_OnError(error) {
    alert(error.responseText);
}

function secRBilling_BindDetails() {

    $.ajax({
        url: "SecuritizationBilling.aspx/GetSummaryDetails",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            $.each(dataArray, function (index, value) {

                document.getElementById("secrBilling_NoOfLoans").value = blankForNull(value.LoanCount);
                document.getElementById("secrBilling_lblProjectId").innerText = blankForNull(value.ProjectId);
                document.getElementById("secrBilling_lblClientDealName").innerText = blankForNull(value.ClientDealName);
                document.getElementById("secrBilling_lblProjectName").innerText = blankForNull(value.ProjectName);
            });
        },
    });

    return false;

}


//------------- Securitization Billing Sent------------- //

var secrBillingSent_table;


function secrBillingSent_BindGrid() {

    $('#load1').show();

    $.ajax({
        url: "SecuritizationBillingSent.aspx/GetAllSentBilling",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);

            secrBillingSent_table = $('#table_secrBillingSent').DataTable({
                dom: 'Bftip',
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
                columns: [
                    { data: 'SrNo' },
                    { data: 'BillingType' },
                    { data: 'ProjectName' },
                    { data: 'DealNo' },
                    { data: 'BillingPeriod' },
                    { data: 'Description' },
                    { data: 'NoOfHoursLoans' },
                    { data: 'BillingAddedDate' },
                    { data: 'AssociateRemark' }
                ],
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                },
                initComplete: function () {
                    $('#load1').hide();
                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Securitization-Reliance Letter Billing', autoFilter: true,
                    },
                ],
            });
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}

