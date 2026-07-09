<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="FlowCharts.aspx.cs" Inherits="WebPortal.Admin.FlowCharts" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .fc-page {
            background: #f5f8fc;
        }

        .fc-hero {
            position: relative;
            overflow: hidden;
            border-radius: 22px;
            padding: 26px 28px;
            margin-bottom: 22px;
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%);
            box-shadow: 0 16px 36px rgba(37, 99, 235, .22);
        }

        .fc-hero:before,
        .fc-hero:after {
            content: "";
            position: absolute;
            border-radius: 999px;
            background: rgba(255, 255, 255, .16);
        }

        .fc-hero:before {
            width: 190px;
            height: 190px;
            right: -45px;
            top: -75px;
        }

        .fc-hero:after {
            width: 110px;
            height: 110px;
            right: 145px;
            bottom: -55px;
        }

        .fc-hero-content {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            gap: 18px;
        }

        .fc-hero-icon {
            width: 66px;
            height: 66px;
            flex: 0 0 66px;
            border-radius: 20px;
            background: rgba(255, 255, 255, .18);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 30px;
            box-shadow: inset 0 0 0 1px rgba(255, 255, 255, .25);
        }

        .fc-hero h4 {
            margin: 0;
            font-size: 23px;
            font-weight: 800;
            letter-spacing: .2px;
        }

        .fc-hero p {
            margin: 6px 0 0;
            color: rgba(255, 255, 255, .86);
            font-size: 14px;
        }

        .fc-main-card {
            background: #fff;
            border: 1px solid #e8eef7;
            border-radius: 22px;
            box-shadow: 0 12px 30px rgba(15, 23, 42, .08);
            overflow: hidden;
        }

        .fc-toolbar {
            padding: 22px;
            border-bottom: 1px solid #edf2f7;
            background: linear-gradient(180deg, #ffffff 0%, #f9fbff 100%);
        }

        .fc-filter-grid {
            display: grid;
            grid-template-columns: minmax(240px, 360px) 1fr;
            gap: 18px;
            align-items: end;
        }

        .fc-field label {
            display: block;
            margin-bottom: 8px;
            color: #334155;
            font-size: 13px;
            font-weight: 800;
        }

        .fc-field label i {
            color: #2563eb;
            margin-right: 7px;
        }

        .fc-select {
            width: 100% !important;
            height: 44px;
            border: 1px solid #d9e3f0;
            border-radius: 13px;
            color: #0f172a;
            font-weight: 600;
            box-shadow: none;
            transition: all .25s ease;
        }

        .fc-select:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, .12);
        }

        .fc-help-box {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 13px 15px;
            border-radius: 14px;
            background: #eff6ff;
            color: #1e3a8a;
            font-size: 13px;
            font-weight: 600;
        }

        .fc-help-box i {
            font-size: 20px;
            color: #2563eb;
        }

        .fc-quick-cards {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 15px;
            padding: 20px 22px 0;
        }

        .fc-process-card {
            border: 1px solid #e6edf7;
            border-radius: 18px;
            padding: 17px;
            background: #fff;
            display: flex;
            align-items: center;
            gap: 13px;
            cursor: pointer;
            transition: all .25s ease;
        }

        .fc-process-card:hover {
            transform: translateY(-4px);
            border-color: #bfdbfe;
            box-shadow: 0 14px 26px rgba(37, 99, 235, .14);
        }

        .fc-process-icon {
            width: 48px;
            height: 48px;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 20px;
            background: linear-gradient(135deg, #2563eb, #22c1dc);
        }

        .fc-process-card h6 {
            margin: 0;
            font-size: 14px;
            font-weight: 800;
            color: #0f172a;
        }

        .fc-process-card span {
            display: block;
            margin-top: 4px;
            color: #64748b;
            font-size: 12px;
            font-weight: 600;
        }

        .fc-view-area {
            padding: 22px;
        }

        .fc-empty-state {
            min-height: 300px;
            border: 2px dashed #dbe7f5;
            border-radius: 22px;
            background: linear-gradient(180deg, #fbfdff 0%, #f7fbff 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            color: #64748b;
        }

        .fc-empty-state i {
            display: block;
            margin-bottom: 16px;
            color: #2563eb;
            font-size: 54px;
            animation: fcFloat 2.2s ease-in-out infinite;
        }

        @keyframes fcFloat {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-8px); }
        }

        .fc-chart-panel {
            display: none;
            animation: fcFadeUp .35s ease both;
        }

        @keyframes fcFadeUp {
            from { opacity: 0; transform: translateY(12px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .fc-panel-title {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 18px;
            padding-bottom: 14px;
            border-bottom: 1px solid #edf2f7;
        }

        .fc-panel-title h5 {
            margin: 0;
            color: #0f172a;
            font-size: 18px;
            font-weight: 850;
        }

        .fc-panel-title h5 i {
            color: #2563eb;
            margin-right: 8px;
        }

        .fc-badge {
            padding: 7px 12px;
            border-radius: 999px;
            background: #e0f2fe;
            color: #0369a1;
            font-size: 12px;
            font-weight: 800;
        }

        .fc-image-wrap {
            width: 100%;
            padding: 18px;
            border-radius: 18px;
            background: #f8fbff;
            border: 1px solid #e5edf7;
            text-align: center;
            overflow-x: auto;
        }

        .fc-image-wrap img {
            max-width: 100%;
            height: auto;
            border-radius: 14px;
            background: #fff;
            box-shadow: 0 10px 24px rgba(15, 23, 42, .08);
        }

        .fc-image-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 18px;
        }

        @media (max-width: 991px) {
            .fc-filter-grid,
            .fc-quick-cards,
            .fc-image-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 576px) {
            .fc-hero { padding: 22px 18px; }
            .fc-hero-content { align-items: flex-start; }
            .fc-hero-icon { width: 54px; height: 54px; flex-basis: 54px; font-size: 24px; }
            .fc-hero h4 { font-size: 19px; }
            .fc-toolbar, .fc-view-area { padding: 16px; }
            .fc-quick-cards { padding: 16px 16px 0; }
        }
    </style>

    <script>
        function flowchart_hideall() {
            document.getElementById('dvRecruitement').style.display = 'none';
            document.getElementById('dvJoining').style.display = 'none';
            document.getElementById('dvExit').style.display = 'none';

            var emptyState = document.getElementById('dvFlowchartEmpty');
            if (emptyState) {
                emptyState.style.display = '';
            }
        }

        function flowchart_getflowcharts(ddl) {
            flowchart_hideall();

            var selectedValue = ddl.value;
            var emptyState = document.getElementById('dvFlowchartEmpty');

            if (selectedValue === 'Recruitment') {
                document.getElementById('dvRecruitement').style.display = 'block';
                if (emptyState) emptyState.style.display = 'none';
            }
            else if (selectedValue === 'Joining') {
                document.getElementById('dvJoining').style.display = 'block';
                if (emptyState) emptyState.style.display = 'none';
            }
            else if (selectedValue === 'Exit') {
                document.getElementById('dvExit').style.display = 'block';
                if (emptyState) emptyState.style.display = 'none';
            }

            return false;
        }

        function flowchart_selecttype(type) {
            var ddl = document.getElementById('flowchart_type');
            ddl.value = type;
            flowchart_getflowcharts(ddl);
            return false;
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="fc-page">
        <div class="container-fluid">

            <div class="fc-hero">
                <div class="fc-hero-content">
                    <div class="fc-hero-icon">
                        <i class="fas fa-project-diagram"></i>
                    </div>
                    <div>
                        <h4>HR Process Flow Charts</h4>
                        <p>View recruitment, joining and exit process flow charts in one clean responsive workspace.</p>
                    </div>
                </div>
            </div>

            <div class="fc-main-card">
                <div class="fc-toolbar">
                    <div class="fc-filter-grid">
                        <div class="fc-field">
                            <label for="flowchart_type"><i class="fas fa-sitemap"></i>Flow Chart Type</label>
                            <select id="flowchart_type" name="flowchart_type" class="form-control fc-select" onchange="return flowchart_getflowcharts(this);">
                                <option value="">Select Flow Chart</option>
                                <option value="Recruitment">Recruitment</option>
                                <option value="Joining">Joining</option>
                                <option value="Exit">Exit</option>
                            </select>
                        </div>

                        <div class="fc-help-box">
                            <i class="fas fa-info-circle"></i>
                            <span>Select a process from the dropdown or use the quick cards below to open the flow chart.</span>
                        </div>
                    </div>
                </div>

                <div class="fc-quick-cards">
                    <div class="fc-process-card" onclick="return flowchart_selecttype('Recruitment');">
                        <div class="fc-process-icon"><i class="fas fa-user-plus"></i></div>
                        <div>
                            <h6>Recruitment</h6>
                            <span>Candidate selection process</span>
                        </div>
                    </div>

                    <div class="fc-process-card" onclick="return flowchart_selecttype('Joining');">
                        <div class="fc-process-icon"><i class="fas fa-user-check"></i></div>
                        <div>
                            <h6>Joining</h6>
                            <span>Employee onboarding process</span>
                        </div>
                    </div>

                    <div class="fc-process-card" onclick="return flowchart_selecttype('Exit');">
                        <div class="fc-process-icon"><i class="fas fa-sign-out-alt"></i></div>
                        <div>
                            <h6>Exit</h6>
                            <span>Separation approval process</span>
                        </div>
                    </div>
                </div>

                <div class="fc-view-area">
                    <div id="dvFlowchartEmpty" class="fc-empty-state">
                        <div>
                            <i class="fas fa-route"></i>
                            <h5><b>Select Flow Chart</b></h5>
                            <p class="mb-0">Your selected HR process flow chart will appear here.</p>
                        </div>
                    </div>

                    <div id="dvRecruitement" class="fc-chart-panel">
                        <div class="fc-panel-title">
                            <h5><i class="fas fa-user-plus"></i>Recruitment Flow Chart</h5>
                            <span class="fc-badge">Recruitment</span>
                        </div>
                        <div class="fc-image-wrap">
                            <img src="../Images/Recruitment.png" alt="Recruitment Flow Chart" />
                        </div>
                    </div>

                    <div id="dvJoining" class="fc-chart-panel">
                        <div class="fc-panel-title">
                            <h5><i class="fas fa-user-check"></i>Joining Flow Chart</h5>
                            <span class="fc-badge">Joining</span>
                        </div>
                        <div class="fc-image-grid">
                            <div class="fc-image-wrap">
                                <img src="../Images/Joining1.png" alt="Joining Flow Chart Part 1" />
                            </div>
                            <div class="fc-image-wrap">
                                <img src="../Images/Joining2.png" alt="Joining Flow Chart Part 2" />
                            </div>
                        </div>
                    </div>

                    <div id="dvExit" class="fc-chart-panel">
                        <div class="fc-panel-title">
                            <h5><i class="fas fa-sign-out-alt"></i>Exit Flow Chart</h5>
                            <span class="fc-badge">Exit</span>
                        </div>
                        <div class="fc-image-grid">
                            <div class="fc-image-wrap">
                                <img src="../Images/Exit1.png" alt="Exit Flow Chart Part 1" />
                            </div>
                            <div class="fc-image-wrap">
                                <img src="../Images/Exit2.png" alt="Exit Flow Chart Part 2" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</asp:Content>


<%--<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        function flowchart_getflowcharts(ddl) {

            var index = ddl.selectedIndex;
            if (index == 1) {
                dvRecruitement.style.display = '';
                dvJoining.style.display = 'none';
                dvExit.style.display = 'none';
            }
            else if (index == 2) {
                dvRecruitement.style.display = 'none';
                dvJoining.style.display = '';
                dvExit.style.display = 'none';
            }
            else if (index == 3) {
                dvRecruitement.style.display = 'none';
                dvJoining.style.display = 'none';
                dvExit.style.display = '';
            }
            else {
                dvRecruitement.style.display = 'none';
                dvJoining.style.display = 'none';
                dvExit.style.display = 'none';
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>HR Process Flow Charts</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <h5 class="card-title"></h5>

                <table class="table">
                    <tr>
                        <td width="100px"><b>Flow Chart Type:</b></td>
                        <td width="250px">
                            <select id="flowchart_type" name="flowchart_type" class="form-control" style="width: 200px" onchange="return flowchart_getflowcharts(this);">
                                <option value="">Select</option>
                                <option value="Recruitment">Recruitment</option>
                                <option value="Joining">Joining</option>
                                <option value="Exit">Exit</option>
                            </select>
                        </td>

                    </tr>
                </table>
                <hr />
                <div id="dvRecruitement" style="display: none; text-align: center;">
                    <h2><span style="text-decoration: underline; font-style: italic;">RECRUITMENT FLOW CHART
                    </span></h2>
                    <br />
                    <img src="../Images/Recruitment.png" />
                </div>
                <div id="dvJoining" style="display: none; text-align: left;">
                    <h2><span style="text-decoration: underline; font-style: italic;">JOINING FLOW CHART
                    </span></h2>
                    <br />
                    <table style="width: 100%;" class="table">
                        <tr>
                            <td>
                                <img src="../Images/Joining1.png" width="450" /></td>
                            <td align="left" style="text-align: left;">
                                <img src="../Images/Joining2.png" width="580" /></td>
                        </tr>
                    </table>


                </div>
                <div id="dvExit" style="display: none; text-align: left;">
                    <h2><span style="text-decoration: underline; font-style: italic;">EXIT FLOW CHART
                    </span></h2>
                    <br />
                    <table style="width: 100%;" class="table">
                        <tr>
                            <td>
                                <img src="../Images/Exit1.png" width="450" /></td>
                            <td align="left" style="text-align: left;">
                                <img src="../Images/Exit2.png" width="580" /></td>
                        </tr>
                    </table>

                </div>
            </div>
        </div>
    </div>
</asp:Content>--%>
