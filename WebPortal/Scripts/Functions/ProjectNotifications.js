var ProjectName = "";
let upnot_draggedLi = null;
let upnot_draggedItems = [];

/* ---------- Bind Methods ---------- */

function upnot_binddomains() {
    var select = document.getElementById("upnot_domain");
    var options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#upnot_domain").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "UserProjectNotifications.aspx/GetAllDomains", dataType: "json", contentType: "application/json",

        success: function (res) {
            var dataArray = JSON.parse(res.d)
            $.each(dataArray, function (data, value) {
                $("#upnot_domain").append($("<option></option>").val(value.DomainGroupId).html(value.DomainGroupName));
            })
        }

    });
}

function upnot_bindsubdomain() {

    var select = document.getElementById("upnot_subdomain");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    var ddlDomain = document.getElementById('upnot_domain');
    var index = ddlDomain.selectedIndex;
    var DomainGroupId = ddlDomain.options[index].value;

    $("#upnot_subdomain").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "UserProjectNotifications.aspx/GetSubdomains", dataType: "json", contentType: "application/json",
        data: "{DomainGroupId:" + DomainGroupId + "}",

        success: function (res) {

            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (data, value) {
                $("#upnot_subdomain").append($("<option></option>").val(value.DomainID).html(value.DomainName));
            })
        }

    });
}

function upnot_bindprojects() {

    let select = document.getElementById("upnot_Project");

    // Clear dropdown
    select.innerHTML = "";

    let ddlDomain = document.getElementById('upnot_subdomain');
    let DomainGroupId = ddlDomain.value;

    // Default option
    $("#upnot_Project").append($("<option></option>").val("").text("Select"));

    $.ajax({
        type: "POST",
        url: "UserProjectNotifications.aspx/GetDomainwiseProjects",
        dataType: "json",
        contentType: "application/json",
        data: JSON.stringify({ SubdomainID: DomainGroupId }),

        success: function (res) {

            let dataArray = JSON.parse(res.d);

            $.each(dataArray, function (i, value) {
                $("#upnot_Project").append($("<option></option>").val(value.ProjectID).html(value.ProjectName));
            });
        },

        error: function (err) {
            console.error("Error loading projects:", err);
        }
    });
}

function upnot_binduserlist() {

    // 🔹 START LOADING UI
    const btn = document.getElementById("btnGetUser");
    btn.disabled = true;
    btn.querySelector(".btn-text").innerText = "Loading...";
    btn.querySelector(".spinner").style.display = "inline-block";

    $("#upnot_userslist").empty();
    $("#upnot_selectedusers").empty();

    var ProjectName = $("#upnot_Project option:selected").text();
    var DomainGroupId = $("#upnot_subdomain option:selected").text();

    $.ajax({
        type: "POST",
        url: "UserProjectNotifications.aspx/GetProjectwiseUsers",
        dataType: "json",
        contentType: "application/json",
        data: JSON.stringify({
            ProjectName: ProjectName,
            Subdomain: DomainGroupId
        }),

        success: function (res) {

            let dataArray = typeof res.d === "string"
                ? JSON.parse(res.d)
                : res.d;

            $.each(dataArray, function (i, item) {

                let li = $("<li>")
                    .text(item.UserName)
                    .attr("data-id", item.UserID)
                    .attr("draggable", true)
                    .on("dragstart", upnot_dragLi);

                $("#upnot_userslist").append(li);
            });
        },

        error: function () {
            alert("Error loading users");
        },

        complete: function () {
            // 🔹 STOP LOADING UI
            btn.disabled = false;
            btn.querySelector(".btn-text").innerText = "Get Users";
            btn.querySelector(".spinner").style.display = "none";
        }
    });

    return false;
}

function bindalertgrid() {
    $('#grdAlert').DataTable({
        ajax: {
            type: "POST",
            url: "UserProjectNotifications.aspx/GetAllDashboardAlert",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            dataSrc: function (json) {
                return JSON.parse(json.d);
            }
        },
        columns: [
            { data: "Project" },
            { data: "Subject" },
            { data: "Message" },
            { data: "EffectiveDate" },
            { data: "AddedByName" },
            { data: "AddedDate" }
        ]
    });
}

function upnot_changeproject() {

    $("#upnot_userslist").empty();
    $("#upnot_selectedusers").empty();
}


/* ---------- save data ---------- */

