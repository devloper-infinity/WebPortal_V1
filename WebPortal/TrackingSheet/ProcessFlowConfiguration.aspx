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

        .flow-dependency-picker { position:relative }
        .flow-dependency-picker summary { min-height:38px; padding:8px 34px 8px 11px; border:1px solid #cbd5e1; border-radius:4px; background:#fff; cursor:pointer; list-style:none; position:relative }
        .flow-dependency-picker summary::-webkit-details-marker { display:none }
        .flow-dependency-picker summary:after { content:'\25BC'; position:absolute; right:11px; top:10px; color:#64748b; font-size:11px }
        .flow-dependency-menu { position:absolute; z-index:20; width:100%; margin-top:3px; padding:9px; border:1px solid #cbd5e1; border-radius:5px; background:#fff; box-shadow:0 10px 25px rgba(15,23,42,.16) }
        .flow-dependency-menu input[type=search] { width:100%; margin-bottom:7px }
        .flow-dependency-options { max-height:190px; overflow:auto; border-top:1px solid #e2e8f0; border-bottom:1px solid #e2e8f0 }
        .flow-dependency-option { display:flex; align-items:center; gap:8px; margin:0; padding:7px 4px; cursor:pointer }
        .flow-dependency-option:hover { background:#f1f5f9 }
        .flow-dependency-option input { width:auto; min-height:0 }
        .flow-dependency-actions { display:flex; justify-content:flex-end; gap:8px; padding-top:7px }
        .flow-dependency-empty { padding:9px 4px; color:#64748b }
        .flow-config-section { grid-column:1/-1; margin-top:4px; padding:14px; border:1px solid #dbe6ef; border-radius:8px; background:#f8fbfd }
        .flow-config-section-title { margin:0 0 12px; color:#17324d; font-size:14px; font-weight:800 }
        .flow-config-section .olt-form { margin:0 }
        .flow-routing-note { margin-top:6px; line-height:1.45 }
        .flow-grid-scroll { position:relative; max-height:520px; overflow:auto; border:1px solid #d7e2ee; border-radius:6px; scrollbar-gutter:stable }
        .flow-grid-scroll .olt-table { min-width:1500px; margin:0; border-collapse:separate; border-spacing:0 }
        .flow-grid-scroll .deal-flow-table { min-width:1180px }
        .flow-grid-scroll .olt-table th { position:sticky; top:0; z-index:5; background:#e8f0f7; white-space:nowrap }
        .flow-grid-scroll .olt-table td { background:#fff }
        .flow-grid-scroll .olt-table th:nth-child(1),.flow-grid-scroll .olt-table td:nth-child(1) { position:sticky; left:0; z-index:7; width:68px; min-width:68px; max-width:68px; text-align:center }
        .flow-grid-scroll .olt-table th:nth-child(2),.flow-grid-scroll .olt-table td:nth-child(2) { position:sticky; left:68px; z-index:6; width:220px; min-width:220px; background:#fff; box-shadow:5px 0 8px -8px rgba(15,23,42,.65) }
        .flow-grid-scroll .olt-table th:nth-child(1),.flow-grid-scroll .olt-table th:nth-child(2) { z-index:9; background:#e8f0f7 }
        .flow-grid-scroll .olt-table td.olt-empty { position:static; width:auto; max-width:none; text-align:center }
        .flow-action-button { display:inline-flex; width:34px; height:32px; align-items:center; justify-content:center; border:1px solid #b9cad8; border-radius:6px; background:#fff; color:#0f6b8f; font-size:19px; cursor:pointer }
        .flow-action-button:hover,.flow-action-button[aria-expanded=true] { border-color:#0f6b8f; background:#e8f4f8 }
        .flow-action-menu { position:fixed; z-index:2000; min-width:142px; padding:5px; border:1px solid #cbd5e1; border-radius:7px; background:#fff; box-shadow:0 12px 28px rgba(15,23,42,.24) }
        .flow-action-menu[hidden] { display:none }
        .flow-action-menu button { display:flex; width:100%; align-items:center; gap:9px; padding:8px 10px; border:0; border-radius:5px; background:transparent; color:#243b53; text-align:left; cursor:pointer }
        .flow-action-menu button:hover { background:#eef5f9 }
        .flow-action-menu .delete { color:#b42318 }
        .flow-action-menu button:disabled { color:#94a3b8; cursor:not-allowed }
        .flow-action-menu button:disabled:hover { background:transparent }

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
    <script src="../Scripts/TrackingSheet/ProcessFlowConfiguration.js?v=20260817.1"></script>
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
                        <div class="flow-config-section">
                            <div class="flow-config-section-title">Completion and productivity</div>
                            <div class="olt-form">
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
                            <select id="productivityType">
                                <option value="Loan Based Productivity">Loan Based Productivity</option>
                                <option value="Hourly Productivity">Hourly Productivity</option>
                            </select>
                        </div>
                        <div class="olt-field">
                            <label>Min Completion Minutes <span class="olt-muted">(optional)</span></label>
                            <input id="minCompletionMinutes" type="number" min="0" step="1" placeholder="No minimum" />
                        </div>
                        <div class="olt-field">
                            <label>Max Completion Minutes <span class="olt-muted">(optional)</span></label>
                            <input id="maxCompletionMinutes" type="number" min="0" step="1" placeholder="No maximum" />
                        </div>
                        <div class="olt-field full"><small class="olt-muted">Leave Min/Max blank if no completion-time validation is required.</small></div>
                            </div>
                        </div>
                        <div class="flow-config-section">
                            <div class="flow-config-section-title">Workflow and feedback routing</div>
                            <div class="olt-form">
                        <div class="olt-field wide">
                            <label>Eligible After Process(es) <span class="olt-muted">(optional)</span></label>
                            <details id="eligibleAfterPicker" class="flow-dependency-picker">
                                <summary id="eligibleAfterSummary">No selection &ndash; use sequence flow</summary>
                                <div class="flow-dependency-menu">
                                    <input id="eligibleAfterSearch" type="search" placeholder="Search predecessor processes..." autocomplete="off" />
                                    <div id="eligibleAfterOptions" class="flow-dependency-options"></div>
                                    <div class="flow-dependency-actions">
                                        <button type="button" class="olt-btn secondary" onclick="clearEligibleAfter();return false;">Clear all</button>
                                        <button type="button" class="olt-btn" onclick="eligibleAfterPicker.open=false;return false;">Done</button>
                                    </div>
                                </div>
                            </details>
                            <small class="olt-muted">All selected predecessors must be completed. Leave empty to retain sequence-based eligibility.</small>
                        </div>
                        <div class="olt-field wide">
                            <label>Feedback Against Process(es) <span class="olt-muted">(optional)</span></label>
                            <details id="feedbackAgainstPicker" class="flow-dependency-picker">
                                <summary id="feedbackAgainstSummary">No selection &ndash; allow all prior completed processes</summary>
                                <div class="flow-dependency-menu">
                                    <input id="feedbackAgainstSearch" type="search" placeholder="Search feedback target processes..." autocomplete="off" />
                                    <div id="feedbackAgainstOptions" class="flow-dependency-options"></div>
                                    <div class="flow-dependency-actions">
                                        <button type="button" class="olt-btn secondary" onclick="clearFeedbackTargets();return false;">Clear all</button>
                                        <button type="button" class="olt-btn" onclick="feedbackAgainstPicker.open=false;return false;">Done</button>
                                    </div>
                                </div>
                            </details>
                            <small class="olt-muted flow-routing-note">Controls which completed process users can receive feedback from this task. Leave empty for the existing all-prior-process behaviour.</small>
                        </div>
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
                <div class="flow-grid-scroll">
                    <table class="olt-table flow-config-table">
                        <thead>
                            <tr>
                                <th>Actions</th>
                                <th>Process Name</th>
                                <th>Sequence</th>
                                <th>Requirement</th>
                                <th>Feedback mandatory</th>
                                <th>Final process</th>
                                <th>Tracking Sheet process</th>
                                <th>Productivity Type</th>
                                <th>Min Minutes</th>
                                <th>Max Minutes</th>
                                <th>Eligible After Process(es)</th>
                                <th>Feedback Against Process(es)</th>
                            </tr>
                        </thead>
                        <tbody id="rows">
                            <tr>
                                <td colspan="12" class="olt-empty">Select a project.</td>
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
                        <div class="olt-field wide"><label>Productivity Type</label><select id="dealProductivityType"><option value="Loan Based Productivity">Loan Based Productivity</option><option value="Hourly Productivity">Hourly Productivity</option></select></div>
                        <div class="olt-field"><label>Min Completion Minutes <span class="olt-muted">(optional)</span></label><input id="dealMinCompletionMinutes" type="number" min="0" step="1" placeholder="No minimum" /></div>
                        <div class="olt-field"><label>Max Completion Minutes <span class="olt-muted">(optional)</span></label><input id="dealMaxCompletionMinutes" type="number" min="0" step="1" placeholder="No maximum" /></div>
                        <div class="olt-field full"><small class="olt-muted">Leave Min/Max blank if no completion-time validation is required.</small></div>
                        <div class="olt-field full olt-actions"><button type="button" class="olt-btn" onclick="saveDealFlow()">Save process</button><button type="button" class="olt-btn secondary" onclick="clearDealForm()">Clear</button></div>
                    </div>
                </div>
            </section>
            <section class="olt-card">
                <div class="olt-card-head">Configured deal process flow</div>
                <div class="olt-card-body olt-muted">The complete project flow is shown automatically. Edit only the rows that need a deal-specific value; the full flow is preserved for the deal.</div>
                <div class="flow-grid-scroll"><table class="olt-table deal-flow-table"><thead><tr><th>Actions</th><th>Process Name</th><th>Sequence</th><th>Requirement</th><th>Feedback mandatory</th><th>Final process</th><th>Source</th><th>Productivity Type</th><th>Min Minutes</th><th>Max Minutes</th></tr></thead><tbody id="dealRows"><tr><td colspan="10" class="olt-empty">Select a project and deal.</td></tr></tbody></table></div>
            </section>
        </div></div>
        <div id="flowActionMenu" class="flow-action-menu" hidden role="menu" onclick="event.stopPropagation()">
            <button type="button" role="menuitem" onclick="runFlowAction('edit')"><span aria-hidden="true">&#9998;</span> Edit</button>
            <button id="flowDeleteAction" type="button" role="menuitem" class="delete" onclick="runFlowAction('delete')"><span aria-hidden="true">&#128465;</span> Delete</button>
        </div>
    </div>
</asp:Content>
