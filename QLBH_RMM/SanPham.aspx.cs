using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QLBH_RMM
{
    public partial class SanPham : System.Web.UI.Page
    {
        protected string selectedMaLoai;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string maLoai = Request.QueryString["MaLoai"];
                string searchQuery = Request.QueryString["search"]; // Get the search parameter

                // Initialize selectedMaLoai
                selectedMaLoai = string.IsNullOrEmpty(maLoai) ? "0" : maLoai;

                // Load all products by default if there's no search query or specific category
                LoadProductsByCategory(selectedMaLoai, searchQuery);
            }
        }

        protected void DataList1_ItemCommand(object source, DataListCommandEventArgs e)
        {
            if (e.CommandName == "ChonLoai")
            {
                selectedMaLoai = e.CommandArgument.ToString();
                DataList1.DataBind();
                LoadProductsByCategory(selectedMaLoai, null); // Re-load products for the selected category
            }
        }

        private void LoadProductsByCategory(string maLoai, string searchQuery)
        {
            // Set the SQL command to load products based on category
            srcSanPham.SelectCommand = "SELECT SP.MaSP, SP.TenSP, Img, DonGia, S.TenSize, SS.MaSize " +
                                        "FROM SanPham SP " +
                                        "LEFT JOIN SanPham_Size SS ON SP.MaSP = SS.MaSP " +
                                        "LEFT JOIN Size S ON S.MaSize = SS.MaSize " +
                                        "WHERE (@MaLoai = '0' OR SP.MaLoai = @MaLoai) and SP.TinhTrang = 1"; // Display all if MaLoai = '0'

            // Set the parameters
            srcSanPham.SelectParameters.Clear();
            srcSanPham.SelectParameters.Add("MaLoai", maLoai); // Maintain the selected category

            // If a search query exists, modify the SQL command to include it
            if (!string.IsNullOrEmpty(searchQuery))
            {
                srcSanPham.SelectCommand += " AND (SP.TenSP LIKE @SearchTerm)";
                srcSanPham.SelectParameters.Add("SearchTerm", "%" + searchQuery + "%");
            }

            DataList2.DataBind(); // Cập nhật lại DataList2 để hiển thị sản phẩm
        }
    }
}
