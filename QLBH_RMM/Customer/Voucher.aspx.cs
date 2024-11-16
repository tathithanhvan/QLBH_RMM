using System;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QLBH_RMM.Customer
{
    public partial class Vouchers : Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadPromotions();
            }
        }
        private void LoadPromotions()
        {
            if (Session["CustomerId"] != null)
            {
                int customerId = Convert.ToInt32(Session["CustomerId"]);
                int membershipTier = LayHangThanhVien(customerId); // Lấy hạng thành viên của người dùng

                using (SqlConnection connection = GetDatabaseConnection())
                {
                    // Câu truy vấn để lấy các khuyến mãi có MaHang khớp với người dùng hoặc MaHang là NULL
                    string query = @"
                                    SELECT TenKM, 
                                           CONVERT(varchar(10), NgayBatDau, 103) AS NgayBatDau, 
                                           CONVERT(varchar(10), NgayKetThuc, 103) AS NgayKetThuc, 
                                           GiaTriDonHangToiThieu, 
                                           MoTa, 
                                           SoLuongToiDa, 
                                           SoLuongDaSuDung, 
                                           MaKM,
                                           (SoLuongToiDa - SoLuongDaSuDung) AS SoLuongConLai
                                    FROM KhuyenMai
                                    WHERE (MaHang = @membershipTier OR MaHang IS NULL)
                                    AND NgayBatDau <= GETDATE() 
                                    AND NgayKetThuc >= GETDATE() 
                                    AND SoLuongDaSuDung < SoLuongToiDa
                                    AND TrangThai = N'Hoạt động'";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@membershipTier", membershipTier);

                        SqlDataReader reader = command.ExecuteReader();

                        if (reader.HasRows)
                        {
                            rptVouchers.DataSource = reader;
                            rptVouchers.DataBind();
                        }
                        else
                        {
                            // Nếu không có khuyến mãi, bạn có thể thêm thông báo
                            Label lblNoPromotions = new Label
                            {
                                Text = "Không có khuyến mãi nào.",
                                CssClass = "voucher-info" // Thêm CSS cho thông báo
                            };
                            // Thêm vào Content Placeholder
                        }
                    }
                }
            }
        }

        private int LayHangThanhVien(int customerId)
        {
            int hang = 0;

            using (SqlConnection connection = GetDatabaseConnection())
            {
                string query = @"
            SELECT MaHang
            FROM KhachHang
            WHERE MaKH = @customerId";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@customerId", customerId);

                    SqlDataReader reader = command.ExecuteReader();

                    if (reader.Read())
                    {
                        // Giả sử cột MaHang lưu hạng thành viên
                        hang = Convert.ToInt32(reader["MaHang"]);
                    }
                    else
                    {
                        // Nếu không tìm thấy thông tin khách hàng, có thể trả về giá trị mặc định
                        hang = 1; // Giả sử hạng 1 là hạng mặc định
                    }
                }
            }

            return hang;
        }

        private SqlConnection GetDatabaseConnection()
        {
            string connectionString = "Data Source=TRIPLETANDV;Initial Catalog=QuanLyBanHang;Integrated Security=True";
            SqlConnection connection = new SqlConnection(connectionString);
            connection.Open();
            return connection;
        }
    }
}
