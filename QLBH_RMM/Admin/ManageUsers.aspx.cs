using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace QLBH_RMM.Admin
{
    public partial class ManageUsers : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["QuanLyBanHang_SP_ConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadEmployees();
                LoadPositions();
            }
        }

        private void LoadEmployees()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT MaNV, TenNV, Email, SDT, MaCV FROM NhanVien", conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                GridViewEmployees.DataSource = dt;
                GridViewEmployees.DataBind();

                DropDownListEmployees.DataSource = dt;
                DropDownListEmployees.DataTextField = "TenNV";
                DropDownListEmployees.DataValueField = "MaNV";
                DropDownListEmployees.DataBind();

                ddlNhanVien.DataSource = dt;
                ddlNhanVien.DataTextField = "TenNV";
                ddlNhanVien.DataValueField = "MaNV";
                ddlNhanVien.DataBind();
            }
        }

        private void LoadPositions()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT MaCV, TenCV FROM ChucVu", conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                DropDownListPosition.DataSource = dt;
                DropDownListPosition.DataTextField = "TenCV";
                DropDownListPosition.DataValueField = "MaCV";
                DropDownListPosition.DataBind();
            }
        }

        protected void ButtonAddEmployee_Click(object sender, EventArgs e)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand("INSERT INTO NhanVien (TenNV, GioiTinh, Email, SDT, MaCV) VALUES (@TenNV, @GioiTinh, @Email, @SDT, @MaCV)", conn);
                    cmd.Parameters.AddWithValue("@TenNV", TextBoxName.Text);
                    cmd.Parameters.AddWithValue("@GioiTinh", ddlGioiTinh.SelectedValue);
                    cmd.Parameters.AddWithValue("@Email", TextBoxEmail.Text);
                    cmd.Parameters.AddWithValue("@SDT", TextBoxPhone.Text);
                    cmd.Parameters.AddWithValue("@MaCV", DropDownListPosition.SelectedValue);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }

                LoadEmployees(); 
                ShowMessage("Thêm nhân viên thành công!", "success");
            }
            catch (Exception ex)
            {
                ShowMessage("Có lỗi xảy ra: " + ex.Message, "error");
            }
        }

        protected void ButtonAddAccount_Click(object sender, EventArgs e)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    // Kiểm tra xem TenDN đã tồn tại trong bảng TaiKhoan chưa
                    SqlCommand checkUsernameCmd = new SqlCommand("SELECT COUNT(*) FROM TaiKhoan WHERE TenDN = @TenDN", conn);
                    checkUsernameCmd.Parameters.AddWithValue("@TenDN", TextBoxUsername.Text);

                    conn.Open();
                    int usernameExists = (int)checkUsernameCmd.ExecuteScalar();
                    conn.Close();

                    if (usernameExists > 0)
                    {
                        // Nếu tên đăng nhập đã tồn tại, hiển thị thông báo lỗi
                        ShowMessage("Tên đăng nhập đã tồn tại. Vui lòng chọn tên đăng nhập khác.", "error");
                        return;
                    }

                    // Nếu tên đăng nhập chưa tồn tại, thêm tài khoản mới
                    SqlCommand cmd = new SqlCommand("INSERT INTO TaiKhoan (TenDN, MK, MaNV, Muc) VALUES (@TenDN, @MK, @MaNV, @Muc)", conn);
                    cmd.Parameters.AddWithValue("@TenDN", TextBoxUsername.Text);
                    cmd.Parameters.AddWithValue("@MK", TextBoxPassword.Text);
                    cmd.Parameters.AddWithValue("@MaNV", DropDownListEmployees.SelectedValue);
                    cmd.Parameters.AddWithValue("@Muc", DropDownListRole.SelectedValue);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();

                    ShowMessage("Thêm tài khoản thành công!", "success");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Có lỗi xảy ra: " + ex.Message, "error");
            }
        }


        protected void btnGanQuyen_Click(object sender, EventArgs e)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand("Update TaiKhoan set Muc= @Muc where MaNV = @MaNV", conn);
                    cmd.Parameters.AddWithValue("@MaNV", ddlNhanVien.SelectedValue);
                    cmd.Parameters.AddWithValue("@Muc", ddlVaiTro.SelectedValue);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }

                ShowMessage("Gán quyền thành công!", "success");
            }
            catch (Exception ex)
            {
                ShowMessage("Có lỗi xảy ra: " + ex.Message, "error");
            }
        }

        private void ShowMessage(string message, string type)
        {
            string script = $"alert('{message}');";
            ClientScript.RegisterStartupScript(this.GetType(), "ShowMessage", script, true);
        }
    }
}
