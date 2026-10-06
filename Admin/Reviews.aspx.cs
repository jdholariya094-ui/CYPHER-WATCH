using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using CYPHER.App_Code;

namespace CYPHER.Admin
{
    public partial class Reviews : Page
    {
        protected global::System.Web.UI.WebControls.Literal litReviewCount;
        protected global::System.Web.UI.WebControls.Panel pnlAlert;
        protected global::System.Web.UI.WebControls.Label lblAlert;
        protected global::System.Web.UI.WebControls.DropDownList ddlReviewFilter;
        protected global::System.Web.UI.WebControls.Repeater rptReviews;

        public string AlertCssClass { get; private set; } = "admin-alert-info";
        public string AlertIconClass { get; private set; } = "fa-info-circle";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadReviews();
            }
        }

        private void LoadReviews()
        {
            try
            {
                var dt = DBHelper.GetAllReviews();
                string filter = ddlReviewFilter.SelectedValue;

                if (filter == "pending")
                {
                    DataTable filtered = dt.Clone();
                    foreach (DataRow row in dt.Rows)
                    {
                        if (!Convert.ToBoolean(row["IsApproved"]))
                            filtered.ImportRow(row);
                    }
                    dt = filtered;
                }
                else if (filter == "approved")
                {
                    DataTable filtered = dt.Clone();
                    foreach (DataRow row in dt.Rows)
                    {
                        if (Convert.ToBoolean(row["IsApproved"]))
                            filtered.ImportRow(row);
                    }
                    dt = filtered;
                }

                rptReviews.DataSource = dt;
                rptReviews.DataBind();
                litReviewCount.Text = dt.Rows.Count.ToString();
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading reviews: " + ex.Message, false);
            }
        }

        protected void FilterChanged(object sender, EventArgs e)
        {
            LoadReviews();
        }

        protected void rptReviews_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int reviewId = Convert.ToInt32(e.CommandArgument);

            try
            {
                if (e.CommandName == "Approve")
                {
                    DBHelper.ApproveReview(reviewId, true);
                    ShowAlert("Review #" + reviewId + " approved and published to store.", true);
                }
                else if (e.CommandName == "Revoke")
                {
                    DBHelper.ApproveReview(reviewId, false);
                    ShowAlert("Review #" + reviewId + " status changed to pending.", true);
                }
                else if (e.CommandName == "DeleteReview")
                {
                    DBHelper.DeleteReview(reviewId);
                    ShowAlert("Review #" + reviewId + " deleted permanently.", true);
                }
                LoadReviews();
            }
            catch (Exception ex)
            {
                ShowAlert("Error executing review action: " + ex.Message, false);
            }
        }

        public string GetStars(int rating)
        {
            string s = "";
            for (int i = 1; i <= 5; i++)
            {
                s += (i <= rating) ? "★" : "☆";
            }
            return s;
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
