using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;
using System.Web.UI;

namespace QLBH_RMM.Admin
{
    public partial class AddProduct : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadSizes();
            }
        }

        private void LoadSizes()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["QuanLyBanHang_SP_ConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT MaSize, TenSize FROM Size";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    SqlDataReader reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {
                        ddlSize.Items.Add(new ListItem(reader["TenSize"].ToString(), reader["MaSize"].ToString()));
                    }
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            // Validation checks
            if (string.IsNullOrWhiteSpace(txtProductCode.Text))
            {
                ShowAlert("Vui lòng nhập mã sản phẩm.");
                return;
            }
            if (string.IsNullOrWhiteSpace(txtProductName.Text))
            {
                ShowAlert("Vui lòng nhập tên sản phẩm.");
                return;
            }
            if (ddlProductType.SelectedValue == "")
            {
                ShowAlert("Vui lòng chọn loại sản phẩm.");
                return;
            }
            if (ddlStatus.SelectedValue == "")
            {
                ShowAlert("Vui lòng chọn tình trạng sản phẩm.");
                return;
            }
            if (ddlSize.SelectedValue == "")
            {
                ShowAlert("Vui lòng chọn kích cỡ sản phẩm.");
                return;
            }
            if (string.IsNullOrWhiteSpace(txtPrice.Text) || !decimal.TryParse(txtPrice.Text, out _))
            {
                ShowAlert("Vui lòng nhập giá sản phẩm hợp lệ.");
                return;
            }

            if (IsProductCodeExists(txtProductCode.Text))
            {
                ShowAlert("Mã sản phẩm đã tồn tại.");
                return;
            }

            // Proceed to insert into the database
            string connectionString = ConfigurationManager.ConnectionStrings["QuanLyBanHang_SP_ConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "INSERT INTO SanPham (MaSP, TenSP, MaLoai, Img, MoTa, TinhTrang) VALUES (@MaSP, @TenSP, @MaLoai, @Img, @MoTa, @TinhTrang); " +
                               "INSERT INTO SanPham_Size (MaSP, MaSize, DonGia) VALUES (@MaSP, @MaSize, @DonGia)";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    string imgPath = SaveProductImage();

                    cmd.Parameters.AddWithValue("@MaSP", txtProductCode.Text);
                    cmd.Parameters.AddWithValue("@TenSP", txtProductName.Text);
                    cmd.Parameters.AddWithValue("@MaLoai", ddlProductType.SelectedValue);
                    cmd.Parameters.AddWithValue("@Img", imgPath);
                    cmd.Parameters.AddWithValue("@MoTa", txtDescription.Text);
                    cmd.Parameters.AddWithValue("@TinhTrang", ddlStatus.SelectedValue);
                    cmd.Parameters.AddWithValue("@MaSize", ddlSize.SelectedValue);
                    cmd.Parameters.AddWithValue("@DonGia", Convert.ToDecimal(txtPrice.Text));

                    cmd.ExecuteNonQuery();
                }
            }

            // Hiển thị thông báo thành công trước khi chuyển hướng
            ScriptManager.RegisterStartupScript(this, GetType(), "showalert", "alert('Sản phẩm mới đã được thêm!'); window.location='ManageProducts.aspx';", true);
        }
    

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("ManageProducts.aspx");
        }

        private string SaveProductImage()
        {
            if (fuProductImage.HasFile)
            {
                string fileName = System.IO.Path.GetFileName(fuProductImage.FileName);
                string filePath = Server.MapPath("~/Images/") + fileName;
                fuProductImage.SaveAs(filePath);
                return "~/Images/" + fileName;
            }
            return null;
        }

        private bool IsProductCodeExists(string productCode)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["QuanLyBanHang_SP_ConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT COUNT(*) FROM SanPham WHERE MaSP = @MaSP";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@MaSP", productCode);
                    int count = (int)cmd.ExecuteScalar();
                    return count > 0;
                }
            }
        }

        private void ShowAlert(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showalert", $"alert('{message}');", true);
        }
    }
}
