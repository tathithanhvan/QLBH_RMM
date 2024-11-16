using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace QLBH_RMM
{
    public partial class XacNhanDatHang : System.Web.UI.Page
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
                    Response.Write("<script>alert('Không tìm thấy đơn hàng.'); window.location='TrangChu.aspx';</script>");
                }
            }
        }

        private SqlConnection GetDatabaseConnection()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["QuanLyBanHang_SP_ConnectionString"].ConnectionString;
            return new SqlConnection(connectionString);
        }
        private void LoadOrderDetails(string orderId)
        {
            using (var connection = GetDatabaseConnection())
            {
                connection.Open();
                string orderQuery = "SELECT MaKH, TenNN, SDTNN, DiaChiNN, NgayMua, TinhTrang, TriGiaHD, HinhThucThanhToan, SoTienGiam FROM HoaDon WHERE MaHD = @orderId";

                using (SqlCommand cmd = new SqlCommand(orderQuery, connection))
                {
                    cmd.Parameters.AddWithValue("@orderId", orderId);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblRecipientName.Text = reader["TenNN"].ToString();
                            lblRecipientPhone.Text = reader["SDTNN"].ToString();
                            lblRecipientAddress.Text = reader["DiaChiNN"].ToString();
                            lblPaymentMethod.Text = GetPaymentMethodText(reader["HinhThucThanhToan"].ToString());

                            decimal totalPrice = Convert.ToDecimal(reader["TriGiaHD"]);
                            lblTotal.Text = totalPrice.ToString("N0") + " VNĐ";

                            // Retrieve and display the discount
                            decimal discount = Convert.ToDecimal(reader["SoTienGiam"]);
                            lblDiscount.Text = discount.ToString("N0") + " VNĐ";

                            // Calculate final amount
                            decimal finalAmount = CalculateFinalAmount(totalPrice, discount);
                            lblGrandTotal.Text = totalPrice.ToString("N0") + " VNĐ"; // Total Price
                            lblFinalTotal.Text = finalAmount.ToString("N0") + " VNĐ"; // Final Amount

                            LoadOrderItems(orderId);
                        }
                        else
                        {
                            Response.Write("<script>alert('Không tìm thấy đơn hàng.'); window.location='Default.aspx';</script>");
                        }
                    }
                }
            }
        }

        //private void LoadOrderDetails(string orderId)
        //{
        //    using (var connection = GetDatabaseConnection())
        //    {
        //        connection.Open();
        //        string orderQuery = "SELECT MaKH, TenNN, SDTNN, DiaChiNN, NgayMua, TinhTrang, TriGiaHD, HinhThucThanhToan, MaKM FROM HoaDon WHERE MaHD = @orderId";

        //        using (SqlCommand cmd = new SqlCommand(orderQuery, connection))
        //        {
        //            cmd.Parameters.AddWithValue("@orderId", orderId);
        //            using (SqlDataReader reader = cmd.ExecuteReader())
        //            {
        //                if (reader.Read())
        //                {
        //                    lblRecipientName.Text = reader["TenNN"].ToString();
        //                    lblRecipientPhone.Text = reader["SDTNN"].ToString();
        //                    lblRecipientAddress.Text = reader["DiaChiNN"].ToString();
        //                    lblPaymentMethod.Text = GetPaymentMethodText(reader["HinhThucThanhToan"].ToString());

        //                    decimal totalPrice = Convert.ToDecimal(reader["TriGiaHD"]);
        //                    lblTotal.Text = totalPrice.ToString("N0") + " VNĐ";

        //                    // Retrieve and display the discount
        //                    decimal discount = GetDiscount(orderId);
        //                    lblDiscount.Text = discount.ToString("N0") + " VNĐ";

        //                    // Calculate final amount
        //                    decimal finalAmount = CalculateFinalAmount(totalPrice, discount);
        //                    lblGrandTotal.Text = totalPrice.ToString("N0") + " VNĐ"; // Total Price
        //                    lblFinalTotal.Text = finalAmount.ToString("N0") + " VNĐ"; // Final Amount

        //                    LoadOrderItems(orderId);
        //                }
        //                else
        //                {
        //                    Response.Write("<script>alert('Không tìm thấy đơn hàng.'); window.location='Default.aspx';</script>");
        //                }
        //            }
        //        }
        //    }
        //}

        private decimal GetDiscount(string orderId)
        {
            decimal discount = 0;

            using (var connection = GetDatabaseConnection())
            {
                connection.Open();
                string query = @"
                                SELECT ISNULL(SUM(GiamGia), 0) 
                                FROM CTKM ctkm 
                                JOIN HoaDon hd ON hd.MaKM = ctkm.MaKM 
                                WHERE hd.MaHD = @orderId";

                using (SqlCommand cmd = new SqlCommand(query, connection))
                {
                    cmd.Parameters.AddWithValue("@orderId", orderId);
                    discount = Convert.ToDecimal(cmd.ExecuteScalar());
                }
            }

            return discount;
        }

        private decimal CalculateFinalAmount(decimal totalPrice, decimal discount)
        {
            return Math.Max(totalPrice - discount, 0);
        }

        private string GetPaymentMethodText(string paymentMethod)
        {
            switch (paymentMethod)
            {
                case "COD":
                    return "Thanh toán khi nhận hàng";
                case "BankTransfer":
                    return "Chuyển khoản ngân hàng";
                default:
                    return "Không xác định";
            }
        }

        private void LoadOrderItems(string orderId)
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
                                     WHERE st.MaCTHD = cthd.MaCTHD
                                     GROUP BY st.MaCTHD) AS 'Topping',  
                                    (SELECT STRING_AGG(ghichu.TenGC, ', ') 
                                     FROM GhiChu_SanPham gc 
                                     JOIN GhiChu ghichu ON gc.MaGC = ghichu.MaGC 
                                     WHERE gc.MaCTHD = cthd.MaCTHD
                                     GROUP BY gc.MaCTHD) AS 'Ghi chú',  
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
                            orderItems.Add(item);
                        }
                        OrderDetailsGridView.DataSource = orderItems;
                        OrderDetailsGridView.DataBind();
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
