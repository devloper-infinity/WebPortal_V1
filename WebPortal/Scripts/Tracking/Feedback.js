function bind_LoanDetails(id) {

    $('#load1').show();

    $.ajax({
        type: "POST",
        url: "AddFeedback.aspx/GetLoanDetailsByProcessID",
        data: JSON.stringify({ ProcessID: id }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        success: function (response) {

            $('#load1').hide();

            var data = response.d;

            // If response.d is a JSON string, parse it
            if (typeof data === "string") {
                data = JSON.parse(data);
            }

            // If an array is returned, take the first record
            if ($.isArray(data) && data.length > 0) {
                data = data[0];
            }

            if (!data) {
                Swal.fire("No Record", "Loan details not found.", "warning");
                return;
            }

            var data = JSON.parse(response.d);

            if (data.length > 0) {

                $("#af_ctxProject").text(data[0].ProjectNo || "-");
                $("#af_ctxDeal").text(data[0].DealNo || "-");
                $("#af_ctxLoan").text(data[0].OrderNumber || "-");
                $("#af_ctxProcess").text(data[0].Process || "-");
                $("#af_ctxOrderDate").text(data[0].AddedDate || "-");

                $("#af_statusProject").text(data[0].ProjectNo || "-");
                $("#af_statusDeal").text(data[0].DealNo || "-");
                $("#af_statusLoan").text(data[0].OrderNumber || "-");
                $("#af_statusProcess").text(data[0].Process || "-");
                $("#af_statusOrderDate").text(data[0].AddedDate || "-");
            }
        },

        error: function (xhr) {

            $('#load1').hide();

            console.error(xhr.responseText);

            Swal.fire(
                "Error",
                "Unable to fetch loan details.",
                "error"
            );
        }
    });
}

function af_completeOrder() {
    // var processID = $("#af_processID").val();
    // var status = $("#af_status").val();

    // $("#af_status").focus();

    // if (!status) {
    //     Swal.fire({
    //         icon: "warning",
    //         title: "Status Required",
    //         text: "Please select the status.",
    //         confirmButtonText: "OK"
    //     }).then(function () {
    //         $("#af_status").focus();
    //     });

    //     return false;
    // }

    $("#popUp_updateOrderStatus").find("select, input, textarea, button").filter(":visible:not(:disabled)").first().focus();

    console.log("Process ID:", processID);
    console.log("Status:", status);

    // Continue AJAX/PageMethod call here
}

function af_btnSave() {


    $.ajax({
        type: "POST",
        url: "Allocate.aspx/AllocateOrders_Self",
        data: JSON.stringify({
            Loans: commaSeparatedSrNo
        }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        success: function (response) {

            $('#load1').hide();

            Swal.fire({
                icon: 'success',
                title: 'Success',
                text: 'Selected loan(s) allocated successfully.',
                confirmButtonText: 'OK'
            }).then(function () {
                GetLoansToAllocate_bindGrid();
            });

            $("#sectrack_stat_deals").text(selectedSrNo.length);
        },

        error: function (xhr) {

            $('#load1').hide();

            console.error(xhr.responseText);

            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'Error while allocating selected loan(s).',
                confirmButtonText: 'OK'
            });
        }
    });
    return false;
}

function toggleHoldReason() {
    var isHold = $('#af_status').val() === 'Hold';
    $('#af_holdReason').prop('disabled', !isHold);

    if (!isHold) {
        $('#af_holdReason').val('');
    }
}