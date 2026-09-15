using System;
using System.Data;
using System.Web.UI;
using CYPHER.App_Code;

namespace CYPHER.Pages
{
    public partial class Brands : Page
    {
        protected global::System.Web.UI.WebControls.Repeater rptBrands;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadBrands();
            }
        }

        private void LoadBrands()
        {
            try
            {
                DataTable dt = DBHelper.GetAllBrands();
                rptBrands.DataSource = dt;
                rptBrands.DataBind();
            }
            catch (Exception)
            {
                // Silence or log error
            }
        }
    }
}
