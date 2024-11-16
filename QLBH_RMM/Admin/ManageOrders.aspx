<%@ Page Title="Quản Lý Đơn Hàng" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageOrders.aspx.cs" Inherits="QLBH_RMM.Admin.ManageOrders" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .container {
            display: flex;
            margin-top: 50px;
            padding: 0px;
            background-color: #f9f9f9;
            margin-left: 25%;
            min-height: 100vh;
        }

        .sidebar {
            width: 20%;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            margin-right: 20px;
            position: fixed; 
            height: 100vh;
            margin-top: 50px;
        }

        .sidebar h3 {
            color: #0A6847;
            margin-bottom: 20px;
        }

        .filter-section {
            margin-bottom: 20px;
        }

        .filter-section input {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        h2 {
            color: #0A6847;
            margin-bottom: 15px;
            text-align: center;
        }
        .filter-section .button {
            width: 100%;
            padding: 10px;
            background-color: #0A6847;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            box-sizing: border-box;
        }

        .filter-section .button:hover {
            background-color: #007B5F;
        }

        .order-list {
            flex: 1;
            background-color: #fff;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .order-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .order-table th, .order-table td {
            border: 1px solid #ccc;
            padding: 10px;
            text-align: center;
        }

        .order-table th {
            background-color: #0A6847;
            color: white;
        }

        /* Tooltip style */
        .tooltip {
            position: relative;
            display: inline-block;
            cursor: pointer;
        }

        .tooltip .tooltiptext {
            visibility: hidden;
            width: 200px;
            background-color: #555;
            color: #fff;
            text-align: center;
            border-radius: 6px;
            padding: 5px;
            position: absolute;
            z-index: 1;
            bottom: 125%; /* Position above the text */
            left: 50%;
            margin-left: -100px; /* Center the tooltip */
            opacity: 0;
            transition: opacity 0.3s;
        }

        .tooltip:hover .tooltiptext {
            visibility: visible;
            opacity: 1;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
        <div class="sidebar">
            <h3>Lọc và Tìm Kiếm</h3>
            <div class="filter-section">
                <asp:TextBox ID="searchOrderID" runat="server" placeholder="Nhập thông tin tìm kiếm..."></asp:TextBox>
                <asp:Button ID="btnSearch" runat="server" Text="Tìm Kiếm" CssClass="button" OnClick="btnSearch_Click" />
            </div>
            <div class="filter-section">
                <label for="startDate">Từ Ngày:</label>
                <asp:TextBox ID="startDate" runat="server" TextMode="Date"></asp:TextBox>
                <label for="endDate">Đến Ngày:</label>
                <asp:TextBox ID="endDate" runat="server" TextMode="Date"></asp:TextBox>
                <asp:Button ID="btnFilter" runat="server" Text="Lọc Theo Ngày" CssClass="button" OnClick="btnFilter_Click" />
            </div>
        </div>
<div class="container">
        <div class="order-list">
            <h2 style="text-align: center;">Danh Sách Đơn Hàng</h2>
            <div style="text-align: center; margin-top: 10px;">
                <span class="tooltip">Nhấn vào Mã HD để xem chi tiết đơn hàng
                    <span class="tooltiptext">Nhấn vào Mã HD để xem chi tiết đơn hàng</span>
                </span>
            </div>
            <asp:GridView ID="GridViewOrders" runat="server" AutoGenerateColumns="False" CssClass="order-table" DataKeyNames="MaHD" DataSourceID="SqlDataSource1" AllowPaging="True">
                <Columns>
                    <asp:HyperLinkField DataNavigateUrlFields="MaHD" 
                                       DataNavigateUrlFormatString="OrderDetail.aspx?MaHD={0}" 
                                       HeaderText="Mã HD" 
                                       SortExpression="MaHD" 
                                       DataTextField="MaHD" />
                    <asp:BoundField DataField="NgayMua" HeaderText="Ngày Đặt" SortExpression="NgayMua" />
                    <asp:BoundField DataField="TriGiaHD" HeaderText="Trị Giá" SortExpression="TriGiaHD" />
                    <asp:BoundField DataField="TinhTrang" HeaderText="Tình Trạng" SortExpression="TinhTrang" />
                    <asp:BoundField DataField="TenNN" HeaderText="Người Nhận" SortExpression="TenNN" />
                    <asp:BoundField DataField="SDTNN" HeaderText="SDT" SortExpression="SDTNN" />
                    <asp:BoundField DataField="HinhThucThanhToan" HeaderText="Thanh Toán" SortExpression="HinhThucThanhToan" />
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:QuanLyBanHang_SP_ConnectionString %>" SelectCommand="SELECT [MaHD], [NgayMua], [TriGiaHD], [TinhTrang], [TenNN], [SDTNN], [HinhThucThanhToan] FROM [HoaDon] ORDER BY [NgayMua] DESC"></asp:SqlDataSource>
        </div>
    </div>
</asp:Content>
