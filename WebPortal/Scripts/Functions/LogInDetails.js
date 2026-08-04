

var PMCode;
var html;
var logtable;
var edittable;
var global_code;

console.log('test');


function New_BindLogGrid(date, PMCode) {

    console.log(PMCode);

    $('#load1').show();

    $.ajax({
        url: "LogInDetails.aspx/BindLogGrid",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            Code: PMCode,
            Date: date
        }),

        success: function (data) {

            let dataArray = JSON.parse(data.d);
            let html = "";

            const allowedUsers = [12, 7036, 216, 8082, 285, 255, 291, 8535, 277, 9738, 99, 9858];

            let pm_Code = Number(PMCode);

            $.each(dataArray, function (index, value) {

                if (value.code === 'ZCM')
                    alert(value.ACTIVE)

                /* =========================
                   SAFE VALUES
                ========================= */

                let cotValue = value.COT || "";
                let activeValue = value.ACTIVE || "";

                /* =========================
                   STATUS DESIGN
                ========================= */

                //if (activeValue === "Abscond")
                //    alert('message');

                let statusClass = "";
                let statusText = "";

                if (activeValue === "Block") {

                    statusClass = "badge-block";
                    statusText = "Blocked";
                }
                else if (activeValue === "Abscond") {

                    statusClass = "badge-abscond";
                    statusText = "Absconded";
                }
                else if (activeValue === "Leave") {

                    statusClass = "badge-leave";
                    statusText = "On Leave";
                }
                else if (cotValue.toLowerCase().includes("awaited")) {

                    statusClass = "badge-await";
                    statusText = "Awaited";
                }

                else {

                    statusClass = "badge-active";
                    statusText = "Active";
                }

                /* =========================
                   ACTION BUTTONS
                ========================= */

                let actionHtml = `
                    <div class="dropdown">
                        <div type="button"
                             data-toggle="dropdown"
                             aria-expanded="false"
                             style="cursor:pointer; display:inline-block;">

                            <i style="color:dodgerblue;font-size:14px;"
                               class="uil fs-0 me-2 uil-cog"></i>

                            <span class="sr-only"></span>
                        </div>

                        <div class="dropdown-menu" role="menu">
                `;

                if (allowedUsers.includes(pm_Code)) {

                    if (activeValue === "Block" || activeValue === "Abscond") {

                        actionHtml += `
                            <a class="dropdown-item"
                               href="#!"
                               onclick="block('${value.code}','${value.name}','${value.LastLoginDate}',${index},0);">

                                Activate ERP Login
                            </a>
                        `;
                    }
                    else {

                        actionHtml += `
                            <a class="dropdown-item"
                               href="#!"
                               onclick="block('${value.code}','${value.name}','${value.LastLoginDate}',${index},1);">

                                Block ERP Login
                            </a>
                        `;
                    }
                }
                else {

                    actionHtml += `
                        <a class="dropdown-item disabled" href="#!">
                            No Permission
                        </a>
                    `;
                }

                actionHtml += `<a class="dropdown-item" href="ViewLog.aspx?Code=${encodeURIComponent(value.code)}">View Log Details</a></div></div>`;

                /* =========================
                   TABLE ROW
                ========================= */

                html += `
                    <tr data-status="${statusText.toLowerCase()}">

                        <td>${index + 1}</td>

                        <td>${actionHtml}</td>

                        <td style="width:100px;">
                            <strong>${blankForNull(value.code)}</strong>
                        </td>

                        <td>${blankForNull(value.name)}</td>

                        <td>
                            <span class="badge badge-status ${statusClass}">
                                ${blankForNull(cotValue)}
                            </span>
                        </td>

                        <td>${blankForNull(value.in)}</td>

                        <td>${blankForNull(value.out)}</td>

                        <td>${blankForNull(value.LastLoginDate)}</td>

                        <td>${blankForNull(value.in_ip)}</td>

                        <td>${blankForNull(value.out_ip)}</td>

                        <td>
                            <span class="badge badge-status ${statusClass}">
                                ${statusText}
                            </span>
                        </td>
                    </tr>
                `;
            });

            /* =========================
               DESTROY OLD TABLE
            ========================= */

            if ($.fn.DataTable.isDataTable('#log')) {

                $('#log').DataTable().clear().destroy();
            }

            $('#log tbody').html(html);

            /* =========================
               INITIALIZE DATATABLE
            ========================= */

            let edittable = $('#log').DataTable({

                dom:
                    "<'row mb-3'<'col-md-2'l><'col-md-6 text-left'i><'col-md-3 text-right'f>>" +
                    "<'row'<'col-12'tr>>" +
                    "<'row mt-3'<'col-md-5'><'col-md-7'p>>",

                paging: true,
                searching: true,
                ordering: true,
                info: true,
                responsive: true,
                autoWidth: false,
                destroy: true,
                fixedHeader: true,
                pageLength: 10,

                columnDefs: [
                    {
                        targets: 0,
                        width: "50px"
                    },
                    {
                        targets: 1,
                        orderable: false,
                        width: "120px"
                    }
                ],

                language: {
                    search: "",
                    searchPlaceholder: "Search employee...",
                    lengthMenu: "Show _MENU_ Entries",
                    info: "Showing _START_ to _END_ of _TOTAL_ entries",
                    paginate: {
                        previous: "Prev",
                        next: "Next"
                    }
                },

                initComplete: function () {

                    $('#load1').hide();

                    /* =========================
                       STATUS FILTER
                    ========================= */

                    $('input[name="status"]').off('change').on('change', function () {

                        let selected = $(this).val();

                        if (selected === "all") {

                            edittable.column(10).search('').draw();
                        }
                        else if (selected === "active") {

                            edittable.column(10).search('Active').draw();
                        }
                        else if (selected === "awaited") {

                            edittable.column(10).search('Awaited').draw();
                        }
                        else if (selected === "leave") {

                            edittable.column(10).search('on Leave').draw();
                        }
                        else if (selected === "block") {

                            edittable.column(10).search('Blocked').draw();
                        }
                        else if (selected === "abscond") {

                            edittable.column(10).search('Absconded').draw();
                        }
                    });
                }
            });
        },

        error: function (error) {

            $('#load1').hide();

            alert('Error : ' + error.responseText);
        }
    });
}

