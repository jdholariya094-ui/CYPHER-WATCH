<%@ Page Title="Coupons" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeBehind="Coupons.aspx.cs" Inherits="CYPHER.Admin.Coupons" %>

<asp:Content ID="PageTitleContent" ContentPlaceHolderID="TitleContent" runat="server">
    Promotional Coupons & Codes
</asp:Content>

<asp:Content ID="PageHeaderContent" ContentPlaceHolderID="PageHeaderContent" runat="server">
    <div class="d-flex align-items-center justify-content-between w-100">
        <div>
            <span>Promotional Coupons</span>
            <span class="badge ms-2" style="background: rgba(201,168,76,0.15); color: var(--admin-gold); font-size: 0.72rem;">
                <asp:Literal ID="litCount" runat="server">0</asp:Literal> Active & Archived
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

    <!-- ── ADD / EDIT COUPON FORM ── -->
    <asp:Panel ID="pnlEditCoupon" runat="server" Visible="false" CssClass="admin-form-card mb-4">
        <div class="d-flex align-items-center justify-content-between mb-4 pb-2 border-bottom border-secondary border-opacity-25">
            <h4 style="font-family:'Cormorant Garamond',serif; color:var(--admin-gold); font-size:1.5rem; margin:0;">
                <asp:Literal ID="litFormTitle" runat="server">Create New Promotional Coupon</asp:Literal>
            </h4>
            <asp:LinkButton ID="btnCloseForm" runat="server" OnClick="btnCloseForm_Click" CssClass="btn-admin-icon">
                <i class="fas fa-times"></i>
            </asp:LinkButton>
        </div>

        <asp:HiddenField ID="hdnCouponID" runat="server" Value="0" />

        <div class="admin-form">
            <div class="row g-3">
                <div class="col-md-4">
                    <label>Coupon Code *</label>
                    <asp:TextBox ID="txtCode" runat="server" CssClass="form-control" placeholder="e.g. LUXURY10, CYPHERVIP" style="text-transform:uppercase; font-weight:700; letter-spacing:1px;" required="required" />
                </div>

                <div class="col-md-4">
                    <label>Discount Type *</label>
                    <asp:DropDownList ID="ddlType" runat="server" CssClass="form-select">
                        <asp:ListItem Value="Percentage">Percentage Discount (%)</asp:ListItem>
                        <asp:ListItem Value="Fixed">Fixed Amount Off (&#8377;)</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="col-md-4">
                    <label>Discount Value *</label>
                    <asp:TextBox ID="txtValue" runat="server" CssClass="form-control" TextMode="Number" step="0.01" placeholder="e.g. 10 or 5000" required="required" />
                </div>

                <div class="col-md-4">
                    <label>Minimum Cart Total (&#8377;)</label>
                    <asp:TextBox ID="txtMinSpend" runat="server" CssClass="form-control" TextMode="Number" step="1" placeholder="0" />
                </div>

                <div class="col-md-4">
                    <label>Maximum Global Redemptions</label>
                    <asp:TextBox ID="txtMaxUses" runat="server" CssClass="form-control" TextMode="Number" placeholder="Leave empty for unlimited" />
                </div>

                <div class="col-md-4">
                    <label>Expiration Date</label>
                    <asp:TextBox ID="txtExpiryDate" runat="server" CssClass="form-control" TextMode="Date" />
                </div>

                <div class="col-12">
                    <label class="d-flex align-items-center gap-2" style="cursor:pointer; text-transform:none; color:#DDD;">
                        <asp:CheckBox ID="chkIsActive" runat="server" Checked="true" />
                        <span>Coupon is Active and Redeemable</span>
                    </label>
                </div>

                <div class="col-12 d-flex justify-content-end gap-2 pt-2 border-top border-secondary border-opacity-25">
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCloseForm_Click" CssClass="btn-admin-secondary" CausesValidation="false" />
                    <asp:Button ID="btnSaveCoupon" runat="server" Text="Save Coupon" OnClick="btnSaveCoupon_Click" CssClass="btn-admin-primary" />
                </div>
            </div>
        </div>
    </asp:Panel>

    <!-- Toolbar -->
    <div class="admin-toolbar">
        <div class="admin-table-title d-flex align-items-center gap-2">
            <i class="fas fa-ticket-alt" style="color:var(--admin-gold);"></i>
            Promotional Vouchers & Codes
        </div>
        <div>
            <asp:LinkButton ID="btnShowAdd" runat="server" OnClick="btnShowAdd_Click" CssClass="btn-admin-primary">
                <i class="fas fa-plus-circle"></i> Create Coupon
            </asp:LinkButton>
        </div>
    </div>

    <!-- Coupons Table -->
    <div class="admin-table-card mt-0">
        <div class="table-responsive">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Promo Code</th>
                        <th>Benefit</th>
                        <th>Minimum Spend</th>
                        <th>Redemptions</th>
                        <th>Expiration</th>
                        <th>Status</th>
                        <th style="text-align:right;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptCoupons" runat="server" OnItemCommand="rptCoupons_ItemCommand">
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="badge" style="background:rgba(201,168,76,0.18); color:var(--admin-gold); font-size:0.85rem; font-weight:700; letter-spacing:1px; padding:6px 12px; border:1px dashed rgba(201,168,76,0.4);">
                                            <%# Eval("CouponCode") %>
                                        </span>
                                    </div>
                                </td>
                                <td>
                                    <div style="font-weight:600; color:#FFF;">
                                        <%# Eval("DiscountType").ToString() == "Percentage" ? Eval("DiscountValue") + "% OFF" : "&#8377;" + Convert.ToDecimal(Eval("DiscountValue")).ToString("N0") + " OFF" %>
                                    </div>
                                    <div style="font-size:0.72rem; color:#888;"><%# Eval("DiscountType") %> Discount</div>
                                </td>
                                <td>
                                    <div style="color:#DDD; font-size:0.85rem;">
                                        &#8377;<%# Convert.ToDecimal(Eval("MinOrderAmount")).ToString("N0") %>
                                    </div>
                                </td>
                                <td>
                                    <div style="font-size:0.82rem; color:#DDD;">
                                        <strong><%# Eval("UsedCount") %></strong> / <%# Eval("MaxUses") != DBNull.Value ? Eval("MaxUses") : "Unlimited" %>
                                    </div>
                                </td>
                                <td>
                                    <div style="font-size:0.8rem; color:#AAA;">
                                        <%# Eval("ExpiryDate") != DBNull.Value ? Convert.ToDateTime(Eval("ExpiryDate")).ToString("MMM dd, yyyy") : "<span style='color:#777;'>Never Expires</span>" %>
                                    </div>
                                </td>
                                <td>
                                    <span class="status-badge <%# Convert.ToBoolean(Eval("IsActive")) ? "active" : "inactive" %>">
                                        <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Disabled" %>
                                    </span>
                                </td>
                                <td style="text-align:right;">
                                    <div class="d-flex justify-content-end gap-1">
                                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditCoupon" CommandArgument='<%# Eval("CouponID") %>' CssClass="btn-admin-icon" ToolTip="Edit Coupon">
                                            <i class="fas fa-edit"></i>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnToggle" runat="server" CommandName="ToggleActive" CommandArgument='<%# Eval("CouponID") %>' CssClass="btn-admin-icon" ToolTip="Toggle Status">
                                            <i class="fas <%# Convert.ToBoolean(Eval("IsActive")) ? "fa-eye-slash" : "fa-eye" %>"></i>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteCoupon" CommandArgument='<%# Eval("CouponID") %>' CssClass="btn-admin-icon danger" ToolTip="Delete Coupon" OnClientClick="return confirm('Permanently delete this coupon?');">
                                            <i class="fas fa-trash"></i>
                                        </asp:LinkButton>
                                    </div>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                    <% if (rptCoupons.Items.Count == 0) { %>
                        <tr>
                            <td colspan="7" class="text-center py-5" style="color:#777;">
                                <i class="fas fa-ticket-alt fa-2x mb-2" style="color:var(--admin-gold); opacity:0.4;"></i><br />
                                No promotional coupons configured.
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</asp:Content>
