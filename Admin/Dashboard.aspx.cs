using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using CYPHER.App_Code;

namespace CYPHER.Admin
{
    public partial class Dashboard : Page
    {
        protected global::System.Web.UI.WebControls.Literal litRevenue;
        protected global::System.Web.UI.WebControls.Literal litOrders;
        protected global::System.Web.UI.WebControls.Literal litProducts;
        protected global::System.Web.UI.WebControls.Literal litUsers;
        protected global::System.Web.UI.WebControls.Repeater rptRecentOrders;
        protected global::System.Web.UI.WebControls.Repeater rptLowStock;
        protected global::System.Web.UI.WebControls.Repeater rptPendingReviews;

        public int PendingOrdersCount { get; private set; } = 0;
        public int LowStockCount { get; private set; } = 0;
        public int PendingReviewsCount { get; private set; } = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDashboard();
            }
        }

        private void LoadDashboard()
        {
            try
            {
                // 1. Stats
                var stats = DBHelper.GetDashboardStats();
                if (stats != null && stats.Rows.Count > 0)
                {
                    DataRow r = stats.Rows[0];
                    decimal rev = r["TotalRevenue"] != DBNull.Value ? Convert.ToDecimal(r["TotalRevenue"]) : 0;
                    litRevenue.Text = rev.ToString("N0");
                    litOrders.Text = (r["TotalOrders"] != DBNull.Value ? r["TotalOrders"].ToString() : "0");
                    litProducts.Text = (r["TotalProducts"] != DBNull.Value ? r["TotalProducts"].ToString() : "0");
                    litUsers.Text = (r["TotalUsers"] != DBNull.Value ? r["TotalUsers"].ToString() : "0");

                    if (r["PendingOrders"] != DBNull.Value)
                        PendingOrdersCount = Convert.ToInt32(r["PendingOrders"]);
                    if (r["LowStockCount"] != DBNull.Value)
                        LowStockCount = Convert.ToInt32(r["LowStockCount"]);
                    if (r["PendingReviews"] != DBNull.Value)
                        PendingReviewsCount = Convert.ToInt32(r["PendingReviews"]);
                }

                // 2. Recent Orders
                rptRecentOrders.DataSource = DBHelper.GetRecentOrders(6);
                rptRecentOrders.DataBind();

                // 3. Low stock watches
                rptLowStock.DataSource = DBHelper.GetLowStockProducts(5);
                rptLowStock.DataBind();

                // 4. Pending Reviews
                rptPendingReviews.DataSource = DBHelper.GetPendingReviews(5);
                rptPendingReviews.DataBind();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Error in Admin Dashboard: " + ex.Message);
            }
        }

        protected void rptPendingReviews_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int reviewId = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName == "Approve")
            {
                DBHelper.ApproveReview(reviewId, true);
            }
            else if (e.CommandName == "Reject")
            {
                DBHelper.DeleteReview(reviewId);
            }
            LoadDashboard();
        }

        public string GetStars(int rating)
        {
            string s = "";
            for (int i = 1; i <= 5; i++)
            {
                s += (i <= rating) ? "★" : "☆";
            }
            return s;
        }
    }
}
