<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminLogin.aspx.cs" Inherits="CYPHER.Admin.AdminLogin" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Authentication — CYPHER Luxury Watches</title>
    <!-- Bootstrap 5 CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" />
    <!-- Font Awesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@400;500;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <!-- Admin CSS -->
    <link rel="stylesheet" href="<%= ResolveUrl("~/Content/css/admin.css?v=2.5") %>" />
    <style>
        .login-crest {
            width: 58px;
            height: 58px;
            border-radius: 50%;
            background: rgba(201,168,76,0.12);
            border: 1px solid rgba(201,168,76,0.3);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.25rem;
            color: var(--admin-gold);
            font-size: 1.5rem;
        }
        .form-floating-custom {
            position: relative;
            margin-bottom: 1.25rem;
        }
        .form-floating-custom input {
            width: 100%;
            background: #111;
            border: 1px solid rgba(255,255,255,0.12);
            border-radius: 8px;
            padding: 0.85rem 1rem 0.85rem 2.8rem;
            color: #F5F5F5;
            font-size: 0.9rem;
            transition: all 0.2s;
        }
        .form-floating-custom input:focus {
            border-color: var(--admin-gold);
            box-shadow: 0 0 0 3px rgba(201,168,76,0.15);
            outline: none;
            background: #141414;
        }
        .form-floating-custom i.input-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #666;
            font-size: 0.95rem;
        }
        .demo-box {
            background: rgba(255,255,255,0.03);
            border: 1px dashed rgba(201,168,76,0.25);
            border-radius: 8px;
            padding: 0.75rem 1rem;
            margin-top: 1.5rem;
            font-size: 0.78rem;
            color: #888;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
    </style>
</head>
<body class="admin-login-page">
    <form id="form1" runat="server">
        <div class="admin-login-card">
            <div class="text-center mb-4">
                <div class="login-crest">
                    <i class="fas fa-shield-alt"></i>
                </div>
                <h2 style="font-family:'Cormorant Garamond',serif; color:var(--admin-gold); font-size:2rem; letter-spacing:3px; margin-bottom:0.25rem;">
                    CYPHER
                </h2>
                <div style="font-size:0.75rem; letter-spacing:2px; text-transform:uppercase; color:#777;">
                    Executive Management Portal
                </div>
            </div>

            <!-- Error message panel -->
            <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="admin-alert admin-alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <div><asp:Label ID="lblError" runat="server" /></div>
            </asp:Panel>

            <!-- Success / info panel -->
            <asp:Panel ID="pnlInfo" runat="server" Visible="false" CssClass="admin-alert admin-alert-info">
                <i class="fas fa-info-circle"></i>
                <div><asp:Label ID="lblInfo" runat="server" /></div>
            </asp:Panel>

            <div class="form-floating-custom">
                <i class="fas fa-user-shield input-icon"></i>
                <asp:TextBox ID="txtUsername" runat="server" placeholder="Administrator Username" autocomplete="username" />
            </div>

            <div class="form-floating-custom">
                <i class="fas fa-lock input-icon"></i>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Security Password" autocomplete="current-password" />
            </div>

            <div class="d-flex align-items-center justify-content-between mb-4">
                <label class="d-flex align-items-center gap-2" style="font-size:0.8rem; color:#888; cursor:pointer; margin:0;">
                    <asp:CheckBox ID="chkRemember" runat="server" /> Remember workstation
                </label>
                <a href="<%= ResolveUrl("~/Pages/Home.aspx") %>" style="font-size:0.8rem; color:#888;">
                    ← Storefront
                </a>
            </div>

            <asp:Button ID="btnLogin" runat="server" Text="Sign In to Portal" OnClick="btnLogin_Click" CssClass="btn-admin-primary w-100 justify-content-center" style="padding:0.75rem; font-size:0.9rem;" />

            <div class="demo-box">
                <div>
                    <span style="color:#C9A84C; font-weight:600;">Default Credentials:</span><br />
                    <span>User: <strong>admin</strong> &bull; Pass: <strong>Admin@123</strong></span>
                </div>
                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="fillDemo()" style="font-size:0.7rem; border-color:rgba(201,168,76,0.3); color:#C9A84C;">
                    Auto-Fill
                </button>
            </div>
        </div>
    </form>

    <script>
        function fillDemo() {
            document.getElementById('<%= txtUsername.ClientID %>').value = 'admin';
            document.getElementById('<%= txtPassword.ClientID %>').value = 'Admin@123';
        }
    </script>
</body>
</html>
