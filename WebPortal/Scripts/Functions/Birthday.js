var Birthday_Table = null;
var Birthday_Rows = [];
var Birthday_SelectedEmployeeId = 0;
var Birthday_SelectedEmployee = null;

function Birthday_Init() {
    if (!$("#bdash_list").length) {
        return;
    }

    $("#bd_btnRefresh").off("click.birthday").on("click.birthday", function () {
        Birthday_LoadBirthdays(true);
    });

    $("#bd_tableSearch").off("input.birthday").on("input.birthday", function () {
        if (Birthday_Table) {
            Birthday_Table.search(this.value).draw();
        }
    });

    $("#bd_btnSend").off("click.birthday").on("click.birthday", function () {
        Birthday_SendWish();
    });

    $("#txtWish").off("keydown.birthday").on("keydown.birthday", function (event) {
        if (event.key === "Enter") {
            event.preventDefault();
            Birthday_SendWish();
        }
    });

    Birthday_LoadBirthdays(false);
}

function Birthday_LoadBirthdays(isManualRefresh) {
    Birthday_SetLoader(true);

    $.ajax({
        url: "Birthday.aspx/GetAllBirthdays",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            Birthday_Rows = Birthday_ParseJson(data.d, []);
            Birthday_RenderTable(Birthday_Rows);
            Birthday_UpdateBirthdayCount(Birthday_Rows.length);
            Birthday_SelectInitialEmployee();

            if (isManualRefresh) {
                Birthday_Toast("success", "Birthday list refreshed");
            }
        },
        error: function (xhr) {
            Birthday_Message("error", "Unable to load birthdays", Birthday_AjaxError(xhr));
        },
        complete: function () {
            Birthday_SetLoader(false);
        }
    });

    return false;
}

function Birthday_RenderTable(rows) {
    if ($.fn.DataTable.isDataTable("#bdash_list")) {
        Birthday_Table.clear().rows.add(rows).draw();
        return;
    }

    Birthday_Table = $("#bdash_list").DataTable({
        data: rows,
        dom: "rt<'row align-items-center mt-2'<'col-sm-5'i><'col-sm-7'p>>",
        scrollX: true,
        paging: true,
        pageLength: 10,
        autoWidth: false,
        ordering: false,
        processing: true,
        deferRender: true,
        language: {
            emptyTable: "No birthdays found for today.",
            info: "Showing _START_ to _END_ of _TOTAL_ birthdays",
            infoEmpty: "No birthdays available",
            paginate: {
                previous: "Previous",
                next: "Next"
            }
        },
        columns: [
            {
                data: null,
                className: "text-center",
                render: function (data, type, row, meta) {
                    return meta.row + 1;
                }
            },
            {
                data: "EmployeeID",
                className: "text-center",
                render: function (employeeId) {
                    return '<button type="button" class="bd-view-btn" title="View wishes" onclick="return Birthday_SelectEmployee(' + Number(employeeId || 0) + ');"><i class="fas fa-eye"></i></button>';
                }
            },
            { data: "EmployeeID", visible: false, render: Birthday_RenderText },
            { data: "Code", render: Birthday_RenderText },
            {
                data: null,
                render: function (row) {
                    var name = Birthday_Normalize(row.Name);
                    var code = Birthday_Normalize(row.Code);
                    // return '<div class="bd-person"><span class="bd-avatar">' + Birthday_Escape(Birthday_GetInitials(name || code)) + '</span><div><strong>' + Birthday_Escape(name || "-") + '</strong><span>' + Birthday_Escape(code || "") + '</span></div></div>';
                    return '<div class="bd-person">' + '</span><div><strong>' + Birthday_Escape(name || "-") + '</strong></div></div>';

                }
            },
            { data: "DateOfBirth", render: Birthday_RenderDate },
            { data: "BranchName", render: Birthday_RenderBadge },
            { data: "DepartmentName", render: Birthday_RenderText },
            { data: "DesignationName", render: Birthday_RenderText },
            { data: "ReportingManager", render: Birthday_RenderText }
        ],
        columnDefs: [{
            targets: "_all",
            className: "text-nowrap"
        }],
        rowCallback: function (row, data) {
            $(row).toggleClass("is-selected", Number(data.EmployeeID) === Number(Birthday_SelectedEmployeeId));
        },
        drawCallback: function () {
            Birthday_UpdateRecordCount(this.api().rows({ search: "applied" }).count());
        }
    });

    $("#bdash_list tbody").off("click.birthday").on("click.birthday", "tr", function (event) {
        if ($(event.target).closest("button").length) {
            return;
        }

        var row = Birthday_Table.row(this).data();
        if (row && row.EmployeeID) {
            Birthday_SelectEmployee(row.EmployeeID);
        }
    });
}

