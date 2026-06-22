<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="CompensatoryOff.aspx.cs" Inherits="WebPortal.Admin.CompensatoryOff" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="dist/css/adminlte.min.css">
    <link rel="stylesheet" href="dist/css/custom-style.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        :root {
            --co-primary: #2563eb;
            --co-primary-dark: #1d4ed8;
            --co-success: #16a34a;
            --co-danger: #dc2626;
            --co-warning: #f59e0b;
            --co-bg: #f8fafc;
            --co-card: #ffffff;
            --co-text: #0f172a;
            --co-muted: #64748b;
            --co-border: #e2e8f0;
            --co-radius: 18px;
            --co-shadow: 0 18px 40px rgba(15, 23, 42, 0.08);
        }

        .co-page {
            background: var(--co-bg);
            min-height: calc(100vh - 70px);
        }

        .co-shell {
            max-width: 100%;
            margin: 0 auto;
        }

        .co-hero {
            position: relative;
            overflow: hidden;
            border-radius: 24px;
            padding: 24px 28px;
            color: #fff;
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            box-shadow: var(--co-shadow);
            margin-bottom: 18px;
        }

            .co-hero:after {
                content: "";
                position: absolute;
                width: 220px;
                height: 220px;
                right: -60px;
                top: -80px;
                border-radius: 50%;
                background: rgba(255,255,255,.16);
            }

            .co-hero h4 {
                margin: 0;
                font-weight: 800;
                letter-spacing: -.02em;
            }

            .co-hero p {
                margin: 8px 0 0;
                opacity: .88;
            }

        .co-card {
            background: var(--co-card);
            border: 1px solid var(--co-border);
            border-radius: var(--co-radius);
            box-shadow: var(--co-shadow);
            overflow: hidden;
        }

        .co-tabs {
            padding: 16px 18px;
            border-bottom: 1px solid var(--co-border);
            background: linear-gradient(180deg, #ffffff 0%, #f8fafc 100%);
        }

            .co-tabs .nav-tabs {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                border: 1px solid #e5edf7;
                border-radius: 999px;
                padding: 6px;
                background: #eef4fb;
                box-shadow: inset 0 1px 2px rgba(15, 23, 42, .05);
            }

            .co-tabs .nav-item {
                margin: 0;
            }

            .co-tabs .nav-link {
                position: relative;
                display: inline-flex;
                align-items: center;
                gap: 7px;
                border: 0 !important;
                border-radius: 999px !important;
                color: #52657a;
                font-weight: 800;
                padding: 11px 20px;
                line-height: 1;
                transition: all .22s ease;
                background: transparent;
            }

            .co-tabs .nav-link:hover {
                color: var(--co-primary-dark);
                background: rgba(255, 255, 255, .72);
            }

                .co-tabs .nav-link.active {
                    color: #fff !important;
                    background: linear-gradient(135deg, #1f3c88 0%, #2563eb 58%, #1bc5e8 100%) !important;
                    box-shadow: 0 14px 28px rgba(37, 99, 235, .30);
                    transform: translateY(-1px);
                }

            .co-tabs .nav-link i {
                font-size: 13px;
            }

        .co-body {
            padding: 18px;
        }

        .co-form-panel {
            border: 1px solid var(--co-border);
            border-radius: 16px;
            padding: 18px;
            background: linear-gradient(180deg, #fff, #f8fafc);
            margin-bottom: 18px;
        }

            .co-form-panel label,
            .custom-comp-modal label {
                color: var(--co-text);
                font-weight: 700;
                font-size: 13px;
                margin-bottom: 6px;
            }

        .co-input,
        .custom-input,
        .form-control {
            border-radius: 12px !important;
            border: 1px solid var(--co-border) !important;
            min-height: 42px;
            box-shadow: none !important;
        }

            .co-input:focus,
            .custom-input:focus,
            .form-control:focus {
                border-color: var(--co-primary) !important;
                box-shadow: 0 0 0 4px rgba(37, 99, 235, .12) !important;
            }

        .gradient-btn,
        .co-btn-primary {
            border: 0 !important;
            color: #fff !important;
            border-radius: 12px !important;
            font-weight: 800;
            min-height: 42px;
            padding: 10px 18px;
           background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%)!important;
            box-shadow: 0 12px 24px rgba(37, 99, 235, .25);
        }

        .co-btn-light,
        .btn-cancel {
            border-radius: 12px !important;
            min-height: 42px;
            font-weight: 800;
            border: 1px solid var(--co-border) !important;
            color: var(--co-text) !important;
            background: #fff !important;
        }

        .co-toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            margin-bottom: 14px;
        }

        .co-section-title {
            margin: 0;
            font-weight: 800;
            color: var(--co-text);
        }

        .co-table-wrap {
            border: 1px solid var(--co-border);
            border-radius: 16px;
            overflow: auto;
            background: #fff;
        }

            .co-table-wrap table {
                margin-bottom: 0 !important;
            }

            .co-table-wrap thead th {
                position: sticky;
                top: 0;
                z-index: 1;
                background: #f1f5f9;
                color: #334155;
                font-size: 12px;
                text-transform: uppercase;
                letter-spacing: .03em;
                border-bottom: 1px solid var(--co-border) !important;
                white-space: nowrap;
            }

            .co-table-wrap tbody td {
                vertical-align: middle;
                white-space: nowrap;
                color: var(--co-text);
                border-top: 1px solid #eef2f7 !important;
            }

            .co-table-wrap tbody tr:hover {
                background: #f8fafc;
            }

        .custom-comp-modal {
            border: 0;
            border-radius: 22px;
            overflow: hidden;
            box-shadow: 0 28px 70px rgba(15, 23, 42, .28);
        }

        .custom-comp-header {
            border: 0;
            color: #fff;
            padding: 18px 22px;
            background: linear-gradient(135deg, var(--co-primary), #7c3aed);
        }

            .custom-comp-header .modal-title {
                font-weight: 800;
            }

        .custom-footer {
            border-top: 1px solid var(--co-border);
            background: #f8fafc;
            padding: 14px 20px;
        }

        .loading {
            position: fixed !important;
            inset: 0 !important;
            z-index: 99999 !important;
            display: none;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            gap: 12px;
            width: 100vw;
            height: 100vh;
            background: rgba(248, 250, 252, .78);
            backdrop-filter: blur(6px);
            color: var(--co-text);
            font-weight: 800;
            text-align: center;
        }

        /* jQuery .show() sets display:block; force center alignment when visible */
        .loading[style*="display: block"],
        .loading[style*="display:block"] {
            display: flex !important;
        }

        .loading img {
            position: static !important;
            width: 76px;
            height: 76px;
            object-fit: contain;
            border-radius: 18px;
            padding: 12px;
            background: #fff;
            box-shadow: 0 18px 38px rgba(15, 23, 42, .18);
        }

        #compoff_dverror .modal-content {
            border: 0;
            border-radius: 18px;
            box-shadow: var(--co-shadow);
        }

        @media (max-width: 768px) {
            .co-hero {
                padding: 20px;
            }

            .co-body {
                padding: 14px;
            }

            .co-tabs .nav-tabs {
                display: flex;
                width: 100%;
                border-radius: 18px;
            }

            .co-tabs .nav-item,
            .co-tabs .nav-link {
                flex: 1 1 auto;
                justify-content: center;
                text-align: center;
            }

            .co-toolbar {
                align-items: stretch;
                flex-direction: column;
            }

                .co-toolbar .btn {
                    width: 100%;
                }
        }
    </style>

    <script>
        $(document).ready(function () {
            var currentUserName = '<%= HttpContext.Current.User.Identity.Name.ToString() %>';
            setTabVisibility();
            bindworkedholiday(currentUserName);
        });

        $(function () {
            $("#compoff_date, #teamcompoffadd_date").datepicker({
                dateFormat: "dd-M-yy"
            });
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" alt="Loading" />
        <div>One moment, please...</div>
    </div>

    <main class="co-page">
        <div class="co-shell">
            <section class="co-hero">
                <h4><i class="fas fa-calendar-check mr-2"></i>Compensatory Off</h4>
                <p>Apply, track, approve, and manage compensatory off requests.</p>
            </section>

            <section class="co-card">
                <div class="co-tabs">
                    <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                        <li class="nav-item" id="liUserCompOff">
                            <a class="nav-link active" id="custom-tabs-two-user-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">
                                <i class="fas fa-user-clock mr-1"></i>My Compensatory Off
                            </a>
                        </li>
                        <li class="nav-item" id="liTeamCompOff">
                            <a class="nav-link" id="custom-tabs-two-pm-tab" data-toggle="pill" href="#custom-tabs-two" role="tab" aria-controls="custom-tabs-two-pm" onclick="return teambindWorkedHoliday_Grid();" aria-selected="false">
                                <i class="fas fa-users mr-1"></i>Team Compensation Off
                            </a>
                        </li>
                    </ul>
                </div>

                <div class="co-body">
                    <div class="tab-content" id="custom-tabs-one-tabContent">
                        <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                            <div class="co-form-panel">
                                <div class="row align-items-end">
                                    <div class="col-lg-3 col-md-6 mb-3 mb-lg-0">
                                        <label for="compoff_holidaydate">Worked Holiday Date</label>
                                        <select id="compoff_holidaydate" name="compoff_holidaydate" class="form-control co-input">
                                            <option value="Select">Select</option>
                                        </select>
                                    </div>

                                    <div class="col-lg-3 col-md-6 mb-3 mb-lg-0">
                                        <label for="compoff_date">Comp Off Date</label>
                                        <input type="text" id="compoff_date" name="compoff_date" class="form-control co-input" placeholder="dd-MMM-yyyy" />
                                    </div>

                                    <div class="col-lg-4 col-md-8 mb-3 mb-lg-0">
                                        <label for="compoff_remark">Remark</label>
                                        <textarea id="compoff_remark" name="compoff_remark" class="form-control co-input" rows="1" placeholder="Enter reason or note"></textarea>
                                    </div>

                                    <div class="col-lg-2 col-md-4">
                                        <button id="compoff_btn" class="btn gradient-btn btn-block" onclick="return compoff_btnsubmit();">
                                            <i class="fas fa-paper-plane mr-1"></i>Submit
                                       
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <div class="co-toolbar">
                                <h6 class="co-section-title">My Requests</h6>
                            </div>

                            <div class="co-table-wrap">
                                <table class="table table-hover" id="table_compoff" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th>Sr. #</th>
                                            <th>Worked-Holiday</th>
                                            <th>Compensatory Off</th>
                                            <th>Remark</th>
                                            <th>Requested Date</th>
                                            <th>Approval Status</th>
                                            <th>Approval Remark</th>
                                            <th>Approved By</th>
                                            <th>Approved Date</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>

                        <div class="tab-pane fade" id="custom-tabs-two" role="tabpanel" aria-labelledby="custom-tabs-two-tab">
                            <div class="co-toolbar">
                                <h6 class="co-section-title">Team Requests</h6>
                                <button type="button" id="addNewcompoff_btn" class="btn gradient-btn" onclick="return addNewCompesatoryOff();">
                                    <i class="fas fa-plus mr-1"></i>Add New Compensatory Off
                               
                                </button>
                            </div>

                            <div class="co-table-wrap">
                                <table class="table table-hover" id="table_pmcompoff" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th>Action</th>
                                            <th>Sr. #</th>
                                            <th>Code</th>
                                            <th>EmpName</th>
                                            <th>Branch</th>
                                            <th>Department</th>
                                            <th>Designation</th>
                                            <th>Domain</th>
                                            <th>Sub-Domain</th>
                                            <th>Reporting Manager</th>
                                            <th>Worked-Holiday</th>
                                            <th>Compensatory Off</th>
                                            <th>Remark</th>
                                            <th>Requested Date</th>
                                            <th>Approval Status</th>
                                            <th>Approval Remark</th>
                                            <th>Approved By</th>
                                            <th>Approved Date</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </main>

    <div class="modal fade" id="teamCompOffadd_details" data-backdrop="static" tabindex="-1">
        <div class="modal-dialog modal-xl modal-dialog-centered">
            <div class="modal-content custom-comp-modal">
                <div class="modal-header custom-comp-header">
                    <h5 class="modal-title"><i class="fa fa-calendar-plus mr-2"></i>Add Compensatory Off</h5>
                    <button type="button" class="close text-white" data-dismiss="modal"><span>&times;</span></button>
                </div>

                <div class="modal-body p-4">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label>Employee</label>
                            <select id="teamCompOffadd_user" class="form-control custom-input" onchange="return bindTeamtHoliday(this);">
                                <option value="Select">Select</option>
                            </select>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label>Worked Holiday Date</label>
                            <select id="temcompoffadd_holidaydate" class="form-control custom-input">
                                <option value="Select">Select</option>
                            </select>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label>Comp Off Date</label>
                            <input type="text" id="teamcompoffadd_date" class="form-control custom-input" placeholder="dd-MMM-yyyy" />
                        </div>

                        <div class="col-md-6 mb-3">
                            <label>Remark</label>
                            <textarea id="teamCompOffadd_remark" class="form-control custom-input" rows="2" placeholder="Enter reason or note"></textarea>
                        </div>
                    </div>
                </div>

                <div class="modal-footer custom-footer">
                    <button type="button" class="btn co-btn-light" data-dismiss="modal">Cancel</button>
                    <button type="button" class="btn gradient-btn" onclick="return teamCompOffAdd_btnSubmit();">
                        <i class="fas fa-paper-plane mr-1"></i>Submit
                   
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="teamCompOff_details" data-backdrop="static" tabindex="-1">
        <div class="modal-dialog modal-xl modal-dialog-centered">
            <div class="modal-content custom-comp-modal">
                <div class="modal-header custom-comp-header">
                    <h5 class="modal-title" id="teamCompOff_lbldetails"></h5>
                    <button type="button" class="close text-white" data-dismiss="modal"><span>&times;</span></button>
                </div>

                <div class="modal-body p-4">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label>Worked Holiday Date</label>
                            <input type="text" id="temcompoff_holidaydate" readonly class="form-control custom-input" />
                        </div>

                        <div class="col-md-6 mb-3">
                            <label>Comp Off Date</label>
                            <input type="text" id="teamcompoff_date" readonly class="form-control custom-input" />
                        </div>

                        <div class="col-md-6 mb-3">
                            <label>Status</label>
                            <select id="teamCompOff_Status" class="form-control custom-input">
                                <option value="Select">Select</option>
                                <option value="Approved">Approve</option>
                                <option value="Rejected">Reject</option>
                            </select>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label>Remark</label>
                            <textarea id="teamCompOff_remark" class="form-control custom-input" rows="2" placeholder="Enter approval remark"></textarea>
                        </div>
                    </div>
                </div>

                <div class="modal-footer custom-footer">
                    <button type="button" class="btn co-btn-light" data-dismiss="modal">Cancel</button>
                    <button type="button" class="btn gradient-btn" onclick="return teamCompOff_btnSubmit();">
                        <i class="fas fa-check mr-1"></i>Submit
                   
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="compoff_dverror">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header border-0 pb-0">
                    <h6 class="modal-title font-weight-bold" id="compoff_errmsg"></h6>
                </div>
                <div class="modal-footer border-0 justify-content-center">
                    <button class="btn gradient-btn" type="button" id="compoff_btnMessage" onclick="return compoff_Message();">Okay</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>


