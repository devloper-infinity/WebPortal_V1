var inductionset_table;
var inductionset_html;
var checkpaper_table;
var checkpaper_html;
var answer_table;
var answer_html;
var indreport_table;
var indreport_html;
var indreportdetail_table;
var indreportdetail_html;


function indreportdetails_bindgrid() {
    const urlParams = new URLSearchParams(window.location.search);
    const EmpID = urlParams.get('EmpID');
    var ddlmonth = document.getElementById("indreport_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("indreport_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }

    if (EmpID != '') {
        $('#load1').show();

        indreportdetail_html = '';
        $.ajax({
            url: "HRInduction.aspx/GetHRInductionReportDetails",
            type: "POST",
            data: "{EmployeeID:" + EmpID + ",Month:'" + month + "',Year:'" + year + "'}",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (data) {
                var dataArray = JSON.parse(data.d);//
                $.each(dataArray, function (index, value) {
                    indreportdetail_html += '<tr>';
                    indreportdetail_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(index + 1) + '</td>';
                    indreportdetail_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.ExamDate) + '</td>';
                    indreportdetail_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Result) + '</td>';
                    indreportdetail_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.MarksObtained) + '</td>';
                    indreportdetail_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Percentages) + '</td>';
                    indreportdetail_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Code) + '</td>';
                    indreportdetail_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Name) + '</td>';
                    indreportdetail_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.JoiningDate) + '</td>';
                    indreportdetail_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.BranchName) + '</td>';
                    indreportdetail_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.DepartmentName) + '</td>';
                    indreportdetail_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.DesignationName) + '</td>';
                    indreportdetail_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.ReportingManager) + '</td>';
                    indreportdetail_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Attempt) + '</td>';
                    indreportdetail_html += '</tr>';
                });

                if ($.fn.dataTable.isDataTable('#indreportdetail_table')) {
                    indreportdetail_table.destroy();
                }
                $('#indreportdetail_table tbody').html(indreportdetail_html);
                //else
                indreportdetail_table = $('#indreportdetail_table').DataTable({
                    dom: 'tip',
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
                            extend: 'excelHtml5', title: 'Induction Summary', autoFilter: true,
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

function indreportsummary_bindgrid() {
    const urlParams = new URLSearchParams(window.location.search);
    const EmpID = urlParams.get('EmpID');
    var ddlmonth = document.getElementById("indreport_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("indreport_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }

    if (EmpID != '') {
        $('#load1').show();

        indreport_html = '';
        $.ajax({
            url: "HRInduction.aspx/GetHRInductionReportSummary",
            type: "POST",
            data: "{EmployeeID:" + EmpID + ",Month:'" + month + "',Year:'" + year + "'}",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (data) {
                var dataArray = JSON.parse(data.d);//

                $.each(dataArray, function (index, value) {
                    indreport_html += '<tr>';
                    indreport_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(index + 1) + '</td>';
                    indreport_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.BranchName) + '</td>';
                    indreport_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Total) + '</td>';
                    indreport_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Completed) + '</td>';
                    indreport_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Pending) + '</td>';
                    indreport_html += '</tr>';
                });

                if ($.fn.dataTable.isDataTable('#indreport_table')) {
                    indreport_table.destroy();
                }
                $('#indreport_table tbody').html(indreport_html);
                //else
                indreport_table = $('#indreport_table').DataTable({
                    dom: 'Bt',
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
                            extend: 'excelHtml5', title: 'Induction Summary', autoFilter: true,
                          
                            customize: function (xlsx) {
                                setSheetName(xlsx, 'Summary');
                                addSheet(xlsx, '#indreportdetail_table', 'Induction Details', 'Details', '2');

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
    indreportdetails_bindgrid();
    return false;
}

function indreport_BindYear() {
    var start = new Date().getFullYear();

    var select = document.getElementById("indreport_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    } ``

    $("#indreport_year").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#indreport_year").append($("<option></option>").val(i).html(i));
    }
}

function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

function answer_bindheaderinfo() {
    const urlParams = new URLSearchParams(window.location.search);
    const EmpID = urlParams.get('EmpID');
    if (EmpID != '') {
        $('#load1').show();

        $.ajax({
            url: "HRAnswerSheet.aspx/BindHRExamInfo",
            type: "POST",
            data: "{EmployeeID:" + EmpID + "}",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (data) {
                var dataArray = JSON.parse(data.d);//
                $.each(dataArray, function (index, value) {
                    document.getElementById("answer_name").innerHTML = value.Name;
                    document.getElementById("answer_examdate").innerHTML = value.ExamDate;
                    document.getElementById("answer_marks").innerHTML = value.Marks;
                    document.getElementById("answer_result").innerHTML = value.Result;
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

function answer_bindgrid() {
    const urlParams = new URLSearchParams(window.location.search);
    const EmpID = urlParams.get('EmpID');
    if (EmpID != '') {
        $('#load1').show();

        answer_html = '';
        $.ajax({
            url: "HRAnswerSheet.aspx/GetQuestionPaperforcheck",
            type: "POST",
            data: "{EmployeeID:" + EmpID + "}",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (data) {
                var dataArray = JSON.parse(data.d);//

                $.each(dataArray, function (index, value) {
                    answer_html += '<tr>';
                    answer_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(index + 1) + '</td>';
                    answer_html += '<td style="text-wrap: wrap; text-align:left;">' + blankForNull(value.Question) + '</td>';
                    answer_html += '<td style="text-wrap: wrap; text-align:left;">' + blankForNull(value.Answer) + '</td>';
                    answer_html += '<td style="text-wrap: wrap; text-align:left;">' + blankForNull(value.CorrectAnswer) + '</td>';
                    answer_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Weightage) + '</td>';
                    answer_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Marks) + '</td>';
                    answer_html += '</tr>';
                });

                if ($.fn.dataTable.isDataTable('#answer_table')) {
                    answer_table.destroy();
                }
                $('#answer_table tbody').html(answer_html);
                //else
                answer_table = $('#answer_table').DataTable({
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

function checkpaper_BindYear() {
    var start = new Date().getFullYear();

    var select = document.getElementById("checkpaper_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#checkpaper_year").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#checkpaper_year").append($("<option></option>").val(i).html(i));
    }
}

function checkpaper_showanswersheet(EmployeeID, Index) {
    location.href = 'HRAnswerSheet.aspx?EmpID=' + EmployeeID;
}

function checkpaper_Submit() {
    var ddlmonth = document.getElementById("checkpaper_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("checkpaper_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }

    $('#load1').show();

    checkpaper_html = '';
    $.ajax({
        url: "HRInduction.aspx/GetQuestionPaperforcheck",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//

            $.each(dataArray, function (index, value) {
                checkpaper_html += '<tr>';
                checkpaper_html += '<td style="text-wrap: nowrap; text-align:left; display:none;">' + blankForNull(value.EmployeeID) + '</td>';
                checkpaper_html += '<td style="text-align:center;"><a class="dropdown-item" href="#!" id="Actions" onclick="checkpaper_showanswersheet(' + value.EmployeeID + ',' + index + ');" title="Show Answer Sheet"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-file-check" style="font-size:16px;"></i></span></a></td>';
                checkpaper_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(index + 1) + '</td>';
                checkpaper_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Code) + '</td>';
                checkpaper_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Name) + '</td>';
                checkpaper_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Result) + '</td>';
                checkpaper_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.ExamDate) + '</td>';
                checkpaper_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Attempt) + '</td>';
                checkpaper_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#checkpaper_table')) {
                checkpaper_table.destroy();
            }
            $('#checkpaper_table tbody').html(checkpaper_html);
            //else
            checkpaper_table = $('#checkpaper_table').DataTable({
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
                        extend: 'excelHtml5', title: 'HR Induction Papers', autoFilter: true,
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

function inductionset_BindGrid() {
    $('#load1').show();

    inductionset_html = '';
    $.ajax({
        url: "HRInduction.aspx/GetAllQuestions",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//

            $.each(dataArray, function (index, value) {
                var addeddate = eval(value.AddedDate.replace(/\/Date\((\d+)\)\//gi, "new Date($1).toLocaleDateString(\"en-US\")"));
                inductionset_html += '<tr>';
                inductionset_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(index + 1) + '</td>';
                inductionset_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Question) + '</td>';
                inductionset_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Weightage) + '</td>';
                inductionset_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Answer1) + '</td>';
                inductionset_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Answer2) + '</td>';
                inductionset_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Answer3) + '</td>';
                inductionset_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Answer4) + '</td>';
                inductionset_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.CorrectAnswer) + '</td>';
                inductionset_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.AddedByName) + '</td>';
                inductionset_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(addeddate) + '</td>';
                inductionset_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#inductionset_table')) {
                inductionset_table.destroy();
            }
            $('#inductionset_table tbody').html(inductionset_html);
            //else
            inductionset_table = $('#inductionset_table').DataTable({
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
                        extend: 'excelHtml5', title: 'HR Induction Question Set', autoFilter: true,
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
    return false;
}

function inductionset_submit() {
    var inductionset_question = document.getElementById("inductionset_question").value;
    var inductionset_weightage = document.getElementById("inductionset_weightage").value;
    var inductionset_option1 = document.getElementById("inductionset_option1").value;
    var inductionset_option2 = document.getElementById("inductionset_option2").value;
    var inductionset_option3 = document.getElementById("inductionset_option3").value;
    var inductionset_option4 = document.getElementById("inductionset_option4").value;
    var option1 = document.getElementById("option1").checked;
    var option2 = document.getElementById("option2").checked;
    var option3 = document.getElementById("option3").checked;
    var option4 = document.getElementById("option4").checked;
    var correctanswer = '';
    if (option1 == true)
        correctanswer = inductionset_option1;
    if (option2 == true)
        correctanswer = inductionset_option2;
    if (option3 == true)
        correctanswer = inductionset_option3;
    if (option4 == true)
        correctanswer = inductionset_option4;

    if (inductionset_question == "") {
        alert("Please enter question");
        document.getElementById("inductionset_question").focus();
        return false;
    }
    if (inductionset_weightage == "") {
        alert("Please enter weightage");
        document.getElementById("inductionset_weightage").focus();
        return false;
    }
    if (inductionset_option1 == "") {
        alert("Please enter option 1");
        document.getElementById("inductionset_option1").focus();
        return false;
    }
    if (inductionset_option2 == "") {
        alert("Please enter option 2");
        document.getElementById("inductionset_option2").focus();
        return false;
    }
    if (option1 == false && option2 == false && option3 == false && option4 == false) {
        alert("Please select correct answer checkbox");
        return false;
    }

    PageMethods.InsertQuestionSet(inductionset_question, inductionset_weightage, inductionset_option1, inductionset_option2, inductionset_option3, inductionset_option4, correctanswer, inductionset_OnSuccess, inductionset_OnError);
    return false;
}

function inductionset_OnSuccess(result) {
    if (result > 0) {
        document.getElementById("inductionset_errmsg").innerHTML = "Question added successfully!";
        document.getElementById("inductionset_errmsg").style.color = 'black';
        $('#inductionset_dverror').modal('show');
    }
    else {
        document.getElementById("inductionset_errmsg").innerHTML = "Question already exists!";
        document.getElementById("inductionset_errmsg").style.color = 'red';
        $('#inductionset_dverror').modal('show');
        return false;
    }
    //location.reload();
    return false;
}

function inductionset_OnError(error) {
    alert(error);
}

function inductionset_Message() {
    location.reload();
}


//Employee Question Paper
function hrinductiontest_BindTest() {

    $('#load1').show();
    var Current;
    var Prev;
    $.ajax({
        type: "POST", url: "HRQuestionPaper.aspx/GetHRInductionQuestions", dataType: "json", contentType: "application/json",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            var index = 0;
            var questionno = 1;
            var dvmain = document.getElementById("dvhrinductiontest");
            var dvHeader;
            $.each(dataArray, function (data, value) {
                dvHeader = document.createElement("div");
                dvHeader.classList.add("col-12");
                dvHeader.classList.add("col-md");
                var p = document.createElement("h6");
                p.innerHTML = questionno + ": " + blankForNull(value.Question);
                p.style.marginLeft = "5%";
                p.style.paddingTop = "20px";
                p.classList.add("mb-2");
                p.classList.add("mt-0");
                p.classList.add("text-body-primary");
                p.classList.add("fs-0");
                p.style.fontSize = "12px";
                dvHeader.appendChild(p);
                questionno++;

                var select = document.createElement("select");
                select.id = "option_" + blankForNull(value.ID);
                select.style.width = "300px";
                select.style.marginLeft = "5%";
                select.classList.add("form-control");
                var option = document.createElement("option");
                option.value = "";
                option.textContent = "Select";
                select.appendChild(option);

                if (blankForNull(value.Answer1) != "") {
                    option = document.createElement("option");
                    option.value = blankForNull(value.Answer1);
                    option.textContent = blankForNull(value.Answer1);
                    select.appendChild(option);
                }
                if (blankForNull(value.Answer2) != "") {
                    option = document.createElement("option");
                    option.value = blankForNull(value.Answer2);
                    option.textContent = blankForNull(value.Answer2);
                    select.appendChild(option);
                }
                if (blankForNull(value.Answer3) != "") {
                    option = document.createElement("option");
                    option.value = blankForNull(value.Answer3);
                    option.textContent = blankForNull(value.Answer3);
                    select.appendChild(option);
                }
                if (blankForNull(value.Answer4) != "") {
                    option = document.createElement("option");
                    option.value = blankForNull(value.Answer4);
                    option.textContent = blankForNull(value.Answer4);
                    select.appendChild(option);
                }
                dvHeader.appendChild(select);
                dvmain.appendChild(dvHeader);
                index++;

            })
            var btn = document.createElement("button");
            btn.id = "hrinductiontest_btnsubmit";
            btn.classList.add("btn");
            btn.classList.add("btn-primary");
            btn.style.marginLeft = "50%";
            btn.setAttribute("onclick", "return hrinductiontest_submit();");
            btn.innerHTML = "Submit";
            dvmain.appendChild(btn);
        }

    });
    $('#load1').hide();
}

function hrinductiontest_submit() {
    var params = "";
    var parameters = "";
    $.ajax({
        type: "POST", url: "HRQuestionPaper.aspx/GetHRInductionQuestions", dataType: "json", contentType: "application/json",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            var index = 0;
            var questionno = 1;

            $.each(dataArray, function (data, value) {
                var control = document.getElementById("option_" + blankForNull(value.ID));
                var id = control.id;
                var value = control.options[control.selectedIndex].value;
                params = id + '~' + value;
                parameters = parameters + ':' + params;
                if (value == "") {
                    alert("All questions are mandatory.");
                    parameters = "";
                    document.getElementById("option_" + blankForNull(value.ID)).focus();
                    return false;
                }
                questionno++;

            })
            if (parameters != "") {
                $('#waitingpanel').modal('show');
                PageMethods.InsertHRTestAnswers(parameters, hrinductiontest_OnSuccess, hrinductiontest_OnError);
            }
        }
    });

    return false;
}

function hrinductiontest_OnSuccess(result) {

    $('#waitingpanel').modal('hide');
    if (result > 0) {
        document.getElementById("hrinductiontest_errmsg").innerHTML = "Induction test submitted succesfully.!";
        $('#hrinductiontest_dverror').modal('show');
        return false;
    }
    else {
        document.getElementById("hrinductiontest_errmsg").innerHTML = "Oops! Error occured while submitting indeuction test. <br /> Please contact administrator!";
        document.getElementById("hrinductiontest_errmsg").style.color = 'red';
        $('#hrinductiontest_dverror').modal('show');
        return false;
    }
    return false;
}

function hrinductiontest_OnError(error) {
    alert(error);
}

function hrinductiontest_Message() {
    location.href = 'DashboardEmployee.aspx';
}


 //////////////////////////////////////// Multiheader Export ///////////////////////////////////////////

function getHeaderNames(table) {
    // Gets header names.
    //params:
    //  table: table ID.
    //Returns:
    //  Array of column header names.

    var header = $(table).DataTable().columns().header().toArray();

    var names = [];
    header.forEach(function (th) {
        names.push($(th).html());
    });

    return names;
}

function buildCols(data) {
    // Builds cols XML.
    //To do: deifne widths for each column.
    //Params:
    //  data: row data.
    //Returns:
    //  String of XML formatted column widths.

    var cols = '<cols>';

    for (i = 0; i < data.length; i++) {
        colNum = i + 1;
        cols += '<col min="' + colNum + '" max="' + colNum + '" width="20" customWidth="1"/>';
    }

    cols += '</cols>';

    return cols;
}

function buildRow(data, rowNum, styleNum) {
    // Builds row XML.
    //Params:
    //  data: Row data.
    //  rowNum: Excel row number.
    //  styleNum: style number or empty string for no style.
    //Returns:
    //  String of XML formatted row.

    var style = styleNum ? ' s="' + styleNum + '"' : '';

    var row = '<row r="' + rowNum + '">';

    for (i = 0; i < data.length; i++) {
        colNum = (i + 10).toString(36).toUpperCase();  // Convert to alpha

        var cr = colNum + rowNum;

        row += '<c t="inlineStr" r="' + cr + '"' + style + '>' +
            '<is>' +
            '<t>' + data[i] + '</t>' +
            '</is>' +
            '</c>';
    }

    row += '</row>';

    return row;
}

function getTableData(table, title) {
    // Processes Datatable row data to build sheet.
    //Params:
    //  table: table ID.
    //  title: Title displayed at top of SS or empty str for no title.
    //Returns:
    //  String of XML formatted worksheet.

    var header = getHeaderNames(table);
    var table = $(table).DataTable();
    var rowNum = 1;
    var mergeCells = '';
    var ws = '';

    ws += buildCols(header);
    ws += '<sheetData>';

    if (title.length > 0) {
        ws += buildRow([title], rowNum, 51);
        rowNum++;

        mergeCol = ((header.length - 1) + 10).toString(36).toUpperCase();

        mergeCells = '<mergeCells count="1">' +
            '<mergeCell ref="A1:' + mergeCol + '1"/>' +
            '</mergeCells>';
    }

    ws += buildRow(header, rowNum, 2);
    rowNum++;

    // Loop through each row to append to sheet.    
    table.rows().every(function (rowIdx, tableLoop, rowLoop) {
        var data = this.data();

        // If data is object based then it needs to be converted 
        // to an array before sending to buildRow()
        ws += buildRow(data, rowNum, '');

        rowNum++;
    });

    ws += '</sheetData>' + mergeCells;

    return ws;

}
function setSheetName(xlsx, name) {
    // Changes tab title for sheet.
    //Params:
    //  xlsx: xlxs worksheet object.
    //  name: name for sheet.

    if (name.length > 0) {
        var source = xlsx.xl['workbook.xml'].getElementsByTagName('sheet')[0];
        source.setAttribute('name', name);
    }
}

function addSheet(xlsx, table, title, name, sheetId) {
    //Clones sheet from Sheet1 to build new sheet.
    //Params:
    //  xlsx: xlsx object.
    //  table: table ID.
    //  title: Title for top row or blank if no title.
    //  name: Name of new sheet.
    //  sheetId: string containing sheetId for new sheet.
    //Returns:
    //  Updated sheet object.

    //Add sheet2 to [Content_Types].xml => <Types>
    //============================================
    var source = xlsx['[Content_Types].xml'].getElementsByTagName('Override')[1];
    var clone = source.cloneNode(true);
    clone.setAttribute('PartName', '/xl/worksheets/sheet' + sheetId + '.xml');
    xlsx['[Content_Types].xml'].getElementsByTagName('Types')[0].appendChild(clone);

    //Add sheet relationship to xl/_rels/workbook.xml.rels => Relationships
    //=====================================================================
    var source = xlsx.xl._rels['workbook.xml.rels'].getElementsByTagName('Relationship')[0];
    var clone = source.cloneNode(true);
    clone.setAttribute('Id', 'rId' + sheetId + 1);
    clone.setAttribute('Target', 'worksheets/sheet' + sheetId + '.xml');
    xlsx.xl._rels['workbook.xml.rels'].getElementsByTagName('Relationships')[0].appendChild(clone);

    //Add second sheet to xl/workbook.xml => <workbook><sheets>
    //=========================================================
    var source = xlsx.xl['workbook.xml'].getElementsByTagName('sheet')[0];
    var clone = source.cloneNode(true);
    clone.setAttribute('name', name);
    clone.setAttribute('sheetId', sheetId);
    clone.setAttribute('r:id', 'rId' + sheetId + 1);
    xlsx.xl['workbook.xml'].getElementsByTagName('sheets')[0].appendChild(clone);

    //Add sheet2.xml to xl/worksheets
    //===============================
    var newSheet = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
        '<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac" mc:Ignorable="x14ac">' +
        getTableData(table, title) +

        '</worksheet>';

    xlsx.xl.worksheets['sheet' + sheetId + '.xml'] = $.parseXML(newSheet);

}