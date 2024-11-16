<%@ Page Title="Đăng Nhập" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="QLBH_RMM.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" type="text/css" href="styles.css" />
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5fff3;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 800px; /* Same width as the registration container */
            background-color: #fff;
            border-radius: 8px;
            padding: 10px;
            margin-top: 80px;
        }

        h2 {
            font-size: 26px;
            font-weight: bold;
            color: #0A6847;
            text-align: center;
            margin-bottom: 30px;
        }

        .form-group {
            margin-bottom: 35px;
            display: flex;
            align-items: center;
        }

        .form-group label {
            flex: 0 0 175px; /* Fixed width for label */
            font-weight: bold;
            color: #333;
        }

        .form-group input {
            flex: 1;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
            font-size: 14px;
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
    <div class="wizard-container">
        <div class="container">
            <asp:Login ID="Login1" runat="server" FailureText="Đăng nhập không thành công. Vui lòng thử lại." DestinationPageUrl="~/TrangChu.aspx">
                <LayoutTemplate>
                    <table cellpadding="1" cellspacing="0" style="border-collapse:collapse;">
                        <tr>
                            <td>
                                <table cellpadding="0">
                                    <tr>
                                     <td align="center" colspan="2"><h2>Đăng Nhập</h2></td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName">Tên đăng nhập:</asp:Label>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="UserName" runat="server"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName" ErrorMessage="Vui lòng nhập tên đăng nhập." ToolTip="User Name is required." ValidationGroup="Login1">*</asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password">Mật khẩu:</asp:Label>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="Password" runat="server" TextMode="Password"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password" ErrorMessage="Vui lòng nhập mật khẩu." ToolTip="Password is required." ValidationGroup="Login1">*</asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <asp:CheckBox ID="RememberMe" runat="server" Text="Ghi nhớ mật khẩu." Font-Italic="True" Enabled="True" Checked="True" OnCheckedChanged="Login1_LoggedIn" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="center" colspan="2" style="color:Red;">
                                            <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" colspan="2">
                                            <asp:Button ID="LoginButton" runat="server" CommandName="Login" Text="Đăng nhập" ValidationGroup="Login1" CssClass="btn" OnClick="Login1_LoggedIn" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </LayoutTemplate>
            </asp:Login>
             <div class="extra-options">
                <asp:HyperLink ID="ForgotPasswordLink" runat="server" NavigateUrl="~/ForgotPassword.aspx">Quên mật khẩu?</asp:HyperLink>
                <asp:HyperLink ID="RegisterLink" runat="server" NavigateUrl="~/Register.aspx">Đăng ký</asp:HyperLink>
            </div>
        </div>
    </div>
</asp:Content>

