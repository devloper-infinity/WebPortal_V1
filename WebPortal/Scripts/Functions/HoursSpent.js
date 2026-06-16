
var fromdate;
var todate;

function hoursSpent_show() {

    fromdate = document.getElementById("hoursSpent_from").value;
    todate = document.getElementById("hoursSpent_to").value;

    if (fromdate == "") {
        alert("Please select From Date.");
        return false;
    }
    if (todate == "") {
        alert("Please select To Date.");
        return false;
    }

    if (fromdate != "" && todate != "") {

        bindProjectWiseData(fromdate, todate);
    }
}

function bindProjectWiseData(fromdate, todate) {

    $('#load1').show();

    var columns = [];

    $.ajax({
        url: "HoursSpent.aspx/GetProjectWiseData",
        type: "POST",
        dataType: "json",
        data: "{FromDate:'" + fromdate + "',ToDate:'" + todate + "'}",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            if (dataArray != null && dataArray != '') {

                $.each(dataArray[0], function (key, value) {
                    var my_item = {};
                    my_item.data = key;
                    my_item.title = key;
                    columns.push(my_item);
                });

                $('#hoursSpent_project').DataTable({
                    dom: 't',
                    //scrollX: true,
                    destroy: true,
                    "paging": false,
                    "autoWidth": false,
                    select: true,
                    "ordering": false,
                    processing: true,
                    'select': {
                        'style': 'single'
                    },
                    "data": dataArray,
                    "columns": columns,

                    autoWidth: false,

                    fnCreatedRow: function (nRow, aData, iDataIndex) {
                        $(nRow).children("td").css("text-wrap", "nowrap");
                    },

                    headerCallback1: function (thead) {
                        $(thead).find('th').css({
                            'white-space': 'nowrap',
                            'padding': '8px 40px',
                            'vertical-align': 'middle',
                        });
                    },

                    initComplete: function () {

                        $("#load1").hide();
                        // bindprjprc();
                    },
                });
            }
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
}

function bindprjprc() {

    $('#load1').show();

    var columns = [];

    $.ajax({
        url: "HoursSpent.aspx/GetProjectProcessWiseData",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = JSON.parse(data.d);

            if (dataArray != null && dataArray != '') {

                $.each(dataArray[0], function (key, value) {
                    var my_item = {};
                    my_item.data = key;
                    my_item.title = key;
                    columns.push(my_item);
                });

                $('#hoursSpenttable_prjprc').DataTable({
                    dom: 'lftp',
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
                    "data": dataArray,
                    "columns": columns,

                    fnCreatedRow: function (nRow, aData, iDataIndex) {
                        $(nRow).children("td").css("text-wrap", "nowrap");
                    },

                    headerCallback2: function (thead) {
                        $(thead).find('th').css({
                            'white-space': 'nowrap',
                            'padding': '8px 40px',
                            'text-align': 'left',
                        });
                    },

                    initComplete: function () {
                        $("#load1").hide();
                    },
                });
            }
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
}

function binduserwise() {

    $("#load1").show();

    var columns = [];

    $.ajax({
        url: "HoursSpent.aspx/GetProjectProcessUserWiseData",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            if (dataArray != null && dataArray != '') {
                $.each(dataArray[0], function (key, value) {
                    var my_item = {};
                    my_item.data = key;
                    my_item.title = key;
                    columns.push(my_item);
                });

                $('#hoursSpenttable_prjprcuser').DataTable({
                    dom: 'lftp',
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
                    "data": dataArray,
                    "columns": columns,


                    fnCreatedRow: function (nRow, aData, iDataIndex) {
                        $(nRow).children("td").css("text-wrap", "nowrap");
                    },

                    headerCallback3: function (thead) {
                        $(thead).find('th').css({
                            'white-space': 'nowrap',
                           /* 'padding': '8px 40px',*/
                            'text-align': 'left',
                        });
                    },

                    initComplete: function () {
                        $("#load1").hide();
                        //  bindprodData();
                    },
                });
            }
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
}

function bindprodData() {

    $('#load1').show();

    var columns = [];

    // DESTROY if already exists (very important)
    if ($.fn.DataTable.isDataTable('#hoursSpenttable_proddata')) {
        $('#hoursSpenttable_proddata').DataTable().clear().destroy();
        $('#hoursSpenttable_proddata').empty(); // removes old thead/tbody height
    }

    $.ajax({
        url: "HoursSpent.aspx/GetPrductionData",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = JSON.parse(data.d);

            if (dataArray && dataArray.length > 0) {

                $.each(dataArray[0], function (key) {
                    columns.push({
                        data: key,
                        title: key
                    });
                });

                var table = $('#hoursSpenttable_proddata').DataTable({
                    dom: 'lftp',
                    paging: true,
                    ordering: false,
                    processing: true,
                    autoWidth: false,          // 🔴 MUST be false in tabs
                    scrollX: false,
                    select: { style: 'single' },
                    data: dataArray,
                    columns: columns,

                    initComplete: function () {
                        // Force recalculation AFTER tab is visible
                        setTimeout(function () {
                            table.columns.adjust().draw(false);
                        }, 50);

                        $('#load1').hide();
                    },

                    createdRow: function (row) {
                        $(row).find('td').css('white-space', 'nowrap');
                    },

                    headerCallback: function (thead) {   // 🔥 fixed
                        $(thead).find('th').css({
                            'white-space': 'nowrap',
                            'padding': '10px 20px',
                            'text-align': 'left'
                        });
                    }
                });
            }
        },

        error: function (error) {
            $('#load1').hide();
            alert('Error: ' + error.responseText);
        }
    });
}

function bindprodData_Core() {

    $('#load1').show();

    var columns = [];

    $.ajax({
        url: "HoursSpent.aspx/GetPrductionData",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            if (dataArray != null && dataArray != '') {

                $.each(dataArray[0], function (key, value) {
                    var my_item = {};
                    my_item.data = key;
                    my_item.title = key;
                    columns.push(my_item);
                });

                $('#hoursSpenttable_proddata').DataTable({
                    dom: 'lftp',
                    scrollX: false,
                    destroy: true,
                    "paging": true,
                    "autoWidth": true,
                    select: true,
                    "ordering": false,
                    processing: true,
                    'select': {
                        'style': 'single'
                    },
                    "data": dataArray,
                    "columns": columns,

                    initComplete: function () {

                        $("#load1").hide();
                    },

                    fnCreatedRow: function (nRow, aData, iDataIndex) {
                        $(nRow).children("td").css("text-wrap", "nowrap");
                    },

                    headerCallback4: function (thead) {
                        $(thead).find('th').css({
                            'white-space': 'nowrap',
                            'padding': '10px 20px',   // top/bottom | left/right
                            'text-align': 'left'
                        });
                    },
                });
            }
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
}


