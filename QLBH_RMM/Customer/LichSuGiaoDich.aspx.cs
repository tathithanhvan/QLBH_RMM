using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.UI;

namespace QLBH_RMM.Customer
{
    public partial class LichSuGiaoDich : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string customerId = GetLoggedInCustomerId();
                if (!string.IsNullOrEmpty(customerId))
                {
                    LoadTransactionHistory(customerId);
                }
                else
                {
                    Response.Write("<script>alert('Vui lòng đăng nhập để xem lịch sử giao dịch.'); window.location='Login.aspx';</script>");
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

        private void LoadTransactionHistory(string customerId)
        {
            using (var connection = GetDatabaseConnection())
            {
                connection.Open();
                string query = @"
                    SELECT MaHD, NgayMua, TinhTrang 
                    FROM HoaDon 
                    WHERE MaKH = @customerId 
                    ORDER BY NgayMua DESC";

                using (SqlCommand cmd = new SqlCommand(query, connection))
                {
                    cmd.Parameters.AddWithValue("@customerId", customerId);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        List<Transaction> transactions = new List<Transaction>();
                        while (reader.Read())
                        {
                            Transaction transaction = new Transaction
                            {
                                MaHD = reader["MaHD"].ToString(),
                                NgayMua = Convert.ToDateTime(reader["NgayMua"]).ToString("dd/MM/yyyy"),
                                TinhTrang = reader["TinhTrang"].ToString()
                            };
                            transactions.Add(transaction);
                        }

                        BindTransactionHistory(transactions);
                    }
                }
            }
        }

        private void BindTransactionHistory(List<Transaction> transactions)
        {
            if (transactions.Count == 0)
            {
                transactionList.InnerHtml = "<li>Không có giao dịch nào.</li>";
                return;
            }

            foreach (var transaction in transactions)
            {
                string listItem = $"<li><strong>Giao dịch #{transaction.MaHD}:</strong> {transaction.TinhTrang} ({transaction.NgayMua}) " +
                                  $"<a href='ChiTietDonHang.aspx?MaHD={transaction.MaHD}'>Xem chi tiết</a></li>";
                transactionList.InnerHtml += listItem;
            }
        }

        public class Transaction
        {
            public string MaHD { get; set; }
            public string NgayMua { get; set; }
            public string TinhTrang { get; set; }
        }
    }
}
