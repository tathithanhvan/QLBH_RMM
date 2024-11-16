<%@ Page Title="Chi Tiết Hóa Đơn" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="OrderDetail.aspx.cs" Inherits="QLBH_RMM.Admin.OrderDetail" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5fff3;
            margin: 0;
            padding: 20px;
        }
        .order-details {
            background-color: #ffffff;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        .order-details h2 {
            color: #0A6847;
            margin-bottom: 15px;
            text-align: center;
        }
        .order-info {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }
        .order-info label {
            font-weight: bold;
            color: #333;
            flex-basis: 30%; /* Adjust width of labels */
        }
        .order-info p, .order-info input {
            margin: 0;
            color: #555;
            flex-basis: 65%; /* Adjust width of input fields */
        }
        .order-info-container {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
        }
        .order-info-left, .order-info-right {
            width: 48%;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        th, td {
            padding: 10px;
            border: 1px solid #e0e0e0;
            text-align: left;
        }
        th {
            background-color: #f9f9f9;
        }
        .total-section {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            margin-top: 30px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
        }
        .total-section p {
            font-size: 17px;
            color: #333;
        }
        .total-section p strong {
            font-size: 19px;
            color: #0A6847;
        }
        .button-container {
            text-align: center;
            margin-top: 20px;
        }
        .btn {
            padding: 10px 15px;
            background-color: #0A6847;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin: 5px;
        }
        .btn:hover {
            background-color: #007B5F;
        }
        .input {
            width: 100%; /* Make inputs take full width of their container */
            max-width: 200px; /* Set a maximum width for inputs */
            padding: 5px; /* Adjust padding for a more compact look */
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="content">
        <div class="order-details">
            <h2>Chi Tiết Hóa Đơn</h2>
            <div class="order-info-container">
                <div class="order-info-left">
                    <div class="order-info">
                        <label>Mã Hóa Đơn:</label>
                        <p><asp:Label ID="lblOrderId" runat="server" Text=""></asp:Label></p>
                    </div>
                    <div class="order-info">
                        <label>Ngày Đặt:</label>
                        <p><asp:Label ID="lblOrderDate" runat="server" Text=""></asp:Label></p>
                    </div>
                    <div class="order-info">
                        <label>Người Nhận:</label>
                        <p>
                            <asp:TextBox ID="txtRecipientName" runat="server" Text="" Enabled="false" CssClass="input"></asp:TextBox>
                        </p>
                    </div>
                    <div class="order-info">
                        <label>Số Điện Thoại:</label>
                        <p>
                            <asp:TextBox ID="txtPhoneNumber" runat="server" Text="" Enabled="false" CssClass="input"></asp:TextBox>
                        </p>
                    </div>
                </div>
                <div class="order-info-right">
                    <div class="order-info">
                        <label>Tổng Giá Trị:</label>
                        <p><asp:Label ID="lblTotalAmount" runat="server" Text=""></asp:Label></p>
                    </div>
                    <div class="order-info">
                        <label>Trạng Thái:</label>
                        <p>
                            <asp:DropDownList ID="ddlStatus" runat="server">
                                <asp:ListItem Value="Chưa giao">Chưa giao</asp:ListItem>
                                <asp:ListItem Value="Đã xong">Đã xong</asp:ListItem>
                            </asp:DropDownList>
                        </p>
                    </div>
                    <div class="order-info">
                        <label>Địa Chỉ Giao Hàng:</label>
                        <p>
                            <asp:TextBox ID="txtShippingAddress" runat="server" Text="" Enabled="false" CssClass="input"></asp:TextBox>
                        </p>
                    </div>
                </div>
            </div>
            <div class="order-info">
                <label>Danh Sách Sản Phẩm:</label>
            </div>
            <asp:GridView ID="gvOrderItems" runat="server" AutoGenerateColumns="False">
                <Columns>
                    <asp:BoundField DataField="TenSP" HeaderText="Tên Sản Phẩm" />
                    <asp:BoundField DataField="TenSize" HeaderText="Kích Thước" />
                    <asp:BoundField DataField="DonGia" HeaderText="Giá" DataFormatString="{0:N0} VNĐ" />
                    <asp:BoundField DataField="SoLuong" HeaderText="Số Lượng" />
                    <asp:BoundField DataField="Topping" HeaderText="Topping" />
                    <asp:BoundField DataField="GhiChu" HeaderText="Ghi Chú" />
                    <asp:BoundField DataField="TotalPrice" HeaderText="Tổng Giá" DataFormatString="{0:N0} VNĐ" />
                </Columns>
            </asp:GridView>
        </div>
        <div class="total-section">
            <p><strong>Tổng Giá Trị Đơn Hàng:</strong> <asp:Label ID="lblTotalValue" runat="server" Text=""></asp:Label></p>
            <p><strong>Khuyến Mãi:</strong> <asp:Label ID="lblDiscount" runat="server" Text=""></asp:Label></p>
            <p><strong>Tổng Số Tiền Phải Trả:</strong> <asp:Label ID="lblFinalTotal" runat="server" Text=""></asp:Label></p>
        </div>
        <div class="button-container">
            <asp:Button ID="btnEdit" runat="server" Text="Chỉnh Sửa" CssClass="btn" OnClick="btnEdit_Click" />
            <asp:Button ID="btnSave" runat="server" Text="Lưu" CssClass="btn" OnClick="btnSave_Click" />
            <asp:Button ID="btnBack" runat="server" Text="Quay Lại" CssClass="btn" OnClick="btnBack_Click" />
        </div>
    </div>
</asp:Content>
