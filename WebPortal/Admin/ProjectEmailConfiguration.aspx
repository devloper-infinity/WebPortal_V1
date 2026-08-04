<%@ Page Title="Project Email Configuration" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ProjectEmailConfiguration.aspx.cs" Inherits="WebPortal.Admin.ProjectEmailConfiguration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../plugins/sweetalert2-theme-bootstrap-4/bootstrap-4.min.css" />
    <link rel="stylesheet" href="../plugins/sweetalert2/sweetalert2.min.css" />
    <style>
        .pec-page { padding: 18px; color: #172033; }
        .pec-hero, .pec-card { background: #fff; border: 1px solid #d9e3ed; border-radius: 12px; box-shadow: 0 8px 22px rgba(15,23,42,.06); }
        .pec-hero { display: flex; align-items: center; gap: 14px; padding: 18px 22px; margin-bottom: 16px; border-left: 4px solid #0f8a7d; }
        .pec-hero-icon { width: 50px; height: 50px; display: inline-flex; align-items: center; justify-content: center; flex: 0 0 50px; border-radius: 14px; color: #fff; background: linear-gradient(135deg,#0f8a7d,#22b8a7); box-shadow: 0 8px 18px rgba(15,138,125,.24); font-size: 22px; }
        .pec-hero h2 { margin: 0; font-size: 22px; font-weight: 700; }
        .pec-hero p { margin: 3px 0 0; color: #617086; font-size: 12px; }
        .pec-card { overflow: hidden; margin-bottom: 16px; }
        .pec-card-header { display: flex; align-items: center; justify-content: space-between; gap: 12px; padding: 14px 18px; background: #f7fafc; border-bottom: 1px solid #dfe7ef; }
        .pec-card-title { margin: 0; font-size: 14px; font-weight: 700; color: #0f5f59; }
        .pec-card-subtitle { margin-top: 2px; color: #6b7b90; font-size: 11px; }
        .pec-card-body { padding: 20px; }
        .pec-label { display: block; margin-bottom: 7px; color: #28374b; font-size: 12px; font-weight: 700; }
        .pec-required { color: #dc3545; }
        .pec-control { width: 100%; height: 42px; padding: 8px 12px; color: #172033; background: #fff; border: 1px solid #cbd7e3; border-radius: 9px; outline: none; transition: border-color .18s,box-shadow .18s; }
        .pec-control:focus { border-color: #0f8a7d; box-shadow: 0 0 0 3px rgba(15,138,125,.12); }
        .pec-recipient-grid { display: grid; grid-template-columns: repeat(2,minmax(0,1fr)); gap: 16px; margin-top: 20px; }
        .pec-recipient-box { padding: 16px; border: 1px solid #dce7ed; border-radius: 11px; background: #f8fbfc; }
        .pec-recipient-box.to-box { border-top: 3px solid #0f8a7d; }
        .pec-recipient-box.cc-box { border-top: 3px solid #3b82f6; }
        .pec-section-heading { display: flex; align-items: center; justify-content: space-between; gap: 10px; margin-bottom: 10px; }
        .pec-section-heading h3 { margin: 0; font-size: 13px; font-weight: 700; }
        .pec-helper { margin: 4px 0 0; color: #738196; font-size: 10px; }
        .pec-email-row { display: grid; grid-template-columns: minmax(0,1fr) 40px; gap: 8px; margin-top: 9px; animation: pecRowIn .18s ease-out; }
        .pec-input-wrap { position: relative; }
        .pec-input-wrap > i { position: absolute; left: 13px; top: 50%; color: #8090a3; transform: translateY(-50%); }
        .pec-email-input { padding-left: 38px; }
        .pec-btn { height: 40px; display: inline-flex; align-items: center; justify-content: center; gap: 7px; padding: 0 15px; border: 0; border-radius: 9px; font-size: 12px; font-weight: 700; cursor: pointer; transition: transform .15s,opacity .15s; }
        .pec-btn:hover { transform: translateY(-1px); }
        .pec-btn:disabled { cursor: not-allowed; opacity: .62; transform: none; }
        .pec-btn-add { height: 34px; color: #0f766e; background: #e8f8f5; border: 1px solid #a7e2d8; }
        .cc-box .pec-btn-add { color: #1d4ed8; background: #eff6ff; border-color: #bfdbfe; }
        .pec-btn-remove { width: 40px; padding: 0; color: #c53030; background: #fff0f0; border: 1px solid #f2c3c3; }
        .pec-actions { display: flex; justify-content: flex-end; padding: 15px 20px; background: #fbfcfd; border-top: 1px solid #e2e9f0; }
        .pec-btn-save { min-width: 150px; color: #fff; background: linear-gradient(135deg,#087f73,#0ca392); box-shadow: 0 8px 18px rgba(8,127,115,.20); }
        .pec-status { display: none; align-items: center; gap: 7px; padding: 7px 10px; color: #0f766e; background: #eafaf6; border: 1px solid #b8e8dc; border-radius: 18px; font-size: 10px; font-weight: 700; }
        .pec-loading { opacity: .58; pointer-events: none; }
        .pec-table-wrap { padding: 14px; overflow-x: auto; }
        #pecConfigurationTable { width: 100% !important; }
        #pecConfigurationTable thead th { padding: 10px 9px; white-space: nowrap; color: #184b50; background: #e8f5f4; border-top: 2px solid #15998b; border-bottom: 1px solid #a9d7d2; font-size: 11px; }
        #pecConfigurationTable tbody td { padding: 9px; vertical-align: middle; border-color: #e1e8ee; font-size: 11px; }
        #pecConfigurationTable tbody tr:hover { background: #f5fbfa; }
        .pec-type-badge { display: inline-flex; min-width: 38px; justify-content: center; padding: 4px 8px; border-radius: 12px; font-size: 10px; font-weight: 800; }
        .pec-type-to { color: #0f766e; background: #dff7f1; }
        .pec-type-cc { color: #1d4ed8; background: #e7f0ff; }
        .pec-edit-btn { width: 31px; height: 31px; color: #0f766e; background: #e5f7f3; border: 1px solid #a9ddd4; border-radius: 8px; }
        .pec-email-chips, .pec-row-actions { display: flex; flex-wrap: wrap; gap: 5px; }
        .pec-row-actions { flex-wrap: nowrap; justify-content: center; }
        .pec-email-chip { display: inline-flex; align-items: center; gap: 5px; padding: 5px 8px; color: #334155; background: #f1f5f9; border: 1px solid #d9e2ec; border-radius: 14px; white-space: nowrap; font-size: 10px; }
        .pec-email-chip.to-chip { color: #0f5f59; background: #e9f9f5; border-color: #b7e6dc; }
        .pec-email-chip.cc-chip { color: #1e4fa3; background: #edf4ff; border-color: #c8daf8; }
        .pec-edit-btn.to-action { color: #0f766e; background: #e5f7f3; border-color: #a9ddd4; }
        .pec-edit-btn.cc-action { color: #1d4ed8; background: #edf4ff; border-color: #bfd2f5; }
        .pec-project-action { width: auto; min-width: 65px; padding: 0 9px; white-space: nowrap; font-size: 10px; font-weight: 700; }
        .pec-history-btn { color: #7c3aed; background: #f3edff; border-color: #d8c5ff; }
        .pec-history-action { display: inline-flex; padding: 4px 8px; border-radius: 12px; font-size: 9px; font-weight: 800; text-transform: uppercase; }
        .pec-history-insert,.pec-history-activate { color: #047857; background: #dff8ee; }
        .pec-history-update { color: #1d4ed8; background: #e7f0ff; }
        .pec-history-delete,.pec-history-deactivate { color: #b91c1c; background: #feeaea; }
        .pec-history-action i { margin-right: 5px; }
        .pec-status-pill { display: inline-flex; padding: 4px 8px; border-radius: 12px; font-size: 9px; font-weight: 800; text-transform: uppercase; }
        .pec-status-active { color: #047857; background: #dff8ee; }
        .pec-status-inactive { color: #b91c1c; background: #feeaea; }
        .pec-modal-header { color: #fff; background: linear-gradient(135deg,#0d756b,#15998b); border: 0; }
        .pec-modal-header .close { color: #fff; opacity: .9; }
        @keyframes pecRowIn { from { opacity: 0; transform: translateY(-4px); } to { opacity: 1; transform: translateY(0); } }
        @media (max-width: 900px) { .pec-recipient-grid { grid-template-columns: 1fr; } }
        @media (max-width: 767px) { .pec-page { padding: 10px; } .pec-hero,.pec-card-body { padding: 14px; } .pec-section-heading { align-items: flex-start; flex-direction: column; } .pec-btn-add,.pec-btn-save { width: 100%; } .pec-actions { padding: 13px 14px; } }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="pec-page">
        <section class="pec-hero">
            <span class="pec-hero-icon"><i class="fas fa-mail-bulk"></i></span>
            <div><h2>Project Email Configuration</h2><p>Maintain project-wise To and CC recipients with complete audit information.</p></div>
        </section>

        <section class="pec-card" id="pecConfigurationCard">
            <header class="pec-card-header">
                <div><h3 class="pec-card-title"><i class="fas fa-sliders-h mr-1"></i>Email Settings</h3><div class="pec-card-subtitle">Select a permitted project and configure its recipients.</div></div>
                <span class="pec-status" id="pecStatus"><i class="fas fa-check-circle"></i><span></span></span>
            </header>
            <div class="pec-card-body">
                <div class="row"><div class="col-lg-6 col-md-8 col-sm-12">
                    <label class="pec-label" for="pecProject">Project <span class="pec-required">*</span></label>
                    <select id="pecProject" class="pec-control"><option value="">Loading projects...</option></select>
                </div></div>

                <div class="pec-recipient-grid">
                    <section class="pec-recipient-box to-box">
                        <div class="pec-section-heading">
                            <div><h3><i class="fas fa-paper-plane mr-1 text-success"></i>To Email Address(es) <span class="pec-required">*</span></h3><p class="pec-helper">Primary recipients of project emails.</p></div>
                            <button type="button" class="pec-btn pec-btn-add" data-email-type="TO"><i class="fas fa-plus"></i>Add To</button>
                        </div>
                        <div id="pecToEmailList" class="pec-email-list" data-email-type="TO"></div>
                    </section>

                    <section class="pec-recipient-box cc-box">
                        <div class="pec-section-heading">
                            <div><h3><i class="fas fa-copy mr-1 text-primary"></i>CC Email Address(es)</h3><p class="pec-helper">Optional copied recipients.</p></div>
                            <button type="button" class="pec-btn pec-btn-add" data-email-type="CC"><i class="fas fa-plus"></i>Add CC</button>
                        </div>
                        <div id="pecCcEmailList" class="pec-email-list" data-email-type="CC"></div>
                    </section>
                </div>
            </div>
            <footer class="pec-actions"><button type="button" id="pecSave" class="pec-btn pec-btn-save"><i class="fas fa-save"></i>Save Configuration</button></footer>
        </section>

        <section class="pec-card">
            <header class="pec-card-header"><div><h3 class="pec-card-title"><i class="fas fa-list-alt mr-1"></i>Saved Email Configurations</h3><div class="pec-card-subtitle">Review and edit active project recipients.</div></div></header>
            <div class="pec-table-wrap">
                <table id="pecConfigurationTable" class="table table-bordered table-striped">
                    <thead><tr><th>Project</th><th>To Email Address(es)</th><th>CC Email Address(es)</th><th>Added By</th><th>Added Date &amp; Time</th><th>Updated By</th><th>Updated Date &amp; Time</th><th>Actions</th></tr></thead>
                    <tbody></tbody>
                </table>
            </div>
        </section>
    </div>

    <div class="modal fade" id="pecEditToModal" tabindex="-1" role="dialog" aria-labelledby="pecEditToTitle" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered" role="document"><div class="modal-content">
            <div class="modal-header pec-modal-header"><h5 class="modal-title" id="pecEditToTitle"><i class="fas fa-paper-plane mr-2"></i>Edit To Email Addresses</h5><button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button></div>
            <div class="modal-body">
                <input type="hidden" id="pecEditToProjectId" />
                <label class="pec-label" for="pecEditToProject">Project</label><input id="pecEditToProject" class="pec-control" readonly="readonly" />
                <section class="pec-recipient-box to-box mt-3">
                    <div class="pec-section-heading"><div><h3><i class="fas fa-paper-plane mr-1 text-success"></i>To Email Address(es) <span class="pec-required">*</span></h3><p class="pec-helper">Add, edit, or remove primary recipients.</p></div><button type="button" class="pec-btn pec-btn-add pec-edit-add" data-edit-context="edit-to" data-email-type="TO"><i class="fas fa-plus"></i>Add To</button></div>
                    <div id="pecEditToEmailList" class="pec-email-list" data-email-type="TO"></div>
                </section>
            </div>
            <div class="modal-footer"><button type="button" class="btn btn-light" data-dismiss="modal"><i class="fas fa-times mr-1"></i>Close</button><button type="button" id="pecUpdateTo" class="pec-btn pec-btn-save"><i class="fas fa-save"></i>Save To Emails</button></div>
        </div></div>
    </div>

    <div class="modal fade" id="pecEditCcModal" tabindex="-1" role="dialog" aria-labelledby="pecEditCcTitle" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered" role="document"><div class="modal-content">
            <div class="modal-header pec-modal-header"><h5 class="modal-title" id="pecEditCcTitle"><i class="fas fa-copy mr-2"></i>Edit CC Email Addresses</h5><button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button></div>
            <div class="modal-body">
                <input type="hidden" id="pecEditCcProjectId" />
                <label class="pec-label" for="pecEditCcProject">Project</label><input id="pecEditCcProject" class="pec-control" readonly="readonly" />
                <section class="pec-recipient-box cc-box mt-3">
                    <div class="pec-section-heading"><div><h3><i class="fas fa-copy mr-1 text-primary"></i>CC Email Address(es)</h3><p class="pec-helper">Add, edit, or remove copied recipients.</p></div><button type="button" class="pec-btn pec-btn-add pec-edit-add" data-edit-context="edit-cc" data-email-type="CC"><i class="fas fa-plus"></i>Add CC</button></div>
                    <div id="pecEditCcEmailList" class="pec-email-list" data-email-type="CC"></div>
                </section>
            </div>
            <div class="modal-footer"><button type="button" class="btn btn-light" data-dismiss="modal"><i class="fas fa-times mr-1"></i>Close</button><button type="button" id="pecUpdateCc" class="pec-btn pec-btn-save"><i class="fas fa-save"></i>Save CC Emails</button></div>
        </div></div>
    </div>

    <div class="modal fade" id="pecHistoryModal" tabindex="-1" role="dialog" aria-labelledby="pecHistoryTitle" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered" role="document"><div class="modal-content">
            <div class="modal-header pec-modal-header"><h5 class="modal-title" id="pecHistoryTitle"><i class="fas fa-history mr-2"></i>Project Email History</h5><button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button></div>
            <div class="modal-body"><div class="pec-table-wrap p-0"><table id="pecHistoryTable" class="table table-bordered table-striped w-100"><thead><tr><th>Action</th><th>Email Type</th><th>Previous Email</th><th>New Email</th><th>Previous Status</th><th>New Status</th><th>Changed By</th><th>Changed Date &amp; Time</th></tr></thead><tbody></tbody></table></div></div>
            <div class="modal-footer"><button type="button" class="btn btn-light" data-dismiss="modal"><i class="fas fa-times mr-1"></i>Close</button></div>
        </div></div>
    </div>

    <script src="../plugins/sweetalert2/sweetalert2.all.min.js"></script>
    <script src="../Scripts/Functions/ProjectEmailConfiguration.js"></script>
</asp:Content>
