<%@ Page Title="Register - CYPHER" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="CYPHER.Pages.Register" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <section class="section-pad d-flex align-items-center justify-content-center" style="min-height: 80vh; background: radial-gradient(circle at center, #141414 0%, #0A0A0A 100%);">
    <div class="container">
      <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6 col-xl-5">
          <div class="glass-card p-4 p-md-5" style="border: 1px solid rgba(201,168,76,0.18); box-shadow: var(--shadow-card);">
            <div class="text-center mb-4">
              <h2 style="font-family:'Cormorant Garamond',serif; color:#C9A84C; font-size:2.2rem; margin:0;">Create Account</h2>
              <p class="text-muted" style="font-size:0.85rem; margin-top:0.4rem;">Join the CYPHER circle of collectors</p>
              <div class="title-line mx-auto" style="width: 40px;"></div>
            </div>

            <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-danger bg-dark text-danger border-danger mb-4" style="border-color: rgba(231, 76, 60, 0.3) !important; font-size: 0.85rem;">
              <i class="fas fa-exclamation-circle me-2"></i> <asp:Label ID="lblError" runat="server" />
            </asp:Panel>

            <div class="form-cypher row g-3">
              <div class="col-12">
                <label for="<%= txtFullName.ClientID %>">Full Name *</label>
                <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" placeholder="e.g. John Doe" />
              </div>

              <div class="col-12">
                <label for="<%= txtEmail.ClientID %>">Email Address *</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="e.g. john@example.com" TextMode="Email" />
              </div>

              <div class="col-12">
                <label for="<%= txtPhone.ClientID %>">Phone Number</label>
                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="e.g. +91 98765 43210" />
              </div>

              <div class="col-md-6">
                <label for="<%= txtPassword.ClientID %>">Password *</label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Min. 6 characters" />
              </div>

              <div class="col-md-6">
                <label for="<%= txtConfirmPassword.ClientID %>">Confirm Password *</label>
                <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="••••••••" />
              </div>

              <div class="col-12 mt-3">
                <asp:Button ID="btnRegister" runat="server" CssClass="btn-gold w-100" Text="Create Account" OnClick="btnRegister_Click" />
              </div>

              <div class="text-center mt-4 pt-2" style="border-top: 1px solid rgba(255,255,255,0.06);">
                <p class="text-muted mb-0" style="font-size: 0.85rem;">
                  Already have an account? <a href="<%= ResolveUrl("~/Pages/Login.aspx") %>" style="color: #C9A84C; font-weight: 500;">Sign In</a>
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</asp:Content>
