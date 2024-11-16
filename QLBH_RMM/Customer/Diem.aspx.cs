using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace QLBH_RMM.Customer
{
    public partial class Diem : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string customerId = GetLoggedInCustomerId();
                if (!string.IsNullOrEmpty(customerId))
                {
                    LoadCustomerPoints(customerId);
                    LoadPointsHistory(customerId);
                }
                else
                {
                    Response.Write("<script>alert('Vui lòng đăng nhập để xem điểm thưởng.'); window.location='Login.aspx';</script>");
                }
            }
        }

        private string GetLoggedInCustomerId()
        {
            return Session["CustomerId"]?.ToString();
        }

        private SqlConnection GetDatabaseConnection()
        {
            string connectionString = "Data Source=TRIPLETANDV;Initial Catalog=QuanLyBanHang;Integrated Security=True";
            return new SqlConnection(connectionString);
        }

        private void LoadCustomerPoints(string customerId)
        {
            using (var connection = GetDatabaseConnection())
            {
                connection.Open();
                string query = "SELECT SoDiem, DiemDaSuDung FROM KhachHang WHERE MaKH = @customerId";
                using (SqlCommand cmd = new SqlCommand(query, connection))
                {
                    cmd.Parameters.AddWithValue("@customerId", customerId);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            int currentPoints = Convert.ToInt32(reader["SoDiem"]);
                            int usedPoints = Convert.ToInt32(reader["DiemDaSuDung"]);
                            int availablePoints = currentPoints - usedPoints;

                            lblSoDiem.Text = currentPoints.ToString();
                            lblDiemDaSuDung.Text = usedPoints.ToString();
                            lblDiemKhaDung.Text = availablePoints.ToString();

                            SetCurrentRank(currentPoints);
                        }
                    }
                }
            }
        }

        private void SetCurrentRank(int currentPoints)
        {
            string currentRank = "";
            int pointsNeededForNextRank = 0;

            if (currentPoints < 500)
            {
                currentRank = "Hạt mầm";
                pointsNeededForNextRank = 500 - currentPoints;
            }
            else if (currentPoints < 1000)
            {
                currentRank = "Chồi non";
                pointsNeededForNextRank = 1000 - currentPoints;
            }
            else if (currentPoints < 2500)
            {
                currentRank = "Lá nhỏ";
                pointsNeededForNextRank = 2500 - currentPoints;
            }
            else if (currentPoints < 5000)
            {
                currentRank = "Lá xanh";
                pointsNeededForNextRank = 5000 - currentPoints;
            }
            else
            {
                currentRank = "Siêu rau má";
                pointsNeededForNextRank = 0; // Already at the highest rank
            }

            lblCurrentRank.Text = currentRank;
            lblMinPoints.Text = pointsNeededForNextRank.ToString(); // Update points needed for next rank
        }

        private void LoadPointsHistory(string customerId)
        {
            using (var connection = GetDatabaseConnection())
            {
                connection.Open();
                string query = "SELECT NgayKiemDuoc, DiemKiemDuoc, MaHD FROM DiemTichLuy WHERE MaKH = @customerId ORDER BY NgayKiemDuoc DESC";
                using (SqlCommand cmd = new SqlCommand(query, connection))
                {
                    cmd.Parameters.AddWithValue("@customerId", customerId);
                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);
                        rptHistory.DataSource = dt;
                        rptHistory.DataBind();
                    }
                }
            }
        }
    }
}
