<%@ Page Title="Báo Cáo Khuyến Mãi" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Report_Promotions.aspx.cs" Inherits="QLBH_RMM.Admin.Report_Promotions" %>
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
        .table-container {
            margin-top: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            border-radius: 8px;
            overflow: hidden;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #0A6847; /* Header color */
            color: white;
        }
        .table-primary {
            background-color: #e9f5f0; /* Light green for primary table */
        }
        .table-secondary {
            background-color: #f0e9f5; /* Light purple for secondary table */
        }
        .table-tertiary {
            background-color: #f5f0e9; /* Light beige for tertiary table */
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
            margin: 0 10px;
            transition: background 0.3s;
        }
        .btn:hover {
            background-color: #005f4f;
        }
        .scrollable-table {
            max-height: 400px; /* Adjust as needed */
            overflow-y: auto;
            display: block;
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
        <h3>Báo Cáo Khuyến Mãi</h3>

        <h4>Khuyến Mãi Sắp Hết Hạn</h4>
        <asp:GridView ID="gdvKMSapHetHan" runat="server" AutoGenerateColumns="false" CssClass="table table-primary">
            <Columns>
                <asp:BoundField DataField="MaKM" HeaderText="Mã Khuyến Mãi" />
                <asp:BoundField DataField="TenKM" HeaderText="Tên Khuyến Mãi" />
                <asp:BoundField DataField="NgayBatDau" HeaderText="Ngày Bắt Đầu" DataFormatString="{0:dd/MM/yyyy}" />
                <asp:BoundField DataField="NgayKetThuc" HeaderText="Ngày Kết Thúc" DataFormatString="{0:dd/MM/yyyy}" />
                <asp:BoundField DataField="GiamGia" HeaderText="Giảm Giá" />
                <asp:BoundField DataField="KieuGiamGia" HeaderText="Kiểu Giảm Giá" />
                <asp:BoundField DataField="TrangThai" HeaderText="Tình Trạng" />
            </Columns>
        </asp:GridView>

        <h4>Khuyến Mãi Trong Tháng</h4>
        <div class="button-container">
            <div class="filter-container">
                <label class="filter-label">Chọn Tháng:</label>
                <asp:DropDownList ID="ddlMonths" runat="server">
                    <asp:ListItem Text="Tháng 1" Value="1"></asp:ListItem>
                    <asp:ListItem Text="Tháng 2" Value="2"></asp:ListItem>
                    <asp:ListItem Text="Tháng 3" Value="3"></asp:ListItem>
                    <asp:ListItem Text="Tháng 4" Value="4"></asp:ListItem>
                    <asp:ListItem Text="Tháng 5" Value="5"></asp:ListItem>
                    <asp:ListItem Text="Tháng 6" Value="6"></asp:ListItem>
                    <asp:ListItem Text="Tháng 7" Value="7"></asp:ListItem>
                    <asp:ListItem Text="Tháng 8" Value="8"></asp:ListItem>
                    <asp:ListItem Text="Tháng 9" Value="9"></asp:ListItem>
                    <asp:ListItem Text="Tháng 10" Value="10"></asp:ListItem>
                    <asp:ListItem Text="Tháng 11" Value="11"></asp:ListItem>
                    <asp:ListItem Text="Tháng 12" Value="12"></asp:ListItem>
                </asp:DropDownList>
                <asp:Button ID="btnFilter" runat="server" Text="Lọc" CssClass="btn" OnClick="btnFilter_Click" />
                <asp:Button ID="btnExportBoth" runat="server" Text="Xuất Báo Cáo" CssClass="btn" OnClick="btnXuatBaoCao_Click" />
            </div>
        </div>

        <div class="table-container">
            <asp:GridView ID="gdvKMThang" runat="server" AutoGenerateColumns="false" CssClass="table table-secondary">
                <Columns>
                    <asp:BoundField DataField="MaKM" HeaderText="Mã Khuyến Mãi" />
                    <asp:BoundField DataField="TenKM" HeaderText="Tên Khuyến Mãi" />
                    <asp:BoundField DataField="NgayBatDau" HeaderText="Ngày Bắt Đầu" DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:BoundField DataField="NgayKetThuc" HeaderText="Ngày Kết Thúc" DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:BoundField DataField="GiamGia" HeaderText="Giảm Giá" />
                    <asp:BoundField DataField="KieuGiamGia" HeaderText="Kiểu Giảm Giá" />
                    <asp:BoundField DataField="TrangThai" HeaderText="Tình Trạng" />
                </Columns>
            </asp:GridView>
        </div>

        <h4>Tỷ Lệ Sử Dụng Khuyến Mãi</h4>
         <div class="scrollable-table">
        <asp:GridView ID="GridViewUsageRate" runat="server" AutoGenerateColumns="false" CssClass="table table-tertiary">
            <Columns>
                <asp:BoundField DataField="MaKM" HeaderText="Mã Khuyến Mãi" />
                <asp:BoundField DataField="TenKM" HeaderText="Tên Khuyến Mãi" />
                <asp:BoundField DataField="TongPhatHanh" HeaderText="Tổng Số Mã Phát Hành" />
                <asp:BoundField DataField="TongSuDung" HeaderText="Tổng Số Mã Đã Sử Dụng" />
                <asp:BoundField DataField="TyLeSuDung" HeaderText="Tỷ Lệ Sử Dụng" DataFormatString="{0:P2}" />
            </Columns>
        </asp:GridView>
             </div>
    </div>
</asp:Content>
