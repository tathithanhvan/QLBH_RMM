<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="HeThongCuaHang.aspx.cs" Inherits="QLBH_RMM.HeThongCuaHang" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .search-bar {
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 40px 0;
            margin-top: 100px;
        }

        .search-bar input {
            padding: 10px;
            border-radius: 5px 0 0 5px;
            border: 1px solid #ccc;
            font-size: 16px;
        }

        .search-bar button {
            margin-left: 10px;
            background-color: #F6E9B2;
            padding: 5px 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s ease;
        }

        .search-bar button:hover {
            background-color: #0e805a;
        }

        .map-link {
            display: inline-block;
            margin-top: 10px;
            background-color: #0e805a;
            color: white;
            padding: 5px 10px;
            border-radius: 5px;
            text-decoration: none;
        }

        .map-link:hover {
            background-color: #0c6f47;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="search-bar" style="text-align: center; margin-bottom: 20px;">
        <asp:TextBox ID="txtTim" runat="server" placeholder="Tìm kiếm cửa hàng..." style="width: 300px; padding: 10px;"></asp:TextBox>
        <asp:Button ID="btnTim" runat="server" Text="Tìm kiếm" OnClick="btnSearch_Click" style="padding: 10px 20px; margin-left: 10px;" />
    </div>
    <asp:SqlDataSource ID="srcCuaHang" runat="server" ConnectionString="<%$ ConnectionStrings:QuanLyBanHang_SP_ConnectionString %>" SelectCommand="SELECT * FROM [CuaHang]"></asp:SqlDataSource>
    
    <div class="scrollable-container">
        <asp:DataList ID="DataList2" runat="server" DataKeyField="MaCH" DataSourceID="srcCuaHang" CellSpacing="10" HorizontalAlign="Center" RepeatColumns="2" Width="1500px">
            <ItemTemplate>
                <div style="border: 1px solid #ccc; border-radius: 5px; padding: 15px; margin-bottom: 15px; background-color: #f9f9f9;">
                    <h4 style="margin: 0;">Cửa hàng: <asp:Label ID="TenCHLabel" runat="server" Text='<%# Eval("TenCH") %>' /></h4>
                    <p><strong>Địa chỉ:</strong> <asp:Label ID="DiaChiLabel" runat="server" Text='<%# Eval("DiaChi") %>' /></p>
                    <p><strong>SĐT:</strong> <asp:Label ID="SDTLabel" runat="server" Text='<%# Eval("SDT") %>' /></p>
                    <asp:HyperLink ID="lnkGoogleMap" runat="server" CssClass="map-link"
                        NavigateUrl='<%# "https://www.google.com/maps/search/?api=1&query=" + Eval("DiaChi") %>' 
                        Text="Xem trên Google Maps" Target="_blank" />
                </div>
            </ItemTemplate>
        </asp:DataList>
    </div>
</asp:Content>
