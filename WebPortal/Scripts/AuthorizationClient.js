(function (window, $) {
    "use strict";
    if (!$ || !$.ajaxPrefilter) return;

    var showing = false;
    function showAuthorizationModal(status) {
        if (showing) return;
        showing = true;
        var unauthenticated = status === 401;
        var title = unauthenticated ? "Session Expired" : "Access Denied";
        var message = unauthenticated
            ? "Your session has expired. Please sign in again."
            : "You do not have permission to perform this operation.";

        if (window.Swal && window.Swal.fire) {
            window.Swal.fire({ icon: "error", title: title, text: message, confirmButtonText: "OK" })
                .then(function () { showing = false; if (unauthenticated) window.location.href = window.appRoot ? window.appRoot + "Login.aspx" : "../Login.aspx"; });
            return;
        }

        var id = "erpAuthorizationModal";
        $("#" + id).remove();
        $("body").append('<div class="modal fade" id="' + id + '" tabindex="-1" role="dialog" aria-hidden="true"><div class="modal-dialog modal-dialog-centered"><div class="modal-content"><div class="modal-header"><h5 class="modal-title">' + title + '</h5></div><div class="modal-body"><p class="mb-0">' + message + '</p></div><div class="modal-footer"><button type="button" class="btn btn-primary" data-dismiss="modal">OK</button></div></div></div></div>');
        $("#" + id).on("hidden.bs.modal", function () { showing = false; $(this).remove(); if (unauthenticated) window.location.href = "../Login.aspx"; }).modal("show");
    }

    $.ajaxPrefilter(function (options) {
        var originalError = options.error;
        options.error = function (xhr) {
            if (xhr && (xhr.status === 401 || xhr.status === 403)) {
                showAuthorizationModal(xhr.status);
                return;
            }
            if (originalError) return originalError.apply(this, arguments);
        };
    });
})(window, window.jQuery);
