<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EditInfinityFeedback.aspx.cs" Inherits="WebPortal.Admin.EditInfinityFeedback" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        body {
            background: #f3f6f8;
        }

        .inf-page {
            color: #16202a;
            padding-bottom: 28px;
        }

        .inf-hero {
            align-items: center;
            background: linear-gradient(135deg, #0f766e 0%, #1d4ed8 100%);
            border-radius: 8px;
            box-shadow: 0 14px 28px rgba(28, 58, 85, 0.16);
            color: #fff;
            display: flex;
            gap: 20px;
            justify-content: space-between;
            margin-bottom: 18px;
            padding: 22px 24px;
        }

        .inf-kicker {
            color: rgba(255,255,255,0.82);
            font-size: 12px;
            font-weight: 700;
            margin-bottom: 6px;
            text-transform: uppercase;
        }

        .inf-title {
            font-size: 24px;
            font-weight: 700;
            line-height: 1.2;
            margin: 0;
        }

        .inf-subtitle {
            color: rgba(255,255,255,0.88);
            font-size: 13px;
            margin: 8px 0 0;
            max-width: 760px;
        }

        .inf-hero-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: flex-end;
        }

        .inf-btn {
            align-items: center;
            border-radius: 6px;
            display: inline-flex;
            font-size: 13px;
            font-weight: 700;
            gap: 8px;
            justify-content: center;
            min-height: 38px;
            padding: 8px 14px;
        }

        .inf-btn-primary {
            background: #0f766e;
            border: 1px solid #0f766e;
            color: #fff;
        }

            .inf-btn-primary:hover,
            .inf-btn-primary:focus {
                background: #0b5f59;
                border-color: #0b5f59;
                color: #fff;
            }

        .inf-btn-light {
            background: rgba(255,255,255,0.96);
            border: 1px solid rgba(255,255,255,0.96);
            color: #17324d;
        }

        .inf-panel {
            background: #fff;
            border: 1px solid #dce5ec;
            border-radius: 8px;
            box-shadow: 0 10px 24px rgba(31, 51, 71, 0.06);
            margin-bottom: 18px;
            overflow: hidden;
        }

        .inf-panel-header {
            align-items: center;
            border-bottom: 1px solid #e7edf2;
            display: flex;
            gap: 14px;
            justify-content: space-between;
            padding: 16px 18px;
        }

        .inf-panel-title {
            align-items: center;
            color: #172737;
            display: flex;
            font-size: 16px;
            font-weight: 700;
            gap: 9px;
            margin: 0;
        }

        .inf-panel-subtitle {
            color: #6d7f90;
            font-size: 12px;
            margin: 4px 0 0;
        }

        .inf-panel-body {
            padding: 18px;
        }

        .inf-section-title {
            align-items: center;
            color: #2d3f50;
            display: flex;
            font-size: 13px;
            font-weight: 800;
            gap: 8px;
            margin: 18px 0 12px;
        }

            .inf-section-title:first-child {
                margin-top: 0;
            }

        .inf-form-grid {
            display: grid;
            gap: 14px 16px;
            grid-template-columns: repeat(3, minmax(0, 1fr));
        }

        .inf-field {
            min-width: 0;
        }

        .inf-severity-dependent[hidden],
        .inf-feedback-status-field[hidden] {
            display: none !important;
        }

        .inf-field-wide {
            grid-column: span 3;
        }

        .inf-field label {
            color: #46596b;
            display: block;
            font-size: 12px;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .inf-field .form-control {
            border-color: #cfdbe5;
            border-radius: 6px;
            box-shadow: none;
            color: #172737;
            font-size: 13px;
            min-height: 38px;
            width: 100%;
        }

        .inf-field textarea.form-control {
            min-height: 86px;
            resize: vertical;
        }

        .inf-field .form-control:focus {
            border-color: #0f766e;
            box-shadow: 0 0 0 3px rgba(15, 118, 110, 0.14);
        }

        .inf-field .form-control:disabled {
            background: #f6f9fb;
            color: #667789;
            opacity: 1;
        }

        .inf-action-row {
            align-items: center;
            border-top: 1px solid #e7edf2;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 18px;
            padding-top: 16px;
        }

        .inf-table-wrap {
            padding: 0 18px 18px;
            overflow-x: auto;
        }

        #table_productionData {
            border-collapse: separate !important;
            border-spacing: 0;
            margin: 0 !important;
            width: 100% !important;
        }

            #table_productionData thead th {
                background: #edf3f6 !important;
                border-color: #d7e2ea !important;
                color: #263747;
                font-size: 12px;
                /*text-align: center;*/
                vertical-align: middle;
                white-space: nowrap;
            }

            #table_productionData tbody td {
                /*  background: #fff;*/
                background: #edf3f6 !important;
                border-color: #d7e2ea !important;
                border-color: #e2e9ef !important;
                color: #263747;
                font-size: 12px;
                vertical-align: middle;
            }

            #table_productionData tbody tr:hover td {
                background: #f7fbfa;
            }

        .loading {
            align-items: center;
            background: rgba(255,255,255,0.92);
            border: 1px solid #dce5ec;
            border-radius: 8px;
            box-shadow: 0 18px 40px rgba(20, 33, 45, 0.18);
            color: #263747;
            display: none;
            font-size: 12px;
            font-weight: 700;
            left: 50%;
            min-width: 220px;
            padding: 18px;
            position: fixed;
            text-align: center;
            top: 42%;
            transform: translate(-50%, -50%);
            z-index: 99999;
        }

            .loading img {
                display: block;
                margin: 0 auto 10px;
                max-width: 44px;
            }

        @media (max-width: 1199px) {
            .inf-form-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .inf-field-wide {
                grid-column: span 2;
            }
        }

        @media (max-width: 767px) {
            .inf-hero {
                align-items: flex-start;
                flex-direction: column;
            }

            .inf-hero-actions,
            .inf-action-row {
                align-items: stretch;
                flex-direction: column;
                width: 100%;
            }

            .inf-btn {
                width: 100%;
            }

            .inf-form-grid {
                grid-template-columns: 1fr;
            }

            .inf-field-wide {
                grid-column: span 1;
            }
        }

        .hero-back-link {
            position: relative;
            z-index: 1;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 14px;
            color: #fff !important;
            background: rgba(255, 255, 255, .16);
            border: 1px solid rgba(255, 255, 255, .22);
            border-radius: 999px;
            font-size: 13px;
            font-weight: 800;
            text-decoration: none !important;
            transition: transform .16s ease, background .16s ease;
        }

            .hero-back-link:hover {
                color: #fff !important;
                background: rgba(255, 255, 255, .24);
                transform: translateY(-1px);
            }
    </style>

    <script>

        $(document).ready(function () {

            const urlParams = new URLSearchParams(window.location.search);
            const FeedbackID = urlParams.get('FID');
            const subdomain = urlParams.get('s');

            $('#infFeedback_Severity').on('change', toggleSeverityDependentFields);
            toggleSeverityDependentFields();
            BindInfinityFeedback(FeedbackID, subdomain);

            //  BingProductionDataGrid('9761798470', 'EDWIN ROBERT'); //9761798470	2377	EDWIN ROBERT
        });

    </script>


