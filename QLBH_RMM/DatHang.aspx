<%@ Page Title="Đặt Hàng" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="DatHang.aspx.cs" Inherits="QLBH_RMM.DatHang" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5; 
            margin: 0;
            padding: 0;
        }

        .container {
            display: flex;
            max-width: 1200px;
            margin: 20px auto;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            margin-top: 100px;
        }

        .payment-info {
            flex: 1;
            padding: 20px;
            border-right: 1px solid #e0e0e0;
            overflow-y: auto; /* Cho phép cuộn nếu nội dung quá dài */
            height: calc(100vh - 200px); /* Chiều cao cố định cho phần thanh toán */
        }

        .shipping-info {
            width: 400px; /* Cố định chiều rộng */
            padding: 20px;
            position: sticky; /* Giữ cố định trên màn hình */
            top: 20px; /* Đặt ở vị trí trên cùng */
            height: calc(100vh - 100px); /* Chiều cao cố định */
            overflow-y: auto; /* Cuộn nếu nội dung quá dài */
            background-color: #fff;
        }

        .box-header {
            border-bottom: 2px solid #0A6847; 
            padding-bottom: 10px;
            margin-bottom: 20px;
        }

        .box-header h2 {
            color: #0A6847;
            font-size: 28px;
            margin: 0;
            text-align: left; 
        }

        .box-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border: 1px solid #e0e0e0;
            padding: 15px;
            border-radius: 8px;
            background-color: #f9f9f9;
            transition: box-shadow 0.3s ease;
            margin-bottom: 10px;
        }

        .box-item:hover {
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
        }

        .box-item h3 {
            color: #0A6847;
            margin: 0;
            font-size: 20px;
            text-align: left; 
        }

        .box-item p {
            margin: 5px 0;
            font-size: 14px;
            color: #555; 
            text-align: left; 
        }

        .total-section {
            display: flex;
            justify-content: space-between; 
            align-items: center; 
            font-size: 22px;
            font-weight: bold;
            color: #0A6847;
            margin-top: 20px;
        }

        .checkout-button {
            background-color: #0A6847;
            color: #fff;
            padding: 12px 20px; 
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 18px; 
            transition: background-color 0.3s ease;
            margin-top: 10px;
            width: 100%; /* Đặt nút thanh toán chiếm toàn bộ chiều rộng */
        }

        .checkout-button:hover {
            background-color: #00796b; 
        }

        .customer-info, .payment-methods, .promotions {
            margin-top: 20px;
            padding: 15px;
            background-color: #f9f9f9;
            border-radius: 8px;
            box-shadow: 0 1px 5px rgba(0, 0, 0, 0.1);
        }

        .customer-info label, .payment-methods label, .promotions label {
            font-weight: bold;
            margin-bottom: 5px;
            display: block;
        }

        .customer-info input, .payment-methods select, .promotions input {
            width: calc(100% - 20px);
            padding: 10px;
            border: 1px solid #e0e0e0;
            border-radius: 5px;
            margin-bottom: 10px;
        }

        .promotions input[type="checkbox"] {
            margin-right: 10px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container">
        <div class="payment-info">
            <div class="box-header">
                <h2>Danh Sách Sản Phẩm</h2>
            </div>
            <div class="product-list">
                <asp:ListView ID="OrderListView" runat="server">
                    <ItemTemplate>
                        <div class="box-item">
                            <div>
                                <h3><%# Eval("TenSP") %></h3>
                                <p>Kích thước: <%# Eval("TenSize") %></p>
                                <p>Giá: <%# Eval("DonGia", "{0:0,000}") %> VND</p>
                                <p>Số lượng: <%# Eval("SoLuong") %></p>
                                <p>Ghi chú: <%# Eval("GhiChu") %></p>
                                <p>Topping: <%# Eval("TenTopping") %></p>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:ListView>
            </div>
            <div class="payment-methods">
                <label for="ddlPaymentMethod">Hình thức thanh toán:</label>
                <asp:DropDownList ID="ddlPaymentMethod" runat="server">
                    <asp:ListItem Text="Chọn hình thức thanh toán" Value=""></asp:ListItem>
                    <asp:ListItem Text="Thanh toán khi nhận hàng" Value="COD"></asp:ListItem>
                    <asp:ListItem Text="Chuyển khoản ngân hàng" Value="BankTransfer"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="promotions">
                <label>Nhập mã khuyến mãi:</label>
                <asp:TextBox ID="txtPromoCode" runat="server" placeholder="Nhập mã khuyến mãi"></asp:TextBox>
                <asp:Button ID="btnApplyPromo" runat="server" Text="Áp dụng" OnClick="ApplyPromo_Click" CssClass="checkout-button" />
                <asp:Label ID="lblPromoMessage" runat="server" ForeColor="Red" />
            </div>

            <div class="total-section">
                <span>Số tiền giảm:</span>
                <asp:Label ID="lblDiscountAmount" runat="server" CssClass="total-section" Text="0 VNĐ" />
            </div>
            <div class="total-section">
                <span>Tổng cộng:</span>
                <asp:Label ID="TotalLabel" runat="server" CssClass="total-section" />
            </div>

        </div>

        <div class="shipping-info">
            <div class="box-header">
                <h2>Thông Tin Nhận Hàng</h2>
            </div>

            <div class="customer-info">
                <label for="txtCustomerName">Họ và tên:</label>
                <asp:TextBox ID="txtCustomerName" runat="server"></asp:TextBox>

                <label for="txtPhone">Số điện thoại:</label>
                <asp:TextBox ID="txtPhone" runat="server"></asp:TextBox>

                <label for="txtAddress">Địa chỉ giao hàng:</label>
                <asp:TextBox ID="txtAddress" runat="server" TextMode="MultiLine" Rows="3" Width="100%"></asp:TextBox>
            </div>
            <asp:Button ID="btn_DatHang" runat="server" Text="Thanh toán" CssClass="checkout-button" OnClick="Checkout_Click" />
        </div>
    </div>
</asp:Content>