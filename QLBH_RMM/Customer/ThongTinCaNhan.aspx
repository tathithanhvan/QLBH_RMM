<%@ Page Title="Thông Tin Cá Nhân" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="ThongTinCaNhan.aspx.cs" Inherits="QLBH_RMM.Customer.ThongTinCaNhan" %>

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
        
        .container {
            max-width: 600px;
            margin: 20px auto; /* Center the container */
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
        h1 {
            text-align: center;
            color: #0A6847;
            font-size: 28px;
            margin-bottom: 30px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #333;
        }
        input[type="text"],
        input[type="email"],
        input[type="date"],
        select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 14px;
            background-color: #fff;
        }
        input[type="text"]:focus,
        input[type="email"]:focus,
        input[type="date"]:focus,
        select:focus {
            border-color: #0A6847;
            outline: none;
            box-shadow: 0 0 5px rgba(10, 104, 71, 0.3);
        }
        .button-container {
            display: flex;
            justify-content: space-between; /* Space buttons evenly */
            margin-top: 20px;
        }
        .update-button,
        .back-button {
            background-color: #0A6847;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            width: 48%; /* Adjust width to fit side by side */
            transition: background-color 0.3s, transform 0.2s;
        }
        .update-button:hover,
        .back-button:hover {
            background-color: #0e805a;
            transform: translateY(-2px);
        }
        .update-button:active,
        .back-button:active {
            transform: translateY(0);
        }
        @media (max-width: 768px) {
            .container {
                padding: 20px;
            }
            .update-button,
            .back-button {
                width: 100%; /* Stack buttons on smaller screens */
                margin-top: 10px; /* Add space between stacked buttons */
            }
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
        <div class =" container">
        <h1>Thông Tin Cá Nhân</h1>
        <div class="form-group">
            <label for="TenKHTextBox">Tên Khách Hàng:</label>
            <asp:TextBox ID="TenKHTextBox" runat="server" placeholder="Tên Khách Hàng" />
        </div>
        <div class="form-group">
            <label for="DiaChiTextBox">Địa Chỉ:</label>
            <asp:TextBox ID="DiaChiTextBox" runat="server" placeholder="Địa Chỉ" />
        </div>
        <div class="form-group">
            <label for="GioiTinhDropDown">Giới Tính:</label>
            <asp:DropDownList ID="GioiTinhDropDown" runat="server">
                <asp:ListItem Text="Nam" Value="0"></asp:ListItem>
                <asp:ListItem Text="Nữ" Value="1"></asp:ListItem>
            </asp:DropDownList>
        </div>
        <div class="form-group">
            <label for="NgaySinhTextBox">Ngày Sinh:</label>
            <asp:TextBox ID="NgaySinhTextBox" runat="server" TextMode="Date" />
        </div>
        <div class="form-group">
            <label for="SDTTextBox">Số Điện Thoại:</label>
            <asp:TextBox ID="SDTTextBox" runat="server" placeholder="Số Điện Thoại" />
        </div>
        <div class="form-group">
            <label for="EmailTextBox">Email:</label>
            <asp:TextBox ID="EmailTextBox" runat="server" placeholder="Email" TextMode="Email" Enabled="False" />
        </div>
        <div class="button-container">
            <asp:Button ID="ButtonBack" runat="server" CssClass="back-button" Text="Trở Về" OnClick="btnBack_Click" />
            <asp:Button ID="Button1" runat="server" CssClass="update-button" Text="Cập Nhật Thông Tin" OnClick="btnUpdate_Click" />
        </div>
            </div>
    </div>
</asp:Content>
