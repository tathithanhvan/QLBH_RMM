<%@ Page Title="Admin Rau Má Mix" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="QLBH_RMM.Admin.Home" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .dashboard {
            margin-top: 100px;
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            padding: 20px;
            background-color: #f9f9f9;
            min-height: calc(100vh - 120px);
        }

        .dashboard-card {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            padding: 20px;
            flex: 1 1 30%;
            text-align: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

        .dashboard-card h3 {
            margin-bottom: 10px;
            font-size: 24px;
            color: #0A6847;
        }

        .dashboard-card p {
            font-size: 18px;
            color: #666;
        }

        .dashboard-card a {
            display: inline-block;
            margin-top: 10px;
            text-decoration: none;
            color: #007B5F;
            font-weight: bold;
            font-size: 16px;
            transition: color 0.3s;
        }

        .dashboard-card a:hover {
            color: #005b4a;
        }

        .statistic {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .statistic-item {
            flex: 1 1 24%;
            background-color: #007B5F;
            color: white;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
        }

        .statistic-item h4 {
            margin: 0;
            font-size: 28px;
        }

        .statistic-item span {
            font-size: 18px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="dashboard">
        <!-- Thống kê nhanh -->
        <div class="statistic">
            <div class="statistic-item">
                <h4 id="lblNewOrders">0</h4>
                <span>Đơn hàng mới</span>
            </div>
            <div class="statistic-item">
                <h4 id="lblTotalProducts">0</h4>
                <span>Sản phẩm</span>
            </div>
            <div class="statistic-item">
                <h4 id="lblNewUsers">0</h4>
                <span>Người dùng mới</span>
            </div>
            <div class="statistic-item">
                <h4 id="lblCompletionRate">0%</h4>
                <span>Tỉ lệ hoàn thành đơn hàng</span>
            </div>
        </div>
        <!-- Các thẻ quản lý -->
        <div class="dashboard-card">
            <h3>Quản lý đơn hàng</h3>
            <p>Xem, cập nhật và quản lý đơn hàng của khách hàng</p>
            <a href="/Admin/ManageOrders.aspx">Xem chi tiết</a>
        </div>

        <div class="dashboard-card">
            <h3>Quản lý sản phẩm</h3>
            <p>Thêm mới, cập nhật và xóa sản phẩm trong hệ thống</p>
            <a href="/Admin/ManageProducts.aspx">Xem chi tiết</a>
        </div>
        <div class="dashboard-card">
            <h3>Quản lý khuyến mãi</h3>
            <p>Thêm mới, cập nhật và xóa khuyến mãi trong hệ thống</p>
            <a href="/Admin/ManagePromotions.aspx">Xem chi tiết</a>
        </div>

        <div class="dashboard-card">
            <h3>Quản lý người dùng</h3>
            <p>Kiểm soát và quản lý thông tin người dùng</p>
            <a href="/Admin/ManageUsers.aspx">Xem chi tiết</a>
        </div>

        <div class="dashboard-card">
            <h3>Báo cáo</h3>
            <p>Truy cập và xem các báo cáo doanh thu, số liệu</p>
            <a href="/Admin/Reports.aspx">Xem chi tiết</a>
        </div>

        <div class="dashboard-card">
            <h3>Cài đặt</h3>
            <p>Tùy chỉnh các cấu hình và thiết lập hệ thống</p>
            <a href="/Admin/Settings.aspx">Xem chi tiết</a>
        </div>
    </div>

    <!-- Include jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script>
        // Function to animate numbers counting up
        function animateCounter(elementId, startValue, endValue, duration) {
            $({ countNum: startValue }).animate({ countNum: endValue }, {
                duration: duration,
                easing: 'linear',
                step: function () {
                    // Update the element with the current value
                    $(elementId).text(Math.floor(this.countNum));
                },
                complete: function () {
                    // Set the final value (in case of rounding issues)
                    $(elementId).text(endValue);
                }
            });
        }

        // Call this function after data is loaded
        function startAnimation(newOrders, totalProducts, newUsers, completionRate) {
            animateCounter("#lblNewOrders", 0, newOrders, 2000); // 2 seconds animation
            animateCounter("#lblTotalProducts", 0, totalProducts, 2000);
            animateCounter("#lblNewUsers", 0, newUsers, 2000);
            animateCounter("#lblCompletionRate", 0, completionRate, 2000); // completion rate
        }
    </script>
</asp:Content>
