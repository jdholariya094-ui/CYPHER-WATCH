<%@ Page Title="Login - CYPHER" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="CYPHER.Pages.Login" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <section class="section-pad d-flex align-items-center justify-content-center" style="min-height: 80vh; background: radial-gradient(circle at center, #141414 0%, #0A0A0A 100%);">
    <div class="container">
      <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5 col-xl-4">
          <div class="glass-card p-4 p-md-5" style="border: 1px solid rgba(201,168,76,0.18); box-shadow: var(--shadow-card);">
            <div class="text-center mb-4">
              <h2 style="font-family:'Cormorant Garamond',serif; color:#C9A84C; font-size:2.2rem; margin:0;">Welcome Back</h2>
              <p class="text-muted" style="font-size:0.85rem; margin-top:0.4rem;">Access your luxury vault and collections</p>
              <div class="title-line mx-auto" style="width: 40px;"></div>
            </div>

            <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-danger bg-dark text-danger border-danger mb-4" style="border-color: rgba(231, 76, 60, 0.3) !important; font-size: 0.85rem;">
              <i class="fas fa-exclamation-circle me-2"></i> <asp:Label ID="lblError" runat="server" />
            </asp:Panel>

            <div class="form-cypher d-flex flex-column gap-3">
              <div>
                <label for="<%= txtEmail.ClientID %>">Email Address</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="e.g. john@example.com" TextMode="Email" />
              </div>
              
              <div>
                <div class="d-flex justify-content-between align-items-center">
                  <label for="<%= txtPassword.ClientID %>" class="mb-0">Password</label>
                </div>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control mt-1" TextMode="Password" placeholder="••••••••" />
              </div>

              <div class="form-check mt-1">
                <asp:CheckBox ID="chkRemember" runat="server" CssClass="form-check-input" />
                <label class="form-check-label text-muted" for="<%= chkRemember.ClientID %>" style="text-transform:none; font-size:0.8rem; letter-spacing:0;">
                  Remember me on this device
                </label>
              </div>

              <div class="mt-2">
                <asp:Button ID="btnLogin" runat="server" CssClass="btn-gold w-100" Text="Sign In" OnClick="btnLogin_Click" />
              </div>

              <div class="text-center mt-4 pt-2" style="border-top: 1px solid rgba(255,255,255,0.06);">
                <p class="text-muted mb-0" style="font-size: 0.85rem;">
                  New to CYPHER? <a href="<%= ResolveUrl("~/Pages/Register.aspx") %>" style="color: #C9A84C; font-weight: 500;">Create an Account</a>
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</asp:Content>
