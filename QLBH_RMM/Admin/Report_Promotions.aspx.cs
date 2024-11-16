using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using OfficeOpenXml;

namespace QLBH_RMM.Admin
{
    public partial class Report_Promotions : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadKMSapHetHan();
                LoadTyLeSuDung();
            }
        }

        private void LoadKMSapHetHan()
        {
            string query = @"
                SELECT MaKM, TenKM, NgayBatDau, NgayKetThuc, GiamGia, KieuGiamGia, TrangThai
                FROM KhuyenMai
                WHERE NgayKetThuc >= GETDATE()
                  AND NgayKetThuc <= DATEADD(DAY, 7, GETDATE())
                  AND TrangThai = N'Hoạt động';";

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["QuanLyBanHang_SP_ConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gdvKMSapHetHan.DataSource = dt;
                    gdvKMSapHetHan.DataBind();
                }
            }
        }

        private void LoadTyLeSuDung()
        {
            string query = @"
                SELECT 
                    km.MaKM, 
                    km.TenKM, 
                    km.SoLuongDaSuDung AS TongSuDung, 
                    km.SoLuongToiDa AS TongPhatHanh, 
                    CAST(km.SoLuongDaSuDung AS FLOAT) / NULLIF(km.SoLuongToiDa, 0) AS TyLeSuDung
                FROM 
                    KhuyenMai km
                WHERE 
                    km.SoLuongToiDa > 0;";

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["QuanLyBanHang_SP_ConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    GridViewUsageRate.DataSource = dt;
                    GridViewUsageRate.DataBind();
                }
            }
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            // Lọc theo tháng đã chọn
            int selectedMonth = int.Parse(ddlMonths.SelectedValue);
            string query = @"
                SELECT *
                FROM 
                    KhuyenMai 
                WHERE 
                    MONTH(NgayKetThuc) = @SelectedMonth AND 
                    NgayKetThuc >= GETDATE()
                ORDER BY 
                    NgayKetThuc;";

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["QuanLyBanHang_SP_ConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@SelectedMonth", selectedMonth);
                    conn.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gdvKMThang.DataSource = dt;
                    gdvKMThang.DataBind();
                }
            }
        }

        protected void btnXuatBaoCao_Click(object sender, EventArgs e)
        {
            using (ExcelPackage excel = new ExcelPackage())
            {
                // Xuất báo cáo khuyến mãi tháng
                var workSheet1 = excel.Workbook.Worksheets.Add("Báo Cáo Khuyến Mãi Tháng");
                DataTable dtMonthly = LayKMThang();
                DecodeDataTable(dtMonthly); // Decode HTML entities
                workSheet1.Cells["A1"].LoadFromDataTable(dtMonthly, true);

                // Định dạng tiêu đề
                for (int i = 1; i <= dtMonthly.Columns.Count; i++)
                {
                    workSheet1.Cells[1, i].Style.Font.Bold = true;
                    workSheet1.Cells[1, i].Style.Fill.PatternType = OfficeOpenXml.Style.ExcelFillStyle.Solid;
                    workSheet1.Cells[1, i].Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.LightGray);
                }

                // Xuất tỷ lệ sử dụng khuyến mãi
                var workSheet2 = excel.Workbook.Worksheets.Add("Tỷ Lệ Sử Dụng Khuyến Mãi");
                DataTable dtUsageRate = TyLeSuDung();
                DecodeDataTable(dtUsageRate); // Decode HTML entities
                workSheet2.Cells["A1"].LoadFromDataTable(dtUsageRate, true);

                // Định dạng tiêu đề cho tỷ lệ sử dụng
                for (int i = 1; i <= dtUsageRate.Columns.Count; i++)
                {
                    workSheet2.Cells[1, i].Style.Font.Bold = true;
                    workSheet2.Cells[1, i].Style.Fill.PatternType = OfficeOpenXml.Style.ExcelFillStyle.Solid;
                    workSheet2.Cells[1, i].Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.LightGray);
                }

                // Tạo file Excel và gửi phản hồi
                using (MemoryStream stream = new MemoryStream())
                {
                    excel.SaveAs(stream);
                    var fileName = "BaoCaoKhuyenMai.xlsx";
                    Response.Clear();
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    Response.AddHeader("content-disposition", $"attachment; filename={fileName}");
                    Response.BinaryWrite(stream.ToArray());
                    Response.End();
                }
            }
        }
        private void DecodeDataTable(DataTable table)
        {
            foreach (DataRow row in table.Rows)
            {
                for (int i = 0; i < table.Columns.Count; i++)
                {
                    if (row[i] is string cellValue)
                    {
                        row[i] = HttpUtility.HtmlDecode(cellValue);
                    }
                }
            }
        }

        private DataTable LayKMThang()
        {
            string query = @"
                SELECT 
                    MaKM, 
                    TenKM, 
                    NgayBatDau, 
                    NgayKetThuc, 
                    GiamGia, 
                    KieuGiamGia, 
                    TrangThai 
                FROM 
                    KhuyenMai 
                WHERE 
                    MONTH(NgayKetThuc) = @SelectedMonth AND 
                    NgayKetThuc >= GETDATE();";

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["QuanLyBanHang_SP_ConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@SelectedMonth", int.Parse(ddlMonths.SelectedValue));
                    conn.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    return dt;
                }
            }
        }

        private DataTable TyLeSuDung()
        {
            string query = @"
                SELECT 
                    km.MaKM, 
                    km.TenKM, 
                    km.SoLuongDaSuDung AS TongSuDung, 
                    km.SoLuongToiDa AS TongPhatHanh, 
                    CAST(km.SoLuongDaSuDung AS FLOAT) / NULLIF(km.SoLuongToiDa, 0) AS TyLeSuDung
                FROM 
                    KhuyenMai km
                WHERE 
                    km.SoLuongToiDa > 0;";

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["QuanLyBanHang_SP_ConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    return dt;
                }
            }
        }
    }
}