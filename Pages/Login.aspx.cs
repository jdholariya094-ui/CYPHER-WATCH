using System;
using System.Data;
using System.Web;
using System.Web.UI;
using CYPHER.App_Code;

namespace CYPHER.Pages
{
    public partial class Login : Page
    {
        protected global::System.Web.UI.WebControls.Panel pnlError;
        protected global::System.Web.UI.WebControls.Label lblError;
        protected global::System.Web.UI.WebControls.TextBox txtEmail;
        protected global::System.Web.UI.WebControls.TextBox txtPassword;
        protected global::System.Web.UI.WebControls.CheckBox chkRemember;
        protected global::System.Web.UI.WebControls.Button btnLogin;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (SessionHelper.IsUserLoggedIn)
            {
                RedirectUser();
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            pnlError.Visible = false;

            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                lblError.Text = "Please enter both email and password.";
                pnlError.Visible = true;
                return;
            }

            try
            {
                DataRow userRow = DBHelper.GetUserByEmail(email);
                if (userRow != null)
                {
                    string storedHash = userRow["PasswordHash"].ToString();
                    if (SessionHelper.VerifyPassword(password, storedHash))
                    {
                        int userId = Convert.ToInt32(userRow["UserID"]);
                        string fullName = userRow["FullName"].ToString();
                        
                        // Login user
                        SessionHelper.LoginUser(userId, fullName, email);

                        // Refresh cart count
                        SessionHelper.RefreshCartCount();

                        RedirectUser();
                        return;
                    }
                }

                // Invalid login
                lblError.Text = "Invalid email or password.";
                pnlError.Visible = true;
            }
            catch (Exception ex)
            {
                lblError.Text = "An error occurred during login: " + ex.Message;
                pnlError.Visible = true;
            }
        }

        private void RedirectUser()
        {
            string returnUrl = Request.QueryString["ReturnUrl"];
            if (!string.IsNullOrEmpty(returnUrl))
            {
                Response.Redirect(returnUrl, true);
            }
            else
            {
                Response.Redirect("~/Pages/Home.aspx", true);
            }
        }
    }
}
