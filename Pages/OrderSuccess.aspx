<%@ Page Title="Order Confirmed - CYPHER" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="OrderSuccess.aspx.cs" Inherits="CYPHER.Pages.OrderSuccess" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <section class="section-pad d-flex align-items-center justify-content-center" style="min-height: 80vh; background: radial-gradient(circle at center, #141414 0%, #0A0A0A 100%);">
    <div class="container text-center">
      <div class="row justify-content-center">
        <div class="col-md-7 col-lg-6">
          <div class="glass-card p-5" style="border: 1px solid rgba(46, 204, 113, 0.25); box-shadow: 0 8px 40px rgba(46, 204, 113, 0.08);">
            <!-- Icon -->
            <div class="d-inline-flex align-items-center justify-content-center bg-dark mb-4" style="width: 80px; height: 80px; border-radius:50%; border:2px solid #2ecc71;">
              <i class="fas fa-check text-success" style="font-size: 2.2rem;"></i>
            </div>

            <h2 style="font-family:'Cormorant Garamond',serif; color:#FFF; font-size:2.6rem; font-weight:300;">Order Confirmed</h2>
            <p class="text-muted" style="font-size:0.9rem;">Thank you for your purchase. Your invoice has been generated.</p>
            <div class="title-line mx-auto" style="width: 50px; background: linear-gradient(90deg, #2ecc71, transparent);"></div>

            <!-- Receipt Info -->
            <div class="glass-card p-4 my-4 text-start" style="background:rgba(0,0,0,0.2); border:1px solid rgba(255,255,255,0.04); font-size:0.88rem;">
              <div class="d-flex justify-content-between mb-2">
                <span class="text-muted">Order Reference:</span>
                <strong style="color:#FFF;">#CYPHER-<asp:Label ID="lblOrderID" runat="server" /></strong>
              </div>
              <div class="d-flex justify-content-between mb-2">
                <span class="text-muted">Order Date:</span>
                <span style="color:#FFF;"><asp:Label ID="lblDate" runat="server" /></span>
              </div>
              <div class="d-flex justify-content-between mb-2">
                <span class="text-muted">Payment Method:</span>
                <span style="color:#FFF;"><asp:Label ID="lblPayment" runat="server" /></span>
              </div>
              <div class="d-flex justify-content-between mb-2">
                <span class="text-muted">Delivery Estimate:</span>
                <span class="text-warning">2 – 4 Business Days</span>
              </div>
              <hr style="border-color:rgba(255,255,255,0.08);" />
              <div class="d-flex justify-content-between">
                <strong style="color:#FFF;">Paid Amount:</strong>
                <strong style="color:#C9A84C; font-size:1.1rem;">₹<asp:Label ID="lblTotal" runat="server" /></strong>
              </div>
            </div>

            <div class="d-flex gap-3">
              <a href="<%= ResolveUrl("~/Pages/Watches.aspx") %>" class="btn-outline-gold flex-grow-1 text-center py-2" style="font-size:0.8rem; letter-spacing:1px;">Continue Shopping</a>
              <a href="<%= ResolveUrl("~/Pages/Dashboard.aspx?tab=orders") %>" class="btn-gold flex-grow-1 text-center py-2" style="font-size:0.8rem; letter-spacing:1px;">Track Order</a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</asp:Content>
