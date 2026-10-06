using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
//New Namespace
using System.Data.SqlClient;//For Connection
using System.Data;//For Dataset
using System.Configuration;//For Connection String

namespace CYPHER.MasterPages
{
    public partial class SiteMaster : System.Web.UI.MasterPage
    {
        SqlConnection con;
        SqlCommand cmd;

        string s = ConfigurationManager.ConnectionStrings["CypherDB"].ConnectionString;

        void getcon()
        {
            con = new SqlConnection(s);
            con.Open();
        }

        // Properties exposed to markup
        public string UserName  { get; private set; }
        public int    CartCount { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //Check if user is logged in via Session["user"]
                if (Session["user"] != null)
                {
                    pnlGuest.Visible = false;
                    pnlUser.Visible  = true;
                    UserName = Session["user"].ToString();

                    //Get cart count from DB
                    try
                    {
                        getcon();
                        cmd = new SqlCommand("select isnull(sum(Quantity),0) from Cart where UserID=(select UserID from Users where Email='" + Session["user"].ToString() + "')", con);
                        CartCount = Convert.ToInt32(cmd.ExecuteScalar());
                    }
                    catch { CartCount = 0; }
                }
                else
                {
                    pnlGuest.Visible = true;
                    pnlUser.Visible  = false;
                    UserName  = "";
                    CartCount = 0;
                }
            }
        }

        protected void lnkLogout_Click(object sender, EventArgs e)
        {
            //Clear session and redirect
            Session["user"] = null;
            Session.Clear();
            Response.Redirect("~/Pages/Home.aspx");
        }

        protected void btnSubscribeServer_Click(object sender, EventArgs e)
        {
            string email = hdnNewsletterEmail.Value.Trim();
            if (string.IsNullOrEmpty(email)) return;

            try
            {
                getcon();
                cmd = new SqlCommand("insert into NewsletterSubscribers(Email) values('" + email + "')", con);
                cmd.ExecuteNonQuery();
                string script = "window.showToast('Thank you for subscribing!','fa-check-circle');";
                Page.ClientScript.RegisterStartupScript(GetType(), "subToast", script, true);
            }
            catch
            {
                string script = "window.showToast('You are already subscribed.','fa-info-circle');";
                Page.ClientScript.RegisterStartupScript(GetType(), "subToast", script, true);
            }
        }

        public string IsActivePage(string pageName)
        {
            string path = Request.Url.AbsolutePath.ToLower();
            return path.Contains(pageName.ToLower()) ? "active" : string.Empty;
        }
    }
}

