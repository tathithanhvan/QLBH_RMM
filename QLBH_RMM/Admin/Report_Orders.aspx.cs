using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.IO;
using OfficeOpenXml; // EPPlus
using iTextSharp.text;
using iTextSharp.text.pdf;

namespace QLBH_RMM.Admin
{
    public partial class Report_Orders : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnFilter_Click(object sender, EventArgs e)
        {
            DateTime fromDate;
            DateTime toDate;

            // Kiểm tra nếu cả hai ngày đều hợp lệ
            if (DateTime.TryParse(txtFromDate.Text, out fromDate) && DateTime.TryParse(txtToDate.Text, out toDate))
            {
                // Kiểm tra nếu toDate lớn hơn fromDate
                if (toDate > fromDate)
                {
                    // Nếu toDate lớn hơn fromDate, tiếp tục xử lý
                    srcOrderList.SelectParameters["FromDate"].DefaultValue = fromDate.ToString("yyyy-MM-dd");
                    srcOrderList.SelectParameters["ToDate"].DefaultValue = toDate.ToString("yyyy-MM-dd");

                    GridViewOrders.DataBind();
                }
                else
                {
                    // Nếu toDate không lớn hơn fromDate, hiển thị thông báo lỗi cho người dùng
                    // Ví dụ: Sử dụng một Label hoặc MessageBox để hiển thị thông báo
                    lblErrorMessage.Text = "Ngày kết thúc phải lớn hơn ngày bắt đầu.";
                    lblErrorMessage.Visible = true; // Đảm bảo thông báo được hiển thị
                }
            }
            else
            {
                // Xử lý lỗi nếu một trong các ngày không hợp lệ
                lblErrorMessage.Text = "Vui lòng nhập ngày hợp lệ.";
                lblErrorMessage.Visible = true; // Đảm bảo thông báo được hiển thị
            }
        }


        protected void btnExportToExcel_Click(object sender, EventArgs e)
        {
            // Get data from GridView into a DataTable
            DataTable dt = CreateDataTableFromGridView();

            if (dt.Rows.Count == 0)
            {
                lblErrorMessage.Text = "Không có dữ liệu để xuất!";
                lblErrorMessage.Visible = true;
                return;
            }

            // Export to Excel
            ExcelPackage.LicenseContext = LicenseContext.NonCommercial;
            using (ExcelPackage excel = new ExcelPackage())
            {
                var workSheet = excel.Workbook.Worksheets.Add("Báo Cáo Đơn Hàng");
                workSheet.Cells["A1"].LoadFromDataTable(dt, true);

                // Autofit columns
                for (int i = 1; i <= dt.Columns.Count; i++)
                {
                    workSheet.Column(i).AutoFit();
                }

                // Save file
                using (MemoryStream stream = new MemoryStream())
                {
                    excel.SaveAs(stream);
                    var fileName = "BaoCaoDonHang.xlsx";
                    Response.Clear();
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    Response.AddHeader("content-disposition", $"attachment; filename={fileName}");
                    Response.BinaryWrite(stream.ToArray());
                    Response.End();
                }
            }
        }

        protected void btnExportToPDF_Click(object sender, EventArgs e)
        {
            // Get data from GridView into a DataTable
            DataTable dt = CreateDataTableFromGridView();

            if (dt.Rows.Count == 0)
            {
                lblErrorMessage.Text = "Không có dữ liệu để xuất!";
                lblErrorMessage.Visible = true;
                return;
            }

            // Export to PDF
            using (MemoryStream stream = new MemoryStream())
            {
                Document pdfDoc = new Document(PageSize.A4, 10f, 10f, 20f, 10f);
                PdfWriter writer = PdfWriter.GetInstance(pdfDoc, stream);
                pdfDoc.Open();

                // Add title
                pdfDoc.Add(new Paragraph("Báo Cáo Đơn Hàng", FontFactory.GetFont("Arial", 20, Font.BOLD)));

                // Create PDF table and populate it
                PdfPTable pdfTable = new PdfPTable(dt.Columns.Count);
                pdfTable.WidthPercentage = 100;

                // Add headers
                foreach (DataColumn column in dt.Columns)
                {
                    pdfTable.AddCell(new Phrase(column.ColumnName, FontFactory.GetFont("Arial", 12, Font.BOLD)));
                }

                // Add rows
                foreach (DataRow row in dt.Rows)
                {
                    foreach (var cell in row.ItemArray)
                    {
                        pdfTable.AddCell(new Phrase(cell.ToString(), FontFactory.GetFont("Arial", 10)));
                    }
                }

                pdfDoc.Add(pdfTable);
                pdfDoc.Close();

                // Download PDF
                var fileName = "BaoCaoDonHang.pdf";
                Response.ContentType = "application/pdf";
                Response.AddHeader("content-disposition", $"attachment; filename={fileName}");
                Response.BinaryWrite(stream.ToArray());
                Response.End();
            }
        }

        private DataTable CreateDataTableFromGridView()
        {
            DataTable dt = new DataTable();

            // Create columns based on GridView headers
            foreach (DataControlField column in GridViewOrders.Columns)
            {
                dt.Columns.Add(column.HeaderText);
            }

            // Populate rows by iterating through GridView rows
            foreach (GridViewRow row in GridViewOrders.Rows)
            {
                DataRow dr = dt.NewRow();
                for (int i = 0; i < row.Cells.Count; i++)
                {
                    string cellText = row.Cells[i].Text.Trim();

                    // Replace &nbsp; with an empty string and decode HTML entities
                    if (cellText == "&nbsp;")
                    {
                        cellText = "";
                    }
                    else
                    {
                        cellText = HttpUtility.HtmlDecode(cellText);
                    }

                    dr[i] = cellText;
                }
                dt.Rows.Add(dr);
            }

            return dt;
        }

    }
}