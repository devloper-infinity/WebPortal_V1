<%@ Page Title="" Language="C#" MasterPageFile="~/Production/Production.Master" AutoEventWireup="true" CodeBehind="ProjectTrackingFieldConfiguration.aspx.cs" Inherits="WebPortal.TrackingSheet.ProjectTrackingFieldConfiguration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .content-header .callout {
            border: 1px solid #d8e2ef;
            border-left: 4px solid #2563eb;
            border-radius: 6px;
            background: #ffffff;
            box-shadow: 0 6px 18px rgba(15, 23, 42, 0.06);
            align-items: center;
        }

        .content-header h6 {
            font-size: 15px;
            color: #1f2937;
            letter-spacing: 0;
        }

        .card {
            border: 1px solid #d8e2ef;
            border-radius: 6px;
            box-shadow: 0 8px 22px rgba(15, 23, 42, 0.06);
        }

        .card-body {
            /*  padding: 18px;*/
        }

        .field-config-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(180px, 1fr));
            gap: 12px;
            align-items: end;
            padding: 14px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            background: #f8fafc;
        }

            .field-config-grid label {
                font-weight: 600 !important;
                margin-bottom: 4px;
                color: #334155;
                font-size: 12px;
            }

        .field-config-checks {
            display: flex;
            gap: 18px;
            align-items: center;
            min-height: 38px;
        }

            .field-config-checks label {
                margin-bottom: 0;
                font-weight: 500 !important;
            }

        .field-config-actions {
            /* display: flex;*/
            text-align: right !important;
            gap: 8px;
            align-items: center;
            flex-wrap: wrap;
        }

        .field-config-replica {
            display: grid;
            grid-template-columns: minmax(220px, 1fr) minmax(220px, 1fr) auto;
            gap: 12px;
            align-items: end;
            padding: 14px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            background: #ffffff;
        }

            .field-config-replica label {
                font-weight: 600 !important;
                margin-bottom: 4px;
                color: #334155;
                font-size: 12px;
            }

        .field-config-status {
            min-height: 24px;
            font-weight: 600;
            padding-left: 2px;
        }

        .form-control {
            border-color: #cbd5e1;
            border-radius: 5px;
            font-size: 13px;
        }

            .form-control:focus {
                border-color: #2563eb;
                box-shadow: 0 0 0 0.12rem rgba(37, 99, 235, 0.18);
            }

        .btn {
            border-radius: 5px;
            font-weight: 600;
        }

        #table_ProjectTrackingFields {
            border-collapse: separate;
            border-spacing: 0;
            font-size: 13px;
            background: #ffffff;
        }

            #table_ProjectTrackingFields th {
                background: #eef2f7;
                border-color: #d8e2ef;
                color: #334155;
                font-size: 12px;
                font-weight: 700;
                text-transform: uppercase;
                vertical-align: middle;
                white-space: nowrap;
            }

            #table_ProjectTrackingFields td {
                border-color: #e2e8f0;
                color: #334155;
                vertical-align: middle;
            }

            #table_ProjectTrackingFields tbody tr:hover {
                background: #f8fafc;
            }

        .project-tracking-loader-backdrop {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 1060;
            align-items: center;
            justify-content: center;
            background: rgba(15, 23, 42, 0.32);
        }

        .project-tracking-loader-box {
            min-width: 190px;
            padding: 18px 22px;
            border-radius: 6px;
            background: #fff;
            box-shadow: 0 18px 45px rgba(15, 23, 42, 0.24);
            text-align: center;
            font-weight: 600;
            color: #1f2937;
        }

        .project-tracking-loader-spinner {
            width: 30px;
            height: 30px;
            margin: 0 auto 10px;
            border: 3px solid #d9e2ef;
            border-top-color: #007bff;
            border-radius: 50%;
            animation: projectTrackingSpin 0.8s linear infinite;
        }

        @keyframes projectTrackingSpin {
            to {
                transform: rotate(360deg);
            }
        }

        @media (max-width: 992px) {
            .field-config-grid,
            .field-config-replica {
                grid-template-columns: 1fr;
            }
        }

        .pt-config-page {
            max-width: 100%;
            background: #f4f7fb;
            min-height: calc(100vh - 120px);
        }

        .pt-config-shell {
            max-width: 1380px;
            margin: 0 auto;
        }

        .pt-config-hero {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            margin-bottom: 14px;
            padding: 16px 18px;
            border: 1px solid #d8e2ef;
            border-left: 5px solid #2563eb;
            border-radius: 6px;
            background: #ffffff;
            box-shadow: 0 10px 24px rgba(15, 23, 42, 0.07);
        }

        .pt-config-title {
            margin: 0;
            color: #0f172a;
            font-size: 18px;
            font-weight: 700;
            line-height: 1.2;
        }

        .pt-config-subtitle {
            margin-top: 4px;
            color: #64748b;
            font-size: 12px;
            font-weight: 500;
        }

        .pt-config-panel {
            margin-bottom: 14px;
            border: 1px solid #d8e2ef;
            border-radius: 6px;
            background: #ffffff;
            box-shadow: 0 8px 22px rgba(15, 23, 42, 0.06);
        }

        .pt-config-panel-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            padding: 12px 14px;
            border-bottom: 1px solid #e2e8f0;
            background: #f8fafc;
        }

        .pt-config-panel-title {
            margin: 0;
            color: #1e293b;
            font-size: 14px;
            font-weight: 700;
        }

        .pt-config-panel-body {
            padding: 14px;
        }

        .pt-config-table-wrap {
            width: 100%;
            overflow: auto;
            padding: 1%;
        }

        .pt-config-page .field-config-grid,
        .pt-config-page .field-config-replica {
            border: 0;
            padding: 0;
            background: transparent;
        }

        .pt-config-page .form-control {
            height: 36px;
        }

        .pt-config-page textarea.form-control {
            height: auto;
        }

        .pt-config-page #table_ProjectTrackingFields {
            margin-bottom: 0;
            border: 0;
        }

            .pt-config-page #table_ProjectTrackingFields th {
                position: sticky;
                top: 0;
                z-index: 1;
                padding: 10px 8px;
            }

            .pt-config-page #table_ProjectTrackingFields td {
                padding: 9px 8px;
            }

        @media (max-width: 768px) {
            .pt-config-hero {
                flex-direction: column;
                align-items: flex-start;
            }
        }

        .pt-config-page {
            color: #172033;
            background: linear-gradient(180deg, #edf5fb 0%, #f7f9fc 48%, #f4f7fb 100%);
        }

        .pt-config-shell {
            max-width: 1420px;
        }

        .pt-config-hero {
            position: relative;
            overflow: hidden;
            min-height: 94px;
            margin-bottom: 16px;
            padding: 18px 28px;
            border: 1px solid rgba(255, 255, 255, 0.18);
            border-radius: 20px;
            background: linear-gradient(105deg, #284bd8 0%, #2d6fea 58%, #3bc4d3 100%);
            box-shadow: 0 14px 30px rgba(39, 84, 205, 0.22);
        }

            .pt-config-hero::before,
            .pt-config-hero::after {
                position: absolute;
                display: block;
                border-radius: 50%;
                background: rgba(255, 255, 255, 0.09);
                content: "";
                pointer-events: none;
            }

            .pt-config-hero::before {
                top: -112px;
                right: 5.5%;
                width: 230px;
                height: 230px;
            }

            .pt-config-hero::after {
                right: 5.5%;
                bottom: -152px;
                width: 250px;
                height: 250px;
            }

            .pt-config-hero > * {
                position: relative;
                z-index: 3;
            }

        .pt-config-heading {
            position: relative;
            display: flex;
            width: 100%;
            min-height: auto;
            padding: 0;
            align-items: center;
            gap: 14px;
            isolation: isolate;
        }

            .pt-config-heading::before,
            .pt-config-heading::after {
                display: none;
            }

        .pt-config-icon {
            display: inline-flex;
            flex: 0 0 50px;
            width: 50px;
            height: 50px;
            align-items: center;
            justify-content: center;
            border: 1px solid rgba(255, 255, 255, 0.28);
            border-radius: 16px;
            color: #ffffff;
            background: rgba(255, 255, 255, 0.14);
            box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.18);
            font-size: 21px;
        }

        .pt-config-title {
            color: #ffffff;
            font-size: 20px;
            font-weight: 800;
            letter-spacing: 0;
            text-transform: none;
            text-shadow: 0 1px 2px rgba(15, 23, 42, 0.18);
        }

            .pt-config-title i {
                color: #ffffff;
            }

        .pt-config-subtitle {
            margin-top: 3px;
            margin-left: 0;
            color: rgba(255, 255, 255, 0.86);
            font-size: 12px;
        }

        .pt-config-quick-link {
            min-width: 138px;
            border-color: #0f6b8f;
            color: #0f6b8f;
            background: #f2fbfd;
        }

            .pt-config-quick-link:hover {
                color: #ffffff;
                background: #0f6b8f;
                border-color: #0f6b8f;
            }

        .pt-config-panel {
            overflow: hidden;
            margin-bottom: 16px;
            border: 1px solid #d3dfeb;
            background: #ffffff;
            box-shadow: 0 12px 28px rgba(31, 45, 61, 0.08);
        }

        .pt-config-panel-header {
            min-height: 50px;
            padding: 12px 16px;
            background: #f6f9fc;
        }

        .pt-config-panel-title {
            display: flex;
            align-items: center;
            gap: 9px;
            color: #1f2d3d;
            font-size: 15px;
        }

        .pt-panel-icon {
            display: inline-flex;
            width: 30px;
            height: 30px;
            align-items: center;
            justify-content: center;
            border-radius: 6px;
            color: #0f6b8f;
            background: #e8f6f8;
        }

        .pt-config-panel-body {
            padding: 16px;
        }

        .pt-config-page .field-config-grid {
            grid-template-columns: 1.1fr 1.15fr 0.85fr 0.85fr;
            gap: 14px 16px;
        }

        .pt-config-page .field-config-replica {
            grid-template-columns: minmax(240px, 1fr) minmax(240px, 1fr) auto;
            gap: 14px 16px;
        }

        .pt-config-page label {
            color: #384860;
            font-size: 12px;
            font-weight: 700 !important;
            letter-spacing: 0;
        }

        .pt-config-page .form-control {
            height: 38px;
            border: 1px solid #bfccd9;
            border-radius: 6px;
            color: #1f2d3d;
            background: #ffffff;
        }

        .pt-config-page textarea.form-control {
            min-height: 76px;
            resize: vertical;
        }

        .pt-config-page .field-config-checks {
            gap: 12px;
            align-items: center;
            flex-wrap: wrap;
            padding-top: 19px;
        }

        .pt-config-page .field-config-flags {
            grid-column: 1 / span 3;
            justify-content: flex-start;
            flex-wrap: nowrap;
            padding-top: 0;
        }

        .pt-config-page .field-config-secondary-field {
            align-self: start;
        }

        .pt-config-page .field-config-checks label {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            color: #334155;
            font-weight: 600 !important;
        }

        .pt-config-page input[type="checkbox"] {
            width: 15px;
            height: 15px;
            accent-color: #0f6b8f;
        }

        .pt-config-page .checkbox-wrapper-44.toggleButton {
            position: relative;
            display: inline-flex;
            align-items: center;
            gap: 7px;
            margin: 0;
            cursor: pointer;
            transform-origin: 50% 50%;
            transform-style: preserve-3d;
        }

        .pt-config-page .checkbox-wrapper-44 input[type="checkbox"] {
            position: absolute;
            width: 1px;
            height: 1px;
            margin: 0;
            opacity: 0;
            pointer-events: none;
        }

        .pt-config-page .checkbox-wrapper-44 .toggle-mark {
            position: relative;
            display: block;
            flex: 0 0 24px;
            width: 24px;
            height: 24px;
            border: 2px solid #94a3b8;
            border-radius: 5%;
            background: #ffffff;
            transition: border-color 0.2s ease, background 0.2s ease, box-shadow 0.2s ease, transform 0.14s ease;
        }

            .pt-config-page .checkbox-wrapper-44 .toggle-mark svg {
                position: absolute;
                z-index: 1;
                inset: -2px;
                display: block;
                width: 24px;
                height: 24px;
                fill: none;
                stroke: #ffffff;
                stroke-width: 3.6;
                stroke-linecap: round;
                stroke-linejoin: round;
            }

            .pt-config-page .checkbox-wrapper-44 .toggle-mark path {
                stroke-dasharray: 145;
                stroke-dashoffset: 145;
                transition: stroke-dashoffset 0.42s ease;
            }

        .pt-config-page .checkbox-wrapper-44 input:checked + .toggle-mark {
            border-color: #0f6b8f;
            background: linear-gradient(145deg, #12a7c9 0%, #0f6b8f 100%);
            box-shadow: 0 4px 10px rgba(15, 107, 143, 0.22);
        }

            .pt-config-page .checkbox-wrapper-44 input:checked + .toggle-mark path {
                stroke-dashoffset: 0;
            }

        .pt-config-page .checkbox-wrapper-44:active .toggle-mark {
            transform: rotateX(28deg) scale(0.96);
        }

        .pt-config-page .checkbox-wrapper-44 input:focus-visible + .toggle-mark {
            outline: 3px solid rgba(37, 99, 235, 0.22);
            outline-offset: 2px;
        }

        .pt-config-page .checkbox-wrapper-44 input:disabled + .toggle-mark,
        .pt-config-page .checkbox-wrapper-44 input:disabled ~ .toggle-text {
            opacity: 0.48;
        }

        .pt-config-page .field-config-actions {
            grid-column: 4;
            display: flex;
            justify-content: flex-end;
            align-items: end;
            flex-wrap: nowrap;
            padding-top: 0;
        }

        .pt-config-page .btn {
            border-radius: 6px;
            letter-spacing: 0;
        }

        .pt-config-page .btn-primary {
            border-color: #0f6b8f;
            background: #0f6b8f;
            box-shadow: 0 8px 16px rgba(15, 107, 143, 0.20);
        }

            .pt-config-page .btn-primary:hover {
                border-color: #0b526e;
                background: #0b526e;
            }

        .pt-config-page .btn-outline-secondary {
            border-color: #b8c6d4;
            color: #405166;
            background: #ffffff;
        }

        .pt-config-page .btn-outline-success {
            border-color: #198754;
            color: #14784a;
            background: #f3fbf7;
        }

            .pt-config-page .btn-outline-success:hover {
                color: #ffffff;
                background: #198754;
            }

        .pt-config-page .field-config-status {
            min-height: 22px;
            padding-left: 0;
            font-size: 12px;
        }

        .pt-config-table-wrap {
            max-height: 460px;
            border-top: 1px solid #e2e8f0;
        }

        .pt-config-page #table_ProjectTrackingFields th {
            color: #26384d;
            background: #e8eef5;
        }

        .pt-config-page #table_ProjectTrackingFields td {
            color: #2f3e52;
            background: #ffffff;
        }

        .pt-config-page #table_ProjectTrackingFields tbody tr:nth-child(even) td {
            background: #fbfdff;
        }

        .pt-config-page #table_ProjectTrackingFields tbody tr:hover td {
            background: #eef8fa;
        }

        .pt-config-page .pt-generated-row td {
            background: #f8fafc;
            color: #516173;
        }

        .pt-config-page .pt-process-row td {
            border-top: 1px solid #b9dce5;
            background: #f4fbfd;
        }

        .pt-icon-button {
            width: 30px;
            height: 30px;
            padding: 0;
            line-height: 1;
        }

        .pt-field-title {
            color: #172033;
            font-weight: 700;
        }

        .pt-field-subnote {
            margin-top: 2px;
            color: #7a8797;
            font-size: 11px;
        }

        .pt-options-text {
            color: #64748b;
            white-space: pre-line;
        }

        .pt-type-pill,
        .pt-pill,
        .pt-lock-pill {
            display: inline-flex;
            min-height: 24px;
            align-items: center;
            justify-content: center;
            border-radius: 999px;
            padding: 3px 9px;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0;
            white-space: nowrap;
        }

        .pt-type-pill {
            color: #0f526b;
            background: #e7f6fa;
            border: 1px solid #bddfeb;
        }

        .pt-pill-yes {
            color: #146c43;
            background: #eaf8ef;
            border: 1px solid #bfe8cf;
        }

        .pt-pill-no {
            color: #7a4d14;
            background: #fff7e7;
            border: 1px solid #f2d69b;
        }

        .pt-lock-pill {
            color: #516173;
            background: #eef2f7;
            border: 1px solid #d6dee8;
        }

        @media (max-width: 992px) {
            .pt-config-page .field-config-grid,
            .pt-config-page .field-config-replica {
                grid-template-columns: 1fr;
            }

            .pt-config-page .field-config-checks,
            .pt-config-page .field-config-actions {
                grid-column: 1;
                padding-top: 0;
            }

            .pt-config-page .field-config-flags {
                flex-wrap: wrap;
            }
        }

        @media (max-width: 576px) {
            .pt-config-hero {
                min-height: 94px;
                padding: 16px 18px;
            }

            .pt-config-heading {
                width: 100%;
                min-height: auto;
                padding: 0;
            }

            .pt-config-title {
                font-size: 16px;
            }

            .pt-config-subtitle {
                font-size: 11px;
            }
        }
    </style>

    <script src="../Scripts/TrackingSheet/ProjectTrackingFieldConfiguration.js"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="projectTrackingLoader" class="project-tracking-loader-backdrop">
        <div class="project-tracking-loader-box">
            <div class="project-tracking-loader-spinner"></div>
            <div id="projectTrackingLoaderText">Please wait...</div>
        </div>
    </div>

    <div class="pt-config-page">
        <div class="pt-config-shell">
            <div class="pt-config-hero">
                <div class="pt-config-heading">
                    <span class="pt-config-icon"><i class="fas fa-sliders-h"></i></span>
                    <div>
                        <h4 class="pt-config-title">Project Tracking Field Configuration</h4>
                        <div class="pt-config-subtitle">Configure project-wise tracking fields, process columns, sequence, and replica setup.</div>
                    </div>
                </div>
            </div>

            <input type="hidden" id="hdnFieldConfigId" value="0" />
            <input type="hidden" id="hdnStatusOptionsFieldConfigId" value="0" />

            <div class="pt-config-panel">
                <div class="pt-config-panel-header">
                    <h5 class="pt-config-panel-title"><span class="pt-panel-icon"><i class="fas fa-cog"></i></span>Field Setup</h5>
                    <div id="fieldConfigStatus" class="field-config-status"></div>
                </div>
                <div class="pt-config-panel-body">
                    <div class="field-config-grid">
                        <div>
                            <label for="ddlFieldConfigProject">Project</label>
                            <select id="ddlFieldConfigProject" class="form-control">
                                <option value="">Select</option>
                            </select>
                        </div>
                        <div>
                            <label for="txtFieldName">Field Name</label>
                            <input type="text" id="txtFieldName" class="form-control" />
                        </div>
                        <div>
                            <label for="ddlFieldDataType">Data Type</label>
                            <select id="ddlFieldDataType" class="form-control">
                                <option value="Text">Text</option>
                                <option value="Number">Number</option>
                                <option value="Date">Date</option>
                                <option value="DateTime">DateTime</option>
                                <option value="Dropdown">Dropdown</option>
                                <option value="Checkbox">Checkbox</option>
                                <option value="Process">Process</option>
                            </select>
                        </div>
                        <div class="field-config-checks">
                            <label class="checkbox-wrapper-44 toggleButton">
                                <input type="checkbox" id="chkActualProcess" />
                                <span class="toggle-mark">
                                    <svg viewBox="0 0 44 44" aria-hidden="true">
                                        <path d="M14,24 L21,31 L39.7428882,11.5937758 C35.2809627,6.53125861 30.0333333,4 24,4 C12.95,4 4,12.95 4,24 C4,35.05 12.95,44 24,44 C35.05,44 44,35.05 44,24 C44,19.3 42.5809627,15.1645919 39.7428882,11.5937758" transform="translate(-2,-2)"></path></svg>
                                </span>
                                <span class="toggle-text">Actual Process</span>
                            </label>
                        </div>
                        <div class="field-config-secondary-field">
                            <label for="txtDisplayOrder">Display Order</label>
                            <input type="number" id="txtDisplayOrder" class="form-control" min="0" />
                        </div>
                        <div class="field-config-secondary-field">
                            <label for="ddlDateFormat">Date Format</label>
                            <select id="ddlDateFormat" class="form-control" disabled>
                                <option value="dd/MM/yyyy">dd/MM/yyyy</option>
                                <option value="MM/dd/yyyy">MM/dd/yyyy</option>
                                <option value="yyyy-MM-dd">yyyy-MM-dd</option>
                                <option value="dd-MMM-yyyy">dd-MMM-yyyy</option>
                                <option value="MMM dd yyyy">MMM dd yyyy</option>
                            </select>
                        </div>
                        <div class="field-config-secondary-field" style="grid-column: span 2;">
                            <label for="txtFieldOptions">Dropdown Options</label>
                            <textarea id="txtFieldOptions" class="form-control" rows="2" placeholder="One option per line"></textarea>
                        </div>
                        <div class="field-config-checks field-config-flags">
                            <label class="checkbox-wrapper-44 toggleButton">
                                <input type="checkbox" id="chkFieldRequired" />
                                <span class="toggle-mark">
                                    <svg viewBox="0 0 44 44" aria-hidden="true">
                                        <path d="M14,24 L21,31 L39.7428882,11.5937758 C35.2809627,6.53125861 30.0333333,4 24,4 C12.95,4 4,12.95 4,24 C4,35.05 12.95,44 24,44 C35.05,44 44,35.05 44,24 C44,19.3 42.5809627,15.1645919 39.7428882,11.5937758" transform="translate(-2,-2)"></path></svg></span>
                                <span class="toggle-text">Required</span>
                            </label>
                            <label class="checkbox-wrapper-44 toggleButton">
                                <input type="checkbox" id="chkUniqueField" />
                                <span class="toggle-mark">
                                    <svg viewBox="0 0 44 44" aria-hidden="true">
                                        <path d="M14,24 L21,31 L39.7428882,11.5937758 C35.2809627,6.53125861 30.0333333,4 24,4 C12.95,4 4,12.95 4,24 C4,35.05 12.95,44 24,44 C35.05,44 44,35.05 44,24 C44,19.3 42.5809627,15.1645919 39.7428882,11.5937758" transform="translate(-2,-2)"></path></svg></span>
                                <span class="toggle-text">Unique Field</span>
                            </label>
                            <label class="checkbox-wrapper-44 toggleButton">
                                <input type="checkbox" id="chkFieldVisible" checked />
                                <span class="toggle-mark">
                                    <svg viewBox="0 0 44 44" aria-hidden="true">
                                        <path d="M14,24 L21,31 L39.7428882,11.5937758 C35.2809627,6.53125861 30.0333333,4 24,4 C12.95,4 4,12.95 4,24 C4,35.05 12.95,44 24,44 C35.05,44 44,35.05 44,24 C44,19.3 42.5809627,15.1645919 39.7428882,11.5937758" transform="translate(-2,-2)"></path></svg></span>
                                <span class="toggle-text">Visible</span>
                            </label>
                            <label class="checkbox-wrapper-44 toggleButton">
                                <input type="checkbox" id="chkFieldEditable" checked />
                                <span class="toggle-mark">
                                    <svg viewBox="0 0 44 44" aria-hidden="true">
                                        <path d="M14,24 L21,31 L39.7428882,11.5937758 C35.2809627,6.53125861 30.0333333,4 24,4 C12.95,4 4,12.95 4,24 C4,35.05 12.95,44 24,44 C35.05,44 44,35.05 44,24 C44,19.3 42.5809627,15.1645919 39.7428882,11.5937758" transform="translate(-2,-2)"></path></svg></span>
                                <span class="toggle-text">Editable</span>
                            </label>
                            <label class="checkbox-wrapper-44 toggleButton">
                                <input type="checkbox" id="chkForBilling" />
                                <span class="toggle-mark">
                                    <svg viewBox="0 0 44 44" aria-hidden="true">
                                        <path d="M14,24 L21,31 L39.7428882,11.5937758 C35.2809627,6.53125861 30.0333333,4 24,4 C12.95,4 4,12.95 4,24 C4,35.05 12.95,44 24,44 C35.05,44 44,35.05 44,24 C44,19.3 42.5809627,15.1645919 39.7428882,11.5937758" transform="translate(-2,-2)"></path></svg></span>
                                <span class="toggle-text">For Billing</span>
                            </label>
                            <label class="checkbox-wrapper-44 toggleButton">
                                <input type="checkbox" id="chkForImport" />
                                <span class="toggle-mark">
                                    <svg viewBox="0 0 44 44" aria-hidden="true">
                                        <path d="M14,24 L21,31 L39.7428882,11.5937758 C35.2809627,6.53125861 30.0333333,4 24,4 C12.95,4 4,12.95 4,24 C4,35.05 12.95,44 24,44 C35.05,44 44,35.05 44,24 C44,19.3 42.5809627,15.1645919 39.7428882,11.5937758" transform="translate(-2,-2)"></path></svg></span>
                                <span class="toggle-text">For Import</span>
                            </label>
                        </div>
                        <div class="field-config-actions">
                            <button type="button" id="btnSaveFieldConfig" class="btn btn-primary">
                                <i class="fas fa-save"></i>&nbsp;Save Field
                            </button>
                            <button type="button" id="btnNewFieldConfig" class="btn btn-outline-secondary">
                                <i class="fas fa-plus"></i>&nbsp;New
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="pt-config-panel">
                <div class="pt-config-panel-header">
                    <h5 class="pt-config-panel-title"><span class="pt-panel-icon"><i class="fas fa-clone"></i></span>Create Project Replica</h5>
                </div>
                <div class="pt-config-panel-body">
                    <div class="field-config-replica">
                        <div>
                            <label for="ddlReplicaSourceProject">Replica From Project</label>
                            <select id="ddlReplicaSourceProject" class="form-control">
                                <option value="">Select</option>
                            </select>
                        </div>
                        <div>
                            <label for="ddlReplicaTargetProject">Replica To Project</label>
                            <select id="ddlReplicaTargetProject" class="form-control">
                                <option value="">Select</option>
                            </select>
                        </div>
                        <div>
                            <button type="button" id="btnCreateReplica" class="btn btn-outline-success">
                                <i class="fas fa-clone"></i>&nbsp;Create Replica
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="pt-config-panel">
                <div class="pt-config-panel-header">
                    <h5 class="pt-config-panel-title"><span class="pt-panel-icon"><i class="fas fa-list-ul"></i></span>Configured Fields</h5>
                </div>
                <div class="pt-config-table-wrap">
                    <table class="table table-bordered table-sm pt-config-table" id="table_ProjectTrackingFields">
                        <thead>
                            <tr>
                                <th style="width: 190px; text-align: center;">Action</th>
                                <th style="width: 80px; text-align: center;">Order</th>
                                <th>Field</th>
                                <th>Type</th>
                                <th style="width: 120px;">Date Format</th>
                                <th>Options</th>
                                <th style="width: 90px; text-align: center;">Required</th>
                                <th style="width: 100px; text-align: center;">Unique Field</th>
                                <th style="width: 90px; text-align: center;">Visible</th>
                                <th style="width: 90px; text-align: center;">Editable</th>
                                <th style="width: 100px; text-align: center;">For Billing</th>
                                <th style="width: 100px; text-align: center;">For Import</th>
                                <th style="width: 90px; text-align: center;">Process</th>
                                <th style="width: 100px; text-align: center;">Generated</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td colspan="14" class="text-center">Select a project.</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
