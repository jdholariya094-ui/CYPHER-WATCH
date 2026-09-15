using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using CYPHER.App_Code;

namespace CYPHER.Pages
{
    public partial class Cart : Page
    {
        protected global::System.Web.UI.WebControls.Panel pnlCartEmpty;
        protected global::System.Web.UI.WebControls.Panel pnlCartContent;
        protected global::System.Web.UI.WebControls.GridView gvCart;
        protected global::System.Web.UI.WebControls.Label lblSubtotal;
        protected global::System.Web.UI.WebControls.TextBox txtCoupon;
        protected global::System.Web.UI.WebControls.Button btnApplyCoupon;
        protected global::System.Web.UI.WebControls.Label lblCouponMsg;
        protected global::System.Web.UI.WebControls.Panel pnlDiscountRow;
        protected global::System.Web.UI.WebControls.Label lblCouponCode;
        protected global::System.Web.UI.WebControls.Label lblDiscountAmount;
        protected global::System.Web.UI.WebControls.Label lblTax;
        protected global::System.Web.UI.WebControls.Label lblTotal;
        protected global::System.Web.UI.WebControls.Button btnCheckout;

        protected void Page_Load(object sender, EventArgs e)
        {
            SessionHelper.RequireUserLogin(Request.Url.PathAndQuery);

            if (!IsPostBack)
            {
                BindCart();
            }
        }

        private void BindCart()
        {
            int userId = SessionHelper.CurrentUserID;
            try
            {
                DataTable dt = DBHelper.GetCartByUser(userId);
                
                if (dt != null && dt.Rows.Count > 0)
                {
                    gvCart.DataSource = dt;
                    gvCart.DataBind();
                    
                    pnlCartEmpty.Visible = false;
                    pnlCartContent.Visible = true;

                    CalculateTotals(dt);
                }
                else
                {
                    pnlCartEmpty.Visible = true;
                    pnlCartContent.Visible = false;
                    
                    // Clear coupon
                    Session.Remove("CouponCode");
                    Session.Remove("CouponPercent");
                }
            }
            catch (Exception)
            {
                pnlCartEmpty.Visible = true;
                pnlCartContent.Visible = false;
            }
        }

        private void CalculateTotals(DataTable dt)
        {
            decimal subtotal = 0;
            foreach (DataRow row in dt.Rows)
            {
                subtotal += Convert.ToDecimal(row["LineTotal"]);
            }

            decimal discountPercent = 0;
            if (Session["CouponPercent"] != null)
            {
                discountPercent = Convert.ToDecimal(Session["CouponPercent"]);
                lblCouponCode.Text = Session["CouponCode"].ToString();
                pnlDiscountRow.Visible = true;
            }
            else
            {
                pnlDiscountRow.Visible = false;
            }

            decimal discountAmount = subtotal * (discountPercent / 100);
            decimal discountedSubtotal = subtotal - discountAmount;
            decimal tax = discountedSubtotal * 0.18m; // GST 18%
            decimal total = discountedSubtotal + tax;

            lblSubtotal.Text = string.Format("{0:N0}", subtotal);
            lblDiscountAmount.Text = string.Format("{0:N0}", discountAmount);
            lblTax.Text = string.Format("{0:N0}", tax);
            lblTotal.Text = string.Format("{0:N0}", total);

            // Save totals in Session for Checkout validation
            Session["CartSubtotal"] = subtotal;
            Session["CartDiscount"] = discountAmount;
            Session["CartTax"] = tax;
            Session["CartTotal"] = total;
        }

        protected void gvCart_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "RemoveItem")
            {
                int cartId = Convert.ToInt32(e.CommandArgument);
                try
                {
                    DBHelper.RemoveFromCart(cartId);
                    SessionHelper.RefreshCartCount();
                    BindCart();
                }
                catch (Exception) { }
            }
            else if (e.CommandName == "IncQty" || e.CommandName == "DecQty")
            {
                int rowIndex = Convert.ToInt32(e.CommandArgument);
                int cartId = Convert.ToInt32(gvCart.DataKeys[rowIndex].Value);
                TextBox txtQty = (TextBox)gvCart.Rows[rowIndex].FindControl("txtQty");
                
                int qty = Convert.ToInt32(txtQty.Text);
                int newQty = e.CommandName == "IncQty" ? qty + 1 : qty - 1;

                try
                {
                    if (newQty <= 0)
                    {
                        DBHelper.RemoveFromCart(cartId);
                    }
                    else
                    {
                        DBHelper.UpdateCartQuantity(cartId, newQty);
                    }
                    SessionHelper.RefreshCartCount();
                    BindCart();
                }
                catch (Exception) { }
            }
        }

        protected void btnApplyCoupon_Click(object sender, EventArgs e)
        {
            lblCouponMsg.Visible = false;
            string code = txtCoupon.Text.Trim();

            if (string.IsNullOrEmpty(code))
            {
                lblCouponMsg.Text = "Please enter a coupon code.";
                lblCouponMsg.CssClass = "text-danger d-block mt-2";
                lblCouponMsg.Visible = true;
                return;
            }

            try
            {
                DataRow coupon = DBHelper.ValidateCoupon(code);
                if (coupon != null)
                {
                    decimal percent = Convert.ToDecimal(coupon["DiscountPercent"]);
                    Session["CouponCode"] = code;
                    Session["CouponPercent"] = percent;

                    lblCouponMsg.Text = string.Format("Coupon '{0}' applied successfully ({1}% OFF)!", code, percent);
                    lblCouponMsg.CssClass = "text-success d-block mt-2";
                    lblCouponMsg.Visible = true;

                    // Re-bind to recalculate totals
                    BindCart();
                }
                else
                {
                    Session.Remove("CouponCode");
                    Session.Remove("CouponPercent");
                    lblCouponMsg.Text = "Invalid or expired coupon code.";
                    lblCouponMsg.CssClass = "text-danger d-block mt-2";
                    lblCouponMsg.Visible = true;
                    BindCart();
                }
            }
            catch (Exception ex)
            {
                lblCouponMsg.Text = "Error validating coupon: " + ex.Message;
                lblCouponMsg.CssClass = "text-danger d-block mt-2";
                lblCouponMsg.Visible = true;
            }
        }

        protected void btnCheckout_Click(object sender, EventArgs e)
        {
            Response.Redirect("Checkout.aspx", true);
        }
    }
}
