<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="RewardAndRecognition.aspx.cs" Inherits="WebPortal.Admin.RewardAndRecognition" %>

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

        .dataTables_length, .dataTables_info {
            float: left !important;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: normal !important;
            border: none !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 50px;
            float: left;
        }

        .buttons-excel, .buttons-html5 {
            color: #fff;
            /*     background-color: #28a745;
            border-color: #28a745;*/
            box-shadow: none;
            background: linear-gradient(to right, #ffbf96, #fe7096);
            border: 0;
            font-weight: bold;
            margin: 0px 10px;
        }

        .table.dataTable th {
            background: linear-gradient(to bottom, #007bff, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
        }

        /*.form-control {
            font-size: 11px !important;
        }*/
    </style>
    <script>

        var fileslist = '';
        var fd = new FormData();
        window.onload = function () {
            document.getElementById('RewardRecg_attachment').addEventListener('change', getFileName);
        }
        const getFileName = (event) => {

            for (var i = 0; i < event.target.files.length; i++) {
                const files = event.target.files;
                var file = files[i];
                document.getElementById("RewardRecg_file").value = files[i].name;
                if (fileslist != '')
                    fileslist = fileslist + ',' + file.name;
                else
                    fileslist = file.name;
                // add all selected files
                fd.append(event.target.name, file, file.name);
                // create the request

            }
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
            document.getElementById("filesdiv").innerHTML = fileslist;
        }

        $(document).ready(function () {

            rnr_BindYear();
            rnr_bindusers();
            rnr_bidgrid();
            rnr_bindbranches();
            rnr_snap_binddata();
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="RewardRecg_file" style="display: none;" />
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Reward and Recognition</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <div class="card card-tabs">
                    <div class="card-header p-0 pt-1">
                        <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="custom-tabs-one-rnr_emp-tab" data-toggle="pill" href="#custom-tabs-one-rnr_emp" role="tab" aria-controls="custom-tabs-one-rnr_emp" aria-selected="true"><b>Add Employee</b></a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-rnr_snap-tab" data-toggle="pill" href="#custom-tabs-one-rnr_snap" role="tab" aria-controls="custom-tabs-one-rnr_snap" aria-selected="false"><b>Add Snaps</b></a>
                            </li>
                        </ul>
                    </div>

                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-rnr_emp" role="tabpanel" aria-labelledby="custom-tabs-one-rnr_emp-tab">
                                <h5 class="card-title"></h5>
                                <table class="table">
                                    <tr>
                                        <td><b>Year:</b></td>
                                        <td>
                                            <select id="rnr_year" name="rnr_year" class="form-control" style="width: 350px;">
                                                <option value="">Select</option>
                                            </select>
                                        </td>
                                        <td><b>Quarter:</b></td>
                                        <td>
                                            <select id="rnr_quarter" name="rnr_quarter" class="form-control" style="width: 350px;">
                                                <option value="">Select</option>
                                                <option value="January ~ March">January ~ March</option>
                                                <option value="April ~ June">April ~ June</option>
                                                <option value="July ~ September">July ~ September</option>
                                                <option value="October ~ December">October ~ December</option>
                                            </select>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td><b>Employee:</b></td>
                                        <td>
                                            <select id="rnr_employee" name="rnr_employee" class="form-control" style="width: 350px;"></select>
                                        </td>
                                        <td></td>
                                        <td>
                                            <button id="rnr_btnsubmit" class="btn btn-primary" onclick="return rnr_Submit();">Submit</button>
                                        </td>
                                    </tr>
                                </table>
                                <hr />
                                <table class="table" id="rnr_table">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Quarter</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Employee Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Joining Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Date Of Birth</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Domain</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Subdomain</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Department</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Designation</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Reporting Manager</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Current Status</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Latest Working Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Productivity/Task</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Final Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    </tbody>
                                </table>
                            </div>

                            <div class="tab-pane fade show fade" id="custom-tabs-one-rnr_snap" role="tabpanel" aria-labelledby="custom-tabs-one-rnr_snap-tab">
                                <table class="table">
                                    <tr>
                                        <td><b>Year:</b></td>
                                        <td>
                                            <select id="rnrSnap_year" name="rnrSnap_year" class="form-control" style="width: 350px;">
                                                <option value="">Select</option>
                                            </select>
                                        </td>
                                        <td><b>Quarter:</b></td>
                                        <td>
                                            <select id="rnrSnap_quarter" name="rnrSnap_quarter" class="form-control" style="width: 350px;">
                                                <option value="Select">Select</option>
                                                <option value="January ~ March">January ~ March</option>
                                                <option value="April ~ June">April ~ June</option>
                                                <option value="July ~ September">July ~ September</option>
                                                <option value="October ~ December">October ~ December</option>
                                            </select>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td><b>Location:</b></td>
                                        <td>
                                            <select id="rnrSnap_location" name="rnrSnap_location" class="form-control" style="width: 350px;"></select>
                                        </td>
                                        <td><b>Snaps:</b></td>
                                        <td>
                                            <input type="file" id="RewardRecg_attachment" name="RewardRecg_attachment" class="form-control" style="width: 350px;" multiple />
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
                                        <td>
                                            <button id="rnrSnap_btnsubmit" class="btn btn-primary" onclick="return rnrSnap_Submit();">Submit</button>
                                        </td>
                                    </tr>
                                </table>
                                <hr style="border-top: solid 2px Black;" />
                                <table class="table" id="table_rnr_snap" style="padding-top: 10px; width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Action</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Location</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Year</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Quarter</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Uploaded By</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Uploaded Date</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <div class="modal fade" id="rnr_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="rnr_errmsg"></h6>
                    <%--<button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>--%>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="followup_btnMessage" onclick="return rnr_Message();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

    <div class="modal fade" id="rnr_snap_display">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header" style="background-color: azure;">
                    <%--<h6 class="modal-title" id="setappr_detailsheader"> </h6>--%>
                    <label id="displayrnr_snap_Header" name="displayrnr_snap_Header" style="font-weight: bolder; font-size: 18px;" color="white"></label>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <%--  <img class="d-block w-100" src="../images/snap2.jpg" alt="First slide">--%>
                    <div id="dvslidermain">
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

    <link href="../ckeditor/contents.css" rel="stylesheet" />
</asp:Content>
