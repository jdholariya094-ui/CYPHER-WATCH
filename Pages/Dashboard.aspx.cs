using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using CYPHER.App_Code;

namespace CYPHER.Pages
{
    public partial class Dashboard : Page
    {
        protected global::System.Web.UI.WebControls.Label lblUserSidebarName;
        protected global::System.Web.UI.WebControls.Label lblUserSidebarEmail;
        protected global::System.Web.UI.WebControls.LinkButton lnkTabProfile;
        protected global::System.Web.UI.WebControls.LinkButton lnkTabOrders;
        protected global::System.Web.UI.WebControls.LinkButton lnkTabWishlist;
        protected global::System.Web.UI.WebControls.Panel pnlProfile;
        protected global::System.Web.UI.WebControls.Panel pnlProfileSuccess;
        protected global::System.Web.UI.WebControls.Panel pnlProfileError;
        protected global::System.Web.UI.WebControls.Label lblProfileError;
        protected global::System.Web.UI.WebControls.TextBox txtFullName;
        protected global::System.Web.UI.WebControls.TextBox txtEmail;
        protected global::System.Web.UI.WebControls.TextBox txtPhone;
        protected global::System.Web.UI.WebControls.TextBox txtAddress;
        protected global::System.Web.UI.WebControls.TextBox txtCity;
        protected global::System.Web.UI.WebControls.TextBox txtState;
        protected global::System.Web.UI.WebControls.TextBox txtZip;
        protected global::System.Web.UI.WebControls.Button btnUpdateProfile;
        protected global::System.Web.UI.WebControls.Panel pnlOrders;
        protected global::System.Web.UI.WebControls.Repeater rptOrders;
        protected global::System.Web.UI.WebControls.Panel pnlNoOrders;
        protected global::System.Web.UI.WebControls.Panel pnlWishlist;
        protected global::System.Web.UI.WebControls.Repeater rptWishlist;
        protected global::System.Web.UI.WebControls.Panel pnlNoWishlist;

        protected void Page_Load(object sender, EventArgs e)
        {
            SessionHelper.RequireUserLogin(Request.Url.PathAndQuery);

            if (!IsPostBack)
            {
                LoadUserDetails();

                string activeTab = Request.QueryString["tab"];
                if (string.IsNullOrEmpty(activeTab)) activeTab = "profile";

                SwitchTab(activeTab);
            }
        }

        private void LoadUserDetails()
        {
            int userId = SessionHelper.CurrentUserID;
            try
            {
                DataRow userRow = DBHelper.GetUserByID(userId);
                if (userRow != null)
                {
                    lblUserSidebarName.Text = userRow["FullName"].ToString();
                    lblUserSidebarEmail.Text = userRow["Email"].ToString();

                    txtFullName.Text = userRow["FullName"].ToString();
                    txtEmail.Text = userRow["Email"].ToString();
                    txtPhone.Text = userRow["Phone"] != DBNull.Value ? userRow["Phone"].ToString() : string.Empty;
                    txtAddress.Text = userRow["Address"] != DBNull.Value ? userRow["Address"].ToString() : string.Empty;
                    txtCity.Text = userRow["City"] != DBNull.Value ? userRow["City"].ToString() : string.Empty;
                    txtState.Text = userRow["State"] != DBNull.Value ? userRow["State"].ToString() : string.Empty;
                    txtZip.Text = userRow["ZipCode"] != DBNull.Value ? userRow["ZipCode"].ToString() : string.Empty;
                }
            }
            catch (Exception) { }
        }

        protected void lnkTab_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string tabName = btn.CommandArgument;
            SwitchTab(tabName);
        }

