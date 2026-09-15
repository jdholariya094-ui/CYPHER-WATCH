<%@ Page Title="Luxury Brands - CYPHER" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Brands.aspx.cs" Inherits="CYPHER.Pages.Brands" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <section class="section-pad-sm text-center" style="background: linear-gradient(180deg, #111 0%, #0A0A0A 100%); border-bottom: 1px solid rgba(201,168,76,0.15);">
    <div class="container py-4">
      <p class="section-eyebrow mb-2">Heritage</p>
      <h1 class="section-title" style="font-family:'Cormorant Garamond',serif; color:#FFF; font-size:3rem; font-weight:300;">World-Class Watchmakers</h1>
      <div class="title-line mx-auto"></div>
      <p class="text-muted mx-auto" style="max-width: 600px; font-size:1rem;">
        Discover the legendary brands that define precision and elegance. Every watchmaker represents decades of innovation, heritage, and mechanical artistry.
      </p>
    </div>
  </section>

  <section class="section-pad">
    <div class="container">
      <div class="row g-4 justify-content-center">
        <asp:Repeater ID="rptBrands" runat="server">
          <ItemTemplate>
            <div class="col-6 col-md-4 col-lg-3">
              <a href='<%# ResolveUrl("~/Pages/Watches.aspx?brand=" + Eval("BrandID")) %>' class="text-decoration-none d-block">
                <div class="brand-logo-card text-center p-5 glass-card" style="border: 1px solid rgba(201,168,76,0.15); border-radius: 12px; transition: all 0.3s ease; background: #141414;">
                  <h3 style="font-family:'Cormorant Garamond',serif; font-size:1.6rem; color:#C9A84C; letter-spacing:2px; font-weight:500; margin:0;">
                    <%# Eval("BrandName") %>
                  </h3>
                  <span class="text-muted d-block mt-2" style="font-size:0.75rem; letter-spacing:1px; text-transform:uppercase;">Explore Catalog &rarr;</span>
                </div>
              </a>
            </div>
          </ItemTemplate>
        </asp:Repeater>
      </div>
    </div>
  </section>
</asp:Content>