function block(Code, name, logindate, Index, Type) {

    global_code = Code;

    if (Type == 1) {

        document.getElementById("blockunblockLabel").innerHTML = "Block ERP Login - " + Code + " : " + name;
        document.getElementById("btnApprove").innerHTML = "Block";
        document.getElementById("lblcurrentstatus").innerHTML = "Active";
        document.getElementById("lblcurrentstatus").style.color = "green";
    }
    else {

        document.getElementById("blockunblockLabel").innerHTML = "Activate ERP Login - " + Code + " : " + name;
        document.getElementById("btnApprove").innerHTML = "Activate";
        document.getElementById("lblcurrentstatus").innerHTML = "Blocked";
        document.getElementById("lblcurrentstatus").style.color = "red";
    }

    if (logindate != null && logindate.length > 0 && logindate != 'null')
        document.getElementById("lbllatestlogindate").innerHTML = logindate;

    $('#blockunblock').modal('show');
}

function setActions() {

    const status = $("#lblcurrentstatus").text().trim();
    const remark = $("#remark").val().trim();

    const tobestatus = status === "Active" ? "Blocked" : "Activated";
    const msgstatus = status === "Active" ? "block" : "activate";


    // Validation
    if (remark == "") {

        Swal.fire({ icon: 'warning', title: 'Remark Required', text: 'Please enter remark.' });
        return false;
    }

    if (remark.length < 10) {

        Swal.fire({ icon: 'warning', title: 'Invalid Remark', text: 'Remark should be at least 10 characters.' });
        return false;
    }

    // Confirmation
    Swal.fire({
        title: 'Confirm Action', text: `Do you want to ${msgstatus} profile?`, icon: 'question', showCancelButton: true, confirmButtonText: 'Yes',
        cancelButtonText: 'Cancel', confirmButtonColor: '#3085d6', cancelButtonColor: '#d33'
    }).then((result) => {

        if (!result.isConfirmed) return;
        Swal.fire({
            title: 'Please Wait...', text: 'Processing request and sending email notification.', allowOutsideClick: false, allowEscapeKey: false,
            didOpen: () => {
                Swal.showLoading();
            }
        });

        PageMethods.BlockUnblockLogin(global_code, tobestatus, remark,

            // Success
            function () {

                global_code = '';
                $("#remark").val('');

                $('#blockunblock').modal('hide');

                Swal.fire({ icon: 'success', title: 'Success', text: 'User status updated successfully.' });
            },

            // Error
            function () {

                global_code = '';

                Swal.fire({ icon: 'error', title: 'Failed', text: 'Something went wrong. Please try again.' });
            }
        );
    });

    return false;
}

function bindchangegrid(ddldate) {
    var date = ddldate.options[ddldate.selectedIndex].text;
    BindLogGrid(date);
}


function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}
