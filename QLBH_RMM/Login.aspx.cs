using System;
using System.Data.SqlClient;
using System.Web.Security;

namespace QLBH_RMM
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserName"] != null)
            {
                Response.Redirect("~/TrangChu.aspx");
            }
        }

        protected void Login1_LoggedIn(object sender, EventArgs e)
        {
            string userName = Login1.UserName;
            string password = Login1.Password; // Get the entered password

            // Validate the user with Membership
            if (Membership.ValidateUser(userName, password))
            {
                // If validation is successful, retrieve the customer ID from the QuanLyBanHang database
                string connectionString = "Data Source=TRIPLETANDV;Initial Catalog=QuanLyBanHang;Integrated Security=True";
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    // Retrieve customer ID based on username
                    string selectKhachHangIdQuery = "SELECT MaKH FROM TaiKhoan WHERE TenDN = @TenDN";
                    using (SqlCommand command = new SqlCommand(selectKhachHangIdQuery, connection))
                    {
                        command.Parameters.AddWithValue("@TenDN", userName);
                        var result = command.ExecuteScalar();

                        if (result != null)
                        {
                            // Store username and customer ID in session
                            Session["UserName"] = userName;
                            Session["CustomerId"] = result.ToString();

                            // Check if the user has admin role
                            if (Roles.IsUserInRole(userName, "admin"))
                            {
                                // Set authentication cookie and redirect to admin home
                                FormsAuthentication.SetAuthCookie(userName, Login1.RememberMeSet);
                                Response.Redirect("~/Admin/Home.aspx");
                            }
                            else
                            {
                                // Redirect to the main page if not admin
                                Response.Redirect("~/TrangChu.aspx");
                            }
                        }
                        else
                        {
                            // Handle case where customer ID is not found
                            Login1.FailureText = "Customer ID not found.";
                        }
                    }
                }
            }
            else
            {
                // Optionally handle failed login attempts
                // You can display an error message to the user
                Login1.FailureText = "Invalid username or password.";
            }
        }
    }
}
