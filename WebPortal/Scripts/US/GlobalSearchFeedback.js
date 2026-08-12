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
            review: row.Review || "",
            sd: row.StartDatetime || "",
            started: true
        };

        // A Global Search row is created before a task is selected, so zero is valid.
        if (processId > 0) {
            payload.tp = processId;
        }

        return payload;
    }

    function resume(row, returnPage) {
        if (!row || !row.LoanNo || !row.DealNo) {
            alert("Loan details are not available for this loan.");
            return false;
        }

        var encoded = btoa(JSON.stringify(createPayload(row, returnPage)));
        window.location.href = "FeedbackDetails.aspx?data=" + encodeURIComponent(encoded);
        return false;
    }

    global.GlobalSearchFeedback = {
        loadSearch: function () { return us_getloansforglobalsearch(); },
        initializeDetails: function () {
            GetLoggedInUserDetails();
            bindloanDetails_feedback();
        },
        taskChanged: function (ddl) { return getTaskwiseDetails(ddl); },
        submit: function () { return usfeedback_submit(); },
        complete: function () { return usfeedback_completeLoan(); },
        resume: resume
    };
})(window);
