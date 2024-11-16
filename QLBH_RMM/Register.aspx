<%@ Page Title="Đăng Ký" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="QLBH_RMM.Register" %>

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
            margin-top:80px;
            max-width: 800px; 
            background-color: #fff;
            border-radius: 8px;
            padding: 10px;
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
            flex: 0 0 175px; /* Đặt chiều rộng cố định cho label */
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
            justify-content: center; /* Căn giữa ngang */
            align-items: center; /* Căn giữa dọc */
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
            margin: 0 10px; 
        }

    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <div class="wizard-container">
        <div class="container">
            <asp:CreateUserWizard ID="CreateUserWizard1" runat="server" AnswerLabelText="Câu hỏi bảo mật:" AnswerRequiredErrorMessage="Vui lòng nhập câu trả lời." CompleteSuccessText="Tạo tài khoản thành công! Tài khoản mới đã được tạo." ConfirmPasswordCompareErrorMessage="Mật khẩu xác nhận không trùng khớp. Vui lòng thử lại." ConfirmPasswordLabelText="Xác nhận mật khẩu:" ConfirmPasswordRequiredErrorMessage="Vui lòng xác nhận mật khẩu." ContinueButtonText="Tiếp tục" CreateUserButtonText="Đăng Ký" DuplicateEmailErrorMessage="Địa chỉ Email đã được sử dụng. Vui lòng nhập Email khác." DuplicateUserNameErrorMessage="Tên đăng nhập đã được sử dụng. Vui lòng nhập tên đăng nhập khác." EmailRegularExpressionErrorMessage="Vui lòng nhập địa chỉ Email khác." EmailRequiredErrorMessage="Vui lòng nhập địa chỉ Email." FinishCompleteButtonText="Hoàn thành" FinishPreviousButtonText="Trở lại" InvalidAnswerErrorMessage="Vui lòng nhập câu trả lời." InvalidEmailErrorMessage="Vui lòng nhập địa chỉ Email." InvalidPasswordErrorMessage="Độ dài mật khẩu tối thiểu: {0}. Yêu cầu ký tự không phải chữ số và chữ cái: {1}." InvalidQuestionErrorMessage="Vui lòng nhập câu hỏi bảo mật khác." PasswordLabelText="Mật khẩu:" PasswordRegularExpressionErrorMessage="Vui lòng thử mật khẩu khác." PasswordRequiredErrorMessage="Vui lòng nhập mật khẩu." QuestionLabelText="Câu hỏi bảo mật:" QuestionRequiredErrorMessage="Vui lòng nhập câu hỏi bảo mật." StartNextButtonText="Tiếp tục" StepNextButtonText="Tiếp tục" StepPreviousButtonText="Trở về" UnknownErrorMessage="Tạo tài khoản không thành công. Vui lòng thử lại." UserNameLabelText="Tên đăng nhập:" UserNameRequiredErrorMessage="Vui lòng nhập tên đăng nhập." OnCreatedUser="CreateUserWizard1_CreatedUser" ContinueDestinationPageUrl="~/Login.aspx">
                <CreateUserButtonStyle CssClass="btn" />
                <WizardSteps>
                    <asp:CreateUserWizardStep ID="CreateUserWizardStep1" runat="server">
                        <ContentTemplate>
                            <table>
                                <tr>
                                     <td align="center" colspan="2"><h2>Đăng Ký</h2></td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName">Tên đăng nhập:</asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="UserName" runat="server"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName" ErrorMessage="Vui lòng nhập tên đăng nhập." ToolTip="Vui lòng nhập tên đăng nhập." ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password">Mật khẩu:</asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="Password" runat="server" TextMode="Password"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password" ErrorMessage="Vui lòng nhập mật khẩu." ToolTip="Vui lòng nhập mật khẩu." ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <asp:Label ID="ConfirmPasswordLabel" runat="server" AssociatedControlID="ConfirmPassword">Xác nhận mật khẩu:</asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="ConfirmPassword" runat="server" TextMode="Password"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="ConfirmPasswordRequired" runat="server" ControlToValidate="ConfirmPassword" ErrorMessage="Vui lòng xác nhận mật khẩu." ToolTip="Vui lòng xác nhận mật khẩu." ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <asp:Label ID="EmailLabel" runat="server" AssociatedControlID="Email">E-mail:</asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="Email" runat="server"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="EmailRequired" runat="server" ControlToValidate="Email" ErrorMessage="Vui lòng nhập địa chỉ Email." ToolTip="Vui lòng nhập địa chỉ Email." ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <asp:Label ID="QuestionLabel" runat="server" AssociatedControlID="Question">Câu hỏi bảo mật:</asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="Question" runat="server"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="QuestionRequired" runat="server" ControlToValidate="Question" ErrorMessage="Vui lòng nhập câu hỏi bảo mật." ToolTip="Vui lòng nhập câu hỏi bảo mật." ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <asp:Label ID="AnswerLabel" runat="server" AssociatedControlID="Answer">Trả lời:</asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="Answer" runat="server"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="AnswerRequired" runat="server" ControlToValidate="Answer" ErrorMessage="Vui lòng nhập câu trả lời." ToolTip="Vui lòng nhập câu trả lời." ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="center" colspan="2">
                                        <asp:CompareValidator ID="PasswordCompare" runat="server" ControlToCompare="Password" ControlToValidate="ConfirmPassword" Display="Dynamic" ErrorMessage="Mật khẩu xác nhận không trùng khớp. Vui lòng thử lại." ValidationGroup="CreateUserWizard1"></asp:CompareValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="center" colspan="2" style="color:Red;">
                                        <asp:Literal ID="ErrorMessage" runat="server" EnableViewState="False"></asp:Literal>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:CreateUserWizardStep>
                    <asp:CompleteWizardStep ID="CompleteWizardStep1" runat="server">
                        <ContentTemplate>
                            <table>
                                <tr>
                                    <td align="center"><h2>Hoàn Thành</h2></td>
                                </tr>
                                <tr>
                                    <td>Tạo tài khoản thành công! Tài khoản mới đã được tạo.</td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <asp:Button ID="ContinueButton" runat="server" CausesValidation="False" CommandName="Continue" Text="Tiếp tục" ValidationGroup="CreateUserWizard1" CssClass="btn" />
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:CompleteWizardStep>
                </WizardSteps>
            </asp:CreateUserWizard>

            <div class="extra-options">
                <asp:HyperLink ID="ForgotPasswordLink" runat="server" NavigateUrl="~/ForgotPassword.aspx">Quên mật khẩu?</asp:HyperLink>
                <asp:HyperLink ID="LoginLink" runat="server" NavigateUrl="~/Login.aspx">Đăng nhập</asp:HyperLink>
            </div>
        </div>
    </div>
</asp:Content>
