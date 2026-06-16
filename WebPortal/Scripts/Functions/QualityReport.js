function feedbackreport_getreportfromdatabase() {
    $.ajax({
        url: "ImportFeedback.aspx/GetUserInfo",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            dataArray = JSON.parse(data.d);
            $.each(dataArray, function (data, value) {
                if (blankForNull(value.SubDomain) == "Credit" || blankForNull(value.SubDomain) == "Servicing") {
                    $("#feedbackreport_domain").val(blankForNull(value.SubDomain));
                    document.getElementById("feedbackreport_tddomainhead").style.display = "none";
                    if (blankForNull(value.SubDomain) == "Credit") {
                        $("#feedbckreport_companyselection").modal("show");
                        document.getElementById("feedbackreport_trcompany").style.display = "";
                    }
                    else {
                        feedbackreport_generateNewReport();
                    }
                }
                else {
                    $("#feedbckreport_companyselection").modal("show");
                    document.getElementById("feedbackreport_tddomainhead").style.display = "";

                }
            })
        }
    });
    return false;
}

function getcanopyinfinity(ddlcat) {
    var val = ddlcat.options[ddlcat.selectedIndex].text;
    if (val == "Credit") {
        document.getElementById("feedbackreport_trcompany").style.display = "";
    }
    else
        document.getElementById("feedbackreport_trcompany").style.display = "none";
    return false;
}

function feedbackreport_generateNewReport() {
    $("#feedbckreport_companyselection").modal("hide");
    $('#waitingpanel').modal('show');
    document.getElementById("spntext").innerHTML = "Generating excel sheet with chart : Weekly Graphical View";
    var domain = $("#feedbackreport_domain").val();
    var company = $("#feedbackreport_company").val();
    PageMethods.GetGraphicalView(domain, company, fr_graph_OnSuccess, fr_graph_OnError);
    return false;
}
function fr_graph_OnSuccess(result) {
    if (result >= 1) {
        document.getElementById("spntext").innerHTML = "Generating excel sheet with chart : Client wise Error Trending";
        var domain = $("#feedbackreport_domain").val();
        var company = $("#feedbackreport_company").val();
        PageMethods.CLientwiseErrorTrending(domain, company, fr_clienttrend_OnSuccess, fr_clienttrend_OnError);
    }
    return false;
}
function fr_clienttrend_OnSuccess(result) {
    if (result >= 1) {
        document.getElementById("spntext").innerHTML = "Generating excel sheet with chart : Reviewer wise Feedback Summary";
        var domain = $("#feedbackreport_domain").val();
        var company = $("#feedbackreport_company").val();
        PageMethods.ReviewersFeedbackSummary(domain, company, fr_revfeedsum_OnSuccess, fr_revfeedsum_OnError);
    }
    return false;
}

function fr_revfeedsum_OnSuccess(result) {
    if (result >= 1) {
        document.getElementById("spntext").innerHTML = "Generating excel sheet with chart : Reviewer vs QCer Error Count";
        var domain = $("#feedbackreport_domain").val();
        var company = $("#feedbackreport_company").val();
        PageMethods.ReviewerVsQcerErrorCounts(domain, company, fr_revvsqc_OnSuccess, fr_revvsqc_OnError);
    }
    return false;
}

function fr_revvsqc_OnSuccess(result) {
    if (result >= 1) {
        document.getElementById("spntext").innerHTML = "Generating excel sheet with chart : No Error Files Analysis";
        var domain = $("#feedbackreport_domain").val();
        var company = $("#feedbackreport_company").val();
        PageMethods.NoErrorFilesAnalysis(domain, company, fr_noerrana_OnSuccess, fr_noerrana_OnError);
    }
    return false;
}

function fr_noerrana_OnSuccess(result) {
    if (result >= 1) {
        document.getElementById("spntext").innerHTML = "Generating excel sheet with chart : Reviewer wise Client wise Error";
        var domain = $("#feedbackreport_domain").val();
        var company = $("#feedbackreport_company").val();
        PageMethods.Reviewerwiseclientwiseerrors(domain, company, fr_revclienterror_OnSuccess, fr_revclienterror_OnError);
    }
    return false;
}

function fr_revclienterror_OnSuccess(result) {
    if (result >= 1) {
        document.getElementById("spntext").innerHTML = "Generating excel sheet with chart : Reviewer, QC, Client wise Error Trending";
        var domain = $("#feedbackreport_domain").val();
        var company = $("#feedbackreport_company").val();
        PageMethods.ReviewerQCClientwiseerrors(domain, company, fr_revqcclienttrend_OnSuccess, fr_revqcclienttrend_OnError);
    }
    return false;
}

