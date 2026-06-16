

function salmaster_bindGrid() {

    $('#load1').show(); // optional loader

    $.ajax({
        url: 'SalarySlipMaster.aspx/GetEmployeeSalarySlip',
        type: "POST",
        contentType: "application/json",

        success: function(data) {
            var dataArray = JSON.parse(data.d);

            // Destroy old DataTable if exists
            if ($.fn.DataTable.isDataTable('#table_SalaryMaster')) {
                $('#table_SalaryMaster').DataTable().clear().destroy();
            }

            $('#table_SalaryMaster tbody').empty();

            $('#table_SalaryMaster').DataTable({
                dom: 'lfrtip',
                data: dataArray,
                scrollX: true,
                paging: true,
                processing: true,
                ordering: false,
                serverSide: false,

                columns: [
                    {
                        data: null,
                        render: function(data, type, row, meta) {
                            return meta.row + 1;
                        }
                    },
                    { data: "BranchName" },
                    { data: "Code" },
                    { data: "FullName" },
                    { data: "CurrentStatus" },
                    { data: "JoiningDate" },
                  /*  { data: "EmailID" },*/
                    { data: "EmailID" },

                    {
                        data: "Month1",
                        render: function(data, type, row) {
                            if (data === "Not Available") {
                                return '<span style="color:gray;">' + data + '</span>';
                            }
                            return '<a href="#" class="salaryPopup" data-month="' + row.M1 + '" data-year="' + row.Year1 + '" data-id="' + row.EmployeeID + '">' + data + '</a>';
                        }
                    },
                    {
                        data: "Month2",
                        render: function(data, type, row) {
                            if (data === "Not Available") {
                                return '<span style="color:gray;">' + data + '</span>';
                            } return '<a href="#" class="salaryPopup" data-month="' + row.M2 + '" data-year="' + row.Year2 + '" data-id="' + row.EmployeeID + '">' + data + '</a>';
                        }
                    },
                    {
                        data: "Month3",
                        render: function(data, type, row) {
                            if (data === "Not Available") {
                                return '<span style="color:gray;">' + data + '</span>';
                            } return '<a href="#" class="salaryPopup" data-month="' + row.M3 + '" " data-year="' + row.Year3 + '" data-id="' + row.EmployeeID + '">' + data + '</a>';
                        }
                    },
                    {
                        data: "Month4",
                        render: function(data, type, row) {
                            if (data === "Not Available") {
                                return '<span style="color:gray;">' + data + '</span>';
                            } return '<a href="#" class="salaryPopup" data-month="' + row.M4 + '"  data-year="' + row.Year4 + '" data-id="' + row.EmployeeID + '">' + data + '</a>';
                        }
                    }
                ],

                initComplete: function() {
                    $('#load1').hide();
                }
            });
        },

        error: function(error) {
            $('#load1').hide();
            alert('Error: ' + error.responseText);
        }
    });
}

$(document).on("click", ".salaryPopup", function(e) {

    e.preventDefault();

    var empId = $(this).data("id");
    var month = $(this).data("month");
    var year = $(this).data("year");

    LoadSalarySlip(empId, month, year);
});

function LoadSalarySlip(empId, month, year) {

    $.ajax({
        type: "POST",
        url: "SalarySlipMaster.aspx/GetEmployeeSalaryInfo",
        data: "{EmployeeID:" + empId + ",Month:'" + month + "',Year:'" + year + "',CompID:" + 1 + "}",
        contentType: "application/json; charset=utf-8",

        success: function(response) {

            var data = JSON.parse(response.d);

            if (data.length > 0) {

                var d = data[0];

                /* COMPANY INFO */
                $('#lblCompanyName').text(d.CompanyName);
                $('#lblCompanyAddress').text(d.Address);
                $('#lblCityPincode').text(d.City + " - " + d.Pincode);
                $('#lblState').text(d.State);
                $('#lblCountry').text(d.Country);
                $('#lblPhoneNo').text(d.ContactNo);
                $('#lblFax').text(d.FaxNo);
                $('#lblSalarymonth').text("Salary for the month of " + month + " - " + year);
                $('#lblBranch').text(d.HeadOffice);

                /* EMPLOYEE INFO */
                $('#lblCode').text(d.Code);
                $('#lblBranch').text(d.Branch);
                $('#lblName').text(d.Name);
                $('#lbldepartment').text(d.DepartmentName);
                $('#lblESICNo').text(d.ESICNo);
                $('#lblDesignation').text(d.DesignationName);
                $('#lblPfNo').text(d.PFNo);
                $('#lblTotalDays').text(d.TotalDays);


                /* EARNINGS */
                $('#lblbasicDA').text(d.BasicDA);
                $('#lblBasicDA1').text(d.BasicDA1);

                $('#lblHRA').text(d.HRA);
                $('#lblHRA1').text(d.HRA1);

                $('#lblMedicle').text(d.Medical);
                $('#lblMedicle1').text(d.Medical1);

                $('#lblTransportAllowance').text(d.TransportAllowance);
                $('#lblTransportAllowance1').text(d.TransportAllowance1);

                $('#lblEducationAllowance').text(d.EducationAllowance);
                $('#lblEducationAllowance1').text(d.EducationAllowance1);

                $('#lblHostelAllowance').text(d.HostelAllowance);
                $('#lblHostelAllowance1').text(d.HostelAllowance1);

                $('#lblAttendanceBonus').text(d.AttendanceBonus);
                $('#lblAttendanceBonus1').text(d.AttendanceBonus1);

                $('#lblQualityBonus').text(d.QualityBonus);
                $('#lblQualityBonus1').text(d.QualityBonus1);

                $('#lblSalary').text(d.Salary);
                $('#lblTotalDueSalary').text(d.DueSalary);


                /* DEDUCTIONS */

                $('#lblAdvances').text(d.Advances);
                $('#lblBonus').text(d.Bonus);
                $('#lblESI').text(d.ESI);
                $('#lblIncentive').text(d.Incentive);
                $('#lblPF').text(d.PF);
                $('#lblAllowences').text(d.Allowences);
                $('#lblMLWF').text(d.MLWF);
                $('#lblSalaryArrears').text(d.SalaryArrears);
                $('#lblProfTax').text(d.ProfTax);
                $('#lblDeduction').text(d.Deduction);
                $('#lblOther').text(d.Other);
                $('#lblTDS').text(d.TDS);

                $('#lblTotalDeduction').text(d.TotalDeduction);
                $('#lblNetSalary').text(d.NetSalary);


                /* OPTIONAL FIELD VISIBILITY */
                if (d.Medical > 0) $('#mr').show();
                if (d.TransportAllowance > 0) $('#tr').show();
                if (d.EducationAllowance > 0) $('#ea').show();
                if (d.HostelAllowance > 0) $('#ha').show();


                /* OPEN POPUP */

                $('#popUpSalarySlip').modal('show');

            }

            else {
                alert("Salary slip is not availabe.");
                $('#popUpSalarySlip').modal('hide');
            }
        }
    });
}

function printSlip() {

    var divContents = document.getElementById("divsal").innerHTML;
    var a = window.open('', '', 'height=700, width=900, font - size: 12px');

    a.document.write('<html>');
    a.document.write('<head></head>');
    /* a.document.write('');*/
    a.document.write('<body>');
    a.document.write(divContents);
    a.document.write('</body></html>');

    a.document.close();
    a.print();
}

