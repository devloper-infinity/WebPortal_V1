// =======================
// GLOBAL VARIABLES
// =======================
let currentMainTab = "nondd";
let currentSubTab = "summary";
let isDataLoaded = false;


// =======================
// PAGE LOAD
// =======================
$(document).ready(function() {




    /*  $.ajax({
          type: "POST",
          url: "UserPerformanceHrReport.aspx/GetHRUserData",
          data: JSON.stringify({
              type: "nondd",
              tab: "summary",
              FromDate: "2026-01-26",
              EndDate: "2026-02-25"
          }),
          contentType: "application/json; charset=utf-8",
  
          success: function(res) {
  
              let data = JSON.parse(res.d);
  
              console.log("FINAL DATA:", data);
  
              $("#testTable").DataTable({
                  data: data,
                  columns: [
                      { data: "Month" },
                      { data: "Year" }
                  ]
              });
          }
      });
      */

    console.log("JS Loaded");

  //  loadTabContent();

    // MAIN TAB CLICK
    $(document).on("click", ".mainTab", function() {

        $(".mainTab").removeClass("active");
        $(this).addClass("active");

        currentMainTab = $(this).data("type");

        loadTabContent();
    });

    // SUB TAB CLICK
    $(document).on("click", ".subTab", function() {

        $(".subTab").removeClass("active");
        $(this).addClass("active");

        currentSubTab = $(this).data("tab");

        loadTabContent();
    });

});


// LOAD TEMPLATE
function loadTabContent() {

    let templateId = `#${currentMainTab}_${currentSubTab}_template`;

    console.log("Loading Template:", templateId);

    let html = $(templateId).html();

    $("#tabContentArea").html(html);

    console.log("HTML AFTER LOAD:", $("#tabContentArea").html());

}


// SHOW BUTTON CLICK
function core_handleShowClick() {

    console.log("SHOW CLICKED");

    let fromDate = $("#hrUser_fromDate").val();
    let toDate = $("#hrUser_toDate").val();

    
    fromDate = '2026-01-26';
    toDate = '2026-02-25';

    if (!fromDate || !toDate) {
        alert("Select dates");
        return;
    }

    isDataLoaded = true;
    loadData();
}

function handleShowClick() {

    console.log("SHOW CLICKED");

    let tableId = getTableId();

    console.log("Checking table:", tableId);

    if ($(tableId).length === 0) {
        console.error("❌ Table not found EVEN AFTER TEMPLATE LOAD");
        return;
    }

    loadData();
}

// GET TABLE ID
function getTableId() {

    if (currentMainTab === "nondd" && currentSubTab === "summary") return "#table_nondd_Summary";
    if (currentMainTab === "nondd" && currentSubTab === "production") return "#table_nondd_prod";
    if (currentMainTab === "nondd" && currentSubTab === "feedback") return "#table_nondd_feedback";
    if (currentMainTab === "nondd" && currentSubTab === "attendance") return "#table_nondd_attn";

    if (currentMainTab === "credit" && currentSubTab === "summary") return "#table_cred_Summary";
    if (currentMainTab === "credit" && currentSubTab === "production") return "#table_cred_prod";
    if (currentMainTab === "credit" && currentSubTab === "feedback") return "#table_cred_feedback";
    if (currentMainTab === "credit" && currentSubTab === "attendance") return "#table_cred_attn";

    if (currentMainTab === "servicing" && currentSubTab === "summary") return "#table_serv_Summary";
    if (currentMainTab === "servicing" && currentSubTab === "production") return "#table_serv_prod";
    if (currentMainTab === "servicing" && currentSubTab === "feedback") return "#table_serv_feedback";
    if (currentMainTab === "servicing" && currentSubTab === "attendance") return "#table_serv_attn";
}



// LOAD DATA (AJAX)
function loadData() {

    let fromDate = $("#hrUser_fromDate").val();
    let toDate = $("#hrUser_toDate").val();

    fromDate = '2026-01-26';
    toDate = '2026-02-25';

    let tableId = getTableId();

    console.log("Loading Data for:", tableId);

    $("#loader").show();

    $.ajax({
        type: "POST",
        url: "UserPerformanceHrReport.aspx/GetHRUserData",
        data: JSON.stringify({
            type: currentMainTab,
            tab: currentSubTab,
            FromDate: $("#hrUser_fromDate").val(),
            EndDate: $("#hrUser_toDate").val()
        }),
        contentType: "application/json; charset=utf-8",

        success: function(res) {
            console.log("AJAX SUCCESS");
            console.log("RAW RESPONSE:", res);

            let dataArray = [];

            try {
                dataArray = (typeof res.d === "string") ? JSON.parse(res.d) : res.d;
            } catch (e) {
                console.error("JSON ERROR:", e);
            }

            console.log("PARSED DATA:", dataArray);

            let tableId = getTableId();
            console.log("TABLE ID:", tableId);

            initializeDataTable(tableId, dataArray);
        },

        error: function(err) {
            console.error("AJAX ERROR:", err);
            alert("AJAX FAILED - check console");
        }
    });

    /*   $.ajax({
           type: "POST",
           url: "UserPerformanceHrReport.aspx/GetHRUserData",
           data: JSON.stringify({
               type: currentMainTab,
               tab: currentSubTab,
               FromDate: fromDate,
               EndDate: toDate
           }),
           contentType: "application/json; charset=utf-8",
   
           success: function(res) {
   
               let dataArray = [];
   
               try {
                   dataArray = (typeof res.d === "string") ? JSON.parse(res.d) : res.d;
               } catch (e) {
                   console.error("JSON Parse Error:", e);
               }
   
               console.log("Data Received:", dataArray);
   
               initializeDataTable(tableId, dataArray);
           },
   
           error: function(err) {
               console.error("AJAX Error:", err);
           },
   
           complete: function() {
               $("#loader").hide();
           }
       }); */
}




