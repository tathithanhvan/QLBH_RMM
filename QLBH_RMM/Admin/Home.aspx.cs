using System;
using System.Data.SqlClient;  // Add namespace for SQL connection
using System.Configuration;   // For accessing connection strings

namespace QLBH_RMM.Admin
{
    public partial class Home : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadStatistics();  // Call method to load statistics
            }
        }
        //Thống kê theo ngày
        //private void LoadStatistics()
        //{
        //    string connectionString = "Data Source=TRIPLETANDV;Initial Catalog=QuanLyBanHang;Integrated Security=True";

        //    using (SqlConnection conn = new SqlConnection(connectionString))
        //    {
        //        conn.Open();

        //        // Query to get statistics for today
        //        string query = @"
        //    SELECT 
        //        (SELECT COUNT(*) FROM HoaDon WHERE CAST(NgayMua AS DATE) = CAST(GETDATE() AS DATE)) AS NewOrders,
        //        (SELECT COUNT(*) FROM SanPham) AS TotalProducts,
        //        (SELECT COUNT(*) FROM KhachHang WHERE NgaySinh >= CAST(GETDATE() - 30 AS DATE)) AS NewUsers,
        //        (SELECT CAST(SUM(CASE WHEN CAST(NgayMua AS DATE) = CAST(GETDATE() AS DATE) THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5, 2)) FROM HoaDon WHERE CAST(NgayMua AS DATE) = CAST(GETDATE() AS DATE)) AS CompletionRate;
        //";

        //        SqlCommand cmd = new SqlCommand(query, conn);

        //        using (SqlDataReader reader = cmd.ExecuteReader())
        //        {
        //            if (reader.Read())
        //            {
        //                lblNewOrders.Text = reader["NewOrders"].ToString();
        //                lblTotalProducts.Text = reader["TotalProducts"].ToString();
        //                lblNewUsers.Text = reader["NewUsers"].ToString();
        //                lblCompletionRate.Text = reader["CompletionRate"].ToString() + "%";
        //            }
        //        }
        //    }
        //}

        //Thống kê theo tháng
        private void LoadStatistics()
        {
            string connectionString = "Data Source=TRIPLETANDV;Initial Catalog=QuanLyBanHang;Integrated Security=True";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                string query = @"
            SELECT 
                (SELECT COUNT(*) FROM HoaDon WHERE CAST(NgayMua AS DATE) = CAST(GETDATE() AS DATE)) AS NewOrders,
                (SELECT COUNT(*) FROM SanPham) AS TotalProducts,
                (SELECT COUNT(*) FROM KhachHang WHERE NgayTao >= CAST(GETDATE() - 30 AS DATE)) AS NewUsers,
                (SELECT CAST(SUM(CASE WHEN CAST(NgayMua AS DATE) = CAST(GETDATE() AS DATE) THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5, 2)) FROM HoaDon WHERE CAST(NgayMua AS DATE) = CAST(GETDATE() AS DATE)) AS CompletionRate;
        ";

                SqlCommand cmd = new SqlCommand(query, conn);

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        // Check for DBNull and assign default values if null
                        int newOrders = reader["NewOrders"] != DBNull.Value ? Convert.ToInt32(reader["NewOrders"]) : 0;
                        int totalProducts = reader["TotalProducts"] != DBNull.Value ? Convert.ToInt32(reader["TotalProducts"]) : 0;
                        int newUsers = reader["NewUsers"] != DBNull.Value ? Convert.ToInt32(reader["NewUsers"]) : 0;
                        decimal completionRate = reader["CompletionRate"] != DBNull.Value ? Convert.ToDecimal(reader["CompletionRate"]) : 0.0m;

                        // Update the labels or pass the values to the front-end using JavaScript
                        ClientScript.RegisterStartupScript(this.GetType(), "startCounter", $@"
                    <script type='text/javascript'>
                        $(document).ready(function() {{
                            startAnimation({newOrders}, {totalProducts}, {newUsers}, {completionRate});
                        }});
                    </script>
                ", false);
                    }
                }
            }
        }
    }
}
