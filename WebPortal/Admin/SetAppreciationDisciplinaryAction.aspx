<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="SetAppreciationDisciplinaryAction.aspx.cs" Inherits="WebPortal.Admin.SetAppreciationDisciplinaryAction" %>

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

        div.dt-buttons {
            position: static;
            padding-left: 50px;
            float: left;
        }

        .buttons-excel {
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
            /*background:linear-gradient(to bottom, #0070C0, 80%, #ffffff);*/
            background: linear-gradient(to bottom, #cbd0dd, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none;
        }
        /*.form-control {
            font-size: 11px !important;
        }*/
    </style>
    <script>
        $(document).ready(function () {
            CKEDITOR.replace('setappr_description');
            setappr_BindUsers();
            setappr_bindgrid();
        });
    </script>
    <script src="../ckeditor/ckeditor.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Set Appreciation and Disciplinary Action</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <table class="table">
                    <tr>
                        <td><b>Employee:</b></td>
                        <td>
                            <label id="setappr_apprid" style="display: none;"></label>
                            <select id="setappr_employee" name="setappr_employee" class="form-control" style="width: 250px;" onchange="setappr_getEmpInfo(this);"></select>
                        </td>
                        <td><b>Name:</b></td>
                        <td>
                            <label id="setappr_empname" class="form-control" style="width: 250px; font-weight: normal;"></label>
                        </td>
                        <td><b>Joining Date:</b></td>
                        <td>
                            <label id="setappr_joiningdate" class="form-control" style="width: 250px; font-weight: normal;"></label>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Department:</b></td>
                        <td>
                            <label id="setappr_department" class="form-control" style="width: 250px; font-weight: normal;"></label>
                        </td>
                        <td><b>Designation:</b></td>
                        <td>
                            <label id="setappr_designation" class="form-control" style="width: 250px; font-weight: normal;"></label>
                        </td>
                        <td><b>Reporting Manager:</b></td>
                        <td>
                            <label id="setappr_repotingmanager" class="form-control" style="width: 250px; font-weight: normal;"></label>
                        </td>
                    </tr>
                </table>
                <hr />
                <h6 class="uil uil-0-plus">&nbsp;Appreciation/ Disciplinary Action</h6>
                <table class="table">
                    <tr>
                        <td><b>Type:</b></td>
                        <td>
                            <select id="setappr_type" name="setappr_type" class="form-control" style="width: 300px;" onchange="setappr_getApprTitle(this);">
                                <option value="">Select</option>
                                <option value="Appreciation">Appreciation</option>
                                <option value="DisciplinaryAction">Disciplinary Action</option>
                                <option value="PerformanceImprovementPlan">Performance Improvement Plan</option>
                            </select>
                        </td>
                        <td><b>Title:</b></td>
                        <td>
                            <select id="setappr_title" name="setappr_title" class="form-control" style="width: 300px;" onchange="setappr_getApprDesc(this);"></select>
                        </td>
                    </tr>
                    <tr id="setappr_trother" style="display: none;">
                        <td id="setappr_tdperiodheader"><b>Period:</b></td>
                        <td id="setappr_tdperiodrow">
                            <select id="setappr_period" name="setappr_period" class="form-control" style="width: 300px;"></select>
                        </td>
                        <td id="setappr_tdeffectivedateheader"><b>Effective Date:</b></td>
                        <td id="setappr_tdeffectivedaterow">
                            <input type="date" id="setappr_effectivedate" name="setappr_effectivedate" class="form-control" style="width: 300px;" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Description:</b></td>
                        <td colspan="3">
                            <input type="text" id="setappr_description" name="setappr_description" class="ckeditor" style="width: 500px;" />

                        </td>
                    </tr>
                    <tr>
                        <td colspan="4" style="text-align: center;">
                            <button id="setappr_btnpreview" name="setappr_btnsubmit" class="btn btn-primary" onclick="return setappr_preview();">Preview</button>
                            <button id="setappr_btnsubmit" name="setappr_btnsubmit" class="btn btn-primary" onclick="return setappr_submit();">Submit</button>
                        </td>
                    </tr>
                </table>

                <hr />
                <h5 class="uil uil-file-block-alt">Appreciation/ Disciplinary Action Details</h5>

                <div class="row mb-3" style="margin-bottom: 10px;">
                    <div class="col-md-3">
                        <label>Year</label>
                        <select id="filterYear" class="form-control">
                            <option value="">All Years</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label>Month</label>
                        <select id="filterMonth" class="form-control">
                            <option value="">All Months</option>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label>Location</label>
                        <select id="filterLocation" class="form-control">
                            <option value="">All Locations</option>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label>Department</label>
                        <select id="filterDepartment" class="form-control">
                            <option value="">All Departments</option>
                        </select>
                    </div>

                </div>
                <table class="table" id="setappr_gr_table" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Joining Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Department</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Designation</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Reporting Manager</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Action Month</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Action Year</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Appreciation</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Warnings</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">PIP</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="modal fade" id="setappr_previewpop">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Preview</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="col-lg-12">
                        <div class="row">
                            <div class="col-md-10">
                                <table>
                                    <tr style="display: none;">
                                        <td><b>Code:</b>&nbsp;<label id="setappr_popcode"></label></td>

                                    </tr>
                                    <tr>
                                        <td><b>Name:</b>&nbsp;<label id="setappr_popname"></label></td>
                                    </tr>
                                    <tr>
                                        <td><b>Joining Date:</b>&nbsp;<label id="setappr_popdoj"></label></td>
                                    </tr>
                                    <tr style="display: none;">
                                        <td><b>Location:</b>&nbsp;<label id="setappr_poplocation"></label></td>
                                    </tr>
                                </table>
                            </div>
                            <div class="col-md-2">
                                <b>Date:</b> &nbsp;<label id="setappr_popdate"></label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12" style="text-align: center;">
                                <hr />
                                <h5 id="setappr_popsubject"></h5>
                                <hr />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <hr />
                                <label id="setappr_popdesc"></label>
                            </div>
                        </div>
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
    <div class="modal fade" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">System is updating details. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>
    <div class="modal fade" id="setappr_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="setappr_errmsg"></h6>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="setappr_btnMessage" onclick="location.reload();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

    <div class="modal fade" id="setappr_viewdetails">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="setappr_detailsheader">Preview</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
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
