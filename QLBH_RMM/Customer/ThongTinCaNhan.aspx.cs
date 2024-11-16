using System;
using System.Data.SqlClient;

namespace QLBH_RMM.Customer
{
    public partial class ThongTinCaNhan : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserName"] != null) // Check if user is logged in
                {
                    string username = Session["UserName"].ToString();
                    LoadUserInfo(username); // Load user information
                }
                else
                {
                    Response.Redirect("~/Login.aspx");
                }
            }
        }

        private void LoadUserInfo(string username)
        {
            // Connection string to the database
            string connectionString = "Data Source=TRIPLETANDV;Initial Catalog=QuanLyBanHang;Integrated Security=True";

            // SQL command to retrieve customer information
            string query = @"SELECT KH.TenKH, KH.DiaChi, KH.GioiTinh, KH.NgaySinh, KH.SDT, KH.Email 
                             FROM KhachHang KH
                             INNER JOIN TaiKhoan TK ON KH.MaKH = TK.MaKH
                             WHERE TK.TenDN = @Username";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Username", username);
                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            // Assign data to TextBoxes, handling NULL values
                            TenKHTextBox.Text = reader["TenKH"] != DBNull.Value ? reader["TenKH"].ToString() : string.Empty;
                            DiaChiTextBox.Text = reader["DiaChi"] != DBNull.Value ? reader["DiaChi"].ToString() : string.Empty;
                            GioiTinhDropDown.SelectedValue = reader["GioiTinh"].ToString(); // Assuming 0 = Male, 1 = Female

                            // Convert birth date, if not present set to empty
                            NgaySinhTextBox.Text = reader["NgaySinh"] != DBNull.Value
                                ? Convert.ToDateTime(reader["NgaySinh"]).ToString("yyyy-MM-dd")
                                : string.Empty;

                            SDTTextBox.Text = reader["SDT"] != DBNull.Value ? reader["SDT"].ToString() : string.Empty;
                            EmailTextBox.Text = reader["Email"] != DBNull.Value ? reader["Email"].ToString() : string.Empty;
                        }
                    }
                }
            }
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            string tenKH = TenKHTextBox.Text.Trim();
            string diaChi = DiaChiTextBox.Text.Trim();
            string gioiTinh = GioiTinhDropDown.SelectedValue;
            DateTime ngaySinh;

            if (!DateTime.TryParse(NgaySinhTextBox.Text, out ngaySinh))
            {
                ngaySinh = DateTime.MinValue; // Handle empty birth date
            }

            string sdt = SDTTextBox.Text.Trim();
            string email = EmailTextBox.Text.Trim();
            string username = Session["UserName"].ToString();

            string connectionString = "Data Source=TRIPLETANDV;Initial Catalog=QuanLyBanHang;Integrated Security=True";

            // Check if the new phone number already exists
            string checkQuery = @"SELECT COUNT(*) FROM KhachHang WHERE SDT = @SDT AND MaKH <> (SELECT MaKH FROM TaiKhoan WHERE TenDN = @Username)";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                {
                    checkCmd.Parameters.AddWithValue("@SDT", sdt);
                    checkCmd.Parameters.AddWithValue("@Username", username);
                    conn.Open();

                    int count = (int)checkCmd.ExecuteScalar();
                    if (count > 0)
                    {
                        // Notify the user that the phone number is already in use
                        string script = "alert('Số điện thoại đã tồn tại. Vui lòng nhập số khác!');";
                        ClientScript.RegisterStartupScript(this.GetType(), "alert", script, true);
                        return; // Exit the method to prevent further processing
                    }
                }
            }

            // Proceed with the update if the phone number is unique
            string query = @"UPDATE KhachHang 
                     SET TenKH = @TenKH, DiaChi = @DiaChi, GioiTinh = @GioiTinh, NgaySinh = @NgaySinh, SDT = @SDT, Email = @Email 
                     FROM KhachHang KH
                     INNER JOIN TaiKhoan TK ON KH.MaKH = TK.MaKH
                     WHERE TK.TenDN = @Username";

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@TenKH", tenKH);
                        cmd.Parameters.AddWithValue("@DiaChi", diaChi);
                        cmd.Parameters.AddWithValue("@GioiTinh", gioiTinh);
                        cmd.Parameters.AddWithValue("@NgaySinh", ngaySinh != DateTime.MinValue ? (object)ngaySinh : DBNull.Value);
                        cmd.Parameters.AddWithValue("@SDT", sdt);
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@Username", username);

                        conn.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();

                        // Notify success or failure
                        string message = rowsAffected > 0 ? "Cập nhật thông tin thành công!" : "Cập nhật thông tin không thành công. Vui lòng thử lại!";
                        string script = $"alert('{message}'); window.location = '/TaiKhoan.aspx';";
                        ClientScript.RegisterStartupScript(this.GetType(), "alert", script, true);
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the exception
                string script = "alert('Đã xảy ra lỗi. Vui lòng thử lại sau!');";
                ClientScript.RegisterStartupScript(this.GetType(), "alert", script, true);
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/TaiKhoan.aspx");
        }
    }
}
