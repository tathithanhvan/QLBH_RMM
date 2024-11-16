<%@ Page Title="Giỏ Hàng" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="GioHang.aspx.cs" Inherits="QLBH_RMM.GioHang" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5; 
            margin: 0;
            padding: 0;
        }

        .box-container {
            max-width: 900px; 
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin: 20px auto;
            display: flex;
            flex-direction: column; 
            margin-top: 100px;
        }

        .box-header {
            border-bottom: 2px solid #0A6847; 
            padding-bottom: 10px;
            margin-bottom: 10px;
        }

        .box-header h2 {
            color: #0A6847;
            font-size: 28px;
            margin: 0;
            text-align: left; 
        }

        .box-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border: 1px solid #e0e0e0;
            padding: 15px;
            border-radius: 8px;
            background-color: #f9f9f9;
            transition: box-shadow 0.3s ease;
            margin-bottom: 10px;
        }

        .box-item:hover {
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
        }

        .box-item h3 {
            color: #0A6847;
            margin: 0;
            font-size: 20px;
            text-align: left; 
        }

        .box-item p {
            margin: 5px 0;
            font-size: 14px;
            color: #555; 
            text-align: left; 
        }

        .box-item button {
            background-color: #e74c3c;
            color: #fff;
            border: none;
            padding: 15px 20px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            font-size: 16px;
            margin-left: 10px;
        }

        .box-item button:hover {
            background-color: #c0392b;
        }

        .total-section {
            display: flex;
            justify-content: space-between; 
            align-items: center; 
            font-size: 22px;
            font-weight: bold;
            color: #0A6847;
        }
         .total-left {
            display: flex;
            align-items: center; 
        }

        .total-left span {
            margin-right: 10px;
        }

        .checkout-button {
            background-color: #0A6847;
            color: #fff;
            padding: 12px 20px; 
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 18px; 
            transition: background-color 0.3s ease;
        }

        .checkout-button:hover {
            background-color: #00796b; 
        }

        .quantity-input {
            width: 50px; 
            margin-right: 10px; 
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="box-container">
        <div class="box-header">
            <h2>Giỏ Hàng Của Bạn</h2>
        </div>

        <div class="box-section">
            <asp:ListView ID="CartListView" runat="server" OnItemCommand="CartListView_ItemCommand">
                <ItemTemplate>
                    <div class="box-item">
                        <div>
                            <h3><%# Eval("TenSP") %></h3>
                            <p>Kích thước: <%# Eval("TenSize") %></p>
                            <p>Giá: <%# Eval("DonGia", "{0:0,000}") %> VND</p>                         
                            <p>Topping: <%# Eval("TenTopping") %></p>
                            <p>Ghi chú: <%# Eval("TenGC") %></p>



                            <p>Số lượng topping: 
                               <%# string.IsNullOrEmpty(Eval("TenTopping").ToString()) ? "0" : Eval("TenTopping").ToString().Split(',').Length.ToString() %> 
                               x 7,000 VND</p>
                            <p>Số lượng: 
                                <asp:TextBox ID="QuantityTextBox" runat="server" CssClass="quantity-input" 
                                             Text='<%# Eval("SoLuong") %>' />
                            </p>

                            <!-- Hiển thị tổng giá cho sản phẩm -->
                            <p><strong>Tổng giá: <%# ((decimal)Eval("DonGia") + 
                                 (string.IsNullOrWhiteSpace(Eval("TenTopping").ToString()) ? 0 : Eval("TenTopping").ToString().Split(',').Length * 7000)) 
                                 * (int)Eval("SoLuong") %> VND</strong></p>
                        </div>
                        <div>
                            <asp:Button ID="btnUpdate" runat="server" Text="Cập nhật" 
                                         CommandArgument='<%# Eval("MaSP") %>' 
                                         CommandName="UpdateQuantity" />
                            <asp:Button ID="btnXoa" runat="server" Text="Xóa" 
                                         CommandArgument='<%# Eval("MaSP") %>' 
                                         CommandName="Remove" />
                        </div>
                    </div>
                </ItemTemplate>


            </asp:ListView>
        </div>

        <div class="total-section">
            <div class="total-left">
                <span>Tổng cộng:</span>
                <asp:Label ID="TotalLabel" runat="server" CssClass="total-section" />
            </div>
            <asp:Button ID="btnThanhToan" runat="server" CssClass="checkout-button" OnClick="Checkout_Click" Text="Thanh toán" />
        </div>
    </div>
</asp:Content>
