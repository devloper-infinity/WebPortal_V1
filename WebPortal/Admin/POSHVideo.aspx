<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="POSHVideo.aspx.cs" Inherits="WebPortal.Admin.POSHVideo" %>

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

        .dataTables_paginate {
            float: left !important;
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
        function gettestlink() {
            var video = document.getElementById("<%= poshvideo.ClientID %>");
            var totaltime = video.duration;
            var currenttime = video.currentTime;

            /* $("#poshvi_dverror").modal('show');*/

            Swal.fire({
                title: 'Completed!',
                html: 'You have successfully completed the video.<br>Please click <b>OK</b> to proceed to the induction test.',
                icon: 'success',
                confirmButtonText: 'OK',
                allowOutsideClick: false
            }).then((result) => {
                if (result.isConfirmed) {
                    // poshvi_Message();  your existing function
                    location.href = "PoshTest.aspx";
                }
            });

            return false;
        }

        function posh_getconfirmation() {
            var video = document.getElementById("<%= poshvideo.ClientID %>");
            var totaltime = video.duration;
            var currenttime = video.currentTime;
            if (currenttime < totaltime) {
                if (confirm("Are you sure you want to leave the page?")) {
                    return true;
                }
                else {
                    return false;
                }
            }
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>POSH Induction Video</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body" style="text-align: center;">
                <span style="color: red; padding-bottom: 5px; font-size: 16px; font-family: biome;">Note: You will be redirected to the induction test after completing the video.</span>
                <video id="poshvideo" src="~/images/Welcome to POSH Awareness Training.mp4" runat="server" width="1000" height="600" onended="gettestlink();" controls controlslist="nodownload" style="border: solid 1px Gray;">
                </video>
            </div>
        </div>
    </div>
    <div class="modal fade" id="poshvi_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="poshvi_errmsg">Thank you for watching complete video. Please click on <b>Okay</b> button below to start the test.
                    </h6>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="poshvi_btnMessage" onclick="return poshvi_Message();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>
