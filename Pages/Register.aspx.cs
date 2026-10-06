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
    public partial class Register : System.Web.UI.Page
    {
        SqlConnection con;//For Connection
        SqlCommand cmd;//For insert, update, delete

        string s = ConfigurationManager.ConnectionStrings["CypherDB"].ConnectionString;//For Connection String

        protected void Page_Load(object sender, EventArgs e)
        {
            getcon();
        }

        void getcon()
        {
            con = new SqlConnection(s);
            con.Open();
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (btnRegister.Text == "Create Account")
            {
                getcon();

                // Check if email already exists
                SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM Users WHERE Email='" + txtEmail.Text + "'", con);
                int count = (int)checkCmd.ExecuteScalar();

                if (count > 0)
                {
                    // Email already exists
                }
                else
                {
                    // Insert new record
                    cmd = new SqlCommand("INSERT INTO Users(FullName,Email,PasswordHash) VALUES('"
                                         + txtFullName.Text + "','"
                                         + txtEmail.Text + "','"
                                         + txtPassword.Text + "')", con);
                    cmd.ExecuteNonQuery();
                    Response.Redirect("Login.aspx");
                }
                
            }
        }
    }
}
