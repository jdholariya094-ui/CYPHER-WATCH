<%@ Page Title="Sales Reports" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeBehind="Reports.aspx.cs" Inherits="CYPHER.Admin.Reports" %>

<asp:Content ID="PageTitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    Financial & Sales Analytics
</asp:Content>

<asp:Content ID="PageHeaderContent" ContentPlaceHolderID="PageHeaderContent" runat="server">
    <div class="d-flex align-items-center justify-content-between w-100">
        <div>
            <span>Executive Sales Analytics</span>
            <span class="badge ms-2" style="background: rgba(201,168,76,0.15); color: var(--admin-gold); font-size: 0.72rem;">
                Audited Financial Reports
            </span>
        </div>
        <button type="button" class="btn-admin-outline" onclick="window.print()">
            <i class="fas fa-print me-1"></i> Print / Export Statement
        </button>
    </div>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <!-- ── DATE RANGE FILTER TOOLBAR ── -->
    <div class="admin-toolbar">
        <div class="admin-toolbar-left align-items-center">
            <span style="font-size:0.8rem; text-transform:uppercase; color:#888; font-weight:600;">Timeframe:</span>
            
            <div class="d-flex align-items-center gap-2">
                <asp:TextBox ID="txtFromDate" runat="server" CssClass="form-control" TextMode="Date" style="max-width:160px;" />
                <span style="color:#777;">to</span>
                <asp:TextBox ID="txtToDate" runat="server" CssClass="form-control" TextMode="Date" style="max-width:160px;" />
            </div>

            <asp:Button ID="btnGenerate" runat="server" Text="Analyze Period" OnClick="btnGenerate_Click" CssClass="btn-admin-primary" />
            
            <div class="d-flex gap-1 ms-2">
                <asp:Button ID="btnLast7" runat="server" Text="Last 7 Days" OnClick="btnPreset_Click" CommandArgument="7" CssClass="btn btn-sm btn-outline-secondary" style="font-size:0.75rem;" />
                <asp:Button ID="btnLast30" runat="server" Text="Last 30 Days" OnClick="btnPreset_Click" CommandArgument="30" CssClass="btn btn-sm btn-outline-secondary" style="font-size:0.75rem;" />
                <asp:Button ID="btnLast90" runat="server" Text="Last 90 Days" OnClick="btnPreset_Click" CommandArgument="90" CssClass="btn btn-sm btn-outline-secondary" style="font-size:0.75rem;" />
                <asp:Button ID="btnAllTime" runat="server" Text="All Time" OnClick="btnPreset_Click" CommandArgument="365" CssClass="btn btn-sm btn-outline-secondary" style="font-size:0.75rem;" />
            </div>
        </div>
    </div>

    <!-- ── EXECUTIVE SUMMARY CARDS ── -->
    <div class="admin-grid-4">
        <!-- Period Revenue -->
        <div class="admin-stat-card">
            <div class="stat-icon gold">
                <i class="fas fa-coins"></i>
            </div>
            <div class="stat-info">
                <div class="stat-val">&#8377;<asp:Literal ID="litPeriodRevenue" runat="server">0</asp:Literal></div>
                <div class="stat-lbl">Period Net Revenue</div>
            </div>
        </div>

        <!-- Period Orders -->
        <div class="admin-stat-card">
            <div class="stat-icon blue">
                <i class="fas fa-shopping-bag"></i>
            </div>
            <div class="stat-info">
                <div class="stat-val"><asp:Literal ID="litPeriodOrders" runat="server">0</asp:Literal></div>
                <div class="stat-lbl">Orders in Scope</div>
            </div>
        </div>

        <!-- AOV -->
        <div class="admin-stat-card">
            <div class="stat-icon green">
                <i class="fas fa-calculator"></i>
            </div>
            <div class="stat-info">
                <div class="stat-val">&#8377;<asp:Literal ID="litAOV" runat="server">0</asp:Literal></div>
                <div class="stat-lbl">Avg Order Value (AOV)</div>
            </div>
        </div>

        <!-- Days Active -->
        <div class="admin-stat-card">
            <div class="stat-icon purple">
                <i class="fas fa-calendar-check"></i>
            </div>
            <div class="stat-info">
                <div class="stat-val"><asp:Literal ID="litSalesDays" runat="server">0</asp:Literal></div>
                <div class="stat-lbl">Trading Days Logged</div>
            </div>
        </div>
    </div>

    <!-- ── SECOND ROW: TOP WATCHES & STATUS BREAKDOWN ── -->
    <div class="row g-4 mb-4">
        <!-- Top Selling Watches -->
        <div class="col-lg-7">
            <div class="admin-table-card mt-0 h-100">
                <div class="admin-table-header">
                    <div class="admin-table-title d-flex align-items-center gap-2">
                        <i class="fas fa-trophy" style="color:var(--admin-gold);"></i>
                        Top Selling Timepieces
                    </div>
                </div>
                <div class="table-responsive">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>Watch</th>
                                <th>Maison</th>
                                <th>Units Sold</th>
                                <th style="text-align:right;">Sales Revenue</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptTopSelling" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <img src="<%# ResolveUrl(Eval("ImageURL") != DBNull.Value && !string.IsNullOrEmpty(Eval("ImageURL").ToString()) ? Eval("ImageURL").ToString() : "~/Content/images/watches/watch_hero.jpg") %>" class="admin-thumb" alt="Watch" />
                                                <div style="font-weight:600; color:#FFF;"><%# Eval("ProductName") %></div>
                                            </div>
                                        </td>
                                        <td style="color:var(--admin-gold);"><%# Eval("BrandName") %></td>
                                        <td>
                                            <span class="badge bg-secondary"><%# Eval("UnitsSold") %> units</span>
                                        </td>
                                        <td style="text-align:right; font-weight:700; color:#FFF;">
                                            &#8377;<%# Convert.ToDecimal(Eval("TotalSales")).ToString("N0") %>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                            <% if (rptTopSelling.Items.Count == 0) { %>
                                <tr>
                                    <td colspan="4" class="text-center py-4" style="color:#777;">
                                        No sales logged during this period.
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Order Fulfillment Status Breakdown -->
        <div class="col-lg-5">
            <div class="admin-table-card mt-0 h-100">
                <div class="admin-table-header">
                    <div class="admin-table-title d-flex align-items-center gap-2">
                        <i class="fas fa-pie-chart" style="color:var(--admin-gold);"></i>
                        Order Status Breakdown
                    </div>
                </div>
                <div class="p-3">
                    <asp:Repeater ID="rptStatusDist" runat="server">
                        <ItemTemplate>
                            <div class="mb-3">
                                <div class="d-flex justify-content-between mb-1" style="font-size:0.85rem;">
                                    <span class="status-badge <%# Eval("OrderStatus").ToString().ToLower() %>">
                                        <%# Eval("OrderStatus") %>
                                    </span>
                                    <span style="color:#FFF; font-weight:600;">
                                        <%# Eval("StatusCount") %> orders &bull; &#8377;<%# Convert.ToDecimal(Eval("TotalRevenue")).ToString("N0") %>
                                    </span>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <% if (rptStatusDist.Items.Count == 0) { %>
                        <div class="text-center py-4" style="color:#777;">
                            No order statuses logged yet.
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>

    <!-- ── DAILY REVENUE BREAKDOWN TABLE ── -->
    <div class="admin-table-card mt-0">
        <div class="admin-table-header">
            <div class="admin-table-title d-flex align-items-center gap-2">
                <i class="fas fa-calendar-alt" style="color:var(--admin-gold);"></i>
                Daily Financial Settlement
            </div>
        </div>

        <div class="table-responsive">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Transactions Count</th>
                        <th>Settled Revenue</th>
                        <th style="text-align:right;">Day Average</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptDailySales" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td style="font-weight:600; color:#FFF;">
                                    <%# Convert.ToDateTime(Eval("SaleDate")).ToString("dddd, MMM dd, yyyy") %>
                                </td>
                                <td>
                                    <span class="badge bg-dark border border-secondary" style="font-size:0.75rem;">
                                        <%# Eval("OrderCount") %> Transactions
                                    </span>
                                </td>
                                <td style="font-weight:700; color:var(--admin-gold); font-size:0.95rem;">
                                    &#8377;<%# Convert.ToDecimal(Eval("Revenue")).ToString("N0") %>
                                </td>
                                <td style="text-align:right; color:#DDD;">
                                    &#8377;<%# (Convert.ToDecimal(Eval("Revenue")) / Convert.ToInt32(Eval("OrderCount"))).ToString("N0") %>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                    <% if (rptDailySales.Items.Count == 0) { %>
                        <tr>
                            <td colspan="4" class="text-center py-5" style="color:#777;">
                                <i class="fas fa-calendar-times fa-2x mb-2" style="color:var(--admin-gold); opacity:0.4;"></i><br />
                                No sales transactions found within selected date range.
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</asp:Content>
