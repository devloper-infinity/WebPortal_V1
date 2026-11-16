<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="HRQuestionPaper.aspx.cs" Inherits="WebPortal.Admin.HRQuestionPaper" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root { --hr-blue:#2563eb; --hr-cyan:#22c1dc; --hr-ink:#0f172a; --hr-muted:#64748b; --hr-line:#dbe5f1; }
        .hr-test-page { min-height:calc(100vh - 118px); padding:18px 0 30px; background:#f4f7fb; }
        .hr-test-shell { width:100%; max-width:1180px; margin:auto; padding:0 15px; }

        .hr-test-hero { position:relative; overflow:hidden; display:flex; align-items:center; justify-content:space-between; gap:20px; padding:22px 26px; margin-bottom:20px; border-radius:20px; color:#fff; background:linear-gradient(120deg,#1d4ed8 0%,var(--hr-blue) 58%,var(--hr-cyan) 100%); box-shadow:0 16px 36px rgba(37,99,235,.24); }
        .hr-test-hero:before,.hr-test-hero:after { content:""; position:absolute; border-radius:50%; background:rgba(255,255,255,.13); }
        .hr-test-hero:before { top:-135px; right:-70px; width:310px; height:310px; }
        .hr-test-hero:after { bottom:-105px; left:38%; width:210px; height:210px; }
        .hr-test-hero-main,.hr-test-hero-badge { position:relative; z-index:1; }
        .hr-test-hero-main { display:flex; align-items:center; gap:16px; }
        .hr-test-hero-icon { width:60px; height:60px; min-width:60px; display:flex; align-items:center; justify-content:center; border:1px solid rgba(255,255,255,.28); border-radius:19px; background:rgba(255,255,255,.16); font-size:27px; }
        .hr-test-kicker { margin-bottom:4px; font-size:11px; font-weight:800; letter-spacing:1.8px; text-transform:uppercase; opacity:.9; }
        .hr-test-title { margin:0; color:#fff; font-size:24px; font-weight:800; line-height:1.2; }
        .hr-test-subtitle { margin:7px 0 0; color:rgba(255,255,255,.9); font-size:13px; }
        .hr-test-hero-badge { display:inline-flex; align-items:center; gap:8px; padding:9px 14px; border:1px solid rgba(255,255,255,.25); border-radius:999px; background:rgba(255,255,255,.16); font-size:12px; font-weight:700; white-space:nowrap; }

        .hr-test-panel { overflow:hidden; border:1px solid var(--hr-line); border-radius:20px; background:#fff; box-shadow:0 10px 30px rgba(15,23,42,.07); }
        .hr-test-panel-head { display:flex; align-items:center; justify-content:space-between; gap:16px; padding:17px 22px; border-bottom:1px solid #e8eef5; background:linear-gradient(180deg,#fff 0%,#f8fbff 100%); }
        .hr-test-panel-title { display:flex; align-items:center; gap:11px; margin:0; color:var(--hr-ink); font-size:16px; font-weight:800; }
        .hr-test-panel-title i { width:35px; height:35px; display:inline-flex; align-items:center; justify-content:center; border-radius:11px; color:#fff; background:linear-gradient(135deg,var(--hr-blue),var(--hr-cyan)); }
        .hr-test-note { display:inline-flex; align-items:center; gap:7px; margin:0; padding:7px 11px; border:1px solid #fed7aa; border-radius:9px; color:#9a3412; background:#fff7ed; font-size:12px; font-weight:700; }
        .hr-test-panel-body { padding:22px; }

        #dvhrinductiontest { display:grid; grid-template-columns:minmax(0,1fr); gap:14px; }
        #dvhrinductiontest > div { position:relative; width:auto!important; max-width:none!important; min-height:118px; padding:18px 20px 19px 58px!important; border:1px solid #e1e8f0; border-radius:16px; background:#fbfdff; transition:.2s ease; }
        #dvhrinductiontest > div:before { content:"?"; position:absolute; top:17px; left:17px; width:29px; height:29px; display:flex; align-items:center; justify-content:center; border-radius:9px; color:var(--hr-blue); background:#eaf2ff; font-size:13px; font-weight:900; }
        #dvhrinductiontest > div:hover,#dvhrinductiontest > div:focus-within { border-color:#bfdbfe; box-shadow:0 9px 22px rgba(37,99,235,.08); transform:translateY(-1px); }
        #dvhrinductiontest > div h6 { margin:0 0 14px!important; padding:2px 0 0!important; color:#1e293b!important; font-size:13px!important; font-weight:700; line-height:1.55; }
        #dvhrinductiontest > div select.form-control { width:100%!important; height:43px!important; margin:0!important; padding:8px 36px 8px 12px; border:1px solid #d5deea; border-radius:11px; color:#334155; background-color:#fff; box-shadow:none; font-size:13px; transition:.2s ease; }
        #dvhrinductiontest > div select.form-control:focus { border-color:var(--hr-blue); box-shadow:0 0 0 4px rgba(37,99,235,.10); }
        #hrinductiontest_btnsubmit { grid-column:1/-1; justify-self:end; min-width:145px; margin:4px 0 0!important; padding:11px 24px; border:0; border-radius:12px; color:#fff; background:linear-gradient(135deg,var(--hr-blue),var(--hr-cyan)); box-shadow:0 10px 22px rgba(37,99,235,.24); font-size:13px; font-weight:800; transition:.2s ease; }
        #hrinductiontest_btnsubmit:before { content:"\f1d8"; margin-right:8px; font-family:"Font Awesome 5 Free"; font-weight:900; }
        #hrinductiontest_btnsubmit:hover,#hrinductiontest_btnsubmit:focus { color:#fff; transform:translateY(-2px); box-shadow:0 14px 27px rgba(37,99,235,.3); }

        .loading { display:none; position:fixed; inset:0; z-index:99999; width:190px; height:165px; margin:auto; padding:24px 18px; border-radius:18px; color:#334155; background:rgba(255,255,255,.96); box-shadow:0 20px 48px rgba(15,23,42,.2); text-align:center; }
        .loading img { width:72px; height:72px; margin-bottom:8px; object-fit:contain; }
        #hrinductiontest_dverror .modal-content { overflow:hidden; border:0; border-radius:16px; box-shadow:0 20px 48px rgba(15,23,42,.2); }
        #hrinductiontest_dverror .modal-header { padding:22px 20px 12px; border-bottom:0; text-align:center; }
        #hrinductiontest_dverror .modal-title { width:100%; color:#334155; font-size:14px; font-weight:700; line-height:1.5; }
        #hrinductiontest_dverror .modal-footer { justify-content:center; padding:10px 20px 20px; border-top:0; }
        #hrinductiontest_btnMessage { min-width:105px; border:0; border-radius:10px; background:linear-gradient(135deg,var(--hr-blue),var(--hr-cyan)); font-weight:700; }
        #waitingpanel .modal-dialog { top:30%; }

        @media(max-width:767.98px) {
            .hr-test-page { padding-top:12px; } .hr-test-hero { align-items:flex-start; padding:19px; } .hr-test-hero-badge { display:none; }
            .hr-test-title { font-size:20px; } .hr-test-panel-head { align-items:flex-start; flex-direction:column; } .hr-test-panel-body { padding:15px; }
            #dvhrinductiontest { grid-template-columns:1fr; } #dvhrinductiontest > div { min-height:0; } #hrinductiontest_btnsubmit { width:100%; justify-self:stretch; }
        }
        @media(max-width:420px) { .hr-test-hero-icon { width:50px; height:50px; min-width:50px; border-radius:16px; } .hr-test-subtitle { display:none; } #dvhrinductiontest > div { padding:16px 15px 17px 51px!important; } }
    </style>
    <script>
        $(document).ready(function () { hrinductiontest_BindTest(); });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" alt="Loading" />
        <div style="font-size:12px;font-weight:bold;">Loading your test...</div>
    </div>

    <main class="hr-test-page">
        <div class="hr-test-shell">
            <section class="hr-test-hero">
                <div class="hr-test-hero-main">
                    <div class="hr-test-hero-icon"><i class="fas fa-clipboard-check"></i></div>
                    <div>
                        <div class="hr-test-kicker">Learning &amp; Development</div>
                        <h1 class="hr-test-title">HR Induction Test</h1>
                        <p class="hr-test-subtitle">Complete every question and submit your responses when you are ready.</p>
                    </div>
                </div>
                <div class="hr-test-hero-badge"><i class="fas fa-shield-alt"></i> Employee Assessment</div>
            </section>

            <section class="hr-test-panel">
                <div class="hr-test-panel-head">
                    <h2 class="hr-test-panel-title"><i class="fas fa-list-ol"></i> Assessment Questions</h2>
                    <p class="hr-test-note"><i class="fas fa-exclamation-circle"></i> Please do not refresh this page</p>
                </div>
                <div class="hr-test-panel-body"><div id="dvhrinductiontest"></div></div>
            </section>
        </div>
    </main>

    <div class="modal fade" id="hrinductiontest_dverror" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header"><h6 class="modal-title" id="hrinductiontest_errmsg"></h6></div>
                <div class="modal-footer"><button class="btn btn-primary" type="button" id="hrinductiontest_btnMessage" onclick="return hrinductiontest_Message();">Okay</button></div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="waitingpanel" tabindex="-1" data-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" alt="Submitting" /><br />
            <span style="color:#fff;font-size:24px;font-weight:bold;font-style:italic;" id="spntext">System is updating details. Please wait</span>
            <span style="color:#fff;font-size:48px;font-weight:bold;font-style:italic;animation:animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>
</asp:Content>
