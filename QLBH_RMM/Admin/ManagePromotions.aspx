<%@ Page Title="Quản Lý Khuyến Mãi" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManagePromotions.aspx.cs" Inherits="QLBH_RMM.Admin.Promotions" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet" />
    <style>
         body {
            font-family: Arial, sans-serif;
            background-color: #f5fff3;
            margin: 0;
            display: flex;
        }
        .promotion-dashboard {
            margin-top: 50px;
            padding: 30px;
            background-color: #f9f9f9;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .promotion-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .promotion-filters {
            margin-bottom: 20px;
        }

        .promotion-table {
            width: 100%;
            margin-top: 20px;
            background-color: #fff;
        }
        h3 {
            color: #0A6847;
            margin-bottom: 20px;
        }
        h2 {
            color: #0A6847;
            margin-bottom: 15px;
            text-align: center;
        }
        .add-promotion-section {
            margin-top: 20px;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .form-control {
            margin-bottom: 10px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="promotion-dashboard">
        <div class="promotion-header">
            <h2>Danh Sách Khuyến Mãi</h2>
            <asp:Button ID="btnAddPromotion" runat="server" Text="Thêm Khuyến Mãi" CssClass="btn btn-primary" OnClick="btnAddPromotion_Click" />
        </div>

        <div class="promotion-filters">
            <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Tìm Khuyến Mãi" />
            <asp:DropDownList ID="ddlTrangThai" runat="server" CssClass="form-control">
                <asp:ListItem Text="Tất cả" Value="" />
                <asp:ListItem Text="Đang diễn ra" Value="Hoạt động" />
                <asp:ListItem Text="Không hoạt động" Value="Không hoạt động" />
            </asp:DropDownList>
            <div class="row">
                <div class="col">
                    <asp:TextBox ID="txtNgayBatDauFilter" runat="server" CssClass="form-control" TextMode="Date" />
                </div>
                <div class="col">
                    <asp:TextBox ID="txtNgayKetThucFilter" runat="server" CssClass="form-control" TextMode="Date" />
                </div>
            </div>
            <asp:DropDownList ID="ddlKieuGiamGia" runat="server" CssClass="form-control">
                <asp:ListItem Text="Tất cả" Value="" />
                <asp:ListItem Text="Giảm giá theo phần trăm" Value="PT" />
                <asp:ListItem Text="Giảm giá theo số tiền" Value="TN" />
            </asp:DropDownList>
            <asp:Button ID="btnFilter" runat="server" Text="Lọc" CssClass="btn btn-success mt-2" OnClick="btnFilter_Click" />
        </div>

        <asp:Panel ID="pnlAddPromotion" runat="server" CssClass="add-promotion-section" Visible="false">
            <h5>Thêm Khuyến Mãi</h5>
            <div class="row mb-2">
                <div class="col-md-4">
                    <asp:Label ID="lblAddMaKM" runat="server" Text="Mã Khuyến Mãi:" CssClass="form-label" />
                    <asp:TextBox ID="txtAddMaKM" runat="server" CssClass="form-control" placeholder="Mã Khuyến Mãi" />
                </div>
                <div class="col-md-4">
                    <asp:Label ID="lblAddTenKM" runat="server" Text="Tên Khuyến Mãi:" CssClass="form-label" />
                    <asp:TextBox ID="txtAddTenKM" runat="server" CssClass="form-control" placeholder="Tên Khuyến Mãi" />
                </div>
                <div class="col-md-4">
                    <asp:Label ID="lblAddNgayBatDau" runat="server" Text="Ngày Bắt Đầu:" CssClass="form-label" />
                    <asp:TextBox ID="txtAddNgayBatDau" runat="server" CssClass="form-control" TextMode="Date" />
                </div>
            </div>

            <div class="row mb-2">
                <div class="col-md-4">
                    <asp:Label ID="lblAddNgayKetThuc" runat="server" Text="Ngày Kết Thúc:" CssClass="form-label" />
                    <asp:TextBox ID="txtAddNgayKetThuc" runat="server" CssClass="form-control" TextMode="Date" />
                </div>
                <div class="col-md-4">
                    <asp:Label ID="lblAddGiamGia" runat="server" Text="Giảm Giá:" CssClass="form-label" />
                    <asp:TextBox ID="txtAddGiamGia" runat="server" CssClass="form-control" placeholder="Giảm Giá" />
                </div>
                <div class="col-md-4">
                    <asp:Label ID="lblAddKieuGiamGia" runat="server" Text="Kiểu Giảm Giá:" CssClass="form-label" />
                    <asp:DropDownList ID="ddlAddKieuGiamGia" runat="server" CssClass="form-control">
                        <asp:ListItem Text="Giảm giá theo phần trăm" Value="PT" />
                        <asp:ListItem Text="Giảm giá theo số tiền" Value="TN" />
                    </asp:DropDownList>
                </div>
            </div>

            <div class="row mb-2">
                <div class="col-md-4">
                    <asp:Label ID="lblAddTrangThai" runat="server" Text="Trạng Thái:" CssClass="form-label" />
                    <asp:DropDownList ID="ddlAddTrangThai" runat="server" CssClass="form-control">
                        <asp:ListItem Text="Đang diễn ra" Value="Hoạt động" />
                        <asp:ListItem Text="Không hoạt động" Value="Không hoạt động" />
                    </asp:DropDownList>
                </div>
                <div class="col-md-4">
                    <asp:Label ID="lblAddMemberLevel" runat="server" Text="Hạng Thành Viên:" CssClass="form-label" />
                    <asp:DropDownList ID="ddlAddMemberLevel" runat="server" CssClass="form-control">
                        <asp:ListItem Text="Tất cả" Value="" />
                        <asp:ListItem Text="Hạt mầm" Value="1" />
                        <asp:ListItem Text="Chồi non" Value="2" />
                        <asp:ListItem Text="Lá nhỏ" Value="3" />
                        <asp:ListItem Text="Lá xanh" Value="4" />
                        <asp:ListItem Text="Siêu rau má" Value="5" />
                    </asp:DropDownList>
                </div>
                <div class="col-md-4">
                    <asp:Label ID="lblAddMinOrderValue" runat="server" Text="Giá Trị Đơn Hàng Tối Thiểu:" CssClass="form-label" />
                    <asp:TextBox ID="txtAddMinOrderValue" runat="server" CssClass="form-control" placeholder="Giá Trị Đơn Hàng Tối Thiểu" />
                </div>
            </div>

            <div class="row mb-2">
                <div class="col-md-4">
                    <asp:Label ID="lblAddMaxQuantity" runat="server" Text="Số Lượng Tối Đa:" CssClass="form-label" />
                    <asp:TextBox ID="txtAddMaxQuantity" runat="server" CssClass="form-control" placeholder="Số Lượng Tối Đa" />
                </div>
                <div class="col-md-8">
                    <asp:Label ID="lblAddMoTa" runat="server" Text="Mô Tả:" CssClass="form-label" />
                    <asp:TextBox ID="txtAddMoTa" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Mô Tả" />
                </div>
            </div>

            <asp:Label ID="lblAddMessage" runat="server" Text="" CssClass="mt-3" ForeColor="Green" Visible="false" />
            <br />
            <asp:Button ID="btnSavePromotion" runat="server" Text="Lưu" CssClass="btn btn-primary mt-2" OnClick="btnSavePromotion_Click" />
            <asp:Button ID="btnCancelAdd" runat="server" Text="Hủy" CssClass="btn btn-secondary mt-2" OnClick="btnCancelAdd_Click" />
        </asp:Panel>

        <asp:Panel ID="pnlEditPromotion" runat="server" CssClass="add-promotion-section" Visible="false">
            <h5>Sửa Khuyến Mãi</h5>
            <div class="row mb-2">
                <div class="col-md-4">
                    <asp:Label ID="lblEditMaKM" runat="server" Text="Mã Khuyến Mãi:" CssClass="form-label" />
                    <asp:TextBox ID="txtEditMaKM" runat="server" CssClass="form-control" ReadOnly="true" placeholder="Mã Khuyến Mãi" />
                </div>
                <div class="col-md-4">
                    <asp:Label ID="lblEditTenKM" runat="server" Text="Tên Khuyến Mãi:" CssClass="form-label" />
                    <asp:TextBox ID="txtEditTenKM" runat="server" CssClass="form-control" placeholder="Tên Khuyến Mãi" />
                </div>
                <div class="col-md-4">
                    <asp:Label ID="lblEditNgayBatDau" runat="server" Text="Ngày Bắt Đầu:" CssClass="form-label" />
                    <asp:TextBox ID="txtEditNgayBatDau" runat="server" CssClass="form-control" TextMode="Date" />
                </div>
            </div>

            <div class="row mb-2">
                <div class="col-md-4">
                    <asp:Label ID="lblEditNgayKetThuc" runat="server" Text="Ngày Kết Thúc:" CssClass="form-label" />
                    <asp:TextBox ID="txtEditNgayKetThuc" runat="server" CssClass="form-control" TextMode="Date" />
                </div>
                <div class="col-md-4">
                    <asp:Label ID="lblEditGiamGia" runat="server" Text="Giảm Giá:" CssClass="form-label" />
                    <asp:TextBox ID="txtEditGiamGia" runat="server" CssClass="form-control" placeholder="Giảm Giá" />
                </div>
                <div class="col-md-4">
                    <asp:Label ID="lblEditKieuGiamGia" runat="server" Text="Kiểu Giảm Giá:" CssClass="form-label" />
                    <asp:DropDownList ID="ddlEditKieuGiamGia" runat="server" CssClass="form-control">
                        <asp:ListItem Text="Giảm giá theo phần trăm" Value="PT" />
                        <asp:ListItem Text="Giảm giá theo số tiền" Value="TN" />
                    </asp:DropDownList>
                </div>
            </div>

            <div class="row mb-2">
                <div class="col-md-4">
                    <asp:Label ID="lblEditTrangThai" runat="server" Text="Trạng Thái:" CssClass="form-label" />
                    <asp:DropDownList ID="ddlEditTrangThai" runat="server" CssClass="form-control">
                        <asp:ListItem Text="Đang diễn ra" Value="Hoạt động" />
                        <asp:ListItem Text="Không hoạt động" Value="Không hoạt động" />
                    </asp:DropDownList>
                </div>
                <div class="col-md-4">
                    <asp:Label ID="lblEditMaHang" runat="server" Text="Hạng Thành Viên:" CssClass="form-label" />
                    <asp:DropDownList ID="ddlEditMaHang" runat="server" CssClass="form-control">
                        <asp:ListItem Text="Tất cả" Value="" />
                        <asp:ListItem Text="Hạt mầm" Value="1" />
                        <asp:ListItem Text="Chồi non" Value="2" />
                        <asp:ListItem Text="Lá nhỏ" Value="3" />
                        <asp:ListItem Text="Lá xanh" Value="4" />
                        <asp:ListItem Text="Siêu rau má" Value="5" />
                    </asp:DropDownList>
                </div>
                <div class="col-md-4">
                    <asp:Label ID="lblEditNgayTao" runat="server" Text="Ngày Tạo:" CssClass="form-label" />
                    <asp:TextBox ID="txtEditNgayTao" runat="server" CssClass="form-control" ReadOnly="true" placeholder="Ngày Tạo" />
                </div>
            </div>

            <div class="row mb-2">
                <div class="col-md-4">
                    <asp:Label ID="lblEditNgayCapNhat" runat="server" Text="Ngày Cập Nhật:" CssClass="form-label" />
                    <asp:TextBox ID="txtEditNgayCapNhat" runat="server" CssClass="form-control" ReadOnly="true" placeholder="Ngày Cập Nhật" />
                </div>
                <div class="col-md-4">
                    <asp:Label ID="lblEditGiaTriDonHangToiThieu" runat="server" Text="Giá Trị Đơn Hàng Tối Thiểu:" CssClass="form-label" />
                    <asp:TextBox ID="txtEditGiaTriDonHangToiThieu" runat="server" CssClass="form-control" placeholder="Giá Trị Đơn Hàng Tối Thiểu" />
                </div>
                <div class="col-md-4">
                    <asp:Label ID="lblEditSoLuongToiDa" runat="server" Text="Số Lượng Tối Đa:" CssClass="form-label" />
                    <asp:TextBox ID="txtEditSoLuongToiDa" runat="server" CssClass="form-control" placeholder="Số Lượng Tối Đa" />
                </div>
            </div>

            <div class="row mb-2">
                <div class="col-md-4">
                    <asp:Label ID="lblEditSoLuongDaSuDung" runat="server" Text="Số Lượng Đã Sử Dụng:" CssClass="form-label" />
                    <asp:TextBox ID="txtEditSoLuongDaSuDung" runat="server" CssClass="form-control" ReadOnly="true" placeholder="Số Lượng Đã Sử Dụng" />
                </div>
                <div class="col-md-8">
                    <asp:Label ID="lblEditMoTa" runat="server" Text="Mô Tả:" CssClass="form-label" />
                    <asp:TextBox ID="txtEditMoTa" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Mô Tả" />
                </div>
            </div>
            <asp:Label ID="lblEditMessage" runat="server" Text="" CssClass="mt-3" ForeColor="Green" Visible="false" />
            <br />
            <asp:Button ID="btnUpdatePromotion" runat="server" Text="Cập Nhật" CssClass="btn btn-primary mt-2" OnClick="btnUpdatePromotion_Click" />
            <asp:Button ID="btnCancelEdit" runat="server" Text="Hủy" CssClass="btn btn-secondary mt-2" OnClick="btnCancelEdit_Click" />
        </asp:Panel>


        <asp:GridView ID="GridView1" runat="server" CssClass="table table-bordered promotion-table" 
            AutoGenerateColumns="False" AllowPaging="True" DataSourceID="SqlDataSource1" 
            OnRowCommand="GridView1_RowCommand" DataKeyNames="MaKM">
            <Columns>
                <asp:BoundField DataField="MaKM" HeaderText="Mã Khuyến Mãi" />
                <asp:BoundField DataField="TenKM" HeaderText="Tên Khuyến Mãi" />
                <asp:BoundField DataField="NgayBatDau" HeaderText="Ngày Bắt Đầu" DataFormatString="{0:yyyy-MM-dd}" />
                <asp:BoundField DataField="NgayKetThuc" HeaderText="Ngày Kết Thúc" DataFormatString="{0:yyyy-MM-dd}" />
                <asp:BoundField DataField="GiamGia" HeaderText="Giảm Giá" DataFormatString="{0:N2}" />
                <asp:BoundField DataField="KieuGiamGia" HeaderText="Kiểu Giảm Giá" />
                <asp:BoundField DataField="TrangThai" HeaderText="Trạng Thái" />
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Button ID="btnEdit" runat="server" CssClass="btn btn-warning btn-sm" Text="Sửa" 
                            CommandName="EditPromotion" CommandArgument='<%# Eval("MaKM") %>' />
                        <asp:Button ID="btnDelete" runat="server" CssClass="btn btn-danger btn-sm" Text="Xóa" 
                             CommandName="DeletePromotion" CommandArgument='<%# Eval("MaKM") %>' 
                             OnClientClick="return confirmDelete();" />
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>
        </asp:GridView>
        <script type="text/javascript">
            function confirmDelete() {
                return confirm("Bạn có chắc chắn muốn xóa khuyến mãi này?");
            }
        </script>
       

        <asp:SqlDataSource ID="SqlDataSource1" runat="server"
            ConnectionString="<%$ ConnectionStrings:QuanLyBanHang_SP_ConnectionString %>"
            SelectCommand="SELECT * FROM KhuyenMai">
        </asp:SqlDataSource>
    </div>
</asp:Content>
