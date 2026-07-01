var cr_html;
var cruw_table;
var cruw_paper_table;
var cruw_paper_html;
var cruw_ans_table;
var cruw_ans_html;
var cruw_send_table;
var cruw_send_html;
var crser_html;
var crser_table;
var crser_paper_table;
var crser_paper_html;
var crser_ans_table;
var crser_ans_html;
var crser_send_table;
var crser_send_html;


function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

function cruw_BindGrid() {
    $('#load1').show();
    cr_html = '';
    $.ajax({
        url: "UnderwritingTestModule.aspx/GetAllCredit_UWQuestions",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                var addeddate = eval(value.AddedDate.replace(/\/Date\((\d+)\)\//gi, "new Date($1).toLocaleDateString(\"en-US\")"));
                cr_html += '<tr>';
                cr_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(index + 1) + '</td>';
                cr_html += '<td style="text-wrap: wrap; text-align:left;"><label style="width:300px;">' + blankForNull(value.Question) + '</label></td>';
                cr_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.QuestionType) + '</td>';
                cr_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Marks) + '</td>';
                cr_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Option1) + '</td>';
                cr_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Option2) + '</td>';
                cr_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Option3) + '</td>';
                cr_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Option4) + '</td>';
                cr_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Answer) + '</td>';
                cr_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.AddedByName) + '</td>';
                cr_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(addeddate) + '</td>';
                cr_html += '</tr>';
            });
            if ($.fn.dataTable.isDataTable('#cruw_table')) {
                cruw_table.destroy();
            }
            $('#cruw_table tbody').html(cr_html);
            //else
            cruw_table = $('#cruw_table').DataTable({
                dom: 'lBftip',
                destroy: true,
                "paging": true,
                select: true,
                "ordering": false,
                processing: true,
                'select': {
                    'style': 'single'
                },
                initComplete: function () {
                    $('#load1').hide();
                    $("#cruw_table").wrap("<div style='overflow:auto; width:100%;position:relative;'></div>");

                },

                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Credit Test Question Set', autoFilter: true,
                        exportOptions: {
                            columns: [0, 1, 2, 3, 4],
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

function cruw_submit() {
    var cruw_question = document.getElementById("cruw_question").value;
    var cruw_weightage = document.getElementById("cruw_marks").value;
    var ddlqtype = document.getElementById("cruw_questiontype");
    var cruw_questiontype = ddlqtype.options[ddlqtype.selectedIndex].value;
    var cruw_option1 = document.getElementById("cruw_option1").value;
    var cruw_option2 = document.getElementById("cruw_option2").value;
    var cruw_option3 = document.getElementById("cruw_option3").value;
    var cruw_option4 = document.getElementById("cruw_option4").value;
    var option1 = document.getElementById("cruw_A_option1").checked;
    var option2 = document.getElementById("cruw_A_option2").checked;
    var option3 = document.getElementById("cruw_A_option3").checked;
    var option4 = document.getElementById("cruw_A_option4").checked;
    var correctanswer = '';
    if (option1 == true)
        correctanswer = cruw_option1;
    if (option2 == true)
        correctanswer = cruw_option2;
    if (option3 == true)
        correctanswer = cruw_option3;
    if (option4 == true)
        correctanswer = cruw_option4;

    if (cruw_question == "") {
        alert("Please enter question");
        document.getElementById("cruw_question").focus();
        return false;
    }
    if (cruw_questiontype == "") {
        alert("Please select question type");
        document.getElementById("cruw_questiontype").focus();
        return false;
    }
    if (cruw_weightage == "") {
        alert("Please enter marks");
        document.getElementById("cruw_marks").focus();
        return false;
    }
    if (cruw_option1 == "") {
        alert("Please enter option 1");
        document.getElementById("cruw_option1").focus();
        return false;
    }
    if (cruw_option2 == "") {
        alert("Please enter option 2");
        document.getElementById("cruw_option2").focus();
        return false;
    }
    if (option1 == false && option2 == false && option3 == false && option4 == false) {
        alert("Please select correct answer checkbox");
        return false;
    }

    PageMethods.InsertQuestionSet_CRUW(cruw_question, cruw_questiontype, cruw_weightage, cruw_option1, cruw_option2, cruw_option3, cruw_option4, correctanswer, cruw_OnSuccess, cruw_OnError);
    return false;
}

function cruw_OnSuccess(result) {
    if (result > 0) {
        document.getElementById("cruw_question").value = "";
        document.getElementById("cruw_marks").value = "";
        document.getElementById("cruw_questiontype").selectedIndex = 0;
        document.getElementById("cruw_option1").value = "";
        document.getElementById("cruw_option2").value = "";
        document.getElementById("cruw_option3").value = "";
        document.getElementById("cruw_option4").value = "";
        document.getElementById("cruw_A_option1").checked = false;
        document.getElementById("cruw_A_option2").checked = false;
        document.getElementById("cruw_A_option3").checked = false;
        document.getElementById("cruw_A_option4").checked = false;
        document.getElementById("cruw_errmsg").innerHTML = "Question added successfully!";
        document.getElementById("cruw_errmsg").style.color = 'black';
        $('#cruw_dverror').modal('show');
    }
    else {
        document.getElementById("cruw_errmsg").innerHTML = "Question already exists!";
        document.getElementById("cruw_errmsg").style.color = 'red';
        $('#cruw_dverror').modal('show');
        return false;
    }
    //location.reload();
    return false;
}

function cruw_OnError(error) {
    alert(error);
}

function cruw_Message() {
    $('#cruw_dverror').modal('hide');
    cruw_BindGrid();
    crser_BindGrid();
    /*location.reload();*/
}

function cruw_paper_Submit() {
    var fromdate = document.getElementById("cruw_paper_from").value;
    var todate = document.getElementById("cruw_paper_to").value;

    if (fromdate == "") {
        alert("Please select from date");
        return false;
    }
    if (todate == "") {
        alert("Please select to date");
        return false;
    }

    $('#load1').show();

    cruw_paper_html = '';
    $.ajax({
        url: "UnderwritingTestModule.aspx/GetCredit_UWQuestionPaperforcheck",
        type: "POST",
        data: "{FromDate:'" + fromdate + "', ToDate:'" + todate + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                cruw_paper_html += '<tr>';
                cruw_paper_html += '<td style="text-wrap: nowrap; text-align:left; display:none;">' + blankForNull(value.AppID) + '</td>';
                cruw_paper_html += '<td style="text-align:center;"><a class="dropdown-item" href="#!" id="Actions" onclick="cruw_paper_showanswersheet(' + value.AppID + ',' + index + ');" title="Show Answer Sheet"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-file-check" style="font-size:16px;"></i></span></a></td>';
                cruw_paper_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(index + 1) + '</td>';
                cruw_paper_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Name) + '</td>';
                cruw_paper_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.AssignedDate) + '</td>';
                cruw_paper_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.TestDate) + '</td>';
                cruw_paper_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Attempt) + '</td>';
                cruw_paper_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Credit) + '</td>';
                cruw_paper_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.CreditResult) + '</td>';
                cruw_paper_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Compliance) + '</td>';
                cruw_paper_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.ComplianceResult) + '</td>';
                cruw_paper_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Collateral) + '</td>';
                cruw_paper_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.CollateralResult) + '</td>';
                cruw_paper_html += '</tr>';
            });
            if ($.fn.dataTable.isDataTable('#cruw_paper_table')) {
                cruw_paper_table.destroy();
            }
            $('#cruw_paper_table tbody').html(cruw_paper_html);
            //else
            cruw_paper_table = $('#cruw_paper_table').DataTable({
                dom: 'lBftip',
                destroy: true,
                scrollX: true,
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
                        extend: 'excelHtml5', title: 'Credit Underwriting Papers', autoFilter: true,
                        exportOptions: {
                            columns: [2, 3, 4, 5, 6, 7],
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

function cruw_paper_showanswersheet(AppID, index) {
    location.href = 'CreditUWAnswerSheet.aspx?AppID=' + AppID;
}

function cruw_ans_BindHeader() {
    const urlParams = new URLSearchParams(window.location.search);
    const AppID = urlParams.get('AppID');
    if (AppID != '') {
        $('#load1').show();

        answer_html = '';
        $.ajax({
            url: "CreditUWAnswerSheet.aspx/GetCredit_UWAnswerSheetHeader",
            type: "POST",
            data: "{AppID:" + AppID + "}",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (data) {
                var dataArray = JSON.parse(data.d);//

                $.each(dataArray, function (index, value) {
                    document.getElementById("cruw_ans_name").innerHTML = blankForNull(value.FirstName) + ' ' + blankForNull(value.MiddleName) + ' ' + blankForNull(value.LastName);
                    document.getElementById("cruw_ans_examdate").innerHTML = blankForNull(value.TestDate);
                });
            },
            error: function (error) {
                alert('error; ' + eval(error));
                alert('error; ' + error.responseText);
            }
        });
    }
    return false;
}

function cruw_ans_BindGrid() {
    const urlParams = new URLSearchParams(window.location.search);
    const AppID = urlParams.get('AppID');
    if (AppID != '') {
        $('#load1').show();

        cruw_ans_html = '';
        $.ajax({
            url: "CreditUWAnswerSheet.aspx/GetCredit_UWAnswerSheet",
            type: "POST",
            data: "{AppID:" + AppID + "}",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (data) {
                var dataArray = JSON.parse(data.d);//
                var creditmark = 0;
                var creditresult = 0;
                var compliancemark = 0;
                var complianceresult = 0;
                var collateralmark = 0;
                var collateralresult = 0;
                $.each(dataArray, function (index, value) {
                    cruw_ans_html += '<tr>';
                    cruw_ans_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(index + 1) + '</td>';
                    cruw_ans_html += '<td style="text-wrap: wrap; text-align:left;">' + blankForNull(value.Question) + '</td>';
                    cruw_ans_html += '<td style="text-wrap: wrap; text-align:left;">' + blankForNull(value.QuestionType) + '</td>';
                    cruw_ans_html += '<td style="text-wrap: wrap; text-align:left;">' + blankForNull(value.Answer) + '</td>';
                    cruw_ans_html += '<td style="text-wrap: wrap; text-align:left;">' + blankForNull(value.CorrectAnswer) + '</td>';
                    cruw_ans_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Weightage) + '</td>';
                    cruw_ans_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Marks) + '</td>';
                    cruw_ans_html += '</tr>';
                    if (blankForNull(value.QuestionType) == 'Credit') {
                        creditmark += parseInt(value.Marks);
                    }
                    if (blankForNull(value.QuestionType) == 'Compliance') {
                        compliancemark += parseInt(value.Marks);
                    }
                    if (blankForNull(value.QuestionType) == 'Collateral') {
                        collateralmark += parseInt(value.Marks);
                    }

                });
                creditresult = parseFloat(((parseFloat(creditmark) / parseFloat(20)) * 100))
                complianceresult = parseFloat(((parseFloat(compliancemark) / parseFloat(16)) * 100))
                collateralresult = parseFloat(((parseFloat(collateralmark) / parseFloat(9)) * 100))

                document.getElementById("cruw_ans_credit").innerHTML = blankForNull(creditmark) + ' (' + Math.round(blankForNull(creditresult)) + '%)';
                document.getElementById("cruw_ans_compliance").innerHTML = blankForNull(compliancemark) + ' (' + Math.round(blankForNull(complianceresult)) + '%)';
                document.getElementById("cruw_ans_collateral").innerHTML = blankForNull(collateralmark) + ' (' + Math.round(blankForNull(collateralresult)) + '%)';
                var TotalMarks = parseInt(creditmark) + parseInt(compliancemark) + parseInt(collateralmark);
                document.getElementById("cruw_ans_marks").innerHTML = TotalMarks;

                if (parseInt(TotalMarks) >= 20) {
                    document.getElementById("answer_result").innerHTML = "PASS";
                    document.getElementById("answer_result").style.color = "green";
                    document.getElementById("answer_result").style.font.bold = true;
                }
                else {
                    document.getElementById("answer_result").innerHTML = "FAIL";
                    document.getElementById("answer_result").style.color = "red";
                    document.getElementById("answer_result").style.font.bold = true;
                }

                if ($.fn.dataTable.isDataTable('#cruw_ans_table')) {
                    cruw_ans_table.destroy();
                }
                $('#cruw_ans_table tbody').html(cruw_ans_html);
                //else
                cruw_ans_table = $('#cruw_ans_table').DataTable({
                    dom: 't',
                    destroy: true,
                    scrollX: true,
                    "paging": false,
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
                            extend: 'excelHtml5', title: 'Glass Door Competitors', autoFilter: true,
                            exportOptions: {
                                columns: [0, 1, 2, 3],
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
    }
    return false;
}

function cruw_send_Submit() {
    var fromdate = document.getElementById("cruw_send_from").value;
    var todate = document.getElementById("cruw_send_to").value;

    if (fromdate == "") {
        alert("Please select from date");
        return false;
    }
    if (todate == "") {
        alert("Please select to date");
        return false;
    }
    $('#load1').show();
    cruw_send_html = '';
    $.ajax({
        url: "UnderwritingTestModule.aspx/GetCredit_UWCandidateForSendMail",
        type: "POST",
        data: "{FromDate:'" + fromdate + "', ToDate:'" + todate + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                cruw_send_html += '<tr>';
                cruw_send_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(index + 1) + '</td>';
                cruw_send_html += '<td style="text-wrap: nowrap; text-align:center;"><input type="checkbox" class="custom-checkbox" id="chk' + blankForNull(value.AppID) + '"></td>';
                cruw_send_html += '<td style="text-wrap: wrap; text-align:left;">' + blankForNull(value.AppID) + '</td>';
                cruw_send_html += '<td style="text-wrap: wrap; text-align:left;">' + blankForNull(value.Name) + '</td>';
                cruw_send_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Position) + '</td>';
                cruw_send_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.EmailID) + '</td>';
                cruw_send_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.CellPhoneNo) + '</td>';
                cruw_send_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Result) + '</td>';
                cruw_send_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.MarksObtained) + '</td>';
                cruw_send_html += '</tr>';
            });
            if ($.fn.dataTable.isDataTable('#cruw_send_table')) {
                cruw_send_table.destroy();
            }
            $('#cruw_send_table tbody').html(cruw_send_html);
            //else
            cruw_send_table = $('#cruw_send_table').DataTable({
                dom: 'lBftip',
                destroy: true,
                "paging": true,
                select: true,
                "ordering": false,
                processing: true,
                'select': {
                    'style': 'single'
                },
                initComplete: function () {
                    $('#load1').hide();
                    $("#cruw_table").wrap("<div style='overflow:auto; width:100%;position:relative;'></div>");

                },

                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Credit Test Candidates', autoFilter: true,
                        exportOptions: {
                            columns: [0, 2, 3, 4, 5, 6, 7, 8],
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

function cruw_send_SendEmail() {
    $('#load1').show();
    var oTable = $('#cruw_send_table').dataTable();
    var IDS = '';
    var rowcollection = oTable.$(".custom-checkbox:checked", { "page": "all" });
    rowcollection.each(function (index, elem) {
        var checkbox_value = $(elem).val();
        var AppID = elem.id.replace("chk", "");
        if (IDS == "")
            IDS = AppID;
        else
            IDS = IDS + ',' + AppID;

    });
    document.getElementById("emailappid").value = IDS;
    __doPostBack("ctl00$ContentPlaceHolder1$Button1", "");
    //$('#load1').hide();
  
    return false;
}

function getServicingDetails() {
    crser_BindGrid();
}

function crser_BindGrid() {
    $('#load1').show();
    crser_html = '';
    $.ajax({
        url: "UnderwritingTestModule.aspx/GetAllServicing_UWQuestions",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                var addeddate = eval(value.AddedDate.replace(/\/Date\((\d+)\)\//gi, "new Date($1).toLocaleDateString(\"en-US\")"));
                crser_html += '<tr>';
                crser_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(index + 1) + '</td>';
                crser_html += '<td style="text-wrap: wrap; text-align:left;"><label style="width:300px;">' + blankForNull(value.Question) + '</label></td>';
                crser_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Marks) + '</td>';
                crser_html += '<td style="text-wrap: wrap; text-align:left;">' + blankForNull(value.Option1) + '</td>';
                crser_html += '<td style="text-wrap: wrap; text-align:left;">' + blankForNull(value.Option2) + '</td>';
                crser_html += '<td style="text-wrap: wrap; text-align:left;">' + blankForNull(value.Option3) + '</td>';
                crser_html += '<td style="text-wrap: wrap; text-align:left;">' + blankForNull(value.Option4) + '</td>';
                crser_html += '<td style="text-wrap: wrap; text-align:left;">' + blankForNull(value.Answer) + '</td>';
                crser_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.AddedByName) + '</td>';
                crser_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(addeddate) + '</td>';
                crser_html += '</tr>';
            });
            if ($.fn.dataTable.isDataTable('#crser_table')) {
                crser_table.destroy();
            }
            $('#crser_table tbody').html(crser_html);
            //else
            crser_table = $('#crser_table').DataTable({
                dom: 'lBftip',
                destroy: true,
                "paging": true,
                select: true,
                "ordering": false,
                processing: true,
                'select': {
                    'style': 'single'
                },
                initComplete: function () {
                    $('#load1').hide();
                    $("#crser_table").wrap("<div style='overflow:auto; width:100%;position:relative;'></div>");

                },

                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Servicing Test Question Set', autoFilter: true,
                        exportOptions: {
                            columns: [0, 1, 2, 3, 4],
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

function crser_submit() {
    var crser_question = document.getElementById("crser_question").value;
    var crser_weightage = document.getElementById("crser_marks").value;
    var crser_option1 = document.getElementById("crser_option1").value;
    var crser_option2 = document.getElementById("crser_option2").value;
    var crser_option3 = document.getElementById("crser_option3").value;
    var crser_option4 = document.getElementById("crser_option4").value;
    var option1 = document.getElementById("crser_A_option1").checked;
    var option2 = document.getElementById("crser_A_option2").checked;
    var option3 = document.getElementById("crser_A_option3").checked;
    var option4 = document.getElementById("crser_A_option4").checked;
    var correctanswer = '';
    if (option1 == true)
        correctanswer = crser_option1;
    if (option2 == true)
        correctanswer = crser_option2;
    if (option3 == true)
        correctanswer = crser_option3;
    if (option4 == true)
        correctanswer = crser_option4;

    if (crser_question == "") {
        alert("Please enter question");
        document.getElementById("crser_question").focus();
        return false;
    }
    if (crser_weightage == "") {
        alert("Please enter marks");
        document.getElementById("crser_marks").focus();
        return false;
    }
    if (crser_option1 == "") {
        alert("Please enter option 1");
        document.getElementById("crser_option1").focus();
        return false;
    }
    if (crser_option2 == "") {
        alert("Please enter option 2");
        document.getElementById("crser_option2").focus();
        return false;
    }
    if (option1 == false && option2 == false && option3 == false && option4 == false) {
        alert("Please select correct answer checkbox");
        return false;
    }

    PageMethods.InsertQuestionSet_SERUW(crser_question, crser_weightage, crser_option1, crser_option2, crser_option3, crser_option4, correctanswer, crser_OnSuccess, crser_OnError);
    return false;
}

function crser_OnSuccess(result) {
    if (result > 0) {
        document.getElementById("crser_question").value = "";
        document.getElementById("crser_marks").value = "";
        document.getElementById("crser_option1").value = "";
        document.getElementById("crser_option2").value = "";
        document.getElementById("crser_option3").value = "";
        document.getElementById("crser_option4").value = "";
        document.getElementById("crser_A_option1").checked = false;
        document.getElementById("crser_A_option2").checked = false;
        document.getElementById("crser_A_option3").checked = false;
        document.getElementById("crser_A_option4").checked = false;
        document.getElementById("cruw_errmsg").innerHTML = "Question added successfully!";
        document.getElementById("cruw_errmsg").style.color = 'black';
        $('#cruw_dverror').modal('show');
    }
    else {
        document.getElementById("cruw_errmsg").innerHTML = "Question already exists!";
        document.getElementById("cruw_errmsg").style.color = 'red';
        $('#cruw_dverror').modal('show');
        return false;
    }
    //location.reload();
    return false;
}

function crser_OnError(error) {
    alert(error);
}

function crser_paper_Submit() {
    var fromdate = document.getElementById("crser_paper_from").value;
    var todate = document.getElementById("crser_paper_to").value;

    if (fromdate == "") {
        alert("Please select from date");
        return false;
    }
    if (todate == "") {
        alert("Please select to date");
        return false;
    }

    $('#load1').show();

    crser_paper_html = '';
    $.ajax({
        url: "UnderwritingTestModule.aspx/GetServicing_UWQuestionPaperforcheck",
        type: "POST",
        data: "{FromDate:'" + fromdate + "', ToDate:'" + todate + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                crser_paper_html += '<tr>';
                crser_paper_html += '<td style="text-wrap: nowrap; text-align:left; display:none;">' + blankForNull(value.AppID) + '</td>';
                crser_paper_html += '<td style="text-align:center;"><a class="dropdown-item" href="#!" id="Actions" onclick="crser_paper_showanswersheet(' + value.AppID + ',' + index + ');" title="Show Answer Sheet"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-file-check" style="font-size:16px;"></i></span></a></td>';
                crser_paper_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(index + 1) + '</td>';
                crser_paper_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Name) + '</td>';
                crser_paper_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.TestDate) + '</td>';
                crser_paper_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Attempt) + '</td>';
                crser_paper_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Marks) + '</td>';
                crser_paper_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Percentage) + '</td>';
                crser_paper_html += '</tr>';
            });
            if ($.fn.dataTable.isDataTable('#crser_paper_table')) {
                crser_paper_table.destroy();
            }
            $('#crser_paper_table tbody').html(crser_paper_html);
            //else
            crser_paper_table = $('#crser_paper_table').DataTable({
                dom: 'lBftip',
                destroy: true,
                scrollX: true,
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
                        extend: 'excelHtml5', title: 'Servicing Underwriting Papers', autoFilter: true,
                        exportOptions: {
                            columns: [2, 3, 4, 5, 6, 7],
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

function crser_paper_showanswersheet(AppID, index) {
    location.href = 'ServicingUWAnswerSheet.aspx?AppID=' + AppID;
}

function crser_ans_BindHeader() {
    const urlParams = new URLSearchParams(window.location.search);
    const AppID = urlParams.get('AppID');
    if (AppID != '') {
        $('#load1').show();

        answer_html = '';
        $.ajax({
            url: "ServicingUWAnswerSheet.aspx/GetServicing_UWAnswerSheetHeader",
            type: "POST",
            data: "{AppID:" + AppID + "}",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (data) {
                var dataArray = JSON.parse(data.d);//
                $.each(dataArray, function (index, value) {
                    document.getElementById("crser_ans_name").innerHTML = blankForNull(value.FirstName) + ' ' + blankForNull(value.MiddleName) + ' ' + blankForNull(value.LastName);
                    document.getElementById("crser_ans_examdate").innerHTML = blankForNull(value.TestDate);
                });
            },
            error: function (error) {
                alert('error; ' + eval(error));
                alert('error; ' + error.responseText);
            }
        });
    }
    return false;
}

function crser_ans_BindGrid() {
    const urlParams = new URLSearchParams(window.location.search);
    const AppID = urlParams.get('AppID');
    if (AppID != '') {
        $('#load1').show();

        crser_ans_html = '';
        $.ajax({
            url: "ServicingUWAnswerSheet.aspx/GetServicing_UWAnswerSheet",
            type: "POST",
            data: "{AppID:" + AppID + "}",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (data) {
                var dataArray = JSON.parse(data.d);//
                var vmarks = 0;
                var vresult = 0;

                $.each(dataArray, function (index, value) {
                    crser_ans_html += '<tr>';
                    crser_ans_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(index + 1) + '</td>';
                    crser_ans_html += '<td style="text-wrap: wrap; text-align:left;">' + blankForNull(value.Question) + '</td>';
                    crser_ans_html += '<td style="text-wrap: wrap; text-align:left;">' + blankForNull(value.Answer) + '</td>';
                    crser_ans_html += '<td style="text-wrap: wrap; text-align:left;">' + blankForNull(value.CorrectAnswer) + '</td>';
                    crser_ans_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Weightage) + '</td>';
                    crser_ans_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Marks) + '</td>';
                    crser_ans_html += '</tr>';
                    vmarks += parseInt(value.Marks);
                });

                document.getElementById("crser_ans_marks").innerHTML = blankForNull(vmarks);

                if (parseInt(vmarks) >= 22) {
                    document.getElementById("answerser_result").innerHTML = "PASS";
                    document.getElementById("answerser_result").style.color = "green";
                    document.getElementById("answerser_result").style.font.bold = true;
                }
                else {
                    document.getElementById("answerser_result").innerHTML = "FAIL";
                    document.getElementById("answerser_result").style.color = "red";
                    document.getElementById("answerser_result").style.font.bold = true;
                }

                if ($.fn.dataTable.isDataTable('#crser_ans_table')) {
                    crser_ans_table.destroy();
                }
                $('#crser_ans_table tbody').html(crser_ans_html);
                //else
                crser_ans_table = $('#crser_ans_table').DataTable({
                    dom: 't',
                    destroy: true,
                    scrollX: true,
                    "paging": false,
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
                            extend: 'excelHtml5', title: 'Servicing Test Answer Sheet', autoFilter: true,
                            exportOptions: {
                                columns: [0, 1, 2, 3],
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
    }
    return false;
}

function crser_send_Submit() {
    var fromdate = document.getElementById("crser_send_from").value;
    var todate = document.getElementById("crser_send_to").value;

    if (fromdate == "") {
        alert("Please select from date");
        return false;
    }
    if (todate == "") {
        alert("Please select to date");
        return false;
    }
    $('#load1').show();
    crser_send_html = '';
    $.ajax({
        url: "UnderwritingTestModule.aspx/GetServicing_UWCandidateForSendMail",
        type: "POST",
        data: "{FromDate:'" + fromdate + "', ToDate:'" + todate + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                crser_send_html += '<tr>';
                crser_send_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(index + 1) + '</td>';
                crser_send_html += '<td style="text-wrap: nowrap; text-align:center;"><input type="checkbox" class="custom-checkbox" id="chk' + blankForNull(value.AppID) + '"></td>';
                crser_send_html += '<td style="text-wrap: wrap; text-align:left;">' + blankForNull(value.AppID) + '</td>';
                crser_send_html += '<td style="text-wrap: wrap; text-align:left;">' + blankForNull(value.Name) + '</td>';
                crser_send_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Position) + '</td>';
                crser_send_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.EmailID) + '</td>';
                crser_send_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.CellPhoneNo) + '</td>';
                crser_send_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Result) + '</td>';
                crser_send_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.MarksObtained) + '</td>';
                crser_send_html += '</tr>';
            });
            if ($.fn.dataTable.isDataTable('#crser_send_table')) {
                crser_send_table.destroy();
            }
            $('#crser_send_table tbody').html(crser_send_html);
            //else
            crser_send_table = $('#crser_send_table').DataTable({
                dom: 'lBftip',
                destroy: true,
                "paging": true,
                select: true,
                "ordering": false,
                processing: true,
                'select': {
                    'style': 'single'
                },
                initComplete: function () {
                    $('#load1').hide();
                    $("#crser_send_table").wrap("<div style='overflow:auto; width:100%;position:relative;'></div>");

                },

                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Servicing Test Candidates', autoFilter: true,
                        exportOptions: {
                            columns: [0, 2, 3, 4, 5, 6, 7, 8],
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

function crser_send_SendEmail() {
    $('#load1').show();
    var oTable = $('#crser_send_table').dataTable();
    var IDS = '';
    var rowcollection = oTable.$(".custom-checkbox:checked", { "page": "all" });
    rowcollection.each(function (index, elem) {
        var checkbox_value = $(elem).val();
        var AppID = elem.id.replace("chk", "");
        if (IDS == "")
            IDS = AppID;
        else
            IDS = IDS + ',' + AppID;

    });
    document.getElementById("emailappidser").value = IDS;
    __doPostBack("ctl00$ContentPlaceHolder1$btnMailSer", "");
    //$('#load1').hide();
    return false;
}