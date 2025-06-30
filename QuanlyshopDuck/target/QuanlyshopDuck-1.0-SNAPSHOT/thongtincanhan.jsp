<%-- 
    Document   : thongtincanhan
    Created on : May 19, 2025, 12:21:54 AM
    Author     : sphie
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="data.giohang"%>
<%@page import="java.util.*" %>
<%@page import="data.khachhang" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>Thông tin khách hàng - ShopDuck</title>
    <style>
         * {
            margin: 0; padding: 0; box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: #f9f9f9;
            color: #333;
            line-height: 1.6;
        }

        header {
            background: #ff6f61;
            color: white;
            padding: 15px 30px;
            position: sticky;
            top: 0;
            z-index: 100;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        header h1 {
            font-size: 1.8rem;
        }

        nav a {
            color: white;
            text-decoration: none;
            margin-left: 25px;
            font-weight: 600;
            transition: color 0.3s ease;
        }

        nav a:hover {
            color: #ffe5e0;
        }

        .container {
            max-width: 700px;
            margin: 40px auto;
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        h2 {
            color: #ff6f61;
            margin-bottom: 20px;
            border-bottom: 2px solid #ff6f61;
            display: inline-block;
            padding-bottom: 5px;
        }

        form label {
            display: block;
            margin-top: 15px;
            font-weight: 600;
        }

        form input, form textarea, form select {
            width: 100%;
            padding: 12px;
            margin-top: 8px;
            border: 1.5px solid #ccc;
            border-radius: 8px;
            transition: border 0.3s ease;
            background-color: white;
        }

        form input:focus, form textarea:focus, form select:focus {
            border-color: #ff6f61;
            outline: none;
        }

        form button {
            margin-top: 25px;
            background: #ff6f61;
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: background 0.3s ease;
        }

        form button:hover {
            background: #e65b4e;
        }

        footer {
            background: #333;
            color: #ddd;
            text-align: center;
            padding: 20px 0;
            font-size: 0.9rem;
            margin-top: 50px;
        }

        /* Styles cho phần hiển thị đơn hàng */
        .order-summary {
            margin-top: 30px;
            margin-bottom: 30px;
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 20px;
            background-color: #fcfcfc;
        }
        .order-summary h3 {
            color: #ff6f61;
            margin-bottom: 15px;
            border-bottom: 1px dashed #ff6f61;
            padding-bottom: 5px;
        }
        .order-summary ul {
            list-style: none;
            padding: 0;
        }
        .order-summary ul li {
            padding: 8px 0;
            border-bottom: 1px dotted #e0e0e0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .order-summary ul li:last-child {
            border-bottom: none;
        }
        .order-summary .item-details {
            font-weight: 500;
        }
        .order-summary .item-quantity {
            font-size: 0.9em;
            color: #777;
        }
        .order-summary .item-subtotal {
            font-weight: bold;
            color: #333;
        }
        .order-summary .total-order-amount {
            margin-top: 20px;
            font-size: 1.2em;
            font-weight: bold;
            text-align: right;
            color: #ff6f61;
        }

        /* Styles for messages */
        .message-success {
            color: #28a745; /* Green */
            font-weight: bold;
            margin-bottom: 15px;
            text-align: center;
        }
        .message-error {
            color: #dc3545; /* Red */
            font-weight: bold;
            margin-bottom: 15px;
            text-align: center;
        }

        /* Styles for saved customer info display */
        .customer-info-display {
            margin-top: 20px;
            padding: 20px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            background-color: #fcfcfc;
            text-align: left;
        }
        .customer-info-display h3 {
            color: #ff6f61;
            margin-bottom: 15px;
            border-bottom: 1px dashed #ff6f61;
            padding-bottom: 5px;
        }
        .customer-info-display p {
            margin-bottom: 8px;
        }
        .customer-info-display strong {
            display: inline-block;
            width: 120px; /* Adjust as needed */
        }


        @media (max-width: 600px) {
            nav a {
                margin-left: 15px;
                font-size: 0.9rem;
            }

            .container {
                padding: 20px;
            }
        }
        /* Existing styles */
        .order-confirmation {
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        .place-order-button {
            background-color: #ff6f61;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1.1em;
            transition: background-color 0.3s ease;
        }
        .place-order-button:hover {
            background-color: #e65b4e;
        }
    </style>
</head>
<body>
    <header>
        <h1>🛍️ ShopDuck</h1>
        <nav>
            <a href="trangchu.jsp">Trang chủ</a>
            <a href="giohang.jsp">Giỏ hàng</a>
            <%
                String tenDangNhap = (String) session.getAttribute("tenDangNhap");
                if (tenDangNhap == null) {
            %>
                <a href="dangnhap.jsp">Đăng nhập</a>
            <%
                } else {
            %>
                <a href="dangxuat.jsp">Đăng xuất</a>
            <%
                }
            %>
            <a href="thongtincanhan.jsp">Khách hàng</a>
        </nav>
    </header>

    <div class="container">
        <h2>Thông tin khách hàng</h2>

        <%-- Check if user is logged in --%>
        <%
            if (tenDangNhap == null) {
        %>
            <p class="message-error">Vui lòng <a href="dangnhap.jsp">đăng nhập</a> để nhập thông tin khách hàng.</p>
        <%
            } else {
        %>

        <%-- Hiển thị thông báo thành công/lỗi từ Servlet --%>
        <% String message = (String) request.getAttribute("message");
           String error = (String) request.getAttribute("error");
           String orderId = request.getAttribute("orderId") != null ? request.getAttribute("orderId").toString() : null;
           if (message != null) { %>
            <p class="message-success"><%= message %></p>
        <% } else if (error != null) { %>
            <p class="message-error"><%= error %></p>
        <% } %>
        <%-- Hiển thị mã đơn hàng nếu có --%>
        <% if (orderId != null) { %>
            <div class="order-confirmation">
                <h3>Đơn hàng của bạn</h3>
                <p><strong>Mã đơn hàng:</strong> <%= orderId %></p>
            </div>
        <% } %>

        <div class="order-summary">
            <h3>Thông tin đơn hàng của bạn</h3>
            <%
                List<giohang> cart = (List<giohang>) session.getAttribute("cart");
                if (cart == null || cart.isEmpty()) {
            %>
                <p>Giỏ hàng trống. Vui lòng quay lại <a href="giohang.jsp">giỏ hàng</a> để thêm sản phẩm.</p>
            <%
                } else {
                    double orderTotal = 0;
            %>
                <ul>
                <%
                    for (giohang item : cart) {
                        double itemSubtotal = item.getPrice() * item.getQuantity();
                        orderTotal += itemSubtotal;
                %>
                    <li>
                        <span class="item-details"><%= item.getProductName() %></span>
                        <span class="item-quantity">x<%= item.getQuantity() %></span>
                        <span class="item-subtotal"><%= String.format("%,.0f", itemSubtotal) %> đ</span>
                    </li>
                <%
                    }
                %>
                </ul>
                <div class="total-order-amount">
                    Tổng cộng đơn hàng: <%= String.format("%,.0f", orderTotal) %> đ
                </div>
                <%-- Lấy thông tin khách hàng từ session --%>
        <% khachhang currentKhachHang = (khachhang) session.getAttribute("currentKhachHang"); %>
                <%-- Add Place Order button --%>
                <% if (currentKhachHang != null) { %>
                    <form action="donhang" method="post">
                        <button type="submit" class="place-order-button">Đặt hàng</button>
                    </form>
                <% } %>
            <%
                }
            %>
        </div>

        <%-- Lấy thông tin khách hàng từ session --%>
        <% khachhang currentKhachHang = (khachhang) session.getAttribute("currentKhachHang"); %>

        <%-- Hiển thị thông tin khách hàng đã lưu --%>
        <% if (currentKhachHang != null) { %>
            <div class="customer-info-display">
                <h3>Thông tin khách hàng đã lưu</h3>
                <p><strong>Họ và tên:</strong> <%= currentKhachHang.getHoVaTen() %></p>
                <p><strong>Email:</strong> <%= currentKhachHang.getEmail() %></p>
                <p><strong>Số điện thoại:</strong> <%= currentKhachHang.getSoDienThoai() %></p>
                <p><strong>Giới tính:</strong> <%= currentKhachHang.getGioiTinh() %></p>
                <p><strong>Ngày sinh:</strong> <%= currentKhachHang.getNgaySinh() != null ? currentKhachHang.getNgaySinh().toString() : "" %></p>
                <p><strong>Địa chỉ:</strong> <%= currentKhachHang.getDiaChi() %></p>
            </div>
            <hr style="margin: 30px 0; border: none; border-top: 1px solid #eee;">
            <h3>Cập nhật thông tin (nếu cần)</h3>
        <% } %>

        <form action="thongtinnguoidung" method="post">
            <label for="name">Họ và tên</label>
            <input type="text" id="name" name="name" required
                   value="<%= currentKhachHang != null ? currentKhachHang.getHoVaTen() : "" %>">

            <label for="email">Email</label>
            <input type="email" id="email" name="email" required
                   value="<%= currentKhachHang != null ? currentKhachHang.getEmail() : "" %>">

            <label for="phone">Số điện thoại</label>
            <input type="tel" id="phone" name="phone" required
                   value="<%= currentKhachHang != null ? currentKhachHang.getSoDienThoai() : "" %>">

            <label for="gender">Giới tính</label>
            <select id="gender" name="gender" required>
                <option value="">-- Chọn giới tính --</option>
                <option value="Nam" <%= (currentKhachHang != null && "Nam".equals(currentKhachHang.getGioiTinh())) ? "selected" : "" %>>Nam</option>
                <option value="Nữ" <%= (currentKhachHang != null && "Nữ".equals(currentKhachHang.getGioiTinh())) ? "selected" : "" %>>Nữ</option>
                <option value="Khác" <%= (currentKhachHang != null && "Khác".equals(currentKhachHang.getGioiTinh())) ? "selected" : "" %>>Khác</option>
            </select>

            <label for="dob">Ngày sinh</label>
            <input type="date" id="dob" name="dob"
                   value="<%= currentKhachHang != null && currentKhachHang.getNgaySinh() != null ? currentKhachHang.getNgaySinh().toString() : "" %>">

            <label for="address">Địa chỉ</label>
            <textarea id="address" name="address" rows="3" required><%= currentKhachHang != null ? currentKhachHang.getDiaChi() : "" %></textarea>

            <button type="submit">Lưu thông tin</button>
        </form>
        <%
            }
        %>
    </div>

    <footer>
        © 2025 ShopDuck. Mọi quyền được bảo lưu.
    </footer>
</body>
</html>