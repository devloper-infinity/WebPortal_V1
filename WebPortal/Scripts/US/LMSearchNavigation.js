(function (global) {
    "use strict";

    function resume(row, returnPage) {
        if (!row || !row.LoanRecordID || !row.LoanNo) {
            alert("LauraMac loan details are not available.");
            return false;
        }
        var payload = {
            recordID: row.LoanRecordID,
            loanID: row.LoanNo,
            client: row.Client || "",
            process: row.Process || "",
            script: row.Script || "",
            orderDate: row.OrderDate || "",
            trackID: row.ProductionTrackID || 0,
            started: true,
            src: returnPage || "LMSearch"
        };
        window.location.href = "LMSearchDetails.aspx?data=" + encodeURIComponent(btoa(JSON.stringify(payload)));
        return false;
    }

    global.LMSearchNavigation = { resume: resume };
}(window));
