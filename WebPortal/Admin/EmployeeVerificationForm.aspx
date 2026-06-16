<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EmployeeVerificationForm.aspx.cs" Inherits="WebPortal.Admin.EmployeeVerificationForm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .loading {
            display: none;
            position: fixed;
            top: 350px;
            left: 50%;
            margin-top: -96px;
            margin-left: -96px;
            /*  background-color: #ccc;*/
            opacity: .85;
            border-radius: 25px;
            width: 192px;
            height: 192px;
            z-index: 99999;
        }

        /*.form-control {
            font-size: 11px !important;
        }*/
    </style>

    <script>
        window.onload = function () {
            document.getElementById('ExEmpForm_attachment').addEventListener('change', getFileName);
        }
        const getFileName = (event) => {
            const files = event.target.files;
            var file = files[0];
            document.getElementById("filep").value = files[0].name;

            const fd = new FormData();

            // add all selected files
            fd.append(event.target.name, file, file.name);
            // create the request
            const xhr = new XMLHttpRequest();

            xhr.onload = () => {
                if (xhr.status >= 200 && xhr.status < 300) {
                    // we done!
                }
            };
            var url = window.location.href;
            // path to server would be where you'd normally post the form to
            xhr.open('POST', url, true);
            xhr.send(fd);
            document.getElementById("dropzone").classList.add("dz-max-files-reached");
            document.getElementById("conentdiv").style.display = '';
            document.getElementById("filesdiv").innerHTML = file.name;
        }

        $(document).ready(function () {
            BindFormInformation();
        });

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="filep" style="display: none;" />
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Ex Employer Verification Form</b></h6>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right" style="font-size: 12px; font-weight: bold;">
                        <li class="breadcrumb-item"><a href="#utl" id="aBack" runat="server" style="color: saddlebrown" onclick="window.history.go(-1); return false;"><< Go back </a></li>
                    </ol>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <h5 class="card-title"></h5>
                <div class="card card-primary card-outline">
                    <div class="card-header">
                        <div class="card-title">
                            <i class="fas fa-edit"></i>
                            Basic Details:
                        </div>
                    </div>
                    <table class="table">
                        <tr>
                            <td><b>Employee:</b></td>
                            <td>
                                <label id="ExEmpForm_name" name="ExEmpForm_name" class="form-control" style="width: 350px"></label>
                            </td>
                            <td><b>Name of Organiation:</b></td>
                            <td>
                                <input type="text" id="ExEmpForm_organizationname" name="ExEmpForm_organizationname" class="form-control" style="width: 350px;" />
                            </td>
                        </tr>
                        <tr>
                            <td><b>Candidate Name:</b></td>
                            <td>
                                <input type="text" id="ExEmpForm_candidatename" name="ExEmpForm_candidatename" class="form-control" style="width: 350px;" />
                            </td>
                            <td><b>Employee ID/Code:</b></td>
                            <td>
                                <input type="text" id="ExEmpForm_employeeid" name="ExEmpForm_employeeid" class="form-control" style="width: 350px;" />
                            </td>
                        </tr>
                        <tr>
                            <td><b>Designation:</b></td>
                            <td>
                                <input type="text" id="ExEmpForm_designation" name="ExEmpForm_designation" class="form-control" style="width: 350px;" />
                            </td>
                            <td><b>Period of Employment:</b></td>
                            <td>
                                <input type="text" id="ExEmpForm_employmentperiod" name="ExEmpForm_employmentperiod" class="form-control" style="width: 350px;" />
                            </td>
                        </tr>
                        <tr>
                            <td><b>Salary:</b></td>
                            <td>
                                <input type="text" id="ExEmpForm_salary" name="ExEmpForm_salary" class="form-control" style="width: 350px;" />
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                    </table>
                </div>
                <div class="card card-primary card-outline">
                    <div class="card-header">
                        <div class="card-title">
                            <i class="fas fa-edit"></i>
                            Reporting Manager Details:
                        </div>
                    </div>
                    <table class="table">
                        <tr>
                            <td><b>Name:</b></td>
                            <td>
                                <input type="text" id="ExEmpForm_reportingmanager" name="ExEmpForm_reportingmanager" class="form-control" style="width: 350px;" />
                            </td>
                            <td><b>Designation:</b></td>
                            <td>
                                <input type="text" id="ExEmpForm_reportingdesignation" name="ExEmpForm_reportingdesignation" class="form-control" style="width: 350px;" />
                            </td>
                        </tr>
                        <tr>
                            <td><b>Contact No. & E-Mail:</b></td>
                            <td>
                                <textarea type="text" id="ExEmpForm_reportingmanageremail" name="ExEmpForm_reportingmanageremail" class="form-control" style="width: 350px;"></textarea>
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                    </table>
                </div>
                <div class="card card-primary card-outline">
                    <div class="card-header">
                        <div class="card-title">
                            <i class="fas fa-edit"></i>
                            HR Related Details:
                        </div>
                    </div>
                    <table class="table">
                        <tr>
                            <td><b>HR Name:</b></td>
                            <td>
                                <input type="text" id="ExEmpForm_hrname" name="ExEmpForm_hrname" class="form-control" style="width: 350px;" />
                            </td>
                            <td><b>Contact No. & E-Mail:</b></td>
                            <td>
                                <input type="text" id="ExEmpForm_hremail" name="ExEmpForm_hremail" class="form-control" style="width: 350px;" />
                            </td>
                        </tr>
                        <tr>
                            <td><b>Reason for Leaving the Organization:</b></td>
                            <td>
                                <textarea type="text" id="ExEmpForm_reasonforleaving" name="ExEmpForm_reasonforleaving" class="form-control" style="width: 350px;"></textarea>
                            </td>
                            <td><b>Any Exit Formalities Pending:(YES/NO):</b></td>
                            <td>
                                <input type="text" id="ExEmpForm_exitformality" name="ExEmpForm_exitformality" class="form-control" style="width: 350px;" />
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 250px;"><b>Eligible for rehire (Based on job performance) (If No, please Specify Reason):</b></td>
                            <td>
                                <textarea type="text" id="ExEmpForm_eligibility" name="ExEmpForm_eligibility" class="form-control" style="width: 350px;"></textarea>
                            </td>
                            <td><b>Verified by (Name & Designation):</b>
                            </td>
                            <td>
                                <input type="text" id="ExEmpForm_verifiedby" name="ExEmpForm_verifiedby" class="form-control" style="width: 350px;" />
                            </td>
                        </tr>
                        <tr>
                            <td><b>Receiver Email Address:</b></td>
                            <td>
                                <input type="email" id="ExEmpForm_receiver" name="ExEmpForm_receiver" class="form-control" style="width: 350px;" />
                            </td>
                            <td><b>Attachment:</b></td>
                            <td>
                                <input type="file" id="ExEmpForm_attachment" name="ExEmpForm_attachment" class="form-control" style="width: 350px;" />
                                <div class="dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete" id="dropzone">
                                    <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column" id="conentdiv" style="display: none!important;">

                                        <div class="flex-1 d-flex flex-between-center">
                                            <div id="filesdiv" style="margin-top: 10px; margin-bottom: 10px;"></div>
                                            <div class="dropdown font-sans-serif">
                                                <button class="btn btn-link text-600 btn-sm dropdown-toggle btn-reveal dropdown-caret-none" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                    <svg class="svg-inline--fa fa-ellipsis" style="display: none!important" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="ellipsis" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg="">
                                                        <path fill="currentColor" d="M120 256C120 286.9 94.93 312 64 312C33.07 312 8 286.9 8 256C8 225.1 33.07 200 64 200C94.93 200 120 225.1 120 256zM280 256C280 286.9 254.9 312 224 312C193.1 312 168 286.9 168 256C168 225.1 193.1 200 224 200C254.9 200 280 225.1 280 256zM328 256C328 225.1 353.1 200 384 200C414.9 200 440 225.1 440 256C440 286.9 414.9 312 384 312C353.1 312 328 286.9 328 256z"></path></svg><!-- <span class="fas fa-ellipsis-h"></span> Font Awesome fontawesome.com --></button>
                                                <div class="dropdown-menu dropdown-menu-end border py-2"><a class="dropdown-item" href="#!" data-dz-remove="data-dz-remove">Remove File</a></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" align="center">
                                <button id="ExEmpForm_btnSubmit" class="btn btn-primary" onclick="return ExEmpForm_SubmitData();">Submit</button>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="form_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="form_errmsg"></h6>
                    <%--<button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>--%>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="btnMessage" onclick="return ExForm_Message();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>
