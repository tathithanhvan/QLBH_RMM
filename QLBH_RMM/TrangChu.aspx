<%@ Page Title="Trang Chủ" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true" CodeBehind="TrangChu.aspx.cs" Inherits="QLBH_RMM.TrangChu" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Bố cục chung */
        body {
            font-family: Arial, sans-serif;
            background-color: #f5fff3;
            margin: 0;
            padding: 0;
        }

        /* Banner chính */
        .home-banner {
            text-align: center;
            margin-top: 70px;
        }

        .home-banner img {
            width: 100%;
            height: auto;
        }

        /* Phần sản phẩm nổi bật */
        .products-section {
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
            padding: 20px;
            gap: 20px;
        }

       .product-card-SPNB {
            width: 30%;
            border: 1px solid #ccc;
            padding: 15px;
            margin-bottom: 20px;
            text-align: center;
            height: 250px; 
            background-color: #f9f9f9;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transform: translateY(-5px);
            transition: transform 0.3s ease; 
        }

        .product-card {
            width: 220px; 
            border: 1px solid #ccc;
            padding: 15px;
            margin-bottom: 20px;
            text-align: center;
            background-color: #f9f9f9;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            height: 300px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transform: translateY(-5px);
            transition: transform 0.3s ease; 
        }


        .product-card:hover {
            transform: translateY(-20px);
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.15);
        }

        .product-card img {
            width: 150px;
            height: 150px;
            margin: 0 auto 10px;
            display: block;
        }

        .product-card h3 {
            color: #0A6847;
            font-size: 18px;
            margin-bottom: 10px;
        }

        .product-card p {
            font-size: 16px;
            color: #333;
            margin-bottom: 10px;
        }

        /* Tiêu đề các phần */
        h2 {
            font-size: 28px;
            color: #ffffff;
            background-color: #0A6847; /* Màu nền tiêu đề */
            padding: 5px 10px;
            border-radius: 8px;
            text-align: center;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            margin: 30px 0;
        }

        /* Phần chương trình khuyến mãi */
        .promotion-section {
            display: flex;
            justify-content: center; /* Căn giữa các thẻ */
            flex-wrap: nowrap; /* Không cho phép xuống dòng */
            overflow-x: auto; /* Cho phép cuộn ngang nếu không đủ chỗ */
            gap: 20px; /* Khoảng cách giữa các thẻ */
            margin: 40px 0;
        }


        .promotion-card {
            flex: 1 1 30%; /* Đặt kích thước cho các thẻ để chúng vừa với không gian */
            background-color: #e0f7e4;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            padding: 15px;
            text-align: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            max-width: 450px; /* Giới hạn chiều rộng tối đa của thẻ */

        }
        .promotion-card:hover {
            transform: translateY(-20px);
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.15);
        }

        .promotion-card img {
            width: 80%; /* Giảm kích thước hình ảnh để cân đối với thẻ */
            height: auto;
            border-radius: 10px;
            margin-bottom: 15px; /* Khoảng cách nhỏ hơn giữa ảnh và nội dung */
        }

        .promotion-card h3 {
            font-size: 20px; /* Giảm kích thước chữ */
            color: #0A6847;
            margin-bottom: 10px;
        }

        .promotion-card p {
            font-size: 14px; /* Giảm kích thước mô tả */
            color: #333;
            margin-bottom: 15px; /* Cân chỉnh khoảng cách giữa mô tả và nút */
        }

        .promo-button {
            background-color: #0A6847;
            color: #fff;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            font-size: 14px; /* Giảm kích thước nút */
            cursor: pointer;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: background-color 0.3s ease;
        }

        .promo-button:hover {
            background-color: #0e805a;

        }
