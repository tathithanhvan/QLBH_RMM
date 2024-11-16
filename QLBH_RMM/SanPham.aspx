<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="SanPham.aspx.cs" Inherits="QLBH_RMM.SanPham" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5fff3;
            margin: 0;
            padding: 0;
        }

        .category-nav {
            background-color: #ffffff;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
            margin-top: 100px;
        }

        .category-list {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 15px;
        }

        .category-item {
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 10px 15px;
            text-align: center;
            transition: background-color 0.3s, transform 0.3s;
            cursor: pointer;
        }

        .category-label {
            font-size: 16px; /* Kích thước chữ */
            color: #333; /* Màu chữ */
            text-align: center; /* Căn giữa */
            display: block; /* Để tự động căn giữa */
        }

        .category-item:hover {
            background-color: #e9f5e9;
            transform: scale(1.05);
        }

        .section-title {
            font-size: 26px;
            font-weight: bold;
            color: #0A6847;
            text-align: center;
            margin-bottom: 30px;
        }

        .product-card {
            width: 220px;
            border: 1px solid #ddd;
            padding: 15px;
            margin-bottom: 20px;
            text-align: center;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            min-height: 250px;
        }

        .product-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
        }

        .product-card img {
            width: 150px;
            height: 150px;
            margin: 0 auto 10px;
            display: block;
        }

        .product-card h3 {
            font-size: 18px;
            margin-top: 15px;
            margin-bottom: 10px;
            color: #0A6847;
            text-overflow: ellipsis;
        }

        .product-card p {
            font-size: 14px;
            color: #333;
            margin-bottom: 10px;

        }

        .product-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 20px;
            justify-content: center;
        }

        .product-item {
            display: flex;
            justify-content: center;
        }

        .product-info {
            margin-top: 10px;
            font-size: 14px;
        }

        .product-price {
            color: #e74c3c;
            font-size: 16px;
            font-weight: bold;
        }

        .selected {
            background-color: #e0f7fa; /* Màu nền khi được chọn */
            color: #00796b; /* Màu chữ khi được chọn */
            font-weight: bold; /* Chữ đậm khi được chọn */
        }

        .auto-style1 {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 20px;
            justify-content: center;
            text-align: center;
        }

        .auto-style2 {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 15px;
            text-align: center;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <!-- Nguồn dữ liệu cho LoaiSP -->
    <asp:SqlDataSource ID="srcLoaiSP" runat="server" 
        ConnectionString="<%$ ConnectionStrings:QuanLyBanHang_SP_ConnectionString %>" 
        SelectCommand="SELECT * FROM LoaiSP WHERE MaLoai <> 'GC'">
    </asp:SqlDataSource>

    <!-- Danh sách loại sản phẩm -->
    <div class="category-nav">
        <div class="section-title">Chọn loại sản phẩm:</div>
        <div class="auto-style2">
            <asp:DataList ID="DataList1" runat="server" DataSourceID="srcLoaiSP" 
                RepeatDirection="Horizontal" OnItemCommand="DataList1_ItemCommand">
                <ItemTemplate>
                    <div class='<%# Eval("MaLoai").ToString() == selectedMaLoai ? "category-item selected" : "category-item" %>'>
                        <asp:ImageButton ID="CategoryImageButton" runat="server" 
                            Height="100px" 
                            ImageUrl='<%# Eval("Img") %>' 
                            Width="100px" 
                            CommandName="ChonLoai" 
                            CommandArgument='<%# Eval("MaLoai") %>' />
                        <br />
                        <asp:Label ID="Label1" runat="server" CssClass="category-label" Text='<%# Eval("TenLoai") %>'></asp:Label>
                    </div>
                </ItemTemplate>
            </asp:DataList>
        </div>
    </div>

    <br />

    <!-- Nguồn dữ liệu cho SanPham -->
    <asp:SqlDataSource ID="srcSanPham" runat="server" 
        ConnectionString="<%$ ConnectionStrings:QuanLyBanHang_SP_ConnectionString %>" 
        SelectCommand="SELECT SP.MaSP, SP.TenSP, Img, DonGia, S.TenSize, SS.MaSize
                       FROM SanPham SP
                       LEFT JOIN SanPham_Size SS ON SP.MaSP = SS.MaSP
                       LEFT JOIN Size S ON S.MaSize = SS.MaSize
                       WHERE (@MaLoai = '0' OR SP.MaLoai = @MaLoai) and SP.TinhTrang = 1">
        <SelectParameters>
            <asp:Parameter Name="MaLoai" Type="String" DefaultValue="0" />
        </SelectParameters>
    </asp:SqlDataSource>

    <div class="auto-style1">
        <asp:DataList ID="DataList2" runat="server" DataSourceID="srcSanPham" 
            RepeatColumns="5" RepeatDirection="Horizontal" CellSpacing="30">
            <ItemTemplate>
                <div class="product-item">
                    <div class="product-card">
                        <asp:HyperLink ID="ProductLink" runat="server" 
                            NavigateUrl='<%# "ChiTietSanPham.aspx?MaSP=" + Eval("MaSP") + "&MaSize=" + Eval("MaSize") %>'>
                            <asp:Image ID="ProductImage" runat="server" CssClass="product img" 
                                ImageUrl='<%# Eval("Img") %>' />
                        </asp:HyperLink>
                        <div class="product-info">
                            <strong>&nbsp;<asp:Label ID="TenSPLabel" runat="server" 
                                Text='<%# Eval("TenSP") %>' /></strong>
                            <br />
                            <span class="product-price">Giá: <asp:Label ID="DonGiaLabel" runat="server" 
                                Text='<%#Eval("DonGia","{0:0,000}") %>' /></span>
                            <br />
                            <strong>Kích thước:</strong> <asp:Label ID="TenSizeLabel" runat="server" 
                                Text='<%# Eval("TenSize") %>' />
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:DataList>
    </div>

</asp:Content>
