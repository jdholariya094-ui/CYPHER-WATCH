<%@ Page Title="User Dashboard - CYPHER" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="CYPHER.Pages.Dashboard" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <!-- Breadcrumb -->
  <div class="breadcrumb-cypher py-3">
    <div class="container">
      <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
          <li class="breadcrumb-item"><a href="<%= ResolveUrl("~/Pages/Home.aspx") %>"><i class="fas fa-home me-1"></i>Home</a></li>
          <li class="breadcrumb-item active" aria-current="page">Dashboard</li>
        </ol>
      </nav>
    </div>
  </div>

  <section class="section-pad-sm">
    <div class="container">
      <div class="row g-4">
        <!-- Sidebar Navigation -->
        <div class="col-lg-3">
          <div class="glass-card p-4 text-center mb-4" style="border: 1px solid rgba(201,168,76,0.15);">
            <div class="d-inline-flex align-items-center justify-content-center bg-dark mb-3" style="width: 70px; height: 70px; border-radius:50%; border:1px solid var(--gold);">
              <i class="far fa-user text-warning" style="font-size: 1.8rem;"></i>
            </div>
            <h4 style="font-family:'Cormorant Garamond',serif; color:#FFF; margin:0;"><asp:Label ID="lblUserSidebarName" runat="server" /></h4>
            <p class="text-muted" style="font-size:0.8rem; margin:0.2rem 0 1rem 0;"><asp:Label ID="lblUserSidebarEmail" runat="server" /></p>
            <hr style="border-color:rgba(255,255,255,0.06);" />
            
            <div class="d-flex flex-column gap-2 text-start">
              <asp:LinkButton ID="lnkTabProfile" runat="server" CssClass="btn btn-dark w-100 text-start py-2 px-3" style="font-size:0.82rem; border-color:rgba(255,255,255,0.05); color:#fff;" OnClick="lnkTab_Click" CommandArgument="profile">
                <i class="fas fa-user-cog text-warning me-2"></i>Profile Settings
              </asp:LinkButton>
              <asp:LinkButton ID="lnkTabOrders" runat="server" CssClass="btn btn-dark w-100 text-start py-2 px-3" style="font-size:0.82rem; border-color:rgba(255,255,255,0.05); color:#fff;" OnClick="lnkTab_Click" CommandArgument="orders">
                <i class="fas fa-box text-warning me-2"></i>My Orders
              </asp:LinkButton>
              <asp:LinkButton ID="lnkTabWishlist" runat="server" CssClass="btn btn-dark w-100 text-start py-2 px-3" style="font-size:0.82rem; border-color:rgba(255,255,255,0.05); color:#fff;" OnClick="lnkTab_Click" CommandArgument="wishlist">
                <i class="fas fa-heart text-warning me-2"></i>My Wishlist
              </asp:LinkButton>
            </div>
          </div>
        </div>

        <!-- Content Area -->
        <div class="col-lg-9">
          <!-- PROFILE SETTINGS -->
          <asp:Panel ID="pnlProfile" runat="server" Visible="true">
            <div class="glass-card p-4 p-md-5" style="border: 1px solid rgba(255,255,255,0.06); background:#141414;">
              <h3 style="font-family:'Cormorant Garamond',serif; color:#C9A84C; margin-bottom:1.5rem; border-bottom:1px solid rgba(255,255,255,0.05); padding-bottom:0.5rem;">Profile Settings</h3>
              
              <asp:Panel ID="pnlProfileSuccess" runat="server" Visible="false" CssClass="alert alert-success bg-dark text-success border-success mb-4" style="border-color: rgba(46, 204, 113, 0.3) !important; font-size: 0.85rem;">
                <i class="fas fa-check-circle me-2"></i> Profile details updated successfully!
              </asp:Panel>

              <asp:Panel ID="pnlProfileError" runat="server" Visible="false" CssClass="alert alert-danger bg-dark text-danger border-danger mb-4" style="border-color: rgba(231, 76, 60, 0.3) !important; font-size: 0.85rem;">
                <i class="fas fa-exclamation-circle me-2"></i> <asp:Label ID="lblProfileError" runat="server" />
              </asp:Panel>

              <div class="form-cypher row g-3">
                <div class="col-md-6">
                  <label for="<%= txtFullName.ClientID %>">Full Name *</label>
                  <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" />
                </div>
                <div class="col-md-6">
                  <label for="<%= txtEmail.ClientID %>">Email Address (Cannot change)</label>
                  <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" ReadOnly="true" style="opacity: 0.6;" />
                </div>
                <div class="col-md-6">
                  <label for="<%= txtPhone.ClientID %>">Phone Number</label>
                  <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" />
                </div>
                <div class="col-12">
                  <label for="<%= txtAddress.ClientID %>">Street Address</label>
                  <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" placeholder="123 Luxury Ave, Apt 4B" />
                </div>
                <div class="col-md-4">
                  <label for="<%= txtCity.ClientID %>">City</label>
                  <asp:TextBox ID="txtCity" runat="server" CssClass="form-control" placeholder="Mumbai" />
                </div>
                <div class="col-md-4">
                  <label for="<%= txtState.ClientID %>">State</label>
                  <asp:TextBox ID="txtState" runat="server" CssClass="form-control" placeholder="Maharashtra" />
                </div>
                <div class="col-md-4">
                  <label for="<%= txtZip.ClientID %>">PIN / Zip Code</label>
                  <asp:TextBox ID="txtZip" runat="server" CssClass="form-control" placeholder="400001" />
                </div>
                <div class="col-12 mt-4 text-end">
                  <asp:Button ID="btnUpdateProfile" runat="server" CssClass="btn-gold" Text="Update Details" OnClick="btnUpdateProfile_Click" />
                </div>
              </div>
            </div>
          </asp:Panel>

          <!-- ORDER HISTORY -->
          <asp:Panel ID="pnlOrders" runat="server" Visible="false">
            <div class="glass-card p-4" style="border: 1px solid rgba(255,255,255,0.06); background:#141414;">
              <h3 style="font-family:'Cormorant Garamond',serif; color:#C9A84C; margin-bottom:1.5rem; border-bottom:1px solid rgba(255,255,255,0.05); padding-bottom:0.5rem;">Order History</h3>
              
              <asp:Repeater ID="rptOrders" runat="server" OnItemDataBound="rptOrders_ItemDataBound">
                <ItemTemplate>
                  <div class="glass-card p-3 mb-3" style="border:1px solid rgba(255,255,255,0.05); background:rgba(0,0,0,0.2);">
                    <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3 pb-2" style="border-bottom: 1px solid rgba(255,255,255,0.04);">
                      <div>
                        <span style="color:#888; font-size:0.8rem;">Reference:</span>
                        <strong style="color:#FFF; font-size:0.85rem;">#CYPHER-<%# Eval("OrderID") %></strong>
                      </div>
                      <div>
                        <span style="color:#888; font-size:0.8rem;">Date:</span>
                        <span style="color:#FFF; font-size:0.85rem;"><%# Convert.ToDateTime(Eval("OrderDate")).ToString("MMM dd, yyyy") %></span>
                      </div>
                      <div>
                        <span style="color:#888; font-size:0.8rem;">Status:</span>
                        <span class='badge <%# GetStatusBadgeClass(Eval("OrderStatus").ToString()) %>' style="font-size:0.65rem; text-transform:uppercase;"><%# Eval("OrderStatus") %></span>
                      </div>
                      <div>
                        <span style="color:#888; font-size:0.8rem;">Total:</span>
                        <strong style="color:#C9A84C; font-size:0.95rem;">₹<%# string.Format("{0:N0}", Eval("GrandTotal")) %></strong>
                      </div>
                    </div>

                    <!-- Items Detail Repeater -->
                    <div class="d-flex flex-column gap-2 ps-2">
                      <asp:Repeater ID="rptOrderDetails" runat="server">
                        <ItemTemplate>
                          <div class="d-flex align-items-center justify-content-between gap-3" style="font-size:0.82rem;">
                            <div class="d-flex align-items-center gap-2">
                              <img src='<%# Eval("ImageURL") %>' alt='<%# Eval("ProductName") %>' style="width:30px; height:30px; object-fit:contain; border-radius:4px; background:#1A1A1A;" />
                              <div>
                                <span style="color:#FFF;"><%# Eval("ProductName") %></span>
                                <small class="text-muted d-block"><%# Eval("BrandName") %> &bull; Qty: <%# Eval("Quantity") %></small>
                              </div>
                            </div>
                            <span style="color:#ccc;">₹<%# string.Format("{0:N0}", Eval("TotalPrice")) %></span>
                          </div>
                        </ItemTemplate>
                      </asp:Repeater>
                    </div>
                  </div>
                </ItemTemplate>
              </asp:Repeater>

              <asp:Panel ID="pnlNoOrders" runat="server" Visible="false" CssClass="text-center py-5">
                <i class="fas fa-box text-muted mb-3" style="font-size:2.5rem; opacity:0.3;"></i>
                <p class="text-muted mb-0" style="font-size:0.9rem;">You haven't placed any orders yet.</p>
              </asp:Panel>
            </div>
          </asp:Panel>

          <!-- WISHLIST -->
          <asp:Panel ID="pnlWishlist" runat="server" Visible="false">
            <div class="glass-card p-4" style="border: 1px solid rgba(255,255,255,0.06); background:#141414;">
              <h3 style="font-family:'Cormorant Garamond',serif; color:#C9A84C; margin-bottom:1.5rem; border-bottom:1px solid rgba(255,255,255,0.05); padding-bottom:0.5rem;">My Wishlist</h3>
              
              <div class="row g-3">
                <asp:Repeater ID="rptWishlist" runat="server" OnItemCommand="rptWishlist_ItemCommand">
                  <ItemTemplate>
                    <div class="col-sm-6">
                      <div class="p-3 d-flex align-items-center justify-content-between gap-3 glass-card" style="border:1px solid rgba(255,255,255,0.04); background:#141414;">
                        <div class="d-flex align-items-center gap-3">
                          <img src='<%# Eval("ImageURL") %>' alt='<%# Eval("ProductName") %>' style="width:50px; height:50px; object-fit:contain; border-radius:4px; background:#1A1A1A; border:1px solid rgba(255,255,255,0.05);" />
                          <div>
                            <span style="font-size:0.65rem; color:#C9A84C; text-transform:uppercase; letter-spacing:1px; display:block;"><%# Eval("BrandName") %></span>
                            <a href='<%# ResolveUrl("~/Pages/ProductDetail.aspx?id=" + Eval("ProductID")) %>' style="font-size:0.88rem; color:#FFF; font-weight:600;"><%# Eval("ProductName") %></a>
                            <span class="d-block mt-1" style="font-size:0.85rem; color:#C9A84C;">₹<%# string.Format("{0:N0}", Convert.ToDecimal(Eval("Price")) * (1 - (Convert.ToDecimal(Eval("DiscountPercent"))/100))) %></span>
                          </div>
                        </div>
                        <div class="d-flex flex-column gap-2 align-items-end">
                          <asp:LinkButton ID="lnkRemoveWishlist" runat="server" CommandName="RemoveWish" CommandArgument='<%# Eval("ProductID") %>' CssClass="text-danger" style="font-size:0.8rem;" title="Remove from wishlist"><i class="fas fa-trash-alt"></i></asp:LinkButton>
                        </div>
                      </div>
                    </div>
                  </ItemTemplate>
                </asp:Repeater>
              </div>

              <asp:Panel ID="pnlNoWishlist" runat="server" Visible="false" CssClass="text-center py-5">
                <i class="far fa-heart text-muted mb-3" style="font-size:2.5rem; opacity:0.3;"></i>
                <p class="text-muted mb-0" style="font-size:0.9rem;">Your wishlist is currently empty.</p>
              </asp:Panel>
            </div>
          </asp:Panel>
        </div>
      </div>
    </div>
  </section>
</asp:Content>
