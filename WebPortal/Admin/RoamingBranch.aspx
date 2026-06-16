<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="RoamingBranch.aspx.cs" Inherits="WebPortal.Admin.RoamingBranch" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        $(document).ready(function () {
            roam_bindbranches();
            roam_bindemployee();
            roam_Binddata();
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        body {
            background: #f4f7fb;
        }

        .dashboard-header {
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            border-radius: 15px;
            padding: 12px 18px;
            color: white;
            position: relative;
            overflow: hidden;
            margin-bottom: 25px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        }

        .dashboard-header::after {
            content: '';
            position: absolute;
            right: -70px;
            top: -50px;
            width: 220px;
            height: 220px;
            background: rgba(255,255,255,0.12);
            border-radius: 50%;
        }

        .dashboard-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 5px;
            position: relative;
            z-index: 1;
        }

        .dashboard-subtitle {
            font-size: 12px;
            opacity: 0.9;
            position: relative;
            z-index: 1;
        }

        .roam-page-wrapper {
            padding: 15px;
        }

        .summary-card,
        .filter-card,
        .data-card {
            background: #fff;
            border: 0;
            border-radius: 16px;
            box-shadow: 0 8px 22px rgba(31, 60, 136, 0.08);
        }

        .summary-card {
            padding: 18px;
            height: 100%;
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .summary-icon {
            width: 46px;
            height: 46px;
            border-radius: 14px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: #eef4ff;
            color: #1f3c88;
            font-size: 19px;
        }

        .summary-label {
            color: #6c7890;
            font-size: 12px;
            margin-bottom: 3px;
        }

        .summary-value {
            color: #1f2d3d;
            font-size: 18px;
            font-weight: 700;
            line-height: 1.1;
        }

        .section-title {
            color: #1f3c88;
            font-size: 15px;
            font-weight: 700;
            margin-bottom: 14px;
        }

        .section-title i {
            margin-right: 7px;
        }

        .filter-card .form-control {
            border-radius: 10px;
            min-height: 40px;
            border: 1px solid #dbe5f3;
        }

        .filter-card label {
            color: #334155;
            font-size: 13px;
            margin-bottom: 6px;
        }

        .btn-gradient {
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            color: #fff !important;
            border: none;
            border-radius: 10px;
            padding: 9px 22px;
            font-weight: 600;
            box-shadow: 0 7px 14px rgba(37, 117, 252, .24);
        }

        .btn-gradient:hover {
            color: #fff;
            transform: translateY(-1px);
        }

        .btn-soft {
            background: #eef4ff;
            color: #1f3c88;
            border: 1px solid #d9e6ff;
            border-radius: 10px;
            padding: 9px 18px;
            font-weight: 600;
        }

        .table-toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
            margin-bottom: 12px;
        }

        .table-responsive-modern {
            border: 1px solid #e6edf7;
            border-radius: 14px;
            overflow: hidden;
        }

        #roam_table {
            margin-bottom: 0;
        }

        #roam_table thead th {
            background: #eef4ff;
            color: #1f3c88;
            font-size: 13px;
            font-weight: 700;
            border-bottom: 1px solid #d9e6ff;
            vertical-align: middle;
            white-space: nowrap;
        }

        #roam_table tbody td {
            vertical-align: middle;
            font-size: 13px;
            color: #334155;
            border-top: 1px solid #edf2f7;
        }

        #roam_table tbody tr:hover {
            background: #f8fbff;
        }

        .loading {
         /*   position: fixed;
            z-index: 9999;
            inset: 0;
            background: rgba(255,255,255,.82);
            display: none;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            color: #1f3c88;*/

               border: 16px solid #f3f3f3;
   border-radius: 50%;
   border-top: 16px solid #3498db;
 /*  width: 120px;
   height: 120px;*/
   -webkit-animation: spin 2s linear infinite;
   animation: spin 2s linear infinite;
   margin-left: 250px;
   margin-top: 250px;

        }

        .modal-content {
            border: 0;
            border-radius: 16px;
            box-shadow: 0 16px 40px rgba(15, 23, 42, .18);
            overflow: hidden;
        }

        .modal-header {
            background: linear-gradient(90deg, #1f3c88, #2575fc);
            color: #fff;
            border-bottom: 0;
        }

        .modal-header .close,
        .modal-header .close span {
            color: #fff;
            opacity: 1;
        }

        .modal-footer {
            border-top: 1px solid #edf2f7;
        }

        @media (max-width: 767px) {
            .roam-page-wrapper { padding: 10px; }
            .dashboard-header { padding: 14px; }
            .dashboard-title { font-size: 18px; }
            .filter-card .btn { width: 100%; margin-top: 8px; }
        }
    </style>

   <%-- <div class="loading" id="load1">
        <img src="../images/Load_1.gif" alt="Loading" />
        <div style="font-size: 12px; font-weight: bold; margin-top: 8px;">One moment, please . . . .</div>
    </div>--%>

    <div class="roam-page-wrapper">
        <div class="dashboard-header">
            <div class="dashboard-title"><i class="fas fa-route"></i>&nbsp; Roaming Branch</div>
            <div class="dashboard-subtitle">Assign, monitor, and maintain employee roaming branch mappings</div>
        </div>

        <div class="row mb-4">
            <div class="col-md-4 mb-3">
                <div class="summary-card">
                    <div class="summary-icon"><i class="fas fa-user-check"></i></div>
                    <div>
                        <div class="summary-label">Employee Mapping</div>
                        <div class="summary-value">Roaming Access</div>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="summary-card">
                    <div class="summary-icon"><i class="fas fa-code-branch"></i></div>
                    <div>
                        <div class="summary-label">Branch Selection</div>
                        <div class="summary-value">Controlled Access</div>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="summary-card">
                    <div class="summary-icon"><i class="fas fa-shield-alt"></i></div>
                    <div>
                        <div class="summary-label">Audit Trail</div>
                        <div class="summary-value">User & Date Wise</div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card filter-card mb-4">
            <div class="card-body">
                <div class="section-title"><i class="fas fa-sliders-h"></i>Roaming Branch Setup</div>
                <div class="row align-items-end">
                    <div class="col-lg-5 col-md-6 mb-3">
                        <label><b>Employee</b></label>
                        <select id="roam_employee" name="roam_employee" class="form-control">
                            <option value="">Select</option>
                        </select>
                    </div>
                    <div class="col-lg-5 col-md-6 mb-3">
                        <label><b>Roaming Branch</b></label>
                        <select id="roam_branch" name="roam_branch" class="form-control">
                            <option value="">Select</option>
                        </select>
                    </div>
                    <div class="col-lg-2 col-md-12 mb-3">
                        <button id="roam_btnSubmit" class="btn btn-gradient btn-block" onclick="return roam_submit();">
                            <i class="fas fa-save"></i>&nbsp; Submit
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <div class="card data-card">
            <div class="card-body">
                <div class="table-toolbar">
                    <div>
                        <div class="section-title mb-1"><i class="fas fa-list"></i>Roaming Branch List</div>
                        <small class="text-muted">Review active employee and branch mappings</small>
                    </div>
                    <button type="button" class="btn btn-soft" onclick="roam_Binddata(); return false;">
                        <i class="fas fa-sync-alt"></i>&nbsp; Refresh
                    </button>
                </div>
                <div class="table-responsive table-responsive-modern">
                    <table class="table table-hover" id="roam_table" style="width: 100%;">
                        <thead>
                            <tr>
                                <th class="sort border-top ps-3" style="display: none;">Roaming Branch ID</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Actions</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Employee</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Roaming Branch</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added By</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added Date</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="roam_dverror">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title"><i class="fas fa-info-circle"></i>&nbsp; Message</h6>
                </div>
                <div class="modal-body text-center">
                    <h6 class="mb-0" id="roam_errmsg"></h6>
                </div>
                <div class="modal-footer justify-content-center">
                    <button class="btn btn-gradient" type="button" id="roam_btnMessage" onclick="return roam_Message();">Okay</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="roam_deleteroamingbranch">
        <div class="modal-dialog modal-l modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title"><i class="fas fa-trash-alt"></i>&nbsp; Delete Roaming Branch</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body text-center py-4">
                    <div class="summary-icon mx-auto mb-3"><i class="fas fa-exclamation-triangle"></i></div>
                    <p class="mb-0">Are you sure you want to delete roaming branch?</p>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
                    <button class="btn btn-gradient" type="button" id="roam_btnYes" onclick="return roam_deleteroamingbranch();">Yes, Delete</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>


<%--<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        $(document).ready(function () {
            roam_bindbranches();
            roam_bindemployee();
            roam_Binddata();
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Roaming Branch</b></h6>
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
                        <td><b>Employee:</b></td>
                        <td>
                            <select id="roam_employee" name="roam_employee" class="form-control" style="width: 350px;">
                                <option value="">Select</option>
                            </select>
                        </td>
                        <td><b>Roaming Branch:</b></td>
                        <td>
                            <select id="roam_branch" name="roam_branch" class="form-control" style="width: 350px;">
                                <option value="">Select</option>
                            </select>
                        </td>
                        <td>
                            <button id="roam_btnSubmit" class="btn btn-primary" onclick="return roam_submit();">Submit</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <table class="table" id="roam_table" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="display: none;">Roaming Branch ID</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Actions</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Employee</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Roaming Branch</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added By</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added Date</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>

            </div>
        </div>
    </div>
    <div class="modal fade" id="roam_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="roam_errmsg"></h6>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="roam_btnMessage" onclick="return roam_Message();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

    <div class="modal fade" id="roam_deleteroamingbranch">
        <div class="modal-dialog modal-l">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Delete Roaming Branch</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">

                    <p>Are you sure you want to delete roaming branch?</p>

                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
                    <button class="btn btn-primary" type="button" id="roam_btnYes" onclick="return roam_deleteroamingbranch();">Yes</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>--%>
