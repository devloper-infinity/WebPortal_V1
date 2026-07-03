<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="RequisitionProfile.aspx.cs" Inherits="WebPortal.Admin.RequisitionProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
       /* .loading {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 999999;
            background: rgba(255,255,255,.65);
            text-align: center;
        }

        .loading img {
            position: absolute;
            top: 50%;
            left: 50%;
            width: 70px;
            height: 70px;
            transform: translate(-50%, -60%);
        }

        .loading div {
            position: absolute;
            top: calc(50% + 45px);
            left: 50%;
            transform: translateX(-50%);
            font-size: 13px;
            font-weight: 700;
            color: #1f2937;
        }
*/
         #load1 .loading-inner {
      position: absolute !important;
      top: 50% !important;
      left: 50% !important;
      transform: translate(-50%, -50%) !important;
      width: min(280px, calc(100vw - 32px));
      max-width: calc(100vw - 32px);
      border-radius: 22px;
      background: #fff;
      padding: 24px 22px;
      box-shadow: 0 24px 55px rgba(15, 23, 42, .28);
  }

  #load1.loading img {
      display: block;
      width: 82px;
      max-width: 82px;
      height: auto;
      margin: 0 auto;
  }

  .loading-text {
      margin-top: 10px;
      font-size: 13px;
      font-weight: 800;
      color: var(--resg-ink);
  }
        .rp-page {
                     background: #f4f7fb;
            min-height: calc(100vh - 80px);
        }

        .rp-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            gap: 22px;
            padding: 15px 15px;
            margin-bottom: 22px;
            border-radius: 18px;
            color: #fff;
            background: linear-gradient(115deg, #0a5fd7 0%, #1976f3 38%, #1da8ea 72%, #22d3ee 100%);
            box-shadow: 0 12px 28px rgba(21, 98, 228, .25);
        }

        .rp-hero::before {
            content: "";
            position: absolute;
            top: -82px;
            left: -6%;
            width: 116%;
            height: 175px;
            border-radius: 50%;
            background: rgba(255,255,255,.10);
            transform: rotate(-4deg);
        }

        .rp-hero::after {
            content: "";
            position: absolute;
            right: -85px;
            bottom: -90px;
            width: 285px;
            height: 285px;
            border-radius: 50%;
            background: rgba(255,255,255,.13);
        }

        .rp-hero > * {
            position: relative;
            z-index: 2;
        }

        .rp-hero-icon {
            width: 60px;
            height: 60px;
            min-width: 60px;
            border-radius: 50%;
            border: 2px solid rgba(255,255,255,.75);
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.12);
        }

        .rp-hero-icon i {
            font-size: 32px;
            color: #fff;
        }

        .rp-kicker {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 2px;
            font-weight: 700;
            opacity: .9;
            margin-bottom: 4px;
        }

        .rp-title {
            margin: 0;
            font-size: 22px;
            font-weight: 800;
            color: #fff;
        }

        .rp-subtitle {
            margin: 8px 0 0;
            font-size: 13px;
            color: rgba(255,255,255,.92);
            line-height: 1.5;
        }

        .rp-form-card,
        .rp-grid-card {
            border: 0;
            border-radius: 16px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, .08);
        }

        .rp-card-title {
            display: flex;
            align-items: center;
            gap: 9px;
            margin-bottom: 16px;
            color: #0f172a;
            font-size: 15px;
            font-weight: 800;
        }

        .rp-card-title i {
            color: #2563eb;
        }

        .rp-form-grid {
            display: grid;
            grid-template-columns: minmax(260px, 480px) auto;
            gap: 16px;
            align-items: end;
        }

        .rp-field label {
            display: block;
            font-size: 13px;
            font-weight: 700 !important;
            color: #334155;
            margin-bottom: 6px;
            border: none !important;
        }

        .rp-field .form-control {
            height: 40px;
            border-radius: 10px;
            font-size: 13px;
            border: 1px solid #dbe3ef;
        }

        .rp-field .form-control:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37,99,235,.12);
        }

        .rp-btn-primary {
            border: 0;
            color: #fff;
            font-weight: 700;
            border-radius: 10px;
            padding: 9px 20px;
            background: linear-gradient(120deg, #2563eb, #22c1dc);
            box-shadow: 0 8px 18px rgba(37, 99, 235, .25);
            height: 40px;
        }

        .rp-btn-primary:hover {
            color: #fff;
            transform: translateY(-1px);
        }

        .rp-table-wrap {
            width: 100%;
            overflow: hidden;
        }

        #rp_table {
            width: 100% !important;
            margin-bottom: 0;
        }

        #rp_table thead th,
        .table.dataTable th {
            background: #edf3f8 !important;
            color: #111827 !important;
            font-size: 12px;
            font-weight: 800;
            white-space: nowrap;
            border-bottom: 1px solid #dbe3ef !important;
            vertical-align: middle;
        }

        #rp_table tbody td,
        .table.dataTable td {
            font-size: 12px;
            vertical-align: middle;
            white-space: nowrap;
            background-color: #fff !important;
        }

        #rp_table tbody tr:hover td {
            background-color: #f8fbff !important;
        }

        .dataTables_length,
        .dataTables_info {
            float: left !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 50px;
            float: left;
        }

        .buttons-excel,
        .buttons-html5 {
            color: #fff !important;
            box-shadow: none;
            background: linear-gradient(to right, #22c55e, #16a34a) !important;
            border: 0 !important;
            font-weight: bold;
            margin: 0 10px;
            border-radius: 8px !important;
        }

        .dataTables_scrollHeadInner,
        .dataTables_scrollHeadInner table {
            width: 100% !important;
        }

        .rp-modal .modal-content {
            border: 0;
            border-radius: 16px;
            box-shadow: 0 18px 45px rgba(15,23,42,.18);
        }

        .rp-modal .modal-header {
            background: linear-gradient(120deg, #2563eb, #22c1dc);
            color: #fff;
            border-radius: 16px 16px 0 0;
        }

        .rp-modal .modal-title {
            font-weight: 800;
        }

        @media (max-width: 768px) {
            .rp-hero {
                flex-direction: column;
                align-items: flex-start;
            }

            .rp-form-grid {
                grid-template-columns: 1fr;
            }

            .rp-btn-primary {
                width: 100%;
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            rp_Binddata();
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div>One moment, please...</div>
    </div>

    <div class="rp-page">

        <div class="rp-hero">
            <span class="rp-hero-icon">
                <i class="fas fa-user-tie"></i>
            </span>

            <div>
                <%--<div class="rp-kicker">Recruitment Setup</div>--%>
                <h1 class="rp-title">Recruitment Positions</h1>
                <p class="rp-subtitle">
                    Create and manage recruitment position profiles used for hiring requisitions and candidate tracking.
                </p>
            </div>
        </div>

        <div class="card rp-form-card mb-3">
            <div class="card-body">
                <div class="rp-card-title">
                    <i class="fas fa-plus-circle"></i>
                    Add Position Profile
                </div>

                <div class="rp-form-grid">
                    <div class="rp-field">
                        <label for="rp_profile">Position</label>
                        <input type="text" id="rp_profile" name="rp_profile" class="form-control" placeholder="Enter position name" required />
                    </div>

                    <div>
                        <button id="rp_btnSubmit" class="rp-btn-primary" onclick="return rp_submit();">
                            <i class="fas fa-save mr-1"></i> Submit
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <div class="card rp-grid-card">
            <div class="card-body">
                <div class="rp-card-title">
                    <i class="fas fa-list-ul"></i>
                    Position List
                </div>

                <div class="rp-table-wrap">
                    <table class="table table-bordered table-hover nowrap" id="rp_table" style="width: 100%;">
                        <thead>
                            <tr>
                                <th class="text-center">Sr. #</th>
                                <th>Position</th>
                                <th>Added By</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>

    </div>

    <div class="modal fade rp-modal" id="rp_dverror" data-backdrop="static" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="rp_errmsg"></h6>
                </div>

                <div class="modal-footer justify-content-center">
                    <button class="rp-btn-primary" type="button" id="rp_btnMessage" onclick="return rp_Message();">
                        Okay
                    </button>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

<%--<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
            rp_Binddata();
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Recruitment Positions</b></h6>
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
                        <td><b>Position:</b></td>
                        <td>
                            <input type="text" id="rp_profile" name="rp_profile" class="form-control" style="width:350px;" required />
                        </td>
                        <td>
                            <button id="rp_btnSubmit" class="btn btn-primary" onclick="return rp_submit();">Submit</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <table class="table" id="rp_table" style="width:100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;text-align:center;">Sr. #</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Position</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added By</th>                            
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>

            </div>
        </div>
    </div>
    <div class="modal fade" id="rp_dverror" data-backdrop="static" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="rp_errmsg"></h6>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="rp_btnMessage" onclick="return rp_Message();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>--%>
