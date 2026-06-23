var md_table;
var md_html;

var md_agr_history_table;
var md_agr_history_html;

var md_clientlist_history_table;
var md_clientlist_history_html;

var success_msg = "";
var error_msg = "";
var docType = "";

function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

function core_md_BindMasterData() {
    $('#load1').show();
    md_html = '';
    $.ajax({
        url: "MasterData.aspx/GetMasterData",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);

            $.each(dataArray, function (index, value) {
                //    var addeddate = eval(value.AddedDate.replace(/\/Date\((\d+)\)\//gi, "new Date($1).toLocaleDateString(\"en-US\")"));
                md_html += '<tr>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(index + 1) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.EmployeeID) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Code) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Name) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Salary) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.JoiningDate) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.DateOfBirth) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Branch) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Department) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Designation) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Domain) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Subdomain) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ReportingManager) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.DomainHead) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ContactNo) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.EmailAddress) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.PresentAddress) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.PermanentAddress) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.UAN) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ESICNo) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.LatestLoginDate) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.CurrentStatus) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ProductivityTask) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Agreement2017Version) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Agreement2017Date) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Agreement2017ExpiryDate) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Agreement2017StampPaper) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Agreement2018Version) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Agreement2018Date) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Agreement2018ExpiryDate) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Agreement2018StampPaper) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Agreement2019Version) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Agreement2019Date) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Agreement2019ExpiryDate) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Agreement2019StampPaper) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Agreement11Version) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Agreement11Date) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Agreement11ExpiryDate) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Agreement11StampPaper) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Agreement2Version) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Agreement2Date) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Agreement2ExpiryDate) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Agreement2StampPaper) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Agreement285Version) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Agreement285Date) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Agreement285ExpiryDate) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Agreement285StampPaper) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.NonSolicitationClauseNo285) + '</td>';
                md_html += '<td style="text-wrap: nowrap;"><label style="width:500px;text-wrap:wrap;">' + blankForNull(value.NonSolicitationPenalty285) + '</label></td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ThreeMonthsClauseNo285) + '</td>';
                md_html += '<td style="text-wrap: nowrap;"><label style="width:500px;text-wrap:wrap;">' + blankForNull(value.ThreeMonthsPenalty285) + '</label></td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.MinimumServiceClauseNo285) + '</td>';
                md_html += '<td style="text-wrap: nowrap;"><label style="width:500px;text-wrap:wrap;">' + blankForNull(value.MinimumServicePenalty285) + '</label></td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.MinimumServiceYears285) + '</td>';

                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Agreement29Version) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Agreement29Date) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Agreement29ExpiryDate) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Agreement29StampPaper) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.NonSolicitationClauseNo29) + '</td>';
                md_html += '<td style="text-wrap: nowrap;"><label style="width:500px;text-wrap:wrap;">' + blankForNull(value.NonSolicitationPenalty29) + '</label></td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ThreeMonthsClauseNo29) + '</td>';
                md_html += '<td style="text-wrap: nowrap;"><label style="width:500px;text-wrap:wrap;">' + blankForNull(value.ThreeMonthsPenalty29) + '</label></td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.MinimumServiceClauseNo29) + '</td>';
                md_html += '<td style="text-wrap: nowrap;"><label style="width:500px;text-wrap:wrap;">' + blankForNull(value.MinimumServicePenalty29) + '</label></td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.MinimumServiceYears29) + '</td>';

                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Agreement3Version) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Agreement3Date) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Agreement3ExpiryDate) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Agreement3StampPaper) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.NonSolicitationClauseNo3) + '</td>';
                md_html += '<td style="text-wrap: nowrap;"><label style="width:500px;text-wrap:wrap;">' + blankForNull(value.NonSolicitationPenalty3) + '</label></td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ThreeMonthsClauseNo3) + '</td>';
                md_html += '<td style="text-wrap: nowrap;"><label style="width:500px;text-wrap:wrap;">' + blankForNull(value.ThreeMonthsPenalty3) + '</label></td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.MinimumServiceClauseNo3) + '</td>';
                md_html += '<td style="text-wrap: nowrap;"><label style="width:500px;text-wrap:wrap;">' + blankForNull(value.MinimumServicePenalty3) + '</label></td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.MinimumServiceYears3) + '</td>';

                md_html += '<td style="text-wrap: nowrap;"><a class="dropdown-item" href="#!" id="Actions" onclick="md_AddAgreement(' + value.EmployeeID + ',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-plus-circle" style="font-size:14px;"></i></span></a></td>';
                md_html += '<td style="text-wrap: nowrap;"><a class="dropdown-item" href="#!" id="Actions" onclick="md_AgreementHistory(' + value.EmployeeID + ',' + index + ');"><span style="color: orange;"><i class="uil fs-0 me-2 uil-history" style="font-size:14px;"></i></span></a></td>';
                md_html += '<td style="text-wrap: nowrap;"><a class="dropdown-item" href="#!" id="Actions" onclick="md_AddAgreementClause(' + value.EmployeeID + ',' + index + ');"><span style="color: green;"><i class="uil fs-0 me-2 uil-plus-circle" style="font-size:14px;"></i></span></a></td>';

                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Addendum1Version) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Addendum1SignedDate) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Addendum1StampPaper) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.NonSolicitationClauseNo1Add) + '</td>';
                md_html += '<td style="text-wrap: nowrap;"><label style="width:500px;text-wrap:wrap;">' + blankForNull(value.NonSolicitationPenalty1Add) + '</label></td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ThreeMonthsClauseNo1Add) + '</td>';
                md_html += '<td style="text-wrap: nowrap;"><label style="width:500px;text-wrap:wrap;">' + blankForNull(value.ThreeMonthsPenalty1Add) + '</label></td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.MinimumServiceClauseNo1Add) + '</td>';
                md_html += '<td style="text-wrap: nowrap;"><label style="width:500px;text-wrap:wrap;">' + blankForNull(value.MinimumServicePenalty1Add) + '</label></td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.MinimumServiceYears1Add) + '</td>';

                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Addendum2Version) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Addendum2SignedDate) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Addendum2StampPaper) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.NonSolicitationClauseNo2Add) + '</td>';
                md_html += '<td style="text-wrap: nowrap;"><label style="width:500px;text-wrap:wrap;">' + blankForNull(value.NonSolicitationPenalty2Add) + '</label></td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ThreeMonthsClauseNo2Add) + '</td>';
                md_html += '<td style="text-wrap: nowrap;"><label style="width:500px;text-wrap:wrap;">' + blankForNull(value.ThreeMonthsPenalty2Add) + '</label></td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.MinimumServiceClauseNo2Add) + '</td>';
                md_html += '<td style="text-wrap: nowrap;"><label style="width:500px;text-wrap:wrap;">' + blankForNull(value.MinimumServicePenalty2Add) + '</label></td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.MinimumServiceYears2Add) + '</td>';

                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Addendum25Version) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Addendum25SignedDate) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Addendum25StampPaper) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.NonSolicitationClauseNo25Add) + '</td>';
                md_html += '<td style="text-wrap: nowrap;"><label style="width:500px;text-wrap:wrap;">' + blankForNull(value.NonSolicitationPenalty25Add) + '</label></td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ThreeMonthsClauseNo2Add) + '</td>';
                md_html += '<td style="text-wrap: nowrap;"><label style="width:500px;text-wrap:wrap;">' + blankForNull(value.ThreeMonthsPenalty25Add) + '</label></td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.MinimumServiceClauseNo25Add) + '</td>';
                md_html += '<td style="text-wrap: nowrap;"><label style="width:500px;text-wrap:wrap;">' + blankForNull(value.MinimumServicePenalty25Add) + '</label></td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.MinimumServiceYears25Add) + '</td>';

                md_html += '<td style="text-wrap: nowrap;"><a class="dropdown-item" href="#!" id="Actions" onclick="md_AddAddendum(' + value.EmployeeID + ',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-plus-circle" style="font-size:14px;"></i></span></a></td>';
                md_html += '<td style="text-wrap: nowrap;"><a class="dropdown-item" href="#!" id="Actions" onclick="md_AddAddendumClause(' + value.EmployeeID + ',' + index + ');"><span style="color: green;"><i class="uil fs-0 me-2 uil-plus-circle" style="font-size:14px;"></i></span></a></td>';

                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ClientListVersion) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ClientListStatus) + '</td>';

                md_html += '<td style="text-wrap: nowrap;"><a class="dropdown-item" href="#!" id="Actions" onclick="md_AddClientList(' + value.EmployeeID + ',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-plus-circle" style="font-size:14px;"></i></span></a></td>';
                md_html += '<td style="text-wrap: nowrap;"><a class="dropdown-item" href="#!" id="Actions" onclick="md_ClientListHistory(' + value.EmployeeID + ',' + index + ');"><span style="color: orange;"><i class="uil fs-0 me-2 uil-history" style="font-size:14px;"></i></span></a></td>';

                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Pseudoname) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.PseudonameAgreementStatus) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.PseudonameAcknowledgementDate) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.PenaltyforBreachPsudonameUndertaking) + '</td>';

                md_html += '<td style="text-wrap: nowrap;"><a class="dropdown-item" href="#!" id="Actions" onclick="md_AddPseudoname(' + value.EmployeeID + ',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-plus-circle" style="font-size:14px;"></i></span></a></td>';

                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.UndertakingVersion) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.UndertakingSignedDate) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.UndertakingStampPaper) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.UndertakingStampPaperCost) + '</td>';

                md_html += '<td style="text-wrap: nowrap;"><a class="dropdown-item" href="#!" id="Actions" onclick="md_AddUndertaking(' + value.EmployeeID + ',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-plus-circle" style="font-size:14px;"></i></span></a></td>';

                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.FileTracker) + '</td>';
                md_html += '<td style="text-wrap: nowrap;"><a class="dropdown-item" href="#!" id="Actions" onclick="md_FileTracker(' + value.EmployeeID + ',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-plus-circle" style="font-size:14px;"></i></span></a></td>';

                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.VisaNo) + '</td>';
                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ValidTill) + '</td>';
                md_html += '<td style="text-wrap: nowrap;"><a class="dropdown-item" href="#!" id="Actions" onclick="md_USVisa(' + value.EmployeeID + ',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-plus-circle" style="font-size:14px;"></i></span></a></td>';

                md_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ScannedCopy) + '</td>';
                md_html += '<td style="text-wrap: nowrap;"><a class="dropdown-item" href="#!" id="Actions" onclick="md_ScannedCopy(' + value.EmployeeID + ',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-plus-circle" style="font-size:14px;"></i></span></a></td>';

                md_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#md_table')) {
                md_table.destroy();
            }
            $('#md_table tbody').html(md_html);

            md_table = $('#md_table').DataTable({
                fixedColumns: {
                    start: 4
                },
                scrollCollapse: true,
                dom: 'lBftip',
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
                initComplete: function () {
                    $('#load1').hide();
                },

                "rowCallback": function (row, data) {
                    // Cell at index 5 in the row is 'Active'.
                    var val = data[3];
                },

                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Master Data', autoFilter: true,
                    },
                ],
            });
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }


    });

    //var isrch = 0;
    //$('#md_table thead tr:eq(4) th').each(function () {
    //    if (isrch == 3) {
    //        var title = $(this).text();
    //        $(this).html('<input type="text" placeholder="Search ' + title + '" class="column_search" />');
    //    }
    //    else {
    //        $(this).html('');
    //    }
    //    isrch++;
    //});

    //$('#md_table thead').on('keyup', ".column_search", function () {

    //    md_table    
    //        .column($(this).parent().index())
    //        .search(this.value)
    //        .draw();

    //})
    return false;
}


