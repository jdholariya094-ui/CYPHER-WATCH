<%@ Page Title="Orders" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeBehind="Orders.aspx.cs" Inherits="CYPHER.Admin.Orders" %>

<asp:Content ID="PageTitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    Order Fulfillment & Logistics
</asp:Content>

<asp:Content ID="PageHeaderContent" ContentPlaceHolderID="PageHeaderContent" runat="server">
    <div class="d-flex align-items-center justify-content-between w-100">
        <div>
            <span>Order Fulfillment</span>
            <span class="badge ms-2" style="background: rgba(201,168,76,0.15); color: var(--admin-gold); font-size: 0.72rem;">
                <asp:Literal ID="litOrderCount" runat="server">0</asp:Literal> Orders Found
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

    <!-- ── ORDER DETAILS INSPECTION MODAL ── -->
    <asp:Panel ID="pnlOrderDetails" runat="server" Visible="false" CssClass="admin-modal-backdrop">
        <div class="admin-modal-dialog">
            <div class="admin-modal-header">
                <div class="admin-modal-title">
                    <i class="fas fa-file-invoice" style="color:var(--admin-gold);"></i>
                    <span>Order #<asp:Literal ID="litModalOrderID" runat="server" /> Details</span>
                </div>
                <asp:LinkButton ID="btnCloseModal" runat="server" OnClick="btnCloseModal_Click" CssClass="btn-admin-icon">
                    <i class="fas fa-times"></i>
                </asp:LinkButton>
            </div>

            <div class="admin-modal-body">
                <asp:HiddenField ID="hdnModalOrderID" runat="server" />

                <!-- Customer & Shipping Summary Grid -->
                <div class="admin-grid-2 mb-3">
                    <div class="p-3 rounded" style="background:#111; border:1px solid rgba(255,255,255,0.06);">
                        <div style="font-size:0.75rem; text-transform:uppercase; letter-spacing:1px; color:#888; margin-bottom:0.5rem;">
                            <i class="fas fa-user me-1 text-gold"></i> Customer Dossier
                        </div>
                        <div style="font-size:0.95rem; font-weight:600; color:#FFF;"><asp:Literal ID="litCustName" runat="server" /></div>
                        <div style="font-size:0.8rem; color:#AAA;"><i class="fas fa-envelope me-1"></i> <asp:Literal ID="litCustEmail" runat="server" /></div>
                        <div style="font-size:0.8rem; color:#AAA;"><i class="fas fa-phone me-1"></i> <asp:Literal ID="litCustPhone" runat="server" /></div>
                        <div style="font-size:0.75rem; color:#777; margin-top:0.25rem;">Placed on <asp:Literal ID="litOrderDate" runat="server" /></div>
                    </div>

                    <div class="p-3 rounded" style="background:#111; border:1px solid rgba(255,255,255,0.06);">
                        <div style="font-size:0.75rem; text-transform:uppercase; letter-spacing:1px; color:#888; margin-bottom:0.5rem;">
                            <i class="fas fa-map-marker-alt me-1 text-gold"></i> Delivery Destination
                        </div>
                        <div style="font-size:0.85rem; color:#DDD; line-height:1.4;">
                            <asp:Literal ID="litShippingAddress" runat="server" />
                        </div>
                    </div>
                </div>

                <!-- Order Items Table -->
                <div class="admin-table-card mt-0 mb-3">
                    <div class="admin-table-header py-2">
                        <span style="font-size:0.82rem; font-weight:600; color:#FFF;">Timepieces Ordered</span>
                    </div>
                    <div class="table-responsive">
                        <table class="admin-table">
                            <thead>
                                <tr>
                                    <th>Watch</th>
                                    <th>Unit Price</th>
                                    <th>Qty</th>
                                    <th style="text-align:right;">Subtotal</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="rptOrderItems" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <img src="<%# ResolveUrl(Eval("ImageURL") != DBNull.Value && !string.IsNullOrEmpty(Eval("ImageURL").ToString()) ? Eval("ImageURL").ToString() : "~/Content/images/watches/watch_hero.jpg") %>" class="admin-thumb" alt="Watch" />
                                                    <div>
                                                        <div style="font-weight:600; color:#FFF;"><%# Eval("ProductName") %></div>
                                                        <div style="font-size:0.7rem; color:#777;"><%# Eval("BrandName") %></div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>&#8377;<%# Convert.ToDecimal(Eval("UnitPrice")).ToString("N0") %></td>
                                            <td><span class="badge bg-secondary"><%# Eval("Quantity") %></span></td>
                                            <td style="text-align:right; font-weight:600; color:#FFF;">
                                                &#8377;<%# Convert.ToDecimal(Eval("TotalPrice")).ToString("N0") %>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Order Pricing Breakdown -->
                <div class="d-flex justify-content-end mb-4">
                    <div style="width: 280px; font-size: 0.85rem;">
                        <div class="d-flex justify-content-between py-1 text-muted">
                            <span>Subtotal:</span>
                            <span class="text-white">&#8377;<asp:Literal ID="litSubtotal" runat="server" /></span>
                        </div>
                        <div class="d-flex justify-content-between py-1 text-muted">
                            <span>Coupon Discount:</span>
                            <span class="text-success">-&#8377;<asp:Literal ID="litDiscount" runat="server" /></span>
                        </div>
                        <div class="d-flex justify-content-between py-1 text-muted">
                            <span>GST (18%):</span>
                            <span class="text-white">&#8377;<asp:Literal ID="litGST" runat="server" /></span>
                        </div>
                        <div class="d-flex justify-content-between py-1 text-muted">
                            <span>Insured Vault Shipping:</span>
                            <span class="text-white">&#8377;<asp:Literal ID="litShipping" runat="server" /></span>
                        </div>
                        <div class="d-flex justify-content-between py-2 border-top border-secondary border-opacity-50" style="font-size:1.1rem; font-weight:700; color:var(--admin-gold);">
                            <span>Grand Total:</span>
                            <span>&#8377;<asp:Literal ID="litGrandTotal" runat="server" /></span>
                        </div>
                    </div>
                </div>

                <!-- Interactive Fulfillment Update Form -->
                <div class="p-3 rounded admin-form" style="background:#111; border:1px solid rgba(201,168,76,0.25);">
                    <div style="font-size:0.8rem; font-weight:600; color:var(--admin-gold); text-transform:uppercase; letter-spacing:1px; margin-bottom:0.75rem;">
                        <i class="fas fa-shipping-fast me-1"></i> Dispatch & Logistics Control
                    </div>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label>Fulfillment Status</label>
                            <asp:DropDownList ID="ddlModalOrderStatus" runat="server" CssClass="form-select">
                                <asp:ListItem Value="Pending">Pending Dispatch</asp:ListItem>
                                <asp:ListItem Value="Processing">Processing / Vault Inspection</asp:ListItem>
                                <asp:ListItem Value="Shipped">Dispatched / In Transit</asp:ListItem>
                                <asp:ListItem Value="Delivered">Delivered & Signed</asp:ListItem>
                                <asp:ListItem Value="Cancelled">Cancelled</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-6">
                            <label>Payment Status</label>
                            <asp:DropDownList ID="ddlModalPaymentStatus" runat="server" CssClass="form-select">
                                <asp:ListItem Value="Pending">Pending</asp:ListItem>
                                <asp:ListItem Value="Completed">Completed / Cleared</asp:ListItem>
                                <asp:ListItem Value="Refunded">Refunded</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-6">
                            <label>Courier Tracking Number</label>
                            <asp:TextBox ID="txtModalTracking" runat="server" CssClass="form-control" placeholder="e.g. BLUEDART-84729103" />
                        </div>
                        <div class="col-md-6">
                            <label>Internal Logistics Notes</label>
                            <asp:TextBox ID="txtModalNotes" runat="server" CssClass="form-control" placeholder="Packaging verified, certificate attached..." />
                        </div>
                    </div>
                </div>
            </div>

            <div class="admin-modal-footer">
                <asp:Button ID="btnCloseModalBottom" runat="server" Text="Dismiss" OnClick="btnCloseModal_Click" CssClass="btn-admin-secondary" CausesValidation="false" />
                <asp:Button ID="btnUpdateOrder" runat="server" Text="Update Logistics Status" OnClick="btnUpdateOrder_Click" CssClass="btn-admin-primary" />
            </div>
        </div>
    </asp:Panel>

    <!-- ── SEARCH & FILTER TOOLBAR ── -->
    <div class="admin-toolbar">
        <div class="admin-toolbar-left">
            <div class="admin-input-group" style="min-width: 260px;">
                <i class="fas fa-search"></i>
                <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search by Order ID or Customer..." />
            </div>

            <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged" style="max-width:180px;">
                <asp:ListItem Value="">All Statuses</asp:ListItem>
                <asp:ListItem Value="Pending">Pending</asp:ListItem>
                <asp:ListItem Value="Processing">Processing</asp:ListItem>
                <asp:ListItem Value="Shipped">Shipped</asp:ListItem>
                <asp:ListItem Value="Delivered">Delivered</asp:ListItem>
                <asp:ListItem Value="Cancelled">Cancelled</asp:ListItem>
            </asp:DropDownList>

            <asp:Button ID="btnFilter" runat="server" Text="Filter" OnClick="btnFilter_Click" CssClass="btn-admin-outline" />
            <asp:Button ID="btnReset" runat="server" Text="Reset" OnClick="btnReset_Click" CssClass="btn-admin-secondary" />
        </div>
    </div>

    <!-- ── ORDERS DATA TABLE ── -->
    <div class="admin-table-card mt-0">
        <div class="table-responsive">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Order #</th>
                        <th>Customer</th>
                        <th>Order Date</th>
                        <th>Grand Total</th>
                        <th>Payment</th>
                        <th>Fulfillment Status</th>
                        <th>Tracking</th>
                        <th style="text-align:right;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptOrders" runat="server" OnItemCommand="rptOrders_ItemCommand">
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <div style="font-weight:700; color:var(--admin-gold); font-size:0.95rem;">
                                        #<%# Eval("OrderID") %>
                                    </div>
                                </td>
                                <td>
                                    <div style="font-weight:600; color:#FFF;"><%# Eval("FullName") %></div>
                                    <div style="font-size:0.75rem; color:#888;"><%# Eval("Email") %></div>
                                </td>
                                <td>
                                    <div style="color:#DDD; font-size:0.83rem;">
                                        <%# Convert.ToDateTime(Eval("OrderDate")).ToString("MMM dd, yyyy") %>
                                    </div>
                                    <div style="font-size:0.7rem; color:#666;">
                                        <%# Convert.ToDateTime(Eval("OrderDate")).ToString("hh:mm tt") %>
                                    </div>
                                </td>
                                <td>
                                    <div style="font-weight:700; color:#FFF; font-size:0.95rem;">
                                        &#8377;<%# Convert.ToDecimal(Eval("GrandTotal")).ToString("N0") %>
                                    </div>
                                    <div style="font-size:0.7rem; color:#888;">
                                        Coupon: <%# Eval("CouponCode") != DBNull.Value && !string.IsNullOrEmpty(Eval("CouponCode").ToString()) ? Eval("CouponCode") : "None" %>
                                    </div>
                                </td>
                                <td>
                                    <span class="badge bg-dark border border-secondary" style="font-size:0.75rem; color:#DDD;">
                                        <%# Eval("PaymentMethod") %>
                                    </span>
                                </td>
                                <td>
                                    <span class="status-badge <%# Eval("OrderStatus").ToString().ToLower() %>">
                                        <%# Eval("OrderStatus") %>
                                    </span>
                                </td>
                                <td>
                                    <div style="font-size:0.78rem; color:#AAA; font-family:monospace;">
                                        <%# Eval("TrackingNumber") != DBNull.Value && !string.IsNullOrEmpty(Eval("TrackingNumber").ToString()) ? Eval("TrackingNumber") : "<span style='color:#555;'>Unassigned</span>" %>
                                    </div>
                                </td>
                                <td style="text-align:right;">
                                    <asp:LinkButton ID="btnInspect" runat="server" CommandName="InspectOrder" CommandArgument='<%# Eval("OrderID") %>' CssClass="btn-admin-icon" ToolTip="Inspect Order & Dispatch">
                                        <i class="fas fa-eye"></i>
                                    </asp:LinkButton>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                    <% if (rptOrders.Items.Count == 0) { %>
                        <tr>
                            <td colspan="8" class="text-center py-5" style="color:#777;">
                                <i class="fas fa-shopping-bag fa-2x mb-2" style="color:var(--admin-gold); opacity:0.4;"></i><br />
                                No orders matching the criteria.
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</asp:Content>
