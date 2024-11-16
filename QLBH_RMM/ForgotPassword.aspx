<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="QLBH_RMM.ForgotPassword1" %>
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
            margin-top: 80px;
            max-width: 800px;
            background-color: #fff;
            border-radius: 8px;
            padding: 20px; 
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
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
            flex: 0 0 175px; /* Fixed width for labels */
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
            margin: 0 10px; /* Space between links */
        }

        .auto-style1 {
            height: 31px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <div class="wizard-container">
        <div class="container">
            <asp:PasswordRecovery ID="PasswordRecovery1" runat="server" AnswerLabelText="Trả lời:" AnswerRequiredErrorMessage="Vui lòng nhập câu trả lời." GeneralFailureText="Đăng ký nhận mật khẩu không thành công. Vui lòng thử lại." QuestionFailureText="Câu trả lời của bạn không được xác minh. Vui lòng thử lại." QuestionInstructionText="Trả lời câu hỏi để nhận mật khẩu mới." QuestionLabelText="Câu hỏi bảo mật:" QuestionTitleText="Xác nhận danh tính:" SubmitButtonText="Gửi" SuccessText="Mật khẩu mới đã được gửi thành công." UserNameFailureText="Chúng tôi không thể truy cập thông tin của bạn. Vui lòng thử lại." UserNameInstructionText="Nhập tên đăng nhập của bạn để nhận mật khẩu." UserNameLabelText="Tên đăng nhập:" UserNameRequiredErrorMessage="Vui lòng nhập tên đăng nhập." UserNameTitleText="Quên mật khẩu?">
                <SubmitButtonStyle CssClass="btn" />
                <QuestionTemplate>
                    <table cellpadding="1" cellspacing="0" style="border-collapse:collapse;">
                        <tr>
                            <td>
                                <table cellpadding="0">
                                    <tr>
                                     <td align="center" colspan="2"><h2>Xác nhận danh tính</h2></td>
                                    </tr>
                                    <tr>
                                        <td align="center" colspan="2">Trả lời câu hỏi để nhận mật khẩu mới.</td>
                                    </tr>
                                    <tr>
                                        <td align="right">Tên đăng nhập:</td>
                                        <td>
                                            <asp:Literal ID="UserName" runat="server"></asp:Literal>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">Câu hỏi bảo mật:</td>
                                        <td>
                                            <asp:Literal ID="Question" runat="server"></asp:Literal>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <asp:Label ID="AnswerLabel" runat="server" AssociatedControlID="Answer">Trả lời:</asp:Label>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="Answer" runat="server"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="AnswerRequired" runat="server" ControlToValidate="Answer" ErrorMessage="Vui lòng nhập câu trả lời." ToolTip="Vui lòng nhập câu trả lời." ValidationGroup="PasswordRecovery1">*</asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="center" colspan="2" style="color:Red;">
                                            <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" colspan="2">
                                            <asp:Button ID="SubmitButton" runat="server" CommandName="Submit" CssClass="btn" Text="Gửi" ValidationGroup="PasswordRecovery1" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </QuestionTemplate>
                <UserNameTemplate>
                    <table cellpadding="1" cellspacing="0" style="border-collapse:collapse;">
                        <tr>
                            <td>
                                <table cellpadding="0">
                                    <tr>
                                     <td align="center" colspan="2"><h2>Quên mật khẩu</h2></td>
                                    </tr>
                                    <tr>
                                        <td align="center" colspan="2">Nhập tên đăng nhập của bạn để nhận mật khẩu.</td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName">Tên đăng nhập:</asp:Label>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="UserName" runat="server"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName" ErrorMessage="Vui lòng nhập tên đăng nhập." ToolTip="Vui lòng nhập tên đăng nhập." ValidationGroup="PasswordRecovery1">*</asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="center" colspan="2" style="color:Red;">
                                            <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" colspan="2">
                                            <asp:Button ID="SubmitButton" runat="server" CommandName="Submit" CssClass="btn" Text="Gửi" ValidationGroup="PasswordRecovery1" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </UserNameTemplate>
            </asp:PasswordRecovery>
    <div class="extra-options">
                <asp:HyperLink ID="LoginLink" runat="server" NavigateUrl="~/Login.aspx">Đăng nhập</asp:HyperLink>
                <asp:HyperLink ID="RegisterLink" runat="server" NavigateUrl="~/Register.aspx">Đăng ký</asp:HyperLink>
            </div>
        </div>
    </div>
</asp:Content>
