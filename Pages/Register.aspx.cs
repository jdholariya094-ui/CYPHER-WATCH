using System;
using System.Data;
using System.Web.UI;
using CYPHER.App_Code;

namespace CYPHER.Pages
{
    public partial class Register : Page
    {
        protected global::System.Web.UI.WebControls.Panel pnlError;
        protected global::System.Web.UI.WebControls.Label lblError;
        protected global::System.Web.UI.WebControls.TextBox txtFullName;
        protected global::System.Web.UI.WebControls.TextBox txtEmail;
        protected global::System.Web.UI.WebControls.TextBox txtPhone;
        protected global::System.Web.UI.WebControls.TextBox txtPassword;
        protected global::System.Web.UI.WebControls.TextBox txtConfirmPassword;
        protected global::System.Web.UI.WebControls.Button btnRegister;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (SessionHelper.IsUserLoggedIn)
            {
                Response.Redirect("~/Pages/Home.aspx");
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            pnlError.Visible = false;

            string fullName = txtFullName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string phone = txtPhone.Text.Trim();
            string password = txtPassword.Text;
            string confirmPassword = txtConfirmPassword.Text;

            if (string.IsNullOrEmpty(fullName) || string.IsNullOrEmpty(email) || 
                string.IsNullOrEmpty(password) || string.IsNullOrEmpty(confirmPassword))
            {
                lblError.Text = "Please fill in all required fields.";
                pnlError.Visible = true;
                return;
            }

            if (password.Length < 6)
            {
                lblError.Text = "Password must be at least 6 characters long.";
                pnlError.Visible = true;
                return;
            }

            if (password != confirmPassword)
            {
                lblError.Text = "Passwords do not match.";
                pnlError.Visible = true;
                return;
            }

            try
            {
                // Check if email already registered
                DataRow existingUser = DBHelper.GetUserByEmail(email);
                if (existingUser != null)
                {
                    lblError.Text = "This email is already registered.";
                    pnlError.Visible = true;
                    return;
                }

                // Hash password
                string passwordHash = SessionHelper.HashPassword(password);

                // Register user
                int newUserId = DBHelper.RegisterUser(fullName, email, phone, passwordHash);
                if (newUserId > 0)
                {
                    // Login newly registered user
                    SessionHelper.LoginUser(newUserId, fullName, email);

                    // Redirect to home page
                    Response.Redirect("~/Pages/Home.aspx", true);
                }
                else
                {
                    lblError.Text = "Registration failed. Please try again.";
                    pnlError.Visible = true;
                }
            }
            catch (Exception ex)
            {
                lblError.Text = "An error occurred: " + ex.Message;
                pnlError.Visible = true;
            }
        }
    }
}
