<%@ Page Title="Luxury Collections - CYPHER" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Collections.aspx.cs" Inherits="CYPHER.Pages.Collections" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <section class="section-pad-sm text-center" style="background: linear-gradient(180deg, #111 0%, #0A0A0A 100%); border-bottom: 1px solid rgba(201,168,76,0.15);">
    <div class="container py-4">
      <p class="section-eyebrow mb-2">Curated Categories</p>
      <h1 class="section-title" style="font-family:'Cormorant Garamond',serif; color:#FFF; font-size:3rem; font-weight:300;">The Collections</h1>
      <div class="title-line mx-auto"></div>
      <p class="text-muted mx-auto" style="max-width: 600px; font-size:1rem;">
        Explore our curated watch collections. Each classification is designed for distinct tastes, lifestyles, and occasions.
      </p>
    </div>
  </section>

  <section class="section-pad">
    <div class="container">
      <div class="row g-4 justify-content-center">
        <asp:Repeater ID="rptCollections" runat="server">
          <ItemTemplate>
            <div class="col-md-6 col-lg-4">
              <a href='<%# ResolveUrl("~/Pages/Watches.aspx?cat=" + Eval("CategoryID")) %>' class="collection-card d-block text-decoration-none" style="position:relative; border-radius:12px; overflow:hidden; border:1px solid rgba(255,255,255,0.06); transition: all 0.3s ease;">
                <img src='https://placehold.co/600x450/0A0A0A/C9A84C?text=<%# Server.UrlEncode(Eval("CategoryName").ToString()) %>' alt='<%# Eval("CategoryName") %>' style="width:100%; transition: transform 0.5s ease; object-fit: cover;" />
                <div class="collection-overlay" style="position:absolute; inset:0; background: linear-gradient(to top, rgba(0,0,0,0.95) 0%, rgba(0,0,0,0.4) 60%, transparent 100%); display:flex; flex-column; justify-content:end; padding:2rem; transition: all 0.3s ease;">
                  <span style="color:#C9A84C; font-size:.7rem; letter-spacing:3px; text-transform:uppercase; font-weight:600;">Collection</span>
                  <h3 style="font-family:'Cormorant Garamond',serif; color:#fff; font-size:1.8rem; margin: 0.2rem 0 0.6rem 0;">
                    <%# Eval("CategoryName") %>
                  </h3>
                  <span style="color:#C0C0C0; font-size:.82rem;">Explore Catalog &rarr;</span>
                </div>
              </a>
            </div>
          </ItemTemplate>
        </asp:Repeater>
      </div>
    </div>
  </section>
</asp:Content>
