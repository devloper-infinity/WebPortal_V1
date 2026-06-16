<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="NewJoineeHRFollowup.aspx.cs" Inherits="WebPortal.Admin.NewJoineeHRFollowup" %>
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
        $(document).ready(function () {
            Followup_BindYear();
        });
    </script>
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>New Joinee HR Follow up</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <h5 class="card-title"></h5>
                <table class="table">
                    <tr>
                        <td style="width: 50px;"><b>Month:</b></td>
                        <td style="width: 150px;">
                            <select id="followup_month" name="followup_month" class="form-control">
                                <option value="">Select</option>
                                <option value="January">January</option>
                                <option value="February">February</option>
                                <option value="March">March</option>
                                <option value="April">April</option>
                                <option value="May">May</option>
                                <option value="June">June</option>
                                <option value="July">July</option>
                                <option value="August">August</option>
                                <option value="September">September</option>
                                <option value="October">October</option>
                                <option value="November">November</option>
                                <option value="December">December</option>
                            </select>
                        </td>
                        <td style="width: 50px;">
                            <b>Year:</b>
                        </td>
                        <td style="width: 150px;">
                            <select id="followup_year" name="followup_year" class="form-control">
                                <option value="">Select</option>
                            </select>
                        </td>
                        <td style="width: 100px;">
                            <button id="followup_btnShow" class="btn btn-primary" onclick="return followup_Submit()">Show</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <table class="table" id="followup_table" style="padding-top: 10px; width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="display: none;">Employee ID</th>
                            <th class="sort border-top ps-3">Actions</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Employee Name</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Joining Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Contact #</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Designation</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Domain</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Reporting Manager</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Observations of New Joiner by HR</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added By</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="followupremarkpopup">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Observations by HR</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table">
                        <tr>
                            <td><b>Employee Name:</b></td>
                            <td>
                                <label id="followup_empname" class="form-control" style="width: 300px;"></label>
                            </td>
                        </tr>

                        <tr>
                            <td><b>Observations:</b></td>
                            <td>
                                <textarea id="followup_remark" name="followup_remark" class="form-control" style="width: 300px;"></textarea>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button class="btn btn-primary" type="button" id="followup_btnupdateremark" onclick="return followup_updateremark();">Update Remark</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
  
    <div class="modal fade" id="followup_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="followup_errmsg"></h6>
                    <%--<button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>--%>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="followup_btnMessage" onclick="return followup_Message();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>
