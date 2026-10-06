<%@ Page Title="Reviews Moderation" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeBehind="Reviews.aspx.cs" Inherits="CYPHER.Admin.Reviews" %>

<asp:Content ID="PageTitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    Customer Reviews Moderation
</asp:Content>

<asp:Content ID="PageHeaderContent" ContentPlaceHolderID="PageHeaderContent" runat="server">
    <div class="d-flex align-items-center justify-content-between w-100">
        <div>
            <span>Customer Reviews Moderation</span>
            <span class="badge ms-2" style="background: rgba(201,168,76,0.15); color: var(--admin-gold); font-size: 0.72rem;">
                <asp:Literal ID="litReviewCount" runat="server">0</asp:Literal> Reviews
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

    <!-- Toolbar & Filter Tabs -->
    <div class="admin-toolbar">
        <div class="admin-toolbar-left">
            <asp:DropDownList ID="ddlReviewFilter" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged" style="max-width:200px;">
                <asp:ListItem Value="pending" Selected="True">Pending Moderation</asp:ListItem>
                <asp:ListItem Value="approved">Approved & Published</asp:ListItem>
                <asp:ListItem Value="all">All Reviews</asp:ListItem>
            </asp:DropDownList>
        </div>
    </div>

    <!-- Reviews Table -->
    <div class="admin-table-card mt-0">
        <div class="table-responsive">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th style="width: 70px;">Watch</th>
                        <th>Product</th>
                        <th>Reviewer</th>
                        <th>Rating</th>
                        <th>Review Text</th>
                        <th>Submitted On</th>
                        <th>Status</th>
                        <th style="text-align:right;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptReviews" runat="server" OnItemCommand="rptReviews_ItemCommand">
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <img src="<%# ResolveUrl(Eval("ImageURL") != DBNull.Value && !string.IsNullOrEmpty(Eval("ImageURL").ToString()) ? Eval("ImageURL").ToString() : "~/Content/images/watches/watch_hero.jpg") %>" class="admin-thumb" alt="Watch" />
                                </td>
                                <td>
                                    <div style="font-weight:600; color:#FFF; font-size:0.9rem;"><%# Eval("ProductName") %></div>
                                    <div style="font-size:0.72rem; color:#888;">Review #<%# Eval("ReviewID") %></div>
                                </td>
                                <td style="color:#DDD;"><%# Eval("FullName") %></td>
                                <td>
                                    <span style="color:#f1c40f; font-size:0.9rem;">
                                        <%# GetStars(Convert.ToInt32(Eval("Rating"))) %>
                                    </span>
                                </td>
                                <td style="max-width:320px; color:#AAA; font-size:0.83rem;">
                                    "<%# Eval("ReviewText") %>"
                                </td>
                                <td>
                                    <div style="font-size:0.8rem; color:#777;">
                                        <%# Convert.ToDateTime(Eval("CreatedDate")).ToString("MMM dd, yyyy") %>
                                    </div>
                                </td>
                                <td>
                                    <span class="status-badge <%# Convert.ToBoolean(Eval("IsApproved")) ? "active" : "pending" %>">
                                        <%# Convert.ToBoolean(Eval("IsApproved")) ? "Approved" : "Pending" %>
                                    </span>
                                </td>
                                <td style="text-align:right;">
                                    <div class="d-flex justify-content-end gap-1">
                                        <asp:LinkButton ID="btnApprove" runat="server" CommandName="Approve" CommandArgument='<%# Eval("ReviewID") %>' Visible='<%# !Convert.ToBoolean(Eval("IsApproved")) %>' CssClass="btn-admin-icon success" ToolTip="Approve Review">
                                            <i class="fas fa-check"></i>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnRevoke" runat="server" CommandName="Revoke" CommandArgument='<%# Eval("ReviewID") %>' Visible='<%# Convert.ToBoolean(Eval("IsApproved")) %>' CssClass="btn-admin-icon" ToolTip="Revoke Approval">
                                            <i class="fas fa-ban"></i>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteReview" CommandArgument='<%# Eval("ReviewID") %>' CssClass="btn-admin-icon danger" ToolTip="Delete Review" OnClientClick="return confirm('Delete this review permanently?');">
                                            <i class="fas fa-trash"></i>
                                        </asp:LinkButton>
                                    </div>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                    <% if (rptReviews.Items.Count == 0) { %>
                        <tr>
                            <td colspan="8" class="text-center py-5" style="color:#777;">
                                <i class="fas fa-star fa-2x mb-2" style="color:var(--admin-gold); opacity:0.4;"></i><br />
                                No reviews matching current filter.
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</asp:Content>
