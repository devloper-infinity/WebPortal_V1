<%@ Page Title="Process Flow Configuration" Language="C#" MasterPageFile="~/TrackingSheet/TrackingSheetMaster.Master" AutoEventWireup="true" CodeBehind="ProcessFlowConfiguration.aspx.cs" Inherits="WebPortal.TrackingSheet.ProcessFlowConfiguration" %>

<asp:Content ID="Head" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="OLTracking.css" />
    <style>
        .flow-stage {
            display: inline-flex;
            min-width: 34px;
            height: 28px;
            align-items: center;
            justify-content: center;
            border-radius: 14px;
            background: #0f6b8f;
            color: #fff;
            font-weight: 800
        }

        .flow-same {
            display: inline-block;
            margin-left: 6px;
            color: #64748b;
            font-size: 11px
        }

        .flow-final {
            display: inline-flex;
            padding: 3px 9px;
            border: 1px solid #93c5fd;
            border-radius: 999px;
            color: #1d4ed8;
            background: #eff6ff;
            font-size: 11px;
            font-weight: 800
        }

        .flow-source { display:inline-flex; padding:3px 9px; border-radius:999px; font-size:11px; font-weight:800 }
        .flow-source.inherited { border:1px solid #cbd5e1; background:#f1f5f9; color:#475569 }
        .flow-source.override { border:1px solid #7dd3fc; background:#e0f2fe; color:#075985 }

        .checkbox-wrapper-22 {
            display: flex;
            min-height: 38px;
            align-items: center;
            gap: 10px
        }

        .flow-tabs { display:flex; gap:8px; margin-bottom:16px; border-bottom:1px solid #d7e2ee }
        .flow-tab { border:0; border-bottom:3px solid transparent; padding:11px 18px; background:transparent; color:#526b82; font-weight:800; cursor:pointer }
        .flow-tab.active { border-bottom-color:#0f6b8f; color:#0f6b8f }
        .flow-panel { display:none }
        .flow-panel.active { display:block }

            .checkbox-wrapper-22 .switch {
                display: inline-block;
                flex: 0 0 60px;
                width: 60px;
                height: 34px;
                position: relative;
                margin: 0;
                cursor: pointer
            }

                .checkbox-wrapper-22 .switch input {
                    position: absolute;
                    width: 1px !important;
                    height: 1px;
                    min-height: 0 !important;
                    margin: 0;
                    opacity: 0
                }

            .checkbox-wrapper-22 .slider {
                position: absolute;
                inset: 0;
                background-color: #cbd5e1;
                cursor: pointer;
                transition: .4s
            }

                .checkbox-wrapper-22 .slider:before {
                    position: absolute;
                    content: "";
                    width: 26px;
                    height: 26px;
                    left: 4px;
                    bottom: 4px;
                    background-color: #fff;
                    box-shadow: 0 2px 5px rgba(15,23,42,.25);
                    transition: .4s
                }

            .checkbox-wrapper-22 input:checked + .slider {
                background-color: #0f6b8f
            }

                .checkbox-wrapper-22 input:checked + .slider:before {
                    transform: translateX(26px)
                }

            .checkbox-wrapper-22 input:focus-visible + .slider {
                outline: 3px solid rgba(15,107,143,.25);
                outline-offset: 2px
            }

            .checkbox-wrapper-22 .slider.round {
                border-radius: 34px
            }

                .checkbox-wrapper-22 .slider.round:before {
                    border-radius: 50%
                }

            .checkbox-wrapper-22 .toggle-text {
                cursor: pointer;
                font-weight: 600
            }
    </style>


    <script src="OLTracking.js"></script>
    <script src="../Scripts/TrackingSheet/ProcessFlowConfiguration.js?v=20260814.3"></script>
</asp:Content>

<asp:Content ID="Body" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="olt-page">
        <div class="olt-hero">
            <div>
                <h2>Process Flow Configuration</h2>
                <p>Configure process sequence, completion rules, and Tracking Sheet handling.</p>
            </div>
        </div>

        <div id="oltAlert" class="olt-alert"></div>
        <div class="flow-tabs">
            <button type="button" class="flow-tab active" data-panel="projectFlowPanel">Project-Wise Configuration</button>
            <button type="button" class="flow-tab" data-panel="dealFlowPanel">Deal-Wise Configuration</button>
        </div>
        <div id="projectFlowPanel" class="flow-panel active"><div class="olt-grid">
            <section class="olt-card">
                <div class="olt-card-head">Add or update project process</div>
                <div class="olt-card-body">
                    <div class="olt-form">
                        <div class="olt-field wide">
                            <label>Project</label><select id="project"></select>
                        </div>
                        <div class="olt-field wide">
                            <label>Process</label><select id="process"><option value="">Select process</option>
                            </select>
                        </div>
                        <div class="olt-field">
                            <label>Sequence</label><input id="stageNo" type="number" min="1" value="1" />
                        </div>
                        <div class="olt-field">
                            <label>Requirement</label><select id="requirement"><option value="mandatory">Mandatory</option>
                                <option value="skippable">Can be skipped</option>
                            </select>
                        </div>
                        <div class="olt-field">
                            <div class="checkbox-wrapper-22">
                                <label class="switch" for="feedback">
                                    <input id="feedback" type="checkbox" />
                                    <span class="slider round"></span>
                                </label>
                                <label class="toggle-text" for="feedback">Feedback mandatory while completing</label>
                            </div>
                        </div>
                        <div class="olt-field">
                            <div class="checkbox-wrapper-22">
                                <label class="switch" for="finalProcess">
                                    <input id="finalProcess" type="checkbox" />
                                    <span class="slider round"></span>
                                </label>
                                <label class="toggle-text" for="finalProcess">Final Process</label>
                            </div>
                        </div>
                        <div class="olt-field">
                            <div class="checkbox-wrapper-22">
                                <label class="switch" for="trackingSheetProcess">
                                    <input id="trackingSheetProcess" type="checkbox" checked />
                                    <span class="slider round"></span>
                                </label>
                                <label class="toggle-text" for="trackingSheetProcess">Tracking Sheet Process</label>
                            </div>
                        </div>
                        <div class="olt-field wide">
                            <label>Productivity Type</label>
                            <select id="productivityType" onchange="toggleExpectedTime(false)">
                                <option value="Loan Based Productivity">Loan Based Productivity</option>
                                <option value="Hourly Productivity">Hourly Productivity</option>
                            </select>
                        </div>
                        <div id="expectedTimeFields" class="olt-field wide" style="display:none">
                            <label>Expected Completion Time</label>
                            <div style="display:flex;gap:8px;align-items:center">
                                <input id="expectedHours" type="number" min="0" max="999" value="0" aria-label="Expected completion hours" />
                                <span>Hours</span>
                                <input id="expectedMinutes" type="number" min="0" max="59" value="0" aria-label="Expected completion minutes" />
                                <span>Minutes</span>
                            </div>
                        </div>
                        <div class="olt-field full olt-actions">
                            <button type="button" class="olt-btn" onclick="saveFlow()">Save process</button>
                            <button type="button" class="olt-btn secondary" onclick="clearForm()">Clear</button>
                        </div>
                    </div>
                </div>
            </section>

            <section class="olt-card">
                <div class="olt-card-head">Configured process flow</div>
                <div class="olt-card-body olt-muted">Example: assigning CNC Review and SS Review to sequence 1 makes them run simultaneously. Sequence 2 loans wait until every mandatory process in sequence 1 is completed.</div>
                <div class="olt-table-wrap">
                    <table class="olt-table">
                        <thead>
                            <tr>
                                <th>Sequence</th>
                                <th>Process</th>
                                <th>Requirement</th>
                                <th>Feedback mandatory</th>
                                <th>Final process</th>
                                <th>Tracking Sheet process</th>
                                <th>Productivity Type</th>
                                <th>Expected Time</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody id="rows">
                            <tr>
                                <td colspan="9" class="olt-empty">Select a project.</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </section>
        </div></div>

        <div id="dealFlowPanel" class="flow-panel"><div class="olt-grid">
            <section class="olt-card">
                <div class="olt-card-head">Add or update deal-level tracking process</div>
                <div class="olt-card-body">
                    <div class="olt-form">
                        <div class="olt-field wide"><label>Project</label><select id="dealProject"></select></div>
                        <div class="olt-field wide"><label>Deal</label><select id="dealNumber" disabled><option value="">Select deal</option></select></div>
                        <div class="olt-field wide"><label>Process</label><select id="dealProcess"><option value="">Select process</option></select></div>
                        <div class="olt-field"><label>Sequence</label><input id="dealStageNo" type="number" min="1" value="1" /></div>
                        <div class="olt-field"><label>Requirement</label><select id="dealRequirement"><option value="mandatory">Mandatory</option><option value="skippable">Can be skipped</option></select></div>
                        <div class="olt-field"><div class="checkbox-wrapper-22"><label class="switch" for="dealFeedback"><input id="dealFeedback" type="checkbox" /><span class="slider round"></span></label><label class="toggle-text" for="dealFeedback">Feedback mandatory while completing</label></div></div>
                        <div class="olt-field"><div class="checkbox-wrapper-22"><label class="switch" for="dealFinalProcess"><input id="dealFinalProcess" type="checkbox" /><span class="slider round"></span></label><label class="toggle-text" for="dealFinalProcess">Final Process</label></div></div>
                        <div class="olt-field wide"><label>Productivity Type</label><select id="dealProductivityType" onchange="toggleExpectedTime(true)"><option value="Loan Based Productivity">Loan Based Productivity</option><option value="Hourly Productivity">Hourly Productivity</option></select></div>
                        <div id="dealExpectedTimeFields" class="olt-field wide" style="display:none"><label>Expected Completion Time</label><div style="display:flex;gap:8px;align-items:center"><input id="dealExpectedHours" type="number" min="0" max="999" value="0" aria-label="Expected completion hours" /><span>Hours</span><input id="dealExpectedMinutes" type="number" min="0" max="59" value="0" aria-label="Expected completion minutes" /><span>Minutes</span></div></div>
                        <div class="olt-field full olt-actions"><button type="button" class="olt-btn" onclick="saveDealFlow()">Save process</button><button type="button" class="olt-btn secondary" onclick="clearDealForm()">Clear</button></div>
                    </div>
                </div>
            </section>
            <section class="olt-card">
                <div class="olt-card-head">Configured deal process flow</div>
                <div class="olt-card-body olt-muted">The complete project flow is shown automatically. Edit only the rows that need a deal-specific value; the full flow is preserved for the deal.</div>
                <div class="olt-table-wrap"><table class="olt-table"><thead><tr><th>Sequence</th><th>Process</th><th>Requirement</th><th>Feedback mandatory</th><th>Final process</th><th>Source</th><th>Productivity Type</th><th>Expected Time</th><th>Action</th></tr></thead><tbody id="dealRows"><tr><td colspan="9" class="olt-empty">Select a project and deal.</td></tr></tbody></table></div>
            </section>
        </div></div>
    </div>
</asp:Content>
