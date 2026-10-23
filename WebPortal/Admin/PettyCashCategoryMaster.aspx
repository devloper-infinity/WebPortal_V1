<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="PettyCashCategoryMaster.aspx.cs" Inherits="WebPortal.Admin.PettyCashCategoryMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .pc-page {
            padding-top: 18px !important;
            padding-bottom: 28px;
            color: #fff;
        }

        .pc-hero {
            position: relative;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 24px;
            overflow: hidden;
            /*  min-height: 144px;*/
            padding: 20px 25px;
            margin-bottom: 20px;
            border-radius: 18px;
            color: #fff;
            background: linear-gradient(115deg,#123d70 0%,#1769a2 56%,#16a6b2 100%);
            box-shadow: 0 12px 30px rgba(22,73,116,.18)
        }

            .pc-hero:before, .pc-hero:after {
                position: absolute;
                content: "";
                border-radius: 50%;
                pointer-events: none
            }

            .pc-hero:before {
                width: 280px;
                height: 280px;
                right: 110px;
                top: -190px;
                background: rgba(255,255,255,.08)
            }

            .pc-hero:after {
                width: 210px;
                height: 210px;
                right: -50px;
                bottom: -155px;
                border: 1px solid rgba(255,255,255,.18)
            }

        .pc-hero-copy, .pc-hero-mark {
            position: relative;
            z-index: 1
        }

        .pc-eyebrow {
            display: inline-block;
            margin-bottom: 7px;
            color: rgba(230,247,255,.78);
            font-size: 10px;
            font-weight: 750;
            letter-spacing: .16em;
            text-transform: uppercase
        }

        .pc-hero h1 {
            margin: 0;
            color: #fff;
            font-size: clamp(20px,3vw,23px);
            font-weight: 650;
            letter-spacing: -.035em
        }

        .pc-hero p {
            margin: 7px 0 0;
            color: rgba(240,249,255,.83);
            font-size: 13px
        }

        .pc-hero-mark {
            display: flex;
            width: 66px;
            height: 66px;
            align-items: center;
            justify-content: center;
            border: 1px solid rgba(255,255,255,.28);
            border-radius: 20px;
            background: rgba(255,255,255,.13);
            box-shadow: inset 0 1px 0 rgba(255,255,255,.18);
            font-size: 27px;
            color: #fff
        }

        .pc-card {
            overflow: hidden;
            border: 1px solid #e1eaf3;
            border-radius: 16px;
            background: #fff;
            box-shadow: 0 7px 24px rgba(18,52,86,.06)
        }

            .pc-card .card-body {
                padding: 24px
            }

        .pc-card-heading {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 18px;
            margin-bottom: 22px
        }

            .pc-card-heading h2 {
                margin: 2px 0 5px;
                color: #183858;
                font-size: 17px;
                font-weight: 750;
                letter-spacing: -.015em
            }

            .pc-card-heading p {
                margin: 0;
                color: #71849b;
                font-size: 12px
            }

        .pc-kicker {
            color: #187b97;
            font-size: 10px;
            font-weight: 750;
            letter-spacing: .12em;
            text-transform: uppercase
        }

        .pc-context-badge {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 8px 11px;
            border: 1px solid #dcebf2;
            border-radius: 999px;
            background: #f4fafc;
            color: #477086;
            font-size: 10px;
            font-weight: 700;
            white-space: nowrap
        }

        .pc-label {
            display: block;
            margin-bottom: 8px;
            color: #435b74;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: .045em;
            text-transform: uppercase
        }

        .pc-required {
            color: #e25858
        }

        .pc-form-control {
            height: 44px !important;
            border: 1px solid #d8e2ec !important;
            border-radius: 10px !important;
            background-color: #fbfdff !important;
            color: #193956 !important;
            font-size: 13px !important;
            box-shadow: 0 1px 2px rgba(22,54,91,.025) !important;
            transition: border-color .18s ease,box-shadow .18s ease !important
        }

            .pc-form-control:focus {
                border-color: #5a9fd0 !important;
                background: #fff !important;
                box-shadow: 0 0 0 4px rgba(43,139,190,.12) !important;
                outline: 0
            }

        .pc-form-actions {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-top: 22px;
            padding-top: 18px;
            border-top: 1px solid #edf2f7
        }

        .pc-btn-primary, .pc-btn-reset {
            display: inline-flex;
            min-height: 41px;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 9px 17px;
            border-radius: 10px !important;
            font-size: 12px !important;
            font-weight: 700 !important;
            transition: transform .16s ease,box-shadow .16s ease,background .16s ease !important
        }

        .pc-btn-primary {
            border: 0 !important;
            background: linear-gradient(110deg,#146bb3,#0da99d) !important;
            color: #fff !important;
            box-shadow: 0 7px 15px rgba(24,129,159,.18) !important
        }

            .pc-btn-primary:hover {
                transform: translateY(-1px);
                box-shadow: 0 10px 19px rgba(24,129,159,.25) !important
            }

        .pc-btn-reset {
            border: 1px solid #d7e2ed !important;
            background: #fff !important;
            color: #49627b !important
        }

            .pc-btn-reset:hover {
                border-color: #9db6cc !important;
                background: #f5f9fc !important;
                color: #1b4e76 !important
            }

        .pc-table-card {
            margin-top: 20px
        }

            .pc-table-card .card-body {
                padding: 22px 24px
            }

        #pc_CategoryTable {
            margin: 0 !important;
            border: 1px solid #e3eaf1;
            border-radius: 11px;
            overflow: hidden;
            color: #29445f;
            font-size: 12px
        }

            #pc_CategoryTable thead th {
                padding: 13px 14px;
                border: 0;
                border-bottom: 1px solid #28517b;
                background: #12395f;
                color: #fff;
                font-size: 10px;
                font-weight: 750;
                letter-spacing: .055em;
                text-transform: uppercase;
                white-space: nowrap
            }

            #pc_CategoryTable tbody td {
                padding: 12px 14px;
                border-color: #edf1f5;
                vertical-align: middle
            }

            #pc_CategoryTable tbody tr:nth-child(even) {
                background: #f8fafc
            }

            #pc_CategoryTable tbody tr:hover {
                background: #eff7fc
            }

        .pc-status {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 5px 10px;
            border-radius: 999px;
            background: #e9f8f0;
            color: #16804c;
            font-size: 10px;
            font-weight: 750
        }

            .pc-status:before {
                width: 6px;
                height: 6px;
                border-radius: 50%;
                background: currentColor;
                content: ""
            }

            .pc-status.inactive {
                background: #fff1f0;
                color: #c24a4a
            }

        .pc-edit-btn {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 7px 12px !important;
            border: 1px solid #d5e3ef !important;
            border-radius: 9px !important;
            background: #fff !important;
            color: #17659c !important;
            font-size: 11px !important;
            font-weight: 700 !important
        }

            .pc-edit-btn:hover {
                border-color: #176fa8 !important;
                background: #edf7fc !important;
                color: #124f79 !important
            }

        .pc-page .dataTables_wrapper {
            color: #62778e;
            font-size: 11px
        }

            .pc-page .dataTables_wrapper .dataTables_length, .pc-page .dataTables_wrapper .dataTables_filter {
                margin-bottom: 14px;
                color: #657a90;
                font-size: 11px
            }

                .pc-page .dataTables_wrapper .dataTables_length select, .pc-page .dataTables_wrapper .dataTables_filter input {
                    min-height: 34px;
                    padding: 5px 10px;
                    border: 1px solid #d7e2ed;
                    border-radius: 9px;
                    background: #fff;
                    color: #28445f;
                    outline: 0
                }

                    .pc-page .dataTables_wrapper .dataTables_filter input:focus, .pc-page .dataTables_wrapper .dataTables_length select:focus {
                        border-color: #63a3cf;
                        box-shadow: 0 0 0 3px rgba(43,139,190,.1)
                    }

            .pc-page .dataTables_wrapper .dataTables_info {
                padding-top: 14px;
                color: #71849b
            }

            .pc-page .dataTables_wrapper .dataTables_paginate {
                padding-top: 8px
            }

                .pc-page .dataTables_wrapper .dataTables_paginate .paginate_button {
                    border: 0 !important;
                    border-radius: 8px !important;
                    color: #47627d !important
                }

                    .pc-page .dataTables_wrapper .dataTables_paginate .paginate_button.current, .pc-page .dataTables_wrapper .dataTables_paginate .paginate_button.current:hover {
                        border: 0 !important;
                        background: #eaf4fb !important;
                        color: #17659c !important
                    }

        .modal-content.pc-modal {
            overflow: hidden;
            border: 1px solid #e3eaf1;
            border-radius: 15px;
            box-shadow: 0 18px 45px rgba(15,39,66,.2)
        }

            .modal-content.pc-modal .modal-header {
                border-bottom: 1px solid #edf2f7;
                background: #f8fbfd
            }

        @media(max-width:767.98px) {
            .pc-page {
                padding: 12px !important
            }

            .pc-hero {
                min-height: 124px;
                padding: 22px;
                border-radius: 15px
            }

            .pc-hero-mark {
                width: 52px;
                height: 52px;
                border-radius: 16px;
                font-size: 22px
            }

            .pc-card .card-body, .pc-table-card .card-body {
                padding: 18px
            }

            .pc-card-heading {
                margin-bottom: 18px
            }

            .pc-form-actions {
                margin-top: 18px
            }
        }
    </style>
    <div class="container-fluid py-3 pc-page" style="color: white!important;">
        <header class="pc-hero">
            <div class="pc-hero-copy">
                <%--<span class="pc-eyebrow">Finance · Configuration</span>--%><h1>Petty Cash Category Master</h1>
                <p>Organize expense categories and keep request options up to date.</p>
            </div>
            <div class="pc-hero-mark" aria-hidden="true"><i class="fas fa-layer-group"></i></div>
        </header>
        <section class="card pc-card pc-form-card">
            <div class="card-body">
                <div class="pc-card-heading">
                    <div>
                        <span class="pc-kicker">Category setup</span><h2>Category details</h2>
                        <p>Create a category or edit an existing one.</p>
                    </div>
                    <span class="pc-context-badge"><i class="fas fa-sliders-h" aria-hidden="true"></i>Master data</span>
                </div>
                <input type="hidden" id="pc_catId" value="0" />
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label class="pc-label" for="pc_catName">Category name <span class="pc-required">*</span></label><input id="pc_catName" maxlength="150" class="form-control pc-form-control" placeholder="e.g. Travel and conveyance" autocomplete="off" />
                    </div>
                    <div class="col-md-5 mb-3">
                        <label class="pc-label" for="pc_catDescription">Description</label><input id="pc_catDescription" maxlength="500" class="form-control pc-form-control" placeholder="Briefly describe what this category covers" />
                    </div>
                    <div class="col-md-3 mb-3">
                        <label class="pc-label" for="pc_catActive">Status</label><select id="pc_catActive" class="form-control pc-form-control"><option value="true">Active</option>
                            <option value="false">Inactive</option>
                        </select>
                    </div>
                </div>
                <div class="pc-form-actions">
                    <button class="btn pc-btn-primary" type="button" onclick="pc_categorySave()"><i class="fas fa-check" aria-hidden="true"></i><span>Save category</span></button>
                    <button class="btn pc-btn-reset" type="button" onclick="pc_categoryClear()"><i class="fas fa-undo-alt" aria-hidden="true"></i><span>Reset form</span></button>
                </div>
            </div>
        </section>
        <section class="card pc-card pc-table-card">
            <div class="card-body">
                <div class="pc-card-heading">
                    <div>
                        <span class="pc-kicker">Expense setup</span><h2>Categories</h2>
                        <p>Review current categories and update their details or status.</p>
                    </div>
                    <span class="pc-context-badge"><i class="fas fa-list-ul" aria-hidden="true"></i>Category directory</span>
                </div>
                <table id="pc_CategoryTable" class="table w-100">
                    <thead>
                        <tr>
                            <th>Category</th>
                            <th>Description</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                </table>
            </div>
        </section>
    </div>

    <div class="modal fade" id="pcMessageModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content pc-modal">
                <div class="modal-header">
                    <h5 class="modal-title" id="pcMessageTitle">Message</h5>
                    <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                </div>
                <div class="modal-body" id="pcMessageBody"></div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-dismiss="modal">OK</button>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="pcConfirmModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content pc-modal">
                <div class="modal-header">
                    <h5 class="modal-title" id="pcConfirmTitle">Confirmation</h5>
                    <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                </div>
                <div class="modal-body" id="pcConfirmMessage"></div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="pcConfirmYes">Yes</button>
                </div>
            </div>
        </div>
    </div>
    <div id="load1" style="display: none; position: fixed; z-index: 20000; left: 50%; top: 50%; transform: translate(-50%,-50%); background: #fff; padding: 14px 18px; border-radius: 8px; box-shadow: 0 4px 24px rgba(0,0,0,.2)"><span class="spinner-border spinner-border-sm mr-2"></span>Processing...</div>
    <script src="<%= ResolveUrl("~/Scripts/Functions/PettyCash.js?v=20261022-6") %>"></script>
</asp:Content>
