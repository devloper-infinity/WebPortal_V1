<%@ Page Title="" Language="C#" MasterPageFile="~/IT/Admin.Master" AutoEventWireup="true" CodeBehind="TIcketQueue.aspx.cs" Inherits="WebPortal.IT.TIcketQueue" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --ticket-primary: #2563eb;
            --ticket-primary-dark: #1d4ed8;
            --ticket-soft: #eff6ff;
            --ticket-border: #e5e7eb;
            --ticket-text: #0f172a;
            --ticket-muted: #64748b;
            --ticket-card-shadow: 0 18px 45px rgba(15, 23, 42, .08);
        }

        .ticket-page {
            background: #f8fafc;
            min-height: calc(100vh - 90px);
        }

        .ticket-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: flex-start;
            gap: 18px;
            color: #fff;
            background: linear-gradient(135deg, #2563eb 0%, #7c3aed 55%, #f97316 120%);
            border-radius: 22px;
            padding: 24px 28px;
            margin-bottom: 18px;
            box-shadow: var(--remark-shadow);
        }

            .ticket-hero:after {
                content: "";
                position: absolute;
                width: 280px;
                height: 280px;
                right: -80px;
                top: -110px;
                background: rgba(255, 255, 255, .16);
                border-radius: 50%;
            }

            .ticket-hero h4,
            .ticket-hero p,
            .ticket-hero .btn {
                position: relative;
                z-index: 1;
            }

            .ticket-hero h4 {
                margin: 0;
                font-weight: 800;
                letter-spacing: .2px;
            }

            .ticket-hero p {
                margin: 7px 0 0;
                color: rgba(255, 255, 255, .86);
            }


        .ticket-hero-icon {
            width: 52px;
            height: 52px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 16px;
            color: #fff;
            background: linear-gradient(135deg, var(--ticket-primary), #fe7096);
            box-shadow: 0 14px 26px rgba(37, 99, 235, .25);
            font-size: 22px;
        }

        .ticket-card {
            border: 1px solid var(--ticket-border) !important;
            border-radius: 18px !important;
            box-shadow: var(--ticket-card-shadow);
            overflow: hidden;
        }

            .ticket-card .card-body {
                padding: 20px;
            }

        .ticket-table-wrap {
            width: 100%;
            overflow-x: auto;
        }

        #it_ticketqueue {
            border-collapse: separate !important;
            border-spacing: 0 10px !important;
            margin-top: 0 !important;
        }

            #it_ticketqueue thead th {
                background: #f1f5f9 !important;
                color: #334155 !important;
                font-size: 12px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: .03em;
                border: 0 !important;
                padding: 12px 14px !important;
                vertical-align: middle;
            }

            #it_ticketqueue tbody tr {
                box-shadow: 0 6px 18px rgba(15, 23, 42, .06);
                border-radius: 14px;
            }

            #it_ticketqueue tbody td {
                background: #fff !important;
                border-top: 1px solid var(--ticket-border) !important;
                border-bottom: 1px solid var(--ticket-border) !important;
                padding: 13px 14px !important;
                vertical-align: middle;
                color: #1f2937;
            }

                #it_ticketqueue tbody td:first-child {
                    border-left: 1px solid var(--ticket-border) !important;
                    border-radius: 14px 0 0 14px;
                }

                #it_ticketqueue tbody td:last-child {
                    border-right: 1px solid var(--ticket-border) !important;
                    border-radius: 0 14px 14px 0;
                }

        .dataTables_wrapper .dataTables_filter input,
        .dataTables_wrapper .dataTables_length select {
            border: 1px solid var(--ticket-border) !important;
            border-radius: 10px !important;
            padding: 7px 10px !important;
            outline: none !important;
        }

            .dataTables_wrapper .dataTables_filter input:focus {
                border-color: var(--ticket-primary) !important;
                box-shadow: 0 0 0 3px rgba(37, 99, 235, .12) !important;
            }

        .dataTables_wrapper .dataTables_paginate .paginate_button.current,
        .dataTables_wrapper .dataTables_paginate .paginate_button.current:hover {
            color: #fff !important;
            border: 0 !important;
            border-radius: 10px !important;
            background: var(--ticket-primary) !important;
        }

        @media (max-width: 767px) {
            .ticket-hero {
                align-items: flex-start;
                padding: 18px;
            }

            .ticket-hero-icon {
                width: 46px;
                height: 46px;
            }
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            it_tq_bindgrid();
        });

    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="ticket-page">
        <div class="ticket-hero">
            <span class="ticket-hero-icon"><i class="fas fa-ticket-alt"></i></span> <div>
                <h4>Ticket Queue</h4>
                <p>Review assigned tickets, priority, TAT and elapsed time in one clean view.</p>
            </div>
           
        </div>
        <div class="col-lg-12 p-0">
            <div class="card ticket-card">
                <div class="card-body">
                    <div class="ticket-table-wrap">
                        <table class="table" id="it_ticketqueue" style="width: 100%;">
                            <thead>
                                <tr>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Actions</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; display: none;">Ticket Id</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Assign Ticket</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;"></th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Ticket #</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Ticket Raised On</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Expected TAT</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Code</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Location</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Request Related To</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Priority</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Subject</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Elapsed Time</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
