using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QLBH_RMM.Admin
{
    public partial class Promotions : Page
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
            GridView1.DataBind();
        }

        protected void btnSavePromotion_Click(object sender, EventArgs e)
        {
            try
            {
                // Validate input fields
                if (string.IsNullOrWhiteSpace(txtAddMaKM.Text) ||
                    string.IsNullOrWhiteSpace(txtAddTenKM.Text) ||
                    string.IsNullOrWhiteSpace(txtAddNgayBatDau.Text) ||
                    string.IsNullOrWhiteSpace(txtAddNgayKetThuc.Text) ||
                    string.IsNullOrWhiteSpace(txtAddGiamGia.Text) ||
                    string.IsNullOrWhiteSpace(ddlAddKieuGiamGia.SelectedValue) ||
                    string.IsNullOrWhiteSpace(ddlAddTrangThai.SelectedValue) ||
                    string.IsNullOrWhiteSpace(txtAddMaxQuantity.Text) || // Số lượng tối đa
                    string.IsNullOrWhiteSpace(txtAddMinOrderValue.Text)) // Giá trị đơn hàng tối thiểu
                {
                    lblAddMessage.Text = "Vui lòng điền đầy đủ thông tin.";
                    lblAddMessage.ForeColor = System.Drawing.Color.Red;
                    lblAddMessage.Visible = true;
                    return;
                }

                string maKM = txtAddMaKM.Text.Trim();
                string tenKM = txtAddTenKM.Text.Trim();
                DateTime ngayBatDau = DateTime.Parse(txtAddNgayBatDau.Text);
                DateTime ngayKetThuc = DateTime.Parse(txtAddNgayKetThuc.Text);
                float giamGia = float.Parse(txtAddGiamGia.Text);
                string kieuGiamGia = ddlAddKieuGiamGia.SelectedValue.Trim();
                string trangThai = ddlAddTrangThai.SelectedValue.Trim();
                string moTa = txtAddMoTa.Text.Trim();
                string maHang = ddlAddMemberLevel.SelectedValue.Trim(); // Mã hạng
                int soLuongToiDa = int.Parse(txtAddMaxQuantity.Text); // Số lượng tối đa
                float giaTriDonHangToiThieu = float.Parse(txtAddMinOrderValue.Text); // Giá trị đơn hàng tối thiểu

                // Implement your insert logic here
                InsertPromotion(maKM, tenKM, ngayBatDau, ngayKetThuc, giamGia, kieuGiamGia, trangThai, moTa, maHang, soLuongToiDa, giaTriDonHangToiThieu);

                ShowMessage("Khuyến mãi đã được thêm thành công.");
                LoadPromotions(); // Refresh the GridView
            }
            catch (FormatException)
            {
                lblAddMessage.Text = "Định dạng ngày hoặc số không hợp lệ. Vui lòng kiểm tra lại.";
                lblAddMessage.ForeColor = System.Drawing.Color.Red;
                lblAddMessage.Visible = true;
            }
            catch (Exception ex)
            {
                lblAddMessage.Text = "Đã xảy ra lỗi khi thêm khuyến mãi. Vui lòng thử lại.";
                lblAddMessage.ForeColor = System.Drawing.Color.Red;
                lblAddMessage.Visible = true;
                // Log the exception (optional)
                // LogError(ex);
            }
        }

        private void InsertPromotion(string maKM, string tenKM, DateTime ngayBatDau, DateTime ngayKetThuc, float giamGia, string kieuGiamGia, string trangThai, string moTa, string maHang, int soLuongToiDa, float giaTriDonHangToiThieu)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["QuanLyBanHang_SP_ConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "INSERT INTO KhuyenMai (MaKM, TenKM, NgayBatDau, NgayKetThuc, GiamGia, KieuGiamGia, TrangThai, MoTa, NgayTao, NgayCapNhat, MaHang, SoLuongToiDa, GiaTriDonHangToiThieu) " +
                               "VALUES (@maKM, @tenKM, @ngayBatDau, @ngayKetThuc, @giamGia, @kieuGiamGia, @trangThai, @moTa, @ngayTao, @ngayCapNhat, @maHang, @soLuongToiDa, @giaTriDonHangToiThieu)";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@maKM", maKM);
                    cmd.Parameters.AddWithValue("@tenKM", tenKM);
                    cmd.Parameters.AddWithValue("@ngayBatDau", ngayBatDau);
                    cmd.Parameters.AddWithValue("@ngayKetThuc", ngayKetThuc);
                    cmd.Parameters.AddWithValue("@giamGia", giamGia);
                    cmd.Parameters.AddWithValue("@kieuGiamGia", kieuGiamGia);
                    cmd.Parameters.AddWithValue("@trangThai", trangThai);
                    cmd.Parameters.AddWithValue("@moTa", moTa);
                    cmd.Parameters.AddWithValue("@ngayTao", DateTime.Now);
                    cmd.Parameters.AddWithValue("@ngayCapNhat", DateTime.Now);
                    cmd.Parameters.AddWithValue("@maHang", (string.IsNullOrEmpty(maHang) ? (object)DBNull.Value : maHang)); // Handle null case
                    cmd.Parameters.AddWithValue("@soLuongToiDa", soLuongToiDa); // Số lượng tối đa
                    cmd.Parameters.AddWithValue("@giaTriDonHangToiThieu", giaTriDonHangToiThieu); // Giá trị đơn hàng tối thiểu

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }


        protected void btnAddPromotion_Click(object sender, EventArgs e)
        {
            pnlAddPromotion.Visible = true;
            ClearAddPromotionFields(); // Clear fields for new entry
        }

        private void ClearAddPromotionFields()
        {
            txtAddMaKM.Text = "";
            txtAddTenKM.Text = "";
            txtAddNgayBatDau.Text = "";
            txtAddNgayKetThuc.Text = "";
            txtAddGiamGia.Text = "";
            ddlAddKieuGiamGia.SelectedIndex = 0;
            ddlAddTrangThai.SelectedIndex = 0;
            txtAddMoTa.Text = "";
            lblAddMessage.Visible = false;
        }

        protected void btnCancelAdd_Click(object sender, EventArgs e)
        {
            pnlAddPromotion.Visible = false;
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            SqlDataSource1.SelectParameters.Clear();

            string searchQuery = txtSearch.Text.Trim();
            string trangThai = ddlTrangThai.SelectedValue;
            string kieuGiamGia = ddlKieuGiamGia.SelectedValue;
            string ngayBatDau = txtNgayBatDauFilter.Text;
            string ngayKetThuc = txtNgayKetThucFilter.Text;

            // Build your SQL query based on the filters
            string filterQuery = "SELECT * FROM KhuyenMai WHERE 1=1";

            if (!string.IsNullOrEmpty(searchQuery))
            {
                filterQuery += " AND (TenKM LIKE '%' + @searchQuery + '%' OR MaKM LIKE '%' + @searchQuery + '%')";
                SqlDataSource1.SelectParameters.Add("searchQuery", searchQuery);
            }

            if (!string.IsNullOrEmpty(trangThai))
            {
                filterQuery += " AND TrangThai = @trangThai";
                SqlDataSource1.SelectParameters.Add("trangThai", trangThai);
            }

            if (!string.IsNullOrEmpty(ngayBatDau))
            {
                filterQuery += " AND NgayBatDau >= @ngayBatDau";
                SqlDataSource1.SelectParameters.Add("ngayBatDau", ngayBatDau);
            }

            if (!string.IsNullOrEmpty(ngayKetThuc))
            {
                filterQuery += " AND NgayKetThuc <= @ngayKetThuc";
                SqlDataSource1.SelectParameters.Add("ngayKetThuc", ngayKetThuc);
            }

            if (!string.IsNullOrEmpty(kieuGiamGia))
            {
                filterQuery += " AND KieuGiamGia = @kieuGiamGia";
                SqlDataSource1.SelectParameters.Add("kieuGiamGia", kieuGiamGia);
            }

            SqlDataSource1.SelectCommand = filterQuery;

            GridView1.DataBind();
        }
        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditPromotion")
            {
                string maKM = e.CommandArgument.ToString();
                LoadPromotionForEdit(maKM);
                pnlEditPromotion.Visible = true;
                pnlAddPromotion.Visible = false; 
            }
            if (e.CommandName == "DeletePromotion")
            {
                // Lấy mã khuyến mãi từ CommandArgument
                string maKM = e.CommandArgument.ToString();

                // Kiểm tra xem khuyến mãi có đang được sử dụng không
                if (IsPromotionUsed(maKM))
                {
                    // Thông báo không thể xóa
                    ShowMessage("Không thể xóa khuyến mãi đã được sử dụng trong hóa đơn.");
                }
                else
                {
                    // Thực hiện xóa khuyến mãi
                    DeletePromotion(maKM);
                    // Cập nhật lại danh sách khuyến mãi
                    LoadPromotions();
                    ShowMessage("Xóa khuyến mãi thành công.");
                }
            }
        }

        private void LoadPromotionForEdit(string maKM)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["QuanLyBanHang_SP_ConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM KhuyenMai WHERE MaKM = @maKM";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@maKM", maKM);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            txtEditMaKM.Text = reader["MaKM"].ToString();
                            txtEditTenKM.Text = reader["TenKM"].ToString();
                            txtEditNgayBatDau.Text = Convert.ToDateTime(reader["NgayBatDau"]).ToString("yyyy-MM-dd");
                            txtEditNgayKetThuc.Text = Convert.ToDateTime(reader["NgayKetThuc"]).ToString("yyyy-MM-dd");
                            txtEditGiamGia.Text = reader["GiamGia"].ToString();
                            ddlEditKieuGiamGia.SelectedValue = reader["KieuGiamGia"].ToString();
                            ddlEditTrangThai.SelectedValue = reader["TrangThai"].ToString();
                            var maHang = reader["MaHang"] != DBNull.Value ? reader["MaHang"].ToString() : string.Empty;
                            ddlEditMaHang.SelectedValue = maHang;
                            txtEditNgayTao.Text = Convert.ToDateTime(reader["NgayTao"]).ToString("yyyy-MM-dd"); // Assuming "NgayTao" is the correct field
                            txtEditNgayCapNhat.Text = Convert.ToDateTime(reader["NgayCapNhat"]).ToString("yyyy-MM-dd"); // Assuming "NgayCapNhat" is the correct field
                            txtEditGiaTriDonHangToiThieu.Text = reader["GiaTriDonHangToiThieu"].ToString(); // Assuming "GiaTriDonHangToiThieu" is the correct field
                            txtEditSoLuongToiDa.Text = reader["SoLuongToiDa"].ToString(); // Assuming "SoLuongToiDa" is the correct field
                            txtEditSoLuongDaSuDung.Text = reader["SoLuongDaSuDung"].ToString(); // Assuming "SoLuongDaSuDung" is the correct field
                            txtEditMoTa.Text = reader["MoTa"].ToString();
                        }
                    }
                }
            }
        }

        protected void btnUpdatePromotion_Click(object sender, EventArgs e)
        {
            try
            {
                // Validate input fields
                if (string.IsNullOrWhiteSpace(txtEditTenKM.Text) ||
                    string.IsNullOrWhiteSpace(txtEditNgayBatDau.Text) ||
                    string.IsNullOrWhiteSpace(txtEditNgayKetThuc.Text) ||
                    string.IsNullOrWhiteSpace(txtEditGiamGia.Text) ||
                    string.IsNullOrWhiteSpace(ddlEditKieuGiamGia.SelectedValue) ||
                    string.IsNullOrWhiteSpace(ddlEditTrangThai.SelectedValue) ||
                    string.IsNullOrWhiteSpace(txtEditGiaTriDonHangToiThieu.Text) ||
                    string.IsNullOrWhiteSpace(txtEditSoLuongToiDa.Text))
                {
                    lblEditMessage.Text = "Vui lòng điền đầy đủ thông tin.";
                    lblEditMessage.ForeColor = System.Drawing.Color.Red;
                    lblEditMessage.Visible = true;
                    return;
                }

                string maKM = txtEditMaKM.Text.Trim(); // Keep this read-only
                string tenKM = txtEditTenKM.Text.Trim();
                DateTime ngayBatDau = DateTime.Parse(txtEditNgayBatDau.Text);
                DateTime ngayKetThuc = DateTime.Parse(txtEditNgayKetThuc.Text);
                float giamGia = float.Parse(txtEditGiamGia.Text);
                string kieuGiamGia = ddlEditKieuGiamGia.SelectedValue.Trim();
                string trangThai = ddlEditTrangThai.SelectedValue.Trim();
                string maHang = ddlEditMaHang.SelectedValue.Trim();
                DateTime ngayTao = DateTime.Parse(txtEditNgayTao.Text); // Assuming you want to keep this as is
                DateTime ngayCapNhat = DateTime.Parse(txtEditNgayCapNhat.Text); // Assuming you want to keep this as is
                float giaTriDonHangToiThieu = float.Parse(txtEditGiaTriDonHangToiThieu.Text);
                int soLuongToiDa = int.Parse(txtEditSoLuongToiDa.Text);
                string moTa = txtEditMoTa.Text.Trim();

                UpdatePromotion(maKM, tenKM, ngayBatDau, ngayKetThuc, giamGia, kieuGiamGia, trangThai, maHang, ngayTao, ngayCapNhat, giaTriDonHangToiThieu, soLuongToiDa, moTa);

                pnlEditPromotion.Visible = false; // Hide the edit panel
                LoadPromotions(); // Refresh the GridView
                ShowMessage("Khuyến mãi đã được cập nhật thành công.");


            }
            catch (FormatException)
            {
                lblEditMessage.Text = "Định dạng ngày hoặc số không hợp lệ. Vui lòng kiểm tra lại.";
                lblEditMessage.ForeColor = System.Drawing.Color.Red;
                lblEditMessage.Visible = true;
            }
            catch (Exception)
            {
                lblEditMessage.Text = "Đã xảy ra lỗi khi cập nhật khuyến mãi. Vui lòng thử lại.";
                lblEditMessage.ForeColor = System.Drawing.Color.Red;
                lblEditMessage.Visible = true;
            }
        }
        private void UpdatePromotion(string maKM, string tenKM, DateTime ngayBatDau, DateTime ngayKetThuc, float giamGia, string kieuGiamGia, string trangThai, string maHang, DateTime ngayTao, DateTime ngayCapNhat, float giaTriDonHangToiThieu, int soLuongToiDa, string moTa)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["QuanLyBanHang_SP_ConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "UPDATE KhuyenMai SET TenKM = @tenKM, NgayBatDau = @ngayBatDau, NgayKetThuc = @ngayKetThuc, GiamGia = @giamGia, KieuGiamGia = @kieuGiamGia, TrangThai = @trangThai, MaHang = @maHang, NgayTao = @ngayTao, NgayCapNhat = @ngayCapNhat, GiaTriDonHangToiThieu = @giaTriDonHangToiThieu, SoLuongToiDa = @soLuongToiDa, MoTa = @moTa WHERE MaKM = @maKM";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@maKM", maKM);
                    cmd.Parameters.AddWithValue("@tenKM", tenKM);
                    cmd.Parameters.AddWithValue("@ngayBatDau", ngayBatDau);
                    cmd.Parameters.AddWithValue("@ngayKetThuc", ngayKetThuc);
                    cmd.Parameters.AddWithValue("@giamGia", giamGia);
                    cmd.Parameters.AddWithValue("@kieuGiamGia", kieuGiamGia);
                    cmd.Parameters.AddWithValue("@trangThai", trangThai);
                    cmd.Parameters.AddWithValue("@maHang", (string.IsNullOrEmpty(maHang) ? (object)DBNull.Value : maHang)); // Handle null case
                    cmd.Parameters.AddWithValue("@ngayTao", ngayTao);
                    cmd.Parameters.AddWithValue("@ngayCapNhat", ngayCapNhat);
                    cmd.Parameters.AddWithValue("@giaTriDonHangToiThieu", giaTriDonHangToiThieu);
                    cmd.Parameters.AddWithValue("@soLuongToiDa", soLuongToiDa);
                    cmd.Parameters.AddWithValue("@moTa", moTa);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        protected void btnCancelEdit_Click(object sender, EventArgs e)
        {
            pnlEditPromotion.Visible = false; // Hide the edit panel
        }

        private bool IsPromotionUsed(string maKM)
        {
            // Logic kiểm tra khuyến mãi đã được sử dụng
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["QuanLyBanHang_SP_ConnectionString"].ConnectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM HoaDon WHERE MaKM = @MaKM", conn);
                cmd.Parameters.AddWithValue("@MaKM", maKM);
                int count = (int)cmd.ExecuteScalar();
                return count > 0; // Trả về true nếu đã sử dụng
            }
        }

        private void DeletePromotion(string maKM)
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["QuanLyBanHang_SP_ConnectionString"].ConnectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("DELETE FROM KhuyenMai WHERE MaKM = @MaKM", conn);
                cmd.Parameters.AddWithValue("@MaKM", maKM);
                cmd.ExecuteNonQuery();
            }
        }
        private void ShowMessage(string message)
        {
            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('" + message + "');", true);
        }
    }
}
