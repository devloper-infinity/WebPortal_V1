<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Birthday.aspx.cs" Inherits="WebPortal.Admin.Birthday" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../plugins/sweetalert2-theme-bootstrap-4/bootstrap-4.min.css" />
    <link rel="stylesheet" href="../plugins/sweetalert2/sweetalert2.min.css" />
    <script src="../plugins/sweetalert2/sweetalert2.all.min.js"></script>
    <script src="../Scripts/Functions/Birthday.js?v=@DateTime.Now.Ticks"></script>

    <style>
        :root {
            --bd-primary: #7c3aed;
            --bd-teal: #0891b2;
            --bd-rose: #ec4899;
            --bd-amber: #f59e0b;
            --bd-text: #172033;
            --bd-muted: #667085;
            --bd-border: #f1d9e8;
            --bd-page: #fff7ed;
            --bd-surface: #ffffff;
            --bd-shadow: 0 18px 42px rgba(190, 18, 60, .12);
        }

        body,
        .content-wrapper {
            background: var(--bd-page) !important;
        }

        .birthday-page {
            background:
                linear-gradient(90deg, rgba(236, 72, 153, .07) 1px, transparent 1px),
                linear-gradient(180deg, rgba(245, 158, 11, .08) 1px, transparent 1px);
            background-size: 28px 28px;
        }

        .bd-loader {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 99999;
            align-items: center;
            justify-content: center;
            background: rgba(245, 247, 251, .76);
            backdrop-filter: blur(5px);
        }

        .bd-loader-card {
            width: 194px;
            padding: 22px;
            border: 1px solid var(--bd-border);
            border-radius: 8px;
            background: #fff;
            text-align: center;
            box-shadow: var(--bd-shadow);
            color: var(--bd-muted);
            font-size: 13px;
            font-weight: 800;
        }

        .bd-loader-card img {
            width: 64px;
            height: 64px;
            margin-bottom: 10px;
        }

        .bd-hero {
            position: relative;
            overflow: hidden;
            margin-bottom: 16px;
            min-height: 128px;
            padding: 26px 26px;
            border: 1px solid rgba(236, 72, 153, .25);
            border-radius: 8px;
            color: #fff;
            background:linear-gradient(135deg, rgba(124, 58, 237, .98) 0%, rgba(236, 72, 153, .95) 48%, rgba(245, 158, 11, .95) 100%);
            box-shadow: 0 22px 48px rgba(236, 72, 153, .22);
        }

        .bd-hero::before {
            content: "";
            position: absolute;
            inset: 0;
            opacity: .22;
            background-image:
                linear-gradient(90deg, rgba(255,255,255,.9) 0 10px, transparent 10px 100%),
                linear-gradient(90deg, #fde68a 0 8px, transparent 8px 100%),
                linear-gradient(90deg, #a7f3d0 0 7px, transparent 7px 100%),
                linear-gradient(90deg, #bfdbfe 0 9px, transparent 9px 100%);
            background-size: 92px 4px, 74px 4px, 62px 4px, 84px 4px;
            background-position: 9px 20px, 34px 54px, 14px 86px, 62px 112px;
            transform: rotate(-7deg) scale(1.1);
            pointer-events: none;
        }

        .bd-hero::after {
            content: "";
            position: absolute;
            right: -56px;
            top: 18px;
            width: 220px;
            height: 74px;
            background: rgba(255, 255, 255, .18);
            transform: rotate(-18deg);
            pointer-events: none;
        }

        .bd-hero-content {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
        }

        .bd-title-wrap {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .bd-title-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 62px;
            height: 62px;
            border: 1px solid rgba(255, 255, 255, .25);
            border-radius: 8px;
            background: linear-gradient(135deg, rgba(255, 255, 255, .28), rgba(255, 255, 255, .12));
            box-shadow: inset 0 1px 0 rgba(255,255,255,.24), 0 12px 26px rgba(124, 58, 237, .22);
            font-size: 26px;
            animation: bdPartyBounce 2.8s ease-in-out infinite;
        }

        .bd-hero h1 {
            margin: 0;
            font-size: 30px;
            font-weight: 900;
            line-height: 1.15;
            letter-spacing: 0;
        }

        .bd-hero p {
            margin: 7px 0 0;
            color: rgba(255, 255, 255, .9);
            font-size: 14px;
            font-weight: 600;
        }

        .bd-hero-chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            min-height: 38px;
            padding: 9px 13px;
            border: 1px solid rgba(255, 255, 255, .34);
            border-radius: 999px;
            background: rgba(255, 255, 255, .18);
            font-size: 12px;
            font-weight: 900;
            white-space: nowrap;
            box-shadow: inset 0 1px 0 rgba(255,255,255,.2);
        }

        @keyframes bdPartyBounce {
            0%, 100% { transform: translateY(0) rotate(-3deg); }
            50% { transform: translateY(-5px) rotate(4deg); }
        }

        .bd-summary-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(180px, 1fr));
            gap: 12px;
            margin-bottom: 16px;
        }

        .bd-summary-card {
            display: flex;
            align-items: center;
            gap: 12px;
            min-height: 70px;
            padding: 14px;
            border: 1px solid rgba(236, 72, 153, .18);
            border-radius: 8px;
            background: linear-gradient(180deg, #ffffff 0%, #fff7fb 100%);
            box-shadow: 0 10px 24px rgba(236, 72, 153, .08);
            position: relative;
            overflow: hidden;
        }

        .bd-summary-card::before {
            content: "";
            position: absolute;
            inset: 0 auto 0 0;
            width: 5px;
            background: var(--accent);
        }

        .bd-summary-card i {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 38px;
            height: 38px;
            border-radius: 8px;
            color: var(--accent);
            background: var(--accent-soft);
            font-size: 17px;
        }

        .bd-summary-card span {
            display: block;
            color: var(--bd-muted);
            font-size: 12px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: .03em;
        }

        .bd-summary-card strong {
            display: block;
            margin-top: 3px;
            color: var(--bd-text);
            font-size: 19px;
            font-weight: 900;
            line-height: 1;
        }

        .bd-summary-today { --accent: var(--bd-primary); --accent-soft: #f5f3ff; }
        .bd-summary-selected { --accent: var(--bd-teal); --accent-soft: #ecfeff; }
        .bd-summary-messages { --accent: var(--bd-rose); --accent-soft: #fdf2f8; }

        .bd-grid {
            display: grid;
            grid-template-columns: minmax(0, 1.15fr) minmax(360px, .85fr);
            gap: 16px;
            align-items: start;
        }

        .bd-panel {
            overflow: hidden;
            border: 1px solid rgba(236, 72, 153, .16);
            border-radius: 8px;
            background: var(--bd-surface);
            box-shadow: var(--bd-shadow);
        }

        .bd-panel-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            padding: 15px 16px;
            border-bottom: 1px solid rgba(236, 72, 153, .16);
            background: linear-gradient(90deg, #fff7fb 0%, #fff7ed 100%);
        }

        .bd-panel-title h2 {
            margin: 0;
            color: var(--bd-text);
            font-size: 17px;
            font-weight: 900;
            line-height: 1.2;
        }

        .bd-panel-title span {
            display: block;
            margin-top: 4px;
            color: var(--bd-muted);
            font-size: 12px;
            font-weight: 700;
        }

        .bd-tools {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 10px;
            flex-wrap: wrap;
        }

        .bd-search {
            display: flex;
            align-items: center;
            gap: 8px;
            min-width: 240px;
            padding: 8px 11px;
            border: 1px solid var(--bd-border);
            border-radius: 8px;
            background: #fff;
            color: var(--bd-rose);
        }

        .bd-search input {
            width: 100%;
            border: 0;
            outline: 0;
            color: var(--bd-text);
            font-size: 14px;
            background: transparent;
        }

        .bd-action-btn,
        .bd-send-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-height: 38px;
            border: 0;
            border-radius: 8px;
            padding: 9px 13px;
            color: #fff;
            background: linear-gradient(135deg, var(--bd-primary), var(--bd-rose));
            font-size: 13px;
            font-weight: 900;
            cursor: pointer;
            transition: transform .18s ease, box-shadow .18s ease;
        }

        .bd-action-btn:hover,
        .bd-send-btn:hover {
            color: #fff;
            transform: translateY(-1px);
            box-shadow: 0 12px 24px rgba(236, 72, 153, .22);
        }

        .bd-table-wrap {
            padding: 14px;
        }

        #bdash_list {
            width: 100% !important;
            margin: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0;
        }

        #bdash_list thead th,
        .table.dataTable th {
            border: 0 !important;
            background: #fdf2f8 !important;
            color: #831843 !important;
            font-size: 12px;
            font-weight: 900;
            text-transform: uppercase;
            letter-spacing: .03em;
            padding: 12px !important;
            white-space: nowrap;
        }

        #bdash_list tbody td {
            padding: 12px !important;
            border-top: 1px solid #edf2f7;
            color: #334155;
            font-size: 13px;
            vertical-align: middle;
            background: #fff;
        }

        #bdash_list tbody tr {
            cursor: pointer;
        }

        #bdash_list tbody tr:hover td,
        #bdash_list tbody tr.is-selected td {
            background: #fff7ed !important;
        }

        .bd-view-btn {
            width: 32px;
            height: 32px;
            border: 0;
            border-radius: 8px;
            color: #be123c;
            background: #fdf2f8;
            cursor: pointer;
        }

        .bd-person {
            display: flex;
            align-items: center;
            gap: 10px;
            min-width: 210px;
        }

        .bd-avatar {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 36px;
            height: 36px;
            border-radius: 8px;
            color: #fff;
            background: linear-gradient(135deg, #ec4899, #f59e0b);
            font-size: 13px;
            font-weight: 900;
            flex: 0 0 auto;
        }

        .bd-person strong {
            display: block;
            color: var(--bd-text);
            font-size: 13px;
            font-weight: 900;
        }

        .bd-person span {
            display: block;
            margin-top: 2px;
            color: var(--bd-muted);
            font-size: 12px;
            font-weight: 700;
        }

        .bd-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 5px 9px;
            border-radius: 999px;
            color: #9a3412;
            background: #ffedd5;
            font-size: 12px;
            font-weight: 800;
            white-space: nowrap;
        }

        .bd-detail {
            position: sticky;
            top: 12px;
        }

        .bd-selected-card {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 14px;
            border-bottom: 1px solid rgba(236, 72, 153, .16);
            background:
                linear-gradient(135deg, #fff7fb 0%, #fff7ed 100%);
        }

        .bd-selected-avatar {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 48px;
            height: 48px;
            border-radius: 8px;
            color: #fff;
            background: linear-gradient(135deg, #ec4899, #7c3aed);
            font-size: 17px;
            font-weight: 900;
            flex: 0 0 auto;
        }

        .bd-selected-name {
            margin: 0;
            color: var(--bd-text);
            font-size: 16px;
            font-weight: 900;
        }

        .bd-selected-meta {
            margin-top: 4px;
            color: var(--bd-muted);
            font-size: 12px;
            font-weight: 700;
        }

        .bd-party-note {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-top: 8px;
            padding: 6px 9px;
            border-radius: 999px;
            color: #9f1239;
            background: #ffe4e6;
            font-size: 11px;
            font-weight: 900;
            text-transform: uppercase;
            letter-spacing: .03em;
        }

        .bd-wish-box {
            padding: 14px;
            border-bottom: 1px solid rgba(236, 72, 153, .16);
            background: #fff7fb;
        }

        .bd-input-row {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 9px 10px;
            border: 1px solid rgba(236, 72, 153, .22);
            border-radius: 8px;
            background: #fff;
        }

        .bd-input-row i {
            color: var(--bd-rose);
        }

        .bd-input-row input {
            flex: 1;
            min-width: 0;
            border: 0;
            outline: 0;
            color: var(--bd-text);
            background: transparent;
            font-size: 14px;
        }

        .bd-messages {
            max-height: 520px;
            overflow-y: auto;
            padding: 14px;
            background: #fff;
        }

        .bd-message-list {
            display: grid;
            gap: 10px;
        }

        .bd-message-card {
            padding: 12px;
            border: 1px solid #fbcfe8;
            border-radius: 8px;
            background: linear-gradient(180deg, #ffffff 0%, #fff7fb 100%);
            box-shadow: 0 8px 18px rgba(236, 72, 153, .06);
        }

        .bd-message-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
            margin-bottom: 7px;
        }

        .bd-message-head strong {
            color: var(--bd-text);
            font-size: 13px;
            font-weight: 900;
        }

        .bd-message-head span {
            color: var(--bd-muted);
            font-size: 11px;
            font-weight: 700;
            white-space: nowrap;
        }

        .bd-message-text {
            margin: 0;
            color: #334155;
            font-size: 13px;
            font-weight: 600;
            line-height: 1.45;
            word-break: break-word;
        }

        .bd-empty {
            padding: 28px 16px;
            border: 1px dashed #cbd5e1;
            border-radius: 8px;
            color: #9f1239;
            background: #fff7fb;
            text-align: center;
            font-weight: 700;
        }

        .bd-empty i {
            display: block;
            margin-bottom: 10px;
            color: var(--bd-rose);
            font-size: 26px;
        }

        .swal2-container {
            z-index: 20000 !important;
        }

        @media (max-width: 1199px) {
            .bd-grid {
                grid-template-columns: 1fr;
            }

            .bd-detail {
                position: static;
            }
        }

        @media (max-width: 767px) {
            .birthday-page {
                padding-top: 8px;
            }

            .bd-hero-content,
            .bd-panel-head,
            .bd-summary-grid {
                display: flex;
                flex-direction: column;
                align-items: stretch;
            }

            .bd-tools,
            .bd-search {
                width: 100%;
            }

            .bd-input-row {
                align-items: stretch;
                flex-direction: column;
            }

            .bd-send-btn {
                width: 100%;
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            if (typeof Birthday_Init === "function") {
                Birthday_Init();
            }
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="bd-loader" id="load1">
        <div class="bd-loader-card">
            <img src="../images/Load_1.gif" alt="Loading" />
            <div>Loading birthdays</div>
        </div>
    </div>

    <div class="birthday-page">
        <section class="bd-hero">
            <div class="bd-hero-content">
                <div class="bd-title-wrap">
                    <span class="bd-title-icon"><i class="fas fa-birthday-cake"></i></span>
                    <div>
                        <h1>Birthday Celebration</h1>
                        <p>Find today's stars, send warm wishes, and keep the celebration glowing.</p>
                    </div>
                </div>
                <span class="bd-hero-chip"><i class="fas fa-gift"></i> Wish Wall</span>
            </div>
        </section>

        <section class="bd-summary-grid" aria-label="Birthday summary">
            <article class="bd-summary-card bd-summary-today">
                <i class="fas fa-birthday-cake"></i>
                <div>
                    <span>Today's Birthdays</span>
                    <strong id="bd_totalBirthdays">0</strong>
                </div>
            </article>
            <article class="bd-summary-card bd-summary-selected">
                <i class="fas fa-user-check"></i>
                <div>
                    <span>Selected</span>
                    <strong id="bd_selectedEmployee">None</strong>
                </div>
            </article>
            <article class="bd-summary-card bd-summary-messages">
                <i class="fas fa-envelope-open-text"></i>
                <div>
                    <span>Messages</span>
                    <strong id="bd_totalMessages">0</strong>
                </div>
            </article>
        </section>

        <section class="bd-grid">
            <div class="bd-panel">
                <div class="bd-panel-head">
                    <div class="bd-panel-title">
                        <h2><i class="fas fa-list"></i>&nbsp; Today's Birthday List</h2>
                        <span id="bd_recordCount">Loading records</span>
                    </div>
                    <div class="bd-tools">
                        <label class="bd-search" for="bd_tableSearch">
                            <i class="fas fa-search"></i>
                            <input type="search" id="bd_tableSearch" placeholder="Search birthdays" autocomplete="off" />
                        </label>
                        <button type="button" class="bd-action-btn" id="bd_btnRefresh">
                            <i class="fas fa-sync-alt"></i>
                            <span>Refresh</span>
                        </button>
                    </div>
                </div>

                <div class="bd-table-wrap table-responsive">
                    <table class="table table-hover nowrap" id="bdash_list">
                        <thead>
                            <tr>
                                <th class="text-center">Sr. #</th>
                                <th class="text-center">View</th>
                                <th style="display: none;">Employee ID</th>
                                <th>Code</th>
                                <th>Name</th>
                                <th>Date of Birth</th>
                                <th>Branch</th>
                                <th>Department</th>
                                <th>Designation</th>
                                <th>Reporting Manager</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>

            <aside class="bd-panel bd-detail">
                <div class="bd-selected-card">
                    <span class="bd-selected-avatar" id="bd_selectedAvatar">BD</span>
                    <div>
                        <h2 class="bd-selected-name" id="bd_selectedName">Select a birthday</h2>
                       <%-- <div class="bd-selected-meta" id="bd_selectedMeta">Messages will appear here.</div>--%>
                        <div class="bd-party-note"><i class="fas fa-star"></i> Make their day</div>
                    </div>
                </div>

                <div class="bd-wish-box">
                    <div class="bd-input-row">
                        <i class="fas fa-pen"></i>
                        <input type="text" id="txtWish" placeholder="Write your birthday wish here..." autocomplete="off" />
                        <button type="button" class="bd-send-btn" id="bd_btnSend">
                            <i class="fas fa-paper-plane"></i>
                            <span>Send</span>
                        </button>
                    </div>
                </div>

                <div id="dvMessages" class="bd-messages">
                    <div class="bd-empty">
                        <i class="fas fa-gift"></i>
                        Select an employee to view birthday wishes.
                    </div>
                </div>
            </aside>
        </section>
    </div>
</asp:Content>
