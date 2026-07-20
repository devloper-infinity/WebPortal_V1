<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AICopilot.aspx.cs" Inherits="WebPortal.Admin.AICopilot" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>ERP Copilot</title>

    <style>
        .copilot-wrapper {
            max-width: 900px;
            margin: 25px auto;
            background: #fff;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 18px rgba(0,0,0,0.08);
            font-family: Arial;
        }

        .copilot-title {
            font-size: 22px;
            font-weight: 600;
            margin-bottom: 15px;
        }

        #txtQuestion {
            width: 100%;
            min-height: 110px;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 8px;
            resize: vertical;
        }

        #btnAskAI {
            margin-top: 12px;
            padding: 9px 22px;
            border: none;
            border-radius: 6px;
            background: #1f4e79;
            color: white;
            cursor: pointer;
        }

        #aiResult {
            margin-top: 20px;
            background: #f7f9fc;
            border-left: 4px solid #1f4e79;
            padding: 15px;
            border-radius: 8px;
            white-space: pre-line;
            line-height: 1.5;
        }
    </style>
</head>

<body>
    <form id="form1" runat="server">
        <div class="ai-copilot-shell">

            <div class="ai-sidebar">
                <div class="ai-brand">
                    <div class="ai-logo">AI</div>
                    <div>
                        <h4>ERP Copilot</h4>
                        <span>Internal AI Assistant</span>
                    </div>
                </div>

                <button type="button" id="btnNewChat" class="ai-new-chat">
                    + New Chat
                </button>

                <div class="ai-quick-title">Quick Actions</div>

                <button type="button" class="ai-chip" data-prompt="Find salary slip">
                    Salary Slip
                </button>

                <button type="button" class="ai-chip" data-prompt="Find attendance report">
                    Attendance Report
                </button>

                <button type="button" class="ai-chip" data-prompt="Find resignation page">
                    Resignation
                </button>

                <button type="button" class="ai-chip" data-prompt="Find performance report">
                    Performance Report
                </button>
            </div>

            <div class="ai-main">

                <div class="ai-header">
                    <div>
                        <h3>ERP Copilot</h3>
                        <p>Ask about ERP menus, report pages, attendance, billing, or workflow help.</p>
                    </div>
                    <div class="ai-status">
                        <span></span>Local AI Active
                    </div>
                </div>

                <div id="chatBox" class="ai-chat-box">
                    <div class="ai-empty">
                        <div class="ai-empty-icon">AI</div>
                        <h4>How can I help you today?</h4>
                        <p>Ask for a menu, report, or ERP workflow.</p>
                    </div>
                </div>

                <div class="ai-input-area">
                <textarea id="txtQuestion" placeholder="Ask for a menu or report..."></textarea>
                    <button type="button" id="btnAskAI">Send</button>
                </div>

            </div>
        </div>
        <style>
            .ai-copilot-shell {
                display: flex;
                height: calc(100vh - 120px);
                min-height: 620px;
                background: #f3f6fb;
                border-radius: 14px;
                overflow: hidden;
                border: 1px solid #dfe5ef;
                font-family: "Segoe UI", Arial, sans-serif;
            }

            .ai-sidebar {
                width: 280px;
                background: linear-gradient(180deg, #102a43, #163b5c);
                color: #fff;
                padding: 20px;
            }

            .ai-brand {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 25px;
            }

            .ai-logo {
                width: 42px;
                height: 42px;
                border-radius: 12px;
                background: #ffffff;
                color: #163b5c;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: 700;
            }

            .ai-brand h4 {
                margin: 0;
                font-size: 18px;
            }

            .ai-brand span {
                font-size: 12px;
                opacity: .75;
            }

            .ai-new-chat {
                width: 100%;
                border: 1px solid rgba(255,255,255,.35);
                background: rgba(255,255,255,.12);
                color: #fff;
                padding: 11px;
                border-radius: 10px;
                margin-bottom: 25px;
                cursor: pointer;
            }

            .ai-quick-title {
                font-size: 12px;
                text-transform: uppercase;
                opacity: .7;
                margin-bottom: 10px;
            }

            .ai-chip {
                width: 100%;
                display: block;
                background: rgba(255,255,255,.10);
                border: none;
                color: #fff;
                text-align: left;
                padding: 11px 12px;
                border-radius: 10px;
                margin-bottom: 9px;
                cursor: pointer;
            }

                .ai-chip:hover,
                .ai-new-chat:hover {
                    background: rgba(255,255,255,.20);
                }

            .ai-main {
                flex: 1;
                display: flex;
                flex-direction: column;
                background: #fff;
            }

            .ai-header {
                padding: 18px 24px;
                border-bottom: 1px solid #e8edf5;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

                .ai-header h3 {
                    margin: 0;
                    font-size: 22px;
                    color: #102a43;
                }

                .ai-header p {
                    margin: 4px 0 0;
                    font-size: 13px;
                    color: #64748b;
                }

            .ai-status {
                font-size: 13px;
                background: #ecfdf5;
                color: #047857;
                padding: 7px 12px;
                border-radius: 20px;
            }

                .ai-status span {
                    width: 8px;
                    height: 8px;
                    background: #10b981;
                    display: inline-block;
                    border-radius: 50%;
                    margin-right: 6px;
                }

            .ai-chat-box {
                flex: 1;
                padding: 24px;
                overflow-y: auto;
                background: #f8fafc;
            }

            .ai-empty {
                text-align: center;
                margin-top: 120px;
                color: #475569;
            }

            .ai-empty-icon {
                font-size: 42px;
                margin-bottom: 10px;
            }

            .ai-message-row {
                display: flex;
                margin-bottom: 18px;
            }

                .ai-message-row.user {
                    justify-content: flex-end;
                }

            .ai-message {
                max-width: 75%;
                padding: 13px 15px;
                border-radius: 14px;
                line-height: 1.5;
                font-size: 14px;
                white-space: pre-line;
            }

                .ai-message.user {
                    background: #1f4e79;
                    color: #fff;
                    border-bottom-right-radius: 4px;
                }

                .ai-message.bot {
                    background: #fff;
                    color: #1e293b;
                    border: 1px solid #e2e8f0;
                    border-bottom-left-radius: 4px;
                }

            .ai-input-area {
                border-top: 1px solid #e8edf5;
                padding: 15px;
                display: flex;
                gap: 10px;
                background: #fff;
            }

            #txtQuestion {
                flex: 1;
                min-height: 52px;
                max-height: 130px;
                resize: vertical;
                border: 1px solid #cbd5e1;
                border-radius: 12px;
                padding: 12px;
                font-size: 14px;
                outline: none;
            }

                #txtQuestion:focus {
                    border-color: #1f4e79;
                }

            #btnAskAI {
                width: 95px;
                border: none;
                border-radius: 12px;
                background: #1f4e79;
                color: #fff;
                font-weight: 600;
                cursor: pointer;
            }

                #btnAskAI:disabled {
                    opacity: .6;
                    cursor: not-allowed;
                }

            .ai-typing {
                font-style: italic;
                color: #64748b;
            }

            @media(max-width: 768px) {
                .ai-copilot-shell {
                    flex-direction: column;
                    height: auto;
                }

                .ai-sidebar {
                    width: auto;
                }

                .ai-message {
                    max-width: 90%;
                }
            }
        </style>
    </form>

    <script src="../plugins/jquery/jquery.min.js"></script>

    <portal:VersionedScript Src="~/Scripts/AI.js" runat="server"></portal:VersionedScript>

</body>
</html>
