using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using CYPHER.App_Code;

namespace CYPHER.Admin
{
    public partial class AdminMaster : MasterPage
    {
        protected global::System.Web.UI.ScriptManager ScriptManager1;
        protected global::System.Web.UI.WebControls.LinkButton lnkLogout;
        protected global::System.Web.UI.WebControls.LinkButton lnkTopLogout;

        public string AdminName { get; private set; } = "Admin";
        public string AdminInitial { get; private set; } = "A";
        public int PendingOrdersCount { get; private set; } = 0;
        public int PendingReviewsCount { get; private set; } = 0;

        protected void Page_Init(object sender, EventArgs e)
        {
            // Verify admin authentication
            if (Session["AdminUser"] == null)
            {
                Response.Redirect("~/Admin/AdminLogin.aspx");
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AdminName"] != null && !string.IsNullOrWhiteSpace(Session["AdminName"].ToString()))
            {
                AdminName = Session["AdminName"].ToString();
            }
            else if (Session["AdminUser"] != null)
            {
                AdminName = Session["AdminUser"].ToString();
            }

            if (!string.IsNullOrEmpty(AdminName))
            {
                AdminInitial = AdminName.Substring(0, 1).ToUpper();
            }

            if (!IsPostBack)
            {
                LoadBadges();
            }
        }

        private void LoadBadges()
        {
            try
            {
                var stats = DBHelper.GetDashboardStats();
                if (stats != null && stats.Rows.Count > 0)
                {
                    var row = stats.Rows[0];
                    if (row["PendingOrders"] != DBNull.Value)
                        PendingOrdersCount = Convert.ToInt32(row["PendingOrders"]);
                    if (row["PendingReviews"] != DBNull.Value)
                        PendingReviewsCount = Convert.ToInt32(row["PendingReviews"]);
                }
            }
            catch
            {
                // Silently handle if database is busy
            }
        }

        public string IsActive(string pageName)
        {
            string path = Request.Url.AbsolutePath.ToLower();
            return path.EndsWith("/" + pageName.ToLower()) || path.Contains("/" + pageName.ToLower()) ? "active" : string.Empty;
        }

        protected void lnkLogout_Click(object sender, EventArgs e)
        {
            Session["AdminUser"] = null;
            Session["AdminName"] = null;
            Session.Remove("AdminUser");
            Session.Remove("AdminName");
            Response.Redirect("~/Admin/AdminLogin.aspx");
        }
    }
}
