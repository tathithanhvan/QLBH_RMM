using System;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;

namespace QLBH_RMM
{
    public partial class TaiKhoan : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserName"] != null) // Kiểm tra người dùng đã đăng nhập
                {
                    string username = Session["UserName"].ToString();
                    var userInfo = GetUserInfo(username);
                    if (userInfo != null)
                    {
                        // Hiển thị thông tin người dùng
                        lblHoTen.Text = userInfo.FullName; // Hiển thị tên
                        lblEmail.Text = userInfo.Email; // Hiển thị email
                        lblPhoneNumber.Text = userInfo.PhoneNumber; // Hiển thị số điện thoại
                        lblDiaChi.Text = userInfo.Address; // Hiển thị địa chỉ (nếu có)
                    }
                }
                else
                {
                    Response.Redirect("Login.aspx");
                }
            }
        }

        private UserInfo GetUserInfo(string username)
        {
            // Kết nối đến cơ sở dữ liệu và lấy thông tin người dùng
            string connectionString = "Data Source=TRIPLETANDV;Initial Catalog=QuanLyBanHang;Integrated Security=True";
            UserInfo userInfo = null;

            string query = @"SELECT KH.TenKH, KH.Email, KH.SDT, KH.DiaChi 
                             FROM KhachHang KH
                             INNER JOIN TaiKhoan TK ON KH.MaKH = TK.MaKH
                             WHERE TK.TenDN = @Username";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Username", username);
                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            userInfo = new UserInfo
                            {
                                Username = username,
                                FullName = reader["TenKH"] != DBNull.Value ? reader["TenKH"].ToString() : string.Empty,
                                Email = reader["Email"] != DBNull.Value ? reader["Email"].ToString() : string.Empty,
                                PhoneNumber = reader["SDT"] != DBNull.Value ? reader["SDT"].ToString() : string.Empty,
                                Address = reader["DiaChi"] != DBNull.Value ? reader["DiaChi"].ToString() : string.Empty
                            };
                        }
                    }
                }
            }

            return userInfo;
        }

        private class UserInfo
        {
            public string Username { get; set; }
            public string FullName { get; set; }
            public string Email { get; set; }
            public string PhoneNumber { get; set; }
            public string Address { get; set; } // Thêm địa chỉ vào thông tin người dùng
        }
    }
}
