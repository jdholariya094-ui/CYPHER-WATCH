using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using CYPHER.App_Code;

namespace CYPHER.Admin
{
    public partial class Products : Page
    {
        protected global::System.Web.UI.WebControls.Literal litTotalCount;
        protected global::System.Web.UI.WebControls.Panel pnlAlert;
        protected global::System.Web.UI.WebControls.Label lblAlert;
        protected global::System.Web.UI.WebControls.Panel pnlEditProduct;
        protected global::System.Web.UI.WebControls.Literal litFormTitle;
        protected global::System.Web.UI.WebControls.LinkButton btnCloseForm;
        protected global::System.Web.UI.WebControls.HiddenField hdnProductID;

        protected global::System.Web.UI.WebControls.TextBox txtProductName;
        protected global::System.Web.UI.WebControls.DropDownList ddlBrand;
        protected global::System.Web.UI.WebControls.DropDownList ddlCategory;
        protected global::System.Web.UI.WebControls.TextBox txtPrice;
        protected global::System.Web.UI.WebControls.TextBox txtDiscount;
        protected global::System.Web.UI.WebControls.TextBox txtStock;
        protected global::System.Web.UI.WebControls.TextBox txtMovement;
        protected global::System.Web.UI.WebControls.DropDownList ddlGender;
        protected global::System.Web.UI.WebControls.TextBox txtCaseDiam;
        protected global::System.Web.UI.WebControls.TextBox txtWaterRes;
        protected global::System.Web.UI.WebControls.TextBox txtCaseColor;
        protected global::System.Web.UI.WebControls.TextBox txtStrap;
        protected global::System.Web.UI.WebControls.TextBox txtCrystal;
        protected global::System.Web.UI.WebControls.TextBox txtImageUrl;
        protected global::System.Web.UI.WebControls.TextBox txtDescription;
        protected global::System.Web.UI.WebControls.CheckBox chkIsActive;
        protected global::System.Web.UI.WebControls.CheckBox chkIsFeatured;
        protected global::System.Web.UI.WebControls.CheckBox chkIsNewArrival;
        protected global::System.Web.UI.WebControls.CheckBox chkIsBestSeller;
        protected global::System.Web.UI.WebControls.Button btnCancelEdit;
        protected global::System.Web.UI.WebControls.Button btnSaveProduct;

        protected global::System.Web.UI.WebControls.TextBox txtSearch;
        protected global::System.Web.UI.WebControls.DropDownList ddlFilterBrand;
        protected global::System.Web.UI.WebControls.DropDownList ddlFilterCategory;
        protected global::System.Web.UI.WebControls.DropDownList ddlFilterStock;
        protected global::System.Web.UI.WebControls.Button btnSearch;
        protected global::System.Web.UI.WebControls.Button btnResetFilter;
        protected global::System.Web.UI.WebControls.LinkButton btnShowAddProduct;
        protected global::System.Web.UI.WebControls.Repeater rptProducts;

        public string AlertCssClass { get; private set; } = "admin-alert-info";
        public string AlertIconClass { get; private set; } = "fa-info-circle";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDropdowns();

                // Check query string parameters e.g. stock=low
                if (Request.QueryString["stock"] != null)
                {
                    string s = Request.QueryString["stock"].ToLower();
                    if (ddlFilterStock.Items.FindByValue(s) != null)
                        ddlFilterStock.SelectedValue = s;
                }

                if (Request.QueryString["action"] == "add")
                {
                    OpenAddForm();
                }

