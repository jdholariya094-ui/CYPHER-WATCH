using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using CYPHER.App_Code;

namespace CYPHER.Admin
{
    public partial class Categories : Page
    {
        protected global::System.Web.UI.WebControls.Literal litCount;
        protected global::System.Web.UI.WebControls.Panel pnlAlert;
        protected global::System.Web.UI.WebControls.Label lblAlert;
        protected global::System.Web.UI.WebControls.Panel pnlEditCategory;
        protected global::System.Web.UI.WebControls.Literal litFormTitle;
        protected global::System.Web.UI.WebControls.LinkButton btnCloseForm;
        protected global::System.Web.UI.WebControls.HiddenField hdnCategoryID;

        protected global::System.Web.UI.WebControls.TextBox txtCategoryName;
        protected global::System.Web.UI.WebControls.TextBox txtImageURL;
        protected global::System.Web.UI.WebControls.TextBox txtDescription;
        protected global::System.Web.UI.WebControls.CheckBox chkIsActive;
        protected global::System.Web.UI.WebControls.Button btnCancel;
        protected global::System.Web.UI.WebControls.Button btnSaveCategory;

        protected global::System.Web.UI.WebControls.LinkButton btnShowAdd;
        protected global::System.Web.UI.WebControls.Repeater rptCategories;

        public string AlertCssClass { get; private set; } = "admin-alert-info";
        public string AlertIconClass { get; private set; } = "fa-info-circle";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCategories();
            }
        }

        private void LoadCategories()
        {
            try
            {
                var dt = DBHelper.GetCategoriesWithCount();
                rptCategories.DataSource = dt;
                rptCategories.DataBind();
                litCount.Text = dt.Rows.Count.ToString();
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading categories: " + ex.Message, false);
            }
        }

        protected void btnShowAdd_Click(object sender, EventArgs e)
        {
            hdnCategoryID.Value = "0";
            litFormTitle.Text = "Add New Category";
            txtCategoryName.Text = "";
            txtDescription.Text = "";
            txtImageURL.Text = "/Content/images/watches/watch_luxury_gold.jpg";
            chkIsActive.Checked = true;
            pnlEditCategory.Visible = true;
        }

        protected void btnCloseForm_Click(object sender, EventArgs e)
        {
            pnlEditCategory.Visible = false;
        }

        protected void btnSaveCategory_Click(object sender, EventArgs e)
        {
            int catId = Convert.ToInt32(hdnCategoryID.Value);
            string name = txtCategoryName.Text.Trim();
            if (string.IsNullOrEmpty(name))
            {
                ShowAlert("Category Name is required.", false);
                return;
            }

            try
            {
                DBHelper.SaveCategory(catId, name, txtDescription.Text.Trim(), txtImageURL.Text.Trim(), chkIsActive.Checked);
                ShowAlert(catId > 0 ? "Category updated successfully." : "New category created successfully.", true);
                pnlEditCategory.Visible = false;
                LoadCategories();
            }
            catch (Exception ex)
            {
                ShowAlert("Error saving category: " + ex.Message, false);
            }
        }

        protected void rptCategories_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int catId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditCat")
            {
                try
                {
                    var row = DBHelper.GetCategoryByID(catId);
                    if (row != null)
                    {
                        hdnCategoryID.Value = catId.ToString();
                        litFormTitle.Text = "Edit Category #" + catId + " — " + row["CategoryName"];
                        txtCategoryName.Text = row["CategoryName"].ToString();
                        txtDescription.Text = row["Description"] != DBNull.Value ? row["Description"].ToString() : "";
                        txtImageURL.Text = row["ImageURL"] != DBNull.Value ? row["ImageURL"].ToString() : "";
                        chkIsActive.Checked = Convert.ToBoolean(row["IsActive"]);
                        pnlEditCategory.Visible = true;
                    }
                }
                catch (Exception ex)
                {
                    ShowAlert("Error loading category: " + ex.Message, false);
                }
            }
            else if (e.CommandName == "ToggleActive")
            {
                try
                {
                    DBHelper.ToggleCategoryStatus(catId);
                    ShowAlert("Category status updated.", true);
                    LoadCategories();
                }
                catch (Exception ex)
                {
                    ShowAlert("Error updating category: " + ex.Message, false);
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
