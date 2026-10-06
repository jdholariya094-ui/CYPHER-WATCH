using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using CYPHER.App_Code;

namespace CYPHER.Admin
{
    public partial class Orders : Page
    {
        protected global::System.Web.UI.WebControls.Literal litOrderCount;
        protected global::System.Web.UI.WebControls.Panel pnlAlert;
        protected global::System.Web.UI.WebControls.Label lblAlert;

        protected global::System.Web.UI.WebControls.Panel pnlOrderDetails;
        protected global::System.Web.UI.WebControls.Literal litModalOrderID;
        protected global::System.Web.UI.WebControls.LinkButton btnCloseModal;
        protected global::System.Web.UI.WebControls.HiddenField hdnModalOrderID;
        protected global::System.Web.UI.WebControls.Literal litCustName;
        protected global::System.Web.UI.WebControls.Literal litCustEmail;
        protected global::System.Web.UI.WebControls.Literal litCustPhone;
        protected global::System.Web.UI.WebControls.Literal litOrderDate;
        protected global::System.Web.UI.WebControls.Literal litShippingAddress;
        protected global::System.Web.UI.WebControls.Repeater rptOrderItems;
        protected global::System.Web.UI.WebControls.Literal litSubtotal;
        protected global::System.Web.UI.WebControls.Literal litDiscount;
        protected global::System.Web.UI.WebControls.Literal litGST;
        protected global::System.Web.UI.WebControls.Literal litShipping;
        protected global::System.Web.UI.WebControls.Literal litGrandTotal;
        protected global::System.Web.UI.WebControls.DropDownList ddlModalOrderStatus;
        protected global::System.Web.UI.WebControls.DropDownList ddlModalPaymentStatus;
        protected global::System.Web.UI.WebControls.TextBox txtModalTracking;
        protected global::System.Web.UI.WebControls.TextBox txtModalNotes;
        protected global::System.Web.UI.WebControls.Button btnCloseModalBottom;
        protected global::System.Web.UI.WebControls.Button btnUpdateOrder;

        protected global::System.Web.UI.WebControls.TextBox txtSearch;
        protected global::System.Web.UI.WebControls.DropDownList ddlStatusFilter;
        protected global::System.Web.UI.WebControls.Button btnFilter;
        protected global::System.Web.UI.WebControls.Button btnReset;
        protected global::System.Web.UI.WebControls.Repeater rptOrders;

        public string AlertCssClass { get; private set; } = "admin-alert-info";
        public string AlertIconClass { get; private set; } = "fa-info-circle";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["status"] != null)
                {
                    string st = Request.QueryString["status"];
                    if (ddlStatusFilter.Items.FindByValue(st) != null)
                        ddlStatusFilter.SelectedValue = st;
                }

                LoadOrders();

