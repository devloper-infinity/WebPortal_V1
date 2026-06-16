<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ViewLog.aspx.cs" Inherits="WebPortal.Admin.ViewLog" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .loading {
            display: none;
            position: fixed;
            top: 350px;
            left: 50%;
            margin-top: -96px;
            margin-left: -96px;
            /*  background-color: #ccc;*/
            opacity: .85;
            border-radius: 25px;
            width: 192px;
            height: 192px;
            z-index: 99999;
        }

        /*.form-control {
            font-size: 11px !important;
        }*/
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Employee Daily Log Details</b></h6>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right" style="font-size: 12px; font-weight: bold;">
                        <li class="breadcrumb-item"><a href="#utl" id="aBack" runat="server" style="color: saddlebrown" onclick="window.history.go(-1); return false;"><< Go back </a></li>

                    </ol>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <%--    <table class="table" style="margin-top: -20px;">
                    <tr>
                        <td><b>Code:</b>

                            <label id="lblcode1" name="lblcode1" runat="server" class="label-text"></label>
                        </td>
                        <td><b>Name:</b>
                            <label id="lblname1" name="lblname1" runat="server" class="label-text"></label>
                        </td>
                        <td><b>Pseudoname:</b>
                            <label id="lblPseudoname" name="lblPseudoname" runat="server" class="label-text"></label>
                        </td>
                        <td>
                            <span style="font-weight: bold; font-style: italic; text-decoration: underline;">
                                <a href="ProposedSalaryReport.aspx" id="aProposed" runat="server" style="color: saddlebrown">Proposed Salary Report</a>
                            </span>
                        </td>
                    </tr>
                </table>
                <table class="table" >
                    <tr>
                        <td><b>Month:</b>&nbsp;<asp:DropDownList ID="ddlMonth" Height="24px" runat="server" ValidationGroup="user" Width="100px">
                            <asp:ListItem Value="January">January</asp:ListItem>
                            <asp:ListItem Value="February">February</asp:ListItem>
                            <asp:ListItem Value="March">March</asp:ListItem>
                            <asp:ListItem Value="April">April</asp:ListItem>
                            <asp:ListItem Value="May">May</asp:ListItem>
                            <asp:ListItem Value="June">June</asp:ListItem>
                            <asp:ListItem Value="July">July</asp:ListItem>
                            <asp:ListItem Value="August">August</asp:ListItem>
                            <asp:ListItem Value="September">September</asp:ListItem>
                            <asp:ListItem Value="October">October</asp:ListItem>
                            <asp:ListItem Value="November">November</asp:ListItem>
                            <asp:ListItem Value="December">December</asp:ListItem>
                        </asp:DropDownList>&nbsp;&nbsp;&nbsp;<b>Year:</b>&nbsp;<asp:DropDownList ID="ddlYear" Height="24px" runat="server" ValidationGroup="user" Width="100px"></asp:DropDownList>
                            &nbsp;&nbsp;
                    <asp:Button ID="btnshow" CssClass="btn btn-primary" runat="server" style="padding:0px 10px;" Text="Show" OnClick="btnshow_Click" />&nbsp;&nbsp;
                        </td>
                    </tr>
                </table>--%>

                <%--   <div class="container-fluid">  </div>--%>

                <%--                <div class="row align-items-end g-3 p-3 shadow-sm"
                    style="background: #fff; border-radius: 8px;">

                    <!-- Code -->
                    <div class="col-md-2">
                        <label class="fw-bold mb-1">Code</label>
                        <input type="text" id="txtCode" runat="server" class="form-control" readonly />
                    </div>

                    <!-- Name -->
                    <div class="col-md-2">
                        <label class="fw-bold mb-1">Name</label>
                        <input type="text"
                            id="txtName"
                            runat="server"
                            class="form-control"
                            readonly />
                    </div>

                    <!-- Pseudoname -->
                    <div class="col-md-2">
                        <label class="fw-bold mb-1">Pseudoname</label>
                        <input type="text"
                            id="txtPseudoname"
                            runat="server"
                            class="form-control"
                            readonly />
                    </div>

                    <!-- Month -->
                    <div class="col-md-2">
                                              <label class="fw-bold mb-1">Month</label>
                        <asp:DropDownList ID="ddlMonth" runat="server" CssClass="form-control" ValidationGroup="user">
                            <asp:ListItem Value="January">January</asp:ListItem>
                            <asp:ListItem Value="February">February</asp:ListItem>
                            <asp:ListItem Value="March">March</asp:ListItem>
                            <asp:ListItem Value="April">April</asp:ListItem>
                            <asp:ListItem Value="May">May</asp:ListItem>
                            <asp:ListItem Value="June">June</asp:ListItem>
                            <asp:ListItem Value="July">July</asp:ListItem>
                            <asp:ListItem Value="August">August</asp:ListItem>
                            <asp:ListItem Value="September">September</asp:ListItem>
                            <asp:ListItem Value="October">October</asp:ListItem>
                            <asp:ListItem Value="November">November</asp:ListItem>
                            <asp:ListItem Value="December">December</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <!-- Year -->
                    <div class="col-md-2">
                        <label class="fw-bold mb-1">Year</label>
                        <asp:DropDownList ID="ddlYear" runat="server" CssClass="form-control" ValidationGroup="user"></asp:DropDownList>
                    </div>

                    <!-- Show Button -->
                    <div class="col-md-1">
                        <asp:Button ID="btnshow"
                            runat="server"
                            Text="Show"
                            CssClass="btn btn-primary w-100"
                            OnClick="btnshow_Click" />
                    </div>

                    <!-- Report Link -->
                    <div class="col-md-2">
                        <a href="ProposedSalaryReport.aspx" id="aProposed" runat="server" style="color: saddlebrown">Proposed Salary Report</a>

                    </div>

                </div>--%>

                <div class="row align-items-end g-2 p-3 shadow-sm flex-nowrap overflow-auto"
                    style="background: #fff; border-radius: 12px;">

                    <!-- Common Width -->
                    <style>
                        .same-width {
                            width: 160px;
                        }
                    </style>

                    <!-- Code -->
                    <div class="col-auto">
                        <label class="fw-bold mb-1" style="color: #6c757d;"><b>Code</b></label>
                        <input type="text" id="txtCode" runat="server" class="form-control same-width" disabled style="background-color: white;" />
                    </div>

                    <!-- Name -->
                    <div class="col-auto">
                        <label class="fw-bold mb-1" style="color: #6c757d;"><b>Name</b></label>
                        <input type="text" id="txtName" runat="server" class="form-control same-width" readonly  style="background-color: white;" />
                    </div>

                    <!-- Pseudoname -->
                    <div class="col-auto">
                        <label class="fw-bold mb-1" style="color: #6c757d;"><b>Pseudo Name</b></label>
                        <input type="text" id="txtPseudoname" runat="server" class="form-control same-width" readonly  style="background-color: white;" />
                    </div>

                    <!-- Month -->
                    <div class="col-auto">
                        <label class="fw-bold mb-1" style="color: #6c757d;"><b>Month</b></label>
                        <asp:DropDownList ID="ddlMonth" runat="server" CssClass="form-control same-width" ValidationGroup="user">
                            <asp:ListItem Value="January">January</asp:ListItem>
                            <asp:ListItem Value="February">February</asp:ListItem>
                            <asp:ListItem Value="March">March</asp:ListItem>
                            <asp:ListItem Value="April">April</asp:ListItem>
                            <asp:ListItem Value="May">May</asp:ListItem>
                            <asp:ListItem Value="June">June</asp:ListItem>
                            <asp:ListItem Value="July">July</asp:ListItem>
                            <asp:ListItem Value="August">August</asp:ListItem>
                            <asp:ListItem Value="September">September</asp:ListItem>
                            <asp:ListItem Value="October">October</asp:ListItem>
                            <asp:ListItem Value="November">November</asp:ListItem>
                            <asp:ListItem Value="December">December</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <!-- Year -->
                    <div class="col-auto">
                        <label class="fw-bold mb-1" style="color: #6c757d;"><b>Year</b></label>
                        <asp:DropDownList ID="ddlYear" runat="server" CssClass="form-control same-width" ValidationGroup="user"></asp:DropDownList>
                    </div>

                    <!-- Show Button -->
                    <div class="col-auto">
                        <asp:Button ID="btnshow" runat="server" Text="Show" CssClass="btn btn-primary same-width" OnClick="btnshow_Click" />
                    </div>

                    <!-- Report Link -->
                    <div class="col-auto">
                        <a href="ProposedSalaryReport.aspx" id="aProposed" runat="server"
                            class="btn btn-secondary same-width">Proposed Salary</a>
                        <%-- <a href="ProposedSalaryReport.aspx" id="aProposed" runat="server" style="color: saddlebrown">Proposed Salary Report</a>--%>
                    </div>

                </div>

            </div>
            <div class="card-body">
                <div class="table-list" id="advanceAjaxTable">
                    <div class="table-responsive">
                        <asp:GridView ID="grdLog" runat="server" HeaderStyle-BackColor="WhiteSmoke" EmptyDataText="No data available in table" AutoGenerateColumns="false" CssClass="table table-bordered table-striped table-sm mb-0 align-content-center">
                            <Columns>
                                <asp:BoundField DataField="Date" HeaderText="Date" />
                                <asp:BoundField DataField="InTime" HeaderText="In Time" />
                                <asp:BoundField DataField="OutTime" HeaderText="Out Time" />
                                <asp:BoundField DataField="ShiftTime" HeaderText="Hours" />
                                <asp:BoundField DataField="BreakOutTime" HeaderText="Break Out" />
                                <asp:BoundField DataField="BreakInTime" HeaderText="Break In" />
                                <asp:BoundField DataField="TotalBreakHours" HeaderText="Break Time" />
                                <asp:BoundField DataField="Hours" HeaderText="Total Hours" />
                                <asp:BoundField DataField="ExtraHours" HeaderText="Extra Hours" />
                                <asp:BoundField DataField="NoofHours" HeaderText="Deducted Hours" />
                                <asp:BoundField DataField="LateMark" HeaderText="Late mark" />
                                <asp:BoundField DataField="Partial" HeaderText="Partial" />
                                <asp:BoundField DataField="ShiftRemark" HeaderText="Shift Remark" />
                                <asp:BoundField DataField="LeaveType" HeaderText="Day Status" />
                                <asp:BoundField DataField="INIP" HeaderText="In IP" />
                                <asp:BoundField DataField="OutIP" HeaderText="Out IP" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