/* Phần tìm kiếm cửa hàng */
        .search-bar {
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 40px 0; /* Thêm khoảng cách phía trên và dưới */
        }

        .search-bar input {
            padding: 10px;
            border-radius: 5px 0 0 5px;
            border: 1px solid #ccc;
            font-size: 16px; /* Kích thước chữ */
        }

        .search-bar button {
            margin-left: 10px;
            background-color: #F6E9B2;
            padding: 5px 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px; /* Kích thước chữ */
            transition: background-color 0.3s ease;

        }

        .search-bar button:hover {
            background-color: #0e805a; /* Màu nền khi hover */
        }
                .store-card {
            border: 1px solid #ccc; 
            border-radius: 5px; 
            padding: 15px; 
            margin-bottom: 15px; 
            background-color: #f9f9f9;
        }

        .store-card h4 {
            margin: 0;
        }
               /* Phần thông tin hệ thống */
        .info-section {
            display: flex;
            justify-content: space-around;
            margin: 30px 0;
        }

        .info-box {
            background-color: rgb(60, 143, 75);
            color: white;
            padding: 30px;
            border-radius: 16px;
            text-align: center;
            width: 40%;
        }

        .info-box h4 {
            font-size: 48px; /* Kích thước chữ lớn hơn */
            margin: 0;
        }

        .info-box p {
            font-size: 20px; /* Kích thước chữ lớn hơn */
        }
               /* Thông tin bổ sung */
        .additional-info {
            display: flex;
            justify-content: space-around;
            margin: 10px 0;
            font-size: 16px;
            color: #333;
            text-align: center;
        }

        .info-column {
            flex: 1;
            margin: 0 2px;
            font-weight: bold; /* Chữ in đậm */
        }

        .info-icon {
            width: 36px; /* Kích thước icon */
            height: 36px;
            margin-right: 8px; /* Khoảng cách giữa icon và chữ */
            vertical-align: middle; /* Căn giữa icon với chữ */
        }
    </style>
    <style type="text/css">
        .scrollable-container {
            max-height: 400px; /* Chiều cao tối đa cho vùng cuộn */
            overflow-y: auto; /* Bật cuộn dọc */
            padding: 10px; /* Khoảng cách bên trong */
            background-color: #f5fff3;
        }
    </style>


