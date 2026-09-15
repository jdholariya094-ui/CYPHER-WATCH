<%@ Page Title="Checkout - CYPHER" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Checkout.aspx.cs" Inherits="CYPHER.Pages.Checkout" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <!-- Breadcrumb -->
  <div class="breadcrumb-cypher py-3">
    <div class="container">
      <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
          <li class="breadcrumb-item"><a href="<%= ResolveUrl("~/Pages/Home.aspx") %>"><i class="fas fa-home me-1"></i>Home</a></li>
          <li class="breadcrumb-item"><a href="<%= ResolveUrl("~/Pages/Cart.aspx") %>">Cart</a></li>
          <li class="breadcrumb-item active" aria-current="page">Checkout</li>
        </ol>
      </nav>
    </div>
  </div>

  <section class="section-pad-sm">
    <div class="container">
      <h2 style="font-family:'Cormorant Garamond',serif; color:#C9A84C; margin-bottom:2rem;">Secure Checkout</h2>

      <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-danger bg-dark text-danger border-danger mb-4" style="border-color: rgba(231, 76, 60, 0.3) !important;">
        <i class="fas fa-exclamation-circle me-2"></i> <asp:Label ID="lblError" runat="server" />
      </asp:Panel>

      <div class="row g-5">
        <!-- Billing/Shipping Details -->
        <div class="col-lg-7">
          <div class="glass-card p-4 p-md-5 mb-4" style="border: 1px solid rgba(255,255,255,0.06); background:#141414;">
            <h3 style="font-family:'Cormorant Garamond',serif; color:#C9A84C; margin-bottom:1.5rem; border-bottom:1px solid rgba(255,255,255,0.05); padding-bottom:0.5rem;">Shipping Information</h3>
            
            <div class="form-cypher row g-3">
              <div class="col-md-6">
                <label for="<%= txtFullName.ClientID %>">Recipient Name *</label>
                <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" placeholder="e.g. John Doe" />
              </div>
              <div class="col-md-6">
                <label for="<%= txtPhone.ClientID %>">Phone Number *</label>
                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="e.g. +91 98765 43210" />
              </div>
              <div class="col-12">
                <label for="<%= txtAddress.ClientID %>">Shipping Address *</label>
                <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" placeholder="Street, Apartment, Suite" />
              </div>
              <div class="col-md-4">
                <label for="<%= txtCity.ClientID %>">City *</label>
                <asp:TextBox ID="txtCity" runat="server" CssClass="form-control" placeholder="e.g. Mumbai" />
              </div>
              <div class="col-md-4">
                <label for="<%= txtState.ClientID %>">State *</label>
                <asp:TextBox ID="txtState" runat="server" CssClass="form-control" placeholder="e.g. Maharashtra" />
              </div>
              <div class="col-md-4">
                <label for="<%= txtZip.ClientID %>">PIN / Zip Code *</label>
                <asp:TextBox ID="txtZip" runat="server" CssClass="form-control" placeholder="e.g. 400001" />
              </div>
            </div>
          </div>

          <div class="glass-card p-4 p-md-5" style="border: 1px solid rgba(255,255,255,0.06); background:#141414;">
            <h3 style="font-family:'Cormorant Garamond',serif; color:#C9A84C; margin-bottom:1.5rem; border-bottom:1px solid rgba(255,255,255,0.05); padding-bottom:0.5rem;">Payment Method</h3>
            
            <div class="form-cypher">
              <asp:RadioButtonList ID="rblPayment" runat="server" CssClass="text-light" AutoPostBack="true" OnSelectedIndexChanged="rblPayment_SelectedIndexChanged" RepeatLayout="Flow" style="font-size:0.9rem;">
                <asp:ListItem Value="Card" Text="Credit / Debit Card (Visa, Mastercard)" Selected="True" />
                <asp:ListItem Value="UPI" Text="UPI / PayTM" />
                <asp:ListItem Value="COD" Text="Cash on Delivery (COD)" />
              </asp:RadioButtonList>

              <!-- Card Details Block -->
              <asp:Panel ID="pnlCardDetails" runat="server" CssClass="row g-3 mt-3">
                <div class="col-md-6">
                  <label>Cardholder Name</label>
                  <asp:TextBox ID="txtCardName" runat="server" CssClass="form-control" placeholder="JOHN DOE" />
                </div>
                <div class="col-md-6">
                  <label>Card Number</label>
                  <asp:TextBox ID="txtCardNum" runat="server" CssClass="form-control" placeholder="1111-2222-3333-4444" />
                </div>
                <div class="col-md-6">
                  <label>Expiry Date</label>
                  <asp:TextBox ID="txtCardExp" runat="server" CssClass="form-control" placeholder="MM/YY" />
                </div>
                <div class="col-md-6">
                  <label>CVV</label>
                  <asp:TextBox ID="txtCardCVV" runat="server" CssClass="form-control" placeholder="•••" TextMode="Password" />
                </div>
              </asp:Panel>

              <!-- UPI Details Block -->
              <asp:Panel ID="pnlUPIDetails" runat="server" CssClass="mt-3" Visible="false">
                <div class="form-group">
                  <label>UPI ID (VPA)</label>
                  <asp:TextBox ID="txtUPIID" runat="server" CssClass="form-control mt-1" placeholder="john@upi" />
                </div>
              </asp:Panel>
            </div>
          </div>
        </div>

        <!-- Order Summary -->
        <div class="col-lg-5">
          <div class="glass-card p-4" style="border: 1px solid rgba(201,168,76,0.15); box-shadow: var(--shadow-gold);">
            <h4 style="font-family:'Cormorant Garamond',serif; color:#C9A84C; margin-bottom:1.5rem; border-bottom:1px solid rgba(255,255,255,0.06); padding-bottom:0.5rem;">Order Summary</h4>

            <!-- Items list -->
            <div class="d-flex flex-column gap-3 mb-4" style="max-height: 250px; overflow-y: auto;">
              <asp:Repeater ID="rptSummaryItems" runat="server">
                <ItemTemplate>
                  <div class="d-flex align-items-center justify-content-between gap-3">
                    <div class="d-flex align-items-center gap-2">
                      <img src='<%# Eval("ImageURL") %>' alt='<%# Eval("ProductName") %>' style="width:40px; height:40px; object-fit:contain; border-radius:4px; border:1px solid rgba(255,255,255,0.05);" />
                      <div>
                        <span style="font-size:0.82rem; color:#FFF; display:block; max-width:180px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;" title='<%# Eval("ProductName") %>'><%# Eval("ProductName") %></span>
                        <small class="text-muted">Qty: <%# Eval("Quantity") %></small>
                      </div>
                    </div>
                    <span style="font-size:0.85rem; color:#C9A84C;">₹<%# string.Format("{0:N0}", Eval("LineTotal")) %></span>
                  </div>
                </ItemTemplate>
              </asp:Repeater>
            </div>

            <!-- Totals -->
            <div class="d-flex flex-column gap-3 pt-3 mb-4" style="font-size: 0.88rem; border-top: 1px solid rgba(255,255,255,0.06);">
              <div class="d-flex justify-content-between text-muted">
                <span>Subtotal</span>
                <span style="color:#FFF;">₹<asp:Label ID="lblSubtotal" runat="server" /></span>
              </div>
              
              <asp:Panel ID="pnlDiscountRow" runat="server" Visible="false" CssClass="d-flex justify-content-between text-success">
                <span>Promo Discount</span>
                <span>-₹<asp:Label ID="lblDiscount" runat="server" /></span>
              </asp:Panel>

              <div class="d-flex justify-content-between text-muted">
                <span>GST (18%)</span>
                <span style="color:#FFF;">₹<asp:Label ID="lblTax" runat="server" /></span>
              </div>

              <div class="d-flex justify-content-between text-muted">
                <span>Delivery Charge</span>
                <span class="text-success font-weight-bold">FREE</span>
              </div>

              <div class="d-flex justify-content-between pt-3 mt-2" style="border-top:1px solid rgba(255,255,255,0.06);">
                <strong style="color:#FFF; font-size:1.1rem;">Grand Total</strong>
                <strong style="color:#C9A84C; font-size:1.3rem;">₹<asp:Label ID="lblTotal" runat="server" /></strong>
              </div>
            </div>

            <asp:Button ID="btnPlaceOrder" runat="server" CssClass="btn-gold w-100" Text="Complete Purchase" OnClick="btnPlaceOrder_Click" />
          </div>
        </div>
      </div>
    </div>
  </section>
</asp:Content>
