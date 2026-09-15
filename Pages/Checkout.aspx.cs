using System;
using System.Data;
using System.Web.UI;
using CYPHER.App_Code;

namespace CYPHER.Pages
{
    public partial class Checkout : Page
    {
        protected global::System.Web.UI.WebControls.Panel pnlError;
        protected global::System.Web.UI.WebControls.Label lblError;
        protected global::System.Web.UI.WebControls.TextBox txtFullName;
        protected global::System.Web.UI.WebControls.TextBox txtPhone;
        protected global::System.Web.UI.WebControls.TextBox txtAddress;
        protected global::System.Web.UI.WebControls.TextBox txtCity;
        protected global::System.Web.UI.WebControls.TextBox txtState;
        protected global::System.Web.UI.WebControls.TextBox txtZip;
        protected global::System.Web.UI.WebControls.RadioButtonList rblPayment;
        protected global::System.Web.UI.WebControls.Panel pnlCardDetails;
        protected global::System.Web.UI.WebControls.TextBox txtCardName;
        protected global::System.Web.UI.WebControls.TextBox txtCardNum;
        protected global::System.Web.UI.WebControls.TextBox txtCardExp;
        protected global::System.Web.UI.WebControls.TextBox txtCardCVV;
        protected global::System.Web.UI.WebControls.Panel pnlUPIDetails;
        protected global::System.Web.UI.WebControls.TextBox txtUPIID;
        protected global::System.Web.UI.WebControls.Repeater rptSummaryItems;
        protected global::System.Web.UI.WebControls.Label lblSubtotal;
        protected global::System.Web.UI.WebControls.Panel pnlDiscountRow;
        protected global::System.Web.UI.WebControls.Label lblDiscount;
        protected global::System.Web.UI.WebControls.Label lblTax;
        protected global::System.Web.UI.WebControls.Label lblTotal;
        protected global::System.Web.UI.WebControls.Button btnPlaceOrder;

        protected void Page_Load(object sender, EventArgs e)
        {
            SessionHelper.RequireUserLogin(Request.Url.PathAndQuery);

            if (!IsPostBack)
            {
                BindCheckoutSummary();
            }
        }

        private void BindCheckoutSummary()
        {
            int userId = SessionHelper.CurrentUserID;
            try
            {
                DataTable dt = DBHelper.GetCartByUser(userId);
                if (dt == null || dt.Rows.Count == 0)
                {
                    Response.Redirect("Cart.aspx", true);
                    return;
                }

                rptSummaryItems.DataSource = dt;
                rptSummaryItems.DataBind();

                // Get values from Session or calculate if missing
                decimal subtotal = 0;
                foreach (DataRow row in dt.Rows)
                {
                    subtotal += Convert.ToDecimal(row["LineTotal"]);
                }

                decimal discountAmount = 0;
                if (Session["CartDiscount"] != null)
                {
                    discountAmount = Convert.ToDecimal(Session["CartDiscount"]);
                    lblDiscount.Text = string.Format("{0:N0}", discountAmount);
                    pnlDiscountRow.Visible = true;
                }

                decimal tax = (subtotal - discountAmount) * 0.18m;
                decimal grandTotal = (subtotal - discountAmount) + tax;

                lblSubtotal.Text = string.Format("{0:N0}", subtotal);
                lblTax.Text = string.Format("{0:N0}", tax);
                lblTotal.Text = string.Format("{0:N0}", grandTotal);
            }
            catch (Exception)
            {
                Response.Redirect("Cart.aspx", true);
            }
        }

        protected void rblPayment_SelectedIndexChanged(object sender, EventArgs e)
        {
            string payMethod = rblPayment.SelectedValue;
            pnlCardDetails.Visible = (payMethod == "Card");
            pnlUPIDetails.Visible = (payMethod == "UPI");
        }

        protected void btnPlaceOrder_Click(object sender, EventArgs e)
        {
            pnlError.Visible = false;

            string fullName = txtFullName.Text.Trim();
            string phone = txtPhone.Text.Trim();
            string address = txtAddress.Text.Trim();
            string city = txtCity.Text.Trim();
            string state = txtState.Text.Trim();
            string zip = txtZip.Text.Trim();
            string paymentMethod = rblPayment.SelectedValue;

            if (string.IsNullOrEmpty(fullName) || string.IsNullOrEmpty(phone) ||
                string.IsNullOrEmpty(address) || string.IsNullOrEmpty(city) ||
                string.IsNullOrEmpty(state) || string.IsNullOrEmpty(zip))
            {
                lblError.Text = "Please fill in all shipping details.";
                pnlError.Visible = true;
                return;
            }

            // Payment verification (mock)
            if (paymentMethod == "Card")
            {
                if (string.IsNullOrEmpty(txtCardName.Text) || string.IsNullOrEmpty(txtCardNum.Text) ||
                    string.IsNullOrEmpty(txtCardExp.Text) || string.IsNullOrEmpty(txtCardCVV.Text))
                {
                    lblError.Text = "Please enter all credit card details.";
                    pnlError.Visible = true;
                    return;
                }
            }
            else if (paymentMethod == "UPI")
            {
                if (string.IsNullOrEmpty(txtUPIID.Text))
                {
                    lblError.Text = "Please enter your UPI ID.";
                    pnlError.Visible = true;
                    return;
                }
            }

            int userId = SessionHelper.CurrentUserID;

            try
            {
                // Fetch Cart items
                DataTable cartDt = DBHelper.GetCartByUser(userId);
                if (cartDt == null || cartDt.Rows.Count == 0)
                {
                    Response.Redirect("Cart.aspx", true);
                    return;
                }

                // Recalculate totals
                decimal subtotal = 0;
                foreach (DataRow row in cartDt.Rows)
                {
                    subtotal += Convert.ToDecimal(row["LineTotal"]);
                }

                decimal discountAmount = 0;
                string couponCode = null;
                if (Session["CouponPercent"] != null)
                {
                    decimal pct = Convert.ToDecimal(Session["CouponPercent"]);
                    discountAmount = subtotal * (pct / 100);
                    couponCode = Session["CouponCode"].ToString();
                }

                decimal tax = (subtotal - discountAmount) * 0.18m;
                decimal grandTotal = (subtotal - discountAmount) + tax;

                // Place Order in DB
                int orderId = DBHelper.PlaceOrder(
                    userId, subtotal, discountAmount, tax, 0, grandTotal,
                    couponCode, paymentMethod, address, city, state, zip);

                // Insert Order Details
                foreach (DataRow item in cartDt.Rows)
                {
                    int productId = Convert.ToInt32(item["ProductID"]);
                    int qty = Convert.ToInt32(item["Quantity"]);
                    decimal price = Convert.ToDecimal(item["Price"]);
                    decimal discPct = Convert.ToDecimal(item["DiscountPercent"]);
                    decimal total = Convert.ToDecimal(item["LineTotal"]);

                    DBHelper.InsertOrderDetail(orderId, productId, qty, price, discPct, total);
                }

                // Clear Cart
                DBHelper.ClearCart(userId);
                SessionHelper.RefreshCartCount();

                // Clear Coupon and Checkout session values
                Session.Remove("CouponCode");
                Session.Remove("CouponPercent");
                Session.Remove("CartSubtotal");
                Session.Remove("CartDiscount");
                Session.Remove("CartTax");
                Session.Remove("CartTotal");

                // Redirect to Success
                Response.Redirect("OrderSuccess.aspx?id=" + orderId, true);
            }
            catch (Exception ex)
            {
                lblError.Text = "An error occurred while placing your order: " + ex.Message;
                pnlError.Visible = true;
            }
        }
    }
}
