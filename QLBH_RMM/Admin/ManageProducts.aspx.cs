using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QLBH_RMM.Admin
{
    public partial class ManageProducts : Page
    {
        private SqlConnection GetDatabaseConnection()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["QuanLyBanHang_SP_ConnectionString"].ConnectionString;
            return new SqlConnection(connectionString);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadProducts();
                LoadSizes();
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchTerm = txtSearch.Text.Trim();
            LoadProducts(searchTerm);
        }

        protected void btnAddProduct_Click(object sender, EventArgs e)
        {
            Response.Redirect("AddProduct.aspx");
        }

        protected void btnSelect_Click(object sender, EventArgs e)
        {
            // Get the button that was clicked
            Button btn = (Button)sender;

            // Get the GridViewRow that contains the button
            GridViewRow row = (GridViewRow)btn.NamingContainer;

            // Retrieve the product ID and size from the GridView
            string productId = gvProducts.DataKeys[row.RowIndex].Value.ToString();
            string maSize = ((HiddenField)row.FindControl("hfMaSize")).Value; // Get the MaSize from the hidden field

            // Load the product details using the retrieved values
            LoadProductDetails(productId, maSize);
        }

        private void LoadSizes()
        {
            using (var connection = GetDatabaseConnection())
            {
                connection.Open();
                string query = "SELECT MaSize, TenSize FROM Size";
                using (SqlCommand cmd = new SqlCommand(query, connection))
                {
                    SqlDataReader reader = cmd.ExecuteReader();
                    ddlSize.Items.Clear(); // Clear existing items
                    while (reader.Read())
                    {
                        ddlSize.Items.Add(new ListItem(reader["TenSize"].ToString(), reader["MaSize"].ToString()));
                    }
                }
            }
        }

        private void LoadProducts(string searchTerm = "")
        {
            using (var connection = GetDatabaseConnection())
            {
                connection.Open();
                string query = "SELECT sp.MaSP, sp.TenSP, ss.DonGia, s.TenSize, s.MaSize, sp.TinhTrang, Img " +
                               "FROM SanPham sp " +
                               "JOIN SanPham_Size ss ON sp.MaSP = ss.MaSP " +
                               "JOIN Size s ON s.MaSize = ss.MaSize " +
                               "WHERE sp.TenSP LIKE '%' + @searchTerm + '%'";
                using (SqlCommand cmd = new SqlCommand(query, connection))
                {
                    cmd.Parameters.Add("@searchTerm", SqlDbType.NVarChar).Value = searchTerm;
                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);
                        gvProducts.DataSource = dt;
                        gvProducts.DataBind();
                    }
                }
            }
        }

        protected void gvProducts_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridViewRow row = gvProducts.SelectedRow;
            string productId = gvProducts.DataKeys[row.RowIndex].Value.ToString();
            string maSize = ((HiddenField)row.FindControl("hfMaSize")).Value; // Get the MaSize from the hidden field
            LoadProductDetails(productId, maSize);
        }

        private void LoadProductDetails(string productId, string maSize)
        {
            using (var connection = GetDatabaseConnection())
            {
                connection.Open();
                string query = "SELECT sp.MaSP, sp.TenSP, ss.DonGia, s.TenSize, sp.TinhTrang, sp.MoTa, sp.Img " +
                               "FROM SanPham sp " +
                               "JOIN SanPham_Size ss ON sp.MaSP = ss.MaSP " +
                               "JOIN Size s ON s.MaSize = ss.MaSize " +
                               "WHERE sp.MaSP = @MaSP AND s.MaSize = @MaSize"; // Filter by MaSize
                using (SqlCommand cmd = new SqlCommand(query, connection))
                {
                    cmd.Parameters.Add("@MaSP", SqlDbType.VarChar).Value = productId;
                    cmd.Parameters.Add("@MaSize", SqlDbType.VarChar).Value = maSize; // Add MaSize parameter
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            txtProductId.Text = reader["MaSP"].ToString();
                            txtProductName.Text = reader["TenSP"].ToString();
                            txtProductPrice.Text = reader["DonGia"].ToString();
                            txtProductDescription.Text = reader["MoTa"] != DBNull.Value ? reader["MoTa"].ToString() : string.Empty;

                            // Load the status dropdown
                            if (reader["TinhTrang"] != DBNull.Value)
                            {
                                ddlStatus.SelectedValue = reader["TinhTrang"].ToString();
                            }

                            // Set the selected size
                            ddlSize.SelectedValue = maSize; // Set the selected size based on the passed parameter

                            // Store the current image path for later use
                            string imagePath = reader["Img"] != DBNull.Value ? reader["Img"].ToString() : string.Empty;
                            ViewState["CurrentImage"] = imagePath;

                            // Display the image in an Image control
                            if (!string.IsNullOrEmpty(imagePath))
                            {
                                imgProductImage.ImageUrl = ResolveUrl(imagePath);
                            }
                        }
                    }
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string productId = txtProductId.Text;

            // Validate inputs
            if (string.IsNullOrEmpty(txtProductName.Text) || string.IsNullOrEmpty(txtProductPrice.Text))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", "alert('Tên sản phẩm và đơn giá là bắt buộc!');", true);
                return;
            }

            string imagePath = string.Empty;
            if (fuProductImage.HasFile)
            {
                // Validate file type and size
                if (fuProductImage.PostedFile.ContentLength > 1048576) // 1MB limit
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "showalert", "alert('Kích thước tệp không được vượt quá 1MB!');", true);
                    return;
                }

                string fileExtension = Path.GetExtension(fuProductImage.FileName).ToLower();
                if (fileExtension != ".jpg" && fileExtension != ".png" && fileExtension != ".jpeg")
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "showalert", "alert('Chỉ cho phép tệp .jpg, .png, hoặc .jpeg!');", true);
                    return;
                }

                // Save the uploaded file and get the path
                string fileName = Path.GetFileName(fuProductImage.FileName);
                imagePath = "~/Images/" + fileName; // Adjust the path as necessary
                fuProductImage.SaveAs(Server.MapPath(imagePath)); // Save the file
            }
            else
            {
                // If no new file is uploaded, retain the existing image path
                imagePath = ViewState["CurrentImage"] != null ? ViewState["CurrentImage"].ToString() : string.Empty;
            }

            using (var connection = GetDatabaseConnection())
            {
                connection.Open();

                // Update the SanPham table
                string updateProductQuery = "UPDATE SanPham SET TenSP = @TenSP, MoTa = @MoTa, Img = @Img, TinhTrang = @TinhTrang WHERE MaSP = @MaSP";
                using (SqlCommand productCmd = new SqlCommand(updateProductQuery, connection))
                {
                    productCmd.Parameters.Add("@TenSP", SqlDbType.NVarChar).Value = txtProductName.Text;
                    productCmd.Parameters.Add("@MoTa", SqlDbType.NVarChar).Value = txtProductDescription.Text;
                    productCmd.Parameters.Add("@Img", SqlDbType.NVarChar).Value = imagePath;
                    productCmd.Parameters.Add("@TinhTrang", SqlDbType.Int).Value = int.Parse(ddlStatus.SelectedValue);
                    productCmd.Parameters.Add("@MaSP", SqlDbType.VarChar).Value = productId;
                    productCmd.ExecuteNonQuery();
                }

                // Update the DonGia in SanPham_Size table for the selected size
                string selectedSize = ddlSize.SelectedValue; // Get the selected size
                string updateSizeQuery = "UPDATE SanPham_Size SET DonGia = @DonGia WHERE MaSP = @MaSP AND MaSize = @MaSize";
                using (SqlCommand sizeCmd = new SqlCommand(updateSizeQuery, connection))
                {
                    sizeCmd.Parameters.Add("@DonGia", SqlDbType.Decimal).Value = decimal.Parse(txtProductPrice.Text);
                    sizeCmd.Parameters.Add("@MaSP", SqlDbType.VarChar).Value = productId;
                    sizeCmd.Parameters.Add("@MaSize", SqlDbType.VarChar).Value = selectedSize; // Use the selected size for the update
                    sizeCmd.ExecuteNonQuery();
                }
                LoadProducts();
                ClearProductDetails();
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ClearProductDetails();
        }

        private void ClearProductDetails()
        {
            txtProductId.Text = string.Empty;
            txtProductName.Text = string.Empty;
            txtProductPrice.Text = string.Empty;
            txtProductDescription.Text = string.Empty;
            fuProductImage.Attributes.Clear(); // Clear file upload control
            ddlStatus.SelectedIndex = 0; // Reset dropdown
            imgProductImage.ImageUrl = string.Empty; // Clear the displayed image
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            string productId = txtProductId.Text; 
            bool deletionSuccessful = false; 

            using (var connection = GetDatabaseConnection())
            {
                connection.Open();
                using (var transaction = connection.BeginTransaction())
                {
                    try
                    {
                        // Delete related records in SanPham_Size
                        string deleteSizeQuery = "DELETE FROM SanPham_Size WHERE MaSP = @productId";
                        using (SqlCommand sizeCmd = new SqlCommand(deleteSizeQuery, connection, transaction))
                        {
                            sizeCmd.Parameters.Add("@productId", SqlDbType.VarChar).Value = productId;
                            sizeCmd.ExecuteNonQuery();
                        }

                        // Delete the product
                        string deleteProductQuery = "DELETE FROM SanPham WHERE MaSP = @productId";
                        using (SqlCommand productCmd = new SqlCommand(deleteProductQuery, connection, transaction))
                        {
                            productCmd.Parameters.Add("@productId", SqlDbType.VarChar).Value = productId;
                            int rowsAffected = productCmd.ExecuteNonQuery();

                            if (rowsAffected > 0)
                            {
                                deletionSuccessful = true; // Deletion successful
                            }
                        }

                        transaction.Commit();
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                    }
                }
            }

            // Display success or error message
            if (deletionSuccessful)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Sản phẩm đã được xóa thành công!');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Lỗi: Không thể xóa sản phẩm!');", true);
            }
            LoadProducts();
        }
    }
}
