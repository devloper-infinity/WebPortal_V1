<%@ Page Title="" Language="C#" MasterPageFile="~/Search/Search.Master" AutoEventWireup="true" CodeBehind="Costing.aspx.cs" Inherits="WebPortal.Search.Costing" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --costing-bg: #f4f6f8;
            --costing-surface: #ffffff;
            --costing-border: #d8e1e8;
            --costing-soft: #edf2f6;
            --costing-text: #1f2937;
            --costing-muted: #64748b;
            --costing-primary: #0f766e;
            --costing-primary-dark: #115e59;
            --costing-accent: #2563eb;
            --costing-danger: #dc2626;
            --costing-warning: #b45309;
            --costing-success: #15803d;
        }

        #load1 {
            display: none;
            position: fixed !important;
            inset: 0 !important;
            width: 100vw !important;
            height: 100vh !important;
            margin: 0 !important;
            z-index: 2147483647;
            background: rgba(248, 250, 252, .74);
            backdrop-filter: blur(2px);
            align-items: center !important;
            justify-content: center !important;
            text-align: center;
        }

            #load1 > .costing-loader-content {
                position: static !important;
                margin: 0 !important;
                transform: none !important;
                text-align: center;
            }

            #load1 img {
                width: 64px;
                height: 64px;
                display: block;
                margin: 0 auto 10px;
            }

            #load1 .costing-loader-message {
                color: var(--costing-text);
                font-size: 12px;
                font-weight: 700;
            }

        .costing-page {
            min-height: calc(100vh - 72px);
            color: var(--costing-text);
            background: var(--costing-bg);
        }

        .costing-header,
        .costing-shell {
            max-width: 1440px;
            margin: 0 auto;
        }

        .costing-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 14px;
            padding: 14px 18px;
            background: var(--costing-surface);
            border: 1px solid var(--costing-border);
            border-left: 4px solid var(--costing-primary);
            border-radius: 8px;
            box-shadow: 0 10px 24px rgba(31, 41, 55, .05);
        }

        .costing-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0;
            color: var(--costing-text);
            font-size: 22px;
            font-weight: 700;
        }

            .costing-title i {
                width: 36px;
                height: 36px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                color: #ffffff;
                background: var(--costing-primary);
                border-radius: 8px;
                font-size: 15px;
            }

        .costing-context {
            margin-top: 2px;
            color: var(--costing-muted);
            font-size: 12px;
            font-weight: 600;
        }

        .costing-alert {
            max-width: 1440px;
            margin: 0 auto 14px;
            display: none;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 700;
        }

        .costing-shell {
            background: var(--costing-surface);
            border: 1px solid var(--costing-border);
            border-radius: 8px;
            box-shadow: 0 12px 30px rgba(31, 41, 55, .06);
            overflow: hidden;
        }

        .costing-section {
            padding: 16px 18px 18px;
            border-bottom: 1px solid var(--costing-soft);
        }

            .costing-section:last-child {
                border-bottom: 0;
            }

        .section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 14px;
            padding-bottom: 10px;
            border-bottom: 1px solid var(--costing-soft);
        }

            .section-header h2 {
                display: flex;
                align-items: center;
                gap: 8px;
                margin: 0;
                color: var(--costing-primary-dark);
                font-size: 15px;
                font-weight: 800;
            }

            .section-header i {
                color: var(--costing-primary);
            }

        .field-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(180px, 1fr));
            gap: 14px 16px;
            align-items: end;
        }

            .field-grid.three {
                grid-template-columns: repeat(3, minmax(180px, 1fr));
            }

            .field-grid.two {
                grid-template-columns: repeat(2, minmax(220px, 1fr));
            }

            .field-grid .wide {
                grid-column: span 2;
            }

            .field-grid .full {
                grid-column: 1 / -1;
            }

        .costing-field {
            min-width: 0;
        }

            .costing-field label {
                display: block;
                margin: 0 0 5px;
                color: var(--costing-text);
                font-size: 12px;
                font-weight: 700;
            }

            .costing-field .required {
                color: var(--costing-danger);
            }

        .costing-control {
            width: 100%;
            min-height: 38px;
            padding: 8px 10px;
            color: var(--costing-text);
            background: #ffffff;
            border: 1px solid #ccd6df;
            border-radius: 7px;
            font-size: 12px;
            outline: none;
            transition: border-color .15s ease, box-shadow .15s ease, background-color .15s ease;
        }

            .costing-control:focus {
                border-color: var(--costing-primary);
                box-shadow: 0 0 0 3px rgba(15, 118, 110, .12);
            }

            .costing-control[readonly],
            .costing-control:disabled,
            .costing-readonly {
                color: var(--costing-primary-dark);
                background: #eef8f7;
                border-color: #b7d8d4;
                font-weight: 700;
            }

        textarea.costing-control {
            min-height: 72px;
            resize: vertical;
        }

        input[type="file"].costing-control {
            padding: 7px 10px;
            background: #fbfcfd;
            border-style: dashed;
        }

        .summary-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(180px, 1fr));
            gap: 10px;
            margin-top: 14px;
        }

        .summary-item,
        .cost-row {
            min-width: 0;
            padding: 10px 12px;
            background: #fbfcfd;
            border: 1px solid var(--costing-soft);
            border-radius: 8px;
        }

        .summary-label {
            display: block;
            margin-bottom: 3px;
            color: var(--costing-muted);
            font-size: 11px;
            font-weight: 800;
            text-transform: uppercase;
        }

        .summary-value {
            display: block;
            min-height: 18px;
            color: var(--costing-text);
            font-size: 13px;
            font-weight: 700;
            word-break: break-word;
        }

        .cost-row {
            margin-bottom: 12px;
        }

        .cost-row-title {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 8px;
            margin-bottom: 10px;
            color: var(--costing-primary-dark);
            font-size: 13px;
            font-weight: 800;
        }

        .cost-row-grid {
            display: grid;
            grid-template-columns: minmax(150px, 1.15fr) minmax(90px, .7fr) minmax(110px, .8fr) minmax(110px, .8fr) minmax(110px, .8fr);
            gap: 10px;
            align-items: end;
        }

            .cost-row-grid.compact {
                grid-template-columns: minmax(170px, 1fr) minmax(120px, .8fr) minmax(150px, 1fr) minmax(120px, .8fr);
            }

        .costing-note {
            margin: 0 0 12px;
            padding: 10px 12px;
            color: #7c2d12;
            background: #fff7ed;
            border: 1px solid #fed7aa;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 700;
        }

        .costing-actions {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            flex-wrap: wrap;
            margin-top: 14px;
        }

        .btn-costing-primary,
        .btn-costing-secondary {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-height: 38px;
            min-width: 128px;
            padding: 8px 16px;
            border-radius: 7px;
            font-size: 12px;
            font-weight: 800;
            line-height: 1.2;
            text-decoration: none;
            transition: background-color .15s ease, border-color .15s ease, box-shadow .15s ease, transform .15s ease;
        }

        .btn-costing-primary {
            color: #ffffff;
            background: var(--costing-primary);
            border: 1px solid var(--costing-primary);
            box-shadow: 0 8px 18px rgba(15, 118, 110, .18);
        }

            .btn-costing-primary:hover,
            .btn-costing-primary:focus {
                color: #ffffff;
                background: var(--costing-primary-dark);
                border-color: var(--costing-primary-dark);
                box-shadow: 0 10px 22px rgba(15, 118, 110, .22);
                transform: translateY(-1px);
            }

        .btn-costing-secondary {
            color: var(--costing-text);
            background: #ffffff;
            border: 1px solid var(--costing-border);
        }

            .btn-costing-secondary:hover,
            .btn-costing-secondary:focus {
                color: var(--costing-primary-dark);
                background: #f8fafc;
                border-color: #b6c4d0;
            }

        .grid-panel {
            margin-top: 14px;
            border: 1px solid var(--costing-border);
            border-radius: 8px;
            overflow: hidden;
            background: #ffffff;
        }

        .grid-panel-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 12px 14px;
            background: #fbfcfd;
            border-bottom: 1px solid var(--costing-soft);
        }

            .grid-panel-header h3 {
                margin: 0;
                color: var(--costing-text);
                font-size: 13px;
                font-weight: 800;
            }

            .grid-panel-header span {
                color: var(--costing-muted);
                font-size: 12px;
                font-weight: 700;
            }

        .grid-wrap {
            padding: 12px;
            overflow-x: auto;
        }

        .costing-table {
            width: 100% !important;
            margin-bottom: 0 !important;
            border-collapse: collapse;
            font-size: 12px;
        }

            .costing-table thead th {
                color: var(--costing-text);
                background: #f1f5f9;
                border-bottom: 1px solid #dce5ec;
                font-size: 12px;
                font-weight: 800;
                white-space: nowrap;
            }

            .costing-table thead tr:first-child th.costing-band-header {
                color: #ffffff;
                background: #0f766e;
                border-right: 1px solid rgba(255, 255, 255, .28);
                border-bottom: 1px solid #0b5f59;
                text-align: center;
                vertical-align: middle;
            }

            .costing-table thead tr:nth-child(2) th {
                background: #dff3f1;
                text-align: center;
            }

            .costing-table tbody td {
                vertical-align: middle;
                white-space: nowrap;
            }

        .dataTables_wrapper .dataTables_filter input,
        .dataTables_wrapper .dataTables_length select {
            min-height: 32px;
            border: 1px solid #ccd6df;
            border-radius: 7px;
            font-size: 12px;
        }

        .final-actions {
            padding: 16px 18px 20px;
            background: #fbfcfd;
            border-top: 1px solid var(--costing-soft);
        }

        @media (max-width: 1180px) {
            .field-grid,
            .field-grid.three,
            .summary-grid,
            .cost-row-grid,
            .cost-row-grid.compact {
                grid-template-columns: repeat(2, minmax(180px, 1fr));
            }

            .field-grid .wide {
                grid-column: span 2;
            }
        }

        @media (max-width: 720px) {
            .costing-page {
                padding: 12px;
            }

            .costing-header {
                align-items: flex-start;
                flex-direction: column;
            }

            .costing-title {
                font-size: 18px;
            }

            .field-grid,
            .field-grid.two,
            .field-grid.three,
            .summary-grid,
            .cost-row-grid,
            .cost-row-grid.compact {
                grid-template-columns: 1fr;
            }

            .field-grid .wide {
                grid-column: auto;
            }

            .btn-costing-primary,
            .btn-costing-secondary {
                width: 100%;
            }
        }
    </style>

    <portal:VersionedScript Src="~/Scripts/Search/Costing.js" runat="server"></portal:VersionedScript>
    
    <script>
        $(document).ready(function () {

            const params = new URLSearchParams(window.location.search);
            const orderId = params.get('OrderID');

            if (typeof Costing_InitPage === "function") {
                Costing_InitPage(orderId);
            }
        });
    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="costing-page">
        <div class="loading" id="load1">
            <div class="costing-loader-content">
                <img src="../images/Load_1.gif" alt="Loading" />
                <div class="costing-loader-message">One moment, please . . . .</div>
            </div>
        </div>

        <div class="costing-header">
            <div>
                <h1 class="costing-title"><i class="fas fa-file-invoice-dollar"></i><span>Production / Abstractor Costing</span></h1>
                <div class="costing-context">Search Operations</div>
            </div>
            <button type="button" id="btnCostingBack" class="btn-costing-secondary" onclick="window.history.back(); return false;">
                <i class="fas fa-arrow-left"></i><span>Back</span>
            </button>
        </div>

        <div id="costingAlert" class="alert costing-alert" role="alert"></div>

        <div class="costing-shell">
            <section class="costing-section">
                <div class="section-header">
                    <h2><i class="fas fa-clipboard-list"></i><span>Order Details</span></h2>
                </div>

                <div class="field-grid">
                    <div class="costing-field full">
                        <label for="ddlOrder"><span class="required">*</span> Order Number</label>
                        <select id="ddlOrder" class="costing-control">
                            <option value="">Select</option>
                        </select>
                    </div>
                </div>

                <input type="hidden" id="hdnCounty" />

                <div class="summary-grid">
                    <div class="summary-item"><span class="summary-label">Project</span><span id="lblProjectNumber" class="summary-value"></span></div>
                    <div class="summary-item"><span class="summary-label">Product Type</span><span id="lblProductType" class="summary-value"></span></div>
                    <div class="summary-item"><span class="summary-label">Process</span><span id="lblProcess" class="summary-value"></span></div>
                    <div class="summary-item"><span class="summary-label">Order Received Date</span><span id="Label2" class="summary-value"></span></div>
                    <div class="summary-item"><span class="summary-label">State</span><span id="lblState" class="summary-value"></span></div>
                    <div class="summary-item"><span class="summary-label">County</span><span id="lblCounty" class="summary-value"></span></div>
               <%--     <div class="summary-item"><span class="summary-label">Plant</span><span id="lblPlant" class="summary-value"></span></div>
                    <div class="summary-item"><span class="summary-label">Judgment Link</span><span id="lblJudgment" class="summary-value"></span></div>
                    <div class="summary-item"><span class="summary-label">Average Cost</span><span id="lblAvgCost" class="summary-value"></span></div>
                    <div class="summary-item"><span class="summary-label">Plant Start Date</span><span id="lblplantSDate" class="summary-value"></span></div>
                    <div class="summary-item"><span class="summary-label">Image Start Date</span><span id="lblImageSDate" class="summary-value"></span></div>--%>
                </div>
            </section>

            <section class="costing-section">
                <div class="section-header">
                    <h2><i class="fas fa-calculator"></i><span>Production Cost Information</span></h2>
                </div>

                <div class="field-grid two">
                    <div class="costing-field">
                        <label for="ddlCostSearchEngine"><span class="required">*</span> Search Engine Type</label>
                        <select id="ddlCostSearchEngine" class="costing-control">
                            <option value="Select">Select</option>
                            <option value="Paid">Paid</option>
                            <option value="Free">Free</option>
                        </select>
                    </div>
                    <div class="costing-field">
                        <label for="txtCostSearchType"><span class="required">*</span> Search Engine Link</label>
                        <input type="text" id="txtCostSearchType" class="costing-control" />
                    </div>
                </div>

                <div class="cost-row">
                    <div class="cost-row-title"><span>Search Cost</span></div>
                    <div class="cost-row-grid">
                        <div class="costing-field">
                            <label for="ddlSearchCostNoOfSearchesMade">Cost Basis</label>
                            <select id="ddlSearchCostNoOfSearchesMade" class="costing-control">
                                <option value="NoOfSearchesMade">No. Of Searches Made</option>
                            </select>
                        </div>
                        <div class="costing-field">
                            <label for="txtNoOfSearchesMade">Searches</label>
                            <input type="text" id="txtNoOfSearchesMade" class="costing-control costing-number" />
                        </div>
                        <div class="costing-field">
                            <label for="txtCostSearches">Cost/Search</label>
                            <input type="text" id="txtCostSearches" class="costing-control costing-money-input" />
                        </div>
                        <div class="costing-field">
                            <label for="txtSearchCostTotal">Total</label>
                            <input type="text" id="txtSearchCostTotal" class="costing-control costing-readonly" readonly />
                        </div>
                    </div>
                </div>

                <div class="cost-row">
                    <div class="cost-row-title"><span>Search Copy Cost</span></div>
                    <div class="cost-row-grid">
                        <div class="costing-field">
                            <label for="ddlSearchCopyCostPattern">Pattern</label>
                            <select id="ddlSearchCopyCostPattern" class="costing-control">
                                <option value="Similar">Similar</option>
                                <option value="Vary">Vary</option>
                            </select>
                        </div>
                        <div class="costing-field">
                            <label for="ddlSearchCopyPagesDocs">Pages / Docs</label>
                            <select id="ddlSearchCopyPagesDocs" class="costing-control">
                                <option value="NoOfPages">No. Of Pages</option>
                                <option value="NoOfDocs">No. Of Docs</option>
                            </select>
                        </div>
                        <div class="costing-field">
                            <label for="txtNoOfPagesAndDocs">Count</label>
                            <input type="text" id="txtNoOfPagesAndDocs" class="costing-control costing-number" />
                        </div>
                        <div class="costing-field">
                            <label id="lblSearchCopyCostPageDoc" for="txtNoOfPagesAndDocsCost">Cost/Page</label>
                            <input type="text" id="txtNoOfPagesAndDocsCost" class="costing-control costing-money-input" />
                        </div>
                        <div class="costing-field">
                            <label for="txtNoOfPagesAndDocsTotalCost">Total</label>
                            <input type="text" id="txtNoOfPagesAndDocsTotalCost" class="costing-control costing-readonly" readonly />
                        </div>
                    </div>
                </div>

                <div class="cost-row" id="trVarySearchCopyCost">
                    <div class="cost-row-title"><span>Search Copy Cost Variation</span></div>
                    <div class="cost-row-grid">
                        <div class="costing-field">
                            <label for="ddlVarySearchCopyPagesDocs">Pages / Docs</label>
                            <select id="ddlVarySearchCopyPagesDocs" class="costing-control">
                                <option value="NoOfPages">No. Of Pages</option>
                                <option value="NoOfDocs">No. Of Docs</option>
                            </select>
                        </div>
                        <div class="costing-field">
                            <label for="txtVaryNoOfPagesAndDocs">Count</label>
                            <input type="text" id="txtVaryNoOfPagesAndDocs" class="costing-control costing-number" />
                        </div>
                        <div class="costing-field">
                            <label id="lblVarySearchCopyCostPageDoc" for="txtVarySearchPageCost">Cost/Page</label>
                            <input type="text" id="txtVarySearchPageCost" class="costing-control costing-money-input" />
                        </div>
                        <div class="costing-field">
                            <label for="txtVarySearhCopyCostTotal">Total</label>
                            <input type="text" id="txtVarySearhCopyCostTotal" class="costing-control costing-readonly" readonly />
                        </div>
                    </div>
                </div>

                <div class="field-grid">
                    <div class="costing-field full">
                        <label for="txtJudgementSearchCostLink">Judgement Search Link</label>
                        <input type="text" id="txtJudgementSearchCostLink" class="costing-control" />
                    </div>
                </div>

                <div class="cost-row">
                    <div class="cost-row-title"><span>Judgment Search Cost</span></div>
                    <div class="cost-row-grid">
                        <div class="costing-field">
                            <label for="ddlJudgementSearchCostNoOfSearches">Cost Basis</label>
                            <select id="ddlJudgementSearchCostNoOfSearches" class="costing-control">
                                <option value="NoOfSearchesMade">No. Of Searches Made</option>
                            </select>
                        </div>
                        <div class="costing-field">
                            <label for="txtJudgementNoOfSearches">Searches</label>
                            <input type="text" id="txtJudgementNoOfSearches" class="costing-control costing-number" />
                        </div>
                        <div class="costing-field">
                            <label for="txtJudgementNoOfSearchesCost">Cost/Search</label>
                            <input type="text" id="txtJudgementNoOfSearchesCost" class="costing-control costing-money-input" />
                        </div>
                        <div class="costing-field">
                            <label for="txtJudgementNoOfSearchesTotalCost">Total</label>
                            <input type="text" id="txtJudgementNoOfSearchesTotalCost" class="costing-control costing-readonly" readonly />
                        </div>
                    </div>
                </div>

                <div class="cost-row">
                    <div class="cost-row-title"><span>Judgment Copy Cost</span></div>
                    <div class="cost-row-grid">
                        <div class="costing-field">
                            <label for="ddlJudjementCopyCostPattern">Pattern</label>
                            <select id="ddlJudjementCopyCostPattern" class="costing-control">
                                <option value="Similar">Similar</option>
                                <option value="Vary">Vary</option>
                            </select>
                        </div>
                        <div class="costing-field">
                            <label for="ddlJudgementCopyPagesDocs">Pages / Docs</label>
                            <select id="ddlJudgementCopyPagesDocs" class="costing-control">
                                <option value="NoOfPages">No. Of Pages</option>
                                <option value="NoOfDocs">No. Of Docs</option>
                            </select>
                        </div>
                        <div class="costing-field">
                            <label for="txtJudjementCopyNoOfPages">Count</label>
                            <input type="text" id="txtJudjementCopyNoOfPages" class="costing-control costing-number" />
                        </div>
                        <div class="costing-field">
                            <label id="lblJudjementCopyPageDoc" for="txtJudjementCopyNoOfPagesCost">Cost/Page</label>
                            <input type="text" id="txtJudjementCopyNoOfPagesCost" class="costing-control costing-money-input" />
                        </div>
                        <div class="costing-field">
                            <label for="txtJudjementCopyNoOfPagesTotalCost">Total</label>
                            <input type="text" id="txtJudjementCopyNoOfPagesTotalCost" class="costing-control costing-readonly" readonly />
                        </div>
                    </div>
                </div>

                <div class="cost-row" id="trVaryJudjementCopyCost">
                    <div class="cost-row-title"><span>Judgment Copy Cost Variation</span></div>
                    <div class="cost-row-grid">
                        <div class="costing-field">
                            <label for="ddlVaryJudgementCopyPagesDocs">Pages / Docs</label>
                            <select id="ddlVaryJudgementCopyPagesDocs" class="costing-control">
                                <option value="NoOfPages">No. Of Pages</option>
                                <option value="NoOfDocs">No. Of Docs</option>
                            </select>
                        </div>
                        <div class="costing-field">
                            <label for="txtVaryJudjementCopyNoOfPages">Count</label>
                            <input type="text" id="txtVaryJudjementCopyNoOfPages" class="costing-control costing-number" />
                        </div>
                        <div class="costing-field">
                            <label id="lblVaryJudjementCopyPageDoc" for="txtVaryJudgmentPageCost">Cost/Page</label>
                            <input type="text" id="txtVaryJudgmentPageCost" class="costing-control costing-money-input" />
                        </div>
                        <div class="costing-field">
                            <label for="txtVaryJudjementCopyNoOfPagesTotalCost">Total</label>
                            <input type="text" id="txtVaryJudjementCopyNoOfPagesTotalCost" class="costing-control costing-readonly" readonly />
                        </div>
                    </div>
                </div>

                <div class="cost-row">
                    <div class="cost-row-title"><span>Tax And Other Charges</span></div>
                    <div class="field-grid">
                        <div class="costing-field wide">
                            <label for="txtTaxDescription">Tax Description</label>
                            <textarea id="txtTaxDescription" class="costing-control"></textarea>
                        </div>
                        <div class="costing-field">
                            <label for="txtTaxTotalAmount">Tax Amount</label>
                            <input type="text" id="txtTaxTotalAmount" class="costing-control costing-money-input" />
                        </div>
                        <div class="costing-field wide">
                            <label for="txtOtherCharges">Other Charges Description</label>
                            <textarea id="txtOtherCharges" class="costing-control"></textarea>
                        </div>
                        <div class="costing-field">
                            <label for="txtOtherChargesAmount">Other Charges Amount</label>
                            <input type="text" id="txtOtherChargesAmount" class="costing-control costing-money-input" />
                        </div>
                    </div>
                </div>

                <div class="field-grid">
                    <div class="costing-field full">
                        <label for="txtCostRemark">Remark</label>
                        <textarea id="txtCostRemark" class="costing-control"></textarea>
                    </div>
                    <div class="costing-field">
                        <label for="txtNoOfDoc"><span class="required">*</span> No of Documents Provided to Client</label>
                        <input type="text" id="txtNoOfDoc" class="costing-control costing-number" />
                    </div>
                    <div class="costing-field">
                        <label for="txtNoOfPages"><span class="required">*</span> No of Pages Provided</label>
                        <input type="text" id="txtNoOfPages" class="costing-control costing-number" />
                    </div>
                    <div class="costing-field">
                        <label for="lblManualTotalSearchEngineCost">Production Cost</label>
                        <input type="text" id="lblManualTotalSearchEngineCost" class="costing-control costing-readonly" readonly />
                    </div>
                    <div class="costing-field">
                        <label for="ddlTaxInfo"><span class="required">*</span> Tax Information Provided</label>
                        <select id="ddlTaxInfo" class="costing-control">
                            <option value="Select">Select</option>
                            <option value="Yes">Yes</option>
                            <option value="No">No</option>
                        </select>
                    </div>
                    <div class="costing-field">
                        <label for="ddlTaxesYN"><span class="required">*</span> Called for Taxes</label>
                        <select id="ddlTaxesYN" class="costing-control">
                            <option value="Select">Select</option>
                            <option value="Yes">Yes</option>
                            <option value="No">No</option>
                        </select>
                    </div>
                    <div class="costing-field">
                        <label for="ddlSnippingTools"><span class="required">*</span> Snipping Tools</label>
                        <select id="ddlSnippingTools" class="costing-control">
                            <option value="Select">Select</option>
                            <option value="Yes">Yes</option>
                            <option value="No">No</option>
                        </select>
                    </div>
                    <div class="costing-field">
                        <label for="txtPagesDeliverToClient">No of Pages Deliver to Client</label>
                        <input type="text" id="txtPagesDeliverToClient" class="costing-control costing-number" />
                    </div>
                    <div class="costing-field wide">
                        <label for="FlInVoice">Attachment</label>
                        <input type="file" id="FlInVoice" class="costing-control" />
                    </div>
                    <div class="costing-field">
                        <label for="txtOrderCost">Order Cost</label>
                        <input type="text" id="txtOrderCost" class="costing-control costing-readonly" readonly />
                    </div>
                </div>

                <div class="costing-actions">
                    <button type="button" id="btnAddProductionCosting" class="btn-costing-primary">
                        <i class="fas fa-plus"></i><span>Add Production Costing</span>
                    </button>
                    <button type="button" id="btnResetProductionCosting" class="btn-costing-secondary">
                        <i class="fas fa-undo"></i><span>Reset</span>
                    </button>
                </div>

                <div class="grid-panel">
                    <div class="grid-panel-header">
                        <h3>Production Costing Report</h3>
                        <span id="productionGridCount">0 records</span>
                    </div>
                    <div class="grid-wrap">
                        <table id="grdManualCostingReport" class="table table-striped table-hover costing-table">
                            <thead>
                                <tr>
                                    <th rowspan="2">Sr.#</th>
                                    <th rowspan="2">Order No</th>
                                    <th rowspan="2">Search Engine Type</th>
                                    <th rowspan="2">Search Engine Link</th>
                                    <th colspan="3" class="costing-band-header">Search Cost</th>
                                    <th colspan="8" class="costing-band-header">Search Copy Cost</th>
                                    <th rowspan="2">Judgement Search Link</th>
                                    <th colspan="3" class="costing-band-header">Judgment Search Cost</th>
                                    <th colspan="8" class="costing-band-header">Judgment Search Copy Cost</th>
                                    <th colspan="2" class="costing-band-header">Tax Charges</th>
                                    <th colspan="2" class="costing-band-header">Other Charges</th>
                                    <th rowspan="2">Remark</th>
                                    <th rowspan="2">Documents</th>
                                    <th rowspan="2">Pages</th>
                                    <th rowspan="2">Tax Info</th>
                                    <th rowspan="2">Called Taxes</th>
                                    <th rowspan="2">Snipping Tools</th>
                                    <th rowspan="2">Pages Deliver</th>
                                    <th rowspan="2">Attachment</th>
                                    <th rowspan="2">Production Cost</th>
                                </tr>
                                <tr>
                                    <th>Searches</th>
                                    <th>Cost/Search</th>
                                    <th>Search Total</th>
                                    <th>Pattern</th>
                                    <th>Main Count</th>
                                    <th>Main Cost</th>
                                    <th>Main Total</th>
                                    <th>Vary Count</th>
                                    <th>Vary Cost</th>
                                    <th>Vary Total</th>
                                    <th>Copy Cost Total</th>
                                    <th>Searches</th>
                                    <th>Cost/Search</th>
                                    <th>Search Total</th>
                                    <th>Pattern</th>
                                    <th>Main Count</th>
                                    <th>Main Cost</th>
                                    <th>Main Total</th>
                                    <th>Vary Count</th>
                                    <th>Vary Cost</th>
                                    <th>Vary Total</th>
                                    <th>Copy Cost Total</th>
                                    <th>Description</th>
                                    <th>Amount</th>
                                    <th>Description</th>
                                    <th>Amount</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </section>

            <section class="costing-section">
                <div class="section-header">
                    <h2><i class="fas fa-user-tie"></i><span>Abstractor Cost</span></h2>
                </div>

                <div class="costing-note">Note: If abstractor cost is zero then Description should be "Invoice Not available".</div>

                <div id="abstractorDisabledNote" class="alert alert-info costing-alert" style="display: none;">Abstractor costing is enabled only for Offline or Online to Offline orders.</div>

                <div class="field-grid">
                    <div class="costing-field">
                        <label for="txtAbstractorSearchCost">Search Cost</label>
                        <input type="text" id="txtAbstractorSearchCost" class="costing-control costing-money-input" />
                    </div>
                    <div class="costing-field">
                        <label for="ddlAbstractorPagesCopy">Copy Cost Basis</label>
                        <select id="ddlAbstractorPagesCopy" class="costing-control">
                            <option value="NoOfSearchesMade">No. Of Pages</option>
                        </select>
                    </div>
                    <div class="costing-field">
                        <label for="txtAbstractorPagesCopyCost">No. Of Pages</label>
                        <input type="text" id="txtAbstractorPagesCopyCost" class="costing-control costing-number" />
                    </div>
                    <div class="costing-field">
                        <label for="txtAbstractorPagesCopyCostTotal">Copy Cost Total</label>
                        <input type="text" id="txtAbstractorPagesCopyCostTotal" class="costing-control costing-money-input" />
                    </div>
                    <div class="costing-field wide">
                        <label for="txtAbstractorOtherDescription">Other Cost Description</label>
                        <textarea id="txtAbstractorOtherDescription" class="costing-control"></textarea>
                    </div>
                    <div class="costing-field">
                        <label for="txtAbstractorOtherCost">Other Amount</label>
                        <input type="text" id="txtAbstractorOtherCost" class="costing-control costing-money-input" />
                    </div>
                    <div class="costing-field">
                        <label for="txtTotalAbstractorCost">Abstractor Cost</label>
                        <input type="text" id="txtTotalAbstractorCost" class="costing-control costing-readonly" readonly />
                    </div>
                </div>

                <div class="costing-actions">
                    <button type="button" id="btnAddAbstractor" class="btn-costing-primary">
                        <i class="fas fa-plus"></i><span>Add Abstractor</span>
                    </button>
                </div>

                <div class="grid-panel">
                    <div class="grid-panel-header">
                        <h3>Abstractor Costing Report</h3>
                        <span id="abstractorGridCount">0 records</span>
                    </div>
                    <div class="grid-wrap">
                        <table id="grdAbstarctor" class="table table-striped table-hover costing-table">
                            <thead>
                                <tr>
                                    <th>Sr.#</th>
                                    <th>Order No</th>
                                    <th>Search Engine</th>
                                    <th>Search Engine Type</th>
                                    <th>Search Cost</th>
                                    <th>No Of Pages</th>
                                    <th>Copy Cost Total</th>
                                    <th>Other Description</th>
                                    <th>Other Cost</th>
                                    <th>Abstractor Cost</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </section>

            <section class="costing-section">
                <div class="section-header">
                    <h2><i class="fas fa-credit-card"></i><span>Credit Card Payment Information</span></h2>
                </div>

                <div class="field-grid">
                    <div class="costing-field">
                        <label for="txtCostNameOfTheCard">Name of the Card</label>
                        <input type="text" id="txtCostNameOfTheCard" class="costing-control" />
                    </div>
                    <div class="costing-field">
                        <label for="txtCreditCardNo">Credit Card No.</label>
                        <input type="text" id="txtCreditCardNo" class="costing-control costing-number" maxlength="4" />
                    </div>
                    <div class="costing-field">
                        <label for="txtCostValidUpTO">Valid Up To</label>
                        <input type="text" id="txtCostValidUpTO" class="costing-control" placeholder="MM-DD-YYYY" />
                    </div>
                    <div class="costing-field">
                        <label for="txtCostNameOfThePlant">Name Of The Plant</label>
                        <input type="text" id="txtCostNameOfThePlant" class="costing-control" />
                    </div>
                    <div class="costing-field">
                        <label for="txtCostSearchingAmount">Searching Amount</label>
                        <input type="text" id="txtCostSearchingAmount" class="costing-control costing-money-input" />
                    </div>
                    <div class="costing-field">
                        <label for="txtCostDownloadingAmount">Downloading Amount</label>
                        <input type="text" id="txtCostDownloadingAmount" class="costing-control costing-money-input" />
                    </div>
                </div>
            </section>

            <div class="final-actions">
                <div class="costing-actions">
                    <button type="button" id="btnAddManualCosting" class="btn-costing-primary">
                        <i class="fas fa-save"></i><span>Save And Exit</span>
                    </button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
