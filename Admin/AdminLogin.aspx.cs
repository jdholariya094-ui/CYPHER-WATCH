using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using CYPHER.App_Code;

namespace CYPHER.Admin
{
    public partial class AdminLogin : Page
    {
        protected global::System.Web.UI.WebControls.Panel pnlError;
        protected global::System.Web.UI.WebControls.Label lblError;
        protected global::System.Web.UI.WebControls.Panel pnlInfo;
        protected global::System.Web.UI.WebControls.Label lblInfo;
        protected global::System.Web.UI.WebControls.TextBox txtUsername;
        protected global::System.Web.UI.WebControls.TextBox txtPassword;
        protected global::System.Web.UI.WebControls.CheckBox chkRemember;
        protected global::System.Web.UI.WebControls.Button btnLogin;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // If already logged in, redirect straight to dashboard
                if (Session["AdminUser"] != null)
                {
                    Response.Redirect("~/Admin/Dashboard.aspx");
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text;

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                pnlError.Visible = true;
                lblError.Text = "Please enter both username and password.";
                return;
            }

            try
            {
                var adminRow = DBHelper.VerifyAdminLogin(username, password);
                if (adminRow != null)
                {
                    Session["AdminUser"] = adminRow["Username"].ToString();
                    Session["AdminName"] = adminRow["FullName"] != DBNull.Value ? adminRow["FullName"].ToString() : adminRow["Username"].ToString();
                    Session["AdminID"] = adminRow["AdminID"].ToString();

                    Response.Redirect("~/Admin/Dashboard.aspx", false);
                }
                else
                {
                    pnlError.Visible = true;
                    lblError.Text = "Invalid administrator credentials. Access denied.";
                }
            }
            catch (Exception ex)
            {
                pnlError.Visible = true;
                lblError.Text = "Authentication system error: " + ex.Message;
            }
        }
    }
}
