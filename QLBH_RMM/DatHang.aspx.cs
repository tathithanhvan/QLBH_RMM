using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;

namespace QLBH_RMM
{
    public partial class DatHang : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["CustomerId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                if (Session["TotalAmount"] != null)
                {
                    decimal totalAmount = (decimal)Session["TotalAmount"];
                    TotalLabel.Text = totalAmount.ToString("N0") + " VNĐ";
                }
                else
                {
                    TotalLabel.Text = "0 VNĐ";
                }

                LoadOrderItems();
            }
        }

        private SqlConnection GetDatabaseConnection()
        {
            string connectionString = "Data Source=TRIPLETANDV;Initial Catalog=QuanLyBanHang;Integrated Security=True";
            var connection = new SqlConnection(connectionString);
            connection.Open();
            return connection;
        }

        private decimal TongDonHang(List<CartItem> cartItems)
        {
            decimal total = 0;

            using (var connection = GetDatabaseConnection())
            {
                foreach (var item in cartItems)
                {
                    string query = @"
                            SELECT ss.DonGia 
                            FROM SanPham sp
                            JOIN SanPham_Size ss ON sp.MaSP = ss.MaSP
                            JOIN Size s ON s.MaSize = ss.MaSize
                            WHERE sp.MaSP = @productId AND ss.MaSize = @sizeId";

                    using (SqlCommand cmd = new SqlCommand(query, connection))
                    {
                        cmd.Parameters.AddWithValue("@productId", item.MaSP);
                        cmd.Parameters.AddWithValue("@sizeId", item.MaSize);
                        var result = cmd.ExecuteScalar();

                        if (result != null)
                        {
                            decimal donGia = Convert.ToDecimal(result);
                            decimal toppingCost = 0;

                            // Count toppings and get their prices
                            if (!string.IsNullOrWhiteSpace(item.MaTopping))
                            {
                                string[] toppingCodes = item.MaTopping.Split(',');
                                foreach (var code in toppingCodes)
                                {
                                    string toppingQuery = "SELECT giatopping FROM Topping WHERE MaTopping = @toppingCode";
                                    using (SqlCommand toppingCmd = new SqlCommand(toppingQuery, connection))
                                    {
                                        toppingCmd.Parameters.AddWithValue("@toppingCode", code.Trim());
                                        var toppingResult = toppingCmd.ExecuteScalar();
                                        if (toppingResult != null)
                                        {
                                            toppingCost += Convert.ToDecimal(toppingResult);
                                        }
                                    }
                                }
                            }
                            total += (donGia + toppingCost) * item.SoLuong;
                        }
                    }
                }
            }
            return total;
        }

        protected void Checkout_Click(object sender, EventArgs e)
        {
            if (Session["CustomerId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            string customerId = Session["CustomerId"].ToString();
            string recipientName = txtCustomerName.Text.Trim();
            string recipientPhone = txtPhone.Text.Trim();
            string recipientAddress = txtAddress.Text.Trim();
            string paymentMethod = ddlPaymentMethod.SelectedValue;

            // Validate recipient information
            if (string.IsNullOrEmpty(recipientName))
            {
                Response.Write("<script>alert('Vui lòng nhập tên người nhận.');</script>");
                return;
            }

            if (string.IsNullOrEmpty(recipientPhone))
            {
                Response.Write("<script>alert('Vui lòng nhập số điện thoại người nhận.');</script>");
                return;
            }

            if (string.IsNullOrEmpty(recipientAddress))
            {
                Response.Write("<script>alert('Vui lòng nhập địa chỉ người nhận.');</script>");
                return;
            }

            if (string.IsNullOrEmpty(paymentMethod))
            {
                Response.Write("<script>alert('Vui lòng chọn hình thức thanh toán.');</script>");
                return;
            }

            List<CartItem> cart = (List<CartItem>)Session["Cart"];
            if (cart != null && cart.Count > 0)
            {
                decimal totalAmount = TongDonHang(cart);
                decimal discountAmount = 0;

                // Calculate discount based on promo code
                if (Session["PromoCode"] != null)
                {
                    string promoCode = Session["PromoCode"].ToString();
                    discountAmount = GetDiscountAmountByPromoCode(promoCode, totalAmount);
                    UpdatePromoUsage(promoCode);
                }

                string orderId = SaveOrder(customerId, recipientName, recipientPhone, recipientAddress, paymentMethod, cart, discountAmount);

                if (string.IsNullOrEmpty(orderId))
                {
                    Response.Write("<script>alert('Lỗi khi lưu đơn hàng.');</script>");
                    return;
                }
                Session["Cart"] = null; // Clear the cart
                Response.Redirect("XacNhanDatHang.aspx?MaHD=" + orderId);
            }
            else
            {
                Response.Write("<script>alert('Giỏ hàng của bạn đang trống.');</script>");
            }
        }

        private decimal GetDiscountAmountByPromoCode(string promoCode, decimal orderValue)
        {
            decimal discountAmount = 0;

            using (var connection = GetDatabaseConnection())
            {
                string query = @"
                        SELECT K.GiamGia, K.KieuGiamGia 
                        FROM KhuyenMai K
                        WHERE K.MaKM = @promoCode 
                        AND GETDATE() BETWEEN K.NgayBatDau AND K.NgayKetThuc
                        AND K.GiaTriDonHangToiThieu <= @orderValue";

                using (SqlCommand cmd = new SqlCommand(query, connection))
                {
                    cmd.Parameters.AddWithValue("@promoCode", promoCode);
                    cmd.Parameters.AddWithValue("@orderValue", orderValue);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            decimal discountValue = Convert.ToDecimal(reader["GiamGia"]);
                            string discountType = reader["KieuGiamGia"].ToString();

                            if (discountType == "PT") // Percentage discount
                            {
                                discountAmount = (orderValue * (discountValue / 100));
                            }
                            else if (discountType == "TN") // Fixed amount discount
                            {
                                discountAmount = discountValue;
                            }
                        }
                    }
                }
            }

            return discountAmount;
        }

        private void LoadOrderItems()
        {
            List<CartItem> cart = (List<CartItem>)Session["Cart"];

            if (cart != null && cart.Count > 0)
            {
                OrderListView.DataSource = cart;
                OrderListView.DataBind();

                decimal grandTotal = TongDonHang(cart);
                TotalLabel.Text = grandTotal.ToString("N0") + " VNĐ";
            }
            else
            {
                TotalLabel.Text = "Giỏ hàng trống";
            }
        }

        private string SaveOrder(string customerId, string recipientName, string recipientPhone, string recipientAddress, string paymentMethod, List<CartItem> cartItems, decimal discountAmount)
        {
            using (var connection = GetDatabaseConnection())
            {
                string orderId = InsertOrder(connection, customerId, recipientName, recipientPhone, recipientAddress, paymentMethod, cartItems, discountAmount);

                // Calculate points earned
                decimal totalAmount = TongDonHang(cartItems);
                int pointsEarned = (int)(totalAmount / 1000); // 1000 VNĐ = 1 điểm

                // Update customer points
                UpdateCustomerPoints(connection, customerId, pointsEarned);
                SavePointsToDiemTichLuy(connection, customerId, pointsEarned, orderId);
                if (Session["PromoCode"] != null)
                {
                    string promoCode = Session["PromoCode"].ToString();
                    decimal discount = GetDiscountByPromoCode(promoCode, totalAmount);
                }

                foreach (var item in cartItems)
                {
                    string maCTHD = InsertOrderDetails(connection, orderId, item);

                    if (!string.IsNullOrEmpty(item.MaTopping))
                    {
                        InsertIntoSanPhamTopping(connection, item.MaSP, item.MaTopping, maCTHD);
                    }

                    if (!string.IsNullOrWhiteSpace(item.MaGC))
                    {
                        InsertIntoGhiChuSanPham(connection, item.MaSP, item.MaGC, maCTHD);
                    }
                }

                return orderId;
            }
        }

        private void SavePointsToDiemTichLuy(SqlConnection connection, string customerId, int pointsEarned, string orderId)
        {
            string query = @"
        INSERT INTO DiemTichLuy (MaKH, DiemKiemDuoc, NgayKiemDuoc, MaHD) 
        VALUES (@customerId, @pointsEarned, @date, @orderId)";

            using (SqlCommand cmd = new SqlCommand(query, connection))
            {
                cmd.Parameters.AddWithValue("@customerId", customerId);
                cmd.Parameters.AddWithValue("@pointsEarned", pointsEarned);
                cmd.Parameters.AddWithValue("@date", DateTime.Now);
                cmd.Parameters.AddWithValue("@orderId", orderId);
                cmd.ExecuteNonQuery();
            }
        }
        private void UpdateCustomerPoints(SqlConnection connection, string customerId, int pointsEarned)
        {
            string query = @"
                            UPDATE KhachHang 
                            SET SoDiem = SoDiem + @pointsEarned 
                            WHERE MaKH = @customerId";

            using (SqlCommand cmd = new SqlCommand(query, connection))
            {
                cmd.Parameters.AddWithValue("@pointsEarned", pointsEarned);
                cmd.Parameters.AddWithValue("@customerId", customerId);
                cmd.ExecuteNonQuery();
            }
        }

        private void UpdatePromoUsage(string promoCode)
        {
            using (var connection = GetDatabaseConnection())
            {
                string query = "UPDATE KhuyenMai SET SoLuongDaSuDung = SoLuongDaSuDung + 1 WHERE MaKM = @promoCode";
                using (SqlCommand cmd = new SqlCommand(query, connection))
                {
                    cmd.Parameters.AddWithValue("@promoCode", promoCode);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private decimal GetDiscountByPromoCode(string promoCode, decimal orderValue)
        {
            decimal discount = 0;

            using (var connection = GetDatabaseConnection())
            {
                string query = @"
                                SELECT K.GiamGia 
                                FROM KhuyenMai K
                                WHERE K.MaKM = @promoCode 
                                AND GETDATE() BETWEEN K.NgayBatDau AND K.NgayKetThuc
                                AND K.GiaTriDonHangToiThieu <= @orderValue";

                using (SqlCommand cmd = new SqlCommand(query, connection))
                {
                    cmd.Parameters.AddWithValue("@promoCode", promoCode);
                    cmd.Parameters.AddWithValue("@orderValue", orderValue);

                    var result = cmd.ExecuteScalar();
                    if (result != null)
                    {
                        discount = Convert.ToDecimal(result);
                    }
                }
            }

            return discount;
        }

        private string InsertOrderDetails(SqlConnection connection, string orderId, CartItem item)
        {
            string maCTHD = null;
            string query = @"
                            INSERT INTO CTHD (MaHD, MaSP, SoLuong, MaSize) 
                            OUTPUT INSERTED.MaCTHD
                            VALUES (@orderId, @productId, @quantity, @sizeId)";

            using (SqlCommand cmd = new SqlCommand(query, connection))
            {
                cmd.Parameters.AddWithValue("@orderId", orderId);
                cmd.Parameters.AddWithValue("@productId", item.MaSP);
                cmd.Parameters.AddWithValue("@quantity", item.SoLuong);
                cmd.Parameters.AddWithValue("@sizeId", item.MaSize);

                try
                {
                    maCTHD = cmd.ExecuteScalar()?.ToString(); // Retrieve MaCTHD
                }
                catch (Exception ex)
                {
                    LogError(ex, orderId, item.MaSP, item.SoLuong.ToString(), item.GhiChu, "");
                    Response.Write("<script>alert('Lỗi khi lưu chi tiết đơn hàng: " + ex.Message + "');</script>");
                }
            }

            return maCTHD;
        }

        private void InsertIntoSanPhamTopping(SqlConnection connection, string maSP, string maTopping, string maCTHD)
        {
            if (!string.IsNullOrEmpty(maTopping))
            {
                string[] toppingCodes = maTopping.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

                foreach (var toppingCode in toppingCodes)
                {
                    string trimmedToppingCode = toppingCode.Trim();

                    // Check if the record already exists
                    string checkQuery = "SELECT COUNT(*) FROM SanPham_Topping WHERE MaSP = @maSP AND MaTopping = @maTopping AND MaCTHD = @maCTHD";
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, connection))
                    {
                        checkCmd.Parameters.AddWithValue("@maSP", maSP);
                        checkCmd.Parameters.AddWithValue("@maTopping", trimmedToppingCode);
                        checkCmd.Parameters.AddWithValue("@maCTHD", maCTHD);

                        int count = (int)checkCmd.ExecuteScalar();
                        if (count == 0)
                        {
                            string insertQuery = "INSERT INTO SanPham_Topping (MaSP, MaTopping, MaCTHD) VALUES (@maSP, @maTopping, @maCTHD)";
                            using (SqlCommand insertCmd = new SqlCommand(insertQuery, connection))
                            {
                                insertCmd.Parameters.AddWithValue("@maSP", maSP);
                                insertCmd.Parameters.AddWithValue("@maTopping", trimmedToppingCode);
                                insertCmd.Parameters.AddWithValue("@maCTHD", maCTHD);
                                insertCmd.ExecuteNonQuery();
                            }
                        }
                    }
                }
            }
        }

        private void InsertIntoGhiChuSanPham(SqlConnection connection, string maSP, string ghiChu, string maCTHD)
        {
            if (!string.IsNullOrEmpty(ghiChu))
            {
                string[] noteCodes = ghiChu.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

                foreach (var noteCode in noteCodes)
                {
                    string trimmedNoteCode = noteCode.Trim();

                    // Check if the record already exists
                    string checkQuery = "SELECT COUNT(*) FROM GhiChu_SanPham WHERE MaSP = @maSP AND MaGC = @maGC AND MaCTHD = @maCTHD";
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, connection))
                    {
                        checkCmd.Parameters.AddWithValue("@maSP", maSP);
                        checkCmd.Parameters.AddWithValue("@maGC", trimmedNoteCode);
                        checkCmd.Parameters.AddWithValue("@maCTHD", maCTHD);

                        int count = (int)checkCmd.ExecuteScalar();
                        if (count == 0)
                        {
                            string insertQuery = "INSERT INTO GhiChu_SanPham (MaGC, MaSP, MaCTHD) VALUES (@maGC, @maSP, @maCTHD)";
                            using (SqlCommand insertCmd = new SqlCommand(insertQuery, connection))
                            {
                                insertCmd.Parameters.AddWithValue("@maGC", trimmedNoteCode);
                                insertCmd.Parameters.AddWithValue("@maSP", maSP);
                                insertCmd.Parameters.AddWithValue("@maCTHD", maCTHD);
                                insertCmd.ExecuteNonQuery();
                            }
                        }
                    }
                }
            }
        }

        private string InsertOrder(SqlConnection connection, string customerId, string recipientName, string recipientPhone, string recipientAddress, string paymentMethod, List<CartItem> cartItems, decimal discountAmount)
        {
            string orderId = null;
            string query = @"
    INSERT INTO HoaDon (MaKH, TenNN, SDTNN, DiaChiNN, NgayMua, TriGiaHD, HinhThucThanhToan, SoTienGiam) 
    OUTPUT INSERTED.MaHD 
    VALUES (@customerId, @recipientName, @recipientPhone, @recipientAddress, @date, @total, @paymentMethod, @discountAmount)";

            using (SqlCommand cmd = new SqlCommand(query, connection))
            {
                cmd.Parameters.AddWithValue("@customerId", customerId);
                cmd.Parameters.AddWithValue("@recipientName", recipientName);
                cmd.Parameters.AddWithValue("@recipientPhone", recipientPhone);
                cmd.Parameters.AddWithValue("@recipientAddress", recipientAddress);
                cmd.Parameters.AddWithValue("@date", DateTime.Now);
                cmd.Parameters.AddWithValue("@total", TongDonHang(cartItems));
                cmd.Parameters.AddWithValue("@paymentMethod", paymentMethod);
                cmd.Parameters.AddWithValue("@discountAmount", discountAmount);

                try
                {
                    orderId = cmd.ExecuteScalar()?.ToString();
                }
                catch (SqlException ex)
                {
                    LogError(ex, customerId, recipientName, recipientPhone, recipientAddress, paymentMethod);
                    Response.Write("<script>alert('Lỗi khi tạo đơn hàng: " + ex.Message + "');</script>");
                }
                catch (Exception ex)
                {
                    LogError(ex, customerId, recipientName, recipientPhone, recipientAddress, paymentMethod);
                    Response.Write("<script>alert('Lỗi không xác định: " + ex.Message + "');</script>");
                }
            }
            return orderId;
        }

        private void LogError(Exception ex, string customerId, string recipientName, string recipientPhone, string recipientAddress, string paymentMethod)
        {
            string errorMessage = $"Lỗi: {ex.Message} \nTham số:\n" +
                                  $"MaKH: {customerId}\n" +
                                  $"TenNN: {recipientName}\n" +
                                  $"SDTNN: {recipientPhone}\n" +
                                  $"DiaChiNN: {recipientAddress}\n" +
                                  $"HinhThucThanhToan: {paymentMethod}";

            System.IO.File.AppendAllText(Server.MapPath("~/App_Data/ErrorLog.txt"), $"{DateTime.Now}: {errorMessage}\n");
        }
        protected void ApplyPromo_Click(object sender, EventArgs e)
        {
            string promoCode = txtPromoCode.Text.Trim();
            decimal discount = 0;
            string discountType = string.Empty;
            bool isBuy2Get1 = false;

            // Get customer ID from session
            string customerId = Session["CustomerId"]?.ToString();

            // Check if the customer exists and get their tier
            string customerTier = GetCustomerTier(customerId);
            if (string.IsNullOrEmpty(customerTier))
            {
                lblPromoMessage.Text = "Không tìm thấy thông tin khách hàng.";
                return;
            }

            using (var connection = GetDatabaseConnection())
            {
                // Modified query to handle NULL tier for promotions
                string query = @"
            SELECT GiamGia, KieuGiamGia, GiaTriDonHangToiThieu 
            FROM KhuyenMai 
            WHERE MaKM = @promoCode 
            AND GETDATE() BETWEEN NgayBatDau AND NgayKetThuc 
            AND (MaHang = @customerTier OR MaHang IS NULL)"; // Check for specific tier or NULL

                using (SqlCommand cmd = new SqlCommand(query, connection))
                {
                    cmd.Parameters.AddWithValue("@promoCode", promoCode);
                    cmd.Parameters.AddWithValue("@customerTier", customerTier);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            discount = Convert.ToDecimal(reader["GiamGia"]);
                            discountType = reader["KieuGiamGia"].ToString();
                            decimal minOrderValue = Convert.ToDecimal(reader["GiaTriDonHangToiThieu"]);

                            List<CartItem> cartItems = (List<CartItem>)Session["Cart"];
                            decimal totalOrderValue = TongDonHang(cartItems);

                            if (totalOrderValue < minOrderValue)
                            {
                                lblPromoMessage.Text = $"Đơn hàng của bạn phải có giá trị tối thiểu {minOrderValue:N0} VNĐ để áp dụng mã khuyến mãi này!";
                                ResetDiscountDisplay();
                                return;
                            }

                            if (discountType == "B2G1")
                            {
                                isBuy2Get1 = true;
                            }
                            else
                            {
                                lblPromoMessage.Text = $"Mã khuyến mãi hợp lệ! Giảm {discount} {(discountType == "PT" ? "%" : "VNĐ")}.";
                            }

                            // Set the promo code in session
                            Session["PromoCode"] = promoCode;
                        }
                        else
                        {
                            lblPromoMessage.Text = "Mã khuyến mãi không hợp lệ hoặc đã hết hạn!";
                            ResetDiscountDisplay();
                            return;
                        }
                    }
                }
            }

            // Update total amount
            UpdateTotalAmount(discount, discountType, isBuy2Get1);
        }

        private void ResetDiscountDisplay()
        {
            TotalLabel.Text = TongDonHang((List<CartItem>)Session["Cart"]).ToString("N0") + " VNĐ";
            lblDiscountAmount.Text = "0 VNĐ"; // Reset discount display
        }

        private void UpdateTotalAmount(decimal discount, string discountType, bool isBuy2Get1)
        {
            List<CartItem> cartItemsForTotal = (List<CartItem>)Session["Cart"];
            if (cartItemsForTotal != null && cartItemsForTotal.Count > 0)
            {
                decimal total = TongDonHang(cartItemsForTotal);
                decimal finalTotal = total;

                // Apply discount
                if (discountType == "PT")
                {
                    finalTotal = total - (total * (discount / 100));
                }
                else if (discountType == "TN")
                {
                    finalTotal -= discount;
                }
                else if (isBuy2Get1)
                {
                    var rauMaItems = cartItemsForTotal.Where(item => item.MaSP.StartsWith("RMM") || item.MaSP.StartsWith("RMSH")).ToList();
                    int rauMaCount = rauMaItems.Count;
                    int freeItems = rauMaCount / 2;

                    if (freeItems > 0)
                    {
                        decimal pricePerItem = rauMaItems.First().DonGia;
                        finalTotal -= freeItems * pricePerItem;
                        lblPromoMessage.Text += $" Bạn đã nhận được {freeItems} sản phẩm rau má miễn phí!";
                    }
                    else
                    {
                        lblPromoMessage.Text += " Bạn cần mua ít nhất 2 sản phẩm rau má để áp dụng khuyến mãi này!";
                        return;
                    }
                }

                // Ensure the total amount is not negative
                finalTotal = finalTotal < 0 ? 0 : finalTotal;

                TotalLabel.Text = finalTotal.ToString("N0") + " VNĐ";
                Session["TotalAmount"] = finalTotal; // Update the session with the new total amount
                lblDiscountAmount.Text = (total - finalTotal).ToString("N0") + " VNĐ"; // Calculate and display the discount amount
            }
        }

        // Lấy mã hạng của khách hàng
        private string GetCustomerTier(string customerId)
        {
            string tier = null;

            using (var connection = GetDatabaseConnection())
            {
                string query = "SELECT MaHang FROM KhachHang WHERE MaKH = @customerId";
                using (SqlCommand cmd = new SqlCommand(query, connection))
                {
                    cmd.Parameters.AddWithValue("@customerId", customerId);
                    var result = cmd.ExecuteScalar();
                    if (result != null)
                    {
                        tier = result.ToString();
                    }
                }
            }

            return tier;
        }
    }
}
