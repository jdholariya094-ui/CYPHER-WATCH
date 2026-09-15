<%@ Page Title="Shopping Cart - CYPHER" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Cart.aspx.cs" Inherits="CYPHER.Pages.Cart" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <!-- Breadcrumb -->
  <div class="breadcrumb-cypher py-3">
    <div class="container">
      <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
          <li class="breadcrumb-item"><a href="<%= ResolveUrl("~/Pages/Home.aspx") %>"><i class="fas fa-home me-1"></i>Home</a></li>
          <li class="breadcrumb-item active" aria-current="page">Shopping Cart</li>
        </ol>
      </nav>
    </div>
  </div>

  <section class="section-pad-sm">
    <div class="container">
      <h2 style="font-family:'Cormorant Garamond',serif; color:#C9A84C; margin-bottom:2rem;">Your Selection</h2>

      <asp:Panel ID="pnlCartEmpty" runat="server" Visible="false" CssClass="text-center py-5 glass-card" style="border: 1px solid rgba(201,168,76,0.15);">
        <i class="fas fa-shopping-bag text-muted mb-3" style="font-size:3rem; opacity:0.3;"></i>
        <h3 style="font-family:'Cormorant Garamond',serif; color:#fff;">Your Cart is Empty</h3>
        <p class="text-muted" style="font-size:0.9rem;">You haven't added any luxury timepieces yet.</p>
        <a href="<%= ResolveUrl("~/Pages/Watches.aspx") %>" class="btn-gold mt-3">Browse Watches</a>
      </asp:Panel>

      <asp:Panel ID="pnlCartContent" runat="server" Visible="true">
        <div class="row g-5">
          <!-- Cart Table -->
          <div class="col-lg-8">
            <div class="table-responsive glass-card p-3" style="border: 1px solid rgba(255,255,255,0.06); border-radius:12px; background:#141414;">
              <asp:GridView ID="gvCart" runat="server" AutoGenerateColumns="False" DataKeyNames="CartID" CssClass="table table-dark table-striped align-middle mb-0" GridLines="None" style="--bs-table-bg:#141414; border:none;" OnRowCommand="gvCart_RowCommand">
                <Columns>
                  <asp:TemplateField HeaderText="Timepiece" HeaderStyle-CssClass="text-muted font-weight-bold">
                    <ItemTemplate>
                      <div class="d-flex align-items-center gap-3">
                        <img src='<%# Eval("ImageURL") %>' alt='<%# Eval("ProductName") %>' style="width:60px; height:60px; object-fit:contain; border:1px solid rgba(255,255,255,0.05); border-radius:6px; background:#1A1A1A;" />
                        <div>
                          <span class="text-warning text-uppercase" style="font-size:0.65rem; letter-spacing:1px; display:block;"><%# Eval("BrandName") %></span>
                          <strong style="color:#FFF; font-size:0.9rem;"><%# Eval("ProductName") %></strong>
                        </div>
                      </div>
                    </ItemTemplate>
                  </asp:TemplateField>

                  <asp:TemplateField HeaderText="Price" HeaderStyle-CssClass="text-muted font-weight-bold">
                    <ItemTemplate>
                      <span style="font-size:0.95rem; color:#C9A84C;">₹<%# string.Format("{0:N0}", Eval("UnitDiscountedPrice")) %></span>
                    </ItemTemplate>
                  </asp:TemplateField>

                  <asp:TemplateField HeaderText="Qty" HeaderStyle-CssClass="text-muted font-weight-bold text-center" ItemStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                      <div class="form-cypher d-flex justify-content-center align-items-center gap-1">
                        <asp:LinkButton ID="lnkDec" runat="server" CommandName="DecQty" CommandArgument='<%# Container.DataItemIndex %>' CssClass="btn btn-outline-secondary py-0 px-2" style="font-size:0.75rem; border-color:rgba(255,255,255,0.1); color:#aaa;">-</asp:LinkButton>
                        <asp:TextBox ID="txtQty" runat="server" Text='<%# Eval("Quantity") %>' ReadOnly="true" CssClass="form-control text-center p-0" style="width:35px; height:25px; font-size:0.82rem; background:transparent; border-color:rgba(255,255,255,0.08); color:#fff;" />
                        <asp:LinkButton ID="lnkInc" runat="server" CommandName="IncQty" CommandArgument='<%# Container.DataItemIndex %>' CssClass="btn btn-outline-secondary py-0 px-2" style="font-size:0.75rem; border-color:rgba(255,255,255,0.1); color:#aaa;">+</asp:LinkButton>
                      </div>
                    </ItemTemplate>
                  </asp:TemplateField>

                  <asp:TemplateField HeaderText="Total" HeaderStyle-CssClass="text-muted font-weight-bold">
                    <ItemTemplate>
                      <span style="font-size:0.95rem; color:#FFF; font-weight:600;">₹<%# string.Format("{0:N0}", Eval("LineTotal")) %></span>
                    </ItemTemplate>
                  </asp:TemplateField>

                  <asp:TemplateField ItemStyle-HorizontalAlign="Right">
                    <ItemTemplate>
                      <asp:LinkButton ID="lnkRemove" runat="server" CommandName="RemoveItem" CommandArgument='<%# Eval("CartID") %>' CssClass="text-danger" style="font-size:0.85rem;" title="Remove timepiece"><i class="fas fa-trash-alt"></i></asp:LinkButton>
                    </ItemTemplate>
                  </asp:TemplateField>
                </Columns>
              </asp:GridView>
            </div>
          </div>

          <!-- Cart Summary -->
          <div class="col-lg-4">
            <div class="glass-card p-4" style="border: 1px solid rgba(201,168,76,0.15); box-shadow: var(--shadow-gold);">
              <h4 style="font-family:'Cormorant Garamond',serif; color:#C9A84C; margin-bottom:1.5rem; border-bottom:1px solid rgba(255,255,255,0.06); padding-bottom:0.5rem;">Summary</h4>

              <div class="d-flex flex-column gap-3 mb-4" style="font-size: 0.9rem;">
                <div class="d-flex justify-content-between text-muted">
                  <span>Subtotal</span>
                  <span style="color:#FFF;">₹<asp:Label ID="lblSubtotal" runat="server" Text="0" /></span>
                </div>
                
                <!-- Coupon Input -->
                <div class="form-cypher mt-2">
                  <label for="<%= txtCoupon.ClientID %>" class="text-muted" style="font-size:0.75rem; text-transform:none;">Have a Promo Code?</label>
                  <div class="d-flex gap-2 mt-1">
                    <asp:TextBox ID="txtCoupon" runat="server" CssClass="form-control py-1 px-3" placeholder="e.g. CYPHER10" style="font-size:0.8rem;" />
                    <asp:Button ID="btnApplyCoupon" runat="server" CssClass="btn-gold py-1 px-3" Text="Apply" OnClick="btnApplyCoupon_Click" style="font-size:0.75rem;" />
                  </div>
                  <asp:Label ID="lblCouponMsg" runat="server" CssClass="d-block mt-2" style="font-size:0.78rem;" Visible="false" />
                </div>

                <asp:Panel ID="pnlDiscountRow" runat="server" Visible="false" CssClass="d-flex justify-content-between text-success mt-2">
                  <span>Discount (<asp:Label ID="lblCouponCode" runat="server" />)</span>
                  <span>-₹<asp:Label ID="lblDiscountAmount" runat="server" Text="0" /></span>
                </asp:Panel>

                <div class="d-flex justify-content-between text-muted">
                  <span>Estimated Shipping</span>
                  <span class="text-success font-weight-bold" style="letter-spacing:1px;">FREE</span>
                </div>

                <div class="d-flex justify-content-between text-muted">
                  <span>Estimated Tax (GST 18%)</span>
                  <span style="color:#FFF;">₹<asp:Label ID="lblTax" runat="server" Text="0" /></span>
                </div>

                <div class="d-flex justify-content-between pt-3 mt-2" style="border-top:1px solid rgba(255,255,255,0.06);">
                  <strong style="color:#FFF; font-size:1.1rem;">Total</strong>
                  <strong style="color:#C9A84C; font-size:1.3rem;">₹<asp:Label ID="lblTotal" runat="server" Text="0" /></strong>
                </div>
              </div>

              <asp:Button ID="btnCheckout" runat="server" CssClass="btn-gold w-100" Text="Proceed To Checkout" OnClick="btnCheckout_Click" />
            </div>
          </div>
        </div>
      </asp:Panel>
    </div>
  </section>
</asp:Content>
