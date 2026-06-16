var AV_table;
var userID;
var selectedrow;
var html = '';
var VerIDs;
var Ver_empids;
var addVefSummary_table;
var addVefSummary_html;

function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

function BindYear() {
    var start = new Date().getFullYear();

    var select = document.getElementById("AV_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#AV_year").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#AV_year").append($("<option></option>").val(i).html(i));
    }
}

function bind_addressverficationSummary(Month, Year) {

    $('#load1').show();
    addVefSummary_html = '';
    $.ajax({
        url: "AddressVerification.aspx/GetAddressVerificationDataForSummary",
        data: "{Month:'" + Month + "', Year:'" + Year + "'}",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);
            $.each(dataArray, function (index, value) {
                addVefSummary_html += '<tr>';
                addVefSummary_html += '<td style="text-wrap: nowrap;text-align:center;">' + blankForNull((index + 1)) + '</td>';
                addVefSummary_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.BranchName) + '</td>';
                addVefSummary_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.Total) + '</td>';
                addVefSummary_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.Completed) + '</td>';
                addVefSummary_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.Pending) + '</td>';
                addVefSummary_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#table_addVefSummary')) {
                addVefSummary_table.destroy();
            }
            $('#table_addVefSummary tbody').html(addVefSummary_html);
            addVefSummary_table = $('#table_addVefSummary').DataTable({
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
                buttons: [

                    {
                        extend: 'excelHtml5', title: 'Address Verification Summary', autoFilter: true,
                        exportOptions: {
                            columns: [3, 4, 5, 6, 7, 8, 9, 10, 11]
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
    return false;
}

function AddRemark(VerID, Index) {
    var row = AV_table.row(Index).data();
    VerIDs = VerID;
    Ver_empids = row[1];
    document.getElementById("spn_updatedetailsName").innerHTML = "Update Courier Details - " + row[3] + " : " + row[4];
    $('#updatedetails').modal('show');
}

function AddAttachment(VerID, Index) {
    var row = AV_table.row(Index).data();
    VerIDs = VerID;
    Ver_empids = row[1];
    // document.getElementById("AV_empname2").innerHTML = row[4];
    var actualdate = '';
    if (row[9] != "") {
        var newtodate = new Date(row[9]);
        var day = newtodate.getDate();
        if (day < 10)
            day = '0' + day
        var month = newtodate.getMonth() + 1;
        if (month < 10)
            month = '0' + month
        var year = newtodate.getFullYear();
        actualdate = year + "-" + (month) + "-" + (day);
    }
    else
        actualdate = '';

    document.getElementById("spn_updatedetailsdocs").innerHTML = "Update Courier Details - " + row[3] + " : " + row[4];

    document.getElementById("AV_verificationdate2").value = actualdate;
    document.getElementById("AV_courier2").value = row[10];
    document.getElementById("AV_remark2").value = row[11];
    $('#uploaddocument').modal('show');
}

function AddressVerification_Submit() {
    var ddlmonth = document.getElementById("AV_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("AV_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }

    bind_addressverficationSummary(month, year);

    $('#load1').show();
    html = '';
    $.ajax({
        url: "AddressVerification.aspx/GetVerificationRecords",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {

                //  alert(value.Attachment.substring(value.Attachment.indexOf("EmployeeDocuments")));

                html += '<tr>';
                html += '<td style="display:none;">' + value.VerID + '</td>';
                html += '<td style="display:none;">' + value.EmployeeID + '</td>';
                html += '<td class=""><div class="btn-group">';
                html += '<div class="btn-group">';
                html += '<div type="button" data-toggle="dropdown" aria-expanded="false"><i style="color: dodgerblue; font-size:14px;" class="uil fs-0 me-2 uil-cog"></i>';
                html += '<span class="sr-only"></span></div><div class="dropdown-menu" role="menu" style="">';
                html += '<a class="dropdown-item" href="#!" id="Actions" onclick="AddRemark(' + value.VerID + ',' + index + ',1);"><span style="color: forestgreen;"><i class="uil fs-0 me-2 uil-pen"></i></span>&nbsp;&nbsp;Update Remark</a>';
                html += '<a class="dropdown-item" href="#!" id="ActionsEx" onclick="AddAttachment(' + value.VerID + ',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-file"></i></span>&nbsp;&nbsp;Upload Attachment</a><div class="dropdown-divider"></div>';
                //html += '<a class="dropdown-item" href="#!" id="ActionsEx" onclick="DownloadAV(' + value.VerID + ',' + index + ');"><span style="color: brown;"><i class="uil fs-0 me-2 uil-download-alt"></i></span>&nbsp;&nbsp;Download Attachment</a></div></div></td > ';
                if (value.Attachment != null)
                    html += '<a class="dropdown-item" target="_blank" href="../' + value.Attachment.substring(value.Attachment.indexOf("EmployeeDocuments")) + '" id="DownloadAtt"><span style="color: brown;"><i class="uil fs-0 me-2 uil-download-alt"></i></span>&nbsp;&nbsp;Download Attachment</a></div></div></td > ';
                else
                    html += '<a class="dropdown-item" href="#url" id="DownloadAtt"><span style="color: brown;"><i class="uil fs-0 me-2 uil-download-alt"></i></span>&nbsp;&nbsp;Download Attachment</a></div></div></td> ';


                //html += '<td class="align-middle white-space-nowrap pe-0"><div class="font-sans-serif btn-reveal-trigger position-static">';
                //html += '<button class="btn btn-sm dropdown-toggle dropdown-caret-none transition-none btn-reveal fs--2" type="button" data-bs-toggle="dropdown" data-boundary="window" aria-haspopup="true" aria-expanded="false" data-bs-reference="parent">';
                //html += '<span style="color: Mediumslateblue;"><i class="fa-solid fa-cog"></i></span></button><div class="dropdown-menu dropdown-menu-end py-2" style="">';
                //html += '<a class="dropdown-item" href="#!" id="Actions" onclick="AddRemark(' + value.AppId + ',' + index + ');"><span style="color: forestgreen;"><i class="fa-solid fa-pen"></i></span>&nbsp;&nbsp;Add Remark</a>';
                //html += '<a class="dropdown-item" href="#!" id="ActionsEx" onclick="ViewApplication(' + value.AppId + ',' + index + ');"><span style="color: dodgerblue;"><i class="fa-solid fa-eye"></i></span>&nbsp;&nbsp;View Application</a>';
                //html += '</div></div></td>';

                html += '<td>' + blankForNull(value.Code) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Name) + '</td>';
                html += '<td>' + blankForNull(value.JoiningDate) + '</td>';
                html += '<td>' + blankForNull(value.BranchName) + '</td>';
                html += '<td>' + blankForNull(value.CellNo) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.PermenentAddress) + '</td>';
                html += '<td>' + blankForNull(value.VerificationDate) + '</td>';
                html += '<td>' + blankForNull(value.CourierNo) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Remark) + '</td>';
                html += '<td style="display:none;">' + blankForNull(value.Attachment) + '</td>';
                html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#addressVerification')) {
                AV_table.destroy();
            }
            $('#addressVerification tbody').html(html);
            //else
            AV_table = $('#addressVerification').DataTable({
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
                    //document.getElementById("filterboxrow").style.display = '';
                    $('#load1').hide();
                    //this.api()
                    //    .columns()
                    //    .every(function () {
                    //        let column = this;
                    //        let title = column.header().textContent;

                    //        // Create input element
                    //        let input = document.createElement('input');
                    //        input.placeholder = title;
                    //        input.className = "filterinput";
                    //        column.header().replaceChildren(input);

                    //        // Event listener for user input
                    //        input.addEventListener('keyup', () => {
                    //            if (column.search() !== this.value) {
                    //                column.search(input.value).draw();
                    //            }
                    //        });
                    //    });

                },
                "rowCallback": function (row, data) {
                    // Cell at index 5 in the row is 'Active'.
                    var val = data[3];
                },

                buttons: [

                    {
                        extend: 'excelHtml5', title: 'Address Verification', autoFilter: true,
                        exportOptions: {
                            columns: [3, 4, 5, 6, 7, 8, 9, 10, 11]
                        }

                    },

                ],

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

function AV_UpdateRemark() {
    var AV_verificationdate = document.getElementById("AV_verificationdate").value;
    var AV_courier1 = document.getElementById("AV_courier1").value;
    var AV_remark1 = document.getElementById("AV_remark1").value;
    PageMethods.InsertVerificationRemark(Ver_empids, AV_verificationdate, AV_courier1, AV_remark1, AV_OnSuccess, AV_OnError);
    VerIDs = '';
    return false;
}

function AV_OnSuccess(result) {
    if (result > 0) {
        alert('Remark updated successfully!');
    }
    else {
        alert('Error occured while updating remark!');
    }
    location.reload();
    return false;
}

function AV_OnError(error) {
    alert(error);
}

function AV_uploaddocument() {
    var AV_verificationdate = document.getElementById("AV_verificationdate2").value;
    var AV_courier1 = document.getElementById("AV_courier2").value;
    var AV_remark1 = document.getElementById("AV_remark2").value;
    PageMethods.InsertVerificationDocument(Ver_empids, AV_verificationdate, AV_courier1, AV_remark1, AV_OnSuccess, AV_OnError);
    VerIDs = '';
    return false;
}

const getFileName = (event) => {
    const files = event.target.files;
    var file = files[0];
    document.getElementById("filep").value = files[0].name;

    const fd = new FormData();

    // add all selected files
    fd.append(event.target.name, file, file.name);
    // create the request
    const xhr = new XMLHttpRequest();

    xhr.onload = () => {
        if (xhr.status >= 200 && xhr.status < 300) {
            // we done!
        }
    };
    var url = window.location.href;
    // path to server would be where you'd normally post the form to
    xhr.open('POST', url, true);
    xhr.send(fd);
    document.getElementById("dropzone").classList.add("dz-max-files-reached");
    document.getElementById("conentdiv").style.display = '';
    document.getElementById("filesdiv").innerHTML = file.name;
}