function fr_revqcclienttrend_OnSuccess(result) {
    if (result >= 1) {
        document.getElementById("spntext").innerHTML = "Generating excel sheet with chart : QCer performance";
        var domain = $("#feedbackreport_domain").val();
        var company = $("#feedbackreport_company").val();
        PageMethods.QCersPerformance(domain, company, fr_qcperf_OnSuccess, fr_qcperf_OnError);
    }
    return false;
}

function fr_qcperf_OnSuccess(result) {
    if (result >= 1) {
        document.getElementById("spntext").innerHTML = "Generating excel sheet with chart : Category";
        var domain = $("#feedbackreport_domain").val();
        var company = $("#feedbackreport_company").val();
        PageMethods.CategorySheet(domain, company, fr_category_OnSuccess, fr_category_OnError);
    }
    return false;
}

function fr_category_OnSuccess(result) {
    if (result >= 1) {
        document.getElementById("spntext").innerHTML = "Generating excel sheet with chart : Sub category";
        var domain = $("#feedbackreport_domain").val();
        var company = $("#feedbackreport_company").val();
        PageMethods.SubcategorySheet(domain, company, fr_subcategory_OnSuccess, fr_subcategory_OnError);
    }
    return false;
}

function fr_subcategory_OnSuccess(result) {
    if (result >= 1) {
        document.getElementById("spntext").innerHTML = "Generating excel sheet with chart : Internal Feedbacks";
        var domain = $("#feedbackreport_domain").val();
        var company = $("#feedbackreport_company").val();
        PageMethods.getInternalFeedbacks(domain, company, fr_internal_OnSuccess, fr_internal_OnError);
    }
    return false;
}

function fr_internal_OnSuccess(result) {
    if (result >= 1) {
        document.getElementById("spntext").innerHTML = "Generating excel sheet with chart : Client Feedbacks";
        var domain = $("#feedbackreport_domain").val();
        var company = $("#feedbackreport_company").val();
        PageMethods.getClientFeedbacks(domain, company, fr_clientfd_OnSuccess, fr_clientfd_OnError);
    }
    return false;
}

function fr_clientfd_OnSuccess(result) {
    document.getElementById("spntext").innerHTML = "Generating excel sheet with chart : ReQC Feedbacks";
    var domain = $("#feedbackreport_domain").val();
    var company = $("#feedbackreport_company").val();
    PageMethods.getReQCFeedbacks(domain, company, fr_Reqc_OnSuccess, fr_Reqc_OnError);
    return false;
}

function fr_Reqc_OnSuccess(result) {
    document.getElementById("spntext").innerHTML = "Generating excel sheet with chart : Rebuttal Feedbacks";
    var domain = $("#feedbackreport_domain").val();
    var company = $("#feedbackreport_company").val();
    PageMethods.getRebuttalFeedbacks(domain, company, fr_Rebut_OnSuccess, fr_Rebut_OnError);
    return false;
}

function fr_Rebut_OnSuccess(result) {
    document.getElementById("spntext").innerHTML = "Generating excel sheet with chart : Client Quality Report";
    var domain = $("#feedbackreport_domain").val();
    var company = $("#feedbackreport_company").val();
    PageMethods.GetClientQualityReport(domain, company, fr_clientqual_OnSuccess, fr_clientqual_OnError);
    return false;
}

function fr_clientqual_OnSuccess(result) {
    document.getElementById("spntext").innerHTML = "Downloading Final Output . . .";
    __doPostBack(fr_downloadBtnId, '');
    $('#waitingpanel').modal('hide');
    return false;
}

function fr_clientqual_OnError(error) {
    alert(error.responseText);
    return false;
}

function fr_Rebut_OnError(error) {
    alert(error.responseText);
    return false;
}

function fr_Reqc_OnError(error) {
    alert(error.responseText);
    return false;
}

function fr_clientfd_OnError(error) {
    alert(error.responseText);
    return false;
}


function fr_internal_OnError(error) {
    alert(error.responseText);
    return false;
}

function fr_subcategory_OnError(error) {
    alert(error.responseText);
    return false;
}

function fr_category_OnError(error) {
    alert(error.responseText);
    return false;
}

function fr_qcperf_OnError(error) {
    alert(error.responseText);
    return false;
}

function fr_revqcclienttrend_OnError(error) {
    alert(error.responseText);
    return false;
}

function fr_revclienterror_OnError(error) {
    alert(error.responseText);
    return false;
}

function fr_noerrana_OnError(error) {
    alert(error.responseText);
    return false;
}

function fr_revvsqc_OnError(error) {
    alert(error.responseText);
    return false;
}

function fr_revfeedsum_OnError(error) {
    alert(error.responseText);
    return false;
}

function fr_clienttrend_OnError(error) {
    alert(error.responseText);
    return false;
}

function fr_graph_OnError(error) {
    alert(error.responseText);
    return false;
}