<%@ Page Title="Categories" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeBehind="Categories.aspx.cs" Inherits="CYPHER.Admin.Categories" %>

<asp:Content ID="PageTitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    Categories Architecture
</asp:Content>

<asp:Content ID="PageHeaderContent" ContentPlaceHolderID="PageHeaderContent" runat="server">
    <div class="d-flex align-items-center justify-content-between w-100">
        <div>
            <span>Categories Architecture</span>
            <span class="badge ms-2" style="background: rgba(201,168,76,0.15); color: var(--admin-gold); font-size: 0.72rem;">
                <asp:Literal ID="litCount" runat="server">0</asp:Literal> Collections
            </span>
        </div>
    </div>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Alert Panel -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false">
        <div class="admin-alert <%= AlertCssClass %>">
            <i class="fas <%= AlertIconClass %>"></i>
            <div><asp:Label ID="lblAlert" runat="server" /></div>
        </div>
    </asp:Panel>

    <!-- ── ADD / EDIT CATEGORY FORM ── -->
    <asp:Panel ID="pnlEditCategory" runat="server" Visible="false" CssClass="admin-form-card mb-4">
        <div class="d-flex align-items-center justify-content-between mb-4 pb-2 border-bottom border-secondary border-opacity-25">
            <h4 style="font-family:'Cormorant Garamond',serif; color:var(--admin-gold); font-size:1.5rem; margin:0;">
                <asp:Literal ID="litFormTitle" runat="server">Add Category</asp:Literal>
            </h4>
            <asp:LinkButton ID="btnCloseForm" runat="server" OnClick="btnCloseForm_Click" CssClass="btn-admin-icon">
                <i class="fas fa-times"></i>
            </asp:LinkButton>
        </div>

        <asp:HiddenField ID="hdnCategoryID" runat="server" Value="0" />

        <div class="admin-form">
            <div class="row g-3">
                <div class="col-md-6">
                    <label>Category Name *</label>
                    <asp:TextBox ID="txtCategoryName" runat="server" CssClass="form-control" placeholder="e.g. Chronograph, Diving, Haute Horlogerie" required="required" />
                </div>

                <div class="col-md-6">
                    <label>Representative Image URL</label>
                    <asp:TextBox ID="txtImageURL" runat="server" CssClass="form-control" placeholder="/Content/images/watches/watch_luxury_gold.jpg" />
                </div>

                <div class="col-12">
                    <label>Description & Scope</label>
                    <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control" placeholder="Brief summary of timepieces under this category..." />
                </div>

                <div class="col-12">
                    <label class="d-flex align-items-center gap-2" style="cursor:pointer; text-transform:none; color:#DDD;">
                        <asp:CheckBox ID="chkIsActive" runat="server" Checked="true" />
                        <span>Category is Active & Visible</span>
                    </label>
                </div>

                <div class="col-12 d-flex justify-content-end gap-2 pt-2 border-top border-secondary border-opacity-25">
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCloseForm_Click" CssClass="btn-admin-secondary" CausesValidation="false" />
                    <asp:Button ID="btnSaveCategory" runat="server" Text="Save Category" OnClick="btnSaveCategory_Click" CssClass="btn-admin-primary" />
                </div>
            </div>
        </div>
    </asp:Panel>

    <!-- Toolbar -->
    <div class="admin-toolbar">
        <div class="admin-table-title d-flex align-items-center gap-2">
            <i class="fas fa-layer-group" style="color:var(--admin-gold);"></i>
            Watch Classification Categories
        </div>
        <div>
            <asp:LinkButton ID="btnShowAdd" runat="server" OnClick="btnShowAdd_Click" CssClass="btn-admin-primary">
                <i class="fas fa-plus-circle"></i> Add Category
            </asp:LinkButton>
        </div>
    </div>

    <!-- Categories Table -->
    <div class="admin-table-card mt-0">
        <div class="table-responsive">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th style="width: 70px;">Image</th>
                        <th>Category Name</th>
                        <th>Description</th>
                        <th>Assigned Watches</th>
                        <th>Status</th>
                        <th style="text-align:right;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptCategories" runat="server" OnItemCommand="rptCategories_ItemCommand">
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <img src="<%# ResolveUrl(Eval("ImageURL") != DBNull.Value && !string.IsNullOrEmpty(Eval("ImageURL").ToString()) ? Eval("ImageURL").ToString() : "~/Content/images/watches/watch_hero.jpg") %>" class="admin-thumb" alt="Category" />
                                </td>
                                <td>
                                    <div style="font-weight:600; color:#FFF; font-size:0.95rem;">
                                        <%# Eval("CategoryName") %>
                                    </div>
                                    <div style="font-size:0.72rem; color:#888;">ID: #<%# Eval("CategoryID") %></div>
                                </td>
                                <td style="color:#AAA; max-width:320px; font-size:0.83rem;">
                                    <%# Eval("Description") %>
                                </td>
                                <td>
                                    <a href="Products.aspx?cat=<%# Eval("CategoryID") %>" class="badge" style="background:rgba(201,168,76,0.15); color:var(--admin-gold); text-decoration:none;">
                                        <i class="fas fa-clock me-1"></i><%# Eval("ProductCount") %> Timepieces
                                    </a>
                                </td>
                                <td>
                                    <span class="status-badge <%# Convert.ToBoolean(Eval("IsActive")) ? "active" : "inactive" %>">
                                        <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Archived" %>
                                    </span>
                                </td>
                                <td style="text-align:right;">
                                    <div class="d-flex justify-content-end gap-1">
                                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditCat" CommandArgument='<%# Eval("CategoryID") %>' CssClass="btn-admin-icon" ToolTip="Edit Category">
                                            <i class="fas fa-edit"></i>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnToggle" runat="server" CommandName="ToggleActive" CommandArgument='<%# Eval("CategoryID") %>' CssClass="btn-admin-icon" ToolTip="Toggle Status">
                                            <i class="fas <%# Convert.ToBoolean(Eval("IsActive")) ? "fa-eye-slash" : "fa-eye" %>"></i>
                                        </asp:LinkButton>
                                    </div>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                    <% if (rptCategories.Items.Count == 0) { %>
                        <tr>
                            <td colspan="6" class="text-center py-4" style="color:#777;">
                                No categories defined yet.
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</asp:Content>
