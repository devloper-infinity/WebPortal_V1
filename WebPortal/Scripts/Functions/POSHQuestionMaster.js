
var posh_table;
var posh_html;


function posh_bindSection() {
    var select = document.getElementById("posh_section");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#posh_section").append($("<option></option>").val("Select").html("Select"));

    $.ajax({
        type: "POST", url: "POSHQuestionMaster.aspx/GetPOSHQuestionSection", dataType: "json", contentType: "application/json",
        success: function (res1) {
            var dataArray = JSON.parse(res1.d);
            $.each(dataArray, function (data1, value1) {
                $("#posh_section").append($("<option></option>").val(value1.Section).html(value1.Section));
            });
        }
    });
}

function posh_BindGrid() {
    $('#load1').show();
    posh_table = '';
    $.ajax({
        url: "POSHQuestionMaster.aspx/GetAllPOSHQuestion",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                posh_table += '<tr>';
                posh_table += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(index + 1) + '</td>';
                posh_table += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Section) + '</td>';
                posh_table += '<td style="text-wrap: wrap; text-align:left;"><label style="width:300px;">' + blankForNull(value.Question) + '</label></td>';
                posh_table += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.Weightage) + '</td>';
                posh_table += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Option1) + '</td>';
                posh_table += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Option2) + '</td>';
                posh_table += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Option3) + '</td>';
                posh_table += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Option4) + '</td>';
                posh_table += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Answer) + '</td>';
                posh_table += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.AddedByName) + '</td>';
                posh_table += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.AddedDate1) + '</td>';
                posh_table += '</tr>';
            });
            if ($.fn.dataTable.isDataTable('#table_posh')) {
                table_posh.destroy();
            }
            $('#table_posh tbody').html(posh_table);
            //else
            table_posh = $('#table_posh').DataTable({
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
                    $("#table_posh").wrap("<div style='overflow:auto; width:100%;position:relative;'></div>");
                },

                buttons: [
                    {
                        extend: 'excelHtml5', title: 'POSH Question Set', autoFilter: true,
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

function posh_Questionsubmit() {

    var posh_question = document.getElementById("posh_question").value;
    var posh_weightage = document.getElementById("posh_marks").value;
    var ddlqtype = document.getElementById("posh_section");
    var posh_section = ddlqtype.options[ddlqtype.selectedIndex].value;
    var posh_option1 = document.getElementById("posh_option1").value;
    var posh_option2 = document.getElementById("posh_option2").value;
    var posh_option3 = document.getElementById("posh_option3").value;
    var posh_option4 = document.getElementById("posh_option4").value;
    var option1 = document.getElementById("posh_A_option1").checked;
    var option2 = document.getElementById("posh_A_option2").checked;
    var option3 = document.getElementById("posh_A_option3").checked;
    var option4 = document.getElementById("posh_A_option4").checked;
    var correctanswer = '';

    if (option1 == true)
        correctanswer = posh_option1;
    if (option2 == true)
        correctanswer = posh_option2;
    if (option3 == true)
        correctanswer = posh_option3;
    if (option4 == true)
        correctanswer = posh_option4;

    if (posh_question == "") {
        alert("Please enter question");
        document.getElementById("posh_question").focus();
        return false;
    }
    if (posh_section == "") {
        alert("Please select section");
        document.getElementById("posh_section").focus();
        return false;
    }
    if (posh_weightage == "") {
        alert("Please enter marks");
        document.getElementById("posh_marks").focus();
        return false;
    }
    if (posh_option1 == "") {
        alert("Please enter option 1");
        document.getElementById("posh_option1").focus();
        return false;
    }
    if (posh_option2 == "") {
        alert("Please enter option 2");
        document.getElementById("posh_option2").focus();
        return false;
    }
    if (option1 == false && option2 == false && option3 == false && option4 == false) {
        alert("Please select correct answer checkbox");
        return false;
    }

    PageMethods.InsertQuestionSet_POSH(posh_question, posh_section, posh_weightage, posh_option1, posh_option2, posh_option3, posh_option4, correctanswer, posh_OnSuccess, posh_OnError);
    return false;
}

function posh_OnSuccess(result) {

    if (result > 0) {

        posh_BindGrid();

        document.getElementById("posh_question").value = "";
        document.getElementById("posh_marks").value = "";
        document.getElementById("posh_section").selectedIndex = 0;
        document.getElementById("posh_option1").value = "";
        document.getElementById("posh_option2").value = "";
        document.getElementById("posh_option3").value = "";
        document.getElementById("posh_option4").value = "";
        document.getElementById("posh_A_option1").checked = false;
        document.getElementById("posh_A_option2").checked = false;
        document.getElementById("posh_A_option3").checked = false;
        document.getElementById("posh_A_option4").checked = false;
        document.getElementById("posh_errmsg").innerHTML = "Question added successfully!";
        document.getElementById("posh_errmsg").style.color = 'black';

        $('#posh_dverror').modal('show');
    }
    else {
        document.getElementById("posh_errmsg").innerHTML = "Question already exists!";
        document.getElementById("posh_errmsg").style.color = 'red';
        $('#posh_dverror').modal('show');
        return false;
    }
    return false;
}

function posh_OnError(error) {
    alert(error);
}
