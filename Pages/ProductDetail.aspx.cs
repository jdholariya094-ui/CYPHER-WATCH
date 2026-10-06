using System;
using System.Data;
using System.Web;
using System.Web.UI;
using CYPHER.App_Code;

namespace CYPHER.Pages
{
    public partial class ProductDetail : Page
    {
        protected global::System.Web.UI.WebControls.Label lblBreadcrumbName;
        protected global::System.Web.UI.WebControls.Panel pnlProduct;
        protected global::System.Web.UI.WebControls.Image imgProduct;
        protected global::System.Web.UI.WebControls.Label lblBrand;
        protected global::System.Web.UI.WebControls.Label lblName;
        protected global::System.Web.UI.WebControls.Label lblRatingCount;
        protected global::System.Web.UI.WebControls.Label lblPriceOriginal;
        protected global::System.Web.UI.WebControls.Label lblPriceCurrent;
        protected global::System.Web.UI.WebControls.Label lblDiscount;
        protected global::System.Web.UI.HtmlControls.HtmlGenericControl badgeStock;
        protected global::System.Web.UI.WebControls.Label lblDescription;
        protected global::System.Web.UI.WebControls.DropDownList ddlQty;
        protected global::System.Web.UI.WebControls.Button btnAddToCart;
        protected global::System.Web.UI.WebControls.Label lblCartMessage;
        protected global::System.Web.UI.WebControls.Label lblSpecCase;
        protected global::System.Web.UI.WebControls.Label lblSpecWater;
        protected global::System.Web.UI.WebControls.Label lblSpecMovement;
        protected global::System.Web.UI.WebControls.Label lblSpecDial;
        protected global::System.Web.UI.WebControls.Label lblSpecGlass;
        protected global::System.Web.UI.WebControls.Label lblSpecBand;
        protected global::System.Web.UI.WebControls.Label lblSpecWarranty;
        protected global::System.Web.UI.WebControls.Panel pnlReviewAlert;
        protected global::System.Web.UI.WebControls.Label lblReviewAlert;
        protected global::System.Web.UI.WebControls.DropDownList ddlRating;
        protected global::System.Web.UI.WebControls.TextBox txtReviewText;
        protected global::System.Web.UI.WebControls.Button btnSubmitReview;
        protected global::System.Web.UI.WebControls.Repeater rptReviews;
        protected global::System.Web.UI.WebControls.Panel pnlNoReviews;
        protected global::System.Web.UI.WebControls.Panel pnlError;

        private int ProductID
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
            if (!IsPostBack)
            {
                if (ProductID > 0)
                {
                    LoadProductDetails();
                    LoadReviews();
                }
                else
                {
                    ShowError();
                }
            }
        }

        private void LoadProductDetails()
        {
            try
            {
                DataRow product = DBHelper.GetProductByID(ProductID);
                if (product != null)
                {
                    pnlProduct.Visible = true;
                    pnlError.Visible = false;

                    // Breadcrumb and Basic info
                    string productName = GetVal(product, "Luxury Timepiece", "ProductName");
                    lblBreadcrumbName.Text = productName;
                    lblName.Text = productName;
                    lblBrand.Text = GetVal(product, "CYPHER", "BrandName");
                    lblRatingCount.Text = GetVal(product, "0", "ReviewCount", "RatingCount");
                    lblDescription.Text = GetVal(product, "", "Description");

                    // Image
                    imgProduct.ImageUrl = GetVal(product, ResolveUrl("~/Content/images/watches/watch_hero.jpg"), "ImageURL", "ProductImage");
                    imgProduct.Attributes["onerror"] = "this.onerror=null;this.src='" + ResolveUrl("~/Content/images/watches/watch_hero.jpg") + "';";

                    // Price & Discount
                    decimal price = Convert.ToDecimal(product["Price"]);
                    decimal discountPercent = Convert.ToDecimal(product["DiscountPercent"]);
                    
                    if (discountPercent > 0)
                    {
                        lblPriceOriginal.Text = "₹" + string.Format("{0:N0}", price);
                        lblDiscount.Text = "-" + Convert.ToInt32(discountPercent) + "% OFF";
                        lblDiscount.Visible = true;
                        
                        decimal currentPrice = price * (1 - (discountPercent / 100));
                        lblPriceCurrent.Text = string.Format("{0:N0}", currentPrice);
                    }
                    else
                    {
                        lblPriceOriginal.Visible = false;
                        lblDiscount.Visible = false;
                        lblPriceCurrent.Text = string.Format("{0:N0}", price);
                    }

                    // Stock Status
                    int stock = Convert.ToInt32(GetVal(product, "10", "StockQuantity", "StockQty"));
                    if (stock > 0)
                    {
                        badgeStock.InnerText = "IN STOCK";
                        badgeStock.Attributes["class"] = "badge bg-success";
                        btnAddToCart.Enabled = true;
                        btnAddToCart.Text = "Add To Cart";
                    }
                    else
                    {
                        badgeStock.InnerText = "OUT OF STOCK";
                        badgeStock.Attributes["class"] = "badge bg-danger";
                        btnAddToCart.Enabled = false;
                        btnAddToCart.Text = "Out of Stock";
                    }

                    // Specifications
                    lblSpecCase.Text = GetVal(product, "42mm", "CaseDiameter", "CaseSize", "CaseColor");
                    lblSpecWater.Text = GetVal(product, "50m", "WaterResistance");
                    lblSpecMovement.Text = GetVal(product, "Automatic", "Movement");
                    lblSpecDial.Text = GetVal(product, "Black", "CaseColor", "DialColor");
                    lblSpecGlass.Text = GetVal(product, "Sapphire Crystal", "Crystal", "GlassType");
                    lblSpecBand.Text = GetVal(product, "Stainless Steel", "StrapMaterial", "BandMaterial");
                    lblSpecWarranty.Text = GetVal(product, "2 Years", "WarrantyYears");
                }
                else
                {
                    ShowError();
                }
            }
            catch (Exception)
            {
                ShowError();
            }
        }

