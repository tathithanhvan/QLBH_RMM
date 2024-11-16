<%@ Page Title="Đăng Xuất Thành Công" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="DangXuat.aspx.cs" Inherits="QLBH_RMM.Customer.DangXuat" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5fff3;
            margin: 0;
            padding: 0;
            text-align: center;
        }

        .notification {
            margin-top: 100px;
            padding: 20px;
            margin-bottom: 80px;
        }

        .notification h2 {
            color: #0A6847;
            font-size: 24px;
        }

        .notification p {
            color: #333;
            font-size: 16px;
            margin: 15px 0;
        }

        .home-link {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #0A6847;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }

        .home-link:hover {
            background-color: #0e805a;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="notification">
        <h2>Đăng Xuất Thành Công</h2>
        <p>Bạn đã đăng xuất khỏi tài khoản của mình. Cảm ơn bạn đã sử dụng dịch vụ của chúng tôi!</p>
        <a href="/TrangChu.aspx" class="home-link">Quay về Trang Chủ</a>
    </div>
</asp:Content>
