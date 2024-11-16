using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QLBH_RMM
{
    public partial class TrangChu : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void DataList1_ItemCommand(object source, DataListCommandEventArgs e)
        {
            if (e.CommandName == "XemThem")
            {
                string maLoai = DataList1.DataKeys[e.Item.ItemIndex].ToString();
                Response.Redirect($"SanPham.aspx?MaLoai={maLoai}");
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string search = txtTim.Text.Trim();
            srcCuaHang.SelectCommand = $"SELECT * FROM CuaHang WHERE TenCH LIKE N'%{search}%' OR SDT LIKE '%{search}%' OR DiaChi LIKE N'%{search}%'";
        }
        protected void DatNgay(object sender, EventArgs e)
        {
            Response.Redirect("SanPham.aspx");
        }

    }
}