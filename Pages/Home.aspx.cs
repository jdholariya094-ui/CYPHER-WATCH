using System;
using System.Web.UI;
using CYPHER.App_Code;

namespace CYPHER.Pages
{
    public partial class Home : Page
    {
        protected global::System.Web.UI.WebControls.Repeater rptFeatured;
        protected global::System.Web.UI.WebControls.Repeater rptNewArrivals;
        protected global::System.Web.UI.WebControls.Repeater rptBestSellers;
        protected global::System.Web.UI.WebControls.Repeater rptBrands;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindData();
            }
        }

        private void BindData()
        {
            try
            {
                rptFeatured.DataSource = DBHelper.GetFeaturedProducts(8);
                rptFeatured.DataBind();

                rptNewArrivals.DataSource = DBHelper.GetNewArrivals(8);
                rptNewArrivals.DataBind();

                rptBestSellers.DataSource = DBHelper.GetBestSellers(8);
                rptBestSellers.DataBind();

                rptBrands.DataSource = DBHelper.GetAllBrands();
                rptBrands.DataBind();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Error binding home page data: " + ex.Message);
            }
        }

        public string GetStars(decimal rating)
        {
            int r = (int)Math.Round(rating);
            string stars = "";
            for (int i = 1; i <= 5; i++)
            {
                if (i <= r)
                    stars += "★";
                else
                    stars += "☆";
            }
            return stars;
        }

        public string GetDiscountedPrice(decimal price, decimal discountPercent)
        {
            decimal discounted = price - (price * discountPercent / 100);
            return discounted.ToString("N0");
        }
    }
}
