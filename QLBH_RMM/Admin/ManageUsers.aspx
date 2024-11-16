<%@ Page Title="Quản Lý Tài Khoản" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageUsers.aspx.cs" Inherits="QLBH_RMM.Admin.ManageUsers" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            font-family: 'Arial', sans-serif; 
            background-color: #f5fff3;
            margin: 0;
        }
        .dashboard-container {
            margin-top: 50px;
            padding: 20px;
            background-color: #f9f9f9;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        h2{
            color: #0A6847;
            margin-bottom: 15px;
            text-align: center;
            font-size: 22px;
        }
        h3 {
            color: #0A6847;
            margin-bottom: 20px;
            font-size: 20px;
        }
        .table-container {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        .scrollable-table {
            max-height: 300px;
            overflow-y: auto;
        }
        .form-section {
            margin-top: 20px;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        .form-control {
            margin-bottom: 10px;
        }
        .btn-primary {
            background-color: #007B5F; /* Màu nút đồng bộ */
            border-color: #007B5F;
        }
        .btn-primary:hover {
            background-color: #005b4a; /* Màu nút khi hover */
            border-color: #005b4a;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container dashboard-container">

        <div class="table-container mt-4">
            <h2><strong>Danh Sách Nhân Viên</strong></h2> 
            <div class="scrollable-table">
                <asp:GridView ID="GridViewEmployees" runat="server" CssClass="table table-striped table-bordered" AutoGenerateColumns="False">
                    <Columns>
                        <asp:BoundField DataField="MaNV" HeaderText="Mã nhân viên" />
                        <asp:BoundField DataField="TenNV" HeaderText="Tên nhân viên" />
                        <asp:BoundField DataField="Email" HeaderText="Email" />
                        <asp:BoundField DataField="SDT" HeaderText="Điện thoại" />
                        <asp:BoundField DataField="MaCV" HeaderText="Chức vụ" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>

        <div class="row mt-4">
            <div class="col-md-6 form-section">
                <h3>Thêm Nhân Viên Mới</h3> 
                <asp:Panel ID="PanelAddEmployee" runat="server">
                    <asp:Label ID="LabelName" runat="server" Text="Tên nhân viên:" AssociatedControlID="TextBoxName"></asp:Label>
                    <asp:TextBox ID="TextBoxName" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:Label ID="LabelGT" runat="server" Text="Giới tính:" AssociatedControlID="ddlGioiTinh"></asp:Label>
                      <asp:DropDownList ID="ddlGioiTinh" runat="server" CssClass="form-control mt-2">
                    <asp:ListItem Value="0">Nữ</asp:ListItem>
                    <asp:ListItem Value="1">Nam</asp:ListItem>
                          </asp:DropDownList>
                    <asp:Label ID="LabelEmail" runat="server" Text="Email:" AssociatedControlID="TextBoxEmail"></asp:Label>
                    <asp:TextBox ID="TextBoxEmail" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:Label ID="LabelPhone" runat="server" Text="Điện thoại:" AssociatedControlID="TextBoxPhone"></asp:Label>
                    <asp:TextBox ID="TextBoxPhone" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:Label ID="LabelPosition" runat="server" Text="Chức vụ:" AssociatedControlID="DropDownListPosition"></asp:Label>
                    <asp:DropDownList ID="DropDownListPosition" runat="server" CssClass="form-control"></asp:DropDownList>
                    <asp:Button ID="ButtonAddEmployee" runat="server" Text="Thêm nhân viên" CssClass="btn btn-primary mt-2" OnClick="ButtonAddEmployee_Click" />
                </asp:Panel>
            </div>

            <div class="col-md-6 form-section">
                <h3>Thêm Tài Khoản Cho Nhân Viên</h3> 
                <asp:Panel ID="PanelAddAccount" runat="server">
                    <asp:Label ID="LabelUsername" runat="server" Text="Tên đăng nhập:" AssociatedControlID="TextBoxUsername"></asp:Label>
                    <asp:TextBox ID="TextBoxUsername" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:Label ID="LabelPassword" runat="server" Text="Mật khẩu:" AssociatedControlID="TextBoxPassword"></asp:Label>
                    <asp:TextBox ID="TextBoxPassword" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                    <asp:Label ID="LabelEmployee" runat="server" Text="Chọn nhân viên:" AssociatedControlID="DropDownListEmployees"></asp:Label>
                    <asp:DropDownList ID="DropDownListEmployees" runat="server" CssClass="form-control"></asp:DropDownList>
                    <asp:Label ID="LabelRole" runat="server" Text="Quyền:" AssociatedControlID="DropDownListRole"></asp:Label>
                    <asp:DropDownList ID="DropDownListRole" runat="server" CssClass="form-control">
                        <asp:ListItem Value="NhanVien">Nhân viên</asp:ListItem>
                        <asp:ListItem Value="QuanLy">Quản lý</asp:ListItem>
                    </asp:DropDownList>
                    <asp:Button ID="ButtonAddAccount" runat="server" Text="Thêm tài khoản" CssClass="btn btn-primary mt-2" OnClick="ButtonAddAccount_Click" />
                </asp:Panel>
            </div>
        </div>

        <div class="form-section mt-4">
            <h3>Quản Lý Quyền Truy Cập</h3>
            <asp:Panel ID="PanelRoleManagement" runat="server">
                <asp:Label ID="LabelSelectEmployee" runat="server" Text="Chọn nhân viên để gán quyền:" AssociatedControlID="ddlNhanVien"></asp:Label>
                <asp:DropDownList ID="ddlNhanVien" runat="server" CssClass="form-control"></asp:DropDownList>
                <asp:DropDownList ID="ddlVaiTro" runat="server" CssClass="form-control mt-2">
                    <asp:ListItem Value="NhanVien">Nhân viên</asp:ListItem>
                    <asp:ListItem Value="QuanLy">Quản lý</asp:ListItem>
                </asp:DropDownList>
                <asp:Button ID="btnGanQuyen" runat="server" Text="Gán quyền" CssClass="btn btn-primary mt-2" OnClick="btnGanQuyen_Click" />
            </asp:Panel>
        </div>
    </div>
</asp:Content>
