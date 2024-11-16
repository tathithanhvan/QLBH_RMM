<%@ Page Title="Thêm Sản Phẩm" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AddProduct.aspx.cs" Inherits="QLBH_RMM.Admin.AddProduct" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .product-management {
            margin: 50px auto;
            padding: 20px;
            max-width: 800px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        .product-management h2 {
            color: #0A6847;
            text-align: center;
            margin-bottom: 20px;
        }
        .form-container {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        .input {
            padding: 10px;
            border: 1px solid #e0e0e0;
            border-radius: 4px;
        }
        .btn-container {
            display: flex;
            justify-content: center;
            gap: 15px;
        }
        .btn {
            padding: 10px;
            background-color: #0A6847;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .btn:hover {
            background-color: #007B5F;
        }
        .btn-back {
            background-color: #007B5F;
        }
        .btn-back:hover {
            background-color: #005b4a;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="product-management">
        <h2>Thêm Sản Phẩm</h2>
        <div class="form-container">
            <asp:DropDownList ID="ddlProductType" runat="server" CssClass="input">
                <asp:ListItem Text="Chọn loại sản phẩm" Value=""></asp:ListItem>
                <asp:ListItem Text="Combo" Value="CB"></asp:ListItem>
                <asp:ListItem Text="Món Ăn Vặt" Value="MAV"></asp:ListItem>
                <asp:ListItem Text="Rau Má Mix" Value="RMM"></asp:ListItem>
                <asp:ListItem Text="Rau Má Mix Sữa Hạt" Value="RMSH"></asp:ListItem>
                <asp:ListItem Text="Sữa Hạt Dinh Dưỡng" Value="SH"></asp:ListItem>
            </asp:DropDownList>
            <asp:TextBox ID="txtProductCode" runat="server" CssClass="input" placeholder="Mã Sản Phẩm"></asp:TextBox>
            <asp:TextBox ID="txtProductName" runat="server" CssClass="input" placeholder="Tên Sản Phẩm"></asp:TextBox>
            <asp:DropDownList ID="ddlSize" runat="server" CssClass="input">
                <asp:ListItem Text="Chọn kích cỡ" Value=""></asp:ListItem>
            </asp:DropDownList>
            <asp:TextBox ID="txtPrice" runat="server" CssClass="input" placeholder="Đơn Giá"></asp:TextBox>
            <asp:TextBox ID="txtDescription" runat="server" CssClass="input" TextMode="MultiLine" Rows="4" placeholder="Mô Tả"></asp:TextBox>
            <asp:FileUpload ID="fuProductImage" runat="server" CssClass="input" />
            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="input">
                <asp:ListItem Text="Chọn tình trạng" Value=""></asp:ListItem>
                <asp:ListItem Text="Đang hoạt động" Value="1"></asp:ListItem>
                <asp:ListItem Text="Không hoạt động" Value="0"></asp:ListItem>
            </asp:DropDownList>
        </div>
        <div class="btn-container">
            <asp:Button ID="btnSave" runat="server" Text="Lưu" CssClass="btn" OnClick="btnSave_Click" />
            <asp:Button ID="btnCancel" runat="server" Text="Hủy" CssClass="btn" OnClick="btnCancel_Click" />
        </div>
    </div>
</asp:Content>
