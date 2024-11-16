using OfficeOpenXml;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QLBH_RMM.Admin
{
    public partial class Report_Products : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // BindGridView("SalesReport");
            }
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            
            BindGridView(ddlReportType.SelectedValue);
        }

        protected void btnExport_Click(object sender, EventArgs e)
        {
            // Check if data exists in Session
            DataTable dt = Session["ReportData"] as DataTable;
            if (dt == null || dt.Rows.Count == 0)
            {
                Response.Write("<script>alert('Không có dữ liệu để xuất!');</script>");
                return;
            }

            ExcelPackage.LicenseContext = LicenseContext.NonCommercial;

            using (ExcelPackage excel = new ExcelPackage())
            {
                var workSheet = excel.Workbook.Worksheets.Add("Báo Cáo Sản Phẩm");
                workSheet.Cells["A1"].LoadFromDataTable(dt, true);

                // Format header
                for (int i = 1; i <= dt.Columns.Count; i++)
                {
                    workSheet.Cells[1, i].Style.Font.Bold = true;
                    workSheet.Cells[1, i].Style.Fill.PatternType = OfficeOpenXml.Style.ExcelFillStyle.Solid;
                    workSheet.Cells[1, i].Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.LightGray);
                }

                using (MemoryStream stream = new MemoryStream())
                {
                    excel.SaveAs(stream);
                    string fileName = "BaoCaoSanPham.xlsx";
                    Response.Clear();
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    Response.AddHeader("content-disposition", $"attachment; filename=\"{fileName}\"");
                    Response.BinaryWrite(stream.ToArray());
                    Response.Flush();
                    Response.SuppressContent = true;
                    Response.End();
                }
            }
        }



        protected void ddlReportType_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindGridView(ddlReportType.SelectedValue);
        }

        private void BindGridView(string reportType)
        {
            string query = string.Empty;

            DateTime? startDate = null;
            DateTime? endDate = null;

            if (!string.IsNullOrEmpty(txtStartDate.Text))
            {
                startDate = DateTime.Parse(txtStartDate.Text);
            }

            if (!string.IsNullOrEmpty(txtEndDate.Text))
            {
                endDate = DateTime.Parse(txtEndDate.Text);
            }

            switch (reportType)
            {
                case "DTTheoSP":
                    query = @"
                SELECT 
                    sp.MaSP,
                    sp.TenSP,
                    ls.TenLoai,
                    SUM(cthd.Soluong) AS SoLuongBan,
                    SUM(cthd.Soluong * sps.DonGia) AS TongDoanhThu
                FROM 
                    CTHD cthd
                JOIN 
                    SanPham sp ON cthd.MaSP = sp.MaSP
                JOIN 
                    SanPham_Size sps ON sp.MaSP = sps.MaSP AND cthd.MaSize = sps.MaSize
                JOIN 
                    LoaiSP ls ON sp.MaLoai = ls.MaLoai
                JOIN 
                    HoaDon hd ON cthd.MaHD = hd.MaHD
                WHERE 
                    hd.TinhTrang = N'Đã Xong'";

                    if (startDate.HasValue)
                    {
                        query += " AND HD.NgayMua >= @StartDate";
                    }
                    if (endDate.HasValue)
                    {
                        query += " AND HD.NgayMua <= @EndDate";
                    }

                    query += @"
                GROUP BY 
                    sp.MaSP, sp.TenSP, ls.TenLoai
                ORDER BY 
                    TongDoanhThu DESC;";
                    break;

                case "TPHayDiKemSP":
                    query = @"
                       SELECT 
                            sp.MaSP,
                            sp.TenSP,
                            t.MaTopping,
                            t.TenTopping,
                            SUM(cthd.Soluong) AS SoLanDiKem
                        FROM 
                            CTHD cthd
                        JOIN 
                            SanPham sp ON cthd.MaSP = sp.MaSP
                        JOIN 
                            SanPham_Topping stp ON cthd.MaCTHD = stp.MaCTHD AND cthd.MaSP = stp.MaSP
                        JOIN 
                            Topping t ON stp.MaTopping = t.MaTopping
                        GROUP BY 
                            sp.MaSP, sp.TenSP, t.MaTopping, t.TenTopping
                        ORDER BY 
                            SoLanDiKem DESC;";
                    break;

                case "MonthlyRevenueReport":
                    query = @"
                        SELECT 
                            SP.TenSP,
                            MONTH(HD.NgayMua) AS Thang,
                            SUM(CTHD.Soluong) AS TongSoLuong,
                            SUM(CTHD.Soluong * SPS.DonGia) AS TongDoanhThu
                        FROM 
                            HoaDon HD
                            JOIN CTHD ON HD.MaHD = CTHD.MaHD
                            JOIN SanPham SP ON CTHD.MaSP = SP.MaSP
                            JOIN SanPham_Size SPS ON CTHD.MaSP = SPS.MaSP AND CTHD.MaSize = SPS.MaSize
                        WHERE 
                            HD.TinhTrang = N'Đã xong'";
                             if (startDate.HasValue)
                                                {
                                                    query += " AND HD.NgayMua >= @StartDate";
                                                }
                                        if (endDate.HasValue)
                                        {
                                            query += " AND HD.NgayMua <= @EndDate";
                                        }

                                        query += @"
                        GROUP BY 
                            SP.TenSP, MONTH(HD.NgayMua)
                        ORDER BY 
                            Thang, SP.TenSP;";
                    break;

                case "SPBanChay":
                    query = @"
                        SELECT 
                            SP.TenSP,
                            SUM(CTHD.Soluong) AS TongSoLuongBan,
                            SUM(CTHD.Soluong * SPS.DonGia) AS TongDoanhThu
                        FROM 
                            HoaDon HD
                            JOIN CTHD ON HD.MaHD = CTHD.MaHD
                            JOIN SanPham SP ON CTHD.MaSP = SP.MaSP
                            JOIN SanPham_Size SPS ON CTHD.MaSP = SPS.MaSP AND CTHD.MaSize = SPS.MaSize
                        WHERE 
                            HD.TinhTrang = N'Đã xong'
                        GROUP BY 
                            SP.TenSP
                        ORDER BY 
                            TongSoLuongBan DESC;";
                    break;
            }

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["QuanLyBanHang_SP_ConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    if (startDate.HasValue)
                    {
                        cmd.Parameters.AddWithValue("@StartDate", startDate.Value);
                    }
                    if (endDate.HasValue)
                    {
                        cmd.Parameters.AddWithValue("@EndDate", endDate.Value);
                    }
                    conn.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    GridViewReports.DataSource = dt;
                    GridViewReports.DataBind();

                    Session["ReportData"] = dt;
                }
            }
        }
    }
}
