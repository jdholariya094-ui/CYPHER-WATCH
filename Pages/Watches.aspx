<%@ Page Title="Shop Watches - CYPHER" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Watches.aspx.cs" Inherits="CYPHER.Pages.Watches" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <!-- Breadcrumb -->
  <div class="breadcrumb-cypher py-3">
    <div class="container">
      <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
          <li class="breadcrumb-item"><a href="<%= ResolveUrl("~/Pages/Home.aspx") %>"><i class="fas fa-home me-1"></i>Home</a></li>
          <li class="breadcrumb-item active" aria-current="page">Shop Watches</li>
        </ol>
      </nav>
    </div>
  </div>

  <!-- Catalog Section -->
  <section class="section-pad-sm">
    <div class="container">
      <div class="row g-4">
        <!-- Sidebar Filters -->
        <div class="col-lg-3">
          <div class="glass-card p-4 mb-4" style="border: 1px solid rgba(201,168,76,0.15);">
            <h4 style="font-family:'Cormorant Garamond',serif; color:#C9A84C; margin-bottom:1.5rem; border-bottom:1px solid rgba(255,255,255,0.06); padding-bottom:0.5rem;">Filters</h4>

            <!-- Category Filter -->
            <div class="mb-4">
              <h5 style="font-size:0.9rem; color:#fff; text-transform:uppercase; letter-spacing:1px; margin-bottom:0.8rem;">Collections</h5>
              <div style="max-height: 200px; overflow-y: auto;">
                <asp:RadioButtonList ID="rblCategories" runat="server" CssClass="text-light form-cypher" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged" RepeatLayout="UnorderedList" style="list-style:none; padding:0; font-size:0.85rem;" />
              </div>
            </div>

            <!-- Brand Filter -->
            <div class="mb-4">
              <h5 style="font-size:0.9rem; color:#fff; text-transform:uppercase; letter-spacing:1px; margin-bottom:0.8rem;">Brands</h5>
              <div style="max-height: 200px; overflow-y: auto;">
                <asp:RadioButtonList ID="rblBrands" runat="server" CssClass="text-light form-cypher" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged" RepeatLayout="UnorderedList" style="list-style:none; padding:0; font-size:0.85rem;" />
              </div>
            </div>

            <!-- Price Filter -->
            <div class="mb-4">
              <h5 style="font-size:0.9rem; color:#fff; text-transform:uppercase; letter-spacing:1px; margin-bottom:0.8rem;">Price (₹)</h5>
              <div class="form-cypher d-flex gap-2">
                <asp:TextBox ID="txtMinPrice" runat="server" CssClass="form-control text-center p-1" placeholder="Min" style="font-size:0.8rem;" />
                <span class="text-muted align-self-center">-</span>
                <asp:TextBox ID="txtMaxPrice" runat="server" CssClass="form-control text-center p-1" placeholder="Max" style="font-size:0.8rem;" />
              </div>
              <asp:Button ID="btnPriceFilter" runat="server" CssClass="btn-gold btn-sm w-100 mt-2 p-1" Text="Apply Price" OnClick="FilterChanged" style="font-size:0.75rem;" />
            </div>

            <!-- Clear Filter Button -->
            <asp:LinkButton ID="lnkClearFilters" runat="server" CssClass="text-danger d-block text-center mt-3" style="font-size:0.8rem; text-decoration:none;" OnClick="lnkClearFilters_Click">
              <i class="fas fa-times me-1"></i>Clear All Filters
            </asp:LinkButton>
          </div>
        </div>

        <!-- Catalog Grid -->
        <div class="col-lg-9">
          <!-- Top bar sorting and info -->
          <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 p-3 glass-card" style="border: 1px solid rgba(255,255,255,0.06); border-radius:8px;">
            <p class="text-muted mb-0" style="font-size: 0.9rem;">
              Showing <span class="text-warning font-weight-bold"><asp:Label ID="lblCount" runat="server" Text="0" /></span> timepieces
            </p>
            <div class="d-flex gap-3 align-items-center">
              <!-- Search Bar -->
              <div class="form-cypher d-none d-md-block">
                <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control py-1 px-3" placeholder="Search..." OnTextChanged="FilterChanged" AutoPostBack="true" style="border-radius:20px; font-size:0.8rem; width:180px;" />
              </div>
              <!-- Sort Dropdown -->
              <div class="form-cypher d-flex align-items-center gap-2">
                <label for="<%= ddlSort.ClientID %>" class="mb-0 text-muted" style="font-size:0.8rem; text-transform:none;">Sort:</label>
                <asp:DropDownList ID="ddlSort" runat="server" CssClass="form-select py-1 px-3" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged" style="font-size:0.8rem; background-color:#1A1A1A; color:#FFF; border-radius:5px;">
                  <asp:ListItem Value="Default" Text="Default Curation" />
                  <asp:ListItem Value="PriceAsc" Text="Price: Low to High" />
                  <asp:ListItem Value="PriceDesc" Text="Price: High to Low" />
                  <asp:ListItem Value="Newest" Text="New Arrivals" />
                </asp:DropDownList>
              </div>
            </div>
          </div>

          <!-- Product Repeater -->
          <div class="row g-4">
            <asp:Repeater ID="rptProducts" runat="server">
              <ItemTemplate>
                <div class="col-sm-6 col-md-4">
                  <div class="product-card">
                    <div class="product-card-img">
                      <img src='<%# Eval("ImageURL") %>' alt='<%# Eval("ProductName") %>' />
                      <%# Convert.ToBoolean(Eval("IsNewArrival")) ? "<span class='product-badge new'>NEW</span>" : "" %>
                      <%# Convert.ToDecimal(Eval("DiscountPercent")) > 0 ? "<span class='product-badge sale'>-" + Convert.ToInt32(Eval("DiscountPercent")) + "%</span>" : "" %>
                      <div class="product-card-overlay">
                        <a href='<%# ResolveUrl("~/Pages/ProductDetail.aspx?id=" + Eval("ProductID")) %>' class="overlay-btn" title="View Details"><i class="fas fa-eye"></i></a>
                      </div>
                    </div>
                    <div class="product-card-body">
                      <div class="product-brand"><%# Eval("BrandName") %></div>
                      <h3 class="product-name" title='<%# Eval("ProductName") %>'><%# Eval("ProductName") %></h3>
                      <div class="product-rating">
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star-half-alt"></i>
                        <span class="count">(<%# Eval("ReviewCount") %>)</span>
                      </div>
                      <div class="product-price">
                        <%# Convert.ToDecimal(Eval("DiscountPercent")) > 0 ? "<span class='price-original'>₹" + string.Format("{0:N0}", Eval("Price")) + "</span>" : "" %>
                        <span class="price-current">₹<%# GetDiscountedPrice(Convert.ToDecimal(Eval("Price")), Convert.ToDecimal(Eval("DiscountPercent"))) %></span>
                      </div>
                      <div class="product-card-actions">
                        <a href='<%# ResolveUrl("~/Pages/ProductDetail.aspx?id=" + Eval("ProductID")) %>' class="btn-cart-sm text-center text-decoration-none">View Details</a>
                      </div>
                    </div>
                  </div>
                </div>
              </ItemTemplate>
            </asp:Repeater>
          </div>

          <!-- No Products Found -->
          <asp:Panel ID="pnlNoProducts" runat="server" Visible="false" CssClass="text-center py-5 glass-card mt-4" style="border: 1px solid rgba(255,255,255,0.06); border-radius:12px;">
            <i class="fas fa-search text-muted mb-3" style="font-size:3rem; opacity:0.3;"></i>
            <h3 style="font-family:'Cormorant Garamond',serif; color:#fff;">No Timepieces Found</h3>
            <p class="text-muted" style="font-size:0.9rem;">Try adjusting your search query or filters.</p>
          </asp:Panel>
        </div>
      </div>
    </div>
  </section>
</asp:Content>