async function upnot_submitnotifications() {

    if (event) event.preventDefault();

    let subject = document.getElementById("upnot_subject").value.trim();
    let message = document.getElementById("upnot_alertmessage").value.trim();
    let effectiveDate = document.getElementById("upnot_effectivedate").value;
    let domainId = document.getElementById("upnot_domain").value;
    let subdomainId = document.getElementById("upnot_subdomain").value;
    let project = document.getElementById("upnot_Project").value;

    let selectedUsers = Array.from(document.querySelectorAll("#upnot_selectedusers li")).map(li => li.getAttribute("data-id")).join(",");

    let fileInput = document.getElementById("upnot_fpAttach");
    let file = fileInput.files.length > 0 ? fileInput.files[0] : null;

    if (!subject) return Swal.fire("Validation", "Subject is required", "warning");
    if (!effectiveDate) return Swal.fire("Validation", "Effective Date is required", "warning");
    if (!message) return Swal.fire("Validation", "Message is required", "warning");
    if (!domainId || domainId === "0") return Swal.fire("Validation", "Domain is required", "warning");
    if (!subdomainId || subdomainId === "0") return Swal.fire("Validation", "Sub Domain is required", "warning");
    if (!project || project === "0") return Swal.fire("Validation", "Project is required", "warning");
    if (!selectedUsers) return Swal.fire("Validation", "Please select at least one user", "warning");

    let formData = new FormData();
    formData.append("Subject", subject);
    formData.append("Message", message);
    formData.append("EffectiveDate", effectiveDate);
    formData.append("DomainID", domainId);
    formData.append("SubdomainID", subdomainId);
    formData.append("Project", project);
    formData.append("Users", selectedUsers);

    if (file) {
        formData.append("Attachment", file);
    }

    try {

        let response = await fetch("UserProjectNotifications.aspx/InsertProjectNotification", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                Subject: subject,
                Message: message,
                EffectiveDate: effectiveDate,
                DomainID: domainId,
                SubdomainID: subdomainId,
                Project: project,
                Users: selectedUsers
            })
        });

        let result = await response.json();

        // WebMethod returns data inside .d
        if (result.d > 0) {
            Swal.fire("Success", "Notification saved successfully!", "success");
            upnot_resetform();
        } else {
            Swal.fire("Error", "Failed to save notification", "error");
        }

    } catch (error) {
        console.error(error);
        Swal.fire("Error", "Something went wrong while saving.", "error");
    }

    return false;
}


/* ---------- click select ---------- */
$(document).on("click", ".listbox-ul li", function (e) {

    if (!e.ctrlKey) {
        $(".listbox-ul li").removeClass("selected");
    }

    $(this).toggleClass("selected");
});

function upnot_dragLi(e) {

    let selected = document.querySelectorAll(".listbox-ul li.selected");

    // If dragged item is not selected → treat it as single drag
    if (!e.target.classList.contains("selected")) {
        selected = [e.target];
    }

    upnot_draggedItems = Array.from(selected);
}

function upnot_allowDrop(e) {
    e.preventDefault();
}

function upnot_dropLi(e) {
    e.preventDefault();

    let targetUl = e.currentTarget;

    upnot_draggedItems.forEach(item => {

        // avoid duplicate append issues
        if (item && targetUl !== item.parentNode) {
            targetUl.appendChild(item);
            item.classList.remove("selected");
        }
    });

    upnot_draggedItems = [];
}

/*Select All*/
$(document).on("keydown", function (e) {

    // Ctrl+A or Cmd+A (Mac)
    if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === "a") {

        // Only when the focus is inside the users list
        if ($(document.activeElement).closest("#upnot_userslist").length ||
            $("#upnot_userslist:hover").length) {

            e.preventDefault(); // Prevent browser's Select All

            $("#upnot_userslist li").addClass("selected");
        }

        if ($(document.activeElement).closest("#upnot_selectedusers").length ||
            $("#upnot_selectedusers:hover").length) {

            e.preventDefault(); // Prevent browser's Select All

            $("#upnot_selectedusers li").addClass("selected");
        }
    }
});

// $(document).on("keydown", function (e) {

//     if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === "a") {

//         const list = document.activeElement;

//         if ($(list).hasClass("listbox-ul")) {
//             e.preventDefault();
//             $(list).find("li").addClass("selected");
//         }
//     }
// });

function upnot_resetform() {
    document.getElementById("upnot_subject").value = "";
    document.getElementById("upnot_alertmessage").value = "";
    document.getElementById("upnot_effectivedate").value = "";
    document.getElementById("upnot_domain").selectedIndex = 0;
    document.getElementById("upnot_subdomain").innerHTML = "";
    document.getElementById("upnot_Project").innerHTML = "";
    document.getElementById("upnot_fpAttach").value = "";

    $("#upnot_userslist").empty();
    $("#upnot_selectedusers").empty();
}


/*------------ OLD methods ------------*/
function core_upnot_submitnotifications() {

    alert(users);

    var users = [];

    //$("#upnot_selectedusers option").each(function () {
    //    users.push($(this).val());
    //});

    /*  var userIds = users.join(",");*/

    $("#upnot_selectedusers li").each(function () {
        users.push($(this).data("id"));
    });

    alert($("#upnot_Project").val());

    var data = {
        Subject: $("#upnot_subject").val(),
        Message: $("#upnot_alertmessage").val(),
        EffectiveDate: $("#upnot_effectivedate").val(),
        DomainID: $("#upnot_domain").val(),
        SubdomainID: $("#upnot_subdomain").val(),
        Project: ProjectName,
        Users: userIds
    };

    $.ajax({
        type: "POST",
        url: "UserProjectNotifications.aspx/InsertProjectNotification",
        data: JSON.stringify(data),
        contentType: "application/json; charset=utf-8",

        success: function (res) {
            alert("Record added successfully");
            location.reload();
        }

    });
    return false;
}

