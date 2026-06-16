<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="GroupMaster.aspx.cs" Inherits="WebPortal.Admin.GroupMaster" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid mt-3">

    <h4><b>Manage Groups</b></h4>

    <div class="row">

        <!-- LEFT: GROUP FORM -->
        <div class="col-md-4">
            <div class="card">
                <div class="card-header bg-info text-white">
                    <b id="formTitle">Add / Edit Group</b>
                </div>

                <div class="card-body">
                    
                    <asp:HiddenField ID="hfGroupId" runat="server" />

                    <label>Group Name</label>
                    <asp:TextBox ID="txtGroupName" runat="server" CssClass="form-control"></asp:TextBox>

                    <label class="mt-2">Description</label>
                    <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control"
                        TextMode="MultiLine" Rows="3"></asp:TextBox>

                    <div class="form-check mt-2">
                        <asp:CheckBox ID="chkActive" runat="server" CssClass="form-check-input" Checked="true" />
                        <label class="form-check-label">Active</label>
                    </div>

                    <asp:Button ID="btnSave" runat="server" Text="Save Group"
                        CssClass="btn btn-success mt-3"
                        OnClick="btnSave_Click" />

                    <asp:Button ID="btnNew" runat="server" Text="New"
                        CssClass="btn btn-secondary mt-3 ml-2"
                        OnClick="btnNew_Click" />

                </div>
            </div>
        </div>

        <!-- RIGHT: GROUP LIST -->
        <div class="col-md-8">
            <div class="card">
                <div class="card-header bg-secondary text-white">
                    <b>Existing Groups</b>
                </div>

                <div class="card-body">

                    <asp:GridView ID="gvGroups" runat="server" CssClass="table table-bordered"
                        AutoGenerateColumns="False" OnRowCommand="gvGroups_RowCommand">

                        <Columns>
                            <asp:BoundField DataField="GroupId" HeaderText="ID" />
                            <asp:BoundField DataField="GroupName" HeaderText="Group Name" />
                            <asp:BoundField DataField="Description" HeaderText="Description" />
                            <asp:BoundField DataField="IsActive" HeaderText="Active" />

                            <asp:TemplateField HeaderText="Action">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lnkEdit" runat="server" 
                                        Text="Edit" CommandName="editGroup"
                                        CommandArgument='<%# Eval("GroupId") %>' CssClass="btn btn-sm btn-info" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>

                    </asp:GridView>

                </div>
            </div>
        </div>

    </div>

</div>
</asp:Content>