function md_BindMasterData() {
    $('#load1').show();

    const tableId = '#md_table';

    const baseColumns = [
        {
            title: 'Sr. #', data: null, render: function (data, type, row, meta) {
                return meta.settings._iDisplayStart + meta.row + 1;
            }
        },
        { title: 'EmployeeID', data: 'EmployeeID' },
        { title: 'Code', data: 'Code' },
        { title: 'Name', data: 'Name' },
        { title: 'Salary', data: 'Salary' },
        { title: 'Joining Date', data: 'JoiningDate' },
        { title: 'Date Of Birth', data: 'DateOfBirth' },
        { title: 'Branch', data: 'Branch' },
        { title: 'Department', data: 'Department' },
        { title: 'Designation', data: 'Designation' },
        { title: 'Domain', data: 'Domain' },
        { title: 'Subdomain', data: 'Subdomain' },
        { title: 'Reporting Manager', data: 'ReportingManager' },
        { title: 'Domain Head', data: 'DomainHead' },
        { title: 'Contact #', data: 'ContactNo' },
        { title: 'Email Address', data: 'EmailAddress' },
        { title: 'Present Address', data: 'PresentAddress' },
        { title: 'Permanent Address', data: 'PermanentAddress' },
        { title: 'UAN', data: 'UAN' },
        { title: 'ESIC #', data: 'ESICNo' },
        { title: 'Latest Login Date', data: 'LatestLoginDate' },
        { title: 'Current Status', data: 'CurrentStatus' },
        { title: 'Productivity/Task', data: 'ProductivityTask' }
    ];

    const agreementColumns = [
        group4('Agreement 2017', 'Agreement2017Version', 'Agreement2017Date', 'Agreement2017ExpiryDate', 'Agreement2017StampPaper'),
        group4('Agreement 2018', 'Agreement2018Version', 'Agreement2018Date', 'Agreement2018ExpiryDate', 'Agreement2018StampPaper'),
        group4('Agreement 2019', 'Agreement2019Version', 'Agreement2019Date', 'Agreement2019ExpiryDate', 'Agreement2019StampPaper'),
        group4('Agreement 1.1', 'Agreement11Version', 'Agreement11Date', 'Agreement11ExpiryDate', 'Agreement11StampPaper'),
        group4('Agreement 2.0', 'Agreement2Version', 'Agreement2Date', 'Agreement2ExpiryDate', 'Agreement2StampPaper'),

        agreement11('Agreement 2.8.5', 'Agreement285', '285'),
        agreement11('Agreement 2.9', 'Agreement29', '29'),
        agreement11('Agreement 3.0', 'Agreement3', '3')
    ].flat();

    const actionAgreementColumns = [
        actionCol('Add Agreement', 'md_AddAgreement', 'dodgerblue', 'uil-plus-circle'),
        actionCol('Agreement History', 'md_AgreementHistory', 'orange', 'uil-history'),
        actionCol('Add Clause', 'md_AddAgreementClause', 'green', 'uil-plus-circle')
    ];

    const addendumColumns = [
        addendum10('Addendum 1.0', 'Addendum1', '1Add'),
        addendum10('Addendum 2.0', 'Addendum2', '2Add'),
        addendum10('Addendum 2.5', 'Addendum25', '25Add')
    ].flat();

    const finalColumns = [
        actionCol('Add Addendum', 'md_AddAddendum', 'dodgerblue', 'uil-plus-circle'),
        actionCol('Add Clause', 'md_AddAddendumClause', 'green', 'uil-plus-circle'),

        { title: 'Client List Version', data: 'ClientListVersion' },
        { title: 'Client List Status', data: 'ClientListStatus' },
        actionCol('Add Client List', 'md_AddClientList', 'dodgerblue', 'uil-plus-circle'),
        actionCol('Client List History', 'md_ClientListHistory', 'orange', 'uil-history'),

        { title: 'Pseudoname', data: 'Pseudoname' },
        { title: 'Agreement Status', data: 'PseudonameAgreementStatus' },
        { title: 'Acknowledgement Date', data: 'PseudonameAcknowledgementDate' },
        { title: 'Penalty for Breach - Pseudoname Undertaking', data: 'PenaltyforBreachPsudonameUndertaking' },
        actionCol('Add Pseudoname Details', 'md_AddPseudoname', 'dodgerblue', 'uil-plus-circle'),

        { title: 'Undertaking Version', data: 'UndertakingVersion' },
        { title: 'Undertaking Signed Date', data: 'UndertakingSignedDate' },
        { title: 'Undertaking Stamp Paper #', data: 'UndertakingStampPaper' },
        { title: 'Undertaking Cost', data: 'UndertakingStampPaperCost' },
        actionCol('Add Undertaking', 'md_AddUndertaking', 'dodgerblue', 'uil-plus-circle'),

        { title: 'File #', data: 'FileTracker' },
        actionCol('File Tracker', 'md_FileTracker', 'dodgerblue', 'uil-plus-circle'),

        { title: 'Visa #', data: 'VisaNo' },
        { title: 'Valid Till', data: 'ValidTill' },
        actionCol('Update Visa #', 'md_USVisa', 'dodgerblue', 'uil-plus-circle'),

        { title: 'Is Scanned Copy Updated?', data: 'ScannedCopy' },
        actionCol('Update Scanned Copy', 'md_ScannedCopy', 'dodgerblue', 'uil-plus-circle')
    ];

    const allColumns = [
        ...baseColumns,
        ...agreementColumns,
        ...actionAgreementColumns,
        ...addendumColumns,
        ...finalColumns
    ];

    buildHeader(tableId, allColumns);

    $.ajax({
        url: "MasterData.aspx/GetMasterData",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            const dataArray = JSON.parse(data.d || '[]');

            if ($.fn.DataTable.isDataTable(tableId)) {
                $(tableId).DataTable().clear().destroy();
            }

            md_table = $(tableId).DataTable({
                data: dataArray,
                columns: allColumns,
                dom: 'lBftip',
                scrollX: true,
                scrollCollapse: true,
                destroy: true,
                paging: true,
                autoWidth: false,
                ordering: false,
                processing: true,
                select: {
                    style: 'single'
                },
                fixedColumns: {
                    leftColumns: 4
                },
                columnDefs: [
                    {
                        targets: '_all',
                        className: 'dt-nowrap',
                        render: function (data, type, row, meta) {
                            if (type === 'display') {
                                return blankForNull(data);
                            }
                            return data;
                        }
                    }
                ],
                buttons: [
                    {
                        extend: 'excelHtml5',
                        title: 'Master Data',
                        autoFilter: true
                    }
                ],
                initComplete: function () {
                    $('#load1').hide();
                    $(tableId).show();
                }
            });
        },

        error: function (error) {
            $('#load1').hide();
            alert('error; ' + error.responseText);
        }
    });

    return false;
}

