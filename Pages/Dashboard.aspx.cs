using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
//New Namespace
using System.Data.SqlClient;//For Connection
using System.Data;//For Dataset
using System.Configuration;//For Connection String

namespace CYPHER.Pages
{
    public partial class Dashboard : System.Web.UI.Page
    {
        SqlConnection con;//For Connection
        SqlCommand cmd;//For insert, update, delete
        SqlDataAdapter da;//For Container
        DataSet ds;//For Select

        string s = ConfigurationManager.ConnectionStrings["CypherDB"].ConnectionString;//For Connection String

        void getcon()
        {
            con = new SqlConnection(s);
            con.Open();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            //Check if user is logged in
            if (Session["user"] == null)
            {
                Response.Redirect("~/Pages/Login.aspx");
            }

            getcon();

            if (!IsPostBack)
            {
                LoadUserDetails();
                pnlProfile.Visible = true;
                pnlOrders.Visible = false;
                pnlWishlist.Visible = false;
            }
        }

        void LoadUserDetails()
        {
            //Select user details from DB using session email
            da = new SqlDataAdapter("select * from Users where Email='" + Session["user"].ToString() + "'", con);
            ds = new DataSet();
            da.Fill(ds);

            if (ds.Tables[0].Rows.Count > 0)
            {
                DataRow row = ds.Tables[0].Rows[0];
                DataColumnCollection cols = ds.Tables[0].Columns;

                //Always present columns
                lblUserSidebarName.Text = row["FullName"].ToString();
                lblUserSidebarEmail.Text = row["Email"].ToString();
                txtFullName.Text = row["FullName"].ToString();
                txtEmail.Text    = row["Email"].ToString();

                //Optional columns — check if they exist in the table first
                txtPhone.Text   = cols.Contains("Phone")   && row["Phone"]   != DBNull.Value ? row["Phone"].ToString()   : "";
                txtAddress.Text = cols.Contains("Address") && row["Address"] != DBNull.Value ? row["Address"].ToString() : "";
                txtCity.Text    = cols.Contains("City")    && row["City"]    != DBNull.Value ? row["City"].ToString()    : "";
                txtState.Text   = cols.Contains("State")   && row["State"]   != DBNull.Value ? row["State"].ToString()   : "";
                txtZip.Text     = cols.Contains("ZipCode") && row["ZipCode"] != DBNull.Value ? row["ZipCode"].ToString() : "";
            }
        }

        protected void lnkTab_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string tabName = btn.CommandArgument;

            pnlProfile.Visible  = false;
            pnlOrders.Visible   = false;
            pnlWishlist.Visible = false;

            if (tabName == "profile")
            {
                pnlProfile.Visible = true;
                LoadUserDetails();
            }
            else if (tabName == "orders")
            {
                pnlOrders.Visible = true;
                LoadOrders();
            }
            else if (tabName == "wishlist")
            {
                pnlWishlist.Visible = true;
            }
        }

        void LoadOrders()
        {
            //Select orders for logged in user
            da = new SqlDataAdapter("select * from Orders where UserID=(select UserID from Users where Email='" + Session["user"].ToString() + "') order by OrderDate desc", con);
            ds = new DataSet();
            da.Fill(ds);

            if (ds.Tables[0].Rows.Count > 0)
            {
                rptOrders.DataSource = ds;
                rptOrders.DataBind();
                rptOrders.Visible  = true;
                pnlNoOrders.Visible = false;
            }
            else
            {
                rptOrders.Visible  = false;
                pnlNoOrders.Visible = true;
            }
        }

        protected void btnUpdateProfile_Click(object sender, EventArgs e)
        {
            pnlProfileSuccess.Visible = false;
            pnlProfileError.Visible   = false;

            if (string.IsNullOrEmpty(txtFullName.Text))
            {
                pnlProfileError.Visible = true;
                lblProfileError.Text    = "Full Name is required.";
                return;
            }

            try
            {
                //Update — only FullName is required; others are optional
                getcon();
                cmd = new SqlCommand("update Users set FullName='" + txtFullName.Text + "',Phone='" + txtPhone.Text + "',Address='" + txtAddress.Text + "',City='" + txtCity.Text + "',State='" + txtState.Text + "',ZipCode='" + txtZip.Text + "' where Email='" + Session["user"].ToString() + "'", con);
                cmd.ExecuteNonQuery();
                pnlProfileSuccess.Visible = true;
                LoadUserDetails();
            }
            catch (Exception)
            {
                //If optional columns don't exist in DB, update only FullName
                getcon();
                cmd = new SqlCommand("update Users set FullName='" + txtFullName.Text + "' where Email='" + Session["user"].ToString() + "'", con);
                cmd.ExecuteNonQuery();
                pnlProfileSuccess.Visible = true;
                LoadUserDetails();
            }
        }

        protected void rptOrders_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            //Required by markup - left empty for basic functionality
        }

        protected void rptWishlist_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            //Required by markup - left empty for basic functionality
        }

        public string GetStatusBadgeClass(string status)
        {
            switch (status.ToLower())
            {
                case "pending":   return "bg-warning text-dark";
                case "shipped":   return "bg-info text-dark";
                case "delivered": return "bg-success text-light";
                case "cancelled":
                case "failed":    return "bg-danger text-light";
                default:          return "bg-secondary text-light";
            }
        }
    }
}

