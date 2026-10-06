<%@ Page Title="Contact Us - CYPHER" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="CYPHER.Pages.Contact" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <section class="section-pad-sm text-center" style="background: linear-gradient(180deg, #111 0%, #0A0A0A 100%); border-bottom: 1px solid rgba(201,168,76,0.15);">
    <div class="container py-4">
      <p class="section-eyebrow mb-2">Connect With Us</p>
      <h1 class="section-title" style="font-family:'Cormorant Garamond',serif; color:#FFF; font-size:3rem; font-weight:300;">Contact Our Specialists</h1>
      <div class="title-line mx-auto"></div>
      <p class="text-muted mx-auto" style="max-width: 600px; font-size:1rem;">
        Have a question about a timepiece, custom order, or service inquiry? Our dedicated team of horological specialists is here to assist you.
      </p>
    </div>
  </section>

  <section class="section-pad">
    <div class="container">
      <div class="row g-5">
        <!-- Contact Form -->
        <div class="col-lg-7">
          <div class="glass-card p-4 p-md-5" style="border: 1px solid rgba(201,168,76,0.15);">
            <h3 style="font-family:'Cormorant Garamond',serif; color:#C9A84C; margin-bottom:1.5rem;">Send Inquiry</h3>
            
            <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="alert alert-success bg-dark text-success border-success mb-4" style="border-color: rgba(46, 204, 113, 0.3) !important;">
              <i class="fas fa-check-circle me-2"></i> Thank you! Your inquiry has been successfully received. A specialist will contact you shortly.
            </asp:Panel>

            <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-danger bg-dark text-danger border-danger mb-4" style="border-color: rgba(231, 76, 60, 0.3) !important;">
              <i class="fas fa-exclamation-circle me-2"></i> <asp:Label ID="lblError" runat="server" />
            </asp:Panel>

            <div class="form-cypher row g-4">
              <div class="col-md-6">
                <label for="<%= txtName.ClientID %>">Full Name *</label>
                <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="e.g. John Doe" />
              </div>
              <div class="col-md-6">
                <label for="<%= txtEmail.ClientID %>">Email Address *</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="e.g. john@example.com" TextMode="Email" />
              </div>
              <div class="col-md-6">
                <label for="<%= txtPhone.ClientID %>">Phone Number</label>
                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="e.g. +91 98765 43210" />
              </div>
              <div class="col-md-6">
                <label for="<%= txtSubject.ClientID %>">Subject *</label>
                <asp:TextBox ID="txtSubject" runat="server" CssClass="form-control" placeholder="e.g. Product Availability" />
              </div>
              <div class="col-12">
                <label for="<%= txtMessage.ClientID %>">Message *</label>
                <asp:TextBox ID="txtMessage" runat="server" CssClass="form-control" placeholder="Describe your request in detail..." TextMode="MultiLine" Rows="5" />
              </div>
              <div class="col-12 text-end">
                <asp:Button ID="btnSubmit" runat="server" CssClass="btn-gold" Text="Submit Inquiry" OnClick="btnSubmit_Click" />
              </div>
            </div>
          </div>
        </div>

        <!-- Info & Details -->
        <div class="col-lg-5">
          <div class="d-flex flex-column gap-4 h-100 justify-content-between">
            <div class="glass-card p-4" style="border: 1px solid rgba(255,255,255,0.06);">
              <h4 style="font-family:'Cormorant Garamond',serif; color:#fff; margin-bottom:1.2rem;">Mumbai Headquarters</h4>
              <p style="color:#aaa; font-size:0.9rem; margin-bottom:1rem;">
                <i class="fas fa-map-marker-alt text-warning me-2"></i> 101, Taj Heritage Chambers, Apollo Bunder, Colaba, Mumbai, Maharashtra 400001, India
              </p>
              <p style="color:#aaa; font-size:0.9rem; margin-bottom:1rem;">
                <i class="fas fa-phone-alt text-warning me-2"></i> +91 98765 43210
              </p>
              <p style="color:#aaa; font-size:0.9rem; margin-bottom:0;">
                <i class="fas fa-envelope text-warning me-2"></i> support@cypherwatch.com
              </p>
            </div>

            <div class="glass-card p-4" style="border: 1px solid rgba(255,255,255,0.06);">
              <h4 style="font-family:'Cormorant Garamond',serif; color:#fff; margin-bottom:1.2rem;">Hours of Operation</h4>
              <ul class="list-unstyled mb-0" style="color:#aaa; font-size:0.9rem;">
                <li class="d-flex justify-content-between mb-2">
                  <span>Monday – Friday</span>
                  <span class="text-warning">10:00 AM – 7:00 PM</span>
                </li>
                <li class="d-flex justify-content-between mb-2">
                  <span>Saturday</span>
                  <span class="text-warning">11:00 AM – 5:00 PM</span>
                </li>
                <li class="d-flex justify-content-between">
                  <span>Sunday</span>
                  <span class="text-danger">Closed</span>
                </li>
              </ul>
            </div>

            <div style="border: 1px solid rgba(201,168,76,0.25); padding: 6px; border-radius: 12px; background: #111; overflow:hidden; position:relative;">
              <img src='<%= ResolveUrl("~/Content/images/watches/watch_rolex_daydate.jpg") %>' alt="CYPHER Flagship Timepiece" class="img-fluid rounded" style="width:100%; height:220px; object-fit:cover;" />
              <div style="position:absolute; bottom:12px; left:16px; background:rgba(0,0,0,0.82); backdrop-filter:blur(6px); padding:4px 10px; border-radius:6px; border:1px solid rgba(201,168,76,0.3);">
                <span style="color:#C9A84C; font-size:0.75rem; font-weight:600; letter-spacing:1px;"><i class="fas fa-gem me-1"></i>CYPHER Flagship Timepiece</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</asp:Content>
