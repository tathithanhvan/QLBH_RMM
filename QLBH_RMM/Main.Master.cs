using System;
using System.Web;
using System.Web.UI;

namespace QLBH_RMM
{
    public partial class Main : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Kiểm tra nếu trang hiện tại thuộc thư mục Customer
          
        }

        protected void btntaikhoan_Click(object sender, ImageClickEventArgs e)
        {
            if (Session["UserName"] != null) // Kiểm tra người dùng đã đăng nhập
            {
                Response.Redirect("~/TaiKhoan.aspx");
            }
            else
            {
                Response.Redirect("~/Login.aspx");
            }
        }
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchQuery = txtSearch.Text.Trim();
            if (!string.IsNullOrEmpty(searchQuery))
            {
                Response.Redirect($"~/SanPham.aspx?search={Server.UrlEncode(searchQuery)}");
            }
        }

    }
}
