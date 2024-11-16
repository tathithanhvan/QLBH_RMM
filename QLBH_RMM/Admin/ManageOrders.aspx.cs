using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QLBH_RMM.Admin
{
    public partial class ManageOrders : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
            //    // Initialize ViewState or any other necessary setup
            //    ViewState["SearchValue"] = string.Empty;
            //    ViewState["StartDate"] = string.Empty;
            //    ViewState["EndDate"] = string.Empty;
            //}
            //else
            //{
            //    // Restore previous search and filter values
            //    searchOrderID.Text = ViewState["SearchValue"].ToString();
            //    startDate.Text = ViewState["StartDate"].ToString();
            //    endDate.Text = ViewState["EndDate"].ToString();
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchValue = searchOrderID.Text.Trim();
            //ViewState["SearchValue"] = searchValue; // Store search value in ViewState

            // Check if searchValue is not empty
            if (!string.IsNullOrEmpty(searchValue))
            {
                SqlDataSource1.SelectCommand = @"
                    SELECT 
                        [MaHD], 
                        [NgayMua], 
                        [TriGiaHD], 
                        [TinhTrang], 
                        [TenNN], 
                        [SDTNN], 
                        [DiaChiNN], 
                        [HinhThucThanhToan], 
                        [MaNV], 
                        [MaKH], 
                        [MaKM], 
                        [SoTienGiam] 
                    FROM 
                        [HoaDon] 
                    WHERE 
                        [MaHD] LIKE @SearchValue OR 
                        [MaNV] LIKE @SearchValue OR 
                        [MaKH] LIKE @SearchValue OR 
                        [MaKM] LIKE @SearchValue OR 
                        [TriGiaHD] LIKE @SearchValue OR 
                        [NgayMua] LIKE @SearchValue OR 
                        [TinhTrang] LIKE @SearchValue OR 
                        [TenNN] LIKE @SearchValue OR 
                        [SDTNN] LIKE @SearchValue OR 
                        [DiaChiNN] LIKE @SearchValue OR 
                        [HinhThucThanhToan] LIKE @SearchValue OR 
                        [SoTienGiam] LIKE @SearchValue 
                    ORDER BY 
                        [NgayMua] DESC";

                SqlDataSource1.SelectParameters.Clear(); // Clear old parameters
                SqlDataSource1.SelectParameters.Add("SearchValue", "%" + searchValue + "%"); // Add new parameter
                GridViewOrders.DataBind(); // Update GridView
            }
            else
            {
                // Handle empty search scenario (optional)
                // You could display a message to the user if needed
            }
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            string startDateText = startDate.Text;
            string endDateText = endDate.Text;

            //ViewState["StartDate"] = startDateText; // Store start date in ViewState
            //ViewState["EndDate"] = endDateText; // Store end date in ViewState

            // Validate the date inputs
            if (DateTime.TryParse(startDateText, out DateTime parsedStartDate) && DateTime.TryParse(endDateText, out DateTime parsedEndDate))
            {
                SqlDataSource1.SelectCommand = @"
                    SELECT 
                        [MaHD], 
                        [NgayMua], 
                        [TriGiaHD], 
                        [TinhTrang], 
                        [TenNN], 
                        [SDTNN], 
                        [DiaChiNN], 
                        [HinhThucThanhToan], 
                        [MaNV], 
                        [MaKH], 
                        [MaKM], 
                        [SoTienGiam] 
                    FROM 
                        [HoaDon] 
                    WHERE 
                        [NgayMua] BETWEEN @StartDate AND @EndDate 
                    ORDER BY 
                        [NgayMua] DESC";

                SqlDataSource1.SelectParameters.Clear(); // Clear old parameters
                SqlDataSource1.SelectParameters.Add("StartDate", parsedStartDate.ToString("yyyy-MM-dd")); // Add new parameter
                SqlDataSource1.SelectParameters.Add("EndDate", parsedEndDate.ToString("yyyy-MM-dd")); // Add new parameter
                GridViewOrders.DataBind(); // Update GridView
            }
            else
            {
                // Handle invalid date input (optional)
                // You could display a message to the user if needed
            }
        }

        //protected void GridViewOrders_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    // Get the selected row
        //    GridViewRow selectedRow = GridViewOrders.SelectedRow;

        //    // Retrieve the order ID from the selected row
        //    string orderId = selectedRow.Cells[1].Text; // Adjust the index based on where MaHD is located

        //    // Fetch order details from the database
        //    DisplayOrderDetails(orderId);
        //}

        //private void DisplayOrderDetails(string orderId)
        //{
        //    string connectionString = "Data Source=TRIPLETANDV;Initial Catalog=QuanLyBanHang;Integrated Security=True";
        //    string query = "SELECT * FROM [HoaDon] WHERE [MaHD] = @OrderId";

        //    using (SqlConnection conn = new SqlConnection(connectionString))
        //    {
        //        using (SqlCommand cmd = new SqlCommand(query, conn))
        //        {
        //            cmd.Parameters.AddWithValue("@OrderId", orderId);
        //            conn.Open();
        //            SqlDataReader reader = cmd.ExecuteReader();

        //            if (reader.Read())
        //            {
        //                // Assuming you have fields like NgayMua, TriGiaHD, etc.
        //                string orderDetails = $"Mã HD: {reader["MaHD"]}<br/>" +
        //                                      $"Ngày Mua: {reader["NgayMua"]}<br/>" +
        //                                      $"Trị Giá HD: {reader["TriGiaHD"]}<br/>" +
        //                                      $"Tình Trạng: {reader["TinhTrang"]}<br/>" +
        //                                      $"Tên Người Nhận: {reader["TenNN"]}<br/>" +
        //                                      $"Địa Chỉ: {reader["DiaChiNN"]}<br/>" +
        //                                      $"SDT: {reader["SDTNN"]}<br/>";

        //                LabelOrderDetails.Text = orderDetails;
        //                PanelOrderDetails.Visible = true; // Show the details panel
        //            }
        //            else
        //            {
        //                LabelOrderDetails.Text = "Không tìm thấy thông tin đơn hàng.";
        //                PanelOrderDetails.Visible = true; // Show the details panel even if no data found
        //            }
        //        }
        //    }
        //}

    }
}
