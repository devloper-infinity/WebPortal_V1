<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="PageAllocation.aspx.cs" Inherits="WebPortal.Admin.PageAllocation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        // Select All
        function toggleAll(cb) {
            document.querySelectorAll("input.child-check").forEach(x => x.checked = cb.checked);
            document.querySelectorAll(".parent-checkbox").forEach(x => x.checked = cb.checked);
            document.querySelectorAll(".section-checkbox").forEach(x => x.checked = cb.checked);
        }

        // Section toggle
        function toggleSection(cb) {
            let card = cb.closest(".card");
            card.querySelectorAll(".child-check").forEach(x => x.checked = cb.checked);
            card.querySelectorAll(".section-checkbox").forEach(x => x.checked = cb.checked);
        }

        // Subsection toggle
        function toggleChildSection(cb) {
            let section = cb.closest(".col-md-12");
            section.querySelectorAll(".child-check").forEach(x => x.checked = cb.checked);
        }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid mt-3">

        <div class="row">

            <!-- LEFT PANEL: USER LIST -->
            <div class="col-md-3">
                <h5><b>Users</b></h5>
                <asp:ListBox ID="lstUsers" runat="server" CssClass="form-control" AutoPostBack="true"
                    OnSelectedIndexChanged="lstUsers_SelectedIndexChanged" Height="500px"></asp:ListBox>
            </div>

            <!-- RIGHT PANEL: MENU RIGHTS -->
            <div class="col-md-9">
                <h5><b>Menu Rights</b></h5>

                <!-- Select All -->
                <div class="form-check mb-2">
                    <input type="checkbox" class="form-check-input" id="chkAll" onclick="toggleAll(this)">
                    <label class="form-check-label" for="chkAll">Select All</label>
                </div>

                <!-- MENU TREE -->
                <asp:Repeater ID="rptMenus" runat="server">
                    <ItemTemplate>

                        <div class="card mb-2">
                            <div class="card-header bg-info text-black">
                                <b><%# Eval("MenuName") %></b>

                                <input type="checkbox"
                                    class="float-right parent-checkbox"
                                    data-id='<%# Eval("MenuId") %>'
                                    onclick="toggleSection(this)" />
                            </div>

                            <div class="card-body">

                                <asp:Repeater ID="rptSub" runat="server" DataSource='<%# Eval("Sections") %>'>
                                    <ItemTemplate>

                                        <h6 class="text-primary"><%# Eval("SectionName") %></h6>

                                        <asp:Repeater ID="rptItems" runat="server" DataSource='<%# Eval("Items") %>'>
                                            <ItemTemplate>
                                                <div class="form-check ml-4">
                                                    <asp:CheckBox ID="chkRight" runat="server" CssClass="d-none" />

                                                    <!-- MENU ID -->
                                                    <asp:HiddenField ID="hfMenuId" runat="server" Value='<%# Eval("MenuId") %>' />
                                                    <input type="checkbox"
                                                        class="form-check-input child-check"
                                                        name="rights"
                                                        value='<%# Eval("MenuId") %>' />

                                                    <label class="form-check-label"><%# Eval("MenuName") %></label>
                                                </div>
                                            </ItemTemplate>
                                        </asp:Repeater>

                                    </ItemTemplate>
                                </asp:Repeater>

                            </div>
                        </div>

                    </ItemTemplate>
                </asp:Repeater>

                <asp:Button ID="btnSave" runat="server" CssClass="btn btn-success mt-2"
                    Text="Save Rights" OnClick="btnSave_Click" />
            </div>
        </div>

    </div>
    <script>
        // sync server checkbox (chkRight) to HTML checkbox
        $(document).ready(function () {
            $("input[id*='chkRight']").each(function () {
                var isChecked = $(this).prop("checked");
                $(this).closest(".form-check").find("input[name='rights']").prop("checked", isChecked);
            });
        });
    </script>
</asp:Content>
