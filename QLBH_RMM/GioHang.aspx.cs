using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QLBH_RMM
{
    public partial class GioHang : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCart();
            }
        }

        // Tải giỏ hàng từ session và hiển thị lên giao diện
        private void LoadCart()
        {
            List<CartItem> cart = (List<CartItem>)Session["Cart"];
            if (cart != null && cart.Count > 0)
            {
                CartListView.DataSource = cart;
                CartListView.DataBind();

                // Tính tổng tiền cho toàn bộ giỏ hàng
                decimal grandTotal = CalculateGrandTotal(cart);
                TotalLabel.Text = grandTotal.ToString("N0") + " VNĐ";
            }
            else
            {
                CartListView.DataSource = null;
                CartListView.DataBind();
                TotalLabel.Text = "Giỏ hàng trống";
            }
        }

        private decimal CalculateGrandTotal(List<CartItem> cart)
        {
            decimal grandTotal = 0;
            foreach (var item in cart)
            {
                decimal toppingCost = CalculateToppingCost(item.MaTopping);
                decimal itemTotal = (item.DonGia + toppingCost) * item.SoLuong;
                grandTotal += itemTotal;
            }
            return grandTotal;
        }

        private decimal CalculateToppingCost(string toppingCodes)
        {
            decimal totalCost = 0;
            if (!string.IsNullOrWhiteSpace(toppingCodes))
            {
                string connString = ConfigurationManager.ConnectionStrings["QuanLyBanHang_SP_ConnectionString"].ConnectionString;
                string[] codes = toppingCodes.Split(',');

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    conn.Open();
                    foreach (var code in codes)
                    {
                        string toppingQuery = "SELECT giatopping FROM Topping WHERE MaTopping = @toppingCode";
                        using (SqlCommand toppingCmd = new SqlCommand(toppingQuery, conn))
                        {
                            toppingCmd.Parameters.AddWithValue("@toppingCode", code.Trim());
                            var toppingResult = toppingCmd.ExecuteScalar();
                            if (toppingResult != null)
                            {
                                totalCost += Convert.ToDecimal(toppingResult);
                            }
                        }
                    }
                }
            }
            return totalCost;
        }

        // Hàm xử lý các hành động của người dùng trên ListView (Xóa hoặc cập nhật số lượng sản phẩm)
        protected void CartListView_ItemCommand(object sender, ListViewCommandEventArgs e)
        {
            List<CartItem> cart = (List<CartItem>)Session["Cart"];
            if (cart == null) return;

            if (e.CommandName == "Remove")
            {
                string productId = e.CommandArgument.ToString();
                CartItem itemToRemove = cart.Find(item => item.MaSP == productId);
                if (itemToRemove != null)
                {
                    cart.Remove(itemToRemove); // Xóa sản phẩm khỏi giỏ hàng
                    Session["Cart"] = cart; // Cập nhật lại Session giỏ hàng
                    LoadCart(); // Tải lại giỏ hàng để hiển thị
                }
            }
            else if (e.CommandName == "UpdateQuantity")
            {
                string productId = e.CommandArgument.ToString();
                Button btn = (Button)e.CommandSource; // Lấy nút bấm
                ListViewItem listViewItem = (ListViewItem)btn.NamingContainer; // Lấy item chứa nút bấm
                TextBox quantityTextBox = (TextBox)listViewItem.FindControl("QuantityTextBox"); // Lấy TextBox chứa số lượng

                // Kiểm tra nếu TextBox không null và giá trị hợp lệ
                if (quantityTextBox != null)
                {
                    if (int.TryParse(quantityTextBox.Text, out int newQuantity) && newQuantity > 0)
                    {
                        CartItem itemToUpdate = cart.Find(cartItem => cartItem.MaSP == productId);
                        if (itemToUpdate != null)
                        {
                            itemToUpdate.SoLuong = newQuantity; // Cập nhật số lượng
                            Session["Cart"] = cart; // Lưu lại giỏ hàng vào Session
                            LoadCart(); // Tải lại giỏ hàng để hiển thị
                        }
                    }
                }
            }
        }

        // Hàm xử lý khi người dùng bấm nút "Checkout" để thanh toán
        protected void Checkout_Click(object sender, EventArgs e)
        {
            List<CartItem> cart = (List<CartItem>)Session["Cart"];
            var customerId = Session["CustomerId"];
            if (customerId == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }
            else if (cart != null && cart.Count > 0)
            {
                decimal grandTotal = CalculateGrandTotal(cart);
                Session["TotalAmount"] = grandTotal;
                Response.Redirect("DatHang.aspx");
            }
            else
            {
                Response.Write("<script>alert('Giỏ hàng của bạn đang trống');</script>");
            }
        }
    }
}
