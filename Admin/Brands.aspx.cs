using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using CYPHER.App_Code;

namespace CYPHER.Admin
{
    public partial class Brands : Page
    {
        protected global::System.Web.UI.WebControls.Literal litCount;
        protected global::System.Web.UI.WebControls.Panel pnlAlert;
        protected global::System.Web.UI.WebControls.Label lblAlert;
        protected global::System.Web.UI.WebControls.Panel pnlEditBrand;
        protected global::System.Web.UI.WebControls.Literal litFormTitle;
        protected global::System.Web.UI.WebControls.LinkButton btnCloseForm;
        protected global::System.Web.UI.WebControls.HiddenField hdnBrandID;

        protected global::System.Web.UI.WebControls.TextBox txtBrandName;
        protected global::System.Web.UI.WebControls.TextBox txtCountry;
        protected global::System.Web.UI.WebControls.TextBox txtLogoURL;
        protected global::System.Web.UI.WebControls.TextBox txtDescription;
        protected global::System.Web.UI.WebControls.CheckBox chkIsActive;
        protected global::System.Web.UI.WebControls.Button btnCancel;
        protected global::System.Web.UI.WebControls.Button btnSaveBrand;

        protected global::System.Web.UI.WebControls.LinkButton btnShowAdd;
        protected global::System.Web.UI.WebControls.Repeater rptBrands;

        public string AlertCssClass { get; private set; } = "admin-alert-info";
        public string AlertIconClass { get; private set; } = "fa-info-circle";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadBrands();
            }
        }

        private void LoadBrands()
        {
            try
            {
                var dt = DBHelper.GetBrandsWithCount();
                rptBrands.DataSource = dt;
                rptBrands.DataBind();
                litCount.Text = dt.Rows.Count.ToString();
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading brands: " + ex.Message, false);
            }
        }

        protected void btnShowAdd_Click(object sender, EventArgs e)
        {
            hdnBrandID.Value = "0";
            litFormTitle.Text = "Add Watchmaker Maison";
            txtBrandName.Text = "";
            txtCountry.Text = "Switzerland";
            txtDescription.Text = "";
            txtLogoURL.Text = "/Content/images/watches/watch_hero.jpg";
            chkIsActive.Checked = true;
            pnlEditBrand.Visible = true;
        }

        protected void btnCloseForm_Click(object sender, EventArgs e)
        {
            pnlEditBrand.Visible = false;
        }

        protected void btnSaveBrand_Click(object sender, EventArgs e)
        {
            int brandId = Convert.ToInt32(hdnBrandID.Value);
            string name = txtBrandName.Text.Trim();
            if (string.IsNullOrEmpty(name))
            {
                ShowAlert("Brand Name is required.", false);
                return;
            }

            try
            {
                DBHelper.SaveBrand(brandId, name, txtDescription.Text.Trim(), txtLogoURL.Text.Trim(), txtCountry.Text.Trim(), chkIsActive.Checked);
                ShowAlert(brandId > 0 ? "Brand updated successfully." : "New brand maison registered.", true);
                pnlEditBrand.Visible = false;
                LoadBrands();
            }
            catch (Exception ex)
            {
                ShowAlert("Error saving brand: " + ex.Message, false);
            }
        }

        protected void rptBrands_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int brandId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditBrand")
            {
                try
                {
                    var row = DBHelper.GetBrandByID(brandId);
                    if (row != null)
                    {
                        hdnBrandID.Value = brandId.ToString();
                        litFormTitle.Text = "Edit Brand #" + brandId + " — " + row["BrandName"];
                        txtBrandName.Text = row["BrandName"].ToString();
                        txtCountry.Text = row["Country"] != DBNull.Value ? row["Country"].ToString() : "";
                        txtDescription.Text = row["Description"] != DBNull.Value ? row["Description"].ToString() : "";
                        txtLogoURL.Text = row["LogoURL"] != DBNull.Value ? row["LogoURL"].ToString() : "";
                        chkIsActive.Checked = Convert.ToBoolean(row["IsActive"]);
                        pnlEditBrand.Visible = true;
                    }
                }
                catch (Exception ex)
                {
                    ShowAlert("Error loading brand: " + ex.Message, false);
                }
            }
            else if (e.CommandName == "ToggleActive")
            {
                try
                {
                    DBHelper.ToggleBrandStatus(brandId);
                    ShowAlert("Brand status updated.", true);
                    LoadBrands();
                }
                catch (Exception ex)
                {
                    ShowAlert("Error updating brand: " + ex.Message, false);
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