</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="home-banner">
        <asp:Image ID="Image1" runat="server" ImageUrl="~/Images/6.png" />
    </div>

    <div class="additional-info">
        <div class="info-column">
            <p>
                <asp:Image ID="Image14" runat="server" CssClass="info-icon" ImageUrl="~/Images/ic1.png" />
                100% Rau Má Tươi Nguyên Chất</p>
        </div>
        <div class="info-column">
            <p>
                <asp:Image ID="Image15" runat="server" CssClass="info-icon" ImageUrl="~/Images/ic2.png" />
                Đạt chuẩn HACCP, ATTP</p>
        </div>
        <div class="info-column">
            <p>
                <asp:Image ID="Image16" runat="server" CssClass="info-icon" ImageUrl="~/Images/ic3.png" />
                Hoàn toàn tự nhiên, tốt cho sức khoẻ</p>
        </div>
    </div>
    <div class="additional-info">
        <p>Chào mừng bạn đến với cửa hàng nước Rau Má lớn nhất Việt Nam với hơn 60 cửa hàng tại TP.HCM và Bình Dương.</p>
    </div>
    <div class="info-section">
        <div class="info-box">
            <h4><asp:Label ID="lblFoundedYear" runat="server" Text="5"></asp:Label></h4>
            <p>Năm thành lập</p>
        </div>
        <div class="info-box">
            <h4><asp:Label ID="lblStoreCount" runat="server" Text="60"></asp:Label></h4>
            <p>Cửa hàng tại HCM &amp; Bình Dương</p>
        </div>
    </div>

    <h2>MENU</h2>
    <asp:SqlDataSource ID="srcLoaiSP" runat="server" ConnectionString="<%$ ConnectionStrings:QuanLyBanHang_SP_ConnectionString %>" SelectCommand="SELECT * FROM LoaiSP WHERE MaLoai &lt;&gt; 'GC';"></asp:SqlDataSource>
        <asp:DataList ID="DataList1" runat="server" DataSourceID="srcLoaiSP" 
            CellPadding="10" CellSpacing="20" HorizontalAlign="Center" 
            RepeatColumns="5" RepeatDirection="Horizontal" DataKeyField="MaLoai" 
            OnItemCommand="DataList1_ItemCommand">
            <ItemTemplate>
                <div class="product-card">
                    <asp:Image ID="Image1" runat="server" ImageUrl='<%# Eval("Img") %>' Width="200px" Height="180px" ImageAlign="Middle" />
                    <h3><%# Eval("TenLoai") %></h3>
                    <asp:Button ID="btnViewMore" runat="server" Text="Xem Thêm" CommandName="XemThem" CssClass="promo-button" />
                </div>
            </ItemTemplate>
        </asp:DataList>


    <h2>CHƯƠNG TRÌNH KHUYẾN MÃI</h2>
        <div class="promotion-section">
            <div class="promotion-card">
                <asp:Image ID="Image10" runat="server" ImageUrl="~/Images/km_dc15.png" />
                <h3>Giảm 15% cho Đơn hàng lớn</h3>
                <p>Đơn hàng trị giá trên 1.500.000đ: - GIẢM NGAY 15%</p>
                <asp:Button ID="btnDatNgay1" runat="server" Text="Đặt Ngay" CssClass="promo-button" OnClick="DatNgay" />
            </div>

            <div class="promotion-card">
                <asp:Image ID="Image11" runat="server" ImageUrl="~/Images/b2g1.png" />
                <h3>Mua 2 Tặng 1</h3>
                <p>Khuyến mãi đặc biệt khi mua 2 ly bất kỳ, tặng ngay 1 Bánh Tráng Mix miễn phí.</p>
                <asp:Button ID="btnDatNgay2" runat="server" Text="Đặt Ngay" CssClass="promo-button" OnClick="DatNgay" />
            </div>

            <div class="promotion-card">
                <asp:Image ID="Image12" runat="server" ImageUrl="~/Images/Tp.png" />
                <h3>Tặng 1 phần Topping</h3>
                <p>TẶNG MIỄN PHÍ 1 PHẦN TOPPING BẤT KỲ cho đơn chỉ từ 50K.</p>
                <asp:Button ID="btnDatNgay3" runat="server" Text="Đặt Ngay" CssClass="promo-button" OnClick="DatNgay" />
            </div>

            <div class="promotion-card">
                <asp:Image ID="Image13" runat="server" ImageUrl="~/Images/km_rmsd.png" />
                <h3>Tặng Rau Má Sữa Dừa</h3>
                <p>Tặng Rau Má Sữa Dừa khi...</p>
                <asp:Button ID="btnDatNgay4" runat="server" Text="Đặt Ngay" CssClass="promo-button" OnClick="DatNgay" />
            </div>
        </div>

    <h2 style="text-align: center;">HỆ THỐNG CỬA HÀNG</h2>

    <div class="search-bar" style="text-align: center; margin-bottom: 20px;">
        <asp:TextBox ID="txtTim" runat="server" placeholder="Tìm kiếm cửa hàng..." style="width: 300px; padding: 10px;"></asp:TextBox>
        <asp:Button ID="btnTim" runat="server" Text="Tìm kiếm" OnClick="btnSearch_Click" style="padding: 10px 20px; margin-left: 10px;" />
    </div>
    <asp:SqlDataSource ID="srcCuaHang" runat="server" ConnectionString="<%$ ConnectionStrings:QuanLyBanHang_SP_ConnectionString %>" SelectCommand="SELECT * FROM [CuaHang]"></asp:SqlDataSource>
    
    <div class="scrollable-container">
        <asp:DataList ID="DataList2" runat="server" DataKeyField="MaCH" DataSourceID="srcCuaHang" CellSpacing="10" HorizontalAlign="Center" RepeatColumns="2">
             <ItemTemplate>
                    <div style="border: 1px solid #ccc; border-radius: 5px; padding: 15px; margin-bottom: 15px; background-color: #f9f9f9;">
                        <h4 style="margin: 0;">Cửa hàng: <asp:Label ID="TenCHLabel" runat="server" Text='<%# Eval("TenCH") %>' /></h4>
                        <p><strong>Địa chỉ:</strong> <asp:Label ID="DiaChiLabel" runat="server" Text='<%# Eval("DiaChi") %>' /></p>
                        <p><strong>SĐT:</strong> <asp:Label ID="SDTLabel" runat="server" Text='<%# Eval("SDT") %>' /></p>
                    </div>
                </ItemTemplate>
        </asp:DataList>
    </div>
        <script>
            // Hàm để chạy hiệu ứng đếm số
            function animateNumber(element, target, duration) {
                let start = 0;
                const stepTime = Math.ceil(duration / target);
        
                const timer = setInterval(() => {
                    start += 1;
                    element.innerText = start;
                    if (start === target) {
                        clearInterval(timer);
                    }
                }, stepTime);
            }

            window.onload = function() {
                // Gọi hàm khi trang đã tải xong
                const foundedYearElement = document.getElementById('<%= lblFoundedYear.ClientID %>');
                const storeCountElement = document.getElementById('<%= lblStoreCount.ClientID %>');

                // Số năm thành lập và số cửa hàng
                const foundedYear = 5; // Thay thế bằng dữ liệu thực tế
                const storeCount = 60;  // Thay thế bằng dữ liệu thực tế

                // Khởi động hiệu ứng đếm
                animateNumber(foundedYearElement, foundedYear, 2000); // Thời gian 2000ms
                animateNumber(storeCountElement, storeCount, 2000); // Thời gian 2000ms
            };
        </script>


</asp:Content>
