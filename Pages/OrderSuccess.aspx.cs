using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using CYPHER.App_Code;

namespace CYPHER.Pages
{
    public partial class OrderSuccess : Page
    {
        protected global::System.Web.UI.WebControls.Label lblOrderID;
        protected global::System.Web.UI.WebControls.Label lblDate;
        protected global::System.Web.UI.WebControls.Label lblPayment;
        protected global::System.Web.UI.WebControls.Label lblTotal;

        private int OrderID
        {
            get
            {
                int id;
                if (int.TryParse(Request.QueryString["id"], out id)) return id;
                return 0;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            SessionHelper.RequireUserLogin(Request.Url.PathAndQuery);

            if (!IsPostBack)
            {
                if (OrderID > 0)
                {
                    LoadOrderReceipt();
                }
                else
                {
                    Response.Redirect("Home.aspx");
                }
            }
        }

        private void LoadOrderReceipt()
        {
            try
            {
                string sql = "SELECT * FROM Orders WHERE OrderID=@OID AND UserID=@UID";
                DataRow orderRow = DBHelper.GetDataRow(sql, new[]
                {
                    new SqlParameter("@OID", OrderID),
                    new SqlParameter("@UID", SessionHelper.CurrentUserID)
                });

                if (orderRow != null)
                {
                    lblOrderID.Text = orderRow["OrderID"].ToString();
                    lblDate.Text = Convert.ToDateTime(orderRow["OrderDate"]).ToString("MMMM dd, yyyy hh:mm tt");
                    lblPayment.Text = orderRow["PaymentMethod"].ToString() == "COD" ? "Cash on Delivery" : orderRow["PaymentMethod"].ToString();
                    lblTotal.Text = string.Format("{0:N0}", orderRow["GrandTotal"]);
                }
                else
                {
                    Response.Redirect("Home.aspx");
                }
            }
            catch (Exception)
            {
                Response.Redirect("Home.aspx");
            }
        }
    }
}
