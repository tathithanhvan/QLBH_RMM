<%@ Page Title="Chi Tiết Đơn Hàng" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="ChiTietDonHang.aspx.cs" Inherits="QLBH_RMM.Customer.ChiTietDonHang" %>
<%@ Import Namespace="System.Web.UI.WebControls" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5fff3;
            margin: 0;
            display: flex;
        }
        .sidebar {
            width: 20%;
            background-color: #0A6847;
            color: white;
            padding: 30px; /* Tăng padding cho sidebar */
            height: 100vh; /* Chiều cao sidebar bằng chiều cao viewport */
            position: fixed; /* Giữ sidebar cố định khi cuộn */
            margin-top: 50px;

        }
        .sidebar h2 {
            color: #ffffff;
            font-size: 30px; /* Tăng kích thước chữ tiêu đề */
            margin-bottom: 20px; /* Tăng khoảng cách dưới tiêu đề */
        }
        .sidebar a {
            color: white;
            text-decoration: none;
            display: block;
            margin: 15px 0; /* Tăng khoảng cách giữa các liên kết */
            font-weight: bold;
            font-size: 20px; /* Tăng kích thước chữ cho các liên kết */
        }
        .sidebar a:hover {
            text-decoration: underline;
        }
        .content {
            margin-left: 25%; /* Đẩy nội dung sang phải để tránh sidebar */
            padding: 20px;
            flex-grow: 1;
            min-height: 100vh; /* Đảm bảo nội dung có chiều cao tối thiểu bằng chiều cao viewport */
            box-sizing: border-box; /* Đảm bảo padding không làm tăng chiều rộng */
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
        }
        .order-info p {
            margin: 0;
            color: #555;
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
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="sidebar">
        <h2>Tài Khoản</h2>
        <a href="ThongTinCaNhan.aspx">Thông Tin Cá Nhân</a>
        <a href="LichSuGiaoDich.aspx">Lịch Sử Đặt Hàng</a>
        <a href="Diem.aspx">Điểm Tích Lũy</a>
        <a href="Voucher.aspx">Voucher Của Tôi</a>
        <a href="ChangePassword.aspx">Đổi Mật Khẩu</a>
        <a href="DangXuat.aspx">Đăng Xuất</a>
    </div>
    <div class="content">
        <div class="order-details">
            <h2>Chi Tiết Đơn Hàng</h2>
            <div class="order-info-container">
                <div class="order-info-left">
                    <div class="order-info">
                        <label>Mã Đơn Hàng:</label>
                        <p><asp:Label ID="lblOrderId" runat="server" Text=""></asp:Label></p>
                    </div>
                    <div class="order-info">
                        <label>Người Nhận:</label>
                        <p><asp:Label ID="lblRecipientName" runat="server" Text=""></asp:Label></p>
                    </div>
                    <div class="order-info">
                        <label>Địa Chỉ Giao Hàng:</label>
                        <p><asp:Label ID="lblShippingAddress" runat="server" Text=""></asp:Label></p>
                    </div>
                </div>
                <div class="order-info-right">
                    <div class="order-info">
                        <label>Ngày Đặt Hàng:</label>
                        <p><asp:Label ID="lblOrderDate" runat="server" Text=""></asp:Label></p>
                    </div>
                    <div class="order-info">
                        <label>Tổng Giá Trị:</label>
                        <p><asp:Label ID="lblTotalAmount" runat="server" Text=""></asp:Label></p>
                    </div>
                    <div class="order-info">
                        <label>Trạng Thái Đơn Hàng:</label>
                        <p><asp:Label ID="lblOrderStatus" runat="server" Text=""></asp:Label></p>
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
        </div>
    
</asp:Content>