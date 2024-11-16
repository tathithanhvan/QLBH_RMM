<%@ Page Title="Tài Khoản" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true" CodeBehind="TaiKhoan.aspx.cs" Inherits="QLBH_RMM.TaiKhoan" %>

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
        .personal-info, .order-history, .points-voucher {
            background-color: #ffffff;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 10px;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
        }

        .personal-info h3, .order-history h3, .points-voucher h3 {
            font-size: 24px;
            color: #0A6847;
            margin-bottom: 15px;
        }

        a {
            color: #0A6847;
            text-decoration: underline;
        }

    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="sidebar">
        <h2>Tài Khoản</h2>
        <a href="Customer/ThongTinCaNhan.aspx">Thông Tin Cá Nhân</a>
        <a href="Customer/LichSuGiaoDich.aspx">Lịch Sử Đặt Hàng</a>
        <a href="Customer/Diem.aspx">Điểm Tích Lũy</a>
        <a href="Customer/Voucher.aspx">Voucher Của Tôi</a>
        <a href="Customer/ChangePassword.aspx">Đổi Mật Khẩu</a>
        <a href="Customer/DangXuat.aspx">Đăng Xuất</a>
    </div>
    <div class="content">
        <div class="personal-info">
            <h3>Thông Tin Cá Nhân</h3>
            <p><strong>Họ và tên:</strong> <asp:Label ID="lblHoTen" runat="server" Text=""></asp:Label></p>
            <p><strong>Email:</strong> <asp:Label ID="lblEmail" runat="server" Text=""></asp:Label></p>
            <p><strong>Số điện thoại:</strong> <asp:Label ID="lblPhoneNumber" runat="server" Text=""></asp:Label></p>
            <p><strong>Địa chỉ giao hàng:</strong> <asp:Label ID="lblDiaChi" runat="server" Text=""></asp:Label></p>
            <a href="Customer/ThongTinCaNhan.aspx">Chỉnh sửa thông tin</a>
        </div>

        <div class="order-history">
            <h3>Lịch Sử Giao Dịch</h3>
            <ul>
                <li>
                    <strong>Đơn hàng #123456:</strong> Đã giao hàng (01/10/2024) 
                    <a href="Customer/LichSuGiaoDich.aspx?id=123456">Xem chi tiết</a>
                </li>
                <li>
                    <strong>Đơn hàng #654321:</strong> Đang xử lý (05/10/2024) 
                    <a href="Customer/LichSuGiaoDich.aspx?id=654321">Xem chi tiết</a>
                </li>
            </ul>
        </div>

        <div class="points-voucher">
            <h3>Điểm và Voucher</h3>
            <p><strong>Số điểm hiện tại:</strong> 500 điểm</p>
            <p><strong>Voucher khả dụng:</strong></p>
            <ul>
                <li>Giảm 10% cho đơn hàng trên 500k - <a href="Customer/Voucher.aspx">Sử dụng ngay</a></li>
                <li>Giảm 50k cho đơn hàng đầu tiên - <a href="Customer/Voucher.aspx">Sử dụng ngay</a></li>
            </ul>
        </div>
     </div>
</asp:Content>
