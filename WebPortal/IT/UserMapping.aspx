<%@ Page Title="User Mapping Management" Language="C#" MasterPageFile="~/IT/Admin.Master" AutoEventWireup="true" CodeBehind="UserMapping.aspx.cs" Inherits="WebPortal.IT.UserMapping" %>

<asp:Content ID="UserMappingHead" ContentPlaceHolderID="head" runat="server">
    <style>
        .um-page {
            padding: 8px 0 28px;
            color: #172b4d
        }

        .um-hero {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            padding: 20px 24px;
            margin-bottom: 18px;
            border-radius: 16px;
            color: #fff;
            background: linear-gradient(120deg,#174ea6,#167d9a);
            box-shadow: 0 10px 26px rgba(26,66,116,.14)
        }

            .um-hero h1 {
                font-size: 22px;
                font-weight: 700;
                margin: 0
            }

        .um-context {
            margin: 6px 0 0;
            opacity: .92
        }

        .um-card {
            background: #fff;
            border: 1px solid #e1e9f2;
            border-radius: 14px;
            box-shadow: 0 8px 22px rgba(25,55,90,.06);
            padding: 18px;
            margin-bottom: 16px
        }

            .um-card h2 {
                font-size: 16px;
                font-weight: 700;
                margin: 0 0 16px
            }

        .um-grid {
            display: grid;
            grid-template-columns: repeat(3,minmax(0,1fr));
            gap: 14px
        }

            .um-grid.two {
                grid-template-columns: repeat(2,minmax(0,1fr))
            }

        .um-field {
            min-width: 0
        }

            .um-field.full {
                grid-column: 1/-1
            }

            .um-field label {
                display: block;
                font-weight: 600;
                font-size: 12px;
                margin: 0 0 6px;
                color: #334155
            }

            .um-field .form-control {
                min-height: 38px;
                border-radius: 8px
            }

        .um-required {
            color: #b91c1c
        }

        .um-actions {
            display: flex;
            align-items: center;
            gap: 9px;
            flex-wrap: wrap
        }

        .um-tabs {
            border-bottom: 1px solid #d9e4f0;
            margin-bottom: 16px
        }

            .um-tabs .nav-link {
                font-weight: 700;
                color: #52627a
            }

                .um-tabs .nav-link.active {
                    color: #185abc;
                    border-color: #d9e4f0 #d9e4f0 #fff
                }

        .um-table-wrap {
            width: 100%;
            overflow-x: auto
        }

        .um-muted {
            font-size: 12px;
            color: #64748b
        }

        .um-status {
            display: inline-block;
            border-radius: 20px;
            padding: 3px 9px;
            font-size: 11px;
            font-weight: 700;
            background: #e7f7ed;
            color: #18723b
        }

            .um-status.off {
                background: #f1f3f5;
                color: #687385
            }

        .um-validation {
            display: none;
            color: #b91c1c;
            font-size: 12px;
            margin-top: 5px
        }

        .um-loader {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(255,255,255,.68);
            z-index: 10000;
            align-items: center;
            justify-content: center
        }

            .um-loader.show {
                display: flex
            }

            .um-loader span {
                background: #fff;
                padding: 14px 20px;
                border-radius: 10px;
                box-shadow: 0 6px 24px #94a3b866;
                font-weight: 700
            }

        .um-section-note {
            padding: 10px 12px;
            background: #f3f8ff;
            border-left: 3px solid #2870ca;
            border-radius: 5px;
            margin-bottom: 12px;
            font-size: 12px
        }

        .dataTables_wrapper .dataTables_filter input {
            margin-left: 6px
        }

        .um-table {
            min-width: 800px !important
        }

        @media(max-width:900px) {
            .um-grid {
                grid-template-columns: repeat(2,minmax(0,1fr))
            }

            .um-hero {
                align-items: flex-start;
                flex-direction: column
            }
        }

        @media(max-width:600px) {
            .um-grid, .um-grid.two {
                grid-template-columns: 1fr
            }

            .um-field.full {
                grid-column: auto
            }

            .um-card {
                padding: 13px
            }

            .um-hero {
                padding: 17px
            }
        }
    </style>
    <script src="../Scripts/Functions/UserMapping.js"></script>
</asp:Content>
<asp:Content ID="UserMappingBody" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="um-page" id="um_page" data-header-id="<%= HeaderID %>" data-month="<%= System.Web.HttpUtility.HtmlAttributeEncode(Month) %>" data-year="<%= System.Web.HttpUtility.HtmlAttributeEncode(Year) %>">
        <header class="um-hero">
            <div>
                <h1><i class="fas fa-users-cog"></i>User Mapping Management</h1>
                <p class="um-context" id="um_context">Loading invoice and project details...</p>
            </div>
            <a class="btn btn-light" href="InvoiceVerification.aspx"><i class="fas fa-arrow-left"></i>Back to Invoice Verification</a>
        </header>

        <ul class="nav nav-tabs um-tabs" role="tablist">
            <li class="nav-item"><a class="nav-link active" data-toggle="tab" href="#um_tab_users" role="tab">Add New User</a></li>
            <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#um_tab_resources" role="tab">Non-Employee / Corporate Resources</a></li>
            <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#um_tab_report" role="tab">Consolidated Report</a></li>
        </ul>
        <div class="tab-content">
            <section class="tab-pane fade show active" id="um_tab_users" role="tabpanel">
                <div class="um-card">
                    <h2><i class="fas fa-user-plus text-primary"></i>Add New User</h2>
                    <div class="um-grid">
                        <div class="um-field">
                            <label for="um_employee">Employee <span class="um-required">*</span></label><select id="um_employee" class="form-control"><option value="">Loading employees...</option>
                            </select>
                        </div>
                        <div class="um-field" id="um_other_wrap" style="display: none">
                            <label for="um_other">Other user <span class="um-required">*</span></label><input id="um_other" class="form-control" maxlength="200" />
                        </div>
                        <div class="um-field">
                            <label for="um_user_from">Effective Date <span class="um-required">*</span></label><input type="date" id="um_user_from" class="form-control" />
                        </div>
                    </div>
                    <div class="um-actions mt-3">
                        <button id="um_add_user" type="button" class="btn btn-primary"><i class="fas fa-plus"></i>Add User</button><span class="um-muted">Existing duplicate and employee rules are applied by the current invoice user mapping procedure.</span>
                    </div>
                    <div class="um-validation" id="um_user_error"></div>
                </div>

                <div class="um-card">
                    <h2><i class="fas fa-list text-primary"></i>Invoice Users</h2>
                    <div class="um-table-wrap">
                        <table id="um_users_table" class="table table-striped table-hover um-table">
                            <thead>
                                <tr>
                                    <th>Sr.</th>
                                    <th>Number</th>
                                    <th>Cost</th>
                                    <th>Code</th>
                                    <th>Name</th>
                                    <th>Pseudoname</th>
                                    <th>Branch</th>
                                    <th>Domain</th>
                                    <th>Project</th>
                                    <th>Current Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </section>

            <section class="tab-pane fade" id="um_tab_resources" role="tabpanel">
                <div class="um-card">
                    <h2><i class="fas fa-building text-primary"></i>Corporate Resource</h2>
                    <input type="hidden" id="um_resource_id" value="0" />
                    <div class="um-grid">
                        <div class="um-field">
                            <label for="um_resource_name">Resource Name <span class="um-required">*</span></label><input id="um_resource_name" class="form-control" maxlength="255" />
                        </div>
                        <div class="um-field">
                            <label for="um_resource_type">Resource Type <span class="um-required">*</span></label><select id="um_resource_type" class="form-control"><option value="">Select</option>
                                <option>Shared Mailbox</option>
                                <option>Microsoft Teams Resource</option>
                                <option>Departmental Account</option>
                                <option>Shared/Common Account</option>
                                <option>Service Account</option>
                                <option>Other</option>
                            </select>
                        </div>
                        <div class="um-field">
                            <label for="um_account">Email / Account Identifier</label><input id="um_account" class="form-control" maxlength="255" />
                        </div>
                        <div class="um-field">
                            <label for="um_project">Project <span class="um-required">*</span></label>
                            <select id="um_project" class="form-control">
                                <option value="">Select project</option>
                            </select>
                        </div>
                        <div class="um-field">
                            <label for="um_domain">Department / Domain</label><%--<select id="um_domain" class="form-control"><option value="">Select</option>
                            </select>--%>
                            <input id="um_domain" class="form-control" />
                        </div>
                        <div class="um-field">
                            <label for="um_resource_from">Effective From <span class="um-required">*</span></label><input type="date" id="um_resource_from" class="form-control" />
                        </div>
                        <div class="um-field">
                            <label for="um_resource_to">Effective To</label><input type="date" id="um_resource_to" class="form-control" />
                        </div>
                        <div class="um-field">
                            <label for="um_resource_status">Status</label><select id="um_resource_status" class="form-control"><option value="1">Active</option>
                                <option value="0">Deactivated</option>
                            </select>
                        </div>
                        <div class="um-field full">
                            <label for="um_description">Description / Purpose</label><textarea id="um_description" class="form-control" rows="2" maxlength="1000"></textarea>
                        </div>
                        <div class="um-field full">
                            <label for="um_remark">Remark</label><textarea id="um_remark" class="form-control" rows="2" maxlength="1000"></textarea>
                        </div>
                    </div>
                    <div class="um-actions mt-3">
                        <button id="um_save_resource" type="button" class="btn btn-primary"><i class="fas fa-save"></i>Save Resource</button>
                        <button id="um_clear_resource" type="button" class="btn btn-outline-secondary">Clear</button>
                    </div>
                    <div class="um-validation" id="um_resource_error"></div>
                </div>
                <div class="um-card">
                    <h2><i class="fas fa-link text-primary"></i>Employee Mapping</h2>
                    <div class="um-section-note">Each employee relationship keeps its own effective dates and history. Ending a mapping preserves the record.</div>
                    <div class="um-grid">
                        <div class="um-field">
                            <label for="um_mapping_resource">Corporate Resource <span class="um-required">*</span></label><select id="um_mapping_resource" class="form-control"><option value="">Select or use Manage Mapping from the resource list</option>
                            </select>
                        </div>
                        <div class="um-field">
                            <label for="um_mapping_employees">Employees <span class="um-required">*</span></label><select id="um_mapping_employees" class="form-control" multiple size="5"></select><small class="um-muted">Use Ctrl/Cmd to select more than one employee.</small>
                        </div>
                        <div class="um-field">
                            <label for="um_mapping_from">Effective From <span class="um-required">*</span></label><input type="date" id="um_mapping_from" class="form-control" />
                        </div>
                        <div class="um-field">
                            <label for="um_mapping_to">Effective To</label><input type="date" id="um_mapping_to" class="form-control" />
                        </div>
                    </div>
                    <div class="um-actions mt-3">
                        <button id="um_save_mapping" type="button" class="btn btn-primary"><i class="fas fa-user-plus"></i>Add Employee Mapping</button>
                        <button id="um_cancel_mapping_edit" type="button" class="btn btn-outline-secondary" style="display: none">Cancel Edit</button>
                        <button id="um_associate_billing" type="button" class="btn btn-outline-primary"><i class="fas fa-file-invoice-dollar"></i>Associate With This Billing Period</button>
                    </div>
                    <div class="um-validation" id="um_mapping_error"></div>
                    <div class="um-table-wrap mt-3">
                        <table id="um_mappings_table" class="table table-sm table-striped um-table">
                            <thead>
                                <tr>
                                    <th>Employee</th>
                                    <th>Effective From</th>
                                    <th>Effective To</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
                <div class="um-card">
                    <div class="um-actions justify-content-between">
                        <h2 class="mb-0"><i class="fas fa-table text-primary"></i>Corporate Resources</h2>
                        <select id="um_resource_filter_project" class="form-control" style="max-width: 280px"></select>
                    </div>
                    <div class="um-table-wrap mt-3">
                        <table id="um_resources_table" class="table table-striped table-hover um-table">
                            <thead>
                                <tr>
                                    <th>Resource ID</th>
                                    <th>Resource Name</th>
                                    <th>Resource Type</th>
                                    <th>Email / Account</th>
                                    <th>Project</th>
                                    <th>Department / Domain</th>
                                    <th>Mapped Employees</th>
                                    <th>Effective From</th>
                                    <th>Effective To</th>
                                    <th>Status</th>
                                    <th>Remark</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </section>

            <section class="tab-pane fade" id="um_tab_report" role="tabpanel">
                <div class="um-card">
                    <h2><i class="fas fa-chart-bar text-primary"></i>Consolidated Report</h2>
                    <div class="um-grid">
                        <div class="um-field">
                            <label for="um_report_month">Billing Month</label><select id="um_report_month" class="form-control"><option value="">All</option>
                                <option>January</option>
                                <option>February</option>
                                <option>March</option>
                                <option>April</option>
                                <option>May</option>
                                <option>June</option>
                                <option>July</option>
                                <option>August</option>
                                <option>September</option>
                                <option>October</option>
                                <option>November</option>
                                <option>December</option>
                            </select>
                        </div>
                        <div class="um-field">
                            <label for="um_report_year">Billing Year</label><select id="um_report_year" class="form-control"><option value="">All</option>
                            </select>
                        </div>
                        <div class="um-field">
                            <label for="um_report_type">Record Type</label><select id="um_report_type" class="form-control"><option value="">All</option>
                                <option>Employee</option>
                                <option>Corporate Resource</option>
                            </select>
                        </div>
                        <div class="um-field">
                            <label for="um_report_project">Project</label><select id="um_report_project" class="form-control"><option value="">All</option>
                            </select>
                        </div>
                        <div class="um-field">
                            <label for="um_report_domain">Department / Domain</label><select id="um_report_domain" class="form-control"><option value="">All</option>
                            </select>
                        </div>
                        <div class="um-field">
                            <label for="um_report_resource_type">Resource Type</label><select id="um_report_resource_type" class="form-control"><option value="">All</option>
                                <option>Shared Mailbox</option>
                                <option>Microsoft Teams Resource</option>
                                <option>Departmental Account</option>
                                <option>Shared/Common Account</option>
                                <option>Service Account</option>
                                <option>Other</option>
                            </select>
                        </div>
                        <div class="um-field">
                            <label for="um_report_status">Status</label><select id="um_report_status" class="form-control"><option value="">All</option>
                                <option value="1">Active</option>
                                <option value="0">Deactivated</option>
                            </select>
                        </div>
                        <div class="um-field">
                            <label for="um_report_from">Effective From</label><input type="date" id="um_report_from" class="form-control" />
                        </div>
                        <div class="um-field">
                            <label for="um_report_to">Effective To</label><input type="date" id="um_report_to" class="form-control" />
                        </div>
                    </div>
                    <div class="um-actions mt-3">
                        <button id="um_run_report" type="button" class="btn btn-primary"><i class="fas fa-search"></i>Run Report</button>
                    </div>
                </div>
                <div class="um-card">
                    <div class="um-table-wrap">
                        <table id="um_report_table" class="table table-striped table-hover um-table">
                            <thead>
                                <tr>
                                    <th>Record Type</th>
                                    <th>Employee / Resource</th>
                                    <th>Employee Code / Resource ID</th>
                                    <th>Resource Type</th>
                                    <th>Email / Account</th>
                                    <th>Project</th>
                                    <th>Department</th>
                                    <th>Domain</th>
                                    <th>Mapped Employees</th>
                                    <th>Billing Month</th>
                                    <th>Billing Year</th>
                                    <th>Billing Date</th>
                                    <th>Effective From</th>
                                    <th>Effective To</th>
                                    <th>Billing Amount</th>
                                    <th>Status</th>
                                    <th>Remark</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </section>
        </div>
    </div>
    <div class="um-loader" id="um_loader"><span><i class="fas fa-spinner fa-spin"></i>Please wait...</span></div>
    <div class="modal fade" id="um_message_modal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 id="um_message_title" class="modal-title">Notice</h5>
                    <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                </div>
                <div id="um_message_body" class="modal-body"></div>
                <div class="modal-footer">
                    <button class="btn btn-primary" data-dismiss="modal">OK</button>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="um_confirm_modal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Confirm action</h5>
                    <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                </div>
                <div id="um_confirm_body" class="modal-body"></div>
                <div class="modal-footer">
                    <button class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <button id="um_confirm_yes" class="btn btn-primary">Confirm</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
