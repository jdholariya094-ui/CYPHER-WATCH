using System;
using CYPHER.App_Code;

namespace CYPHER.MasterPages
{
    /// <summary>
    /// Code-behind for Site.Master.
    /// Handles session display, cart count, and newsletter subscription.
    /// </summary>
    public partial class SiteMaster : System.Web.UI.MasterPage
    {
        protected global::System.Web.UI.WebControls.Panel pnlGuest;
        protected global::System.Web.UI.WebControls.Panel pnlUser;
        protected global::System.Web.UI.WebControls.LinkButton lnkLogout;
        protected global::System.Web.UI.WebControls.HiddenField hdnNewsletterEmail;
        protected global::System.Web.UI.WebControls.Button btnSubscribeServer;

        // Properties exposed to the master page markup
        public string UserName  { get; private set; }
        public int    CartCount { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                RefreshSessionDisplay();
        }

        /// <summary>Refreshes nav display based on current session state.</summary>
        private void RefreshSessionDisplay()
        {
            bool loggedIn = SessionHelper.IsUserLoggedIn;

            pnlGuest.Visible = !loggedIn;
            pnlUser.Visible  =  loggedIn;

            if (loggedIn)
            {
                UserName  = SessionHelper.CurrentUserName;
                CartCount = SessionHelper.GetCartCount();
                // Sync from DB once per request
                SessionHelper.RefreshCartCount();
                CartCount = SessionHelper.GetCartCount();
            }
        }

        /// <summary>Logout link handler.</summary>
        protected void lnkLogout_Click(object sender, EventArgs e)
        {
            SessionHelper.LogoutUser();
            Response.Redirect("~/Pages/Home.aspx");
        }

        /// <summary>Footer newsletter subscription handler.</summary>
        protected void btnSubscribeServer_Click(object sender, EventArgs e)
        {
            string email = hdnNewsletterEmail.Value.Trim();
            if (string.IsNullOrEmpty(email)) return;

            bool ok = DBHelper.SubscribeNewsletter(email);

            // Feedback via JavaScript alert injected on client
            string msg = ok
                ? "Thank you for subscribing!"
                : "You are already subscribed.";
            string icon = ok ? "fa-check-circle" : "fa-info-circle";

            // Script injection for toast
            string script = string.Format("window.showToast('{0}','{1}');", msg, icon);
            Page.ClientScript.RegisterStartupScript(GetType(), "subToast", script, true);
        }

        /// <summary>
        /// Returns "active" CSS class if the current page name matches.
        /// Called from .aspx markup: <%= IsActivePage("Home") %>
        /// </summary>
        public string IsActivePage(string pageName)
        {
            string path = Request.Url.AbsolutePath.ToLower();
            return path.Contains(pageName.ToLower()) ? "active" : string.Empty;
        }
    }
}
