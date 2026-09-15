using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using CYPHER.App_Code;

namespace CYPHER.Pages
{
    public partial class Watches : Page
    {
        protected global::System.Web.UI.WebControls.RadioButtonList rblCategories;
        protected global::System.Web.UI.WebControls.RadioButtonList rblBrands;
        protected global::System.Web.UI.WebControls.TextBox txtMinPrice;
        protected global::System.Web.UI.WebControls.TextBox txtMaxPrice;
        protected global::System.Web.UI.WebControls.Button btnPriceFilter;
        protected global::System.Web.UI.WebControls.LinkButton lnkClearFilters;
        protected global::System.Web.UI.WebControls.Label lblCount;
        protected global::System.Web.UI.WebControls.TextBox txtSearch;
        protected global::System.Web.UI.WebControls.DropDownList ddlSort;
        protected global::System.Web.UI.WebControls.Repeater rptProducts;
        protected global::System.Web.UI.WebControls.Panel pnlNoProducts;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadFilterSidebar();
                
                // Pre-populate filter parameters from QueryString
                if (!string.IsNullOrEmpty(Request.QueryString["brand"]))
                {
                    rblBrands.SelectedValue = Request.QueryString["brand"];
                }
                if (!string.IsNullOrEmpty(Request.QueryString["cat"]))
                {
                    rblCategories.SelectedValue = Request.QueryString["cat"];
                }
                if (!string.IsNullOrEmpty(Request.QueryString["search"]))
                {
                    txtSearch.Text = Request.QueryString["search"];
                }
                if (!string.IsNullOrEmpty(Request.QueryString["sort"]))
                {
                    ddlSort.SelectedValue = Request.QueryString["sort"];
                }

                BindProducts();
            }
        }

        private void LoadFilterSidebar()
        {
            try
            {
                // Categories
                DataTable dtCats = DBHelper.GetAllCategories();
                rblCategories.Items.Clear();
                rblCategories.Items.Add(new ListItem("All Collections", ""));
                foreach (DataRow row in dtCats.Rows)
                {
                    rblCategories.Items.Add(new ListItem(row["CategoryName"].ToString(), row["CategoryID"].ToString()));
                }
                rblCategories.SelectedValue = "";

                // Brands
                DataTable dtBrands = DBHelper.GetAllBrands();
                rblBrands.Items.Clear();
                rblBrands.Items.Add(new ListItem("All Brands", ""));
                foreach (DataRow row in dtBrands.Rows)
                {
                    rblBrands.Items.Add(new ListItem(row["BrandName"].ToString(), row["BrandID"].ToString()));
                }
                rblBrands.SelectedValue = "";
            }
            catch (Exception)
            {
                // Silence
            }
        }

        private void BindProducts()
        {
            int? brandId = null;
            if (!string.IsNullOrEmpty(rblBrands.SelectedValue))
                brandId = Convert.ToInt32(rblBrands.SelectedValue);

            int? categoryId = null;
            if (!string.IsNullOrEmpty(rblCategories.SelectedValue))
                categoryId = Convert.ToInt32(rblCategories.SelectedValue);

            decimal? minPrice = null;
            if (!string.IsNullOrEmpty(txtMinPrice.Text.Trim()))
            {
                decimal temp;
                if (decimal.TryParse(txtMinPrice.Text.Trim(), out temp)) minPrice = temp;
            }

            decimal? maxPrice = null;
            if (!string.IsNullOrEmpty(txtMaxPrice.Text.Trim()))
            {
                decimal temp;
                if (decimal.TryParse(txtMaxPrice.Text.Trim(), out temp)) maxPrice = temp;
            }

            string search = txtSearch.Text.Trim();
            if (string.IsNullOrEmpty(search)) search = null;

            string sort = ddlSort.SelectedValue;
            if (sort == "Default") sort = null;

            try
            {
                DataTable dt = DBHelper.GetAllProductsFiltered(brandId, categoryId, null, minPrice, maxPrice, search, sort, 0, 100);
                
                lblCount.Text = dt.Rows.Count.ToString();

                if (dt.Rows.Count > 0)
                {
                    rptProducts.DataSource = dt;
                    rptProducts.DataBind();
                    rptProducts.Visible = true;
                    pnlNoProducts.Visible = false;
                }
                else
                {
                    rptProducts.Visible = false;
                    pnlNoProducts.Visible = true;
                }
            }
            catch (Exception)
            {
                // Silence
            }
        }

        protected void FilterChanged(object sender, EventArgs e)
        {
            BindProducts();
        }

        protected void lnkClearFilters_Click(object sender, EventArgs e)
        {
            rblCategories.SelectedValue = "";
            rblBrands.SelectedValue = "";
            txtMinPrice.Text = string.Empty;
            txtMaxPrice.Text = string.Empty;
            txtSearch.Text = string.Empty;
            ddlSort.SelectedValue = "Default";
            BindProducts();
        }

        public string GetDiscountedPrice(decimal price, decimal discountPercent)
        {
            decimal final = price * (1 - (discountPercent / 100));
            return string.Format("{0:N0}", final);
        }
    }
}
