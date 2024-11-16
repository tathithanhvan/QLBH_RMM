<%@ Page Title="Báo Cáo Sản Phẩm" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Report_Products.aspx.cs" Inherits="QLBH_RMM.Admin.Report_Products" %>
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
            color: #a4d7d5;
        }
        .content {
            margin-left: 14%; /* Adjusted for sidebar */
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
        .filter-container {
            margin-bottom: 20px;
        }
        .filter-label {
            font-weight: bold;
            margin-right: 10px;
        }
        .chart-container {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
            gap: 20px;
        }
        .chart-box {
            background-color: #ffffff;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            flex: 1;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: #ffffff;
            border-radius: 8px;
            overflow: hidden;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #0A6847;
            color: white;
        }
        .button-container {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }
        .btn {
            background-color: #0A6847;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 5px;
            cursor: pointer;
            margin: 10px 0;
            transition: background 0.3s;
        }
        .btn:hover {
            background-color: #005f4f;
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
        <h3>Báo Cáo Sản Phẩm</h3>

        <div class="filter-container">
            <label class="filter-label">Chọn Loại Báo Cáo:</label>
            <asp:DropDownList ID="ddlReportType" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlReportType_SelectedIndexChanged">
                <asp:ListItem Text="Doanh Thu Sản Phẩm" Value="DTTheoSP"></asp:ListItem>
                <asp:ListItem Text="Sản Phẩm và Topping Hay Đi Kèm" Value="TPHayDiKemSP"></asp:ListItem>
                <asp:ListItem Text="Doanh Thu Theo Tháng" Value="MonthlyRevenueReport"></asp:ListItem>
                <asp:ListItem Text="Top Sản Phẩm Bán Chạy" Value="SPBanChay"></asp:ListItem>
            </asp:DropDownList>
            <label class="filter-label">Từ Ngày:</label>
            <asp:TextBox ID="txtStartDate" runat="server" TextMode="Date"></asp:TextBox>
            <label class="filter-label">Đến Ngày:</label>
            <asp:TextBox ID="txtEndDate" runat="server" TextMode="Date"></asp:TextBox>
            <asp:Button ID="btnFilter" runat="server" Text="Lọc" CssClass="btn" OnClick="btnFilter_Click" />
            <asp:Button ID="btnExport" runat="server" Text="Xuất Báo Cáo" CssClass="btn" OnClick="btnExport_Click" />
        </div>

        <asp:GridView ID="GridViewReports" runat="server" AutoGenerateColumns="true" CssClass="table">
        </asp:GridView>

        <div class="chart-container">
            <div class="chart-box">
                <h4>Thống kê số lượng bán theo sản phẩm</h4>
                <asp:Chart runat="server" ID="ChartProducts" DataSourceID="srcProductSales">
                    <Series>
                        <asp:Series Name="Series1" Color="#007bff" XValueMember="TenSP" YValueMembers="TongSoLuongBan"></asp:Series>
                    </Series>
                    <ChartAreas>
                        <asp:ChartArea Name="ChartArea1"></asp:ChartArea>
                    </ChartAreas>
                </asp:Chart>
            </div>
            <div class="chart-box">
                <h4>Tổng doanh thu từ sản phẩm theo ngày</h4>
                <asp:Chart runat="server" ID="ChartRevenueProducts" DataSourceID="srcProductRevenue">
                    <Series>
                        <asp:Series Name="Series1" ChartType="Column" XValueMember="Ngay" YValueMembers="TongDoanhThu" Color="#007bff"></asp:Series>
                    </Series>
                    <ChartAreas>
                        <asp:ChartArea Name="ChartArea1"></asp:ChartArea>
                    </ChartAreas>
                </asp:Chart>
            </div>
        </div>
        <asp:SqlDataSource ID="srcProductSales" runat="server" ConnectionString="<%$ ConnectionStrings:QuanLyBanHang_SP_ConnectionString %>" 
            SelectCommand="SELECT TOP (10) SP.TenSP, SUM(CTHD.Soluong) AS TongSoLuongBan, SUM(CTHD.Soluong * SPS.DonGia) AS TongDoanhThu FROM HoaDon AS HD INNER JOIN CTHD ON HD.MaHD = CTHD.MaHD INNER JOIN SanPham AS SP ON CTHD.MaSP = SP.MaSP INNER JOIN SanPham_Size AS SPS ON CTHD.MaSP = SPS.MaSP AND CTHD.MaSize = SPS.MaSize WHERE (HD.TinhTrang = N'Đã xong') GROUP BY SP.TenSP ORDER BY TongSoLuongBan DESC">
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="srcProductRevenue" runat="server" ConnectionString="<%$ ConnectionStrings:QuanLyBanHang_SP_ConnectionString %>" 
            SelectCommand="SELECT CONVERT(DATE, HD.NgayMua) AS Ngay, SUM(CTHD.Soluong * SPS.DonGia) AS TongDoanhThu FROM HoaDon HD JOIN CTHD ON HD.MaHD = CTHD.MaHD JOIN SanPham SP ON CTHD.MaSP = SP.MaSP JOIN SanPham_Size SPS ON CTHD.MaSP = SPS.MaSP AND CTHD.MaSize = SPS.MaSize WHERE HD.TinhTrang = N'Đã xong' GROUP BY CONVERT(DATE, HD.NgayMua)">
        </asp:SqlDataSource>
    </div>
    
</asp:Content>

