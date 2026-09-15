<%@ Page Title="About Us - CYPHER" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="CYPHER.Pages.About" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <!-- Hero Section -->
  <section class="section-pad-sm text-center" style="background: linear-gradient(180deg, #111 0%, #0A0A0A 100%); border-bottom: 1px solid rgba(201,168,76,0.15);">
    <div class="container py-4">
      <p class="section-eyebrow mb-2">Our Legacy</p>
      <h1 class="section-title" style="font-family:'Cormorant Garamond',serif; color:#FFF; font-size:3rem; font-weight:300;">Crafting Time, Defining Elegance</h1>
      <div class="title-line mx-auto"></div>
      <p class="text-muted mx-auto" style="max-width: 600px; font-size:1rem;">
        CYPHER has stood as the pinnacle of horological excellence, curating the world's most sought-after watches for collectors who value precision, heritage, and distinction.
      </p>
    </div>
  </section>

  <!-- Story Section -->
  <section class="section-pad">
    <div class="container">
      <div class="row align-items-center g-5">
        <div class="col-lg-6">
          <div style="border: 1px solid rgba(201,168,76,0.2); padding: 10px; border-radius: 12px; background: #111;">
            <img src="https://placehold.co/800x600/0A0A0A/C9A84C?text=Horological+Craftsmanship" alt="Watchmaking" class="img-fluid rounded" style="opacity: 0.85;" />
          </div>
        </div>
        <div class="col-lg-6">
          <p class="section-eyebrow mb-2">Our Story</p>
          <h2 style="font-family:'Cormorant Garamond',serif; color:#C9A84C; font-size:2.2rem; margin-bottom:1.5rem;">The Pursuit of Horological Perfection</h2>
          <p style="color:#ccc; font-size:0.95rem; line-height:1.8;">
            Founded by a collective of master watchmakers and vintage timepiece collectors, CYPHER was born out of a desire to bridge the gap between historic craftsmanship and contemporary luxury. Every timepiece in our inventory is hand-selected and strictly evaluated by our experts.
          </p>
          <p style="color:#ccc; font-size:0.95rem; line-height:1.8;">
            Whether it is the engineering marvel of a Swiss tourbillon, the robust dependability of a professional diver, or the classic beauty of an heirloom dress watch, we assure authenticity, reliability, and unparalleled service.
          </p>
          <div class="row g-4 mt-3">
            <div class="col-sm-6">
              <div class="d-flex align-items-center gap-3">
                <i class="fas fa-certificate text-warning" style="font-size: 1.5rem;"></i>
                <div>
                  <h4 style="font-size: 1rem; color:#fff; margin:0;">100% Authentic</h4>
                  <small style="color:#888;">Certified watchmakers</small>
                </div>
              </div>
            </div>
            <div class="col-sm-6">
              <div class="d-flex align-items-center gap-3">
                <i class="fas fa-shield-alt text-warning" style="font-size: 1.5rem;"></i>
                <div>
                  <h4 style="font-size: 1rem; color:#fff; margin:0;">Extended Warranty</h4>
                  <small style="color:#888;">Complete peace of mind</small>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- Showcase / Gallery -->
  <section class="section-pad" style="background:#0F0F0F; border-top: 1px solid rgba(255,255,255,0.05); border-bottom: 1px solid rgba(255,255,255,0.05);">
    <div class="container">
      <div class="text-center mb-5">
        <p class="section-eyebrow mb-1">Curation</p>
        <h2 class="section-title">The Showrooms</h2>
        <div class="title-line mx-auto"></div>
      </div>
      <div class="row g-4">
        <div class="col-md-4">
          <div class="card bg-dark border-0 overflow-hidden" style="border-radius:12px; group-hover:transform;">
            <img src="https://placehold.co/600x450/141414/C9A84C?text=Geneva+Salon" class="card-img" alt="Geneva" style="opacity:0.75;" />
            <div class="card-img-overlay d-flex flex-column justify-content-end bg-gradient-dark" style="background: linear-gradient(180deg, transparent 50%, rgba(0,0,0,0.9) 100%);">
              <h4 style="color:#fff; font-family:'Cormorant Garamond',serif; margin:0;">Geneva Salon</h4>
              <p style="color:#C9A84C; font-size:0.75rem; letter-spacing:1px; margin:0;">SWITZERLAND</p>
            </div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="card bg-dark border-0 overflow-hidden" style="border-radius:12px;">
            <img src="https://placehold.co/600x450/141414/C9A84C?text=London+Gallery" class="card-img" alt="London" style="opacity:0.75;" />
            <div class="card-img-overlay d-flex flex-column justify-content-end bg-gradient-dark" style="background: linear-gradient(180deg, transparent 50%, rgba(0,0,0,0.9) 100%);">
              <h4 style="color:#fff; font-family:'Cormorant Garamond',serif; margin:0;">London Gallery</h4>
              <p style="color:#C9A84C; font-size:0.75rem; letter-spacing:1px; margin:0;">UNITED KINGDOM</p>
            </div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="card bg-dark border-0 overflow-hidden" style="border-radius:12px;">
            <img src="https://placehold.co/600x450/141414/C9A84C?text=Mumbai+Boutique" class="card-img" alt="Mumbai" style="opacity:0.75;" />
            <div class="card-img-overlay d-flex flex-column justify-content-end bg-gradient-dark" style="background: linear-gradient(180deg, transparent 50%, rgba(0,0,0,0.9) 100%);">
              <h4 style="color:#fff; font-family:'Cormorant Garamond',serif; margin:0;">Mumbai Boutique</h4>
              <p style="color:#C9A84C; font-size:0.75rem; letter-spacing:1px; margin:0;">INDIA</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</asp:Content>
