<%@ Page Title="Quản Lý Báo Cáo" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Reports.aspx.cs" Inherits="QLBH_RMM.Admin.Reports" %>

<%@ Register Assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>
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
            top: 0;
            left: 0;
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
            transition: color 0.3s;
        }
        .sidebar a:hover {
            text-decoration: underline;
            color: #a4d7d5; /* Thay đổi màu khi hover */
        }
        .content {
            margin-left: 14%; /* Đẩy nội dung sang phải để tránh sidebar */
            padding: 20px;
            flex-grow: 1;
            min-height: 100vh;
            box-sizing: border-box;
            margin-top: 20px;
        }
        .content h3 {
            font-size: 24px;
            color: #0A6847;
            margin-bottom: 15px;
        }
        .content p {
            font-size: 18px;
            color: #333;
        }
        .chart-container {
            margin-top: 20px;
            display: flex; /* Sử dụng Flexbox để sắp xếp các biểu đồ */
            justify-content: space-between; /* Căn giữa các biểu đồ */
            gap: 20px; /* Khoảng cách giữa các biểu đồ */
        }
        .chart-box {
            background-color: #ffffff;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            flex: 1; /* Cho phép các biểu đồ chiếm không gian bằng nhau */
        }
        a {
            color: #0A6847;
            text-decoration: underline;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="sidebar">
        <h2>Báo Cáo</h2>
        <a href="Report_Orders.aspx">Báo Cáo Đơn Hàng</a>
        <a href="Report_Products.aspx">Báo Cáo Sản Phẩm</a>
        <a href="Report_Promotions.aspx">Báo Cáo Khuyến Mãi</a>
        <a href="Report_Users.aspx">Báo Cáo Người Dùng</a>
    </div>
    <div class="content">
        <h3>Tổng Quan Báo Cáo</h3>
        <p>Chọn một loại báo cáo từ menu bên trái để xem chi tiết và tạo báo cáo.</p>
        
        <div class="chart-container">
            <div class="chart-box">
                <h4>Tổng số đơn hàng theo ngày trong tháng</h4>
                <asp:Chart runat="server" ID="ChartOrders" DataSourceID="srcBCDH">
                    <Series>
                        <asp:Series Name="Series1" ChartType="Line" XValueMember="Ngay" YValueMembers="TongSoDonHang" YValuesPerPoint="2" Color="#0A6847"></asp:Series>
                    </Series>
                    <ChartAreas>
                        <asp:ChartArea Name="ChartArea1"></asp:ChartArea>
                    </ChartAreas>
                </asp:Chart>
            </div>

            <div class="chart-box">
                <h4>Tổng số người dùng mới theo ngày trong tháng</h4>
                <asp:Chart ID="ChartUsers" runat="server" DataSourceID="srcBCKH">
                    <Series>
                        <asp:Series Name="Series1" XValueMember="Ngay" YValueMembers="TongSoNguoiDungMoi"></asp:Series>
                    </Series>
                    <ChartAreas>
                        <asp:ChartArea Name="ChartArea1"></asp:ChartArea>
                    </ChartAreas>
                </asp:Chart>
            </div>
        </div>

        <br />
        <asp:SqlDataSource ID="srcBCDH" runat="server" ConnectionString="<%$ ConnectionStrings:QuanLyBanHang_SP_ConnectionString %>" 
            SelectCommand="SELECT CONVERT(DATE, NgayMua) AS Ngay, COUNT(*) AS TongSoDonHang 
                           FROM HoaDon 
                           WHERE (MONTH(NgayMua) = MONTH(GETDATE())) AND (YEAR(NgayMua) = YEAR(GETDATE())) 
                           GROUP BY CONVERT(DATE, NgayMua) 
                           ORDER BY Ngay DESC"></asp:SqlDataSource>
        <asp:SqlDataSource ID="srcBCKH" runat="server" ConnectionString="<%$ ConnectionStrings:QuanLyBanHang_SP_ConnectionString %>" 
            SelectCommand="SELECT CAST(NgayTao AS DATE) AS Ngay, COUNT(*) AS TongSoNguoiDungMoi 
                           FROM KhachHang 
                           WHERE (MONTH(NgayTao) = MONTH(GETDATE())) AND (YEAR(NgayTao) = YEAR(GETDATE())) 
                           GROUP BY CAST(NgayTao AS DATE) 
                           ORDER BY Ngay DESC"></asp:SqlDataSource>
    </div>
</asp:Content>
