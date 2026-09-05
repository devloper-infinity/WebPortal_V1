(function ($) {
    "use strict";

    var rpsEmployeeTable = null;
    var rpsPasswordPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^a-zA-Z0-9]).{8,}$/;

    $(document).ready(function () {
        rps_bindTabs();
        rps_bindEmployees();

        $("#rpsGeneratePassword").on("click", rps_generatePassword);
        $("#rpsSavePassword").on("click", rps_resetPassword);
        $("#rpsSaveSegment").on("click", rps_updateSegment);
    });

    function rps_bindTabs() {
        $(".rps-tab").on("click", function () {
            rps_activateTab($(this).data("rps-tab"));
        });

        $(".rps-tab").on("keydown", function (event) {
            if (event.key !== "ArrowLeft" && event.key !== "ArrowRight") {
                return;
            }

            event.preventDefault();
            var tabs = $(".rps-tab");
            var currentIndex = tabs.index(this);
            var nextIndex = event.key === "ArrowRight"
                ? (currentIndex + 1) % tabs.length
                : (currentIndex - 1 + tabs.length) % tabs.length;

            tabs.eq(nextIndex).trigger("click").trigger("focus");
        });
    }

    function rps_activateTab(tabName) {
        $(".rps-tab").each(function () {
            var isActive = $(this).data("rps-tab") === tabName;
            $(this)
                .toggleClass("is-active", isActive)
                .attr("aria-selected", isActive ? "true" : "false")
                .attr("tabindex", isActive ? "0" : "-1");
        });

        $(".rps-panel").each(function () {
            var isActive = $(this).data("rps-panel") === tabName;
            $(this).toggleClass("is-active", isActive).prop("hidden", !isActive);
        });
    }

    function rps_bindEmployees() {

        rps_setPageLoading(true);

        if ($.fn.DataTable.isDataTable("#rpsEmployeeTable")) {
            $("#rpsEmployeeTable").DataTable().destroy();
            $("#rpsEmployeeTable tbody").empty();
        }

        $.ajax({
            type: "POST",
            url: "ResetPasswordSegment.aspx/GetUSEmployees",
            data: "{}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",

            success: function (response) {

                try {
                    // Your C# method returns string, therefore parse response.d
                    var employees = response.d;

                    if (typeof employees === "string") {
                        employees = JSON.parse(employees);
                    }

                    employees = employees || [];

                    // console.log("Employees:", employees);

                    // Bind dropdown if required
                    rps_bindUserDropdowns(employees);

                    // Bind DataTable
                    rpsEmployeeTable = $("#rpsEmployeeTable").DataTable({
                        data: employees,
                        destroy: true,
                        processing: false,
                        serverSide: false,
                        scrollX: true,
                        ordering: false,
                        pageLength: 10,

                        lengthMenu: [
                            [10, 25, 50, -1],
                            [10, 25, 50, "All"]
                        ],

                        columns: [
                            {
                                data: "SrNo",
                                defaultContent: "",
                                render: rps_renderText
                            },
                            {
                                data: "FullName",
                                defaultContent: "",
                                render: rps_renderText
                            },
                            // {
                            //     data: "ReportingManager",
                            //     defaultContent: "",
                            //     render: rps_renderText
                            // },
                            // {
                            //     data: "DesignationName",
                            //     defaultContent: "",
                            //     render: rps_renderText
                            // },
                            // {
                            //     data: "DepartmentName",
                            //     defaultContent: "",
                            //     render: rps_renderText
                            // },
                            {
                                data: "Segment",
                                defaultContent: "",
                                render: rps_renderSegment
                            }
                        ],

                        dom:
                            "<'row align-items-center mb-3'" +
                            "<'col-md-5'l>" +
                            "<'col-md-7'f>" +
                            ">" +
                            "<'row mb-2'<'col-12'B>>" +
                            "rt" +
                            "<'row mt-3'" +
                            "<'col-md-5'i>" +
                            "<'col-md-7'p>" +
                            ">",

                        buttons: [
                            {
                                extend: "excelHtml5",
                                text: '<i class="fas fa-file-excel"></i> Excel',
                                className: "btn btn-success btn-sm",
                                title: "US Employee Directory"
                            },
                            {
                                extend: "print",
                                text: '<i class="fas fa-print"></i> Print',
                                className: "btn btn-primary btn-sm",
                                title: "US Employee Directory"
                            }
                        ],

                        language: {
                            emptyTable: "No employees found",
                            search: "Search:"
                        }
                    });

                } catch (ex) {
                    console.error("Employee binding error:", ex);

                    rps_showError(
                        "Unable to bind employee data.",
                        ex
                    );
                }

                rps_setPageLoading(false);
            },

            error: function (xhr, status, error) {

                rps_setPageLoading(false);

                console.error("GetUSEmployees failed");
                console.error("HTTP Status:", xhr.status);
                console.error("Response:", xhr.responseText);
                console.error("Error:", error);

                rps_showError(
                    "Unable to load employee data.",
                    xhr
                );
            }
        });
    }

    function core_rps_bindEmployees() {

        alert('message');

        rps_setPageLoading(true);

        $.ajax({
            type: "POST",
            url: "ResetPasswordSegment.aspx/GetUSEmployees",
            data: "{}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",

            success: function (response) {
                // console.log(response);
                // alert(response.d);
            },

            error: function (xhr, status, error) {
                console.error("HTTP Status:", xhr.status);
                console.error("Error:", error);
                console.error("Response:", xhr.responseText);

                alert(xhr.responseText);
            }
        });

        // rpsEmployeeTable = $("#rpsEmployeeTable").DataTable({
        //     destroy: true,
        //     processing: true,
        //     serverSide: false,
        //     scrollX: true,
        //     ordering: false,
        //     pageLength: 10,
        //     lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],

        //     ajax: {
        //         type: "POST",
        //         url: "ResetPasswordSegment.aspx/GetUSEmployees",
        //         data: "{}",
        //         contentType: "application/json; charset=utf-8",
        //         dataType: "json",
        //         dataSrc: function (response) {
        //             var employees = response && response.d ? response.d : [];

        //             alert(employees);

        //             employees = typeof employees === "string" ? JSON.parse(employees) : employees;
        //             employees = rps_normalizeEmployees(employees);
        //             rps_bindUserDropdowns(employees);
        //             return employees;
        //         },
        //         error: function (xhr) {
        //             rps_setPageLoading(false);
        //             rps_showError("Unable to load employee data.", xhr);
        //         }
        //     },
        //     columns: [
        //         { data: "Code", defaultContent: "", render: rps_renderText },
        //         { data: "FullName", defaultContent: "", render: rps_renderText },
        //         { data: "ReportingManager", defaultContent: "", render: rps_renderText },
        //         { data: "DesignationName", defaultContent: "", render: rps_renderText },
        //         { data: "DepartmentName", defaultContent: "", render: rps_renderText },
        //         { data: "Segment", defaultContent: "", render: rps_renderSegment }
        //     ],
        //     dom: "<'row align-items-center mb-3'<'col-md-5'l><'col-md-7'f>>" +
        //         "<'row mb-2'<'col-12'B>>rt<'row mt-3'<'col-md-5'i><'col-md-7'p>>",
        //     buttons: [
        //         { extend: "excelHtml5", text: '<i class="fas fa-file-excel"></i> Excel', className: "btn btn-success btn-sm", title: "US Employee Directory" },
        //         { extend: "print", text: '<i class="fas fa-print"></i> Print', className: "btn btn-primary btn-sm", title: "US Employee Directory" }
        //     ],
        //     language: {
        //         emptyTable: "No employees found",
        //         processing: "Loading employees...",
        //         search: "Search:"
        //     },
        //     initComplete: function () {
        //         rps_setPageLoading(false);
        //     }
        // });
    }

    function rps_normalizeEmployees(employees) {
        return $.map(employees || [], function (employee) {
            return {
                SrNo: employee.SrNo || employee.SrNo || "",
                FullName: employee.FullName || employee.Name || "",
                // ReportingManager: employee.ReportingManager || employee.Manager || "",
                // DesignationName: employee.DesignationName || employee.Designation || "",
                // DepartmentName: employee.DepartmentName || employee.Department || "",
                Segment: employee.Segment || ""
            };
        });
    }


    function rps_bindUserDropdowns(employees) {

        var options = ['<option value="">Select user</option>'];

        $.each(employees || [], function (_, employee) {

            var code = rps_text(employee.Code);
            var name = rps_text(employee.FullName);

            if (code) {

                options.push(
                    '<option value="' + rps_escapeHtml(code) + '">' +
                    rps_escapeHtml(name) +
                    '</option>'
                );
            }
        });

        $("#rpsResetUser, #rpsSegmentUser").html(options.join(""));
    }
    function rps_generatePassword() {
        rps_showProcessing("Generating password", "Creating a secure temporary password.");

        rps_post("GeneratePassword", {}, function (password) {
            Swal.close();
            $("#rpsGeneratedPassword").val(rps_text(password));
        }, "Unable to generate a password.");
    }

    function rps_resetPassword() {
        var code = $("#rpsResetUser").val();
        var password = $("#rpsGeneratedPassword").val();

        if (!code) {
            rps_showValidation("Please select a user.");
            return;
        }

        if (!password) {
            rps_showValidation("Please generate a password before saving.");
            return;
        }

        if (!rpsPasswordPattern.test(password)) {
            rps_showValidation("The generated password does not satisfy the password policy. Please generate it again.");
            return;
        }

        Swal.fire({
            icon: "question",
            title: "Reset password?",
            text: "The selected employee will need to use the newly generated password.",
            showCancelButton: true,
            confirmButtonText: "Yes, reset password",
            confirmButtonColor: "#2563eb",
            cancelButtonText: "Cancel"
        }).then(function (confirmation) {
            if (!confirmation.isConfirmed) {
                return;
            }

            rps_showProcessing("Resetting password", "Please wait while the password is updated.");
            rps_post("ResetPassword", { code: code, password: password }, function (result) {
                if (!result || !result.Success) {
                    rps_showResultError(result && result.Message ? result.Message : "Unable to reset the password.");
                    return;
                }

                Swal.fire({ icon: "success", title: "Success", text: result.Message, confirmButtonColor: "#2563eb" });
                $("#rpsResetUser").val("");
                $("#rpsGeneratedPassword").val("");
            }, "Unable to reset the password.");
        });
    }

    function rps_updateSegment() {
        var code = $("#rpsSegmentUser").val();
        var segment = $("#rpsSegment").val();

        if (!code) {
            rps_showValidation("Please select a user.");
            return;
        }

        if (!segment) {
            rps_showValidation("Please select a segment.");
            return;
        }

        Swal.fire({
            icon: "question",
            title: "Update segment?",
            text: "The selected employee will be assigned to " + segment + ".",
            showCancelButton: true,
            confirmButtonText: "Yes, update segment",
            confirmButtonColor: "#2563eb",
            cancelButtonText: "Cancel"
        }).then(function (confirmation) {
            if (!confirmation.isConfirmed) {
                return;
            }

            rps_showProcessing("Updating segment", "Please wait while the assignment is saved.");
            rps_post("UpdateSegment", { code: code, segment: segment }, function (result) {
                if (!result || !result.Success) {
                    rps_showResultError(result && result.Message ? result.Message : "Unable to update the segment.");
                    return;
                }

                Swal.fire({
                    icon: result.Changed ? "success" : "info",
                    title: result.Changed ? "Success" : "No change needed",
                    text: result.Message,
                    confirmButtonColor: "#2563eb"
                });

                $("#rpsSegmentUser, #rpsSegment").val("");
                rps_bindEmployees();
            }, "Unable to update the segment.");
        });
    }

    function rps_post(method, data, onSuccess, fallbackMessage) {
        $.ajax({
            type: "POST",
            url: "ResetPasswordSegment.aspx/" + method,
            data: JSON.stringify(data || {}),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                onSuccess(response ? response.d : null);
            },
            error: function (xhr) {
                Swal.close();
                rps_showError(fallbackMessage, xhr);
            }
        });
    }

    function rps_showProcessing(title, text) {
        Swal.fire({
            title: title,
            text: text,
            allowOutsideClick: false,
            allowEscapeKey: false,
            showConfirmButton: false,
            didOpen: function () { Swal.showLoading(); }
        });
    }

    function rps_showValidation(message) {
        Swal.fire({ icon: "warning", title: "Validation", text: message, confirmButtonColor: "#f59e0b" });
    }

    function rps_showResultError(message) {
        Swal.fire({ icon: "error", title: "Error", text: message, confirmButtonColor: "#dc2626" });
    }

    function rps_showError(message, xhr) {
        if (window.console && console.error) {
            console.error("ResetPasswordSegment request failed", xhr);
        }

        rps_showResultError(message);
    }

    function rps_setPageLoading(isLoading) {
        $("#rpsPageLoader").toggleClass("is-visible", isLoading).attr("aria-hidden", isLoading ? "false" : "true");
    }

    function rps_renderText(data, type) {
        var value = rps_text(data);
        return type === "display" ? rps_escapeHtml(value) : value;
    }

    function rps_renderSegment(data, type) {
        var value = rps_text(data);

        if (type !== "display") {
            return value;
        }

        return value ? '<span class="rps-segment-badge">' + rps_escapeHtml(value) + '</span>' : "-";
    }

    function rps_text(value) {
        return value === null || value === undefined ? "" : String(value);
    }

    function rps_escapeHtml(value) {
        return rps_text(value)
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#39;");
    }
})(jQuery);
