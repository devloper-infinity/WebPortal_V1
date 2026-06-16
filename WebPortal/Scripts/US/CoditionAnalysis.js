var global_analysisid = 0;
var conAnalysis_table;
var analysisStartTime;


function condAnalysis_bindGrid() {

    $('#usload1').show();

    $.ajax({
        url: "ConditionAnalysis.aspx/ViewAllConditionClearingPending",
        type: "POST",
        contentType: "application/json",
        success: function (data) {

            var dataArray = data.d || [];

            // Destroy old DataTable
            if ($.fn.DataTable.isDataTable('#table_conAnalysis')) {
                $('#table_conAnalysis').DataTable().clear().destroy();
            }

            conAnalysis_table = $('#table_conAnalysis').DataTable({
                dom: 'lfrtip',
                data: dataArray,
                scrollX: false,
                paging: true,
                processing: true,
                ordering: false,
                serverSide: false,

                columns: [
                    {
                        data: "Id", title: "Action",
                        className: "text-center",
                        render: function (data) {
                            return '<a title="Add conditions" class="dropdown-item" href="#!" id="Actions" onclick="condAnalysis_show(' + data + ');"><span style="color: dodgerblue; font-size:15px;"><i class="uil uil-comment-alt-message me-1 text-primary"></i></span></a>'
                        }
                    },
                    {
                        data: null, title: 'Sr. #',
                        render: function (data, type, row, meta) {
                            return meta.row + 1;
                        }
                    },

                    { data: 'DealNo', title: 'Deal #' },
                    { data: 'LoanNo', title: 'Loan #' },
                    { data: 'InfinityCondition', title: 'Infinity Conditions' },
                    { data: 'ClientsRebuttal', title: 'Clients Rebuttal' },
                    { data: 'ReceivedDate', title: 'Received Date' },
                    { data: 'AddedName', title: 'Added  By' },
                    { data: 'AddedDate1', title: 'Added Date' }
                ],

                initComplete: function () {
                    $('#usload1').hide();
                }
            });

        },

        error: function (error) {
            $('#usload1').hide();
            alert('Error: ' + error.responseText);
        }

    });
}


function condAnalysis_show(id) {

    global_analysisid = id;

    condAnalysis_binddata(id);

    $('#popUp_addResponse').modal('show');

    // Store popup open time
    analysisStartTime = new Date();
}


function condAnalysis_binddata(id) {

    $.ajax({
        url: "ConditionAnalysis.aspx/ViewAllConditionClearingById",
        type: "POST",
        data: "{ID:" + id + "}",
        contentType: "application/json",
        success: function (data) {

            var dataArray = data.d || [];

            $('#ana_popupheader').text("  Deal - " + dataArray[0].DealNo + ",   Loan - " + dataArray[0].LoanNo);
            document.getElementById("ana_infCondition").value = dataArray[0].InfinityCondition || '';
            document.getElementById("ana_rebuttal").value = dataArray[0].ClientsRebuttal || '';
            document.getElementById("ana_receivedDate").value = formatdate(dataArray[0].ReceivedDate) || '';
            document.getElementById("ana_process").value = dataArray[0].Process || '';
            document.getElementById("ana_initGrade").value = dataArray[0].InitialExceptionGrade || '';
        },

        error: function (error) {
            $('#load1').hide();
            alert('Error: ' + error.responseText);
        }

    });
}


function ana_endAnalysis() {

    var receivedDate = $("#ana_receivedDate").val();
    var grade = $("#ana_initGrade").val();
    var process = $("#ana_process").val();
    var infCondition = $("#ana_infCondition").val();
    var rebuttal = $("#ana_rebuttal").val();

    var responseText = $("#ana_response").val();
    var reviewDate = $("#ana_reviewDate").val();
    var finalGrade = $("#ana_finalGrade").val();
    var resolved = $("#ana_resolved").val();

    // Validation
    if (responseText == "") { alert("Please enter Comments"); return false; }
    if (reviewDate == "") { alert("Please select Review Date"); return false; }
    if (finalGrade == "") { alert("Please select Final Exception Grade"); return false; }
    if (resolved == "") { alert("Please select Resolved"); return false; }

    var analysisEndTime = new Date();
    var diffMs = analysisEndTime - analysisStartTime;

    var diffSeconds = Math.floor(diffMs / 1000);
    var hours = Math.floor(diffSeconds / 3600);
    var minutes = Math.floor((diffSeconds % 3600) / 60);
    var seconds = diffSeconds % 60;

    hours = hours.toString().padStart(2, '0');
    minutes = minutes.toString().padStart(2, '0');
    seconds = seconds.toString().padStart(2, '0');

    var totalTime = hours + ":" + minutes + ":" + seconds;

    // PageMethod Call
    PageMethods.UpdateConditionAnalysis(global_analysisid, reviewDate, resolved, responseText, totalTime, infCondition, receivedDate, rebuttal, finalGrade, analysisStartTime, analysisEndTime,

        function (response) {

            if (response.includes("Error")) {
                Swal.fire({
                    icon: 'warning',
                    title: 'Warning',
                    text: response,
                    zIndex: 999999
                });
            } else {
                $('#popUp_addResponse').modal('hide');

                Swal.fire({
                    icon: 'success',
                    title: 'Success',
                    text: response
                }).then(function () {
                    analysis_ClearForm();
                    global_analysisid = 0;
                });
            }
        },

        function (error) {
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: error.get_message()
            });
        }
    );

    return false;
}


function analysis_ClearForm() {

    $("#concl_receiveddate").val("");
    $("#ana_resolved").prop("selectedIndex", 0);
    $("#ana_finalGrade").prop("selectedIndex", 0);
    $("#ana_response").val("");
    $("#ana_reviewDate").val("");
    $("#ana_rebuttal").val("");
    $("#ana_infCondition").val("");
    $("#ana_initGrade").val("");
    $("#ana_process").val("");
    $("#ana_receivedDate").val("");
}


function formatdate(prv_date) {

    var date = new Date(prv_date);
    var day = date.getDate();
    if (day < 10)
        day = '0' + day
    var month = date.getMonth() + 1;
    if (month < 10)
        month = '0' + month
    var year = date.getFullYear();
    var actualdate = year + "-" + (month) + "-" + (day);

    return actualdate;
}


function openAnalysisModalFromGrid(id) {

    document.getElementById("ana_project").value = dataArray.project || '';
    document.getElementById("ana_deal").value = dataArray.deal || '';
    document.getElementById("ana_loan").value = dataArray.loan || '';
    document.getElementById("ana_infCondition").value = dataArray.inf || '';
    document.getElementById("ana_rebuttal").value = dataArray.rebuttal || '';
    document.getElementById("ana_receivedDate").value = dataArray.date || '';
    document.getElementById("ana_process").value = dataArray.process || '';
    document.getElementById("ana_initGrade").value = dataArray.grade || '';

    // Open modal
    document.getElementById("analysisModal").style.display = "block";
}


function closeAnalysisModal() {

    analysis_ClearForm();
    global_analysisid = 0;
    $('#popUp_addResponse').modal('hide');
}