                LoadProducts();
            }
        }

        private void LoadDropdowns()
        {
            try
            {
                // Brands
                var brands = DBHelper.GetAllBrands();
                ddlBrand.DataSource = brands;
                ddlBrand.DataTextField = "BrandName";
                ddlBrand.DataValueField = "BrandID";
                ddlBrand.DataBind();

                ddlFilterBrand.Items.Clear();
                ddlFilterBrand.Items.Add(new ListItem("All Brands", ""));
                foreach (DataRow row in brands.Rows)
                {
                    ddlFilterBrand.Items.Add(new ListItem(row["BrandName"].ToString(), row["BrandID"].ToString()));
                }

                // Categories
                var cats = DBHelper.GetAllCategories();
                ddlCategory.DataSource = cats;
                ddlCategory.DataTextField = "CategoryName";
                ddlCategory.DataValueField = "CategoryID";
                ddlCategory.DataBind();

                ddlFilterCategory.Items.Clear();
                ddlFilterCategory.Items.Add(new ListItem("All Categories", ""));
                foreach (DataRow row in cats.Rows)
                {
                    ddlFilterCategory.Items.Add(new ListItem(row["CategoryName"].ToString(), row["CategoryID"].ToString()));
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading brands and categories: " + ex.Message, false);
            }
        }

        private void LoadProducts()
        {
            try
            {
                int? brandId = null;
                if (!string.IsNullOrEmpty(ddlFilterBrand.SelectedValue))
                    brandId = Convert.ToInt32(ddlFilterBrand.SelectedValue);

                int? catId = null;
                if (!string.IsNullOrEmpty(ddlFilterCategory.SelectedValue))
                    catId = Convert.ToInt32(ddlFilterCategory.SelectedValue);

                string search = txtSearch.Text.Trim();
                if (string.IsNullOrEmpty(search)) search = null;

                string stock = ddlFilterStock.SelectedValue;

                var dt = DBHelper.GetAllProductsAdmin(brandId, catId, search, stock);
                rptProducts.DataSource = dt;
                rptProducts.DataBind();

                litTotalCount.Text = dt.Rows.Count.ToString();
            }
            catch (Exception ex)
            {
                ShowAlert("Error fetching timepieces: " + ex.Message, false);
            }
        }

        protected void FilterChanged(object sender, EventArgs e)
        {
            LoadProducts();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadProducts();
        }

        protected void btnResetFilter_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlFilterBrand.SelectedIndex = 0;
            ddlFilterCategory.SelectedIndex = 0;
            ddlFilterStock.SelectedIndex = 0;
            LoadProducts();
        }

        protected void btnShowAddProduct_Click(object sender, EventArgs e)
        {
            OpenAddForm();
        }

        private void OpenAddForm()
        {
            hdnProductID.Value = "0";
            litFormTitle.Text = "Add New Timepiece to Vault";
            txtProductName.Text = "";
            txtPrice.Text = "";
            txtDiscount.Text = "0";
            txtStock.Text = "5";
            txtMovement.Text = "";
            txtCaseDiam.Text = "40mm";
            txtWaterRes.Text = "100m";
            txtCaseColor.Text = "Stainless Steel";
            txtStrap.Text = "Stainless Steel";
            txtCrystal.Text = "Sapphire";
            txtImageUrl.Text = "/Content/images/watches/watch_hero.jpg";
            txtDescription.Text = "";
            chkIsActive.Checked = true;
            chkIsFeatured.Checked = false;
            chkIsNewArrival.Checked = true;
            chkIsBestSeller.Checked = false;
            pnlEditProduct.Visible = true;
        }

        protected void btnCloseForm_Click(object sender, EventArgs e)
        {
            pnlEditProduct.Visible = false;
        }

        protected void btnSaveProduct_Click(object sender, EventArgs e)
        {
            int prodId = Convert.ToInt32(hdnProductID.Value);
            string name = txtProductName.Text.Trim();
            if (string.IsNullOrEmpty(name))
            {
                ShowAlert("Watch name is mandatory.", false);
                return;
            }

            decimal price = 0;
            if (!decimal.TryParse(txtPrice.Text.Trim(), out price) || price <= 0)
            {
                ShowAlert("Please enter a valid retail price.", false);
                return;
            }

            decimal discount = 0;
            decimal.TryParse(txtDiscount.Text.Trim(), out discount);

            int stock = 0;
            int.TryParse(txtStock.Text.Trim(), out stock);

            int brandId = Convert.ToInt32(ddlBrand.SelectedValue);
            int catId = Convert.ToInt32(ddlCategory.SelectedValue);

            string imgUrl = txtImageUrl.Text.Trim();
            if (string.IsNullOrEmpty(imgUrl))
                imgUrl = "/Content/images/watches/watch_hero.jpg";

            try
            {
                DBHelper.SaveProduct(
                    prodId, name, brandId, catId, txtDescription.Text.Trim(),
                    price, discount, stock, imgUrl, "",
                    ddlGender.SelectedValue, txtCaseColor.Text.Trim(), txtStrap.Text.Trim(),
                    txtCaseDiam.Text.Trim(), txtWaterRes.Text.Trim(), txtMovement.Text.Trim(),
                    txtCrystal.Text.Trim(), chkIsActive.Checked, chkIsFeatured.Checked,
                    chkIsNewArrival.Checked, chkIsBestSeller.Checked
                );

                ShowAlert(prodId > 0 ? "Timepiece updated successfully." : "New timepiece added to vault successfully.", true);
                pnlEditProduct.Visible = false;
                LoadProducts();
            }
            catch (Exception ex)
            {
                ShowAlert("Error saving timepiece: " + ex.Message, false);
            }
        }

        protected void rptProducts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int prodId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditProduct")
            {
                try
                {
                    var row = DBHelper.GetProductForAdmin(prodId);
                    if (row != null)
                    {
                        hdnProductID.Value = prodId.ToString();
                        litFormTitle.Text = "Edit Timepiece #" + prodId + " — " + row["ProductName"];
                        txtProductName.Text = row["ProductName"].ToString();
                        ddlBrand.SelectedValue = row["BrandID"].ToString();
                        ddlCategory.SelectedValue = row["CategoryID"].ToString();
                        txtPrice.Text = Convert.ToDecimal(row["Price"]).ToString("0.##");
                        txtDiscount.Text = Convert.ToDecimal(row["DiscountPercent"]).ToString("0.##");
                        txtStock.Text = row["StockQuantity"].ToString();
                        txtMovement.Text = row["Movement"] != DBNull.Value ? row["Movement"].ToString() : "";
                        if (row["Gender"] != DBNull.Value && ddlGender.Items.FindByValue(row["Gender"].ToString()) != null)
                            ddlGender.SelectedValue = row["Gender"].ToString();
                        txtCaseDiam.Text = row["CaseDiameter"] != DBNull.Value ? row["CaseDiameter"].ToString() : "";
                        txtWaterRes.Text = row["WaterResistance"] != DBNull.Value ? row["WaterResistance"].ToString() : "";
                        txtCaseColor.Text = row["CaseColor"] != DBNull.Value ? row["CaseColor"].ToString() : "";
                        txtStrap.Text = row["StrapMaterial"] != DBNull.Value ? row["StrapMaterial"].ToString() : "";
                        txtCrystal.Text = row["Crystal"] != DBNull.Value ? row["Crystal"].ToString() : "";
                        txtImageUrl.Text = row["ImageURL"] != DBNull.Value ? row["ImageURL"].ToString() : "";
                        txtDescription.Text = row["Description"] != DBNull.Value ? row["Description"].ToString() : "";

                        chkIsActive.Checked = Convert.ToBoolean(row["IsActive"]);
                        chkIsFeatured.Checked = Convert.ToBoolean(row["IsFeatured"]);
                        chkIsNewArrival.Checked = Convert.ToBoolean(row["IsNewArrival"]);
                        chkIsBestSeller.Checked = Convert.ToBoolean(row["IsBestSeller"]);

                        pnlEditProduct.Visible = true;
                    }
                }
                catch (Exception ex)
                {
                    ShowAlert("Error loading timepiece: " + ex.Message, false);
                }
            }
            else if (e.CommandName == "ToggleActive")
            {
                try
                {
                    DBHelper.DeleteProduct(prodId);
                    ShowAlert("Timepiece visibility status toggled.", true);
                    LoadProducts();
                }
                catch (Exception ex)
                {
                    ShowAlert("Error updating status: " + ex.Message, false);
                }
            }
        }

        private void ShowAlert(string msg, bool isSuccess)
        {
            pnlAlert.Visible = true;
            lblAlert.Text = msg;
            AlertCssClass = isSuccess ? "admin-alert-success" : "admin-alert-danger";
            AlertIconClass = isSuccess ? "fa-check-circle" : "fa-exclamation-circle";
        }
    }
}