function buildHeader(tableId, columns) {
    let headerHtml = '<tr>';

    columns.forEach(function (col) {
        headerHtml += '<th class="sort border-top ps-3" style="text-wrap:nowrap;">' + col.title + '</th>';
    });

    headerHtml += '</tr>';

    $(tableId + ' thead').html(headerHtml);
}

function group4(groupName, version, date, expiry, stamp) {
    return [
        { title: groupName + ' Version', data: version },
        { title: groupName + ' Agreement Date', data: date },
        { title: groupName + ' Expiry Date', data: expiry },
        { title: groupName + ' Stamp Paper #', data: stamp }
    ];
}

function agreement11(groupName, prefix, suffix) {
    return [
        { title: groupName + ' Version', data: prefix + 'Version' },
        { title: groupName + ' Agreement Date', data: prefix + 'Date' },
        { title: groupName + ' Expiry Date', data: prefix + 'ExpiryDate' },
        { title: groupName + ' Stamp Paper #', data: prefix + 'StampPaper' },
        { title: groupName + ' Non Solicitation Clause #', data: 'NonSolicitationClauseNo' + suffix },
        wrapCol(groupName + ' Non Solicitation Penalty', 'NonSolicitationPenalty' + suffix),
        { title: groupName + ' 3 Months Clause #', data: 'ThreeMonthsClauseNo' + suffix },
        wrapCol(groupName + ' 3 Months Penalty', 'ThreeMonthsPenalty' + suffix),
        { title: groupName + ' Minimum Service Clause #', data: 'MinimumServiceClauseNo' + suffix },
        wrapCol(groupName + ' Minimum Service Penalty', 'MinimumServicePenalty' + suffix),
        { title: groupName + ' Minimum Service Years', data: 'MinimumServiceYears' + suffix }
    ];
}

function addendum10(groupName, prefix, suffix) {
    return [
        { title: groupName + ' Version', data: prefix + 'Version' },
        { title: groupName + ' Signed Date', data: prefix + 'SignedDate' },
        { title: groupName + ' Stamp Paper #', data: prefix + 'StampPaper' },
        { title: groupName + ' Non Solicitation Clause #', data: 'NonSolicitationClauseNo' + suffix },
        wrapCol(groupName + ' Non Solicitation Penalty', 'NonSolicitationPenalty' + suffix),
        { title: groupName + ' 3 Months Clause #', data: 'ThreeMonthsClauseNo' + suffix },
        wrapCol(groupName + ' 3 Months Penalty', 'ThreeMonthsPenalty' + suffix),
        { title: groupName + ' Minimum Service Clause #', data: 'MinimumServiceClauseNo' + suffix },
        wrapCol(groupName + ' Minimum Service Penalty', 'MinimumServicePenalty' + suffix),
        { title: groupName + ' Minimum Service Years', data: 'MinimumServiceYears' + suffix }
    ];
}

