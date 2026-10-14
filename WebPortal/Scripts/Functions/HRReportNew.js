// HRReportNew uses a local copy of the year binder so it stays independent of HRReports.js.
function hr_BindYear() {
    var start = new Date().getFullYear();
    var select = document.getElementById("hr_year");
    if (!select) return;

    while (select.options.length > 0) {
        select.remove(0);
    }

    var placeholder = document.createElement("option");
    placeholder.value = "";
    placeholder.text = "Select Year";
    select.add(placeholder);

    for (var year = start; year > start - 5; year--) {
        var option = document.createElement("option");
        option.value = year;
        option.text = year;
        select.add(option);
    }
}
