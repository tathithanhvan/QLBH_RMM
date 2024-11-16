<%@ Page Title="Lịch Sử Giao Dịch" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true" CodeBehind="LichSuGiaoDich.aspx.cs" Inherits="QLBH_RMM.Customer.LichSuGiaoDich" %>

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
        .transaction-history {
            background-color: #ffffff;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 10px;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
        }
        .transaction-history h3 {
            font-size: 24px;
            color: #0A6847;
            margin-bottom: 15px;
        }
        .transaction-history ul {
            list-style: none; /* Loại bỏ dấu chấm đầu dòng */
            padding: 0; /* Xóa padding */
        }
        .transaction-history li {
            margin-bottom: 10px; /* Khoảng cách giữa các giao dịch */
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
        <a href="ThongTinCaNhan.aspx">Thông Tin Cá Nhân</a>
        <a href="LichSuGiaoDich.aspx">Lịch Sử Đặt Hàng</a>
        <a href="Diem.aspx">Điểm Tích Lũy</a>
        <a href="Voucher.aspx">Voucher Của Tôi</a>
        <a href="ChangePassword.aspx">Đổi Mật Khẩu</a>
        <a href="DangXuat.aspx">Đăng Xuất</a>
    </div>
    <div class="content">
        <div class="transaction-history">
            <h3>Lịch Sử Giao Dịch</h3>
            <ul id="transactionList" runat="server">
                <!-- Danh sách giao dịch sẽ được chèn vào đây -->
            </ul>
        </div>
    </div>
</asp:Content>

