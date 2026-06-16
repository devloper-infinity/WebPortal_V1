<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="FlowCharts.aspx.cs" Inherits="WebPortal.Admin.FlowCharts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
</asp:Content>