// INITIALIZE DATATABLE
function initializeDataTable(tableId, dataArray) {

    console.log("TABLE:", tableId);
    console.log("DATA SAMPLE:", dataArray[0]);

    if (!tableId || $(tableId).length === 0) {
        console.error("Table not found:", tableId);
        return;
    }

    if (!dataArray || dataArray.length === 0) {
        $(tableId + " tbody").html("<tr><td colspan='10'>No Data</td></tr>");
        return;
    }

    let isDynamic = (currentSubTab === "production" || currentSubTab === "feedback");

    // destroy old
    if ($.fn.DataTable.isDataTable(tableId)) {
        $(tableId).DataTable().clear().destroy();

        // ❗ ONLY for dynamic
        if (isDynamic) {
            $(tableId).empty();
        }
    }

    // =====================
    // 🔹 DYNAMIC TABLE
    // =====================
    if (isDynamic) {

        let columns = Object.keys(dataArray[0]).map(key => ({
            data: key,
            title: key
        }));

        $(tableId).DataTable({
            data: dataArray,
            columns: columns,
            scrollX: true,
            destroy: true
        });

    }

    // =====================
    // 🔹 FIXED TABLE
    // =====================
    else {

        // ⚠️ MATCH THESE WITH YOUR API (check console log)
        let columns = [];

        if (currentSubTab === "summary") {
            columns = [
                { data: "Month" },
                { data: "Year" },
                { data: "Code" },
                { data: "EmployeeName" },
                { data: "Employee" },
                { data: "LoanCount" },
                { data: "ProdPerc" },
                { data: "QualityPerc" },
                { data: "AttPerc" },
                { data: "ProdGrade" },
                { data: "QualGrade" },
                { data: "AttnGrade" }
            ];
        }

        if (currentSubTab === "attendance") {
            columns = [
                { data: "Code" },
                { data: "TotalCalenderDays" },
                { data: "AbsentDays" },
                { data: "PartialCount" },
                { data: "PartialDays" },
                { data: "TotalAbsentDays" },
                { data: "SalaryPresentDays" },
                { data: "AttendancePercOnTotalDays" },
                { data: "Latemarks" },
                { data: "RemovedLatemarks" },
                { data: "TotalLatemarks" }
            ];
        }

        $(tableId).DataTable({
            data: dataArray,
            columns: columns, // 🔥 REQUIRED
            scrollX: true,
            destroy: true
        });
    }
}

// =======================
// EXPORT CURRENT TABLE
// =======================
function exportTableToExcel() {

    let tableId = getTableId();

    if ($.fn.DataTable.isDataTable(tableId)) {
        $(tableId).DataTable().button('.buttons-excel').trigger();
    }
}


// =======================
// EXPORT ALL (SERVER)
// =======================
function exportAllToExcel() {

    let fromDate = $("#hrUser_fromDate").val();
    let toDate = $("#hrUser_toDate").val();
     
    
    fromDate = '2026-01-26';
    toDate = '2026-02-25';

    if (!fromDate || !toDate) {
        alert("Select date range");
        return;
    }

    window.location.href = `ExportExcel.aspx?from=${fromDate}&to=${toDate}`;
} 


function getFixedColumns() {

    alert('e');

    // SUMMARY
    if (currentSubTab === "summary") {
        return [
            { data: 'Month' },
            { data: 'Year' },
            { data: 'Code' },
            { data: 'EmployeeName' },
            { data: 'Employee' },
            { data: 'LoanCount' },
            { data: 'ProdPerc' },
            { data: 'QualityPerc' },
            { data: 'AttPerc' },
            { data: 'ProdGrade' },
            { data: 'QualGrade' },
            { data: 'AttnGrade' }
        ];
    }

    // ATTENDANCE
    if (currentSubTab === "attendance") {
        return [
            { data: 'Code' },
            { data: 'TotalCalenderDays' },
            { data: 'AbsentDays' },
            { data: 'PartialCount' },
            { data: 'PartialDays' },
            { data: 'TotalAbsentDays' },
            { data: 'SalaryPresentDays' },
            { data: 'AttendancePercOnTotalDays' },
            { data: 'Latemarks' },
            { data: 'RemovedLatemarks' },
            { data: 'TotalLatemarks' }
        ];
    }

    return [];
} 