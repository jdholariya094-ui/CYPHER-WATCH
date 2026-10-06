<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="CYPHER.Admin.Dashboard" %>

<asp:Content ID="PageTitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    Executive Dashboard
</asp:Content>

<asp:Content ID="PageHeaderContent" ContentPlaceHolderID="PageHeaderContent" runat="server">
    <div class="d-flex align-items-center gap-2">
        <span>Executive Dashboard</span>
        <span class="badge" style="background: rgba(201,168,76,0.15); color: var(--admin-gold); font-size: 0.72rem; font-weight: normal;">Live System</span>
    </div>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <!-- ── STAT CARDS GRID ── -->
    <div class="admin-grid-4">
        <!-- Revenue -->
        <div class="admin-stat-card">
            <div class="stat-icon gold">
                <i class="fas fa-coins"></i>
            </div>
            <div class="stat-info">
                <div class="stat-val">&#8377;<asp:Literal ID="litRevenue" runat="server">0</asp:Literal></div>
                <div class="stat-lbl">Total Net Revenue</div>
            </div>
        </div>

        <!-- Orders -->
        <div class="admin-stat-card">
            <div class="stat-icon blue">
                <i class="fas fa-shopping-bag"></i>
            </div>
            <div class="stat-info">
                <div class="stat-val"><asp:Literal ID="litOrders" runat="server">0</asp:Literal></div>
                <div class="stat-lbl">Total Orders Placed</div>
            </div>
        </div>

        <!-- Products -->
        <div class="admin-stat-card">
            <div class="stat-icon green">
                <i class="fas fa-clock"></i>
            </div>
            <div class="stat-info">
                <div class="stat-val"><asp:Literal ID="litProducts" runat="server">0</asp:Literal></div>
                <div class="stat-lbl">Active Timepieces</div>
            </div>
        </div>

        <!-- Customers -->
        <div class="admin-stat-card">
            <div class="stat-icon purple">
                <i class="fas fa-users"></i>
            </div>
            <div class="stat-info">
                <div class="stat-val"><asp:Literal ID="litUsers" runat="server">0</asp:Literal></div>
                <div class="stat-lbl">Registered Customers</div>
            </div>
        </div>
    </div>

    <!-- ── ATTENTION ALERTS BAR ── -->
    <div class="row g-3 mb-4">
        <% if (PendingOrdersCount > 0) { %>
        <div class="col-md-4">
            <a href="Orders.aspx?status=Pending" class="d-flex align-items-center justify-content-between p-3 rounded" style="background: rgba(241,196,15,0.08); border: 1px solid rgba(241,196,15,0.25); color: #f1c40f; text-decoration:none;">
                <div class="d-flex align-items-center gap-2">
                    <i class="fas fa-exclamation-circle fa-lg"></i>
                    <div>
                        <strong><%= PendingOrdersCount %> Pending Orders</strong>
                        <div style="font-size:0.75rem; color:#AAA;">Require processing and dispatch</div>
                    </div>
                </div>
                <i class="fas fa-chevron-right"></i>
            </a>
        </div>
        <% } %>

        <% if (LowStockCount > 0) { %>
        <div class="col-md-4">
            <a href="Products.aspx?stock=low" class="d-flex align-items-center justify-content-between p-3 rounded" style="background: rgba(231,76,60,0.08); border: 1px solid rgba(231,76,60,0.25); color: #e74c3c; text-decoration:none;">
                <div class="d-flex align-items-center gap-2">
                    <i class="fas fa-box-open fa-lg"></i>
                    <div>
                        <strong><%= LowStockCount %> Low-Stock Watches</strong>
                        <div style="font-size:0.75rem; color:#AAA;">Inventory &#8804; 5 units remaining</div>
                    </div>
                </div>
                <i class="fas fa-chevron-right"></i>
            </a>
        </div>
        <% } %>

        <% if (PendingReviewsCount > 0) { %>
        <div class="col-md-4">
            <a href="Reviews.aspx" class="d-flex align-items-center justify-content-between p-3 rounded" style="background: rgba(52,152,219,0.08); border: 1px solid rgba(52,152,219,0.25); color: #3498db; text-decoration:none;">
                <div class="d-flex align-items-center gap-2">
                    <i class="fas fa-star-half-alt fa-lg"></i>
                    <div>
                        <strong><%= PendingReviewsCount %> Reviews Awaiting Moderation</strong>
                        <div style="font-size:0.75rem; color:#AAA;">Approve customer testimonials</div>
                    </div>
                </div>
                <i class="fas fa-chevron-right"></i>
            </a>
        </div>
        <% } %>
    </div>

    <!-- ── MAIN SPLIT: RECENT ORDERS & QUICK ACTIONS ── -->
    <div class="row g-4 mb-4">
        <!-- Recent Orders (Left 8 Cols) -->
        <div class="col-lg-8">
            <div class="admin-table-card mt-0 h-100">
                <div class="admin-table-header">
                    <div class="admin-table-title d-flex align-items-center gap-2">
                        <i class="fas fa-receipt" style="color:var(--admin-gold);"></i>
                        Recent Customer Orders
                    </div>
                    <a href="Orders.aspx" class="btn-admin-outline" style="padding: 0.3rem 0.75rem; font-size: 0.75rem;">
                        View All Orders <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>

                <div class="table-responsive">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>Order #</th>
                                <th>Customer</th>
                                <th>Date</th>
                                <th>Grand Total</th>
                                <th>Payment</th>
                                <th>Status</th>
                                <th style="text-align:right;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptRecentOrders" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td style="font-weight:600; color:var(--admin-gold);">
                                            #<%# Eval("OrderID") %>
                                        </td>
                                        <td>
                                            <div style="font-weight:500; color:#FFF;"><%# Eval("FullName") %></div>
                                            <div style="font-size:0.72rem; color:#777;"><%# Eval("Email") %></div>
                                        </td>
                                        <td><%# Convert.ToDateTime(Eval("OrderDate")).ToString("MMM dd, yyyy") %></td>
                                        <td style="font-weight:600; color:#FFF;">
                                            &#8377;<%# Convert.ToDecimal(Eval("GrandTotal")).ToString("N0") %>
                                        </td>
                                        <td>
                                            <span style="font-size:0.75rem; color:#AAA;"><%# Eval("PaymentMethod") %></span>
                                        </td>
                                        <td>
                                            <span class="status-badge <%# Eval("OrderStatus").ToString().ToLower() %>">
                                                <%# Eval("OrderStatus") %>
                                            </span>
                                        </td>
                                        <td style="text-align:right;">
                                            <a href="Orders.aspx?view=<%# Eval("OrderID") %>" class="btn-admin-icon" title="Inspect Order">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                            <% if (rptRecentOrders.Items.Count == 0) { %>
                                <tr>
                                    <td colspan="7" class="text-center py-4" style="color:#777;">
                                        No customer orders recorded yet.
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Quick Actions & Catalog Highlights (Right 4 Cols) -->
        <div class="col-lg-4">
            <!-- Quick Actions Card -->
            <div class="admin-form-card mb-4">
                <div class="admin-table-title mb-3 d-flex align-items-center gap-2">
                    <i class="fas fa-bolt" style="color:var(--admin-gold);"></i>
                    Quick Operations
                </div>
                <div class="d-grid gap-2">
                    <a href="Products.aspx" class="btn-admin-primary justify-content-center">
                        <i class="fas fa-plus-circle"></i> Add New Timepiece
                    </a>
                    <a href="Coupons.aspx" class="btn-admin-outline justify-content-center">
                        <i class="fas fa-tag"></i> Create Discount Coupon
                    </a>
                    <a href="Reports.aspx" class="btn-admin-secondary justify-content-center">
                        <i class="fas fa-file-invoice-dollar"></i> Generate Sales Report
                    </a>
                    <a href="<%= ResolveUrl("~/Pages/Home.aspx") %>" target="_blank" class="btn-admin-secondary justify-content-center">
                        <i class="fas fa-external-link-alt"></i> Preview Storefront
                    </a>
                </div>
            </div>

            <!-- Low Stock Mini List -->
            <div class="admin-table-card mt-0">
                <div class="admin-table-header">
                    <div class="admin-table-title d-flex align-items-center gap-2" style="font-size:0.88rem;">
                        <i class="fas fa-exclamation-triangle" style="color:#e74c3c;"></i>
                        Low Stock Alert
                    </div>
                    <a href="Products.aspx?stock=low" style="font-size:0.75rem; color:#888;">Manage</a>
                </div>
                <div class="p-2">
                    <asp:Repeater ID="rptLowStock" runat="server">
                        <ItemTemplate>
                            <div class="d-flex align-items-center justify-content-between p-2 border-bottom border-secondary border-opacity-10">
                                <div class="d-flex align-items-center gap-2">
                                    <img src="<%# ResolveUrl(Eval("ImageURL") != DBNull.Value && !string.IsNullOrEmpty(Eval("ImageURL").ToString()) ? Eval("ImageURL").ToString() : "~/Content/images/watches/watch_hero.jpg") %>" class="admin-thumb" alt="Watch" />
                                    <div>
                                        <div style="font-size:0.8rem; font-weight:500; color:#FFF; max-width:140px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">
                                            <%# Eval("ProductName") %>
                                        </div>
                                        <div style="font-size:0.7rem; color:#777;"><%# Eval("BrandName") %></div>
                                    </div>
                                </div>
                                <span class="stock-badge <%# Convert.ToInt32(Eval("StockQuantity")) == 0 ? "out-stock" : "low-stock" %>">
                                    <%# Eval("StockQuantity") %> left
                                </span>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <% if (rptLowStock.Items.Count == 0) { %>
                        <div class="text-center py-3" style="font-size:0.8rem; color:#777;">
                            <i class="fas fa-check-circle text-success mb-1"></i><br />
                            All timepiece stock levels healthy!
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>

    <!-- ── SECOND ROW: PENDING REVIEWS MODERATION ── -->
    <div class="admin-table-card">
        <div class="admin-table-header">
            <div class="admin-table-title d-flex align-items-center gap-2">
                <i class="fas fa-comments" style="color:var(--admin-gold);"></i>
                Pending Customer Reviews (Moderation Queue)
            </div>
            <a href="Reviews.aspx" class="btn-admin-outline" style="padding: 0.3rem 0.75rem; font-size: 0.75rem;">
                All Reviews
            </a>
        </div>

        <div class="table-responsive">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Watch</th>
                        <th>Reviewer</th>
                        <th>Rating</th>
                        <th>Feedback</th>
                        <th>Date</th>
                        <th style="text-align:right;">Moderation</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptPendingReviews" runat="server" OnItemCommand="rptPendingReviews_ItemCommand">
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <img src="<%# ResolveUrl(Eval("ImageURL") != DBNull.Value && !string.IsNullOrEmpty(Eval("ImageURL").ToString()) ? Eval("ImageURL").ToString() : "~/Content/images/watches/watch_hero.jpg") %>" class="admin-thumb" alt="Watch" />
                                        <div style="font-weight:500; color:#FFF;"><%# Eval("ProductName") %></div>
                                    </div>
                                </td>
                                <td style="color:#DDD;"><%# Eval("FullName") %></td>
                                <td>
                                    <span style="color:#f1c40f; font-size:0.85rem;">
                                        <%# GetStars(Convert.ToInt32(Eval("Rating"))) %>
                                    </span>
                                </td>
                                <td style="max-width:300px; color:#AAA; font-size:0.82rem;">
                                    "<%# Eval("ReviewText") %>"
                                </td>
                                <td style="font-size:0.75rem; color:#777;">
                                    <%# Convert.ToDateTime(Eval("CreatedAt")).ToString("MMM dd, yyyy") %>
                                </td>
                                <td style="text-align:right;">
                                    <div class="d-flex justify-content-end gap-1">
                                        <asp:LinkButton ID="btnApprove" runat="server" CommandName="Approve" CommandArgument='<%# Eval("ReviewID") %>' CssClass="btn-admin-icon success" ToolTip="Approve Review">
                                            <i class="fas fa-check"></i>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnReject" runat="server" CommandName="Reject" CommandArgument='<%# Eval("ReviewID") %>' CssClass="btn-admin-icon danger" ToolTip="Delete Review" OnClientClick="return confirm('Reject and delete this review?');">
                                            <i class="fas fa-trash"></i>
                                        </asp:LinkButton>
                                    </div>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                    <% if (rptPendingReviews.Items.Count == 0) { %>
                        <tr>
                            <td colspan="6" class="text-center py-4" style="color:#777;">
                                <i class="fas fa-check-circle text-success me-2"></i>No customer reviews pending moderation.
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</asp:Content>
