using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QLBH_RMM
{
    public partial class ChiTietSanPham : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Lấy mã sản phẩm và mã kích cỡ từ URL
                string maSP = Request.QueryString["MaSP"];
                string maSize = Request.QueryString["MaSize"];

                // Hiển thị chi tiết sản phẩm
                if (!string.IsNullOrEmpty(maSP))
                {
                    LoadProductDetails(maSP, maSize);
                }
            }
        }

        private void LoadProductDetails(string maSP, string maSize)
        {
            string connString = ConfigurationManager.ConnectionStrings["QuanLyBanHang_SP_ConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                string query = "SELECT SP.TenSP, SP.Img, DonGia, S.TenSize, MoTa " +
                               "FROM SanPham SP " +
                               "LEFT JOIN SanPham_Size SS ON SP.MaSP = SS.MaSP " +
                               "LEFT JOIN Size S ON S.MaSize = SS.MaSize " +
                               "WHERE SP.MaSP = @MaSP AND S.MaSize = @MaSize";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@MaSP", maSP);
                    cmd.Parameters.AddWithValue("@MaSize", maSize);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            TenSPLabel.Text = reader["TenSP"].ToString();
                            ProductImage.ImageUrl = reader["Img"].ToString();
                            DonGiaLabel.Text = string.Format("{0:0,000}", reader["DonGia"]);
                            MoTaLabel.Text = reader["MoTa"].ToString();
                            SizeLabel.Text = reader["TenSize"].ToString();
                        }
                        else
                        {
                        }
                    }
                }
            }
        }
        protected void AddToCart_Click(object sender, EventArgs e)
        {
            // Lấy mã sản phẩm từ query string
            string masp = Request.QueryString["MaSP"];
            string masize = Request.QueryString["MaSize"];
            decimal dongia = Convert.ToDecimal(DonGiaLabel.Text); // Giá sản phẩm
            string tensp = TenSPLabel.Text; // Tên sản phẩm
            string tensize = SizeLabel.Text; // Tên kích thước

            // Lấy số lượng sản phẩm từ input
            int soLuong = int.Parse(quantityInput.Value);

            // Lấy topping đã chọn (mã và tên)
            string selectedToppings = string.Join(", ", ToppingCheckBoxList.Items.Cast<ListItem>()
                                                        .Where(i => i.Selected)
                                                        .Select(i => i.Value)); // Mã topping

            string toppingNames = string.Join(", ", ToppingCheckBoxList.Items.Cast<ListItem>()
                                                        .Where(i => i.Selected)
                                                        .Select(i => i.Text)); // Tên topping

            // Lấy ghi chú đã chọn (mã và tên)
            string selectedNotes = string.Join(", ", NoteCheckBoxList.Items.Cast<ListItem>()
                                                        .Where(i => i.Selected)
                                                        .Select(i => i.Value)); // Mã ghi chú

            string noteNames = string.Join(", ", NoteCheckBoxList.Items.Cast<ListItem>()
                                                        .Where(i => i.Selected)
                                                        .Select(i => i.Text)); // Tên ghi chú

            // Sử dụng Session để lưu trữ giỏ hàng
            List<CartItem> cart = (List<CartItem>)Session["Cart"];
            if (cart == null)
            {
                cart = new List<CartItem>();
            }

            // Tạo sản phẩm mới
            CartItem newItem = new CartItem
            {
                MaSP = masp,
                TenSP = tensp,
                MaSize = masize,
                TenSize = tensize,
                DonGia = dongia,
                SoLuong = soLuong,
                MaTopping = selectedToppings, // Mã topping
                TenTopping = toppingNames, // Tên topping
                MaGC = selectedNotes, // Mã ghi chú
                TenGC = noteNames // Tên ghi chú
            };

            // Thêm vào giỏ hàng
            cart.Add(newItem);
            Session["Cart"] = cart;

            // Thông báo cho người dùng
            Response.Write("<script>alert('Sản phẩm đã được thêm vào giỏ hàng!');</script>");
        }

    }

    public class CartItem
    {
        public string MaSP { get; set; } 
        public string TenSP { get; set; } 
        public string MaSize { get; set; }
        public string TenSize { get; set; } 
        public decimal DonGia { get; set; }
        public int SoLuong { get; set; }
        public string MaTopping { get; set; } 
        public string TenTopping { get; set; } 
        public string MaGC { get; set; } 
        public string TenGC { get; set; } 
        public string GhiChu { get; set; } 
    }

}
