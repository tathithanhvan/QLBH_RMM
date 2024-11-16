<%@ Page Title="Quản Lý Sản Phẩm" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageProducts.aspx.cs" Inherits="QLBH_RMM.Admin.ManageProducts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .product-management {
            display: flex;
            margin-top: 50px;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .product-list {
            flex: 1;
            margin-right: 20px;
            padding: 15px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            background-color: #f9f9f9;
            overflow-y: auto;
            max-height: 600px;
        }

        .product-detail {
            flex: 0 0 700px;
            padding: 15px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            background-color: #f9f9f9;
            position: sticky;
            top: 20px;
            height: calc(100vh - 100px);
            overflow-y: auto;
        }

        .product-management h2 {
            color: #0A6847;
            text-align: center;
            margin-bottom: 20px;
        }

        .search-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .input {
            flex: 2;
            padding: 10px;
            border: 1px solid #e0e0e0;
            border-radius: 4px;
            font-size: 14px;
        }

        .btn {
            padding: 10px 15px;
            background-color: #0A6847;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
            font-size: 14px;
        }

        .btn:hover {
            background-color: #007B5F;
        }

        .product-grid {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        th, td {
            padding: 10px;
            border: 1px solid #e0e0e0;
            text-align: center;
        }

        th {
            background-color: #f9f9f9;
        }

        .product-image {
            width: 80px;
            height: auto;
            border-radius: 4px;
        }

        .button-container {
            text-align: center;
            margin-top: 20px;
        }

        .detail-title {
            font-size: 14px;
            margin-bottom: 5px;
            color: #0A6847;
        }

        .detail-input {
            width: calc(100% - 20px);
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #e0e0e0;
            border-radius: 4px;
        }

        .detail-button {
            width: 100%;
            padding: 10px;
            background-color: #0A6847;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .detail-button:hover {
            background-color: #007B5F;
        }

        .image-container {
            text-align: center;
            margin: 10px 0;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="product-management">
        <div class="product-list">
            <h2>Danh Sách Sản Phẩm</h2>
            <div class="search-container">
                <asp:TextBox ID="txtSearch" runat="server" CssClass="input" placeholder="Tìm kiếm sản phẩm..."></asp:TextBox>
                <asp:Button ID="btnSearch" runat="server" Text="Tìm kiếm" CssClass="btn" OnClick="btnSearch_Click" />
            </div>
           <asp:GridView ID="gvProducts" runat="server" AutoGenerateColumns="False" CssClass="product-grid" DataKeyNames="MaSP" 
              OnSelectedIndexChanged="gvProducts_SelectedIndexChanged">
            <Columns>
                <asp:BoundField DataField="TenSP" HeaderText="Tên Sản Phẩm" />
                <asp:BoundField DataField="TenSize" HeaderText="Kích Cỡ" />
                <asp:BoundField DataField="DonGia" HeaderText="Đơn Giá" DataFormatString="{0:N0} VNĐ" />
                <asp:TemplateField HeaderText="Hình ảnh sản phẩm">
                    <ItemTemplate>
                        <asp:Image ID="Image1" runat="server" CssClass="product-image" ImageUrl='<%# Eval("Img") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Tình Trạng">
                    <ItemTemplate>
                        <asp:Label ID="lblStatus" runat="server" 
                            Text='<%# Convert.ToBoolean(Eval("TinhTrang")) ? "Đang hoạt động" : "Không hoạt động" %>'>
                        </asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Hành Động">
                    <ItemTemplate>
                        <asp:HiddenField ID="hfMaSize" runat="server" Value='<%# Eval("MaSize") %>' />
                        <asp:Button ID="btnSelect" runat="server" CommandName="Select" CommandArgument='<%# Eval("MaSP") %>' Text="Xem" CssClass="btn" OnClick="btnSelect_Click" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>


        </div>

        <div class="product-detail">
            <h2>Chi Tiết Sản Phẩm</h2>
            <asp:Label ID="lblProductId" runat="server" Text="Mã Sản Phẩm:" CssClass="detail-title"></asp:Label>
            <asp:TextBox ID="txtProductId" runat="server" CssClass="detail-input" ReadOnly="true"></asp:TextBox>
            <asp:Label ID="lblProductName" runat="server" Text="Tên Sản Phẩm:" CssClass="detail-title"></asp:Label>
            <asp:TextBox ID="txtProductName" runat="server" CssClass="detail-input"></asp:TextBox>
            <asp:Label ID="lblProductSize" runat="server" Text="Kích cỡ:" CssClass="detail-title"></asp:Label>
            <asp:DropDownList ID="ddlSize" runat="server" CssClass="detail-input"></asp:DropDownList>
            <asp:Label ID="lblProductPrice" runat="server" Text="Đơn Giá:" CssClass="detail-title"></asp:Label>
            <asp:TextBox ID="txtProductPrice" runat="server" CssClass="detail-input"></asp:TextBox>
            <asp:Label ID="lblProductDescription" runat="server" Text="Mô Tả:" CssClass="detail-title"></asp:Label>
            <asp:TextBox ID="txtProductDescription" runat="server" CssClass="detail-input" TextMode="MultiLine" Rows="3"></asp:TextBox>
            <asp:Label ID="lblProductImage" runat="server" Text="Hình Ảnh:" CssClass="detail-title"></asp:Label>
            <div class="image-container">
                <asp:Image ID="imgProductImage" runat="server" CssClass="product-image" />
                <br />
                <asp:FileUpload ID="fuProductImage" runat="server" CssClass="input" />
            </div>
            <asp:Label ID="lblStatus" runat="server" Text="Tình Trạng:" CssClass="detail-title"></asp:Label>
            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="input">
                <asp:ListItem Text="Chọn tình trạng" Value=""></asp:ListItem>
                <asp:ListItem Text="Đang hoạt động" Value="1"></asp:ListItem>
                <asp:ListItem Text="Không hoạt động" Value="0"></asp:ListItem>
            </asp:DropDownList>
            <div class="button-container">               
                <asp:Button ID="btnAdd" runat="server" Text="Thêm mới" CssClass="btn" OnClick="btnAddProduct_Click" />
                <asp:Button ID="btnSave" runat="server" Text="Lưu" CssClass="btn" OnClick="btnSave_Click" />
                <asp:Button ID="btnDelete" runat="server" Text="Xóa" OnClientClick="return confirmDelete();" OnClick="btnDelete_Click" CssClass="btn" />
                <asp:Button ID="btnCancel" runat="server" Text="Hủy" CssClass="btn" OnClick="btnCancel_Click" />
            </div>
        </div>
    </div>
    <script type="text/javascript">
    function confirmDelete() {
        return confirm("Bạn có chắc chắn muốn xóa sản phẩm này?");
    }
    </script>

</asp:Content>
