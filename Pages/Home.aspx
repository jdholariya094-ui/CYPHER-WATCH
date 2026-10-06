<%@ Page Title="Home" Language="C#" MasterPageFile="~/MasterPages/Site.Master"
         AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="CYPHER.Pages.Home" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
  <style>
    .brand-logo-card{background:#141414;border:1px solid rgba(255,255,255,.06);border-radius:12px;
      padding:1.5rem;display:flex;align-items:center;justify-content:center;transition:all .3s;}
    .brand-logo-card:hover{border-color:rgba(201,168,76,.4);transform:translateY(-4px);}
    .review-card{background:#141414;border:1px solid rgba(255,255,255,.06);border-radius:12px;padding:1.8rem;}
    .collection-card{position:relative;border-radius:12px;overflow:hidden;aspect-ratio:4/3;}
    .collection-card img{width:100%;height:100%;object-fit:cover;transition:transform .5s;}
    .collection-card:hover img{transform:scale(1.08);}
    .collection-overlay{position:absolute;inset:0;background:linear-gradient(to top,rgba(0,0,0,.8),transparent);
      display:flex;flex-direction:column;justify-content:flex-end;padding:1.5rem;}
    .why-icon{width:60px;height:60px;background:rgba(201,168,76,.1);border-radius:12px;
      display:flex;align-items:center;justify-content:center;font-size:1.5rem;color:#C9A84C;margin-bottom:1rem;}
    .gallery-img{aspect-ratio:1;object-fit:cover;width:100%;border-radius:8px;
      cursor:pointer;transition:all .3s;filter:grayscale(20%);}
    .gallery-img:hover{filter:grayscale(0);transform:scale(1.02);}
  </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

  <!-- ===== HERO ===== -->
  <section class="hero-section">
    <div class="container">
      <div class="row align-items-center min-vh-100">
        <div class="col-lg-6 hero-content">
          <p class="hero-eyebrow">Premium Luxury Timepieces</p>
          <h1 class="hero-title">Time Defines<br/><span class="accent">Style</span></h1>
          <div class="hero-divider"></div>
          <p class="hero-subtitle">Luxury Watches Crafted for Excellence. Discover masterpieces from the world's finest watchmakers.</p>
          <div class="hero-buttons d-flex gap-3 flex-wrap">
            <a href="<%= ResolveUrl("~/Pages/Watches.aspx") %>" class="btn-gold">
              <span><i class="fas fa-shopping-bag me-2"></i>Shop Now</span>
            </a>
            <a href="<%= ResolveUrl("~/Pages/Collections.aspx") %>" class="btn-outline-gold">
              <i class="fas fa-compass me-2"></i>Explore Collection
            </a>
          </div>
        </div>
        <div class="col-lg-6 d-none d-lg-flex justify-content-center align-items-center">
          <div class="hero-watch-wrapper">
            <div class="hero-watch-glow"></div>
            <div class="hero-watch-ring-outer"></div>
            <div class="hero-watch-ring-inner"></div>
            <div class="hero-badge hero-badge-top">
              <i class="fas fa-certificate text-gold me-1"></i> Swiss Chronometer
            </div>
            <div class="hero-watch-img-container">
              <img src='<%= ResolveUrl("~/Content/images/watches/watch_hero.jpg") %>'
                   alt="CYPHER Luxury Watch" />
            </div>
            <div class="hero-badge hero-badge-bottom">
              <div class="badge-title">AUTOMATIC</div>
              <div class="badge-sub">Limited Production</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- ===== STATS ===== -->
  <section class="stats-section" style="background:#0D0D0D;padding:3rem 0;border-top:1px solid rgba(201,168,76,.1);">
    <div class="container">
      <div class="row g-3 text-center">
        <div class="col-6 col-md-3">
          <div class="stat-card reveal">
            <div class="stat-number"><span data-count="10000">0</span>+</div>
            <div class="stat-label">Happy Customers</div>
          </div>
        </div>
        <div class="col-6 col-md-3">
          <div class="stat-card reveal delay-1">
            <div class="stat-number"><span data-count="500">0</span>+</div>
            <div class="stat-label">Watch Models</div>
          </div>
        </div>
        <div class="col-6 col-md-3">
          <div class="stat-card reveal delay-2">
            <div class="stat-number"><span data-count="50">0</span>+</div>
            <div class="stat-label">Premium Brands</div>
          </div>
        </div>
        <div class="col-6 col-md-3">
          <div class="stat-card reveal delay-3">
            <div class="stat-number"><span data-count="15">0</span>+</div>
            <div class="stat-label">Years of Excellence</div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- ===== FEATURED WATCHES ===== -->
  <section class="section-pad">
    <div class="container">
      <div class="text-center mb-5 reveal">
        <p class="section-eyebrow">Handpicked For You</p>
        <h2 class="section-title">Featured Watches</h2>
        <div class="title-line mx-auto"></div>
        <p class="section-subtitle mx-auto">Exceptional timepieces selected by our experts for the discerning collector.</p>
      </div>
      <div class="row g-4">
        <asp:Repeater ID="rptFeatured" runat="server">
          <ItemTemplate>
            <div class="col-sm-6 col-lg-3 reveal">
              <div class="product-card hover-lift">
                <div class="product-card-img">
                  <img src='<%# Eval("ImageURL") %>' alt='<%# Eval("ProductName") %>' loading="lazy" onerror="this.onerror=null;this.src=window.CYPHER_FALLBACK_IMG||'/Content/images/watches/watch_hero.jpg';" />
                  <div class="product-card-overlay">
                    <button class="overlay-btn quick-view-btn" data-pid='<%# Eval("ProductID") %>' title="Quick View">
                      <i class="fas fa-eye"></i>
                    </button>
                    <button class="overlay-btn wishlist-toggle" title="Wishlist">
                      <i class="far fa-heart"></i>
                    </button>
                  </div>
                  <%# Convert.ToDecimal(Eval("DiscountPercent")) > 0 ?
                      string.Format("<span class='product-badge sale'>{0}% OFF</span>", Eval("DiscountPercent")) :
                      Convert.ToBoolean(Eval("IsNewArrival")) ?
                      "<span class='product-badge new'>NEW</span>" : "" %>
                </div>
                <div class="product-card-body">
                  <div class="product-brand"><%# Eval("BrandName") %></div>
                  <div class="product-name"><%# Eval("ProductName") %></div>
                  <div class="product-rating">
                    <%# GetStars(Convert.ToDecimal(Eval("Rating"))) %>
                    <span class="count">(<%# Eval("ReviewCount") %>)</span>
                  </div>
                  <div class="product-price">
                    <%# Convert.ToDecimal(Eval("DiscountPercent")) > 0 ?
                        string.Format("<span class='price-original'>₹{0:N0}</span>", Convert.ToDecimal(Eval("Price"))) : "" %>
                    <span class="price-current">₹<%# GetDiscountedPrice(Convert.ToDecimal(Eval("Price")), Convert.ToDecimal(Eval("DiscountPercent"))) %></span>
                  </div>
                  <div class="product-card-actions">
                    <a href='<%# ResolveUrl("~/Pages/ProductDetail.aspx?id=" + Eval("ProductID")) %>'
                       class="btn-cart-sm">View Details</a>
                  </div>
                </div>
              </div>
            </div>
          </ItemTemplate>
        </asp:Repeater>
      </div>
      <div class="text-center mt-5">
        <a href="<%= ResolveUrl("~/Pages/Watches.aspx") %>" class="btn-outline-gold">View All Watches</a>
      </div>
    </div>
  </section>

  <!-- ===== COLLECTIONS ===== -->
  <section class="section-pad" style="background:#0D0D0D;">
    <div class="container">
      <div class="text-center mb-5 reveal">
        <p class="section-eyebrow">Curated For Excellence</p>
        <h2 class="section-title">Luxury Collections</h2>
        <div class="title-line mx-auto"></div>
      </div>
      <div class="row g-4">
        <div class="col-md-4 reveal">
          <a href="<%= ResolveUrl("~/Pages/Collections.aspx?cat=1") %>" class="collection-card d-block text-decoration-none">
            <img src='<%= ResolveUrl("~/Content/images/watches/watch_luxury_gold.jpg") %>' alt="Luxury Collection" />
            <div class="collection-overlay">
              <span style="color:#C9A84C;font-size:.7rem;letter-spacing:3px;text-transform:uppercase;">Premium</span>
              <h3 style="font-family:'Cormorant Garamond',serif;color:#fff;font-size:1.8rem;margin:0;">Luxury</h3>
              <span style="color:#C0C0C0;font-size:.82rem;">Explore &rarr;</span>
            </div>
          </a>
        </div>
        <div class="col-md-4 reveal delay-1">
          <a href="<%= ResolveUrl("~/Pages/Collections.aspx?cat=3") %>" class="collection-card d-block text-decoration-none">
            <img src='<%= ResolveUrl("~/Content/images/watches/watch_tag_monaco.jpg") %>' alt="Sports Collection" />
            <div class="collection-overlay">
              <span style="color:#C9A84C;font-size:.7rem;letter-spacing:3px;text-transform:uppercase;">Performance</span>
              <h3 style="font-family:'Cormorant Garamond',serif;color:#fff;font-size:1.8rem;margin:0;">Sports</h3>
              <span style="color:#C0C0C0;font-size:.82rem;">Explore &rarr;</span>
            </div>
          </a>
        </div>
        <div class="col-md-4 reveal delay-2">
          <a href="<%= ResolveUrl("~/Pages/Collections.aspx?cat=5") %>" class="collection-card d-block text-decoration-none">
            <img src='<%= ResolveUrl("~/Content/images/watches/watch_hero.jpg") %>' alt="Limited Edition" />
            <div class="collection-overlay">
              <span style="color:#C9A84C;font-size:.7rem;letter-spacing:3px;text-transform:uppercase;">Exclusive</span>
              <h3 style="font-family:'Cormorant Garamond',serif;color:#fff;font-size:1.8rem;margin:0;">Limited Edition</h3>
              <span style="color:#C0C0C0;font-size:.82rem;">Explore &rarr;</span>
            </div>
          </a>
        </div>
      </div>
    </div>
  </section>

  <!-- ===== NEW ARRIVALS ===== -->
  <section class="section-pad">
    <div class="container">
      <div class="d-flex align-items-center justify-content-between mb-5">
        <div>
          <p class="section-eyebrow mb-1">Just Landed</p>
          <h2 class="section-title mb-0">New Arrivals</h2>
          <div class="title-line"></div>
        </div>
        <a href="<%= ResolveUrl("~/Pages/Watches.aspx?sort=Newest") %>" class="btn-outline-gold d-none d-md-block">View All</a>
      </div>
      <div class="row g-4">
        <asp:Repeater ID="rptNewArrivals" runat="server">
          <ItemTemplate>
            <div class="col-sm-6 col-lg-3 reveal">
              <div class="product-card hover-lift">
                <div class="product-card-img">
                  <img src='<%# Eval("ImageURL") %>' alt='<%# Eval("ProductName") %>' loading="lazy" onerror="this.onerror=null;this.src=window.CYPHER_FALLBACK_IMG||'/Content/images/watches/watch_hero.jpg';" />
                  <span class="product-badge new">NEW</span>
                  <div class="product-card-overlay">
                    <button class="overlay-btn quick-view-btn" data-pid='<%# Eval("ProductID") %>' title="Quick View">
                      <i class="fas fa-eye"></i>
                    </button>
                  </div>
                </div>
                <div class="product-card-body">
                  <div class="product-brand"><%# Eval("BrandName") %></div>
                  <div class="product-name"><%# Eval("ProductName") %></div>
                  <div class="product-price">
                    <span class="price-current">₹<%# GetDiscountedPrice(Convert.ToDecimal(Eval("Price")), Convert.ToDecimal(Eval("DiscountPercent"))) %></span>
                  </div>
                  <div class="product-card-actions">
                    <a href='<%# ResolveUrl("~/Pages/ProductDetail.aspx?id=" + Eval("ProductID")) %>' class="btn-cart-sm">View Details</a>
                  </div>
                </div>
              </div>
            </div>
          </ItemTemplate>
        </asp:Repeater>
      </div>
    </div>
  </section>

  <!-- ===== BEST SELLERS ===== -->
  <section class="section-pad" style="background:#0D0D0D;">
    <div class="container">
      <div class="text-center mb-5 reveal">
        <p class="section-eyebrow">Most Loved</p>
        <h2 class="section-title">Best Sellers</h2>
        <div class="title-line mx-auto"></div>
      </div>
      <div class="row g-4">
        <asp:Repeater ID="rptBestSellers" runat="server">
          <ItemTemplate>
            <div class="col-sm-6 col-lg-3 reveal">
              <div class="product-card hover-lift">
                <div class="product-card-img">
                  <img src='<%# Eval("ImageURL") %>' alt='<%# Eval("ProductName") %>' loading="lazy" onerror="this.onerror=null;this.src=window.CYPHER_FALLBACK_IMG||'/Content/images/watches/watch_hero.jpg';" />
                  <span class="product-badge hot">HOT</span>
                  <div class="product-card-overlay">
                    <button class="overlay-btn quick-view-btn" data-pid='<%# Eval("ProductID") %>' title="Quick View">
                      <i class="fas fa-eye"></i>
                    </button>
                  </div>
                </div>
                <div class="product-card-body">
                  <div class="product-brand"><%# Eval("BrandName") %></div>
                  <div class="product-name"><%# Eval("ProductName") %></div>
                  <div class="product-rating"><%# GetStars(Convert.ToDecimal(Eval("Rating"))) %></div>
                  <div class="product-price">
                    <span class="price-current">₹<%# GetDiscountedPrice(Convert.ToDecimal(Eval("Price")), Convert.ToDecimal(Eval("DiscountPercent"))) %></span>
                  </div>
                  <div class="product-card-actions">
                    <a href='<%# ResolveUrl("~/Pages/ProductDetail.aspx?id=" + Eval("ProductID")) %>' class="btn-cart-sm">Buy Now</a>
                  </div>
                </div>
              </div>
            </div>
          </ItemTemplate>
        </asp:Repeater>
      </div>
    </div>
  </section>

  <!-- ===== FEATURED BRANDS ===== -->
  <section class="section-pad">
    <div class="container">
      <div class="text-center mb-5 reveal">
        <p class="section-eyebrow">Our Partners</p>
        <h2 class="section-title">Featured Brands</h2>
        <div class="title-line mx-auto"></div>
      </div>
      <div class="row g-3 justify-content-center">
        <asp:Repeater ID="rptBrands" runat="server">
          <ItemTemplate>
            <div class="col-6 col-md-4 col-lg-3 reveal">
              <a href='<%# ResolveUrl("~/Pages/Brands.aspx?id=" + Eval("BrandID")) %>' class="text-decoration-none">
                <div class="brand-logo-card">
                  <span style="font-family:'Cormorant Garamond',serif;font-size:1.4rem;
                                color:#C9A84C;letter-spacing:3px;font-weight:600;">
                    <%# Eval("BrandName") %>
                  </span>
                </div>
              </a>
            </div>
          </ItemTemplate>
        </asp:Repeater>
      </div>
    </div>
  </section>

  <!-- ===== WHY CHOOSE US ===== -->
  <section class="section-pad" style="background:#0D0D0D;">
    <div class="container">
      <div class="text-center mb-5 reveal">
        <p class="section-eyebrow">Our Promise</p>
        <h2 class="section-title">Why Choose CYPHER</h2>
        <div class="title-line mx-auto"></div>
      </div>
      <div class="row g-4 text-center">
        <div class="col-md-6 col-lg-3 reveal">
          <div class="why-icon mx-auto"><i class="fas fa-shield-alt"></i></div>
          <h5 style="font-family:'Cormorant Garamond',serif;color:#F5F5F5;font-size:1.2rem;">100% Authentic</h5>
          <p style="color:#666;font-size:.85rem;">Every watch is certified genuine with official brand warranty.</p>
        </div>
        <div class="col-md-6 col-lg-3 reveal delay-1">
          <div class="why-icon mx-auto"><i class="fas fa-shipping-fast"></i></div>
          <h5 style="font-family:'Cormorant Garamond',serif;color:#F5F5F5;font-size:1.2rem;">Free Shipping</h5>
          <p style="color:#666;font-size:.85rem;">Complimentary insured delivery on orders above ₹5,000.</p>
        </div>
        <div class="col-md-6 col-lg-3 reveal delay-2">
          <div class="why-icon mx-auto"><i class="fas fa-undo-alt"></i></div>
          <h5 style="font-family:'Cormorant Garamond',serif;color:#F5F5F5;font-size:1.2rem;">Easy Returns</h5>
          <p style="color:#666;font-size:.85rem;">Hassle-free 30-day returns with no questions asked.</p>
        </div>
        <div class="col-md-6 col-lg-3 reveal delay-3">
          <div class="why-icon mx-auto"><i class="fas fa-headset"></i></div>
          <h5 style="font-family:'Cormorant Garamond',serif;color:#F5F5F5;font-size:1.2rem;">24/7 Support</h5>
          <p style="color:#666;font-size:.85rem;">Expert concierge support for every query, any time.</p>
        </div>
      </div>
    </div>
  </section>

  <!-- ===== CUSTOMER REVIEWS ===== -->
  <section class="section-pad">
    <div class="container">
      <div class="text-center mb-5 reveal">
        <p class="section-eyebrow">Testimonials</p>
        <h2 class="section-title">What Customers Say</h2>
        <div class="title-line mx-auto"></div>
      </div>
      <div id="reviewCarousel" class="carousel slide" data-bs-ride="carousel">
        <div class="carousel-inner">
          <div class="carousel-item active">
            <div class="row g-4 justify-content-center">
              <div class="col-md-4">
                <div class="review-card reveal">
                  <div class="stars mb-2">★★★★★</div>
                  <p style="color:#C0C0C0;font-size:.9rem;font-style:italic;">"Absolutely breathtaking. My Rolex Submariner arrived in perfect condition. CYPHER's service is world-class."</p>
                  <div style="margin-top:1rem;color:#C9A84C;font-weight:600;">Arjun Mehta</div>
                  <div style="color:#666;font-size:.78rem;">Mumbai</div>
                </div>
              </div>
              <div class="col-md-4">
                <div class="review-card reveal delay-1">
                  <div class="stars mb-2">★★★★★</div>
                  <p style="color:#C0C0C0;font-size:.9rem;font-style:italic;">"The Omega Seamaster I ordered was exactly as described. Delivered in 3 days, beautifully packaged!"</p>
                  <div style="margin-top:1rem;color:#C9A84C;font-weight:600;">Priya Sharma</div>
                  <div style="color:#666;font-size:.78rem;">Delhi</div>
                </div>
              </div>
              <div class="col-md-4 d-none d-md-block">
                <div class="review-card reveal delay-2">
                  <div class="stars mb-2">★★★★☆</div>
                  <p style="color:#C0C0C0;font-size:.9rem;font-style:italic;">"Great collection and authentic products. The team helped me choose the perfect watch as a gift."</p>
                  <div style="margin-top:1rem;color:#C9A84C;font-weight:600;">Vikram Singh</div>
                  <div style="color:#666;font-size:.78rem;">Bangalore</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- ===== NEWSLETTER ===== -->
  <section style="background:linear-gradient(135deg,#0D0D0D,#1A1410,#0D0D0D);
                  border-top:1px solid rgba(201,168,76,.15);border-bottom:1px solid rgba(201,168,76,.15);
                  padding:4rem 0;">
    <div class="container">
      <div class="row justify-content-center text-center">
        <div class="col-lg-6 reveal">
          <p class="section-eyebrow">Exclusive Offers</p>
          <h2 class="section-title">Join the CYPHER Circle</h2>
          <p style="color:#666;font-size:.9rem;margin-bottom:2rem;">
            Subscribe for VIP access to new arrivals, limited editions, and member-only discounts.
          </p>
          <div class="newsletter-input-group" style="max-width:480px;margin:0 auto;">
            <input type="email" id="heroEmail" class="newsletter-input"
                   placeholder="Enter your email address" />
            <button class="newsletter-btn" onclick="subscribeHero(); return false;">
              Subscribe
            </button>
          </div>
          <p style="color:#444;font-size:.75rem;margin-top:.75rem;">
            No spam. Unsubscribe anytime.
          </p>
        </div>
      </div>
    </div>
  </section>

</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="ScriptsContent" runat="server">
  <script>
    function subscribeHero() {
      var e = document.getElementById('heroEmail').value.trim();
      if (!e) return;
      document.getElementById('ctl00_hdnNewsletterEmail').value = e;
      document.getElementById('ctl00_btnSubscribeServer').click();
    }
  </script>
</asp:Content>
