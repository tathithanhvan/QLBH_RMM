<%@ Page Title="Chi Tiết Sản Phẩm" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="ChiTietSanPham.aspx.cs" Inherits="QLBH_RMM.ChiTietSanPham" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5fff3;
            margin: 0;
            padding: 0;
        }

        .product-detail {
            display: flex;
            max-width: 1200px;
            margin: 0 auto;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-top: 100px;
            gap: 5px; /* Thêm khoảng cách giữa hình ảnh và thông tin sản phẩm */
        }

        .product-image {
            flex: 1.8; /* Tăng kích thước cho phần hình ảnh */
            padding-right: 5px;
        }

        .product-image img {
            width: 100%;
            border-radius: 8px;
        }

        .product-info {
            flex: 2.5; /* Tăng kích thước cho phần thông tin sản phẩm */
        }

        .product-info h2 {
            font-size: 26px; /* Tăng kích thước chữ tiêu đề */
            color: #0A6847;
            margin-bottom: 10px; /* Thêm khoảng cách dưới tiêu đề */
        }

        .product-info .price {
            font-size: 22px; /* Tăng kích thước chữ giá */
            color: #e74c3c;
            font-weight: bold;
            margin: 10px 0;
        }

        .product-info .description {
            font-size: 16px;
            color: #333;
            margin-bottom: 20px;
            line-height: 1.5; /* Tăng khoảng cách giữa các dòng */
        }

        .quantity-container {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }

        .quantity-input {
            width: 60px;
            padding: 5px;
            margin-left: 10px;
            margin-right: 10px;
        }

        .add-to-cart {
            background-color: #0A6847;
            color: #fff;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s ease; /* Thêm hiệu ứng chuyển đổi */
        }

        .add-to-cart:hover {
            background-color: #00796b;
        }

        .note-label {
            font-size: 16px;
            margin-bottom: 5px;
            display: inline; /* Thay đổi từ block sang inline */
            color: #0A6847;
        }

        .size-label {
            font-size: 16px; /* Cập nhật kiểu chữ cho kích cỡ */
            margin-left: 10px; /* Khoảng cách giữa label và giá trị kích cỡ */
        }

        .checkbox-container {
            display: flex; /* Sắp xếp theo hàng */
            justify-content: space-between; /* Khoảng cách giữa các cột */
            margin-bottom: 5px; /* Khoảng cách dưới phần topping và ghi chú */
        }

        .note-checkboxes {
            display: flex;
            flex-direction: column; /* Sắp xếp theo chiều dọc */
            flex: 1; /* Mỗi cột chiếm 1/2 chiều rộng */
        }

        .note-checkboxes label {
            margin-right: 10px; /* Khoảng cách giữa các checkbox */
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="product-detail">
        <div class="product-image">
            <asp:Image ID="ProductImage" runat="server" />
        </div>
        <div class="product-info">
            <h2><asp:Label ID="TenSPLabel" runat="server" /></h2>
            <div class="price">Giá: <asp:Label ID="DonGiaLabel" runat="server" /></div>

            <!-- Hiển thị kích cỡ -->
            <label class="note-label">Kích cỡ:</label>
            <span class="size-label"><asp:Label ID="SizeLabel" runat="server" /></span>

            <!-- Mô tả sản phẩm nằm ở dưới nút thêm sản phẩm -->
            <div class="description" style="margin-top: 20px;">
                <asp:Label ID="MoTaLabel" runat="server" />
            </div>

            <!-- Topping và Ghi chú -->
            <div class="checkbox-container">
                <!-- Topping -->
                <div class="note-checkboxes">
                    <label class="note-label">Thêm Topping:</label>
                    <asp:CheckBoxList ID="ToppingCheckBoxList" runat="server" RepeatColumns="1" Width="250px">
                        <asp:ListItem Value="TP001">Khúc bạch Trứng tươi</asp:ListItem>
                        <asp:ListItem Value="TP002">Sương Sáo Hạt Chia</asp:ListItem>
                        <asp:ListItem Value="TP003">Thạch Củ Năng</asp:ListItem>
                        <asp:ListItem Value="TP004">Thạch Lá Dứa</asp:ListItem>
                        <asp:ListItem Value="TP005">Trân Châu Lá Dứa</asp:ListItem>
                        <asp:ListItem Value="TP006">Trân Châu Tuyết Trắng</asp:ListItem>
                        <asp:ListItem Value="TP007">Thạch Nha Đam</asp:ListItem>
                    </asp:CheckBoxList>
                </div>

                <!-- Ghi chú -->
                <div class="note-checkboxes">
                    <label class="note-label">Ghi chú:</label>
                    <asp:CheckBoxList ID="NoteCheckBoxList" runat="server" RepeatColumns="1" Width="250px">
                        <asp:ListItem Value="1">Không Đá</asp:ListItem>
                        <asp:ListItem Value="2">50% Đá</asp:ListItem>
                        <asp:ListItem Value="3">0% Ngọt</asp:ListItem>
                        <asp:ListItem Value="4">50% Ngọt</asp:ListItem>
                        <asp:ListItem Value="5">Túi Đá Riêng</asp:ListItem>
                        <asp:ListItem Value="6">Không sữa dừa</asp:ListItem>
                        <asp:ListItem Value="7">Không Macca</asp:ListItem>
                        <asp:ListItem Value="8">Không Hạnh Nhân</asp:ListItem>
                    </asp:CheckBoxList>
                </div>
            </div>

            <!-- Chọn số lượng -->
            <div class="quantity-container">
                <label class="note-label">Số lượng:</label>
                <input type="number" class="quantity-input" min="1" value="1" id="quantityInput" runat="server" />
            </div>

            <button class="add-to-cart" runat="server" onserverclick="AddToCart_Click">Thêm vào giỏ hàng</button>
        </div>
    </div>
</asp:Content>
