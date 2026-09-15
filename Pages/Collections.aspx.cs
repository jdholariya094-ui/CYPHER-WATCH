using System;
using System.Data;
using System.Web.UI;
using CYPHER.App_Code;

namespace CYPHER.Pages
{
    public partial class Collections : Page
    {
        protected global::System.Web.UI.WebControls.Repeater rptCollections;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCollections();
            }
        }

        private void LoadCollections()
        {
            try
            {
                DataTable dt = DBHelper.GetAllCategories();
                rptCollections.DataSource = dt;
                rptCollections.DataBind();
            }
            catch (Exception)
            {
                // Silence or log error
            }
        }
    }
}
