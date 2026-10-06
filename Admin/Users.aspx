<%@ Page Title="Customers" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeBehind="Users.aspx.cs" Inherits="CYPHER.Admin.Users" %>

<asp:Content ID="PageTitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    Customer Accounts & Profiles
</asp:Content>

<asp:Content ID="PageHeaderContent" ContentPlaceHolderID="PageHeaderContent" runat="server">
    <div class="d-flex align-items-center justify-content-between w-100">
        <div>
            <span>Customer Dossiers</span>
            <span class="badge ms-2" style="background: rgba(201,168,76,0.15); color: var(--admin-gold); font-size: 0.72rem;">
                <asp:Literal ID="litCount" runat="server">0</asp:Literal> Clients
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

    <!-- Toolbar -->
    <div class="admin-toolbar">
        <div class="admin-toolbar-left">
            <div class="admin-input-group" style="min-width: 280px;">
                <i class="fas fa-search"></i>
                <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search by name, email, or city..." />
            </div>
            <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" CssClass="btn-admin-outline" />
            <asp:Button ID="btnReset" runat="server" Text="Reset" OnClick="btnReset_Click" CssClass="btn-admin-secondary" />
        </div>
    </div>

    <!-- Users Table -->
    <div class="admin-table-card mt-0">
        <div class="table-responsive">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Customer</th>
                        <th>Contact Information</th>
                        <th>Location</th>
                        <th>Acquisitions & Spend</th>
                        <th>Registered On</th>
                        <th>Account Status</th>
                        <th style="text-align:right;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptUsers" runat="server" OnItemCommand="rptUsers_ItemCommand">
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="admin-avatar" style="width:32px; height:32px; font-size:0.8rem;">
                                            <%# Eval("FullName").ToString().Substring(0, 1).ToUpper() %>
                                        </div>
                                        <div>
                                            <div style="font-weight:600; color:#FFF;"><%# Eval("FullName") %></div>
                                            <div style="font-size:0.72rem; color:#888;">Client ID: #<%# Eval("UserID") %></div>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div style="color:#DDD; font-size:0.82rem;"><i class="fas fa-envelope text-secondary me-1"></i> <%# Eval("Email") %></div>
                                    <div style="color:#888; font-size:0.75rem;"><i class="fas fa-phone text-secondary me-1"></i> <%# Eval("Phone") != DBNull.Value && !string.IsNullOrEmpty(Eval("Phone").ToString()) ? Eval("Phone") : "No phone" %></div>
                                </td>
                                <td>
                                    <div style="font-size:0.82rem; color:#DDD;"><%# Eval("City") != DBNull.Value ? Eval("City") : "-" %>, <%# Eval("State") != DBNull.Value ? Eval("State") : "" %></div>
                                    <div style="font-size:0.72rem; color:#777;"><%# Eval("Country") %></div>
                                </td>
                                <td>
                                    <a href="Orders.aspx?search=<%# Eval("Email") %>" class="badge" style="background:rgba(201,168,76,0.12); color:var(--admin-gold); text-decoration:none;">
                                        <%# Eval("OrderCount") %> Orders
                                    </a>
                                    <div style="font-size:0.75rem; color:#AAA; margin-top:2px;">
                                        Total: &#8377;<%# Convert.ToDecimal(Eval("TotalSpent")).ToString("N0") %>
                                    </div>
                                </td>
                                <td>
                                    <div style="font-size:0.8rem; color:#AAA;">
                                        <%# Convert.ToDateTime(Eval("CreatedAt")).ToString("MMM dd, yyyy") %>
                                    </div>
                                </td>
                                <td>
                                    <span class="status-badge <%# Convert.ToBoolean(Eval("IsActive")) ? "active" : "inactive" %>">
                                        <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Suspended" %>
                                    </span>
                                </td>
                                <td style="text-align:right;">
                                    <asp:LinkButton ID="btnToggle" runat="server" CommandName="ToggleActive" CommandArgument='<%# Eval("UserID") %>' CssClass="btn-admin-icon" ToolTip="Toggle User Status" OnClientClick="return confirm('Toggle client active account status?');">
                                        <i class="fas <%# Convert.ToBoolean(Eval("IsActive")) ? "fa-user-slash text-danger" : "fa-user-check text-success" %>"></i>
                                    </asp:LinkButton>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                    <% if (rptUsers.Items.Count == 0) { %>
                        <tr>
                            <td colspan="7" class="text-center py-5" style="color:#777;">
                                <i class="fas fa-users fa-2x mb-2" style="color:var(--admin-gold); opacity:0.4;"></i><br />
                                No registered clients matching query.
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</asp:Content>
