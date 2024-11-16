using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QLBH_RMM
{
    public partial class LienHe : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnSend_Click(object sender, EventArgs e)
        {
            try
            {
                string name = txtName.Text;
                string email = txtEmail.Text;
                string message = txtMessage.Text;

                MailMessage mail = new MailMessage();
                mail.From = new MailAddress("thanhvan972002@gmail.com"); 
                mail.To.Add("2121011855@sv.ufm.edu.vn");
                mail.Subject = $"Liên hệ từ {name}";
                mail.Body = $"Tên: {name}\nEmail: {email}\nTin nhắn: {message}";
                mail.IsBodyHtml = false; 

                SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587); 
                smtp.Credentials = new NetworkCredential("2121011855@sv.ufm.edu.vn", "Ebx56207"); 
                smtp.EnableSsl = true; 

                smtp.Send(mail);

                Response.Write("<script>alert('Gửi tin nhắn thành công!');</script>");

                txtName.Text = string.Empty;
                txtEmail.Text = string.Empty;
                txtMessage.Text = string.Empty;
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Có lỗi xảy ra: " + ex.Message + "');</script>");
            }
        }
    }
    
}