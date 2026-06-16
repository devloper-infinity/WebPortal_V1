<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AssignGroupMenus.aspx.cs" Inherits="WebPortal.Admin.AssignGroupMenus" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        function toggleSectionItems(cb) {
            let sectionDiv = cb.closest(".mb-3");
            sectionDiv.querySelectorAll("input[name='menus']")
                .forEach(x => x.checked = cb.checked);
        }
        function toggleTopMenu(cb) {
            let card = cb.closest(".card");
            card.querySelectorAll("input[name='menus']").forEach(x => x.checked = cb.checked);
        }

        function loadSelectedMenus() {

            let selected = JSON.parse($("#<%= hfSelectedMenus.ClientID %>").val() || "[]");
            console.log("Selected:", selected);
            $("input[name='menus']").each(function () {
                let id = parseInt($(this).val());
                if (selected.includes(id)) {
                    $(this).prop("checked", true);
                }
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hfSelectedMenus" runat="server" />
    <div class="container-fluid mt-3">

        <h4><b>Assign Menus to Group</b></h4>

        <!-- Select Group -->
        <div class="row mb-3">
            <div class="col-md-4">
                <label>Select Group</label>
                <asp:DropDownList ID="ddlGroups" runat="server" CssClass="form-control"
                    AutoPostBack="true" OnSelectedIndexChanged="ddlGroups_SelectedIndexChanged">
                </asp:DropDownList>
            </div>
        </div>

        <!-- Menu Tree -->
        <asp:Repeater ID="rptMenus" runat="server">
            <itemtemplate>
                <div class="card mb-3">
                <div class="card-header bg-info text-white">
                    <b><%# Eval("MenuName") %></b>

                    <!-- Top menu select all -->
                    <input type="checkbox" class="float-right"
                           onclick="toggleTopMenu(this)"
                           style="transform: scale(1.3);" />
                </div>
                
                    <div class="card-body">

                        <!-- Sections -->
                        <asp:Repeater ID="rptSub" runat="server" DataSource='<%# Eval("Sections") %>'>
                            <itemtemplate>

                                <div class="mb-3">
                                    <h6 class="text-primary">
    <b><%# Eval("SectionName") %></b>

    <!-- Section Select All -->
    <input type="checkbox"
           class="float-right section-select-all"
           onclick="toggleSectionItems(this)"
           style="transform: scale(1.2);" />
</h6>

                                    <!-- Menu Items -->
                                    <asp:Repeater ID="rptItems" runat="server" DataSource='<%# Eval("Items") %>'>
                                        <itemtemplate>
                                            <div class="form-check ml-4">

                                                <!-- hidden MenuId -->
                                                <asp:HiddenField ID="hfMenuId" runat="server" Value='<%# Eval("MenuId") %>' />

                                                <!-- checkbox -->
                                                <input type="checkbox" class="form-check-input" name="menus" value="<%# Eval("MenuId") %>" id="chkMenu" />

                                                <label class="form-check-label">
                                                    <%# Eval("MenuName") %>
                                                </label>

                                            </div>
                                        </itemtemplate>
                                    </asp:Repeater>

                                </div>

                            </itemtemplate>
                        </asp:Repeater>

                    </div>
                </div>

            </itemtemplate>
        </asp:Repeater>

        <asp:Button ID="btnSave" runat="server" Text="Save Group Menus"
            CssClass="btn btn-success" OnClick="btnSave_Click" />

    </div>
</asp:Content>
