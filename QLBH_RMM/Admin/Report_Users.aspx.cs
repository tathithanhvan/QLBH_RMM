using OfficeOpenXml;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QLBH_RMM.Admin
{
    public partial class Report_Users : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadTongNguoiDung();
                LoadNguoiDungMoi();
                LoadHoatDongNguoiDung();
                LoadNguoiDungKhongHoatDong();
            }
        }

        private void LoadTongNguoiDung()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["QuanLyBanHang_SP_ConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM KhachHang";
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                int totalUsers = (int)cmd.ExecuteScalar();
                lblTotalUsers.Text = totalUsers.ToString();
            }
        }

        private void LoadNguoiDungMoi()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["QuanLyBanHang_SP_ConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT MaKH, TenKH, Email, NgayTao FROM KhachHang WHERE DATEDIFF(DAY, NgayTao, GETDATE()) <= 30"; // Users registered in the last 30 days
                SqlDataAdapter adapter = new SqlDataAdapter(query, conn);
                DataTable newUsersTable = new DataTable();
                adapter.Fill(newUsersTable);
                gdvNewUsers.DataSource = newUsersTable;
                gdvNewUsers.DataBind();
            }
        }

        private void LoadHoatDongNguoiDung()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["QuanLyBanHang_SP_ConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT k.MaKH, k.TenKH, k.SoDiem, k.diemdasudung, hang.Tenhang,
                           COUNT(h.MaHD) AS SoDonHang, 
                           SUM(h.TriGiaHD) AS TongChiTieu 
                    FROM KhachHang k 
					left join hangthanhvien hang on k.mahang=hang.mahang
                    LEFT JOIN HoaDon h ON k.MaKH = h.MaKH 
                    GROUP BY k.MaKH, k.TenKH, k.SoDiem, k.diemdasudung, Tenhang";
                SqlDataAdapter adapter = new SqlDataAdapter(query, conn);
                DataTable userActivityTable = new DataTable();
                adapter.Fill(userActivityTable);
                gdvUserActivity.DataSource = userActivityTable;
                gdvUserActivity.DataBind();
            }
        }

        private void LoadNguoiDungKhongHoatDong()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["QuanLyBanHang_SP_ConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT k.MaKH, TenKH, Email, 
                           MAX(NgayMua) AS NgayCuoiHoatDong 
                    FROM KhachHang k 
                    LEFT JOIN HoaDon h ON k.MaKH = h.MaKH 
                    GROUP BY k.MaKH, TenKH, Email 
                    HAVING MAX(NgayMua) < DATEADD(MONTH, -3, GETDATE())"; // Users inactive for more than 6 months
                SqlDataAdapter adapter = new SqlDataAdapter(query, conn);
                DataTable inactiveUsersTable = new DataTable();
                adapter.Fill(inactiveUsersTable);
                gdvInactiveUsers.DataSource = inactiveUsersTable;
                gdvInactiveUsers.DataBind();
            }
        }

        protected void btnXuatBaoCao_Click(object sender, EventArgs e)
        {
            using (ExcelPackage excel = new ExcelPackage())
            {

                // Sheet for Người Dùng Mới
                var wsNewUsers = excel.Workbook.Worksheets.Add("Người Dùng Mới");
                ExportGridViewToWorksheet(gdvNewUsers, wsNewUsers);

                // Sheet for Hoạt Động Của Người Dùng
                var wsUserActivity = excel.Workbook.Worksheets.Add("Hoạt Động Người Dùng");
                ExportGridViewToWorksheet(gdvUserActivity, wsUserActivity);

                // Sheet for Người Dùng Không Hoạt Động
                var wsInactiveUsers = excel.Workbook.Worksheets.Add("Người Dùng Không Hoạt Động");
                ExportGridViewToWorksheet(gdvInactiveUsers, wsInactiveUsers);

                // Set the response content for download
                Response.Clear();
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("content-disposition", "attachment; filename=BaoCaoNguoiDung.xlsx");
                Response.BinaryWrite(excel.GetAsByteArray());
                Response.End();
            }
        }

        private void ExportGridViewToWorksheet(GridView gridView, ExcelWorksheet worksheet)
        {
            // Export headers
            for (int i = 0; i < gridView.HeaderRow.Cells.Count; i++)
            {
                worksheet.Cells[1, i + 1].Value = HttpUtility.HtmlDecode(gridView.HeaderRow.Cells[i].Text);
                worksheet.Cells[1, i + 1].Style.Font.Bold = true;
                worksheet.Cells[1, i + 1].Style.Fill.PatternType = OfficeOpenXml.Style.ExcelFillStyle.Solid;
                worksheet.Cells[1, i + 1].Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.LightGreen);
            }

            // Export rows
            for (int i = 0; i < gridView.Rows.Count; i++)
            {
                for (int j = 0; j < gridView.Rows[i].Cells.Count; j++)
                {
                    worksheet.Cells[i + 2, j + 1].Value = HttpUtility.HtmlDecode(gridView.Rows[i].Cells[j].Text);
                }
            }

            // Auto-fit columns for better readability
            worksheet.Cells[worksheet.Dimension.Address].AutoFitColumns();
        }

    }
}