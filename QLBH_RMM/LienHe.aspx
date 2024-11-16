<%@ Page Title="Liên Hệ" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="LienHe.aspx.cs" Inherits="QLBH_RMM.LienHe" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }

        .container {
            width: 80%;
            margin: auto;
            overflow: hidden;
            padding: 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-top: 70px;
        }

        h1 {
            text-align: center;
            color: #333;
        }

        .contact-info {
            margin-bottom: 30px;
        }

        .contact-info h3 {
            color: #0A6847;
        }

        .contact-info p {
            margin: 5px 0;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #555;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .form-group button {
            width: 80%;
            padding: 10px;
            background: #0e805a;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background 0.3s;
        }

        .form-group button:hover {
            background: #0a5e42;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container">
        <h1>Liên Hệ Với Chúng Tôi</h1>

        <div class="contact-info">
            <h3>Thông Tin Cửa Hàng</h3>
            <p>Địa chỉ: 65 đường số 37, Khu đô thị Vạn Phúc, Hiệp Bình Phước, Thành phố Hồ Chí Minh</p>
            <p>Email: <asp:HyperLink ID="lnkGmail" runat="server" NavigateUrl="mailto:2121011855@sv.ufm.edu.vn" Text="2121011855@sv.ufm.edu.vn" /></p>
            <p>Hotline: <asp:HyperLink ID="lnkCall" runat="server" NavigateUrl="tel:+84856036377" Text="1900 09 07 02" /></p>
        </div>

        <h3>Gửi Thông Điệp</h3>
        <asp:Panel ID="Panel1" runat="server">
            <div class="form-group">
                <label for="txtName">Tên của bạn:</label>
                <asp:TextBox ID="txtName" runat="server" placeholder="Nhập tên..." required></asp:TextBox>
            </div>
            <div class="form-group">
                <label for="txtEmail">Email:</label>
                <asp:TextBox ID="txtEmail" runat="server" placeholder="Nhập email..." required></asp:TextBox>
            </div>
            <div class="form-group">
                <label for="txtMessage">Tin nhắn:</label>
                <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Rows="5" placeholder="Nhập tin nhắn..." required></asp:TextBox>
            </div>
            <div class="form-group">
                <strong>
                <asp:Button ID="btnSend" runat="server" BackColor="#0E805A" ForeColor="White" OnClick="btnSend_Click" Text="Gửi" />
                </strong>
            </div>
        </asp:Panel>
    </div>
</asp:Content>
