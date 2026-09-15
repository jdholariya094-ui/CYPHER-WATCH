<%@ Page Title="Product Details - CYPHER" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="ProductDetail.aspx.cs" Inherits="CYPHER.Pages.ProductDetail" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <!-- Breadcrumb -->
  <div class="breadcrumb-cypher py-3">
    <div class="container">
      <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
          <li class="breadcrumb-item"><a href="<%= ResolveUrl("~/Pages/Home.aspx") %>"><i class="fas fa-home me-1"></i>Home</a></li>
          <li class="breadcrumb-item"><a href="<%= ResolveUrl("~/Pages/Watches.aspx") %>">Shop</a></li>
          <li class="breadcrumb-item active" aria-current="page"><asp:Label ID="lblBreadcrumbName" runat="server" Text="Product" /></li>
        </ol>
      </nav>
    </div>
  </div>

  <section class="section-pad-sm">
    <div class="container">
      <asp:Panel ID="pnlProduct" runat="server">
        <!-- Main Info -->
        <div class="row g-5 mb-5">
          <!-- Image -->
          <div class="col-lg-6">
            <div style="border:1px solid rgba(201,168,76,0.18); padding:10px; border-radius:12px; background:#111; text-align:center;">
              <asp:Image ID="imgProduct" runat="server" CssClass="img-fluid rounded" style="max-height:500px; object-fit:contain;" />
            </div>
          </div>

          <!-- Actions & Text -->
          <div class="col-lg-6">
            <div class="d-flex flex-column gap-3">
              <div>
                <span class="text-warning text-uppercase font-weight-bold" style="font-size:0.75rem; letter-spacing:2px;">
                  <asp:Label ID="lblBrand" runat="server" />
                </span>
                <h1 style="font-family:'Cormorant Garamond',serif; color:#FFF; font-size:2.8rem; font-weight:300; line-height:1.2; margin: 0.3rem 0;">
                  <asp:Label ID="lblName" runat="server" />
                </h1>
                <div class="d-flex align-items-center gap-2 mt-1">
                  <span class="stars">
                    <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star-half-alt"></i>
                  </span>
                  <span class="text-muted" style="font-size:0.85rem;">(<asp:Label ID="lblRatingCount" runat="server" Text="0" /> Customer Reviews)</span>
                </div>
              </div>

              <!-- Price Card -->
              <div class="glass-card p-4 d-flex align-items-center justify-content-between" style="border: 1px solid rgba(201,168,76,0.15);">
                <div>
                  <span class="text-muted" style="font-size:0.8rem; text-transform:uppercase;">Special Price</span>
                  <div class="d-flex align-items-center gap-3 mt-1">
                    <asp:Label ID="lblPriceOriginal" runat="server" CssClass="price-original" style="font-size:1.1rem; text-decoration:line-through; color:#888;" />
                    <span class="price-current" style="font-size:2rem;">₹<asp:Label ID="lblPriceCurrent" runat="server" /></span>
                    <asp:Label ID="lblDiscount" runat="server" CssClass="price-discount" style="font-size:0.8rem;" />
                  </div>
                </div>
                <div>
                  <span class="badge" id="badgeStock" runat="server" style="padding:8px 15px; font-size:0.7rem; letter-spacing:1px; text-transform:uppercase;">IN STOCK</span>
                </div>
              </div>

              <!-- Description -->
              <div>
                <h5 style="color:#FFF; font-family:'Cormorant Garamond',serif; font-size:1.2rem; margin-bottom:0.5rem;">Overview</h5>
                <p class="text-muted" style="font-size:0.95rem; line-height:1.7;">
                  <asp:Label ID="lblDescription" runat="server" />
                </p>
              </div>

              <!-- Cart Control -->
              <div class="d-flex gap-3 align-items-center mt-3 pt-3" style="border-top:1px solid rgba(255,255,255,0.06);">
                <div class="form-cypher d-flex align-items-center gap-2">
                  <label for="<%= ddlQty.ClientID %>" class="mb-0 text-muted" style="font-size:0.85rem; text-transform:none;">Qty:</label>
                  <asp:DropDownList ID="ddlQty" runat="server" CssClass="form-select py-1 px-3" style="width:70px; background:#1A1A1A; color:#fff; border:1px solid rgba(255,255,255,0.1);">
                    <asp:ListItem Value="1" Text="1" Selected="True" />
                    <asp:ListItem Value="2" Text="2" />
                    <asp:ListItem Value="3" Text="3" />
                    <asp:ListItem Value="4" Text="4" />
                    <asp:ListItem Value="5" Text="5" />
                  </asp:DropDownList>
                </div>
                <asp:Button ID="btnAddToCart" runat="server" CssClass="btn-gold flex-grow-1" Text="Add To Cart" OnClick="btnAddToCart_Click" />
              </div>
              
              <asp:Label ID="lblCartMessage" runat="server" CssClass="text-success mt-2" style="font-size:0.85rem;" Visible="false" />
            </div>
          </div>
        </div>

        <!-- Details & Specifications -->
        <div class="row g-5 mt-4">
          <!-- Specifications -->
          <div class="col-lg-6">
            <h3 style="font-family:'Cormorant Garamond',serif; color:#C9A84C; margin-bottom:1.5rem; border-bottom:1px solid rgba(201,168,76,0.15); padding-bottom:0.5rem;">Specifications</h3>
            <table class="table table-dark table-striped table-bordered" style="font-size:0.9rem; --bs-table-bg:#141414; border-color:rgba(255,255,255,0.04);">
              <tbody>
                <tr>
                  <td class="text-muted" style="width:35%;">Case Diameter</td>
                  <td style="color:#FFF;"><asp:Label ID="lblSpecCase" runat="server" /></td>
                </tr>
                <tr>
                  <td class="text-muted">Water Resistance</td>
                  <td style="color:#FFF;"><asp:Label ID="lblSpecWater" runat="server" /></td>
                </tr>
                <tr>
                  <td class="text-muted">Movement Type</td>
                  <td style="color:#FFF;"><asp:Label ID="lblSpecMovement" runat="server" /></td>
                </tr>
                <tr>
                  <td class="text-muted">Dial Color</td>
                  <td style="color:#FFF;"><asp:Label ID="lblSpecDial" runat="server" /></td>
                </tr>
                <tr>
                  <td class="text-muted">Glass/Crystal</td>
                  <td style="color:#FFF;"><asp:Label ID="lblSpecGlass" runat="server" /></td>
                </tr>
                <tr>
                  <td class="text-muted">Band/Strap</td>
                  <td style="color:#FFF;"><asp:Label ID="lblSpecBand" runat="server" /></td>
                </tr>
                <tr>
                  <td class="text-muted">Warranty</td>
                  <td style="color:#FFF;"><asp:Label ID="lblSpecWarranty" runat="server" /> Years</td>
                </tr>
              </tbody>
            </table>
          </div>

          <!-- Reviews Section -->
          <div class="col-lg-6">
            <h3 style="font-family:'Cormorant Garamond',serif; color:#C9A84C; margin-bottom:1.5rem; border-bottom:1px solid rgba(201,168,76,0.15); padding-bottom:0.5rem;">Customer Reviews</h3>
            
            <!-- Add Review form -->
            <div class="glass-card p-4 mb-4" style="border: 1px solid rgba(255,255,255,0.06);">
              <h5 style="color:#fff; font-size:1rem; margin-bottom:1rem;">Write a Review</h5>
              
              <asp:Panel ID="pnlReviewAlert" runat="server" Visible="false" CssClass="alert alert-info bg-dark text-info border-info p-2 mb-3" style="font-size:0.8rem;">
                <asp:Label ID="lblReviewAlert" runat="server" />
              </asp:Panel>

              <div class="form-cypher row g-3">
                <div class="col-sm-6">
                  <label for="<%= ddlRating.ClientID %>">Rating</label>
                  <asp:DropDownList ID="ddlRating" runat="server" CssClass="form-select py-1" style="background:#1A1A1A; color:#fff; border:1px solid rgba(255,255,255,0.1);">
                    <asp:ListItem Value="5" Text="5 Stars — Perfect" Selected="True" />
                    <asp:ListItem Value="4" Text="4 Stars — Very Good" />
                    <asp:ListItem Value="3" Text="3 Stars — Average" />
                    <asp:ListItem Value="2" Text="2 Stars — Poor" />
                    <asp:ListItem Value="1" Text="1 Star — Terrible" />
                  </asp:DropDownList>
                </div>
                <div class="col-12">
                  <label for="<%= txtReviewText.ClientID %>">Comments</label>
                  <asp:TextBox ID="txtReviewText" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Share your experience..." />
                </div>
                <div class="col-12 text-end">
                  <asp:Button ID="btnSubmitReview" runat="server" CssClass="btn-gold btn-sm py-1 px-3" Text="Submit Review" OnClick="btnSubmitReview_Click" style="font-size:0.75rem;" />
                </div>
              </div>
            </div>

            <!-- Reviews list -->
            <div class="d-flex flex-column gap-3">
              <asp:Repeater ID="rptReviews" runat="server">
                <ItemTemplate>
                  <div class="review-card p-3" style="background:#141414; border: 1px solid rgba(255,255,255,0.04); border-radius: 8px;">
                    <div class="d-flex justify-content-between">
                      <strong style="color:#FFF;"><%# Eval("FullName") %></strong>
                      <span class="stars" style="font-size:0.75rem;">
                        <%# GetStarsHtml(Convert.ToInt32(Eval("Rating"))) %>
                      </span>
                    </div>
                    <small class="text-muted d-block mb-2"><%# Convert.ToDateTime(Eval("CreatedDate")).ToString("MMMM dd, yyyy") %></small>
                    <p class="text-light mb-0" style="font-size:0.88rem; line-height:1.5;"><%# Eval("ReviewText") %></p>
                  </div>
                </ItemTemplate>
              </asp:Repeater>
              
              <asp:Panel ID="pnlNoReviews" runat="server" Visible="false" CssClass="text-center py-4" style="background:#141414; border-radius:8px;">
                <p class="text-muted mb-0" style="font-size:0.85rem;">No reviews yet. Be the first to share your thoughts!</p>
              </asp:Panel>
            </div>
          </div>
        </div>
      </asp:Panel>

      <!-- Error Panel -->
      <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="text-center py-5 glass-card" style="border: 1px solid rgba(201,168,76,0.15);">
        <i class="fas fa-exclamation-triangle text-warning mb-3" style="font-size:3rem;"></i>
        <h3 style="font-family:'Cormorant Garamond',serif; color:#fff;">Timepiece Not Found</h3>
        <p class="text-muted" style="font-size:0.9rem;">The requested product could not be loaded or does not exist.</p>
        <a href="<%= ResolveUrl("~/Pages/Watches.aspx") %>" class="btn-gold mt-3">Return to Shop</a>
      </asp:Panel>
    </div>
  </section>
</asp:Content>