function Birthday_SelectInitialEmployee() {
    var employeeId = Number(new URLSearchParams(window.location.search).get("EmployeeID") || 0);

    if (!employeeId && Birthday_SelectedEmployeeId) {
        employeeId = Birthday_SelectedEmployeeId;
    }

    if (!employeeId && Birthday_Rows.length) {
        employeeId = Number(Birthday_Rows[0].EmployeeID || 0);
    }

    if (employeeId) {
        Birthday_SelectEmployee(employeeId, true);
        return;
    }

    Birthday_ResetSelection();
}

function Birthday_SelectEmployee(employeeId, skipHistory) {
    Birthday_SelectedEmployeeId = Number(employeeId || 0);
    Birthday_SelectedEmployee = Birthday_FindEmployee(Birthday_SelectedEmployeeId);

    if (!Birthday_SelectedEmployeeId) {
        Birthday_ResetSelection();
        return false;
    }

    Birthday_UpdateSelectedCard(Birthday_SelectedEmployee);

    if (Birthday_Table) {
        Birthday_Table.rows().invalidate("data").draw(false);
    }

    if (!skipHistory && window.history && window.history.replaceState) {
        window.history.replaceState(null, "", "Birthday.aspx?EmployeeID=" + Birthday_SelectedEmployeeId);
    }

    Birthday_LoadMessages(Birthday_SelectedEmployeeId);
    return false;
}

function Birthday_ResetSelection() {
    Birthday_SelectedEmployeeId = 0;
    Birthday_SelectedEmployee = null;
    $("#bd_selectedAvatar").text("BD");
    $("#bd_selectedName").text("Select a birthday");
    // $("#bd_selectedMeta").text("Messages will appear here.");
    $("#bd_selectedEmployee").text("None");
    $("#bd_totalMessages").text("0");
    $("#dvMessages").html('<div class="bd-empty"><i class="fas fa-gift"></i>Select an employee to view birthday wishes.</div>');
}

function Birthday_UpdateSelectedCard(employee) {
    var name = employee ? Birthday_Normalize(employee.Name) : "";
    var code = employee ? Birthday_Normalize(employee.Code) : "";
    var department = employee ? Birthday_Normalize(employee.DepartmentName) : "";
    var designation = employee ? Birthday_Normalize(employee.DesignationName) : "";

    $("#bd_selectedAvatar").text(code);
    $("#bd_selectedName").text(name || "Selected birthday");
    // $("#bd_selectedMeta").text([code, department, designation].filter(Boolean).join(" | "));
    $("#bd_selectedEmployee").text(name || code || "Selected");
}

function Birthday_LoadMessages(employeeId) {
    Birthday_SetLoader(true);

    $.ajax({
        url: "Birthday.aspx/GetAllBirthdayMessages",
        type: "POST",
        data: JSON.stringify({ EmployeeID: Number(employeeId || 0) }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var messages = Birthday_ParseJson(data.d, []);
            Birthday_RenderMessages(messages);
            $("#bd_totalMessages").text(messages.length);
        },
        error: function (xhr) {
            Birthday_Message("error", "Unable to load wishes", Birthday_AjaxError(xhr));
        },
        complete: function () {
            Birthday_SetLoader(false);
        }
    });
}

function Birthday_RenderMessages(messages) {
    if (!messages.length) {
        $("#dvMessages").html('<div class="bd-empty"><i class="fas fa-envelope-open-text"></i>No birthday messages yet.</div>');
        return;
    }

    var html = '<div class="bd-message-list">';
    $.each(messages, function (index, message) {
        html += '<article class="bd-message-card">'
            + '<div class="bd-message-head">'
            + '<strong><i class="fas fa-user-tie"></i> ' + Birthday_Escape(Birthday_Normalize(message.FromName) || "Colleague") + '</strong>'
            + '<span><i class="fas fa-clock"></i> ' + Birthday_Escape(Birthday_Normalize(message.AddedDate)) + '</span>'
            + '</div>'
            + '<p class="bd-message-text">' + Birthday_Escape(Birthday_Normalize(message.Message)) + '</p>'
            + '</article>';
    });
    html += '</div>';

    $("#dvMessages").html(html);
}

