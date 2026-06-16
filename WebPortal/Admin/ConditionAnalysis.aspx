<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ConditionAnalysis.aspx.cs" Inherits="WebPortal.Admin.ConditionAnalysis" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        .loading {
            display: none;
            position: fixed;
            top: 350px;
            left: 50%;
            margin-top: -96px;
            margin-left: -96px;
            opacity: .85;
            border-radius: 25px;
            width: 192px;
            height: 192px;
            z-index: 99999;
        }

        .dataTables_scrollBody {
            min-height: 100px !important;
            height: auto;
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
            box-shadow: none;
            background: linear-gradient(to right, #ffbf96, #fe7096);
            border: 0;
            font-weight: bold;
            margin: 0px 10px;
        }

        .table.dataTable th {
            white-space: nowrap;
            color: #000;
        }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
        }

        #table_conAnalysis_wrapper {
            width: 100% !important;
        }

        #table_conAnalysis {
            width: 100% !important;
        }

        .swal2-container {
            z-index: 200000 !important;
        }
    </style>

    <script>

        $(document).ready(function () {

            condAnalysis_bindGrid();
        });

    </script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="usload1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Condition Analysis</b></h6>
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <table class="table" style="width: 100%;" id="table_conAnalysis">
                    <thead></thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Analysis Modal -->
    <div id="popUp_addResponse" class="custom-modal">
        <div class="custom-modal-content">

            <div class="custom-modal-header">
                <h5>Analysis Condition Of :<span id="ana_popupheader" style="font-weight: normal; font-size: 18px!important;"></span></h5>
             <%--   <span class="close-btn" onclick="closeAnalysisModal()">&times;</span>--%>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="color: white;">
                    <span aria-hidden="true" onclick="closeAnalysisModal()">&times;</span>
                </button>
            </div>

            <div class="custom-modal-body">
                <div class="analysiscon-container">
                    <!-- Row -->
                    <div class="my-row">
                        <div class="my-col-4">
                            <label><b>Received Date</b></label>
                            <input type="date" class="my-input" id="ana_receivedDate" readonly>
                        </div>

                        <div class="my-col-4">
                            <label><b>Process</b></label>
                            <input type="text" class="my-input" id="ana_process" readonly>
                        </div>

                        <div class="my-col-4">
                            <label><b>Initial Exception Grade</b></label>
                            <input type="text" class="my-input" id="ana_initGrade" readonly>
                        </div>
                    </div>

                    <!-- Infinity Condition -->
                    <div class="my-row">
                        <div class="my-col-12">
                            <label><b>Infinity Condition</b></label>
                            <textarea class="my-textarea" id="ana_infCondition" readonly></textarea>
                        </div>
                    </div>

                    <!-- Clients Rebuttal -->
                    <div class="my-row">
                        <div class="my-col-12">
                            <label><b>Clients Rebuttal</b></label>
                            <textarea class="my-textarea" id="ana_rebuttal"></textarea>
                        </div>
                    </div>

                    <div class="section-title-line">
                        <i class="uil uil-pen"></i>
                        <span>Infinity Response</span>
                    </div>
                    <div class="card-blue card-outline" style="padding-bottom: 1%;"></div>

                    <!-- Row -->
                    <div class="my-row">
                        <div class="my-col-4">
                            <label><b>Reviewed Date</b></label>
                            <input type="date" class="my-input" id="ana_reviewDate">
                        </div>

                        <div class="my-col-4">
                            <label><b>Resolved</b></label>
                            <select class="my-select" id="ana_resolved">
                                <option value="">Select</option>
                                <option value="Yes">Yes</option>
                                <option value="No">No</option>
                            </select>
                        </div>

                        <div class="my-col-4">
                            <label><b>Final Exception Grade</b></label>
                            <select class="my-select" id="ana_finalGrade">
                                <option value="">Select</option>
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="4">4</option>
                            </select>
                        </div>
                        <%--</div>

  <!-- Total Time -->
  <div class="my-row">--%>
                        <%-- <div class="my-col-3">
          <label><b>Total Time (in Mins)</b></label>
          <input type="time" class="my-input" id="ana_totaltime" step="60">
      </div>--%>
                    </div>

                    <!-- Infinity Response -->
                    <div class="my-row">
                        <div class="my-col-12">
                            <label><b>Comment</b></label>
                            <textarea class="my-textarea" id="ana_response"></textarea>
                        </div>
                    </div>

                    <!-- Buttons -->
                    <div class="my-row">
                        <div class="my-col-12" style="text-align: right;">
                            <button type="button" class="my-btn success" onclick="return ana_endAnalysis();">End Analysis</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style>
        /* Modal Background */
        .custom-modal {
            display: none;
            position: fixed;
            z-index: 9999;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.4);
        }

        /* Modal Box */
        .custom-modal-content {
            background-color: #fff;
            margin: 5% auto;
            width: 70%;
            border-radius: 6px;
            box-shadow: 0 0 10px rgba(0,0,0,0.3);
        }

        /* Header */
        .custom-modal-header {
            padding: 10px;
            /* background: #e9e9e9;*/
            background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;
            font-weight: bold;
            display: flex;
            font-size: 16px;
            color: white;
            justify-content: space-between;
        }

        /* Body */
        .custom-modal-body {
            padding: 15px;
            padding-left: 3%;
        }

        .label {
            font-weight: bold;
        }

        /* Close Button */
        .close-btn {
            cursor: pointer;
            font-size: 20px;
        }

        /* Grid Layout */
        .my-row {
            display: flex;
            flex-wrap: wrap;
            margin-bottom: 10px;
        }

        .my-col-3 {
            width: 25%;
            padding-right: 15px;
        }

        .my-col-4 {
            width: 33%;
            padding-right: 15px;
        }

        .my-col-6 {
            width: 50%;
            padding-right: 15px;
        }

        .my-col-12 {
            width: 98%;
        }

        /* Inputs */
        .my-input, .my-select {
            width: 100%;
            height: 30px;
            border: 1px solid #cfcfcf;
            padding: 4px;
            border-radius: 3px;
            font-size: 12px;
        }

        .my-textarea {
            width: 100%;
            height: 60px;
            border: 1px solid #cfcfcf;
            padding: 5px;
            border-radius: 3px;
            resize: none;
        }

            .my-input:focus, .my-select:focus, .my-textarea:focus {
                border-color: #b5d3ff;
                box-shadow: 0 0 3px rgba(181,211,255,0.7);
                outline: none;
            }

        /* Buttons */
        .my-btn {
            padding: 6px 18px;
            border: none;
            border-radius: 4px;
            color: white;
            margin-right: 10px;
        }

        .primary {
            background: #6c757d;
        }

        .success {
            background: #5cb85c;
        }
    </style>

    <style>
        .section-title-line {
            display: flex;
            align-items: center;
            font-size: 14px;
            font-weight: 600;
            margin: 18px 5px 10px 5px;
            color: #2c2c2c;
        }

            .section-title-line i {
                margin-right: 8px;
                font-size: 15px;
            }
    </style>

</asp:Content>