function wrapCol(title, fieldName) {
    return {
        title: title,
        data: fieldName,
        render: function (data) {
            return '<label style="width:500px;text-wrap:wrap;">' + blankForNull(data) + '</label>';
        }
    };
}

function actionCol(title, functionName, color, icon) {
    return {
        title: title,
        data: null,
        orderable: false,
        searchable: false,
        render: function (data, type, row, meta) {
            return '<a class="dropdown-item" href="#!" onclick="' + functionName + '(' + row.EmployeeID + ',' + meta.row + ');">' +
                '<span style="color:' + color + ';">' +
                '<i class="uil fs-0 me-2 ' + icon + '" style="font-size:14px;"></i>' +
                '</span></a>';
        }
    };
}

function blankForNull(value) {
    return value === null || value === undefined ? '' : value;
}


function getagreementexpirydate() {

    var agreementdate = document.getElementById('md_agg_agreementdate').value;
    var ddl = document.getElementById("md_addagg_years");
    var years = ddl.options[ddl.selectedIndex].value;

    if (years > 0 && agreementdate != "") {

        var date = new Date(agreementdate);
        date.setDate(date.getDate() - 1);

        var day = date.getDate();
        if (day < 10)
            day = '0' + day
        var month = date.getMonth() + 1;
        if (month < 10)
            month = '0' + month

        var year = date.getFullYear();
        var newyear = (parseInt(year) + parseInt(years));
        var actualdate = newyear + "-" + (month) + "-" + (day);
        $("#md_agg_expirydate").val(actualdate);
    }
    else {
        $("#md_agg_expirydate").val("");
    }
}


/*---------------  Show Pop-Up  ---------------*/

function md_AddAgreement(EmployeeID, Index) {
    var row = md_table.row(Index).data();
    var codename = row[2] + ' : ' + row[3];
    document.getElementById("addagreementLabel").innerHTML = "Add Agreement Details -- " + codename;
    document.getElementById("md_addagreement_employeeid").innerHTML = row[2];
    $("#addagreement").modal("show");
}

function md_AgreementHistory(EmployeeID, Index) {
    var row = md_table.row(Index).data();
    var codename = row[2] + ' : ' + row[3];
    document.getElementById("agreementhistoryLabel").innerHTML = "Agreement History -- " + codename;
    document.getElementById("md_agreementhistory_employeeid").innerHTML = row[2];
    md_agrhistory_bindtable(row[2], "Agreement");
    $("#agreementhistory").modal("show");
}

function md_agrhistory_bindtable(Code, Type) {
    $('#load1').show();
    md_agr_history_html = '';
    $.ajax({
        url: "MasterData.aspx/GetStampPaperHistory",
        type: "POST",
        data: "{Code:'" + Code + "', Type:'" + Type + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                var addeddate = eval(value.AddedDate.replace(/\/Date\((\d+)\)\//gi, "new Date($1).toLocaleDateString(\"en-US\")"));
                md_agr_history_html += '<tr>';
                md_agr_history_html += '<td style="text-wrap: nowrap;">' + blankForNull(index + 1) + '</td>';
                md_agr_history_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Type) + '</td>';
                md_agr_history_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Duration) + '</td>';
                md_agr_history_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.StampPapersUsed) + '</td>';
                md_agr_history_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.StampPaperNo) + '</td>';
                md_agr_history_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.AgreementDate) + '</td>';
                md_agr_history_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ExpiryDate) + '</td>';
                md_agr_history_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Version) + '</td>';
                md_agr_history_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.FileNo) + '</td>';
                md_agr_history_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.AddedByName) + '</td>';
                md_agr_history_html += '<td style="text-wrap: nowrap;">' + blankForNull(addeddate) + '</td>';
                md_agr_history_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#md_agr_history_table')) {
                md_agr_history_table.destroy();
            }
            $('#md_agr_history_table tbody').html(md_agr_history_html);
            //else
            md_agr_history_table = $('#md_agr_history_table').DataTable({
                scrollCollapse: true,
                dom: 'lftip',
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
                initComplete: function () {
                    $('#load1').hide();
                },
            });

            //$('#fnalize tbody').on('click', 'tr', function () {
            //    row = table.row(this).data();
            //});
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}

function md_AddAgreementClause(EmployeeID, Index) {
    var row = md_table.row(Index).data();
    var codename = row[2] + ' : ' + row[3];
    document.getElementById("agreementclauseLabel").innerHTML = "Add Agreement Clause -- " + codename;
    document.getElementById("md_agreementclause_employeeid").innerHTML = row[2];
    $("#agreementclause").modal("show");
}

function md_AddAddendum(EmployeeID, Index) {
    var row = md_table.row(Index).data();
    var codename = row[2] + ' : ' + row[3];
    document.getElementById("addaddendumLabel").innerHTML = "Add Addendum Details -- " + codename;
    document.getElementById("md_addaddendum_employeeid").innerHTML = row[2];
    $("#addaddendum").modal("show");
}

function md_AddAddendumClause(EmployeeID, Index) {
    var row = md_table.row(Index).data();
    var codename = row[2] + ' : ' + row[3];
    document.getElementById("addaddendumclauseLabel").innerHTML = "Add Addendum Clause -- " + codename;
    document.getElementById("md_addaddendumclause_employeeid").innerHTML = row[2];
    $("#addaddendumclause").modal("show");
}

function md_AddClientList(EmployeeID, Index) {
    var row = md_table.row(Index).data();
    var codename = row[2] + ' : ' + row[3];
    document.getElementById("addclientlistLabel").innerHTML = "Add Client List -- " + codename;
    document.getElementById("md_addclientlist_employeeid").innerHTML = row[2];
    $("#addclientlist").modal("show");
}

function md_ClientListHistory(EmployeeID, Index) {
    var row = md_table.row(Index).data();
    var codename = row[2] + ' : ' + row[3];
    document.getElementById("clientlisthistoryLabel").innerHTML = "Client List History -- " + codename;
    document.getElementById("md_clientlisthistory_employeeid").innerHTML = row[2];
    md_clientList_bindtable(row[2], "ClientList");
    $("#clientlisthistory").modal("show");
}

