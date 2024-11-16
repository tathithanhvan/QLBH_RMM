using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QLBH_RMM
{
    public partial class HeThongCuaHang : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string search = txtTim.Text.Trim();

            srcCuaHang.SelectCommand = $"SELECT * FROM CuaHang WHERE TenCH LIKE N'%{search}%' OR SDT LIKE '%{search}%' OR DiaChi LIKE N'%{search}%'";

        }
    }
}