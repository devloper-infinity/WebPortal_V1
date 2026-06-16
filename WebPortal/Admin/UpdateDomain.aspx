<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="UpdateDomain.aspx.cs" Inherits="WebPortal.Admin.UpdateDomain" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        .main-container {
            width: 100%;
            padding: 15px 25px;
        }

        /* Custom Grid */
        .my-row {
            display: flex;
            flex-wrap: wrap;
            margin-bottom: 15px;
            width: 100%;
        }

        .my-col-3 {
            width: 25%;
            padding-right: 15px;
        }

        .my-col-12 {
            width: 100%;
        }

        .my-input:focus, .my-select:focus {
            border-color: #b5d3ff;
            box-shadow: 0 0 4px rgba(181, 211, 255, 0.6);
            outline: none;
        }
        /* Inputs */
        .my-input, .my-select {
            width: 100%;
            height: 40px;
            border: 1px solid #dcdcdc;
            padding: 6px;
            border-radius: 5px;
            font-size: 12px;
            background-color: #fff;
            transition: all 0.2s ease;
        }

        textarea.my-input {
            height: 70px;
            resize: none;
        }

        label {
            font-size: 12px;
            margin-bottom: 4px;
            display: block;
        }

        .my-btn {
            padding: 6px 18px;
            border-radius: 4px;
            border: none;
            color: #fff;
            font-size: 14px;
            margin-right: 8px;
        }

        .primary {
            background: #2f7ed8;
        }

        .success {
            background: #28a745;
        }

        .warning {
            background: #f0ad4e;
        }

        .my-btn:hover {
            opacity: 0.9;
        }

        .req {
            color: red;
            font-weight: bold;
            margin-left: 3px;
        }

        .top {
            display: flex;
            align-items: center;
        }

        .dataTables_length {
            margin-right: 10px;
        }

        .dt-buttons {
            margin-right: auto;
        }

        .dataTables_filter {
            margin-left: auto;
        }

        .card {
            transition: 0.3s ease;
        }

            .card:hover {
                transform: translateY(-3px);
            }

        .btn {
            border-radius: 10px;
            font-weight: 400;
        }

        .form-select {
            border-radius: 10px;
        }

        h5, h6 {
            letter-spacing: 0.5px;
        }

        .btn-gradient-primary {
            /* background: linear-gradient(135deg, #4e73df, #224abe);*/
            background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;
            color: #fff;
            border-radius: 12px;
            height: 40px;
            font-weight: 400;
            transition: 0.3s;
        }

            .btn-gradient-primary:hover {
                transform: translateY(-2px);
                background: linear-gradient(135deg, #224abe, #1a3a8f);
                color: #fff;
            }

        .btn-gradient-success {
            background: linear-gradient(135deg, #1cc88a, #13855c);
            color: #fff;
            border-radius: 12px;
            height: 50px;
            width: 60%;
            font-weight: 400;
            transition: 0.3s;
        }

            .btn-gradient-success:hover {
                transform: translateY(-2px);
                color: #fff;
            }

        table.dataTable thead th::before,
        table.dataTable thead th::after {
            display: none !important;
        }

        #filter_rows input {
            width: 100%;
            height: 30px;
            padding: 3px;
            font-size: 12px;
            box-sizing: border-box;
        }


        #filter_row input,
        #filter_row select {
            /* width: 100%;*/
            height: 22px;
            font-size: 12px;
            padding: 4px;
            border-radius: 4px;
            border: 1px solid #ced4da;
        }

        #filter_row {
            background-color: #f8f9fa;
        }

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
    </style>

    <script>
        $(document).ready(function () {
            updomain_bindDomains();
            updomain_bindSubDomains();
            updomain_bindgrid();
        });
    </script>

    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />

    <!-- SweetAlert -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.8/css/jquery.dataTables.min.css" />

    <!-- FixedHeader CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/fixedheader/3.4.0/css/fixedHeader.dataTables.min.css" />

    <!-- FixedColumns CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/fixedcolumns/4.3.0/css/fixedColumns.dataTables.min.css" />

    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>

    <!-- FixedHeader JS -->
    <script src="https://cdn.datatables.net/fixedheader/3.4.0/js/dataTables.fixedHeader.min.js"></script>

    <!-- FixedColumns JS -->
    <script src="https://cdn.datatables.net/fixedcolumns/4.3.0/js/dataTables.fixedColumns.min.js"></script>

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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Update Domain</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card sla-card">
                <div class="card-body">
                    <div class="main-container">
                        <div class="my-row">

                            <div class="my-col-3">
                                <label>Domain<b><span class="req">*</span></b></label>
                                <select class="my-select" id="updomain_domain" onchange="otherTask_bindProcess(this)"></select>
                            </div>

                            <div class="my-col-3">
                                <label>Sub Domain<b><span class="req">*</span></b></label>
                                <select class="my-select" id="updomain_subdomain"></select>
                            </div>

                            <div class="my-col-3">
                                <label>Process<span class="req"></span></label>
                                <input type="text" id="updomain_process" class="my-select" />
                            </div>

                            <div class="my-col-3">
                                <label><b><span class="req"></span></b></label>
                                <button type="submit" id="updomain_update" class="btn btn-gradient-primary w-100" onclick="return updomain_submit();"><i class="bi bi-arrow-repeat"></i>&nbsp; Change</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-body">
                    <%-- <div style="overflow: auto; height: 600px;"> </div>--%>
                    <table class="table" id="table_updomain" style="width: 100%;">
                        <thead>
                            <tr>
                                <th class="sort border-top" style="text-wrap: nowrap; width: 100px;">Sr. #</th>
                                <th class="no-sort">
                                    <input type="checkbox" id="updomain_selectAll" /></th>
                                <th style="width: 50px;">Actions</th>
                                <th class="sort border-top" style="text-wrap: nowrap; width: 100px;">Code</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Name</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Joining Date</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Branch</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Department</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Designation</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Domain</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Subdomain</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Segment</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Reporting Manager</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Job Type</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Latest Login</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Current Status</th>
                            </tr>
                            <%--  <!-- ✅ Filter Row -->
                            <tr id="filter_row">
                                <th></th>
                                <th></th>
                                <th></th>
                                <th>
                                    <input type="text" class="column-filter" placeholder="Search Code" /></th>
                                <th>
                                    <input type="text" class="column-filter" placeholder="Search Name" /></th>
                                <th>
                                    <input type="text" class="column-filter" placeholder="Search Date" /></th>
                                <th>
                                    <input type="text" class="column-filter" placeholder="Search Branch" /></th>
                                <th>
                                    <input type="text" class="column-filter" placeholder="Search Dept" /></th>
                                <th>
                                    <input type="text" class="column-filter" placeholder="Search Designation" /></th>
                                <th>
                                    <input type="text" class="column-filter" placeholder="Search Domain" /></th>
                                <th>
                                    <input type="text" class="column-filter" placeholder="Search Subdomain" /></th>
                                <th>
                                    <input type="text" class="column-filter" placeholder="Search Segment" /></th>
                                <th>
                                    <input type="text" class="column-filter" placeholder="Search Manager" /></th>
                                <th>
                                    <input type="text" class="column-filter" placeholder="Search Job Type" /></th>
                                <th>
                                    <input type="text" class="column-filter" placeholder="Search Login" /></th>
                                <th>
                                    <input type="text" class="column-filter" placeholder="Search Status" /></th>
                            </tr>--%>
                        </thead>
                        <tbody></tbody>
                    </table>

                </div>
            </div>
        </div>
    </div>



    <div class="modal fade" id="updomain_popUp">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header" style="background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;">
                    <label id="updomain_Header" name="updomain_Header" style="font-weight: bolder; font-size: 18px; color: white;"></label>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="color: white;">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">

                    <div class="container-fluid">

                        <div class="row g-3">
                            <!-- Domain -->
                            <div class="col-md-4">
                                <label class="form-label fw-bold">Domain <span class="text-danger">*</span></label>
                                <select class="my-select" id="popUp_domain" onchange="otherTask_bindProcess(this)"></select>
                            </div>

                            <!-- Sub Domain -->
                            <div class="col-md-4">
                                <label class="form-label fw-bold">Sub Domain <span class="text-danger">*</span></label>
                                <select class="my-select" id="popUp_subdomain"></select>
                            </div>

                            <!-- Process -->
                            <div class="col-md-4">
                                <label class="form-label fw-bold">Process <span class="text-danger">*</span></label>
                                <input class="my-select" id="popUp_process" />
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer d-flex justify-content-between">
                    <button type="button" class="btn btn-light" data-dismiss="modal">Close</button>
                    <button type="submit" id="popUp_update" class="btn btn-primary px-4" style="background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;" onclick="return popUp_submit();"><i class="bi bi-arrow-repeat"></i>Update</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="updomain_waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">System is updating data. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>

</asp:Content>