function md_clientList_bindtable(Code, Type) {
    $('#load1').show();
    md_clientlist_history_html = '';

    $.ajax({
        url: "MasterData.aspx/GetStampPaperHistory",
        type: "POST",
        data: "{Code:'" + Code + "', Type:'" + Type + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                var addeddate = eval(value.AddedDate.replace(/\/Date\((\d+)\)\//gi, "new Date($1).toLocaleDateString(\"en-US\")"));
                md_clientlist_history_html += '<tr>';
                md_clientlist_history_html += '<td style="text-wrap: nowrap;">' + blankForNull(index + 1) + '</td>';
                md_clientlist_history_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Type) + '</td>';
                md_clientlist_history_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.SignedDate) + '</td>';
                md_clientlist_history_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Version) + '</td>';
                md_clientlist_history_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.OtherRemark) + '</td>';
                md_clientlist_history_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.AddedByName) + '</td>';
                md_clientlist_history_html += '<td style="text-wrap: nowrap;">' + blankForNull(addeddate) + '</td>';
                md_agr_history_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#md_clientlist_history_table')) {
                md_clientlist_history_table.destroy();
            }
            $('#md_clientlist_history_table tbody').html(md_clientlist_history_html);

            md_clientlist_history_table = $('#md_clientlist_history_table').DataTable({
                scrollCollapse: true,
                dom: 'lftip',
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

function md_AddPseudoname(EmployeeID, Index) {
    var row = md_table.row(Index).data();
    var codename = row[2] + ' : ' + row[3];
    document.getElementById("addpseudonameLabel").innerHTML = "Add Pseudoname -- " + codename;
    document.getElementById("md_addpseudoname_employeeid").innerHTML = row[2];
    $("#addpseudoname").modal("show");
}

function md_AddUndertaking(EmployeeID, Index) {
    var row = md_table.row(Index).data();
    var codename = row[2] + ' : ' + row[3];
    document.getElementById("addundertakingLabel").innerHTML = "Add Undertaking -- " + codename;
    document.getElementById("md_addundertaking_employeeid").innerHTML = row[2];
    $("#addundertaking").modal("show");
}

function md_FileTracker(EmployeeID, Index) {
    var row = md_table.row(Index).data();
    var codename = row[2] + ' : ' + row[3];
    document.getElementById("filetrackerLabel").innerHTML = "Update File Details -- " + codename;
    document.getElementById("md_filetracker_employeeid").innerHTML = row[2];
    $("#filetracker").modal("show");
}

function md_USVisa(EmployeeID, Index) {
    var row = md_table.row(Index).data();
    var codename = row[2] + ' : ' + row[3];
    document.getElementById("usvisaLabel").innerHTML = "Update Visa Details -- " + codename;
    document.getElementById("md_usvisa_employeeid").innerHTML = row[2];
    $("#usvisa").modal("show");
}

function md_ScannedCopy(EmployeeID, Index) {
    var row = md_table.row(Index).data();
    var codename = row[2] + ' : ' + row[3];
    document.getElementById("scannedcopyLabel").innerHTML = "Update Scanned Copy -- " + codename;
    document.getElementById("md_scannedcopy_employeeid").innerHTML = row[2];
    $("#scannedcopy").modal("show");
}


/*--------------- Submit Pop-Up ---------------*/

function md_addagg_submit() {

    success_msg = "";
    error_msg = "";

    var code = document.getElementById("md_addagreement_employeeid").innerHTML;
    var type = "Agreement";
    var cost = document.getElementById("md_addagg_stamppapercost").value;
    var ddlversion = document.getElementById("md_addagg_version");
    var version = ddlversion.options[ddlversion.selectedIndex].value;
    var ddlyears = document.getElementById("md_addagg_years");
    var duration = ddlyears.options[ddlyears.selectedIndex].value;
    var agreementdate = document.getElementById("md_agg_agreementdate").value;
    var expirydate = document.getElementById("md_agg_expirydate").value;
    var ddlstamppaper = document.getElementById("md_addagg_stamppaperused");
    var stamppapersused = ddlstamppaper.options[ddlstamppaper.selectedIndex].value;
    var stamppaperno = document.getElementById("md_addagg_stamppaperno").value;
    var fileno = document.getElementById("md_addagg_fileno").value;
    var signeddate = "";
    var ackdate = document.getElementById("md_agg_ackdate").value;
    var remark = document.getElementById("md_addagg_remark").value;
    var PenaltyPseudoname = "";

    if (duration == "") {
        alert("Please select No. of Years.");
        return;
    }
    if (agreementdate == "") {
        alert("Please select agreement date.");
        return;
    }
    if (expirydate == "") {
        alert("Please select expiry date.");
        return;
    }
    if (stamppapersused == "") {
        alert("Please select number of stamp papers used.");
        return;
    }
    if (stamppaperno == "") {
        alert("Please enter stamp paper number.");
        return;
    }
    if (fileno == "") {
        alert("Please enter file no.");
        return;
    }
    if (version == "") {
        alert("Please select document version.");
        return;
    }
    if (remark == "") {
        alert("Please enter remark.");
        return;
    }

    if (cost == "") {
        cost = "0";
    }
    
    docType = "Agreement";
    success_msg = "Agreement record saved successfully!";
    error_msg = "Oops! Error occured while saving record. Please contact administrator!";

    PageMethods.InsertStampPaperDetails(code, type, cost, version, duration, agreementdate, expirydate, stamppapersused, stamppaperno, fileno, signeddate, ackdate, remark, PenaltyPseudoname, md_OnSuccess, md_OnError)
    return false;
}

function md_agrclause_submit() {
    var code = document.getElementById("md_agreementclause_employeeid").innerHTML;
    var type = "Agreement";
    var ddlversion = document.getElementById("md_agrclause_version");
    var version = ddlversion.options[ddlversion.selectedIndex].value;
    var ddlclause = document.getElementById("md_agrclause_clause");
    var clause = ddlclause.options[ddlclause.selectedIndex].value;
    var clauseno = document.getElementById("md_agrclause_clauseno").value;
    var penalty = document.getElementById("md_agrclause_penalty").value;

    if (version == "") {
        alert("Please select version.");
        return;
    }
    if (clause == "") {
        alert("Please select clause.");
        return;
    }
    if (clauseno == "") {
        alert("Please enter clause number.");
        return;
    }
    if (penalty == "") {
        alert("Please enter Penalty for breaching clause.");
        return;
    }

    success_msg = "Agreement clause added successfully!";
    error_msg = "Oops! Error occured while adding agreement clause. Please contact administrator!";

    PageMethods.InsertStamppaperClause(code, type, version, clause, clauseno, penalty, md_OnSuccess, md_OnError);

    return false;
}

function md_addadm_submit() {

    success_msg = "";
    error_msg = "";

    var code = document.getElementById("md_addaddendum_employeeid").innerHTML;
    var stamppaperno = document.getElementById("md_addadm_stamppaperno").value;
    var signeddate = document.getElementById("md_addadm_signeddate").value;
    var ackdate = document.getElementById("md_addadm_ackdate").value;
    var remark = document.getElementById("md_addadm_remark").value;
    var cost = document.getElementById("md_addadm_cost").value;
    var stamppapersused = 1;
    var type = "Addendum";

    var ddlversion = document.getElementById("md_addadm_version");
    var version = ddlversion.options[ddlversion.selectedIndex].value;

    var PenaltyPseudoname = "";
    var agreementdate = "";
    var expirydate = "";
    var duration = "";
    var fileno = "";

    if (stamppaperno == "") {
        alert("Please enter stamp paper number.");
        return;
    }
    if (signeddate == "") {
        alert("Please enter signed date.");
        return;
    }
    if (ackdate == "") {
        alert("Please enter acknowledgement date.");
        return;
    }
    if (version == "") {
        alert("Please select document version.");
        return;
    }
    if (remark == "") {
        alert("Please enter remark.");
        return;
    }
    if (cost == "") {
        cost = "0";
    }

    success_msg = "Addendum added successfully!";
    error_msg = "Oops! Error occured while adding addendum. Please contact administrator!";

    PageMethods.InsertStampPaperDetails(code, type, cost, version, duration, agreementdate, expirydate, stamppapersused, stamppaperno, fileno, signeddate, ackdate, remark, PenaltyPseudoname, md_OnSuccess, md_OnError)
    return false;
}

function md_addmclause_submit() {

    success_msg = "";
    error_msg = "";

    var code = document.getElementById("md_addaddendumclause_employeeid").innerHTML;
    var type = "Addendum";
    var ddlversion = document.getElementById("md_addmclause_version");
    var version = ddlversion.options[ddlversion.selectedIndex].value;
    var ddlclause = document.getElementById("md_addmclause_clause");
    var clause = ddlclause.options[ddlclause.selectedIndex].value;
    var clauseno = document.getElementById("md_addmclause_clauseno").value;
    var penalty = document.getElementById("md_addmclause_penalty").value;

    if (version == "") {
        alert("Please select version.");
        return;
    }
    if (clause == "") {
        alert("Please select clause.");
        return;
    }
    if (clauseno == "") {
        alert("Please enter clause number.");
        return;
    }
    if (penalty == "") {
        alert("Please enter penalty for breaching clause");
        return
    }

    success_msg = "Addendum clause added successfully!";
    error_msg = "Oops! Error occured while adding addendum clause. Please contact administrator!";

    PageMethods.InsertStamppaperClause(code, type, version, clause, clauseno, penalty, md_OnSuccess, md_OnError);

    return false;
}

function md_clilst_submit() {

    success_msg = "";
    error_msg = "";

    var code = document.getElementById("md_addclientlist_employeeid").innerHTML;
    var type = "ClientList";
    var signeddate = document.getElementById("md_clilst_signdate").value;
    var version = document.getElementById("md_clilst_version").value;
    var remark = document.getElementById("md_clilst_remark").value;

    var PenaltyPseudoname = "";
    var stamppapersused = 0;
    var agreementdate = "";
    var stamppaperno = "";
    var expirydate = "";
    var duration = "";
    var ackdate = "";
    var fileno = "";
    var cost = "0";

    if (signeddate == "") {
        alert("Please select signed date.");
        return;
    }
    if (version == "") {
        alert("Please select document version.");
        return;
    }
    if (remark == "") {
        alert("Please enter remark.");
        return;
    }

    success_msg = "Client list added successfully!";
    error_msg = "Oops! Error occured while adding client list. Please contact administrator!";

    PageMethods.InsertStampPaperDetails(code, type, cost, version, duration, agreementdate, expirydate, stamppapersused, stamppaperno, fileno, signeddate, ackdate, remark, PenaltyPseudoname, md_OnSuccess, md_OnError)
    return false;
}

function md_addpseudoname_submit() {

    success_msg = "";
    error_msg = "";

    var code = document.getElementById("md_addpseudoname_employeeid").innerHTML;
    var type = "Pseudoname";
    var ackdate = document.getElementById("md_addpseudoname_ackdate").value;
    var PenaltyPseudoname = document.getElementById("md_addpseudoname_penalty").value;
    var remark = document.getElementById("md_addpseudoname_remark").value;

    var stamppapersused = 0;
    var agreementdate = "";
    var stamppaperno = "";
    var expirydate = "";
    var signeddate = "";
    var duration = "";
    var version = "";
    var fileno = "";
    var cost = "0";

    if (PenaltyPseudoname == "") {
        alert("Please enter Penalty for breach.");
        return;
    }
    if (ackdate == "") {
        alert("Please enter acknowledgement date.");
        return;
    }
    if (remark == "") {
        alert("Please enter remark.");
        return;
    }

    success_msg = "Pseudo name added successfully!";
    error_msg = "Oops! Error occured while adding pseudo name. Please contact administrator!";

    PageMethods.InsertStampPaperDetails(code, type, cost, version, duration, agreementdate, expirydate, stamppapersused, stamppaperno, fileno, signeddate, ackdate, remark, PenaltyPseudoname, md_OnSuccess, md_OnError)
    return false;
}

function md_addundertaking_submit() {

    success_msg = "";
    error_msg = "";

    var code = document.getElementById("md_addundertaking_employeeid").innerHTML;
    var type = "Undertaking";
    var cost = document.getElementById("md_addundertaking_cost").value;
    var ddlversion = document.getElementById("md_addundertaking_version");
    var version = ddlversion.options[ddlversion.selectedIndex].value;
    var remark = document.getElementById("md_addundertaking_remark").value;
    var stamppaperno = document.getElementById("md_addundertaking_stampno").value;
    var signeddate = document.getElementById("md_addundertaking_signdate").value;

    var PenaltyPseudoname = "";
    var stamppapersused = 0;
    var agreementdate = "";
    var expirydate = "";
    var duration = "";
    var ackdate = "";
    var fileno = "";

    if (signeddate == "") {
        alert("Please enter signed date.");
        return;
    }
    if (stamppaperno == "") {
        alert("Please enter stamp paper no.");
        return;
    }
    if (cost == "") {
        alert("Please enter cost.");
        return;
    }
    if (version == "") {
        alert("Please select version.");
        return;
    }
    if (remark == "") {
        alert("Please enter remark.");
        return;
    }

    success_msg = "Undertaking added successfully!";
    error_msg = "Oops! Error occured while adding undertaking. Please contact administrator!";

    PageMethods.InsertStampPaperDetails(code, type, cost, version, duration, agreementdate, expirydate, stamppapersused, stamppaperno, fileno, signeddate, ackdate, remark, PenaltyPseudoname, md_OnSuccess, md_OnError)
    return false;
}

function md_filetracker_submit() {

    success_msg = "";
    error_msg = "";

    var code = document.getElementById("md_filetracker_employeeid").innerHTML;
    var type = "File";
    var fileno = document.getElementById("md_filetracker_fileNo").value;

    var visatilldate = "";
    var scannedcopy = "";
    var visano = "";

    if (fileno == "") {
        alert("Please senter file no.");
        return;
    }

    success_msg = "File no added successfully!";
    error_msg = "Oops! Error occured while adding file no. Please contact administrator!";

    PageMethods.InsertMasterDataDetails_FileNo(code, type, fileno, visano, visatilldate, scannedcopy, md_OnSuccess, md_OnError)
    return false;
}

function md_usvisa_submit() {

    success_msg = "";
    error_msg = "";

    var code = document.getElementById("md_filetracker_employeeid").innerHTML;
    var type = "Visa";
    var visano = document.getElementById("md_usvisano").value;
    var visatilldate = document.getElementById("md_usvisa_validdate").value;

    var scannedcopy = "";
    var fileno = "";

    if (visano == "") {
        alert("Please enter visa no.");
        return;
    }
    if (visatilldate == "") {
        alert("Please enter valid date.");
        return;
    }

    success_msg = "Visa details added successfully!";
    error_msg = "Oops! Error occured while adding visa details. Please contact administrator!";

    PageMethods.InsertMasterDataDetails_FileNo(code, type, fileno, visano, visatilldate, scannedcopy, md_OnSuccess, md_OnError)
    return false;
}

function md_scannedcopy_submit() {

    success_msg = "";
    error_msg = "";

    var code = document.getElementById("md_filetracker_employeeid").innerHTML;
    var type = "Scan";
    var ddlscannedcopy = document.getElementById("md_scannedcopy_scancopy");
    var scannedcopy = ddlscannedcopy.options[ddlscannedcopy.selectedIndex].value;

    var visatilldate = "";
    var fileno = "";
    var visano = "";

    if (scannedcopy == "") {
        alert("Please enter scanned copy.");
        return;
    }

    success_msg = "Scanned copy details added successfully!";
    error_msg = "Oops! Error occured while adding scanned copy details. Please contact administrator!";

    PageMethods.InsertMasterDataDetails_FileNo(code, type, fileno, visano, visatilldate, scannedcopy, md_OnSuccess, md_OnError)
    return false;
}

function md_OnSuccess(result) {

    $("#addagreement").modal("hide");
    $("#agreementclause").modal("hide");
    $("#addaddendum").modal("hide");
    $("#addaddendumclause").modal("hide");
    $("#addclientlist").modal("hide");
    $("#addpseudoname").modal("hide");
    $("#addundertaking").modal("hide");
    $("#filetracker").modal("hide");
    $("#usvisa").modal("hide");
    $("#scannedcopy").modal("hide");

    if (result > 0) {
        document.getElementById("md_errmsg").innerHTML = success_msg;
        $('#md_dverror').modal('show');
        document.getElementById("md_btnMessage").focus();
        return false;
    }
    else {
        document.getElementById("md_errmsg").innerHTML = error_msg
        document.getElementById("md_errmsg").style.color = 'red';
        $('#md_dverror').modal('show');
    }
    document.getElementById("md_btnMessage").focus();
    return false;
}

function md_OnError(error) {
    alert(error);
}

function md_Message() {

    document.getElementById("md_addagg_stamppapercost").value = '';
    document.getElementById("md_addagg_version").selectedIndex = 0;
    document.getElementById("md_addagg_years").selectedIndex = 0;
    document.getElementById("md_agg_agreementdate").value = '';
    document.getElementById("md_agg_expirydate").value = '';
    document.getElementById("md_addagg_stamppaperused").selectedIndex = 0;
    document.getElementById("md_addagg_stamppaperno").value = '';
    document.getElementById("md_addagg_fileno").value = '';
    document.getElementById("md_agg_ackdate").value = '';
    document.getElementById("md_addagg_remark").value = '';

    document.getElementById("md_agrclause_version").selectedIndex = 0;
    document.getElementById("md_agrclause_clause").selectedIndex = 0;
    document.getElementById("md_agrclause_clauseno").value = '';
    document.getElementById("md_agrclause_penalty").value = '';

    document.getElementById("md_addaddendum_employeeid").value = '';
    document.getElementById("md_addadm_stamppaperno").value = '';
    document.getElementById("md_addadm_signeddate").value = '';
    document.getElementById("md_addadm_ackdate").value = '';
    document.getElementById("md_addadm_cost").value = '';
    document.getElementById("md_addadm_remark").value = '';
    document.getElementById("md_addadm_version").selectedIndex = 0;

    document.getElementById("md_addmclause_clauseno").value = '';
    document.getElementById("md_addmclause_penalty").value = '';
    document.getElementById("md_addmclause_version").selectedIndex = 0;
    document.getElementById("md_addmclause_clause").selectedIndex = 0;

    document.getElementById("md_clilst_signdate").value = '';
    document.getElementById("md_clilst_remark").value = '';
    document.getElementById("md_clilst_version").selectedIndex = 0;

    document.getElementById("md_addpseudoname_ackdate").value = '';
    document.getElementById("md_addpseudoname_penalty").value = '';
    document.getElementById("md_addpseudoname_remark").value = '';

    document.getElementById("md_addundertaking_signdate").value = '';
    document.getElementById("md_addundertaking_stampno").value = '';
    document.getElementById("md_addundertaking_cost").value = '';
    document.getElementById("md_addundertaking_remark").value = '';
    document.getElementById("md_addundertaking_version").selectedIndex = 0;

    document.getElementById("md_filetracker_fileNo").value = '';

    document.getElementById("md_usvisano").value = '';
    document.getElementById("md_usvisa_validdate").value = '';

    document.getElementById("md_scannedcopy_scancopy").selectedIndex = 0;

    $('#md_dverror').modal('hide');

    $("#addagreement").modal("hide");
    $("#agreementclause").modal("hide");
    $("#addaddendum").modal("hide");
    $("#addaddendumclause").modal("hide");
    $("#addclientlist").modal("hide");
    $("#addpseudoname").modal("hide");
    $("#addundertaking").modal("hide");
    $("#filetracker").modal("hide");
    $("#usvisa").modal("hide");
    $("#scannedcopy").modal("hide");
    $("#agreementhistory").modal("hide");
    $("#agreementhistory").modal("hide");
    $("#clientlisthistory").modal("hide");

    md_BindMasterData();
}

//<tr>
//    <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Sr. #</th>
//    <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">EmployeeID</th>
//    <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Code</th>
//    <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Name</th>
//    <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Salary</th>
//    <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Joining Date</th>
//    <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Date Of Birth</th>
//    <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Branch</th>
//    <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Department</th>
//    <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Designation</th>
//    <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Domain</th>
//    <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Subdomain</th>
//    <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Reporting Manager</th>
//    <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Domain Head</th>
//    <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Contact #</th>
//    <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Email Address</th>
//    <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Present Address</th>
//    <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Permanent Address</th>
//    <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">UAN</th>
//    <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">ESIC #</th>
//    <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Latest Login Date</th>
//    <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Current Status</th>
//    <th class="sort border-top ps-3" style="vertical-align: middle;" rowspan="3">Productivity/Task</th>

//    <%--Agreement 2017--%>
//    <th class="sort border-top ps-3" rowspan="2">Version</th>
//    <th class="sort border-top ps-3" rowspan="2">Agreement Date</th>
//    <th class="sort border-top ps-3" rowspan="2">Expiry Date</th>
//    <th class="sort border-top ps-3" rowspan="2">Stamp Paper #</th>


//    <%--Agreement 2018--%>
//    <th class="sort border-top ps-3" rowspan="2">Version</th>
//    <th class="sort border-top ps-3" rowspan="2">Agreement Date</th>
//    <th class="sort border-top ps-3" rowspan="2">Expiry Date</th>
//    <th class="sort border-top ps-3" rowspan="2">Stamp Paper #</th>

//    <%--Agreement 2019--%>
//    <th class="sort border-top ps-3" rowspan="2">Version</th>
//    <th class="sort border-top ps-3" rowspan="2">Agreement Date</th>
//    <th class="sort border-top ps-3" rowspan="2">Expiry Date</th>
//    <th class="sort border-top ps-3" rowspan="2">Stamp Paper #</th>

//    <%--Agreement 1.1--%>
//    <th class="sort border-top ps-3" rowspan="2">Version</th>
//    <th class="sort border-top ps-3" rowspan="2">Agreement Date</th>
//    <th class="sort border-top ps-3" rowspan="2">Expiry Date</th>
//    <th class="sort border-top ps-3" rowspan="2">Stamp Paper #</th>

//    <%--Agreement 2--%>
//    <th class="sort border-top ps-3" rowspan="2">Version</th>
//    <th class="sort border-top ps-3" rowspan="2">Agreement Date</th>
//    <th class="sort border-top ps-3" rowspan="2">Expiry Date</th>
//    <th class="sort border-top ps-3" rowspan="2">Stamp Paper #</th>

//    <%--Agreement 2.8.5--%>
//    <th class="sort border-top ps-3" rowspan="2">Version</th>
//    <th class="sort border-top ps-3" rowspan="2">Agreement Date</th>
//    <th class="sort border-top ps-3" rowspan="2">Expiry Date</th>
//    <th class="sort border-top ps-3" rowspan="2">Stamp Paper #</th>
//    <th class="sort border-top ps-3">Clause #</th>
//    <th class="sort border-top ps-3">Penalty for breaching clause</th>
//    <th class="sort border-top ps-3">Clause #</th>
//    <th class="sort border-top ps-3">Penalty for breaching clause</th>
//    <th class="sort border-top ps-3">Clause #</th>
//    <th class="sort border-top ps-3">Penalty for breaching clause</th>
//    <th class="sort border-top ps-3">Minimum service commitment upto (Years)</th>

//    <%--Agreement 2.9--%>
//    <th class="sort border-top ps-3" rowspan="2">Version</th>
//    <th class="sort border-top ps-3" rowspan="2">Agreement Date</th>
//    <th class="sort border-top ps-3" rowspan="2">Expiry Date</th>
//    <th class="sort border-top ps-3" rowspan="2">Stamp Paper #</th>
//    <th class="sort border-top ps-3">Clause #</th>
//    <th class="sort border-top ps-3">Penalty for breaching claus
//        <th class="sort border-top ps-3">Clause #</th>
//        <th class="sort border-top ps-3">Penalty for breaching clause</th>
//        <th class="sort border-top ps-3">Clause #</th>
//        <th class="sort border-top ps-3">Penalty for breaching clause</th>
//        <th class="sort border-top ps-3">Minimum service commitment upto (Years)</th>

//        <%--Agreement 3.0--%>
//        <th class="sort border-top ps-3" rowspan="2">Version</th>
//        <th class="sort border-top ps-3" rowspan="2">Agreement Date</th>
//        <th class="sort border-top ps-3" rowspan="2">Expiry Date</th>
//        <th class="sort border-top ps-3" rowspan="2">Stamp Paper #</th>
//        <th class="sort border-top ps-3">Clause #</th>
//        <th class="sort border-top ps-3">Penalty for breaching clause</th>
//        <th class="sort border-top ps-3">Clause #</th>
//        <th class="sort border-top ps-3">Penalty for breaching clause</th>
//        <th class="sort border-top ps-3">Clause #</th>
//        <th class="sort border-top ps-3">Penalty for breaching clause</th>
//        <th class="sort border-top ps-3">Minimum service commitment upto (Years)</th>

//        <%--Add Agreement Details, clause and History details--%>
//        <th style="width: 50px;"></th>

//        <%--View agreement history--%>
//        <th style="width: 50px;"></th>

//        <%--Add Agreement clause--%>
//        <th style="width: 50px;"></th>

//        <%--Addendum 1.0--%>
//        <th class="sort border-top ps-3" rowspan="2">Version</th>
//        <th class="sort border-top ps-3" rowspan="2">Signed Date</th>
//        <th class="sort border-top ps-3" rowspan="2">Stamp Paper #</th>
//        <th class="sort border-top ps-3">Clause #</th>
//        <th class="sort border-top ps-3">Penalty for breaching clause</th>
//        <th class="sort border-top ps-3">Clause #</th>
//        <th class="sort border-top ps-3">Penalty for breaching clause</th>
//        <th class="sort border-top ps-3">Clause #</th>
//        <th class="sort border-top ps-3">Penalty for breaching clause</th>
//        <th class="sort border-top ps-3">Minimum service commitment upto (Years)</th>

//        <%--Addendum 2.0--%>
//        <th class="sort border-top ps-3" rowspan="2">Version</th>
//        <th class="sort border-top ps-3" rowspan="2">Signed Date</th>
//        <th class="sort border-top ps-3" rowspan="2">Stamp Paper #</th>
//        <th class="sort border-top ps-3">Clause #</th>
//        <th class="sort border-top ps-3">Penalty for breaching clause</th>
//        <th class="sort border-top ps-3">Clause #</th>
//        <th class="sort border-top ps-3">Penalty for breaching clause</th>
//        <th class="sort border-top ps-3">Clause #</th>
//        <th class="sort border-top ps-3">Penalty for breaching clause</th>
//        <th class="sort border-top ps-3">Minimum service commitment upto (Years)</th>

//        <%--Addendum 2.5--%>
//        <th class="sort border-top ps-3" rowspan="2">Version</th>
//        <th class="sort border-top ps-3" rowspan="2">Signed Date</th>
//        <th class="sort border-top ps-3" rowspan="2">Stamp Paper #</th>
//        <th class="sort border-top ps-3">Clause #</th>
//        <th class="sort border-top ps-3">Penalty for breaching clause</th>
//        <th class="sort border-top ps-3">Clause #</th>
//        <th class="sort border-top ps-3">Penalty for breaching clause</th>
//        <th class="sort border-top ps-3">Clause #</th>
//        <th class="sort border-top ps-3">Penalty for breaching clause</th>
//        <th class="sort border-top ps-3">Minimum service commitment upto (Years)</th>

//        <%--Add Addendum Details, clause and History details--%>
//        <th style="width: 50px;"></th>

//        <%--Add Addendum clause--%>
//        <th style="width: 50px;"></th>

//        <%--Client List--%>
//        <th class="sort border-top ps-3" rowspan="2">Version</th>
//        <th class="sort border-top ps-3" rowspan="2">Status</th>
//        <th style="width: 50px;"></th>
//        <th style="width: 50px;"></th>

//        <%--Pseudoname--%>
//        <th class="sort border-top ps-3" rowspan="2">Pseudoname</th>
//        <th class="sort border-top ps-3" rowspan="2">Agreement Status</th>
//        <th class="sort border-top ps-3" rowspan="2">Acknowledgement Date</th>
//        <th class="sort border-top ps-3" rowspan="2">Penalty for Breach - Pseudoname Undertaking</th>
//        <th style="width: 50px;"></th>

//        <%--Undertaking--%>
//        <th class="sort border-top ps-3" rowspan="2">Version</th>
//        <th class="sort border-top ps-3" rowspan="2">Signed Date</th>
//        <th class="sort border-top ps-3" rowspan="2">Stamp Paper #</th>
//        <th class="sort border-top ps-3" rowspan="2">Cost</th>
//        <th style="width: 50px;"></th>

//        <%--File Tracker--%>
//        <th class="sort border-top ps-3" rowspan="2">File #</th>
//        <th style="width: 50px;"></th>

//        <%--US Visa--%>
//        <th class="sort border-top ps-3" rowspan="2">Visa #</th>
//        <th class="sort border-top ps-3" rowspan="2">Valid Till</th>
//        <th style="width: 50px;"></th>

//        <%--Scanned Copy--%>
//        <th class="sort border-top ps-3" rowspan="2">Is Scanned Copy Updated?</th>
//        <th style="width: 50px;"></th>
//                        </tr>