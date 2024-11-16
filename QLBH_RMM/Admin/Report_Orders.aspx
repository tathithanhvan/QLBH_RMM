<%@ Page Title="Báo Cáo Đơn Hàng" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Report_Orders.aspx.cs" Inherits="QLBH_RMM.Admin.Report_Orders" %>
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
            justify-content: center; /* Căn giữa theo chiều ngang */
            margin-top: 20px; /* Khoảng cách trên */
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
            background-color: #0A6847;
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
        <h3>Báo Cáo Đơn Hàng</h3>
                <asp:Label ID="lblFromDate" runat="server" Text="Từ ngày:" AssociatedControlID="txtFromDate"></asp:Label>
        <asp:TextBox ID="txtFromDate" runat="server" TextMode="Date"></asp:TextBox>

        <asp:Label ID="lblToDate" runat="server" Text="Đến ngày:" AssociatedControlID="txtToDate"></asp:Label>
        <asp:TextBox ID="txtToDate" runat="server" TextMode="Date"></asp:TextBox>

        <asp:Button ID="btnFilter" runat="server" Text="Lọc" OnClick="btnFilter_Click" CssClass="btn" />

            <asp:Button ID="btnExportToExcel" runat="server" Text="Xuất Báo Cáo ra Excel" OnClick="btnExportToExcel_Click" CssClass="btn" />
            <asp:Button ID="btnExportToPDF" runat="server" Text="Xuất Báo Cáo ra PDF" OnClick="btnExportToPDF_Click" CssClass="btn" />
        <br />
        <asp:Label ID="lblErrorMessage" runat="server" Text="Label" Visible="False" ForeColor="Red" Font-Bold="False"></asp:Label>

        <h4>Danh Sách Đơn Hàng</h4>
        <asp:GridView ID="GridViewOrders" runat="server" AutoGenerateColumns="False" DataSourceID="srcOrderList">
            <Columns>
                <asp:BoundField DataField="MaHD" HeaderText="Mã Đơn Hàng" />
                <asp:BoundField DataField="TenKH" HeaderText="Tên Khách Hàng" />
                <asp:BoundField DataField="NgayMua" HeaderText="Ngày Mua" DataFormatString="{0:dd/MM/yyyy}" />
                <asp:BoundField DataField="TriGiaHD" HeaderText="Tổng Giá Trị" DataFormatString="{0:N0}" />
                <asp:BoundField DataField="NhanVien" HeaderText="Mã Nhân Viên" />
                <asp:BoundField DataField="TinhTrang" HeaderText="Tình Trạng" />
                <asp:BoundField DataField="KhuyenMai" HeaderText="Mã Khuyến Mãi" />
                <asp:BoundField DataField="SoTienGiam" HeaderText="Số Tiền Giảm" DataFormatString="{0:N0}" />
                <asp:BoundField DataField="TenNN" HeaderText="Tên Người Nhận" />
                <asp:BoundField DataField="SDTNN" HeaderText="SĐT Người Nhận" />
                <asp:BoundField DataField="DiaChiNN" HeaderText="Địa Chỉ Người Nhận" />
                <asp:BoundField DataField="HinhThucThanhToan" HeaderText="Hình Thức Thanh Toán" />
            </Columns>
        </asp:GridView>

        <div class="chart-container">
            <div class="chart-box">
                <h4>Tổng số đơn hàng theo ngày</h4>
                <asp:Chart runat="server" ID="ChartOrders" DataSourceID="srcOrders">
                    <Series>
                        <asp:Series Name="Series1" ChartType="Line" XValueMember="Ngay" YValueMembers="TongSoDonHang" Color="#007bff"></asp:Series>
                    </Series>
                    <ChartAreas>
                        <asp:ChartArea Name="ChartArea1"></asp:ChartArea>
                    </ChartAreas>
                </asp:Chart>
            </div>

            <div class="chart-box">
                <h4>Tổng doanh thu theo ngày</h4>
                <asp:Chart runat="server" ID="ChartRevenue" DataSourceID="srcRevenue">
                    <Series>
                        <asp:Series Name="Series1" ChartType="Column" XValueMember="Ngay" YValueMembers="TongDoanhThu" Color="#007bff"></asp:Series>
                    </Series>
                    <ChartAreas>
                        <asp:ChartArea Name="ChartArea1"></asp:ChartArea>
                    </ChartAreas>
                </asp:Chart>
            </div>
        </div>

        <asp:SqlDataSource ID="srcOrders" runat="server" ConnectionString="<%$ ConnectionStrings:QuanLyBanHang_SP_ConnectionString %>" 
            SelectCommand="SELECT CONVERT(DATE, NgayMua) AS Ngay, COUNT(*) AS TongSoDonHang 
                           FROM HoaDon 
                           WHERE MONTH(NgayMua) = MONTH(GETDATE()) AND YEAR(NgayMua) = YEAR(GETDATE()) 
                           GROUP BY CONVERT(DATE, NgayMua) 
                           ORDER BY Ngay"></asp:SqlDataSource>

        <asp:SqlDataSource ID="srcRevenue" runat="server" ConnectionString="<%$ ConnectionStrings:QuanLyBanHang_SP_ConnectionString %>" 
            SelectCommand="SELECT CONVERT(DATE, NgayMua) AS Ngay, SUM(TriGiaHD) AS TongDoanhThu 
                           FROM HoaDon 
                           WHERE MONTH(NgayMua) = MONTH(GETDATE()) AND YEAR(NgayMua) = YEAR(GETDATE()) 
                           GROUP BY CONVERT(DATE, NgayMua) 
                           ORDER BY Ngay"></asp:SqlDataSource>
       



        <asp:SqlDataSource ID="srcOrderList" runat="server" ConnectionString="<%$ ConnectionStrings:QuanLyBanHang_SP_ConnectionString %>" 
            SelectCommand="SELECT 
                            h.MaHD, 
                            k.TenKH, 
                            h.NgayMua, 
                            h.TriGiaHD, 
                            nv.MaNV AS NhanVien, 
                            h.TinhTrang, 
                            km.MaKM AS KhuyenMai, 
                            h.SoTienGiam,
                            h.TenNN, h.SDTNN, h.DiaChiNN, h.HinhThucThanhToan
                        FROM 
                            HoaDon h 
                        JOIN 
                            KhachHang k ON h.MaKH = k.MaKH 
                        LEFT JOIN 
                            NhanVien nv ON h.MaNV = nv.MaNV 
                        LEFT JOIN 
                            KhuyenMai km ON h.MaKM = km.MaKM 
                        WHERE 
                            h.NgayMua BETWEEN @FromDate AND @ToDate
                        ORDER BY 
                            h.NgayMua DESC">
            <SelectParameters>
                <asp:Parameter Name="FromDate" Type="DateTime" />
                <asp:Parameter Name="ToDate" Type="DateTime" />
            </SelectParameters>
        </asp:SqlDataSource>

    </div>
</asp:Content>