</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="filep_ap" style="display: none;" />
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div>One moment, please . . . .</div>
    </div>

    <div class="inf-page">
        <div class="inf-hero">
            <div>
                <div class="inf-kicker">Quality Feedback</div>
                <h1 class="inf-title">
                    <i class="fas fa-comment-dots mr-2"></i>
                    Edit Infinity Feedback
                </h1>
                <p class="inf-subtitle">
                    Review feedback details, update finding and RCA information, and verify related production records.
               
                </p>
            </div>
            <div class="inf-hero-actions">
                <a href="~/Admin/InfinityFeedback.aspx" id="aBack" runat="server" class="hero-back-link">
                    <i class="fas fa-arrow-left"></i>
                    Back
                </a>
            </div>
        </div>

        <div class="inf-panel">
            <div class="inf-panel-header">
                <div>
                    <h2 class="inf-panel-title"><i class="fas fa-pen-to-square"></i>Feedback Details</h2>
                    <div class="inf-panel-subtitle">Labels are placed above each field for a cleaner, responsive form layout.</div>
                </div>
            </div>
            <div class="inf-panel-body">
                <div class="inf-section-title"><i class="fas fa-circle-info"></i>Loan And Review Information</div>
                <div class="inf-form-grid">
                    <div class="inf-field">
                        <label for="infFeedback_LoanNo">Loan #</label>
                        <input type="text" id="infFeedback_LoanNo" name="infFeedback_LoanNo" class="form-control" disabled="disabled" />
                    </div>
                    <div class="inf-field">
                        <label for="infFeedback_Client">Client</label>
                        <input type="text" id="infFeedback_Client" name="infFeedback_Client" class="form-control" disabled="disabled" />
                    </div>
                    <div class="inf-field">
                        <label for="infFeedback_UWName">UW Name</label>
                        <input type="text" id="infFeedback_UWName" name="infFeedback_UWName" class="form-control" disabled="disabled" />
                    </div>
                    <div class="inf-field">
                        <label for="infFeedback_DateReviewed">Date Reviewed</label>
                        <input type="text" id="infFeedback_DateReviewed" name="infFeedback_DateReviewed" class="form-control" disabled="disabled" />
                    </div>
                    <div class="inf-field">
                        <label for="infFeedback_QCName">QC Name</label>
                        <input type="text" id="infFeedback_QCName" name="infFeedback_QCName" class="form-control" disabled="disabled" />
                    </div>
                    <div class="inf-field">
                        <label for="infFeedback_QcDate">QC Date</label>
                        <input type="text" id="infFeedback_QcDate" name="infFeedback_QcDate" class="form-control" disabled="disabled" />
                    </div>
                </div>

                <div class="inf-section-title"><i class="fas fa-triangle-exclamation"></i>Feedback Classification</div>
                <div class="inf-form-grid">
                    <div class="inf-field inf-severity-dependent">
                        <label for="infFeedback_Category">Category</label>
                        <input type="text" id="infFeedback_Category" name="infFeedback_Category" class="form-control" />
                    </div>
                    <div class="inf-field inf-severity-dependent">
                        <label for="infFeedback_SubCategory">Sub Category</label>
                        <input type="text" id="infFeedback_SubCategory" name="infFeedback_SubCategory" class="form-control" />
                    </div>
                    <div class="inf-field inf-severity-dependent">
                        <label for="infFeedback_ErrorField">Error Field</label>
                        <input type="text" id="infFeedback_ErrorField" name="infFeedback_Sategory" class="form-control" />
                    </div>
                    <div class="inf-field inf-severity-dependent">
                        <label for="infFeedback_Screen">Screen</label>
                        <input type="text" id="infFeedback_Screen" name="infFeedback_Screen" class="form-control" />
                    </div>
                    <div class="inf-field inf-severity-dependent">
                        <label for="infFeedback_ErrorType">Error Type</label>
                        <input type="text" id="infFeedback_ErrorType" name="infFeedback_ErrorType" class="form-control" />
                    </div>
                    <div class="inf-field inf-severity-dependent">
                        <label for="infFeedback_FeedbackType">Feedback Type</label>
                        <input type="text" id="infFeedback_FeedbackType" name="infFeedback_FeedbackType" class="form-control" />
                    </div>
                    <div class="inf-field">
                        <label for="infFeedback_Severity">Severity</label>
                        <select id="infFeedback_Severity" name="infFeedback_Severity" class="form-control" disabled>
                            <option value="">Select</option>
                            <option value="Critical">Critical</option>
                            <option value="Non-Critical">Non-Critical</option>
                            <option value="No Error">No Error</option>
                        </select>
                    </div>
                    <div class="inf-field inf-feedback-status-field" hidden="hidden">
                        <label for="infFeedback_FeedbackStatus">Feedback Status</label>
                        <select id="infFeedback_FeedbackStatus" name="infFeedback_FeedbackStatus" class="form-control">
                            <option value="">Select</option>
                            <option value="Agree">Agree</option>
                            <option value="Disagree">Disagree</option>
                        </select>
                    </div>
                    <div class="inf-field">
                        <label for="infFeedback_Source">Source</label>
                        <input type="text" id="infFeedback_Source" name="infFeedback_Source" class="form-control" />
                    </div>
                    <div class="inf-field">
                        <label for="infFeedback_FeedbackRecDate">Feedback Received Date</label>
                        <input type="text" id="infFeedback_FeedbackRecDate" name="infFeedback_FeedbackRecDate" class="form-control" />
                    </div>
                    <div class="inf-field inf-field-wide inf-severity-dependent">
                        <label for="infFeedback_Finding">Finding</label>
                        <textarea id="infFeedback_Finding" name="infFeedback_Finding" class="form-control"></textarea>
                    </div>
                    <div class="inf-field inf-field-wide inf-severity-dependent">
                        <label for="infFeedback_RCA">RCA / Rebuttal Comments</label>
                        <textarea id="infFeedback_RCA" name="infFeedback_RCA" class="form-control"></textarea>
                    </div>
                </div>

                <div class="inf-action-row">
                    <button class="inf-btn inf-btn-primary" type="button" id="btnAddFeedback" onclick="return edit_OnClickAddFeedback();">
                        <i class="fas fa-save"></i>
                        Update Feedback
                   
                    </button>
                </div>
            </div>
        </div>

        <div class="inf-panel">
            <div class="inf-panel-header">
                <div>
                    <h2 class="inf-panel-title"><i class="fas fa-table-list"></i>Production Data</h2>
                    <div class="inf-panel-subtitle">Related reviewer and process details linked to this feedback.</div>
                </div>
            </div>
            <div class="inf-table-wrap">
                <table class="table" id="table_productionData">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; display:none;">Actions</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; display: none;">ProdID</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Reviewer</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Process</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Completion Date</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

</asp:Content>
