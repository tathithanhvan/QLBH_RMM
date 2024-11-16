<%@ Page Title="Báo Cáo Người Dùng" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Report_Users.aspx.cs" Inherits="QLBH_RMM.Admin.Report_Users" %>
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
            font-size: 26px;
            color: #0A6847;
            margin-bottom: 20px;
        }

        .statistic-container {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
        }

        .statistic-box {
            flex: 1;
            background-color: #ffffff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .statistic-box h4 {
            font-size: 22px;
            color: #0A6847;
            margin-bottom: 10px;
        }

        .table-container {
            margin-top: 30px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        th, td {
            padding: 12px;
            text-align: left;
            border: 1px solid #ddd;
        }

        th {
            background-color: #0A6847;
            color: white;
        }

        .table-primary {
            background-color: #e9f5f0;
        }

        .table-secondary {
            background-color: #f0e9f5;
        }

        .table-tertiary {
            background-color: #f5f0e9;
        }

        .btn {
            background-color: #0A6847;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .btn:hover {
            background-color: #005f4f;
        }
        .scrollable-table {
            max-height: 400px; 
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
        <h3>Báo Cáo Người Dùng</h3>

        <asp:Button ID="btnExportBoth" runat="server" Text="Xuất Báo Cáo" CssClass="btn" OnClick="btnXuatBaoCao_Click" />
        <div class="statistic-container">
            <div class="statistic-box">
                <h4>Tổng Số Người Dùng</h4>
                <asp:Label ID="lblTotalUsers" runat="server" Text="0" Font-Bold="True" Font-Size="Large"></asp:Label>
            </div>
            </div>

                <h4>Người Dùng Mới</h4>
         <div class="scrollable-table">
                <asp:GridView ID="gdvNewUsers" runat="server" AutoGenerateColumns="false" CssClass="table-primary">
                    <Columns>
                        <asp:BoundField DataField="MaKH" HeaderText="Mã Khách Hàng" />
                        <asp:BoundField DataField="TenKH" HeaderText="Tên Khách Hàng" />
                        <asp:BoundField DataField="Email" HeaderText="Email" />
                        <asp:BoundField DataField="NgayTao" HeaderText="Ngày Đăng Ký" DataFormatString="{0:dd/MM/yyyy}" />
                    </Columns>
                </asp:GridView>
             </div>


                <h4>Hoạt Động Của Người Dùng</h4>
              <div class="scrollable-table">
                <asp:GridView ID="gdvUserActivity" runat="server" AutoGenerateColumns="false" CssClass="table-secondary">
                    <Columns>
                        <asp:BoundField DataField="MaKH" HeaderText="Mã Khách Hàng" />
                        <asp:BoundField DataField="TenKH" HeaderText="Tên Khách Hàng" />
                        <asp:BoundField DataField="SoDonHang" HeaderText="Số Đơn Hàng" />
                        <asp:BoundField DataField="SoDiem" HeaderText="Số Điểm Tích Lũy" />
                        <asp:BoundField DataField="DiemDaSuDung" HeaderText="Điểm Đã Sử Dụng" />
                        <asp:BoundField DataField="TenHang" HeaderText="Hạng Thành Viên" />
                        <asp:BoundField DataField="TongChiTieu" HeaderText="Tổng Chi Tiêu" DataFormatString="{0:0,000}" />
                    </Columns>
                </asp:GridView>
                  </div>


        <h4>Người Dùng Không Hoạt Động</h4>
        <div class="scrollable-table">
        <asp:GridView ID="gdvInactiveUsers" runat="server" AutoGenerateColumns="false" CssClass="table-tertiary">
            <Columns>
                <asp:BoundField DataField="MaKH" HeaderText="Mã Khách Hàng" />
                <asp:BoundField DataField="TenKH" HeaderText="Tên Khách Hàng" />
                <asp:BoundField DataField="Email" HeaderText="Email" />
                <asp:BoundField DataField="NgayCuoiHoatDong" HeaderText="Ngày Cuối Hoạt Động" DataFormatString="{0:dd/MM/yyyy}" />
            </Columns>
        </asp:GridView>
            </div>
    </div>
</asp:Content>