<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="SLATimeline.aspx.cs" Inherits="WebPortal.Admin.SLATimeline" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        /* Container */
        .sla-container {
            padding: 20px;
            background: #f5f7fb;
            min-height: 100vh;
        }

        /* Card */
        .sla-card {
            background: #fff;
            border-radius: 14px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
            overflow: hidden;
        }

        /* Header */
        .sla-header {
            background: linear-gradient(135deg, #4e73df, #224abe);
            color: white;
            padding: 15px 20px;
            font-size: 18px;
            font-weight: 600;
        }

        /* Body */
        .sla-body {
            padding: 25px;
        }

        /* Grid */
        .sla-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 20px;
        }

        /* Fields */
        .sla-field label {
            font-size: 12px;
            font-weight: bold;
            color: #6c757d;
            margin-bottom: 5px;
            display: block;
        }

        .sla-field input,
        .sla-field select {
            width: 100%;
            padding: 10px;
            border-radius: 8px;
            border: 1px solid #dcdfe6;
            transition: 0.3s;
            font-size: 14px;
        }

            /* Focus Effect */
            .sla-field input:focus,
            .sla-field select:focus {
                border-color: #4e73df;
                box-shadow: 0 0 0 2px rgba(78,115,223,0.15);
                outline: none;
            }

        /* Buttons */
        .sla-actions {
            margin-top: 25px;
            text-align: right;
        }

        .btn-save {
            background: #28a745;
            color: #fff;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            margin-right: 10px;
            cursor: pointer;
        }

        .btn-reset {
            background: #6c757d;
            color: #fff;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
        }

        /* Hover */
        .btn-save:hover {
            background: #218838;
        }

        .btn-reset:hover {
            background: #5a6268;
        }

        /* Validation */
        .error {
            border-color: red !important;
        }

        .sla-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr); /* 3 per row */
            gap: 20px;
        }

        .btn-save {
            background: linear-gradient(135deg, #28a745, #218838);
            color: #fff;
            border: none;
            padding: 10px 22px;
            border-radius: 8px;
            cursor: pointer;
            position: relative;
            font-weight: 600;
            transition: 0.3s;
        }

            .btn-save:hover {
                transform: translateY(-1px);
                box-shadow: 0 5px 12px rgba(0,0,0,0.15);
            }

        /* Loader spinner */
        .btn-loader {
            width: 18px;
            height: 18px;
            border: 2px solid #fff;
            border-top: 2px solid transparent;
            border-radius: 50%;
            display: inline-block;
            animation: spin 0.7s linear infinite;
            margin-left: 8px;
        }

        @keyframes spin {
            to {
                transform: rotate(360deg);
            }
        }

        .btn-gradient-primary {
            background: linear-gradient(135deg, #4e73df, #224abe);
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

            var userId = '<%= HttpContext.Current.User.Identity.Name.ToString() %>';

            sla_Project(userId);

            sla_bindYears();

            slarTimeline_bindgrid();

        });

    </script>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>SLA Timeline</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <div class="sla-grid">

                    <div class="sla-field">
                        <label>Project</label>
                        <select id="sla_Project"></select>
                    </div>

                    <div class="sla-field">
                        <label>Process</label>
                        <select id="sla_DealNo">
                            <option value="">Select Process</option>
                            <option value="Pre-Close">Pre-Close</option>
                            <option value="Post-Close">Post-Close</option>
                        </select>
                    </div>

                    <div class="sla-field">
                        <label>Timeline</label>
                        <input type="number" id="sla_Timeline">
                    </div>

                    <div class="sla-field">
                        <label>Timeline Type</label>
                        <select id="sla_TimelineType">
                            <option value="">Select Type</option>
                            <option value="Hours">Hours</option>
                            <option value="Days">Days</option>
                        </select>
                    </div>

                    <div class="sla-field d-flex align-items-end">
                        <button type="button" id="sla_btnSubmit" class="btn btn-gradient-primary w-100" onclick="sla_save()">
                            <span class="btn-text"><i class="bi bi-floppy"></i>&nbsp;&nbsp; Save</span>
                            <span class="btn-loader d-none"></span>
                        </button>
                    </div>

                </div>
            </div>


            <div class="card-body">
                <%--<div class="datatable" data-mdb-datatable-init data-mdb-borderless="true" data-mdb-hover="true" data-mdb-dark="true" data-mdb-sm="true" data-mdb-fixed-header="true" data-mdb-loading="true" data-mdb-color="light-blue" data-mdb-border-color="info"></div>--%>
                <table class="table" id="table_slaTimeline" style="width: 100%;">
                    <thead></thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

    <style>
        /* Container feel */
        #table_slaTimeline {
            border-collapse: separate;
            border-spacing: 0;
            background: #fff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08);
            font-family: "Segoe UI", Roboto, Arial, sans-serif;
        }

            /* Header styling */
            #table_slaTimeline thead {
                /*   background: linear-gradient(90deg, #4f46e5, #6366f1);*/
                color: white;
            }

                #table_slaTimeline thead th {
                    padding: 14px 16px;
                    font-weight: 600;
                    text-transform: uppercase;
                    font-size: 13px;
                    letter-spacing: 0.5px;
                }

            /* Body cells */
            #table_slaTimeline tbody td {
                padding: 6px 8px;
                border-bottom: 1px solid #f1f1f1;
                font-size: 12px;
                color: #333;
            }

            /* Hover effect */
            #table_slaTimeline tbody tr {
                transition: all 0.2s ease-in-out;
            }

                #table_slaTimeline tbody tr:hover {
                    background: #f8fafc;
                    transform: scale(1.01);
                }

                /* Zebra striping */
                #table_slaTimeline tbody tr:nth-child(even) {
                    background: #fcfcfc;
                }

                /* Rounded bottom */
                #table_slaTimeline tbody tr:last-child td {
                    border-bottom: none;
                }

        /* Optional: small badge style (for status columns etc.) */
        .badge-soft {
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
            background: #eef2ff;
            color: #4f46e5;
        }
    </style>
</asp:Content>


<%--   <div class="sla-field">
                        <label>Month</label>
                        <select id="sla_Month">
                            <option value="">Select Month</option>
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
                    </div>

                    <div class="sla-field">
                        <label>Year</label>
                        <select id="sla_Year"></select>
                    </div>--%>

