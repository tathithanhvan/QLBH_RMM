<%@ Page Title="Điểm Tích Lũy" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="Diem.aspx.cs" Inherits="QLBH_RMM.Customer.Diem" %>
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
        .section {
            background-color: #ffffff;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 10px;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
        }
        .section h3 {
            font-size: 24px;
            color: #0A6847;
            margin-bottom: 15px;
        }
        .ranking-section {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }
        .ranking-card {
            background-color: #ffffff;
            border-radius: 10px;
            padding: 10px;
            box-shadow: 0px 2px 4px rgba(0, 0, 0, 0.1);
            flex: 1 1 calc(25% - 10px);
            min-width: 180px;
            text-align: center;
            transition: transform 0.2s;
            border: 1px solid #0A6847;
        }
        .ranking-card:hover {
            transform: scale(1.05);
        }
        .ranking-card h4 {
            color: #0A6847;
            margin-bottom: 5px;
            font-size: 18px;
        }
        .ranking-card p {
            font-size: 14px;
            color: #555;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: center;
        }
        th {
            background-color: #0A6847;
            color: white;
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
        <div class="section">
            <h3>Điểm Tích Lũy</h3>
            <p><strong>Số điểm hiện tại:</strong> <asp:Label ID="lblSoDiem" runat="server" Text="0"></asp:Label> điểm</p>
            <p><strong>Điểm đã sử dụng:</strong> <asp:Label ID="lblDiemDaSuDung" runat="server" Text="0"></asp:Label> điểm</p>
            <p><strong>Điểm khả dụng:</strong> <asp:Label ID="lblDiemKhaDung" runat="server" Text="0"></asp:Label> điểm</p>
            <p><strong>Hạng hiện tại:</strong> <asp:Label ID="lblCurrentRank" runat="server" Text=""></asp:Label></p>
            <p><strong>Bạn cần:</strong> <asp:Label ID="lblMinPoints" runat="server" Text="0"></asp:Label> điểm để lên hạng tiếp theo.</p>
        </div>

        <div class="section ranking-section">
            <h3>Các Mức Hạng</h3>
            <div class="ranking-card" id="rankCard1">
                <h4>Hạt mầm</h4>
                <p>Điểm tối thiểu: 0</p>
            </div>
            <div class="ranking-card" id="rankCard2">
                <h4>Chồi non</h4>
                <p>Điểm tối thiểu: 500</p>
            </div>
            <div class="ranking-card" id="rankCard3">
                <h4>Lá nhỏ</h4>
                <p>Điểm tối thiểu: 1000</p>
            </div>
            <div class="ranking-card" id="rankCard4">
                <h4>Lá xanh</h4>
                <p>Điểm tối thiểu: 2500</p>
            </div>
            <div class="ranking-card" id="rankCard5">
                <h4>Siêu rau má</h4>
                <p>Điểm tối thiểu: 5000</p>
            </div>
        </div>

        <div class="section">
            <h3>Lịch Sử Tích Điểm</h3>
            <table class="history-table">
                <thead>
                    <tr>
                        <th>Ngày Kiểm Được</th>
                        <th>Điểm Kiểm Được</th>
                        <th>Mã Hóa Đơn</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptHistory" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td><%# Eval("NgayKiemDuoc", "{0:dd/MM/yyyy}") %></td>
                                <td><%# Eval("DiemKiemDuoc") %></td>
                                <td><%# Eval("MaHD") %></td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
        </div>
    </div>
</asp:Content>