        private void LoadReviews()
        {
            try
            {
                DataTable dt = DBHelper.GetApprovedReviews(ProductID);
                if (dt != null && dt.Rows.Count > 0)
                {
                    rptReviews.DataSource = dt;
                    rptReviews.DataBind();
                    rptReviews.Visible = true;
                    pnlNoReviews.Visible = false;
                }
                else
                {
                    rptReviews.Visible = false;
                    pnlNoReviews.Visible = true;
                }
            }
            catch (Exception)
            {
                // Silence
            }
        }

        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            if (!SessionHelper.IsUserLoggedIn)
            {
                // Redirect to login with ReturnUrl
                string returnUrl = Request.Url.PathAndQuery;
                Response.Redirect("Login.aspx?ReturnUrl=" + HttpUtility.UrlEncode(returnUrl), true);
                return;
            }

            int userId = SessionHelper.CurrentUserID;
            int qty = Convert.ToInt32(ddlQty.SelectedValue);

            try
            {
                DBHelper.AddToCart(userId, ProductID, qty);
                SessionHelper.RefreshCartCount();
                
                // Show message
                lblCartMessage.Text = string.Format("<i class='fas fa-check-circle me-1'></i> Added {0} item(s) to your cart successfully!", qty);
                lblCartMessage.Visible = true;
            }
            catch (Exception ex)
            {
                lblCartMessage.Text = "<span class='text-danger'>Error: " + ex.Message + "</span>";
                lblCartMessage.Visible = true;
            }
        }

        protected void btnSubmitReview_Click(object sender, EventArgs e)
        {
            pnlReviewAlert.Visible = false;

            if (!SessionHelper.IsUserLoggedIn)
            {
                lblReviewAlert.Text = "Please log in to submit a review.";
                pnlReviewAlert.Visible = true;
                return;
            }

            int userId = SessionHelper.CurrentUserID;
            int rating = Convert.ToInt32(ddlRating.SelectedValue);
            string reviewText = txtReviewText.Text.Trim();

            if (string.IsNullOrEmpty(reviewText))
            {
                lblReviewAlert.Text = "Please enter some review text.";
                pnlReviewAlert.Visible = true;
                return;
            }

            try
            {
                DBHelper.AddReview(ProductID, userId, rating, reviewText);
                
                txtReviewText.Text = string.Empty;
                ddlRating.SelectedValue = "5";

                // Re-bind reviews
                LoadReviews();

                lblReviewAlert.Text = "Thank you! Your review has been submitted and is pending approval.";
                pnlReviewAlert.Attributes["class"] = "alert alert-success bg-dark text-success border-success p-2 mb-3";
                pnlReviewAlert.Visible = true;
            }
            catch (Exception ex)
            {
                lblReviewAlert.Text = "Error submitting review: " + ex.Message;
                pnlReviewAlert.Attributes["class"] = "alert alert-danger bg-dark text-danger border-danger p-2 mb-3";
                pnlReviewAlert.Visible = true;
            }
        }

        private void ShowError()
        {
            pnlProduct.Visible = false;
            pnlError.Visible = true;
        }

        public string GetStarsHtml(int rating)
        {
            return GetStarsHtml((object)rating);
        }

        public string GetStarsHtml(object ratingObj)
        {
            int rating = 5;
            if (ratingObj != null && ratingObj != DBNull.Value)
            {
                int.TryParse(ratingObj.ToString(), out rating);
            }
            string html = "";
            for (int i = 1; i <= 5; i++)
            {
                if (i <= rating) html += "<i class=\"fas fa-star\"></i>";
                else html += "<i class=\"far fa-star\"></i>";
            }
            return html;
        }

        public string GetReviewDate(object dataItem)
        {
            try
            {
                DataRowView rowView = dataItem as DataRowView;
                if (rowView != null)
                {
                    if (rowView.Row.Table.Columns.Contains("CreatedAt") && rowView["CreatedAt"] != DBNull.Value)
                    {
                        DateTime dt;
                        if (DateTime.TryParse(rowView["CreatedAt"].ToString(), out dt))
                            return dt.ToString("MMMM dd, yyyy");
                    }
                    if (rowView.Row.Table.Columns.Contains("CreatedDate") && rowView["CreatedDate"] != DBNull.Value)
                    {
                        DateTime dt;
                        if (DateTime.TryParse(rowView["CreatedDate"].ToString(), out dt))
                            return dt.ToString("MMMM dd, yyyy");
                    }
                }
            }
            catch { }
            return "";
        }

        public string FormatReviewDate(object dateObj)
        {
            if (dateObj == null || dateObj == DBNull.Value) return "";
            DateTime dt;
            if (DateTime.TryParse(dateObj.ToString(), out dt))
            {
                return dt.ToString("MMMM dd, yyyy");
            }
            return dateObj.ToString();
        }

        private string GetVal(DataRow row, string defaultVal, params string[] columnNames)
        {
            if (row == null) return defaultVal;
            foreach (var col in columnNames)
            {
                if (row.Table.Columns.Contains(col) && row[col] != DBNull.Value)
                {
                    string s = row[col].ToString();
                    if (!string.IsNullOrWhiteSpace(s)) return s;
                }
            }
            return defaultVal;
        }
    }
}
