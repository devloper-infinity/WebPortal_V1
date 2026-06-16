<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="StampPaperInformation.aspx.cs" Inherits="WebPortal.Admin.StampPaperInformation" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .dashboard-header {
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            border-radius: 15px;
            padding: 12px;
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
        }

        .dashboard-subtitle {
            font-size: 12px;
            opacity: 0.9;
            /*text-transform: uppercase;*/
        }
    </style>

    <script>
        $(document).ready(function () {
            stampinfo_bindemployees();
            stampinfo_BindStampPaperInfo();
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="dashboard-header">
        <div class="d-flex justify-content-between align-items-start mb-1">
            <div>
                <div class="dashboard-title">
                    <i class="fas fa-file-signature"></i>&nbsp;&nbsp;
                    Stamp Paper Information
                </div>
                <div class="dashboard-subtitle">
                    View and manage stamp paper details and transaction records.
                </div>
            </div>
        </div>
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <%--<table class="table">
                    <tr>
                        <td><b>Employee:</b></td>
                        <td>
                            <select id="stampinfo_employee" name="stampinfo_employee" class="form-control" style="width: 300px;">
                                <option value="">Select</option>
                            </select>
                        </td>
                        <td><b>Stamp Paper Type:</b></td>
                        <td>
                            <select id="stampinfo_stamppapertype" name="stampinfo_stamppapertype" class="form-control" style="width: 300px;">
                                <option value="">Select</option>
                                <option value="Addendum">Addendum</option>
                                <option value="Agreement">Agreement</option>
                                <option value="Client List">Client List</option>
                                <option value="Undertaking">Undertaking</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Stamp Paper #:</b></td>
                        <td>
                            <input type="text" id="stampinfo_stamppaperno" name="stampinfo_stamppaperno" class="form-control" style="width: 300px;" />
                        </td>
                        <td><b>Stamp Paper Cost:</b></td>
                        <td>
                            <input type="text" id="stampinfo_stamppapercost" name="stampinfo_stamppapercost" class="form-control" style="width: 300px;" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Stamp Paper Version:</b></td>
                        <td>
                            <input type="text" id="stampinfo_stamppaperversion" name="stampinfo_stamppaperversion" class="form-control" style="width: 300px;" />
                        </td>
                        <td><b>Stamp Paper Count:</b></td>
                        <td>
                            <select id="stampinfo_stamppapercount" name="stampinfo_stamppapercount" class="form-control" style="width: 300px;">
                                <option value="">Select</option>
                                <option value="1">1</option>
                                <option value="2">2</option>
                            </select>
                        </td>
                    </tr>
                    <tr>

                        <td><b>Received Date:</b></td>
                        <td>
                            <input type="date" id="stampinfo_stamppaperreceiveddate" name="stampinfo_stamppaperreceiveddate" class="form-control" style="width: 300px;" />
                        </td>
                        <td><b>Remark:</b></td>
                        <td>
                            <textarea id="stampinfo_remark" name="stampinfo_remark" class="form-control" style="width: 300px;"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4" style="vertical-align: middle; text-align: center;">
                            <button id="stampinfo_btnsubmit" class="btn btn-primary" onclick="return stampinfo_submit();">Submit</button>
                        </td>
                    </tr>
                </table>--%>

                <div class="card-body">

                    <!-- Row 1 -->
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label fw-bold">Employee</label>
                            <select id="stampinfo_employee" name="stampinfo_employee" class="form-control">
                                <option value="">Select</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold">Stamp Paper Type</label>
                            <select id="stampinfo_stamppapertype" name="stampinfo_stamppapertype" class="form-control">
                                <option value="">Select</option>
                                <option value="Addendum">Addendum</option>
                                <option value="Agreement">Agreement</option>
                                <option value="Client List">Client List</option>
                                <option value="Undertaking">Undertaking</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold">Stamp Paper #</label>
                            <input type="text" id="stampinfo_stamppaperno" name="stampinfo_stamppaperno" class="form-control">
                        </div>
                    </div>

                    <!-- Row 2 -->
                    <div class="row g-3 mt-1">
                        <div class="col-md-4">
                            <label class="form-label fw-bold">Stamp Paper Cost</label>
                            <input type="text" id="stampinfo_stamppapercost" name="stampinfo_stamppapercost" class="form-control">
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold">Stamp Paper Version</label>
                            <input type="text" id="stampinfo_stamppaperversion" name="stampinfo_stamppaperversion" class="form-control">
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold">Stamp Paper Count</label>
                            <select id="stampinfo_stamppapercount" name="stampinfo_stamppapercount" class="form-control">
                                <option value="">Select</option>
                                <option value="1">1</option>
                                <option value="2">2</option>
                            </select>
                        </div>
                    </div>

                    <!-- Row 3 -->
                    <div class="row g-3 mt-1">
                        <div class="col-md-4">
                            <label class="form-label fw-bold">Received Date</label>
                            <input type="date" id="stampinfo_stamppaperreceiveddate" name="stampinfo_stamppaperreceiveddate" class="form-control">
                        </div>

                        <div class="col-md-8">
                            <label class="form-label fw-bold">Remark</label>
                            <textarea id="stampinfo_remark" name="stampinfo_remark" rows="2" class="form-control"></textarea>
                        </div>
                    </div>

                    <!-- Button -->
                    <div class="text-center mt-4">
                        <button id="stampinfo_btnsubmit"
                            class="btn btn-primary px-4"
                            onclick="return stampinfo_submit();">
                            Submit
                        </button>
                    </div>

                </div>

                <%--    <div class="container-fluid">
                    <div class="bg-white p-4 rounded-3 shadow-sm">

                        <div class="row g-4">

                            <!-- Employee -->
                            <div class="col-lg-4">
                                <div class="form-floating">
                                    <select id="stampinfo_employee" name="stampinfo_employee" class="form-select">
                                        <option value="">Select</option>
                                    </select>
                                    <label for="stampinfo_employee">Employee</label>
                                </div>
                            </div>

                            <!-- Stamp Paper Type -->
                            <div class="col-lg-4">
                                <div class="form-floating">
                                    <select id="stampinfo_stamppapertype" name="stampinfo_stamppapertype" class="form-select">
                                        <option value="">Select</option>
                                        <option value="Addendum">Addendum</option>
                                        <option value="Agreement">Agreement</option>
                                        <option value="Client List">Client List</option>
                                        <option value="Undertaking">Undertaking</option>
                                    </select>
                                    <label for="stampinfo_stamppapertype">Stamp Paper Type</label>
                                </div>
                            </div>

                            <!-- Stamp Paper No -->
                            <div class="col-lg-4">
                                <div class="form-floating">
                                    <input type="text" id="stampinfo_stamppaperno" name="stampinfo_stamppaperno" class="form-control">
                                    <label for="stampinfo_stamppaperno">Stamp Paper #</label>
                                </div>
                            </div>

                            <!-- Cost -->
                            <div class="col-lg-4">
                                <div class="form-floating">
                                    <input type="text" id="stampinfo_stamppapercost" name="stampinfo_stamppapercost" class="form-control">
                                    <label for="stampinfo_stamppapercost">Stamp Paper Cost</label>
                                </div>
                            </div>

                            <!-- Version -->
                            <div class="col-lg-4">
                                <div class="form-floating">
                                    <input type="text" id="stampinfo_stamppaperversion" name="stampinfo_stamppaperversion" class="form-control">
                                    <label for="stampinfo_stamppaperversion">Version</label>
                                </div>
                            </div>

                            <!-- Count -->
                            <div class="col-lg-4">
                                <div class="form-floating">
                                    <select id="stampinfo_stamppapercount" name="stampinfo_stamppapercount" class="form-select">
                                        <option value="">Select</option>
                                        <option value="1">1</option>
                                        <option value="2">2</option>
                                    </select>
                                    <label for="stampinfo_stamppapercount">Count</label>
                                </div>
                            </div>

                            <!-- Received Date -->
                            <div class="col-lg-4">
                                <div class="form-floating">
                                    <input type="date" id="stampinfo_stamppaperreceiveddate" name="stampinfo_stamppaperreceiveddate" class="form-control">
                                    <label for="stampinfo_stamppaperreceiveddate">Received Date</label>
                                </div>
                            </div>

                            <!-- Remark -->
                            <div class="col-lg-8">
                                <div class="form-floating">
                                    <textarea id="stampinfo_remark"
                                        name="stampinfo_remark"
                                        class="form-control"
                                        style="height: 58px"></textarea>
                                    <label for="stampinfo_remark">Remark</label>
                                </div>
                            </div>

                        </div>

                        <div class="text-end mt-4">
                            <button id="stampinfo_btnsubmit"
                                class="btn btn-primary px-5 rounded-pill shadow-sm"
                                onclick="return stampinfo_submit();">
                                <i class="bi bi-check-circle me-2"></i>Submit
                            </button>
                        </div>

                    </div>
                </div>--%>
            </div>
            <div class="card-body">
                <table class="table" id="stampinfo_table" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Code</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Type</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Stamp Paper #</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Cost</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Version</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Stamp Paper Count</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Received Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Remark</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="stampinfo_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="selfleave_errmsg"></h6>
                    <%--<button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>--%>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="stampinfo_btnMessage" onclick="return stampinfo_Message();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

    <style>
        /*.form-control,
        .form-select {
            border-radius: 12px;
            border-color: #e5e7eb;
        }

            .form-control:focus,
            .form-select:focus {
                box-shadow: 0 0 0 0.2rem rgba(13,110,253,.15);
            }
*/
        .bg-white {
            background: #fff;
        }
    </style>
</asp:Content>
