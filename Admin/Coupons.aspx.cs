using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using CYPHER.App_Code;

namespace CYPHER.Admin
{
    public partial class Coupons : Page
    {
        protected global::System.Web.UI.WebControls.Literal litCount;
        protected global::System.Web.UI.WebControls.Panel pnlAlert;
        protected global::System.Web.UI.WebControls.Label lblAlert;

        protected global::System.Web.UI.WebControls.Panel pnlEditCoupon;
        protected global::System.Web.UI.WebControls.Literal litFormTitle;
        protected global::System.Web.UI.WebControls.LinkButton btnCloseForm;
        protected global::System.Web.UI.WebControls.HiddenField hdnCouponID;

        protected global::System.Web.UI.WebControls.TextBox txtCode;
        protected global::System.Web.UI.WebControls.DropDownList ddlType;
        protected global::System.Web.UI.WebControls.TextBox txtValue;
        protected global::System.Web.UI.WebControls.TextBox txtMinSpend;
        protected global::System.Web.UI.WebControls.TextBox txtMaxUses;
        protected global::System.Web.UI.WebControls.TextBox txtExpiryDate;
        protected global::System.Web.UI.WebControls.CheckBox chkIsActive;
        protected global::System.Web.UI.WebControls.Button btnCancel;
        protected global::System.Web.UI.WebControls.Button btnSaveCoupon;

        protected global::System.Web.UI.WebControls.LinkButton btnShowAdd;
        protected global::System.Web.UI.WebControls.Repeater rptCoupons;

        public string AlertCssClass { get; private set; } = "admin-alert-info";
        public string AlertIconClass { get; private set; } = "fa-info-circle";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCoupons();
            }
        }

        private void LoadCoupons()
        {
            try
            {
                var dt = DBHelper.GetAllCoupons();
                rptCoupons.DataSource = dt;
                rptCoupons.DataBind();
                litCount.Text = dt.Rows.Count.ToString();
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading coupons: " + ex.Message, false);
            }
        }

        protected void btnShowAdd_Click(object sender, EventArgs e)
        {
            hdnCouponID.Value = "0";
            litFormTitle.Text = "Create New Promotional Coupon";
            txtCode.Text = "";
            ddlType.SelectedValue = "Percentage";
            txtValue.Text = "10";
            txtMinSpend.Text = "0";
            txtMaxUses.Text = "";
            txtExpiryDate.Text = "";
            chkIsActive.Checked = true;
            pnlEditCoupon.Visible = true;
        }

        protected void btnCloseForm_Click(object sender, EventArgs e)
        {
            pnlEditCoupon.Visible = false;
        }

        protected void btnSaveCoupon_Click(object sender, EventArgs e)
        {
            int couponId = Convert.ToInt32(hdnCouponID.Value);
            string code = txtCode.Text.Trim().ToUpper();
            if (string.IsNullOrEmpty(code))
            {
                ShowAlert("Coupon Code is required.", false);
                return;
            }

            decimal val = 0;
            if (!decimal.TryParse(txtValue.Text.Trim(), out val) || val <= 0)
            {
                ShowAlert("Please enter a valid discount value.", false);
                return;
            }

            decimal minSpend = 0;
            decimal.TryParse(txtMinSpend.Text.Trim(), out minSpend);

            int? maxUses = null;
            int maxU;
            if (int.TryParse(txtMaxUses.Text.Trim(), out maxU) && maxU > 0)
                maxUses = maxU;

            DateTime? expiry = null;
            DateTime expD;
            if (DateTime.TryParse(txtExpiryDate.Text.Trim(), out expD))
                expiry = expD;

            try
            {
                DBHelper.SaveCoupon(couponId, code, ddlType.SelectedValue, val, minSpend, maxUses, expiry, chkIsActive.Checked);
                ShowAlert(couponId > 0 ? "Coupon '" + code + "' updated successfully." : "New coupon '" + code + "' activated.", true);
                pnlEditCoupon.Visible = false;
                LoadCoupons();
            }
            catch (Exception ex)
            {
                ShowAlert("Error saving coupon: " + ex.Message, false);
            }
        }

        protected void rptCoupons_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int couponId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditCoupon")
            {
                try
                {
                    var row = DBHelper.GetCouponByID(couponId);
                    if (row != null)
                    {
                        hdnCouponID.Value = couponId.ToString();
                        litFormTitle.Text = "Edit Coupon — " + row["CouponCode"];
                        txtCode.Text = row["CouponCode"].ToString();
                        ddlType.SelectedValue = row["DiscountType"].ToString();
                        txtValue.Text = Convert.ToDecimal(row["DiscountValue"]).ToString("0.##");
                        txtMinSpend.Text = Convert.ToDecimal(row["MinOrderAmount"]).ToString("0.##");
                        txtMaxUses.Text = row["MaxUses"] != DBNull.Value ? row["MaxUses"].ToString() : "";
                        if (row["ExpiryDate"] != DBNull.Value)
                            txtExpiryDate.Text = Convert.ToDateTime(row["ExpiryDate"]).ToString("yyyy-MM-dd");
                        else
                            txtExpiryDate.Text = "";
                        chkIsActive.Checked = Convert.ToBoolean(row["IsActive"]);
                        pnlEditCoupon.Visible = true;
                    }
                }
                catch (Exception ex)
                {
                    ShowAlert("Error loading coupon: " + ex.Message, false);
                }
            }
            else if (e.CommandName == "ToggleActive")
            {
                try
                {
                    DBHelper.ToggleCouponStatus(couponId);
                    ShowAlert("Coupon active status toggled.", true);
                    LoadCoupons();
                }
                catch (Exception ex)
                {
                    ShowAlert("Error toggling coupon: " + ex.Message, false);
                }
            }
            else if (e.CommandName == "DeleteCoupon")
            {
                try
                {
                    DBHelper.DeleteCoupon(couponId);
                    ShowAlert("Coupon deleted successfully.", true);
                    LoadCoupons();
                }
                catch (Exception ex)
                {
                    ShowAlert("Error deleting coupon: " + ex.Message, false);
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
