<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="UserAppreciationDisciplinaryActionReport.aspx.cs" Inherits="WebPortal.Admin.UserAppreciationDisciplinaryActionReport" %>

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
    <style>
        /* ===================================
   CLEAN MODERN SLIDER ICONS (FIXED)
   =================================== */

        /* Reset Bootstrap default icons */
        /*#carouselExampleIndicatorsUser .carousel-control-prev-icon,
        #carouselExampleIndicatorsUser .carousel-control-next-icon {
            background-image: none !important;
            width: 18px;
            height: 18px;
        }*/

        /* Arrow container */
        /*#carouselExampleIndicatorsUser .carousel-control-prev,
        #carouselExampleIndicatorsUser .carousel-control-next {
            width: 36px;
            height: 36px;
            background: #ffffff;
            border-radius: 50%;
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.12);
            opacity: 1;
        }*/

        /* Chevron arrow */
        /*#carouselExampleIndicatorsUser .carousel-control-prev-icon::before,
        #carouselExampleIndicatorsUser .carousel-control-next-icon::before {
            content: '';
            display: block;
            width: 9px;
            height: 9px;
            border-top: 2px solid #374151;
            border-right: 2px solid #374151;
            position: absolute;
            top: 50%;
            left: 50%;
        }*/

        /* Left arrow */
        /*#carouselExampleIndicatorsUser .carousel-control-prev-icon::before {
            transform: translate(-50%, -50%) rotate(-135deg);
        }*/

        /* Right arrow */
        /*#carouselExampleIndicatorsUser .carousel-control-next-icon::before {
            transform: translate(-50%, -50%) rotate(45deg);
        }*/

        /* Hover polish */
        /*#carouselExampleIndicatorsUser .carousel-control-prev:hover,
        #carouselExampleIndicatorsUser .carousel-control-next:hover {
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.16);
        }*/
    </style>

    <script>
        $(document).ready(function () {
            // CKEDITOR.replace('userappr_description');
            userappr_bindgrid();
        });
    </script>
    <script src="../ckeditor/ckeditor.js"></script>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Appreciation and Disciplinary Action Report</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <table class="table" id="userappr_gr_table" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Joining Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Department</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Designation</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Reporting Manager</th>
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
    <div class="modal fade" id="userappr_previewpop">
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
                                        <td><b>Code:</b>&nbsp;<label id="userappr_popcode"></label></td>

                                    </tr>
                                    <tr>
                                        <td><b>Name:</b>&nbsp;<label id="userappr_popname"></label></td>
                                    </tr>
                                    <tr>
                                        <td><b>Joining Date:</b>&nbsp;<label id="userappr_popdoj"></label></td>
                                    </tr>
                                    <tr style="display: none;">
                                        <td><b>Location:</b>&nbsp;<label id="userappr_poplocation"></label></td>
                                    </tr>
                                </table>
                            </div>
                            <div class="col-md-2">
                                <b>Date:</b> &nbsp;<label id="userappr_popdate"></label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12" style="text-align: center;">
                                <hr />
                                <h5 id="userappr_popsubject"></h5>
                                <hr />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <hr />
                                <label id="userappr_popdesc"></label>
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


    <div class="modal fade" id="userappr_viewdetails">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="userappr_detailsheader">Preview</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="dvUserslidermain">
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

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

    <%--  <link href="../ckeditor/contents.css" rel="stylesheet" />--%>
</asp:Content>
