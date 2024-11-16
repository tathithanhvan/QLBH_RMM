using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.UI;

namespace QLBH_RMM.Customer
{
    public partial class ChiTietDonHang : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string orderId = Request.QueryString["MaHD"];
                if (!string.IsNullOrEmpty(orderId))
                {
                    LoadOrderDetails(orderId);
                }
                else
                {
                    Response.Write("<script>alert('Không tìm thấy đơn hàng.'); window.location='TaiKhoan.aspx';</script>");
                }
            }
        }

        private SqlConnection GetDatabaseConnection()
        {
            string connectionString = "Data Source=TRIPLETANDV;Initial Catalog=QuanLyBanHang;Integrated Security=True";
            return new SqlConnection(connectionString);
        }

        private void LoadOrderDetails(string orderId)
        {
            using (var connection = GetDatabaseConnection())
            {
                connection.Open();
                string orderQuery = "SELECT MaHD, TenNN, DiaChiNN, NgayMua, TinhTrang, TriGiaHD, SoTienGiam FROM HoaDon WHERE MaHD = @orderId";

                using (SqlCommand cmd = new SqlCommand(orderQuery, connection))
                {
                    cmd.Parameters.AddWithValue("@orderId", orderId);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblOrderId.Text = reader["MaHD"].ToString();
                            lblRecipientName.Text = reader["TenNN"].ToString();
                            lblShippingAddress.Text = reader["DiaChiNN"].ToString();
                            lblOrderDate.Text = Convert.ToDateTime(reader["NgayMua"]).ToString("dd/MM/yyyy");
                            lblTotalAmount.Text = Convert.ToDecimal(reader["TriGiaHD"]).ToString("N0") + " VNĐ";
                            lblTotalValue.Text = Convert.ToDecimal(reader["TriGiaHD"]).ToString("N0") + " VNĐ";
                            lblOrderStatus.Text = reader["TinhTrang"].ToString();

                            // Get the discount from the database
                            decimal discount = reader["SoTienGiam"] != DBNull.Value ? Convert.ToDecimal(reader["SoTienGiam"]) : 0;
                            lblDiscount.Text = discount.ToString("N0") + " VNĐ"; // Display discount

                            LoadOrderItems(orderId, discount); // Pass discount to LoadOrderItems
                        }
                        else
                        {
                            Response.Write("<script>alert('Không tìm thấy đơn hàng.'); window.location='LichSuGiaoDich.aspx';</script>");
                        }
                    }
                }
            }
        }

        private void LoadOrderItems(string orderId, decimal discount)
        {
            using (var connection = GetDatabaseConnection())
            {
                connection.Open();
                string itemsQuery = @"
                    SELECT 
                        sp.TenSP AS 'Tên sản phẩm',
                        sz.TenSize AS 'Kích Thước',
                        ss.DonGia AS 'Giá',
                        cthd.Soluong AS 'Số Lượng',
                        (SELECT STRING_AGG(tp.TenTopping, ', ') 
                         FROM SanPham_Topping st 
                         JOIN Topping tp ON st.MaTopping = tp.MaTopping 
                         WHERE st.MaCTHD = cthd.MaCTHD) AS 'Topping',  
                        (SELECT STRING_AGG(ghichu.TenGC, ', ') 
                         FROM GhiChu_SanPham gc 
                         JOIN GhiChu ghichu ON gc.MaGC = ghichu.MaGC 
                         WHERE gc.MaCTHD = cthd.MaCTHD) AS 'Ghi chú',  
                        cthd.MaCTHD,
                        (ss.DonGia + 
                            ISNULL((SELECT SUM(tp2.GiaTopping)  
                                    FROM SanPham_Topping st 
                                    JOIN Topping tp2 ON st.MaTopping = tp2.MaTopping
                                    WHERE st.MaCTHD = cthd.MaCTHD), 0)) * cthd.Soluong AS 'TotalPrice'  
                    FROM 
                        HoaDon hd
                    JOIN 
                        CTHD cthd ON hd.MaHD = cthd.MaHD
                    JOIN 
                        SanPham sp ON cthd.MaSP = sp.MaSP
                    JOIN 
                        Size sz ON cthd.MaSize = sz.MaSize
                    JOIN 
                        SanPham_Size ss ON cthd.MaSP = ss.MaSP AND cthd.MaSize = ss.MaSize
                    WHERE 
                        hd.MaHD = @orderId
                    GROUP BY 
                        sp.TenSP, sz.TenSize, ss.DonGia, cthd.Soluong, cthd.MaCTHD";

                using (SqlCommand cmd = new SqlCommand(itemsQuery, connection))
                {
                    cmd.Parameters.AddWithValue("@orderId", orderId);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        List<OrderItem> orderItems = new List<OrderItem>();
                        decimal totalValue = 0;

                        while (reader.Read())
                        {
                            OrderItem item = new OrderItem
                            {
                                TenSP = reader["Tên sản phẩm"].ToString(),
                                TenSize = reader["Kích Thước"].ToString(),
                                DonGia = Convert.ToDecimal(reader["Giá"]),
                                SoLuong = Convert.ToInt32(reader["Số Lượng"]),
                                GhiChu = reader["Ghi chú"] != DBNull.Value ? reader["Ghi chú"].ToString() : "",
                                Topping = reader["Topping"] != DBNull.Value ? reader["Topping"].ToString() : "",
                                TotalPrice = Convert.ToDecimal(reader["TotalPrice"])
                            };
                            totalValue += item.TotalPrice;
                            orderItems.Add(item);
                        }

                        gvOrderItems.DataSource = orderItems;
                        gvOrderItems.DataBind();

                        // Calculate final total after discount
                        decimal finalTotal = totalValue - discount;
                        lblFinalTotal.Text = finalTotal < 0 ? "0 VNĐ" : finalTotal.ToString("N0") + " VNĐ";
                    }
                }
            }
        }

        public class OrderItem
        {
            public string TenSP { get; set; }
            public string TenSize { get; set; }
            public decimal DonGia { get; set; }
            public int SoLuong { get; set; }
            public string GhiChu { get; set; }
            public string Topping { get; set; }
            public decimal TotalPrice { get; set; }
        }
    }
}
