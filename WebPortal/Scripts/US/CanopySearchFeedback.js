(function (global) {
    "use strict";

    function createPayload(row, returnPage) {
        var processId = parseInt(row.ProcessID, 10) || 0;
        var payload = {
            ln: row.LoanNo || "",
            dn: row.DealNo || "",
            src: returnPage,
            client: row.Client || "",
            od: row.OrderDate || "",
            process: row.Process || "",
            script: row.Script || "",
            review: row.Review || "",
            sd: row.StartDatetime || "",
            started: true
        };

        // A Canopy row may also be resumed before a task is selected.
        if (processId > 0) {
            payload.tp = processId;
        }

        return payload;
    }

    function resume(row, returnPage) {
        if (!row || !row.LoanNo || !row.DealNo) {
            alert("Canopy loan details are not available for this loan.");
            return false;
        }

        var encoded = btoa(JSON.stringify(createPayload(row, returnPage)));
        window.location.href = "FeedbackCanopyDetails.aspx?data=" + encodeURIComponent(encoded);
        return false;
    }

    global.CanopySearchFeedback = {
        loadSearch: function () { return us_getloansforglobalsearchCanopy(); },
        initializeDetails: function () {
            canopyfeedback_getLoggedInUserDetails();
            canopyfeedback_bindLoanDetails();
        },
        taskChanged: function (ddl) { return canopyfeedback_getTaskwiseDetails(ddl); },
        submit: function () { return canopyfeedback_submit(); },
        complete: function () { return canopyfeedback_completeLoan(); },
        resume: resume
    };
})(window);
