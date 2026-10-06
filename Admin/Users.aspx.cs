using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using CYPHER.App_Code;

namespace CYPHER.Admin
{
    public partial class Users : Page
    {
        protected global::System.Web.UI.WebControls.Literal litCount;
        protected global::System.Web.UI.WebControls.Panel pnlAlert;
        protected global::System.Web.UI.WebControls.Label lblAlert;
        protected global::System.Web.UI.WebControls.TextBox txtSearch;
        protected global::System.Web.UI.WebControls.Button btnSearch;
        protected global::System.Web.UI.WebControls.Button btnReset;
        protected global::System.Web.UI.WebControls.Repeater rptUsers;

        public string AlertCssClass { get; private set; } = "admin-alert-info";
        public string AlertIconClass { get; private set; } = "fa-info-circle";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadUsers();
            }
        }

        private void LoadUsers()
        {
            try
            {
                var dt = DBHelper.GetAllUsers();
                string query = txtSearch.Text.Trim().ToLower();

                if (!string.IsNullOrEmpty(query))
                {
                    DataTable filtered = dt.Clone();
                    foreach (DataRow row in dt.Rows)
                    {
                        string name = row["FullName"].ToString().ToLower();
                        string email = row["Email"].ToString().ToLower();
                        string city = row["City"] != DBNull.Value ? row["City"].ToString().ToLower() : "";
                        if (name.Contains(query) || email.Contains(query) || city.Contains(query))
                        {
                            filtered.ImportRow(row);
                        }
                    }
                    dt = filtered;
                }

                rptUsers.DataSource = dt;
                rptUsers.DataBind();
                litCount.Text = dt.Rows.Count.ToString();
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading users: " + ex.Message, false);
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadUsers();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            LoadUsers();
        }

        protected void rptUsers_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ToggleActive")
            {
                int userId = Convert.ToInt32(e.CommandArgument);
                try
                {
                    DBHelper.ToggleUserStatus(userId);
                    ShowAlert("Client account status updated.", true);
                    LoadUsers();
                }
                catch (Exception ex)
                {
                    ShowAlert("Error updating client status: " + ex.Message, false);
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