        private void SwitchTab(string tabName)
        {
            pnlProfile.Visible = false;
            pnlOrders.Visible = false;
            pnlWishlist.Visible = false;

            lnkTabProfile.CssClass = "btn btn-dark w-100 text-start py-2 px-3";
            lnkTabOrders.CssClass = "btn btn-dark w-100 text-start py-2 px-3";
            lnkTabWishlist.CssClass = "btn btn-dark w-100 text-start py-2 px-3";

            int userId = SessionHelper.CurrentUserID;

            switch (tabName.ToLower())
            {
                case "orders":
                    pnlOrders.Visible = true;
                    lnkTabOrders.CssClass = "btn btn-warning w-100 text-start py-2 px-3 text-dark";
                    BindOrders(userId);
                    break;
                case "wishlist":
                    pnlWishlist.Visible = true;
                    lnkTabWishlist.CssClass = "btn btn-warning w-100 text-start py-2 px-3 text-dark";
                    BindWishlist(userId);
                    break;
                case "profile":
                default:
                    pnlProfile.Visible = true;
                    lnkTabProfile.CssClass = "btn btn-warning w-100 text-start py-2 px-3 text-dark";
                    break;
            }
        }

        private void BindOrders(int userId)
        {
            try
            {
                DataTable dt = DBHelper.GetOrdersByUser(userId);
                if (dt != null && dt.Rows.Count > 0)
                {
                    rptOrders.DataSource = dt;
                    rptOrders.DataBind();
                    rptOrders.Visible = true;
                    pnlNoOrders.Visible = false;
                }
                else
                {
                    rptOrders.Visible = false;
                    pnlNoOrders.Visible = true;
                }
            }
            catch (Exception) { }
        }

        private void BindWishlist(int userId)
        {
            try
            {
                DataTable dt = DBHelper.GetWishlistByUser(userId);
                if (dt != null && dt.Rows.Count > 0)
                {
                    rptWishlist.DataSource = dt;
                    rptWishlist.DataBind();
                    rptWishlist.Visible = true;
                    pnlNoWishlist.Visible = false;
                }
                else
                {
                    rptWishlist.Visible = false;
                    pnlNoWishlist.Visible = true;
                }
            }
            catch (Exception) { }
        }

        protected void rptOrders_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                int orderId = Convert.ToInt32(rowView["OrderID"]);
                
                Repeater rptDetails = (Repeater)e.Item.FindControl("rptOrderDetails");
                if (rptDetails != null)
                {
                    try
                    {
                        DataTable detailsDt = DBHelper.GetOrderDetailsByOrder(orderId);
                        rptDetails.DataSource = detailsDt;
                        rptDetails.DataBind();
                    }
                    catch (Exception) { }
                }
            }
        }

        protected void rptWishlist_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "RemoveWish")
            {
                int productId = Convert.ToInt32(e.CommandArgument);
                int userId = SessionHelper.CurrentUserID;

                try
                {
                    DBHelper.ToggleWishlist(userId, productId);
                    BindWishlist(userId);
                }
                catch (Exception) { }
            }
        }

        protected void btnUpdateProfile_Click(object sender, EventArgs e)
        {
            pnlProfileSuccess.Visible = false;
            pnlProfileError.Visible = false;

            int userId = SessionHelper.CurrentUserID;
            string fullName = txtFullName.Text.Trim();
            string phone = txtPhone.Text.Trim();
            string address = txtAddress.Text.Trim();
            string city = txtCity.Text.Trim();
            string state = txtState.Text.Trim();
            string zip = txtZip.Text.Trim();

            if (string.IsNullOrEmpty(fullName))
            {
                lblProfileError.Text = "Full Name is required.";
                pnlProfileError.Visible = true;
                return;
            }

            try
            {
                bool success = DBHelper.UpdateUserProfile(userId, fullName, phone, address, city, state, zip);
                if (success)
                {
                    pnlProfileSuccess.Visible = true;
                    LoadUserDetails();
                }
                else
                {
                    lblProfileError.Text = "Could not update profile details. Please try again.";
                    pnlProfileError.Visible = true;
                }
            }
            catch (Exception ex)
            {
                lblProfileError.Text = "Error: " + ex.Message;
                pnlProfileError.Visible = true;
            }
        }

        public string GetStatusBadgeClass(string status)
        {
            switch (status.ToLower())
            {
                case "pending":
                    return "bg-warning text-dark";
                case "shipped":
                    return "bg-info text-dark";
                case "delivered":
                    return "bg-success text-light";
                case "cancelled":
                case "failed":
                    return "bg-danger text-light";
                default:
                    return "bg-secondary text-light";
            }
        }
    }
}
