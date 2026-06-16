var incstep1_table;

const inc_chkIds = [];

function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

function GetCheckedCheckboxes_incstep1(ID) {
    if (ID.checked) {
        if (!inc_chkIds.includes(ID.id)) {
            inc_chkIds.push(ID.id);
        }
    }
    else {
        if (inc_chkIds.includes(ID.id)) {
            inc_chkIds.splice(inc_chkIds.indexOf(ID.id), 1);
        }
    }

    return false;
}

function incstep1_proceedtonextstep() {
    if (inc_chkIds.length > 0) {
        var codes = "";
        for (let i = 0; i < inc_chkIds.length; i++) {
            if (i == 0) {
                codes = inc_chkIds[i];
            }
            else {
                codes = codes + "," + inc_chkIds[i];
            }
        }
        PageMethods.InsertIncrementProposalRecord(codes, incstep1_OnSuccess, incstep1_OnError);
        return false;
    }
    else {
        alert("Please select atleast one employee.");
        return false;
    }
    return false;
}

function incstep1_OnSuccess(result) {
    if (result > 0) {
        alert("Employees transfered to step 2. Please click OK to proceed.");
        incstep1_bindgrid();
        document.getElementById("custom-tabs-one-home-tab").classList.remove("active");
        document.getElementById("custom-tabs-one-home").classList.remove("active");
        document.getElementById("custom-tabs-one-profile-tab").classList.add("active");
        document.getElementById("custom-tabs-one-profile").classList.add("active");
    }
    return false;
}

function incstep1_OnError(error) {
    alert(error);
}


function incstep1_bindgrid() {
    $('#load1').show();
    assetlist_html = '';
    $.ajax({
        url: "IncrementProposalReport_Step1.aspx/GetDueForIncrement",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//

            incstep1_table = $('#incstep1_table').DataTable({
                dom: 'Bftip',
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
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
                    { data: '' },
                    { data: 'Code' },
                    { data: 'Name' },
                    { data: 'JoiningDate' },
                    { data: 'BranchName' },
                    { data: 'DepartmentName' },
                    { data: 'DesignationName' },
                    { data: 'ReportingManager' },
                    { data: 'DPType' },
                    { data: 'Salary' },
                    { data: 'LatestLoginDate' },
                    { data: 'TenureSinceLastInc' },
                    { data: 'Difference' },
                    { data: 'BeforeSalary' },
                    { data: 'PreviousIncMonth' },
                    { data: 'PrevIncPerc' }

                ],
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                },
                columnDefs: [
                    {
                        targets: 0,
                        "width": "45px",
                        render: function (data, type, row, meta) {
                            return '<input type="checkbox" class="dropdown-item" href="#!" id="' + row.Code + '" onclick="GetCheckedCheckboxes_incstep1(this);" />';
                            //return '<input type="button" class="btn-primary" id=viewdetails-"' + meta.row + '" value="Details" onclick="return ViewPolicyDetails(\'' + meta.row + '\');" />&nbsp;<input type="button" class="btn-default" id=viewtasks-"' + meta.row + '" value="Tasks"  onclick="return ViewTaskDetails(\'' + meta.row + '\');"/>';
                        }

                    }
                ],

                initComplete: function () {
                    $('#load1').hide();

                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Employees Due For Increment', autoFilter: true,
                        exportOptions: {
                            columns: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
                        }

                    },


                ],

            });
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    $('#allassetslist thead tr:eq(1) th').each(function () {
        var title = $(this).text();
        $(this).html('<input type="text" placeholder="Search ' + title + '" class="column_search" />');
    });

    $('#allassetslist thead').on('keyup', ".column_search", function () {

        allassetslist
            .column($(this).parent().index())
            .search(this.value)
            .draw();
    });
    return false;
}