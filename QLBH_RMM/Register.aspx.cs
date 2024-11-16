using System;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace QLBH_RMM
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void CreateUserWizard1_CreatedUser(object sender, EventArgs e)
        {
            // Lấy thông tin từ CreateUserWizard
            string userName = ((TextBox)CreateUserWizard1.CreateUserStep.ContentTemplateContainer.FindControl("UserName")).Text;
            string email = ((TextBox)CreateUserWizard1.CreateUserStep.ContentTemplateContainer.FindControl("Email")).Text;

            // Kết nối đến cơ sở dữ liệu
            string connectionString = "Data Source=TRIPLETANDV;Initial Catalog=QuanLyBanHang;Integrated Security=True"; // Thay thế bằng chuỗi kết nối của bạn
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                // Thêm khách hàng vào bảng KhachHang
                string insertKhachHangQuery = "INSERT INTO KhachHang (TenKH, Email, DiaChi, GioiTinh, NgaySinh, SDT, NgayTao) OUTPUT INSERTED.MaKH " +
                                                  "VALUES (@TenKH, @Email, '', '', NULL, '', GETDATE())"; // Sử dụng GETDATE() để lấy ngày hiện tại

                using (SqlCommand command = new SqlCommand(insertKhachHangQuery, connection))
                {
                    command.Parameters.AddWithValue("@TenKH", userName);
                    command.Parameters.AddWithValue("@Email", email);
                    command.ExecuteNonQuery();
                }

                string selectKhachHangIdQuery = "SELECT TOP 1 MaKH FROM KhachHang ORDER BY MaKH DESC";
                int khachHangId;
                using (SqlCommand command = new SqlCommand(selectKhachHangIdQuery, connection))
                {
                    khachHangId = (int)command.ExecuteScalar();
                }

                // Thêm tài khoản vào bảng TaiKhoan
                string insertTaiKhoanQuery = "INSERT INTO TaiKhoan (TenDN, MaKH, Muc) VALUES (@TenDN, @MaKH, @Muc)";
                using (SqlCommand command = new SqlCommand(insertTaiKhoanQuery, connection))
                {
                    command.Parameters.AddWithValue("@TenDN", userName);
                    command.Parameters.AddWithValue("@MaKH", khachHangId);
                    command.Parameters.AddWithValue("@Muc", "KhachHang"); // Mức mặc định
                    command.ExecuteNonQuery();
                }
            }
        }
    }
}
