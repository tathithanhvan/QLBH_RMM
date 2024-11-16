<%@ Page Title="Đổi Mật Khẩu" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="ChangePassword.aspx.cs" Inherits="QLBH_RMM.Customer.ChangePassword" %>

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
        }
        .sidebar a:hover {
            text-decoration: underline;
        }
        .content {
            margin-left: 25%; 
            padding: 20px;
            flex-grow: 1;
            min-height: 100vh; 
            box-sizing: border-box; 
        }
        .container {
            max-width: 600px;
            margin: 20px auto; 
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
        h1 {
            text-align: center;
            color: #0A6847;
            font-size: 28px;
            margin-bottom: 30px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #333;
        }
        input[type="password"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 14px;
            background-color: #fff;
        }
        input[type="password"]:focus {
            border-color: #0A6847;
            outline: none;
            box-shadow: 0 0 5px rgba(10, 104, 71, 0.3);
        }
        .button-container {
            display: flex;
            justify-content: space-between; 
            margin-top: 20px;
        }
        .update-button,
        .back-button {
            background-color: #0A6847;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            width: 48%; 
            transition: background-color 0.3s, transform 0.2s;
        }
        .update-button:hover,
        .back-button:hover {
            background-color: #0e805a;
            transform: translateY(-2px);
        }
        .update-button:active,
        .back-button:active {
            transform: translateY(0);
        }
        @media (max-width: 768px) {
            .container {
                padding: 20px;
            }
            .update-button,
            .back-button {
                width: 100%; 
                margin-top: 10px; 
            }
        }
        .btn {
            background-color: #0A6847;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            width: 100%;
            margin-top: 10px;
            font-size: 16px;
        }

        .btn:hover {
            background-color: #00796b;
        }

        .error-message {
            color: red;
            font-size: 12px;
        }
                /* Centering form content */
        .wizard-container {
            display: flex;
            justify-content: center; /* Center horizontally */
            align-items: center; /* Center vertically */
            height: 100%;
            padding: 20px;
        }
        .extra-options {
            text-align: center;
            margin-top: 10px;
        }

        .extra-options a {
            color: #0A6847;
            text-decoration: none;
            margin: 0 10px; /* Thêm khoảng cách giữa các liên kết */
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="sidebar">
         <h2>Tài Khoản</h2>
        <a href="ThongTinCaNhan.aspx">Thông Tin Cá Nhân</a>
        <a href="LichSuGiaoDich.aspx">Lịch Sử Đặt Hàng</a>
        <a href="Diem.aspx">Điểm Tích Lũy</a>
        <a href="Voucher.aspx">Voucher Của Tôi</a>
        <a href="ChangePassword.aspx">Đổi Mật Khẩu</a>
        <a href="DangXuat.aspx">Đăng Xuất</a>
    </div>
    <div class="content">
            <div class="wizard-container">

        <div class="container">
            <h1>Đổi Mật Khẩu</h1>
       
        <asp:ChangePassword ID="ChangePassword1" runat="server" CancelButtonText="Hủy" ChangePasswordButtonText="Xác nhận">
            <ChangePasswordTemplate>
                <table cellpadding="1" cellspacing="0" style="border-collapse:collapse;">
                    <tr>
                        <td>
                            <table cellpadding="0">
                                <tr>
                                    <td align="right">
                                        <asp:Label ID="CurrentPasswordLabel" runat="server" AssociatedControlID="CurrentPassword">Mật khẩu hiện tại:</asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="CurrentPassword" runat="server" TextMode="Password"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="CurrentPasswordRequired" runat="server" ControlToValidate="CurrentPassword" ErrorMessage="Vui lòng nhập mật khẩu hiện tại." ToolTip="Password is required." ValidationGroup="ChangePassword1">*</asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <asp:Label ID="NewPasswordLabel" runat="server" AssociatedControlID="NewPassword">Mật khẩu mới:</asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="NewPassword" runat="server" TextMode="Password"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="NewPasswordRequired" runat="server" ControlToValidate="NewPassword" ErrorMessage="VUi lòng nhập mật khẩu mới." ToolTip="New Password is required." ValidationGroup="ChangePassword1">*</asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <asp:Label ID="ConfirmNewPasswordLabel" runat="server" AssociatedControlID="ConfirmNewPassword">Xác nhận mật khẩu:</asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="ConfirmNewPassword" runat="server" TextMode="Password"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="ConfirmNewPasswordRequired" runat="server" ControlToValidate="ConfirmNewPassword" ErrorMessage="Vui lòng nhập xác nhận mật khẩu." ToolTip="Confirm New Password is required." ValidationGroup="ChangePassword1">*</asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="center" colspan="2">
                                        <asp:CompareValidator ID="NewPasswordCompare" runat="server" ControlToCompare="NewPassword" ControlToValidate="ConfirmNewPassword" Display="Dynamic" ErrorMessage="Mật khẩu mới và xác nhận mật khẩu không trùng khớp." ValidationGroup="ChangePassword1"></asp:CompareValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="center" colspan="2" style="color:Red;">
                                        <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <asp:Button ID="ChangePasswordPushButton" runat="server" CommandName="ChangePassword" Text="Xác nhận" ValidationGroup="ChangePassword1" CssClass="btn" />
                                    </td>
                                    <td>
                                        <asp:Button ID="CancelPushButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Hủy" CssClass="btn" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </ChangePasswordTemplate>
            <SuccessTemplate>
                <table cellpadding="1" cellspacing="0" style="border-collapse:collapse;">
                    <tr>
                        <td>
                            <table cellpadding="0">
                                <tr>
                                    <td align="center" colspan="2">Hoàn Thành</td>
                                </tr>
                                <tr>
                                    <td>Mật khẩu mới đã được cập nhật!</td>
                                </tr>
                                <tr>
                                    <td align="right" colspan="2">
                                        <asp:Button ID="ContinuePushButton" runat="server" CausesValidation="False" CommandName="Continue" Text="Continue" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </SuccessTemplate>
        </asp:ChangePassword>
    </div>
         </div>
        </div>
</asp:Content>
