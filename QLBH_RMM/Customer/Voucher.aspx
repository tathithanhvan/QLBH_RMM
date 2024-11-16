<%@ Page Title="Voucher" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="Voucher.aspx.cs" Inherits="QLBH_RMM.Customer.Vouchers" %>
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
            padding: 30px;
            height: 100vh;
            position: fixed;
            margin-top: 50px;
        }
        .sidebar h2 {
            color: #ffffff;
            font-size: 30px;
            margin-bottom: 20px;
        }
        .sidebar a {
            color: white;
            text-decoration: none;
            display: block;
            margin: 15px 0;
            font-weight: bold;
            font-size: 20px;
        }
        .sidebar a:hover {
            text-decoration: underline;
        }
        .content {
            margin-left: 25%;
            padding: 20px;
            flex-grow: 1;
            min-height: 100vh;
            box-sizing: border-box;
        }
        .voucher-info {
            background-color: #ffffff;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 10px;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
        }
        .voucher-info h3 {
            font-size: 24px;
            color: #0A6847;
            margin-bottom: 15px;
        }
        .voucher-item {
            padding: 15px;
            margin: 10px 0;
            border: 1px solid #0A6847;
            border-radius: 5px;
            background-color: #f9f9f9;
            transition: box-shadow 0.2s;
        }
        .voucher-item:hover {
            box-shadow: 0px 2px 10px rgba(0, 0, 0, 0.2);
        }
        .voucher-item p {
            font-size: 16px;
            color: #333333;
            margin-bottom: 10px;
        }
        .voucher-item strong {
            color: #0A6847;
        }
        .copy-button {
            background-color: #0A6847;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }
        .copy-button:hover {
            background-color: #07573c;
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
        <div class="voucher-info">
            <h3>Danh Sách Voucher</h3>
            <asp:Repeater ID="rptVouchers" runat="server">
                <ItemTemplate>
                    <div class="voucher-item">
                        <p><strong>Tên Khuyến Mãi:</strong> <%# Eval("TenKM") %></p>
                        <p><strong>Mô Tả:</strong> <%# Eval("MoTa") %></p>
                        <p><strong>Thời Gian:</strong> <%# Eval("NgayBatDau") %> đến <%# Eval("NgayKetThuc") %></p>
                        <p><strong>Số Lượng Voucher Còn Lại:</strong> <asp:Label ID="lblSoLuongConLai" runat="server" Text='<%# Eval("SoLuongConLai") %>'></asp:Label></p>
                        <p><strong>Mã Khuyến Mãi:</strong> <asp:Label ID="lblMaKM" runat="server" Text='<%# Eval("MaKM") %>'></asp:Label></p>
                        <asp:Button ID="btnCopyCode" runat="server" CssClass="copy-button" Text="Sao Chép Mã Khuyến Mãi" OnClientClick='<%# "copyToClipboard(\"" + Eval("MaKM") + "\"); return false;" %>' />
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
    
    <script>
        function copyToClipboard(code) {
            navigator.clipboard.writeText(code).then(function () {
                alert('Mã khuyến mãi đã được sao chép!');
            }, function (err) {
                console.error('Không thể sao chép mã: ', err);
            });
        }
    </script>
</asp:Content>
