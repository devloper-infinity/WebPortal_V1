function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

function preparecheque_bindyear() {
    var start = new Date().getFullYear();

    var select = document.getElementById("preparecheque_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#preparecheque_year").append($("<option></option>").val("0").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#preparecheque_year").append($("<option></option>").val(i).html(i));
    }
}

function preparecheque_show() {
    $('#load1').show();
    var ddlmonth = document.getElementById("preparecheque_month");
    var ddlyear = document.getElementById("preparecheque_year");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    $.ajax({
        url: "PrepareCheques.aspx/getRegularSalary",
        type: "POST",
        dataType: "json",
        data: "{Month:'" + month + "',Year:'" + year + "'}",
        contentType: "application/json; charset=utf-8",
        success: function (data) {


            var dataArray = JSON.parse(data.d);//

            if (dataArray != null) {
                document.getElementById("preparecheque_generate_1").style.display = '';
                document.getElementById("preparecheque_generate_2").style.display = '';
            }
            upr_table = $('#preparecheque_regular_table').DataTable({
                dom: 'Bftip',
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollY: "400px",       // Fixed height
                scrollCollapse: true,   // Remove extra empty space
                scrollX: true,
                "paging": false,
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
                    { data: 'BranchName' },
                    { data: 'DepartmentName' },
                    { data: 'Code' },
                    { data: 'FullName' },
                    { data: 'BankName' },
                    { data: 'BankAccNo' },
                    { data: 'IFSCCode' },
                    { data: 'NetSalary' },
                    { data: 'ChequeNo' },
                    { data: 'AddedDate' }
                ],
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                    $(nRow).children("td").css("text-align", "center");
                },


                initComplete: function () {
                    $('#load1').hide();

                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Regular Salary Report', autoFilter: true,


                    },


                ],
                footerCallback: function (row, data, start, end, display) {

                    var api = this.api();

                    // Remove formatting and convert to number
                    var total = api
                        .column(8) // NetSalary column index
                        .data()
                        .reduce(function (a, b) {
                            return parseFloat(a || 0) + parseFloat(b || 0);
                        }, 0);

                    // Format total (optional)
                    total = total.toFixed(2);

                    // Update footer
                    $(api.column(8).footer()).html(total);
                },
                headerCallback: function (thead, data, start, end, display) {

                    var api = this.api();

                    // Calculate total
                    var total = api.column(8).data().reduce(function (a, b) {

                        // Remove comma if exists
                        var x = parseFloat(a.toString().replace(/,/g, '')) || 0;
                        var y = parseFloat(b.toString().replace(/,/g, '')) || 0;

                        return x + y;

                    }, 0);

                    // Update header text
                    $(api.column(8).header()).html("Net Salary <br />(" + total.toFixed(2) + ")");
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


/// Hold Employees
function preparehold_bindyear() {
    var start = new Date().getFullYear();

    var select = document.getElementById("preparehold_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#preparehold_year").append($("<option></option>").val("0").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#preparehold_year").append($("<option></option>").val(i).html(i));
    }
}

function preparehold_show() {
    $('#load1').show();
    var ddlmonth = document.getElementById("preparehold_month");
    var ddlyear = document.getElementById("preparehold_year");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    $.ajax({
        url: "PrepareCheques.aspx/GetAllHoldEmployees",
        type: "POST",
        dataType: "json",
        data: "{Month:'" + month + "',Year:'" + year + "'}",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            upr_table = $('#preparehold_table').DataTable({
                dom: 'Bftip',
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollY: "400px",       // Fixed height
                scrollCollapse: true,   // Remove extra empty space
                scrollX: true,
                "paging": false,
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
                    {
                        data: null,
                        orderable: false,
                        render: function (data, type, row) {
                            return '<input type="checkbox" class="empCheckbox" value="' + row.Code + '">';
                        }
                    },
                    { data: 'SrNo' },
                    { data: 'Branch' },
                    { data: 'DepartmentName' },
                    { data: 'Code' },
                    { data: 'FullName' },
                    { data: 'BankName' },
                    { data: 'BankAccNo' },
                    { data: 'IFSCCode' },
                    { data: 'NetSalary' },
                    { data: 'HoldRemark' },
                    { data: 'LatestLoginDate' }
                ],
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                },


                initComplete: function () {
                    $('#load1').hide();

                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Regular Salary Report', autoFilter: true,


                    },


                ],


            });
            $('#preparehold_table tbody').on('change', '.empCheckbox', function () {

                if ($('.empCheckbox:checked').length > 0) {
                    $('#preparehold_addchequeno').show();
                } else {
                    $('#preparehold_addchequeno').hide();
                }

            });
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}


/// Other Than Salary
function preparechequeother_bindyear() {
    var start = new Date().getFullYear();

    var select = document.getElementById("preparechequeother_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#preparechequeother_year").append($("<option></option>").val("0").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#preparechequeother_year").append($("<option></option>").val(i).html(i));
    }
}

function preparechequeother_show() {
    $('#load1').show();
    var ddlmonth = document.getElementById("preparechequeother_month");
    var ddlyear = document.getElementById("preparechequeother_year");
    var ddltype = document.getElementById("preparechequeother_type");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    var type = ddltype.options[ddltype.selectedIndex].value;
    $.ajax({
        url: "PrepareCheques.aspx/GetAllOtherThanSalaryEmployees",
        type: "POST",
        dataType: "json",
        data: "{Month:'" + month + "',Year:'" + year + "', Type:'" + type + "'}",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            if (dataArray != null) {
                document.getElementById("preparechequeother_generate_1").style.display = '';
                document.getElementById("preparechequeother_generate_2").style.display = '';
            }
            upr_table = $('#preparecheque_other_table').DataTable({
                dom: 'Bftip',
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollY: "400px",       // Fixed height
                scrollCollapse: true,   // Remove extra empty space
                scrollX: true,
                "paging": false,
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
                    {
                        data: null,
                        orderable: false,
                        render: function (data, type, row) {
                            return '<input type="checkbox" class="empCheckbox" value="' + row.Code + '">';
                        }
                    },
                    { data: 'BranchName' },
                    { data: 'DepartmentName' },
                    { data: 'Code' },
                    { data: 'FullName' },
                    { data: 'BankName' },
                    { data: 'BankAccNo' },
                    { data: 'IFSCCode' },
                    { data: 'Amount' },
                    { data: 'ChequeNo' },
                    { data: 'ReleaseDate' },
                    { data: 'CurrentStatus' }
                ],
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                },


                initComplete: function () {
                    $('#load1').hide();

                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Regular Salary Report', autoFilter: true,


                    },


                ],


            });
            $('#preparecheque_other_table tbody').on('change', '.empCheckbox', function () {

                if ($('.empCheckbox:checked').length > 0) {
                    $('#prepare_other_addchequeno').show();
                } else {
                    $('#prepare_other_addchequeno').hide();
                }

            });
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}

