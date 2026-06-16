
var ackUserReport_table;
var ackUserReport_html;

function BindUserPerformanceInfo() {

    $.ajax({
        url: "UserPerformanceAcknowledgement.aspx/GetOverAllUserPerformance_UserPerfAck",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = JSON.parse(data.d);

            $.each(dataArray, function (index, value) {

                document.getElementById("userPerfAck_lblPerformanceID").innerHTML = value.PerformanceID;
                document.getElementById("userPerfAck_lblCode").innerHTML = value.Code;
                document.getElementById("userPerfAck_lblDate").innerHTML = '<b>Date : </b> ' + value.CurrentDate;
                document.getElementById("userPerfAck_lblTo").innerHTML = '<b>To : </b> ' + value.EmployeeName;
                document.getElementById("userPerfAck_lblPosition").innerHTML = '<b>Position : </b> ' + value.DesignationName;
                document.getElementById("userPerfAck_lblDomain").innerHTML = '<b>Domain : </b> ' + value.DomainName;
                document.getElementById("userPerfAck_lblMonthYear").innerHTML = '<b>' + value.Month.substring(0, 3) + '-' + value.Year + ' </b>';
                document.getElementById("userPerfAck_lblEmpName").innerHTML = '<b>Dear </b>' + value.F_Name + ',';
                document.getElementById("userPerfAck_lblQCritical").innerHTML = '(<b>Critical : </b>' + value.Critical;
                document.getElementById("userPerfAck_lblQNonCritical").innerHTML = '<b>Non-Critical : </b>' + value.NonCritical + ')';

                document.getElementById("userPerfAck_lblQuality").innerHTML = '</br>' + value.QualityPerc;
                document.getElementById("userPerfAck_lblQuaRatingCat").innerHTML = '</br>' + value.QualRatingCatg;
                document.getElementById("userPerfAck_lblAttendance").innerHTML = value.AttPerc;
                document.getElementById("userPerfAck_lblAttRatingCat").innerHTML = value.AttnRatingCatg;
                document.getElementById("userPerfAck_lblProductivity").innerHTML = value.ProdPerc;
                document.getElementById("userPerfAck_lblPrRatingCat").innerHTML = value.ProdRatingCatg;
                document.getElementById("userPerfAck_lblDesclaimer").innerHTML = 'I ' + value.F_Name + ', acknowledge the receipt and review of my performance grading as outlined above.';
            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });

    return false;
}

function Onclick_userPerfAck_btnAccept() {

    var IsAck = document.getElementById("chk_UserPerfDesclaimer").checked;
    var PerformanceID = document.getElementById("userPerfAck_lblPerformanceID").innerHTML;
    var Code = document.getElementById("userPerfAck_lblCode").innerHTML;

    if (IsAck == false) {
        alert("Please check checkbox.");
        return false;
    }
    if (IsAck == true) {
        PageMethods.AcknowledgeUserPerformance(PerformanceID, Code, OnSuccessAck, OnErrorAck);
    }
    return false;
}

function OnSuccessAck(result) {

    if (result > 0) {
        alert("Acknowledged successfully.");
        window.location = "../Admin/DashboardEmployee.aspx";
    }
    else {
        alert("Oops! Error occured while acknowledging performance. Please contact administrator");
        return false;
    }
}

function OnErrorAck(error) {
    alert(error.responseText);
}


/*------------------ User Performance Monthly Acknowledgement Report ---------------*/

function ackrp_BindYear() {

    var start = new Date().getFullYear();

    var select = document.getElementById("ack_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#ack_year").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#ack_year").append($("<option></option>").val(i).html(i));
    }
}

function showUserAckReport() {

    const month = document.getElementById("ack_month").value;
    const year = document.getElementById("ack_year").value;

    if (!month) {
        alert("Please select month");
        return;
    }

    if (!year) {
        alert("Please select year");
        return;
    }


    // Call async function
    BindAckReport_Grid(month, year);
}

async function BindAckReport_Grid(Month, Year) {

    const Title = `Monthly User Performance Acknowledgement Report ${Month}-${Year}`;
    const $table = $('#table_ackUserReport');

    try {
        //Swal.fire({
        //    title: 'Loading...',
        //    text: 'Fetching report data',
        //    allowOutsideClick: false,
        //    didOpen: () => Swal.showLoading()
        //});

        const response = await $.ajax({
            url: "UserPerformanceAckReport.aspx/GetAllMonthlyUserPerformanceAck",
            type: "POST",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            data: JSON.stringify({ Month, Year })
        });

        const dataArray = JSON.parse(response.d || "[]");

        const rows = dataArray.map((value, index) => `
            <tr>
                <td class="text-center">
                    <a href="javascript:void(0);" onclick="GenerateAckPDF(${value.PerformanceID})">
                        <i class="fa fa-download" style=" color:dodgerblue;"></i>
                    </a>
                </td>
                <td class="text-center">${index + 1}</td>
                <td>${blankForNull(value.Code)}</td>
                <td>${blankForNull(value.Name)}</td>
                <td>${blankForNull(value.PseudoName)}</td>
                <td>${blankForNull(value.ReportingManager)}</td>
                <td>${blankForNull(value.SubDomain)}</td>
                <td class="text-center">${blankForNull(value.ProdPerc)}</td>
                <td class="text-center">${blankForNull(value.ProdGrade)}</td>
                <td>${blankForNull(value.ProdRatingCatg)}</td>
                <td class="text-center">${blankForNull(value.QualityPerc)}</td>
                <td class="text-center">${blankForNull(value.QualityGrade)}</td>
                <td>${blankForNull(value.QualityRatingCatg)}</td>
                <td class="text-center">${blankForNull(value.AttendancePerc)}</td>
                <td class="text-center">${blankForNull(value.AttendanceGrade)}</td>
                <td>${blankForNull(value.AttnRatingCatg)}</td>
                <td class="text-center">${blankForNull(value.CriticalErrorCnt)}</td>
                <td class="text-center">${blankForNull(value.NonCriticalErrorCnt)}</td>
                <td class="text-center">${blankForNull(value.Status)}</td>
                <td>${blankForNull(value.AddedDate)}</td>
            </tr>
        `).join('');

        if ($.fn.dataTable.isDataTable($table)) {
            $table.DataTable().clear().destroy();
        }

        $table.find('tbody').html(rows);

        /*  addColumnFilters();*/

        const table = $table.DataTable({
            dom: 'lBftip',
            scrollX: true,
            paging: true,
            autoWidth: false,
            ordering: true,
            processing: true,
            deferRender: true,
            select: { style: 'single' },
            buttons: [
                {
                    extend: 'excelHtml5',
                    title: Title,
                    autoFilter: true
                }
            ],
            initComplete: function () {
                Swal.close();
            }
        });

        applyColumnSearch(table);

    } catch (error) {
        //Swal.close();

        //Swal.fire({
        //    icon: 'error',
        //    title: 'Error',
        //    text: error.responseText || 'Failed to load data'
        //});
    }

    return false;
}

function addColumnFilters() {
    $('#table_ackUserReport thead th').each(function () {
        const title = $(this).text();
        if (title) {
            $(this).html(`${title}<br><input type="text" class="column-search" placeholder="Search" style="width:100%"/>`);
        }
    });
}

function applyColumnSearch(table) {
    table.columns().every(function () {
        const column = this;

        $('input', this.header()).on('keyup change', function () {
            if (column.search() !== this.value) {
                column.search(this.value).draw();
            }
        });
    });
}

/*------------------ PDF Format ---------------*/

function GenerateAckPDF(performanceId) {

    $("#pdfLoader").show();

    const safe = v => (v === undefined || v === null || v === "undefined") ? "" : v;

    $.ajax({
        url: "UserPerformanceAckReport.aspx/GetOverAllUserPerformance_UserPerfAck_Report",
        type: "POST",
        dataType: "json",
        data: JSON.stringify({ PerformanceID: performanceId }),
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = JSON.parse(data.d);

            if (dataArray.length === 0) {
                alert("No data found");
                $('#load1').hide();
                return;
            }

            // 👉 TAKE FIRST RECORD ONLY
            var value = dataArray[0];

            // ✅ SET DATA (SAFE VERSION)

            document.getElementById("userPerfAckPdf_lblTo").innerHTML = safe(value.Code) + " - " + safe(value.EmployeeName);
            document.getElementById("userPerfAckPdf_lblPosition").innerHTML = safe(value.DesignationName);
            document.getElementById("userPerfAckPdf_lblDomain").innerHTML = safe(value.DomainName);

            // ✅ SAFE MONTH (IMPORTANT)
            const month = safe(value.Month);
            const year = safe(value.Year);

            document.getElementById("userPerfAckPdf_lblMonthYear").innerHTML = '<b>' + (month ? month.substring(0, 3) : "") + (year ? "-" + year : "") + '</b>';
            document.getElementById("userPerfAckPdf_lblEmpName").innerHTML = '<b>Dear </b>' + safe(value.F_Name) + ',';
            document.getElementById("userPerfAckPdf_lblQCritical").innerHTML = '(<b>Critical : </b>' + safe(value.CriticalErrorCnt);
            document.getElementById("userPerfAckPdf_lblQNonCritical").innerHTML = '<b>Non-Critical : </b>' + safe(value.NonCriticalErrorCnt) + ')';
            document.getElementById("userPerfAckPdf_lblQuality").innerHTML = safe(value.QualityPerc);
            document.getElementById("userPerfAckPdf_lblQuaRatingCat").innerHTML = safe(value.QualityRatingCatg);
            document.getElementById("userPerfAckPdf_lblAttendance").innerHTML = safe(value.AttendancePerc);
            document.getElementById("userPerfAckPdf_lblAttRatingCat").innerHTML = safe(value.AttnRatingCatg);
            document.getElementById("userPerfAckPdf_lblProductivity").innerHTML = safe(value.ProdPerc);
            document.getElementById("userPerfAckPdf_lblPrRatingCat").innerHTML = safe(value.ProdRatingCatg);

            var element = document.getElementById("div_print");
            element.style.display = "block";

            html2canvas(element, { scale: 2 }).then(canvas => {

                const imgData = canvas.toDataURL('image/png');
                const { jsPDF } = window.jspdf;

                const pdf = new jsPDF('p', 'mm', 'a4');

                var imgWidth = 210;
                var imgHeight = canvas.height * imgWidth / canvas.width;

                pdf.addImage(imgData, 'PNG', 0, 0, imgWidth, imgHeight);

                // ✅ FIXED FILE NAME
                pdf.save("Performance_Acknowledgement_" + value.Code + ".pdf");

                element.style.display = "none";
                $("#pdfLoader").hide();

            });
        },

        error: function () {
            alert("Error generating PDF");
            $("#pdfLoader").hide();

        }
    });
}


