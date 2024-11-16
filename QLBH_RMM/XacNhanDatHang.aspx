<%@ Page Title="Xác Nhận Đơn Hàng" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="XacNhanDatHang.aspx.cs" Inherits="QLBH_RMM.XacNhanDatHang" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 900px;
            margin: 50px auto;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            padding: 40px;
        }

        h2 {
            color: #0A6847;
            font-size: 32px;
            text-align: center;
            margin-bottom: 20px;
            font-weight: bold;
        }

        h3 {
            color: #333;
            font-size: 24px;
            margin-top: 20px;
            margin-bottom: 10px;
        }

        .section {
            margin-bottom: 30px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        th, td {
            padding: 12px;
            border: 1px solid #e0e0e0;
            text-align: left;
        }

        th {
            background-color: #f9f9f9;
            font-weight: bold;
        }

        .total-section th {
            background-color: #e0f7fa;
        }

        .thank-you {
            text-align: center;
            margin-top: 20px;
            font-size: 18px;
            color: #555;
        }

        .back-button {
            display: inline-block;
            width: 220px;
            margin: 30px auto 0;
            text-align: center;
            background-color: #0A6847;
            color: #fff;
            padding: 15px 0;
            border-radius: 5px;
            text-decoration: none;
            font-size: 18px;
            transition: background-color 0.3s;
        }

        .back-button:hover {
            background-color: #00796b;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container">
        <h2>Đơn Hàng Của Bạn Đã Được Đặt Thành Công!</h2>
        
        <div class="section order-details">
            <h3>Chi Tiết Đơn Hàng</h3>
            <asp:GridView ID="OrderDetailsGridView" runat="server" AutoGenerateColumns="false">
                <Columns>
                    <asp:BoundField DataField="TenSP" HeaderText="Tên Sản Phẩm" />
                    <asp:BoundField DataField="TenSize" HeaderText="Kích Thước" />
                    <asp:BoundField DataField="DonGia" HeaderText="Giá" DataFormatString="{0:N0} VND" />
                    <asp:BoundField DataField="SoLuong" HeaderText="Số Lượng" />
                    <asp:BoundField DataField="Topping" HeaderText="Topping" />
                    <asp:BoundField DataField="GhiChu" HeaderText="Ghi Chú" />
                    <asp:BoundField DataField="TotalPrice" HeaderText="Tổng Giá" DataFormatString="{0:N0} VND" />
                </Columns>
            </asp:GridView>
        </div>

        <div class="section customer-info">
            <h3>Thông Tin Nhận Hàng</h3>
            <table>
                <tr>
                    <th>Tên Người Nhận</th>
                    <td><asp:Label ID="lblRecipientName" runat="server" /></td>
                </tr>
                <tr>
                    <th>Số Điện Thoại</th>
                    <td><asp:Label ID="lblRecipientPhone" runat="server" /></td>
                </tr>
                <tr>
                    <th>Địa Chỉ</th>
                    <td><asp:Label ID="lblRecipientAddress" runat="server" /></td>
                </tr>
                <tr>
                    <th>Hình Thức Thanh Toán</th>
                    <td><asp:Label ID="lblPaymentMethod" runat="server" /></td>
                </tr>
                <tr>
                    <th>Tổng Tiền</th>
                    <td><asp:Label ID="lblTotal" runat="server" /></td>
                </tr>
            </table>
        </div>

        <div class="section total-section">
            <h3>Chi Tiết Thanh Toán</h3>
            <table>
                <tr>
                    <th>Tổng Tiền</th>
                    <td><asp:Label ID="lblGrandTotal" runat="server" /></td>
                </tr>
                <tr>
                    <th>Giảm Giá</th>
                    <td><asp:Label ID="lblDiscount" runat="server" /></td>
                </tr>
                <tr>
                    <th>Thành Tiền</th>
                    <td><asp:Label ID="lblFinalTotal" runat="server" /></td>
                </tr>
            </table>
        </div>

        <div class="thank-you">
            <p>Cảm ơn bạn đã mua hàng! Đơn hàng của bạn sẽ được xử lý trong thời gian sớm nhất.</p>
        </div>

        <a href="TrangChu.aspx" class="back-button">Tiếp Tục Mua Sắm</a>
    </div>
</asp:Content>
