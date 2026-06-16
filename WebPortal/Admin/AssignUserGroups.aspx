<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AssignUserGroups.aspx.cs" Inherits="WebPortal.Admin.AssignUserGroups" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid mt-3">

    <h4><b>Assign Groups to User</b></h4>

    <div class="row">
        
        <!-- User List -->
        <div class="col-md-4">
            <label><b>Users</b></label>
            <asp:ListBox ID="lstUsers" runat="server" CssClass="form-control"
                AutoPostBack="true" OnSelectedIndexChanged="lstUsers_SelectedIndexChanged"
                Height="450px">
            </asp:ListBox>
        </div>

        <!-- Groups -->
        <div class="col-md-8">
            <label><b>Groups</b></label>
            <asp:CheckBoxList ID="cblGroups" runat="server"
                RepeatColumns="2" CssClass="mt-2">
            </asp:CheckBoxList>

            <asp:Button ID="btnSave" runat="server" Text="Save User Groups"
                CssClass="btn btn-success mt-3" OnClick="btnSave_Click" />
        </div>

    </div>
</div>
</asp:Content>