function Birthday_SendWish() {
    var message = Birthday_Normalize($("#txtWish").val());

    if (!Birthday_SelectedEmployeeId) {
        Birthday_Message("warning", "Select birthday", "Please select an employee before sending a wish.");
        return false;
    }

    if (!message) {
        Birthday_Message("warning", "Birthday wish required", "Please write a birthday wish before sending.");
        $("#txtWish").focus();
        return false;
    }

    Birthday_SetSendBusy(true);

    $.ajax({
        type: "POST",
        url: "Birthday.aspx/SendBirthdayWish",
        data: JSON.stringify({
            message: message,
            EmployeeID: Birthday_SelectedEmployeeId
        }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function () {
            $("#txtWish").val("");
            Birthday_Toast("success", "Wish sent");
            Birthday_LoadMessages(Birthday_SelectedEmployeeId);
        },
        error: function (xhr) {
            Birthday_Message("error", "Failed to send", Birthday_AjaxError(xhr));
        },
        complete: function () {
            Birthday_SetSendBusy(false);
        }
    });

    return false;
}

function Birthday_FindEmployee(employeeId) {
    var id = Number(employeeId || 0);
    for (var i = 0; i < Birthday_Rows.length; i++) {
        if (Number(Birthday_Rows[i].EmployeeID) === id) {
            return Birthday_Rows[i];
        }
    }
    return null;
}

function Birthday_UpdateBirthdayCount(count) {
    $("#bd_totalBirthdays").text(count || 0);
}

function Birthday_UpdateRecordCount(count) {
    var label = count === 1 ? "birthday" : "birthdays";
    $("#bd_recordCount").text((count || 0) + " " + label);
}

function Birthday_SetLoader(isVisible) {
    $("#load1").css("display", isVisible ? "flex" : "none");
}

function Birthday_SetSendBusy(isBusy) {
    $("#bd_btnSend")
        .prop("disabled", isBusy)
        .html(isBusy
            ? '<i class="fas fa-spinner fa-spin"></i><span>Sending</span>'
            : '<i class="fas fa-paper-plane"></i><span>Send</span>');
}

function Birthday_Message(icon, title, text) {
    if (window.Swal && Swal.fire) {
        return Swal.fire({
            icon: icon || "info",
            title: title || "Information",
            text: text || "",
            confirmButtonText: "OK",
            confirmButtonColor: "#2563eb",
            heightAuto: false
        });
    }

    alert((title ? title + "\n" : "") + (text || ""));
}

function Birthday_Toast(icon, title) {
    if (window.Swal && Swal.mixin) {
        var toast = Swal.mixin({
            toast: true,
            position: "top-end",
            showConfirmButton: false,
            timer: 1800,
            timerProgressBar: true,
            heightAuto: false
        });
        toast.fire({ icon: icon || "success", title: title || "Done" });
        return;
    }
}

function Birthday_ParseJson(value, fallback) {
    if (value === null || value === undefined || value === "") {
        return fallback;
    }

    if (typeof value !== "string") {
        return value;
    }

    try {
        return JSON.parse(value);
    }
    catch (ex) {
        return fallback;
    }
}

function Birthday_AjaxError(xhr) {
    if (xhr && xhr.responseJSON && xhr.responseJSON.Message) {
        return xhr.responseJSON.Message;
    }

    if (xhr && xhr.responseText) {
        var parsed = Birthday_ParseJson(xhr.responseText, null);
        if (parsed && parsed.Message) {
            return parsed.Message;
        }
    }

    return "Something went wrong. Please try again.";
}

function Birthday_RenderText(data) {
    return Birthday_Escape(Birthday_Normalize(data) || "-");
}

function Birthday_RenderBadge(data) {
    var value = Birthday_Normalize(data);
    return value ? '<span class="bd-badge">' + Birthday_Escape(value) + '</span>' : "-";
}

function Birthday_RenderDate(data) {
    return Birthday_Escape(Birthday_Normalize(data) || "-");
}

function Birthday_GetInitials(value) {
    var text = Birthday_Normalize(value);
    if (!text) {
        return "BD";
    }

    var parts = text.split(/\s+/).filter(Boolean);
    if (parts.length === 1) {
        return parts[0].substring(0, 2).toUpperCase();
    }

    return (parts[0].charAt(0) + parts[parts.length - 1].charAt(0)).toUpperCase();
}

function Birthday_Normalize(value) {
    if (value === null || value === undefined || value === "null") {
        return "";
    }

    return String(value).trim();
}

function Birthday_Escape(value) {
    return Birthday_Normalize(value)
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#39;");
}