                if (Request.QueryString["view"] != null)
                {
                    int viewId = 0;
                    if (int.TryParse(Request.QueryString["view"], out viewId))
                    {
                        OpenOrderDetails(viewId);
                    }
                }
            }
        }

        private void LoadOrders()
        {
            try
            {
                string status = ddlStatusFilter.SelectedValue;
                string search = txtSearch.Text.Trim();

                var dt = DBHelper.GetAllOrders(0, 100, status, search);
                rptOrders.DataSource = dt;
                rptOrders.DataBind();
                litOrderCount.Text = dt.Rows.Count.ToString();
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading orders: " + ex.Message, false);
            }
        }

        protected void FilterChanged(object sender, EventArgs e)
        {
            LoadOrders();
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            LoadOrders();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlStatusFilter.SelectedIndex = 0;
            LoadOrders();
        }

        protected void rptOrders_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "InspectOrder")
            {
                int orderId = Convert.ToInt32(e.CommandArgument);
                OpenOrderDetails(orderId);
            }
        }

        private void OpenOrderDetails(int orderId)
        {
            try
            {
                var row = DBHelper.GetOrderHeader(orderId);
                if (row != null)
                {
                    hdnModalOrderID.Value = orderId.ToString();
                    litModalOrderID.Text = orderId.ToString();
                    litCustName.Text = row["FullName"] != DBNull.Value ? row["FullName"].ToString() : "Client #" + row["UserID"];
                    litCustEmail.Text = row["Email"] != DBNull.Value ? row["Email"].ToString() : "N/A";
                    litCustPhone.Text = row["UserPhone"] != DBNull.Value ? row["UserPhone"].ToString() : "Not provided";
                    litOrderDate.Text = Convert.ToDateTime(row["OrderDate"]).ToString("dd MMM yyyy, hh:mm tt");

                    string addr = row["ShippingAddress"] != DBNull.Value ? row["ShippingAddress"].ToString() : "";
                    string city = row["ShippingCity"] != DBNull.Value ? row["ShippingCity"].ToString() : "";
                    string state = row["ShippingState"] != DBNull.Value ? row["ShippingState"].ToString() : "";
                    string zip = row["ShippingZipCode"] != DBNull.Value ? row["ShippingZipCode"].ToString() : "";
                    litShippingAddress.Text = string.Format("{0}<br />{1}, {2} - {3}", addr, city, state, zip);

                    // Pricing
                    decimal total = Convert.ToDecimal(row["TotalAmount"]);
                    decimal disc = Convert.ToDecimal(row["DiscountAmount"]);
                    decimal gst = Convert.ToDecimal(row["GST"]);
                    decimal ship = Convert.ToDecimal(row["ShippingCharge"]);
                    decimal grand = Convert.ToDecimal(row["GrandTotal"]);

                    litSubtotal.Text = total.ToString("N0");
                    litDiscount.Text = disc.ToString("N0");
                    litGST.Text = gst.ToString("N0");
                    litShipping.Text = ship.ToString("N0");
                    litGrandTotal.Text = grand.ToString("N0");

                    // Status dropdowns
                    string ordStatus = row["OrderStatus"].ToString();
                    if (ddlModalOrderStatus.Items.FindByValue(ordStatus) != null)
                        ddlModalOrderStatus.SelectedValue = ordStatus;

                    string payStatus = row["PaymentStatus"] != DBNull.Value ? row["PaymentStatus"].ToString() : "Pending";
                    if (ddlModalPaymentStatus.Items.FindByValue(payStatus) != null)
                        ddlModalPaymentStatus.SelectedValue = payStatus;

                    txtModalTracking.Text = row["TrackingNumber"] != DBNull.Value ? row["TrackingNumber"].ToString() : "";
                    txtModalNotes.Text = row["Notes"] != DBNull.Value ? row["Notes"].ToString() : "";

                    // Items
                    var items = DBHelper.GetOrderDetailsByOrder(orderId);
                    rptOrderItems.DataSource = items;
                    rptOrderItems.DataBind();

                    pnlOrderDetails.Visible = true;
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error inspecting order: " + ex.Message, false);
            }
        }

        protected void btnCloseModal_Click(object sender, EventArgs e)
        {
            pnlOrderDetails.Visible = false;
        }

        protected void btnUpdateOrder_Click(object sender, EventArgs e)
        {
            int orderId = Convert.ToInt32(hdnModalOrderID.Value);
            string status = ddlModalOrderStatus.SelectedValue;
            string payStatus = ddlModalPaymentStatus.SelectedValue;
            string tracking = txtModalTracking.Text.Trim();
            string notes = txtModalNotes.Text.Trim();

            try
            {
                DBHelper.UpdateOrderFull(orderId, status, payStatus, tracking, notes);
                ShowAlert("Order #" + orderId + " updated to status '" + status + "'.", true);
                pnlOrderDetails.Visible = false;
                LoadOrders();
            }
            catch (Exception ex)
            {
                ShowAlert("Error updating order: " + ex.Message, false);
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
