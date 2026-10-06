using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using CYPHER.App_Code;

namespace CYPHER.Admin
{
    public partial class Reports : Page
    {
        protected global::System.Web.UI.WebControls.TextBox txtFromDate;
        protected global::System.Web.UI.WebControls.TextBox txtToDate;
        protected global::System.Web.UI.WebControls.Button btnGenerate;
        protected global::System.Web.UI.WebControls.Button btnLast7;
        protected global::System.Web.UI.WebControls.Button btnLast30;
        protected global::System.Web.UI.WebControls.Button btnLast90;
        protected global::System.Web.UI.WebControls.Button btnAllTime;

        protected global::System.Web.UI.WebControls.Literal litPeriodRevenue;
        protected global::System.Web.UI.WebControls.Literal litPeriodOrders;
        protected global::System.Web.UI.WebControls.Literal litAOV;
        protected global::System.Web.UI.WebControls.Literal litSalesDays;

        protected global::System.Web.UI.WebControls.Repeater rptTopSelling;
        protected global::System.Web.UI.WebControls.Repeater rptStatusDist;
        protected global::System.Web.UI.WebControls.Repeater rptDailySales;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DateTime to = DateTime.Today.AddDays(1);
                DateTime from = DateTime.Today.AddDays(-30);
                txtFromDate.Text = from.ToString("yyyy-MM-dd");
                txtToDate.Text = to.ToString("yyyy-MM-dd");

                LoadReport(from, to);
            }
        }

        private void LoadReport(DateTime from, DateTime to)
        {
            try
            {
                // 1. Daily sales
                var sales = DBHelper.GetSalesReport(from, to);
                rptDailySales.DataSource = sales;
                rptDailySales.DataBind();

                decimal totalRev = 0;
                int totalOrders = 0;
                foreach (DataRow row in sales.Rows)
                {
                    totalRev += Convert.ToDecimal(row["Revenue"]);
                    totalOrders += Convert.ToInt32(row["OrderCount"]);
                }

                litPeriodRevenue.Text = totalRev.ToString("N0");
                litPeriodOrders.Text = totalOrders.ToString();
                litSalesDays.Text = sales.Rows.Count.ToString();

                decimal aov = totalOrders > 0 ? (totalRev / totalOrders) : 0;
                litAOV.Text = aov.ToString("N0");

                // 2. Top selling watches
                var topSelling = DBHelper.GetTopSellingProducts(5);
                rptTopSelling.DataSource = topSelling;
                rptTopSelling.DataBind();

                // 3. Status distribution
                var statusDist = DBHelper.GetOrderStatusDistribution();
                rptStatusDist.DataSource = statusDist;
                rptStatusDist.DataBind();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Error generating sales report: " + ex.Message);
            }
        }

        protected void btnGenerate_Click(object sender, EventArgs e)
        {
            DateTime from, to;
            if (!DateTime.TryParse(txtFromDate.Text, out from))
                from = DateTime.Today.AddDays(-30);
            if (!DateTime.TryParse(txtToDate.Text, out to))
                to = DateTime.Today.AddDays(1);

            LoadReport(from, to);
        }

        protected void btnPreset_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int days = Convert.ToInt32(btn.CommandArgument);
            DateTime to = DateTime.Today.AddDays(1);
            DateTime from = DateTime.Today.AddDays(-days);

            txtFromDate.Text = from.ToString("yyyy-MM-dd");
            txtToDate.Text = to.ToString("yyyy-MM-dd");

            LoadReport(from, to);
        }
    }
}
