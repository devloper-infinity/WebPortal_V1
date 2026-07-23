<%@ Page Title="Process Flow Configuration" Language="C#" MasterPageFile="~/Production/Production.Master" AutoEventWireup="true" CodeBehind="ProcessFlowConfiguration.aspx.cs" Inherits="WebPortal.TrackingSheet.ProcessFlowConfiguration" %>

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

        .checkbox-wrapper-22 {
            display: flex;
            min-height: 38px;
            align-items: center;
            gap: 10px
        }

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
</asp:Content>

<asp:Content ID="Body" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="olt-page">
        <div class="olt-hero">
            <div>
                <h2>Process Flow Configuration</h2>
                <p>Add only tracking processes. Processes with the same sequence run simultaneously.</p>
            </div>
        </div>

        <div id="oltAlert" class="olt-alert"></div>
        <div class="olt-grid">
            <section class="olt-card">
                <div class="olt-card-head">Add or update tracking process</div>
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
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody id="rows">
                            <tr>
                                <td colspan="6" class="olt-empty">Select a project.</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </section>
        </div>
    </div>

    <script src="OLTracking.js"></script>
    <script>
        var page = 'ProcessFlowConfiguration.aspx', processes = [], flow = []; document.addEventListener('DOMContentLoaded', function () { OLT.call(page, 'GetProjects').then(function (r) { OLT.options(project, r, ['ProjectID', 'projectID'], ['ProjectName', 'ProjectNo', 'Name'], 'Select project'); }); project.onchange = loadProject; });
        function pid(p) { return +OLT.val(p, ['ProcessID', 'processID']); } function pname(p) { return OLT.val(p, ['ProcessName', 'Name']); } function loadProject() { if (!project.value) return; Promise.all([OLT.call(page, 'GetProcesses', { projectId: +project.value }), OLT.call(page, 'GetFlow', { projectId: +project.value })]).then(function (r) { processes = r[0]; flow = r[1]; OLT.options(process, processes, ['ProcessID', 'processID'], ['ProcessName', 'Name'], 'Select process'); render(); }).catch(function (e) { OLT.alert(e.message, true); }); }
        function render() { rows.innerHTML = flow.length ? flow.map(function (x, i) { var simultaneous = i > 0 && flow[i - 1].StageNo === x.StageNo; return '<tr><td><span class="flow-stage">' + x.StageNo + '</span>' + (simultaneous ? '<span class="flow-same">simultaneous</span>' : '') + '</td><td>' + OLT.esc(x.ProcessName) + '</td><td>' + (x.IsMandatory ? 'Mandatory' : 'Can be skipped') + '</td><td>' + (x.FeedbackRequiredOnComplete ? 'Yes' : 'No') + '</td><td>' + (x.IsFinalProcess ? '<span class="flow-final">Final</span>' : 'No') + '</td><td><button type="button" class="olt-btn secondary" onclick="editFlow(' + x.ProcessID + ');return false;">Edit</button> <button type="button" class="olt-btn danger" onclick="removeFlow(' + x.ProcessID + ');return false;">Remove</button></td></tr>'; }).join('') : '<tr><td colspan="6" class="olt-empty">No tracking processes configured.</td></tr>'; }
        function editFlow(id) { var x = flow.filter(function (f) { return +f.ProcessID === id; })[0]; if (!x) return; process.value = id; stageNo.value = x.StageNo; requirement.value = x.IsMandatory ? 'mandatory' : 'skippable'; feedback.checked = x.FeedbackRequiredOnComplete; finalProcess.checked = x.IsFinalProcess; window.scrollTo(0, 0); } function clearForm() { process.value = ''; stageNo.value = 1; requirement.value = 'mandatory'; feedback.checked = false; finalProcess.checked = false; }
        function saveFlow() { if (!project.value || !process.value || +stageNo.value < 1) { OLT.alert('Project, process, and valid sequence are required.', true); return; } var selected = process.options[process.selectedIndex]; OLT.call(page, 'SaveFlow', { projectId: +project.value, processId: +process.value, processName: selected.text, stageNo: +stageNo.value, isMandatory: requirement.value === 'mandatory', feedbackRequired: feedback.checked, isFinalProcess: finalProcess.checked }).then(function () { OLT.alert('Process flow saved.'); clearForm(); loadProject(); }).catch(function (e) { OLT.alert(e.message, true); }); }
        function removeFlow(id) { if (!confirm('Remove this process from the tracking flow?')) return; OLT.call(page, 'RemoveFlow', { projectId: +project.value, processId: id }).then(function () { OLT.alert('Process removed.'); loadProject(); }).catch(function (e) { OLT.alert(e.message, true); }); }
    </script>
</asp:Content>
